unit DBManagers;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
    uses
        stmObj,
        stmPG,
        stmDataBase2,
        Ncdef2,
        DBRecord1,
        DBQueryBuilder,
        DBModels,
        DBObjects,
        DBQuerySets,
        Classes,
        SysUtils,
        ZDbcIntfs,
        debug0;
    type
        TDBManager = class(typeUO)
        private
            _model:TDBModel;
            _qset:TDBQuerySet;
            _qbuilder:TQueryBuilder;

        public
            constructor Create(model:TDBModel);
            destructor Destroy;override;
            procedure initManager(model:TDBModel);
            function get(where:AnsiString):TDBObject;
            function all(order:AnsiString):TDBQuerySet;
            function filter(where,order:AnsiString):TDBQuerySet;
            function search(join,where,order:AnsiString):TDBQuerySet;
            function insert(var item:TDBObject;commit:boolean=True;break:boolean=False):TDBObject;overload;
            property model:TDBModel read _model;
            class function stmClassName:AnsiString;override;
            procedure processMessage(id:integer;source:typeUO;p:pointer);override;

        end;

    procedure proTDBManager_Create(var model:TDBModel;var pu:typeUO);pascal;
    procedure proTDBManager_get(where:AnsiString;var dbobject:TDBObject;var pu:typeUO);pascal;
    procedure proTDBManager_all(order:AnsiString;var qset:TDBQuerySet;var pu:typeUO);pascal;
    procedure proTDBManager_filter(where,order:AnsiString;var qset:TDBQuerySet;var pu:typeUO);pascal;
    procedure proTDBManager_search(join,where,order:AnsiString;var qset:TDBQuerySet;var pu:typeUO);pascal;
    procedure proTDBManager_insert(var dbobject:TDBObject;commit:Boolean;var pu:typeUO);pascal;

