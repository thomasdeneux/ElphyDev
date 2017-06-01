unit DBtable1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses  windows, classes, forms, controls,FrameTable1, grids,XMLIntf, XMLDoc, sysUtils, clipbrd,
      util1,listG, stmdef,stmObj,NcDef2,stmPg,stmPopup,varconf1,
      memoForm,stmData0, debug0,
      DBrecord1, editDBtable1;



type
  { TtableRec contient les données correspondant à un champ
    Le nom du champ est ailleurs (dans fields de TDBtable )
    Create fixe le type et initialise une liste TlistG ou TstringList .
    Les indices vont de 0 à count-1
  }

  TtableRec=class

            private
              FVtype:TGvariantType;
              p: Tobject;          { TlistG ou TstringList }

              procedure setCount(n:integer);
              function getCount: integer;

              function getGvariant(n:integer): TGvariant;
              procedure setGvariant(n:integer; gv:TGvariant);

              function getInteger(n:integer):int64;
              procedure setInteger(n:integer; w:int64);

              procedure setFloat(n:integer;value:Float);
              function getFloat(n:integer):Float;

              procedure setComplex(n:integer;value:TFloatComp);
              function getComplex(n:integer):TFloatComp;

              procedure setString(n:integer;value:AnsiString);
              function getString(n:integer):AnsiString;

              procedure setBoolean(n:integer;value:Boolean);
              function getBoolean(n:integer):Boolean;

              procedure setDateTime(n:integer;value:TDateTime);
              function getDateTime(n:integer):TDateTime;



            public
              constructor create(tp1:TGvariantType);
              destructor destroy;override;


              procedure clear;
              property Vtype: TGVariantType read FVtype;
              property count:integer read getCount write setCount;
              property Gvariant[n: integer]: TGvariant read getGvariant write setGvariant;
              property Vinteger[n:integer]: int64 read getInteger write SetInteger;
              property Vfloat[n:integer]: float read getFloat write SetFloat;
              property Vcomplex[n:integer]: TfloatComp read getComplex write SetComplex;
              property Vstring[n:integer]: AnsiString read getString write SetString;
              property Vboolean[n:integer]: Boolean read getBoolean write SetBoolean;
              property VDateTime[n:integer]:TDateTime read getDateTime write setDateTime;


            end;

  TDBtable=class;
  TDBrecordTable=
            class(TDBrecord)
              table:TDBtable;
              NumLine:integer;

              constructor create(Atable:TDBtable; row: integer);
              function fields:TstringList; override;

              procedure setValue(name:AnsiString;var value:TGvariant); override;
              function getValue(name:AnsiString):TGvariant; override;

              procedure setValue1(n:integer;var value:TGvariant); override;
              function getValue1(n:integer):TGvariant; override;
            end;


  TXMLinfo=class
              table: TDBtable;
              FullName:TstringList;

              DbRowMax: array of integer;
              limit:integer;
              offset:integer;
              total_count:integer;
              XML: IXMLDocument;
              constructor create(TheTable: TDBtable);
              destructor destroy;override;

              procedure AnalyseXML;
              procedure getDBList(stRoot:AnsiString;child: IXMLnode);
              procedure getDBNode(stRoot:AnsiString;child: IXMLnode);
            end;

  TDBtable=class(Tdata0)
            private
              FrowCount:integer;
              DBrecordList: Tlist;
              Ferror:boolean;
              FRowMarked:array of boolean;

              XMLinfo0: TXMLinfo;
              function EditForm:TeditDBtable;

            protected
              onSel:Tpg2Event;
              onDblClick: Tpg2Event;
              onRightClick: Tpg2Event;
              onClickB: Tpg2Event;

              GridColor:integer;
              GridMarkedColor:integer;
              GridFixedColor:integer;
              GridSelColor:integer;

              procedure setFirstColVisible(w:boolean);virtual;
              function getFirstColVisible:boolean;virtual;
              procedure setFirstRowVisible(w:boolean);virtual;
              function getFirstRowVisible:boolean;virtual;

              procedure setButton0(w:boolean);virtual;
              function getButton0:boolean;virtual;

              procedure setButtonsVisible(w:boolean);virtual;
              function getButtonsVisible:boolean;virtual;

              procedure setColumnWidths(n:integer;w:integer);virtual;
              function getColumnWidths(n:integer):integer;virtual;

              procedure setColumnVisible(n:integer;w:boolean);virtual;
              function getColumnVisible(n:integer):boolean;virtual;

              function getTableFrame:TTableFrame;virtual;

              procedure OnSelectCell(x,y:integer);
              procedure OnDblClickCell(x,y:integer);
              procedure OnRightClickCell(x,y:integer);

              procedure OnClickButton(Acol, Arow:integer);

              procedure setRowCount(n:integer);virtual;
              function getRowCount:integer;virtual;



              function getRowMarked(n:integer):boolean;    { n de 1 à rowCount }
              procedure setRowMarked(n:integer; w:boolean);

           private

              function getTableRec(n:integer):TtableRec;

              function getColType(n:integer): TGVariantType;

              procedure setValue(name:AnsiString;row: integer; var value:TGvariant);
              function getValue(name:AnsiString;row: integer):TGvariant;

              procedure setInteger(n,row:integer;value:int64);
              function getInteger(n,row:integer):int64;

              procedure setFloat(n,row:integer;value:Float);
              function getFloat(n,row:integer):Float;

              procedure setComplex(n,row:integer;value:TFloatComp);
              function getComplex(n,row:integer):TFloatComp;

              procedure setString(n,row:integer;value:AnsiString);
              function getString(n,row:integer):AnsiString;

              procedure setBoolean(n,row:integer;value:Boolean);
              function getBoolean(n,row:integer):Boolean;

              procedure setDateTime(n,row:integer;value:TDateTime);
              function getDateTime(n,row:integer):TDateTime;


            public
              property FirstColVisible: boolean read GetFirstColVisible write setFirstColVisible;
              property FirstRowVisible: boolean read GetFirstRowVisible write setFirstRowVisible;
              property Button0: boolean read GetButton0 write setButton0;
              property ButtonsVisible: boolean read GetButtonsVisible write setButtonsVisible;
              property ColumnWidths[n:integer]:integer read GetColumnWidths write SetColumnWidths;
              property ColumnVisible[n:integer]:boolean read GetColumnVisible write SetColumnVisible;

              property TableFrame: TTableFrame read GetTableFrame;

            public
              fields:TstringList;

              constructor create;override;
              destructor destroy;override;
              class function stmClassName:AnsiString;override;

              function getGridColor(col,row:integer; Fsel:boolean):integer;
              property RowCount:integer read getRowCount write setRowCount;
              property TableRec[n:integer]:TtableRec read GetTableRec;
              property ColType[n:integer]: TGVariantType read getColType;
              property RowMarked[n:integer]:boolean read getRowMarked write setRowMarked;

              procedure clearFields;
              function AddField(name:AnsiString;tp:TGvariantType; const AcceptMulti:boolean=false): integer;
              procedure DeleteField(name:AnsiString);

              property value[name:AnsiString;row: integer]:TGvariant read getValue;

              property Vinteger[n,row:integer]:int64 read getInteger write setInteger;
              property VFloat[n,row:integer]:float read getFloat write setFloat;
              property Vcomplex[n,row:integer]:TfloatComp read getComplex write setComplex;
              property Vstring[n,row:integer]:AnsiString read getString write setString;
              property VBoolean[n,row:integer]:Boolean read getBoolean write setBoolean;
              property VDateTime[n,row:integer]:TDateTime read getDateTime write setDateTime;

              procedure assign(var db:TDBtable);

              procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
              procedure CompleteLoadInfo;override;
              procedure CompleteSaveInfo;override;

              function ColCount:integer;virtual;
              function getInfo:AnsiString;override;

              procedure createForm;override;
              procedure invalidate;override;

              function getDBrecordTable(n: integer): TDBrecordTable;
              procedure AddLine;
              procedure AddRecord(db: TDBrecord);

              function ActiveEmbedded(TheParent:TwinControl; x1,y1,x2,y2:integer): Trect;override;
              procedure UnActiveEmbedded;override;
              procedure setEmbedded(v: boolean); override;
              procedure PaintImageTo(dc:hdc;x,y:integer);override;


              procedure initform;virtual;
              procedure MarkSelectedRows(mode:integer);
              procedure RemoveMarks;

              function XMLinfo: TXMLinfo;

              procedure GetSelection(var x1,y1,x2,y2: integer);
              procedure SetSelection( x1,y1,x2,y2: integer);

              function GetSelectionAsText(WithNames: boolean; sep, StringSep: AnsiString; Nbdeci:integer): AnsiString;
              procedure CopySelectionToClipboard(WithNames: boolean; sep, StringSep: AnsiString; Nbdeci:integer);
            end;


