codeunit 50404 "Get Source Doc. Outbound WMS"
{
    trigger OnRun()
    begin

    end;



    procedure CreateFromSalesOrder(var SalesHeader: Record "Sales Header"): Boolean
    var
        // GetSourceDocuments: Report "Get Source Documents";
        GetSourceDocuments: Report "Get Source Documents1";
        GetSourceDocumentsCodeunit: Codeunit 50200;
        lRstTMPEnvioAlm: Record "Warehouse Shipment Header";
        WhseShptHeader: Record "Warehouse Shipment Header";
        WareHouseShipmentLine: Record "Warehouse Shipment Line";
        FuncionesCodeunit: CodeUnit Funciones;


    begin
        WITH SalesHeader DO BEGIN
            TESTFIELD(Status, Status::Released);

            PfsCustomer.GET("Sell-to Customer No.");
            PfsCustomer.CheckBlockedCustOnDocs(PfsCustomer, SalesHeader."Document Type", FALSE, FALSE);
            SalesHeader.CheckLocation(TRUE);
            FuncionesCodeunit.ControlEnviosPedido(SalesHeader);
            IF SalesHeader."Ventas en consignacion" THEN BEGIN
                //EX.CGR.290920
                TransferHeaderTemp.DELETEALL;
                IF EsCantidadAEnviar THEN BEGIN
                    recSalesLine.SETRANGE("Document No.", SalesHeader."No.");
                    recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
                    recSalesLine.SETFILTER("Qty. to Ship", '<>0');
                    IF NOT recSalesLine.FINDFIRST THEN BEGIN
                        logError(SalesHeader, 'No hay lineas con cantidad a enviar para transferir');
                        EXIT(FALSE);
                    END;
                    recSalesLine.SETRANGE("Document No.", SalesHeader."No.");
                    recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
                    recSalesLine.SETFILTER("Qty. to Ship", '<>0');
                    IF recSalesLine.FINDSET THEN
                        REPEAT
                            recSalesLine.CALCFIELDS("Cantidad en consignacion", "Cantidad transferencia");
                            IF recSalesLine."Qty. to Ship" > (recSalesLine.Quantity - recSalesLine."Cantidad en consignacion" -
                            recSalesLine."Cantidad transferencia" - recSalesLine."Cantidad Anulada") THEN BEGIN
                                logError(SalesHeader, 'No puede enviar ' + FORMAT(recSalesLine."Qty. to Ship") + ' unidades el producto ' +
                                  recSalesLine."No." + ' variante ' + recSalesLine."Variant Code");
                                EXIT(FALSE);
                            END;
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
                            recSalesLine.CALCFIELDS("Cantidad en consignacion", "Cantidad transferencia");
                            IF (recSalesLine."Cant. Pte no anulada" > recSalesLine."Cantidad transferencia") THEN
                                LineasPendientes := FALSE;
                        UNTIL recSalesLine.NEXT = 0;

                    IF LineasPendientes THEN
                        logError(SalesHeader, 'No hay lineas con cantidad pendientes para transferir');
                    EXIT(FALSE);
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

                    UNTIL recSalesLine.NEXT = 0;

                    IF NOT SinVentanas THEN //3536 - MEP 2022 02 14
                        MESSAGE('Pedidos de transferencia creados:\' + Documentos);

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
                    GetSourceDocuments.USEREQUESTPAGE(false);
                    GetSourceDocuments.SETTABLEVIEW(WhseRqst);
                    GetSourceDocuments.SetHideDialog(SinVentanas); //EX-SGG-WMS 180719

                    GetSourceDocuments.EnvioAlmacenCantidadAEnviar(EsCantidadAEnviar); //EX-SGG-WMS 040919
                    GetSourceDocuments.RUNMODAL;

                    WareHouseShipmentLine.SetRange("Source Type", 37);
                    WareHouseShipmentLine.SetRange("Source Subtype", "Document Type");
                    WareHouseShipmentLine.SetRange("Source No.", "No.");
                    if WareHouseShipmentLine.FindFirst() then begin
                        lRstTMPEnvioAlm.SetRange("No.", WareHouseShipmentLine."No.");
                        if lRstTMPEnvioAlm.FindFirst() then;
                    end;

                    // IF lRstTMPEnvioAlm.FINDFIRST THEN BEGIN
                    //     logError(SalesHeader, 'Variable temporal con registros');
                    //     EXIT(FALSE);
                    // END;

                    //  GetSourceDocumentsCodeunit.DevuelveEnviosAlmGenerados(lRstTMPEnvioAlm);
                    IF lRstTMPEnvioAlm.FINDSET THEN
                        REPEAT
                            WhseShptHeader.GET(lRstTMPEnvioAlm."No.");
                            EstableceTipoyCodOrigenEnEnvio(WhseShptHeader, WhseShptHeader."Tipo origen"::Cliente, SalesHeader."Sell-to Customer No.");

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
                            WhseShptHeader."Shipping No." := WhseShptHeader."No.";
                            WhseShptHeader.MODIFY(TRUE);
                            //FIN EX-SGG-WMS 190619
                            EstableceTipoEntrega(WhseShptHeader, SalesHeader."No."); //EX-SGG-WMS 110719
                        UNTIL lRstTMPEnvioAlm.NEXT = 0; //EX-SGG 040620

                    GetSourceDocuments.GetLastShptHeader(WhseShptHeader);

                    IF NOT SinVentanas THEN //EX-SGG-WMS 180719
                        Page.RUN(Page::"Warehouse Shipment", WhseShptHeader);
                    RstCabEnvio := WhseShptHeader; //EX-SGG-WMS 180719
                END
                ELSE BEGIN //EX-SGG-WMS 250919
                           //3724 p6
                    logError(SalesHeader, 'No existe ' + WhseRqst.TABLECAPTION + ':\' + WhseRqst.GETFILTERS);
                    EXIT(FALSE);
                END;
            END;
        END;

        //EX-CV
        //UpdateFieldTEntrega(SalesHeader);
        //    CheckTransfersLines;

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
    end;



    procedure logError(salesHeader: Record "Sales Header"; error: Text[1024])
    var
        IncidenciasGenpedidosWeb: Record "Incidencias Gen. pedidos Web";
    begin
        IncidenciasGenpedidosWeb.RESET;
        IncidenciasGenpedidosWeb.INIT;
        IncidenciasGenpedidosWeb."Numero pedido" := salesHeader."No.";
        //TODO
        //IncidenciasGenpedidosWeb.Numerolinea := IncidenciasGenpedidosWeb.GetLineNo(salesHeader."No.");
        //TODO
        IncidenciasGenpedidosWeb."Estado Error" := IncidenciasGenpedidosWeb."Estado Error"::Consolidado;
        IncidenciasGenpedidosWeb."Fecha error" := TODAY;
        IncidenciasGenpedidosWeb."Hora Error" := TIME;
        IncidenciasGenpedidosWeb."Descripción error" := error;
        //  IncidenciasGenpedidosWeb.INSERT;
    end;




    procedure CheckTransfersLines()
    var

        _recTransferLineAux: Record "Transfer Line";
        _recLineCheckTemp: Record Item;
        _lineNoFilter: Integer;
        _recTransferLineAux2: Record "Transfer Line";
        _recTransferLineAuxTempCheck: Record "Transfer Line";
    begin
        //EX-CV //EX 20220503
        _recTransferLineAuxTempCheck.DELETEALL;

        _recTransferLineAux.RESET;
        _recTransferLineAux.SETRANGE("Document No.", globalTransferCode);
        IF _recTransferLineAux.FINDSET THEN
            REPEAT
                _recLineCheckTemp.RESET;
                _recLineCheckTemp.SETRANGE("No.", FORMAT(_recTransferLineAux."PfsMatrix Line No."));
                IF NOT _recLineCheckTemp.FINDFIRST THEN BEGIN
                    _recLineCheckTemp.INIT;
                    _recLineCheckTemp."No." := FORMAT(_recTransferLineAux."PfsMatrix Line No.");
                    _recLineCheckTemp.INSERT();
                END;
            UNTIL _recTransferLineAux.NEXT = 0;

        _recLineCheckTemp.RESET;
        IF _recLineCheckTemp.FINDSET THEN
            REPEAT
                EVALUATE(_lineNoFilter, _recLineCheckTemp."No.");

                _recTransferLineAux.RESET;
                _recTransferLineAux.SETRANGE("Document No.", globalTransferCode);
                _recTransferLineAux.SETRANGE("No. linea pedido", _lineNoFilter);
                _recTransferLineAux.SETRANGE(PfsSubline, FALSE);
                IF NOT _recTransferLineAux.FINDFIRST THEN BEGIN
                    _recTransferLineAux.RESET;
                    _recTransferLineAux.SETRANGE("Document No.", globalTransferCode);
                    _recTransferLineAux.SETRANGE(PfsSubline, FALSE);
                    _recTransferLineAux.SETRANGE("PfsMatrix Line No.", _lineNoFilter);
                    IF NOT _recTransferLineAux.FINDFIRST THEN BEGIN
                        _recTransferLineAux.RESET;
                        _recTransferLineAux.SETRANGE("Document No.", globalTransferCode);
                        _recTransferLineAux.SETRANGE("PfsMatrix Line No.", _lineNoFilter);
                        _recTransferLineAux.SETRANGE(PfsSubline, TRUE);
                        IF _recTransferLineAux.FINDFIRST THEN BEGIN
                            _recTransferLineAuxTempCheck.RESET;
                            _recTransferLineAuxTempCheck.SETRANGE("Document No.", globalTransferCode);
                            _recTransferLineAuxTempCheck.SETRANGE("PfsMatrix Line No.", _lineNoFilter);
                            IF NOT _recTransferLineAuxTempCheck.FINDFIRST THEN BEGIN
                                _recTransferLineAux.PfsSubline := FALSE;
                                _recTransferLineAux.MODIFY(FALSE);

                                _recTransferLineAuxTempCheck.INIT;
                                _recTransferLineAuxTempCheck.TRANSFERFIELDS(_recTransferLineAux);
                                IF _recTransferLineAuxTempCheck.INSERT(FALSE) THEN;
                            END;
                        END;
                    END;
                END;

            UNTIL _recLineCheckTemp.NEXT = 0;
    end;

    procedure EstableceTipoEntrega(VAR lRstCabEnv: Record "Warehouse Shipment Header"; lCodPedidoVenta: Code[20])
    var
        lRstCabVenta: Record "Sales Header";
        WareHouseEvento: Codeunit 50200;
    begin
        //EX-SGG-WMS 110719
        CASE lRstCabEnv."Tipo origen" OF
            lRstCabEnv."Tipo origen"::Cliente:
                BEGIN
                    lRstCabVenta.GET(lRstCabVenta."Document Type"::Order, lCodPedidoVenta);
                    lRstCabEnv.VALIDATE("Tipo de entrega", lRstCabVenta."Tipo de entrega");

                    //EX-SGG-WMS 291119
                    IF lRstCabEnv."Tipo de entrega" = '' THEN
                        lRstCabEnv.VALIDATE("Tipo de entrega", '1');
                    IF (lRstCabEnv."Tipo de entrega" = '1') AND (WareHouseEvento.ExistenLinsAsignacionDirecta(lRstCabEnv.TABLENAME, lRstCabEnv."No.")) THEN
                        //lRstCabEnv.VALIDATE("Tipo de entrega",'4')
                        lRstCabEnv.VALIDATE("Tipo de entrega", '7') //EX-SGG-WMS 050220
                                                                    //FIN EX-SGG-WMS 291119

                END;
            lRstCabEnv."Tipo origen"::Proveedor:
                BEGIN
                    lRstCabEnv.VALIDATE("Tipo de entrega", '1');
                END;
        END;
        lRstCabEnv.MODIFY(TRUE);
    END;

    procedure EstableceTipoyCodOrigenEnEnvio(VAR lRstCabEnv: Record "Warehouse Shipment Header"; lTipoOrigen: Enum TipoOrigen; lCodOrigen: Code[20])
    begin
        //EX-SGG-WMS 170619
        lRstCabEnv.VALIDATE("Tipo origen", lTipoOrigen);
        IF lCodOrigen <> '0' THEN //EX-SGG-WMS 270919
            lRstCabEnv.VALIDATE("Cod. origen", lCodOrigen)
        ELSE BEGIN
            lRstCabEnv."Cod. origen" := lCodOrigen;
            lRstCabEnv."Fecha servicio solicitada" := WORKDATE;
        END;
        lRstCabEnv.MODIFY(TRUE);
    END;

    procedure CreateFromOutbndTransferOrder(TransHeader: Record "Transfer Header")
    var

        WhseRqst: Record "Warehouse Request";
        WhseShptHeader: Record "Warehouse Shipment Header";
        //  GetSourceDocuments: Report "Get Source Documents";
        GetSourceDocuments: Report "Get Source Documents1";

        lRstTMPEnvioAlm: Record "Warehouse Shipment Header";
        WareHouseShipmentLine: Record "Warehouse Shipment Line";
    begin
        WITH TransHeader DO BEGIN
            TESTFIELD(Status, Status::Released);
            WhseRqst.SETRANGE(Type, WhseRqst.Type::Outbound);
            WhseRqst.SETRANGE("Source Type", DATABASE::"Transfer Line");
            WhseRqst.SETRANGE("Source Subtype", 0);
            WhseRqst.SETRANGE("Source No.", "No.");
            WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
            WhseRqst.SETRANGE("Completely Handled", FALSE); //EX-SGG-WMS 250919

            IF WhseRqst.FIND('-') THEN BEGIN
                GetSourceDocuments.USEREQUESTpage(FALSE);
                GetSourceDocuments.SETTABLEVIEW(WhseRqst);
                GetSourceDocuments.SetHideDialog(SinVentanas);//3536 - MEP - 2022 02 15
                GetSourceDocuments.RUNMODAL;


                WareHouseShipmentLine.SetRange("Source Type", 37);
                //  WareHouseShipmentLine.SetRange("Source Subtype", "Document Type");
                WareHouseShipmentLine.SetRange("Source No.", "No.");
                if WareHouseShipmentLine.FindFirst() then begin
                    lRstTMPEnvioAlm.SetRange("No.", WareHouseShipmentLine."No.");
                    // if lRstTMPEnvioAlm.FindFirst() then;
                end;

                //EX-SGG 040620
                //  IF lRstTMPEnvioAlm.FINDFIRST THEN ERROR('Variable temporal con registros');
                //  GetSourceDocuments.DevuelveEnviosAlmGenerados(lRstTMPEnvioAlm);
                IF lRstTMPEnvioAlm.FINDSET THEN
                    REPEAT
                        WhseShptHeader.GET(lRstTMPEnvioAlm."No.");
                        WhseShptHeader."Shipping No." := WhseShptHeader."No.";
                        //EstableceTipoyCodOrigenEnEnvio(WhseShptHeader, WhseShptHeader."Tipo origen"::Cliente, WhseShptHeader."Cod Cliente");
                        EstableceTipoyCodOrigenEnEnvio(WhseShptHeader, WhseShptHeader."Tipo origen"::Cliente, TransHeader."Cod. cliente");
                        EstableceTipoEntrega(WhseShptHeader, TransHeader."No. pedido venta");

                    UNTIL lRstTMPEnvioAlm.NEXT = 0; //EX-SGG 040620
                GetSourceDocuments.GetLastShptHeader(WhseShptHeader);
                IF NOT SinVentanas THEN //3536 - MEP 2022 02 14
                    page.RUN(Page::"Warehouse Shipment", WhseShptHeader);
            END
            ELSE //EX-SGG-WMS 250919
                ERROR('No existe ' + WhseRqst.TABLECAPTION + ':\' + WhseRqst.GETFILTERS);

        END;
    end;

    procedure CreateHeaderTransfer(SalesLine2: Record "Sales Line")
    var
        recInventorySetup: Record "Inventory Setup";
        NoSeriesMgnt: Codeunit NoSeriesManagement;
        recSalesHeader: Record "Sales Header";
        lCduWMS: Codeunit "WareHouse Eventos";
    begin
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

        recTransferHeader.VALIDATE("Tipo de entrega", recSalesHeader."Tipo de entrega");
        IF recTransferHeader."Tipo de entrega" = '' THEN
            recTransferHeader.VALIDATE("Tipo de entrega", '1');

        IF (recTransferHeader."Tipo de entrega" = '1') AND
           (lCduWMS.ExistenLinsAsignacionDirecta(recTransferHeader.TABLENAME, recTransferHeader."No.")) THEN
            recTransferHeader.VALIDATE("Tipo de entrega", '7');

        IF NOT EsCantidadAEnviar THEN
            recTransferHeader."Envio total" := TRUE;

        //EX-CV END
        recTransferHeader.MODIFY;
        Documentos += recTransferHeader."No." + '\';
        IF VerificaAlmSEGA(SalesLine2."Location Code") THEN BEGIN
            TransferHeaderTemp := recTransferHeader;
            TransferHeaderTemp.INSERT;
        END;

    END;



    procedure CreateLinesTransfer(SalesLine2: Record "Sales Line")
    var
        NoLinea: Integer;
        CantidadPedTransferencia: Decimal;
        InrecTransferLine: Record "Transfer Line";
    begin
        //EX.CGR.290920
        //EX-CV  -  2742  -  2021 05 26
        IF EsCantidadAEnviar THEN
            IF SalesLine2."Qty. to Ship" = 0 THEN
                EXIT;
        //EX-CV  -  2742  -  2021 05 26 END
        InrecTransferLine.SetRange("Document No.", recTransferHeader."No.");
        if InrecTransferLine.FindLast() then begin
            NoLinea := InrecTransferLine."Line No.";
            NoLinea += 10000;
        end else begin
            NoLinea := 10000;
        end;
        recTransferLine.INIT;
        recTransferLine."Document No." := recTransferHeader."No.";
        //  NoLinea += 10000;
        recTransferLine."Line No." := NoLinea;
        recTransferLine.INSERT(true);

        recTransferLine.VALIDATE("Item No.", SalesLine2."No.");
        recTransferLine.VALIDATE("Variant Code", SalesLine2."Variant Code");
        IF SalesLine2."Bin Code" <> '' THEN
            recTransferLine.VALIDATE("Transfer-from Bin Code", SalesLine2."Bin Code");
        recTransferLine.VALIDATE("Shortcut Dimension 1 Code", SalesLine2."Shortcut Dimension 1 Code");
        recTransferLine.VALIDATE("Shortcut Dimension 2 Code", SalesLine2."Shortcut Dimension 2 Code");
        recTransferLine."No. pedido" := SalesLine2."Document No.";
        recTransferLine."No. linea pedido" := SalesLine2."Line No.";
        recTransferLine."Bulto No." := 1;
        recTransferLine."Shortcut Dimension 1 Code" := SalesLine2."Shortcut Dimension 1 Code";
        recTransferLine."PfsMatrix Line No." := SalesLine2."PfsMatrix Line No.";
        recTransferLine.PfsSubline := SalesLine2.PfsSubline;

        IF EsCantidadAEnviar THEN BEGIN
            recTransferLine.VALIDATE(Quantity, SalesLine2."Qty. to Ship");

        END ELSE BEGIN


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
        END;

        globalTransferCode := recTransferLine."Document No.";

        recTransferLine.MODIFY;
    end;

    procedure VerificaAlmSEGA(CodAlmacen: Code[10]): Boolean
    var
        Location: Record Location;
    begin
        Location.GET(CodAlmacen);
        IF (Location."Clase de Stock SEGA" <> '') AND (Location."Estado Calidad SEGA" <> '') THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE)
    END;

    var
        myInt: Integer;

        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        SinVentanas: Boolean;
        globalTransferCode: Code[20];
        LAlmacen: Code[20];
        PfsCustomer: Record Customer;
        Documentos: Code[20];
        TransferHeaderTemp: Record "Transfer Header" temporary;
        recTransferHeader: Record "Transfer Header";
        RstCabEnvio: Record "Warehouse Shipment Header";
        recTransferLine: Record "Transfer Line";
        EsCantidadAEnviar: Boolean;
        LineasPendientes: Boolean;
        recSalesLine: Record "Sales Line";
        WhseRqst: Record "Warehouse Request";


    // [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnAfterSalesLineOnPreDataItem', '', false, false)]
    // procedure OnAfterSalesLineOnPreDataItem(var SalesLine: Record "Sales Line"; OneHeaderCreated: Boolean; WhseShptHeader: Record "Warehouse Shipment Header"; WhseReceiptHeader: Record "Warehouse Receipt Header")
    // begin
    //     if EsCantidadAEnviar then
    //         IF EsCantidadAEnviar THEN SalesLine.SETFILTER("Qty. to Ship", '>0');
    // end;

    procedure EnvioAlmacenCantidadAEnviar(lEsCantidadAEnviar: Boolean)
    begin
        EsCantidadAEnviar := lEsCantidadAEnviar;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Transfer Warehouse Mgt.", 'OnFromTransLine2ShptLineOnAfterInitNewLine', '', false, false)]
    procedure OnFromTransLine2ShptLineOnAfterInitNewLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; TransferLine: Record "Transfer Line")
    begin

        //    WarehouseShipmentLine.PfsSubline := TransferLine.PfsSubline;
        //    WarehouseShipmentLine."PfsMatrix Line No." := TransferLine."PfsMatrix Line No.";
        WarehouseShipmentLine."Cod. temporada" := TransferLine."Shortcut Dimension 1 Code";

    end;

    // [EventSubscriber(ObjectType::Table, Database::"Warehouse Shipment Line", 'OnBeforeInitOutstandingQtys', '', false, false)]
    // procedure OnBeforeInitOutstandingQtys(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    // begin
    //     Message('%1', WarehouseShipmentLine."Qty. to Ship");
    // end;

}