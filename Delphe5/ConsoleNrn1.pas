unit ConsoleNrn1;

interface

uses
  Windows,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ExtCtrls, Menus,

  SynEdit, SynEditHighlighter,SynEditKeyCmds,

  util1, Gdos, Ddosfich, debug0 ;

type

  { TconsoleE }

  TprocessLine=procedure (st:string) of object;

  TconsoleNrn = class(TForm)
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
    procedure EditorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
    Stack:TstringList;
    StackIndex:integer;
    MaxStackIndex:integer;

    procedure EditorStatusChange(Sender: TObject;Changes: TSynStatusChanges);
    procedure PushLine(st:AnsiString);
    function PopLine:AnsiString;
    function PopLine2:AnsiString;

  public
    { Déclarations publiques }
    ProcessLine: procedure (st:AnsiString) of object;

    procedure Init;
    Procedure AddLine(st:AnsiString);

  end;


implementation



{$R *.DFM}

var
  LastFile:AnsiString;

procedure TconsoleNrn.EditorStatusChange(Sender: TObject; Changes: TSynStatusChanges);
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

procedure TconsoleNrn.Init;
begin

  editor.OnStatusChange:= EditorStatusChange;
end;

procedure TconsoleNrn.PushLine(st:AnsiString);
begin
  stack.Add(st);
  while stack.count>MaxStackIndex do stack.Delete(0);
  StackIndex:=stack.count-1;
end;

function TconsoleNrn.PopLine:AnsiString;
begin
  if stack.count=0 then exit;
  result:=stack[stackIndex];
  if stackIndex>0 then dec(stackIndex) else stackIndex:=stack.Count-1;
end;

function TconsoleNrn.PopLine2:AnsiString;
begin
  if stack.count=0 then exit;

  if stackIndex<stack.Count-1 then inc(stackIndex) else stackIndex:=0;
  result:=stack[stackIndex];

end;


procedure TconsoleNrn.EditorProcessCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
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
            then ProcessLine(lines[lines.count-1]);
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

procedure TconsoleNrn.AddLine(st: AnsiString);
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

procedure TconsoleNrn.FormCreate(Sender: TObject);
begin
  stack:=TstringList.create;
  MaxStackIndex:=1000;

  //editor.SearchEngine:=SearchEditGlb;
end;

procedure TconsoleNrn.FormDestroy(Sender: TObject);
begin
  stack.free;
end;


procedure TconsoleNrn.Save1Click(Sender: TObject);
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

procedure TconsoleNrn.Clear1Click(Sender: TObject);
begin
  if MessageDlg('Clear All Commands ?', mtConfirmation,[mbYes,mbNo],0) = mrYes then
  begin
    Editor.Lines.Clear;
    Editor.Lines.Add('');
    Editor.readOnly:=false;
  end;
end;


procedure TconsoleNrn.Undo1Click(Sender: TObject);
begin
  editor.Undo;
end;

procedure TconsoleNrn.Redo1Click(Sender: TObject);
begin
  editor.Redo;
end;

procedure TconsoleNrn.Copy1Click(Sender: TObject);
begin
  editor.CopyToClipboard;
end;

procedure TconsoleNrn.Paste1Click(Sender: TObject);
begin
  editor.PasteFromClipboard;
end;

procedure TconsoleNrn.Cut1Click(Sender: TObject);
begin
  editor.CutToClipboard;
end;

procedure TconsoleNrn.EditorMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pp:Tpoint;
begin
  if ssRight in Shift then
    begin
      pp:=Editor.ClientToScreen(classes.point(x,y));
      popupMenu1.Popup(pp.x,pp.y);
    end;
end;                                                                  

Initialization
AffDebug('Initialization evalvar1',0);
end.
