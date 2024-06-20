tableextension 50219 SalesHeaderWMS extends "Sales Header" //36
{
    fields
    {

        field(50034; "Proposicion Venta"; Boolean)
        {
            CalcFormula = Exist(TemporalPV WHERE(Proceso = FILTER('RFIDCAB' | 'WMSCAB'), "Clave 1" = FIELD("No.")));
            Description = '181110 EX-WMS 09/09/19 Validar tambien para el proceso WMSCAB';
            Editable = true;
            FieldClass = FlowField;
            Caption = 'Sales Proposition', comment = 'ESP="Proposición Venta"';
        }

        field(50045; "No Pedido Portal"; Text[8])
        {
            Description = 'EX-SGG-WMS 120719';
            Caption = 'No Order Portal', comment = 'ESP="No Pedido Portal"';
            DataClassification = ToBeClassified;
        }
        field(50400; "Envios lanzados"; Decimal)
        {
            CalcFormula = Sum("Warehouse Shipment Line".Quantity WHERE("Source Type" = CONST(37), "Source Subtype" = CONST(1), "Source No." = FIELD("No."), "Source Document" = CONST("Sales Order"), "Estado cabecera" = CONST(Released)));
            Caption = 'Released shipments', comment = 'ESP="Envíos lanzados"';
            Description = 'EX-SGG-WMS 190619';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50401; "Envios sin lanzar"; Decimal)
        {
            CalcFormula = Sum("Warehouse Shipment Line".Quantity WHERE("Source Type" = CONST(37), "Source Subtype" = CONST(1), "Source No." = FIELD("No."), "Source Document" = CONST("Sales Order"), "Estado cabecera" = CONST(Open)));
            Caption = 'Unreleased shipments', comment = 'ESP="Envíos sin lanzar"';
            Description = 'EX-SGG-WMS 190619';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50402; "Tipo de entrega"; Code[5])
        {
            Description = 'EX-SGG-WMS 120719';
            TableRelation = "Configuracion Parametros SEGA".Codigo WHERE(Tipo = CONST(Entrega));
            Caption = 'Delivery type', comment = 'ESP="Tipo de entrega"';
            DataClassification = ToBeClassified;
        }
        field(50403; "Pedido venta original"; Code[20])
        {
            Description = 'EX-SGG-WMS 120719,EX-DRG 191020';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order), "Sell-to Customer No." = FIELD("Sell-to Customer No."), "Fecha servicio solicitada" = FIELD("Fecha servicio solicitada"), "Pedido venta original" = FILTER(''));
            Caption = 'Original sales order', comment = 'ESP="Pedido venta original"';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                lRstLinVenta: Record "Sales Line";
            begin
                //EX-SGG 040820
                TESTFIELD("Document Type", "Document Type"::Order);
                IF ("Pedido venta original" <> "No.") THEN BEGIN //EX-DRG 191020
                    IF ("Pedido venta original" <> xRec."Pedido venta original") AND (xRec."Pedido venta original" <> '') THEN BEGIN
                        lRstLinVenta.SETRANGE("Document Type", "Document Type");
                        lRstLinVenta.SETRANGE("Document No.", "No.");
                        IF lRstLinVenta.FINDSET() THEN
                            REPEAT

                                lRstLinVenta.TESTFIELD("Asignacion Directa", FALSE);
                            UNTIL lRstLinVenta.NEXT() = 0;
                    END;
                END ELSE BEGIN
                    ERROR(Text11006000006);
                END;
            end;
        }

        field(50405; "Shipment Type Name"; Text[50])
        {
            CalcFormula = Lookup("Configuracion Parametros SEGA".Descripcion WHERE(Tipo = CONST(Entrega), Codigo = FIELD("Tipo de entrega")));
            Caption = 'Shimpment Type Nam', comment = 'ESP="Nombre del tipo de envío"';
            Description = 'EX-DRG-WMS 301020';
            Editable = false;
            FieldClass = FlowField;
        }
        modify("Cod Agente")
        {
            trigger OnAfterValidate()
            var

                lRecSubAgentCust: Record "SubAgenteporCliente";
                _SalesSetup: Record "Sales & Receivables Setup";
                _recCustomer: Record Customer;

                labelError: Label 'Agent Modification, previous: ', comment = 'ESP="Modificación Agente, anterior: "';
                _repProcessSalesConsig: Report "ProcessSalesConsignments";
            begin



                TESTFIELD(Status, Status::Open);

                IF ((Confirmado) AND (xRec."Cod Agente" <> "Cod Agente")) THEN //NM_MDP_003
                    Funciones.Modificacion(labelError + xRec."Cod Agente", rec); //NM_MDP_003 TODO VERO



                IF NOT ("Ventas en consignacion") THEN BEGIN
                    DtoFact.RESET();
                    DtoFact.SETRANGE(Code, "Bill-to Customer No.");
                    IF DtoFact.FINDFIRST() THEN BEGIN
                        "% Dto Factura Cli" := DtoFact."Discount %";
                    END;

                    IF VendedorRec.GET("Cod Agente") THEN BEGIN
                        "Nombre Agente" := VendedorRec.Name;
                        lRecSubAgentCust.RESET();
                        lRecSubAgentCust.SETRANGE(lRecSubAgentCust."Cod. Cliente", "Bill-to Customer No.");
                        lRecSubAgentCust.SETRANGE(lRecSubAgentCust."Cod. Agente", "Cod Agente");
                        IF lRecSubAgentCust.FINDFIRST() THEN
                            "% Comision Ag" := lRecSubAgentCust."% Comision Agente"
                        ELSE
                            "% Comision Ag" := VendedorRec."Porcentaje Comision";

                    END ELSE BEGIN
                        "Nombre Agente" := '';
                        "% Comision Ag" := 0;
                    END;
                END;

                IF "Ventas en consignacion" THEN BEGIN
                    TESTFIELD("Proposicion Venta", FALSE);

                    "%ComisionAgent" := _repProcessSalesConsig.GetComisionConsig("Sell-to Customer No.", TRUE);

                    "%SubComisionAgent" := _repProcessSalesConsig.GetComisionConsig("Sell-to Customer No.", FALSE);
                    "%DiscountConsig" := _repProcessSalesConsig.GetDiscountConsig("Sell-to Customer No.");
                    PaymentMethodConsing := _repProcessSalesConsig.GetPaymMethodConsig("Sell-to Customer No.");

                    IF "%ComisionAgent" <> 0 THEN
                        VALIDATE("% Comision Ag", "%ComisionAgent");

                    IF "%SubComisionAgent" <> 0 THEN
                        VALIDATE("% Comision SubAg", "%SubComisionAgent");

                    IF "%DiscountConsig" <> 0 THEN
                        VALIDATE("% Dto Factura Cli", "%DiscountConsig");

                    IF PaymentMethodConsing <> '' THEN
                        VALIDATE("Payment Method Code", PaymentMethodConsing);
                END;


                UpdateSalesLines(FIELDCAPTION("Cod Agente"), FALSE); // Pfs7.50
            end;

        }
        modify("SalesPerson Code")
        {
            trigger OnBeforeValidate()
            var
                VendedorRec: Record "Salesperson/Purchaser";
            begin
                TESTFIELD(Status, Status::Open);

                IF VendedorRec.GET("Salesperson Code") THEN BEGIN
                    ComisionDto();

                    VALIDATE("Cod Agente", VendedorRec.Agente);
                END ELSE BEGIN
                    "Nombre subagente" := '';
                    "% Comision SubAg" := 0;
                END;
            end;

            trigger OnAfterValidate()
            var
                LabelName: Label 'Subagent Modification, previous: ', comment = 'ESP="Modificación Subagente, anterior: "';
            begin
                IF ((Confirmado) AND (xRec."Salesperson Code" <> "Salesperson Code")) THEN //NM_MDP_003
                    Funciones.Modificacion(LabelName + xRec."Salesperson Code", Rec); //NM_MDP_003
            end;
        }
        field(50404; "Tipo Servicio"; Enum "Tipo Servicio")
        {
            DataClassification = ToBeClassified;

        }
        field(50424; "Envio a Mail"; Text[30])
        {
            DataClassification = ToBeClassified;
        }

        modify("Ventas en consignacion")
        {
            trigger OnBeforeValidate()
            begin
                NoModificarPedidoEnviado();
            end;
        }
    }

    trigger OnDelete()
    var
        pt_PedWS: Record "Relacion Ped. WS";
    begin
        //TODO WMS
        //SF-IMF Marcamos el pedido como borrado en la tabla relacionada
        pt_PedWS.RESET;
        pt_PedWS.SETRANGE(CodPedido, "No.");
        IF pt_PedWS.FINDFIRST THEN BEGIN
            pt_PedWS.Borrado := TRUE;
            pt_PedWS.MODIFY;
        end;
    end;

    PROCEDURE ComisionDto();
    VAR
        lRecSubAgentCust: Record SubAgenteporCliente;
        _SalesSetup: Record "Sales & Receivables Setup";
        _recCustomer: Record Customer;

        _repProcessSalesConsig: Report "ProcessSalesConsignments";
    BEGIN

        IF NOT ("Ventas en consignacion") THEN BEGIN
            DtoFact.RESET();
            DtoFact.SETRANGE(Code, "Bill-to Customer No.");
            IF DtoFact.FINDFIRST() THEN BEGIN
                "% Dto Factura Cli" := DtoFact."Discount %";
            END;

            IF VendedorRec.GET("Salesperson Code") THEN BEGIN
                "Nombre subagente" := VendedorRec.Name;

                lRecSubAgentCust.RESET();
                lRecSubAgentCust.SETRANGE(lRecSubAgentCust."Cod. Cliente", "Bill-to Customer No.");
                lRecSubAgentCust.SETRANGE(lRecSubAgentCust."Cod. Subagente", "Salesperson Code");
                IF lRecSubAgentCust.FINDFIRST() THEN
                    "% Comision SubAg" := lRecSubAgentCust."% Comision Subagente"
                ELSE
                    "% Comision SubAg" := VendedorRec."Porcentaje Comision";
            END;
        END;

        IF "Ventas en consignacion" THEN BEGIN
            TESTFIELD("Proposicion Venta", FALSE);

            "%ComisionAgent" := _repProcessSalesConsig.GetComisionConsig("Sell-to Customer No.", TRUE);
            "%SubComisionAgent" := _repProcessSalesConsig.GetComisionConsig("Sell-to Customer No.", FALSE);
            "%DiscountConsig" := _repProcessSalesConsig.GetDiscountConsig("Sell-to Customer No.");
            PaymentMethodConsing := _repProcessSalesConsig.GetPaymMethodConsig("Sell-to Customer No.");

            IF "%ComisionAgent" <> 0 THEN
                VALIDATE("% Comision Ag", "%ComisionAgent");

            IF "%SubComisionAgent" <> 0 THEN
                VALIDATE("% Comision SubAg", "%SubComisionAgent");

            IF "%DiscountConsig" <> 0 THEN
                VALIDATE("% Dto Factura Cli", "%DiscountConsig");

            IF PaymentMethodConsing <> '' THEN
                VALIDATE("Payment Method Code", PaymentMethodConsing);
        END;
    END;

    trigger OnBeforeInsert()
    begin
        //TODO
        //    IF ("Document Type" = "Document Type"::Order) AND ("Sell-to Customer No." <> '') THEN //EX-SGG-WNS 020919
        //     CduWMS.CopiarAtributosTtoLogistico(0, 1, "Sell-to Customer No.", "No.");

    end;

    PROCEDURE NoModificarPedidoEnviado();
    Begin
        recSalesLine.RESET;
        recSalesLine.SETRANGE("Document No.", "No.");
        recSalesLine.SETRANGE(Type, recSalesLine.Type::Item);
        IF recSalesLine.FINDSET THEN
            REPEAT
                IF recSalesLine."Cant. Pte no anulada" <> recSalesLine."Outstanding Quantity" - recSalesLine."Cantidad Anulada" THEN
                    ERROR('No se puede modificar ya que tiene movimientos realizados.');
                IF recSalesLine."Quantity Shipped" <> 0 THEN
                    ERROR('Ya existe una linea de almacen registrado.');
            UNTIL recSalesLine.NEXT = 0;

        WarehouseShipmentLine.SETRANGE("Source No.", "No.");
        IF WarehouseShipmentLine.FINDFIRST THEN
            ERROR('Ya existe una linea de almacen enviado.');


    END;


    procedure CheckLocation(ShowError: Boolean): Boolean
    begin
        IF NOT ("Shipping Advice" = "Shipping Advice"::Complete) THEN
            EXIT(FALSE);

        SalesLine.SETRANGE("Document Type", "Document Type");
        SalesLine.SETRANGE("Document No.", "No.");
        SalesLine.SETRANGE(Type, SalesLine.Type::Item);
        IF SalesLine.FINDSET THEN BEGIN
            SalesLine2.COPYFILTERS(SalesLine);
            SalesLine2.SETCURRENTKEY("Document Type", "Document No.", "Location Code");
            SalesLine2.SETFILTER("Location Code", '<> %1', SalesLine."Location Code");
            IF SalesLine2.FINDFIRST THEN BEGIN
                IF ShowError THEN
                    ERROR(Text050, FIELDCAPTION("Shipping Advice"), "Shipping Advice", "No.", SalesLine.Type);
                EXIT(TRUE);
            END;
            REPEAT
            //TODO
            // IF CheckItemAvail.SalesLineShowWarning(SalesLine) THEN BEGIN
            //     IF ShowError THEN
            //         ERROR(Text064, SalesLine."No.", SalesLine."Location Code", SalesLine."Document No.");
            //     EXIT(TRUE);
            // END;
            UNTIL SalesLine.NEXT = 0
        END;
    end;

    PROCEDURE TotalCantiConsigLines(): Decimal;
    VAR
        SalesLine: Record 37;
        ret: Decimal;
    BEGIN
        //EX-CV
        SalesLine.RESET;
        SalesLine.SETRANGE("Document Type", "Document Type");
        SalesLine.SETRANGE("Document No.", "No.");
        IF SalesLine.FINDSET THEN
            REPEAT
                SalesLine.CALCFIELDS("Cantidad en consignacion");
                ret += SalesLine."Cantidad en consignacion";
            UNTIL SalesLine.NEXT = 0;

        EXIT(ret);
        //EX-CV END
    END;

    var
        CheckItemAvail: Page "Check Availability";
        SalesLine2: Record "Sales Line";
        Text064: Label 'No se creó el envío de almacén porque el campo Aviso envío se configuró en Completo y el número de producto %1 no está disponible en el código de almacén %2.\\Para crear el envío de almacén, puede cambiar el campo Aviso de envío a Parcial en el pedido de venta número %3 o rellenar manualmente el documento de envío de almacén.';
        Text050: Label 'Si %1 es %2 en el nº de pedido de venta %3, todas las líneas venta donde el tipo es %4 deben utilizar el mismo almacén.';
        Funciones: Codeunit Funciones;
        DtoFact: Record "Cust. Invoice Disc.";
        VendedorRec: Record "Salesperson/Purchaser";
        "%ComisionAgent": Decimal;
        "%SubComisionAgent": Decimal;
        recSalesLine: Record "Sales Line";
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        "%DiscountConsig": Decimal;
        PaymentMethodConsing: Code[20];
        Text11006000006: Label 'The original sales order and the order number cannot be the same', comment = 'ESP="El pedido de ventas original y el número de pedido no pueden ser iguales"';


}
