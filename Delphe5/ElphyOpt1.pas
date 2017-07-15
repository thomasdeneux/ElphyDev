unit ElphyOpt1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, editcont,
  fileCtrl,

  util1, debug0, stmdef;

type
  TElphyOpt = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    ESMatlab: TeditString;                                                                                                     
    MatlabButton: TBitBtn;
    Label2: TLabel;
    cbManagedMem: TcomboBoxV;
    Label3: TLabel;
    ESdataRoot: TeditString;
    DataRootBtn: TBitBtn;
    Label4: TLabel;
    ESpgRoot: TeditString;
    PgRootBtn: TBitBtn;
    Label5: TLabel;
    EStempDir: TeditString;
    TempDirBtn: TBitBtn;
    CBcreateLog: TCheckBoxV;
    enLogCode: TeditNum;
    Label6: TLabel;
    cbCudaVersion: TcomboBoxV;
    Label7: TLabel;
    cbDirectXVersion: TcomboBoxV;
    Label8: TLabel;
    procedure MatlabButtonClick(Sender: TObject);
    procedure DataRootBtnClick(Sender: TObject);
    procedure PgRootBtnClick(Sender: TObject);
    procedure TempDirBtnClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    procedure Execute;
  end;

function ElphyOpt: TElphyOpt;

implementation
{$R *.DFM}

uses Matlab0;

var
  FElphyOpt: TElphyOpt;

function ElphyOpt: TElphyOpt;
begin
  if not assigned(FElphyOpt) then FElphyOpt:= TElphyOpt.create(nil);
  result:= FElphyOpt;
end;

procedure TElphyOpt.Execute;
var
  OldMem:integer;
  OldMatlabPath:AnsiString;
begin
  OldMem:= MemManagerSize;
  OldMatlabPath:= MatlabPath;

  esMatlab.setString(MatlabPath,255);
  esDataRoot.setString(UnicDataRoot,255);
  esPgRoot.setString(UnicPgRoot,255);
  esTempDir.setString(TempDirectory,255);

  cbManagedMem.setNumVar(MemManagerSize,t_longint);
  cbManagedMem.SetNumList(0,2048,64);

  cbCreateLog.setVar(GdebugMode);
  enLogCode.setVar(DebugCode,g_longint);
  enLogCode.setMinMax(0,255);


  
  {$IFDEF WIN64}
  FcudaVersion:=3;
  cbCudaVersion.setVar(FcudaVersion,g_longint,3);
  cbCudaVersion.setString(' Cuda 8.0');
  cbCudaVersion.enabled:=false;

  {$ELSE}
  FcudaVersion:=2;
  cbCudaVersion.setVar(FcudaVersion,g_longint,2);
  cbCudaVersion.setString(' Cuda 6.5 ');
  cbCudaVersion.enabled:=false;

  {$ENDIF}

  cbDirectXVersion.setVar(FdirectXVersion,g_longint,1);
  cbDirectXVersion.setString(' DirectX 9 | DirectX 9EX');




  if showModal=mrOK then
  begin
    updateAllVar(self);
    if OldMem <> MemManagerSize then messageCentral('You have to restart Elphy to use new memory parameters');
    if MatlabPath<>OldMatlabPath then resetMatlabTested;
  end;

end;

{$IF CompilerVersion>=22}
procedure TElphyOpt.MatlabButtonClick(Sender: TObject);
var
  stDir:String;
begin
  if selectDirectory(StDir,[],0)
    then ESmatlab.Text:=stDir;
end;

procedure TElphyOpt.DataRootBtnClick(Sender: TObject);
var
  stDir:String;
begin
  if selectDirectory(StDir,[],0)
    then ESdataRoot.Text:=stDir;
end;


procedure TElphyOpt.PgRootBtnClick(Sender: TObject);
var
  stDir:String;
begin
  if selectDirectory(StDir,[],0)
    then ESPgRoot.Text:=stDir;
end;


procedure TElphyOpt.TempDirBtnClick(Sender: TObject);
var
  stDir:String;
begin
  if selectDirectory(StDir,[],0)
    then ESTempDir.Text:=stDir;
end;
{$ELSE}
procedure TElphyOpt.MatlabButtonClick(Sender: TObject);
var
  stDir:AnsiString;
begin
  if selectDirectory('Choose Matlab Directory','',StDir)
    then ESmatlab.Text:=stDir;
end;


procedure TElphyOpt.DataRootBtnClick(Sender: TObject);
var
  stDir:AnsiString;
begin
  if selectDirectory('Choose DATAROOT Directory','',StDir)
    then ESdataRoot.Text:=stDir;
end;


procedure TElphyOpt.PgRootBtnClick(Sender: TObject);
var
  stDir:AnsiString;
begin
  if selectDirectory('Choose PGROOT Directory','',StDir)
    then ESPgRoot.Text:=stDir;
end;


procedure TElphyOpt.TempDirBtnClick(Sender: TObject);
var
  stDir:AnsiString;
begin
  if selectDirectory('Choose Temp Directory','',StDir)
    then ESTempDir.Text:=stDir;
end;

{$IFEND}

Initialization
AffDebug('Initialization ElphyOpt1',0);
{$IFDEF FPC}
{$I ElphyOpt1.lrs}
{$ENDIF}
end.
