pageextension 50426 WhseReceiptSubform extends "Whse. Receipt Subform" //5769
{
    layout
    {
        addlast(Control1)
        {

            field("Cod. temporada"; Rec."Cod. temporada")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Season code field.', Comment = '%ESP="Cód. temporada"';
            }
        }

    }
}