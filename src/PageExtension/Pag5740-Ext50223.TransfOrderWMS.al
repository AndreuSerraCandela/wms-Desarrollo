pageextension 50223 TransfOrderWMS extends "Transfer Order" //5740
{
    layout
    {
        addafter("No. pedido venta")
        {

            field("Tipo de entrega"; Rec."Tipo de entrega")
            {
                ApplicationArea = All;
                //  ToolTip = 'Specifies the value of the Tipo de entrega field.';
                ToolTip = 'Specifies the value of the Tipo de entrega field.', comment = 'ESP="Especifica el valor de Tipo de Entrega"';
                Caption = 'Tipo de entrega';
            }
        }
    }
}
