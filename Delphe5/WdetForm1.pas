unit WdetForm1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Detform1, Menus, StdCtrls, editcont, ExtCtrls, Buttons, 

  util1,wdetDlg1,stmdef,stmObj,stmvec1,stmVzoom;

type
  TWinDetPanel = class(TDetPanel)
    GroupBox1: TGroupBox;
    Bcr1: TButton;
    Bcr2: TButton;
    Bcr3: TButton;
    Bcr4: TButton;
    Bcr8: TButton;
    Bcr7: TButton;
    Bcr6: TButton;
    Bcr5: TButton;
    Bcr10: TButton;
    Bcr9: TButton;
    Bcadrer: TBitBtn;
    cbAbsolute: TCheckBoxV;
    Label8: TLabel;
    enRefPos: TeditNum;
    cbActive1: TCheckBoxV;
    CbActive2: TCheckBoxV;
    cbActive3: TCheckBoxV;
    cbActive4: TCheckBoxV;
    cbActive5: TCheckBoxV;
    cbActive6: TCheckBoxV;
    cbActive7: TCheckBoxV;
    cbActive8: TCheckBoxV;
    cbActive9: TCheckBoxV;
    cbActive10: TCheckBoxV;
    procedure Bcr10Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BcadrerClick(Sender: TObject);
    procedure cbActive1Click(Sender: TObject);
  private
    { Déclarations privées }
    cbA:array[1..10] of TcheckBoxV;
    Bcr:array[1..10] of Tbutton;

  public
    { Déclarations publiques }
     procedure installe(owner:typeUO;var info:TinfoDetect;
                        var source:Tvector;zoom:TimageVector);
  end;

function WinDetPanel: TWinDetPanel;

implementation

uses stmWindet1;
{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FWinDetPanel: TWinDetPanel;

function WinDetPanel: TWinDetPanel;
begin
  if not assigned(FWinDetPanel) then FWinDetPanel:= TWinDetPanel.create(nil);
  result:= FWinDetPanel;
end;



procedure TWinDetPanel.installe(owner:typeUO;var info:TinfoDetect;
                        var source:Tvector;zoom:TimageVector);
var
  i:integer;
begin
  inherited installe(owner,info,source,zoom);

  with TwinDetect(owner0) do
  begin
    cbAbsolute.setVar(AbsCur);
    enRefPos.setVar(RefPos,t_extended);
    enRefPos.Decimal:=6;

    for i:=1 to 10 do
      cbA[i].checked:=wincur[i].visible;

  end;
end;

procedure TWinDetPanel.Bcr10Click(Sender: TObject);
var
  num:integer;
begin
  num:=Tbutton(sender).tag;
  winDetectDlg.caption:='Cursor # '+Istr(num);
  winDetectDlg.execution(TwinDetect(owner0).wincur[num]);
  cbA[num].Checked:=TwinDetect(owner0).wincur[num].visible;
end;



procedure TWinDetPanel.FormCreate(Sender: TObject);
var
  i:integer;
begin
  inherited;

  Bcr[1]:=Bcr1;
  Bcr[2]:=Bcr2;
  Bcr[3]:=Bcr3;
  Bcr[4]:=Bcr4;
  Bcr[5]:=Bcr5;
  Bcr[6]:=Bcr6;
  Bcr[7]:=Bcr7;
  Bcr[8]:=Bcr8;
  Bcr[9]:=Bcr9;
  Bcr[10]:=Bcr10;


  cbA[1]:=cbActive1;
  cbA[2]:=cbActive2;
  cbA[3]:=cbActive3;
  cbA[4]:=cbActive4;
  cbA[5]:=cbActive5;
  cbA[6]:=cbActive6;
  cbA[7]:=cbActive7;
  cbA[8]:=cbActive8;
  cbA[9]:=cbActive9;
  cbA[10]:=cbActive10;

  for i:=1 to 10 do
  begin
    Bcr[i].Tag:=i;
    cbA[i].Tag:=i;
  end;
end;

procedure TWinDetPanel.BcadrerClick(Sender: TObject);
begin
  TwinDetect(owner0).CadrerCurseurs;

end;

procedure TWinDetPanel.cbActive1Click(Sender: TObject);
var
  num:integer;
begin
  num:=TcheckBoxV(sender).Tag;
  with TwinDetect(owner0).wincur[num] do
  begin
    visible := cbA[num].checked;
    invalidateAfter;
  end;  

end;

Initialization
AffDebug('Initialization WdetForm1',0);
{$IFDEF FPC}
{$I WdetForm1.lrs}
{$ENDIF}
end.
