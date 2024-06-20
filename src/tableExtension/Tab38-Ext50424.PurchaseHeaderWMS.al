tableextension 50424 PurchaseHeaderWMS extends "Purchase Header" //38
{
    fields
    {

        field(50400; Recepciones; Decimal)
        {
            Caption = 'Recepciones', comment = 'ESP="Recepciones"';
            FieldClass = FlowField;
            CalcFormula = Sum("Warehouse Receipt Line".Quantity WHERE("Source Type" = CONST(39),
                                                                            "Source Subtype" = CONST(1),
                                                                            "Source No." = FIELD("No."),
                                                                            "Source Document" = CONST("Purchase Order")));
            DecimalPlaces = 0 : 2;
        }
    }
}
