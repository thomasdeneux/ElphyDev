unit fitProp;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  FuncProp, StdCtrls, editcont, Grids, ExtCtrls,

  util1,stmObj,stmvec1,Dcurfit0, debug0, Buttons,
  chooseOb;


type
  TFitProp1 = class(TFunctionProp)
    Label7: TLabel;
    CB1: TCheckBoxV;
    CB2: TCheckBoxV;
    CB3: TCheckBoxV;
    CB4: TCheckBoxV;
    CB5: TCheckBoxV;
    CB6: TCheckBoxV;
    CB7: TCheckBoxV;
    CB8: TCheckBoxV;
    GroupBox2: TGroupBox;
    LXstartFit: TLabel;
    enXStartFit: TeditNum;
    LXendFit: TLabel;
    enXEndFit: TeditNum;
    Label10: TLabel;
    enMaxNbpt: TeditNum;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    cbMode: TcomboBoxV;
    Label16: TLabel;
    enMaxIt: TeditNum;
    Label17: TLabel;
    enSeuil: TeditNum;
    CBinit: TCheckBox;
    Bexecute: TButton;
    LIstartFit: TLabel;
    enIstartFit: TeditNum;
    enIendFit: TeditNum;
    LIendFit: TLabel;
    cbUseIndices: TCheckBoxV;
    LYstartFit: TLabel;
    enYstartFit: TeditNum;
    LYendFit: TLabel;
    enYendFit: TeditNum;
    enXdata: TEdit;
    Bxdata: TBitBtn;
    enYdata: TEdit;
    Bydata: TBitBtn;
    enSigData: TEdit;
    BerrorData: TBitBtn;
    PanelCHI2: TPanel;
    Label9: TLabel;
    procedure BexecuteClick(Sender: TObject);
    procedure cbUseIndicesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BxdataClick(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
  private
    { Déclarations privées }
    CB:array[1..8] of TcheckBoxV;
    procedure updateVar;
    procedure setEnabled;
  protected
    procedure CheckNumVar;override;
  public
    { Déclarations publiques }

    procedure  init(owner:TypeUO);
    procedure update;

  end;


implementation

uses stmFit1;

{$R *.DFM}


procedure TfitProp1.updateVar;
var
  i:integer;
begin
  with Tfit(owner0).fitInfo do
  begin
    updateAllvar(self);
    initialize:=CBinit.checked;
  end;
end;

procedure TfitProp1.setEnabled;
begin
  with Tfit(owner0).fitInfo do
  begin
    enIstartFit.enabled:=useIndices;
    enIendFit.enabled:=useIndices;
    LIstartFit.enabled:=useIndices;
    LIendFit.enabled:=useIndices;

    enXstartFit.enabled:=not useIndices;
    enXendFit.enabled:=not useIndices;
    LXstartFit.enabled:=not useIndices;
    LXendFit.enabled:=not useIndices;
  end;
end;


procedure TfitProp1.init(owner:TypeUO);
var
  i:integer;
begin
  owner0:=owner;
  initBox;


  with Tfit(owner0),fitInfo do
  begin
    enXdata.Text:=uoIdent(fitX);
    enYdata.Text:=uoIdent(fitY);
    enSigdata.Text:=uoIdent(fitSigma);

    with cbMode do
    begin
      setStringArray(tabModeFit,11,9);
      setvar(Fitmode,t_smallint,1);
    end;

    enXStartFit.setVar(x1FTR,T_extended);
    enXEndFit.setVar(x2FTR,T_extended);

    enYStartFit.setVar(y1FTR,T_extended);
    enYEndFit.setVar(y2FTR,T_extended);

    enIStartFit.setVar(I1FTR,T_longint);
    enIEndFit.setVar(I2FTR,T_longint);

    cbUseIndices.setVar(UseIndices);

    enMaxNbpt.setvar(FitNbptMax,t_longint);
    enMaxNbpt.setMinMax(2,100000);

    enMaxIt.setvar(maxIt,t_smallint);
    enMaxIt.setMinMax(1,32767);

    enSeuil.setVar(Fitseuil,t_smallint);
    enSeuil.setMinMax(1,100);

    CBinit.checked:=initialize;

    setEnabled;

    for i:=1 to 8 do
      CB[i].setvar(FitParaCl[drawgrid1.TopRow+i]);

    PanelCHI2.Caption:=Estr(FitChiSqr,6);  
  end;

end;

procedure TFitProp1.BexecuteClick(Sender: TObject);
begin
  BcompileClick(self);

  updateVar;

  Tfit(owner0).executeFit;

  drawgrid1.invalidate;
  PanelCHI2.Caption:=Estr(Tfit(owner0).FitChiSqr,6);
end;

procedure TFitProp1.cbUseIndicesClick(Sender: TObject);
begin
  cbUseIndices.updateVar;
  setEnabled;
end;

procedure TFitProp1.CheckNumVar;
var
  i:integer;
begin
  inherited;

  with Tfit(owner0).FitInfo do
  begin
    for i:=1 to 8 do
      CB[i].setvar(FitParaCl[drawgrid1.TopRow+i]);
  end;
end;

procedure TFitProp1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  inherited;

  CB[1]:=CB1;
  CB[2]:=CB2;
  CB[3]:=CB3;
  CB[4]:=CB4;
  CB[5]:=CB5;
  CB[6]:=CB6;
  CB[7]:=CB7;
  CB[8]:=CB8;

end;

procedure TFitProp1.BxdataClick(Sender: TObject);
var
  ob:TypeUO;
begin
  with Tfit(owner0).FitInfo do
  case Tbutton(sender).tag of
    1: ob:=fitX;
    2: ob:=fitY;
    3: ob:=fitSigma;
  end;

  chooseObject.caption:='Choose a vector';
  with Tfit(owner0).FitInfo do
  if chooseObject.execution(Tvector,ob) then
    case Tbutton(sender).tag of
      1: begin
           owner0.derefObjet(typeUO(FitX));
           fitX:=Tvector(ob);
           owner0.refObjet(fitX);
           enXdata.Text:=uoIdent(fitX);
         end;
      2: begin
           owner0.derefObjet(typeUO(FitY));
           fitY:=Tvector(ob);
           owner0.refObjet(fitY);
           enYdata.Text:=uoIdent(fitY);
         end;
      3: begin
           owner0.derefObjet(typeUO(FitSigma));
           fitSigma:=Tvector(ob);
           owner0.refObjet(fitSigma);
           enSigdata.Text:=uoIdent(fitSigma);
         end;
    end;
end;

procedure TFitProp1.FormDeactivate(Sender: TObject);
begin
  inherited;
  updatevar;
end;

procedure TFitProp1.update;
var
  i:integer;
begin
  updateAllCtrl(self);
  initBox;

  with Tfit(owner0).fitInfo do
  begin
    enXdata.Text:=uoIdent(fitX);
    enYdata.Text:=uoIdent(fitY);
    enSigdata.Text:=uoIdent(fitSigma);

    CBinit.checked:=initialize;

    setEnabled;

    for i:=1 to 8 do
      CB[i].setvar(FitParaCl[drawgrid1.TopRow+i]);

    PanelCHI2.Caption:=Estr(Tfit(owner0).FitChiSqr,6);
  end;
end;

Initialization
AffDebug('Initialization fitProp',0);
{$IFDEF FPC}
{$I fitProp.lrs}
{$ENDIF}
end.
