codeunit 50415 "Eventos_Sub_Warehouse_Recep"
{
    var



    //codeunit 50410.
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnAfterCheckWhseRcptLines', '', false, false)]
    local procedure OnAfterCheckWhseRcptLines(var WhseRcptHeader: Record "Warehouse Receipt Header"; var WhseRcptLine: Record "Warehouse Receipt Line")
    var

    begin
        // WhseRcptHeader.GET("No.");
        //
        WhseRcptHeader.TESTFIELD("Posting Date");
        WhseRcptHeader.TESTFIELD(WhseRcptHeader.Status, WhseRcptHeader.Status::Released);
       // Message('probando');
        //EX-SGG-WMS 120719

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforerun', '', false, false)]
    procedure OnBeforeRun(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; var SuppressCommit: Boolean)
    var
        CduWMS: Codeunit 50003;
        WareHouseRecepHeader: Record "Warehouse Receipt Header";
    begin
        if WareHouseRecepHeader.Get(WarehouseReceiptLine."No.") then
            if NOT WareHouseRecepHeader."Omitir SEGA" then begin
                IF (NOT CduWMS.EsUsuarioSEGA(USERID)) AND GUIALLOWED THEN
                    ERROR('Solo un usuario SEGA puede realizar el registro'); //EX-SGG-WMS 230719
            end;

    end;

    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnBeforeCheckWhseRqstDocumentStatus', '', false, false)]
    // local procedure OnBeforeCheckWhseRqstDocumentStatus(WhseRqst: Record "Warehouse Request"; var WarehouseReceiptLine: Record "Warehouse Receipt Line"; SalesHeader: Record "Sales Header"; PurchHeader: Record "Purchase Header"; var IsHandled: Boolean)
    // begin

    //      case WhseRqst."Source Document" of
    //         WhseRqst."Source Document"::"Purchase Order"
    //                    WarehouseReceiptLine.PfsItemBlocked(FALSE,'1');
    //      end;
         
    // end;

    


}