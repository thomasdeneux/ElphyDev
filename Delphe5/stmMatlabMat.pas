unit stmMatlabMat;

interface

uses classes, strUtils,
     util1, stmObj,stmPG,Ncdef2, stmMemo1,
     matlab_mat, matlab_matrix;


type
  TmatlabStruct =  class(typeUO)
              private
                mx0: mxArrayPtr;

                function FindStructField(name: AnsiString): MxArrayPtr;
              public
                constructor create;override;
                destructor destroy;override;

                class function STMClassName:AnsiString;override;
                procedure Put( st:AnsiString;var value: TGvariant);

                function getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;override;
                procedure setMxArray(mxArray:MxArrayPtr;Const invertIndices:boolean=false);override;

                function Get(name: AnsiString;var value; tpx:integer):boolean;
                function GetSt(name: AnsiString;var value: AnsiString):boolean;
                function GetObj(name: AnsiString;var value: TypeUO):boolean;
              end;

  TmatFile =  class(typeUO)
              private
                fileName:AnsiString;
                pmf: Tpmf;
              public
                constructor create;override;
                destructor destroy;override;

                class function STMClassName:AnsiString;override;

                function OpenFile(st:AnsiString; stMode:AnsiString): boolean;
                procedure close;
                {
                function PutMxArray(name: AnsiString; mxArray: TmxArray): boolean;

                procedure GetNextVariable(var name: AnsiString;var mxArray: TmxArray);
                }
                function DeleteVariable(name: AnsiString): integer;

                procedure GetDir( var memo: TstmMemo);

                function putVariable(name: AnsiString; var value: TGvariant; Const tpDest0: typetypeG=g_none): boolean;
                function GetVariable(name: AnsiString;var value; tpx:integer):boolean;
                function GetStVariable(name: AnsiString;var value: AnsiString):boolean;
                function GetObjVariable(name: AnsiString;var value: TypeUO):boolean;

              end;



procedure proTmatlabStruct_create(var pu:typeUO);pascal;
procedure proTmatlabStruct_Put(name: AnsiString; var value:TGvariant; var pu:typeUO);pascal;

function fonctionTmatlabStruct_Get(name: AnsiString; var value:AnsiString; var pu:typeUO): boolean;pascal;
function fonctionTmatlabStruct_Get_1(name: AnsiString; var value:typeUO; var pu:typeUO): boolean;pascal;
function fonctionTmatlabStruct_Get_2(name: AnsiString; var value;size,tpx:integer; var pu:typeUO): boolean;pascal;


procedure proTmatFile_OpenFile(stf,stmode: AnsiString; var pu:typeUO);pascal;
procedure proTmatFile_GetDir(var memo: TstmMemo;var pu:typeUO);pascal;
procedure proTmatFile_Close(var pu:typeUO);pascal;

procedure proTmatFile_PutVariable(name: AnsiString; var value: TGvariant; var pu:typeUO);pascal;
procedure proTmatFile_PutVariable_1(name: AnsiString; var value: TGvariant; tp:integer; var pu:typeUO);pascal;

function fonctionTmatFile_GetVariable(name: AnsiString; var value: AnsiString; var pu:typeUO):boolean;pascal;
function fonctionTmatFile_GetVariable_1(name: AnsiString; var value:typeUO; var pu:typeUO):boolean;pascal;
function fonctionTmatFile_GetVariable_2(name: AnsiString; var value;size,tpx:integer; var pu:typeUO):boolean;pascal;


implementation


function VariantToMxArray(var value:TGvariant; Const TpDest0:typetypeG = g_none): mxArrayPtr;
begin
  case value.Vtype of
    gvBoolean:   result:= mxCreateLogicalScalar(value.Vboolean);
    gvInteger:   result:= mxCreateDoubleScalar(value.VInteger);
    gvFloat:     result:= mxCreateDoubleScalar(value.Vfloat);
    gvComplex:   begin
                   result:=  mxCreateDoubleMatrix(1,1,mxComplex);
                   Pdouble(mxGetData(result))^:=value.Vcomplex.x;
                   Pdouble(mxGetImagData(result))^:=value.Vcomplex.y;
                 end;
    gvString:    result:= mxCreateString( @value.Vstring[1]);
    gvObject:    begin
                   if assigned(value.Vobject) then result:=value.Vobject.getMxArray(tpDest0);
                 end;
    else result:=nil;
  end;
end;


