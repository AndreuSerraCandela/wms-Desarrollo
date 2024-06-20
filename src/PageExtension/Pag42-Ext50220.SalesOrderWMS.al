pageextension 50220 SalesOrderWMS extends "Sales Order" //42
{
    layout
    {
        addafter("Sell-to Address 2")
        {
            field("Envio a Mail"; Rec."Envio a Mail")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Sell-to Mail field.';
            }

        }
        addafter("Cust. Bank Acc. Code")
        {
            field("Proposicion Venta"; Rec."Proposicion Venta")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Proposicion Venta field.';
            }

            field("Tipo de Entrega"; Rec."Tipo de Entrega")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tipo de entrega field.';
            }
            field("Shipment Type Name"; Rec."Shipment Type Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the value of the Shipment Type Name field.';
            }

        }
        addafter("Origen del pedido")
        {
            field("Pedido venta original"; Rec."Pedido venta original")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pedido venta original field.', comment = 'ESP="Pedido venta original"';
            }

            field("Tipo Servicio"; Rec."Tipo Servicio")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Service Type field.', comment = 'ESP="Especifique el tipo de servicio"';
            }

        }

        moveafter("Shipment Type Name"; "Location Code")
    }

    actions
    {
        addlast("F&unctions")
        {

            action("Create Whse. Shipment")
            {


                Caption = 'Create Whse. Shipment All Order', comment = 'ESP="Crear envio alm. Total Pedido"';
                ApplicationArea = All;
                Image = Receipt;
                ToolTip = 'Create Whse. Shipment', comment = 'ESP="Crear envio almacén Total Pedido"';

                trigger OnAction()
                var
                    // GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound WMS";
                begin
                    GetSourceDocOutbound.CreateFromSalesOrder(rec);
                    IF NOT rec.FIND('=><') THEN
                        rec.INIT;
                end;
            }
            action("Crear envio almacén cantidad a enviar")

            {
                Caption = 'Create Whse. Shipment Qty. to ship', comment = 'ESP="Crear envio alm. cantidad a enviar"';
                ApplicationArea = All;
                Image = Receipt;
                ToolTip = 'Create Whse. Shipment Qty. to ship', Comment = 'ESP="Crear envio almacén cantidad a enviar"';

                trigger OnAction()
                var
                    //GetSourceDocInbound: Codeunit 50403;
                    // GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                    // GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound WMS";

                begin
                    //TODO > VERO > WMS OJO CREAR LA CODEUNIT 50404Get Source Doc. Outbound WMS POR CULPA DE ESTA FUNCION EnvioAlmacenCantidadAEnviar
                    // GetSourceDocInbound.ReciboAlmacenCantidadRecibida(TRUE);
                    GetSourceDocOutbound.EnvioAlmacenCantidadAEnviar(TRUE);
                    GetSourceDocOutbound.CreateFromSalesOrder(rec);

                    IF NOT rec.FIND('=><') THEN
                        rec.INIT;
                end;
            }


            action("Ver asignacion")
            {
                Caption = 'Ver asignacion', comment = 'ESP="Ver asignacion"';
                ApplicationArea = All;
                Image = ViewPage;
                ToolTip = 'Executes the Ver asignacion action.', comment = 'ESP="Ejecuta la acción de Ver asignacion"';

                trigger OnAction()
                var

                begin

                    pTmp.RESET;
                    pTmp.SETRANGE(pTmp.Proceso, 'D-ASIGNA');
                    pTmp.SETRANGE(pTmp.usuario, USERID);
                    pTmp.DELETEALL;

                    COMMIT;

                    x := 0;
                    pLinea.RESET;
                    pLinea.SETRANGE(pLinea."Document Type", pLinea."Document Type"::Order);
                    pLinea.SETRANGE(pLinea."Document No.", REC."No.");
                    pLinea.SETRANGE(pLinea."Asignacion Directa", TRUE);
                    IF pLinea.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            x += 1;

                            pTmp.INIT;
                            pTmp.Proceso := 'D-ASIGNA';
                            pTmp.usuario := USERID;
                            pTmp."Clave 1" := pLinea."Document No.";
                            pTmp."Clave 2" := FORMAT(pLinea."Line No.");
                            pTmp."Clave 3" := pLinea."No.";
                            pTmp."Clave 4" := FORMAT(x);
                            pTmp."Clave 5" := USERID;
                            pTmp.Color := pLinea."PfsVertical Component";
                            pTmp.Talla := pLinea."PfsHorizontal Component";
                            pTmp."Fecha servicio confirmada" := pLinea."Fecha servicio confirmada";
                            //  pTmp."Prepack Code" := pLinea."PfsPrepack Code";
                            pTmp."Asignación Directa" := TRUE;
                            pTmp."Pedido de Compras 1" := pLinea."Cod. Pedido Compra";
                            pTmp.INSERT;
                        UNTIL pLinea.NEXT = 0;

                    pLinea.RESET;
                    pLinea.SETRANGE(pLinea."Document Type", pLinea."Document Type"::Order);
                    pLinea.SETRANGE(pLinea."Document No.", REC."No.");
                    IF pLinea.FINDSET(FALSE, FALSE) THEN
                        REPEAT
                            IF (pLinea."Cantidad Asignada Stock" <> 0) OR (pLinea."Cantidad Asignada Compras" <> 0) THEN BEGIN
                                x += 1;
                                pTmp.INIT;
                                pTmp.Proceso := 'D-ASIGNA';
                                pTmp.usuario := USERID;
                                pTmp."Clave 1" := pLinea."Document No.";
                                pTmp."Clave 2" := FORMAT(pLinea."Line No.");
                                pTmp."Clave 3" := pLinea."No.";
                                pTmp."Clave 4" := FORMAT(x);
                                pTmp."Clave 5" := USERID;
                                pTmp.Color := pLinea."PfsVertical Component";
                                pTmp.Talla := pLinea."PfsHorizontal Component";
                                pTmp."Fecha servicio confirmada" := pLinea."Fecha servicio confirmada";
                                // pTmp."Prepack Code" := pLinea."PfsPrepack Code";
                                pTmp."Asignación Directa" := FALSE;
                                pTmp."Asignación Automática" := TRUE;
                                pTmp."Cantidad Asignada a Stock" := pLinea."Cantidad Asignada Stock";
                                pTmp."Cantidad Asignada a Compras" := pLinea."Cantidad Asignada Compras";
                                pTmp.INSERT;

                                n := 0;
                                //EX-SGG 260716 COMENTO.
                                // { CNM-001 DES-COMENTO Y ARREGLO:
                                pAsignaciones.RESET; // pAsignar.RESET;
                                pAsignaciones.SETRANGE("Nº Pedido Venta", pLinea."Document No.");   // pAsignar.SETRANGE(pAsignar."Pedido Venta No."...
                                pAsignaciones.SETRANGE("Nº Linea Pedido Venta", pLinea."Line No."); // pAsignar.SETRANGE(...
                                pAsignaciones.SETRANGE("Tipo Asignación", pAsignaciones."Tipo Asignación"::Compra);
                                IF pAsignaciones.FINDSET(FALSE, FALSE) THEN
                                    REPEAT
                                        n += 1;
                                        CASE n OF
                                            1:
                                                BEGIN
                                                    pTmp."Pedido de Compras 1" := pAsignaciones."Nº Pedido Compra";
                                                    pTmp."Pedido de Compras 1 Qty" := pAsignaciones."Cantidad Asignada";
                                                END;
                                            2:
                                                BEGIN
                                                    pTmp."Pedido de Compras 2" := pAsignaciones."Nº Pedido Compra";
                                                    pTmp."Pedido de Compras 2 Qty" := pAsignaciones."Cantidad Asignada";
                                                END;
                                            3:
                                                BEGIN
                                                    pTmp."Pedido de Compras 3" := pAsignaciones."Nº Pedido Compra";
                                                    pTmp."Pedido de Compras 3 Qty" := pAsignaciones."Cantidad Asignada";
                                                END;
                                            4:
                                                BEGIN
                                                    pTmp."Pedido de Compras 4" := pAsignaciones."Nº Pedido Compra";
                                                    pTmp."Pedido de Compras 4 Qty" := pAsignaciones."Cantidad Asignada";
                                                END;
                                        END;
                                    UNTIL pAsignaciones.NEXT = 0;
                                pTmp.MODIFY;
                                // } FIN DE CMN-001
                                //FIN EX-SGG
                            END;
                        UNTIL pLinea.NEXT = 0;

                    COMMIT;

                    pTmp.RESET;
                    pTmp.SETRANGE(pTmp.Proceso, 'D-ASIGNA');
                    pTmp.SETRANGE(pTmp.usuario, USERID);
                    IF pTmp.FINDFIRST THEN
                        PAGE.RUNMODAL(50070)
                    ELSE
                        ERROR('No se han encontrado líneas asignadas');
                end;
            }

            action("Atributos tto. logistico")
            {
                Caption = 'Atributos tto. logístico', comment = 'ESP="Atributos tto. logístico"';
                ApplicationArea = All;
                Image = Action;
                ToolTip = 'Executes the Atributos tto. logístico action.', comment = 'ESP="Ejecuta la acción de Atributos tto. logístico"';
                //  Promoted = true;
                // PromotedCategory = Category8;

                // //TODO ESPERANDO ALMACENES mirar runpagelink
                RunObject = Page "Atributos tto. logistic. WMS";
                // RunPageLink = sorting("Tipo documento", Codigo, "Codigo atributo") ORDER(Ascending) WHERE("Tipo documento"=CONST(Pedido));

            }




        }


        addfirst(Category_Category8)
        {
            actionref("Atributos tto. logistico_promoted"; "Atributos tto. logistico")
            { }
        }
        addfirst(Category_Category11)
        {
            actionref("Create Whse. Shipment_promoted"; "Create Whse. Shipment")
            { }
            actionref("Crear envio almacén cantidad a enviar_promoted"; "Crear envio almacén cantidad a enviar")
            { }

        }
        modify(Release1)
        {
            trigger OnBeforeAction()
            begin
                rec.CalcFields("Proposicion Venta");
                if rec."Proposicion Venta" then
                    ERROR('Pedido en proposición de venta');

            end;
        }


    }



    trigger OnAfterGetRecord()
    var
        pt_CodigosWS: Record "Relacion Ped. WS";
    begin
        //SF-IMF 25/06/2014: Para que cargue el nº de pedido externo en pedidos procedentes de WebServices        
        pt_CodigosWS.Reset();
        pt_CodigosWS.SetRange(CodPedido, rec."No.");
        If pt_CodigosWS.FindFirst() Then
            WS_ExternalCode := pt_CodigosWS.CodExterno
        Else
            WS_ExternalCode := '';

        Rec.CalcFields("Shipment Type Name");  //EX-DRG-WMS 301020
    end;


    var

        RSales: Record "Sales Line";
        WS_ExternalCode: Code[20];
        pAsignaciones: Record "Asignaciones Vtas-Compras";
        pTmp: Record 50003;
        pLinea: Record "Sales Line";
        n: Integer;
        x: Integer;

}
