unit stmPython1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysUtils,
     util1,Gdos,Dgraphic,varconf1,debug0,
     stmdef,stmObj,stmData0,
     Ncdef2,stmPg,stmMemo1,stmVec1
     {$IFNDEF WIN64} ,PythonEngine {$ENDIF};


type
  TpythonEng=
    class(Tdata0)
      MemoSource,MemoOutput:TstmMemo;
      fileName:AnsiString;

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;

      procedure createForm;override;

      function GetRealVar(st:AnsiString):float;
      function GetVar(st:AnsiString): TGvariant;
      procedure GetVector(st:AnsiString;vec:Tvector);

      procedure SetVar(st:AnsiString;x: TGvariant);
      procedure SetVector(st:AnsiString;vec:Tvector);

      procedure Execute(st:Tstrings);
    end;

procedure proTPythonEng_create(var pu:typeUO);pascal;
function fonctionTPythonEng_source(var pu:typeUO):pointer;pascal;
function fonctionTPythonEng_output(var pu:typeUO):pointer;pascal;

procedure proTPythonEng_execute(var pu:typeUO);pascal;
procedure proTPythonEng_executeString(st:AnsiString;var pu:typeUO);pascal;
procedure proTPythonEng_executeFile(stF:AnsiString;var pu:typeUO);pascal;

function fonctionTpythonEng_GetVar(st:AnsiString;var pu:typeUO):TGvariant;pascal;
procedure proTpythonEng_GetVector(st:AnsiString;var vec:Tvector;var pu:typeUO);pascal;

procedure proTpythonEng_SetVar(st: AnsiString; x: TGvariant;var pu:typeUO);pascal;
procedure proTpythonEng_SetVector(st:AnsiString;var vec:Tvector;var pu:typeUO);pascal;

implementation

{$IFNDEF WIN64}
uses stmPyForm1;
{$ENDIF}

{ TpythonEng }

constructor TpythonEng.create;
begin
  inherited;
  canDestroyForm:=false;
end;

class function TpythonEng.stmClassName: AnsiString;
begin
  result:='PythonEngine';
end;


procedure TpythonEng.createForm;
begin
  {$IFNDEF WIN64}
  if not assigned(PythonForm) then  Pythonform:=TpythonForm.create(formstm);

  pythonForm.init(self);
  form:=PythonForm;
  form.Caption:=ident;

  MemoSource:=TstmMemo.create;
  MemoSource.init(TpythonForm(form).MemoSource);
  MemoSource.NotPublished:=true;

  MemoOutput:=TstmMemo.create;
  MemoOutput.init(TpythonForm(form).MemoOutput);
  MemoOutput.NotPublished:=true;
  {$ENDIF}
end;

destructor TpythonEng.destroy;
begin
  form.Hide;
  inherited;
end;

function TpythonEng.GetRealVar(st:AnsiString): float;
{$IFNDEF WIN64}
var
  pName,pModule,pVar:PPyObject;
begin
  with TpythonForm(form).PythonEngine1 do
  try
    pName := PyString_FromString('__main__');

    pModule := PyImport_Import(pName);
    Py_DECREF(pName);

    if (pModule <> Nil) then
    begin
      try
      pvar:=PyObject_GetAttrString(pModule, Pansichar(st));

      if pVar=nil then sortieErreur('Unknown Python identifier');

      if PyFloat_Check(pVar) then
      begin
        result:=PyFloat_asDouble(pVar);
        Py_DECREF(pvar);
      end
      else sortieErreur('Variable is not real');

      finally
      Py_DECREF(pModule);
      end;
    end
    else sortieErreur('Python Module not found');

  finally
    PyErr_clear;
  end;
end;
{$ELSE}
begin
end;
{$ENDIF}


{$IFNDEF WIN64}
function PyObjectAsGVariant( obj:PPyObject ):TGvariant;
begin
  result.init;
  with GetPythonEngine do
  begin
    if PyInt_Check(obj) then
      Result.Vinteger:= PyInt_AsLong(obj)
    else
    if PyLong_Check(obj) then
      Result.Vinteger:= PyLong_AsLongLong(obj)
    else
    if PyFloat_Check(obj) then
      Result.Vfloat := PyFloat_AsDouble(obj)
    else
    if PyString_Check(obj) then
      Result.Vstring := PyObjectAsString(obj)
    else
    if PyBool_Check(obj) then
      Result.Vboolean := (PyObject_IsTrue(obj) = 1)
    else Result.init;
  end;
end;