function ClassIDtoFloat(t:pointer; classID: mxClassID): float;
begin
  if assigned(t) then
  case classID of
    mxInt8_class:   result:= PShort(t)^;
    mxUInt8_class:  result:= Pbyte(t)^;
    mxInt16_class:  result:= PsmallInt(t)^;
    mxUInt16_class: result:= Pword(t)^;

    mxInt32_class:  result:= Plongint(t)^;
    mxUInt32_class: result:= Plongword(t)^;

    mxsingle_class: result:= Psingle(t)^;
    mxDouble_class: result:= Pdouble(t)^;
    else result:=0;
  end
  else result:=0;
end;


procedure FloatToVar(w1,w2:float; t: pointer; tpx:integer);
begin
  case typeNombre(tpx) of
    nbByte:         Pbyte(t)^:= round(w1);
    nbShort:        PShortint(t)^:= round(w1);
    nbSmall:        PSmallint(t)^:= round(w1);
    nbWord:         Pword(t)^:= round(w1);
    nbLong:         PLongint(t)^:= round(w1);
    nbDword:        PLongword(t)^:= round(w1);
    nbInt64:        Pint64(t)^:= round(w1);
    nbSingle:       Psingle(t)^:= w1;
    nbdouble:       Pdouble(t)^:= w1;
    nbExtended:     Pextended(t)^:= w1;
    nbSingleComp:   PsingleComp(t)^:= singleComp(w1,w2);
    nbDoubleComp:   PdoubleComp(t)^:= DoubleComp(w1,w2);
    nbExtComp:      PfloatComp(t)^:= FloatComp(w1,w2);

  end;
end;

function MxToVar( mx: MxArrayPtr;var value; tpx: integer):boolean;
var
  Pdim: PtabLong;
  Ndim: integer;
  i:integer;
  t1,t2:pointer;
  classID: mxClassID;
  isComp: boolean;
  w1,w2:float;
begin
  Ndim:= mxGetNumberOfDimensions(mx);
  Pdim:= mxGetDimensions(mx);

  for i:=0 to Ndim-1 do
    if Pdim^[i]<>1 then exit;

  classID:=mxGetClassID(mx);
  isComp:= mxIsComplex(mx);

  if mxIsNumeric(mx) then
  begin
    t1:= mxGetPr(mx);
    w1:= ClassIDtoFloat(t1, classID);
    if isComp then
    begin
      t2:= mxGetPi(mx);
      w2:= ClassIDtoFloat(t2, classID);
    end
    else w2:=0;

    FloatToVar(w1,w2, @value, tpx);
  end
  else
  if mxIsLogical(mx) and (tpx = ord(nbBoole)) then
  begin
    Pboolean(value)^ := mxGetLogicals(mx)^;
  end;
end;


{ TmatlabStruct }

constructor TmatlabStruct.create;
var
  fieldNames: Ansistring;
  p: pointer;
begin
  inherited;

  if not testMatlabMat then exit;
  if not testMatlabMatrix then exit;

  fieldNames:='Hello';
  p:=@fieldNames[1];

  mx0:= mxCreateStructMatrix(1,1,0,nil);
end;

destructor TmatlabStruct.destroy;
begin
  mxDestroyArray(mx0);
  mx0:=nil;
  inherited;
end;

class function TmatlabStruct.STMClassName: AnsiString;
begin
  result:= 'MatlabStruct';
end;


procedure TmatlabStruct.Put(st: AnsiString; var value: TGvariant);
var
  mx,mxF,mxB,mxS: mxArrayPtr;
  stl:Tstringlist;
  stA: AnsiString;
  i,k:integer;
begin
  mx:= VariantToMxArray(value);
  if assigned(mx) then
  begin
    stl:=TstringList.create;
    stl.text:= AnsiReplaceText(st,'.',crlf);

    mxB:=mx0;
    for i:=0 to stL.Count-1 do
    begin
      stA:=stl[i];                                    // en 64 bits, ne pas écrire PansiChar(stL[i]) (qui marche en 32 bits)
      mxF:=mxGetField(mxB,0,PansiChar(stA));
      if assigned(mxF) then                           // Le champ existe
      begin
        if (i<stL.Count-1) then mxB:= mxF             // Elément non terminal: on boucle
        else
        begin
          mxDestroyArray(mxF);                        // Elément terminal
          mxSetField(mxB,0,PansiChar(stA), mx);       // On le détruit et on le remplace
        end;
      end
      else
      begin
        k:= mxAddField(mxB,PansiChar(stA));           // le champ n'existe pas, on le crée
        if (i=stL.Count-1) then
        begin                                         // Elément terminal
          mxSetFieldByNumber(mxB,0, k, mx);           // On accroche  mx
        end
        else
        begin                                          // Elément non terminal
          mxS:= mxCreateStructMatrix(1,1,0,nil);       // on accroche une structure vide
          mxSetFieldByNumber(mxB,0, k, mxS);
          mxB:=mxS;                                    // et on boucle
        end;
      end;
    end;
  end;