procedure proTDBtable_create(var pu:typeUO);pascal;
procedure proTDBtable_AddField(st:AnsiString;tp:integer;var pu:typeUO);pascal;
procedure proTDBtable_DeleteField(st:AnsiString;var pu:typeUO);pascal;
procedure proTDBtable_clear(var pu:typeUO);pascal;
function fonctionTDBtable_FieldExists(st:AnsiString;var pu:typeUO):boolean;pascal;

function fonctionTDBgrid0_ColCount(var pu:typeUO):integer;pascal;
function fonctionTDBgrid0_RowCount(var pu:typeUO):integer;pascal;


function fonctionTDBtable_Vtype(n:integer;var pu:typeUO):integer;pascal;
function fonctionTDBtable_Names(n:integer;var pu:typeUO):AnsiString;pascal;

function fonctionTDBtable_Lines(n:integer; var pu:typeUO): TDBrecordTable;pascal;
procedure proTDBtable_AddLine(var pu:typeUO);pascal;
procedure proTDBtable_AddRecord(var rec: TDBrecord; var pu:typeUO);pascal;


procedure proTDBgrid0_ShowButtons(w:boolean;var pu:typeUO);pascal;
function fonctionTDBgrid0_ShowButtons(var pu:typeUO):boolean;pascal;
function fonctionTDBgrid0_CanModify(var pu:typeUO):boolean;pascal;
procedure proTDBgrid0_FirstColVisible(w:boolean;var pu:typeUO);pascal;
function fonctionTDBgrid0_FirstColVisible(var pu:typeUO):boolean;pascal;
procedure proTDBgrid0_ButtonColumn(w:boolean;var pu:typeUO);pascal;
function fonctionTDBgrid0_ButtonColumn(var pu:typeUO):boolean;pascal;
procedure proTDBgrid0_FirstRowVisible(w:boolean;var pu:typeUO);pascal;
function fonctionTDBgrid0_FirstRowVisible(var pu:typeUO):boolean;pascal;
procedure proTDBgrid0_ColWidths(n:integer;w:integer;var pu:typeUO);pascal;
function fonctionTDBgrid0_ColWidths(n:integer;var pu:typeUO):integer;pascal;

procedure proTDBgrid0_onSelectCell(w:integer;var pu:typeUO);pascal;
function fonctionTDBgrid0_onSelectCell(n:integer;var pu:typeUO):integer;pascal;

procedure proTDBgrid0_onDblClick(w:integer;var pu:typeUO);pascal;
function fonctionTDBgrid0_onDblClick(n:integer;var pu:typeUO):integer;pascal;

procedure proTDBgrid0_onRightClick(w:integer;var pu:typeUO);pascal;
function fonctionTDBgrid0_onRightClick(n:integer;var pu:typeUO):integer;pascal;

procedure proTDBgrid0_onClickButton(w:integer;var pu:typeUO);pascal;
function fonctionTDBgrid0_onClickButton(n:integer;var pu:typeUO):integer;pascal;

procedure proTDBgrid0_CanModify(w:boolean;var pu:typeUO);pascal;
procedure proTDBgrid0_RowSelect(w:boolean;var pu:typeUO);pascal;
function fonctionTDBgrid0_RowSelect(var pu:typeUO):boolean;pascal;
procedure proTDBgrid0_ColSizing(w:boolean;var pu:typeUO);pascal;
function fonctionTDBgrid0_ColSizing(var pu:typeUO):boolean;pascal;
procedure proTDBgrid0_Color(w:integer;var pu:typeUO);pascal;
function fonctionTDBgrid0_Color(var pu:typeUO):integer;pascal;
procedure proTDBgrid0_FixedColor(w:integer;var pu:typeUO);pascal;
function fonctionTDBgrid0_FixedColor(var pu:typeUO):integer;pascal;
procedure proTDBgrid0_DefaultColWidth(w:integer;var pu:typeUO);pascal;
function fonctionTDBgrid0_DefaultColWidth(var pu:typeUO):integer;pascal;
procedure proTDBgrid0_DefaultRowHeight(w:integer;var pu:typeUO);pascal;
function fonctionTDBgrid0_DefaultRowHeight(var pu:typeUO):integer;pascal;
function fonctionTDBgrid0_font(var pu:typeUO):pointer;pascal;

