/// <summary>
/// Codeunit FuncionesWMS (ID 50003).
/// </summary>
codeunit 50003 "FuncionesWMS"
{
    trigger OnRun()
    Var
        CUFunciones: Codeunit 50000;
        lRecConsignmentCondition: Record 50051;
        Rec: Record "Filtros Proposicion";


    BEGIN
        Rec.Get();

        RecUser.GET(USERID);
        RecUser."Proposicion Venta" := FALSE;
        RecUser.MODIFY;


        Salir := FALSE;
        IncrCant := 0;
        ContadorLin := 0;
        LinPedido.RESET;

        //IF Rec."F. Fecha Servicio Confirm." <> '' THEN
        //LinPedido.SETCURRENTKEY("Fecha servicio confirmada")
        //ELSE
        //LinPedido.SETCURRENTKEY("Document Type","Document No.","Line No.");
        LinPedido.SETCURRENTKEY("Document Type", Type, "Document No.", "Shortcut Dimension 1 Code", "Fecha servicio confirmada",
        "Sell-to Customer No.", Agente, "Location Code", "No.", "PfsVertical Component", "Cod. almacen consignacion");


        LinPedido.SETRANGE("Document Type", LinPedido."Document Type"::Order);
        LinPedido.SETRANGE(Type, LinPedido.Type::Item);
        IF Rec."Filtro Pedido" <> '' THEN
            LinPedido.SETFILTER("Document No.", Rec."Filtro Pedido");
        IF Rec.Temporada <> '' THEN
            LinPedido.SETFILTER("Shortcut Dimension 1 Code", Rec.Temporada);
        IF Rec."F. Fecha Servicio Confirm." <> '' THEN
            LinPedido.SETFILTER("Fecha servicio confirmada", Rec."F. Fecha Servicio Confirm.");
        IF Rec."Filtro Cliente" <> '' THEN
            LinPedido.SETFILTER("Sell-to Customer No.", Rec."Filtro Cliente");
        // IF FRepresentante <> '' THEN
        //     LinPedido.SETFILTER(Agente, FRepresentante);
        IF FAlmacen <> '' THEN
            LinPedido.SETFILTER("Location Code", FAlmacen);
        IF Rec."Filtro Producto" <> '' THEN
            LinPedido.SETFILTER("No.", Rec."Filtro Producto");
        IF Rec."Filtro Color" <> '' THEN
            LinPedido.SETFILTER("PfsVertical Component", Rec."Filtro Color");
        //EX.CGR.140920
        IF Rec."Tipo Pedido" = Rec."Tipo Pedido"::"Pedidos en firme" THEN
            LinPedido.SETFILTER("Cod. almacen consignacion", '%1', '');
        IF Rec."Tipo Pedido" = Rec."Tipo Pedido"::"Pedidos consignacion" THEN
            LinPedido.SETFILTER("Cod. almacen consignacion", '<>%1', '');



        LinPedido.SETRANGE(LinPedido.Status, LinPedido.Status::Open);
        LinPedido.SETRANGE(LinPedido."Proposicion Venta", FALSE);
        //LinPedido.SETRANGE(LinPedido."Picking Manual", FALSE);
        //LinPedido.SETRANGE(LinPedido."Pedido Magento", FALSE);
        LinPedido.SETRANGE("Producto SEGA", TRUE); //EX-SGG-WMS 200619
        IF LinPedido.FINDFIRST THEN
            REPEAT
                IF CabPedido.GET(CabPedido."Document Type"::Order, LinPedido."Document No.") THEN;
                CabPedido.CALCFIELDS("Proposicion Venta");
                //IF ((CabPedido.Status = CabPedido.Status::Released) AND (NOT CabPedido."Proposicion Venta") AND
                //(NOT CabPedido."Picking Manual"))  THEN BEGIN
                RecCli.GET(CabPedido."Sell-to Customer No.");
                ClienteBloq := FALSE;
                IF EstadoCli.GET(RecCli.CustomerStatus) THEN
                    //RecCli.CustomerStatus
                    IF not EstadoCli."Envíos permitidos" Then //EstadoCli."Sales Shipment Blocked" THEN
                        ClienteBloq := TRUE;
                //EX-OMI-WMS 270519

                //IF ((NOT RecCli.Vencimiento15(CabPedido."Sell-to Customer No.")) AND
                IF ((NOT CUFunciones.Vencimiento15(CabPedido."Sell-to Customer No.")) AND
                    //EX-OMI-WMS fin

                    (NOT CabPedido."Pedido Retenido") AND (NOT ClienteBloq)) and (TipoServ(CabPedido."Tipo Servicio", Rec)) THEN BEGIN
                    ContadorLin += 1;
                    If Rec."Num pedidos a enviar" <> 0 Then
                        if ContadorLin = Rec."Num pedidos a enviar" Then Salir := True;
                    //LinPedido.CALCFIELDS("Cantidad Picking","Cant. env. lanz. SKU todos PV");
                    LinPedido.CALCFIELDS("Cant. envios lanzados", "Cant. en envios almacen"); //EX-SGG-WMS 100919
                                                                                              //EX-SGG-WMS 180919
                                                                                              // V.UPDATE(1, CabPedido."No.");
                                                                                              // V.UPDATE(2, LinPedido."Fecha servicio confirmada");
                                                                                              // V.UPDATE(3, ContadorLin);
                    TemporalRec.INIT;
                    TemporalRec."Clave 1" := LinPedido."Document No.";                  //N  pedido
                    TemporalRec.Proceso := 'WMSLIN';
                    TemporalRec."Clave 2" := LinPedido."PfsHorizontal Component";       //Talla
                    TemporalRec."Clave 3" := LinPedido."Sell-to Customer No.";          //Cliente
                    TemporalRec."Clave 4" := LinPedido."No.";                           //producto
                    TemporalRec."Clave 5" := LinPedido."PfsVertical Component";         //color
                    TemporalRec."Fecha Servicio" := LinPedido."Fecha servicio confirmada";
                    TemporalRec.Temporada := LinPedido."Shortcut Dimension 1 Code";
                    TemporalRec.usuario := USERID;

                    TemporalRec."Nombre Cliente" := CabPedido."Sell-to Customer Name";
                    TemporalRec.Color := LinPedido."PfsVertical Component";
                    TemporalRec.Talla := LinPedido."PfsHorizontal Component";
                    TemporalRec."Serie Precio" := LinPedido."Serie Precio";
                    TemporalRec.Sucursal := '1';
                    TemporalRec.Prioridad := '0';
                    //TemporalRec.Sucursal := Sucursal;
                    //TemporalRec.Prioridad := Prioridad;
                    TemporalRec."Cod Variante" := LinPedido."Variant Code";
                    //TemporalRec.CodPreemb := LinPedido."Prepack Code";
                    //TemporalRec."Cant Preemb" := LinPedido."PfsPrepack Quantity";
                    TemporalRec.Linea := LinPedido."Line No.";
                    IF TemporalRec.CodPreemb <> '' THEN
                        TemporalRec.VarPreemb := LinPedido."PfsVertical Component" + '-' + TemporalRec.CodPreemb;
                    TemporalRec."Clave 6" := TemporalRec.VarPreemb;
                    //EX.CGR.140920
                    IF Rec."Tipo Pedido" = Rec."Tipo Pedido"::"Pedidos consignacion" THEN
                        TemporalRec."Consignacion venta" := TRUE;

                    //+EX-SGG 171122
                    RecProd.GET(TemporalRec."Clave 4"); //EX-SGG 121222
                    TemporalRec."Tipo de producto" := RecProd.Tipo;
                    TemporalRec."Cod. grupo talla" := LinPedido."PfsHorz Component Group";
                    //-EX-SGG 171122

                    IF NOT TemporalRec.INSERT THEN BEGIN
                        TemporalRecMod.RESET;
                        TemporalRecMod.SETCURRENTKEY("Clave 1", "Clave 2", "Clave 3", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario, Insertado);
                        TemporalRecMod.SETRANGE("Clave 1", TemporalRec."Clave 1");
                        TemporalRecMod.SETRANGE("Clave 2", TemporalRec."Clave 2");
                        TemporalRecMod.SETRANGE("Clave 3", TemporalRec."Clave 3");
                        TemporalRecMod.SETRANGE("Clave 4", TemporalRec."Clave 4");
                        TemporalRecMod.SETRANGE("Clave 5", TemporalRec."Clave 5");
                        TemporalRecMod.SETRANGE("Clave 6", TemporalRec."Clave 6");
                        TemporalRecMod.SETRANGE(Proceso, 'WMSLIN');
                        TemporalRecMod.SETRANGE(usuario, USERID);
                        TemporalRecMod.SETRANGE(Insertado, FALSE);
                        IF TemporalRecMod.FINDFIRST THEN BEGIN
                            TemporalRecMod.Cantidad += LinPedido."PfsOrder Quantity";
                            //EX-CV  -  2708  -  JX  -  2021 04 13
                            LinPedido.CALCFIELDS("Cantidad transferencia", "Cantidad en consignacion");
                            TemporalRecMod."Cantidad Pendiente" += LinPedido."Outstanding Quantity" -
                                                                    (LinPedido."Cantidad transferencia" + LinPedido."Cantidad en consignacion");

                            //EX-CV  -  2708  -  JX  -  2021 04 13 END
                            TemporalRecMod."Cantidad Anulada" += LinPedido."Cantidad Anulada";
                            TemporalRecMod."Cantidad Servida" += LinPedido."Quantity Shipped";
                            TemporalRecMod."Serie Precio" := LinPedido."Serie Precio";
                            //SF-POF
                            IF LinPedido."VAT Calculation Type" <> LinPedido."VAT Calculation Type"::"Reverse Charge VAT" THEN
                                TemporalRecMod."Importe Pedido" += LinPedido."Outstanding Amount"
                            ELSE
                                TemporalRecMod."Importe Pedido" += LinPedido.Amount;
                            //SF-POF:FIN
                            IF LinPedido."Cantidad Anulada" = 0 THEN
                                TemporalRecMod."Importe Pte No anul" += LinPedido."Outstanding Amount"
                            ELSE BEGIN
                                IF LinPedido."Cantidad Anulada" <> LinPedido."PfsOrder Quantity" THEN
                                    TemporalRecMod."Importe Pte No anul" +=
                                    ((LinPedido."PfsOrder Quantity" - LinPedido."Cantidad Anulada") / LinPedido."PfsOrder Quantity") *
                                    LinPedido."Outstanding Amount";
                            END;
                            // TemporalRecMod."Cantidad Picking" +=
                            //     CantPicking(LinPedido."No.", LinPedido."PfsVertical Component", LinPedido."PfsHorizontal Component",
                            //     LinPedido."PfsPrepack Code");
                            // TemporalRecMod."Cantidad Reserva" +=
                            //     CalculoReserva2(LinPedido."No.", LinPedido."PfsVertical Component",
                            //     LinPedido."PfsHorizontal Component", LinPedido."PfsPrepack Code");
                            TemporalRecMod."Cant. envios lanzados" += LinPedido."Cant. en envios almacen";// ."Cant. env. lanz. SKU todos PV"; //EX-SGG-WMS 100919 180919
                                                                                                          //TemporalRecMod."Picking Pedido" += LinPedido."Cantidad Picking";
                            TemporalRecMod."Reserva Pedido" += CalculoReserva(LinPedido."Document No.", LinPedido."Line No.");
                            TemporalRecMod."Cant. envios lanzados pedido" += LinPedido."Cant. envios lanzados"; //EX-SGG-WMS 100919

                            TemporalRecMod.MODIFY;
                        END;
                    END ELSE BEGIN
                        TemporalRec.Cantidad := LinPedido."PfsOrder Quantity";
                        //EX-CV  -  2708  -  JX  -  2021 04 13
                        LinPedido.CALCFIELDS("Cantidad transferencia", "Cantidad en consignacion");
                        TemporalRec."Cantidad Pendiente" := LinPedido."Outstanding Quantity" -
                                                            (LinPedido."Cantidad transferencia" + LinPedido."Cantidad en consignacion");
                        //EX-CV  -  2708  -  JX  -  2021 04 13 END
                        TemporalRec."Cantidad Anulada" := LinPedido."Cantidad Anulada";
                        TemporalRec."Cantidad Servida" := LinPedido."Quantity Shipped";
                        //TemporalRec."Importe Pedido" := LinPedido."Outstanding Amount";
                        //SF-POF
                        IF LinPedido."VAT Calculation Type" <> LinPedido."VAT Calculation Type"::"Reverse Charge VAT" THEN
                            TemporalRec."Importe Pedido" += LinPedido."Outstanding Amount"
                        ELSE
                            TemporalRec."Importe Pedido" += LinPedido.Amount;
                        //SF-POF:FIN

                        // TemporalRec."Cantidad Picking" :=
                        // CantPicking(LinPedido."No.", LinPedido."PfsVertical Component", LinPedido."PfsHorizontal Component",
                        //     LinPedido."PfsPrepack Code");

                        //TemporalRec."Picking Pedido" := LinPedido."Cantidad Picking";
                        TemporalRec."Reserva Pedido" := CalculoReserva(LinPedido."Document No.", LinPedido."Line No.");
                        // TemporalRec."Cantidad Reserva" :=
                        // CalculoReserva2(LinPedido."No.", LinPedido."PfsVertical Component",
                        // LinPedido."PfsHorizontal Component", LinPedido."PfsPrepack Code");
                        TemporalRec."Cant. envios lanzados" := LinPedido."Cant. en envios almacen"; //EX-SGG-WMS 180919
                        TemporalRec."Cant. envios lanzados pedido" := LinPedido."Cant. envios lanzados"; //EX-SGG-WMS 100919

                        IF LinPedido."Cantidad Anulada" = 0 THEN
                            TemporalRec."Importe Pte No anul" := LinPedido."Outstanding Amount"
                        ELSE BEGIN
                            IF LinPedido."Cantidad Anulada" <> LinPedido."PfsOrder Quantity" THEN
                                TemporalRec."Importe Pte No anul" :=
                                ((LinPedido."PfsOrder Quantity" - LinPedido."Cantidad Anulada") / LinPedido."PfsOrder Quantity") *
                                    LinPedido."Outstanding Amount";
                        END;

                        TemporalRec.MODIFY;
                    END;
                END;
            //END;
            UNTIL ((LinPedido.NEXT = 0) OR (Salir));
        //V.CLOSE;

        //+EX-SGG 231122 COMENTO INNECESARIO
        //   {
        //   IF Rec."Servicio Pedido" = Rec."Servicio Pedido"::Resto THEN BEGIN
        //     TempAgrup.RESET;
        //     TempAgrup.SETCURRENTKEY(Proceso,usuario,Insertado);
        //     TempAgrup.SETRANGE(Proceso,'WMSLIN');
        //     TempAgrup.SETRANGE(usuario,USERID);
        //     TempAgrup.SETRANGE(Insertado,FALSE);
        //     IF TempAgrup.FINDFIRST THEN
        //       REPEAT
        //         TempAgrup2.RESET;
        //         TempAgrup2.SETCURRENTKEY("Clave 1","Clave 3",Proceso,usuario,Insertado);
        //         TempAgrup2.SETRANGE("Clave 1",TempAgrup."Clave 1");
        //         TempAgrup2.SETRANGE("Clave 3",TempAgrup."Clave 3");
        //         TempAgrup2.SETRANGE(Proceso,'WMSLIN');
        //         TempAgrup2.SETRANGE(usuario,USERID);
        //         TempAgrup2.SETRANGE(Insertado,FALSE);
        //         IF TempAgrup2.FINDFIRST THEN
        //           REPEAT
        //             IF TempAgrup2.Cantidad = TempAgrup2."Cantidad Pendiente" THEN BEGIN
        //               TempAgrup2.Anular := TRUE;
        //               TempAgrup2.MODIFY;
        //               TempAgrup.Anular := TRUE;
        //               TempAgrup.MODIFY;
        //             END;
        //           UNTIL TempAgrup2.NEXT = 0;
        //       UNTIL TempAgrup.NEXT = 0;
        //   END;
        //   }
        //-EX-SGG 231122

        IF Rec."Servicio Pedido" = Rec."Servicio Pedido"::Nuevo THEN BEGIN
            TempAgrup.RESET;
            TempAgrup.SETCURRENTKEY(Proceso, usuario, Insertado);
            TempAgrup.SETRANGE(Proceso, 'WMSLIN');
            TempAgrup.SETRANGE(usuario, USERID);
            TempAgrup.SETRANGE(Insertado, FALSE);
            IF TempAgrup.FINDFIRST THEN
                REPEAT
                    TempAgrup2.RESET;
                    TempAgrup2.SETCURRENTKEY("Clave 1", "Clave 3", Proceso, usuario, Insertado);
                    TempAgrup2.SETRANGE("Clave 1", TempAgrup."Clave 1");
                    TempAgrup2.SETRANGE("Clave 3", TempAgrup."Clave 3");
                    TempAgrup2.SETRANGE(Proceso, 'WMSLIN');
                    TempAgrup2.SETRANGE(usuario, USERID);
                    TempAgrup2.SETRANGE(Insertado, FALSE);
                    IF TempAgrup2.FINDFIRST THEN
                        REPEAT
                            IF TempAgrup2.Cantidad <> TempAgrup2."Cantidad Pendiente" THEN BEGIN

                                TempAgrup2.Anular := TRUE;
                                TempAgrup2.MODIFY;
                                TempAgrup.Anular := TRUE;
                                TempAgrup.MODIFY;
                            END;
                        UNTIL TempAgrup2.NEXT = 0;
                UNTIL TempAgrup.NEXT = 0;
        END;

        //V.OPEN('Borrar Cantidades pendientes');
        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario, "Cantidad Pendiente", Insertado);
        TemporalRec.SETRANGE(Proceso, 'WMSLIN');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.SETRANGE("Cantidad Pendiente", 0);
        TemporalRec.SETRANGE(Insertado, FALSE);
        TemporalRec.DELETEALL;
        //V.CLOSE;

        //V.OPEN('Borrar Cantidades Anuladas');
        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario, Anular, Insertado);
        TemporalRec.SETRANGE(Proceso, 'WMSLIN');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.SETRANGE(Anular, TRUE);
        TemporalRec.SETRANGE(Insertado, FALSE);
        TemporalRec.DELETEALL;
        //V.CLOSE;

        Solicitado := 0;
        //V.OPEN('Tallas Parciales');

        IF Rec."Admite Tallas Parciales" THEN BEGIN
            TempAgrup.RESET;
            TempAgrup.SETCURRENTKEY(Proceso, usuario, Insertado);
            TempAgrup.SETRANGE(Proceso, 'WMSLIN');
            TempAgrup.SETRANGE(usuario, USERID);
            TempAgrup.SETRANGE(Insertado, FALSE);
            IF TempAgrup.FINDFIRST THEN
                REPEAT
                    StockCalc := CalculoStock(TempAgrup."Clave 4", TempAgrup.Color, TempAgrup.Talla, TempAgrup.CodPreemb) -
                                    TempAgrup."Cantidad Reserva" - TempAgrup."Cantidad Picking"//;  //xxxx
                                    - TempAgrup."Cant. envios lanzados"; //EX-SGG-WMS 100919
                    Solicitado := (TempAgrup."Cantidad Pendiente" - TempAgrup."Cantidad Anulada"
                                                                    - TempAgrup."Reserva Pedido"
                                                                    - TempAgrup."Picking Pedido"//)
                                                                    - TempAgrup."Cant. envios lanzados pedido") //EX-SGG-WMS 100919
                                                                    * Rec."% Talla" / 100;

                    IF ((Solicitado > StockCalc) OR (StockCalc <= 0)) THEN BEGIN
                        TempAgrup."Cantidad Agrupacion" := TempAgrup."Cantidad Pendiente" - TempAgrup."Cantidad Anulada"
                                                                                        - TempAgrup."Reserva Pedido"
                                                                                        - TempAgrup."Picking Pedido"//;
                                                                                    - TempAgrup."Cant. envios lanzados pedido"; //EX-SGG-WMS 100919
                        TempAgrup.Anular := TRUE;

                        TempAgrup.MODIFY;
                    END ELSE BEGIN
                        IF ((TempAgrup."Cantidad Pendiente" - TempAgrup."Cantidad Anulada" -
                            TempAgrup."Cant. envios lanzados pedido" - //EX-SGG-WMS 100919
                            TempAgrup."Reserva Pedido" - TempAgrup."Picking Pedido") > StockCalc) THEN BEGIN

                            TempAgrup."Cantidad Asignada" := StockCalc;
                            TempAgrup."Cantidad Agrupacion" := TempAgrup."Cantidad Pendiente" - TempAgrup."Cantidad Anulada"
                                                                                            - TempAgrup."Reserva Pedido"
                                                                                            - TempAgrup."Picking Pedido"//;
                                                                                    - TempAgrup."Cant. envios lanzados pedido"; //EX-SGG-WMS 100919

                            IF TempAgrup."Cantidad Asignada" < 0 THEN
                                TempAgrup."Cantidad Asignada" := 0;

                            TempAgrup.MODIFY;
                        END ELSE BEGIN
                            TempAgrup."Cantidad Asignada" := TempAgrup."Cantidad Pendiente" - TempAgrup."Cantidad Anulada"
                                                                                            - TempAgrup."Reserva Pedido"
                                                                                            - TempAgrup."Picking Pedido"//;
                                                                                        - TempAgrup."Cant. envios lanzados pedido";
                            //EX-SGG-WMS 100919

                            IF TempAgrup."Cantidad Asignada" < 0 THEN
                                TempAgrup."Cantidad Asignada" := 0;

                            TempAgrup."Cantidad Agrupacion" := TempAgrup."Cantidad Pendiente" - TempAgrup."Cantidad Anulada"
                                                                                                - TempAgrup."Reserva Pedido"
                                                                                                - TempAgrup."Picking Pedido"//;
                                                                                    - TempAgrup."Cant. envios lanzados pedido";
                            //EX-SGG-WMS 100919

                            TempAgrup.MODIFY;
                        END;
                    END;
                UNTIL TempAgrup.NEXT = 0;
        END;
        //+EX-SGG 231122 COMENTO INNECESARIO
        //   {
        //   ELSE BEGIN
        //     TempAgrup.RESET;
        //     TempAgrup.SETCURRENTKEY(Proceso,usuario,Insertado);
        //     TempAgrup.SETRANGE(Proceso,'WMSLIN');
        //     TempAgrup.SETRANGE(usuario,USERID);
        //     TempAgrup.SETRANGE(Insertado,FALSE);
        //     IF TempAgrup.FINDFIRST THEN
        //       REPEAT
        //         StockCalc := CalculoStock(TempAgrup."Clave 4",TempAgrup.Color,TempAgrup.Talla,TempAgrup.CodPreemb) -
        //                      TempAgrup."Cantidad Reserva" - TempAgrup."Cantidad Picking"//;
        //                      -TempAgrup."Cant. envios lanzados"; //EX-SGG-WMS 100919
        //         Solicitado := TempAgrup."Cantidad Pendiente"-TempAgrup."Cantidad Anulada" -
        //                       TempAgrup."Reserva Pedido" - TempAgrup."Picking Pedido"//;
        //                       -TempAgrup."Cant. envios lanzados pedido"; //EX-SGG-WMS 100919

        //         IF ((Solicitado > StockCalc) OR (StockCalc <= 0)) THEN BEGIN
        //           TempAgrup."Cantidad Agrupacion" := TempAgrup."Cantidad Pendiente" -TempAgrup."Cantidad Anulada" -
        //                                             TempAgrup."Reserva Pedido" - TempAgrup."Picking Pedido"//;
        //                                             -TempAgrup."Cant. envios lanzados pedido"; //EX-SGG-WMS 100919

        //           TempAgrup.Anular := TRUE;

        //           TempAgrup.MODIFY;
        //         END ELSE BEGIN
        //           IF ((TempAgrup."Cantidad Pendiente"-TempAgrup."Cantidad Anulada" -
        //               TempAgrup."Cant. envios lanzados pedido" - //EX-SGG-WMS 100919
        //               TempAgrup."Reserva Pedido" - TempAgrup."Picking Pedido") > StockCalc) THEN BEGIN
        //                 TempAgrup."Cantidad Asignada" := StockCalc;
        //                 IF TempAgrup."Cantidad Asignada" < 0 THEN
        //                   TempAgrup."Cantidad Asignada" := 0;

        //                 TempAgrup."Cantidad Agrupacion" := TempAgrup."Cantidad Pendiente"-TempAgrup."Cantidad Anulada"
        //                                                    - TempAgrup."Reserva Pedido" - TempAgrup."Picking Pedido"//;
        //                                                    - TempAgrup."Cant. envios lanzados pedido"; //EX-SGG-WMS 100919
        //                 TempAgrup.MODIFY;
        //           END ELSE BEGIN
        //             TempAgrup."Cantidad Asignada" := TempAgrup."Cantidad Pendiente"-TempAgrup."Cantidad Anulada"
        //                                                 - TempAgrup."Reserva Pedido" - TempAgrup."Picking Pedido"//;
        //                                                 - TempAgrup."Cant. envios lanzados pedido"; //EX-SGG-WMS 100919

        //             IF TempAgrup."Cantidad Asignada" < 0 THEN
        //               TempAgrup."Cantidad Asignada" := 0;
        //             TempAgrup."Cantidad Agrupacion" := TempAgrup."Cantidad Pendiente"-TempAgrup."Cantidad Anulada"
        //                                                - TempAgrup."Reserva Pedido" - TempAgrup."Picking Pedido"//;
        //                                                - TempAgrup."Cant. envios lanzados pedido"; //EX-SGG-WMS 100919
        //             IF TempAgrup."Cantidad Agrupacion" < 0 THEN
        //               TempAgrup."Cantidad Agrupacion" := 0;
        //             TempAgrup.MODIFY;
        //           END;
        //         END;
        //       UNTIL TempAgrup.NEXT = 0;
        //   END;
        //   }
        //-EX-SGG 231122
        //V.CLOSE;

        //+EX-SGG 231122 COMENTO INNECESARIO
        //   {
        //   //V.OPEN('Control agrupacion');
        //   Solicitado := 0;
        //   IF ControlAgrup THEN BEGIN
        //     TempAgrup.RESET;
        //     TempAgrup.SETCURRENTKEY(Proceso,usuario,Insertado);
        //     TempAgrup.SETRANGE(Proceso,'WMSLIN');
        //     TempAgrup.SETRANGE(usuario,USERID);
        //     TempAgrup.SETRANGE(Insertado,FALSE);
        //     IF TempAgrup.FINDFIRST THEN
        //       REPEAT
        //         TallasRec.RESET;
        //         TallasRec.SETCURRENTKEY("Item No.","Series Precios");
        //         TallasRec.SETRANGE("Item No.",TempAgrup."Clave 4");
        //         TallasRec.SETRANGE("Series Precios",TempAgrup."Serie Precio");
        //         IF TallasRec.FINDFIRST THEN
        //           REPEAT
        //             TempAgrup2.RESET;
        //             TempAgrup2.SETRANGE("Clave 1",TempAgrup."Clave 1");
        //             TempAgrup2.SETRANGE("Clave 3",TempAgrup."Clave 3");
        //             TempAgrup2.SETRANGE("Clave 4",TempAgrup."Clave 4");
        //             TempAgrup2.SETRANGE(Proceso,'WMSLIN');
        //             TempAgrup2.SETRANGE(usuario,USERID);
        //             TempAgrup2.SETRANGE(Color,TempAgrup.Color);
        //             TempAgrup2.SETRANGE(Talla,TallasRec.Code);
        //             TempAgrup2.SETRANGE(Insertado,FALSE);
        //             IF TempAgrup2.FINDFIRST THEN BEGIN

        //               StockCalc := CalculoStock(TempAgrup2."Clave 4",
        //                                   TempAgrup2.Color,TempAgrup2.Talla,TempAgrup.CodPreemb) -
        //                                   TempAgrup2."Cantidad Reserva" - TempAgrup2."Cantidad Picking"//;
        //                                   - TempAgrup2."Cant. envios lanzados"; //EX-SGG-WMS 100919

        //               //Solicitado := TempAgrup2."Cantidad Agrupacion";
        //               //a cantidad agrupacion se le aplica % talla?
        //               Solicitado := TempAgrup2."Cantidad Agrupacion" * Rec."% Talla"/100;
        //               IF ((Solicitado > StockCalc) OR (StockCalc <= 0)) THEN BEGIN
        //                  TempAgrup.Anular := TRUE;

        //                  TempAgrup.MODIFY;
        //               END;

        //             END;
        //           UNTIL TallasRec.NEXT = 0;
        //       UNTIL TempAgrup.NEXT = 0;
        //   END;
        //   //V.CLOSE;
        //   }
        //-EX-SGG 231122
        //V.OPEN('Preembalados 1:#1######  #2#######');

        TempAgrup.RESET;
        TempAgrup.SETCURRENTKEY(Proceso, usuario, Insertado, "Clave 6");
        TempAgrup.SETRANGE(Proceso, 'WMSLIN');
        TempAgrup.SETRANGE(usuario, USERID);
        TempAgrup.SETRANGE(Insertado, FALSE);
        TempAgrup.SETFILTER("Clave 6", '<>%1', '');
        NumPreemb2 := TempAgrup.COUNT;

        TempAgrup.RESET;
        TempAgrup.SETCURRENTKEY(Proceso, usuario, Insertado, "Clave 6");
        TempAgrup.SETRANGE(Proceso, 'WMSLIN');
        TempAgrup.SETRANGE(usuario, USERID);
        TempAgrup.SETRANGE(Insertado, FALSE);
        TempAgrup.SETFILTER("Clave 6", '<>%1', '');
        IF TempAgrup.FINDFIRST THEN
            REPEAT

                NumPreemb3 += 1;
                //V.UPDATE(1, NumPreemb3);
                //V.UPDATE(2, NumPreemb2);

                CantPreemb := 0;
                NumPreemb := 0;
                TempAgrup2.RESET;
                TempAgrup2.SETCURRENTKEY("Clave 1", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario); //xxxxxxxxxxxx
                TempAgrup2.SETRANGE("Clave 1", TempAgrup."Clave 1");
                TempAgrup2.SETRANGE("Clave 4", TempAgrup."Clave 4");
                TempAgrup2.SETRANGE("Clave 5", TempAgrup."Clave 5");
                TempAgrup2.SETRANGE("Clave 6", TempAgrup."Clave 6");
                TempAgrup2.SETRANGE(Proceso, 'WMSLIN');
                TempAgrup2.SETRANGE(usuario, USERID);
                IF TempAgrup2.FINDFIRST THEN
                    REPEAT
                        CantPreemb += TempAgrup2."Cantidad Asignada";
                        NumPreemb += 1;
                    UNTIL TempAgrup2.NEXT = 0;

                //IF CantPreemb MOD 12 <> 0 THEN BEGIN
                IF ((CantPreemb MOD 12 <> 0) OR (NumPreemb <> 6)) THEN BEGIN
                    TempAgrup2.RESET;
                    TempAgrup2.SETCURRENTKEY("Clave 1", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario); //xxxxxxxxxxxx
                    TempAgrup2.SETRANGE("Clave 1", TempAgrup."Clave 1");
                    TempAgrup2.SETRANGE("Clave 4", TempAgrup."Clave 4");
                    TempAgrup2.SETRANGE("Clave 5", TempAgrup."Clave 5");
                    TempAgrup2.SETRANGE("Clave 6", TempAgrup."Clave 6");
                    TempAgrup2.SETRANGE(Proceso, 'WMSLIN');
                    TempAgrup2.SETRANGE(usuario, USERID);
                    IF TempAgrup2.FINDFIRST THEN
                        REPEAT
                            TempAgrup2."Cantidad Asignada" := 0;
                            TempAgrup2.Anular := TRUE;
                            TempAgrup2.MODIFY;
                        UNTIL TempAgrup2.NEXT = 0;

                END;
            UNTIL TempAgrup.NEXT = 0;

        //V.CLOSE;

        NumPreemb3 := 0;
        TempAgrup.RESET;
        TempAgrup.SETCURRENTKEY(Proceso, usuario, Insertado, "Clave 6");
        TempAgrup.SETRANGE(Proceso, 'WMSLIN');
        TempAgrup.SETRANGE(usuario, USERID);
        TempAgrup.SETRANGE(Insertado, FALSE);
        TempAgrup.SETFILTER("Clave 6", '<>%1', '');
        NumPreemb2 := TempAgrup.COUNT;

        //V.OPEN('Preembalados 2:#1######  #2#######');

        TempAgrup.RESET;
        TempAgrup.SETCURRENTKEY(Proceso, usuario, Insertado, "Clave 6");
        TempAgrup.SETRANGE(Proceso, 'WMSLIN');
        TempAgrup.SETRANGE(usuario, USERID);
        TempAgrup.SETRANGE(Insertado, FALSE);
        TempAgrup.SETFILTER("Clave 6", '<>%1', '');
        IF TempAgrup.FINDFIRST THEN
            REPEAT

                NumPreemb3 += 1;
                //V.UPDATE(1, NumPreemb3);
                //V.UPDATE(2, NumPreemb2);

                AsignPreemb := FALSE;
                TempAgrup2.RESET;
                TempAgrup2.SETCURRENTKEY("Clave 1", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario);
                TempAgrup2.SETRANGE("Clave 1", TempAgrup."Clave 1");
                TempAgrup2.SETRANGE("Clave 4", TempAgrup."Clave 4");
                TempAgrup2.SETRANGE("Clave 5", TempAgrup."Clave 5");
                TempAgrup2.SETRANGE("Clave 6", TempAgrup."Clave 6");
                TempAgrup2.SETRANGE(Proceso, 'WMSLIN');
                TempAgrup2.SETRANGE(usuario, USERID);
                IF TempAgrup2.FINDFIRST THEN
                    REPEAT
                        IF ((TempAgrup2."Cantidad Asignada" <= 0) AND (TempAgrup2."Clave 6" <> '')) THEN BEGIN
                            AsignPreemb := TRUE;

                            TempAgrup3.RESET;
                            TempAgrup3.SETCURRENTKEY("Clave 1", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario); //xxxxxxxxx
                            TempAgrup3.SETRANGE("Clave 1", TempAgrup2."Clave 1");
                            TempAgrup3.SETRANGE("Clave 4", TempAgrup2."Clave 4");
                            TempAgrup3.SETRANGE("Clave 5", TempAgrup2."Clave 5");
                            TempAgrup3.SETRANGE("Clave 6", TempAgrup2."Clave 6");
                            TempAgrup3.SETRANGE(Proceso, 'WMSLIN');
                            TempAgrup3.SETRANGE(usuario, USERID);
                            IF TempAgrup3.FINDFIRST THEN
                                REPEAT
                                    TempAgrup3."Cantidad Asignada" := 0;
                                    TempAgrup3.MODIFY;
                                UNTIL TempAgrup3.NEXT = 0;
                        END;
                    UNTIL ((TempAgrup2.NEXT = 0) OR (AsignPreemb));
            UNTIL TempAgrup.NEXT = 0;
        //V.CLOSE;


        //V.OPEN('Creacion cabeceras:#1######  #2#######');
        CodPedido := '';
        ContadorLin := 0;
        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY("Clave 1", Proceso, usuario, Insertado);
        TemporalRec.SETRANGE(Proceso, 'WMSLIN');
        TemporalRec.SETRANGE(usuario, USERID);

        TemporalRec.SETRANGE(Insertado, FALSE);
        IF TemporalRec.FINDFIRST THEN BEGIN
            REPEAT
                IF CodPedido <> TemporalRec."Clave 1" THEN BEGIN
                    TemporalCab.INIT;
                    IF CabPedido.GET(CabPedido."Document Type"::Order, TemporalRec."Clave 1") THEN;
                    //CabPedido.CALCFIELDS(Comment);
                    CabPedido.CALCFIELDS(Comment, "Envios lanzados"); //EX-SGG-WMS 100919
                    ContadorLin += 1;
                    //V.UPDATE(1, TemporalRec."Clave 1");
                    //V.UPDATE(2, ContadorLin);
                    TemporalCab."Clave 1" := TemporalRec."Clave 1";
                    TemporalCab."Clave 3" := TemporalRec."Clave 3";
                    TemporalCab.Proceso := 'WMSCAB';
                    TemporalCab.usuario := USERID;
                    TemporalCab.Cantidad := TemporalRec.Cantidad;

                    TemporalCab."Cantidad Pendiente" := TemporalRec."Cantidad Pendiente";
                    TemporalCab."Nombre Cliente" := CabPedido."Sell-to Customer Name";
                    TemporalCab."Cantidad Anulada" := TemporalRec."Cantidad Anulada";
                    TemporalCab."Cantidad Servida" := TemporalRec."Cantidad Servida";
                    TemporalCab."Cantidad Asignada" := TemporalRec."Cantidad Asignada";
                    TemporalCab."Cantidad Picking" := Cantidad_En_PickingPed(CabPedido."No.");
                    TemporalCab."Cant. envios lanzados" := CabPedido."Envios lanzados"; //EX-SGG-WMS 100919
                                                                                        //TemporalCab."Cantidad Reserva" := TemporalRec."Cantidad Reserva";
                    TemporalCab."Cantidad Reserva" := CalculoReserva3(CabPedido."No.", Rec);
                    TemporalCab."Importe Pte No anul" := TemporalRec."Importe Pte No anul";
                    TemporalCab.Stock := TemporalRec.Stock;
                    TemporalCab.Temporada := TemporalRec.Temporada;
                    TemporalCab.Retenido := CabPedido."Pedido Retenido";
                    TemporalCab.Sucursal := Sucursal;
                    TemporalCab.Prioridad := Prioridad;
                    TemporalCab.Origen := CabPedido."Sell-to County";
                    TemporalCab."Fecha Servicio" := CabPedido."Fecha servicio solicitada";
                    TemporalCab.ComentarioPed := CabPedido.Comment;
                    TemporalCab."Cod Representante" := CabPedido."Salesperson Code";
                    ConfAlm.GET;

                    //WMS EX-JFC 09/09/2019 Validar el almacen predeterminado SEGA
                    //TemporalCab.Almacen := ConfAlm."Almacen Envio Generico";
                    TemporalCab.Almacen := ConfAlm."Almacen predet. SEGA";
                    //WMS FIN EX-JFC 09/09/2019 Validar el almacen predeterminado SEGA

                    //EX.CGR.140920
                    //IF Rec."Tipo Pedido"=Rec."Tipo Pedido"::"Pedidos consignacion" THEN
                    IF CabPedido."Ventas en consignacion" = TRUE THEN
                        TemporalCab."Consignacion venta" := TRUE;


                    RecCli.GET(CabPedido."Sell-to Customer No.");
                    TemporalCab.Descripcion := RecCli.CustomerStatus;

                    LinPedImporte.RESET;
                    LinPedImporte.SETCURRENTKEY("Document Type", "Document No.", "Line No.");
                    LinPedImporte.SETRANGE("Document Type", LinPedImporte."Document Type"::Order);
                    LinPedImporte.SETRANGE("Document No.", CabPedido."No.");
                    IF LinPedImporte.FINDFIRST THEN BEGIN
                        LinPedImporte.CALCSUMS("Outstanding Amount");
                        //TemporalCab."Importe Pedido" += LinPedImporte."Outstanding Amount";
                        //SF-POF
                        IF LinPedImporte."VAT Calculation Type" <> LinPedImporte."VAT Calculation Type"::"Reverse Charge VAT" THEN
                            TemporalCab."Importe Pedido" += LinPedImporte."Outstanding Amount"
                        ELSE
                            TemporalCab."Importe Pedido" += LinPedImporte.Amount;
                        //SF-POF:FIN

                        //REPEAT
                        //TemporalCab."Importe Pedido" += LinPedImporte."Outstanding Amount";
                        //UNTIL LinPedImporte.NEXT = 0;
                    END;

                    RecCli.GET(TemporalCab."Clave 3");
                    //IF CUFunc.RiesgoCliente(CabPedido."Sell-to Customer No.") <= 0 THEN
                    //EX-JFC 071221 Control de Riesgo o Aval segun el tipo de pedido en firme o consignacion
                    IF TemporalCab."Consignacion venta" = FALSE THEN BEGIN
                        // TemporalCab."Riesgo NMilenio" := RecCli."Riesgo Concedido";
                        // TODO RIESGO
                        TemporalCab."Riesgo NMilenio" := RecCli."Riesgo Concedido Consignacion";
                        ;// RecCli."Riesgo NUEVO MILENIO";
                         //IF RecCli."Riesgo NUEVO MILENIO" <= 0 THEN
                         // If RecCli."Riesgo Concedido" <= 0 Then
                        if RecCli."Riesgo Concedido Consignacion" <= 0 then
                            TemporalCab."Supera Riesgo" := TRUE;
                    END;

                    IF TemporalCab."Consignacion venta" = TRUE THEN BEGIN
                        lRecConsignmentCondition.RESET;
                        lRecConsignmentCondition.SETRANGE("Customer No.", RecCli."No.");
                        lRecConsignmentCondition.SETRANGE("Register Type", lRecConsignmentCondition."Register Type"::Consignment);
                        lRecConsignmentCondition.SETRANGE("Value Type", lRecConsignmentCondition."Value Type"::Aval);
                        IF lRecConsignmentCondition.FINDFIRST THEN;
                        TemporalCab."Riesgo NMilenio" := lRecConsignmentCondition.Value;
                        //TemporalCab."Riesgo NMilenio" := RecCli."Riesgo NUEVO MILENIO";
                        IF lRecConsignmentCondition.Value <= 0 THEN
                            TemporalCab."Supera Riesgo" := TRUE;
                    END;
                    //EX-JFC FIN 071221 Control de Riesgo o Aval segun el tipo de pedido en firme o consignacion

                    IF NOT TemporalCab."Supera Riesgo" THEN;
                    //        TemporalCab.Clasificadora := TRUE;  //EX-SGG-WMS 200619 COMENTO

                    IF TemporalCab.Retenido THEN
                        TemporalCab.Clasificadora := FALSE;
                    //EX-OMI-WMS 270519
                    //TemporalCab."Impago Cliente" := RecCli.Vencimiento15(TemporalCab."Clave 3");
                    TemporalCab."Impago Cliente" := CUFunciones.Vencimiento15(TemporalCab."Clave 3");
                    //EX-OMI-WMS fin

                    //EX-SGG-WMS 200619 COMENTO
                    //   {
                    //         IF TemporalCab."Impago Cliente" THEN BEGIN
                    //           TemporalCab.Clasificadora := FALSE;
                    //           TemporalCab.PDA := FALSE;
                    //         END;
                    //   }

                    TemporalCab.INSERT;
                END ELSE BEGIN

                    TemporalCabMod.RESET;
                    TemporalCabMod.SETCURRENTKEY("Clave 1", "Clave 3", Proceso, usuario, Insertado);
                    TemporalCabMod.SETRANGE("Clave 1", TemporalRec."Clave 1");
                    TemporalCabMod.SETRANGE("Clave 3", TemporalRec."Clave 3");
                    TemporalCabMod.SETRANGE(Proceso, 'WMSCAB');
                    TemporalCabMod.SETRANGE(usuario, USERID);
                    TemporalCabMod.SETRANGE(Insertado, FALSE);
                    IF TemporalCabMod.FINDFIRST THEN BEGIN

                        TemporalCabMod.Cantidad += TemporalRec.Cantidad;
                        TemporalCabMod."Cantidad Pendiente" += TemporalRec."Cantidad Pendiente";
                        TemporalCabMod."Cantidad Anulada" += TemporalRec."Cantidad Anulada";
                        TemporalCabMod."Cantidad Servida" += TemporalRec."Cantidad Servida";
                        TemporalCabMod."Cantidad Asignada" += TemporalRec."Cantidad Asignada";
                        TemporalCabMod.Stock += TemporalRec.Stock;
                        TemporalCabMod."Importe Pte No anul" += TemporalRec."Importe Pte No anul";
                        TemporalCabMod.MODIFY;
                    END;
                END;
                CodPedido := TemporalRec."Clave 1";
            UNTIL TemporalRec.NEXT = 0;
            //V.CLOSE;
        END;
        ContadorLin2 := ContadorLin;

        //V.OPEN('Asignacion Cantidades:#1###### #2####### #3######');
        ContadorLin := 0;
        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario, Insertado);
        TemporalRec.SETRANGE(Proceso, 'WMSCAB');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.SETRANGE(Insertado, FALSE);
        IF TemporalRec.FINDFIRST THEN
            REPEAT
                ContadorLin += 1;
                //V.UPDATE(1, TemporalRec."Clave 1");
                //V.UPDATE(2, ContadorLin);
                //V.UPDATE(3, ContadorLin2);
                TemporalRec.Cantidad := 0;
                TemporalRec."Cantidad Pendiente" := 0;

                TemporalRec."Importe Pte No anul" := TemporalRec."Importe Pte No anul" - CalcResImp(TemporalRec."Clave 1") -
                CalcImpPicking(TemporalRec."Clave 1");

                TemporalRec.MODIFY;

                TempAgrup.RESET;
                TempAgrup.SETCURRENTKEY("Clave 1", Proceso, usuario, Insertado);
                //TempAgrup.SETCURRENTKEY("Clave 1","Clave 4","Clave 5","Clave 6",Proceso,usuario);
                TempAgrup.SETRANGE("Clave 1", TemporalRec."Clave 1");
                TempAgrup.SETRANGE(Proceso, 'WMSLIN');
                TempAgrup.SETRANGE(usuario, USERID);
                TempAgrup.SETRANGE(Insertado, FALSE);
                IF TempAgrup.FINDFIRST THEN
                    REPEAT
                        TemporalRec.Cantidad += TempAgrup.Cantidad;
                        TemporalRec."Cantidad Pendiente" += TempAgrup."Cantidad Pendiente";
                        TemporalRec.MODIFY;
                    UNTIL TempAgrup.NEXT = 0;
            UNTIL TemporalRec.NEXT = 0;
        //V.CLOSE;

        //V.OPEN('Calculo2');

        //+EX-SGG 231122 COMENTO INNECESARIO
        //   {
        //   Solicitado := 0;
        //   IF Porcentaje <> 0 THEN BEGIN
        //     TemporalRec.RESET;
        //     TemporalRec.SETCURRENTKEY(Proceso,usuario,Insertado);
        //     TemporalRec.SETRANGE(Proceso,'WMSCAB');
        //     TemporalRec.SETRANGE(usuario,USERID);
        //     TemporalRec.SETRANGE(Insertado,FALSE);
        //     IF TemporalRec.FINDFIRST THEN
        //       REPEAT
        //         Solicitado := (TemporalRec."Cantidad Pendiente"-TemporalRec."Cantidad Anulada"
        //                                                        -TemporalRec."Cantidad Picking"
        //                                                        -TemporalRec."Cant. envios lanzados" //EX-SGG-WMS 100919
        //                                                        -TemporalRec."Cantidad Reserva") * Porcentaje/100;
        //         IF ((Solicitado > TemporalRec."Cantidad Asignada") OR (TemporalRec.Stock -TemporalRec."Cantidad Picking"-
        //             TemporalRec."Cant. envios lanzados" - //EX-SGG-WMS 100919
        //             TemporalRec."Cantidad Reserva" <= 0)) THEN BEGIN
        //           TemporalRec.Anular := TRUE;
        //           TemporalRec.MODIFY;
        //           TempAgrup.RESET;
        //           TempAgrup.SETCURRENTKEY("Clave 1",Proceso,usuario,Insertado);
        //           TempAgrup.SETRANGE("Clave 1",TemporalRec."Clave 1");
        //           TempAgrup.SETRANGE(Proceso,'WMSLIN');
        //           TempAgrup.SETRANGE(usuario,USERID);
        //           TempAgrup.SETRANGE(Insertado,FALSE);
        //           IF TempAgrup.FINDFIRST THEN
        //             REPEAT
        //               TempAgrup.Anular := TRUE;
        //               TempAgrup.MODIFY;
        //             UNTIL TempAgrup.NEXT = 0;
        //         END;
        //       UNTIL TemporalRec.NEXT = 0;
        //   END;
        //   }
        //-EX-SGG 231122

        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario, Insertado);
        TemporalRec.SETRANGE(Proceso, 'WMSCAB');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.SETRANGE(Insertado, FALSE);
        IF TemporalRec.FINDFIRST THEN
            REPEAT
                IF ((TemporalRec.Cantidad = TemporalRec."Cantidad Anulada")
                    AND (TemporalRec."Cantidad Asignada" = 0)) THEN BEGIN
                    TemporalRec.Anular := TRUE;
                    TemporalRec.MODIFY;
                END;
            UNTIL TemporalRec.NEXT = 0;

        //+EX-SGG 231122 COMENTO INNECESARIO
        //   {
        //   IF CantMin <> 0 THEN BEGIN
        //     TemporalRec.RESET;
        //     TemporalRec.SETCURRENTKEY(Proceso,usuario,Anular,Insertado);
        //     TemporalRec.SETRANGE(Proceso,'WMSCAB');
        //     TemporalRec.SETRANGE(usuario,USERID);
        //     TemporalRec.SETRANGE(Anular,FALSE);
        //     TemporalRec.SETRANGE(Insertado,FALSE);
        //     IF TemporalRec.FINDFIRST THEN
        //       REPEAT

        //         IF ((TemporalRec."Cantidad Asignada" < CantMin)) THEN BEGIN
        //           TemporalRec.Anular := TRUE;
        //           TemporalRec.MODIFY;
        //           TempAgrup.RESET;
        //           TempAgrup.SETCURRENTKEY("Clave 1",Proceso,usuario,Insertado);
        //           TempAgrup.SETRANGE("Clave 1",TemporalRec."Clave 1");
        //           TempAgrup.SETRANGE(Proceso,'WMSLIN');
        //           TempAgrup.SETRANGE(usuario,USERID);
        //           TempAgrup.SETRANGE(Insertado,FALSE);
        //           IF TempAgrup.FINDFIRST THEN
        //             REPEAT
        //               TempAgrup.Anular := TRUE;
        //               TempAgrup.MODIFY;
        //             UNTIL TempAgrup.NEXT = 0;
        //         END;
        //       UNTIL TemporalRec.NEXT = 0;
        //   END;
        //   }Salir
        //-EX-SGG 231122

        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario, Anular, Insertado);
        TemporalRec.SETRANGE(Proceso, 'WMSCAB');
        TemporalRec.SETRANGE(usuario, USERID);
        TemporalRec.SETRANGE(Anular, TRUE);
        TemporalRec.SETRANGE(Insertado, FALSE);
        IF TemporalRec.FINDFIRST THEN
            TemporalRec.DELETEALL(TRUE);
        //REPEAT
        //TemporalRec.DELETE(TRUE);
        //UNTIL TemporalRec.NEXT = 0;


        //+EX-SGG 231122 COMENTO INNECESARIO
        //   {
        //   IF CantMax <> 0 THEN BEGIN
        //     CantTotal := 0;
        //     Salir := FALSE;
        //     TemporalRec.RESET;
        //     TemporalRec.SETCURRENTKEY(Proceso,usuario,Insertado);
        //     TemporalRec.SETRANGE(Proceso,'WMSCAB');
        //     TemporalRec.SETRANGE(usuario,USERID);
        //     TemporalRec.SETRANGE(Insertado,FALSE);
        //     IF TemporalRec.FINDFIRST THEN
        //       REPEAT
        //         CantTotal += TemporalRec."Cantidad Asignada";
        //         TemporalRec."No Anular" := TRUE;
        //         TemporalRec.MODIFY;
        //         TempAgrup.RESET;
        //         TempAgrup.SETCURRENTKEY("Clave 1",Proceso,usuario,Insertado);
        //         TempAgrup.SETRANGE("Clave 1",TemporalRec."Clave 1");
        //         TempAgrup.SETRANGE(Proceso,'WMSLIN');
        //         TempAgrup.SETRANGE(usuario,USERID);
        //         TempAgrup.SETRANGE(Insertado,FALSE);
        //         IF TempAgrup.FINDFIRST THEN
        //           REPEAT
        //             TempAgrup."No Anular" := TRUE;
        //             TempAgrup.MODIFY;
        //           UNTIL TempAgrup.NEXT = 0;

        //         IF CantTotal > CantMax THEN
        //           Salir := TRUE;
        //       UNTIL ((TemporalRec.NEXT = 0) OR (Salir));

        //     TemporalRec.RESET;
        //     TemporalRec.SETCURRENTKEY(Proceso,usuario,"No Anular",Insertado);
        //     TemporalRec.SETRANGE(Proceso,'WMSCAB');
        //     TemporalRec.SETRANGE(usuario,USERID);
        //     TemporalRec.SETRANGE("No Anular",FALSE);
        //     TemporalRec.SETRANGE(Insertado,FALSE);
        //     IF TemporalRec.FINDFIRST THEN
        //       REPEAT
        //         TempAgrup.RESET;
        //         TempAgrup.SETCURRENTKEY(Proceso,usuario,"Clave 1","No Anular",Insertado);
        //         TempAgrup.SETRANGE(Proceso,'WMSLIN');
        //         TempAgrup.SETRANGE(usuario,USERID);
        //         TempAgrup.SETRANGE("Clave 1",TemporalRec."Clave 1");
        //         TempAgrup.SETRANGE("No Anular",FALSE);
        //         TempAgrup.SETRANGE(Insertado,FALSE);
        //         IF TempAgrup.FINDFIRST THEN
        //           TempAgrup.DELETEALL;
        //           //REPEAT
        //             //TempAgrup.DELETE;
        //           //UNTIL TempAgrup.NEXT = 0;
        //         TemporalRec.DELETE;
        //       UNTIL TemporalRec.NEXT = 0;
        //   END;
        //   }
        //-EX-SGG 231122
        //V.CLOSE;

        //V.OPEN('Lineas no asignadas:#1########');
        TemporalRec.LOCKTABLE;
        TemporalRec.RESET;
        //TemporalRec.SETCURRENTKEY(Proceso,usuario);
        TemporalRec.SETRANGE(Proceso, 'WMSCAB');
        TemporalRec.SETRANGE(usuario, USERID);
        IF TemporalRec.FINDFIRST THEN
            REPEAT
                //V.UPDATE(1, TemporalRec."Clave 1");
                CantNuevaGl := 0;
                CantServGl := 0;
                Crearlineasnoasignadas(TemporalRec."Clave 1", CantNuevaGl, CantServGl);
                TemporalRec.Insertado := TRUE;
                TemporalRec.Cantidad := TemporalRec.Cantidad + CantNuevaGl;
                TemporalRec."Cantidad Servida" := TemporalRec."Cantidad Servida" + CantServGl;
                TemporalRec.MODIFY;
            UNTIL TemporalRec.NEXT = 0;

        //V.CLOSE;

        //V.OPEN('Actualizacion Final');
        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario);
        TemporalRec.SETRANGE(Proceso, 'WMSLIN');
        TemporalRec.SETRANGE(usuario, USERID);
        IF TemporalRec.FINDFIRST THEN
            TemporalRec.MODIFYALL(TemporalRec.Insertado, TRUE);
        //REPEAT
        //TemporalRec.Insertado := TRUE;
        //TemporalRec.MODIFY;
        //UNTIL TemporalRec.NEXT = 0;

        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario);
        TemporalRec.SETRANGE(Proceso, 'WMSTALLAS');
        TemporalRec.SETRANGE(usuario, USERID);
        IF TemporalRec.FINDFIRST THEN
            TemporalRec.MODIFYALL(TemporalRec.Insertado, TRUE);
        //REPEAT
        //TemporalRec.Insertado := TRUE;
        //TemporalRec.MODIFY;
        //UNTIL TemporalRec.NEXT = 0;

        TemporalRec.RESET;
        TemporalRec.SETCURRENTKEY(Proceso, usuario);
        TemporalRec.SETRANGE(Proceso, 'WMST2');
        TemporalRec.SETRANGE(usuario, USERID);
        IF TemporalRec.FINDFIRST THEN
            TemporalRec.MODIFYALL(TemporalRec.Insertado, TRUE);
        //REPEAT
        //TemporalRec.Insertado := TRUE;
        //TemporalRec.MODIFY;
        //UNTIL TemporalRec.NEXT = 0;
        //V.CLOSE;

        COMMIT;
        Page.RUNMODAL(Page::"Modificacion Prop Vta Cab WMS"); //EX-SGG-WMS 200619
    END;


    Procedure TipoServ(TP: Enum "Tipo servicio"; Rec: Record "Filtros Proposicion"): Boolean
    begin
        If Rec."Tipo Servicio" = Rec."Tipo Servicio"::Todos Then exit(true);
        If Rec."Tipo Servicio" = Rec."Tipo Servicio"::Nuevo Then exit(Tp = Tp::Nuevo);
        If Rec."Tipo Servicio" = Rec."Tipo Servicio"::"Reposición" Then exit(Tp = Tp::"Reposición");
    end;

    PROCEDURE CalculoReserva(DocRes: Code[20]; LineaRes: Integer): Integer;
    VAR
        MovReserva: Record 50012;
        CantRes: Decimal;
    BEGIN
        //Reserva pedido
        CantRes := 0;
        MovReserva.RESET;
        MovReserva.SETCURRENTKEY("Origen Documento No.", "Origen Documento Line No.", Referencia, Variante, "Documento No.", "PrePack Code");
        MovReserva.SETRANGE("Origen Documento No.", DocRes);
        MovReserva.SETRANGE("Origen Documento Line No.", LineaRes);
        //IF MovReserva.FINDFIRST THEN
        //REPEAT
        //CantRes += MovReserva."Cantidad Reservada";
        //UNTIL MovReserva.NEXT = 0;
        MovReserva.CALCSUMS("Cantidad Reservada");

        //EXIT(CantRes);
        EXIT(MovReserva."Cantidad Reservada");
    END;

    PROCEDURE CalcResImp(CodPed: Code[20]): Decimal;
    VAR
        ImpReserva: Decimal;
        RecPedido: Record 36;
        MovReserva: Record 50012;
        RecLinPedido: Record 37;
        FactorCant: Decimal;
    BEGIN
        ImpReserva := 0;
        RecPedido.RESET;
        RecPedido.SETRANGE("Document Type", RecPedido."Document Type"::Order);
        RecPedido.SETRANGE(RecPedido."No.", CodPed);
        IF RecPedido.FINDFIRST THEN
            REPEAT
                //RecPedido.CALCFIELDS("Reserva Picking");
                //IF RecPedido."Reserva Picking" <> 0 THEN BEGIN
                MovReserva.RESET;
                MovReserva.SETRANGE("Origen Documento No.", CodPed);
                IF MovReserva.FINDFIRST THEN
                    REPEAT
                        IF RecLinPedido.GET(RecLinPedido."Document Type"::Order,
                              MovReserva."Origen Documento No.", MovReserva."Origen Documento Line No.") THEN BEGIN
                            IF RecLinPedido."Outstanding Quantity" <> 0 THEN
                                FactorCant := MovReserva."Cantidad Reservada" / RecLinPedido."Outstanding Quantity";
                            ImpReserva += (RecLinPedido."Unit Price" * MovReserva."Cantidad Reservada" -
                              RecLinPedido."Inv. Discount Amount" * FactorCant -
                                RecLinPedido."Pmt. Discount Amount" * FactorCant) *
                                  (1 + RecLinPedido."VAT %" / 100)
                        END;
                    UNTIL MovReserva.NEXT = 0;
            //END;
            UNTIL RecPedido.NEXT = 0;
        EXIT(ImpReserva);
    END;

    PROCEDURE CalcImpPicking(CodPed: Code[20]): Decimal;
    VAR
        ImpPicking: Decimal;
        RecPedido: Record 36;
        RecLinPedido: Record 37;
        FactorCant: Decimal;
    // PickLinResumen: Record 50010;
    BEGIN
        // ImpPicking := 0;
        // FactorCant := 0;
        // PickLinResumen.RESET;
        // PickLinResumen.SETRANGE("Pedido No.", CodPed);
        // PickLinResumen.SETRANGE("Envio No.", '');
        // IF PickLinResumen.FINDFIRST THEN
        //     REPEAT
        //         IF RecLinPedido.GET(RecLinPedido."Document Type"::Order, PickLinResumen."Pedido No.", PickLinResumen."Pedido Linea No.") THEN BEGIN
        //             IF RecLinPedido."Outstanding Quantity" <> 0 THEN
        //                 FactorCant := PickLinResumen.Cantidad / RecLinPedido."Outstanding Quantity";
        //             ImpPicking += (RecLinPedido."Unit Price" * PickLinResumen.Cantidad -
        //               RecLinPedido."Inv. Discount Amount" * FactorCant -
        //                 RecLinPedido."Pmt. Disc. Given Amount" * FactorCant) *
        //                   (1 + RecLinPedido."VAT %" / 100)
        //         END;
        //     UNTIL PickLinResumen.NEXT = 0;
        // EXIT(ImpPicking);
    END;

    PROCEDURE CalculoReserva2(Modelo: Code[20]; Color: Code[20]; Talla: Code[20]; CodPreemb: Code[20]): Decimal;
    VAR
        PfsSetup: Record "SetupTallas";
        Code: Text;
        Res2: Integer;
    BEGIN

        ConfAlm.GET;
        Res2 := 0;
        RecProd.RESET;
        RecProd.SETRANGE("No.", Modelo);
        PfsSetup.Get();
        Code := Color + PfsSetup."Variant Separador" + Talla;
        RecProd.SETFILTER("Variant Filter", Code);
        //RecProd.SETRANGE("Filtro Preembalado", CodPreemb);

        IF RecProd.FINDFIRST THEN BEGIN
            // RecProd.CALCFIELDS("Cantidad Reserva Picking");
            // Res2 := RecProd."Cantidad Reserva Picking";
        END;
        EXIT(Res2);
    END;

    PROCEDURE CalculoReserva3(DocRes: Code[20]; Rec: Record "Filtros Proposicion"): Integer;
    VAR
        MovReserva: Record 50012;
        CantRes: Decimal;
    BEGIN
        CantRes := 0;
        MovReserva.RESET;
        MovReserva.SETCURRENTKEY("Origen Documento No.", "Fecha Servicio", Referencia);
        MovReserva.SETRANGE("Origen Documento No.", DocRes);
        MovReserva.SETFILTER("Fecha Servicio", Rec."F. Fecha Servicio Confirm.");
        MovReserva.SETFILTER(Referencia, Rec."Filtro Producto");

        IF MovReserva.FINDFIRST THEN
            MovReserva.CALCSUMS("Cantidad Reservada");
        //REPEAT
        //CantRes += MovReserva."Cantidad Reservada";
        //UNTIL MovReserva.NEXT = 0;


        //EXIT(CantRes);
        EXIT(MovReserva."Cantidad Reservada");
    END;

    PROCEDURE CantPicking(Modelo: Code[20]; Color: Code[20]; Talla: Code[20]; FPr: Code[20]): Integer;
    VAR
        CantidadPicking: Integer;
    // PickingResumen: Record 50010;
    BEGIN
        //picking de producto
        // ConfAlm.GET;
        // CantidadPicking := 0;
        // PickingResumen.RESET;
        // PickingResumen.SETCURRENTKEY("Pedido Item No.", Pendiente, Color, Talla, "Pedido Prepack Code", "Almac n Actual");
        // PickingResumen.SETFILTER("Pedido Item No.", Modelo);
        // PickingResumen.SETRANGE(Pendiente, TRUE);
        // PickingResumen.SETRANGE(Color, Color);
        // PickingResumen.SETRANGE(Talla, Talla);
        // PickingResumen.SETRANGE("Pedido Prepack Code", FPr);

        // IF FPr = '' THEN
        //     PickingResumen.SETRANGE("Almac n Actual", ConfAlm."Almacen Envio Generico")
        // ELSE
        //     PickingResumen.SETRANGE("Almac n Actual", ConfAlm."Almacen Preembalado");

        // IF PickingResumen.FINDFIRST THEN
        //     REPEAT
        //         CantidadPicking += PickingResumen.Cantidad - PickingResumen."Cantidad Enviada";
        //    UNTIL PickingResumen.NEXT = 0;
        EXIT(CantidadPicking);
    END;

    PROCEDURE Cantidad_En_PickingPed(_Pedido: Code[20]) Qty: Decimal;
    VAR
    // RecLinResPicking: Record 50010;
    BEGIN
        Qty := 0;

        // RecLinResPicking.RESET;
        // RecLinResPicking.SETCURRENTKEY("Pedido No.", Pendiente, "Fecha Servicio", "Pedido Item No.");
        // RecLinResPicking.SETRANGE("Pedido No.", _Pedido);
        // RecLinResPicking.SETRANGE(Pendiente, TRUE);
        // RecLinResPicking.SETFILTER("Fecha Servicio", Rec."F. Fecha Servicio Confirm.");
        // RecLinResPicking.SETFILTER("Pedido Item No.", Rec."Filtro Producto");
        // IF RecLinResPicking.FINDFIRST THEN
        //     REPEAT
        //         Qty += RecLinResPicking.Cantidad - RecLinResPicking."Cantidad Enviada";
        // UNTIL RecLinResPicking.NEXT = 0;
    END;


    PROCEDURE CalculoStock(Modelo: Code[20]; Color: Code[20]; Talla: Code[20]; CodPreemb: Code[20]): Decimal;
    VAR
        RecStock: Record 32;
        Stock: Integer;
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
        //RecProd.SETFILTER("Filtro Talla", Talla);

        //RecProd.SETRANGE("Filtro Preembalado", CodPreemb);

        IF CodPreemb = '' THEN
            //WMS EX-JFC 09/09/2019 Validar el almacen predeterminado SEGA
            //RecProd.SETRANGE("Location Filter",ConfAlm."Almacen Envio Generico")
            //RecProd.SETRANGE("Location Filter",ConfAlm."Almacen predet. SEGA")
            //WMS FIN EX-JFC 09/09/2019 Validar el almacen predeterminado SEGA
            RecProd.SETFILTER("Location Filter", FiltroAlmacenesSEGA()); //EX-SGG-WMS 100919
                                                                         //ELSE
                                                                         //  RecProd.SETRANGE("Location Filter", ConfAlm."Almacen Preembalado");

        IF RecProd.FINDFIRST THEN BEGIN
            RecProd.CALCFIELDS(Inventory);
            Stock := RecProd.Inventory;
        END;

        EXIT(Stock);
    END;

    PROCEDURE Crearlineasnoasignadas(CabTempPed: Code[20]; VAR CantNueva: Decimal; VAR CantServ: Decimal);
    VAR
        TempCrear1: Record 50011;
        LinPedCrear: Record 37;
        TempCrear2: Record 50011;
        TempCrear3: Record 50011;
    BEGIN
        CantNueva := 0;
        CantServ := 0;

        LinPedCrear.RESET;
        LinPedCrear.SETRANGE(LinPedCrear."Document Type", LinPedCrear."Document Type"::Order);
        LinPedCrear.SETRANGE("Document No.", CabTempPed);
        LinPedCrear.SETRANGE("Producto SEGA", TRUE); //EX-JFC 020322 A ado control producto SEGA
        IF LinPedCrear.FINDFIRST THEN
            REPEAT
                TempCrear1.RESET;
                TempCrear1.SETCURRENTKEY("Clave 1", Linea, Proceso);
                TempCrear1.SETRANGE("Clave 1", LinPedCrear."Document No.");
                TempCrear1.SETRANGE(Linea, LinPedCrear."Line No.");
                TempCrear1.SETRANGE(Proceso, 'WMSLIN');
                IF NOT TempCrear1.FINDFIRST THEN BEGIN
                    TempCrear2.INIT;
                    TempCrear2."Clave 1" := LinPedCrear."Document No.";
                    TempCrear2."Clave 2" := LinPedCrear."PfsHorizontal Component";
                    TempCrear2."Clave 3" := LinPedCrear."Sell-to Customer No.";
                    TempCrear2."Clave 4" := LinPedCrear."No.";
                    TempCrear2."Clave 5" := LinPedCrear."PfsVertical Component";
                    // TempCrear2."Clave 6" := LinPedCrear."PfsPrepack Code";
                    //TempCrear2."Clave 7"
                    //TempCrear2."Clave 8"
                    TempCrear2.Proceso := 'WMSLIN';
                    TempCrear2.usuario := USERID;
                    TempCrear2.Temporada := LinPedCrear."Shortcut Dimension 1 Code";
                    TempCrear2.Color := LinPedCrear."PfsVertical Component";
                    TempCrear2.Talla := LinPedCrear."PfsHorizontal Component";
                    TempCrear2.Cantidad := LinPedCrear."PfsOrder Quantity";
                    TempCrear2."Cantidad Servida" := LinPedCrear."Quantity Shipped";
                    TempCrear2."Cantidad Anulada" := LinPedCrear."Cantidad Anulada";
                    //EX-CV  -  2708  -  JX  -  2021 04 13
                    LinPedCrear.CALCFIELDS("Cantidad transferencia", "Cantidad en consignacion");
                    TempCrear2."Cantidad Pendiente" := LinPedCrear."Outstanding Quantity" -
                                                       (LinPedCrear."Cantidad transferencia" + LinPedCrear."Cantidad en consignacion");
                    //EX-CV  -  2708  -  JX  -  2021 04 13 END
                    //TempCrear2."Importe Pedido" := LinPedCrear."Outstanding Amount";
                    //SF-POF
                    IF LinPedCrear."VAT Calculation Type" <> LinPedCrear."VAT Calculation Type"::"Reverse Charge VAT" THEN
                        TempCrear2."Importe Pedido" += LinPedCrear."Outstanding Amount"
                    ELSE
                        TempCrear2."Importe Pedido" += LinPedCrear.Amount;
                    //SF-POF:FIN

                    TempCrear2."Fecha Servicio" := LinPedCrear."Fecha servicio confirmada";
                    TempCrear2."Serie Precio" := LinPedCrear."Serie Precio";
                    //TempCrear2."Serie Servicio" := LinPedCrear."Serie Servicio";
                    TempCrear2."Cod Variante" := LinPedCrear."Variant Code";
                    TempCrear2.Linea := LinPedCrear."Line No.";

                    //+EX-SGG 171122
                    RecProd.GET(TempCrear2."Clave 4");
                    TempCrear2."Tipo de producto" := RecProd.Tipo;
                    TempCrear2."Cod. grupo talla" := LinPedCrear."PfsHorz Component Group";
                    //-EX-SGG 171122

                    IF TempCrear2.Cantidad <> TempCrear2."Cantidad Anulada" THEN
                        IF TempCrear2.INSERT THEN;


                    TempCrear3.RESET;
                    TempCrear3.SETCURRENTKEY("Clave 1", Proceso);
                    TempCrear3.SETRANGE("Clave 1", CabTempPed);
                    TempCrear3.SETRANGE(Proceso, 'WMSCAB');
                    IF TempCrear3.FINDFIRST THEN BEGIN
                        TempCrear3.Cantidad += LinPedCrear."PfsOrder Quantity";
                        TempCrear3."Cantidad Servida" += LinPedCrear."Quantity Shipped";
                        TempCrear3.MODIFY;
                        CantNueva += LinPedCrear."PfsOrder Quantity";
                        CantServ += LinPedCrear."Quantity Shipped";
                    END;

                END;
            UNTIL LinPedCrear.NEXT = 0;
    END;

    PROCEDURE FiltroAlmacenesSEGA() lFiltroAlmacenes: Text[250];
    VAR
        lRstAlmacenes: Record 14;
    BEGIN
        //EX-SGG-WMS 100919
        lRstAlmacenes.SETRANGE("Clase de Stock SEGA", '1');
        lRstAlmacenes.SETRANGE("Estado Calidad SEGA", '0');
        //lRstAlmacenes.SETRANGE("Stock no gestionado por SEGA", FALSE);
        lRstAlmacenes.SETRANGE(Ecommerce, FALSE);
        lRstAlmacenes.SETRANGE(Reservado, FALSE);
        lRstAlmacenes.SETRANGE(Servicio, TRUE);
        lRstAlmacenes.FINDSET;
        REPEAT
            lFiltroAlmacenes += lRstAlmacenes.Code + '|';
        UNTIL lRstAlmacenes.NEXT = 0;
        lFiltroAlmacenes := COPYSTR(lFiltroAlmacenes, 1, STRLEN(lFiltroAlmacenes) - 1);
    END;

    var
        // RstCabRecepAlm: Record "WarehouseReceiptHeaderWMS";
        //   tmp_RstCabRecepAlm: Record "WarehouseReceiptHeaderWMS";
        // RstLinRecepAlm: Record "WarehouseReceiptLineWMS";
        // RstCabEnvAlm: Record "WarehouseShipmentHeaderWMS";
        // tmp_RstCabEnvAlm: Record "WarehouseShipmentHeaderWMS";
        // RstLinEnvAlm: Record "WarehouseShipmentLineWMS";
        // RstHistCabRecepAlm: Record "PostedWhseReceiptHeaderWMS";
        // RstHistCabEnvAlm: Record "PostedWhseShipmentHderWMS";
        RstControl: Record "Control integracion WMS";
        RstOE: Record "WMS OE-Ordenes de Entrada";
        RstCE: Record "WMS CE-Confirmación de Entrada";
        RstPE: Record "WMS PE-Pedidos";
        RstCS: Record "WMS CS-Confirmacion de Salidas";

        RstCP: Record "WMS CP-Confir. de Preparacion";
        RstAS: Record "WMS AS-Ajuste Stock";
        RstSA: Record "WMS SA-Stock Actual";
        RstLOG: Record "WMS Log de errores";
        RstCabVenta: Record "Sales Header";
        RstLinVenta: Record "Sales Line";
        RstCabCompra: Record "Purchase Header";
        RstLinCompra: Record "Purchase Line";
        RstConfCompras: Record "Purchases & Payables Setup";
        RstConfAlm: Record "Warehouse Setup";
        RstVinculos: Record "Record Link";
        RstAlmacen: Record "Location";
        RstProd: Record "Item";
        // RstAsignacionDirecta: Record "Asignaciones Vtas-Compras";
        // RstAtributos: Record "Atributos tto. logistic. WMS";
        RstConfUsuarios: Record "User Setup";
        //RstSucursales: Record "Sucursales de destino";
        RstRef: RecordRef;
        CduNoSeriesMgt: Codeunit "NoSeriesManagement";
        nRegControl: Integer;
        LinTransfer: Record "Transfer Line";
        globalSourceNo: Code[20];
        DimValue: Record 349;
        CabPedido: Record 36;
        TemporalRec: Record 50011;
        LinPedido: Record 37;

        FRepresentante: Text[30];
        FAlmacen: Text[30];
        CantTotal: Decimal;
        IncrCant: Decimal;
        Salir: Boolean;
        TallasRec: Record 96111;
        TempAgrup: Record 50011;
        TempAgrup2: Record 50011;
        FlagExport: Code[10];
        Sucursal: Code[10];
        Prioridad: Code[10];
        RecCli: Record 18;
        StockCalc: Integer;
        Solicitado: Decimal;
        RecPedVta: Record 36;
        CodPedido: Code[20];
        TemporalCab: Record 50011;
        TemporalCabMod: Record 50011;
        RecUser: Record 91;
        TemporalRecMod: Record 50011;
        LinPedImporte: Record 37;
        //RecPicking: Record 50010;
        ValorPicking: Integer;
        C: Integer;
        T: Integer;
        ConfAlm: Record 5769;
        RecProd: Record 27;
        RecProdF: Record 27;
        ContadorLin: Integer;
        CUFunc: Codeunit 50000;
        TempAgrup3: Record 50011;
        AsignPreemb: Boolean;
        CantPreemb: Integer;
        NumPreemb: Integer;
        NumPreemb2: Integer;
        NumPreemb3: Integer;
        Condicion6: Text[100];
        Condicion7: Text[100];
        ContadorLin2: Integer;
        EstadoCli: Record CustomerStatus;
        ClienteBloq: Boolean;
        CantNuevaGl: Decimal;
        CantServGl: Decimal;
        v_Prueba: Integer;


    /// <summary>
    /// CompruebaProdAlmSEGAImaginario.
    /// </summary>
    /// <param name="lCodProd">Code[20].</param>
    /// <param name="lCodAlm">Code[10].</param>
    procedure CompruebaProdAlmSEGAImaginario(lCodProd: Code[20]; lCodAlm: Code[10])
    //EX-SGG-WMS 020719
    var
    begin
        //TODO
        //  IF RstAlmacen.GET(lCodAlm) AND RstProd.GET(lCodProd) THEN
        //      IF (NOT RstAlmacen."Stock no gestionado por SEGA") THEN //EX-SGG-WMS 110919 ANTES RstAlamcen.Imaginario
        //          RstProd.TESTFIELD("Producto SEGA", EsAlmacenSEGA(RstAlmacen.Code));
    end;

    /// <summary>
    /// DevuelveAlmacenPredetSEGA.
    /// </summary>
    /// <returns>Return value of type Code[10].</returns>

    procedure DevuelveAlmacenPredetSEGA(): Code[10]
    begin
        //EX-SGG-WMS 020919
        RstConfAlm.Get();

        //TODO
        RstConfAlm.TestField("Almacen predet. SEGA");
        Exit(RstConfAlm."Almacen predet. SEGA");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeCheckReturnInfo', '', false, false)]
    local procedure OnBeforeCheckReturnInfo(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; xSalesHeader: Record "Sales Header"; BillTo: Boolean)
    var
    //    CduWMS: Codeunit "WareHouse Eventos";
    begin
        //TODO
        // CduWMS.EliminarAtributosTtoLogistico(1,SalesHeader."No.");//EX-SGG-WMS
    end;


    //codeunit 50414


    procedure InsertarRegistroLOG(var lRstControlWMS: Record 50414; lRespuestaSEGA: Boolean; lDescError: Text[250])
    begin
        //EX-SGG-WMS 180619
        CLEAR(RstLOG);
        RstLOG.INIT;
        RstLOG.VALIDATE("No. registro", UltimoNumeroRegistroLOG() + 1);
        RstLOG.VALIDATE(Interface, lRstControlWMS.Interface);
        RstLOG.VALIDATE("Tipo documento", lRstControlWMS."Tipo documento");
        RstLOG.VALIDATE("No. documento", lRstControlWMS."No. documento");
        RstLOG.VALIDATE("Id. WMS", lRstControlWMS."Id. SEGA");
        RstLOG.VALIDATE("Fecha y hora", CURRENTDATETIME);
        RstLOG.VALIDATE(Descripcion, lDescError);
        RstLOG.VALIDATE("No. registro control rel.", lRstControlWMS."No. registro");
        RstLOG.VALIDATE("Respuesta SEGA", lRespuestaSEGA); //EX-SGG-WMS 280819
        RstLOG.INSERT(TRUE);
    end;

    procedure UltimoNumeroRegistroLOG(): Integer
    var
        lRstLOG: Record 50420;
    begin
        //EX-SGG-WMS 180619
        IF lRstLOG.FINDLAST THEN
            EXIT(lRstLOG."No. registro")
        ELSE
            EXIT(0);
    end;



    procedure DevuelveComentarios(lIdTabla: Integer; lNoDoc: Code[20]; lLongitudMax: Integer) lComentarios: Text[250]
    var
        lRstComentarios: Record 5770;
    begin
        //EX-SGG-WMS 120619
        CASE lIdTabla OF
            DATABASE::"Warehouse Receipt Header":
                lRstComentarios.SETRANGE("Table Name", lRstComentarios."Table Name"::"Whse. Receipt");
            DATABASE::"Warehouse Shipment Header":
                lRstComentarios.SETRANGE("Table Name", lRstComentarios."Table Name"::"Whse. Shipment");
        END;
        IF lLongitudMax > MAXSTRLEN(lComentarios) THEN
            lLongitudMax := MAXSTRLEN(lComentarios);
        lRstComentarios.SETRANGE(Type, lRstComentarios.Type::" ");
        lRstComentarios.SETRANGE("No.", lNoDoc);
        IF lRstComentarios.FINDSET THEN
            REPEAT
                lComentarios += COPYSTR(lRstComentarios.Comment, 1, lLongitudMax);
                lLongitudMax -= STRLEN(COPYSTR(lRstComentarios.Comment, 1, lLongitudMax));
            UNTIL (lRstComentarios.NEXT = 0) OR (lLongitudMax <= 0)
    end;

    procedure DevuelveCodigoArticuloERP(lCodProd: Code[20]; lCodVar: Code[10]): Text[250]
    begin
        //EX-SGG-WMS 120619
        EXIT(lCodProd + '-' + lCodVar);
    end;

    procedure ObtenerCodigoArticuloERP(lCodArtERP: Text[30]; var lCodProd: Code[20]; var lCodVarProd: Code[10])
    var
        lLong: Integer;
    begin
        //EX-SGG-WMS 280819 COMENTO Y REHAGO. SEGUN CONFIG VERTICAL SON LONGITUDES MAXIMAS.
        /*
        //EX-SGG-WMS 260619
        RstPfsSetup.GET;
        RstPfsSetup.TESTFIELD("Variant Vert Component Length");
        RstPfsSetup.TESTFIELD("Variant Horz Component Length");
        RstPfsSetup.TESTFIELD("Variant Seperator");
        lLong:=RstPfsSetup."Variant Vert Component Length"+STRLEN(RstPfsSetup."Variant Seperator")+
                 RstPfsSetup."Variant Horz Component Length";
        IF STRLEN(lCodArtERP)>lLong THEN
         BEGIN
          lCodProd:=COPYSTR(lCodArtERP,1,STRLEN(lCodArtERP)-lLong-1);
          lCodVarProd:=COPYSTR(lCodArtERP,STRLEN(lCodArtERP)-lLong+1);
         END;
        */
        IF (STRPOS(lCodArtERP, '-') > 0) AND (STRLEN(lCodArtERP) > STRPOS(lCodArtERP, '-') + 1) THEN BEGIN
            lCodProd := COPYSTR(lCodArtERP, 1, STRPOS(lCodArtERP, '-') - 1);
            lCodVarProd := COPYSTR(lCodArtERP, STRPOS(lCodArtERP, '-') + 1);
        END;

    end;

    procedure DevuelveEstadoCalidadAlmacen(lCodAlmacen: Code[10]) lEstadoCalidad: Integer
    begin
        //EX-SGG-WMS 120619
        RstAlmacen.GET(lCodAlmacen);
        IF RstAlmacen."Estado Calidad SEGA" <> '' THEN
            EVALUATE(lEstadoCalidad, RstAlmacen."Estado Calidad SEGA");
    end;


    procedure EsAlmacenSEGA(lCodAlmacen: Code[10]): Boolean
    begin
        //EX-SGG-WMS 270619
        IF RstAlmacen.GET(lCodAlmacen) THEN
            //EXIT((RstAlmacen."Estado Stock SEGA"<>'') AND (RstAlmacen."Estado Calidad SEGA"<>''));
            //EX-SGG-WMS 060919
            EXIT((RstAlmacen."Clase de Stock SEGA" <> '') AND (RstAlmacen."Estado Calidad SEGA" <> ''))
        // AND
        //   (NOT RstAlmacen."Stock no gestionado por SEGA"));
    end;

    procedure EsProductoSEGA(lCodProd: Code[20]): Boolean
    begin
        //EX-SGG-WMS 020719
        RstProd.GET(lCodProd);
        EXIT(RstProd."Producto SEGA");
    end;

    procedure EsUsuarioSEGA(lCodUsuario: Code[50]): Boolean
    begin
        //se aumenta a 50 
        //EX-SGG-WMS 230719
        IF RstConfUsuarios.GET(lCodUsuario) THEN
            EXIT(RstConfUsuarios."Usuario SEGA");
    end;

    procedure EnviarASEGA(lCodProd: Code[20]; lCodAlmacen: Code[10]): Boolean
    begin
        //EX-SGG-WMS 020719
        // RstAlmacen.GET(lCodAlmacen);
        // //IF EsProductoSEGA(lCodProd) AND (NOT RstAlmacen."Stock no gestionado por SEGA") AND EsAlmacenSEGA(RstAlmacen.Code) THEN
        // IF (NOT RstAlmacen."Stock no gestionado por SEGA") AND EsAlmacenSEGA(RstAlmacen.Code) THEN //EX-SGG-WMS 191219
        //     EXIT(RstAlmacen."Estado Stock SEGA" <> '2'); //RETIRADO
    end;

    procedure CompruebaCantidadSEGAvsNAV(lCantSEGA: Integer; lCantNAV: Integer; lInterface: Text[30]; lNoDoc: Code[20]; lNomTblSEGA: Text[30]; lLinTblSEGA: Text[30]; lNomTblNAV: Text[30]; lLinTblNAV: Text[30]; lTxtVariable: Text[30]; var lError: Boolean; var lDescError: Text[250])
    begin
        //EX-SGG-WMS 280920
        CASE TRUE OF
            lCantSEGA > lCantNAV:
                BEGIN
                    lError := TRUE;
                    lDescError := COPYSTR(lInterface + ' ' + lNoDoc + ':' + lTxtVariable + lNomTblSEGA + '(' + FORMAT(lCantSEGA) + ') ' +
                                ' en linea ' + lLinTblSEGA + ' no debe ser mayor que en ' + lNomTblNAV + '(' + FORMAT(lCantNAV) + ')' +
                                ' en linea ' + lLinTblNAV, 1, MAXSTRLEN(lDescError));
                END;
            ((lCantSEGA > 0) AND (lCantNAV < 0)) OR ((lCantSEGA < 0) AND (lCantNAV > 0)):
                BEGIN
                    lError := TRUE;
                    lDescError := COPYSTR(lInterface + ' ' + lNoDoc + ':' + lTxtVariable + lNomTblSEGA + '(' + FORMAT(lCantSEGA) + ') ' +
                                ' en linea ' + lLinTblSEGA + ' debe tener el mismo signo que en ' + lNomTblNAV + '(' + FORMAT(lCantNAV) + ')' +
                                ' en linea ' + lLinTblNAV, 1, MAXSTRLEN(lDescError));
                END;

        END;
    end;


    procedure CompruebaCantProdYVar(lInterface: Text[30]; lCantidad: Decimal; lCodProd: Code[20]; lCodVarProd: Code[10]; lCodAlmacen: Code[10]; lFiltroAlmacenesSEGA: Text[250]; var lCantidadNAV: Decimal; var lError: Boolean; var lDescError: Text[250])
    var
        lRstProd: Record 27;
        lRstVarProd: Record 5401;
        // lCduPfsControl: Codeunit "11006100";
        dummyCtrl: Record 50414;
        txtInterfaceSA: Text[30];
    begin
        //EX-SGG-WMS 280619 AGREGO PARAMETROS PARA FILTRO ALMACENES SEGA Y CANTIDAD NAV.
        //EX-SGG-WMS 260619

        // Truco 20210916-NM-CSA para comparar TXT de Option
        dummyCtrl.Interface := dummyCtrl.Interface::"SA-Stock Actual";
        txtInterfaceSA := FORMAT(dummyCtrl.Interface);
        CLEAR(dummyCtrl);

        RstProd.RESET;
        IF NOT RstProd.GET(lCodProd) THEN
            lDescError := COPYSTR(lInterface + ': No se encuentra el producto ' + lCodProd, 1, MAXSTRLEN(lDescError))
        //EX-SGG-WMS 060919 COMENTO.
        /*
        ELSE IF NOT lCduPfsControl.CheckItemStatus(RstProd."PfsItem Status",'Z') THEN
         lDescError:=COPYSTR(lInterface+': El producto '+RstProd."No."+' tiene el estado '+RstProd."PfsItem Status"
                      ,1,MAXSTRLEN(lDescError))
        */
        ELSE
            IF NOT lRstVarProd.GET(RstProd."No.", lCodVarProd) THEN
                lDescError := COPYSTR(lInterface + ': No se encuentra la variante ' + lCodVarProd + ' para el producto ' +
                               lCodProd, 1, MAXSTRLEN(lDescError))
            //EX-SGG-WMS 060919 COMENTO.
            /*
            ELSE IF NOT lCduPfsControl.CheckItemStatus(lRstVarProd."PfsItem Status",'Z') THEN
             lDescError:=COPYSTR(lInterface+': La variante '+lRstVarProd.Code+' del producto '+RstProd."No."+
                          ' tiene el estado '+lRstVarProd."PfsItem Status",1,MAXSTRLEN(lDescError))
            */
            ELSE
                IF NOT RstAlmacen.GET(lCodAlmacen) THEN
                    lDescError := COPYSTR(lInterface + ': No existe el almacén ' + lCodAlmacen, 1, MAXSTRLEN(lDescError))
                ELSE
                    IF (lCantidad = 0) AND (lInterface <> txtInterfaceSA) THEN //EX-SGG-WMS 280720 // 20210916-NM-CSA (txtInterfaceSA)
                        lDescError := COPYSTR(lInterface + ': La cantidad para la variante ' + lCodVarProd + ' y el producto ' +
                                       lCodProd + ' no puede ser 0', 1, MAXSTRLEN(lDescError))
                    ELSE
                        IF lCantidad < 0 THEN BEGIN
                            RstProd.SETFILTER("Location Filter", lFiltroAlmacenesSEGA);
                            RstProd.SETRANGE("Variant Filter", lRstVarProd.Code);
                            RstProd.CALCFIELDS(Inventory);
                            IF ABS(lCantidad) > RstProd.Inventory THEN
                                lDescError := COPYSTR(lInterface + ': No es posible realizar un ajuste negativo por más cantidad de la existente ' +
                                             'para el producto ' + lCodProd + ', variante ' + lCodVarProd + '(' + FORMAT(RstProd.Inventory) + FORMAT(lCantidad)
                                             , 1, MAXSTRLEN(lDescError));
                            lCantidadNAV := RstProd.Inventory;
                        END;
        lError := lDescError <> '';

    end;

    procedure ObtenerAlmacenPpalEstadosSEGA(lInterface: Text[30]; lestadoCalidad: Integer; lclaseStock: Integer; var lCodAlmacen: Code[20]; var lError: Boolean; var lDescError: Text[250])
    begin
        //EX-SGG-WMS 260619
        RstAlmacen.RESET;
        RstAlmacen.SETRANGE(RstAlmacen."Clase de Stock SEGA", FORMAT(lclaseStock));
        RstAlmacen.SETRANGE(RstAlmacen."Estado Calidad SEGA", FORMAT(lestadoCalidad));
        RstAlmacen.SETRANGE(RstAlmacen."Almacen principal SEGA", TRUE);
        IF RstAlmacen.FINDFIRST THEN
            lCodAlmacen := RstAlmacen.Code
        ELSE BEGIN
            lError := TRUE;
            lDescError := COPYSTR(lInterface + ': No existe almacen ppal SEGA con clase stock ' + FORMAT(lclaseStock) +
             ' y estado calidad ' + FORMAT(lestadoCalidad), 1, MAXSTRLEN(lDescError));
        END;
    end;

    procedure ObtenerFiltroAlmacenesSEGA(lestadoCalidad: Integer; lclaseStock: Integer; var lFiltroAlmacenesSEGA: Text[250])
    begin
        //EX-SGG-WMS 280619
        CLEAR(lFiltroAlmacenesSEGA);
        RstAlmacen.RESET;
        RstAlmacen.SETRANGE(RstAlmacen."Clase de Stock SEGA", FORMAT(lclaseStock));
        RstAlmacen.SETRANGE("Estado Calidad SEGA", FORMAT(lestadoCalidad));
        //TODO
        //EL CAMPO STOCK NO GESTIONADO POR SEGA PREGUNTAR SI CONTINUA
        //   RstAlmacen.SETRANGE("Stock no gestionado por SEGA", FALSE); //EX-SGG-WMS 060919
        RstAlmacen.FINDSET;
        REPEAT
            lFiltroAlmacenesSEGA += RstAlmacen.Code + '|';
        UNTIL RstAlmacen.NEXT = 0;
        lFiltroAlmacenesSEGA := COPYSTR(lFiltroAlmacenesSEGA, 1, STRLEN(lFiltroAlmacenesSEGA) - 1);
    end;

    procedure DocumentoEliminadoEnSEGA(var lRstControlWMS: Record 50414)
    var
        lCduRelease: Codeunit 7310;
        lPregunta: Text[1024];
        respControl: Record 50414;
        RstCabEnvAlm: Record "Warehouse Shipment Header";
        RstCabRecepAlm: Record "Warehouse Receipt Header";
        RstLinRecepAlm: Record "Warehouse Receipt Line";
    begin
        //EX-SGG-WMS 311019
        // lRstControlWMS.TESTFIELD(Estado,lRstControlWMS.Estado::Error); NM-CSA-191205
        IF NOT (lRstControlWMS.Interface IN [lRstControlWMS.Interface::"PE-Pedido", lRstControlWMS.Interface::"OE-Orden de Entrada"]) THEN
            ERROR('Esta acción solo puede realizarse para interfaces tipo ' + FORMAT(lRstControlWMS.Interface::"OE-Orden de Entrada") +
             ' y ' + FORMAT(lRstControlWMS.Interface::"PE-Pedido"));
        lPregunta := '¿Está seguro de que el documento ' + lRstControlWMS."No. documento" + ' está eliminado en SEGA ' +
         'y debe también eliminarse en el Control de Integración?';
        IF NOT CONFIRM(lPregunta, FALSE) THEN ERROR('Eliminación cancelada');
        IF NOT CONFIRM('Esta acción también dejará el documento original abierto, pero no lo eliminará.\\' + lPregunta, FALSE) THEN
            ERROR('Eliminación cancelada');

        // NM-CSA-191205
        IF (lRstControlWMS.Estado <> lRstControlWMS.Estado::Error) THEN
            IF NOT CONFIRM('El documento "' + lRstControlWMS."No. documento" + '" no se encuentra en estado ERROR.' +
              '\\¿Se ha asegurado de que está anulado en SEGA y debe eliminarse de este Control?', FALSE) THEN
                ERROR('Eliminación cancelada')
