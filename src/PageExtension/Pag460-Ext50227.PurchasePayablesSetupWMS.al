pageextension 50227 PurchasePayablesSetupWMS extends "Purchases & Payables Setup" //460
{
    layout
    {
        addlast(General_NM)
        {
            field("Fecha Vto orden"; rec."Fecha Vto orden entrada")
            {
                ApplicationArea = All;
                Caption = 'Fecha Vto. Orden entrada', comment = 'ESP="Fecha Vto. Orden entrada"';
                ToolTip = 'Specifies the value of Order Due Date field.', comment = 'ESP="Especifica el valor del campo Fecha Vto orden"';
            }
        }
    }
}
