namespace wms.wms;

using Microsoft.Warehouse.Document;
using Microsoft.Manufacturing.Document;
using Microsoft.Purchases.Document;

pageextension 50438 WarehouseReceiptWMS extends "Warehouse Receipt" //5768
{

    layout
    {
        addafter("Posting Date")
        {
            field(Status; Rec.Status)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Status field.', Comment = '%ESP="Estado"';
            }

            field("Tipo de Orden de Entrada"; Rec."Tipo de Orden de Entrada")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Entry Order Type field.', Comment = '%ESP="Tipo de Orden de Entrada"';
            }
            field("Pares Recibir"; Rec."Pares Recibir")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pairs Receive field.', Comment = '%ESP="Pares Recibir"';
            }

            field("Nombre Tipo de orden Entrada"; Rec."Nombre Tipo de orden Entrada")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name Order Type Entry field.', Comment = '%ESP="Nombre Tipo de orden Entrada"';
            }
            field("Tipo Origen"; Rec."Tipo Origen")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Origin Type field.', Comment = '%ESP="Tipo Origen"';
            }
            field("Cod. origen"; Rec."Cod. origen")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Origin Code field.', Comment = '%ESP="Cód. Origen"';
            }

            field("Receiving No."; Rec."Receiving No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Receiving No. field.', Comment = '%';
            }

        }

    }
    actions
    {
        addbefore("P&osting")
        {

            action("Re&lease")
            {
                ApplicationArea = Warehouse;
                Caption = 'Re&lease', comment = 'ESP="Lanzar"';
                Image = ReleaseDoc;
                ShortCutKey = 'Ctrl+F9';
                ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                trigger OnAction()
                var
                    ReleaseWhseShptDoc: Codeunit "Whse.-Shipment Release";
                    //   ReleaseWhseRecepDoc:Codeunit "Whse.-Purch. Release";
                    ReleaseWhseRecepDoc: Codeunit 50200;
                begin
                    CurrPage.Update(true);
                    if Rec.Status = Rec.Status::Open then
                        //  ReleaseWhseShptDoc.Release(Rec);
                        ReleaseWhseRecepDoc.Release(rec);
                end;
            }
            action("Re&open")
            {
                ApplicationArea = Warehouse;
                Caption = 'Re&open', comment = 'ESP="Abrir"';
                Image = ReOpen;
                ToolTip = 'Reopen the document for additional warehouse activity.';

                trigger OnAction()
                var
                    //  ReleaseWhseShptDoc: Codeunit "Whse.-Shipment Release";
                    ReleaseWhseRecepDoc: Codeunit "WareHouse Eventos";
                begin
                    //   ReleaseWhseShptDoc.Reopen(Rec);
                    ReleaseWhseRecepDoc.Reopen(rec);
                end;
            }
        }
        addfirst(Category_Process)
        {
            group(Release)
            {
                Caption = 'Release', comment = 'ESP="Lanzar"';
                actionref(Release_promoted; "Re&lease")
                { }
                actionref(RelOpen_promoted; "Re&Open")
                { }
            }
        }

    }



    var

}
