unit editDBtable1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Types, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,Grids, FrameTable1, StdCtrls, ExtCtrls,

  util1,listG,NcDef2,stmObj, debug0, DBrecord1 ;



type
  TEditDBtable = class(TForm)
    TableFrame1: TTableFrame;
    Panel1: TPanel;
    Bprop: TButton;
    Binsert: TButton;
    Bdelete: TButton;
    Panel2: TPanel;
    BupdateDB: TButton;
    BackPanel: TPanel;
    procedure FormDestroy(Sender: TObject);
    procedure BpropClick(Sender: TObject);
    procedure TableFrame1DrawGrid1MouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
    DBtable:TypeUO;
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

    ExtraCols:integer;

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
    procedure CellDblClick(rect:Trect;x,y:integer);
    procedure CellMouseDownClick(rect:Trect;x,y:integer);

    procedure initTableFrame;

    


    procedure setColWidth(n:integer;w:integer);
    function getColWidth(n:integer):integer;

    procedure ColWidthChanged(n,w:integer);


  public
    buttonCell:TbuttonCell;

    FirstColVisible:boolean; { true si les numéros de ligne sont affichés }
    FirstRowVisible: boolean;
    Fbutton0: boolean;       { true si une colonne de boutons est affichée }

    OnSelectCell0: procedure (Acol,Arow:integer) of object;
    OnDblClickCell0: procedure (Acol,Arow:integer) of object;

    OnRightClickCell0: procedure (Acol,Arow:integer) of object;

    property Destroying: boolean read Fdestroying write SetDestroying;

    property FirstColWidth:integer read FfirstColWidth write FfirstColWidth;
    property ColumnWidths[n:integer]:integer read getColWidth write SetColWidth;



    procedure init(p:TypeUO);

    function CanEdit:boolean;

    // Fait passer des coordonnées grille aux coordonnées table en enlevant les lignes ou colonnes extra
    // On obtient des coo qui commencent à zéro.
    // C'est seulement dans le langage Elphy que les coo commencent à 1
    function GridColToTableCol(x:integer):integer;
    function GridRowToTableRow(y:integer):integer;

  end;



implementation


