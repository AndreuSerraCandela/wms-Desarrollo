table 50462 "Parametro Proposicion Envios"
{
    DataClassification = ToBeClassified;
    DrillDownPageId = "Ejecutar NAS Prop.Envios";
    LookupPageId = "Ejecutar NAS Prop.Envios";

    fields
    {
        field(1; Parametro; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Parametro', comment = 'ESP="Parametro"';
        }
        field(2; Temporada; Text[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Temporada', comment = 'ESP="Temporada"';
        }
        field(3; "Filter Date Serv. OK"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Filter Date Serv. OK', comment = 'ESP="Filtro Fecha Serv. confirmada"';
        }
        field(4; "Filter Order"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Filter Order', comment = 'ESP="Filtro Pedido"';
        }
        field(5; "Filter Customer"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Filter Customer', comment = 'ESP="Filtro Cliente"';
        }
        field(6; "Filter Item"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Filter Item', comment = 'ESP="Filtro Producto"';
        }
        field(7; "Filter Color"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'EnglishText', comment = 'ESP="YourLanguageText"';
        }
        field(8; "Type Services"; Enum "Tipo Servicio")
        {
            DataClassification = ToBeClassified;
            Caption = 'Type Services', comment = 'ESP="Tipo Servicio"';
        }
        field(9; "Type Order"; Enum "Tipo Anulación")
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Minimal customer risk"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Minimal customer risk', comment = 'ESP="Riesgo Minimo Cliente"';
        }
    }

    keys
    {
        key(Key1; Parametro)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var


    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}