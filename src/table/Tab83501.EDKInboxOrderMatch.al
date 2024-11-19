namespace EDK.API.Master.Data;

using Microsoft.Sales.Document;

table 83501 "EDK Inbox Order Match"
{
    Caption = 'EDKInboxOrderMatch';

    DataClassification = CustomerContent;
    Access = Internal;

    fields
    {
        field(1; "Document Order No."; Code[20])
        {
            Caption = 'Document Order No.';
            TableRelation = "Sales Header"."No." where("Document Type" = const(Order));
        }
        field(2; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
            TableRelation = "Sales Line"."Line No." where("Document Type" = const(Order), "Document No." = field("Document Order No."));
        }
        field(3; "E-Document Entry No."; Integer)
        {
            Caption = 'E-Document Entry No.';
            TableRelation = "EDK Inbox";
        }
        field(4; "E-Document Line No."; Integer)
        {
            Caption = 'E-Document Imported Line No.';
            TableRelation = "EDK Inbox Importet Line"."Line No." where("E-Document Entry No." = field("E-Document Entry No."));
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
#pragma warning disable AS0005, AS0125
        field(6; "E-Document Direct Unit Cost"; Decimal)
        {
            Caption = 'E-Document Unit Cost';
        }
        field(7; "PO Direct Unit Cost"; Decimal)
        {
            Caption = 'Purchase Order Unit Cost';
        }
        field(8; "Line Discount %"; Decimal)
        {
            Caption = 'Discount %';
        }
        field(9; "Unit of Measure Code"; Code[20])
        {
            Caption = 'Unit of Measure';
        }
        field(10; "E-Document Description"; Text[100])
        {
            Caption = 'E-Document Description';
        }
        field(11; "PO Description"; Text[100])
        {
            Caption = 'Purchase Order Description';
        }
        field(12; "Fully Matched"; Boolean)
        {
            Caption = 'Fully Matched';
        }
        field(13; "Matched Quantity"; Integer)
        {
            Caption = 'Matched Quantity';
        }
        field(83121; "Created By BU Code"; Code[20])
        {
            Caption = 'Created By BU Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
#pragma warning restore AS0005, AS0125
    }

    keys
    {
        key(Key1; "Document Order No.", "Document Line No.", "E-Document Entry No.", "E-Document Line No.")
        {
            Clustered = true;
        }
        key(Key2; "E-Document Entry No.", "E-Document Line No.", "Document Order No.")
        {
            SumIndexFields = Quantity;
        }
    }
}
