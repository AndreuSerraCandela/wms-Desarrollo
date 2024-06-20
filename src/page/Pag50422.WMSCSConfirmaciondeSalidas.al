page 50422 "WMS CS-Confirmacion de Salidas"
{
    ApplicationArea = All;
    Caption = 'WMS CS-Confirmacion de Salidas';
    PageType = List;
    SourceTable = "WMS CS-Confirmacion de Salidas";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
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
                field(codigoCentroDestino; Rec.codigoCentroDestino)
                {
                    ToolTip = 'Specifies the value of the codigoCentroDestino field.';
                }
                field(codigoCentroTransportista; Rec.codigoCentroTransportista)
                {
                    ToolTip = 'Specifies the value of the codigoCentroTransportista field.';
                }
                field(codigoContenedor; Rec.codigoContenedor)
                {
                    ToolTip = 'Specifies the value of the codigoContenedor field.';
                }
                field(codigoContenedor2; Rec.codigoContenedor2)
                {
                    ToolTip = 'Specifies the value of the codigoContenedor2 field.';
                }
                field(codigoEntregaERP; Rec.codigoEntregaERP)
                {
                    ToolTip = 'Specifies the value of the codigoEntregaERP field.';
                }
                field(fecha; Rec.fecha)
                {
                    ToolTip = 'Specifies the value of the fecha field.';
                }
                field(finCodigoEntregaERP; Rec.finCodigoEntregaERP)
                {
                    ToolTip = 'Specifies the value of the finCodigoEntregaERP field.';
                }
                field(hora; Rec.hora)
                {
                    ToolTip = 'Specifies the value of the hora field.';
                }
                field(identificadorExpedicion; Rec.identificadorExpedicion)
                {
                    ToolTip = 'Specifies the value of the identificadorExpedicion field.';
                }
                field(lineaEntregaERP; Rec.lineaEntregaERP)
                {
                    ToolTip = 'Specifies the value of the lineaEntregaERP field.';
                }
                field(matriculaVehiculo; Rec.matriculaVehiculo)
                {
                    ToolTip = 'Specifies the value of the matriculaVehiculo field.';
                }
                field(numeroBulto; Rec.numeroBulto)
                {
                    ToolTip = 'Specifies the value of the numeroBulto field.';
                }
                field(numeroMensaje; Rec.numeroMensaje)
                {
                    ToolTip = 'Specifies the value of the numeroMensaje field.';
                }
                field(tipoCentroDestino; Rec.tipoCentroDestino)
                {
                    ToolTip = 'Specifies the value of the tipoCentroDestino field.';
                }
                field(tipoCentroTransportista; Rec.tipoCentroTransportista)
                {
                    ToolTip = 'Specifies the value of the tipoCentroTransportista field.';
                }
                field(tipoContenedor; Rec.tipoContenedor)
                {
                    ToolTip = 'Specifies the value of the tipoContenedor field.';
                }
                field(tipoContenedor2; Rec.tipoContenedor2)
                {
                    ToolTip = 'Specifies the value of the tipoContenedor2 field.';
                }
            }
        }
    }
}