end;


function TmatlabStruct.getMxArray(const tpdest0: typetypeG): MxArrayPtr;
begin
  result:= mxDuplicateArray(mx0);
end;

procedure TmatlabStruct.setMxArray(mxArray: MxArrayPtr; const invertIndices: boolean);
begin
  mxDestroyArray(mx0);
  mx0:= mxDuplicateArray(mxArray);
end;



function TmatlabStruct.Get(name: AnsiString; var value; tpx: integer): boolean;
var
  mx: MxArrayPtr;
begin
  result:=false;

  mx:= FindStructField(name);

  if assigned(mx) then
  begin
    mxToVar(mx,value,tpx);
    result:=true;
  end;
end;



function TmatlabStruct.GetObj(name: AnsiString; var value: TypeUO): boolean;
var
  mx: MxArrayPtr;
begin
  result:=false;

  mx:= FindStructField(name);

  if assigned(mx) then
  begin
    value.setMxArray(mx);
    result:=true;
  end;
end;


function TmatlabStruct.FindStructField(name: AnsiString): MxArrayPtr;
var
  mx: MxArrayPtr;
  stl:Tstringlist;
  st:AnsiString;
  i:integer;
begin
  result:=nil;
  if not assigned(mx0) then exit;

  try
  stl:=TstringList.create;
  stl.text:= AnsiReplaceText(name,'.',crlf);

  mx:=mx0;
  for i:=0 to stL.Count-1 do
  begin
    st:=stl[i];    // win64 , on ne peut pas écrire mx:=mxGetField(mx,0,Pansichar(stl[i]));
    mx:=mxGetField(mx,0,PansiChar(st));
    if not assigned(mx) then exit;
  end;
  result:= mx;

  finally
  stL.Free;
  end;
end;



function TmatlabStruct.GetSt(name: AnsiString; var value: AnsiString): boolean;
var
  mx: MxArrayPtr;
  buf: array[0..1000] of AnsiChar;
begin
  result:=false;

  mx:= FindStructField(name);

  if assigned(mx) and mxIsChar(mx) then
  begin
    mxGetString(Mx, @buf[0], 1000);
    value:= Pansichar(@buf[0]);
    result:=true;
  end;

end;

{ TmatFile }

function TmatFile.OpenFile(st, stMode: AnsiString):boolean;
begin
  pmf:= matopen(@st[1],@stmode[1]);
  result:= assigned(pmf);
end;

procedure TmatFile.close;
begin
  if assigned(pmf) then
  begin
    matClose(pmf);
    pmf:=nil;
  end;
end;

constructor TmatFile.create;
begin
  inherited;

end;

function TmatFile.DeleteVariable(name: AnsiString): integer;
begin
  matDeleteVariable(pmf, Pansichar(name));
end;

destructor TmatFile.destroy;
begin
  close;

  inherited;
end;

procedure TmatFile.GetDir(var memo: TstmMemo);
var
  i, num: integer;
  tab:PtabPchar;
begin
  memo.clear;
  tab:= matGetDir( pmf, num);
  if assigned(tab) then
  begin
    for i:=0 to num-1 do
      memo.addline(tab[i]);

    mxFree(tab);
  end;

end;
{
procedure TmatFile.GetNextVariable(var name: AnsiString; var mxArray: TmxArray);
var
  p: PansiChar;
begin
  mxArray.mx:= matGetNextVariable(pmf,p);
  name:=p;
end;

procedure TmatFile.GetVariable(name: AnsiString; var mxArray: TmxArray);
begin
  mxArray.mx:= matGetVariable(pmf,PansiChar(Name));
end;


function TmatFile.PutMxArray(name: AnsiString; mxArray: TmxArray): boolean;
begin
  result:= (matPutVariable(pmf, PansiChar(name),MxArray.mx)=0);
end;
}

