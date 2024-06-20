codeunit 50409 "Funciones WMS"
{
    // EX-SGG 120619 NUEVAS FUNCIONES
    //        130619 INCLUYO PE-PEDIDOS, CS-CONFIRMACION DE SALIDAS, AS-AJUSTES DE STOCK, SA-STOCK ACTUAL
    //        170619 FUNCION ProcesarRegistrosControl
    //        180619 FUNCIONES InsertarRegistroLOG,UltimoNumeroRegistroLOG,VisualizarLOGRegistroControl. CODIGO CONTROL LOG DE ERRORES.
    //               FUNCION ComunicarWSRegistrosControl
    //               UN REGISTRO CONTROL POR DOCUMENTO EN CE-CONFIRMACION ENTRADAS, ObternerDatos, ProcesarRegistrosControl
    //        200619 NUEVA FUNCION CompruebaCantidadSEGAvsNAV Y CODIGO REFERENCIA. PROCESAMIENTO DE CS-CONFIRMACION DE SALIDAS.
    //               NUEVA FUNCION InsertarEnRegistroControl. CODIGO REFERENCIA.
    //        210619 NUEVA FUNCION AnalizarRespuestaWS. WS_ActualizarEstadoSEGA
    //        240619 TRASPASO FUNCION WS_ActualizarEstadoSEGA A NUEVA CODEUNIT 50414 WS WMS EXCLUSIVA PARA LA PUBLICACION DE WS
    //        260619 ACTUALIZAR ESTADO DOCUMENTO DEL ENVIO Enviado SEGA EN ComunicarWSRegistrosControl.
    //               ProcesarRegistrosControl PARA AS. FUNCIONES ObtenerCodigoArticuloERP,CompruebaCantProdYVar,
    //                ObtenerAlmacenPpalEstadosSEGA
    //        270619 ProcesarRegistrosControl PARA SA. FUNCIONES CopiarAtributosTtoLogistico,EsAlmacenSEGA.
    //               CODIGO PARA CONTEMPLAR DEVOLUCION DE VENTA EN INTERFACE OE.
    //        280618 FUNCION ComprobarUsuarioSiProductoSEGA. TRATAMIENTO VARIOS ALMACENES CON MISMO ESTADO CALIDAD SEGA Y
    //                MISMO TIPO STOCK SEGA. FUNCION ObtenerFiltroAlmacenesSEGA
    //        010719 FILTROS PARA motivoAjuste EN MENSAJE AS
    //        020719 FUNCION CompruebaProdAlmSEGAImaginario LLAMADA DESDE VALIDACIONES CAMPOS SALES/PURCHASE LINE
    //               FUNCIONES EsProductoSEGA,EnviarASEGA PARA CONTROL LINEAS REMITIDAS A SEGA
    //               USO DE RSTOE EN ProcesarRegistrosControl-CE PARA DETERMINAR Nº DE LINEAS Y SI FUE ENVIADA A SEGA.
    //               USO DE RSTPE EN ProcesarRegistrosControl-CS PARA DETERMINAR Nº DE LINEAS Y SI FUE ENVIADA A SEGA.
    //        030719 FUNCIONES ValidarEstadoRegistroControl,CompruebaNoIntegradosPreviosSA
    //               INCORPORACION DE numeroMensaje EN AS.
    //        040719 AGRUPACIONES REGISTROS CONTROL PARA AS Y SA POR numeroMensaje (Numero de mensaje SEGA)
    //               NUEVAS FUNCIONES ComprobacionesPreviasASySA,IntentaRegDiarioProductoASySA
    //        110719 CAMBIO CODIGO EN InsertarRegistroOE PARA OBTENER VALOR DE tipoOrdenEntrada SEGUN CAMPO CABECERA.
    //               tipoOrigen EN PE Y OE. COMPLETAR codigoentregaerp,lineaentregaerp,cantidadlineaentregaerp EN OE.
    //        150719 CORRECCIONES. NUEVA FUNCION EliminaTagsVaciosFicheroXML. REF VARIABLE RstAsignacionDirecta A TBL50025
    //        160719 USO NUEVOS CAMPOS "No. serie mensaje SEGA PE" Y "No. serie mensaje SEGA OE".
    //               USO "Numero de mensaje SEGA" EN ComunicarWSRegistrosControl PARA <int:numMensaje>
    //        170719 FUNCION ObtenerValorAtributosTtoLogist. CODIGO LLAMADA EN InsertarRegistroPE. GESTION ECI EN REGISTRO PE.
    //               DIVERSOS CAMBIOS ULTIMO ANALISIS EN REGISTRO PE.
    //        180719 NUEVA FUNCION GenerarEnviosMAGENTO()
    //        190719 NUEVAS FUNCIONES ReobtenerDatos,EliminarRegistrosOE,EliminarRegistrosPE
    //        220719 COMPLETO FUNCION ReobtenerDatos.
    //        230719 CORRECCIONES.
    //        300719 ASIGNACION DE NUEVOS CAMPOS direccionCliente2 Y direccionRecepctor2 EN PE.
    // EX-OMI 080819 Correccion
    // EX-SGG 280819 CORRECCION EN InsertarRegistroLOG() Y ObtenerCodigoArticuloERP()
    //               SETCURRENTKEY PARA RSTCE POR CAMBIO DE CLAVE PRIMARIA.
    //               DIVERSAS NUEVAS COMPROBACIONES EN ProcesarRegistrosControl PARA MENSAJE CE.
    //               NUEVA FUNCION AgruparRegistrosCE
    //        290819 CAMBIO ESPACIO DE NOMBRES EN ComunicarWSRegistrosControl DE int A tec. CAMBIO VALOR CONSTANTE lSOAPActionTXT
    //               INCLUYO COMMIT ANTES DE IF <CODEUNIT>.RUN NECESARIO. SetUpnewLine PARA MENSAJE AS.
    //        020919 NUEVA FUNCION DevuelveAlmacenPredetSEGA. CORRECCIONES.
    //        040919 CAMBIO REFERENCIA VARIABLES LOCALES lCduRegRecep DE 50405 A 50410 Y lCduRegEnv DE 50411 A 50412. AGREGO
    //                 CODIGO PARA ESTABLECER PARAMETROS EN REGISTRO DE ENVIOS ALMACEN.
    //        050919 CAMBIO EN NavegarRegistroControl PARA HACERLO POR "No." EN REGISTRADOS AL HEREDAR "No." DE BORRADOR.
    //        060919 COMENTO CODIGO EN CompruebaCantProdYVar().
    //               EXCLUIR ALM. IMAGINARIOS EN ObtenerFiltroAlmacenesSEGA()
    //               ALMACENES IMAGINARIOS NO SON CONSIDERADOS SEGA.
    //        110919 NUEVA FUNCION EliminarAtributosTtoLogistico(). CAMPO ALMACENES Imaginario RENOMBRADO A Stock no gestionado por SEGA
    //        120919 SETCURRENTKEY PARA CS POR CAMBIO EN CLAVE PPAL.
    //               NUEVAS FUNCIONES AgruparRegistrosCS, CrearEmbalajesEDIdesdeCS. TRATAMIENTO DE REGISTROS AGRUPADOS EN PROCESAMIENTO
    //                DE MENSAJE CS.
    //        130919 ACTUALIZAR Posting Date ANTES DE REGISTRO MENSAJES CE, CS. VALIDAR Qty. to ship EN PROCESAMIENTO DE CS.
    //        170919 EVITO TRIGER MODIFY/DELETE AL PROCESAR MENSAJE CS CON FUNCOION SaltarComprobacionEnviadoASEGA.
    //               GESTION A TRAVES DEL SERVICIO NAS CON LAS NUEVAS OPCIONES CREADAS EN CONFIGURACION DE ALMACEN.
    //        180919 AGREGO PARAMETRO A FUNCION GenerarEnviosMAGENTO. GESTION GENERAR ENVIO 1 A 1 DESDE CDU 50008.
    //        190919 CODIGO PARA INFORMAR EN REGISTRO PE DATOS xxxxCliente CON LAS SUCURSALES EN ECI.
    //        200919 COMPROBAR PRODUCTO SEGA EN ComprobacionesPreviasASySA()
    //        300919 MAXSTRLEN EN InsertarRegistroPE, CAMPOS PROVINCIAx
    //        011019 MUEVO CODIGO PARA ESTABLECER PfsSetSuspendDeleteCheck EN MENSAJE CS.
    //        071019 INFORMO DE telefonoReceptor EN REGISTRO PE.
    //        181019 COMENTO CODIGO ERROR EN CrearEmbalajesEDIdesdeCS. EN SU LUGAR, DELETEALL.
    // EX-SMN 181019 En la función ReobtenerDatos, si tipo distinto a OE o PE modificar el estado a pendiente
    // EX-SMN 231019 Corrección cómo se informa el campo "Embalaje nivel 2" en las líneas de embalaje de nivel 3 por no venir ordenados
    // EX-SGG 241019 CORRECCIONES.
    //        281019 ESTABLECER numeroMensaje COMO "Document No." EN LINEA DIARIO MENSAJE AS.
    //        301019 CORRECCIONES SETFILTER X SETRANGE MENSAJE SA.
    //        311019 sethidevalidationdialog EN MENSAJE SA. NUEVA FUNCION DocumentoEliminadoEnSEGA().
    //        071119 TRATAMIENTO DE CS Y CE SOLO CUANDO EXISTA MARCA DE CIERRE.
    //        181119 VALIDAR CANTIDAD A RECIBIR EN CE.
    //        271119 MODIFICACION EN ProcesarRegistrosControl PARA MENSAJE SA. REGISTRAR SECCION COMPLETA DESCARTANDO SKU CON ERRORES.
    //        281119 Sell-to County EN InsetarRegistroPE.
    //        291119 NUEVAS FUNCIONES EsLineaAsignacionDirecta,ExistenLinsAsignacionDirecta. CODIGO REFERENCIA.
    //        021219 TRATAMIENTO PEDIDOS MAGENTO Y telefonoReceptor EN InsetarRegistroPE.
    //               CORRECCION EN InsertarRegistroOE
    //        051219 CORRECCION EN InsertarRegistroOE ASIGNACIONES DIRECTAS.
    // EX-OMI 101219 modificacion codigoEntregaERP = locrec_WHshipmentline."No." en vez de SKU y
    //                            lineaEntregaERP = locrec_WHshipmentline."Line No." en vez linea venta
    // EX-SGG 181219 REPEAT UNTIL POR MAL FUNCIONAMIENTO MODIFYALL EN VALIDARESTADOREGISTROCONTROL.
    //               MOD EN CompruebaNoIntegradosPreviosSA() PARA SOLO CONSIDERAR CS Y CE.
    //        191219 INCLUIR PRODUCTOS NO SEGA EN ENVIO A SEGA DESDE ENVIOS Y RECEPCIONES ALMACEN.
    //               CORRECCION EN PROCESAR MENSAJE SA PARA INCLUIR LINEA ALM PPAL SI NO EXISTE.
    //        231219 CORRECCIONES PARA TENER EN CUENTA ALMACENS EN MENSAJE SA POR CLASE STOCK Y CALIDAD.
    //        261219 CORRECCIONES EN ELIMINACION DE REGISTROS DE CUADRO CONTROL.
    // EX-SGG 240120 CORRECCION EN ASIGNACCIÓN DIFERENCIA CANTIDADES EN PROCESAMIENTO SA. (Instalado 13/04)
    // EX-SGG 280120 CODIGO EN EliminarRegistroControl() PARA GUARDAR LOG ELIMINACIÓN.    (Instalado 13/04)
    //        040220 NUEVA FUNCION DescartarRegistrosPrevios() Y CODIGO REFERENCIA PROCESAR REGISTROS SA. (Instalado 17/04)
    //        050220 ESTABLECED VALOR EN CAMPO idiomaDocumentacion InsertarRegistroPE. (Instalado 27/04)
    //        070220 MODIFICACION PARA INSERTAR REGISTRO PE SIN LINEAS EN EL CASO DE ALMACEN RETIRADOS.
    //        170420 CONTROL EXISTEN LINEAS EN INTEGRACION MENSAJE SA. MODIFICACION IntentaRegDiarioProductoASySA PARA REALIZAR
    //                REGISTRO COMPLETO SECCIÓN DIARIO EN SA.
    //        270420 CORRECCION REFERENCIA VARIABLE EN DescartarRegistrosPrevios().
    //        280420 CORRECCION CREACION DE REGISTRO PE PARA PRODUCTO RETIRADO.
    //        060520 REESTABLECER VARIABLES EN REPORT CALCULO INVENTARIO TRATAMIENTO MENSAJE SA.
    //        020620 ESTABLECER lineaentregaERP EN CS PRODUCTO RETIRADO (SINLINEA) (Instalado 24/09)
    //        040620 CORRECCION TENER EN CUENTA lCSSinNumLinea. (Instalado 05/10)
    //        040620 PROCESAMIENTO DE MENSAJES AS CON MOTIVO 26. (Instalado 24/08)
    //        290620 OBTENER REGISTRO CABECERA CON INFORMACIÓN ACTUALIZADA.
    //        300620 ELIMINACION DE LINEAS EN AS MOTIVO 26 SI NO SE ENCUENTRAN EN AS. VALIDACION CAB POSTING DATE. (Instalado 24/08)
    //        140720 REPEAT UNTIL POR MAL FUNCIONAMIENTO MODIFYALL EN VALIDARESTADOREGISTROCONTROL.
    //        170720 ABRIR/LANZAR CAB COMPRA EN TRATAMIENTO AS MOTIVO 26 DEVOLCIONES. (Instalado 24/08)
    //        140920 CAMBIO SIGNO CANTIDADES EN AgruparRegistrosASDevolCompras(). (Instalado 05/10)
    //        280920 AMPLIAR COMPROBACIONES DE CANTIDADES PARA IDENTIFICAR DISTINTO SIGNO EN CompruebaCantidadSEGAvsNAV() (Instalado 05/10)
    //        161220 MODIFICACIONES EN FUNCION ComprobarUsuarioSiProductoSEGA() PARA PERMITIR PRODUCTO SEGA, USUARIO NO SEGA.
    // EX-DRG 110321 Nueva funcion para ejecutar procedimiento almacenado de SQL (PreObtenerSASQL)
    // EX-SGG 280720 (PARCIALMENTE) permitir cantidad 0 en SA (CompruebaCantProdYVar)
    // 20210916-NM-CSA Completa EX-SGG 280720 para permitir cantidad 0 en SA (CompruebaCantProdYVar)
    // EX-DRG 280921 Nueva funcion para borrar lineas con cantidad 0
    //               Modificamos intenta reg diario para que primero elimine las lineas con cantidad a 0
    // EX-DRG 141021 Contamos las lineas del diario para que solo cuando sea 1 o mayor registre y nos evitamos el error
    // EX-DRG 191021 Metemos un commit para cerrar la transaccion del diario y evitar el error, en caso de que no funcione leer comentariO
    //               de EX-DRG 141021
    // 
    // ************************
    // VARIOS TO-DO
    // 
    // NM-CSA-191205 función EliminadoEnSEGA()
    //  - Añadir comprobación de que no hay CE o CS para ese documento.
    //  - No obligar a que el estado sea error, aunque sí pedir confirmación extra.
    // 
    // NM-CSA-200410 Cambios para nuevo tipo OE 4 de "devolución completa". Cambios en InsertarRegistroOE()
    // //SF-JFC 150921 buscar el pedido de venta solo si la linea es de pedido
    // //SF-JFC 081121 buscar el pedido de venta si el envio proviene de un pedido transferencia en consignacion
    // //EX-CV  -  2021 12 14
    // //EX-CV  -  JX  -  2021 12 23 Cambio procesado mensaje CS en caso de Venta en consignación
    // EX-RBF 040122 Marcar obtenido individualmente en lugar de todos los registros.
    //        110422 tmp_RstCabRecepAlm temporary = Yes.
    //        200522 Control al insertar registro PE u OE en control integracion.
    // EX-SGG 250722 ESTABLECER Obtenido POR NO. DOCUMENTO EN ObtenerDatos() PARA CE Y CS.
    // NM-CSA-220803 03/08/22 HOTFIX para error generación PE concatenando con EMAIL (guardado en "Envío-a Nombre 2")
    //               Sabemos que en B2C el "Envío-a Nombre 2" almacena el email, no un segundo nombre. En este caso no concatenamos.
    // 
    // //3724    Requerimiento de modificaciones B2B B2C - NAV  editado NM-CSA-020822
    //           p6 trazabilidad del procesado de pedidos.

    Permissions = TableData 50416 = rimd,
                  TableData 50417 = rimd,
                  TableData 50418 = rimd,
                  TableData 50419 = rimd,
                  TableData 50420 = rimd;
    TableNo = 472;

    trigger OnRun()
    var
        lFiltroInterface: Text[250];
    begin
        //EX-SGG-WMS 170919
        ObtenerDatos;

        RstControl.RESET;
        RstControl.SETCURRENTKEY(Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA", "Numero de mensaje SEGA");
        IF RstConfAlm."Mensajes PE" >= RstConfAlm."Mensajes PE"::"Obtener y procesar" THEN
            lFiltroInterface += FORMAT(RstControl.Interface::"PE-Pedido") + '|';
        IF RstConfAlm."Mensajes OE" >= RstConfAlm."Mensajes OE"::"Obtener y procesar" THEN
            lFiltroInterface += FORMAT(RstControl.Interface::"OE-Orden de Entrada") + '|';
        IF RstConfAlm."Mensajes CE" >= RstConfAlm."Mensajes CE"::"Obtener y procesar" THEN
            lFiltroInterface += FORMAT(RstControl.Interface::"CE-Confirmacion de Entrada") + '|';
        IF RstConfAlm."Mensajes CS" >= RstConfAlm."Mensajes CS"::"Obtener y procesar" THEN
            lFiltroInterface += FORMAT(RstControl.Interface::"CS-Confirmacion de Salida") + '|';
        IF RstConfAlm."Mensajes AS" >= RstConfAlm."Mensajes AS"::"Obtener y procesar" THEN
            lFiltroInterface += FORMAT(RstControl.Interface::"AS-Ajuste de Stock") + '|';
        IF RstConfAlm."Mensajes SA" >= RstConfAlm."Mensajes SA"::"Obtener y procesar" THEN
            lFiltroInterface += FORMAT(RstControl.Interface::"SA-Stock Actual") + '|';
        IF STRLEN(lFiltroInterface) > 1 THEN BEGIN
            lFiltroInterface := COPYSTR(lFiltroInterface, 1, STRLEN(lFiltroInterface) - 1);
            RstControl.SETFILTER(Interface, lFiltroInterface);
            ProcesarRegistrosControl(RstControl);
        END;

        CLEAR(lFiltroInterface);
        IF RstConfAlm."Mensajes PE" = RstConfAlm."Mensajes PE"::"Obtener-procesar y comunicar" THEN
            lFiltroInterface += FORMAT(RstControl.Interface::"PE-Pedido") + '|';
        IF RstConfAlm."Mensajes OE" = RstConfAlm."Mensajes OE"::"Obtener-procesar y comunicar" THEN
            lFiltroInterface += FORMAT(RstControl.Interface::"OE-Orden de Entrada") + '|';
        IF STRLEN(lFiltroInterface) > 1 THEN BEGIN
            lFiltroInterface := COPYSTR(lFiltroInterface, 1, STRLEN(lFiltroInterface) - 1);
            RstControl.SETFILTER(Interface, lFiltroInterface);
            ComunicarWSRegistrosControl(RstControl);
        END;
    end;

    var
        RstCabRecepAlm: Record "Warehouse Receipt Header";
        tmp_RstCabRecepAlm: Record "Warehouse Receipt Header" temporary;
        RstLinRecepAlm: Record "Warehouse Receipt line";
        RstCabEnvAlm: Record "Warehouse Shipment Header"; //Warehouse Shipment Header WMS
        tmp_RstCabEnvAlm: Record "Warehouse Shipment line" temporary;
        RstLinEnvAlm: Record "Warehouse Shipment Line";
        RstHistCabRecepAlm: Record "Posted Whse. Receipt Header";
        RstHistCabEnvAlm: Record "Posted Whse. Shipment Header";
        RstControl: Record "Control integracion WMS";
        RstOE: Record "WMS OE-Ordenes de Entrada";
        RstCE: Record "WMS CE-Confirmación de Entrada";
        RstPE: Record "WMS PE-Pedidos";
        RstCS: Record "WMS CS-Confirmacion de Salidas";
        RstAS: Record "WMS AS-Ajuste Stock";
        RstSA: Record "WMS SA-Stock Actual";
        RstLOG: Record "WMS Log de errores";
        RstCabVenta: Record "Sales Header";
        RstLinVenta: Record "Sales line";
        RstCabCompra: Record "Purchase Header";
        RstLinCompra: Record "Purchase line";
        RstConfCompras: Record "Purchases & Payables Setup";
        RstConfAlm: Record 5769;
        RstVinculos: Record 2000000068;
        RstAlmacen: Record Location;
        RstProd: Record Item;
        RstAsignacionDirecta: Record 50025;
        RstAtributos: Record 50421;
        RstConfUsuarios: Record 91;
        RstSucursales: Record "Sucursales de destino";
        RstRef: RecordRef;
        CduNoSeriesMgt: Codeunit 396;
        nRegControl: Integer;
        LinTransfer: Record 5741;
        globalSourceNo: Code[20];


    procedure ObtenerDatos()
    var
        lRstTMPCE: Record "WMS CE-Confirmación de Entrada" temporary;
        lRstTMPCS: Record "WMS CS-Confirmacion de Salidas" temporary;
    begin
        //EX-SGG-WMS 160719
        CLEAR(CduNoSeriesMgt);
        RstConfAlm.GET;
        RstConfAlm.TESTFIELD("No. serie mensaje SEGA PE");
        RstConfAlm.TESTFIELD("No. serie mensaje SEGA OE");
        //FIN EX-SGG-WMS 160719
        nRegControl := UltimoNumeroRegistroControl() + 1;
        //EX-SGG 120619
        IF (RstConfAlm."Mensajes OE" >= RstConfAlm."Mensajes OE"::Obtener) OR GUIALLOWED THEN //EX-SGG-WMS 170919
         BEGIN
            RstCabRecepAlm.RESET;
            RstCabRecepAlm.SETCURRENTKEY(Obtenido);
            RstCabRecepAlm.SETCURRENTKEY(Obtenido, Status);
            RstCabRecepAlm.SETRANGE(Obtenido, FALSE);
            RstCabRecepAlm.SETRANGE(Status, RstCabEnvAlm.Status::Released);
            IF RstCabRecepAlm.FINDSET THEN BEGIN
                REPEAT
                    InsertarEnRegistroControl(nRegControl, RstControl.Interface::"OE-Orden de Entrada",
                     RstControl."Tipo documento"::"Recepcion almacen", RstCabRecepAlm."No.",
                     RstControl.Estado::Pendiente, CURRENTDATETIME, 0,
                     CduNoSeriesMgt.GetNextNo(RstConfAlm."No. serie mensaje SEGA OE", WORKDATE, TRUE)); //EX-SGG-WMS 160719
                    InsertarRegistroOE(RstCabRecepAlm);
                    //EX-RBF 040122 Inicio
                    //RstCabRecepAlm.MODIFYALL(Obtenido,TRUE,FALSE);
                    tmp_RstCabRecepAlm.TRANSFERFIELDS(RstCabRecepAlm);
                    tmp_RstCabRecepAlm.INSERT;
                UNTIL RstCabRecepAlm.NEXT = 0;
                IF tmp_RstCabRecepAlm.FINDSET THEN
                    REPEAT
                        RstCabRecepAlm.GET(tmp_RstCabRecepAlm."No.");
                        RstCabRecepAlm.Obtenido := TRUE;
                        RstCabRecepAlm.MODIFY;
                    UNTIL tmp_RstCabRecepAlm.NEXT = 0;
                tmp_RstCabRecepAlm.DELETEALL;
                //EX-RBF 040122 Fin

            END;
        END;

        IF (RstConfAlm."Mensajes PE" >= RstConfAlm."Mensajes PE"::Obtener) OR GUIALLOWED THEN //EX-SGG-WMS 170919
         BEGIN
            RstCabEnvAlm.RESET;
            RstCabEnvAlm.SETCURRENTKEY(Obtenido, Status);
            RstCabEnvAlm.SETRANGE(Obtenido, FALSE);
            RstCabEnvAlm.SETRANGE(Status, RstCabEnvAlm.Status::Released);
            IF RstCabEnvAlm.FINDSET THEN BEGIN
                REPEAT
                    InsertarEnRegistroControl(nRegControl, RstControl.Interface::"PE-Pedido",
                     RstControl."Tipo documento"::"Envio almacen", RstCabEnvAlm."No.",
                     RstControl.Estado::Pendiente, CURRENTDATETIME, 0,
                     CduNoSeriesMgt.GetNextNo(RstConfAlm."No. serie mensaje SEGA PE", WORKDATE, TRUE)); //EX-SGG-WMS 160719
                    InsertarRegistroPE(RstCabEnvAlm); //EX-SGG 130619
                                                      //EX-RBF 040122 Inicio
                    tmp_RstCabEnvAlm.TRANSFERFIELDS(RstCabEnvAlm);
                    tmp_RstCabEnvAlm.INSERT;
                //EX-OMI 080819
                //UNTIL RstCabRecepAlm.NEXT=0;
                UNTIL RstCabEnvAlm.NEXT = 0;
                //RstCabEnvAlm.MODIFYALL(Obtenido,TRUE,FALSE);
                IF tmp_RstCabEnvAlm.FINDSET THEN
                    REPEAT
                        RstCabEnvAlm.GET(tmp_RstCabEnvAlm."No.");
                        RstCabEnvAlm.Obtenido := TRUE;
                        RstCabEnvAlm.MODIFY;
                    UNTIL tmp_RstCabEnvAlm.NEXT = 0;
                tmp_RstCabEnvAlm.DELETEALL;
                //EX-RBF 040122 Fin
            END;
        END;


        IF (RstConfAlm."Mensajes CE" >= RstConfAlm."Mensajes CE"::Obtener) OR GUIALLOWED THEN //EX-SGG-WMS 170919
         BEGIN
            RstCE.RESET;
            RstCE.SETCURRENTKEY(Obtenido);
            RstCE.SETRANGE(Obtenido, FALSE);
            IF RstCE.FINDSET THEN BEGIN
                //+EX-SGG 250722
                IF lRstTMPCE.FINDFIRST THEN ERROR('Las variables temporales no deben contener registros');
                lRstTMPCE.SETCURRENTKEY(correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada);
                //-EX-SGG 250722
                REPEAT
                    RstControl.RESET;
                    RstControl.SETCURRENTKEY(Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA",
                     "Numero de mensaje SEGA");
                    RstControl.SETRANGE(Interface, RstControl.Interface::"CE-Confirmacion de Entrada");
                    RstControl.SETRANGE("Tipo documento", RstControl."Tipo documento"::"Recepcion almacen");
                    RstControl.SETRANGE("No. documento", RstCE.codigoOrdenEntrada);
                    RstControl.SETRANGE("Id. SEGA", RstCE.correlativoRecepcion);
                    RstControl.SETRANGE("Numero de mensaje SEGA", RstCE.numeroMensaje);
                    IF NOT RstControl.FINDFIRST THEN //EX-SGG-WMS 180619
                     BEGIN
                        InsertarEnRegistroControl(nRegControl, RstControl.Interface::"CE-Confirmacion de Entrada",
                         RstControl."Tipo documento"::"Recepcion almacen", RstCE.codigoOrdenEntrada,
                         RstControl.Estado::Pendiente, CURRENTDATETIME, RstCE.correlativoRecepcion, RstCE.numeroMensaje); //EX-SGG-WMS 200619

                        //+EX-SGG 250722
                        lRstTMPCE.SETRANGE(codigoOrdenEntrada, RstCE.codigoOrdenEntrada);
                        IF NOT lRstTMPCE.FINDFIRST THEN BEGIN
                            lRstTMPCE.TRANSFERFIELDS(RstCE);
                            lRstTMPCE.INSERT(FALSE);
                        END;
                        //-EX-SGG 250722
                    END;
                UNTIL RstCE.NEXT = 0;
                //+EX-SGG 250722
                //RstCE.MODIFYALL(Obtenido,TRUE,TRUE);
                lRstTMPCE.SETRANGE(codigoOrdenEntrada);
                IF lRstTMPCE.FINDSET THEN BEGIN
                    RstCE.RESET;
                    RstCE.SETCURRENTKEY(correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada);
                    REPEAT
                        RstCE.SETRANGE(codigoOrdenEntrada, lRstTMPCE.codigoOrdenEntrada);
                        RstCE.MODIFYALL(Obtenido, TRUE, TRUE);
                    UNTIL lRstTMPCE.NEXT = 0;
                END;
                //-EX-SGG 250722
            END;
        END;

        //EX-SGG 130619
        IF (RstConfAlm."Mensajes CS" >= RstConfAlm."Mensajes CS"::Obtener) OR GUIALLOWED THEN //EX-SGG-WMS 170919
         BEGIN
            RstCS.RESET;
            RstCS.SETCURRENTKEY(Obtenido);
            RstCS.SETRANGE(Obtenido, FALSE);
            IF RstCS.FINDSET THEN BEGIN
                //+EX-SGG 250722
                IF lRstTMPCS.FINDFIRST THEN ERROR('Las variables temporales no deben contener registros');
                lRstTMPCS.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP);
                //-EX-SGG 250722
                REPEAT
                    RstControl.RESET;
                    RstControl.SETCURRENTKEY(Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA",
                     "Numero de mensaje SEGA");
                    RstControl.SETRANGE(Interface, RstControl.Interface::"CS-Confirmacion de Salida");
                    RstControl.SETRANGE("Tipo documento", RstControl."Tipo documento"::"Envio almacen");
                    RstControl.SETRANGE("No. documento", RstCS.codigoEntregaERP);
                    RstControl.SETRANGE("Id. SEGA", RstCS.identificadorExpedicion);
                    RstControl.SETRANGE("Numero de mensaje SEGA", RstCS.numeroMensaje);
                    IF NOT RstControl.FINDFIRST THEN  //EX-SGG-WMS 200619
                     BEGIN
                        InsertarEnRegistroControl(nRegControl, RstControl.Interface::"CS-Confirmacion de Salida",
                         RstControl."Tipo documento"::"Envio almacen", RstCS.codigoEntregaERP,
                         RstControl.Estado::Pendiente, CURRENTDATETIME, RstCS.identificadorExpedicion, RstCS.numeroMensaje);

                        //+EX-SGG 250722
                        lRstTMPCS.SETRANGE(codigoEntregaERP, RstCS.codigoEntregaERP);
                        IF NOT lRstTMPCS.FINDFIRST THEN BEGIN
                            lRstTMPCS.TRANSFERFIELDS(RstCS);
                            lRstTMPCS.INSERT(FALSE);
                        END;
                        //-EX-SGG 250722
                    END;
                UNTIL RstCS.NEXT = 0;
                //+EX-SGG 250722
                //RstCS.MODIFYALL(Obtenido,TRUE,TRUE);
                lRstTMPCS.SETRANGE(codigoEntregaERP);
                IF lRstTMPCS.FINDSET THEN BEGIN
                    RstCS.RESET;
                    RstCS.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP);
                    REPEAT
                        RstCS.SETRANGE(codigoEntregaERP, lRstTMPCS.codigoEntregaERP);
                        RstCS.MODIFYALL(Obtenido, TRUE, TRUE);
                    UNTIL lRstTMPCS.NEXT = 0;
                END;
                //-EX-SGG 250722
            END;
        END;

        IF (RstConfAlm."Mensajes AS" >= RstConfAlm."Mensajes AS"::Obtener) OR GUIALLOWED THEN //EX-SGG-WMS 170919
         BEGIN
            RstAS.RESET;
            RstAS.SETCURRENTKEY(Obtenido);
            RstAS.SETRANGE(Obtenido, FALSE);
            IF RstAS.FINDSET THEN BEGIN
                REPEAT
                    RstControl.RESET;
                    RstControl.SETCURRENTKEY(Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA",
                     "Numero de mensaje SEGA");
                    RstControl.SETRANGE(Interface, RstControl.Interface::"AS-Ajuste de Stock");
                    RstControl.SETRANGE("Tipo documento", RstControl."Tipo documento"::Stock);
                    RstControl.SETRANGE("Numero de mensaje SEGA", RstAS.numeroMensaje);
                    IF NOT RstControl.FINDFIRST THEN  //EX-SGG-WMS 030719
                        InsertarEnRegistroControl(nRegControl, RstControl.Interface::"AS-Ajuste de Stock",
                         RstControl."Tipo documento"::Stock, FORMAT(RstAS.numeroMensaje),
                         RstControl.Estado::Pendiente, CURRENTDATETIME, RstAS.identificadorAjuste, RstAS.numeroMensaje);
                UNTIL RstAS.NEXT = 0;
                RstAS.MODIFYALL(Obtenido, TRUE, TRUE);
            END;
        END;

        IF (RstConfAlm."Mensajes SA" >= RstConfAlm."Mensajes SA"::Obtener) OR GUIALLOWED THEN //EX-SGG-WMS 170919
         BEGIN
            RstSA.RESET;
            RstSA.SETCURRENTKEY(Obtenido);
            RstSA.SETRANGE(Obtenido, FALSE);
            IF RstSA.FINDSET THEN BEGIN
                REPEAT
                    RstControl.RESET;
                    RstControl.SETCURRENTKEY(Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA",
                     "Numero de mensaje SEGA");
                    RstControl.SETRANGE(Interface, RstControl.Interface::"SA-Stock Actual");
                    RstControl.SETRANGE("Tipo documento", RstControl."Tipo documento"::Stock);
                    RstControl.SETRANGE("Numero de mensaje SEGA", RstSA.numeroMensaje);
                    IF NOT RstControl.FINDFIRST THEN BEGIN //EX-SGG-WMS 030719
                        PreObtenerSASQL(RstSA.numeroMensaje); //EX-DRG 110321
                        InsertarEnRegistroControl(nRegControl, RstControl.Interface::"SA-Stock Actual",
                         RstControl."Tipo documento"::Stock, FORMAT(RstSA.numeroMensaje),
                         RstControl.Estado::Pendiente, CURRENTDATETIME, RstSA.identificadorStock, RstSA.numeroMensaje);
                    END;
                UNTIL RstSA.NEXT = 0;
                RstSA.MODIFYALL(Obtenido, TRUE, TRUE);
            END;
        END;
    end;


    procedure ReobtenerDatos(var lRstControlWMS: Record "50414")
    begin
        //EX-SGG-WMS 190719
        IF NOT CONFIRM('¿Confirma reobtener la información de los ' + FORMAT(lRstControlWMS.COUNT) + ' registros seleccionados?\' +
         'Esta acción solo aplica a interfaces "PE-Pedido" y "OE-Orden de Entrada".\' +
         'Eliminará la información de las tablas auxiliares y obtendrá un nuevo numero de mensaje para SEGA.', FALSE) THEN
            EXIT;

        //EX-SMN-WMS 181019
        /*
        lRstControlWMS.SETFILTER(Interface,FORMAT(lRstControlWMS.Interface::"PE-Pedido")+'|'+
         FORMAT(lRstControlWMS.Interface::"OE-Orden de Entrada"));
        */
        //EX-SMN-WMS FIN
        CLEAR(CduNoSeriesMgt);
        RstConfAlm.GET;
        RstConfAlm.TESTFIELD("No. serie mensaje SEGA PE");
        RstConfAlm.TESTFIELD("No. serie mensaje SEGA OE");
        IF lRstControlWMS.FINDSET THEN
            REPEAT
                //EX-SMN-WMS 211019
                IF lRstControlWMS.Estado <> lRstControlWMS.Estado::Error THEN
                    ERROR('Sólo se puede reintentar integrar documentos cuyo estado sea Error');
                //EX-SMN-WMS FIN
                CASE lRstControlWMS.Interface OF
                    lRstControlWMS.Interface::"PE-Pedido":
                        BEGIN
                            RstCabEnvAlm.GET(lRstControlWMS."No. documento");
                            RstCabEnvAlm.TESTFIELD(Status, RstCabEnvAlm.Status::Released);
                            EliminarRegistrosPE(lRstControlWMS."No. documento");
                            lRstControlWMS.VALIDATE("Numero de mensaje SEGA",
                             CduNoSeriesMgt.GetNextNo(RstConfAlm."No. serie mensaje SEGA PE", WORKDATE, TRUE));
                            InsertarRegistroPE(RstCabEnvAlm);
                        END;
                    lRstControlWMS.Interface::"OE-Orden de Entrada": //EX-SGG-WMS 220719
                        BEGIN
                            RstCabRecepAlm.GET(lRstControlWMS."No. documento");
                            RstCabRecepAlm.TESTFIELD(Status, RstCabRecepAlm.Status::Released);
                            EliminarRegistrosOE(lRstControlWMS."No. documento");
                            lRstControlWMS.VALIDATE("Numero de mensaje SEGA",
                             CduNoSeriesMgt.GetNextNo(RstConfAlm."No. serie mensaje SEGA OE", WORKDATE, TRUE));
                            InsertarRegistroOE(RstCabRecepAlm);
                        END;
                    //EX-SMN-WMS 181019
                    ELSE BEGIN
                        IF lRstControlWMS.Estado = lRstControlWMS.Estado::Error THEN BEGIN
                            lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Pendiente);
                            lRstControlWMS.MODIFY(TRUE);
                            EXIT;
                        END;
                        EXIT;
                    END;
                //EX-SMN-WMS FIN
                END;
                lRstControlWMS.DELETELINKS;
                lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Pendiente);
                lRstControlWMS.VALIDATE("Fecha y hora obtenido", CURRENTDATETIME);
                lRstControlWMS.VALIDATE("Fecha y hora procesado", 0DT);
                lRstControlWMS.VALIDATE("Fecha y hora ult. resp. SEGA", 0DT);
                lRstControlWMS.VALIDATE("Fecha y hora enviado WS", 0DT);
                lRstControlWMS.VALIDATE("Estado SEGA", lRstControlWMS."Estado SEGA"::" ");
                lRstControlWMS.MODIFY(TRUE);
            UNTIL lRstControlWMS.NEXT = 0;

    end;


    procedure UltimoNumeroRegistroControl(): Integer
    var
        lRstControlWMS: Record "50414";
    begin
        //EX-SGG 120619
        IF lRstControlWMS.FINDLAST THEN
            EXIT(lRstControlWMS."No. registro")
        ELSE
            EXIT(0);
    end;


    procedure InsertarEnRegistroControl(var lnRegControl: Integer; lInterface: Option; lTipoDoc: Option; lNoDoc: Code[20]; lEstado: Option; lFechayHora: DateTime; lIdWMS: Integer; lNumeroMensaje: Code[25])
    var
        lRstControl: Record 50414;
    begin
        //EX-SGG-WMS 200619
        //EX-RBF 200522 Inicio
        CLEAR(lRstControl);
        lRstControl.SETRANGE("No. documento", lNoDoc);
        IF lRstControl.FINDFIRST THEN
            CASE lRstControl.Interface OF
                lRstControl.Interface::"OE-Orden de Entrada":
                    BEGIN
                        IF lInterface = lRstControl.Interface::"OE-Orden de Entrada" THEN
                            ERROR('Error al insertar registro en control, ya existe un registro para el No. documento %1', lNoDoc);
                    END;
                lRstControl.Interface::"PE-Pedido":
                    BEGIN
                        IF lInterface = lRstControl.Interface::"PE-Pedido" THEN
                            ERROR('Error al insertar registro en control, ya existe un registro para el No. documento %1', lNoDoc);
                    END;
            END;
        //EX-RBF 200522 Fin
        CLEAR(RstControl);
        RstControl.INIT;
        RstControl.VALIDATE("No. registro", lnRegControl);
        RstControl.VALIDATE(Interface, lInterface);
        RstControl.VALIDATE("Tipo documento", lTipoDoc);
        RstControl.VALIDATE("No. documento", lNoDoc);
        RstControl.VALIDATE(Estado, lEstado);
        RstControl.VALIDATE("Fecha y hora obtenido", lFechayHora);
        RstControl.VALIDATE("Id. SEGA", lIdWMS);
        RstControl.VALIDATE("Numero de mensaje SEGA", lNumeroMensaje); //EX-SGG-WMS 030719
        RstControl.INSERT(TRUE);
        lnRegControl += 1;
    end;


    procedure EliminarRegistroControl(var lRstControlWMS: Record "50414")
    var
        lNoRegControl: Integer;
    begin
        //EX-SGG 120619
        lRstControlWMS.TESTFIELD(Estado, lRstControlWMS.Estado::Pendiente);
        CASE lRstControlWMS."Tipo documento" OF
            lRstControlWMS."Tipo documento"::"Recepcion almacen":
                BEGIN
                    RstCabRecepAlm.GET(lRstControlWMS."No. documento");
                    RstCabRecepAlm.VALIDATE(Obtenido, FALSE);
                    RstCabRecepAlm.MODIFY;
                    EliminarRegistrosOE(lRstControlWMS."No. documento"); //EX-SGG-WNS 190719
                END;
            lRstControlWMS."Tipo documento"::"Envio almacen":
                BEGIN
                    RstCabEnvAlm.GET(lRstControlWMS."No. documento");
                    RstCabEnvAlm.VALIDATE(Obtenido, FALSE);
                    RstCabEnvAlm.MODIFY;
                    EliminarRegistrosPE(lRstControlWMS."No. documento"); //EX-SGG-WMS 190719
                END;
            lRstControlWMS."Tipo documento"::Stock: //EX-SGG-WMS 150719
                BEGIN
                    CASE lRstControlWMS.Interface OF
                        lRstControlWMS.Interface::"AS-Ajuste de Stock":
                            BEGIN
                                RstAS.RESET;
                                RstAS.SETCURRENTKEY(numeroMensaje);
                                RstAS.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA"); //EX-SGG-WMS 261219
                                RstAS.DELETEALL(TRUE);
                            END;
                        lRstControlWMS.Interface::"SA-Stock Actual":
                            BEGIN
                                RstSA.RESET;
                                RstSA.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA"); //EX-SGG-WMS 261219
                                RstSA.DELETEALL(TRUE);
                            END;
                    END;
                END;
        END;

        //EX-SGG-WMS 180619
        RstLOG.RESET;
        RstLOG.SETCURRENTKEY("No. registro control rel.");
        RstLOG.SETRANGE("No. registro control rel.", lRstControlWMS."No. registro");
        RstLOG.DELETEALL(TRUE);
        lRstControlWMS.DELETELINKS;
        //FIN EX-SGG-WMS 180619

        //EX-SGG-WMS 280120
        lNoRegControl := lRstControlWMS."No. registro";
        lRstControlWMS."No. registro" := 0;
        InsertarRegistroLOG(lRstControlWMS, FALSE, 'Registro eliminado por el usuario ' + USERID);
        lRstControlWMS."No. registro" := lNoRegControl;
        //FIN EX-SGG-WMS 280120
    end;


    procedure ValidarEstadoRegistroControl(var lRstControlWMS: Record "50414")
    begin
        //EX-SGG-WMS 030719
        CASE lRstControlWMS.Interface OF
            lRstControlWMS.Interface::"OE-Orden de Entrada":
                BEGIN
                    RstOE.RESET;
                    RstOE.SETCURRENTKEY(codigoOrdenEntrada);
                    RstOE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                    //EX-SGG-WMS 181219
                    //RstOE.MODIFYALL(Integrado,lRstControlWMS.Estado=lRstControlWMS.Estado::Integrado,TRUE);
                    IF RstOE.FINDSET THEN
                        REPEAT
                            RstOE.VALIDATE(Integrado, lRstControlWMS.Estado = lRstControlWMS.Estado::Integrado);
                            RstOE.MODIFY(TRUE);
                        UNTIL RstOE.NEXT = 0;
                    //FIN EX-SGG-WMS 181219
                END;
            lRstControlWMS.Interface::"PE-Pedido":
                BEGIN
                    RstPE.RESET;
                    RstPE.SETCURRENTKEY(codigoEntregaERP);
                    RstPE.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                    //EX-SGG-WMS 181219
                    //RstPE.MODIFYALL(Integrado,lRstControlWMS.Estado=lRstControlWMS.Estado::Integrado,TRUE);
                    IF RstPE.FINDSET THEN
                        REPEAT
                            RstPE.VALIDATE(Integrado, lRstControlWMS.Estado = lRstControlWMS.Estado::Integrado);
                            RstPE.MODIFY(TRUE);
                        UNTIL RstPE.NEXT = 0;
                    //FIN EX-SGG-WMS 181219
                END;
            lRstControlWMS.Interface::"CE-Confirmacion de Entrada":
                BEGIN
                    RstCE.RESET;
                    RstCE.SETCURRENTKEY(correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada); //EX-SGG 280819
                    RstCE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                    //EX-SGG-WMS 140720
                    //RstCE.MODIFYALL(Integrado,lRstControlWMS.Estado=lRstControlWMS.Estado::Integrado,TRUE);
                    IF RstCE.FINDSET THEN
                        REPEAT
                            RstCE.VALIDATE(Integrado, lRstControlWMS.Estado = lRstControlWMS.Estado::Integrado);
                            RstCE.MODIFY(TRUE);
                        UNTIL RstCE.NEXT = 0;
                    //FIN EX-SGG-WMS 140720
                END;
            lRstControlWMS.Interface::"CS-Confirmacion de Salida":
                BEGIN
                    RstCS.RESET;
                    RstCS.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP); //EX-SGG-WMS 120919
                    RstCS.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                    //EX-SGG-WMS 140720
                    //RstCS.MODIFYALL(Integrado,lRstControlWMS.Estado=lRstControlWMS.Estado::Integrado,TRUE);
                    IF RstCS.FINDSET THEN
                        REPEAT
                            RstCS.VALIDATE(Integrado, lRstControlWMS.Estado = lRstControlWMS.Estado::Integrado);
                            RstCS.MODIFY(TRUE);
                        UNTIL RstCS.NEXT = 0;
                    //FIN EX-SGG-WMS 140720
                END;
            lRstControlWMS.Interface::"AS-Ajuste de Stock", lRstControlWMS.Interface::"SA-Stock Actual":
                ;
        //EX-SGG-WMS 150719 NO APLICA PARA AS/SA YA QUE LLEVAN EL ESTADO POR CADA UNO DE LOS REGISTROS.
        END;
    end;


    procedure VisualizarDatosRegistroControl(var lRstControlWMS: Record "Control integracion WMS")
    var
        lFrmOE: page 50420;
        lFrmCE: page 50417;
        lFrmPE: page 50421;
        lFrmCS: page 50422;
        lFrmAS: page 50423;
        lFrmSA: page 50424;
    begin
        //EX-SGG-WMS 120619
        CASE lRstControlWMS.Interface OF
            lRstControlWMS.Interface::"OE-Orden de Entrada":
                BEGIN
                    CLEAR(lFrmOE);
                    RstOE.RESET;
                    RstOE.SETCURRENTKEY(codigoOrdenEntrada);
                    RstOE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                    lFrmOE.SETTABLEVIEW(RstOE);
                    lFrmOE.EDITABLE(FALSE);
                    lFrmOE.RUNMODAL;
                END;
            lRstControlWMS.Interface::"PE-Pedido": //EX-WMS 130619
                BEGIN
                    CLEAR(lFrmPE);
                    RstPE.RESET;
                    RstPE.SETCURRENTKEY(codigoEntregaERP);
                    RstPE.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                    lFrmPE.SETTABLEVIEW(RstPE);
                    lFrmPE.EDITABLE(FALSE);
                    lFrmPE.RUNMODAL;
                END;
            lRstControlWMS.Interface::"CE-Confirmacion de Entrada":
                BEGIN
                    CLEAR(lFrmCE);
                    RstCE.RESET;
                    RstCE.SETCURRENTKEY(correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada); //EX-SGG 280819
                    RstCE.SETRANGE(correlativoRecepcion, lRstControlWMS."Id. SEGA");
                    RstCE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                    RstCE.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA");
                    lFrmCE.SETTABLEVIEW(RstCE);
                    lFrmCE.EDITABLE(FALSE);
                    lFrmCE.RUNMODAL;
                END;
            lRstControlWMS.Interface::"CS-Confirmacion de Salida": //EX-SGG 130619
                BEGIN
                    CLEAR(lFrmCS);
                    RstCS.RESET;
                    RstCS.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP); //EX-SGG-WMS 120919
                    RstCS.SETRANGE(identificadorExpedicion, lRstControlWMS."Id. SEGA");
                    RstCS.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                    RstCS.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA");
                    lFrmCS.SETTABLEVIEW(RstCS);
                    lFrmCS.EDITABLE(FALSE);
                    lFrmCS.RUNMODAL;
                END;
            lRstControlWMS.Interface::"AS-Ajuste de Stock":  //EX-SGG 130619
                BEGIN
                    CLEAR(lFrmAS);
                    RstAS.RESET;
                    RstAS.SETCURRENTKEY(numeroMensaje, motivoAjuste); //EX-SGG-WMS 040719
                    RstAS.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA"); //EX-SGG-WMS 040719
                    lFrmAS.SETTABLEVIEW(RstAS);
                    lFrmAS.EDITABLE(FALSE);
                    lFrmAS.RUNMODAL;
                END;
            lRstControlWMS.Interface::"SA-Stock Actual":  //EX-SGG 130619
                BEGIN
                    CLEAR(lFrmSA);
                    RstSA.RESET;
                    RstSA.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA"); //EX-SGG-WMS 040719
                    lFrmSA.SETTABLEVIEW(RstSA);
                    lFrmSA.EDITABLE(FALSE);
                    lFrmSA.RUNMODAL;
                END;

        END;
    end;


    procedure VisualizarLOGRegistroControl(var lRstControlWMS: Record "Control integracion WMS")
    var
        lFrmLOG: page 50425;
    begin
        //EX-SGG-WMS 180619
        CLEAR(lFrmLOG);
        RstLOG.RESET;
        RstLOG.SETCURRENTKEY("No. registro control rel.");
        RstLOG.SETRANGE("No. registro control rel.", lRstControlWMS."No. registro");
        lFrmLOG.SETTABLEVIEW(RstLOG);
        lFrmLOG.EDITABLE(FALSE);
        lFrmLOG.RUNMODAL;
    end;


    procedure NavegarRegistroControl(var lRstControlWMS: Record "50414")
    begin
        //EX-SGG-WMS 120619
        CASE lRstControlWMS."Tipo documento" OF
            lRstControlWMS."Tipo documento"::"Envio almacen": //EX-SGG 130619
                BEGIN
                    IF RstCabEnvAlm.GET(lRstControlWMS."No. documento") THEN BEGIN
                        RstCabEnvAlm.RESET;
                        RstCabEnvAlm.SETRANGE("No.", lRstControlWMS."No. documento");
                        page.RUNMODAL(0, RstCabEnvAlm);
                    END
                    ELSE BEGIN
                        RstHistCabEnvAlm.RESET;
                        //RstHistCabEnvAlm.SETRANGE("Whse. Shipment No.",lRstControlWMS."No. documento");
                        RstHistCabEnvAlm.SETRANGE("No.", lRstControlWMS."No. documento"); //EX-SGG-WMS 050919
                        page.RUNMODAL(0, RstHistCabEnvAlm);
                    END;
                END;
            lRstControlWMS."Tipo documento"::"Recepcion almacen":
                BEGIN
                    IF RstCabRecepAlm.GET(lRstControlWMS."No. documento") THEN BEGIN
                        RstCabRecepAlm.RESET;
                        RstCabRecepAlm.SETRANGE("No.", lRstControlWMS."No. documento");
                        page.RUNMODAL(0, RstCabRecepAlm);
                    END
                    ELSE BEGIN
                        RstHistCabRecepAlm.RESET;
                        //RstHistCabRecepAlm.SETRANGE("Whse. Receipt No.",lRstControlWMS."No. documento");
                        RstHistCabRecepAlm.SETRANGE("No.", lRstControlWMS."No. documento"); //EX-SGG-WMS 050919
                        page.RUNMODAL(0, RstHistCabRecepAlm);
                    END;
                END;
            lRstControlWMS."Tipo documento"::Stock:
                ; //EX-SGG-WMS 150719 NO APLICA.
        END;
    end;

    procedure ProcesarRegistrosControl(var lRstControlWMS: Record "Control integracion WMS")

    var
        lRstTMPLinRecepAlm: Record "Warehouse Receipt Line" temporary;
        lRstTMPLinEnvAlm: Record "Warehouse Shipment Line" temporary;
        lRstLinDia: Record 83;
        lRstTMPCE: Record "WMS CE-Confirmación de Entrada" temporary;
        lRstTMPCS: Record 50417 temporary;
        lRstTMPAS: Record 50418 temporary;
        lRstTMPCabCompra: Record 38 temporary;
        //   lCduRegRecep: Codeunit "50410";
        // lCduRegEnv: Codeunit "50412";
        lCduRegCompra: Codeunit 90;
        lCduLanzarPedCompra: Codeunit 415;
        lRptCalcInv: Report 790;
        lF: File;
        lOutStr: OutStream;
        //   lXMLOE: XMLport "50400";
        //   lXMLPE: XMLport "50401";
        lNombreFichero: Text[1024];
        lError: Boolean;
        lDescError: Text[250];
        lAlgunError: Boolean;
        lFiltroAlmacen: Text[250];
        lCantidadSEGA: Decimal;
        lCantidadNAV: Decimal;
        lCantidadDif: Decimal;
        lCodProd: Code[20];
        lCodVarProd: Code[10];
        lCodAlmPpal: Code[10];
        lnLinea: Integer;
        lIntAux: Integer;
        lCodAux: Code[10];
        lDecAux: Decimal;
        lCSSinNumLinea: Boolean;
        recTransferLine: Record 5741;
        recSalesHeader: Record "Sales Header";
        recTransferHeader: Record 5740;
        lisConsig: Boolean;
    begin
        /*
      //EX-SGG-WMS 170619
      IF lRstTMPLinRecepAlm.FINDFIRST OR lRstTMPLinEnvAlm.FINDFIRST OR lRstTMPCE.FINDFIRST OR lRstTMPCS.FINDFIRST
       OR lRstTMPAS.FINDFIRST OR lRstTMPCabCompra.FINDFIRST THEN
          ERROR('Las variables temporales no deben contener registros');
      RstConfAlm.GET;
      RstConfAlm.TESTFIELD("Ruta ficheros integracion WMS");
      RstConfAlm.TESTFIELD("Libro Diario Producto");
      RstConfAlm.TESTFIELD("Seccion Diario Producto");
      RstConfAlm.TESTFIELD("Libro Diario Inventario");
      RstConfAlm.TESTFIELD("Seccion Diario Inventario");
      lRstControlWMS.SETRANGE(Estado, lRstControlWMS.Estado::Pendiente);
      IF lRstControlWMS.FINDSET THEN BEGIN
          CLEAR(lError);
          CLEAR(lDescError);
          REPEAT
              CASE lRstControlWMS.Interface OF
                  lRstControlWMS.Interface::"OE-Orden de Entrada", lRstControlWMS.Interface::"PE-Pedido":
                      BEGIN
                      Message('en desarrollo vlr');

                          lNombreFichero := RstConfAlm."Ruta ficheros integracion WMS" + DELCHR(FORMAT(WORKDATE, 0, '<Standard Format,9>'), '=', '-') +
                           DELCHR(FORMAT(TIME, 0, '<Standard Format,9>'), '=', ':') + '_' + COPYSTR(FORMAT(lRstControlWMS.Interface), 1, 2) +
                           '_' + lRstControlWMS."No. documento" + '.xml';
                          lF.CREATE(lNombreFichero);
                          lF.CREATEOUTSTREAM(lOutStr);
                          CASE lRstControlWMS.Interface OF
                              lRstControlWMS.Interface::"OE-Orden de Entrada":
                                  BEGIN
                                      RstOE.RESET;
                                      RstOE.SETCURRENTKEY(codigoOrdenEntrada);
                                      RstOE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                                      RstOE.FINDSET;
                                      CLEAR(lXMLOE);
                                      lXMLOE.SETTABLEVIEW(RstOE);
                                      lXMLOE.SETDESTINATION(lOutStr);
                                      lXMLOE.EXPORT;
                                  END;
                              lRstControlWMS.Interface::"PE-Pedido":
                                  BEGIN
                                      RstPE.RESET;
                                      RstPE.SETCURRENTKEY(codigoEntregaERP);
                                      RstPE.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                                      RstPE.FINDSET;
                                      CLEAR(lXMLPE);
                                      lXMLPE.SETTABLEVIEW(RstPE);
                                      lXMLPE.SETDESTINATION(lOutStr);
                                      lXMLPE.EXPORT;
                                  END;
                          END;
                          lF.CLOSE;
                          EliminaTagsVaciosFicheroXML(lNombreFichero); //EX-SGG-WMS 150719
                          lRstControlWMS.ADDLINK(lNombreFichero, 'Integración WMS');
                          lRstControlWMS.VALIDATE("Fecha y hora procesado", CURRENTDATETIME);
                          lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Preparado);
                          lRstControlWMS.MODIFY(TRUE);
                      END;



                  lRstControlWMS.Interface::"CE-Confirmacion de Entrada":  //EX-SGG-WMS 180619
                      BEGIN
                          RstCE.RESET;
                          RstCE.SETCURRENTKEY(correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada); //EX-SGG 280819
                          RstCE.SETRANGE(correlativoRecepcion, lRstControlWMS."Id. SEGA");
                          RstCE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                          RstCE.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA");
                          RstCE.SETRANGE(finCodigoOrdenEntrada, TRUE); //EX-SGG-WMS 071119
                          IF RstCE.FINDFIRST THEN //EX-SGG-WMS 071119
                           BEGIN //EX-SGG-WMS 071119
                              RstCE.SETRANGE(finCodigoOrdenEntrada); //EX-SGG-WMS 071119
                                                                     //EX-SGG-WMS 020719 USO RSTOE
                              RstOE.RESET;
                              RstOE.SETCURRENTKEY(codigoOrdenEntrada);
                              RstOE.SETRANGE(codigoOrdenEntrada, lRstControlWMS."No. documento");
                              //FIN EX-SGG-WMS 020719
                              //EX-SGG-WMS 280819

                              CLEAR(lError);
                              lDescError := FORMAT(lRstControlWMS.Interface::"CE-Confirmacion de Entrada") +
                               ' ' + lRstControlWMS."No. documento";
                              IF NOT RstOE.FINDFIRST THEN BEGIN
                                  lError := TRUE;
                                  lDescError += ':No se encuentra la recepción de almacén NAV';
                              END;
                              //FIN EX-SGG-WMS 280819
                              IF NOT lError THEN BEGIN
                                  AgruparRegistrosCE(lRstControlWMS, lRstTMPCE, lError, lDescError);//EX-SGG-WMS 280819
                                  lRstTMPLinRecepAlm.RESET;
                                  lRstTMPLinRecepAlm.DELETEALL;
                                  //IF RstCE.FINDSET THEN
                                  lRstTMPCE.RESET; //EX-SGG-WMS 280819 USO VAR TEMPORAL AGRUPADA.
                                  IF (lRstTMPCE.FINDSET) AND (NOT lError) THEN
                                      REPEAT
                                          IF EVALUATE(lnLinea, lRstTMPCE.lineaOrdenEntrada) THEN; //EX-SGG-WMS 280819
                                          IF NOT RstLinRecepAlm.GET(lRstTMPCE.codigoOrdenEntrada, lnLinea) THEN BEGIN //EX-SGG-WNS 280819 IF
                                              lError := TRUE;
                                              lDescError += ':No se encuentra la línea ' + lRstTMPCE.lineaOrdenEntrada + ' en la recepción de almacén NAV';
                                          END
                                          ELSE BEGIN
                                              ObtenerCodigoArticuloERP(lRstTMPCE.codigoArticuloERP, lCodProd, lCodVarProd);
                                              IF (lCodProd <> RstLinRecepAlm."Item No.") OR (lCodVarProd <> RstLinRecepAlm."Variant Code") THEN BEGIN
                                                  lError := TRUE;
                                                  lDescError += ':Código producto y variante en ' + lRstTMPCE.lineaOrdenEntrada +
                                                    ' no coincide con la indicada en el documento NAV';
                                              END
                                              ELSE //FIN EX-SGG-WMS 280819
                                                  CompruebaCantidadSEGAvsNAV(lRstTMPCE.Cantidad, RstLinRecepAlm.Quantity, FORMAT(lRstControlWMS.Interface),
                                                   lRstControlWMS."No. documento", lRstTMPCE.TABLENAME, lRstTMPCE.lineaOrdenEntrada,
                                                   RstLinRecepAlm.TABLENAME, FORMAT(RstLinRecepAlm."Line No."), 'Cantidad en ',
                                                   lError, lDescError); //EX-SGG-WMS 200619
                                          END;

                                          IF (RstLinRecepAlm."Location Code" <> '') AND (NOT lError) THEN BEGIN
                                              RstAlmacen.GET(RstLinRecepAlm."Location Code");
                                              IF FORMAT(lRstTMPCE.estadoCalidad) <> RstAlmacen."Estado Calidad SEGA" THEN BEGIN
                                                  lError := TRUE;
                                                  lDescError += ':estadoCalidad ' + lRstTMPCE.TABLENAME + '(' + FORMAT(lRstTMPCE.estadoCalidad) + ') ' +
                                                   'no debe ser distinto que en ' + RstLinRecepAlm.TABLENAME + '(' + FORMAT(RstLinRecepAlm."Location Code") + ')';
                                              END;
                                          END;

                                          IF NOT lError THEN BEGIN
                                              lRstTMPLinRecepAlm.TRANSFERFIELDS(RstLinRecepAlm);
                                              lRstTMPLinRecepAlm.Quantity := lRstTMPCE.Cantidad;
                                              lRstTMPLinRecepAlm.INSERT(TRUE);
                                          END;
                                      UNTIL (lRstTMPCE.NEXT = 0) OR lError;

                                  RstLinRecepAlm.RESET;
                                  RstLinRecepAlm.SETRANGE("No.", lRstControlWMS."No. documento");
                                  IF RstLinRecepAlm.FINDSET AND (NOT lError) THEN BEGIN
                                      REPEAT
                                          IF lRstTMPLinRecepAlm.GET(RstLinRecepAlm."No.", RstLinRecepAlm."Line No.") THEN BEGIN
                                              RstLinRecepAlm.VALIDATE(Quantity, lRstTMPLinRecepAlm.Quantity);
                                              RstLinRecepAlm.VALIDATE("Qty. to Receive", RstLinRecepAlm.Quantity); //EX-SGG-WMS 181119
                                                                                                                   //RstLinRecepAlm.MODIFY(TRUE);
                                              RstLinRecepAlm.MODIFY; //EX-SGG-WMS 030919
                                          END
                                          ELSE BEGIN
                                              RstOE.SETFILTER(lineaOrdenEntrada, FORMAT(RstLinRecepAlm."Line No.")); //EX-SGG-WMS 020719
                                              IF RstOE.FINDFIRST THEN //EX-SGG-WMS 020719
                                                  RstLinRecepAlm.DELETE(TRUE);
                                          END;
                                      UNTIL RstLinRecepAlm.NEXT = 0;

                                      //EX-SGG-WMS 130919
                                      RstCabRecepAlm.GET(RstLinRecepAlm."No.");
                                      RstCabRecepAlm.VALIDATE("Posting Date", lRstTMPCE.fecha);
                                      RstCabRecepAlm.MODIFY;
                                      //FIN EX-SGG-WMS 130919

                                      COMMIT; //EX-SGG 290819
                                      IF (RstConfAlm."Mensajes CE" = RstConfAlm."Mensajes CE"::"Obtener-procesar y registrar") OR
                                       GUIALLOWED THEN //EX-SGG-WMS 170919
                                        BEGIN
                                          CLEAR(lCduRegRecep);
                                          IF NOT lCduRegRecep.RUN(RstLinRecepAlm) THEN BEGIN
                                              lError := TRUE;
                                              lDescError := COPYSTR(GETLASTERRORTEXT, 1, MAXSTRLEN(lDescError));
                                              CLEARLASTERROR;
                                          END;
                                      END;
                                  END;
                              END;

                              IF lError THEN BEGIN
                                  InsertarRegistroLOG(lRstControlWMS, FALSE, lDescError);
                                  lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Error);
                                  lRstControlWMS.MODIFY(TRUE);
                              END
                              ELSE  //EX-SGG-WMS 170919
                               BEGIN
                                  lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Integrado);
                                  lRstControlWMS.VALIDATE("Fecha y hora procesado", CURRENTDATETIME);
                                  lRstControlWMS.MODIFY(TRUE);
                              END;
                          END; //EX-SGG-WMS 071119
                      END;
                  lRstControlWMS.Interface::"CS-Confirmacion de Salida": //EX-SGG-WMS 200619
                      BEGIN
                          RstCS.RESET;
                          RstCS.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP); //EX-SGG-WMS 120919
                          RstCS.SETRANGE(identificadorExpedicion, lRstControlWMS."Id. SEGA");
                          RstCS.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                          RstCS.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA");
                          RstCS.SETRANGE(finCodigoEntregaERP, TRUE); //EX-SGG-WMS 071119
                          IF RstCS.FINDFIRST THEN //EX-SGG-WMS 071119
                           BEGIN //EX-SGG-WMS 071119
                              RstCS.SETRANGE(finCodigoEntregaERP); //EX-SGG-WMS 071119
                                                                   //EX-SGG-WMS 020719
                              RstPE.RESET;
                              RstPE.SETCURRENTKEY(codigoEntregaERP);
                              RstPE.SETRANGE(codigoEntregaERP, lRstControlWMS."No. documento");
                              //FIN EX-SGG-WMS 020719
                              //EX-SGG-WMS 120919

                              CLEAR(lError);
                              lDescError := FORMAT(lRstControlWMS.Interface::"CS-Confirmacion de Salida") +
                               ' ' + lRstControlWMS."No. documento";
                              IF NOT RstPE.FINDFIRST THEN BEGIN
                                  lError := TRUE;
                                  lDescError += ':No se encuentra el envío de almacén NAV';
                              END
                              ELSE BEGIN
                                  //EX-SGG 020620
                                  RstCS.SETRANGE(lineaEntregaERP, 'SINLINEA');
                                  lCSSinNumLinea := RstCS.COUNT > 0;
                                  IF lCSSinNumLinea THEN BEGIN
                                      RstCS.FINDSET;
                                      RstLinEnvAlm.SETRANGE("No.", RstCS.codigoEntregaERP);
                                      REPEAT
                                          lRstTMPCS.TRANSFERFIELDS(RstCS);
                                          lRstTMPCS.INSERT;
                                          ObtenerCodigoArticuloERP(RstCS.codigoArticuloERP, lCodProd, lCodVarProd);
                                          RstLinEnvAlm.SETRANGE("Item No.", lCodProd);
                                          RstLinEnvAlm.SETRANGE("Variant Code", lCodVarProd);
                                          IF RstLinEnvAlm.FINDFIRST THEN BEGIN
                                              lRstTMPCS.lineaEntregaERP := FORMAT(RstLinEnvAlm."Line No.");
                                              lRstTMPCS.MODIFY;
                                          END
                                          ELSE BEGIN
                                              lError := TRUE;
                                              lDescError += ':No se encuentra línea envío almacén para el producto ' + RstCS.codigoArticuloERP;
                                          END;
                                      UNTIL (RstCS.NEXT = 0) OR lError;

                                      IF NOT lError THEN BEGIN
                                          lRstTMPCS.FINDSET;
                                          REPEAT
                                              RstCS.GET(lRstTMPCS."No. registro");
                                              RstCS.lineaEntregaERP := lRstTMPCS.lineaEntregaERP;
                                              RstCS.MODIFY;
                                          UNTIL lRstTMPCS.NEXT = 0;
                                      END;
                                      lRstTMPCS.DELETEALL;
                                  END;
                                  RstCS.SETRANGE(lineaEntregaERP);

                                  IF NOT lError THEN
                                      //FIN EX-SGG 020620
                                      CrearEmbalajesEDIdesdeCS(lError, lDescError);
                              END;
                              //FIN EX-SGG-WMS 120919
                              IF NOT lError THEN BEGIN
                                  AgruparRegistrosCS(lRstControlWMS, lRstTMPCS, lError, lDescError);//EX-SGG-WMS 120919
                                  lRstTMPLinEnvAlm.RESET;
                                  lRstTMPLinEnvAlm.DELETEALL;
                                  //IF RstCS.FINDSET THEN
                                  lRstTMPCS.RESET;
                                  IF (lRstTMPCS.FINDSET) AND (NOT lError) THEN //EX-SGG-WMS 120919 TEMPORAL AGRUPADA
                                      REPEAT

                                          IF EVALUATE(lnLinea, lRstTMPCS.lineaEntregaERP) THEN; //EX-SGG-WMS 120919
                                          IF NOT RstLinEnvAlm.GET(lRstTMPCS.codigoEntregaERP, lnLinea) THEN //EX-SGG-WMS 120919 IF
                                           BEGIN
                                              lError := TRUE;
                                              lDescError += ':No se encuentra la línea ' + lRstTMPCS.lineaEntregaERP + ' en el envío de almacén NAV';
                                          END
                                          ELSE BEGIN
                                              ObtenerCodigoArticuloERP(lRstTMPCS.codigoArticuloERP, lCodProd, lCodVarProd);
                                              IF (lCodProd <> RstLinEnvAlm."Item No.") OR (lCodVarProd <> RstLinEnvAlm."Variant Code") THEN BEGIN
                                                  lError := TRUE;
                                                  lDescError += ':Código producto y variante en ' + lRstTMPCS.lineaEntregaERP +
                                                    ' no coincide con la indicada en el documento NAV';
                                              END
                                              ELSE //FIN EX-SGG-WMS 120919
                                                  CompruebaCantidadSEGAvsNAV(lRstTMPCS.cantidad, RstLinEnvAlm.Quantity, FORMAT(lRstControlWMS.Interface),
                                                   lRstControlWMS."No. documento", lRstTMPCS.TABLENAME, lRstTMPCS.lineaEntregaERP,
                                                   RstLinEnvAlm.TABLENAME, FORMAT(RstLinEnvAlm."Line No."), 'Cantidad en ', lError, lDescError);
                                          END;
                                          IF NOT lError THEN BEGIN
                                              lRstTMPLinEnvAlm.TRANSFERFIELDS(RstLinEnvAlm);
                                              lRstTMPLinEnvAlm.Quantity := lRstTMPCS.cantidad;
                                              lRstTMPLinEnvAlm.INSERT(TRUE);
                                          END;
                                      UNTIL (lRstTMPCS.NEXT = 0) OR lError;

                                  RstLinEnvAlm.RESET;
                                  RstLinEnvAlm.SETRANGE("No.", lRstControlWMS."No. documento");
                                  IF RstLinEnvAlm.FINDSET AND (NOT lError) THEN BEGIN

                                      //EX-CV  -  2021 12 14
                                      REPEAT
                                          lisConsig := FALSE;
                                          globalSourceNo := RstLinEnvAlm."Source No.";
                                          recTransferHeader.RESET;
                                          recTransferHeader.SETRANGE("No.", RstLinEnvAlm."Source No.");
                                          IF recTransferHeader.FINDFIRST THEN BEGIN
                                              recSalesHeader.RESET;
                                              recSalesHeader.SETRANGE("Document Type", recSalesHeader."Document Type"::Order);
                                              recSalesHeader.SETRANGE("No.", recTransferHeader."No. pedido venta");
                                              recSalesHeader.SETRANGE("Ventas en consignacion", TRUE);
                                              IF recSalesHeader.FINDFIRST THEN
                                                  lisConsig := TRUE;
                                          END;

                                          RstLinEnvAlm.SaltarComprobacionEnviadoASEGA(TRUE); //EX-SGG-WMS 170919
                                          IF lRstTMPLinEnvAlm.GET(RstLinEnvAlm."No.", RstLinEnvAlm."Line No.") THEN BEGIN
                                              RstLinEnvAlm.PfsSetSuspendStatusCheck(TRUE); //EX-SGG-WMS 130919
                                                                                           //RstLinEnvAlm.VALIDATE(Quantity,lRstTMPLinEnvAlm.Quantity); EX-CV  -  JX  -  2021 12 23
                                              IF NOT lisConsig THEN RstLinEnvAlm.VALIDATE(Quantity, lRstTMPLinEnvAlm.Quantity);
                                              RstLinEnvAlm.VALIDATE("Qty. to Ship", lRstTMPLinEnvAlm.Quantity); //EX-SGG-WMS 130919
                                              RstLinEnvAlm.MODIFY(TRUE);
                                          END ELSE BEGIN
                                              IF NOT lisConsig THEN BEGIN
                                                  RstPE.SETFILTER(lineaEntregaERP, FORMAT(RstLinEnvAlm."Line No.")); //EX-SGG-WMS 020719
                                                  IF (RstPE.FINDFIRST) OR lCSSinNumLinea THEN BEGIN//EX-SGG-WMS 020719 040620
                                                      RstLinEnvAlm.PfsSetSuspendDeleteCheck(TRUE); //EX-SGG-WMS 011019
                                                      RstLinEnvAlm.DELETE(TRUE);
                                                  END;
                                              END;
                                          END;
                                      UNTIL RstLinEnvAlm.NEXT = 0;
                                      //EX-CV END

                                      //EX-SGG-WMS 130919
                                      RstCabEnvAlm.GET(RstLinEnvAlm."No.");
                                      RstCabEnvAlm.VALIDATE("Posting Date", lRstTMPCS.fecha);
                                      RstCabEnvAlm.MODIFY;
                                      //FIN EX-SGG-WMS 130919

                                      COMMIT; //EX-SGG 290819
                                      IF (RstConfAlm."Mensajes CS" = RstConfAlm."Mensajes CS"::"Obtener-procesar y registrar") OR
                                       GUIALLOWED THEN //EX-SGG-WMS 170919
                                        BEGIN
                                          CLEAR(lCduRegEnv);
                                          //EX-SGG-WMS 040919
                                          lCduRegEnv.SetPostingSettings(FALSE);
                                          lCduRegEnv.SetPrint(FALSE);
                                          //FIN EX-SGG-WMS 040919
                                          IF NOT lCduRegEnv.RUN(RstLinEnvAlm) THEN BEGIN
                                              lError := TRUE;
                                              lDescError := COPYSTR(GETLASTERRORTEXT, 1, MAXSTRLEN(lDescError));
                                              CLEARLASTERROR;
                                          END;

                                          //EX-CV  -  2021 12 14
                                          UpdateSLCantPendNoAnul();
                                          //EX-CV  -  2021 12 14 END
                                      END;
                                  END;
                              END;

                              IF lError THEN BEGIN
                                  InsertarRegistroLOG(lRstControlWMS, FALSE, lDescError);
                                  lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Error);
                                  lRstControlWMS.MODIFY(TRUE);
                              END
                              ELSE //EX-SGG-WMS 170919
                               BEGIN
                                  lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Integrado);
                                  lRstControlWMS.VALIDATE("Fecha y hora procesado", CURRENTDATETIME);
                                  lRstControlWMS.MODIFY(TRUE);
                              END;
                          END; //EX-SGG-WMS 071119
                      END;
                  lRstControlWMS.Interface::"AS-Ajuste de Stock": //EX-SGG-WMS 260619
                      BEGIN
                          CLEAR(lAlgunError); //EX-SGG-WMS 040719
                          RstAS.RESET;
                          RstAS.SETCURRENTKEY(numeroMensaje, motivoAjuste); //EX-SGG-WMS 040719
                          RstAS.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA"); //EX-SGG-WNS 040719
                          RstAS.SETFILTER(motivoAjuste, '<>28&<>26');  //EX-SGG-WMS 010719
                          RstAS.SETRANGE(Integrado, FALSE); //EX-SGG-WNS 040719
                          IF RstAS.FINDSET THEN
                              REPEAT
                                  CLEAR(lError);
                                  ComprobacionesPreviasASySA(lRstLinDia, lRstControlWMS, RstAS.estadoCalidad, RstAS.claseStock, RstAS.codigoArticuloERP,
                                   RstAS.cantidad, lCantidadNAV, lCodProd, lCodVarProd, lCodAlmPpal, lFiltroAlmacen, lError, lDescError); //EX-SGG-WNS 040719

                                  IF NOT lError THEN BEGIN
                                      lnLinea := 10000;
                                      lRstLinDia.VALIDATE("Journal Template Name", RstConfAlm."Libro Diario Producto");
                                      lRstLinDia.VALIDATE("Journal Batch Name", RstConfAlm."Seccion Diario Producto");
                                      lRstLinDia.VALIDATE("Line No.", lnLinea);
                                      lRstLinDia.SetUpNewLine(lRstLinDia); //EX-SGG-WMS 290819
                                      lRstLinDia.INSERT(TRUE);
                                      lnLinea += 10000;
                                      IF RstAS.cantidad < 0 THEN
                                          lRstLinDia.VALIDATE("Entry Type", lRstLinDia."Entry Type"::"Negative Adjmt.")
                                      ELSE
                                          lRstLinDia.VALIDATE("Entry Type", lRstLinDia."Entry Type"::"Positive Adjmt.");
                                      lRstLinDia.VALIDATE("Posting Date", RstAS.fecha);
                                      lRstLinDia.VALIDATE("Item No.", lCodProd);
                                      lRstLinDia.VALIDATE("Variant Code", lCodVarProd);
                                      lRstLinDia.VALIDATE(Description, COPYSTR(lRstLinDia.Description + ' ' + RstAS.observaciones,
                                        1, MAXSTRLEN(lRstLinDia.Description)));
                                      //RstAS.codigoOrdenEntrada //EX-SGG-WMS 220719 NO SE HACE NADA.
                                      lRstLinDia.VALIDATE("Location Code", lCodAlmPpal);
                                      lRstLinDia.VALIDATE("Document No.", COPYSTR(RstAS.numeroMensaje, 1,
                                       MAXSTRLEN(lRstLinDia."Document No."))); //EX-SGG-WMS 281019
                                      lRstLinDia.MODIFY(TRUE);
                                      //EX-SGG-WMS 280619
                                      lCantidadSEGA := RstAS.cantidad;
                                      IF lCantidadSEGA > 0 THEN BEGIN
                                          lRstLinDia.VALIDATE(Quantity, ABS(lCantidadSEGA));
                                          lRstLinDia.MODIFY(TRUE);
                                      END
                                      ELSE BEGIN
                                          RstProd.RESET;
                                          RstProd.GET(lRstLinDia."Item No.");
                                          RstProd.SETRANGE("Variant Filter", lRstLinDia."Variant Code");
                                          RstProd.SETRANGE("Location Filter", lCodAlmPpal);
                                          RstProd.CALCFIELDS(Inventory);
                                          IF RstProd.Inventory > ABS(lCantidadSEGA) THEN BEGIN
                                              lRstLinDia.VALIDATE(Quantity, ABS(lCantidadSEGA));
                                              lRstLinDia.MODIFY(TRUE);
                                              lCantidadSEGA := 0;
                                          END
                                          ELSE
                                              IF RstProd.Inventory > 0 THEN BEGIN
                                                  lRstLinDia.VALIDATE(Quantity, RstProd.Inventory);
                                                  lRstLinDia.MODIFY(TRUE);
                                                  lCantidadSEGA += RstProd.Inventory;
                                              END;

                                          IF lCantidadSEGA < 0 THEN BEGIN
                                              RstAlmacen.RESET;
                                              RstAlmacen.SETFILTER(Code, lFiltroAlmacen);
                                              RstAlmacen.SETRANGE("Almacen principal SEGA", FALSE);
                                              IF RstAlmacen.FINDSET THEN
                                                  REPEAT
                                                      RstProd.SETRANGE("Location Filter", RstAlmacen.Code);
                                                      RstProd.CALCFIELDS(Inventory);
                                                      IF RstProd.Inventory > ABS(lCantidadSEGA) THEN BEGIN
                                                          IF lRstLinDia.Quantity <> 0 THEN BEGIN
                                                              lRstLinDia."Line No." := lnLinea;
                                                              lRstLinDia.INSERT(TRUE);
                                                              lnLinea += 10000;
                                                          END;
                                                          lRstLinDia.VALIDATE("Location Code", RstAlmacen.Code);
                                                          lRstLinDia.VALIDATE(Quantity, ABS(lCantidadSEGA));
                                                          lRstLinDia.MODIFY(TRUE);
                                                          lCantidadSEGA := 0;
                                                      END
                                                      ELSE
                                                          IF RstProd.Inventory > 0 THEN BEGIN
                                                              IF lRstLinDia.Quantity <> 0 THEN BEGIN
                                                                  lRstLinDia."Line No." := lnLinea;
                                                                  lRstLinDia.INSERT(TRUE);
                                                                  lnLinea += 10000;
                                                              END;
                                                              lRstLinDia.VALIDATE("Location Code", RstAlmacen.Code);
                                                              lRstLinDia.VALIDATE(Quantity, RstProd.Inventory);
                                                              lRstLinDia.MODIFY(TRUE);
                                                              lCantidadSEGA += RstProd.Inventory;
                                                          END;
                                                  UNTIL (RstAlmacen.NEXT = 0) OR (lCantidadSEGA = 0);
                                          END;
                                      END;
                                      //FIN EX-SGG-WMS 280619

                                  END;

                                  //EX-SGG-WMS 040719
                                  IntentaRegDiarioProductoASySA(lRstLinDia, lRstControlWMS, RstAS.identificadorAjuste,
                                   RstAS.Integrado, lAlgunError, lError, lDescError);
                                  RstAS.MODIFY(TRUE);

                                  COMMIT;
                              //FIN EX-SGG-WMS 040719

                              UNTIL RstAS.NEXT = 0;

                          //EX-SGG-WMS 010719 DEVOLUCIONES COMPRAS. 040620 observaciones=No. devol. SIN "DEV".
                          RstAS.SETRANGE(motivoAjuste, 26);
                          IF RstAS.FINDSET THEN
                           //EX-SGG-WMS 040620
                           BEGIN
                              CLEAR(lError);
                              AgruparRegistrosASDevolCompras(lRstControlWMS, lRstTMPAS, lRstTMPCabCompra, lError, lDescError);
                              IF NOT lError THEN BEGIN
                                  lRstTMPAS.RESET;
                                  IF lRstTMPCabCompra.FINDSET THEN
                                      REPEAT
                                          CLEAR(lError);
                                          lDescError := FORMAT(lRstControlWMS.Interface::"AS-Ajuste de Stock") +
                                           ' ' + lRstControlWMS."No. documento";
                                          IF RstCabCompra.GET(lRstTMPCabCompra."Document Type", lRstTMPCabCompra."No.") THEN BEGIN
                                              CLEAR(lCduLanzarPedCompra); //EX-SGG 170720
                                              lCduLanzarPedCompra.PerformManualReopen(RstCabCompra); //EX-SGG 170720
                                              RstLinCompra.RESET;
                                              RstLinCompra.SETRANGE("Document Type", RstCabCompra."Document Type");
                                              RstLinCompra.SETRANGE("Document No.", RstCabCompra."No.");
                                              RstLinCompra.SETRANGE(Type, RstLinCompra.Type::Item);
                                              lRstTMPAS.SETRANGE(observaciones, RstCabCompra."No.");
                                              lRstTMPAS.FINDSET;
                                              REPEAT
                                                  ObtenerCodigoArticuloERP(lRstTMPAS.codigoArticuloERP, lCodProd, lCodVarProd);
                                                  RstLinCompra.SETRANGE("No.", lCodProd);
                                                  RstLinCompra.SETRANGE("Variant Code", lCodVarProd);
                                                  IF RstLinCompra.FINDFIRST THEN BEGIN
                                                      CompruebaCantidadSEGAvsNAV(lRstTMPAS.cantidad, RstLinCompra.Quantity, FORMAT(lRstControlWMS.Interface),
                                                       lRstControlWMS."No. documento", lRstTMPAS.TABLENAME, FORMAT(RstLinCompra."Line No."),
                                                       RstLinCompra.TABLENAME, FORMAT(RstLinCompra."Line No."), 'Cantidad en ',
                                                       lError, lDescError);
                                                      IF NOT lError THEN BEGIN
                                                          RstLinCompra.VALIDATE(Quantity, lRstTMPAS.cantidad);
                                                          RstLinCompra.VALIDATE("Return Qty. to Ship", lRstTMPAS.cantidad);
                                                          RstLinCompra.MODIFY(TRUE);
                                                      END;
                                                  END
                                                  ELSE BEGIN
                                                      lError := TRUE;
                                                      lDescError += ':No se encuentra el SKU ' + lRstTMPAS.codigoArticuloERP + ' en la devolución ' + RstCabCompra."No.";
                                                  END;
                                              UNTIL (lRstTMPAS.NEXT = 0) OR lError;

                                              lCduLanzarPedCompra.PerformManualRelease(RstCabCompra); //EX-SGG 170720

                                              //EX-SGG-WMS 300620
                                              IF NOT lError THEN BEGIN
                                                  RstLinCompra.SETRANGE("No.");
                                                  RstLinCompra.SETRANGE("Variant Code");
                                                  IF RstLinCompra.FINDSET THEN
                                                      REPEAT
                                                          lRstTMPAS.SETRANGE(codigoArticuloERP,
                                                           DevuelveCodigoArticuloERP(RstLinCompra."No.", RstLinCompra."Variant Code"));
                                                          IF NOT lRstTMPAS.FINDFIRST THEN
                                                              RstLinCompra.DELETE(TRUE);
                                                      UNTIL RstLinCompra.NEXT = 0;
                                                  lRstTMPAS.SETRANGE(codigoArticuloERP);
                                                  lRstTMPAS.FINDFIRST;
                                                  RstCabCompra.VALIDATE("Posting Date", lRstTMPAS.fecha);
                                                  RstCabCompra.MODIFY;
                                                  COMMIT;
                                              END;
                                              //FIN EX-SGG-WMS 300620

                                              IF NOT lError THEN BEGIN
                                                  IF (RstConfAlm."Mensajes AS" = RstConfAlm."Mensajes AS"::"Obtener-procesar y registrar") OR
                                                    GUIALLOWED THEN BEGIN
                                                      CLEAR(lCduRegCompra);
                                                      RstCabCompra.Invoice := FALSE;
                                                      RstCabCompra.Ship := TRUE;
                                                      IF NOT lCduRegCompra.RUN(RstCabCompra) THEN BEGIN
                                                          lError := TRUE;
                                                          lDescError := COPYSTR(GETLASTERRORTEXT, 1, MAXSTRLEN(lDescError));
                                                          CLEARLASTERROR;
                                                      END;
                                                  END;

                                                  IF NOT lError THEN BEGIN
                                                      RstAS.SETRANGE(observaciones, RstCabCompra."No.");
                                                      RstAS.MODIFYALL(Integrado, TRUE);
                                                      RstAS.SETRANGE(observaciones);
                                                  END;
                                              END;

                                              IF lError THEN BEGIN
                                                  lAlgunError := TRUE;
                                                  InsertarRegistroLOG(lRstControlWMS, FALSE, lDescError);
                                              END;
                                          END
                                          ELSE BEGIN
                                              lAlgunError := TRUE;
                                              InsertarRegistroLOG(lRstControlWMS, FALSE,
                                               lDescError + ':No se encuentra la devolución de compra ' + lRstTMPCabCompra."No.");
                                          END;
                                      UNTIL lRstTMPCabCompra.NEXT = 0;
                              END
                              ELSE
                                  lAlgunError := TRUE;
                          END;
                          //FIN EX-SGG-WMS 040620

                          //EX-SGG-WMS 040719
                          IF lAlgunError THEN
                              lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Error)
                          ELSE
                              lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Integrado);
                          lRstControlWMS.VALIDATE("Fecha y hora procesado", CURRENTDATETIME);
                          lRstControlWMS.MODIFY(TRUE);
                          //FIN EX-SGG-WMS 040719

                      END;
                  lRstControlWMS.Interface::"SA-Stock Actual":  //EX-SGG-WMS 270619
                      BEGIN                                        //TO-DO PRODUCTOS SEGA QUE NO VENGAN INFORMADOS, DEJAR CON STOCK A 0
                          CLEAR(lAlgunError); //EX-SGG-WMS 040719
                          RstSA.RESET;
                          RstSA.SETRANGE(numeroMensaje, lRstControlWMS."Numero de mensaje SEGA"); //EX-SGG-WNS 040719
                          RstSA.SETRANGE(Integrado, FALSE); //EX-SGG-WNS 040719
                          IF RstSA.FINDSET THEN BEGIN
                              //EX-SGG-WMS 271119
                              lRstLinDia.RESET;
                              lRstLinDia.SETRANGE("Journal Template Name", RstConfAlm."Libro Diario Inventario");
                              lRstLinDia.SETRANGE("Journal Batch Name", RstConfAlm."Seccion Diario Inventario");
                              lRstLinDia.DELETEALL(TRUE);
                              COMMIT;
                              //FIN EX-SGG-WMS 271119
                              REPEAT
                                  CLEAR(lError);
                                  ComprobacionesPreviasASySA(lRstLinDia, lRstControlWMS, RstSA.estadoCalidad, RstSA.claseStock, RstSA.codigoArticuloERP,
                                   RstSA.cantidad, lCantidadNAV, lCodProd, lCodVarProd, lCodAlmPpal, lFiltroAlmacen, lError, lDescError); //EX-SGG-WNS 040719

                                  IF NOT lError THEN //EX-SGG-WMS 030719
                                      CompruebaNoIntegradosPreviosSA(lCodProd, lCodVarProd, RstSA.fecha, RstSA.identificadorStock, lError, lDescError);

                                  IF NOT lError THEN BEGIN
                                      RstProd.RESET;
                                      RstProd.SETRANGE("No.", lCodProd);
                                      //RstProd.SETRANGE("Location Filter",lFiltroAlmacen); //EX-SGG-WMS 280619
                                      RstProd.SETFILTER("Location Filter", lFiltroAlmacen); //EX-SGG-WMS 301019
                                      RstProd.SETRANGE("Variant Filter", lCodVarProd);
                                      CLEAR(lRptCalcInv);
                                      lRstLinDia.VALIDATE("Journal Template Name", RstConfAlm."Libro Diario Inventario");
                                      lRstLinDia.VALIDATE("Journal Batch Name", RstConfAlm."Seccion Diario Inventario");
                                      lRptCalcInv.SetItemJnlLine(lRstLinDia);
                                      lRptCalcInv.PfsSetFromPhysJournal(TRUE);
                                      //lRptCalcInv.InitializeRequest(RstSA.fecha,'',FALSE);
                                      lRptCalcInv.InitializeRequest(RstSA.fecha, '', TRUE); //EX-SGG-WMS 191219
                                      lRptCalcInv.ValidatePostingDate;
                                      lRptCalcInv.SetHideValidationDialog(TRUE); //EX-SGG-WMS 311019
                                      lRptCalcInv.USEREQUESTFORM(FALSE);
                                      lRptCalcInv.SETTABLEVIEW(RstProd);
                                      lRptCalcInv.RUN;
                                      //EX-SGG-WMS 280619
                                      lCantidadSEGA := RstSA.cantidad;
                                      lRstLinDia.SETRANGE("Item No.", lCodProd);
                                      lRstLinDia.SETRANGE("Variant Code", lCodVarProd);
                                      lRstLinDia.SETRANGE("Location Code", lCodAlmPpal); //EX-SGG-WMS 191219
                                      IF NOT lRstLinDia.FINDSET THEN BEGIN
                                          //EX-SGG-WMS 191219 COMENTO E INSERTO LIN ALM PPAL


                                          CLEAR(lIntAux);
                                          CLEAR(lCodAux);
                                          CLEAR(lDecAux);
                                          lRstLinDia.VALIDATE("Journal Template Name", RstConfAlm."Libro Diario Inventario");
                                          lRstLinDia.VALIDATE("Journal Batch Name", RstConfAlm."Seccion Diario Inventario");
                                          lRptCalcInv.SetItemJnlLine(lRstLinDia);
                                          lRptCalcInv.GetLocation(lCodAlmPpal);
                                          lRptCalcInv.InitializeRequest(RstSA.fecha, '', TRUE); //EX-SGG 060520
                                          lRptCalcInv.ValidatePostingDate; //EX-SGG 060520
                                          lRptCalcInv.InsertItemJnlLine(lCodProd, lCodVarProd, lIntAux, lCodAux, lCodAux, lDecAux, 0);
                                          //FIN EX-SGG-WMS 191219
                                      END
                                      ;//ELSE //EX-SGG-WMS 191219 COMENTO SIN ELSE
                                       //BEGIN //EX-SGG-WMS 191219 COMENTO
                                       //lRstLinDia.SETRANGE("Location Code"); //EX-SGG-WMS 191219 231219 COMENTO.
                                      lRstLinDia.SETFILTER("Location Code", lFiltroAlmacen); //EX-SGG-WMS 231219
                                      lRstLinDia.FINDSET; //EX-SGG-WMS 191219
                                      CLEAR(lCantidadNAV);
                                      REPEAT
                                          lCantidadNAV += lRstLinDia."Qty. (Calculated)";
                                      UNTIL lRstLinDia.NEXT = 0;
                                      lCantidadDif := lCantidadSEGA - lCantidadNAV;
                                      IF lCantidadDif <> 0 THEN BEGIN
                                          lRstLinDia.SETRANGE("Location Code", lCodAlmPpal);
                                          IF lRstLinDia.FINDFIRST THEN BEGIN
                                              IF lCantidadDif > 0 THEN BEGIN
                                                  //lRstLinDia.VALIDATE("Qty. (Phys. Inventory)",lCantidadSEGA);  //EX-SGG-WMS 240120 COMENTO.
                                                  lRstLinDia.VALIDATE("Qty. (Phys. Inventory)", lRstLinDia."Qty. (Calculated)" + lCantidadDif); //EX-SGG-WMS 240120
                                                  lCantidadDif := 0;
                                                  lRstLinDia.MODIFY(TRUE);
                                              END
                                              ELSE BEGIN
                                                  IF lRstLinDia."Qty. (Calculated)" < ABS(lCantidadDif) THEN
                                                      lRstLinDia.VALIDATE("Qty. (Phys. Inventory)", 0)
                                                  ELSE
                                                      lRstLinDia.VALIDATE("Qty. (Phys. Inventory)", lRstLinDia."Qty. (Calculated)" + lCantidadDif);
                                                  lRstLinDia.MODIFY(TRUE);
                                                  //lCantidadDif+=lRstLinDia."Qty. (Calculated)";
                                                  lCantidadDif += lRstLinDia.Quantity; //EX-SGG-WMS 191219
                                              END;
                                          END;

                                          IF lCantidadDif < 0 THEN BEGIN
                                              //lRstLinDia.SETFILTER("Location Code",'<>'+lCodAlmPpal); //EX-SGG-WMS 231219 COMENTO.
                                              lRstLinDia.SETFILTER("Location Code", '<>' + lCodAlmPpal + '&' + lFiltroAlmacen); //EX-SGG-WMS 231219
                                              IF lRstLinDia.FINDSET THEN
                                                  REPEAT
                                                      IF lRstLinDia."Qty. (Calculated)" < ABS(lCantidadDif) THEN
                                                          lRstLinDia.VALIDATE("Qty. (Phys. Inventory)", 0)
                                                      ELSE
                                                          lRstLinDia.VALIDATE("Qty. (Phys. Inventory)", lRstLinDia."Qty. (Calculated)" + lCantidadDif);
                                                      lRstLinDia.MODIFY(TRUE);
                                                      //lCantidadDif+=lRstLinDia."Qty. (Calculated)";
                                                      lCantidadDif += lRstLinDia.Quantity; //EX-SGG-WMS 191219
                                                  UNTIL (lRstLinDia.NEXT = 0) OR (lCantidadDif = 0);
                                          END;

                                      END;
                                      //END; //EX-SGG-WMS 191219 COMENTO

                                      IF (lCantidadDif <> 0) AND (NOT lError) THEN BEGIN
                                          lError := TRUE;
                                          lDescError := FORMAT(lRstControlWMS.Interface) +
                                           ': No ha sido posible asignar toda la cantidad SEGA al inventario para el producto' +
                                           lCodProd + ' variante ' + lCodVarProd;
                                          lRstLinDia.SETRANGE("Location Code"); //EX-SGG-WMS 271119
                                          lRstLinDia.DELETEALL(TRUE); //EX-SGG-WMS 271119
                                      END;
                                      //FIN EX-SGG-WMS 280619

                                  END;


                                  IF lError THEN
                                      InsertarRegistroLOG(lRstControlWMS, FALSE, lDescError);
                                  RstSA.Integrado := NOT lError;
                                  //FIN EX-SGG-WMS 271119

                                  RstSA.MODIFY(TRUE);

                              //COMMIT; //EX-SGG-WMS 271119 COMENTO.
                              //FIN EX-SGG-WMS 040719

                              UNTIL RstSA.NEXT = 0;
                          END;

                          //EX-SGG-WMS 241119
                          CLEAR(lError);
                          CLEAR(lDescError);
                          lRstLinDia.RESET;
                          lRstLinDia.SETRANGE("Journal Template Name", RstConfAlm."Libro Diario Inventario");
                          lRstLinDia.SETRANGE("Journal Batch Name", RstConfAlm."Seccion Diario Inventario");
                          IF NOT lRstLinDia.FINDFIRST THEN //EX-SGG-WMS 170420
                           BEGIN
                              lError := TRUE;
                              lDescError := FORMAT(lRstControlWMS.Interface) + ': No existen líneas para registrar en el ' +
                               'diario ' + RstConfAlm."Libro Diario Inventario" + ', sección ' + RstConfAlm."Seccion Diario Inventario";
                              InsertarRegistroLOG(lRstControlWMS, FALSE, lDescError);
                          END
                          ELSE //FIN EX-SGG-WMS 170420
                              IntentaRegDiarioProductoASySA(lRstLinDia, lRstControlWMS, lRstControlWMS."Id. SEGA",
                               RstSA.Integrado, lAlgunError, lError, lDescError);
                          //FIN EX-SGG-WMS 241119

                          //EX-SGG-WMS 040719
                          //IF lAlgunError THEN
                          IF lError THEN //EX-SGG-WMS 271119 NO SE CONTROL lAlgunError EN SA.
                              lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Error)
                          ELSE BEGIN
                              lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Integrado);
                              DescartarRegistrosPrevios(lRstControlWMS); //EX-SGG-WMS 040220
                          END;
                          lRstControlWMS.VALIDATE("Fecha y hora procesado", CURRENTDATETIME);
                          lRstControlWMS.MODIFY(TRUE);
                          //FIN EX-SGG-WMS 040719

                      END;
              END;
              COMMIT;
          UNTIL lRstControlWMS.NEXT = 0;
      END;
      */

    end;


    procedure ComunicarWSRegistrosControl(var lRstControlWMS: Record 50414)
    var
        // lXMLDoc: Automation;
        // lXMLDocRespuesta: Automation;
        // lXMLHttpConn: Automation;
        lFileSOAP: File;
        lFileXML: File;
        lOutStream: OutStream;
        lInStream: InStream;
        lc13: Char;
        lc10: Char;
        lBuffer: Text[1024];
        lStatusCode: Integer;
        lStatusDescription: Text[1024];
        lSoapenvTxt: Label 'http://schemas.xmlsoap.org/soap/envelope/';
        lErrorRespTXT: Label 'Could not get response.';
        lErrorConTXT: Label 'Could not establish connection.';
        lSOAPActionTXT: Label 'http://www.tecsidel.es/Service/importData';
        lContentTypeTXT: Label 'text/xml';
        lMetodoWS: Text[250];
        lNombreFichero: Text[1024];
        lx: Integer;
        lLongitudContenido: Integer;
        lErrorWS: Boolean;
        lDescRespWS: Text[250];
    begin

       /*
        //EX-SGG-WMS 180619
        IF GUIALLOWED THEN //EX-SGG-WMS 170919
            lRstControlWMS.SETRANGE(Interface, lRstControlWMS.Interface::"OE-Orden de Entrada", lRstControlWMS.Interface::"PE-Pedido");
        lRstControlWMS.SETRANGE(Estado, lRstControlWMS.Estado::Preparado);
        IF lRstControlWMS.FINDSET THEN BEGIN
            RstConfAlm.GET;
            RstConfAlm.TESTFIELD("URL integracion WS WMS");
            RstConfAlm.TESTFIELD("Ruta ficheros integracion WMS");
            lc13 := 13;
            lc10 := 10;
            REPEAT
                lMetodoWS := COPYSTR(FORMAT(lRstControlWMS.Interface), 1, 2);
                RstRef.GETTABLE(lRstControlWMS);
                RstVinculos.RESET;
                RstVinculos.SETRANGE("Record ID", RstRef.RECORDID);
                RstVinculos.FINDLAST;
                RstRef.CLOSE;
                lx := STRLEN(RstVinculos.URL1) + 1;
                REPEAT
                    lx -= 1;
                UNTIL COPYSTR(RstVinculos.URL1, lx, 1) = '\';
                lNombreFichero := COPYSTR(RstVinculos.URL1, lx + 1);
                lFileSOAP.CREATE(RstConfAlm."Ruta ficheros integracion WMS" + '\SOAP_' + lNombreFichero);
                lFileSOAP.CREATEOUTSTREAM(lOutStream);
                lOutStream.WRITETEXT('<?xml version="1.0" encoding="UTF-8"?>' + FORMAT(lc13) + FORMAT(lc10));
                lOutStream.WRITETEXT('<soapenv:Envelope xmlns:soapenv="' + lSoapenvTxt + '" ' +
                 //'xmlns:int="http://www.interfasesSEGAERP.com/">'+FORMAT(lc13)+FORMAT(lc10));
                 //EX-SGG-WMS 290819 CAMBIO ESPACIO NOMBRES SEGA DE int A tec
                 'xmlns:tec="http://www.tecsidel.es/">' + FORMAT(lc13) + FORMAT(lc10));
                lOutStream.WRITETEXT('<soapenv:Header/>' + FORMAT(lc13) + FORMAT(lc10));
                lOutStream.WRITETEXT('<soapenv:Body>' + FORMAT(lc13) + FORMAT(lc10));
                lOutStream.WRITETEXT('<tec:importData>' + FORMAT(lc13) + FORMAT(lc10));
                lOutStream.WRITETEXT('<tec:xml>');
                lOutStream.WRITETEXT('<![CDATA[' + FORMAT(lc13) + FORMAT(lc10));

                lFileXML.OPEN(RstVinculos.URL1);
                lFileXML.CREATEINSTREAM(lInStream);
                WHILE NOT lInStream.EOS DO BEGIN
                    lInStream.READTEXT(lBuffer, 1024);
                    lOutStream.WRITETEXT(lBuffer + FORMAT(lc13) + FORMAT(lc10));
                END;
                lFileXML.CLOSE;

                lOutStream.WRITETEXT(']]>' + FORMAT(lc13) + FORMAT(lc10));
                lOutStream.WRITETEXT('</tec:xml>' + FORMAT(lc13) + FORMAT(lc10));
                lOutStream.WRITETEXT('<tec:code>' + lMetodoWS + '</tec:code>' + FORMAT(lc13) + FORMAT(lc10));
                lOutStream.WRITETEXT('<tec:numMensaje>' + lRstControlWMS."Numero de mensaje SEGA" + '</tec:numMensaje>' +
                 FORMAT(lc13) + FORMAT(lc10)); //EX-SGG-WNS 160719
                lOutStream.WRITETEXT('</tec:importData>' + FORMAT(lc13) + FORMAT(lc10));
                lOutStream.WRITETEXT('</soapenv:Body>' + FORMAT(lc13) + FORMAT(lc10));
                lOutStream.WRITETEXT('</soapenv:Envelope>' + FORMAT(lc13) + FORMAT(lc10));
                lLongitudContenido := lFileSOAP.LEN;
                lFileSOAP.CLOSE;

                CLEAR(lXMLDoc);
                CREATE(lXMLDoc);
                CLEAR(lXMLHttpConn);
                CREATE(lXMLHttpConn);
                lXMLDoc.load(RstConfAlm."Ruta ficheros integracion WMS" + '\SOAP_' + lNombreFichero);
                lXMLHttpConn.open('POST', RstConfAlm."URL integracion WS WMS", FALSE);
                lXMLHttpConn.setRequestHeader('Content-Type', lContentTypeTXT);
                lXMLHttpConn.setRequestHeader('SOAPAction', lSOAPActionTXT);
                lXMLHttpConn.setRequestHeader('ContentLenght', FORMAT(lLongitudContenido));
                ERASE(RstConfAlm."Ruta ficheros integracion WMS" + '\SOAP_' + lNombreFichero); //DEBUG OFF
                                                                                               //lXMLHttpConn.setTimeouts(LONG resolveTimeout, LONG connectTimeout, LONG sendTimeout, LONG receiveTimeout)
                lXMLHttpConn.send(lXMLDoc);

                CLEAR(lXMLDocRespuesta);
                CREATE(lXMLDocRespuesta);
                IF NOT lXMLDocRespuesta.load(lXMLHttpConn.responseXML) THEN BEGIN
                    lErrorWS := TRUE;
                    lDescRespWS := COPYSTR(lErrorConTXT + ':' + GETLASTERRORTEXT, 1, MAXSTRLEN(lDescRespWS));
                    CLEARLASTERROR;
                END ELSE BEGIN
                    lStatusCode := lXMLHttpConn.status;
                    lStatusDescription := lXMLHttpConn.statusText;
                    IF lStatusCode <> 200 THEN BEGIN
                        lErrorWS := TRUE;
                        lDescRespWS := COPYSTR(FORMAT(lStatusCode) + ':' + lStatusDescription, 1, MAXSTRLEN(lDescRespWS));
                    END
                    ELSE
                        AnalizarRespuestaWS(lErrorWS, lDescRespWS, lXMLDocRespuesta);
                END;

                IF lErrorWS THEN BEGIN
                    InsertarRegistroLOG(lRstControlWMS, FALSE, lDescRespWS);
                    lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::Error);
                END
                ELSE BEGIN
                    lRstControlWMS.VALIDATE(Estado, lRstControlWMS.Estado::"Enviado WS");
                    //EX-SGG-WMS 260619
                    IF lRstControlWMS.Interface = lRstControlWMS.Interface::"PE-Pedido" THEN BEGIN
                        RstCabEnvAlm.GET(lRstControlWMS."No. documento");
                        RstCabEnvAlm.VALIDATE("Document Status", RstCabEnvAlm."Document Status"::"Enviado SEGA");
                        RstCabEnvAlm.MODIFY;
                    END;
                    //FIN EX-SGG-WMS 260619
                END;
                lRstControlWMS.VALIDATE("Fecha y hora enviado WS", CURRENTDATETIME);
                lRstControlWMS.MODIFY(TRUE);
                COMMIT;
            UNTIL lRstControlWMS.NEXT = 0;
        END;
        */
    end;


    //procedure AnalizarRespuestaWS(var lErrorWS: Boolean; var lDescRespWS: Text[250]; var lXMLDocRespuesta: Automation)
    procedure AnalizarRespuestaWS(var lErrorWS: Boolean; var lDescRespWS: Text[250]; var lXMLDocRespuesta: Boolean)
    var
        //lRstTMpBlob: Record 99008535 temporary;
        lInStr: InStream;
        lOutStr: OutStream;
        lBigTxt: BigText;
        lBigTxtAux: BigText;
        lEtiquetaIni: Text[30];
        lEtiquetaFin: Text[30];
        lValor: Text[1024];
    begin
        /*
        //EX-SGG-WMS 210619
        lRstTMpBlob.Blob.CREATEOUTSTREAM(lOutStr);
        lRstTMpBlob.Blob.CREATEINSTREAM(lInStr);
        lXMLDocRespuesta.save(lOutStr);
        lBigTxt.READ(lInStr);
        lEtiquetaIni := '&lt;errorcode&gt;';
        lEtiquetaFin := '&lt;/errorcode&gt;';
        IF (lBigTxt.TEXTPOS(lEtiquetaIni) <> 0) AND (lBigTxt.TEXTPOS(lEtiquetaFin) <> 0) THEN BEGIN
            lBigTxt.GETSUBTEXT(lBigTxtAux, lBigTxt.TEXTPOS(lEtiquetaIni) + STRLEN(lEtiquetaIni),
             lBigTxt.TEXTPOS(lEtiquetaFin) - (lBigTxt.TEXTPOS(lEtiquetaIni) + STRLEN(lEtiquetaIni)));
            lBigTxtAux.GETSUBTEXT(lValor, 1, MAXSTRLEN(lValor));
            lErrorWS := lValor <> '1';
            lEtiquetaIni := '&lt;error&gt;';
            lEtiquetaFin := '&lt;/error&gt;';
            IF (lBigTxt.TEXTPOS(lEtiquetaIni) <> 0) AND (lBigTxt.TEXTPOS(lEtiquetaFin) <> 0) THEN BEGIN
                lBigTxt.GETSUBTEXT(lBigTxtAux, lBigTxt.TEXTPOS(lEtiquetaIni) + STRLEN(lEtiquetaIni),
                  lBigTxt.TEXTPOS(lEtiquetaFin) - (lBigTxt.TEXTPOS(lEtiquetaIni) + STRLEN(lEtiquetaIni)));
                lBigTxtAux.GETSUBTEXT(lValor, 1, MAXSTRLEN(lValor));
                lDescRespWS := COPYSTR(lValor, 1, MAXSTRLEN(lDescRespWS));
            END;
        END
        ELSE BEGIN
            lErrorWS := TRUE;
            lDescRespWS := 'Error: No se ha podido analizar la respuesta';
        END;
        */
    end;


    procedure InsertarRegistroOE(var lRstCabRecepAlm: Record "Warehouse Receipt Header")
    var
        lnRegOE: Integer;
        locrec_WHshipmentline: Record "Warehouse Receipt Line";
    begin
        //EX-SGG-WMS 120619
        RstConfCompras.GET;
        RstLinRecepAlm.RESET;
        RstLinRecepAlm.SETRANGE("No.", lRstCabRecepAlm."No.");
        IF RstLinRecepAlm.FINDSET THEN BEGIN
            lnRegOE := UltimoNumeroRegistroOE + 1;
            CLEAR(RstOE);
            RstOE.INIT;
            RstOE.VALIDATE("No. registro", lnRegOE);
            RstOE.VALIDATE(tipoOperacion, 1);
            RstOE.VALIDATE(codigoOrdenEntrada, lRstCabRecepAlm."No.");

            //EX-SGG-WMS 110719
            /*
                CASE RstLinRecepAlm."Source Document" OF
                  RstLinRecepAlm."Source Document"::"Sales Order",RstLinRecepAlm."Source Document"::"Sales Return Order":
                   BEGIN
                    RstOE.VALIDATE(tipoOrdenEntrada,2);
                    RstOE.VALIDATE(tipoCentroOrigen,FORMAT(1));
                    CASE RstLinRecepAlm."Source Document" OF
                     RstLinRecepAlm."Source Document"::"Sales Order":
                      RstCabVenta.GET(RstCabVenta."Document Type"::Order,RstLinRecepAlm."Source No.");
                     RstLinRecepAlm."Source Document"::"Sales Return Order":
                      RstCabVenta.GET(RstCabVenta."Document Type"::"Return Order",RstLinRecepAlm."Source No.");
                    END;
                    RstOE.VALIDATE(codigoCentroOrigen,RstCabVenta."Sell-to Customer No.");
                   END;
                  RstLinRecepAlm."Source Document"::"Purchase Order",RstLinRecepAlm."Source Document"::"Purchase Return Order":
                   BEGIN
                    RstOE.VALIDATE(tipoOrdenEntrada,1);
                    RstOE.VALIDATE(tipoCentroOrigen,FORMAT(2));
                    CASE RstLinRecepAlm."Source Document" OF
                     RstLinRecepAlm."Source Document"::"Purchase Order":
                      BEGIN
                       RstCabCompra.GET(RstCabVenta."Document Type"::Order,RstLinRecepAlm."Source No.");
                       //EX-SGG-WMS 110719
                       RstAsignacionDirecta.RESET;
                       RstAsignacionDirecta.SETCURRENTKEY("Pedido de compra","Lin. pedido de compra");
                       RstAsignacionDirecta.SETRANGE("Pedido de compra",RstLinRecepAlm."Source No.");
                       RstAsignacionDirecta.SETRANGE("Lin. pedido de compra",RstLinRecepAlm."Source Line No.");
                       IF RstAsignacionDirecta.FINDFIRST THEN
                        RstOE.VALIDATE(tipoOrdenEntrada,3);
                       //FIN EX-SGG-WMS
                      END;
                     RstLinRecepAlm."Source Document"::"Purchase Return Order":
                      RstCabCompra.GET(RstCabVenta."Document Type"::"Return Order",RstLinRecepAlm."Source No.");
                    END;
                    RstOE.VALIDATE(codigoCentroOrigen,RstCabCompra."Buy-from Vendor No.");
                   END;
                END;
            */
            EVALUATE(RstOE.tipoOrdenEntrada, lRstCabRecepAlm."Tipo de Orden de Entrada");
            RstOE.VALIDATE(tipoOrdenEntrada);
            CASE lRstCabRecepAlm."Tipo origen" OF
                lRstCabRecepAlm."Tipo origen"::Cliente:
                    RstOE.VALIDATE(tipoCentroOrigen, FORMAT(1));
                lRstCabRecepAlm."Tipo origen"::Proveedor:
                    RstOE.VALIDATE(tipoCentroOrigen, FORMAT(2));
            END;
            //FIN EX-SGG-WMS 110719

            RstOE.VALIDATE(codigoCentroOrigen, lRstCabRecepAlm."Cod. origen"); //EX-SGG-WMS 150719
            RstOE.VALIDATE(fechaEntrega, WORKDATE);
            // RstOE.fechaVencimiento := CALCDATE(RstConfCompras."Fecha Vto orden", RstOE.fechaEntrega);
            RstOE.fechaVencimiento := CALCDATE(RstConfCompras."Fecha Vto orden entrada", RstOE.fechaEntrega);

            RstOE.VALIDATE(comentario, DevuelveComentarios(
              DATABASE::"Warehouse Receipt Header", RstOE.codigoOrdenEntrada, MAXSTRLEN(RstOE.comentario)));

            locrec_WHshipmentline.SETCURRENTKEY("Source Type", "Source Subtype", "Source No.", "Source Line No.");//EX-OMI 101219

            REPEAT
                //IF ((RstOE.tipoOrdenEntrada=2) AND EnviarASEGA(RstLinRecepAlm."Item No.",RstLinRecepAlm."Location Code")) //EX-SGG-WMS 020719
                // NM-CSA-200410                       // EX-SGG-WMS 020719
                IF ((RstOE.tipoOrdenEntrada IN [2, 4]) AND EnviarASEGA(RstLinRecepAlm."Item No.", RstLinRecepAlm."Location Code"))
                 OR (RstOE.tipoOrdenEntrada IN [1, 3]) THEN //EX-SGG-WMS 270619
                  BEGIN
                    RstOE.VALIDATE("No. registro", lnRegOE);
                    RstOE.VALIDATE(lineaOrdenEntrada, FORMAT(RstLinRecepAlm."Line No."));
                    RstOE.VALIDATE(codigoArticuloERP, DevuelveCodigoArticuloERP(RstLinRecepAlm."Item No.", RstLinRecepAlm."Variant Code"));
                    RstOE.VALIDATE(cantidad, RstLinRecepAlm.Quantity);
                    RstOE.VALIDATE(tolerancia, 0);
                    RstOE.VALIDATE(codigoOrdenCompraERP, RstLinRecepAlm."Source No.");
                    RstOE.VALIDATE(codigoDocumentoEntrada, RstLinRecepAlm."No. albaran proveedor");
                    RstOE.VALIDATE(estadoCalidad, DevuelveEstadoCalidadAlmacen(RstLinRecepAlm."Location Code"));
                    RstOE.VALIDATE(motivoDevolucion, '');

                    //EX-SGG-WMS 110719
                    CLEAR(RstOE.codigoEntregaERP);
                    CLEAR(RstOE.lineaEntregaERP);
                    CLEAR(RstOE.cantidadLineaEntregaERP);
                    IF RstOE.tipoOrdenEntrada = 3 THEN BEGIN
                        RstAsignacionDirecta.RESET;
                        RstAsignacionDirecta.SETRANGE("Nº Pedido Compra", RstLinRecepAlm."Source No.");
                        RstAsignacionDirecta.SETRANGE("Tipo Asignación", RstAsignacionDirecta."Tipo Asignación"::Directa);
                        RstAsignacionDirecta.SETRANGE("Nº Linea Pedido Compra", RstLinRecepAlm."Source Line No."); //EX-SGG-WMS 051219
                        IF RstAsignacionDirecta.FINDSET THEN
                            REPEAT
                                IF RstLinVenta.GET(RstLinVenta."Document Type"::Order, RstAsignacionDirecta."Nº Pedido Venta",
                                 RstAsignacionDirecta."Nº Linea Pedido Venta") THEN BEGIN
                                    RstOE.VALIDATE("No. registro", lnRegOE);

                                    //EX-OMI 101219
                                    //RstOE.VALIDATE(codigoEntregaERP,DevuelveCodigoArticuloERP(RstLinVenta."No.",RstLinVenta."Variant Code"));
                                    //RstOE.VALIDATE(lineaEntregaERP,FORMAT(RstLinVenta."Line No."));
                                    locrec_WHshipmentline.SETRANGE("Source Type", 37);
                                    locrec_WHshipmentline.SETRANGE("Source Subtype", locrec_WHshipmentline."Source Subtype"::"1");
                                    locrec_WHshipmentline.SETRANGE("Source No.", RstLinVenta."Document No.");
                                    locrec_WHshipmentline.SETRANGE("Source Line No.", RstLinVenta."Line No.");
                                    locrec_WHshipmentline.FINDFIRST;
                                    RstOE.VALIDATE(codigoEntregaERP, locrec_WHshipmentline."No.");
                                    RstOE.VALIDATE(lineaEntregaERP, FORMAT(locrec_WHshipmentline."Line No."));
                                    //EX-OMi fin

                                    RstOE.VALIDATE(cantidadLineaEntregaERP, RstLinVenta.Quantity);
                                    RstOE.INSERT(TRUE);
                                    lnRegOE += 1;
                                END;
                            UNTIL RstAsignacionDirecta.NEXT = 0;
                    END
                    //FIN EX-SGG-WMS 110719
                    ELSE //EX-SGG-WMS 021219
                     BEGIN
                        RstOE.INSERT(TRUE);
                        lnRegOE += 1;
                    END;
                END;
            UNTIL RstLinRecepAlm.NEXT = 0;
        END;

    end;


    procedure UltimoNumeroRegistroOE(): Integer
    var
        lRstOE: Record "WMS OE-Ordenes de Entrada";
    begin
        //EX-SGG-WMS 120619
        IF lRstOE.FINDLAST THEN
            EXIT(lRstOE."No. registro")
        ELSE
            EXIT(0);
    end;


    procedure EliminarRegistrosOE(lNoDoc: Code[20])
    begin
        //EX-SGG-WMS 190719
        RstOE.RESET;
        RstOE.SETCURRENTKEY(codigoOrdenEntrada);
        RstOE.SETRANGE(codigoOrdenEntrada, lNoDoc);
        RstOE.DELETEALL(TRUE);
    end;


    procedure InsertarRegistroPE(var lRstCabEnvAlm: Record "Warehouse Shipment Header")
    var
        lRstCli: Record Customer;
        lRstDirEnv: Record "Ship-to Address";
        lnRegPE: Integer;
    begin
        //EX-SGG-WMS 130619
        RstLinEnvAlm.RESET;
        RstLinEnvAlm.SETRANGE("No.", lRstCabEnvAlm."No.");
        IF RstLinEnvAlm.FINDSET THEN BEGIN
            lnRegPE := UltimoNumeroRegistroPE + 1;
            CLEAR(RstPE);
            RstPE.INIT;
            RstPE.VALIDATE("No. registro", lnRegPE);
            RstPE.VALIDATE(tipoOperacion, 1);
            RstPE.VALIDATE(codigoEntregaERP, lRstCabEnvAlm."No.");
            EVALUATE(RstPE.tipoEntrega, lRstCabEnvAlm."Tipo de entrega");
            RstPE.VALIDATE(tipoEntrega);
            RstPE.VALIDATE(CodigoPedidoERP, RstLinEnvAlm."Source No.");
            RstPE.VALIDATE(codigoPedidoCliente, lRstCabEnvAlm."External Document No.");
            //EX-SGG-WMS 110719
            CASE lRstCabEnvAlm."Tipo origen" OF
                lRstCabEnvAlm."Tipo origen"::Cliente:
                    RstPE.VALIDATE(tipoCentroDestino, FORMAT(1));
                lRstCabEnvAlm."Tipo origen"::Proveedor:
                    RstPE.VALIDATE(tipoCentroDestino, FORMAT(2));
            END;
            //FIN EX-SGG-WMS 110719
            RstPE.VALIDATE(codigoCentroDestino, lRstCabEnvAlm."Cod. origen");
            RstPE.VALIDATE(prioridad, 1);
            RstPE.VALIDATE(fechaGeneracion, WORKDATE);
            RstPE.VALIDATE(horaGeneracion, TIME);
            RstPE.VALIDATE(fechaServicio, lRstCabEnvAlm."Fecha servicio solicitada");
            RstPE.VALIDATE(codigoTipoRuta, lRstCabEnvAlm."Shipping Agent Service Code");
            RstPE.VALIDATE(observaciones, DevuelveComentarios(
              DATABASE::"Warehouse Shipment Header", RstPE.codigoEntregaERP, MAXSTRLEN(RstPE.observaciones)));
            RstPE.VALIDATE(requiereManipulacion, ObtenerValorAtributosTtoLogist(RstAtributos."Tipo documento"::Envio,
              lRstCabEnvAlm."No.", RstAtributos.FIELDNAME("Requiere manipulacion")) = 'S'); //EX-SGG-WMS 170719
            RstPE.VALIDATE(verificacionEnExpedicion, ObtenerValorAtributosTtoLogist(RstAtributos."Tipo documento"::Envio,
              lRstCabEnvAlm."No.", RstAtributos.FIELDNAME("Verificar expedicion")) = 'S'); //EX-SGG-WMS 170719
            RstPE.VALIDATE(codigoCliente, lRstCabEnvAlm."Cod. origen");

            //SF-JFC 150921 buscar el pedido de venta solo si la linea es de pedido
            IF (RstLinEnvAlm."Source Document" = RstLinEnvAlm."Source Document"::"Sales Order") THEN
                //SF-JFC 150921 buscar el pedido de venta solo si la linea es de pedido
                RstCabVenta.GET(RstCabVenta."Document Type"::Order, RstLinEnvAlm."Source No.");
            //SF-JFC 081121 buscar el pedido de venta si el envio almacen proviene de un pedido transferencia en consignacion
            IF (RstLinEnvAlm."Source Document" = RstLinEnvAlm."Source Document"::"Outbound Transfer") THEN
                LinTransfer.RESET;
            LinTransfer.SETFILTER(LinTransfer."Document No.", RstLinEnvAlm."Source No.");
            LinTransfer.SETRANGE(LinTransfer."Line No.", RstLinEnvAlm."Source Line No.");
            IF LinTransfer.FINDFIRST THEN
                RstCabVenta.GET(RstCabVenta."Document Type"::Order, LinTransfer."No. pedido");
            //SF-JFC 081121 buscar el pedido de venta si el envio almacen proviene de un pedido transferencia en consignacion

            IF lRstCabEnvAlm."Tipo de entrega" = '6' THEN  //EX-SGG-WMS 170719 ECI
             BEGIN
                //TODO JORGE
                //  RstSucursales.GET(RstCabVenta."Sell-to Customer No.", RstCabVenta."Cod sucursal destino");

                RstPE.VALIDATE(codigoCliente, RstPE.codigoCliente + '-' + RstSucursales.Codigo); //EX-SGG-WMS 190919 DESCOMENTO.
                                                                                                 //RstPE.VALIDATE(codigoCliente,RstPE.codigoCliente+'-'+RstCabVenta."EDI Depto/Dpto"); //EX-SGG-WMS 230719 CORRECCION 190919 COM.
                                                                                                 //TODO JORGE
                                                                                                 //     RstPE.VALIDATE(departamentoCliente, RstCabVenta."EDI Depto/Dpto" + '-00');
                                                                                                 //EX-SGG-WMS 190919
                RstPE.VALIDATE(nombreCliente, RstSucursales.Nombre);
                RstPE.VALIDATE(direccionCliente, RstSucursales.Address);
                RstPE.VALIDATE(direccionCliente2, RstSucursales."Address 2");
                RstPE.VALIDATE(ciudadCliente, RstSucursales.City);
                //RstPE.VALIDATE(provinciaCliente,RstSucursales.County);
                RstPE.VALIDATE(provinciaCliente, COPYSTR(RstSucursales.County, 1, MAXSTRLEN(RstPE.provinciaCliente))); //EX-SGG-WMS 300919
                RstPE.VALIDATE(codigoPostalCliente, RstSucursales."Post Code");
                RstPE.VALIDATE(paisCliente, RstSucursales."Country/Region Code");
                //FIN EX-SGG-WMS
            END
            ELSE //EX-SGG-WMS 190919
             BEGIN
                //EX-SGG-WMS 170719
                RstPE.VALIDATE(nombreCliente, lRstCabEnvAlm."Sell-to Customer Name" + lRstCabEnvAlm."Sell-to Customer Name 2");
                RstPE.VALIDATE(direccionCliente, lRstCabEnvAlm."Sell-to Address");
                RstPE.VALIDATE(direccionCliente2, lRstCabEnvAlm."Sell-to Address 2"); //EX-SGG-WMS 300719
                RstPE.VALIDATE(ciudadCliente, lRstCabEnvAlm."Sell-to City");
                //RstPE.VALIDATE(provinciaCliente,lRstCabEnvAlm."Sell-to County");
                RstPE.VALIDATE(provinciaCliente, COPYSTR(lRstCabEnvAlm."Sell-to County", 1,
                 MAXSTRLEN(RstPE.provinciaCliente))); //EX-SGG-WMS 300919 281119
                RstPE.VALIDATE(codigoPostalCliente, lRstCabEnvAlm."Sell-to Post Code");
                RstPE.VALIDATE(paisCliente, lRstCabEnvAlm."Sell-to Country/Region Code");
            END;
            //RstPE.VALIDATE(nombreReceptor,lRstCabEnvAlm."Ship-to Name"+lRstCabEnvAlm."Ship-to Name 2"); HOTFIX NM-CSA-220803
            IF lRstCabEnvAlm."Tipo de entrega" = '2' THEN // E-commerce, no concatenar
                RstPE.VALIDATE(nombreReceptor, lRstCabEnvAlm."Ship-to Name")
            ELSE
                RstPE.VALIDATE(nombreReceptor, lRstCabEnvAlm."Ship-to Name" + lRstCabEnvAlm."Ship-to Name 2");

            RstPE.VALIDATE(direccionReceptor, lRstCabEnvAlm."Ship-to Address");
            RstPE.VALIDATE(direccionReceptor2, lRstCabEnvAlm."Ship-to Address 2"); //EX-SGG-WMS 300719
            RstPE.VALIDATE(ciudadReceptor, lRstCabEnvAlm."Ship-to City");
            //RstPE.VALIDATE(provinciaReceptor,lRstCabEnvAlm."Ship-to County");
            RstPE.VALIDATE(provinciaReceptor, COPYSTR(lRstCabEnvAlm."Ship-to County", 1, MAXSTRLEN(RstPE.provinciaReceptor)));
            //EX-SGG-WMS 300919
            RstPE.VALIDATE(codigoPostalReceptor, lRstCabEnvAlm."Ship-to Post Code");
            RstPE.VALIDATE(paisReceptor, lRstCabEnvAlm."Ship-to Country/Region Code");
            RstPE.VALIDATE(tipoContenedor, ObtenerValorAtributosTtoLogist(RstAtributos."Tipo documento"::Envio,
              lRstCabEnvAlm."No.", RstAtributos.FIELDNAME("Caja anonima")));
            //FIN EX-SGG-WMS 170719
            lRstCli.GET(RstCabVenta."Sell-to Customer No.");
            //EX-SGG-WMS 021219
            // IF RstCabVenta."Pedido Magento" THEN
            //     RstPE.VALIDATE(telefonoReceptor, RstCabVenta."Ship-to Contact")
            // ELSE
            //FIN EX-SGG-WMS 021219
            //EX-SGG-WMS 071019
            IF RstCabVenta."Ship-to Code" <> '' THEN BEGIN
                lRstDirEnv.GET(RstCabVenta."Sell-to Customer No.", RstCabVenta."Ship-to Code");
                RstPE.VALIDATE(telefonoReceptor, lRstDirEnv."Phone No.");
            END
            ELSE BEGIN
                RstPE.VALIDATE(telefonoReceptor, lRstCli."Phone No.");
            END;
            //FIN EX-SGG-WMS 071019

            //EX-SGG-WMS 050220
            IF STRLEN(lRstCli."Language Code") < 2 THEN
                RstPE.VALIDATE(idiomaDocumentacion, 'ES')
            ELSE
                RstPE.VALIDATE(idiomaDocumentacion, COPYSTR(lRstCli."Language Code", 1, 2));
            IF NOT (RstPE.idiomaDocumentacion IN ['ES', 'EN', 'FR', 'IT']) THEN
                RstPE.VALIDATE(idiomaDocumentacion, 'ES');
            //FIN EX-SGG-WMS 050220

            IF EnviarASEGA(RstLinEnvAlm."Item No.", RstLinEnvAlm."Location Code") THEN //EX-SGG-WMS 020719
                REPEAT
                    RstPE.VALIDATE("No. registro", lnRegPE);
                    RstPE.VALIDATE(lineaEntregaERP, FORMAT(RstLinEnvAlm."Line No."));
                    RstPE.VALIDATE(codigoArticuloERP, DevuelveCodigoArticuloERP(RstLinEnvAlm."Item No.", RstLinEnvAlm."Variant Code"));
                    RstPE.VALIDATE(cantidad, RstLinEnvAlm.Quantity);
                    RstPE.VALIDATE(claseStock, 1);
                    RstPE.VALIDATE(indicadorPersonalizado, (ObtenerValorAtributosTtoLogist(RstAtributos."Tipo documento"::Envio,
                      lRstCabEnvAlm."No.", RstAtributos.FIELDNAME("Indicador personalizado")) = 'S') OR //); //EX-SGG-WMS 170719 291119
                      (EsLineaAsignacionDirecta(RstLinEnvAlm.TABLENAME, RstLinEnvAlm."Source No.", RstLinEnvAlm."Source Line No.")));
                    //EX-SGG 291119
                    RstPE.VALIDATE(prepararMonoArticulo, ObtenerValorAtributosTtoLogist(RstAtributos."Tipo documento"::Envio,
                      lRstCabEnvAlm."No.", RstAtributos.FIELDNAME("Preparacion mono referencia")) = 'S'); //EX-SGG-WMS 170719
                    RstPE.INSERT(TRUE);
                    lnRegPE += 1;
                UNTIL RstLinEnvAlm.NEXT = 0
            //EX-SGG-WMS 070220
            //TODO JORGE
            // ELSE
            //     IF (NOT RstAlmacen."Stock no gestionado por SEGA") AND EsAlmacenSEGA(RstAlmacen.Code) AND
            //  (RstAlmacen."Estado Stock SEGA" = '2') THEN //EX-SGG 280420
            //         RstPE.INSERT(TRUE);
            //FIN EX-SGG-WMS 070220
        END;
    end;


    procedure UltimoNumeroRegistroPE(): Integer
    var
        lRstPE: Record "WMS PE-Pedidos";
    begin
        //EX-SGG-WMS 130619
        IF lRstPE.FINDLAST THEN
            EXIT(lRstPE."No. registro")
        ELSE
            EXIT(0);
    end;


    procedure EliminarRegistrosPE(lNoDoc: Code[20])
    begin
        //EX-SGG-WMS 190719
        RstPE.RESET;
        RstPE.SETCURRENTKEY(codigoEntregaERP);
        RstPE.SETRANGE(codigoEntregaERP, lNoDoc);
        RstPE.DELETEALL(TRUE);
    end;


    procedure InsertarRegistroLOG(var lRstControlWMS: Record "50414"; lRespuestaSEGA: Boolean; lDescError: Text[250])
    begin
        //EX-SGG-WMS 180619
        CLEAR(RstLOG);
        RstLOG.INIT;
        RstLOG.VALIDATE("No. registro", UltimoNumeroRegistroLOG() + 1);
        RstLOG.VALIDATE(Interface, lRstControlWMS.Interface);
        RstLOG.VALIDATE("Tipo documento", lRstControlWMS."Tipo documento");
        RstLOG.VALIDATE("No. documento", lRstControlWMS."No. documento");
        RstLOG.VALIDATE("Id. WMS", lRstControlWMS."Id. SEGA");
        RstLOG.VALIDATE("Fecha y hora", CURRENTDATETIME);
        RstLOG.VALIDATE(Descripcion, lDescError);
        RstLOG.VALIDATE("No. registro control rel.", lRstControlWMS."No. registro");
        RstLOG.VALIDATE("Respuesta SEGA", lRespuestaSEGA); //EX-SGG-WMS 280819
        RstLOG.INSERT(TRUE);
    end;


    procedure UltimoNumeroRegistroLOG(): Integer
    var
        lRstLOG: Record "WMS Log de errores";
    begin
        //EX-SGG-WMS 180619
        IF lRstLOG.FINDLAST THEN
            EXIT(lRstLOG."No. registro")
        ELSE
            EXIT(0);
    end;


    procedure DevuelveComentarios(lIdTabla: Integer; lNoDoc: Code[20]; lLongitudMax: Integer) lComentarios: Text[250]
    var
        lRstComentarios: Record "5770";
    begin
        //EX-SGG-WMS 120619
        CASE lIdTabla OF
            DATABASE::"Warehouse Receipt Header":
                lRstComentarios.SETRANGE("Table Name", lRstComentarios."Table Name"::"Whse. Receipt");
            DATABASE::"Warehouse Shipment Header":
                lRstComentarios.SETRANGE("Table Name", lRstComentarios."Table Name"::"Whse. Shipment");
        END;
        IF lLongitudMax > MAXSTRLEN(lComentarios) THEN
            lLongitudMax := MAXSTRLEN(lComentarios);
        lRstComentarios.SETRANGE(Type, lRstComentarios.Type::" ");
        lRstComentarios.SETRANGE("No.", lNoDoc);
        IF lRstComentarios.FINDSET THEN
            REPEAT
                lComentarios += COPYSTR(lRstComentarios.Comment, 1, lLongitudMax);
                lLongitudMax -= STRLEN(COPYSTR(lRstComentarios.Comment, 1, lLongitudMax));
            UNTIL (lRstComentarios.NEXT = 0) OR (lLongitudMax <= 0)
    end;


    procedure DevuelveCodigoArticuloERP(lCodProd: Code[20]; lCodVar: Code[10]): Text[250]
    begin
        //EX-SGG-WMS 120619
        EXIT(lCodProd + '-' + lCodVar);
    end;


    procedure ObtenerCodigoArticuloERP(lCodArtERP: Text[30]; var lCodProd: Code[20]; var lCodVarProd: Code[10])
    var
        lLong: Integer;
    begin
        //EX-SGG-WMS 280819 COMENTO Y REHAGO. SEGUN CONFIG VERTICAL SON LONGITUDES MAXIMAS.
        /*
        //EX-SGG-WMS 260619
        RstPfsSetup.GET;
        RstPfsSetup.TESTFIELD("Variant Vert Component Length");
        RstPfsSetup.TESTFIELD("Variant Horz Component Length");
        RstPfsSetup.TESTFIELD("Variant Seperator");
        lLong:=RstPfsSetup."Variant Vert Component Length"+STRLEN(RstPfsSetup."Variant Seperator")+
                 RstPfsSetup."Variant Horz Component Length";
        IF STRLEN(lCodArtERP)>lLong THEN
         BEGIN
          lCodProd:=COPYSTR(lCodArtERP,1,STRLEN(lCodArtERP)-lLong-1);
          lCodVarProd:=COPYSTR(lCodArtERP,STRLEN(lCodArtERP)-lLong+1);
         END;
        */
        IF (STRPOS(lCodArtERP, '-') > 0) AND (STRLEN(lCodArtERP) > STRPOS(lCodArtERP, '-') + 1) THEN BEGIN
            lCodProd := COPYSTR(lCodArtERP, 1, STRPOS(lCodArtERP, '-') - 1);
            lCodVarProd := COPYSTR(lCodArtERP, STRPOS(lCodArtERP, '-') + 1);
        END;

    end;


    procedure DevuelveEstadoCalidadAlmacen(lCodAlmacen: Code[10]) lEstadoCalidad: Integer
    begin
        //EX-SGG-WMS 120619
        RstAlmacen.GET(lCodAlmacen);
        IF RstAlmacen."Estado Calidad SEGA" <> '' THEN
            EVALUATE(lEstadoCalidad, RstAlmacen."Estado Calidad SEGA");
    end;


    procedure EsAlmacenSEGA(lCodAlmacen: Code[10]): Boolean
    begin
        //EX-SGG-WMS 270619
        IF RstAlmacen.GET(lCodAlmacen) THEN
            //EXIT((RstAlmacen."Estado Stock SEGA"<>'') AND (RstAlmacen."Estado Calidad SEGA"<>''));
            //EX-SGG-WMS 060919
            //  EXIT((RstAlmacen."Estado Stock SEGA" <> '') AND (RstAlmacen."Estado Calidad SEGA" <> '') AND
            exit((RstAlmacen."Clase de Stock SEGA" <> '') AND (RstAlmacen."Estado Calidad SEGA" <> '') AND
         // (NOT RstAlmacen."Stock no gestionado por SEGA"));
         //TODO JORGE
         (NOT true));
    end;


    procedure EsProductoSEGA(lCodProd: Code[20]): Boolean
    begin
        //EX-SGG-WMS 020719
        RstProd.GET(lCodProd);
        EXIT(RstProd."Producto SEGA");
    end;


    procedure EsUsuarioSEGA(lCodUsuario: Code[20]): Boolean
    begin
        //EX-SGG-WMS 230719
        IF RstConfUsuarios.GET(lCodUsuario) THEN
            EXIT(RstConfUsuarios."Usuario SEGA");
    end;


    procedure EnviarASEGA(lCodProd: Code[20]; lCodAlmacen: Code[10]): Boolean
    begin
        // //EX-SGG-WMS 020719
        // RstAlmacen.GET(lCodAlmacen);
        // //IF EsProductoSEGA(lCodProd) AND (NOT RstAlmacen."Stock no gestionado por SEGA") AND EsAlmacenSEGA(RstAlmacen.Code) THEN
        // IF (NOT RstAlmacen."Stock no gestionado por SEGA") AND EsAlmacenSEGA(RstAlmacen.Code) THEN //EX-SGG-WMS 191219
        //     EXIT(RstAlmacen."Estado Stock SEGA" <> '2'); //RETIRADO
    end;


    procedure CompruebaCantidadSEGAvsNAV(lCantSEGA: Integer; lCantNAV: Integer; lInterface: Text[30]; lNoDoc: Code[20]; lNomTblSEGA: Text[30]; lLinTblSEGA: Text[30]; lNomTblNAV: Text[30]; lLinTblNAV: Text[30]; lTxtVariable: Text[30]; var lError: Boolean; var lDescError: Text[250])
    begin
        //EX-SGG-WMS 280920
        CASE TRUE OF
            lCantSEGA > lCantNAV:
                BEGIN
                    lError := TRUE;
                    lDescError := COPYSTR(lInterface + ' ' + lNoDoc + ':' + lTxtVariable + lNomTblSEGA + '(' + FORMAT(lCantSEGA) + ') ' +
                                ' en linea ' + lLinTblSEGA + ' no debe ser mayor que en ' + lNomTblNAV + '(' + FORMAT(lCantNAV) + ')' +
                                ' en linea ' + lLinTblNAV, 1, MAXSTRLEN(lDescError));
                END;
            ((lCantSEGA > 0) AND (lCantNAV < 0)) OR ((lCantSEGA < 0) AND (lCantNAV > 0)):
                BEGIN
                    lError := TRUE;
                    lDescError := COPYSTR(lInterface + ' ' + lNoDoc + ':' + lTxtVariable + lNomTblSEGA + '(' + FORMAT(lCantSEGA) + ') ' +
                                ' en linea ' + lLinTblSEGA + ' debe tener el mismo signo que en ' + lNomTblNAV + '(' + FORMAT(lCantNAV) + ')' +
                                ' en linea ' + lLinTblNAV, 1, MAXSTRLEN(lDescError));
                END;

        END;
    end;


    procedure CompruebaCantProdYVar(lInterface: Text[30]; lCantidad: Decimal; lCodProd: Code[20]; lCodVarProd: Code[10]; lCodAlmacen: Code[10]; lFiltroAlmacenesSEGA: Text[250]; var lCantidadNAV: Decimal; var lError: Boolean; var lDescError: Text[250])
    var
        lRstProd: Record "ITEM";
        lRstVarProd: Record "Item Variant";
        //lCduPfsControl: Codeunit "11006100";
        dummyCtrl: Record "50414";
        txtInterfaceSA: Text[30];
    begin
        //EX-SGG-WMS 280619 AGREGO PARAMETROS PARA FILTRO ALMACENES SEGA Y CANTIDAD NAV.
        //EX-SGG-WMS 260619

        // Truco 20210916-NM-CSA para comparar TXT de Option
        dummyCtrl.Interface := dummyCtrl.Interface::"SA-Stock Actual";
        txtInterfaceSA := FORMAT(dummyCtrl.Interface);
        CLEAR(dummyCtrl);

        RstProd.RESET;
        IF NOT RstProd.GET(lCodProd) THEN
            lDescError := COPYSTR(lInterface + ': No se encuentra el producto ' + lCodProd, 1, MAXSTRLEN(lDescError))
        //EX-SGG-WMS 060919 COMENTO.
        /*
        ELSE IF NOT lCduPfsControl.CheckItemStatus(RstProd."PfsItem Status",'Z') THEN
         lDescError:=COPYSTR(lInterface+': El producto '+RstProd."No."+' tiene el estado '+RstProd."PfsItem Status"
                      ,1,MAXSTRLEN(lDescError))
        */
        ELSE
            IF NOT lRstVarProd.GET(RstProd."No.", lCodVarProd) THEN
                lDescError := COPYSTR(lInterface + ': No se encuentra la variante ' + lCodVarProd + ' para el producto ' +
                               lCodProd, 1, MAXSTRLEN(lDescError))
            //EX-SGG-WMS 060919 COMENTO.
            /*
            ELSE IF NOT lCduPfsControl.CheckItemStatus(lRstVarProd."PfsItem Status",'Z') THEN
             lDescError:=COPYSTR(lInterface+': La variante '+lRstVarProd.Code+' del producto '+RstProd."No."+
                          ' tiene el estado '+lRstVarProd."PfsItem Status",1,MAXSTRLEN(lDescError))
            */
            ELSE
                IF NOT RstAlmacen.GET(lCodAlmacen) THEN
                    lDescError := COPYSTR(lInterface + ': No existe el almacén ' + lCodAlmacen, 1, MAXSTRLEN(lDescError))
                ELSE
                    IF (lCantidad = 0) AND (lInterface <> txtInterfaceSA) THEN //EX-SGG-WMS 280720 // 20210916-NM-CSA (txtInterfaceSA)
                        lDescError := COPYSTR(lInterface + ': La cantidad para la variante ' + lCodVarProd + ' y el producto ' +
                                       lCodProd + ' no puede ser 0', 1, MAXSTRLEN(lDescError))
                    ELSE
                        IF lCantidad < 0 THEN BEGIN
                            RstProd.SETFILTER("Location Filter", lFiltroAlmacenesSEGA);
                            RstProd.SETRANGE("Variant Filter", lRstVarProd.Code);
                            RstProd.CALCFIELDS(Inventory);
                            IF ABS(lCantidad) > RstProd.Inventory THEN
                                lDescError := COPYSTR(lInterface + ': No es posible realizar un ajuste negativo por más cantidad de la existente ' +
                                             'para el producto ' + lCodProd + ', variante ' + lCodVarProd + '(' + FORMAT(RstProd.Inventory) + FORMAT(lCantidad)
                                             , 1, MAXSTRLEN(lDescError));
                            lCantidadNAV := RstProd.Inventory;
                        END;
        lError := lDescError <> '';

    end;


    procedure ObtenerAlmacenPpalEstadosSEGA(lInterface: Text[30]; lestadoCalidad: Integer; lclaseStock: Integer; var lCodAlmacen: Code[20]; var lError: Boolean; var lDescError: Text[250])
    begin
        //EX-SGG-WMS 260619
        RstAlmacen.RESET;
        //  RstAlmacen.SETRANGE("Estado Stock SEGA", FORMAT(lclaseStock));
        RstAlmacen.SETRANGE("Clase de Stock SEGA", FORMAT(lclaseStock));
        RstAlmacen.SETRANGE("Estado Calidad SEGA", FORMAT(lestadoCalidad));
        RstAlmacen.SETRANGE("Almacen principal SEGA", TRUE);
        IF RstAlmacen.FINDFIRST THEN
            lCodAlmacen := RstAlmacen.Code
        ELSE BEGIN
            lError := TRUE;
            lDescError := COPYSTR(lInterface + ': No existe almacen ppal SEGA con clase stock ' + FORMAT(lclaseStock) +
             ' y estado calidad ' + FORMAT(lestadoCalidad), 1, MAXSTRLEN(lDescError));
        END;
    end;


    procedure ObtenerFiltroAlmacenesSEGA(lestadoCalidad: Integer; lclaseStock: Integer; var lFiltroAlmacenesSEGA: Text[250])
    begin
        //EX-SGG-WMS 280619
        CLEAR(lFiltroAlmacenesSEGA);
        RstAlmacen.RESET;
        //RstAlmacen.SETRANGE("Estado Stock SEGA", FORMAT(lclaseStock));
        RstAlmacen.SETRANGE("Clase de Stock SEGA", FORMAT(lclaseStock));

        RstAlmacen.SETRANGE("Estado Calidad SEGA", FORMAT(lestadoCalidad));
        // RstAlmacen.SETRANGE("Stock no gestionado por SEGA", FALSE); //EX-SGG-WMS 060919
        RstAlmacen.FINDSET;
        REPEAT
            lFiltroAlmacenesSEGA += RstAlmacen.Code + '|';
        UNTIL RstAlmacen.NEXT = 0;
        lFiltroAlmacenesSEGA := COPYSTR(lFiltroAlmacenesSEGA, 1, STRLEN(lFiltroAlmacenesSEGA) - 1);
    end;


    procedure DevuelveAlmacenPredetSEGA(): Code[10]
    begin
        //EX-SGG-WMS 020919
        RstConfAlm.GET;
        RstConfAlm.TESTFIELD("Almacen predet. SEGA");
        EXIT(RstConfAlm."Almacen predet. SEGA");
    end;


    procedure DocumentoEliminadoEnSEGA(var lRstControlWMS: Record "50414")
    var
        lCduRelease: Codeunit "7310";
        lPregunta: Text[1024];
        respControl: Record "50414";
    begin
        //EX-SGG-WMS 311019
        // lRstControlWMS.TESTFIELD(Estado,lRstControlWMS.Estado::Error); NM-CSA-191205
        IF NOT (lRstControlWMS.Interface IN [lRstControlWMS.Interface::"PE-Pedido", lRstControlWMS.Interface::"OE-Orden de Entrada"]) THEN
            ERROR('Esta acción solo puede realizarse para interfaces tipo ' + FORMAT(lRstControlWMS.Interface::"OE-Orden de Entrada") +
             ' y ' + FORMAT(lRstControlWMS.Interface::"PE-Pedido"));
        lPregunta := '¿Está seguro de que el documento ' + lRstControlWMS."No. documento" + ' está eliminado en SEGA ' +
         'y debe también eliminarse en el Control de Integración?';
        IF NOT CONFIRM(lPregunta, FALSE) THEN ERROR('Eliminación cancelada');
        IF NOT CONFIRM('Esta acción también dejará el documento original abierto, pero no lo eliminará.\\' + lPregunta, FALSE) THEN
            ERROR('Eliminación cancelada');

        // NM-CSA-191205
        IF (lRstControlWMS.Estado <> lRstControlWMS.Estado::Error) THEN
            IF NOT CONFIRM('El documento "' + lRstControlWMS."No. documento" + '" no se encuentra en estado ERROR.' +
              '\\¿Se ha asegurado de que está anulado en SEGA y debe eliminarse de este Control?', FALSE) THEN
                ERROR('Eliminación cancelada')
