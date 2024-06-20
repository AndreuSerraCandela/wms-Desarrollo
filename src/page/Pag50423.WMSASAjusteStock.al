page 50423 "WMS AS-Ajuste Stock"
{
    ApplicationArea = All;
    Caption = 'WMS AS-Ajuste Stock';
    PageType = List;
    SourceTable = "WMS AS-Ajuste Stock";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Integrado; Rec.Integrado)
                {
                    ToolTip = 'Specifies the value of the Integrado field.';
                }
                field(Obtenido; Rec.Obtenido)
                {
                    ToolTip = 'Specifies the value of the Obtenido field.';
                }
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
                field(codigoOrdenEntrada; Rec.codigoOrdenEntrada)
                {
                    ToolTip = 'Specifies the value of the codigoOrdenEntrada field.';
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
                field(identificadorAjuste; Rec.identificadorAjuste)
                {
                    ToolTip = 'Specifies the value of the identificadorAjuste field.';
                }
                field(motivoAjuste; Rec.motivoAjuste)
                {
                    ToolTip = 'Specifies the value of the motivoAjuste field.';
                }
                field(numeroMensaje; Rec.numeroMensaje)
                {
                    ToolTip = 'Specifies the value of the numeroMensaje field.';
                }
                field(observaciones; Rec.observaciones)
                {
                    ToolTip = 'Specifies the value of the observaciones field.';
                }
                field(tipoAjuste; Rec.tipoAjuste)
                {
                    ToolTip = 'Specifies the value of the tipoAjuste field.';
                }
            }
        }
    }
}
