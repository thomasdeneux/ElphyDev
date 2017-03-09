unit ChooseTopic1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,
  debug0;

type
  TChooseTopic = class(TForm)
    ListBox1: TListBox;
    BOK: TButton;
    Bcancel: TButton;
    procedure ListBox1DblClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    function execution(stList:TstringList):AnsiString;
  end;

function ChooseTopic: TChooseTopic;

implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FChooseTopic: TChooseTopic;

function ChooseTopic: TChooseTopic;
begin
  if not assigned(FChooseTopic) then FChooseTopic:= TChooseTopic.create(nil);
  result:= FChooseTopic;
end;

{ TForm2 }

function TChooseTopic.execution(stList: TstringList): AnsiString;
begin
  if not assigned(stList) or (stList.Count=0) then result:=''
  else
  if stList.count=1 then result:=stList[0]
  else
  begin
    listBox1.Items.text:=stList.text;
    result:='';

    if showModal=mrOK then
      if listBox1.itemIndex>=0
        then result:=listBox1.Items[listBox1.itemIndex];
  end;

end;

procedure TChooseTopic.ListBox1DblClick(Sender: TObject);
begin
  modalResult:=mrOK;
end;

Initialization
AffDebug('Initialization chooseTopic1',0);
{$IFDEF FPC}
{$I ChooseTopic1.lrs}
{$ENDIF}
end.
