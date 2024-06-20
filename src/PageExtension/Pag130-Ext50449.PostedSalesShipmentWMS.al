pageextension 50449 PostedSalesShipmentWMS extends "Posted Sales Shipment"//130
{
    layout
    {

        //TODO VERO WMS



    }

    actions
    {

        addfirst("&Shipment")
        {
            action("Impresion Packing")
            {
                Caption = 'Impresión Packing', comment = 'ESP="Impresión Packing"';
                ApplicationArea = All;
                image = PrintAttachment;

                trigger OnAction()
                var
                    lRepPacking: Report "InformePackingAlbaranes";
                    lRecSalesShipHeader: Record "Sales Shipment Header";
                begin
                    lRecSalesShipHeader.SETRANGE("No.", rec."No.");
                    lRepPacking.SETTABLEVIEW(lRecSalesShipHeader);
                    lRepPacking.RUNMODAL;
                end;
            }

        }
    }
}
