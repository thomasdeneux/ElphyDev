unit iniDet1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,

  util1,stmObj,stmvec1, ExtCtrls;

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

  TDetectPanel = class(TForm)
    Label1: TLabel;
    CBsource: TComboBox;
    Label4: TLabel;
    ENheight: TeditNum;
    Label5: TLabel;
    ENlength: TeditNum;
    Label2: TLabel;
    cbMode: TcomboBoxV;
    Label6: TLabel;
    enXstart: TeditNum;
    Label7: TLabel;
    enXend: TeditNum;
    Bexecute: TButton;
    Bautoscale: TButton;
    PnbDet: TPanel;
    Label3: TLabel;
    enInhib: TeditNum;
    cbStepOption: TCheckBoxV;
    procedure BexecuteClick(Sender: TObject);
    procedure CBsourceDropDown(Sender: TObject);
    procedure CBsourceChange(Sender: TObject);
    procedure BautoscaleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbModeChange(Sender: TObject);
  private
    { Déclarations privées }
    owner0:typeUO;
    adInfo:^TinfoDetect;
    adSource:^Tvector;
  public
    { Déclarations publiques }
    executeD:procedure of object;
    nbDetectionD: function:integer of object;
    procedure installe(owner:typeUO;var info:TinfoDetect;var source:Tvector);

    procedure WMkillFocus (var message:TWMkillFocus );message WM_KillFocus;
  end;

var
  DetectPanel: TDetectPanel;

implementation

{$R *.DFM}

procedure TDetectPanel.installe(owner:typeUO;var info:TinfoDetect;var source:Tvector);
begin
  owner0:=owner;
  adInfo:=@info;
  adSource:=@source;
  with info do
  begin
    cbSource.items.clear;
    if assigned(source) then cbSource.items.add(source.ident);
    cbSource.itemIndex:=0;

    
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

  end;
end;

procedure TDetectPanel.BexecuteClick(Sender: TObject);
begin
  updateAllVar(self);
  ExecuteD;
end;

procedure TDetectPanel.CBsourceDropDown(Sender: TObject);
begin
  installeComboBox(CBsource,adSource^,Tvector);
end;

procedure TDetectPanel.CBsourceChange(Sender: TObject);
begin
  owner0.derefObjet(typeUO(adsource^));
  with CBsource do
  if (itemIndex>=0) and (itemIndex<items.count-1) then
    begin
      adsource^:=Tvector(items.objects[itemIndex]);
      owner0.refObjet(typeUO(adsource^));
    end
  else adsource^:=nil;


end;

procedure TDetectPanel.BautoscaleClick(Sender: TObject);
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

procedure TdetectPanel.WMkillFocus (var message:TWMkillFocus );
begin
  updateAllVar(self);
end;

procedure TDetectPanel.FormShow(Sender: TObject);
begin
  installe(owner0,adinfo^,adSource^);
end;

procedure TDetectPanel.cbModeChange(Sender: TObject);
begin
  with adInfo^ do
  cbStepOption.enabled:= (mode>=MDStepUp) and (mode<=MDStepUpDw);
end;

end.
