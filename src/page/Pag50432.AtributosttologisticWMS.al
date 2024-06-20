page 50432 "Atributos tto. logistic. WMS"
{
    ApplicationArea = All;
    Caption = 'Atributos tto. logistic. WMS';
    PageType = List;
    SourceTable = "Atributos tto. logistic. WMS";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Tipo documento"; Rec."Tipo documento")
                {
                  //  ToolTip = 'Specifies the value of the Tipo documento field.';
                    Editable = false;
                }
                field(Codigo; Rec.Codigo)
                {
                //    ToolTip = 'Specifies the value of the Código field.';
                    Editable = false;
                }
                field("Codigo atributo"; rec."Codigo atributo")
                {
                  //  Editable = false;
                }
                field("Descripcion atributo"; Rec."Descripcion atributo")
                {
                  //  ToolTip = 'Specifies the value of the Descripción atributo field.';
                  //  Editable = false;
                }
               
            }
        }
    }
}
