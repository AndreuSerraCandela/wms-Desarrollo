/// <summary>
/// Report DesglosePedidosVenta (ID 50404).
/// </summary>
report 50404 DesglosePedidosVenta
{
    ApplicationArea = All;
    Caption = 'Desglose de pedidos de venta', comment = 'ESP="Desglose de pedidos de venta"';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.") ORDER(Ascending) WHERE("Document Type" = CONST(Order));
            RequestFilterFields = "No.";

            dataitem("Sales Line"; "Sales Line")
            {

                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending);
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");

                dataitem("Purchase Line"; "Purchase Line")
                {
                    DataItemTableView = SORTING("Cod Pedido Venta", "Cod Pedido Venta Línea") ORDER(Ascending) WHERE("Document Type" = CONST(Order));
                    DataItemLink = "Cod Pedido Venta" = FIELD("Document No."), "Cod Pedido Venta Línea" = FIELD("Line No.");

                    trigger OnPreDataItem()
                    var
                    begin
                        IF NOT "Sales Line"."Asignacion Directa" THEN CurrReport.BREAK;
                    end;


                    trigger OnAfterGetRecord()
                    var
                    begin

                        RstTMPLinCompraAcum.SETRANGE(Type, Type);
                        RstTMPLinCompraAcum.SETRANGE("No.", "No.");
                        RstTMPLinCompraAcum.SETRANGE("Variant Code", "Variant Code");
                        IF NOT RstTMPLinCompraAcum.FINDFIRST THEN BEGIN
                            RstTMPLinCompraAcum.TRANSFERFIELDS("Purchase Line");
                            RstTMPLinCompraAcum.INSERT;
                        END
                        ELSE BEGIN
                            //EX-SGG-WMS 250919
                            IF (RstTMPLinCompraAcum."Document No." <> "Purchase Line"."Document No.") OR
                             (RstTMPLinCompraAcum."Line No." <> "Purchase Line"."Line No.") THEN
                                ERROR('No puede existir el mismo producto y variante con asignación directa asociado a más de un ' +
                                 'pedido/línea de compra simultaneamente. Campos identificativos:\' +
                                 'Pedido de compra 1: ' + RstTMPLinCompraAcum."Document No." +
                                 ' línea: ' + FORMAT(RstTMPLinCompraAcum."Line No.") +
                                 ' producto: ' + RstTMPLinCompraAcum."No." + ' ' + RstTMPLinCompraAcum."Variant Code" + '\' +
                                 'Pedido de compra 2: ' + "Document No." +
                                 ' línea: ' + FORMAT("Line No.") +
                                 ' producto: ' + "No." + ' ' + "Variant Code");
                            //FIN EX-SGG-WMS
                            RstTMPLinCompraAcum.Quantity += Quantity;
                            RstTMPLinCompraAcum."Cant. Pte no anulada" += "Cant. Pte no anulada";//EX-DRG 201120
                            RstTMPLinCompraAcum.MODIFY;
                        END;
                    end;
                }

                trigger OnPreDataItem()
                var
                begin
                    CLEAR(OrderFilter);
                end;

                trigger OnAfterGetRecord()
                var
                begin

                    RstTMPLinVentaOrigAcum.SETRANGE(Type, Type);
                    RstTMPLinVentaOrigAcum.SETRANGE("No.", "No.");
                    RstTMPLinVentaOrigAcum.SETRANGE("Variant Code", "Variant Code");
                    IF NOT RstTMPLinVentaOrigAcum.FINDFIRST THEN BEGIN
                        RstTMPLinVentaOrigAcum.TRANSFERFIELDS("Sales Line");
                        RstTMPLinVentaOrigAcum.INSERT;
                    END
                    ELSE BEGIN
                        RstTMPLinVentaOrigAcum.Quantity += Quantity;
                        RstTMPLinVentaOrigAcum."Cant. Pte no anulada" += "Cant. Pte no anulada";//EX-DRG 201120
                        RstTMPLinVentaOrigAcum.MODIFY;
                    END;

                    IF OrderFilter = '' THEN BEGIN
                        OrderFilter := "Document No.";
                    END ELSE BEGIN
                        IF LastOrderFilter <> "Document No." THEN
                            OrderFilter += '|' + "Document No.";
                    END;

                    LastOrderFilter := "Document No.";
                end;
            }
            dataitem("Sales Header nuevos"; "Sales Header")
            {

                DataItemTableView = SORTING("Pedido venta original") ORDER(Ascending);
                DataItemLink = "Document Type" = FIELD("Document Type"), "Pedido venta original" = FIELD("No.");



                dataitem("Sales Line nuevos"; "Sales Line")
                {
                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") ORDER(Ascending);
                    DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                    trigger OnAfterGetRecord()
                    var
                        myInt: Integer;
                    begin

                        RstTMPLinVentaNuevosAcum.SETRANGE(Type, Type);
                        RstTMPLinVentaNuevosAcum.SETRANGE("No.", "No.");
                        RstTMPLinVentaNuevosAcum.SETRANGE("Variant Code", "Variant Code");
                        IF NOT RstTMPLinVentaNuevosAcum.FINDFIRST THEN BEGIN
                            RstTMPLinVentaNuevosAcum.TRANSFERFIELDS("Sales Line nuevos");
                            RstTMPLinVentaNuevosAcum.INSERT;
                        END
                        ELSE BEGIN
                            RstTMPLinVentaNuevosAcum.Quantity += Quantity;
                            RstTMPLinVentaNuevosAcum."Cant. Pte no anulada" += "Cant. Pte no anulada"; //EX-SGG 281220
                            RstTMPLinVentaNuevosAcum.MODIFY;
                        END;

                        RstTMPLinVentaNuevos.TRANSFERFIELDS("Sales Line nuevos");
                        RstTMPLinVentaNuevos.INSERT;

                        //EX-SGG 040820
                        RstLinVenta.RESET;
                        RstLinVenta.SETRANGE("Document Type", "Document Type");
                        RstLinVenta.SETRANGE("Document No.", "Sales Header nuevos"."Pedido venta original");
                        RstLinVenta.SETRANGE(Type, Type);
                        RstLinVenta.SETRANGE("No.", "No.");
                        RstLinVenta.SETRANGE("Variant Code", "Variant Code");
                        IF RstLinVenta.FINDFIRST THEN BEGIN
                            RstLinVenta.EstableceEsProcesoAsigDirecta(TRUE); //EX-SGG 241220
                            "Fecha servicio confirmada" := RstLinVenta."Fecha servicio confirmada";
                            MODIFY;
                        END;


                        IF OrderFilter = '' THEN BEGIN
                            OrderFilter := "Sales Line nuevos"."Document No.";
                        END ELSE BEGIN
                            IF LastOrderFilter <> "Sales Line nuevos"."Document No." THEN BEGIN
                                IF "Sales Line nuevos"."Document No." = INCSTR(LastOrderFilter) THEN BEGIN // ¿Es el siguiente número?
                                    IF COPYSTR(OrderFilter, STRLEN(OrderFilter) - STRLEN(LastOrderFilter) - STRLEN('..') + 1, 2) = '..' THEN
                                        OrderFilter := COPYSTR(OrderFilter, 1, STRLEN(OrderFilter) - STRLEN(LastOrderFilter)) + "Sales Line nuevos"."Document No."
                                    ELSE
                                        OrderFilter += '..' + "Sales Line nuevos"."Document No.";
                                END ELSE
                                    OrderFilter += '|' + "Sales Line nuevos"."Document No.";
                            END;
                        END;
                        LastOrderFilter := "Document No.";
                    end;

                }

                trigger OnAfterGetRecord()
                var
                begin

                    "Nº Matricula" := "Sales Header"."Nº Matricula";
                    "Fecha Orden asignacion" := "Sales Header"."Fecha Orden asignacion";
                    MODIFY;
                end;
            }
            dataitem("Comprobar acumulados ventas"; Integer)
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);


                trigger OnAfterGetRecord()
                var
                begin

                    RstTMPLinCompraAcum.RESET;
                    IF RstTMPLinCompraAcum.FINDSET THEN BEGIN
                        RstTMPLinVentaNuevos.RESET;
                        RstTMPLinVentaNuevos.SETCURRENTKEY("Document Type", Type, "No.", "Variant Code");
                        RstTMPLinVentaNuevosAcum.RESET;
                        RstTMPLinVentaNuevosAcum.SETCURRENTKEY("Document Type", Type, "No.", "Variant Code");
                        REPEAT
                            RstTMPLinVentaNuevosAcum.SETRANGE(Type, RstTMPLinCompraAcum.Type);
                            RstTMPLinVentaNuevosAcum.SETRANGE("No.", RstTMPLinCompraAcum."No.");
                            RstTMPLinVentaNuevosAcum.SETRANGE("Variant Code", RstTMPLinCompraAcum."Variant Code");
                            IF RstTMPLinVentaNuevosAcum.FINDFIRST THEN BEGIN
                                IF RstTMPLinVentaNuevosAcum."Cant. Pte no anulada" = RstTMPLinCompraAcum."Cant. Pte no anulada" THEN
                                 BEGIN
                                    RstTMPLinVentaNuevos.COPYFILTERS(RstTMPLinVentaNuevosAcum);
                                    RstTMPLinVentaNuevos.FINDSET;
                                    REPEAT
                                        RstAsigDirecta.INIT;
                                        RstAsigDirecta.VALIDATE("Nº Pedido Venta", RstTMPLinVentaNuevos."Document No.");
                                        RstAsigDirecta.VALIDATE("Nº Linea Pedido Venta", RstTMPLinVentaNuevos."Line No.");
                                        RstAsigDirecta.VALIDATE("Tipo Asignación", RstAsigDirecta."Tipo Asignación"::Directa);
                                        RstAsigDirecta.VALIDATE("Nº Pedido Compra", RstTMPLinCompraAcum."Document No.");
                                        RstAsigDirecta.VALIDATE("Nº Linea Pedido Compra", RstTMPLinCompraAcum."Line No.");
                                        RstAsigDirecta.VALIDATE(Producto, RstTMPLinVentaNuevos."No.");
                                        RstAsigDirecta.VALIDATE(Variante, RstTMPLinVentaNuevos."Variant Code");
                                        RstAsigDirecta.VALIDATE("Cantidad Asignada", RstTMPLinVentaNuevos."Cant. Pte no anulada");
                                        RstAsigDirecta.INSERT;
                                        RstLinVenta.GET(RstTMPLinVentaNuevos."Document Type", RstTMPLinVentaNuevos."Document No.",
                                         RstTMPLinVentaNuevos."Line No.");
                                        RstLinVenta.VALIDATE("Asignacion Directa", TRUE);
                                        RstLinVenta.MODIFY;
                                    UNTIL RstTMPLinVentaNuevos.NEXT = 0;
                                END
                                ELSE
                                    ERROR('Cantidad acumulada para el producto en el pedido de compra de asignación directa ' +
                                    'no debe ser distinta a la cantidad acumulada del producto de los pedidos de venta relacionados:\' +
                                    'Pedido de compra: ' + RstTMPLinCompraAcum."Document No." +
                                    ' línea: ' + FORMAT(RstTMPLinCompraAcum."Line No.") +
                                    ' producto: ' + RstTMPLinCompraAcum."No." + ' ' + RstTMPLinCompraAcum."Variant Code" + '\' +
                                    'Cantidad pedido de compra: ' + FORMAT(RstTMPLinCompraAcum.Quantity) + '\' +
                                    'Cantidad en pedidos de venta: ' + FORMAT(RstTMPLinVentaNuevosAcum."Cant. Pte no anulada"));
                            END
                            ELSE
                                ERROR('Deben existir líneas de venta asociadas al producto y variante cuandro se trata ' +
                                 'de una asignación directa asociada a un pedido de compra.\' +
                                 'Pedido de compra: ' + RstTMPLinCompraAcum."Document No." +
                                 ' línea: ' + FORMAT(RstTMPLinCompraAcum."Line No.") +
                                 ' producto: ' + RstTMPLinCompraAcum."No." + ' ' + RstTMPLinCompraAcum."Variant Code");
                        UNTIL RstTMPLinCompraAcum.NEXT = 0;
                    END;
                end;

                trigger OnPostDataItem()
                var
                begin

                    RstAsigDirecta.RESET;
                    RstAsigDirecta.SETRANGE("Nº Pedido Venta", "Sales Header"."No.");
                    IF RstAsigDirecta.FINDSET THEN
                        REPEAT
                            RstAsigDirecta."Cantidad Asignada" := 0;
                            RstAsigDirecta.MODIFY;
                        UNTIL RstAsigDirecta.NEXT = 0;

                end;

            }

            trigger OnAfterGetRecord()
            var
            begin

                TESTFIELD("Pedido venta original", ''); //EX-SGG-WMS 250919

                RstTMPLinVentaNuevos.RESET;
                RstTMPLinVentaNuevos.DELETEALL;
                RstTMPLinVentaNuevosAcum.RESET;
                RstTMPLinVentaNuevosAcum.DELETEALL;
                RstTMPLinVentaNuevosAcum.SETCURRENTKEY("Document Type", Type, "No.", "Variant Code");


                RstTMPLinCompraAcum.RESET;
                RstTMPLinCompraAcum.DELETEALL;
                RstTMPLinCompraAcum.SETCURRENTKEY("Document Type", Type, "No.", "Variant Code");

                RstTMPLinVentaOrigAcum.RESET;
                RstTMPLinVentaOrigAcum.DELETEALL;
                RstTMPLinVentaOrigAcum.SETCURRENTKEY("Document Type", Type, "No.", "Variant Code");
            end;
        }
    }

    var
        RstTMPLinVentaNuevos: Record "Sales Line";
        RstTMPLinVentaNuevosAcum: Record "Sales Line";
        RstLinVenta: Record "Sales Line";
        RstTMPLinCompraAcum: Record "Purchase Line";
        RstAsigDirecta: Record "Asignaciones Vtas-Compras";
        RstTMPLinVentaOrigAcum: Record "Sales Line";
        LogOrders: Report "LogOrders";
        OrderFilter: Text[250];
        LastOrderFilter: Code[20];
        SalesHeader: Record "Sales Header";
        rSalesLine: Record "Sales Line";
        MAnulacion: Record "Motivos";


    trigger OnPreReport()
    var
    begin

        IF (RstTMPLinVentaNuevos.FINDFIRST) OR //(RstTMPLinCompra.FINDFIRST) OR  //EX-SGG-WMS 250919 COMENTO
         (RstTMPLinVentaNuevosAcum.FINDFIRST) OR (RstTMPLinCompraAcum.FINDFIRST)
         OR (RstTMPLinVentaOrigAcum.FINDFIRST) //EX-SGG 040820
          THEN
            ERROR('Las variables temporales no deben contener registros');
    end;

    trigger OnPostReport()
    var
    begin

        MESSAGE('*** Proceso de desglose finalizado con éxito.*** \' + '\' + 'A continuación se ejecutará el informe para mostrar el detalle de dicho desglose'); //EX-SGG 040820
        COMMIT;
        SalesHeader.RESET;
        SalesHeader.SETRANGE("Document Type", SalesHeader."Document Type"::Order);
        SalesHeader.SETFILTER("No.", OrderFilter);

        LogOrders.SETTABLEVIEW(SalesHeader);
        LogOrders.RUNMODAL;
    end;
}