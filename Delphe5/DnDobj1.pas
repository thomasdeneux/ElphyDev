unit DnDobj1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,
  debug0;

type
  TDragAndDropObject = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    Lname: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    function execution(stName:AnsiString;var st:AnsiString):boolean;
  end;

function DragAndDropObject: TDragAndDropObject;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FDragAndDropObject: TDragAndDropObject;

function DragAndDropObject: TDragAndDropObject;
begin
  if not assigned(FDragAndDropObject) then FDragAndDropObject:= TDragAndDropObject.create(nil);
  result:= FDragAndDropObject;
end;

function TDragAndDropObject.execution(stName:AnsiString;var st:AnsiString):boolean;
begin
  Lname.caption:=stName;
  memo1.text:=st;
  result:= (showModal=mrOK);

  if result then st:=memo1.text;

end;

Initialization
AffDebug('Initialization DnDobj1',0);
{$IFDEF FPC}
{$I DnDobj1.lrs}
{$ENDIF}
end.
