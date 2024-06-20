page 50417 "WMS CE-Confirmación de entrada"
{
    ApplicationArea = All;
    Caption = 'WMS CE-Confirmación de entrada';
    PageType = List;
    SourceTable = "WMS CE-Confirmación de Entrada";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(fecha; Rec.fecha)
                {
                    ToolTip = 'Specifies the value of the fecha field.';
                }
                field(hora; Rec.hora)
                {
                    ToolTip = 'Specifies the value of the hora field.';
                }
                field(matriculaVehiculo; Rec.matriculaVehiculo)
                {
                    ToolTip = 'Specifies the value of the matriculaVehiculo field.';
                }
                field(tipoCentroTransportista; Rec.tipoCentroTransportista)
                {
                    ToolTip = 'Specifies the value of the tipoCentroTransportista field.';
                }
                field(codigoCentroTransportista; Rec.codigoCentroTransportista)
                {
                    ToolTip = 'Specifies the value of the codigoCentroTransportista field.';
                }
                field(lineaOrdenEntrada; Rec.lineaOrdenEntrada)
                {
                    ToolTip = 'Specifies the value of the lineaOrdenEntrada field.';
                }
                field(codigoArticuloERP; Rec.codigoArticuloERP)
                {
                    ToolTip = 'Specifies the value of the codigoArticuloERP field.';
                }
                field(Cantidad; Rec.Cantidad)
                {
                    ToolTip = 'Specifies the value of the Cantidad field.';
                }
                field(estadoCalidad; Rec.estadoCalidad)
                {
                    ToolTip = 'Specifies the value of the estadoCalidad field.';
                }
                field(tipoCentroOrigen; Rec.tipoCentroOrigen)
                {
                    ToolTip = 'Specifies the value of the tipoCentroOrigen field.';
                }
                field(codigoCentroOrigen; Rec.codigoCentroOrigen)
                {
                    ToolTip = 'Specifies the value of the codigoCentroOrigen field.';
                }
                field(codigoOrdenEntrada; Rec.codigoOrdenEntrada)
                {
                    ToolTip = 'Specifies the value of the codigoOrdenEntrada field.';
                }
                field(finCodigoOrdenEntrada; Rec.finCodigoOrdenEntrada)
                {
                    ToolTip = 'Specifies the value of the finCodigoOrdenEntrada field.';
                }
                field(codigoOrdenCompraERP; Rec.codigoOrdenCompraERP)
                {
                    ToolTip = 'Specifies the value of the codigoOrdenCompraERP field.';
                }
                field(tipoDocumentoRecibido; Rec.tipoDocumentoRecibido)
                {
                    ToolTip = 'Specifies the value of the tipoDocumentoRecibido field.';
                }
                field(codigoDocumentoRecibido; Rec.codigoDocumentoRecibido)
                {
                    ToolTip = 'Specifies the value of the codigoDocumentoRecibido field.';
                }
                field(Obtenido; Rec.Obtenido)
                {
                    ToolTip = 'Specifies the value of the Obtenido field.';
                }
            }
        }
    }
}
