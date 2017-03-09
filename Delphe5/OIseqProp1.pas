unit OIseqProp1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs,
  stmOIseq1, StdCtrls, editcont;

type
  TOIseqProp = class(TForm)
    GroupBox6: TGroupBox;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    enI1: TeditNum;
    enX1: TeditNum;
    enI2: TeditNum;
    enX2: TeditNum;
    esUnitX: TeditString;
    Bok: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    enJ1: TeditNum;
    enY1: TeditNum;
    enJ2: TeditNum;
    enY2: TeditNum;
    esUnitY: TeditString;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function getParams(var p: TOIscaleProp): boolean;
  end;


function OIseqProp: TOIseqProp;

implementation

{$R *.dfm}

{ TOIseqProp }

var
  FOIseqProp: TOIseqProp;

function OIseqProp: TOIseqProp;
begin
  if not assigned(FOIseqProp) then FOIseqProp:= TOIseqProp.Create(nil);
  result:=FOIseqProp;
end;

function TOIseqProp.getParams(var p: TOIscaleProp): boolean;
begin
  with p do
  begin
    esUnitX.setvar(unitX,sizeof(unitX)-1);
    enI1.setvar(i1,T_longint);
    enI2.setvar(i2,T_longint);
    enX1.setvar(X1,T_single);
    enX2.setvar(X2,T_single);

    esUnitY.setvar(unitY,sizeof(unitY)-1);
    enJ1.setvar(j1,T_longint);
    enJ2.setvar(j2,T_longint);
    enY1.setvar(Y1,T_single);
    enY2.setvar(Y2,T_single);
  end;

  result:=(showModal=mrOK);
  if result then  updateAllVar(self);
end;

end.