procedure proTDBgrid0_Col(w:integer;var pu:typeUO);pascal;
function fonctionTDBgrid0_Col(var pu:typeUO):integer;pascal;

procedure proTDBgrid0_Row(w:integer;var pu:typeUO);pascal;
function fonctionTDBgrid0_Row(var pu:typeUO):integer;pascal;

procedure proTDBgrid0_RowMarked(n:integer;w:boolean; var pu:typeUO);pascal;
function fonctionTDBgrid0_RowMarked(n:integer;var pu:typeUO):boolean;pascal;
procedure proTDBgrid0_MarkSelectedRows(mode:integer; var pu:typeUO);pascal;

procedure proTDBgrid0_MarkColor(w:integer;var pu:typeUO);pascal;
function fonctionTDBgrid0_MarkColor(var pu:typeUO):integer;pascal;

procedure proTDBgrid0_ColVisible(n:integer;w:boolean;var pu:typeUO);pascal;
function fonctionTDBgrid0_ColVisible(n:integer;var pu:typeUO):boolean;pascal;

procedure proTDBgrid0_GetSelection(var x1,y1,x2,y2: integer;var pu: typeUO);pascal;
procedure proTDBgrid0_SetSelection(x1,y1,x2,y2: integer;var pu: typeUO);pascal;

procedure proTDBgrid0_CopySelectionToClipboard(var pu: typeUO);pascal;
procedure proTDBgrid0_CopySelectionToClipboard_1(WithNames: boolean; sep, StringSep: AnsiString; Nbdeci:integer; var pu: typeUO);pascal;

function fonctionTDBgrid0_GetSelectionAsText(WithNames: boolean; sep, StringSep: AnsiString; Nbdeci:integer; var pu: typeUO): AnsiString;pascal;

implementation


{ TtableRec }

procedure TtableRec.clear;
begin
  p.Free;
  p:=nil;
  FVtype:=gvNull;
end;

destructor TtableRec.destroy;
begin
  clear;
  inherited;
end;

function TtableRec.getCount: integer;
begin
  if p is Tstringlist then
    result:= Tstringlist(p).count
  else
  if p is TListG then result:=TlistG(p).Count
  else result:=0;
end;


constructor TtableRec.create(tp1: TGvariantType);
begin
 FVtype:=tp1;
 case Vtype of
    gvBoolean:    p:=TlistG.create(sizeof(boolean));
    gvInteger:    p:=TlistG.create(sizeof(int64));
    gvFloat :     p:=TlistG.create(sizeof(float));
    gvComplex :   p:=TlistG.create(sizeof(TfloatComp));
    gvString:     p:=TstringList.Create;
    gvDateTime:   p:=TlistG.create(sizeof(TdateTime));
    gvObject:     p:=TlistG.create(sizeof(pointer));
    else          p:=nil;
  end;
end;

procedure TtableRec.setCount(n: integer);
begin
  if p is Tstringlist then
    with Tstringlist(p) do
    begin
      while Count < n do add('');
      while Count>n do delete(count-1);
    end
  else
  if p is TListG then TlistG(p).Count:=n;
end;

function TtableRec.getGvariant(n: integer): TGvariant;
begin
  result.init;
  if (n>=0) and (n<count) then
  case Vtype of
    gvBoolean:    result.Vboolean:= Pboolean(TlistG(p)[n])^;
    gvInteger:    result.Vinteger:= Pint64(TlistG(p)[n])^;
    gvFloat :     result.Vfloat:= Pfloat(TlistG(p)[n])^;
    gvComplex :   result.Vcomplex:= PfloatComp(TlistG(p)[n])^;
    gvString:     result.Vstring:= Tstringlist(p)[n];
    gvDateTime:   result.VdateTime:= PdateTime(TlistG(p)[n])^;
    gvObject:     result.Vobject:= Ppointer(TlistG(p)[n])^;
  end
  else result.Vtype:=Vtype;

end;

procedure TtableRec.setGvariant(n: integer; gv: TGVariant);
begin
  if (n>=0) and (n<count) then
  case Vtype of
    gvBoolean:    Pboolean(TlistG(p)[n])^:= gv.Vboolean;
    gvInteger:    Pint64(TlistG(p)[n])^:= gv.Vinteger;
    gvFloat :     Pfloat(TlistG(p)[n])^:= gv.Vfloat;
    gvComplex :   PfloatComp(TlistG(p)[n])^:= gv.Vcomplex;
    gvString:     Tstringlist(p)[n]:= gv.Vstring;
    gvDateTime:   PdateTime(TlistG(p)[n])^:= gv.VdateTime;
    gvObject:     Ppointer(TlistG(p)[n])^:= gv.Vobject;
  end;

end;

function TtableRec.getInteger(n: integer): int64;
begin
  if (n>=0) and (n<count) and (Vtype=gvInteger) then
    result:= Pint64(TlistG(p)[n])^;
end;

procedure TtableRec.setInteger(n:integer; w: int64);
begin
  if (n>=0) and (n<count) and (Vtype=gvInteger) then
    Pint64(TlistG(p)[n])^:=w;
end;

function TtableRec.getBoolean(n: integer): Boolean;
begin
  if (n>=0) and (n<count) and (Vtype=gvBoolean) then
    result:= Pboolean(TlistG(p)[n])^;
end;

procedure TtableRec.setBoolean(n: integer; value: Boolean);
begin
  if (n>=0) and (n<count) and (Vtype=gvBoolean) then
    Pboolean(TlistG(p)[n])^:=value;
end;


function TtableRec.getFloat(n: integer): Float;
begin
  if (n>=0) and (n<count) and (Vtype=gvFloat) then
    result:=PFloat(TlistG(p)[n])^;
end;

procedure TtableRec.setFloat(n: integer; value: Float);
begin
  if (n>=0) and (n<count) and (Vtype=gvFloat) then
    PFloat(TlistG(p)[n])^:=value;
end;

function TtableRec.getString(n: integer): AnsiString;
begin
  if (n>=0) and (n<count) and (Vtype=gvString) then
    result:=Tstringlist(p)[n];
