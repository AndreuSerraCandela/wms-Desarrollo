pageextension 50224 WarehouseSetupWMS extends "Warehouse Setup" //5775
{
    layout
    {
        addbefore(Numbering)

        {
            group("Integracion WMS")
            {
                Caption = 'Integracion WMS';
                field("Ruta ficheros integracion WMS"; Rec."Ruta ficheros integracion WMS")
                {
                    ApplicationArea = All;
                    //   ToolTip = 'Specifies the value of the Ruta ficheros integracion WMS field.';
                    ToolTip = 'Specifies the value of the Ruta ficheros integracion WMS field.', comment = 'ESP=Especifica el valor del campo Ruta ficheros integracion WMS.';
                    Caption = 'Ruta ficheros integracion WMS';
                    AssistEdit = true;
                    trigger OnAssistEdit()
                    var
                        CduCommDialog: Dialog;
                        lRutaCompleta: Text;
                        lx: Integer;
                        var1: Text;
                        filemanaget: Codeunit "File Management";

                    begin
                        var1 := '*.xls';

                        filemanaget.CombinePath(lRutaCompleta, var1);
                        lRutaCompleta := filemanaget.GetDirectoryName(lRutaCompleta);

                        // //EX-SGG-WMS 170619
                        // CLEAR(CduCommDialog);
                        // //   lRutaCompleta := CduCommDialog.OpenFile('Seleccione una ubicación', 'Archivos', 5, '*.xls', 1);
                        // CduCommDialog.Open('Seleccione una ubicación', lRutaCompleta);
                        // CduCommDialog.

                        //     // IF lRutaCompleta <> '' THEN BEGIN
                        //     lx := STRLEN(lRutaCompleta) + 1;
                        // REPEAT
                        //     lx -= 1;
                        // UNTIL COPYSTR(lRutaCompleta, lx, 1) = '\';
                        // "Ruta ficheros integracion WMS" := COPYSTR(lRutaCompleta, 1, lx);
                        // // END;
                    end;
                }
                field("URL integracion WS WMS"; Rec."URL integracion WS WMS")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the URL integracion WS WMS field.', comment = 'ESP=Especifica el valor del campo de URL intergracion WS WMS ';
                    Caption = 'URL integracion WS WMS';
                }
                field("No. serie mensaje SEGA OE"; Rec."No. serie mensaje SEGA OE")
                {
                    ApplicationArea = All;
                    //ToolTip = 'Specifies the value of the No. serie mensaje SEGA OE field.';
                    ToolTip = 'Specifies the value of the No. serie mensaje SEGA OE field.', comment = 'ESP=Especifica el valor del campo No. serie mensaje SEGA OE.';
                    Caption = 'No. serie mensaje SEGA OE';
                }
                field("No. serie mensaje SEGA PE"; Rec."No. serie mensaje SEGA PE")
                {
                    ApplicationArea = All;
                    // ToolTip = 'Specifies the value of the No. serie mensaje SEGA PE field.';
                    ToolTip = 'Specifies the value of the No. serie mensaje SEGA PE field.', comment = 'ESP=Especifica el valor de campo No. serie mensaje SEGA PE.';
                    Caption = 'No. serie mensaje SEGA PE';
                }
                field("Almacen predet. SEGA"; Rec."Almacen predet. SEGA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Almacen predet. SEGA field.', comment = 'ESP=Especifica el valor del campo Almacen predet. SEGA.';
                    Caption = 'Almacen predet. SEGA';
                }
                group("AS- Ajuste de Stock")
                {
                    Caption = 'AS- Ajuste de Stock';
                    field("Libro Diario Producto"; Rec."Libro Diario Producto")
                    {
                        ApplicationArea = All;
                        // ToolTip = 'Specifies the value of the Libro Diario Producto field.';
                        ToolTip = 'Specifies the value of the Libro Diario Producto field.', comment = 'ESP=Especifica el valor del campo Libro Diario Producto.';
                        Caption = 'Libro Diario Producto';
                    }
                    field("Seccion Diario Producto"; Rec."Seccion Diario Producto")
                    {
                        ApplicationArea = All;
                        //   ToolTip = 'Specifies the value of the Seccion Diario Producto field.';
                        ToolTip = 'Specifies the value of the Seccion Diario Producto field.', comment = 'ESP=Especifica el valor del campo Seccion Diario Producto.';
                        Caption = 'Seccion Diario Producto';
                    }
                }
                group("SA-Stock Actual")
                {
                    Caption = 'SA-Stock Actual';
                    field("Libro Diario Inventario"; Rec."Libro Diario Inventario")
                    {
                        ApplicationArea = All;
                        // ToolTip = 'Specifies the value of the Libro Diario Inventario field.';
                        ToolTip = 'Specifies the value of the Libro Diario Inventario field.', comment = 'ESP=Especifica el valor del campo Libro Diario Inventario.';
                        Caption = 'Libro Diario Inventario';
                    }
                    field("Seccion Diario Inventario"; Rec."Seccion Diario Inventario")
                    {
                        ApplicationArea = All;
                        // ToolTip = 'Specifies the value of the Sección Diario Inventario field.';
                        ToolTip = 'Specifies the value of the Sección Diario Inventario field.', comment = 'ESP=Especifica el valor del campo Seccion Diario Inventario.';
                        Caption = 'Sección Diario Inventario';
                    }
                }
                group("Gestiones servicio NAS")
                {
                    Caption = 'Gestiones servicio NAS';
                    field("Mensajes PE"; Rec."Mensajes PE")
                    {
                        ApplicationArea = All;
                        //  ToolTip = 'Specifies the value of the Mensajes PE field.';
                        ToolTip = 'Specifies the value of the Mensajes PE field.', comment = 'ESP=Especifica el valor del campo Mensajes PE.';
                        Caption = 'Mensajes PE';
                    }
                    field("Mensajes OE"; Rec."Mensajes OE")
                    {
                        ApplicationArea = All;
                        //   ToolTip = 'Specifies the value of the Mensajes OE field.';
                        ToolTip = 'Specifies the value of the Mensajes OE field.', comment = 'ESP=Especifica el valor del campo Mensajes OE.';
                        Caption = 'Mensajes OE';
                    }
                    field("Mensajes CS"; Rec."Mensajes CS")
                    {
                        ApplicationArea = All;
                        //    ToolTip = 'Specifies the value of the Mensajes CS field.';
                        ToolTip = 'Specifies the value of the Mensajes CS field.', comment = 'ESP=Especifica el valor del campo Mensajes CS.';
                        Caption = 'Mensajes CS';
                    }
                    field("Mensajes CE"; Rec."Mensajes CE")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Mensajes CE field.', comment = 'ESP=Especifica el valor del campo Mensajes CE.';
                        Caption = 'Mensajes CE';
                    }
                    field("Mensajes AS"; Rec."Mensajes AS")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Mensajes AS field.', comment = 'ESP=Especifica el valor del campo Mensajes AS.';
                        Caption = 'Mensajes AS';
                    }
                    field("Mensajes SA"; Rec."Mensajes SA")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Mensajes SA field.', comment = 'ESP=Especifica el valor del campo Mensajes SA.';
                        Caption = 'Mensajes SA';
                    }
                }
            }
        }
    }
}
