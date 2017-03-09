unit EditorColors1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ColorFrame1, editcont, Buttons, ExtCtrls,

  util1,debug0,
  {$IFDEF FPC} Gedit5fpc {$ELSE} Gedit5 {$ENDIF} ;

type
  TGetEditorColors = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Button5: TButton;
    Button6: TButton;
    Panel2: TPanel;
    BitBtn2: TBitBtn;
    Panel3: TPanel;
    BitBtn3: TBitBtn;
    Panel4: TPanel;
    BitBtn4: TBitBtn;
    Panel5: TPanel;
    BitBtn5: TBitBtn;
    ColorDialog1: TColorDialog;
    Label6: TLabel;
    CheckBox1: TCheckBoxV;
    CheckBox2: TCheckBoxV;
    CheckBox3: TCheckBoxV;
    CheckBox4: TCheckBoxV;
    CheckBox5: TCheckBoxV;
    CheckBox6: TCheckBoxV;
    CheckBox7: TCheckBoxV;
    CheckBox8: TCheckBoxV;
    CheckBox9: TCheckBoxV;
    CheckBox10: TCheckBoxV;
    CheckBox11: TCheckBoxV;
    CheckBox12: TCheckBoxV;
    CheckBox13: TCheckBoxV;
    CheckBox14: TCheckBoxV;
    CheckBox15: TCheckBoxV;
    Pex1: TPanel;
    Pex2: TPanel;
    Pex3: TPanel;
    Pex4: TPanel;
    Pex5: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Panel6: TPanel;
    BitBtn6: TBitBtn;
    Panel7: TPanel;
    BitBtn7: TBitBtn;
    CheckBox16: TCheckBoxV;
    CheckBox17: TCheckBoxV;
    CheckBox18: TCheckBoxV;
    CheckBox19: TCheckBoxV;
    CheckBox20: TCheckBoxV;
    CheckBox21: TCheckBoxV;
    Pex6: TPanel;
    Pex7: TPanel;
    PanelG1: TPanel;
    BitBtnG1: TBitBtn;
    PanelG2: TPanel;
    BitBtnG2: TBitBtn;
    PanelG3: TPanel;
    BitBtnG3: TBitBtn;
    PanelG4: TPanel;
    BitBtnG4: TBitBtn;
    PanelG5: TPanel;
    BitBtnG5: TBitBtn;
    PanelG6: TPanel;
    BitBtnG6: TBitBtn;
    PanelG7: TPanel;
    BitBtnG7: TBitBtn;
    Label9: TLabel;
    Panel8: TPanel;
    BitBtn8: TBitBtn;
    CheckBox22: TCheckBoxV;
    CheckBox23: TCheckBoxV;
    CheckBox24: TCheckBoxV;
    Pex8: TPanel;
    PanelG8: TPanel;
    BitBtnG8: TBitBtn;
    Button1: TButton;
    procedure FormClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure BitBtnG1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
    Pcolor,PcolorG,Pex:array[1..8] of Tpanel;
    cbBold,cbItalic,cbUnder:array[1..8] of TcheckBox;

    ed0:pointer;
    procedure updateExample(n:integer);
    procedure initDlg(ed:Tedit5);
  public
    { Déclarations publiques }


    function execute(ed:Tedit5):boolean;
  end;

function GetEditorColors: TGetEditorColors;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FGetEditorColors: TGetEditorColors;

function GetEditorColors: TGetEditorColors;
begin
  if not assigned(FGetEditorColors) then FGetEditorColors:= TGetEditorColors.create(nil);
  result:= FGetEditorColors;
end;

procedure TGetEditorColors.initDlg(ed:Tedit5);
var
  i:integer;
begin
  for i:=1 to 8 do
  begin
    Pcolor[i].Color:=DefEdColors[i];
    PcolorG[i].Color:=DefEdBKColors[i];

    cbBold[i].checked:=DefEdBold[i];
    cbItalic[i].checked:=DefEdItalic[i];
    cbUnder[i].checked:=DefEdUnderscore[i];

    Pex[i].font.Assign(ed.TheFont);
    updateExample(i);
  end;
end;


function TGetEditorColors.execute(ed:Tedit5):boolean;
var
  i:integer;
