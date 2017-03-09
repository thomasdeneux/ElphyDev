unit stmDN2;

interface

uses windows,classes,math,
     util1,Gdos,dtf0,Dgraphic,Dpalette,
     stmDef,stmObj,stmobv0,stmMvtX1,varconf1,Ncdef2,
     defForm,selRF1,editcont,
     getMseq1,syspal32,
     stmgrid3,
     stmvec1,stmMat1,stmOdat2,stmAve1,stmAveA1,
     stmPg,stmError,
     Rarray1,listG,
     matrix0,chrono0,
     Gnoise1;



type

  TdenseNoise=class(Trevcor)

              private
                noise:TgridNoise;

                ker1:array of array of array of single;
                ker2:array of array of array of array of array of array of single;

                tau1K1,tau2K1,NtauK1:integer;
                tau1K2,tau2K2,NtauK2:integer;


                pseq:integer;

                count1,count2:integer;

                obvis2:Tresizable;
                grid:TgridEx;

                dataK1,dataK2:typeDataGetE;
                VK1,VK2:Tvector;

                sourcePstw:Tvector;
                pstw:array[1..2] of TaverageArray;
                EvtTimes:array of integer;
                dxEvt:double;      { Param d'échelle pour les dates evt }

                function getKernel1(x,y,tau:integer):float;
                procedure setKernel1(x,y,tau:integer;w:float);
                function getKernel2(x1,y1,t1,x2,y2,t2:integer):float;
                procedure setKernel2(x1,y1,t1,x2,y2,t2:integer;w:float);

                function getKer1L(i:integer):float;
                function getKer2L(i:integer):float;

                procedure CalculK1(VData:Tvector;t1,t2:integer;Fclear:boolean);
                procedure CalculK2(VData:Tvector;t11,t22:integer;Fclear:boolean);




                function Phi1(x1,y1,t1,x2,y2,t2:integer):float;
                function InvPhi1(x1,y1,t1,x2,y2,t2:integer):float;

                procedure CorrectionK1;

                function Xker1(tab:PtabSingle;Nb,x,y,t:integer):float;
                function Xker2(tab:PtabSingle;Nb,x1,y1,t1,x2,y2,t2:integer):float;

                procedure setSeed(x:integer);override;

                function getState(x,y,t:integer):integer;
              public
                nbPstW:integer;
                x1pstW,x2PstW:float;


                constructor create;override;
                destructor destroy;override;
                class function STMClassName:string;override;

                procedure reafficheObjets(obOn:boolean);override;

                procedure InitMvt; override;
                procedure initObvis;override;
                procedure calculeMvt; override;
                procedure doneMvt; override;

                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;

                function dialogForm:TclassGenForm;override;
                procedure installDialog(var form:Tgenform;var newF:boolean);
                            override;


                function Von(x,y:integer):Tresizable;
                function Gstate(x,y,t:integer):integer;
                procedure initParams;

                procedure FirstOrder(var mat:Tmatrix;tau:integer);
                procedure SecondOrder(var mat:Tmatrix;x1,y1,tau1,tau2:integer);
                procedure SecondOrder1(var mat:Tmatrix;tau1,dx,dy,dt:integer);

                property Kernel1[x,y,tau:integer]:float read getKernel1
                                                        write setKernel1;
                property Kernel2[x1,y1,tau1,x2,y2,tau2:integer]:float read getKernel2
                                                                      write setKernel2;


                procedure Simulate(var RA:TrealArray;var vec:Tvector;
                                    var Ferror:boolean);

                procedure BuildK1list(var RA:TrealArray;seuil1,seuil2:float);
                procedure BuildK2list(var RA:TrealArray;seuil1,seuil2:float);

                function getXker1(var Vdata:Tvector;x,y,tau:integer):float;
                function getXker2(var Vdata:Tvector;x1,y1,tau1,x2,y2,tau2:integer):float;

                procedure setChildNames;override;

                procedure initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);
                procedure calculatePstw;

                procedure processMessage(id:integer;source:typeUO;p:pointer);override;
                procedure InstallTimes(vec:Tvector;dx:float);
              end;


procedure proTdenseNoise_create(name:String;var pu:typeUO);pascal;

function fonctionTdenseNoise_length(var pu:typeUO):integer;pascal;

procedure proTdenseNoise_Nvalue(n,value:integer;var pu:typeUO);pascal;
function fonctionTdenseNoise_Nvalue(n:integer;var pu:typeUO):integer;pascal;

procedure proTdenseNoise_BuildK1(var Vdata:Tvector;t1,t2:integer;Fclear:boolean;var pu:typeUO);pascal;
procedure proTdenseNoise_BuildK2(var Vdata:Tvector;t1,t2:integer;Fclear:boolean;var pu:typeUO);pascal;

procedure proTdenseNoise_FirstOrder(var mat:Tmatrix;tau:integer;
                                    var pu:typeUO);pascal;
procedure proTdenseNoise_SecondOrder(var mat:Tmatrix;x1,y1,tau1,tau2:integer;
                                    var pu:typeUO);pascal;
procedure proTdenseNoise_SecondOrder1(var mat:Tmatrix;tau1,dx,dy,dt:integer;
                                    var pu:typeUO);pascal;


function fonctionTdenseNoise_Kernel1(x,y,t:integer;var pu:typeUO):float;pascal;
function fonctionTdenseNoise_Kernel2(x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):float;pascal;

