page 50415 SubLineasControlIntegracion
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Control integracion WMS";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Interface"; Rec."Interface")
                {
                    ToolTip = 'Specifies the value of the Interface field.';
                }
                field("Tipo documento"; Rec."Tipo documento")
                {
                    ToolTip = 'Specifies the value of the Tipo documento field.';
                }
                field("No. documento"; Rec."No. documento")
                {
                    ToolTip = 'Specifies the value of the No. documento field.';
                }
                field("No. registro"; Rec."No. registro")
                {
                    ToolTip = 'Specifies the value of the No. registro field.';
                }
                field(Estado; Rec.Estado)
                {
                    ToolTip = 'Specifies the value of the Estado field.';
                }
                field("Estado SEGA"; Rec."Estado SEGA")
                {
                    ToolTip = 'Specifies the value of the Estado SEGA field.';
                }
                field("Fecha y hora enviado WS"; Rec."Fecha y hora enviado WS")
                {
                    ToolTip = 'Specifies the value of the Fecha y hora enviado WS field.';
                }

            }
        }
       
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}