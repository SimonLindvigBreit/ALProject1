namespace ALProject.ALProject;

using EDK.API.Base.Setup;
using Microsoft.Purchases.Document;
using Microsoft.Inventory.Item;
using EDK.API.Master.Data;
using Microsoft.Intercompany.Setup;

codeunit 83501 POInboxAPIFunctions
{
    procedure fAPISendPurchaseOrder(pPurchaseHeader: Record "Purchase Header"; pSendToBuCode: code[20]; pHideDialog: Boolean) rOK: Boolean
    var
        lFrameWork: Record "EDK API Framework";
        lInbox: Record "EDK Inbox";
        lAPIBC2BCConnector: Codeunit "EDK API BC2BC Connector";
        lAPIFunctions: Codeunit "EDK API Functions";
        lApiStrAndBase64Functions: codeunit "EDK API StrAndBase64Functions";
        //lAPIDebugFunctions: Codeunit "EDK API Debug Functions";
        lJsonBody: JsonObject;
        lParameter: Text;
        lJsonArray: JsonArray;
        lRequestBodyText: Text;
        lEntityName: Text;
        lResponseTxt: text;
        lCurrentLanguage: Integer;
        lUseSchemaVersion1: Boolean;
        lSync: Boolean;
        lUpdate: Boolean;
        lParameterSchemaTok: Label '?$schemaversion=1.0', Locked = true;
        //lParameterPostTok: Label 'masteritems(%1)?$schemaversion=1.0', Locked = true;
        lParameterPostTok: Label 'inbox/', Locked = true;
        //lParameterPatchTok: Label 'masteritems(%1)?$schemaversion=1.0', Locked = true;
        lParameterPatchTok: Label 'inbox(%1)', Locked = true;

    begin
        GetSetup();
        lCurrentLanguage := GlobalLanguage;
        GlobalLanguage(1033);

        lFrameWork."REST Method" := lFrameWork."REST Method"::Post;
        lEntityName := lParameterPostTok;

        lUseSchemaVersion1 := false;
        if lUseSchemaVersion1 then
            lEntityName := lEntityName + lParameterSchemaTok;

        lPopulateJsonBody(pPurchaseHeader, lJsonBody, gAPISetup, pSendToBuCode);
        lPopulateJsonBodyWithPurchaseLine(pPurchaseHeader, lJsonBody, gAPISetup);

        lJsonBody.WriteTo(lRequestBodyText);

        lResponseTxt := lAPIBC2BCConnector.ConnectToBCSaas(lFrameWork, lEntityName, '', lRequestBodyText, '', pHideDialog);

        GlobalLanguage(lCurrentLanguage);

        rOK := true;
        exit(rOK);
    end;


    local procedure lPopulateJsonBody(pPurchaseHeader: Record "Purchase Header"; var pJsonBody: Jsonobject; var pAPISetup: Record "EDK API Setup"; var pBuCode: Code[20])
    var
        lInbox: Record "EDK Inbox";
        lApiStrAndBase64Functions: codeunit "EDK API StrAndBase64Functions";
        EnumHandling: Codeunit "EDK_EnumHandling";
        FieldRefVar: FieldRef;
        RecRefVar: RecordRef;
    begin
        pJsonBody.Add('createdByBuCode', lApiStrAndBase64Functions.UrlEncode(pAPISetup."Business Unit Code"));
        pJsonBody.Add('sendToBuCode', lApiStrAndBase64Functions.UrlEncode(pBuCode));
        pJsonBody.Add('documentNo', lApiStrAndBase64Functions.UrlEncode(pPurchaseHeader."No."));
        // if pPurchaseHeader."Document Type" = pPurchaseHeader."Document Type"::Order then begin
        //     RecRefVar.GetTable(pPurchaseHeader);
        //     FieldRefVar := RecRefVar.Field(pPurchaseHeader.FieldNo("Document Type"));
        //     pJsonBody.Add('documentType', EnumHandling.GetEnumValueAsString(FieldRefVar));
        // end;
        pJsonBody.Add('shipToName', lApiStrAndBase64Functions.UrlEncode(pPurchaseHeader."Ship-to Name"));
        pJsonBody.Add('shipToName2', lApiStrAndBase64Functions.UrlEncode(pPurchaseHeader."Ship-to Name 2"));
        pJsonBody.Add('shipToAddress', lApiStrAndBase64Functions.UrlEncode(pPurchaseHeader."Ship-to Address"));
        pJsonBody.Add('shipToAddress2', lApiStrAndBase64Functions.UrlEncode(pPurchaseHeader."Ship-to Address 2"));
        pJsonBody.Add('shipToCity', lApiStrAndBase64Functions.UrlEncode(pPurchaseHeader."Ship-to City"));
        pJsonBody.Add('shipToPostCode', lApiStrAndBase64Functions.UrlEncode(pPurchaseHeader."Ship-to Post Code"));
        pJsonBody.Add('shipToCountyRegion', lApiStrAndBase64Functions.UrlEncode(pPurchaseHeader."Ship-to Country/Region Code"));
        pJsonBody.Add('shipToPhoneNo', lApiStrAndBase64Functions.UrlEncode(pPurchaseHeader."Ship-to Phone No."));
        pJsonBody.Add('shipToContact', lApiStrAndBase64Functions.UrlEncode(pPurchaseHeader."Ship-to Contact"));
    end;

    local procedure lPopulateJsonBodyWithPurchaseLine(pPurchaseHeader: Record "Purchase Header"; var lJsonBody: JsonObject; gAPISetup: Record "EDK API Setup")
    var
        lPurchaseLine: Record "Purchase Line";
        pJsonArray: JsonArray;
        lJsonBody2: JsonObject;
    begin
        lPurchaseLine.SetRange("Document No.", pPurchaseHeader."No.");
        lPurchaseLine.SetRange("Document Type", pPurchaseHeader."Document Type");
        if lPurchaseLine.FindSet() then begin
            Clear(pJsonArray);

            GenerateJsonLine(lPurchaseLine, lJsonBody2);
            pJsonArray.Add(lJsonBody2);
        end;
        lJsonBody.Add('inboxImportetLine', pJsonArray);
    end;

    local procedure GenerateJsonLine(pPurchaseLine: Record "Purchase Line"; var pJsonBody: JsonObject)
    var
        lItem: Record "Item";
        lApiStrAndBase64Functions: codeunit "EDK API StrAndBase64Functions";
    begin
        lItem.Get(pPurchaseLine."No.");

        // pJsonBody.Add('eDocEntryNo', lApiStrAndBase64Functions.UrlEncode(pPurchaseLine."Document No."));
        pJsonBody.Add('lineNo', lApiStrAndBase64Functions.UrlEncode(format(pPurchaseLine."Line No.")));
        pJsonBody.Add('masterItemNo', lApiStrAndBase64Functions.UrlEncode(lItem."No."));
        pJsonBody.Add('masterItemSystemID', lItem.SystemId);
        pJsonBody.Add('description', lApiStrAndBase64Functions.UrlEncode(pPurchaseLine.Description));
        pJsonBody.Add('quantity', pPurchaseLine.Quantity);
        pJsonBody.Add('unitOfMeasureCode', lApiStrAndBase64Functions.UrlEncode(pPurchaseLine."Unit of Measure"));
        pJsonBody.Add('directUnitCost', pPurchaseLine."Direct Unit Cost");
        pJsonBody.Add('lineDiscount', pPurchaseLine."Line Discount %");
    end;

    procedure GetSetup();
    begin
        if SetupInitialized then
            exit;

        gAPISetup.get();
        gAPISetup.testfield(Active);
        gAPISetup.testfield("Business Unit Code");

        gICSetup.get();
        gICSetup.testfield("IC Partner Code");

        SetupInitialized := true;
    end;

    var
        gICSetup: record "IC Setup";
        gAPISetup: Record "EDK API Setup";
        // gMDSetup: Record "EDK Master Item Setup";
        // gMasterItemFunctions: Codeunit "EDK Master Item Env Functions";
        SetupInitialized: Boolean;
}
