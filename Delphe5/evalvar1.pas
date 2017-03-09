unit evalvar1;

interface

uses
  Windows,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ExtCtrls,

  SynEdit, SynEditHighlighter,SynEditKeyCmds,

  util1, Gdos, Ddosfich, Ncdef2,stmDef, debug0,
  Ncompil3,
  symbac3,
  Gedit5 ,
  Menus;

type

  { TconsoleE }

  TprocessLine=procedure (st:string) of object;

  TconsoleE = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Save1: TMenuItem;
    Clear1: TMenuItem;
    Edit1: TMenuItem;
    Editor: TSynEdit;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N1: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Cut1: TMenuItem;
    S1: TMenuItem;
    Find1: TMenuItem;
    FindNext1: TMenuItem;
    Options1: TMenuItem;
    Font1: TMenuItem;
    Colors1: TMenuItem;
    Help1: TMenuItem;
    PopupMenu1: TPopupMenu;
    ProgramHelp1: TMenuItem;
    Debug1: TMenuItem;
    procedure EditorProcessCommand(Sender: TObject;
      var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);

    procedure Undo1Click(Sender: TObject);
    procedure Redo1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Find1Click(Sender: TObject);
    procedure FindNext1Click(Sender: TObject);
    procedure Help1Click(Sender: TObject);
    procedure ProgramHelp1Click(Sender: TObject);
    procedure EditorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
    Stack:TstringList;
    StackIndex:integer;
    MaxStackIndex:integer;

    EditWin:Tedit5;

    procedure EditorStatusChange(Sender: TObject;Changes: TSynStatusChanges);
    procedure PushLine(st:AnsiString);
    function PopLine:AnsiString;
    function PopLine2:AnsiString;

  public
    { Déclarations publiques }
    ProcessLine: procedure (st:AnsiString; edit: Tedit5) of object;

    procedure Init(Edit:Tedit5);
    Procedure AddLine(st:AnsiString);

    procedure EvaluerVar(st:AnsiString);
  end;

const
  ElphyDebugMode: boolean=true;

var
  BreakPointList: Tlist;

function IsABreakPoint(Plex: PtUlex): boolean;
procedure ShowDebugWindow;

implementation



{$R *.DFM}

var
  LastFile:AnsiString;

procedure TconsoleE.EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
var
  p:integer;
begin
  if [scCaretX,scCaretY]*Changes<>[] then
  begin
    p:=TsynEdit(sender).CaretY;
    with TsynEdit(sender) do
    begin
      readOnly:= ( p<>lines.Count) and (lines.count<>0);
    end;
  end;

end;

procedure TconsoleE.Init(edit:Tedit5);
begin
  editWin:=edit;
  if assigned(EditWin) then
  begin
    Editor.Font.assign(editWin.TheFont);
    editor.Highlighter:=editWin.SynElphySyn1;
  end;

  editor.OnStatusChange:= EditorStatusChange;
end;

procedure TconsoleE.PushLine(st:AnsiString);
begin
  stack.Add(st);
  while stack.count>MaxStackIndex do stack.Delete(0);
  StackIndex:=stack.count-1;
end;

function TconsoleE.PopLine:AnsiString;
begin
  if stack.count=0 then exit;
  result:=stack[stackIndex];
  if stackIndex>0 then dec(stackIndex) else stackIndex:=stack.Count-1;
end;

function TconsoleE.PopLine2:AnsiString;
begin
  if stack.count=0 then exit;

  if stackIndex<stack.Count-1 then inc(stackIndex) else stackIndex:=0;
  result:=stack[stackIndex];

end;


procedure TconsoleE.EditorProcessCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
var
  st:AnsiString;
begin
  with TsynEdit(sender) do
  case command of
    ecLineBreak, ecInsertLine:
      begin
        if (CaretY=lines.Count) then
        begin
          CaretX:= length(lines[lines.count-1]) +1;
          PushLine(lines[lines.count-1]);
          if assigned(ProcessLine)
            then ProcessLine(lines[lines.count-1], editWin);
        end;
      end;

    ecDeleteLastChar:
      begin
        if (caretY=lines.Count) and (caretX=1) then command:=ecNone;
      end;

    ecUp:
      begin
        if CaretY=lines.Count then
        begin
          command:=ecNone;
          lines[lines.count-1]:=PopLine;
          caretX:=length(lines[lines.count-1])+1;
        end;
      end;

    ecDown:
      begin
        if CaretY=lines.Count then
        begin
          command:=ecNone;
          lines[lines.count-1]:=PopLine2;
          caretX:=length(lines[lines.count-1])+1;
        end;
      end;
  end;
