unit RepFile1;

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

  util1,DdosFich,descElphy1, debug0;

type
  TReplayFile = class(TForm)
    GroupBox1: TGroupBox;
    Bchoose: TButton;
    Lfile: TLabel;
    Label1: TLabel;
    enFirst: TeditNum;
    enLast: TeditNum;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    Bauto: TButton;
    procedure BchooseClick(Sender: TObject);
    procedure BautoClick(Sender: TObject);
  private
    { Private declarations }
    fx:pointer;
    nbmax:integer;
  public
    { Public declarations }
    procedure init(p:pointer);
  end;

function ReplayFile: TReplayFile;

implementation

uses {$IFDEF DX11} {$ELSE} FxCtrlDX9  {$ENDIF};

{$R *.DFM} 
var
  FReplayFile: TReplayFile;

function ReplayFile: TReplayFile;
begin
  if not assigned(FReplayFile) then FReplayFile:= TReplayFile.create(nil);
  result:= FReplayFile;
end;
procedure TReplayFile.init(p:pointer);
var
  desc:TelphyDescriptor;
begin
  fx:=p;

  with TFXcontrol(fx) do
  begin
    desc:=TelphyDescriptor.create;
    if desc.init(repFileName) then
      begin
        nbMax:=desc.nbSeqDat;
        Lfile.caption:=extractFileName(repFileName);
        if (RepFirst<1) or (RepFirst>nbmax) or (RepLast<1) or (RepLast>nbmax) then
          begin
            RepFirst:=1;
            RepLast:=nbmax;
          end;
      end;
    desc.free;

    enFirst.setvar(RepFirst,t_longint);
    enFirst.setminmax(1,maxEntierLong);

    enLast.setvar(RepLast,t_longint);
    enLast.setminmax(1,maxEntierLong);

  end;
end;

procedure TReplayFile.BchooseClick(Sender: TObject);
var
  st:AnsiString;
  desc:TelphyDescriptor;
begin
  st:=GchooseFile('Choose a data file',TFXcontrol(fx).repFileName);
  if st<>'' then
    begin
      desc:=TelphyDescriptor.create;
      if desc.init(st) then
        begin
          nbMax:=desc.nbSeqDat;

          TFXcontrol(fx).repFileName:=st;
          Lfile.caption:=extractFileName(st);
        end;
      desc.free;
    end;

end;

procedure TReplayFile.BautoClick(Sender: TObject);
begin
  with TFXcontrol(fx) do
  begin
    repFirst:=1;
    repLast:=nbMax;
    updateAllCtrl(self);
  end;
end;

Initialization
AffDebug('Initialization repFile1',0);
{$IFDEF FPC}
{$I RepFile1.lrs}
{$ENDIF}
end.
