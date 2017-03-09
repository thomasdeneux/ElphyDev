unit stmAve1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses Windows,
     classes,graphics,forms,controls,

     util1,Gdos,DdosFich,Dgraphic,Dgrad1,dtf0, debug0,
     Dpalette,Ncdef2,
     editcont,cood0, matCooD0,

     stmDef,stmObj,defForm,
     getVect0,visu0,
     inivect0,
     varconf1,
     stmVec1,
     stmError,stmPg,
     ippDefs,ipps,ippsovr,
     Cuda1, CudaRT1, CudaNPP1;

type
  Taverage=     class(TVector)
                  Count:longint;
                  Sqrs,stdDev,stdUp,stdDw:Tvector;
                  FStdOn:boolean;

                  IUstart,IUend:integer;
                  Finvalidate:boolean;

                  constructor create;override;
                  destructor destroy;override;

                  class function STMClassName:AnsiString;override;
                  function initialise(st:AnsiString):boolean;override;

                  procedure setChildNames;override;
                  procedure resetTitles;override;
                  procedure setChilds;

                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                  procedure saveToStream(f:Tstream;Fdata:boolean);override;
                  function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;
                  procedure proprietes(sender:Tobject);override;

                  function loadFromStream1(f:Tstream;size:LongWord;Fdata:boolean):boolean;

                  procedure AddTempAverage(vec:Tvector;isrc,idest,nb:integer);
                  procedure AddTempAverageCuda(vec:Tvector;isrc,idest,nb:integer);
                  procedure SubTempAverage(vec:Tvector;isrc,idest,nb:integer);

                  Procedure Add0(vec:Tvector;complet:boolean);
                  Procedure Add(vec:Tvector);
                  Procedure Add1(vec:Tvector);

                  Procedure Sub0(vec:Tvector;complet:boolean);
                  Procedure Sub(vec:Tvector);
                  Procedure Sub1(vec:Tvector);

                  procedure updateStdDev;

                  Procedure AddEx0(vec:Tvector;Xorg:float;complet:boolean);
                  Procedure AddEx(vec:Tvector;Xorg:float);
                  Procedure AddEx1(vec:Tvector;Xorg:float);


                  procedure reset;
                  procedure clear;override;

                  procedure setStdScales;
                  procedure setStdON(w:boolean);
                  property stdOn:boolean read FstdOn write setStdON;

                  procedure modify(tNombre:typeTypeG;i1,i2:integer);override;
                end;



{***************** Déclarations STM pour Taverage *****************************}
procedure proTaverage_create(name:AnsiString;t:smallint;n1,n2:longint;var pu:typeUO);pascal;
procedure proTaverage_create_1(t:smallint;n1,n2:longint;var pu:typeUO);pascal;

Procedure proTaverage_Add(var p, pu:typeUO); pascal;
Procedure proTaverage_AddEx(var p:typeUO;xorg:float;var pu:typeUO); pascal;

Procedure proTaverage_Add1(var p, pu:typeUO); pascal;
Procedure proTaverage_AddEx1(var p:typeUO;xorg:float;var pu:typeUO); pascal;
Procedure proTaverage_UpdateStdDev(var pu:typeUO); pascal;

procedure proTaverage_reset(var pu:typeUO);pascal;

procedure proTaverage_count(x:longint;var pu:typeUO);pascal;
function fonctionTaverage_Count(var pu:typeUO):longint;pascal;

procedure proTaverage_Finvalidate(x:boolean;var pu:typeUO);pascal;
function fonctionTaverage_Finvalidate(var pu:typeUO):boolean;pascal;


procedure proTaverage_StdOn(w:boolean;var pu:typeUO); pascal;
function fonctionTaverage_StdOn(var pu:typeUO):boolean; pascal;

function fonctionTaverage_VSqrs(var pu:typeUO):Tvector;pascal;
function fonctionTaverage_VstdDev(var pu:typeUO):Tvector;pascal;
function fonctionTaverage_VStdUp(var pu:typeUO):Tvector;pascal;
function fonctionTaverage_VStdDw(var pu:typeUO):Tvector;pascal;

IMPLEMENTATION


{********************** Méthodes de Taverage ****************************}

