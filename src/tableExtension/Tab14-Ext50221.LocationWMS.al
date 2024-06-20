tableextension 50221 LocationWMS extends Location //14
{
    fields
    {

        field(50010; Necesidades; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Necesidades', comment = 'ESP="Necesidades"';
        }

        field(50400; "Clase de Stock SEGA"; code[10])
        {
            DataClassification = ToBeClassified;
            //50400	Estado Stock SEGA
            TableRelation = "Configuracion Parametros SEGA".Codigo WHERE(Tipo = FILTER(Stock));
            Caption = 'Clase de Stock SEGA', comment = 'ESP="Clase de Stock SEGA"';

            trigger OnValidate()
            begin

                //EX-OMI WMS 170619
                //IF "Estado Stock SEGA" = '' THEN
                IF rec."Clase de Stock SEGA" = '' THEN
                    "Almacen principal SEGA" := FALSE;
                //EX-OMI WMS fin
            end;
        }
        field(50401; "Estado Calidad SEGA"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Estado Calidad SEGA', comment = 'ESP="Estado Calidad SEGA"';
            TableRelation = "Configuracion Parametros SEGA".Codigo WHERE(Tipo = FILTER(Calidad));
            trigger OnValidate()
            begin

                //EX-OMI WMS 170619
                IF "Estado Calidad SEGA" = '' THEN
                    "Almacen principal SEGA" := FALSE;
                //EX-OMI WMS fin
            end;
        }
        field(50402; "Almacen principal SEGA"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Almacen principal SEGA';
            trigger OnValidate()
            var
                locrec_location: Record Location;
            begin

                //EX-OMI WMS 170619
                IF (rec."Clase de Stock SEGA" = '') OR (rec."Estado Calidad SEGA" = '') THEN
                    "Almacen principal SEGA" := FALSE
                ELSE
                    IF "Almacen principal SEGA" THEN BEGIN
                        locrec_location.SETRANGE("Clase de Stock SEGA", rec."Clase de Stock SEGA");
                        locrec_location.SETRANGE("Estado Calidad SEGA", rec."Estado Calidad SEGA");
                        locrec_location.SETRANGE("Almacen principal SEGA", TRUE);
                        IF locrec_location.COUNT <> 0 THEN BEGIN
                            "Almacen principal SEGA" := FALSE;
                            ERROR('Solo puede existir un almacen con esa combinacion');
                        END;
                    END;
                //EX-OMI WMS fin
            end;
        }


        field(50406; "Nombre Estado Calidad SEGA"; Text[50])
        {
            //DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = Lookup("Configuracion Parametros SEGA".Descripcion WHERE(Tipo = FILTER(Calidad), Codigo = FIELD("Estado Calidad SEGA")));
            Caption = 'Nombre Estado Calidad SEGA', comment = 'ESP="Nombre Estado Calidad SEGA"';

        }
        field(50407; "Nombre Clase Stock SEGA"; Text[50])
        {
            // DataClassification = ToBeClassified;
            FieldClass = FlowField;
            CalcFormula = Lookup("Configuracion Parametros SEGA".Descripcion WHERE(Tipo = FILTER(Stock), Codigo = FIELD("Clase de Stock SEGA")));
            Caption = 'Nombre Clase Stock SEGA', comment = 'ESP="Nombre Clase Stock SEGA"';
        }
    }
}
