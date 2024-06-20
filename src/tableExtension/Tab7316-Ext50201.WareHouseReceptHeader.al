/// <summary>
/// TableExtension WareHouseReceptHeader (ID 50201) extends Record Warehouse Receipt Header //7316.
/// Warehouse Receipt Header WMS 50400
/// </summary>
tableextension 50201 WareHouseReceptHeader extends "Warehouse Receipt Header" //7316
{
    //migramos de la tabla 50001 al "Warehouse Receipt Header", xq anteriormente no tenian licencia
    fields
    {
        field(50400; TraerDocOrigen; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Bring Doc. Origin', comment = 'ESP="Traer Doc. Origen"';
        }
        field(50401; Obtenido; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Obtein', comment = 'ESP="Obtenido"';
        }
        field(50402; "Tipo Origen"; Enum TipoOrigen)
        {
            DataClassification = ToBeClassified;
            Caption = 'Origin Type', comment = 'ESP="Tipo Origen"';
        }
        field(50403; "Cod. origen"; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Origin Code', comment = 'ESP="Cód. Origen"';
        }
        field(50404; Status; Option)
        {
            Caption = 'Status', comment = 'ESP="Estado"';
            Editable = false;
            OptionCaptionML = ENU = 'Open,Released', ESP = 'Abierto,Lanzado';
            OptionMembers = Open,Released;
            trigger OnValidate()
            var
                LabelName: Label 'It is not possible to launch warehouse receipt ', comment = 'ESP="No es posible lanzar la recepción de almacén "';
                LabelName1: Label '. There are no associated lines.', comment = 'ESP=". No existen líneas asociadas."';
            begin

                //EX-SGG-WMS 180619
                IF Rec.Status = Status::Released THEN BEGIN
                    CALCFIELDS("Lineas asociadas");
                    IF NOT "Lineas asociadas" THEN
                        ERROR(LabelName + "No." + LabelName1);
                    CompruebaLineasAsignacionDirec(); //EX-SGG-WMS 120719
                END;
            end;
        }
        field(50405; "Lineas asociadas"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Asociated Lines', comment = 'ESP="Líneas asociadas"';
        }
        field(50406; "Tipo de Orden de Entrada"; Code[5])
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry Order Type', comment = 'ESP="Tipo de Orden de Entrada"';
            TableRelation = "Configuracion Parametros SEGA".Codigo WHERE(Tipo = CONST("Orden entrada"));
        }
        field(50407; "Pares Recibir"; Decimal)
        {
            //DataClassification = ToBeClassified;
            Caption = 'Pairs Receive', comment = 'ESP="Pares Recibir"';
            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Receipt Line".Quantity WHERE("No." = FIELD("No.")));
        }
        field(50408; "Nombre Tipo de orden Entrada"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Name Order Type Entry', comment = 'ESP="Nombre Tipo de orden Entrada"';
        }
        field(50430; "Omitir SEGA"; Boolean)
        {
            DataClassification = ToBeClassified;
        }

    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    /// <summary>
    /// CompruebaLineasAsignacionDirec.
    /// </summary>
    procedure CompruebaLineasAsignacionDirec()
    var
        //lRstLinRecep: Record "Warehouse Receipt Line WMS";
        lRstLinRecep: Record "Warehouse Receipt Line";
        //     lRstLinEnv: Record "Warehouse Shipment Line WMS";
        lRstLinEnv: Record "Warehouse Shipment Line";
        //lRstLinEnvReg: Record "Posted Whse. Shipment Line WMS";
        lRstLinEnvReg: Record "Posted Whse. Shipment Line";
        lCantLinsVenta: Decimal;
        lCantLinsEnv: Decimal;
        lExacto: Boolean;
    begin

        //EX-SGG-WMS 120719
        lRstLinEnv.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Source Line No.");
        lRstLinEnvReg.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Source Line No.");
        lRstLinRecep.SETRANGE("No.", "No.");
        lRstLinRecep.SETRANGE("Source Type", DATABASE::"Purchase Line");
        lRstLinRecep.SETRANGE("Source Document", lRstLinRecep."Source Document"::"Purchase Order");
        IF lRstLinRecep.FINDSET() THEN
            REPEAT
                CLEAR(lCantLinsVenta);
                CLEAR(lCantLinsEnv);
                CLEAR(lExacto);
            /* begin vlrangel pdte    //  lRstAsigDir: Record "Asignaciones Vtas-Compras";
            lRstLinCompra.GET(lRstLinCompra."Document Type"::Order, lRstLinRecep."Source No.", lRstLinRecep."Source Line No.");
            lRstAsigDir.SETRANGE("Nº Pedido Compra", lRstLinRecep."Source No.");
            lRstAsigDir.SETRANGE("Nº Linea Pedido Compra", lRstLinRecep."Source Line No.");
            lRstAsigDir.SETRANGE("Tipo Asignación", lRstAsigDir."Tipo Asignación"::Directa);
            IF lRstAsigDir.FINDSET THEN BEGIN
                REPEAT
                    lRstLinEnv.SETRANGE("Source Type", DATABASE::"Sales Line");
                    lRstLinEnv.SETRANGE("Source Subtype", 1);
                    lRstLinEnv.SETRANGE("Source No.", lRstAsigDir."Nº Pedido Venta");
                    lRstLinEnv.SETRANGE("Source Line No.", lRstAsigDir."Nº Linea Pedido Venta");
                    lRstLinEnv.SETRANGE("Source Document", lRstLinEnv."Source Document"::"Sales Order");
                    lRstLinEnv.SETRANGE("Estado cabecera", lRstLinEnv."Estado cabecera"::Released);
                    IF lRstLinEnv.FINDFIRST THEN
                        lCantLinsEnv += lRstLinEnv.Quantity;
                    IF lCantLinsEnv = lRstLinRecep.Quantity THEN
                        lExacto := TRUE;
                    lRstLinVenta.GET(lRstLinVenta."Document Type"::Order, lRstAsigDir."Nº Pedido Venta", lRstAsigDir."Nº Linea Pedido Venta");
                    lCantLinsVenta += lRstLinVenta.Quantity;
                UNTIL lRstAsigDir.NEXT = 0;
                IF lCantLinsVenta <> lRstLinCompra.Quantity THEN
                    ERROR(STRSUBSTNO(lTxt001, lRstLinCompra."Document No.", lRstLinRecep."Item No.", lRstLinRecep."Variant Code") +
                     'La cantidad asociada a la linea del pedido no coincide con la cantidad de asignación directa.');
                IF NOT lExacto THEN
                    ERROR(STRSUBSTNO(lTxt001, lRstLinCompra."Document No.", lRstLinRecep."Item No.", lRstLinRecep."Variant Code") +
                     'La cantidad asociada a la linea de recepción no es exacta a la suma de cantidades de las ventas asociadas.');
            END
            ELSE BEGIN
                IF lRstLinCompra."Cod Pedido Venta" <> '' THEN
                    ERROR(STRSUBSTNO(lTxt001, lRstLinCompra."Document No.", lRstLinRecep."Item No.", lRstLinRecep."Variant Code") +
                     'No se han encontrado registros asociados en ' + lRstAsigDir.TABLECAPTION);
            END;
            */ //vlrangel end
            UNTIL lRstLinRecep.NEXT() = 0;
    end;
}