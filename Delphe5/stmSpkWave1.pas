unit StmSpkWave1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,

     util1,Dgraphic,Dtrace1,listG,
     dtf0,
     stmDef,stmObj,
     stmDobj1,
     varconf1,
     stmVec1,
     NcDef2,stmPg,
     cyberK2,
     WaveListForm1,
     matlab_matrix,matlab_mat;


  { TwaveList est un vecteur du type temp
    On l'initialise en appelant initTemp1 de Tvector
    puis en appelant InitRawData qui fixe RawData et RawDataAtt.
    TwaveList n'est pas propriétaire de RawData et RawDataAtt.

    RawData est un objet data qui permet d'accéder aux données proprement dites.

    Octobre 2016: la waveform contient un header de ElphySpkPacketFixedSize octets + le vecteur waveForm proprement dit
    RawData.getP(n) donne le début du HEADER !!

    On utilise uniquement RawData.getP(n)
    et aussi rawdata.eltSize (voir plus bas) .

    RawData.indiceMin et RawData.indiceMax renvoient respectivement 1 et maxIndex

    RawDataAtt est un objet data qui renvoie l'attribut du vecteur d'indice n
    On utilise uniquement RawDataAtt.getI(n) qui donne l'attribut du vecteur n

    SetIndex remplace le contenu du vecteur TwaveList par de nouvelles données.
  }

type
  TWrec=record
          ElphyTime:longword;
          time: longword;
          chid: smallint;
          unit1: byte;
        end;
  PWrec=^TWrec;



  TwaveList = class(Tvector)
              private
                FmaxIndex:integer;

                function getMaxIndex: integer;virtual;

              public
                CurWRec:TWrec;

                WUCount,WUcountR:longint;

                dataSpk: array of typeDataSegUExt;
                Wunit:array of TwaveList;

                Windex:integer;

                FUseStdColors:boolean;

                RawData, RawDataAtt : typeDataB;
                OldColor:integer;

                DxuSrc:float;         { quand la source est en secondes, la waveform est en ms }
                unitXsrc:AnsiString;

                Att0:byte; {utilisé quand RawDataAtt=nil }

                MultiIndexDisplay:boolean;
                MultiIndexStart, MultiIndexEnd: integer;
                OldMultiMode:boolean;


                property maxIndex:integer read getMaxIndex;

                function getAtt:integer;virtual;
                procedure SetAtt(w:integer);virtual;
                property Att:integer read getAtt write setAtt;

                procedure InitRawData(data1, dataAtt1: typeDataB);
                procedure ReInitRawData;
                procedure setIndex(n:integer);virtual;
                function getCurrentTime:float;
                function getTimeString:AnsiString;
                function getUnitString:AnsiString;

                constructor create;override;
                destructor destroy;override;

                class function STMClassName:AnsiString;override;
                procedure setVectors(nb:integer);
                procedure setChildNames;override;

                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure saveToStream(f:Tstream;Fdata:boolean);override;
                function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;
                function loadFromStream1(f:Tstream;size:LongWord;Fdata:boolean):boolean;
                procedure CompleteLoadInfo;override;

                procedure CreateForm;override;
                procedure initForm;

                procedure BeforePaint;
                procedure AfterPaint;

                procedure BeforeFormPaint;
                procedure AfterFormPaint;

                procedure Display;override;
                procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                                  const order:integer=-1); override;

                procedure setMultiIndex(w:boolean; I1,I2:integer);
                procedure SavePacketList(f:Tstream;Const Times: Tvector=nil);virtual;

                function getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;override;


              end;

  TwaveListA= class(TwaveList)
              private
                listG:Tlistg;

                function getMaxIndex: integer;override;

              public
                constructor create;override;
                destructor destroy;override;
                procedure Init(NbUnit:integer;tp:typetypeG; i1,i2:integer);
                procedure SetAtt(w:integer);override;

                procedure Clear;override;
                procedure AddVector(vec:Tvector; NumU:integer);
                procedure AddWaveList(wl: TwaveList);

                procedure SavePacketList(f:Tstream;Const Times: Tvector=nil);override;

                function DataPointer: pointer;
                function AttPointer: pointer;
                function getPointer:pointer;

                function getAttValue(i:integer):byte;override;

                //procedure setMxArray(mxArray:MxArrayPtr;Const invertIndices:boolean=false);override;
              end;

