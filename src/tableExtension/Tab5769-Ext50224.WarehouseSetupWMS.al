tableextension 50224 WarehouseSetupWMS extends "Warehouse Setup" //5769
{
    fields
    {
        field(50400; "Libro Diario Producto"; Code[10])
        {
            Description = 'EX-OMI-WMS 230519';
            TableRelation = "Item Journal Template".Name WHERE(Type = CONST(Item),
                                                                "Page ID" = CONST(40));
            Caption = 'Libro Diario Producto';
        }
        field(50401; "Seccion Diario Producto"; Code[10])
        {
            Description = 'EX-OMI-WMS 230519';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Libro Diario Producto"));
            Caption = 'Seccion Diario Producto';
        }
        field(50402; "Ruta ficheros integracion WMS"; Text[250])
        {
            Description = 'EX-SGG-WMS 170619';
            Caption = 'Ruta ficheros integracion WMS';
        }
        field(50403; "URL integracion WS WMS"; Text[250])
        {
            Description = 'EX-SGG-WMS 170619';
            Caption = 'URL integracion WS WMS';
        }
        field(50404; "Libro Diario Inventario"; Code[10])
        {
            Description = 'EX-SGG-WMS 270619';
            TableRelation = "Item Journal Template".Name WHERE(Type = CONST("Phys. Inventory"),
                                                                "Page ID" = CONST(392));
            Caption = 'Libro Diario Inventario';
        }
        field(50405; "Seccion Diario Inventario"; Code[10])
        {
            Caption = 'Sección Diario Inventario';
            Description = 'EX-SGG-WMS 270619';
            TableRelation = "Item Journal Batch".Name WHERE("Journal Template Name" = FIELD("Libro Diario Inventario"));
        }
        field(50406; "No. serie mensaje SEGA PE"; Code[10])
        {
            Description = 'EX-SGG-WMS 160719';
            TableRelation = "No. Series";
            Caption = 'No. serie mensaje SEGA PE';
        }
        field(50407; "No. serie mensaje SEGA OE"; Code[10])
        {
            Description = 'EX-SGG-WMS 160719';
            TableRelation = "No. Series";
            Caption = 'No. serie mensaje SEGA OE';
        }
        field(50408; "Almacen predet. SEGA"; Code[10])
        {
            Description = 'EX-SGG-WMS 020919';
            TableRelation = Location;
            Caption = 'Almacen predet. SEGA';
        }
        field(50409; "Mensajes PE"; Option)
        {
            Description = 'EX-SGG-WMS 170919';
            OptionCaption = ' ,Obtener,Obtener y procesar,Obtener-procesar y comunicar';
            OptionMembers = " ",Obtener,"Obtener y procesar","Obtener-procesar y comunicar";
            Caption = 'Mensajes PE';
        }
        field(50410; "Mensajes OE"; Option)
        {
            Description = 'EX-SGG-WMS 170919';
            OptionCaption = ' ,Obtener,Obtener y procesar,Obtener-procesar y comunicar';
            OptionMembers = " ",Obtener,"Obtener y procesar","Obtener-procesar y comunicar";
            Caption = 'Mensajes OE';
        }
        field(50411; "Mensajes CS"; Option)
        {
            Description = 'EX-SGG-WMS 170919';
            OptionCaption = ' ,Obtener,Obtener y procesar,Obtener-procesar y registrar';
            OptionMembers = " ",Obtener,"Obtener y procesar","Obtener-procesar y registrar";
            Caption = 'Mensajes CS';
        }
        field(50412; "Mensajes CE"; Option)
        {
            Description = 'EX-SGG-WMS 170919';
            OptionCaption = ' ,Obtener,Obtener y procesar,Obtener-procesar y registrar';
            OptionMembers = " ",Obtener,"Obtener y procesar","Obtener-procesar y registrar";
            Caption = 'Mensajes CE';
        }
        field(50413; "Mensajes AS"; Option)
        {
            Description = 'EX-SGG-WMS 170919';
            OptionCaption = ' ,Obtener,Obtener y procesar,Obtener-procesar y registrar';
            OptionMembers = " ",Obtener,"Obtener y procesar","Obtener-procesar y registrar";
            Caption = 'Mensajes AS';
        }
        field(50414; "Mensajes SA"; Option)
        {
            Description = 'EX-SGG-WMS 170919';
            OptionCaption = ' ,Obtener,Obtener y procesar,Obtener-procesar y registrar';
            OptionMembers = " ",Obtener,"Obtener y procesar","Obtener-procesar y registrar";
            Caption = 'Mensajes SA';
        }
    }
}
