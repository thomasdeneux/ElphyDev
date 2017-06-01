unit FrameTable1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  {$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ExtCtrls,
  editCont,util1,selectCells1,
  debug0;

type
  Tcell = class;

  TgetCell=function (Acol,Arow:integer):Tcell of object;
  TselectCell=procedure (Acol,Arow:integer) of object;
  TDblClickCell=procedure(rectCell:Trect;col1,row1:integer) of object;
  TchangeColWidth=procedure(n,w:integer) of object;

  TTableFrame = class(TFrame)
    DrawGrid1: TDrawGrid;
    ColorDialog1: TColorDialog;
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure DrawGrid1TopLeftChanged(Sender: TObject);
    procedure DrawGrid1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DrawGrid1DblClick(Sender: TObject);
  private
    { Déclarations privées }
    curCell:Tcell;
    DefaultCell:Tcell;
    getCell:TgetCell;

    FcolW: array of integer;

    procedure setColW(n:integer;w:integer);
    function getColW(n:integer):integer;
    property ColW[n:integer]:integer read getColW write SetColW;

    function cell(Acol,Arow:integer):Tcell;
    procedure SetCanvasDefault(state: TGridDrawState );
    function GetGridColorDefault(state:TGridDrawState): integer;
  public
    { Déclarations publiques }
    OnSelectCell:TselectCell;
    OnDblClickCell:TDblClickCell;
    OnMouseDownCell:TDblClickCell;
    OnChangeColWidth: TChangeColWidth;
    FcanEdit:boolean;

    Fdestroying: boolean;
    GetGridColor: function (col,row:integer;Fsel:boolean):integer of object;

    constructor create(owner:Tcomponent);override;
    procedure init(Ncol,Nrow,NfixCol,NfixRow:integer;func:TgetCell);

    function SumOfWidths:integer;
    procedure invalidate;override;

    function selectGroup:boolean;

    function rowCount:integer;
    function ColCount:integer;

    procedure AppendRow;
    procedure DeleteRow;
  end;

  TinitCell=procedure (Acol,Arow:integer) of object;

  Tcell=class
          frame:TtableFrame;
          colG,rowG:integer;
          colEdit,rowEdit:integer;
          AlwaysEdit: boolean; // true pour les boutons permanents

          constructor create(Frame1:TtableFrame);

          procedure Draw(rect:Trect;State: TGridDrawState);virtual;
          procedure Edit(rect:Trect);virtual;
          procedure HideEdit;virtual;

          procedure invalidate;virtual;
        end;

  TcellClass=class of Tcell;


  TsetBxy=procedure(col,row:integer;x:boolean) of object;
  TgetBxy=function(col,row:integer):boolean  of object;

  TcheckBoxCell=class(Tcell)
          CB:TcheckBoxV;
          Align: TAlignment;
          AdData:Pboolean;

        private
          procedure setE(x:boolean;data1:pointer);
          function getE(data1:pointer):boolean;

        public
          setBxy:TsetBxy;
          getBxy:TgetBxy;

          constructor create(Frame1:TtableFrame);
          procedure Draw(rect:Trect;State: TGridDrawState);override;
          procedure Edit(rect:Trect);override;
          procedure HideEdit;override;
          procedure invalidate;override;
        end;

  TlabelCell=class(Tcell)
          st:AnsiString;
          color:integer;
          procedure Draw(rect:Trect;State: TGridDrawState);override;
          procedure Edit(rect:Trect);override;
        end;

  TcomboBoxCell=class(Tcell)
          CB:TcomboBoxV;
          tpNum:typetypeG;
          num1:integer;
          AdData:pointer;

          constructor create(Frame1:TtableFrame);
          procedure setOptions(st:AnsiString);overload;               { ex: 'UN|DEUX|TROIS'}
          procedure setOptions(var tb;long,nb:integer);overload;  { tableau de chaînes courtes }
          procedure SetOptions(n1,n2,step:integer);overload;      { suite de nombres }
          procedure SetOptions(list:TstringList);overload;        { stringList }

          procedure Draw(rect:Trect;State: TGridDrawState);override;
          procedure Edit(rect:Trect);override;
          procedure HideEdit;override;
          procedure invalidate;override;
        end;


  TsetStxy=procedure(col,row:integer;x:AnsiString) of object;
  TgetStxy=function(col,row:integer):AnsiString  of object;

  TEditStringCell=class(Tcell)
          AdData:pointer;
          setStxy:TsetStxy;
          getStxy:TgetStxy;

          editString:TeditString;

          procedure setE(x:AnsiString;data1:pointer);
          function getE(data1:pointer):AnsiString;

          constructor create(Frame1:TtableFrame);

          procedure Draw(rect:Trect;State: TGridDrawState);override;
          procedure Edit(rect:Trect);override;
          procedure HideEdit;override;

          procedure EditonKeyDw(Sender: TObject; var Key: Word; Shift: TShiftState);
          procedure EditOnChange(Sender: TObject);
          procedure invalidate;override;
        end;


  TsetExy=procedure(col,row:integer;x:float) of object;
  TgetExy=function(col,row:integer):float  of object;

  TEditNumCell=class(Tcell)
          AdData:pointer;
          setExy:TsetExy;
          getExy:TgetExy;

          editNum:TeditNum;
          tpNum:typetypeG;
          mini,maxi:float;
          nbDeci:integer;

          procedure setE(x:float;data1:pointer);
          function getE(data1:pointer):float;

          constructor create(Frame1:TtableFrame);

          procedure Draw(rect:Trect;State: TGridDrawState);override;
          procedure Edit(rect:Trect);override;
          procedure HideEdit;override;

          procedure EditonKeyDw(Sender: TObject; var Key: Word; Shift: TShiftState);
          procedure EditOnChange(Sender: TObject);
          procedure invalidate;override;
        end;

  TUserOnClick=procedure(ACol,ARow:integer) of object;

  TcolorCell=class(Tcell)
          AdData:Pinteger;
          button:Tbutton;
          OnColorChanged:TUserOnClick;

          constructor create(Frame1:TtableFrame);

          procedure Draw(rect:Trect;State: TGridDrawState);override;
          procedure Edit(rect:Trect);override;
          procedure HideEdit;override;

          procedure ColorOnClick(sender:Tobject);
        end;




  TbuttonCell=class(Tcell)
          button:Tbutton;
          UserOnClick:TuserOnClick;

          constructor create(Frame1:TtableFrame);

          procedure Draw(rect:Trect;State: TGridDrawState);override;
          procedure Edit(rect:Trect);override;
          procedure HideEdit;override;

          procedure ButtonOnClick(sender:Tobject);
        end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}



