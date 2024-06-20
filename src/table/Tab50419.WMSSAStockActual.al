table 50419 "WMS SA-Stock Actual"
{
    // EX-SGG-WMS 130619 NUEVA ENTIDAD PARA RECOGER LOS MENSAJES SA - STOCK ACTUAL
    //            030719 NUEVO CAMPO Integrado. AGREGO A KEY.  NUEVO CAMPO numeroMensaje
    //            040719 NUEVA KEY numeroMensaje
    //            160719 CAMPO numeroMensaje DE Interger A Code(25)
    //            120919 CAMBIO CLAVE PPTAL DE identificadorStock A numeroMensaje,identificadorStock.

    fields
    {
        field(1; identificadorStock; Integer)
        {
        }
        field(2; fecha; Date)
        {
        }
        field(3; hora; Time)
        {
        }
        field(4; codigoArticuloERP; Text[20])
        {
        }
        field(5; cantidad; Integer)
        {
        }
        field(6; estadoCalidad; Integer)
        {
        }
        field(7; claseStock; Integer)
        {
        }
        field(8; Obtenido; Boolean)
        {
        }
        field(9; Integrado; Boolean)
        {
            Description = 'EX-SGG-WMS 030719';
        }
        field(10; numeroMensaje; Code[25])
        {
            Description = 'EX-SGG-WMS 030719,EX-SGG-WMS 160719 Interger->Code(25)';
        }
    }

    keys
    {
        key(Key1; numeroMensaje, identificadorStock)
        {
            Clustered = true;
        }
        key(Key2; Obtenido, Integrado, fecha, codigoArticuloERP)
        {
        }
    }

    fieldgroups
    {
    }
}
