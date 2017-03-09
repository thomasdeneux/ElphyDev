unit DrawFile1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,

  util1,stmDef,stmObj,stmdf0, debug0;

type
  TRedrawFile = class(TForm)
    Label1: TLabel;
    enFirst: TeditNum;
    enLast: TeditNum;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Bauto: TButton;
    cbClearCtrl: TCheckBoxV;
    cbFastMode: TCheckBoxV;
    procedure BautoClick(Sender: TObject);
  private
    { Private declarations }
    fx:pointer;
    nbmax:integer;
  public
    { Public declarations }
    procedure init(p:pointer);
  end;

function RedrawFile: TRedrawFile;

implementation

uses {$IFDEF DX11} FxCtrlDX11 {$ELSE} FxCtrlDX9  {$ENDIF} ;

{$R *.DFM} 
var
  FRedrawFile: TRedrawFile;

function RedrawFile: TRedrawFile;
begin
  if not assigned(FRedrawFile) then FRedrawFile:= TRedrawFile.create(nil);
  result:= FRedrawFile;
end;
procedure TRedrawFile.init(p:pointer);
begin
  fx:=p;

  with TFXcontrol(fx) do
  begin
    nbmax:=TdataFile(dacDataFile).EpCount;
    if (DrawFirst<1) or (DrawFirst>nbmax) or (DrawLast<1) or (DrawLast>nbmax) then
      begin
        DrawFirst:=1;
        DrawLast:=nbmax;
      end;

    enFirst.setvar(DrawFirst,t_longint);
    enFirst.setminmax(1,maxEntierLong);

    enLast.setvar(DrawLast,t_longint);
    enLast.setminmax(1,maxEntierLong);

    cbClearCtrl.setVar(DrawClear);
    cbFastMode.setVar(DrawFast);

  end;
end;

procedure TRedrawFile.BautoClick(Sender: TObject);
begin
  with TFXcontrol(fx) do
  begin
    DrawFirst:=1;
    DrawLast:=nbMax;
    updateAllCtrl(self);
  end;
end;

Initialization
AffDebug('Initialization DrawFile1',0);
{$IFDEF FPC}
{$I DrawFile1.lrs}
{$ENDIF}
end.
