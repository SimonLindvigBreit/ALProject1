namespace EDK.API.Master.Data;

using Microsoft.Sales.Document;

table 83502 "EDK Inbox Importet Line"
{
    Caption = 'EDK Inbox Importet Line';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "E-Document Entry No."; Integer)
        {
            Caption = 'E-Document Entry No.';
            TableRelation = "EDK Inbox";
            // Editable = false;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            // Editable = false;
        }
        field(3; Type; Enum "Sales Line Type")
        {
            Caption = 'Type';
            // Editable = false;
        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            // Editable = false;
        }
        field(5; "Unit Of Measure Code"; Code[20])
        {
            Caption = 'Unit Of Measure';
            // Editable = false;
        }
#pragma warning disable AS0004
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            // Editable = false;
        }
        field(7; "Matched Quantity"; Decimal)
        {
            Caption = 'Matched Quantity';
            DecimalPlaces = 0 : 5;
            // Editable = false;

            trigger OnValidate()
            begin
                if ("Matched Quantity" > Quantity) or ("Matched Quantity" < 0) then
                    Error(MatchedQtyErr);

                Validate("Fully Matched");
            end;
        }
#pragma warning restore AS0004
        field(8; "Fully Matched"; Boolean)
        {
            Caption = 'Fully Matched';
            // Editable = false;

            trigger OnValidate()
            begin
                "Fully Matched" := "Matched Quantity" = Quantity;
            end;
        }
        field(9; "Direct Unit Cost"; Decimal)
        {
            Caption = 'Direct Unit Cost';
            // Editable = false;
        }
        field(10; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
            // Editable = false;
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(11; "Master Item No."; Code[20])
        {
            Caption = 'No.';
        }
        field(12; "Master Item System ID"; Guid)
        {
            Caption = 'Master Item System ID';
        }
    }

    keys
    {
        key(Key1;
        "E-Document Entry No.", "Line No.")
        {
            Clustered = true;
        }
    }
    var
        MatchedQtyErr: Label 'The Matched Quantity should not exceed Quantity and cannot be less than zero.';
}

