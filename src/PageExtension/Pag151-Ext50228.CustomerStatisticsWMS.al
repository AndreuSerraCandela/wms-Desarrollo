pageextension 50228 CustomerStatisticsWMS extends "Customer Statistics" //151
{


    layout
    {
        //   group(cd)
        //             {
        //                 field("Outstanding balance"; ImpFactPte)
        //                 {
        //                     Caption = 'Outstanding balance"', comment = 'ESP="Saldo Pendiente"';
        //                 }
        //             }

        //  group("Consignment Sale")
        //     {
        //         Caption = 'Consignment Sale', comment = 'ESP="Venta en consignación"';

        //         group(m)
        //         {
        //  field("Order in transit"; ImpPedTransitoConsig)
        //             {
        //                 Caption = 'Order in transit"', comment = 'ESP="Ped en tránsito"';
        //             }
        //       }
        //    field("Warehouse shipments launched"; ImpEnviosLanzadosConsig)
        //             {
        //                 Caption = 'Warehouse shipments launched"', comment = 'ESP="Envíos almacén lanzados"';
        //             }

        //  field("Open warehouse shipments"; ImpEnviosSinLanzarConsig)
        //             {
        //                 Caption = 'Open warehouse shipments"', comment = 'ESP="Envíos almacén abiertos"';
        //             }


    }
    trigger OnAfterGetRecord()
    var
        CostCalcMgt: Codeunit "Cost Calculation Management";
        RecLinVta: Record "Sales Line";
        lRecConsignmentCondition: Record "ConsignmentCondition";
        CduFunciones: Codeunit Funciones;

    begin

        //EX-SGG-WMS 100719
        CLEAR(CduFunciones);
        //new
        ImpRiesgoFinancieroDispNew := CduFunciones.RiesgoCliente(rec."No.");
        //new end
        DevuelveVariablesRiesgoCliente(OpenRemainingAmtLCY, Impagados, SaldoMigracion, ImpPicking, ImpReserva, FactPte, ImpAlb,
         ImpAnul, ImpPedPte, ImpagRemRech, ImpagRem, FactPteImpag, ImpEnviosLanzados, ImpEnviosSinLanzar);
        TotalAmountLCY := rec."Balance (LCY)" + ImpPedPte + ImpAlb + rec."Outstanding Invoices (LCY)" - ImpAnul;
        //FIN EX-SGG-WMS 100719

        //EX-CV
        ImpAvalConsignacion := 0;
        lRecConsignmentCondition.RESET;
        lRecConsignmentCondition.SETRANGE("Customer No.", rec."No.");
        lRecConsignmentCondition.SETRANGE("Register Type", lRecConsignmentCondition."Register Type"::Consignment);
        lRecConsignmentCondition.SETRANGE("Value Type", lRecConsignmentCondition."Value Type"::Aval);
        IF lRecConsignmentCondition.FINDFIRST THEN;
        ImpAvalConsignacion := lRecConsignmentCondition.Value;

        // CduFunciones.GetDataAvalConsignacion(ImpPedPteConsig, ImpAnulConsig, ImpPedTransferPdtServirConsig,
        //                                      ImpEnviosLanzadosConsig, ImpEnviosSinLanzarConsig, ImpPedTransitoConsig,
        //                                      ImpStockConsig, ImpFactPteConsig, ImpFactPteImpagConsig,
        //                                      ImpEfecPendConsig, ImpEfecPendRemesasConsig, ImpEfectPendRemesasRegConsig,
        //                                      ImpagRemRechConsig);
        // CduFunciones.getImpagadosConsig(ImpagadosConsig);

        //EX-CV
        Customer.RESET();
        Customer.SETRANGE("No.", REC."No.");
        IF Customer.FINDFIRST THEN;

        //EX-CV 3348 MEP 2022 01 13 START
        ///   CalcStadisticsFields();
        //3348 MEP 2022 01 13 END

        //Importe riesgo financiero Pendiente

        //EX-CV 3348 MEP 2022 01 13 START
        ImpRiesgoFinancieroConsig := ImpFactPteConsig +
                                     (ImpStockConsig + ImpPedTransitoConsig +
                                      ImpEnviosLanzadosConsig + ImpEnviosSinLanzarConsig);
        //3348 MEP 2022 01 13 START


        //Importe riesgo financiero

        //EX-CV 3348 MEP 2022 01 13 START
        ImpRiesgoFinanciero := ImpFactPte + (ImpAlb + ImpPicking + ImpReserva + ImpEnviosLanzados);

        ImpFactPteConsig := ImpFactPteConsig - ImpagadosConsig;//;ImpagRemRechConsig;
                                                               //3348 MEP 2022 01 13 END


        //New
        //ImpRiesgoFinancieroDispNew := CduFunciones.RiesgoCliente("No.");
        //New end

        CLEAR(ImpDeudaVencida);
        MovCli.RESET();
        MovCli.SETRANGE("Customer No.", REC."No.");
        MovCli.SETRANGE(Open, TRUE);
        MovCli.SETRANGE("Ventas en consignacion", FALSE);
        MovCli.SETFILTER("Due Date", '<%1', WORKDATE);

        IF MovCli.FINDFIRST THEN
            REPEAT
                MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                ImpDeudaVencida := ImpDeudaVencida + MovCli."Remaining Amt. (LCY)";
            UNTIL MovCli.NEXT = 0;

        CLEAR(ImpDeudaVencidaConsig);
        MovCli.RESET();
        MovCli.SETRANGE("Customer No.", Rec."No.");
        MovCli.SETRANGE(Open, TRUE);
        MovCli.SETRANGE("Ventas en consignacion", TRUE);
        MovCli.SETFILTER("Due Date", '<%1', WORKDATE);

        IF MovCli.FINDFIRST THEN
            REPEAT
                MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                ImpDeudaVencidaConsig := ImpDeudaVencidaConsig + MovCli."Remaining Amt. (LCY)";
            UNTIL MovCli.NEXT = 0;

        //EX-CV END

        //EX-CV 3348 MEP 2022 01 13 START
        //se cambio el uso de las variables viejas por las nuevas
        //las cuales se calculan mediante CustLedgerEntry."remaining Amt. (LCY)"
        IF OpenRemainingAmtLCY[1] > 0 THEN
            OpenRemainingAmtLCY[1] -= ImpEfecPendConsig;

        IF OpenRemainingAmtLCY[2] > 0 THEN
            OpenRemainingAmtLCY[2] -= ImpEfecPendRemesasConsig;

        IF OpenRemainingAmtLCY[3] > 0 THEN
            OpenRemainingAmtLCY[3] -= ImpEfectPendRemesasRegConsig;

        //3348 MEP 2022 01 13 END

        //EX-CV END
    end;

    procedure DevuelveVariablesRiesgoCliente(var lOpenRemainingAmtLCY: array[5] of Decimal; var lImpagados: Decimal; var lSaldoMigracion: Decimal; var lImpPicking: Decimal; var lImpReserva: Decimal; var lFactPte: Decimal; var lImpAlb: Decimal; var lImpAnul: Decimal; var lImpPedPte: Decimal; var lImpagRemRech: Decimal; var lImpagRem: array[5] of Decimal; var lFactPteImpag: Decimal; var lImpEnviosLanzados: Decimal; var lImpEnviosSinLanzar: Decimal)
    var
        li: Integer;

    begin
        //EX-SGG-WMS 100719
        FOR li := 1 TO ARRAYLEN(OpenRemainingAmtLCY) DO
            lOpenRemainingAmtLCY[li] := OpenRemainingAmtLCY[li];
        lImpagados := Impagados;
        lSaldoMigracion := SaldoMigracion;
        lImpPicking := ImpPicking;
        lImpReserva := ImpReserva;
        lFactPte := FactPte;
        lImpAlb := ImpAlb;
        lImpAnul := ImpAnul;
        lImpPedPte := ImpPedPte;
        lImpagRemRech := ImpagRemRech;
        FOR li := 1 TO ARRAYLEN(ImpagRem) DO
            lImpagRem[li] := ImpagRem[li];
        lFactPteImpag := FactPteImpag;
        lImpEnviosLanzados := ImpEnviosLanzados;
        lImpEnviosSinLanzar := ImpEnviosSinLanzar;
    end;



    var
        ImpEnviosLanzadosConsig: Decimal;
        MovCli: Record "Cust. Ledger Entry";
        ImpEnviosSinLanzarConsig: Decimal;
        ImpStockConsig: Decimal;
        ImpPedTransitoConsig: Decimal;

        ImpFactPteConsig: Decimal;
        ImpFactPte: Decimal;

        TotalAmountLCY: Decimal;
        Customer: Record Customer;
        ImpDeudaVencidaConsig: Decimal;
        ImpDeudaVencida: Decimal;
        ImpRiesgoFinanciero: Decimal;
        ImpRiesgoFinancieroDispNew: Decimal;
        Impagados: Decimal;
        SaldoMigracion: Decimal;
        ImpPicking: Decimal;
        ImpReserva: Decimal;
        FactPte: Decimal;
        ImpAlb: Decimal;
        ImpAnul: Decimal;
        ImpPedPte: Decimal;
        ImpagRemRech: Decimal;
        ImpagRem: array[5] of Decimal;
        FactPteImpag: Decimal;
        CalcularRiesgoCliSinAlbaranes: Boolean;
        ImpEnviosLanzados: Decimal;
        ImpEnviosSinLanzar: Decimal;
        ImpEfecPendConsig: Decimal;
        ImpEfecPendRemesasConsig: Decimal;
        ImpEfectPendRemesasRegConsig: Decimal;
        ImpagRemRechConsig: Decimal;
        ImpRiesgoFinancieroConsig: Decimal;
        ImpAvalConsignacion: Decimal;
        ImpagadosConsig: Decimal;
}
