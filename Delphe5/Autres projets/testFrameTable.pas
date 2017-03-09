unit testFrameTable;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FrameTable1,
  util1;

type
  TTableFrameTest = class(TForm)
    TableFrame1: TTableFrame;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    tbB:array of boolean;
    tbOpt:array of integer;
    tbR:array of single;
    cols:array of integer;

    cellCb:TcheckBoxCell;
    Lab:TlabelCell;
    cellCombo:TcomboBoxCell;
    cellNum:TeditNumCell;
    colorCell:TcolorCell;
    buttonCell:TbuttonCell;
    function getCell(ACol, ARow: Integer):Tcell;
  end;

var
  TableFrameTest: TTableFrameTest;

implementation

{$R *.dfm}

{ TTableFrameTest }



procedure TTableFrameTest.FormCreate(Sender: TObject);
begin
  setLength(tbB,21);
  setLength(tbOpt,21);
  setLength(tbR,21);
  setLength(cols,21);

  cellCb:=TcheckBoxCell.create(tableFrame1);
  lab:=TlabelCell.create(tableFrame1);

  cellCombo:=TcomboBoxCell.create(tableFrame1);
  cellCombo.tpNum:=g_longint;
  cellCombo.setOptions('Un|Deux|Trois');

  cellNum:=TeditNumCell.create(tableFrame1);
  cellNum.tpNum:=g_single;

  colorCell:=TcolorCell.create(tableFrame1);
  buttonCell:=TbuttonCell.create(tableFrame1);

  with tableFrame1 do
  begin
    init(5,20,1,1,getCell);

  end;

end;

function TTableFrameTest.getCell(ACol, ARow: Integer):Tcell;
begin
  result:=nil;
  if (Acol=0) or (Arow=0) then
  begin
    result:=lab;
    if (Arow>0) and (Arow<tableFrame1.RowCount) then lab.st:='Row '+Istr(Arow)
    else
    if (Acol>0) then
    case Acol of
      0: lab.st:='';
      1: lab.st:='Param';
      2: lab.st:='Clamp';
      3: lab.st:='Min';
      4: lab.st:='Max';
    end;
  end
  else
  if Acol=1 then
  begin
    result:=cellCB;
    cellCB.AdData:=@tbB[Arow-1];
  end
  else
  if Acol=2 then
  begin
    result:=colorCell;
    colorCell.AdData:=@cols[Arow-1];
  end
  else
  if Acol=3 then
  begin
    result:=buttonCell;
    buttonCell.button.Caption:='Delete';
  end
  else
  begin
    result:=cellNum;
    cellNum.AdData:=nil;
    cellNum.getExy:=nil;
    cellNum.setExy:=nil;

    case Acol of
      2: cellNum.AdData:=@tbR[Arow-1];
      3: cellNum.AdData:=@tbR[Arow-1];
      4: cellNum.AdData:=@tbR[Arow-1];
    end;
  end;
end;


procedure TTableFrameTest.FormDestroy(Sender: TObject);
begin
  cellCB.free;
end;

end.