constructor Taverage.create;
begin
  inherited;

  Sqrs:=Tvector.create;
  stdDev:=Tvector.create;
  stdUp:=Tvector.create;
  stdDw:=Tvector.create;

  Sqrs.Flags.Findex:=false;
  Sqrs.Flags.Ftype:=false;
  StdDev.Flags.Findex:=false;
  StdDev.Flags.Ftype:=false;
  StdUp.Flags.Findex:=false;
  StdUp.Flags.Ftype:=false;
  StdDw.Flags.Findex:=false;
  StdDw.Flags.Ftype:=false;

  stdON:=false;

  setChilds;

  AddTochildList(sqrs);
  AddTochildList(stdDev);
  AddTochildList(stdUp);
  AddTochildList(stdDw);

  FInvalidate:=true;
end;

destructor Taverage.destroy;
begin
  Sqrs.free;
  stdDev.free;
  stdUp.free;
  stdDw.free;

  inherited;
end;

class function Taverage.STMClassName:AnsiString;
begin
  STMClassName:='Average';
end;

function Taverage.initialise(st:AnsiString):boolean;
begin
  result:= inherited initialise(st);
  if result then setChilds;
end;


procedure Taverage.setChildNames;
var
  i:integer;
begin
  with Sqrs do
  begin
    ident:=self.ident+'.Vsqrs';
    notPublished:=true;
    Fchild:=true;
  end;

  with stdDev do
  begin
    ident:=self.ident+'.VstdDev';
    notPublished:=true;
    Fchild:=true;
  end;

  with stdUp do
  begin
    ident:=self.ident+'.VstdUp';
    notPublished:=true;
    Fchild:=true;
  end;

  with stdDw do
  begin
    ident:=self.ident+'.VstdDw';
    notPublished:=true;
    Fchild:=true;
  end;
end;

procedure Taverage.ResetTitles;
begin
  Sqrs.title:='';
  stdDev.title:='';
  stdUp.title:='';
  stdDw.title:='';
end;


procedure Taverage.setChilds;
begin
  setChildNames;

  Sqrs.visu.color:=clBlue;
  stdDev.visu.color:=clBlue;
  stdUp.visu.color:=clGreen;
  stdDw.visu.color:=clGreen;
end;


procedure Taverage.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;

  with conf do
    setvarconf('Count',count,sizeof(count));
end;


procedure Taverage.saveToStream(f:Tstream;Fdata:boolean);
var
  i,old:integer;
begin
  old:=count;
  if not Fdata then
    count:=0;
  inherited saveToStream(f,Fdata);
  count:=old;

  Sqrs.saveToStream(f,Fdata);
  stdDev.saveToStream(f,Fdata);
  stdUp.saveToStream(f,Fdata);
  stdDw.saveToStream(f,Fdata);
end;

function Taverage.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
  var
    st1:string[255];
    posf:LongWord;
    ok:boolean;
    posIni:LongWord;
    i:integer;
  begin
    ok:=inherited loadFromStream(f,size,Fdata);
    result:=ok;

    if not Fdata then count:=0;

    if not ok then
    begin
      setChilds;
      exit;
    end;

    if f.position>=f.Size  then
      begin
        result:=true;
        exit;
      end;

    posIni:=f.position;
    st1:=readHeader(f,longWord(size));
    FlagConvertExtended:=true;
    ok:=(st1=Tvector.stmClassName) and
        (Sqrs.loadFromStream(f,size,Fdata)) and
        (Sqrs.NotPublished);
    if not ok then
      begin
        f.Position:=Posini;
        result:=ok;
        setChilds;
        exit;
      end;

    posIni:=f.position;
    st1:=readHeader(f,longWord(size));
    ok:=(st1=Tvector.stmClassName) and
        (stdDev.loadFromStream(f,size,Fdata)) and
        (stdDev.NotPublished);
    if not ok then
      begin
        f.Position:=Posini;
        result:=ok;
        setChilds;
        exit;
      end;

    posIni:=f.position;
    st1:=readHeader(f,longWord(size));
    ok:=(st1=Tvector.stmClassName) and
        (stdUp.loadFromStream(f,size,Fdata)) and
        (stdUp.NotPublished);
    if not ok then
      begin
        f.Position:= Posini;
        result:=ok;
        setChilds;
        exit;
      end;

    posIni:=f.position;
    st1:=readHeader(f,longWord(size));
    ok:=(st1=Tvector.stmClassName) and
        (stdDw.loadFromStream(f,size,Fdata)) and
        (stdDw.NotPublished);
    if not ok then
      begin
        f.Position:=Posini;
        result:=ok;
        setChilds;
        exit;
      end;

    setChilds;
    result:=ok;
  end;


