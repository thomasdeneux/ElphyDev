unit DBUnic;

interface
    uses
        SysUtils,
        stmDatabase2,
        stmObj,
        stmPG,
        stmMemo1,
        DBObjects,
        DBModels,
        DBManagers,
        DBQuerySets,
        ZDbcIntfs,
        Classes;

    procedure initCache;
    function model_is_installed:Boolean;

    type
        TDBUnic = class(typeUO)
        public
            class function stmClassName:string;override;
        end;

    var
        dbConnector:TDBUnic;

    function fonctionDBUnic:pointer;pascal;
    procedure proTDBUnic_InitConnection(protocol,host:String;port:Integer;database,login,password:String;var pu:typeUO);pascal;
    procedure proTDBUnic_CloseConnection(var pu:typeUO);pascal;
    procedure proTDBUnic_LaunchCommit(var pu:typeUO);pascal;
    function constructAnalysisQuery(analysis_type,condition,order:String):String;
    function constructStatistics:String;
    {shortcuts for installing or uninstalling the analysis database model}
    procedure proTDBUnic_InstallAnalysisModel(var pu:typeUO);pascal; {tested}
    procedure proTDBUnic_UninstallAnalysisModel(var pu:typeUO);pascal; {tested}
    procedure proTDBUnic_GetModels(var memo:TstmMemo;var pu:typeUO);pascal;
    {shortcuts for AnalysisType creation, redefinition and deletion}
    procedure proTDBUnic_DefineAnalysisType(id,usecase,path:String;commit:Boolean;var pu:typeUO);pascal; {tested}
    procedure proTDBUnic_RenameAnalysisType(old_id,new_id:String;commit:Boolean;var pu:typeUO);pascal; {tested}
    procedure proTDBUnic_RelocateAnalysisType(id,new_path:String;commit:Boolean;var pu:typeUO);pascal; {tested}
    procedure proTDBUnic_ExplainAnalysisType(id,usecase:String;commit:Boolean;var pu:typeUO);pascal; {tested}
    procedure proTDBUnic_RemoveAnalysisType(id:String;commit:Boolean;var pu:typeUO);pascal; {tested}
    {shortcuts for Input/Output creation, redefinition and deletion}
    procedure proTDBUnic_DefineInputOutput(analysis_type,name,iotype,iocoding,usecase:String;commit:Boolean;var pu:typeUO);pascal; {tested}
    procedure proTDBUnic_RemoveInputOutput(analysis_type,name:String;commit:Boolean;var pu:typeUO);pascal; {tested}
    procedure proTDBUnic_RenameInputOutput(analysis_type,old_name,new_name:String;commit:Boolean;var pu:typeUO);pascal; {tested}
    procedure proTDBUnic_ExplainInputOutput(analysis_type,name,usecase:String;commit:Boolean;var pu:typeUO);pascal; {tested}
    {shortcuts for Analysis creation and deletion}
    procedure proTDBUnic_StoreAnalysis(var analysis_object:TDBObject;commit:Boolean;var pu:typeUO);pascal; {tested}
    procedure proTDBUnic_RemoveAnalysis(id:String;commit:Boolean;var pu:typeUO);pascal; {tested}
    procedure proTDBUnic_GetAnalyses(analysis_type,condition,order:String;var resultset:TDBResultSet;var pu:typeUO);pascal;
    procedure proTDBUnic_GetStatistics(var resultset:TDBResultSet;var pu:typeUO);pascal;
    procedure proTDBUnic_GetAnalysesAsObjects(analysis_type,condition,order:String;var queryset:TDBQuerySet;var pu:typeUO);pascal;

