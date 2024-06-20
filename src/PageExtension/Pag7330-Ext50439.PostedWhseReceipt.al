namespace wms.wms;

using Microsoft.Warehouse.History;

pageextension 50439 PostedWhseReceipt extends "Posted Whse. Receipt" //7330
{

    layout
    {
        addafter("Posting Date")
        {

            field("Tipo de orden entrada"; Rec."Tipo de orden entrada")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tipo de orden entrada field.', Comment = '%';
                Editable = false;
            }
        }
    }
}