;

        CASE lRstControlWMS."Tipo documento" OF
            lRstControlWMS."Tipo documento"::"Envio almacen":
                BEGIN
                    // NM-CSA-191205
                    respControl.RESET;
                    respControl.SETRANGE(Interface, respControl.Interface::"CS-Confirmacion de Salida");
                    respControl.SETRANGE("No. documento", lRstControlWMS."No. documento");
                    IF respControl.FINDFIRST THEN ERROR('No es posible eliminar un documento para el que ya se ha recibido un mensaje CS.');
                    // FIN NM-CSA-191205
                    RstCabEnvAlm.GET(lRstControlWMS."No. documento");
                    RstCabEnvAlm."Document Status" := RstCabEnvAlm."Document Status"::" ";
                    RstCabEnvAlm.Obtenido := FALSE;
                    lCduRelease.Reopen(RstCabEnvAlm);
                    lRstControlWMS.Estado := lRstControlWMS.Estado::Pendiente;
                    lRstControlWMS.DELETE(TRUE);
                END;
            lRstControlWMS."Tipo documento"::"Recepcion almacen":
                BEGIN
                    // NM-CSA-191205
                    respControl.RESET;
                    respControl.SETRANGE(Interface, respControl.Interface::"CE-Confirmacion de Entrada");
                    respControl.SETRANGE("No. documento", lRstControlWMS."No. documento");
                    IF respControl.FINDFIRST THEN ERROR('No es posible eliminar un documento para el que ya se ha recibido un mensaje CE.');
                    // FIN NM-CSA-191205
                    RstCabRecepAlm.GET(lRstControlWMS."No. documento");
                    RstCabRecepAlm.Obtenido := FALSE;
                    RstCabRecepAlm.Status := RstCabRecepAlm.Status::Open;
                    RstCabRecepAlm.MODIFY;
                    RstLinRecepAlm.RESET;
                    RstLinRecepAlm.SETRANGE("No.", RstCabRecepAlm."No.");
                    //   RstLinRecepAlm.MODIFYALL("Estado cabecera", RstCabRecepAlm.Status);
                    lRstControlWMS.Estado := lRstControlWMS.Estado::Pendiente;
                    lRstControlWMS.DELETE(TRUE);
                END;
            ELSE
                ERROR('Esta acción solo puede realizarse para tipos de documento ' + FORMAT(lRstControlWMS."Tipo documento"::"Recepcion almacen")
               +
                 ' y ' + FORMAT(lRstControlWMS."Tipo documento"::"Envio almacen"));
        END;
    end;


    procedure ComprobarUsuarioSiProductoSEGA(lCodProducto: Code[20]; lIDUsuario: Code[20]; lValidarProducto: Boolean; var lAlmacen: Code[10])
    begin
        //EX-SGG-WMS 280619
        IF RstProd.GET(lCodProducto) THEN
            IF RstProd."Producto SEGA" THEN
                IF RstConfUsuarios.GET(lIDUsuario) THEN
                    //EX-SGG 161220
                    //RstConfUsuarios.TESTFIELD("Usuario SEGA");
                    IF NOT RstConfUsuarios."Usuario SEGA" THEN BEGIN
                        IF lValidarProducto AND (lAlmacen = '') THEN BEGIN
                            RstAlmacen.RESET;
                            RstAlmacen.SETFILTER(RstAlmacen."Clase de Stock SEGA", '<>''''');
                            RstAlmacen.SETFILTER("Estado Calidad SEGA", '<>''''');
                            //    RstAlmacen.SETRANGE("Stock no gestionado por SEGA", TRUE);
                            IF RstAlmacen.FINDFIRST THEN
                                lAlmacen := RstAlmacen.Code;
                        END;
                        IF RstAlmacen.GET(lAlmacen) THEN
                            IF ((RstAlmacen."Clase de Stock SEGA" = '') OR (RstAlmacen."Estado Calidad SEGA" = '')) OR
                                ((RstAlmacen."Clase de Stock SEGA" <> '') AND (RstAlmacen."Estado Calidad SEGA" <> '')) then
                                // (NOT RstAlmacen."Stock no gestionado por SEGA")) THEN
                                ERROR('Debe seleccionar un almacén SEGA no gestionado');
                    END;
        //FIN EX-SGG 161220
    end;

    //  procedure CompruebaProdAlmSEGAImaginario(lCodProd: Code[20]; lCodAlm: Code[10])
    // begin
    //     //EX-SGG-WMS 020719
    //     IF RstAlmacen.GET(lCodAlm) AND RstProd.GET(lCodProd) THEN
    //         IF (NOT RstAlmacen."Stock no gestionado por SEGA") THEN //EX-SGG-WMS 110919 ANTES RstAlamcen.Imaginario
    //             RstProd.TESTFIELD("Producto SEGA", EsAlmacenSEGA(RstAlmacen.Code));
    // end;

    procedure ComprobacionesPreviasASySA(var lRstLinDia: Record 83; lRstControlWMS: Record 50414; lestadoCalidad: Integer; lclaseStock: Integer; lcodigoArticuloERP: Text[20]; lcantidad: Decimal; var lCantidadNAV: Decimal; var lCodProd: Code[20]; var lCodVarProd: Code[10]; var lCodAlmPpal: Code[10]; var lFiltroAlmacen: Text[250]; var lError: Boolean; var lDescError: Text[250])
    begin
        //EX-SGG-WMS 040719
        CLEAR(lError); //EX-SGG-WMS 030719
        CLEAR(lDescError); //EX-SGG-WMS 030719
        CLEAR(lRstLinDia);
        lRstLinDia.RESET;
        CASE lRstControlWMS.Interface OF
            lRstControlWMS.Interface::"AS-Ajuste de Stock":
                BEGIN
                    lRstLinDia.SETRANGE("Journal Template Name", RstConfAlm."Libro Diario Producto");
                    lRstLinDia.SETRANGE("Journal Batch Name", RstConfAlm."Seccion Diario Producto");
                    lRstLinDia.DELETEALL(TRUE); //EX-SGG-WMS 271119
                END;
            lRstControlWMS.Interface::"SA-Stock Actual":
                BEGIN
                    lRstLinDia.SETRANGE("Journal Template Name", RstConfAlm."Libro Diario Inventario");
                    lRstLinDia.SETRANGE("Journal Batch Name", RstConfAlm."Seccion Diario Inventario");
                END;
        END;
        //lRstLinDia.DELETEALL(TRUE); //EX-SGG-WMS 271119 COMENTO. SOLO EN AS.
        COMMIT; //EX-SGG-WMS 290819
        lRstLinDia.INIT;
        ObtenerAlmacenPpalEstadosSEGA(FORMAT(lRstControlWMS.Interface), lestadoCalidad, lclaseStock,
         lCodAlmPpal, lError, lDescError);
        IF NOT lError THEN BEGIN
            ObtenerFiltroAlmacenesSEGA(lestadoCalidad, lclaseStock, lFiltroAlmacen); //EX-SGG-WMS 280619
            ObtenerCodigoArticuloERP(lcodigoArticuloERP, lCodProd, lCodVarProd);
            CompruebaCantProdYVar(FORMAT(lRstControlWMS.Interface), lcantidad, lCodProd, lCodVarProd,
              lCodAlmPpal, lFiltroAlmacen, lCantidadNAV, lError, lDescError);
        END;

        //EX-SGG-WMS 200919
        IF NOT lError THEN
            IF NOT EsProductoSEGA(lCodProd) THEN BEGIN
                lError := TRUE;
                lDescError := COPYSTR(FORMAT(lRstControlWMS.Interface) + ': El producto ' + lCodProd + ' no es un producto SEGA.'
                             , 1, MAXSTRLEN(lDescError));
            END;
    end;

    procedure AgruparRegistrosASDevolCompras(var lRstControlWMS: Record 50414; var lRstTMPAS: Record 50418 temporary; var lRstTMPCabCompra: Record "Purchase Header" temporary; var lError: Boolean; var lDescError: Text[250])
    begin
        //EX-SGG-WMS 040620
        lRstTMPAS.RESET;
        lRstTMPAS.DELETEALL;
        lRstTMPCabCompra.RESET;
        lRstTMPCabCompra.DELETEALL;
        IF RstAS.FINDSET THEN
            REPEAT
                lRstTMPAS.SETRANGE(codigoArticuloERP, RstAS.codigoArticuloERP);
                lRstTMPAS.SETRANGE(observaciones, RstAS.observaciones);
                IF NOT lRstTMPAS.FINDFIRST THEN BEGIN
                    lRstTMPAS.TRANSFERFIELDS(RstAS);
                    lRstTMPAS.cantidad := lRstTMPAS.cantidad * -1; //EX-SGG 140920
                    lRstTMPAS.INSERT;
                END
                ELSE BEGIN
                    IF lRstTMPAS.estadoCalidad <> RstAS.estadoCalidad THEN BEGIN
                        lError := TRUE;
                        lDescError := FORMAT(lRstControlWMS.Interface::"AS-Ajuste de Stock") +
                         ' ' + lRstControlWMS."No. documento" + ':estadoCalidad ' + RstAS.TABLENAME + '(' + FORMAT(RstAS.estadoCalidad) + ') ' +
                         'no debe ser distinto para el mismo SKU y devolución';
                    END
                    ELSE BEGIN
                        //lRstTMPAS.cantidad+=RstAS.cantidad;
                        lRstTMPAS.cantidad += (RstAS.cantidad * -1); //EX-SGG 140920
                        lRstTMPAS.MODIFY;
                    END;
                END;
                IF NOT lRstTMPCabCompra.GET(lRstTMPCabCompra."Document Type"::"Return Order", RstAS.observaciones) THEN BEGIN
                    lRstTMPCabCompra."Document Type" := lRstTMPCabCompra."Document Type"::"Return Order";
                    lRstTMPCabCompra."No." := RstAS.observaciones;
                    lRstTMPCabCompra.INSERT;
                END;
            UNTIL (RstAS.NEXT = 0) OR lError;
    end;

    procedure AgruparRegistrosCE(var lRstControlWMS: Record 50414; var lRstTMPCE: Record 50409 temporary; var lError: Boolean; var lDescError: Text[250])
    begin
        //EX-SGG-WMS 280819
        lRstTMPCE.RESET;
        lRstTMPCE.DELETEALL;
        lRstTMPCE.SETCURRENTKEY(correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada);
        lRstTMPCE.COPYFILTERS(RstCE);
        IF RstCE.FINDSET THEN
            REPEAT
                lRstTMPCE.SETRANGE(lineaOrdenEntrada, RstCE.lineaOrdenEntrada);
                IF NOT lRstTMPCE.FINDFIRST THEN BEGIN
                    lRstTMPCE.TRANSFERFIELDS(RstCE);
                    lRstTMPCE.INSERT;
                END
                ELSE BEGIN
                    IF lRstTMPCE.estadoCalidad <> RstCE.estadoCalidad THEN BEGIN
                        lError := TRUE;
                        lDescError := FORMAT(lRstControlWMS.Interface::"CE-Confirmacion de Entrada") +
                         ' ' + lRstControlWMS."No. documento" + ':estadoCalidad ' + RstCE.TABLENAME + '(' + FORMAT(RstCE.estadoCalidad) + ') ' +
                         'no debe ser distinto para la misma línea de recepción y distintos contenedores';
                    END
                    ELSE BEGIN
                        lRstTMPCE.Cantidad += RstCE.Cantidad;
                        lRstTMPCE.MODIFY;
                    END;
                END;
            UNTIL (RstCE.NEXT = 0) OR (lError);
    end;

    procedure AgruparRegistrosCS(var lRstControlWMS: Record 50414; var lRstTMPCS: Record 50417 temporary; var lError: Boolean; var lDescError: Text[250])
    begin
        //EX-SGG-WMS 120919
        lRstTMPCS.RESET;
        lRstTMPCS.DELETEALL;
        lRstTMPCS.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP);
        lRstTMPCS.COPYFILTERS(RstCS);
        IF RstCS.FINDSET THEN
            REPEAT
                lRstTMPCS.SETRANGE(lineaEntregaERP, RstCS.lineaEntregaERP);
                IF NOT lRstTMPCS.FINDFIRST THEN BEGIN
                    lRstTMPCS.TRANSFERFIELDS(RstCS);
                    lRstTMPCS.INSERT;
                END
                ELSE BEGIN
                    IF lRstTMPCS.claseStock <> RstCS.claseStock THEN BEGIN
                        lError := TRUE;
                        lDescError := FORMAT(lRstControlWMS.Interface::"CS-Confirmacion de Salida") +
                         ' ' + lRstControlWMS."No. documento" + ':claseStock ' + RstCS.TABLENAME + '(' + FORMAT(RstCS.claseStock) + ') ' +
                         'no debe ser distinto para la misma línea de envío y distintos contenedores';
                    END
                    ELSE BEGIN
                        lRstTMPCS.cantidad += RstCS.cantidad;
                        lRstTMPCS.MODIFY;
                    END;
                END;
            UNTIL (RstCS.NEXT = 0) OR (lError);
    end;

    procedure ProcesarRegistrosControl(var lRstControlWMS: Record "Control integracion WMS")

    var
        lRstTMPLinRecepAlm: Record "Warehouse Receipt Line" temporary;
        lRstTMPLinEnvAlm: Record "Warehouse Shipment Line" temporary;
        lRstLinDia: Record 83;
        lRstTMPCE: Record "WMS CE-Confirmación de Entrada" temporary;
        lRstTMPCS: Record 50417 temporary;
        lRstTMPAS: Record 50418 temporary;
        lRstTMPCabCompra: Record 38 temporary;
        //   lCduRegRecep: Codeunit "50410";
        // lCduRegEnv: Codeunit "50412";
        lCduRegCompra: Codeunit 90;
        lCduLanzarPedCompra: Codeunit 415;
        lRptCalcInv: Report 790;
        lF: File;
        lOutStr: OutStream;
        //   lXMLOE: XMLport "50400";
        //   lXMLPE: XMLport "50401";
        lNombreFichero: Text[1024];
        lError: Boolean;
        lDescError: Text[250];
        lAlgunError: Boolean;
        lFiltroAlmacen: Text[250];
        lCantidadSEGA: Decimal;
        lCantidadNAV: Decimal;
        lCantidadDif: Decimal;
        lCodProd: Code[20];
        lCodVarProd: Code[10];
        lCodAlmPpal: Code[10];
        lnLinea: Integer;
        lIntAux: Integer;
        lCodAux: Code[10];
        lDecAux: Decimal;
        lCSSinNumLinea: Boolean;
        recTransferLine: Record 5741;
        recSalesHeader: Record "Sales Header";
        recTransferHeader: Record 5740;
        lisConsig: Boolean;
    begin

        //EX-SGG-WMS 170619
        IF lRstTMPLinRecepAlm.FINDFIRST OR lRstTMPLinEnvAlm.FINDFIRST OR lRstTMPCE.FINDFIRST OR lRstTMPCS.FINDFIRST
         OR lRstTMPAS.FINDFIRST OR lRstTMPCabCompra.FINDFIRST THEN
            ERROR('Las variables temporales no deben contener registros');
        RstConfAlm.GET;
        RstConfAlm.TESTFIELD("Ruta ficheros integracion WMS");
        RstConfAlm.TESTFIELD("Libro Diario Producto");
        RstConfAlm.TESTFIELD("Seccion Diario Producto");
        RstConfAlm.TESTFIELD("Libro Diario Inventario");
        RstConfAlm.TESTFIELD("Seccion Diario Inventario");
        lRstControlWMS.SETRANGE(Estado, lRstControlWMS.Estado::Pendiente);
        IF lRstControlWMS.FINDSET THEN BEGIN
            CLEAR(lError);
            CLEAR(lDescError);
            //Trato solo el motivo 26, el resto está pendiente
            REPEAT
                CASE lRstControlWMS.Interface OF
                    lRstControlWMS.Interface::"OE-Orden de Entrada", lRstControlWMS.Interface::"PE-Pedido":
                        BEGIN
                            Message('en desarrollo vlr');

                            //   lNombreFichero := RstConfAlm."Ruta ficheros integracion WMS" + DELCHR(FORMAT(WORKDATE, 0, '<Standard Format,9>'), '=', '-') +
                            //    DELCHR(FORMAT(TIME, 0, '<Standard Format,9>'), '=', ':') + '_' + COPYSTR(FORMAT(lRstControlWMS.Interface), 1, 2) +
                            //    '_' + lRstControlWMS."No. documento" + '.xml';
                            //   lF.CREATE(lNombreFichero);
                            //   lF.CREATEOUTSTREAM(lOutStr);
                            //   CASE lRstControlWMS.Interface OF
                            //       lRstControlWMS.Interface::"OE-Orden de Entrada":
                            //           BEGIN
                            //               RstOE.RESET;
                            //               RstOE.SETCURRENTKEY(codigoOrdenEntrada);
                            //               RstOE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                            //               RstOE.FINDSET;
                            //               CLEAR(lXMLOE);
                            //               lXMLOE.SETTABLEVIEW(RstOE);
                            //               lXMLOE.SETDESTINATION(lOutStr);
                            //               lXMLOE.EXPORT;
                            //           END;
                            //       lRstControlWMS.Interface::"PE-Pedido":
                            //           BEGIN
                            //               RstPE.RESET;
                            //               RstPE.SETCURRENTKEY(codigoEntregaERP);
                            //               RstPE.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                            //               RstPE.FINDSET;
                            //               CLEAR(lXMLPE);
                            //               lXMLPE.SETTABLEVIEW(RstPE);
                            //               lXMLPE.SETDESTINATION(lOutStr);
                            //               lXMLPE.EXPORT;
                            //           END;
                            //   END;
                            //   lF.CLOSE;
                            //   EliminaTagsVaciosFicheroXML(lNombreFichero); //EX-SGG-WMS 150719
                            //   lRstControlWMS.ADDLINK(lNombreFichero, 'Integración WMS');
                            //   lRstControlWMS.VALIDATE("Fecha y hora procesado", CURRENTDATETIME);
                            //   lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Preparado);
                            //   lRstControlWMS.MODIFY(TRUE);
                        END;



                    lRstControlWMS.Interface::"CE-Confirmacion de Entrada":  //EX-SGG-WMS 180619
                        BEGIN
                            //   RstCE.RESET;
                            //   RstCE.SETCURRENTKEY(correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada); //EX-SGG 280819
                            //   RstCE.SETRANGE(correlativoRecepcion, lRstControlWMS."Id. SEGA");
                            //   RstCE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                            //   RstCE.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA");
                            //   RstCE.SETRANGE(finCodigoOrdenEntrada, TRUE); //EX-SGG-WMS 071119
                            //   IF RstCE.FINDFIRST THEN //EX-SGG-WMS 071119
                            //    BEGIN //EX-SGG-WMS 071119
                            //       RstCE.SETRANGE(finCodigoOrdenEntrada); //EX-SGG-WMS 071119
                            //                                              //EX-SGG-WMS 020719 USO RSTOE
                            //       RstOE.RESET;
                            //       RstOE.SETCURRENTKEY(codigoOrdenEntrada);
                            //       RstOE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                            //       //FIN EX-SGG-WMS 020719
                            //       //EX-SGG-WMS 280819

                            //       CLEAR(lError);
                            //       lDescError := FORMAT(lRstControlWMS.Interface::"CE-Confirmacion de Entrada") +
                            //        ' ' + lRstControlWMS."No. documento";
                            //       IF NOT RstOE.FINDFIRST THEN BEGIN
                            //           lError := TRUE;
                            //           lDescError += ':No se encuentra la recepción de almacén NAV';
                            //       END;
                            //       //FIN EX-SGG-WMS 280819
                            //       IF NOT lError THEN BEGIN
                            //           AgruparRegistrosCE(lRstControlWMS, lRstTMPCE, lError, lDescError);//EX-SGG-WMS 280819
                            //           lRstTMPLinRecepAlm.RESET;
                            //           lRstTMPLinRecepAlm.DELETEALL;
                            //           //IF RstCE.FINDSET THEN
                            //           lRstTMPCE.RESET; //EX-SGG-WMS 280819 USO VAR TEMPORAL AGRUPADA.
                            //           IF (lRstTMPCE.FINDSET) AND (NOT lError) THEN
                            //               REPEAT
                            //                   IF EVALUATE(lnLinea, lRstTMPCE.lineaOrdenEntrada) THEN; //EX-SGG-WMS 280819
                            //                   IF NOT RstLinRecepAlm.GET(lRstTMPCE.codigoOrdenEntrada, lnLinea) THEN BEGIN //EX-SGG-WNS 280819 IF
                            //                       lError := TRUE;
                            //                       lDescError += ':No se encuentra la línea ' + lRstTMPCE.lineaOrdenEntrada + ' en la recepción de almacén NAV';
                            //                   END
                            //                   ELSE BEGIN
                            //                       ObtenerCodigoArticuloERP(lRstTMPCE.codigoArticuloERP, lCodProd, lCodVarProd);
                            //                       IF (lCodProd <> RstLinRecepAlm."Item No.") OR (lCodVarProd <> RstLinRecepAlm."Variant Code") THEN BEGIN
                            //                           lError := TRUE;
                            //                           lDescError += ':Código producto y variante en ' + lRstTMPCE.lineaOrdenEntrada +
                            //                             ' no coincide con la indicada en el documento NAV';
                            //                       END
                            //                       ELSE //FIN EX-SGG-WMS 280819
                            //                           CompruebaCantidadSEGAvsNAV(lRstTMPCE.Cantidad, RstLinRecepAlm.Quantity, FORMAT(lRstControlWMS.Interface),
                            //                            lRstControlWMS."No. documento", lRstTMPCE.TABLENAME, lRstTMPCE.lineaOrdenEntrada,
                            //                            RstLinRecepAlm.TABLENAME, FORMAT(RstLinRecepAlm."Line No."), 'Cantidad en ',
                            //                            lError, lDescError); //EX-SGG-WMS 200619
                            //                   END;

                            //                   IF (RstLinRecepAlm."Location Code" <> '') AND (NOT lError) THEN BEGIN
                            //                       RstAlmacen.GET(RstLinRecepAlm."Location Code");
                            //                       IF FORMAT(lRstTMPCE.estadoCalidad) <> RstAlmacen."Estado Calidad SEGA" THEN BEGIN
                            //                           lError := TRUE;
                            //                           lDescError += ':estadoCalidad ' + lRstTMPCE.TABLENAME + '(' + FORMAT(lRstTMPCE.estadoCalidad) + ') ' +
                            //                            'no debe ser distinto que en ' + RstLinRecepAlm.TABLENAME + '(' + FORMAT(RstLinRecepAlm."Location Code") + ')';
                            //                       END;
                            //                   END;

                            //                   IF NOT lError THEN BEGIN
                            //                       lRstTMPLinRecepAlm.TRANSFERFIELDS(RstLinRecepAlm);
                            //                       lRstTMPLinRecepAlm.Quantity := lRstTMPCE.Cantidad;
                            //                       lRstTMPLinRecepAlm.INSERT(TRUE);
                            //                   END;
                            //               UNTIL (lRstTMPCE.NEXT = 0) OR lError;

                            //           RstLinRecepAlm.RESET;
                            //           RstLinRecepAlm.SETRANGE("No.", lRstControlWMS."No. documento");
                            //           IF RstLinRecepAlm.FINDSET AND (NOT lError) THEN BEGIN
                            //               REPEAT
                            //                   IF lRstTMPLinRecepAlm.GET(RstLinRecepAlm."No.", RstLinRecepAlm."Line No.") THEN BEGIN
                            //                       RstLinRecepAlm.VALIDATE(Quantity, lRstTMPLinRecepAlm.Quantity);
                            //                       RstLinRecepAlm.VALIDATE("Qty. to Receive", RstLinRecepAlm.Quantity); //EX-SGG-WMS 181119
                            //                                                                                            //RstLinRecepAlm.MODIFY(TRUE);
                            //                       RstLinRecepAlm.MODIFY; //EX-SGG-WMS 030919
                            //                   END
                            //                   ELSE BEGIN
                            //                       RstOE.SETFILTER(lineaOrdenEntrada, FORMAT(RstLinRecepAlm."Line No.")); //EX-SGG-WMS 020719
                            //                       IF RstOE.FINDFIRST THEN //EX-SGG-WMS 020719
                            //                           RstLinRecepAlm.DELETE(TRUE);
                            //                   END;
                            //               UNTIL RstLinRecepAlm.NEXT = 0;

                            //               //EX-SGG-WMS 130919
                            //               RstCabRecepAlm.GET(RstLinRecepAlm."No.");
                            //               RstCabRecepAlm.VALIDATE("Posting Date", lRstTMPCE.fecha);
                            //               RstCabRecepAlm.MODIFY;
                            //               //FIN EX-SGG-WMS 130919

                            //               COMMIT; //EX-SGG 290819
                            //               IF (RstConfAlm."Mensajes CE" = RstConfAlm."Mensajes CE"::"Obtener-procesar y registrar") OR
                            //                GUIALLOWED THEN //EX-SGG-WMS 170919
                            //                 BEGIN
                            //                   CLEAR(lCduRegRecep);
                            //                   IF NOT lCduRegRecep.RUN(RstLinRecepAlm) THEN BEGIN
                            //                       lError := TRUE;
                            //                       lDescError := COPYSTR(GETLASTERRORTEXT, 1, MAXSTRLEN(lDescError));
                            //                       CLEARLASTERROR;
                            //                   END;
                            //               END;
                            //           END;
                            //       END;

                            //       IF lError THEN BEGIN
                            //           InsertarRegistroLOG(lRstControlWMS, FALSE, lDescError);
                            //           lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Error);
                            //           lRstControlWMS.MODIFY(TRUE);
                            //       END
                            //       ELSE  //EX-SGG-WMS 170919
                            //        BEGIN
                            //           lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Integrado);
                            //           lRstControlWMS.VALIDATE("Fecha y hora procesado", CURRENTDATETIME);
                            //           lRstControlWMS.MODIFY(TRUE);
                            //       END;
                            //   END; //EX-SGG-WMS 071119
                        END;
                    lRstControlWMS.Interface::"CS-Confirmacion de Salida": //EX-SGG-WMS 200619
                        BEGIN
                            //   RstCS.RESET;
                            //   RstCS.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP); //EX-SGG-WMS 120919
                            //   RstCS.SETRANGE(identificadorExpedicion, lRstControlWMS."Id. SEGA");
                            //   RstCS.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                            //   RstCS.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA");
                            //   RstCS.SETRANGE(finCodigoEntregaERP, TRUE); //EX-SGG-WMS 071119
                            //   IF RstCS.FINDFIRST THEN //EX-SGG-WMS 071119
                            //    BEGIN //EX-SGG-WMS 071119
                            //       RstCS.SETRANGE(finCodigoEntregaERP); //EX-SGG-WMS 071119
                            //                                            //EX-SGG-WMS 020719
                            //       RstPE.RESET;
                            //       RstPE.SETCURRENTKEY(codigoEntregaERP);
                            //       RstPE.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                            //       //FIN EX-SGG-WMS 020719
                            //       //EX-SGG-WMS 120919

                            //       CLEAR(lError);
                            //       lDescError := FORMAT(lRstControlWMS.Interface::"CS-Confirmacion de Salida") +
                            //        ' ' + lRstControlWMS."No. documento";
                            //       IF NOT RstPE.FINDFIRST THEN BEGIN
                            //           lError := TRUE;
                            //           lDescError += ':No se encuentra el envío de almacén NAV';
                            //       END
                            //       ELSE BEGIN
                            //           //EX-SGG 020620
                            //           RstCS.SETRANGE(lineaEntregaERP, 'SINLINEA');
                            //           lCSSinNumLinea := RstCS.COUNT > 0;
                            //           IF lCSSinNumLinea THEN BEGIN
                            //               RstCS.FINDSET;
                            //               RstLinEnvAlm.SETRANGE("No.", RstCS.codigoEntregaERP);
                            //               REPEAT
                            //                   lRstTMPCS.TRANSFERFIELDS(RstCS);
                            //                   lRstTMPCS.INSERT;
                            //                   ObtenerCodigoArticuloERP(RstCS.codigoArticuloERP, lCodProd, lCodVarProd);
                            //                   RstLinEnvAlm.SETRANGE("Item No.", lCodProd);
                            //                   RstLinEnvAlm.SETRANGE("Variant Code", lCodVarProd);
                            //                   IF RstLinEnvAlm.FINDFIRST THEN BEGIN
                            //                       lRstTMPCS.lineaEntregaERP := FORMAT(RstLinEnvAlm."Line No.");
                            //                       lRstTMPCS.MODIFY;
                            //                   END
                            //                   ELSE BEGIN
                            //                       lError := TRUE;
                            //                       lDescError += ':No se encuentra línea envío almacén para el producto ' + RstCS.codigoArticuloERP;
                            //                   END;
                            //               UNTIL (RstCS.NEXT = 0) OR lError;

                            //               IF NOT lError THEN BEGIN
                            //                   lRstTMPCS.FINDSET;
                            //                   REPEAT
                            //                       RstCS.GET(lRstTMPCS."No. registro");
                            //                       RstCS.lineaEntregaERP := lRstTMPCS.lineaEntregaERP;
                            //                       RstCS.MODIFY;
                            //                   UNTIL lRstTMPCS.NEXT = 0;
                            //               END;
                            //               lRstTMPCS.DELETEALL;
                            //           END;
                            //           RstCS.SETRANGE(lineaEntregaERP);

                            //           IF NOT lError THEN
                            //               //FIN EX-SGG 020620
                            //               CrearEmbalajesEDIdesdeCS(lError, lDescError);
                            //       END;
                            //       //FIN EX-SGG-WMS 120919
                            //       IF NOT lError THEN BEGIN
                            //           AgruparRegistrosCS(lRstControlWMS, lRstTMPCS, lError, lDescError);//EX-SGG-WMS 120919
                            //           lRstTMPLinEnvAlm.RESET;
                            //           lRstTMPLinEnvAlm.DELETEALL;
                            //           //IF RstCS.FINDSET THEN
                            //           lRstTMPCS.RESET;
                            //           IF (lRstTMPCS.FINDSET) AND (NOT lError) THEN //EX-SGG-WMS 120919 TEMPORAL AGRUPADA
                            //               REPEAT

                            //                   IF EVALUATE(lnLinea, lRstTMPCS.lineaEntregaERP) THEN; //EX-SGG-WMS 120919
                            //                   IF NOT RstLinEnvAlm.GET(lRstTMPCS.codigoEntregaERP, lnLinea) THEN //EX-SGG-WMS 120919 IF
                            //                    BEGIN
                            //                       lError := TRUE;
                            //                       lDescError += ':No se encuentra la línea ' + lRstTMPCS.lineaEntregaERP + ' en el envío de almacén NAV';
                            //                   END
                            //                   ELSE BEGIN
                            //                       ObtenerCodigoArticuloERP(lRstTMPCS.codigoArticuloERP, lCodProd, lCodVarProd);
                            //                       IF (lCodProd <> RstLinEnvAlm."Item No.") OR (lCodVarProd <> RstLinEnvAlm."Variant Code") THEN BEGIN
                            //                           lError := TRUE;
                            //                           lDescError += ':Código producto y variante en ' + lRstTMPCS.lineaEntregaERP +
                            //                             ' no coincide con la indicada en el documento NAV';
                            //                       END
                            //                       ELSE //FIN EX-SGG-WMS 120919
                            //                           CompruebaCantidadSEGAvsNAV(lRstTMPCS.cantidad, RstLinEnvAlm.Quantity, FORMAT(lRstControlWMS.Interface),
                            //                            lRstControlWMS."No. documento", lRstTMPCS.TABLENAME, lRstTMPCS.lineaEntregaERP,
                            //                            RstLinEnvAlm.TABLENAME, FORMAT(RstLinEnvAlm."Line No."), 'Cantidad en ', lError, lDescError);
                            //                   END;
                            //                   IF NOT lError THEN BEGIN
                            //                       lRstTMPLinEnvAlm.TRANSFERFIELDS(RstLinEnvAlm);
                            //                       lRstTMPLinEnvAlm.Quantity := lRstTMPCS.cantidad;
                            //                       lRstTMPLinEnvAlm.INSERT(TRUE);
                            //                   END;
                            //               UNTIL (lRstTMPCS.NEXT = 0) OR lError;

                            //           RstLinEnvAlm.RESET;
                            //           RstLinEnvAlm.SETRANGE("No.", lRstControlWMS."No. documento");
                            //           IF RstLinEnvAlm.FINDSET AND (NOT lError) THEN BEGIN

                            //               //EX-CV  -  2021 12 14
                            //               REPEAT
                            //                   lisConsig := FALSE;
                            //                   globalSourceNo := RstLinEnvAlm."Source No.";
                            //                   recTransferHeader.RESET;
                            //                   recTransferHeader.SETRANGE("No.", RstLinEnvAlm."Source No.");
                            //                   IF recTransferHeader.FINDFIRST THEN BEGIN
                            //                       recSalesHeader.RESET;
                            //                       recSalesHeader.SETRANGE("Document Type", recSalesHeader."Document Type"::Order);
                            //                       recSalesHeader.SETRANGE("No.", recTransferHeader."No. pedido venta");
                            //                       recSalesHeader.SETRANGE("Ventas en consignacion", TRUE);
                            //                       IF recSalesHeader.FINDFIRST THEN
                            //                           lisConsig := TRUE;
                            //                   END;

                            //                   RstLinEnvAlm.SaltarComprobacionEnviadoASEGA(TRUE); //EX-SGG-WMS 170919
                            //                   IF lRstTMPLinEnvAlm.GET(RstLinEnvAlm."No.", RstLinEnvAlm."Line No.") THEN BEGIN
                            //                       RstLinEnvAlm.PfsSetSuspendStatusCheck(TRUE); //EX-SGG-WMS 130919
                            //                                                                    //RstLinEnvAlm.VALIDATE(Quantity,lRstTMPLinEnvAlm.Quantity); EX-CV  -  JX  -  2021 12 23
                            //                       IF NOT lisConsig THEN RstLinEnvAlm.VALIDATE(Quantity, lRstTMPLinEnvAlm.Quantity);
                            //                       RstLinEnvAlm.VALIDATE("Qty. to Ship", lRstTMPLinEnvAlm.Quantity); //EX-SGG-WMS 130919
                            //                       RstLinEnvAlm.MODIFY(TRUE);
                            //                   END ELSE BEGIN
                            //                       IF NOT lisConsig THEN BEGIN
                            //                           RstPE.SETFILTER(lineaEntregaERP, FORMAT(RstLinEnvAlm."Line No.")); //EX-SGG-WMS 020719
                            //                           IF (RstPE.FINDFIRST) OR lCSSinNumLinea THEN BEGIN//EX-SGG-WMS 020719 040620
                            //                               RstLinEnvAlm.PfsSetSuspendDeleteCheck(TRUE); //EX-SGG-WMS 011019
                            //                               RstLinEnvAlm.DELETE(TRUE);
                            //                           END;
                            //                       END;
                            //                   END;
                            //               UNTIL RstLinEnvAlm.NEXT = 0;
                            //               //EX-CV END

                            //               //EX-SGG-WMS 130919
                            //               RstCabEnvAlm.GET(RstLinEnvAlm."No.");
                            //               RstCabEnvAlm.VALIDATE("Posting Date", lRstTMPCS.fecha);
                            //               RstCabEnvAlm.MODIFY;
                            //               //FIN EX-SGG-WMS 130919

                            //               COMMIT; //EX-SGG 290819
                            //               IF (RstConfAlm."Mensajes CS" = RstConfAlm."Mensajes CS"::"Obtener-procesar y registrar") OR
                            //                GUIALLOWED THEN //EX-SGG-WMS 170919
                            //                 BEGIN
                            //                   CLEAR(lCduRegEnv);
                            //                   //EX-SGG-WMS 040919
                            //                   lCduRegEnv.SetPostingSettings(FALSE);
                            //                   lCduRegEnv.SetPrint(FALSE);
                            //                   //FIN EX-SGG-WMS 040919
                            //                   IF NOT lCduRegEnv.RUN(RstLinEnvAlm) THEN BEGIN
                            //                       lError := TRUE;
                            //                       lDescError := COPYSTR(GETLASTERRORTEXT, 1, MAXSTRLEN(lDescError));
                            //                       CLEARLASTERROR;
                            //                   END;

                            //                   //EX-CV  -  2021 12 14
                            //                   UpdateSLCantPendNoAnul();
                            //                   //EX-CV  -  2021 12 14 END
                            //               END;
                            //           END;
                            //       END;

                            //       IF lError THEN BEGIN
                            //           InsertarRegistroLOG(lRstControlWMS, FALSE, lDescError);
                            //           lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Error);
                            //           lRstControlWMS.MODIFY(TRUE);
                            //       END
                            //       ELSE //EX-SGG-WMS 170919
                            //        BEGIN
                            //           lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Integrado);
                            //           lRstControlWMS.VALIDATE("Fecha y hora procesado", CURRENTDATETIME);
                            //           lRstControlWMS.MODIFY(TRUE);
                            //       END;
                            //  END; //EX-SGG-WMS 071119
                        END;
                    lRstControlWMS.Interface::"AS-Ajuste de Stock": //EX-SGG-WMS 260619
                        BEGIN
                            //   CLEAR(lAlgunError); //EX-SGG-WMS 040719
                            //   RstAS.RESET;
                            //   RstAS.SETCURRENTKEY(numeroMensaje, motivoAjuste); //EX-SGG-WMS 040719
                            //   RstAS.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA"); //EX-SGG-WNS 040719
                            //   RstAS.SETFILTER(motivoAjuste, '<>28&<>26');  //EX-SGG-WMS 010719
                            //   RstAS.SETRANGE(Integrado, FALSE); //EX-SGG-WNS 040719
                            //   IF RstAS.FINDSET THEN
                            //       REPEAT
                            //           CLEAR(lError);
                            //           ComprobacionesPreviasASySA(lRstLinDia, lRstControlWMS, RstAS.estadoCalidad, RstAS.claseStock, RstAS.codigoArticuloERP,
                            //            RstAS.cantidad, lCantidadNAV, lCodProd, lCodVarProd, lCodAlmPpal, lFiltroAlmacen, lError, lDescError); //EX-SGG-WNS 040719

                            //           IF NOT lError THEN BEGIN
                            //               lnLinea := 10000;
                            //               lRstLinDia.VALIDATE("Journal Template Name", RstConfAlm."Libro Diario Producto");
                            //               lRstLinDia.VALIDATE("Journal Batch Name", RstConfAlm."Seccion Diario Producto");
                            //               lRstLinDia.VALIDATE("Line No.", lnLinea);
                            //               lRstLinDia.SetUpNewLine(lRstLinDia); //EX-SGG-WMS 290819
                            //               lRstLinDia.INSERT(TRUE);
                            //               lnLinea += 10000;
                            //               IF RstAS.cantidad < 0 THEN
                            //                   lRstLinDia.VALIDATE("Entry Type", lRstLinDia."Entry Type"::"Negative Adjmt.")
                            //               ELSE
                            //                   lRstLinDia.VALIDATE("Entry Type", lRstLinDia."Entry Type"::"Positive Adjmt.");
                            //               lRstLinDia.VALIDATE("Posting Date", RstAS.fecha);
                            //               lRstLinDia.VALIDATE("Item No.", lCodProd);
                            //               lRstLinDia.VALIDATE("Variant Code", lCodVarProd);
                            //               lRstLinDia.VALIDATE(Description, COPYSTR(lRstLinDia.Description + ' ' + RstAS.observaciones,
                            //                 1, MAXSTRLEN(lRstLinDia.Description)));
                            //               //RstAS.codigoOrdenEntrada //EX-SGG-WMS 220719 NO SE HACE NADA.
                            //               lRstLinDia.VALIDATE("Location Code", lCodAlmPpal);
                            //               lRstLinDia.VALIDATE("Document No.", COPYSTR(RstAS.numeroMensaje, 1,
                            //                MAXSTRLEN(lRstLinDia."Document No."))); //EX-SGG-WMS 281019
                            //               lRstLinDia.MODIFY(TRUE);
                            //               //EX-SGG-WMS 280619
                            //               lCantidadSEGA := RstAS.cantidad;
                            //               IF lCantidadSEGA > 0 THEN BEGIN
                            //                   lRstLinDia.VALIDATE(Quantity, ABS(lCantidadSEGA));
                            //                   lRstLinDia.MODIFY(TRUE);
                            //               END
                            //               ELSE BEGIN
                            //                   RstProd.RESET;
                            //                   RstProd.GET(lRstLinDia."Item No.");
                            //                   RstProd.SETRANGE("Variant Filter", lRstLinDia."Variant Code");
                            //                   RstProd.SETRANGE("Location Filter", lCodAlmPpal);
                            //                   RstProd.CALCFIELDS(Inventory);
                            //                   IF RstProd.Inventory > ABS(lCantidadSEGA) THEN BEGIN
                            //                       lRstLinDia.VALIDATE(Quantity, ABS(lCantidadSEGA));
                            //                       lRstLinDia.MODIFY(TRUE);
                            //                       lCantidadSEGA := 0;
                            //                   END
                            //                   ELSE
                            //                       IF RstProd.Inventory > 0 THEN BEGIN
                            //                           lRstLinDia.VALIDATE(Quantity, RstProd.Inventory);
                            //                           lRstLinDia.MODIFY(TRUE);
                            //                           lCantidadSEGA += RstProd.Inventory;
                            //                       END;

                            //                   IF lCantidadSEGA < 0 THEN BEGIN
                            //                       RstAlmacen.RESET;
                            //                       RstAlmacen.SETFILTER(Code, lFiltroAlmacen);
                            //                       RstAlmacen.SETRANGE("Almacen principal SEGA", FALSE);
                            //                       IF RstAlmacen.FINDSET THEN
                            //                           REPEAT
                            //                               RstProd.SETRANGE("Location Filter", RstAlmacen.Code);
                            //                               RstProd.CALCFIELDS(Inventory);
                            //                               IF RstProd.Inventory > ABS(lCantidadSEGA) THEN BEGIN
                            //                                   IF lRstLinDia.Quantity <> 0 THEN BEGIN
                            //                                       lRstLinDia."Line No." := lnLinea;
                            //                                       lRstLinDia.INSERT(TRUE);
                            //                                       lnLinea += 10000;
                            //                                   END;
                            //                                   lRstLinDia.VALIDATE("Location Code", RstAlmacen.Code);
                            //                                   lRstLinDia.VALIDATE(Quantity, ABS(lCantidadSEGA));
                            //                                   lRstLinDia.MODIFY(TRUE);
                            //                                   lCantidadSEGA := 0;
                            //                               END
                            //                               ELSE
                            //                                   IF RstProd.Inventory > 0 THEN BEGIN
                            //                                       IF lRstLinDia.Quantity <> 0 THEN BEGIN
                            //                                           lRstLinDia."Line No." := lnLinea;
                            //                                           lRstLinDia.INSERT(TRUE);
                            //                                           lnLinea += 10000;
                            //                                       END;
                            //                                       lRstLinDia.VALIDATE("Location Code", RstAlmacen.Code);
                            //                                       lRstLinDia.VALIDATE(Quantity, RstProd.Inventory);
                            //                                       lRstLinDia.MODIFY(TRUE);
                            //                                       lCantidadSEGA += RstProd.Inventory;
                            //                                   END;
                            //                           UNTIL (RstAlmacen.NEXT = 0) OR (lCantidadSEGA = 0);
                            //                   END;
                            //               END;
                            //               //FIN EX-SGG-WMS 280619

                            //           END;

                            //           //EX-SGG-WMS 040719
                            //           IntentaRegDiarioProductoASySA(lRstLinDia, lRstControlWMS, RstAS.identificadorAjuste,
                            //            RstAS.Integrado, lAlgunError, lError, lDescError);
                            //           RstAS.MODIFY(TRUE);

                            //           COMMIT;
                            //       //FIN EX-SGG-WMS 040719

                            //       UNTIL RstAS.NEXT = 0;

                            //EX-SGG-WMS 010719 DEVOLUCIONES COMPRAS. 040620 observaciones=No. devol. SIN "DEV".
                            RstAS.SETRANGE(motivoAjuste, 26);
                            IF RstAS.FINDSET THEN
                             //EX-SGG-WMS 040620
                             BEGIN
                                CLEAR(lError);
                                AgruparRegistrosASDevolCompras(lRstControlWMS, lRstTMPAS, lRstTMPCabCompra, lError, lDescError);
                                IF NOT lError THEN BEGIN
                                    lRstTMPAS.RESET;
                                    IF lRstTMPCabCompra.FINDSET THEN
                                        REPEAT
                                            CLEAR(lError);
                                            lDescError := FORMAT(lRstControlWMS.Interface::"AS-Ajuste de Stock") +
                                             ' ' + lRstControlWMS."No. documento";
                                            IF RstCabCompra.GET(lRstTMPCabCompra."Document Type", lRstTMPCabCompra."No.") THEN BEGIN
                                                CLEAR(lCduLanzarPedCompra); //EX-SGG 170720
                                                lCduLanzarPedCompra.PerformManualReopen(RstCabCompra); //EX-SGG 170720
                                                RstLinCompra.RESET;
                                                RstLinCompra.SETRANGE("Document Type", RstCabCompra."Document Type");
                                                RstLinCompra.SETRANGE("Document No.", RstCabCompra."No.");
                                                If RstLinCompra.FindFirst() then begin
                                                    lError := TRUE;
                                                    lDescError += ':Hay líneas en la devolución ' + RstCabCompra."No.";
                                                end else begin
                                                    lnlinea := 0;
                                                    //RstLinCompra.SETRANGE(Type, RstLinCompra.Type::Item);
                                                    lRstTMPAS.SETRANGE(observaciones, RstCabCompra."No.");
                                                    lRstTMPAS.FINDSET;
                                                    REPEAT
                                                        ObtenerCodigoArticuloERP(lRstTMPAS.codigoArticuloERP, lCodProd, lCodVarProd);
                                                        RstLinCompra.Init();
                                                        RstLinCompra."Document Type" := RstCabCompra."Document Type";
                                                        RstLinCompra."Document No." := RstCabCompra."No.";
                                                        lnLinea += 10000;
                                                        RstLinCompra."Line No." := lnLinea;
                                                        RstLinCompra.Insert(true);
                                                        RstLinCompra.Type := RstLinCompra.Type::Item;
                                                        RstLinCompra.Validate("No.", lCodProd);
                                                        If lCodVarProd <> '' Then
                                                            RstLinCompra.Validate("Variant Code", lCodVarProd);
                                                        RstLinCompra.VALIDATE(Quantity, lRstTMPAS.cantidad);
                                                        RstLinCompra.VALIDATE("Return Qty. to Ship", lRstTMPAS.cantidad);
                                                        RstLinCompra.MODIFY(TRUE);

                                                    UNTIL (lRstTMPAS.NEXT = 0) OR lError;

                                                    lCduLanzarPedCompra.PerformManualRelease(RstCabCompra); //EX-SGG 170720
                                                end;
                                                //EX-SGG-WMS 300620
                                                IF NOT lError THEN BEGIN
                                                    RstLinCompra.SETRANGE("No.");
                                                    RstLinCompra.SETRANGE("Variant Code");
                                                    IF RstLinCompra.FINDSET THEN
                                                        REPEAT
                                                            lRstTMPAS.SETRANGE(codigoArticuloERP,
                                                             DevuelveCodigoArticuloERP(RstLinCompra."No.", RstLinCompra."Variant Code"));
                                                            IF NOT lRstTMPAS.FINDFIRST THEN
                                                                RstLinCompra.DELETE(TRUE);
                                                        UNTIL RstLinCompra.NEXT = 0;
                                                    lRstTMPAS.SETRANGE(codigoArticuloERP);
                                                    lRstTMPAS.FINDFIRST;
                                                    RstCabCompra.VALIDATE("Posting Date", lRstTMPAS.fecha);
                                                    RstCabCompra.MODIFY;
                                                    COMMIT;
                                                END;
                                                //FIN EX-SGG-WMS 300620

                                                IF NOT lError THEN BEGIN
                                                    IF (RstConfAlm."Mensajes AS" = RstConfAlm."Mensajes AS"::"Obtener-procesar y registrar") OR
                                                      GUIALLOWED THEN BEGIN
                                                        CLEAR(lCduRegCompra);
                                                        RstCabCompra.Invoice := FALSE;
                                                        RstCabCompra.Ship := TRUE;
                                                        IF NOT lCduRegCompra.RUN(RstCabCompra) THEN BEGIN
                                                            lError := TRUE;
                                                            lDescError := COPYSTR(GETLASTERRORTEXT, 1, MAXSTRLEN(lDescError));
                                                            CLEARLASTERROR;
                                                        END;
                                                    END;

                                                    IF NOT lError THEN BEGIN
                                                        RstAS.SETRANGE(observaciones, RstCabCompra."No.");
                                                        RstAS.MODIFYALL(Integrado, TRUE);
                                                        RstAS.SETRANGE(observaciones);
                                                    END;
                                                END;

                                                IF lError THEN BEGIN
                                                    lAlgunError := TRUE;
                                                    InsertarRegistroLOG(lRstControlWMS, FALSE, lDescError);
                                                END;
                                            END
                                            ELSE BEGIN
                                                lAlgunError := TRUE;
                                                InsertarRegistroLOG(lRstControlWMS, FALSE,
                                                 lDescError + ':No se encuentra la devolución de compra ' + lRstTMPCabCompra."No.");
                                            END;
                                        UNTIL lRstTMPCabCompra.NEXT = 0;
                                END
                                ELSE
                                    lAlgunError := TRUE;
                            END;
                            //FIN EX-SGG-WMS 040620

                            //EX-SGG-WMS 040719
                            IF lAlgunError THEN
                                lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Error)
                            ELSE
                                lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Integrado);
                            lRstControlWMS.VALIDATE("Fecha y hora procesado", CURRENTDATETIME);
                            lRstControlWMS.MODIFY(TRUE);
                            //FIN EX-SGG-WMS 040719

                        END;
                    lRstControlWMS.Interface::"SA-Stock Actual":  //EX-SGG-WMS 270619
                        BEGIN                                        //TO-DO PRODUCTOS SEGA QUE NO VENGAN INFORMADOS, DEJAR CON STOCK A 0
                            // CLEAR(lAlgunError); //EX-SGG-WMS 040719
                            // RstSA.RESET;
                            // RstSA.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA"); //EX-SGG-WNS 040719
                            // RstSA.SETRANGE(Integrado, FALSE); //EX-SGG-WNS 040719
                            // IF RstSA.FINDSET THEN BEGIN
                            //     //EX-SGG-WMS 271119
                            //     lRstLinDia.RESET;
                            //     lRstLinDia.SETRANGE("Journal Template Name", RstConfAlm."Libro Diario Inventario");
                            //     lRstLinDia.SETRANGE("Journal Batch Name", RstConfAlm."Seccion Diario Inventario");
                            //     lRstLinDia.DELETEALL(TRUE);
                            //     COMMIT;
                            //     //FIN EX-SGG-WMS 271119
                            //     REPEAT
                            //         CLEAR(lError);
                            //         ComprobacionesPreviasASySA(lRstLinDia, lRstControlWMS, RstSA.estadoCalidad, RstSA.claseStock, RstSA.codigoArticuloERP,
                            //          RstSA.cantidad, lCantidadNAV, lCodProd, lCodVarProd, lCodAlmPpal, lFiltroAlmacen, lError, lDescError); //EX-SGG-WNS 040719

                            //         IF NOT lError THEN //EX-SGG-WMS 030719
                            //             CompruebaNoIntegradosPreviosSA(lCodProd, lCodVarProd, RstSA.fecha, RstSA.identificadorStock, lError, lDescError);

                            //         IF NOT lError THEN BEGIN
                            //             RstProd.RESET;
                            //             RstProd.SETRANGE("No.", lCodProd);
                            //             //RstProd.SETRANGE("Location Filter",lFiltroAlmacen); //EX-SGG-WMS 280619
                            //             RstProd.SETFILTER("Location Filter", lFiltroAlmacen); //EX-SGG-WMS 301019
                            //             RstProd.SETRANGE("Variant Filter", lCodVarProd);
                            //             CLEAR(lRptCalcInv);
                            //             lRstLinDia.VALIDATE("Journal Template Name", RstConfAlm."Libro Diario Inventario");
                            //             lRstLinDia.VALIDATE("Journal Batch Name", RstConfAlm."Seccion Diario Inventario");
                            //             lRptCalcInv.SetItemJnlLine(lRstLinDia);
                            //             lRptCalcInv.PfsSetFromPhysJournal(TRUE);
                            //             //lRptCalcInv.InitializeRequest(RstSA.fecha,'',FALSE);
                            //             lRptCalcInv.InitializeRequest(RstSA.fecha, '', TRUE); //EX-SGG-WMS 191219
                            //             lRptCalcInv.ValidatePostingDate;
                            //             lRptCalcInv.SetHideValidationDialog(TRUE); //EX-SGG-WMS 311019
                            //             lRptCalcInv.USEREQUESTFORM(FALSE);
                            //             lRptCalcInv.SETTABLEVIEW(RstProd);
                            //             lRptCalcInv.RUN;
                            //             //EX-SGG-WMS 280619
                            //             lCantidadSEGA := RstSA.cantidad;
                            //             lRstLinDia.SETRANGE("Item No.", lCodProd);
                            //             lRstLinDia.SETRANGE("Variant Code", lCodVarProd);
                            //             lRstLinDia.SETRANGE("Location Code", lCodAlmPpal); //EX-SGG-WMS 191219
                            //             IF NOT lRstLinDia.FINDSET THEN BEGIN
                            //                 //EX-SGG-WMS 191219 COMENTO E INSERTO LIN ALM PPAL


                            //                 CLEAR(lIntAux);
                            //                 CLEAR(lCodAux);
                            //                 CLEAR(lDecAux);
                            //                 lRstLinDia.VALIDATE("Journal Template Name", RstConfAlm."Libro Diario Inventario");
                            //                 lRstLinDia.VALIDATE("Journal Batch Name", RstConfAlm."Seccion Diario Inventario");
                            //                 lRptCalcInv.SetItemJnlLine(lRstLinDia);
                            //                 lRptCalcInv.GetLocation(lCodAlmPpal);
                            //                 lRptCalcInv.InitializeRequest(RstSA.fecha, '', TRUE); //EX-SGG 060520
                            //                 lRptCalcInv.ValidatePostingDate; //EX-SGG 060520
                            //                 lRptCalcInv.InsertItemJnlLine(lCodProd, lCodVarProd, lIntAux, lCodAux, lCodAux, lDecAux, 0);
                            //                 //FIN EX-SGG-WMS 191219
                            //             END
                            //             ;//ELSE //EX-SGG-WMS 191219 COMENTO SIN ELSE
                            //              //BEGIN //EX-SGG-WMS 191219 COMENTO
                            //              //lRstLinDia.SETRANGE("Location Code"); //EX-SGG-WMS 191219 231219 COMENTO.
                            //             lRstLinDia.SETFILTER("Location Code", lFiltroAlmacen); //EX-SGG-WMS 231219
                            //             lRstLinDia.FINDSET; //EX-SGG-WMS 191219
                            //             CLEAR(lCantidadNAV);
                            //             REPEAT
                            //                 lCantidadNAV += lRstLinDia."Qty. (Calculated)";
                            //             UNTIL lRstLinDia.NEXT = 0;
                            //             lCantidadDif := lCantidadSEGA - lCantidadNAV;
                            //             IF lCantidadDif <> 0 THEN BEGIN
                            //                 lRstLinDia.SETRANGE("Location Code", lCodAlmPpal);
                            //                 IF lRstLinDia.FINDFIRST THEN BEGIN
                            //                     IF lCantidadDif > 0 THEN BEGIN
                            //                         //lRstLinDia.VALIDATE("Qty. (Phys. Inventory)",lCantidadSEGA);  //EX-SGG-WMS 240120 COMENTO.
                            //                         lRstLinDia.VALIDATE("Qty. (Phys. Inventory)", lRstLinDia."Qty. (Calculated)" + lCantidadDif); //EX-SGG-WMS 240120
                            //                         lCantidadDif := 0;
                            //                         lRstLinDia.MODIFY(TRUE);
                            //                     END
                            //                     ELSE BEGIN
                            //                         IF lRstLinDia."Qty. (Calculated)" < ABS(lCantidadDif) THEN
                            //                             lRstLinDia.VALIDATE("Qty. (Phys. Inventory)", 0)
                            //                         ELSE
                            //                             lRstLinDia.VALIDATE("Qty. (Phys. Inventory)", lRstLinDia."Qty. (Calculated)" + lCantidadDif);
                            //                         lRstLinDia.MODIFY(TRUE);
                            //                         //lCantidadDif+=lRstLinDia."Qty. (Calculated)";
                            //                         lCantidadDif += lRstLinDia.Quantity; //EX-SGG-WMS 191219
                            //                     END;
                            //                 END;

                            //                 IF lCantidadDif < 0 THEN BEGIN
                            //                     //lRstLinDia.SETFILTER("Location Code",'<>'+lCodAlmPpal); //EX-SGG-WMS 231219 COMENTO.
                            //                     lRstLinDia.SETFILTER("Location Code", '<>' + lCodAlmPpal + '&' + lFiltroAlmacen); //EX-SGG-WMS 231219
                            //                     IF lRstLinDia.FINDSET THEN
                            //                         REPEAT
                            //                             IF lRstLinDia."Qty. (Calculated)" < ABS(lCantidadDif) THEN
                            //                                 lRstLinDia.VALIDATE("Qty. (Phys. Inventory)", 0)
                            //                             ELSE
                            //                                 lRstLinDia.VALIDATE("Qty. (Phys. Inventory)", lRstLinDia."Qty. (Calculated)" + lCantidadDif);
                            //                             lRstLinDia.MODIFY(TRUE);
                            //                             //lCantidadDif+=lRstLinDia."Qty. (Calculated)";
                            //                             lCantidadDif += lRstLinDia.Quantity; //EX-SGG-WMS 191219
                            //                         UNTIL (lRstLinDia.NEXT = 0) OR (lCantidadDif = 0);
                            //                 END;

                            //             END;
                            //             //END; //EX-SGG-WMS 191219 COMENTO

                            //             IF (lCantidadDif <> 0) AND (NOT lError) THEN BEGIN
                            //                 lError := TRUE;
                            //                 lDescError := FORMAT(lRstControlWMS.Interface) +
                            //                  ': No ha sido posible asignar toda la cantidad SEGA al inventario para el producto' +
                            //                  lCodProd + ' variante ' + lCodVarProd;
                            //                 lRstLinDia.SETRANGE("Location Code"); //EX-SGG-WMS 271119
                            //                 lRstLinDia.DELETEALL(TRUE); //EX-SGG-WMS 271119
                            //             END;
                            //             //FIN EX-SGG-WMS 280619

                            //         END;


                            //         IF lError THEN
                            //             InsertarRegistroLOG(lRstControlWMS, FALSE, lDescError);
                            //         RstSA.Integrado := NOT lError;
                            //         //FIN EX-SGG-WMS 271119

                            //         RstSA.MODIFY(TRUE);

                            //     //COMMIT; //EX-SGG-WMS 271119 COMENTO.
                            //     //FIN EX-SGG-WMS 040719

                            //     UNTIL RstSA.NEXT = 0;
                            // END;

                            // //EX-SGG-WMS 241119
                            // CLEAR(lError);
                            // CLEAR(lDescError);
                            // lRstLinDia.RESET;
                            // lRstLinDia.SETRANGE("Journal Template Name", RstConfAlm."Libro Diario Inventario");
                            // lRstLinDia.SETRANGE("Journal Batch Name", RstConfAlm."Seccion Diario Inventario");
                            // IF NOT lRstLinDia.FINDFIRST THEN //EX-SGG-WMS 170420
                            //  BEGIN
                            //     lError := TRUE;
                            //     lDescError := FORMAT(lRstControlWMS.Interface) + ': No existen líneas para registrar en el ' +
                            //      'diario ' + RstConfAlm."Libro Diario Inventario" + ', sección ' + RstConfAlm."Seccion Diario Inventario";
                            //     InsertarRegistroLOG(lRstControlWMS, FALSE, lDescError);
                            // END
                            // ELSE //FIN EX-SGG-WMS 170420
                            //     IntentaRegDiarioProductoASySA(lRstLinDia, lRstControlWMS, lRstControlWMS."Id. SEGA",
                            //      RstSA.Integrado, lAlgunError, lError, lDescError);
                            // //FIN EX-SGG-WMS 241119

                            // //EX-SGG-WMS 040719
                            // //IF lAlgunError THEN
                            // IF lError THEN //EX-SGG-WMS 271119 NO SE CONTROL lAlgunError EN SA.
                            //     lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Error)
                            // ELSE BEGIN
                            //     lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Integrado);
                            //     DescartarRegistrosPrevios(lRstControlWMS); //EX-SGG-WMS 040220
                            // END;
                            // lRstControlWMS.VALIDATE("Fecha y hora procesado", CURRENTDATETIME);
                            // lRstControlWMS.MODIFY(TRUE);
                            // //FIN EX-SGG-WMS 040719

                        END;
                END;
                COMMIT;
            UNTIL lRstControlWMS.NEXT = 0;
        END;


    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Outbound", 'OnAfterCreateWhseShipmentHeaderFromWhseRequest', '', false, false)]
    local procedure OnAfterCreateWhseShipmentHeaderFromWhseRequest(var WarehouseRequest: Record "Warehouse Request"; var WhseShptHeader: Record "Warehouse Shipment Header")
    var
        SalesHeader: Record "Sales Header";
    begin
        If SalesHeader.Get(WarehouseRequest."Source Subtype", WarehouseRequest."Source No.") Then begin
            WhseShptHeader."Envio a Mail" := SalesHeader."Envio a Mail";
            WhseShptHeader.Modify();
        end;
    end;

    procedure VisualizarDatosRegistroControl(var lRstControlWMS: Record "Control integracion WMS")
    var
        lFrmOE: page "WMS OE-Ordenes de Entrada";
        lFrmCE: page "WMS CE-Confirmación de entrada";
        lFrmPE: page "WMS PE-Pedidos";
        lFrmCS: page "WMS CS-Confirmacion de Salidas";
        lFrmCP: Page "WMS CP-Confir. de Preparacion";
        lFrmAS: page "WMS AS-Ajuste Stock";
        lFrmSA: page "WMS SA-Stock Actual";
    begin
        //EX-SGG-WMS 120619
        CASE lRstControlWMS.Interface OF
            lRstControlWMS.Interface::"OE-Orden de Entrada":
                BEGIN
                    CLEAR(lFrmOE);
                    RstOE.RESET;
                    RstOE.SETCURRENTKEY(codigoOrdenEntrada);
                    RstOE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                    lFrmOE.SETTABLEVIEW(RstOE);
                    lFrmOE.EDITABLE(FALSE);
                    lFrmOE.RUNMODAL;
                END;
            lRstControlWMS.Interface::"PE-Pedido": //EX-WMS 130619
                BEGIN
                    CLEAR(lFrmPE);
                    RstPE.RESET;
                    RstPE.SETCURRENTKEY(codigoEntregaERP);
                    RstPE.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                    lFrmPE.SETTABLEVIEW(RstPE);
                    lFrmPE.EDITABLE(FALSE);
                    lFrmPE.RUNMODAL;
                END;
            lRstControlWMS.Interface::"CE-Confirmacion de Entrada":
                BEGIN
                    CLEAR(lFrmCE);
                    RstCE.RESET;
                    RstCE.SETCURRENTKEY(correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada); //EX-SGG 280819
                    RstCE.SETRANGE(correlativoRecepcion, lRstControlWMS."Id. SEGA");
                    RstCE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                    RstCE.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA");
                    lFrmCE.SETTABLEVIEW(RstCE);
                    lFrmCE.EDITABLE(FALSE);
                    lFrmCE.RUNMODAL;
                END;
            lRstControlWMS.Interface::"CP-Confirmacion de Preparacion": //EX-SGG 130619
                BEGIN
                    CLEAR(lFrmCS);
                    RstCP.RESET;
                    RstCP.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP); //EX-SGG-WMS 120919
                    RstCP.SETRANGE(identificadorExpedicion, lRstControlWMS."Id. SEGA");
                    RstCP.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                    RstCP.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA");
                    lFrmCP.SETTABLEVIEW(RstCP);
                    lFrmCP.EDITABLE(FALSE);
                    lFrmCP.RUNMODAL;
                END;
            lRstControlWMS.Interface::"CS-Confirmacion de Salida": //EX-SGG 130619
                BEGIN
                    CLEAR(lFrmCS);
                    RstCS.RESET;
                    RstCS.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP); //EX-SGG-WMS 120919
                    RstCS.SETRANGE(identificadorExpedicion, lRstControlWMS."Id. SEGA");
                    RstCS.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                    RstCS.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA");
                    lFrmCS.SETTABLEVIEW(RstCS);
                    lFrmCS.EDITABLE(FALSE);
                    lFrmCS.RUNMODAL;
                END;
            lRstControlWMS.Interface::"AS-Ajuste de Stock":  //EX-SGG 130619
                BEGIN
                    CLEAR(lFrmAS);
                    RstAS.RESET;
                    RstAS.SETCURRENTKEY(numeroMensaje, motivoAjuste); //EX-SGG-WMS 040719
                    RstAS.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA"); //EX-SGG-WMS 040719
                    lFrmAS.SETTABLEVIEW(RstAS);
                    lFrmAS.EDITABLE(FALSE);
                    lFrmAS.RUNMODAL;
                END;
            lRstControlWMS.Interface::"SA-Stock Actual":  //EX-SGG 130619
                BEGIN
                    CLEAR(lFrmSA);
                    RstSA.RESET;
                    RstSA.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA"); //EX-SGG-WMS 040719
                    lFrmSA.SETTABLEVIEW(RstSA);
                    lFrmSA.EDITABLE(FALSE);
                    lFrmSA.RUNMODAL;
                END;

        END;
    end;

    procedure VisualizarLOGRegistroControl(var lRstControlWMS: Record "Control integracion WMS")
    var
        lFrmLOG: page "WMS Log de errores";
    begin
        //EX-SGG-WMS 180619
        CLEAR(lFrmLOG);
        RstLOG.RESET;
        RstLOG.SETCURRENTKEY("No. registro control rel.");
        RstLOG.SETRANGE("No. registro control rel.", lRstControlWMS."No. registro");
        lFrmLOG.SETTABLEVIEW(RstLOG);
        lFrmLOG.EDITABLE(FALSE);
        lFrmLOG.RUNMODAL;
    end;



    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues_ModCompras(var PurchLine: Record "Purchase Line"; Item: Record Item; CurrentFieldNo: Integer; PurchHeader: Record "Purchase Header")
    var
        CduWMS: Codeunit "FuncionesWMS"; //CU50409
    begin
        if PurchLine."Document Type" = PurchLine."Document Type"::Order then
            if Item."Producto SEGA" then begin
                PurchLine.Validate("Location Code", CduWMS.DevuelveAlmacenPredetSEGA);
            end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnCodeOnBeforePostTransferOrder', '', true, true)]
    local procedure OnCodeOnBeforePostTransferOrder(var TransHeader: Record "Transfer Header"; var DefaultNumber: Integer; var Selection: Option; var IsHandled: Boolean; var PostBatch: Boolean; var TransferOrderPost: Enum "Transfer Order Post")
    begin
        ComprobacionesAlmacenesSEGA(TransHeader);
    end;

    procedure ComprobacionesAlmacenesSEGA(var TransHeader: Record "Transfer Header"): Boolean

    var
        RecLocation: Record Location;
        RecLocationAux: Record Location;
        RegUser: Record "User Setup";
        gblCodeClaseStockSEGA: Code[20];
        gblCodeClaseStockSEGAAux: Code[20];
        gblEstadoCalidadSEGA: Code[20];
        gblEstadoCalidadSEGAAux: Code[20];
        gblAlmacenServicio: Boolean;
        gblAlmacenServicioAux: Boolean;
    begin
        Clear(RecLocation);
        if RecLocation.Get(TransHeader."Transfer-from Code") then;


        Clear(RecLocationAux);
        if RecLocationAux.Get(TransHeader."Transfer-to Code") then;

        if (RecLocation."Clase de Stock SEGA" <> '') and (RecLocationAux."Clase de Stock SEGA" <> '')
            and (RecLocation."Estado Calidad SEGA" <> '') and (RecLocationAux."Estado Calidad SEGA" <> '') then begin
            if NOT ((RecLocation."Clase de Stock SEGA" = RecLocationAux."Clase de Stock SEGA") and
               (RecLocation."Estado Calidad SEGA" = RecLocationAux."Estado Calidad SEGA")) then begin
                exit(false);
            end else
                exit(true);
            //Error('error deben tener la misma clase y estado');

        end;

    end;



    // procedure ObtenerDatos()
    // var
    //     lRstTMPCE: Record "WMS CE-Confirmación de Entrada" temporary;
    //     lRstTMPCS: Record "WMS CS-Confirmacion de Salidas" temporary;
    // begin
    //     //EX-SGG-WMS 160719
    //     CLEAR(CduNoSeriesMgt);
    //     RstConfAlm.GET;
    //     RstConfAlm.TESTFIELD("No. serie mensaje SEGA PE");
    //     RstConfAlm.TESTFIELD("No. serie mensaje SEGA OE");
    //     //FIN EX-SGG-WMS 160719
    //     nRegControl := UltimoNumeroRegistroControl() + 1;
    //     //EX-SGG 120619
    //     IF (RstConfAlm."Mensajes OE" >= RstConfAlm."Mensajes OE"::Obtener) OR GUIALLOWED THEN //EX-SGG-WMS 170919
    //      BEGIN
    //         RstCabRecepAlm.RESET;
    //         RstCabRecepAlm.SETCURRENTKEY(Obtenido);
    //         RstCabRecepAlm.SETCURRENTKEY(Obtenido, Status);
    //         RstCabRecepAlm.SETRANGE(Obtenido, FALSE);
    //         RstCabRecepAlm.SETRANGE(Status, RstCabEnvAlm.Status::Released);
    //         IF RstCabRecepAlm.FINDSET THEN BEGIN
    //             REPEAT
    //                 InsertarEnRegistroControl(nRegControl, RstControl.Interface::"OE-Orden de Entrada",
    //                  RstControl."Tipo documento"::"Recepcion almacen", RstCabRecepAlm."No.",
    //                  RstControl.Estado::Pendiente, CURRENTDATETIME, 0,
    //                  CduNoSeriesMgt.GetNextNo(RstConfAlm."No. serie mensaje SEGA OE", WORKDATE, TRUE)); //EX-SGG-WMS 160719
    //                 InsertarRegistroOE(RstCabRecepAlm);
    //                 //EX-RBF 040122 Inicio
    //                 //RstCabRecepAlm.MODIFYALL(Obtenido,TRUE,FALSE);
    //                 tmp_RstCabRecepAlm.TRANSFERFIELDS(RstCabRecepAlm);
    //                 tmp_RstCabRecepAlm.INSERT;
    //             UNTIL RstCabRecepAlm.NEXT = 0;
    //             IF tmp_RstCabRecepAlm.FINDSET THEN
    //                 REPEAT
    //                     RstCabRecepAlm.GET(tmp_RstCabRecepAlm."No.");
    //                     RstCabRecepAlm.Obtenido := TRUE;
    //                     RstCabRecepAlm.MODIFY;
    //                 UNTIL tmp_RstCabRecepAlm.NEXT = 0;
    //             tmp_RstCabRecepAlm.DELETEALL;
    //             //EX-RBF 040122 Fin

    //         END;
    //     END;

    //     IF (RstConfAlm."Mensajes PE" >= RstConfAlm."Mensajes PE"::Obtener) OR GUIALLOWED THEN //EX-SGG-WMS 170919
    //      BEGIN
    //         RstCabEnvAlm.RESET;
    //         RstCabEnvAlm.SETCURRENTKEY(Obtenido, Status);
    //         RstCabEnvAlm.SETRANGE(Obtenido, FALSE);
    //         RstCabEnvAlm.SETRANGE(Status, RstCabEnvAlm.Status::Released);
    //         IF RstCabEnvAlm.FINDSET THEN BEGIN
    //             REPEAT
    //                 InsertarEnRegistroControl(nRegControl, RstControl.Interface::"PE-Pedido",
    //                  RstControl."Tipo documento"::"Envio almacen", RstCabEnvAlm."No.",
    //                  RstControl.Estado::Pendiente, CURRENTDATETIME, 0,
    //                  CduNoSeriesMgt.GetNextNo(RstConfAlm."No. serie mensaje SEGA PE", WORKDATE, TRUE)); //EX-SGG-WMS 160719
    //                 InsertarRegistroPE(RstCabEnvAlm); //EX-SGG 130619
    //                                                   //EX-RBF 040122 Inicio
    //                 tmp_RstCabEnvAlm.TRANSFERFIELDS(RstCabEnvAlm);
    //                 tmp_RstCabEnvAlm.INSERT;
    //             //EX-OMI 080819
    //             //UNTIL RstCabRecepAlm.NEXT=0;
    //             UNTIL RstCabEnvAlm.NEXT = 0;
    //             //RstCabEnvAlm.MODIFYALL(Obtenido,TRUE,FALSE);
    //             IF tmp_RstCabEnvAlm.FINDSET THEN
    //                 REPEAT
    //                     RstCabEnvAlm.GET(tmp_RstCabEnvAlm."No.");
    //                     RstCabEnvAlm.Obtenido := TRUE;
    //                     RstCabEnvAlm.MODIFY;
    //                 UNTIL tmp_RstCabEnvAlm.NEXT = 0;
    //             tmp_RstCabEnvAlm.DELETEALL;
    //             //EX-RBF 040122 Fin
    //         END;
    //     END;


    //     IF (RstConfAlm."Mensajes CE" >= RstConfAlm."Mensajes CE"::Obtener) OR GUIALLOWED THEN //EX-SGG-WMS 170919
    //      BEGIN
    //         RstCE.RESET;
    //         RstCE.SETCURRENTKEY(Obtenido);
    //         RstCE.SETRANGE(Obtenido, FALSE);
    //         IF RstCE.FINDSET THEN BEGIN
    //             //+EX-SGG 250722
    //             IF lRstTMPCE.FINDFIRST THEN ERROR('Las variables temporales no deben contener registros');
    //             lRstTMPCE.SETCURRENTKEY(correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada);
    //             //-EX-SGG 250722
    //             REPEAT
    //                 RstControl.RESET;
    //                 RstControl.SETCURRENTKEY(Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA",
    //                  "Numero de mensaje SEGA");
    //                 RstControl.SETRANGE(Interface, RstControl.Interface::"CE-Confirmacion de Entrada");
    //                 RstControl.SETRANGE("Tipo documento", RstControl."Tipo documento"::"Recepcion almacen");
    //                 RstControl.SETRANGE("No. documento", RstCE.codigoOrdenEntrada);
    //                 RstControl.SETRANGE("Id. SEGA", RstCE.correlativoRecepcion);
    //                 RstControl.SETRANGE("Numero de mensaje SEGA", RstCE.numeroMensaje);
    //                 IF NOT RstControl.FINDFIRST THEN //EX-SGG-WMS 180619
    //                  BEGIN
    //                     InsertarEnRegistroControl(nRegControl, RstControl.Interface::"CE-Confirmacion de Entrada",
    //                      RstControl."Tipo documento"::"Recepcion almacen", RstCE.codigoOrdenEntrada,
    //                      RstControl.Estado::Pendiente, CURRENTDATETIME, RstCE.correlativoRecepcion, RstCE.numeroMensaje); //EX-SGG-WMS 200619

    //                     //+EX-SGG 250722
    //                     lRstTMPCE.SETRANGE(codigoOrdenEntrada, RstCE.codigoOrdenEntrada);
    //                     IF NOT lRstTMPCE.FINDFIRST THEN BEGIN
    //                         lRstTMPCE.TRANSFERFIELDS(RstCE);
    //                         lRstTMPCE.INSERT(FALSE);
    //                     END;
    //                     //-EX-SGG 250722
    //                 END;
    //             UNTIL RstCE.NEXT = 0;
    //             //+EX-SGG 250722
    //             //RstCE.MODIFYALL(Obtenido,TRUE,TRUE);
    //             lRstTMPCE.SETRANGE(codigoOrdenEntrada);
    //             IF lRstTMPCE.FINDSET THEN BEGIN
    //                 RstCE.RESET;
    //                 RstCE.SETCURRENTKEY(correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada);
    //                 REPEAT
    //                     RstCE.SETRANGE(codigoOrdenEntrada, lRstTMPCE.codigoOrdenEntrada);
    //                     RstCE.MODIFYALL(Obtenido, TRUE, TRUE);
    //                 UNTIL lRstTMPCE.NEXT = 0;
    //             END;
    //             //-EX-SGG 250722
    //         END;
    //     END;

    //     //EX-SGG 130619
    //     IF (RstConfAlm."Mensajes CS" >= RstConfAlm."Mensajes CS"::Obtener) OR GUIALLOWED THEN //EX-SGG-WMS 170919
    //      BEGIN
    //         RstCS.RESET;
    //         RstCS.SETCURRENTKEY(Obtenido);
    //         RstCS.SETRANGE(Obtenido, FALSE);
    //         IF RstCS.FINDSET THEN BEGIN
    //             //+EX-SGG 250722
    //             IF lRstTMPCS.FINDFIRST THEN ERROR('Las variables temporales no deben contener registros');
    //             lRstTMPCS.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP);
    //             //-EX-SGG 250722
    //             REPEAT
    //                 RstControl.RESET;
    //                 RstControl.SETCURRENTKEY(Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA",
    //                  "Numero de mensaje SEGA");
    //                 RstControl.SETRANGE(Interface, RstControl.Interface::"CS-Confirmacion de Salida");
    //                 RstControl.SETRANGE("Tipo documento", RstControl."Tipo documento"::"Envio almacen");
    //                 RstControl.SETRANGE("No. documento", RstCS.codigoEntregaERP);
    //                 RstControl.SETRANGE("Id. SEGA", RstCS.identificadorExpedicion);
    //                 RstControl.SETRANGE("Numero de mensaje SEGA", RstCS.numeroMensaje);
    //                 IF NOT RstControl.FINDFIRST THEN  //EX-SGG-WMS 200619
    //                  BEGIN
    //                     InsertarEnRegistroControl(nRegControl, RstControl.Interface::"CS-Confirmacion de Salida",
    //                      RstControl."Tipo documento"::"Envio almacen", RstCS.codigoEntregaERP,
    //                      RstControl.Estado::Pendiente, CURRENTDATETIME, RstCS.identificadorExpedicion, RstCS.numeroMensaje);

    //                     //+EX-SGG 250722
    //                     lRstTMPCS.SETRANGE(codigoEntregaERP, RstCS.codigoEntregaERP);
    //                     IF NOT lRstTMPCS.FINDFIRST THEN BEGIN
    //                         lRstTMPCS.TRANSFERFIELDS(RstCS);
    //                         lRstTMPCS.INSERT(FALSE);
    //                     END;
    //                     //-EX-SGG 250722
    //                 END;
    //             UNTIL RstCS.NEXT = 0;
    //             //+EX-SGG 250722
    //             //RstCS.MODIFYALL(Obtenido,TRUE,TRUE);
    //             lRstTMPCS.SETRANGE(codigoEntregaERP);
    //             IF lRstTMPCS.FINDSET THEN BEGIN
    //                 RstCS.RESET;
    //                 RstCS.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP);
    //                 REPEAT
    //                     RstCS.SETRANGE(codigoEntregaERP, lRstTMPCS.codigoEntregaERP);
    //                     RstCS.MODIFYALL(Obtenido, TRUE, TRUE);
    //                 UNTIL lRstTMPCS.NEXT = 0;
    //             END;
    //             //-EX-SGG 250722
    //         END;
    //     END;

    //     IF (RstConfAlm."Mensajes AS" >= RstConfAlm."Mensajes AS"::Obtener) OR GUIALLOWED THEN //EX-SGG-WMS 170919
    //      BEGIN
    //         RstAS.RESET;
    //         RstAS.SETCURRENTKEY(Obtenido);
    //         RstAS.SETRANGE(Obtenido, FALSE);
    //         IF RstAS.FINDSET THEN BEGIN
    //             REPEAT
    //                 RstControl.RESET;
    //                 RstControl.SETCURRENTKEY(Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA",
    //                  "Numero de mensaje SEGA");
    //                 RstControl.SETRANGE(Interface, RstControl.Interface::"AS-Ajuste de Stock");
    //                 RstControl.SETRANGE("Tipo documento", RstControl."Tipo documento"::Stock);
    //                 RstControl.SETRANGE("Numero de mensaje SEGA", RstAS.numeroMensaje);
    //                 IF NOT RstControl.FINDFIRST THEN  //EX-SGG-WMS 

    //                     InsertarEnRegistroControl(nRegControl, RstControl.Interface::"AS-Ajuste de Stock",
    //                      RstControl."Tipo documento"::Stock, FORMAT(RstAS.numeroMensaje),
    //                      RstControl.Estado::Pendiente, CURRENTDATETIME, RstAS.identificadorAjuste, RstAS.numeroMensaje);
    //             UNTIL RstAS.NEXT = 0;
    //             RstAS.MODIFYALL(Obtenido, TRUE, TRUE);
    //         END;
    //     END;

    //     IF (RstConfAlm."Mensajes SA" >= RstConfAlm."Mensajes SA"::Obtener) OR GUIALLOWED THEN //EX-SGG-WMS 170919
    //      BEGIN
    //         RstSA.RESET;
    //         RstSA.SETCURRENTKEY(Obtenido);
    //         RstSA.SETRANGE(Obtenido, FALSE);
    //         IF RstSA.FINDSET THEN BEGIN
    //             REPEAT
    //                 RstControl.RESET;
    //                 RstControl.SETCURRENTKEY(Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA",
    //                  "Numero de mensaje SEGA");
    //                 RstControl.SETRANGE(Interface, RstControl.Interface::"SA-Stock Actual");
    //                 RstControl.SETRANGE("Tipo documento", RstControl."Tipo documento"::Stock);
    //                 RstControl.SETRANGE("Numero de mensaje SEGA", RstSA.numeroMensaje);
    //                 IF NOT RstControl.FINDFIRST THEN BEGIN //EX-SGG-WMS 030719
    //                     PreObtenerSASQL(RstSA.numeroMensaje); //EX-DRG 110321
    //                     InsertarEnRegistroControl(nRegControl, RstControl.Interface::"SA-Stock Actual",
    //                      RstControl."Tipo documento"::Stock, FORMAT(RstSA.numeroMensaje),
    //                      RstControl.Estado::Pendiente, CURRENTDATETIME, RstSA.identificadorStock, RstSA.numeroMensaje);
    //                 END;
    //             UNTIL RstSA.NEXT = 0;
    //             RstSA.MODIFYALL(Obtenido, TRUE, TRUE);
    //         END;
    //     END;
    // end;

    // procedure InsertarRegistroOE(var lRstCabRecepAlm: Record "Warehouse Receipt Header")
    // var
    //     lnRegOE: Integer;
    //     locrec_WHshipmentline: Record "Warehouse Receipt Line";
    // begin
    //     //EX-SGG-WMS 120619
    //     RstConfCompras.GET;
    //     RstLinRecepAlm.RESET;
    //     RstLinRecepAlm.SETRANGE("No.", lRstCabRecepAlm."No.");
    //     IF RstLinRecepAlm.FINDSET THEN BEGIN
    //         lnRegOE := UltimoNumeroRegistroOE + 1;
    //         CLEAR(RstOE);
    //         RstOE.INIT;
    //         RstOE.VALIDATE("No. registro", lnRegOE);
    //         RstOE.VALIDATE(tipoOperacion, 1);
    //         RstOE.VALIDATE(codigoOrdenEntrada, lRstCabRecepAlm."No.");

    //         //EX-SGG-WMS 110719
    //         /*
    //             CASE RstLinRecepAlm."Source Document" OF
    //               RstLinRecepAlm."Source Document"::"Sales Order",RstLinRecepAlm."Source Document"::"Sales Return Order":
    //                BEGIN
    //                 RstOE.VALIDATE(tipoOrdenEntrada,2);
    //                 RstOE.VALIDATE(tipoCentroOrigen,FORMAT(1));
    //                 CASE RstLinRecepAlm."Source Document" OF
    //                  RstLinRecepAlm."Source Document"::"Sales Order":
    //                   RstCabVenta.GET(RstCabVenta."Document Type"::Order,RstLinRecepAlm."Source No.");
    //                  RstLinRecepAlm."Source Document"::"Sales Return Order":
    //                   RstCabVenta.GET(RstCabVenta."Document Type"::"Return Order",RstLinRecepAlm."Source No.");
    //                 END;
    //                 RstOE.VALIDATE(codigoCentroOrigen,RstCabVenta."Sell-to Customer No.");
    //                END;
    //               RstLinRecepAlm."Source Document"::"Purchase Order",RstLinRecepAlm."Source Document"::"Purchase Return Order":
    //                BEGIN
    //                 RstOE.VALIDATE(tipoOrdenEntrada,1);
    //                 RstOE.VALIDATE(tipoCentroOrigen,FORMAT(2));
    //                 CASE RstLinRecepAlm."Source Document" OF
    //                  RstLinRecepAlm."Source Document"::"Purchase Order":
    //                   BEGIN
    //                    RstCabCompra.GET(RstCabVenta."Document Type"::Order,RstLinRecepAlm."Source No.");
    //                    //EX-SGG-WMS 110719
    //                    RstAsignacionDirecta.RESET;
    //                    RstAsignacionDirecta.SETCURRENTKEY("Pedido de compra","Lin. pedido de compra");
    //                    RstAsignacionDirecta.SETRANGE("Pedido de compra",RstLinRecepAlm."Source No.");
    //                    RstAsignacionDirecta.SETRANGE("Lin. pedido de compra",RstLinRecepAlm."Source Line No.");
    //                    IF RstAsignacionDirecta.FINDFIRST THEN
    //                     RstOE.VALIDATE(tipoOrdenEntrada,3);
    //                    //FIN EX-SGG-WMS
    //                   END;
    //                  RstLinRecepAlm."Source Document"::"Purchase Return Order":
    //                   RstCabCompra.GET(RstCabVenta."Document Type"::"Return Order",RstLinRecepAlm."Source No.");
    //                 END;
    //                 RstOE.VALIDATE(codigoCentroOrigen,RstCabCompra."Buy-from Vendor No.");
    //                END;
    //             END;
    //         */
    //         EVALUATE(RstOE.tipoOrdenEntrada, lRstCabRecepAlm."Tipo de Orden de Entrada");
    //         RstOE.VALIDATE(tipoOrdenEntrada);
    //         CASE lRstCabRecepAlm."Tipo origen" OF
    //             lRstCabRecepAlm."Tipo origen"::Cliente:
    //                 RstOE.VALIDATE(tipoCentroOrigen, FORMAT(1));
    //             lRstCabRecepAlm."Tipo origen"::Proveedor:
    //                 RstOE.VALIDATE(tipoCentroOrigen, FORMAT(2));
    //         END;
    //         //FIN EX-SGG-WMS 110719

    //         RstOE.VALIDATE(codigoCentroOrigen, lRstCabRecepAlm."Cod. origen"); //EX-SGG-WMS 150719
    //         RstOE.VALIDATE(fechaEntrega, WORKDATE);
    //         RstOE.fechaVencimiento := CALCDATE(RstConfCompras."Fecha Vto orden entrada", RstOE.fechaEntrega);
    //         RstOE.VALIDATE(comentario, DevuelveComentarios(
    //           DATABASE::"Warehouse Receipt Header", RstOE.codigoOrdenEntrada, MAXSTRLEN(RstOE.comentario)));

    //         locrec_WHshipmentline.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Source Line No.");//EX-OMI 101219

    //         REPEAT
    //             //IF ((RstOE.tipoOrdenEntrada=2) AND EnviarASEGA(RstLinRecepAlm."Item No.",RstLinRecepAlm."Location Code")) //EX-SGG-WMS 020719
    //             // NM-CSA-200410                       // EX-SGG-WMS 020719
    //             IF ((RstOE.tipoOrdenEntrada IN [2, 4]) AND EnviarASEGA(RstLinRecepAlm."Item No.", RstLinRecepAlm."Location Code"))
    //              OR (RstOE.tipoOrdenEntrada IN [1, 3]) THEN //EX-SGG-WMS 270619
    //               BEGIN
    //                 RstOE.VALIDATE("No. registro", lnRegOE);
    //                 RstOE.VALIDATE(lineaOrdenEntrada, FORMAT(RstLinRecepAlm."Line No."));
    //                 RstOE.VALIDATE(codigoArticuloERP, DevuelveCodigoArticuloERP(RstLinRecepAlm."Item No.", RstLinRecepAlm."Variant Code"));
    //                 RstOE.VALIDATE(cantidad, RstLinRecepAlm.Quantity);
    //                 RstOE.VALIDATE(tolerancia, 0);
    //                 RstOE.VALIDATE(codigoOrdenCompraERP, RstLinRecepAlm."Source No.");
    //                 RstOE.VALIDATE(codigoDocumentoEntrada, RstLinRecepAlm."No. albaran proveedor");
    //                 RstOE.VALIDATE(estadoCalidad, DevuelveEstadoCalidadAlmacen(RstLinRecepAlm."Location Code"));
    //                 RstOE.VALIDATE(motivoDevolucion, '');

    //                 //EX-SGG-WMS 110719
    //                 CLEAR(RstOE.codigoEntregaERP);
    //                 CLEAR(RstOE.lineaEntregaERP);
    //                 CLEAR(RstOE.cantidadLineaEntregaERP);
    //                 IF RstOE.tipoOrdenEntrada = 3 THEN BEGIN
    //                     RstAsignacionDirecta.RESET;
    //                     RstAsignacionDirecta.SETRANGE("Nº Pedido Compra", RstLinRecepAlm."Source No.");
    //                     RstAsignacionDirecta.SETRANGE("Tipo Asignación", RstAsignacionDirecta."Tipo Asignación"::Directa);
    //                     RstAsignacionDirecta.SETRANGE("Nº Linea Pedido Compra", RstLinRecepAlm."Source Line No."); //EX-SGG-WMS 051219
    //                     IF RstAsignacionDirecta.FINDSET THEN
    //                         REPEAT
    //                             IF RstLinVenta.GET(RstLinVenta."Document Type"::Order, RstAsignacionDirecta."Nº Pedido Venta",
    //                              RstAsignacionDirecta."Nº Linea Pedido Venta") THEN BEGIN
    //                                 RstOE.VALIDATE("No. registro", lnRegOE);

    //                                 //EX-OMI 101219
    //                                 //RstOE.VALIDATE(codigoEntregaERP,DevuelveCodigoArticuloERP(RstLinVenta."No.",RstLinVenta."Variant Code"));
    //                                 //RstOE.VALIDATE(lineaEntregaERP,FORMAT(RstLinVenta."Line No."));
    //                                 locrec_WHshipmentline.SETRANGE("Source Type", 37);
    //                                 locrec_WHshipmentline.SETRANGE("Source Subtype", locrec_WHshipmentline."Source Subtype"::"1");
    //                                 locrec_WHshipmentline.SETRANGE("Source No.", RstLinVenta."Document No.");
    //                                 locrec_WHshipmentline.SETRANGE("Source Line No.", RstLinVenta."Line No.");
    //                                 locrec_WHshipmentline.FINDFIRST;
    //                                 RstOE.VALIDATE(codigoEntregaERP, locrec_WHshipmentline."No.");
    //                                 RstOE.VALIDATE(lineaEntregaERP, FORMAT(locrec_WHshipmentline."Line No."));
    //                                 //EX-OMi fin

    //                                 RstOE.VALIDATE(cantidadLineaEntregaERP, RstLinVenta.Quantity);
    //                                 RstOE.INSERT(TRUE);
    //                                 lnRegOE += 1;
    //                             END;
    //                         UNTIL RstAsignacionDirecta.NEXT = 0;
    //                 END
    //                 //FIN EX-SGG-WMS 110719
    //                 ELSE //EX-SGG-WMS 021219
    //                  BEGIN
    //                     RstOE.INSERT(TRUE);
    //                     lnRegOE += 1;
    //                 END;
    //             END;
    //         UNTIL RstLinRecepAlm.NEXT = 0;
    //     END;

    // end;

    // procedure UltimoNumeroRegistroControl(): Integer
    // begin

    //     //EX-SGG 120619
    //     IF lRstControlWMS.FINDLAST THEN
    //         EXIT(lRstControlWMS."No. registro")
    //     ELSE
    //         EXIT(0);
    // end;

    // procedure InsertarEnRegistroControl(var lnRegControl: Integer; lInterface: Option; lTipoDoc: Option; lNoDoc: Code[20]; lEstado: Option; lFechayHora: DateTime; lIdWMS: Integer; lNumeroMensaje: Code[25])
    // var
    //     lRstControl: Record "Control integracion WMS";
    // begin

    //     //EX-SGG-WMS 200619
    //     //EX-RBF 200522 Inicio
    //     CLEAR(lRstControl);
    //     lRstControl.SETRANGE("No. documento", lNoDoc);
    //     IF lRstControl.FINDFIRST THEN
    //         CASE lRstControl.Interface OF
    //             lRstControl.Interface::"OE-Orden de Entrada":
    //                 BEGIN
    //                     IF lInterface = lRstControl.Interface::"OE-Orden de Entrada" THEN
    //                         ERROR('Error al insertar registro en control, ya existe un registro para el No. documento %1', lNoDoc);
    //                 END;
    //             lRstControl.Interface::"PE-Pedido":
    //                 BEGIN
    //                     IF lInterface = lRstControl.Interface::"PE-Pedido" THEN
    //                         ERROR('Error al insertar registro en control, ya existe un registro para el No. documento %1', lNoDoc);
    //                 END;
    //         END;
    //     //EX-RBF 200522 Fin
    //     CLEAR(RstControl);
    //     RstControl.INIT;
    //     RstControl.VALIDATE("No. registro", lnRegControl);
    //     RstControl.VALIDATE(Interface, lInterface);
    //     RstControl.VALIDATE("Tipo documento", lTipoDoc);
    //     RstControl.VALIDATE("No. documento", lNoDoc);
    //     RstControl.VALIDATE(Estado, lEstado);
    //     RstControl.VALIDATE("Fecha y hora obtenido", lFechayHora);
    //     RstControl.VALIDATE("Id. SEGA", lIdWMS);
    //     RstControl.VALIDATE("Numero de mensaje SEGA", lNumeroMensaje); //EX-SGG-WMS 030719
    //     RstControl.INSERT(TRUE);
    //     lnRegControl += 1;
    // end;



    // procedure PreObtenerSASQL(NumMensaje: Code[25])
    // var
    //     WSetup: Record "Warehouse Setup";
    //     ConnectionString: Text[300];
    //     SQL: Text[200];
    // begin

    //     //EX-DRG 110321
    //     WSetup.GET;
    //     WSetup.TESTFIELD(WSetup."SQL Server");
    //     WSetup.TESTFIELD(WSetup."SQL Database");
    //     WSetup.TESTFIELD(WSetup."SQL User");
    //     WSetup.TESTFIELD(WSetup."SQL Password");
    //     ConnectionString := 'Driver={SQL Server};'
    //           + 'Server=' + WSetup."SQL Server" + ';'
    //           + 'Database=' + WSetup."SQL Database" + ';'
    //           + 'Uid=' + WSetup."SQL User" + ';'
    //           + 'Pwd=' + WSetup."SQL Password" + ';';

    //     SQL := 'EXECUTE [WMS_SA_PreObtener] ''' + NumMensaje + '''';

    //     // CREATE(rConn);
    //     // rConn.Open(ConnectionString);
    //     // rConn.Execute(SQL);
    // end;

    // var
    //     lRstControlWMS: Record "Control integracion WMS";
    //     RstCabEnvAlm: Record "Warehouse Shipment Header";
    //     RstCabRecepAlm: Record "Warehouse Receipt Header";
    //     RstLinRecepAlm: Record "Warehouse Receipt Line";
    //     tmp_RstCabRecepAlm: Record "Warehouse Receipt Header" temporary;

}