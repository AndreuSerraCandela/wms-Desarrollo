table 50409 "WMS CE-Confirmación de Entrada"
{
    // EX-SGG-WMS 120619 NUEVO CAMPO Obtenido. NUEVA CLAVE POR ESTE CAMPO.
    //            030719 NUEVO CAMPO Integrado.AGREGO A KEY. NUEVO CAMPO numeroMensaje
    //            160719 CAMPO numeroMensaje DE Interger A Code(25)
    //            280819 NUEVO CAMPO No. registro. ESTABLEZCO COMO CLAVE PRINCIPAL TRAS NUMERARLO. NUMERO EN INSERCIÓN.

    fields
    {
        field(1; correlativoRecepcion; Integer)
        {
        }
        field(2; fecha; Date)
        {
        }
        field(3; hora; Time)
        {
        }
        field(4; matriculaVehiculo; Text[15])
        {
        }
        field(5; tipoCentroTransportista; Text[15])
        {
        }
        field(6; codigoCentroTransportista; Integer)
        {
        }
        field(7; lineaOrdenEntrada; Text[25])
        {
        }
        field(8; codigoArticuloERP; Code[20])
        {
        }
        field(9; Cantidad; Integer)
        {
        }
        field(10; estadoCalidad; Integer)
        {
        }
        field(11; tipoCentroOrigen; Text[15])
        {
        }
        field(12; codigoCentroOrigen; Text[15])
        {
        }
        field(13; codigoOrdenEntrada; Text[18])
        {
        }
        field(14; finCodigoOrdenEntrada; Boolean)
        {
        }
        field(15; codigoOrdenCompraERP; Text[18])
        {
        }
        field(16; tipoDocumentoRecibido; Integer)
        {
        }
        field(17; codigoDocumentoRecibido; Text[18])
        {
        }
        field(19; Obtenido; Boolean)
        {
            Description = 'EX-SGG-WMS 120619';
        }
        field(20; Integrado; Boolean)
        {
            Description = 'EX-SGG-WMS 030719';
        }
        field(21; numeroMensaje; Code[25])
        {
            Description = 'EX-SGG-WMS 030719,EX-SGG-WMS 160719 Interger->Code(25)';
        }
        field(22; "No. registro"; Integer)
        {
            Description = 'EX-SGG-WMS 280819 NUEVA CLAVE PPAL.';
        }
    }

    keys
    {
        key(Key1; "No. registro")
        {
        }
        key(Key2; correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada)
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
        //EX-SGG 280819
        IF "No. registro" = 0 THEN BEGIN
            IF (RstCE.FINDLAST()) AND (RstCE."No. registro" <> 0) THEN
                "No. registro" := RstCE."No. registro" + 1
            ELSE
                "No. registro" := 1;
        END;
    end;

    var
        RstCE: Record "WMS CE-Confirmación de Entrada"; // 50409;
}