procedure proTwaveList_UseStdColors(w:boolean;var pu:typeUO);pascal;
function fonctionTwaveList_UseStdColors(var pu:typeUO):boolean;pascal;
procedure proTwaveList_Index(w:integer;var pu:typeUO);pascal;
function fonctionTwaveList_Index(var pu:typeUO):integer;pascal;
function fonctionTwaveList_MaxIndex(var pu:typeUO):integer;pascal;
function fonctionTwaveList_WUcount(var pu:typeUO):integer;pascal;
function fonctionTwaveList_WU(n:integer;var pu:typeUO):pointer;pascal;
procedure proTwaveList_Att(w:integer;var pu:typeUO);pascal;
function fonctionTwaveList_Att(var pu:typeUO):integer;pascal;

procedure proTwaveList_SetMultiDisplay(w:boolean; I1,I2:integer;var pu:typeUO);pascal;


procedure proTwaveListA_create(NbUnit: integer; var pu:typeUO);pascal;
procedure proTwaveListA_create_1(NbUnit,tp,i1,i2:integer; var pu:typeUO);pascal;

procedure proTwaveListA_AddVector(var vec:Tvector;numU:integer; var pu:typeUO);pascal;
procedure proTwaveListA_UpdateVectors(var pu:typeUO);pascal;
procedure proTwaveListA_AddWaveList(var wl:TwaveList; var pu:typeUO);pascal;

implementation

{ TwaveList }

constructor TwaveList.create;
begin
  inherited;
  FuseStdColors:=true;
end;

destructor TwaveList.destroy;
begin
  setVectors(0);
  inherited;
end;

class function TwaveList.STMClassName: AnsiString;
begin
  result:='WaveList';
end;

procedure TwaveList.setVectors(nb: integer);
var
  i,oldnb:integer;
begin
  oldNb:=length(Wunit);
  WUcount:=nb;

  for i:=WUcount to oldNb-1 do    { si nb<oldNb, détruire les objets }
  begin
    Wunit[i].free;
    dataSpk[i].free;
  end;

  setLength(Wunit,WUcount);       { ajuster la taille des tableaux }
  setLength(dataSpk,WUcount);

  for i:=oldNb to WUcount-1 do    {si nb>oldNb, créer les objets }
  begin
    Wunit[i]:=TwaveList.create;
    dataSpk[i]:=nil;
    with Wunit[i] do
    begin
      notPublished:=true;
      Fchild:=true;
    end;
  end;

  ClearChildList;
  for i:=0 to WUcount-1 do
    addToChildList(Wunit[i]);

  setChildNames;
end;



procedure TwaveList.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;
  if not lecture then WUcountR:=WUcount;

  with conf do
    setvarconf('WUCount',WUcountR,sizeof(WUcount));

end;


function TwaveList.loadFromStream(f: Tstream; size: LongWord;
  Fdata: boolean): boolean;
var
  st1:string[255];
  ok:boolean;
  pos1, posIni: int64;
  i:integer;
  stID:AnsiString;
  OldstID:string[30];
  conf:TblocConf;
  n:integer;


function identifier(st:AnsiString;var n:integer):boolean;
var
  k,code:integer;
begin
  k:=length(ident);
  result:=(copy(st,1,k+1)=ident+'.');
  if not result then exit;

  delete(st,1,k+1);
  n:=0;
  if st='' then exit;

  if copy(st,1,2)='Wu' then
    begin
      delete(st,1,2);
      val(st,n,code);
      result:= (code=0) and (n>=0) and (n<=WUcount);
    end
  else result:=false;
end;

begin
  ok:=inherited loadFromStream(f,size,Fdata);
  result:=ok;

  if not ok then exit;

  if f.position>=f.Size  then
    begin
      result:=true;
      exit;
    end;


  setVectors(WUcountR);

  repeat
    posIni:=f.position;
    st1:=readHeader(f,size);

    if (st1=TwaveList.STMClassName) then
    begin
      pos1:=f.position;
      conf:=TblocConf.create(st1);
      conf.setvarConf('IDENT',OldstId,sizeof(OldstId));
      conf.setStringConf('IDENT1',stId);

      result:=(conf.lire1(f,size)=0);
      conf.free;
      f.Position:=pos1;
      if stId='' then stId:=OldStId;
                                                   {ident.VU1 }
      result:=identifier(stId,n);
      if result and (n>=0) and (n<length(Wunit))
        then result:=Wunit[n].loadFromStream(f,size,Fdata)
        else f.Position:=posini+size;
    end
    else
    begin
      result:=false;
      f.Position:=posini+size;
    end;
  until (f.position>=f.size) or not result;
  f.Position:=posini;

  setChildNames;
  result:=true;
