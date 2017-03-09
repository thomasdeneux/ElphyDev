unit EdResultSet2;

interface

uses
  Windows, Types, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Grids, FrameTable1, StdCtrls, ExtCtrls,
  ZClasses,ZdbcIntfs,
  util1,listG,NcDef2,stmObj,stmDataBase2,DBrecord1;



type
  TEditResultSet2 = class(TForm)
    TableFrame1: TTableFrame;
    Panel1: TPanel;
    Bprop: TButton;
    Binsert: TButton;
    Bdelete: TButton;
    Panel2: TPanel;
    BupdateDB: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure BpropClick(Sender: TObject);
    procedure BinsertClick(Sender: TObject);
    procedure BdeleteClick(Sender: TObject);
    procedure BupdateDBClick(Sender: TObject);
    procedure TableFrame1DrawGrid1MouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Déclarations privées }
    DBresultSet:TDBresultSet;
    decimalPlaces:integer;

    cellCb:TcheckBoxCell;
    Lab:TlabelCell;
    cellCombo:TcomboBoxCell;
    cellNum:TeditNumCell;
    cellString:TeditStringCell;
    colorCell:TcolorCell;
    buttonCell:TbuttonCell;

    curRow:integer;
    RowBuffer:TDBrecord;


    function getCell(ACol, ARow: Integer):Tcell;

    procedure setBxy(x,y:integer;w:boolean);
    function getBxy(x,y:integer):boolean;

    procedure setExy(x,y:integer;w:float);
    function getExy(x,y:integer):float;

    procedure setStxy(x,y:integer;w:string);
    function getStxy(x,y:integer):string;

    procedure CellSelection(x,y:integer);

    procedure initTableFrame;

  public

    OnSelectCell: procedure (Acol,Arow:integer) of object;
    { Déclarations publiques }
    UOdlg:typeUO;
    procedure init(p:TDBresultset);

    function FirstColVisible:boolean;
    function FirstRowVisible:boolean;
    function CanEdit:boolean;

    procedure SetColWidths(p:PtabLong);
    procedure GetColWidths(p:PtabLong);
  end;



implementation

{$R *.dfm}

function TEditResultSet2.getCell(ACol, ARow: Integer): Tcell;
var
  Ztype:TZSQLtype;
begin
  result:=nil;
  if DBresultSet=nil then exit;

  Acol:=Acol+1- TableFrame1.DrawGrid1.FixedCols;
  Arow:=Arow+1- TableFrame1.DrawGrid1.FixedRows;


  if (Acol=0) or (Arow=0) then
  begin
    result:=lab;
    if (Arow>0) and (Arow<DBresultset.RowCount) then
    begin
      DBresultSet.MoveTo(Arow);
      if DBresultset.resultSet.RowDeleted
        then lab.color:=clWhite
        else lab.color:=clBlack;
      lab.st:='Row '+Istr(Arow);
    end
    else
    if (Acol>0) then lab.st:=DBresultset.resultSet.GetMetadata.GetColumnLabel(Acol)
    else lab.st:='';
  end
  else
  begin
    Ztype:=DBresultset.resultSet.GetMetadata.GetColumnType(Acol);
    case Ztype of
      stBoolean:  begin
                    result:=cellCB;
                    cellCB.setBxy:=setBxy;
                    cellCB.getBxy:=getBxy;
                  end;

      stByte,stShort,stInteger,stLong: begin
                                         result:=cellNum;
                                         cellNum.nbDeci:=0;
                                         cellNum.setExy:=setExy;
                                         cellNum.getExy:=getExy;
                                       end;

      stFloat,stDouble,stBigDecimal:   begin
                                         result:=cellNum;
                                         cellNum.nbDeci:=2;
                                         cellNum.setExy:=setExy;
                                         cellNum.getExy:=getExy;
                                       end;

      stString, stUnicodeString,stAsciiStream, stUnicodeStream:
                                       begin
                                         result:=cellString;
                                         cellString.setStxy:=setStxy;
                                         cellString.getStxy:=getStxy;
                                       end;
    end;
  end;
end;

procedure TEditResultSet2.initTableFrame;
begin
  if assigned(DBresultSet)
    then tableFrame1.init(DBresultSet.ColCount+ord(FirstColVisible),
                          DBresultSet.RowCount+ord(FirstRowVisible),
                          ord(FirstColVisible),ord(FirstRowVisible),getCell)
    else tableFrame1.init(1,1,1,1,getCell);
