unit NrnDrv1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  util1, NrnDll1,RTdef0;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
type
  TThreadCom = class( Tthread )
                 procedure execute;override;
               end;

var
  ThreadCom:TthreadCom;




{ TThreadCom }

var
  NrnBufferHnd: Thandle;
  NrnBufferPtr: PcomBuffer;
  EventHnd: Thandle;

procedure TThreadCom.execute;
var
  len:integer;
begin
  repeat
    if WaitForSingleObject(EventHnd, 250) = WAIT_OBJECT_0 then
    begin
      case NrnBufferPtr^.command of
         nc_quit: NrnSendString('quit()');

         nc_sendString:
           begin
             NrnSendString( PshortString(@NrnBufferPtr^.data)^);

           end;

         nc_getSymList:
           begin
             getSymList( Pinteger(@NrnBufferPtr^.data)^, @NrnBufferPtr^.data, len);
           end;

         nc_ShowConsole:
      end;
      NrnBufferPtr^.command:=0;
      resetEvent(EventHnd);
    end;
  until false;
end;


procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  NrnSendString('quit()');
end;



procedure TForm1.FormCreate(Sender: TObject);
var
  st1,st2: AnsiString;
begin
  if paramCount>0 then st1:=paramStr(1) else st1:= 'C:\nrnRT2\bin\neuron.exe';
  if paramCount>1 then st2:=paramStr(2) else st2:= 'C:\nrnRT2\lib\hoc\nrngui.hoc';

  initNrnDLL(st1,st2);

  NrnBufferHnd := OpenFileMapping(FILE_MAP_ALL_ACCESS,false,stDrvBuffer);
  NrnBufferPtr := MapViewOfFile(NrnBufferHnd,FILE_MAP_ALL_ACCESS,0,0,0);

  if NrnBufferPtr =Nil then
  begin
    messageCentral('No NrnBuffer File');
    exit;
  end;

  EventHnd := OpenEvent(windows.SYNCHRONIZE, TRUE, stDrvEvent);
  if EventHnd=0 then
  begin
    messageCentral('No Nrn Event');
    exit;
  end;

  ThreadCom:= TthreadCom.create(false);

end;



end.
