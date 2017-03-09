unit EdResultSet2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  DateUtils,Types, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Grids, FrameTable1, StdCtrls, ExtCtrls,
  ZClasses,ZdbcIntfs,
  util1,listG,NcDef2,stmObj,stmDataBase2,DBrecord1, debug0;



type
  TEditResultSet2 = class(TForm)
    TableFrame1: TTableFrame;
    Panel1: TPanel;
    Bprop: TButton;
    Binsert: TButton;
    Bdelete: TButton;
    Panel2: TPanel;
    BackPanel: TPanel;
    procedure FormDestroy(Sender: TObject);
    procedure BpropClick(Sender: TObject);
    procedure BinsertClick(Sender: TObject);
    procedure BdeleteClick(Sender: TObject);
    procedure BupdateDBClick(Sender: TObject);
    procedure TableFrame1DrawGrid1MouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure TableFrame1DrawGrid1DblClick(Sender: TObject);
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


    curRow:integer;
    RowBuffer:TDBrecord;

    FFirstColWidth:integer;
    FcolWidths:array of integer;
    ExtraCols: integer;

    FcolHidden: array of boolean;
    GridColToSetCol: array of integer;

    Fdestroying: boolean;
    procedure SetDestroying(w: boolean);

    function getCell(ACol, ARow: Integer):Tcell;

    procedure setBxy(x,y:integer;w:boolean);
    function getBxy(x,y:integer):boolean;

    procedure setExy(x,y:integer;w:float);
    function getExy(x,y:integer):float;

    procedure setStxy(x,y:integer;w:AnsiString);
    function getStxy(x,y:integer):AnsiString;

    procedure setStDateTime(x,y:integer;w:AnsiString);
    function getStDateTime(x,y:integer):AnsiString;

    procedure CellSelection(x,y:integer);
    procedure CellDblClick(rect:Trect; x,y:integer);


    procedure initTableFrame;

    function GridRowToSetRow(y:integer):integer;

    procedure setColWidth(n:integer;w:integer);
    function getColWidth(n:integer):integer;

    procedure setColHidden(n:integer;w:boolean);
    function getColHidden(n:integer):boolean;


    procedure ColWidthChanged(n,w:integer);

  public
    buttonCell:TbuttonCell;

    FirstColVisible:boolean; { true si les numéros de ligne sont affichés }
    FirstRowVisible:boolean; { true si les noms de colonne sont affichés }

    Fbutton0: boolean;       { true si une colonne de boutons est affichée }

    OnSelectCell0: procedure (Acol,Arow:integer) of object;
    OnDblClickCell0: procedure (Acol,Arow:integer) of object;

    property FirstColWidth:integer read FfirstColWidth write FfirstColWidth;
    property ColumnWidths[n:integer]:integer read getColWidth write SetColWidth;
    property ColHidden[n:integer]:boolean read getColHidden write SetColHidden;   // n commence à 1

    property Destroying: boolean read Fdestroying write SetDestroying;
    procedure init(p:TDBresultset);

    function CanEdit:boolean;

  end;



implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

{ Acol, Arow sont les coordonnées dans la grille (commencent à 0)
  resultset utilise des coordonnées commençant à 1 et ignore les lignes fixes
}
function TEditResultSet2.getCell(ACol, ARow: Integer): Tcell;
var
  Ztype:TZSQLtype;
  NumRowCol, ButtonCol: boolean;
begin
  result:=nil;
  if DBresultSet=nil then exit;

  Acol:=GridColToSetCol[Acol];
  Arow:=GridRowToSetRow(Arow);

//  NumRowCol:=(Acol=0) and not Fbutton0 or (Acol=-1) and Fbutton0;
//  ButtonCol:= Fbutton0 and (Acol=0);

  if Acol=-2 then
  begin
    if (Arow>0)
      then result:=ButtonCell
      else result:=nil;
  end
  else
  if (Acol=-1) or (Arow=0) then
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

      stTime, stDate, stTimeStamp:     begin
                                         result:=cellString;
                                         cellString.setStxy:=setStDateTime;
                                         cellString.getStxy:=getStDateTime;
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
var
  i,k,n:integer;
begin
  if assigned(DBresultSet) then
  begin
    ExtraCols:=ord(FirstColVisible)+ord(Fbutton0);
    setLength(gridColToSetCol,DBresultset.ColCount + ExtraCols);

    k:=0;
    if FirstColVisible then
    begin
      gridColToSetCol[k]:=-1;
      inc(k);
    end;
    if Fbutton0 then
    begin
      gridColToSetCol[k]:=-2;
      inc(k);
    end;

    for i:=1 to DBresultset.ColCount do
    if not colHidden[i] then
    begin
      gridColToSetCol[k]:=i;
      inc(k);
    end;

    tableFrame1.init(k+ord(FirstColVisible)+ord(Fbutton0),
                     DBresultSet.RowCount+ord(FirstRowVisible),
                     ord(FirstColVisible),ord(FirstRowVisible),getCell);
  end
  else tableFrame1.init(1,1,1,1,getCell);
