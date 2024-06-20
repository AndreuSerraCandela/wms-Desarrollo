/// <summary>
/// Report AsignacionPVPC (ID 50050).
/// </summary>
report 50050 "AsignacionPVPC"
{
    ApplicationArea = All;
    Caption = 'Asignación PV PC Exc', comment = 'ESP="Asignación PV PC Exc"';
    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './src/reports/Layout/AsignacionPVPC.rdl';
    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            RequestFilterFields = "Document No.", "No.", "PfsVertical Component", "PfsHorizontal Component";
            DataItemTableView = SORTING("No.", "PfsVertical Component", "Serie Precio") ORDER(Ascending) WHERE("Document Type" = CONST(Order), Type = CONST(Item), "Cant. Pte no anulada" = FILTER(> 0));

            column(Getfilters; "Sales Line".GetFilters)
            {
            }
            column(Text001; FORMAT(RecPV."Sell-to Customer No.") + ' - ' + RecPV."Bill-to Name")
            {
            }
            column(FechaServicioSolicitada; RecPV."Fecha servicio solicitada")
            {
            }
            column(PecCompra; PecCompra + ' - ' + RecPC."Pay-to Name")
            {
            }
            column(Test; Test)
            {
            }
            column(UserID; UserID)
            {
            }
            column(WorkDate; WorkDate)
            {
            }
            column(TIME; TIME)
            {
            }
            column(SeriePrecio; "Serie Precio")
            {
            }
            column(No; "No.")
            {
            }
            column(PfsVerticalComponent; "PfsVertical Component")
            {
            }
            column(PfsHorizontalComponent; 'Talla ' + FORMAT("PfsHorizontal Component"))
            {
            }
            column(ERROR; 'ERROR ' + MensajeError)
            {
            }
            column(Cantidad; Cantidad)
            {
            }
            column(LabelName; LabelName)
            {
            }
            column(LabelName1; LabelName1)
            {
            }
            column(LabelName2; LabelName2)
            {
            }
            column(LabelName3; LabelName3)
            {
            }
            column(FechaConfirmada; FechaConfirmada)
            {
            }
            column(HayError; HayError)
            {
            }

            trigger OnPreDataItem()
            var
                LabelName: Label 'A sales order must be selected', comment = 'ESP="Debe seleccionarse un pedido de venta"';
                LabelName1: Label 'Sales order does not exist', comment = 'ESP="El pedido de venta no existe"';
                LabelName2: Label 'The purchase order does not exist', comment = 'ESP="El pedido de compra no existe"';
            begin
                PedVta := "Sales Line".GETFILTER("Document No.");
                IF (STRLEN(PedVta) <> 5) AND (STRLEN(PedVta) <> 7) THEN
                    ERROR(LabelName);

                RecPV.RESET;
                RecPV.SETRANGE(RecPV."Document Type", "Document Type"::Order);
                RecPV.SETRANGE(RecPV."No.", PedVta);
                IF NOT RecPV.FINDFIRST THEN
                    ERROR(LabelName1);

                RecPC.RESET;
                RecPC.SETRANGE(RecPC."Document Type", "Document Type"::Order);
                RecPC.SETRANGE(RecPC."No.", PecCompra);
                IF NOT RecPC.FINDFIRST THEN
                    ERROR(LabelName2);
            end;

            trigger OnAfterGetRecord()
            var
                lcl_LabelName: Label 'The line has automatic assignment.', comment = 'ESP="La línea tiene asignación automática."';
                lcl_LabelName1: Label 'The line has a previous direct assignment.', comment = 'ESP="La línea tiene una asignación directa anterior. "';
                lcl_LabelName2: Label 'The line does not allow assignment.', comment = 'ESP="La línea no permite asignación. "';
                lcl_LabelName3: Label 'Direct allocation is not prepared for prepackaged.', comment = 'ESP="La asignación directa no está preparada para preembalados. "';
                lcl_LabelName4: Label 'The purchase order does not contain this MCT.', comment = 'ESP="El pedido de compra no contiene este MCT."';
                lcl_LabelName5: Label 'The purchase order does not have a confirmation date.', comment = 'ESP="El pedido de compra no tiene fecha de confirmación. "';
                lcl_LabelName6: Label 'The quantities do not match.', comment = 'ESP="No coinciden las cantidades. "';
                lcl_LabelName7: Label 'The purchase order already has direct assignment.', comment = 'ESP="El pedido de compra ya tiene asignación directa. "';
                lcl_LabelName8: Label 'Unknown error during assignment', comment = 'ESP="Error desconocido  durante asignación"';
            begin

                // Comprobación de cada línea:

                MensajeError := '';

                // 1 Verificar si hay asignaciones automáticas:

                IF ("Cantidad Asignada Stock" <> 0) OR ("Cantidad Asignada Compras" <> 0) THEN BEGIN
                    MensajeError += lcl_LabelName;
                    HayError := TRUE;
                END;

                // 2 Asignación directa anterior:

                IF "Sales Line"."Asignacion Directa" THEN BEGIN
                    MensajeError += lcl_LabelName1;
                    HayError := TRUE;
                END;

                // 3 No asignar:

                IF "Sales Line"."No Asignar" THEN BEGIN
                    MensajeError += lcl_LabelName2;
                    HayError := TRUE;
                END;

                // 4 Preembalados

                // IF "Sales Line"."PfsPrepack Code" <> '' THEN BEGIN
                //     MensajeError += lcl_LabelName3;
                //     HayError := TRUE;
                // END;

                LinPedCompra.RESET;
                LinPedCompra.SETRANGE(LinPedCompra."Document Type", "Document Type"::Order);
                LinPedCompra.SETRANGE(LinPedCompra."Document No.", PecCompra);
                LinPedCompra.SETRANGE(LinPedCompra."No.", "Sales Line"."No.");
                //TODO Pendiente de Compras
                // LinPedCompra.SETRANGE(LinPedCompra."PfsPrepack Code", "Sales Line"."PfsPrepack Code");
                LinPedCompra.SETRANGE(LinPedCompra."PfsVertical Component", "Sales Line"."PfsVertical Component");
                LinPedCompra.SETRANGE(LinPedCompra."PfsHorizontal Component", "Sales Line"."PfsHorizontal Component");
                IF LinPedCompra.FINDFIRST THEN BEGIN

                    // 5 Pedido de compra ya asignado a otro:
                    //TODO Pendiente de Compras
                    // IF (LinPedCompra."Cod Pedido Venta" <> '') OR (LinPedCompra."Cod Pedido Venta Línea" <> 0) THEN BEGIN
                    //     MensajeError += lcl_LabelName7;
                    //     HayError := TRUE;
                    // END;

                    // 6 Comprobar cantidades

                    // IF ("Sales Line"."Outstanding Quantity" - "Sales Line"."Cantidad Anulada") <>
                    //    (LinPedCompra."Outstanding Quantity" - LinPedCompra."Cantidad Anulada") THEN BEGIN
                    //     MensajeError += lcl_LabelName6;
                    //     HayError := TRUE;
                    // END;

                    // 7 Guardar fecha

                    // IF LinPedCompra."Fecha Revisada/Confirmada" > 0D THEN BEGIN
                    //     IF LinPedCompra."Fecha Revisada/Confirmada" > FechaConfirmada THEN
                    //         FechaConfirmada := LinPedCompra."Fecha Revisada/Confirmada";
                    // END ELSE BEGIN
                    //     FechaConfirmada := 0D;
                    //     MensajeError += lcl_LabelName5;
                    //     HayError := TRUE;
                    // END;

                END ELSE BEGIN
                    MensajeError += lcl_LabelName4;
                    HayError := TRUE;
                END;

                Cantidad += "Sales Line"."Outstanding Quantity" - "Sales Line"."Cantidad Anulada";

                IF FechaConfirmada <> 0D THEN BEGIN

                    FechaConfirmada := CALCDATE('+3D', FechaConfirmada);
                    IF FechaConfirmada < RecPV."Fecha servicio solicitada" THEN FechaConfirmada := RecPV."Fecha servicio solicitada";

                END ELSE
                    HayError := TRUE;

                IF NOT Test AND NOT HayError THEN BEGIN

                    LinPedVenta.RESET;
                    LinPedVenta.COPYFILTERS("Sales Line");
                    LinPedVenta.SETRANGE(LinPedVenta."Document Type", "Sales Line"."Document Type");
                    LinPedVenta.SETRANGE(LinPedVenta."Document No.", "Sales Line"."Document No.");
                    LinPedVenta.SETRANGE(LinPedVenta."No.", "Sales Line"."No.");
                    //  LinPedVenta.SETRANGE(LinPedVenta."PfsPrepack Code", '');
                    LinPedVenta.SETRANGE(LinPedVenta."PfsVertical Component", "Sales Line"."PfsVertical Component");
                    LinPedVenta.SETRANGE(LinPedVenta."Serie Precio", "Sales Line"."Serie Precio");
                    LinPedVenta.SETFILTER(LinPedVenta."Cant. Pte no anulada", '>0');
                    IF LinPedVenta.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            LinPedCompra.RESET;
                            LinPedCompra.SETRANGE(LinPedCompra."Document Type", "Document Type"::Order);
                            LinPedCompra.SETRANGE(LinPedCompra."Document No.", PecCompra);
                            LinPedCompra.SETRANGE(LinPedCompra."No.", LinPedVenta."No.");
                            //TODO Pendiente de Compras
                            // LinPedCompra.SETRANGE(LinPedCompra."PfsPrepack Code", '');
                            LinPedCompra.SETRANGE(LinPedCompra."PfsVertical Component", LinPedVenta."PfsVertical Component");
                            LinPedCompra.SETRANGE(LinPedCompra."PfsHorizontal Component", LinPedVenta."PfsHorizontal Component");
                            IF LinPedCompra.FINDFIRST THEN BEGIN
                                RecAsignVC.INIT;
                                RecAsignVC.Producto := LinPedVenta."No.";
                                RecAsignVC.Variante := LinPedVenta."Variant Code";
                                //RecAsignVC.Preembalado := LinPedVenta."PfsPrepack Code";
                                RecAsignVC."Nº Pedido Venta" := LinPedVenta."Document No.";
                                RecAsignVC."Nº Linea Pedido Venta" := LinPedVenta."Line No.";
                                RecAsignVC."Nº Pedido Compra" := LinPedCompra."Document No.";
                                RecAsignVC."Nº Linea Pedido Compra" := LinPedCompra."Line No.";
                                RecAsignVC."Cantidad Asignada" := LinPedVenta."Cant. Pte no anulada";
                                RecAsignVC."Tipo Asignación" := RecAsignVC."Tipo Asignación"::Directa;
                                RecAsignVC.INSERT;
                                //TODO Pendiente de Compras
                                // LinPedCompra."Cod Pedido Venta" := LinPedVenta."Document No.";
                                // LinPedCompra."Cod Pedido Venta Línea" := LinPedVenta."Line No.";
                                LinPedCompra.MODIFY;
                                // Actualizar línea de venta:
                                LinPedVenta."Fecha servicio confirmada" := FechaConfirmada;
                                LinPedVenta."Asignacion Directa" := TRUE;
                                LinPedVenta.MODIFY;
                            END ELSE
                                ERROR(lcl_LabelName8);
                        UNTIL LinPedVenta.NEXT = 0;

                END ELSE
                    CurrReport.SHOWOUTPUT(FALSE);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', comment = 'ESP="Opciones"';
                    field("PedidoCompra"; PecCompra)
                    {
                        Caption = 'Purchase order', comment = 'ESP="Pedido Compra"';
                        ApplicationArea = All;
                        trigger OnLookup(var Text: Text): Boolean
                        var

                        begin
                            RecPC.RESET;
                            RecPC.SETRANGE("Document Type", RecPC."Document Type"::Order);
                            IF PAGE.RUNMODAL(PAGE::"Purchase List", RecPC) = ACTION::LookupOK THEN BEGIN
                                Text := RecPC."No.";
                                EXIT(TRUE);
                            END ELSE
                                EXIT(FALSE);
                        end;
                    }
                    field(EjecutarenTest; Test)
                    {
                        Caption = 'Run in Test', comment = 'ESP="Ejecutar en Test"';
                        ApplicationArea = All;
                        trigger OnValidate()
                        var

                        begin
                            gblEnable := false;
                        end;
                    }
                    field(PV_PC; IncluirComentarios)
                    {
                        Enabled = gblEnable;
                        Caption = 'Include observations in PV and PC', comment = 'ESP="Incluir observaciones en PV y PC"';
                    }
                }
            }
        }

        var
            gblEnable: Boolean;

        trigger OnOpenPage()
        var

        begin
            gblEnable := true;
        end;
    }

    var
        PedVta: Text[30];
        PecCompra: Code[20];
        Test: Boolean;
        MensajeError: Text[200];
        HayError: Boolean;
        RecPV: Record "Sales Header";
        RecPC: Record "Purchase Header";
        LinPedCompra: Record "Purchase Line";
        LinPedVenta: Record "Sales Line";
        RecAsignVC: Record "Asignaciones Vtas-Compras";
        FechaConfirmada: Date;
        Cantidad: Decimal;
        IncluirComentarios: Boolean;
        pSalesComentEscribir: Record "Sales Comment Line";
        pPurchComentEscribir: Record "Purch. Comment Line";
        LineaCom: Integer;
        LabelName: Label 'Test OK. Could be assigned with date', comment = 'ESP="Test OK. Podría asignarse con fecha"';
        LabelName1: Label 'KO test. Could not be assigned due to the above errors.', comment = 'ESP="Test KO. No podría asignarse debido a los errores anteriores."';
        LabelName2: Label 'It has been assigned directly to PC with date', comment = 'ESP="Se ha asignado directamente a PC con fecha"';
        LabelName3: Label 'Could not be assigned due to previous errors', comment = 'ESP="No se ha podido asignar por los errores anteriores"';

    trigger OnPostReport()
    var
        LabelName: Label 'COMES PREPARED PC', comment = 'ESP="VIENE PREPARADO PC"';
        LabelName1: Label 'ADIRECTA PV', comment = 'ESP="DIRECT PV"';
    begin

        IF (NOT Test) AND IncluirComentarios AND (NOT HayError) THEN BEGIN

            pSalesComentEscribir.RESET;
            pSalesComentEscribir.SETRANGE("Document Type", pSalesComentEscribir."Document Type"::Order);
            pSalesComentEscribir.SETRANGE("No.", RecPV."No.");
            IF pSalesComentEscribir.FINDLAST() THEN
                LineaCom := pSalesComentEscribir."Line No." + 10000
            ELSE
                LineaCom := 0;

            pSalesComentEscribir.INIT;
            pSalesComentEscribir."Document Type" := pSalesComentEscribir."Document Type"::Order;
            pSalesComentEscribir."No." := RecPV."No.";
            pSalesComentEscribir."Line No." := LineaCom;
            pSalesComentEscribir.Date := TODAY;
            pSalesComentEscribir.Comment := LabelName + RecPC."No.";
            pSalesComentEscribir.INSERT;

            pPurchComentEscribir.RESET;
            pPurchComentEscribir.SETRANGE("Document Type", pSalesComentEscribir."Document Type"::Order);
            pPurchComentEscribir.SETRANGE("No.", RecPC."No.");
            IF pPurchComentEscribir.FINDLAST() THEN
                LineaCom := pPurchComentEscribir."Line No." + 10000
            ELSE
                LineaCom := 0;

            pPurchComentEscribir.INIT;
            pPurchComentEscribir."Document Type" := pSalesComentEscribir."Document Type"::Order;
            pPurchComentEscribir."No." := RecPC."No.";
            pPurchComentEscribir."Line No." := LineaCom;
            pPurchComentEscribir.Date := TODAY;
            pPurchComentEscribir.Comment := LabelName1 + RecPV."No.";
            pPurchComentEscribir.INSERT;
        END;
    end;
}
