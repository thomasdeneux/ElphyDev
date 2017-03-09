unit stmcooX1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, editcont, Buttons,
  debug0, util1;

type
  TFastCoo = class(TForm)
    PanelX: TPanel;
    Lxmin: TLabel;
    Lxmax: TLabel;
    SBposX: TscrollbarV;
    SBrangeX: TscrollbarV;
    PanelY: TPanel;
    LYmax: TLabel;
    LYmin: TLabel;
    SBrangeY: TscrollbarV;
    SBposY: TscrollbarV;
    BcadrerX: TBitBtn;
    bcadrerY: TBitBtn;
    Blevel: TBitBtn;
    procedure SBposXContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure adjustSize(w,h:integer);
    procedure reset;
  end;

function FastCoo: TFastCoo;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FFastCoo: TFastCoo;

function FastCoo: TFastCoo;
begin
  if not assigned(FFastCoo) then
  begin
    FFastCoo:= TFastCoo.create(nil);
    setVCLdef(FFastCoo);
  end;
  result:= FFastCoo;
end;

procedure TFastCoo.adjustSize(w,h:integer);
begin

end;

procedure TFastCoo.reset;
begin
  panelX.parent:=self;
  sbPosX.OnScrollV:=nil;
  sbRangeX.OnScrollV:=nil;

  panelY.parent:=self;
  sbPosY.OnScrollV:=nil;
  sbRangeY.OnScrollV:=nil;

  bCadrerX.onClick:=nil;
  bCadrerY.onClick:=nil;

end;

procedure TFastCoo.SBposXContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin
  Handled:=true;
end;

Initialization
AffDebug('Initialization stmcooX1',0);
{$IFDEF FPC}
{$I stmcooX1.lrs}
{$ENDIF}
end.
