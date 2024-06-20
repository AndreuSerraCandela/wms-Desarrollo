/// <summary>
/// TableExtension SetupTallasyColores (ID 50204) extends Record SetupTallas //96109.
/// </summary>
tableextension 50204 SetupTallasyColores extends SetupTallas //96109
{
    fields
    {
        field(84; "Warehouse Shipment Posting"; Enum WareHouseShipmentPosting)
        {
            DataClassification = ToBeClassified;
            Caption = 'Warehouse Shipment Posting', comment = 'ESP="Contabilización de envíos de almacén"';
        }
        field(85; "Warehouse Shipment Priority"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Warehouse Shipment Priority', comment = 'ESP="Prioridad de envío de almacén"';
        }
    }
}