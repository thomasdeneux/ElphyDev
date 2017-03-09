unit stmVecMatLab;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,
     util1,Dgraphic,dtf0,
     stmdef,stmObj,stmDplot,stmDobj1,stmVec1,stmMat1,stmKLmat,
     matlab0,matlab_matrix,matlab_mat,
     NcDef2,stmPg;



procedure ProOpenMatLab(visible:boolean);pascal;
procedure proMatlabEvalString(st:AnsiString);pascal;

procedure proSaveToMatLab(var x;Xsize:integer;tp:word;name:AnsiString);pascal;
procedure proLoadFromMatLab(var x;Xsize:integer;tpx:word;name:AnsiString);pascal;


procedure proTdataObject_SaveToMatLab(Objname:AnsiString;var pu:typeUO);pascal;
procedure proTdataObject_LoadFromMatLab(Objname:AnsiString;var pu:typeUO);pascal;
procedure proTdataObject_LoadFromMatLab_1(Objname:AnsiString;InvertIndices:boolean;var pu:typeUO);pascal;


procedure SaveDataObjToMatFile(obj:TdataObj;stF,objName:AnsiString;const tpDest0:typetypeG=G_none;const Fappend:boolean=false);
procedure proTdataPlot_SaveToMatFile(stFile,objName:AnsiString;var pu:typeUO);pascal;
procedure proTdataPlot_SaveToMatFile_1(stFile,objName:AnsiString;tpDest:integer;var pu:typeUO);pascal;
procedure proTdataPlot_SaveToMatFile_2(stFile,objName:AnsiString;tpDest:integer;Fappend:boolean;var pu:typeUO);pascal;

procedure proTdataPlot_LoadFromMatFile(stFile,objName:AnsiString;var pu:typeUO);pascal;
procedure proTdataPlot_LoadFromMatFile_1(stFile,objName:AnsiString;InvertIndices:boolean;var pu:typeUO);pascal;

procedure saveMxArrayToMatFile(mxArray:MxArrayPtr;stF,objName:AnsiString;Fappend:boolean);

implementation


procedure testMatlab;
begin
  if not initMatlab then sortieErreur('MATLAB not initialized');
end;

procedure ProOpenMatLab(visible:boolean);
begin
  testMatLab;
  engSetVisible(engine,visible);
end;


{Evaluation dans Matlab}
procedure proMatlabEvalString(st:AnsiString);
var
  res:integer;
begin
  testMatlab;
  st:=st+#0;
  res:=engEvalString(engine,@st[1]);
  if res<>0 then sortieErreur('MatlabEvalString error');
end;


