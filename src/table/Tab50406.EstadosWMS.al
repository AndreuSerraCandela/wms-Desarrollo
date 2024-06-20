table 50406 "Estados WMS"
{
    Caption = 'Estados WMS';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Codigo; Code[10])
        {
            Caption = 'Codigo';
        }
        field(2; Descripcion; Text[25])
        {
            Caption = 'Descripcion';
        }
    }
    keys
    {
        key(PK; Codigo, Descripcion)
        {
            Clustered = true;
        }
    }
}
