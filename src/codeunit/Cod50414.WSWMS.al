codeunit 50414 "WS WMS"
{

    var
        RstControl: Record "Control integracion WMS";
        CduFWMS: Codeunit FuncionesWMS;

    procedure WS_ActualizarEstadoSEGA(var lTipoIntegracion: Text[2]; var lNoDocumento: Code[20]; var lValor: Text[30]; var lMensajeError: Text[250]; var lNumMensaje: Code[25])
    begin
        //EX-SGG-WMS 210619
        IF (lTipoIntegracion = '') OR (lNoDocumento = '') THEN
            ERROR('Debe especificar un Tipo de integración y un Nº de documento');
        RstControl.RESET;
        RstControl.SETCURRENTKEY(Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA", "Numero de mensaje SEGA");
        CASE lTipoIntegracion OF
            'OE':
                RstControl.SETRANGE(Interface, RstControl.Interface::"OE-Orden de Entrada");
            'PE':
                RstControl.SETRANGE(Interface, RstControl.Interface::"PE-Pedido");
            ELSE
                ERROR('Solo puede actualizar Tipos de integración "OE" o "PE"');
        END;
        RstControl.SETRANGE("No. documento", lNoDocumento);
        RstControl.SETRANGE("Numero de mensaje SEGA", lNumMensaje); //EX-SGG-WMS 170719
        RstControl.FINDFIRST;
        CASE lValor OF
            '0':
                BEGIN
                    RstControl.VALIDATE("Estado SEGA", RstControl."Estado SEGA"::"Numero mensaje desconocido");
                    CduFWMS.InsertarRegistroLOG(RstControl, TRUE, 'Número de mensaje desconocido');
                END;
            '1':
                RstControl.VALIDATE("Estado SEGA", RstControl."Estado SEGA"::"En proceso");
            '2':
                BEGIN
                    RstControl.VALIDATE("Estado SEGA", RstControl."Estado SEGA"::Error);
                    CduFWMS.InsertarRegistroLOG(RstControl, TRUE, lMensajeError);
                END;
            '3':
                RstControl.VALIDATE("Estado SEGA", RstControl."Estado SEGA"::Importado);
        END;
        RstControl.VALIDATE("Fecha y hora ult. resp. SEGA", CURRENTDATETIME);
        RstControl.MODIFY(TRUE);
    end;



    procedure WS_ExisteRegControlProcesado(var lTipoIntegracion: Text[2]; var lNumMensaje: Code[25]): Boolean
    begin
        //EX-SGG 170221 QUITO PARAMENTROS lNoDocumento code[20] Y lIdSEGA Integer.
        //EX-SGG 160221
        IF (lTipoIntegracion = '') OR (lNumMensaje = '') THEN
            ERROR('Debe especificar un Tipo de integración y un Numero de mensaje');
        //EX-SGG 170221 NO NECESARIO
        /*
        IF (lTipoIntegracion IN ['CE','CS']) AND ((lNoDocumento='') OR (lIdSEGA=0)) THEN
         ERROR('Debe especificar un Número de documento y un Id SEGA cuando el Tipo de integración es '+lTipoIntegracion);
        */
        RstControl.RESET;
        RstControl.SETCURRENTKEY(Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA", "Numero de mensaje SEGA");
        CASE lTipoIntegracion OF
            'CS':
                BEGIN
                    RstControl.SETRANGE(Interface, RstControl.Interface::"CS-Confirmacion de Salida");
                    RstControl.SETRANGE("Tipo documento", RstControl."Tipo documento"::"Envio almacen");
                    //    RstControl.SETRANGE("No. documento",lNoDocumento); //EX-SGG 170221 NO NECESARIO
                    //    RstControl.SETRANGE("Id. SEGA",lIdSEGA); //EX-SGG 170221 NO NECESARIO
                END;
            'CE':
                BEGIN
                    RstControl.SETRANGE(Interface, RstControl.Interface::"CE-Confirmacion de Entrada");
                    RstControl.SETRANGE("Tipo documento", RstControl."Tipo documento"::"Recepcion almacen");
                    //    RstControl.SETRANGE("No. documento",lNoDocumento); //EX-SGG 170221 NO NECESARIO
                    //    RstControl.SETRANGE("Id. SEGA",lIdSEGA); //EX-SGG 170221 NO NECESARIO
                END;
            'AS':
                BEGIN
                    RstControl.SETRANGE(Interface, RstControl.Interface::"AS-Ajuste de Stock");
                    RstControl.SETRANGE("Tipo documento", RstControl."Tipo documento"::Stock);
                END;
            'SA':
                BEGIN
                    RstControl.SETRANGE(Interface, RstControl.Interface::"SA-Stock Actual");
                    RstControl.SETRANGE("Tipo documento", RstControl."Tipo documento"::Stock);
                END
            ELSE
                ERROR('Tipo de intergación debe ser CS,CE,AS o SA');
        END;

        RstControl.SETFILTER(Estado, '<>' + FORMAT(RstControl.Estado::Pendiente));
        RstControl.SETRANGE("Numero de mensaje SEGA", lNumMensaje);
        EXIT(RstControl.FINDFIRST);

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::Funciones, 'OnBeforeModifyTemporalRecMod', '', false, false)]
    local procedure OnBeforeModifyTemporalRecMod(var SalesLine: Record "Sales Line"; var TemporalRecMod: Record TemporalForms)
    begin

        // LinVentaRec.CALCFIELDS("Cant. envios lanzados");
        // TemporalRec."Cantidad Envios" := LinVentaRec."Cant. envios lanzados";
        //EX-JFC-WMS FIN 110919 Meter el campo Cantidad Envios.      
        SalesLine.CalcFields(SalesLine."Cant. envios lanzados");
        //  TemporalRecMod."Cantidad_Envios" := SalesLine."Cant. envios lanzados";


    end;

  

   

  
}