function Taverage.loadFromStream1(f:Tstream;size:LongWord;Fdata:boolean):boolean;
begin
  result:=inherited loadFromStream(f,size,Fdata);
  setChilds;
end;


{ Ajoute vec à la moyenne dans les cas compatibles IPPS
  On ne fait aucun contrôle
  isrc est l'indice de départ dans vec
  idest est l'indice de destination dans le vecteur moyenne
  nb est le nombre de points
}

procedure Taverage.AddTempAverage(vec:Tvector;isrc,idest,nb:integer);
var
  wS:TsingleComp;
  wD:TdoubleComp;
begin
{ Il faut oublier ça pour le moment.
  IPP est bien plus rapide que NPP.

  if initNPPS then
  begin
    AddTempAverageCuda(vec,isrc,idest,nb);
    exit;
  end;
}
  IPPStest;
  case tpNum of
    G_single: begin
                ippsMulC(count-1,Psingle(@PtabSingle(tb)^[idest-Istart]),nb);
                ippsAdd(Psingle(@PtabSingle(vec.tb)^[isrc-vec.Istart]) , Psingle(@PtabSingle(tb)^[idest-Istart]),nb);
                ippsMulC(1/count,Psingle(@PtabSingle(tb)^[idest-Istart]),nb);
              end;
    G_double: begin
                ippsMulC(count-1,Pdouble(@Ptabdouble(tb)^[idest-Istart]),nb);
                ippsAdd(Pdouble(@Ptabdouble(vec.tb)^[isrc-vec.Istart]) , Pdouble(@Ptabdouble(tb)^[idest-Istart]),nb);
                ippsMulC(1/count,Pdouble(@Ptabdouble(tb)^[idest-Istart]),nb);
              end;

    G_singleComp:
              begin
                ws.x:=count-1;
                ws.y:=0;
                ippsMulC(ws,PsingleComp(@PtabSingleComp(tb)^[idest-Istart]),nb);
                ippsAdd(PsingleComp(@PtabSingleComp(vec.tb)^[isrc-vec.Istart]) , PsingleComp(@PtabSingleComp(tb)^[idest-Istart]), nb);
                ws.x:=1/count;
                ws.y:=0;
                ippsMulC(ws,PsingleComp(@PtabSingleComp(tb)^[idest-Istart]),nb);
              end;

    G_doubleComp:
              begin
                wd.x:=count-1;
                wd.y:=0;
                ippsMulC(wd,PdoubleComp(@PtabdoubleComp(tb)^[idest-Istart]),nb);
                ippsAdd(PdoubleComp(@PtabdoubleComp(vec.tb)^[isrc-vec.Istart]) , PdoubleComp(@PtabdoubleComp(tb)^[idest-Istart]), nb);
                wd.x:=1/count;
                wd.y:=0;
                ippsMulC(wd,PdoubleComp(@PtabdoubleComp(tb)^[idest-Istart]),nb);
              end;

  end;
  IPPSend;
end;


// avril 2013 :  il faut se rendre à l'évidence: NPP est beaucoup plus lente que IPP !!!


procedure Taverage.AddTempAverageCuda(vec:Tvector;isrc,idest,nb:integer);
var
  wS:TsingleComp;
  wD:TdoubleComp;
  Src,dest:pointer;
  st:string;
  res:integer;
const
  devSrc: pointer=nil;
  devDest:pointer=nil;

