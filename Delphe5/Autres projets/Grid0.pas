unit Grid0;

interface

uses
  SysUtils, WinTypes, WinProcs, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, Grids,
  util1, ExtCtrls, StdCtrls, editcont;

type
  TArrayEditor = class(TForm)
    DrawGrid1: TDrawGrid;
    Panel1: TPanel;
    LigCol: TLabel;
    procedure DrawGrid1DrawCell(Sender: TObject; Col, Row: Longint;
      Rect: TRect; State: TGridDrawState);
    procedure FormCreate(Sender: TObject);
    procedure DrawGrid1SetEditText(Sender: TObject; ACol, ARow: Longint;
      const Value: String);
    procedure DrawGrid1SelectCell(Sender: TObject; Col, Row: Longint;
      var CanSelect: Boolean);
  private
    { Déclarations private }
  public
    { Déclarations public }
    tb:array[1..20,1..100] of float;
  end;

var
  ArrayEditor: TArrayEditor;

implementation

{$R *.DFM}

procedure TArrayEditor.DrawGrid1DrawCell(Sender: TObject; Col, Row: Longint;
  Rect: TRect; State: TGridDrawState);
var
  st:string;
  l:integer;
begin
  if (col=0) and (row<>0) then
    drawGrid1.canvas.TextOut(rect.left+1,rect.top+1,Istr(row))
  else
  if (col<>0) and (row=0) then
    drawGrid1.canvas.TextOut(rect.left+1,rect.top+1,Istr(col))
  else
  if (col<>0) and (row<>0) then
    begin
      st:=Estr(tb[col,row],3);
      l:=drawGrid1.canvas.TextWidth(st);
      drawGrid1.canvas.TextOut(rect.right-l-2,rect.top+1,st);
    end;
end;


procedure TArrayEditor.FormCreate(Sender: TObject);
var
  i,j:integer;
begin
  for i:=1 to 20 do
    for j:=1 to 100 do
      tb[i,j]:=i*1000+j;
  drawGrid1.rowCount:=100;
  drawGrid1.colCount:=20;

  with drawGrid1 do
  begin
    DefaultColWidth:=canvas.TextWidth('000000000000')+2;
    DefaultRowHeight:=canvas.TextHeight('0')+2;
  end;
end;

procedure TArrayEditor.DrawGrid1SetEditText(Sender: TObject; ACol,
  ARow: Longint; const Value: String);
var
  x:float;
  code:word;
begin
  val(value,x,code);
  if (code=0) and (Acol<>0) and (Arow<>0) then tb[Acol,Arow]:=x;
end;



procedure TArrayEditor.DrawGrid1SelectCell(Sender: TObject; Col,
  Row: Longint; var CanSelect: Boolean);
begin
  LigCol.caption:=Istr(col)+'/'+Istr(row);
end;

end.