end;


function TwaveList.loadFromStream1(f: Tstream; size: LongWord; Fdata: boolean): boolean;
begin
  result:=inherited loadFromStream(f,size,Fdata);
  setChildNames;
end;

procedure TwaveList.saveToStream(f: Tstream; Fdata: boolean);
var
  i:integer;
begin
  inherited saveToStream(f,Fdata);

  for i:=0 to WUcount-1 do Wunit[i].saveToStream(f,Fdata);
end;

procedure TwaveList.setChildNames;
var
  i:integer;
begin
  for i:=0 to high(Wunit) do
  with Wunit[i] do
  begin
    ident:=self.ident+'.Wu'+Istr(i);
    notPublished:=true;
    Fchild:=true;
    readOnly:=self.readOnly;
  end;
end;


procedure TwaveList.InitRawData(data1, dataAtt1: typeDataB);
var
  nb:array[0..255] of integer;
  bb:byte;
  i:integer;
  Usize:integer;
begin
  RawData:=data1;
  RawDataAtt:=dataAtt1;

  if assigned(data1)
    then FmaxIndex:=data1.indiceMax
    else FmaxIndex:=0;

  initForm;
  setIndex(-1);

  fillchar(nb,sizeof(nb),0);
  if assigned(RawdataAtt) then
  with RawdataAtt do
  for i:=indiceMin to indiceMax do
  begin
    bb:=getI(i);
    inc(nb[bb]);
  end;

  for i:=0 to WUcount-1 do
  begin
    Wunit[i].initTemp1(Istart,Iend,g_smallint);
    dataSpk[i].free;
    if assigned(Rawdata) then
    begin
      if RawData.EltSize=2
        then Usize:=totSize+ElphySpkPacketFixedSize
        else Usize:=RawData.EltSize;
      dataSpk[i]:=typeDataSegUExt.create(RAwdata,RAwdataAtt,i,1,nb[i],Usize); { objet sélectionnant un attribut }
    end
    else dataSpk[i]:=nil;
    Wunit[i].Att0:=i;
    Wunit[i].InitRawData(dataSpk[i],nil);

    Wunit[i].Dxu:=Dxu;
    Wunit[i].x0u:=x0u;
    Wunit[i].unitX:=unitX;

    Wunit[i].Dyu:=Dyu;
    Wunit[i].y0u:=y0u;
    Wunit[i].unitY:=unitY;

    Wunit[i].DxuSrc:=DxuSrc;
    Wunit[i].unitXsrc:=unitXsrc;
  end;

end;

procedure TwaveList.ReInitRawData;
begin
  InitRawData(RAwdata, RawDataAtt);
end;

procedure TwaveList.setIndex(n: integer);
var
  p:pointer;

begin
  if n=-1 then n:=windex;
  if n<1 then n:=1;
  if n>maxIndex then n:=maxindex;

  if (n>=1) and (n<=maxIndex) then
  begin
    p:=RawData.getP(n);
    if assigned(p) and (tb<>nil) then
    begin
      move(p^,curWrec,sizeof(curWrec));
      if assigned(RawDataAtt)
        then curWrec.unit1:=RawDataAtt.getI(n)
        else curWrec.unit1:=Att0;
      inc(intG(p), ElphySpkPacketFixedSize);

      move(p^,tb^,totSize);
      Windex:=n;
    end;
  end;
end;

function TwaveList.getCurrentTime: float;
begin
  result:=curWrec.ElphyTime*DxuSrc;
end;

function TwaveList.getTimeString: AnsiString;
begin
  result:=Estr(getCurrentTime,3)+ ' '+unitXsrc;
end;

function TwaveList.getUnitString: AnsiString;
begin
  result:= Istr(curWrec.unit1);
end;


procedure TwaveList.CreateForm;
begin
  form:=TWaveListForm.create(FormStm);
  with TWaveListForm(form) do
  begin
    beginDragG:=GbeginDrag;
    caption:=ident;
    color:=BKcolor;
    Uplot:=self;
    initForm;
  end;
end;



procedure TwaveList.initForm;
begin
  if assigned(form) then
  with TWaveListForm(form) do
  begin
    SBindex.setParams(Windex,1,maxIndex);
    cbHold.setVar(HoldMode);
    cbStdColors.setVar(FUseStdColors);

    BeforeBMpaint:=BeforeFormPaint;
    onBMpaint:=AfterFormPaint;

  end;
end;

