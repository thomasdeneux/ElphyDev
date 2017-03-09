unit getrev1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stimForm, StdCtrls, editcont,
  debug0;

type
  TgetRevCor1 = class(TStimulusForm) { Aurait pu descendre de TgetOnOff }
    enDivX: TeditNum;
    Label1: TLabel;
    enDivY: TeditNum;
    Label2: TLabel;
    enLum1: TeditNum;
    Label4: TLabel;
    enLum2: TeditNum;
    Label5: TLabel;
    Label6: TLabel;
    enExpansion: TeditNum;
    Label7: TLabel;
    enScotome: TeditNum;
    Label9: TLabel;
    enSeed: TeditNum;
    cbOnControl: TCheckBoxV;
    cbOnScreen: TCheckBoxV;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    enDtON: TeditNum;
    enDtOff: TeditNum;
    enCycleCount: TeditNum;
    enDelay: TeditNum;
    Button1: TButton;
    CBadjust: TCheckBoxV;
    procedure Button1Click(Sender: TObject);
    procedure cbOnControlClick(Sender: TObject);
    procedure cbOnScreenClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    selectRFD:procedure of object;
    onControlD,onScreenD:procedure(v:boolean) of object;
  end;

var
  getRevCor1: TgetRevCor1;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TgetRevCor1.Button1Click(Sender: TObject);
begin
  if assigned(selectRFD) then selectRFD;
end;

procedure TgetRevCor1.cbOnControlClick(Sender: TObject);
begin
  if assigned(onControlD) then onControlD(cbOnControl.checked);
end;

procedure TgetRevCor1.cbOnScreenClick(Sender: TObject);
begin
  if assigned(onScreenD) then onScreenD(cbOnScreen.checked);
end;

Initialization
AffDebug('Initialization getrev1',0);
{$IFDEF FPC}
{$I getrev1.lrs}
{$ENDIF}
end.