end;

procedure TtableRec.setString(n: integer; value: AnsiString);
begin
  if (n>=0) and (n<count) and (Vtype=gvString) then
    Tstringlist(p)[n]:=value;
end;


function TtableRec.getComplex(n: integer): TFloatComp;
begin
  if (n>=0) and (n<count) and (Vtype=gvComplex) then
    result:=PFloatComp(TlistG(p)[n])^;
end;

procedure TtableRec.setComplex(n: integer; value: TFloatComp);
begin
  if (n>=0) and (n<count) and (Vtype=gvComplex) then
    PFloatComp(TlistG(p)[n])^:=value;
end;

function TtableRec.getDateTime(n: integer): TDateTime;
begin
  if (n>=0) and (n<count) and (Vtype=gvDateTime) then
    result:=PdateTime(TlistG(p)[n])^;
end;

procedure TtableRec.setDateTime(n: integer; value: TDateTime);
begin
  if (n>=0) and (n<count) and (Vtype=gvDateTime) then
    PdateTime(TlistG(p)[n])^:=value;
end;



{ TDBtable }

function TDBtable.AddField(name: AnsiString; tp: TGvariantType; const AcceptMulti:boolean=false): integer;
var
  rec:TtableRec;
begin
  if not AcceptMulti then
  begin
    Ferror:=( fields.IndexOf(name)>=0) ;
    if Ferror then exit;
  end
  else Ferror:=false;

  rec:=TtableRec.Create(tp);
  rec.setCount (Rowcount);
  result:=fields.AddObject(name,Tobject(rec));
  initForm;
end;

procedure TDBtable.DeleteField(name: AnsiString);
var
  i:integer;
begin
  i:=fields.IndexOf(name);
  if i>=0 then
  begin
    TtableRec(fields.Objects[i]).free;
    fields.Delete(i);
  end;
  initForm;
end;

procedure TDBtable.clearFields;
var
  i:integer;
begin
  for i:=0 to fields.Count-1 do
    TtableRec(fields.Objects[i]).free;

  fields.clear;
  initForm;
end;

constructor TDBtable.create;
begin
  inherited;
  fields:=Tstringlist.create;
  DBrecordList:= Tlist.Create;

  GridColor:=       rgb(230,230,230);
  GridMarkedColor:= rgb(50,190,190);
  GridFixedColor:=  rgb(190,190,190);
  GridSelColor:=    rgb(150,220,160);
end;

destructor TDBtable.destroy;
var
  i:integer;
begin
  if assigned(form) then EditForm.Destroying:= true;
  ClearFields;
  fields.free;
  with DBrecordList do
  begin
    for i:=0 to count-1 do TDBrecordTable(items[i]).Free;
    free;
  end;
  XMLinfo.Free;
  inherited;
end;

class function TDBtable.stmClassName: AnsiString;
begin
  result:='DBtable';
end;

function TDBtable.getColType(n: integer): TGVariantType;
begin
  if (n>=0) and (n<fields.Count)
    then result:=tableRec[n].Vtype
    else result:=gvNull;
end;


function TDBtable.getValue(name: AnsiString;row: integer): TGvariant;
var
  i:integer;
  st:AnsiString;
begin
  i:=fields.IndexOf(name);
  if i>=0
    then result:= TableRec[i].getGVariant(row)
    else result.init;
  FError:=(i<0);
end;

procedure TDBtable.setValue(name: AnsiString;row: integer; var value: TGvariant);
var
  i:integer;
begin
  i:=fields.IndexOf(name);
  if i<0 then i:=AddField(name,value.Vtype);

  if (row>=0) then
  begin
    while (RowCount<=row) do AddLine;
    if ColType[i]=value.Vtype
      then tableRec[i].setGVariant(row,value)
      else sortieErreur('TDBtable.setValue : invalid type');
  end;
  initForm;
end;


function TDBtable.getInteger(n,row: integer): int64;
begin
  if (n>=0) and (n<fields.Count) and (row>=0) and (row<RowCount)
    then result:=tableRec[n].Vinteger[row]
    else result:=0;
end;

procedure TDBtable.setInteger(n,row:integer; value: int64);
begin
  if (n>=0) and (n<fields.Count) and (row>=0) and (row<RowCount)
    then tableRec[n].Vinteger[row]:=value;
end;

function TDBtable.getFloat(n,row: integer): Float;
begin
  if (n>=0) and (n<fields.Count) and (row>=0) and (row<RowCount)
    then result:=tableRec[n].VFloat[row]
    else result:=0;
end;

procedure TDBtable.setFloat(n,row:integer; value: Float);
begin
  if (n>=0) and (n<fields.Count) and (row>=0) and (row<RowCount)
    then tableRec[n].VFloat[row]:=value;
end;

function TDBtable.getComplex(n,row: integer): TFloatComp;
begin
  if (n>=0) and (n<fields.Count) and (row>=0) and (row<RowCount)
    then result:=tableRec[n].VComplex[row]
    else result:=cpxNumber(0,0);
end;

procedure TDBtable.setComplex(n,row:integer; value: TFloatComp);
begin
  if (n>=0) and (n<fields.Count) and (row>=0) and (row<RowCount)
    then tableRec[n].VComplex[row]:=value;
end;

function TDBtable.getBoolean(n,row: integer): Boolean;
begin
  if (n>=0) and (n<fields.Count) and (row>=0) and (row<RowCount)
    then result:=tableRec[n].VBoolean[row]
    else result:=false;
end;

procedure TDBtable.setBoolean(n,row:integer; value: Boolean);
begin
  if (n>=0) and (n<fields.Count) and (row>=0) and (row<RowCount)
    then tableRec[n].VBoolean[row]:=value;
end;

function TDBtable.getString(n,row: integer): AnsiString;
begin
  if (n>=0) and (n<fields.Count) and (row>=0) and (row<RowCount)
    then result:=tableRec[n].VString[row]
    else result:='';
end;

procedure TDBtable.setString(n,row:integer; value: AnsiString);
begin
  if (n>=0) and (n<fields.Count) and (row>=0) and (row<RowCount)
    then tableRec[n].VString[row]:=value;
end;

function TDBtable.getDateTime(n,row: integer): TDateTime;
begin
  if (n>=0) and (n<fields.Count) and (row>=0) and (row<RowCount)
    then result:=tableRec[n].VDateTime[row]
    else result:= 0;
end;