end;


procedure TEditResultSet2.FormCreate(Sender: TObject);
begin
  FirstColWidth:=100;
  FirstRowVisible:=true;

  tableFrame1.OnChangeColWidth:= ColWidthChanged;

  lab:=TlabelCell.create(tableFrame1);

  cellCb:=TcheckBoxCell.create(tableFrame1);

  cellCombo:=TcomboBoxCell.create(tableFrame1);
  cellCombo.tpNum:=g_longint;
  cellCombo.setOptions('Un|Deux|Trois');

  cellNum:=TeditNumCell.create(tableFrame1);
  cellNum.tpNum:=g_single;

  colorCell:=TcolorCell.create(tableFrame1);

  buttonCell:=TbuttonCell.create(tableFrame1);
  buttonCell.button.Caption:='.';
  buttonCell.AlwaysEdit:=true;

  cellString:=TeditStringCell.create(tableFrame1);

end;




procedure TEditResultSet2.init(p: TDBresultset);
var
  i:integer;
begin
  DBresultSet:=p;

  if assigned(DBresultSet) then
  begin
    DBresultSet.InitRowBuffer(RowBuffer);
    tableFrame1.OnSelectCell:=CellSelection;
    tableFrame1.OnDblClickCell:=CellDblClick;

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

  ExtraCols:=ord(FirstColVisible)+ord(Fbutton0);

  with TableFrame1.DrawGrid1 do
  begin
    if FirstColVisible then ColWidths[0]:=FirstColWidth;

    if Fbutton0 then
      if FirstColVisible then
      begin
        if TableFrame1.DrawGrid1.ColCount>1 then TableFrame1.DrawGrid1.ColWidths[1]:=12;
      end
      else TableFrame1.DrawGrid1.ColWidths[0]:=12;

    for i:=ExtraCols to ColCount-1 do ColWidths[i]:=ColumnWidths[i-ExtraCols+1];
  end;
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


function TEditResultSet2.GridRowToSetRow(y:integer):integer;
begin
  result:= y+1- TableFrame1.DrawGrid1.FixedRows;
end;

function TEditResultSet2.getBxy(x, y: integer): boolean;
begin
  x:=GridColToSetCol[x];
  y:=GridRowToSetRow(y);

  if DBresultSet.MoveTo(y)
    then result:=DBresultset.resultSet.GetBoolean(x)
    else result:=false;
end;

procedure TEditResultSet2.setBxy(x, y: integer; w: boolean);
begin
  x:=GridColToSetCol[x];
  y:=GridRowToSetRow(y);

  if DBresultSet.MoveTo(y)
    then DBresultset.resultSet.UpdateBoolean(x,w);
end;


function TEditResultSet2.getExy(x, y: integer): float;
var
  Ztype:TZSQLtype;
begin
  x:=GridColToSetCol[x];
  y:=GridRowToSetRow(y);

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
  x:=GridColToSetCol[x];
  y:=GridRowToSetRow(y);

  Ztype:=DBresultset.resultSet.GetMetadata.GetColumnType(x);

  if y=curRow then
    case Ztype of
      stByte, stShort, stInteger, stLong:    rowBuffer.Vinteger[x-1]:=round(w);
      stFloat,stDouble,stBigDecimal:         rowBuffer.VFloat[x-1]:=w;
    end;

end;


function TEditResultSet2.getStxy(x, y: integer): AnsiString;
begin
  x:=GridColToSetCol[x];
  y:=GridRowToSetRow(y);

  if y=curRow then result:=rowBuffer[x-1].VString
  else
  if DBresultSet.MoveTo(y) {and not DBresultset.resultSet.rowDeleted}
    then result:=DBresultset.resultSet.GetString(x)
  else result:='';
end;

procedure TEditResultSet2.setStxy(x, y: integer; w: AnsiString);
begin
  x:=GridColToSetCol[x];
  y:=GridRowToSetRow(y);

  if y=curRow then
  begin
    if y=2 then messageCentral('==>'+w);
    rowBuffer.VString[x-1]:=w;
  end;
end;


