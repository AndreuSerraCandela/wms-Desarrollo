Page 50437 "Modif Prop Venta Lineas"
{

    SourceTable = 50011;
    PageType = List;

    layout
    {
        // de filed 17 a field 49
        area(Content)
        {
            group(Cabecera)
            {
                Editable = false;

                Field("Nº Pedido"; Rec."Clave 1") { ApplicationArea = All; }
                group("Datos Cliente")
                {
                    field("Cliente "; Rec."Clave 3") { ApplicationArea = All; }
                    Field("Nombre Cliente"; Rec."Nombre Cliente") { ApplicationArea = All; }
                    field("Tipo Envio"; TipoEnvio) { ApplicationArea = All; }
                }
                field(Asigando; ImporteAsig) { ApplicationArea = All; }
                field(Riesgo; RiesgoDisp) { ApplicationArea = All; }
                field("Asiganado Cliente"; ImporteAsigCli) { ApplicationArea = All; }
                //field("Nº Piking";"Nº Piking"){ApplicationArea=all;}
                //field("Fecha Picking";Rec."Fecha picking"){ApplicationArea=All;}
                Field(Albaranes; Rec.Albaranes) { ApplicationArea = All; }
                field("Fecha Albaran"; Rec."Fecha Albaran") { ApplicationArea = All; }
            }
            repeater(Detalle)
            {
                Field("Asigna Lin"; Rec."Asigna Lin")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    BEGIN
                        IF COPYSTR(Rec."Clave 6", 4, 3) = 'LAD' THEN BEGIN
                            IF ((Rec."36 Asig" + Rec."37 Asig" + Rec."38 Asig" + Rec."39 Asig" + Rec."40 Asig" + Rec."41 Asig") MOD 12 <> 0) THEN
                                ERROR('La suma de la asignaci n no es correcta');
                            IF ((Rec."36 Asig" = 0) OR (Rec."37 Asig" = 0) OR (Rec."38 Asig" = 0) OR
                                (Rec."39 Asig" = 0) OR (Rec."40 Asig" = 0) OR (Rec."41 Asig" = 0)) THEN
                                ERROR('Existe preembalado sin valor informado');
                        END;

                        IF COPYSTR(Rec."Clave 6", 4, 3) = 'MEN' THEN BEGIN
                            IF ((Rec."40 Asig" + Rec."41 Asig" + Rec."42 Asig" + Rec."43 Asig" + Rec."44 Asig" + Rec."45 Asig") MOD 12 <> 0) THEN
                                ERROR('La suma de la asignaci n no es correcta');
                            IF ((Rec."40 Asig" = 0) OR (Rec."41 Asig" = 0) OR (Rec."42 Asig" = 0) OR
                                (Rec."43 Asig" = 0) OR (Rec."44 Asig" = 0) OR (Rec."45 Asig" = 0)) THEN
                                ERROR('Existe preembalado sin valor informado');
                        END;
                        Actualizar();
                    END;

                }
                field(Modelo; Rec."Clave 4") { Caption = 'Modelo'; ApplicationArea = All; Style = Strong; }
                field(Color; Rec."Clave 5") { Caption = 'Color'; ApplicationArea = All; Style = Strong; }
                field(Descripcion; Rec.Descripcion) { Caption = 'Descripcion'; ApplicationArea = All; Style = Strong; }
                field("Pte. Servir"; PteServir) { ApplicationArea = All; Style = Strong; }
                field("Cód. Preenbalado"; Rec."Clave 6") { Caption = 'Cód. Preembalado'; ApplicationArea = All; Style = Strong; }

                Field("17 Pte Servir"; Rec."17 Pte Servir")
                {

                    ApplicationArea = All;
                }

                Field("17 Stock"; Rec."17 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }

                Field("17 Asig"; Rec."17 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("18 Pte Servir"; Rec."18 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("18 Stock"; Rec."18 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("18 Asig"; Rec."18 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("19 Pte Servir"; Rec."19 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("19 Stock"; Rec."19 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("19 Asig"; Rec."19 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("20 Pte Servir"; Rec."20 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("20 Stock"; Rec."20 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("20 Asig"; Rec."20 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("21 Pte Servir"; Rec."21 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("21 Stock"; Rec."21 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("21 Asig"; Rec."21 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("22 Pte Servir"; Rec."22 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("22 Stock"; Rec."22 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("22 Asig"; Rec."22 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("23 Pte Servir"; Rec."23 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("23 Stock"; Rec."23 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("23 Asig"; Rec."23 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("24 Pte Servir"; Rec."24 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("24 Stock"; Rec."24 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("24 Asig"; Rec."24 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("25 Pte Servir"; Rec."25 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("25 Stock"; Rec."25 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("25 Asig"; Rec."25 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("26 Pte Servir"; Rec."26 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("26 Stock"; Rec."26 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("26 Asig"; Rec."26 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("27 Pte Servir"; Rec."27 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("27 Stock"; Rec."27 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("27 Asig"; Rec."27 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("28 Pte Servir"; Rec."28 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("28 Stock"; Rec."28 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("28 Asig"; Rec."28 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("29 Pte Servir"; Rec."29 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("29 Stock"; Rec."29 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("29 Asig"; Rec."29 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("30 Pte Servir"; Rec."30 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("30 Stock"; Rec."30 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("30 Asig"; Rec."30 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("31 Pte Servir"; Rec."31 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("31 Stock"; Rec."31 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("31 Asig"; Rec."31 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("32 Pte Servir"; Rec."32 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("32 Stock"; Rec."32 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("32 Asig"; Rec."32 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("33 Pte Servir"; Rec."33 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("33 Stock"; Rec."33 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("33 Asig"; Rec."33 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("34 Pte Servir"; Rec."34 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("34 Stock"; Rec."34 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("34 Asig"; Rec."34 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("35 Pte Servir"; Rec."35 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("35 Stock"; Rec."35 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("35 Asig"; Rec."35 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("36 Pte Servir"; Rec."36 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("36 Stock"; Rec."36 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("36 Asig"; Rec."36 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("37 Pte Servir"; Rec."37 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("37 Stock"; Rec."37 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("37 Asig"; Rec."37 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                }
                field("38 Pte Servir"; Rec."38 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("38 Stock"; Rec."38 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }

                Field("38 Asig"; Rec."38 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;


                    trigger OnValidate()
                    BEGIN

                        IF Rec."Clave 6" <> '' THEN
                            ERROR('No se puede modificar preembalado');
                    END;
                }
                field("39 Pte Servir"; Rec."39 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("39 Stock"; Rec."39 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("39 Asig"; Rec."39 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    trigger OnValidate()
                    BEGIN

                        IF Rec."Clave 6" <> '' THEN
                            ERROR('No se puede modificar preembalado');
                    END;
                }
                field("40 Pte Servir"; Rec."40 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("40 Stock"; Rec."40 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("40 Asig"; Rec."40 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    trigger OnValidate()
                    BEGIN

                        IF Rec."Clave 6" <> '' THEN
                            ERROR('No se puede modificar preembalado');
                    END;
                }
                field("41 Pte Servir"; Rec."41 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("41 Stock"; Rec."41 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("41 Asig"; Rec."41 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    trigger OnValidate()
                    BEGIN

                        IF Rec."Clave 6" <> '' THEN
                            ERROR('No se puede modificar preembalado');
                    END;
                }
                field("42 Pte Servir"; Rec."42 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("42 Stock"; Rec."42 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("42 Asig"; Rec."42 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    trigger OnValidate()
                    BEGIN

                        IF Rec."Clave 6" <> '' THEN
                            ERROR('No se puede modificar preembalado');
                    END;
                }
                field("43 Pte Servir"; Rec."43 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("43 Stock"; Rec."43 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("43 Asig"; Rec."43 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    trigger OnValidate()
                    BEGIN

                        IF Rec."Clave 6" <> '' THEN
                            ERROR('No se puede modificar preembalado');
                    END;
                }
                field("44 Pte Servir"; Rec."44 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("44 Stock"; Rec."44 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("44 Asig"; Rec."44 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    trigger OnValidate()
                    BEGIN

                        IF Rec."Clave 6" <> '' THEN
                            ERROR('No se puede modificar preembalado');
                    END;
                }
                field("45 Pte Servir"; Rec."45 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("45 Stock"; Rec."45 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("45 Asig"; Rec."45 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;
                    trigger OnValidate()
                    BEGIN

                        IF Rec."Clave 6" <> '' THEN
                            ERROR('No se puede modificar preembalado');
                    END;
                }
                field("46 Pte Servir"; Rec."46 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("46 Stock"; Rec."46 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("46 Asig"; Rec."46 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;

                }
                field("47 Pte Servir"; Rec."47 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("47 Stock"; Rec."47 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("47 Asig"; Rec."47 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;

                }
                field("48 Pte Servir"; Rec."48 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("48 Stock"; Rec."48 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("48 Asig"; Rec."48 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;

                }
                field("49 Pte Servir"; Rec."49 Pte Servir")
                {
                    ApplicationArea = All;
                }
                field("49 Stock"; Rec."49 Stock")
                {
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("49 Asig"; Rec."49 Asig")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;

                }
            }


            part("Proposicion Tallas"; "Tallas Proposicion")
            {
                ApplicationArea = All;
                SubPageView = WHERE(Proceso = FILTER('RFIDT2|WMST2'),
                                   "Clave 2" = FILTER(<> 'FECHA&<>SPRECIO&<>SSERVICIO'));
                SubPageLink = "Clave 1" = FIELD("Clave 1"),
                            "Clave 4" = FIELD("Clave 4"),
                            "Clave 5" = FIELD("Clave 5"),
                            "Clave 6" = FIELD("Clave 6");
            }
            part("FechaS Tallas"; "Tallas Proposicion Fecha")
            {
                ApplicationArea = All;
                SubPageView = WHERE(Proceso = FILTER('RFIDT2|WMST2'),
                                   "Clave 2" = CONST('FECHA'));
                SubPageLink = "Clave 1" = FIELD("Clave 1"),
                            "Clave 4" = FIELD("Clave 4"),
                            "Clave 5" = FIELD("Clave 5"),
                            "Clave 6" = FIELD("Clave 6");
            }
            part("Series Tallas"; "Tallas Proposicion SeriePrecio")
            {
                ApplicationArea = All;
                SubPageView = WHERE(Proceso = FILTER('RFIDT2|WMST2'),
                                   "Clave 2" = CONST('SPRECIO'));
                SubPageLink = "Clave 1" = FIELD("Clave 1"),
                            "Clave 4" = FIELD("Clave 4"),
                            "Clave 5" = FIELD("Clave 5"),
                            "Clave 6" = FIELD("Clave 6");
            }



        }
    }
    actions
    {
        area(Processing)
        {
            action("Actualizar Asignación")
            {
                ApplicationArea = all;
                Image = UpdateShipment;
                trigger OnAction()
                BEGIN
                    RecTempT.RESET;
                    RecTempT.SETRANGE("Clave 1", Rec."Clave 1");
                    RecTempT.SETRANGE(Proceso, 'RFIDTALLAS');
                    RecTempT.SETRANGE(usuario, USERID);
                    IF RecTempT.FINDFIRST THEN
                        REPEAT
                            IF RecTempT."17 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("17 Asig", RecTempT."17 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."18 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("18 Asig", RecTempT."18 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."19 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("19 Asig", RecTempT."19 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."20 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("20 Asig", RecTempT."20 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."21 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("21 Asig", RecTempT."21 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."22 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("22 Asig", RecTempT."22 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."23 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("23 Asig", RecTempT."23 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."24 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("24 Asig", RecTempT."24 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."25 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("25 Asig", RecTempT."25 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."26 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("26 Asig", RecTempT."26 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."27 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("27 Asig", RecTempT."27 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."28 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("28 Asig", RecTempT."28 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."29 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("29 Asig", RecTempT."29 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."30 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("30 Asig", RecTempT."30 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."31 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("31 Asig", RecTempT."31 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."32 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("32 Asig", RecTempT."32 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."33 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("33 Asig", RecTempT."33 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."34 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("34 Asig", RecTempT."34 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."35 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("35 Asig", RecTempT."35 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."36 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("36 Asig", RecTempT."36 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."37 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("37 Asig", RecTempT."37 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."38 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("38 Asig", RecTempT."38 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."39 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("39 Asig", RecTempT."39 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."40 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("40 Asig", RecTempT."40 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."41 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("41 Asig", RecTempT."41 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."42 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("42 Asig", RecTempT."42 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."43 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("43 Asig", RecTempT."43 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."44 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("44 Asig", RecTempT."44 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."45 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("45 Asig", RecTempT."45 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."46 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("46 Asig", RecTempT."46 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."47 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("47 Asig", RecTempT."47 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."48 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("48 Asig", RecTempT."48 Pte Servir");
                                RecTempT.MODIFY;
                            END;
                            IF RecTempT."49 Pte Servir" <> 0 THEN BEGIN
                                RecTempT.VALIDATE("49 Asig", RecTempT."49 Pte Servir");
                                RecTempT.MODIFY;
                            END;

                        UNTIL RecTempT.NEXT = 0;
                END;
            }
            action("Asignación")
            {
                ApplicationArea = All;
                Image = Apply;
                trigger OnAction()
                BEGIN
                    RecTemp.RESET;
                    //RecTemp.SETCURRENTKEY("Clave 1",Proceso);
                    RecTemp.SETRANGE("Clave 1", Rec."Clave 1");
                    //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                    //RecTemp.SETRANGE(Proceso,'RFIDTALLAS');
                    RecTemp.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
                    //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                    IF RecTemp.FINDFIRST THEN
                        //RecTemp.MODIFYALL("Asigna Lin",TRUE,TRUE);
                        REPEAT
                            //IF NOT RecTemp."Asigna Lin" THEN BEGIN
                            RecTemp.VALIDATE("Asigna Lin", TRUE);
                            RecTemp.MODIFY;
                        //END;
                        UNTIL RecTemp.NEXT = 0;

                    Actualizar;
                END;
            }
            action("No Asignación")
            {
                ApplicationArea = All;
                Image = UnApply;
                trigger OnAction()
                BEGIN
                    RecTemp.RESET;
                    //RecTemp.SETCURRENTKEY("Clave 1",Proceso);
                    RecTemp.SETRANGE("Clave 1", Rec."Clave 1");
                    //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                    //RecTemp.SETRANGE(Proceso,'RFIDTALLAS');
                    RecTemp.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
                    //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

                    IF RecTemp.FINDFIRST THEN
                        //RecTemp.MODIFYALL("Asigna Lin",FALSE);
                        REPEAT
                            //IF RecTemp."Asigna Lin" THEN BEGIN
                            RecTemp.VALIDATE("Asigna Lin", FALSE);
                            RecTemp.MODIFY;
                        //END;
                        UNTIL RecTemp.NEXT = 0;

                    Actualizar;
                END;
            }

            action("Cálculo Importes")
            {
                ApplicationArea = All;
                Image = Calculate;

                trigger OnAction()
                begin
                    Actualizar;
                end;
            }

            action(Actualiza)
            {
                ApplicationArea = All;
                Image = RefreshLines;
                trigger OnAction()
                BEGIN

                    RecTempImporte.RESET;
                    RecTempImporte.SETCURRENTKEY("Clave 1", Proceso);
                    RecTempImporte.SETRANGE("Clave 1", Rec."Clave 1");
                    //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                    //RecTempImporte.SETRANGE(Proceso,'RFIDTALLAS');
                    RecTempImporte.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
                    //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                    IF RecTempImporte.FINDFIRST THEN BEGIN

                        RecTempImpLin.RESET;
                        RecTempImpLin.SETCURRENTKEY("Clave 1", "Clave 2", Proceso);
                        RecTempImpLin.SETRANGE("Clave 1", RecTempImporte."Clave 1");
                        RecTempImpLin.SETRANGE("Clave 2", '3ASIGNADO');
                        //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                        //RecTempImpLin.SETRANGE(Proceso,'RFIDT2');
                        RecTempImpLin.SETFILTER(Proceso, 'RFIDT2|WMST2');
                        //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

                        IF RecTempImpLin.FINDFIRST THEN BEGIN
                            RecTemp.RESET;
                            RecTemp.SETCURRENTKEY("Clave 1", "Clave 3", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario);
                            RecTemp.SETRANGE("Clave 1", RecTempImpLin."Clave 1");
                            RecTemp.SETRANGE("Clave 3", RecTempImpLin."Clave 3");
                            RecTemp.SETRANGE("Clave 4", RecTempImpLin."Clave 4");
                            RecTemp.SETRANGE("Clave 5", RecTempImpLin."Clave 5");
                            RecTemp.SETRANGE("Clave 6", RecTempImpLin."Clave 6");
                            //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                            //RecTemp.SETRANGE(Proceso,'RFIDTALLAS');
                            RecTemp.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
                            //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

                            RecTemp.SETRANGE(usuario, USERID);
                            IF RecTemp.FINDFIRST THEN BEGIN
                                RecTempImpLin."17 AsigU" := RecTemp."17 Asig";
                                RecTempImpLin."18 AsigU" := RecTemp."18 Asig";
                                RecTempImpLin."19 AsigU" := RecTemp."19 Asig";
                                RecTempImpLin."20 AsigU" := RecTemp."20 Asig";
                                RecTempImpLin."21 AsigU" := RecTemp."21 Asig";
                                RecTempImpLin."22 AsigU" := RecTemp."22 Asig";
                                RecTempImpLin."23 AsigU" := RecTemp."23 Asig";
                                RecTempImpLin."24 AsigU" := RecTemp."24 Asig";
                                RecTempImpLin."25 AsigU" := RecTemp."25 Asig";
                                RecTempImpLin."26 AsigU" := RecTemp."26 Asig";
                                RecTempImpLin."27 AsigU" := RecTemp."27 Asig";
                                RecTempImpLin."28 AsigU" := RecTemp."28 Asig";
                                RecTempImpLin."29 AsigU" := RecTemp."29 Asig";
                                RecTempImpLin."30 AsigU" := RecTemp."30 Asig";
                                RecTempImpLin."31 AsigU" := RecTemp."31 Asig";
                                RecTempImpLin."32 AsigU" := RecTemp."32 Asig";
                                RecTempImpLin."33 AsigU" := RecTemp."33 Asig";
                                RecTempImpLin."34 AsigU" := RecTemp."34 Asig";
                                RecTempImpLin."35 AsigU" := RecTemp."35 Asig";
                                RecTempImpLin."36 AsigU" := RecTemp."36 Asig";
                                RecTempImpLin."37 AsigU" := RecTemp."37 Asig";
                                RecTempImpLin."38 AsigU" := RecTemp."38 Asig";
                                RecTempImpLin."39 AsigU" := RecTemp."39 Asig";
                                RecTempImpLin."40 AsigU" := RecTemp."40 Asig";
                                RecTempImpLin."41 AsigU" := RecTemp."41 Asig";
                                RecTempImpLin."42 AsigU" := RecTemp."42 Asig";
                                RecTempImpLin."43 AsigU" := RecTemp."43 Asig";
                                RecTempImpLin."44 AsigU" := RecTemp."44 Asig";
                                RecTempImpLin."45 AsigU" := RecTemp."45 Asig";
                                RecTempImpLin."46 AsigU" := RecTemp."46 Asig";
                                RecTempImpLin."47 AsigU" := RecTemp."47 Asig";
                                RecTempImpLin."48 AsigU" := RecTemp."48 Asig";
                                RecTempImpLin."49 AsigU" := RecTemp."49 Asig";
                                RecTempImpLin.MODIFY;
                            END;
                        END;
                        RecTempImpLin.RESET;
                        RecTempImpLin.SETCURRENTKEY("Clave 1", "Clave 2", Proceso);
                        RecTempImpLin.SETRANGE("Clave 1", RecTempImporte."Clave 1");
                        RecTempImpLin.SETRANGE("Clave 2", 'STOCK');
                        //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                        //RecTempImpLin.SETRANGE(Proceso,'RFIDT2');
                        RecTempImpLin.SETFILTER(Proceso, 'RFIDT2|WMST2');
                        //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

                        IF RecTempImpLin.FINDFIRST THEN BEGIN
                            RecTemp.RESET;
                            RecTemp.SETCURRENTKEY("Clave 1", "Clave 3", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario);
                            RecTemp.SETRANGE("Clave 1", RecTempImpLin."Clave 1");
                            RecTemp.SETRANGE("Clave 3", RecTempImpLin."Clave 3");
                            RecTemp.SETRANGE("Clave 4", RecTempImpLin."Clave 4");
                            RecTemp.SETRANGE("Clave 5", RecTempImpLin."Clave 5");
                            RecTemp.SETRANGE("Clave 6", RecTempImpLin."Clave 6");
                            //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                            //RecTemp.SETRANGE(Proceso,'RFIDTALLAS');
                            RecTemp.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
                            //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

                            RecTemp.SETRANGE(usuario, USERID);
                            IF RecTemp.FINDFIRST THEN BEGIN
                                RecTempImpLin."17 AsigU" := RecTemp."17 Stock";
                                RecTempImpLin."18 AsigU" := RecTemp."18 Stock";
                                RecTempImpLin."19 AsigU" := RecTemp."19 Stock";
                                RecTempImpLin."20 AsigU" := RecTemp."20 Stock";
                                RecTempImpLin."21 AsigU" := RecTemp."21 Stock";
                                RecTempImpLin."22 AsigU" := RecTemp."22 Stock";
                                RecTempImpLin."23 AsigU" := RecTemp."23 Stock";
                                RecTempImpLin."24 AsigU" := RecTemp."24 Stock";
                                RecTempImpLin."25 AsigU" := RecTemp."25 Stock";
                                RecTempImpLin."26 AsigU" := RecTemp."26 Stock";
                                RecTempImpLin."27 AsigU" := RecTemp."27 Stock";
                                RecTempImpLin."28 AsigU" := RecTemp."28 Stock";
                                RecTempImpLin."29 AsigU" := RecTemp."29 Stock";
                                RecTempImpLin."30 AsigU" := RecTemp."30 Stock";
                                RecTempImpLin."31 AsigU" := RecTemp."31 Stock";
                                RecTempImpLin."32 AsigU" := RecTemp."32 Stock";
                                RecTempImpLin."33 AsigU" := RecTemp."33 Stock";
                                RecTempImpLin."34 AsigU" := RecTemp."34 Stock";
                                RecTempImpLin."35 AsigU" := RecTemp."35 Stock";
                                RecTempImpLin."36 AsigU" := RecTemp."36 Stock";
                                RecTempImpLin."37 AsigU" := RecTemp."37 Stock";
                                RecTempImpLin."38 AsigU" := RecTemp."38 Stock";
                                RecTempImpLin."39 AsigU" := RecTemp."39 Stock";
                                RecTempImpLin."40 AsigU" := RecTemp."40 Stock";
                                RecTempImpLin."41 AsigU" := RecTemp."41 Stock";
                                RecTempImpLin."42 AsigU" := RecTemp."42 Stock";
                                RecTempImpLin."43 AsigU" := RecTemp."43 Stock";
                                RecTempImpLin."44 AsigU" := RecTemp."44 Stock";
                                RecTempImpLin."45 AsigU" := RecTemp."45 Stock";
                                RecTempImpLin."46 AsigU" := RecTemp."46 Stock";
                                RecTempImpLin."47 AsigU" := RecTemp."47 Stock";
                                RecTempImpLin."48 AsigU" := RecTemp."48 Stock";
                                RecTempImpLin."49 AsigU" := RecTemp."49 Stock";
                                RecTempImpLin.MODIFY;
                            END;
                        END;
                    END;
                END;
            }
        }


    }

    VAR
        RecFormaPago: Record "Payment Method";
        OpenRemainingAmtLCY: ARRAY[5] OF Decimal;
        FactPteImpag: decimal;
        CalcularRiesgoCliSinAlbaranes: Boolean;
        ImpEnviosLanzados: Decimal;
        ImpEnviosSinLanzar: Decimal;
        ImpPedPteConsig: Decimal;
        ImpAnulConsig: Decimal;
        ImpPedTransferPdtServirConsig: Decimal;
        ImpEnviosLanzadosConsig: Decimal;
        ImpEnviosSinLanzarConsig: Decimal;
        ImpPedTransitoConsig: Decimal;
        ImpStockConsig: Decimal;
        ImpFactPteConsig: Decimal;
        ImpFactPteImpagConsig: Decimal;
        ImpEfecPendConsig: Decimal;
        ImpEfecPendRemesasConsig: Decimal;
        ImpEfectPendRemesasRegConsig: Decimal;
        ImpagRemRechConsig: Decimal;
        ImpagadosConsig: Decimal;
        impAnul: Decimal;
        ImpPedPte: Decimal;
        ImpAlb: Decimal;
        lRecConsignmentCondition: Record 50051;
        RecTempT: Record 50011;
        RiesgoDisp: Decimal;
        CUFunc: Codeunit 50000;
        RecTemp: Record 50011;
        PedidoRec: Record 36;
        TipoEnvio: Option Parcial,Completo;
        ImporteAsig: Decimal;
        RecTempImporte: Record 50011;
        RecTempImpLin: Record 50011;
        ImporteAsigCli: Decimal;
        PteServir: Decimal;
        ImpagRemRech: Decimal;
        RecPteServir: Record 50011;
        TemporalPV: Record 50011;

    trigger OnOpenPage()
    BEGIN
        //EX-JFC 071221 Calculo de RiesgoDisp en funcion de si el documento es de venta en firme o de venta en consignacion
        TemporalPV.RESET;
        TemporalPV.SETCURRENTKEY("Clave 1", Proceso);
        TemporalPV.SETRANGE("Clave 1", Rec."Clave 1");
        TemporalPV.SETFILTER(Proceso, 'WMSCAB|RFIDCAB');
        IF TemporalPV.FINDFIRST THEN BEGIN
            IF TemporalPV."Consignacion venta" = FALSE THEN
                RiesgoDisp := CUFunc.RiesgoCliente(Rec."Clave 3");

            IF TemporalPV."Consignacion venta" = TRUE THEN
                RiesgoDisp := GetValueAvalDisp(Rec."Clave 3");
        END;
        //EX-JFC 071221 Calculo de RiesgoDisp en funcion de si el documento es de venta en firme o de venta en consignacion

        ImporteAsig := 0;
        RecTempImporte.RESET;
        RecTempImporte.SETCURRENTKEY("Clave 1", Proceso);
        RecTempImporte.SETRANGE("Clave 1", Rec."Clave 1");
        //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
        //RecTempImporte.SETRANGE(Proceso,'RFIDTALLAS');
        RecTempImporte.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
        //WMS FIN  EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
        IF RecTempImporte.FINDFIRST THEN BEGIN
            RecTempImpLin.RESET;
            RecTempImpLin.SETCURRENTKEY("Clave 1", Proceso, "Asigna Lin", Cantidad);
            RecTempImpLin.SETRANGE("Clave 1", RecTempImporte."Clave 1");
            //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
            //RecTempImpLin.SETRANGE(Proceso,'RFIDLIN');
            RecTempImpLin.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
            //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
            RecTempImpLin.SETRANGE("Asigna Lin", TRUE);
            RecTempImpLin.SETFILTER(Cantidad, '<>0');
            IF RecTempImpLin.FINDFIRST THEN
                REPEAT
                    IF RecTempImpLin.Cantidad <> 0 THEN
                        ImporteAsig += RecTempImpLin."Importe Pedido" *
                        (RecTempImpLin."Cantidad Asignada" / RecTempImpLin.Cantidad);
                UNTIL RecTempImpLin.NEXT = 0;
        END;

        ImporteAsigCli := 0;
        RecTempImporte.RESET;
        RecTempImporte.SETCURRENTKEY("Clave 3", Proceso);
        //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
        //RecTempImporte.SETRANGE(Proceso,'RFIDTALLAS');
        RecTempImpLin.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
        //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

        RecTempImporte.SETRANGE("Clave 3", Rec."Clave 3");
        IF RecTempImporte.FINDFIRST THEN BEGIN

            RecTempImpLin.RESET;
            RecTempImpLin.SETCURRENTKEY("Clave 3", Proceso, "Asigna Lin", Cantidad);
            RecTempImpLin.SETRANGE("Clave 3", RecTempImporte."Clave 3");
            //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
            //RecTempImpLin.SETRANGE(Proceso,'RFIDLIN');
            RecTempImpLin.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
            //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
            RecTempImpLin.SETRANGE("Asigna Lin", TRUE);
            RecTempImpLin.SETFILTER(Cantidad, '<>0');
            IF RecTempImpLin.FINDFIRST THEN
                REPEAT
                    IF RecTempImpLin.Cantidad <> 0 THEN
                        ImporteAsigCli += RecTempImpLin."Importe Pedido" *
                        (RecTempImpLin."Cantidad Asignada" / RecTempImpLin.Cantidad);
                UNTIL RecTempImpLin.NEXT = 0;
        END;
    END;

    trigger OnAfterGetRecord()
    BEGIN
        //RiesgoDisp := CUFunc.RiesgoCliente("Clave 3");

        IF PedidoRec.GET(PedidoRec."Document Type"::Order, Rec."Clave 1") THEN
            IF PedidoRec."Shipping Advice" = PedidoRec."Shipping Advice"::Partial THEN
                TipoEnvio := TipoEnvio::Parcial
            ELSE
                TipoEnvio := TipoEnvio::Completo;

        PteServir := 0;
        RecPteServir.RESET;
        RecPteServir.SETCURRENTKEY("Clave 1", "Clave 2", "Clave 3", "Clave 4", "Clave 5", "Clave 6", "Clave 7", "Clave 8", Proceso);
        RecPteServir.SETRANGE("Clave 1", Rec."Clave 1");
        RecPteServir.SETRANGE("Clave 2", Rec."Clave 2");
        RecPteServir.SETRANGE("Clave 3", Rec."Clave 3");
        RecPteServir.SETRANGE("Clave 4", Rec."Clave 4");
        RecPteServir.SETRANGE("Clave 5", Rec."Clave 5");
        RecPteServir.SETRANGE("Clave 6", Rec."Clave 6");
        RecPteServir.SETRANGE("Clave 7", Rec."Clave 7");
        RecPteServir.SETRANGE("Clave 8", Rec."Clave 8");
        //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
        //RecPteServir.SETRANGE(Proceso,'RFIDTALLAS');
        RecPteServir.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
        //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

        IF RecPteServir.FINDFIRST THEN
            PteServir := RecPteServir."17 Pte Servir" + RecPteServir."18 Pte Servir" + RecPteServir."19 Pte Servir" +
                        RecPteServir."20 Pte Servir" + RecPteServir."21 Pte Servir" + RecPteServir."22 Pte Servir" +
                        RecPteServir."23 Pte Servir" + RecPteServir."24 Pte Servir" + RecPteServir."25 Pte Servir" +
                        RecPteServir."26 Pte Servir" + RecPteServir."27 Pte Servir" + RecPteServir."28 Pte Servir" +
                        RecPteServir."29 Pte Servir" + RecPteServir."30 Pte Servir" + RecPteServir."31 Pte Servir" +
                        RecPteServir."32 Pte Servir" + RecPteServir."33 Pte Servir" + RecPteServir."34 Pte Servir" +
                        RecPteServir."35 Pte Servir" + RecPteServir."36 Pte Servir" + RecPteServir."37 Pte Servir" +
                        RecPteServir."38 Pte Servir" + RecPteServir."39 Pte Servir" + RecPteServir."40 Pte Servir" +
                        RecPteServir."41 Pte Servir" + RecPteServir."42 Pte Servir" + RecPteServir."43 Pte Servir" +
                        RecPteServir."44 Pte Servir" + RecPteServir."45 Pte Servir" + RecPteServir."46 Pte Servir" +
                        RecPteServir."47 Pte Servir" + RecPteServir."48 Pte Servir" + RecPteServir."49 Pte Servir";


        //SF-RAF: 06/06/2014
        Rec.CALCFIELDS(Albaranes, "Fecha Albaran");
        //SF-RAF: FIN
    END;

    PROCEDURE Actualizar();
    BEGIN
        ImporteAsig := 0;
        RecTempImporte.RESET;
        RecTempImporte.SETCURRENTKEY("Clave 1", Proceso);
        RecTempImporte.SETRANGE("Clave 1", Rec."Clave 1");
        //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
        //RecTempImporte.SETRANGE(Proceso,'RFIDTALLAS');
        RecTempImporte.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
        //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
        IF RecTempImporte.FINDFIRST THEN BEGIN
            RecTempImpLin.RESET;
            RecTempImpLin.SETCURRENTKEY("Clave 1", Proceso, "Asigna Lin", Cantidad);
            RecTempImpLin.SETRANGE("Clave 1", RecTempImporte."Clave 1");
            //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
            //RecTempImpLin.SETRANGE(Proceso,'RFIDLIN');
            RecTempImpLin.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
            //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

            RecTempImpLin.SETRANGE("Asigna Lin", TRUE);
            RecTempImpLin.SETFILTER(Cantidad, '<>0');
            IF RecTempImpLin.FINDFIRST THEN
                REPEAT
                    IF RecTempImpLin.Cantidad <> 0 THEN
                        ImporteAsig += RecTempImpLin."Importe Pedido" *
                          (RecTempImpLin."Cantidad Asignada" / RecTempImpLin.Cantidad);
                UNTIL RecTempImpLin.NEXT = 0;
        END;


        ImporteAsigCli := 0;
        RecTempImporte.RESET;
        RecTempImporte.SETCURRENTKEY("Clave 3", Proceso);
        RecTempImporte.SETRANGE("Clave 3", Rec."Clave 3");
        //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
        //RecTempImporte.SETRANGE(Proceso,'RFIDTALLAS');
        RecTempImporte.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
        //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

        IF RecTempImporte.FINDFIRST THEN BEGIN

            RecTempImpLin.RESET;
            RecTempImpLin.SETCURRENTKEY("Clave 3", Proceso, "Asigna Lin", Cantidad);
            RecTempImpLin.SETRANGE("Clave 3", RecTempImporte."Clave 3");
            //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
            //RecTempImpLin.SETRANGE(Proceso,'RFIDLIN');
            RecTempImpLin.SETFILTER(Proceso, 'RFIDLIN|WMSLIN');
            //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

            RecTempImpLin.SETRANGE("Asigna Lin", TRUE);
            RecTempImpLin.SETFILTER(Cantidad, '<>0');
            IF RecTempImpLin.FINDFIRST THEN
                REPEAT
                    IF RecTempImpLin.Cantidad <> 0 THEN
                        ImporteAsigCli += RecTempImpLin."Importe Pedido" *
                          (RecTempImpLin."Cantidad Asignada" / RecTempImpLin.Cantidad);
                UNTIL RecTempImpLin.NEXT = 0;
        END;

        RecTempImporte.RESET;
        RecTempImporte.SETCURRENTKEY("Clave 1", Proceso);
        RecTempImporte.SETRANGE("Clave 1", Rec."Clave 1");
        //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
        //RecTempImporte.SETRANGE(Proceso,'RFIDTALLAS');
        RecTempImporte.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
        //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

        IF RecTempImporte.FINDFIRST THEN
            REPEAT
                RecTempImpLin.RESET;
                RecTempImpLin.SETCURRENTKEY("Clave 1", "Clave 2", "Clave 4", "Clave 5", "Clave 6", Proceso);
                RecTempImpLin.SETRANGE("Clave 1", RecTempImporte."Clave 1");
                RecTempImpLin.SETRANGE("Clave 2", '3ASIGNADO');
                RecTempImpLin.SETRANGE("Clave 4", RecTempImporte."Clave 4");
                RecTempImpLin.SETRANGE("Clave 5", RecTempImporte."Clave 5");
                RecTempImpLin.SETRANGE("Clave 6", RecTempImporte."Clave 6");
                //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                //RecTempImpLin.SETRANGE(Proceso,'RFIDT2');
                RecTempImpLin.SETFILTER(Proceso, 'RFIDT2|WMST2');
                //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

                IF RecTempImpLin.FINDFIRST THEN BEGIN
                    RecTemp.RESET;
                    RecTemp.SETCURRENTKEY("Clave 1", "Clave 3", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario);
                    RecTemp.SETRANGE("Clave 1", RecTempImpLin."Clave 1");
                    RecTemp.SETRANGE("Clave 3", RecTempImpLin."Clave 3");
                    RecTemp.SETRANGE("Clave 4", RecTempImpLin."Clave 4");
                    RecTemp.SETRANGE("Clave 5", RecTempImpLin."Clave 5");
                    RecTemp.SETRANGE("Clave 6", RecTempImpLin."Clave 6");
                    //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                    //RecTemp.SETRANGE(Proceso,'RFIDTALLAS');
                    RecTemp.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
                    //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                    RecTemp.SETRANGE(usuario, USERID);
                    IF RecTemp.FINDFIRST THEN BEGIN
                        RecTempImpLin."17 AsigU" := RecTemp."17 Asig";
                        RecTempImpLin."18 AsigU" := RecTemp."18 Asig";
                        RecTempImpLin."19 AsigU" := RecTemp."19 Asig";
                        RecTempImpLin."20 AsigU" := RecTemp."20 Asig";
                        RecTempImpLin."21 AsigU" := RecTemp."21 Asig";
                        RecTempImpLin."22 AsigU" := RecTemp."22 Asig";
                        RecTempImpLin."23 AsigU" := RecTemp."23 Asig";
                        RecTempImpLin."24 AsigU" := RecTemp."24 Asig";
                        RecTempImpLin."25 AsigU" := RecTemp."25 Asig";
                        RecTempImpLin."26 AsigU" := RecTemp."26 Asig";
                        RecTempImpLin."27 AsigU" := RecTemp."27 Asig";
                        RecTempImpLin."28 AsigU" := RecTemp."28 Asig";
                        RecTempImpLin."29 AsigU" := RecTemp."29 Asig";
                        RecTempImpLin."30 AsigU" := RecTemp."30 Asig";
                        RecTempImpLin."31 AsigU" := RecTemp."31 Asig";
                        RecTempImpLin."32 AsigU" := RecTemp."32 Asig";
                        RecTempImpLin."33 AsigU" := RecTemp."33 Asig";
                        RecTempImpLin."34 AsigU" := RecTemp."34 Asig";
                        RecTempImpLin."35 AsigU" := RecTemp."35 Asig";
                        RecTempImpLin."36 AsigU" := RecTemp."36 Asig";
                        RecTempImpLin."37 AsigU" := RecTemp."37 Asig";
                        RecTempImpLin."38 AsigU" := RecTemp."38 Asig";
                        RecTempImpLin."39 AsigU" := RecTemp."39 Asig";
                        RecTempImpLin."40 AsigU" := RecTemp."40 Asig";
                        RecTempImpLin."41 AsigU" := RecTemp."41 Asig";
                        RecTempImpLin."42 AsigU" := RecTemp."42 Asig";
                        RecTempImpLin."43 AsigU" := RecTemp."43 Asig";
                        RecTempImpLin."44 AsigU" := RecTemp."44 Asig";
                        RecTempImpLin."45 AsigU" := RecTemp."45 Asig";
                        RecTempImpLin."46 AsigU" := RecTemp."46 Asig";
                        RecTempImpLin."47 AsigU" := RecTemp."47 Asig";
                        RecTempImpLin."48 AsigU" := RecTemp."48 Asig";
                        RecTempImpLin."49 AsigU" := RecTemp."49 Asig";
                        RecTempImpLin.MODIFY;
                    END;
                END;
                RecTempImpLin.RESET;
                RecTempImpLin.SETCURRENTKEY("Clave 1", "Clave 2", "Clave 4", "Clave 5", "Clave 6", Proceso);
                RecTempImpLin.SETRANGE("Clave 1", RecTempImporte."Clave 1");
                RecTempImpLin.SETRANGE("Clave 2", 'STOCK');
                RecTempImpLin.SETRANGE("Clave 4", RecTempImporte."Clave 4");
                RecTempImpLin.SETRANGE("Clave 5", RecTempImporte."Clave 5");
                RecTempImpLin.SETRANGE("Clave 6", RecTempImporte."Clave 6");
                //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                //RecTempImpLin.SETRANGE(Proceso,'RFIDT2');
                RecTempImpLin.SETFILTER(Proceso, 'RFIDT2|WMST2');
                //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS

                IF RecTempImpLin.FINDFIRST THEN BEGIN
                    RecTemp.RESET;
                    RecTemp.SETCURRENTKEY("Clave 1", "Clave 3", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario);
                    RecTemp.SETRANGE("Clave 1", RecTempImpLin."Clave 1");
                    RecTemp.SETRANGE("Clave 3", RecTempImpLin."Clave 3");
                    RecTemp.SETRANGE("Clave 4", RecTempImpLin."Clave 4");
                    RecTemp.SETRANGE("Clave 5", RecTempImpLin."Clave 5");
                    RecTemp.SETRANGE("Clave 6", RecTempImpLin."Clave 6");
                    //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                    //RecTemp.SETRANGE(Proceso,'RFIDTALLAS');
                    RecTemp.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
                    //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                    RecTemp.SETRANGE(usuario, USERID);
                    IF RecTemp.FINDFIRST THEN BEGIN
                        RecTempImpLin."17 AsigU" := RecTemp."17 Stock";
                        RecTempImpLin."18 AsigU" := RecTemp."18 Stock";
                        RecTempImpLin."19 AsigU" := RecTemp."19 Stock";
                        RecTempImpLin."20 AsigU" := RecTemp."20 Stock";
                        RecTempImpLin."21 AsigU" := RecTemp."21 Stock";
                        RecTempImpLin."22 AsigU" := RecTemp."22 Stock";
                        RecTempImpLin."23 AsigU" := RecTemp."23 Stock";
                        RecTempImpLin."24 AsigU" := RecTemp."24 Stock";
                        RecTempImpLin."25 AsigU" := RecTemp."25 Stock";
                        RecTempImpLin."26 AsigU" := RecTemp."26 Stock";
                        RecTempImpLin."27 AsigU" := RecTemp."27 Stock";
                        RecTempImpLin."28 AsigU" := RecTemp."28 Stock";
                        RecTempImpLin."29 AsigU" := RecTemp."29 Stock";
                        RecTempImpLin."30 AsigU" := RecTemp."30 Stock";
                        RecTempImpLin."31 AsigU" := RecTemp."31 Stock";
                        RecTempImpLin."32 AsigU" := RecTemp."32 Stock";
                        RecTempImpLin."33 AsigU" := RecTemp."33 Stock";
                        RecTempImpLin."34 AsigU" := RecTemp."34 Stock";
                        RecTempImpLin."35 AsigU" := RecTemp."35 Stock";
                        RecTempImpLin."36 AsigU" := RecTemp."36 Stock";
                        RecTempImpLin."37 AsigU" := RecTemp."37 Stock";
                        RecTempImpLin."38 AsigU" := RecTemp."38 Stock";
                        RecTempImpLin."39 AsigU" := RecTemp."39 Stock";
                        RecTempImpLin."40 AsigU" := RecTemp."40 Stock";
                        RecTempImpLin."41 AsigU" := RecTemp."41 Stock";
                        RecTempImpLin."42 AsigU" := RecTemp."42 Stock";
                        RecTempImpLin."43 AsigU" := RecTemp."43 Stock";
                        RecTempImpLin."44 AsigU" := RecTemp."44 Stock";
                        RecTempImpLin."45 AsigU" := RecTemp."45 Stock";
                        RecTempImpLin."46 AsigU" := RecTemp."46 Stock";
                        RecTempImpLin."47 AsigU" := RecTemp."47 Stock";
                        RecTempImpLin."48 AsigU" := RecTemp."48 Stock";
                        RecTempImpLin."49 AsigU" := RecTemp."49 Stock";
                        RecTempImpLin.MODIFY;
                    END;
                END;
            UNTIL RecTempImporte.NEXT = 0;

        //SF-POF
        IF ImporteAsigCli > RiesgoDisp THEN
            ERROR('El importe %1 excede el riesgo del cliente', ImporteAsigCli);
        //SF-POF:FIN
    END;

    procedure GetValueAvalDisp(pCustomerCode: Text): Decimal
    var
        Customer: Record Customer;
        cFunc: Codeunit 50000;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ImpFactPteConsig2: Decimal;
        ImpAlb: Decimal;
        ImpAnul: Decimal;
        ImpPedPte: Decimal;
        ImpagRemRech: Decimal;
        ImpagRem: ARRAY[5] OF Decimal;
        ImpEnviosLanzados: Decimal;
        ImpEnviosSinLanzar: Decimal;
        ImpPedPteConsig: Decimal;
        ImpAnulConsig: Decimal;
        ImpPedTransferPdtServirConsig: Decimal;
        ImpEnviosLanzadosConsig: Decimal;
        ImpEnviosSinLanzarConsig: Decimal;
        ImpPedTransitoConsig: Decimal;
        ImpStockConsig: Decimal;
        ImpFactPteConsig: Decimal;
        ImpFactPteImpagConsig: Decimal;
        ImpEfecPendConsig: Decimal;
        ImpEfecPendRemesasConsig: Decimal;
        ImpEfectPendRemesasRegConsig: Decimal;
        ImpagRemRechConsig: Decimal;
        ImpagadosConsig: Decimal;
        ImpAvalDisp: Decimal;
        ImpRiesgoFinancieroConsig: Decimal;
    begin
        //EX-CV
        //EX-JFC 071221 Calcular la funcion con el nuevo calculo de riesgo
        Customer.RESET;
        Customer.SETRANGE("No.", pCustomerCode);
        IF Customer.FINDFIRST THEN;
        //EX-JFC 071221 Calcular la funcion con el nuevo calculo de riesgo

        //EX-JFC 071221 Calcular la funcion con el nuevo calculo de riesgo
        //Se comenta ya que no se va a usar este calculo
        //ImpRiesgoFinancieroConsig := ImpPedPteConsig + ImpAnulConsig + ImpEnviosLanzadosConsig + ImpEnviosSinLanzarConsig +
        //                             ImpPedTransitoConsig + ImpStockConsig + ImpFactPteConsig + ImpFactPteImpagConsig +
        //                             ImpEfecPendConsig + ImpEfecPendRemesasConsig + ImpEfectPendRemesasRegConsig;


        RiesgoCliente(pCustomerCode);
        GetDataAvalConsignacion(ImpPedPteConsig, ImpAnulConsig, ImpPedTransferPdtServirConsig,
                                                ImpEnviosLanzadosConsig, ImpEnviosSinLanzarConsig, ImpPedTransitoConsig,
                                                ImpStockConsig, ImpFactPteConsig, ImpFactPteImpagConsig,
                                                ImpEfecPendConsig, ImpEfecPendRemesasConsig, ImpEfectPendRemesasRegConsig,
                                                ImpagRemRechConsig);
        getImpagadosConsig(ImpagadosConsig);

        //3348 - MEP - 2022 03 03
        //Imp. Fact. Pte. Consignacion
        //Saldos Pendientes Consignacion
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Ventas en consignacion", TRUE);
        CustLedgerEntry.SETRANGE(Open, TRUE);
        CustLedgerEntry.SETRANGE("Customer No.", Customer."No.");
        IF CustLedgerEntry.FINDSET THEN
            REPEAT
                CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                ImpFactPteConsig2 += CustLedgerEntry."Remaining Amt. (LCY)";
            UNTIL CustLedgerEntry.NEXT = 0;

        //Cambiado Customer."Imp. Fact. Pte. Consignacion" por ImpFactPteConsig2"
        //EX-JFC 071221 Calcular la funcion con el nuevo calculo de riesgo
        //Importe riesgo financiero Pendiente
        ImpRiesgoFinancieroConsig := ImpFactPteConsig2 +
                                        (ImpStockConsig + ImpPedTransitoConsig +
                                            ImpEnviosLanzadosConsig + ImpEnviosSinLanzarConsig);
        //EX-JFC 071221 Calcular la funcion con el nuevo calculo de riesgo


        lRecConsignmentCondition.RESET;
        lRecConsignmentCondition.SETRANGE("Customer No.", pCustomerCode);
        lRecConsignmentCondition.SETRANGE("Register Type", lRecConsignmentCondition."Register Type"::Consignment);
        lRecConsignmentCondition.SETRANGE("Value Type", lRecConsignmentCondition."Value Type"::Aval);
        IF lRecConsignmentCondition.FINDFIRST THEN;

        ImpAvalDisp := lRecConsignmentCondition.Value - ImpRiesgoFinancieroConsig;

        EXIT(ImpAvalDisp)
    end;

    PROCEDURE GetDataAvalConsignacion(VAR pImpPedPteConsig: Decimal; VAR pImpAnulConsig: Decimal; VAR pImpPedTransferPdtServirConsig: Decimal;
     VAR pImpEnviosLanzadosConsig: Decimal; VAR pImpEnviosSinLanzarConsig: Decimal; VAR pImpPedTransitoConsig: Decimal;
     VAR pImpStockConsig: Decimal; VAR pImpFactPteConsig: Decimal; VAR pImpFactPteImpagConsig: Decimal;
     VAR pImpEfecPendConsig: Decimal; VAR pImpEfecPendRemesasConsig: Decimal; VAR pImpEfectPendRemesasRegConsig: Decimal;
     VAR pImpagRemRechConsig: Decimal);
    BEGIN
        //EX-CV
        pImpPedPteConsig := ImpPedPteConsig;
        pImpAnulConsig := ImpAnulConsig;
        pImpPedTransferPdtServirConsig := ImpPedTransferPdtServirConsig;
        pImpEnviosLanzadosConsig := ImpEnviosLanzadosConsig;
        pImpEnviosSinLanzarConsig := ImpEnviosSinLanzarConsig;
        pImpPedTransitoConsig := ImpPedTransitoConsig;
        pImpStockConsig := ImpStockConsig;
        pImpFactPteConsig := ImpFactPteConsig;
        pImpFactPteImpagConsig := ImpFactPteImpagConsig;
        pImpEfecPendConsig := ImpEfecPendConsig;
        pImpEfecPendRemesasConsig := ImpEfecPendRemesasConsig;
        pImpEfectPendRemesasRegConsig := ImpEfectPendRemesasRegConsig;
        pImpagRemRechConsig := ImpagRemRechConsig;
        //EX-CV END
    END;

    PROCEDURE getImpagadosConsig(VAR pImpagadosConsig: Decimal);
    BEGIN
        //EX-CV
        pImpagadosConsig := ImpagadosConsig;
        //EX-CV END
    END;

    PROCEDURE RiesgoCliente(CodCliente: Code[20]): Decimal;
    VAR
        ClienteRec: Record 18;
        CurrentDate: Date;
        ValueEntry: Record 5802;
        DateFilterCalc: Codeunit 358;
        CustDateFilter: ARRAY[4] OF Text[30];
        CustDateName: ARRAY[4] OF Text[30];
        TotalAmountLCY: Decimal;
        i: Integer;
        CostCalcMgt: Codeunit 5836;
        CustSalesLCY: ARRAY[4] OF Decimal;
        AdjmtCostLCY: ARRAY[4] OF Decimal;
        CustProfit: ARRAY[4] OF Decimal;
        ProfitPct: ARRAY[4] OF Decimal;
        AdjCustProfit: ARRAY[4] OF Decimal;
        AdjProfitPct: ARRAY[4] OF Decimal;
        CustInvDiscAmountLCY: ARRAY[4] OF Decimal;
        CustPaymentDiscLCY: ARRAY[4] OF Decimal;
        CustPaymentDiscTolLCY: ARRAY[4] OF Decimal;
        CustPaymentTolLCY: ARRAY[4] OF Decimal;
        CustReminderChargeAmtLCY: ARRAY[4] OF Decimal;
        CustFinChargeAmtLCY: ARRAY[4] OF Decimal;
        CustCrMemoAmountsLCY: ARRAY[4] OF Decimal;
        CustPaymentsLCY: ARRAY[4] OF Decimal;
        CustRefundsLCY: ARRAY[4] OF Decimal;
        CustOtherAmountsLCY: ARRAY[4] OF Decimal;
        InvAmountsLCY: ARRAY[4] OF Decimal;
        MovCli: Record 21;
        SaldoClientes: Record 50017;
        //PickLinResumen : Record 50010;
        CantPicking: Integer;
        RecLinPedido: Record 37;
        FactorCant: Decimal;
        MovReserva: Record 50012;
        RecPedido: Record 36;
        RecPedido2: Record 36;
        RecLinVta: Record 37;
        "--EX-LV-SGG": Integer;
        //lRstLinEnvAlm : Record 50403;
        lImpAux: Decimal;
        lRecTransferHeader: Record 5740;
        lRecTransferLine: Record 5741;
        lRecSalesHeader: Record 36;
        lRecLocation: Record 14;
        lRecItemLedEntry: Record 32;
        lRecItem: Record 27;
        lQtyPerUnitMeasurement: Decimal;
        lcuUOMMgt: Codeunit 5402;
        recTransferLine: Record 5741;
        TransferHeader: Record 5740;
        lPedConsig: Boolean;
        //lRstHeadEnvAlm : Record 50402;
        lRecCustomer: Record 18;
        CustLedgerEntry: Record 21;
        ImpFactPte: Decimal;
        SaldoMigracion: Decimal;
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        Impagados: Decimal;
        FactPte: Decimal;

    BEGIN

        SaldoMigracion := 0;
        ClienteRec.RESET;
        ClienteRec.GET(CodCliente); //EX-SGG-WMS 100719
        ClienteRec.CalcFields("Riesgo Concedido Consignacion", "Riesgo Concedido Firme");

        IF CurrentDate <> WORKDATE THEN BEGIN
            CurrentDate := WORKDATE;
        END;

        //EX-SGG-WMS 090719 CODIGO DE FORMULARIO ESTADISTICAS CLIENTE.
        ImpAnul := 0;
        ImpPedPte := 0;
        ImpAlb := 0;
        FactorCant := 0;
        //EX-CV
        CLEAR(ImpPedPteConsig);
        CLEAR(ImpAnulConsig);
        CLEAR(ImpPedTransferPdtServirConsig);
        CLEAR(ImpEnviosLanzadosConsig);
        CLEAR(ImpEnviosSinLanzarConsig);
        CLEAR(ImpPedTransitoConsig);
        CLEAR(ImpStockConsig);
        CLEAR(ImpFactPteConsig);
        CLEAR(ImpFactPteImpagConsig);
        CLEAR(ImpEfecPendConsig);
        CLEAR(ImpEfecPendRemesasConsig);
        CLEAR(ImpEfectPendRemesasRegConsig);
        CLEAR(ImpagRemRechConsig);
        CLEAR(ImpagadosConsig);
        //EX-CV END

        RecLinVta.RESET;
        RecLinVta.SETCURRENTKEY("Document Type", "Sell-to Customer No.",
        "Outstanding Quantity", "Document No.", "Fecha servicio solicitada");
        RecLinVta.SETRANGE("Document Type", RecLinVta."Document Type"::Order);
        RecLinVta.SETRANGE("Sell-to Customer No.", ClienteRec."No.");
        IF RecLinVta.FINDFIRST THEN
            REPEAT

                IF RecLinVta.Quantity <> 0 THEN
                    FactorCant := RecLinVta."Cantidad Anulada" / RecLinVta.Quantity
                ELSE
                    FactorCant := 0;

                //EX-JFC 14/11/14 Calcular el importe en EUROS
                RecPedido.RESET;
                RecPedido.SETRANGE(RecPedido."No.", RecLinVta."Document No.");
                IF RecPedido.FINDFIRST THEN BEGIN
                    //EX-CV
                    IF RecPedido."Currency Code" = '' THEN BEGIN
                        IF NOT RecPedido."Ventas en consignacion" THEN BEGIN
                            ImpAnul += (RecLinVta."Cantidad Anulada" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);
                        END ELSE BEGIN
                            ImpAnulConsig += (RecLinVta."Cantidad Anulada" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);
                        END;
                    END ELSE BEGIN
                        Currency.InitRoundingPrecision;
                        IF NOT RecPedido."Ventas en consignacion" THEN BEGIN
                            ImpAnul += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                            RecPedido."Posting Date", RecPedido."Currency Code",
                            ((RecLinVta."Cantidad Anulada" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100)),
                            RecPedido."Currency Factor"),
                            Currency."Amount Rounding Precision");
                        END ELSE BEGIN
                            ImpAnulConsig += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                            RecPedido."Posting Date", RecPedido."Currency Code",
                            ((RecLinVta."Cantidad Anulada" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100)),
                            RecPedido."Currency Factor"),
                            Currency."Amount Rounding Precision");
                        END;
                    END;
                    //EX-CV END
                END;
                //EX-JFC 14/11/14 Calcular el importe en EUROS


                IF RecLinVta.Quantity <> 0 THEN
                    FactorCant := RecLinVta."Outstanding Quantity" / RecLinVta.Quantity
                ELSE
                    FactorCant := 0;

                //EX-JFC 14/11/14 Calcular el importe en EUROS
                RecPedido.RESET;
                RecPedido.SETRANGE(RecPedido."No.", RecLinVta."Document No.");
                IF RecPedido.FINDFIRST THEN BEGIN
                    //EX-CV
                    IF RecPedido."Currency Code" = '' THEN BEGIN
                        IF NOT RecPedido."Ventas en consignacion" THEN BEGIN
                            ImpPedPte += (RecLinVta."Outstanding Quantity" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);
                        END ELSE BEGIN
                            ImpPedPteConsig += (RecLinVta."Outstanding Quantity" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);
                        END;
                    END ELSE BEGIN
                        Currency.InitRoundingPrecision;
                        IF NOT RecPedido."Ventas en consignacion" THEN BEGIN
                            ImpPedPte += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                            RecPedido."Posting Date", RecPedido."Currency Code",
                            ((RecLinVta."Outstanding Quantity" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100)),
                            RecPedido."Currency Factor"),
                            Currency."Amount Rounding Precision");
                        END ELSE BEGIN
                            ImpPedPteConsig += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                            RecPedido."Posting Date", RecPedido."Currency Code",
                            ((RecLinVta."Outstanding Quantity" * RecLinVta."Unit Price" -
                            RecLinVta."Inv. Discount Amount" * FactorCant -
                            RecLinVta."Pmt. Discount Amount" * FactorCant)
                            * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100)),
                            RecPedido."Currency Factor"),
                            Currency."Amount Rounding Precision");
                        END;
                    END;
                    //EX-CV END
                END;
                //EX-JFC 14/11/14 Calcular el importe en EUROS

                IF Not CalcularRiesgoCliSinAlbaranes THEN //EX-SGG-WMS 090719
                 BEGIN
                    IF RecLinVta.Quantity <> 0 THEN
                        FactorCant := RecLinVta."Qty. Shipped Not Invoiced" / RecLinVta.Quantity
                    ELSE
                        FactorCant := 0;
                    //modificado por practicas2
                    CLEAR(RecPedido2);
                    RecPedido2.RESET;
                    RecPedido2.SETRANGE(RecPedido2."Document Type", RecPedido2."Document Type"::Order);
                    RecPedido2.SETRANGE(RecPedido2."No.", RecLinVta."Document No.");
                    IF RecPedido2.FINDFIRST THEN BEGIN
                        //IF RecPedido."No. Series"<>'S-SHPT-SC'  THEN
                        IF RecPedido2."Shipping No. Series" <> 'S-SHPT-SC' THEN BEGIN
                            //EX-JFC 14/11/14 Calcular el importe en EUROS
                            RecPedido.RESET;
                            RecPedido.SETRANGE(RecPedido."No.", RecLinVta."Document No.");
                            IF RecPedido.FINDFIRST THEN BEGIN
                                //SF-MLA 16/03/16 Se redondea y se hace el cambio de divisa sobre el total para no perder c ntimos.
                                //EX-CV
                                IF NOT RecPedido."Ventas en consignacion" THEN
                                    ImpAlb += (RecLinVta."Qty. Shipped Not Invoiced" * RecLinVta."Unit Price" -
                                    RecLinVta."Inv. Discount Amount" * FactorCant -
                                    RecLinVta."Pmt. Discount Amount" * FactorCant)
                                    * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);
                                //EX-CV END
                                //                                 {
                                //                                 END ELSE
                                //                                 BEGIN

                                //                                   Currency.InitRoundingPrecision;
                                //                                   ImpAlb += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                //                                   RecPedido."Posting Date", RecPedido."Currency Code",
                                //                                   ((RecLinVta."Qty. Shipped Not Invoiced" * RecLinVta."Unit Price" -
                                //                                   RecLinVta."Inv. Discount Amount" * FactorCant -
                                //                                   RecLinVta."Pmt. Discount Amount" * FactorCant)
                                //                                   * (1 + RecLinVta."VAT %"/100 + RecLinVta."EC %"/100)),
                                //                                   RecPedido."Currency Factor"),
                                //                                   Currency."Amount Rounding Precision");
                                //                                 }
                            END;

                            //EX-JFC 14/11/14 Calcular el importe en EUROS

                        END;
                    END;
                    //fin modificado
                END; //EX-SGG-WMS 090719

            UNTIL RecLinVta.NEXT = 0;
        //SF-ALD 090317 El factor de divisa corresponder  al  ltimo factor de divisa existente
        RecPedido.RESET;
        RecPedido.SETRANGE(RecPedido."Document Type", RecPedido."Document Type"::Order);
        RecPedido.SETRANGE(RecPedido."Sell-to Customer No.", ClienteRec."No.");
        //RecPedido.FINDLAST;
        IF RecPedido.FINDLAST THEN //EX-SGG-WMS 030919
            IF (RecPedido."Currency Code" <> '') AND (NOT CalcularRiesgoCliSinAlbaranes) THEN BEGIN //EX-SGG-WMS 090719
                CurrExchRate.SETFILTER(CurrExchRate."Currency Code", RecPedido."Currency Code");
                CurrExchRate.FINDLAST;
                //SF-ALD FIN
                Currency.InitRoundingPrecision;
                ImpAlb := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                RecPedido."Posting Date", RecPedido."Currency Code", ImpAlb, CurrExchRate."Exchange Rate Amount")
                , Currency."Amount Rounding Precision");
            END;
        //FIN SF-MLA

        //FIN EX-SGG-WMS 090719

        CLEAR(CalcularRiesgoCliSinAlbaranes);//EX-SGG-WMS 090719


        UpdateDocStatistics(CodCliente);

        //Impagados
        IF RecFormaPago.GET(ClienteRec."Payment Method Code") THEN;
        Impagados := 0;
        MovCli.RESET;
        MovCli.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
        MovCli.SETRANGE("Customer No.", CodCliente);
        MovCli.SETRANGE(Open, TRUE);
        //       IF NOT RecFormaPago."Bloqueo impago" THEN
        //         MovCli.SETFILTER("Due Date",'<%1',WORKDATE - 15)
        //       ELSE
        MovCli.SETFILTER("Due Date", '<=%1', WORKDATE);
        IF MovCli.FINDFIRST THEN
            REPEAT
                MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                //EX-CV
                IF NOT MovCli."Ventas en consignacion" THEN
                    Impagados += MovCli."Remaining Amt. (LCY)"
                ELSE
                    ImpagadosConsig += MovCli."Remaining Amt. (LCY)";
            //EX-CV END
            UNTIL MovCli.NEXT = 0;

        FactPte := 0;
        MovCli.RESET;
        MovCli.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
        MovCli.SETRANGE("Customer No.", CodCliente);
        MovCli.SETRANGE(Open, TRUE);
        //MovCli.SETRANGE("Document Type",MovCli."Document Type"::Invoice);
        MovCli.SETFILTER("Document Type", '%1|%2|%3|%4', MovCli."Document Type"::Invoice,
             MovCli."Document Type"::Payment, MovCli."Document Type"::"Credit Memo",
             MovCli."Document Type"::" ");
        //EX-CV
        IF MovCli.FINDSET THEN
            REPEAT
                //SF-LBD 20/10/14
                //MovCli.CALCFIELDS("Remaining Amount");
                //FactPte += MovCli."Remaining Amount";
                MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                IF NOT MovCli."Ventas en consignacion" THEN
                    FactPte += MovCli."Remaining Amt. (LCY)"
                ELSE
                    ImpFactPteConsig += MovCli."Remaining Amt. (LCY)";
            UNTIL MovCli.NEXT = 0;
        //EX-CV END

        FactPteImpag := 0;
        MovCli.RESET;
        MovCli.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
        MovCli.SETRANGE("Customer No.", CodCliente);
        MovCli.SETRANGE(Open, TRUE);
        MovCli.SETFILTER("Document Type", '%1|%2|%3|%4', MovCli."Document Type"::Invoice,
                MovCli."Document Type"::Payment, MovCli."Document Type"::"Credit Memo",
                MovCli."Document Type"::" ");
        //       IF NOT RecFormaPago."Bloqueo impago" THEN
        //         MovCli.SETFILTER("Due Date",'<%1',WORKDATE - 15)
        //       ELSE BEGIN
        MovCli.SETFILTER("Due Date", '<=%1', WORKDATE);
        // END;
        //EX-CV
        IF MovCli.FINDFIRST THEN
            REPEAT
                //SF-LBD 20/10/14
                //MovCli.CALCFIELDS("Remaining Amount");
                //FactPteImpag += MovCli."Remaining Amount";
                MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                IF NOT MovCli."Ventas en consignacion" THEN
                    FactPteImpag += MovCli."Remaining Amt. (LCY)"
                ELSE
                    ImpFactPteImpagConsig += MovCli."Remaining Amt. (LCY)";
            //SF-LBD FIN
            UNTIL MovCli.NEXT = 0;

        FactPte := FactPte - FactPteImpag;
        ImpFactPteConsig := ImpFactPteConsig - ImpFactPteImpagConsig;
        //EX-CV END

        //       ImpPicking := 0;
        //       FactorCant := 0;
        //       PickLinResumen.RESET;
        //       PickLinResumen.SETRANGE("Pedido Cliente No.",CodCliente);
        //       PickLinResumen.SETRANGE("Envio No.",'');
        //       IF PickLinResumen.FINDFIRST THEN
        //         REPEAT
        //           IF RecLinPedido.GET(RecLinPedido."Document Type"::Order,PickLinResumen."Pedido No.",PickLinResumen."Pedido Linea No.") THEN
        //           BEGIN
        //             IF (RecLinPedido."Outstanding Quantity" - RecLinPedido."Cantidad Anulada") <> 0 THEN BEGIN
        //               //SF-LBD 17/06/14

        //               //SF-MLA 29/03/16 Igual el c lculo al resto de formularios.
        //               //FactorCant := PickLinResumen.Cantidad/
        //               //(RecLinPedido.Quantity - RecLinPedido."Cantidad Anulada");
        //               FactorCant := PickLinResumen.Cantidad/RecLinPedido.Quantity;
        //               //FactorCant := PickLinResumen.Cantidad/
        //               //(RecLinPedido."Outstanding Quantity" - RecLinPedido."Cantidad Anulada");
        //               //SF-LBD FIN
        //             //EX-JFC 14/11/14 Calcular el importe en EUROS
        //                 RecPedido.RESET;
        //                 RecPedido.SETRANGE(RecPedido."No.",RecLinPedido."Document No.");
        //                 IF RecPedido.FINDFIRST THEN
        //                 BEGIN
        //                  // IF RecPedido."Currency Code" = '' THEN BEGIN
        //                  IF FactorCant <>0 THEN BEGIN
        //                     ImpPicking += (RecLinPedido."Unit Price" * PickLinResumen.Cantidad -
        //                     RecLinPedido."Inv. Discount Amount" * FactorCant -
        //                     RecLinPedido."Pmt. Discount Amount" * FactorCant) *
        //                     (1 + RecLinPedido."VAT %"/100 + RecLinPedido."EC %"/100)
        //                  END ELSE BEGIN
        //                     ImpPicking += (RecLinPedido."Unit Price" * PickLinResumen.Cantidad -
        //                     RecLinPedido."Inv. Discount Amount" -
        //                     RecLinPedido."Pmt. Discount Amount") *
        //                     (1 + RecLinPedido."VAT %"/100 + RecLinPedido."EC %"/100)

        //                  END;
        // //                   {
        // //                   END ELSE
        // //                   BEGIN
        // //                     Currency.InitRoundingPrecision;
        // //                     ImpPicking += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
        // //                     RecPedido."Posting Date", RecPedido."Currency Code",
        // //                     ((RecLinPedido."Unit Price" * PickLinResumen.Cantidad -
        // //                     RecLinPedido."Inv. Discount Amount" * FactorCant -
        // //                     RecLinPedido."Pmt. Discount Amount" * FactorCant) *
        // //                     (1 + RecLinPedido."VAT %"/100 + RecLinPedido."EC %"/100)),
        // //                     RecPedido."Currency Factor"),
        // //                     Currency."Amount Rounding Precision");
        // //                   END;
        // //                   }
        //                END;
        //              END;
        //              //EX-JFC 14/11/14 Calcular el importe en EUROS
        //            END;
        //         UNTIL PickLinResumen.NEXT = 0;
        //SF-MLA 29/03/16 Se redondea y se hace el cambio de divisa sobre el total para no perder c ntimos.
        //       IF RecPedido."Currency Code" <> '' THEN BEGIN
        //         ImpPicking:= ROUND(CurrExchRate.ExchangeAmtFCYToLCY(RecPedido."Posting Date", RecPedido."Currency Code",
        //         ImpPicking,RecPedido."Currency Factor"),Currency."Amount Rounding Precision");
        //       END;

        //       ImpReserva := 0;
        //       RecPedido.RESET;
        //       RecPedido.SETRANGE("Document Type",RecPedido."Document Type"::Order);
        //       RecPedido.SETRANGE("Sell-to Customer No.",CodCliente);
        //       IF RecPedido.FINDFIRST THEN
        //         REPEAT
        //           RecPedido.CALCFIELDS("Reserva Picking");
        //           IF RecPedido."Reserva Picking" <> 0 THEN BEGIN
        //             MovReserva.RESET;
        //             MovReserva.SETRANGE("Origen Documento No.",RecPedido."No.");
        //             IF MovReserva.FINDFIRST THEN
        //               REPEAT
        //           IF RecLinPedido.GET(RecLinPedido."Document Type"::Order,
        //                 MovReserva."Origen Documento No.",MovReserva."Origen Documento Line No.") THEN
        //           BEGIN
        //             IF RecLinPedido."Outstanding Quantity" <> 0 THEN BEGIN
        //               //SF-LBD 17/06/14
        //               FactorCant := MovReserva."Cantidad Reservada"/RecLinPedido.Quantity;
        //               //FactorCant := MovReserva."Cantidad Reservada"/RecLinPedido."Outstanding Quantity";
        //               //SF-LBD FIN
        //             //EX-JFC 14/11/14 Calcular el importe en EUROS
        //                 //RecPedido.RESET;
        //                 //RecPedido.SETRANGE(RecPedido."No.",RecLinPedido."Document No.");
        //                 //IF RecPedido.FINDFIRST THEN
        //                 //BEGIN
        //                   IF RecPedido."Currency Code" = '' THEN BEGIN
        //                     ImpReserva += (RecLinPedido."Unit Price" * MovReserva."Cantidad Reservada" -
        //                     RecLinPedido."Inv. Discount Amount" * FactorCant -
        //                     RecLinPedido."Pmt. Discount Amount" * FactorCant) *
        //                     (1 + RecLinPedido."VAT %"/100 + RecLinPedido."EC %"/100)
        //                   END ELSE
        //                   BEGIN
        //                     Currency.InitRoundingPrecision;
        //                     ImpReserva += ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
        //                     RecPedido."Posting Date", RecPedido."Currency Code",
        //                     ((RecLinPedido."Unit Price" * MovReserva."Cantidad Reservada" -
        //                   RecLinPedido."Inv. Discount Amount" * FactorCant -
        //                   RecLinPedido."Pmt. Discount Amount" * FactorCant) *
        //                   (1 + RecLinPedido."VAT %"/100 + RecLinPedido."EC %"/100)),
        //                     RecPedido."Currency Factor"),
        //                     Currency."Amount Rounding Precision");
        //                   END;
        //                //END;
        //              END;
        //             //EX-JFC 14/11/14 Calcular el importe en EUROS
        //           END;

        //               UNTIL MovReserva.NEXT = 0;
        //           END;

        //           //EX-CV
        //           IF RecPedido."Ventas en consignacion" THEN BEGIN
        //             lRecTransferLine.RESET;
        //             lRecTransferLine.SETRANGE(lRecTransferLine."No. pedido", RecPedido."No.");
        //             IF lRecTransferLine.FINDSET THEN REPEAT
        //               lRstLinEnvAlm.RESET;
        //               lRstLinEnvAlm.SETRANGE("Source No.", lRecTransferLine."Document No.");
        //               lRstLinEnvAlm.SETRANGE("Source Line No.", lRecTransferLine."Line No.");
        //               IF lRstLinEnvAlm.FINDFIRST THEN BEGIN

        //                 IF RecLinVta.GET(RecLinVta."Document Type"::Order,RecPedido."No.",lRstLinEnvAlm."Source Line No.") THEN;
        //                  CLEAR(FactorCant);
        //                  IF RecLinVta.Quantity <> 0 THEN
        //                    FactorCant := lRstLinEnvAlm.Quantity/RecLinVta.Quantity;

        //                 lImpAux := (lRstLinEnvAlm.Quantity * RecLinVta."Unit Price" -
        //                   RecLinVta."Inv. Discount Amount" * FactorCant -
        //                   RecLinVta."Pmt. Discount Amount" * FactorCant)
        //                   * (1 + RecLinVta."VAT %"/100 + RecLinVta."EC %"/100);

        //                 lRstHeadEnvAlm.RESET;
        //                 lRstHeadEnvAlm.SETRANGE("No.", lRstLinEnvAlm."No.");
        //                 IF lRstHeadEnvAlm.FINDFIRST THEN BEGIN
        //                   CASE lRstLinEnvAlm."Estado cabecera" OF
        //                    lRstLinEnvAlm."Estado cabecera"::Released: ImpEnviosLanzadosConsig+=lImpAux;
        //                    lRstLinEnvAlm."Estado cabecera"::Open: ImpEnviosSinLanzarConsig+=lImpAux;
        //                   END;
        //                 END;
        //               END;
        //             UNTIL lRecTransferLine.NEXT = 0;
        //           END;
        //           //EX-CV END
        //         UNTIL RecPedido.NEXT = 0;

        //EX-SGG-WMS 100719 INCLYO ENVIOS ALMACEN
        //       CLEAR(ImpEnviosLanzados);
        //       CLEAR(ImpEnviosSinLanzar);
        //       lRstLinEnvAlm.RESET;
        //       lRstLinEnvAlm.SETCURRENTKEY("No.","Destination Type","Destination No.");
        //       lRstLinEnvAlm.SETRANGE("Destination Type",lRstLinEnvAlm."Destination Type"::Customer);
        //       lRstLinEnvAlm.SETRANGE("Destination No.",ClienteRec."No.");
        //       lRstLinEnvAlm.SETRANGE("Source Type",DATABASE::"Sales Line");
        //       IF lRstLinEnvAlm.FINDSET THEN
        //        REPEAT
        //         IF RecLinVta.GET(RecLinVta."Document Type"::Order,lRstLinEnvAlm."Source No.",lRstLinEnvAlm."Source Line No.") THEN
        //          BEGIN
        //            CLEAR(FactorCant);
        //            IF RecLinVta.Quantity <> 0 THEN
        //              FactorCant := lRstLinEnvAlm.Quantity/RecLinVta.Quantity;

        //             lImpAux := (lRstLinEnvAlm.Quantity * RecLinVta."Unit Price" -
        //               RecLinVta."Inv. Discount Amount" * FactorCant -
        //               RecLinVta."Pmt. Discount Amount" * FactorCant)
        //               * (1 + RecLinVta."VAT %"/100 + RecLinVta."EC %"/100);

        //             //EX-CV
        //             lPedConsig := FALSE;
        //             {
        //             lPedConsig := FALSE;
        //             TransferHeader.RESET;
        //             TransferHeader.SETRANGE("No.", lRstLinEnvAlm."Source No.");
        //             IF TransferHeader.FINDFIRST THEN BEGIN
        //               recTransferLine.RESET;
        //               recTransferLine.SETRANGE("Document No.", TransferHeader."No.");
        //               recTransferLine.SETRANGE("Line No.", lRstLinEnvAlm."Source Line No.");
        //               IF recTransferLine.FINDFIRST THEN BEGIN
        //                 lRecSalesHeader.RESET;
        //                 //SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        //                 lRecSalesHeader.SETRANGE("No.", TransferHeader."No. pedido venta");
        //                 lRecSalesHeader.SETRANGE("Ventas en consignacion", TRUE);
        //                 IF lRecSalesHeader.FINDFIRST THEN BEGIN
        //                   lPedConsig := TRUE;
        //                   CASE lRstLinEnvAlm."Estado cabecera" OF
        //                    lRstLinEnvAlm."Estado cabecera"::Released: ImpEnviosLanzadosConsig+=lImpAux;
        //                    lRstLinEnvAlm."Estado cabecera"::Open: ImpEnviosSinLanzarConsig+=lImpAux;
        //                   END;
        //                 END;
        //               END;
        //             END;

        //             IF NOT lPedConsig THEN BEGIN
        //               lRecSalesHeader.RESET;
        //               //SalesLine.SETRANGE("Document Type", SalesLine."Document Type"::Order);
        //               lRecSalesHeader.SETRANGE("No.",  lRstLinEnvAlm."Source No.");
        //               lRecSalesHeader.SETRANGE("Ventas en consignacion", TRUE);
        //               IF lRecSalesHeader.FINDFIRST THEN BEGIN
        //                 lPedConsig := TRUE;
        //                 CASE lRstLinEnvAlm."Estado cabecera" OF
        //                  lRstLinEnvAlm."Estado cabecera"::Released: ImpEnviosLanzadosConsig+=lImpAux;
        //                  lRstLinEnvAlm."Estado cabecera"::Open: ImpEnviosSinLanzarConsig+=lImpAux;
        //                 END;
        //               END;
        //             END;
        //             }
        //             IF NOT lPedConsig THEN BEGIN
        //               CASE lRstLinEnvAlm."Estado cabecera" OF
        //                lRstLinEnvAlm."Estado cabecera"::Released: ImpEnviosLanzados+=lImpAux;
        //                lRstLinEnvAlm."Estado cabecera"::Open: ImpEnviosSinLanzar+=lImpAux;
        //               END;
        //             END;
        //           //EX-CV END
        //          END;
        //        UNTIL lRstLinEnvAlm.NEXT=0;

        //EX-CV
        lRecTransferLine.RESET;
        lRecTransferLine.SETRANGE("Quantity Shipped", 0);
        lRecTransferLine.SETFILTER(Quantity, '<>%1', 0);
        lRecTransferLine.SETFILTER(lRecTransferLine."No. pedido", '<>%1', '');
        lRecTransferLine.SETFILTER(lRecTransferLine."No. linea pedido", '<>%1', 0);
        IF lRecTransferLine.FINDSET THEN
            REPEAT
                RecLinVta.RESET;
                RecLinVta.SETRANGE("Document No.", lRecTransferLine."No. pedido");
                RecLinVta.SETRANGE("Line No.", lRecTransferLine."No. linea pedido");
                RecLinVta.SETRANGE("Sell-to Customer No.", ClienteRec."No.");
                IF RecLinVta.FINDFIRST THEN BEGIN
                    CLEAR(FactorCant);
                    IF RecLinVta.Quantity <> 0 THEN
                        FactorCant := lRecTransferLine.Quantity / RecLinVta.Quantity;

                    lImpAux := (lRecTransferLine.Quantity * RecLinVta."Unit Price" -
                     RecLinVta."Inv. Discount Amount" * FactorCant -
                     RecLinVta."Pmt. Discount Amount" * FactorCant)
                     * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);

                    ImpPedTransferPdtServirConsig += lImpAux;
                END;
            UNTIL lRecTransferLine.NEXT = 0;

        lRecTransferLine.RESET;
        lRecTransferLine.SETFILTER("Qty. in Transit", '<>%1', 0);
        lRecTransferLine.SETFILTER(Quantity, '<>%1', 0);
        lRecTransferLine.SETFILTER(lRecTransferLine."No. pedido", '<>%1', '');
        lRecTransferLine.SETFILTER(lRecTransferLine."No. linea pedido", '<>%1', 0);
        IF lRecTransferLine.FINDSET THEN
            REPEAT
                RecLinVta.RESET;
                RecLinVta.SETRANGE("Document No.", lRecTransferLine."No. pedido");
                RecLinVta.SETRANGE("Line No.", lRecTransferLine."No. linea pedido");
                RecLinVta.SETRANGE("Sell-to Customer No.", ClienteRec."No.");
                IF RecLinVta.FINDFIRST THEN BEGIN
                    CLEAR(FactorCant);

                    IF RecLinVta.Quantity <> 0 THEN
                        FactorCant := lRecTransferLine."Qty. in Transit" / RecLinVta.Quantity;

                    lImpAux := (lRecTransferLine."Qty. in Transit" * RecLinVta."Unit Price" -
                     RecLinVta."Inv. Discount Amount" * FactorCant -
                     RecLinVta."Pmt. Discount Amount" * FactorCant)
                     * (1 + RecLinVta."VAT %" / 100 + RecLinVta."EC %" / 100);

                    ImpPedTransitoConsig += lImpAux;
                END;
            UNTIL lRecTransferLine.NEXT = 0;

        lRecLocation.RESET;
        lRecLocation.SETRANGE(lRecLocation."Cod. cliente", ClienteRec."No.");
        lRecLocation.SETRANGE(Consignacion, TRUE);
        IF lRecLocation.FINDSET THEN
            REPEAT
                lRecItemLedEntry.RESET;
                lRecItemLedEntry.SETRANGE("Location Code", lRecLocation.Code);
                lRecItemLedEntry.SETRANGE(Open, TRUE);
                IF lRecItemLedEntry.FINDSET THEN
                    REPEAT
                        lRecItem.GET(lRecItemLedEntry."Item No.");
                        lQtyPerUnitMeasurement := lcuUOMMgt.GetQtyPerUnitOfMeasure(lRecItem, lRecItemLedEntry."Unit of Measure Code");
                        //ImpStockConsig += (lRecItem."Unit Cost" * lQtyPerUnitMeasurement);
                        //ImpStockConsig += (lRecItem."Unit Cost" * lRecItemLedEntry."Remaining Quantity"); //Ajustar Jon
                        ImpStockConsig += (getSalesPrice(lRecItem."No.", ClienteRec, lRecItemLedEntry."Variant Code")
                            * lRecItemLedEntry."Remaining Quantity"); //Ajustar Jon
                    UNTIL lRecItemLedEntry.NEXT = 0;
            UNTIL lRecLocation.NEXT = 0;
        //EX-CV END

        //EX-CV
        lRecCustomer.RESET;
        lRecCustomer.SETRANGE("No.", CodCliente);
        IF lRecCustomer.FINDFIRST THEN;
        //EXIT(ClienteRec."Riesgo NUEVO MILENIO" -
        //(ImpAlb + OpenRemainingAmtLCY[1] + OpenRemainingAmtLCY[2] + OpenRemainingAmtLCY[3] +
        // SaldoMigracion + ImpPicking + FactPte + ImpReserva+ImpEnviosLanzados) - Impagados);

        //EX-CV  -  2022 03 10
        //Saldos Pendientes
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Ventas en consignacion", FALSE);
        CustLedgerEntry.SETRANGE(Open, TRUE);
        CustLedgerEntry.SETRANGE("Customer No.", lRecCustomer."No.");
        IF CustLedgerEntry.FINDSET THEN
            REPEAT
                CustLedgerEntry.CALCFIELDS("Remaining Amt. (LCY)");
                ImpFactPte += CustLedgerEntry."Remaining Amt. (LCY)";
            UNTIL CustLedgerEntry.NEXT = 0;


        exit((ClienteRec."Riesgo Concedido Consignacion" + ClienteRec."Riesgo Concedido Firme") - (ImpFactPte + ImpAlb + SaldoMigracion + ImpEnviosLanzados));
        //EXIT(ClienteRec."Riesgo Concedido" - (ImpFactPte + ImpAlb + SaldoMigracion + ImpEnviosLanzados));
        //ImpPicking + ImpReserva + ImpEnviosLanzados));
        //EX-CV  -  2022 03 10 END
        //EX-CV END
    END;

    PROCEDURE getSalesPrice(pItem: Code[20]; pCustomer: Record 18; pVariant: Code[20]): Decimal;
    VAR
        SalesPrice: Record 7002;
        ConsignmentCondition: Record 50051;
        ret: Decimal;
        lrecItem: Record 27;
        lrecVATPostingSetup: Record 325;
        lIVA: Decimal;
    BEGIN
        //EX-CV
        ret := 0;
        SalesPrice.RESET;
        SalesPrice.SETRANGE("Item No.", pItem);
        SalesPrice.SETRANGE("Sales Type", SalesPrice."Sales Type"::Customer);
        SalesPrice.SETRANGE("Sales Code", pCustomer."No.");
        SalesPrice.SETFILTER("Starting Date", '..%1', TODAY);
        //SalesPrice.SETRANGE("Location Code", pLocation);
        SalesPrice.SETRANGE("Variant Code", pVariant);
        IF SalesPrice.FINDLAST THEN
            ret := SalesPrice."Unit Price";

        SalesPrice.RESET;
        SalesPrice.SETRANGE("Item No.", pItem);
        SalesPrice.SETRANGE("Sales Code", pCustomer."Customer Price Group");
        SalesPrice.SETFILTER("Starting Date", '..%1', TODAY);
        //SalesPrice.SETRANGE("Location Code", pLocation);
        SalesPrice.SETRANGE("Variant Code", pVariant);
        IF SalesPrice.FINDLAST THEN
            ret := SalesPrice."Unit Price";

        CLEAR(lIVA);
        lrecItem.RESET;
        lrecItem.SETRANGE("No.", pItem);
        IF lrecItem.FINDFIRST THEN BEGIN
            lrecVATPostingSetup.RESET;
            lrecVATPostingSetup.SETRANGE("VAT Bus. Posting Group", pCustomer."VAT Bus. Posting Group");
            lrecVATPostingSetup.SETRANGE("VAT Prod. Posting Group", lrecItem."VAT Prod. Posting Group");
            IF lrecVATPostingSetup.FINDFIRST THEN BEGIN
                lIVA := (ret * lrecVATPostingSetup."VAT %") / 100;
            END;
        END;

        ret += lIVA;

        IF ret <> 0 THEN BEGIN
            ConsignmentCondition.RESET;
            ConsignmentCondition.SETRANGE("Customer No.", pCustomer."No.");
            ConsignmentCondition.SETRANGE("Register Type", ConsignmentCondition."Register Type"::Consignment);
            ConsignmentCondition.SETRANGE("Value Type", ConsignmentCondition."Value Type"::"% Dto Factura Consignación");
            IF ConsignmentCondition.FINDFIRST THEN BEGIN
                ret := ret - ((ConsignmentCondition.Value) * ret / 100)
            END;
        END;

        EXIT(ret);
        //EX-CV END
    END;

    PROCEDURE UpdateDocStatistics(CodCli: Code[20]);
    VAR
        CustLedgEntry: Record 21;
        DocumentSituationFilter: ARRAY[3] OF option " ","Posted BG/PO","Closed BG/PO","BG/PO",Cartera,"Closed Documents";
        j: Integer;
        NoOpen: ARRAY[5] OF Integer;
        NoHonored: ARRAY[5] OF Integer;
        NoRejected: ARRAY[5] OF Integer;
        NoRedrawn: ARRAY[5] OF Integer;
        OpenAmtLCY: ARRAY[5] OF Decimal;
        HonoredAmtLCY: ARRAY[5] OF Decimal;
        RejectedAmtLCY: ARRAY[5] OF Decimal;
        RedrawnAmtLCY: ARRAY[5] OF Decimal;
        RejectedRemainingAmtLC: ARRAY[5] OF Decimal;
        HonoredRemainingAmtLCY: ARRAY[5] OF Decimal;
        RedrawnRemainingAmtLCY: ARRAY[5] OF Decimal;
        ImpagRem: ARRAY[5] OF Decimal;
        ClienteImpag: Record 18;
        MovCli: Record 21;
    BEGIN
        DocumentSituationFilter[1] := DocumentSituationFilter::Cartera;
        DocumentSituationFilter[2] := DocumentSituationFilter::"BG/PO";
        DocumentSituationFilter[3] := DocumentSituationFilter::"Posted BG/PO";

        WITH CustLedgEntry DO BEGIN
            SETCURRENTKEY("Customer No.", "Document Type", "Document Situation", "Document Status");
            SETRANGE("Customer No.", CodCli);
            FOR j := 1 TO 5 DO BEGIN
                CASE j OF
                    4: // Closed Bill Group and Closed Documents
                        BEGIN
                            SETRANGE("Document Type", "Document Type"::Bill);
                            SETFILTER("Document Situation", '%1|%2',
                              "Document Situation"::"Closed BG/PO",
                              "Document Situation"::"Closed Documents");
                        END;
                    5: // Invoices
                        BEGIN
                            SETRANGE("Document Type", "Document Type"::Invoice);
                            SETFILTER("Document Situation", '<>0');
                        END;
                    ELSE BEGIN
                        SETRANGE("Document Type", "Document Type"::Bill);
                        SETRANGE("Document Situation", DocumentSituationFilter[j]);
                    END;
                END;

                IF ((j = 1) OR (j = 2) OR (j = 3)) THEN BEGIN
                    IF ClienteImpag.GET(CodCli) THEN;
                    IF RecFormaPago.GET(ClienteImpag."Payment Method Code") THEN;
                    ImpagRem[j] := 0;
                    MovCli.RESET;
                    MovCli.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
                    MovCli.SETRANGE("Customer No.", CodCli);
                    MovCli.SETRANGE(Open, TRUE);
                    MovCli.SETRANGE("Ventas en consignacion", FALSE);
                    MovCli.SETRANGE("Document Situation", DocumentSituationFilter[j]);
                    //   IF NOT RecFormaPago."Bloqueo impago" THEN
                    //     MovCli.SETFILTER("Due Date",'<%1',WORKDATE - 15)
                    //   ELSE
                    MovCli.SETFILTER("Due Date", '<=%1', WORKDATE);
                    IF MovCli.FINDFIRST THEN
                        REPEAT
                            MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                            //EX-CV
                            IF NOT MovCli."Ventas en consignacion" THEN
                                ImpagRem[j] += MovCli."Remaining Amt. (LCY)"
                        //ELSE BEGIN
                        //  CASE j OF
                        //    1 : ImpEfecPendConsig += MovCli."Remaining Amt. (LCY)";
                        //    2 : ImpEfecPendRemesasConsig += MovCli."Remaining Amt. (LCY)";
                        //    3 : ImpEfectPendRemesasRegConsig += MovCli."Remaining Amt. (LCY)";
                        // END;
                        //END;
                        //EX-CV END
                        UNTIL MovCli.NEXT = 0;
                END;

                //EX-CV
                CLEAR(ImpEfecPendConsig);
                CLEAR(ImpEfecPendRemesasConsig);
                CLEAR(ImpEfectPendRemesasRegConsig);
                MovCli.RESET;
                MovCli.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
                MovCli.SETRANGE("Customer No.", CodCli);
                MovCli.SETRANGE(Open, TRUE);
                MovCli.SETRANGE("Ventas en consignacion", TRUE);
                //IF NOT RecFormaPago."Bloqueo impago" THEN
                //  MovCli.SETFILTER("Due Date",'<%1',WORKDATE - 15)
                //ELSE
                //  MovCli.SETFILTER("Due Date",'<=%1',WORKDATE);
                IF MovCli.FINDFIRST THEN
                    REPEAT
                        MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                        CASE MovCli."Document Situation" OF
                            MovCli."Document Situation"::Cartera:
                                ImpEfecPendConsig += MovCli."Remaining Amt. (LCY)";
                            MovCli."Document Situation"::"BG/PO":
                                ImpEfecPendRemesasConsig += MovCli."Remaining Amt. (LCY)";
                            MovCli."Document Situation"::"Posted BG/PO":
                                ImpEfectPendRemesasRegConsig += MovCli."Remaining Amt. (LCY)";
                        END;
                    UNTIL MovCli.NEXT = 0;

                //EX-CV END

                //EX-SGG-WMS 100719 AGREGO CODIGO FORMULARIO ESTADISTICAS
                ImpagRemRech := 0;
                MovCli.RESET;
                MovCli.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date", "Currency Code");
                MovCli.SETRANGE("Customer No.", CodCli);
                MovCli.SETRANGE(Open, TRUE);
                MovCli.SETRANGE(Positive, TRUE);
                MovCli.SETRANGE("Document Status", MovCli."Document Status"::Rejected);
                IF MovCli.FINDFIRST THEN
                    REPEAT
                        MovCli.CALCFIELDS("Remaining Amt. (LCY)");
                        //EX-CV
                        IF NOT MovCli."Ventas en consignacion" THEN
                            ImpagRemRech += MovCli."Remaining Amt. (LCY)"
                        ELSE
                            ImpagRemRechConsig += MovCli."Remaining Amt. (LCY)";
                    //EX-CV END
                    UNTIL MovCli.NEXT = 0;
                //FIN EX-SGG-WMS 100719 AGREGO CODIGO FORMULARIO ESTADISTICAS

                SETRANGE("Document Status", "Document Status"::Open);
                CALCSUMS("Remaining Amount (LCY) stats."); //EX-SGG-WMS 100719
                                                           //EX-OMI 260320
                                                           //OpenRemainingAmtLCY[j] := "Remaining Amount (LCY) stats." - ImpagRem[j];
                                                           //EX-CV
                IF NOT "Ventas en consignacion" THEN BEGIN
                    IF j <> 1 THEN
                        OpenRemainingAmtLCY[j] := "Remaining Amount (LCY) stats." - ImpagRem[j]
                    ELSE
                        OpenRemainingAmtLCY[j] := "Remaining Amount (LCY) stats.";
                END;
                //EX-CV END
                //EX-OMI 260320 fin
            END;
        END;
    end;




    //WMS EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
    //EX-JFC 071221 Calculo de RiesgoDisp en funcion de si el documento es de venta en firme o de venta en consignacion

}


