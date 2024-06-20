pageextension 50230 ConsultaPedidosClienteWMS extends ConsultaPedidosCliente //50025
{
    layout
    {
        addafter("Amt. Ship. Not Inv. (LCY)")
        {
            field(Cantidad; cantidadPedido)
            {
                Caption = 'Quantity', comment = 'ESP="Cantidad"';
                ToolTip = 'Specifies the value of the cantidadPedido field.';
            }
            field(Servido; cantidadServida)
            {
                BlankZero = true;
                ToolTip = 'Specifies the value of the cantidadServida field.';
                Caption = 'Service', comment = 'ESP="Servido"';
            }
            field(Reserva; CantReserva)
            {
                ToolTip = 'Specifies the value of the CantReserva field.';
                Caption = 'Reserv', comment = 'ESP="Reserva"';
            }
            field(Pendiente; PteAnul)
            {
                ToolTip = 'Specifies the value of the PteAnul field.';
                Caption = 'Pending', comment = 'ESP="Pendiente"';
            }
            field(Anulado; cantidadAnulada)
            {
                ToolTip = 'Specifies the value of the cantidadAnulada field.';
                Caption = 'Anuled', comment = 'ESP="Anulado"';
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        cantidadPedido := 0;
        cantidadServida := 0;
        cantidadAsignada := 0;
        cantidadPendiente := 0;
        cantidadAnulada := 0;

        pSalesLine.RESET;
        pSalesLine.SETCURRENTKEY(
        "Document Type", "PfsHorz Component Group", "Document No.", Type, "No.",
        "PfsVertical Component", "PfsHorizontal Component", "Shipment Date");
        pSalesLine.SETRANGE(pSalesLine."Document Type", Rec."Document Type");
        pSalesLine.SETRANGE(pSalesLine."Document No.", rec."No.");
        pSalesLine.SETRANGE(pSalesLine.Type, pSalesLine.Type::Item);
        IF pSalesLine.FINDSET THEN
            REPEAT
                cantidadPedido += pSalesLine.Quantity;
                cantidadServida += pSalesLine."Quantity Shipped";
                cantidadAsignada += pSalesLine."Qty. Assigned";
                //cantidadPendiente += pSalesLine."Outstanding Quantity";
                cantidadAnulada += pSalesLine."Cantidad Anulada";
            UNTIL pSalesLine.NEXT = 0;

        // // Picking := 0;
        // // RecLinResPicking.RESET;
        // // RecLinResPicking.SETRANGE("Pedido No.", "No.");
        // // RecLinResPicking.SETRANGE(Pendiente, TRUE);
        // // IF RecLinResPicking.FINDFIRST THEN
        // //     REPEAT
        // //         Picking += RecLinResPicking.Cantidad - RecLinResPicking."Cantidad Enviada";
        // //     UNTIL RecLinResPicking.NEXT = 0;

        CantReserva := 0;
        regMovimientosdeReserva.RESET;
        regMovimientosdeReserva.SETRANGE("Origen Documento No.", rec."No.");
        IF regMovimientosdeReserva.FINDFIRST THEN
            REPEAT
                CantReserva += regMovimientosdeReserva."Cantidad Reservada";
            UNTIL regMovimientosdeReserva.NEXT = 0;

        //EX-SGG-WMS 190719 
        RstLinEnvAlm.SETRANGE("Source No.", rec."No.");
        RstLinEnvAlm.SETRANGE("Estado cabecera", RstLinEnvAlm."Estado cabecera"::Open);
        RstLinEnvAlm.CALCSUMS(Quantity);
        CantEnvAlmAbiertos := RstLinEnvAlm.Quantity;
        RstLinEnvAlm.SETRANGE("Estado cabecera", RstLinEnvAlm."Estado cabecera"::Released);
        RstLinEnvAlm.CALCSUMS(Quantity);
        CantEnvAlmLanzados := RstLinEnvAlm.Quantity;
        //FIN EX-SGG-WMS 190719

        //cantidadPendiente := cantidadPedido - cantidadServida - cantidadAnulada - CantReserva;
        cantidadPendiente := cantidadPedido - cantidadServida - Picking - cantidadAnulada - CantReserva - CantEnvAlmLanzados;
        PteAnul := cantidadPendiente;

        CustFilter := rec."Sell-to Customer No.";


        ComPrioritario := '';
        ComentRec.RESET;
        ComentRec.SETRANGE("Table Name", ComentRec."Table Name"::Customer);
        ComentRec.SETRANGE("No.", rec."Sell-to Customer No.");
        IF ComentRec.FINDFIRST THEN
            ComPrioritario := ComentRec.Comment;
    end;


    var
        RstLinEnvAlm: Record "Warehouse Shipment Line";
        TempFilter: Text[250];
        CustFilter: Text[250];
        nombreTemp: Text[30];
        pDim: Record "Dimension Value";
        pCustomer: Record "Customer";
        CUFunc: Codeunit "Funciones";
        pSalesLine: Record "Sales Line";
        cantidadPedido: Integer;
        cantidadServida: Integer;
        cantidadAsignada: Integer;
        cantidadPendiente: Integer;
        cantidadAnulada: Integer;
        detalleTallas: Boolean;
        pEstCli: Record CustomerStatus;
        ImpPedido: Decimal;
        Block: Boolean;
        RiesgoDisp: Decimal;
        ComPrioritario: Text[80];
        ComentRec: Record "Comment Line";
        PteAnul: Integer;
        Picking: Integer;
        //  RecLinResPicking: Record "Picking Líneas Resumen";
        regMovimientosdeReserva: Record "MovimientosdeReserva";
        CantReserva: Integer;
        // RstLinEnvAlm: Record "Warehouse Shipment Line WMS";
        CantEnvAlmAbiertos: Integer;
        CantEnvAlmLanzados: Integer;
}
