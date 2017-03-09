unit ElphyHead;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  util1, Gdos,memoForm, debug0;

type
  TElphyEntete = class(TForm)
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText5: TStaticText;
    Binfo: TButton;
    Panel1: TPanel;
    Lversion: TLabel;
    BOK: TButton;
    procedure FormClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BinfoClick(Sender: TObject);
  private
    { Private declarations }
    DacVer:AnsiString;
    procedure ExtractVersion;
  public
    { Public declarations }
  end;

function ElphyEntete: TElphyEntete;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FElphyEntete: TElphyEntete;

function ElphyEntete: TElphyEntete;
begin
  if not assigned(FElphyEntete) then FElphyEntete:= TElphyEntete.create(nil);
  result:= FElphyEntete;
end;

{$I Dacver.pas}

procedure TElphyEntete.FormClick(Sender: TObject);
begin
  close;
end;

procedure TElphyEntete.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  close;
end;

procedure TElphyEntete.BOKClick(Sender: TObject);
begin
  close;
end;

procedure TElphyEntete.ExtractVersion;
var
  S: AnsiString;
  n, Len, i: DWORD;
  Buf: PChar;
  Value: PChar;
begin
  S := Application.ExeName;
  n := GetFileVersionInfoSize(Pchar(S), n);
  if n > 0 then
  begin
    Buf := AllocMem(n);
    GetFileVersionInfo(PChar(S), 0, n, Buf);

    { Les mots-clés possibles sont:
    CompanyName FileDescription FileVersion InternalName LegalCopyright OriginalFilename ProductName ProductVersion
    }

    if VerQueryValue(Buf, Pchar('\StringFileInfo\040904E4\FileVersion'), Pointer(Value), Len)
      then DacVer:='Version '+value;
    FreeMem(Buf, n);
  end;
end;

procedure TElphyEntete.FormCreate(Sender: TObject);
begin
  ExtractVersion;

  Lversion.caption:={'Version 2.'+Istr(DacVersion) DacVer}   'Build:  '+Istr(DacVersion)+' (' +DateTimeToString(FileDateToDateTime(fileAge(paramStr(0))),false,false)+')'  ;
  {$IFDEF WIN64}
  StaticText1.Caption:='Elphy64';
  {$ENDIF}


  StaticText2.Caption:='(with VisualStim)';
  
end;

procedure TElphyEntete.BinfoClick(Sender: TObject);
var
  viewText:TviewText;
  st:AnsiString;
begin
  st:=extractFilePath(application.exeName)+'Elphy.txt';
  if not fichierExiste(st) then exit;

  viewText:=TviewText.create(nil);
  viewText.Caption:='Elphy info';
  viewText.Font.Name:='Courier New';
  viewText.Font.size:=10;


  viewText.memo1.lines.loadFromFile(st);
  viewText.showModal;

  viewText.free;
end;

Initialization
AffDebug('Initialization ElphyHead',0);
{$IFDEF FPC}
{$I ElphyHead.lrs}
{$ENDIF}
end.
