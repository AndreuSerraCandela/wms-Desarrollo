/// <summary>
/// TableExtension WarehouseShipmentHeader (ID 50202) extends Record Warehouse Shipment Header //7320.
/// </summary>
tableextension 50202 WarehouseShipmentHeader extends "Warehouse Shipment Header" //7320
{
    fields
    {
        field(50399; "Document Status 2"; Enum DocumentStatusWareShp)
        {
            DataClassification = ToBeClassified;
            Caption = 'Document Status 2', comment = 'ESP="Estado Documento 2"';
        }
        field(50400; "Cod Cliente"; Code[20])
        {
            Description = 'EX-OMI-WMS';
            DataClassification = ToBeClassified;
            Caption = 'Customer Code', comment = 'ESP="Cód Cliente"';
        }
        field(50401; Obtenido; Boolean)
        {
            Description = 'EX-SGG-WMS 120619';
            DataClassification = ToBeClassified;
            Caption = 'Obtein', comment = 'ESP="Obtenido"';
        }
        field(50402; "Tipo origen"; Enum TipoOrigen)
        {
            Description = 'EX-SGG-WMS 170619';
            DataClassification = ToBeClassified;
            Caption = 'Tipo Origen', comment = 'ESP="Tipo origen"';
        }
        field(50403; "Cod. origen"; Code[20])
        {
            Description = 'EX-SGG-WMS 170619';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Tipo origen" = CONST(Cliente)) Customer."No."
            ELSE
            IF ("Tipo origen" = CONST(Proveedor)) Vendor."No.";
            Caption = 'Origin Code', comment = 'ESP="Cód. origen"';
        }
        field(50404; "Fecha servicio solicitada"; Date)
        {
            Description = 'EX-SGG-WMS 190619';
            DataClassification = ToBeClassified;
            Caption = 'Solicited Service Date', comment = 'ESP="Fecha servicio solicitada"';
        }
        field(50405; "Ship-to Name"; Text[50])
        {
            Caption = 'Ship-to Name', comment = 'ESP="Envío a-Nombre"';
            Description = 'EX-SGG-WMS 190619';
            DataClassification = ToBeClassified;
        }
        field(50406; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2', comment = 'ESP="Envío a-Nombre 2"';
            Description = 'EX-SGG-WMS 190619';
            DataClassification = ToBeClassified;
        }
        field(50407; "Ship-to Address"; Text[50])
        {
            Caption = 'Ship-to Address', comment = 'ESP="Envío a-Dirección"';
            DataClassification = ToBeClassified;
            Description = 'EX-SGG-WMS 190619';
        }
        field(50408; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2', comment = 'ESP="Envío a-Dirección 2"';
            Description = 'EX-SGG-WMS 190619';
            DataClassification = ToBeClassified;
        }
        field(50409; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City', comment = 'ESP="Envío a-Población"';
            DataClassification = ToBeClassified;
            Description = 'EX-SGG-WMS 190619';
        }
        field(50410; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code', comment = 'ESP="Envío a-C.P."';
            DataClassification = ToBeClassified;
            Description = 'EX-SGG-WMS 190619';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(50411; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County', comment = 'ESP="Envío a-Provincia"';
            Description = 'EX-SGG-WMS 190619';
            DataClassification = ToBeClassified;
        }
        field(50412; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code', comment = 'ESP="Envío a-Cód.país/región."';
            Description = 'EX-SGG-WMS 190619';
            TableRelation = "Country/Region";
            DataClassification = ToBeClassified;
        }
        field(50413; "Tipo de entrega"; Code[5])
        {
            Description = 'EX-SGG-WMS 200619';
            DataClassification = ToBeClassified;
            TableRelation = "Configuracion Parametros SEGA".Codigo WHERE(Tipo = CONST(Entrega));
            Caption = 'Delivery type', comment = 'ESP="Tipo de entrega"';
        }
        field(50414; "Sell-to Customer Name"; Text[50])
        {
            Caption = 'Sell-to Customer Name', comment = 'ESP="Venta a-Nombre"';
            DataClassification = ToBeClassified;
            Description = 'EX-SGG-WMS 170719';
        }
        field(50415; "Sell-to Customer Name 2"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sell-to Customer Name 2', comment = 'ESP="Venta a-Nombre 2"';
            Description = 'EX-SGG-WMS 170719';
        }
        field(50416; "Sell-to Address"; Text[50])
        {
            Caption = 'Sell-to Address', comment = 'ESP="Venta a-Dirección"';
            DataClassification = ToBeClassified;
            Description = 'EX-SGG-WMS 170719';
        }
        field(50417; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2', comment = 'ESP="Venta a-Dirección 2"';
            DataClassification = ToBeClassified;
            Description = 'EX-SGG-WMS 170719';
        }
        field(50418; "Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City', comment = 'ESP="Venta a-Población"';
            DataClassification = ToBeClassified;
            Description = 'EX-SGG-WMS 170719';
        }
        field(50419; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code', comment = 'ESP="Venta a-C.P."';
            DataClassification = ToBeClassified;
            Description = 'EX-SGG-WMS 170719';
            TableRelation = "Post Code";
            ValidateTableRelation = false;
        }
        field(50420; "Sell-to County"; Text[30])
        {
            Caption = 'Sell-to County', comment = 'ESP="Venta a-Provincia"';
            DataClassification = ToBeClassified;
            Description = 'EX-SGG-WMS 170719';
        }
        field(50421; "Sell-to Country/Region Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sell-to County', comment = 'ESP="Venta a-Provincia"';
            Description = 'EX-SGG-WMS 170719';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                VALIDATE("Ship-to Country/Region Code");
            end;
        }
        field(50422; "Pares Enviar"; Decimal)
        {
            CalcFormula = Sum("Warehouse Shipment Line".Quantity WHERE("No." = FIELD("No.")));
            Description = 'EX-JFC-WMS 100919';
            FieldClass = FlowField;
            Caption = 'Pairs Send', comment = 'ESP="Pares Enviar"';
        }
        field(50423; "Nombre Tipo de entrega"; Text[50])
        {
            CalcFormula = Lookup("Configuracion Parametros SEGA".Descripcion WHERE("Tipo" = FILTER(Entrega),
                                                                                    Codigo = FIELD("Tipo de entrega")));
            Description = 'EX-JFC-WMS 100919';
            FieldClass = FlowField;
            Caption = 'Name Type of delivery', comment = 'ESP="Nombre Tipo de entrega"';
        }
        field(50424; "Envio a Mail"; Text[30])
        {

        }
        field(50430; "Omitir SEGA"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    /// <summary>
    /// CompruebaEnviadoASEGA.
    /// </summary>
    procedure CompruebaEnviadoASEGA()
    begin
        //EX-SGG-WMS 260619
        IF ("Document Status 2" = "Document Status 2"::"Enviado SEGA") THEN
            ERROR('No se puede modificar un envío si ' + FIELDCAPTION("Document Status 2") + ' es ' + FORMAT("Document Status 2"));
    end;
}
