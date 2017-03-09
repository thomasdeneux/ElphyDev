unit VSSyncPrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  util1,stmdef,stmObj,Visusys1, StdCtrls, editcont;

type
  TGetVSsyncParam = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    enS1x: TeditNum;
    enS1y: TeditNum;
    Label2: TLabel;
    GroupBox3: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    enS2x: TeditNum;
    enS2y: TeditNum;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    enC1x: TeditNum;
    enC1y: TeditNum;
    GroupBox6: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    enC2x: TeditNum;
    enC2y: TeditNum;
    Button2: TButton;
    Button1: TButton;
    Label13: TLabel;
    enSpotSize: TeditNum;
    Label3: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure execute;
  end;


function GetVSsyncParam: TGetVSsyncParam;

implementation

{$R *.dfm}

var
  GetVSsyncParam0: TGetVSsyncParam;

function GetVSsyncParam: TGetVSsyncParam;
begin
  if not assigned(GetVSsyncParam0) then GetVSsyncParam0:= TGetVSsyncParam.Create(formStm);
  result:= GetVSsyncParam0;
end;

{ TGetVSsyncParam }

procedure TGetVSsyncParam.execute;
begin
  with VSsyncSpot[1] do
  begin
    enS1x.setVar(x,t_single);
    enS1y.setVar(y,t_single);
  end;
  with VSsyncSpot[2] do
  begin
    enS2x.setVar(x,t_single);
    enS2y.setVar(y,t_single);
  end;

  with VScontSpot[1] do
  begin
    enC1x.setVar(x,t_single);
    enC1y.setVar(y,t_single);
  end;
  with VScontSpot[2] do
  begin
    enC2x.setVar(x,t_single);
    enC2y.setVar(y,t_single);
  end;

  enSpotSize.setVar(VSspotSize,t_single);

  if showModal=mrOK then updateAllvar(self);
end;

end.