begin
  //if not initNPPS then exit;
  if not initCudaLib2 then exit;

  st:='';
  case tpNum of
    G_single: begin
                src:=  Psingle(@PtabSingle(vec.tb)^[isrc-vec.Istart]);
                dest:= Psingle(@PtabSingle(tb)^[idest-Istart]);

                res:=testAverage(src,dest,nb,count);
                //messageCentral('res='+Istr(res));
                {
                st:=st+'- '+Istr(cudaMalloc(devSrc, nb*sizeof(single)));
                st:=st+'- '+Istr(cudaMalloc(devDest, nb*sizeof(single)));

                st:=st+'- '+Istr(cudaMemCpy(devSrc,Src, nb*sizeof(single),cudaMemcpyHostToDevice));
                st:=st+'- '+Istr(cudaMemCpy(devDest,dest, nb*sizeof(single),cudaMemcpyHostToDevice));

                st:=st+'- '+Istr(nppsMulC_32f_I(count-1,devDest,nb));
                st:=st+'- '+Istr(nppsAdd_32f_I(devSrc , devDest,nb));
                st:=st+'- '+Istr(nppsMulC_32f_I(1/count,devDest,nb));

                st:=st+'- '+Istr(cudaMemCpy(Dest,Devdest,nb*sizeof(single),cudaMemcpyDeviceToHost));

                st:=st+'- '+Istr(cudaFree(devSrc));
                st:=st+'- '+Istr(cudaFree(devDest));

                messageCentral(st);
                }
              end;
    G_double: begin
                ippsMulC(count-1,Pdouble(@Ptabdouble(tb)^[idest-Istart]),nb);
                ippsAdd(Pdouble(@Ptabdouble(vec.tb)^[isrc-vec.Istart]) , Pdouble(@Ptabdouble(tb)^[idest-Istart]),nb);
                ippsMulC(1/count,Pdouble(@Ptabdouble(tb)^[idest-Istart]),nb);
              end;

    G_singleComp:
              begin
                ws.x:=count-1;
                ws.y:=0;
                ippsMulC(ws,PsingleComp(@PtabSingleComp(tb)^[idest-Istart]),nb);
                ippsAdd(PsingleComp(@PtabSingleComp(vec.tb)^[isrc-vec.Istart]) , PsingleComp(@PtabSingleComp(tb)^[idest-Istart]), nb);
                ws.x:=1/count;
                ws.y:=0;
                ippsMulC(ws,PsingleComp(@PtabSingleComp(tb)^[idest-Istart]),nb);
              end;

    G_doubleComp:
              begin
                wd.x:=count-1;
                wd.y:=0;
                ippsMulC(wd,PdoubleComp(@PtabdoubleComp(tb)^[idest-Istart]),nb);
                ippsAdd(PdoubleComp(@PtabdoubleComp(vec.tb)^[isrc-vec.Istart]) , PdoubleComp(@PtabdoubleComp(tb)^[idest-Istart]), nb);
                wd.x:=1/count;
                wd.y:=0;
                ippsMulC(wd,PdoubleComp(@PtabdoubleComp(tb)^[idest-Istart]),nb);
              end;

  end;
  NPPSend;
end;


procedure Taverage.SubTempAverage(vec:Tvector;isrc,idest,nb:integer);
var
  wS:TsingleComp;
  wD:TdoubleComp;
begin
  IPPStest;
  case tpNum of
    G_single: begin
                ippsMulC(count+1,Psingle(@PtabSingle(tb)^[idest-Istart]),nb);
                ippsSub(Psingle(@PtabSingle(vec.tb)^[isrc-vec.Istart]) , Psingle(@PtabSingle(tb)^[idest-Istart]),nb);
                ippsMulC(1/count,Psingle(@PtabSingle(tb)^[idest-Istart]),nb);
              end;
    G_double: begin
                ippsMulC(count+1,Pdouble(@Ptabdouble(tb)^[idest-Istart]),nb);
                ippsSub(Pdouble(@Ptabdouble(vec.tb)^[isrc-vec.Istart]) , Pdouble(@Ptabdouble(tb)^[idest-Istart]),nb);
                ippsMulC(1/count,Pdouble(@Ptabdouble(tb)^[idest-Istart]),nb);
              end;

    G_singleComp:
              begin
                ws.x:=count+1;
                ws.y:=0;
                ippsMulC(ws,PsingleComp(@PtabSingleComp(tb)^[idest-Istart]),nb);
                ippsSub(PsingleComp(@PtabSingleComp(vec.tb)^[isrc-vec.Istart]) , PsingleComp(@PtabSingleComp(tb)^[idest-Istart]), nb);
                ws.x:=1/count;
                ws.y:=0;
                ippsMulC(ws,PsingleComp(@PtabSingleComp(tb)^[idest-Istart]),nb);
              end;

    G_doubleComp:
              begin
                wd.x:=count+1;
                wd.y:=0;
                ippsMulC(wd,PdoubleComp(@PtabdoubleComp(tb)^[idest-Istart]),nb);
                ippsSub(PdoubleComp(@PtabdoubleComp(vec.tb)^[isrc-vec.Istart]) , PdoubleComp(@PtabdoubleComp(tb)^[idest-Istart]), nb);
                wd.x:=1/count;
                wd.y:=0;
                ippsMulC(wd,PdoubleComp(@PtabdoubleComp(tb)^[idest-Istart]),nb);
              end;

  end;
  IPPSend;