function GvariantAsPyObject(xg:TGvariant):PPyObject;
begin
  with GetPythonEngine do
  begin
    case xg.Vtype of
      gvInteger: result:=PyLong_FromLong(xg.Vinteger);
      gvFloat:   result:=PyFloat_FromDouble(xg.Vfloat);

      gvString:  result:=PyString_FromString(Pansichar(xg.Vstring));
      gvBoolean: result:=PyBool_FromLong(ord(xg.Vboolean));

      else result:=nil;
    end;
  end;
end;


function PyObjectAsFloat( obj:PPyObject ):float;
var
  st:AnsiString;
  x:float;
  code:integer;
begin
  with GetPythonEngine do
  begin
    if PyInt_Check(obj) then
      Result:= PyInt_AsLong(obj)
    else
    if PyLong_Check(obj) then
      Result:= PyLong_AsLongLong(obj)
    else
    if PyFloat_Check(obj) then
      Result:= PyFloat_AsDouble(obj)
    else
    if PyString_Check(obj) then
    begin
       st:= PyObjectAsString(obj);
       val(st,x,code);
       if code=0
         then result:=x
         else sortieErreur('Unable to convert Python object into real');
    end
    else
    if PyBool_Check(obj) then
      Result:= PyObject_IsTrue(obj)
    else sortieErreur('Unable to convert Python object into real');
  end;
end;
{$ENDIF}


function TpythonEng.GetVar(st:AnsiString): TGvariant;
{$IFNDEF WIN64}
var
  pName,pModule,pVar:PPyObject;
begin

  if st='' then sortieErreur('TpythonEng.GetVar : String is empty');

  with TpythonForm(form).PythonEngine1 do
  try
    pName := PyString_FromString('__main__');

    pModule := PyImport_Import(pName);
    Py_DECREF(pName);

    if (pModule <> Nil) then
    begin
      try
        pvar:=PyObject_GetAttrString(pModule, Pansichar(st));

        if pVar=nil then sortieErreur('Unknown Python identifier');

        try
          result:= PyObjectAsGVariant( pvar );
        finally
          Py_DECREF(pvar);
        end;

      finally
      Py_DECREF(pModule);
      end;
    end
    else sortieErreur('Python Module not found');

  finally
    PyErr_clear;
  end;
end;
{$ELSE}
begin
end;
{$ENDIF}


{$IFNDEF WIN64}
function PyObjectAsVector( obj : PPyObject;var vec:Tvector):boolean ;
  function GetSequenceItem( sequence : PPyObject; idx : Integer ) : Float;
  var
    val : PPyObject;
  begin
    with getPythonEngine do
    begin
      val := PySequence_GetItem( sequence, idx );
      try
        Result := PyObjectAsFloat( val );
      finally
        Py_XDecRef( val );
      end;
    end;
  end;

var
  i, len: Integer;
begin
  with getPythonEngine do
  begin
    if PySequence_Check( obj ) = 1 then
    begin
      len:= PySequence_Length( obj );
      // if we have at least one object in the sequence,
      if len > 0 then
        // we try to get the first one, simply to test if the sequence API
        // is really implemented.
        Py_XDecRef( PySequence_GetItem( obj, 0 ) );
      // check if the Python object did really implement the sequence API
      if PyErr_Occurred = nil then
        begin
          vec.initTemp1(0,PySequence_Length( obj )-1,vec.tpNum);

          for i := 0 to PySequence_Length( obj )-1 do
            vec.Yvalue[i] := GetSequenceItem( obj, i );
          result:=true;
        end
      else // the object didn't implement the sequence API, so we return Null
        begin
          PyErr_Clear;
          Result := false;
        end;
    end
    else Result := false;
  end;
end;

function VectorAsPyObject(vec:Tvector):PpyObject;
var
  i:integer;
begin
  with getPythonEngine do
  begin
    Result := PyList_New( vec.Icount );
    for i := vec.Istart to vec.Iend do
        PyList_SetItem( Result, i-vec.Istart, PyFloat_FromDouble(vec.Yvalue[i]) );
  end;
end;
{$ENDIF}

procedure TpythonEng.GetVector(st:AnsiString;vec:Tvector);
{$IFNDEF WIN64}
var
  pName,pModule,pVar:PPyObject;
begin
  if st='' then sortieErreur('TpythonEng.GetVector : string is empty');

  with TpythonForm(form).PythonEngine1 do
  try
    pName := PyString_FromString('__main__');

    pModule := PyImport_Import(pName);
    Py_DECREF(pName);

    if (pModule <> Nil) then
    begin
      try
        pvar:=PyObject_GetAttrString(pModule, Pansichar(st));

        if pVar=nil then sortieErreur('Unknown Python identifier');

        try
          PyObjectAsVector( pvar,vec );
        finally
          Py_DECREF(pvar);
        end;

      finally
      Py_DECREF(pModule);
      end;
    end
    else sortieErreur('Python Module not found');

  finally
    PyErr_clear;
  end;

