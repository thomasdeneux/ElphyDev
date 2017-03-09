unit DBModels;

interface
    uses
        util1,
        stmObj,
        stmPG,
        stmDataBase2,
        stmMemo1,
        Ncdef2,
        SysUtils,
        Classes,
        ZDbcIntfs;


    type
        TArrayString = array of String;
        TDBModel = class(typeUO)
        private
            _table,_application,_application_table:String;
            _fields,_field_types,_field_constraints,_pkeys,_fkeys,_field_lookups,_field_foreign_fields,_field_is_serial:TStringList;
            _n_fields,_n_pkeys,_n_fkeys:Integer;
            _connection:IZconnection;

        public
            constructor Create;overload;
            constructor Create(table:String;application:String='';view_on:String='');overload;
            destructor Destroy;override;
            procedure initModel(table:String;application:String='';view_on:String='');
            function has_key(key:String):Boolean;
            function is_pkey(key:String):Boolean;
            function is_fkey(key:String):Boolean;
            function getPk:String;
            function getFk:String;
            property pkeys:TStringList read _pkeys;
            property fkeys:TStringList read _fkeys;
            property nfields:Integer read _n_fields;
            property npkeys:Integer read _n_pkeys;
            property nfkeys:Integer read _n_fkeys;
            property table:String read _table;
            property application:String read _application;
            property application_table:String read _application_table;
            property fields:TStringList read _fields;
            property types:TStringList read _field_types;
            property constraints:TStringList read _field_constraints;
            property lookups:TStringList read _field_lookups;
            property references:TStringList read _field_foreign_fields;
            property connection:IZConnection read _connection;
            class function stmClassName:string;override;
        end;

procedure proTDBModel_Create(table:String;var pu:typeUO);pascal;
function fonctionTDBModel_hasKey(key:String;var pu:typeUO):Boolean;pascal;
function fonctionTDBModel_isPKey(key:String;var pu:typeUO):Boolean;pascal;
function fonctionTDBModel_isFKey(key:String;var pu:typeUO):Boolean;pascal;
function fonctionTDBModel_nPKeys(var pu:typeUO):Integer;pascal;
function fonctionTDBModel_nFKeys(var pu:typeUO):Integer;pascal;
function fonctionTDBModel_getTable(var pu:typeUO):String;pascal;
function fonctionTDBModel_getConstraint(key:String;var pu:typeUO):String;pascal;
function fonctionTDBModel_getType(key:String;var pu:typeUO):String;pascal;
procedure proTDBModel_getFields(var memo:TstmMemo;var pu:typeUO);pascal;
procedure proTDBModel_getPKeys(var memo:TstmMemo;var pu:typeUO);pascal;
procedure proTDBModel_getFKeys(var memo:TstmMemo;var pu:typeUO);pascal;
procedure proTDBModel_getLookup(key:String;var memo:TstmMemo;var pu:typeUO);pascal;


