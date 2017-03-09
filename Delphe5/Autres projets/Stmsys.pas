unit Stmsys;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls,

  util1,editcont,stmdef;

type
  TSysDialog = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    GroupBox1: TGroupBox;
    RadioButtonV1: TRadioButtonV;
    RadioButtonV2: TRadioButtonV;
    Label1: TLabel;
    editString1: TeditString;
    RadioButtonV3: TRadioButtonV;
  private
    { Déclarations private }
    stAd:string[10];
  public
    { Déclarations public }
    procedure execution;
  end;

var
  SysDialog: TSysDialog;

implementation

{$R *.DFM}

procedure TSysDialog.execution;
  var
    v:longint;
  begin
    stAd:=hexa(BaseAddress);
    RadioButtonV1.setvar(CarteAcq,1);
    RadioButtonV2.setvar(CarteAcq,2);
    RadioButtonV3.setvar(CarteAcq,3);
    
    editString1.setvar(stAd,10);
    if showModal=mrOK then
      begin
        updateAllVar(self);
        v:=hexaToLong(stAd);
        if v<>-1 then BaseAddress:=v;
      end;
  end;

end.
