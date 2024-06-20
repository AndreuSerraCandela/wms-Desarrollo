table 50423 "Filtros Proposicion"
{
    LookupPageId = "Proposiciones Venta WMS";
    DrillDownPageId = "Proposiciones Venta WMS";
    fields
    {
        field(1; Clave; Code[2]) { DataClassification = ToBeClassified; }
        field(2; Temporada; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "F. Fecha Servicio Confirm."; Text[30]) { DataClassification = ToBeClassified; }
        field(4; "Filtro Pedido"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Filtro Cliente"; Text[250])
        {
            DataClassification = ToBeClassified;

        }

        //field("Filtro Representante"; FRepresentante) { ApplicationArea = All; }
        field(6; "Servicio Pedido"; Option) { OptionMembers = Todo,Resto,Nuevo; }
        field(7; "% Servicio Pedido"; Decimal) { DataClassification = ToBeClassified; }
        Field(8; "Control Agrupaciones Serie"; Boolean) { DataClassification = ToBeClassified; }

        field(9; "Cantidad Máxima Global"; Decimal) { DataClassification = ToBeClassified; }
        field(10; "Cantidad Mínima por Pedido"; Decimal) { DataClassification = ToBeClassified; }



        field(11; "Admite Tallas Parciales"; Boolean)
        {

        }
        field(12; "% Talla"; Decimal)
        {

        }
        field(13; "Filtro Producto"; Text[250])
        {

        }

        field(14; "Filtro Color"; Text[250]) { }

        field(15; "Tipo Pedido"; Option) { OptionMembers = "Todos los pedidos","Pedidos en firme","Pedidos consignacion"; }
        field(16; "Tipo Servicio"; Option) { OptionMembers = Todos,Nuevo,Reposición; }
        field(17; "Num pedidos a enviar"; Integer) { }

        field(50; "Dif F. Pedido"; DateFormula) { }
        field(51; "F.Ser.Sol"; DateFormula) { }
    }
    keys
    {
        key(Pk; Clave) { }
    }
}