end;


procedure TEditResultSet2.init(p: TDBresultset);
var
  i:integer;
begin
  DBresultSet:=p;

  if not assigned(cellCb) then cellCb:=TcheckBoxCell.create(tableFrame1);
  if not assigned(lab) then lab:=TlabelCell.create(tableFrame1);

  if not assigned(cellCombo) then cellCombo:=TcomboBoxCell.create(tableFrame1);
  cellCombo.tpNum:=g_longint;
  cellCombo.setOptions('Un|Deux|Trois');

  if not assigned(cellNum) then cellNum:=TeditNumCell.create(tableFrame1);
  cellNum.tpNum:=g_single;

  if not assigned(colorCell) then colorCell:=TcolorCell.create(tableFrame1);
  if not assigned(ButtonCell) then buttonCell:=TbuttonCell.create(tableFrame1);

  if not assigned(CellString) then cellString:=TeditStringCell.create(tableFrame1);

  if assigned(DBresultSet) then
  begin
    DBresultSet.InitRowBuffer(RowBuffer);
    tableFrame1.OnSelectCell:=CellSelection;
    InitTableFrame;
    if curRow>DBresultSet.RowCount then
    begin
      curRow:=1;
      TableFrame1.DrawGrid1.Row:=curRow;
    end;
    DBresultSet.loadRowBuffer(curRow,RowBuffer);
  end
  else
    begin
      tableFrame1.OnSelectCell:=nil;
      tableFrame1.init(1,1,1,1,getCell);
      curRow:=0;
    end;
  decimalPlaces:=3;


  {TableFrame1.FcanEdit:=false; pour tester }
  invalidate;
end;


procedure TEditResultSet2.FormDestroy(Sender: TObject);
var
  i:integer;
begin
  cellCb.Free;
  Lab.Free;
  cellCombo.Free;
  cellNum.Free;
  cellString.Free;
  colorCell.Free;
  buttonCell.Free;

  rowBuffer.free;
end;

function TEditResultSet2.getBxy(x, y: integer): boolean;
begin
  x:=x+1- TableFrame1.DrawGrid1.FixedCols;
  y:=y+1- TableFrame1.DrawGrid1.FixedRows;

  if DBresultSet.MoveTo(y)
    then result:=DBresultset.resultSet.GetBoolean(x)
    else result:=false;
end;

procedure TEditResultSet2.setBxy(x, y: integer; w: boolean);
begin
  x:=x+1- TableFrame1.DrawGrid1.FixedCols;
  y:=y+1- TableFrame1.DrawGrid1.FixedRows;

  if DBresultSet.MoveTo(y)
    then DBresultset.resultSet.UpdateBoolean(x,w);
end;


function TEditResultSet2.getExy(x, y: integer): float;
var
  Ztype:TZSQLtype;
begin
  x:=x+1- TableFrame1.DrawGrid1.FixedCols;
  y:=y+1- TableFrame1.DrawGrid1.FixedRows;

  Ztype:=DBresultset.resultSet.GetMetadata.GetColumnType(x);

  if y=curRow then
    case Ztype of
      stByte, stShort, stInteger, stLong:    result:=rowBuffer[x-1].VInteger;
      stFloat,stDouble,stBigDecimal:         result:=rowBuffer[x-1].Vfloat;
      else result:=0;
    end
  else
  if DBresultSet.MoveTo(y) and not DBresultset.resultSet.rowDeleted then
  case Ztype of
    stByte:          result:=DBresultset.resultSet.GetByte(x);
    stShort:         result:=DBresultset.resultSet.GetShort(x);
    stInteger:       result:=DBresultset.resultSet.GetInt(x);
    stLong:          result:=DBresultset.resultSet.GetLong(x);
    stFloat:         result:=DBresultset.resultSet.GetFloat(x);
    stDouble:        result:=DBresultset.resultSet.GetDouble(x);
    stBigDecimal:    result:=DBresultset.resultSet.GetBigDecimal(x);
  end
  else result:=0;
end;

procedure TEditResultSet2.setExy(x, y: integer; w: float);
var
  Ztype:TZSQLtype;
