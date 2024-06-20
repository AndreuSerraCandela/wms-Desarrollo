namespace wms.wms;

pageextension 50319 PfsItemHorzComponents extends "PfsItem Horz Components" //96111
{
    layout
    {
        addbefore("Variant Component")
        {

            field(Encajado; Rec.Encajado)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Encajado field.';
            }
        }

    }
}