procedure TDBtable.setDateTime(n,row:integer; value: TDateTime);
begin
  if (n>=0) and (n<fields.Count) and (row>=0) and (row<RowCount)
    then tableRec[n].VDateTime[row]:=value;
end;




procedure TDBtable.assign(var db: TDBtable);
var
  i:integer;
  Pvariant:PGvariant;
begin
  clearFields;
  fields.Text:=db.fields.Text;
  for i:=0 to db.fields.Count-1 do
  begin
    new(Pvariant);
    fillchar(Pvariant^,sizeof(Pvariant^),0);
    copyGVariant(PGvariant(db.fields.objects[i])^,Pvariant^);
    fields.Objects[i]:=pointer(Pvariant);
  end;
end;




procedure TDBtable.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;
end;


function TDBtable.ColCount: integer;
begin
  result:=fields.Count;
end;

procedure TDBtable.CompleteLoadInfo;
begin
  inherited;
end;

procedure TDBtable.CompleteSaveInfo;
begin
end;

function TDBtable.getInfo: AnsiString;
var
  i:integer;
begin
  result:=inherited getInfo+crlf;
  {
  for i:=0 to ColCount-1 do
    result:=result+CRLF+fields[i]+': '+TGvariantTypeName[ColType[i]];
  }
end;


procedure TDBtable.invalidate;
begin
  initForm;
end;

function TDBtable.getTableRec(n: integer): TtableRec;
begin
  if (n>=0) and  (n<fields.count)
    then result:= TtableRec(fields.objects[n])
    else result:=nil;
end;

procedure TDBtable.setRowCount(n: integer);
var
  i:integer;
begin
  for i:=0 to ColCount-1 do tableRec[i].count:=n;
  FrowCount:=n;
end;

function TDBtable.getRowCount:integer;
begin
  result:=FrowCount;
end;

function TDBtable.getDBrecordTable(n: integer): TDBrecordTable;
var
  db: TDBrecordTable;
  i:integer;
begin
  if n>=0 then
  begin
    while rowCount<=n do addline;
    db:= TDBrecordTable.create(self,n);
    db.NotPublished:=true;
    db.Fchild:=true;


    { Avec cette méthode, on aura au plus RowCount objets DBrecordTable dans la liste.
    }
    for i:=0 to DBrecordList.count-1 do
    if TDBrecordTable(DBrecordList[i]).NumLine=n then
    begin
       TDBrecordTable(DBrecordList[i]).Free;
       DBrecordList.Delete(i);
       break;
     end;

    DBrecordList.add(db);
    result:= @db.myad;
  end
  else result:=nil;
end;

procedure TDBtable.AddLine;
begin
  RowCount:= RowCount+1;
  initForm;
end;

procedure TDBtable.AddRecord(db: TDBrecord);
begin

end;

procedure TDBtable.OnSelectCell(x, y: integer);
begin
  with OnSel do
  if valid then pg.executerProcedure2(ad,x+1,y+1);
end;

procedure TDBtable.OnDblClickCell(x, y: integer);
begin
  with OnDblClick do
  if valid then pg.executerProcedure2(ad,x+1,y+1);
end;

procedure TDBtable.OnRightClickCell(x, y: integer);
begin
  with OnRightClick do
  if valid then pg.executerProcedure2(ad,x+1,y+1);
end;

procedure TDBtable.OnClickButton(Acol, Arow: integer);
begin
  with OnClickB do
  if valid then pg.executerProcedure1(ad,Arow);

end;


function TDBtable.ActiveEmbedded(TheParent:TwinControl; x1,y1,x2,y2:integer): Trect;
begin
  with editForm.BackPanel do
  begin
    parent:=TheParent;
    align:=alNone;
    setBounds(x1,y1,x2,y2);
    result:=rect(left,top,left+width-1,top+height-1);
  end;
end;

procedure TDBtable.UnActiveEmbedded;
begin
  EditForm.BackPanel.Parent:= TEditDBtable(form);
  EditForm.BackPanel.align:=alClient;
end;

procedure TDBtable.setEmbedded(v: boolean);
begin
  Fembedded:=v;
end;

procedure TDBtable.PaintImageTo(dc:hdc;x,y:integer);
begin
  editform.BackPanel.PaintTo(dc, x, y);
end;


procedure TDBtable.createForm;
begin
  form:=TEditDBtable.create(formStm);
  form.formStyle:=fsStayOnTop;
  //form.borderStyle:=bsSingle;

  EditForm.OnSelectCell0:=OnSelectCell;
  EditForm.OnDblClickCell0:=OnDblClickCell;
  EditForm.OnRightClickCell0:=OnRightClickCell;

  EditForm.ButtonCell.UserOnClick:=OnClickButton;
  EditForm.Panel1.visible:=false;    

end;


procedure TDBtable.setFirstColVisible(w: boolean);
begin
  with EditForm do FirstColVisible:=w;
  InitForm;
end;

function TDBtable.getFirstColVisible: boolean;
begin
  result:=EditForm.FirstColVisible;
end;

procedure TDBtable.setFirstRowVisible(w: boolean);
begin
  EditForm.FirstRowVisible:=w;
  InitForm;
end;

function TDBtable.getFirstRowVisible: boolean;
begin
  result:=EditForm.FirstRowVisible;
end;

function TDBtable.getButton0: boolean;
begin
  result:=EditForm.Fbutton0;
end;

procedure TDBtable.setButton0(w: boolean);
begin
  EditForm.Fbutton0:=w;
end;

function TDBtable.getColumnWidths(n: integer): integer;
begin
  result:=EditForm.ColumnWidths[n];
end;

procedure TDBtable.setColumnWidths(n, w: integer);
begin
  EditForm.ColumnWidths[n]:=w;
end;

function TDBtable.getColumnVisible(n: integer): boolean;
begin
  result:=true;
end;

procedure TDBtable.setColumnVisible(n:integer; w: boolean);
begin
end;


function TDBtable.getTableFrame: TTableFrame;
begin
  result:=EditForm.TableFrame1;
end;

procedure TDBtable.setButtonsVisible(w: boolean);
begin
  EditForm.Panel1.visible:=w;
end;

function TDBtable.getButtonsVisible: boolean;
begin
  result:=EditForm.Panel1.visible;
end;


procedure TDBtable.initform;
begin
  editForm.init(self);
end;

function TDBtable.EditForm: TeditDBtable;
begin
  if not assigned(form) then createForm;
  result:= TeditDBtable(form);
