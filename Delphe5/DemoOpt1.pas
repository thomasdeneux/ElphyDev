unit DemoOpt1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont,
  DemoBrd1, debug0;

type
  TDemoOptions = class(TForm)
    cbTagStart: TCheckBoxV;
    BOK: TButton;
    Bcancel: TButton;
    cbModel: TcomboBoxV;
    enPeriod: TeditNum;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    enNoise: TeditNum;
    Label4: TLabel;
    enAmplitude: TeditNum;
    Label5: TLabel;
    enFreq: TeditNum;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure execution(p:pointer);
  end;

function DemoOptions: TDemoOptions;

implementation



{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FDemoOptions: TDemoOptions;

function DemoOptions: TDemoOptions;
begin
  if not assigned(FDemoOptions) then FDemoOptions:= TDemoOptions.create(nil);
  result:= FDemoOptions;
end;

{ TForm2 }

procedure TDemoOptions.execution(p: pointer);
begin
  with TdemoInterface(p) do
  begin
    cbTagStart.setVar(TDemoInterface(p).FuseTagStart);
    cbModel.setString('Sinus|Squares|Random Events|Read Outputs');
    cbModel.setVar(model,t_longint,0);

    enPeriod.setVar(ModelPeriod,t_double);
    enAmplitude.setvar(ModelAmp,t_double);
    enNoise.setVar(AmpNoise,t_double);
    enFreq.setvar(EventFreq,t_double);
    if showModal=mrOK
      then updateAllvar(self);
  end;
end;

Initialization
AffDebug('Initialization DemoOpt1',0);
{$IFDEF FPC}
{$I DemoOpt1.lrs}
{$ENDIF}
end.
