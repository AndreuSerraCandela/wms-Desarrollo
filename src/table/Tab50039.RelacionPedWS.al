table 50039 "Relacion Ped. WS"
{
    Caption = 'Relacion Ped. WS';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; CodPedido; Code[20])
        {
            Caption = 'CodPedido';
            DataClassification = ToBeClassified;
        }
        field(2; CodExterno; Code[20])
        {
            Caption = 'CodExterno';
            DataClassification = ToBeClassified;
        }
        field(3; Borrado; Boolean)
        {
            Caption = 'Borrado';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; CodPedido)
        {
            Clustered = true;
        }
    }
}
