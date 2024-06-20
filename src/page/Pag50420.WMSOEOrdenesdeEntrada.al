page 50420 "WMS OE-Ordenes de Entrada"
{
    ApplicationArea = All;
    Caption = 'WMS OE-Ordenes de Entrada';
    PageType = List;
    SourceTable = "WMS OE-Ordenes de Entrada";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(tipoOperacion; Rec.tipoOperacion)
                {
                    ToolTip = 'Specifies the value of the tipoOperacion field.';
                }
                field(codigoOrdenEntrada; Rec.codigoOrdenEntrada)
                {
                    ToolTip = 'Specifies the value of the codigoOrdenEntrada field.';
                }
                field(tipoCentroOrigen; Rec.tipoCentroOrigen)
                {
                    ToolTip = 'Specifies the value of the tipoCentroOrigen field.';
                }
                field(tipoOrdenEntrada; Rec.tipoOrdenEntrada)
                {
                    ToolTip = 'Specifies the value of the tipoOrdenEntrada field.';
                }
                field(lineaOrdenEntrada; Rec.lineaOrdenEntrada)
                {
                    ToolTip = 'Specifies the value of the lineaOrdenEntrada field.';
                }
                field(codigoOrdenCompraERP; Rec.codigoOrdenCompraERP)
                {
                    ToolTip = 'Specifies the value of the codigoOrdenCompraERP field.';
                }
                field(codigoCentroOrigen; Rec.codigoCentroOrigen)
                {
                    ToolTip = 'Specifies the value of the codigoCentroOrigen field.';
                }
                field(fechaVencimiento; Rec.fechaVencimiento)
                {
                    ToolTip = 'Specifies the value of the fechaVencimiento field.';
                }
                field(fechaEntrega; Rec.fechaEntrega)
                {
                    ToolTip = 'Specifies the value of the fechaEntrega field.';
                }
                field(comentario; Rec.comentario)
                {
                    ToolTip = 'Specifies the value of the comentario field.';
                }
                field(lineaEntregaERP; Rec.lineaEntregaERP)
                {
                    ToolTip = 'Specifies the value of the lineaEntregaERP field.';
                }
                field(codigoEntregaERP; Rec.codigoEntregaERP)
                {
                    ToolTip = 'Specifies the value of the codigoEntregaERP field.';
                }
                field(estadoCalidad; Rec.estadoCalidad)
                {
                    ToolTip = 'Specifies the value of the estadoCalidad field.';
                }
                field(codigoArticuloERP; Rec.codigoArticuloERP)
                {
                    ToolTip = 'Specifies the value of the codigoArticuloERP field.';
                }
                field(codigoDocumentoEntrada; Rec.codigoDocumentoEntrada)
                {
                    ToolTip = 'Specifies the value of the codigoDocumentoEntrada field.';
                }
                field(motivoDevolucion; Rec.motivoDevolucion)
                {
                    ToolTip = 'Specifies the value of the motivoDevolucion field.';
                }
                field(tolerancia; Rec.tolerancia)
                {
                    ToolTip = 'Specifies the value of the tolerancia field.';
                }
                field(cantidad; Rec.cantidad)
                {
                    ToolTip = 'Specifies the value of the cantidad field.';
                }
                field(cantidadLineaEntregaERP; Rec.cantidadLineaEntregaERP)
                {
                    ToolTip = 'Specifies the value of the cantidadLineaEntregaERP field.';
                }
            }
        }
    }
}