begin
  x:=x+1- TableFrame1.DrawGrid1.FixedCols;
  y:=y+1- TableFrame1.DrawGrid1.FixedRows;

  Ztype:=DBresultset.resultSet.GetMetadata.GetColumnType(x);

  if y=curRow then
    case Ztype of
      stByte, stShort, stInteger, stLong:    rowBuffer.Vinteger[x-1]:=round(w);
      stFloat,stDouble,stBigDecimal:         rowBuffer.VFloat[x-1]:=w;
    end;

end;


function TEditResultSet2.getStxy(x, y: integer): string;
begin
  x:=x+1- TableFrame1.DrawGrid1.FixedCols;
  y:=y+1- TableFrame1.DrawGrid1.FixedRows;

  if y=curRow then result:=rowBuffer[x-1].VString
  else
  if DBresultSet.MoveTo(y) and not DBresultset.resultSet.rowDeleted
    then result:=DBresultset.resultSet.GetString(x)
  else result:='';
end;

procedure TEditResultSet2.setStxy(x, y: integer; w: string);
begin
  x:=x+1- TableFrame1.DrawGrid1.FixedCols;
  y:=y+1- TableFrame1.DrawGrid1.FixedRows;

  if y=curRow then rowBuffer.VString[x-1]:=w;
end;


procedure TEditResultSet2.BpropClick(Sender: TObject);
begin
  DBresultSet.proprietes(sender);
end;

procedure TEditResultSet2.BinsertClick(Sender: TObject);
begin
  if not DBresultset.FcanInsert then exit;

  DBresultSet.resultSet.movetoInsertRow;

  TableFrame1.AppendRow;
end;

procedure TEditResultSet2.BdeleteClick(Sender: TObject);
begin
  if not DBresultset.FcanDelete then exit;

  if (curRow>=1) and (curRow<=DBresultSet.RowCount) then
  begin
    DBresultSet.deleteRow(curRow);
    TableFrame1.deleteRow;
    DBresultSet.loadRowBuffer(curRow,rowBuffer);
  end;

end;

procedure TEditResultSet2.CellSelection(x, y: integer);
begin
  x:=x+1- TableFrame1.DrawGrid1.FixedCols;
  y:=y+1- TableFrame1.DrawGrid1.FixedRows;

  panel2.Caption:=Istr(x)+' / '+Istr(y);

  if y<>curRow then
  begin
    if CanEdit and (curRow<>0) then
      if not DBresultSet.saveRowBuffer(curRow,rowBuffer) then TableFrame1.DeleteRow;
    curRow:=y;
    DBresultSet.LoadRowBuffer(curRow,rowBuffer);
  end;

  if assigned(OnSelectCell) then OnSelectCell(x,y);
end;



procedure TEditResultSet2.BupdateDBClick(Sender: TObject);
begin
  DBresultset.resultSet.GetStatement.GetConnection.Commit;
end;


function TEditResultSet2.FirstColVisible: boolean;
begin
  result:=TableFrame1.DrawGrid1.FixedCols>0;
end;

function TEditResultSet2.FirstRowVisible: boolean;
begin
  result:=TableFrame1.DrawGrid1.FixedRows>0;
end;

function TEditResultSet2.CanEdit: boolean;
begin
  result:=TableFrame1.FcanEdit;
end;

procedure TEditResultSet2.SetColWidths(p: PtabLong);
var
  i:integer;
begin
  with TableFrame1.DrawGrid1 do
  for i:=0 to ColCount-1 do
    ColWidths[i]:=p^[i];
end;

procedure TEditResultSet2.GetColWidths(p: PtabLong);
var
  i:integer;
begin
  with TableFrame1.DrawGrid1 do
  for i:=0 to ColCount-1 do
    p^[i]:=ColWidths[i];
end;



procedure TEditResultSet2.TableFrame1DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p:Tpoint;
begin
  {p:=TableFrame1.DrawGrid1.ClientToScreen(types.point(x,y));}
  TableFrame1.DrawGrid1.MouseToCell(X,y,x,y);

  x:=x+1- TableFrame1.DrawGrid1.FixedCols;
  y:=y+1- TableFrame1.DrawGrid1.FixedRows;


  if ((x=0) or (y=0)) and assigned(OnSelectCell) then OnSelectCell(x,y);
end;

end.