uses DBtable1;
{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

{ Acol, Arow sont les coordonnées dans la grille (commencent à 0)
  DBtable utilise des coordonnées commençant à 0 et ignore les lignes fixes
}
function TEditDBtable.getCell(ACol, ARow: Integer): Tcell;
var
  NumRowCol, ButtonCol: boolean;
  Atype: TGvariantType;
begin
  result:=nil;
  if DBtable=nil then exit;

  Acol:=GridColToTableCol(Acol);
  Arow:=GridRowToTableRow(Arow);

  NumRowCol:=(Acol=-1) and not Fbutton0 or (Acol=-2) and Fbutton0;
  ButtonCol:= Fbutton0 and (Acol=-1);

  if ButtonCol then
  begin
    if (Arow>=0)
      then result:=ButtonCell
      else result:=nil;
  end
  else
  if NumRowCol or (Arow=-1) then
  begin
    result:=lab;
    if (Arow>=0) and (Arow< TDBtable(DBtable).RowCount) then
    begin
      lab.color:=clBlack;
      lab.st:='Row '+Istr(Arow+1);
    end
    else
    if (Acol>=0) then lab.st:=TDBtable(DBtable).fields[Acol]
    else lab.st:='';
  end
  else
  begin
    Atype:=TDBtable(DBtable).ColType[Acol];
    case Atype of
      gvBoolean:  begin
                    result:=cellCB;
                    cellCB.setBxy:=setBxy;
                    cellCB.getBxy:=getBxy;
                  end;

      gvInteger:  begin
                    result:=cellNum;
                    cellNum.nbDeci:=0;
                    cellNum.setExy:=setExy;
                    cellNum.getExy:=getExy;
                  end;

      gvFloat:    begin
                    result:=cellNum;
                    cellNum.nbDeci:=3;
                    cellNum.setExy:=setExy;
                    cellNum.getExy:=getExy;
                  end;

      gvString:   begin
                    result:=cellString;
                    cellString.setStxy:=setStxy;
                    cellString.getStxy:=getStxy;
                  end;

      gvDateTime: begin
                    result:=cellString;
                    cellString.setStxy:=setStDateTime;
                    cellString.getStxy:=getStDateTime;
                  end;

    end;
  end;
end;

procedure TEditDBtable.initTableFrame;
begin
  if assigned(DBtable)
    then tableFrame1.init(TDBtable(DBtable).ColCount+ord(FirstColVisible)+ord(Fbutton0),
                          TDBtable(DBtable).RowCount+ord(FirstRowVisible),
                          ord(FirstColVisible){+ord(Fbutton0)},ord(FirstRowVisible),getCell)
    else tableFrame1.init(1,1,1,1,getCell);
end;


procedure TEditDBtable.init(p: TypeUO);
var
  i:integer;
begin
  DBtable:=p;

  if assigned(TDBtable(DBtable)) then
  begin
    tableFrame1.OnSelectCell:=CellSelection;
    tableFrame1.OnDblClickCell:=CellDblClick;
    tableFrame1.OnMouseDownCell:=CellMouseDownClick;
    tableFrame1.GetGridColor:= TDBtable(DBtable).getGridColor;
    InitTableFrame;
    if curRow>TDBtable(DBtable).RowCount then
    begin
      curRow:=0;
      TableFrame1.DrawGrid1.Row:=curRow;
    end;
  end
  else
    begin
      tableFrame1.OnSelectCell:=nil;
      tableFrame1.init(1,1,1,1,getCell);
      curRow:=0;
    end;
  decimalPlaces:=3;

  with TableFrame1.DrawGrid1 do
  begin
    ExtraCols:=ord(FirstColVisible)+ord(Fbutton0);
    if FirstColVisible then ColWidths[0]:=FirstColWidth;

    if Fbutton0 then
      if FirstColVisible  then
      begin
        if TableFrame1.DrawGrid1.ColCount>1 then TableFrame1.DrawGrid1.ColWidths[1]:=12;
      end
      else TableFrame1.DrawGrid1.ColWidths[0]:=12;

    for i:=ExtraCols to ColCount-1 do ColWidths[i]:=ColumnWidths[i-ExtraCols+1];
  end;
  invalidate;
end;


procedure TEditDBtable.FormDestroy(Sender: TObject);
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

function TEditDBtable.GridColToTableCol(x:integer):integer;
begin
  result:= x- ExtraCols;
end;

function TEditDBtable.GridRowToTableRow(y:integer):integer;
begin
  result:= y - ord(FirstRowVisible); //TableFrame1.DrawGrid1.FixedRows;
end;

function TEditDBtable.getBxy(x, y: integer): boolean;
begin
  x:=GridColToTableCol(x);
  y:=GridRowToTableRow(y);

  result:=TDBtable(DBtable).VBoolean[x,y];
end;

procedure TEditDBtable.setBxy(x, y: integer; w: boolean);
begin
  x:=GridColToTableCol(x);
  y:=GridRowToTableRow(y);

  TDBtable(DBtable).VBoolean[x,y]:= w;
end;


function TEditDBtable.getExy(x, y: integer): float;
var
  Atype:TGVariantType;
begin
  x:=GridColToTableCol(x);
  y:=GridRowToTableRow(y);

  Atype:=TDBtable(DBtable).ColType[x];

  case Atype of
    gvInteger:    result:= TDBtable(DBtable).Vinteger[x,y];
    gvFloat:      result:= TDBtable(DBtable).Vfloat[x,y];
    else result:=0;
  end;
end;

procedure TEditDBtable.setExy(x, y: integer; w: float);
var
    Atype:TGVariantType;
begin
  x:=GridColToTableCol(x);
  y:=GridRowToTableRow(y);

  Atype:=TDBtable(DBtable).ColType[x];

  case Atype of
    gvInteger:    TDBtable(DBtable).Vinteger[x,y]:=round(w);
    gvFloat:      TDBtable(DBtable).Vfloat[x,y]:=w;
  end;

end;


function TEditDBtable.getStxy(x, y: integer): AnsiString;
begin
  x:=GridColToTableCol(x);
  y:=GridRowToTableRow(y);

  result:= TDBtable(DBtable).Vstring[x,y];
end;

procedure TEditDBtable.setStxy(x, y: integer; w: AnsiString);
begin
  x:=GridColToTableCol(x);
  y:=GridRowToTableRow(y);

  TDBtable(DBtable).Vstring[x,y]:= w;
end;

procedure TEditDBtable.setStDateTime(x,y:integer;w:AnsiString);
begin
  x:=GridColToTableCol(x);
  y:=GridRowToTableRow(y);

  TDBtable(DBtable).VdateTime[x,y]:= StringToDateTime(w);
end;

function TEditDBtable.getStDateTime(x,y:integer):AnsiString;
begin
  x:=GridColToTableCol(x);
  y:=GridRowToTableRow(y);

  result:= DateTimeToString(TDBtable(DBtable).VdateTime[x,y]);
end;


procedure TEditDBtable.BpropClick(Sender: TObject);
begin
  TDBtable(DBtable).proprietes(sender);
end;

procedure TEditDBtable.CellSelection(x, y: integer);
begin
  x:=GridColToTableCol(x);
  y:=GridRowToTableRow(y);

  panel2.Caption:=Istr(x)+' / '+Istr(y);

  curRow:=y;

  if assigned(OnSelectCell0) then OnSelectCell0(x,y);
end;

procedure TeditDBTable.CellDblClick(rect:Trect;x,y:integer);
begin
  x:=GridColToTableCol(x);
  y:=GridRowToTableRow(y);

  if assigned(OnDblClickCell0) then OnDblClickCell0(x,y);
end;

procedure TeditDBTable.CellMouseDownClick(rect:Trect;x,y:integer);
begin
  x:=GridColToTableCol(x);
  y:=GridRowToTableRow(y);

  if assigned(OnRightClickCell0) then OnRightClickCell0(x,y);
end;



function TEditDBtable.CanEdit: boolean;
begin
  result:=TableFrame1.FcanEdit;
end;


procedure TEditDBtable.TableFrame1DrawGrid1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

    x1:=GridColToTableCol(x1);
    y1:=GridRowToTableRow(y1);

    if (y1<1) and (x>rect1.Left+3) and (x<rect1.Right-3)
       or
       (x1<1) and (y>rect1.top+3) and (y<rect1.bottom-3)
      then OnSelectCell0(x1,y1);
  end;
end;


procedure TEditDBtable.FormCreate(Sender: TObject);
begin
  cellCb:=TcheckBoxCell.create(tableFrame1);
  lab:=TlabelCell.create(tableFrame1);

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

  FirstColWidth:=100;
  tableFrame1.OnChangeColWidth:= ColWidthChanged;
end;


procedure TEditDBtable.setColWidth(n, w: integer);
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

procedure TEditDBtable.SetDestroying(w: boolean);
begin
  Fdestroying:=w;
  TableFrame1.Fdestroying:=w;
end;

function TEditDBtable.getColWidth(n: integer): integer;
begin
  if (n>=1) and (n<length(FColWidths))
    then result:=FcolWidths[n]
    else result:=TableFrame1.DrawGrid1.DefaultColWidth;
end;

procedure TEditDBtable.ColWidthChanged(n, w: integer);
begin
  n:=n-ExtraCols +1;
  SetColWidth(n,w);
end;

Initialization
AffDebug('Initialization edResultSet2',0);
{$IFDEF FPC}
{$I EdResultSet2.lrs}
{$ENDIF}
end.
