table 50407 "Encajados WMS"
{
    DrillDownPageId = "Encajados WMS";
    LookupPageId = "Encajados WMS";

    fields
    {
        field(1; Codigo; Code[20])
        {
        }
        field(2; "Alto caja unidad (mm)"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcularVolumen("Alto caja unidad (mm)", "Ancho caja unidad (mm)", "Largo caja unidad (mm)",
                                "Alto caja agrupacion (mm)", "Ancho caja agrupacion (mm)", "Largo caja agrupacion (mm)");
            end;
        }
        field(3; "Ancho caja unidad (mm)"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcularVolumen("Alto caja unidad (mm)", "Ancho caja unidad (mm)", "Largo caja unidad (mm)",
                                "Alto caja agrupacion (mm)", "Ancho caja agrupacion (mm)", "Largo caja agrupacion (mm)");
            end;
        }
        field(4; "Largo caja unidad (mm)"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcularVolumen("Alto caja unidad (mm)", "Ancho caja unidad (mm)", "Largo caja unidad (mm)",
                                "Alto caja agrupacion (mm)", "Ancho caja agrupacion (mm)", "Largo caja agrupacion (mm)");
            end;
        }
        field(5; "Volumen unidad (c3)"; Decimal)
        {
        }
        field(6; "Alto caja agrupacion (mm)"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcularVolumen("Alto caja unidad (mm)", "Ancho caja unidad (mm)", "Largo caja unidad (mm)",
                                "Alto caja agrupacion (mm)", "Ancho caja agrupacion (mm)", "Largo caja agrupacion (mm)");
            end;
        }
        field(7; "Ancho caja agrupacion (mm)"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcularVolumen("Alto caja unidad (mm)", "Ancho caja unidad (mm)", "Largo caja unidad (mm)",
                                "Alto caja agrupacion (mm)", "Ancho caja agrupacion (mm)", "Largo caja agrupacion (mm)");
            end;
        }
        field(8; "Largo caja agrupacion (mm)"; Decimal)
        {

            trigger OnValidate()
            begin
                CalcularVolumen("Alto caja unidad (mm)", "Ancho caja unidad (mm)", "Largo caja unidad (mm)",
                                "Alto caja agrupacion (mm)", "Ancho caja agrupacion (mm)", "Largo caja agrupacion (mm)");
            end;
        }
        field(9; "Unidades por caja agrupacion"; Integer)
        {
        }
        field(10; "Volumen Agrupacion (c3)"; Decimal)
        {
        }
        field(11; "Paletizacion cajas por nivel"; Integer)
        {
        }
        field(12; "Paletizacion niveles por palet"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, "Alto caja unidad (mm)", "Ancho caja unidad (mm)", "Largo caja unidad (mm)", "Volumen unidad (c3)", "Alto caja agrupacion (mm)", "Ancho caja agrupacion (mm)", "Alto caja agrupacion (mm)", "Largo caja agrupacion (mm)")
        { }
        fieldgroup(Brick; Codigo, "Alto caja unidad (mm)","Volumen Agrupacion (c3)") { }
    }


    procedure CalcularVolumen(alto: Decimal; ancho: Decimal; largo: Decimal; altogroup: Decimal; anchogroup: Decimal; largogroup: Decimal) volumen: Decimal
    begin
        IF (alto <> 0) AND (ancho <> 0) AND (largo <> 0) THEN
            "Volumen unidad (c3)" := alto * ancho * largo / 1000;
        IF (altogroup <> 0) AND (anchogroup <> 0) AND (largogroup <> 0) THEN
            "Volumen Agrupacion (c3)" := altogroup * anchogroup * largogroup / 1000;
        IF ("Volumen unidad (c3)" <> 0) AND ("Volumen Agrupacion (c3)" <> 0) THEN
            "Unidades por caja agrupacion" := ROUND(("Volumen Agrupacion (c3)" / "Volumen unidad (c3)"), 1);
    end;
}