;

        CASE lRstControlWMS."Tipo documento" OF
            lRstControlWMS."Tipo documento"::"Envio almacen":
                BEGIN
                    // NM-CSA-191205
                    respControl.RESET;
                    respControl.SETRANGE(Interface, respControl.Interface::"CS-Confirmacion de Salida");
                    respControl.SETRANGE("No. documento", lRstControlWMS."No. documento");
                    IF respControl.FINDFIRST THEN ERROR('No es posible eliminar un documento para el que ya se ha recibido un mensaje CS.');
                    // FIN NM-CSA-191205
                    RstCabEnvAlm.GET(lRstControlWMS."No. documento");
                    RstCabEnvAlm."Document Status" := RstCabEnvAlm."Document Status"::" ";
                    RstCabEnvAlm.Obtenido := FALSE;
                    lCduRelease.Reopen(RstCabEnvAlm);
                    lRstControlWMS.Estado := lRstControlWMS.Estado::Pendiente;
                    lRstControlWMS.DELETE(TRUE);
                END;
            lRstControlWMS."Tipo documento"::"Recepcion almacen":
                BEGIN
                    // NM-CSA-191205
                    respControl.RESET;
                    respControl.SETRANGE(Interface, respControl.Interface::"CE-Confirmacion de Entrada");
                    respControl.SETRANGE("No. documento", lRstControlWMS."No. documento");
                    IF respControl.FINDFIRST THEN ERROR('No es posible eliminar un documento para el que ya se ha recibido un mensaje CE.');
                    // FIN NM-CSA-191205
                    RstCabRecepAlm.GET(lRstControlWMS."No. documento");
                    RstCabRecepAlm.Obtenido := FALSE;
                    RstCabRecepAlm.Status := RstCabRecepAlm.Status::Open;
                    RstCabRecepAlm.MODIFY;
                    RstLinRecepAlm.RESET;
                    RstLinRecepAlm.SETRANGE("No.", RstCabRecepAlm."No.");
                    //  RstLinRecepAlm.MODIFYALL("Estado cabecera", RstCabRecepAlm.Status);
                    lRstControlWMS.Estado := lRstControlWMS.Estado::Pendiente;
                    lRstControlWMS.DELETE(TRUE);
                END;
            ELSE
                ERROR('Esta acción solo puede realizarse para tipos de documento ' + FORMAT(lRstControlWMS."Tipo documento"::"Recepcion almacen")
               +
                 ' y ' + FORMAT(lRstControlWMS."Tipo documento"::"Envio almacen"));
        END;
    end;


    procedure CopiarAtributosTtoLogistico(lOptDe: Option Cliente,Pedido,Envio; lOptA: Option Cliente,Pedido,Envio; lCodDe: Code[20]; lCodA: Code[20])
    var
        lRstAtributosDe: Record "50421";
        lRstAtributosA: Record "50421";
    begin
        //EX-SGG-WMS 270619
        lRstAtributosA.INIT;
        lRstAtributosA.VALIDATE("Tipo documento", lOptA);
        //lRstAtributosA.VALIDATE(Codigo,lCodA);
        lRstAtributosA.Codigo := lCodA; //EX-SGG-WMS 020919
        lRstAtributosDe.SETRANGE("Tipo documento", lOptDe);
        lRstAtributosDe.SETRANGE(Codigo, lCodDe);
        IF lRstAtributosDe.FINDSET THEN
            REPEAT
                lRstAtributosA.VALIDATE("Codigo atributo", lRstAtributosDe."Codigo atributo");
                IF NOT lRstAtributosA.INSERT(TRUE) THEN;
            UNTIL lRstAtributosDe.NEXT = 0;
    end;


    procedure ObtenerValorAtributosTtoLogist(lTipoDoc: Option Cliente,Pedido,Envio; lCodigo: Code[20]; lCampo: Text[250]): Text[1024]
    begin
        //EX-SGG-WMS 170719
        RstAtributos.RESET;
        RstAtributos.SETRANGE("Tipo documento", lTipoDoc);
        RstAtributos.SETRANGE(Codigo, lCodigo);
        IF RstAtributos.FINDSET THEN
            REPEAT
                CASE lCampo OF
                    RstAtributos.FIELDNAME("Requiere manipulacion"):
                        BEGIN
                            RstAtributos.CALCFIELDS("Requiere manipulacion");
                            IF RstAtributos."Requiere manipulacion" THEN
                                EXIT('S');
                        END;
                    RstAtributos.FIELDNAME("Verificar expedicion"):
                        BEGIN
                            RstAtributos.CALCFIELDS("Verificar expedicion");
                            IF RstAtributos."Verificar expedicion" THEN
                                EXIT('S');
                        END;
                    RstAtributos.FIELDNAME("Indicador personalizado"):
                        BEGIN
                            RstAtributos.CALCFIELDS("Indicador personalizado");
                            IF RstAtributos."Indicador personalizado" THEN
                                EXIT('S');
                        END;
                    RstAtributos.FIELDNAME("Preparacion mono referencia"):
                        BEGIN
                            RstAtributos.CALCFIELDS("Preparacion mono referencia");
                            IF RstAtributos."Preparacion mono referencia" THEN
                                EXIT('S');
                        END;
                    RstAtributos.FIELDNAME("Caja anonima"):
                        BEGIN
                            RstAtributos.CALCFIELDS("Caja anonima"); //EX-SGG-WMS 230719
                            IF RstAtributos."Caja anonima" <> 0 THEN
                                EXIT(FORMAT(RstAtributos."Caja anonima"));
                        END;
                END;
            UNTIL RstAtributos.NEXT = 0;

        EXIT('');
    end;


    procedure EliminarAtributosTtoLogistico(lOpt: Option Cliente,Pedido,Envio; lCod: Code[20])
    var
        lRstAtributos: Record "Atributos tto. logistic. WMS";
    begin
        //EX-SGG-WMS 110919
        lRstAtributos.SETRANGE("Tipo documento", lOpt);
        lRstAtributos.SETRANGE(Codigo, lCod);
        lRstAtributos.DELETEALL(TRUE);
    end;


    procedure ComprobarUsuarioSiProductoSEGA(lCodProducto: Code[20]; lIDUsuario: Code[20]; lValidarProducto: Boolean; var lAlmacen: Code[10])
    begin
        //EX-SGG-WMS 280619
        IF RstProd.GET(lCodProducto) THEN
            IF RstProd."Producto SEGA" THEN
                IF RstConfUsuarios.GET(lIDUsuario) THEN
                    //EX-SGG 161220
                    //RstConfUsuarios.TESTFIELD("Usuario SEGA");
                    IF NOT RstConfUsuarios."Usuario SEGA" THEN BEGIN
                        IF lValidarProducto AND (lAlmacen = '') THEN BEGIN
                            RstAlmacen.RESET;
                            RstAlmacen.SETFILTER("Clase de Stock SEGA", '<>''''');
                            RstAlmacen.SETFILTER("Estado Calidad SEGA", '<>''''');
                            //    RstAlmacen.SETRANGE("Stock no gestionado por SEGA", TRUE);
                            IF RstAlmacen.FINDFIRST THEN
                                lAlmacen := RstAlmacen.Code;
                        END;
                        IF RstAlmacen.GET(lAlmacen) THEN
                            IF ((RstAlmacen."Clase de Stock SEGA" = '') OR (RstAlmacen."Estado Calidad SEGA" = '')) OR
                            //"Clase de Stock SEGA"
                                ((RstAlmacen."Estado Calidad SEGA" <> '') AND (RstAlmacen."Estado Calidad SEGA" <> '')) THEN
                                //(NOT RstAlmacen."Stock no gestionado por SEGA")) THEN
                                ERROR('Debe seleccionar un almacén SEGA no gestionado');
                    END;
        //FIN EX-SGG 161220
    end;


    procedure CompruebaProdAlmSEGAImaginario(lCodProd: Code[20]; lCodAlm: Code[10])
    begin
        //EX-SGG-WMS 020719
        IF RstAlmacen.GET(lCodAlm) AND RstProd.GET(lCodProd) THEN
            //  IF (NOT RstAlmacen."Stock no gestionado por SEGA") THEN //EX-SGG-WMS 110919 ANTES RstAlamcen.Imaginario
            RstProd.TESTFIELD("Producto SEGA", EsAlmacenSEGA(RstAlmacen.Code));
    end;


    procedure CompruebaNoIntegradosPreviosSA(lCodProd: Code[20]; lCodVarProd: Code[10]; lFecha: Date; lIdWMS: Integer; var lError: Boolean; var lDescError: Text[250])
    var
        lTxt001: Label 'Existe al menos un registro previo para este producto y variante (%2) no integrado en la interface %1';
        lRstOE: Record "WMS OE-Ordenes de Entrada";
        lRstCE: Record "WMS CE-Confirmación de Entrada";
        lRstPE: Record "WMS PE-Pedidos";
        lRstCS: Record "WMS CS-Confirmacion de Salidas";
        lRstAS: Record "WMS AS-Ajuste Stock";
        lRstSA: Record "WMS SA-Stock Actual";
    begin
        //EX-SGG-WMS 030719
        //EX-SGG-WMS 181219 COMPENTO PARA SOLO CONSIDERAR MENSAJES CS Y CE.
        /*
        lRstOE.SETCURRENTKEY(codigoOrdenEntrada,Integrado,fechaEntrega,codigoArticuloERP);
        lRstOE.SETRANGE(Integrado,FALSE);
        lRstOE.SETRANGE(fechaEntrega,0D,lFecha);
        lRstOE.SETRANGE(codigoArticuloERP,DevuelveCodigoArticuloERP(lCodProd,lCodVarProd));
        IF lRstOE.FINDFIRST THEN
         lDescError:=STRSUBSTNO(lTxt001,FORMAT(RstControl.Interface::"OE-Orden de Entrada"),lCodProd+' '+lCodVarProd)
        ELSE
         BEGIN
        */
        lRstCE.SETCURRENTKEY(Obtenido, Integrado, fecha, codigoArticuloERP);
        lRstCE.SETRANGE(Integrado, FALSE);
        lRstCE.SETRANGE(fecha, 0D, lFecha);
        lRstCE.SETRANGE(codigoArticuloERP, DevuelveCodigoArticuloERP(lCodProd, lCodVarProd));
        IF lRstCE.FINDFIRST THEN
            lDescError := STRSUBSTNO(lTxt001, FORMAT(RstControl.Interface::"CE-Confirmacion de Entrada"), lCodProd + ' ' + lCodVarProd)
        ELSE
           /*
              BEGIN
               lRstPE.SETCURRENTKEY(codigoEntregaERP,Integrado,fechaGeneracion,codigoArticuloERP);
               lRstPE.SETRANGE(Integrado,FALSE);
               lRstPE.SETRANGE(fechaGeneracion,0D,lFecha);
               lRstPE.SETRANGE(codigoArticuloERP,DevuelveCodigoArticuloERP(lCodProd,lCodVarProd));
               IF lRstPE.FINDFIRST THEN
                lDescError:=STRSUBSTNO(lTxt001,FORMAT(RstControl.Interface::"PE-Pedido"),lCodProd+' '+lCodVarProd)
               ELSE
           */
           BEGIN
            lRstCS.SETCURRENTKEY(Obtenido, Integrado, fecha, codigoArticuloERP);
            lRstCS.SETRANGE(Integrado, FALSE);
            lRstCS.SETRANGE(fecha, 0D, lFecha);
            lRstCS.SETRANGE(codigoArticuloERP, DevuelveCodigoArticuloERP(lCodProd, lCodVarProd));
            IF lRstCS.FINDFIRST THEN
                lDescError := STRSUBSTNO(lTxt001, FORMAT(RstControl.Interface::"CS-Confirmacion de Salida"), lCodProd + ' ' + lCodVarProd)
            /*
                  ELSE
                   BEGIN
                    lRstAS.SETCURRENTKEY(Obtenido,Integrado,fecha,codigoArticuloERP);
                    lRstAS.SETRANGE(Integrado,FALSE);
                    lRstAS.SETRANGE(fecha,0D,lFecha);
                    lRstAS.SETRANGE(codigoArticuloERP,DevuelveCodigoArticuloERP(lCodProd,lCodVarProd));
                    IF lRstAS.FINDFIRST THEN
                     lDescError:=STRSUBSTNO(lTxt001,FORMAT(RstControl.Interface::"AS-Ajuste de Stock"),lCodProd+' '+lCodVarProd)
                    ELSE
                     BEGIN
                      lRstSA.SETCURRENTKEY(Obtenido,Integrado,fecha,codigoArticuloERP);
                      lRstSA.SETRANGE(Integrado,FALSE);
                      lRstSA.SETRANGE(fecha,0D,lFecha);
                      lRstSA.SETRANGE(codigoArticuloERP,DevuelveCodigoArticuloERP(lCodProd,lCodVarProd));
                      lRstSA.SETFILTER(identificadorStock,'<>'+FORMAT(lIdWMS));
                      IF lRstSA.FINDFIRST THEN
                       lDescError:=STRSUBSTNO(lTxt001,FORMAT(RstControl.Interface::"SA-Stock Actual"),lCodProd+' '+lCodVarProd);
                     END;
                   END;
            */
        END;
        /*
           END;
         END;
        */

        lError := lDescError <> '';

    end;


    procedure ComprobacionesPreviasASySA(var lRstLinDia: Record "83"; lRstControlWMS: Record "50414"; lestadoCalidad: Integer; lclaseStock: Integer; lcodigoArticuloERP: Text[20]; lcantidad: Decimal; var lCantidadNAV: Decimal; var lCodProd: Code[20]; var lCodVarProd: Code[10]; var lCodAlmPpal: Code[10]; var lFiltroAlmacen: Text[250]; var lError: Boolean; var lDescError: Text[250])
    begin
        //EX-SGG-WMS 040719
        CLEAR(lError); //EX-SGG-WMS 030719
        CLEAR(lDescError); //EX-SGG-WMS 030719
        CLEAR(lRstLinDia);
        lRstLinDia.RESET;
        CASE lRstControlWMS.Interface OF
            lRstControlWMS.Interface::"AS-Ajuste de Stock":
                BEGIN
                    lRstLinDia.SETRANGE("Journal Template Name", RstConfAlm."Libro Diario Producto");
                    lRstLinDia.SETRANGE("Journal Batch Name", RstConfAlm."Seccion Diario Producto");
                    lRstLinDia.DELETEALL(TRUE); //EX-SGG-WMS 271119
                END;
            lRstControlWMS.Interface::"SA-Stock Actual":
                BEGIN
                    lRstLinDia.SETRANGE("Journal Template Name", RstConfAlm."Libro Diario Inventario");
                    lRstLinDia.SETRANGE("Journal Batch Name", RstConfAlm."Seccion Diario Inventario");
                END;
        END;
        //lRstLinDia.DELETEALL(TRUE); //EX-SGG-WMS 271119 COMENTO. SOLO EN AS.
        COMMIT; //EX-SGG-WMS 290819
        lRstLinDia.INIT;
        ObtenerAlmacenPpalEstadosSEGA(FORMAT(lRstControlWMS.Interface), lestadoCalidad, lclaseStock,
         lCodAlmPpal, lError, lDescError);
        IF NOT lError THEN BEGIN
            ObtenerFiltroAlmacenesSEGA(lestadoCalidad, lclaseStock, lFiltroAlmacen); //EX-SGG-WMS 280619
            ObtenerCodigoArticuloERP(lcodigoArticuloERP, lCodProd, lCodVarProd);
            CompruebaCantProdYVar(FORMAT(lRstControlWMS.Interface), lcantidad, lCodProd, lCodVarProd,
              lCodAlmPpal, lFiltroAlmacen, lCantidadNAV, lError, lDescError);
        END;

        //EX-SGG-WMS 200919
        IF NOT lError THEN
            IF NOT EsProductoSEGA(lCodProd) THEN BEGIN
                lError := TRUE;
                lDescError := COPYSTR(FORMAT(lRstControlWMS.Interface) + ': El producto ' + lCodProd + ' no es un producto SEGA.'
                             , 1, MAXSTRLEN(lDescError));
            END;
    end;


    procedure IntentaRegDiarioProductoASySA(var lRstLinDia: Record "83"; var lRstControlWMS: Record "50414"; lIdSEGA: Integer; var lIntegrado: Boolean; var lAlgunError: Boolean; lError: Boolean; lDescError: Text[250]): Boolean
    var
        lCduRegLinDia: Codeunit "22";
        lCduRegDia: Codeunit "23";
        lTxtAux: Text[30];
        lRegistrar: Boolean;
    begin
        //EX-SGG-WMS 040719
        IF NOT lError THEN BEGIN
            lRstLinDia.SETRANGE("Location Code");
            COMMIT; //EX-SGG 290819

            //EX-SGG-WMS 170919
            CASE lRstControlWMS.Interface OF
                lRstControlWMS.Interface::"AS-Ajuste de Stock":
                    lRegistrar := (RstConfAlm."Mensajes AS" = RstConfAlm."Mensajes AS"::"Obtener-procesar y registrar") OR
                     GUIALLOWED;
                lRstControlWMS.Interface::"SA-Stock Actual":
                    lRegistrar := (RstConfAlm."Mensajes SA" = RstConfAlm."Mensajes SA"::"Obtener-procesar y registrar") OR
                     //GUIALLOWED;
                     FALSE; //DEBUG ON
            END;
            //FIN EX-SGG-WMS 170919

            IF lRegistrar THEN //EX-SGG-WMS 170919
             BEGIN
                //EX-SGG-WMS 170420
                CASE lRstControlWMS.Interface OF
                    lRstControlWMS.Interface::"AS-Ajuste de Stock":
                        BEGIN
                            CLEAR(lCduRegLinDia);
                            lIntegrado := lCduRegLinDia.RUN(lRstLinDia);
                        END;
                    lRstControlWMS.Interface::"SA-Stock Actual":
                        BEGIN
                            CLEAR(lCduRegDia);
                            DeleteLinesQuantity0(lRstLinDia); //EX-DRG 280921
                                                              //EX-DRG 141021
                            IF lRstLinDia.COUNT >= 1 THEN
                                //Si el commit no funciona correctamente, tenemos que ver otra forma de capturar el valor de retorno de la ejecución
                                //de la codeunit.
                                lIntegrado := lCduRegDia.RUN(lRstLinDia);
                            //EX-DRG 141021
                        END;
                END;

                IF NOT lIntegrado THEN BEGIN
                    lError := TRUE;
                    lDescError := COPYSTR(GETLASTERRORTEXT, 1, MAXSTRLEN(lDescError));
                    CLEARLASTERROR;
                END;
                //FIN EX-SGG-WMS 170420
            END
            ELSE
                lIntegrado := TRUE;
        END;

        IF lError THEN BEGIN
            //lRstLinDia.DELETEALL(TRUE); //EX-SGG-WMS 271119 COMENTO. SOLO PARA AS.
            CASE lRstControlWMS.Interface OF
                lRstControlWMS.Interface::"AS-Ajuste de Stock":
                    BEGIN
                        lTxtAux := 'ajuste';
                        lRstLinDia.DELETEALL(TRUE);
                    END;
                lRstControlWMS.Interface::"SA-Stock Actual":
                    lTxtAux := 'stock';
            END;
            lDescError := COPYSTR('Id ' + lTxtAux + ': ' + FORMAT(lIdSEGA) + ':' + lDescError
             , 1, MAXSTRLEN(lDescError)); //EX-SGG-WMS 040719
            InsertarRegistroLOG(lRstControlWMS, FALSE, lDescError);
            lAlgunError := TRUE; //EX-SGG-WMS 040719
            lIntegrado := FALSE;
        END;
    end;


    procedure AgruparRegistrosASDevolCompras(var lRstControlWMS: Record "50414"; var lRstTMPAS: Record "50418" temporary; var lRstTMPCabCompra: Record "38" temporary; var lError: Boolean; var lDescError: Text[250])
    begin
        //EX-SGG-WMS 040620
        lRstTMPAS.RESET;
        lRstTMPAS.DELETEALL;
        lRstTMPCabCompra.RESET;
        lRstTMPCabCompra.DELETEALL;
        IF RstAS.FINDSET THEN
            REPEAT
                lRstTMPAS.SETRANGE(codigoArticuloERP, RstAS.codigoArticuloERP);
                lRstTMPAS.SETRANGE(observaciones, RstAS.observaciones);
                IF NOT lRstTMPAS.FINDFIRST THEN BEGIN
                    lRstTMPAS.TRANSFERFIELDS(RstAS);
                    lRstTMPAS.cantidad := lRstTMPAS.cantidad * -1; //EX-SGG 140920
                    lRstTMPAS.INSERT;
                END
                ELSE BEGIN
                    IF lRstTMPAS.estadoCalidad <> RstAS.estadoCalidad THEN BEGIN
                        lError := TRUE;
                        lDescError := FORMAT(lRstControlWMS.Interface::"AS-Ajuste de Stock") +
                         ' ' + lRstControlWMS."No. documento" + ':estadoCalidad ' + RstAS.TABLENAME + '(' + FORMAT(RstAS.estadoCalidad) + ') ' +
                         'no debe ser distinto para el mismo SKU y devolución';
                    END
                    ELSE BEGIN
                        //lRstTMPAS.cantidad+=RstAS.cantidad;
                        lRstTMPAS.cantidad += (RstAS.cantidad * -1); //EX-SGG 140920
                        lRstTMPAS.MODIFY;
                    END;
                END;
                IF NOT lRstTMPCabCompra.GET(lRstTMPCabCompra."Document Type"::"Return Order", RstAS.observaciones) THEN BEGIN
                    lRstTMPCabCompra."Document Type" := lRstTMPCabCompra."Document Type"::"Return Order";
                    lRstTMPCabCompra."No." := RstAS.observaciones;
                    lRstTMPCabCompra.INSERT;
                END;
            UNTIL (RstAS.NEXT = 0) OR lError;
    end;


    procedure AgruparRegistrosCE(var lRstControlWMS: Record "50414"; var lRstTMPCE: Record "WMS CE-Confirmación de Entrada" temporary; var lError: Boolean; var lDescError: Text[250])
    begin
        //EX-SGG-WMS 280819
        lRstTMPCE.RESET;
        lRstTMPCE.DELETEALL;
        lRstTMPCE.SETCURRENTKEY(correlativoRecepcion, codigoOrdenEntrada, lineaOrdenEntrada);
        lRstTMPCE.COPYFILTERS(RstCE);
        IF RstCE.FINDSET THEN
            REPEAT
                lRstTMPCE.SETRANGE(lineaOrdenEntrada, RstCE.lineaOrdenEntrada);
                IF NOT lRstTMPCE.FINDFIRST THEN BEGIN
                    lRstTMPCE.TRANSFERFIELDS(RstCE);
                    lRstTMPCE.INSERT;
                END
                ELSE BEGIN
                    IF lRstTMPCE.estadoCalidad <> RstCE.estadoCalidad THEN BEGIN
                        lError := TRUE;
                        lDescError := FORMAT(lRstControlWMS.Interface::"CE-Confirmacion de Entrada") +
                         ' ' + lRstControlWMS."No. documento" + ':estadoCalidad ' + RstCE.TABLENAME + '(' + FORMAT(RstCE.estadoCalidad) + ') ' +
                         'no debe ser distinto para la misma línea de recepción y distintos contenedores';
                    END
                    ELSE BEGIN
                        lRstTMPCE.Cantidad += RstCE.Cantidad;
                        lRstTMPCE.MODIFY;
                    END;
                END;
            UNTIL (RstCE.NEXT = 0) OR (lError);
    end;


    procedure AgruparRegistrosCS(var lRstControlWMS: Record "50414"; var lRstTMPCS: Record "50417" temporary; var lError: Boolean; var lDescError: Text[250])
    begin
        //EX-SGG-WMS 120919
        lRstTMPCS.RESET;
        lRstTMPCS.DELETEALL;
        lRstTMPCS.SETCURRENTKEY(identificadorExpedicion, codigoEntregaERP, lineaEntregaERP);
        lRstTMPCS.COPYFILTERS(RstCS);
        IF RstCS.FINDSET THEN
            REPEAT
                lRstTMPCS.SETRANGE(lineaEntregaERP, RstCS.lineaEntregaERP);
                IF NOT lRstTMPCS.FINDFIRST THEN BEGIN
                    lRstTMPCS.TRANSFERFIELDS(RstCS);
                    lRstTMPCS.INSERT;
                END
                ELSE BEGIN
                    IF lRstTMPCS.claseStock <> RstCS.claseStock THEN BEGIN
                        lError := TRUE;
                        lDescError := FORMAT(lRstControlWMS.Interface::"CS-Confirmacion de Salida") +
                         ' ' + lRstControlWMS."No. documento" + ':claseStock ' + RstCS.TABLENAME + '(' + FORMAT(RstCS.claseStock) + ') ' +
                         'no debe ser distinto para la misma línea de envío y distintos contenedores';
                    END
                    ELSE BEGIN
                        lRstTMPCS.cantidad += RstCS.cantidad;
                        lRstTMPCS.MODIFY;
                    END;
                END;
            UNTIL (RstCS.NEXT = 0) OR (lError);
    end;


    // procedure CrearEmbalajesEDIdesdeCS(var lError: Boolean; var lDescError: Text[250])
    // var
    //   //  lRstEmbalajes: Record "50301";
    //     lRstTMPPed: Record "36" temporary;
    //     lnLinea: Integer;
    //     lnNivel2: Integer;
    //     lnNivel2Encontrado: Integer;
    // begin
    //     //EX-SGG-WMS 120919
    //     IF lRstTMPPed.FINDFIRST THEN ERROR('Las variables temporales no deben contener registros');
    //     IF RstCS.FINDSET THEN
    //         REPEAT
    //             IF EVALUATE(lnLinea, RstCS.lineaEntregaERP) THEN
    //                 IF RstLinEnvAlm.GET(RstCS.codigoEntregaERP, lnLinea) THEN
    //                     IF (RstLinEnvAlm."Source Document" = RstLinEnvAlm."Source Document"::"Sales Order") AND
    //                      RstCabVenta.GET(RstCabVenta."Document Type"::Order, RstLinEnvAlm."Source No.") THEN BEGIN //EX-SGG-WMS 241019
    //                         IF NOT lRstTMPPed.GET(RstCabVenta."Document Type", RstCabVenta."No.") THEN BEGIN
    //                             lRstEmbalajes.RESET;
    //                             lRstEmbalajes.SETRANGE("Tipo de documento", lRstEmbalajes."Tipo de documento"::Pedido);
    //                             lRstEmbalajes.SETRANGE("No documento", RstCabVenta."No.");
    //                             IF lRstEmbalajes.FINDFIRST THEN
    //                                 //EX-SGG-WMS 181019 COMENTO ERROR. EN SU LUGAR, ELIMINACIÓN. SIN ELSE BEGIN.
    //                                 /*
    //                                          BEGIN
    //                                           lError:=TRUE;
    //                                           lDescError+=':Ya existe la definición de embalajes en el pedido '+RstCabVenta."No.";
    //                                          END
    //                                         ELSE
    //                                          BEGIN
    //                                 */
    //               lRstEmbalajes.DELETEALL(TRUE);
    //                             CLEAR(lRstEmbalajes);
    //                             //FIN EX-SGG-WMS 181019
    //                             lRstEmbalajes.INIT;
    //                             lRstEmbalajes."Tipo de documento" := lRstEmbalajes."Tipo de documento"::Pedido;
    //                             lRstEmbalajes."No documento" := RstCabVenta."No.";
    //                             lRstEmbalajes."No linea documento" := 0;
    //                             lRstEmbalajes."No linea" := 10000;
    //                             lRstEmbalajes.Nivel := lRstEmbalajes.Nivel::"Nivel 1";
    //                             lRstEmbalajes."Embalaje nivel 1" := 1;
    //                             lRstEmbalajes.Cantidad := 1;
    //                             lRstEmbalajes.INSERT;
    //                             lRstTMPPed.TRANSFERFIELDS(RstCabVenta);
    //                             lRstTMPPed.INSERT;
    //                             CLEAR(lnNivel2);
    //                             // END; //EX-SGG-WMS 181019 COMENTO.
    //                         END;

    //                         lRstEmbalajes.RESET;
    //                         lRstEmbalajes.SETRANGE("Tipo de documento", lRstEmbalajes."Tipo de documento"::Pedido);
    //                         lRstEmbalajes.SETRANGE("No documento", RstCabVenta."No.");
    //                         lRstEmbalajes.SETRANGE("Tipo embalaje", lRstEmbalajes."Tipo embalaje"::"Palet ISO (80x120 cm)");
    //                         lRstEmbalajes.SETRANGE(Nivel, lRstEmbalajes.Nivel::"Nivel 2");
    //                         lRstEmbalajes.SETRANGE(SSCC, RstCS.codigoContenedor);
    //                         IF NOT lRstEmbalajes.FINDFIRST THEN BEGIN
    //                             lnNivel2 += 1;
    //                             lRstEmbalajes.INIT;
    //                             lRstEmbalajes."Tipo de documento" := lRstEmbalajes."Tipo de documento"::Pedido;
    //                             lRstEmbalajes."No documento" := RstCabVenta."No.";
    //                             lRstEmbalajes."No linea documento" := 0;
    //                             lRstEmbalajes."No linea" := lRstEmbalajes.ObtenerUltNoLinea(lRstEmbalajes."Tipo de documento",
    //                              lRstEmbalajes."No documento", lRstEmbalajes."No linea documento");
    //                             lRstEmbalajes."Tipo embalaje" := lRstEmbalajes."Tipo embalaje"::"Palet ISO (80x120 cm)";
    //                             lRstEmbalajes.Nivel := lRstEmbalajes.Nivel::"Nivel 2";
    //                             lRstEmbalajes."Embalaje nivel 1" := 1;
    //                             lRstEmbalajes."Embalaje nivel 2" := lnNivel2;
    //                             lRstEmbalajes.Cantidad := 0;
    //                             lRstEmbalajes.SSCC := RstCS.codigoContenedor;
    //                             lRstEmbalajes.INSERT;
    //                             lnNivel2Encontrado := lnNivel2; //EX-SGG-WMS 241019 CORRECCION.
    //                                                             //EX-SMN-WMS 231019
    //                                                             //END;
    //                         END
    //                         ELSE
    //                             lnNivel2Encontrado := lRstEmbalajes."Embalaje nivel 2";
    //                         //EX-SMN-WMS FIN
    //                         lRstEmbalajes.INIT;
    //                         lRstEmbalajes."Tipo de documento" := lRstEmbalajes."Tipo de documento"::Pedido;
    //                         lRstEmbalajes."No documento" := RstCabVenta."No.";
    //                         lRstEmbalajes."No linea documento" := RstLinEnvAlm."Source Line No.";
    //                         lRstEmbalajes."No linea" := lRstEmbalajes.ObtenerUltNoLinea(lRstEmbalajes."Tipo de documento",
    //                          lRstEmbalajes."No documento", lRstEmbalajes."No linea documento");
    //                         lRstEmbalajes."Tipo embalaje" := lRstEmbalajes."Tipo embalaje"::"Caja de cartón";
    //                         lRstEmbalajes.Nivel := lRstEmbalajes.Nivel::"Nivel 3";
    //                         lRstEmbalajes."Embalaje nivel 1" := 1;
    //                         //EX-SMN-WMS 231019
    //                         //lRstEmbalajes."Embalaje nivel 2":=lnNivel2;
    //                         lRstEmbalajes."Embalaje nivel 2" := lnNivel2Encontrado;
    //                         //EX-SMN-WMS FIN
    //                         lRstEmbalajes."Embalaje nivel 3" := RstCS.numeroBulto;
    //                         lRstEmbalajes.Cantidad := RstCS.cantidad;
    //                         lRstEmbalajes.SSCC := RstCS.codigoContenedor2;
    //                         lRstEmbalajes.INSERT;

    //                     END;
    //         UNTIL (RstCS.NEXT = 0) OR lError;

    //     IF (NOT lError) AND (lRstTMPPed.FINDSET) THEN BEGIN
    //         lRstEmbalajes.RESET;
    //         lRstEmbalajes.SETRANGE("Tipo de documento", lRstEmbalajes."Tipo de documento"::Pedido);
    //         REPEAT
    //             lRstEmbalajes.SETRANGE("No documento", lRstTMPPed."No.");
    //             lRstEmbalajes.ActualizarCantidades(lRstEmbalajes);
    //         UNTIL lRstTMPPed.NEXT = 0;
    //     END;

    // end;


    // procedure EliminaTagsVaciosFicheroXML(lNombreFichero: Text[1024])
    // var
    //     lFLectura: File;
    //     lFEscritura: File;
    //     lTxtLin: Text[1024];
    //     lNombreFicheroTMP: Text[1024];
    // begin
    //     //EX-SGG-WMS 150719
    //     lNombreFicheroTMP := lNombreFichero + '.tmp';
    //     lFLectura.TEXTMODE(TRUE);
    //     lFLectura.OPEN(lNombreFichero);
    //     lFEscritura.TEXTMODE(TRUE);
    //     lFEscritura.WRITEMODE(TRUE);
    //     lFEscritura.CREATE(lNombreFicheroTMP);
    //     WHILE lFLectura.POS < lFLectura.LEN DO BEGIN
    //         lFLectura.READ(lTxtLin);
    //         IF (STRPOS(lTxtLin, '<unaOrdenEntrada/>') = 0) AND (STRPOS(lTxtLin, '<unPedido/>') = 0) THEN
    //             lFEscritura.WRITE(lTxtLin);
    //     END;
    //     lFLectura.CLOSE;
    //     lFEscritura.CLOSE;
    //     ERASE(lNombreFichero);
    //     RENAME(lNombreFicheroTMP, lNombreFichero);
    // end;





    procedure EsLineaAsignacionDirecta(lNombreTabla: Text[30]; lNoDoc: Code[20]; lNoLinDoc: Integer): Boolean
    begin
        //EX-SGG-WMS 291119
        RstAsignacionDirecta.RESET;
        RstAsignacionDirecta.SETRANGE("Tipo Asignación", RstAsignacionDirecta."Tipo Asignación"::Directa);
        CASE lNombreTabla OF
            RstLinEnvAlm.TABLENAME:
                BEGIN
                    RstAsignacionDirecta.SETRANGE("Nº Pedido Venta", lNoDoc);
                    RstAsignacionDirecta.SETRANGE("Nº Linea Pedido Venta", lNoLinDoc);
                END;
            RstLinRecepAlm.TABLENAME:
                BEGIN
                    RstAsignacionDirecta.SETRANGE("Nº Pedido Compra", lNoDoc);
                    RstAsignacionDirecta.SETRANGE("Nº Linea Pedido Compra", lNoLinDoc);
                END;
        END;
        EXIT(RstAsignacionDirecta.FINDFIRST);
    end;





    procedure DescartarRegistrosPrevios(var lRstControlOrigen: Record "Control integracion WMS")
    var
        lRstControlDescartar: Record 50414;
    begin
        //EX-SGG-WMS 040220
        lRstControlOrigen.TESTFIELD(Interface, lRstControlOrigen.Interface::"SA-Stock Actual");
        lRstControlDescartar.SETCURRENTKEY(Interface, "Tipo documento", "No. documento", "Id. SEGA", Estado, "Estado SEGA",
         "Numero de mensaje SEGA");
        lRstControlDescartar.SETRANGE(Interface, lRstControlDescartar.Interface::"AS-Ajuste de Stock");
        lRstControlDescartar.SETFILTER(Estado, FORMAT(lRstControlDescartar.Estado::Pendiente) + '|' +
         FORMAT(lRstControlDescartar.Estado::Error));
        lRstControlDescartar.SETRANGE("No. registro", 0, lRstControlOrigen."No. registro");
        lRstControlDescartar.MODIFYALL(Estado, lRstControlDescartar.Estado::Descartado, TRUE);
        lRstControlDescartar.MODIFYALL("Fecha y hora procesado", CURRENTDATETIME, TRUE);
    end;


    procedure PreObtenerSASQL(NumMensaje: Code[25])
    var
        ConnectionString: Text[300];
        SQL: Text[100];
        // rConn: Automation;
        // rCursor: Automation;
        WSetup: Record "Warehouse Setup";
    begin
        //EX-DRG 110321
        WSetup.GET;
        WSetup.TESTFIELD(WSetup."SQL Server");
        WSetup.TESTFIELD(WSetup."SQL Database");
        WSetup.TESTFIELD(WSetup."SQL User");
        WSetup.TESTFIELD(WSetup."SQL Password");
        ConnectionString := 'Driver={SQL Server};'
              + 'Server=' + WSetup."SQL Server" + ';'
              + 'Database=' + WSetup."SQL Database" + ';'
              + 'Uid=' + WSetup."SQL User" + ';'
              + 'Pwd=' + WSetup."SQL Password" + ';';

        SQL := 'EXECUTE [WMS_SA_PreObtener] ''' + NumMensaje + '''';

        // CREATE(rConn);
        // rConn.Open(ConnectionString);
        // rConn.Execute(SQL);
    end;


    procedure DeleteLinesQuantity0(ItemJournal: Record 83)
    var
        WarehouseSet: Record 5769;
    begin
        WarehouseSet.GET;

        ItemJournal.RESET;
        ItemJournal.SETRANGE("Journal Template Name", WarehouseSet."Libro Diario Inventario");
        ItemJournal.SETRANGE("Journal Batch Name", WarehouseSet."Seccion Diario Inventario");
        ItemJournal.SETFILTER(Quantity, '=%1', 0);
        IF ItemJournal.FINDSET THEN
            REPEAT
                ItemJournal.DELETE();
            UNTIL ItemJournal.NEXT = 0;

        //EX-DRG 191021
        COMMIT;
    end;


    procedure UpdateSLCantPendNoAnul()
    var
        TransLine: Record "5741";
        SalesLine: Record "Sales line";
    begin
        //EX-CV  -  2021 12 14
        TransLine.SETRANGE("Document No.", globalSourceNo);
        //TransLine.SETRANGE("Derived From Line No.",0);
        IF TransLine.FINDFIRST THEN BEGIN
            SalesLine.RESET;
            SalesLine.SETRANGE("Document No.", TransLine."No. pedido");
            //SalesLine.SETRANGE("Line No.", TransLine."No. linea pedido");
            IF SalesLine.FINDSET THEN
                REPEAT
                    SalesLine.CALCFIELDS("Cantidad en consignacion", "Cantidad transferencia");
                    IF SalesLine."Cant. Pte no anulada" <> (SalesLine."Outstanding Quantity" - SalesLine."Cantidad en consignacion" -
                                                            SalesLine."Cantidad Anulada"/* + SalesLine."Cantidad transferencia"*/) THEN BEGIN
                        //SalesLine."Cant. Pte no anulada" -= SalesLine."Cantidad en consignacion";
                        SalesLine."Cant. Pte no anulada" := SalesLine."Outstanding Quantity" - SalesLine."Cantidad en consignacion" -
                                                            SalesLine."Cantidad Anulada"/* + SalesLine."Cantidad transferencia"*/;

                        SalesLine.MODIFY(FALSE);
                    END;
                UNTIL SalesLine.NEXT = 0;
        END;
        //EX-CV  -  2021 12 14 END

    end;
}

