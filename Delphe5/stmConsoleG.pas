unit stmConsoleG;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

  const
    maxBuf=1000;
  type
  TconsoleG = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Déclarations privées }
    buf: array[0..maxBuf] of AnsiString;
    Iread, Iwrite:integer;
    function read:AnsiString;
    procedure UpdateConsole;

  public
    { Déclarations publiques }

    procedure writeln(st:AnsiString);
    
  end;

var
  consoleG: TconsoleG;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

{ TconsoleG }

procedure TconsoleG.writeln(st: AnsiString);
begin
  buf[Iwrite mod maxBuf]:=st;
  inc(Iwrite);
end;

procedure TconsoleG.FormCreate(Sender: TObject);
begin
  ;
end;

procedure TconsoleG.FormDestroy(Sender: TObject);
begin
  ;
end;

function TconsoleG.read: AnsiString;
begin
  if Iread<Iwrite then
  begin
    result:=buf[Iread mod maxBuf];
    buf[Iread mod maxBuf]:='';
    inc(Iread);
  end;
end;

procedure TconsoleG.UpdateConsole;
begin
  while Iread<Iwrite do memo1.Lines.add(read);
end;

procedure TconsoleG.Timer1Timer(Sender: TObject);
begin
  UpdateConsole;
end;

Initialization
AffDebug('Initialization stmConsoleG',0);
{$IFDEF FPC}
{$I stmConsoleG.lrs}
{$ENDIF}
end.
