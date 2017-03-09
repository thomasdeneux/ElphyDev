unit RTlog1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,debug0;

type
  TRTcomLog = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;


function RTcomLog: TRTcomLog;

procedure RTlogWrite(st:AnsiString);

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FRTcomLog: TRTcomLog;

function RTcomLog: TRTcomLog;
begin
  if not assigned(FRTcomLog) then FRTcomLog:= TRTcomLog.create(nil);
  result:= FRTcomLog;
end;

procedure RTlogWrite(st:AnsiString);
begin
  if not RTcomLog.Visible then RTcomLog.show;
  RTcomLog.Memo1.Lines.Add(st);
end;

Initialization
AffDebug('Initialization RTlog1',0);
{$IFDEF FPC}
{$I RTlog1.lrs}
{$ENDIF}
end.
