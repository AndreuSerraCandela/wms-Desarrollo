pageextension 50316 SourceDocument extends "Source Documents" //5793
{
    layout
    {
    }

    actions
    {
        addbefore("&Line")
        {
            action("Cantidad a recibir")
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    locrec_WhReceiptHeader: Record "Warehouse Receipt Header";
                begin

                    locrec_WhReceiptHeader.GET(CodigoRecepcion);
                    locrec_WhReceiptHeader.TraerDocOrigen := TRUE;
                    locrec_WhReceiptHeader.MODIFY;
                end;
            }
        }
    }
    procedure TraerDocRecepcionAlmacen(codRecep: Code[20])
    var
        myInt: Integer;
    begin

        //EX-OMI-WMS 230519
        CodigoRecepcion := codRecep;
    end;

    var
        CodigoRecepcion: Code[20];
}