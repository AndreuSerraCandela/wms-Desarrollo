Page 50430 "Proposiciones Venta WMS"
{
    PageType = Card;
    Caption = 'Generar Proposición Envios';
    SourceTable = "Filtros Proposicion";
    ApplicationArea = all;
    UsageCategory = Administration;
    layout

    {
        area(Content)
        {


            field(Temporada; Rec.Temporada)
            {
                ApplicationArea = All;
                trigger OnLookup(var Text: Text): Boolean
                BEGIN
                    DimValue.RESET;
                    DimValue.SETRANGE("Global Dimension No.", 1);
                    IF Page.RUNMODAL(Page::"Dimension Values", DimValue) = ACTION::LookupOK THEN BEGIN
                        Text := DimValue.Code;
                        EXIT(TRUE);
                    END ELSE
                        EXIT(FALSE);
                END;
            }
            field("F. Fecha Servicio Confirm."; Rec."F. Fecha Servicio Confirm.") { ApplicationArea = All; }
            field("Filtro Pedido"; Rec."Filtro Pedido")
            {
                ApplicationArea = All;
                trigger OnLookUp(var Text: Text): Boolean
                BEGIN
                    RecPedVta.RESET;
                    RecPedVta.SETRANGE("Document Type", RecPedVta."Document Type"::Order);
                    IF Page.RUNMODAL(Page::"Sales List", RecPedVta) = ACTION::LookupOK THEN BEGIN
                        Text := RecPedVta."No.";
                        EXIT(TRUE);
                    END ELSE
                        EXIT(FALSE);
                END;
            }
            field("Filtro Cliente"; Rec."Filtro Cliente")
            {
                ApplicationArea = All;
                trigger OnLookUp(var Text: Text): Boolean
                BEGIN
                    RecCli.RESET;
                    IF Page.RUNMODAL(Page::"Customer List", RecCli) = ACTION::LookupOK THEN BEGIN
                        Text := RecCli."No.";
                        EXIT(TRUE);
                    END ELSE
                        EXIT(FALSE);
                END;
            }
            field("Filtro Producto"; Rec."Filtro Producto")
            {
                ApplicationArea = All;
                trigger OnLookUp(var Text: Text): Boolean
                BEGIN
                    RecProdF.RESET;
                    IF Page.RUNMODAL(Page::"Item List", RecProdF) = ACTION::LookupOK THEN BEGIN
                        Text := RecProdF."No.";
                        EXIT(TRUE);
                    END ELSE
                        EXIT(FALSE);
                END;
            }
            field("Filtro Color"; Rec."Filtro Color") { ApplicationArea = All; }
            field("Tipo Pedido"; Rec."Tipo Pedido") { ApplicationArea = All; }

            field("Filtro Representante"; FRepresentante) { ApplicationArea = All; Visible = false; }
            field("Servicio Pedido"; Rec."Servicio Pedido") { ApplicationArea = All; Visible = false; }
            field("% Servicio Pedido"; Rec."% Servicio Pedido") { ApplicationArea = All; Visible = false; }
            Field("Control Agrupaciones Serie"; Rec."Control Agrupaciones Serie") { ApplicationArea = All; Visible = false; }

            field("Cantidad Máxima Global"; Rec."Cantidad Máxima Global") { ApplicationArea = All; Visible = false; }
            field("Cantidad Mínima por Pedido"; Rec."Cantidad Mínima por Pedido") { ApplicationArea = All; Visible = false; }



            field("Admite Tallas Parciales"; Rec."Admite Tallas Parciales")
            {
                ApplicationArea = All;
                Visible = false;
                trigger OnValidate()
                BEGIN
                    IF NOT Rec."Admite Tallas Parciales" THEN
                        Rec."% Talla" := 100
                    ELSE
                        Rec."% Talla" := 0;
                END;
            }
            field("% Talla"; Rec."% Talla")
            {
                ApplicationArea = All;
                Visible = false;
                trigger OnValidate()
                BEGIN
                    IF Rec."% Talla" <> 100 THEN
                        Rec."Admite Tallas Parciales" := TRUE;
                END;
            }
            field("Tipo Servicio"; Rec."Tipo Servicio") { ApplicationArea = All; Visible = false; }
            field("Numero pedidos a enviar a proposición"; Rec."Num pedidos a enviar") { ApplicationArea = All; Visible = true; }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Procesar)
            {
                ApplicationArea = All;
                Image = Calculate;
                trigger OnAction()
                Var
                    CUFunciones: Codeunit 50000;
                    lRecConsignmentCondition: Record 50051;

                BEGIN
                    V.OPEN('#1######  #2#######  #3#######');

                    RecUser.GET(USERID);
                    RecUser."Proposicion Venta" := FALSE;
                    RecUser.MODIFY;


                    Salir := FALSE;
                    IncrCant := 0;
                    ContadorLin := 0;
                    LinPedido.RESET;
                    
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
                    LinPedido.SETRANGE("Producto SEGA", TRUE); //EX-SGG-WMS 200619
                    IF LinPedido.FINDFIRST THEN
                        REPEAT
                            IF CabPedido.GET(CabPedido."Document Type"::Order, LinPedido."Document No.") THEN;
                            CabPedido.CALCFIELDS("Proposicion Venta");



                            RecCli.GET(CabPedido."Sell-to Customer No.");
                            ClienteBloq := FALSE;
                            IF EstadoCli.GET(RecCli.CustomerStatus) THEN
                                IF not EstadoCli."Envíos permitidos" Then //EstadoCli."Sales Shipment Blocked" THEN
                                    ClienteBloq := TRUE;
                            //EX-OMI-WMS 270519

                           
                            IF ((NOT CUFunciones.Vencimiento15(CabPedido."Sell-to Customer No.")) AND                               

                                (NOT CabPedido."Pedido Retenido") AND (NOT ClienteBloq)) and (TipoServ(CabPedido."Tipo Servicio")) THEN BEGIN
                                ContadorLin += 1;
                                If Rec."Num pedidos a enviar" <> 0 Then
                                    if ContadorLin = Rec."Num pedidos a enviar" Then Salir := True;
                              
                                LinPedido.CALCFIELDS("Cant. envios lanzados", "Cant. en envios almacen"); //EX-SGG-WMS 100919
                                                                                                          //EX-SGG-WMS 180919
                                V.UPDATE(1, CabPedido."No.");
                                V.UPDATE(2, LinPedido."Fecha servicio confirmada");
                                V.UPDATE(3, ContadorLin);
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
                                TemporalRec."Cod Variante" := LinPedido."Variant Code";                              
                               
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
                                    
                                    TemporalRec."Cantidad Anulada" := LinPedido."Cantidad Anulada";
                                    TemporalRec."Cantidad Servida" := LinPedido."Quantity Shipped";                                   
                                    //SF-POF
                                    IF LinPedido."VAT Calculation Type" <> LinPedido."VAT Calculation Type"::"Reverse Charge VAT" THEN
                                        TemporalRec."Importe Pedido" += LinPedido."Outstanding Amount"
                                    ELSE
                                        TemporalRec."Importe Pedido" += LinPedido.Amount;
                                    //SF-POF:FIN                                  
                                    TemporalRec."Reserva Pedido" := CalculoReserva(LinPedido."Document No.", LinPedido."Line No.");
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
                    V.CLOSE;



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

                    V.OPEN('Borrar Cantidades pendientes');
                    TemporalRec.RESET;
                    TemporalRec.SETCURRENTKEY(Proceso, usuario, "Cantidad Pendiente", Insertado);
                    TemporalRec.SETRANGE(Proceso, 'WMSLIN');
                    TemporalRec.SETRANGE(usuario, USERID);
                    TemporalRec.SETRANGE("Cantidad Pendiente", 0);
                    TemporalRec.SETRANGE(Insertado, FALSE);
                    TemporalRec.DELETEALL;
                    V.CLOSE;

                    V.OPEN('Borrar Cantidades Anuladas');
                    TemporalRec.RESET;
                    TemporalRec.SETCURRENTKEY(Proceso, usuario, Anular, Insertado);
                    TemporalRec.SETRANGE(Proceso, 'WMSLIN');
                    TemporalRec.SETRANGE(usuario, USERID);
                    TemporalRec.SETRANGE(Anular, TRUE);
                    TemporalRec.SETRANGE(Insertado, FALSE);
                    TemporalRec.DELETEALL;
                    V.CLOSE;

                    Solicitado := 0;
                    V.OPEN('Tallas Parciales');

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

                    V.CLOSE;
                    V.OPEN('Preembalados 1:#1######  #2#######');

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
                            V.UPDATE(1, NumPreemb3);
                            V.UPDATE(2, NumPreemb2);

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

                    V.CLOSE;

                    NumPreemb3 := 0;
                    TempAgrup.RESET;
                    TempAgrup.SETCURRENTKEY(Proceso, usuario, Insertado, "Clave 6");
                    TempAgrup.SETRANGE(Proceso, 'WMSLIN');
                    TempAgrup.SETRANGE(usuario, USERID);
                    TempAgrup.SETRANGE(Insertado, FALSE);
                    TempAgrup.SETFILTER("Clave 6", '<>%1', '');
                    NumPreemb2 := TempAgrup.COUNT;

                    V.OPEN('Preembalados 2:#1######  #2#######');

                    TempAgrup.RESET;
                    TempAgrup.SETCURRENTKEY(Proceso, usuario, Insertado, "Clave 6");
                    TempAgrup.SETRANGE(Proceso, 'WMSLIN');
                    TempAgrup.SETRANGE(usuario, USERID);
                    TempAgrup.SETRANGE(Insertado, FALSE);
                    TempAgrup.SETFILTER("Clave 6", '<>%1', '');
                    IF TempAgrup.FINDFIRST THEN
                        REPEAT

                            NumPreemb3 += 1;
                            V.UPDATE(1, NumPreemb3);
                            V.UPDATE(2, NumPreemb2);

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
                    V.CLOSE;


                    V.OPEN('Creacion cabeceras:#1######  #2#######');
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
                                V.UPDATE(1, TemporalRec."Clave 1");
                                V.UPDATE(2, ContadorLin);
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
                                TemporalCab."Cantidad Reserva" := CalculoReserva3(CabPedido."No.");
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
                                RecCli.CalcFields("Riesgo Concedido Firme", "Riesgo Concedido Consignacion");
                                //IF CUFunc.RiesgoCliente(CabPedido."Sell-to Customer No.") <= 0 THEN
                                //EX-JFC 071221 Control de Riesgo o Aval segun el tipo de pedido en firme o consignacion
                                IF TemporalCab."Consignacion venta" = FALSE THEN BEGIN
                                    TemporalCab."Riesgo NMilenio" := (RecCli."Riesgo Concedido Firme" + RecCli."Riesgo Concedido Consignacion");
                                    // RecCli."Riesgo NUEVO MILENIO";
                                    //IF RecCli."Riesgo NUEVO MILENIO" <= 0 THEN

                                    If (RecCli."Riesgo Concedido Firme" + RecCli."Riesgo Concedido Consignacion") <= 0 Then
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

                                TemporalCab."Impago Cliente" := CUFunciones.Vencimiento15(TemporalCab."Clave 3");
                                //EX-OMI-WMS fin



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
                        V.CLOSE;
                    END;
                    ContadorLin2 := ContadorLin;

                    V.OPEN('Asignacion Cantidades:#1###### #2####### #3######');
                    ContadorLin := 0;
                    TemporalRec.RESET;
                    TemporalRec.SETCURRENTKEY(Proceso, usuario, Insertado);
                    TemporalRec.SETRANGE(Proceso, 'WMSCAB');
                    TemporalRec.SETRANGE(usuario, USERID);
                    TemporalRec.SETRANGE(Insertado, FALSE);
                    IF TemporalRec.FINDFIRST THEN
                        REPEAT
                            ContadorLin += 1;
                            V.UPDATE(1, TemporalRec."Clave 1");
                            V.UPDATE(2, ContadorLin);
                            V.UPDATE(3, ContadorLin2);
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
                    V.CLOSE;

                    V.OPEN('Calculo2');



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



                    TemporalRec.RESET;
                    TemporalRec.SETCURRENTKEY(Proceso, usuario, Anular, Insertado);
                    TemporalRec.SETRANGE(Proceso, 'WMSCAB');
                    TemporalRec.SETRANGE(usuario, USERID);
                    TemporalRec.SETRANGE(Anular, TRUE);
                    TemporalRec.SETRANGE(Insertado, FALSE);
                    IF TemporalRec.FINDFIRST THEN
                        TemporalRec.DELETEALL(TRUE);



                    V.CLOSE;

                    V.OPEN('Lineas no asignadas:#1########');
                    TemporalRec.LOCKTABLE;
                    TemporalRec.RESET;
                    //TemporalRec.SETCURRENTKEY(Proceso,usuario);
                    TemporalRec.SETRANGE(Proceso, 'WMSCAB');
                    TemporalRec.SETRANGE(usuario, USERID);
                    IF TemporalRec.FINDFIRST THEN
                        REPEAT
                            V.UPDATE(1, TemporalRec."Clave 1");
                            CantNuevaGl := 0;
                            CantServGl := 0;
                            Crearlineasnoasignadas(TemporalRec."Clave 1", CantNuevaGl, CantServGl);
                            TemporalRec.Insertado := TRUE;
                            TemporalRec.Cantidad := TemporalRec.Cantidad + CantNuevaGl;
                            TemporalRec."Cantidad Servida" := TemporalRec."Cantidad Servida" + CantServGl;
                            TemporalRec.MODIFY;
                        UNTIL TemporalRec.NEXT = 0;

                    V.CLOSE;

                    V.OPEN('Actualizacion Final');
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
                    V.CLOSE;

                    COMMIT;
                    Page.RUNMODAL(Page::"Modificacion Prop Vta Cab WMS"); //EX-SGG-WMS 200619
                END;

            }

        }
        area(Promoted)
        {
            actionref(Procesar_promoted; Procesar)
            { }
        }

    }




    VAR


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
        V: Dialog;
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

    trigger OnOpenPage()
    BEGIN
        If Not Rec.Get Then begin
            Rec.Init;
            Rec.Insert();
        end;
        Rec."% Servicio Pedido" := 0;
        Rec."% Talla" := 0;
        FlagExport := '0';
        Sucursal := '1';
        Prioridad := '0';
        Rec."Admite Tallas Parciales" := TRUE; //EX-SGG 231122
    END;

    Procedure TipoServ(TP: Enum "Tipo servicio"): Boolean
    begin
        If Rec."Tipo Servicio" = Rec."Tipo Servicio"::Todos Then exit(true);
        If Rec."Tipo Servicio" = Rec."Tipo Servicio"::Nuevo Then exit(Tp = Tp::Nuevo);
        If Rec."Tipo Servicio" = Rec."Tipo Servicio"::"Reposición" Then exit(Tp = Tp::"Reposición");
    end;


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

    PROCEDURE CalculoReserva3(DocRes: Code[20]): Integer;
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
                    //   TempCrear2."Clave 6" := LinPedCrear."PfsPrepack Code";
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


    // {
    //   Pedidos a tener en cuenta: lanzados, sin Picking manual marcado
    //   Se tiene en cuenta en la insercion si se pide cualquier pedido (T), solo los nuevos (N) o los pedientes (R)
    //   Si un pedido tiene alguna lonea total o parcialmente enviada, ser  de resto.
    //   Si un pedido no tiene ninguna cantidad enviada, nuevo
    //   Si elegimos opcion resto, y en un pedido encuentra alguna l nea de opcion nuevo, no debe proponer NINGUNA l nea
    //   del pedido
    //   Si elegimos opcion nuevo, y en un pedido encuentra alguna l nea de opcion resto, no debe proponer NINGUNA l nea
    //   del pedido


    //   Admite tallas parciales:
    //      Si no se marca, siempre al 100%
    //      Si se marca, le aplica el % indicado a la cantidad de cada una de las tallas. Si el valor de la cantidad pedida
    //      (cantidad pendiente - cantidad anulada) multiplicada por el % indicado es menor que el stock, propone la l nea.
    //      Cuanto m s %, m s restrictivo. Al 100 %, se est  pidiendo que toda la cantidad pedida sea igual o menor al stock.
    //      Si el valor de cantidad por % es menor que el stock, propone hasta lo que pueda de stock.

    //   Control Agrupaciones por serie
    //     Si marcan la opcion, a nivel de serie precio, si alguna talla no se propone, no propone las de su misma serie precio.

    //   % Servicio pedido. Se aplica porcentaje a cantidad pendiente-cantidad anulada de todo el pedido, y se compara con lo propuesto.

    //   CantMin, sobre lo ya calculado.
    //   CantMax, sobre lo ya calculado.


    //   EX-OMI-WMS 270519 Paso de funciones a codeunit 50000 de bloqueoclientes y vencimientos15
    //   *********
    //   EX-SGG-WMS 200619 COPIA DE FRM50023 PARA TRATAMIENTO SOLO PRODUCTOS SEGA Y GENERACI N SOLO DE ENVIOS ALMACEN.
    //                     MODIFICACIONES DE ASIGNACIONES CAMPO "Proceso" DE 'RFID*' A 'WMS*'. ELIMINO ASIGNACIONES A CAMPOS PDA y Clasificad

    //   //WMS EX-JFC 09/09/2019 Validar el almacen predeterminado SEGA
    //   EX-SGG-WMS 100919 NUEVA FUNCION filtroalmacenessega. CODIGO REFERENCIA.
    //                     TENER EN CUENTA CANTIDADES EN ENVIOS ALMACEN LANZADOS EN MISMAS OPERACIONES QUE PICKING.
    //              180919 INCLUYO NUEVO CAMPO Cant. env. lanzados prod y var
    //   EX-CSA-20200221 Ampliar Rec."Filtro Producto" a Text 500 para que puedan filtrar m s productos.
    //   EX.CGR.140920 AGREGADO TIPO PEDIDO
    //   //EX-JFC 071221 Control de Riesgo o Aval segun el tipo de pedido en firme o consignacion
    //   //EX-JFC 020322 A ado control producto SEGA
    //   EX-SGG 171122 ASIGNACION VALORES NUEVOS CAMPOS.
    //          231122 ESTABLEZCO CIERTOS CONTROLES A NO VISIBLES Y EN ROJO. VARIABLE Rec."Admite Tallas Parciales" TRUE. COMENTO CODIGO INNECESARIO Aceptar.
    //          121222 CORRECCION.
    // }

}


