tableextension 50222 TransfHeaderWMS extends "Transfer Header" //5740
{
    fields
    {
        field(50003; "Tipo de entrega"; Code[5])
        {
            Description = 'EX-CGR-011020';
            Caption = 'Delivery type', comment = 'ESP="Tipo de entrega"';
            DataClassification = ToBeClassified;
            TableRelation = "Configuracion Parametros SEGA".Codigo WHERE(Tipo = CONST(Entrega)); //VLRANGEL
            //
        }
    }
}