procedure TwaveList.AfterPaint;
begin
  if FuseStdColors then visu.Color:=OldColor;
end;

procedure TwaveList.BeforePaint;
begin
  if FuseStdColors then
  begin
    OldColor:=visu.color;
    visu.color:=getStdColor(curWrec.unit1);
  end;
end;

procedure TwaveList.AfterFormPaint;
begin
  MultiIndexDisplay:=OldMultiMode;
end;

procedure TwaveList.BeforeFormPaint;
begin
  OldMultiMode:=MultiIndexDisplay;
  MultiIndexDisplay:=false;
end;

procedure TwaveList.CompleteLoadInfo;
begin
  inherited;
  if modeT=DM_EVT1 then modeT:=DM_line;
end;

procedure TwaveList.Display;
var
  i,i1,i2:integer;
  OldIndex:integer;
begin
  if MultiIndexDisplay  then
  begin
    OldIndex:=Windex;
    if MultiIndexStart<1 then i1:=1 else i1:=MultiIndexStart;
    if MultiIndexEnd>maxIndex then i2:=MaxIndex else i2:=MultiIndexEnd;

    for i:=i1 to i2 do
    begin
      setIndex(i);
      BeforePaint;
      if i=i1 then
      begin
         inherited Display;
         with getInsideWindow do setWindow(left,top,right,bottom);
      end
      else displayInside(nil,false,false,false);
      AfterPaint;
    end;
    Windex:=OldIndex;
    {MultiIndexDisplay:=false;}
  end
  else
  begin
    BeforePaint;
    inherited Display;
    AfterPaint;
  end;
end;

procedure TwaveList.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                                  const order:integer=-1);
begin
  BeforePaint;
  inherited displayInside(FirstUO,extWorld,logX,logY,order);
  AfterPaint;
end;

procedure TwaveList.setMultiIndex(w:boolean; I1, I2:integer);
begin
  MultiIndexDisplay:=w;
  MultiIndexStart:=I1;
  MultiIndexEnd:=I2;
end;


function TwaveList.getAtt: integer;
begin
  result:=curWrec.unit1;
end;

procedure TwaveList.SetAtt(w: integer);
begin

end;

procedure TwaveList.SavePacketList(f:Tstream;Const Times: Tvector=nil);
var
  p:pointer;
  i:integer;
begin
  for i:=1 to maxIndex do
  begin
    p:=RawData.getP(i);
    if assigned(p) and (tb<>nil) then
    begin
      if assigned(Times) then
        with Times do PWrec(p)^.ElphyTime:= Jvalue[Istart+ i-1];
      f.Write(p^, ElphySpkPacketFixedSize+totSize);
    end;
  end;
end;



function TwaveList.getMaxIndex: integer;
begin
  result:=FmaxIndex;
end;

function TwaveList.getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;
var
  OKmove:boolean;
  complexity:mxComplexity;
  classID:mxClassID;
  t:pointer;
  i,j:integer;
  i1,i2,Nx: integer;
  tpDest:typetypeG;