end;


Procedure Taverage.Add0(vec:Tvector;complet:boolean);
var
  i,i1,i2:integer;
  flag:boolean;
begin
  if not assigned(vec)  or not assigned(vec.data) then exit;

  if not assigned(data) and (count<>0) then exit;

  i1:=Istart;
  i2:=Iend;

  if count=0 then
    begin
      flag:=(i1<>vec.Istart) or (i2<>vec.Iend);
      if flag then
        begin
          i1:=vec.Istart;
          i2:=vec.Iend;

          initTemp1(i1,i2,tpNum);

        end;

      dxu:=vec.dxu;
      x0u:=vec.x0u;
      unitY:=vec.unitY;
      if tpNum<g_single then
      begin
         dyu:=vec.Dyu;
         y0u:=vec.Y0u;
      end;
      if flag then setStdOn(stdON);
      if stdON then setStdScales; // si not flag , on copie quand même les échelles
    end
  else
    begin
      if i1<vec.Istart then i1:=vec.Istart;
      if i2>vec.Iend then i2:=vec.Iend;
    end;

  inc(count);

  if (tpNum in [G_single,G_double,G_singleComp,G_doubleComp]) and (tpNum=vec.tpNum) and vec.inf.temp
    then AddTempAverage(vec,I1,I1,i2-i1+1)
  else
  begin
    for i:=i1 to i2 do
      data.setE(i,((count-1)*data.getE(i)+vec.data.getE(i))/count );

    if iscomplex then
    for i:=i1 to i2 do
      data.setIm(i,((count-1)*data.getIm(i)+vec.data.getIm(i))/count );
  end;

  visu.ux:=vec.visu.ux;

  { Rappel stdDev= sqrt((sx2-sqr(Sx)/N)/(N-1)); }

  if stdON  then
  begin
    for i:=i1 to i2 do
      sqrs.data.setE(i,sqrs.data.getE(i)+sqr(vec.data.getE(i)));

    if isComplex then
    for i:=i1 to i2 do
      sqrs.data.setE(i,sqrs.data.getE(i)+sqr(vec.data.getIm(i)));

    if complet then updateStdDev;
  end;

  if Finvalidate then invalidate;
end;

procedure Taverage.updateStdDev;
var
  i:integer;
begin
  if stdON  and (count>1) then
  for i:=Istart to Iend do
    begin
      stdDev.data.setE(i, sqrs.data.getE(i)-sqr(data.getE(i))*count) ;

      if isComplex then
      stdDev.data.setE(i, stdDev.data.getE(i)-sqr(data.getIm(i))*count);

      stdDev.data.setE(i,sqrt( abs(stdDev.data.getE(i)/(count-1))));

      stdUp.data.setE(i,data.getE(i)+stdDev.data.getE(i) );
      stdDw.data.setE(i,data.getE(i)-stdDev.data.getE(i) );

      if isComplex then
      begin
        stdUp.data.setIm(i,data.getIm(i)+stdDev.data.getE(i) );
        stdDw.data.setIm(i,data.getIm(i)-stdDev.data.getE(i) );
      end;
    end;
end;


Procedure Taverage.Add(vec:Tvector);
begin
  add0(vec,true);
end;

Procedure Taverage.Add1(vec:Tvector);
begin
  add0(vec,false);
end;

Procedure Taverage.Sub0(vec:Tvector;complet:boolean);
var
  i,i1,i2:integer;
begin
  if not assigned(vec) or not assigned(data) or not assigned(vec.data) then exit;
  if count=0 then exit;

  i1:=data.indicemin;
  i2:=data.indicemax;

  if i1<vec.data.indicemin then i1:=vec.data.indicemin;
  if i2>vec.data.indicemax then i2:=vec.data.indicemax;

  dec(count);

  if (tpNum in [G_single,G_double,G_singleComp,G_doubleComp]) and (tpNum=vec.tpNum) and vec.inf.temp
    then SubTempAverage(vec,I1,I1,i2-i1+1)
  else
  begin
    for i:=i1 to i2 do
      data.setE(i,((count+1)*data.getE(i)-vec.data.getE(i))/count );
    if iscomplex then
    for i:=i1 to i2 do
      data.setIm(i,((count+1)*data.getIm(i)-vec.data.getIm(i))/count );
  end;

  visu.ux:=vec.visu.ux;

  { Rappel stdDev= sqrt((sx2-sqr(Sx)/N)/(N-1)); }

  if stdON  then
  begin
    for i:=i1 to i2 do
      sqrs.data.setE(i,sqrs.data.getE(i)-sqr(vec.data.getE(i)));
    if isComplex then
    for i:=i1 to i2 do
      sqrs.data.setE(i,sqrs.data.getE(i)-sqr(vec.data.getIm(i)));

    if complet then updateStdDev;
  end;

  if Finvalidate then invalidate;
