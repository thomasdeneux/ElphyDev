unit DBObjects;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
    uses
        SysUtils,
        DateUtils,
        Classes,
        ZDbcIntfs,
        stmDataBase2,
        stmObj,
        stmPg,
        Ncdef2,
        DBRecord1,
        DBModels,
        util1, debug0;
        
    type
        TDBObject = class(TDBrecord)
        protected
            _model:TDBModel;
            _created,_existing:Boolean;
            _where:AnsiString;
            function getPk:AnsiString;
            function default_where:AnsiString;
            function find:IZResultSet;
            procedure update;
            procedure insert;
            {procedure remove_analysis(commit:Boolean);}


        public
            constructor Create(model:TDBModel;resultset:IZResultSet);overload;
            constructor Create(model:TDBModel);overload;
            constructor Create;overload;
            destructor Destroy;override;
            procedure initObject;
            procedure finalizeObject(model:TDBModel;resultset:IZResultSet);
            procedure loadData(resultset:IZResultSet);
            procedure assign(dbobject:TDBObject);overload;
            property created:Boolean read _created write _created;
            property existing:Boolean read _existing write _existing;
            property model:TDBModel read _model;
            property pk:AnsiString read getPk;
            procedure remove(commit:Boolean=True);
            procedure save(commit:Boolean=True);
            class function stmClassName:AnsiString;override;
            procedure processMessage(id:integer;source:typeUO;p:pointer);override;
        end;

procedure proTDBObject_create(var pu:typeUO);pascal;
procedure proTDBObject_save(commit:Boolean;var pu:typeUO);pascal;
procedure proTDBObject_remove(commit:Boolean;var pu:typeUO);pascal;
{function fonctionTDBObject_getModel(var pu:typeUO):TDBModel;pascal;}
{fonctions héritées}
procedure proTDBObject_ImplicitValue(st:AnsiString;var x:TGvariant;var pu:typeUO);pascal;
function fonctionTDBObject_ImplicitValue(st:AnsiString;var pu:typeUO):TGvariant;pascal;
procedure proTDBObject_AddField(st:AnsiString;tp:integer;var pu:typeUO);pascal;
procedure proTDBObject_DeleteField(st:AnsiString;var pu:typeUO);pascal;
procedure proTDBObject_clear(var pu:typeUO);pascal;
function fonctionTDBObject_FieldExists(st:AnsiString;var pu:typeUO):boolean;pascal;
function fonctionTDBObject_count(var pu:typeUO):integer;pascal;
function fonctionTDBObject_Vtype(n:integer;var pu:typeUO):integer;pascal;
function fonctionTDBObject_Names(n:integer;var pu:typeUO):AnsiString;pascal;
function fonctionTDBObject_ValString(n:integer;var pu:typeUO):AnsiString;pascal;

