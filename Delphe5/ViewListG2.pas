unit ViewListG2;

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
  TgetALine=function (n:integer):AnsiString of object;




type
  TListGViewer = class(TForm)
    ListBox1: TListBox;
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    { Déclarations privées }
    getALine:TgetALine;
  public
    { Déclarations publiques }


    procedure setData(title:AnsiString;f:TgetAline;nb:integer);
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

{ TovcListGViewer }


procedure TListGViewer.setData(title:AnsiString;f: TgetAline; nb: integer);
var
  i:integer;
begin
  caption:=title;

  getAline:=f;


  with ListBox1 do
  begin
    items.BeginUpdate;
    items.Clear;
    for i:=1 to nb do items.add('');
    items.EndUpdate;
  end;

  { ListBox1.Count := nb;
    Lazarus ne connait pas Ondata , ni le style lbVirtual.


  }
  invalidate;
end;

procedure TListGViewer.ListBox1DrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);

begin
  with ListBox1.Canvas do
  begin
    FillRect(Rect);

    if assigned(getAline)
      then TextOut(Rect.Left + 4, Rect.Top, getAline(Index));
  end;
end;

Initialization
AffDebug('Initialization ViewListG2',0);
{$IFDEF FPC}
{$I ViewListG2.lrs}
{$ENDIF}
end.
