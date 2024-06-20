/// <summary>
/// TableExtension TemporalPV (ID 50011).
/// </summary>
table 50011 TemporalPV
{
    // //WMS EX-JFC 090919 Validar en el borrado de proposicion de venta de WMS que se borren los registros
    // EX-SGG-WNS 100919 NUEVOS CAMPOS Cant. envios lanzados Y Cant. envios lanzados pedidos.
    // EX-CGR-140920 NUEVO CAMPO PARA IDENTIFICAR SI VIENE DE CONSIGNACION
    // EX-SGG 171122 NUEVOS CAMPOS 900 Tipo de producto, 901 Cod. grupo talla,902 Tipo columna matrix
    //               AGREGO A KEY Clave 1,Proceso,usuario,Insertado CAMPOS Tipo de producto,Cod. grupo talla
    //        181122 CODIGO PARA ELIMINAR REGISTROS WMS*MATRIX*
    //        231122 CAPTIONML PARA NUEVOS CAMPOS DE LA TABLA.
    //        251122 FILTROS EN OnDelete PARA PROCESO "WMSMATRIXC". NUEVA FUNCION AsignaLinMatrix(). CODIGO REF.
    //        091222 SE REHACE ELIMINACION DE REGISTROS WMSMATRIX EN OnDelete()
    //               NUEVO CAMPO "Tipo proposicion calculada" PARA GUARDAR CON QUÉ CALCULO SE HA REALIZADO EL DETALLE
    //                 DE LA PROPOSICIÓN.
    //        191222 NUEVA FUNCION ObtenerOtrasCantAsignadas PARA OBTENER SUMATORIO DE CANTIDAD ASIGNADAS DE OTROS PEDIDOS.
    //               NUEVA FUNCION ActOtrasCantPdtesAsignMatrix PARA ACTUALIZAR CANTIDADES A ASIGNAR EN FUNCION DEL STOCK DISPONIBLE.
    //               NUEVO CAMPO Modificado por usuario PARA CONTROL DE MODIFICACION DE ASIGNACION REALIZADA POR EL USUARIO.

    fields
    {
        field(1; Contador; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Contador', comment = 'ESP="Contador"';
        }
        field(2; Proceso; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Proceso', comment = 'ESP="Proceso"';
        }
        field(3; "Clave 1"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Clave 1', comment = 'ESP="Clave 1"';
            TableRelation = IF (Proceso = CONST('RFIDCAB')) "Sales Header"."No."
            ELSE
            IF (Proceso = CONST('RFIDTALLAS')) "Sales Header"."No."
            ELSE
            IF (Proceso = CONST('RFIDLIN')) "Sales Header"."No.";
        }
        field(4; "Clave 2"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Clave 2', comment = 'ESP="Clave 2"';
        }
        field(5; "Clave 3"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Clave 3', comment = 'ESP="Clave 3"';
            TableRelation = IF (Proceso = CONST('RFIDLIN')) Customer
            ELSE
            IF (Proceso = CONST('RFIDTALLAS')) Customer;
        }
        field(6; "Clave 4"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Clave 4', comment = 'ESP="Clave 4"';
            TableRelation = IF (Proceso = CONST('RFIDLIN')) Item
            ELSE
            IF (Proceso = CONST('RFIDTALLAS')) Item;
        }
        field(7; "Clave 5"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Clave 5', comment = 'ESP="Clave 5"';
        }
        field(8; usuario; Code[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Usuario', comment = 'ESP="usuario"';
        }
        field(9; Temporada; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Temporada', comment = 'ESP="Temporada"';
        }
        field(10; Color; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Color', comment = 'ESP="Color"';
        }
        field(11; Talla; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Talla', comment = 'ESP="Talla"';
        }
        field(12; Cantidad; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Cantidad', comment = 'ESP="Cantiad"';
        }
        field(13; "Cantidad Pendiente"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Cantidad Pendiente', comment = 'ESP="Cantiad Pendiente"';
        }
        field(14; "Serie Precio"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Serie precio', comment = 'ESP="Serie Precio"';
        }
        field(15; Sucursal; Code[1])
        {
            DataClassification = ToBeClassified;
            Caption = 'Sucursal', comment = 'ESP="Sucursal"';
        }
        field(16; Prioridad; Code[1])
        {
            DataClassification = ToBeClassified;
            Caption = 'Prioridad', comment = 'ESP="Prioridad"';
        }
        field(17; "Cod Variante"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cód.Variante', comment = 'ESP="Cod. Variante"';
        }
        field(18; Anular; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Anular', comment = 'ESP="Anular"';
        }
        field(19; Stock; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Stock', comment = 'ESP="Stock"';
        }
        field(20; "No Anular"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'No Anular', comment = 'ESP="No Anular"';
        }
        field(21; "Nombre Cliente"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Nombre Cliente', comment = 'ESP="Nombre Cliente"';
        }
        field(22; "Asigna Lin"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Asigna Lin', comment = 'ESP="Asigna Lin"';
            trigger OnValidate()
            begin

                IF ((Proceso = 'RFIDTALLAS')) OR ((Proceso = 'WMSTALLAS')) THEN BEGIN
                    FOR i := 17 TO 49 DO BEGIN
                        RecTemp.RESET();

                        RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');

                        RecTemp.SETRANGE("Clave 1", "Clave 1");
                        RecTemp.SETRANGE("Clave 2", FORMAT(i));
                        RecTemp.SETRANGE("Clave 3", "Clave 3");
                        RecTemp.SETRANGE("Clave 4", "Clave 4");
                        RecTemp.SETRANGE("Clave 5", "Clave 5");
                        RecTemp.SETRANGE("Clave 6", "Clave 6");
                        RecTemp.SETFILTER("Cantidad Asignada", '<>0');
                        IF RecTemp.FINDFIRST() THEN
                            REPEAT
                                RecTemp."Asigna Lin" := "Asigna Lin";
                                RecTemp.MODIFY();

                                IF "Asigna Lin" THEN BEGIN
                                    RecTemp2.RESET();

                                    RecTemp2.SETFILTER(RecTemp2.Proceso, 'RFIDTALLAS|WMSTALLAS');

                                    RecTemp2.SETFILTER("Clave 1", '<>%1', RecTemp."Clave 1");
                                    RecTemp2.SETRANGE("Clave 4", RecTemp."Clave 4");
                                    RecTemp2.SETRANGE("Clave 5", RecTemp."Clave 5");
                                    RecTemp2.SETRANGE("Clave 6", RecTemp."Clave 6");
                                    IF RecTemp2.FINDFIRST() THEN
                                        REPEAT
                                            IF i = 17 THEN BEGIN
                                                IF RecTemp2."17 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."17 Stock" := RecTemp2."17 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."17 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."17 Stock" < RecTemp2."17 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("17 Asig", RecTemp2."17 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 18 THEN BEGIN
                                                IF RecTemp2."18 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."18 Stock" := RecTemp2."18 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."18 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."18 Stock" < RecTemp2."18 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("18 Asig", RecTemp2."18 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 19 THEN BEGIN
                                                IF RecTemp2."19 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."19 Stock" := RecTemp2."19 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."19 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."19 Stock" < RecTemp2."19 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("19 Asig", RecTemp2."19 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 20 THEN BEGIN
                                                IF RecTemp2."20 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."20 Stock" := RecTemp2."20 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."20 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."20 Stock" < RecTemp2."20 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("20 Asig", RecTemp2."20 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 21 THEN BEGIN
                                                IF RecTemp2."21 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."21 Stock" := RecTemp2."21 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."21 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."21 Stock" < RecTemp2."21 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("21 Asig", RecTemp2."21 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 22 THEN BEGIN
                                                IF RecTemp2."22 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."22 Stock" := RecTemp2."22 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."22 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."22 Stock" < RecTemp2."22 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("22 Asig", RecTemp2."22 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 23 THEN BEGIN
                                                IF RecTemp2."23 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."23 Stock" := RecTemp2."23 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."23 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."23 Stock" < RecTemp2."23 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("23 Asig", RecTemp2."23 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 24 THEN BEGIN
                                                IF RecTemp2."24 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."24 Stock" := RecTemp2."24 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."24 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."24 Stock" < RecTemp2."24 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("24 Asig", RecTemp2."24 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 25 THEN BEGIN
                                                IF RecTemp2."25 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."25 Stock" := RecTemp2."25 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."25 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."25 Stock" < RecTemp2."25 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("25 Asig", RecTemp2."25 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 26 THEN BEGIN
                                                IF RecTemp2."26 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."26 Stock" := RecTemp2."26 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."26 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."26 Stock" < RecTemp2."26 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("26 Asig", RecTemp2."26 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 27 THEN BEGIN
                                                IF RecTemp2."27 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."27 Stock" := RecTemp2."27 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."27 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."27 Stock" < RecTemp2."27 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("27 Asig", RecTemp2."27 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 28 THEN BEGIN
                                                IF RecTemp2."28 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."28 Stock" := RecTemp2."28 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."28 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."28 Stock" < RecTemp2."28 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("28 Asig", RecTemp2."28 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 29 THEN BEGIN
                                                IF RecTemp2."29 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."29 Stock" := RecTemp2."29 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."29 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."29 Stock" < RecTemp2."29 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("29 Asig", RecTemp2."29 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 30 THEN BEGIN
                                                IF RecTemp2."30 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."30 Stock" := RecTemp2."30 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."30 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."30 Stock" < RecTemp2."30 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("30 Asig", RecTemp2."30 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 31 THEN BEGIN
                                                IF RecTemp2."31 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."31 Stock" := RecTemp2."31 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."31 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."31 Stock" < RecTemp2."31 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("31 Asig", RecTemp2."31 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 32 THEN BEGIN
                                                IF RecTemp2."32 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."32 Stock" := RecTemp2."32 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."32 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."32 Stock" < RecTemp2."32 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("32 Asig", RecTemp2."32 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 33 THEN BEGIN
                                                IF RecTemp2."33 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."33 Stock" := RecTemp2."33 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."33 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."33 Stock" < RecTemp2."33 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("33 Asig", RecTemp2."33 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 34 THEN BEGIN
                                                IF RecTemp2."34 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."34 Stock" := RecTemp2."34 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."34 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."34 Stock" < RecTemp2."34 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("34 Asig", RecTemp2."34 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 35 THEN BEGIN
                                                IF RecTemp2."35 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."35 Stock" := RecTemp2."35 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."35 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."35 Stock" < RecTemp2."35 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("35 Asig", RecTemp2."35 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 36 THEN BEGIN

                                                IF RecTemp2."36 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."36 Stock" := RecTemp2."36 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."36 Stock" := 0;

                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."36 Stock" < RecTemp2."36 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("36 Asig", RecTemp2."36 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 37 THEN BEGIN

                                                IF RecTemp2."37 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."37 Stock" := RecTemp2."37 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."37 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."37 Stock" < RecTemp2."37 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("37 Asig", RecTemp2."37 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 38 THEN BEGIN
                                                IF RecTemp2."38 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."38 Stock" := RecTemp2."38 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."38 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."38 Stock" < RecTemp2."38 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("38 Asig", RecTemp2."38 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 39 THEN BEGIN
                                                IF RecTemp2."39 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."39 Stock" := RecTemp2."39 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."39 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."39 Stock" < RecTemp2."39 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("39 Asig", RecTemp2."39 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 40 THEN BEGIN
                                                IF RecTemp2."40 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."40 Stock" := RecTemp2."40 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."40 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."40 Stock" < RecTemp2."40 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("40 Asig", RecTemp2."40 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 41 THEN BEGIN
                                                IF RecTemp2."41 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."41 Stock" := RecTemp2."41 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."41 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."41 Stock" < RecTemp2."41 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("41 Asig", RecTemp2."41 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 42 THEN BEGIN
                                                IF RecTemp2."42 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."42 Stock" := RecTemp2."42 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."42 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."42 Stock" < RecTemp2."42 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("42 Asig", RecTemp2."42 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 43 THEN BEGIN
                                                IF RecTemp2."43 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."43 Stock" := RecTemp2."43 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."43 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."43 Stock" < RecTemp2."43 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("43 Asig", RecTemp2."43 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 44 THEN BEGIN
                                                IF RecTemp2."44 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."44 Stock" := RecTemp2."44 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."44 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."44 Stock" < RecTemp2."44 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("44 Asig", RecTemp2."44 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 45 THEN BEGIN
                                                IF RecTemp2."45 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."45 Stock" := RecTemp2."45 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."45 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."45 Stock" < RecTemp2."45 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("45 Asig", RecTemp2."45 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 46 THEN BEGIN
                                                IF RecTemp2."46 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."46 Stock" := RecTemp2."46 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."46 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."46 Stock" < RecTemp2."46 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("46 Asig", RecTemp2."46 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 47 THEN BEGIN
                                                IF RecTemp2."47 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."47 Stock" := RecTemp2."47 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."47 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."47 Stock" < RecTemp2."47 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("47 Asig", RecTemp2."47 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 48 THEN BEGIN
                                                IF RecTemp2."48 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."48 Stock" := RecTemp2."48 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."48 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."48 Stock" < RecTemp2."48 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("48 Asig", RecTemp2."48 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                            IF i = 49 THEN BEGIN
                                                IF RecTemp2."49 Stock" - RecTemp."Cantidad Asignada" > 0 THEN
                                                    RecTemp2."49 Stock" := RecTemp2."49 Stock" - RecTemp."Cantidad Asignada"
                                                ELSE
                                                    RecTemp2."49 Stock" := 0;
                                                IF NOT RecTemp2."Asigna Lin" THEN
                                                    IF (RecTemp2."49 Stock" < RecTemp2."49 Asig") THEN BEGIN
                                                        RecTemp2.VALIDATE("49 Asig", RecTemp2."49 Stock");
                                                    END;
                                                RecTemp2.MODIFY();
                                            END;
                                        UNTIL RecTemp2.NEXT() = 0;

                                    IF i = 17 THEN BEGIN
                                        "17 Stock" := "17 Stock" - "17 Asig";
                                    END;
                                    IF i = 18 THEN BEGIN
                                        "18 Stock" := "18 Stock" - "18 Asig";
                                    END;
                                    IF i = 19 THEN BEGIN
                                        "19 Stock" := "19 Stock" - "19 Asig";
                                    END;
                                    IF i = 20 THEN BEGIN
                                        "20 Stock" := "20 Stock" - "20 Asig";
                                    END;
                                    IF i = 21 THEN BEGIN
                                        "21 Stock" := "21 Stock" - "21 Asig";
                                    END;
                                    IF i = 22 THEN BEGIN
                                        "22 Stock" := "22 Stock" - "22 Asig";
                                    END;
                                    IF i = 23 THEN BEGIN
                                        "23 Stock" := "23 Stock" - "23 Asig";
                                    END;
                                    IF i = 24 THEN BEGIN
                                        "24 Stock" := "24 Stock" - "24 Asig";
                                    END;
                                    IF i = 25 THEN BEGIN
                                        "25 Stock" := "25 Stock" - "25 Asig";
                                    END;
                                    IF i = 26 THEN BEGIN
                                        "26 Stock" := "26 Stock" - "26 Asig";
                                    END;
                                    IF i = 27 THEN BEGIN
                                        "27 Stock" := "27 Stock" - "27 Asig";
                                    END;
                                    IF i = 28 THEN BEGIN
                                        "28 Stock" := "28 Stock" - "28 Asig";
                                    END;
                                    IF i = 29 THEN BEGIN
                                        "29 Stock" := "29 Stock" - "29 Asig";
                                    END;
                                    IF i = 30 THEN BEGIN
                                        "30 Stock" := "30 Stock" - "30 Asig";
                                    END;
                                    IF i = 31 THEN BEGIN
                                        "31 Stock" := "31 Stock" - "31 Asig";
                                    END;
                                    IF i = 32 THEN BEGIN
                                        "32 Stock" := "32 Stock" - "32 Asig";
                                    END;
                                    IF i = 33 THEN BEGIN
                                        "33 Stock" := "33 Stock" - "33 Asig";
                                    END;
                                    IF i = 34 THEN BEGIN
                                        "34 Stock" := "34 Stock" - "34 Asig";
                                    END;
                                    IF i = 35 THEN BEGIN
                                        "35 Stock" := "35 Stock" - "35 Asig";
                                    END;
                                    IF i = 36 THEN BEGIN
                                        "36 Stock" := "36 Stock" - "36 Asig";
                                    END;
                                    IF i = 37 THEN BEGIN
                                        "37 Stock" := "37 Stock" - "37 Asig";
                                    END;
                                    IF i = 38 THEN BEGIN
                                        "38 Stock" := "38 Stock" - "38 Asig";
                                    END;
                                    IF i = 39 THEN BEGIN
                                        "39 Stock" := "39 Stock" - "39 Asig";
                                    END;
                                    IF i = 40 THEN BEGIN
                                        "40 Stock" := "40 Stock" - "40 Asig";
                                    END;
                                    IF i = 41 THEN BEGIN
                                        "41 Stock" := "41 Stock" - "41 Asig";
                                    END;
                                    IF i = 42 THEN BEGIN
                                        "42 Stock" := "42 Stock" - "42 Asig";
                                    END;
                                    IF i = 43 THEN BEGIN
                                        "43 Stock" := "43 Stock" - "43 Asig";
                                    END;
                                    IF i = 44 THEN BEGIN
                                        "44 Stock" := "44 Stock" - "44 Asig";
                                    END;
                                    IF i = 45 THEN BEGIN
                                        "45 Stock" := "45 Stock" - "45 Asig";
                                    END;
                                    IF i = 46 THEN BEGIN
                                        "46 Stock" := "46 Stock" - "46 Asig";
                                    END;
                                    IF i = 47 THEN BEGIN
                                        "47 Stock" := "47 Stock" - "47 Asig";
                                    END;
                                    IF i = 48 THEN BEGIN
                                        "48 Stock" := "48 Stock" - "48 Asig";
                                    END;
                                    IF i = 49 THEN BEGIN
                                        "49 Stock" := "49 Stock" - "49 Asig";
                                    END;

                                END ELSE BEGIN

                                    RecTemp2.RESET();

                                    RecTemp2.SETFILTER(RecTemp2.Proceso, 'RFIDTALLAS|WMSTALLAS');

                                    RecTemp2.SETFILTER("Clave 1", '<>%1', RecTemp."Clave 1");
                                    RecTemp2.SETRANGE("Clave 4", RecTemp."Clave 4");
                                    RecTemp2.SETRANGE("Clave 5", RecTemp."Clave 5");
                                    RecTemp2.SETRANGE("Clave 6", RecTemp."Clave 6");
                                    IF RecTemp2.FINDFIRST() THEN
                                        REPEAT
                                            IF i = 17 THEN BEGIN
                                                IF RecTemp2."17 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."17 Stock" := RecTemp2."17 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."17 Stock" > RecTemp2."17 inist" THEN
                                                        RecTemp2."17 Stock" := RecTemp2."17 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."17 Stock" >= RecTemp2."17 iniasig" THEN BEGIN
                                                    RecTemp2."17 Asig" := RecTemp2."17 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "17 AsigU" := "17 Asig";
                                                END;
                                            END;
                                            IF i = 18 THEN BEGIN
                                                IF RecTemp2."18 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."18 Stock" := RecTemp2."18 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."18 Stock" > RecTemp2."18 inist" THEN
                                                        RecTemp2."18 Stock" := RecTemp2."18 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."18 Stock" >= RecTemp2."18 iniasig" THEN BEGIN
                                                    RecTemp2."18 Asig" := RecTemp2."18 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "18 AsigU" := "18 Asig";
                                                END;
                                            END;
                                            IF i = 19 THEN BEGIN
                                                IF RecTemp2."19 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."19 Stock" := RecTemp2."19 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."19 Stock" > RecTemp2."19 inist" THEN
                                                        RecTemp2."19 Stock" := RecTemp2."19 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."19 Stock" >= RecTemp2."19 iniasig" THEN BEGIN
                                                    RecTemp2."19 Asig" := RecTemp2."19 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "19 AsigU" := "19 Asig";
                                                END;
                                            END;
                                            IF i = 20 THEN BEGIN
                                                IF RecTemp2."20 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."20 Stock" := RecTemp2."20 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."20 Stock" > RecTemp2."20 inist" THEN
                                                        RecTemp2."20 Stock" := RecTemp2."20 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."20 Stock" >= RecTemp2."20 iniasig" THEN BEGIN
                                                    RecTemp2."20 Asig" := RecTemp2."20 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "20 AsigU" := "20 Asig";
                                                END;
                                            END;
                                            IF i = 21 THEN BEGIN
                                                IF RecTemp2."21 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."21 Stock" := RecTemp2."21 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."21 Stock" > RecTemp2."21 inist" THEN
                                                        RecTemp2."21 Stock" := RecTemp2."21 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."21 Stock" >= RecTemp2."21 iniasig" THEN BEGIN
                                                    RecTemp2."21 Asig" := RecTemp2."21 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "21 AsigU" := "21 Asig";
                                                END;
                                            END;
                                            IF i = 22 THEN BEGIN
                                                IF RecTemp2."22 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."22 Stock" := RecTemp2."22 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."22 Stock" > RecTemp2."22 inist" THEN
                                                        RecTemp2."22 Stock" := RecTemp2."22 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."22 Stock" >= RecTemp2."22 iniasig" THEN BEGIN
                                                    RecTemp2."22 Asig" := RecTemp2."22 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "22 AsigU" := "22 Asig";
                                                END;
                                            END;
                                            IF i = 23 THEN BEGIN
                                                IF RecTemp2."23 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."23 Stock" := RecTemp2."23 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."23 Stock" > RecTemp2."23 inist" THEN
                                                        RecTemp2."23 Stock" := RecTemp2."23 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."23 Stock" >= RecTemp2."23 iniasig" THEN BEGIN
                                                    RecTemp2."23 Asig" := RecTemp2."23 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "23 AsigU" := "23 Asig";
                                                END;
                                            END;
                                            IF i = 24 THEN BEGIN
                                                IF RecTemp2."24 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."24 Stock" := RecTemp2."24 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."24 Stock" > RecTemp2."24 inist" THEN
                                                        RecTemp2."24 Stock" := RecTemp2."24 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."24 Stock" >= RecTemp2."24 iniasig" THEN BEGIN
                                                    RecTemp2."24 Asig" := RecTemp2."24 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "24 AsigU" := "24 Asig";
                                                END;
                                            END;
                                            IF i = 25 THEN BEGIN
                                                IF RecTemp2."25 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."25 Stock" := RecTemp2."25 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."25 Stock" > RecTemp2."25 inist" THEN
                                                        RecTemp2."25 Stock" := RecTemp2."25 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."25 Stock" >= RecTemp2."25 iniasig" THEN BEGIN
                                                    RecTemp2."25 Asig" := RecTemp2."25 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "25 AsigU" := "25 Asig";
                                                END;
                                            END;
                                            IF i = 26 THEN BEGIN
                                                IF RecTemp2."26 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."26 Stock" := RecTemp2."26 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."26 Stock" > RecTemp2."26 inist" THEN
                                                        RecTemp2."26 Stock" := RecTemp2."26 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."26 Stock" >= RecTemp2."26 iniasig" THEN BEGIN
                                                    RecTemp2."26 Asig" := RecTemp2."26 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "26 AsigU" := "26 Asig";
                                                END;
                                            END;
                                            IF i = 27 THEN BEGIN
                                                IF RecTemp2."27 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."27 Stock" := RecTemp2."27 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."27 Stock" > RecTemp2."27 inist" THEN
                                                        RecTemp2."27 Stock" := RecTemp2."27 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."27 Stock" >= RecTemp2."27 iniasig" THEN BEGIN
                                                    RecTemp2."27 Asig" := RecTemp2."27 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "27 AsigU" := "27 Asig";
                                                END;
                                            END;
                                            IF i = 28 THEN BEGIN
                                                IF RecTemp2."28 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."28 Stock" := RecTemp2."28 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."28 Stock" > RecTemp2."28 inist" THEN
                                                        RecTemp2."28 Stock" := RecTemp2."28 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."28 Stock" >= RecTemp2."28 iniasig" THEN BEGIN
                                                    RecTemp2."28 Asig" := RecTemp2."28 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "28 AsigU" := "28 Asig";
                                                END;
                                            END;
                                            IF i = 29 THEN BEGIN
                                                IF RecTemp2."29 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."29 Stock" := RecTemp2."29 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."29 Stock" > RecTemp2."29 inist" THEN
                                                        RecTemp2."29 Stock" := RecTemp2."29 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."29 Stock" >= RecTemp2."29 iniasig" THEN BEGIN
                                                    RecTemp2."29 Asig" := RecTemp2."29 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "29 AsigU" := "29 Asig";
                                                END;
                                            END;
                                            IF i = 30 THEN BEGIN
                                                IF RecTemp2."30 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."30 Stock" := RecTemp2."30 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."30 Stock" > RecTemp2."30 inist" THEN
                                                        RecTemp2."30 Stock" := RecTemp2."30 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."30 Stock" >= RecTemp2."30 iniasig" THEN BEGIN
                                                    RecTemp2."30 Asig" := RecTemp2."30 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "30 AsigU" := "30 Asig";
                                                END;
                                            END;
                                            IF i = 31 THEN BEGIN
                                                IF RecTemp2."31 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."31 Stock" := RecTemp2."31 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."31 Stock" > RecTemp2."31 inist" THEN
                                                        RecTemp2."31 Stock" := RecTemp2."31 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."31 Stock" >= RecTemp2."31 iniasig" THEN BEGIN
                                                    RecTemp2."31 Asig" := RecTemp2."31 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "31 AsigU" := "31 Asig";
                                                END;
                                            END;
                                            IF i = 32 THEN BEGIN
                                                IF RecTemp2."32 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."32 Stock" := RecTemp2."32 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."32 Stock" > RecTemp2."32 inist" THEN
                                                        RecTemp2."32 Stock" := RecTemp2."32 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."32 Stock" >= RecTemp2."32 iniasig" THEN BEGIN
                                                    RecTemp2."32 Asig" := RecTemp2."32 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "32 AsigU" := "32 Asig";
                                                END;
                                            END;
                                            IF i = 33 THEN BEGIN
                                                IF RecTemp2."33 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."33 Stock" := RecTemp2."33 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."33 Stock" > RecTemp2."33 inist" THEN
                                                        RecTemp2."33 Stock" := RecTemp2."33 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."33 Stock" >= RecTemp2."33 iniasig" THEN BEGIN
                                                    RecTemp2."33 Asig" := RecTemp2."33 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "33 AsigU" := "33 Asig";
                                                END;
                                            END;
                                            IF i = 34 THEN BEGIN
                                                IF RecTemp2."34 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."34 Stock" := RecTemp2."34 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."34 Stock" > RecTemp2."34 inist" THEN
                                                        RecTemp2."34 Stock" := RecTemp2."34 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."34 Stock" >= RecTemp2."34 iniasig" THEN BEGIN
                                                    RecTemp2."34 Asig" := RecTemp2."34 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "34 AsigU" := "34 Asig";
                                                END;
                                            END;
                                            IF i = 35 THEN BEGIN
                                                IF RecTemp2."35 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."35 Stock" := RecTemp2."35 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."35 Stock" > RecTemp2."35 inist" THEN
                                                        RecTemp2."35 Stock" := RecTemp2."35 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."35 Stock" >= RecTemp2."35 iniasig" THEN BEGIN
                                                    RecTemp2."35 Asig" := RecTemp2."35 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "35 AsigU" := "35 Asig";
                                                END;
                                            END;
                                            IF i = 36 THEN BEGIN
                                                IF RecTemp2."36 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."36 Stock" := RecTemp2."36 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."36 Stock" > RecTemp2."36 inist" THEN
                                                        RecTemp2."36 Stock" := RecTemp2."36 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."36 Stock" >= RecTemp2."36 iniasig" THEN BEGIN
                                                    RecTemp2."36 Asig" := RecTemp2."36 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "36 AsigU" := "36 Asig";
                                                END;
                                            END;
                                            IF i = 37 THEN BEGIN
                                                IF RecTemp2."37 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."37 Stock" := RecTemp2."37 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."37 Stock" > RecTemp2."37 inist" THEN
                                                        RecTemp2."37 Stock" := RecTemp2."37 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."37 Stock" >= RecTemp2."37 iniasig" THEN BEGIN
                                                    RecTemp2."37 Asig" := RecTemp2."37 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "37 AsigU" := "37 Asig";
                                                END;
                                            END;
                                            IF i = 38 THEN BEGIN
                                                IF RecTemp2."38 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."38 Stock" := RecTemp2."38 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."38 Stock" > RecTemp2."38 inist" THEN
                                                        RecTemp2."38 Stock" := RecTemp2."38 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."38 Stock" >= RecTemp2."38 iniasig" THEN BEGIN
                                                    RecTemp2."38 Asig" := RecTemp2."38 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "38 AsigU" := "38 Asig";
                                                END;
                                            END;
                                            IF i = 39 THEN BEGIN
                                                IF RecTemp2."39 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."39 Stock" := RecTemp2."39 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."39 Stock" > RecTemp2."39 inist" THEN
                                                        RecTemp2."39 Stock" := RecTemp2."39 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."39 Stock" >= RecTemp2."39 iniasig" THEN BEGIN
                                                    RecTemp2."39 Asig" := RecTemp2."39 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "39 AsigU" := "39 Asig";
                                                END;
                                            END;
                                            IF i = 40 THEN BEGIN
                                                IF RecTemp2."40 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."40 Stock" := RecTemp2."40 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."40 Stock" > RecTemp2."40 inist" THEN
                                                        RecTemp2."40 Stock" := RecTemp2."40 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."40 Stock" >= RecTemp2."40 iniasig" THEN BEGIN
                                                    RecTemp2."40 Asig" := RecTemp2."40 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "40 AsigU" := "40 Asig";
                                                END;
                                            END;
                                            IF i = 41 THEN BEGIN
                                                IF RecTemp2."41 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."41 Stock" := RecTemp2."41 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."41 Stock" > RecTemp2."41 inist" THEN
                                                        RecTemp2."41 Stock" := RecTemp2."41 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."41 Stock" >= RecTemp2."41 iniasig" THEN BEGIN
                                                    RecTemp2."41 Asig" := RecTemp2."41 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "41 AsigU" := "41 Asig";
                                                END;
                                            END;
                                            IF i = 42 THEN BEGIN
                                                IF RecTemp2."42 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."42 Stock" := RecTemp2."42 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."42 Stock" > RecTemp2."42 inist" THEN
                                                        RecTemp2."42 Stock" := RecTemp2."42 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."42 Stock" >= RecTemp2."42 iniasig" THEN BEGIN
                                                    RecTemp2."42 Asig" := RecTemp2."42 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "42 AsigU" := "42 Asig";
                                                END;
                                            END;
                                            IF i = 43 THEN BEGIN
                                                IF RecTemp2."43 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."43 Stock" := RecTemp2."43 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."43 Stock" > RecTemp2."43 inist" THEN
                                                        RecTemp2."43 Stock" := RecTemp2."43 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."43 Stock" >= RecTemp2."43 iniasig" THEN BEGIN
                                                    RecTemp2."43 Asig" := RecTemp2."43 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "43 AsigU" := "43 Asig";
                                                END;
                                            END;
                                            IF i = 44 THEN BEGIN
                                                IF RecTemp2."44 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."44 Stock" := RecTemp2."44 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."44 Stock" > RecTemp2."44 inist" THEN
                                                        RecTemp2."44 Stock" := RecTemp2."44 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."44 Stock" >= RecTemp2."44 iniasig" THEN BEGIN
                                                    RecTemp2."44 Asig" := RecTemp2."44 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "44 AsigU" := "44 Asig";
                                                END;
                                            END;
                                            IF i = 45 THEN BEGIN
                                                IF RecTemp2."45 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."45 Stock" := RecTemp2."45 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."45 Stock" > RecTemp2."45 inist" THEN
                                                        RecTemp2."45 Stock" := RecTemp2."45 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."45 Stock" >= RecTemp2."45 iniasig" THEN BEGIN
                                                    RecTemp2."45 Asig" := RecTemp2."45 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "45 AsigU" := "45 Asig";
                                                END;
                                            END;
                                            IF i = 46 THEN BEGIN
                                                IF RecTemp2."46 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."46 Stock" := RecTemp2."46 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."46 Stock" > RecTemp2."46 inist" THEN
                                                        RecTemp2."46 Stock" := RecTemp2."46 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."46 Stock" >= RecTemp2."46 iniasig" THEN BEGIN
                                                    RecTemp2."46 Asig" := RecTemp2."46 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "46 AsigU" := "46 Asig";
                                                END;
                                            END;
                                            IF i = 47 THEN BEGIN
                                                IF RecTemp2."47 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."47 Stock" := RecTemp2."47 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."47 Stock" > RecTemp2."47 inist" THEN
                                                        RecTemp2."47 Stock" := RecTemp2."47 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."47 Stock" >= RecTemp2."47 iniasig" THEN BEGIN
                                                    RecTemp2."47 Asig" := RecTemp2."47 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "47 AsigU" := "47 Asig";
                                                END;
                                            END;
                                            IF i = 48 THEN BEGIN
                                                IF RecTemp2."48 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."48 Stock" := RecTemp2."48 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."48 Stock" > RecTemp2."48 inist" THEN
                                                        RecTemp2."48 Stock" := RecTemp2."48 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."48 Stock" >= RecTemp2."48 iniasig" THEN BEGIN
                                                    RecTemp2."48 Asig" := RecTemp2."48 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "48 AsigU" := "48 Asig";
                                                END;
                                            END;
                                            IF i = 49 THEN BEGIN
                                                IF RecTemp2."49 Pte Servir" <> 0 THEN BEGIN
                                                    RecTemp2."49 Stock" := RecTemp2."49 Stock" + RecTemp."Cantidad Asignada";
                                                    IF RecTemp2."49 Stock" > RecTemp2."49 inist" THEN
                                                        RecTemp2."49 Stock" := RecTemp2."49 inist";
                                                    RecTemp2.MODIFY();
                                                END;
                                                IF RecTemp2."49 Stock" >= RecTemp2."49 iniasig" THEN BEGIN
                                                    RecTemp2."49 Asig" := RecTemp2."49 iniasig";
                                                    RecTemp2.MODIFY();
                                                    "49 AsigU" := "49 Asig";
                                                END;
                                            END;
                                        UNTIL RecTemp2.NEXT() = 0;

                                    IF i = 17 THEN BEGIN
                                        IF "17 Pte Servir" <> 0 THEN
                                            "17 Stock" := "17 Stock" + "17 Asig";
                                        IF "17 Stock" >= "17 inist" THEN
                                            "17 Stock" := "17 inist";
                                    END;
                                    IF i = 18 THEN BEGIN
                                        IF "18 Pte Servir" <> 0 THEN
                                            "18 Stock" := "18 Stock" + "18 Asig";
                                        IF "18 Stock" >= "18 inist" THEN
                                            "18 Stock" := "18 inist";
                                    END;
                                    IF i = 19 THEN BEGIN
                                        IF "19 Pte Servir" <> 0 THEN
                                            "19 Stock" := "19 Stock" + "19 Asig";
                                        IF "19 Stock" >= "19 inist" THEN
                                            "19 Stock" := "19 inist";
                                    END;
                                    IF i = 20 THEN BEGIN
                                        IF "20 Pte Servir" <> 0 THEN
                                            "20 Stock" := "20 Stock" + "20 Asig";
                                        IF "20 Stock" >= "20 inist" THEN
                                            "20 Stock" := "20 inist";
                                    END;
                                    IF i = 21 THEN BEGIN
                                        IF "21 Pte Servir" <> 0 THEN
                                            "21 Stock" := "21 Stock" + "21 Asig";
                                        IF "21 Stock" >= "21 inist" THEN
                                            "21 Stock" := "21 inist";
                                    END;
                                    IF i = 22 THEN BEGIN
                                        IF "22 Pte Servir" <> 0 THEN
                                            "22 Stock" := "22 Stock" + "22 Asig";
                                        IF "22 Stock" >= "22 inist" THEN
                                            "22 Stock" := "22 inist";
                                    END;
                                    IF i = 23 THEN BEGIN
                                        IF "23 Pte Servir" <> 0 THEN
                                            "23 Stock" := "23 Stock" + "23 Asig";
                                        IF "23 Stock" >= "23 inist" THEN
                                            "23 Stock" := "23 inist";
                                    END;
                                    IF i = 24 THEN BEGIN
                                        IF "24 Pte Servir" <> 0 THEN
                                            "24 Stock" := "24 Stock" + "24 Asig";
                                        IF "24 Stock" >= "24 inist" THEN
                                            "24 Stock" := "24 inist";
                                    END;
                                    IF i = 25 THEN BEGIN
                                        IF "25 Pte Servir" <> 0 THEN
                                            "25 Stock" := "25 Stock" + "25 Asig";
                                        IF "25 Stock" >= "25 inist" THEN
                                            "25 Stock" := "25 inist";
                                    END;
                                    IF i = 26 THEN BEGIN
                                        IF "26 Pte Servir" <> 0 THEN
                                            "26 Stock" := "26 Stock" + "26 Asig";
                                        IF "26 Stock" >= "26 inist" THEN
                                            "26 Stock" := "26 inist";
                                    END;
                                    IF i = 27 THEN BEGIN
                                        IF "27 Pte Servir" <> 0 THEN
                                            "27 Stock" := "27 Stock" + "27 Asig";
                                        IF "27 Stock" >= "27 inist" THEN
                                            "27 Stock" := "27 inist";
                                    END;
                                    IF i = 28 THEN BEGIN
                                        IF "28 Pte Servir" <> 0 THEN
                                            "28 Stock" := "28 Stock" + "28 Asig";
                                        IF "28 Stock" >= "28 inist" THEN
                                            "28 Stock" := "28 inist";
                                    END;
                                    IF i = 29 THEN BEGIN
                                        IF "29 Pte Servir" <> 0 THEN
                                            "29 Stock" := "29 Stock" + "29 Asig";
                                        IF "29 Stock" >= "29 inist" THEN
                                            "29 Stock" := "29 inist";
                                    END;
                                    IF i = 30 THEN BEGIN
                                        IF "30 Pte Servir" <> 0 THEN
                                            "30 Stock" := "30 Stock" + "30 Asig";
                                        IF "30 Stock" >= "30 inist" THEN
                                            "30 Stock" := "30 inist";
                                    END;
                                    IF i = 31 THEN BEGIN
                                        IF "31 Pte Servir" <> 0 THEN
                                            "31 Stock" := "31 Stock" + "31 Asig";
                                        IF "31 Stock" >= "31 inist" THEN
                                            "31 Stock" := "31 inist";
                                    END;
                                    IF i = 32 THEN BEGIN
                                        IF "32 Pte Servir" <> 0 THEN
                                            "32 Stock" := "32 Stock" + "32 Asig";
                                        IF "32 Stock" >= "32 inist" THEN
                                            "32 Stock" := "32 inist";
                                    END;
                                    IF i = 33 THEN BEGIN
                                        IF "33 Pte Servir" <> 0 THEN
                                            "33 Stock" := "33 Stock" + "33 Asig";
                                        IF "33 Stock" >= "33 inist" THEN
                                            "33 Stock" := "33 inist";
                                    END;
                                    IF i = 34 THEN BEGIN
                                        IF "34 Pte Servir" <> 0 THEN
                                            "34 Stock" := "34 Stock" + "34 Asig";
                                        IF "34 Stock" >= "34 inist" THEN
                                            "34 Stock" := "34 inist";
                                    END;
                                    IF i = 35 THEN BEGIN
                                        IF "35 Pte Servir" <> 0 THEN
                                            "35 Stock" := "35 Stock" + "35 Asig";
                                        IF "35 Stock" >= "35 inist" THEN
                                            "35 Stock" := "35 inist";
                                    END;
                                    IF i = 36 THEN BEGIN
                                        IF "36 Pte Servir" <> 0 THEN
                                            "36 Stock" := "36 Stock" + "36 Asig";
                                        IF "36 Stock" >= "36 inist" THEN
                                            "36 Stock" := "36 inist";
                                    END;
                                    IF i = 37 THEN BEGIN
                                        IF "37 Pte Servir" <> 0 THEN
                                            "37 Stock" := "37 Stock" + "37 Asig";
                                        IF "37 Stock" >= "37 inist" THEN
                                            "37 Stock" := "37 inist";
                                    END;
                                    IF i = 38 THEN BEGIN
                                        IF "38 Pte Servir" <> 0 THEN
                                            "38 Stock" := "38 Stock" + "38 Asig";
                                        IF "38 Stock" >= "38 inist" THEN
                                            "38 Stock" := "38 inist";
                                    END;
                                    IF i = 39 THEN BEGIN
                                        IF "39 Pte Servir" <> 0 THEN
                                            "39 Stock" := "39 Stock" + "39 Asig";
                                        IF "39 Stock" >= "39 inist" THEN
                                            "39 Stock" := "39 inist";
                                    END;
                                    IF i = 40 THEN BEGIN
                                        IF "40 Pte Servir" <> 0 THEN
                                            "40 Stock" := "40 Stock" + "40 Asig";
                                        IF "40 Stock" >= "40 inist" THEN
                                            "40 Stock" := "40 inist";
                                    END;
                                    IF i = 41 THEN BEGIN
                                        IF "41 Pte Servir" <> 0 THEN
                                            "41 Stock" := "41 Stock" + "41 Asig";
                                        IF "41 Stock" >= "41 inist" THEN
                                            "41 Stock" := "41 inist";
                                    END;
                                    IF i = 42 THEN BEGIN
                                        IF "42 Pte Servir" <> 0 THEN
                                            "42 Stock" := "42 Stock" + "42 Asig";
                                        IF "42 Stock" >= "42 inist" THEN
                                            "42 Stock" := "42 inist";
                                    END;
                                    IF i = 43 THEN BEGIN
                                        IF "43 Pte Servir" <> 0 THEN
                                            "43 Stock" := "43 Stock" + "43 Asig";
                                        IF "43 Stock" >= "43 inist" THEN
                                            "43 Stock" := "43 inist";
                                    END;
                                    IF i = 44 THEN BEGIN
                                        IF "44 Pte Servir" <> 0 THEN
                                            "44 Stock" := "44 Stock" + "44 Asig";
                                        IF "44 Stock" >= "44 inist" THEN
                                            "44 Stock" := "44 inist";
                                    END;
                                    IF i = 45 THEN BEGIN
                                        IF "45 Pte Servir" <> 0 THEN
                                            "45 Stock" := "45 Stock" + "45 Asig";
                                        IF "45 Stock" >= "45 inist" THEN
                                            "45 Stock" := "45 inist";
                                    END;
                                    IF i = 46 THEN BEGIN
                                        IF "46 Pte Servir" <> 0 THEN
                                            "46 Stock" := "46 Stock" + "46 Asig";
                                        IF "46 Stock" >= "46 inist" THEN
                                            "46 Stock" := "46 inist";
                                    END;
                                    IF i = 47 THEN BEGIN
                                        IF "47 Pte Servir" <> 0 THEN
                                            "47 Stock" := "47 Stock" + "47 Asig";
                                        IF "47 Stock" >= "47 inist" THEN
                                            "47 Stock" := "47 inist";
                                    END;
                                    IF i = 48 THEN BEGIN
                                        IF "48 Pte Servir" <> 0 THEN
                                            "48 Stock" := "48 Stock" + "48 Asig";
                                        IF "48 Stock" >= "48 inist" THEN
                                            "48 Stock" := "48 inist";
                                    END;
                                    IF i = 49 THEN BEGIN
                                        IF "49 Pte Servir" <> 0 THEN
                                            "49 Stock" := "49 Stock" + "49 Asig";
                                        IF "49 Stock" >= "49 inist" THEN
                                            "49 Stock" := "49 inist";
                                    END;
                                END;
                            UNTIL RecTemp.NEXT() = 0;
                    END;
                END;

                AsignaLinMatrix(); //EX-SGG 251122
            end;
        }
        field(23; "% B"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = '% B', comment = 'ESP="% B"';
        }
        field(24; "Cantidad Anulada"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Cantidad Anulada', comment = 'ESP="Cantidad Anulada"';
        }
        field(25; "Cantidad Servida"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Cantidad Servida', comment = 'ESP="Cantidad Servida"';
        }
        field(26; "Cantidad Asignada"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Cantidad Asginada', comment = 'ESP="Cantidad Asignada"';
        }
        field(27; "Asigna Cab"; Boolean)
        {
            Caption = 'Asgina Cab', comment = 'ESP="Asgina Cab"';
            CalcFormula = Exist(TemporalPV WHERE(Proceso = FILTER('RFIDTALLAS' | 'WMSTALLAS'),
                                                  "Clave 1" = FIELD("Clave 1"),
                                                  "Asigna Lin" = CONST(true)));
            FieldClass = FlowField;
        }
        field(28; "Cantidad Agrupacion"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Cantidad Agrupacion', comment = 'ESP="Cantidad Agrupacion"';
        }
        field(29; Descripcion; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Descripcion', comment = 'ESP="Descripcion"';
        }
        field(30; Retenido; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Retenido', comment = 'ESP="Retenido"';
        }
        field(31; "Importe Pedido"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Importe Pedido', comment = 'ESP="Importe Pedido"';
        }
        field(32; "Cantidad Picking"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Cantidad Picking', comment = 'ESP="Cantidad Picking"';
        }
        field(33; Clasificadora; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Clasificadora', comment = 'ESP="Clasificadora"';
            trigger OnValidate()
            begin
                IF Proceso = 'RFIDCAB' THEN BEGIN
                    IF Clasificadora AND PDA THEN
                        PDA := FALSE;
                    IF "Supera Riesgo" THEN
                        ERROR('Supera Riesgo');

                    IF "Impago Cliente" THEN
                        ERROR('Impago Cliente');

                    IF Retenido AND Clasificadora THEN
                        MESSAGE('Pedido Retenido');
                END;
            end;
        }
        field(34; PDA; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'PDA', comment = 'ESP="PDA"';
            trigger OnValidate()
            begin
                IF Proceso = 'RFIDCAB' THEN BEGIN
                    IF Clasificadora AND PDA THEN
                        Clasificadora := FALSE;

                    IF "Supera Riesgo" THEN
                        ERROR('Supera Riesgo');

                    IF "Impago Cliente" THEN
                        ERROR('Impago Cliente');

                    IF Retenido AND PDA THEN
                        MESSAGE('Pedido Retenido');
                END;
            end;
        }
        field(35; Eliminar; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Eliminar', comment = 'ESP="Eliminar"';
        }
        field(36; "Cantidad Reserva"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Cantidad Reserva', comment = 'ESP="Cantidad Reserva"';
        }
        field(37; Logistica; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Logistica', comment = 'ESP="Logistica"';
        }
        field(38; "Cod Picking"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cod Picking', comment = 'ESP="Cod Picking"';
        }
        field(39; CodPreemb; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'CodPreemb', comment = 'ESP="CodPreemb"';
        }
        field(40; "Cant Preemb"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Cant Preemb', comment = 'ESP="Cant Preemb"';
        }
        field(41; VarPreemb; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'VarPreemb', comment = 'ESP="VarPreemb"';
        }
        field(42; Linea; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Linea', comment = 'ESP="Linea"';
        }
        field(43; Almacen; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Almacen', comment = 'ESP="Almacen"';
        }
        field(44; "Clave 6"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Clave 6', comment = 'ESP="Clave 6"';
        }
        field(45; "Clave 7"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Clave 7', comment = 'ESP="Clave 7"';
        }
        field(46; "Clave 8"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Clave 8', comment = 'ESP="Clave 8"';
        }
        field(47; "Fecha Servicio"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Fecha Servicio', comment = 'ESP="Fecha Servicio"';
        }
        field(48; Insertado; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Insertado', comment = 'ESP="Insertado"';
        }
        field(49; "Insertado 2"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Insertado 2', comment = 'ESP="Insertado 2"';
        }
        field(100; "17 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '17 Stock', comment = 'ESP="17 Stock"';
        }
        field(101; "18 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '18 Stock', comment = 'ESP="18 Stock"';
        }
        field(102; "19 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '19 Stock', comment = 'ESP="19 Stock"';
        }
        field(103; "20 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '20 Stock', comment = 'ESP="20 Stock"';
        }
        field(104; "21 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '21 Stock', comment = 'ESP="21 Stock"';
        }
        field(105; "22 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '22 Stock', comment = 'ESP="22 Stock"';
        }
        field(106; "23 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '23 Stock', comment = 'ESP="23 Stock"';
        }
        field(107; "24 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '24 Stock', comment = 'ESP="24 Stock"';
        }
        field(108; "25 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '25 Stock', comment = 'ESP="25 Stock"';
        }
        field(109; "26 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '26 Stock', comment = 'ESP="26 Stock"';
        }
        field(110; "27 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '27 Stock', comment = 'ESP="27 Stock"';
        }
        field(111; "28 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '28 Stock', comment = 'ESP="28 Stock"';
        }
        field(112; "29 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '29 Stock', comment = 'ESP="29 Stock"';
        }
        field(113; "30 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '30 Stock', comment = 'ESP="30 Stock"';
        }
        field(114; "31 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '31 Stock', comment = 'ESP="31 Stock"';
        }
        field(115; "32 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '32 Stock', comment = 'ESP="32 Stock"';
        }
        field(116; "33 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '33 Stock', comment = 'ESP="33 Stock"';
        }
        field(117; "34 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '34 Stock', comment = 'ESP="34 Stock"';
        }
        field(118; "35 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '35 Stock', comment = 'ESP="35 Stock"';
        }
        field(119; "36 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '36 Stock', comment = 'ESP="36 Stock"';
        }
        field(120; "37 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '37 Stock', comment = 'ESP="37 Stock"';
        }
        field(121; "38 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '38 Stock', comment = 'ESP="38 Stock"';
        }
        field(122; "39 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '39 Stock', comment = 'ESP="39 Stock"';
        }
        field(123; "40 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '40 Stock', comment = 'ESP="40 Stock"';
        }
        field(124; "41 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '41 Stock', comment = 'ESP="41 Stock"';
        }
        field(125; "42 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '42 Stock', comment = 'ESP="42 Stock"';
        }
        field(126; "43 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '43 Stock', comment = 'ESP="43 Stock"';
        }
        field(127; "44 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '44 Stock', comment = 'ESP="44 Stock"';
        }
        field(128; "45 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '45 Stock', comment = 'ESP="45 Stock"';
        }
        field(129; "46 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '46 Stock', comment = 'ESP="46 Stock"';
        }
        field(130; "47 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '47 Stock', comment = 'ESP="47 Stock"';
        }
        field(131; "48 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '48 Stock', comment = 'ESP="48 Stock"';
        }
        field(132; "49 Stock"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '49 Stock', comment = 'ESP="49 Stock"';
        }
        field(200; "17 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '17 Pte Servir', comment = 'ESP="17 Pte Servir"';
        }
        field(201; "18 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '18 Pte Servir', comment = 'ESP="18 Pte Servir"';
        }
        field(202; "19 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '19 Pte Servir', comment = 'ESP="19 Pte Servir"';
        }
        field(203; "20 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '20 Pte Servir', comment = 'ESP="20 Pte Servir"';
        }
        field(204; "21 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '21 Pte Servir', comment = 'ESP="21 Pte Servir"';
        }
        field(205; "22 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '22 Pte Servir', comment = 'ESP="22 Pte Servir"';
        }
        field(206; "23 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '23 Pte Servir', comment = 'ESP="23 Pte Servir"';
        }
        field(207; "24 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '24 Pte Servir', comment = 'ESP="24 Pte Servir"';
        }
        field(208; "25 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '25 Pte Servir', comment = 'ESP="25 Pte Servir"';
        }
        field(209; "26 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '26 Pte Servir', comment = 'ESP="26 Pte Servir"';
        }
        field(210; "27 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '27 Pte Servir', comment = 'ESP="27 Pte Servir"';
        }
        field(211; "28 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '28 Pte Servir', comment = 'ESP="28 Pte Servir"';
        }
        field(212; "29 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '29 Pte Servir', comment = 'ESP="29 Pte Servir"';
        }
        field(213; "30 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '30 Pte Servir', comment = 'ESP="30 Pte Servir"';
        }
        field(214; "31 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '31 Pte Servir', comment = 'ESP="31 Pte Servir"';
        }
        field(215; "32 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '32 Pte Servir', comment = 'ESP="32 Pte Servir"';
        }
        field(216; "33 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '33 Pte Servir', comment = 'ESP="33 Pte Servir"';
        }
        field(217; "34 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '34 Pte Servir', comment = 'ESP="34 Pte Servir"';
        }
        //vero
        field(218; "35 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '35 Pte Servir', comment = 'ESP="35 Pte Servir"';
        }
        field(219; "36 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '36 Pte Servir', comment = 'ESP="36 Pte Servir"';
        }
        field(220; "37 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '37 Pte Servir', comment = 'ESP="37 Pte Servir"';
        }
        field(221; "38 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '38 Pte Servir', comment = 'ESP="38 Pte Servir"';
        }
        field(222; "39 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '39 Pte Servir', comment = 'ESP="39 Pte Servir"';
        }
        field(223; "40 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '40 Pte Servir', comment = 'ESP="40 Pte Servir"';
        }
        field(224; "41 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '41 Pte Servir', comment = 'ESP="41 Pte Servir"';
        }
        field(225; "42 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '42 Pte Servir', comment = 'ESP="42 Pte Servir"';
        }
        field(226; "43 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '43 Pte Servir', comment = 'ESP="43 Pte Servir"';
        }
        field(227; "44 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '44 Pte Servir', comment = 'ESP="44 Pte Servir"';
        }
        field(228; "45 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '45 Pte Servir', comment = 'ESP="45 Pte Servir"';
        }
        field(229; "46 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '46 Pte Servir', comment = 'ESP="46 Pte Servir"';
        }
        field(230; "47 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '47 Pte Servir', comment = 'ESP="47 Pte Servir"';
        }
        field(231; "48 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '48 Pte Servir', comment = 'ESP="48 Pte Servir"';
        }
        field(232; "49 Pte Servir"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '49 Pte Servir', comment = 'ESP="49 Pte Servir"';
        }
        field(300; "17 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '17 Asig"', comment = 'ESP="17 Asig""';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN

                    IF "Asigna Lin" THEN
                        ERROR(LabelName);
                    IF "17 Asig" > "17 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);
                    "17 AsigU" := "17 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');

                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '17');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "17 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');

                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."17 AsigU" := "17 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(301; "18 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '18 Asig', comment = 'ESP="18 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN

                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "18 Asig" > "18 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "18 AsigU" := "18 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');

                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '18');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "18 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');

                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."18 AsigU" := "18 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(302; "19 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '19 Asig', comment = 'ESP="19 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN

                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "19 Asig" > "19 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "19 AsigU" := "19 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');

                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '19');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "19 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');

                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."19 AsigU" := "19 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(303; "20 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '20 Asig', comment = 'ESP="20 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "20 Asig" > "20 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "20 AsigU" := "20 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '20');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        REPEAT
                            RecTemp."Cantidad Asignada" := "20 Asig";
                            RecTemp.MODIFY();
                        UNTIL RecTemp.NEXT() = 0;
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."20 AsigU" := "20 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(304; "21 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '21 Asig', comment = 'ESP="21 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "21 Asig" > "21 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "21 AsigU" := "21 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '21');
                    IF RecTemp.FINDFIRST() THEN
                        REPEAT
                            RecTemp."Cantidad Asignada" := "21 Asig";
                            RecTemp.MODIFY();
                        UNTIL RecTemp.NEXT() = 0;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."21 AsigU" := "21 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(305; "22 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '22 Asig', comment = 'ESP="22 Asig"';
            trigger OnValidate()

            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "22 Asig" > "22 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "22 AsigU" := "22 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '22');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "22 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."22 AsigU" := "22 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(306; "23 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '23 Asig', comment = 'ESP="23 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "23 Asig" > "23 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "23 AsigU" := "23 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '23');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "23 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."23 AsigU" := "23 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(307; "24 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '24 Asig', comment = 'ESP="24 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "24 Asig" > "24 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "24 AsigU" := "24 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '24');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "24 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."24 AsigU" := "24 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(308; "25 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '25 Asig', comment = 'ESP="25 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "25 Asig" > "25 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "25 AsigU" := "25 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '25');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "25 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."25 AsigU" := "25 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(309; "26 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '26 Asig', comment = 'ESP="26 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "26 Asig" > "26 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "26 AsigU" := "26 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '26');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "26 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."26 AsigU" := "26 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(310; "27 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '27 Asig', comment = 'ESP="27 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "27 Asig" > "27 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "27 AsigU" := "27 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '27');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "27 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."27 AsigU" := "27 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(311; "28 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '28 Asig', comment = 'ESP="28 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "28 Asig" > "28 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "28 AsigU" := "28 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '28');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "28 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."28 AsigU" := "28 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(312; "29 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '29 Asig', comment = 'ESP="29 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "29 Asig" > "29 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "29 AsigU" := "29 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '29');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "29 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."29 AsigU" := "29 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(313; "30 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '30 Asig', comment = 'ESP="30 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "30 Asig" > "30 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "30 AsigU" := "30 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '30');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "30 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."30 AsigU" := "30 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(314; "31 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '31 Asig', comment = 'ESP="31 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "31 Asig" > "31 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "31 AsigU" := "31 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '31');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "31 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."31 AsigU" := "31 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(315; "32 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '32 Asig', comment = 'ESP="32 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "32 Asig" > "32 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "32 AsigU" := "32 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '32');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "32 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."32 AsigU" := "32 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(316; "33 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '33 Asig', comment = 'ESP="33 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "33 Asig" > "33 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "33 AsigU" := "33 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '33');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "33 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."33 AsigU" := "33 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(317; "34 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '34 Asig', comment = 'ESP="34 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "34 Asig" > "34 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "34 AsigU" := "34 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '34');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "34 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."34 AsigU" := "34 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(318; "35 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '35 Asig', comment = 'ESP="35 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "35 Asig" > "35 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "35 AsigU" := "35 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '35');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "35 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."35 AsigU" := "35 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(319; "36 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '36 Asig', comment = 'ESP="36 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "36 Asig" > "36 Pte Servir" THEN
                        ERROR(LabelName1);

                    "36 AsigU" := "36 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '36');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "36 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."36 AsigU" := "36 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(320; "37 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '37 Asig', comment = 'ESP="37 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "37 Asig" > "37 Pte Servir" THEN
                        ERROR(LabelName1);

                    "37 AsigU" := "37 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '37');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "37 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."37 AsigU" := "37 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(321; "38 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '38 Asig', comment = 'ESP="38 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "38 Asig" > "38 Pte Servir" THEN
                        ERROR(LabelName1);

                    "38 AsigU" := "38 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '38');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "38 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."38 AsigU" := "38 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(322; "39 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '39 Asig', comment = 'ESP="39 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "39 Asig" > "39 Pte Servir" THEN
                        ERROR(LabelName1);

                    "39 AsigU" := "39 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '39');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "39 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."39 AsigU" := "39 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(323; "40 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '40 Asig', comment = 'ESP="40 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "40 Asig" > "40 Pte Servir" THEN
                        ERROR(LabelName1);

                    "40 AsigU" := "40 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '40');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "40 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."40 AsigU" := "40 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(324; "41 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '41 Asig', comment = 'ESP="41 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "41 Asig" > "41 Pte Servir" THEN
                        ERROR(LabelName1);

                    "41 AsigU" := "41 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '41');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "41 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."41 AsigU" := "41 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(325; "42 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '42 Asig', comment = 'ESP="42 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "42 Asig" > "42 Pte Servir" THEN
                        ERROR(LabelName1);

                    "42 AsigU" := "42 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '42');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "42 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."42 AsigU" := "42 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(326; "43 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '43 Asig', comment = 'ESP="43 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "43 Asig" > "43 Pte Servir" THEN
                        ERROR(LabelName1);

                    "43 AsigU" := "43 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '43');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "43 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."43 AsigU" := "43 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(327; "44 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '44 Asig', comment = 'ESP="44 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "44 Asig" > "44 Pte Servir" THEN
                        ERROR(LabelName1);

                    "44 AsigU" := "44 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '44');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "44 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."44 AsigU" := "44 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(328; "45 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '45 Asig', comment = 'ESP="45 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';

            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "45 Asig" > "45 Pte Servir" THEN
                        ERROR(LabelName1);

                    "45 AsigU" := "45 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '45');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "45 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."45 AsigU" := "45 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(329; "46 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '46 Asig', comment = 'ESP="46 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "46 Asig" > "46 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "46 AsigU" := "46 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '46');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "46 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."46 AsigU" := "46 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(330; "47 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '47 Asig', comment = 'ESP="47 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "47 Asig" > "47 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "47 AsigU" := "47 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '47');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "47 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."47 AsigU" := "47 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(331; "48 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '48 Asig', comment = 'ESP="48 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "48 Asig" > "48 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "48 AsigU" := "48 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '48');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "48 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."48 AsigU" := "48 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(332; "49 Asig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '49 Asig', comment = 'ESP="49 Asig"';
            trigger OnValidate()
            var
                LabelName: Label 'You must uncheck Line Assignment', comment = 'ESP="Debe desmarcar Asignación líneas"';
                LabelName1: Label 'Allocation greater than Amount to Serve', comment = 'ESP="Asignación mayor que Cantidad Pte Servir"';
                LabelName2: Label 'Cannot be modified prepackaged', comment = 'ESP="No se puede modificar preembalado"';
            begin

                IF (Proceso = 'RFIDTALLAS') OR (Proceso = 'WMSTALLAS') THEN BEGIN
                    IF "Asigna Lin" THEN
                        ERROR(LabelName);

                    IF "49 Asig" > "49 Pte Servir" THEN
                        ERROR(LabelName1);
                    IF "Clave 6" <> '' THEN
                        ERROR(LabelName2);

                    "49 AsigU" := "49 Asig";
                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    RecTemp.SETRANGE(Talla, '49');
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."Cantidad Asignada" := "49 Asig";
                        RecTemp.MODIFY();
                    END;

                    RecTemp.RESET();

                    RecTemp.SETFILTER(Proceso, 'RFIDT2|WMST2');
                    RecTemp.SETRANGE(usuario, USERID);
                    RecTemp.SETRANGE("Clave 1", "Clave 1");
                    RecTemp.SETRANGE("Clave 2", '.ASIGNADO');
                    RecTemp.SETRANGE("Clave 3", "Clave 3");
                    RecTemp.SETRANGE("Clave 4", "Clave 4");
                    RecTemp.SETRANGE("Clave 5", "Clave 5");
                    IF RecTemp.FINDFIRST() THEN BEGIN
                        RecTemp."49 AsigU" := "49 Asig";
                        RecTemp.MODIFY();
                    END;
                END;
            end;
        }
        field(400; "17 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '17 AsigU', comment = 'ESP="17 AsigU"';
        }
        field(401; "18 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '18 AsigU', comment = 'ESP="18 AsigU"';
        }
        field(402; "19 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '19 AsigU', comment = 'ESP="19 AsigU"';
        }
        field(403; "20 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '20 AsigU', comment = 'ESP="20 AsigU"';
        }
        field(404; "21 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '21 AsigU', comment = 'ESP="21 AsigU"';
        }
        field(405; "22 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '22 AsigU', comment = 'ESP="22 AsigU"';
        }
        field(406; "23 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '23 AsigU', comment = 'ESP="23 AsigU"';
        }
        field(407; "24 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '24 AsigU', comment = 'ESP="24 AsigU"';
        }
        field(408; "25 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '25 AsigU', comment = 'ESP="25 AsigU"';
        }
        field(409; "26 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '26 AsigU', comment = 'ESP="26 AsigU"';
        }
        field(410; "27 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '27 AsigU', comment = 'ESP="27 AsigU"';
        }
        field(411; "28 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '28 AsigU', comment = 'ESP="28 AsigU"';
        }
        field(412; "29 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '29 AsigU', comment = 'ESP="29 AsigU"';
        }
        field(413; "30 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '30 AsigU', comment = 'ESP="30 AsigU"';
        }
        field(414; "31 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '31 AsigU', comment = 'ESP="31 AsigU"';
        }
        field(415; "32 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '32 AsigU', comment = 'ESP="32 AsigU"';
        }
        field(416; "33 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '33 AsigU', comment = 'ESP="33 AsigU"';
        }
        field(417; "34 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '34 AsigU', comment = 'ESP="34 AsigU"';
        }
        field(418; "35 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '35 AsigU', comment = 'ESP="35 AsigU"';
        }
        field(419; "36 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '36 AsigU', comment = 'ESP="36 AsigU"';
        }
        field(420; "37 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '37 AsigU', comment = 'ESP="37 AsigU"';
        }
        field(421; "38 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '38 AsigU', comment = 'ESP="38 AsigU"';
        }
        field(422; "39 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '39 AsigU', comment = 'ESP="39 AsigU"';
        }
        field(423; "40 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '40 AsigU', comment = 'ESP="40 AsigU"';
        }
        field(424; "41 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '41 AsigU', comment = 'ESP="41 AsigU"';
        }
        field(425; "42 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '42 AsigU', comment = 'ESP="42 AsigU"';
        }
        field(426; "43 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '43 AsigU', comment = 'ESP="43 AsigU"';
        }
        field(427; "44 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '44 AsigU', comment = 'ESP="44 AsigU"';
        }
        field(428; "45 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '45 AsigU', comment = 'ESP="45 AsigU"';
        }
        field(429; "46 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '46 AsigU', comment = 'ESP="46 AsigU"';
        }
        field(430; "47 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '47 AsigU', comment = 'ESP="47 AsigU"';
        }
        field(431; "48 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '48 AsigU', comment = 'ESP="48 AsigU"';
        }
        field(432; "49 AsigU"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '49 AsigU', comment = 'ESP="49 AsigU"';
        }
        field(433; "Supera Riesgo"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Overcome Risk', comment = 'ESP="Supera Riesgo"';
        }
        field(434; "17 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Type', comment = 'ESP="Tipo"';
        }
        field(435; "18 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Type', comment = 'ESP="Tipo"';
        }
        field(436; "19 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Type', comment = 'ESP="Tipo"';
        }
        field(437; "20 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '20 iniasig', comment = 'ESP="20 iniasig"';
        }
        field(438; "21 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '21 iniasig', comment = 'ESP="21 iniasig"';
        }
        field(439; "22 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '22 iniasig', comment = 'ESP="22 iniasig"';
        }
        field(440; "23 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '23 iniasig', comment = 'ESP="23 iniasig"';
        }
        field(441; "24 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '24 iniasig', comment = 'ESP="24 iniasig"';
        }
        field(442; "25 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '25 iniasig', comment = 'ESP="25 iniasig"';
        }
        field(443; "26 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '26 iniasig', comment = 'ESP="26 iniasig"';
        }
        field(444; "27 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '27 iniasig', comment = 'ESP="27 iniasig"';
        }
        field(445; "28 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '28 iniasig', comment = 'ESP="28 iniasig"';
        }
        field(446; "29 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '29 iniasig', comment = 'ESP="29 iniasig"';
        }
        field(447; "30 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '30 iniasig', comment = 'ESP="30 iniasig"';
        }
        field(448; "31 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '31 iniasig', comment = 'ESP="31 iniasig"';
        }
        field(449; "32 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '32 iniasig', comment = 'ESP="32 iniasig"';
        }
        field(450; "33 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '33 iniasig', comment = 'ESP="33 iniasig"';
        }
        field(451; "34 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '34 iniasig', comment = 'ESP="34 iniasig"';
        }
        field(452; "35 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '35 iniasig', comment = 'ESP="35 iniasig"';
        }
        field(453; "36 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '36 iniasig', comment = 'ESP="36 iniasig"';
        }
        field(454; "37 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '37 iniasig', comment = 'ESP="37 iniasig"';
        }
        field(455; "38 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '38 iniasig', comment = 'ESP="38 iniasig"';
        }
        field(456; "39 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '39 iniasig', comment = 'ESP="39 iniasig"';
        }
        field(457; "40 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '40 iniasig', comment = 'ESP="40 iniasig"';
        }
        field(458; "41 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '41 iniasig', comment = 'ESP="41 iniasig"';
        }
        field(459; "42 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '42 iniasig', comment = 'ESP="42 iniasig"';
        }
        field(460; "43 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '43 iniasig', comment = 'ESP="43 iniasig"';
        }
        field(461; "44 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '44 iniasig', comment = 'ESP="44 iniasig"';
        }
        field(462; "45 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '45 iniasig', comment = 'ESP="45 iniasig"';
        }
        field(463; "46 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '46 iniasig', comment = 'ESP="46 iniasig"';
        }
        field(464; "47 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '47 iniasig', comment = 'ESP="47 iniasig"';
        }
        field(465; "48 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '48 iniasig', comment = 'ESP="48 iniasig"';
        }
        field(466; "49 iniasig"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '49 iniasig', comment = 'ESP="49 iniasig"';
        }
        field(500; "17 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '17 inist', comment = 'ESP="17 inist"';
        }
        field(501; "18 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '18 inist', comment = 'ESP="18 inist"';
        }
        field(502; "19 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '19 inist', comment = 'ESP="19 inist"';
        }
        field(503; "20 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '20 inist', comment = 'ESP="20 inist"';
        }
        field(504; "21 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '21 inist', comment = 'ESP="21 inist"';
        }
        field(505; "22 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '22 inist', comment = 'ESP="22 inist"';
        }
        field(506; "23 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '23 inist', comment = 'ESP="23 inist"';
        }
        field(507; "24 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '24 inist', comment = 'ESP="24 inist"';
        }
        field(508; "25 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '25 inist', comment = 'ESP="25 inist"';
        }
        field(509; "26 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '26 inist', comment = 'ESP="26 inist"';
        }
        field(510; "27 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '27 inist', comment = 'ESP="27 inist"';
        }
        field(511; "28 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '28 inist', comment = 'ESP="28 inist"';
        }
        field(512; "29 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '29 inist', comment = 'ESP="29 inist"';
        }
        field(513; "30 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '30 inist', comment = 'ESP="30 inist"';
        }
        field(514; "31 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '31 inist', comment = 'ESP="31 inist"';
        }
        field(515; "32 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '32 inist', comment = 'ESP="32 inist"';
        }
        field(516; "33 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '33 inist', comment = 'ESP="33 inist"';
        }
        field(517; "34 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '34 inist', comment = 'ESP="34 inist"';
        }
        field(518; "35 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '35 inist', comment = 'ESP="35 inist"';
        }
        field(519; "36 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '36 inist', comment = 'ESP="36 inist"';
        }
        field(520; "37 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '37 inist', comment = 'ESP="37 inist"';
        }
        field(521; "38 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '38 inist', comment = 'ESP="38 inist"';
        }
        field(522; "39 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '39 inist', comment = 'ESP="39 inist"';
        }
        field(523; "40 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '40 inist', comment = 'ESP="40 inist"';
        }
        field(524; "41 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '41 inist', comment = 'ESP="41 inist"';
        }
        field(525; "42 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '42 inist', comment = 'ESP="42 inist"';
        }
        field(526; "43 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '43 inist', comment = 'ESP="43 inist"';
        }
        field(527; "44 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '44 inist', comment = 'ESP="44 inist"';
        }
        field(528; "45 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '45 inist', comment = 'ESP="45 inist"';
        }
        field(529; "46 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '46 inist', comment = 'ESP="46 inist"';
        }
        field(530; "47 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '47 inist', comment = 'ESP="47 inist"';
        }
        field(531; "48 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '48 inist', comment = 'ESP="48 inist"';
        }
        field(532; "49 inist"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = '49 inist', comment = 'ESP="49 inist"';
        }
        field(533; "Importe Asignado"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Importe Asignado', comment = 'ESP="Importe Asignado"';
        }
        field(534; "Importe Pte No anul"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Importe Pte No anul', comment = 'ESP="Importe Pte No anul"';
        }
        field(535; Origen; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Origen', comment = 'ESP="Origen"';
        }
        field(536; "Importe Asignado Cli"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Importe Asignado Cli', comment = 'ESP="Importe Asignado Cli"';
        }
        field(537; "Reserva Pedido"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Reserva Pedido', comment = 'ESP="Reserva Pedido"';
        }
        field(538; "Picking Pedido"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Picking Pedido', comment = 'ESP="Picking Pedido"';
        }
        field(539; ComentarioPed; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'ComentarioPed', comment = 'ESP="ComentarioPed"';
        }
        field(540; "Impago Cliente"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Impago Cliente', comment = 'ESP="Impago Cliente"';
        }
        field(541; "Riesgo NMilenio"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Riesgo NMilenio', comment = 'ESP="Riesgo NMilenio"';
        }
        field(542; "Cod Representante"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Cod Representante', comment = 'ESP="Cod Representante"';
        }
        field(600; "17 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '17 fecha', comment = 'ESP="17 fecha"';
        }
        field(601; "18 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '18 fecha', comment = 'ESP="18 fecha"';
        }
        field(602; "19 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '19 fecha', comment = 'ESP="19 fecha"';
        }
        field(603; "20 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '20 fecha', comment = 'ESP="20 fecha"';
        }
        field(604; "21 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '21 fecha', comment = 'ESP="21 fecha"';
        }
        field(605; "22 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '22 fecha', comment = 'ESP="22 fecha"';
        }
        field(606; "23 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '23 fecha', comment = 'ESP="23 fecha"';
        }
        field(607; "24 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '24 fecha', comment = 'ESP="24 fecha"';
        }
        field(608; "25 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '25 fecha', comment = 'ESP="25 fecha"';
        }
        field(609; "26 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '26 fecha', comment = 'ESP="26 fecha"';
        }
        field(610; "27 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '27 fecha', comment = 'ESP="27 fecha"';
        }
        field(611; "28 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '28 fecha', comment = 'ESP="28 fecha"';
        }
        field(612; "29 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '29 fecha', comment = 'ESP="29 fecha"';
        }
        field(613; "30 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '30 fecha', comment = 'ESP="30 fecha"';
        }
        field(614; "31 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '31 date', comment = 'ESP="31 fecha"';
        }
        field(615; "32 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '32 date', comment = 'ESP="32 fecha"';
        }
        field(616; "33 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '33 date', comment = 'ESP="33 fecha"';
        }
        field(617; "34 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '34 date', comment = 'ESP="34 fecha"';
        }
        field(618; "35 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '35 date', comment = 'ESP="35 fecha"';
        }
        field(619; "36 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '36 date', comment = 'ESP="36 fecha"';
        }
        field(620; "37 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '37 date', comment = 'ESP="37 fecha"';
        }
        field(621; "38 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '38 date', comment = 'ESP="38 fecha"';
        }
        field(622; "39 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '39 date', comment = 'ESP="39 fecha"';
        }
        field(623; "40 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '40 date', comment = 'ESP="40 fecha"';
        }
        field(624; "41 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '41 date', comment = 'ESP="41 fecha"';
        }
        field(625; "42 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '42 date', comment = 'ESP="42 fecha"';
        }
        field(626; "43 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '43 date', comment = 'ESP="43 fecha"';
        }
        field(627; "44 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '44 date', comment = 'ESP="44 fecha"';
        }
        field(628; "45 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '45 date', comment = 'ESP="45 fecha"';
        }
        field(629; "46 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '46 date', comment = 'ESP="46 fecha"';
        }
        field(630; "47 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '47 date', comment = 'ESP="47 fecha"';
        }
        field(631; "48 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '48 date', comment = 'ESP="48 fecha"';
        }
        field(632; "49 fecha"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = '49 date', comment = 'ESP="49 fecha"';
        }
        field(700; "17 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '17 SP', comment = 'ESP="17 SP"';
        }
        field(701; "18 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '18 SP', comment = 'ESP="18 SP"';
        }
        field(702; "19 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '19 SP', comment = 'ESP="19 SP"';
        }
        field(703; "20 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '20 SP', comment = 'ESP="20 SP"';
        }
        field(704; "21 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '21 SP', comment = 'ESP="21 SP"';
        }
        field(705; "22 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '22 SP', comment = 'ESP="22 SP"';
        }
        field(706; "23 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '23 SP', comment = 'ESP="23 SP"';
        }
        field(707; "24 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '24 SP', comment = 'ESP="24 SP"';
        }
        field(708; "25 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '25 SP', comment = 'ESP="25 SP"';
        }
        field(709; "26 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '26 SP', comment = 'ESP="26 SP"';
        }
        field(710; "27 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '27 SP', comment = 'ESP="27 SP"';
        }
        field(711; "28 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '28 SP', comment = 'ESP="28 SP"';
        }
        field(712; "29 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '29 SP', comment = 'ESP="29 SP"';
        }
        field(713; "30 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '30 SP', comment = 'ESP="30 SP"';
        }
        field(714; "31 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '31 SP', comment = 'ESP="31 SP"';
        }
        field(715; "32 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '32 SP', comment = 'ESP="32 SP"';
        }
        field(716; "33 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '33 SP', comment = 'ESP="33 SP"';
        }
        field(717; "34 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '34 SP', comment = 'ESP="34 SP"';
        }
        field(718; "35 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '35 SP', comment = 'ESP="35 SP"';
        }
        field(719; "36 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '36 SP', comment = 'ESP="36 SP"';
        }
        field(720; "37 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '37 SP', comment = 'ESP="37 SP"';
        }
        field(721; "38 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '38 SP', comment = 'ESP="38 SP"';
        }
        field(722; "39 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '39 SP', comment = 'ESP="39 SP"';
        }
        field(723; "40 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '40 SP', comment = 'ESP="40 SP"';
        }
        field(724; "41 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '41 SP', comment = 'ESP="41 SP"';
        }
        field(725; "42 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '42 SP', comment = 'ESP="42 SP"';
        }
        field(726; "43 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '43 SP', comment = 'ESP="43 SP"';
        }
        field(727; "44 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '44 SP', comment = 'ESP="44 SP"';
        }
        field(728; "45 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '59 SP', comment = 'ESP="45 SP"';
        }
        field(729; "46 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '46 SP', comment = 'ESP="46 SP"';
        }
        field(730; "47 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '47 SP', comment = 'ESP="47 SP"';
        }
        field(731; "48 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '48 SP', comment = 'ESP="48 SP"';
        }
        field(732; "49 SP"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '49 SP', comment = 'ESP="49 SP"';
        }
        field(799; "Serie Servicio"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Service Series', comment = 'ESP="Serie Servicio"';
        }
        field(800; "17 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '17 SS', comment = 'ESP="17 SS"';
        }
        field(801; "18 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '18 SS', comment = 'ESP="18 SS"';
        }
        field(802; "19 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '19 SS', comment = 'ESP="19 SS"';
        }
        field(803; "20 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '20 SS', comment = 'ESP="20 SS"';
        }
        field(804; "21 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '21 SS', comment = 'ESP="21 SS"';
        }
        field(805; "22 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '22 SS', comment = 'ESP="22 SS"';
        }
        field(806; "23 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '23 SS', comment = 'ESP="23 SS"';
        }
        field(807; "24 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '24 SS', comment = 'ESP="24 SS"';
        }
        field(808; "25 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '25 SS', comment = 'ESP="25 SS"';
        }
        field(809; "26 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '26 SS', comment = 'ESP="26 SS"';
        }
        field(810; "27 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '27 SS', comment = 'ESP="27 SS"';
        }
        field(811; "28 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '28 SS', comment = 'ESP="28 SS"';
        }
        field(812; "29 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '29 SS', comment = 'ESP="29 SS"';
        }
        field(813; "30 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '30 SS', comment = 'ESP="30 SS"';
        }
        field(814; "31 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '31 SS', comment = 'ESP="31 SS"';
        }
        field(815; "32 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '32 SS', comment = 'ESP="32 SS"';
        }
        field(816; "33 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '33 SS', comment = 'ESP="33 SS"';
        }
        field(817; "34 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '34 SS', comment = 'ESP="34 SS"';
        }
        field(818; "35 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '35 SS', comment = 'ESP="35 SS"';
        }
        field(819; "36 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '36 SS', comment = 'ESP="36 SS"';
        }
        field(820; "37 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '37 SS', comment = 'ESP="37 SS"';
        }
        field(821; "38 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '38 SS', comment = 'ESP="38 SS"';
        }
        field(822; "39 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '39 SS', comment = 'ESP="39 SS"';
        }
        field(823; "40 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '40 SS', comment = 'ESP="40 SS"';
        }
        field(824; "41 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '41 SS', comment = 'ESP="41 SS"';
        }
        field(825; "42 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '42 SS', comment = 'ESP="42 SS"';
        }
        field(826; "43 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '43 SS', comment = 'ESP="43 SS"';
        }
        field(827; "44 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '44 SS', comment = 'ESP="44 SS"';
        }
        field(828; "45 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '45 SS', comment = 'ESP="45 SS"';
        }
        field(829; "46 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '46 SS', comment = 'ESP="46 SS"';
        }
        field(830; "47 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '47 SS', comment = 'ESP="47 SS"';
        }
        field(831; "48 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '48 SS', comment = 'ESP="48 SS"';
        }
        field(832; "49 SS"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = '49 SS', comment = 'ESP="49 SS"';
        }
        // field(838;"Nº Picking";Integer)
        // {
        //     CalcFormula = Count("Picking Cabecera" WHERE ("Nº Pedido"=FIELD("Clave 1"),
        //                                                   Enviado=FILTER(<>Todo)));
        //     Description = 'SF-RAF';
        //     FieldClass = FlowField;
        // }
        // field(839;"Fecha Picking";Date)
        // {
        //     CalcFormula = Max("Picking Cabecera"."Fecha Picking" WHERE (Nº Pedido=FIELD(Clave 1),
        //                                                                 Enviado=FILTER(<>Todo)));
        //     Description = 'SF-RAF';
        //     FieldClass = FlowField;
        // }
        field(840; Albaranes; Integer)
        {
            CalcFormula = Count("Sales Shipment Header" WHERE("Order No." = FIELD("Clave 1")));
            Description = 'SF-RAF';
            FieldClass = FlowField;
            Caption = 'Delivery notes', comment = 'ESP="Albaranes"';
        }
        field(841; "Fecha Albaran"; Date)
        {
            CalcFormula = Max("Sales Shipment Header"."Posting Date" WHERE("Order No." = FIELD("Clave 1")));
            Description = 'SF-RAF';
            FieldClass = FlowField;
            Caption = 'Delivery note date', comment = 'ESP="Fecha Albaran"';
        }
        field(900; "Tipo de producto"; Option)
        {
            Description = 'EX-SGG 171122';
            OptionCaption = 'Calzado,Materia,Publicidad,Accesorio';
            OptionMembers = Calzado,Materia,Publicidad,Accesorio;
            DataClassification = ToBeClassified;
            Caption = 'Product Type', comment = 'ESP="Tipo de producto"';
        }
        field(901; "Cod. grupo talla"; Code[10])
        {
            Description = 'EX-SGG 171122';
            DataClassification = ToBeClassified;
            Caption = 'Size group code', comment = 'ESP="Cod. grupo talla"';
        }
        field(902; "Tipo columna matrix"; Option)
        {
            Description = 'EX-SGG 171122';
            OptionCaption = ' ,Pdte servir,Stock,Asig';
            OptionMembers = " ","Pdte servir",Stock,Asig;
            DataClassification = ToBeClassified;
            Caption = 'Matrix column type', comment = 'ESP="Tipo columna matrix"';
        }
        field(903; "Tipo proposicion calculada"; Option)
        {
            Description = 'EX-SGG 091222';
            OptionCaption = ' ,Normal,Matriz';
            OptionMembers = " ",Normal,Matriz;
            DataClassification = ToBeClassified;
            Caption = 'Calculated proposition type', comment = 'ESP="Tipo proposicion calculada"';
        }
        field(904; "Modificado por usuario"; Boolean)
        {
            Description = 'EX-SGG 191222';
            DataClassification = ToBeClassified;
            Caption = 'Modified by user', comment = 'ESP="Modificado por usuario"';
        }
        field(50400; "Cant. envios lanzados"; Decimal)
        {
            Description = 'EX-SGG-WMS 100919';
            DataClassification = ToBeClassified;
            Caption = 'Number of shipments released', comment = 'ESP="Cant. envios lanzados"';
        }
        field(50401; "Cant. envios lanzados pedido"; Decimal)
        {
            Description = 'EX-SGG-WMS 100919';
            DataClassification = ToBeClassified;
            Caption = 'Quantity of shipments released ordered', comment = 'ESP="Cant. envios lanzados pedido"';
        }
        field(50402; "Total Pdt Servir"; Integer)
        {
            Description = 'EX-DRG-WMS 301020';
            DataClassification = ToBeClassified;
            Caption = 'Total Pdt Serve', comment = 'ESP="Total Pdt Servir"';
        }
        field(50403; "Consignacion venta"; Boolean)
        {
            Description = 'EX-CGR-140920';
            DataClassification = ToBeClassified;
            Caption = 'Sales consignment', comment = 'ESP="Consignación venta"';
        }
    }

    keys
    {
        key(Key1; "Clave 1", "Clave 2", "Clave 3", "Clave 4", "Clave 5", "Clave 6", "Clave 7", "Clave 8", Contador, Proceso)
        {
            Clustered = true;
        }
        key(Key2; Proceso)
        {
        }
        key(Key3; "Fecha Servicio")
        {
        }
        key(Key4; "Clave 1", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario)
        {
        }
        key(Key5; Proceso, usuario, Insertado, "Clave 6")
        {
        }
        key(Key6; Proceso, usuario, "Insertado 2")
        {
        }
        key(Key7; "Clave 1", "Clave 3", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario, "Insertado 2")
        {
        }
        key(Key8; "Clave 1", Proceso, "Asigna Lin")
        {
        }
        key(Key9; "Clave 3", Proceso, "Asigna Lin")
        {
        }
        key(Key10; Proceso, usuario, "Cantidad Pendiente", Insertado)
        {
        }
        key(Key11; "Clave 1", Linea)
        {
        }
        key(Key12; Proceso, usuario, Anular, Insertado)
        {
        }
        key(Key13; "Clave 1", Proceso, usuario, Insertado, "Tipo de producto", "Cod. grupo talla")
        {
        }
        key(Key14; "Clave 1", "Clave 3", Proceso, usuario, Insertado)
        {
        }
        key(Key15; "Clave 1", Linea, Proceso)
        {
        }
        key(Key16; "Clave 1", Proceso, "Asigna Lin", Cantidad)
        {
        }
        key(Key17; "Clave 3", Proceso, "Asigna Lin", Cantidad)
        {
        }
        key(Key18; "Clave 1", "Clave 2", "Clave 3", "Clave 4", "Clave 5", "Clave 6", "Clave 7", "Clave 8", Proceso, "Consignacion venta")
        {
        }
        key(Key19; "Clave 2", Proceso)
        {
        }
        key(Key20; "Clave 1", "Clave 2", "Clave 4", "Clave 5", "Clave 6", Proceso)
        {
        }
        key(Key21; "Clave 1", "Clave 2", Proceso)
        {
        }
        key(Key22; "Clave 1", "Clave 2", "Clave 3", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario, Insertado)
        {
        }
        key(Key23; Proceso, usuario)
        {
        }
        key(Key24; "Clave 1", Proceso, usuario, Anular, Insertado)
        {
        }
    }

    trigger OnDelete()
    begin

        RecTemp.RESET();
        RecTemp.SETRANGE(Proceso, 'RFIDLIN');
        //RecTemp.SETRANGE(usuario,USERID);
        RecTemp.SETRANGE("Clave 1", "Clave 1");
        RecTemp.SETRANGE("Clave 3", "Clave 3");
        RecTemp.DELETEALL();

        RecTemp.RESET();
        RecTemp.SETRANGE(Proceso, 'RFIDTALLAS');
        //RecTemp.SETRANGE(usuario,USERID);
        RecTemp.SETRANGE("Clave 1", "Clave 1");
        RecTemp.SETRANGE("Clave 3", "Clave 3");
        RecTemp.DELETEALL();

        RecTemp.RESET();
        RecTemp.SETRANGE(Proceso, 'RFIDT2');
        //RecTemp.SETRANGE(usuario,USERID);
        RecTemp.SETRANGE("Clave 1", "Clave 1");
        RecTemp.SETRANGE("Clave 3", "Clave 3");
        RecTemp.DELETEALL();

        //WMS EX-JFC 090919 Validar en el borrado de proposicion de venta de WMS que se borren los registros
        RecTemp.RESET();
        RecTemp.SETRANGE(Proceso, 'WMSLIN');
        //RecTemp.SETRANGE(usuario,USERID);
        RecTemp.SETRANGE("Clave 1", "Clave 1");
        RecTemp.SETRANGE("Clave 3", "Clave 3");
        RecTemp.DELETEALL();

        RecTemp.RESET();
        RecTemp.SETRANGE(Proceso, 'WMSTALLAS');
        //RecTemp.SETRANGE(usuario,USERID);
        RecTemp.SETRANGE("Clave 1", "Clave 1");
        RecTemp.SETRANGE("Clave 3", "Clave 3");
        RecTemp.DELETEALL();

        RecTemp.RESET();
        RecTemp.SETRANGE(Proceso, 'WMST2');
        //RecTemp.SETRANGE(usuario,USERID);
        RecTemp.SETRANGE("Clave 1", "Clave 1");
        RecTemp.SETRANGE("Clave 3", "Clave 3");
        RecTemp.DELETEALL();
        //WMS FIN EX-JFC 090919 Validar en el borrado de proposicion de venta de WMS que se borren los registros

        //+EX-SGG 091222
        RecTemp.RESET();
        RecTemp.SETRANGE(Proceso, 'WMSMATRIX');
        RecTemp.SETRANGE("Clave 1", "Clave 1");
        RecTemp.SETRANGE("Clave 3", "Clave 3");
        RecTemp.DELETEALL();
        RecTemp.SETRANGE(Proceso, 'WMSMATRIXC');
        RecTemp.SETRANGE("Clave 3");
        RecTemp.DELETEALL();
        //-EX-SGG 091222
    end;

    var
        RecTemp: Record TemporalPV;
        i: Integer;
        CabPedido: Record "Sales Header";
        RecTemp2: Record TemporalPV;

    /// <summary>
    /// AsignaLinMatrix.
    /// </summary>
    procedure AsignaLinMatrix()
    var
        lRecWMSLIN: Record TemporalPV;
        lRecWMSMATRIX: Record TemporalPV;
        lCantidadAsign: Decimal;
    begin
        //EX-SGG 251122
        IF Rec.Proceso <> 'WMSTALLAS' THEN
            EXIT;

        lRecWMSLIN.SETRANGE("Clave 1", Rec."Clave 1");
        lRecWMSLIN.SETRANGE("Clave 3", Rec."Clave 3");
        lRecWMSLIN.SETRANGE("Clave 4", Rec."Clave 4");
        lRecWMSLIN.SETRANGE("Clave 5", Rec."Clave 5");
        lRecWMSLIN.SETRANGE("Clave 6", Rec."Clave 6");
        lRecWMSLIN.SETRANGE(Proceso, 'WMSLIN');
        lRecWMSLIN.SETFILTER("Cantidad Asignada", '<>0');
        IF lRecWMSLIN.FINDSET() THEN BEGIN
            REPEAT
                lRecWMSLIN."Asigna Lin" := Rec."Asigna Lin";
                lRecWMSLIN.MODIFY();
                lCantidadAsign := lRecWMSLIN."Cantidad Asignada";
                IF NOT lRecWMSLIN."Asigna Lin" THEN
                    lCantidadAsign := lCantidadAsign * -1;
                lRecWMSMATRIX.RESET();
                lRecWMSMATRIX.COPYFILTERS(lRecWMSLIN);
                lRecWMSMATRIX.SETRANGE(Proceso, 'WMSMATRIX');
                lRecWMSMATRIX.SETRANGE("Cantidad Asignada");
                lRecWMSMATRIX.SETRANGE("Clave 2", lRecWMSLIN."Clave 2");
                lRecWMSMATRIX.SETRANGE("Tipo columna matrix", lRecWMSMATRIX."Tipo columna matrix"::Stock);
                IF lRecWMSMATRIX.FINDFIRST() THEN BEGIN
                    lRecWMSMATRIX.Cantidad -= lCantidadAsign;
                    IF lRecWMSMATRIX.Cantidad < 0 THEN
                        lRecWMSMATRIX.Cantidad := 0;
                    lRecWMSMATRIX.MODIFY();
                END;
                lRecWMSMATRIX.SETFILTER("Clave 1", '<>' + lRecWMSLIN."Clave 1");
                lRecWMSMATRIX.SETRANGE("Clave 3");
                IF lRecWMSMATRIX.FINDSET() THEN
                    REPEAT
                        lRecWMSMATRIX.Cantidad -= lCantidadAsign;
                        IF lRecWMSMATRIX.Cantidad < 0 THEN
                            lRecWMSMATRIX.Cantidad := 0;
                        lRecWMSMATRIX.MODIFY();
                    UNTIL lRecWMSMATRIX.NEXT() = 0;
                ActOtrasCantPdtesAsignMatrix(lRecWMSLIN."Clave 1", lRecWMSLIN."Clave 4", lRecWMSLIN."Clave 2",
                 lRecWMSLIN."Clave 5"); //EX-SGG 191222
            UNTIL lRecWMSLIN.NEXT() = 0;
        END;
    end;

    /// <summary>
    /// ObtenerOtrasCantAsignadas.
    /// </summary>
    /// <param name="pNoPedido">Code[20].</param>
    /// <param name="pNoProducto">Code[20].</param>
    /// <param name="pCodTalla">Code[10].</param>
    /// <param name="pCodColor">Code[10].</param>
    /// <returns>Return variable rCantAsign of type Decimal.</returns>
    procedure ObtenerOtrasCantAsignadas(pNoPedido: Code[20]; pNoProducto: Code[20]; pCodTalla: Code[10]; pCodColor: Code[10]) rCantAsign: Decimal
    var
        lRstWMSLIN: Record TemporalPV;
    begin
        //EX-SGG 191222
        lRstWMSLIN.SETFILTER("Clave 1", '<>' + pNoPedido);
        lRstWMSLIN.SETRANGE("Clave 2", pCodTalla);
        lRstWMSLIN.SETRANGE("Clave 4", pNoProducto);
        lRstWMSLIN.SETRANGE("Clave 5", pCodColor);
        lRstWMSLIN.SETRANGE(Proceso, 'WMSLIN');
        lRstWMSLIN.SETRANGE("Asigna Lin", TRUE);
        IF lRstWMSLIN.FINDSET() THEN
            REPEAT
                rCantAsign += lRstWMSLIN."Cantidad Asignada";
            UNTIL lRstWMSLIN.NEXT() = 0;
    end;

    /// <summary>
    /// ActOtrasCantPdtesAsignMatrix.
    /// </summary>
    /// <param name="pNoPedido">Code[20].</param>
    /// <param name="pNoProducto">Code[20].</param>
    /// <param name="pCodTalla">Code[10].</param>
    /// <param name="pCodColor">Code[10].</param>
    procedure ActOtrasCantPdtesAsignMatrix(pNoPedido: Code[20]; pNoProducto: Code[20]; pCodTalla: Code[10]; pCodColor: Code[10])
    var
        lRstWMSLIN: Record TemporalPV;
        lRstWMSMATRIX: Record TemporalPV;
        lRstWMSMATRIXPdte: Record TemporalPV;
        lRstWMSTALLAS: Record TemporalPV;
        lCantStock: Decimal;
    begin
        //EX-SGG 191222 SOLO MATRIX. EL VALIDATE DE "Asigna Lin" YA REALIZA ACTUALIZACION A DATOS ANTERIORES.
        lRstWMSLIN.SETFILTER("Clave 1", '<>' + pNoPedido);
        lRstWMSLIN.SETRANGE("Clave 2", pCodTalla);
        lRstWMSLIN.SETRANGE("Clave 4", pNoProducto);
        lRstWMSLIN.SETRANGE("Clave 5", pCodColor);
        lRstWMSLIN.SETRANGE(Proceso, 'WMSLIN');
        lRstWMSLIN.SETRANGE("Asigna Lin", FALSE);
        lRstWMSLIN.SETRANGE(Anular, FALSE);
        IF lRstWMSLIN.FINDSET() THEN BEGIN
            lRstWMSMATRIX.SETRANGE("Clave 2", lRstWMSLIN."Clave 2");
            lRstWMSMATRIX.SETRANGE("Clave 4", lRstWMSLIN."Clave 4");
            lRstWMSMATRIX.SETRANGE("Clave 5", lRstWMSLIN."Clave 5");
            lRstWMSMATRIX.SETRANGE(Proceso, 'WMSMATRIX');
            REPEAT
                lRstWMSMATRIX.SETRANGE("Clave 1", lRstWMSLIN."Clave 1");
                lRstWMSMATRIX.SETRANGE("Clave 3", lRstWMSLIN."Clave 3");
                lRstWMSMATRIX.SETRANGE("Tipo columna matrix", lRstWMSMATRIX."Tipo columna matrix"::Stock);
                lRstWMSTALLAS.COPYFILTERS(lRstWMSMATRIX);
                lRstWMSTALLAS.SETRANGE(Proceso, 'WMSTALLAS');
                lRstWMSTALLAS.SETRANGE("Clave 2");
                lRstWMSTALLAS.SETRANGE("Tipo columna matrix");
                lRstWMSTALLAS.SETRANGE("Asigna Lin", TRUE);
                IF lRstWMSMATRIX.FINDFIRST() AND (NOT lRstWMSTALLAS.FINDFIRST()) THEN BEGIN
                    lCantStock := lRstWMSMATRIX.Cantidad;
                    lRstWMSMATRIX.SETRANGE("Tipo columna matrix", lRstWMSMATRIX."Tipo columna matrix"::Asig);
                    lRstWMSMATRIX.FINDFIRST();
                    IF (lRstWMSMATRIX.Cantidad > lCantStock) THEN BEGIN
                        lRstWMSMATRIX.Cantidad := lCantStock;
                        lRstWMSMATRIX.MODIFY();
                    END;
                    IF NOT lRstWMSMATRIX."Modificado por usuario" THEN BEGIN
                        lRstWMSMATRIXPdte.COPYFILTERS(lRstWMSMATRIX);
                        lRstWMSMATRIXPdte.SETRANGE("Tipo columna matrix", lRstWMSMATRIXPdte."Tipo columna matrix"::"Pdte servir");
                        lRstWMSMATRIXPdte.FINDFIRST();
                        IF (lRstWMSMATRIX.Cantidad <> lRstWMSMATRIXPdte.Cantidad) AND (lRstWMSMATRIXPdte.Cantidad <= lCantStock) THEN BEGIN
                            lRstWMSMATRIX.Cantidad := lRstWMSMATRIXPdte.Cantidad;
                            lRstWMSMATRIX.MODIFY();
                        END;
                    END;
                    IF lRstWMSLIN."Cantidad Asignada" <> lRstWMSMATRIX.Cantidad THEN BEGIN
                        lRstWMSLIN."Cantidad Asignada" := lRstWMSMATRIX.Cantidad;
                        lRstWMSLIN.MODIFY();
                    END;
                END;
            UNTIL lRstWMSLIN.NEXT() = 0;
        END;
    end;
}
