unit revcor2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,sysutils, dialogs,controls,math,
     util1,Dgraphic,dtf0,spk0,Dtrace1,
     stmdef, stmObj,stmData0,stmvec1,stmmat1,varconf1,debug0,
     revPan2,
     stmOdat2,stmAveA1,stmAve1,stmPsth1,stmCorA1,stmMatA1,
     stmError,Ncdef2,stmPg,

     stmFFT,
     IPPS,IPPdefs,IPPSovr,

     VlistA1,
     D7random1;


(*
Les structures suivantes sont déclarées dans revPan1:

  TRCAinfo=record
             dataVec:Tvector;        {vecteur contenant les ev data}
             stEvt:string[255];      {fichier contenant les ev stim}

             tmaxi,dt0:double;       {Les psths de base sont calculés pour
                                      toutes les tranches de largeur dt0
                                      entre -tmaxi et +tmaxi }
             t,dt:double;            {Paramètres pour la matrice courante}


             AutoScale:boolean;      {Flag autoscale}
             seuilZ:double;          {Seuil de significativité=2.57}
             optiAvecSeuil:boolean;  {Flag entrainant un seuillage des cartes optimales}
           end;

  TRCAinfo1=record
              Nmoyen,Nsig:double;
              ZupRaw,ZupOpt:array[1..2] of double;
              nbPixelOpt:array[1..2] of integer;

            end;

  CalculPsth:

  CalculeMat: calcule les  deux matrices correspondant à la tranche de temps [t,t+dt[
    en se basant sur le contenu des psths
    On calcule aussi les 2 matrices anterogrades avec la moyenne et l'écart-type.

  calculeOptima: calcule les deux matrices correspondant à une tranche de temps [t,t+dt[
    en se basant sur le contenu des psths et en donnant à t toutes les valeurs possibles
    entre -tmax et +tmax. On garde pour chaque pixel la valeur la plus élevée et on range
    dans les matrices latence la valeur de t correspondante.

    Les cartes optimales sont seuillées si OptiAvecSeuil est vrai.

  calculate appelle successivement calculePsth, calculeMat et calculeOptima.

*)

const
  m1=1;
  m2=2;
  mopt1=3;
  mopt2=4;
  mlat1=5;
  mlat2=6;
  mante1=7;
  mante2=8;

  nbmatRCA=8;

  Nz=2;

type
  Tcode=record
          date:integer;
          code:smallint; {code de 0 à nx*ny*nz-1}
          fp:single;
        end;
  TtabCode=array[1..1000] of Tcode;
  PtabCode=^TtabCode;

  TPsdMatRec= record
                x1,x2,dx1:float;
                Nfft,Nb:integer;
                i1,i2:integer;
                Count:integer;
                WindowMode:integer;
                Fpsd:byte;
              end;

type
  TrevcorAnalysis=
    class(Tdata0)
    private
      mat:array[1..nbmatRCA] of Tmatrix;


      FDataVecB:Tvector;   {image pour sauvegarde}

      nbDivX0,nbDivY0,expansion0,scotome0:integer; {Valeurs fournies par installSequence}

      Nx,Ny:integer;      {Valeurs calculées par installSequence}



      Plist:Tlist;          {liste des psths.
                          Il y a  nx*ny*nz psths d'indices ipmin à ipmax
                          La liste contient des pointeurs sur des tableaux
                          d'entiers longs.
                          }
      strucSize:integer; {taille de chaque psth}

      codes:PtabCode;    { Ce tableau reçoit:
                            - les codes lus dans le fichier EVT ou calculés avec
                              installeSequence
                            - les dates lues dans le fichier EVT ou provenant
                              d'un vecteur (InstallTimes)
                          }
      codesSize:integer; { taille de ce tableau}
      nbTot:integer;     { nb d'evt-stim rangés dans codes}
      dxEvt:double;      { Param d'échelle pour les dates evt }

      psths:array[1..2] of TvectorArray;

      sourcePstw:Tvector;
      pstw:array[1..2] of TaverageArray;

      pstac:array[1..2] of TcorrelogramArray;

      PsdMatRec:TPsdMatRec;
      sourcePsdMat:Tvector;
      psdMat:array[1..2] of TmatrixArray;


      function ipmin:integer;
      function ipmax:integer;
      function ip1:integer;
      function nbip:integer;

      function controlePsth(i,j,k,l:integer):boolean;
      procedure setPsth(i,j,k,l:integer;x:integer);
      function getPsth(i,j,k,l:integer):integer;
      procedure incPsth(code0,l:integer);

      function encode(x,y,z:integer):integer;
      procedure decode(code:integer;var x,y,z:integer); {x,y,z commencent à zéro}

      function getX(code:integer):integer;
      function getY(code:integer):integer;
      function getZ(code:integer):integer;

      procedure clearUp;

      procedure setDataVec(v:Tvector);

      procedure freeCodes;
      procedure loadEvt;

      procedure installSequence(seed,nbDivX,nbDivY,expansion,scotome:integer);
      procedure InstallTimes(vec:Tvector;dx:float);
      procedure InstallFP(vec:Tvector);

      procedure DumpCodes;
    public
      info:TrcaInfo;
      resultat:TrcaInfo1;

      nbPstW:integer;
      x1pstW,x2PstW:float;


      x1pstAc,x2Pstac:float;

      constructor create;override;
      destructor destroy;override;

      procedure  initChildList;override;
      class function STMClassName:AnsiString;override;

      procedure setChildNames;

      function initialise(st:AnsiString):boolean;override;
      procedure createForm;override;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
        override;

      procedure completeLoadInfo;override;

      procedure saveToStream(f:Tstream;Fdata:boolean);override;
      function  loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;


      procedure RetablirReferences(list:Tlist);override;
      procedure resetAll;override;

      procedure processMessage(id:integer;source:typeUO;p:pointer);
                override;


      property psth[i,j,k,l:integer]:integer read getPsth write setPsth;

      function InitPsth:boolean;

      procedure CalculPsth(clear:boolean);

      procedure calculeOptima;
      procedure calculSeuil;
      procedure CalculOptimaSeuil;
      procedure calculeMat;

      procedure Calculate;
      procedure Add;
      procedure clearPsth;

      procedure calculZupRaw;

      procedure scrolltG(x:float);
      procedure scrollDtG(x:float);

      procedure calculOptiG;

      property DataVec:Tvector read info.DataVec write setDataVec;

      procedure getStimsXYZ(x1,y1,z1:integer;var v:Tvector);
      function getTimeXYZ(x1,y1,z1:integer):float;

      procedure initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);
      procedure calculatePstw;


      procedure initPstac(cor1,cor2:TcorrelogramArray;
                          i1,i2:integer;classe,x1,x2:float);
      procedure calculatePstac;

      procedure initPsdMat(var1,var2:TmatrixArray;source:Tvector;
                                     x1,x2,dx1:float;Nfft,Nb,WM:integer;Fpsd:byte);
      procedure calculatePsdMat;
      procedure NormPsdMat;

      procedure InitResponses(source:Tvector;va1,va2:TvectorArray;
                                        x1,x2:float;tp:typetypeG);

      procedure Responses(source:Tvector;va1,va2:TvectorArray;x1,x2:float;mode:integer);

      procedure Responses1(seqs,evts:TVlist;seeds:Tvector;va1,va2:TvectorArray;
                       x1,x2,dx1:float;mode:integer);

      procedure getMatXYZ(mat1,mat2:Tmatrix);
      procedure getCodes(vec: Tvector;num:integer);

      procedure FreeRef;override;
    end;


procedure proTrevCorAnalysis_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTrevCorAnalysis_installSource(var source1:Tvector;var pu:typeUO);pascal;

procedure proTrevCorAnalysis_installEvtFile(st:AnsiString;var pu:typeUO);pascal;

procedure proTrevCorAnalysis_installStimSeq(seed,nbDivX,nbDivY,expansion,scotome:integer;
                                            var pu:typeUO);pascal;
procedure proTrevCorAnalysis_installTimes(var vecEvt:Tvector;dx:float;
                                             var pu:typeUO);pascal;
procedure proTrevCorAnalysis_installFP(var vec:Tvector;var pu:typeUO);pascal;


procedure proTrevCorAnalysis_Tmaxi(w:float;var pu:typeUO);pascal;
function fonctionTrevCorAnalysis_Tmaxi(var pu:typeUO):float;pascal;

procedure proTrevCorAnalysis_Dt0(w:float;var pu:typeUO);pascal;
function fonctionTrevCorAnalysis_Dt0(var pu:typeUO):float;pascal;

procedure proTrevCorAnalysis_t(w:float;var pu:typeUO);pascal;
function fonctionTrevCorAnalysis_t(var pu:typeUO):float;pascal;

procedure proTrevCorAnalysis_Dt(w:float;var pu:typeUO);pascal;
function fonctionTrevCorAnalysis_Dt(var pu:typeUO):float;pascal;


procedure proTrevCorAnalysis_Zthreshold(w:float;var pu:typeUO);pascal;
function fonctionTrevCorAnalysis_Zthreshold(var pu:typeUO):float;pascal;

procedure proTrevCorAnalysis_UseThreshold(w:boolean;var pu:typeUO);pascal;
function fonctionTrevCorAnalysis_UseThreshold(var pu:typeUO):boolean;pascal;

procedure proTrevCorAnalysis_ClearPsth(var pu:typeUO);pascal;
procedure proTrevCorAnalysis_calculatePsth(var pu:typeUO);pascal;
procedure proTrevCorAnalysis_calculateMatrix(var pu:typeUO);pascal;
procedure proTrevCorAnalysis_calculateOptMatrix(var pu:typeUO);pascal;


function fonctionTrevCorAnalysis_m1(var pu:typeUO):pointer;pascal;
function fonctionTrevCorAnalysis_m2(var pu:typeUO):pointer;pascal;
function fonctionTrevCorAnalysis_mopt1(var pu:typeUO):pointer;pascal;
function fonctionTrevCorAnalysis_mopt2(var pu:typeUO):pointer;pascal;
function fonctionTrevCorAnalysis_mlat1(var pu:typeUO):pointer;pascal;
function fonctionTrevCorAnalysis_mlat2(var pu:typeUO):pointer;pascal;
function fonctionTrevCorAnalysis_mante1(var pu:typeUO):pointer;pascal;
function fonctionTrevCorAnalysis_mante2(var pu:typeUO):pointer;pascal;

function fonctionTrevCorAnalysis_psths(num:integer;var pu:typeUO):pointer;pascal;


function fonctionTrevCorAnalysis_mat(num:smallint;var pu:typeUO):pointer;pascal;

function fonctionTrevCorAnalysis_PixelsAbove(num:integer;var pu:typeUO):integer;pascal;
function fonctionTrevCorAnalysis_Zabove(num:integer;var pu:typeUO):float;pascal;

function fonctionTrevCorAnalysis_Nmean(var pu:typeUO):float;pascal;
function fonctionTrevCorAnalysis_Nstd(var pu:typeUO):float;pascal;

procedure proTrevCorAnalysis_getStimsXYZ(x,y,z:integer;var v:Tvector;
              var pu:typeUO);pascal;

function fonctionTrevCorAnalysis_getTimeXYZ(x,y,z:integer;var pu:typeUO):float;pascal;



function fonctionTrevCorAnalysis_PosCount(var pu:typeUO):longint;pascal;
function fonctionTrevCorAnalysis_Nx(var pu:typeUO):longint;pascal;
function fonctionTrevCorAnalysis_Ny(var pu:typeUO):longint;pascal;


function fonctionTrevCorAnalysis_Codes(i:integer;var pu:typeUO):integer;pascal;
function fonctionTrevCorAnalysis_Xpos(i:integer;var pu:typeUO):integer;pascal;
function fonctionTrevCorAnalysis_Ypos(i:integer;var pu:typeUO):integer;pascal;
function fonctionTrevCorAnalysis_Zpos(i:integer;var pu:typeUO):integer;pascal;

function fonctionTrevCorAnalysis_encode(x,y,z:integer;var pu:typeUO):integer;pascal;
procedure proTrevCorAnalysis_decode(code:integer;var x,y,z:integer;var pu:typeUO);pascal;

procedure proSelectEvents(var source,dest,Csource,Cdest:Tvector;Cmin,Cmax:float);pascal;
procedure proSelectEvents1(var source,Csource:Tvector;Cmin,Cmax:float);pascal;

procedure proTrevCorAnalysis_calculatePstw(var pu:typeUO);pascal;
procedure proTrevCorAnalysis_initPstw(var v1,v2:TaverageArray;var source:Tvector;
                                      x1,x2:float;var pu:typeUO);pascal;



procedure proTrevCorAnalysis_calculatePstac(var pu:typeUO);pascal;
procedure proTrevCorAnalysis_initPstac(var cor1,cor2:pointer;i1,i2:integer;classe,x1,x2:float;var pu:typeUO);pascal;

function fonctionFindRevCorSeed(var seed:integer;
           nbDivX,nbDivY,expansion,scotome:integer;var Vcode:Tvector):boolean;pascal;


procedure proTrevCorAnalysis_initPsdMat(var m1,m2:TmatrixArray;var source:Tvector;
                                     x1,x2,dx1:float;Nfft,Nb,WM:integer;modePsd:integer;
                                     var pu:typeUO);pascal;
procedure proTrevCorAnalysis_CalculatePsdMat(var pu:typeUO);pascal;
procedure proTrevCorAnalysis_NormPsdMat(var pu:typeUO);pascal;

procedure proTrevCorAnalysis_InitResponses(var source:Tvector;var va1,va2:TvectorArray;
                                      x1,x2:float;tp:integer;var pu:typeUO);pascal;

procedure proTrevCorAnalysis_Responses(var source:Tvector;var va1,va2:TvectorArray;
                                      x1,x2:float;mode:integer;var pu:typeUO);pascal;

procedure proTrevCorAnalysis_Responses1(var seqs,evts:TVlist;var seeds:Tvector;
                     var va1,va2:TvectorArray;x1,x2,dx1:float;mode:integer;var pu:typeUO);pascal;

procedure proTrevcorAnalysis_getMatXYZ(var mat1,mat2: Tmatrix;var pu:typeUO);pascal;                     
procedure proTrevcorAnalysis_getCodes(var vec: Tvector;num:integer;var pu:typeUO);pascal;

implementation

var
  E_nbc:integer;
  E_affectation:integer;
  E_numMat:integer;
  E_12:integer;
  E_getStimsXYZ:integer;
  E_numDistri:integer;
  E_code:integer;
  E_average:integer;
  E_installTimes:integer;
  E_installFP:integer;
  E_pstac:integer;
  E_psdmat1:integer;
  E_response:integer;
  E_InitResponse:integer;

constructor TrevCorAnalysis.create;
var
  i:integer;
begin
  inherited;

  for i:=1 to nbmatRCA do
    begin
      mat[i]:=Tmatrix.create;
      mat[i].initTemp(0,5,0,5,g_longint);
      {mat[i].visu.inverseY:=true;}
      mat[i].Fchild:=true;
    end;

  Plist:=Tlist.create;


  with info do
  begin
    tmaxi:=0.200;
    dt0:=0.001;

    t:=0;
    dt:=0.050;

    autoscale:=true;
    SeuilZ:=3;
  end;

  for i:=1 to 2 do
    begin
      psths[i]:=TvectorArray.create;
      psths[i].Fchild:=true;
    end;

  initChildList;
end;

procedure  TrevCorAnalysis.initChildList;
var
  i:integer;
begin
   for i:=1 to nbmatRCA do AddToChildList(mat[i]);

   for i:=1 to 2 do AddTochildList(psths[i]);

end;

destructor TrevCorAnalysis.destroy;
var
  i:integer;
begin
  clearUp;
  Plist.free;
  freeCodes;

  derefObjet(typeUO(info.dataVec));

  derefObjet(typeUO(pstw[1]));
  derefObjet(typeUO(pstw[2]));

  derefObjet(typeUO(pstac[1]));
  derefObjet(typeUO(pstac[2]));

  derefObjet(typeUO(psdMat[1]));
  derefObjet(typeUO(psdMat[2]));


  derefObjet(typeUO(sourcePstw));
  derefObjet(typeUO(sourcePsdMat));

  for i:=1 to nbmatRCA do mat[i].free;

  for i:=1 to 2 do psths[i].free;


  inherited;
end;


class function TrevCorAnalysis.STMClassName:AnsiString;
begin
  result:='RevCorAnalysis';
end;


procedure TrevCorAnalysis.setChildNames;
var
  i:integer;
begin
    mat[1].ident:=ident+'.M1';
    mat[2].ident:=ident+'.M2';

    mat[3].ident:=ident+'.Mopt1';
    mat[4].ident:=ident+'.Mopt2';

    mat[5].ident:=ident+'.Mlat1';
    mat[6].ident:=ident+'.Mlat2';

    mat[7].ident:=ident+'.Mante1';
    mat[8].ident:=ident+'.Mante2';

    psths[1].ident:=ident+'.psths1';
    psths[2].ident:=ident+'.psths2';

end;

function TrevCorAnalysis.initialise(st:AnsiString):boolean;
begin
  result:=inherited initialise(st);

  setChildNames;
end;

procedure TrevCorAnalysis.createForm;
begin
  form:=TrevPanel.create(formStm);

  with TrevPanel(form) do
  begin
    caption:=ident;
    loadEvtFileP:=loadEvt;
    calculPsthP:=Calculate;
    scrollTP:=scrolltG;
    scrollDTP:=scrollDtG;

    calculOptiP:=calculOptiG;

    init(self,info,resultat);
  end;
end;

procedure TrevCorAnalysis.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);


  conf.setvarConf('Info',info,sizeof(info));
end;

procedure TrevCorAnalysis.completeLoadInfo;
var
  i:integer;
begin
  inherited;
  FdatavecB:=info.dataVec;

  info.dataVec:=nil;
  {
  fillchar(info.vc,sizeof(info.vc),0);
  info.nbc:=0;
  }
end;

procedure TrevCorAnalysis.saveToStream(f:Tstream;Fdata:boolean);
var
  i:integer;
begin
  inherited saveToStream(f,Fdata);

  for i:=1 to nbmatRCA do mat[i].saveToStream(f,Fdata);

  for i:=1 to 2 do psths[i].saveToStream(f,Fdata);

end;

function TrevCorAnalysis.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
  var
    st1:string[255];
    posf:LongWord;
    ok1:boolean;
    posIni:LongWord;
    i:integer;
    n:integer;
    p:typeUO;
  begin
    result:=inherited loadFromStream(f,size,Fdata);

    if not result then exit;

    if f.position>=f.size then exit;

    i:=1;
    ok1:=true;
    while (i<=nbmatRCA) and ok1 do
    begin
      posIni:=f.position;
      st1:=readHeader(f,size);

      result:=(st1=Tmatrix.stmClassName) and
           (mat[i].loadFromStream(f,size,Fdata));

      if not result then
        begin
           f.Position:=Posini;
           ok1:=false;
         end
      else mat[i].initTemp(0,5,0,5,g_longint);
      inc(i);
    end;

    for i:=1 to 2 do
      begin
        posIni:=f.position;
        st1:=readHeader(f,size);
        result:=(st1=TvectorArray.stmClassName) and
          (psths[i].loadFromStream(f,size,Fdata));

        if not result then f.Position:=Posini;
      end;


    setChildNames;
    formRec.restoreFormXY(form,createForm);
  end;



procedure TrevCorAnalysis.RetablirReferences(list:Tlist);
var
  i,j:integer;
  p:pointer;
begin
  for i:=0 to list.count-1 do
    begin
     p:=typeUO(list.items[i]).myAd;

     if p=FdataVecb then
       begin
         info.dataVec:=list.items[i];
         refObjet(info.dataVec);
       end;

    end;
end;

procedure TrevCorAnalysis.resetAll;
begin
  if assigned(form) then
    with TrevPanel(form) do init(self,info,resultat);
end;


procedure TrevCorAnalysis.processMessage(id:integer;source:typeUO;p:pointer);
var
  i:integer;
begin
  if not assigned(source) then exit;

  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        if (dataVec=source) then
          begin
            derefObjet(typeUO(info.dataVec));
            info.dataVec:=nil;
          end;

        for i:=1 to 2 do
          if (pstac[i]=source) then
            begin
              derefObjet(typeUO(pstac[i]));
              pstac[i]:=nil;
            end;

        if (sourcePstw=source) then
          begin
            derefObjet(typeUO(sourcePstw));
            sourcePstw:=nil;
          end;


        for i:=1 to 2 do
          if (pstw[i]=source) then
            begin
              derefObjet(typeUO(pstw[i]));
              pstw[i]:=nil;
            end;

        for i:=1 to 2 do
          if (psdMat[i]=source) then
            begin
              derefObjet(typeUO(psdMat[i]));
              psdMat[i]:=nil;
            end;

        if (sourcePsdMat=source) then
          begin
            derefObjet(typeUO(sourcePsdMat));
            sourcePsdMat:=nil;
          end;

      end;

  end;
end;


procedure TrevCorAnalysis.scrolltG(x:float);
var
  i:integer;
begin
  info.t:=x;
  calculeMat;
  calculeOptima;
end;

procedure TrevCorAnalysis.scrollDtG(x:float);
var
  i:integer;
begin
  info.dt:=x;
  calculeMat;
  calculeOptima;
end;


procedure TrevCorAnalysis.clearUp;
var
  i:integer;
begin
  for i:=0 to Plist.count-1 do freemem(Plist.items[i],strucSize);
  Plist.clear;
end;


function TrevCorAnalysis.ipmin:integer;
begin
  with info do ipmin:=round(-tmaxi/dt0);
end;

function TrevCorAnalysis.ipmax:integer;
begin
  with info do ipmax:=round(tmaxi/dt0);
end;

function TrevCorAnalysis.ip1:integer;
begin
  with info do ip1:=round(t/dt0);
end;

function TrevCorAnalysis.nbip:integer;
begin
  with info do nbip:=round(dt/dt0);
end;

function TrevCorAnalysis.InitPsth:boolean;
var
  i:integer;
  p:pointer;
  dat:typedataL;
  x,y,z:integer;
begin
  clearUp;

  result:=(nx>0) and (nx<100) and (ny>0) and (ny<100);
  if not result then exit;


  strucSize:=(ipmax-ipmin+1)*4;

  psths[1].initarray(1,nx,1,ny);
  psths[2].initarray(1,nx,1,ny);



  for i:=0 to nx*ny*2-1 do
    begin
      getmem(p,strucSize);
      fillchar(p^,strucSize,0);
      Plist.add(p);

      decode(i,x,y,z);
      dat:=typeDataL.create(p,1,ipmin,ipmin,ipmax);
      psths[z+1].initVectorEx(x+1,y+1,dat,g_longint);
    end;

  for i:=1 to 2 do psths[i].initChildList;

  DumpCodes;
end;

function TrevCorAnalysis.controlePsth(i,j,k,l:integer):boolean;
var
  num:integer;
begin
  num:=ny*2*i+2*j+k;
  result:=(num>=0) and (num<Plist.count)
          and
          (l>=Ipmin) and (l<=Ipmax);
end;

procedure TrevCorAnalysis.setPsth(i,j,k,l:integer;x:integer);
begin
  if not controlePsth(i,j,k,l) then exit;
  Ptablong(Plist.items[ny*2*i+2*j+k])^[l-IpMin]:=x;
end;

function TrevCorAnalysis.getPsth(i,j,k,l:integer):integer;
begin
  if not controlePsth(i,j,k,l) then exit;
  result:=  Ptablong(Plist.items[ny*2*i+2*j+k])^[l-Ipmin];
end;

procedure TrevCorAnalysis.incPsth(code0,l:integer);
begin
  if (code0<0) or (code0>=nx*ny*2) or (l<Ipmin) or (l>Ipmax) then
    begin
      messageCentral('code='+Istr(code0)+' '+Istr(l));
      exit;
    end;

  {messageCentral('code='+Istr(code0)+' ip= '+Istr(l)+' '+Istr(IpMin));}  
  inc(Ptablong(Plist.items[code0])^[l-IpMin]);
end;


procedure TrevCorAnalysis.decode(code:integer;var x,y,z:integer);
begin
  z:=code mod Nz;
  code:=(code-z) div nz;
  y:=code mod ny;
  x:=(code-y) div ny;
end;

function TrevCorAnalysis.encode(x,y,z:integer):integer;
begin
  result:=z+nz*(y+ny*x);
end;

function TrevCorAnalysis.getX(code:integer):integer;
var
  x,y,z:integer;
begin
  z:=code mod Nz;
  code:=(code-z) div nz;
  y:=code mod ny;
  result:=(code-y) div ny;
end;

function TrevCorAnalysis.getY(code:integer):integer;
var
  x,y,z:integer;
begin
  z:=code mod Nz;
  code:=(code-z) div nz;
  result:=code mod ny;
end;

function TrevCorAnalysis.getZ(code:integer):integer;
var
  x,y,z:integer;
begin
  result:=code mod Nz;
end;


procedure TrevCorAnalysis.freeCodes;
begin
  if codes<>nil then freemem(codes,codesSize);
  codes:=nil;
  codesSize:=0;
end;

procedure TrevCorAnalysis.loadEvt;
var
  i,x,y,z:integer;
  ev0:typeSP;

  f:TfileStream;
  res:intG;
  infoSP:typeInfoSpk;
  ok:boolean;
begin
  f:=nil;
  try
  f:=TfileStream.Create(info.stEvt,fmOpenReadWrite);

  infoSP.charger(f,ok);
  if not ok then
    begin
      messageCentral('Error loading '+info.stEvt);
      f.free;
      exit;
    end;

  dxEvt:=infoSP.deltaX;

  f.Position:=infoSP.tailleInfo;

  f.read(ev0,sizeof(ev0));  {écarter l'événement zéro }

  f.read(ev0,sizeof(ev0));  {lire nx}
  nx:=ev0.x div 2;

  f.read(ev0,sizeof(ev0));  {lire ny}
  ny:=ev0.x div 2;

  f.read(ev0,sizeof(ev0));  {lire nz}

  nbtot:=(f.Size-infoSP.tailleInfo) div sizeof(typeSP) -4;

  freeCodes;
  CodesSize:=sizeof(Tcode)*nbtot;
  getmem(codes,CodesSize);

  for i:=1 to nbtot do
    begin
      f.read(ev0,sizeof(ev0));
      codes^[i].date:=ev0.date;
      codes^[i].code:=ev0.x div 2-1;
      codes^[i].fp:=1;
    end;

  f.free;
  except
  f.free;
  end;
end;

procedure TrevCorAnalysis.DumpCodes;
var
  i:integer;
  f:Text;
begin
  assign(f,debugPath+'codes.txt');
  try
  rewrite(f);
  for i:=1 to nbtot do
    with codes^[i] do writeln(f,Istr1(date,6)+Istr1(code,6));
  close(f);

  except
  close(f);
  end;
end;

procedure TrevCorAnalysis.installSequence(seed,nbDivX,nbDivY,expansion,scotome:integer);
  type
    Tmemomat=array [1..2,0..80,0..80] of boolean;
  var
    MemoMat : ^Tmemomat;

    i, j, k: integer;
    Xinf,Xsup,Yinf,Ysup:integer;

    x,y,contrast:integer;

  begin
    nbDivX0:=nbDivX;
    nbDivY0:=nbDivY;
    expansion0:=expansion;
    scotome0:=scotome;

    nX := roundI(nbDivX*Expansion/100.0);
    nY := roundI(nbDivY*Expansion/100.0);
    if (nx>=80) or (ny>=80) then exit;

    freeCodes;

    new(memomat);
    GsetRandSeed(Seed);

    fillchar(memoMat^,sizeof(memoMat^),0);
    nbTot :=nx*ny*2;

    XInf := roundI(nX/2.0 - nbDivX*(Scotome/100)/2.0);
    XSup := roundI(nX/2.0 + nbDivX*(Scotome/100)/2.0) -1;
    YInf := roundI(nY/2.0 - nbDivY*(Scotome/100)/2.0);
    YSup := roundI(nY/2.0 + nbDivY*(Scotome/100)/2.0) -1;

    if (Scotome <> 0) then
      for i:= XInf to XSup do
        for j:= YInf to YSup do
          for k:=1 to 2 do
            begin
              MemoMat^[k,i,j]:=TRUE;
              dec(nbTot);
            end;

    CodesSize:=sizeof(Tcode)*nbtot;
    getmem(codes,CodesSize);
    fillchar(codes^,codesSize,0);


    for i:= 1 to nbTot-1 do
      with codes^[i] do
      begin
        repeat
           X := Grandom(nX);
           Y := Grandom(nY);
           contrast := Grandom(2)+1;
           code:=contrast-1+nz*y+nz*ny*x;
           fp:=1;
        until (MemoMat^[contrast,X,Y] = FALSE);
        MemoMat^[contrast,X,Y] := TRUE;
      end;

    for i:=0 to nX-1 do
      for j:=0 to nY-1 do
        for k:=1 to 2 do
          if MemoMat^[k,i,j]=FALSE then
            with codes^[nbTot] do
            begin
              X := i;
              Y := j;
              contrast := k;
              code:=contrast-1+nz*y+nz*ny*x;
              fp:=1;
              dispose(memomat);
              exit;
            end;
  end;

function FindSeed(var seed:integer;
           nbDivX,nbDivY,expansion,scotome:integer;Wcodes:PtabEntier1):boolean;
type
  Tmemomat=array [1..2,0..80,0..80] of boolean;
var
  MemoMat : ^Tmemomat;
  i,j,k,s:integer;
  nbtot:integer;
  nx,ny:integer;
  Xinf,Xsup,Yinf,Ysup:integer;


function testSeed(ss:integer):boolean;
var
  i, j, k: integer;
  x,y,contrast,code:integer;

begin
  GsetRandSeed(ss);

  result:=false;
  fillchar(memoMat^,sizeof(memoMat^),0);
  if (Scotome <> 0) then
    for i:= XInf to XSup do
      for j:= YInf to YSup do
        for k:=1 to 2 do
          MemoMat^[k,i,j]:=TRUE;

  for i:= 1 to nbTot-1 do
    begin
      repeat
         X := Grandom(nX);
         Y := Grandom(nY);
         contrast := Grandom(2)+1;
      until (MemoMat^[contrast,X,Y] = FALSE);
      code:=contrast-1+nz*y+nz*ny*x;
      if code<>Wcodes^[i] then exit;
      MemoMat^[contrast,X,Y] := TRUE;
    end;

  for i:=0 to nX-1 do
    for j:=0 to nY-1 do
      for k:=1 to 2 do
        if MemoMat^[k,i,j]=FALSE then
          begin
            X := i;
            Y := j;
            contrast := k;
            code:=contrast-1+nz*y+nz*ny*x;
            if code<>Wcodes^[nbtot] then exit;
          end;

  result:=true;
end;


begin
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);
  if (nx>=80) or (ny>=80) then exit;

  XInf := roundI(nX/2.0 - nbDivX*(Scotome/100)/2.0);
  XSup := roundI(nX/2.0 + nbDivX*(Scotome/100)/2.0) -1;
  YInf := roundI(nY/2.0 - nbDivY*(Scotome/100)/2.0);
  YSup := roundI(nY/2.0 + nbDivY*(Scotome/100)/2.0) -1;

  nbTot :=nx*ny*2;
  if (Scotome <> 0) then
    nbtot:=nbtot-(Xsup-Xinf+1)*(Ysup-Yinf+1)*2;

  new(memomat);

  for s:=0 to 65535 do
    begin
      result:=testSeed(s);
      if result then
        begin
          seed:=s;
          dispose(memoMat);
          exit;
        end;
    end;

    
  dispose(memoMat);
end;

procedure TrevCorAnalysis.InstallTimes(vec:Tvector;dx:float);
var
  i:integer;
begin
  dxEvt:=dx;
  for i:=1 to nbtot do codes^[i].date:=roundL(vec.Yvalue[i]/dxEvt);
end;

procedure TrevCorAnalysis.InstallFP(vec:Tvector);
var
  i:integer;
begin
  for i:=1 to nbtot do codes^[i].fp:=vec.Yvalue[i];
end;

procedure TrevCorAnalysis.CalculPsth(clear:boolean);
var
  i,j,i0,i1:longint;
  ip:integer;

  dtmin,dtmax:double;
  date:double;

  EventIend:integer;
  n:integer;
  dateCode:double;
begin

  dtmax:=(ipmax+1)*info.dt0;
  dtmin:=ipmin*info.dt0;

  if clear then
    if not initPsth then exit;

  for i:=1 to nbmatRCA do
  begin
    mat[i].initTemp(1,nx,1,ny,g_longint);
    mat[i].autoscaleX;
    mat[i].autoscaleY;
  end;
  EventIend:=DataVec.Iend;

  i0:=-1;
  i1:=DataVec.Istart-1;

  n:=0;
  while n<nbtot do
  begin
    inc(n);   {lire top synchro }
    dateCode:=codes^[n].date*dxEvt;

    if i1>=EventIend then exit;

    if codes^[n].fp>0 then
    begin
      repeat
        inc(i1);                         {incrémenter i1 jusqu'à l'obtention }
        date:=DataVec.Yvalue[i1];          {d'une date utile pour le psth }
      until (i1>=EventIend) or (date>=dateCode+dtmin);

      dec(i1);

      i:=i1+1;                           {accumuler les ev jusqu'à dépassement }
      date:=DataVec.Yvalue[i];             {de la date maximale }

      while (i<=EventIend) and (date<dateCode+dtmax) do
      begin
        date:=DataVec.Yvalue[i];
        ip:= floor((date-dateCode)/info.dt0);
        if (ip>=ipmin) and (ip<=ipmax)
          then incPsth(codes^[n].code,ip);

        inc(i);
      end;
    end;
  end;

end;




procedure TrevCorAnalysis.calculeMat;
var
  i,j,l,m,l2:integer;
  max:integer;
begin
  with info do
  begin
    max:=ip1+nbip-1;
    if max>ipmax then max:=ipmax;

    for m:=1 to 2 do
    with mat[m] do
    begin
      data.raz;

      for l:=ip1 to max do
        for i:=Istart to Iend do
          for j:=Jstart to Jend do
            data.addI(i,j,psth[i-1,j-1,m-1,l]);
    end;
  end;

  for i:=1 to 2 do
    begin
      if info.autoscale then mat[i].autoscaleZ;
      mat[i].invalidate;
    end;

  calculSeuil;
  calculZupRaw;
end;


procedure TrevCorAnalysis.calculSeuil;
var
  m,i,j,l:integer;
  n:integer;
  x,xt,xt2:double;

begin
  n:=0;
  xt:=0;
  xt2:=0;

  with info do
  begin
    for m:=7 to 8 do
    with mat[m] do
    begin
      data.raz; {calcul de deux matrices antérogrades entre -tmax et -tmax+dt}

      for l:=ipmin to ipmin+nbip-1 do
        for i:=Istart to Iend do
          for j:=Jstart to Jend do
            data.addI(i,j,psth[i-1,j-1,m-7,l]);
    end;

    n:=0;
    xt:=0;
    xt2:=0;

    for m:=7 to 8 do
    with mat[m] do
    begin   {calcul de la moyenne et l'écart-type sur les matrices anterogrades}
      for i:=Istart to Iend do
        for j:=Jstart to Jend do
          begin
            x:=data.getI(i,j);
            xt:=xt+x;
            xt2:=xt2+sqr(x);
            n:=n+1;
          end;
    end;

    with resultat do
    begin
      Nmoyen:=xt/n;
      Nsig:=sqrt(1/(n-1)*( xt2-sqr(xt)/n));
    end;
  end;

  for i:=7 to 8 do
    begin
      if info.autoscale then mat[i].autoscaleZ;
      mat[i].invalidate;
    end;

end;

procedure TrevCorAnalysis.calculZupRaw;
var
  seuilA1,seuilA2:double;
  i,j,m:integer;
  x,nb1,nbtot:integer;

begin
  with info,resultat do
  begin
    seuilA1:=Nmoyen+seuilZ*Nsig;
    seuilA2:=Nmoyen-seuilZ*Nsig;

    {Calcul du rapport entre le poids des pixels significatifs et le poids total
     sur les cartes brutes.
    }

    for m:=1 to 2 do
    with mat[m] do
    begin
      nbtot:=0;
      nb1:=0;
      for i:=Istart to Iend do
        for j:=Jstart to Jend do
          begin
            x:=Kvalue[i,j];
            inc(nbtot,x);
            if (x<=seuilA2) or (x>=seuilA1) then inc(nb1,x);
          end;

      if nbtot>0
        then ZupRaw[m]:=nb1/nbtot
        else ZupRaw[m]:=0;
    end;

  end;
end;


procedure TrevCorAnalysis.calculeOptima;
var
  i,j,l,m:integer;
  x,xm,latm:integer;

  n:integer;
  xt,xt2:double;

begin
  with info do
  begin
    for m:=3 to 4 do
    with mat[m] do
    begin
      data.raz;

      for i:=Istart to Iend do
        for j:=Jstart to Jend do
          begin
            x:=0;
            for l:=0 to nbip-1 do x:=x+psth[i-1,j-1,m-3,l];
            xm:=x;
            latm:=0;

            for l:=nbip to ipmax{-nbip+1} do
              begin
                x:=x-psth[i-1,j-1,m-3,l-nbip]+psth[i-1,j-1,m-3,l];
                if x>xm then
                  begin
                    xm:=x;
                    latm:=l;
                  end;
              end;

            Kvalue[i,j]:=xm;
            mat[m+2].Kvalue[i,j]:=latm;
          end;

      autoscaleZ;
      mat[m+2].autoscaleZ;
    end;
  end;

  if info.OptiAvecSeuil then CalculOptimaSeuil;
end;

procedure TrevCorAnalysis.CalculOptimaSeuil;
var
  seuilA1,seuilA2:double;
  i,j,m:integer;
  nb1,nbtot:integer;
  x:integer;
begin
  calculSeuil;
  calculZupRaw;

  with info,resultat do
  begin
    seuilA1:=Nmoyen+seuilZ*Nsig;
    seuilA2:=Nmoyen-seuilZ*Nsig;

    {Seuillage des cartes optimales: si un pixel est entre les seuils, on
     remplace sa valeur par zéro.
    }

    nbPixelOpt[1]:=0;
    nbPixelOpt[2]:=0;

    for m:=3 to 4 do
    with mat[m] do
    begin
      nb1:=0;
      nbtot:=0;
      for i:=Istart to Iend do
        for j:=Jstart to Jend do
          begin
            x:=Kvalue[i,j];
            inc(nbtot,x);
            if x<=seuilA2 then
              begin
                Kvalue[i,j]:=-round(-x+Nmoyen-1);
                inc(nb1,round(seuilA2)-x);
                inc(nbPixelOpt[m-2]);
              end
            else
            if x<seuilA1 then
              begin
                Kvalue[i,j]:=0;
                mat[m+2].Kvalue[i,j]:=0;
              end
            else
              begin
                Kvalue[i,j]:=round(x-Nmoyen+1);
                inc(nb1,x-round(seuilA1));
                inc(nbPixelOpt[m-2]);
              end;
          end;
      if Nsig<>0
        then Dzu:=1/Nsig
        else Dzu:=0;
      Z0u:=0;

      if nbtot>0
        then ZupOpt[m-2]:=nb1/nbtot
        else ZupOpt[m-2]:=0;

      autoScaleZ;
      Zmin:=0;

      invalidate;
    end;



  end;
end;

procedure TrevCorAnalysis.calculOptiG;
var
  i:integer;
begin
  calculeOptima;

  for i:=3 to 6 do mat[i].invalidate;
end;

procedure TrevCorAnalysis.clearPsth;
var
  i:integer;
begin
  initPsth;

  for i:=1 to nbmatRCA do
    begin
      mat[i].clear;
      mat[i].invalidate;
    end;
end;

procedure TrevCorAnalysis.Calculate;
var
  i:integer;
begin
  {loadEvt;}
  calculPsth(true);
  calculeMat;
  calculeOptima;

  for i:=1 to nbmatRCA do mat[i].invalidate;
end;

procedure TrevCorAnalysis.Add;
var
  i:integer;
begin
  calculPsth(false);
  calculeMat;
  calculeOptima;

  for i:=1 to nbmatRCA do mat[i].invalidate;
end;


procedure TrevCorAnalysis.setDataVec(v:Tvector);
begin
  derefObjet(typeUO(info.dataVec));
  info.dataVec:=v;
  refObjet(typeUO(info.dataVec));
end;


procedure TrevCorAnalysis.getStimsXYZ(x1,y1,z1:integer;var v:Tvector);
var
  i,code0:integer;
begin
  if not assigned(v) or not assigned(v.data) then exit;
  if not assigned(codes) then exit;

  v.initEventList(g_longint,dxEvt);

  code0:=z1+nz*y1+nz*ny*x1+1;

  for i:=1 to nbtot do
    with codes^[i] do
    if code=code0 then v.addToList(date*dxEvt);

end;

function TrevCorAnalysis.getTimeXYZ(x1,y1,z1:integer):float;
var
  i,code0:integer;
begin
  result:=-1;
  if not assigned(codes) then exit;

  code0:=z1+nz*y1+nz*ny*x1+1;

  for i:=1 to nbtot do
    with codes^[i] do
    if code=code0 then
    begin
      result:=date*dxEvt;
      exit;
    end;

end;

{ Calcul des PSTW }

procedure TrevCorAnalysis.initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);
var
  i,i1,i2:integer;
begin
  for i:=1 to 2 do derefObjet(typeUO(pstw[i]));
  pstw[1]:=var1;
  pstw[2]:=var2;
  for i:=1 to 2 do refObjet(pstw[i]);

  derefObjet(typeUO(sourcePstw));
  sourcePstw:=source;
  refObjet(sourcePstw);

  nbPstw:=0;
  x1Pstw:=x1;
  x2Pstw:=x2;

  i1:=roundL(x1Pstw/source.dxu);
  i2:=roundL(x2Pstw/source.dxu);

  for i:=1 to 2 do
    begin
      pstw[i].initarray(1,nx,1,ny);
      pstw[i].initAverages(i1,i2,g_single);
      pstw[i].dxu:=source.dxu;

      pstw[i].clear;
    end;
end;


procedure TrevCorAnalysis.calculatePstw;
var
  i,i1,i2:integer;
  x,y,z:integer;
  t:double;

  vv:Taverage;

begin
  for i:=1 to 2 do
    if not assigned(pstw[i])  then exit;

  for i:=1 to nbtot do
    begin
      t:=codes^[i].date*dxEvt;
      decode(codes^[i].code,x,y,z);
      vv:=pstw[z+1].average(x+1,y+1);
      if assigned(vv) then
      begin
        if (codes^[i].fp>0) then vv.addEx(sourcePstw,t);
      end
      else sortieErreur(E_average);
    end;

end;


procedure TrevCorAnalysis.InitResponses(source:Tvector;va1,va2:TvectorArray;
                                        x1,x2:float;tp:typetypeG);
var
  i,i1,i2:integer;
begin
  i1:=roundL(x1/source.dxu);
  i2:=roundL(x2/source.dxu);

  va1.initarray(1,nx,1,ny);
  va1.initVectors(i1,i2,tp);
  va1.x0u:=source.x0u;
  va1.dxu:=source.dxu;
  va1.y0u:=source.y0u;
  va1.dyu:=source.dyu;

  va2.initarray(1,nx,1,ny);
  va2.initVectors(i1,i2,tp);
  va2.x0u:=source.x0u;
  va2.dxu:=source.dxu;
  va2.y0u:=source.y0u;
  va2.dyu:=source.dyu;
end;

{ Calcul des "réponses" }

procedure TrevCorAnalysis.Responses(source:Tvector;va1,va2:TvectorArray;x1,x2:float;mode:integer);
var
  i,i1,i2:integer;
  x,y,z:integer;
  it:integer;

  va:array[1..2] of TvectorArray;
  vv,vdum:Tvector;
begin
  i1:=roundL(x1/source.dxu);
  i2:=roundL(x2/source.dxu);

  va[1]:=va1;
  va[2]:=va2;

  for i:=1 to 2 do
    with va[i] do
    if (Imin<>1) or (Imax<>nx) or (Jmin<>1) or (Jmax<>ny) or
       (Istart<>i1) or (Iend<>i2) or (tpNum<>source.tpNum) then exit;
  vdum:=Tvector.create;
  vdum.initTemp1(i1,i2,source.tpNum);


  TRY
    for i:=1 to nbtot do
    begin
      it:=source.invconvx(codes^[i].date*dxEvt);
      decode(codes^[i].code,x,y,z);
      vv:=va[z+1][x+1,y+1];
      if not assigned(vv) then sortieErreur(E_Response);

      if mode=0
        then VV.copyDataFromVec(source,it+i1,it+i2,vv.Istart)
      else
        begin
          Vdum.copyDataFromVec(source,it+i1,it+i2,vv.Istart);

          case mode of
            1: vv.Vadd(Vdum);
            2: vv.VaddSqrs(Vdum);
            3: begin
                 Vdum.NormalizeValues;
                 vv.Vadd(Vdum);
               end;
          end;
        end;
    end;

  FINALLY
    if mode<>0 then Vdum.free;
  END;

end;

{ Calcul des PsdMat }

procedure TrevCorAnalysis.initPsdMat(var1,var2:TmatrixArray;source:Tvector;
                                     x1,x2,dx1:float;Nfft,Nb,WM:integer;Fpsd:byte);
var
  i,j:integer;
  i1,j1:integer;
begin
  for i:=1 to 2 do derefObjet(typeUO(psdMat[i]));
  psdMat[1]:=var1;
  psdMat[2]:=var2;
  for i:=1 to 2 do refObjet(psdMat[i]);

  derefObjet(typeUO(sourcePsdMat));
  sourcePsdMat:=source;
  refObjet(sourcePsdMat);

  PsdMatRec.x1:=x1;
  PsdMatRec.x2:=x2;
  PsdMatRec.dx1:=dx1;
  PsdMatRec.Nfft:=Nfft;
  PsdMatRec.Nb:=Nb;
  PsdMatRec.i1:=roundL(x1/dx1);
  PsdMatRec.i2:=roundL(x2/dx1);
  psdMatRec.count:=0;
  psdMatRec.WindowMode:=WM;
  psdMatRec.Fpsd:=Fpsd;

  for i:=1 to 2 do
    with psdMat[i] do
    begin
      initarray(1,nx,1,ny);
      case Fpsd of
        0:   initMatrix(g_single,PsdMatRec.i1,PsdMatRec.i2,0,Nb-1);
        1,2: initMatrix(g_singleComp,PsdMatRec.i1,PsdMatRec.i2,0,Nb-1);

        3: begin
             initMatrix(g_singleComp,PsdMatRec.i1,PsdMatRec.i2,0,Nb-1);
             for i1:=Imin to Imax do
             for j1:=Jmin to Jmax do
                with matrix(i1,j1) do
                for j:=0 to Icount*Jcount-1 do
                  PtabSingleComp(tb)^[j].x:=1;

           end;
        {pour 4, on garde le contenu des matrices}
      end;
      dxu:=dx1;
      x0u:=0;
      dyu:=1/(NFFT*source.dxu/1000);
      y0u:=0;
    end;
end;

procedure RealFftNip(src:Psingle; dest:PsingleComp; Order:integer);
begin

end;

procedure TrevCorAnalysis.calculatePsdMat;
var
  i,j,k,n,n1:integer;
  x,y,z:integer;
  t,w:float;
  order:integer;

  mm:Tmatrix;
  vec1:Tvector;
  tbX:array of TSingleComp;
  NbJ:integer;

  tbAux:array of single;
  xA,yA:float;

begin
  IPPStest;
  if not GetOrder2(psdMatRec.Nfft,order)
    then sortieErreur('FFT parameter must be a power of 2');

  for i:=1 to 2 do
    if not assigned(psdMat[i])  then exit;
  if not assigned(sourcePsdMat) then exit;

  vec1:=Tvector.create;
  vec1.Dxu:=sourcePsdMat.Dxu;
  vec1.x0u:=sourcePsdMat.x0u;
  vec1.initTemp1(sourcePsdMat.Istart,sourcePsdMat.Iend+psdMatRec.Nfft,G_single);
  vec1.copyDataFrom(sourcePsdMat);

  setLength(tbX,psdMatRec.Nfft div 2+1);
  setLength(tbAux,psdMatRec.Nfft);

  TRY
  for i:=1 to nbtot do
    begin
      t:=codes^[i].date*dxEvt;
      decode(codes^[i].code,x,y,z);
      mm:=psdMat[z+1].matrix(x+1,y+1);
      NbJ:=mm.Jcount;

      for n:=psdMatRec.i1 to psdMatRec.i2 do
      begin
        n1:=n-psdmatRec.i1;
        k:=sourcePsdMat.invconvx(t+n*PsdMatRec.dx1);

        if (psdMatRec.WindowMode>0) and (psdMatRec.WindowMode <=4) then
          begin
            move(PtabSingle(vec1.tb)^[k],tbAux[0],length(tbAux)*sizeof(single));
            case psdMatRec.windowMode of
              1:  ippsWinBartlett(Psingle(@tbAux[0]),length(tbAux));
              2:  ippsWinBlackmanOpt(Psingle(@tbAux[0]),length(tbAux));
              3:  ippsWinHamming(Psingle(@tbAux[0]),length(tbAux));
              4:  ippsWinHann(Psingle(@tbAux[0]),length(tbAux));
            end;

            ippsFFTfwd(Psingle(@tbAux[0]),PsingleComp(@tbX[0]),Order);
          end
        else
          begin
           ippsFFTfwd(Psingle(@PtabSingle(vec1.tb)^[k-vec1.Istart]),PsingleComp(@tbX[0]),Order);
          end;

        case psdMatRec.Fpsd of
          0: for j:=0 to mm.Jcount-1 do
               PtabSingle(mm.tb)^[nbJ*n1+j]:=
                 PtabSingle(mm.tb)^[nbJ*n1+j] + sqr(tbX[j].x)+sqr(tbX[j].y);

          1: for j:=0 to mm.Jcount-1 do
               with  PtabSingleComp(mm.tb)^[nbJ*n1+j] do
               begin
                 x:=x+ tbX[j].x;
                 y:=y+ tbX[j].y;
               end;

          2: for j:=0 to mm.Jcount-1 do
               with  PtabSingleComp(mm.tb)^[nbJ*n1+j] do
               begin
                 with tbX[j] do
                   w:=sqrt(sqr(x)+sqr(y));
                 if w<>0 then
                 begin
                   x:=x+ tbX[j].x/w;
                   y:=y+ tbX[j].y/w;
                 end;
               end;

          3: for j:=0 to mm.Jcount-1 do
               with  PtabSingleComp(mm.tb)^[nbJ*n1+j] do
               begin
                 xA:=x*tbX[j].x-y*tbX[j].y;
                 yA:=x*tbX[j].y+y*tbX[j].x;

                 x:=xA;
                 y:=yA;
               end;

          4: for j:=0 to mm.Jcount-1 do
             begin
               with tbX[j] do
               if x<>0
                 then xA:=arctan2(y,x)                {xA=phase de l'essai}
                 else xA:=0;
               with  PtabSingleComp(mm.tb)^[nbJ*n1+j] do
               begin
                 y:=xA-x;                               {x=phase moyenne}
                 if abs(y+2*pi)<abs(y) then y:=y+2*pi
                 else
                 if abs(y-2*pi)<abs(y) then y:=y-2*pi;
                 y:=y+sqr(y);                           { somme des carrés dans y}
               end;
             end;

        end;
      end;
    end;

  inc(psdMatRec.count);
  FINALLY
  vec1.Free;
  IPPSend;
  END;

end;


procedure TrevCorAnalysis.NormPsdMat;
var
  i,j,n,n1:integer;
  value:TSingleComp;
  i1,j1:integer;
  nbEltMat:integer;

begin
  IPPStest;

  for i:=1 to 2 do
    if not assigned(psdMat[i])  then exit;

  TRY
    value.x:=1/psdMatRec.count;
    value.y:=0;
    n1:=psdMatRec.count-1;
    with psdMat[1].matrix(1,1) do nbEltMat:=Icount*Jcount;

    for n:=1 to 2 do
      with psdMat[n] do
      begin
        for i:=Imin to Imax do
        for j:=Jmin to Jmax do
          case psdMatRec.Fpsd of
            0:   ippsMulC(1/psdMatRec.count,matrix(i,j).tbS,nbEltMat);
            1,2: ippsMulC(Value,PsingleComp(matrix(i,j).tb),nbEltMat);

            3:  with matrix(i,j) do
                for i1:=0 to nbEltMat-1 do
                  with PtabSingleComp(tb)^[i1] do
                  begin
                    if x<>0
                      then x:=arcTan2(y,x)/psdMatRec.count; {Phase moyenne dans x}
                    y:=0;                                    {zéro dans y}
                  end;
            4:  with matrix(i,j) do
                for i1:=0 to nbEltMat-1 do
                  with PtabSingleComp(tb)^[i1] do
                  begin
                    y:=y/n1;                                  {StdDev dans y}
                  end;
          end;
      end;
  FINALLY
    IPPSend;
  END;

end;

{ Calcul des PStac }

procedure TrevCorAnalysis.initPstac(cor1,cor2:TcorrelogramArray;
                                    i1,i2:integer;classe,x1,x2:float);
var
  i:integer;
begin
  derefobjet(typeUO(pstac[1]));
  derefobjet(typeUO(pstac[2]));

  pstac[1]:=cor1;
  pstac[2]:=cor2;

  refobjet(pstac[1]);
  refobjet(pstac[2]);


  x1Pstac:=x1;
  x2Pstac:=x2;

  for i:=1 to 2 do
    begin
      pstac[i].initarray(1,nx,1,ny);
      pstac[i].initCorrelograms(i1,i2,g_single,classe);
    end;
end;


procedure TrevCorAnalysis.calculatePstac;
var
  i:integer;
  x,y,z:integer;
  t:double;

  vv:Tcorrelogram;

begin
  for i:=1 to 2 do
    if not assigned(pstac[i])  then exit;

  for i:=1 to nbtot do
    begin
      t:=codes^[i].date*dxEvt;
      decode(codes^[i].code,x,y,z);
      vv:=pstac[z+1].cors(x+1,y+1);
      if assigned(vv)
        then vv.add1(dataVec,dataVec,t+x1Pstac,t+x2Pstac)
        else sortieErreur(E_pstac);
    end;
end;


type
  TarrayOfSingle=array of Single;

function getRao(w:TarrayOfSingle):float;
var
  data:typeDataS;
  tt,lambda:float;
  i,N:integer;
begin
  N:=length(w);
  data:=typeDataS.create(@w[0],1,0,0,N-1);
  data.sort(true);
  data.free;
  
  lambda:=2*pi/N;
  tt:=0;
  for i:=1 to N-1 do
    tt:=tt+abs(w[i]-w[i-1]-lambda);
  tt:=tt+abs(2*pi-w[N-1]+w[0]);
  result:=tt/2;
end;

function getRayleigh(w:TarrayOfSingle):float;
var
  i:integer;
  x,y:float;
begin
  x:=0;
  y:=0;
  for i:=0 to high(w) do
  begin
    x:=x+cos(w[i]);
    y:=y+sin(w[i]);
  end;

  result:=sqrt(sqr(x)+sqr(y))/length(w);
end;


procedure TrevCorAnalysis.Responses1(seqs,evts:TVlist;seeds:Tvector;
                                  va1,va2:TvectorArray;x1,x2,dx1:float;mode:integer);
var
  PZ:array of array of array of array of integer;
  nbS,NumS:integer;
  i,x,y,z:integer;

  va:array[1..2] of TvectorArray;
  source:Tvector;
  i1,i2:integer;
  w:TArrayOfsingle;
  ww:double;
  t,dt1:integer;


begin
  va[1]:=va1;
  va[2]:=va2;
  source:=seqs.Vectors[1];

  i1:=roundL(x1/dx1);
  i2:=roundL(x2/dx1);

  for i:=1 to 2 do
  with va[i] do
  begin
    initarray(1,nx,1,ny);
    initVectors(i1,i2,g_single);
    x0u:=0;
    dxu:=dx1;
    y0u:=source.y0u;
    dyu:=source.dyu;
  end;


  nbS:=seqs.count;
  setLength(PZ,nbS,nx,ny,2);
  setLength(w,nbS);

  for numS:=1 to nbS do
  begin
    installSequence(seeds.Jvalue[numS],nbDivX0,nbDivY0,expansion0,scotome0);
    installTimes(evts.Vectors[numS],dxEvt);

    for i:=1 to nbtot do
    begin
      decode(codes^[i].code,x,y,z);
      PZ[numS-1,x,y,z]:=source.invconvx(codes^[i].date*dxEvt);
    end;
  end;


  case mode of
    0:for i:=i1 to i2 do
      begin
        dt1:=source.invconvx(i*dx1);

        for x:=0 to nx-1 do
        for y:=0 to ny-1 do
        for z:=0 to 1 do
        begin
          ww:=0;
          for numS:=0 to nbS-1 do
          begin
            t:=PZ[numS,x,y,z]+dt1;
            ww:=ww+sqr(MdlCpx(seqs.Vectors[numS+1].Cpxvalue[t]));
          end;
          va[z+1][x+1,y+1].Yvalue[i]:=ww/nbS;
        end;
      end;

    1:for i:=i1 to i2 do
      begin
        dt1:=source.invconvx(i*dx1);

        for x:=0 to nx-1 do
        for y:=0 to ny-1 do
        for z:=0 to 1 do
        begin
          for numS:=0 to nbS-1 do
          begin
            t:=PZ[numS,x,y,z]+dt1;
            w[numS]:=AngleCpx(seqs.Vectors[numS+1].Cpxvalue[t]);
          end;
          va[z+1][x+1,y+1].Yvalue[i]:=getRayleigh(w);
        end;
      end;

    2:for i:=i1 to i2 do
      begin
        dt1:=source.invconvx(i*dx1);

        for x:=0 to nx-1 do
        for y:=0 to ny-1 do
        for z:=0 to 1 do
        begin
          for numS:=0 to nbS-1 do
          begin
            t:=PZ[numS,x,y,z]+dt1;
            w[numS]:=AngleCpx(seqs.Vectors[numS+1].Cpxvalue[t]);
          end;
          va[z+1][x+1,y+1].Yvalue[i]:=getRao(w);
        end;
      end;
  end;
end;



procedure TrevcorAnalysis.getMatXYZ(mat1, mat2: Tmatrix);
var
  i:integer;
  x,y,z:integer;
begin
  if not assigned(mat1) or not assigned(mat2) then exit;
  if nbtot<=0 then exit;

  mat1.initTemp(1,nx,1,ny,g_longint);
  mat2.initTemp(1,nx,1,ny,g_longint);

  for i:=1 to nbTot do
  with codes^[i] do
  begin
    decode(code,x,y,z);
    if z=0
      then mat1.Kvalue[x+1,y+1]:=date
      else mat2.Kvalue[x+1,y+1]:=date;
  end;

end;

procedure TrevcorAnalysis.getCodes(vec: Tvector;num:integer);
var
  i:integer;
begin
  if not assigned(vec)  then exit;
  if nbtot<=0 then exit;

  vec.modify(g_longint,0,nx*ny*2-1);

  for i:=1 to nbTot do
  begin
    if (i+num>=1) and (i+num<=nbtot)
      then vec.Jvalue[codes^[i].code]:=codes^[i+num].code
      else vec.Jvalue[codes^[i].code]:=-1;
  end;

end;




{ ************************** Méthodes STM *****************************}



procedure proTrevCorAnalysis_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TrevCorAnalysis);

  with TrevCorAnalysis(pu) do
  begin
    setChildNames;
  end;
end;

procedure proTrevCorAnalysis_installSource(var source1:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(source1));

  with TrevCorAnalysis(pu) do DataVec:=source1;
end;


procedure proTrevCorAnalysis_InstallEvtFile(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do
  begin
    info.stEvt:=st;
    loadEvt;
  end;
end;


procedure proTrevCorAnalysis_installStimSeq(seed,nbDivX,nbDivY,expansion,scotome:integer;
                                            var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  TrevCorAnalysis(pu).installSequence(seed,nbDivX,nbDivY,expansion,scotome);
end;


procedure proTrevCorAnalysis_installTimes(var vecEvt:Tvector;dx:float;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do
  begin
    if (nbtot=0) or (vecEvt.Icount<nbtot)  then sortieErreur(E_installTimes);
    InstallTimes(vecEvt,dx);
  end;
end;

procedure proTrevCorAnalysis_installFP(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do
  begin
    if (nbtot=0) or (vec.Icount<nbtot) then sortieErreur(E_installFP);
    InstallFP(vec);
  end;
end;


{property TrevCorAnalysis.Tmaxi:real;}

procedure proTrevCorAnalysis_Tmaxi(w:float;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do info.Tmaxi:=w;
end;

function fonctionTrevCorAnalysis_Tmaxi(var pu:typeUO):float;
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do result:=info.Tmaxi;
end;


{property TrevCorAnalysis.Dt0:real;}

procedure proTrevCorAnalysis_Dt0(w:float;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do info.Dt0:=w;
end;

function fonctionTrevCorAnalysis_Dt0(var pu:typeUO):float;
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do result:=info.Dt0;
end;


{property TrevCorAnalysis.t:real;}

procedure proTrevCorAnalysis_t(w:float;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do info.t:=w;
end;

function fonctionTrevCorAnalysis_t(var pu:typeUO):float;
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do result:=info.t;
end;

{property TrevCorAnalysis.Dt:real;}
procedure proTrevCorAnalysis_Dt(w:float;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do info.Dt:=w;
end;

function fonctionTrevCorAnalysis_Dt(var pu:typeUO):float;
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do result:=info.Dt;
end;


{property TrevCorAnalysis.Zthreshold:real;}
procedure proTrevCorAnalysis_Zthreshold(w:float;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do info.seuilZ:=w;
end;

function fonctionTrevCorAnalysis_Zthreshold(var pu:typeUO):float;
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do result:=info.seuilZ;
end;

{property TrevCorAnalysis.UseThreshold:boolean;}
procedure proTrevCorAnalysis_UseThreshold(w:boolean;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do info.optiAvecSeuil:=w;
end;

function fonctionTrevCorAnalysis_UseThreshold(var pu:typeUO):boolean;
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do result:=info.optiAvecSeuil;
end;





procedure proTrevCorAnalysis_ClearPsth(var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do ClearPsth;
end;

procedure proTrevCorAnalysis_calculatePsth(var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do CalculPsth(false);
end;

procedure proTrevCorAnalysis_calculateMatrix(var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do calculeMat;
end;

procedure proTrevCorAnalysis_calculateOptMatrix(var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TrevCorAnalysis(pu) do calculeOptima;
end;



function fonctionTrevCorAnalysis_m1(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=@mat[1];
end;

function fonctionTrevCorAnalysis_m2(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=@mat[2];
end;

function fonctionTrevCorAnalysis_mopt1(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=@mat[3];
end;

function fonctionTrevCorAnalysis_mopt2(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=@mat[4];
end;

function fonctionTrevCorAnalysis_mlat1(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=@mat[5];
end;

function fonctionTrevCorAnalysis_mlat2(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=@mat[6];
end;

function fonctionTrevCorAnalysis_mante1(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=@mat[7];
end;

function fonctionTrevCorAnalysis_mante2(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=@mat[8];
end;



function fonctionTrevCorAnalysis_mat(num:smallint;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  ControleParam(num,1,nbMatRCA,E_NumMat);
  with TrevCorAnalysis(pu) do result:=@mat[num];
end;

procedure proTrevCorAnalysis_Distri(num:smallint;var p:typeUO;var pu:typeUO);
begin
  sortieErreur(E_affectation);
end;


function fonctionTrevCorAnalysis_PixelsAbove(num:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  ControleParam(num,1,2,E_12);
  with TrevCorAnalysis(pu) do result:=resultat.nbPixelOpt[num];
end;

function fonctionTrevCorAnalysis_Zabove(num:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  ControleParam(num,1,2,E_12);
  with TrevCorAnalysis(pu) do result:=resultat.ZupOpt[num];
end;

function fonctionTrevCorAnalysis_Nmean(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=resultat.Nmoyen;
end;

function fonctionTrevCorAnalysis_Nstd(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=resultat.Nsig;
end;

procedure proTrevCorAnalysis_getStimsXYZ(x,y,z:integer;var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));
  with TrevCorAnalysis(pu) do
  begin
    if not assigned(codes) or
       (x<1) or (x>nx) or
       (y<1) or (y>ny) or
       (z<1) or (z>2)
      then sortieErreur(E_getStimsXYZ);

    getStimsXYZ(x-1,y-1,z-1,v);
  end;
end;

function fonctionTrevCorAnalysis_getTimeXYZ(x,y,z:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do
  begin
    if not assigned(codes) or
       (x<1) or (x>nx) or
       (y<1) or (y>ny) or
       (z<1) or (z>2)
      then sortieErreur(E_getStimsXYZ);

    result:=getTimeXYZ(x-1,y-1,z-1);
  end;
end;


function fonctionTrevCorAnalysis_PosCount(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=NbTot;
end;

function fonctionTrevCorAnalysis_Nx(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=Nx;
end;

function fonctionTrevCorAnalysis_Ny(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do result:=Ny;
end;

function fonctionTrevCorAnalysis_Codes(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do
  begin
    if not assigned(codes) or (i<1) or (i>nbtot)
      then sortieErreur(E_code);
    result:=codes^[i].code;
  end;
end;

function fonctionTrevCorAnalysis_Xpos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do
  begin
    if not assigned(codes) or (i<1) or (i>nbtot)
      then sortieErreur(E_code);
    result:=getX(codes^[i].code)+1;
  end;
end;

function fonctionTrevCorAnalysis_Ypos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do
  begin
    if not assigned(codes) or (i<1) or (i>nbtot)
      then sortieErreur(E_code);
    result:=getY(codes^[i].code)+1;
  end;
end;

function fonctionTrevCorAnalysis_Zpos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do
  begin
    if not assigned(codes) or (i<1) or (i>nbtot)
      then sortieErreur(E_code);
    result:=getZ(codes^[i].code)+1;
  end;
end;


function fonctionTrevCorAnalysis_encode(x,y,z:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do
  begin
    result:=encode(x-1,y-1,z-1);
  end;
end;

procedure proTrevCorAnalysis_decode(code:integer;var x,y,z:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do
  begin
    decode(code,x,y,z);
    inc(x);
    inc(y);
    inc(z);
  end;
end;

function fonctionTrevCorAnalysis_psths(num:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  ControleParam(num,1,2,E_12);
  with TrevCorAnalysis(pu) do result:=@psths[num];
end;



procedure proSelectEvents(var source,dest,Csource,Cdest:Tvector;Cmin,Cmax:float);
var
  i:integer;
  x:float;
begin
  verifierVecteur(source);
  verifierVecteur(dest);
  verifierVecteur(Csource);
  verifierVecteur(Cdest);

  dest.controleReadOnly;
  Cdest.controleReadOnly;

  if (source.Istart<>1) or
     (source.Istart<>Csource.Istart) or (source.Iend<>Csource.Iend) then exit;

  dest.initEventList(source.tpNum,source.dxu);
  Cdest.initList(Csource.tpNum);

  for i:=Csource.Istart to Csource.Iend do
    begin
      x:=Csource.data.getE(i);
      if (x>=Cmin) and (x<Cmax) then
        begin
          Cdest.addToList(x);
          dest.addToList(source.data.getE(i));
        end;
      end;

end;

procedure proSelectEvents1(var source,Csource:Tvector;Cmin,Cmax:float);
var
  i:integer;
  x:float;
  p1,p2:PtabDouble1;
  nb:integer;
begin
  verifierVecteur(source);
  verifierVecteur(Csource);

  source.controleReadOnly;
  Csource.controleReadOnly;

  if (source.Istart<>1) or
     (source.Istart<>Csource.Istart) or (source.Iend<>Csource.Iend) then exit;

  nb:=source.Iend-source.Istart+1;
  getmem(p1,nb*sizeof(double));
  getmem(p2,nb*sizeof(double));

  TRY
  for i:=source.Istart to source.Iend do
    begin
      p1^[i]:=source.data.getE(i);
      p2^[i]:=Csource.data.getE(i);
    end;


  source.initEventList(source.tpNum,source.dxu);
  Csource.initList(Csource.tpNum);

  for i:=1 to nb  do
    begin
      x:=p2^[i];
      if (x>=Cmin) and (x<Cmax) then
        begin
          Csource.addToList(x);
          source.addToList(p1^[i]);
        end;
      end;

  FINALLY
  freemem(p1,nb*8);
  freemem(p2,nb*8);
  END;
end;


procedure proTrevCorAnalysis_calculatePstw(var pu:typeUO);
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do calculatePstw;
end;

procedure proTrevCorAnalysis_initPstw(var v1,v2:TaverageArray;var source:Tvector;
                                      x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));

  verifierVecteur(source);

  with TrevCorAnalysis(pu) do initPstw(v1,v2,source,x1,x2);
end;

procedure proTrevCorAnalysis_calculatePstac(var pu:typeUO);
begin
  verifierObjet(pu);
  with TrevCorAnalysis(pu) do calculatePstac;
end;

procedure proTrevCorAnalysis_initPstac(var cor1,cor2:pointer;
                               i1,i2:integer;classe,x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(cor1));
  verifierObjet(typeUO(cor2));
  with TrevCorAnalysis(pu) do initPstac(cor1,cor2,i1,i2,classe,x1,x2);
end;

function fonctionFindRevCorSeed(var seed:integer;
           nbDivX,nbDivY,expansion,scotome:integer;var Vcode:Tvector):boolean;
var
  Wcode:PtabEntier1;
  i,n:integer;
begin
  result:=false;
  verifierVecteur(Vcode);

  with Vcode do n:=Iend-Istart+1;
  if (n<=0) or (n>80*80*2) then exit;

  getmem(Wcode,n*sizeof(smallint));
  with Vcode do
  for i:=Istart to Iend do Wcode^[i-Istart+1]:=Jvalue[i];

  result:=FindSeed(seed,nbDivX,nbDivY,expansion,scotome,Wcode);
  freemem(Wcode);
end;


procedure proTrevCorAnalysis_initPsdMat(var m1,m2:TmatrixArray;var source:Tvector;
                                     x1,x2,dx1:float;Nfft,Nb,WM:integer;ModePsd:integer;
                                     var pu:typeUO);
var
  order:integer;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(m1));
  verifierObjet(typeUO(m2));

  verifierVecteur(source);

  if (nb<1) or (nb>Nfft div 2 +1) then sortieErreur(E_PsdMat1);
  if not GetOrder2(Nfft,order) then sortieErreur('FFT parameter must be a power of 2');

  with TrevCorAnalysis(pu) do
    initPsdMat(m1,m2,source,x1,x2,dx1,Nfft,Nb,WM,ModePsd);
end;

procedure proTrevCorAnalysis_CalculatePsdMat(var pu:typeUO);
begin
  verifierObjet(pu);

  with TrevCorAnalysis(pu) do
    calculatePsdMat;
end;

procedure proTrevCorAnalysis_NormPsdMat(var pu:typeUO);
begin
  verifierObjet(pu);

  with TrevCorAnalysis(pu) do
    NormPsdMat;
end;

procedure proTrevCorAnalysis_Responses(var source:Tvector;var va1,va2:TvectorArray;
                                      x1,x2:float;mode:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(source);
  verifierObjet(typeUO(va1));
  verifierObjet(typeUo(va2));
  TrevCorAnalysis(pu).Responses(source,va1,va2,x1,x2,mode);
end;

procedure proTrevCorAnalysis_InitResponses(var source:Tvector;var va1,va2:TvectorArray;
                                      x1,x2:float;tp:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(source);
  verifierObjet(typeUO(va1));
  verifierObjet(typeUo(va2));

  if (tp<0) or (tp>ord(G_ExtComp)) then sortieErreur(E_InitResponse);

  TrevCorAnalysis(pu).InitResponses(source,va1,va2,x1,x2,typetypeG(tp));
end;

procedure proTrevCorAnalysis_Responses1(var seqs,evts:TVlist;var seeds:Tvector;
                                  var va1,va2:TvectorArray;x1,x2,dx1:float;mode:integer;
                                  var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(seqs));
  verifierObjet(typeUO(evts));
  verifierObjet(typeUO(va1));
  verifierObjet(typeUO(va2));
  verifierVecteur(seeds);

  TrevCorAnalysis(pu).Responses1(seqs,evts,seeds,va1,va2,x1,x2,dx1,mode);

end;

procedure proTrevcorAnalysis_getMatXYZ(var mat1,mat2: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat1));
  verifierObjet(typeUO(mat2));

  TrevCorAnalysis(pu).getMatXYZ(mat1,mat2);
end;

procedure proTrevcorAnalysis_getCodes(var vec: Tvector;num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));

  TrevCorAnalysis(pu).getCodes(vec,num);
end;


procedure TrevcorAnalysis.FreeRef;
var
  i:integer;
begin
  inherited;
  derefObjet(typeUO(info.dataVec));
  for i:=1 to 2 do
    derefObjet(typeUO(pstw[i]));
  derefObjet(typeUO(sourcePstw));

  for i:=1 to 2 do
    derefObjet(typeUO(psdmat[i]));
  derefObjet(typeUO(sourcePsdmat));

  derefobjet(typeUO(pstac[1]));
  derefobjet(typeUO(pstac[2]));

end;

Initialization
AffDebug('Initialization revcor2',0);

installError(E_nbc,'TrevcorAnalysis: criterion number out of range');
installError(E_numMat,'TrevcorAnalysis: matrix number out of range');
installError(E_affectation,'TrevcorAnalysis: cannot modify this object');
installError(E_12,'TrevcorAnalysis: invalid index (1 or 2 expected)');
installError(E_getStimsXYZ,'TrevcorAnalysis.getStimsXYZ error');
installError(E_numDistri,'TrevcorAnalysis: Distri number out of range');
installError(E_code,'TrevcorAnalysis: Code index out of range');
installError(E_average,'TrevcorAnalysis: pstw error');
installError(E_installTimes,'TrevcorAnalysis.installTimes: stim.seq. not installed');
installError(E_installFP,'TrevcorAnalysis.installFP: stim.seq. not installed');

installError(E_pstac,'TrevcorAnalysis: pstac error');
installError(E_psdmat1,'TrevcorAnalysis.initPsdMat : parameter out of range');
installError(E_response,'TrevcorAnalysis.Responses : ');
installError(E_InitResponse,'TrevcorAnalysis.InitResponses : number type not supported');

registerObject(TrevCorAnalysis,data);

end.
