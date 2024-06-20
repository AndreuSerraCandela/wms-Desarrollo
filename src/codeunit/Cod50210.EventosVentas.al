codeunit 50210 "Eventos_Ventas"
{


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", OnAfterCopyFromItem, '', false, false)]
    local procedure SetOnAfterCopyFromItem(var SalesLine: Record "Sales Line"; Item: Record Item)
    begin
        // if Item."Producto SEGA" then
        SalesLine."Location Code" := CduWMS.DevuelveAlmacenPredetSEGA();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Funciones Excelia", 'OnBeforeProcesarPedidosMag', '', false, false)]
    local procedure OnBeforeProcesarPedidosMag(var SalesHeader: Record "Sales Header")
    begin

        SalesHeader.Validate("Tipo de entrega", '2');

    end;

    procedure EsLineaAsignacionDirecta(lNombreTabla: Text[30]; lNoDoc: Code[20]; lNoLinDoc: Integer): Boolean
    var
        RstAsignacionDirecta: Record "Asignaciones Vtas-Compras";
        RstLinEnvAlm: Record "Warehouse Shipment Line";
        RstLinRecepAlm: Record "Warehouse Receipt Line";
    begin
        //EX-SGG-WMS 291119
        RstAsignacionDirecta.RESET;
        RstAsignacionDirecta.SETRANGE("Tipo Asignación", RstAsignacionDirecta."Tipo Asignación"::Directa);
        CASE lNombreTabla OF
            RstLinEnvAlm.TABLENAME:
                BEGIN
                    RstAsignacionDirecta.SETRANGE("Nº Pedido Venta", lNoDoc);
                    RstAsignacionDirecta.SETRANGE("Nº Linea Pedido Venta", lNoLinDoc);
                END;
            RstLinRecepAlm.TABLENAME:
                BEGIN
                    RstAsignacionDirecta.SETRANGE("Nº Pedido Compra", lNoDoc);
                    RstAsignacionDirecta.SETRANGE("Nº Linea Pedido Compra", lNoLinDoc);
                END;
        END;
        EXIT(RstAsignacionDirecta.FINDFIRST);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues(var SalesLine: Record "Sales Line"; Item: Record Item; SalesHeader: Record "Sales Header"; var xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    var
        //TODO
        // CduWMS: codeunit 50003;
        GLSetup: Record "General Ledger Setup";
        RecDimValue: Record "Dimension Value";
        LabelName: Label 'Season %1 not valid', comment = 'ESP="Temporada %1 no vigente"';
    begin
        IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) then begin
            // AND (NOT SalesHeader."Pedido Magento") THEN BEGIN

            GLSetup.GET();
            RecDimValue.RESET();
            RecDimValue.SETRANGE("Dimension Code", GLSetup."Global Dimension 1 Code");
            RecDimValue.SETRANGE(Code, Item."Global Dimension 1 Code");
            IF RecDimValue.FINDFIRST() THEN
                IF RecDimValue.Blocked THEN
                    ERROR('Temporada %1 no vigente', Item."Global Dimension 1 Code");
        END;

        SalesLine."Cod Unidad Medida Base" := Item."Base Unit of Measure";

        IF Item."Producto SEGA" THEN;
        //TODO
        // SalesLine."Location Code" := CduWMS.DevuelveAlmacenPredetSEGA();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnCopyFromItemOnAfterCheck', '', false, false)]
    local procedure OnCopyFromItemOnAfterCheck(var SalesLine: Record "Sales Line"; Item: Record Item)
    begin
        SalesLine."Producto SEGA" := Item."Producto SEGA";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeCopyShipToCustomerAddressFieldsFromShipToAddr', '', false, false)]
    local procedure OnBeforeCopyShipToCustomerAddressFieldsFromShipToAddr(var SalesHeader: Record "Sales Header"; var ShipToAddress: Record "Ship-to Address"; var IsHandled: Boolean)
    begin
        IF SalesHeader."Ventas en consignacion" THEN SalesHeader.NoModificarPedidoEnviado; //NM-CSA-20220207 (antes sin IF)
        IF (ShipToAddress."Cod. almacen consignacion" = '') AND (SalesHeader."Ventas en consignacion") THEN
            ERROR('Indique un almacén de consignación ya que estáen un pedido en Consignación');
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeCopySellToCustomerAddressFieldsFromCustomer', '', false, false)]
    local procedure OnBeforeCopySellToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; Customer: Record Customer; var IsHandled: Boolean)
    begin
        //  SalesHeader."Envio a Mail" := Customer."Envio a Mail";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeCopyFromItem', '', false, false)]
    local procedure OnBeforeCopyFromItem(var SalesLine: Record "Sales Line"; Item: Record Item; var IsHandled: Boolean)
    VAR
        CduWMS: Codeunit FuncionesWMS;
    begin

        //EX-SGG-WMS 020919

        IF Item."Producto SEGA" THEN
            SalesLine."Location Code" := CduWMS.DevuelveAlmacenPredetSEGA;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeUpdateOutboundWhseHandlingTime', '', false, false)]
    local procedure OnBeforeUpdateOutboundWhseHandlingTime(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        Location: Record Location;
    begin
        IF SalesHeader."Ventas en consignacion" AND (SalesHeader."Location Code" <> '') THEN
            Location.TestField("Cod. cliente", SalesHeader."Sell-to Customer No.");

    end;

    /*
    [IntegrationEvent(false, false)]
        local procedure OnBeforeUpdateOutboundWhseHandlingTime(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
        begin
        end;
    */

    procedure RiesgoCliente(CodCliente: Code[20]): Decimal
    var
        ClienteRec: Record 18;
        CurrentDate: Date;
        ValueEntry: Record 5802;
        DateFilterCalc: Codeunit 358;
        CustDateFilter: array[4] of Text[30];
        CustDateName: array[4] of Text[30];
        TotalAmountLCY: Decimal;
        i: Integer;
        CostCalcMgt: Codeunit 5836;
        CustSalesLCY: array[4] of Decimal;
        AdjmtCostLCY: array[4] of Decimal;
        CustProfit: array[4] of Decimal;
        ProfitPct: array[4] of Decimal;
        AdjCustProfit: array[4] of Decimal;
        AdjProfitPct: array[4] of Decimal;
        CustInvDiscAmountLCY: array[4] of Decimal;
        CustPaymentDiscLCY: array[4] of Decimal;
        CustPaymentDiscTolLCY: array[4] of Decimal;
        CustPaymentTolLCY: array[4] of Decimal;
        CustReminderChargeAmtLCY: array[4] of Decimal;
        CustFinChargeAmtLCY: array[4] of Decimal;
        CustCrMemoAmountsLCY: array[4] of Decimal;
        CustPaymentsLCY: array[4] of Decimal;
        CustRefundsLCY: array[4] of Decimal;
        CustOtherAmountsLCY: array[4] of Decimal;
        InvAmountsLCY: array[4] of Decimal;
        MovCli: Record "Cust. Ledger Entry";
        SaldoClientes: Record FamiliaProducto;
        CantPicking: Integer;
        RecLinPedido: Record "Sales Line";
        FactorCant: Decimal;
        MovReserva: Record 50012;
        RecPedido: Record "Sales Header";
        RecPedido2: Record "Sales Header";
        RecLinVta: Record 37;
        "--EX-LV-SGG": Integer;
        lRstLinEnvAlm: Record "Warehouse Shipment Line";
        lImpAux: Decimal;
        lRecTransferHeader: Record 5740;
        lRecTransferLine: Record 5741;
        lRecSalesHeader: Record "Sales Header";
        lRecLocation: Record 14;
        lRecItemLedEntry: Record 32;
        lRecItem: Record 27;
        lQtyPerUnitMeasurement: Decimal;
        lcuUOMMgt: Codeunit 5402;
        recTransferLine: Record 5741;
        TransferHeader: Record 5740;
        lPedConsig: Boolean;
        lRstHeadEnvAlm: Record "Warehouse Shipment Header";
        lRecCustomer: Record 18;
        CustLedgerEntry: Record 21;
        ImpFactPte: Decimal;
        SaldoMigracion: Decimal;
        CalcularRiesgoCliSinAlbaranes: Boolean;
    begin

        SaldoMigracion := 0;
        ClienteRec.RESET;
        ClienteRec.GET(CodCliente); //EX-SGG-WMS 100719

        IF CurrentDate <> WORKDATE THEN BEGIN
            CurrentDate := WORKDATE;
        END;

        //EX-SGG-WMS 090719 CODIGO DE FORMULARIO ESTADISTICAS CLIENTE.
        ImpAnul := 0;
        ImpPedPte := 0;
        ImpAlb := 0;
        FactorCant := 0;
        //EX-CV
        CLEAR(ImpPedPteConsig);
        CLEAR(ImpAnulConsig);
        CLEAR(ImpPedTransferPdtServirConsig);
        CLEAR(ImpEnviosLanzadosConsig);
        CLEAR(ImpEnviosSinLanzarConsig);
        CLEAR(ImpPedTransitoConsig);
        CLEAR(ImpStockConsig);
        CLEAR(ImpFactPteConsig);
        CLEAR(ImpFactPteImpagConsig);
        CLEAR(ImpEfecPendConsig);
        CLEAR(ImpEfecPendRemesasConsig);
        CLEAR(ImpEfectPendRemesasRegConsig);
        CLEAR(ImpagRemRechConsig);
        CLEAR(ImpagadosConsig);
        //EX-CV END

        RecLinVta.RESET;
        RecLinVta.SETCURRENTKEY("Document Type", "Sell-to Customer No.",
        "Outstanding Quantity", "Document No.", "Fecha servicio solicitada");
        RecLinVta.SETRANGE("Document Type", RecLinVta."Document Type"::Order);
        RecLinVta.SETRANGE("Sell-to Customer No.", ClienteRec."No.");
        IF RecLinVta.FINDFIRST THEN
            REPEAT

                IF RecLinVta.Quantity <> 0 THEN
                    FactorCant := RecLinVta."Cantidad Anulada" / RecLinVta.Quantity
                ELSE
                    FactorCant := 0;

                //EX-JFC 14/11/14 Calcular el importe en EUROS
                RecPedido.RESET;
                RecPedido.SETRANGE(RecPedido."No.", RecLinVta."Document No.");
                IF RecPedido.FINDFIRST THEN BEGIN
                    //EX-CV
                    IF RecPedido."Currency Code" = '' THEN BEGIN
                        IF NOT RecPedido."Ventas en consignacion" THEN BEGIN
                            ImpAnul += (RecLinVta."Cantidad Anulada" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);
                        END ELSE BEGIN
                            ImpAnulConsig += (RecLinVta."Cantidad Anulada" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);
                        END;
                    END ELSE BEGIN
                        Currency.InitRoundingPrecision;
                        IF NOT RecPedido."Ventas en consignacion" THEN BEGIN
                            ImpAnul += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                            RecPedido."Posting Date", RecPedido."Currency Code",
                            ((RecLinVta."Cantidad Anulada" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100)),
                            RecPedido."Currency Factor"),
                            Currency."Amount Rounding Precision");
                        END ELSE BEGIN
                            ImpAnulConsig += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                            RecPedido."Posting Date", RecPedido."Currency Code",
                            ((RecLinVta."Cantidad Anulada" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100)),
                            RecPedido."Currency Factor"),
                            Currency."Amount Rounding Precision");
                        END;
                    END;
                    //EX-CV END
                END;
                //EX-JFC 14/11/14 Calcular el importe en EUROS


                IF RecLinVta.Quantity <> 0 THEN
                    FactorCant := RecLinVta."Outstanding Quantity" / RecLinVta.Quantity
                ELSE
                    FactorCant := 0;

                //EX-JFC 14/11/14 Calcular el importe en EUROS
                RecPedido.RESET;
                RecPedido.SETRANGE(RecPedido."No.", RecLinVta."Document No.");
                IF RecPedido.FINDFIRST THEN BEGIN
                    //EX-CV
                    IF RecPedido."Currency Code" = '' THEN BEGIN
                        IF NOT RecPedido."Ventas en consignacion" THEN BEGIN
                            ImpPedPte += (RecLinVta."Outstanding Quantity" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);
                        END ELSE BEGIN
                            ImpPedPteConsig += (RecLinVta."Outstanding Quantity" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);
                        END;
                    END ELSE BEGIN
                        Currency.InitRoundingPrecision;
                        IF NOT RecPedido."Ventas en consignacion" THEN BEGIN
                            ImpPedPte += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                            RecPedido."Posting Date", RecPedido."Currency Code",
                            ((RecLinVta."Outstanding Quantity" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100)),
                            RecPedido."Currency Factor"),
                            Currency."Amount Rounding Precision");
                        END ELSE BEGIN
                            ImpPedPteConsig += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                            RecPedido."Posting Date", RecPedido."Currency Code",
                            ((RecLinVta."Outstanding Quantity" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100)),
                            RecPedido."Currency Factor"),
                            Currency."Amount Rounding Precision");
                        END;
                    END;
                    //EX-CV END
                END;
                //EX-JFC 14/11/14 Calcular el importe en EUROS

                IF NOT CalcularRiesgoCliSinAlbaranes THEN //EX-SGG-WMS 090719
                 BEGIN
                    IF RecLinVta.Quantity <> 0 THEN
                        FactorCant := RecLinVta."Qty. Shipped Not Invoiced" / RecLinVta.Quantity
                    ELSE
                        FactorCant := 0;
                    //modificado por practicas2
                    CLEAR(RecPedido2);
                    RecPedido2.RESET;
                    RecPedido2.SETRANGE(RecPedido2."Document Type", RecPedido2."Document Type"::Order);
                    RecPedido2.SETRANGE(RecPedido2."No.", RecLinVta."Document No.");
                    IF RecPedido2.FINDFIRST THEN BEGIN
                        //IF RecPedido."No. Series"<>'S-SHPT-SC'  THEN
                        IF RecPedido2."Shipping No. Series" <> 'S-SHPT-SC' THEN BEGIN
                            //EX-JFC 14/11/14 Calcular el importe en EUROS
                            RecPedido.RESET;
                            RecPedido.SETRANGE(RecPedido."No.", RecLinVta."Document No.");
                            IF RecPedido.FINDFIRST THEN BEGIN
                                //SF-MLA 16/03/16 Se redondea y se hace el cambio de divisa sobre el total para no perder céntimos.
                                //EX-CV
                                IF NOT RecPedido."Ventas en consignacion" THEN
                                    ImpAlb += (RecLinVta."Qty. Shipped Not Invoiced" * RecLinVta."Unit Price" -
                                    RecLinVta."Inv. Discount Amount" * FactorCant -
                                    RecLinVta."Pmt. Discount Amount" * FactorCant)
                                    * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);
                                //EX-CV END
                                /*
                                END ELSE
                                BEGIN

                                  Currency.InitRoundingPrecision;
                                  ImpAlb += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                  RecPedido."Posting Date", RecPedido."Currency Code",
                                  ((RecLinVta."Qty. Shipped Not Invoiced" * RecLinVta."Unit Price" -
                                  RecLinVta."Inv. Discount Amount" * FactorCant -
                                  RecLinVta."Pmt. Discount Amount" * FactorCant)
                                  * (1 + RecLinVta."VAT %"/100 + RecLinVta."EC %"/100)),
                                  RecPedido."Currency Factor"),
                                  Currency."Amount Rounding Precision");
                                */
                            END;

                            //EX-JFC 14/11/14 Calcular el importe en EUROS

                        END;
                    END;
                    //fin modificado
                END; //EX-SGG-WMS 090719

            UNTIL RecLinVta.NEXT = 0;
        //SF-ALD 090317 El factor de divisa corresponderá al último factor de divisa existente
        RecPedido.RESET;
        RecPedido.SETRANGE(RecPedido."Document Type", RecPedido."Document Type"::Order);
        RecPedido.SETRANGE(RecPedido."Sell-to Customer No.", ClienteRec."No.");
        //RecPedido.FINDLAST;
        IF RecPedido.FINDLAST THEN //EX-SGG-WMS 030919
            IF (RecPedido."Currency Code" <> '') AND (NOT CalcularRiesgoCliSinAlbaranes) THEN BEGIN //EX-SGG-WMS 090719
                CurrExchRate.SETFILTER(CurrExchRate."Currency Code", RecPedido."Currency Code");
                CurrExchRate.FINDLAST;
                //SF-ALD FIN
                Currency.InitRoundingPrecision;
                ImpAlb := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                RecPedido."Posting Date", RecPedido."Currency Code", ImpAlb, CurrExchRate."Exchange Rate Amount")
                , Currency."Amount Rounding Precision");
            END;
        //FIN SF-MLA

        //FIN EX-SGG-WMS 090719

        CLEAR(CalcularRiesgoCliSinAlbaranes);//EX-SGG-WMS 090719


        UpdateDocStatistics(CodCliente);

        //Impagados
        IF RecFormaPago.GET(ClienteRec."Payment Method Code") THEN;
        Impagados := 0;
        MovCli.RESET;
        MovCli.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
        MovCli.SETRANGE("Customer No.", CodCliente);
        MovCli.SETRANGE(Open, TRUE);
        //TODO IMPAGO
        // IF NOT RecFormaPago."Bloqueo impago" THEN
        //     MovCli.SETFILTER("Due Date", '<%1', WORKDATE - 15)
        // ELSE
        //     MovCli.SETFILTER("Due Date", '<=%1', WORKDATE);
        IF MovCli.FINDFIRST THEN
            REPEAT
                MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                //EX-CV
                IF NOT MovCli."Ventas en consignacion" THEN
                    Impagados += MovCli."Remaining Amt. (LCY)"
                ELSE
                    ImpagadosConsig += MovCli."Remaining Amt. (LCY)";
            //EX-CV END
            UNTIL MovCli.NEXT = 0;

        FactPte := 0;
        MovCli.RESET;
        MovCli.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
        MovCli.SETRANGE("Customer No.", CodCliente);
        MovCli.SETRANGE(Open, TRUE);
        //MovCli.SETRANGE("Document Type",MovCli."Document Type"::Invoice);
        MovCli.SETFILTER("Document Type", '%1|%2|%3|%4', MovCli."Document Type"::Invoice,
                         MovCli."Document Type"::Payment, MovCli."Document Type"::"Credit Memo",
                         MovCli."Document Type"::" ");
        //EX-CV
        IF MovCli.FINDSET THEN
            REPEAT
                //SF-LBD 20/10/14
                //MovCli.CALCFIELDS("Remaining Amount");
                //FactPte += MovCli."Remaining Amount";
                MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                IF NOT MovCli."Ventas en consignacion" THEN
                    FactPte += MovCli."Remaining Amt. (LCY)"
                ELSE
                    ImpFactPteConsig += MovCli."Remaining Amt. (LCY)";
            UNTIL MovCli.NEXT = 0;
        //EX-CV END

        FactPteImpag := 0;
        MovCli.RESET;
        MovCli.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
        MovCli.SETRANGE("Customer No.", CodCliente);
        MovCli.SETRANGE(Open, TRUE);
        MovCli.SETFILTER("Document Type", '%1|%2|%3|%4', MovCli."Document Type"::Invoice,
                         MovCli."Document Type"::Payment, MovCli."Document Type"::"Credit Memo",
                         MovCli."Document Type"::" ");
        //TODO IMPAGO
        // IF NOT RecFormaPago."Bloqueo impago" THEN
        //     MovCli.SETFILTER("Due Date", '<%1', WORKDATE - 15)
        // ELSE BEGIN
        //     MovCli.SETFILTER("Due Date", '<=%1', WORKDATE);
        // END;
        //EX-CV
        IF MovCli.FINDFIRST THEN
            REPEAT
                //SF-LBD 20/10/14
                //MovCli.CALCFIELDS("Remaining Amount");
                //FactPteImpag += MovCli."Remaining Amount";
                MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                IF NOT MovCli."Ventas en consignacion" THEN
                    FactPteImpag += MovCli."Remaining Amt. (LCY)"
                ELSE
                    ImpFactPteImpagConsig += MovCli."Remaining Amt. (LCY)";
            //SF-LBD FIN
            UNTIL MovCli.NEXT = 0;

        FactPte := FactPte - FactPteImpag;
        ImpFactPteConsig := ImpFactPteConsig - ImpFactPteImpagConsig;
        //EX-CV END

        // ImpPicking := 0;
        // FactorCant := 0;
        // PickLinResumen.RESET;
        // PickLinResumen.SETRANGE("Pedido Cliente No.", CodCliente);
        // PickLinResumen.SETRANGE("Envio No.", '');
        // IF PickLinResumen.FINDFIRST THEN
        //     REPEAT
        //         IF RecLinPedido.GET(RecLinPedido."Document Type"::Order, PickLinResumen."Pedido No.", PickLinResumen."Pedido Linea No.") THEN BEGIN
        //             IF (RecLinPedido."Outstanding Quantity" - RecLinPedido."Cantidad Anulada") <> 0 THEN BEGIN
        //                 //SF-LBD 17/06/14

        //                 //SF-MLA 29/03/16 Igual el cálculo al resto de formularios.
        //                 //FactorCant := PickLinResumen.Cantidad/
        //                 //(RecLinPedido.Quantity - RecLinPedido."Cantidad Anulada");
        //                 FactorCant := PickLinResumen.Cantidad / RecLinPedido.Quantity;
        //                 //FactorCant := PickLinResumen.Cantidad/
        //                 //(RecLinPedido."Outstanding Quantity" - RecLinPedido."Cantidad Anulada");
        //                 //SF-LBD FIN
        //                 //EX-JFC 14/11/14 Calcular el importe en EUROS
        //                 RecPedido.RESET;
        //                 RecPedido.SETRANGE(RecPedido."No.", RecLinPedido."Document No.");
        //                 IF RecPedido.FINDFIRST THEN BEGIN
        //                     // IF RecPedido."Currency Code" = '' THEN BEGIN
        //                     IF FactorCant <> 0 THEN BEGIN
        //                         ImpPicking += (RecLinPedido."Unit Price" * PickLinResumen.Cantidad -
        //                         RecLinPedido."Inv. Discount Amount" * FactorCant -
        //                         RecLinPedido."Pmt. Discount Amount" * FactorCant) *
        //                         (1 + RecLinPedido."VAT %" / 100 + RecLinPedido."EC %" / 100)
        //                     END ELSE BEGIN
        //                         ImpPicking += (RecLinPedido."Unit Price" * PickLinResumen.Cantidad -
        //                         RecLinPedido."Inv. Discount Amount" -
        //                         RecLinPedido."Pmt. Discount Amount") *
        //                         (1 + RecLinPedido."VAT %" / 100 + RecLinPedido."EC %" / 100)

        //                     END;
        //                     /*
        //                     END ELSE
        //                     BEGIN
        //                       Currency.InitRoundingPrecision;
        //                       ImpPicking += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
        //                       RecPedido."Posting Date", RecPedido."Currency Code",
        //                       ((RecLinPedido."Unit Price" * PickLinResumen.Cantidad -
        //                       RecLinPedido."Inv. Discount Amount" * FactorCant -
        //                       RecLinPedido."Pmt. Discount Amount" * FactorCant) *
        //                       (1 + RecLinPedido."VAT %"/100 + RecLinPedido."EC %"/100)),
        //                       RecPedido."Currency Factor"),
        //                       Currency."Amount Rounding Precision");
        //                     END;
        //                     */
        //                 END;
        //             END;
        //             //EX-JFC 14/11/14 Calcular el importe en EUROS
        //         END;
        //     UNTIL PickLinResumen.NEXT = 0;
        //SF-MLA 29/03/16 Se redondea y se hace el cambio de divisa sobre el total para no perder céntimos.
        // IF RecPedido."Currency Code" <> '' THEN BEGIN
        //     ImpPicking := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(RecPedido."Posting Date", RecPedido."Currency Code",
        //     ImpPicking, RecPedido."Currency Factor"), Currency."Amount Rounding Precision");
        // END;

        // ImpReserva := 0;
        // RecPedido.RESET;
        // RecPedido.SETRANGE("Document Type", RecPedido."Document Type"::Order);
        // RecPedido.SETRANGE("Sell-to Customer No.", CodCliente);
        // IF RecPedido.FINDFIRST THEN
        //     REPEAT
        //         RecPedido.CALCFIELDS("Reserva Picking");
        //         IF RecPedido."Reserva Picking" <> 0 THEN BEGIN
        //             MovReserva.RESET;
        //             MovReserva.SETRANGE("Origen Documento No.", RecPedido."No.");
        //             IF MovReserva.FINDFIRST THEN
        //                 REPEAT
        //                     IF RecLinPedido.GET(RecLinPedido."Document Type"::Order,
        //                           MovReserva."Origen Documento No.", MovReserva."Origen Documento Line No.") THEN BEGIN
        //                         IF RecLinPedido."Outstanding Quantity" <> 0 THEN BEGIN
        //                             //SF-LBD 17/06/14
        //                             FactorCant := MovReserva."Cantidad Reservada" / RecLinPedido.Quantity;
        //                             //FactorCant := MovReserva."Cantidad Reservada"/RecLinPedido."Outstanding Quantity";
        //                             //SF-LBD FIN
        //                             //EX-JFC 14/11/14 Calcular el importe en EUROS
        //                             //RecPedido.RESET;
        //                             //RecPedido.SETRANGE(RecPedido."No.",RecLinPedido."Document No.");
        //                             //IF RecPedido.FINDFIRST THEN
        //                             //BEGIN
        //                             IF RecPedido."Currency Code" = '' THEN BEGIN
        //                                 ImpReserva += (RecLinPedido."Unit Price" * MovReserva."Cantidad Reservada" -
        //                                 RecLinPedido."Inv. Discount Amount" * FactorCant -
        //                                 RecLinPedido."Pmt. Discount Amount" * FactorCant) *
        //                                 (1 + RecLinPedido."VAT %" / 100 + RecLinPedido."EC %" / 100)
        //                             END ELSE BEGIN
        //                                 Currency.InitRoundingPrecision;
        //                                 ImpReserva += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
        //                                 RecPedido."Posting Date", RecPedido."Currency Code",
        //                                 ((RecLinPedido."Unit Price" * MovReserva."Cantidad Reservada" -
        //                               RecLinPedido."Inv. Discount Amount" * FactorCant -
        //                               RecLinPedido."Pmt. Discount Amount" * FactorCant) *
        //                               (1 + RecLinPedido."VAT %" / 100 + RecLinPedido."EC %" / 100)),
        //                                 RecPedido."Currency Factor"),
        //                                 Currency."Amount Rounding Precision");
        //                             END;
        //                             //END;
        //                         END;
        //                         //EX-JFC 14/11/14 Calcular el importe en EUROS
        //                     END;

        //                 UNTIL MovReserva.NEXT = 0;
        //         END;

        //EX-CV
        IF RecPedido."Ventas en consignacion" THEN BEGIN
            lRecTransferLine.RESET;
            lRecTransferLine.SETRANGE(lRecTransferLine."No. pedido", RecPedido."No.");
            IF lRecTransferLine.FINDSET THEN
                REPEAT
                    lRstLinEnvAlm.RESET;
                    lRstLinEnvAlm.SETRANGE("Source No.", lRecTransferLine."Document No.");
                    lRstLinEnvAlm.SETRANGE("Source Line No.", lRecTransferLine."Line No.");
                    IF lRstLinEnvAlm.FINDFIRST THEN BEGIN

                        IF RecLinVta.GET(RecLinVta."Document Type"::Order, RecPedido."No.", lRstLinEnvAlm."Source Line No.") THEN;
                        CLEAR(FactorCant);
                        IF RecLinVta.Quantity <> 0 THEN
                            FactorCant := lRstLinEnvAlm.Quantity / RecLinVta.Quantity;

                        lImpAux := (lRstLinEnvAlm.Quantity * RecLinVta."Unit Price" -
                          RecLinVta."Inv. Discount Amount" * FactorCant -
                          RecLinVta."Pmt. Discount Amount" * FactorCant)
                          * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);

                        lRstHeadEnvAlm.RESET;
                        lRstHeadEnvAlm.SETRANGE("No.", lRstLinEnvAlm."No.");
                        IF lRstHeadEnvAlm.FINDFIRST THEN BEGIN
                            CASE lRstLinEnvAlm."Estado cabecera" OF
                                lRstLinEnvAlm."Estado cabecera"::Released:
                                    ImpEnviosLanzadosConsig += lImpAux;
                                lRstLinEnvAlm."Estado cabecera"::Open:
                                    ImpEnviosSinLanzarConsig += lImpAux;
                            END;
                        END;
                    END;
                UNTIL lRecTransferLine.NEXT = 0;
        END;
        //EX-CV END
        //   UNTIL RecPedido.NEXT = 0;

        //EX-SGG-WMS 100719 INCLYO ENVIOS ALMACEN
        CLEAR(ImpEnviosLanzados);
        CLEAR(ImpEnviosSinLanzar);
        lRstLinEnvAlm.RESET;
        lRstLinEnvAlm.SETCURRENTKEY("No.", "Destination Type", "Destination No.");
        lRstLinEnvAlm.SETRANGE("Destination Type", lRstLinEnvAlm."Destination Type"::Customer);
        lRstLinEnvAlm.SETRANGE("Destination No.", ClienteRec."No.");
        lRstLinEnvAlm.SETRANGE("Source Type", DATABASE::"Sales Line");
        IF lRstLinEnvAlm.FINDSET THEN
            REPEAT
                IF RecLinVta.GET(RecLinVta."Document Type"::Order, lRstLinEnvAlm."Source No.", lRstLinEnvAlm."Source Line No.") THEN BEGIN
                    CLEAR(FactorCant);
                    IF RecLinVta.Quantity <> 0 THEN
                        FactorCant := lRstLinEnvAlm.Quantity / RecLinVta.Quantity;

                    lImpAux := (lRstLinEnvAlm.Quantity * RecLinVta."Unit Price" -
                      RecLinVta."Inv. Discount Amount" * FactorCant -
                      RecLinVta."Pmt. Discount Amount" * FactorCant)
                      * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);

                    //EX-CV
                    lPedConsig := FALSE;
                    /*
                    lPedConsig := FALSE;
                    TransferHeader.RESET;
                    TransferHeader.SETRANGE("No.", lRstLinEnvAlm."Source No.");
                    IF TransferHeader.FINDFIRST THEN BEGIN
                      recTransferLine.RESET;
                      recTransferLine.SETRANGE("Document No.", TransferHeader."No.");
                      recTransferLine.SETRANGE("Line No.", lRstLinEnvAlm."Source Line No.");
                      IF recTransferLine.FINDFIRST THEN BEGIN
                        lRecSalesHeader.RESET;
                        //SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
                        lRecSalesHeader.SETRANGE("No.", TransferHeader."No. pedido venta");
                        lRecSalesHeader.SETRANGE("Ventas en consignacion", TRUE);
                        IF lRecSalesHeader.FINDFIRST THEN BEGIN
                          lPedConsig := TRUE;
                          CASE lRstLinEnvAlm."Estado cabecera" OF
                           lRstLinEnvAlm."Estado cabecera"::Released: ImpEnviosLanzadosConsig+=lImpAux;
                           lRstLinEnvAlm."Estado cabecera"::Open: ImpEnviosSinLanzarConsig+=lImpAux;
                          END;
                        END;
                      END;
                    END;

                    IF NOT lPedConsig THEN BEGIN
                      lRecSalesHeader.RESET;
                      //SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
                      lRecSalesHeader.SETRANGE("No.",  lRstLinEnvAlm."Source No.");
                      lRecSalesHeader.SETRANGE("Ventas en consignacion", TRUE);
                      IF lRecSalesHeader.FINDFIRST THEN BEGIN
                        lPedConsig := TRUE;
                        CASE lRstLinEnvAlm."Estado cabecera" OF
                         lRstLinEnvAlm."Estado cabecera"::Released: ImpEnviosLanzadosConsig+=lImpAux;
                         lRstLinEnvAlm."Estado cabecera"::Open: ImpEnviosSinLanzarConsig+=lImpAux;
                        END;
                      END;
                    END;
                    */
                    IF NOT lPedConsig THEN BEGIN
                        CASE lRstLinEnvAlm."Estado cabecera" OF
                            lRstLinEnvAlm."Estado cabecera"::Released:
                                ImpEnviosLanzados += lImpAux;
                            lRstLinEnvAlm."Estado cabecera"::Open:
                                ImpEnviosSinLanzar += lImpAux;
                        END;
                    END;
                    //EX-CV END
                END;
            UNTIL lRstLinEnvAlm.NEXT = 0;

        //EX-CV
        lRecTransferLine.RESET;
        lRecTransferLine.SETRANGE("Quantity Shipped", 0);
        lRecTransferLine.SETFILTER(Quantity, '<>%1', 0);
        lRecTransferLine.SETFILTER(lRecTransferLine."No. pedido", '<>%1', '');
        lRecTransferLine.SETFILTER(lRecTransferLine."No. linea pedido", '<>%1', 0);
        IF lRecTransferLine.FINDSET THEN
            REPEAT
                RecLinVta.RESET;
                RecLinVta.SETRANGE("Document No.", lRecTransferLine."No. pedido");
                RecLinVta.SETRANGE("Line No.", lRecTransferLine."No. linea pedido");
                RecLinVta.SETRANGE("Sell-to Customer No.", ClienteRec."No.");
                IF RecLinVta.FINDFIRST THEN BEGIN
                    CLEAR(FactorCant);
                    IF RecLinVta.Quantity <> 0 THEN
                        FactorCant := lRecTransferLine.Quantity / RecLinVta.Quantity;

                    lImpAux := (lRecTransferLine.Quantity * RecLinVta."Unit Price" -
                      RecLinVta."Inv. Discount Amount" * FactorCant -
                      RecLinVta."Pmt. Discount Amount" * FactorCant)
                      * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);

                    ImpPedTransferPdtServirConsig += lImpAux;
                END;
            UNTIL lRecTransferLine.NEXT = 0;

        lRecTransferLine.RESET;
        lRecTransferLine.SETFILTER("Qty. in Transit", '<>%1', 0);
        lRecTransferLine.SETFILTER(Quantity, '<>%1', 0);
        lRecTransferLine.SETFILTER(lRecTransferLine."No. pedido", '<>%1', '');
        lRecTransferLine.SETFILTER(lRecTransferLine."No. linea pedido", '<>%1', 0);
        IF lRecTransferLine.FINDSET THEN
            REPEAT
                RecLinVta.RESET;
                RecLinVta.SETRANGE("Document No.", lRecTransferLine."No. pedido");
                RecLinVta.SETRANGE("Line No.", lRecTransferLine."No. linea pedido");
                RecLinVta.SETRANGE("Sell-to Customer No.", ClienteRec."No.");
                IF RecLinVta.FINDFIRST THEN BEGIN
                    CLEAR(FactorCant);

                    IF RecLinVta.Quantity <> 0 THEN
                        FactorCant := lRecTransferLine."Qty. in Transit" / RecLinVta.Quantity;

                    lImpAux := (lRecTransferLine."Qty. in Transit" * RecLinVta."Unit Price" -
                      RecLinVta."Inv. Discount Amount" * FactorCant -
                      RecLinVta."Pmt. Discount Amount" * FactorCant)
                      * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);

                    ImpPedTransitoConsig += lImpAux;
                END;
            UNTIL lRecTransferLine.NEXT = 0;

        lRecLocation.RESET;
        lRecLocation.SETRANGE(lRecLocation."Cod. cliente", ClienteRec."No.");
        lRecLocation.SETRANGE(Consignacion, TRUE);
        IF lRecLocation.FINDSET THEN
            REPEAT
                lRecItemLedEntry.RESET;
                lRecItemLedEntry.SETRANGE("Location Code", lRecLocation.Code);
                lRecItemLedEntry.SETRANGE(Open, TRUE);
                IF lRecItemLedEntry.FINDSET THEN
                    REPEAT
                        lRecItem.GET(lRecItemLedEntry."Item No.");
                        lQtyPerUnitMeasurement := lcuUOMMgt.GetQtyPerUnitOfMeasure(lRecItem, lRecItemLedEntry."Unit of Measure Code");
                        //ImpStockConsig += (lRecItem."Unit Cost" * lQtyPerUnitMeasurement);
                        //ImpStockConsig += (lRecItem."Unit Cost" * lRecItemLedEntry."Remaining Quantity"); //Ajustar Jon
                        ImpStockConsig += (getSalesPrice(lRecItem."No.", ClienteRec, lRecItemLedEntry."Variant Code")
                                           * lRecItemLedEntry."Remaining Quantity"); //Ajustar Jon
                    UNTIL lRecItemLedEntry.NEXT = 0;
            UNTIL lRecLocation.NEXT = 0;
        //EX-CV END

        //EX-CV
        lRecCustomer.RESET;
        lRecCustomer.SETRANGE("No.", CodCliente);
        IF lRecCustomer.FINDFIRST THEN;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Ventas en consignacion", FALSE);
        CustLedgerEntry.SETRANGE(Open, TRUE);
        CustLedgerEntry.SETRANGE("Customer No.", lRecCustomer."No.");
        IF CustLedgerEntry.FINDSET THEN
            REPEAT
                CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                ImpFactPte += CustLedgerEntry."Remaining Amt. (LCY)";
            UNTIL CustLedgerEntry.NEXT = 0;


        EXIT(ClienteRec."Riesgo Concedido Firme" - (ImpFactPte + ImpAlb + SaldoMigracion +
                                                  ImpPicking + ImpReserva + ImpEnviosLanzados));
        //EX-CV  -  2022 03 10 END
        //EX-CV END

    end;

    procedure getSalesPrice(pItem: Code[20]; pCustomer: Record Customer; pVariant: Code[20]): Decimal
    var
        SalesPrice: Record 7002;
        //ConsignmentCondition: Record 50051;
        ret: Decimal;
        lrecItem: Record 27;
        lrecVATPostingSetup: Record 325;
        lIVA: Decimal;
    begin
        //EX-CV
        ret := 0;
        SalesPrice.RESET;
        SalesPrice.SETRANGE("Item No.", pItem);
        SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SETRANGE("Sales Code", pCustomer."No.");
        SalesPrice.SETFILTER("Starting Date", '..%1', TODAY);
        //SalesPrice.SETRANGE("Location Code", pLocation);
        SalesPrice.SETRANGE("Variant Code", pVariant);
        IF SalesPrice.FINDLAST THEN
            ret := SalesPrice."Unit Price";

        SalesPrice.RESET;
        SalesPrice.SETRANGE("Item No.", pItem);
        SalesPrice.SETRANGE("Sales Code", pCustomer."Customer Price Group");
        SalesPrice.SETFILTER("Starting Date", '..%1', TODAY);
        //SalesPrice.SETRANGE("Location Code", pLocation);
        SalesPrice.SETRANGE("Variant Code", pVariant);
        IF SalesPrice.FINDLAST THEN
            ret := SalesPrice."Unit Price";

        CLEAR(lIVA);
        lrecItem.RESET;
        lrecItem.SETRANGE("No.", pItem);
        IF lrecItem.FINDFIRST THEN BEGIN
            lrecVATPostingSetup.RESET;
            lrecVATPostingSetup.SETRANGE("VAT Bus. Posting Group", pCustomer."VAT Bus. Posting Group");
            lrecVATPostingSetup.SETRANGE("VAT Prod. Posting Group", lrecItem."VAT Prod. Posting Group");
            IF lrecVATPostingSetup.FINDFIRST THEN BEGIN
                lIVA := (ret * lrecVATPostingSetup."VAT %") / 100;
            END;
        END;

        ret += lIVA;

        // IF ret <> 0 THEN BEGIN
        //     ConsignmentCondition.RESET;
        //     ConsignmentCondition.SETRANGE("Customer No.", pCustomer."No.");
        //     ConsignmentCondition.SETRANGE("Register Type", ConsignmentCondition."Register Type"::Consignment);
        //     ConsignmentCondition.SETRANGE("Value Type", ConsignmentCondition."Value Type"::"% Dto Factura Consignación");
        //     IF ConsignmentCondition.FINDFIRST THEN BEGIN
        //         ret := ret - ((ConsignmentCondition.Value) * ret / 100)
        //     END;
        // END;

        EXIT(ret);
        //EX-CV END
    end;


    procedure UpdateDocStatistics(CodCli: Code[20])
    var
        CustLedgEntry: Record "21";
        DocumentSituationFilter: array[3] of Option " ","Posted BG/PO","Closed BG/PO","BG/PO",Cartera,"Closed Documents";
        j: Integer;
        NoOpen: array[5] of Integer;
        NoHonored: array[5] of Integer;
        NoRejected: array[5] of Integer;
        NoRedrawn: array[5] of Integer;
        OpenAmtLCY: array[5] of Decimal;
        HonoredAmtLCY: array[5] of Decimal;
        RejectedAmtLCY: array[5] of Decimal;
        RedrawnAmtLCY: array[5] of Decimal;
        RejectedRemainingAmtLCY: array[5] of Decimal;
        HonoredRemainingAmtLCY: array[5] of Decimal;
        RedrawnRemainingAmtLCY: array[5] of Decimal;
        ImpagRem: array[5] of Decimal;
        ClienteImpag: Record "18";
        MovCli: Record "21";
    begin
        DocumentSituationFilter[1] := DocumentSituationFilter::Cartera;
        DocumentSituationFilter[2] := DocumentSituationFilter::"BG/PO";
        DocumentSituationFilter[3] := DocumentSituationFilter::"Posted BG/PO";

        WITH CustLedgEntry DO BEGIN
            SETCURRENTKEY("Customer No.", "Document Type", "Document Situation", "Document Status");
            SETRANGE("Customer No.", CodCli);
            FOR j := 1 TO 5 DO BEGIN
                CASE j OF
                    4: // Closed Bill Group and Closed Documents
                        BEGIN
                            SETRANGE("Document Type", "Document Type"::Bill);
                            SETFILTER("Document Situation", '%1|%2',
                              "Document Situation"::"Closed BG/PO",
                              "Document Situation"::"Closed Documents");
                        END;
                    5: // Invoices
                        BEGIN
                            SETRANGE("Document Type", "Document Type"::Invoice);
                            SETFILTER("Document Situation", '<>0');
                        END;
                    ELSE BEGIN
                        SETRANGE("Document Type", "Document Type"::Bill);
                        SETRANGE("Document Situation", DocumentSituationFilter[j]);
                    END;
                END;

                IF ((j = 1) OR (j = 2) OR (j = 3)) THEN BEGIN
                    IF ClienteImpag.GET(CodCli) THEN;
                    IF RecFormaPago.GET(ClienteImpag."Payment Method Code") THEN;
                    ImpagRem[j] := 0;
                    MovCli.RESET;
                    MovCli.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
                    MovCli.SETRANGE("Customer No.", CodCli);
                    MovCli.SETRANGE(Open, TRUE);
                    MovCli.SETRANGE("Ventas en consignacion", FALSE);
                    MovCli.SETRANGE("Document Situation", DocumentSituationFilter[j]);
                    //TODO IMPAGO
                    // IF NOT RecFormaPago."Bloqueo impago" THEN
                    //     MovCli.SETFILTER("Due Date", '<%1', WORKDATE - 15)
                    // ELSE
                    //     MovCli.SETFILTER("Due Date", '<=%1', WORKDATE);
                    IF MovCli.FINDFIRST THEN
                        REPEAT
                            MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                            //EX-CV
                            IF NOT MovCli."Ventas en consignacion" THEN
                                ImpagRem[j] += MovCli."Remaining Amt. (LCY)"
                        //ELSE BEGIN
                        //  CASE j OF
                        //    1 : ImpEfecPendConsig += MovCli."Remaining Amt. (LCY)";
                        //    2 : ImpEfecPendRemesasConsig += MovCli."Remaining Amt. (LCY)";
                        //    3 : ImpEfectPendRemesasRegConsig += MovCli."Remaining Amt. (LCY)";
                        // END;
                        //END;
                        //EX-CV END
                        UNTIL MovCli.NEXT = 0;
                END;

                //EX-CV
                CLEAR(ImpEfecPendConsig);
                CLEAR(ImpEfecPendRemesasConsig);
                CLEAR(ImpEfectPendRemesasRegConsig);
                MovCli.RESET;
                MovCli.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
                MovCli.SETRANGE("Customer No.", CodCli);
                MovCli.SETRANGE(Open, TRUE);
                MovCli.SETRANGE("Ventas en consignacion", TRUE);
                //IF NOT RecFormaPago."Bloqueo impago" THEN
                //  MovCli.SETFILTER("Due Date",'<%1',WORKDATE - 15)
                //ELSE
                //  MovCli.SETFILTER("Due Date",'<=%1',WORKDATE);
                IF MovCli.FINDFIRST THEN
                    REPEAT
                        MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                        CASE MovCli."Document Situation" OF
                            MovCli."Document Situation"::Cartera:
                                ImpEfecPendConsig += MovCli."Remaining Amt. (LCY)";
                            MovCli."Document Situation"::"BG/PO":
                                ImpEfecPendRemesasConsig += MovCli."Remaining Amt. (LCY)";
                            MovCli."Document Situation"::"Posted BG/PO":
                                ImpEfectPendRemesasRegConsig += MovCli."Remaining Amt. (LCY)";
                        END;
                    UNTIL MovCli.NEXT = 0;

                //EX-CV END

                //EX-SGG-WMS 100719 AGREGO CODIGO FORMULARIO ESTADISTICAS
                ImpagRemRech := 0;
                MovCli.RESET;
                MovCli.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
                MovCli.SETRANGE("Customer No.", CodCli);
                MovCli.SETRANGE(Open, TRUE);
                MovCli.SETRANGE(Positive, TRUE);
                MovCli.SETRANGE("Document Status", MovCli."Document Status"::Rejected);
                IF MovCli.FINDFIRST THEN
                    REPEAT
                        MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                        //EX-CV
                        IF NOT MovCli."Ventas en consignacion" THEN
                            ImpagRemRech += MovCli."Remaining Amt. (LCY)"
                        ELSE
                            ImpagRemRechConsig += MovCli."Remaining Amt. (LCY)";
                    //EX-CV END
                    UNTIL MovCli.NEXT = 0;
                //FIN EX-SGG-WMS 100719 AGREGO CODIGO FORMULARIO ESTADISTICAS

                SETRANGE("Document Status", "Document Status"::Open);
                CALCSUMS("Remaining Amount (LCY) stats."); //EX-SGG-WMS 100719
                                                           //EX-OMI 260320
                                                           //OpenRemainingAmtLCY[j] := "Remaining Amount (LCY) stats." - ImpagRem[j];
                                                           //EX-CV
                IF NOT "Ventas en consignacion" THEN BEGIN
                    IF j <> 1 THEN
                        OpenRemainingAmtLCY[j] := "Remaining Amount (LCY) stats." - ImpagRem[j]
                    ELSE
                        OpenRemainingAmtLCY[j] := "Remaining Amount (LCY) stats.";
                END;
                //EX-CV END
                //EX-OMI 260320 fin
            END;
        END;
    end;



    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnBeforePost', '', true, true)]

    // local procedure OnBeforePost(var TransHeader: Record "Transfer Header"; var IsHandled: Boolean; var TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment"; var TransferOrderPostReceipt: Codeunit "TransferOrder-Post Receipt"; var PostBatch: Boolean; var TransferOrderPost: Enum "Transfer Order Post")
    // var
    //     RecLocation: Record Location;
    //     RecLocationAux: Record Location;
    //     RegUser: Record "User Setup";
    //     gblCodeClaseStockSEGA: Code[20];
    //     gblCodeClaseStockSEGAAux: Code[20];
    //     gblEstadoCalidadSEGA: Code[20];
    //     gblEstadoCalidadSEGAAux: Code[20];
    //     gblAlmacenServicio: Boolean;
    //     gblAlmacenServicioAux: Boolean;
    // begin
    //     Clear(RecLocation);
    //     RecLocation.Get(TransHeader."Transfer-from Code");
    //     gblCodeClaseStockSEGA := RecLocation."Clase de Stock SEGA";
    //     gblEstadoCalidadSEGA := RecLocation."Estado Calidad SEGA";
    //     gblAlmacenServicio := RecLocation.Servicio;

    //     Clear(RecLocationAux);
    //     RecLocationAux.Get(TransHeader."Transfer-to Code");
    //     gblCodeClaseStockSEGAAux := RecLocationAux."Clase de Stock SEGA";
    //     gblEstadoCalidadSEGAAux := RecLocationAux."Estado Calidad SEGA";
    //     gblAlmacenServicioAux := RecLocationAux.Servicio;
    //     //este codigo es de Marco
    //     // if (gblCodeClaseStockSEGA <> gblCodeClaseStockSEGAAux) AND (gblEstadoCalidadSEGA <> gblEstadoCalidadSEGAAux) then begin

    //     //     Error('');
    //     // end;
    //     //origen
    //     // if RecLocation.Servicio and RecLocationAux.Servicio = false then begin

    //     //     Error('controlar cantidades');
    //     // end else begin
    //     //     Error('salir ejecucion');
    //     // end;




    //     //     RegUser.Get(USERID);
    //     //     if RegUser."Usuario SEGA" then begin
    //     //         if gblAlmacenServicio and gblAlmacenServicioAux = false then
    //     //    end;

    //     //     end;
    //     //end;

    // end;






    var
        OpenRemainingAmtLCY: array[5] of Decimal;
        Currency: Record Currency;
        CurrExchRate: Record 330;
        CduWMS: Codeunit FuncionesWMS;
        ImpAlb: Decimal;
        ImpAnul: Decimal;
        ImpPedPte: Decimal;
        ImpagRemRech: Decimal;
        ImpPedPteConsig: Decimal;
        ImpAnulConsig: Decimal;
        ImpPedTransferPdtServirConsig: Decimal;
        ImpEnviosLanzados: Decimal;
        ImpEnviosSinLanzar: Decimal;
        ImpEnviosLanzadosConsig: Decimal;
        ImpEnviosSinLanzarConsig: Decimal;
        ImpPedTransitoConsig: Decimal;
        ImpStockConsig: Decimal;
        ImpFactPteConsig: Decimal;
        ImpFactPteImpagConsig: Decimal;
        ImpEfecPendConsig: Decimal;
        ImpEfecPendRemesasConsig: Decimal;
        ImpEfectPendRemesasRegConsig: Decimal;
        ImpagRemRechConsig: Decimal;
        FactPteImpag: Decimal;
        ImpagadosConsig: Decimal;
        FactPte: Decimal;
        ImpReserva: Decimal;
        RecFormaPago: Record "Payment Method";
        ImpPicking: Decimal;
        Impagados: Decimal;

}