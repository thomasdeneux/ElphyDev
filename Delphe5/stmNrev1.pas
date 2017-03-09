unit stmNrev1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows,sysutils,forms,classes, graphics,
     util1,Dgraphic,Gdos,dtf0,tbe0,listG,

     Stmdef,stmObj,
     Dpalette,
     stmObv0,stmMvtX1,
     stmVec1,stmAve1,stmMat1,stmOdat2,stmPsth1,stmPstA1,stmAveA1,
     varconf1,syspal32,
     debug0,
     NcDef2,stmPg,
     stmMList,
     stmGrid1,
     D7random1;


type
  TseqElt = record
                X,Y,Z,FP: byte;
              end;

  TNrev=  class(TonOff)
              protected
                DTmesure:float;            {Duree de cycle mesurée en millisecondes }


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

                Sequence: Array Of Array of TseqElt;

                nX,nY:integer;             { nb div effectifs en tenant compte de
                                             expansion et scotome }
                XInf,XSup,YInf,YSup : integer;
                                           { coo du scotome }

                obvisA:array[1..2] of Tresizable;

                EvtTimes:array of integer;
                dxEvt:double;              { Param d'échelle pour les dates evt }

                NbBar:integer;
                grid:Tgrid;

                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;
                procedure setChildNames;override;

                procedure randSequence;virtual;

                procedure InitMvt; override;
                procedure initObvis;override;
                procedure calculeMvt; override;
                procedure doneMvt; override;
                procedure setVisiFlags(obOn:boolean);override;

                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;

                procedure afficheC;override;
                procedure afficheS;override;

                function getInfo:AnsiString;override;

                procedure setSeed(x:integer);virtual;
                function getSeed:integer;virtual;
                Property seed:integer read getSeed write setSeed;

                procedure installSequence(seed1,nbDivX1,nbDivY1,expansion1,scotome1, nbB:integer);
                
                function InstallTimes(vec:Tvector;dx:float;var stE:string): boolean;
                procedure DetectTimes(vec:Tvector;x1,x2,th,linhib:float;Fup:boolean);
                procedure InstallFP(vec:Tvector);

                procedure initPsth(var1,var2:TpsthArray;source:Tvector;x1,x2,deltaX:float);virtual;
                procedure calculatePsth(var1,var2:TpsthArray;source:Tvector);virtual;

                procedure initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);virtual;
                procedure calculatePstw(var1,var2:TaverageArray;source:Tvector);virtual;

                procedure BuildSignal(var1,var2:TvectorArray;vec:Tvector);
                procedure Display;override;
                function Plotable:boolean;override;

                procedure getMlist(Mlist: TmatList);
                procedure BuildRevMask(mat:Tmatrix;Xpos,Ypos:Tvector);
              end;



procedure proTNrev_create(var pu:typeUO);pascal;
procedure proTNrev_create_1(name:AnsiString;var pu:typeUO);pascal;

procedure proTNrev_setRF(num:integer;var pu:typeUO);pascal;

procedure proTNrev_divXcount(ww:integer;var pu:typeUO);pascal;
function fonctionTNrev_divXcount(var pu:typeUO):integer;pascal;

procedure proTNrev_divYcount(ww:integer;var pu:typeUO);pascal;
function fonctionTNrev_divYcount(var pu:typeUO):integer;pascal;

procedure proTNrev_Lum1(ww:float;var pu:typeUO);pascal;
function fonctionTNrev_Lum1(var pu:typeUO):float;pascal;

procedure proTNrev_Lum2(ww:float;var pu:typeUO);pascal;
function fonctionTNrev_Lum2(var pu:typeUO):float;pascal;

procedure proTNrev_expansion(ww:integer;var pu:typeUO);pascal;
function fonctionTNrev_expansion(var pu:typeUO):integer;pascal;

procedure proTNrev_scotome(ww:integer;var pu:typeUO);pascal;
function fonctionTNrev_scotome(var pu:typeUO):integer;pascal;

procedure proTNrev_Seed(ww:integer;var pu:typeUO);pascal;
function fonctionTNrev_Seed(var pu:typeUO):integer;pascal;

procedure proTNrev_AdjustObjectSize(ww:boolean;var pu:typeUO); pascal;
function fonctionTNrev_AdjustObjectSize(var pu:typeUO):boolean; pascal;

function fonctionTNrev_Xcount(var pu:typeUO):integer;pascal;
function fonctionTNrev_Ycount(var pu:typeUO):integer;pascal;