end;
{$ELSE}
begin
end;
{$ENDIF}



procedure TpythonEng.SetVar(st: AnsiString; x: TGvariant);
{$IFNDEF WIN64}
var
  pName,pModule,pVar:PPyObject;
begin
  if st='' then sortieErreur('TpythonEng.SetVar : string is empty');

  with TpythonForm(form).PythonEngine1 do
  try
    pName := PyString_FromString('__main__');

    pModule := PyImport_Import(pName);
    Py_DECREF(pName);

    if (pModule <> Nil) then
    begin
      try
        pVar:=GvariantAsPyObject(x );

        if assigned(pVar) then
        try
          PyObject_SetAttrString(pModule, Pansichar(st) ,pVar);
        finally
          Py_DECREF(pvar);
        end

        else sortieErreur('Unable to create Python variable');

      finally
      Py_DECREF(pModule);
      end;
    end
    else sortieErreur('Python Module not found');

  finally
    PyErr_clear;
  end;

end;
{$ELSE}
begin
end;
{$ENDIF}

procedure TpythonEng.SetVector(st:AnsiString;vec:Tvector);
{$IFNDEF WIN64}
var
  pName,pModule,pVar:PPyObject;
begin
  if st='' then sortieErreur('TpythonEng.SetVector : string is empty');

  with TpythonForm(form).PythonEngine1 do
  try
    pName := PyString_FromString('__main__');

    pModule := PyImport_Import(pName);
    Py_DECREF(pName);

    if (pModule <> Nil) then
    begin
      try
        pVar:=VectorAsPyObject(vec );

        if assigned(pVar) then
        try
          PyObject_SetAttrString(pModule, Pansichar(st) ,pVar);
        finally
          Py_DECREF(pvar);
        end

        else sortieErreur('Unable to create Python variable');

      finally
      Py_DECREF(pModule);
      end;
    end
    else sortieErreur('Python Module not found');

  finally
    PyErr_clear;
  end;
end;
{$ELSE}
begin
end;
{$ENDIF}

procedure MaskFPUExceptions(ExceptionsMasked : boolean);
begin
  if ExceptionsMasked then
    Set8087CW($1332 or $3F)
  else
    Set8087CW($1332);
end;


procedure TpythonEng.Execute(st: Tstrings);
begin
{$IFNDEF WIN64}
  MaskFPUExceptions(true);
  try
    TpythonForm(form).PythonEngine1.ExecStrings( st );
  finally
    MaskFPUExceptions(false);
  end;
{$ENDIF}
end;



{********************************* Méthodes stm *******************************}

procedure proTPythonEng_create(var pu:typeUO);
begin
  createPgObject('',pu,TPythonEng);

  with TPythonEng(pu) do
  begin
    createForm;
  end;
end;

function fonctionTPythonEng_source(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TPythonEng(pu) do result:=@MemoSource;
end;

function fonctionTPythonEng_output(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TPythonEng(pu) do result:=@MemoOutput;
end;

procedure proTPythonEng_execute(var pu:typeUO);
begin
  verifierObjet(pu);

  {$IFNDEF WIN64}
  with TPythonEng(pu) do execute(TpythonForm(form).MemoSource.Lines) ;
  {$ENDIF}
end;

procedure proTPythonEng_executeString(st:AnsiString;var pu:typeUO);
var
  list:TstringList;
begin
{$IFNDEF WIN64}
  verifierObjet(pu);
  list:=TstringList.create;
  list.Text:=st;
  try
    TPythonEng(pu).Execute(list);
  finally
    list.free;
  end;
{$ENDIF}
end;

procedure proTPythonEng_executeFile(stF:AnsiString;var pu:typeUO);
var
  list:TstringList;
begin
{$IFNDEF WIN64}
  verifierObjet(pu);

  list:=TstringList.create;
  try
    chDir(extractFilePath(stF));
    list.LoadFromFile(stF);
    TPythonEng(pu).Execute(list);
  finally
    list.free;
  end;
{$ENDIF}
end;



function fonctionTpythonEng_GetVar(st:AnsiString;var pu:typeUO):TGvariant;
begin
  verifierObjet(pu);
  result:=TPythonEng(pu).GetVar(st);
end;

procedure proTpythonEng_GetVector(st:AnsiString;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  TPythonEng(pu).GetVector(st,vec);
end;

procedure proTpythonEng_SetVar(st: AnsiString; x: TGvariant;var pu:typeUO);
begin
  verifierObjet(pu);
  TPythonEng(pu).SetVar(st,x);
end;

procedure proTpythonEng_SetVector(st:AnsiString;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  TPythonEng(pu).SetVector(st,vec);
end;



end.