implementation
    uses
        DBCache;

    class function TDBUnic.stmClassName:string;
        begin
            result:='DBUnic';
        end;

    function fonctionDBUnic:pointer;
        begin
            result:=@dbConnector;
        end;

    procedure proTDBUnic_GetModels(var memo:TstmMemo;var pu:typeUO);pascal;
        var
            statement:IZStatement;
            resultset:IZResultSet;
            query,table:String;

        begin
            verifierObjet(typeUO(memo));
            memo.memo.Clear;
            statement := DBConnection.Connection.createStatement;
            query := 'SELECT table_name FROM information_schema.tables WHERE table_schema = ''public'' AND table_type = ''BASE TABLE'' ORDER BY table_name';
            resultset := statement.ExecuteQuery(query);
            while resultset.Next do
                begin
                    table := resultset.GetStringByName('table_name');
                    memo.memo.Lines.add(table);
                end;
        end;

    procedure proTDBUnic_CloseConnection(var pu:typeUO);pascal;
        begin
            DBCONNECTION.closeDB;
            anTypeManager.Free;
            anManager.Free;
            ioManager.Free;
            potManager.Free;
            subpotManager_bool.Free;
            subpotManager_int.Free;
            subpotManager_float.Free;
            subpotManager_str.Free;
            inputManager.Free;
            outputManager.Free;
            anTypeModel.Free;
            anModel.Free;
            ioModel.Free;
            potModel.Free;
            subpotModel_bool.Free;
            subpotModel_int.Free;
            subpotModel_float.Free;
            subpotModel_str.Free;
            inputModel.Free;
            outputModel.Free;
        end;

    function model_is_installed:Boolean;
        var
            statement:IZStatement;
            resultset:IZResultSet;
            query,table:String;
            count:Integer;

        begin
            statement := DBConnection.Connection.createStatement;
            query := 'SELECT table_name FROM information_schema.tables WHERE table_schema = ''public'' AND table_type = ''BASE TABLE'' AND table_name LIKE ''analysis_%'' ORDER BY table_name';
            resultset := statement.ExecuteQuery(query);
            count := 0;
            while resultset.Next do count := count + 1;
            if count > 0 then Result := True else Result := False;
        end;

    procedure initCache;
        begin
            {create managers relative analyses}
            anTypeModel := TDBModel.Create('analysis_component');
            anModel := TDBModel.Create('analysis_analysis');
            ioModel := TDBModel.Create('analysis_pin');
            potModel := TDBModel.Create('analysis_potential');
            subpotModel_bool := TDBModel.Create('analysis_potential_boolean');
            subpotModel_int := TDBModel.Create('analysis_potential_integer');
            subpotModel_float := TDBModel.Create('analysis_potential_float');
            subpotModel_str := TDBModel.Create('analysis_potential_string');
            inputModel := TDBModel.Create('analysis_analysis_inputs');
            outputModel := TDBModel.Create('analysis_analysis_outputs');
            {create managers relative analyses}
            anTypeManager := TDBManager.Create(anTypeModel);
            anManager := TDBManager.Create(anModel);
            ioManager := TDBManager.Create(ioModel);
            potManager := TDBManager.Create(potModel);
            subpotManager_bool := TDBManager.Create(subpotModel_bool);
            subpotManager_int := TDBManager.Create(subpotModel_int);
            subpotManager_float := TDBManager.Create(subpotModel_float);
            subpotManager_str := TDBManager.Create(subpotModel_str);
            inputManager := TDBManager.Create(inputModel);
            outputManager := TDBManager.Create(outputModel);
        end;

    procedure proTDBUnic_InitConnection(protocol,host:String;port:Integer;database,login,password:String;var pu:typeUO);pascal;
        begin
            {
            if not assigned(connection) then createPgObject('',typeUO(connection),TDBConnection) else connection.closeDB;
            connection.connectDB(protocol, host, port, database, login, password);
            DBCONNECTION := connection;
            }
            if DBCONNECTION = nil then DBCONNECTION := TDBConnection.Create else proTDBUnic_CloseConnection(pu);
            DBCONNECTION.connectDB(protocol, host, port, database, login, password);
            if model_is_installed then initCache;
        end;

    procedure proTDBUnic_LaunchCommit(var pu:typeUO);
        begin
            DBCONNECTION.connection.commit;
        end;

    procedure proTDBUnic_InstallAnalysisModel(var pu:typeUO);
        var
            statement:IZStatement;
            resultset:IZResultSet;
            query:String;

        begin
            if model_is_installed then raise Exception.Create('Analysis Model Already Installed');
            query := 'BEGIN;' +
                     'CREATE TABLE "analysis_component" (' +
                     '   "id" varchar(256) NOT NULL PRIMARY KEY,' +
                     '   "usecase" text NULL,' +
                     '   "base" boolean NOT NULL,' +
                     '   "package" text NULL,' +
                     '   "language" varchar(16) NULL );' +
                     'CREATE TABLE "analysis_subcomponent" (' +
                     '    "id" serial NOT NULL PRIMARY KEY,' +
                     '    "component_id" varchar(256) NOT NULL REFERENCES "analysis_component" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "subcomponent_id" varchar(256) NOT NULL REFERENCES "analysis_component" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "alias" varchar(256) NOT NULL,'+
                     '    UNIQUE ("component_id", "subcomponent_id", "alias"));'+
                     'CREATE TABLE "analysis_pintype" ('+
                     '    "id" varchar(32) NOT NULL PRIMARY KEY);'+
                     'CREATE TABLE "analysis_codingtype" ('+
                     '    "id" varchar(32) NOT NULL PRIMARY KEY);'+
                     'CREATE TABLE "analysis_pin" ( '+
                     '    "id" serial NOT NULL PRIMARY KEY, '+
                     '    "component" varchar(256) NOT NULL REFERENCES "analysis_component" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "name" varchar(256) NOT NULL,'+
                     '    "usecase" text NULL,'+
                     '    "pintype" varchar(32) NOT NULL REFERENCES "analysis_pintype" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "codingtype" varchar(32) NULL REFERENCES "analysis_codingtype" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    UNIQUE ("component", "name"));'+
                     'CREATE TABLE "analysis_connection" ('+
                     '    "id" serial NOT NULL PRIMARY KEY,'+
                     '    "component" varchar(256) NOT NULL REFERENCES "analysis_component" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "pin_left_id" integer NOT NULL REFERENCES "analysis_pin" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "pin_right_id" integer NOT NULL REFERENCES "analysis_pin" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "alias_left_id" integer NULL REFERENCES "analysis_subcomponent" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "alias_right_id" integer NULL REFERENCES "analysis_subcomponent" ("id") DEFERRABLE INITIALLY DEFERRED);'+
                     'CREATE TABLE "analysis_potential" ('+
                     '    "id" serial NOT NULL PRIMARY KEY,'+
                     '    "pin" integer NOT NULL REFERENCES "analysis_pin" ("id") DEFERRABLE INITIALLY DEFERRED);'+
                     'CREATE TABLE "analysis_potential_existing" ('+
                     '    "potential_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "value_id" integer NOT NULL REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED);'+
                     'CREATE TABLE "analysis_potential_integer" ('+
                     '    "potential_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "value" integer NOT NULL);'+
                     'CREATE TABLE "analysis_potential_float" ('+
                     '    "potential_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "value" double precision NOT NULL);'+
                     'CREATE TABLE "analysis_potential_string" ('+
                     '    "potential_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "value" text NOT NULL);'+
                     'CREATE TABLE "analysis_potential_date" ('+
                     '    "potential_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "value" date NOT NULL);'+
                     'CREATE TABLE "analysis_potential_time" ('+
                     '    "potential_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "value" time NOT NULL);'+
                     'CREATE TABLE "analysis_potential_datetime" ('+
                     '    "potential_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "value" timestamp with time zone NOT NULL);'+
                     'CREATE TABLE "analysis_potential_boolean" ('+
                     '    "potential_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "value" boolean NOT NULL);'+
                     'CREATE TABLE "analysis_potential_pythonobject" ('+
                     '    "potential_ptr_id" integer NOT NULL PRIMARY KEY REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "value" text NOT NULL);'+
                     'CREATE TABLE "analysis_analysis" ('+
                     '    "id" varchar(256) NOT NULL PRIMARY KEY,'+
                     '    "component" varchar(256) NOT NULL REFERENCES "analysis_component" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "comments" text NULL);'+
                     'CREATE TABLE "analysis_analysis_inputs" ('+
                     '    "id" serial NOT NULL PRIMARY KEY,'+
                     '    "analysis_id" varchar(256) NOT NULL REFERENCES "analysis_analysis" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "potential_id" integer NOT NULL REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    UNIQUE ("analysis_id", "potential_id"));'+
                     'CREATE TABLE "analysis_analysis_outputs" ('+
                     '    "id" serial NOT NULL PRIMARY KEY,'+
                     '    "analysis_id" varchar(256) NOT NULL REFERENCES "analysis_analysis" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "potential_id" integer NOT NULL REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    UNIQUE ("analysis_id", "potential_id"));'+
                     'CREATE TABLE "analysis_analysis_debugs" ('+
                     '    "id" serial NOT NULL PRIMARY KEY,'+
                     '    "analysis_id" varchar(256) NOT NULL REFERENCES "analysis_analysis" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    "potential_id" integer NOT NULL REFERENCES "analysis_potential" ("id") DEFERRABLE INITIALLY DEFERRED,'+
                     '    UNIQUE ("analysis_id", "potential_id"));'+
                     'CREATE LANGUAGE plpythonu;' +
                     'CREATE FUNCTION ar_median(ar float8[]) RETURNS float AS $$'+ #13#10 +
                     '    tmp = ar.replace(''{'','''')'+ #13#10 +
                     '    tmp = tmp.replace(''}'','''')'+ #13#10 +
                     '    tmp = tmp.split('','')'+ #13#10 +
                     '    tmp = [float(k) for k in tmp]'+ #13#10 +
                     '    tmp.sort()'+ #13#10 +
                     '    N = len(tmp)'+ #13#10 +
                     '    if N == 0 :'+ #13#10 +
                     '        return 0'+ #13#10 +
                     '    elif N == 1 :'+ #13#10 +
                     '        return tmp[0]'+ #13#10 +
                     '    elif (N%2)==0 :'+ #13#10 +
                     '        return 0.5*(tmp[N/2-1] + tmp[N/2])'+ #13#10 +
                     '    else :'+ #13#10 +
                     '        return float(tmp[N/2])'+ #13#10 +
                     '$$ LANGUAGE plpythonu;'+
                     'CREATE AGGREGATE median(float8) (sfunc=array_append,stype=float8[],finalfunc=ar_median,initcond=''{}'');'+
                     'CREATE FUNCTION ar_median(ar text[]) RETURNS varchar AS $$'+ #13#10 +
                     '    return None'+ #13#10 +
                     '$$ LANGUAGE plpythonu;'+
                     'CREATE AGGREGATE median(text) (sfunc=array_append,stype=text[],finalfunc=ar_median,initcond=''{}'');'+
                     'CREATE FUNCTION ar_avg(ar text[]) RETURNS varchar AS $$'+ #13#10 +
                     '    return None'+ #13#10 +
                     '$$ LANGUAGE plpythonu;'+
                     'CREATE AGGREGATE avg(text) (sfunc=array_append,stype=text[],finalfunc=ar_avg,initcond=''{}'');'+
                     {
                     'CREATE FUNCTION ar_stddev_pop(ar text[]) RETURNS varchar AS $$'+ #13#10 +
                     '    return None'+ #13#10 +
                     '$$ LANGUAGE plpythonu;'+
                     'CREATE AGGREGATE stddev_pop(text) (sfunc=array_append,stype=text[],finalfunc=ar_stddev_pop,initcond='''');'+
                     }
                     'CREATE FUNCTION ar_stddev_samp(ar text[]) RETURNS varchar AS $$'+ #13#10 +
                     '    return None'+ #13#10 +
                     '$$ LANGUAGE plpythonu;'+
                     'CREATE AGGREGATE stddev(text) (sfunc=array_append,stype=text[],finalfunc=ar_stddev_samp,initcond=''{}'');'+
                     {
                     'CREATE FUNCTION ar_var_pop(ar text[]) RETURNS varchar AS $$'+ #13#10 +
                     '    return None'+ #13#10 +
                     '$$ LANGUAGE plpythonu;'+
                     'CREATE AGGREGATE var_pop(text) (sfunc=array_append,stype=text[],finalfunc=ar_var_pop,initcond='''');'+
                     'CREATE FUNCTION ar_var_samp(ar text[]) RETURNS varchar AS $$'+ #13#10 +
                     '    return None'+ #13#10 +
                     '$$ LANGUAGE plpythonu;'+
                     'CREATE AGGREGATE variance(text) (sfunc=array_append,stype=text[],finalfunc=ar_var_samp,initcond='''');'+
                     }
                     'CREATE FUNCTION ar_min(ar float8[]) RETURNS float AS $$' + #13#10 +
                     '  tmp = ar.replace(''{'','''')' + #13#10 +
                     '  tmp = tmp.replace(''}'','''')' + #13#10 +
                     '  tmp = tmp.split('','')' + #13#10 +
                     '  return min(tmp)' + #13#10 +
                     '$$ LANGUAGE plpythonu;' +

                     'CREATE AGGREGATE pmin(float8) (sfunc=array_append,stype=float8[],finalfunc=ar_min,initcond=''{}'');' +

                     'CREATE FUNCTION ar_max(ar float8[]) RETURNS float AS $$' + #13#10 +
                     '  tmp = ar.replace(''{'','''')' + #13#10 +
                     '  tmp = tmp.replace(''}'','''')' + #13#10 +
                     '  tmp = tmp.split('','')' + #13#10 +
                     '  return max(tmp)' + #13#10 +
                     '$$ LANGUAGE plpythonu;' +

                     'CREATE AGGREGATE pmax(float8) (sfunc=array_append,stype=float8[],finalfunc=ar_max,initcond=''{}'');' +

                     'CREATE FUNCTION ar_min(ar int[]) RETURNS integer AS $$' + #13#10 +
                     '  tmp = ar.replace(''{'','''')' + #13#10 +
                     '  tmp = tmp.replace(''}'','''')' + #13#10 +
                     '  tmp = tmp.split('','')' + #13#10 +
                     '  return min(tmp)' + #13#10 +
                     '$$ LANGUAGE plpythonu;' +

                     'CREATE AGGREGATE pmin(int) (sfunc=array_append,stype=int[],finalfunc=ar_min,initcond=''{}'');' +

                     'CREATE FUNCTION ar_max(ar int[]) RETURNS integer AS $$' + #13#10 +
                     '  tmp = ar.replace(''{'','''')' + #13#10 +
                     '  tmp = tmp.replace(''}'','''')' +  #13#10 +
                     '  tmp = tmp.split('','')' + #13#10 +
                     '  return max(tmp)' + #13#10 +
                     '$$ LANGUAGE plpythonu;' +

                     'CREATE AGGREGATE pmax(int) (sfunc=array_append,stype=int[],finalfunc=ar_max,initcond=''{}'');' +

                     'CREATE FUNCTION ar_min(ar text[]) RETURNS text AS $$' + #13#10 +
                     '  return None' + #13#10 +
                     '$$ LANGUAGE plpythonu;' +

                     'CREATE AGGREGATE pmin(text) (sfunc=array_append,stype=text[],finalfunc=ar_min,initcond=''{}'');' +

                     'CREATE FUNCTION ar_max(ar text[]) RETURNS text AS $$' + #13#10 +
                     '  return None' + #13#10 +
                     '$$ LANGUAGE plpythonu;' +

                     'CREATE AGGREGATE pmax(text) (sfunc=array_append,stype=text[],finalfunc=ar_max,initcond=''{}'');' +

                     'CREATE FUNCTION ar_avg_name(ar text[]) RETURNS text AS $$' + #13#10 +
                     '    return ''=== Mean ===''' + #13#10 +
                     '$$ LANGUAGE plpythonu;' +

                     'CREATE AGGREGATE avg_name(text) (sfunc=array_append,stype=text[],finalfunc=ar_avg_name,initcond=''{}'');' +

                     'CREATE FUNCTION ar_pmin_name(ar text[]) RETURNS text AS $$ ' + #13#10 +
                     '   return ''=== Min ===''' + #13#10 +
                     '$$ LANGUAGE plpythonu; ' +

                     'CREATE AGGREGATE pmin_name(text) (sfunc=array_append,stype=text[],finalfunc=ar_pmin_name,initcond=''{}'');' +

                     'CREATE FUNCTION ar_pmax_name(ar text[]) RETURNS text AS $$' + #13#10 +
                     '    return ''=== Max ===''' + #13#10 +
                     '$$ LANGUAGE plpythonu; ' +

                     'CREATE AGGREGATE pmax_name(text) (sfunc=array_append,stype=text[],finalfunc=ar_pmax_name,initcond=''{}'');' +

                     'CREATE FUNCTION ar_median_name(ar text[]) RETURNS text AS $$ ' + #13#10 +
                     '    return ''=== Median ==='' ' + #13#10 +
                     '$$ LANGUAGE plpythonu; ' +

                     'CREATE AGGREGATE median_name(text) (sfunc=array_append,stype=text[],finalfunc=ar_median_name,initcond=''{}'');' +
                     {
                     'CREATE FUNCTION ar_stddev_pop_name(ar text[]) RETURNS text AS $$ ' + #13#10 +
                     '    return ''Std Population''' + #13#10 +
                     '$$ LANGUAGE plpythonu;' +

                     'CREATE AGGREGATE stddev_pop_name(text) (sfunc=array_append,stype=text[],finalfunc=ar_stddev_pop_name,initcond='''');' +
                     }
                     'CREATE FUNCTION ar_stddev_samp_name(ar text[]) RETURNS text AS $$' + #13#10 +
                     '    return ''=== Std ===''' + #13#10 +
                     '$$ LANGUAGE plpythonu;' +

                     'CREATE AGGREGATE stddev_name(text) (sfunc=array_append,stype=text[],finalfunc=ar_stddev_samp_name,initcond=''{}'');' +
                     {
                     'CREATE FUNCTION ar_var_pop_name(ar text[]) RETURNS text AS $$' + #13#10 +
                     '    return ''Variance Population''' + #13#10 +
                     '$$ LANGUAGE plpythonu;' +

                     'CREATE AGGREGATE var_pop_name(text) (sfunc=array_append,stype=text[],finalfunc=ar_var_pop_name,initcond='''');' +

                     'CREATE FUNCTION ar_var_samp_name(ar text[]) RETURNS text AS $$' + #13#10 +
                     '    return ''Variance Sample''' + #13#10 +
                     '$$ LANGUAGE plpythonu;' +

                     'CREATE AGGREGATE variance_name(text) (sfunc=array_append,stype=text[],finalfunc=ar_var_samp_name,initcond='''');' +
                     }
                     {'INSERT INTO analysis_pintype (id) VALUES (''Parameter'');'+}
                     'INSERT INTO analysis_pintype (id) VALUES (''Input'');'+
                     'INSERT INTO analysis_pintype (id) VALUES (''Output'');'+
                     'INSERT INTO analysis_codingtype (id) VALUES (''int'');'+
                     'INSERT INTO analysis_codingtype (id) VALUES (''float'');'+
                     'INSERT INTO analysis_codingtype (id) VALUES (''str'');'+
                     'INSERT INTO analysis_codingtype (id) VALUES (''bool'');'+
                     'INSERT INTO analysis_codingtype (id) VALUES (''file'');'+
                     {
                     'INSERT INTO analysis_codingtype (id) VALUES (''date'');'+
                     'INSERT INTO analysis_codingtype (id) VALUES (''time'');'+
                     'INSERT INTO analysis_codingtype (id) VALUES (''datetime'');'+
                     'INSERT INTO analysis_codingtype (id) VALUES (''file'');'+
                     'INSERT INTO analysis_codingtype (id) VALUES (''object'');'+
                     'INSERT INTO analysis_codingtype (id) VALUES (''none'');'+
                     }
                     'COMMIT;';
            statement := DBCONNECTION.connection.createStatement;
            statement.ExecuteQuery(query);
            DBCONNECTION.connection.Commit;
            initCache;
        end;

    procedure proTDBUnic_UninstallAnalysisModel(var pu:typeUO);
        var
            statement:IZStatement;
            query:String;

        begin
            if not model_is_installed then raise Exception.Create('Analysis Model Not Installed');
            query := 'DROP TABLE analysis_potential_integer;' +
                     'DROP TABLE analysis_potential_float;' +
                     'DROP TABLE analysis_potential_boolean;' +
                     'DROP TABLE analysis_potential_string;' +
                     'DROP TABLE analysis_potential_date;' +
                     'DROP TABLE analysis_potential_datetime;' +
                     'DROP TABLE analysis_potential_time;' +
                     'DROP TABLE analysis_potential_existing;' +
                     'DROP TABLE analysis_potential_pythonobject;' +
                     'DROP TABLE analysis_analysis_debugs;' +
                     'DROP TABLE analysis_analysis_inputs;' +
                     'DROP TABLE analysis_analysis_outputs;' +
                     'DROP TABLE analysis_potential;' +
                     'DROP TABLE analysis_analysis;' +
                     'DROP TABLE analysis_connection;' +
                     'DROP TABLE analysis_pin;' +
                     'DROP TABLE analysis_subcomponent;' +
                     'DROP TABLE analysis_component;' +
                     'DROP TABLE analysis_pintype;' +
                     'DROP TABLE analysis_codingtype;' +
                     'DROP AGGREGATE median(float8);' +
                     'DROP FUNCTION ar_median(float8[]);' +
                     'DROP AGGREGATE median(text);' +
                     'DROP FUNCTION ar_median(text[]);' +
                     'DROP AGGREGATE avg(text);' +
                     'DROP FUNCTION ar_avg(text[]);' +
                     {
                     'DROP AGGREGATE stddev_pop(text);' +
                     'DROP FUNCTION ar_stddev_pop(text[]);' +
                     }
                     'DROP AGGREGATE stddev(text);' +
                     'DROP FUNCTION ar_stddev_samp(text[]);' +
                     {
                     'DROP AGGREGATE var_pop(text);' +
                     'DROP FUNCTION ar_var_pop(text[]);' +
                     'DROP AGGREGATE variance(text);' +
                     'DROP FUNCTION ar_var_samp(text[]);' +
                     }
                     'DROP AGGREGATE pmin(int);' +
                     'DROP FUNCTION ar_min(int[]);' +
                     'DROP AGGREGATE pmax(int);' +
                     'DROP FUNCTION ar_max(int[]);' +
                     'DROP AGGREGATE pmin(float8);' +
                     'DROP FUNCTION ar_min(float8[]);' +
                     'DROP AGGREGATE pmax(float8);' +
                     'DROP FUNCTION ar_max(float8[]);' +
                     'DROP AGGREGATE pmin(text);' +
                     'DROP FUNCTION ar_min(text[]);' +
                     'DROP AGGREGATE pmax(text);' +
                     'DROP FUNCTION ar_max(text[]);'+
                     'DROP AGGREGATE avg_name(text);'+
                     'DROP AGGREGATE pmin_name(text);'+
                     'DROP AGGREGATE pmax_name(text);'+
                     'DROP AGGREGATE median_name(text);'+
                     {'DROP AGGREGATE stddev_pop_name(text);'+}
                     'DROP AGGREGATE stddev_name(text);'+
                     {
                     'DROP AGGREGATE var_pop_name(text);'+
                     'DROP AGGREGATE variance_name(text);'+
                     }
                     'DROP FUNCTION ar_avg_name(text[]);'+
                     'DROP FUNCTION ar_pmin_name(text[]);'+
                     'DROP FUNCTION ar_pmax_name(text[]);'+
                     'DROP FUNCTION ar_median_name(text[]);'+
                     {'DROP FUNCTION ar_stddev_pop_name(text[]);'+ }
                     'DROP FUNCTION ar_stddev_samp_name(text[]);'+
                     {
                     'DROP FUNCTION ar_var_pop_name(text[]);'+
                     'DROP FUNCTION ar_var_samp_name(text[]);'+
                     }
                     'DROP LANGUAGE plpythonu;';
                     
            statement := DBCONNECTION.connection.createStatement;
            statement.ExecuteQuery(query);
            DBCONNECTION.connection.Commit;
        end;
    {
    function constructAnalysisQuery(analysis_type,condition,order:String;connection:TDBConnection):String;
        var
            ioModel:TDBModel;
            ioManager:TDBManager;
            pins:TDBQuerySet;
            pin:TDBObject;
            i:Integer;
            coding,cls,pinname,pintype,select,from,where,join:String;
            query:AnsiString;


        begin
            select := 'SELECT an.id,an.comments,';
            from := ' FROM analysis_analysis as an,';
            where := ' WHERE an.component = ''' + analysis_type + ''' AND ';
            ioModel := TDBModel.Create('analysis_pin',connection.connection);
            ioManager := TDBManager.Create(ioModel);
            pins := ioManager.filter('component = ''' + analysis_type + '''','id');
            for i:=1 to pins.count do
                begin
                    pin := pins.objects[i-1];
                    coding := pin.value['codingtype'].VString;
                    if coding = 'bool' then cls:='boolean';
                    if coding = 'int' then cls:='integer';
                    if coding = 'float' then cls:='float';
                    if coding = 'str' then cls:='string';
                    if coding = 'file' then cls:='string';
                    pinname := pin.value['name'].VString;
                    select := select + '"' + pinname + '"' + '.value as "' + pinname + '"';
                    pintype := pin.value['pintype'].VString;
                    if (pintype = 'Input') or (pintype = 'Parameter') then pintype := 'inputs' else if (pintype = 'Output') then pintype := 'outputs';
                    join := '(SELECT an.id,pin.name,pottype.value ' +
                             'FROM analysis_analysis as an,' +
                                  'analysis_potential_' + cls + ' as pottype,' +
                                  'analysis_potential as pot,' +
                                  'analysis_pin as pin,' +
                                  'analysis_analysis_' + pintype + ' as ' + pintype +
                            ' WHERE an.id = ' + pintype + '.analysis_id' +
                            ' AND   ' + pintype + '.potential_id = pot.id' +
                            ' AND   pot.pin = pin.id' +
                            ' AND   pot.id = pottype.potential_ptr_id' +
                            ' AND   pin.name = ''' + pinname + ''')' + ' as "' + pinname + '"';
                
                    where := where + '"' + pinname + '"' + '.id = an.id';
                         
                    from := from + join;
                    if i < pins.count then
                        begin
                            select := select + ',';
                            from := from + ',';
                            where := where + ' AND ';
                        end;
                end;
            if condition <> '' then where := where + ' AND ' + condition;
            if order <> '' then query := select + from + where + ' ORDER BY "' + order + '"' else query := select + from + where;
            constructAnalysisQuery := query;
        end;
    }

    function constructStatistics:String;
        var
            i,j:Integer;
            statistics:TStringList;
            stat_query,tmp_query,null_row:String;

        begin
            if all_fields = nil then raise Exception.create('cannot do statistics before listing analyses');
            {some basic analyses}
            statistics := TStringList.Create;
            statistics.Add('avg');
            statistics.Add('pmin');
            statistics.Add('pmax');
            statistics.Add('median');
            statistics.Add('stddev');
            {
            statistics.Add('stddev_pop');
            statistics.Add('var_pop');
            statistics.Add('variance');
            }
            stat_query := '';
            for i := 1 to statistics.Count do
                begin
                    tmp_query := 'SELECT ' + statistics[i-1] + '_name(id) as id,' + statistics[i-1] + '(component) as component,' + statistics[i-1] + '(comments) as comments,';
                    for j := 1 to all_fields.count do
                        begin
                            tmp_query := tmp_query + statistics[i-1] + '("' + all_fields[j-1] + '") as "' + all_fields[j-1] + '"';
                            if j < all_fields.Count then tmp_query := tmp_query + ',';
                        end;
                    stat_query := stat_query + tmp_query + ' FROM (VALUES ' + LAST_ANALYSES_CONSTRUCT + ') as an(' + LAST_ANALYSES_SELECT + ')';
                    if LAST_ANALYSES_WHERE <> '' then stat_query := stat_query + ' WHERE ' + LAST_ANALYSES_WHERE;
                    if i < statistics.Count then stat_query := stat_query + ' UNION ';
                end;
            statistics.Free;
            Result := stat_query;
    end;

    function constructAnalysisQuery(analysis_type,condition,order:String):String;
        var
            delegateManager:TDBManager;
            analyses,inouts,ios,pins,potentials,subpotentials:TDBQuerySet;
            analysis,pin,potential,subpotential,inout,void_object:TDBObject;
            i,j,k,m,pin_id,potential_id,subpotential_id,total_pins, npins,old_npins,index,last_index:Integer;
            analysis_id,analysis_comments,coding,cls,pintype,oldpinname,pinname,select,from,where,join,query,row,values,value,aliases:String;
            field_state:TStringList;

        begin
            field_state := TStringList.Create;
            all_fields.Free;{come from cache}
            all_fields := TStringList.Create;
            pins := ioManager.filter('component = ''' + analysis_type + '''','id');
            select := 'id,component,comments,';
            total_pins := pins.count;
            for i:=1 to total_pins do
                begin
                    pinname := pins.objects[i-1].value['name'].VString;
                    field_state.Values[pinname] := 'False';
                end;
            LAST_ANALYSES_WHERE := condition;
            if condition <> '' then where := ' WHERE ' + condition else where := '';
            analyses := anManager.filter('component = ''' + analysis_type + '''','id');
            value := '';
            for i:=1 to analyses.count do
                begin
                    analysis := analyses.objects[i-1];
                    analysis_id := analysis.value['id'].VString;
                    analysis_comments := analysis.value['comments'].VString;
                    row := '(''' + analysis_id + ''',''' + analysis_type + ''',''' + analysis_comments + ''',';
                    npins := 0;
                    for j:= 1 to 2 do
                        begin
                            if j = 1 then
                                begin
                                    delegateManager := inputManager;
                                    pintype := 'Input';
                                end
                            else
                                begin
                                    delegateManager := outputManager;
                                    pintype := 'Output';
                                end;
                            inouts := delegateManager.filter('analysis_id = ''' + analysis_id + '''','id');
                            ios := ioManager.filter('pintype = ''' + pintype + ''' and component = ''' + analysis_type + '''','id');

                            if ios.count <> inouts.count then
                                begin
                                    field_state.Clear;
                                    for k:=1 to ios.count do
                                        begin
                                            pinname := ios.objects[k-1].value['name'].VString;
                                            field_state.Values[pinname] := 'False';
                                        end;
                                    for k := 1 to inouts.count do
                                        begin
                                            potential_id := inouts.objects[k-1].value['potential_id'].VInteger;
                                            potential := potManager.get('id = ' + IntToStr(potential_id));
                                            pin_id := potential.value['pin'].Vinteger;
                                            pin := ioManager.get('id = ' + IntToStr(pin_id));
                                            pinname := pin.value['name'].VString;
                                            field_state.Values[pinname] := 'True';
                                            potential.Free;
                                            pin.Free;
                                        end;

                                    last_index := 0;
                                    for k := 1 to ios.count do
                                        begin
                                            pinname := ios.objects[k-1].value['name'].VString;
                                            if field_state.Values[pinname] = 'False' then
                                                begin
                                                    index := field_state.IndexOf(pinname + '=' + field_state.Values[pinname]);
                                                    if (index > inouts.list.count) or (inouts.list.count = 0) then
                                                        begin
                                                            inouts.list.Add(TDBObject.Create);
                                                            index := 0;
                                                        end
                                                    else inouts.list.Insert(index,TDBObject.Create);
                                                    void_object := inouts.list[index];
                                                    void_object.AddField('potential_id',gvInteger);
                                                    void_object.AddField('pinname',gvString);
                                                    void_object.VInteger[0] := -1;
                                                    void_object.VString[1] := pinname;
                                                end;
                                        end;

                                end;
                            ios.Free;

                            for k := 1 to inouts.count do
                                begin
                                    npins := npins + 1;
                                    potential_id := inouts.objects[k-1].value['potential_id'].VInteger;
                                    if potential_id > -1 then
                                        begin
                                            potential := potManager.get('id = ' + IntToStr(potential_id));
                                            pin_id := potential.value['pin'].Vinteger;
                                            pin := ioManager.get('id = ' + IntToStr(pin_id));
                                            coding := pin.value['codingtype'].VString;
                                            pinname := pin.value['name'].VString;
                                            if all_fields.IndexOf(pinname) < 0 then all_fields.Add(pinname);
                                            if coding = 'bool' then delegateManager:=subpotManager_bool;
                                            if coding = 'int' then delegateManager:=subpotManager_int;
                                            if coding = 'float' then delegateManager:=subpotManager_float;
                                            if (coding = 'str') or (coding = 'file') then delegateManager:=subpotManager_str;

                                            subpotentials := delegateManager.filter('potential_ptr_id = ' + IntToStr(potential_id),'potential_ptr_id');
                                            if subpotentials.count < 1 then value := 'NULL'
                                            else
                                                begin
                                                    subpotential := subpotentials.objects[0];
                                                    value := subpotential.value['value'].getValString;
                                                end;
                                            potential.Free;
                                            pin.Free;
                                            subpotentials.Free;
                                        end
                                    else
                                        begin
                                            value := 'NULL';
                                            pinname := inouts.objects[k-1].value['pinname'].VString;
                                            if all_fields.IndexOf(pinname) < 0 then all_fields.Add(pinname);
                                        end;
                                    if (value <> 'NULL') and ((coding = 'str') or (coding = 'file')) then value := '''' + value + '''';
                                    row := row + value;
                                    if npins < total_pins then row := row + ',' else row := row + ')';
                                end;
                            inouts.Free;
                        end;

                    values := values + row;
                    if i < analyses.count then values := values + ',';
                end;
            if analyses.count > 0 then
                begin
                    for i := 1 to all_fields.count do
                        begin
                            select := select + '"' + all_fields[i-1] + '"';
                            if i < all_fields.Count then select := select + ',';
                        end;
                    from := ' FROM (VALUES ' + values + ') as an(' + select + ')';
                    LAST_ANALYSES_SELECT := select;
                    select := 'SELECT ' + select;
                    if order <> '' then query := select + from + where + ' ORDER BY "' + order + '"' else query := select + from + where;
                end
            else query := '';
            Result := query;
            LAST_ANALYSES_CONSTRUCT := values;
            analyses.Free;
            {all_fields.Free;}
            field_state.Free;
            pins.Free;
    end;

    procedure proTDBUnic_DefineAnalysisType(id,usecase,path:String;commit:Boolean;var pu:typeUO); {tested}
        {Defines a new analysis type in database :

            - id : the name that identify the analysis
            - usecase : the explanation of the analysis type, what does it supposed to do
            - path : the location of the file that contain the program that computes the analysis
            - connection : the TDBConnection object communicating with the database system
            - commit : boolean that tells if the database will be automatically updated or later manually

        }                 
        var
            tmp_object,anType:TDBObject;

        begin
            anType := TDBObject.Create(anTypeModel);
            {define all fields of an analysis type}
            anType.AddField('id',gvString);
            anType.AddField('base',gvBoolean);
            anType.AddField('language',gvString);
            anType.AddField('usecase',gvString);
            anType.AddField('package',gvString);
            {init all fields}
            anType.VString[0] := id;
            anType.VBoolean[1] := True;
            anType.VString[2] := 'Elphy';
            anType.Vstring[3] := usecase;
            anType.Vstring[4] := path;

            tmp_object := anTypeManager.insert(anType,False);
            if commit then DBCONNECTION.connection.commit;
            tmp_object.Free;
            anType.Free;
        end;

    procedure proTDBUnic_RenameAnalysisType(old_id,new_id:String;commit:Boolean;var pu:typeUO);{tested}
        {Renames the string that identifies an analysis type :

            - old_id : the current name of the analysis type
            - new_id : the new name of the analysis
            - connection : the TDBConnection object communicating with the database system
            - commit : boolean that tells if the database will be automatically updated or later manually
        }
        var
            anType,io,analysis:TDBObject;
            ios,analyses:TDBQuerySet;
            index,i:Integer;

        begin
            if old_id <> new_id then
                begin
                    {get the old object, change its id and create a new object with old properties but the old id}
                    anType := anTypeManager.get('id = '''+ old_id + '''');
                    index := anType.fields.IndexOf('id');
                    anType.VString[index] := new_id;
                    anType.save(False);
                    anType.Free;
                    {get all inputs/outputs attached to the old analysis type and link them to the new one}
                    ios := ioManager.filter('component = '''+ old_id + '''','id');
                    for i:=1 to ios.count do
                        begin
                            io := ios.objects[i-1];
                            index := io.fields.IndexOf('component');
                            io.VString[index] := new_id;
                            io.save(False);
                        end;
                    ios.Free;
                    {get all analyses attached to the old analysis type and link them to the new one}
                    analyses := anManager.filter('component = '''+ old_id + '''','id');
                    for i:=1 to analyses.count do
                        begin
                            analysis := analyses.objects[i-1];
                            index := analysis.fields.IndexOf('component');
                            analysis.VString[index] := new_id;
                            analysis.save(False);
                        end;
                    analyses.Free;
                    {remove the old analysis type}
                    anType := anTypeManager.get('id = '''+ old_id + '''');
                    anType.remove(False);
                    anType.Free;
                    if commit then DBCONNECTION.connection.commit;
                end;
        end;

    procedure proTDBUnic_RelocateAnalysisType(id,new_path:String;commit:Boolean;var pu:typeUO);{tested}
        {Relocates the analysis type :

            - id : the name of the analysis type
            - new_path : the new location of the file containing the analysis program
            - connection : the TDBConnection object communicating with the database system
            - commit : boolean that tells if the actions done with the function is done automatically or performed later manually
        }
        var
            anType:TDBObject;
            index:Integer;

        begin
            anType := anTypeManager.get('id = '''+ id + '''');
            index := anType.fields.IndexOf('package');
            anType.VString[index] := new_path;
            anType.save(False);
            if commit then DBCONNECTION.connection.commit;
            anType.Free;
        end;

    procedure proTDBUnic_ExplainAnalysisType(id,usecase:String;commit:Boolean;var pu:typeUO);{tested}
        {Explains the analysis type :

            - id : the name of the analysis type
            - usecase : the new explanation of the purpose of the analysis
            - connection : the TDBConnection object communicating with the database system
            - commit : boolean that tells if the actions done with the function is done automatically or performed later manually
        }
        var
            anType:TDBObject;
            index:Integer;

        begin
            anType := anTypeManager.get('id = '''+ id + '''');
            index := anType.fields.IndexOf('usecase');
            anType.VString[index] := usecase;
            anType.save(False);
            if commit then DBCONNECTION.connection.commit;
            anType.Free;
        end;

    procedure proTDBUnic_DefineInputOutput(analysis_type,name,iotype,iocoding,usecase:String;commit:Boolean;var pu:typeUO);{tested}
        {Defines a new Input/Output for a specified Analysis Type :

            - analysis_type : the name of the analysis type
            - name : the name of the input/output
            - usecase : the explanation of the input/output, what does it supposed to be
            - iotype : specify if it is a Input, an Output or an Extern value coming from another analysis
            - iocoding : the kind of coding that is hold by the input/output choosen from [str,int,bool,float,file]
            - connection : the TDBConnection object communicating with the database system
            - commit : boolean that tells if the database will be automatically updated or later manually

        }
        var
            anType,io,tmp_object:TDBObject;
            test1,test2:Boolean;

        begin
            test1 := (iocoding = 'str') or (iocoding = 'bool') or (iocoding = 'int') or (iocoding = 'float') or (iocoding = 'file');
            test2 := (iotype = 'Input') or (iotype = 'Output');
            if not test1 then raise Exception.Create('iocoding must be in [str,bool,int,float,file]');
            if not test2 then raise Exception.Create('iotype must be in [Input,Output]');
            {test if analysis type is in database}
            try
                anType := anTypeManager.get('id = ''' + analysis_type + '''');
            except
                raise Exception('analysis type ' + analysis_type + ' not in database');
            end;
            anType.Free;
            io := TDBObject.Create(ioModel);
            {define all fields of an analysis type}
            io.AddField('component',gvString);
            io.AddField('name',gvString);
            io.AddField('pintype',gvString);
            io.AddField('codingtype',gvString);
            if usecase <> '' then io.AddField('usecase',gvString);
            {init all fields}
            io.VString[0] := analysis_type;
            io.VString[1] := name;
            io.VString[2] := iotype;
            io.Vstring[3] := iocoding;
            if usecase <> '' then io.VString[4] := usecase;
            tmp_object := ioManager.insert(io,False);
            if commit then DBCONNECTION.connection.commit;
            tmp_object.Free;
            io.Free;
        end;

    procedure proTDBUnic_RenameInputOutput(analysis_type,old_name,new_name:String;commit:Boolean;var pu:typeUO);{tested}
        {Renames the analysis type input/output :

            - analysis_type : the name of the analysis type
            - old_name : the old name of the input/output
            - new_path : the new name of the input/output
            - connection : the TDBConnection object communicating with the database system
            - commit : boolean that tells if the actions done with the function is done automatically or performed later manually
        }
        var
            io:TDBObject;
            index:Integer;

        begin
            io := ioManager.get('component = ''' + analysis_type + ''' AND name = '''+ old_name + '''');
            index := io.fields.IndexOf('name');
            io.VString[index] := new_name;
            io.save(False);
            if commit then DBCONNECTION.connection.commit;
            io.Free;
        end;

    procedure proTDBUnic_ExplainInputOutput(analysis_type,name,usecase:String;commit:Boolean;var pu:typeUO);{tested}
        {Explains the analysis type input/output :

            - analysis_type : the name of the analysis type
            - name : the name of the input/output
            - usecase : the explanation of the input/output, what does it supposed to be
            - connection : the TDBConnection object communicating with the database system
            - commit : boolean that tells if the actions done with the function is done automatically or performed later manually
        }
        var
            io:TDBObject;
            index:Integer;

        begin
            io := ioManager.get('component = ''' + analysis_type + ''' AND name = '''+ name + '''');
            index := io.fields.IndexOf('usecase');
            io.VString[index] := usecase;
            io.save(False);
            if commit then DBCONNECTION.connection.commit;
            io.Free;
        end;

    procedure proTDBUnic_RemoveInputOutput(analysis_type,name:String;commit:Boolean;var pu:typeUO);{tested}
        {Removes an Input/Output and all of its computed value relative to an Analysis Type

            - analysis_type : the name of the analysis type
            - name : the name of the Input/Output
            - connection : the TDBConnection object communicating with the database system
            - commit : boolean that tells if the actions done with the function is done automatically or performed later manually
        }
        var
            delegateManager1,delegateManager2:TDBManager;
            pin,potential,subpotential,inout:TDBObject;
            coding,pintype:String;
            potentials:TDBQuerySet;
            i,pin_id,potential_id:Integer;

        begin
            pin := ioManager.get('name = ''' + name + ''' AND component = ''' + analysis_type + '''');
            pin_id := pin.value['id'].VInteger;
            coding := pin.value['codingtype'].VString;
            pintype := pin.value['pintype'].VString;
            if coding = 'bool' then delegateManager1:=subpotManager_bool;
            if coding = 'int' then delegateManager1:=subpotManager_int;
            if coding = 'float' then delegateManager1:=subpotManager_float;
            if (coding = 'str') or (coding = 'file') then delegateManager1:=subpotManager_str;
            if (pintype = 'Input') or (pintype = 'Output') then delegateManager2 := inputManager;
            if (pintype = 'Output') then delegateManager2 := outputManager;
            potentials := potManager.filter('pin = ' + IntToStr(pin_id),'id');
            for i := 1 to potentials.count do
                begin
                    potential_id := potentials.objects[i-1].value['id'].VInteger;
                    subpotential := delegateManager1.get('potential_ptr_id = ' + IntToStr(potential_id));
                    subpotential.remove(False);
                    inout := delegateManager2.get('potential_id = ' + IntToStr(potential_id));
                    inout.remove(False);
                    subpotential.Free;
                    inout.Free;
                end;
            potentials.remove(False);
            pin.remove(False);
            if commit then DBCONNECTION.connection.commit;
            potentials.Free;
            pin.Free;
        end;

    procedure proTDBUnic_StoreAnalysis(var analysis_object:TDBObject;commit:Boolean;var pu:typeUO);
        {Stores a complete analysis :

            - analysis_object : the TDBObject that capture all analysis parameters, it must contain these fields :

                + id : the identification string of the new analysis
                + analysis_type : the name of the analysis type relative to the new analysis
                + if in1 ... inN and out1 ... outM corresponding to names of inputs/outputs of the analysis type,
                  the TDBObject must contain fields that have got the names

                you can add a field named 'comments' to add comments concerning the new analysis

            - connection : the TDBConnection object communicating with the database system
            - commit : boolean that tells if the actions done with the function is done automatically or performed later manually
        }
        begin
            anManager.insert(analysis_object,False);
            if commit then DBCONNECTION.connection.commit;
        end;

    procedure proTDBUnic_RemoveAnalysis(id:String;commit:Boolean;var pu:typeUO);{tested}
        {Removes a complete analysis :

            - id : the name of the analysis
            - connection : the TDBConnection object communicating with the database system
            - commit : boolean that tells if the actions done with the function is done automatically or performed later manually
        }
        var
            {anModel,ioModel,potModel,subpotModel_int,subpotModel_float,subpotModel_bool,subpotModel_str,inputModel,outputModel:TDBModel;}
            delegateManager1,delegateManager2{,anManager,ioManager,potManager,subpotManager_int,subpotManager_float,subpotManager_bool,subpotManager_str,inputManager,outputManager}:TDBManager;
            an,pin,potential,subpotential:TDBObject;
            coding:String;
            ios:TDBQuerySet;
            i,j:Integer;

        begin
            an := anManager.get('id = ''' + id + '''');
            for i:=1 to 2 do
                begin
                    if i = 1 then delegateManager1 := inputManager else delegateManager1 := outputManager;
                    ios := delegateManager1.filter('analysis_id = ''' + id + '''','id');
                    for j:=1 to ios.count do
                        begin
                            potential := potManager.get('id =' + IntToStr(ios.objects[j-1].value['potential_id'].Vinteger));
                            pin := ioManager.get('id = ' + IntToStr(potential.value['pin'].VInteger));
                            coding := pin.value['codingtype'].VString;
                            if coding = 'bool' then delegateManager2:=subpotManager_bool;
                            if coding = 'int' then delegateManager2:=subpotManager_int;
                            if coding = 'float' then delegateManager2:=subpotManager_float;
                            if (coding = 'str') or (coding = 'file') then delegateManager2:=subpotManager_str;
                            subpotential := delegateManager2.get('potential_ptr_id = ' + IntToStr(potential.value['id'].Vinteger));
                            subpotential.remove(False);
                            ios.objects[j-1].remove(False);
                            subpotential.Free;
                            potential.remove(False);
                            pin.Free;
                            potential.Free;
                        end;
                    ios.Free;
                end;
            an.remove(False);
            if commit then DBCONNECTION.connection.commit;
            an.Free;
        end;

    procedure proTDBUnic_RemoveAnalysisType(id:String;commit:Boolean;var pu:typeUO);{tested without dependent ios or analyses}
        {Removes a complete analysis type and all of dependeing inputs/outputs/analyses :

            - id : the name of the analysis type
            - connection : the TDBConnection object communicating with the database system
            - commit : boolean that tells if the actions done with the function is done automatically or performed later manually
        }
        var
            {anTypeModel,anModel,ioModel,potModel,subpotModel_bool,subpotModel_int,subpotModel_float,subpotModel_str,inputModel,outputModel:TDBModel;}
            delegateManager1,delegateManager2{,anTypeManager,anManager,ioManager,potManager,subpotManager_bool,subpotManager_int,subpotManager_float,subpotManager_str,inputManager,outputManager}:TDBManager;
            pins,analyses,ios:TDBQuerySet;
            analysis,component,potential,subpotential,pin:TDBObject;
            i,j,k:Integer;
            coding:String;
            
        begin
            analyses := anManager.filter('component = ''' + id + '''', 'id');
            for i := 1 to analyses.count do
                begin
                    analysis := analyses.objects[i-1];
                    for j:=1 to 2 do
                        begin
                            if j = 1 then delegateManager1 := inputManager else delegateManager1 := outputManager;
                            ios := delegateManager1.filter('analysis_id = ''' + analyses.objects[i-1].value['id'].VString + '''','id');
                            for k:=1 to ios.count do
                                begin
                                    potential := potManager.get('id =' + IntToStr(ios.objects[k-1].value['potential_id'].Vinteger));
                                    pin := ioManager.get('id = ' + IntToStr(potential.value['pin'].VInteger));
                                    coding := pin.value['codingtype'].VString;
                                    if coding = 'bool' then delegateManager2:=subpotManager_bool;
                                    if coding = 'int' then delegateManager2:=subpotManager_int;
                                    if coding = 'float' then delegateManager2:=subpotManager_float;
                                    if (coding = 'str') or (coding = 'file') then delegateManager2:=subpotManager_str;
                                    subpotential := delegateManager2.get('potential_ptr_id = ' + IntToStr(potential.value['id'].Vinteger));
                                    subpotential.remove(False);
                                    ios.objects[k-1].remove(False);
                                    potential.remove(False);
                                    subpotential.Free;
                                    pin.Free;
                                    potential.Free;
                                end; 
                            ios.Free;
                        end;
                    analysis.remove(False);

                    {proRemoveAnalysis(analysis.value['id'].VString,connection,False);}
               end;
            component := anTypeManager.get('id = ''' + id + '''');
            component.remove(False);
            pins := ioManager.filter('component = '''+ component.value['id'].VString + '''','id');
            if pins.count > 0 then pins.remove(False);
            if commit then DBCONNECTION.connection.Commit;
            pins.Free;
            analyses.Free;
            component.Free;
        end;

    procedure proTDBUnic_GetAnalyses(analysis_type,condition,order:String;var resultset:TDBResultSet;var pu:typeUO);
        var
            query:String;
            statement:IZStatement;

        begin
            if not assigned(resultset) then createPgObject('',typeUO(resultset),TDBresultset) else resultset.resultSet.Close;
            query := constructAnalysisQuery(analysis_type,condition,order);
            if query = '' then query := 'SELECT * FROM analysis_analysis WHERE component = ''' + analysis_type + '''';
            statement := DBCONNECTION.connection.createStatement;
            try
                resultset.ResultSet:=nil;
                resultset.resultSet := statement.ExecuteQuery(query);
                resultset.initParams;
                if resultset.rowCount > 0 then resultset.invalidate;
            finally
                resultset.IsOpen:=assigned(resultset.resultSet);
            end;
        end;

    procedure proTDBUnic_GetStatistics(var resultset:TDBResultSet;var pu:typeUO);pascal;
        var
            query:String;
            statement:IZStatement;

        begin
            if not assigned(resultset) then createPgObject('',typeUO(resultset),TDBresultset) else resultset.resultSet.Close;
            query := constructStatistics;
            statement := DBCONNECTION.connection.createStatement;
            try
                resultset.ResultSet:=nil;
                resultset.resultSet := statement.ExecuteQuery(query);
                resultset.initParams;
                if resultset.rowCount > 0 then resultset.invalidate;
            finally
                resultset.IsOpen:=assigned(resultset.resultSet);
            end;
        end;

    procedure proTDBUnic_GetAnalysesAsObjects(analysis_type,condition,order:String;var queryset:TDBQuerySet;var pu:typeUO);
        var
            query:String;

        begin
            query := constructAnalysisQuery(analysis_type,condition,order);
            if query <> '' then
                begin
                    if not assigned(queryset) then createPgObject('',typeUO(queryset),TDBQuerySet);
                    queryset.initQuerySet(anModel);
                    queryset.finalizeQuerySet(query);
                end;
        end;

initialization
    registerObject(TDBUnic,sys);
end.
 