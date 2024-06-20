tableextension 50464 PurchaseLineWMS extends "Purchase Line" //39
{

    fields
    {
        //TODO > VERO > WMS        
        field(50400; "Cant. en recepciones almacen"; Decimal)
        {
            Caption = 'Qty. in Warehouse Receptions', comment = 'ESP="Cant. en recepciones almacen"';
            Description = 'EX-SGG-WMS 221019';
            Editable = false;
            // ObsoleteState = Removed;
            // ObsoleteReason = 'Pasa a WMS';
            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Receipt Line".Quantity WHERE("Source Type" = CONST(39),
                                                                            "Source Subtype" = CONST(1),
                                                                            "Source No." = FIELD("Document No."),
                                                                            "Source Line No." = FIELD("Line No."),
                                                                            "Source Document" = CONST("Purchase Order")));
        }

        modify("Cantidad Anulada")
        {
            trigger OnAfterValidate()
            begin
                //TODO > VERO > WMS
                //EX-SGG-WMS 221019                
                CALCFIELDS(rec."Cant. en recepciones almacen");
                IF "Cant. en recepciones almacen" > "Cant. Pte no anulada" THEN
                    ERROR('El producto ' + "No." + ' ya ésta enviado a SEGA para su gestión no puede anularlo.');
                //FIN EX-SGG-WMS 221019
            end;
        }
    }



}
