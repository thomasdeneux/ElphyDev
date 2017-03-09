unit getBmp0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, Buttons,

  Gdos,DdosFich,debug0;

type
  TinitImagePlot = class(TForm)
    GroupBox1: TGroupBox;
    Lfile: TLabel;
    Button1: TButton;
    Button2: TButton;
    BitBtn1: TBitBtn;
    cbPavage: TCheckBoxV;
    cbStretch: TCheckBoxV;
    cbAspectRatio: TCheckBoxV;
    procedure BloadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    stgen:AnsiString;

  public
    { Déclarations publiques }
    function execution(title:AnsiString;var stF:AnsiString;var paver,etaler,keepRatio:boolean):boolean;
  end;

function initImagePlot: TinitImagePlot;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FinitImagePlot: TinitImagePlot;

function initImagePlot: TinitImagePlot;
begin
  if not assigned(FinitImagePlot) then FinitImagePlot:= TinitImagePlot.create(nil);
  result:= FinitImagePlot;
end;


function TinitImagePlot.execution
            (title:AnsiString;var stF:AnsiString;var paver,etaler,keepRatio:boolean):boolean;
begin
  caption:=title;
  Lfile.caption:=stF;
  cbPavage.setvar(paver);
  cbStretch.setvar(etaler);
  cbAspectRatio.setvar(keepRatio);

  result:=(showModal=mrOK);
  if result then
    begin
      updateAllvar(self);
      stF:=Lfile.caption;
    end;
end;


procedure TinitImagePlot.BloadClick(Sender: TObject);
var
  st:AnsiString;
const
  stFiltre='*.bmp|*.bmp|*.jpg|*.jpg';
  Ifiltre:integer=1;
begin
  st:=Lfile.caption;
  if choixFichierStandard1(stGen,st,stFiltre,Ifiltre) then
    begin
      Lfile.caption:=st;
    end;

end;

procedure TinitImagePlot.FormCreate(Sender: TObject);
begin
  stgen:='*.bmp';
end;

Initialization
AffDebug('Initialization getBmp0',0);
{$IFDEF FPC}
{$I getBmp0.lrs}
{$ENDIF}
end.
