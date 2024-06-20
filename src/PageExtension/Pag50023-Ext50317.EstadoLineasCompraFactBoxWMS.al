pageextension 50317 EstadoLineasCompraFactBoxWMS extends EstadoLineasCompraFactBox //50023
{

    layout
    {
        addlast(Control2)
        {
            field(Recepciones; Rec.Recepciones)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Recepciones field.', Comment = 'ESP="Recepciones"';
            }
        }
    }
}