procedure proTNrev_updateSequence(var pu:typeUO);pascal;

procedure proTNrev_RFx(ww:float;var pu:typeUO);pascal;
function fonctionTNrev_RFx(var pu:typeUO):float;pascal;

procedure proTNrev_RFy(ww:float;var pu:typeUO);pascal;
function fonctionTNrev_RFy(var pu:typeUO):float;pascal;

procedure proTNrev_RFdx(ww:float;var pu:typeUO);pascal;
function fonctionTNrev_RFdx(var pu:typeUO):float;pascal;

procedure proTNrev_RFdy(ww:float;var pu:typeUO);pascal;
function fonctionTNrev_RFdy(var pu:typeUO):float;pascal;

procedure proTNrev_RFtheta(ww:float;var pu:typeUO);pascal;
function fonctionTNrev_RFtheta(var pu:typeUO):float;pascal;

procedure proTNrev_installStimSeq(seed,nbDivX,nbDivY,expansion,scotome, NbB:integer; var pu:typeUO);pascal;
function fonctionTNrev_installTimes(var vecEvt:Tvector;dx:float;var pu:typeUO): boolean;pascal;
function fonctionTNrev_installTimes_1(var vecEvt:Tvector;dx:float;NoError:boolean; var pu:typeUO): boolean;pascal;

procedure proTNrev_installFP(var vec:Tvector;var pu:typeUO);pascal;

function fonctionTNrev_PosCount(var pu:typeUO):longint;pascal;

function fonctionTNrev_Xpos(b,i:integer;var pu:typeUO):integer;pascal;
function fonctionTNrev_Ypos(b,i:integer;var pu:typeUO):integer;pascal;
function fonctionTNrev_Zpos(b,i:integer;var pu:typeUO):integer;pascal;
function fonctionTNrev_Tpos(b,i:integer;var pu:typeUO):integer;pascal;

procedure proTNrev_initPsth(var v1,v2:TpsthArray;var source:Tvector; x1,x2,deltaX:float;var pu:typeUO);pascal;
procedure proTNrev_calculatePsth(var v1,v2:TpsthArray;var source:Tvector; var pu:typeUO);pascal;

procedure proTNrev_initPstw(var v1,v2:TaverageArray;var source:Tvector; x1,x2:float;var pu:typeUO);pascal;
procedure proTNrev_calculatePstw(var v1,v2:TaverageArray;var source:Tvector; var pu:typeUO);pascal;

procedure proTNrev_DetectTimes(var vec:Tvector;x1,x2,th,linhib:float;Fup:boolean;var pu:typeUO);pascal;

procedure proTNrev_getMlist(var Mlist: TmatList;var pu:typeUO);pascal;

procedure proTNrev_BuildSignal(var var1,var2:TvectorArray;var vec:Tvector;var pu:typeUO);pascal;
procedure proTNrev_BuildSimMask(var mat:Tmatrix;var Xpos,Ypos:Tvector;var pu:typeUO);pascal;

procedure proTNrev_ObjCount(n:integer;var pu:typeUO);pascal;
function fonctionTNrev_ObjCount(var pu:typeUO):integer;pascal;


implementation



{*********************   Méthodes de TNrev  *************************}

constructor TNrev.create;
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

  NbBar:=5;
  grid:=Tgrid.create;
  grid.notpublished:=true;
  grid.Fchild:=true;

end;


destructor TNrev.destroy;
begin
  grid.Free;
  inherited destroy;

end;

class function TNrev.STMClassName:AnsiString;
begin
   result:='NRev';
end;

procedure TNrev.setChildNames;
begin
end;


procedure TNrev.RandSequence;
var
  seq0:TseqElt;
  i, j, k,t: integer;
  nbtot:integer;

function controle(i0,j0:integer):boolean;
var
  i:integer;
begin
  result:=false;
  for i:=0 to i0-1 do
    if (sequence[i,j0].x=sequence[i0,j0].X) and (sequence[i,j0].y=sequence[i0,j0].y) then exit;
  result:=true;
end;