begin
  result:=nil;
  if not testMatlabMat then exit;
  if not testMatlabMatrix then exit;

  if (Icount<=0) then
  begin
    sortieErreur('TwaveList.SaveToMatFile : source is empty');
    exit;
  end;

  if tpDest0=G_none
    then tpDest:= g_double
    else tpDest:=tpDest0;

  if not (tpDest in MatlabTypes) then
  begin
    sortieErreur('Tvector.SaveToMatFile : invalid type');
    exit;
  end;

  classId:=TpNumToClassId(tpDest);
  complexity:=tpNumToComplexity(tpDest);

  result:=mxCreateNumericMatrix(Icount,maxIndex,classID,complexity);
  if result=nil then
  begin
    sortieErreur('TwaveList.SaveToMatFile : error 1');
    exit;
  end;

  t:= mxGetPr(result);
  if t=nil then
  begin
    sortieErreur('TwaveList.SaveToMatFile : error 2');
    exit;
  end;

  i1:= Istart;
  i2:= Iend;
  Nx:= Icount;

  case tpDest of
    G_byte:         for j:= 1 to maxIndex do
                    begin
                      setIndex(j);
                      for i:=i1 to i2 do PtabOctet(t)^[i-i1 + Nx*(j-1)]:=Jvalue[i];
                    end;

    G_short:        for j:= 1 to maxIndex do
                    begin
                      setIndex(j);
                      for i:=i1 to i2 do PtabShort(t)^[i-i1 + Nx*(j-1)]:=Jvalue[i];
                    end;
    G_smallint:     for j:= 1 to maxIndex do
                    begin
                      setIndex(j);
                      for i:=i1 to i2 do PtabEntier(t)^[i-i1 + Nx*(j-1)]:=Jvalue[i];
                    end;

    G_word:         for j:= 1 to maxIndex do
                    begin
                      setIndex(j);
                      for i:=i1 to i2 do PtabWord(t)^[i-i1 + Nx*(j-1)]:=Jvalue[i];
                    end;

    G_longint:      for j:= 1 to maxIndex do
                    begin
                      setIndex(j);
                      for i:=i1 to i2 do PtabLong(t)^[i-i1 + Nx*(j-1)]:=Jvalue[i];
                    end;

    G_single,
    G_singleComp:   for j:= 1 to maxIndex do
                    begin
                      setIndex(j);
                      for i:=i1 to i2 do PtabSingle(t)^[i-i1 + Nx*(j-1)]:=Yvalue[i];
                    end;

    G_double,
    G_doubleComp,
    G_real,
    G_extended:     for j:= 1 to maxIndex do
                    begin
                      setIndex(j);
                      for i:=i1 to i2 do PtabDouble(t)^[i-i1 + Nx*(j-1)]:=Yvalue[i];
                    end;

  end;

  t:= mxGetPi(result);
  if (complexity=mxComplex) and assigned(t) then
    if tpDest=g_singleComp then
      for j:= 1 to maxIndex do
      begin
        setIndex(j);
        for i:=i1 to i2 do PtabSingle(t)^[i-i1 + Nx*(j-1)]:=Imvalue[i];
      end
    else
      for j:= 1 to maxIndex do
      begin
        setIndex(j);
        for i:=i1 to i2 do PtabDouble(t)^[i-i1 + Nx*(j-1)]:=Imvalue[i];
      end;
end;


{ TwaveListA }


constructor TwaveListA.create;
begin
  inherited;
end;

destructor TwaveListA.destroy;
begin
  RawData.Free;
  RawDataAtt.Free;
  listG.Free;

  inherited;
end;

procedure TwaveListA.Init(NbUnit:integer; tp:typetypeG; i1,i2:integer);
var
  sz:integer;
begin
  initTemp1(i1,i2,tp);
  with flags do
  begin
    FmaxIndex:=false;
    Findex:= false;
    Ftype:= false;
  end;

  setVectors(NbUnit);
  sz:=tailleTypeG[tp]*(i2-i1+1)+ElphySpkPacketFixedSize;

  listG.Free;
  listG:=TlistG.create(sz);

  RawData:=TypeDataI.createStep(getPointer,sz,1,1,listG.Count);
  RawDataAtt:=TypeDataByte.createStep(AttPointer,sz,1,1,listG.Count);

  initRawData(RawData,RawDataAtt);
end;

procedure TwaveListA.AddVector(vec: Tvector; NumU:integer);
var
  pdest:pointer;

begin
  if maxindex=0 then
  begin
    with vec do init( WUcount, tpNum,Istart,Iend);
    dxu:=vec.Dxu;
    x0u:=vec.X0u;
    dyu:=vec.Dyu;
    y0u:=vec.y0u;
  end
  else
  if (vec.Istart<>Istart) or (vec.Iend<>Iend) or (vec.tpNum<>tpNum) or
     (vec.dxu<>dxu) or (vec.x0u<>X0u) or (vec.dyu<>dyu) or (vec.y0u<>y0u) then
     sortieErreur('TwaveListA.addvector : vector parameters do not match wavelist parameters');

  copyDataFrom(vec);

  pdest:=listG.AddEmpty;

  curWrec.unit1:=NumU;
  move(curWrec,pdest^,sizeof(curWrec));
  inc(intG(pdest),ElphySpkPacketFixedSize);
  move(tb^,pdest^,totsize);

  RawData.modifyData(getPointer);
  Rawdata.modifyLimits(1,listG.Count);

  RawDataAtt.modifyData(AttPointer);
  RawdataAtt.modifyLimits(1,listG.Count);

end;

procedure TwaveListA.AddWaveList(wl: TwaveList);
var
  i:integer;
  pdest:pointer;
