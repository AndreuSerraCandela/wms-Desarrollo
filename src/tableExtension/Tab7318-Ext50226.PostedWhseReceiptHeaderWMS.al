tableextension 50226 PostedWhseReceiptHeaderWMS extends "Posted Whse. Receipt Header" //7318
{
    fields
    {
        field(50402; "Tipo origen"; Option)
        {
            OptionMembers = ,Cliente,Proveedor;
            //DataClassification = ToBeClassified;
        }
        field(50403; "Cod. origen"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50406; "Tipo de orden entrada"; Code[5])
        {
            DataClassification = ToBeClassified;
        }
    }
}
