codeunit 50992 "Purchases Warehouse Mgt1"
{
    var
#if not CLEAN23
        WMSManagement: Codeunit "WMS Management";
#endif
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        //WhseCreateSourceDocument: Codeunit "Whse.-Create Source Document";
        WhseCreateSourceDocument: Codeunit "Whse.-Create Source Document";

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", 'OnShowSourceDocLine', '', false, false)]
    local procedure OnShowSourceDocLine(SourceType: Integer; SourceSubType: Option; SourceNo: Code[20]; SourceLineNo: Integer; SourceSubLineNo: Integer)
    var
        PurchaseLine: Record "Purchase Line";
        IsHandled: Boolean;
    begin
        if SourceType = Database::"Purchase Line" then begin
            PurchaseLine.Reset();
            PurchaseLine.SetRange("Document Type", SourceSubType);
            PurchaseLine.SetRange("Document No.", SourceNo);
            PurchaseLine.SetRange("Line No.", SourceLineNo);
            IsHandled := false;

            OnBeforeShowPurchaseLines(PurchaseLine, SourceSubType, SourceNo, SourceLineNo, IsHandled);
            if not IsHandled then
                ShowPurchaseLines(PurchaseLine);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", 'OnShowSourceDocAttachedLines', '', false, false)]
    local procedure OnShowSourceDocAttachedLines(SourceType: Integer; SourceSubType: Option; SourceNo: Code[20]; SourceLineNo: Integer)
    var
        PurchaseLine: Record "Purchase Line";
        IsHandled: Boolean;
    begin
        if SourceType = Database::"Purchase Line" then begin
            PurchaseLine.Reset();
            PurchaseLine.SetRange("Document Type", SourceSubType);
            PurchaseLine.SetRange("Document No.", SourceNo);
            PurchaseLine.SetRange("Attached to Line No.", SourceLineNo);
            IsHandled := false;
            OnBeforeShowAttachedPurchaseLines(PurchaseLine, SourceSubType, SourceNo, SourceLineNo, IsHandled);
            if not IsHandled then
                ShowPurchaseLines(PurchaseLine);
        end;
    end;

    local procedure ShowPurchaseLines(var PurchaseLine: Record "Purchase Line")
    begin
        Page.Run(Page::"Purchase Lines", PurchaseLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", 'OnShowSourceDocCard', '', false, false)]
    local procedure OnShowSourceDocCard(SourceType: Integer; SourceSubType: Option; SourceNo: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        if SourceType = DATABASE::"Purchase Line" then begin
            PurchaseHeader.Reset();
            PurchaseHeader.SetRange("Document Type", SourceSubType);
            if PurchaseHeader.Get(SourceSubType, SourceNo) then
                if PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order then
                    PAGE.RunModal(PAGE::"Purchase Order", PurchaseHeader)
                else
                    PAGE.RunModal(PAGE::"Purchase Return Order", PurchaseHeader);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"WMS Management", 'OnShowPostedSourceDoc', '', false, false)]
    local procedure OnShowPostedSourceDoc(PostedSourceDoc: Option; PostedSourceNo: Code[20])
    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        ReturnShipmentHeader: Record "Return Shipment Header";
        PostedSourceDocEnum: Enum "Warehouse Shipment Posted Source Document";
    begin
        PostedSourceDocEnum := Enum::"Warehouse Shipment Posted Source Document".FromInteger(PostedSourceDoc);
        case PostedSourceDocEnum of
            PostedSourceDocEnum::"Posted Receipt":
                begin
                    PurchRcptHeader.Reset();
                    PurchRcptHeader.SetRange("No.", PostedSourceNo);
                    PAGE.RunModal(PAGE::"Posted Purchase Receipt", PurchRcptHeader);
                end;
            PostedSourceDocEnum::"Posted Return Shipment":
                begin
                    ReturnShipmentHeader.Reset();
                    ReturnShipmentHeader.SetRange("No.", PostedSourceNo);
                    PAGE.RunModal(PAGE::"Posted Return Shipment", ReturnShipmentHeader);
                end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowPurchaseLines(var PurchaseLine: Record "Purchase Line"; SourceSubType: Integer; SourceNo: Code[20]; SourceLineNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowAttachedPurchaseLines(var PurchaseLine: Record "Purchase Line"; SourceSubType: Integer; SourceNo: Code[20]; SourceLineNo: Integer; var IsHandled: Boolean)
    begin
    end;

    procedure PurchaseLineVerifyChange(var NewPurchaseLine: Record "Purchase Line"; var OldPurchaseLine: Record "Purchase Line")
    var
        OverReceiptMgt: Codeunit "Over-Receipt Mgt.";
        NewRecordRef: RecordRef;
        OldRecordRef: RecordRef;
        IsHandled: Boolean;
    begin
        IsHandled := false;

        OnBeforePurchaseLineVerifyChange(NewPurchaseLine, OldPurchaseLine, IsHandled);
        if IsHandled then
            exit;

        if not WhseValidateSourceLine.WhseLinesExist(
             DATABASE::"Purchase Line", NewPurchaseLine."Document Type".AsInteger(), NewPurchaseLine."Document No.",
             NewPurchaseLine."Line No.", 0, NewPurchaseLine.Quantity)
        then
            exit;

        NewRecordRef.GetTable(NewPurchaseLine);
        OldRecordRef.GetTable(OldPurchaseLine);
        with NewPurchaseLine do begin
            WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo(Type));
            WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo("No."));
            WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo("Variant Code"));
            WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo("Location Code"));
            WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo("Unit of Measure Code"));
            WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo("Drop Shipment"));
            WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo("Sales Order No."));
            WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo("Sales Order Line No."));
            WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo("Special Order"));
            WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo("Special Order Sales No."));
            WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo("Special Order Sales Line No."));
            WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo("Job No."));
            if not OverReceiptMgt.IsQuantityUpdatedFromInvtPutAwayOverReceipt(NewPurchaseLine) then begin
                if not OverReceiptMgt.IsQuantityUpdatedFromWarehouseOverReceipt(NewPurchaseLine) then
                    WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo(Quantity));
                WhseValidateSourceLine.VerifyFieldNotChanged(NewRecordRef, OldRecordRef, FieldNo("Qty. to Receive"));
            end;
        end;

        OnAfterPurchaseLineVerifyChange(NewPurchaseLine, OldPurchaseLine, NewRecordRef, OldRecordRef);

    end;

    procedure PurchaseLineDelete(var PurchaseLine: Record "Purchase Line")
    begin
        if WhseValidateSourceLine.WhseLinesExist(
             DATABASE::"Purchase Line", PurchaseLine."Document Type".AsInteger(), PurchaseLine."Document No.", PurchaseLine."Line No.", 0, PurchaseLine.Quantity)
        then
            //WhseValidateSourceLine.RaiseCannotBeDeletedErr(PurchaseLine.TableCaption());
            //revisar vlrangel

        OnAfterPurchaseLineDelete(PurchaseLine);

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Validate Source Line", 'OnWhseLineExistOnBeforeCheckReceipt', '', false, false)]
    local procedure OnWhseLineExistOnBeforeCheckReceipt(SourceType: Integer; SourceSubType: Option; SourceQty: Decimal; var CheckReceipt: Boolean)
    begin
        CheckReceipt := CheckReceipt or
           ((SourceType = DATABASE::"Purchase Line") and (SourceSubType = 1) and (SourceQty >= 0)) or
           ((SourceType = DATABASE::"Purchase Line") and (SourceSubType = 5) and (SourceQty < 0));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse. Validate Source Line", 'OnWhseLineExistOnBeforeCheckShipment', '', false, false)]
    local procedure OnWhseLineExistOnBeforeCheckShipment(SourceType: Integer; SourceSubType: Option; SourceQty: Decimal; var CheckShipment: Boolean)
    begin
        CheckShipment := CheckShipment or
           ((SourceType = DATABASE::"Purchase Line") and (SourceSubType = 1) and (SourceQty < 0)) or
           ((SourceType = DATABASE::"Purchase Line") and (SourceSubType = 5) and (SourceQty >= 0));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPurchaseLineVerifyChange(var NewPurchaseLine: Record "Purchase Line"; var OldPurchaseLine: Record "Purchase Line"; var NewRecordRef: RecordRef; var OldRecordRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPurchaseLineDelete(var PurchaseLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchaseLineVerifyChange(var NewPurchaseLine: Record "Purchase Line"; var OldPurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Request", 'OnShowSourceDocumentCard', '', false, false)]
    local procedure OnShowSourceDocumentCard(var WarehouseRequest: Record "Warehouse Request")
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        case WarehouseRequest."Source Document" of
            Enum::"Warehouse Request Source Document"::"Purchase Order":
                begin
                    PurchaseHeader.Get(WarehouseRequest."Source Subtype", WarehouseRequest."Source No.");
                    PAGE.Run(PAGE::"Purchase Order", PurchaseHeader);
                end;
            Enum::"Warehouse Request Source Document"::"Purchase Return Order":
                begin
                    PurchaseHeader.Get(WarehouseRequest."Source Subtype", WarehouseRequest."Source No.");
                    PAGE.Run(PAGE::"Purchase Return Order", PurchaseHeader);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warehouse Source Filter", 'OnSetFiltersOnSourceTables', '', false, false)]
    local procedure OnSetFiltersOnSourceTables(var WarehouseSourceFilter: Record "Warehouse Source Filter"; var GetSourceDocuments: Report "Get Source Documents")
    var
        PurchaseHeader: Record "Purchase Line";
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseHeader.SetFilter("Buy-from Vendor No.", WarehouseSourceFilter."Buy-from Vendor No. Filter");

        PurchaseLine.SetFilter("No.", WarehouseSourceFilter."Item No. Filter");
        PurchaseLine.SetFilter("Variant Code", WarehouseSourceFilter."Variant Code Filter");
        PurchaseLine.SetFilter("Unit of Measure Code", WarehouseSourceFilter."Unit of Measure Filter");
        PurchaseLine.SetFilter("Buy-from Vendor No.", WarehouseSourceFilter."Buy-from Vendor No. Filter");
        PurchaseLine.SetFilter("Expected Receipt Date", WarehouseSourceFilter."Expected Receipt Date");
        PurchaseLine.SetFilter("Planned Receipt Date", WarehouseSourceFilter."Planned Receipt Date");

        GetSourceDocuments.SetTableView(PurchaseHeader);
        GetSourceDocuments.SetTableView(PurchaseLine);
    end;

    procedure FromPurchLine2ShptLine(WarehouseShipmentHeader: Record "Warehouse Shipment Header"; PurchaseLine: Record "Purchase Line"; var LCantidadARecibir: Boolean) Result: Boolean
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        IsHandled: Boolean;
        TotalOutstandingWhseShptQty: Decimal;
        TotalOutstandingWhseShptQtyBase: Decimal;

    begin
        IsHandled := false;

        OnBeforeFromPurchLine2ShptLine(PurchaseLine, Result, IsHandled, WarehouseShipmentHeader);
        if IsHandled then
            exit(Result);

        if NOT LCantidadARecibir then begin
            TotalOutstandingWhseShptQty := Abs(PurchaseLine."Outstanding Quantity") - PurchaseLine."Quantity Received"; ///???
            TotalOutstandingWhseShptQtyBase := Abs(PurchaseLine."Outstanding Qty. (Base)") - PurchaseLine."Whse. Outstanding Qty. (Base)";
        END ELSE begin
            TotalOutstandingWhseShptQty := Abs((PurchaseLine."Qty. to Receive")) - PurchaseLine."Qty. to Receive";
            TotalOutstandingWhseShptQtyBase := Abs((PurchaseLine."Qty. to Receive (Base)")) - PurchaseLine."Qty. to Receive (Base)";

        end;



        with WarehouseShipmentLine do begin
            InitNewLine(WarehouseShipmentHeader."No.");
            SetSource(DATABASE::"Purchase Line", PurchaseLine."Document Type".AsInteger(), PurchaseLine."Document No.", PurchaseLine."Line No.");
            PurchaseLine.TestField("Unit of Measure Code");
            SetItemData(
              PurchaseLine."No.", PurchaseLine.Description, PurchaseLine."Description 2", PurchaseLine."Location Code",
              PurchaseLine."Variant Code", PurchaseLine."Unit of Measure Code", PurchaseLine."Qty. per Unit of Measure",
              PurchaseLine."Qty. Rounding Precision", PurchaseLine."Qty. Rounding Precision (Base)");


            ///vlrangel begin
            WarehouseShipmentLine."Cod. temporada" := PurchaseLine."Shortcut Dimension 1 Code";
            WarehouseShipmentLine.PfsSubline := PurchaseLine.PfsSubline;
            WarehouseShipmentLine."PfsMatrix Line No." := PurchaseLine."PfsMatrix Line No.";


            OnFromPurchLine2ShptLineOnAfterInitNewLine(WarehouseShipmentLine, WarehouseShipmentHeader, PurchaseLine);
            //WhseCreateSourceDocument.SetQtysOnShptLine(WarehouseShipmentLine, Abs(PurchaseLine."Outstanding Quantity"), Abs(PurchaseLine."Outstanding Qty. (Base)"));
            //  SetQtysOnShptLine(WarehouseShipmentLine, Abs(PurchaseLine."Outstanding Quantity"), Abs(PurchaseLine."Outstanding Qty. (Base)"));
            SetQtysOnShptLine(WarehouseShipmentLine, TotalOutstandingWhseShptQty, TotalOutstandingWhseShptQtyBase);
            //revisar vlrangel
            if PurchaseLine."Document Type" = PurchaseLine."Document Type"::Order then
                "Due Date" := PurchaseLine."Expected Receipt Date";
            if PurchaseLine."Document Type" = PurchaseLine."Document Type"::"Return Order" then
                "Due Date" := WorkDate();
            if WarehouseShipmentHeader."Shipment Date" = 0D then
                "Shipment Date" := PurchaseLine."Planned Receipt Date"
            else
                "Shipment Date" := WarehouseShipmentHeader."Shipment Date";
            "Destination Type" := "Destination Type"::Vendor;
            "Destination No." := PurchaseLine."Buy-from Vendor No.";
            if "Location Code" = WarehouseShipmentHeader."Location Code" then
                "Bin Code" := WarehouseShipmentHeader."Bin Code";
            if "Bin Code" = '' then
                "Bin Code" := PurchaseLine."Bin Code";

            // WhseCreateSourceDocument.UpdateShipmentLine(WarehouseShipmentLine, WarehouseShipmentHeader);
            //revisar vlrangel

            OnFromPurchLine2ShptLineOnBeforeCreateShptLine(WarehouseShipmentLine, WarehouseShipmentHeader, PurchaseLine);
            //            WhseCreateSourceDocument.CreateShipmentLine(WarehouseShipmentLine);
            CreateShipmentLine(WarehouseShipmentLine);
            //revisar vlrangel

            OnAfterCreateShptLineFromPurchLine(WarehouseShipmentLine, WarehouseShipmentHeader, PurchaseLine);
            exit(not HasErrorOccured());
        end;
    end;


    procedure CreateShipmentLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        Item: Record Item;
    begin
        with WarehouseShipmentLine do begin
            Item."No." := "Item No.";
            Item.ItemSKUGet(Item, "Location Code", "Variant Code");
            "Shelf No." := Item."Shelf No.";
            //  OnBeforeWhseShptLineInsert(WarehouseShipmentLine);
            Insert();
            //   OnAfterWhseShptLineInsert(WarehouseShipmentLine);
            CreateWhseItemTrackingLines();
        end;

        // OnAfterCreateShptLine(WarehouseShipmentLine);
    end;

    procedure SetQtysOnShptLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; Qty: Decimal; QtyBase: Decimal)
    var
        Location: Record Location;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        // OnBeforeSetQtysOnShptLine(WarehouseShipmentLine, Qty, QtyBase, IsHandled);
        if IsHandled then
            exit;

        with WarehouseShipmentLine do begin
            Quantity := Qty;
            "Qty. (Base)" := QtyBase;
            InitOutstandingQtys();
            CheckSourceDocLineQty();
            if Location.Get("Location Code") then
                CheckBin(0, 0);
        end;
    end;

    procedure PurchLine2ReceiptLine(WarehouseReceiptHeader: Record "Warehouse Receipt Header"; PurchaseLine: Record "Purchase Line"; VAR EsCantidadARecibir: Boolean): Boolean
    var
        WarehouseReceiptLine: Record "Warehouse Receipt Line";
        IsHandled: Boolean;
        Result: Boolean;
        RItemVarian: Record "Item Variant";
    begin
        IsHandled := false;

        OnBeforePurchLine2ReceiptLine(WarehouseReceiptHeader, PurchaseLine, IsHandled, Result);
        if IsHandled then
            exit(Result);

        with WarehouseReceiptLine do begin
            InitNewLine(WarehouseReceiptHeader."No.");
            SetSource(DATABASE::"Purchase Line", PurchaseLine."Document Type".AsInteger(), PurchaseLine."Document No.", PurchaseLine."Line No.");
            PurchaseLine.TestField("Unit of Measure Code");
            SetItemData(
              PurchaseLine."No.", PurchaseLine.Description, PurchaseLine."Description 2", PurchaseLine."Location Code",
              PurchaseLine."Variant Code", PurchaseLine."Unit of Measure Code", PurchaseLine."Qty. per Unit of Measure",
              PurchaseLine."Qty. Rounding Precision", PurchaseLine."Qty. Rounding Precision (Base)");
            "Over-Receipt Code" := PurchaseLine."Over-Receipt Code";
            IsHandled := false;



            WarehouseReceiptLine."Cod. temporada" := PurchaseLine."Shortcut Dimension 1 Code";

            WarehouseReceiptLine.PfsSubline := PurchaseLine.PfsSubline;
            WarehouseReceiptLine."PfsMatrix Line No." := PurchaseLine."PfsMatrix Line No.";



            OnPurchLine2ReceiptLineOnAfterInitNewLine(WarehouseReceiptLine, WarehouseReceiptHeader, PurchaseLine, IsHandled);
            if not IsHandled then begin
                case PurchaseLine."Document Type" of
                    PurchaseLine."Document Type"::Order:
                        begin
                            Validate("Qty. Received", Abs(PurchaseLine."Quantity Received"));
                            "Due Date" := PurchaseLine."Expected Receipt Date";
                        end;
                    PurchaseLine."Document Type"::"Return Order":
                        begin
                            Validate("Qty. Received", Abs(PurchaseLine."Return Qty. Shipped"));
                            "Due Date" := WorkDate();
                        end;
                end;
                //WhseCreateSourceDocument.SetQtysOnRcptLine(WarehouseReceiptLine, Abs(PurchaseLine.Quantity), Abs(PurchaseLine."Quantity (Base)"));
                if EsCantidadARecibir then begin
                    SetQtysOnRcptLine(WarehouseReceiptLine, Abs(PurchaseLine."Qty. to Receive"), Abs(PurchaseLine."Qty. to Receive (Base)"));
                end else begin
                    SetQtysOnRcptLine(WarehouseReceiptLine, Abs(PurchaseLine.Quantity), Abs(PurchaseLine."Quantity (Base)"));
                end;
                //revisar vlrangel
            end;

            OnPurchLine2ReceiptLineOnAfterSetQtysOnRcptLine(WarehouseReceiptLine, PurchaseLine);
            "Starting Date" := PurchaseLine."Planned Receipt Date";
            if "Location Code" = WarehouseReceiptHeader."Location Code" then
                "Bin Code" := WarehouseReceiptHeader."Bin Code";
            if "Bin Code" = '' then
                "Bin Code" := PurchaseLine."Bin Code";
            //  WhseCreateSourceDocument.UpdateReceiptLine(WarehouseReceiptLine, WarehouseReceiptHeader);

            // if RItemVarian.get(WarehouseReceiptLine."Item No.", WarehouseReceiptLine."Variant Code") then
            //     WarehouseReceiptLine."PfsItem Status" := RItemVarian."Item Status";

            OnPurchLine2ReceiptLineOnAfterUpdateReceiptLine(WarehouseReceiptLine, WarehouseReceiptHeader, PurchaseLine);
            //WhseCreateSourceDocument.CreateReceiptLine(WarehouseReceiptLine);
            CreateReceiptLine(WarehouseReceiptLine);

            OnAfterCreateRcptLineFromPurchLine(WarehouseReceiptLine, WarehouseReceiptHeader, PurchaseLine);
            exit(not HasErrorOccured());
        end;
    end;

    procedure CreateReceiptLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line")
    var
        Item: Record Item;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        // OnBeforeCreateReceiptLine(WarehouseReceiptLine, IsHandled);
        if IsHandled then
            exit;

        with WarehouseReceiptLine do begin
            Item."No." := "Item No.";
            Item.ItemSKUGet(Item, "Location Code", "Variant Code");
            "Shelf No." := Item."Shelf No.";
            Status := GetLineStatus();
            //    OnBeforeWhseReceiptLineInsert(WarehouseReceiptLine);
            Insert();
            //   OnAfterWhseReceiptLineInsert(WarehouseReceiptLine);
        end;
    end;


    procedure SetQtysOnRcptLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; Qty: Decimal; QtyBase: Decimal)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        // OnBeforeSetQtysOnRcptLine(WarehouseReceiptLine, Qty, QtyBase, IsHandled);
        if IsHandled then
            exit;

        with WarehouseReceiptLine do begin
            Quantity := Qty;
            "Qty. (Base)" := QtyBase;
            InitOutstandingQtys();
        end;

        //  OnAfterSetQtysOnRcptLine(WarehouseReceiptLine, Qty, QtyBase);
    end;

    procedure CheckIfFromPurchLine2ShptLine(PurchaseLine: Record "Purchase Line"): Boolean
    begin
        exit(CheckIfFromPurchLine2ShptLine(PurchaseLine, "Reservation From Stock"::" "));
    end;

    procedure CheckIfFromPurchLine2ShptLine(PurchaseLine: Record "Purchase Line"; ReservedFromStock: Enum "Reservation From Stock"): Boolean
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        IsHandled: Boolean;
        ReturnValue: Boolean;
    begin
        IsHandled := false;
        ReturnValue := false;

        OnBeforeCheckIfPurchLine2ShptLine(PurchaseLine, ReturnValue, IsHandled);
        if IsHandled then
            exit(ReturnValue);

        if PurchaseLine.IsNonInventoriableItem() then
            exit(false);

        if not PurchaseLine.CheckIfPurchaseLineMeetsReservedFromStockSetting(Abs(PurchaseLine."Outstanding Qty. (Base)"), ReservedFromStock) then
            exit(false);

        with WarehouseShipmentLine do begin
            SetSourceFilter(DATABASE::"Purchase Line", PurchaseLine."Document Type".AsInteger(), PurchaseLine."Document No.", PurchaseLine."Line No.", false);
            CalcSums("Qty. Outstanding (Base)");
            exit(Abs(PurchaseLine."Outstanding Qty. (Base)") > "Qty. Outstanding (Base)");
        end;
    end;

    procedure CheckIfPurchLine2ReceiptLine(PurchaseLine: Record "Purchase Line"): Boolean
    var
        ReturnValue: Boolean;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        ReturnValue := false;

        OnBeforeCheckIfPurchLine2ReceiptLine(PurchaseLine, ReturnValue, IsHandled);
        if IsHandled then
            exit(ReturnValue);

        if PurchaseLine.IsNonInventoriableItem() then
            exit(false);

        PurchaseLine.CalcFields("Whse. Outstanding Qty. (Base)");
        exit(Abs(PurchaseLine."Outstanding Qty. (Base)") > Abs(PurchaseLine."Whse. Outstanding Qty. (Base)"));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFromPurchLine2ShptLine(var PurchaseLine: Record "Purchase Line"; var Result: Boolean; var IsHandled: Boolean; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFromPurchLine2ShptLineOnAfterInitNewLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; PurchaseLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFromPurchLine2ShptLineOnBeforeCreateShptLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; PurchaseLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateShptLineFromPurchLine(var WarehouseShipmentLine: Record "Warehouse Shipment Line"; WarehouseShipmentHeader: Record "Warehouse Shipment Header"; PurchaseLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePurchLine2ReceiptLine(WarehouseReceiptHeader: Record "Warehouse Receipt Header"; var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean; var Result: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPurchLine2ReceiptLineOnAfterInitNewLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPurchLine2ReceiptLineOnAfterSetQtysOnRcptLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; PurchaseLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPurchLine2ReceiptLineOnAfterUpdateReceiptLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; var WhseReceiptHeader: Record "Warehouse Receipt Header"; PurchaseLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateRcptLineFromPurchLine(var WarehouseReceiptLine: Record "Warehouse Receipt Line"; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; PurchaseLine: Record "Purchase Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckIfPurchLine2ReceiptLine(var PurchaseLine: Record "Purchase Line"; var ReturnValue: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckIfPurchLine2ShptLine(var PurchaseLine: Record "Purchase Line"; var ReturnValue: Boolean; var IsHandled: Boolean)
    begin
    end;
}