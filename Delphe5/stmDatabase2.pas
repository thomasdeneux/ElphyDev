unit stmdataBase2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses  types,sysutils,classes,forms,controls,menus,editcont,

      ZClasses, ZDbcIntfs, ZDbcPostgreSql,
      util1,listG, stmdef,stmObj,NcDef2,stmPg,stmMemo1,stmPopup,
      DBrecord1;

type
  TDBconnection=
    class(typeUO)
      Connection: IZConnection;

      procedure ConnectDB(stProtocol, stHost:AnsiString;NumPort:integer; stbase, stUser, stPassword:AnsiString);
      procedure closeDB;

      destructor destroy;override;
      class function stmClassName:AnsiString;override;

      procedure InsertDBrecord(tableName:AnsiString; var db:TdbRecord);
    end;

  TDBstatement=class(typeUO)
                  statement: IZstatement;
                  destructor destroy;override;
                  class function stmClassName:AnsiString;override;
               end;

  TDBpreparedStatement=class(typeUO)
                  statement: IZpreparedStatement;
                  destructor destroy;override;
                  class function stmClassName:AnsiString;override;
               end;

  TDBCallableStatement=class(typeUO)
                  statement: IZcallableStatement;
                  destructor destroy;override;
                  class function stmClassName:AnsiString;override;
               end;

  TDBresultSet=class(typeUO)
                  EditForm:Tform;

                  resultSet: IZresultSet;
                  FIsOpen:boolean;
                  FcanModify:boolean;
                  FcanInsert:boolean;
                  FcanDelete:boolean;
                  FautoEdit:boolean;

                  colCount,rowCount:integer;
                  NameList:TstringList;
                  Ztype:  array of TZSQLtype;
                  GVtype: array of TGvariantType;
                  DeleteList:TdeleteList;
                  keys:AnsiString;


                  procedure setIsOpen(w:boolean);

                  constructor create;override;

                  destructor destroy;override;
                  class function stmClassName:AnsiString;override;

                  property isOpen:boolean read FisOpen write setIsOpen ;
                  property canModify:boolean read FcanModify write FcanModify;
                  property canInsert:boolean read FcanInsert write FcanInsert;
                  property canDelete:boolean read FcanDelete write FcanDelete;
                  property AutoEdit:boolean read FautoEdit write FautoEdit;


                  procedure close;
                  procedure invalidate;

                  function getPopUp:TpopupMenu;override;
                  procedure show(sender:Tobject);override;

                  procedure initParams;
                  procedure proprietes(sender:Tobject);
                  function getRowCount:integer;
                  function MoveTo(y: integer):boolean;
                  procedure DeleteRow(var curRow:integer);

                  procedure initRowBuffer(var rowBuffer:TDBrecord);
                  procedure freeRowBuffer(var rowBuffer:TDBrecord);
                  procedure loadRowBuffer(curRow:integer;var rowBuffer:TDBrecord);

                  function saveRowBuffer(curRow:integer; rowBuffer:TDBrecord):boolean;
                  function saveDBrecord(ARow:integer; db:TDBrecord):boolean;

               end;



{TDBconnection}
procedure proTDBconnection_create(protocol,host:AnsiString;port:integer;base,user,password:AnsiString;var pu:typeUO);pascal;
procedure proTDBconnection_CreateStatement(var ss: TDBstatement;var pu:typeUO);pascal;
procedure proTDBconnection_PrepareStatement(SQL: AnsiString;var  ss:TDBPreparedStatement;var pu:typeUO);pascal;
procedure proTDBconnection_PrepareCall(SQL: AnsiString;var ss: TDBCallableStatement;var pu:typeUO);pascal;

procedure proTDBconnection_CreateStatementWithParams(var Info: TstmMemo;var ss:TDBstatement;var pu:typeUO);pascal;
procedure proTDBconnection_PrepareStatementWithParams(SQL: AnsiString; var Info: TstmMemo;var ss:TDBPreparedStatement;var pu:typeUO);pascal;
procedure proTDBconnection_PrepareCallWithParams(SQL: AnsiString; var Info: TstmMemo;var ss:TDBCallableStatement;var pu:typeUO);pascal;

function fonctionTDBconnection_NativeSQL(SQL: AnsiString;var pu:typeUO):AnsiString;pascal;

procedure proTDBconnection_AutoCommit(x:Boolean;var pu:typeUO);pascal;
function fonctionTDBconnection_AutoCommit(var pu:typeUO): Boolean;pascal;

function fonctionTDBconnection_Metadata(var pu:typeUO): pointer;pascal;
procedure proTDBconnection_IsReadOnly(x:Boolean;var pu:typeUO);pascal;
function fonctionTDBconnection_IsReadOnly(var pu:typeUO): Boolean;pascal;

procedure proTDBconnection_Catalog(x:AnsiString;var pu:typeUO);pascal;
function fonctionTDBconnection_Catalog(var pu:typeUO): AnsiString;pascal;

procedure proTDBconnection_TransactionIsolation(x:integer;var pu:typeUO);pascal;
function fonctionTDBconnection_TransactionIsolation(var pu:typeUO):integer;pascal;

procedure proTDBconnection_commit(var pu:typeUO);pascal;
procedure proTDBconnection_rollback(var pu:typeUO);pascal;

procedure proTDBconnection_InsertDBrecord(tableName:AnsiString; var db:TdbRecord; var pu:typeUO);pascal;

{TDBstatement}
procedure proTDBstatement_ExecuteQuery(SQL: AnsiString;var ss:TDBresultset;var pu:typeUO);pascal;
procedure proTDBstatement_ExecuteQuery_1(var SQL: TstmMemo;var ss:TDBresultset;var pu:typeUO);pascal;
function fonctionTDBstatement_ExecuteUpdate(SQL: AnsiString;var pu:typeUO):Integer;pascal;
function fonctionTDBstatement_ExecuteUpdate_1(var SQL:TstmMemo;var pu:typeUO):Integer;pascal;
procedure proTDBstatement_Close(var pu:typeUO);pascal;

procedure proTDBstatement_FetchDirection(x:integer;var pu:typeUO);pascal;
function fonctionTDBstatement_FetchDirection(var pu:typeUO):integer;pascal;

procedure proTDBstatement_FetchSize(x:integer;var pu:typeUO);pascal;
function fonctionTDBstatement_FetchSize(var pu:typeUO):integer;pascal;

procedure proTDBstatement_ResultSetConcurrency(x:integer;var pu:typeUO);pascal;
function fonctionTDBstatement_ResultSetConcurrency(var pu:typeUO):integer;pascal;

procedure proTDBstatement_ResultSetType(x:integer;var pu:typeUO);pascal;
function fonctionTDBstatement_ResultSetType(var pu:typeUO):integer;pascal;

procedure proTDBstatement_PostUpdates(x:integer;var pu:typeUO);pascal;
function fonctionTDBstatement_PostUpdates(var pu:typeUO):integer;pascal;

procedure proTDBstatement_LocateUpdates(x:integer;var pu:typeUO);pascal;
function fonctionTDBstatement_LocateUpdates(var pu:typeUO):integer;pascal;



{TDBPreparedStatement}
procedure proTDBPreparedStatement_ExecuteQueryPrepared(var ss: TDBresultset;var pu:typeUO);pascal;
function fonctionTDBPreparedStatement_ExecuteUpdatePrepared(var pu:typeUO):Integer;pascal;
function fonctionTDBPreparedStatement_ExecutePrepared(var pu:typeUO):Boolean;pascal;

procedure proTDBPreparedStatement_SetDefaultValue(ParameterIndex: Integer; Value: AnsiString;var pu:typeUO);pascal;

