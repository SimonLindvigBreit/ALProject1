namespace EDK.API.Master.Data;

codeunit 83502 "EDK_EnumHandling"
{

    procedure GetEnumValueAsString(FieldRefVar: FieldRef): Text
    begin
        exit(FieldRefVar.GetEnumValueNameFromOrdinalValue(FieldRefVar.Value()));
    end;
}