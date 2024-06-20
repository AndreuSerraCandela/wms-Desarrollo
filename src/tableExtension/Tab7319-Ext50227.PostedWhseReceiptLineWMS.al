tableextension 50227 PostedWhseReceiptLineWMS extends "Posted Whse. Receipt Line" //7319
{
    fields
    {
        field(50300; "Cod. temporada"; Code[20])
        {
            Description = 'EX-SGG-WMS 190619';
            Caption = 'Season code', comment = 'ESP="Cód. temporada"';
            DataClassification = ToBeClassified;
        }
        field(50400; "No. albaran proveedor"; Code[20])
        {
            Caption = '';
            DataClassification = ToBeClassified;
        }
    }
}