class function TmatFile.STMClassName: AnsiString;
begin
  result:= 'MatFile';
end;




function TmatFile.putVariable(name: AnsiString; var value: TGvariant; Const tpDest0: typetypeG=g_none ): boolean;
var
  mx: MxArrayPtr;
begin
  mx:= VariantToMxArray(value,tpDest0);

  if assigned(mx) then result:= (matPutVariable(pmf, PansiChar(name),mx)=0);
  mxDestroyArray(mx);
end;



function TmatFile.GetVariable(name: AnsiString; var value; tpx: integer): boolean;
var
  mx: mxArrayPtr;
begin
  mx:= matGetVariable(pmf,PansiChar(Name));
  if not assigned(mx) then exit;

  try
    mxToVar(mx,value,tpx);
  finally
    mxDestroyArray(mx);
  end;
end;

function TmatFile.GetStVariable(name: AnsiString;var value: AnsiString):boolean;
var
  mx: mxArrayPtr;
  buf:array[0..1000] of Ansichar;
begin
  result:=false;
  mx:= matGetVariable(pmf,PansiChar(Name));
  if not assigned(mx) then exit;

  try
    if mxIsChar(mx) then
    begin
      mxGetString(Mx, @buf[0], 1000);
      value:= Pansichar(@buf[0]);
      result:=true;
    end;
  finally
    mxDestroyArray(mx);
  end;
end;

function TmatFile.GetObjVariable(name: AnsiString; var value: TypeUO): boolean;
var
  mx: mxArrayPtr;
begin
  result:=false;
  mx:= matGetVariable(pmf,PansiChar(Name));
  if not assigned(mx) then exit;

  try
    value.setMxArray(mx);
  finally
    mxDestroyArray(mx);
  end;
  result:=true;
end;



// ******************************* Méthodes stm *************************

procedure proTmatlabStruct_create(var pu:typeUO);
begin
  if not (testMatlabMat and testMatlabMatrix) then exit;

  createPgObject('',pu,TmatlabStruct);

end;

procedure proTmatlabStruct_Put(name: AnsiString; var value: TGvariant; var pu:typeUO);
begin
  verifierObjet(pu);
  TmatlabStruct(pu).Put(name, value);
end;

function fonctionTmatlabStruct_Get(name: AnsiString; var value:AnsiString; var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  result:= TmatlabStruct(pu).GetSt(name, value);
end;

function fonctionTmatlabStruct_Get_1(name: AnsiString; var value:typeUO; var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  result:= TmatlabStruct(pu).GetObj(name, value);
end;

function fonctionTmatlabStruct_Get_2(name: AnsiString; var value;size,tpx:integer; var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  result:= TmatlabStruct(pu).Get(name, value,tpx);
end;

procedure proTmatFile_OpenFile(stf,stmode: AnsiString; var pu:typeUO);
begin
  if not (testMatlabMat and testMatlabMatrix) then exit;

  if (stMode<>'r') and (stMode<>'w') and (stMode<>'w4') and (stMode<>'u')
    then sortieErreur('TmatFile.OpenFile : bad mode');

  createPgObject('',pu,TmatFile);
  with Tmatfile(pu) do
  begin
    if not OpenFile(stf,stMode) then sortieErreur('TmatFile.OpenFile : unable to open file '+stf);

  end;
end;

procedure proTmatFile_GetDir(var memo: TstmMemo;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(memo));

  Tmatfile(pu).GetDir(memo);

end;

procedure proTmatFile_Close(var pu:typeUO);
begin
  proTobject_free(pu);
end;

procedure proTmatFile_PutVariable(name: AnsiString; var value: TGvariant; var pu:typeUO);
begin
  verifierObjet(pu);
  TmatFile(pu).putVariable(name,value);
end;

procedure proTmatFile_PutVariable_1(name: AnsiString; var value: TGvariant; tp:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  TmatFile(pu).putVariable(name,value, typetypeG(tp));
end;


function fonctionTmatFile_GetVariable(name: AnsiString; var value: AnsiString; var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= TmatFile(pu).getStVariable(name,value);
end;

function fonctionTmatFile_GetVariable_1(name: AnsiString; var value:typeUO; var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  verifierObjet(value);
  result:= TmatFile(pu).getObjVariable(name,value);
end;


function fonctionTmatFile_GetVariable_2(name: AnsiString; var value;size,tpx:integer; var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= TmatFile(pu).getVariable(name,value,tpx);
end;




end.