{ TTableFrame }

function TTableFrame.cell(Acol, Arow: integer): Tcell;
begin
  if assigned(getCell)
    then result:=getcell(Acol,Arow)
    else result:=nil;
  if not assigned(result)
    then result:=DefaultCell;
  result.colG:=Acol;
  result.rowG:=Arow;
end;

constructor TTableFrame.create(owner: Tcomponent);
begin
  inherited;
  DefaultCell:=Tcell.create(self);
  FcanEdit:=true;
end;

procedure TTableFrame.SetCanvasDefault(state: TGridDrawState);
begin
  with drawGrid1.canvas do
  begin
    TextFlags:=TextFlags or ETO_OPAQUE;
    pen.Style:=psSolid;
    brush.Style:=bsSolid;

    pen.Color:=clBlack;
    font.Color:=clBlack;
  end;
end;

function TtableFrame.GetGridColorDefault(state:TGridDrawState): integer;
begin
  if {$IFDEF DELPHE_XE}(gdRowSelected in state) or {$ENDIF} (gdSelected in state)
    then  result:=rgb(50,230,230)
  else
  if gdFixed in state then result:=rgb(190,190,190)

  else result:=rgb(230,230,230);
end;


procedure TTableFrame.DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  frm:Tcustomform;
  TheCell:Tcell;
  w:integer;
