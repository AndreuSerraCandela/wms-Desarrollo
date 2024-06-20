Page 50431 "Modificacion Prop Vta Cab WMS"
{
    SourceTable = TemporalPV;
    SourceTableView = SORTING("Clave 1", "Clave 2", "Clave 3", "Clave 4", "Clave 5", "Clave 6", "Clave 7", "Clave 8", Proceso, "Consignacion venta")
                    ORDER(Ascending);
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(Content)
        {
            repeater(Detalle)
            {
                field(Usuario; Rec.usuario) { Editable = false; ApplicationArea = All; }

                field("Fecha Servicio"; Rec."Fecha Servicio") { Editable = false; ApplicationArea = All; }
                field("Comentario"; Rec.ComentarioPed) { Editable = false; ApplicationArea = All; }
                field("Cód. Representante"; Rec."Cod Representante") { Editable = false; ApplicationArea = All; }
                field(Temporada; Rec.Temporada) { Editable = false; ApplicationArea = All; }
                field("Clave 1"; Rec."Clave 1") { Editable = false; ApplicationArea = All; }
                //  OnFormat=BEGIN
                //             //EX-SGG-WMS 230919
                //             IF ExistenLineasAsignadas("Clave 1",'WMSTALLAS',USERID) THEN
                //              CurrPage."Clave 1".UPDATEFORECOLOR(16711680)
                //             ELSE
                //              CurrPage."Clave 1".UPDATEFORECOLOR(0);
                //           END;
                //            }
                field("Nº Pedido"; Rec.Origen) { Editable = false; ApplicationArea = All; }
                field("Nombre Cliente"; Rec."Nombre Cliente") { Editable = false; ApplicationArea = All; }
                field(Cantidad; Rec.Cantidad) { Editable = false; ApplicationArea = All; }
                field("Cantidad Anulada"; Rec."Cantidad Anulada") { Editable = false; ApplicationArea = All; }
                field("Cantidad Servida"; Rec."Cantidad Servida") { Editable = false; ApplicationArea = All; }
                field("Cantidad Pendiente"; Rec."Cantidad Pendiente" - Rec."Cantidad Anulada" - Rec."Cantidad Picking" - Rec."Cantidad Reserva" - Rec."Cant. envios lanzados") { Editable = false; ApplicationArea = All; }
                field("Cantidad Picking"; Rec."Cantidad Picking") { Editable = false; ApplicationArea = All; }
                field("Cant. envios lanzados"; Rec."Cant. envios lanzados") { Editable = false; ApplicationArea = All; }
                field("Cant. envios lanzados pedido"; Rec."Cant. envios lanzados pedido") { Editable = false; ApplicationArea = All; }
                field("Cantidad Asignada"; Rec."Cantidad Asignada") { Editable = false; ApplicationArea = All; }
                field("Cantidad Reservada"; Rec."Cantidad Reserva") { Editable = false; ApplicationArea = All; }
                field(Retenido; Rec.Retenido) { Editable = false; ApplicationArea = All; }
                field("Estado Cliente"; Rec.Descripcion) { Editable = false; ApplicationArea = All; }
                field("Importe Pedido TOTAL"; Rec."Importe Pedido") { Editable = false; ApplicationArea = All; }
                field("Importe Pte No anul"; Rec."Importe Pte No anul") { Editable = false; ApplicationArea = All; }
                field("Importe Asignado"; Rec."Importe Asignado") { Editable = false; ApplicationArea = All; }
                field("Importe Asignado Clientes"; Rec."Importe Asignado Cli") { Editable = false; ApplicationArea = All; }
                field("Impago Cliente"; Rec."Impago Cliente") { Editable = false; ApplicationArea = All; }
                field("Supera Riesgo"; Rec."Supera Riesgo") { Editable = false; ApplicationArea = All; }
                field("Riesgo Nuevo Milenio"; Rec."Riesgo NMilenio") { Editable = false; ApplicationArea = ALL; }
                //  OnFormat=BEGIN
                //             IF "Riesgo NMilenio" <= 0 THEN
                //               CurrPage.RNM.UPDATEFORECOLOR(255);
                //           END;
                field("Consignacion venta"; Rec."Consignacion venta") { Editable = false; ApplicationArea = All; }


            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("L&íneas Proposición")
            {
                ShortCutKey = 'Ctrl+X';
                Image = Line;
                ApplicationArea = All;
                trigger OnAction()
                Var
                    lAlgunoDistintoCalzado: Boolean;
                    lTxtOpciones: label 'Proposición normal,Proposición matriz';
                BEGIN
                    //+EX-SGG 091222
                    //LineasProposicionNormal();
                    CASE Rec."Tipo proposicion calculada" OF
                        Rec."Tipo proposicion calculada"::" ":
                            BEGIN
                                CLEAR(lAlgunoDistintoCalzado);
                                RecTempLin.RESET;
                                RecTempLin.SETCURRENTKEY(Proceso, usuario, "Insertado 2");
                                RecTempLin.SETRANGE(Proceso, 'WMSLIN');
                                //  RecTempLin.SETRANGE(usuario, USERID);
                                RecTempLin.SETRANGE("Clave 1", Rec."Clave 1");
                                RecTempLin.FINDSET();
                                REPEAT
                                    RecProd.GET(RecTempLin."Clave 4");
                                    lAlgunoDistintoCalzado := RecProd.Tipo <> 0;// RecProd.Tipo::Accesorio;
                                UNTIL (RecTempLin.NEXT() = 0) OR lAlgunoDistintoCalzado;
                                IF lAlgunoDistintoCalzado THEN
                                    LineasProposicionMatriz()
                                ELSE
                                    CASE DIALOG.STRMENU(lTxtOpciones, 1) OF
                                        1:
                                            LineasProposicionNormal();
                                        2:
                                            LineasProposicionMatriz();
                                    END;
                            END;
                        Rec."Tipo proposicion calculada"::Normal:
                            LineasProposicionNormal();
                        Rec."Tipo proposicion calculada"::Matriz:
                            LineasProposicionMatriz();
                    END;
                    //-EX-SGG 091222
                END;
            }
            action("Cálculo Importe")
            {
                ShortCutKey = 'Ctrl+Z';
                Image = Calculate;
                ApplicationArea = All;
                trigger OnAction()
                Var
                    CUFunciones: Codeunit 50000;
                BEGIN
                    V.OPEN('Calculo Importe Individual:#1#######');
                    RecTempImporte.RESET;
                    RecTempImporte.SETRANGE(Proceso, 'WMSCAB');
                    //RecTempImporte.SETRANGE(usuario,USERID);

                    IF RecTempImporte.FINDFIRST THEN
                        REPEAT
                            V.UPDATE(1, RecTempImporte."Clave 1");
                            RecTempImporte."Importe Asignado" := 0;
                            RecTempImporte.MODIFY;
                            RecTempImpLin.RESET;
                            RecTempImpLin.SETRANGE("Clave 1", RecTempImporte."Clave 1");
                            RecTempImpLin.SETRANGE(Proceso, 'WMSLIN');
                            RecTempImpLin.SETRANGE("Asigna Lin", TRUE);
                            IF RecTempImpLin.FINDFIRST THEN
                                REPEAT
                                    IF RecTempImpLin.Cantidad <> 0 THEN
                                        RecTempImporte."Importe Asignado" += RecTempImpLin."Importe Pedido" *
                                          (RecTempImpLin."Cantidad Asignada" / RecTempImpLin.Cantidad);

                                UNTIL RecTempImpLin.NEXT = 0;

                            //EX JFC 141221 Calculamos el riesgo o aval del cliente en funcion de pedido en firme o consignacion. Comentado
                            //RiesgoDisp := CUFunc.RiesgoCliente(RecTempImporte."Clave 3");
                            //RecCli.GET(RecTempImporte."Clave 3");
                            //RiesgoNM := RecCli."Riesgo NUEVO MILENIO";
                            //EX JFC FIN 141221 Calculamos el riesgo o aval del cliente en funcion de pedido en firme o consignacion.Comentado

                            //EX JFC 141221 Calculamos el riesgo o aval del cliente en funcion de pedido en firme o consignacion.
                            TemporalPV.RESET;
                            TemporalPV.SETCURRENTKEY("Clave 1", Proceso);
                            TemporalPV.SETRANGE("Clave 1", RecTempImporte."Clave 1");
                            TemporalPV.SETFILTER(Proceso, 'WMSCAB');
                            IF TemporalPV.FINDFIRST THEN BEGIN
                                IF TemporalPV."Consignacion venta" = FALSE THEN BEGIN
                                    RiesgoDisp := CUFunc.RiesgoCliente(RecTempImporte."Clave 3");
                                    RecCli.GET(RecTempImporte."Clave 3");
                                    RecCli.CalcFields(RecCli."Riesgo Concedido Consignacion", "Riesgo Concedido Firme");

                                    RiesgoNM := (RecCli."Riesgo Concedido Firme" + RecCli."Riesgo Concedido Consignacion");
                                END;
                                IF TemporalPV."Consignacion venta" = TRUE THEN BEGIN
                                    RiesgoDisp := GetValueAvalDisp(RecTempImporte."Clave 3");
                                    lRecConsignmentCondition.RESET;
                                    lRecConsignmentCondition.SETRANGE("Customer No.", RecTempImporte."Clave 3");
                                    lRecConsignmentCondition.SETRANGE("Register Type", lRecConsignmentCondition."Register Type"::Consignment);
                                    lRecConsignmentCondition.SETRANGE("Value Type", lRecConsignmentCondition."Value Type"::Aval);
                                    IF lRecConsignmentCondition.FINDFIRST THEN;
                                    RiesgoNM := lRecConsignmentCondition.Value;
                                END;
                            END;
                            //EX JFC FIN 141221 Calculamos el riesgo o aval del cliente en funcion de pedido en firme o consignacion.


                            IF BloqueoCli.GET(RecCli.CustomerStatus) THEN
                                IF not BloqueoCli."Envíos permitidos" THEN
                                    RecTempImporte.Retenido := TRUE;
                            RecTempImporte.Descripcion := BloqueoCli.Code;
                            //SF-POF:Quieren cambiar el criterio
                            //IF ((RecTempImporte."Importe Asignado" >= RiesgoDisp) OR
                            //   (RiesgoNM <= 0))
                            IF ((RecTempImporte."Importe Asignado" > RiesgoDisp) OR
                               (RiesgoNM <= 0))
                            //SF-POF:FIN

                            THEN BEGIN
                                RecTempImporte."Supera Riesgo" := TRUE;
                                //EX-SGG-WMS 200619 COMENTO
                                //   {
                                //           RecTempImporte.Clasificadora := FALSE;
                                //           RecTempImporte.PDA := FALSE;
                                //   }
                            END ELSE BEGIN
                                RecTempImporte."Supera Riesgo" := FALSE;
                                //EX-SGG-WMS 200619 COMENTO
                                //   {
                                //           IF RecTempImporte.Clasificadora THEN BEGIN
                                //             RecTempImporte.Clasificadora := TRUE;
                                //             RecTempImporte.PDA := FALSE;
                                //           END;
                                //           IF RecTempImporte.PDA THEN BEGIN
                                //             RecTempImporte.PDA := TRUE;
                                //             RecTempImporte.Clasificadora := FALSE;
                                //           END;
                                //   }
                            END;
                            //EX-SGG-WMS 200619 COMENTO
                            //   {
                            //         IF RecTempImporte.Retenido THEN BEGIN
                            //           RecTempImporte.Clasificadora := FALSE;
                            //           RecTempImporte.PDA := FALSE;
                            //         END;}
                            //EX-OMI-WMS 270519
                            //IF RecCli.Vencimiento15(RecTempImporte."Clave 3") THEN BEGIN
                            IF CUFunciones.Vencimiento15(RecTempImporte."Clave 3") THEN BEGIN
                                //EX-OMI-WMS
                                //EX-SGG-WMS 200619 COMENTO
                                //   {
                                //           RecTempImporte.Clasificadora := FALSE;
                                //           RecTempImporte.PDA := FALSE;
                                //   }
                                RecTempImporte."Impago Cliente" := TRUE;
                            END ELSE BEGIN
                                RecTempImporte."Impago Cliente" := FALSE;
                            END;

                            RecTempImporte.MODIFY;
                        UNTIL RecTempImporte.NEXT = 0;
                    V.CLOSE;


                    V.OPEN('Calculo Importe Mismo Cliente:#1#######');
                    RecTempImporte.RESET;
                    RecTempImporte.SETRANGE(Proceso, 'WMSCAB');
                    //RecTempImporte.SETRANGE(usuario,USERID);

                    IF RecTempImporte.FINDFIRST THEN
                        REPEAT
                            V.UPDATE(1, RecTempImporte."Clave 1");
                            RecTempImporte."Importe Asignado Cli" := 0;
                            RecTempImporte.MODIFY;
                            RecTempImpLin.RESET;
                            RecTempImpLin.SETRANGE("Clave 3", RecTempImporte."Clave 3");
                            RecTempImpLin.SETRANGE(Proceso, 'WMSLIN');
                            RecTempImpLin.SETRANGE("Asigna Lin", TRUE);
                            IF RecTempImpLin.FINDFIRST THEN
                                REPEAT
                                    IF RecTempImpLin.Cantidad <> 0 THEN
                                        RecTempImporte."Importe Asignado Cli" += RecTempImpLin."Importe Pedido" *
                                          (RecTempImpLin."Cantidad Asignada" / RecTempImpLin.Cantidad);

                                UNTIL RecTempImpLin.NEXT = 0;

                            //EX JFC 141221 Calculamos el riesgo o aval del cliente en funcion de pedido en firme o consignacion. Comentado
                            //RiesgoDisp := CUFunc.RiesgoCliente(RecTempImporte."Clave 3");
                            //RecCli.GET(RecTempImporte."Clave 3");
                            //RiesgoNM := RecCli."Riesgo NUEVO MILENIO";
                            //EX JFC FIN 141221 Calculamos el riesgo o aval del cliente en funcion de pedido en firme o consignacion.Comentado

                            //EX JFC 141221 Calculamos el riesgo o aval del cliente en funcion de pedido en firme o consignacion.
                            TemporalPV.RESET;
                            TemporalPV.SETCURRENTKEY("Clave 1", Proceso);
                            TemporalPV.SETRANGE("Clave 1", RecTempImporte."Clave 1");
                            TemporalPV.SETFILTER(Proceso, 'WMSCAB');
                            IF TemporalPV.FINDFIRST THEN BEGIN
                                IF TemporalPV."Consignacion venta" = FALSE THEN BEGIN
                                    RiesgoDisp := CUFunc.RiesgoCliente(RecTempImporte."Clave 3");
                                    RecCli.GET(RecTempImporte."Clave 3");
                                    RecCli.CalcFields(RecCli."Riesgo Concedido Consignacion", "Riesgo Concedido Firme");
                                    RiesgoNM := (RecCli."Riesgo Concedido Firme" + RecCli."Riesgo Concedido Consignacion");
                                    //RiesgoNM := RecCli."Riesgo Concedido";
                                END;
                                IF TemporalPV."Consignacion venta" = TRUE THEN BEGIN
                                    RiesgoDisp := GetValueAvalDisp(RecTempImporte."Clave 3");
                                    lRecConsignmentCondition.RESET;
                                    lRecConsignmentCondition.SETRANGE("Customer No.", RecTempImporte."Clave 3");
                                    lRecConsignmentCondition.SETRANGE("Register Type", lRecConsignmentCondition."Register Type"::Consignment);
                                    lRecConsignmentCondition.SETRANGE("Value Type", lRecConsignmentCondition."Value Type"::Aval);
                                    IF lRecConsignmentCondition.FINDFIRST THEN;
                                    RiesgoNM := lRecConsignmentCondition.Value;
                                END;
                            END;
                            //EX JFC FIN 141221 Calculamos el riesgo o aval del cliente en funcion de pedido en firme o consignacion.


                            // {
                            // IF ((RecTempImporte."Importe Asignado Cli" >= RiesgoDisp) OR
                            //    (RecTempImporte."Importe Asignado Cli" >= RiesgoNM)) THEN BEGIN
                            // }
                            //SF-POF:Quieren cambiar el criterio
                            //IF ((RecTempImporte."Importe Asignado Cli" >= RiesgoDisp) OR
                            //   (RiesgoNM <= 0)) THEN BEGIN
                            IF ((RecTempImporte."Importe Asignado Cli" > RiesgoDisp) OR
                               (RiesgoNM <= 0)) THEN BEGIN
                                //SF-POF:FIN

                                RecTempImporte."Supera Riesgo" := TRUE;
                                //EX-SGG-WMS 200619 COMENTO
                                //   {
                                //           RecTempImporte.Clasificadora := FALSE;
                                //           RecTempImporte.PDA := FALSE;
                                //   }
                            END ELSE BEGIN
                                RecTempImporte."Supera Riesgo" := FALSE;
                                //EX-SGG-WMS 200619 COMENTO
                                //   {
                                //           IF RecTempImporte.Clasificadora THEN BEGIN
                                //             RecTempImporte.Clasificadora := TRUE;
                                //             RecTempImporte.PDA := FALSE;
                                //           END;
                                //           IF RecTempImporte.PDA THEN BEGIN
                                //             RecTempImporte.PDA := TRUE;
                                //             RecTempImporte.Clasificadora := FALSE;
                                //           END;
                                //   }

                            END;
                            //EX-SGG-WMS 200619 COMENTO
                            //   {
                            //         IF RecTempImporte.Retenido THEN BEGIN
                            //           RecTempImporte.Clasificadora := FALSE;
                            //           RecTempImporte.PDA := FALSE;
                            //         END;
                            //   }
                            //EX-OMI-WMS 270519
                            //IF RecCli.Vencimiento15(RecTempImporte."Clave 3") THEN BEGIN
                            IF CUFunciones.Vencimiento15(RecTempImporte."Clave 3") THEN BEGIN
                                //EX-OMI fin
                                //EX-SGG-WMS 200619 COMENTO
                                //   {
                                //           RecTempImporte.Clasificadora := FALSE;
                                //           RecTempImporte.PDA := FALSE;
                                //   }
                                RecTempImporte."Impago Cliente" := TRUE;
                            END ELSE BEGIN
                                RecTempImporte."Impago Cliente" := FALSE;
                            END;

                            RecTempImporte.MODIFY;
                        UNTIL RecTempImporte.NEXT = 0;
                    V.CLOSE;

                    COMMIT;
                    //REPORT.RUNMODAL(REPORT::"Comprobar Preemb Proposici WMS",TRUE,FALSE); //EX-SGG-WMS 200619
                    BtnGenerarEnviosWMENABLED := (TRUE);
                END;
            }

            action("Generar envíos WMS")
            {
                ApplicationArea = All;
                Image = Shipment;
                Enabled = BtnGenerarEnviosWMENABLED;
                trigger OnAction()
                BEGIN
                    IF NOT CONFIRM('Recuerde Calcular Importes.  Continuar?', FALSE) THEN
                        EXIT;

                    LinAsign := FALSE;
                    TemporalRec.RESET;
                    TemporalRec.SETRANGE(Proceso, 'WMSCAB');
                    TemporalRec.SETRANGE(usuario, USERID);
                    IF TemporalRec.FINDFIRST THEN
                        REPEAT
                            TemporalRec.CALCFIELDS("Asigna Cab");
                            IF TemporalRec."Asigna Cab" THEN
                                LinAsign := TRUE;
                        UNTIL TemporalRec.NEXT = 0;

                    IF NOT LinAsign THEN
                        ERROR('No se ha realizado asignaci n de l neas');

                    TemporalRec.RESET;
                    TemporalRec.SETRANGE(Proceso, 'WMSCAB');
                    TemporalRec.SETRANGE(usuario, USERID);
                    //TemporalRec.SETRANGE(PDA,TRUE); //EX-SGG 200619 COMENTO
                    FiltrosRiesgoRetenidoImpago(TemporalRec); //EX-SGG 200619

                    IF TemporalRec.FINDSET THEN
                        REPEAT
                            TemporalRec.CALCFIELDS("Asigna Cab");
                            Corregir(TemporalRec."Clave 1");
                            IF TemporalRec."Asigna Cab" THEN BEGIN
                                IF CabPedidoRec.GET(CabPedidoRec."Document Type"::Order, TemporalRec."Clave 1") THEN BEGIN
                                    //EX-SGG-WMS 110919 COMENTO Y ESTABLEZCO CANTIDADES A ENVIAR A 0
                                    //   {
                                    //         //EX-SGG 200619 COMENTO Y CREO ENVIO.
                                    //     {
                                    //         IF TemporalRec.Logistica THEN
                                    //           DocPick := cdPicking.Crear_Picking(TemporalRec.Almacen,
                                    //            CabPedidoRec."No.",OpcOrigen::PDA,OpcDestino::"Almac n Log stico", FALSE)
                                    //         ELSE
                                    //           DocPick := cdPicking.Crear_Picking(TemporalRec.Almacen,
                                    //            CabPedidoRec."No.",OpcOrigen::PDA,OpcDestino::Cliente, FALSE);
                                    //     }
                                    //         CLEAR(CduGetSrcOutBndWMS);
                                    //         CduGetSrcOutBndWMS.CreateFromSalesOrder(CabPedidoRec);
                                    //         //FIN EX-SGG 200619 COMENTO Y CREO ENVIO.
                                    //   }
                                    RstLinVenta.SETRANGE("Document Type", CabPedidoRec."Document Type");
                                    RstLinVenta.SETRANGE("Document No.", CabPedidoRec."No.");
                                    IF RstLinVenta.FINDSET THEN //EX-SGG-WMS 130919
                                        REPEAT
                                            RstLinVenta.f_NOcomprobar(TRUE);
                                            RstLinVenta.VALIDATE("Qty. to Ship", 0);
                                            RstLinVenta.MODIFY(TRUE);
                                            RstLinVenta.f_NOcomprobar(FALSE);
                                        UNTIL RstLinVenta.NEXT = 0;
                                END;
                                //FIN EX-SGG-WMS 110919

                                TemporalRec."Cod Picking" := DocPick;
                                TemporalRec.MODIFY;
                            END;
                        UNTIL TemporalRec.NEXT = 0;

                    TemporalRec.RESET;
                    TemporalRec.SETRANGE(Proceso, 'WMSLIN');
                    TemporalRec.SETRANGE(usuario, USERID);
                    TemporalRec.SETFILTER("Cantidad Asignada", '<>0');
                    TemporalRec.SETRANGE("Asigna Lin", TRUE);
                    IF TemporalRec.FINDFIRST THEN
                        REPEAT
                            TempAsignacion.RESET;
                            TempAsignacion.SETRANGE("Clave 1", TemporalRec."Clave 1");
                            TempAsignacion.SETRANGE(Proceso, 'WMSCAB');
                            TempAsignacion.SETRANGE(usuario, USERID);
                            //TempAsignacion.SETRANGE(PDA,TRUE); //EX-SGG 200619 COMENTO
                            FiltrosRiesgoRetenidoImpago(TempAsignacion); //EX-SGG 200619
                            IF TempAsignacion.FINDFIRST THEN BEGIN
                                TempAsignacion.CALCFIELDS(TempAsignacion."Asigna Cab");
                                IF TempAsignacion."Asigna Cab" THEN BEGIN
                                    //IF TemporalRec."Clave 6" = '' THEN
                                    //EX-SGG-WMS 110919 COMENTO Y ASIGNO A QTY. TO SHIP.
                                    //   {
                                    //              cdPicking.Reserva_Crear_L nea(TempAsignacion."Cod Picking",TemporalRec."Clave 1",
                                    //                                              TemporalRec.Linea,TemporalRec."Cantidad Asignada",
                                    //                                              TemporalRec."Clave 4",TemporalRec."Cod Variante",
                                    //                                              TemporalRec."Clave 5",TemporalRec."Clave 2",
                                    //                                              COPYSTR(TemporalRec.VarPreemb,4),
                                    //                                              OpcOrigen::PDA,TemporalRec."Fecha Servicio");
                                    //   }
                                    RstLinVenta.GET(RstLinVenta."Document Type"::Order, TemporalRec."Clave 1", TemporalRec.Linea);
                                    RstLinVenta.VALIDATE("Qty. to Ship", TemporalRec."Cantidad Asignada");
                                    RstLinVenta.MODIFY(TRUE);
                                    //FIN EX-SGG-WMS
                                END;
                            END;
                        UNTIL TemporalRec.NEXT = 0;

                    //EX-SGG 200619 COMENTO
                    //   {

                    //     pPrint.RESET;
                    //     pPrint.SETRANGE(pPrint."Report ID",0);
                    //     IF pPrint.FINDSET THEN
                    //       pPrint.DELETEALL(TRUE);

                    //   }

                    TemporalRec.RESET;
                    TemporalRec.SETRANGE(Proceso, 'WMSCAB');
                    TemporalRec.SETRANGE(usuario, USERID);
                    //TemporalRec.SETRANGE("Clave 1",'2422063');

                    //TemporalRec.SETRANGE(PDA,TRUE); //EX-SGG 200619 COMENTO
                    FiltrosRiesgoRetenidoImpago(TemporalRec); //EX-SGG 200619
                    IF TemporalRec.FINDFIRST THEN
                        REPEAT
                            CabPedidoRec.RESET;
                            CabPedidoRec.SETRANGE("Document Type", CabPedidoRec."Document Type"::Order);
                            CabPedidoRec.SETRANGE("No.", TemporalRec."Clave 1");
                            IF CabPedidoRec.FINDFIRST THEN BEGIN
                                //EX-SGG 200619 COMENTO
                                //   {
                                //         CLEAR(PedInforme);
                                //         //PedInforme.DePicking(TRUE,TemporalRec."Cod Picking");
                                //         //PedInforme.SETTABLEVIEW(TemporalRec);
                                //         PedInforme.USEREQUESTFORM(FALSE);
                                //         PedInforme.FuncVar(CabPedidoRec."No.");
                                //         PedInforme.RUNMODAL;
                                //   }
                                //EX-SGG-WMS 110919 GENERACION ENVIO ALMACEN
                                TemporalRec.CALCFIELDS("Asigna Cab");
                                IF TemporalRec."Asigna Cab" THEN BEGIN

                                    CreateFromSalesOrder(CabPedidoRec);
                                END;
                                //FIN EX-SGG-WMS 110919
                                TemporalRec.DELETE(TRUE);
                            END;
                        UNTIL TemporalRec.NEXT = 0;

                    CurrPage.UPDATE;
                END;
            }
        }
    }

    VAR
        Documentos: Integer;
        recTransferHeader: Record 5740;
        globalTransferCode: Code[20];
        CantidadPedTransferencia: Decimal;
        RstCabEnvio: Record "Warehouse Shipment Header";
        ReleaseTransferDocument: Codeunit 5708;
        CalcularRiesgoCliSinAlbaranes: Boolean;
        OpenRemainingAmtLCY: ARRAY[5] OF Decimal;
        FactPteImpag: decimal;
        RecTempLin: Record 50011;
        RecTempTallas: Record 50011;
        RecTempTallasMod: Record 50011;
        BtnGenerarEnviosWMENABLED: Boolean;
        RecUser: Record 91;
        Fecha: Text[30];
        Hora: Text[30];
        // ReportAlmB: Report 50086;
        // ReportAlmP: Report 50087;
        ConfContRec: Record 98;
        ConfVtas: Record 311;
        OutFile: File;
        FileName: Text[100];
        TemporalRec: Record 50011;
        CabPedidoRec: Record 36;
        EncuentraVend: Boolean;
        FlagExp: Code[1];
        Transportista: Code[10];
        RecFormaPago: Record 289;
        RecVendedor: Record 13;
        Coment1: Text[50];
        Coment2: Text[50];
        Comentario: Record 44;
        OutText: Text[250];
        FormaPago: Integer;
        CodBarras: Record "Item Reference";
        RiesgoDisp: Decimal;
        CUFunc: Codeunit 50000;
        ConfAlm: Record 5769;
        TempPicking: Record 50011;
        ConCantAsig: Boolean;
        TempAsign: Record 50011;
        PorcAsignado: Decimal;
        CantAsignModif: Integer;
        RecTallas2: Record 50011;
        FormLinVta: Page 46;
        DocPick: Code[20];
        TempAsignacion: Record 50011;
        //cdPicking: Codeunit 50005;
        PickingCab: Record 50007;
        LinAsign: Boolean;
        V: Dialog;
        //PedInforme: Report 50030;
        PreembIni: Code[20];
        TempRecPreemb: Record 50011;
        TempRecPreemb2: Record 50011;
        OpcOrigen: Option PDA,JMP,Manual;
        OpcDestino: Option Cliente,"Almacén Logístico";
        MovReserva: Record 50012;
        RecProd: Record 27;
        RecTempImporte: Record 50011;
        RecTempImpLin: Record 50011;
        pPrint: Record 78;
        RecCli: Record 18;
        RiesgoNM: Decimal;
        ColorRec: Record 96107;
        BloqueoCli: Record CustomerStatus;
        "--EX-V-SGG": Integer;
        RstLinVenta: Record 37;
        TemporalPV: Record 50011;
        lRecConsignmentCondition: Record 50051;
        i: Integer;
        n: Integer;
        Stock: Decimal;
        mpFactPteConsig2: Decimal;
        ImpAlb: Decimal;
        ImpAnul: Decimal;
        ImpPedPte: Decimal;
        ImpagRemRech: Decimal;
        ImpagRem: ARRAY[5] OF Decimal;
        ImpEnviosLanzados: Decimal;
        ImpEnviosSinLanzar: Decimal;
        ImpPedPteConsig: Decimal;
        ImpAnulConsig: Decimal;
        ImpPedTransferPdtServirConsig: Decimal;
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
        ImpagadosConsig: Decimal;

    trigger OnOpenPage()
    BEGIN
        Rec.FILTERGROUP(10);
        Rec.SETRANGE(Proceso, 'WMSCAB');
        Rec.FILTERGROUP(0);
        BtnGenerarEnviosWMENABLED := (FALSE);
    END;

    PROCEDURE CreateFromSalesOrder(SalesHeader: Record 36): Boolean;
    VAR
        WhseRqst: Record 5765;
        WhseShptHeader: Record "Warehouse Shipment Header";
        GetSourceDocuments: Report 5753;
        PfsCustomer: Record 18;
        PfsControl: Codeunit 96100;
        lRstTMPEnvioAlm: Record "Warehouse Shipment Line";
        recSalesLine: Record 37;
        LAlmacen: Code[20];
        TransferPostShipment: Codeunit 5704;
        TransferHeaderTemp: Record 5740 temporary;
        LineasPendientes: Boolean;
    BEGIN
        WITH SalesHeader DO BEGIN
            TESTFIELD(Status, Status::Released);
            // Pfs8.00
            PfsCustomer.GET("Sell-to Customer No.");
            PfsCustomer.CheckBlockedCustOnDocs(PfsCustomer, 16, FALSE, FALSE);
            // *TODO
            //CheckLocation(TRUE);

            IF SalesHeader."Ventas en consignacion" THEN BEGIN
                //EX.CGR.290920
                TransferHeaderTemp.DELETEALL;
                IF True THEN BEGIN
                    recSalesLine.SETRANGE("Document No.", SalesHeader."No.");
                    recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
                    recSalesLine.SETFILTER("Qty. to Ship", '<>0');
                    IF NOT recSalesLine.FINDFIRST THEN BEGIN
                        //        ERROR('No hay lineas con cantidad a enviar para transferir');
                        //3724 p6
                        Error('No hay lineas con cantidad a enviar para transferir');
                        EXIT(FALSE);
                    END;
                    //3724 p6 END

                    //EX-CV  -  JX  -  2021 06 18
                    recSalesLine.SETRANGE("Document No.", SalesHeader."No.");
                    recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
                    recSalesLine.SETFILTER("Qty. to Ship", '<>0');
                    IF recSalesLine.FINDSET THEN
                        REPEAT
                            //EX-JFC  051221 Incluir en el calculo la cantidad en transferencia y la cantidad anulada
                            recSalesLine.CALCFIELDS("Cantidad en consignacion", "Cantidad transferencia");
                            IF recSalesLine."Qty. to Ship" > (recSalesLine.Quantity - recSalesLine."Cantidad en consignacion" -
                            recSalesLine."Cantidad transferencia" - recSalesLine."Cantidad Anulada") THEN BEGIN
                                //EX-JFC FIN 051221 Incluir en el calculo la cantidad en transferencia y la cantidad anulada
                                //3724 p6
                                Error('No puede enviar ' + FORMAT(recSalesLine."Qty. to Ship") + ' unidades el producto ' +
                                  recSalesLine."No." + ' variante ' + recSalesLine."Variant Code");
                                EXIT(FALSE);
                            END;
                        //3724 p6 END
                        //ERROR('No puede enviar %1 unidades el producto %2 variante %3', recSalesLine."Qty. to Ship", recSalesLine."No.",
                        //recSalesLine."Variant Code");
                        UNTIL recSalesLine.NEXT = 0;
                    //EX-CV  -  JX  -  2021 06 18 END
                END ELSE BEGIN
                    recSalesLine.SETRANGE("Document No.", SalesHeader."No.");
                    recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
                    //EX-CV  -  2654  -  2021 02 24
                    //recSalesLine.SETFILTER("Outstanding Quantity",'<>0');
                    recSalesLine.SETFILTER(recSalesLine."Cant. Pte no anulada", '<>0');
                    LineasPendientes := TRUE;
                    IF recSalesLine.FINDSET THEN
                        REPEAT
                            //EX-JFC  051221 Incluir en el calculo la cantidad en transferencia y la cantidad anulada
                            recSalesLine.CALCFIELDS("Cantidad en consignacion", "Cantidad transferencia");
                            IF (recSalesLine."Cant. Pte no anulada" > recSalesLine."Cantidad transferencia") THEN
                                LineasPendientes := FALSE;
                        UNTIL recSalesLine.NEXT = 0;
                    //EX-CV  -  2654  -  2021 02 24 END

                    //EX-JFC  051221 Incluir en el calculo la cantidad en transferencia y la cantidad anulada
                    //IF NOT recSalesLine.FINDFIRST THEN
                    IF LineasPendientes THEN
                        //EX-JFC  051221 Incluir en el calculo la cantidad en transferencia y la cantidad anulada
                        //3724 p6
                        Error('No hay lineas con cantidad pendientes para transferir');
                    EXIT(FALSE);
                    //3724 p6 END
                    //ERROR('No hay lineas con cantidad pendientes para transferir');

                END;

                recSalesLine.RESET;
                recSalesLine.SETCURRENTKEY("Location Code");
                recSalesLine.SETRANGE("Document No.", SalesHeader."No.");
                recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
                IF recSalesLine.FINDSET THEN BEGIN
                    REPEAT
                        //EX-JFV 141221 Calculo si para los pedidos en consignacion existe cantidad pendiente de enviar
                        recSalesLine.CALCFIELDS("Cantidad transferencia");
                        IF (recSalesLine."Cant. Pte no anulada" > recSalesLine."Cantidad transferencia") THEN BEGIN
                            //EX-JFV 141221 Calculo si para los pedidos en consignacion existe cantidad pendiente de enviar
                            IF LAlmacen <> recSalesLine."Location Code" THEN BEGIN
                                CreateHeaderTransfer(recSalesLine);
                                CreateLinesTransfer(recSalesLine);
                            END ELSE
                                CreateLinesTransfer(recSalesLine);
                            LAlmacen := recSalesLine."Location Code";
                            //EX-JFV 141221 Calculo si para los pedidos en consignacion existe cantidad pendiente de enviar
                        END;
                    //EX-JFV FIN 141221 Calculo si para los pedidos en consignacion existe cantidad pendiente de enviar

                    //EX-CV  -  2708  -  2021 04 22
                    //EX-CV  -  2654  -  2021 02 24
                    //recSalesLine.OmmitStatus(TRUE);
                    //IF EsCantidadAEnviar THEN
                    //  recSalesLine.VALIDATE("Cantidad Anulada", (recSalesLine."Cantidad Anulada" + recSalesLine."Qty. to Ship"))
                    //ELSE
                    //  recSalesLine.VALIDATE("Cantidad Anulada", (recSalesLine."Cantidad Anulada" + recSalesLine."Cant. Pte no anulada"));
                    //recSalesLine."Outstanding Quantity");
                    //recSalesLine.MODIFY(FALSE);
                    //IF NOT EsCantidadAEnviar THEN BEGIN
                    //  recSalesLine.OmmitStatus(TRUE);
                    //  recSalesLine.VALIDATE("Cantidad Anulada", (recSalesLine."Cantidad Anulada" + recSalesLine."Cant. Pte no anulada"));
                    //  recSalesLine.MODIFY(FALSE);
                    //END;
                    //EX-CV  -  2708  -  2021 04 22 END
                    //EX-CV  -  2654  -  2021 02 24 END
                    UNTIL recSalesLine.NEXT = 0;

                    IF false THEN //3536 - MEP 2022 02 14
                        MESSAGE('Pedidos de transferencia creados:\');//+Documentos);

                    IF TransferHeaderTemp.FINDSET THEN
                        REPEAT
                            recTransferHeader.GET(TransferHeaderTemp."No.");
                            ReleaseTransferDocument.RUN(recTransferHeader);
                            CreateFromOutbndTransferOrder(recTransferHeader);
                        UNTIL TransferHeaderTemp.NEXT = 0;
                END;
            END ELSE BEGIN
                WhseRqst.SETRANGE(Type, WhseRqst.Type::Outbound);
                WhseRqst.SETRANGE("Source Type", DATABASE::"Sales Line");
                WhseRqst.SETRANGE("Source Subtype", "Document Type");
                WhseRqst.SETRANGE("Source No.", "No.");
                WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
                WhseRqst.SETRANGE("Completely Handled", FALSE); //EX-SGG-WMS 250919

                IF WhseRqst.FIND('-') THEN BEGIN
                    //GetSourceDocuments.USEREQUESTFORM(FALSE);
                    GetSourceDocuments.SETTABLEVIEW(WhseRqst);
                    GetSourceDocuments.SetHideDialog(false); //EX-SGG-WMS 180719
                                                             //GetSourceDocuments.EnvioAlmacenCantidadAEnviar(EsCantidadAEnviar); //EX-SGG-WMS 040919
                    GetSourceDocuments.RUNMODAL;

                    //EX-SGG 040620
                    IF lRstTMPEnvioAlm.FINDFIRST THEN BEGIN
                        //3724 p6
                        Error('Variable temporal con registros');
                        EXIT(FALSE);
                        //ERROR('Variable temporal con registros');
                    END;
                    //3724 p6 END
                    //GetSourceDocuments.DevuelveEnviosAlmGenerados(lRstTMPEnvioAlm);
                    IF lRstTMPEnvioAlm.FINDSET THEN
                        REPEAT
                            WhseShptHeader.GET(lRstTMPEnvioAlm."No.");
                            //FIN EX-SGG 040620
                            // EstableceTipoyCodOrigenEnEnvio(WhseShptHeader,WhseShptHeader."Tipo origen"::Cliente,
                            //  "Sell-to Customer No.");//EX-SGG-WMS 170619
                            //EX-SGG-WMS 190619
                            WhseShptHeader.VALIDATE("External Document No.", "External Document No.");
                            WhseShptHeader.VALIDATE("Fecha servicio solicitada", "Fecha servicio solicitada");
                            WhseShptHeader.VALIDATE("Ship-to Name", "Ship-to Name");
                            WhseShptHeader.VALIDATE("Ship-to Name 2", "Ship-to Name 2");
                            WhseShptHeader.VALIDATE("Ship-to Address", "Ship-to Address");
                            WhseShptHeader.VALIDATE("Ship-to Address 2", "Ship-to Address 2");
                            WhseShptHeader.VALIDATE("Ship-to City", "Ship-to City");
                            WhseShptHeader.VALIDATE("Ship-to Post Code", "Ship-to Post Code");
                            WhseShptHeader.VALIDATE("Ship-to County", "Ship-to County");
                            WhseShptHeader.VALIDATE("Ship-to Country/Region Code", "Ship-to Country/Region Code");
                            //EX-SGG-WMS 170719
                            WhseShptHeader.VALIDATE("Sell-to Customer Name", "Sell-to Customer Name");
                            WhseShptHeader.VALIDATE("Sell-to Customer Name 2", "Sell-to Customer Name 2");
                            WhseShptHeader.VALIDATE("Sell-to Address", "Sell-to Address");
                            WhseShptHeader.VALIDATE("Sell-to Address 2", "Sell-to Address 2");
                            WhseShptHeader.VALIDATE("Sell-to City", "Sell-to City");
                            WhseShptHeader.VALIDATE("Sell-to Post Code", "Sell-to Post Code");
                            WhseShptHeader.VALIDATE("Sell-to County", "Sell-to County");
                            WhseShptHeader.VALIDATE("Sell-to Country/Region Code", "Sell-to Country/Region Code");
                            //FIN EX-SGG-WMS 170719
                            WhseShptHeader."Shipping Agent Code" := "Shipping Agent Code"; //EX-SGG-WMS 071119
                            WhseShptHeader."Shipping Agent Service Code" := "Shipping Agent Service Code"; //EX-SGG-WMS 071119
                            WhseShptHeader.MODIFY(TRUE);
                        //FIN EX-SGG-WMS 190619
                        // EstableceTipoEntrega(WhseShptHeader,SalesHeader."No."); //EX-SGG-WMS 110719
                        UNTIL lRstTMPEnvioAlm.NEXT = 0; //EX-SGG 040620

                    GetSourceDocuments.GetLastShptHeader(WhseShptHeader);

                    //   IF False THEN //EX-SGG-WMS 180719
                    //    Page.RUN(Page::"Warehouse Shipment WMS",WhseShptHeader);
                    RstCabEnvio := WhseShptHeader; //EX-SGG-WMS 180719
                END
                ELSE BEGIN //EX-SGG-WMS 250919
                           //3724 p6
                    Error('No existe ' + WhseRqst.TABLECAPTION + ':\' + WhseRqst.GETFILTERS);
                    EXIT(FALSE);

                    //ERROR('No existe '+WhseRqst.TABLECAPTION+':\'+WhseRqst.GETFILTERS);
                    //3724 p6 END
                END;
            END;
        END;

        //EX-CV
        //UpdateFieldTEntrega(SalesHeader);
        //CheckTransfersLines;

        IF SalesHeader."Ventas en consignacion" THEN BEGIN
            recSalesLine.RESET;
            recSalesLine.SETRANGE("Document No.", SalesHeader."No.");
            IF recSalesLine.FINDSET THEN
                REPEAT
                    recSalesLine.CALCFIELDS("Cantidad en consignacion", "Cantidad transferencia");
                    IF recSalesLine."Cant. Pte no anulada" <> (recSalesLine."Outstanding Quantity" - recSalesLine."Cantidad en consignacion" -
                                                               recSalesLine."Cantidad Anulada") THEN BEGIN
                        recSalesLine."Cant. Pte no anulada" := recSalesLine."Outstanding Quantity" - recSalesLine."Cantidad en consignacion" -
                                                               recSalesLine."Cantidad Anulada";

                        recSalesLine.MODIFY(FALSE);
                    END;
                UNTIL recSalesLine.NEXT = 0;
        END;
        //EX-CV END
        //3724 p6
        EXIT(TRUE);
        //3724 p6 END
    END;


    // OnActivateForm=BEGIN

    //                  CurrPage.BtnGenerarEnviosWMS.ENABLED(FALSE);
    //                END;

    // OnDeactivateForm=BEGIN

    //                    CurrPage.BtnGenerarEnviosWMS.ENABLED(FALSE);
    //                  END;
    PROCEDURE CreateHeaderTransfer(SalesLine2: Record 37);
    VAR
        recInventorySetup: Record 313;
        NoSeriesMgnt: Codeunit 396;
        recSalesHeader: Record 36;
        //lCduWMS : Codeunit 50409;
        NoLinea: Integer;
    BEGIN
        //EX.CGR.290920
        recInventorySetup.GET;
        recInventorySetup.TESTFIELD("Serie pedido transf. consig.");
        recTransferHeader.INIT;
        recTransferHeader."No." := NoSeriesMgnt.GetNextNo(recInventorySetup."Serie pedido transf. consig.", WORKDATE, TRUE);
        recTransferHeader.INSERT(TRUE);
        recTransferHeader.VALIDATE("Transfer-from Code", SalesLine2."Location Code");
        recTransferHeader.VALIDATE("Transfer-to Code", SalesLine2."Cod. almacen consignacion");
        recTransferHeader.VALIDATE("In-Transit Code", recInventorySetup."Almacen transito consignacion");
        recTransferHeader.VALIDATE("Shortcut Dimension 1 Code", SalesLine2."Shortcut Dimension 1 Code");
        recTransferHeader.VALIDATE("Shortcut Dimension 2 Code", SalesLine2."Shortcut Dimension 2 Code");
        recTransferHeader."Ventas en consignacion" := TRUE;
        recTransferHeader."Cod. cliente" := SalesLine2."Sell-to Customer No.";
        recTransferHeader."No. pedido venta" := SalesLine2."Document No.";
        recTransferHeader."Assigned User ID" := USERID;
        recSalesHeader.GET(SalesLine2."Document Type", SalesLine2."Document No.");
        recTransferHeader."Nombre cliente" := recSalesHeader."Sell-to Customer Name";
        recTransferHeader."Sell-to Customer Name" := recSalesHeader."Sell-to Customer Name";
        recTransferHeader."Sell-to Customer Name 2" := recSalesHeader."Sell-to Customer Name 2";
        recTransferHeader."Sell-to Address" := recSalesHeader."Sell-to Address";
        recTransferHeader."Sell-to Address 2" := recSalesHeader."Sell-to Address 2";
        recTransferHeader."Sell-to City" := recSalesHeader."Sell-to City";
        recTransferHeader."Sell-to Contact" := recSalesHeader."Sell-to Contact";
        recTransferHeader."Sell-to Post Code" := recSalesHeader."Sell-to Post Code";
        recTransferHeader."Sell-to County" := recSalesHeader."Sell-to County";
        recTransferHeader."Sell-to Country/Region Code" := recSalesHeader."Sell-to Country/Region Code";
        recTransferHeader."Ship-to Name" := recSalesHeader."Ship-to Name";
        recTransferHeader."Ship-to Name 2" := recSalesHeader."Ship-to Name 2";
        recTransferHeader."Ship-to Address" := recSalesHeader."Ship-to Address";
        recTransferHeader."Ship-to Address 2" := recSalesHeader."Ship-to Address 2";
        recTransferHeader."Ship-to City" := recSalesHeader."Ship-to City";
        recTransferHeader."Ship-to Post Code" := recSalesHeader."Ship-to Post Code";
        recTransferHeader."Ship-to County" := recSalesHeader."Ship-to County";
        recTransferHeader."Ship-to Country/Region Code" := recSalesHeader."Ship-to Country/Region Code";
        recTransferHeader."External Document No." := recSalesHeader."External Document No.";
        recTransferHeader."Shipping Agent Code" := recSalesHeader."Shipping Agent Code";
        recTransferHeader."Fecha pedido" := recSalesHeader."Order Date";
        recTransferHeader."Cod. representante" := recSalesHeader."Salesperson Code";
        //EX-CV
        //recTransferHeader."Tipo de entrega" := recSalesHeader."Tipo de entrega";

        //  recTransferHeader.VALIDATE("Tipo de entrega", recSalesHeader."Tipo de entrega"); TODO VERO
        IF recTransferHeader."Tipo de entrega" = '' THEN
            recTransferHeader.VALIDATE("Tipo de entrega", '1');

        IF (recTransferHeader."Tipo de entrega" = '1') //AND
                                                       // (lCduWMS.ExistenLinsAsignacionDirecta(recTransferHeader.TABLENAME, recTransferHeader."No.")) 
          THEN
            recTransferHeader.VALIDATE("Tipo de entrega", '7');

        IF false THEN
            recTransferHeader."Envio total" := TRUE;

        //EX-CV END
        recTransferHeader.MODIFY;
        //Documentos+=recTransferHeader."No."+'\';
        //   IF VerificaAlmSEGA(SalesLine2."Location Code") THEN BEGIN
        //       TransferHeaderTemp:=recTransferHeader;
        //       TransferHeaderTemp.INSERT;
        //   END;
    END;

    PROCEDURE CreateFromOutbndTransferOrder(TransHeader: Record 5740);
    VAR
        WhseRqst: Record 5765;
        WhseShptHeader: Record "Warehouse Shipment Header";
        GetSourceDocuments: Report 5753;
        "--EX-WMS": Integer;
        lRstTMPEnvioAlm: Record "Warehouse Shipment Line" temporary;
    BEGIN
        WITH TransHeader DO BEGIN
            TESTFIELD(Status, Status::Released);
            WhseRqst.SETRANGE(Type, WhseRqst.Type::Outbound);
            WhseRqst.SETRANGE("Source Type", DATABASE::"Transfer Line");
            WhseRqst.SETRANGE("Source Subtype", 0);
            WhseRqst.SETRANGE("Source No.", "No.");
            WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
            WhseRqst.SETRANGE("Completely Handled", FALSE); //EX-SGG-WMS 250919

            IF WhseRqst.FIND('-') THEN BEGIN
                //GetSourceDocuments.USEREQUESTFORM(FALSE);
                GetSourceDocuments.SETTABLEVIEW(WhseRqst);
                GetSourceDocuments.SetHideDialog(true);//3536 - MEP - 2022 02 15
                GetSourceDocuments.RUNMODAL;

                //EX-SGG 040620
                //   IF lRstTMPEnvioAlm.FINDFIRST THEN ERROR('Variable temporal con registros');
                //   GetSourceDocuments.DevuelveEnviosAlmGenerados(lRstTMPEnvioAlm);
                IF lRstTMPEnvioAlm.FINDSET THEN
                    REPEAT
                        WhseShptHeader.GET(lRstTMPEnvioAlm."No.");
                    //FIN EX-SGG 040620

                    //3659 - APR - 2022 05 17 - Se hizo la modificaci n del  ltimo par metro para que a "Cod. origen" se le asigne "Cod Cliente"
                    //EstableceTipoyCodOrigenEnEnvio(WhseShptHeader,WhseShptHeader."Tipo origen"::Cliente,WhseShptHeader."Cod Cliente");
                    //3659 - APR - 2022 05 17 - Se hizo la modificaci n del  ltimo par metro para que a "Cod. origen" se le asigne "Cod Cliente"

                    //EX-SGG-WMS 270919
                    UNTIL lRstTMPEnvioAlm.NEXT = 0; //EX-SGG 040620

                GetSourceDocuments.GetLastShptHeader(WhseShptHeader);
                //   IF NOT SinVentanas THEN //3536 - MEP 2022 02 14
                //     FORM.RUN(FORM::"Warehouse Shipment WMS",WhseShptHeader);
            END
            ELSE //EX-SGG-WMS 250919
                ERROR('No existe ' + WhseRqst.TABLECAPTION + ':\' + WhseRqst.GETFILTERS);

        END;
    END;


    PROCEDURE CreateLinesTransfer(SalesLine2: Record 37);
    VAR
        _recTransferLineAux: Record 5741;
        recTransferLine: Record 5741;
        NoLinea: Integer;
    BEGIN
        //EX.CGR.290920
        //EX-CV  -  2742  -  2021 05 26
        IF true THEN
            IF SalesLine2."Qty. to Ship" = 0 THEN
                EXIT;
        //EX-CV  -  2742  -  2021 05 26 END
        recTransferLine.INIT;
        recTransferLine."Document No." := recTransferHeader."No.";
        NoLinea += 10000;
        recTransferLine."Line No." := NoLinea;
        recTransferLine.INSERT(TRUE);

        recTransferLine.VALIDATE("Item No.", SalesLine2."No.");
        recTransferLine.VALIDATE("Variant Code", SalesLine2."Variant Code");
        IF SalesLine2."Bin Code" <> '' THEN
            recTransferLine.VALIDATE("Transfer-from Bin Code", SalesLine2."Bin Code");
        recTransferLine.VALIDATE("Shortcut Dimension 1 Code", SalesLine2."Shortcut Dimension 1 Code");
        recTransferLine.VALIDATE("Shortcut Dimension 2 Code", SalesLine2."Shortcut Dimension 2 Code");
        recTransferLine."No. pedido" := SalesLine2."Document No.";
        recTransferLine."No. linea pedido" := SalesLine2."Line No.";
        recTransferLine."Bulto No." := 1;
        recTransferLine."PfsMatrix Line No." := SalesLine2."PfsMatrix Line No.";
        recTransferLine.PfsSubline := SalesLine2.PfsSubline;
        //   recTransferLine.PfsSorting:=SalesLine2.PfsSorting;
        //   recTransferLine."PfsMatrix Quantity":=SalesLine2."PfsMatrix Quantity";
        //   recTransferLine."PfsMatrix Qty. To Ship":=SalesLine2."PfsMatrix Qty. to Ship";

        //Comentado Jorge
        IF true THEN BEGIN
            recTransferLine.VALIDATE(Quantity, SalesLine2."Qty. to Ship");
            //  {
            //  SalesLine2."Quantity Shipped" :=SalesLine2."Quantity Shipped" +SalesLine2."Qty. to Ship";
            //  SalesLine2."Qty. to Ship (Base)":=SalesLine2."Quantity Shipped";
            //  SalesLine2."Qty. Shipped (Base)" :=SalesLine2."Qty. Shipped (Base)" +SalesLine2."Qty. to Ship (Base)";
            //  SalesLine2.InitOutstanding;
            //  SalesLine2.VALIDATE("Qty. to Ship",0);
            //  SalesLine2.MODIFY;
            //  }
        END ELSE BEGIN
            //EX-CV  -  2654  -  2021 02 24
            //recTransferLine.VALIDATE(Quantity,SalesLine2."Outstanding Quantity");
            //EX-CV  -  2708  -  2021 05 05

            //recTransferLine.VALIDATE(Quantity,SalesLine2."Cant. Pte no anulada");

            CantidadPedTransferencia := 0;
            //EX-JFC  051221 Incluir en el calculo la cantidad en transferencia y la cantidad anulada
            SalesLine2.CALCFIELDS("Cantidad en consignacion", "Cantidad transferencia");
            CantidadPedTransferencia := (SalesLine2.Quantity - SalesLine2."Cantidad en consignacion" -
            SalesLine2."Cantidad transferencia" - SalesLine2."Cantidad Anulada");

            recTransferLine.VALIDATE(Quantity, CantidadPedTransferencia);
            //EX-JFC FIN 051221 Incluir en el calculo la cantidad en transferencia y la cantidad anulada


            SalesLine2."Cant. Pte no anulada" := 0;
            SalesLine2.MODIFY;
            //EX-CV  -  2708  -  2021 05 05 END
            //EX-CV  -  2654  -  2021 02 24 END
            //  {
            //  SalesLine2."Quantity Shipped" :=SalesLine2."Quantity Shipped" +SalesLine2."Outstanding Quantity";
            //  SalesLine2."Qty. to Ship (Base)":=SalesLine2."Quantity Shipped";
            //  SalesLine2."Qty. Shipped (Base)" :=SalesLine2."Qty. Shipped (Base)" +SalesLine2."Qty. to Ship (Base)";
            //  SalesLine2.InitOutstanding;
            //  SalesLine2.VALIDATE("Qty. to Ship",0);
            //  SalesLine2.MODIFY;
            //  }
        END;
        //Comentado Jorge END

        //EX-CV
        globalTransferCode := recTransferLine."Document No.";
        //EX-CV END

        recTransferLine.MODIFY;
    END;


    trigger OnAfterGetRecord()
    BEGIN
        //    {
        //    RiesgoDisp := CUFunc.RiesgoCliente("Clave 3");

        //    ConCantAsig := FALSE;
        //    CantAsignModif := 0;
        //    TempAsign.RESET;
        //    TempAsign.SETRANGE("Clave 1","Clave 1");
        //    TempAsign.SETRANGE("Clave 3","Clave 3");
        //    TempAsign.SETRANGE(Proceso,'WMSTALLAS');
        //    //TempAsign.SETRANGE(usuario,USERID);
        //    TempAsign.SETRANGE("Asigna Lin",TRUE);
        //    IF TempAsign.FINDFIRST THEN BEGIN
        //      REPEAT
        //            CantAsignModif +=
        //            TempAsign."17 Asig" + TempAsign."18 Asig" + TempAsign."19 Asig" +
        //            TempAsign."20 Asig" + TempAsign."21 Asig" + TempAsign."22 Asig" +
        //            TempAsign."23 Asig" + TempAsign."24 Asig" + TempAsign."25 Asig" +
        //            TempAsign."26 Asig" + TempAsign."27 Asig" + TempAsign."28 Asig" +
        //            TempAsign."29 Asig" + TempAsign."30 Asig" + TempAsign."31 Asig" +
        //            TempAsign."32 Asig" + TempAsign."33 Asig" + TempAsign."34 Asig" +
        //            TempAsign."35 Asig" + TempAsign."36 Asig" + TempAsign."37 Asig" +
        //            TempAsign."38 Asig" + TempAsign."39 Asig" + TempAsign."40 Asig" +
        //            TempAsign."41 Asig" + TempAsign."42 Asig" + TempAsign."43 Asig" +
        //            TempAsign."44 Asig" + TempAsign."45 Asig" + TempAsign."46 Asig" +
        //            TempAsign."47 Asig" + TempAsign."48 Asig" + TempAsign."49 Asig";
        //      UNTIL TempAsign.NEXT = 0;
        //    END ELSE BEGIN
        //      CantAsignModif := 0;
        //    END;

        //    PorcAsignado := 0;
        //    IF CantAsignModif = 0 THEN BEGIN
        //     IF ("Cantidad Pendiente"-"Cantidad Anulada"-"Cantidad Picking"-"Cantidad Reserva") <> 0 THEN BEGIN
        //        PorcAsignado := ("Cantidad Asignada"/("Cantidad Pendiente"-"Cantidad Anulada"-"Cantidad Picking"-"Cantidad Reserva"))*100;
        //     END
        //    END ELSE BEGIN
        //     IF ("Cantidad Pendiente"-"Cantidad Anulada"-"Cantidad Picking"-"Cantidad Reserva") <> 0 THEN BEGIN
        //        PorcAsignado := (CantAsignModif/("Cantidad Pendiente"-"Cantidad Anulada"-"Cantidad Picking"-"Cantidad Reserva"))*100;
        //     END;
        //    END;
        //    }
    END;



    PROCEDURE CalculoStock(Modelo: Code[20]; Color: Code[20]; Talla: Code[20]; CodPreemb: Code[20]): Decimal;
    VAR
        RecStock: Record 32;
        PfsSetup: Record "SetupTallas";
        Code: Text;
    BEGIN

        ConfAlm.GET;
        Stock := 0;
        RecProd.RESET;
        RecProd.SETRANGE("No.", Modelo);
        PfsSetup.Get();
        Code := Color + PfsSetup."Variant Separador" + Talla;
        RecProd.SETFILTER("Variant Filter", Code);

        //RecProd.SETRANGE("Filtro Preembalado", CodPreemb);

        IF CodPreemb = '' THEN
            //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
            //RecProd.SETRANGE("Location Filter",ConfAlm."Almacen Envio Generico")
            //RecProd.SETRANGE("Location Filter",ConfAlm."Almacen predet. SEGA")
            //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
            RecProd.SETFILTER("Location Filter", FiltroAlmacenesSEGA()); //EX-SGG-WMS 100919
        // ELSE
        //     RecProd.SETRANGE("Location Filter", ConfAlm."Almacen Preembalado");

        IF RecProd.FINDFIRST THEN BEGIN
            RecProd.CALCFIELDS(Inventory);
            Stock := RecProd.Inventory;
        END;
        EXIT(Stock);
    END;

    PROCEDURE CalculoReserva(DocRes: Code[20]; LineaRes: Integer): Integer;
    VAR
        MovReserva: Record 50012;
        CantRes: Decimal;
    BEGIN
        //reserva del documento
        CantRes := 0;
        MovReserva.RESET;
        MovReserva.SETCURRENTKEY("Origen Documento No.", "Origen Documento Line No.");
        MovReserva.SETRANGE("Origen Documento No.", DocRes);
        MovReserva.SETRANGE("Origen Documento Line No.", LineaRes);
        IF MovReserva.FINDFIRST THEN
            MovReserva.CALCSUMS("Cantidad Reservada");
        //REPEAT
        //CantRes += MovReserva."Cantidad Reservada";
        //UNTIL MovReserva.NEXT = 0;
        //EXIT(CantRes);
        EXIT(MovReserva."Cantidad Reservada");
    END;

    PROCEDURE CalculoReserva2(Modelo: Code[20]; Color: Code[20]; Talla: Code[20]; CodPreemb: Code[20]): Decimal;
    VAR
        Res2: Integer;
        PfsSetup: Record "SetupTallas";
        Code: Text;
    BEGIN

        ConfAlm.GET;
        Stock := 0;
        RecProd.RESET;
        RecProd.SETRANGE("No.", Modelo);
        PfsSetup.Get();
        Code := Color + PfsSetup."Variant Separador" + Talla;
        RecProd.SETFILTER("Variant Filter", Code);
        //RecProd.SETRANGE("Filtro Preembalado", CodPreemb);
        IF RecProd.FINDFIRST THEN BEGIN
            //RecProd.CALCFIELDS("Cantidad Reserva Picking");
            //Res2 := RecProd."Cantidad Reserva Picking";
        END;
        EXIT(Res2);
    END;

    PROCEDURE CantPicking(Modelo: Code[20]; Color: Code[20]; Talla: Code[20]; CodPreemb: Code[20]): Integer;
    VAR
        CantidadPicking: Integer;
    // PickingResumen: Record 50010;
    BEGIN
        //picking de producto
        ConfAlm.GET;
        CantidadPicking := 0;
        // PickingResumen.RESET;
        // PickingResumen.SETCURRENTKEY("Pedido Item No.", Pendiente, Color, Talla, "Pedido Prepack Code", "Almac n Actual");
        // PickingResumen.SETFILTER("Pedido Item No.", Modelo);
        // PickingResumen.SETRANGE(Pendiente, TRUE);
        // PickingResumen.SETRANGE(Color, Color);
        // PickingResumen.SETRANGE(Talla, Talla);
        // PickingResumen.SETRANGE("Pedido Prepack Code", CodPreemb);

        // IF CodPreemb = '' THEN
        //     PickingResumen.SETRANGE("Almac n Actual", ConfAlm."Almacen Envio Generico")
        // ELSE
        //     PickingResumen.SETRANGE("Almac n Actual", ConfAlm."Almacen Preembalado");


        // IF PickingResumen.FINDFIRST THEN
        //     REPEAT
        //         CantidadPicking += PickingResumen.Cantidad - PickingResumen."Cantidad Enviada";
        //     UNTIL PickingResumen.NEXT = 0;
        EXIT(CantidadPicking);
    END;

    PROCEDURE Corregir(CabClave1: Code[20]);
    VAR
        TempLin: Record 50011;
        TT: Record 50011;
    BEGIN
        TempLin.RESET;
        TempLin.SETCURRENTKEY("Clave 1", Proceso);
        TempLin.SETRANGE("Clave 1", CabClave1);
        TempLin.SETRANGE(Proceso, 'WMSLIN');
        IF TempLin.FINDFIRST THEN
            REPEAT
                TT.RESET;
                TT.SETCURRENTKEY("Clave 1", "Clave 4", "Clave 5", "Clave 6", Proceso);
                TT.SETRANGE("Clave 1", CabClave1);
                TT.SETRANGE("Clave 4", TempLin."Clave 4");
                TT.SETRANGE("Clave 5", TempLin."Clave 5");
                TT.SETRANGE("Clave 6", TempLin."Clave 6");
                TT.SETRANGE(Proceso, 'WMSTALLAS');
                IF TT.FINDFIRST THEN BEGIN
                    TempLin."Asigna Lin" := TT."Asigna Lin";
                    TempLin.MODIFY;
                    IF TempLin."Clave 2" = '17' THEN BEGIN
                        IF TT."17 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."17 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '18' THEN BEGIN
                        IF TT."18 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."18 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '19' THEN BEGIN
                        IF TT."19 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."19 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '20' THEN BEGIN
                        IF TT."20 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."20 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '21' THEN BEGIN
                        IF TT."21 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."21 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '22' THEN BEGIN
                        IF TT."22 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."22 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '23' THEN BEGIN
                        IF TT."23 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."23 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '24' THEN BEGIN
                        IF TT."24 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."24 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '25' THEN BEGIN
                        IF TT."25 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."25 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '26' THEN BEGIN
                        IF TT."26 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."26 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '27' THEN BEGIN
                        IF TT."27 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."27 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '28' THEN BEGIN
                        IF TT."28 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."28 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '29' THEN BEGIN
                        IF TT."29 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."29 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '30' THEN BEGIN
                        IF TT."30 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."30 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '31' THEN BEGIN
                        IF TT."31 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."31 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '32' THEN BEGIN
                        IF TT."32 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."32 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '33' THEN BEGIN
                        IF TT."33 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."33 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '34' THEN BEGIN
                        IF TT."34 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."34 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '35' THEN BEGIN
                        IF TT."35 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."35 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '36' THEN BEGIN
                        IF TT."36 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."36 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '37' THEN BEGIN
                        IF TT."37 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."37 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '38' THEN BEGIN
                        IF TT."38 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."38 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '39' THEN BEGIN
                        IF TT."39 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."39 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '40' THEN BEGIN
                        IF TT."40 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."40 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '41' THEN BEGIN
                        IF TT."41 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."41 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '42' THEN BEGIN
                        IF TT."42 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."42 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '43' THEN BEGIN
                        IF TT."43 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."43 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '44' THEN BEGIN
                        IF TT."44 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."44 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '45' THEN BEGIN
                        IF TT."45 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."45 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '46' THEN BEGIN
                        IF TT."46 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."46 Asig";
                            TempLin.MODIFY;
                        END;
                    END;
                    IF TempLin."Clave 2" = '47' THEN BEGIN
                        IF TT."47 Asig" <> TempLin."Cantidad Asignada" THEN BEGIN
                            TempLin."Cantidad Asignada" := TT."47 Asig";
                            TempLin.MODIFY;
                        END;
                    END;


                END;
            UNTIL TempLin.NEXT = 0;
    END;

    PROCEDURE "--EX-F-SGG"();
    BEGIN
    END;

    PROCEDURE FiltrosRiesgoRetenidoImpago(VAR lRstTemporalPV: Record 50011);
    BEGIN
        //EX-SGG-WMS 200619
        lRstTemporalPV.SETRANGE("Supera Riesgo", FALSE);
        lRstTemporalPV.SETRANGE(Retenido, FALSE);
        lRstTemporalPV.SETRANGE("Impago Cliente", FALSE);
    END;

    PROCEDURE FiltroAlmacenesSEGA() lFiltroAlmacenes: Text[250];
    VAR
        lRstAlmacenes: Record 14;
    BEGIN
        //EX-SGG-WMS 100919
        lRstAlmacenes.SETRANGE("Clase de Stock SEGA", '1');
        lRstAlmacenes.SETRANGE("Estado Calidad SEGA", '0');
        // lRstAlmacenes.SETRANGE("Stock no gestionado por SEGA", FALSE);
        lRstAlmacenes.SETRANGE(Ecommerce, FALSE);
        lRstAlmacenes.SETRANGE(Reservado, FALSE);
        lRstAlmacenes.SETRANGE(Servicio, TRUE);
        lRstAlmacenes.FINDSET;
        REPEAT
            lFiltroAlmacenes += lRstAlmacenes.Code + '|';
        UNTIL lRstAlmacenes.NEXT = 0;
        lFiltroAlmacenes := COPYSTR(lFiltroAlmacenes, 1, STRLEN(lFiltroAlmacenes) - 1);
    END;

    PROCEDURE ExistenLineasAsignadas(lClave1: Code[20]; lProceso: Code[10]; lUsuario: Code[20]): Boolean;
    VAR
        lRstLinAsign: Record 50011;
    BEGIN
        //EX-SGG-WMS 230919
        lRstLinAsign.SETCURRENTKEY("Clave 1", Proceso, usuario);
        lRstLinAsign.SETRANGE("Clave 1", lClave1);
        lRstLinAsign.SETRANGE(Proceso, lProceso);
        lRstLinAsign.SETRANGE(usuario, lUsuario);
        lRstLinAsign.SETRANGE("Asigna Lin", TRUE);
        EXIT(lRstLinAsign.FINDFIRST);
    END;

    PROCEDURE LineasProposicionNormal();
    BEGIN
        //+EX-SGG 091222
        IF Rec."Tipo proposicion calculada" = Rec."Tipo proposicion calculada"::" " THEN BEGIN
            Rec."Tipo proposicion calculada" := Rec."Tipo proposicion calculada"::Normal;
            Rec.MODIFY();
        END;
        //-EX-SGG 091222

        //codigo real
        BtnGenerarEnviosWMENABLED := (FALSE);

        RecUser.GET(USERID);
        IF NOT RecUser."Proposicion Venta" THEN BEGIN

            V.OPEN('Pte servir a cero');
            RecTempLin.RESET;
            RecTempLin.SETCURRENTKEY(Proceso, usuario, "Insertado 2");
            RecTempLin.SETRANGE(Proceso, 'WMSTALLAS');
            RecTempLin.SETRANGE(usuario, USERID);
            RecTempLin.SETRANGE("Insertado 2", FALSE);
            IF RecTempLin.FINDFIRST THEN
                REPEAT
                    RecTempLin."17 Pte Servir" := 0;
                    RecTempLin."18 Pte Servir" := 0;
                    RecTempLin."19 Pte Servir" := 0;
                    RecTempLin."20 Pte Servir" := 0;
                    RecTempLin."21 Pte Servir" := 0;
                    RecTempLin."22 Pte Servir" := 0;
                    RecTempLin."23 Pte Servir" := 0;
                    RecTempLin."24 Pte Servir" := 0;
                    RecTempLin."25 Pte Servir" := 0;
                    RecTempLin."26 Pte Servir" := 0;
                    RecTempLin."27 Pte Servir" := 0;
                    RecTempLin."28 Pte Servir" := 0;
                    RecTempLin."29 Pte Servir" := 0;
                    RecTempLin."30 Pte Servir" := 0;
                    RecTempLin."31 Pte Servir" := 0;
                    RecTempLin."32 Pte Servir" := 0;
                    RecTempLin."33 Pte Servir" := 0;
                    RecTempLin."34 Pte Servir" := 0;
                    RecTempLin."35 Pte Servir" := 0;
                    RecTempLin."36 Pte Servir" := 0;
                    RecTempLin."37 Pte Servir" := 0;
                    RecTempLin."38 Pte Servir" := 0;
                    RecTempLin."39 Pte Servir" := 0;
                    RecTempLin."40 Pte Servir" := 0;
                    RecTempLin."41 Pte Servir" := 0;
                    RecTempLin."42 Pte Servir" := 0;
                    RecTempLin."43 Pte Servir" := 0;
                    RecTempLin."44 Pte Servir" := 0;
                    RecTempLin."45 Pte Servir" := 0;
                    RecTempLin."46 Pte Servir" := 0;
                    RecTempLin."47 Pte Servir" := 0;
                    RecTempLin."48 Pte Servir" := 0;
                    RecTempLin."49 Pte Servir" := 0;
                    RecTempLin.MODIFY;
                UNTIL RecTempLin.NEXT = 0;
            V.CLOSE;

            V.OPEN('C lculo Stock:#1######');
            RecTempLin.RESET;
            RecTempLin.SETCURRENTKEY(Proceso, usuario, "Insertado 2");
            RecTempLin.SETRANGE(Proceso, 'WMSLIN');
            RecTempLin.SETRANGE(usuario, USERID);
            RecTempLin.SETRANGE("Insertado 2", FALSE);
            IF RecTempLin.FINDFIRST THEN
                REPEAT
                    V.UPDATE(1, RecTempLin."Clave 1");
                    RecTempTallas.INIT;
                    RecTempTallas."Clave 1" := RecTempLin."Clave 1";
                    RecTempTallas."Clave 3" := RecTempLin."Clave 3";
                    RecTempTallas."Clave 4" := RecTempLin."Clave 4";
                    RecTempTallas."Clave 5" := RecTempLin."Clave 5";
                    ColorRec.RESET;
                    ColorRec.SETRANGE(Code, RecTempLin."Clave 5");
                    IF ColorRec.FINDFIRST THEN
                        RecTempTallas.Descripcion := ColorRec.Description;
                    RecTempTallas."Clave 6" := RecTempLin."Clave 6";
                    RecTempTallas.Proceso := 'WMSTALLAS';
                    RecTempTallas.usuario := USERID;
                    RecTempTallas."Nombre Cliente" := RecTempLin."Nombre Cliente";
                    IF NOT RecTempTallas.INSERT THEN BEGIN
                        RecTempTallasMod.RESET;
                        RecTempTallasMod.SETCURRENTKEY("Clave 1", "Clave 3", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario, "Insertado 2");
                        RecTempTallasMod.SETRANGE("Clave 1", RecTempLin."Clave 1");
                        RecTempTallasMod.SETRANGE("Clave 3", RecTempLin."Clave 3");
                        RecTempTallasMod.SETRANGE("Clave 4", RecTempLin."Clave 4");
                        RecTempTallasMod.SETRANGE("Clave 5", RecTempLin."Clave 5");
                        RecTempTallasMod.SETRANGE("Clave 6", RecTempLin."Clave 6");
                        RecTempTallasMod.SETRANGE(Proceso, 'WMSTALLAS');
                        RecTempTallasMod.SETRANGE(usuario, USERID);
                        RecTempTallasMod.SETRANGE("Insertado 2", FALSE);

                        IF RecTempTallasMod.FINDFIRST THEN BEGIN
                            IF RecTempLin.Talla = '17' THEN BEGIN
                                RecTempTallasMod."17 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."17 inist" := RecTempTallasMod."17 Stock";
                                //RecTempTallasMod."17 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."17 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."17 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."17 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."17 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."17 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."17 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '18' THEN BEGIN
                                RecTempTallasMod."18 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."18 inist" := RecTempTallasMod."18 Stock";
                                //RecTempTallasMod."18 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."18 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."18 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."18 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."18 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."18 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."18 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '19' THEN BEGIN
                                RecTempTallasMod."19 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."19 inist" := RecTempTallasMod."19 Stock";
                                //RecTempTallasMod."19 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."19 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919


                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."19 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."19 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."19 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."19 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."19 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '20' THEN BEGIN
                                RecTempTallasMod."20 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."20 inist" := RecTempTallasMod."20 Stock";
                                //RecTempTallasMod."20 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."20 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919


                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."20 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."20 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."20 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."20 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."20 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '21' THEN BEGIN
                                RecTempTallasMod."21 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."21 inist" := RecTempTallasMod."21 Stock";
                                //RecTempTallasMod."21 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."21 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919


                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."21 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."21 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."21 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."21 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."21 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '22' THEN BEGIN
                                RecTempTallasMod."22 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."22 inist" := RecTempTallasMod."22 Stock";
                                //RecTempTallasMod."22 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."22 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."22 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."22 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."22 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."22 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."22 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '23' THEN BEGIN
                                RecTempTallasMod."23 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."23 inist" := RecTempTallasMod."23 Stock";
                                //RecTempTallasMod."23 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."23 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919


                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."23 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."23 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."23 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."23 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."23 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '24' THEN BEGIN
                                RecTempTallasMod."24 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."24 inist" := RecTempTallasMod."24 Stock";
                                //RecTempTallasMod."24 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."24 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."24 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."24 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."24 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."24 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."24 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '25' THEN BEGIN
                                RecTempTallasMod."25 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                //RecTempLin."Picking Pedido";
                                RecTempTallasMod."25 inist" := RecTempTallasMod."25 Stock";
                                //RecTempTallasMod."25 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."25 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."25 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."25 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."25 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."25 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."25 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '26' THEN BEGIN
                                RecTempTallasMod."26 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                //RecTempLin."Picking Pedido";
                                RecTempTallasMod."26 inist" := RecTempTallasMod."26 Stock";
                                //RecTempTallasMod."26 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."26 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."26 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."26 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."26 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."26 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."26 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '27' THEN BEGIN
                                RecTempTallasMod."27 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."27 inist" := RecTempTallasMod."27 Stock";
                                //RecTempTallasMod."27 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."27 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."27 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."27 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."27 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."27 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."27 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '28' THEN BEGIN
                                RecTempTallasMod."28 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                //RecTempLin."Picking Pedido";
                                RecTempTallasMod."28 inist" := RecTempTallasMod."28 Stock";
                                //RecTempTallasMod."28 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."28 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919;

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."28 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."28 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."28 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."28 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."28 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '29' THEN BEGIN
                                RecTempTallasMod."29 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                //RecTempLin."Picking Pedido";
                                RecTempTallasMod."29 inist" := RecTempTallasMod."29 Stock";
                                //RecTempTallasMod."29 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."29 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919


                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."29 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."29 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                //AGOSTO
                                RecTempTallasMod."29 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."29 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."29 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '30' THEN BEGIN
                                RecTempTallasMod."30 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                //RecTempLin."Picking Pedido";
                                RecTempTallasMod."30 inist" := RecTempTallasMod."30 Stock";
                                //RecTempTallasMod."30 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."30 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919


                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."30 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."30 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."30 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."30 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."30 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '31' THEN BEGIN
                                RecTempTallasMod."31 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."31 inist" := RecTempTallasMod."31 Stock";
                                //RecTempTallasMod."31 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."31 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."31 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."31 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."31 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."31 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."31 SS" := RecTempLin."Serie Servicio";
                            END;
                            IF RecTempLin.Talla = '32' THEN BEGIN
                                RecTempTallasMod."32 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."32 inist" := RecTempTallasMod."32 Stock";
                                //RecTempTallasMod."32 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."32 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."32 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."32 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."32 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."32 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."32 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '33' THEN BEGIN
                                RecTempTallasMod."33 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."33 inist" := RecTempTallasMod."33 Stock";
                                //RecTempTallasMod."33 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."33 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."33 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."33 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."33 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."33 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."33 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '34' THEN BEGIN
                                RecTempTallasMod."34 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."34 inist" := RecTempTallasMod."34 Stock";
                                //RecTempTallasMod."34 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."34 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919


                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."34 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."34 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."34 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."34 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."34 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '35' THEN BEGIN
                                RecTempTallasMod."35 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."35 inist" := RecTempTallasMod."35 Stock";
                                //RecTempTallasMod."35 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."35 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."35 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."35 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."35 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."35 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."35 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '36' THEN BEGIN
                                RecTempTallasMod."36 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                //RecTempLin."Picking Pedido";
                                RecTempTallasMod."36 inist" := RecTempTallasMod."36 Stock";
                                //RecTempTallasMod."36 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."36 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."36 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."36 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."36 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."36 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."36 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '37' THEN BEGIN
                                RecTempTallasMod."37 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."37 inist" := RecTempTallasMod."37 Stock";
                                //RecTempTallasMod."37 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."37 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."37 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."37 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."37 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."37 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."37 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '38' THEN BEGIN
                                RecTempTallasMod."38 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."38 inist" := RecTempTallasMod."38 Stock";
                                //RecTempTallasMod."38 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."38 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."38 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."38 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."38 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."38 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."38 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '39' THEN BEGIN
                                RecTempTallasMod."39 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."39 inist" := RecTempTallasMod."39 Stock";
                                //RecTempTallasMod."39 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."39 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919


                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."39 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."39 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."39 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."39 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."39 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '40' THEN BEGIN
                                RecTempTallasMod."40 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."40 inist" := RecTempTallasMod."40 Stock";
                                //RecTempTallasMod."40 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."40 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."40 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."40 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."40 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."40 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."40 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '41' THEN BEGIN
                                RecTempTallasMod."41 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."41 inist" := RecTempTallasMod."41 Stock";
                                //RecTempTallasMod."41 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."41 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919


                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."41 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."41 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."41 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."41 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."41 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '42' THEN BEGIN
                                RecTempTallasMod."42 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."42 inist" := RecTempTallasMod."42 Stock";
                                //RecTempTallasMod."42 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."42 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919


                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."42 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."42 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."42 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."42 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."42 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '43' THEN BEGIN
                                RecTempTallasMod."43 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."43 inist" := RecTempTallasMod."43 Stock";
                                //RecTempTallasMod."43 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."43 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."43 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."43 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."43 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."43 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."43 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '44' THEN BEGIN
                                RecTempTallasMod."44 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."44 inist" := RecTempTallasMod."44 Stock";
                                //RecTempTallasMod."44 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."44 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."44 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."44 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."44 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."44 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."44 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '45' THEN BEGIN
                                RecTempTallasMod."45 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."45 inist" := RecTempTallasMod."45 Stock";
                                //RecTempTallasMod."45 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."45 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."45 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."45 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."45 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."45 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."45 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '46' THEN BEGIN
                                RecTempTallasMod."46 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."46 inist" := RecTempTallasMod."46 Stock";
                                //RecTempTallasMod."46 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."46 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."46 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."46 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."46 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."46 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."46 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '47' THEN BEGIN
                                RecTempTallasMod."47 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."47 inist" := RecTempTallasMod."47 Stock";
                                //RecTempTallasMod."47 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."47 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."47 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."47 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."47 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."47 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."47 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '48' THEN BEGIN
                                RecTempTallasMod."48 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."48 inist" := RecTempTallasMod."48 Stock";
                                //RecTempTallasMod."48 Pte Servir" += RecTempLin."Cantidad Pendiente";
                                RecTempTallasMod."48 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."48 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."48 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."48 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."48 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."48 SS" := RecTempLin."Serie Servicio";

                            END;
                            IF RecTempLin.Talla = '49' THEN BEGIN
                                RecTempTallasMod."49 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                                RecTempLin.CodPreemb) -
                                //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                                CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                                - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                                RecTempTallasMod."49 inist" := RecTempTallasMod."49 Stock";
                                //RecTempTallasMod."49 Pte Servir" += RecTempLin."Cantidad Pendiente";

                                RecTempTallasMod."49 Pte Servir" += RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                                IF NOT RecTempLin.Anular THEN BEGIN
                                    RecTempTallasMod."49 Asig" += RecTempLin."Cantidad Asignada";
                                    RecTempTallasMod."49 iniasig" += RecTempLin."Cantidad Asignada";
                                END;
                                RecTempTallasMod."49 fecha" := RecTempLin."Fecha Servicio";
                                RecTempTallasMod."49 SP" := RecTempLin."Serie Precio";
                                RecTempTallasMod."49 SS" := RecTempLin."Serie Servicio";

                            END;
                            RecTempTallasMod.MODIFY;
                        END;
                    END ELSE BEGIN
                        IF RecTempLin.Talla = '17' THEN BEGIN
                            RecTempTallas."17 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."17 inist" := RecTempTallas."17 Stock";
                            //RecTempTallas."17 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."17 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."17 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."17 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."17 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."17 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."17 SS" := RecTempLin."Serie Servicio";

                        END;
                        IF RecTempLin.Talla = '18' THEN BEGIN
                            RecTempTallas."18 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."18 inist" := RecTempTallas."18 Stock";
                            //RecTempTallas."18 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."18 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."18 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."18 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."18 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."18 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."18 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '19' THEN BEGIN
                            RecTempTallas."19 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."19 inist" := RecTempTallas."19 Stock";
                            //RecTempTallas."19 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."19 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."19 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."19 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."19 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."19 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."19 SS" := RecTempLin."Serie Servicio";

                        END;
                        IF RecTempLin.Talla = '20' THEN BEGIN
                            RecTempTallas."20 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."20 inist" := RecTempTallas."20 Stock";
                            //RecTempTallas."20 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."20 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."20 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."20 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."20 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."20 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."20 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '21' THEN BEGIN
                            RecTempTallas."21 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."21 inist" := RecTempTallas."21 Stock";
                            //RecTempTallas."21 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."21 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."21 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."21 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."21 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."21 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."21 SS" := RecTempLin."Serie Servicio";

                        END;
                        IF RecTempLin.Talla = '22' THEN BEGIN
                            RecTempTallas."22 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."22 inist" := RecTempTallas."22 Stock";
                            //RecTempTallas."22 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."22 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."22 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."22 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."22 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."22 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."22 SS" := RecTempLin."Serie Servicio";

                        END;
                        IF RecTempLin.Talla = '23' THEN BEGIN
                            RecTempTallas."23 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."23 inist" := RecTempTallas."23 Stock";
                            //RecTempTallas."23 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."23 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."23 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."23 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."23 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."23 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."23 SS" := RecTempLin."Serie Servicio";

                        END;
                        IF RecTempLin.Talla = '24' THEN BEGIN
                            RecTempTallas."24 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."24 inist" := RecTempTallas."24 Stock";
                            //RecTempTallas."24 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."24 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."24 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."24 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."24 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."24 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."24 SS" := RecTempLin."Serie Servicio";

                        END;
                        IF RecTempLin.Talla = '25' THEN BEGIN
                            RecTempTallas."25 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."25 inist" := RecTempTallas."25 Stock";
                            //RecTempTallas."25 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."25 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."25 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."25 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."25 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."25 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."25 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '26' THEN BEGIN
                            RecTempTallas."26 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."26 inist" := RecTempTallas."26 Stock";
                            //RecTempTallas."26 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."26 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."26 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."26 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."26 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."26 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."26 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '27' THEN BEGIN
                            RecTempTallas."27 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."27 inist" := RecTempTallas."27 Stock";
                            //RecTempTallas."27 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."27 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."27 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."27 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."27 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."27 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."27 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '28' THEN BEGIN
                            RecTempTallas."28 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."28 inist" := RecTempTallas."28 Stock";
                            //RecTempTallas."28 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."28 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."28 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."28 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."28 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."28 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."28 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '29' THEN BEGIN
                            RecTempTallas."29 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."29 inist" := RecTempTallas."29 Stock";
                            //RecTempTallas."29 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."29 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."29 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."29 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."29 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."29 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."29 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '30' THEN BEGIN
                            RecTempTallas."30 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."30 inist" := RecTempTallas."30 Stock";
                            //RecTempTallas."30 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."30 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."30 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."30 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."30 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."30 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."30 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '31' THEN BEGIN
                            RecTempTallas."31 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."31 inist" := RecTempTallas."31 Stock";
                            //RecTempTallas."31 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."31 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."31 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."31 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."31 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."31 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."31 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '32' THEN BEGIN
                            RecTempTallas."32 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."32 inist" := RecTempTallas."32 Stock";
                            //RecTempTallas."32 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."32 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."32 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."32 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."32 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."32 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."32 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '33' THEN BEGIN
                            RecTempTallas."33 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            //RecTempLin."Picking Pedido";
                            RecTempTallas."33 inist" := RecTempTallas."33 Stock";
                            //RecTempTallas."33 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."33 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."33 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."33 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."33 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."33 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."33 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '34' THEN BEGIN
                            RecTempTallas."34 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."34 inist" := RecTempTallas."34 Stock";
                            //RecTempTallas."34 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."34 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."34 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."34 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."34 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."34 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."34 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '35' THEN BEGIN
                            RecTempTallas."35 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."35 inist" := RecTempTallas."35 Stock";
                            //RecTempTallas."35 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."35 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."35 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."35 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."35 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."35 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."35 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '36' THEN BEGIN
                            RecTempTallas."36 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."36 inist" := RecTempTallas."36 Stock";
                            //RecTempTallas."36 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."36 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."36 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."36 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."36 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."36 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."36 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '37' THEN BEGIN
                            RecTempTallas."37 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."37 inist" := RecTempTallas."37 Stock";
                            //RecTempTallas."37 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."37 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."37 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."37 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."37 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."37 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."37 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '38' THEN BEGIN
                            RecTempTallas."38 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."38 inist" := RecTempTallas."38 Stock";
                            //RecTempTallas."38 Pte Servir" := RecTempLin."Cantidad Pendiente";
                            RecTempTallas."38 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."38 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."38 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."38 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."38 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."38 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '39' THEN BEGIN
                            RecTempTallas."39 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."39 inist" := RecTempTallas."39 Stock";
                            //RecTempTallas."39 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."39 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."39 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."39 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."39 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."39 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."39 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '40' THEN BEGIN
                            RecTempTallas."40 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."40 inist" := RecTempTallas."40 Stock";
                            //RecTempTallas."40 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."40 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."40 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."40 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."40 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."40 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."40 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '41' THEN BEGIN
                            RecTempTallas."41 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."41 inist" := RecTempTallas."41 Stock";
                            //RecTempTallas."41 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."41 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."41 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."41 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."41 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."41 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."41 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '42' THEN BEGIN
                            RecTempTallas."42 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."42 inist" := RecTempTallas."42 Stock";
                            //RecTempTallas."42 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."42 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."42 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."42 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."42 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."42 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."42 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '43' THEN BEGIN
                            RecTempTallas."43 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."43 inist" := RecTempTallas."43 Stock";
                            //RecTempTallas."43 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."43 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."43 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."43 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."43 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."43 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."43 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '44' THEN BEGIN
                            RecTempTallas."44 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."44 inist" := RecTempTallas."44 Stock";
                            //RecTempTallas."44 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."44 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."44 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."44 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."44 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."44 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."44 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '45' THEN BEGIN
                            RecTempTallas."45 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            //RecTempLin."Picking Pedido";
                            RecTempTallas."45 inist" := RecTempTallas."45 Stock";
                            //RecTempTallas."45 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."45 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919


                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."45 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."45 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."45 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."45 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."45 SS" := RecTempLin."Serie Servicio";

                        END;
                        IF RecTempLin.Talla = '46' THEN BEGIN
                            RecTempTallas."46 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."46 inist" := RecTempTallas."46 Stock";
                            //RecTempTallas."46 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."46 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."46 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."46 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."46 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."46 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."46 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '47' THEN BEGIN
                            RecTempTallas."47 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."47 inist" := RecTempTallas."47 Stock";
                            //RecTempTallas."47 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."47 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."47 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."47 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."47 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."47 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."47 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '48' THEN BEGIN
                            RecTempTallas."48 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            //CalculoReserva(RecTempLin."Clave 1",RecTempLin.Linea) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."48 inist" := RecTempTallas."48 Stock";
                            //RecTempTallas."48 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."48 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."48 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."48 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."48 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."48 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."48 SS" := RecTempLin."Serie Servicio";
                        END;
                        IF RecTempLin.Talla = '49' THEN BEGIN
                            RecTempTallas."49 Stock" := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla,
                            RecTempLin.CodPreemb) -
                            CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                            CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb)//;
                            - RecTempLin."Cant. envios lanzados"; //EX-SGG-WMS 180919

                            RecTempTallas."49 inist" := RecTempTallas."49 Stock";
                            //RecTempTallas."49 Pte Servir" := RecTempLin."Cantidad Pendiente";

                            RecTempTallas."49 Pte Servir" := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                            CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                            RecTempLin."Cant. envios lanzados pedido";      //EX-JFC-WMS 110919

                            IF NOT RecTempLin.Anular THEN BEGIN
                                RecTempTallas."49 Asig" := RecTempLin."Cantidad Asignada";
                                RecTempTallas."49 iniasig" := RecTempLin."Cantidad Asignada";
                            END;
                            RecTempTallas."49 fecha" := RecTempLin."Fecha Servicio";
                            RecTempTallas."49 SP" := RecTempLin."Serie Precio";
                            RecTempTallas."49 SS" := RecTempLin."Serie Servicio";
                        END;

                        //RecTempTallas.VALIDATE("Asigna Lin",TRUE);
                        RecTempTallas.MODIFY;
                    END;
                UNTIL RecTempLin.NEXT = 0;
            V.CLOSE;
        END;

        RecUser."Proposicion Venta" := TRUE;
        RecUser.MODIFY;

        V.OPEN('Inicando proceso');
        RecTempLin.RESET;
        RecTempLin.SETCURRENTKEY(Proceso, usuario, "Insertado 2");
        RecTempLin.SETRANGE(Proceso, 'WMST2');
        RecTempLin.SETRANGE(usuario, USERID);
        RecTempLin.SETRANGE("Insertado 2", FALSE);
        RecTempLin.DELETEALL;
        V.CLOSE;

        V.OPEN('C lculo Pte servir:#1#######');
        RecTempLin.RESET;
        RecTempLin.SETCURRENTKEY(Proceso, usuario, "Insertado 2");
        RecTempLin.SETRANGE(Proceso, 'WMSTALLAS');
        RecTempLin.SETRANGE(usuario, USERID);
        RecTempLin.SETRANGE("Insertado 2", FALSE);
        IF RecTempLin.FINDFIRST THEN
            REPEAT
                V.UPDATE(1, RecTempLin."Clave 1");
                RecTallas2.INIT;
                RecTallas2."Clave 1" := RecTempLin."Clave 1";
                RecTallas2."Clave 3" := RecTempLin."Clave 3";
                RecTallas2."Clave 4" := RecTempLin."Clave 4";
                RecTallas2."Clave 5" := RecTempLin."Clave 5";
                RecTallas2."Clave 6" := RecTempLin."Clave 6";
                RecTallas2."Clave 2" := 'PTE. SERVIR';
                RecTallas2.Proceso := 'WMST2';
                RecTallas2.usuario := USERID;
                IF RecTempLin."17 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."17 AsigU" := RecTempLin."17 Pte Servir";
                END;
                IF RecTempLin."18 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."18 AsigU" := RecTempLin."18 Pte Servir";
                END;
                IF RecTempLin."19 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."19 AsigU" := RecTempLin."19 Pte Servir";
                END;
                IF RecTempLin."20 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."20 AsigU" := RecTempLin."20 Pte Servir";
                END;
                IF RecTempLin."21 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."21 AsigU" := RecTempLin."21 Pte Servir";
                END;
                IF RecTempLin."22 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."22 AsigU" := RecTempLin."22 Pte Servir";
                END;
                IF RecTempLin."23 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."23 AsigU" := RecTempLin."23 Pte Servir";
                END;
                IF RecTempLin."24 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."24 AsigU" := RecTempLin."24 Pte Servir";
                END;
                IF RecTempLin."25 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."25 AsigU" := RecTempLin."25 Pte Servir";
                END;
                IF RecTempLin."26 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."26 AsigU" := RecTempLin."26 Pte Servir";
                END;
                IF RecTempLin."27 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."27 AsigU" := RecTempLin."27 Pte Servir";
                END;
                IF RecTempLin."28 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."28 AsigU" := RecTempLin."28 Pte Servir";
                END;
                IF RecTempLin."29 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."29 AsigU" := RecTempLin."29 Pte Servir";
                END;
                IF RecTempLin."30 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."30 AsigU" := RecTempLin."30 Pte Servir";
                END;
                IF RecTempLin."31 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."31 AsigU" := RecTempLin."31 Pte Servir";
                END;
                IF RecTempLin."32 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."32 AsigU" := RecTempLin."32 Pte Servir";
                END;
                IF RecTempLin."33 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."33 AsigU" := RecTempLin."33 Pte Servir";
                END;
                IF RecTempLin."34 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."34 AsigU" := RecTempLin."34 Pte Servir";
                END;
                IF RecTempLin."35 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."35 AsigU" := RecTempLin."35 Pte Servir";
                END;
                IF RecTempLin."36 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."36 AsigU" := RecTempLin."36 Pte Servir";
                END;
                IF RecTempLin."37 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."37 AsigU" := RecTempLin."37 Pte Servir";
                END;
                IF RecTempLin."38 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."38 AsigU" := RecTempLin."38 Pte Servir";
                END;
                IF RecTempLin."39 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."39 AsigU" := RecTempLin."39 Pte Servir";
                END;
                IF RecTempLin."40 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."40 AsigU" := RecTempLin."40 Pte Servir";
                END;
                IF RecTempLin."41 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."41 AsigU" := RecTempLin."41 Pte Servir";
                END;
                IF RecTempLin."42 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."42 AsigU" := RecTempLin."42 Pte Servir";
                END;
                IF RecTempLin."43 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."43 AsigU" := RecTempLin."43 Pte Servir";
                END;
                IF RecTempLin."44 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."44 AsigU" := RecTempLin."44 Pte Servir";
                END;
                IF RecTempLin."45 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."45 AsigU" := RecTempLin."45 Pte Servir";
                END;
                IF RecTempLin."46 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."46 AsigU" := RecTempLin."46 Pte Servir";
                END;
                IF RecTempLin."47 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."47 AsigU" := RecTempLin."47 Pte Servir";
                END;
                IF RecTempLin."48 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."48 AsigU" := RecTempLin."48 Pte Servir";
                END;
                IF RecTempLin."49 Pte Servir" <> 0 THEN BEGIN
                    RecTallas2."49 AsigU" := RecTempLin."49 Pte Servir";
                END;

                RecTallas2.INSERT;

                RecTallas2.INIT;
                RecTallas2."Clave 1" := RecTempLin."Clave 1";
                RecTallas2."Clave 3" := RecTempLin."Clave 3";
                RecTallas2."Clave 4" := RecTempLin."Clave 4";
                RecTallas2."Clave 5" := RecTempLin."Clave 5";
                RecTallas2."Clave 6" := RecTempLin."Clave 6";
                RecTallas2."Clave 2" := 'STOCK';
                RecTallas2.Proceso := 'WMST2';
                RecTallas2.usuario := USERID;
                IF RecTempLin."17 Stock" <> 0 THEN BEGIN
                    RecTallas2."17 AsigU" := RecTempLin."17 Stock";
                END;
                IF RecTempLin."18 Stock" <> 0 THEN BEGIN
                    RecTallas2."18 AsigU" := RecTempLin."18 Stock";
                END;
                IF RecTempLin."19 Stock" <> 0 THEN BEGIN
                    RecTallas2."19 AsigU" := RecTempLin."19 Stock";
                END;
                IF RecTempLin."20 Stock" <> 0 THEN BEGIN
                    RecTallas2."20 AsigU" := RecTempLin."20 Stock";
                END;
                IF RecTempLin."21 Stock" <> 0 THEN BEGIN
                    RecTallas2."21 AsigU" := RecTempLin."21 Stock";
                END;
                IF RecTempLin."22 Stock" <> 0 THEN BEGIN
                    RecTallas2."22 AsigU" := RecTempLin."22 Stock";
                END;
                IF RecTempLin."23 Stock" <> 0 THEN BEGIN
                    RecTallas2."23 AsigU" := RecTempLin."23 Stock";
                END;
                IF RecTempLin."24 Stock" <> 0 THEN BEGIN
                    RecTallas2."24 AsigU" := RecTempLin."24 Stock";
                END;
                IF RecTempLin."25 Stock" <> 0 THEN BEGIN
                    RecTallas2."25 AsigU" := RecTempLin."25 Stock";
                END;
                IF RecTempLin."26 Stock" <> 0 THEN BEGIN
                    RecTallas2."26 AsigU" := RecTempLin."26 Stock";
                END;
                IF RecTempLin."27 Stock" <> 0 THEN BEGIN
                    RecTallas2."27 AsigU" := RecTempLin."27 Stock";
                END;
                IF RecTempLin."28 Stock" <> 0 THEN BEGIN
                    RecTallas2."28 AsigU" := RecTempLin."28 Stock";
                END;
                IF RecTempLin."29 Stock" <> 0 THEN BEGIN
                    RecTallas2."29 AsigU" := RecTempLin."29 Stock";
                END;
                IF RecTempLin."30 Stock" <> 0 THEN BEGIN
                    RecTallas2."30 AsigU" := RecTempLin."30 Stock";
                END;
                IF RecTempLin."31 Stock" <> 0 THEN BEGIN
                    RecTallas2."31 AsigU" := RecTempLin."31 Stock";
                END;
                IF RecTempLin."32 Stock" <> 0 THEN BEGIN
                    RecTallas2."32 AsigU" := RecTempLin."32 Stock";
                END;
                IF RecTempLin."33 Stock" <> 0 THEN BEGIN
                    RecTallas2."33 AsigU" := RecTempLin."33 Stock";
                END;
                IF RecTempLin."34 Stock" <> 0 THEN BEGIN
                    RecTallas2."34 AsigU" := RecTempLin."34 Stock";
                END;
                IF RecTempLin."35 Stock" <> 0 THEN BEGIN
                    RecTallas2."35 AsigU" := RecTempLin."35 Stock";
                END;
                IF RecTempLin."36 Stock" <> 0 THEN BEGIN
                    RecTallas2."36 AsigU" := RecTempLin."36 Stock";
                END;
                IF RecTempLin."37 Stock" <> 0 THEN BEGIN
                    RecTallas2."37 AsigU" := RecTempLin."37 Stock";
                END;
                IF RecTempLin."38 Stock" <> 0 THEN BEGIN
                    RecTallas2."38 AsigU" := RecTempLin."38 Stock";
                END;
                IF RecTempLin."39 Stock" <> 0 THEN BEGIN
                    RecTallas2."39 AsigU" := RecTempLin."39 Stock";
                END;
                IF RecTempLin."40 Stock" <> 0 THEN BEGIN
                    RecTallas2."40 AsigU" := RecTempLin."40 Stock";
                END;
                IF RecTempLin."41 Stock" <> 0 THEN BEGIN
                    RecTallas2."41 AsigU" := RecTempLin."41 Stock";
                END;
                IF RecTempLin."42 Stock" <> 0 THEN BEGIN
                    RecTallas2."42 AsigU" := RecTempLin."42 Stock";
                END;
                IF RecTempLin."43 Stock" <> 0 THEN BEGIN
                    RecTallas2."43 AsigU" := RecTempLin."43 Stock";
                END;
                IF RecTempLin."44 Stock" <> 0 THEN BEGIN
                    RecTallas2."44 AsigU" := RecTempLin."44 Stock";
                END;
                IF RecTempLin."45 Stock" <> 0 THEN BEGIN
                    RecTallas2."45 AsigU" := RecTempLin."45 Stock";
                END;
                IF RecTempLin."46 Stock" <> 0 THEN BEGIN
                    RecTallas2."46 AsigU" := RecTempLin."46 Stock";
                END;
                IF RecTempLin."47 Stock" <> 0 THEN BEGIN
                    RecTallas2."47 AsigU" := RecTempLin."47 Stock";
                END;
                IF RecTempLin."48 Stock" <> 0 THEN BEGIN
                    RecTallas2."48 AsigU" := RecTempLin."48 Stock";
                END;
                IF RecTempLin."49 Stock" <> 0 THEN BEGIN
                    RecTallas2."49 AsigU" := RecTempLin."49 Stock";
                END;

                RecTallas2.INSERT;

                RecTallas2.INIT;
                RecTallas2."Clave 1" := RecTempLin."Clave 1";
                RecTallas2."Clave 3" := RecTempLin."Clave 3";
                RecTallas2."Clave 4" := RecTempLin."Clave 4";
                RecTallas2."Clave 5" := RecTempLin."Clave 5";
                RecTallas2."Clave 6" := RecTempLin."Clave 6";

                RecTallas2."Clave 2" := '3ASIGNADO';
                RecTallas2.Proceso := 'WMST2';
                RecTallas2.usuario := USERID;
                IF RecTempLin."17 Asig" <> 0 THEN BEGIN
                    RecTallas2."17 AsigU" := RecTempLin."17 Asig";
                END;
                IF RecTempLin."18 Asig" <> 0 THEN BEGIN
                    RecTallas2."18 AsigU" := RecTempLin."18 Asig";
                END;
                IF RecTempLin."19 Asig" <> 0 THEN BEGIN
                    RecTallas2."19 AsigU" := RecTempLin."19 Asig";
                END;
                IF RecTempLin."20 Asig" <> 0 THEN BEGIN
                    RecTallas2."20 AsigU" := RecTempLin."20 Asig";
                END;
                IF RecTempLin."21 Asig" <> 0 THEN BEGIN
                    RecTallas2."21 AsigU" := RecTempLin."21 Asig";
                END;
                IF RecTempLin."22 Asig" <> 0 THEN BEGIN
                    RecTallas2."22 AsigU" := RecTempLin."22 Asig";
                END;
                IF RecTempLin."23 Asig" <> 0 THEN BEGIN
                    RecTallas2."23 AsigU" := RecTempLin."23 Asig";
                END;
                IF RecTempLin."24 Asig" <> 0 THEN BEGIN
                    RecTallas2."24 AsigU" := RecTempLin."24 Asig";
                END;
                IF RecTempLin."25 Asig" <> 0 THEN BEGIN
                    RecTallas2."25 AsigU" := RecTempLin."25 Asig";
                END;
                IF RecTempLin."26 Asig" <> 0 THEN BEGIN
                    RecTallas2."26 AsigU" := RecTempLin."26 Asig";
                END;
                IF RecTempLin."27 Asig" <> 0 THEN BEGIN
                    RecTallas2."27 AsigU" := RecTempLin."27 Asig";
                END;
                IF RecTempLin."28 Asig" <> 0 THEN BEGIN
                    RecTallas2."28 AsigU" := RecTempLin."28 Asig";
                END;
                IF RecTempLin."29 Asig" <> 0 THEN BEGIN
                    RecTallas2."29 AsigU" := RecTempLin."29 Asig";
                END;
                IF RecTempLin."30 Asig" <> 0 THEN BEGIN
                    RecTallas2."30 AsigU" := RecTempLin."30 Asig";
                END;
                IF RecTempLin."31 Asig" <> 0 THEN BEGIN
                    RecTallas2."31 AsigU" := RecTempLin."31 Asig";
                END;
                IF RecTempLin."32 Asig" <> 0 THEN BEGIN
                    RecTallas2."32 AsigU" := RecTempLin."32 Asig";
                END;
                IF RecTempLin."33 Asig" <> 0 THEN BEGIN
                    RecTallas2."33 AsigU" := RecTempLin."33 Asig";
                END;
                IF RecTempLin."34 Asig" <> 0 THEN BEGIN
                    RecTallas2."34 AsigU" := RecTempLin."34 Asig";
                END;
                IF RecTempLin."35 Asig" <> 0 THEN BEGIN
                    RecTallas2."35 AsigU" := RecTempLin."35 Asig";
                END;
                IF RecTempLin."36 Asig" <> 0 THEN BEGIN
                    RecTallas2."36 AsigU" := RecTempLin."36 Asig";
                END;
                IF RecTempLin."37 Asig" <> 0 THEN BEGIN
                    RecTallas2."37 AsigU" := RecTempLin."37 Asig";
                END;
                IF RecTempLin."38 Asig" <> 0 THEN BEGIN
                    RecTallas2."38 AsigU" := RecTempLin."38 Asig";
                END;
                IF RecTempLin."39 Asig" <> 0 THEN BEGIN
                    RecTallas2."39 AsigU" := RecTempLin."39 Asig";
                END;
                IF RecTempLin."40 Asig" <> 0 THEN BEGIN
                    RecTallas2."40 AsigU" := RecTempLin."40 Asig";
                END;
                IF RecTempLin."41 Asig" <> 0 THEN BEGIN
                    RecTallas2."41 AsigU" := RecTempLin."41 Asig";
                END;
                IF RecTempLin."42 Asig" <> 0 THEN BEGIN
                    RecTallas2."42 AsigU" := RecTempLin."42 Asig";
                END;
                IF RecTempLin."43 Asig" <> 0 THEN BEGIN
                    RecTallas2."43 AsigU" := RecTempLin."43 Asig";
                END;
                IF RecTempLin."44 Asig" <> 0 THEN BEGIN
                    RecTallas2."44 AsigU" := RecTempLin."44 Asig";
                END;
                IF RecTempLin."45 Asig" <> 0 THEN BEGIN
                    RecTallas2."45 AsigU" := RecTempLin."45 Asig";
                END;
                IF RecTempLin."46 Asig" <> 0 THEN BEGIN
                    RecTallas2."46 AsigU" := RecTempLin."46 Asig";
                END;
                IF RecTempLin."47 Asig" <> 0 THEN BEGIN
                    RecTallas2."47 AsigU" := RecTempLin."47 Asig";
                END;
                IF RecTempLin."48 Asig" <> 0 THEN BEGIN
                    RecTallas2."48 AsigU" := RecTempLin."48 Asig";
                END;
                IF RecTempLin."49 Asig" <> 0 THEN BEGIN
                    RecTallas2."49 AsigU" := RecTempLin."49 Asig";
                END;
                RecTallas2.INSERT;

                RecTallas2.INIT;
                RecTallas2."Clave 1" := RecTempLin."Clave 1";
                RecTallas2."Clave 3" := RecTempLin."Clave 3";
                RecTallas2."Clave 4" := RecTempLin."Clave 4";
                RecTallas2."Clave 5" := RecTempLin."Clave 5";
                RecTallas2."Clave 6" := RecTempLin."Clave 6";

                RecTallas2."Clave 2" := 'FECHA';
                RecTallas2.Proceso := 'WMST2';
                RecTallas2.usuario := USERID;
                IF RecTempLin."17 fecha" <> 0D THEN BEGIN
                    RecTallas2."17 fecha" := RecTempLin."17 fecha";
                END;
                IF RecTempLin."18 fecha" <> 0D THEN BEGIN
                    RecTallas2."18 fecha" := RecTempLin."18 fecha";
                END;
                IF RecTempLin."19 fecha" <> 0D THEN BEGIN
                    RecTallas2."19 fecha" := RecTempLin."19 fecha";
                END;
                IF RecTempLin."20 fecha" <> 0D THEN BEGIN
                    RecTallas2."20 fecha" := RecTempLin."20 fecha";
                END;
                IF RecTempLin."21 fecha" <> 0D THEN BEGIN
                    RecTallas2."21 fecha" := RecTempLin."21 fecha";
                END;
                IF RecTempLin."22 fecha" <> 0D THEN BEGIN
                    RecTallas2."22 fecha" := RecTempLin."22 fecha";
                END;
                IF RecTempLin."23 fecha" <> 0D THEN BEGIN
                    RecTallas2."23 fecha" := RecTempLin."23 fecha";
                END;
                IF RecTempLin."24 fecha" <> 0D THEN BEGIN
                    RecTallas2."24 fecha" := RecTempLin."24 fecha";
                END;
                IF RecTempLin."25 fecha" <> 0D THEN BEGIN
                    RecTallas2."25 fecha" := RecTempLin."25 fecha";
                END;
                IF RecTempLin."26 fecha" <> 0D THEN BEGIN
                    RecTallas2."26 fecha" := RecTempLin."26 fecha";
                END;
                IF RecTempLin."27 fecha" <> 0D THEN BEGIN
                    RecTallas2."27 fecha" := RecTempLin."27 fecha";
                END;
                IF RecTempLin."28 fecha" <> 0D THEN BEGIN
                    RecTallas2."28 fecha" := RecTempLin."28 fecha";
                END;
                IF RecTempLin."29 fecha" <> 0D THEN BEGIN
                    RecTallas2."29 fecha" := RecTempLin."29 fecha";
                END;
                IF RecTempLin."30 fecha" <> 0D THEN BEGIN
                    RecTallas2."30 fecha" := RecTempLin."30 fecha";
                END;
                IF RecTempLin."31 fecha" <> 0D THEN BEGIN
                    RecTallas2."31 fecha" := RecTempLin."31 fecha";
                END;
                IF RecTempLin."32 fecha" <> 0D THEN BEGIN
                    RecTallas2."32 fecha" := RecTempLin."32 fecha";
                END;
                IF RecTempLin."33 fecha" <> 0D THEN BEGIN
                    RecTallas2."33 fecha" := RecTempLin."33 fecha";
                END;
                IF RecTempLin."34 fecha" <> 0D THEN BEGIN
                    RecTallas2."34 fecha" := RecTempLin."34 fecha";
                END;
                IF RecTempLin."35 fecha" <> 0D THEN BEGIN
                    RecTallas2."35 fecha" := RecTempLin."35 fecha";
                END;
                IF RecTempLin."36 fecha" <> 0D THEN BEGIN
                    RecTallas2."36 fecha" := RecTempLin."36 fecha";
                END;
                IF RecTempLin."37 fecha" <> 0D THEN BEGIN
                    RecTallas2."37 fecha" := RecTempLin."37 fecha";
                END;
                IF RecTempLin."38 fecha" <> 0D THEN BEGIN
                    RecTallas2."38 fecha" := RecTempLin."38 fecha";
                END;
                IF RecTempLin."39 fecha" <> 0D THEN BEGIN
                    RecTallas2."39 fecha" := RecTempLin."39 fecha";
                END;
                IF RecTempLin."40 fecha" <> 0D THEN BEGIN
                    RecTallas2."40 fecha" := RecTempLin."40 fecha";
                END;
                IF RecTempLin."41 fecha" <> 0D THEN BEGIN
                    RecTallas2."41 fecha" := RecTempLin."41 fecha";
                END;
                IF RecTempLin."42 fecha" <> 0D THEN BEGIN
                    RecTallas2."42 fecha" := RecTempLin."42 fecha";
                END;
                IF RecTempLin."43 fecha" <> 0D THEN BEGIN
                    RecTallas2."43 fecha" := RecTempLin."43 fecha";
                END;
                IF RecTempLin."44 fecha" <> 0D THEN BEGIN
                    RecTallas2."44 fecha" := RecTempLin."44 fecha";
                END;
                IF RecTempLin."45 fecha" <> 0D THEN BEGIN
                    RecTallas2."45 fecha" := RecTempLin."45 fecha";
                END;
                IF RecTempLin."46 fecha" <> 0D THEN BEGIN
                    RecTallas2."46 fecha" := RecTempLin."46 fecha";
                END;
                IF RecTempLin."47 fecha" <> 0D THEN BEGIN
                    RecTallas2."47 fecha" := RecTempLin."47 fecha";
                END;
                IF RecTempLin."48 fecha" <> 0D THEN BEGIN
                    RecTallas2."48 fecha" := RecTempLin."48 fecha";
                END;
                IF RecTempLin."49 fecha" <> 0D THEN BEGIN
                    RecTallas2."49 fecha" := RecTempLin."49 fecha";
                END;
                RecTallas2.INSERT;


                RecTallas2.INIT;
                RecTallas2."Clave 1" := RecTempLin."Clave 1";
                RecTallas2."Clave 3" := RecTempLin."Clave 3";
                RecTallas2."Clave 4" := RecTempLin."Clave 4";
                RecTallas2."Clave 5" := RecTempLin."Clave 5";
                RecTallas2."Clave 6" := RecTempLin."Clave 6";

                RecTallas2."Clave 2" := 'SPRECIO';
                RecTallas2.Proceso := 'WMST2';
                RecTallas2.usuario := USERID;
                IF RecTempLin."17 SP" <> '' THEN BEGIN
                    RecTallas2."17 SP" := RecTempLin."17 SP";
                END;
                IF RecTempLin."18 SP" <> '' THEN BEGIN
                    RecTallas2."18 SP" := RecTempLin."18 SP";
                END;
                IF RecTempLin."19 SP" <> '' THEN BEGIN
                    RecTallas2."19 SP" := RecTempLin."19 SP";
                END;
                IF RecTempLin."20 SP" <> '' THEN BEGIN
                    RecTallas2."20 SP" := RecTempLin."20 SP";
                END;
                IF RecTempLin."21 SP" <> '' THEN BEGIN
                    RecTallas2."21 SP" := RecTempLin."21 SP";
                END;
                IF RecTempLin."22 SP" <> '' THEN BEGIN
                    RecTallas2."22 SP" := RecTempLin."22 SP";
                END;
                IF RecTempLin."23 SP" <> '' THEN BEGIN
                    RecTallas2."23 SP" := RecTempLin."23 SP";
                END;
                IF RecTempLin."24 SP" <> '' THEN BEGIN
                    RecTallas2."24 SP" := RecTempLin."24 SP";
                END;
                IF RecTempLin."25 SP" <> '' THEN BEGIN
                    RecTallas2."25 SP" := RecTempLin."25 SP";
                END;
                IF RecTempLin."26 SP" <> '' THEN BEGIN
                    RecTallas2."26 SP" := RecTempLin."26 SP";
                END;
                IF RecTempLin."27 SP" <> '' THEN BEGIN
                    RecTallas2."27 SP" := RecTempLin."27 SP";
                END;
                IF RecTempLin."28 SP" <> '' THEN BEGIN
                    RecTallas2."28 SP" := RecTempLin."28 SP";
                END;
                IF RecTempLin."29 SP" <> '' THEN BEGIN
                    RecTallas2."29 SP" := RecTempLin."29 SP";
                END;
                IF RecTempLin."30 SP" <> '' THEN BEGIN
                    RecTallas2."30 SP" := RecTempLin."30 SP";
                END;
                IF RecTempLin."31 SP" <> '' THEN BEGIN
                    RecTallas2."31 SP" := RecTempLin."31 SP";
                END;
                IF RecTempLin."32 SP" <> '' THEN BEGIN
                    RecTallas2."32 SP" := RecTempLin."32 SP";
                END;
                IF RecTempLin."33 SP" <> '' THEN BEGIN
                    RecTallas2."33 SP" := RecTempLin."33 SP";
                END;
                IF RecTempLin."34 SP" <> '' THEN BEGIN
                    RecTallas2."34 SP" := RecTempLin."34 SP";
                END;
                IF RecTempLin."35 SP" <> '' THEN BEGIN
                    RecTallas2."35 SP" := RecTempLin."35 SP";
                END;
                IF RecTempLin."36 SP" <> '' THEN BEGIN
                    RecTallas2."36 SP" := RecTempLin."36 SP";
                END;
                IF RecTempLin."37 SP" <> '' THEN BEGIN
                    RecTallas2."37 SP" := RecTempLin."37 SP";
                END;
                IF RecTempLin."38 SP" <> '' THEN BEGIN
                    RecTallas2."38 SP" := RecTempLin."38 SP";
                END;
                IF RecTempLin."39 SP" <> '' THEN BEGIN
                    RecTallas2."39 SP" := RecTempLin."39 SP";
                END;
                IF RecTempLin."40 SP" <> '' THEN BEGIN
                    RecTallas2."40 SP" := RecTempLin."40 SP";
                END;
                IF RecTempLin."41 SP" <> '' THEN BEGIN
                    RecTallas2."41 SP" := RecTempLin."41 SP";
                END;
                IF RecTempLin."42 SP" <> '' THEN BEGIN
                    RecTallas2."42 SP" := RecTempLin."42 SP";
                END;
                IF RecTempLin."43 SP" <> '' THEN BEGIN
                    RecTallas2."43 SP" := RecTempLin."43 SP";
                END;
                IF RecTempLin."44 SP" <> '' THEN BEGIN
                    RecTallas2."44 SP" := RecTempLin."44 SP";
                END;
                IF RecTempLin."45 SP" <> '' THEN BEGIN
                    RecTallas2."45 SP" := RecTempLin."45 SP";
                END;
                IF RecTempLin."46 SP" <> '' THEN BEGIN
                    RecTallas2."46 SP" := RecTempLin."46 SP";
                END;
                IF RecTempLin."47 SP" <> '' THEN BEGIN
                    RecTallas2."47 SP" := RecTempLin."47 SP";
                END;
                IF RecTempLin."48 SP" <> '' THEN BEGIN
                    RecTallas2."48 SP" := RecTempLin."48 SP";
                END;
                IF RecTempLin."49 SP" <> '' THEN BEGIN
                    RecTallas2."49 SP" := RecTempLin."49 SP";
                END;
                RecTallas2.INSERT;

                RecTallas2.INIT;
                RecTallas2."Clave 1" := RecTempLin."Clave 1";
                RecTallas2."Clave 3" := RecTempLin."Clave 3";
                RecTallas2."Clave 4" := RecTempLin."Clave 4";
                RecTallas2."Clave 5" := RecTempLin."Clave 5";
                RecTallas2."Clave 6" := RecTempLin."Clave 6";

                RecTallas2."Clave 2" := 'SSERVICIO';
                RecTallas2.Proceso := 'WMST2';
                RecTallas2.usuario := USERID;
                IF RecTempLin."17 SS" <> '' THEN BEGIN
                    RecTallas2."17 SS" := RecTempLin."17 SS";
                END;
                IF RecTempLin."18 SS" <> '' THEN BEGIN
                    RecTallas2."18 SS" := RecTempLin."18 SS";
                END;
                IF RecTempLin."19 SS" <> '' THEN BEGIN
                    RecTallas2."19 SS" := RecTempLin."19 SS";
                END;
                IF RecTempLin."20 SS" <> '' THEN BEGIN
                    RecTallas2."20 SS" := RecTempLin."20 SS";
                END;
                IF RecTempLin."21 SS" <> '' THEN BEGIN
                    RecTallas2."21 SS" := RecTempLin."21 SS";
                END;
                IF RecTempLin."22 SS" <> '' THEN BEGIN
                    RecTallas2."22 SS" := RecTempLin."22 SS";
                END;
                IF RecTempLin."23 SS" <> '' THEN BEGIN
                    RecTallas2."23 SS" := RecTempLin."23 SS";
                END;
                IF RecTempLin."24 SS" <> '' THEN BEGIN
                    RecTallas2."24 SS" := RecTempLin."24 SS";
                END;
                IF RecTempLin."25 SS" <> '' THEN BEGIN
                    RecTallas2."25 SS" := RecTempLin."25 SS";
                END;
                IF RecTempLin."26 SS" <> '' THEN BEGIN
                    RecTallas2."26 SS" := RecTempLin."26 SS";
                END;
                IF RecTempLin."27 SS" <> '' THEN BEGIN
                    RecTallas2."27 SS" := RecTempLin."27 SS";
                END;
                IF RecTempLin."28 SS" <> '' THEN BEGIN
                    RecTallas2."28 SS" := RecTempLin."28 SS";
                END;
                IF RecTempLin."29 SS" <> '' THEN BEGIN
                    RecTallas2."29 SS" := RecTempLin."29 SS";
                END;
                IF RecTempLin."30 SS" <> '' THEN BEGIN
                    RecTallas2."30 SS" := RecTempLin."30 SS";
                END;
                IF RecTempLin."31 SS" <> '' THEN BEGIN
                    RecTallas2."31 SS" := RecTempLin."31 SS";
                END;
                IF RecTempLin."32 SS" <> '' THEN BEGIN
                    RecTallas2."32 SS" := RecTempLin."32 SS";
                END;
                IF RecTempLin."33 SS" <> '' THEN BEGIN
                    RecTallas2."33 SS" := RecTempLin."33 SS";
                END;
                IF RecTempLin."34 SS" <> '' THEN BEGIN
                    RecTallas2."34 SS" := RecTempLin."34 SS";
                END;
                IF RecTempLin."35 SS" <> '' THEN BEGIN
                    RecTallas2."35 SS" := RecTempLin."35 SS";
                END;
                IF RecTempLin."36 SS" <> '' THEN BEGIN
                    RecTallas2."36 SS" := RecTempLin."36 SS";
                END;
                IF RecTempLin."37 SS" <> '' THEN BEGIN
                    RecTallas2."37 SS" := RecTempLin."37 SS";
                END;
                IF RecTempLin."38 SS" <> '' THEN BEGIN
                    RecTallas2."38 SS" := RecTempLin."38 SS";
                END;
                IF RecTempLin."39 SS" <> '' THEN BEGIN
                    RecTallas2."39 SS" := RecTempLin."39 SS";
                END;
                IF RecTempLin."40 SS" <> '' THEN BEGIN
                    RecTallas2."40 SS" := RecTempLin."40 SS";
                END;
                IF RecTempLin."41 SS" <> '' THEN BEGIN
                    RecTallas2."41 SS" := RecTempLin."41 SS";
                END;
                IF RecTempLin."42 SS" <> '' THEN BEGIN
                    RecTallas2."42 SS" := RecTempLin."42 SS";
                END;
                IF RecTempLin."43 SS" <> '' THEN BEGIN
                    RecTallas2."43 SS" := RecTempLin."43 SS";
                END;
                IF RecTempLin."44 SS" <> '' THEN BEGIN
                    RecTallas2."44 SS" := RecTempLin."44 SS";
                END;
                IF RecTempLin."45 SS" <> '' THEN BEGIN
                    RecTallas2."45 SS" := RecTempLin."45 SS";
                END;
                IF RecTempLin."46 SS" <> '' THEN BEGIN
                    RecTallas2."46 SS" := RecTempLin."46 SS";
                END;
                IF RecTempLin."47 SS" <> '' THEN BEGIN
                    RecTallas2."47 SS" := RecTempLin."47 SS";
                END;
                IF RecTempLin."48 SS" <> '' THEN BEGIN
                    RecTallas2."48 SS" := RecTempLin."48 SS";
                END;
                IF RecTempLin."49 SS" <> '' THEN BEGIN
                    RecTallas2."49 SS" := RecTempLin."49 SS";
                END;
                RecTallas2.INSERT;

            UNTIL RecTempLin.NEXT = 0;
        V.CLOSE;


        V.OPEN('Modificando insertado');
        TemporalRec.LOCKTABLE;
        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario);
        TemporalRec.SETRANGE(Proceso, 'WMSCAB');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.MODIFYALL("Insertado 2", TRUE);

        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario);
        TemporalRec.SETRANGE(Proceso, 'WMSLIN');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.MODIFYALL("Insertado 2", TRUE);

        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario);
        TemporalRec.SETRANGE(Proceso, 'WMSTALLAS');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.MODIFYALL("Insertado 2", TRUE);

        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario);
        TemporalRec.SETRANGE(Proceso, 'WMST2');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.MODIFYALL("Insertado 2", TRUE);
        V.CLOSE;

        COMMIT;
        RecTempLin.RESET;
        RecTempLin.SETCURRENTKEY("Clave 1", Proceso, usuario);
        RecTempLin.SETRANGE("Clave 1", Rec."Clave 1");
        RecTempLin.SETRANGE(Proceso, 'WMSTALLAS');
        RecTempLin.SETRANGE(usuario, USERID);
        IF RecTempLin.FINDFIRST THEN
            Page.RUNMODAL(Page::"Modif Prop Venta Lineas", RecTempLin);
    END;

    PROCEDURE LineasProposicionMatriz();
    VAR
        lRecMatrix: Record 50011;
        lRecMatrixCols: Record 50011;
        lCantStock: Decimal;
        lx: Integer;
    BEGIN
        //+EX-SGG 091222
        IF Rec."Tipo proposicion calculada" = Rec."Tipo proposicion calculada"::" " THEN BEGIN
            Rec."Tipo proposicion calculada" := Rec."Tipo proposicion calculada"::Matriz;
            Rec.MODIFY();
        END;
        //-EX-SGG 091222

        //codigo real
        BtnGenerarEnviosWMENABLED := FALSE;

        //+EX-SGG 091222 COMENTO
        //   {
        //   RecUser.GET(USERID);
        //     IF NOT RecUser."Proposicion Venta" THEN BEGIN
        //   }
        //-EX-SGG 091222

        V.OPEN('Cálculo Stock:#1######');
        RecTempLin.RESET;
        RecTempLin.SETCURRENTKEY(Proceso, usuario, "Insertado 2");
        RecTempLin.SETRANGE(Proceso, 'WMSLIN');
        RecTempLin.SETRANGE(usuario, USERID);
        //RecTempLin.SETRANGE("Insertado 2",FALSE); //EX-SGG 221122 COMENTO.
        RecTempLin.SETRANGE("Clave 1", Rec."Clave 1"); //EX-SGG 221122
        IF RecTempLin.FINDSET THEN
            REPEAT
                V.UPDATE(1, RecTempLin."Clave 1");
                RecTempTallas.INIT;
                RecTempTallas."Clave 1" := RecTempLin."Clave 1";
                RecTempTallas."Clave 3" := RecTempLin."Clave 3";
                RecTempTallas."Clave 4" := RecTempLin."Clave 4";
                RecTempTallas."Clave 5" := RecTempLin."Clave 5";
                ColorRec.RESET;
                ColorRec.SETRANGE(Code, RecTempLin."Clave 5");
                IF ColorRec.FINDFIRST THEN
                    RecTempTallas.Descripcion := ColorRec.Description;
                RecTempTallas."Clave 6" := RecTempLin."Clave 6";
                RecTempTallas.Proceso := 'WMSTALLAS';
                RecTempTallas.usuario := USERID;
                RecTempTallas."Nombre Cliente" := RecTempLin."Nombre Cliente";

                //+EX-SGG 171122
                RecTempTallas."Tipo de producto" := RecTempLin."Tipo de producto";
                RecTempTallas."Cod. grupo talla" := RecTempLin."Cod. grupo talla";
                //-EX-SGG 171122

                IF NOT RecTempTallas.INSERT THEN;

                //+EX-SGG 171122
                lRecMatrix.TRANSFERFIELDS(RecTempLin);
                FOR lx := 1 TO 3 DO BEGIN
                    lRecMatrix.Proceso := 'WMSMATRIX';
                    lRecMatrix."Tipo columna matrix" := lx;
                    lRecMatrix.Contador := lx;
                    IF NOT lRecMatrix.FIND() THEN //EX-SGG 161222
                     BEGIN
                        lRecMatrix.Descripcion := FORMAT(lRecMatrix.Talla) + ' ' + FORMAT(lRecMatrix."Tipo columna matrix");
                        CASE lRecMatrix."Tipo columna matrix" OF
                            lRecMatrix."Tipo columna matrix"::"Pdte servir":
                                lRecMatrix.Cantidad := RecTempLin."Cantidad Pendiente" - RecTempLin."Picking Pedido" -
                                                   CalculoReserva(RecTempLin."Clave 1", RecTempLin.Linea) - RecTempLin."Cantidad Anulada" -
                                                   RecTempLin."Cant. envios lanzados pedido";
                            lRecMatrix."Tipo columna matrix"::Stock:
                                BEGIN
                                    lRecMatrix.Cantidad := CalculoStock(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                                      CalculoReserva2(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                                      CantPicking(RecTempLin."Clave 4", RecTempLin."Clave 5", RecTempLin.Talla, RecTempLin.CodPreemb) -
                                                      RecTempLin."Cant. envios lanzados" -
                                                      lRecMatrix.ObtenerOtrasCantAsignadas(lRecMatrix."Clave 1", lRecMatrix."Clave 4", lRecMatrix."Clave 2",
                                                         lRecMatrix."Clave 5"); //EX-SGG 191222
                                    lCantStock := lRecMatrix.Cantidad; //EX-SGG 191222
                                END;
                            lRecMatrix."Tipo columna matrix"::Asig:
                                IF NOT RecTempLin.Anular THEN BEGIN
                                    lRecMatrix.Cantidad := RecTempLin."Cantidad Asignada";
                                    //+EX-SGG 191222
                                    IF lCantStock < lRecMatrix.Cantidad THEN BEGIN
                                        lRecMatrix.Cantidad := lCantStock;
                                        RecTempLin."Cantidad Asignada" := lRecMatrix.Cantidad;
                                        RecTempLin.MODIFY();
                                    END;
                                    //-EX-SGG 191222
                                END
                                ELSE
                                    lRecMatrix.Cantidad := 0;
                        END;
                        lRecMatrix.INSERT();
                    END;
                    lRecMatrixCols.TRANSFERFIELDS(lRecMatrix);
                    lRecMatrixCols.Proceso := 'WMSMATRIXC'; //SE UTILIZAR  PARA MOSTRAR LAS COLUMNAS DEL MATRIX.
                    lRecMatrixCols."Clave 3" := '';
                    lRecMatrixCols."Clave 4" := '';
                    lRecMatrixCols."Clave 5" := '';
                    IF NOT lRecMatrixCols.INSERT() THEN;
                END;
            //-EX-SGG 171122

            UNTIL RecTempLin.NEXT = 0;
        V.CLOSE;

        //+EX-SGG 091222 COMENTO
        //   {
        //   END;

        //   RecUser."Proposicion Venta" := TRUE;
        //   RecUser.MODIFY;
        //   }
        //-EX-SGG 091222

        V.OPEN('Inicando proceso');
        RecTempLin.RESET;
        RecTempLin.SETCURRENTKEY(Proceso, usuario, "Insertado 2");
        RecTempLin.SETRANGE(Proceso, 'WMST2');
        RecTempLin.SETRANGE(usuario, USERID);
        RecTempLin.SETRANGE("Insertado 2", FALSE);
        RecTempLin.SETRANGE("Clave 1", Rec."Clave 1"); //EX-SGG 221122
        RecTempLin.DELETEALL;
        V.CLOSE;

        V.OPEN('C lculo Pte servir:#1#######');
        RecTempLin.RESET;
        RecTempLin.SETCURRENTKEY(Proceso, usuario, "Insertado 2");
        RecTempLin.SETRANGE(Proceso, 'WMSTALLAS');
        RecTempLin.SETRANGE(usuario, USERID);
        RecTempLin.SETRANGE("Insertado 2", FALSE);
        RecTempLin.SETRANGE("Clave 1", Rec."Clave 1"); //EX-SGG 221122
        IF RecTempLin.FINDFIRST THEN
            REPEAT
                V.UPDATE(1, RecTempLin."Clave 1");
                RecTallas2.INIT;
                RecTallas2."Clave 1" := RecTempLin."Clave 1";
                RecTallas2."Clave 3" := RecTempLin."Clave 3";
                RecTallas2."Clave 4" := RecTempLin."Clave 4";
                RecTallas2."Clave 5" := RecTempLin."Clave 5";
                RecTallas2."Clave 6" := RecTempLin."Clave 6";
                RecTallas2."Clave 2" := 'PTE. SERVIR';
                RecTallas2.Proceso := 'WMST2';
                RecTallas2.usuario := USERID;

                //+EX-SGG 171122
                RecTallas2."Tipo de producto" := RecTempLin."Tipo de producto";
                RecTallas2."Cod. grupo talla" := RecTempLin."Cod. grupo talla";
                //-EX-SGG 171122

                RecTallas2.INSERT;

                RecTallas2.INIT;
                RecTallas2."Clave 1" := RecTempLin."Clave 1";
                RecTallas2."Clave 3" := RecTempLin."Clave 3";
                RecTallas2."Clave 4" := RecTempLin."Clave 4";
                RecTallas2."Clave 5" := RecTempLin."Clave 5";
                RecTallas2."Clave 6" := RecTempLin."Clave 6";
                RecTallas2."Clave 2" := 'STOCK';
                RecTallas2.Proceso := 'WMST2';
                RecTallas2.usuario := USERID;

                //+EX-SGG 171122
                RecTallas2."Tipo de producto" := RecTempLin."Tipo de producto";
                RecTallas2."Cod. grupo talla" := RecTempLin."Cod. grupo talla";
                //-EX-SGG 171122

                RecTallas2.INSERT;

                RecTallas2.INIT;
                RecTallas2."Clave 1" := RecTempLin."Clave 1";
                RecTallas2."Clave 3" := RecTempLin."Clave 3";
                RecTallas2."Clave 4" := RecTempLin."Clave 4";
                RecTallas2."Clave 5" := RecTempLin."Clave 5";
                RecTallas2."Clave 6" := RecTempLin."Clave 6";

                RecTallas2."Clave 2" := '3ASIGNADO';
                RecTallas2.Proceso := 'WMST2';
                RecTallas2.usuario := USERID;

                //+EX-SGG 171122
                RecTallas2."Tipo de producto" := RecTempLin."Tipo de producto";
                RecTallas2."Cod. grupo talla" := RecTempLin."Cod. grupo talla";
                //-EX-SGG 171122

                RecTallas2.INSERT;

                RecTallas2.INIT;
                RecTallas2."Clave 1" := RecTempLin."Clave 1";
                RecTallas2."Clave 3" := RecTempLin."Clave 3";
                RecTallas2."Clave 4" := RecTempLin."Clave 4";
                RecTallas2."Clave 5" := RecTempLin."Clave 5";
                RecTallas2."Clave 6" := RecTempLin."Clave 6";

                RecTallas2."Clave 2" := 'FECHA';
                RecTallas2.Proceso := 'WMST2';
                RecTallas2.usuario := USERID;

                //+EX-SGG 171122
                RecTallas2."Tipo de producto" := RecTempLin."Tipo de producto";
                RecTallas2."Cod. grupo talla" := RecTempLin."Cod. grupo talla";
                //-EX-SGG 171122

                RecTallas2.INSERT;

                RecTallas2.INIT;
                RecTallas2."Clave 1" := RecTempLin."Clave 1";
                RecTallas2."Clave 3" := RecTempLin."Clave 3";
                RecTallas2."Clave 4" := RecTempLin."Clave 4";
                RecTallas2."Clave 5" := RecTempLin."Clave 5";
                RecTallas2."Clave 6" := RecTempLin."Clave 6";

                RecTallas2."Clave 2" := 'SPRECIO';
                RecTallas2.Proceso := 'WMST2';
                RecTallas2.usuario := USERID;

                //+EX-SGG 171122
                RecTallas2."Tipo de producto" := RecTempLin."Tipo de producto";
                RecTallas2."Cod. grupo talla" := RecTempLin."Cod. grupo talla";
                //-EX-SGG 171122

                RecTallas2.INSERT;

                RecTallas2.INIT;
                RecTallas2."Clave 1" := RecTempLin."Clave 1";
                RecTallas2."Clave 3" := RecTempLin."Clave 3";
                RecTallas2."Clave 4" := RecTempLin."Clave 4";
                RecTallas2."Clave 5" := RecTempLin."Clave 5";
                RecTallas2."Clave 6" := RecTempLin."Clave 6";

                RecTallas2."Clave 2" := 'SSERVICIO';
                RecTallas2.Proceso := 'WMST2';
                RecTallas2.usuario := USERID;

                //+EX-SGG 171122
                RecTallas2."Tipo de producto" := RecTempLin."Tipo de producto";
                RecTallas2."Cod. grupo talla" := RecTempLin."Cod. grupo talla";
                //-EX-SGG 171122

                RecTallas2.INSERT;

            UNTIL RecTempLin.NEXT = 0;

        V.CLOSE;


        V.OPEN('Modificando insertado');
        TemporalRec.LOCKTABLE;
        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario);
        TemporalRec.SETRANGE(Proceso, 'WMSCAB');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.SETRANGE("Clave 1", Rec."Clave 1"); //EX-SGG 221122
        TemporalRec.MODIFYALL("Insertado 2", TRUE);

        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario);
        TemporalRec.SETRANGE(Proceso, 'WMSLIN');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.SETRANGE("Clave 1", Rec."Clave 1"); //EX-SGG 221122
        TemporalRec.MODIFYALL("Insertado 2", TRUE);

        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario);
        TemporalRec.SETRANGE(Proceso, 'WMSTALLAS');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.SETRANGE("Clave 1", Rec."Clave 1"); //EX-SGG 221122
        TemporalRec.MODIFYALL("Insertado 2", TRUE);

        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario);
        TemporalRec.SETRANGE(Proceso, 'WMST2');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.SETRANGE("Clave 1", Rec."Clave 1"); //EX-SGG 221122
        TemporalRec.MODIFYALL("Insertado 2", TRUE);
        V.CLOSE;

        COMMIT;
        RecTempLin.RESET;
        //RecTempLin.SETCURRENTKEY("Clave 1",Proceso,usuario);
        RecTempLin.SETCURRENTKEY("Clave 1", Proceso, usuario, Insertado, "Tipo de producto", "Cod. grupo talla"); //EX-SGG 171122
        RecTempLin.SETRANGE("Clave 1", Rec."Clave 1");
        RecTempLin.SETRANGE(Proceso, 'WMSTALLAS');
        RecTempLin.SETRANGE(usuario, USERID);
        IF RecTempLin.FINDFIRST THEN
            Page.RUNMODAL(Page::"Modif Prop Venta Lineas", RecTempLin);

    END;

    procedure GetValueAvalDisp(pCustomerCode: Text): Decimal
    var
        Customer: Record Customer;
        cFunc: Codeunit 50000;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ImpFactPteConsig2: Decimal;
        ImpAlb: Decimal;
        ImpAnul: Decimal;
        ImpPedPte: Decimal;
        ImpagRemRech: Decimal;
        ImpagRem: ARRAY[5] OF Decimal;
        ImpEnviosLanzados: Decimal;
        ImpEnviosSinLanzar: Decimal;
        ImpPedPteConsig: Decimal;
        ImpAnulConsig: Decimal;
        ImpPedTransferPdtServirConsig: Decimal;
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
        ImpagadosConsig: Decimal;
        ImpAvalDisp: Decimal;
        ImpRiesgoFinancieroConsig: Decimal;
    begin
        //EX-CV
        //EX-JFC 071221 Calcular la funcion con el nuevo calculo de riesgo
        Customer.RESET;
        Customer.SETRANGE("No.", pCustomerCode);
        IF Customer.FINDFIRST THEN;
        //EX-JFC 071221 Calcular la funcion con el nuevo calculo de riesgo

        //EX-JFC 071221 Calcular la funcion con el nuevo calculo de riesgo
        //Se comenta ya que no se va a usar este calculo
        //ImpRiesgoFinancieroConsig := ImpPedPteConsig + ImpAnulConsig + ImpEnviosLanzadosConsig + ImpEnviosSinLanzarConsig +
        //                             ImpPedTransitoConsig + ImpStockConsig + ImpFactPteConsig + ImpFactPteImpagConsig +
        //                             ImpEfecPendConsig + ImpEfecPendRemesasConsig + ImpEfectPendRemesasRegConsig;


        RiesgoCliente(pCustomerCode);
        GetDataAvalConsignacion(ImpPedPteConsig, ImpAnulConsig, ImpPedTransferPdtServirConsig,
                                                ImpEnviosLanzadosConsig, ImpEnviosSinLanzarConsig, ImpPedTransitoConsig,
                                                ImpStockConsig, ImpFactPteConsig, ImpFactPteImpagConsig,
                                                ImpEfecPendConsig, ImpEfecPendRemesasConsig, ImpEfectPendRemesasRegConsig,
                                                ImpagRemRechConsig);
        getImpagadosConsig(ImpagadosConsig);

        //3348 - MEP - 2022 03 03
        //Imp. Fact. Pte. Consignacion
        //Saldos Pendientes Consignacion
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Ventas en consignacion", TRUE);
        CustLedgerEntry.SETRANGE(Open, TRUE);
        CustLedgerEntry.SETRANGE("Customer No.", Customer."No.");
        IF CustLedgerEntry.FINDSET THEN
            REPEAT
                CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                ImpFactPteConsig2 += CustLedgerEntry."Remaining Amt. (LCY)";
            UNTIL CustLedgerEntry.NEXT = 0;

        //Cambiado Customer."Imp. Fact. Pte. Consignacion" por ImpFactPteConsig2"
        //EX-JFC 071221 Calcular la funcion con el nuevo calculo de riesgo
        //Importe riesgo financiero Pendiente
        ImpRiesgoFinancieroConsig := ImpFactPteConsig2 +
                                        (ImpStockConsig + ImpPedTransitoConsig +
                                            ImpEnviosLanzadosConsig + ImpEnviosSinLanzarConsig);
        //EX-JFC 071221 Calcular la funcion con el nuevo calculo de riesgo


        lRecConsignmentCondition.RESET;
        lRecConsignmentCondition.SETRANGE("Customer No.", pCustomerCode);
        lRecConsignmentCondition.SETRANGE("Register Type", lRecConsignmentCondition."Register Type"::Consignment);
        lRecConsignmentCondition.SETRANGE("Value Type", lRecConsignmentCondition."Value Type"::Aval);
        IF lRecConsignmentCondition.FINDFIRST THEN;

        ImpAvalDisp := lRecConsignmentCondition.Value - ImpRiesgoFinancieroConsig;

        EXIT(ImpAvalDisp)
    end;

    PROCEDURE GetDataAvalConsignacion(VAR pImpPedPteConsig: Decimal; VAR pImpAnulConsig: Decimal; VAR pImpPedTransferPdtServirConsig: Decimal;
     VAR pImpEnviosLanzadosConsig: Decimal; VAR pImpEnviosSinLanzarConsig: Decimal; VAR pImpPedTransitoConsig: Decimal;
     VAR pImpStockConsig: Decimal; VAR pImpFactPteConsig: Decimal; VAR pImpFactPteImpagConsig: Decimal;
     VAR pImpEfecPendConsig: Decimal; VAR pImpEfecPendRemesasConsig: Decimal; VAR pImpEfectPendRemesasRegConsig: Decimal;
     VAR pImpagRemRechConsig: Decimal);
    BEGIN
        //EX-CV
        pImpPedPteConsig := ImpPedPteConsig;
        pImpAnulConsig := ImpAnulConsig;
        pImpPedTransferPdtServirConsig := ImpPedTransferPdtServirConsig;
        pImpEnviosLanzadosConsig := ImpEnviosLanzadosConsig;
        pImpEnviosSinLanzarConsig := ImpEnviosSinLanzarConsig;
        pImpPedTransitoConsig := ImpPedTransitoConsig;
        pImpStockConsig := ImpStockConsig;
        pImpFactPteConsig := ImpFactPteConsig;
        pImpFactPteImpagConsig := ImpFactPteImpagConsig;
        pImpEfecPendConsig := ImpEfecPendConsig;
        pImpEfecPendRemesasConsig := ImpEfecPendRemesasConsig;
        pImpEfectPendRemesasRegConsig := ImpEfectPendRemesasRegConsig;
        pImpagRemRechConsig := ImpagRemRechConsig;
        //EX-CV END
    END;

    PROCEDURE getImpagadosConsig(VAR pImpagadosConsig: Decimal);
    BEGIN
        //EX-CV
        pImpagadosConsig := ImpagadosConsig;
        //EX-CV END
    END;

    PROCEDURE RiesgoCliente(CodCliente: Code[20]): Decimal;
    VAR
        ClienteRec: Record 18;
        CurrentDate: Date;
        ValueEntry: Record 5802;
        DateFilterCalc: Codeunit 358;
        CustDateFilter: ARRAY[4] OF Text[30];
        CustDateName: ARRAY[4] OF Text[30];
        TotalAmountLCY: Decimal;
        i: Integer;
        CostCalcMgt: Codeunit 5836;
        CustSalesLCY: ARRAY[4] OF Decimal;
        AdjmtCostLCY: ARRAY[4] OF Decimal;
        CustProfit: ARRAY[4] OF Decimal;
        ProfitPct: ARRAY[4] OF Decimal;
        AdjCustProfit: ARRAY[4] OF Decimal;
        AdjProfitPct: ARRAY[4] OF Decimal;
        CustInvDiscAmountLCY: ARRAY[4] OF Decimal;
        CustPaymentDiscLCY: ARRAY[4] OF Decimal;
        CustPaymentDiscTolLCY: ARRAY[4] OF Decimal;
        CustPaymentTolLCY: ARRAY[4] OF Decimal;
        CustReminderChargeAmtLCY: ARRAY[4] OF Decimal;
        CustFinChargeAmtLCY: ARRAY[4] OF Decimal;
        CustCrMemoAmountsLCY: ARRAY[4] OF Decimal;
        CustPaymentsLCY: ARRAY[4] OF Decimal;
        CustRefundsLCY: ARRAY[4] OF Decimal;
        CustOtherAmountsLCY: ARRAY[4] OF Decimal;
        InvAmountsLCY: ARRAY[4] OF Decimal;
        MovCli: Record 21;
        SaldoClientes: Record 50017;
        //PickLinResumen : Record 50010;
        CantPicking: Integer;
        RecLinPedido: Record 37;
        FactorCant: Decimal;
        MovReserva: Record 50012;
        RecPedido: Record 36;
        RecPedido2: Record 36;
        RecLinVta: Record 37;
        "--EX-LV-SGG": Integer;
        //lRstLinEnvAlm : Record 50403;
        lImpAux: Decimal;
        lRecTransferHeader: Record 5740;
        lRecTransferLine: Record 5741;
        lRecSalesHeader: Record 36;
        lRecLocation: Record 14;
        lRecItemLedEntry: Record 32;
        lRecItem: Record 27;
        lQtyPerUnitMeasurement: Decimal;
        lcuUOMMgt: Codeunit 5402;
        recTransferLine: Record 5741;
        TransferHeader: Record 5740;
        lPedConsig: Boolean;
        //lRstHeadEnvAlm : Record 50402;
        lRecCustomer: Record 18;
        CustLedgerEntry: Record 21;
        ImpFactPte: Decimal;
        SaldoMigracion: Decimal;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Impagados: Decimal;
        FactPte: Decimal;
    BEGIN

        SaldoMigracion := 0;
        ClienteRec.RESET;
        ClienteRec.GET(CodCliente); //EX-SGG-WMS 100719
        ClienteRec.CalcFields("Riesgo Concedido Consignacion", "Riesgo Concedido Firme");

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

                IF Not CalcularRiesgoCliSinAlbaranes THEN //EX-SGG-WMS 090719
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
                        //IF RecPedido."No. Series"<>'S-SHPT-SC'  THEN
                        IF RecPedido2."Shipping No. Series" <> 'S-SHPT-SC' THEN BEGIN
                            //EX-JFC 14/11/14 Calcular el importe en EUROS
                            RecPedido.RESET;
                            RecPedido.SETRANGE(RecPedido."No.", RecLinVta."Document No.");
                            IF RecPedido.FINDFIRST THEN BEGIN
                                //SF-MLA 16/03/16 Se redondea y se hace el cambio de divisa sobre el total para no perder c ntimos.
                                //EX-CV
                                IF NOT RecPedido."Ventas en consignacion" THEN
                                    ImpAlb += (RecLinVta."Qty. Shipped Not Invoiced" * RecLinVta."Unit Price" -
                                    RecLinVta."Inv. Discount Amount" * FactorCant -
                                    RecLinVta."Pmt. Discount Amount" * FactorCant)
                                    * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);
                                //EX-CV END
                                //                                 {
                                //                                 END ELSE
                                //                                 BEGIN

                                //                                   Currency.InitRoundingPrecision;
                                //                                   ImpAlb += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                //                                   RecPedido."Posting Date", RecPedido."Currency Code",
                                //                                   ((RecLinVta."Qty. Shipped Not Invoiced" * RecLinVta."Unit Price" -
                                //                                   RecLinVta."Inv. Discount Amount" * FactorCant -
                                //                                   RecLinVta."Pmt. Discount Amount" * FactorCant)
                                //                                   * (1 + RecLinVta."VAT %"/100 + RecLinVta."EC %"/100)),
                                //                                   RecPedido."Currency Factor"),
                                //                                   Currency."Amount Rounding Precision");
                                //                                 }
                            END;

                            //EX-JFC 14/11/14 Calcular el importe en EUROS

                        END;
                    END;
                    //fin modificado
                END; //EX-SGG-WMS 090719

            UNTIL RecLinVta.NEXT = 0;
        //SF-ALD 090317 El factor de divisa corresponder  al  ltimo factor de divisa existente
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
        //       IF NOT RecFormaPago."Bloqueo impago" THEN
        //         MovCli.SETFILTER("Due Date",'<%1',WORKDATE - 15)
        //       ELSE
        MovCli.SETFILTER("Due Date", '<=%1', WORKDATE);
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
        //       IF NOT RecFormaPago."Bloqueo impago" THEN
        //         MovCli.SETFILTER("Due Date",'<%1',WORKDATE - 15)
        //       ELSE BEGIN
        MovCli.SETFILTER("Due Date", '<=%1', WORKDATE);
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

        //       ImpPicking := 0;
        //       FactorCant := 0;
        //       PickLinResumen.RESET;
        //       PickLinResumen.SETRANGE("Pedido Cliente No.",CodCliente);
        //       PickLinResumen.SETRANGE("Envio No.",'');
        //       IF PickLinResumen.FINDFIRST THEN
        //         REPEAT
        //           IF RecLinPedido.GET(RecLinPedido."Document Type"::Order,PickLinResumen."Pedido No.",PickLinResumen."Pedido Linea No.") THEN
        //           BEGIN
        //             IF (RecLinPedido."Outstanding Quantity" - RecLinPedido."Cantidad Anulada") <> 0 THEN BEGIN
        //               //SF-LBD 17/06/14

        //               //SF-MLA 29/03/16 Igual el c lculo al resto de formularios.
        //               //FactorCant := PickLinResumen.Cantidad/
        //               //(RecLinPedido.Quantity - RecLinPedido."Cantidad Anulada");
        //               FactorCant := PickLinResumen.Cantidad/RecLinPedido.Quantity;
        //               //FactorCant := PickLinResumen.Cantidad/
        //               //(RecLinPedido."Outstanding Quantity" - RecLinPedido."Cantidad Anulada");
        //               //SF-LBD FIN
        //             //EX-JFC 14/11/14 Calcular el importe en EUROS
        //                 RecPedido.RESET;
        //                 RecPedido.SETRANGE(RecPedido."No.",RecLinPedido."Document No.");
        //                 IF RecPedido.FINDFIRST THEN
        //                 BEGIN
        //                  // IF RecPedido."Currency Code" = '' THEN BEGIN
        //                  IF FactorCant <>0 THEN BEGIN
        //                     ImpPicking += (RecLinPedido."Unit Price" * PickLinResumen.Cantidad -
        //                     RecLinPedido."Inv. Discount Amount" * FactorCant -
        //                     RecLinPedido."Pmt. Discount Amount" * FactorCant) *
        //                     (1 + RecLinPedido."VAT %"/100 + RecLinPedido."EC %"/100)
        //                  END ELSE BEGIN
        //                     ImpPicking += (RecLinPedido."Unit Price" * PickLinResumen.Cantidad -
        //                     RecLinPedido."Inv. Discount Amount" -
        //                     RecLinPedido."Pmt. Discount Amount") *
        //                     (1 + RecLinPedido."VAT %"/100 + RecLinPedido."EC %"/100)

        //                  END;
        // //                   {
        // //                   END ELSE
        // //                   BEGIN
        // //                     Currency.InitRoundingPrecision;
        // //                     ImpPicking += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
        // //                     RecPedido."Posting Date", RecPedido."Currency Code",
        // //                     ((RecLinPedido."Unit Price" * PickLinResumen.Cantidad -
        // //                     RecLinPedido."Inv. Discount Amount" * FactorCant -
        // //                     RecLinPedido."Pmt. Discount Amount" * FactorCant) *
        // //                     (1 + RecLinPedido."VAT %"/100 + RecLinPedido."EC %"/100)),
        // //                     RecPedido."Currency Factor"),
        // //                     Currency."Amount Rounding Precision");
        // //                   END;
        // //                   }
        //                END;
        //              END;
        //              //EX-JFC 14/11/14 Calcular el importe en EUROS
        //            END;
        //         UNTIL PickLinResumen.NEXT = 0;
        //SF-MLA 29/03/16 Se redondea y se hace el cambio de divisa sobre el total para no perder c ntimos.
        //       IF RecPedido."Currency Code" <> '' THEN BEGIN
        //         ImpPicking:= ROUND(CurrExchRate.ExchangeAmtFCYToLCY(RecPedido."Posting Date", RecPedido."Currency Code",
        //         ImpPicking,RecPedido."Currency Factor"),Currency."Amount Rounding Precision");
        //       END;

        //       ImpReserva := 0;
        //       RecPedido.RESET;
        //       RecPedido.SETRANGE("Document Type",RecPedido."Document Type"::Order);
        //       RecPedido.SETRANGE("Sell-to Customer No.",CodCliente);
        //       IF RecPedido.FINDFIRST THEN
        //         REPEAT
        //           RecPedido.CALCFIELDS("Reserva Picking");
        //           IF RecPedido."Reserva Picking" <> 0 THEN BEGIN
        //             MovReserva.RESET;
        //             MovReserva.SETRANGE("Origen Documento No.",RecPedido."No.");
        //             IF MovReserva.FINDFIRST THEN
        //               REPEAT
        //           IF RecLinPedido.GET(RecLinPedido."Document Type"::Order,
        //                 MovReserva."Origen Documento No.",MovReserva."Origen Documento Line No.") THEN
        //           BEGIN
        //             IF RecLinPedido."Outstanding Quantity" <> 0 THEN BEGIN
        //               //SF-LBD 17/06/14
        //               FactorCant := MovReserva."Cantidad Reservada"/RecLinPedido.Quantity;
        //               //FactorCant := MovReserva."Cantidad Reservada"/RecLinPedido."Outstanding Quantity";
        //               //SF-LBD FIN
        //             //EX-JFC 14/11/14 Calcular el importe en EUROS
        //                 //RecPedido.RESET;
        //                 //RecPedido.SETRANGE(RecPedido."No.",RecLinPedido."Document No.");
        //                 //IF RecPedido.FINDFIRST THEN
        //                 //BEGIN
        //                   IF RecPedido."Currency Code" = '' THEN BEGIN
        //                     ImpReserva += (RecLinPedido."Unit Price" * MovReserva."Cantidad Reservada" -
        //                     RecLinPedido."Inv. Discount Amount" * FactorCant -
        //                     RecLinPedido."Pmt. Discount Amount" * FactorCant) *
        //                     (1 + RecLinPedido."VAT %"/100 + RecLinPedido."EC %"/100)
        //                   END ELSE
        //                   BEGIN
        //                     Currency.InitRoundingPrecision;
        //                     ImpReserva += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
        //                     RecPedido."Posting Date", RecPedido."Currency Code",
        //                     ((RecLinPedido."Unit Price" * MovReserva."Cantidad Reservada" -
        //                   RecLinPedido."Inv. Discount Amount" * FactorCant -
        //                   RecLinPedido."Pmt. Discount Amount" * FactorCant) *
        //                   (1 + RecLinPedido."VAT %"/100 + RecLinPedido."EC %"/100)),
        //                     RecPedido."Currency Factor"),
        //                     Currency."Amount Rounding Precision");
        //                   END;
        //                //END;
        //              END;
        //             //EX-JFC 14/11/14 Calcular el importe en EUROS
        //           END;

        //               UNTIL MovReserva.NEXT = 0;
        //           END;

        //           //EX-CV
        //           IF RecPedido."Ventas en consignacion" THEN BEGIN
        //             lRecTransferLine.RESET;
        //             lRecTransferLine.SETRANGE(lRecTransferLine."No. pedido", RecPedido."No.");
        //             IF lRecTransferLine.FINDSET THEN REPEAT
        //               lRstLinEnvAlm.RESET;
        //               lRstLinEnvAlm.SETRANGE("Source No.", lRecTransferLine."Document No.");
        //               lRstLinEnvAlm.SETRANGE("Source Line No.", lRecTransferLine."Line No.");
        //               IF lRstLinEnvAlm.FINDFIRST THEN BEGIN

        //                 IF RecLinVta.GET(RecLinVta."Document Type"::Order,RecPedido."No.",lRstLinEnvAlm."Source Line No.") THEN;
        //                  CLEAR(FactorCant);
        //                  IF RecLinVta.Quantity <> 0 THEN
        //                    FactorCant := lRstLinEnvAlm.Quantity/RecLinVta.Quantity;

        //                 lImpAux := (lRstLinEnvAlm.Quantity * RecLinVta."Unit Price" -
        //                   RecLinVta."Inv. Discount Amount" * FactorCant -
        //                   RecLinVta."Pmt. Discount Amount" * FactorCant)
        //                   * (1 + RecLinVta."VAT %"/100 + RecLinVta."EC %"/100);

        //                 lRstHeadEnvAlm.RESET;
        //                 lRstHeadEnvAlm.SETRANGE("No.", lRstLinEnvAlm."No.");
        //                 IF lRstHeadEnvAlm.FINDFIRST THEN BEGIN
        //                   CASE lRstLinEnvAlm."Estado cabecera" OF
        //                    lRstLinEnvAlm."Estado cabecera"::Released: ImpEnviosLanzadosConsig+=lImpAux;
        //                    lRstLinEnvAlm."Estado cabecera"::Open: ImpEnviosSinLanzarConsig+=lImpAux;
        //                   END;
        //                 END;
        //               END;
        //             UNTIL lRecTransferLine.NEXT = 0;
        //           END;
        //           //EX-CV END
        //         UNTIL RecPedido.NEXT = 0;

        //EX-SGG-WMS 100719 INCLYO ENVIOS ALMACEN
        //       CLEAR(ImpEnviosLanzados);
        //       CLEAR(ImpEnviosSinLanzar);
        //       lRstLinEnvAlm.RESET;
        //       lRstLinEnvAlm.SETCURRENTKEY("No.","Destination Type","Destination No.");
        //       lRstLinEnvAlm.SETRANGE("Destination Type",lRstLinEnvAlm."Destination Type"::Customer);
        //       lRstLinEnvAlm.SETRANGE("Destination No.",ClienteRec."No.");
        //       lRstLinEnvAlm.SETRANGE("Source Type",DATABASE::"Sales Line");
        //       IF lRstLinEnvAlm.FINDSET THEN
        //        REPEAT
        //         IF RecLinVta.GET(RecLinVta."Document Type"::Order,lRstLinEnvAlm."Source No.",lRstLinEnvAlm."Source Line No.") THEN
        //          BEGIN
        //            CLEAR(FactorCant);
        //            IF RecLinVta.Quantity <> 0 THEN
        //              FactorCant := lRstLinEnvAlm.Quantity/RecLinVta.Quantity;

        //             lImpAux := (lRstLinEnvAlm.Quantity * RecLinVta."Unit Price" -
        //               RecLinVta."Inv. Discount Amount" * FactorCant -
        //               RecLinVta."Pmt. Discount Amount" * FactorCant)
        //               * (1 + RecLinVta."VAT %"/100 + RecLinVta."EC %"/100);

        //             //EX-CV
        //             lPedConsig := FALSE;
        //             {
        //             lPedConsig := FALSE;
        //             TransferHeader.RESET;
        //             TransferHeader.SETRANGE("No.", lRstLinEnvAlm."Source No.");
        //             IF TransferHeader.FINDFIRST THEN BEGIN
        //               recTransferLine.RESET;
        //               recTransferLine.SETRANGE("Document No.", TransferHeader."No.");
        //               recTransferLine.SETRANGE("Line No.", lRstLinEnvAlm."Source Line No.");
        //               IF recTransferLine.FINDFIRST THEN BEGIN
        //                 lRecSalesHeader.RESET;
        //                 //SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        //                 lRecSalesHeader.SETRANGE("No.", TransferHeader."No. pedido venta");
        //                 lRecSalesHeader.SETRANGE("Ventas en consignacion", TRUE);
        //                 IF lRecSalesHeader.FINDFIRST THEN BEGIN
        //                   lPedConsig := TRUE;
        //                   CASE lRstLinEnvAlm."Estado cabecera" OF
        //                    lRstLinEnvAlm."Estado cabecera"::Released: ImpEnviosLanzadosConsig+=lImpAux;
        //                    lRstLinEnvAlm."Estado cabecera"::Open: ImpEnviosSinLanzarConsig+=lImpAux;
        //                   END;
        //                 END;
        //               END;
        //             END;

        //             IF NOT lPedConsig THEN BEGIN
        //               lRecSalesHeader.RESET;
        //               //SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        //               lRecSalesHeader.SETRANGE("No.",  lRstLinEnvAlm."Source No.");
        //               lRecSalesHeader.SETRANGE("Ventas en consignacion", TRUE);
        //               IF lRecSalesHeader.FINDFIRST THEN BEGIN
        //                 lPedConsig := TRUE;
        //                 CASE lRstLinEnvAlm."Estado cabecera" OF
        //                  lRstLinEnvAlm."Estado cabecera"::Released: ImpEnviosLanzadosConsig+=lImpAux;
        //                  lRstLinEnvAlm."Estado cabecera"::Open: ImpEnviosSinLanzarConsig+=lImpAux;
        //                 END;
        //               END;
        //             END;
        //             }
        //             IF NOT lPedConsig THEN BEGIN
        //               CASE lRstLinEnvAlm."Estado cabecera" OF
        //                lRstLinEnvAlm."Estado cabecera"::Released: ImpEnviosLanzados+=lImpAux;
        //                lRstLinEnvAlm."Estado cabecera"::Open: ImpEnviosSinLanzar+=lImpAux;
        //               END;
        //             END;
        //           //EX-CV END
        //          END;
        //        UNTIL lRstLinEnvAlm.NEXT=0;

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
        //EXIT(ClienteRec."Riesgo NUEVO MILENIO" -
        //(ImpAlb + OpenRemainingAmtLCY[1] + OpenRemainingAmtLCY[2] + OpenRemainingAmtLCY[3] +
        // SaldoMigracion + ImpPicking + FactPte + ImpReserva+ImpEnviosLanzados) - Impagados);

        //EX-CV  -  2022 03 10
        //Saldos Pendientes
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Ventas en consignacion", FALSE);
        CustLedgerEntry.SETRANGE(Open, TRUE);
        CustLedgerEntry.SETRANGE("Customer No.", lRecCustomer."No.");
        IF CustLedgerEntry.FINDSET THEN
            REPEAT
                CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                ImpFactPte += CustLedgerEntry."Remaining Amt. (LCY)";
            UNTIL CustLedgerEntry.NEXT = 0;


        exit((ClienteRec."Riesgo Concedido Consignacion" + ClienteRec."Riesgo Concedido Firme") - (ImpFactPte + ImpAlb + SaldoMigracion + ImpEnviosLanzados));
        //EXIT(ClienteRec."Riesgo Concedido" - (ImpFactPte + ImpAlb + SaldoMigracion + ImpEnviosLanzados));
        //ImpPicking + ImpReserva + ImpEnviosLanzados));
        //EX-CV  -  2022 03 10 END
        //EX-CV END
    END;

    PROCEDURE getSalesPrice(pItem: Code[20]; pCustomer: Record 18; pVariant: Code[20]): Decimal;
    VAR
        SalesPrice: Record 7002;
        ConsignmentCondition: Record 50051;
        ret: Decimal;
        lrecItem: Record 27;
        lrecVATPostingSetup: Record 325;
        lIVA: Decimal;
    BEGIN
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

        IF ret <> 0 THEN BEGIN
            ConsignmentCondition.RESET;
            ConsignmentCondition.SETRANGE("Customer No.", pCustomer."No.");
            ConsignmentCondition.SETRANGE("Register Type", ConsignmentCondition."Register Type"::Consignment);
            ConsignmentCondition.SETRANGE("Value Type", ConsignmentCondition."Value Type"::"% Dto Factura Consignación");
            IF ConsignmentCondition.FINDFIRST THEN BEGIN
                ret := ret - ((ConsignmentCondition.Value) * ret / 100)
            END;
        END;

        EXIT(ret);
        //EX-CV END
    END;

    PROCEDURE UpdateDocStatistics(CodCli: Code[20]);
    VAR
        CustLedgEntry: Record 21;
        DocumentSituationFilter: ARRAY[3] OF option " ","Posted BG/PO","Closed BG/PO","BG/PO",Cartera,"Closed Documents";
        j: Integer;
        NoOpen: ARRAY[5] OF Integer;
        NoHonored: ARRAY[5] OF Integer;
        NoRejected: ARRAY[5] OF Integer;
        NoRedrawn: ARRAY[5] OF Integer;
        OpenAmtLCY: ARRAY[5] OF Decimal;
        HonoredAmtLCY: ARRAY[5] OF Decimal;
        RejectedAmtLCY: ARRAY[5] OF Decimal;
        RedrawnAmtLCY: ARRAY[5] OF Decimal;
        RejectedRemainingAmtLC: ARRAY[5] OF Decimal;
        HonoredRemainingAmtLCY: ARRAY[5] OF Decimal;
        RedrawnRemainingAmtLCY: ARRAY[5] OF Decimal;
        ImpagRem: ARRAY[5] OF Decimal;
        ClienteImpag: Record 18;
        MovCli: Record 21;
    BEGIN
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
                    //   IF NOT RecFormaPago."Bloqueo impago" THEN
                    //     MovCli.SETFILTER("Due Date",'<%1',WORKDATE - 15)
                    //   ELSE
                    MovCli.SETFILTER("Due Date", '<=%1', WORKDATE);
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


    //     BEGIN
    //     {
    //       IF RiesgoDisp <= 0 THEN
    //         CurrPage.RD.UPDATEFORECOLOR(255);

    //       26/11/2013 CARLOS C001 - Ahora se le env a el c digo de picking completo.
    //                                 Antes   AL12345 > 12345
    //                                 Despu s AL12345 > AL12345

    //       24/11/2014 CARLOS C002 - El c digo RFID de la forma de pago no tiene sentido.

    //       23/05/2016 CARLOS C003 - Se sustituye el caracter ';' de los comentarios de pedidos
    //                                porque puede provocar errores en la importaci n de los ficheros

    //       20/02/2018 NM_CSA_180220 Eliminamos el campo "Cantidad Publicidad" de T36 Sales Header porque no se usa.
    //       EX-OMI-WMS 270519 Paso de funciones a codeunit 50000 de bloqueoclientes y vencimientos15
    //       ******************
    //       EX-SGG-WMS 200619 COPIA DE FRM50023 PARA TRATAMIENTO SOLO PRODUCTOS SEGA Y GENERACI N SOLO DE ENVIOS ALMACEN.
    //                         REEMPLAZO VALORES FILTROS DE CAMPO Proceso DE 'WMS*' A 'WMS*'. COMENTO ASIGN. CAMPOS PDA Y Clasificadora
    //                         ELIMINO BOTON Clasificadora . FUNCION FiltrosRiesgoRetenidoImpago. CODIGO REFER. BOTON PDA -> Generar Envios WMS
    //                  100919 NUEVA FUNCION filtroalmacenessega. CODIGO REFERENCIA.
    //                  110919 CODIGO EN BOTON Generar env os WMS PARA ESTABLECER CANTIDADES A ENVIAR SEGUN ASIGNACIONES Y GENERAR ENVIOS ALMACEN
    //                  130919 NO COMPROBAR AL MODIFICAR CANTIDAD A ENVIAR A 0 EN PROPOSICI N.
    //                  180919 INCLUYO EN CALCULO DE TALLAS Cant. envios lanzados
    //                  230919 NUEVA FUNCION ExistenLineasAsignadas. CODIGO LLAMADA EN ONFORMAT DE CONTROL USUARIO Y NO. PEDIDO.
    //       EX-SGG 291020 AGREGAR VENTANA DE PROGESO EN BtnGenerarEnviosWMS - OnPush()
    //       EX-RBF 300321 AGREGAR SEGUNDA VENTANA DE PROGESO EN BtnGenerarEnviosWMS - OnPush().
    //       EX-SGG 171122 NUEVO SUBMENU "L neas Proposici n Matriz". COPY/PASTE DE ORIGINAL + CAMBIOS EN SU CODIGO:
    //                     - HEREDAR NUEVOS CAMPOS.
    //                     - LLAMAR A NUEVO FORMULARIO CON MATRIX "Modif Prop Venta Lineas Matriz" CON KEY MODIFICADA.
    //                     - INSERCCION LINEAS PROCESO 'WMSMATRIX' Y CABECERAS 'WMSMATRIXC'
    //              181122 LIMPIEZA CODIGO ANTIGUO EN NUEVO SUBMENU.
    //              221122 CORRECCIONES.
    //              231122 ELIMINACION CODIGO INNECESARIO REFERETE A CAMPOS TALLA MENU "L neas Proposici n Matriz"
    //              091222 COMENTO USO "Proposicion Venta" CONFIG USUARIO EN MENU "L neas Proposici n Matriz".
    //                     NUEVAS FUNCIONES LineasProposicionNormal Y LineasProposicionMatriz PARA LLEVAR CODIGO QUE RESIDIA EN
    //                       CADA UNO DE LOS SUBMENUS.
    //                     SE MANTIENE SOLO UN SUBMENU "L neas Proposici n" DONDE SE DETERMINAR  QU  FORMULARIO DE ASIGNACIONES SERA MOSTRADO EN
    //                       FUNCI N DE DETERMINADAS CASUISTICAS. USO NUEVO CAMPO "Tipo proposicion calculada".
    //              121222 CORRECCION. OCULTO NUEVO SUBMENU PRA DEJAR SOLO 1 OPCION.
    //              161222 CONTROL RECALCULOS STOCK.
    //              191222 LLAMADA NUEVA FUNCION ObtenerOtrasCantAsignadas. CODIGO REFERENCIA.
    //                     COMPROBACION PARA NO SUPERAR EL STOCK EN LA CANTIDAD ASIGNADA PARA LA MATRIX.
    //     }
    //     END.
    //   }
}

