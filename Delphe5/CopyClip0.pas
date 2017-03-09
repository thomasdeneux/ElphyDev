unit CopyClip0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  editcont, StdCtrls, ExtCtrls,

  util1,Dgraphic, debug0;

type
  TCopyClip = class(TForm)
    C_cancel: TButton;
    CBbitmap: TCheckBoxV;
    CBmono: TCheckBoxV;
    CBwhiteBK: TCheckBoxV;
    Bcopy: TButton;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    enMagFactor: TeditNum;
    enSymbFactor: TeditNum;
    cbAutoSymb: TCheckBoxV;
    cbAutoFont: TCheckBoxV;
    cbSplitMat: TCheckBoxV;
    procedure cbAutoFontClick(Sender: TObject);
    procedure cbAutoSymbClick(Sender: TObject);
  private
    { Private declarations }
    procedure setAutoSymb;
    procedure setAutoFont;

  public
    { Public declarations }
    function execution:boolean;
  end;

function CopyClip: TCopyClip;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FCopyClip: TCopyClip;

function CopyClip: TCopyClip;
begin
  if not assigned(FCopyClip) then FCopyClip:= TCopyClip.create(nil);
  result:= FCopyClip;
end;

procedure TcopyClip.setAutoSymb;
begin
  enSymbFactor.enabled:=not PRautoSymb;
end;

procedure TcopyClip.setAutoFont;
begin
  enMagFactor.enabled:=not PRautoFont;
end;


function TcopyClip.execution:boolean;
begin
  CBbitmap.setvar(PRdraft);
  CBwhiteBK.setvar(PRwhiteBackGnd);
  CBmono.setvar(PRmonochrome);

  enMagFactor.setVar(PRfontMag,t_single);
  enMagFactor.setMinMax(0.2,5);

  enSymbFactor.setVar(PRSymbMag,t_single);
  enSymbFactor.setMinMax(1,20);

  cbAutoSymb.setvar(PRautoSymb);

  cbAutoFont.setvar(PRautoFont);
  cbSplitMat.setvar(PRsplitMatrix);

  setAutoSymb;
  setAutoFont;

  result:=(showModal=mrOK);
  if result then updateAllVar(self);
end;



procedure TcopyClip.cbAutoSymbClick(Sender: TObject);
begin
  cbAutoSymb.updateVar;
  setAutoSymb;
end;

procedure TcopyClip.cbAutoFontClick(Sender: TObject);
begin
  cbAutoFont.updateVar;
  setAutoFont;
end;



Initialization
AffDebug('Initialization CopyClip0',0);
{$IFDEF FPC}
{$I CopyClip0.lrs}
{$ENDIF}
end.
