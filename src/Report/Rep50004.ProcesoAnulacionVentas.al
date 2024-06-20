/// <summary>
/// Report Proceso Anulacion Ventas (ID 50004).
/// </summary>
report 50004 "ProcesoAnulacionVentas"
{
    ApplicationArea = All;
    Caption = 'Proceso anulacion';
    // Caption = 'Sales  Anulation Process Exc ', comment = 'ESP="Proceso Anulación Ventas Exc"';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/Layout/ProcesoAnulacionVentas.rdl';
    dataset
    {
        dataitem("líneas"; "Sales Line")
        {
            DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE("Document Type" = CONST(Order), Type = CONST(Item));
            RequestFilterFields = "Shortcut Dimension 1 Code", "Sell-to Customer No.", "Document No.", "No.", "PfsVertical Component", "PfsHorizontal Component", "Fecha servicio solicitada", "Fecha servicio confirmada", "Motivo Anulacion";

            column(LineasVentaAnuladaCaption; LineasVentaAnuladaCaption)

            {
            }
            column(Getfilters; líneas.GetFilters)
            {
            }
            column(RecMotivoAnulMotivo; MotivoAnul + '  ' + RecMotivoAnul.Motivo)
            {
            }
            column(USERID; USERID)
            {
            }
            column(TODAY; FORMAT(TODAY, 0, 4))
            {
            }
            column(pSalesHeaderNo; pSalesHeader."No.")
            {
            }
            column(pSalesHeaderSelltoCustomerNo; pSalesHeader."Sell-to Customer No.")
            {
            }
            column(No; "No.")
            {
            }
            column(Description; Description)
            {
            }
            column(PfsVerticalComponent; "PfsVertical Component")
            {
            }
            column(PfsHorizontalComponent; "PfsHorizontal Component")
            {
            }
            column(CantidadInforme; CantidadInforme)
            {
            }
            column(ERROR; 'ERROR, pedido en proposición de venta')
            {
            }
            column(CantPtenoanulada; "Cant. Pte no anulada")
            {
            }
            column("DocumentNo"; "Document No.")
            {
            }
            column(OpcAnul; OpcAnul)
            {
            }
            column(Test; Test)
            {
            }
            column(QuantityCaption; QuantityCaption)
            {
            }
            column(SizeCaption; SizeCaption)
            {
            }
            column(ColorCaption; ColorCaption)
            {
            }
            column(NPedidoCaption; NPedidoCaption)
            {
            }
            column(CustomerCaption; CustomerCaption)
            {
            }
            column(FiltroLineaCaption; FiltroLineaCaption)
            {
            }
            column(LineasVentaRecuperadasCaption; LineasVentaRecuperadasCaption)
            {
            }
            column(pSalesHeaderProposicionVenta; pSalesHeader."Proposicion Venta")
            {
            }
            column(gblVisibilidad; gblVisibilidad)
            {
            }
            column(Total; Total)
            {
            }

            trigger OnPreDataItem()
            var

            begin

                Total := 0;

                IF OpcAnul = OpcAnul::Anular THEN BEGIN
                    líneas.SETFILTER(líneas."Cant. Pte no anulada", '<>0');
                END ELSE BEGIN
                    líneas.SETRANGE(líneas."Linea Anulada", TRUE);
                END;

                HayErroresPV := FALSE;
            end;

            trigger OnAfterGetRecord()
            var

            begin

                Lanzado := Lanzado::Open;
                pSalesHeader.RESET;
                pSalesHeader.SETRANGE(pSalesHeader."Document Type", líneas."Document Type");
                pSalesHeader.SETRANGE(pSalesHeader."No.", líneas."Document No.");
                IF pSalesHeader.FINDFIRST THEN BEGIN
                    IF NOT pSalesHeader."Proposicion Venta" THEN BEGIN
                        IF NOT Test THEN BEGIN
                            IF pSalesHeader.Status <> pSalesHeader.Status::Open THEN BEGIN
                                Lanzado := pSalesHeader.Status.AsInteger();
                                pSalesHeader.Status := pSalesHeader.Status::Open;
                                pSalesHeader.MODIFY;
                            END;
                        END;
                    END ELSE
                        HayErroresPV := TRUE;
                END;
                //**************************************

                // if ((OpcAnul = OpcAnul::Anular) AND ("Cant. Pte no anulada" > 0) AND (NOT pSalesHeader."Proposicion Venta")) then begin
                if ((OpcAnul = OpcAnul::Anular) AND ("Cant. Pte no anulada" > 0)) then begin
                    IF NOT Test THEN BEGIN
                        // Normalmente la cantidad anulada inicial suele ser cero, pero puede ser que la línea estuviera parcialmente anulada:
                        CantidadAnuladaInicial := "Cantidad Anulada";
                        VALIDATE("Linea Anulada", TRUE);
                        "Motivo Anulacion" := MotivoAnul;
                        MODIFY;
                        CantidadInforme := "Cantidad Anulada" - CantidadAnuladaInicial;
                    END ELSE BEGIN
                        CantidadInforme := "Cant. Pte no anulada";
                    END;
                    Total += CantidadInforme;
                END;
                ////////*******************************
                //IF ((OpcAnul = OpcAnul::Desanular) AND ("Cantidad Anulada" <> 0) AND (NOT pSalesHeader."Proposicion Venta")) THEN BEGIN
                IF ((OpcAnul = OpcAnul::Desanular) AND ("Cantidad Anulada" <> 0)) THEN BEGIN

                    IF NOT Test THEN BEGIN
                        // Guardar cantidad:
                        CantidadAnuladaInicial := "Cantidad Anulada";
                        CantidadInforme := CantidadAnuladaInicial;
                        // Poner a cero anulación:
                        "Linea Anulada" := FALSE;
                        "Cantidad Anulada" := 0;
                        "Cant. Pte no anulada" := "Outstanding Quantity";
                        "Motivo Anulacion" := MotivoAnul;
                        MODIFY;
                    END ELSE BEGIN
                        CantidadInforme := "Cantidad Anulada";
                    END;
                    Total += CantidadInforme;
                END;
                //************
                IF NOT pSalesHeader."Proposicion Venta" AND NOT Test THEN BEGIN

                    // Guardar comentario en bloqueos del pedido:

                    IF BloqueosContRec.FINDLAST THEN
                        ContBloq := BloqueosContRec.Contador
                    ELSE
                        ContBloq := 0;

                    BloqueosRec.INIT;
                    BloqueosRec.Contador := ContBloq + 1;
                    BloqueosRec."Tipo Bloqueo" := BloqueosRec."Tipo Bloqueo"::"Anulacion Venta";
                    BloqueosRec.Codigo := pSalesHeader."No.";
                    // BloqueosRec.Usuario := USERID;
                    BloqueosRec."Fecha Bloqueo" := WORKDATE;
                    IF OpcAnul = OpcAnul::Anular THEN
                        BloqueosRec.Motivo := 'Anulación proceso ' + RecMotivoAnul.Motivo
                    ELSE
                        BloqueosRec.Motivo := 'Recuperación proceso ' + RecMotivoAnul.Motivo;
                    BloqueosRec.INSERT;

                    // Lanzar de nuevo el pedido:

                    IF Lanzado <> Lanzado::Open THEN BEGIN
                        pSalesHeader.Status := pSalesHeader.Status::Released;
                        pSalesHeader.MODIFY;
                    END;
                END;
            end;

            trigger OnPostDataItem()
            var
                LabelName: Label 'Orders have been found in sales proposals that could not be modified.', comment = 'ESP="Se han encontrado pedidos en proposición de venta que no han podido modificarse. ';
                LabelName1: Label 'Review the report for more information.', comment = 'ESP="Revise el informe para más información."';
            begin

                IF HayErroresPV THEN
                    MESSAGE(LabelName + LabelName1);
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
                    field("MotivodeAnulacionoDesanulacion"; MotivoAnul)
                    {
                        Caption = 'Reason for Cancellation or Cancellation', comment = 'ESP="Motivo de Anulación o Desanulación"';
                        ApplicationArea = All;
                        TableRelation = "Motivos".Codigo WHERE(Tipo = CONST(Anulacion));
                    }
                    field("Opcion"; OpcAnul)
                    {
                        ApplicationArea = All;
                        Caption = 'Option', comment = 'ESP="Opción"';

                        trigger OnValidate()
                        var

                        begin

                            if OpcAnul = OpcAnul::Anular then
                                gblVisibilidad := true
                            else
                                gblVisibilidad := false;
                        end;

                    }
                    field("EjecutarenTEST"; Test)
                    {
                        ApplicationArea = All;
                        Caption = 'Run in TEST', comment = 'ESP="Ejecutar en TEST"';
                    }
                }
            }
        }

    }
    trigger OnInitReport()
    begin
        gblVisibilidad := false;
    end;

    var
        MotivoAnul: Text[50];
        BloqueosContRec: Record "Bloqueos";
        BloqueosRec: Record "Bloqueos";
        ContBloq: Integer;
        CabVtaRec: Record "Sales Header";
        ClienteRec: Record "Customer";
        OpcAnul: Option Anular,Desanular;
        Lanzado: Option Open,Released,"Pending Approval","Pending Prepayment";
        CULanzar: Codeunit "Release Sales Document";
        RecMotivoAnul: Record "Motivos";
        v: Dialog;
        c: Integer;
        t: Integer;
        Total: Decimal;
        pSalesHeader: Record "Sales Header";
        CantidadAnuladaInicial: Decimal;
        CantidadInforme: Decimal;
        HayErroresPV: Boolean;
        Test: Boolean;
        gblVisibilidad: Boolean;
        AlertaVarios: Label 'The following filter can affect more than one %1:\', comment = 'ESP="El siguiente filtro puede afectar a más de un %1:\\%2\\¿Seguro que quiere continuar?\"';
        AlertaNoFiltro: Label 'You have not set a %1 filter.\\Are you sure you want to continue?\', comment = 'ESP="No ha fijado ningún filtro de %1.\\¿Seguro que quiere continuar?\"';
        LineasVentaAnuladaCaption: Label 'Canceled Sale Lines', comment = 'ESP="Líneas Venta Anulada"';
        LineasVentaRecuperadasCaption: Label 'Recovered Sales Lines', comment = 'ESP="Líneas Venta Recuperadas"';
        FiltroLineaCaption: Label 'Line filters:', comment = 'ESP="Filtro líneas:"';
        NPedidoCaption: Label 'No. Order', comment = 'ESP="No. Pedido"';
        CustomerCaption: Label 'Customer', comment = 'ESP="Cliente"';
        ColorCaption: Label 'Color', comment = 'ESP="Color"';
        SizeCaption: Label 'Size', comment = 'ESP="Talla"';
        QuantityCaption: Label 'Quantity', comment = 'ESP="Cantidad"';


    trigger OnPreReport()
    var
        LabelName: Label 'You must inform the reason for cancellation', comment = 'ESP="Debe informar motivo anulación"';
        LabelName1: Label 'You must inform the reason for recovery', comment = 'ESP="Debe informar motivo recuperación"';
        LabelName2: Label 'The execution has been cancelled.', comment = 'ESP="Se ha cancelado la ejecución."';
        LabelName3: Label 'customer', comment = 'ESP="cliente"';
        LabelName4: Label 'order', comment = 'ESP="pedido"';
    begin

        IF NOT Test THEN BEGIN // COO3
            IF MotivoAnul = '' THEN BEGIN
                IF OpcAnul = OpcAnul::Anular THEN
                    ERROR(LabelName);
                IF OpcAnul = OpcAnul::Desanular THEN
                    ERROR(LabelName1);
            END;

            RecMotivoAnul.RESET;
            RecMotivoAnul.SETRANGE(Tipo, RecMotivoAnul.Tipo::Anulacion);
            RecMotivoAnul.SETRANGE(Codigo, MotivoAnul);
            IF RecMotivoAnul.FINDFIRST THEN;
        END;

        IF líneas.GETFILTER("Sell-to Customer No.") <> '' THEN BEGIN
            ClienteRec.RESET;
            ClienteRec.SETFILTER("No.", líneas.GETFILTER("Sell-to Customer No."));
            IF ClienteRec.COUNT > 1 THEN
                IF NOT DIALOG.CONFIRM(AlertaVarios, FALSE, LabelName3, líneas.GETFILTER("Sell-to Customer No.")) THEN
                    ERROR(LabelName2);
        END ELSE BEGIN
            IF NOT DIALOG.CONFIRM(AlertaNoFiltro, FALSE, LabelName3) THEN
                ERROR(LabelName2);
        END;

        IF líneas.GETFILTER("Document No.") <> '' THEN BEGIN
            CabVtaRec.RESET;
            CabVtaRec.SETFILTER("No.", líneas.GETFILTER("Document No."));
            IF CabVtaRec.COUNT > 1 THEN
                IF NOT DIALOG.CONFIRM(AlertaVarios, FALSE, LabelName4, líneas.GETFILTER("Document No.")) THEN
                    ERROR(LabelName2);
        END ELSE BEGIN
            IF NOT DIALOG.CONFIRM(AlertaNoFiltro, FALSE, LabelName4) THEN
                ERROR(LabelName2);
        END;
    end;
}
