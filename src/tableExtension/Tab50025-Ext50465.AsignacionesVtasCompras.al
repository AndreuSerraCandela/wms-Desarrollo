// /// <summary>
// /// Table Asignaciones Vtas-Compras (ID 50025).
// /// </summary>


tableextension 50465 AsignacionesVtasCompras extends "Asignaciones Vtas-Compras" //50025
{
    fields
    {
        // TODO WMS VERO
        field(9; "Tipo Asignación"; Option)
        {
            Caption = 'Tipo Asignación';
            OptionMembers = Compra,Stock,Directa;
            OptionCaption = 'Compra,Stock,Directa', comment = 'ESP="Compra,Stock,Directa"';
        }
    }

}
