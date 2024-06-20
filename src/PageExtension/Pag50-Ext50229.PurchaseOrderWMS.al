pageextension 50229 PurchaseOrderWMS extends "Purchase Order" //50
{


    layout
    {


    }
    actions
    {
        addafter(MoveNegativeLines)
        {

            action("Create Whse. Receipt")
            {
                //Caption = 'Create Whse. Receipt', Comment = 'ESP="Crear recibo almacén Total Pedido"';
                Caption = 'Create Whse. Receipt', comment = 'ESP="Crear recibo almacén Total Pedido"';
                ApplicationArea = All;
                Image = Receipt;
                ToolTip = 'Create Whse. Receipt', comment = 'ESP="Crear recibo almacén Total Pedido"';

                trigger OnAction()
                var
                    GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                begin

                    GetSourceDocInbound.CreateFromPurchOrder(Rec);

                    IF NOT rec.FIND('=><') THEN
                        rec.INIT;
                end;
            }
            action("Crear recibo almacén cantidad a recibir")
            {
                //    Caption = 'Create Whse. Receipt Qty. to receive', Comment = 'ESP="Crear recibo almacén cantidad a recibir"';
                Caption = 'Create Whse. Receipt Qty. to receive', comment = 'ESP="Crear recibo almacén cantidad a recibir"';
                ApplicationArea = All;
                Image = Receipt;
                ToolTip = 'Create Whse. Receipt Qty. to receive', Comment = 'ESP="Crear recibo almacén cantidad a recibir"';

                trigger OnAction()
                var
                    //GetSourceDocInbound: Codeunit 50403;
                    // GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                    GetSourceDocInbound: Codeunit "Get Source Doc. Inbound WMS";

                begin
                    //TODO > VERO > WMS
                    GetSourceDocInbound.ReciboAlmacenCantidadRecibida(TRUE);
                    GetSourceDocInbound.CreateFromPurchOrder(Rec);

                    IF NOT rec.FIND('=><') THEN
                        rec.INIT;
                end;
            }
        }
        addafter(MoveNegativeLines_Promoted)
        {
            // actionref("Create Whse. Receipt_promoted"; "Create Whse. Receipt")
            // {
            // }
        }

    }
}
