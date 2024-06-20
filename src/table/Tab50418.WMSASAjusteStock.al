table 50418 "WMS AS-Ajuste Stock"
{
    LookupPageId = "WMS AS-Ajuste Stock";

    // EX-SGG-WMS 130619 NUEVA ENTIDAD PARA RECOGER LOS MENSAJES AS - AJUSTES DE STOCK
    //            030719 NUEVO CAMPO Integrado.AGREGO A KEY. NUEVO CAMPO numeroMensaje
    //            040719 NUEVA KEY numeroMensaje,motivoAjuste
    //            160719 CAMPO numeroMensaje DE Interger A Code(25)

    fields
    {
        field(1; identificadorAjuste; Integer)
        {
        }
        field(2; fecha; Date)
        {
        }
        field(3; hora; Time)
        {
        }
        field(4; tipoAjuste; Integer)
        {
        }
        field(5; motivoAjuste; Integer)
        {
        }
        field(6; codigoArticuloERP; Text[20])
        {
        }
        field(7; cantidad; Integer)
        {
        }
        field(8; estadoCalidad; Integer)
        {
        }
        field(9; claseStock; Integer)
        {
        }
        field(10; codigoOrdenEntrada; Text[18])
        {
        }
        field(11; observaciones; Text[250])
        {
        }
        field(12; Obtenido; Boolean)
        {
        }
        field(13; Integrado; Boolean)
        {
            Description = 'EX-SGG-WMS 030719';
        }
        field(14; numeroMensaje; Code[25])
        {
            Description = 'EX-SGG-WMS 030719,EX-SGG-WMS 160719 Interger->Code(25)';
        }

    }

    keys
    {
        key(Key1; identificadorAjuste)
        {
            Clustered = true;
        }
        key(Key2; Obtenido, Integrado, fecha, codigoArticuloERP)
        {
        }
        key(Key3; numeroMensaje, motivoAjuste)
        {
        }
    }

    fieldgroups
    {
    }
}
