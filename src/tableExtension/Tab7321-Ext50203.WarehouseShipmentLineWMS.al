/// <summary>
/// TableExtension WarehouseShipmentLineWMS (ID 50203) extends Record Warehouse Shipment Line //7321.
/// </summary>
tableextension 50203 "WarehouseShipmentLineWMS" extends "Warehouse Shipment Line" //7321
{
    fields
    {
        field(50400; "Cod. temporada"; Code[20])
        {
            Description = 'EX-SGG-WMS 190619';
            Caption = 'Season code', comment = 'ESP="Cód. temporada"';
            DataClassification = ToBeClassified;
        }
        field(50401; "Estado cabecera"; Option)
        {
            Caption = 'Status', comment = 'ESP="Estado cabecera"';
            Description = 'EX-SGG-WMS 190619';
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
            DataClassification = ToBeClassified;
        }
    }
    trigger OnModify()
    begin

        IF (NOT SaltarEnviadoASEGA) AND (CurrFieldNo <> 0) THEN //EX-SGG-WMS 170919 011019
         BEGIN
            //EX-SGG-WMS 260619
            GetWhseShptHeader("No.");
            WhseShptHeader.CompruebaEnviadoASEGA();
            //FIN EX-SGG-WMS 260619
        END;
    end;

    trigger OnDelete()
    begin
      //  PfsMatrixControl.CheckRemainingMainLine(Rec); // Pfs7.50

        IF NOT SaltarEnviadoASEGA THEN //EX-SGG-WMS 170919
         BEGIN
            //EX-SGG-WMS 260619
            GetWhseShptHeader("No.");
            WhseShptHeader.CompruebaEnviadoASEGA();
            //FIN EX-SGG-WMS 260619
        END;
    end;

    /// <summary>
    /// PfsCheckCustBlocked.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    procedure PfsCheckCustBlocked(): Boolean
    begin

        IF rec."Destination Type" <> "Destination Type"::Customer THEN
            EXIT;
        IF "Destination No." = '' THEN
            EXIT;
        IF NOT PfsCustomer.GET("Destination No.") THEN
            CLEAR(PfsCustomer);

        PfsCustomer.CheckBlockedCustOnDocs(PfsCustomer, rec."Destination Type", false, PfsCustBlocked);
    end;

    /// <summary>
    /// PfsItemBlocked.
    /// </summary>
    /// <param name="_NoMessage">Boolean.</param>
    /// <param name="_Test">Text[10].</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure PfsItemBlocked(_NoMessage: Boolean; _Test: Text[10]): Boolean
    var

        ItemVariant: Record "Item Variant";
    begin

        IF NOT Item.GET("Item No.") THEN
            CLEAR(Item);
        IF NOT ItemVariant.GET("Item No.", "Variant Code") THEN
            CLEAR(ItemVariant);
        //TODO
        /*
                "PfsItem Status" := ItemVariant."PfsItem Status";
                IF "PfsItem Status" = '' THEN
                    "PfsItem Status" := Item."PfsItem Status";

                IF "PfsItem Status" <> '' THEN BEGIN
                    PfsControl.SetSurpressItemStatusWarning(_NoMessage);
                    EXIT(NOT PfsControl.CheckItemStatus("PfsItem Status", _Test));
                END;
                */
        EXIT(FALSE);
    end;

    /// <summary>
    /// PfsSetCalledFromWhseActReg.
    /// </summary>
    /// <param name="NewCalledFromWhseActRegister">Boolean.</param>
    procedure PfsSetCalledFromWhseActReg(NewCalledFromWhseActRegister: Boolean)
    begin
        PfsIsCalledFromWhseActRegister := NewCalledFromWhseActRegister;
    end;

    /// <summary>
    /// SaltarComprobacionEnviadoASEGA.
    /// </summary>
    /// <param name="lSaltarEnviadoASEGA">Boolean.</param>
    procedure SaltarComprobacionEnviadoASEGA(lSaltarEnviadoASEGA: Boolean)
    begin
        SaltarEnviadoASEGA := lSaltarEnviadoASEGA;
    end;

    /// <summary>
    /// PfsTransferFromCustomer.
    /// </summary>
    /// <param name="SourceRec">Record Customer.</param>
    procedure PfsTransferFromCustomer(SourceRec: Record Customer)
    begin
        //TODO
        SourceRec.CALCFIELDS("Balance (LCY)");
        //  "PfsBalance (LCY)" := SourceRec."Balance (LCY)";
        //  "PfsCredit Limit (LCY)" := SourceRec."Credit Limit (LCY)";
    end;

    /// <summary>
    /// PfsSetSuspendStatusCheck.
    /// </summary>
    /// <param name="Suspend">Boolean.</param>
    procedure PfsSetSuspendStatusCheck(Suspend: Boolean)
    begin
        PfsSuspendStatusCheck := Suspend;
    end;

    var
     //   PfsMatrixControl: Codeunit PfsMatrixControl7321;
        SaltarEnviadoASEGA: Boolean;
        PfsSuspendStatusCheck: Boolean;
        PfsIsCalledFromWhseActRegister: Boolean;
        Item: Record Item;
        PfsCustomer: Record Customer;
        PfsCustBlocked: Boolean;
}