{Envoi d'une variable dans Matlab}
procedure proSaveToMatLab(var x;Xsize:integer;tp:word;name:AnsiString);
var
  complexity:mxComplexity;
  classID:mxClassID;
  mxArray:MxArrayPtr;
  st:AnsiString;
  t:pointer;
  w,wi:double;
begin
  testMatlab;

  if Xsize<>tailleNombre[typeNombre(tp)]
    then sortieErreur('SaveToMatlab : simple variable expected');

  case typeNombre(tp) of
    nbbyte:     w:=byte(x);
    nbshort:    w:=short(x);
    nbsmall:    w:=smallInt(x);
    nbword:     w:=word(x);
    nblong:     w:=longint(x);

    nbsingle:   w:=single(x);
    nbdouble:   w:=double(x);
    nbextended: w:=extended(x);
    nbsinglecomp:     w:=TsingleComp(x).x;
    nbdoublecomp:     w:=TdoubleComp(x).x;
    nbExtcomp:        w:=TfloatComp(x).x;

    else w:=0;
  end;

  case typeNombre(tp) of
    nbsinglecomp:     wi:=TsingleComp(x).y;
    nbdoublecomp:     wi:=TdoubleComp(x).y;
    nbExtcomp:        wi:=TfloatComp(x).y;
    else              wi:=0;
  end;


  TRY
    classID:= mxDouble_class;

    if typeNombre(tp)<nbsingleComp
      then complexity:=mxReal
      else complexity:=mxComplex;

    mxArray:=mxCreateNumericMatrix(1,1,classID,complexity);
    if mxArray=nil then sortieErreur('SaveToMatLab : internal error 1');
    t:= mxGetPr(mxArray);
    if t=nil then sortieErreur('SaveToMatLab : internal error 2');

    PDouble(t)^:=w;

    t:= mxGetPi(mxArray);
    if (complexity=mxComplex) and assigned(t) then
        PDouble(t)^:=wi;

    st:=name+#0;
    engPutVariable(engine,@st[1],mxArray);

  FINALLY
    mxDestroyArray(mxArray);
  END;
end;

{Récupération d'une variable Matlab}
procedure proLoadFromMatLab(var x;Xsize:integer;tpx:word;name:AnsiString);
var
  classID:mxClassID;
  mxArray:MxArrayPtr;
  st:AnsiString;
  t:pointer;
  w,wi:double;
begin
  testMatlab;

  if name='' then sortieErreur('Tvector.LoadFromMatLab : invalid variable name');

  st:=name+#0;
  mxArray:=engGetVariable(engine,@st[1]);
  if not assigned(mxArray)
    then sortieErreur('Tvector.LoadFromMatLab : unable to load variable '+name);

  classID:=mxGetClassID(mxArray);

  t:= mxGetPr(mxArray);

  case classID of
    mxInt16_class:  w:=Psmallint(t)^;
    mxInt32_class:  w:=PLongint(t)^;
    mxsingle_class: w:=PSingle(t)^;
    mxDouble_class: w:=PDouble(t)^;
  end;

  t:= mxGetPi(mxArray);
  if (t<>nil) then
  case classID of
    mxsingle_class: wi:=PSingle(t)^;
    mxDouble_class: wi:=PDouble(t)^;
  end;

  if assigned (mxArray) then mxDestroyArray(mxArray);

  case typeNombre(tpx) of
    nbbyte:     byte(x):=round(w);
    nbshort:    short(x):=round(w);
    nbsmall:    smallInt(x):=round(w);
    nbword:     word(x):=round(w);
    nblong:     longint(x):=round(w);

    nbsingle:   single(x):=w;
    nbdouble:   double(x):=w;
    nbextended: extended(x):=w;
    nbsinglecomp:     TsingleComp(x).x:=w;
    nbdoublecomp:     TdoubleComp(x).x:=w;
    nbExtcomp:        TfloatComp(x).x:=w;

  end;

  case typeNombre(tpx) of
    nbsinglecomp:     TsingleComp(x).y:=wi;
    nbdoublecomp:     TdoubleComp(x).y:=wi;
    nbExtcomp:        TfloatComp(x).y:=wi;
  end;


end;



{Envoi d'un TdataObject dans Matlab}
procedure proTdataObject_SaveToMatLab(Objname:AnsiString;var pu:typeUO);
var
  mxArray:MxArrayPtr;
  st:AnsiString;
begin
  verifierObjet(pu);
  if Objname='' then sortieErreur('TdataObject.SaveToMatLab : Name is empty');

  testMatlab;

  TRY
  mxArray:= TdataPlot(pu).getMxArray;
  if not assigned(mxArray) then sortieErreur('TdataObject.SaveToMatLab : unable to create a Matlab structure');

  st:=Objname+#0;
  if engPutVariable(engine,@st[1],mxArray)<>0
    then sortieErreur('Tvector.SaveToMatLab : unable to send variable '+Objname);;

  FINALLY
    mxDestroyArray(mxArray);
  END;
end;

{Récupération d'un TdataObject à partir de Matlab}
procedure proTdataObject_LoadFromMatLab_1(Objname:AnsiString;InvertIndices:boolean;var pu:typeUO);
var
  mxArray:MxArrayPtr;
  st:AnsiString;
begin
  verifierObjet(pu);
  if Objname='' then sortieErreur('TdataObject.LoadFromMatLab : Name is empty');

  testMatlab;

  st:=Objname+#0;
  mxArray:=engGetVariable(engine,@st[1]);
  if not assigned(mxArray)
    then sortieErreur('TdataObject.LoadFromMatLab : unable to load variable '+Objname);

  try
  TdataObj(pu).setMxArray(mxArray,InvertIndices);
  finally
  if assigned (mxArray) then mxDestroyArray(mxArray);
  end;
end;

procedure proTdataObject_LoadFromMatLab(Objname:AnsiString;var pu:typeUO);
begin
  proTdataObject_LoadFromMatLab_1(Objname,false, pu);
end;

{**********************************  Gestion des fichiers mat-files **************************}



{Sauve le mxArray dans un fichier .mat
 Puis détruit le mxArray
}

procedure saveMxArrayToMatFile(mxArray:MxArrayPtr;stF,objName:AnsiString;Fappend:boolean);
var
  pmf:Tpmf;
  res:integer;
begin
  if not assigned(mxArray) then exit;

  if stF='' then sortieErreur('Tobject.SaveToMatFile : File name is empty');
  if objName='' then sortieErreur('Tobject.SaveToMatFile : objName is empty');

  testMatlabMat;
  testMatlabMatrix;


  TRY
    stF:=stF+#0;
    if Fappend
      then pmf:=matOpen(@stF[1],'u')
      else pmf:=matOpen(@stF[1],'w');

    if not assigned(pmf) then sortieErreur('Tobject.SaveToMatFile : unable to open file');

    objName:=objName+#0;
    res:=matPutVariable(pmf,@objName[1],mxArray);
    if res<>0 then sortieErreur('Tobject.SaveToMatFile : unable to write variable');
    matClose(pmf);

  FINALLY
    mxDestroyArray(mxArray);
  END;
end;

{sauvegarde d'un TdataObj dans un fichier .mat}
procedure SaveDataObjToMatFile(obj:TdataObj;stF,objName:AnsiString;const tpDest0:typetypeG=G_none;const Fappend:boolean=false);
begin
  saveMxArrayToMatFile(obj.getMxArray(tpDest0),stF,objName,Fappend);
end;


procedure proTdataPlot_SaveToMatFile(stFile,objName:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);

  SaveDataObjToMatFile(TdataObj(pu),stFile,objName);
end;

procedure proTdataPlot_SaveToMatFile_1(stFile,objName:AnsiString;tpDest:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  SaveDataObjToMatFile(TdataObj(pu),stFile,objName,typetypeG(tpDest));
end;

procedure proTdataPlot_SaveToMatFile_2(stFile,objName:AnsiString;tpDest:integer;Fappend:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  SaveDataObjToMatFile(TdataObj(pu),stFile,objName,typetypeG(tpDest),Fappend);
end;

{Chargement d'un TdataObj à partir d'un fichier .mat}

function LoadMxArrayFromMatFile(stF,objName:AnsiString):MxArrayPtr;
var
  pmf:Tpmf;
  res:integer;
begin
  result:=nil;

  if stF='' then sortieErreur('Tobject.LoadFromMatFile : File name is empty');
  if objName='' then sortieErreur('Tobject.LoadFromMatFile : objName is empty');

  testMatlabMat;
  testMatlabMatrix;

  stF:=stF+#0;
  pmf:=matOpen(@stF[1],'r');

  if not assigned(pmf) then sortieErreur('Tobject.LoadFromMatFile : unable to open file');

  objName:=objName+#0;
  result:=matGetVariable(pmf,@objName[1]);
  if result=nil then sortieErreur('Tobject.LoadFromMatFile : unable to read variable');
  matClose(pmf);
end;


procedure LoadDataPlotFromMatFile(obj:TdataPlot;stF,objName:AnsiString;invertIndices:boolean);
var
  mxArray:MxArrayPtr;
begin
  try
  mxArray:=LoadMxArrayFromMatFile(stF,objName);
  obj.setMxArray(mxArray,invertIndices);
  finally
  mxDestroyArray(mxArray);
  end;
end;

procedure proTdataPlot_LoadFromMatFile_1(stFile,objName:AnsiString;InvertIndices:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  LoadDataPlotFromMatFile(TdataObj(pu),stFile,objName,invertIndices);
end;

procedure proTdataPlot_LoadFromMatFile(stFile,objName:AnsiString;var pu:typeUO);
begin
  proTdataPlot_LoadFromMatFile_1(stFile,objName,false,pu);
end;

end.
