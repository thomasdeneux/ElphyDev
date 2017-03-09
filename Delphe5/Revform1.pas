unit revForm1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stimForm, StdCtrls, editcont;

type
  TgetRevCor1 = class(TStimulusForm)
    enDivX: TeditNum;
    Label1: TLabel;
    enDivY: TeditNum;
    Label2: TLabel;
    enCol1: TeditNum;
    Label4: TLabel;
    enCol2: TeditNum;
    Label5: TLabel;
    Label6: TLabel;
    enExpansion: TeditNum;
    Label7: TLabel;
    enScotome: TeditNum;
    Label8: TLabel;
    enRF: TeditNum;
    Label9: TLabel;
    enSeed: TeditNum;
    cbOnControl: TCheckBox;
    cbOnScreen: TCheckBox;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  getRevCor1: TgetRevCor1;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

Initialization
AffDebug('Initialization Revform1',0);
{$IFDEF FPC}
{$I revForm1.lrs}
{$ENDIF}
end.