begin
  dxu:=wl.Dxu;
  x0u:=wl.X0u;
  dyu:=wl.Dyu;
  y0u:=wl.y0u;

  for i:=1 to wl.maxIndex do
  begin
    wl.setIndex(i);

    copyDataFrom(wl);

    pdest:=listG.AddEmpty;

    curWrec.unit1:=wl.Att;
    move(curWrec,pdest^,sizeof(curWrec));
    inc(intG(pdest),ElphySpkPacketFixedSize);
    move(tb^,pdest^,totsize);
  end;

  RawData.modifyData(getPointer);
  Rawdata.modifyLimits(1,listG.Count);


  RawDataAtt.modifyData(AttPointer);
  RawdataAtt.modifyLimits(1,listG.Count);

end;

procedure TwaveListA.SetAtt(w: integer);
begin
  curWrec.unit1:=w;
  if (Windex>=1) and (Windex<=RawDataAtt.indiceMax)
    then RawDataAtt.setI(Windex,w);
end;

procedure TwaveListA.SavePacketList(f:Tstream;Const Times: Tvector=nil);
var
  i: integer;
begin
  if assigned(Times) then
  with Times do
  for i:=0 to listG.Count-1 do
    PWrec(listG[i])^.ElphyTime:= Jvalue[Istart+i];

  f.Write(listG.getPointer^,listG.EltSize*listG.Count);
end;

procedure TwaveListA.Clear;
begin
  listG.Clear;
  RawData.modifyData(nil);
  Rawdata.modifyLimits(1,0);

  RawDataAtt.modifyData(nil);
  RawdataAtt.modifyLimits(1,0);
end;

function TwaveListA.getMaxIndex: integer;
begin
  result:=listG.count;
end;


function TwaveListA.AttPointer: pointer;
begin
  result:= listG.getPointer;
  result:= @PWrec(result)^.unit1;
end;

function TwaveListA.DataPointer: pointer;
begin
  result:= listG.getPointer;
  inc(intG(result),ElphySpkPacketFixedSize);
end;


function TwaveListA.getAttValue(i: integer): byte;
begin
  if (i>=1) and (i<=RawDataAtt.indiceMax)
    then result:= RawDataAtt.getI(i);
end;

function TwaveListA.getPointer: pointer;
begin
  result:= listG.getPointer;
end;

                   { Méthode Stm de TwaveList }

procedure proTwaveList_UseStdColors(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TwaveList(pu) do
  begin
    FuseStdColors:=w;
    invalidate;
  end;
end;

function fonctionTwaveList_UseStdColors(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TwaveList(pu).FuseStdColors;
end;

procedure proTwaveList_Index(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TwaveList(pu) do
  begin
    if (w<1) or (w>maxIndex) then sortieErreur('TwaveList.Index : index out of range');
    setIndex(w);
  end;
end;

function fonctionTwaveList_Index(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TwaveList(pu).Windex;
end;

function fonctionTwaveList_MaxIndex(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TwaveList(pu).MaxIndex;
end;

function fonctionTwaveList_WUcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TwaveList(pu).WUcount;
end;

function fonctionTwaveList_WU(n:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TwaveList(pu) do
  begin
    if (n<0) or (n>=length(Wunit)) then sortieErreur('TwaveList.WU : index out of range');
    result:=@Wunit[n];
  end;
end;

procedure proTwaveList_Att(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TwaveList(pu) do
  begin
    if inf.readOnly then sortieErreur('TwaveList.Att : This object is ReadOnly');
    SetAtt(w);
  end;
end;

function fonctionTwaveList_Att(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TwaveList(pu).curWrec.unit1;
end;

procedure proTwaveList_SetMultiDisplay(w:boolean; I1,I2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TwaveList(pu).setMultiIndex(w, I1,i2);
end;


                   { Méthode Stm de TwaveListA }

procedure proTwaveListA_create(NbUnit: integer; var pu:typeUO);
begin
  createPgObject('',pu,TwaveListA);
  TwaveListA(pu).Init(NbUnit,g_smallint,0,0);
end;

procedure proTwaveListA_create_1(NbUnit,tp,i1,i2:integer; var pu:typeUO);
begin
  createPgObject('',pu,TwaveListA);
  TwaveListA(pu).Init(NbUnit,typetypeG(tp),i1,i2);
end;

procedure proTwaveListA_AddVector(var vec:Tvector;numU:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  TwaveListA(pu).Addvector(vec,numU);
end;

procedure proTwaveListA_UpdateVectors(var pu:typeUO);
begin
  verifierObjet(pu);
  TwaveListA(pu).ReinitRawData;
end;

procedure proTwaveListA_AddWaveList(var wl:TwaveList; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(wl));
  TwaveListA(pu).AddWaveList(wl);
end;






end.

