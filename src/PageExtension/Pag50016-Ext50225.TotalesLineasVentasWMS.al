pageextension 50225 TotalesLineasVentasWMS extends TotalesLineasVentas3 //50016
{
    layout
    {
        addlast(Control2)
        {
            field("Pendientes"; Rec."Pares pedidos" - Rec."Pares anulados" - Rec."Pares servidos" - Rec."Envios lanzados" - Rec."Envios sin lanzar" - Rec."Pedidos transferencia" - Rec."Cantidad en consignacion")
            {
                ApplicationArea = SalesReturnOrder;
                Caption = 'Pendientes', comment = 'ESP="Pendientes"';
            }
            field("EnviosSinlanzar"; Rec."Envios sin lanzar")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Envios sin lanzar', comment = 'ESP="Envios sin lanzar"';
                DrillDownPageID = "Whse. Shipment Lines";
            }
            field("EnviosLanzados"; Rec."Envios lanzados")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Envios lanzados', comment = 'ESP="Envios lanzados"';
                DrillDownPageID = "Whse. Shipment Lines";
            }
        }

    }
}
