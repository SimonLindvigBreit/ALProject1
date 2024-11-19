namespace EDK.API.Master.Data;

using Microsoft.Sales.Document;
using EDK.API.Base.Setup;
using Microsoft.Sales.Customer;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.NoSeries;
using Microsoft.Sales.Setup;

codeunit 83500 "EDK Create Sales Order"
{
    procedure CreateSalesOrder(pInbox: Record "EDK Inbox")
    var
        lsalesOrder: Record "Sales Header";
        lAPISetup: Record "EDK API Setup";
        lCustomer: Record "Customer";
        lSalesAndReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeries: Codeunit "No. Series";
        NextNumber: Code[20];
        lSalesPage: Page "Sales Order";
    begin
        if pInbox.Status <> false then
            Error('The E-Document is already processed.');

        lAPISetup.Get();
        if pInbox."Send To BU Code" <> lAPISetup."Business Unit Code" then
            Error('The Business Unit Code in the Inbox does not match the Business Unit Code in the API Setup.');

        lCustomer.SetRange("EDK_Bu_Code", pInbox."Created By BU Code");
        if lCustomer.IsEmpty() then
            Error('The Customer with the Business Unit Code %1 does not exist.', pInbox."Created By BU Code");

        if lCustomer.FindFirst() then begin

            lsalesOrder.Init();
            lSalesAndReceivablesSetup.Get();

            NextNumber := NoSeries.GetNextNo(lSalesAndReceivablesSetup."Order Nos.");

            lsalesOrder."No." := NextNumber;
            lsalesOrder."Document Type" := lsalesOrder."Document Type"::Order;

            lsalesOrder.Validate("Sell-to Customer Name", lCustomer.Name);
            lSalesOrder.Validate("Ship-to Name", pInbox."Ship-to Name");
            lSalesOrder.Validate("Ship-to Name 2", pInbox."Ship-to Name 2");
            lSalesOrder.Validate("Ship-to Address", pInbox."Ship-to Address");
            lSalesOrder.Validate("Ship-to Address 2", pInbox."Ship-to Address 2");
            lSalesOrder.Validate("Ship-to City", pInbox."Ship-to City");
            lSalesOrder.Validate("Ship-to Post Code", pInbox."Ship-to Post Code");
            lsalesOrder.Validate("Ship-to Country/Region Code", pInbox."Ship-to County/Region");
            lsalesOrder.Validate("Ship-to Phone No.", pInbox."Ship-to Phone No.");
            lsalesOrder.Validate("Ship-to Contact", pInbox."Ship-to Contact");

            lsalesOrder.Insert();

            InsertSalesLine(lsalesOrder, pInbox);

            pInbox."Order No." := lsalesOrder."No.";
            pInbox.Status := true;
            pInbox.Modify();

            Page.run(Page::"Sales Order", lsalesOrder);
        end;
    end;

    local procedure InsertSalesLine(lsalesOrder: Record "Sales Header"; pInbox: Record "EDK Inbox")
    var
        lImportetLines: Record "EDK Inbox Importet Line";
        lSalesLine: Record "Sales Line";
        lItem: Record "Item";
    begin


        lImportetLines.SetRange("E-Document Entry No.", pInbox."Entry No");
        if lImportetLines.IsEmpty() then
            Error('No lines found for the E-Document Entry No. %1.', pInbox."Entry No");

        lImportetLines.FindSet();
        repeat
            lItem.SetRange(SystemId, lImportetLines."Master Item System ID");
            if lItem.IsEmpty() then
                Error('The Item with the Master Item System ID %1 does not exist.', lImportetLines."Master Item System ID");

        until lImportetLines.Next() = 0;

        lImportetLines.FindSet();
        repeat
            lItem.SetRange(SystemId, lImportetLines."Master Item System ID");
            lItem.FindFirst();

            lSalesLine.Init();
            lSalesLine."Document Type" := lSalesLine."Document Type"::Order;
            lSalesLine."Document No." := lsalesOrder."No.";

            lSalesLine.Validate(Type, lSalesLine.Type::Item);
            lSalesLine.Validate("No.", lItem."No.");
            lSalesLine.Validate("Quantity", lImportetLines.Quantity);
            lSalesLine.Validate("Line Discount %", lImportetLines."Line Discount %");
            lSalesLine.Validate("Unit Cost", lImportetLines."Direct Unit Cost");

            lSalesLine.Insert();

        until lImportetLines.Next() = 0;
    end;
}