implementation
    uses
        DBCache;

    constructor TDBManager.Create(model:TDBModel);
        begin
           inherited Create;
           notPublished := True;
           initManager(model);
        end;

    destructor TDBManager.Destroy;
        begin
            _qbuilder.Free;
            _qset.Free;
            derefObjet(typeUO(_model));
            inherited Destroy;
        end;

    procedure TDBManager.processMessage(id:integer;source:typeUO;p:pointer);
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

    procedure TDBManager.initManager(model:TDBModel);
        begin
            derefObjet(typeUO(_model));
            _model := model;
            refObjet(typeUO(_model));
            _qbuilder := TQueryBuilder.Create(_model);
            _qset := TDBQuerySet.Create(model);
        end;
    
    function TDBManager.get(where:AnsiString):TDBObject;
        var
            statement:IZStatement;
            resultset:IZResultSet;
            instance:TDBObject;
            query:AnsiString;

        begin
            if _model = nil then raise Exception.Create('model undefined');
            statement := _model.connection.CreateStatement;
            _qbuilder.resetParameters;
            _qbuilder.where := where;
            query := _qbuilder.select;
            resultset := statement.ExecuteQuery(query);
            if resultset.First
                then
                    begin

                        {instance := getObject(_model);
                        instance.finalizeObject(_model,resultset);}

                        instance := TDBObject.Create(_model,resultset);
                        instance.created := False;
                        Result := instance;
                        if resultset.Next then raise Exception.Create('too many objects for the get function, please find a where clause that ensure the uniqueness of the object');
                    end
                else
                    raise Exception.Create('The requested ' + _model.application_table + ' object does not exist.');
        end;

    function TDBManager.all(order:AnsiString):TDBQuerySet;
        var
            query:AnsiString;
            qset:TDBQuerySet;

        begin
            if _model = nil then raise Exception.Create('model undefined');
            _qbuilder.resetParameters;
            _qbuilder.order := order;
            query := _qbuilder.select;
            {_qset.finalizeQuerySet(query);}
            qset := TDBQuerySet.Create(query,_model);
            Result := qset;
        end;

    function TDBManager.filter(where,order:AnsiString):TDBQuerySet;
        var
            query:AnsiString;
            qset:TDBQuerySet;

        begin
            if _model = nil then raise Exception.Create('model undefined');
            _qbuilder.resetParameters;
            _qbuilder.order := order;
            _qbuilder.where := where;
            query := _qbuilder.select;
            {_qset.clear;
            _qset.finalizeQuerySet(query);}
            qset := TDBQuerySet.Create(query,_model);
            Result := qset;
        end;

    function TDBManager.search(join,where,order:AnsiString):TDBQuerySet;
        var
            query:AnsiString;
            qset:TDBQuerySet;

        begin
            if _model = nil then raise Exception.Create('model undefined');
            _qbuilder.resetParameters;
            _qbuilder.join := join;
            _qbuilder.where := where;
            _qbuilder.order := order;
            query := _qbuilder.select;
            {_qset.finalizeQuerySet(query);}
            qset := TDBQuerySet.Create(query,_model);
            Result := qset;
        end;

    function TDBManager.insert(var item:TDBObject;commit:boolean=True;break:boolean=False):TDBObject;{tested}
        var
            statement:IZStatement;
            resultset:IZResultSet;
            tmp_object,tmp_pot,tmp_io,instance,anType,analysis,io,potential,subpotential,input,output:TDBObject;
            ios:TDBQuerySet;
            query,coding,cls,condition,pinname,pintype:AnsiString;
            builder:TQueryBuilder;
            {anTypeModel,ioModel,anModel,potModel,subpotModel,inModel,outModel,boolModel,intModel,floatModel,strModel}{:TDBModel;}
            {anTypeManager,ioManager,}{anManager,}{,potManager,subpotManager,inManager,outManager,boolManager,intManager,floatManager,strManager,}delegateManager:TDBManager;
            pins:TDBQuerySet;
            i,id,index:Integer;
            test:boolean;

        begin
            if _model = nil then raise Exception.Create('model undefined (manager.insert)');
            if (_model.application_table <> 'analysis_analysis') or (break = True) then
                begin
                    statement := _model.connection.CreateStatement;
                    builder := TQueryBuilder.Create(_model,True);
                    query := builder.insert(item);
                    resultset := statement.ExecuteQuery(query);
                    resultset.First;
                    instance := TDBObject.Create(_model,resultset);
                    if commit then
                        begin
                            instance.created := True;
                            instance.existing := True;
                            _model.connection.commit;
                        end;
                    Result := instance;
                    builder.Free;
                end
            else
                begin
                    if item.fields.IndexOf('component')<0 then raise Exception.Create('please specify component field');
                    if item.fields.IndexOf('id')<0 then raise Exception.Create('please specify id field');
                    {creation instance de analysis_analysis}
                    {anModel.initModel('analysis_analysis');}
                    analysis := TDBObject.Create(anModel);
                    analysis.AddField('id',gvString);
                    analysis.VString[0] := item.getValue('id').VString;
                    if item.fields.IndexOf('comments')>=0 then
                        begin
                            analysis.AddField('comments',gvString);
                            analysis.VString[1] := item.getValue('comments').VString;
                            analysis.AddField('component',gvString);
                            analysis.VString[2] := item.getValue('component').VString;
                        end
                    else
                        begin
                            analysis.AddField('component',gvString);
                            analysis.VString[1] := item.getValue('component').VString;
                        end;
                    tmp_object := anManager.insert(analysis,False,True);
                    tmp_object.Free;
                    {init ios and io}
                    {ioModel.initModel('analysis_pin',_model.connection);}
                    {io := TDBObject(TDBRecord.Create);}
                    pins := ioManager.filter('component = ''' + item.value['component'].VString + '''','id');
                    {init potential and subpotential}
                    potential := TDBObject(TDBRecord.Create);
                    {potModel.initModel('analysis_potential',_model.connection);}
                    subpotential := TDBObject(TDBRecord.Create);
                    {
                    subpotModel_str.initModel('analysis_potential_string',_model.connection);
                    subpotModel_int.initModel('analysis_potential_integer',_model.connection);
                    subpotModel_bool.initModel('analysis_potential_boolean',_model.connection);
                    subpotModel_float.initModel('analysis_potential_float',_model.connection);
                    }
                    {init inputs}
                    {inputModel.initModel('analysis_analysis_inputs',_model.connection);}
                    input:= TDBObject(TDBRecord.Create);
                    input.AddField('analysis_id',gvString);
                    input.AddField('potential_id',gvInteger);
                    {init outputs}
                    {outputModel.initModel('analysis_analysis_outputs',_model.connection);}
                    output:= TDBObject(TDBRecord.Create);
                    output.AddField('analysis_id',gvString);
                    output.AddField('potential_id',gvInteger);
                    for i:=1 to pins.count do
                        begin
                            pinname := pins.objects[i-1].value['name'].VString;
                            index := item.fields.IndexOf(pinname);
                            if index >= 0 then
                                begin
                                    {find the right input and insert its relative potential, if it is not found the get function raise an exception}
                                    condition := 'name = ''' + item.fields[index] + ''' AND component = ''' + analysis.value['component'].Vstring + '''';
                                    io := ioManager.get(condition);
                                    id := io.value['id'].VInteger;
                                    potential.clearFields;
                                    potential.AddField('pin',gvInteger);
                                    potential.VInteger[0] := id;
                                    tmp_pot := potManager.insert(potential,False);
                                    id := tmp_pot.value['id'].VInteger;

                                    {detect the potential subclass and insert a new subpotential from the codingtype}
                                    subpotential.AddField('potential_ptr_id',gvInteger);
                                    subpotential.VInteger[0] := id;
                                    coding := io.value['codingtype'].VString;
                                    if coding = 'bool' then
                                        begin
                                            cls:='boolean';
                                            subpotential.AddField('value',gvBoolean);
                                            subpotential.VBoolean[1] := item.value[item.fields[index]].VBoolean;
                                            delegateManager := subpotManager_bool;
                                        end;
                                    if coding = 'int' then
                                        begin
                                            cls:='integer';
                                            subpotential.AddField('value',gvInteger);
                                            subpotential.VInteger[1] := item.value[item.fields[index]].VInteger;
                                            delegateManager := subpotManager_int;
                                        end;
                                    if coding = 'float' then
                                        begin
                                            cls:='float';
                                            subpotential.AddField('value',gvFloat);
                                            subpotential.VFloat[1] := item.value[item.fields[index]].VFloat;
                                            delegateManager := subpotManager_float;
                                        end;
                                    if (coding = 'str') or (coding = 'file') then
                                        begin
                                            cls:='String';
                                            subpotential.AddField('value',gvString);
                                            subpotential.VString[1] := item.value[item.fields[index]].VString;
                                            delegateManager := subpotManager_str;
                                        end;
                                    tmp_object := delegateManager.insert(subpotential,False);
                                    tmp_object.Free;
                                    {add the potential to the list of inputs}
                                    pintype := io.value['pintype'].VString;
                                    if (pintype = 'Input') or (pintype = 'Parameter') then
                                        begin
                                            input.VString[0] := analysis.value['id'].VString;
                                            input.VInteger[1] := tmp_pot.value['id'].VInteger;
                                            tmp_object := inputManager.insert(input,False);
                                        end;
                                    {add the potential to the list of outputs}
                                    if pintype = 'Output' then
                                        begin
                                            output.VString[0] := analysis.value['id'].VString;
                                            output.VInteger[1] := tmp_pot.value['id'].VInteger;
                                            tmp_object := outputManager.insert(output,False);
                                        end;
                                    tmp_object.Free;
                                    io.Free;
                                    tmp_pot.Free;
                                end;
                        end;
                        {commit all new created data};
                    if commit then
                        begin
                            _model.connection.commit;
                            analysis.created := True;
                            analysis.existing := True;
                        end;
                    input.Free;
                    output.Free;
                    subpotential.Free;
                    potential.Free;
                    pins.Free;
                    Result := analysis;
                end;


        end;

    class function TDBManager.stmClassName:AnsiString;
        begin
            result:='DBManager';
        end;

    procedure proTDBManager_Create(var model:TDBModel;var pu:typeUO);pascal;
        begin
            createPgObject('',pu,TDBManager);
            TDBManager(pu).initManager(model);
        end;

    procedure proTDBManager_get(where:AnsiString;var dbobject:TDBObject;var pu:typeUO);pascal;
        var
            statement:IZStatement;
            resultset:IZResultSet;
            query:AnsiString;

        begin
            if TDBManager(pu)._model = nil then raise Exception.Create('model undefined');
            statement := TDBManager(pu)._model.connection.CreateStatement;
            TDBManager(pu)._qbuilder.resetParameters;
            TDBManager(pu)._qbuilder.where := where;
            query := TDBManager(pu)._qbuilder.select;
            resultset := statement.ExecuteQuery(query);
            if resultset.First
                then
                    begin
                        if not assigned(dbobject) then createPgObject('',typeUO(dbobject),TDBObject);
                        dbobject.initObject;
                        dbobject.finalizeObject(TDBManager(pu)._model,resultset);
                        dbobject.created := False;
                        if resultset.Next then raise Exception.Create('too many objects for the get function, please find a where clause that ensure the uniqueness of the object');
                    end
                else
                    raise Exception.Create('The requested ' + TDBManager(pu)._model.application_table + ' object does not exist.');
        end;

        {
        var
            tmp_object:TDBObject;

        begin
            verifierObjet(pu);
            if not assigned(dbobject) then
                dbobject := TDBObject.Create;
            tmp_object := TDBManager(pu).get(where);
            dbobject.assign(tmp_object);
            dbobject.Free;
        end;
        }

    procedure proTDBManager_all(order:AnsiString;var qset:TDBQuerySet;var pu:typeUO);pascal;
        var
            query:AnsiString;

        begin
            if TDBManager(pu)._model = nil then raise Exception.Create('model undefined');
            verifierObjet(pu);
            if not assigned(qset) then
                createPgObject('',typeUO(qset),TDBQuerySet);
            qset.initQuerySet(TDBManager(pu)._model);
            TDBManager(pu)._qbuilder.resetParameters;
            TDBManager(pu)._qbuilder.order := order;
            query := TDBManager(pu)._qbuilder.select;
            qset.finalizeQuerySet(query);
        end;


        {var
            tmp_qset:TDBQuerySet;
            st:AnsiString;
            i:Integer;

        begin
            verifierObjet(pu);
            if not assigned(qset) then
                createPgObject('',typeUO(qset),TDBQuerySet);
            qset.initQuerySet;
            tmp_qset := TDBManager(pu).all(order);
            qset.assign(tmp_qset);
            tmp_qset.Free;
            i := qset.count;
            st := TDBObject(qset[0]).value['id'].VString;
            qset.count;
        end;}
        

    procedure proTDBManager_filter(where,order:AnsiString;var qset:TDBQuerySet;var pu:typeUO);pascal;
        var
            query:AnsiString;

        begin
            if TDBManager(pu)._model = nil then raise Exception.Create('model undefined');
            verifierObjet(pu);
            if not assigned(qset) then
                createPgObject('',typeUO(qset),TDBQuerySet);
            qset.initQuerySet(TDBManager(pu)._model);
            TDBManager(pu)._qbuilder.resetParameters;
            TDBManager(pu)._qbuilder.order := order;
            TDBManager(pu)._qbuilder.where := where;
            query := TDBManager(pu)._qbuilder.select;
            qset.finalizeQuerySet(query);
        end;
        {
        var
            tmp_qset:TDBQuerySet;

        begin
            verifierObjet(pu);
            if not assigned(qset) then
                qset := TDBQuerySet.Create;
            tmp_qset := TDBManager(pu).filter(where,order);
            qset.assign(tmp_qset);
            tmp_qset.Free;
        end;
        }

    procedure proTDBManager_search(join,where,order:AnsiString;var qset:TDBQuerySet;var pu:typeUO);pascal;
        var
            query:AnsiString;

        begin
            if TDBManager(pu)._model = nil then raise Exception.Create('model undefined');
            verifierObjet(pu);
            if not assigned(qset) then
                createPgObject('',typeUO(qset),TDBQuerySet);
            qset.initQuerySet(TDBManager(pu)._model);
            TDBManager(pu)._qbuilder.resetParameters;
            TDBManager(pu)._qbuilder.join := join;
            TDBManager(pu)._qbuilder.where := where;
            TDBManager(pu)._qbuilder.order := order;
            query := TDBManager(pu)._qbuilder.select;
            qset.finalizeQuerySet(query);
        end;
        {
        var
            tmp_qset:TDBQuerySet;
            model:TDBModel;

        begin
            verifierObjet(pu);
            if not assigned(qset) then
                qset := TDBQuerySet.Create;
            model := TDBManager(pu)._model;
            tmp_qset := TDBManager(pu).search(join,where,order);
            qset.assign(tmp_qset);
            tmp_qset.Free;
        end;
        }

    procedure proTDBManager_insert(var dbobject:TDBObject;commit:Boolean;var pu:typeUO);pascal;
        var
            tmp_object:TDBObject;

        begin
            if TDBManager(pu)._model = nil then raise Exception.Create('model undefined');
            verifierObjet(pu);
            if not assigned(dbobject) then
                createPgObject('',typeUO(dbobject),TDBObject);
                {dbobject := TDBObject.Create;}
            tmp_object := TDBManager(pu).insert(dbobject,commit);
            dbobject.assign(tmp_object);
            tmp_object.Free;
        end;

Initialization
AffDebug('Initialization DBManagers',0);
    registerObject(TDBManager,sys);
end.
