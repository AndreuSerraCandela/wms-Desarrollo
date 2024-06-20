pageextension 50318 TotalesLineasDocVtas2WMS extends TotalesLineasDocumentosVentas2 //50030
{

    layout
    {
        addlast(Marina)
        {
            field("Envios sin lanzar"; EnviosSinlanzar)
            {
                ApplicationArea = ALL;
                Caption = 'Envios sin lanzar', comment = 'ESP="Envios sin lanzar"';
                Style = Favorable;
                StyleExpr = true;
            }
            field("Envios lanzados"; EnviosLanzados)
            {
                ApplicationArea = ALL;
                Caption = 'Envios lanzados', comment = 'ESP="Envios lanzados"';
                Style = Favorable;
                StyleExpr = true;
            }
        }

    }
    trigger OnAfterGetRecord()
    begin
        rec.CalcFields("Envios lanzados", "Envios sin lanzar");
        EnviosLanzados := Rec."Envios lanzados";
        EnviosSinlanzar := rec."Envios sin lanzar";
    end;


    var
        EnviosLanzados: Integer;
        EnviosSinlanzar: Integer;
}


