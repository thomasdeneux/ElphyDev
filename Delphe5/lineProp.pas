unit lineProp;

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
  TgetLine = class(TForm)
    labelX1: TLabel;
    enx1: TeditNum;
    Bcolor: TButton;
    Pcolor: TPanel;
    Label2: TLabel;
    enWidth: TeditNum;
    Button5: TButton;
    Button6: TButton;
    ColorDialog1: TColorDialog;
    LabelB: TLabel;
    eny1: TeditNum;
    Label4: TLabel;
    cbStyle: TcomboBoxV;
    cbVisible: TCheckBoxV;
    Label1: TLabel;
    enX2: TeditNum;
    Label3: TLabel;
    eny2: TeditNum;
    procedure BcolorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function getLine: TgetLine;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FgetLine: TgetLine;

function getLine: TgetLine;
begin
  if not assigned(FgetLine) then FgetLine:= TgetLine.create(nil);
  result:= FgetLine;
end;

procedure TgetLine.BcolorClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    execute;
    Pcolor.color:=color;
  end;
end;


Initialization
AffDebug('Initialization lineProp',0);
{$IFDEF FPC}
{$I lineProp.lrs}
{$ENDIF}
end.
