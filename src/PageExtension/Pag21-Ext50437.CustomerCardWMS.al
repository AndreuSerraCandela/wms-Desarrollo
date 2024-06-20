namespace wms.wms;

using Microsoft.Sales.Customer;

pageextension 50437 CustomerCardWMS extends "Customer Card" //21
{

    layout
    {

    }
    actions
    {
        addfirst("&Customer")
        {
            action(Atributos)
            {
                //   Image = op;
                Caption = 'Atributos ttos. Logisticos', comment = 'ESP="Atributos ttos. Logisticos"';
                ApplicationArea = all;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                PromotedOnly = true;

                RunObject = Page "Atributos tto. logistic. WMS";
                RunPageLink = Codigo = field("No.");

            }
        }
    }

}
