table 50416 "WMS PE-Pedidos"
{
    // EX-SGG-WMS 130619 NUEVA ENTIDAD PARA RECOGER LOS MENSAJES PE - PEDIDOS
    //            030719 NUEVO CAMPO Integrado
    //            170719 NUEVO CAMPO departamentoCliente PARA ECI.
    //            300719 NUEVOS CAMPOS direccionCliente2, direccionReceptor2
    //            071019 NUEVO CAMPO telefonoReceptor
    //            050220 NUEVO CAMPO idiomaDocumentacion

    fields
    {
        field(1; "No. registro"; Integer)
        {
        }
        field(2; tipoOperacion; Integer)
        {
        }
        field(3; codigoEntregaERP; Text[18])
        {
        }
        field(4; tipoEntrega; Integer)
        {
        }
        field(5; CodigoPedidoERP; Text[30])
        {
        }
        field(6; codigoPedidoCliente; Text[18])
        {
        }
        field(7; tipoCentroDestino; Text[15])
        {
        }
        field(8; codigoCentroDestino; Text[15])
        {
        }
        field(9; prioridad; Integer)
        {
        }
        field(10; fechaGeneracion; Date)
        {
        }
        field(11; horaGeneracion; Time)
        {
        }
        field(12; fechaServicio; Date)
        {
        }
        field(13; codigoTipoRuta; Text[10])
        {
        }
        field(14; observaciones; Text[64])
        {
        }
        field(15; requiereManipulacion; Boolean)
        {
        }
        field(16; verificacionEnExpedicion; Boolean)
        {
        }
        field(17; codigoCliente; Text[15])
        {
        }
        field(18; nombreCliente; Text[50])
        {
        }
        field(19; direccionCliente; Text[50])
        {
        }
        field(20; ciudadCliente; Text[50])
        {
        }
        field(21; provinciaCliente; Text[20])
        {
        }
        field(22; codigoPostalCliente; Text[15])
        {
        }
        field(23; paisCliente; Text[20])
        {
        }
        field(24; nombreReceptor; Text[50])
        {
        }
        field(25; direccionReceptor; Text[50])
        {
        }
        field(26; ciudadReceptor; Text[50])
        {
        }
        field(27; provinciaReceptor; Text[20])
        {
        }
        field(28; codigoPostalReceptor; Text[15])
        {
        }
        field(29; paisReceptor; Text[20])
        {
        }
        field(30; tipoContenedor; Text[20])
        {
        }
        field(31; lineaEntregaERP; Text[25])
        {
        }
        field(32; codigoArticuloERP; Text[20])
        {
        }
        field(33; cantidad; Integer)
        {
        }
        field(34; claseStock; Integer)
        {
        }
        field(35; indicadorPersonalizado; Boolean)
        {
        }
        field(36; prepararMonoArticulo; Boolean)
        {
        }
        field(37; Integrado; Boolean)
        {
            Description = 'EX-SGG-WMS 030719';
        }
        field(38; departamentoCliente; Code[20])
        {
            Description = 'EX-SGG-WMS 170719';
        }
        field(39; direccionCliente2; Text[50])
        {
            Description = 'EX-SGG-WMS 300719';
        }
        field(40; direccionReceptor2; Text[50])
        {
            Description = 'EX-SGG-WMS 300719';
        }
        field(41; telefonoReceptor; Text[30])
        {
            Description = 'EX-SGG-WMS 071019';
        }
        field(42; idiomaDocumentacion; Code[2])
        {
            Description = 'EX-SGG-WMS 050220';
        }
    }

    keys
    {
        key(Key1; "No. registro")
        {
            Clustered = true;
        }
        key(Key2; codigoEntregaERP, Integrado, fechaGeneracion, codigoArticuloERP)
        {
        }
    }

    fieldgroups
    {
    }
}