implementation
    uses
        DBCache;
    constructor TDBModel.Create;
        begin
            notPublished := True;
            inherited Create;
        end;

    constructor TDBModel.Create(table:String;application:String='';view_on:String='');
        begin
            notPublished := True;
            inherited Create;
            initModel(table,application,view_on);
        end;

    procedure TDBModel.initModel(table:String;application:String='';view_on:String='');
        var
            statement,statement_constraint:IZStatement;
            resultset,resultset_constraint,resultset_constraints,resultset_constraint_unique,resultset_constraint_usage:IZResultSet;
            default,query,constraint,constraint_type,foreign_constraint,foreign_table,foreign_field,fd,tp:String;
            model_exists:Boolean;
            n,index:Integer;

        begin
            model_exists := False;
            _connection := DBCONNECTION.connection;
            if not assigned(_fields) then _fields := TStringList.Create else _fields.Clear;
            if not assigned(_field_types) then _field_types := TStringList.Create else _field_types.Clear;
            if not assigned(_field_constraints) then _field_constraints := TStringList.Create else _field_constraints.Clear;
            if not assigned(_pkeys) then _pkeys := TStringList.Create else _pkeys.Clear;
            if not assigned(_field_lookups) then _field_lookups := TStringList.Create else _field_lookups.Clear;
            if not assigned(_field_foreign_fields) then _field_foreign_fields := TStringList.Create else _field_foreign_fields.Clear;
            if not assigned(_fkeys) then _fkeys := TStringList.Create else _fkeys.Clear;
            if not assigned(_field_is_serial) then _field_is_serial := TStringList.Create else _field_is_serial.Clear;
            _table := table;
            _application := application;
            if _application <> '' then _application_table := _application + '_' + table else _application_table := table;
            statement := _connection.createStatement;
            query := 'SELECT %s,%s,%s,%s,%s FROM %s WHERE table_name = ''%s'' ORDER BY %s';
            query := Format(query, ['table_name', 'column_name', 'data_type', 'udt_name','column_default', 'information_schema.columns', _application_table, 'ordinal_position']);
            resultset := statement.ExecuteQuery(query);
            while resultset.Next do
                begin
                    default := resultset.getStringByName('column_default');
                    fd := resultset.getStringByName('column_name');
                    _fields.Add(fd);
                    if Pos('nextval',default) > 0 then _field_is_serial.Values[fd] := 'True' else _field_is_serial.Values[fd] := 'False';
                    tp := resultset.getStringByName('udt_name');
                    _field_types.Values[fd] := tp;
                    statement_constraint := _connection.CreateStatement;
                    query := 'SELECT constraint_name FROM information_schema.key_column_usage WHERE table_name = ''%s'' AND column_name = ''%s''';
                    query := Format(query, [_application_table, fd]);
                    resultset_constraint := statement_constraint.ExecuteQuery(query);
                    _field_constraints.Values[fd] := 'None';
                    _field_lookups.Values[fd] := 'None';
                    _field_foreign_fields.Values[fd] := 'None';
                    while resultset_constraint.Next do
                        begin
                            constraint := resultset_constraint.getStringByName('constraint_name');
                            query := 'SELECT constraint_type FROM information_schema.table_constraints WHERE table_name = ''%s'' AND constraint_name = ''%s''';
                            query := Format(query, [_application_table, constraint]);
                            resultset_constraints := statement_constraint.ExecuteQuery(query);
                            resultset_constraints.First;
                            constraint_type := resultset_constraints.getStringByName('constraint_type');
                            _field_constraints.Values[fd] := constraint_type;
                            if constraint_type = 'FOREIGN KEY' then
                                begin
                                    _fkeys.Add(fd);
                                    query := 'SELECT unique_constraint_name FROM information_schema.referential_constraints WHERE constraint_name = ''%s''';
                                    query := Format(query, [constraint]);
                                    resultset_constraint_unique := statement_constraint.ExecuteQuery(query);
                                    resultset_constraint_unique.First;
                                    foreign_constraint := resultset_constraint_unique.getStringByName('unique_constraint_name');
                                    query := 'SELECT table_name,column_name FROM information_schema.key_column_usage WHERE constraint_name = ''%s''';
                                    query := Format(query,[foreign_constraint]);
                                    resultset_constraint_usage := statement_constraint.ExecuteQuery(query);
                                    resultset_constraint_usage.First;
                                    foreign_table := resultset_constraint_usage.getStringByName('table_name');
                                    foreign_field := resultset_constraint_usage.getStringByName('column_name');
                                    _field_lookups.Values[fd] := foreign_table;
                                    _field_foreign_fields.Values[fd] := foreign_field;
                                end
                            else
                                begin
                                    {
                                    _field_lookups.Values[fd] := 'None';
                                    _field_foreign_fields.Values[fd] := 'None';
                                    }
                                    if constraint_type = 'PRIMARY KEY' then _pkeys.Add(fd);
                                end;
                        end;

                    {
                    if resultset_constraint.First then
                       begin


                        end
                    else
                        begin

                        end;
                }
                end;
            {make a fake model for analysis to interact with analyses as a classic table}
            if (_application_table = 'analysis_analysis') and (view_on <> '') then
                begin
                    {index := _fields.IndexOf('component');
                    _fields[index] := 'analysis_type';}
                    resultset := statement.ExecuteQuery('SELECT * FROM analysis_pin WHERE component =''' + view_on + '''');
                    while resultset.Next do _fields.Add(resultset.GetStringByName('name'));
                end;
            _n_fields := _fields.Count;
            _n_pkeys := _pkeys.Count;
            _n_fkeys := _fkeys.Count;
            if _n_fields < 1 then
                raise Exception.Create('table ' + _application_table + ' does not exist');
        end;

    function TDBModel.has_key(key:String):Boolean;
        begin
            if _fields.IndexOf(key) > 0 then Result := True else Result := False;
        end;

    function TDBModel.is_pkey(key:String):Boolean;
        begin
            if has_key(key) then
                if _field_constraints.Values[key] = 'PRIMARY KEY' then Result := True else Result := False
            else
                Result := False;
        end;

    function TDBModel.is_fkey(key:String):Boolean;
        begin
            if has_key(key) then
                if _field_constraints.Values[key] = 'FOREIGN KEY' then Result := True else Result := False
            else
                Result := False;
        end;

    function TDBModel.getPk:String;
        var
            i:integer;
            st,separator:String;

        begin
            st := '';
            for i:=1 to _fields.Count do
                begin
                    if st <> '' then separator := '__' else separator := '';
                    if is_pkey(_fields[i-1]) then st := st + separator + _fields[i-1];
                end;
            Result := st;
        end;

    function TDBModel.getFk:String;
        var
            i:integer;
            st,separator,field:String;

        begin
            st := '';
            for i := 1 to _fields.Count do
                begin
                    if st <> '' then separator := '_' else separator := '';
                    if is_fkey(_fields[i-1]) then
                        begin
                            field := _fields[i-1];
                            st := st + separator + _field_lookups.Values[field] + '____' + _field_foreign_fields.Values[field];
                        end;
                end;
            Result := st;
        end;

    destructor TDBModel.Destroy;
        begin
            _fields.Free;
            _field_types.Free;
            _field_constraints.Free;
            _field_lookups.Free;
            _field_foreign_fields.Free;
            _field_is_serial.Free;
            _pkeys.Free;
            _fkeys.Free;
            messageToRef(UOmsg_destroy,nil);
            inherited Destroy;
        end;

    class function TDBModel.stmClassName:string;
        begin
            result:='DBModel';
        end;

    procedure proTDBModel_Create(table:String;var pu:typeUO);pascal;
        begin
             createPgObject('',pu,TDBModel);
             TDBModel(pu).initModel(table);
        end;

    function fonctionTDBModel_hasKey(key:String;var pu:typeUO):Boolean;pascal;
        begin
            verifierObjet(pu);
            Result := TDBModel(pu).has_key(key);
        end;

    function fonctionTDBModel_isPKey(key:String;var pu:typeUO):Boolean;pascal;
        begin
            verifierObjet(pu);
            Result := TDBModel(pu).is_pkey(key);
        end;

    function fonctionTDBModel_isFKey(key:String;var pu:typeUO):Boolean;pascal;
        begin
            verifierObjet(pu);
            Result := TDBModel(pu).is_fkey(key);
        end;

    function fonctionTDBModel_nFields(var pu:typeUO):Integer;pascal;
        begin
            verifierObjet(pu);
            Result := TDBModel(pu).nfields;
        end;

    function fonctionTDBModel_nPKeys(var pu:typeUO):Integer;pascal;
        begin
            verifierObjet(pu);
            Result := TDBModel(pu).npkeys;
        end;

    function fonctionTDBModel_nFKeys(var pu:typeUO):Integer;pascal;
        begin
            verifierObjet(pu);
            Result := TDBModel(pu).nfkeys;
        end;

    function fonctionTDBModel_getTable(var pu:typeUO):String;pascal;
        begin
            verifierObjet(pu);
            Result := TDBModel(pu).application_table;
        end;

    function fonctionTDBModel_getConstraint(key:String;var pu:typeUO):String;pascal;
        var
            model:TDBModel;

        begin
            verifierObjet(pu);
            model := TDBModel(pu);
            if model.has_key(key) then Result := model.constraints.Values[key] else Result := '';
        end;

    function fonctionTDBModel_getType(key:String;var pu:typeUO):String;pascal;
        var
            model:TDBModel;

        begin
            verifierObjet(pu);
            model := TDBModel(pu);
            if model.has_key(key) then Result := model.types.Values[key] else Result := '';
        end;

    procedure proTDBModel_getFields(var memo:TstmMemo;var pu:typeUO);pascal;
        var
            astr:TArrayString;
            model:TDBModel;
            i:Integer;
            st:String;

        begin
            verifierObjet(pu);
            model := TDBModel(pu);
            verifierObjet(typeUO(memo));
            memo.memo.Clear;
            for i:=1 to model.fields.Count do memo.memo.Lines.add(model.fields[i-1]);
        end;

    procedure proTDBModel_getPKeys(var memo:TstmMemo;var pu:typeUO);pascal;
        var
            astr:TArrayString;
            model:TDBModel;
            i:Integer;
            st:String;

        begin
            verifierObjet(pu);
            model := TDBModel(pu);
            verifierObjet(typeUO(memo));
            memo.memo.Clear;
            for i:=1 to model.pkeys.Count do memo.memo.Lines.add(model.pkeys[i-1]);
        end;

    procedure proTDBModel_getFKeys(var memo:TstmMemo;var pu:typeUO);pascal;
        var
            astr:TArrayString;
            model:TDBModel;
            i:Integer;
            st:String;

        begin
            verifierObjet(pu);
            model := TDBModel(pu);
            verifierObjet(typeUO(memo));
            memo.memo.Clear;
            for i:=1 to model.fkeys.Count do memo.memo.Lines.add(model.fkeys[i-1]);
        end;

    procedure proTDBModel_getLookup(key:String;var memo:TstmMemo;var pu:typeUO);pascal;
        var
            astr:TArrayString;
            model:TDBModel;

        begin
            verifierObjet(pu);
            model := TDBModel(pu);
            verifierObjet(typeUO(memo));
            memo.memo.Clear;
            if model.is_fkey(key) then memo.memo.Lines.Add(model.lookups.Values[key] + '.' + model.references.Values[key]);
        end;

initialization
    registerObject(TDBModel,sys);
end.
