page 50419 "Control de la integracion"
{
    PageType = Worksheet;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Control integracion WMS";

    layout
    {
        area(Content)
        {
            group(Info)
            {
                field(FiltroInterfase; FiltroInterfase)
                {
                    ApplicationArea = all;
                    Caption = 'Filtro Interface', comment = 'ESP="Filtro Interface"';
                }
                field(FiltroEstado; FiltroEstado)
                {
                    ApplicationArea = all;
                    Caption = 'Filtro Estado', comment = 'ESP="Filtro Estado"';
                }

            }
            group("Informacion de Servicio")
            {
                field(infoMensaje; infoMensaje)
                {
                    Caption = 'Estado y Ultimo mensaje', comment = 'ESP="Estado y Ultimo mensaje"';
                    ApplicationArea = all;
                    Editable = false;
                }
                field(infoProximaEjecucion; infoProximaEjecucion)
                {
                    Caption = 'Ultima y proxima Ejecucion', comment = 'ESP="Ultima y proxima Ejecucion"';
                    ApplicationArea = all;
                    Editable = false;
                }

            }
            repeater(control1)
            {

                field("Interface"; Rec."Interface")
                {
                    ToolTip = 'Specifies the value of the Interface field.';
                }
                field("Tipo documento"; Rec."Tipo documento")
                {
                    ToolTip = 'Specifies the value of the Tipo documento field.';
                }
                field("No. documento"; Rec."No. documento")
                {
                    ToolTip = 'Specifies the value of the No. documento field.';
                }
                field("No. registro"; Rec."No. registro")
                {
                    ToolTip = 'Specifies the value of the No. registro field.';
                }
                field("Numero de mensaje SEGA"; Rec."Numero de mensaje SEGA")
                {
                    ToolTip = 'Specifies the value of the Numero de mensaje SEGA field.';
                }
                field("Estado SEGA"; Rec."Estado SEGA")
                {
                    ToolTip = 'Specifies the value of the Estado SEGA field.';
                }
                field(Estado; Rec.Estado)
                {
                    ToolTip = 'Specifies the value of the Estado field.';
                }
            }

        }

    }


    actions
    {
        area(Processing)
        {
            action("Obtener datos")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CduWMS9.ObtenerDatos();
                end;
            }
            action(Reintentar)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                    RstControlWMS.RESET;
                    CurrPage.SETSELECTIONFILTER(RstControlWMS);
                    CduWMS9.ReobtenerDatos(RstControlWMS);
                    CurrPage.UPDATE(FALSE);
                end;
            }
            action(Procesar)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                    RstControlWMS.RESET;
                    CurrPage.SETSELECTIONFILTER(RstControlWMS);
                    CLEAR(CduWMS);
                    CduWMS.ProcesarRegistrosControl(RstControlWMS);
                end;
            }
            action("Comunicar WS")
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                    RstControlWMS.RESET;
                    CurrPage.SETSELECTIONFILTER(RstControlWMS);
                    CLEAR(CduWMS);
                    CduWMS9.ComunicarWSRegistrosControl(RstControlWMS);
                end;
            }
            action(Refrescar)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ActualizarInformacionServicio;
                end;
            }
            action(VisualizarDatos)
            {
                Caption = 'Visualizar Datos';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CduWMS.VisualizarDatosRegistroControl(Rec);
                end;
            }
            action("Visualizar &log")
            {
                ApplicationArea = All;
                Caption = 'Visualizar Log';

                trigger OnAction()
                begin
                    CduWMS.VisualizarLOGRegistroControl(Rec); //EX-SGG-WMS 180619
                end;
            }
            action("Documento &eliminado en SEGA")
            {
                ApplicationArea = All;
                Caption = 'Documento &eliminado en SEGA';
                trigger OnAction()
                begin
                    CduWMS.DocumentoEliminadoEnSEGA(Rec);
                end;
            }
        }
    }

    procedure ActualizarInformacionServicio()
    var
        JobQueueEntry: Record "Job Queue Entry";
        JobQueueLog: Record "Job Queue Log Entry";
        JobIDFilter: Text[120];
    begin

        //NM-CSA-231019
        CLEAR(infoUltimaEjecucion);
        CLEAR(infoProximaEjecucion);
        infoEstado := '';
        infoMensaje := '';
        JobIDFilter := '';
        JobQueueEntry.RESET;
        JobQueueEntry.SETRANGE("Object Type to Run", JobQueueEntry."Object Type to Run"::Codeunit);
        JobQueueEntry.SETFILTER("Object ID to Run", '50409');
        IF JobQueueEntry.FINDSET(FALSE, FALSE) THEN BEGIN
            REPEAT
                IF STRLEN(JobIDFilter) > 0 THEN JobIDFilter += '|';
                JobIDFilter += FORMAT(JobQueueEntry.ID);
            UNTIL JobQueueEntry.NEXT = 0;
        END;
        JobQueueLog.RESET;
        JobQueueLog.SETFILTER(ID, JobIDFilter);
        IF JobQueueLog.FINDLAST THEN BEGIN
            JobQueueEntry.GET(JobQueueLog.ID);
            infoUltimaEjecucion := JobQueueLog."End Date/Time";
            infoProximaEjecucion := JobQueueEntry."Earliest Start Date/Time";
            infoEstado := FORMAT(JobQueueEntry.Status);
            infoMensaje := JobQueueLog."Error Message";
        END;

    end;

    var
        myInt: Integer;
        FiltroInterfase: Text[1024];
        FiltroEstado: Text[1024];
        infoEstado: Text[30];
        infoMensaje: Text[250];
        RstConfUsu: Record "User Setup";
        RstControlWMS: Record "Control integracion WMS";
        infoUltimaEjecucion: DateTime;
        infoProximaEjecucion: DateTime;
        CduWMS: Codeunit FuncionesWMS;
        CduWMS9: Codeunit "Funciones WMS";





}