function fonctionTdenseNoise_Ker1(var Vdata:Tvector;x,y,t:integer;var pu:typeUO):float;pascal;
function fonctionTdenseNoise_Ker2(var Vdata:Tvector;x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):float;pascal;

procedure proTdenseNoise_Simulate(var RA:TrealArray;
                                  var vec:Tvector;
                                  var pu:typeUO);pascal;

function fonctionTdenseNoise_VK1(var pu:typeUO):Tvector;pascal;
function fonctionTdenseNoise_VK2(var pu:typeUO):Tvector;pascal;

procedure proTdenseNoise_BuildK1list(var RA:TrealArray;
                                    seuil1,seuil2:float;
                                    var pu:typeUO);pascal;
procedure proTdenseNoise_BuildK2list(var RA:TrealArray;
                                    seuil1,seuil2:float;
                                    var pu:typeUO);pascal;

procedure proTdenseNoise_K1Correction(var pu:typeUO);pascal;
Function FonctionTdenseNoise_Phi1(x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):float;pascal;
Function FonctionTdenseNoise_InvPhi1(x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):float;pascal;

function fonctionTdenseNoise_Gstate(x,y,t:integer;var pu:typeUO):integer;pascal;

procedure proTdenseNoise_installTimes(var vecEvt:Tvector;dx:float;
                                             var pu:typeUO);pascal;

procedure proTdenseNoise_calculatePstw(var pu:typeUO);pascal;
procedure proTdenseNoise_initPstw(var v1,v2:TaverageArray;var source:Tvector;
                                      x1,x2:float;var pu:typeUO);pascal;

implementation


function DeuxPuissance(a:integer) : integer;
begin
  result:=1 shl a;
end;


{*********************   Méthodes de TdenseNoise  *************************}

constructor TdenseNoise.create;
var
  i,j:integer;
begin
  inherited create;

  timeMan.dtOn:=1;

  nbDivX:=8;
  nbDivY:=8;
  expansion:=100;
  dureeC:=10;
  if assigned(rfSys[1])
    then RFDeg:=rfSys[1].deg
    else RFdeg:=degNul;

  grid:=TgridEx.create;
  grid.notpublished:=true;
  grid.Fchild:=true;

  timeMan.nbCycle:=1000;
  noise:=TBBnoise.create(1,1,seed);

  childList:=TList.create;


  dataK1.init(getKer1L,0,1);

  VK1:=Tvector.create;
  AddTochildList(VK1);
  with VK1 do
  begin
    Fchild:=true;
    initdat1(@dataK1,g_single);
  end;

  dataK2.init(getKer2L,0,1);

  VK2:=Tvector.create;
  AddTochildList(VK2);
  with VK2 do
  begin
    Fchild:=true;
    initdat1(@dataK2,g_single);
  end;

end;


destructor TdenseNoise.destroy;
var
  i:integer;
begin

  grid.free;

  VK1.free;
  VK2.free;

  dataK1.done;
  dataK2.done;

  derefObjet(typeUO(pstw[1]));
  derefObjet(typeUO(pstw[2]));
  derefObjet(typeUO(sourcePstw));

  inherited destroy;
end;

procedure TdenseNoise.setChildNames;
begin
  with VK1 do
  begin
    ident:=self.ident+'.VK1';

  end;
  with VK2 do
  begin
    ident:=self.ident+'.VK2';

  end;
end;


class function TdenseNoise.STMClassName:string;
  begin
    STMClassName:='DenseNoise';
  end;

procedure TdenseNoise.initParams;
var
  i,j,dum:integer;
begin
  index:=-1;
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);

  noise.modify(nx,ny,seed);
end;


