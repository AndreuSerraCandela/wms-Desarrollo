/// <summary>
/// Table PfsPostingQuee (ID 50204).
/// </summary>
table 50204 PfsPostingQuee
{
    DataClassification = ToBeClassified;
    //Registros en cola;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            CaptionML = ENU = 'Entry No.', ESP = 'No. Mov.';

        }
        field(2; "Created By"; Code[20])
        {
            CaptionML = ENU = 'Created By',
                        ESP = 'Creado por';
            Editable = false;
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(3; "Creation Date"; Date)
        {
            CaptionML = ENU = 'Creation Date',
                        ESP = 'Fecha Creación';
        }
        field(4; "Creation Time"; Time)
        {
            CaptionML = ENU = 'Creation Time',
                        ESP = 'Hora Creación';
        }
        field(5; Status; Option)
        {
            CaptionML = ENU = 'Status',
                        ESP = 'Estado';
            OptionCaption = ' ,Ready for Posting,Posting Succesfull,Posting Failed';
            OptionMembers = " ","Ready for Posting","Posting Succesfull","Posting Failed";
        }
        field(6; Priority; Integer)
        {
            CaptionML = ENU = 'Priority',
                        ESP = 'Prioridad';
        }
        field(10; "Source Type"; Integer)
        {
            CaptionML = ENU = 'Source Type',
                        ESP = 'Tipo origen';
        }
        field(11; "Source Subtype"; Option)
        {
            CaptionML = ENU = 'Source Subtype',
                        ESP = 'Subtipo origen';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(12; "Source ID"; Code[20])
        {
            CaptionML = ENU = 'Source ID',
                        ESP = 'ID origen';
        }
        field(13; "Source Batch Name"; Code[10])
        {
            CaptionML = ENU = 'Source Batch Name',
                        ESP = 'Nombre del lote de origen';
        }
        field(14; "Source Prod. Order Line"; Integer)
        {
            CaptionML = ENU = 'Source Prod. Order Line',
                        ESP = 'Source Prod. Order Line';
        }
        field(15; "Source Ref. No."; Integer)
        {
            CaptionML = ENU = 'Source Ref. No.',
                        ESP = 'Source Ref. No.';
        }
        field(20; Ship; Boolean)
        {
            CaptionML = ENU = 'Ship',
                        ESP = 'Envío';
        }
        field(21; Receive; Boolean)
        {
            CaptionML = ENU = 'Receive',
                        ESP = 'Recibir';
        }
        field(22; Invoice; Boolean)
        {
            CaptionML = ENU = 'Invoice',
                        ESP = 'Factura';
        }
        field(23; "Orig. Journal Template"; Code[10])
        {
            CaptionML = ENU = 'Orig. Journal Template',
                        ESP = 'Plantilla diario Orig.';
        }
        field(24; "Orig. Journal Batch"; Code[10])
        {
            Caption = 'Orig. Journal Batch';
        }
        field(25; Direction; Option)
        {
            CaptionML = ENU = 'Direction',
                        ESP = 'Dirección';
            OptionCaption = 'Forward,Backward';
            OptionMembers = Forward,Backward;
        }
        field(26; "Calculate Lines"; Boolean)
        {
            CaptionML = ENU = 'Calculate Lines',
                        ESP = 'Calcular líneas';
        }
        field(27; "Calculate Components"; Boolean)
        {
            CaptionML = ENU = 'Calculate Components',
                        ESP = 'Calcular Componentes';
        }
        field(28; "Calculate Routing"; Boolean)
        {
            CaptionML = ENU = 'Calculate Routing',
                        ESP = 'Calcular Enrutamiento';
        }
        field(29; "Create Inbound Request"; Boolean)
        {
            CaptionML = ENU = 'Create Inbound Request',
                        ESP = 'Crear solicitud entrante';
        }
        field(30; "Prod. Order Action"; Option)
        {
            CaptionML = ENU = 'Prod. Order Action Message',
                        ESP = 'Mensaje de acción del pedido';
            OptionCaption = 'Refresh,Change Status';
            OptionMembers = Refresh,"Change Status";
        }
        field(31; "Prod. Order Status"; Option)
        {
            CaptionML = ENU = 'Prod. Order Status',
                        ESP = 'Estado del pedido';
            OptionCaption = 'Simulated,Planned,Firm Planned,Released,Finished';
            OptionMembers = Simulated,Planned,"Firm Planned",Released,Finished;
        }
        field(32; "Posting Date"; Date)
        {
            CaptionML = ENU = 'Posting Date',
                        ESP = 'Fecha registro';
        }
        field(33; "Update Unit Cost"; Boolean)
        {
            CaptionML = ENU = 'Update Unit Cost',
                        ESP = 'Actualizar costo unitario';
        }
        field(34; "Planning Flexibility"; Option)
        {
            CaptionML = ENU = 'Planning Flexibility',
                        ESP = 'Flexibilidad de planificación';
            OptionCaption = 'Unlimited,None';
            OptionMembers = Unlimited,"None";
        }
    }
    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
            MaintainSIFTIndex = false;
        }
        key(Key2; "Source Type", "Source Subtype", "Source ID", "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.", Status)
        {
            MaintainSIFTIndex = false;
        }
        key(Key3; Status, Priority)
        {
            MaintainSIFTIndex = false;
        }
        key(Key4; "Created By", "Creation Date", "Creation Time")
        {
            MaintainSIFTIndex = false;
        }
    }

    trigger OnDelete()
    begin
        IF "Source Type" = DATABASE::"Item Journal Line" THEN
            ERROR(Text001, TABLECAPTION, ItemJnlLine.TABLECAPTION);
    end;

    trigger OnInsert()
    begin
        "Created By" := USERID;
        "Creation Date" := TODAY;
        "Creation Time" := TIME;
    end;

    var
        Text001: Label 'You cannot delete a %1 of Source Type %2.\\You must use the undo posting function in the Queue Posting Item Journal.', comment = 'ESP="No puede eliminar %1 del tipo de fuente %2.\\Debe utilizar la función de deshacer publicación en el diario de elementos de publicación en cola."';

        ItemJnlLine: Record "Item Journal Line";
}