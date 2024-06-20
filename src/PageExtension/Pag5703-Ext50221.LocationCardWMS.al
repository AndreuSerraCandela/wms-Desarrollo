pageextension 50221 LocationCardWMS extends "Location Card" //5703
{
    layout
    {
        addafter("Use As In-Transit")
        {

            field(Necesidades; Rec.Necesidades)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Necesidades field.', Comment = 'ESP="Necesidades"';
            }
        }
        addbefore(Bins)
        {
            group(SEGA)
            {
                Caption = 'SEGA';
                field("Clase de Stock SEGA"; Rec."Clase de Stock SEGA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Clase de Stock SEGA field.', comment = 'ESP="Especifica el código de valor del campo Clase de Stock SEGA."';
                    Caption = 'Clase de Stock SEGA', comment = 'ESP="Clase de Stock SEGA"';

                    trigger OnValidate()
                    begin
                        REC.CalcFields("Nombre Clase Stock SEGA");
                    end;
                }
                field("Nombre Clase Stock SEGA"; Rec."Nombre Clase Stock SEGA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nombre Clase Stock SEGA field.', Comment = 'ESP="Nombre Clase Stock SEGA"';
                }

              

                field("Estado Calidad SEGA"; Rec."Estado Calidad SEGA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Estado Calidad SEGA field.', comment = 'ESP="Especifica el código del campo Estado Calidad SEGA"';
                    Caption = 'Estado Calidad SEGA', comment = 'ESP="Estado Calidad SEGA"';

                    trigger OnValidate()
                    var

                    begin
                        Rec.CalcFields("Nombre Estado Calidad SEGA");
                    end;

                }
                field("Nombre Estado Calidad SEGA"; Rec."Nombre Estado Calidad SEGA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Nombre Estado Calidad SEGA field.', Comment = 'ESP="Nombre Estado Calidad SEGA"';
                }
               


                field("Almacen principal SEGA"; Rec."Almacen principal SEGA")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Almacen principal SEGA field.';
                    Caption = 'Almacen principal SEGA';
                }
                field("Ecommerce."; Rec.Ecommerce)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ecommerce field.', comment = 'ESP="Ecommerce"';
                }
                field("Reservado."; Rec.Reservado)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Reserved field.', comment = 'ESP="Reservado"';
                }

            }
        }

    }
    trigger OnAfterGetCurrRecord()
    begin

    end;

    trigger OnAfterGetRecord()
    begin
        // IF REC."Estado Calidad SEGA" <> xRec."Estado Calidad SEGA" then
        // REC.CalcFields("Nombre Calidad Stock SEGA", "Nombre Clase Stock SEGA");
        // // CurrPage.Update();

    end;

    local procedure ComprobarEstadosSEGA()
    var
        myInt: Integer;
    begin

        //EX-SGG-WMS 030719
        IF (rec."Estado Calidad SEGA" <> '') OR (Rec."Clase de Stock SEGA" <> '') THEN BEGIN
            rec.TESTFIELD(rec."Estado Calidad SEGA");
            rec.TESTFIELD("Clase de Stock SEGA");
        END;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        ComprobarEstadosSEGA(); //EX-SGG-WMS 030719
    end;
}
