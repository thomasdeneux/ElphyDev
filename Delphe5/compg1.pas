unit compg1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls,menus,

  util1,Npopup,debug0;

const
  msg_EndExecute=wm_user+101;


type
  TPgCommand = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Bopen: TBitBtn;
    Bclose: TBitBtn;
    Btext: TBitBtn;
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BopenClick(Sender: TObject);
    procedure BcloseClick(Sender: TObject);
    procedure BtextClick(Sender: TObject);
  private
    { Private declarations }
    xm,ym:integer;
    cap:boolean;
    Fopen:boolean;

    procedure MessageEndExecute(var message:Tmessage);message msg_EndExecute;
  public
    { Public declarations }
    FhidePgPopUp:boolean;
    popPg:TpopupPg;
    comVisible:boolean;
    showEdit: procedure of object;
    messageErreurPg: procedure(n:integer) of object;
    procedure setTitle(st:AnsiString);
    procedure ShowPopup;
    procedure ShowMenu(menu:Tmenu;rac:TmenuItem);
  end;

function PgCommand: TPgCommand;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FPgCommand: TPgCommand;

function PgCommand: TPgCommand;
begin
  if not assigned(FPgCommand) then FPgCommand:= TPgCommand.create(nil);
  result:= FPgCommand;
end;

procedure TPgCommand.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  xm:=x;
  ym:=y;
  cap:=true;

end;

procedure TPgCommand.Panel1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if not cap then exit;

  with clientToScreen(classes.point(x,y)) do
  begin
    left:=x-xm;
    top:=y-ym;
  end;

end;

procedure TPgCommand.Panel1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  cap:=false;
end;

procedure TPgCommand.FormShow(Sender: TObject);
var
  l1,l2,h:integer;
begin
  l1:=canvas.textWidth(panel1.caption)+20;
  l2:=14*3;
  h:=14;

  width:=l1+l2+1;
  height:=h+2;

  with panel1 do
  begin
    left:=1;
    top:=1;
    width:=l1;
    height:=h;
  end;

  with panel2 do
  begin
    left:=l1+1;
    top:=1;
  end;

  Bopen.top:=0;
  Bopen.left:=0;

  Btext.top:=0;
  Btext.left:=14;

  Bclose.top:=0;
  Bclose.left:=28;


end;

procedure TPgCommand.setTitle(st:AnsiString);
begin
  panel1.caption:=st;
  formShow(self);
end;

procedure TPgCommand.showPopUp;
begin
  {if ComVisible then show;}
  popPg.show(left,top+height);
end;

procedure TPgCommand.ShowMenu(menu:Tmenu;rac:TmenuItem);
begin

end;

procedure TPgCommand.FormCreate(Sender: TObject);
begin
  ComVisible:=true;
  popPg:=TpopUpPg.create(self);
end;

procedure TPgCommand.FormDestroy(Sender: TObject);
begin
  popPg.free;
end;

procedure TPgCommand.BopenClick(Sender: TObject);
begin
  showPopUp;
end;

procedure TPgCommand.BcloseClick(Sender: TObject);
begin
  hide;
end;

procedure TPgCommand.BtextClick(Sender: TObject);
begin
  if assigned(showEdit) then showEdit;
end;

procedure TPgCommand.MessageEndExecute(var message:Tmessage);
begin
  if message.wparam>0 then
    begin
      if assigned(MessageErreurPg) then MessageErreurPg(message.lparam);
    end
  else
  if not FhidePgPopUp then showPopUp;
end;

Initialization
AffDebug('Initialization compg1',0);
{$IFDEF FPC}
{$I compg1.lrs}
{$ENDIF}
end.
