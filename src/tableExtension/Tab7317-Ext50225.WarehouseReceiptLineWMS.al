tableextension 50225 WarehouseReceiptLineWMS extends "Warehouse Receipt Line" //7317
{
    fields
    {
        field(50400; "No. albaran proveedor"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
         field(50300; "Cod. temporada"; Code[20])
        {
            Description = 'EX-SGG-WMS 190619';
            Caption = 'Season code', comment = 'ESP="Cód. temporada"';
            DataClassification = ToBeClassified;
        }
        // field(50401; "Estado cabecera"; Option)
        // {
        //     //DataClassification = ToBeClassified;
        //     OptionMembers = Abierto,Lanzado;
        // }
    }



    procedure PfsItemBlocked(_NoMessage: Boolean; _Test: text[10]): Boolean
    var
        myInt: Integer;
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


    var
        Item: Record Item;
}
