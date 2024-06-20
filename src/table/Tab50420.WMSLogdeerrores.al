table 50420 "WMS Log de errores"
{
    // EX-SGG-WMS 210619 NUEVO CAMPÒ Respuesta SEGA

    // DrillDownFormID = Form50425;
    // LookupFormID = Form50425;

    fields
    {
        field(1; "No. registro"; Integer)
        {
        }
        field(2; Interface; Option)
        {
            OptionCaption = 'OE-Orden de Entrada,PE-Pedido,CE-Confirmación de Entrada,CS-Confirmación de Salida,AS-Ajuste de Stock,SA-Stock Actual';
            OptionMembers = "OE-Orden de Entrada","PE-Pedido","CE-Confirmacion de Entrada","CS-Confirmacion de Salida","AS-Ajuste de Stock","SA-Stock Actual";
        }
        field(3; "Tipo documento"; Option)
        {
            OptionCaption = 'Envío almacen,Recepción almacen,Stock';
            OptionMembers = "Envio almacen","Recepcion almacen",Stock;
        }
        field(4; "No. documento"; Code[20])
        {
        }
        field(5; "Id. WMS"; Integer)
        {
        }
        field(6; "Fecha y hora"; DateTime)
        {
        }
        field(7; Descripcion; Text[250])
        {
            Caption = 'Descripción';
        }
        field(8; "No. registro control rel."; Integer)
        {
            TableRelation = "Control integracion WMS"."No. registro";
        }
        field(9; "Respuesta SEGA"; Boolean)
        {
            Description = 'EX-SGG-WMS 210619';
        }
    }

    keys
    {
        key(Key1; "No. registro")
        {
            Clustered = true;
        }
        key(Key2; "No. registro control rel.")
        {
        }
        key(Key3; Interface, "Tipo documento", "No. documento")
        {
        }
    }

    fieldgroups
    {
    }
}
