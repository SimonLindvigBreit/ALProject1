namespace EDK.API.Master.Data;

using Microsoft.Sales.Customer;

tableextension 83502 Customer extends Customer
{
    fields
    {
        field(83100; EDK_Bu_Code; Code[20])
        {
            Caption = 'EDK_Bu_Code';
            DataClassification = CustomerContent;
            TableRelation = "EDK InterCompany Mapping";
        }
    }
}
