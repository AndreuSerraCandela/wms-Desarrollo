table 50414 "Control integracion WMS"
{
    // EX-SGG-WMS 120619 NUEVA ENTIDAD PARA LA GESTIÓN DE INTEGRACIONES CON SEGA WMS. CUADRO DE CONTROL.
    //            210619 NUEVOS CAMPOS Fecha y hora ult. resp. SEGA,Fecha y hora enviado WS, Estado SEGA
    //            030719 VALIDAR ESTADO REGISTRO. NUEVO CAMPO Numero de mensaje SEGA.
    //            160719 CAMPO Numero de mensaje SEGA DE Interger A Code(25)
    //            170719 ACTUALIZACION ESTADO SEGUN ESTADO SEGA=IMPORTADO.
    //            040220 NUEVO ESTADO Descartado

    //   DrillDownFormID = Form50419;
    //   LookupFormID = Form50419;

    fields
    {
        field(1; "No. registro"; Integer)
        {
        }
        field(2; Interface; Option)
        {
            OptionCaption = 'OE-Orden de Entrada,PE-Pedido,CE-Confirmación de Entrada,CS-Confirmación de Salida,AS-Ajuste de Stock,SA-Stock Actual,CP-Confirmacion de Preparacion';
            OptionMembers = "OE-Orden de Entrada","PE-Pedido","CE-Confirmacion de Entrada","CS-Confirmacion de Salida","AS-Ajuste de Stock","SA-Stock Actual","CP-Confirmacion de Preparacion";
        }
        field(3; "Tipo documento"; Option)
        {
            OptionCaption = 'Envío almacen,Recepción almacen,Stock';
            OptionMembers = "Envio almacen","Recepcion almacen",Stock;
        }
        field(4; "No. documento"; Code[20])
        {
        }
        field(5; Estado; Option)
        {
            OptionCaption = 'Pendiente,Preparado,Enviado WS,Integrado,Error,Descartado';
            OptionMembers = Pendiente,Preparado,"Enviado WS",Integrado,Error,Descartado;

            trigger OnValidate()
            begin
                CduWMS.ValidarEstadoRegistroControl(Rec); //EX-SGG-WMS 030719
            end;
        }
        field(6; "Fecha y hora obtenido"; DateTime)
        {
        }
        field(7; "Fecha y hora procesado"; DateTime)
        {
        }
        field(8; "Id. SEGA"; Integer)
        {
            Description = 'EX-SGG-WMS identificador único SEGA de los distintos mensajes recibidos';
        }
        field(9; "Fecha y hora ult. resp. SEGA"; DateTime)
        {
            Description = 'EX-SGG-WMS 210619';
        }
        field(10; "Fecha y hora enviado WS"; DateTime)
        {
            Description = 'EX-SGG-WMS 210619';
        }
        field(11; "Estado SEGA"; Option)
        {
            Description = 'EX-SGG-WMS 210619';
            OptionMembers = " ","Numero mensaje desconocido","En proceso",Error,Importado;

            trigger OnValidate()
            begin
                //EX-SGG-WMS 210619
                IF "Estado SEGA" IN ["Estado SEGA"::"Numero mensaje desconocido", "Estado SEGA"::Error] THEN
                    VALIDATE(Estado, Estado::Error);

                IF "Estado SEGA" = "Estado SEGA"::Importado THEN //EX-SGG-WMS 170719
                    VALIDATE(Estado, Estado::Integrado);
            end;
        }
        field(12; "Numero de mensaje SEGA"; Code[25])
        {
            Description = 'EX-SGG-WMS 030719,EX-SGG-WMS 160719 Interger->Code(25)';
        }
    }

    keys
    {
        key(Key1; "No. registro")
        {
            Clustered = true;
        }
        key(Key2; Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA", "Numero de mensaje SEGA")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CduWMS.EliminarRegistroControl(Rec);
    end;

    var
        CduWMS: Codeunit 50200;
}
