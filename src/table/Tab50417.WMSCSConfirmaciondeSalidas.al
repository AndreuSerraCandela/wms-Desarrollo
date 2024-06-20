table 50417 "WMS CS-Confirmacion de Salidas"
{
    // EX-SGG-WMS 130619 NUEVA ENTIDAD PARA RECOGER LOS MENSAJES CS - CONFIRMACION DE SALIDAS
    //            030719 NUEVO CAMPO Integrado.AGREGO A KEY. NUEVO CAMPO numeroMensaje
    //            160719 CAMPO numeroMensaje DE Interger A Code(25)
    //            300719 AGREGO CAMPO numeroBulto
    //            120919 NUEVO CAMPO No. registro. ESTABLEZCO COMO CLAVE PRINCIPAL TRAS NUMERARLO. NUMERO EN INSERCIÓN.

    fields
    {
        field(1; identificadorExpedicion; Integer)
        {
        }
        field(2; matriculaVehiculo; Text[10])
        {
        }
        field(3; tipoCentroTransportista; Text[15])
        {
        }
        field(4; codigoCentroTransportista; Text[15])
        {
        }
        field(5; fecha; Date)
        {
        }
        field(6; hora; Time)
        {
        }
        field(7; codigoEntregaERP; Text[18])
        {
        }
        field(8; tipoCentroDestino; Text[15])
        {
        }
        field(9; codigoCentroDestino; Text[15])
        {
        }
        field(10; finCodigoEntregaERP; Boolean)
        {
        }
        field(11; tipoContenedor; Text[20])
        {
        }
        field(12; codigoContenedor; Text[20])
        {
        }
        field(13; tipoContenedor2; Text[20])
        {
        }
        field(14; codigoContenedor2; Text[20])
        {
        }
        field(15; lineaEntregaERP; Text[25])
        {
        }
        field(16; codigoArticuloERP; Text[20])
        {
        }
        field(17; cantidad; Integer)
        {
        }
        field(18; claseStock; Integer)
        {
        }
        field(19; Obtenido; Boolean)
        {
        }
        field(20; Integrado; Boolean)
        {
            Description = 'EX-SGG-WMS 030719';
        }
        field(21; numeroMensaje; Code[25])
        {
            Description = 'EX-SGG-WMS 030719,EX-SGG-WMS 160719 Interger->Code(25)';
        }
        field(22; numeroBulto; Integer)
        {
        }
        field(23; "No. registro"; Integer)
        {
            Description = 'EX-SGG-WMS 120919 NUEVA CLAVE PPAL';
        }
    }

    keys
    {
        key(Key1; "No. registro")
        {
        }
        key(Key2; identificadorExpedicion, codigoEntregaERP, lineaEntregaERP)
        {
            Clustered = true;
        }
        key(Key3; Obtenido, Integrado, fecha, codigoArticuloERP)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //EX-SGG 120919
        IF "No. registro" = 0 THEN BEGIN
            IF (RstCS.FINDLAST()) AND (RstCS."No. registro" <> 0) THEN
                "No. registro" := RstCS."No. registro" + 1
            ELSE
                "No. registro" := 1;
        END;
    end;

    var
        RstCS: Record "WMS CS-Confirmacion de Salidas";// 50417;
}
