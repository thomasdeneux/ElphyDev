unit saveObj1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont,debug0;

type
  TSaveObjectDialog = class(TForm)
    GroupBox1: TGroupBox;
    Memo1: TMemo;
    cbAppend: TCheckBoxV;
    Bok: TButton;
    Bcancel: TButton;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function execution(var stCom:AnsiString;var Fappend:boolean):boolean;
  end;

function SaveObjectDialog: TSaveObjectDialog;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FSaveObjectDialog: TSaveObjectDialog;

function SaveObjectDialog: TSaveObjectDialog;
begin
  if not assigned(FSaveObjectDialog) then FSaveObjectDialog:= TSaveObjectDialog.create(nil);
  result:= FSaveObjectDialog;
end;

function TSaveObjectDialog.execution(var stCom:AnsiString;var Fappend:boolean):boolean;
begin
  cbAppend.setvar(Fappend);
  memo1.text:=stCom;
  result:=(showModal=mrOK);

  if result then
    begin
      updateAllVar(self);
      stCom:=memo1.text;
    end;
end;

Initialization
AffDebug('Initialization saveObj1',0);
{$IFDEF FPC}
{$I saveObj1.lrs}
{$ENDIF}
end.
