unit Tpmat;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, ExtCtrls, StdCtrls,

  util1, Buttons, Menus, stmObj,Dpalette;

type
  TpaintMatrix = class(TForm)
    PaintBox1: TPaintBox;
    Panel1: TPanel;
    SBlmin: TScrollBar;
    Panel2: TPanel;
    PLmin: TPanel;
    Panel4: TPanel;
    Plmax: TPanel;
    SBLmax: TScrollBar;
    Panel6: TPanel;
    Pgamma: TPanel;
    SBgamma: TScrollBar;
    BitBtn1: TBitBtn;
    procedure SBlminChange(Sender: TObject);
    procedure SBLmaxChange(Sender: TObject);
    procedure SBgammaChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure WMQueryNewPalette(var message:TWMQueryNewPalette);message WM_QueryNewPalette;
    procedure WMPALETTECHANGED (var message:TWMPALETTECHANGED );message WM_PALETTECHANGED;

  public
    { Déclarations public }
    uo:typeUO;
    extra:procedure of object;
    recupParam:procedure(lmin,lmax,gamma:integer) of object;
    procedure setParam(Lmin,Lmax,gamma,rmin,rmax:integer);

  end;

var
  paintMatrix: TpaintMatrix;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TpaintMatrix.setParam(Lmin,Lmax,gamma,rmin,rmax:integer);
  begin
    pLmin.caption:=Istr(Lmin);
    pLmax.caption:=Istr(Lmax);
    pgamma.caption:=Estr(gamma/10,2);

    SBLmin.setParams(Lmin,-rmin,rmin);
    SBLmax.setParams(Lmax,-rmax,rmax);
    SBgamma.setParams(gamma,1,50);
  end;

procedure TpaintMatrix.SBlminChange(Sender: TObject);
begin
  pLmin.caption:=Istr(SBLmin.position);
  if assigned(recupParam)
    then recupParam(SBLmin.position,SBLmax.position,SBgamma.position);

  onpaint(Self);
end;

procedure TpaintMatrix.SBLmaxChange(Sender: TObject);
begin
  pLmax.caption:=Istr(SBLmax.position);
  if assigned(recupParam)
    then recupParam(SBLmin.position,SBLmax.position,SBgamma.position);

  onpaint(Self);
end;

procedure TpaintMatrix.SBgammaChange(Sender: TObject);
begin
  pgamma.caption:=Estr(SBgamma.position/10,2);
  if assigned(recupParam)
    then recupParam(SBLmin.position,SBLmax.position,SBgamma.position);

  onpaint(Self);
end;

procedure TpaintMatrix.BitBtn1Click(Sender: TObject);
begin
  If assigned(extra) then
    begin
      extra;
      onpaint(Self);
    end;
end;

procedure TpaintMatrix.PaintBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p:Tpoint;
begin
if assigned(uo) and (button=mbRight) then
  begin
    p:=clientToScreen(point(x,y));

    uo.WinMenu(p.x,p.y,1);
  end;
end;

procedure TpaintMatrix.WMQueryNewPalette(var message:TWMQueryNewPalette);
begin
  StmQueryNewPalette(self,paintbox1.canvas.handle,message);

end;

procedure TpaintMatrix.WMPALETTECHANGED (var message:TWMPALETTECHANGED );
begin
  StmPaletteChanged(self.handle,paintbox1.canvas.handle,message);
end;

Initialization
AffDebug('Initialization Tpmat',0);
{$IFDEF FPC}
{$I Tpmat.lrs}
{$ENDIF}
end.