procedure proTDBPreparedStatement_SetNull(ParameterIndex: Integer; SQLType: integer;var pu:typeUO);pascal;
procedure proTDBPreparedStatement_SetBoolean(ParameterIndex: Integer; Value: Boolean;var pu:typeUO);pascal;
procedure proTDBPreparedStatement_SetShortInt(ParameterIndex: Integer; Value: ShortInt;var pu:typeUO);pascal;
procedure proTDBPreparedStatement_SetSmallint(ParameterIndex: Integer; Value: SmallInt;var pu:typeUO);pascal;
procedure proTDBPreparedStatement_SetInteger(ParameterIndex: Integer; Value: Integer;var pu:typeUO);pascal;
procedure proTDBPreparedStatement_SetSingle(ParameterIndex: Integer; Value: Single;var pu:typeUO);pascal;
procedure proTDBPreparedStatement_SetDouble(ParameterIndex: Integer; Value: Double;var pu:typeUO);pascal;
procedure proTDBPreparedStatement_SetString(ParameterIndex: Integer; Value: AnsiString;var pu:typeUO);pascal;
procedure proTDBPreparedStatement_SetElphyObject(ParameterIndex: Integer; var obj:typeUO;var pu:typeUO);pascal;


procedure proTDBPreparedStatement_ClearParameters(var pu:typeUO);pascal;

{Callable SQL statement}
procedure proTDBCallableStatement_RegisterOutParameter(ParameterIndex: Integer; SQLType: Integer;var pu:typeUO);pascal;
function fonctionTDBCallableStatement_WasNull(var pu:typeUO):Boolean;pascal;

function fonctionTDBCallableStatement_IsNull(ParameterIndex: Integer;var pu:typeUO):Boolean;pascal;
function fonctionTDBCallableStatement_GetString(ParameterIndex: Integer;var pu:typeUO):AnsiString;pascal;
function fonctionTDBCallableStatement_GetBoolean(ParameterIndex: Integer;var pu:typeUO):Boolean;pascal;
function fonctionTDBCallableStatement_GetShortInt(ParameterIndex: Integer;var pu:typeUO):ShortInt;pascal;
function fonctionTDBCallableStatement_GetSmallint(ParameterIndex: Integer;var pu:typeUO):SmallInt;pascal;
function fonctionTDBCallableStatement_GetInteger(ParameterIndex: Integer;var pu:typeUO):Integer;pascal;
function fonctionTDBCallableStatement_GetSingle(ParameterIndex: Integer;var pu:typeUO):Single;pascal;
function fonctionTDBCallableStatement_GetDouble(ParameterIndex: Integer;var pu:typeUO):Double;pascal;

{TDBresultset}
procedure proTDBresultset_create(var pu:typeUO);pascal;

function fonctionTDBresultset_Next(var pu:typeUO):Boolean;pascal;
procedure proTDBresultset_Close(var pu:typeUO);pascal;
function fonctionTDBresultset_WasNull(var pu:typeUO):Boolean;pascal;