end;

Procedure Taverage.sub(vec:Tvector);
begin
  sub0(vec,true);
end;

Procedure Taverage.sub1(vec:Tvector);
begin
  sub0(vec,false);
end;


{ Le point d'abscisse Xorg est placé au point d'abscisse 0 dans Taverage }

Procedure Taverage.AddEx0(vec:Tvector;Xorg:float;complet:boolean);
var
  i,i0,i1,i2:integer;
  iorg:integer;
begin
  IPPStest;
  if not assigned(vec) or not assigned(data) or not assigned(vec.data) then exit;

  iorg:=vec.invconvx(Xorg);
  i0:=invconvx(0);

  i1:=IStart;
  i2:=Iend;

  if iorg+i1-i0<vec.Istart then i1:=vec.Istart+i0-iOrg;
  if iorg+i2-i0>vec.Iend then i2:=vec.Iend+i0-iOrg;

  if count=0 then
    begin
      dxu:=vec.dxu;

      unitY:=vec.unitY;
      if tpNum<g_single then
      begin
         dyu:=vec.Dyu;
         y0u:=vec.Y0u;
      end;
      if stdON then setStdScales;
    end;

  inc(count);

  if (tpNum in [G_single,G_double,G_singleComp,G_doubleComp]) and (tpNum=vec.tpNum) and vec.inf.temp
    then AddTempAverage(vec,iorg+i1-i0,i1,i2-i1+1)
  else
  begin
    for i:=i1 to i2 do
      data.setE(i,((count-1)*data.getE(i)+vec.data.getE(iorg+i-i0))/count );

    if isComplex then
    for i:=i1 to i2 do
      data.setIm(i,((count-1)*data.getIm(i)+vec.data.getIm(iorg+i-i0))/count );
  end;
  visu.ux:=vec.visu.ux;

  if stdON then
  begin
    for i:=i1 to i2 do
      sqrs.data.setE(i,sqrs.data.getE(i)+sqr(vec.data.getE(iorg+i-i0)));

    if isComplex then
    for i:=i1 to i2 do
      sqrs.data.setE(i,sqrs.data.getE(i)+sqr(vec.data.getIm(iorg+i-i0)));

    if complet then updateStdDev;
  end;

  if Finvalidate then invalidate;
end;

Procedure Taverage.AddEx(vec:Tvector;Xorg:float);
begin
  addEx0(vec,Xorg,true);
end;

Procedure Taverage.AddEx1(vec:Tvector;Xorg:float);
begin
  addEx0(vec,Xorg,false);
end;


procedure Taverage.reset;
begin
  count:=0;
  fill(0);
  IUstart:=Istart;
  IUend:=Iend;

  sqrs.fill(0);
  stdDev.fill(0);
  stdUp.fill(0);
  stdDw.fill(0);
end;

procedure Taverage.clear;
begin
  reset;
end;

procedure Taverage.setStdON(w:boolean);
begin
  FstdOn:=w;
  if w then
    begin
      sqrs.initTemp1(Istart,Iend,G_double);
      stdDev.initTemp1(Istart,Iend,inf.tpNum);
      stdUp.initTemp1(Istart,Iend,inf.tpNum);
      stdDw.initTemp1(Istart,Iend,inf.tpNum);
    end
  else
    begin
      sqrs.initTemp1(0,0,G_double);
      stdDev.initTemp1(0,0,inf.tpNum);
      stdUp.initTemp1(0,0,inf.tpNum);
      stdDw.initTemp1(0,0,inf.tpNum);
    end;

  setStdScales;
end;

