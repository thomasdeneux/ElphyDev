unit DDopt1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, debug0;

type
  TDD1322Options = class(TForm)
    cbTagStart: TCheckBoxV;
    BOK: TButton;
    Bcancel: TButton;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    p0:pointer;
  public
    { Public declarations }
    procedure execution(p:pointer);
  end;

function DD1322Options: TDD1322Options;

implementation

uses DD1322brd;
{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FDD1322Options: TDD1322Options;

function DD1322Options: TDD1322Options;
begin
  if not assigned(FDD1322Options) then FDD1322Options:= TDD1322Options.create(nil);
  result:= FDD1322Options;
end;


procedure TDD1322Options.execution(p:pointer);
begin
  p0:=p;
  cbTagStart.setVar(TDD1322interface(p).FuseTagStart);
  if showModal=mrOK then updateAllvar(self);
end;

procedure TDD1322Options.Button1Click(Sender: TObject);
begin
  TDD1322interface(p0).Calibrate;
end;

procedure TDD1322Options.Button2Click(Sender: TObject);
begin
  TDD1322interface(p0).DisplayInfo;
end;

Initialization
AffDebug('Initialization DDopt1',0);
{$IFDEF FPC}
{$I DDopt1.lrs}
{$ENDIF}
end.