function fonctionTDBresultset_IsNull(ColumnIndex: Integer;var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_GetString(ColumnIndex: Integer;var pu:typeUO):AnsiString;pascal;
function fonctionTDBresultset_GetBoolean(ColumnIndex: Integer;var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_GetShortInt(ColumnIndex: Integer;var pu:typeUO):ShortInt;pascal;
function fonctionTDBresultset_GetSmallint(ColumnIndex: Integer;var pu:typeUO):SmallInt;pascal;
function fonctionTDBresultset_GetInteger(ColumnIndex: Integer;var pu:typeUO):Integer;pascal;
function fonctionTDBresultset_GetSingle(ColumnIndex: Integer;var pu:typeUO):Single;pascal;
function fonctionTDBresultset_GetDouble(ColumnIndex: Integer;var pu:typeUO):Double;pascal;
function fonctionTDBresultset_GetDateTime(ColumnIndex: Integer;var pu:typeUO):TdateTime;pascal;

procedure proTDBresultset_GetElphyObject(ColumnIndex:integer;var obj:typeUO;var pu:typeUO);pascal;

function fonctionTDBresultset_IsNull_1(ColumnName: AnsiString;var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_GetString_1(ColumnName: AnsiString;var pu:typeUO):AnsiString;pascal;
function fonctionTDBresultset_GetBoolean_1(ColumnName: AnsiString;var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_GetShortInt_1(ColumnName: AnsiString;var pu:typeUO):ShortInt;pascal;
function fonctionTDBresultset_GetSmallint_1(ColumnName: AnsiString;var pu:typeUO):SmallInt;pascal;
function fonctionTDBresultset_GetInteger_1(ColumnName: AnsiString;var pu:typeUO):Integer;pascal;
function fonctionTDBresultset_GetSingle_1(ColumnName: AnsiString;var pu:typeUO):Single;pascal;
function fonctionTDBresultset_GetDouble_1(ColumnName: AnsiString;var pu:typeUO):Double;pascal;
function fonctionTDBresultset_GetDateTime_1(ColumnName: AnsiString;var pu:typeUO):TdateTime;pascal;

procedure proTDBresultset_GetElphyObject_1(ColumnName: AnsiString;var obj:typeUO;var pu:typeUO);pascal;


function fonctionTDBresultset_Metadata(var pu:typeUO): pointer;pascal;
function fonctionTDBresultset_FindColumn(ColumnName: AnsiString;var pu:typeUO):Integer;pascal;

function fonctionTDBresultset_IsBeforeFirst(var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_IsAfterLast(var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_IsFirst(var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_IsLast(var pu:typeUO):Boolean;pascal;
procedure proTDBresultset_BeforeFirst(var pu:typeUO);pascal;
procedure proTDBresultset_AfterLast(var pu:typeUO);pascal;
function fonctionTDBresultset_First(var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_Last(var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_GetRow(var pu:typeUO):Integer;pascal;
function fonctionTDBresultset_MoveAbsolute(Row: Integer;var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_MoveRelative(Rows: Integer;var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_Previous(var pu:typeUO):Boolean;pascal;

function fonctionTDBresultset_RowUpdated(var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_RowInserted(var pu:typeUO):Boolean;pascal;
function fonctionTDBresultset_RowDeleted(var pu:typeUO):Boolean;pascal;

procedure proTDBresultset_UpdateNull(ColumnIndex: Integer;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateBoolean(ColumnIndex: Integer; Value: Boolean;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateShortint(ColumnIndex: Integer; Value: ShortInt;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateSmallint(ColumnIndex: Integer; Value: SmallInt;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateInteger(ColumnIndex: Integer; Value: Integer;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateSingle(ColumnIndex: Integer; Value: Single;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateDouble(ColumnIndex: Integer; Value: Double;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateDateTime(ColumnIndex: Integer; Value: TdateTime;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateString(ColumnIndex: Integer; Value: AnsiString;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateElphyObject(ColumnIndex:integer; var obj:typeUO;var pu:typeUO);pascal;

procedure proTDBresultset_UpdateNull_1(ColumnName: AnsiString;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateBoolean_1(ColumnName: AnsiString; Value: Boolean;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateShortint_1(ColumnName: AnsiString; Value: ShortInt;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateSmallint_1(ColumnName: AnsiString; Value: SmallInt;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateInteger_1(ColumnName: AnsiString; Value: Integer;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateSingle_1(ColumnName: AnsiString; Value: Single;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateDouble_1(ColumnName: AnsiString; Value: Double;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateDateTime_1(ColumnName: AnsiString; Value: TdateTime;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateString_1(ColumnName: AnsiString; Value: AnsiString;var pu:typeUO);pascal;
procedure proTDBresultset_UpdateElphyObject_1(ColumnName: AnsiString; var obj:typeUO;var pu:typeUO);pascal;

procedure proTDBresultset_InsertRow(var pu:typeUO);pascal;
procedure proTDBresultset_UpdateRow(var pu:typeUO);pascal;
procedure proTDBresultset_DeleteRow(Arow:integer; var pu:typeUO);pascal;
procedure proTDBresultset_RefreshRow(var pu:typeUO);pascal;
procedure proTDBresultset_CancelRowUpdates(var pu:typeUO);pascal;
procedure proTDBresultset_MoveToInsertRow(var pu:typeUO);pascal;
procedure proTDBresultset_MoveToCurrentRow(var pu:typeUO);pascal;

procedure proTDBresultset_Show(var pu:typeUO);pascal;

procedure proTDBresultset_getDBrecord(var db:TDBrecord;num:integer; var pu:typeUO);pascal;
procedure proTDBresultset_setDBrecord(var db:TDBrecord;num:integer; var pu:typeUO);pascal;
procedure proTDBresultset_deleteDBrecord(num:integer; var pu:typeUO);pascal;
procedure proTDBresultset_insertDBrecord(var db:TDBrecord; var pu:typeUO);pascal;

procedure proTDBresultset_keys(st:AnsiString; var pu:typeUO);pascal;
function fonctionTDBresultset_keys(var pu:typeUO): AnsiString;pascal;



function fonctionTDBresultset_RowCount(var pu:typeUO):integer;pascal;

{ResultSet metadata}

function fonctionTDBresultsetMetadata_GetColumnCount(pu:typeUO):Integer;pascal;
function fonctionTDBresultsetMetadata_IsAutoIncrement(Column: Integer;pu:typeUO):Boolean;pascal;
function fonctionTDBresultsetMetadata_IsCaseSensitive(Column: Integer;pu:typeUO):Boolean;pascal;
function fonctionTDBresultsetMetadata_IsSearchable(Column: Integer;pu:typeUO):Boolean;pascal;
function fonctionTDBresultsetMetadata_IsCurrency(Column: Integer;pu:typeUO):Boolean;pascal;
function fonctionTDBresultsetMetadata_IsNullable(Column: Integer;pu:typeUO):integer;pascal;

function fonctionTDBresultsetMetadata_IsSigned(Column: Integer;pu:typeUO):Boolean;pascal;
function fonctionTDBresultsetMetadata_GetColumnDisplaySize(Column: Integer;pu:typeUO):Integer;pascal;
function fonctionTDBresultsetMetadata_GetColumnLabel(Column: Integer;pu:typeUO):AnsiString;pascal;
function fonctionTDBresultsetMetadata_GetColumnName(Column: Integer;pu:typeUO):AnsiString;pascal;
function fonctionTDBresultsetMetadata_GetSchemaName(Column: Integer;pu:typeUO):AnsiString;pascal;
function fonctionTDBresultsetMetadata_GetPrecision(Column: Integer;pu:typeUO):Integer;pascal;
function fonctionTDBresultsetMetadata_GetScale(Column: Integer;pu:typeUO):Integer;pascal;
function fonctionTDBresultsetMetadata_GetTableName(Column: Integer;pu:typeUO):AnsiString;pascal;
function fonctionTDBresultsetMetadata_GetCatalogName(Column: Integer;pu:typeUO):AnsiString;pascal;
function fonctionTDBresultsetMetadata_GetColumnType(Column: Integer;pu:typeUO):integer;pascal;
function fonctionTDBresultsetMetadata_GetColumnTypeName(Column: Integer;pu:typeUO):AnsiString;pascal;
function fonctionTDBresultsetMetadata_IsReadOnly(Column: Integer;pu:typeUO):Boolean;pascal;
function fonctionTDBresultsetMetadata_IsWritable(Column: Integer;pu:typeUO):Boolean;pascal;
function fonctionTDBresultsetMetadata_IsDefinitelyWritable(Column: Integer;pu:typeUO):Boolean;pascal;
function fonctionTDBresultsetMetadata_GetDefaultValue(Column: Integer;pu:typeUO):AnsiString;pascal;

procedure proDBgetSupportedProtocols(var memo:TstmMemo);pascal;


implementation

uses edResultSet2,formDlg2;


{ TDBconnection }

procedure TDBconnection.closeDB;
begin
  if Assigned(Connection) then
    if not Connection.IsClosed then
      Connection.Close;
end;

procedure TDBconnection.ConnectDB(stProtocol, stHost: AnsiString; NumPort: integer; stbase, stUser, stPassword: AnsiString);
var
  Url: AnsiString;
begin
  if stProtocol='' then stProtocol:='postgresql-8';
  if stHost='' then stHost:='localhost';

  if NumPort > 0
    then Url := Format('zdbc:%s://%s:%d/%s?UID=%s;PWD=%s',
               [stProtocol, stHost,NumPort, stbase, stUser, stPassword])

    else Url := Format('zdbc:%s://%s/%s?UID=%s;PWD=%s',
               [stProtocol, stHost, stbase, stUser, stPassword]);


  Connection := DriverManager.GetConnectionWithParams(Url, nil);
  Connection.SetAutoCommit(True);
  Connection.SetTransactionIsolation(tiReadCommitted);
  Connection.Open;


end;

destructor TDBconnection.destroy;
begin
  closedb;
  inherited;
end;


class function TDBconnection.stmClassName: AnsiString;
begin
  result:='DBconnection';
end;

procedure TDBconnection.InsertDBrecord(tableName:AnsiString; var db:TdbRecord);
var
  stat:IZpreparedStatement;
  sql,st1,st2:AnsiString;
  i:integer;
begin
  st1:='('+db.fields[0];
  st2:='(?';
  for i:=1 to db.fields.count-1 do
  begin
    st1:=st1+','+db.fields[i];
    st2:=st2+',?';
  end;
  st1:=st1+')';
  st2:=st2+')';

  sql:='insert into '+tableName+' '+st1+' values '+st2;

  stat:=connection.prepareStatement(sql);


  for i:=0 to db.fields.Count-1 do
  with PGvariant( db.fields.Objects[i])^ do
  case Vtype of
    gvBoolean: stat.SetBoolean(i+1,Vboolean);
    gvInteger: stat.SetLong(i+1,Vinteger);
    gvFloat:   stat.SetDouble(i+1,Vfloat);
    gvString:  stat.SetString(i+1,Vstring);
    gvDateTime:stat.setTimeStamp(i+1,VdateTime);
  end;

  stat.ExecuteUpdatePrepared;
end;


{TDBstatement}
destructor TDBstatement.destroy;
begin
  statement.Close;
  inherited;
end;

class function TDBstatement.stmClassName:AnsiString;
begin
  result:='DBstatement';
end;

{TDBpreparedStatement}
destructor TDBpreparedStatement.destroy;
begin
  statement.Close;
  inherited;
end;

class function TDBpreparedStatement.stmClassName:AnsiString;
begin
  result:='DBpreparedStatement';
end;

{TDBCallableStatement}
destructor TDBCallableStatement.destroy;
begin
  statement.Close;
  inherited;
end;

class function TDBCallableStatement.stmClassName:AnsiString;
begin
  result:='DBCallableStatement';
end;

{TDBresultSet}
procedure TDBresultSet.close;
begin
  if isOpen then
  begin
    resultSet.Close;
    {resultSet:=nil;}
    isOpen:=false;
  end;
end;

constructor TDBresultSet.create;
begin
  inherited;
  deleteList:=TdeleteList.create;
  NameList:=TstringList.create;
end;

destructor TDBresultSet.destroy;
begin
  editForm.Free;
  editForm:=nil;
  Close;
  DeleteList.Free;
  NameList.free;
  inherited;
end;

procedure TDBresultSet.invalidate;
begin
  messageToRef(uomsg_invalidateData,nil);
  if assigned(editForm) then TeditResultSet2(editForm).init(self);
end;

procedure TDBresultSet.setIsOpen(w: boolean);
var
  old:boolean;
begin
  old:=FisOpen;
  FisOpen:=w;
  if old<>FisOpen then invalidate;
end;

procedure TDBresultSet.show(sender:Tobject);
begin
  if not assigned(EditForm) then editForm:=TeditResultSet2.create(formStm);

  TeditResultSet2(editForm).init(self);
  TeditResultSet2(editForm).show;
end;

class function TDBresultSet.stmClassName:AnsiString;
begin
  result:='DBresultSet';
end;

function TDBresultSet.GetRowCount:integer;
begin
  result:=0;
  if resultSet.First then
  begin
    result:=1;
    while resultSet.Next do inc(result);
  end;
end;


procedure TDBresultSet.proprietes(sender: Tobject);
var
  dlg:TdlgForm2;
  i:integer;
begin
  dlg:=TdlgForm2.Create(formStm);
  try
  dlg.setBoolean('Can modify',FcanModify);
  dlg.setBoolean('Can insert',FcanInsert);
  dlg.setBoolean('Can delete',FcanDelete);
  dlg.setBoolean('Auto Edit',FautoEdit);

  for i:=1 to 3 do
    dlg.control[i].Enabled:=(resultSet.GetConcurrency=rcUpdatable);

  if dlg.showModal=mrOK then updateAllVar(dlg);

  finally
  dlg.free;
  end;
end;

function TDBresultSet.getPopUp:TpopupMenu;
begin
  with PopUps do
  begin
    PopUpItem(pop_TUO2,'TUO2_Show').onClick:=self.Show;
    PopUpItem(pop_TUO2,'TUO2_Properties').onClick:=Proprietes;

    result:=pop_TUO2;
  end;
end;

function TDBResultSet.MoveTo(y: integer):boolean;
begin
  y:=deleteList.RelToAbs(y);
  result:=resultSet.MoveAbsolute(y);
end;

procedure TDBresultSet.DeleteRow(var curRow:integer);
begin
  MoveTo(curRow);
  resultSet.DeleteRow;
  with DeleteList do add(RelToAbs(curRow));
  dec(rowCount);
  if curRow>rowCount then curRow:=RowCount;
  invalidate;
end;

procedure TDBresultset.initParams;
var
  i:integer;

begin
  ColCount:=resultSet.GetMetadata.GetColumnCount;
  RowCount:=0;
  if resultSet.First then
  begin
    rowCount:=1;
    while resultSet.Next do inc(rowCount);
  end;
  deleteList.Clear;

  NameList.clear;
  setLength(GVtype,ColCount);
  setLength(Ztype, ColCount);
  for i:=1 to Colcount do
  begin
    NameList.Add(resultset.getMetaData.GetColumnLabel(i));
    Ztype[i-1]:=resultSet.GetMetadata.GetColumnType(i);
    case Ztype[i-1] of
      stBoolean:                            GVtype[i-1]:= GVboolean;
      stByte, stShort, stInteger, stLong:   GVtype[i-1]:= GVInteger;
      stFloat, stDouble, stBigDecimal:      GVtype[i-1]:= GVfloat;
      stDate, stTime, stTimeStamp:          GVtype[i-1]:= GVdateTime;
      stString, stUnicodeString,
      stAsciiStream, stUnicodeStream:       GVtype[i-1]:= GVstring;
    end;
  end;
end;


procedure TDBresultSet.freeRowBuffer(var rowBuffer: TDBrecord);
var
  i:integer;
begin
  rowBuffer.Free;
  rowBuffer:=nil;
end;


procedure TDBresultSet.initRowBuffer(var rowBuffer: TDBrecord);
var
  i:integer;
begin
  if not assigned(rowBuffer) then
    begin
        rowBuffer:=TDBrecord.create;
        rowBuffer.notPublished := True;
        rowBuffer.FChild := True;
    end
    else rowBuffer.clear;

  for i:=1 to colCount do
    rowBuffer.AddField(resultSet.GetMetadata.GetColumnLabel(i),gvNull);
end;


procedure TDBResultSet.LoadRowBuffer(curRow:integer;var rowBuffer:TDBrecord);
var
  i:integer;
  Ztype:TZSQLtype;

begin
  if not isOpen then exit;
  
  if (curRow>=1) and (curRow<=RowCount) then
  begin
    MoveTo(curRow);

    for i:=1 to ColCount do
    begin
      Ztype:=resultSet.GetMetadata.GetColumnType(i);

      case Ztype of
        stBoolean:      rowBuffer.Vboolean[i-1]:=resultSet.GetBoolean(i);

        stByte:         rowBuffer.VInteger[i-1]:=resultSet.GetByte(i);
        stShort:        rowBuffer.VInteger[i-1]:=resultSet.GetShort(i);
        stInteger:      rowBuffer.VInteger[i-1]:=resultSet.GetInt(i);
        stLong:         rowBuffer.VInteger[i-1]:=resultSet.GetLong(i);

        stFloat:        rowBuffer.Vfloat[i-1]:=resultSet.GetFloat(i);
        stDouble:       rowBuffer.Vfloat[i-1]:=resultSet.GetDouble(i);
        stBigDecimal:   rowBuffer.Vfloat[i-1]:=resultSet.GetBigDecimal(i);

        stDate:         rowBuffer.VDateTime[i-1]:=resultSet.GetDate(i);
        stTime:         rowBuffer.VDateTime[i-1]:=resultSet.GetTime(i);
        stTimestamp:    rowBuffer.VDateTime[i-1]:=resultSet.GetTimeStamp(i);


        stString, stUnicodeString,stAsciiStream, stUnicodeStream:
                        rowBuffer.Vstring[i-1]:=resultSet.GetString(i);
      end;
    end;
    {rowBuffer.showModal;}

  end
  else
  if (curRow=RowCount+1) then
  begin
    for i:=1 to ColCount do
    begin
      rowBuffer.Vfloat[i-1]:=0;
      rowBuffer.Vstring[i-1]:='';
    end;
  end;
end;

function TDBResultSet.saveRowBuffer(curRow:integer; rowBuffer:TDBrecord):boolean;
var
  i:integer;
  Ztype:TZSQLtype;
begin
  result:=true;
  if (curRow>=1) and (curRow<=RowCount) then MoveTo(curRow)
  else
  if (curRow=RowCount+1) then resultSet.MoveToInsertRow;

  if resultSet.RowDeleted then exit;

  for i:=1 to ColCount do
  begin
    Ztype:=resultSet.GetMetadata.GetColumnType(i);

    case Ztype of
      stBoolean:      resultSet.UpdateBoolean(i,rowBuffer[i-1].Vboolean);

      stByte:         resultSet.UpdateByte(i,rowBuffer[i-1].VInteger);
      stShort:        resultSet.UpdateShort(i,rowBuffer[i-1].VInteger);
      stInteger:      resultSet.UpdateInt(i,rowBuffer[i-1].VInteger);
      stLong:         resultSet.UpdateLong(i,rowBuffer[i-1].VInteger);

      stFloat:        resultSet.UpdateFloat(i,rowBuffer[i-1].Vfloat);
      stDouble:       resultSet.UpdateDouble(i,rowBuffer[i-1].Vfloat);
      stBigDecimal:   resultSet.UpdateBigDecimal(i,rowBuffer[i-1].Vfloat);

      stDate:         resultSet.UpdateDate(i,rowBuffer[i-1].VdateTime);
      stTime:         resultSet.UpdateTime(i,rowBuffer[i-1].VdateTime);
      stTimestamp:    resultSet.UpdateTimeStamp(i,rowBuffer[i-1].VdateTime);

      stString, stUnicodeString,stAsciiStream, stUnicodeStream:
                      resultSet.UpdateString(i,rowBuffer[i-1].Vstring);
    end;
  end;

  if (curRow>=1) and (curRow<=RowCount) then resultSet.UpdateRow
  else
  if (curRow=RowCount+1) then
  begin
    try
      resultSet.insertRow;
      inc(RowCount);
    except
      on E: Exception do
      begin
        messageCentral(E.Message);
        dec(curRow);
        result:=false;
      end;
    end;
  end;

  invalidate;
end;

function TDBResultSet.saveDBrecord(Arow:integer; db:TDBrecord):boolean;
var
  i:integer;
  NumCol: integer;
begin
  result:=true;
  if (Arow>=1) and (Arow<=RowCount) then MoveTo(Arow)
  else
  if (Arow=RowCount+1) then resultSet.MoveToInsertRow;

  if resultSet.RowDeleted then exit;

  for i:=0 to db.count-1 do
  begin
    NumCol:=NameList.indexof(db.fields[i]);
    if (NumCol>=0) and (db[i].Vtype=GVtype[NumCol]) then
    case Ztype[NumCol] of
      stBoolean:      resultSet.UpdateBoolean(NumCol+1,db[i].Vboolean);

      stByte:         resultSet.UpdateByte(NumCol+1,db[i].VInteger);
      stShort:        resultSet.UpdateShort(NumCol+1,db[i].VInteger);
      stInteger:      resultSet.UpdateInt(NumCol+1,db[i].VInteger);
      stLong:         resultSet.UpdateLong(NumCol+1,db[i].VInteger);

      stFloat:        resultSet.UpdateFloat(NumCol+1,db[i].Vfloat);
      stDouble:       resultSet.UpdateDouble(NumCol+1,db[i].Vfloat);
      stBigDecimal:   resultSet.UpdateBigDecimal(NumCol+1,db[i].Vfloat);

      stDate:         resultSet.UpdateDate(NumCol+1,db[i].VdateTime);
      stTime:         resultSet.UpdateTime(NumCol+1,db[i].VdateTime);
      stTimestamp:    resultSet.UpdateTimeStamp(NumCol+1,db[i].VdateTime);

      stString, stUnicodeString,stAsciiStream, stUnicodeStream:
                      resultSet.UpdateString(NumCol+1,db[i].Vstring);
    end;
  end;

  if (Arow>=1) and (Arow<=RowCount) then resultSet.UpdateRowGS(keys)
  else
  if (Arow=RowCount+1) then
  begin
    try
      resultSet.insertRow;
      inc(RowCount);
    except
      on E: Exception do
      begin
        messageCentral(E.Message);
        result:=false;
      end;
    end;
  end;

  invalidate;
end;




{*********************************************** Méthodes STM de TDBconnection ************************************}

procedure proTDBconnection_create(protocol,host:AnsiString;port:integer;base,user,password:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TDBconnection);
  with TDBconnection(pu) do
   ConnectDB(Protocol,Host, Port,base, User,Password);
end;

procedure proTDBconnection_commit(var pu:typeUO);
begin
  verifierobjet(pu);
  TDBconnection(pu).Connection.Commit
end;

procedure proTDBconnection_rollback(var pu:typeUO);
begin
  verifierobjet(pu);
  TDBconnection(pu).Connection.Rollback;
end;


procedure proTDBconnection_CreateStatement(var ss: TDBstatement;var pu:typeUO);
begin
  verifierobjet(pu);

  if not assigned(ss)
    then createPgObject('',typeUO(ss),TDBstatement)
    else ss.statement.Close;
  ss.statement:= TDBconnection(pu).Connection.CreateStatement;
end;

procedure proTDBconnection_PrepareStatement(SQL: AnsiString;var  ss:TDBPreparedStatement;var pu:typeUO);
begin
  verifierobjet(pu);
  if not assigned(ss)
    then createPgObject('',typeUO(ss),TDBpreparedStatement)
    else ss.statement.Close;
  ss.statement:= TDBconnection(pu).Connection.PrepareStatement(sql);
end;

procedure proTDBconnection_PrepareCall(SQL: AnsiString;var ss: TDBCallableStatement;var pu:typeUO);
begin
  verifierobjet(pu);
  if not assigned(ss)
    then createPgObject('',typeUO(ss),TDBCallableStatement)
    else ss.statement.Close;
  ss.statement:= TDBconnection(pu).Connection.PrepareCall(sql);
end;


procedure proTDBconnection_CreateStatementWithParams(var Info: TstmMemo;var ss:TDBstatement;var pu:typeUO);
begin
  verifierobjet(pu);
  if not assigned(ss)
    then createPgObject('',typeUO(ss),TDBStatement)
    else ss.statement.Close;
  ss.statement:= TDBconnection(pu).Connection.CreateStatementWithParams(info.stList);
end;

procedure proTDBconnection_PrepareStatementWithParams(SQL: AnsiString; var Info: TstmMemo;var ss:TDBPreparedStatement;var pu:typeUO);
begin
  verifierobjet(pu);
  if not assigned(ss)
    then createPgObject('',typeUO(ss),TDBPreparedStatement)
    else ss.statement.Close;
  ss.statement:= TDBconnection(pu).Connection.PrepareStatementWithParams(sql,info.stList);
end;

procedure proTDBconnection_PrepareCallWithParams(SQL: AnsiString; var Info: TstmMemo;var ss:TDBCallableStatement;var pu:typeUO);
begin
  verifierobjet(pu);
  if not assigned(ss)
    then createPgObject('',typeUO(ss),TDBCallableStatement)
    else ss.statement.Close;
  ss.statement:= TDBconnection(pu).Connection.PrepareCallWithParams(sql,info.stList);
end;


function fonctionTDBconnection_NativeSQL(SQL: AnsiString;var pu:typeUO):AnsiString;
begin
  verifierobjet(pu);
  result:=TDBconnection(pu).connection.NativeSQL(sql);
end;


procedure proTDBconnection_AutoCommit(x:Boolean;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBconnection(pu).connection.setAutocommit(x);
end;

function fonctionTDBconnection_AutoCommit(var pu:typeUO): Boolean;
begin
  verifierobjet(pu);
  result:=TDBconnection(pu).connection.getAutocommit;
end;

function fonctionTDBconnection_Metadata(var pu:typeUO): pointer;
begin
  verifierobjet(pu);
  result:=TDBconnection(pu);
  {renvoie l'objet TDBconnection, pas l'objet metadata}
end;

procedure proTDBconnection_IsReadOnly(x:Boolean;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBconnection(pu).Connection.SetReadOnly(x);
end;

function fonctionTDBconnection_IsReadOnly(var pu:typeUO): Boolean;
begin
  verifierobjet(pu);
  result:=TDBconnection(pu).connection.isReadOnly;
end;


procedure proTDBconnection_Catalog(x:AnsiString;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBconnection(pu).connection.SetCatalog(x);
end;

function fonctionTDBconnection_Catalog(var pu:typeUO): AnsiString;
begin
  verifierobjet(pu);
  result:=TDBconnection(pu).connection.GetCatalog;
end;


procedure proTDBconnection_TransactionIsolation(x:integer;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBconnection(pu).connection.SetTransactionIsolation(TZtransactIsolationLevel(x));
end;

function fonctionTDBconnection_TransactionIsolation(var pu:typeUO):integer;
begin
  verifierobjet(pu);
  result:=ord(TDBconnection(pu).connection.getTransactionIsolation);
end;


{*********************************************** Méthodes stm de TDBstatement ********************************}


procedure proTDBstatement_ExecuteQuery(SQL: AnsiString;var ss:TDBresultset;var pu:typeUO);
begin
  verifierobjet(pu);
  if not assigned(ss)
    then createPgObject('',typeUO(ss),TDBresultset)
    else ss.Close;

  try
  ss.ResultSet:=nil;
  ss.resultSet:= TDBstatement(pu).statement.ExecuteQuery(sql);
  ss.initParams;
  ss.invalidate;
  finally
  ss.IsOpen:=assigned(ss.resultSet);
  end;
end;

procedure proTDBstatement_ExecuteQuery_1(var SQL: TstmMemo;var ss:TDBresultset;var pu:typeUO);
begin
  verifierObjet(typeUO(sql));
  proTDBstatement_ExecuteQuery(SQL.stList.text, ss, pu);
end;

function fonctionTDBstatement_ExecuteUpdate(SQL: AnsiString;var pu:typeUO):Integer;
begin
  verifierobjet(pu);
  result:= TDBstatement(pu).statement.ExecuteUpdate(sql);
end;

function fonctionTDBstatement_ExecuteUpdate_1(var SQL:TstmMemo;var pu:typeUO):Integer;
begin
  verifierobjet(pu);
  result:= TDBstatement(pu).statement.ExecuteUpdate(sql.stList.Text);
end;

procedure proTDBstatement_Close(var pu:typeUO);
begin
  verifierobjet(pu);
  TDBstatement(pu).statement.close;
end;

procedure proTDBstatement_FetchDirection(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBstatement(pu).statement.setFetchDirection(TZFetchDirection(x));
end;

function fonctionTDBstatement_FetchDirection(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=ord(TDBstatement(pu).statement.getFetchDirection);
end;

procedure proTDBstatement_FetchSize(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBstatement(pu).statement.setFetchSize(x);
end;

function fonctionTDBstatement_FetchSize(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=ord(TDBstatement(pu).statement.GetFetchSize);
end;

procedure proTDBstatement_ResultSetConcurrency(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBstatement(pu).statement.setResultSetConcurrency(TZResultSetConcurrency(x));
end;

function fonctionTDBstatement_ResultSetConcurrency(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=ord(TDBstatement(pu).statement.GetResultSetConcurrency);
end;

procedure proTDBstatement_ResultSetType(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBstatement(pu).statement.setResultSetType(TZResultSetType(x));
end;

function fonctionTDBstatement_ResultSetType(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=ord(TDBstatement(pu).statement.GetResultSetType);
end;

procedure proTDBstatement_PostUpdates(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBstatement(pu).statement.setPostUpdates(TZPostUpdatesMode(x));
end;


function fonctionTDBstatement_PostUpdates(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=ord(TDBstatement(pu).statement.GetPostUpdates);
end;


procedure proTDBstatement_LocateUpdates(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBstatement(pu).statement.setLocateUpdates(TZLocateUpdatesMode(x));
end;

function fonctionTDBstatement_LocateUpdates(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=ord(TDBstatement(pu).statement.GetLocateUpdates);
end;


{*********************************************** TDBPreparedStatement ***************************************}



procedure proTDBPreparedStatement_ExecuteQueryPrepared(var ss: TDBresultset;var pu:typeUO);
begin
  verifierobjet(pu);
  if not assigned(ss)
    then createPgObject('',typeUO(ss),TDBresultset)
    else ss.resultSet.Close;

  try
  ss.resultSet:=nil;
  ss.resultSet:= TDBPreparedStatement(pu).statement.ExecuteQueryPrepared;
  finally
  ss.isOpen:=assigned(ss.resultSet);
  end;
end;

function fonctionTDBPreparedStatement_ExecuteUpdatePrepared(var pu:typeUO):Integer;
begin
  verifierobjet(pu);
  result:= TDBPreparedStatement(pu).statement.ExecuteUpdatePrepared;
end;

function fonctionTDBPreparedStatement_ExecutePrepared(var pu:typeUO):Boolean;
begin
  verifierobjet(pu);
  result:= TDBPreparedStatement(pu).statement.ExecutePrepared;
end;

procedure proTDBPreparedStatement_SetDefaultValue(ParameterIndex: Integer; Value: AnsiString;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBPreparedStatement(pu).statement.SetDefaultValue(parameterIndex,value);
end;

procedure proTDBPreparedStatement_SetNull(ParameterIndex: Integer; SQLType: integer;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBPreparedStatement(pu).statement.SetNull(parameterIndex,TZsqlType(sqlType));
end;

procedure proTDBPreparedStatement_SetBoolean(ParameterIndex: Integer; Value: Boolean;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBPreparedStatement(pu).statement.SetBoolean(parameterIndex,value);
end;

procedure proTDBPreparedStatement_SetShortInt(ParameterIndex: Integer; Value: ShortInt;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBPreparedStatement(pu).statement.SetByte(parameterIndex,value);
end;

procedure proTDBPreparedStatement_SetSmallint(ParameterIndex: Integer; Value: SmallInt;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBPreparedStatement(pu).statement.SetShort(parameterIndex,value);
end;

procedure proTDBPreparedStatement_SetInteger(ParameterIndex: Integer; Value: Integer;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBPreparedStatement(pu).statement.SetInt(parameterIndex,value);
end;

procedure proTDBPreparedStatement_SetSingle(ParameterIndex: Integer; Value: Single;var pu:typeUO);pascal;
begin
  verifierobjet(pu);
  TDBPreparedStatement(pu).statement.SetFloat(parameterIndex,value);
end;

procedure proTDBPreparedStatement_SetDouble(ParameterIndex: Integer; Value: Double;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBPreparedStatement(pu).statement.SetDouble(parameterIndex,value);
end;

procedure proTDBPreparedStatement_SetString(ParameterIndex: Integer; Value: AnsiString;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBPreparedStatement(pu).statement.SetString(parameterIndex,value);
end;

procedure proTDBPreparedStatement_SetElphyObject(ParameterIndex: Integer; var obj:typeUO;var pu:typeUO);
var
  f:TmemoryStream;
begin
  verifierobjet(pu);

  verifierobjet(obj);
  f:=TmemoryStream.create;
  try
    obj.saveToStream(f,true);
    TDBPreparedStatement(pu).statement.SetBinaryStream(ParameterIndex,f);
  finally
    f.free;
  end;
end;


procedure proTDBPreparedStatement_ClearParameters(var pu:typeUO);
begin
  verifierobjet(pu);
  TDBPreparedStatement(pu).statement.ClearParameters;
end;


{************************************************ Callable SQL statement ************************************}

procedure proTDBCallableStatement_RegisterOutParameter(ParameterIndex: Integer; SQLType: Integer;var pu:typeUO);
begin
  verifierobjet(pu);
  TDBCallableStatement(pu).statement.RegisterOutParameter(ParameterIndex,sqlType);
end;

function fonctionTDBCallableStatement_WasNull(var pu:typeUO):Boolean;
begin
  verifierobjet(pu);
  result:=TDBCallableStatement(pu).statement.wasNull;
end;


function fonctionTDBCallableStatement_IsNull(ParameterIndex: Integer;var pu:typeUO):Boolean;
begin
  verifierobjet(pu);
  result:=TDBCallableStatement(pu).statement.isNull(parameterIndex);
end;

function fonctionTDBCallableStatement_GetString(ParameterIndex: Integer;var pu:typeUO):AnsiString;
begin
  verifierobjet(pu);
  result:=TDBCallableStatement(pu).statement.getString(ParameterIndex);
end;

function fonctionTDBCallableStatement_GetBoolean(ParameterIndex: Integer;var pu:typeUO):Boolean;
begin
  verifierobjet(pu);
  result:=TDBCallableStatement(pu).statement.getBoolean(ParameterIndex);
end;

function fonctionTDBCallableStatement_GetShortint(ParameterIndex: Integer;var pu:typeUO):ShortInt;
begin
  verifierobjet(pu);
  result:=TDBCallableStatement(pu).statement.getByte(ParameterIndex);
end;

function fonctionTDBCallableStatement_GetSmallint(ParameterIndex: Integer;var pu:typeUO):SmallInt;
begin
  verifierobjet(pu);
  result:=TDBCallableStatement(pu).statement.getShort(ParameterIndex);
end;

function fonctionTDBCallableStatement_GetInteger(ParameterIndex: Integer;var pu:typeUO):Integer;
begin
  verifierobjet(pu);
  result:=TDBCallableStatement(pu).statement.getInt(ParameterIndex);
end;

function fonctionTDBCallableStatement_GetSingle(ParameterIndex: Integer;var pu:typeUO):Single;
begin
  verifierobjet(pu);
  result:=TDBCallableStatement(pu).statement.getFloat(ParameterIndex);
end;

function fonctionTDBCallableStatement_GetDouble(ParameterIndex: Integer;var pu:typeUO):Double;
begin
  verifierobjet(pu);
  result:=TDBCallableStatement(pu).statement.getDouble(ParameterIndex);
end;



{***************************************** Méthodes STM de TDBresultset ************************************}

procedure proTDBresultset_create(var pu:typeUO);
begin
  createPgObject('',pu,TDBresultset);
end;

function fonctionTDBresultset_Next(var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.Next;
end;

procedure proTDBresultset_Close(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).close;
end;

function fonctionTDBresultset_WasNull(var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.WasNull;
end;

function fonctionTDBresultset_IsNull(ColumnIndex: Integer;var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.isNull(ColumnIndex);
end;

function fonctionTDBresultset_GetString(ColumnIndex: Integer;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.getString(ColumnIndex);
end;

function fonctionTDBresultset_GetBoolean(ColumnIndex: Integer;var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.getBoolean(ColumnIndex);
end;

function fonctionTDBresultset_GetShortint(ColumnIndex: Integer;var pu:typeUO):ShortInt;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.getByte(ColumnIndex);
end;

function fonctionTDBresultset_GetSmallint(ColumnIndex: Integer;var pu:typeUO):SmallInt;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.getShort(ColumnIndex);
end;

function fonctionTDBresultset_GetInteger(ColumnIndex: Integer;var pu:typeUO):Integer;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.getInt(ColumnIndex);
end;

function fonctionTDBresultset_GetSingle(ColumnIndex: Integer;var pu:typeUO):Single;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.getFloat(ColumnIndex);
end;

function fonctionTDBresultset_GetDouble(ColumnIndex: Integer;var pu:typeUO):Double;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.getDouble(ColumnIndex);
end;

function fonctionTDBresultset_GetDateTime(ColumnIndex: Integer;var pu:typeUO):TDateTime;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.getTimeStamp(ColumnIndex);
end;

procedure proTDBresultset_GetElphyObject(ColumnIndex:integer;var obj:typeUO;var pu:typeUO);
var
  f:TStream;
  st1:AnsiString;
  size:cardinal;
begin
  verifierobjet(pu);
  verifierobjet(obj);
  f:=TDBresultset(pu).resultset.GetBinaryStream(ColumnIndex);
  try
    f.Position:=0;
    if not obj.loadX(f) then sortieErreur('TDBresultset.GetElphyObject : unable to loadObject') ;
  finally
    f.free;
  end;
end;

function fonctionTDBresultset_IsNull_1(ColumnName: AnsiString;var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.IsNullByName(ColumnName);
end;

function fonctionTDBresultset_GetString_1(ColumnName: AnsiString;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetStringByName(ColumnName);
end;

function fonctionTDBresultset_GetBoolean_1(ColumnName: AnsiString;var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetBooleanByName(ColumnName);
end;

function fonctionTDBresultset_GetShortint_1(ColumnName: AnsiString;var pu:typeUO):ShortInt;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetByteByName(ColumnName);
end;

function fonctionTDBresultset_GetSmallint_1(ColumnName: AnsiString;var pu:typeUO):SmallInt;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetShortByName(ColumnName);
end;

function fonctionTDBresultset_GetInteger_1(ColumnName: AnsiString;var pu:typeUO):Integer;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetIntByName(ColumnName);
end;

function fonctionTDBresultset_GetSingle_1(ColumnName: AnsiString;var pu:typeUO):Single;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetFloatByName(ColumnName);
end;

function fonctionTDBresultset_GetDouble_1(ColumnName: AnsiString;var pu:typeUO):Double;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetDoubleByName(ColumnName);
end;

function fonctionTDBresultset_GetDateTime_1(ColumnName: AnsiString;var pu:typeUO): TdateTime;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetTimeStampByName(ColumnName);
end;

procedure proTDBresultset_GetElphyObject_1(ColumnName:AnsiString;var obj:typeUO;var pu:typeUO);
var
  f:TStream;
  st1:AnsiString;
  size:cardinal;
begin
  verifierobjet(pu);
  verifierobjet(obj);
  f:=TDBresultset(pu).resultset.GetBinaryStreamByName(columnName);
  try
    f.Position:=0;
    if not obj.loadX(f) then sortieErreur('TDBresultset.GetElphyObject : unable to loadObject') ;
  finally
    f.free;
  end;
end;

function fonctionTDBresultset_Metadata(var pu:typeUO): pointer;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu);
  {renvoie l'objet TDBresultset}
end;


function fonctionTDBresultset_FindColumn(ColumnName: AnsiString;var pu:typeUO):Integer;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.FindColumn(columnName);
end;

function fonctionTDBresultset_IsBeforeFirst(var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.isBeforeFirst;
end;

function fonctionTDBresultset_IsAfterLast(var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.isAfterLast;
end;

function fonctionTDBresultset_IsFirst(var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.isFirst;
end;

function fonctionTDBresultset_IsLast(var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.isLast;
end;

procedure proTDBresultset_BeforeFirst(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.BeforeFirst;
end;

procedure proTDBresultset_AfterLast(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.AfterLast;
end;

function fonctionTDBresultset_First(var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.first;
end;

function fonctionTDBresultset_Last(var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.last;
end;

function fonctionTDBresultset_GetRow(var pu:typeUO):Integer;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.getRow;
end;

function fonctionTDBresultset_MoveAbsolute(Row: Integer;var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.MoveAbsolute(row);
end;

function fonctionTDBresultset_MoveRelative(Rows: Integer;var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.MoveRelative(rows);
end;

function fonctionTDBresultset_Previous(var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.Previous;
end;


function fonctionTDBresultset_RowUpdated(var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.RowUpdated;
end;

function fonctionTDBresultset_RowInserted(var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.RowInserted;
end;

function fonctionTDBresultset_RowDeleted(var pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.RowDeleted;
end;


procedure proTDBresultset_UpdateNull(ColumnIndex: Integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateNull(ColumnIndex);
end;

procedure proTDBresultset_UpdateBoolean(ColumnIndex: Integer; Value: Boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateBoolean(ColumnIndex,value);
end;

procedure proTDBresultset_UpdateShortInt(ColumnIndex: Integer; Value: ShortInt;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateByte(ColumnIndex,value);
end;

procedure proTDBresultset_UpdateSmallint(ColumnIndex: Integer; Value: SmallInt;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateShort(ColumnIndex,value);
end;

procedure proTDBresultset_UpdateInteger(ColumnIndex: Integer; Value: Integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateInt(ColumnIndex,value);
end;

procedure proTDBresultset_UpdateSingle(ColumnIndex: Integer; Value: Single;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateFloat(ColumnIndex,value);
end;

procedure proTDBresultset_UpdateDouble(ColumnIndex: Integer; Value: Double;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateDouble(ColumnIndex,value);
end;

procedure proTDBresultset_UpdateDateTime(ColumnIndex: Integer; Value: TdateTime;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateTimeStamp(ColumnIndex,value);
end;

procedure proTDBresultset_UpdateElphyObject(ColumnIndex: Integer; var obj:typeUO;var pu:typeUO);
var
  f:TmemoryStream;
begin
  verifierObjet(pu);
  verifierObjet(obj);

  f:=TmemoryStream.create;
  try
    obj.saveToStream(f,true);
    TDBresultSet(pu).resultSet.UpdateBinaryStream(ColumnIndex,f);
  finally
    f.free;
  end;
end;


procedure proTDBresultset_UpdateString(ColumnIndex: Integer; Value: AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateString(ColumnIndex,value);
end;

procedure proTDBresultset_UpdateNull_1(ColumnName: AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateNullByName(ColumnName);
end;

procedure proTDBresultset_UpdateBoolean_1(ColumnName: AnsiString; Value: Boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateBooleanByName(ColumnName,value);
end;

procedure proTDBresultset_UpdateShortint_1(ColumnName: AnsiString; Value: ShortInt;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateByteByName(ColumnName,value);
end;

procedure proTDBresultset_UpdateSmallint_1(ColumnName: AnsiString; Value: SmallInt;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateShortByName(ColumnName,value);
end;

procedure proTDBresultset_UpdateInteger_1(ColumnName: AnsiString; Value: Integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateIntByName(ColumnName,value);
end;

procedure proTDBresultset_UpdateSingle_1(ColumnName: AnsiString; Value: Single;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateFloatByName(ColumnName,value);
end;

procedure proTDBresultset_UpdateDouble_1(ColumnName: AnsiString; Value: Double;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateDoubleByName(ColumnName,value);
end;

procedure proTDBresultset_UpdateDateTime_1(ColumnName: AnsiString; Value: TdateTime;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateTimeStampByName(ColumnName,value);
end;

procedure proTDBresultset_UpdateString_1(ColumnName: AnsiString; Value: AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.UpdateStringByName(ColumnName,value);
end;

procedure proTDBresultset_UpdateElphyObject_1(ColumnName: AnsiString; var obj:typeUO;var pu:typeUO);
var
  f:TmemoryStream;
begin
  verifierObjet(pu);
  verifierObjet(obj);

  f:=TmemoryStream.create;
  try
    obj.saveToStream(f,true);
    TDBresultSet(pu).resultSet.UpdateBinaryStreamByName(ColumnName,f);
  finally
    f.free;
  end;
end;


procedure proTDBresultset_InsertRow(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.insertRow;
end;

procedure proTDBresultset_UpdateRow(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.updateRow;
end;

procedure proTDBresultset_DeleteRow(Arow:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).deleteRow(Arow);
end;

procedure proTDBresultset_RefreshRow(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.refreshRow;
end;

procedure proTDBresultset_CancelRowUpdates(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.CancelRowUpdates;
end;

procedure proTDBresultset_MoveToInsertRow(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.MoveToInsertRow;
end;

procedure proTDBresultset_MoveToCurrentRow(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).resultSet.MoveToCurrentRow;
end;

procedure proTDBresultset_show(var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).show(nil);
end;


procedure proTDBresultset_getDBrecord(var db:TDBrecord;num:integer; var pu:typeUO);
begin
  verifierObjet(typeUO(db));
  verifierObjet(pu);

  if (num<1) or (num>TDBresultSet(pu).rowCount)
    then sortieErreur('TDBresultset.getDBrecord : row number out of range');

  TDBresultSet(pu).initRowBuffer(db);
  TDBresultSet(pu).loadRowBuffer(num,db);
end;

procedure proTDBresultset_setDBrecord(var db:TDBrecord;num:integer; var pu:typeUO);
begin
  verifierObjet(typeUO(db));
  verifierObjet(pu);

  if (num<1) or (num>TDBresultSet(pu).rowCount)
    then sortieErreur('TDBresultset.getDBrecord : row number out of range');
  TDBresultSet(pu).saveDBrecord(num,db);
end;

procedure proTDBresultset_deleteDBrecord(num:integer; var pu:typeUO);
begin
  verifierObjet(pu);

  if (num<1) or (num>TDBresultSet(pu).rowCount)
    then sortieErreur('TDBresultset.deleteDBrecord : row number out of range');
  TDBresultSet(pu).DeleteRow(num);
end;

procedure proTDBresultset_insertDBrecord(var db:TDBrecord; var pu:typeUO);
var
  num:integer;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(db));

  num:=TDBresultSet(pu).rowCount+1;
  TDBresultSet(pu).saveDBrecord(num ,db);
end;

function fonctionTDBresultset_RowCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).rowCount;
end;


procedure proTDBresultset_keys(st:AnsiString; var pu:typeUO);
begin
  verifierObjet(pu);
  TDBresultSet(pu).keys:=st;
end;

function fonctionTDBresultset_keys(var pu:typeUO): AnsiString;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).keys;
end;


{******************************************* Méthodes stm de ResultSet metadata **********************}

{ TDBresultsetMetadata est toujours renvoyé par resultset.metatdata
 var pu:typeUO est remplacé par pu:typeUO
}

function fonctionTDBresultsetMetadata_GetColumnCount(pu:typeUO):Integer;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.GetColumnCount;
end;

function fonctionTDBresultsetMetadata_IsAutoIncrement(Column: Integer; pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.isAutoIncrement(column);
end;

function fonctionTDBresultsetMetadata_IsCaseSensitive(Column: Integer;pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.isCaseSensitive(column);
end;

function fonctionTDBresultsetMetadata_IsSearchable(Column: Integer;pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.isSearchable(column);
end;

function fonctionTDBresultsetMetadata_IsCurrency(Column: Integer;pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.isCurrency(column);
end;

function fonctionTDBresultsetMetadata_IsNullable(Column: Integer;pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=ord(TDBresultSet(pu).resultSet.GetMetadata.isNullable(column));
end;


function fonctionTDBresultsetMetadata_IsSigned(Column: Integer;pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.isSigned(column);
end;

function fonctionTDBresultsetMetadata_GetColumnDisplaySize(Column: Integer;pu:typeUO):Integer;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.GetColumnDisplaySize(column);
end;

function fonctionTDBresultsetMetadata_GetColumnLabel(Column: Integer;pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.GetColumnLabel(column);
end;

function fonctionTDBresultsetMetadata_GetColumnName(Column: Integer;pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.GetColumnName(column);
end;

function fonctionTDBresultsetMetadata_GetSchemaName(Column: Integer;pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.GetSchemaName(column);
end;

function fonctionTDBresultsetMetadata_GetPrecision(Column: Integer;pu:typeUO):Integer;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.GetPrecision(column);
end;

function fonctionTDBresultsetMetadata_GetScale(Column: Integer;pu:typeUO):Integer;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.GetScale(column);
end;

function fonctionTDBresultsetMetadata_GetTableName(Column: Integer;pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.GetTableName(column);
end;

function fonctionTDBresultsetMetadata_GetCatalogName(Column: Integer;pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.GetCatalogName(column);
end;

function fonctionTDBresultsetMetadata_GetColumnType(Column: Integer;pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=ord(TDBresultSet(pu).resultSet.GetMetadata.GetColumnType(column));
end;

function fonctionTDBresultsetMetadata_GetColumnTypeName(Column: Integer;pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.GetColumnTypeName(column);
end;

function fonctionTDBresultsetMetadata_IsReadOnly(Column: Integer;pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.isReadOnly(column);
end;

function fonctionTDBresultsetMetadata_IsWritable(Column: Integer;pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.isWritable(column);
end;

function fonctionTDBresultsetMetadata_IsDefinitelyWritable(Column: Integer;pu:typeUO):Boolean;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.isDefinitelyWritable(column);
end;

function fonctionTDBresultsetMetadata_GetDefaultValue(Column: Integer;pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TDBresultSet(pu).resultSet.GetMetadata.GetDefaultValue(column);
end;


procedure proDBgetSupportedProtocols(var memo:TstmMemo);
var
  I, J: Integer;
  Drivers: IZCollection;
  Protocols: TStringDynArray;
begin
  verifierObjet(typeUO(memo));

  memo.stList.Clear;
  Drivers := DriverManager.GetDrivers;
  for I := 0 to Drivers.Count - 1 do
  begin
    Protocols := (Drivers.Items[I] as IZDriver).GetSupportedProtocols;
    for J := 0 to High(Protocols) do
      memo.stList.add(Protocols[J]);
  end;
end;

{ Méthodes stm associées à TDBrecord }

procedure proTDBconnection_InsertDBrecord(tableName:AnsiString; var db:TdbRecord; var pu:typeUO);
begin
  verifierObjet(pu);
  with TDBconnection(pu) do
  insertDBrecord(tableName,db);
end;




end.