begin
  if Fdestroying then exit;

  frm:=getParentForm(self);
  if not assigned(frm) or not frm.visible then exit;

  SetCanvasDefault(state);

  if assigned(GetGridColor)
    then drawgrid1.Canvas.Brush.Color:=GetGridColor(Acol,Arow, {$IFDEF DELPHE_XE}(gdRowSelected in state) or {$ENDIF} (gdSelected in state))
    else drawgrid1.Canvas.Brush.Color:=GetGridColorDefault(state);

  TheCell:=cell(Acol,Arow);
  if (Acol=drawGrid1.Col) and (Arow=drawGrid1.Row) and ( FcanEdit or TheCell.AlwaysEdit) then
  begin
    if assigned(curCell) then curCell.hideEdit;
    curcell:=TheCell;
    Curcell.edit(rect);
  end
  else TheCell.draw(rect,state);

  w:= rect.Right-rect.Left;
  if assigned(OnChangeColWidth) and (w<>colW[Acol]) then OnChangeColWidth(Acol, w);
  colW[Acol]:=w;
end;

procedure TTableFrame.DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
  frm:Tcustomform;
  TheCell:Tcell;
begin
  if Fdestroying then exit;

  frm:=getParentForm(self);
  if not assigned(frm) or not frm.visible then exit;

  if assigned(OnSelectCell) then OnSelectCell(Acol,Arow);

  if assigned(curCell) then curCell.hideEdit;
  TheCell:=cell(Acol,Arow);
  if FcanEdit or TheCell.AlwaysEdit  then
  begin
    curcell:=TheCell;
    curcell.edit(DrawGrid1.Cellrect(Acol,Arow));
  end;

  {
  else
  if  (goRowSelect in DrawGrid1.Options) and FcanEdit then        // Pourquoi ces lignes ?
  begin
    curcell:=Cell(DrawGrid1.FixedCols ,Arow);
    curcell.edit(DrawGrid1.Cellrect(DrawGrid1.FixedCols,Arow));
  end;
  }
end;

procedure TTableFrame.DrawGrid1TopLeftChanged(Sender: TObject);
begin
  if assigned(curCell) then curCell.hideEdit;
end;

