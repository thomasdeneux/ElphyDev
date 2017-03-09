unit DBQuerySets;

interface
    uses
        Classes,
        sysUtils,
        DBObjects,
        DBModels,
        stmObj,
        stmPG,
        stmDataBase2,
        Ncdef2,
        DBRecord1,
        ZDbcIntfs;
    type
        TDBQuerySet = class(typeUO)
        protected
            _objects:TList;
            _last_sql_query:String;
            _resultset:IZResultSet;
            _model:TDBModel;
            _isEmpty:Boolean;
            function countObjects:Integer;
            function getObject(index:Integer):TDBObject;

            {procedure reconstructAnalyses;}
        public
            constructor Create;overload;
            constructor Create(model:TDBModel);overload;
            constructor Create(sql_query:String;model:TDBModel);overload;
            procedure initQuerySet;overload;
            procedure initQuerySet(model:TDBModel);overload;
            procedure finalizeQuerySet(sql_query:String);
            destructor Destroy;override;
            property count:Integer read countObjects;
            property objects[index:Integer]:TDBObject read getObject;default;
            property list:TList read _objects;
            property model:TDBModel read _model;
            property last_sql_query:String read _last_sql_query;
            property resultset:IZResultSet read _resultset;
            procedure remove(commit:Boolean=True);
            procedure clear;
            procedure assign(qset:TDBQuerySet);
            class function stmClassName:string;override;
            procedure processMessage(id:integer;source:typeUO;p:pointer);override;
        end;

procedure proTDBQuerySet_Create(var pu:typeUO);pascal;
procedure proTDBQuerySet_remove(var pu:typeUO);pascal;
procedure proTDBQuerySet_getObject(index:Integer;var dbobject:TDBObject;var pu:typeUO);pascal;
procedure proTDBQuerySet_clear(var pu:typeUO);pascal;
function fonctionTDBQuerySet_countObjects(var pu:typeUO):Integer;pascal;
procedure proTDBQuerySet_getResultSet(var resultset:TDBResultSet;var pu:typeUO);pascal;
{function fonctionTDBQuerySet_getModel(var pu:typeUO):TDBModel;pascal;}

implementation
    constructor TDBQuerySet.Create;
        begin
            inherited Create;
            initQuerySet;
        end;

    constructor TDBQuerySet.Create(model:TDBModel);
        begin
            notPublished := True;
            inherited Create;
            initQuerySet;
            derefObjet(typeUO(_model));
            _model := model;
            refObjet(typeUO(_model));
        end;

    constructor TDBQuerySet.Create(sql_query:String;model:TDBModel);
        begin
            inherited Create;
            initQuerySet;
            derefObjet(typeUO(_model));
            _model := model;
            refObjet(typeUO(_model));
            finalizeQuerySet(sql_query);
        end;

    procedure TDBQuerySet.processMessage(id:integer;source:typeUO;p:pointer);
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

    procedure TDBQuerySet.initQuerySet;
        begin
            if not assigned(_objects) then _objects := TList.Create else clear;
            _last_sql_query := '';
        end;

    procedure TDBQuerySet.initQuerySet(model:TDBModel);
        begin
            derefObjet(typeUO(_model));
            _model := model;
            refObjet(typeUO(_model));
            if not assigned(_objects) then _objects := TList.Create else clear;
            _last_sql_query := '';
        end;

    procedure TDBQuerySet.finalizeQuerySet(sql_query:String);
        var
            statement:IZStatement;
            i:Integer;

        begin
            if _model = nil then raise Exception.Create('model undefined');
            _last_sql_query := sql_query;
            statement := _model.connection.CreateStatement;
            _resultset := statement.ExecuteQuery(sql_query);
            while _resultset.Next do _objects.Add(TDBObject.Create(_model,_resultset));
            if count > 0 then _isEmpty := False else _isEmpty := True;
            _resultset.BeforeFirst;
        end;

    procedure TDBquerySet.assign(qset:TDBQuerySet);
        var
            i:Integer;

        begin
            if qset._model = nil then raise Exception.Create('model undefined');
            _objects.Clear;
            _objects.assign(qset._objects);
            _last_sql_query := qset._last_sql_query;
            _model := qset._model;
            _resultset := qset._resultset;
            _isEmpty := qset._isEmpty;
        end;

    function TDBQuerySet.getObject(index:Integer):TDBObject;
        begin
            Result := _objects[index];
        end;

    function TDBQuerySet.countObjects:Integer;
        begin
            Result := _objects.Count;
        end;

    destructor TDBQuerySet.Destroy;
        begin
            clear;
            _objects.free;
            derefObjet(typeUO(_model));
            inherited Destroy;
        end;

    procedure TDBQuerySet.clear;
        var
            obj:typeUO;
            i:Integer;

        begin
            for i:=1 to _objects.count do
                begin
                    obj := typeUO(_objects[i-1]);
                    obj.free;
                    _objects[i-1]:=nil;
                end;
            _objects.pack;
            _objects.Capacity := 0;
        end;

    procedure TDBQuerySet.remove(commit:Boolean=True);
        var
            i:Integer;
            obj:TDBObject;

        begin
            for i:=1 to _objects.count do
                begin
                    obj := _objects[i-1];
                    obj.remove(commit);
                    obj.Free;
                    _objects[i-1]:=nil;
                end;
            _objects.pack;
            _objects.Capacity := 0;
        end;

    class function TDBQuerySet.stmClassName:string;
        begin
            result:='DBQuerySet';
        end;

    procedure proTDBQuerySet_Create(var pu:typeUO);pascal;
        begin
            createPgObject('',pu,TDBQuerySet);
            TDBQuerySet(pu).initQuerySet;
        end;

    procedure proTDBQuerySet_remove(var pu:typeUO);pascal;
        begin
            verifierObjet(pu);
            TDBQuerySet(pu).remove;
        end;

    procedure proTDBQuerySet_getObject(index:Integer;var dbobject:TDBObject;var pu:typeUO);pascal;
        begin
            verifierObjet(pu);
            if not assigned(dbobject) then
                createPgObject('',typeUO(dbobject),TDBObject);
            dbobject.assign(TDBQuerySet(pu).objects[index]);
        end;

    procedure proTDBQuerySet_getResultSet(var resultset:TDBResultSet;var pu:typeUO);pascal;
        begin
            verifierobjet(pu);
            if not assigned(resultset) then
                createPgObject('',typeUO(resultset),TDBresultset)
            else resultset.resultSet.Close;
            if TDBQuerySet(pu).count > 0 then
                begin
                    try
                        resultset.ResultSet:=nil;
                        resultset.resultSet:=TDBQuerySet(pu)._resultset;
                        resultset.initParams;
                        resultset.invalidate
                    finally
                        resultset.IsOpen:=assigned(resultset.resultSet);
                    end;
                end
            else resultset.free;
        end;

    procedure proTDBQuerySet_clear(var pu:typeUO);pascal;
        begin
            verifierObjet(pu);
            TDBQuerySet(pu).clear;
        end;

    function fonctionTDBQuerySet_countObjects(var pu:typeUO):Integer;pascal;
        begin
            verifierObjet(pu);
            Result := TDBQuerySet(pu).count;
        end;
    {
    function fonctionTDBQuerySet_getModel(var pu:typeUO):TDBModel;pascal;
        begin
            verifierObjet(pu);
            Result := TDBQuerySet(pu).model;
        end;
    }
initialization
    registerObject(TDBQuerySet,sys);
end.