begin
  ed0:=ed;
  initDlg(ed);
  result:= (showModal=mrOK);

  if result then
  begin
    for i:=1 to 8 do
    begin
      DefEdColors[i]:=Pcolor[i].Color;
      DefEdBKColors[i]:=PcolorG[i].Color;

      DefEdBold[i]:=cbBold[i].checked;
      DefEdItalic[i]:=cbItalic[i].checked;
      DefEdUnderscore[i]:=cbUnder[i].checked;
    end;
  end;
end;

procedure TGetEditorColors.FormClick(Sender: TObject);
var
  n:integer;
begin
  n:=Tbitbtn(sender).Tag;
  with colorDialog1 do
  begin
    color:=DefEdColors[n];
    execute;
    Pcolor[n].color:=color;
  end;

  updateExample(n);
end;

procedure TGetEditorColors.BitBtnG1Click(Sender: TObject);
var
  n:integer;
begin
  n:=Tbitbtn(sender).Tag;
  with colorDialog1 do
  begin
    color:=DefEdBKColors[n];
    execute;
    PcolorG[n].color:=color;
  end;

  updateExample(n);
end;


procedure TGetEditorColors.updateExample(n: integer);
begin
  with Pex[n] do
  begin
    color:=PcolorG[n].Color;
    Font.Color:=Pcolor[n].Color;
    Font.Style:=[];
    if cbBold[n].Checked then Font.Style:=Font.Style+[fsBold];
    if cbItalic[n].Checked then Font.Style:=Font.Style+[fsItalic];
    if cbUnder[n].Checked then Font.Style:=Font.Style+[fsUnderLine];

    invalidate;
  end;
end;

procedure TGetEditorColors.FormCreate(Sender: TObject);
var
  i:integer;
begin
  Pcolor[1]:=panel1;
  Pcolor[2]:=panel2;
  Pcolor[3]:=panel3;
  Pcolor[4]:=panel4;
  Pcolor[5]:=panel5;
  Pcolor[6]:=panel6;
  Pcolor[7]:=panel7;
  Pcolor[8]:=panel8;

  PcolorG[1]:=panelG1;
  PcolorG[2]:=panelG2;
  PcolorG[3]:=panelG3;
  PcolorG[4]:=panelG4;
  PcolorG[5]:=panelG5;
  PcolorG[6]:=panelG6;
  PcolorG[7]:=panelG7;
  PcolorG[8]:=panelG8;

  Pex[1]:=Pex1;
  Pex[2]:=Pex2;
  Pex[3]:=Pex3;
  Pex[4]:=Pex4;
  Pex[5]:=Pex5;
  Pex[6]:=Pex6;
  Pex[7]:=Pex7;
  Pex[8]:=Pex8;

  cbBold[1]:=checkBox1;
  cbBold[2]:=checkBox4;
  cbBold[3]:=checkBox7;
  cbBold[4]:=checkBox10;
  cbBold[5]:=checkBox13;
  cbBold[6]:=checkBox16;
  cbBold[7]:=checkBox19;
  cbBold[8]:=checkBox22;

  cbItalic[1]:=checkBox2;
  cbItalic[2]:=checkBox5;
  cbItalic[3]:=checkBox8;
  cbItalic[4]:=checkBox11;
  cbItalic[5]:=checkBox14;
  cbItalic[6]:=checkBox17;
  cbItalic[7]:=checkBox20;
  cbItalic[8]:=checkBox23;

  cbUnder[1]:=checkBox3;
  cbUnder[2]:=checkBox6;
  cbUnder[3]:=checkBox9;
  cbUnder[4]:=checkBox12;
  cbUnder[5]:=checkBox15;
  cbUnder[6]:=checkBox18;
  cbUnder[7]:=checkBox21;
  cbUnder[8]:=checkBox24;


  for i:=1 to 8 do
  begin
    cbBold[i].Tag:=i;
    cbItalic[i].Tag:=i;
    cbUnder[i].Tag:=i;
  end;
end;

procedure TGetEditorColors.CheckBox1Click(Sender: TObject);
begin
  updateExample(TbitBtn(sender).Tag);
end;



procedure TGetEditorColors.Button1Click(Sender: TObject);
var
  i:integer;
  st:AnsiString;
begin
  {
  for i:=1 to 8 do st:=st+Istr(DefEdColors[i])+crlf;
  messageCentral(st);
  }
  initDlg(Tedit5(ed0));

end;


Initialization
AffDebug('Initialization editorColors1',0);
{$IFDEF FPC}
{$I EditorColors1.lrs}
{$ENDIF}
end.
