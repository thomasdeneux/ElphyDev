unit DBQueryBuilder;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
    uses
        SysUtils,
        Classes,
        stmObj,
        DBObjects,
        DBModels;

    type
        TArrayString = array of AnsiString;
        TArrayModel = array of TDBModel;
        TQueryBuilder = class(TObject)
        private
            _fields,_join,_where,_order,_update:AnsiString;
            _model:TDBModel;
            _relative,_isSet:Boolean;
            function replaceString(st:AnsiString;data:TStringList):AnsiString;
            procedure setFields(fields:TStringList);
            function joinArray(items:TStringList;adapt:Boolean=False;decorator:AnsiString='';separator:AnsiString=', '):AnsiString;
            procedure setJoin(tables:TStringList);
            function makeString(arg:TVarRec;adapt:Boolean=False):AnsiString;
            function makeTVarRec(arg:TVarRec;adapt:Boolean=False):TVarRec;


        public
            constructor Create(model:TDBModel;relative:Boolean=False);overload;
            property where:AnsiString read _where write _where;
            property order:AnsiString read _order write _order;
            property join:AnsiString read _join write _join;
            procedure setOrder(order:TStringList);
            procedure resetParameters;
            function splitString(st:AnsiString;separator:AnsiString=','):TStringList;
            function getNaturalJoin:AnsiString;
            function select:AnsiString;
            function insert(item:TDBObject):AnsiString;
            function update(item:TDBObject):AnsiString;
            function del:AnsiString;
            {function analyses:AnsiString;}
        end;

