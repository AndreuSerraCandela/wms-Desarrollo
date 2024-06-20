page 50421 "WMS PE-Pedidos"
{
    ApplicationArea = All;
    Caption = 'WMS PE-Pedidos';
    PageType = List;
    SourceTable = "WMS PE-Pedidos";
    UsageCategory = Lists;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(CodigoPedidoERP; Rec.CodigoPedidoERP)
                {
                    ToolTip = 'Specifies the value of the CodigoPedidoERP field.';
                }
                field(Integrado; Rec.Integrado)
                {
                    ToolTip = 'Specifies the value of the Integrado field.';
                }
                field("No. registro"; Rec."No. registro")
                {
                    ToolTip = 'Specifies the value of the No. registro field.';
                }
                field(cantidad; Rec.cantidad)
                {
                    ToolTip = 'Specifies the value of the cantidad field.';
                }
                field(ciudadCliente; Rec.ciudadCliente)
                {
                    ToolTip = 'Specifies the value of the ciudadCliente field.';
                }
                field(ciudadReceptor; Rec.ciudadReceptor)
                {
                    ToolTip = 'Specifies the value of the ciudadReceptor field.';
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
                field(codigoCliente; Rec.codigoCliente)
                {
                    ToolTip = 'Specifies the value of the codigoCliente field.';
                }
                field(codigoEntregaERP; Rec.codigoEntregaERP)
                {
                    ToolTip = 'Specifies the value of the codigoEntregaERP field.';
                }
                field(codigoPedidoCliente; Rec.codigoPedidoCliente)
                {
                    ToolTip = 'Specifies the value of the codigoPedidoCliente field.';
                }
                field(codigoPostalCliente; Rec.codigoPostalCliente)
                {
                    ToolTip = 'Specifies the value of the codigoPostalCliente field.';
                }
                field(codigoPostalReceptor; Rec.codigoPostalReceptor)
                {
                    ToolTip = 'Specifies the value of the codigoPostalReceptor field.';
                }
                field(codigoTipoRuta; Rec.codigoTipoRuta)
                {
                    ToolTip = 'Specifies the value of the codigoTipoRuta field.';
                }
                field(departamentoCliente; Rec.departamentoCliente)
                {
                    ToolTip = 'Specifies the value of the departamentoCliente field.';
                }
                field(direccionCliente; Rec.direccionCliente)
                {
                    ToolTip = 'Specifies the value of the direccionCliente field.';
                }
                field(direccionCliente2; Rec.direccionCliente2)
                {
                    ToolTip = 'Specifies the value of the direccionCliente2 field.';
                }
                field(direccionReceptor; Rec.direccionReceptor)
                {
                    ToolTip = 'Specifies the value of the direccionReceptor field.';
                }
                field(direccionReceptor2; Rec.direccionReceptor2)
                {
                    ToolTip = 'Specifies the value of the direccionReceptor2 field.';
                }
                field(fechaGeneracion; Rec.fechaGeneracion)
                {
                    ToolTip = 'Specifies the value of the fechaGeneracion field.';
                }
                field(fechaServicio; Rec.fechaServicio)
                {
                    ToolTip = 'Specifies the value of the fechaServicio field.';
                }
                field(horaGeneracion; Rec.horaGeneracion)
                {
                    ToolTip = 'Specifies the value of the horaGeneracion field.';
                }
                field(idiomaDocumentacion; Rec.idiomaDocumentacion)
                {
                    ToolTip = 'Specifies the value of the idiomaDocumentacion field.';
                }
                field(indicadorPersonalizado; Rec.indicadorPersonalizado)
                {
                    ToolTip = 'Specifies the value of the indicadorPersonalizado field.';
                }
                field(lineaEntregaERP; Rec.lineaEntregaERP)
                {
                    ToolTip = 'Specifies the value of the lineaEntregaERP field.';
                }
                field(nombreCliente; Rec.nombreCliente)
                {
                    ToolTip = 'Specifies the value of the nombreCliente field.';
                }
                field(nombreReceptor; Rec.nombreReceptor)
                {
                    ToolTip = 'Specifies the value of the nombreReceptor field.';
                }
                field(observaciones; Rec.observaciones)
                {
                    ToolTip = 'Specifies the value of the observaciones field.';
                }
                field(paisCliente; Rec.paisCliente)
                {
                    ToolTip = 'Specifies the value of the paisCliente field.';
                }
                field(paisReceptor; Rec.paisReceptor)
                {
                    ToolTip = 'Specifies the value of the paisReceptor field.';
                }
                field(prepararMonoArticulo; Rec.prepararMonoArticulo)
                {
                    ToolTip = 'Specifies the value of the prepararMonoArticulo field.';
                }
                field(prioridad; Rec.prioridad)
                {
                    ToolTip = 'Specifies the value of the prioridad field.';
                }
                field(provinciaCliente; Rec.provinciaCliente)
                {
                    ToolTip = 'Specifies the value of the provinciaCliente field.';
                }
                field(provinciaReceptor; Rec.provinciaReceptor)
                {
                    ToolTip = 'Specifies the value of the provinciaReceptor field.';
                }
                field(requiereManipulacion; Rec.requiereManipulacion)
                {
                    ToolTip = 'Specifies the value of the requiereManipulacion field.';
                }
                field(telefonoReceptor; Rec.telefonoReceptor)
                {
                    ToolTip = 'Specifies the value of the telefonoReceptor field.';
                }
                field(tipoCentroDestino; Rec.tipoCentroDestino)
                {
                    ToolTip = 'Specifies the value of the tipoCentroDestino field.';
                }
                field(tipoContenedor; Rec.tipoContenedor)
                {
                    ToolTip = 'Specifies the value of the tipoContenedor field.';
                }
                field(tipoEntrega; Rec.tipoEntrega)
                {
                    ToolTip = 'Specifies the value of the tipoEntrega field.';
                }
                field(tipoOperacion; Rec.tipoOperacion)
                {
                    ToolTip = 'Specifies the value of the tipoOperacion field.';
                }
                field(verificacionEnExpedicion; Rec.verificacionEnExpedicion)
                {
                    ToolTip = 'Specifies the value of the verificacionEnExpedicion field.';
                }
            }
        }
    }
}
