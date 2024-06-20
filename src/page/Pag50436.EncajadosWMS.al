namespace wms.wms;

page 50436 "Encajados WMS"
{
    ApplicationArea = All;
    Caption = 'Encajados WMS';
    PageType = List;
    SourceTable = "Encajados WMS";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Codigo; Rec.Codigo)
                {
                    ToolTip = 'Specifies the value of the Codigo field.';
                }
                field("Alto caja unidad (mm)"; Rec."Alto caja unidad (mm)")
                {
                    ToolTip = 'Specifies the value of the Alto caja unidad (mm) field.';
                }
                field("Ancho caja unidad (mm)"; Rec."Ancho caja unidad (mm)")
                {
                    ToolTip = 'Specifies the value of the Ancho caja unidad (mm) field.';
                }
                field("Largo caja agrupacion (mm)"; Rec."Largo caja agrupacion (mm)")
                {
                    ToolTip = 'Specifies the value of the Largo caja agrupacion (mm) field.';
                }
                field("Volumen unidad (c3)"; Rec."Volumen unidad (c3)")
                {
                    ToolTip = 'Specifies the value of the Volumen unidad (c3) field.';
                }
                field("Alto caja agrupacion (mm)"; Rec."Alto caja agrupacion (mm)")
                {
                    ToolTip = 'Specifies the value of the Alto caja agrupacion (mm) field.';
                }
                field("Largo caja unidad (mm)"; Rec."Largo caja unidad (mm)")
                {
                    ToolTip = 'Specifies the value of the Largo caja unidad (mm) field.';
                }
                field("Volumen Agrupacion (c3)"; Rec."Volumen Agrupacion (c3)")
                {
                    ToolTip = 'Specifies the value of the Volumen Agrupacion (c3) field.';
                }
                field("Ancho caja agrupacion (mm)"; Rec."Ancho caja agrupacion (mm)")
                {
                    ToolTip = 'Specifies the value of the Ancho caja agrupacion (mm) field.';
                }
                field("Paletizacion cajas por nivel"; Rec."Paletizacion cajas por nivel")
                {
                    ToolTip = 'Specifies the value of the Paletizacion cajas por nivel field.';
                }
                field("Paletizacion niveles por palet"; Rec."Paletizacion niveles por palet")
                {
                    ToolTip = 'Specifies the value of the Paletizacion niveles por palet field.';
                }
                field("Unidades por caja agrupacion"; Rec."Unidades por caja agrupacion")
                {
                    ToolTip = 'Specifies the value of the Unidades por caja agrupacion field.';
                }
            }
        }
    }
}
