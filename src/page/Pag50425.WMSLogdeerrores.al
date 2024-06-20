page 50425 "WMS Log de errores"
{
    ApplicationArea = All;
    Caption = 'WMS Log de errores';
    PageType = List;
    SourceTable = "WMS Log de errores";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Descripcion; Rec.Descripcion)
                {
                    ToolTip = 'Specifies the value of the Descripción field.';
                }
                field("Fecha y hora"; Rec."Fecha y hora")
                {
                    ToolTip = 'Specifies the value of the Fecha y hora field.';
                }
                field("Id. WMS"; Rec."Id. WMS")
                {
                    ToolTip = 'Specifies the value of the Id. WMS field.';
                }
                field("Interface"; Rec."Interface")
                {
                    ToolTip = 'Specifies the value of the Interface field.';
                }
                field("No. documento"; Rec."No. documento")
                {
                    ToolTip = 'Specifies the value of the No. documento field.';
                }
                field("No. registro"; Rec."No. registro")
                {
                    ToolTip = 'Specifies the value of the No. registro field.';
                }
                field("No. registro control rel."; Rec."No. registro control rel.")
                {
                    ToolTip = 'Specifies the value of the No. registro control rel. field.';
                }
                field("Respuesta SEGA"; Rec."Respuesta SEGA")
                {
                    ToolTip = 'Specifies the value of the Respuesta SEGA field.';
                }
                field("Tipo documento"; Rec."Tipo documento")
                {
                    ToolTip = 'Specifies the value of the Tipo documento field.';
                }
            }
        }
    }
}
