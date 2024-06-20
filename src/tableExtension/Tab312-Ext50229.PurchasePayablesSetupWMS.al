tableextension 50229 PurchasePayablesSetupWMS extends "Purchases & Payables Setup" //312
{
    fields
    {
        field(50400; "Fecha Vto orden entrada"; DateFormula)
        {
            Caption = 'Order Due Date', comment = 'ESP="Fecha Vto orden"';
            DataClassification = ToBeClassified;
        }
    }
}
