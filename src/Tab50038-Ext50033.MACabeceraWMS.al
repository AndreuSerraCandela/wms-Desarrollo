// tableextension 50229 MACabeceraWMS extends MACabecera// MACabecera //50038
// {
//     fields
//     {
       
//         field(50400; "Ref. Devolucion"; Code[20])
//         {
//             Caption = 'Ref. Devolución';
//             Description = 'EX-SGG-WMS 280619';
//             TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST("Return Order"),"Sell-to Customer No." = FIELD("Recoger a-Cód. Cliente"));
//         }
//     }
// }
