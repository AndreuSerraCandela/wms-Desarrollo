/// <summary>
/// Enum TipoOrigen (ID 50200).
/// </summary>
enum 50200 TipoOrigen
{
    Extensible = true;

    value(0; MyValue)
    {
        Caption = ' ', comment = 'ESP=" "';
    }
    value(1; Cliente)
    {
        Caption = 'Customer', comment = 'ESP="Cliente"';
    }
    value(2; Proveedor)
    {
        Caption = 'Supplier', comment = 'ESP="Proveedor"';
    }
}