procedure TTableFrame.init(Ncol, Nrow, NfixCol, NfixRow: integer;func:TgetCell);
begin
  if assigned(curcell) then curcell.HideEdit;

  drawGrid1.colCount:=Ncol;
  drawGrid1.rowCount:=Nrow;

  {Une erreur est générée si le Nfix n'est pas strictement inférieur à N}
  if NfixCol<Ncol then drawGrid1.FixedCols:=NfixCol else drawGrid1.FixedCols:= 0;
  if NfixRow<Nrow then drawGrid1.FixedRows:=NfixRow else drawGrid1.FixedRows:= 0;

  drawgrid1.invalidate;
  getCell:=func;
end;

procedure TTableFrame.invalidate;
begin
  if assigned(drawgrid1) then
  begin
    drawgrid1.Invalidate; { L'original ne fonctionne pas proprement }
    { 25-01-06:  Si dans Windows 2000, on a choisi les grandes polices,
                 drawgrid1 n'est pas assigné au premier appel de invalidate
    }
    if FcanEdit then
    begin
      curcell:=cell(drawGrid1.Col,drawGrid1.Row);
      if assigned(curcell) and visible then curcell.invalidate;
    end;
  end;
end;

function TTableFrame.selectGroup: boolean;
var
  gg:TgridRect;
  col1, col2, row1, row2:integer;
begin
  with drawgrid1 do
  begin
    selectCells.setMinMax(FixedCols,ColCount-1,FixedRows,rowCount-1);
    col1:=selection.left;
    col2:=selection.right;
    row1:=selection.Top;
    row2:=selection.bottom;
  end;

  result:=selectCells.execution(col1, col2, row1, row2);

  if result then
  begin
    gg.Left:=Col1;
    gg.right:=Col2;
    gg.top:=row1;
    gg.bottom:=row2;
    DrawGrid1.selection:=gg;
  end;
end;

function TTableFrame.SumOfWidths: integer;
var
  i:integer;
begin
  result:=0;
  with drawGrid1 do
  for i:=0 to ColCount-1 do
    result:=result+ColWidths[i];
end;

function TTableFrame.ColCount: integer;
begin
  result:=drawGrid1.ColCount;
end;

function TTableFrame.rowCount: integer;
begin
  result:=drawGrid1.rowCount;
end;


procedure TTableFrame.AppendRow;
begin
  drawGrid1.RowCount:=drawGrid1.RowCount+1;
  drawGrid1.Row:=drawGrid1.RowCount-1;
end;

procedure TTableFrame.DeleteRow;
begin
  drawGrid1.RowCount:=drawGrid1.RowCount-1;
  invalidate;
end;

procedure TTableFrame.DrawGrid1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  row1,col1:integer;
  rect:Trect;
  pgrid:Tpoint;
begin
  if (shift=[ssRight]) and assigned(OnMouseDownCell) then
  begin
    pgrid:=drawgrid1.ScreenToClient(mouse.cursorPos);

    drawGrid1.mouseToCell(pgrid.x,pgrid.y,col1,row1);

    rect:=drawGrid1.cellRect(col1,row1);

    rect.TopLeft:=clientToScreen(rect.TopLeft);
    rect.BottomRight:=clientToScreen(rect.BottomRight);

    OnMouseDownCell(rect,col1,row1);
  end;

end;


procedure TTableFrame.DrawGrid1DblClick(Sender: TObject);
var
  row1,col1:integer;
  rect:Trect;
  pgrid:Tpoint;
begin
  pgrid:=drawgrid1.ScreenToClient(mouse.cursorPos);

  drawGrid1.mouseToCell(pgrid.x,pgrid.y,col1,row1);

  rect:=drawGrid1.cellRect(col1,row1);

  rect.TopLeft:=clientToScreen(rect.TopLeft);
  rect.BottomRight:=clientToScreen(rect.BottomRight);

  if assigned(OnDblClickCell)
    then OnDblClickCell(rect,col1,row1);
end;


procedure TtableFrame.setColW(n, w: integer);
var
  i,len:integer;
begin
   if (n>=0) and (n<20000) then
   begin
     if n>=length(FColW) then
     begin
       len:=length(FColW);
       setLength(FcolW,n+1);

       for i:=len to high(FcolW) do FcolW[i]:=DrawGrid1.DefaultColWidth;
     end;

     FcolW[n]:=w;
   end;
end;

function TtableFrame.getColW(n: integer): integer;
begin
  if (n>=0) and (n<length(FColW))
    then result:=FcolW[n]
    else result:=DrawGrid1.DefaultColWidth;
end;


{ Tcell }

constructor Tcell.create(Frame1: TtableFrame);
begin
  frame:=frame1;
end;

procedure Tcell.Draw(rect: Trect; State: TGridDrawState);
begin
  frame.DrawGrid1.Canvas.Rectangle(rect);
end;

procedure Tcell.Edit(rect: Trect);
begin

end;

procedure Tcell.HideEdit;
begin

end;

procedure Tcell.invalidate;
begin

end;

{ TcheckBoxCell }

constructor TcheckBoxCell.create(frame1:Ttableframe);
begin
  inherited;
  CB:=TcheckBoxV.Create(frame);
  CB.Parent:=frame;
  CB.Visible:=false;
  CB.UpdateVarOnToggle:=true;
end;

procedure TcheckBoxCell.Draw(rect: Trect; State: TGridDrawState);
var
  w:integer;
  bb:boolean;
begin
  with frame.DrawGrid1.Canvas do
  begin
    pen.Color:= brush.Color;
    Rectangle(rect);
  end;  

  w:=rect.bottom-rect.top-5;
  case Align of
    taLeftJustify:  rect.Left:=rect.left+3;
    taCenter:       rect.Left:=(rect.left+rect.Right-w) div 2 ;
    taRightJustify: rect.Left:=rect.right-w-3;
  end;
  rect.right:=rect.left+w;
  rect.top:=rect.Top+2;
  rect.Bottom:=rect.top+w;

  with frame.DrawGrid1.Canvas do
  begin
    pen.Color:=clBlack;
    pen.Width:=1;
    brush.Color:=clWhite;

    Rectangle(rect);

    if assigned(adData) then bb:=Pboolean(AdData)^
    else
    bb:=getE(nil);

    if bb then
    begin
      pen.Width:=2;
      moveto(rect.Left+2,rect.Top+2);
      lineto(rect.right-3,rect.bottom-3);
      moveto(rect.Left+2,rect.bottom-3);
      lineto(rect.right-3,rect.top+2);
    end;
  end;
end;

procedure TcheckBoxCell.Edit(rect: Trect);
begin
  if not isRectEmpty(rect) then
    with cb do
    begin
      height:=rect.Bottom-rect.top-1;
      width:=height;

      case self.Align of
        taLeftJustify:  Left:=rect.left+3+frame.drawGrid1.left+2;
        taCenter:       Left:=(rect.left+rect.Right-width) div 2 +frame.drawGrid1.left+2;
        taRightJustify: left:=rect.right-width+frame.drawGrid1.left+1;
      end;

      top:=rect.top+frame.drawGrid1.top+2;

      if assigned(AdData) then setVar(adData^)
      else
      setProp(setE,getE,nil);

      visible:=true;
    end
  else
  begin
    cb.setvar(nil^);
    cb.Visible:=false;
  end;
end;


procedure TcheckBoxCell.HideEdit;
begin
  CB.Visible:=false;
end;

procedure TcheckBoxCell.setE(x: boolean;data1:pointer);
begin
  if assigned(setBxy) then setBxy(colG,rowG,x);
end;

function TcheckBoxCell.getE(data1:pointer): boolean;
begin
  if assigned(getBxy) then result:=getBxy(colG,rowG);
end;

procedure TcheckBoxCell.invalidate;
begin
  cb.Invalidate;
end;

{ TlabelCell }

procedure TlabelCell.Draw(rect: Trect; State: TGridDrawState);
var
  old:integer;
begin
  old:=frame.drawGrid1.canvas.Font.Color;
  frame.drawGrid1.canvas.Font.Color:=color;
  frame.drawGrid1.canvas.TextRect(rect,rect.left,rect.top+1,st);
  frame.drawGrid1.canvas.Font.Color:=old;
end;

procedure TlabelCell.Edit(rect: Trect);
begin
 // frame.drawGrid1.canvas.TextRect(rect,rect.left,rect.top+1,st);
end;

{ TcomboBoxCell }

constructor TcomboBoxCell.create(Frame1: TtableFrame);
begin
  inherited;
  CB:=TcomboBoxV.Create(frame);
  CB.Parent:=frame;
  CB.Visible:=false;
  CB.UpdateVarOnChange:=true;
end;

procedure TcomboBoxCell.Draw(rect: Trect; State: TGridDrawState);
var
  index:integer;
begin
  index:=round(varToFloat(adData^,cb.Tnum))+num1;
  if (index>=0) and (index<cb.Items.Count)
    then frame.drawGrid1.canvas.TextRect(rect,rect.Left+1,rect.top+1,cb.Items[index]);
end;

procedure TcomboBoxCell.Edit(rect: Trect);
begin
  if not isRectEmpty(rect) then
    with cb do
    begin
      left:=rect.left+frame.drawGrid1.left;
      top:=rect.top+frame.drawGrid1.top;
      width:=rect.Right-rect.left +2 ;
      height:=rect.Bottom-rect.top;

      setVar(adData^,tpNum,Num1);
      {itemIndex:=round(varToFloat(adData,cb.Tnum));}

      visible:=true;
    end
  else
  begin
    cb.setvar(nil^,tpNum,num1);
    cb.Visible:=false;
  end;

end;

procedure TcomboBoxCell.HideEdit;
begin
   CB.Visible:=false;
end;


procedure TcomboBoxCell.setOptions(var tb; long, nb: integer);
begin
  CB.setStringArray(tb,long,nb);
end;

procedure TcomboBoxCell.setOptions(st: AnsiString);
begin
  CB.setString(st);
end;

procedure TcomboBoxCell.setOptions(list: TstringList);
begin
  CB.Assign(list);
end;

procedure TcomboBoxCell.setOptions(n1, n2, step: integer);
begin
  CB.SetNumList(n1,n2,step);
end;

procedure TcomboBoxCell.invalidate;
begin
  cb.setVar(adData^,tpNum,Num1);
  cb.UpdateCtrl;
end;

{ TeditStringCell }

constructor TEditStringCell.create(Frame1: TtableFrame);
begin
  inherited;

  EditString:=TEditString.Create(frame);
  EditString.Parent:=frame;
  EditString.Visible:=false;
  EditString.UpdateVarOnExit:=true;


  EditString.onKeyDown:=EditOnKeyDw;
  EditString.OnChange:=EditOnChange;
end;

procedure TEditStringCell.setE(x:AnsiString;data1:pointer);
begin
  if assigned(setStxy) then setStxy(colEdit,rowEdit,x);
end;

function TEditStringCell.getE(data1:pointer):AnsiString;
begin
  if assigned(getStxy)
    then result:=getStxy(colEdit,rowEdit)
    else result:='';
end;

procedure TEditStringCell.Draw(rect: Trect; State: TGridDrawState);
begin

  if assigned(AdData)
    then frame.drawGrid1.canvas.TextRect(rect,rect.Left+1,rect.top+1,Pansistring(adData)^)
    else frame.drawGrid1.canvas.TextRect(rect,rect.Left+1,rect.top+1,getStxy(colG,rowG));
end;

procedure TEditStringCell.Edit(rect: Trect);
begin
  if not isRectEmpty(rect) then
    with EditString do
    begin
      colEdit:=colG;
      rowEdit:=rowG;

      left:=rect.left+frame.drawGrid1.left;
      top:=rect.top+frame.drawGrid1.top;
      width:=rect.Right-rect.left;
      height:=rect.Bottom-rect.top;

      if assigned(adData) then setString(AnsiString(adData^),20)
      else setProp(setE,getE,nil);

      visible:=true;
      if frame.parent.visible then EditString.setFocus;
      EditString.selectAll;
    end
  else
  begin
    EditString.setvar(nil^,20);
    EditString.Visible:=false;
  end;
end;

procedure TEditStringCell.EditonKeyDw(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_down: with frame.DrawGrid1 do
               if row<rowcount-1 then
               begin
                 EditString.UpdateVar;
                 Row:=Row+1;
               end;

    VK_up:   with frame.DrawGrid1 do
               if row>fixedRows then
               begin
                 EditString.UpdateVar;
                 Row:=Row-1;
               end;

    VK_left: if editString.selStart=0 then
             with frame.DrawGrid1 do
               if col>fixedcols then
               begin
                 EditString.UpdateVar;
                 col:=col-1;
                 setFocus;
               end;

    VK_right:if length(editString.text)=editString.selStart then
             with frame.DrawGrid1 do
               if col<ColCount-1 then
               begin
                 EditString.UpdateVar;
                 col:=col+1;
                 setFocus;
               end;

    VK_return:   EditString.UpdateVar;
  end;
end;

procedure TEditStringCell.HideEdit;
begin
   EditString.Visible:=false;
end;


procedure TEditStringCell.EditOnChange(Sender: TObject);
var
  gg:TgridRect;
begin
  gg.Left:=frame.DrawGrid1.Col;
  gg.right:=frame.DrawGrid1.Col;
  gg.top:=frame.DrawGrid1.row;
  gg.bottom:=frame.DrawGrid1.row;

  frame.DrawGrid1.selection:=gg;
end;

procedure TEditStringCell.invalidate;
begin
  editString.invalidate;
end;



{ TeditNumCell }

constructor TEditNumCell.create(Frame1: TtableFrame);
begin
  inherited;
  nbdeci:=3;

  EditNum:=TEditNum.Create(frame);
  EditNum.Parent:=frame;
  EditNum.Visible:=false;
  EditNum.UpdateVarOnExit:=true;


  EditNum.onKeyDown:=EditOnKeyDw;
  EditNum.OnChange:=EditOnChange;
end;

procedure TEditNumCell.setE(x:float;data1:pointer);
begin
  if assigned(setExy) then setExy(colEdit,rowEdit,x);
end;

function TEditNumCell.getE(data1:pointer):float;
begin
  if assigned(getExy)
    then result:=getExy(colEdit,rowEdit)
    else result:=0;
end;

procedure TEditNumCell.Draw(rect: Trect; State: TGridDrawState);
var
  st:AnsiString;
begin
  if assigned(AdData)
    then st:=Estr(varToFloat(adData^,tpNum),nbdeci)
    else st:=Estr(getExy(colG,rowG),nbdeci);

  frame.drawGrid1.canvas.TextRect(rect,rect.Left+1,rect.top+1,st);

end;

procedure TEditNumCell.Edit(rect: Trect);
begin
  if not isRectEmpty(rect) then
    with EditNum do
    begin
      colEdit:=colG;
      rowEdit:=rowG;

      left:=rect.left+frame.drawGrid1.left;
      top:=rect.top+frame.drawGrid1.top;
      width:=rect.Right-rect.left;
      height:=rect.Bottom-rect.top;

      if assigned(adData) then setVar(adData^,tpNum)
      else setProp(setE,getE,nil,tpNum);

      setMinMax(mini,maxi);
      Decimal:=nbdeci;
      visible:=true;
      if frame.parent.visible then EditNum.setFocus;
      EditNum.selectAll;
    end
  else
  begin
    EditNum.setvar(nil^,tpNum);
    EditNum.Visible:=false;
  end;

end;

procedure TEditNumCell.EditonKeyDw(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_down) or (key=VK_up) or (key=VK_left) or (key=VK_right) or (key=VK_return) then EditNum.UpdateVar;
  case key of
    VK_down: with frame.DrawGrid1 do
               if row<rowcount-1 then  Row:=Row+1;

    VK_up:   with frame.DrawGrid1 do
               if row>fixedRows then  Row:=Row-1;

    VK_left: if editNum.selStart=0 then
             with frame.DrawGrid1 do
               if col>fixedcols then
               begin
                 col:=col-1;
                 if frame.visible then setFocus;
               end;

    VK_right:if length(editNum.text)=editNum.selStart then
             with frame.DrawGrid1 do
               if col<ColCount-1 then
               begin
                 col:=col+1;
                 if frame.visible then setFocus;
               end;
  end;
end;

procedure TEditNumCell.HideEdit;
begin
   EditNum.Visible:=false;
end;


procedure TEditNumCell.EditOnChange(Sender: TObject);
var
  gg:TgridRect;
begin
{$IFNDEF FPC}
  gg.Left:=frame.DrawGrid1.Col;
  gg.right:=frame.DrawGrid1.Col;
  gg.top:=frame.DrawGrid1.row;
  gg.bottom:=frame.DrawGrid1.row;

  frame.DrawGrid1.selection:=gg;
{$ENDIF}
end;


procedure TEditNumCell.invalidate;
begin
  editNum.Invalidate;
end;

{ TcolorCell }

procedure TcolorCell.ColorOnClick(sender: Tobject);
var
  dlg:TcolorDialog;
begin
  if not assigned(AdData) then exit;

  dlg:=TcolorDialog.create(frame);

  try
  dlg.Color:=AdData^;
  if dlg.Execute and (AdData^<>dlg.Color) then
  begin
    AdData^:=dlg.Color;
    draw(frame.DrawGrid1.CellRect(ColEdit,RowEdit),[]);
    if assigned(OnColorChanged) then OnColorChanged(ColEdit,RowEdit);
  end;

  finally
  dlg.free;
  end;
end;

constructor TcolorCell.create(Frame1: TtableFrame);
begin
  inherited;

  button:=Tbutton.Create(frame);
  button.Parent:=frame;
  button.Visible:=false;

  button.OnClick:=ColorOnClick;

end;

procedure TcolorCell.Draw(rect: Trect; State: TGridDrawState);
var
  oldP,oldB:integer;
  h,max:integer;
begin
  if assigned(AdData) then
  with frame.drawGrid1.canvas do
  begin
    oldP:=pen.Color;
    oldB:=brush.Color;
    pen.Color:=clBlack;
    brush.Color:=AdData^;

    h:= rect.bottom-rect.top;
    max:=rect.Right-rect.Left -h-2;

    Rectangle(rect.Left+1,rect.Top+1,rect.Left+max,rect.Bottom-1);

    pen.Color:=oldP;
    brush.Color:=oldB;
  end;
end;

procedure TcolorCell.Edit(rect: Trect);
var
  h,max:integer;
begin
  inherited;
  if not isRectEmpty(rect) then
    with button do
    begin
      colEdit:=colG;
      rowEdit:=rowG;

      h:= rect.bottom-rect.top;
      max:=rect.Right-rect.Left -h-2;

      left:=rect.left+max+4+frame.drawGrid1.left;
      top:=rect.top+frame.drawGrid1.top+3;
      width:=h;
      height:=h-2;

      visible:=true;
      if frame.parent.visible then button.setFocus;

      draw(rect,[gdSelected]);
    end
  else
  begin
    button.Visible:=false;
  end;


end;

procedure TcolorCell.HideEdit;
begin
  inherited;
  button.Visible:=false;
end;


{ TbuttonCell }

procedure TbuttonCell.ButtonOnClick(sender: Tobject);
begin
  if assigned(UserOnClick)
    then UserOnClick(ColEdit,RowEdit);
end;

constructor TbuttonCell.create(Frame1: TtableFrame);
begin
  inherited;

  button:=Tbutton.Create(frame);
  button.Parent:=frame;
  button.Visible:=false;

  button.OnClick:=ButtonOnClick;
end;

procedure TbuttonCell.Draw(rect: Trect; State: TGridDrawState);
var
  oldP,oldB:integer;
  h,max:integer;
  oldFont:Tfont;
begin
  with frame.drawGrid1.canvas do
  begin
    oldP:=pen.Color;
    oldB:=brush.Color;
    oldFont:=font;
    pen.Color:=clBlack;
    brush.Color:=clBtnFace;

    Rectangle(rect);
    font:=button.Font;
    
    TextRect(rect,rect.Left+1,rect.top+1,Button.Caption);

    pen.Color:=oldP;
    brush.Color:=oldB;
    font:=oldFont;
  end;
end;

procedure TbuttonCell.Edit(rect: Trect);
var
  h,max:integer;
begin
  inherited;
  if not isRectEmpty(rect) then
    with button do
    begin
      colEdit:=colG;
      rowEdit:=rowG;

      left:=rect.left+frame.drawGrid1.left ;
      top:=rect.top+frame.drawGrid1.top ;
      width:=rect.Right-rect.Left+2;
      height:=rect.Bottom-rect.Top+4;

      visible:=true;
      if frame.parent.visible then button.setFocus;
    end
  else
  begin
    button.Visible:=false;
  end;


end;

procedure TbuttonCell.HideEdit;
begin
  inherited;
  button.Visible:=false;
end;




Initialization
AffDebug('Initialization FrameTable1',0);
{$IFDEF FPC}
{$I FrameTable1.lrs}
{$ENDIF}
end.
