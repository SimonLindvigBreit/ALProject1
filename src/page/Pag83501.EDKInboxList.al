namespace EDK.API.Master.Data;

page 83501 "EDK InboxList"
{
    Caption = 'EDK E-DocumentInbox List';
    ApplicationArea = Basic, Suite;
    SourceTable = "EDK Inbox";
    // CardPageId = "EDKE-DocumentInbox";
    PageType = List;
    UsageCategory = Lists;
    AdditionalSearchTerms = 'EDK,Edoc,Electronic Document';
    RefreshOnActivate = true;
    Editable = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTableView = sorting("Entry No") order(descending);

    layout
    {
        area(Content)
        {
            repeater(DocumentList)
            {
                ShowCaption = false;
                field("Entry No"; Rec."Entry No")
                {
                    ToolTip = 'Specifies the entry number.';
                }
                field(Sender; Rec."Created By BU Code")
                {
                    ToolTip = 'Specifies the sender of the electronic document.';
                }
                field(Receiver; Rec."Send To BU Code")
                {
                    ToolTip = 'Specifies the receiver of the electronic document.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ToolTip = 'Specifies the order number of the reciever.';
                }
                // field("Document Type"; Rec."Document Type")
                // {
                //     ToolTip = 'Specifies the document type of the electronic document.';
                // }
                // field("Document No."; Rec."Document No.")
                // {
                //     ToolTip = 'Specifies the document number of the electronic document.';
                // }
                // field("Document Date"; Rec."Document Date")
                // {
                //     ToolTip = 'Specifies the document date.';
                // }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the status of the electronic document.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(EDK)
            {
                Caption = 'Create Sales Order';
                action(CreateSalesOrder)
                {
                    ApplicationArea = Basic, Suite;
                    Image = SalesOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create a sales order from the selected electronic document.';

                    trigger OnAction()
                    var
                        CraeteSalesOrder: Codeunit "EDK Create Sales Order";
                    begin
                        CraeteSalesOrder.CreateSalesOrder(Rec);
                    end;
                }
            }
        }
    }
}
