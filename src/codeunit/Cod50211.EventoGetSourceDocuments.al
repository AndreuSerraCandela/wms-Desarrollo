codeunit 50211 EventoGetSourceDocuments
{



    //5753 "Get Source Documents"
    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnBeforeWhseShptHeaderInsert', '', false, false)]
    local procedure OnBeforeWhseShptHeaderInsert(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var WarehouseRequest: Record "Warehouse Request"; SalesLine: Record "Sales Line"; TransferLine: Record "Transfer Line"; SalesHeader: Record "Sales Header")
    var
        InventorySetup: Record "Inventory Setup";
        recTransferHeader: Record "Transfer Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        WhseSetup: Record "Warehouse Setup";
    begin
        WhseSetup.Get();
        InventorySetup.Get();
        IF recTransferHeader.GET(WarehouseRequest."Source No.") THEN BEGIN
            //EX-JFC 211221 Controlar si el pedido de transferencia es de consignacion o no
            IF recTransferHeader."Ventas en consignacion" = TRUE THEN
                WarehouseShipmentHeader."No." := NoSeriesMgt.GetNextNo(InventorySetup."Serie envio transf. consig.", WORKDATE, TRUE)
            ELSE
                WarehouseShipmentHeader."No." := NoSeriesMgt.GetNextNo(WhseSetup."Whse. Ship Nos.", WORKDATE, TRUE);
            //EX-JFC 211221 Controlar si el pedido de transferencia es de consignacion o no
        end else

            IF (SalesHeader."Document Type" = SalesHeader."Document Type"::Order) AND (SalesHeader."Shipping No. Series" <> '') THEN
                WarehouseShipmentHeader."No." := NoSeriesMgt.GetNextNo(SalesHeader."Shipping No. Series", WORKDATE, TRUE); //EX-SGG-WMS 160120
                                                                                                                           //WhseShptHeader."No." := NoSeriesMgt.GetNextNo("Sales Header"."Shipping No. Series","Sales Header"."Posting Date",TRUE);
    END;

    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnBeforeWhseShptHeaderInsert', '', false, false)]
    local procedure OnBeforeWhseShptHeaderInsertMYB(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var WarehouseRequest: Record "Warehouse Request"; SalesLine: Record "Sales Line"; TransferLine: Record "Transfer Line"; SalesHeader: Record "Sales Header")
    var
        Transfer: Record "Transfer Header";
        Cod50003: Codeunit FuncionesWMS;
    begin

        Transfer.SetRange("No.", TransferLine."Document No.");
        if Transfer.FindFirst() then begin
            if Cod50003.ComprobacionesAlmacenesSEGA(Transfer) then
                WarehouseShipmentHeader."Omitir SEGA" := true;
        end;

        // Error('', WarehouseShipmentHeader."No.");
        // Message('2', WarehouseRequest."Destination Type");
        // WarehouseRequest."Source Type" := WarehouseRequest."Source Type"::
    end;


    [EventSubscriber(ObjectType::Report, Report::"Get Source Documents", 'OnBeforeWhseReceiptHeaderInsert', '', false, false)]
    local procedure OnBeforeWhseReceiptHeaderInsert(var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; var WarehouseRequest: Record "Warehouse Request")
    var
        recTransferHeader: Record "Transfer Header";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        WhseSetup: Record "Warehouse Setup";
        InventorySetup: Record "Inventory Setup";
    begin
        WhseSetup.Get();
        InventorySetup.Get();
        IF recTransferHeader.GET(WarehouseRequest."Source No.") THEN
            //EX-JFC 211221 Controlar si el pedido de transferencia es de consignacion o no
            IF recTransferHeader."Ventas en consignacion" = TRUE THEN
                WarehouseReceiptHeader."No." := NoSeriesMgt.GetNextNo(InventorySetup."Serie recep. transf. consig.", WORKDATE, TRUE)
            ELSE
                WarehouseReceiptHeader."No." := NoSeriesMgt.GetNextNo(WhseSetup."Whse. Receipt Nos.", WORKDATE, TRUE);
        //EX-JFC 211221 Controlar si el pedido de transferencia es de consignacion o no
    end;

}