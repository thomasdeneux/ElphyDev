unit NIRTdlg1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, editcont, ComCtrls,
  RTneuronBrd, debug0;

type
  TNIRTparams = class(TForm)
    GroupBox1: TGroupBox;
    TabNumAdc: TTabControl;
    GroupBox6: TGroupBox;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    enJ1: TeditNum;
    enY1: TeditNum;
    enJ2: TeditNum;
    enY2: TeditNum;
    esUnits: TeditString;
    Label23: TLabel;
    esAdcSymbol: TeditString;
    GroupBox2: TGroupBox;
    TabNumDac: TTabControl;
    Label2: TLabel;
    GroupBox3: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    enDacJ1: TeditNum;
    enDacY1: TeditNum;
    enDacJ2: TeditNum;
    enDacY2: TeditNum;
    esDacUnits: TeditString;
    esDacSymbol: TeditString;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label12: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    esDigiSymbol0: TeditString;
    BdigiSymbol0: TBitBtn;
    Panel4: TPanel;
    cbDig0: TcheckBoxV;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    esDigiSymbol1: TeditString;
    BdigiSymbol1: TBitBtn;
    Panel8: TPanel;
    cbDig1: TcheckBoxV;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    esDigiSymbol2: TeditString;
    BdigiSymbol2: TBitBtn;
    Panel12: TPanel;
    cbDig2: TcheckBoxV;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    esDigiSymbol3: TeditString;
    BdigiSymbol3: TBitBtn;
    Panel16: TPanel;
    cbDig3: TcheckBoxV;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    esDigiSymbol4: TeditString;
    BdigiSymbol4: TBitBtn;
    Panel20: TPanel;
    cbDig4: TcheckBoxV;
    Panel21: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    esDigiSymbol5: TeditString;
    BdigiSymbol5: TBitBtn;
    Panel24: TPanel;
    cbDig5: TcheckBoxV;
    Panel25: TPanel;
    Panel26: TPanel;
    Panel27: TPanel;
    esDigiSymbol6: TeditString;
    BdigiSymbol6: TBitBtn;
    Panel28: TPanel;
    cbDig6: TcheckBoxV;
    Panel29: TPanel;
    Panel30: TPanel;
    Panel31: TPanel;
    esDigiSymbol7: TeditString;
    BdigiSymbol7: TBitBtn;
    Panel32: TPanel;
    cbDig7: TcheckBoxV;
    Label8: TLabel;
    Label9: TLabel;
    BadcSymbol: TBitBtn;
    BdacSymbol: TBitBtn;
    Bok: TButton;
    Bcancel: TButton;
    GroupBox5: TGroupBox;
    cbFadvance: TCheckBoxV;
    Label10: TLabel;
    enDacEnd: TeditNum;
    cbUseHoldingValue: TCheckBoxV;
    procedure BadcSymbolClick(Sender: TObject);
    procedure TabNumAdcChange(Sender: TObject);
    procedure TabNumDacChange(Sender: TObject);
  private
    { Déclarations privées }
    NiRT0:TRTparams;


    procedure setAdcVars;
    procedure setDacVars;
    procedure setDigiVars;


  public
    { Déclarations publiques }

    procedure execute(var rt:TRTparams);

  end;

function NIRTparams: TNIRTparams;

implementation

uses ChooseNrnName, AcqBrd1;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FNIRTparams: TNIRTparams;

function NIRTparams: TNIRTparams;
begin
  if not assigned(FNIRTparams) then FNIRTparams:= TNIRTparams.create(nil);
  result:= FNIRTparams;
end;

{ TNIRTparams }

procedure TNIRTparams.execute(var rt: TRTparams);
begin
  move(rt,NiRT0,sizeof(rt));

  setAdcVars;
  setDacVars;
  setDigiVars;
  cbFadvance.setVar(NiRT0.FadvanceON);

  if ShowModal=mrOK then
  begin
    updateAllVar(self);
    move(NiRT0,rt,sizeof(rt));
  end;

end;

procedure TNIRTparams.setAdcVars;
var
  num:integer;
