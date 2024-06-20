/// <summary>
/// TableExtension PostedWhseShipmentLine (ID 50218) extends Record Posted Whse. Shipment line //7323.
/// </summary>
tableextension 50218 PostedWhseShipmentLine extends "Posted Whse. Shipment line" //7323
{
    fields
    {
        // Add changes to table fields here
        field(50400; "Cod. temporada"; Code[20])
        {
            Description = 'EX-SGG-WMS 190619';
            DataClassification = ToBeClassified;
            Caption = 'Season code', comment = 'ESP="Cód. temporada"';
        }
    }
}