end;

function TDBtable.getGridColor(col, row: integer; Fsel: boolean): integer;  // col, row: coo grid Delphi
var
  nCol,nRow:integer;
begin
  nRow:=row+ord(not FirstRowVisible);
  nCol:=col+ord(not FirstColVisible);

  if (nCol=0) or (nRow=0) then result:=GridFixedColor
  else
  if Fsel then result:=GridSelColor
  else  
  if RowMarked[nRow] then result:=GridMarkedColor
  else result:=GridColor;
end;

function TDBtable.getRowMarked(n: integer): boolean;   { n de 1 à rowCount }
begin
  if (n>=1) and (n<=length(FrowMarked))
      then result:=FRowMarked[n-1]
      else result:=false;
end;

procedure TDBtable.setRowMarked(n: integer; w: boolean);
begin
  if (n<1) or (n>rowCount) then exit;
  if length(FrowMarked)<n then setlength(FrowMarked,n);
  FrowMarked[n-1]:=w;
end;

procedure TDBtable.MarkSelectedRows(mode:integer);
var
  i,n:integer;
  rr:TgridRect;
begin
  with TableFrame.DrawGrid1.selection do
  begin
    for i:=top to bottom do
    begin
      if FirstRowVisible then n:=i else n:=i+1;
      case mode of
        0: RowMarked[n]:=false;
        1: RowMarked[n]:=true;
        2: RowMarked[n]:=not RowMarked[n];
      end;
    end;
  end;
  rr.Left:=0;
  rr.Right:=-1;
  rr.Top:=0;
  rr.Bottom:=-1;
  TableFrame.DrawGrid1.selection:=rr;
  TableFrame.DrawGrid1.invalidate;
end;

procedure TDBtable.RemoveMarks;
begin
  setLength(FrowMarked,0);
end;

function TDBtable.XMLinfo: TXMLinfo;
begin
  if not assigned(XMLinfo0) then XMLinfo0:=TXMLinfo.create(self);
  result:= XMLinfo0;
end;

procedure TDBtable.GetSelection(var x1, y1, x2, y2: integer);
begin
  with TableFrame.DrawGrid1.selection do
  begin
    x1:= Editform.GridColToTableCol(left);
    x2:= Editform.GridColToTableCol(right);
    y1:= Editform.GridRowToTableRow(top);
    y2:= Editform.GridRowToTableRow(bottom);
  end;

  //Si l'utilisateur à sélectionné la ligne ou colonne fixe, on corrige
  if x1<0 then x1:=0;
  if y1<0 then y1:=0;
end;

procedure TDBtable.SetSelection(x1, y1, x2, y2: integer);
var
  rr: TgridRect;
begin

  rr.Left:=   EditForm.TableColToGridCol(x1);
  rr.Right:=  EditForm.TableColToGridCol(x2);
  rr.Top:=    EditForm.TableRowToGridRow(y1);
  rr.Bottom:= EditForm.TableRowToGridRow(y2);

  TableFrame.DrawGrid1.selection := rr;
  TableFrame.Invalidate;
end;

procedure TDBtable.CopySelectionToClipboard(WithNames: boolean; sep, StringSep: AnsiString; Nbdeci:integer);
begin
  clipboard.AsText:= GetSelectionAsText(WithNames, sep, StringSep, Nbdeci);
end;

function TDBtable.GetSelectionAsText(WithNames: boolean; sep, StringSep: AnsiString; Nbdeci:integer): AnsiString;
var
  x1,y1,x2,y2: integer;
  i,j:integer;
  st: AnsiString;
begin
  GetSelection(x1,y1,x2,y2);

  st:='';
  if WithNames then
  for i:= x1 to x2 do
  begin
    st:= st+ StringSep+ Fields[i] + StringSep;
    if i<>x2 then st:=st+Sep;
  end;
  st:=st + CRLF;

  for j:= y1 to y2 do
  begin
    for i:= x1 to x2 do
    begin
      case Coltype[i] of
        gvBoolean:    st:= st + Bstr(VBoolean[i,j]);
        gvInteger:    st:= st + Int64str(VInteger[i,j]); { 64 bits }
        gvFloat :     st:= st + Estr(VFloat[i,j],Nbdeci) ;
        gvComplex:    st:= st + Estr(Vcomplex[i,j].x,Nbdeci)+'+i'+Estr(Vcomplex[i,j].y,Nbdeci);
        gvString:     st:= st + StringSep+ Vstring[i,j] + StringSep;
        gvDateTime:   st:= st + FormatDateTime('yyyy-mm-dd hh:mm:ss:zzz',VDateTime[i,j]);
      end;
      if i<>x2 then st:=st+Sep;
    end;
    st:=st + CRLF;
  end;
  result:= st;
end;


{ TDBrecordTable }

constructor TDBrecordTable.create(Atable: TDBtable; row:integer);
begin
  inherited create;

  table:=Atable;
  NumLine:=row;
  //FcannotModify:=true;
end;

function TDBrecordTable.getValue(name: AnsiString): TGvariant;
begin
  result:=table.getValue(name,NumLine);
end;

procedure TDBrecordTable.setValue(name: AnsiString; var value: TGvariant);
begin
  table.setvalue(name,NumLine,value);
end;

function TDBrecordTable.getValue1(n: integer): TGvariant;
var
  tt:TtableRec;
begin
  tt:=table.TableRec[n];
  if assigned(tt)
    then result:=table.TableRec[n].Gvariant[NumLine]
    else result.init;
  Ferror:= not assigned(tt);
end;

procedure TDBrecordTable.setValue1(n: integer; var value: TGvariant);
var
  tt:TtableRec;
begin
  tt:=table.TableRec[n];
  if assigned(tt) then tt.Gvariant[NumLine]:=value;
  Ferror:= not assigned(tt);
end;

function TDBrecordTable.fields: TstringList;
begin
  result:=table.fields;
end;


{ Méthodes stm de TDBtable }

procedure proTDBtable_create(var pu:typeUO);
begin
  createPgObject('',pu,TDBtable);
end;


