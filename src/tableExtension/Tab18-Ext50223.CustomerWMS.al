tableextension 50223 CustomerWMS extends Customer //18
{
    fields
    {
        field(50400; "Tipo de entrega"; Code[5])
        {
            Description = 'EX-SGG-WMS 120719';
            TableRelation = "Configuracion Parametros SEGA".Codigo WHERE(Tipo = CONST(Entrega));
            Caption = 'Delivery type', comment = 'ESP="Tipo de entrega"';
            DataClassification = ToBeClassified;
        }
        field(50401; "Nombre Tipo de Entrega"; Text[50])
        {
            CalcFormula = Lookup("Configuracion Parametros SEGA".Descripcion WHERE(Tipo = FILTER(Entrega),
                                                                                    Codigo = FIELD("Tipo de entrega")));
            Description = 'EX-JFC-WMS 100919';
            FieldClass = FlowField;
            Caption = 'Name Delivery Type', comment = 'ESP="Nombre Tipo de Entrega"';
        }

        // modify("Riesgo Concedido")
        // {
        //     trigger OnAfterValidate()
        //     var
        //         LabelName: Label 'Are you sure that the Conceded Risk should be ZERO?\\', comment = 'ESP="¿Está seguro de que el Riesgo Concedido debe ser CERO?\\"';
        //         LabelName1: Label 'This change will hurt your backorders, make sure you dont have to report another value (e.g. 2).', comment = 'ESP="Este cambio perjudicará sus pedidos pendientes, asegúrese de que no debe informar otro valor (p.ej. 2)."';
        //         LabelName2: Label 'Conceded Risk Change cancelled by the user.', comment = 'ESP="Cambio de Riesgo Concedido cancelado por el usuario."';
        //         LabelName3: Label 'Order number:#1#######', comment = 'ESP="Nº Pedido:#1#######"';
        //         LabelName5: Label 'Order %1 in Sales Proposition', comment = 'ESP="Pedido %1 en Proposición de Venta"';
        //         LabelName6: Label 'There is no financial risk available', comment = 'ESP="No existe riesgo disponible financiero"';
        //         LabelName7: Label 'Error checking the work date', comment = 'ESP="Error al comprobar la fecha de trabajo"';
        //         LabelName4: Label 'Order %1 in Sales Proposition. You must notify the person in charge so that they can review it.', comment = 'ESP="Pedido %1 en Proposición de Venta. Debe avisar al responsable para que lo revise."';

        //     begin

        //         IF (xRec."Riesgo Concedido" > 0) AND ("Riesgo Concedido" <= 0) THEN
        //             IF NOT DIALOG.CONFIRM(LabelName + LabelName1, FALSE) THEN
        //                 ERROR(LabelName2);

        //         v.OPEN(LabelName3);
        //         RecPedVta.RESET();
        //         RecPedVta.SETCURRENTKEY("Document Type", "Sell-to Customer No.", "No.");
        //         RecPedVta.SETRANGE("Document Type", RecPedVta."Document Type"::Order);
        //         RecPedVta.SETRANGE("Sell-to Customer No.", "No.");
        //         RecPedVta.SETRANGE("Ventas en consignacion", FALSE);
        //         IF RecPedVta.FINDFIRST() THEN
        //             REPEAT
        //                 v.UPDATE(1, RecPedVta."No.");
        //                 RecPedVta.CALCFIELDS("Proposicion Venta", "Pares pedidos", "Pares anulados", "Pares servidos");

        //                 IF "Riesgo Concedido" < xRec."Riesgo Concedido" THEN
        //                     MESSAGE(LabelName4, RecPedVta."No.")
        //                 ELSE
        //                     MESSAGE(LabelName5, RecPedVta."No.");

        //                 IF (RecPedVta."Pares pedidos" - RecPedVta."Pares anulados" - RecPedVta."Pares servidos" > 0) THEN BEGIN

        //                     IF "Riesgo Concedido" <= 0 THEN BEGIN
        //                         RecPedVta.PedRet(TRUE);
        //                         RecPedVta.VALIDATE("Pedido Retenido", TRUE);
        //                         RecPedVta."Mensaje Retenido" := LabelName6;
        //                     END ELSE BEGIN
        //                         IF RecPedVta."Mensaje Retenido" = LabelName6 THEN BEGIN
        //                             RecPedVta.PedRet(TRUE);
        //                             RecPedVta.VALIDATE("Pedido Retenido", FALSE);
        //                             RecPedVta."Mensaje Retenido" := '';
        //                         END;
        //                     END;
        //                     RecPedVta.MODIFY();
        //                 END;

        //                 IF (xRec."Riesgo Concedido" = 0) AND ("Riesgo Concedido" > 0) THEN BEGIN
        //                     pT_LastOrder.RESET();
        //                     pT_LastOrder.SETRANGE(pT_LastOrder."Document Type", pT_LastOrder."Document Type"::Order);
        //                     pT_LastOrder.SETRANGE(pT_LastOrder."Shortcut Dimension 1 Code", RecPedVta."Shortcut Dimension 1 Code");
        //                     IF pT_LastOrder.FINDLAST() THEN BEGIN
        //                         RecPedVta."Nº Matricula" := pT_LastOrder."No.";
        //                         IncrementNoText(RecPedVta."Nº Matricula", 1);
        //                         RecPedVta.MODIFY();
        //                     END;
        //                     IF WORKDATE() <> TODAY THEN
        //                         ERROR(LabelName7);
        //                     RecPedVta."Fecha Orden asignacion" := WORKDATE();
        //                 END;
        //             UNTIL RecPedVta.NEXT() = 0;
        //         v.CLOSE();
        //     end;
        // }
    }

    var
        RecPedVta: Record "Sales Header";
        pT_LastOrder: Record "Sales Header";
        v: Dialog;
}
