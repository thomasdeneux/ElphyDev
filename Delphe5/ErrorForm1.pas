unit ErrorForm1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, grids, FrameTable1,
  util1;

type
  TErrorForm = class(TForm)
    TableFrame1: TTableFrame;
    Panel1: TPanel;
    BClear: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BClearClick(Sender: TObject);
  private
    { Déclarations privées }
    lab1: TlabelCell;
    function getCell(ACol, ARow: Integer): Tcell;
    procedure DoubleClick(rectCell:Trect;col1,row1:integer);
  public
    { Déclarations publiques }
    procedure SetLineCount(n:integer);
  end;


function ErrorForm: TErrorForm;

implementation

uses stmdef, ncdef2, stmPG,stmFifoError;
{$R *.dfm}


var
  ErrorForm0: TErrorForm;

function ErrorForm: TErrorForm;
begin
  if not assigned(ErrorForm0) then ErrorForm0:= TErrorForm.Create(nil);
  result:=ErrorForm0;
end;

function TErrorForm.getCell(ACol, ARow: Integer): Tcell;
var
  stError, stFile: String;
  ErrorLine,AdError, k: integer;
begin

  result:=lab1;
  lab1.st:='';

  if (Arow=0) then
  begin
    result:=lab1;
    case Acol of
      1: lab1.st:= ' Ad';
      2: lab1.st:= ' File';
      3: lab1.st:= ' Line';
      4: lab1.st:= ' Error';
    end;
  end
  else
  if Acol=0 then lab1.st:=Istr(Arow)
  else
  if Acol in [1..4] then
  begin
    stError:=fifoError.getLine(Arow-1,stFile,ErrorLine,AdError);
    case Acol of
      1: lab1.st:= Istr(AdError);
      2: lab1.st:= stFile;
      3: lab1.st:= Istr(ErrorLine);
      4: begin
           k:=pos(#10#13,stError);
           if k>0 then
           begin
             stError[k]:=' ';
             stError[k+1]:=' ';
           end;
           lab1.st:= stError;
         end;
    end;

  end;
end;


procedure TErrorForm.FormCreate(Sender: TObject);
begin
  lab1:=TlabelCell.create(tableFrame1);

  with tableFrame1 do
  begin
    init(5,20,1,1,getCell);

    FcanEdit:=false;

    with drawGrid1 do
    begin
      Options:= Options+[goRowSelect];
      colWidths[0]:=50;
      colWidths[1]:=50;
      colWidths[2]:=300;
      colWidths[3]:=50;
      colWidths[4]:=400;

      self.Width:= 850;
    end;
    OnDblClickCell:= DoubleClick;
  end;

  
end;

procedure TErrorForm.SetLineCount(n: integer);
begin
  tableFrame1.init(5,n+1,1,1,getCell);
  tableFrame1.drawgrid1.Row:=n;
end;

procedure TErrorForm.BClearClick(Sender: TObject);
begin
  fifoError.ClearMessages;
end;

procedure TErrorForm.DoubleClick(rectCell: Trect; col1, row1: integer);
var
  stFile,stError:string;
  ErrorLine, AdError: integer;
begin
  stError:=fifoError.getLine(row1-1,stFile,ErrorLine,AdError);

  if assigned(dacPg) then Tpg2(dacPg).ShowFile(stFile,ErrorLine);


end;

end.
