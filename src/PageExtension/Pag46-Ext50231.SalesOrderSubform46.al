pageextension 50231 SalesOrderSubform46 extends "Sales Order Subform" //46
{
    actions

    {
        addlast("F&unctions")
        {

            action(AnularDesAnularLinea)
            {
                ApplicationArea = All;
                Caption = 'Anular / Desanular Línea ', comment = 'ESP="Anular / Desanular Línea "';
                Image = CancelAllLines;

                trigger OnAction()
                var
                    CUFunc: Codeunit Funciones;
                    Report50004: Report ProcesoAnulacionVentas;
                begin
                    Clear(Report50004);

                    IF rec.Status = rec.Status::Open THEN BEGIN
                        IF NOT CONFIRM('¿Anulación de líneas?', FALSE) THEN
                            EXIT;
                        RSales.SetRange("Document Type", rec."Document Type");
                        RSales.SetRange("Document No.", rec."Document No.");
                        RSales.SetRange("Sell-to Customer No.", Rec."Sell-to Customer No.");
                        if RSales.FindFirst() then begin
                            if RSales."Cantidad Anulada" = 0 then begin
                                Report50004.SetTableView(RSales);
                                Report50004.RunModal();
                            end else begin
                                AnulacionLineasEXC();
                            end;
                        END;

                        IF rec.Status = rec.Status::Released THEN
                            MESSAGE('Pedido Lanzado');

                        CUFunc.VisualizacionVenta(rec."No.");

                    end;
                end;
            }

        }


    }


    procedure AnulacionLineasEXC()
    var
        SalesLine: Record "Sales Line";
        // FormAnulacion: Page "Motivos";
        // BloqueosContRec: Record "Bloqueos";
        // BloqueosRec: Record "Bloqueos";
        // ContBloq: Integer;
        MotivosRec: Record "Motivos";
        LabelName: Label 'Invalid reason', comment = 'ESP="Motivo no válido"';

    begin

        CLEAR(FormAnul);

        FormAnul.PasarParam("No.", FiltroColor, Motivos, Anular);
        FormAnul.RUNMODAL;
        FormAnul.PasarParam("No.", FiltroColor, Motivos, Anular);

        MotivosRec.RESET;
        MotivosRec.SETRANGE(MotivosRec.Tipo, MotivosRec.Tipo::Anulacion);
        MotivosRec.SETRANGE(MotivosRec.Codigo, Motivos);
        if not MotivosRec.FINDFIRST then
            ERROR(LabelName);

        SalesLine.COPY(Rec);
        SalesLine.FILTERGROUP(2);
        SalesLine.SETRANGE(PfsSubline);
        SalesLine.SETRANGE("PfsMatrix Line No.", "PfsMatrix Line No.");
        if FiltroColor <> '' then
            SalesLine.SETFILTER("PfsVertical Component", FiltroColor);
        SalesLine.MotivoAnulacion(MotivosRec.Motivo);
        SalesLine.AnulacionLineas(SalesLine, Anular);
    end;

    var

        RSales: Record "Sales Line";
        FiltroColor: Code[10];
        CUFunc: Codeunit Funciones;
        Anular: Option;
        FormAnul: Page AnulacionVentas;
        Motivos: Text[50];
}
