tableextension 50230 ItemWMS extends Item //27
{
    fields
    {
        field(50033; "Qty Purch. Return Order"; Decimal)
        {

            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Receipt Line".Quantity WHERE("Item No." = FIELD("No."), "Location Code" = FIELD("Location Filter"), "Variant Code" = FIELD("Variant Filter"), "Bin Code" = FIELD("Bin Filter"), "Due Date" = field("Date Filter")));
            // "PfsVertical Component" = FIELD()));//,"PfsHorizontal Component"=field(Filtro),"Due Date"=field("Date Filter")));           

        }
        field(50034; "Qty Shipment Sales"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Shipment Line".Quantity WHERE("Item No." = FIELD("No."), "Location Code" = FIELD("Location Filter"), "Variant Code" = FIELD("Variant Filter"), "Bin Code" = FIELD("Bin Filter"), "Due Date" = field("Date Filter")));
            //"PfsVertical Component"=FIELD("Filtro Color")));//,PfsHorizontal Component=FIELD(Filtro Talla),PfsPrepack Code=FIELD(Filtro Preembalado),Shipment Date=FIELD(Date Filter)))


        }

    }
}
