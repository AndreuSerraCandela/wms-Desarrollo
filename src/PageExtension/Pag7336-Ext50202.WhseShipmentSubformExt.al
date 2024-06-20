/// <summary>
/// PageExtension WhseShipmentSubformExt (ID 50202) extends Record Whse. Shipment Subform //7336.
/// </summary>
pageextension 50202 "WhseShipmentSubformExt" extends "Whse. Shipment Subform" //7336
{
    layout
    {
        addbefore("Item No.")
        {
            field(ProductoBloqueado; Rec.PfsItemBlocked(true, '3'))
            {
                ToolTip = 'Specifies the value of the PfsItemBlocked(true, ''3'') field.';
                //StyleExpr = PfsItemBlocked(TRUE, '3');
                ApplicationArea = All;
                Caption = 'PfsItemBlocked(true, ''3'')';
                Visible = false;
            }
            field(ClienteBloqueado; Rec.PfsCheckCustBlocked())
            {
                ToolTip = 'Specifies the value of the PfsCheckCustBlocked() field.';
                ApplicationArea = All;
                Caption = 'PfsCheckCustBlocked()';
                Visible = false;
            }
           
            field("Source Type"; Rec."Source Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the number of the table that is the source of the receipt line.';
            }
        }
        addafter(Description)
        {
        

            field("Cod. temporada"; Rec."Cod. temporada")
            {
                ApplicationArea = All;
                Editable = false;
            }

        }
    }
}