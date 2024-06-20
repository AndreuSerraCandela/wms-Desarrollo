/// <summary>
/// Page Asignaciones Vtas-Compras (ID 50433).
/// </summary>
page 50433 "Asignaciones Vtas-Compras"
{
    ApplicationArea = All;
    Caption = 'Asignaciones Vtas-Compras', comment = 'ESP="Asignaciones Vtas-Compras"';
    PageType = List;
    SourceTable = "Asignaciones Vtas-Compras";
    UsageCategory = Lists;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Nº Pedido Venta"; Rec."Nº Pedido Venta")
                {
                    ToolTip = 'Specifies the value of the Nº Pedido Venta field.';
                }
                field("Nº Linea Pedido Venta"; Rec."Nº Linea Pedido Venta")
                {
                    ToolTip = 'Specifies the value of the Nº Linea Pedido Venta field.';
                }
                field(Producto; Rec.Producto)
                {
                    ToolTip = 'Specifies the value of the Producto field.';
                }
                field(Variante; Rec.Variante)
                {
                    ToolTip = 'Specifies the value of the Variante field.';
                }
                field("Nº Pedido Compra"; Rec."Nº Pedido Compra")
                {
                    ToolTip = 'Specifies the value of the Nº Pedido Compra field.';
                }
                field("Nº Linea Pedido Compra"; Rec."Nº Linea Pedido Compra")
                {
                    ToolTip = 'Specifies the value of the Nº Linea Pedido Compra field.';
                }
                field("Cantidad Asignada"; Rec."Cantidad Asignada")
                {
                    ToolTip = 'Specifies the value of the Cantidad Asignada field.';
                }
                field("Tipo Asignación"; Rec."Tipo Asignación")
                {
                    ToolTip = 'Specifies the value of the Tipo Asignación field.';
                }
                field(Preembalado; Rec.Preembalado)
                {
                    ToolTip = 'Specifies the value of the Preembalado field.';
                }
                field("Fecha Pedido Venta"; Rec."Fecha Pedido Venta")
                {
                    ToolTip = 'Specifies the value of the Fecha Pedido Venta field.';
                }
            }
        }
    }
}
