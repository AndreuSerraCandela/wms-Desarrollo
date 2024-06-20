/// <summary>
/// Codeunit "WareHouse Eventos" (ID 50200).
/// </summary>
codeunit 50200 "WareHouse Eventos"
{
    //trigger
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Shipment Release", 'OnBeforeReopen', '', false, false)]
    local procedure OnBeforeReopen(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var IsHandled: Boolean)
    begin
        WarehouseShipmentHeader.CompruebaEnviadoASEGA(); //EX-SGG-WMS 260619

        //EX-SGG-WMS 230719
        IF WarehouseShipmentHeader.Obtenido THEN
            IF NOT CONFIRM('El envío ya ha sido obtenido para ser integrado con SEGA. ¿Desea continuar?', FALSE) THEN
                EXIT;
        //FIN EX-SGG-WMS

        // Pfs7.60
        PfsSetup.GET();
        IF NOT (PfsSetup."Warehouse Shipment Posting" = PfsSetup."Warehouse Shipment Posting"::MyValue) THEN BEGIN
            //PfsQueueMgt.SetWarehouseShipment(WhseShptHeader, 0);
            SetWarehouseShipment(WarehouseShipmentHeader, 0);
            IF QueueAlreadyExists() THEN
                ERROR(Text11006041, WarehouseShipmentHeader.TABLECAPTION);
        END;
        // *
    end;

    procedure DevuelveEnviosAlmGenerados(VAR lRstTMPEnvioAlm: Record "Warehouse Shipment Header" temporary)
    var
        RstTMPEnvioAlm: Record "Warehouse Shipment Header";
    begin
        RstTMPEnvioAlm := lRstTMPEnvioAlm;
        //EX-SGG-WMS 040620
        IF RstTMPEnvioAlm.FINDSET THEN
            REPEAT
                lRstTMPEnvioAlm.TRANSFERFIELDS(RstTMPEnvioAlm);
                lRstTMPEnvioAlm.INSERT;
            UNTIL RstTMPEnvioAlm.NEXT = 0;
    end;

    procedure DevuelveRecepAlmGenerados(VAR lRstTMPRecepAlm: Record "Warehouse Receipt Header" temporary; RstTMPRecepAlm: Record "Warehouse Receipt Header")
    begin
        //EX-SGG-WMS 040620
        IF RstTMPRecepAlm.FINDSET THEN
            REPEAT
                lRstTMPRecepAlm.TRANSFERFIELDS(RstTMPRecepAlm);
                lRstTMPRecepAlm.INSERT;
            UNTIL RstTMPRecepAlm.NEXT = 0;
    end;

    //EX-SGG-WMS 120620 ELIMINIO CODIGO DE EX-SMN-WMS 071119 PARA SER COMPROBADO EN  ReleaseWhseShptDoc.Release(Rec);

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Shipment Release", 'OnBeforeRelease', '', false, false)]
    local procedure OnBeforeRelease(var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        PermiteLanzarEnvio(WarehouseShipmentHeader, TRUE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Shipment Release", 'OnAfterReleaseWarehouseShipment', '', false, false)]
    local procedure OnAfterReleaseWarehouseShipment(var WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        ActualizaEstadoLineas(WarehouseShipmentHeader, WarehouseShipmentHeader.Status); //EX-SGG-WMS 190619
    end;

    //codeunit 7310

    procedure SetWhseShptHeader(_WhseShptHeader: Record "Warehouse Shipment Header")
    var

    begin

        //3724 p6
        CLEAR(gWhseShptHeader);
        gWhseShptHeader := _WhseShptHeader;
        //3724 p6 END
    end;

    procedure GetWhseShptHeader(var _WhseShptHeader: Record "Warehouse Shipment Header")
    begin

        _WhseShptHeader := gWhseShptHeader;

    end;

    procedure comprobarStock(producto: Code[20]; almacen: Code[10]; variante: Code[10]; cantidad: Decimal)
    var
        rItem: Record Item;
    begin

        // NM-JMT-20240117
        // Función para compruobar el stock de un producto y variante en un determinado almacen.
        // Si la cantidad de la línea es mayor que la difencia entre cantidades de inventario y pendiente de envío, devuelve error
        // [Cant línea] > ([Cant. Inventario] - [Cant env. Pdtes]  --> ERROR
        rItem.RESET;
        rItem.GET(producto);
        rItem.SETFILTER("Location Filter", almacen);
        rItem.SETFILTER("Variant Filter", variante);

        // Recalcular flowfields
        rItem.CALCFIELDS(Inventory);
        rItem.CALCFIELDS("Qty Shipment Sales");

        // Comparar con la cantidad de la línea del pedido, si no hay suficiente -> ERROR
        IF (rItem.Inventory - rItem."Qty Shipment Sales") < cantidad THEN
            ERROR('No hay cantidad suficiente en almacén %1 del producto %2 y variante %3', almacen, producto, variante);

    end;


    //CODEUNIT 7310
    procedure PermiteLanzarEnvio(var lRstCabEnv: Record "Warehouse Shipment Header"; lMostrarError: Boolean): Boolean
    var
    // CduFunciones: Codeunit funciones;
    begin

        //EX-SGG-WMS 110719
        //EX-SGG-WMS 170619
        IF lMostrarError THEN BEGIN
            lRstCabEnv.TESTFIELD("Tipo origen");
            lRstCabEnv.TESTFIELD("Cod. origen");
            lRstCabEnv.TESTFIELD("Tipo de entrega"); //EX-SGG-WMS 120620
        END
        ELSE BEGIN
            IF NOT (lRstCabEnv."Tipo origen" IN [lRstCabEnv."Tipo origen"::Cliente, lRstCabEnv."Tipo origen"::Proveedor]) THEN
                EXIT(FALSE);
            IF lRstCabEnv."Cod. origen" = '' THEN
                EXIT(FALSE);
            IF lRstCabEnv."Tipo de entrega" = '' THEN
                EXIT(FALSE);
            ; //EX-SGG-WMS 120620
        END;
        //IF lRstCabEnv."Tipo origen"=lRstCabEnv."Tipo origen"::Cliente THEN
        IF (lRstCabEnv."Tipo origen" = lRstCabEnv."Tipo origen"::Cliente) AND (lRstCabEnv."Cod. origen" <> '0') THEN //EX-SGG-WMS 270919
         BEGIN

            /*
                        CLEAR(CduFunciones);
                        IF CduFunciones.Vencimiento15(lRstCabEnv."Cod. origen") THEN
                            IF lMostrarError THEN
                                ERROR('No es posible lanzar el envío almacén. El cliente ' + lRstCabEnv."Cod. origen" + ' tiene saldos vencidos.')
                            ELSE
                                EXIT(FALSE);
                        IF CduFunciones.RiesgoCliente(lRstCabEnv."Cod. origen") < 0 THEN //EX-SGG-WMS 110719
                            IF lMostrarError THEN
                                ERROR('No es posible lanzar el envío almacén. El cliente ' + lRstCabEnv."Cod. origen" + ' no tiene riesgo disponible')
                            ELSE
                                EXIT(FALSE);

                       */
        END;
        //FIN EX-SGG-WMS 170619
        //EXIT(CompruebaLineasAsignacionDirec(lRstCabEnv, lMostrarError)); //EX-SGG-WMS 110719
    end;

    procedure ActualizaEstadoLineas(VAR lRstCabEnvAlm: Record "Warehouse Shipment Header"; lEstado: Option)

    var

        lRstLinEnvAlm: Record "Warehouse Shipment Line";
    begin

        //EX-SGG-WMS 190619
        lRstLinEnvAlm.SETRANGE(lRstLinEnvAlm."No.", lRstCabEnvAlm."No.");
        lRstLinEnvAlm.MODIFYALL(lRstLinEnvAlm."Estado cabecera", lEstado, TRUE);
    end;




    procedure SetWarehouseShipment(NewWhseShipmentHeader: Record "Warehouse Shipment Header"; Selection: Integer)
    var
        PostQueueEntry: Record PfsPostingQuee;
    begin

        PostQueueEntry."Source Type" := DATABASE::"Warehouse Shipment Header";
        PostQueueEntry."Source ID" := NewWhseShipmentHeader."No.";
        PostQueueEntry.Ship := Selection IN [1, 2];
        PostQueueEntry.Invoice := Selection IN [2];
    end;

    procedure QueueAlreadyExists(): Boolean
    var
        PostQueueEntry2: Record PfsPostingQuee;
    begin

        SetQueueFilter(PostQueueEntry2);
        PostQueueEntry2.SETRANGE(Status, PostQueueEntry2.Status::"Ready for Posting");
        EXIT(PostQueueEntry2.FIND('-'));
    end;

    procedure SetQueueFilter(var PostQueueEntry2: Record PfsPostingQuee)
    begin

        PostQueueEntry2.RESET();
        PostQueueEntry2.SETCURRENTKEY("Source Type", "Source Subtype", "Source ID", "Source Batch Name",
                                      "Source Prod. Order Line", "Source Ref. No.");
        PostQueueEntry2.SETRANGE("Source Type", PostQueueEntry."Source Type");
        PostQueueEntry2.SETRANGE("Source Subtype", PostQueueEntry."Source Subtype");
        PostQueueEntry2.SETRANGE("Source ID", PostQueueEntry."Source ID");
        PostQueueEntry2.SETRANGE("Source Batch Name", PostQueueEntry."Source Batch Name");
        PostQueueEntry2.SETRANGE("Source Prod. Order Line", PostQueueEntry."Source Prod. Order Line");
        PostQueueEntry2.SETRANGE("Source Ref. No.", PostQueueEntry."Source Ref. No.");
    end;







    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforeCheckUnitOfMeasureCode', '', false, false)]
    local procedure OnBeforeCheckUnitOfMeasureCode(WarehouseReceiptLine: Record "Warehouse Receipt Line"; var IsHandled: Boolean)
    begin
        // Pfs9.02
        CASE WarehouseReceiptLine."Source Document" OF
            WarehouseReceiptLine."Source Document"::"Purchase Order":
                //TODO
                //  PfsItemBlocked(FALSE, '1');
                Message('FALSE 1');
            WarehouseReceiptLine."Source Document"::"Sales Return Order":
                //PfsItemBlocked(FALSE, 'G');
                Message('FALSE G');
        END;
        // *
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", 'OnAfterFindWarehouseRequestForSalesReturnOrder', '', false, false)]
    local procedure OnAfterFindWarehouseRequestForSalesReturnOrder(var WarehouseRequest: Record "Warehouse Request"; SalesHeader: Record "Sales Header")
    var
        WhseRcptHeader: Record "Warehouse Receipt Header";
        GetSourceDocuments: Report "Get Source Documents";
        lRstTMPRecepAlm: Record "Warehouse Receipt Header";
    begin
        IF WarehouseRequest.FIND('-') THEN BEGIN
            GetSourceDocuments.UseRequestPage(FALSE);
            GetSourceDocuments.SETTABLEVIEW(WarehouseRequest);
            GetSourceDocuments.RUNMODAL;

            //EX-SGG 040620
            IF lRstTMPRecepAlm.FINDFIRST THEN ERROR('variable temporal con registros');
            //TODO
            //GetSourceDocuments.DevuelveRecepAlmGenerados(lRstTMPRecepAlm);
            IF lRstTMPRecepAlm.FINDSET THEN
                REPEAT
                    WhseRcptHeader.GET(lRstTMPRecepAlm."No.");
                    //FIN EX-SGG 040620
                    EstableceTipoyCodOrigenEnRecep(WhseRcptHeader, WhseRcptHeader."Tipo origen"::Cliente, SalesHeader."Sell-to Customer No."); //EX-SGG-WMS 140619
                    EstableceTipoOrdenEntrada(WhseRcptHeader, ''); //EX-SGG-WMS 110719
                UNTIL lRstTMPRecepAlm.NEXT = 0; //EX-SGG 040620

            GetSourceDocuments.GetLastReceiptHeader(WhseRcptHeader);
            PAGE.RUN(Page::"Warehouse Receipt", WhseRcptHeader);
        END
        ELSE //EX-SGG-WMS 250919
            ERROR('No existe ' + WarehouseRequest.TABLECAPTION + ':\' + WarehouseRequest.GETFILTERS);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", 'OnAfterFindWarehouseRequestForInbndTransferOrder', '', false, false)]
    local procedure OnAfterFindWarehouseRequestForInbndTransferOrder(var WarehouseRequest: Record "Warehouse Request"; TransferHeader: Record "Transfer Header")
    var

        WhseRcptHeader: Record "Warehouse Receipt Header";
        GetSourceDocuments: Report 5753;

        lRstTMPRecepAlm: Record "Warehouse Receipt Header" temporary;
    begin
        //EX-SGG 040620
        IF lRstTMPRecepAlm.FINDFIRST THEN ERROR('variable temporal con registros');
        //TODO
        //GetSourceDocuments.DevuelveRecepAlmGenerados(lRstTMPRecepAlm);
        IF lRstTMPRecepAlm.FINDSET THEN begin
            REPEAT
                WhseRcptHeader.GET(lRstTMPRecepAlm."No.");
            //FIN EX-SGG 040620
            //  EstableceTipoyCodOrigenEnRecep(WhseRcptHeader, WhseRcptHeader."Tipo origen"::Proveedor, '0'); //EX-SGG-WMS 270919
            UNTIL lRstTMPRecepAlm.NEXT = 0; //EX-SGG 040620

            GetSourceDocuments.GetLastReceiptHeader(WhseRcptHeader);
            Page.RUN(PAGE::"Warehouse Receipt", WhseRcptHeader);
        END;
        // END ELSE //EX-SGG-WMS 250919
        //     ERROR('No existe ' + WarehouseRequest.TABLECAPTION + ':\' + WarehouseRequest.GETFILTERS);
    END;

    procedure EliminarRegistroControl(VAR lRstControlWMS: Record "Control integracion WMS")
    var
        lNoRegControl: Integer;
    begin
        /*
                //EX-SGG 120619
                lRstControlWMS.TESTFIELD(Estado, lRstControlWMS.Estado::Pendiente);
                CASE lRstControlWMS."Tipo documento" OF
                    lRstControlWMS."Tipo documento"::"Recepcion almacen":
                        BEGIN
                            RstCabRecepAlm.GET(lRstControlWMS."No. documento");
                            RstCabRecepAlm.VALIDATE(Obtenido, FALSE);
                            RstCabRecepAlm.MODIFY;
                            EliminarRegistrosOE(lRstControlWMS."No. documento"); //EX-SGG-WNS 190719
                        END;
                    lRstControlWMS."Tipo documento"::"Envio almacen":
                        BEGIN
                            RstCabEnvAlm.GET(lRstControlWMS."No. documento");
                            RstCabEnvAlm.VALIDATE(Obtenido, FALSE);
                            RstCabEnvAlm.MODIFY;
                            EliminarRegistrosPE(lRstControlWMS."No. documento"); //EX-SGG-WMS 190719
                        END;
                    lRstControlWMS."Tipo documento"::Stock: //EX-SGG-WMS 150719
                        BEGIN
                            CASE lRstControlWMS.Interface OF
                                lRstControlWMS.Interface::"AS-Ajuste de Stock":
                                    BEGIN
                                        RstAS.RESET;
                                        RstAS.SETCURRENTKEY(numeroMensaje);
                                        RstAS.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA"); //EX-SGG-WMS 261219
                                        RstAS.DELETEALL(TRUE);
                                    END;
                                lRstControlWMS.Interface::"SA-Stock Actual":
                                    BEGIN
                                        RstSA.RESET;
                                        RstSA.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA"); //EX-SGG-WMS 261219
                                        RstSA.DELETEALL(TRUE);
                                    END;
                            END;
                        END;
                END;

                //EX-SGG-WMS 180619
                RstLOG.RESET;
                RstLOG.SETCURRENTKEY("No. registro control rel.");
                RstLOG.SETRANGE("No. registro control rel.", lRstControlWMS."No. registro");
                RstLOG.DELETEALL(TRUE);
                lRstControlWMS.DELETELINKS;
                //FIN EX-SGG-WMS 180619

                //EX-SGG-WMS 280120
                lNoRegControl := lRstControlWMS."No. registro";
                lRstControlWMS."No. registro" := 0;
                InsertarRegistroLOG(lRstControlWMS, FALSE, 'Registro eliminado por el usuario ' + USERID);
                lRstControlWMS."No. registro" := lNoRegControl;
                //FIN EX-SGG-WMS 280120
                */
    end;

    procedure ValidarEstadoRegistroControl(VAR lRstControlWMS: Record "Control integracion WMS")
    var
        myInt: Integer;
        RstOE: Record "WMS OE-Ordenes de Entrada";
        RstPE: Record "WMS PE-Pedidos";
        RstCE: Record "WMS CE-Confirmación de Entrada";
        RstCS: Record "WMS CS-Confirmacion de Salidas";
    begin

        //EX-SGG-WMS 030719
        CASE lRstControlWMS.Interface OF
            lRstControlWMS.Interface::"OE-Orden de Entrada":
                BEGIN
                    RstOE.RESET();
                    RstOE.SETCURRENTKEY(codigoOrdenEntrada);
                    RstOE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                    //EX-SGG-WMS 181219
                    //RstOE.MODIFYALL(Integrado,lRstControlWMS.Estado=lRstControlWMS.Estado::Integrado,TRUE);
                    IF RstOE.FINDSET() THEN
                        REPEAT
                            RstOE.VALIDATE(Integrado, lRstControlWMS.Estado = lRstControlWMS.Estado::Integrado);
                            RstOE.MODIFY(TRUE);
                        UNTIL RstOE.NEXT() = 0;
                    //FIN EX-SGG-WMS 181219
                END;
            lRstControlWMS.Interface::"PE-Pedido":
                BEGIN
                    RstPE.RESET();
                    RstPE.SETCURRENTKEY(codigoEntregaERP);
                    RstPE.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                    //EX-SGG-WMS 181219
                    //RstPE.MODIFYALL(Integrado,lRstControlWMS.Estado=lRstControlWMS.Estado::Integrado,TRUE);
                    IF RstPE.FINDSET() THEN
                        REPEAT
                            RstPE.VALIDATE(Integrado, lRstControlWMS.Estado = lRstControlWMS.Estado::Integrado);
                            RstPE.MODIFY(TRUE);
                        UNTIL RstPE.NEXT() = 0;
                    //FIN EX-SGG-WMS 181219
                END;
            lRstControlWMS.Interface::"CE-Confirmacion de Entrada":
                BEGIN
                    RstCE.RESET();
                    RstCE.SETCURRENTKEY(correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada); //EX-SGG 280819
                    RstCE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                    //EX-SGG-WMS 140720
                    //RstCE.MODIFYALL(Integrado,lRstControlWMS.Estado=lRstControlWMS.Estado::Integrado,TRUE);
                    IF RstCE.FINDSET() THEN
                        REPEAT
                            RstCE.VALIDATE(Integrado, lRstControlWMS.Estado = lRstControlWMS.Estado::Integrado);
                            RstCE.MODIFY(TRUE);
                        UNTIL RstCE.NEXT() = 0;
                    //FIN EX-SGG-WMS 140720
                END;
            lRstControlWMS.Interface::"CS-Confirmacion de Salida":
                BEGIN
                    RstCS.RESET();
                    RstCS.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP); //EX-SGG-WMS 120919
                    RstCS.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                    //EX-SGG-WMS 140720
                    //RstCS.MODIFYALL(Integrado,lRstControlWMS.Estado=lRstControlWMS.Estado::Integrado,TRUE);
                    IF RstCS.FINDSET() THEN
                        REPEAT
                            RstCS.VALIDATE(Integrado, lRstControlWMS.Estado = lRstControlWMS.Estado::Integrado);
                            RstCS.MODIFY(TRUE);
                        UNTIL RstCS.NEXT() = 0;
                    //FIN EX-SGG-WMS 140720
                END;
            lRstControlWMS.Interface::"AS-Ajuste de Stock", lRstControlWMS.Interface::"SA-Stock Actual":
                ;
        //EX-SGG-WMS 150719 NO APLICA PARA AS/SA YA QUE LLEVAN EL ESTADO POR CADA UNO DE LOS REGISTROS.
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", 'OnBeforeGetSingleInboundDoc', '', false, false)]
    local procedure OnBeforeGetSingleInboundDoc(var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; var IsHandled: Boolean)
    begin
        WarehouseReceiptHeader.FIND;
        WarehouseReceiptHeader.TESTFIELD("Tipo origen"); //EX-SGG-WMS 140619
        WarehouseReceiptHeader.TESTFIELD("Cod. origen"); //EX-SGG-WMS 140619
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", 'OnAfterSetWarehouseRequestFilters', '', false, false)]
    local procedure OnAfterSetWarehouseRequestFilters(var WarehouseRequest: Record "Warehouse Request"; WarehouseReceiptHeader: Record "Warehouse Receipt Header")
    begin
        //EX-SGG-WMS 140619
        CASE WarehouseReceiptHeader."Tipo origen" OF
            WarehouseReceiptHeader."Tipo origen"::Cliente:
                WarehouseRequest.SETRANGE("Destination Type", WarehouseRequest."Destination Type"::Customer);
            WarehouseReceiptHeader."Tipo origen"::Proveedor:
                WarehouseRequest.SETRANGE("Destination Type", WarehouseRequest."Destination Type"::Vendor);
        END;
        WarehouseRequest.SETRANGE("Destination No.", WarehouseReceiptHeader."Cod. origen");
        //FIN EX-SGG-WMS 140619
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", 'OnBeforeGetSourceDocForHeader', '', false, false)]
    local procedure OnBeforeGetSourceDocForHeader(var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; var WarehouseRequest: Record "Warehouse Request"; var IsHandled: Boolean; var GetSourceDocuments: Report "Get Source Documents")
    var
        SourceDocSelection: Page "Source Documents";
        CodigoRecepcion: Code[20];
        locrec_WhReceiptHeader: Record "Warehouse Receipt Header";
    begin
        //TODO
        // SourceDocSelection.TraerDocRecepcionAlmacen(CodigoRecepcion);//EX-OMI-WMS 030719

        SourceDocSelection.LOOKUPMODE(TRUE);
        SourceDocSelection.SETTABLEVIEW(WarehouseRequest);
        IF SourceDocSelection.RUNMODAL = ACTION::LookupOK THEN
            EXIT;
        SourceDocSelection.GetResult(WarehouseRequest);

        GetSourceDocuments.SetOneCreatedReceiptHeader(WarehouseReceiptHeader);
        WarehouseRequest.MARKEDONLY(TRUE);
        IF NOT WarehouseRequest.FIND('-') THEN BEGIN
            WarehouseRequest.MARKEDONLY(FALSE);
            WarehouseRequest.SETRECFILTER;
        END;

        CompruebaMismosTiposDocumentos(WarehouseRequest, WarehouseReceiptHeader); //EX-SGG-WMS 140619

        GetSourceDocuments.UseRequestPage(false);
        GetSourceDocuments.SETTABLEVIEW(WarehouseRequest);

        //EX-OMI-WMS 230519
        locrec_WhReceiptHeader.GET(CodigoRecepcion);
        IF locrec_WhReceiptHeader.TraerDocOrigen THEN BEGIN
            //TODO
            //REVISAR ESTA EN EL REPORT 5753 DE NAV2009
            //GetSourceDocuments.ReciboAlmacenCantidadRecibida(TRUE);
            locrec_WhReceiptHeader.TraerDocOrigen := FALSE;
            locrec_WhReceiptHeader.MODIFY;
        END;
        //EX-OMI-WMS fin

        GetSourceDocuments.RUNMODAL;

        IsHandled := true;
    end;

    PROCEDURE CompruebaMismosTiposDocumentos(VAR lRstSolicitudAlm: Record 5765; VAR lRstCabRecep: Record "Warehouse Receipt Header");
    VAR
        lRstLinRecep: Record "Warehouse Receipt Line";
        // lTipoDoc: Integer;
        lTipoDoc: Enum "Warehouse Activity Source Document";
    BEGIN
        //EX-SGG-WMS 140619
        lRstLinRecep.SETRANGE("No.", lRstCabRecep."No.");
        IF lRstLinRecep.FINDFIRST THEN
            lTipoDoc := lRstLinRecep."Source Document";
        IF lRstSolicitudAlm.FINDSET THEN BEGIN
            IF lTipoDoc = lTipoDoc::" " THEN
                lTipoDoc := lRstSolicitudAlm."Source Document";
            REPEAT
                IF lRstSolicitudAlm."Source Document" = lTipoDoc THEN
                    ERROR('No es posible incluir documentos con distinto origen en la misma recepción de almacén');
            UNTIL lRstSolicitudAlm.NEXT = 0;
        END;
    END;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Get Source Doc. Inbound", 'OnAfterFindWarehouseRequestForPurchaseOrder', '', false, false)]
    local procedure OnAfterFindWarehouseRequestForPurchaseOrder(var WarehouseRequest: Record "Warehouse Request"; PurchaseHeader: Record "Purchase Header")
    var
        WhseRcptHeader: Record "Warehouse Receipt Header";
        lRstTMPRecepAlm: Record "Warehouse Receipt Line" temporary;
    begin

        //  EstableceTipoyCodOrigenEnRecep(WhseRcptHeader, WhseRcptHeader."Tipo origen"::Proveedor, PurchaseHeader."Buy-from Vendor No.");//EX-SGG-WMS 140619
        // //EX-SGG 040620
        // IF lRstTMPRecepAlm.FINDFIRST THEN ERROR('variable temporal con registros');
        // //TODO
        // // GetSourceDocuments.DevuelveRecepAlmGenerados(lRstTMPRecepAlm);
        // IF lRstTMPRecepAlm.FINDSET THEN begin
        //     REPEAT
        //         WhseRcptHeader.GET(lRstTMPRecepAlm."No.");
        //         //FIN EX-SGG 040620
        //         //TODO
        //         EstableceTipoyCodOrigenEnRecep(WhseRcptHeader, WhseRcptHeader."Tipo origen"::Proveedor, PurchaseHeader."Buy-from Vendor No.");//EX-SGG-WMS 140619
        //     // EstableceTipoOrdenEntrada(WhseRcptHeader, PurchaseHeader."No."); //EX-SGG-WMS 110719
        //     UNTIL lRstTMPRecepAlm.NEXT = 0; //EX-SGG 040620
        //                                     //REPORT 5753
        //                                     //GetSourceDocuments.GetLastReceiptHeader(WhseRcptHeader);
        //     Page.RUN(PAGE::"Warehouse Receipt", WhseRcptHeader);
        // END
        // ELSE //EX-SGG-WMS 250919
        //     ERROR('No existe ' + WarehouseRequest.TABLECAPTION + ':\' + WarehouseRequest.GETFILTERS);
    end;

    PROCEDURE EstableceTipoyCodOrigenEnRecep(VAR lRstCabRecep: Record "Warehouse Receipt Header"; lTipoOrigen: Integer; lCodOrigen: Code[20]);
    BEGIN
        //EX-SGG-WMS 140619
        lRstCabRecep.VALIDATE("Tipo origen", lTipoOrigen);
        IF lCodOrigen = '0' THEN begin
            lRstCabRecep.VALIDATE("Cod. origen", lCodOrigen)
        END ELSE
            lRstCabRecep."Cod. origen" := lCodOrigen;

        lRstCabRecep.MODIFY(TRUE);
    END;

    PROCEDURE EstableceTipoOrdenEntrada(VAR lRstCabRecep: Record "Warehouse Receipt Header"; lCodPedidoCompra: Code[20]);
    VAR
    // lCduWMS  : Codeunit 50409;
    BEGIN
        //EX-SGG-WMS 110719
        CASE lRstCabRecep."Tipo origen" OF
            lRstCabRecep."Tipo origen"::Proveedor:
                BEGIN
                    IF ExistenLinsAsignacionDirecta(lRstCabRecep.TABLENAME, lRstCabRecep."No.") THEN begin //EX-SGG-WMS 291119
                        lRstCabRecep.VALIDATE(lRstCabRecep."Tipo de Orden de Entrada", '3')
                    END ELSE
                        lRstCabRecep.VALIDATE(lRstCabRecep."Tipo de Orden de Entrada", '1');
                END;
            lRstCabRecep."Tipo origen"::Cliente:
                BEGIN
                    lRstCabRecep.VALIDATE(lRstCabRecep."Tipo de Orden de Entrada", '2');
                END;
        END;

        lRstCabRecep.MODIFY(TRUE);
    END;

    procedure ExistenLinsAsignacionDirecta(lNombreTabla: Text[30]; lNoDoc: Code[20]): Boolean
    var
        RstCabRecepAlm: Record "Warehouse Receipt Header";
        lRstLinRecepAlm: Record "Warehouse Receipt LINE";
        RstCabEnvAlm: Record "Warehouse Shipment Header";
        lRstLinEnvAlm: Record "Warehouse Shipment Line";
        EventoVenta: Codeunit 50210;
    begin

        //EX-SGG-WMS 291119
        CASE lNombreTabla OF
            RstCabEnvAlm.TABLENAME:
                BEGIN
                    lRstLinEnvAlm.SETRANGE("No.", lNoDoc);
                    IF lRstLinEnvAlm.FINDSET THEN
                        REPEAT
                            IF EventoVenta.EsLineaAsignacionDirecta(lRstLinEnvAlm.TABLENAME, lRstLinEnvAlm."Source No.", lRstLinEnvAlm."Source Line No.") THEN
                                EXIT(TRUE);
                        UNTIL lRstLinEnvAlm.NEXT = 0;
                END;
            RstCabRecepAlm.TABLENAME:
                BEGIN
                    lRstLinRecepAlm.SETRANGE("No.", lNoDoc);
                    IF lRstLinRecepAlm.FINDSET THEN
                        REPEAT
                            IF EventoVenta.EsLineaAsignacionDirecta(lRstLinRecepAlm.TABLENAME, lRstLinRecepAlm."Source No.", lRstLinRecepAlm."Source Line No.") THEN
                                EXIT(TRUE);
                        UNTIL lRstLinRecepAlm.NEXT = 0;
                END;
        END;
        EXIT(FALSE);

    end;

    procedure Release(var WhseReceiptHeader: Record "Warehouse Receipt Header")
    var
        Location: Record Location;
        Location2: Record Location;
        WhsePickRqst: Record "Whse. Pick Request";
        WhseReceiptLine: Record "Warehouse Receipt Line";
    //  ATOLink: Record "Assemble-to-Order Link";
    //  AsmLine: Record "Assembly Line";
    begin
        with WhseReceiptHeader do begin
            if Status = Status::Released then
                exit;

            // OnBeforeRelease(WhseReceiptHeader);

            WhseReceiptLine.SetRange("No.", "No.");
            WhseReceiptLine.SetFilter(Quantity, '<>0');

            // CheckWhseShptLinesNotEmpty(WhseReceiptHeader, WhseShptLine);

            if "Location Code" <> '' then
                Location.Get("Location Code");



            //  OnAfterTestWhseShptLine(WhseReceiptHeader, WhseReceiptLine);

            Status := Status::Released;
            Modify();

            //   OnAfterReleaseWarehouseShipment(WhseReceiptHeader);

            //   CreateWhsePickRequest(WhseReceiptHeader);

            // WhsePickRqst.SetRange("Document Type", WhsePickRqst."Document Type"::);
            // WhsePickRqst.SetRange("Document No.", "No.");
            // WhsePickRqst.SetRange(Status, Status::Open);
            // if not WhsePickRqst.IsEmpty() then
            //     WhsePickRqst.DeleteAll(true);
            // if not SuppressCommit then
            //     Commit();
        end;

        //  OnAfterRelease(WhseReceiptHeader, WhseReceiptLine);
    end;

    procedure Reopen(var WhseReceiptHeader: Record "Warehouse Receipt Header")
    var
        WhsePickRqst: Record "Whse. Pick Request";
        PickWkshLine: Record "Whse. Worksheet Line";
        WhseActivLine: Record "Warehouse Activity Line";
        IsHandled: Boolean;
    begin
        with WhseReceiptHeader do begin
            if Status = Status::Open then
                exit;

            IsHandled := false;
            //   OnBeforeReopen(WhseReceiptHeader, IsHandled);
            if IsHandled then
                exit;



            Status := Status::Open;
            Modify();
        end;

        //  OnAfterReopen(WhseReceiptHeader);
    end;

    var

        PfsSetup: Record SetupTallas;
        PostQueueEntry: Record PfsPostingQuee;
        //Text11006041 : TextConst 'ENU=This %1 is already in batch posting queue.;ESP=Este %1 ya se encuentra en la cola de registro.';
        Text11006041: Label 'ESP="Este %1 ya se encuentra en la cola de registro."';
        CODE5764: Codeunit "Whse.-Post Shipment";
        gWhseShptHeader: Record "Warehouse Shipment Header";

}