begin
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);

  XInf := roundI(nX/2.0 - nbDivX*(Scotome/100)/2.0);
  XSup := roundI(nX/2.0 + nbDivX*(Scotome/100)/2.0) -1;
  YInf := roundI(nY/2.0 - nbDivY*(Scotome/100)/2.0);
  YSup := roundI(nY/2.0 + nbDivY*(Scotome/100)/2.0) -1;

  setLength(sequence,nbBar,nX*nY*2); {longueur max}

  nbtot:=0;
  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
  for k:=0 to 1 do
    if (Scotome = 0) or ((i<Xinf) or (i>Xsup)) and ((j<Yinf) or (j>Ysup)) then
    begin
      with sequence[0,nbtot] do
      begin
        x:=i;
        y:=j;
        z:=k;
        FP:=1;
      end;
      inc(nbtot);
    end;
  setLength(sequence,nbBar,nbtot); {longueur vraie}

  cycleCount:=nbtot;

  for i:=0 to nbBar-1 do
  for j:=0 to nbtot-1 do
    sequence[i,j]:=sequence[0,j];

  GsetRandSeed(seed0);
  for i:= 0 to NbBar-1 do
  for j:= 0 to nbTot-1 do
  begin
    k:=Grandom(nbtot);
    swapmem(sequence[i,j],sequence[i,k],sizeof(TseqElt));         { swap sequences i et k }
  end;

  for i:=1 to NbBar-1 do
  for j:=0 to nbtot-1 do
    while not controle(i,j) do
    begin
      k:=Grandom(nbtot);
      swapmem(sequence[i,j],sequence[i,k],sizeof(TseqElt));
      if not controle(i,j) or not controle(i,k) then swapmem(sequence[i,j],sequence[i,k],sizeof(TseqElt));
    end;

end;



procedure TNrev.InitMvt;
var
  i:integer;
  deg1:typeDegre;
begin
  index:=0;

  RandSequence;

  obvis.deg.theta:=RFdeg.theta;
  if AdjustObjectSize then
    begin
      obvis.deg.dx:=RFdeg.dx /nbDivX;
      obvis.deg.dy:=RFdeg.dy /nbDivY;
    end;

  obvis.deg.lum:=lum[1];

  obvisA[1]:=obvis;

  obvisA[2]:=Tresizable(obvis.clone(false));
  obvisA[2].ident:='Clone';
  obvisA[2].deg.lum:=lum[2];

  deg1:=RFdeg;
  deg1.dx:=deg1.dx*expansion/100;
  deg1.dy:=deg1.dy*expansion/100;
  grid.initGrille(deg1,nx,ny);

end;

procedure TNrev.initObvis;
begin
  obvisA[1].prepareS;
  obvisA[2].prepareS;
end;


procedure TNrev.calculeMvt;
var
  i,j:integer;
  tcycle:integer;
begin

  tCycle:=timeS mod dureeC;
  if (tCycle=0) and (timeS < cycleCount*dureeC) then inc(Index);
  if index>cycleCount then exit;


  for i:=0 to nx-1 do
  for j:=0 to ny-1 do
    grid.obvisA[i,j]:=nil;

  for i:=0 to nbBar-1 do
  with Sequence[i,Index-1] do
    if z=0
      then grid.obvisA[x,y]:=obvisA[1]
      else grid.obvisA[x,y]:=obvisA[2];
end;


procedure TNrev.doneMvt;
begin
  obvisA[2].free;
  obvis:=obvisA[1];
end;

procedure TNrev.setVisiFlags(obOn:boolean);
begin
  if assigned(grid) then
  begin
    grid.FlagonScreen:=affStim and ObON;
    grid.FlagonControl:=affControl and ObON;
  end;
end;

procedure TNrev.buildInfo(var conf:TblocConf;lecture,tout:boolean);
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
      setVarConf('NbBar',NbBar,sizeof(NbBar));
    end;

  end;

function TNrev.getInfo:AnsiString;
var
  i:integer;
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
          'AdjustObjectSize='+Bstr(AdjustObjectSize)+CRLF+
          'NbBar=     '+Istr(NbBar) ;

end;

procedure TNrev.CompleteLoadInfo;
begin
  CheckOldIdent;
  randSequence;
  majPos;
end;


procedure TNrev.afficheC;
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

procedure TNrev.afficheS;
begin
end;

procedure TNrev.setSeed(x:integer);
begin
  seed0:=x;
end;

function TNrev.getSeed:integer;
begin
  result:=seed0;
end;


