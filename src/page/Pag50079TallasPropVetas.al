Page 50438 "Tallas Proposicion Fecha"
{
    SourceTable = 50011;
    PageType = ListPart;
    SourceTableView = WHERE("Clave 2" = CONST('FECHA'));
    layout
    {
        area(Content)
        {

            repeater(Detalle)
            {
                field(Descripción; Rec."Clave 2")
                {
                    Caption = 'Descripcion';
                    ApplicationArea = All;
                    Style = Strong;
                }
                field("17"; Rec."17 fecha")
                {
                    ApplicationArea = All;
                }
                field("18"; Rec."18 fecha")
                {
                    ApplicationArea = All;
                }
                field("19"; Rec."19 fecha")
                {
                    ApplicationArea = All;
                }
                field("20"; Rec."20 fecha")
                {
                    ApplicationArea = All;
                }
                field("21"; Rec."21 fecha")
                {
                    ApplicationArea = All;
                }
                field("22"; Rec."22 fecha")
                {
                    ApplicationArea = All;
                }
                field("23"; Rec."23 fecha")
                {
                    ApplicationArea = All;
                }
                field("24"; Rec."24 fecha")
                {
                    ApplicationArea = All;
                }
                field("25"; Rec."25 fecha")
                {
                    ApplicationArea = All;
                }
                field("26"; Rec."26 fecha")
                {
                    ApplicationArea = All;
                }
                field("27"; Rec."27 fecha")
                {
                    ApplicationArea = All;
                }
                field("28"; Rec."28 fecha")
                {
                    ApplicationArea = All;
                }
                field("29"; Rec."29 fecha")
                {
                    ApplicationArea = All;
                }

                field("30"; Rec."30 fecha")
                {
                    ApplicationArea = All;
                }
                field("31"; Rec."31 fecha")
                {
                    ApplicationArea = All;
                }
                field("32"; Rec."32 fecha")
                {
                    ApplicationArea = All;
                }
                field("33"; Rec."33 fecha")
                {
                    ApplicationArea = All;
                }
                field("34"; Rec."34 fecha")
                {
                    ApplicationArea = All;
                }
                field("35"; Rec."35 fecha")
                {
                    ApplicationArea = All;
                }
                field("36"; Rec."36 fecha")
                {
                    ApplicationArea = All;
                }
                field("37"; Rec."37 fecha")
                {
                    ApplicationArea = All;
                }
                field("38"; Rec."38 fecha")
                {
                    ApplicationArea = All;
                }
                field("39"; Rec."39 fecha")
                {
                    ApplicationArea = All;
                }
                field("40"; Rec."40 fecha")
                {
                    ApplicationArea = All;
                }
                field("41"; Rec."41 fecha")
                {
                    ApplicationArea = All;
                }
                field("42"; Rec."42 fecha")
                {
                    ApplicationArea = All;
                }
                field("43"; Rec."43 fecha")
                {
                    ApplicationArea = All;
                }
                field("44"; Rec."44 fecha")
                {
                    ApplicationArea = All;
                }
                field("45"; Rec."45 fecha")
                {
                    ApplicationArea = All;
                }
                field("46"; Rec."46 fecha")
                {
                    ApplicationArea = All;
                }
                field("47"; Rec."47 fecha")
                {
                    ApplicationArea = All;
                }
                field("48"; Rec."48 fecha")
                {
                    ApplicationArea = All;
                }
                field("49"; Rec."49 fecha")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    VAR
        RecTemp: Record 50011;


}

Page 50439 "Tallas Proposicion SeriePrecio"
{
    PageType = ListPart;
    SourceTable = 50011;
    SourceTableView = WHERE("Clave 2" = FILTER('SPRECIO'));
    layout
    {
        area(Content)
        {
            repeater(Detalle)
            {
                Field(Descripción; Rec."Clave 2")
                {
                    Caption = 'Descripcion';
                    ApplicationArea = All;
                    Style = Strong;
                }
                Field("17"; Rec."17 SP")
                {
                    ApplicationArea = All;
                }
                Field("18"; Rec."18 SP")
                {
                    ApplicationArea = All;
                }
                Field("19"; Rec."19 SP")
                {
                    ApplicationArea = All;
                }
                Field("20"; Rec."20 SP")
                {
                    ApplicationArea = All;
                }
                Field("21"; Rec."21 SP")
                {
                    ApplicationArea = All;
                }
                Field("22"; Rec."22 SP")
                {
                    ApplicationArea = All;
                }
                Field("23"; Rec."23 SP")
                {
                    ApplicationArea = All;
                }
                Field("24"; Rec."24 SP")
                {
                    ApplicationArea = All;
                }
                Field("25"; Rec."25 SP")
                {
                    ApplicationArea = All;
                }
                Field("26"; Rec."26 SP")
                {
                    ApplicationArea = All;
                }
                Field("27"; Rec."27 SP")
                {
                    ApplicationArea = All;
                }
                Field("28"; Rec."28 SP")
                {
                    ApplicationArea = All;
                }
                Field("29"; Rec."29 SP")
                {
                    ApplicationArea = All;
                }
                Field("30"; Rec."30 SP")
                {
                    ApplicationArea = All;
                }
                Field("31"; Rec."31 SP")
                {
                    ApplicationArea = All;
                }
                Field("32"; Rec."32 SP")
                {
                    ApplicationArea = All;
                }
                Field("33"; Rec."33 SP")
                {
                    ApplicationArea = All;
                }
                Field("34"; Rec."34 SP")
                {
                    ApplicationArea = All;
                }
                Field("35"; Rec."35 SP")
                {
                    ApplicationArea = All;
                }
                Field("36"; Rec."36 SP")
                {
                    ApplicationArea = All;
                }
                Field("37"; Rec."37 SP")
                {
                    ApplicationArea = All;
                }
                Field("38"; Rec."38 SP")
                {
                    ApplicationArea = All;
                }
                Field("39"; Rec."39 SP")
                {
                    ApplicationArea = All;
                }
                Field("40"; Rec."40 SP")
                {
                    ApplicationArea = All;
                }
                Field("41"; Rec."41 SP")
                {
                    ApplicationArea = All;
                }
                Field("42"; Rec."42 SP")
                {
                    ApplicationArea = All;
                }
                Field("43"; Rec."43 SP")
                {
                    ApplicationArea = All;
                }
                Field("44"; Rec."44 SP")
                {
                    ApplicationArea = All;
                }
                Field("45"; Rec."45 SP")
                {
                    ApplicationArea = All;
                }
                Field("46"; Rec."46 SP")
                {
                    ApplicationArea = All;
                }
                Field("47"; Rec."47 SP")
                {
                    ApplicationArea = All;
                }
                Field("48"; Rec."48 SP")
                {
                    ApplicationArea = All;
                }
                Field("49"; Rec."49 SP")
                {
                    ApplicationArea = All;
                }


            }
        }
    }


    VAR
        RecTemp: Record 50011;


}

pAGE 50440 "Tallas Proposicion"
{
    PageType = ListPart;
    SourceTable = 50011;
    layout
    {
        area(Content)
        {
            repeater(Detalle)
            {
                Field(Descripción; Rec."Clave 2")
                {
                    Caption = 'Descripcion';
                    ApplicationArea = All;
                    Style = Strong;
                }
                Field("17"; Rec."17 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("18"; Rec."18 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("19"; Rec."19 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("20"; Rec."20 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("21"; Rec."21 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("22"; Rec."22 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("23"; Rec."23 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("24"; Rec."24 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("25"; Rec."25 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("26"; Rec."26 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("27"; Rec."27 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("28"; Rec."28 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("29"; Rec."29 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("30"; Rec."30 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("31"; Rec."31 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("32"; Rec."32 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("33"; Rec."33 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("34"; Rec."34 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("35"; Rec."35 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("36"; Rec."36 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("37"; Rec."37 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("38"; Rec."38 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("39"; Rec."39 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("40"; Rec."40 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("41"; Rec."41 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("42"; Rec."42 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("43"; Rec."43 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("44"; Rec."44 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("45"; Rec."45 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("46"; Rec."46 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("47"; Rec."47 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("48"; Rec."48 AsigU")
                {
                    ApplicationArea = All;
                }
                Field("49"; Rec."49 AsigU")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Actualizar)
            {
                ApplicationArea = All;
                Image = Refresh;
                trigger OnAction()
                begin
                    IF ((Rec.Proceso = 'RFIDT2') AND (Rec."Clave 2" = '3ASIGNADO')) THEN BEGIN
                        RecTemp.RESET;
                        RecTemp.SETCURRENTKEY("Clave 1", "Clave 3", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario);
                        RecTemp.SETRANGE("Clave 1", Rec."Clave 1");
                        RecTemp.SETRANGE("Clave 3", Rec."Clave 3");
                        RecTemp.SETRANGE("Clave 4", Rec."Clave 4");
                        RecTemp.SETRANGE("Clave 5", Rec."Clave 5");
                        RecTemp.SETRANGE("Clave 6", Rec."Clave 6");
                        //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                        //RecTemp.SETRANGE(Proceso,'RFIDTALLAS');
                        RecTemp.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
                        //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                        RecTemp.SETRANGE(usuario, USERID);
                        IF RecTemp.FINDFIRST THEN BEGIN
                            Rec."17 AsigU" := RecTemp."17 Asig";
                            Rec."18 AsigU" := RecTemp."18 Asig";
                            Rec."19 AsigU" := RecTemp."19 Asig";
                            Rec."20 AsigU" := RecTemp."20 Asig";
                            Rec."21 AsigU" := RecTemp."21 Asig";
                            Rec."22 AsigU" := RecTemp."22 Asig";
                            Rec."23 AsigU" := RecTemp."23 Asig";
                            Rec."24 AsigU" := RecTemp."24 Asig";
                            Rec."25 AsigU" := RecTemp."25 Asig";
                            Rec."26 AsigU" := RecTemp."26 Asig";
                            Rec."27 AsigU" := RecTemp."27 Asig";
                            Rec."28 AsigU" := RecTemp."28 Asig";
                            Rec."29 AsigU" := RecTemp."29 Asig";
                            Rec."30 AsigU" := RecTemp."30 Asig";
                            Rec."31 AsigU" := RecTemp."31 Asig";
                            Rec."32 AsigU" := RecTemp."32 Asig";
                            Rec."33 AsigU" := RecTemp."33 Asig";
                            Rec."34 AsigU" := RecTemp."34 Asig";
                            Rec."35 AsigU" := RecTemp."35 Asig";
                            Rec."36 AsigU" := RecTemp."36 Asig";
                            Rec."37 AsigU" := RecTemp."37 Asig";
                            Rec."38 AsigU" := RecTemp."38 Asig";
                            Rec."39 AsigU" := RecTemp."39 Asig";
                            Rec."40 AsigU" := RecTemp."40 Asig";
                            Rec."41 AsigU" := RecTemp."41 Asig";
                            Rec."42 AsigU" := RecTemp."42 Asig";
                            Rec."43 AsigU" := RecTemp."43 Asig";
                            Rec."44 AsigU" := RecTemp."44 Asig";
                            Rec."45 AsigU" := RecTemp."45 Asig";
                            Rec."46 AsigU" := RecTemp."46 Asig";
                            Rec."47 AsigU" := RecTemp."47 Asig";
                            Rec."48 AsigU" := RecTemp."48 Asig";
                            Rec."49 AsigU" := RecTemp."49 Asig";

                            Rec.MODIFY;
                        END;
                    END;

                    IF ((Rec.Proceso = 'RFIDT2') AND (Rec."Clave 2" = 'STOCK')) THEN BEGIN
                        RecTemp.RESET;
                        RecTemp.SETCURRENTKEY("Clave 1", "Clave 3", "Clave 4", "Clave 5", "Clave 6", Proceso, usuario);
                        RecTemp.SETRANGE("Clave 1", Rec."Clave 1");
                        RecTemp.SETRANGE("Clave 3", Rec."Clave 3");
                        RecTemp.SETRANGE("Clave 4", Rec."Clave 4");
                        RecTemp.SETRANGE("Clave 5", Rec."Clave 5");
                        RecTemp.SETRANGE("Clave 6", Rec."Clave 6");
                        //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                        //RecTemp.SETRANGE(Proceso,'RFIDTALLAS');
                        RecTemp.SETFILTER(Proceso, 'RFIDTALLAS|WMSTALLAS');
                        //WMS FIN EX-JFC 090919 Validar tambien el proceso para los que vienen de WMS
                        RecTemp.SETRANGE(usuario, USERID);
                        IF RecTemp.FINDFIRST THEN BEGIN
                            Rec."17 AsigU" := RecTemp."17 Stock";
                            Rec."18 AsigU" := RecTemp."18 Stock";
                            Rec."19 AsigU" := RecTemp."19 Stock";
                            Rec."20 AsigU" := RecTemp."20 Stock";
                            Rec."21 AsigU" := RecTemp."21 Stock";
                            Rec."22 AsigU" := RecTemp."22 Stock";
                            Rec."23 AsigU" := RecTemp."23 Stock";
                            Rec."24 AsigU" := RecTemp."24 Stock";
                            Rec."25 AsigU" := RecTemp."25 Stock";
                            Rec."26 AsigU" := RecTemp."26 Stock";
                            Rec."27 AsigU" := RecTemp."27 Stock";
                            Rec."28 AsigU" := RecTemp."28 Stock";
                            Rec."29 AsigU" := RecTemp."29 Stock";
                            Rec."30 AsigU" := RecTemp."30 Stock";
                            Rec."31 AsigU" := RecTemp."31 Stock";
                            Rec."32 AsigU" := RecTemp."32 Stock";
                            Rec."33 AsigU" := RecTemp."33 Stock";
                            Rec."34 AsigU" := RecTemp."34 Stock";
                            Rec."35 AsigU" := RecTemp."35 Stock";
                            Rec."36 AsigU" := RecTemp."36 Stock";
                            Rec."37 AsigU" := RecTemp."37 Stock";
                            Rec."38 AsigU" := RecTemp."38 Stock";
                            Rec."39 AsigU" := RecTemp."39 Stock";
                            Rec."40 AsigU" := RecTemp."40 Stock";
                            Rec."41 AsigU" := RecTemp."41 Stock";
                            Rec."42 AsigU" := RecTemp."42 Stock";
                            Rec."43 AsigU" := RecTemp."43 Stock";
                            Rec."44 AsigU" := RecTemp."44 Stock";
                            Rec."45 AsigU" := RecTemp."45 Stock";
                            Rec."46 AsigU" := RecTemp."46 Stock";
                            Rec."47 AsigU" := RecTemp."47 Stock";
                            Rec."48 AsigU" := RecTemp."48 Stock";
                            Rec."49 AsigU" := RecTemp."49 Stock";

                            Rec.MODIFY;
                        END;
                    END;
                end;
            }
        }
    }

    VAR
        RecTemp: Record 50011;


}

