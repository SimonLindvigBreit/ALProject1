namespace EDK.API.Master.Data;

using Microsoft.eServices.EDocument;
using System.Reflection;
using Microsoft.Foundation.Reporting;
using System.IO;
using Microsoft.Finance.Currency;
using System.Automation;
using System.Threading;

table 83500 "EDK Inbox"
{
    Caption = 'EDK Inbox';
    DataCaptionFields = "Entry No", "Ship-to Name";
    LookupPageId = "EDK InboxList";
    DrillDownPageId = "EDK InboxList";
    DataClassification = CustomerContent;
    DataPerCompany = false;

    Permissions = tabledata "EDK Inbox" = RIMD;

    fields
    {
        field(1; "Entry No"; Integer)
        {
            Caption = 'Document Entry No';
            AutoIncrement = true;
        }
        // field(2; "Document Record ID"; RecordId)
        // {
        //     Caption = 'Document Record ID';
        //     DataClassification = SystemMetadata;
        // }
        field(3; "Ship-to Name"; Text[100])
        {
            Caption = 'Sell-to/Invoice-to No.';
        }
        field(4; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Sell-to/Invoice-to Name';
            // Editable = false;
        }
        field(5; "Ship-to Address"; Text[100])
        {
            Caption = 'Sell-to/Invoice-to Name';
            // Editable = false;
        }
        field(6; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Sell-to/Invoice-to Name';
            // Editable = false;
        }
        field(7; "Ship-to City"; Text[30])
        {
            Caption = 'Sell-to/Invoice-to Name';
            // Editable = false;
        }
        field(8; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Sell-to/Invoice-to Name';
            // Editable = false;
        }
        field(9; "Ship-to County/Region"; Code[10])
        {
            Caption = 'Sell-to/Invoice-to Name';
            // Editable = false;
        }
        field(10; "Ship-to Phone No."; Text[50])
        {
            Caption = 'Sell-to/Invoice-to Name';
            // Editable = false;
        }
        field(11; "Ship-to Contact"; Text[100])
        {
            Caption = 'Sell-to/Invoice-to Name';
            // Editable = false;
        }
        field(12; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            // Editable = false;
        }
        field(13; "Document Type"; Enum "E-Document Type")
        {
            Caption = 'Document Type';
            // Editable = false;
        }
        field(14; "Document id"; guid)
        {
            Caption = 'Document id';
            // Editable = false;
        }
        // field(14; "Document Date"; Date)
        // {
        //     Caption = 'Document Date';
        //     Editable = false;
        // }
        // field(15; "Due Date"; Date)
        // {
        //     Caption = 'Due Date';
        //     Editable = false;
        // }
        // field(16; "Amount Incl. VAT"; Decimal)
        // {
        //     AutoFormatExpression = Rec."Currency Code";
        //     AutoFormatType = 1;
        //     Caption = 'Amount Including VAT';
        //     Editable = false;
        // }
        // field(17; "Amount Excl. VAT"; Decimal)
        // {
        //     AutoFormatExpression = Rec."Currency Code";
        //     AutoFormatType = 1;
        //     Caption = 'Amount Excluding VAT';
        //     Editable = false;
        // }
        // field(18; "Index In Batch"; Integer)
        // {
        //     Caption = 'Index In Batch';
        //     Editable = false;
        // }
        field(19; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            // Editable = false;
        }
        // field(14; Direction; Enum "E-Document Direction")
        // {
        //     Caption = 'Direction';
        //     Editable = false;
        // }
        // field(15; "Incoming E-Document No."; Text[50])
        // {
        //     Caption = 'Incoming E-Document No.';
        //     Editable = false;
        // }
        // field(16; "Table ID"; Integer)
        // {
        //     Caption = 'Table ID';
        //     Editable = false;
        //     DataClassification = SystemMetadata;
        // }
        // field(17; "Table Name"; Text[250])
        // {
        //     CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = const(Table), "Object ID" = field("Table ID")));
        //     Caption = 'Document Table Name';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(18; Status; Boolean)
        {
            Caption = 'Status';
            ToolTip = 'Specifies if the document is processed.';
        }
        // field(19; "Document Sending Profile"; Code[20])
        // {
        //     Caption = 'Document Sending Profile';
        //     TableRelation = "Document Sending Profile";
        // }
        // field(20; "Source Type"; enum "E-Document Source Type")
        // {
        //     Caption = 'Source Type';
        // }
        // field(21; "Data Exch. Def. Code"; Code[20])
        // {
        //     TableRelation = "Data Exch. Def";
        //     Caption = 'Data Exch. Def. Code';
        // }
        // field(22; "Receiving Company VAT Reg. No."; Text[20])
        // {
        //     Caption = 'Receiving Company VAT Reg. No.';
        // }
        // field(23; "Receiving Company GLN"; Code[13])
        // {
        //     Caption = 'Receiving Company GLN';
        //     Numeric = true;
        // }
        // field(24; "Receiving Company Name"; Text[150])
        // {
        //     Caption = 'Receiving Company Name';
        // }
        // field(25; "Receiving Company Address"; Text[200])
        // {
        //     Caption = 'Receiving Company Address';
        // }
        // field(26; "Currency Code"; Code[10])
        // {
        //     Caption = 'Currency Code';
        //     Editable = false;
        //     TableRelation = Currency;
        // }
        // field(27; "Workflow Code"; Code[20])
        // {
        //     TableRelation = Workflow where(Template = const(false), Category = const('EDOC'));
        //     Caption = 'Workflow Code';
        // }
        // field(28; "Workflow Step Instance ID"; Guid)
        // {
        //     DataClassification = SystemMetadata;
        // }
        // field(29; "Job Queue Entry ID"; Guid)
        // {
        //     TableRelation = "Job Queue Entry";
        //     DataClassification = SystemMetadata;
        // }
        // field(30; "Journal Line System ID"; Guid)
        // {
        //     DataClassification = SystemMetadata;
        // }
        field(83100; "Created By BU Code"; Code[20])
        {
            Caption = 'Created By BU Code';
            NotBlank = true;
        }
        field(83101; "Send To BU Code"; Code[20])
        {
            Caption = 'Send To BU Code';
            NotBlank = true;
        }
    }
    keys
    {
        key(Key1; "Entry No")
        {
            Clustered = true;
        }
        key(Key2; "Document ID")
        {
        }
        key(Key3; "Created By BU Code")
        {
        }
        key(Key4; "Send To BU Code")
        {
        }
    }
}