procedure proTDBtable_AddField(st:AnsiString;tp:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (tp<1) or (tp>intG(high(TGvariantType)))
    then sortieErreur('TDBtable.AddField : invalid type');

  TDBtable(pu).AddField(st,TGvariantType(tp));
  if TDBtable(pu).Ferror then sortieErreur('TDBtable.AddField : field already exists');
end;

procedure proTDBtable_DeleteField(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBtable(pu).DeleteField(st);
  if TDBtable(pu).Ferror then sortieErreur('TDBtable.DeleteField : field does not exist');
end;

procedure proTDBtable_clear(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBtable(pu).clearFields;
end;

function fonctionTDBtable_FieldExists(st:AnsiString;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TDBtable(pu) do
  result:= Fields.IndexOf(st)>=0;
end;

function fonctionTDBgrid0_ColCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TDBtable(pu).ColCount;
end;

function fonctionTDBgrid0_RowCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TDBtable(pu).RowCount;
end;


function fonctionTDBtable_Vtype(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDBtable(pu) do
  if (n>=1) and (n<=ColCount)
    then result:=ord(ColType[n-1])
    else sortieErreur('Column number out of range');
end;


function fonctionTDBtable_Names(n:integer;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TDBtable(pu) do
  if (n>=1) and (n<=ColCount)
    then result:= Fields[n-1]
    else sortieErreur('TDBtable.Names : Column number out of range');
end;


function fonctionTDBtable_Lines(n:integer; var pu:typeUO): TDBrecordTable;
begin
  verifierObjet(pu);
  with TDBtable(pu) do
  begin
    result:= getDBrecordTable(n-1);
    if result=nil then sortieErreur('TDBtable.Lines : row number out of range');
  end;
end;

procedure proTDBtable_AddLine(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBtable(pu).addLine;
end;

procedure proTDBtable_AddRecord(var rec: TDBrecord; var pu:typeUO);
begin
  verifierObjet(pu);
  TDBtable(pu).addRecord(rec);
end;


        { Partie Commune à TDBgrid et TDBtable }

procedure proTDBgrid0_ShowButtons(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBtable(pu).ButtonsVisible:=w;
end;

function fonctionTDBgrid0_ShowButtons(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TDBtable(pu).ButtonsVisible;
end;


function fonctionTDBgrid0_CanModify(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TDBtable(pu).TableFrame.FcanEdit;
end;


procedure proTDBgrid0_FirstColVisible(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBtable(pu).setFirstColVisible(w);
end;

function fonctionTDBgrid0_FirstColVisible(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TDBtable(pu).FirstColVisible;
end;

procedure proTDBgrid0_ButtonColumn(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBtable(pu).button0:=w;
  with TDBtable(pu) do InitForm;
end;

function fonctionTDBgrid0_ButtonColumn(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TDBtable(pu).button0;
end;

procedure proTDBgrid0_FirstRowVisible(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBtable(pu).setFirstRowVisible(w);
end;

function fonctionTDBgrid0_FirstRowVisible(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TDBtable(pu).FirstRowVisible;
end;


procedure proTDBgrid0_ColWidths(n:integer;w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (n<1) or (n>2000) then sortieErreur('TDBtable.ColWidths : index out of range');
  if (w<0) or (w>2000) then sortieErreur('TDBtable.ColWidths : value out of range');
  TDBtable(pu).ColumnWidths[n]:=w;
  with TDBtable(pu) do InitForm;
end;

function fonctionTDBgrid0_ColWidths(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  if (n<0) or (n>2000) then sortieErreur('TDBtable.ColWidths : index out of range');
  result:=TDBtable(pu).ColumnWidths[n];
end;


procedure proTDBgrid0_ColVisible(n:integer;w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  if (n<1) or (n>2000) then sortieErreur('TDBtable.ColVisible : index out of range');
  TDBtable(pu).ColumnVisible[n]:=w;
  with TDBtable(pu) do InitForm;
end;

function fonctionTDBgrid0_ColVisible(n:integer;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  if (n<0) or (n>2000) then sortieErreur('TDBtable.ColVisible : index out of range');
  result:=TDBtable(pu).ColumnVisible[n];
end;


procedure proTDBgrid0_onSelectCell(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu) do OnSel.setad(w);
end;

function fonctionTDBgrid0_onSelectCell(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDBtable(pu) do result:=OnSel.ad;
end;

procedure proTDBgrid0_onDblClick(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu) do OnDblClick.setad(w);
end;

function fonctionTDBgrid0_onDblClick(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDBtable(pu) do result:=OnDblClick.ad;
end;

procedure proTDBgrid0_onRightClick(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu) do OnRightClick.setad(w);
end;

function fonctionTDBgrid0_onRightClick(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDBtable(pu) do result:=OnRightClick.ad;
end;

procedure proTDBgrid0_onClickButton(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu) do OnClickB.setad(w);
end;

function fonctionTDBgrid0_onClickButton(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDBtable(pu) do result:=OnClickB.ad;
end;

{ Propriétés associées à TableFrame }


procedure proTDBgrid0_CanModify(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBtable(pu).TableFrame.FcanEdit:=w;
end;

procedure proTDBgrid0_RowSelect(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu).TableFrame.DrawGrid1 do
  if w then Options:=Options+[goRowSelect]
       else Options:=Options-[goRowSelect];
end;

function fonctionTDBgrid0_RowSelect(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= goRowSelect in TDBtable(pu).TableFrame.DrawGrid1.Options;
end;


procedure proTDBgrid0_ColSizing(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu).TableFrame.DrawGrid1 do
  if w
    then Options:=Options+[goColSizing]
    else Options:=Options-[goColSizing];
end;

function fonctionTDBgrid0_ColSizing(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TDBtable(pu).TableFrame.DrawGrid1 do
  result:=goColSizing in Options;
end;


procedure proTDBgrid0_Color(w:integer;var pu:typeUO);
begin
 verifierObjet(pu);
 TDBtable(pu).GridColor:=w;
end;

function fonctionTDBgrid0_Color(var pu:typeUO):integer;
begin
 verifierObjet(pu);
 result:=TDBtable(pu).GridColor;
end;

procedure proTDBgrid0_MarkColor(w:integer;var pu:typeUO);
begin
 verifierObjet(pu);
 TDBtable(pu).GridMarkedColor:=w;
end;

function fonctionTDBgrid0_MarkColor(var pu:typeUO):integer;
begin
 verifierObjet(pu);
 result:=TDBtable(pu).GridMarkedColor;
end;


procedure proTDBgrid0_FixedColor(w:integer;var pu:typeUO);
begin
 verifierObjet(pu);
 TDBtable(pu).GridFixedColor:=w;
end;

function fonctionTDBgrid0_FixedColor(var pu:typeUO):integer;
begin
 verifierObjet(pu);
 result:=TDBtable(pu).GridFixedColor;
end;


procedure proTDBgrid0_DefaultColWidth(w:integer;var pu:typeUO);
begin
 verifierObjet(pu);
 TDBtable(pu).TableFrame.DrawGrid1.DefaultColWidth:=w;
end;

function fonctionTDBgrid0_DefaultColWidth(var pu:typeUO):integer;
begin
 verifierObjet(pu);
 result:=TDBtable(pu).TableFrame.DrawGrid1.DefaultColWidth;
end;


procedure proTDBgrid0_DefaultRowHeight(w:integer;var pu:typeUO);
begin
 verifierObjet(pu);
 TDBtable(pu).TableFrame.DrawGrid1.DefaultRowHeight:=w;
end;

function fonctionTDBgrid0_DefaultRowHeight(var pu:typeUO):integer;
begin
 verifierObjet(pu);
 result:=TDBtable(pu).TableFrame.DrawGrid1.DefaultRowHeight;
end;

function fonctionTDBgrid0_font(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TDBtable(pu) do
  begin
    result:=TableFrame.DrawGrid1.font;
  end;
end;


procedure proTDBgrid0_Col(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu) do
  begin
    if (w<1) or (w>ColCount) then sortieErreur('TDBgrid0.Col : value out of range');
    if FirstColVisible
      then TableFrame.DrawGrid1.Col:=w
      else TableFrame.DrawGrid1.Col:=w-1;
  end;
end;

function fonctionTDBgrid0_Col(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDBtable(pu) do
  begin
    result:=TableFrame.DrawGrid1.Col;
    if not FirstColVisible then dec(result);
  end;
end;


procedure proTDBgrid0_Row(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu) do
  begin
    if (w<1) or (w>RowCount) then sortieErreur('TDBgrid0.Row : value out of range');
    if FirstRowVisible
      then TableFrame.DrawGrid1.Row:=w
      else TableFrame.DrawGrid1.Row:=w-1;
  end;
end;

function fonctionTDBgrid0_Row(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDBtable(pu) do
  begin
    result:=TableFrame.DrawGrid1.Row;
    if not FirstRowVisible then dec(result);
  end;
end;

procedure proTDBgrid0_RowMarked(n:integer;w:boolean; var pu:typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu) do
  begin
    RowMarked[n]:=w;
    TableFrame.invalidate;
  end;
end;

function fonctionTDBgrid0_RowMarked(n:integer;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= TDBtable(pu).RowMarked[n];
end;

procedure proTDBgrid0_MarkSelectedRows(mode:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu) do
  begin
    MarkSelectedRows(mode);
    TableFrame.invalidate;
  end;
end;

procedure proTDBgrid0_GetSelection(var x1,y1,x2,y2: integer;var pu: typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu) do
    getSelection(x1,y1,x2,y2);

  inc(x1);inc(y1);inc(x2);inc(y2);
end;

procedure proTDBgrid0_SetSelection(x1,y1,x2,y2: integer;var pu: typeUO);
begin
  verifierObjet(pu);

  with TDBtable(pu) do
  begin
    if x1<1 then x1:=1;
    if x2>colCount then x2:= ColCount;
    if y1<1 then y1:=1;
    if y2>RowCount then y2:=RowCount;

    setSelection(x1-1,y1-1,x2-1,y2-1);
  end;
end;



procedure proTDBgrid0_CopySelectionToClipboard(var pu: typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu) do CopySelectionToClipboard(true, #9,'',-1);
end;

procedure proTDBgrid0_CopySelectionToClipboard_1(WithNames: boolean; sep, StringSep: AnsiString; Nbdeci:integer; var pu: typeUO);
begin
  verifierObjet(pu);
  with TDBtable(pu) do CopySelectionToClipboard(WithNames, sep, StringSep, Nbdeci);
end;

function fonctionTDBgrid0_GetSelectionAsText(WithNames: boolean; sep, StringSep: AnsiString; Nbdeci:integer; var pu: typeUO): AnsiString;
begin
  verifierObjet(pu);
  with TDBtable(pu) do result:= GetSelectionAsText(WithNames, sep, StringSep, Nbdeci);
end;

{ TXMLinfo }

constructor TXMLinfo.create(TheTable: TDBtable);
begin
  table:= TheTable;
  FullName:=TstringList.create;
end;

destructor TXMLinfo.destroy;
begin
  FullName.Free;
  XML:=nil;
  inherited;
end;

procedure TXMLinfo.AnalyseXML;
begin
  table.clearFields;
  FullName.Clear;
  getDBNode('', XML.DocumentElement);
  table.initform;
end;


procedure TXMLinfo.getDBNode(stRoot:AnsiString;child: IXMLnode);
var
  k:integer;
  st:AnsiString;
  LastRoot: AnsiString;
begin
  LastRoot:= stRoot;
  if stRoot<>''
    then stRoot:= stRoot+'.'+ Child.NodeName
    else stRoot:= Child.NodeName;

  if Child.HasChildNodes and not(Child.IsTextElement)
    then getDBList(stRoot,Child)
    else
    begin
      if LastRoot='response.meta' then
      begin
        if stRoot = 'response.meta.limit' then limit:= valI(Child.Text)
        else
        if stRoot = 'response.meta.offset' then offset:= valI(Child.Text)
        else
        if stRoot = 'response.meta.total_count' then total_count:=valI(Child.Text);
      end
      else
      begin
        k:= FullName.IndexOf(stRoot);
        if k<0 then
        begin
          FullName.Add(stRoot);
          table.addField(Child.NodeName,gvString,true);
          setlength(DbRowMax,table.fields.Count);
          k:= high(DbRowMax);
          DbRowMax[k]:=0;
        end
        else inc(DbRowMax[k]);

        if table.RowCount<=DbRowMax[k] then table.RowCount:= DbRowMax[k]+1;

        if Child.IsTextElement then table.Vstring[k,DbRowMax[k]] := Child.Text;
      end;
    end;
end;

procedure TXMLinfo.getDBList(stRoot:AnsiString;child: IXMLnode);
var
  i:integer;
begin
  for i:= 0 to child.ChildNodes.Count-1 do
    getDBNode(stRoot,child.ChildNodes[i]);
end;

Initialization
AffDebug('Initialization DBrecord1',0);

registerObject(TDBtable,sys);


end.