begin
  num:= TabNumAdc.TabIndex;

  with NIRT0.AdcChan[num] do
  begin
    esUnits.setvar(unitY,sizeof(unitY)-1);

    enJ1.setvar(jru1,T_smallint);
    enJ2.setvar(jru2,T_smallint);

    enY1.setvar(Yru1,T_single);
    enY2.setvar(Yru2,T_single);

    esAdcSymbol.setVar(SymbName,64);

  end;

end;

procedure TNIRTparams.setDacVars;
var
  num:integer;
begin
  num:= TabNumDac.TabIndex;

  with NIRT0.DacChan[num] do
  begin
    esDacUnits.setvar(unitY,sizeof(unitY)-1);

    enDacJ1.setvar(jru1,T_smallint);
    enDacJ2.setvar(jru2,T_smallint);

    enDacY1.setvar(Yru1,T_single);
    enDacY2.setvar(Yru2,T_single);

    esDacSymbol.setVar(SymbName,64);
    enDacEnd.setVar(NIRT0.DacEndValue[num],t_double);
    cbUseHoldingValue.setvar(NIRT0.UseEndValue[num]);
  end;

end;

procedure TNIRTparams.setDigiVars;
begin
  with NIRT0 do
  begin
    esDigiSymbol0.setVar(DigiChan[0].SymbName,64);
    cbDig0.setVar(DigiChan[0].IsInput);
    cbDig0.Tag:=0;

    esDigiSymbol1.setVar(DigiChan[1].SymbName,64);
    cbDig1.setVar(DigiChan[1].IsInput);
    cbDig1.Tag:=1;

    esDigiSymbol2.setVar(DigiChan[2].SymbName,64);
    cbDig2.setVar(DigiChan[2].IsInput);
    cbDig2.Tag:=2;

    esDigiSymbol3.setVar(DigiChan[3].SymbName,64);
    cbDig3.setVar(DigiChan[3].IsInput);
    cbDig3.Tag:=3;

    esDigiSymbol4.setVar(DigiChan[4].SymbName,64);
    cbDig4.setVar(DigiChan[4].IsInput);
    cbDig4.Tag:=4;

    esDigiSymbol5.setVar(DigiChan[5].SymbName,64);
    cbDig5.setVar(DigiChan[5].IsInput);
    cbDig5.Tag:=5;

    esDigiSymbol6.setVar(DigiChan[6].SymbName,64);
    cbDig6.setVar(DigiChan[6].IsInput);
    cbDig6.Tag:=6;

    esDigiSymbol7.setVar(DigiChan[7].SymbName,64);
    cbDig7.setVar(DigiChan[7].IsInput);
    cbDig7.Tag:=7;
  end;

end;

procedure TNIRTparams.BadcSymbolClick(Sender: TObject);
var
  num:integer;
  st:AnsiString;

begin
  with NIRT0 do
  begin

    st:=ChooseNrnSym.Execute(board);
    if st<>'' then
    case Tbutton(sender).Tag of
      100: begin
             num:=tabNumAdc.tabIndex;
             AdcChan[num].SymbName:=st;
             esAdcSymbol.UpdateCtrl;
           end;

      200: begin
             num:=tabNumDac.tabIndex;
             DacChan[num].SymbName:=st;
             esDacSymbol.UpdateCtrl;
           end;

      else
           begin
             num:=Tbutton(sender).Tag;
             DigiChan[num].SymbName:=st;
             case num of
               0:  esDigiSymbol0.UpdateCtrl;
               1:  esDigiSymbol1.UpdateCtrl;
               2:  esDigiSymbol2.UpdateCtrl;
               3:  esDigiSymbol3.UpdateCtrl;
               4:  esDigiSymbol4.UpdateCtrl;
               5:  esDigiSymbol5.UpdateCtrl;
               6:  esDigiSymbol6.UpdateCtrl;
               7:  esDigiSymbol7.UpdateCtrl;
             end;
           end;

    end;
  end;



end;



procedure TNIRTparams.TabNumAdcChange(Sender: TObject);
begin
  updateAllVar(self);
  SetAdcVars;
end;

procedure TNIRTparams.TabNumDacChange(Sender: TObject);
begin
  updateAllVar(self);
  SetDacVars;
end;

Initialization
AffDebug('Initialization NIRTdlg1',0);
{$IFDEF FPC}
{$I NIRTdlg1.lrs}
{$ENDIF}
end.
