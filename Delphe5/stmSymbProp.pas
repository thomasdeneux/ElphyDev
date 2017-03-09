unit stmSymbProp;

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
  TgetSymbol = class(TForm)
    Label1: TLabel;
    enX: TeditNum;
    Bcolor: TButton;
    Pcolor: TPanel;
    Label2: TLabel;
    enSize: TeditNum;
    Button5: TButton;
    Button6: TButton;
    ColorDialog1: TColorDialog;
    Label3: TLabel;
    enY: TeditNum;
    Label4: TLabel;
    cbStyle: TcomboBoxV;
    cbVisible: TCheckBoxV;
    procedure BcolorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function getSymbol: TgetSymbol;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FgetSymbol: TgetSymbol;

function getSymbol: TgetSymbol;
begin
  if not assigned(FgetSymbol) then FgetSymbol:= TgetSymbol.create(nil);
  result:= FgetSymbol;
end;

procedure TgetSymbol.BcolorClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    execute;
    Pcolor.color:=color;
  end;
end;

Initialization
AffDebug('Initialization stmSymbProp',0);
{$IFDEF FPC}
{$I stmSymbProp.lrs}
{$ENDIF}
end.