{Deux procédures d'initialisation indispensables }

procedure TNrev.installSequence(seed1, nbdivX1, nbdivY1, expansion1, scotome1,NbB: integer);
begin
  seed:=seed1;
  nbDivX:=nbdivX1;
  nbDivY:=nbdivY1;
  expansion:=expansion1;
  scotome:=scotome1;
  nbBar:=nbB;

  randSequence;
end;

function TNrev.InstallTimes(vec:Tvector;dx:float;var stE:string): boolean;
var
  i:integer;
begin
  if (cycleCount=0)then
  begin
    stE:='TNrev: sequence not installed';
    result:=false;
    exit;
  end;

  dxEvt:=dx;
  setLength(EvtTimes,vec.ICount);
  for i:=vec.Istart to vec.Iend do
    EvtTimes[i-vec.Istart]:=roundL(vec.Yvalue[i]/dxEvt);

  result:= vec.Icount=cycleCount;

  if not result then stE:='TNrev: installTimes failed';

end;

procedure TNrev.DetectTimes(vec:Tvector;x1,x2,th,linhib:float;Fup:boolean);
var
  i,i1,i2:integer;
  w1,w:float;
  dlinhib:integer;
begin
  if (cycleCount=0)
      then sortieErreur('TNrev: sequence not installed');

  dxEvt:=vec.dxu;
  setLength(EvtTimes,0);

  i1:=vec.invConvX(x1);
  if i1<vec.Istart then i1:=vec.Istart;
  i2:=vec.invConvX(x2);
  if i2>vec.Iend then i2:=vec.Iend;

  i:=i1;
  w1:=vec.data.getE(i);
  dlinhib:=vec.invConvX(lInhib)-vec.invConvX(0);

  repeat
     inc(i);
     w:=vec.data.getE(i);
     if Fup and (w1<th) and (w>=th) then
       begin
         setLength(EvtTimes,length(EvtTimes)+1);
         EvtTimes[high(EvtTimes)]:=i;
         inc(i,dlinhib);
       end
     else
     if not Fup and (w1>=th) and (w<th) then
       begin
         setLength(EvtTimes,length(EvtTimes)+1);
         EvtTimes[high(EvtTimes)]:=i;
         inc(i,dlinhib);
       end;
     w1:=w;
  until i>=i2;

  if length(EvtTimes)<>cycleCount
      then sortieErreur('TNrev: DetectTimes failed');;

end;


procedure TNrev.InstallFP(vec:Tvector);
begin
end;



{ Calcul des PSTW }

procedure TNrev.initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);
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


procedure TNrev.calculatePstw(var1,var2:TaverageArray;source:Tvector);
var
  i,j:integer;
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
      for j:=0 to nbBar-1 do
      with sequence[j,i] do
      begin
        vv:=pstw[z+1].average(x+1,y+1);
        if assigned(vv) then
        begin
          if (fp>0) then vv.addEx(source,t)
        end
        else sortieErreur('TNrev.calculatePstw : invalid average object ');
      end;
    end;

end;

{ Calcul des Psths }

procedure TNrev.initPsth(var1, var2: TpsthArray; source: Tvector; x1,x2,deltaX: float);
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


procedure TNrev.calculatePsth(var1, var2: TpsthArray; source: Tvector);
var
  i,j:integer;
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
      for j:=0 to nbBar-1 do
      with sequence[j,i] do
      begin
        vv:=psth[z+1].psths(x+1,y+1);
        if assigned(vv) then
        begin
          if (FP>0) then vv.addEx(source,t);
        end
        else sortieErreur('TNrev.calculatePsth : invalid psth object ');
      end;
    end;

end;

procedure TNrev.BuildSignal(var1,var2:TvectorArray;vec:Tvector);
var
  i,j:integer;
  pstw:array[1..2] of TvectorArray;
  vv:Tvector;
  ttt,tmax:float;
  j0:integer;

begin
(*
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
  if numDT=numT then
  begin
    vv:=Pstw[z+1].vector(x+1,y+1);
    ttt:=evtTimes[i]*Dxevt;
    j0:=vec.invconvx(ttt);
    for j:=0 to vv.Iend do
    vec.Yvalue[j0+j]:=vec.Yvalue[j0+j]+vv.Yvalue[j];
  end;
  *)
end;


function TNrev.sequenceInstalled: boolean;
begin
  result:=(cycleCount>0) and (length(EvtTimes)=cycleCount) and (length(sequence[0])=cycleCount);
end;



procedure TNrev.Display;
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

function TNrev.Plotable:boolean;
begin
  result:=true;
end;


procedure TNrev.getMlist(Mlist: TmatList);
var
  mat:Tmatrix;
  i:integer;
begin
(*
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
  *)
end;


