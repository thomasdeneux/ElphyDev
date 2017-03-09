unit MemoForm;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, printers,

  util1,Gdos,DdosFich,debug0, ExtCtrls;

type
  TViewText = class(TForm)
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Save1: TMenuItem;
    Print1: TMenuItem;
    Panel1: TPanel;
    Bok: TButton;
    Bcancel: TButton;
    procedure Save1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    stFile:AnsiString;
    PrintFont:Tfont;

  public
    { Public declarations }
    OnShowWin: procedure of object;

  end;

procedure DisplayViewText(st: AnsiString);

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TViewText.Save1Click(Sender: TObject);
var
  res:integer;
begin
  stFile:=GsaveFile('Save file',stFile,'TXT');
  if stFile<>'' then
    begin
      if fichierExiste(stFile) then
        begin
          res:= MessageDlg('File already exists. Overwrite?',
                mtConfirmation,[mbYes,mbNo],0);
          if res<>mrYes then exit;
        end;

      caption:= extractFileName(stFile);
      memo1.Lines.SaveToFile(stFile);

    end;
end;


procedure TViewText.FormCreate(Sender: TObject);
begin
  PrintFont:=Tfont.create;
  PrintFont.Name:='Courier New';
  PrintFont.Size:=10;

end;

procedure TViewText.FormDestroy(Sender: TObject);
begin
  PrintFont.Free;
end;

procedure TViewText.Print1Click(Sender: TObject);
var
  f: TextFile;
  i:integer;
begin
{$IFDEF FPC}

{$ELSE}
  AssignPrn(f);
  Rewrite(f);

  printer.canvas.Font.Assign(PrintFont);

  with Memo1 do
  begin
    for i:=1 to Lines.Count do
      Writeln(f,lines[i-1]);
  end;

  CloseFile(f);
{$ENDIF}
end;

procedure TViewText.FormShow(Sender: TObject);
begin
  if assigned(OnShowWin) then OnShowWin;
end;


procedure DisplayViewText(st: AnsiString);
var
  Vt: TviewText;
begin
  Vt:= TviewText.Create(nil);
  try
  Vt.caption:= 'Info';
  Vt.Memo1.Text:=st;
  Vt.ShowModal;
  finally
  Vt.Free;
  end;
end;

Initialization
AffDebug('Initialization memoForm',0);
{$IFDEF FPC}
{$I MemoForm.lrs}
{$ENDIF}
end.
