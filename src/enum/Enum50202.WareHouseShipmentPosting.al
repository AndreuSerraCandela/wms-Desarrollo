/// <summary>
/// Enum WareHouseShipmentPosting (ID 50202).
/// </summary>
enum 50202 WareHouseShipmentPosting
{
    Extensible = true;

    value(0; MyValue)
    {
        Caption = 'MyValue';
    }
    value(1; Optional)
    {
        Caption = 'Optional', comment = 'ESP="Opcional"';
    }
    value(2; Always)
    {
        Caption = 'Always', comment = 'ESP="Siempre"';
    }
}