implementation
    uses
        DBQueryBuilder;

    constructor TDBObject.Create;
        begin
            notPublished := True;
            inherited Create;
            initObject;
        end;

    constructor TDBObject.Create(model:TDBModel);
        begin
            notPublished := True;
            inherited Create;
            initObject;
            derefObjet(typeUO(_model));
            _model := model;
            refObjet(typeUO(_model));
        end;

    constructor TDBObject.Create(model:TDBModel;resultset:IZResultSet);
        begin
            notPublished := True;
            inherited Create;
            initObject;
            finalizeObject(model,resultset);
        end;

    procedure TDBObject.processMessage(id:integer;source:typeUO;p:pointer);
        begin
            inherited processMessage(id,source,p);
            case id of
                UOmsg_destroy :
                    begin
                        _model := nil;
                        derefObjet(source);
                    end;
            end;
        end;

    destructor TDBObject.Destroy;
        begin
            derefObjet(typeUO(_model));
            inherited Destroy;
        end;

    procedure TDBObject.initObject;
        begin
            _created := False;
            _existing := False;
            _where := '';
        end;

    procedure TDBObject.finalizeObject(model:TDBModel;resultset:IZResultSet);
        begin
            derefObjet(typeUO(_model));
            _model := model;
            refObjet(typeUO(_model));
            loadData(resultset);
        end;

    procedure TDBObject.loadData(resultset:IZResultSet);
        var
            i:integer;
            Ztype:TZSQLtype;
            field,value:AnsiString;
            isnull:Boolean;

        begin
            for i:=1 to _model.fields.count do
                begin
                    field := _model.fields[i-1];
                    AddField(field,gvNull);
                    isnull := resultset.IsNull(i);
                    if not isnull then
                        begin
                            Ztype:=resultSet.GetMetadata.GetColumnType(i);
                            case Ztype of
                                stTimestamp: VDateTime[i-1]:=resultset.GetTimestamp(i);
                                stBoolean: VBoolean[i-1]:=resultset.GetBoolean(i);
                                stByte: VInteger[i-1]:=resultSet.GetByte(i);
                                stShort: VInteger[i-1]:=resultSet.GetShort(i);
                                stInteger: VInteger[i-1]:=resultSet.GetInt(i);
                                stLong: VInteger[i-1]:=resultSet.GetLong(i);
                                stFloat: Vfloat[i-1]:=resultSet.GetFloat(i);
                                stDouble: Vfloat[i-1]:=resultSet.GetDouble(i);
                                stBigDecimal: Vfloat[i-1]:=resultSet.GetBigDecimal(i);
                                stString:Vstring[i-1]:=resultSet.GetString(i);
                                stUnicodeString:Vstring[i-1]:=resultSet.GetStringByName(field);
                                stAsciiStream:Vstring[i-1]:=resultSet.GetStringByName(field);
                                stUnicodeStream:Vstring[i-1]:=resultSet.GetStringByName(field);
                        end;
                    end;
                end;
            _existing := True;
        end;

    procedure TDBObject.assign(dbobject:TDBObject);
        begin
            if dbobject._model = nil then raise Exception.Create('model undefined');
            assign(TDBRecord(dbobject));
            _created := dbobject._created;
            _existing := dbobject._existing;
            _where := dbobject._where;
            _model := dbobject._model;
        end;

    function TDBObject.getPk:AnsiString;
        begin

        end;

    function TDBObject.default_where:AnsiString;
        var
            separator,field:AnsiString;
            test:Boolean;
            i:Integer;

        begin
            for i:=1 to _model.pkeys.Count do
                begin
                     if _where <> '' then separator := ' AND ' else separator := '';
                     field := _model.pkeys[i-1];
                     _where := _where + separator + field + ' = ';
                     test := (Self.getValue(field).rec.VType = gvString) or (Self.getValue(field).rec.VType = gvDateTime);
                     if test then _where := _where + '''' + Self.getValue(field).getValString + ''''
                     else _where := _where + Self.getValue(field).getValString;
                end;
        end;

    function TDBObject.find:IZResultSet;
        var
            statement:IZStatement;
            query:AnsiString;
            builder:TQueryBuilder;

        begin
            statement := _model.connection.CreateStatement;
            builder := TQueryBuilder.Create(_model,True);
            default_where;
            builder.where := _where;
            query := builder.select;
            Result := statement.ExecuteQuery(query);
            builder.Free;
        end;

    procedure TDBObject.update;
        var
            statement:IZStatement;
            resultset:IZResultSet;
            query:AnsiString;
            builder:TQueryBuilder;
            values:TStringList;
            tmp_object:TDBObject;

        begin
            statement := _model.connection.CreateStatement;
            builder := TQueryBuilder.Create(_model,True);
            builder.where := _where;
            query := builder.update(Self);
            resultset := statement.ExecuteQuery(query);
            if resultset.First then
                begin
                    tmp_object := TDBObject.Create(_model,resultset);
                    _created := False;
                    _existing := True;
                    assign(TDBRecord(tmp_object));
                    tmp_object.Free;
                end
            else
                raise Exception.Create('problem during object update,object has not been found');
            builder.Free;
        end;

    procedure TDBObject.insert;
        var
            statement:IZStatement;
            resultset:IZResultSet;
            query:AnsiString;
            builder:TQueryBuilder;
            values:TStringList;
            tmp_object:TDBObject;

        begin
            statement := _model.connection.CreateStatement;
            builder := TQueryBuilder.Create(_model,True);
            query := builder.insert(Self);
            resultset := statement.ExecuteQuery(query);
            if resultset.First then
                begin
                    tmp_object := TDBObject.Create(_model,resultset);
                    _created := True;
                    _existing := True;
                    assign(TDBRecord(tmp_object));
                    tmp_object.Free;
                end
            else
                raise Exception.Create('problem during object insertion,object has not been found');
            builder.Free;
        end;

    procedure TDBObject.save(commit:Boolean=True);
        var
            resultset:IZResultSet;
            test:AnsiString;

        begin
            if _model = nil then raise Exception.Create('model undefined');

            try
                test := _model.application_table;
            except
                raise Exception.Create('impossible to update an object that has not been created with a manager');
            end;
            {
            if (_model.application_table = 'analysis_analysis') and (self._model.fields.IndexOf('analysis_type') < 0) then
                raise Exception.Create('not implemented case, impossible to update an analysis');
            }
            if (_model.application_table = 'analysis_analysis') and (count > 3) then raise Exception.Create('only component and comments fields could be changed when updating an analysis');
            resultset := find;
            if (not resultset.First) and (_model.application_table = 'analysis_analysis') then raise Exception.Create('only component and comments fields could be changed when updating an analysis');
            if resultset.First then update else insert;
            if commit then _model.connection.commit;
        end;

    procedure TDBObject.remove(commit:Boolean=True);
        var
            statement:IZStatement;
            query,where,separator,field:AnsiString;
            builder:TQueryBuilder;
            test:AnsiString;

        begin
            if _model = nil then raise Exception.Create('model undefined');
            try
                test := _model.application_table;
            except
                raise Exception.Create('impossible to update an object that has not been created with a manager');
            end;
            {
            if (_model.application_table = 'analysis_analysis') and (self._model.fields.IndexOf('analysis_type') < 0) then
                raise Exception.Create('not implemented case, impossible to remove an analysis, please use function removeAnalysis instead');
            }
            if not _existing then raise Exception.Create('object not in database');
            statement := _model.connection.CreateStatement;
            builder := TQueryBuilder.Create(_model);
            default_where;
            builder.where := _where;
            query := builder.del;
            statement.ExecuteQuery(query);
            if commit then
                begin
                    _existing := False;
                    _created := False;
                    _model.connection.commit;
                end;
            builder.Free;
        end;

    class function TDBObject.stmClassName:AnsiString;
        begin
            result:='DBObject';
        end;

    {
    procedure TDBObject.setFields(const fields:array of const);
        var
            i:Integer;

        begin
            SetLength(_fields, Length(fields));
            for i := 1 to  Length(fields) do
                    with fields[i-1] do
                        if (VType = vtString) or (VType = vtAnsiString) or (VType = vtChar) then _fields[i-1] := fields[i-1]
                        else raise WrongFormatException.Create('please give a list of AnsiString, AnsiString or Char');
        end;
    }

    procedure proTDBObject_create(var pu:typeUO);pascal;
        begin
             createPgObject('',pu,TDBObject);
             TDBObject(pu).initObject;
        end;

    procedure proTDBObject_save(commit:Boolean;var pu:typeUO);pascal;
        begin
            verifierObjet(pu);
            TDBObject(pu).save(commit);
        end;

    procedure proTDBObject_remove(commit:Boolean;var pu:typeUO);pascal;
        begin
            verifierObjet(pu);
            TDBObject(pu).remove(commit);
        end;

    procedure proTDBObject_ImplicitValue(st:AnsiString;var x:TGvariant;var pu:typeUO);
        begin
            verifierObjet(pu);
            TDBObject(pu).setvalue(st,x);
            if TDBObject(pu).Ferror then sortieErreur('TDBObject.ImplicitValue : field does not exist');
        end;

    function fonctionTDBObject_ImplicitValue(st:AnsiString;var pu:typeUO):TGvariant;
        begin
            verifierObjet(pu);
            result:=TDBObject(pu).value[st];
            if TDBObject(pu).Ferror then sortieErreur('TDBObject.ImplicitValue : field does not exist');
        end;

    procedure proTDBObject_AddField(st:AnsiString;tp:integer;var pu:typeUO);
        begin
            verifierObjet(pu);
            if (tp<intG(low(TGvariantType))) or (tp>intG(high(TGvariantType)))
            then sortieErreur('TDBrecord.AddField : invalid type');
            TDBObject(pu).AddField(st,TGvariantType(tp));
            if TDBObject(pu).Ferror then sortieErreur('TDBrecord.AddField : field already exists');
        end;

    procedure proTDBObject_DeleteField(st:AnsiString;var pu:typeUO);
        begin
            verifierObjet(pu);
            TDBObject(pu).DeleteField(st);
            if TDBObject(pu).Ferror then sortieErreur('TDBObject.DeleteField : field does not exist');
        end;

    procedure proTDBObject_clear(var pu:typeUO);
        begin
            verifierObjet(pu);
            TDBObject(pu).clearFields;
        end;

    function fonctionTDBObject_FieldExists(st:AnsiString;var pu:typeUO):boolean;
        begin
            verifierObjet(pu);
            with TDBObject(pu) do
            result:= Fields.IndexOf(st)>=0;
        end;

    function fonctionTDBObject_count(var pu:typeUO):integer;
        begin
            verifierObjet(pu);
            with TDBObject(pu) do
            result:= Fields.count;
        end;

    function fonctionTDBObject_Vtype(n:integer;var pu:typeUO):integer;
        begin
            verifierObjet(pu);
            with TDBObject(pu) do
            if (n>=1) and (n<=fields.count)
            then result:= ord(value1[n-1].Vtype)
            else sortieErreur('TDBObject.Vtype : index out of range');
    end;

    function fonctionTDBObject_Names(n:integer;var pu:typeUO):AnsiString;
        begin
            verifierObjet(pu);
            with TDBObject(pu) do
            if (n>=1) and (n<=fields.count)
            then result:= Fields[n-1]
            else sortieErreur('TDBObject.Names : index out of range');
        end;

    function fonctionTDBObject_ValString(n:integer;var pu:typeUO):AnsiString;
        begin
            verifierObjet(pu);
            with TDBObject(pu) do
            if (n>=1) and (n<=fields.count)
            then result:= value1[n-1].getValString
            else sortieErreur('TDBObject.ValString : index out of range');
        end;

    {
    function fonctionTDBObject_getModel(var pu:typeUO):TDBModel;pascal;
        begin
            verifierObjet(pu);
            Result := TDBObject(pu).model;
        end;
    }

Initialization
AffDebug('Initialization DBObjects',0);
    registerObject(TDBObject,sys);
end.
