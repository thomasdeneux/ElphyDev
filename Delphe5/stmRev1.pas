unit stmRev1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows,sysutils,forms,classes, graphics,
     util1,Dgraphic,Gdos,dtf0,tbe0,listG,
     ipps, ippsovr,
     Stmdef,stmObj,
     Dpalette,
     stmObv0,stmMvtX1,
     stmVec1,stmAve1,stmMat1,stmOdat2,stmPsth1,stmPstA1,stmAveA1,
     varconf1,syspal32,
     editCont,defForm,selRF1,getRev1,
     debug0,
     NcDef2,stmPg, chkPstw1,
     stmMlist, VlistA1,stmKLmat,
     D7random1;


type
  TseqElt = record
                X,Y,Z,FP: byte;  { 0 à n-1 }
              end;

  TEltK1 =  record
              case integer of
                1: (x,y,z,t:byte);
                2: (w:integer);
            end;

  TEltK2 =  record
              case integer of
                1: (x1,y1,z1,t1,x2,y2,z2,t2:byte);
                2: (w:int64);
            end;

  Trevcor=    class(TonOff)
              protected
                KPdt:float;
                KPtau1,KPtau2,KPnbt:integer;

                lqrP:TchkPstw;

                listK1:Tlist;
                listK2:TlistG;

                listK1bis:Tlist;
                listK1bisV:Tlist;
                listK2bis:TlistG;
                listK2bisV:Tlist;
                nbK1bis:integer;
                nbK2bis:integer;

                DTmesure:float;            {Duree de cycle mesurée en millisecondes }
                FlqrPsth:boolean;
                DumPsth:Tpsth;

                function sequenceInstalled:boolean;virtual;


              public
                nbDivX, nbDivY:integer;    { nb Divisions pour paver RF }
                lum:array[1..2] of single; { num luminance pour les 2 contrastes }
                expansion:integer;         { on pave un certain % du RF }
                scotome:integer;           { on peut exclure une partie du RF }
                RFDeg: TypeDegre;          { reçoit un RF système }
                Seed0: word;               { seed pour fonction Random }
                AdjustObjectSize:boolean;  { initialiser la taille de l'objet }
                index: integer;            { numéro du cycle courant }
                Sequence: Array of TseqElt;

                nX,nY:integer;             { nb div effectifs en tenant compte de
                                             expansion et scotome }
                XInf,XSup,YInf,YSup : integer;
                                           { coo du scotome }

                obvisA:array[1..2] of Tresizable;


                EvtTimes:array of integer;
                dxEvt:double;             { Param d'échelle pour les dates evt }

                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;
                procedure setChildNames;override;

                procedure CalculeCentre(place:TseqElt;var ic,jc:float);
                procedure CalculeCentre1(x,y:integer;var ic,jc:single);
                procedure CalculeCentre2(x,y:float;var ic,jc:float);

                // randSequence fixe CycleCount
                procedure randSequence;virtual;

                procedure InitMvt; override;
                procedure initObvis;override;
                procedure calculeMvt; override;
                procedure doneMvt; override;


                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;

                procedure selectRF;
                function dialogForm:TclassGenForm;override;
                procedure installDialog(var form:Tgenform;var newF:boolean);
                            override;
                procedure afficheC;override;
                procedure afficheS;override;

                function getInfo:AnsiString;override;

                procedure setSeed(x:integer);virtual;
                function getSeed:integer;virtual;
                Property seed:integer read getSeed write setSeed;

                procedure installSequence(seed1,nbDivX1,nbDivY1,expansion1,scotome1:integer);
                function InstallTimes(vec:Tvector;dx:float;var stE:string): boolean;virtual;
                function CorrectTimes:boolean;
                procedure InstallFP(vec:Tvector);

                procedure initPsth(var1,var2:TpsthArray;source:Tvector;x1,x2,deltaX:float);virtual;
                procedure calculatePsth(var1,var2:TpsthArray;source:Tvector);virtual;

                procedure initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);virtual;
                procedure calculatePstw(var1,var2:TaverageArray;source:Tvector);virtual;

                function encode(x,y,z:integer):integer;          {x,y,z et code commencent à zéro}
                procedure decode(code:integer;var x,y,z:integer);
                function EltCode(Elt:TseqElt):integer;

                function getX(code:integer):integer;
                function getY(code:integer):integer;
                function getZ(code:integer):integer;
                procedure getMatXYZ(mat1, mat2: Tmatrix);
                procedure getConditionXYZ(mat1, mat2: Tmatrix);

                procedure getCodes(vec: Tvector;num:integer);

                function LqrNz:integer;virtual;
                procedure initLqrPstw(source:Tvector;tau1,tau2:integer);virtual;
                procedure initLqrPstH(Lclasse:float;tau1,tau2:integer);virtual;

                procedure BuildMatSline(i:integer);virtual;
                procedure BuildBXline(source:Tvector;i:integer);virtual;
                procedure calculateLqrPstw(source:Tvector);virtual;
                procedure SVD(mat:Tmat);
                procedure SolveLqrPstw;virtual;

                procedure getLqrPstw(pstw:TvectorArray;z:integer;raw,Norm:boolean);virtual;
                procedure getLqrResidual(vec:Tvector);virtual;
                procedure freeLqrPstw;

                procedure BuildXSignal(vec:Tvector);virtual;
                procedure BuildSignal(var1,var2:TvectorArray;vec:Tvector);virtual;
                procedure getLQRline(seq:integer;tt:float;vec:Tvector);

                procedure BuildSignal1(Vlist:TVlist;vec:Tvector);virtual;
                procedure BuildSignalSpk1(Vlist:TVlist;vec:Tvector;Nmax:integer);virtual;


                Procedure BuildRevMask(mat:Tmatrix;Xpos,Ypos:Tvector);

                procedure initKlist;
                procedure AddK1(x,y,z:integer);virtual;
                procedure AddK2(x1a,y1a,z1a,x2a,y2a,z2a,lag:integer);virtual;

                procedure initLqrPstw1(source:Tvector;tau1,tau2:integer);virtual;
                procedure calculateLqrPstw1(source:Tvector);virtual;
                procedure getLqrVector(num:integer;vec:Tvector;raw,norm:boolean);
                procedure getLqrKList( Vlist:TVlist;raw,norm:boolean);

                procedure setLqrLambda(w:float);
                procedure getMlist(Mlist:TmatList);virtual;
                procedure setMlist(Mlist:TmatList);virtual;

                procedure Display;override;
                function Plotable:boolean;override;

              end;



procedure proTrevCor_create(var pu:typeUO);pascal;
procedure proTrevCor_create_1(name:AnsiString;var pu:typeUO);pascal;
procedure proTrevcor_setRF(num:integer;var pu:typeUO);pascal;

procedure proTrevcor_divXcount(ww:integer;var pu:typeUO);pascal;
function fonctionTrevcor_divXcount(var pu:typeUO):integer;pascal;

procedure proTrevcor_divYcount(ww:integer;var pu:typeUO);pascal;
function fonctionTrevcor_divYcount(var pu:typeUO):integer;pascal;

procedure proTrevcor_Lum1(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_Lum1(var pu:typeUO):float;pascal;

procedure proTrevcor_Lum2(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_Lum2(var pu:typeUO):float;pascal;

procedure proTrevcor_expansion(ww:integer;var pu:typeUO);pascal;
function fonctionTrevcor_expansion(var pu:typeUO):integer;pascal;

procedure proTrevcor_scotome(ww:integer;var pu:typeUO);pascal;
function fonctionTrevcor_scotome(var pu:typeUO):integer;pascal;

procedure proTrevcor_Seed(ww:integer;var pu:typeUO);pascal;
function fonctionTrevcor_Seed(var pu:typeUO):integer;pascal;

procedure proTrevcor_AdjustObjectSize(ww:boolean;var pu:typeUO); pascal;
function fonctionTrevcor_AdjustObjectSize(var pu:typeUO):boolean; pascal;

function fonctionTrevcor_Xcount(var pu:typeUO):integer;pascal;
function fonctionTrevcor_Ycount(var pu:typeUO):integer;pascal;

procedure proTrevcor_updateSequence(var pu:typeUO);pascal;

procedure proTrevcor_RFx(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_RFx(var pu:typeUO):float;pascal;

procedure proTrevcor_RFy(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_RFy(var pu:typeUO):float;pascal;

procedure proTrevcor_RFdx(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_RFdx(var pu:typeUO):float;pascal;

procedure proTrevcor_RFdy(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_RFdy(var pu:typeUO):float;pascal;

procedure proTrevcor_RFtheta(ww:float;var pu:typeUO);pascal;
function fonctionTrevcor_RFtheta(var pu:typeUO):float;pascal;



procedure proTrevcor_installStimSeq(seed,nbDivX,nbDivY,expansion,scotome:integer;
                                    var pu:typeUO);pascal;

function fonctionTrevcor_installTimes(var vecEvt:Tvector;dx:float;var pu:typeUO): boolean;pascal;
function fonctionTrevcor_installTimes_1(var vecEvt:Tvector;dx:float;NoError:boolean; var pu:typeUO): boolean;pascal;


procedure proTrevcor_installFP(var vec:Tvector;var pu:typeUO);pascal;

function fonctionTrevcor_PosCount(var pu:typeUO):longint;pascal;

function fonctionTrevcor_Codes(i:integer;var pu:typeUO):integer;pascal;
procedure proTrevcor_Codes(i:integer;w: integer;var pu:typeUO);pascal;

function fonctionTrevcor_Xpos(i:integer;var pu:typeUO):integer;pascal;
procedure proTrevcor_Xpos(i:integer;w: integer;var pu:typeUO);pascal;

function fonctionTrevcor_Ypos(i:integer;var pu:typeUO):integer;pascal;
procedure proTrevcor_Ypos(i:integer;w: integer;var pu:typeUO);pascal;

function fonctionTrevcor_Zpos(i:integer;var pu:typeUO):integer;pascal;
procedure proTrevcor_Zpos(i:integer;w: integer;var pu:typeUO);pascal;

function fonctionTrevcor_encode(x,y,z:integer;var pu:typeUO):integer;pascal;
procedure proTrevcor_decode(code:integer;var x,y,z:integer;var pu:typeUO);pascal;

procedure proTrevcor_initPsth(var v1,v2:TpsthArray;var source:Tvector;
                              x1,x2,deltaX:float;var pu:typeUO);pascal;
procedure proTrevcor_calculatePsth(var v1,v2:TpsthArray;var source:Tvector;
                                   var pu:typeUO);pascal;

procedure proTrevcor_initPstw(var v1,v2:TaverageArray;var source:Tvector;
                              x1,x2:float;var pu:typeUO);pascal;
procedure proTrevcor_calculatePstw(var v1,v2:TaverageArray;var source:Tvector;
                                   var pu:typeUO);pascal;

procedure proTrevcor_getMatXYZ(var mat1,mat2: Tmatrix;var pu:typeUO);pascal;
procedure proTrevcor_getConditionXYZ(var mat1,mat2: Tmatrix;var pu:typeUO);pascal;
procedure proTrevcor_getCodes(var vec: Tvector;num:integer;var pu:typeUO);pascal;

procedure proTrevcor_initLqrPstw(var source:Tvector;tau1,tau2:integer;var pu:typeUO);pascal;
procedure proTrevcor_initLqrPstH(Lclasse:float;tau1,tau2:integer;var pu:typeUO);pascal;
procedure proTrevcor_calculateLqrPstw(var source:Tvector;var pu:typeUO);pascal;
procedure proTrevcor_SolveLqrPstw(var pu:typeUO);pascal;
procedure proTrevcor_SVD(var mat:Tmat;var pu:typeUO);pascal;

procedure proTrevcor_getLqrPstw(var pstw:TvectorArray;z:integer;raw,Norm:boolean;var pu:typeUO);pascal;
procedure proTrevcor_getLqrResidual(var vec:Tvector;var pu:typeUO);pascal;
procedure proTrevcor_freeLqrPstw(var pu:typeUO);pascal;

procedure proTrevcor_BuildSignal(var var1,var2:TvectorArray;var vec:Tvector;var pu:typeUO);pascal;
procedure proTrevcor_BuildSignal1(var Vlist:TVlist;var vec:Tvector;var pu:typeUO);pascal;

procedure proTrevcor_GetLQRline(seq: integer; tt: float; var vec: Tvector;var pu:typeUO);pascal;

procedure proTrevcor_BuildSimMask(var mat:Tmatrix;var Xpos,Ypos:Tvector;var pu:typeUO);pascal;
procedure proBuildRepSim(var pstw1,pstw2:TvectorArray;var Mlist:TmatList;
                         var dest:Tvector;interframe:float);pascal;

procedure proTrevcor_initKlist(var pu:typeUO);pascal;
procedure proTrevcor_AddK1(x,y,z:integer;var pu:typeUO);pascal;
procedure proTrevcor_AddK2(x1,y1,z1,x2,y2,z2,lag:integer;var pu:typeUO);pascal;

procedure proTrevcor_initLqrPstw1(var source:Tvector;tau1,tau2:integer;var pu:typeUO);pascal;
procedure proTrevcor_calculateLqrPstw1(var source:Tvector;var pu:typeUO);pascal;
procedure proTrevcor_getLqrVector(num:integer;var vec:Tvector;raw,norm:boolean;var pu:typeUO);pascal;
procedure proTrevcor_getLqrKList(var Vlist:TVlist;raw,norm:boolean;var pu:typeUO);pascal;
procedure proTrevcor_setLqrLambda(w: float;var pu:typeUO);pascal;

procedure proTrevcor_getMlist(var Mlist: TmatList;var pu:typeUO);pascal;
procedure proTrevcor_setMlist(var Mlist: TmatList;var pu:typeUO);pascal;

function fonctionTrevcor_matH(var pu:typeUO):pointer; pascal;
function fonctionTrevcor_matB(var pu:typeUO):pointer; pascal;
function fonctionTrevcor_matX(var pu:typeUO):pointer; pascal;

procedure proTrevcor_GridToScreen(x1,y1:float;var x2,y2:float;var pu:typeUO);pascal;

implementation



{*********************   Méthodes de TRevCOR  *************************}

constructor TRevCOR.create;
  var
    i,j:integer;
  begin
    inherited create;
    nbDivX:=5;
    nbDivY:=5;
    lum[1]:=25;
    lum[2]:=0;
    expansion:=100;
    scotome:=0;
    dureeC:=10;
    RFDeg:=degNul;
    Seed:=0;

    listK1:=Tlist.create;
    listK2:=TlistG.create(8);

    listK1bis:=Tlist.create;
    listK2bis:=TlistG.create(8);

    listK1bisV:=Tlist.create;
    listK2bisV:=Tlist.create;
  end;


destructor Trevcor.destroy;
begin
  inherited destroy;

  listK1.free;
  listK2.free;

  listK1bis.free;
  listK2bis.free;

  listK1bisV.free;
  listK2bisV.free;
end;

class function Trevcor.STMClassName:AnsiString;
  begin
    STMClassName:='Revcor';
  end;

procedure Trevcor.setChildNames;
begin
  if assigned(lqrP) then lqrP.setChildNames(ident);
end;

procedure TrevCor.CalculeCentre(place:TseqElt;var ic,jc:float);
  var
    x0,y0:float;
    xc,yc:float;

  begin
    x0 := ((place.x-nX/2 + 0.5) * RFdeg.dX) / nbDivX;
    y0 := ((place.y-nY/2 + 0.5) * RFdeg.dY) / nbDivY;
    DegRotationR(x0,y0,xc,yc,0,0,RFdeg.theta);
    ic:=xc+RFdeg.x;
    jc:=yc+RFdeg.y;
  end;

procedure TrevCor.CalculeCentre1(x,y:integer;var ic,jc:single);
  var
    x0,y0:float;
    xc,yc:float;

  begin
    x0 := ((x-nX/2 + 0.5) * RFdeg.dX) / nbDivX;
    y0 := ((y-nY/2 + 0.5) * RFdeg.dY) / nbDivY;
    DegRotationR(x0,y0,xc,yc,0,0,RFdeg.theta);
    ic:=xc+RFdeg.x;
    jc:=yc+RFdeg.y;
  end;                                                                    

procedure TrevCor.CalculeCentre2(x,y:float;var ic,jc:float);
  var
    x0,y0:float;
    xc,yc:float;

  begin
    x0 := ((x-nX/2 -1) * RFdeg.dX) / nbDivX;
    y0 := ((y-nY/2 -1) * RFdeg.dY) / nbDivY;
    DegRotationR(x0,y0,xc,yc,0,0,RFdeg.theta);
    ic:=xc+RFdeg.x;
    jc:=yc+RFdeg.y;
  end;


procedure TrevCor.RandSequence;
var
  MemoMat : array of array of array of boolean;
  i, j, k: integer;
  nbtot:integer;

begin
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);
  setLength(MemoMat,2,nx,ny);


  GsetRandSeed(seed);

  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
  for k:=0 to 1 do
    memoMat[k,i,j]:=false;

  Nbtot :=nx*ny*2;

  XInf := roundI(nX/2.0 - nbDivX*(Scotome/100)/2.0);
  XSup := roundI(nX/2.0 + nbDivX*(Scotome/100)/2.0) -1;
  YInf := roundI(nY/2.0 - nbDivY*(Scotome/100)/2.0);
  YSup := roundI(nY/2.0 + nbDivY*(Scotome/100)/2.0) -1;

  if (Scotome <> 0) then
    for i:= XInf to XSup do
      for j:= YInf to YSup do
        for k:=0 to 1 do
          begin
            MemoMat[k,i,j]:=TRUE;
            dec(NbTot);
          end;

  setLength(sequence,nbTot);
  cycleCount:=length(sequence);

  for i:= 0 to NbTot-2 do
    with sequence[i] do
    begin
      repeat

         X := Grandom(nX);
         Y := Grandom(nY);
         Z := Grandom(2);
         FP:=1;
      until (MemoMat[Z,X,Y] = FALSE);
      MemoMat[Z,X,Y] := TRUE;
    end;

  for i:=0 to nX-1 do
    for j:=0 to nY-1 do
      for k:=0 to 1 do
        if MemoMat[k,i,j]=FALSE then
          with sequence[nbTot-1] do
          begin
            X:= i;
            Y:= j;
            Z:= k;
            FP:=1;
            exit;
          end;
end;


procedure TRevCOR.InitMvt;
  begin
    inherited;

    index:=-1;

    RandSequence;

    obvis.deg.theta:=RFdeg.theta;

    if AdjustObjectSize then
      begin
        obvis.deg.dx:=RFdeg.dx /nbDivX;
        obvis.deg.dy:=RFdeg.dy /nbDivY;
      end;

    obvis.deg.lum:=lum[1];

    with TimeMan do tend:=torg+dureeC*nbCycle;


    obvisA[1]:=obvis;

    obvisA[2]:=Tresizable(obvis.clone(false));
    obvisA[2].ident:='Clone';
    obvisA[2].deg.lum:=lum[2];
  end;

procedure TrevCor.initObvis;
begin
  obvisA[1].prepareS;
  obvisA[2].prepareS;
end;


procedure TRevCOR.calculeMvt;
  var
    tcycle:longint;
    i,j:integer;
    ic,jc:float;
  begin
    obvisA[1].FlagOnScreen:=false;
    obvisA[2].FlagOnScreen:=false;

    obvisA[1].FlagOnControl:=false;
    obvisA[2].FlagOnControl:=false;

    tCycle:=timeS mod dureeC;
    if (tCycle=0) and (timeS < cycleCount*dureeC) then inc(Index);
    if index>cycleCount then exit;

    calculeCentre(Sequence[Index],ic,jc);

    obvis:=obvisA[Sequence[Index].Z+1];
    obvis.deg.x:=ic;
    obvis.deg.y:=jc;
  end;

procedure Trevcor.doneMvt;
begin

  obvisA[2].free;
  obvis:=obvisA[1];
end;


procedure Trevcor.buildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin
      setVarConf('nbDivX',nbDivX,sizeof(nbDivX));
      setVarConf('nbDivY',nbDivY,sizeof(nbDivY));
      setVarConf('Lum',lum,sizeof(lum));
      setVarConf('expansion',expansion,sizeof(expansion));
      setVarConf('scotome',scotome,sizeof(scotome));
      setVarConf('RFdeg',RFdeg,sizeof(RFdeg));
      setVarConf('seed',Seed0,sizeof(Seed0));
      setVarConf('ADjustSize',AdjustObjectSize,sizeof(AdjustObjectSize));
    end;

  end;

function Trevcor.getInfo:AnsiString;
begin
  result:=inherited getInfo+CRLF+
          'nbDivX=    '+Istr(nbDivX)+CRLF+
          'nbDivY=    '+Istr(nbDivY)+CRLF+
          'lum1=      '+Estr(lum[1],3)+CRLF+
          'lum2=      '+Estr(lum[2],3)+CRLF+
          'Expansion= '+Istr(expansion)+CRLF+
          'Scotome=   '+Istr(scotome)+CRLF+
          'RF.x=      '+Estr1(RFdeg.x,10,3)+CRLF+
          'RF.y=      '+Estr1(RFdeg.y,10,3)+CRLF+
          'RF.dx=     '+Estr1(RFdeg.dx,10,3)+CRLF+
          'RF.dy=     '+Estr1(RFdeg.dy,10,3)+CRLF+
          'RF.theta=  '+Estr1(RFdeg.theta,10,3)+CRLF+
          'Seed=      '+Istr(seed)+CRLF+
          'AdjustObjectSize='+Bstr(AdjustObjectSize)+CRLF;
end;

procedure Trevcor.CompleteLoadInfo;
begin
  CheckOldIdent;
  randSequence;
  majPos;
end;

procedure Trevcor.selectRF;
var
  res:integer;
begin
  res:=FormselectRF.showModal;
  if res>100 then
    begin
      RFdeg:=RFsys[res-100].deg;
      majpos;
    end;
end;

function Trevcor.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetRevCor1;
end;

procedure Trevcor.installDialog(var form:Tgenform;var newF:boolean);
begin
    installForm(form,newF);

    with TgetRevcor1(form) do
    begin
      enDelay.setVar(timeMan.tOrg,T_longInt);
      enDelay.setMinMax(0,maxEntierLong);
      enDelay.Dxu:=Tfreq/1E6;

      enDtON.setVar(timeMan.dtON,T_longInt);
      enDtON.setMinMax(0,maxEntierLong);
      enDtON.Dxu:=Tfreq/1E6;

      enDtOff.setVar(timeMan.dtOff,T_longInt);
      enDtOff.setMinMax(0,maxEntierLong);
      enDtOff.Dxu:=Tfreq/1E6;

      enCycleCount.setVar(timeMan.nbCycle,T_longInt);
      enCycleCount.setMinMax(0,maxEntierLong);

      enDivX.setVar(nbDivX,T_smallint);
      enDivX.setMinMax(1,32000);

      enDivY.setVar(nbDivY,T_smallint);
      enDivY.setMinMax(1,32000);

      enDivY.setVar(nbDivY,T_smallint);
      enDivY.setMinMax(1,32000);

      enLum1.setVar(lum[1],T_single);
      enLum1.setMinMax(0,10000);

      enLum2.setVar(lum[2],T_single);
      enLum2.setMinMax(0,10000);

      enExpansion.setVar(Expansion,T_smallint);
      enExpansion.setMinMax(1,32000);

      enScotome.setVar(Scotome,T_smallint);
      enScotome.setMinMax(0,32000);

      selectRFD:=SelectRF;

      enSeed.setVar(seed0,T_smallint);
      CBadjust.setvar(adjustObjectSize);

      onControlD:=SetOnControl;   {Ces procédures doivent être mises en place}
      onScreenD:=SetOnScreen;     {AVANT de modifier checked }

      CbOnControl.checked:=onControl;
      CbOnScreen.checked:=onScreen;

      initCBvisual(self,typeUO(obvis));
    end;
end;



procedure Trevcor.afficheC;
  var
    x,y,dx,dy:integer;
    deg:typeDegre;
    poly,polyAff:typePoly5;
    d12x,d12y:float;
    d14x,d14y:float;
    i:integer;

  begin
    nX := roundI(nbDivX*Expansion/100.0);
    nY := roundI(nbDivY*Expansion/100.0);

    deg:=RFdeg;
    deg.dx:=RFdeg.dx*nx/nbDivX;
    deg.dy:=RFdeg.dy*ny/nbDivY;

    degToPolyAff(deg,polyAff);

    d12x:=(polyAff[2].x-polyAff[1].x)/nx;
    d12y:=(polyAff[2].y-polyAff[1].y)/ny;

    d14x:=(polyAff[4].x-polyAff[1].x)/nx;
    d14y:=(polyAff[4].y-polyAff[1].y)/ny;


    with canvasGlb do
    begin
      pen.color:=clBlue;
      i:=0;
      while i<=nx do
      begin
        moveto(polyAff[1].x+round(i*d12x) ,polyAff[1].y+round(i*d12y));
        lineto(polyAff[4].x+round(i*d12x) ,polyAff[4].y+round(i*d12y));
        inc(i);
      end;

      i:=0;
      while i<=ny do
      begin
        moveto(polyAff[1].x+round(i*d14x) ,polyAff[1].y+round(i*d14y));
        lineto(polyAff[2].x+round(i*d14x) ,polyAff[2].y+round(i*d14y));
        inc(i);
      end;
    end;
  end;

procedure Trevcor.afficheS;
begin
end;

procedure Trevcor.setSeed(x:integer);
begin
  seed0:=x;
end;

function Trevcor.getSeed:integer;
begin
  result:=seed0;
end;


{Deux procédures d'initialisation indispensables }

procedure Trevcor.installSequence(seed1, nbdivX1, nbdivY1, expansion1, scotome1: integer);
begin
  seed:=seed1;
  nbDivX:=nbdivX1;
  nbDivY:=nbdivY1;
  expansion:=expansion1;
  scotome:=scotome1;

  randSequence;
end;

function Trevcor.InstallTimes(vec:Tvector;dx:float;var stE:string): boolean;
var
  i:integer;
begin
  if (cycleCount=0) then
  begin
    stE:='Trevcor: sequence not installed';
    result:=false;
    exit;
  end;

  dxEvt:=dx;
  setLength(EvtTimes,vec.ICount);
  for i:=vec.Istart to vec.Iend do
    EvtTimes[i-vec.Istart]:=roundL(vec.Yvalue[i]/dxEvt);

  result:= (vec.Icount=cycleCount);

  if not result then stE:='Trevcor: installTimes failed';

  if cycleCount>1 then DTmesure:=(EvtTimes[cycleCount-1]-EvtTimes[0])*DxEvt/(cycleCount-1);
end;

function Trevcor.CorrectTimes:boolean;
var
  i:integer;
  dt,dtM,delta:float;
begin
  dtM:=(EvtTimes[cycleCount-1]-EvtTimes[0])/(cycleCount-1);

  i:=0;
  while i<high(EvtTimes) do
  begin
    dt:=EvtTimes[i+1]-EvtTimes[i];
    if dt > dtM*1.9 then
    begin
      setLength(EvtTimes,length(EvtTimes)+1);
      move(EvtTimes[i],EvtTimes[i+1],sizeof(EvtTimes[0])*(high(EvtTimes)-i));
      EvtTimes[i]:=EvtTimes[i]+round(dt);
    end
    else
    if dt<dtM*0.51 then
    begin
      move(EvtTimes[i+2],EvtTimes[i+1],sizeof(EvtTimes[0])*(high(EvtTimes)-i-1));
      setLength(EvtTimes,length(EvtTimes)-1);
    end;
    inc(i);
  end;
  result:=(cycleCount=length(EvtTimes));
end;

procedure Trevcor.InstallFP(vec:Tvector);
var
  i:integer;
begin
  for i:=0 to cycleCount-1 do
    sequence[i].fp:=vec.Jvalue[i+vec.Istart];
end;



{ Calcul des PSTW }

procedure TrevCor.initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);
var
  i,i1,i2:integer;
  pstw:array[1..2] of TaverageArray;
  tp:typetypeG;
begin
  pstw[1]:=var1;
  pstw[2]:=var2;

  i1:=roundL(x1/source.dxu);
  i2:=roundL(x2/source.dxu);

  for i:=1 to 2 do
    begin
      pstw[i].initarray(1,nx,1,ny);
      pstw[i].initAverages(i1,i2,g_single);
      pstw[i].dxu:=source.dxu;

      pstw[i].clear;
    end;
end;


procedure TrevCor.calculatePstw(var1,var2:TaverageArray;source:Tvector);
var
  i:integer;
  t:double;
  vv:Taverage;
  pstw:array[1..2] of TaverageArray;
begin
  pstw[1]:=var1;
  pstw[2]:=var2;

  for i:=1 to 2 do
    if not assigned(pstw[i])  then exit;
  if not sequenceInstalled then exit;

  for i:=0 to cycleCount-1 do
    begin
      t:=EvtTimes[i]*dxEvt;
      with sequence[i] do
      begin
        vv:=pstw[z+1].average(x+1,y+1);
        if assigned(vv) then
        begin
          if fp>0 then vv.addEx(source,t)
        end;
        //else sortieErreur('TrevCor.calculatePstw : invalid average object ');
      end;
    end;

end;

{ Calcul des Psths }

procedure Trevcor.initPsth(var1, var2: TpsthArray; source: Tvector; x1,x2,deltaX: float);
var
  i,i1,i2:integer;
  psth:array[1..2] of TpsthArray;
begin
  psth[1]:=var1;
  psth[2]:=var2;

  i1:=roundL(x1/deltaX);
  i2:=roundL(x2/deltaX);

  for i:=1 to 2 do
    begin
      psth[i].initarray(1,nx,1,ny);
      psth[i].initPsths(i1,i2,g_longint,deltaX);
      psth[i].clear;
    end;
end;


procedure Trevcor.calculatePsth(var1, var2: TpsthArray; source: Tvector);
var
  i:integer;
  t:double;
  vv:Tpsth;
  psth:array[1..2] of TpsthArray;
begin
  psth[1]:=var1;
  psth[2]:=var2;

  for i:=1 to 2 do
    if not assigned(psth[i])  then exit;
  if not sequenceInstalled then exit;

  for i:=0 to cycleCount-1 do
    begin
      t:=EvtTimes[i]*dxEvt;
      with sequence[i] do
      begin
        vv:=psth[z+1].psths(x+1,y+1);
        if assigned(vv) then
        begin
          if FP>0 then vv.addEx(source,t);
        end;
        //else sortieErreur('TrevCor.calculatePsth : invalid psth object ');
      end;
    end;

end;

{ Codage et décodage: x,y et z commencent à zéro
  Le code est z+nz*(y+ny*x)  , il commence aussi à zéro
}


procedure TrevCor.decode(code:integer;var x,y,z:integer);
begin
  z:=code mod 2;
  code:=(code-z) div 2;
  y:=code mod ny;
  x:=(code-y) div ny;
end;

function TrevCor.encode(x,y,z:integer):integer;
begin
  result:=z+2*(y+ny*x);
end;

function Trevcor.EltCode(Elt: TseqElt): integer;
begin
  with Elt do result:=encode(x,y,z);
end;


function TrevCor.getX(code:integer):integer;
var
  x,y,z:integer;
begin
  z:=code mod 2;
  code:=(code-z) div 2;
  y:=code mod ny;
  result:=(code-y) div ny;
end;

function TrevCor.getY(code:integer):integer;
var
  x,y,z:integer;
begin
  z:=code mod 2;
  code:=(code-z) div 2;
  result:=code mod ny;
end;

function TrevCor.getZ(code:integer):integer;
var
  x,y,z:integer;
begin
  result:=code mod 2;
end;



procedure Trevcor.getMatXYZ(mat1, mat2: Tmatrix);
var
  i:integer;
  x,y,z:integer;
begin
  if not assigned(mat1) or not assigned(mat2) then exit;
  if not sequenceInstalled then exit;

  mat1.initTemp(1,nx,1,ny,g_longint);
  mat2.initTemp(1,nx,1,ny,g_longint);

  for i:=0 to cycleCount-1 do
  with sequence[i] do
  begin
    if z=0
      then mat1.Kvalue[x+1,y+1]:=EvtTimes[i]
      else mat2.Kvalue[x+1,y+1]:=EvtTimes[i];
  end;
end;

procedure Trevcor.getConditionXYZ(mat1, mat2: Tmatrix);
var
  i:integer;
  x,y,z:integer;
begin
  if not assigned(mat1) or not assigned(mat2) then exit;
  if not sequenceInstalled then exit;

  mat1.initTemp(1,nx,1,ny,G_smallint);
  mat2.initTemp(1,nx,1,ny,G_smallint);

  for i:=0 to cycleCount-1 do
  with sequence[i] do
  begin
    if z=0
      then mat1.Kvalue[x+1,y+1]:=ord(fp)
      else mat2.Kvalue[x+1,y+1]:=ord(fp);
  end;
end;


procedure Trevcor.getCodes(vec: Tvector;num:integer);
var
  i,cc:integer;
begin
  if not assigned(vec)  then exit;
  if not sequenceInstalled then exit;

  vec.modify(g_longint,0,nx*ny*2-1);

  for i:=0 to cycleCount-1 do
  begin
    with sequence[i] do cc:=encode(x,y,z);

    if (i+num>=0) and (i+num<=cycleCount-1)
      then with sequence[i+num] do vec.Jvalue[cc]:=encode(x,y,z)
      else vec.Jvalue[cc]:=-1;
  end;
end;


function Trevcor.LqrNz:integer;
begin
  result:=2;
end;

procedure Trevcor.initLqrPstw(source:Tvector;tau1,tau2:integer);
var
  ntau:integer;
begin
  FlqrPsth:=false;
  ntau:=tau2-tau1+1;

  if tau1>tau2 then exit;

  KPtau1:=tau1;
  KPtau2:=tau2;

  KPdt:=source.Dxu;
  KPnbt:=round(DTmesure/KPdt);

  if not assigned(lqrP) then
  begin
    lqrP:=TchkPstw.create;
    setChildNames;

    addToChildList(lqrP.MatH);
    addToChildList(lqrP.pstw);
    addToChildList(lqrP.XX);
  end;

  lqrP.init(nx*ny*lqrNz*ntau ,KPnbt);
  lqrP.fONE:=true;

  DumPsth.free;
  DumPsth:=nil;
end;

procedure Trevcor.initLqrPsth(Lclasse:float;tau1,tau2:integer);
var
  ntau:integer;
begin
  FlqrPsth:=true;
  ntau:=tau2-tau1+1;

  if tau1>tau2 then exit;

  KPtau1:=tau1;
  KPtau2:=tau2;

  KPnbt:=round(DTmesure/Lclasse);
  KPdt:=DTmesure/KPnbt;

  if not assigned(lqrP)
    then lqrP:=TchkPstw.create;
  lqrP.init(nx*ny*lqrNz*ntau,KPnbt);

  DumPsth.free;
  Dumpsth:=Tpsth.create;
  Dumpsth.initTemp(0,KPnbt,g_longint,KPdt);

end;


procedure Trevcor.BuildMatSline(i:integer);
var
  ntau:integer;
  k,index:integer;
begin
  lqrP.clearMatSline;
  ntau:=KPtau2-KPtau1+1;

  for k:=KPtau1 to KPTau2 do
  begin
    if (i-k>=0) and (i-k<cycleCount) then
    begin
      index:=k-KPtau1 +ntau*eltCode(sequence[i-k]) ;
      lqrP.MatSline[index]:=1;
    end;
  end;
end;

procedure Trevcor.BuildBXline(source:Tvector;i:integer);
var
  ntau:integer;
  j,k,index:integer;
begin
  lqrP.clearBXline;
  ntau:=KPtau2-KPtau1+1;

  if not FlqrPsth then
  for j:=0 to KPnbt-1 do
    lqrP.BXline[j]:=source.Rvalue[EvtTimes[i]*DxEvt+j*KPdt]
  else
  begin
    DumPsth.clear;
    Dumpsth.AddEx(source,EvtTimes[i]*DxEvt);
    for j:=0 to KPnbt-1 do
      lqrP.BXline[j]:=Dumpsth.Yvalue[j];
  end;

end;


procedure Trevcor.calculateLqrPstw(source:Tvector);
var
  i:integer;
begin
  for i:=0 to cycleCount-1 do
  begin
    BuildMatSline(i);
    BuildBXline(source,i);
    lqrP.UpdateHessian;
  end;
end;



procedure Trevcor.SolveLqrPstw;
begin
  lqrP.solve(false);
  {lqrP.correctionXX(KPtau2-KPtau1+1);}

  dumPsth.Free;
  dumPsth:=nil;
end;

procedure Trevcor.SVD(mat:Tmat);
begin
  lqrP.calculSVD(mat);
end;



procedure Trevcor.getLqrPstw(pstw:TvectorArray;z:integer;raw,Norm:boolean);
var
  i1,i2:integer;
  i,j,k,x,y,tau:integer;
  KPcode:integer;

  N,nTau:integer;
  index:integer;

begin
  z:=z-1;

  nTau:=KPtau2-KPtau1+1;
  if (nTau<1) or (KPdt<=0) or not assigned(lqrP) then exit;

  i1:=KPtau1*KPnbt;
  i2:=(KPtau2+1)*KPnbt-1;

  if (z=0) or (z=1) then
  begin
    pstw.initarray(1,nx,1,ny);
    pstw.initvectors(i1,i2,g_single);
    pstw.dxu:=KPdt;
                      { Construction des Pstws }

    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      KPcode:=ntau*enCode(x,y,z) {+1};
      lqrP.getVector(KPcode,ntau,Pstw[x+1,y+1],raw,Norm );
    end;
  end
  else
  begin
    pstw.initarray(1,nx,1,ny*2);
    pstw.initvectors(i1,i2,g_single);
    pstw.dxu:=KPdt;

    for z:=0 to 1 do
    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      KPcode:=ntau*enCode(x,y,z) {+1};
      lqrP.getVector(KPcode,ntau,Pstw[x+1,y+1+z*ny],raw,Norm );
    end;
  end;

end;

procedure Trevcor.getLqrResidual(vec:Tvector);
begin
  lqrP.getResidual(vec);
end;

procedure Trevcor.freeLqrPstw;
begin
  if assigned(lqrP)
    then lqrP.Init(0,0);
end;

procedure Trevcor.initKlist;
begin
  listK1.clear;
  listK2.clear;

  listK1bis.clear;
  listK2bis.clear;

  listK1bisV.clear;
  listK2bisV.clear;
end;


procedure Trevcor.AddK1(x, y, z: integer);
var
  w:integer;
begin
  x:=x-1;
  y:=y-1;
  z:=z-1;

  w:=x+y shl 8+ z shl 16 ;
  listK1.add(pointer(w));
end;

procedure Trevcor.AddK2(x1a, y1a, z1a, x2a, y2a, z2a,lag: integer);
var
  w:TELtK2;
begin
  w.x1:=x1a;
  w.y1:=y1a;
  w.z1:=z1a;
  w.t1:=0;
  w.x2:=x2a;
  w.y2:=y2a;
  w.z2:=z2a;
  w.t2:=lag;

  listK2.add(@w);
end;


procedure Trevcor.initLqrPstw1(source: Tvector;tau1,tau2:integer);
var
  ntau:integer;
begin
  FlqrPsth:=false;

  ntau:=tau2-tau1+1;
  if tau1>tau2 then exit;

  KPtau1:=tau1;
  KPtau2:=tau2;

  KPdt:=source.Dxu;
  KPnbt:=round(DTmesure/KPdt);

  if not assigned(lqrP)
    then lqrP:=TchkPstw.create;
  lqrP.init(listK1.count*ntau + listK2.count*ntau ,KPnbt);

end;

procedure Trevcor.calculateLqrPstw1(source: Tvector);
var
  i,j,k1,k2:integer;
  index:integer;
  w:integer;

  nTau:integer;
  nbpos:integer;
  psth:Tpsth;
  flag:boolean;
  w2:TEltK2;
begin
  nTau:=KPtau2-KPtau1+1;

  if FlqrPsth then
  begin
    psth:=Tpsth.create;
    psth.initTemp(0,KPnbt,g_longint,KPdt);
  end;

  try

  for i:=0 to cycleCount-1 do
  begin
    lqrP.ClearMatSline;
    lqrP.ClearBXline;

    flag:=false;
    for k1:=KPtau1 to KPTau2 do
      if (i-k1>=0) and (i-k1<cycleCount) then
      begin
        with sequence[i-k1] do
          w:=x+y shl 8+ z shl 16 ;
        index:=listK1.IndexOf(pointer(w));
        if index>=0 then
        begin
          lqrP.MatSline[index*ntau+k1-KPtau1]:=1;
          flag:=true;
        end;

        index:=listK1bis.IndexOf(pointer(w));
        if index>=0 then
        begin
          lqrP.MatSline[(index div nbK1bis)*ntau+k1-KPtau1]:=intG(listK1bisV[index]);
          flag:=true;
        end;

      end;

    if flag then
    begin
      if not FlqrPsth then
      for j:=0 to KPnbt-1 do
        lqrP.BXline[j]:=source.Rvalue[EvtTimes[i]*DxEvt+j*KPdt]
      else
      begin
        psth.clear;
        psth.AddEx(source,EvtTimes[i]*DxEvt);
        for j:=0 to KPnbt-1 do
          lqrP.BXline[j]:=psth.Yvalue[j];
      end;

      lqrP.updateHessian;
    end;
  end;

  finally
  if FlqrPsth then psth.Free;
  end;
end;

procedure Trevcor.getLqrVector(num: integer; vec: Tvector;raw,norm:boolean);
var
  i1,i2:integer;
  i,j,k,x,y,tau:integer;
  KPcode:integer;

  N,nTau:integer;
  index:integer;

begin
  nTau:=KPtau2-KPtau1+1;
  if (nTau<1) or (KPdt<=0) or not assigned(lqrP) then exit;

  i1:=KPtau1*KPnbt;
  i2:=(KPtau2+1)*KPnbt-1;

  vec.initTemp1(i1,i2,g_single);
  vec.dxu:=KPdt;

  lqrP.getVector(num,ntau,vec,raw,norm );

end;

procedure Trevcor.getLqrKList( Vlist:TVlist;raw,norm:boolean);
var
  Vdum:Tvector;
  ntau:integer;
  i,i1,i2:integer;
begin
  nTau:=KPtau2-KPtau1+1;
  if (nTau<1) or (KPdt<=0) or not assigned(lqrP) then exit;

  i1:=KPtau1*KPnbt;
  i2:=(KPtau2+1)*KPnbt-1;

  Vdum:=Tvector.create;
  Vdum.initTemp1(i1,i2,g_single);
  Vdum.dxu:=KPdt;

  Vlist.clear;

  TRY
  for i:=0 to listK1.count-1 do
  begin
    lqrP.getVector(i*ntau,ntau,Vdum,raw,norm );
    Vlist.AddVector(Vdum);
  end;

  for i:=0 to listK2.count-1 do
  begin
    lqrP.getVector(listK1.count*ntau+ i*ntau,ntau,Vdum,raw,norm );
    Vlist.AddVector(Vdum);
  end;


  FINALLY
  Vdum.Free;
  END;
end;

procedure Trevcor.BuildXSignal(vec:Tvector);
var
  tmax:float;
  i,j,j0:integer;
  tt:float;
begin
  if not sequenceInstalled or (KPdt=0) then exit;

  tmax:=EvtTimes[cycleCount-1]*DxEvt + DTmesure +100;

  vec.X0u:=0;
  vec.Dxu:=KPdt;
  if vec.Xend<tmax then
    vec.initTemp1(0,vec.invconvx(tmax),g_single);

  lqrP.fONE:=false;

  for i:=0 to cycleCount-1 do
  with sequence[i] do
  begin
    BuildMatSline(i);
    lqrP.BuildOutLine;

    tt:=evtTimes[i]*Dxevt;
    j0:=vec.invconvx(tt);
    for j:=0 to lqrP.Nt-1 do
    vec.Yvalue[j0+j]:=lqrP.outline[j];
  end;

  lqrP.fONE:=true;
end;

procedure Trevcor.BuildSignal(var1,var2:TvectorArray;vec:Tvector);
var
  i,j:integer;
  pstw:array[1..2] of TvectorArray;
  vv:Tvector;
  tt,tmax:float;
  j0:integer;

begin

  pstw[1]:=var1;
  pstw[2]:=var2;

  if not sequenceInstalled then exit;

  tmax:=EvtTimes[cycleCount-1]*DxEvt+pstw[1].Xend;

  vec.X0u:=0;
  vec.Dxu:=pstw[1].dxu;
  if vec.Xend<tmax then
    vec.initTemp1(0,vec.invconvx(tmax),g_single);

  for i:=0 to cycleCount-1 do
  with sequence[i] do
  begin
    vv:=Pstw[z+1][x+1,y+1];
    tt:=evtTimes[i]*Dxevt;
    j0:=vec.invconvx(tt);
    for j:=0 to vv.Iend do
    vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]+vv.Yvalue[j];
  end;
end;


procedure Trevcor.BuildSignal1(Vlist: TVlist; vec: Tvector);
begin

end;

procedure Trevcor.BuildSignalSpk1(Vlist: TVlist; vec: Tvector;
  Nmax: integer);
begin

end;



function Trevcor.sequenceInstalled: boolean;
begin
  result:=(cycleCount>0) and (length(EvtTimes)=cycleCount) and (length(sequence)=cycleCount);
end;


procedure Trevcor.getLQRline(seq: integer; tt: float; vec: Tvector);
var
  n,k,i:integer;
  Itime:integer;
begin
  if not assigned(LqrP) or (LqrP.Ni=0) or (LqrP.Neq=0) then exit;

  vec.initTemp1(0,LqrP.Ni-1,G_smallint);


  if tt<evtTimes[0]*DxEvt then exit;
  if tt>evtTimes[high(evtTimes)]*DxEvt+DTmesure then exit;

  Itime:=round(tt/DXevt);

  k:=high(EvtTimes);
  while (k>0) and (Itime<evtTimes[k]) do dec(k);

  n:=(seq-1)*cycleCount;

  {
  if k>=0 then
  with lqrP do
  begin
    for i:=0 to Ni-1 do
      vec.Yvalue[i]:=matS[n+k,i];
  end;
  }
end;


{ Mat est une matrice contenant la petite barre affichée par revcor.
  Les régions occupées par la barre contiennent des 1, les autres régions contiennent 0

  Xpos et Ypos contiennent toutes les positions de la barre sur la grille
}

procedure Trevcor.BuildRevMask(mat:Tmatrix;Xpos,Ypos:Tvector);
var
  bar:Tbar;
  i,j,k:integer;
  x,y:single;
  xorg,yorg:integer;

begin
  bar:=Tbar.create;
  bar.deg:=RFdeg;
  bar.deg.dx:=RFdeg.dx /nbDivX;
  bar.deg.dy:=RFdeg.dy /nbDivY;
  bar.buildMaskSingle(mat);

  xorg:=(mat.Icount{-1}) div 2;
  yorg:=(mat.Jcount{-1}) div 2;

  bar.free;

  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);

  Xpos.initTemp1(0,Nx*Ny-1,g_longint);
  Ypos.initTemp1(0,Nx*Ny-1,g_longint);

  k:=0;
  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
  begin
    calculeCentre1(i,j,x,y);
    Xpos.Rvalue[k]:=degToX(x)-xorg;
    Ypos.Rvalue[k]:=degToY(y)-yorg;
    inc(k);
  end;
end;

procedure Trevcor.setLqrLambda(w: float);
begin
  lqrP.lambda:=w;
end;

procedure Trevcor.getMlist(Mlist: TmatList);
var
  mat:Tmatrix;
  i:integer;
begin
  Mlist.clear;
  mat:=Tmatrix.create;
  try
  mat.initTemp(1,Nx,1,Ny,G_short);


  for i:=0 to cycleCount-1 do
  with sequence[i] do
  begin
    mat.clear;
    if z=0
      then mat.Zvalue[x+1,y+1]:=-1
      else mat.Zvalue[x+1,y+1]:=1;

    Mlist.AddMatrix(mat);
  end;

  finally
  mat.free;
  end;
end;

procedure Trevcor.setMlist(Mlist: TmatList);
begin
end;

procedure Trevcor.Display;
var
  x,y,dx,dy:integer;
  deg:typeDegre;
  poly:typePoly5R;
  d12x,d12y:float;
  d14x,d14y:float;
  i:integer;

begin
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);

  deg:=RFdeg;

  deg.dx:=RFdeg.dx*nx/nbDivX;
  deg.dy:=RFdeg.dy*ny/nbDivY;

  degToPolyR(deg,poly);

  d12x:=(poly[2].x-poly[1].x)/nx;
  d12y:=(poly[2].y-poly[1].y)/ny;

  d14x:=(poly[4].x-poly[1].x)/nx;
  d14y:=(poly[4].y-poly[1].y)/ny;


  with canvasGlb do
  begin
    pen.Color:=Dcolor;
    pen.width:=DlineWidth;

    i:=0;
    while i<=nx do
    begin
      moveto(convWx(poly[1].x+i*d12x) ,convWy(poly[1].y+i*d12y));
      lineto(convWx(poly[4].x+i*d12x) ,convWy(poly[4].y+i*d12y));
      inc(i);
    end;

    i:=0;
    while i<=ny do
    begin
      moveto(convWx(poly[1].x+i*d14x) ,convWy(poly[1].y+i*d14y));
      lineto(convWx(poly[2].x+i*d14x) ,convWy(poly[2].y+i*d14y));
      inc(i);
    end;
  end;
end;

function Trevcor.Plotable:boolean;
begin
  result:=true;
end;


{************** Méthodes STM  de Trevcor *****************************}

procedure proTrevcor_create(var pu:typeUO);
begin
  createPgObject('',pu,Trevcor);
end;

procedure proTrevcor_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,Trevcor);
end;

procedure proTrevcor_setRF(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(num,1,5);
  Trevcor(pu).RFdeg:=RFsys[num].deg;
end;

function fonctionTrevcor_Xcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
    fonctionTrevcor_Xcount:=roundI(nbDivX*Expansion/100.0);
end;

function fonctionTrevcor_Ycount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
    fonctionTrevcor_Ycount:=roundI(nbDivY*Expansion/100.0);
end;

procedure proTrevcor_divXcount(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,2000);
  Trevcor(pu).nbdivX:=ww;
end;

function fonctionTrevcor_divXcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTrevcor_divXcount:=Trevcor(pu).nbdivX;
end;

procedure proTrevcor_divYcount(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,2000);
  Trevcor(pu).nbdivY:=ww;
end;

function fonctionTrevcor_divYcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTrevcor_divYcount:=Trevcor(pu).nbdivY;
end;


procedure proTrevcor_Lum1(ww:float;var pu:typeUO);
begin
verifierObjet(pu);
controleParametre(ww,0,10000);
Trevcor(pu).lum[1]:=ww;
end;

function fonctionTrevcor_lum1(var pu:typeUO):float;
begin
verifierObjet(pu);
result:=Trevcor(pu).lum[1];
end;


procedure proTrevcor_lum2(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,0,10000);
  Trevcor(pu).lum[2]:=ww;
end;

function fonctionTrevcor_lum2(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Trevcor(pu).lum[2];
end;

procedure proTrevcor_expansion(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,1000);
  Trevcor(pu).expansion:=ww;
end;

function fonctionTrevcor_expansion(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTrevcor_expansion:=Trevcor(pu).expansion;
end;

procedure proTrevcor_scotome(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,0,32000);
  Trevcor(pu).scotome:=ww;
end;

function fonctionTrevcor_scotome(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTrevcor_scotome:=Trevcor(pu).scotome;
end;

procedure proTrevcor_Seed(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Trevcor(pu).Seed:=ww;
end;

function fonctionTrevcor_Seed(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTrevcor_Seed:=Trevcor(pu).seed;
end;

procedure proTrevcor_AdjustObjectSize(ww:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  Trevcor(pu).AdjustObjectSize:=ww;
end;

function fonctionTrevcor_AdjustObjectSize(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  fonctionTrevcor_AdjustObjectSize:=Trevcor(pu).AdjustObjectSize;
end;

procedure proTrevcor_updateSequence(var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do randSequence;
end;

procedure proTrevcor_RFx(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  if RFdeg.x<>ww then RFdeg.x:=ww;
end;

function fonctionTrevcor_RFx(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTrevcor_RFx:=Trevcor(pu).RFdeg.x;
end;

procedure proTrevcor_RFy(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  if RFdeg.y<>ww then RFdeg.y:=ww;
end;

function fonctionTrevcor_RFy(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTrevcor_RFy:=Trevcor(pu).RFdeg.y;
end;

procedure proTrevcor_RFdx(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,32000);
  with Trevcor(pu) do
  if RFdeg.dx<>ww then RFdeg.dx:=ww;
end;

function fonctionTrevcor_RFdx(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTrevcor_RFdx:=Trevcor(pu).RFdeg.dx;
end;

procedure proTrevcor_RFdy(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,32000);
  with Trevcor(pu) do
  if RFdeg.dy<>ww then RFdeg.dy:=ww;
end;

function fonctionTrevcor_RFdy(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTrevcor_RFdy:=Trevcor(pu).RFdeg.dy;
end;

procedure proTrevcor_RFtheta(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  if RFdeg.theta<>ww then RFdeg.theta:=ww;
end;

function fonctionTrevcor_RFtheta(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTrevcor_RFtheta:=Trevcor(pu).RFdeg.theta;
end;


procedure proTrevCor_installStimSeq(seed,nbDivX,nbDivY,expansion,scotome:integer;
                                            var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  TrevCor(pu).installSequence(seed,nbDivX,nbDivY,expansion,scotome);
end;


function fonctionTrevcor_installTimes(var vecEvt:Tvector;dx:float;var pu:typeUO): boolean;
begin
  result:= fonctionTrevcor_installTimes_1(vecEvt , dx, false,pu);
end;

function fonctionTrevcor_installTimes_1(var vecEvt:Tvector;dx:float;NoError:boolean; var pu:typeUO): boolean;
var
  stE:string;
begin
  verifierObjet(typeUO(pu));
  verifierVecteur(vecEvt);
  with Trevcor(pu) do
    result:= InstallTimes(vecEvt,dx,stE);

  if not result and not NoError then sortieErreur(stE);
end;



procedure proTrevcor_installFP(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with Trevcor(pu) do
  begin
    if (CycleCount=0) or (vec.Icount<CycleCount)
      then sortieErreur('Trevcor: stim. sequence not installed');
    InstallFP(vec);
  end;
end;




function fonctionTrevcor_PosCount(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  with Trevcor(pu) do result:=CycleCount;
end;

function fonctionTrevcor_Codes(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('Trevcor: sequence index out of range');
    result:=EltCode(sequence[i-1]);
  end;
end;

procedure proTrevcor_Codes(i:integer;w: integer;var pu:typeUO);
var
  x1,y1,z1: integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('Trevcor: sequence index out of range');

    decode(w,x1,y1,z1);
    with sequence[i-1] do
    begin
      x:=x1;
      y:=y1;
      z:=z1;
    end;
  end;
end;

function fonctionTrevcor_Xpos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('Trevcor: sequence index out of range');
    result:=sequence[i-1].x+1;
  end;
end;

procedure proTrevcor_Xpos(i:integer;w: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('Trevcor: sequence index out of range');
    sequence[i-1].x:= w-1;
  end;
end;

function fonctionTrevcor_Ypos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('Trevcor: sequence index out of range');
    result:=sequence[i-1].y+1;
  end;
end;

procedure proTrevcor_Ypos(i:integer;w: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('Trevcor: sequence index out of range');
    sequence[i-1].y:= w-1;
  end;
end;

function fonctionTrevcor_Zpos(i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('Trevcor: sequence index out of range');
    result:=sequence[i-1].z+1;
  end;
end;

procedure proTrevcor_Zpos(i:integer;w: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount)
      then sortieErreur('Trevcor: sequence index out of range');
    sequence[i-1].z:= w-1;
  end;
end;



function fonctionTrevcor_encode(x,y,z:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    result:=encode(x-1,y-1,z-1);
  end;
end;

procedure proTrevcor_decode(code:integer;var x,y,z:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do
  begin
    decode(code,x,y,z);
    inc(x);
    inc(y);
    inc(z);
  end;
end;


procedure proTrevcor_initPsth(var v1,v2:TpsthArray;var source:Tvector;
                                      x1,x2,deltaX:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));

  verifierVecteur(source);

  if deltaX<=0 then sortieErreur('Trevcor.initPsth : invalid binWidth');
  if x2<x1 then sortieErreur('Trevcor.initPsth : invalid psth bounds');


  with Trevcor(pu) do initPsth(v1,v2,source,x1,x2,deltaX);
end;

procedure proTrevcor_calculatePsth(var v1,v2:TpsthArray;var source:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do calculatePsth(v1,v2,source);
end;


procedure proTrevcor_initPstw(var v1,v2:TaverageArray;var source:Tvector;
                                      x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));

  verifierVecteur(source);

  with Trevcor(pu) do initPstw(v1,v2,source,x1,x2);
end;

procedure proTrevcor_calculatePstw(var v1,v2:TaverageArray;var source:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do calculatePstw(v1,v2, source);
end;



procedure proTrevcor_getMatXYZ(var mat1,mat2: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat1));
  verifierObjet(typeUO(mat2));

  Trevcor(pu).getMatXYZ(mat1,mat2);
end;

procedure proTrevcor_getConditionXYZ(var mat1,mat2: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat1));
  verifierObjet(typeUO(mat2));

  Trevcor(pu).getConditionXYZ(mat1,mat2);
end;

procedure proTrevcor_getCodes(var vec: Tvector;num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));

  Trevcor(pu).getCodes(vec,num);
end;

procedure proTrevcor_initLqrPstw(var source:Tvector;tau1,tau2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(source);

  Trevcor(pu).initLqrPstw(source,tau1,tau2);
end;

procedure proTrevcor_initLqrPsth(Lclasse:float;tau1,tau2:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  Trevcor(pu).initLqrPsth(Lclasse,tau1,tau2);
end;


procedure proTrevcor_calculateLqrPstw(var source:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(source);
  Trevcor(pu).calculateLqrPstw(source);
end;

procedure proTrevcor_getLqrPstw(var pstw:TvectorArray;z:integer;raw,Norm:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(pstw));


  Trevcor(pu).getLqrPstw(pstw,z,raw,Norm);
end;

procedure proTrevcor_getLqrResidual(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));

  Trevcor(pu).getLqrResidual(vec);
end;


procedure proTrevcor_SolveLqrPstw(var pu:typeUO);
begin
  verifierObjet(pu);
  Trevcor(pu).SolveLqrPstw;
end;

procedure proTrevcor_SVD(var mat:Tmat;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));
  Trevcor(pu).SVD(mat);
end;


procedure proTrevcor_FreeLqrPstw(var pu:typeUO);
begin
  verifierObjet(pu);
  Trevcor(pu).FreeLqrPstw;
end;


procedure proTrevcor_BuildSignal(var var1,var2:TvectorArray;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(var1));
  verifierObjet(typeUO(var2));
  verifierVecteur(vec);

  Trevcor(pu).BuildSignal(var1,var2,vec);
end;


procedure proTrevcor_BuildSignal1(var Vlist:TVlist;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(Vlist));
  verifierVecteur(vec);

  Trevcor(pu).BuildSignal1(Vlist,vec);
end;

procedure proTrevcor_BuildSignalSpk1(var Vlist:TVlist;var vec:Tvector;Nmax:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(Vlist));
  verifierVecteur(vec);

  Trevcor(pu).BuildSignalSpk1(Vlist,vec,Nmax);
end;


procedure proTrevcor_GetLQRline(seq: integer; tt: float; var vec: Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteurTemp(vec);

  Trevcor(pu).GetLqrLine(seq,tt,vec);
end;

procedure proTrevcor_BuildSimMask(var mat:Tmatrix;var Xpos,Ypos:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);

  Trevcor(pu).BuildRevMask(mat,Xpos,Ypos);
end;


procedure proBuildRepSim(var pstw1,pstw2:TvectorArray;var Mlist:TmatList;var dest:Tvector;interframe:float);
var
  duree:float;
  nbpt:integer;
  i,j,k:integer;
  p1,p2,Pdest:PtabSingle;
  i0,i1,nb:integer;
  temp:array of single;
  w:float;
begin
  IPPStest;

  verifierObjet(typeUO(pstw1));
  verifierObjet(typeUO(pstw2));
  verifierObjet(typeUO(Mlist));
  verifierVecteur(dest);

  nb:=pstw1.Iend-pstw1.invconvx(0)+1;

  setLength(temp,nb);


  duree:=interFrame*Mlist.count+pstw1.Xend;
  nbpt:=round(duree/pstw1.dxu);

  dest.initTemp1(0,nbpt-1,g_single);
  dest.dxu:=pstw1.Dxu;
  dest.X0u:=0;
  pdest:=dest.tb;



  for k:=1 to Mlist.count do
  begin
    i0:=dest.invconvx((k-1)*interFrame);
    with Mlist.mat[k] do
      for i:=Istart to Iend do
      for j:=Jstart to Jend do
      begin
        p1:=pstw1[i,j].tbSingle;
        p2:=pstw2[i,j].tbSingle;

        w:=Zvalue[i,j];

        if w>0 then
        begin
          move(p1^,temp[0],nb*sizeof(single));
          ippsMulC(w,Psingle(@temp[0]),nb);
          ippsAdd(Psingle(@temp[0]),Psingle(@pdest^[i0]),nb);
        end
        else
        if w<0 then
        begin
          move(p2^, temp[0],nb*sizeof(single));
          ippsMulC(w,Psingle(@temp[0]),nb);
          ippsAdd(Psingle(@temp[0]),Psingle(@pdest^[i0]),nb);
        end;
      end;
  end;

  IPPSend;
end;


procedure proTrevcor_initKlist(var pu:typeUO);
begin
  verifierObjet(pu);
  Trevcor(pu).initKlist;
end;

procedure proTrevcor_AddK1(x,y,z:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  Trevcor(pu).AddK1(x,y,z);
end;

procedure proTrevcor_AddK2(x1,y1,z1,x2,y2,z2,lag:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  Trevcor(pu).AddK2(x1,y1,z1,x2,y2,z2,lag);
end;


procedure proTrevcor_initLqrPstw1(var source:Tvector;tau1,tau2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(source);

  Trevcor(pu).initLqrPstw1(source,tau1,tau2);
end;

procedure proTrevcor_calculateLqrPstw1(var source:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(source);

  Trevcor(pu).calculateLqrPstw1(source);
end;

procedure proTrevcor_getLqrVector(num:integer;var vec:Tvector;raw,norm:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);

  Trevcor(pu).getLqrVector(num,vec,raw,norm);
end;

procedure proTrevcor_getLqrKList(var Vlist:TVlist;raw,norm:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierobjet(typeUO(Vlist));

  Trevcor(pu).getLqrKList(Vlist,raw,norm);
end;

procedure proTrevcor_setLqrLambda(w: float;var pu:typeUO);
begin
  verifierObjet(pu);

  Trevcor(pu).setLqrLambda(w);
end;

procedure proTrevcor_getMlist(var Mlist: TmatList;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(Mlist));

  with Trevcor(pu) do
    getMlist(Mlist);
end;

procedure proTrevcor_setMlist(var Mlist: TmatList;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(Mlist));
  
  with Trevcor(pu) do
    setMlist(Mlist);
end;


function fonctionTrevcor_matH(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Trevcor(pu).lqrP do
    result:=@matH;
end;

function fonctionTrevcor_matB(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Trevcor(pu).lqrP do
    result:=@pstw;
end;

function fonctionTrevcor_matX(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Trevcor(pu).lqrP do
    result:=@XX;
end;

procedure proTrevcor_GridToScreen(x1,y1:float;var x2,y2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Trevcor(pu) do
    calculeCentre2(x1,y1,x2,y2);
end;


Initialization
AffDebug('Initialization stmRev1',0);

registerObject(Trevcor,stim);

end.