{ RevMask est une matrice ayant les dimensions de l'écran de stimulation

  On donne à chaque pixel de l'écran un numéro correspondant à la case de la grille
  de stimulation.
  Ce numéro est y+Ny*x+1
}

procedure TNrev.BuildRevMask(mat:Tmatrix;Xpos,Ypos:Tvector);
begin
end;



{************** Méthodes STM  de TNrev *****************************}

procedure proTNrev_create(var pu:typeUO);
begin
  createPgObject('',pu,TNrev);
end;

procedure proTNrev_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TNrev);
end;

procedure proTNrev_setRF(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(num,1,5);
  TNrev(pu).RFdeg:=RFsys[num].deg;
end;

function fonctionTNrev_Xcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TNrev(pu) do
    fonctionTNrev_Xcount:=roundI(nbDivX*Expansion/100.0);
end;

function fonctionTNrev_Ycount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TNrev(pu) do
    fonctionTNrev_Ycount:=roundI(nbDivY*Expansion/100.0);
end;

procedure proTNrev_divXcount(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,2000);
  TNrev(pu).nbdivX:=ww;
end;

function fonctionTNrev_divXcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTNrev_divXcount:=TNrev(pu).nbdivX;
end;

procedure proTNrev_divYcount(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,200);
  TNrev(pu).nbdivY:=ww;
end;

function fonctionTNrev_divYcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTNrev_divYcount:=TNrev(pu).nbdivY;
end;


procedure proTNrev_Lum1(ww:float;var pu:typeUO);
begin
verifierObjet(pu);
controleParametre(ww,0,10000);
TNrev(pu).lum[1]:=ww;
end;

function fonctionTNrev_lum1(var pu:typeUO):float;
begin
verifierObjet(pu);
result:=TNrev(pu).lum[1];
end;


procedure proTNrev_lum2(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,0,10000);
  TNrev(pu).lum[2]:=ww;
end;

function fonctionTNrev_lum2(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TNrev(pu).lum[2];
end;

procedure proTNrev_expansion(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,1000);
  TNrev(pu).expansion:=ww;
end;

function fonctionTNrev_expansion(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTNrev_expansion:=TNrev(pu).expansion;
end;

procedure proTNrev_scotome(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,0,32000);
  TNrev(pu).scotome:=ww;
end;

function fonctionTNrev_scotome(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTNrev_scotome:=TNrev(pu).scotome;
end;

procedure proTNrev_Seed(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TNrev(pu).Seed:=ww;
end;

function fonctionTNrev_Seed(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTNrev_Seed:=TNrev(pu).seed;
end;

procedure proTNrev_AdjustObjectSize(ww:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TNrev(pu).AdjustObjectSize:=ww;
end;

function fonctionTNrev_AdjustObjectSize(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  fonctionTNrev_AdjustObjectSize:=TNrev(pu).AdjustObjectSize;
end;

procedure proTNrev_updateSequence(var pu:typeUO);
begin
  verifierObjet(pu);
  with TNrev(pu) do randSequence;
end;

procedure proTNrev_RFx(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TNrev(pu) do
  if RFdeg.x<>ww then RFdeg.x:=ww;
end;

function fonctionTNrev_RFx(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTNrev_RFx:=TNrev(pu).RFdeg.x;
end;

procedure proTNrev_RFy(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TNrev(pu) do
  if RFdeg.y<>ww then RFdeg.y:=ww;
end;

function fonctionTNrev_RFy(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTNrev_RFy:=TNrev(pu).RFdeg.y;
end;

procedure proTNrev_RFdx(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,32000);
  with TNrev(pu) do
  if RFdeg.dx<>ww then RFdeg.dx:=ww;
end;

function fonctionTNrev_RFdx(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTNrev_RFdx:=TNrev(pu).RFdeg.dx;
end;

procedure proTNrev_RFdy(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParametre(ww,1,32000);
  with TNrev(pu) do
  if RFdeg.dy<>ww then RFdeg.dy:=ww;
end;

function fonctionTNrev_RFdy(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTNrev_RFdy:=TNrev(pu).RFdeg.dy;
end;

procedure proTNrev_RFtheta(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TNrev(pu) do
  if RFdeg.theta<>ww then RFdeg.theta:=ww;
end;

function fonctionTNrev_RFtheta(var pu:typeUO):float;
begin
  verifierObjet(pu);
  fonctionTNrev_RFtheta:=TNrev(pu).RFdeg.theta;
end;


procedure proTNrev_installStimSeq(seed,nbDivX,nbDivY,expansion,scotome,NbB:integer;
                                            var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  TNrev(pu).installSequence(seed,nbDivX,nbDivY,expansion,scotome, NbB);
end;



function fonctionTNrev_installTimes(var vecEvt:Tvector;dx:float;var pu:typeUO): boolean;
begin
  result:= fonctionTNrev_installTimes_1(vecEvt , dx, false,pu);
end;

function fonctionTNrev_installTimes_1(var vecEvt:Tvector;dx:float;NoError:boolean; var pu:typeUO): boolean;
var
  stE:string;
begin
  verifierObjet(typeUO(pu));
  verifierVecteur(vecEvt);
  with TNrev(pu) do
    result:= InstallTimes(vecEvt,dx,stE);

  if not result and not NoError then sortieErreur(stE);
end;

procedure proTNrev_installFP(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TNrev(pu) do
  begin
    if (CycleCount=0) or (vec.Icount<CycleCount)
      then sortieErreur('TNrev: stim. sequence not installed');
    InstallFP(vec);
  end;
end;




function fonctionTNrev_PosCount(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  with TNrev(pu) do result:=CycleCount;
end;


function fonctionTNrev_Xpos(b,i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TNrev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount) or (b<1) or (b>nbBar)
      then sortieErreur('TNrev.Xpos :  index out of range');
    result:=sequence[b-1,i-1].x+1;
  end;
end;

function fonctionTNrev_Ypos(b,i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TNrev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount) or (b<1) or (b>nbBar)
      then sortieErreur('TNrev.Ypos :  index out of range');
    result:=sequence[b-1,i-1].y+1;
  end;
end;

function fonctionTNrev_Zpos(b,i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TNrev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount) or (b<1) or (b>nbBar)
      then sortieErreur('TNrev.Zpos : sequence index out of range');
    result:=sequence[b-1,i-1].z+1;
  end;
end;

function fonctionTNrev_Tpos(b,i:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TNrev(pu) do
  begin
    if not assigned(sequence) or (i<1) or (i>CycleCount) or (b<1) or (b>nbBar)
      then sortieErreur('TNrev.Tpos :  index out of range');
    result:=sequence[b-1,i-1].FP+1;
  end;
end;


procedure proTNrev_initPsth(var v1,v2:TpsthArray;var source:Tvector;
                                      x1,x2,deltaX:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));

  verifierVecteur(source);

  if deltaX<=0 then sortieErreur('TNrev.initPsth : invalid binWidth');
  if x2<x1 then sortieErreur('TNrev.initPsth : invalid psth bounds');


  with TNrev(pu) do initPsth(v1,v2,source,x1,x2,deltaX);
end;

procedure proTNrev_calculatePsth(var v1,v2:TpsthArray;var source:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  with TNrev(pu) do calculatePsth(v1,v2,source);
end;

procedure proTNrev_BuildSignal(var var1,var2:TvectorArray;var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(var1));
  verifierObjet(typeUO(var2));
  verifierVecteur(vec);
  TNrev(pu).BuildSignal(var1,var2,vec);
end;

procedure proTNrev_initPstw(var v1,v2:TaverageArray;var source:Tvector;x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));

  verifierVecteur(source);

  with TNrev(pu) do initPstw(v1,v2,source,x1,x2);
end;

procedure proTNrev_calculatePstw(var v1,v2:TaverageArray;var source:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  with TNrev(pu) do calculatePstw(v1,v2, source);
end;


procedure proTNrev_DetectTimes(var vec:Tvector;x1,x2,th,linhib:float;Fup:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  with TNrev(pu) do
  begin
    DetectTimes(vec,x1,x2,th,linhib,Fup);
  end;
end;

procedure proTNrev_getMlist(var Mlist: TmatList;var pu:typeUO);
begin
  verifierObjet(pu);

  with TNrev(pu) do
    getMlist(Mlist);
end;

procedure proTNrev_BuildSimMask(var mat:Tmatrix;var Xpos,Ypos:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);

  TNrev(pu).BuildRevMask(mat,Xpos,Ypos);
end;

procedure proTNrev_ObjCount(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (n<1) then sortieErreur('TNrev.ObjCount must be positive');

  TNrev(pu).nbBar:=n;
end;

function fonctionTNrev_ObjCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TNrev(pu).nbBar;
end;



Initialization
AffDebug('Initialization stmNrev1',0);

registerObject(TNrev,stim);

end.
