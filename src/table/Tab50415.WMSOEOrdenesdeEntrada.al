table 50415 "WMS OE-Ordenes de Entrada"
{
    // EX-SGG-WMS 120619 NUEVA ENTIDAD PARA RECOGER LOS MENSAJES OE - ORDENES DE ENTRADA
    //            030719 NUEVO CAMPO Integrado.AGREGO A KEY.

    // DrillDownFormID = Form50420;
    // LookupFormID = Form50420;

    fields
    {
        field(1; "No. registro"; Integer)
        {
        }
        field(2; tipoOperacion; Integer)
        {
        }
        field(3; codigoOrdenEntrada; Text[18])
        {
        }
        field(4; tipoOrdenEntrada; Integer)
        {
        }
        field(5; tipoCentroOrigen; Text[15])
        {
        }
        field(6; codigoCentroOrigen; Text[15])
        {
        }
        field(7; fechaEntrega; Date)
        {
        }
        field(8; fechaVencimiento; Date)
        {
        }
        field(9; comentario; Text[30])
        {
        }
        field(10; lineaOrdenEntrada; Text[25])
        {
        }
        field(11; codigoArticuloERP; Text[20])
        {
        }
        field(12; cantidad; Integer)
        {
        }
        field(13; tolerancia; Integer)
        {
        }
        field(14; codigoOrdenCompraERP; Text[18])
        {
        }
        field(15; codigoDocumentoEntrada; Text[18])
        {
        }
        field(16; estadoCalidad; Integer)
        {
        }
        field(17; motivoDevolucion; Text[64])
        {
        }
        field(18; codigoEntregaERP; Text[18])
        {
        }
        field(19; lineaEntregaERP; Text[25])
        {
        }
        field(20; cantidadLineaEntregaERP; Integer)
        {
        }
        field(21; Integrado; Boolean)
        {
            Description = 'EX-SGG-WMS 030719';
        }
    }

    keys
    {
        key(Key1; "No. registro")
        {
            Clustered = true;
        }
        key(Key2; codigoOrdenEntrada, Integrado, fechaEntrega, codigoArticuloERP)
        {
        }
    }

    fieldgroups
    {
    }
}
