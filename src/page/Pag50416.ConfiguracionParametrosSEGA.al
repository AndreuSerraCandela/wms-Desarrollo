/// <summary>
/// Page Configuracion Parametros SEGA (ID 50416).
/// </summary>
page 50416 "Configuracion Parametros SEGA"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Configuracion Parametros SEGA";
    // CaptionML = ENU = 'Configuracion Parametros SEGA',                ESP = 'Configuracion Parametros SEGA';
    Caption = 'Configuracion Parametros SEGA', comment = 'ESP="Configuracion Parametros SEGA"';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Caption = 'General';
                field(Tipo; Rec.Tipo)
                {
                    ToolTip = 'Specifies the value of the Tipo field.', comment = 'ESP="Especifica el valor Tipo"';

                }
                field(Codigo; Rec.Codigo)
                {
                    //  ToolTip = 'Specifies the value of the Codigo field.';
                    ToolTip = 'Specifies the value of the Codigo field.', comment = 'ESP="Especificar el valor Codigo"';

                }
                field(Descripcion; Rec.Descripcion)
                {
                    //   ToolTip = 'Specifies the value of the Descripcion field.';
                    ToolTip = 'Specifies the value of the Descripcion field.', comment = 'ESP="Especifica el valor de la Descripcion"';

                }
                field("Requiere manipulacion"; Rec."Requiere manipulacion")
                {
                    ToolTip = 'Specifies the value of the Requiere manipulacion field.', comment = 'ESP="Especifica el valor Requiere manipulacion"';
                }
                field("Verificar expedicion"; Rec."Verificar expedicion")
                {

                    ToolTip = 'Specifies the value of the Verificar expedicion field.', comment = 'ESP="Especifica el valor de Verificar"';
                }
                field("Indicador personalizado"; Rec."Indicador personalizado")
                {

                    ToolTip = 'Specifies the value of the Indicador personalizado field.', comment = 'ESP="Especifica el valor Indicador personalizado"';
                }
                field("Preparacion mono referencia"; Rec."Preparacion mono referencia")
                {

                    ToolTip = 'Specifies the value of the Preparacion mono referencia field.', comment = 'ESP="Especifica el valor Preparacion mono referencia"';
                }
                field("Caja anonima"; Rec."Caja anonima")
                {

                    ToolTip = 'Specifies the value of the Caja anonima field.', comment = 'ESP="Especifica el valor de Caja anomima"';
                }
            }
        }
        area(Factboxes) { }
    }
   

   
}