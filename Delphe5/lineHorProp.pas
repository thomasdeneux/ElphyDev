unit lineHorProp;

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
  Debug0;

type
  TgetLineHor = class(TForm)
    Label1: TLabel;
    enPos: TeditNum;
    Bcolor: TButton;
    Pcolor: TPanel;
    Label2: TLabel;
    enWidth: TeditNum;
    Button5: TButton;
    Button6: TButton;
    ColorDialog1: TColorDialog;
    cbStyle: TcomboBoxV;
    Label4: TLabel;
    cbVisible: TCheckBoxV;
    procedure BcolorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function getLineHor: TgetLineHor;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FgetLineHor: TgetLineHor;

function getLineHor: TgetLineHor;
begin
  if not assigned(FgetLineHor) then FgetLineHor:= TgetLineHor.create(nil);
  result:= FgetLineHor;
end;

procedure TgetLineHor.BcolorClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    execute;
    Pcolor.color:=color;
  end;
end;

Initialization
AffDebug('Initialization lineHorProp',0);
{$IFDEF FPC}
{$I lineHorProp.lrs}
{$ENDIF}
end.
