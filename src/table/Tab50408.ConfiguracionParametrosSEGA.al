/// <summary>
/// Table Configuracion Parametros SEGA (ID 50408).
/// </summary>
table 50408 "Configuracion Parametros SEGA"
{
    // EX-SGG-WMS 270619 AGREGO OPTION TO-DO Atributo. PDTE DETERMINAR CÓMO TRASMITE A SEGA.
    //            120719 REDUCIR Codigo DE 10 A 5
    //            150719 RENOMBRO Option de TO-DO Atributo A Atributo
    //            160719 NUEVOS CAMPOS Boolean.
    //            170719 NUEVO CAMPO Caja anónima

    //  DrillDownFormID = Form50416;
    //  LookupFormID = Form50416;
    DrillDownPageId = "Configuracion Parametros SEGA";
    LookupPageId = "Configuracion Parametros SEGA";
    fields
    {
        field(1; Tipo; Option)
        {
            Description = 'EX-SGG-WMS 270619';
            OptionMembers = " ",Datos,Operacion,Centro,Rotacion,Calidad,Stock,"Orden entrada",Entrega,Atributo;
            Caption = 'Type', comment = 'ESP="Tipo"';
        }
        field(2; Codigo; Code[5])
        {
            Description = 'EX-SGG-WMS 120719';
            Caption = 'code', comment = 'ESP="Codigo"';
        }
        field(3; Descripcion; Text[50])
        {

            Caption = 'Description', comment = 'ESP="Descripcion"';
        }
        field(4; "Requiere manipulacion"; Boolean)
        {

            Caption = 'Requires handling', comment = 'ESP="Requiere manipulación"';
            Description = 'EX-SGG-WMS 160719';
        }
        field(5; "Verificar expedicion"; Boolean)
        {
            Caption = 'Verify shipment', comment = 'ESP="Verificar expedición"';
            Description = 'EX-SGG-WMS 160719';
        }
        field(6; "Indicador personalizado"; Boolean)
        {
            Description = 'EX-SGG-WMS 160719';
            Caption = 'Custom indicator', comment = 'ESP="Indicador personalizado"';

        }
        field(7; "Preparacion mono referencia"; Boolean)
        {

            Caption = 'Article monkey preparation', comment = 'ESP="Preparación mono artículo"';
            Description = 'EX-SGG-WMS 160719';
        }
        field(8; "Caja anonima"; Integer)
        {
            Caption = 'anonymous box', comment = 'ESP="Caja anónima"';
            Description = 'EX-SGG-WMS 170719';
        }
    }

    keys
    {
        key(Key1; Tipo, Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Tipo, Codigo, Descripcion)
        {
        }
    }
}
