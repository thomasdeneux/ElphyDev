unit NSflags1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ExtCtrls,

  util1,stmdef,stmObj,stmdf0, debug0;

type
  TNsFlagsDlg = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    VlistBox: TCheckListBox;
    VtagListBox: TCheckListBox;
    BVselectAll: TButton;
    BVunselectAll: TButton;
    BVtagUnselectAll: TButton;
    BVtagSelectAll: TButton;
    Bcancel: TButton;
    BOK: TButton;
    procedure BVselectAllClick(Sender: TObject);
    procedure BVunselectAllClick(Sender: TObject);
    procedure BVtagSelectAllClick(Sender: TObject);
    procedure BVtagUnselectAllClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Execute(df:TdataFile);
  end;

function NsFlagsDlg: TNsFlagsDlg;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FNsFlagsDlg: TNsFlagsDlg;

function NsFlagsDlg: TNsFlagsDlg;
begin
  if not assigned(FNsFlagsDlg) then FNsFlagsDlg:= TNsFlagsDlg.create(nil);
  result:= FNsFlagsDlg;
end;

{ TNsFlagsDlg }

procedure TNsFlagsDlg.Execute(df:TdataFile);
var
  i:integer;
begin
  with df do
  begin
    VlistBox.Items.Clear;
    for i:=1 to ChannelCount do
    begin
      VlistBox.Items.Add('V'+Istr(i));
      VlistBox.Checked[i-1]:=NSVflag[i];
    end;
    VtagListBox.Items.Clear;
    for i:=1 to VtagCount do
    begin
      VtagListBox.Items.Add('Vtag'+Istr(i));
      VtagListBox.Checked[i-1]:=NSVtagFlag[i];
    end;

  end;

  if showmodal=mrok then
  with df do
  begin
    for i:=1 to ChannelCount do
      NSVflag[i]:=VlistBox.Checked[i-1];
    for i:=1 to VtagCount do
      NSVtagFlag[i]:=VtagListBox.Checked[i-1];
  end;


end;

procedure TNsFlagsDlg.BVselectAllClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to VlistBox.Count-1 do VlistBox.Checked[i]:=true;
end;

procedure TNsFlagsDlg.BVunselectAllClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to VlistBox.Count-1 do VlistBox.Checked[i]:=false;
end;


procedure TNsFlagsDlg.BVtagSelectAllClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to VtaglistBox.Count-1 do VtaglistBox.Checked[i]:=true;
end;


procedure TNsFlagsDlg.BVtagUnselectAllClick(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to VtaglistBox.Count-1 do VtaglistBox.Checked[i]:=false;
end;


Initialization
AffDebug('Initialization NSflags1',0);
{$IFDEF FPC}
{$I NSflags1.lrs}
{$ENDIF}
end.
