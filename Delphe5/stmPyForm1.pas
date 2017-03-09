unit stmPyForm1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, PythonEngine, PythonGUIInputOutput,

  stmDef,stmObj,stmPython1, debug0;

type
  TPythonForm = class(TForm)
    Panel1: TPanel;
    MemoSource: TMemo;
    Splitter1: TSplitter;
    MemoOutput: TMemo;
    Bload: TButton;
    Bsave: TButton;
    Bexecute: TButton;
    PythonEngine1: TPythonEngine;
    PythonGUIInputOutput1: TPythonGUIInputOutput;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure BloadClick(Sender: TObject);
    procedure BsaveClick(Sender: TObject);
    procedure BexecuteClick(Sender: TObject);
  private
    { Déclarations privées }
    owner0:TpythonEng;
  public
    { Déclarations publiques }

    procedure init(owner:TPythonEng);
  end;


var
  PythonForm:TpythonForm;
    
implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

{ TPythonForm }

procedure TPythonForm.init(owner: TPythonEng);
begin
  owner0:=owner;
  memoSource.Clear;
  memoOutput.Clear;
end;

procedure TPythonForm.BloadClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    begin
      owner0.fileName:=OpenDialog1.fileName;
      MemoSource.Lines.LoadFromFile( owner0.FileName );
    end;
end;

procedure TPythonForm.BsaveClick(Sender: TObject);
begin
  with SaveDialog1 do
  begin
    if Execute then
      MemoOutput.Lines.SaveToFile( FileName );
  end;
end;

procedure MaskFPUExceptions(ExceptionsMasked : boolean);
begin
  if ExceptionsMasked then
    Set8087CW($1332 or $3F)
  else
    Set8087CW($1332);
end;


procedure TPythonForm.BexecuteClick(Sender: TObject);
begin
  owner0.Execute( MemoSource.Lines );
end;

Initialization
AffDebug('Initialization stmPyForm1',0);
{$IFDEF FPC}
{$I stmPyForm1.lrs}
{$ENDIF}
end.