procedure TEditResultSet2.setStDateTime(x,y:integer;w:AnsiString);
begin
  x:=GridColToSetCol[x];
  y:=GridRowToSetRow(y);

  if y=curRow then rowBuffer.VdateTime[x-1]:= StringToDateTime(w);
end;

function TEditResultSet2.getStDateTime(x,y:integer):AnsiString;
begin
  x:=GridColToSetCol[x];
  y:=GridRowToSetRow(y);

  if y=curRow then result:= DateTimeToString(rowBuffer[x-1].VdateTime)
  else
  if DBresultSet.MoveTo(y) and not DBresultset.resultSet.rowDeleted
    then result:=DBresultset.resultSet.GetString(x)
  else result:='';
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
  x:=GridColToSetCol[x];
  y:=GridRowToSetRow(y);

  panel2.Caption:=Istr(x)+' / '+Istr(y);

  if y<>curRow then
  begin
    if CanEdit and (curRow<>0) then
      if not DBresultSet.saveRowBuffer(curRow,rowBuffer)
        then TableFrame1.DeleteRow;
    curRow:=y;
    DBresultSet.LoadRowBuffer(curRow,rowBuffer);
  end;

  if assigned(OnSelectCell0) then OnSelectCell0(x,y);
end;

procedure TEditResultSet2.CellDblClick(rect: Trect; x, y: integer);
begin
  x:=GridColToSetCol[x];
  y:=GridRowToSetRow(y);

  if assigned(OnDblClickCell0) then OnDblClickCell0(x,y);
end;


procedure TEditResultSet2.BupdateDBClick(Sender: TObject);
begin
  DBresultset.resultSet.GetStatement.GetConnection.Commit;
end;


function TEditResultSet2.CanEdit: boolean;
begin
  result:=TableFrame1.FcanEdit;
end;


procedure TEditResultSet2.TableFrame1DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p:Tpoint;
  rect1: Trect;
  x1,y1:integer;
begin
{ Les lignes ou colonnes fixes ne sont pas concernées par TdrawGrid.OnSelectCell
  On utilise donc OnMouseUp
  Toutefois, on ne fait rien si on a cliqué sur les bords pour modifier la taille des cellules
}
  if assigned(OnSelectCell0) then
  begin
    TableFrame1.DrawGrid1.MouseToCell(x,y,x1,y1);

    rect1:=TableFrame1.DrawGrid1.CellRect(x1,y1);

    x1:=GridColToSetCol[x1];
    y1:=GridRowToSetRow(y1);

    if (y1<1) and (x>rect1.Left+3) and (x<rect1.Right-3)
       or
       (x1<1) and (y>rect1.top+3) and (y<rect1.bottom-3)
      then OnSelectCell0(x1,y1);
  end;
end;


procedure TEditResultSet2.setColWidth(n, w: integer);
var
  i,len:integer;
begin
   if (n>=1) and (n<2000) then
   begin
     if n>=length(FColWidths) then
     begin
       len:=length(FColWidths);
       setLength(FcolWidths,n+1);

       for i:=len to high(FcolWidths) do FcolWidths[i]:=TableFrame1.DrawGrid1.DefaultColWidth;
     end;

     FcolWidths[n]:=w;
   end;
end;

procedure TEditResultSet2.SetDestroying(w: boolean);
begin
   Fdestroying:=w;
   TableFrame1.Fdestroying:=w;
end;

function TEditResultSet2.getColWidth(n: integer): integer;
begin
  if (n>=1) and (n<length(FColWidths))
    then result:=FcolWidths[n]
    else result:=TableFrame1.DrawGrid1.DefaultColWidth;
end;


procedure TEditResultSet2.setColHidden(n: integer;w:boolean);
var
  i,len:integer;
begin
   if (n>=1) and (n<2000) then
   begin
     if n>=length(FColHidden) then
     begin
       len:=length(FColHidden);
       setLength(FcolHidden,n+1);

       for i:=len to high(FcolHidden) do FcolHidden[i]:=false;
     end;

     FcolHidden[n]:=w;
   end;
end;

function TEditResultSet2.getColHidden(n: integer): boolean;
begin
  if (n>=1) and (n<length(FColHidden))
    then result:=FcolHidden[n]
    else result:=false;
end;

procedure TEditResultSet2.ColWidthChanged(n, w: integer);
begin
  n:=n-ExtraCols +1;
  SetColWidth(n,w);
end;


procedure TEditResultSet2.TableFrame1DrawGrid1DblClick(Sender: TObject);
begin
  TableFrame1.DrawGrid1DblClick(Sender);

end;


Initialization
AffDebug('Initialization edResultSet2',0);
{$IFDEF FPC}
{$I EdResultSet2.lrs}
{$ENDIF}
end.