implementation
    constructor TQueryBuilder.Create(model:TDBModel;relative:Boolean=False);
        var
            i:Integer;

        begin
            inherited Create;
            _model := model;
            _relative := relative;
            _isSet := False;
            if _model.nfields > 0 then setFields(model.fields);
        end;

    procedure TQueryBuilder.resetParameters;
        begin
            _join := '';
            _where := '';
            _order := '';
        end;

    procedure TQueryBuilder.setFields(fields:TStringList);
        var
            i:Integer;
            st_up,decorator:AnsiString;

        begin
            st_up := '';
            for i:= 1 to fields.Count do
                begin
                    st_up := st_up + fields[i-1] + ' = %s ';
                    if (i <> fields.Count) then st_up := st_up + ', ';
                end;
            if not _relative then decorator := _model.application_table + '.%s' else decorator := '';
            _fields := joinArray(fields, False, decorator);
            _update := st_up;
            _isSet := True;
        end;

    function TQueryBuilder.joinArray(items:TStringList;adapt:Boolean=False;decorator:AnsiString='';separator:AnsiString=', '):AnsiString;
        var
            i:Integer;
            st,decorated,tmp:AnsiString;
            field,field_type:AnsiString;

        begin
            st := '';
            for i:=1 to items.Count do
                begin
                    field := items.Names[i-1];
                    if field = '' then tmp := items[i-1] else tmp:=items.Values[field];
                    if adapt and (field<>'') then
                        begin
                            field_type := _model.types.Values[field];
                            if (Pos('text',_model.types.Values[field]) > 0) or (Pos('char',_model.types.Values[field]) > 0) or (Pos('date',_model.types.Values[field]) > 0) or (Pos('time',_model.types.Values[field]) > 0)
                                then tmp := '''' + tmp + '''';
                        end;
                    if decorator <> '' then
                        begin
                            decorated := StringReplace(decorator, '%s', tmp, [rfReplaceAll]);
                            st := st + decorated;
                        end
                    else st := st + tmp;
                    if (i <> items.Count) then st := st + separator;
                end;
            Result := st;
        end;

    function TQueryBuilder.makeString(arg:TVarRec;adapt:Boolean=False):AnsiString;
        const
            bool_chars: array[Boolean] of AnsiString = ('False', 'True');

        begin
            with arg do
                begin
                    case VType of
                        vtInteger: Result := IntToStr(VInteger);
                        vtBoolean: Result := bool_chars[VBoolean];
                        vtChar: if adapt = False then Result := VChar else Result := '''' + VChar + '''';
                        vtExtended: Result := FloatToStr(VExtended^);
                        vtString: if adapt = False then Result := VString^ else Result := '''' + VString^ + '''';
                        vtPChar: if adapt = False then Result := VPChar else Result := '''' + VPChar + '''';
                        vtObject: if adapt = False then Result := VObject.ClassName else Result := '''' + VObject.ClassName + '''';
                        vtClass: if adapt = False then Result := VClass.ClassName else Result := '''' + VClass.ClassName + '''';
                        vtAnsiString: if adapt = False then Result := AnsiString(VAnsiString) else Result := '''' + AnsiString(VAnsiString) + '''';
                        vtCurrency: Result := CurrToStr(VCurrency^);
                        vtVariant: Result := AnsiString(VVariant^);
                        vtInt64: Result := IntToStr(VInt64^);
                    end;
                end;
        end;

    function TQueryBuilder.splitString(st:AnsiString;separator:AnsiString=','):TStringList;
        var
            new_index, last_index, len : Integer;
            substr_left, substr_right:AnsiString;
            items:TStringList;

        begin
            items := TStringList.create;
            substr_right := StringReplace(st, ' ', '', [rfReplaceAll]);
            separator := StringReplace(separator, ' ', '', [rfReplaceAll]);
            last_index := 0;
            new_index := Pos(separator,substr_right);
            while new_index > 0 do
                begin
                    substr_left := Copy(substr_right,last_index, new_index);
                    substr_left := StringReplace(substr_left, separator, '', [rfReplaceAll]);
                    if Length(substr_left) > 0 then items.Add(substr_left);
                    substr_right := Copy(substr_right,new_index,Length(st)-Length(substr_left));
                    substr_right := StringReplace(substr_right, separator, '', []);
                    new_index := Pos(separator,substr_right);
                end;
            if Length(substr_right) > 0 then items.Add(substr_right);
            Result := items;
        end;

    function TQueryBuilder.makeTVarRec(arg:TVarRec;adapt:Boolean=False):TVarRec;
        var
            st:AnsiString;

        begin
            st := makeString(arg, adapt);
            with Result do
                begin
                    VType := vtString;
                    VString := Pointer(st);
                end;
        end;

    procedure TQueryBuilder.setJoin(tables:TStringList);
        var
            decorator:AnsiString;
            splitstr:AnsiString;

        begin
            if _model.application <> '' then decorator := '_%s as %s' else decorator:='';
            _join := joinArray(tables, False, decorator);
        end;

    procedure TQueryBuilder.setOrder(order:TStringList);
        begin
            _order := joinArray(order);
        end;

    function TQueryBuilder.replaceString(st:AnsiString;data:TStringList):AnsiString;
        begin

        end;

    function TQueryBuilder.getNaturalJoin:AnsiString;
        var
           tmparray:TArrayString;
           tables:TStringList;
           models:TArrayModel;
           i,imod,j,jmod,k,m,modulo:Integer;
           st,pkey,fkey,decorator:AnsiString;
           pk,tb:Boolean;

        begin
           st := '';
           tables := splitString(_join,',');
           SetLength(models,tables.Count+1);
           models[0] := _model;
           for i := 1 to tables.count do
               models[i] := TDBModel.Create(tables[i-1]);
           modulo := Length(models);
           for i:=1 to modulo do
               for j:=i to (i+modulo-2) do
                   for k:=1 to models[i-1].pkeys.Count do
                       begin
                           jmod := (j mod modulo);
                           for m:=1 to models[jmod].fkeys.Count do
                               begin
                                   if st = '' then decorator := '' else decorator := ' AND ';
                                   pk := (models[jmod].references.Values[models[jmod].fkeys[m-1]] = models[i-1].pkeys[k-1]);
                                   tb := (models[jmod].lookups.Values[models[jmod].fkeys[m-1]] = models[i-1].application_table);
                                   if pk and tb then
                                       st := st + decorator + models[i-1].application_table + '.' + models[i-1].pkeys[k-1] + ' = ' + models[jmod].application_table + '.' + models[jmod].fkeys[m-1];
                               end;
                       end;
           Result := st;
        end;

    function TQueryBuilder.select:AnsiString;
        var
            natural_join,searched_in,joined,ordered:AnsiString;

        begin
            if not _isSet then setFields(_model.fields);

            if _join <> '' then
                begin
                    joined := ', ' + _join;
                    natural_join := getNaturalJoin;
                end
            else
                begin
                    joined := '';
                    natural_join := '';
                end;
            if ((natural_join = '') and (_where = '')) then searched_in := '';
            if ((natural_join = '') and (_where <> '')) then searched_in := ' WHERE ' + _where;
            if ((natural_join <> '') and (_where = '')) then searched_in := ' WHERE ' + natural_join;
            if ((natural_join <> '') and (_where <> '')) then searched_in := ' WHERE ' + _where + ' AND ' + natural_join;
            if _order <> '' then ordered := Format(' ORDER BY %s', [_order]) else ordered := '';
            Result := Format('SELECT %s FROM %s%s%s%s', [_fields, _model.application_table, joined, searched_in, ordered]);
        end;

    function TQueryBuilder.insert(item:TDBObject):AnsiString;
        var
           fields,val,values,field : AnsiString;
           fds,items:TStringList;
           i:Integer;
           test:Boolean;

        begin
            if not _isSet then setFields(_model.fields);

            items := TStringList.Create;
            fds := TStringList.Create;
            for i:=1 to item.count do
                begin
                    field := item.fields[i-1];
                    val := StringReplace(item.getValue(field).getValString,'=','___***___',[rfReplaceAll]);
                    test := (item.getValue(field).rec.VType = gvNull);
                    if not test then
                        begin
                            fds.Add(field);
                            test := (item.getValue(field).rec.VType = gvString) or (item.getValue(field).rec.VType = gvDateTime);
                            if test then items.Add('''' + StringReplace(val,'''','''''',[rfReplaceAll]) + '''') else items.Add(val);
                        end;
                end;       
            fields := joinArray(fds);
            values := StringReplace(joinArray(items),'___***___', '=',[rfReplaceAll]);
            fds.Free;
            items.Free;
            Result := Format('INSERT INTO %s (%s) VALUES (%s) RETURNING *', [_model.application_table, fields, values]);
        end;

    function TQueryBuilder.update(item:TDBObject):AnsiString;
        var
           i:Integer;
           values:TStringList;
           field,val,new_values,decorator,searched_in, joined : AnsiString;
           items:TStringList;
           test:Boolean;

        begin
            if not _isSet then setFields(_model.fields);

            new_values := '';
            values := TStringList.Create;
            for i:=1 to item.count do
                begin
                    field := item.fields[i-1];
                    val := item.getValue(field).getValString;
                    test := (item.getValue(field).rec.VType = gvNull);
                    if not test then
                        begin
                            if new_values = '' then decorator := '' else decorator := ', ';
                            test := (item.getValue(field).rec.VType = gvString) or (item.getValue(field).rec.VType = gvDateTime);
                            if test then values.Add('''' + StringReplace(val,'''','''''',[rfReplaceAll]) + '''') else values.Add(val);
                            new_values := new_values + decorator + field + ' = ' + values[values.count-1];
                        end;
                end;
            if _where <> '' then searched_in := Format(' WHERE %s', [_where]) else searched_in := '';
            if _join <> '' then joined := Format(' FROM %s', [_join]) else joined := '';
            Result := Format('UPDATE %s SET %s%s%s RETURNING *', [_model.application_table, new_values, joined, searched_in]);
            values.Free;
        end;

    function TQueryBuilder.del:AnsiString;
        begin
            if not _isSet then setFields(_model.fields);
            if _where <> '' then Result := Format('DELETE FROM %s WHERE %s RETURNING *', [_model.application_table, _where])
            else Result := Format('DELETE FROM %s RETURNING *', [_model.application_table]);
        end;
    {
    function TQueryBuilder.analyses:AnsiString;
        var
            ioModel:TDBModel;
            ioManager:TDBManager;
            pins:TDBQuerySet;
            pin:TDBObject;
            i:Integer;
            coding,cls,pintype,select,from,where,join,query:AnsiString;
        
        
        begin
            select := 'SELECT an.id,an.comments,';
            from := ' FROM analysis_analysis as an,';
            where := ' WHERE an.component = ''' + selectedAnType + ''' AND ';
            ioModel.create('analysis_pin',connection);
            ioManager.create(ioModel);
            pins.create;
            pin.create;
            ioManager.filter('component = ''' + selectedAnType + '''','id',pins);
            for i:=1 to pins.countObjects do
                begin
                    pins.getObject(i-1,pin);

                    coding := pin.codingtype;
                    if coding = 'bool' then cls:='boolean';
                    if coding = 'int' then cls:='integer';
                    if coding = 'float' then cls:='float';
                    if coding = 'str' then cls:='string';
                    if coding = 'file' then cls:='string';
                    select := select + '"' + pin.name + '"' + '.value as "' + pin.name + '"';
                    pintype := pin.pintype;
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
                            ' AND   pin.name = ''' + pin.name + ''')' + ' as "' + pin.name + '"';

                    where := where + '"' + pin.name + '"' + '.id = an.id';

                    from := from + join;
                    if i < pins.countObjects then
                        begin
                            select := select + ',';
                            from := from + ',';
                            where := where + ' AND ';
                        end;
                end;
            query := select + from + where + ' ORDER BY "' + orderAn + '"';
            constructAnalysisQuery := query;
        end;
        }

end.
 
