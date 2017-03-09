unit MfitProp;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MFProp, StdCtrls, editcont, Grids, ExtCtrls,

  util1,stmObj,stmMat1,Dcur2fit,Darbre0, Debug0,
  stmMF1,stmMfit1;


type
  TMFitProp1 = class(TMFuncProp)
    GroupBox2: TGroupBox;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    CBdata: TcomboBoxV;
    cbSigdata: TcomboBoxV;
    cbMode: TcomboBoxV;
    enMaxIt: TeditNum;
    enSeuil: TeditNum;
    CBinit: TCheckBox;
    cbUseSelection: TCheckBoxV;
    GroupBox3: TGroupBox;
    Bchi2: TButton;
    Lchi2: TLabel;
    Button5: TButton;
    procedure BexecuteClick(Sender: TObject);
    procedure Bchi2Click(Sender: TObject);
  private
    procedure updateVars;
  public
    { Déclarations publiques }

    function execution(owner:TmatFit):boolean;

  end;


function MFitProp1: TMFitProp1;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FMFitProp1: TMFitProp1;

function MFitProp1: TMFitProp1;
begin
  if not assigned(FMFitProp1) then FMFitProp1:= TMFitProp1.create(nil);
  result:= FMFitProp1;
end;

procedure TMfitProp1.updateVars;
begin
  inherited updateVars;

  with TmatFit(owner0).fitInfo do
  begin
    initialize:=CBinit.checked;

    with CBdata do
    if (itemIndex>=0) and (itemIndex<items.count-1) then
      begin
        owner0.derefObjet(typeUO(FitM));
        fitM:=Tmatrix(items.objects[itemIndex]);
        owner0.refObjet(fitM);
      end
    else fitM:=nil;

    with CBsigdata do
    if (itemIndex>=0) and (itemIndex<items.count-1) then
      begin
        owner0.derefObjet(typeUO(FitSigma));
        fitSigma:=Tmatrix(items.objects[itemIndex]);
        owner0.refObjet(fitSigma);
      end
    else fitSigma:=nil;

  end;
end;



function TMfitProp1.execution(owner:TmatFit):boolean;
begin
  owner0:=owner;
  inherited initBox(Tmatfunction(owner));

  with TmatFit(owner0).fitInfo do
  begin
    installeComboBox(cbdata,fitM,Tmatrix);
    installeComboBox(cbSigData,fitSigma,Tmatrix);

    with cbMode do
    begin
      setStringArray(tabModeFit,11,9);
      setvar(Fitmode,t_smallint,1);
    end;

    cbUseSelection.setVar(UseSelect);

    enMaxIt.setvar(maxIt,t_smallint);
    enSeuil.setVar(Fitseuil,t_smallint);
    CBinit.checked:=initialize;

    showModal;

    updatevars;
  end;

end;

function FloatString(w:float;n:integer):AnsiString;
begin
  result:=Estr(w,n);
end;

procedure TMFitProp1.BexecuteClick(Sender: TObject);
begin
  BvalidateClick(self);

  updateVars;
  {messageCentral('UpdateVar');}
  with TmatFit(owner0) do
  begin
    executeFit;
    Lchi2.caption:=FloatString(getChi2,6);
  end;
  drawgrid1.invalidate;
end;


procedure TMFitProp1.Bchi2Click(Sender: TObject);
begin
  BvalidateClick(self);

  with TmatFit(owner0) do
  begin
    updateVars;
    {messageCentral('UpdateVar');}
    Lchi2.caption:=FloatString(getChi2,6);
  end;

end;

Initialization
AffDebug('Initialization MfitProp',0);
{$IFDEF FPC}
{$I MfitProp.lrs}
{$ENDIF}
end.