procedure TdenseNoise.InitMvt;
  var
    i,j:integer;
    deg1:typeDegre;
  begin
    initParams;

    deg1:=RFdeg;
    deg1.dx:=deg1.dx*expansion/100;
    deg1.dy:=deg1.dy*expansion/100;

    grid.initGrille(deg1,nx,ny);

    obvis.deg.theta:=RFdeg.theta;

    if AdjustObjectSize then
      begin
        obvis.deg.dx:=RFdeg.dx /nbDivX;
        obvis.deg.dy:=RFdeg.dy /nbDivY;
      end;

    obvis.onScreen:=false;
    obvis.onControl:=false;

    obvis.deg.lum:=lum[1];


    with TimeMan do tend:=torg+dureeC*nbCycle;

    obvis2:=Tresizable(obvis.clone(false));
    obvis2.deg.lum:=lum[2];

    {Construire la grille d'arrière plan avec obvis2 }
    for i:=0 to nx-1 do
    for j:=0 to ny-1 do
      grid.obvisA[i,j]:=obvis2;
    grid.fillBackBM;
    for i:=0 to nx-1 do
    for j:=0 to ny-1 do
      grid.obvisA[i,j]:=nil;

  end;


procedure TdenseNoise.initObvis;
begin
  obvis.prepareS;
  obvis2.prepareS;
end;

function TdenseNoise.Von(x,y:integer):Tresizable;
begin
  if noise.f(x,y,index)=-1
    then result:=obvis
    else result:=obvis2;
end;

function TdenseNoise.Gstate(x,y,t:integer):integer;
begin
  result:=noise.f(x,y,t);
end;

procedure TdenseNoise.calculeMvt;
var
  i,j:integer;
begin
  if (timeS mod dureeC=0)  then
  begin
    inc(Index);
    grid.FrefreshHardBM:=true;
  end
  else grid.FrefreshHardBM:=false;

  for i:=0 to nx-1 do
    for j:=0 to ny-1 do
        {grid.obvisA[i,j]:=Von(i,j);}
      if Von(i,j)=obvis
        then grid.obvisA[i,j]:=obvis
        else grid.obvisA[i,j]:=nil;
end;

procedure TdenseNoise.doneMvt;
var
  i,j:integer;
begin
  obvis2.free;

  for i:=0 to nx-1 do
    for j:=0 to ny-1 do
        grid.obvisA[i,j]:=nil;
end;

procedure TdenseNoise.reafficheObjets(obOn:boolean);
begin
  grid.FonScreen:=affStim and ObON;
  grid.FonControl:=affControl and ObON;
end;

procedure TdenseNoise.buildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin
      if tout then setvarConf('OBVIS',longint(obvis),sizeof(longint));
    end;
  end;

procedure TdenseNoise.CompleteLoadInfo;
  begin
    majPos;
  end;

function TdenseNoise.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetMseq;;
end;


procedure TdenseNoise.installDialog(var form:Tgenform;var newF:boolean);
begin
  installForm(form,newF);

  with TgetMseq(form) do
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

    cbDivX.setString('2|4|8|16');
    cbDivX.setNumVar(nbDivX,T_longint);

    cbDivY.setString('2|4|8|16');
    cbDivY.setNumVar(nbDivY,T_longint);

    enLum1.setVar(lum[1],T_single);
    enLum1.setMinMax(0,10000);

    enLum2.setVar(lum[2],T_single);
    enLum2.setMinMax(0,10000);

    cbExpansion.setString('25|50|100|200|400');
    cbExpansion.setNumVar(Expansion,T_longint);

    selectRFD:=SelectRF;

    CBadjust.setvar(adjustObjectSize);

    onControlD:=DisplayOnControl;   {Ces procédures doivent être mises en place}
    onScreenD:=DisplayOnScreen;     {AVANT de modifier checked }

    CbOnControl.checked:=onControl;
    CbOnScreen.checked:=onScreen;

    initCBvisual(self,typeUO(obvis));
    updateAllCtrl(form);
  end;

end;


function TdenseNoise.getKernel1(x,y,tau:integer):float;
begin
  if (x>=0) and (x<nx) and (y>=0) and (y<ny) and (tau>=tau1K1) and (tau<=tau2K1)
    then result:=ker1[x,y,tau-tau1K1]
    else result:=0;
end;

procedure TdenseNoise.setKernel1(x,y,tau:integer;w:float);
begin
  if (x>=0) and (x<nx) and (y>=0) and (y<ny) and (tau>=tau1K1) and (tau<=tau2K1)
    then ker1[x,y,tau-tau1K1]:=w;
end;




function TdenseNoise.getKer1L(i:integer):float;
var
  x,y,tau:integer;
begin
  if ntauK1>0 then
  begin
    tau:=i mod ntauK1;
    i:=i div ntauK1;
    y:= i mod ny;
    x:=i div ny;
    result:=ker1[x,y,tau];
  end
  else result:=0;
end;

function TdenseNoise.getKer2L(i:integer):float;
var
  x1,y1,tau1,x2,y2,tau2:integer;
begin
  if ntauK2>0 then
  begin
    tau2:=i mod ntauK2;
    i:=i div ntauK2;

    y2:= i mod ny;
    i:=i div ny;

    x2:= i mod nx;
    i:=i div nx;

    tau1:=i mod ntauK2;
    i:=i div ntauK2;

    y1:= i mod ny;
    x1:=i div ny;

    result:=ker2[x1,y1,tau1,x2,y2,tau2];
  end
  else result:=0;
end;


procedure TdenseNoise.calculK1(VData:Tvector;t1,t2:integer;Fclear:boolean);
var
  i,x,y,t:integer;
  k1:integer;

  tab:array of single;
  kw:float;
  nbtot:integer;
begin
  initParams;

  tau1K1:=t1;
  tau2K1:=t2;
  NtauK1:=t2-t1+1;

  if Fclear
    then setLength(ker1,nx,ny,ntauK1);

  setLength(tab,Vdata.Icount);

  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  if Fclear
    then count1:=1
    else inc(count1);

  nbTot:=Vdata.Icount{-nTauK1};

  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  for t:=0 to nTauK1-1 do
    begin
      kw:=0;
      for i:={ntauK1}0 to Vdata.Icount-1 do
        if noise.f(x,y,i-tau1K1-t)=1
          then kw:=kw+tab[i]
          else kw:=kw-tab[i];

      if Fclear
        then ker1[x,y,t]:=kw/nbTot
        else ker1[x,y,t]:=(ker1[x,y,t]*(count1-1)+kw/nbTot)/count1;
    end;

  dataK1.init(getKer1L,0,nx*ny*ntauK1-1);
  VK1.initdat1(@dataK1,g_single);
end;

(*
procedure TdenseNoise.calculK1(VData:Tvector;t1,t2:integer;Fclear:boolean);
var
  i,x,y,t:integer;
  k1:integer;

  tab:array of single;
  kw:float;
  nbtot:integer;

function f(x,y,t:integer):single;
var
  i,j:integer;
begin

  result:=0;
  for i:=x-2 to x+2 do
  for j:=y-2 to y+2 do
  result:=result+BB[(t+(i+nx*j)*pseq -tau1K1+lgBB) mod lgBB];

  {result:=BB[(t+(x+nx*y)*pseq -tau1K1+lgBB) mod lgBB];}
end;

begin
  initParams;

  tau1K1:=t1;
  tau2K1:=t2;
  NtauK1:=t2-t1+1;

  if Fclear
    then setLength(ker1,nx,ny,ntauK1);

  setLength(tab,Vdata.Icount);

  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  if Fclear
    then count1:=1
    else inc(count1);

  nbTot:=Vdata.Icount{-nTauK1};

  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  for t:=0 to nTauK1-1 do
    begin
      kw:=0;

      for i:={ntauK1}0 to Vdata.Icount-1 do
        kw:=kw+f(x,y,i-t)*tab[i];

      if Fclear
        then ker1[x,y,t]:=kw/nbTot
        else ker1[x,y,t]:=(ker1[x,y,t]*(count1-1)+kw/nbTot)/count1;
    end;

  dataK1.init(getKer1L,0,nx*ny*ntauK1-1);
  VK1.initdat1(@dataK1,g_single);
end;
*)

procedure TdenseNoise.calculK2(VData:Tvector;t11,t22:integer;Fclear:boolean);
var
  i:integer;
  p1,p2:integer;

  x1,y1,t1,x2,y2,t2:integer;
  w1,w2:integer;

  tab:array of single;
  kw1:float;

  nbtot:integer;
  cond:boolean;
  q1,q2:integer;
  Ndata:integer;
begin
  {initChrono;}
  initParams;

  tau1K2:=t11;
  tau2K2:=t22;
  NtauK2:=t22-t11+1;
  nbTot:=CycleCount-ntauK2;

  if Fclear
    then count2:=1
    else inc(count2);

  if Fclear then
    begin
      setLength(ker2,nx,ny,ntauK2,nx,ny,ntauK2);

      for x1:=0 to nx-1 do
      for y1:=0 to ny-1 do
      for t1:=0 to ntauK2-1 do
      for x2:=0 to nx-1 do
      for y2:=0 to ny-1 do
      for t2:=0 to ntauK2-1 do
        ker2[x1,y1,t1,x2,y2,t2]:=0;
    end;

  setLength(tab,Vdata.Icount);
  for i:=0 to Vdata.Icount-1 do
    tab[i]:=Vdata.Yvalue[i+Vdata.Istart];
  Ndata:=Vdata.Icount;

  for x1:=0 to nx-1 do
  for y1:=0 to ny-1 do
  for t1:=0 to ntauK2-1 do
  BEGIN
    for x2:=0 to nx-1 do
    for y2:=0 to ny-1 do
    for t2:=0 to ntauK2-1 do
      begin
        for i:=ntauK2 to Ndata-1 do
        begin
          if noise.f(x1,y1,t1+tau1K1+i)=noise.f(x2,y2,t2+tau1K1+i)
            then kw1:=kw1+tab[i]
            else kw1:=kw1-tab[i];

          if (x1<>x2) or (y1<>y2) or (t1<>t2) then
          begin
            if Fclear then
              begin
                ker2[x1,y1,t1,x2,y2,t2]:=kw1/({2*}nbTot);
                ker2[x2,y2,t2,x1,y1,t1]:=kw1/({2*}nbTot);
              end
            else
              begin
                ker2[x1,y1,t1,x2,y2,t2]:=( ker2[x1,y1,t1,x2,y2,t2]*(count2-1)+kw1/({2*}nbtot) )/count2;
                ker2[x2,y2,t2,x1,y1,t1]:=ker2[x1,y1,t1,x2,y2,t2];
              end
          end
          else ker2[x1,y1,t1,x2,y2,t2]:=0;
        end;
      end;
    if testEscape then
    begin
      dataK2.init(getKer2L,0,sqr(nx*ny*ntauK2)-1);
      VK2.initdat1(@dataK2,g_single);
      exit;
    end;
    {statusLineTxt(Istr(x1)+' '+Istr(y1)+' '+Istr(t1));}
  END;

  dataK2.init(getKer2L,0,sqr(nx*ny*ntauK2)-1);
  VK2.initdat1(@dataK2,g_single);

  {messageCentral(Chrono);}
end;





function TdenseNoise.Xker1(tab:PtabSingle;Nb,x,y,t:integer):float;
var
  i:integer;
  kw:float;
  tmin,tmax:integer;
begin
  kw:=0;

  tmin:=max(0,t);
  tmax:=min(Nb-1,Nb-1+t);

  for i:=tmin to tmax do
    if noise.f(x,y,t+tau1K1+i)=1
      then kw:=kw+tab[i]
      else kw:=kw-tab[i];
  result:=kw/(tmax-tmin+1);
end;

function TdenseNoise.Xker2(tab:PtabSingle;Nb,x1,y1,t1,x2,y2,t2:integer):float;
var
  i:integer;
  p1,p2:integer;
  w1,w2:integer;
  kw1:float;
  tmin,tmax:integer;
begin
  (*
  p1:=(x1+nx*y1)*pseq -t1 -tau1K2 +lgBB;
  p2:=(x2+nx*y2)*pseq -t2 -tau1K2 +lgBB;

  tmin:=max(0,t1);
  tmin:=max(tmin,t2);
  tmax:=min(Nb-1,Nb-1+t1);
  tmax:=min(tmax,Nb-1+t2);

  kw1:=0;
  for i:=tmin to tmax do
    begin
      w1:=(i+p1) mod lgBB;
      w2:=(i+p2) mod lgBB;
      if (BB[w1]=BB[w2])
        then kw1:=kw1+tab[i]
        else kw1:=kw1-tab[i];
    end;

  if (x1<>x2) or (y1<>y2) or (t1<>t2)
    then result:=kw1/(tmax-tmin+1)
    else result:=0;
  *)
end;

function TdenseNoise.getXker1(var Vdata:Tvector;x,y,tau:integer):float;
var
  i,j:integer;
  tab:array of single;
begin
  initParams;

  setLength(tab,Vdata.Icount);
  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  result:= Xker1(@tab[0],length(tab),i,j,tau);
end;

function TdenseNoise.getXker2(var Vdata:Tvector;x1,y1,tau1,x2,y2,tau2:integer):float;
var
  i:integer;
  tab:array of single;
begin
  initParams;

  setLength(tab,Vdata.Icount);
  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  result:= Xker2(@tab[0],length(tab),x1,y1,tau1,x2,y2,tau2);
end;



procedure TdenseNoise.FirstOrder(var mat:Tmatrix;tau:integer);
var
  i,j:integer;
begin
  initParams;
  mat.modify(mat.tpNum,1,1,nx,ny);

  for i:=0 to nX-1 do
  for j:=0 to nY-1 do
    mat.Zvalue[1+i,1+j]:= Kernel1[i,j,tau];
end;

procedure TdenseNoise.SecondOrder(var mat:Tmatrix;x1,y1,tau1,tau2:integer);
var
  i,j:integer;
begin
  initParams;
  mat.modify(mat.tpNum,1,1,nx,ny);

  for i:=0 to nX-1 do
  for j:=0 to nY-1 do
    mat.Zvalue[1+i,1+j]:= Kernel2[x1,y1,tau1,i,j,tau2];

end;


procedure TdenseNoise.SecondOrder1(var mat:Tmatrix;tau1,dx,dy,dt:integer);
var
  i,j:integer;
begin
  initParams;
  mat.modify(mat.tpNum,1,1,nx,ny);

  for i:=max(0,-dx) to min(nX-1,nX-dx-1) do
  for j:=max(0,-dy) to min(nY-1,nY-dy-1) do
    mat.Zvalue[1+i,1+j]:= kernel2[i,j,tau1,i+dx,j+dx,tau1+dt];
end;


(* Id avec calcul immédiat
procedure TdenseNoise.FirstOrder(var Vdata:Tvector;var mat:Tmatrix;tau:integer);
var
  i,j:integer;
  tab:array of single;
begin
  initParams;
  mat.modify(1,1,nx,ny);

  setLength(tab,Vdata.Icount);
  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  for i:=0 to nX-1 do
  for j:=0 to nY-1 do
    mat.Zvalue[1+i,1+j]:= Xker1(@tab[0],length(tab),i,j,tau);
end;         o



procedure TdenseNoise.SecondOrder(var Vdata:Tvector;var mat:Tmatrix;x1,y1,tau1,tau2:integer);
var
  i,j:integer;
  tab:array of single;
begin
  initParams;
  mat.modify(1,1,nx,ny);

  setLength(tab,Vdata.Icount);
  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  for i:=0 to nX-1 do
  for j:=0 to nY-1 do
    mat.Zvalue[1+i,1+j]:= XKer2(@tab[0],length(tab),x1,y1,tau1,i,j,tau2);
end;

procedure TdenseNoise.SecondOrder1(var Vdata:Tvector;var mat:Tmatrix;tau1,dx,dy,dt:integer);
var
  i,j:integer;
  tab:array of single;
begin
  initParams;
  mat.modify(1,1,nx,ny);

  setLength(tab,Vdata.Icount);
  for i:=0 to Vdata.Icount-1 do tab[i]:=Vdata.Yvalue[i+Vdata.Istart];

  for i:=max(0,-dx) to min(nX-1,nX-dx-1) do
  for j:=max(0,-dy) to min(nY-1,nY-dy-1) do
    mat.Zvalue[1+i,1+j]:= Xker2(@tab[0],length(tab),i,j,tau1,i+dx,j+dx,tau1+dt);

end;
*)


function TdenseNoise.getKernel2(x1,y1,t1,x2,y2,t2:integer):float;
begin
  if (x1>=0) and (x1<nx) and (y1>=0) and (y1<ny) and (t1>=tau1K2) and (t1<=tau2K2)
     and
     (x2>=0) and (x2<nx) and (y2>=0) and (y2<ny) and (t2>=tau1K2) and (t2<=tau2K2)
    then result:=ker2[x1,y1,t1-tau1K2,x2,y2,t2-tau1K2]
    else result:=0;

end;

procedure TdenseNoise.setKernel2(x1,y1,t1,x2,y2,t2:integer;w:float);
begin
  if (x1>=0) and (x1<nx) and (y1>=0) and (y1<ny) and (t1>=tau1K2) and (t1<=tau2K2)
     and
     (x2>=0) and (x2<nx) and (y2>=0) and (y2<ny) and (t2>=tau1K2) and (t2<=tau2K2)
    then ker2[x1,y1,t1-tau1K2,x2,y2,t2-tau1K2]:=w;

end;

type
  TKrecord=record
             bloc,decal:integer;
             value:single;
           end;
  PKrecord=^TKrecord;

  TKrecord2=record
              bloc1,decal1,bloc2,decal2:integer;
              value:single;
              First:boolean;
            end;
  PKrecord2=^TKrecord2;





procedure TdenseNoise.Simulate(var RA:TrealArray;var vec:Tvector;
                               var Ferror:boolean);
var
  i,t:integer;
  x1,y1,tau1,x2,y2,tau2:integer;
  w:TKrecord2;

  data:PdataB;
  Klist:TlistG;

begin
  initParams;
  Klist:=TlistG.create(sizeof(TKrecord2));

  Ferror:=false;
  TRY
    vec.initTemp1(0,CycleCount-1,g_single);

    for i:=1 to RA.nblig do
      begin
        w.value:=RA.value[7,i];
        if w.value<>0 then
          begin
            x1:=roundL(RA.value[1,i])-1;
            y1:=roundL(RA.value[2,i])-1;
            tau1:=roundL(RA.value[3,i]);

            x2:=roundL(RA.value[4,i])-1;
            y2:=roundL(RA.value[5,i])-1;
            tau2:=roundL(RA.value[6,i]);

            if (x1>=0) and (y1>=0)
              then Klist.add(@w)
              else Ferror:=true;
          end;
      end;

    data:=vec.data;

    if not Ferror then
      for t:=0 to CycleCount-1 do
      begin
        vec.Yvalue[t]:=0;
        for i:=0 to Klist.count-1 do
          with PKrecord2(Klist[i])^ do
          if First
            then data^.addE(t,value*noise.f(x1,y1,t-tau1))
            else data^.addE(t,value*noise.f(x1,y1,t-tau1)
                            *noise.f(x2,y2,t-tau2));
      end;

  FINALLY
    Klist.free;
  END;
end;


type
  TBKrecord=record
              x,y:byte;
              t:smallint;
              value:single;
           end;
  PBKrecord=^TBKrecord;

  TBKrecord2=record
              x1,y1:byte;
              t1:smallint;
              x2,y2:byte;
              t2:smallint;
              value:single;
            end;
  PBKrecord2=^TBKrecord2;


function compareK1(Item1, Item2: Pointer): Integer;
begin
  if PBKrecord(item1)^.value<PBKrecord(item2)^.value then result:=-1
  else
  if PBKrecord(item1)^.value>PBKrecord(item2)^.value then result:=1
  else result:=0;
end;

function compareK2(Item1, Item2: Pointer): Integer;
begin
  if PBKrecord2(item1)^.value<PBKrecord2(item2)^.value then result:=-1
  else
  if PBKrecord2(item1)^.value>PBKrecord2(item2)^.value then result:=1
  else result:=0;
end;


procedure TdenseNoise.BuildK1list(var RA:TrealArray;seuil1,seuil2:float);
var
  i,k:integer;
  x,y,t:integer;
  Nt:integer;
  w:TBKrecord;
  Klist:TlistG;
begin
  Klist:=TlistG.create(sizeof(TBKrecord));

  TRY
    RA.modify(4,Nx*Ny*NtauK1);

    for t:=0 to ntauK1-1 do
    for y:=0 to ny-1 do
    for x:=0 to nx-1 do
      begin
        w.value:=Ker1[x,y,t];
        if (w.value<=seuil1) or (w.value>=seuil2) then
          begin
            w.x:=x;
            w.y:=y;
            w.t:=t;
            Klist.add(@w);
          end;
      end;

    Klist.sort(compareK1);

    for i:=0 to nx*ny*ntauK1-1 do
    with PBKrecord(Klist[i])^ do
    begin
      RA.value[1,i+1]:=x+1;
      RA.value[2,i+1]:=y+1;
      RA.value[3,i+1]:=tau1K1+t;
      RA.value[4,i+1]:=value;
    end;

  FINALLY
    Klist.free;
  END;
end;

procedure TdenseNoise.BuildK2list(var RA:TrealArray;seuil1,seuil2:float);
var
  i,k:integer;
  x1,y1,t1,x2,y2,t2:integer;
  Nt:integer;
  w:TBKrecord2;
  w0:single;
  index1,index2:integer;
  Klist:TlistG;
  
begin
  Klist:=TlistG.create(sizeof(TBKrecord2));

  TRY
    RA.modify(8,Nx*Ny*Nt*Nx*Ny*Nt);

    for t2:=0 to ntauK2-1 do
    for y2:=0 to ny-1 do
    for x2:=0 to nx-1 do
    for t1:=0 to ntauK2-1 do
    for y1:=0 to ny-1 do
    for x1:=0 to nx-1 do
      begin
        w.value:=Ker2[x1,y1,tau1K2,x2,y2,tau2K2];
        if (w.value<=seuil1) or (w.value>=seuil2) then
          begin
            w.x1:=x1;
            w.y1:=y1;
            w.t1:=t1;
            w.x2:=x2;
            w.y2:=y2;
            w.t2:=t2;
            Klist.add(@w);
          end;
      end;

    Klist.sort(compareK2);

    for i:=0 to Klist.count-1 do
    with PBKrecord2(Klist[i])^ do
    begin
      RA.value[1,i+1]:=x1+1;
      RA.value[2,i+1]:=y1+1;
      RA.value[3,i+1]:=tau1K2+t1;
      RA.value[4,i+1]:=x2+1;
      RA.value[5,i+1]:=y2+1;
      RA.value[6,i+1]:=tau1K2+t2;

      RA.value[7,i+1]:=value;
    end;

  FINALLY
    Klist.free;
  END;
end;

function TdenseNoise.Phi1(x1,y1,t1,x2,y2,t2:integer): float;
var
  i:integer;
  decal1,decal2:integer;
  min,max:integer;
begin
(*
  min:=0;
  {
  if t1>min then min:=t1;
  if t2>min then min:=t2;
  }
  max:=cycleCount-1;
  {
  if cycleCount+t1-1<max then max:=cycleCount+t1-1;
  if cycleCount+t2-1<max then max:=cycleCount+t2-1;
  }
  decal1:=((x1+y1*nx)*pseq-t1 +lgBB) mod LgBB;
  decal2:=((x2+y2*nx)*pseq-t2 +lgBB) mod LgBB;

  result:=0;
  for i:=min to max do
    result:=result+BB[word(i+decal1)]*BB[word(i+decal2)];
  result:=result/(max-min+1);
  *)
end;

function TdenseNoise.InvPhi1(x1,y1,t1,x2,y2,t2:integer): float;
begin
  if (x1=x2) and (y1=y2) and (t1=t2)
    then result:=2-phi1(x1,y1,t1,x2,y2,t2)
    else result:=-phi1(x1,y1,t1,x2,y2,t2);
end;

procedure TdenseNoise.CorrectionK1;
var
  x,y,t,x1,y1,t1:integer;
  w:float;

  tab:array of array of array of single;
  mat:typeMatrice;
  det:float;
  st:string;
begin
  setLength(tab,nx,ny,ntauK1);

  setLength(mat,nx*ny*ntauK1,nx*ny*ntauK1);

  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  for t:=0 to ntauK1-1 do
  for x1:=0 to nx-1 do
  for y1:=0 to ny-1 do
  for t1:=0 to ntauK1-1 do
    mat[x+nx*y+nx*ny*t,x1+nx*y1+nx*ny*t1]:=Phi1(x,y,t,x1,y1,t1);

  matInv(mat,det);
  if det=0 then
    begin
      messageCentral('Det=0');
      exit;
    end;

  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  for t:=0 to ntauK1-1 do
    begin
      w:=0;
      for x1:=0 to nx-1 do
      for y1:=0 to ny-1 do
      for t1:=0 to ntauK1-1 do
        w:=w+ker1[x1,y1,t1]*mat[x+nx*y+nx*ny*t,x1+nx*y1+nx*ny*t1];
      tab[x,y,t]:=w;
    end;

  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  for t:=0 to ntauK1-1 do
    ker1[x,y,t]:=tab[x,y,t];
end;

procedure TdenseNoise.setSeed(x:integer);
begin
  inherited setSeed(x);
end;



procedure TdenseNoise.processMessage(id:integer;source:typeUO;p:pointer);
var
  i:integer;
begin
  if not assigned(source) then exit;

  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
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
      end;

  end;
end;

function TdenseNoise.getState(x,y,t:integer):integer;
begin
  result:=noise.f(x,y,t);
end;

{ Calcul des PSTW }

procedure TdenseNoise.initPstw(var1,var2:TaverageArray;source:Tvector;x1,x2:float);
var
  i,i1,i2:integer;
begin
  initParams;

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

var
  E_average:integer;

procedure TdenseNoise.calculatePstw;
var
  i:integer;
  x,y,z:integer;
  t:double;

  vv:Taverage;

begin
  for i:=1 to 2 do
    if not assigned(pstw[i])  then exit;

  for i:=0 to cycleCount-1 do
  begin
    t:=EvtTimes[i]*dxEvt;
    for x:=0 to nx-1 do
    for y:=0 to ny-1 do
    begin
      z:=getState(x,y,i);
      vv:=pstw[z+1].average(x+1,y+1);
      if assigned(vv)
        then vv.addEx(sourcePstw,t)
        else sortieErreur(E_average);
    end;    
  end;

end;

procedure TdenseNoise.InstallTimes(vec:Tvector;dx:float);
var
  i:integer;
begin
  dxEvt:=dx;
  setLength(EvtTimes,cycleCount);
  for i:=0 to cycleCount-1 do
    EvtTimes[i]:=roundL(vec.Yvalue[vec.Istart+i]/dxEvt);
end;


{*************************** Méthodes STM ************************************}

var
  E_order:integer;

  E_ker1:integer;
  E_ker2:integer;

  E_index:integer;
  E_data:integer;

  E_XYpos:integer;
  E_simul:integer;

procedure proTdenseNoise_create(name:String;var pu:typeUO);
begin
  createPgObject(name,pu,TdenseNoise);

  with TdenseNoise(pu) do
  begin
    setChildNames;
  end;
end;


procedure proTdenseNoise_Nvalue(n,value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TdenseNoise(pu) do
  begin
  end;
end;


function fonctionTdenseNoise_Nvalue(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TdenseNoise(pu) do
  begin
  end;
end;

function fonctionTdenseNoise_length(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TdenseNoise(pu) do ;
end;

procedure proTdenseNoise_BuildK1(var Vdata:Tvector;t1,t2:integer;Fclear:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(Vdata));

  with TdenseNoise(pu) do CalculK1(Vdata,t1,t2,Fclear);
end;


procedure proTdenseNoise_BuildK2(var Vdata:Tvector;t1,t2:integer;Fclear:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(Vdata));

  with TdenseNoise(pu) do CalculK2(Vdata,t1,t2,Fclear);
end;


procedure proTdenseNoise_FirstOrder(var mat:Tmatrix;tau:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));

  TdenseNoise(pu).firstOrder(mat,tau);
end;


procedure proTdenseNoise_SecondOrder(var mat:Tmatrix;x1,y1,tau1,tau2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));

  TdenseNoise(pu).SecondOrder(mat,x1-1,y1-1,tau1,tau2);
end;

procedure proTdenseNoise_SecondOrder1(var mat:Tmatrix;tau1,dx,dy,dt:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));

  TdenseNoise(pu).SecondOrder1(mat,tau1,dx,dy,dt);
end;


function fonctionTdenseNoise_Kernel1(x,y,t:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TdenseNoise(pu) do
  begin
    if not assigned(ker1) then sortieErreur(E_ker1);
    if (x<1) or (x>nx) or
       (y<1) or (y>ny) or
       (t<tau1K1) or (t>tau2K1) then sortieErreur(E_XYpos);

    result:=kernel1[x-1,y-1,t];
  end;
end;


function fonctionTdenseNoise_Kernel2(x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TdenseNoise(pu) do
  begin
    if not assigned(ker2) then sortieErreur(E_ker2);

    if (x1<1) or (x1>nx) or
       (y1<1) or (y1>ny) or
       (x2<1) or (x2>nx) or
       (y2<1) or (y2>ny) or
       (t1<tau1K2) or (t1>tau2K2) or
       (t2<tau1K2) or (t2>tau2K2)
       then sortieErreur(E_XYpos);

    result:=kernel2[x1-1,y1-1,t1,x2-1,y2-1,t2];
  end;
end;

function fonctionTdenseNoise_Ker1(var Vdata:Tvector;x,y,t:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  verifierVecteur(Vdata);
  with TdenseNoise(pu) do
  begin
    if (x<1) or (x>nx) or
       (y<1) or (y>ny) or
       (t<tau1K1) or (t>tau2K1) then sortieErreur(E_XYpos);

    result:=getXker1(Vdata,x-1,y-1,t);
  end;
end;


function fonctionTdenseNoise_Ker2(var Vdata:Tvector;x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TdenseNoise(pu) do
  begin
    if not assigned(ker2) then sortieErreur(E_ker2);

    if (x1<1) or (x1>nx) or
       (y1<1) or (y1>ny) or
       (x2<1) or (x2>nx) or
       (y2<1) or (y2>ny) or
       (t1<tau1K2) or (t1>tau2K2) or
       (t2<tau1K2) or (t2>tau2K2)
       then sortieErreur(E_XYpos);

    result:=getXker2(Vdata,x1-1,y1-1,t1,x2-1,y2-1,t2);
  end;
end;


procedure proTdenseNoise_Simulate(var RA:TrealArray;
                                  var vec:Tvector;
                                  var pu:typeUO);
var
  error:boolean;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));
  verifierObjet(typeUO(RA));

  vec.controleReadOnly;

  with TdenseNoise(pu) do simulate(ra,vec,error);
  if error then sortieErreur(E_simul);
end;


function fonctionTdenseNoise_VK1(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with TdenseNoise(pu) do result:=@VK1.myAd;
end;

function fonctionTdenseNoise_VK2(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with TdenseNoise(pu) do result:=@VK2.myAd;
end;

procedure proTdenseNoise_BuildK1list(var RA:TrealArray;
                                    seuil1,seuil2:float;
                                    var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(RA));
  with TdenseNoise(pu) do BuildK1list(RA,seuil1,seuil2);
end;

procedure proTdenseNoise_BuildK2list(var RA:TrealArray;
                                    seuil1,seuil2:float;
                                    var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(RA));
  with TdenseNoise(pu) do BuildK2list(RA,seuil1,seuil2);
end;


procedure proTdenseNoise_K1Correction(var pu:typeUO);
begin
  verifierObjet(pu);
  with TdenseNoise(pu) do CorrectionK1;
end;

Function FonctionTdenseNoise_Phi1(x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TdenseNoise(pu).phi1(x1,y1,t1,x2,y2,t2);
end;

Function FonctionTdenseNoise_InvPhi1(x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TdenseNoise(pu).InvPhi1(x1,y1,t1,x2,y2,t2);
end;

function fonctionTdenseNoise_Gstate(x,y,t:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);

  result:=TdenseNoise(pu).Gstate(x-1,y-1,t);
end;

procedure proTdenseNoise_calculatePstw(var pu:typeUO);
begin
  verifierObjet(pu);
  with TdenseNoise(pu) do calculatePstw;
end;

procedure proTdenseNoise_initPstw(var v1,v2:TaverageArray;var source:Tvector;
                                      x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));

  verifierVecteur(source);

  with TdenseNoise(pu) do initPstw(v1,v2,source,x1,x2);
end;

var
  E_installTimes:integer;

procedure proTdenseNoise_installTimes(var vecEvt:Tvector;dx:float;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with TdenseNoise(pu) do
  begin
    if cycleCount=0 then sortieErreur(E_installTimes);
    InstallTimes(vecEvt,dx);
  end;
end;



Initialization

registerObject(TdenseNoise,stim);

installError(E_order,'TdenseNoise: order out of range');
installError(E_index,'TdenseNoise: index out of range');
installError(E_simul,'TdenseNoise.simulate bad data ');

installError(E_ker1,'TdenseNoise: kernel1 not available ');
installError(E_ker2,'TdenseNoise: kernel2 not available ');

installError(E_XYpos,'TdenseNoise: invalid coordinates x y t ');
installError(E_average,'TdenseNoise: CalculatePstw error ');


end.