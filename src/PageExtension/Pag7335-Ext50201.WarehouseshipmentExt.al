/// <summary>
/// PageExtension WarehouseShipmentExt (ID 50201) extends Record Warehouse Shipment //7335.
/// </summary>
pageextension 50201 WarehouseShipmentExt extends "Warehouse Shipment" //7335
{
    layout
    {
        addbefore(Shipping)
        {
            group(Venta)
            {
                CaptionML = ENU = 'Sale', ESP = 'Venta';

                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell-to Customer Name field.';
                    Caption = 'Sell-to Customer Name';
                }
                field("Sell-to Customer Name 2"; Rec."Sell-to Customer Name 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell-to Customer Name 2 field.';
                    Caption = 'Sell-to Customer Name 2';
                }
                field("Sell-to Address"; Rec."Sell-to Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell-to Address field.';
                    Caption = 'Sell-to Address';
                }
                field("Sell-to Address 2"; Rec."Sell-to Address 2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell-to Address 2 field.';
                    Caption = 'Sell-to Address 2';
                }
                field("Envio a Mail"; Rec."Envio a Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell-to Mail field.';
                }
                field("Sell-to City"; Rec."Sell-to City")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell-to City field.';
                    Caption = 'Sell-to City';
                }
                field("Sell-to County"; Rec."Sell-to County")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Sell-to County field.';
                    Caption = 'Sell-to County';
                }
            }
        }
        addlast(Shipping)
        {
            group(GroupName)
            {
                Caption = 'GroupName';
            }
        }
        addlast(General)
        {
            field("Tipo de entrega"; Rec."Tipo de entrega")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tipo de entrega field.';
                Caption = 'Tipo de entrega';
            }
            field("Tipo origen"; Rec."Tipo origen")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Tipo origen field.';
                Caption = 'Tipo origen';
            }
            field("Cod. origen"; Rec."Cod. origen")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Cod. origen field.';
                Caption = 'Cod. origen';
            }
            field("Shipping No."; Rec."Shipping No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Shipping No. field.';
            }
            field("Pares Enviar"; Rec."Pares Enviar")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Pares Enviar field.';
                Caption = 'Pares Enviar';
            }
            field("Importe Envio"; ImpEnvio)
            {
                ApplicationArea = All;
                Caption = 'Importe Envio';
            }
        }
    }

    actions
    {
        addlast("&Shipment")
        {

            action("Atributos tto.Logistico")
            {

                Caption = 'Atributos ttos. Logisticos', comment = 'ESP="Atributos ttos. Logisticos"';
                ApplicationArea = all;

                RunObject = Page "Atributos tto. logistic. WMS";
                RunPageLink = Codigo = field("No.");
            }

        }
        addlast(Category_Category7)
        {

            actionref(Atributos_tto_Logistico_promoted; "Atributos tto.Logistico")
            { }
        }
    }

    trigger OnOpenPage()
    begin
        ImpEnvio := CalculateShipmentAmount(); //EX-SGG 161220
        IF rec."Cod Cliente" <> '' THEN
            rec."Cod. origen" := rec."Cod Cliente";
    end;


    trigger OnAfterGetRecord()
    begin

        //SF-JFC 181019 Sacar la validacion en el OnAfterGetRecord para que deje filtrar
        //SETRANGE("No.");
        //SF-JFC FIN 181019 Sacar la validacion en el OnAfterGetRecord para que deje filtrar
        //"Shipment Amount" := CalculateShipmentAmount; //EX-DRG-WMS 301020 //EX-SGG 161220 COMENTO
        ImpEnvio := CalculateShipmentAmount(); //EX-SGG 161220
        IF rec."Cod Cliente" <> '' THEN
            rec."Cod. origen" := rec."Cod Cliente";
    end;

    procedure CalculateShipmentAmount(): Decimal
    var

        WSLWMS: Record "Warehouse Shipment Line";
        PedidoVenta: Record "Sales Line";
        DevolucionCompra: Record "Purchase Line";
        Amount: Decimal;
    begin

        WSLWMS.RESET();
        WSLWMS.SETRANGE(WSLWMS."No.", rec."No.");
        IF WSLWMS.FIND('-') THEN BEGIN
            REPEAT
                WITH WSLWMS DO BEGIN
                    CASE WSLWMS."Source Document" OF
                        WSLWMS."Source Document"::"Sales Order":
                            BEGIN

                                PedidoVenta.RESET();
                                IF PedidoVenta.GET("Source Document", "Source No.", "Source Line No.") THEN
                                    Amount += PedidoVenta.Quantity * PedidoVenta."Unit Price" - PedidoVenta."Line Discount Amount";
                                    //Amount += PedidoVenta."Qty. to Ship" * PedidoVenta."Unit Price" - PedidoVenta."Line Discount Amount";
                            END;
                        WSLWMS."Source Document"::"Purchase Return Order":
                            BEGIN
                                DevolucionCompra.RESET();
                                IF DevolucionCompra.GET("Source Document", "Source No.", "Source Line No.") THEN
                                    Amount += Quantity * DevolucionCompra."Unit Price (LCY)" - DevolucionCompra."Line Discount Amount";
                            END;
                    END;
                END;
            UNTIL WSLWMS.NEXT() = 0;
        END;
        EXIT(Amount);
    end;





    var
        ImpEnvio: Decimal;
}