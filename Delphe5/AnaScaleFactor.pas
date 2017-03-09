unit AnaScaleFactor;

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

  AcqInf2;

type
  TAnalogOutputDialog = class(TForm)
    esUnits: TeditString;
    Label36: TLabel;
    Label32: TLabel;
    enJ1: TeditNum;
    Label33: TLabel;
    enY1: TeditNum;
    enY2: TeditNum;
    Label35: TLabel;
    enJ2: TeditNum;
    Label34: TLabel;
    Bcancel: TButton;
    Bok: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure execute(var NRNoutput:TNRNoutputChannelInfo);
  end;

var
  AnalogOutputDialog: TAnalogOutputDialog;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

{ TAnalogOutputDialog }

procedure TAnalogOutputDialog.execute(var NRNoutput: TNRNoutputChannelInfo);
begin
  with NRNoutput do
  begin

    esUnits.setvar(unitY,sizeof(unitY)-1);

    enJ1.setvar(jru1,T_longint);
    enJ2.setvar(jru2,T_longint);

    enY1.setvar(Yru1,T_single);
    enY2.setvar(Yru2,T_single);

  end;

end;

Initialization
AffDebug('Initialization AnaScaleFactor',0);
{$IFDEF FPC}
{$I AnaScaleFactor.lrs}
{$ENDIF}
end.
