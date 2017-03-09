unit Detform1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TPform0, Menus, ExtCtrls,StdCtrls, editcont, Buttons,
  util1,Dgraphic,stmObj,stmvec1,stmVzoom, debug0 ;


type
  TmodeDetect=(MDmax,MDmin,MDminMax,
               MDstepUp,MDstepDw,MDstepUpDw,
               MDcrossUp,MDcrossDw,MDcrossUpDw,
               MDslopeUp,MDslopeDw,MDslopeUpDw);
  TinfoDetect=
    record
      mode:TmodeDetect;
      l,h:double;
      Linhib:double;
      xstartD,xendD:double;
      StepOption:boolean;
    end;


type
  TDetPanel = class(TPform)
    Panel1: TPanel;
    Label6: TLabel;
    enXstart: TeditNum;
    enXend: TeditNum;
    Label7: TLabel;
    Bautoscale: TButton;
    Label2: TLabel;
    cbMode: TcomboBoxV;
    Label4: TLabel;
    ENheight: TeditNum;
    Label5: TLabel;
    ENlength: TeditNum;
    Label3: TLabel;
    enInhib: TeditNum;
    cbStepOption: TCheckBoxV;
    Bexecute: TButton;
    PnbDet: TPanel;
    Pnum: TPanel;
    sbNum: TscrollbarV;
    cbHold: TCheckBoxV;
    ShapeExe: TShape;
    EditSource: TEdit;
    Label1: TLabel;
    Bchoose: TBitBtn;
    procedure BautoscaleClick(Sender: TObject);
    procedure BexecuteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbNumScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure cbHoldClick(Sender: TObject);
    procedure BchooseClick(Sender: TObject);
  protected
    { Déclarations privées }
    owner0:typeUO;
    adInfo:^TinfoDetect;
    adSource:^Tvector;
    Zoom0:TimageVector;

    NumEv:integer;
    procedure PaintLines;

  public
    { Déclarations publiques }
    executeD:procedure of object;
    nbDetectionD: function:integer of object;


    procedure installe(owner:typeUO;var info:TinfoDetect;var source:Tvector;zoom:TimageVector);

    procedure WMkillFocus (var message:TWMkillFocus );message WM_KillFocus;
  end;

function DetPanel: TDetPanel;

implementation

uses chooseOb,stmDet1;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FDetPanel: TDetPanel;

function DetPanel: TDetPanel;
begin
  if not assigned(FDetPanel) then FDetPanel:= TDetPanel.create(nil);
  result:= FDetPanel;
end;



procedure TDetPanel.installe(owner:typeUO;var info:TinfoDetect;var source:Tvector;
                               zoom:TimageVector);
begin
  owner0:=owner;
  adInfo:=@info;
  adSource:=@source;
  Zoom0:=zoom;
  with info do
  begin
    if assigned(source)
      then EditSource.Text:= source.ident
      else EditSource.Text:='';

    cbMode.setString('maxima|'+
                     'minima|'+
                     'maxima and minima|'+
                     'steps up|'+
                     'steps dw|'+
                     'steps up and dw|'+
                     'crossings up|'+
                     'crossings dw|'+
                     'crossings up and dw|'+
                     'slopes up|'+
                     'slopes dw|'+
                     'slopes up and dw'
                     );
    cbMode.setvar(mode,t_byte,0);

    enHeight.setvar(h,t_double);
    enHeight.decimal:=6;

    enLength.setvar(l,t_double);
    enLength.setminmax(0,1E100);
    enLength.decimal:=6;

    enInhib.setvar(linhib,t_double);
    enInhib.setminmax(0,1E100);
    enInhib.decimal:=6;

    enXstart.setvar(XstartD,t_double);
    enXend.setvar(XendD,t_double);

    Pnbdet.caption:='N='+Istr(nbDetectionD);

    cbStepOption.setvar(StepOption);
    cbStepOption.enabled:= (mode>=MDStepUp) and (mode<=MDStepUpDw);

    sbNum.setParams(NumEv,1,nbDetectionD);
    cbHold.setVar(HoldMode);
  end;
end;


procedure TdetPanel.WMkillFocus (var message:TWMkillFocus );
begin
  updateAllVar(self);
end;

procedure TDetPanel.BautoscaleClick(Sender: TObject);
begin
  if assigned(adSource^) then
    with adinfo^ do
    begin
      XstartD:=adSource^.Xstart;
      XendD:=adSource^.Xend;

      enXstart.updateCtrl;
      enXend.updateCtrl;
    end;
end;

procedure TDetPanel.BexecuteClick(Sender: TObject);
begin
  updateAllVar(self);
  ExecuteD;
  sbNum.setParams(NumEv,1,nbDetectionD);
  sbNumScrollV(self,1,scBottom);
end;

procedure TDetPanel.FormShow(Sender: TObject);
begin
  installe(owner0,adinfo^,adSource^,zoom0);
  onBMpaint:=PaintLines;
end;

procedure TdetPanel.PaintLines;
begin
  if not assigned(zoom0) then exit;
  with canvasGlb do
  begin
    pen.color:=clBlack;
    pen.style:=psSolid;
    mainWindow;
    with zoom0.getInsideWindow do
    begin
      setWindow(left,top,right,bottom);
      moveto((left+right) div 2,top);
      lineto((left+right) div 2,bottom);
    end;
  end;
end;

procedure TDetPanel.sbNumScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
var
  delta,x1,x2:float;
begin
  if not assigned(zoom0) or (nbDetectionD<1) then exit;

  NumEv:=round(x);

  with Tdetect(owner0).Vevent do
  begin
    if (numEv<Istart) or (numEv>Iend) then exit;
    x:=Yvalue[numEv];
  end;

  Pnum.Caption:=Istr(numEv);

  with Zoom0 do
  begin
    delta:=(Xmax-Xmin)/2;
    X1:=x-delta;
    X2:=x+delta;
    if (x1<>Xmin) or (x2<>Xmax) then
      begin
        Xmin:=x1;
        Xmax:=x2;

        Tdetect(owner0).ChangeCursors(numEv);
        invalidate;
      end;
  end;


end;

procedure TDetPanel.cbHoldClick(Sender: TObject);
begin
  if HoldMode then HoldFirst:=true;
  sbNumScrollV(self,NumEv,scBottom);

  Tdetect(owner0).Vzoom.invalidate;
end;

procedure TDetPanel.BchooseClick(Sender: TObject);
var
  OldSource:typeUO;
begin
  OldSource:=adSource^;

  chooseObject.caption:='Choose a vector';
  if chooseObject.execution(Tvector,typeUO(adsource^)) then
  begin
    owner0.derefObjet(typeUO(Oldsource));
    owner0.refObjet(typeUO(adsource^));

    if assigned(adsource^)
      then EditSource.Text:= adsource^.ident
      else EditSource.Text:='';

    zoom0.installSource(adSource^);
    paintBox0.Invalidate;
  end;

end;

Initialization
AffDebug('Initialization Detform1',0);
{$IFDEF FPC}
{$I Detform1.lrs}
{$ENDIF}
end.
