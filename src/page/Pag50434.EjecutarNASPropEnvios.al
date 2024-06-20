page 50434 "Ejecutar NAS Prop.Envios"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Parametro Proposicion Envios";

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field(Parametro; Rec.Parametro)
                {
                    ToolTip = 'Specifies the value of the Parametro field.', Comment = 'ESP="Parametro"';
                }
                field("Filter Color"; Rec."Filter Color")
                {
                    ToolTip = 'Specifies the value of the EnglishText field.', Comment = 'ESP="YourLanguageText"';
                }
                field("Filter Customer"; Rec."Filter Customer")
                {
                    ToolTip = 'Specifies the value of the Filter Customer field.', Comment = 'ESP="Filtro Cliente"';
                }
                field("Filter Date Serv. OK"; Rec."Filter Date Serv. OK")
                {
                    ToolTip = 'Specifies the value of the Filter Date Serv. OK field.', Comment = 'ESP="Filtro Fecha Serv. confirmada"';
                }
                field("Filter Item"; Rec."Filter Item")
                {
                    ToolTip = 'Specifies the value of the Filter Item field.', Comment = 'ESP="Filtro Producto"';
                }
                field("Filter Order"; Rec."Filter Order")
                {
                    ToolTip = 'Specifies the value of the Filter Order field.', Comment = 'ESP="Filtro Pedido"';
                }
                field("Minimal customer risk"; Rec."Minimal customer risk")
                {
                    ToolTip = 'Specifies the value of the Minimal customer risk field.', Comment = 'ESP="Riesgo Minimo Cliente"';
                }
                field("Type Order"; Rec."Type Order")
                {
                    ToolTip = 'Specifies the value of the Type Order field.';
                }
                field(Temporada; Rec.Temporada)
                {
                    ToolTip = 'Specifies the value of the Temporada field.', Comment = 'ESP="Temporada"';
                }
                field("Type Services"; Rec."Type Services")
                {
                    ToolTip = 'Specifies the value of the Type Services field.', Comment = 'ESP="Tipo Servicio"';
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}