procedure Taverage.setStdScales;
begin
  sqrs.dxu:=dxu;
  sqrs.x0u:=x0u;
  sqrs.dyu:=dyu;
  sqrs.y0u:=y0u;

  sqrs.cpx:=cpx;
  sqrs.Xmin:=Xmin;
  sqrs.Xmax:=Xmax;

  stdDev.dxu:=dxu;
  stdDev.x0u:=x0u;
  stdDev.dyu:=dyu;
  stdDev.y0u:=y0u;

  stdDev.cpx:=cpx;
  stdDev.Xmin:=Xmin;
  stdDev.Xmax:=Xmax;

  stdUp.dxu:=dxu;
  stdUp.x0u:=x0u;
  stdUp.dyu:=dyu;
  stdUp.y0u:=y0u;

  stdUp.cpx:=cpx;
  stdUp.cpy:=cpy;
  stdUp.setWorld(Xmin,Ymin,Xmax,Ymax);

  stdDw.dxu:=dxu;
  stdDw.x0u:=x0u;
  stdDw.dyu:=dyu;
  stdDw.y0u:=y0u;

  stdDw.cpx:=cpx;
  stdDw.cpy:=cpy;
  stdDw.setWorld(Xmin,Ymin,Xmax,Ymax);

end;



procedure Taverage.modify(tNombre:typeTypeG;i1,i2:integer);
begin
  clear;
  inherited;

  setStdOn(FStdON);
end;

procedure Taverage.proprietes(sender: Tobject);
begin
  propVector('Count= '+Istr(count));
end;

{*********************** Méthodes STM pour Taverage ********************}

var
  E_typeNombre:integer;
  E_indexOrder:integer;

procedure proTaverage_create(name:AnsiString;t:smallint;n1,n2:longint;
                             var pu:typeUO);
begin
  if not (typeTypeG(t) in typesVecteursSupportes)
      then sortieErreur(E_typeNombre);
  if n1>n2 then  sortieErreur(E_indexOrder);

  createPgObject(name,pu,Taverage);

  with Taverage(pu) do
  begin
    setChilds;
    initTemp1(n1,n2,TypetypeG(t));
  end;
end;

procedure proTaverage_create_1(t:smallint;n1,n2:longint;var pu:typeUO);
begin
  proTaverage_create('',t,n1,n2, pu);
end;

procedure proTaverage_StdOn(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  Taverage(pu).setStdON(w);
end;

function fonctionTaverage_StdOn(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=Taverage(pu).stdOn;
end;



Procedure proTaverage_Add(var p, pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(p);

    Taverage(pu).add(Tvector(p));
  end;

Procedure proTaverage_Add1(var p, pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(p);

    Taverage(pu).add1(Tvector(p));
  end;

Procedure proTaverage_UpdateStdDev(var pu:typeUO);
  begin
    verifierObjet(pu);

    Taverage(pu).updateStdDev;
  end;



Procedure proTaverage_AddEx(var p:typeUO;xorg:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(p);

    Taverage(pu).addEx(Tvector(p),xorg);
  end;

Procedure proTaverage_AddEx1(var p:typeUO;xorg:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(p);

    Taverage(pu).addEx1(Tvector(p),xorg);
  end;

procedure proTaverage_reset(var pu:typeUO);
  begin
    verifierObjet(pu);
    Taverage(pu).reset;
  end;

procedure proTaverage_count(x:longint;var pu:typeUO);
  begin
    verifierObjet(pu);
    Taverage(pu).count:=x;
  end;

function fonctionTaverage_Count(var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    fonctionTaverage_Count:=Taverage(pu).count;
  end;

procedure proTaverage_Finvalidate(x:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    Taverage(pu).Finvalidate:=x;
  end;

function fonctionTaverage_Finvalidate(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    result:= Taverage(pu).Finvalidate;
  end;


function fonctionTaverage_VSqrs(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with Taverage(pu) do result:=@Sqrs.myAd;
end;

function fonctionTaverage_VstdDev(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with Taverage(pu) do result:=@stdDev.myAd;
end;

function fonctionTaverage_VStdUp(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with Taverage(pu) do result:=@StdUp.myAd;
end;

function fonctionTaverage_VStdDw(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with Taverage(pu) do result:=@StdDw.myAd;
end;


Initialization
AffDebug('Initialization stmAve1',0);

installError(E_typeNombre,'Taverage.create: Type not supported');
installError(E_indexOrder,'Taverage: start index must be lower than end index');

registerObject(Taverage,data);

end.
