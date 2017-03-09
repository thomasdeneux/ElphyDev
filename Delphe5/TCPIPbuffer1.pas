unit TCPIPbuffer1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
                      Annulé
Const
  Sys_Reset =     1;
  Sys_PgExec =    2;
  Sys_PgInstall = 3;
  Sys_LoadConfig =4;
  Sys_Quit =      5;

type
  TbufferInfo=record
                id:string[20];
                idNum:integer;
                flagQuery:boolean;
              end;


implementation

end.
