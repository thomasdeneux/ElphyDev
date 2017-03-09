unit WdetDlg1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, EditScroll1,editcont,

  util1, colorPan1,
  stmdef,stmObj,stmWinCur;

type
  TWindetectDlg = class(TForm)
    edsX: TEditScroll;
    edsY: TEditScroll;
    edsH: TEditScroll;
    cpColor: TcolorPan;
    cbActive: TCheckBoxV;
    BOK: TButton;
    procedure cbActiveClick(Sender: TObject);
  private
    { Déclarations privées }
     x,y,h:float;
     col:integer;
     vis:boolean;

     wincur0:Twincur;

     procedure changeXYH;
  public
    { Déclarations publiques }
    procedure execution(wincur:Twincur);

  end;

function WindetectDlg: TWindetectDlg;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FWindetectDlg: TWindetectDlg;

function WindetectDlg: TWindetectDlg;
begin
  if not assigned(FWindetectDlg) then FWindetectDlg:= TWindetectDlg.create(nil);
  result:= FWindetectDlg;
end;

procedure TWindetectDlg.changeXYH;
begin
  with wincur0 do
  begin
    position[0]:=Rpoint(x,y);
    position[1]:=Rpoint(x,y+h);
    color:=col;
    visible:=vis;
  end;
end;

procedure TWindetectDlg.execution(wincur:Twincur);
var
  smallDx,smallDy:float;
begin
  wincur0:=wincur;
  with wincur do
  begin
    x:=position[0].x;
    y:=position[0].y;
    h:=position[1].y-position[0].y;

    edsx.init(x,t_extended,obref.Xstart,obref.Xend,3);
    edsy.init(y,t_extended,-1E5,1E5,3);
    edsh.init(h,t_extended,-1E5,1E5,3);

    edsx.onChange:=changeXYH;
    edsy.onChange:=changeXYH;
    edsh.onChange:=changeXYH;

    smallDx:=minP10(obref.Xmax-obref.Xmin)/10;
    smallDy:=minP10(obref.Ymax-obref.Ymin)/10;

    edsx.sb.dxSmall:=smallDx;
    edsx.sb.dxLarge:=smallDx*10;
    edsy.sb.dxSmall:=smallDy;
    edsy.sb.dxLarge:=smallDy*10;
    edsh.sb.dxSmall:=smallDy;
    edsh.sb.dxLarge:=smallDy*10;

    col:=color;
    cpColor.init(col,true);
    cpcolor.onChange:=changeXYH;

    vis:=visible;
    cbActive.setVar(vis);
  end;

  showModal;
  updateAllVar(self);
end;

procedure TWindetectDlg.cbActiveClick(Sender: TObject);
begin
  cbActive.updateVar;
  changeXYH;
end;

Initialization
AffDebug('Initialization WdetDlg1',0);
{$IFDEF FPC}
{$I WdetDlg1.lrs}
{$ENDIF}
end.
