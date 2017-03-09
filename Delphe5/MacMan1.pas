unit MacMan1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,Buttons,fileCtrl,

  util1,Gdos,DdosFich,stmObj,stmPg,Imacro1, debug0;

type
  TMacroManagerDialog = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    Label2: TLabel;
    lbMacro: TListBox;
    Badd: TButton;
    Bup: TBitBtn;
    Bdown: TBitBtn;
    Bdelete: TButton;
    enTitle: TeditString;
    GroupBox1: TGroupBox;
    enMask: TeditString;
    Bbrowse: TButton;
    Label1: TLabel;
    cbRemove: TCheckBoxV;
    Bgo: TButton;
    procedure BaddClick(Sender: TObject);
    procedure lbMacroClick(Sender: TObject);
    procedure enTitleExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BdeleteClick(Sender: TObject);
    procedure BupClick(Sender: TObject);
    procedure BdownClick(Sender: TObject);
    procedure BbrowseClick(Sender: TObject);
    procedure BgoClick(Sender: TObject);
  private
    { Private declarations }
    manager:TmacroManager;
    lbTitles:TstringList;

    stFichier:AnsiString;
    stMask:AnsiString;
    Fremove:boolean;
    procedure updateTitle;
    function index:integer;
    function count:integer;
  public
    { Public declarations }
    procedure execute(p:TmacroManager);
  end;

function MacroManagerDialog: TMacroManagerDialog;

implementation


{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FMacroManagerDialog: TMacroManagerDialog;

function MacroManagerDialog: TMacroManagerDialog;
begin
  if not assigned(FMacroManagerDialog) then FMacroManagerDialog:= TMacroManagerDialog.create(nil);
  result:= FMacroManagerDialog;
end;

procedure TMacroManagerDialog.updateTitle;
begin
  if Index>=0
    then enTitle.text:=lbtitles[Index]
    else enTitle.text:='';
end;

procedure TMacroManagerDialog.BaddClick(Sender: TObject);
var
  st:AnsiString;
begin
  st:= GchooseFile('Choose a PG2 file',stFichier);
  if st<>'' then
  begin
    stFichier:=st;
    lbMacro.Items.Add(stFichier);
    lbTitles.Add(extractFileName(st));
    lbMacro.ItemIndex:=lbMacro.Count-1;
    updateTitle;
  end;
end;

procedure TMacroManagerDialog.BdeleteClick(Sender: TObject);
begin
  if index>=0 then
  begin
    lbTitles.Delete(index);
    lbMacro.Items.Delete(index);
    updateTitle;
  end;
end;

procedure TMacroManagerDialog.lbMacroClick(Sender: TObject);
begin
  updateTitle;
end;

procedure TMacroManagerDialog.enTitleExit(Sender: TObject);
begin
  if (index>=0) and (index<count) then
      lbTitles[index]:=enTitle.text;
end;

procedure TMacroManagerDialog.execute(p: TmacroManager);
var
  i:integer;
begin
  manager:=p;

  with manager do
  begin
    LbMacro.clear;
    lbTitles.Clear;
    for i:=0 to Files.count-1 do
    begin
      LbMacro.items.add(Files[i]);
      lbTitles.Add( Titles[i]);
    end;

    enTitle.Text:='';
    stMask:=stDir+'\*.pg2';

    enMask.setString(stMask,255);
    cbRemove.setVar(Fremove);

    if showModal=mrOK
      then InstallMacros(LbMacro.items,lbtitles);
  end;
end;

procedure TMacroManagerDialog.FormCreate(Sender: TObject);
begin
  lbTitles:=TstringList.create;
  stFichier:='*.pg2';
  stMask:=Appdata+'*.pg2';
end;

procedure TMacroManagerDialog.FormDestroy(Sender: TObject);
begin
  lbTitles.Free;
end;

function TMacroManagerDialog.index: integer;
begin
  result:=lbMacro.ItemIndex;
end;

function TMacroManagerDialog.count: integer;
begin
  result:=lbMacro.Count;
end;


procedure TMacroManagerDialog.BupClick(Sender: TObject);
var
  n:integer;
begin
  n:=lbMacro.ItemIndex;
  if n>0 then
  begin
    lbMacro.items.Exchange(n,n-1);
    lbTitles.Exchange(n,n-1);
    updateTitle;
  end;
end;

procedure TMacroManagerDialog.BdownClick(Sender: TObject);
var
  n:integer;
begin
  n:=lbMacro.ItemIndex;
  if (n>=0) and (n<lbMacro.count-1) then
  begin
    lbMacro.items.Exchange(n,n+1);
    lbTitles.Exchange(n,n+1);
    updateTitle;
  end;

end;

procedure TMacroManagerDialog.BbrowseClick(Sender: TObject);
var
  stDir1: string;
begin
  stDir1:=manager.stDir;
  if SelectDirectory('','',stDir1) then
  begin
    manager.stDir:=stDir1;
    stMask:=manager.stDir+'\*.pg2';
    enMask.UpdateCtrl;
  end;
end;

procedure TMacroManagerDialog.BgoClick(Sender: TObject);
var
  files,titles:TstringList;
begin
  files:=TstringList.create;
  titles:=TstringList.create;

  cbRemove.UpdateVar;
  if not Fremove then
  begin
    files.assign(lbMacro.items);
    Titles.Assign(lbtitles);
  end;

  try
  manager.GetToolFiles(stMask,files,titles);

  lbMacro.items.Assign(files);
  lbTitles.Assign(titles);

  updateTitle;
  
  finally
  files.Free;
  titles.Free;
  end;
end;

Initialization
AffDebug('Initialization MacMan1',0);
{$IFDEF FPC}
{$I MacMan1.lrs}
{$ENDIF}
end.
