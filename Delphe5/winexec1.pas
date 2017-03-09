unit winexec1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont,

  util1;

type
  TForm1 = class(TForm)
    editString1: TeditString;
    Bgo: TButton;
    LabelDir: TLabel;
    Bdir: TButton;
    OpenDialog1: TOpenDialog;
    procedure BgoClick(Sender: TObject);
    procedure BdirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    stPath:AnsiString;
    stCom:AnsiString;
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TForm1.BgoClick(Sender: TObject);
begin
  editString1.UpdateVar;

  SetEnvironmentVariable('NU','c:/nrn');

  if stPath<>'' then setCurrentDirectory(@stPath[1]);
  if stCom<>'' then  winexec(@stCom[1],SW_SHOW);

end;

procedure TForm1.BdirClick(Sender: TObject);

begin
  with OpenDialog1 do
  begin
    options:=options+[ofAllowMultiSelect];

  end;

  if OpenDialog1.execute then
  begin
    stPath:=extractFilePath(OpenDialog1.fileName);
    LabelDir.Caption:=stPath;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  stPath:='c:\nrn\modeles\tcfluct';
  openDialog1.InitialDir:=stPath;
  LabelDir.Caption:=stPath;
  
  stCom:= 'c:\nrn\bin\rxvt -e c:/nrn/bin/sh c:/nrn/lib/mknrndllA.sh c:/nrn';

  editString1.setString(stCom,1000);

end;

end.


Initialization
AffDebug('Initialization winexec1',0);
{$IFDEF FPC}
{$I winexec1.lrs}
{$ENDIF}

