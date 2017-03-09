unit DigiOpt0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,

  util1,debug0;

type
  TDigiOptions = class(TForm)
    Label1: TLabel;
    cbDma1: TcomboBoxV;
    Label2: TLabel;
    cbDma2: TcomboBoxV;
    BOK: TButton;
    Bcancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure execution(var ch1,ch2:integer);
  end;

function DigiOptions: TDigiOptions;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FDigiOptions: TDigiOptions;

function DigiOptions: TDigiOptions;
begin
  if not assigned(FDigiOptions) then FDigiOptions:= TDigiOptions.create(nil);
  result:= FDigiOptions;
end;

procedure TDigiOptions.execution(var ch1,ch2:integer);
begin
  cbDma1.SetNumList(5,7,1);
  cbDma1.setNumVar(ch1,t_longint);
  
  cbDma2.SetNumList(5,7,1);
  cbDma2.setNumVar(ch2,t_longint);

  if showModal=mrOK then  updateAllvar(self);
end;



Initialization
AffDebug('Initialization DigiOpt0',0);
{$IFDEF FPC}
{$I DigiOpt0.lrs}
{$ENDIF}
end.
