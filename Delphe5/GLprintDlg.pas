unit GLprintDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  util1, stmObj, StdCtrls, editcont, ColorFrame1, xmldom, XMLIntf,
  msxmldom, XMLDoc;

type
  TGlprintForm = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    enWidth: TeditNum;
    enHeight: TeditNum;
    Label2: TLabel;
    Bcopy: TButton;
    Bprint: TButton;
    Button2: TButton;
    ColFrame1: TColFrame;
    enQuality: TeditNum;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    PrnWidth, PrnHeight:integer;
  public
    { Déclarations publiques }
    function Execute(Atitle:AnsiString;var w,h, col, quality: integer): integer;
  end;

function GlprintForm: TGlprintForm;



implementation

uses stmXYZplot1;

{$R *.dfm}
var
  FGlprintForm: TGlprintForm;

function GlprintForm: TGlprintForm;
begin
  if not assigned(FGLprintForm) then FGlprintForm:= TGlprintForm.Create(nil);
  result:= FGLprintForm;
end;


{ TGlprintForm }

function TGlprintForm.Execute(Atitle:AnsiString; var w,h, col,quality: integer): integer;
var
  res:integer;
  color0: integer;
begin

  caption:=ATitle;
  color0:=col;

  enWidth.setVar(PrnWidth,G_longint);
  enHeight.setVar(PrnHeight,G_longint);

  colFrame1.init(color0);

  enQuality.setVar(quality,G_longint);
  enQuality.setMinMax(1,100);
  res:=showModal;
  if res>100 then
  begin
     updateAllVar(self);
     w:=PrnWidth;
     h:=PrnHeight;
     col:=color0;
     result:=res;
  end
  else result:=0;

end;

procedure TGlprintForm.FormCreate(Sender: TObject);
begin
  PrnWidth:=1000;
  PrnHeight:=1000;

end;

end.
