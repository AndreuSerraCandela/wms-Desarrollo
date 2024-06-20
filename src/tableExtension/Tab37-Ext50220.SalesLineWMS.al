tableextension 50220 SalesLineWMS extends "Sales Line" //37
{
    fields
    {
        field(50044; "Proposicion Venta"; boolean)
        {
            FieldClass = FlowField;
            CalcFormula = Exist(TemporalPV WHERE(Proceso = CONST('RFIDCAB'), "Clave 1" = FIELD("Document No.")));
        }
        field(50400; "Producto SEGA"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'EX-SGG-WMS 200619';
        }
        field(50401; "Cant. envios lanzados"; Decimal)
        {
            //DataClassification = ToBeClassified;
            Description = 'EX-SGG-WMS 100919 180919';
            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Shipment Line".Quantity WHERE("Source Type" = CONST(37), "Source Subtype" = CONST(1), "Source No." = FIELD("Document No."), "Source Line No." = FIELD("Line No."), "Source Document" = CONST("Sales Order"), "Estado cabecera" = CONST(Released)));
        }
        field(50403; "Cant. en envios almacen"; Decimal)
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Shipment Line".Quantity WHERE("Source Type" = CONST(37), "Source Subtype" = CONST(1), "Source No." = FIELD("Document No."), "Source Line No." = FIELD("Line No."), "Source Document" = CONST("Sales Order")));
        }
        modify("Cantidad Anulada")
        {
            trigger OnAfterValidate()
            begin
                CALCFIELDS("Cant. en envios almacen");
                IF "Cant. en envios almacen" > "Cant. Pte no anulada" THEN
                    ERROR('Cant. pdte no anulada %1 no puede ser menor que la Cant. en envíos almacén %2', "Cant. Pte no anulada", "Cant. en envios almacen");
            end;
        }
    }


    trigger OnBeforeDelete()
    var
        pT_VtasCompras: Record "Asignaciones Vtas-Compras";
    begin
        NoModificarConAsigDirecta();

        CLEAR(pT_VtasCompras);
        pT_VtasCompras.RESET();
        pT_VtasCompras.SETRANGE(pT_VtasCompras."Nº Pedido Venta", "Document No.");
        pT_VtasCompras.SETRANGE(pT_VtasCompras.Producto, "No.");
        pT_VtasCompras.SETRANGE(pT_VtasCompras.Variante, "Variant Code");
        IF pT_VtasCompras.FINDFIRST() THEN
            pT_VtasCompras.DELETE();
    end;

    trigger OnAfterModify()
    begin
        IF (NOT VolverAbrirGl) AND (NOT v_comprobar) //EX-SGG-WMS 030919 050919 110919
        AND ("Cant. Pte no anulada" <> 0) //THEN //EX-SGG-WMS 180919
        AND (("Document Type" = "Document Type"::Invoice) AND ("Shipment No." = '')) //NM-CSA-190919
        AND (("Document Type" = "Document Type"::"Credit Memo") AND ("Return Receipt No." = '')) THEN //NM-CSA-190919
            IF Type = Type::Item THEN;
        //TODO
        CduWMS.CompruebaProdAlmSEGAImaginario("No.", "Location Code"); //EX-SGG-WMS 020719
    end;

    var
        VolverAbrirGl: Boolean;
        v_comprobar: Boolean;
        CduWMS: Codeunit 50003;

}
