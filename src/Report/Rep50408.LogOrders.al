/// <summary>
/// Report Log Orders (ID 50408).
/// </summary>
report 50408 "LogOrders"
{
    ApplicationArea = All;
    Caption = 'Log Orders', comment = 'ESP="Log Orders"';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");

            RequestFilterFields = "Document Type", "No.";


            column(No_; "No.")
            {

            }
            column(Fecha_Orden_asignacion; "Fecha Orden asignacion")
            {

            }
            column("Nº_Matricula"; "Nº Matricula")
            {

            }

            column(Format; FORMAT(TODAY, 0, 4))
            {

            }
            column(TIME; TIME)
            {

            }
            column(USERID; USERID)
            {

            }

            column(vCantTotal; vCantTotal)
            {

            }

            dataitem("Sales Header2"; "Sales Header")
            {
                DataItemTableView = SORTING("Document Type", "No.");
                DataItemLink = "Document Type" = FIELD("Document Type"), "Pedido venta original" = FIELD("No.");


                column(No_2; "No.")
                {

                }

                dataitem("Sales Line"; "Sales Line")
                {

                    DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                    DataItemLink = "Document No." = FIELD("No."), "Document Type" = FIELD("Document Type");


                    column(No_SalesLine; "No.")
                    {

                    }
                    column(Description; Description)
                    {

                    }
                    column(Variant_Code; "Variant Code")
                    {

                    }
                    column("PfsOrderQuantity"; "PfsOrder Quantity")
                    {

                    }
                    column(Fecha_servicio_confirmada; "Fecha servicio confirmada")
                    {

                    }
                    //TODO
                    // column(PfsBrand;PfsBrand)
                    // {

                    // }
                    column(Asignacion_Directa; "Asignacion Directa")
                    {

                    }
                    column(vTotalPedido; vTotalPedido)
                    {

                    }


                    trigger OnAfterGetRecord()
                    var
                    begin

                        if "Sales Line"."Asignacion Directa" then
                            vTotalPedido += "Sales Line"."PfsOrder Quantity";

                        vCantTotal += vTotalPedido;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                begin
                    vTotalPedido := 0;
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    var
        vTotalPedido: Integer;
        vCantTotal: Integer;

}
