pageextension 50226 PurchaseOrderSubformWMS extends "Purchase Order Subform" //54
{

    actions
    {
        addafter(DocAttach)
        {
            action("Asignaciones vtas-compras")
            {
                Caption = 'Asignaciones vtas-compras', Comment = 'ESP="Asignaciones vtas-compras"';
                ApplicationArea = All;
                Image = Calculate;
                ToolTip = 'Asignaciones vtas-compras';

                trigger OnAction()
                begin
                    AsignacionesVtasCompras();
                end;
            }


        }
    }


    PROCEDURE AsignacionesVtasCompras();
    VAR
        lRstAsignVtasCompras: Record "Asignaciones Vtas-Compras";
        AsignacionesVtasCompras: Page "Asignaciones Vtas-Compras";
    BEGIN
        //EX-SGG-WMS 250919

        lRstAsignVtasCompras.SETRANGE("Nº Pedido Compra", rec."Document No.");
        lRstAsignVtasCompras.SETRANGE(Producto, rec."No.");
        page.RUNMODAL(50433, lRstAsignVtasCompras);


    END;
}
