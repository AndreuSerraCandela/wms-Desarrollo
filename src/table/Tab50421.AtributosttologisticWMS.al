table 50421 "Atributos tto. logistic. WMS"
{
    // EX-SGG-WMS 170719 CREACION CAMPOS CALCULADOS PARA OBTENER VALORES NUEVOS CAMPOS CONFIG PARAM SEGA
    //            230719 NUEVO CAMPO Descripcion atributo

    // LookupFormID = Form50432;
    LookupPageId = "Atributos tto. logistic. WMS";
    DrillDownPageId = "Atributos tto. logistic. WMS";
    Caption = 'Atributos ttos. logistic WMS';

    fields
    {
        field(1; "Tipo documento"; Option)
        {
            OptionCaption = 'Cliente,Pedido,Envío';
            OptionMembers = Cliente,Pedido,Envio;
        }
        field(2; Codigo; Code[20])
        {
            Caption = 'Código';
            TableRelation = IF ("Tipo documento" = CONST(Cliente)) Customer."No."
            ELSE IF ("Tipo documento" = CONST(Pedido)) "Sales Header"."No." WHERE("Document Type" = CONST(Order))
            ELSE IF ("Tipo documento" = CONST(Envio)) "Warehouse Shipment Header"."No.";
        }
        field(3; "Codigo atributo"; Code[10])
        {
            Caption = 'Código atributo';
            TableRelation = "Configuracion Parametros SEGA".Codigo WHERE(Tipo = CONST(Atributo));
        }
        field(4; "Requiere manipulacion"; Boolean)
        {
            CalcFormula = Lookup("Configuracion Parametros SEGA"."Requiere manipulacion" WHERE(Tipo = CONST(Atributo),
                                                                                                Codigo = FIELD("Codigo atributo")));
            Caption = 'Requiere manipulación';
            Description = 'EX-SGG-WMS 170719';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Verificar expedicion"; Boolean)
        {
            CalcFormula = Lookup("Configuracion Parametros SEGA"."Verificar expedicion" WHERE(Tipo = CONST(Atributo),
                                                                                               Codigo = FIELD("Codigo atributo")));
            Caption = 'Verificar expedición';
            Description = 'EX-SGG-WMS 170719';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Indicador personalizado"; Boolean)
        {
            CalcFormula = Lookup("Configuracion Parametros SEGA"."Indicador personalizado" WHERE(Tipo = CONST(Atributo),
                                                                                                  Codigo = FIELD("Codigo atributo")));
            Description = 'EX-SGG-WMS 170719';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Preparacion mono referencia"; Boolean)
        {
            CalcFormula = Lookup("Configuracion Parametros SEGA"."Preparacion mono referencia" WHERE(Tipo = CONST(Atributo),
                                                                                                      Codigo = FIELD("Codigo atributo")));
            Caption = 'Preparación mono artículo';
            Description = 'EX-SGG-WMS 170719';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Caja anonima"; Integer)
        {
            CalcFormula = Lookup("Configuracion Parametros SEGA"."Caja anonima" WHERE(Tipo = CONST(Atributo),
                                                                                       Codigo = FIELD("Codigo atributo")));
            Caption = 'Caja anónima';
            Description = 'EX-SGG-WMS 170719';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Descripcion atributo"; Text[50])
        {
            CalcFormula = Lookup("Configuracion Parametros SEGA".Descripcion WHERE(Tipo = CONST(Atributo),
                                                                                    Codigo = FIELD("Codigo atributo")));
            Caption = 'Descripción atributo';
            Description = 'EX-SGG-WNS 230719';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Tipo documento", Codigo, "Codigo atributo")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

