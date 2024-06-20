codeunit 50403 "Get Source Doc. Inbound WMS"
{
    trigger OnRun()
    begin

    end;



    procedure GetInboundDocs(WhseReceiptHeader: Record "Warehouse Receipt Header")
    var

        WhseGetSourceFilterRec: Record "Warehouse Source Filter";
        WhseSourceFilterSelection: Page "Filters to Get Source Docs.";
    begin

        WhseReceiptHeader.FIND;
        WhseSourceFilterSelection.SetOneCreatedReceiptHeader(WhseReceiptHeader);
        WhseGetSourceFilterRec.FILTERGROUP(2);
        WhseGetSourceFilterRec.SETRANGE(Type, WhseGetSourceFilterRec.Type::Inbound);
        WhseGetSourceFilterRec.FILTERGROUP(0);
        WhseSourceFilterSelection.SETTABLEVIEW(WhseGetSourceFilterRec);
        WhseSourceFilterSelection.RUNMODAL;
    end;



    procedure GetSingleInboundDoc(WhseReceiptHeader: Record "Warehouse Receipt Header")
    var

        WhseRqst: Record "Warehouse Request";
        SourceDocSelection: Page "Source Documents";
        GetSourceDocuments: Report "Get Source Documents";
        locrec_WhReceiptHeader: Record "Warehouse Receipt Header";
    begin


        WhseReceiptHeader.FIND;
        WhseReceiptHeader.TESTFIELD("Tipo origen"); //EX-SGG-WMS 140619
        WhseReceiptHeader.TESTFIELD("Cod. origen"); //EX-SGG-WMS 140619

        WhseRqst.FILTERGROUP(2);
        WhseRqst.SETRANGE(Type, WhseRqst.Type::Inbound);
        WhseRqst.SETRANGE("Location Code", WhseReceiptHeader."Location Code");

        //EX-SGG-WMS 140619
        CASE WhseReceiptHeader."Tipo origen" OF
            WhseReceiptHeader."Tipo origen"::Cliente:
                WhseRqst.SETRANGE("Destination Type", WhseRqst."Destination Type"::Customer);
            WhseReceiptHeader."Tipo origen"::Proveedor:
                WhseRqst.SETRANGE("Destination Type", WhseRqst."Destination Type"::Vendor);
        END;
        WhseRqst.SETRANGE("Destination No.", WhseReceiptHeader."Cod. origen");
        //FIN EX-SGG-WMS 140619

        WhseRqst.FILTERGROUP(0);
        WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
        WhseRqst.SETRANGE("Completely Handled", FALSE);

        SourceDocSelection.TraerDocRecepcionAlmacen(CodigoRecepcion);//EX-OMI-WMS 030719

        SourceDocSelection.LOOKUPMODE(TRUE);
        SourceDocSelection.SETTABLEVIEW(WhseRqst);
        IF SourceDocSelection.RUNMODAL <> ACTION::LookupOK THEN
            EXIT;
        SourceDocSelection.GetResult(WhseRqst);

        GetSourceDocuments.SetOneCreatedReceiptHeader(WhseReceiptHeader);
        WhseRqst.MARKEDONLY(TRUE);
        IF NOT WhseRqst.FIND('-') THEN BEGIN
            WhseRqst.MARKEDONLY(FALSE);
            WhseRqst.SETRECFILTER;
        END;

        CompruebaMismosTiposDocumentos(WhseRqst, WhseReceiptHeader); //EX-SGG-WMS 140619

        GetSourceDocuments.UseRequestPage(FALSE);
        GetSourceDocuments.SETTABLEVIEW(WhseRqst);

        //EX-OMI-WMS 230519
        locrec_WhReceiptHeader.GET(CodigoRecepcion);
        IF locrec_WhReceiptHeader.TraerDocOrigen THEN BEGIN
            //TODO
            // GetSourceDocuments.ReciboAlmacenCantidadRecibida(TRUE);
            locrec_WhReceiptHeader.TraerDocOrigen := FALSE;
            locrec_WhReceiptHeader.MODIFY;
        END;
        //EX-OMI-WMS fin

        GetSourceDocuments.RUNMODAL;

    end;


    procedure CreateFromPurchOrder(PurchHeader: Record "Purchase Header")
    var

        WhseRqst: Record "Warehouse Request";
        WhseRcptHeader: Record "Warehouse Receipt Header";
        //   GetSourceDocuments: Report "Get Source Documents";
        GetSourceDocuments: Report "Get Source Documents1";

        lRstTMPRecepAlm: Record "Warehouse Receipt Header";
        WareHouseReceiptLine: Record "Warehouse Receipt Line";
    begin
        WITH PurchHeader DO BEGIN
            TESTFIELD(Status, Status::Released);
            WhseRqst.SETRANGE(Type, WhseRqst.Type::Inbound);
            WhseRqst.SETRANGE("Source Type", DATABASE::"Purchase Line");
            WhseRqst.SETRANGE("Source Subtype", "Document Type");
            WhseRqst.SETRANGE("Source No.", "No.");
            WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
            WhseRqst.SETRANGE("Completely Handled", FALSE); //EX-SGG-WMS 250919

            IF WhseRqst.FindFirst() THEN BEGIN
                IF EscantidadRecibida THEN
                    GetSourceDocuments.ReciboAlmacenCantidadRecibida(TRUE);//EX-OMI-WMS 210519

                GetSourceDocuments.UseRequestPage(false);
                GetSourceDocuments.SETTABLEVIEW(WhseRqst);
                GetSourceDocuments.RUNMODAL;


                WareHouseReceiptLine.SetRange("Source Type", 39);
                WareHouseReceiptLine.SetRange("Source Subtype", "Document Type");
                WareHouseReceiptLine.SetRange("Source No.", "No.");
                if WareHouseReceiptLine.FindFirst() then begin
                    lRstTMPRecepAlm.SetRange("No.", WareHouseReceiptLine."No.");
                    if lRstTMPRecepAlm.FindFirst() then;
                end;

                //EX-SGG 040620
                // IF lRstTMPRecepAlm.FINDFIRST THEN ERROR('variable temporal con registros');

                //TODO
                //GetSourceDocuments.DevuelveRecepAlmGenerados(lRstTMPRecepAlm);

                IF lRstTMPRecepAlm.FINDSET THEN begin
                    REPEAT
                        WhseRcptHeader.GET(lRstTMPRecepAlm."No.");
                        //FIN EX-SGG 040620
                        EstableceTipoyCodOrigenEnRecep(WhseRcptHeader, WhseRcptHeader."Tipo origen"::Proveedor,
                         "Buy-from Vendor No.");//EX-SGG-WMS 140619

                        WhseRcptHeader."Receiving No." := WhseRcptHeader."No.";
                        WhseRcptHeader.Modify(true);

                        EstableceTipoOrdenEntrada(WhseRcptHeader, PurchHeader."No."); //EX-SGG-WMS 110719
                    UNTIL lRstTMPRecepAlm.NEXT = 0; //EX-SGG 040620
                end;
                GetSourceDocuments.GetLastReceiptHeader(WhseRcptHeader);
                Page.RUN(PAGE::"Warehouse Receipt", WhseRcptHeader);
            END
            ELSE //EX-SGG-WMS 250919
                ERROR('No existe ' + WhseRqst.TABLECAPTION + ':\' + WhseRqst.GETFILTERS);

        END;
    END;


    procedure CreateFromSalesReturnOrder(SalesHeader: Record "Sales Header")
    var

        WhseRqst: Record "Warehouse Request";
        WhseRcptHeader: Record "Warehouse Receipt Header";
        GetSourceDocuments: Report "Get Source Documents";

        lRstTMPRecepAlm: Record "Warehouse Receipt Header";
    begin
        WITH SalesHeader DO BEGIN
            TESTFIELD(Status, Status::Released);
            WhseRqst.SETRANGE(Type, WhseRqst.Type::Inbound);
            WhseRqst.SETRANGE("Source Type", DATABASE::"Sales Line");
            WhseRqst.SETRANGE("Source Subtype", "Document Type");
            WhseRqst.SETRANGE("Source No.", "No.");
            WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
            WhseRqst.SETRANGE("Completely Handled", FALSE); //EX-SGG-WMS 250919

            IF WhseRqst.FIND('-') THEN BEGIN
                GetSourceDocuments.UseRequestPage(FALSE);
                GetSourceDocuments.SETTABLEVIEW(WhseRqst);
                GetSourceDocuments.RUNMODAL;

                //EX-SGG 040620
                IF lRstTMPRecepAlm.FINDFIRST THEN ERROR('variable temporal con registros');
                //TODO
                //  GetSourceDocuments.DevuelveRecepAlmGenerados(lRstTMPRecepAlm);
                IF lRstTMPRecepAlm.FINDSET THEN
                    REPEAT
                        WhseRcptHeader.GET(lRstTMPRecepAlm."No.");
                        //FIN EX-SGG 040620
                        EstableceTipoyCodOrigenEnRecep(WhseRcptHeader, WhseRcptHeader."Tipo origen"::Cliente,
                         "Sell-to Customer No."); //EX-SGG-WMS 140619
                        EstableceTipoOrdenEntrada(WhseRcptHeader, ''); //EX-SGG-WMS 110719
                    UNTIL lRstTMPRecepAlm.NEXT = 0; //EX-SGG 040620

                GetSourceDocuments.GetLastReceiptHeader(WhseRcptHeader);
                PAGE.RUN(PAGE::"Warehouse Receipt", WhseRcptHeader);
            END
            ELSE //EX-SGG-WMS 250919
                ERROR('No existe ' + WhseRqst.TABLECAPTION + ':\' + WhseRqst.GETFILTERS);

        END;

    END;



    procedure CreateFromInbndTransferOrder(TransHeader: Record "Transfer Header")
    var

        WhseRqst: Record "Warehouse Request";
        WhseRcptHeader: Record "Warehouse Receipt Header";
        GetSourceDocuments: Report "Get Source Documents";
        lRstTMPRecepAlm: Record "Warehouse Receipt HeadeR";
    begin
        WITH TransHeader DO BEGIN
            TESTFIELD(Status, Status::Released);
            WhseRqst.SETRANGE(Type, WhseRqst.Type::Inbound);
            WhseRqst.SETRANGE("Source Type", DATABASE::"Transfer Line");
            WhseRqst.SETRANGE("Source Subtype", 1);
            WhseRqst.SETRANGE("Source No.", "No.");
            WhseRqst.SETRANGE("Document Status", WhseRqst."Document Status"::Released);
            WhseRqst.SETRANGE("Completely Handled", FALSE); //EX-SGG-WMS 250919

            IF WhseRqst.FIND('-') THEN BEGIN
                GetSourceDocuments.UseRequestPage(FALSE);
                GetSourceDocuments.SETTABLEVIEW(WhseRqst);
                GetSourceDocuments.RUNMODAL;

                //EX-SGG 040620
                IF lRstTMPRecepAlm.FINDFIRST THEN ERROR('variable temporal con registros');
                //TODO VERO
                //   GetSourceDocuments.DevuelveRecepAlmGenerados(lRstTMPRecepAlm);
                IF lRstTMPRecepAlm.FINDSET THEN
                    REPEAT
                        WhseRcptHeader.GET(lRstTMPRecepAlm."No.");
                        //FIN EX-SGG 040620
                        EstableceTipoyCodOrigenEnRecep(WhseRcptHeader, WhseRcptHeader."Tipo origen"::Proveedor, '0'); //EX-SGG-WMS 270919
                    UNTIL lRstTMPRecepAlm.NEXT = 0; //EX-SGG 040620

                GetSourceDocuments.GetLastReceiptHeader(WhseRcptHeader);
                Page.RUN(Page::"Warehouse Receipt", WhseRcptHeader);
            END
            ELSE //EX-SGG-WMS 250919
                ERROR('No existe ' + WhseRqst.TABLECAPTION + ':\' + WhseRqst.GETFILTERS);
        END;

    END;



    procedure GetSingleWhsePutAwayDoc(CurrentWkshTemplateName: Code[10]; CurrentWkshName: Code[10]; LocationCode: Code[10])
    var

        WhsePutAwayRqst: Record "Whse. Put-away Request";
        WhsePutAwayDocSelection: PAGE "Put-away Selection";
        GetWhseSourceDocuments: Report "Get Inbound Source Documents";
    begin
        WhsePutAwayRqst.FILTERGROUP(2);
        WhsePutAwayRqst.SETRANGE("Completely Put Away", FALSE);
        WhsePutAwayRqst.SETRANGE("Location Code", LocationCode);
        WhsePutAwayRqst.FILTERGROUP(0);

        WhsePutAwayDocSelection.LOOKUPMODE(TRUE);
        WhsePutAwayDocSelection.SETTABLEVIEW(WhsePutAwayRqst);
        IF WhsePutAwayDocSelection.RUNMODAL <> ACTION::LookupOK THEN
            EXIT;

        WhsePutAwayDocSelection.GetResult(WhsePutAwayRqst);

        GetWhseSourceDocuments.SetWhseWkshName(
          CurrentWkshTemplateName, CurrentWkshName, LocationCode);
        WhsePutAwayRqst.MARKEDONLY(TRUE);
        IF NOT WhsePutAwayRqst.FIND('-') THEN BEGIN
            WhsePutAwayRqst.MARKEDONLY(FALSE);
            WhsePutAwayRqst.SETRECFILTER;
        END;

        GetWhseSourceDocuments.UseRequestPage(FALSE);
        GetWhseSourceDocuments.SETTABLEVIEW(WhsePutAwayRqst);
        GetWhseSourceDocuments.RUNMODAL;

    END;




    procedure ReciboAlmacenCantidadRecibida(cantidadRecibida: Boolean)
    begin
        //EX-OMI-WMS 210519
        EscantidadRecibida := cantidadRecibida;
    end;

    procedure TraerDocRecepcionAlmacen(codRecep: Code[20])
    begin
        //EX-OMI-WMS 230519
        CodigoRecepcion := codRecep;
    END;

    //procedure EstableceTipoyCodOrigenEnRecep(VAR lRstCabRecep: Record "Warehouse Receipt Header"; lTipoOrigen: Integer; lCodOrigen: Code[20])
    procedure EstableceTipoyCodOrigenEnRecep(VAR lRstCabRecep: Record "Warehouse Receipt Header"; lTipoOrigen: Enum TipoOrigen; lCodOrigen: Code[20])
    begin
        //EX-SGG-WMS 140619
        lRstCabRecep.VALIDATE("Tipo origen", lTipoOrigen);
        IF lCodOrigen <> '0' THEN //EX-SGG-WMS 270919
            lRstCabRecep.VALIDATE("Cod. origen", lCodOrigen)
        ELSE
            lRstCabRecep."Cod. origen" := lCodOrigen;

        lRstCabRecep.MODIFY(TRUE);

    END;



    procedure EstableceTipoOrdenEntrada(VAR lRstCabRecep: Record "Warehouse Receipt Header"; lCodPedidoCompra: Code[20])
    var
        lCduWMS: Codeunit 50200;
    begin
        //EX-SGG-WMS 110719
        CASE lRstCabRecep."Tipo origen" OF
            lRstCabRecep."Tipo origen"::Proveedor:
                BEGIN
                    IF lCduWMS.ExistenLinsAsignacionDirecta(lRstCabRecep.TABLENAME, lRstCabRecep."No.") THEN //EX-SGG-WMS 291119
                        lRstCabRecep.VALIDATE(lRstCabRecep."Tipo de Orden de Entrada", '3')
                    ELSE
                        lRstCabRecep.VALIDATE(lRstCabRecep."Tipo de Orden de Entrada", '1');
                END;
            lRstCabRecep."Tipo origen"::Cliente:
                BEGIN
                    lRstCabRecep.VALIDATE(lRstCabRecep."Tipo de Orden de Entrada", '2');
                END;
        END;

        lRstCabRecep.MODIFY(TRUE);

    END;

    procedure CompruebaMismosTiposDocumentos(VAR lRstSolicitudAlm: Record "Warehouse Request"; VAR lRstCabRecep: Record "Warehouse Receipt Header")
    var

        lRstLinRecep: Record "Warehouse Receipt Line";
        lTipoDoc: Integer;
    begin
        //EX-SGG-WMS 140619
        lRstLinRecep.SETRANGE("No.", lRstCabRecep."No.");
        IF lRstLinRecep.FINDFIRST THEN
            lTipoDoc := lRstLinRecep."Source Document";
        IF lRstSolicitudAlm.FINDSET THEN BEGIN
            IF lTipoDoc = 0 THEN
                lTipoDoc := lRstSolicitudAlm."Source Document";
            REPEAT
                IF lRstSolicitudAlm."Source Document" <> lTipoDoc THEN
                    ERROR('No es posible incluir documentos con distinto origen en la misma recepción de almacén');
            UNTIL lRstSolicitudAlm.NEXT = 0;
        END;
    end;

    var
        myInt: Integer;
        CodigoRecepcion: code[20];
        EscantidadRecibida: Boolean;

}