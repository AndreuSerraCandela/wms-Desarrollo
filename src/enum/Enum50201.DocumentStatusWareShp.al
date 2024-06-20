/// <summary>
/// Enum DocumentStatusWareShp (ID 50201).
/// </summary>
enum 50201 DocumentStatusWareShp
{
    Extensible = true;

    value(0; MyValue)
    {
        Caption = 'MyValue';
    }
    value(1; "Partially Picked")
    {
        CaptionML = ENU = 'Partially Picked',
                    ESP = 'Picking parcial';
    }
    value(2; "Partially Shipped")
    {
        CaptionML = ENU = 'Partially Shipped',
                    ESP = 'Enviado parcial';
    }
    value(3; "Completely Picked")
    {
        CaptionML = ENU = 'Completely Picked',
                    ESP = 'Picking completo';
    }
    value(4; "Completely Shipped")
    {
        CaptionML = ENU = 'Completely Shipped',
                    ESP = 'Enviado completo';
    }
    value(5; "Enviado SEGA")
    {
        CaptionML = ENU = 'Enviado SEGA',
                    ESP = 'Enviado SEGA';
    }
}

//Warehouse Shipment Header WMS
//OptionCaption = ' ,Partially Picked,Partially Shipped,Completely Picked,Completely Shipped,Enviado SEGA';
//,Picking parcial,Enviado parcial,Picking completo,Enviado completo,Enviado SEGA