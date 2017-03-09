unit Ocom1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Menus, ComCtrls,

  util1,Dgraphic, debug0,
  stmObj, ObjfileO, DisplayUOFrame1;

type
  TObjFileCommand = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Close1: TMenuItem;
    New1: TMenuItem;
    Options1: TMenuItem;
    TreeView1: TTreeView;

    Panel1: TPanel;
    Splitter1: TSplitter;
    Memo1: TMemo;
    Splitter2: TSplitter;
    UODisplay1: TUODisplay;
    PanelBottom: TPanel;
    Bok: TButton;
    Bcancel: TButton;
    procedure Open1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure TreeView1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure TreeView1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure TreeView1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure TreeView1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure BokClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    uo0:typeUO;
    TUO0: TUOclass;
    Fchoose:boolean;
    Fdestroy:boolean;
  public
    { Public declarations }


    procedure init(uo:typeUO);
    procedure chooseObject(TUO:TUOclass;var ob:typeUO);
  end;

function ObjFileCommand: TObjFileCommand;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

uses objFile1;

var
  FObjFileCommand: TObjFileCommand;

function ObjFileCommand: TObjFileCommand;
begin
  if not assigned(FObjFileCommand) then FObjFileCommand:= TObjFileCommand.create(nil);
  result:= FObjFileCommand;
end;



procedure TObjFileCommand.Open1Click(Sender: TObject);
begin
  if assigned(uo0) then
    TobjectFile(uo0).GOpenFile;
end;

procedure TObjFileCommand.Close1Click(Sender: TObject);
begin
  if assigned(uo0) then
    TobjectFile(uo0).GCloseFile;
end;

procedure TObjFileCommand.New1Click(Sender: TObject);
begin
  if assigned(uo0) then
    TobjectFile(uo0).GNewFile;
end;

procedure TObjFileCommand.Options1Click(Sender: TObject);
begin
  if assigned(uo0) then
  with TobjectFile(uo0) do
  if ObjectFileOptions.execution(Foptions) then
    begin
      DescToFont(FOptions.FontRec,panel1.font);
      panel1.color:=FOptions.color;
      invalidate;
    end;
end;

procedure TObjFileCommand.TreeView1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  accept:=not Fchoose and assigned(uo0) and TobjectFile(uo0).GdragOver;
end;

procedure TObjFileCommand.TreeView1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
  if not Fchoose and assigned(uo0) then TobjectFile(uo0).GdragDrop(source);
end;

procedure TObjFileCommand.TreeView1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if not Fchoose and assigned(uo0) then
    if TobjectFile(uo0).GbeginDrag then TreeView1.beginDrag(false);

end;

procedure TObjFileCommand.TreeView1Change(Sender: TObject;
  Node: TTreeNode);
begin
  if assigned(uo0) and not Fdestroy then
   TobjectFile(uo0).GonChange(node);
end;

procedure TObjFileCommand.init(uo: typeUO);
begin
  Fchoose:=false;
  PanelBottom.Visible:=false;
  uo0:=uo;
end;

procedure TObjFileCommand.TreeView1EndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  if not Fchoose then resetDragUO;
end;

procedure TObjFileCommand.chooseObject(TUO: TUOclass; var ob: typeUO);
begin
  Fchoose:=true;
  TUO0:=TUO;
  PanelBottom.Visible:=true;
  file1.Visible:=false;

  if showModal=mrOK
    then ob:=TobjectFile(uo0).currentUO
    else ob:=nil;
end;

procedure TObjFileCommand.BokClick(Sender: TObject);
var
  ok:boolean;
begin
  ok:=(TobjectFile(uo0).currentUO is TUO0);

  if ok
    then modalResult:=mrOK
    else messageCentral('The object has not the required type');

end;

procedure TObjFileCommand.FormDestroy(Sender: TObject);
begin
  Fdestroy:=true;
end;

Initialization
AffDebug('Initialization Ocom1',0);
{$IFDEF FPC}
{$I Ocom1.lrs}
{$ENDIF}
end.
