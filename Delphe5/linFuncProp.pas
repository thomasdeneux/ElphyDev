unit linFuncProp;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, editcont,
  debug0;

type
  TgetLineFunc = class(TForm)
    labelA: TLabel;
    enA: TeditNum;
    Bcolor: TButton;
    Pcolor: TPanel;
    Label2: TLabel;
    enWidth: TeditNum;
    Button5: TButton;
    Button6: TButton;
    ColorDialog1: TColorDialog;
    LabelB: TLabel;
    enB: TeditNum;
    Label4: TLabel;
    cbStyle: TcomboBoxV;
    cbVisible: TCheckBoxV;
    procedure BcolorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function getLineFunc: TgetLineFunc;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FgetLineFunc: TgetLineFunc;

function getLineFunc: TgetLineFunc;
begin
  if not assigned(FgetLineFunc) then FgetLineFunc:= TgetLineFunc.create(nil);
  result:= FgetLineFunc;
end;

procedure TgetLineFunc.BcolorClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    execute;
    Pcolor.color:=color;
  end;
end;


Initialization
AffDebug('Initialization linFuncProp',0);
{$IFDEF FPC}
{$I linFuncProp.lrs}
{$ENDIF}
end.