end;

procedure TconsoleE.EditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (key=VK_F1) and (shift=[ssCtrl]) then ProgramHelp1Click(nil);

end;


procedure TconsoleE.AddLine(st: AnsiString);
begin
  with editor do
  begin
    if st<>'' then
      if (lines.Count>0) and ( lines[lines.Count-1]='')
        then Lines[lines.Count-1]:=st
        else Lines.Add(st);

    Lines.Add('');
    caretY:=Lines.Count;
    caretX:=1;
    invalidate;
  end;
end;

procedure TconsoleE.FormCreate(Sender: TObject);
begin
  stack:=TstringList.create;
  MaxStackIndex:=1000;

  editor.SearchEngine:=SearchEditGlb;
end;

procedure TconsoleE.FormDestroy(Sender: TObject);
begin
  stack.free;
end;

procedure TconsoleE.EvaluerVar(st: AnsiString);
var
  p,p1,p2:integer;
begin
  if not visible then show;
  BringToFront;

  p1:=pos(#10,st);
  p2:=pos(#13,st);
  if (p1=0) and (p2=0) then p:=length(st)
  else
  if p1=0 then p:=p2-1
  else
  if p2=0 then p:=p1-1
  else
  if p1<p2 then p:=p1-1
  else p:=p2-1;

  st:=copy(st,1,p);

  with editor do
  begin
    if st<>'' then
    begin
      if (lines.Count>0) and ( lines[lines.Count-1]='')
        then Lines[lines.Count-1]:=st
        else Lines.Add(st);

      caretY:=Lines.Count;
      caretX:=length(st)+1;

      PushLine(st);
      if assigned(ProcessLine)
        then ProcessLine(st, EditWin);
    end;
  end;
end;

procedure TconsoleE.Save1Click(Sender: TObject);
var
  st:AnsiString;
  res:integer;
begin
  st:=GsaveFile('Save as',LastFile,'txt');
  if st<>'' then
    begin
      if fichierExiste(st) then
        begin
          res:= MessageDlg('File already exists. Overwrite?',
                mtConfirmation,[mbYes,mbNo],0);
          if res<>mrYes then exit;
        end;

      Editor.Lines.SaveToFile(st);
    end;
end;

procedure TconsoleE.Clear1Click(Sender: TObject);
begin
  if MessageDlg('Clear All Commands ?', mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
    Editor.Lines.Clear;
    Editor.Lines.Add('');
    Editor.readOnly:=false;
  end;
end;


procedure TconsoleE.Undo1Click(Sender: TObject);
begin
  editor.Undo;
end;

procedure TconsoleE.Redo1Click(Sender: TObject);
begin
  editor.Redo;
end;

procedure TconsoleE.Copy1Click(Sender: TObject);
begin
  editor.CopyToClipboard;
end;

procedure TconsoleE.Paste1Click(Sender: TObject);
begin
  editor.PasteFromClipboard;
end;

procedure TconsoleE.Cut1Click(Sender: TObject);
begin
  editor.CutToClipboard;
end;

procedure TconsoleE.Find1Click(Sender: TObject);
begin
  if assigned(EditWin) then
    EditWin.FindAword(editor);
end;

procedure TconsoleE.FindNext1Click(Sender: TObject);
begin
  if assigned(EditWin) then
    EditWin.FindNextWord(Editor);
end;

procedure TconsoleE.Help1Click(Sender: TObject);
begin
  if assigned(EditWin) then EditWin.ProgramHelp;
end;

procedure TconsoleE.ProgramHelp1Click(Sender: TObject);
begin
  if assigned(EditWin) then EditWin.HelpOnAword(Editor.WordAtCursor);
end;


procedure TconsoleE.EditorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pp:Tpoint;
begin
  if ssRight in Shift then
    begin
      pp:=Editor.ClientToScreen(classes.point(x,y));
      popupMenu1.Popup(pp.x,pp.y);
    end;
end;


function IsABreakPoint(Plex: PtUlex): boolean;
begin
end;

procedure ShowDebugWindow;
begin
end;


Initialization
AffDebug('Initialization evalvar1',0);
BreakPointList:= Tlist.create;
end.
