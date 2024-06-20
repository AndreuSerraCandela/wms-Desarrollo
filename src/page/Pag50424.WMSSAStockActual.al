page 50424 "WMS SA-Stock Actual"
{
    ApplicationArea = All;
    Caption = 'WMS SA-Stock Actual';
    PageType = List;
    SourceTable = "WMS SA-Stock Actual";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(cantidad; Rec.cantidad)
                {
                    ToolTip = 'Specifies the value of the cantidad field.';
                }
                field(claseStock; Rec.claseStock)
                {
                    ToolTip = 'Specifies the value of the claseStock field.';
                }
                field(codigoArticuloERP; Rec.codigoArticuloERP)
                {
                    ToolTip = 'Specifies the value of the codigoArticuloERP field.';
                }
                field(estadoCalidad; Rec.estadoCalidad)
                {
                    ToolTip = 'Specifies the value of the estadoCalidad field.';
                }
                field(fecha; Rec.fecha)
                {
                    ToolTip = 'Specifies the value of the fecha field.';
                }
                field(hora; Rec.hora)
                {
                    ToolTip = 'Specifies the value of the hora field.';
                }
                field(identificadorStock; Rec.identificadorStock)
                {
                    ToolTip = 'Specifies the value of the identificadorStock field.';
                }
                field(numeroMensaje; Rec.numeroMensaje)
                {
                    ToolTip = 'Specifies the value of the numeroMensaje field.';
                }
            }
        }
    }
}
