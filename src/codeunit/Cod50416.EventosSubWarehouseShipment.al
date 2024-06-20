codeunit 50416 EventosSubWarehouseShipment
{
    //50412 Whse.-Post Shipment WMS
    var
        x: Codeunit 5763;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnBeforeRun', '', false, false)]
    local procedure OnBeforeRun(var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        CduWMS: Codeunit FuncionesWMS;
        WareHouseShimHeader: Record "Warehouse Shipment Header";
    begin
        if WareHouseShimHeader.Get(WarehouseShipmentLine."No.") then
            if NOT WareHouseShimHeader."Omitir SEGA" then begin
                IF (NOT CduWMS.EsUsuarioSEGA(USERID)) AND GUIALLOWED THEN
                    ERROR('Solo un usuario SEGA puede realizar el registro'); //EX-SGG-WMS 230719
            end;
    end;

    
    //vlrangel
    //OnInitSourceDocumentHeaderOnBeforeSalesHeaderModify(SalesHeader, WhseShptHeader, ModifyHeader, Invoice, WhseShptLine);
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnInitSourceDocumentHeaderOnBeforeSalesHeaderModify', '', false, false)]
    local procedure OnInitSourceDocumentHeaderOnBeforeSalesHeaderModify(var SalesHeader: Record "Sales Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var ModifyHeader: Boolean; Invoice: Boolean; var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        PfsWearerRec: Record Contact;
        PfsTempSalesHeader: Record "Sales Header";
        lRstLinVenta: Record "Sales Line";

    begin
        // Pfs8.20
        //  IF WarehouseShipmentHeader.PfsWearer <> '' THEN BEGIN
        PfsTempSalesHeader := SalesHeader;
        //  PfsWearerRec.GET(WhseShptHeader.PfsWearer);
        SalesHeader."Ship-to Name" := PfsWearerRec.Name;
        SalesHeader."Ship-to Name 2" := PfsWearerRec."Name 2";
        SalesHeader."Ship-to Address" := PfsWearerRec.Address;
        SalesHeader."Ship-to Address 2" := PfsWearerRec."Address 2";
        SalesHeader."Ship-to City" := PfsWearerRec.City;
        SalesHeader."Ship-to Contact" := PfsWearerRec.Name;
        SalesHeader."Ship-to Post Code" := PfsWearerRec."Post Code";
        SalesHeader."Ship-to County" := PfsWearerRec.County;
        SalesHeader."Ship-to Country/Region Code" := PfsWearerRec."Country/Region Code";
        ModifyHeader := TRUE;
        // END;
        // *

        //EX-SGG-WMS 021219       
        if SalesHeader."Pedido B2C" THEN BEGIN
            lRstLinVenta.SETRANGE("Document Type", SalesHeader."Document Type");
            lRstLinVenta.SETRANGE("Document No.", SalesHeader."No.");
            lRstLinVenta.SETRANGE(Type, lRstLinVenta.Type::"G/L Account");
            IF lRstLinVenta.FINDSET THEN
                REPEAT
                    IF lRstLinVenta."Document Type" = lRstLinVenta."Document Type"::"Return Order" THEN
                        lRstLinVenta.InitQtyToReceive()
                    ELSE
                        lRstLinVenta.InitQtyToShip();
                    lRstLinVenta.MODIFY(TRUE);
                UNTIL lRstLinVenta.NEXT = 0;
        END;
        //FIN EX-SGG-WMS 021219

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnInitSourceDocumentHeaderOnBeforePurchHeaderModify', '', false, false)]
    local procedure OnInitSourceDocumentHeaderOnBeforePurchHeaderModify(var PurchaseHeader: Record "Purchase Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var ModifyHeader: Boolean)
    begin
        PurchaseHeader."Return Shipment No." := WarehouseShipmentHeader."Shipping No."; //EX-SGG-WMS 050919
        ModifyHeader := TRUE; //EX-SGG-WMS 050919
    end;


    //OnInitSourceDocumentHeaderOnBeforeTransHeaderModify
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnInitSourceDocumentHeaderOnBeforeTransHeaderModify', '', false, false)]
    local procedure OnInitSourceDocumentHeaderOnBeforeTransHeaderModify(var TransferHeader: Record "Transfer Header"; var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var ModifyHeader: Boolean)
    begin
        //EX.CGR.081020
        IF WarehouseShipmentHeader."Cod Cliente" <> '' THEN
            TransferHeader."Last Shipment No." := WarehouseShipmentHeader."No.";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnAfterFindWhseShptLineForTransLine', '', false, false)]
    local procedure OnAfterFindWhseShptLineForTransLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; var TransferLine: Record "Transfer Line")
    var
        _SalesLine: Record "Sales Line";
        globalPVNo: Code[20];
        globalUpdateSL: Boolean;
    begin
        //EX-CV
        _SalesLine.RESET;
        _SalesLine.SETRANGE("Document No.", TransferLine."No. pedido");
        _SalesLine.SETRANGE("Line No.", TransferLine."No. linea pedido");
        IF _SalesLine.FINDSET THEN
            REPEAT
                // _SalesLine."Act dato" := FALSE;
                _SalesLine.MODIFY(FALSE);
            UNTIL _SalesLine.NEXT = 0;


        //EX-CV END



        //EX-CV  -  fix  -  2021 11 23
        //IF (TransLine."Qty. Shipped (Base)" > 0) OR (TransLine."Qty. to Ship (Base)" > 0) THEN BEGIN
        //EX-CV
        IF NOT globalUpdateSL THEN BEGIN
            _SalesLine.RESET;
            _SalesLine.SETRANGE("Document No.", TransferLine."No. pedido");
            _SalesLine.SETRANGE("Line No.", TransferLine."No. linea pedido");
            //_SalesLine.SETRANGE("Act dato", FALSE);
            IF _SalesLine.FINDFIRST THEN BEGIN
                globalPVNo := _SalesLine."Document No.";
                _SalesLine.CALCFIELDS("Cantidad en consignacion", "Cantidad transferencia");
                //_SalesLine."Cant. Pte no anulada" -= TransLine.Quantity;
                _SalesLine."Cant. Pte no anulada" := _SalesLine.Quantity - _SalesLine."Cantidad en consignacion" -
                                                     _SalesLine."Cantidad Anulada";//{ + _SalesLine."Cantidad transferencia";  }
                _SalesLine."Qty. to Ship (Base)" -= TransferLine."Qty. to Ship (Base)";//TransLine.Quantity;
                _SalesLine."Qty. to Ship" -= TransferLine."Qty. to Ship";//TransLine.Quantity;
                                                                         //_SalesLine."Outstanding Quantity" -= TransLine.Quantity;
                                                                         //_SalesLine."Outstanding Qty. (Base)" -= TransLine.Quantity;
                                                                         // _SalesLine."Act dato" := TRUE;
                _SalesLine.MODIFY(FALSE);
            end;
        end;
    end;




    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnPostSourceDocumentOnBeforePostSalesHeader', '', false, false)]
    local procedure OnPostSourceDocumentOnBeforePostSalesHeader(var SalesPost: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header"; WhseShptHeader: Record "Warehouse Shipment Header"; var CounterSourceDocOK: Integer; SuppressCommit: Boolean; var IsHandled: Boolean; var Invoice: Boolean)
    begin

        // Pfs8.20
        //   IF PfsTempSalesHeader."No." = SalesHeader."No." THEN BEGIN
        SalesHeader."Ship-to Name" := WhseShptHeader."Ship-to Name";
        SalesHeader."Ship-to Name 2" := WhseShptHeader."Ship-to Name 2";
        SalesHeader."Ship-to Address" := WhseShptHeader."Ship-to Address";
        SalesHeader."Ship-to Address 2" := WhseShptHeader."Ship-to Address 2";
        SalesHeader."Ship-to City" := WhseShptHeader."Ship-to City";
        // SalesHeader."Ship-to Contact" := WhseShptHeader.shi;
        SalesHeader."Ship-to Post Code" := WhseShptHeader."Ship-to Post Code";
        SalesHeader."Ship-to County" := WhseShptHeader."Ship-to County";
        SalesHeader."Ship-to Country/Region Code" := WhseShptHeader."Ship-to Country/Region Code";
        SalesHeader.MODIFY;
        //   END;
        // *
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnPostSourceDocumentOnBeforePrintSalesShipment', '', false, false)]
    local procedure OnPostSourceDocumentOnBeforePrintSalesShipment(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean; var SalesShptHeader: Record "Sales Shipment Header"; WhseShptHeader: Record "Warehouse Shipment Header")
    var
        locrec_SalesShipHeader: Record 110;
    begin


        //EX-OMI 211119
        locrec_SalesShipHeader.RESET;
        locrec_SalesShipHeader.SETRANGE("No.", WhseShptHeader."No.");
        IF locrec_SalesShipHeader.FINDFIRST THEN BEGIN
            locrec_SalesShipHeader.VALIDATE("Fecha para facturar", WORKDATE);
            locrec_SalesShipHeader.MODIFY;
        END;
        //EX-OMI fin

    end;

    //OnPostUpdateWhseDocumentsOnBeforeUpdateWhseShptHeader
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Shipment", 'OnPostUpdateWhseDocumentsOnBeforeUpdateWhseShptHeader', '', false, false)]
    procedure OnPostUpdateWhseDocumentsOnBeforeUpdateWhseShptHeader(var WhseShptHeaderParam: Record "Warehouse Shipment Header")
    var
        WhseShptLine2: Record "Warehouse Shipment Line";

    begin
        WhseShptLine2.SetRange("No.", WhseShptHeaderParam."No.");
        PfsDeleteRemWhseShptLines(WhseShptLine2);
    end;

    procedure PfsDeleteRemWhseShptLines(var WhseShptLine2: Record "Warehouse Shipment Line")
    begin

        IF WhseShptLine2.FIND('-') THEN
            REPEAT
                WhseShptLine2.DELETE(false);
            UNTIL WhseShptLine2.NEXT = 0;
    end;

}