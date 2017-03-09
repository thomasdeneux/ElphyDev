unit stmMseq0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,math,sysutils,
     util1,dtf0,Dgraphic,Dpalette, Debug0,
     stmDef,stmObj,stmobv0,stmrev1,varconf1,Ncdef2,
     defForm,selRF1,editcont,
     getMseq1,syspal32,
     stmgrid0,
     stmvec1,stmMat1,stmOdat2,
     stmPg,stmError,
     Rarray1,listG;


type
    Tmseq=    class(Trevcor)

              private
                mG,mT: PtabWord;
                b: PtabShort;   //vecteur des valeurs binaires de la mseq (-1 ou 1)
                length0 : integer; // 2^ordre0-1
                valtap0 : integer; //feedback tap, déterminé par ordre0
                ordre0 : integer;  //de 1 à 16

                fmt:PtabSingle;
                ker1:array of array of array of single;
                ker2:array of array of array of array of array of array of single;
                tau1,tau2,Ntau:integer;

                tabdec:PtabWord;

                pseq:integer;

                grid:Tgrid;

                dataK1,dataK2:typeDataGetE;
                VK1,VK2:Tvector;


                procedure CalculMsequence;
                procedure BuildTbDiff;

                procedure CalculK1(t1,t2:integer);
                procedure CalculK2(t1,t2:integer);

                procedure CorrectFMT(t1,t2:integer);

                function getKer1L(i:integer):float;
                function getKer2L(i:integer):float;

                procedure setChildNames;override;

              public
                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;

                procedure setVisiFlags(obOn:boolean);override;

                procedure InitMvt; override;
                procedure initObvis;override;
                procedure calculeMvt; override;
                procedure doneMvt; override;

                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;

                function dialogForm:TclassGenForm;override;
                procedure installDialog(var form:Tgenform;var newF:boolean);
                            override;
                function Compare(m:Tmseq):integer;

                procedure orderChange;
                function Von(x,y:integer):boolean;
                procedure initParams;

                function LoadTbDiff(st:AnsiString):boolean;
                function saveTbDiff(st:AnsiString):boolean;

                procedure fmtS(VData:Tvector);

                procedure FirstOrder(var mat:Tmatrix;tau:integer);
                procedure SecondOrder(var mat:Tmatrix;x1,y1,t1,t2:integer);
                procedure SecondOrder1(var mat:Tmatrix;tau1,dx,dy,dt:integer);

                function getKernel1(x,y,tau:integer):float;
                procedure setKernel1(x,y,tau:integer;w:float);
                function getKernel2(x1,y1,t1,x2,y2,t2:integer):float;
                procedure setKernel2(x1,y1,t1,x2,y2,t2:integer;w:float);

                property Kernel1[x,y,tau:integer]:float read getKernel1
                                                        write setKernel1;
                property Kernel2[x1,y1,t1,x2,y2,t2:integer]:float read getKernel2
                                                                  write setKernel2;


                procedure BuildK1list(tmin,tmax:integer;var RA:TrealArray;seuil1,seuil2:float);
                procedure BuildK2list(tmin,tmax:integer;var RA:TrealArray;seuil1,seuil2:float);

                procedure ReBuildData1(tmin,tmax:integer;var vec:Tvector;seuil1,seuil2:float);
                procedure ReBuildData2(tmin,tmax:integer;var vec:Tvector;seuil1,seuil2:float);

                procedure Simulate(var RA:TrealArray;var vec:Tvector);
                function testK2(t1,t2:integer):integer;
              end;


procedure proTmsequence_create(name:AnsiString;order:integer;var pu:typeUO);pascal;

procedure proTmsequence_order(ww:integer;var pu:typeUO);pascal;
function fonctionTmsequence_order(var pu:typeUO):integer;pascal;

procedure proTmsequence_valtap(ww:integer;var pu:typeUO);pascal;
function fonctionTmsequence_valtap(var pu:typeUO):integer;pascal;

procedure proTmsequence_BuildShiftTable(var pu:typeUO);pascal;
procedure proTmsequence_LoadShiftTable(st:AnsiString;var pu:typeUO);pascal;
procedure proTmsequence_SaveShiftTable(st:AnsiString;var pu:typeUO);pascal;

function fonctionTmsequence_ShiftTable(n:integer;var pu:typeUO):integer;pascal;
function fonctionTmsequence_length(var pu:typeUO):integer;pascal;

function fonctionTmsequence_Bvalue(n:integer;var pu:typeUO):integer;pascal;
function fonctionTmsequence_MTvalue(n:integer;var pu:typeUO):integer;pascal;
function fonctionTmsequence_MGvalue(n:integer;var pu:typeUO):integer;pascal;

procedure proTmsequence_BuildFMT(var Vdata:Tvector;var pu:typeUO);pascal;
function fonctionTmsequence_FMTvalue(n:integer;var pu:typeUO):float;pascal;
procedure proTmsequence_FirstOrder(var mat:Tmatrix;tau:integer;var pu:typeUO);pascal;
procedure proTmsequence_SecondOrder(var mat:Tmatrix;x1,y1,t1,t2:integer;
                                    var pu:typeUO);pascal;
procedure proTmsequence_SecondOrder1(var mat:Tmatrix;tau1,dx,dy,dt:integer;
                                    var pu:typeUO);pascal;

function fonctionTmsequence_Kernel1(x,y,tau:integer;var pu:typeUO):float;pascal;
procedure proTmsequence_Kernel1(x,y,t:integer;w:float;var pu:typeUO);pascal;

function fonctionTmsequence_Kernel2(x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):float;pascal;
procedure proTmsequence_Kernel2(x1,y1,t1,x2,y2,t2:integer;w:float;var pu:typeUO);pascal;



procedure proTmsequence_BuildK1list(tmin,tmax:integer;var RA:TrealArray;
                                    seuil1,seuil2:float;
                                    var pu:typeUO);pascal;
procedure proTmsequence_BuildK2list(tmin,tmax:integer;var RA:TrealArray;
                                    seuil1,seuil2:float;
                                    var pu:typeUO);pascal;

procedure proTmsequence_reBuildData1(tmin,tmax:integer;var vec:Tvector;
                                     seuil1,seuil2:float;
                                     var pu:typeUO);pascal;

procedure proTmsequence_reBuildData2(tmin,tmax:integer;var vec:Tvector;
                                     seuil1,seuil2:float;
                                     var pu:typeUO);pascal;


procedure proTmsequence_Simulate(var RA:TrealArray;
                                  var vec:Tvector;
                                  var pu:typeUO);pascal;

function fonctionTmsequence_VK1(var pu:typeUO):Tvector;pascal;
function fonctionTmsequence_VK2(var pu:typeUO):Tvector;pascal;

procedure proTmsequence_BuildK1(t1,t2:integer;var pu:typeUO);pascal;
procedure proTmsequence_BuildK2(t1,t2:integer;var pu:typeUO);pascal;

procedure proTmsequence_CorrectFMT(t1,t2:integer;var pu:typeUO);pascal;

function fonctionTestMseqTap(ordre,Xtap:integer):boolean;pascal;
function fonctionTmsequence_testK2(t1,t2:integer;var pu:typeUO):integer;pascal;


implementation


function DeuxPuissance(a:integer) : integer;
var
  i: integer;
begin
  result:=1;
  for i:=1 to a do result:=2*result;
end;

function DefaultValTap(ordre:integer):integer;
begin
  case ordre of
    8:    result:=29;
    9:    result:=17;
    10:   result:=9;
    11:   result:=5;
    12:   result:=83;
    13:   result:=27;
    14:   result:=43;
    15:   result:=53;
    16:   result:=45;
    else result:=0;
  end
end;


{*********************   Méthodes de Tmseq  *************************}

constructor Tmseq.create;
var
  i,j:smallInt;
begin
  inherited create;

  timeMan.dtOn:=1;
  ordre0:=16;
  valtap0:=defaultValTap(ordre0);


  nbDivX:=8;
  nbDivY:=8;
  expansion:=100;

  if assigned(rfSys[1])
    then RFDeg:=rfSys[1].deg
    else RFdeg:=degNul;

  grid:=Tgrid.create;
  grid.notpublished:=true;
  grid.Fchild:=true;
  orderChange;

  calculMsequence;

  dataK1:=typedataGetE.create(getKer1L,0,1);

  VK1:=Tvector.create;
  AddTochildList(VK1);
  with VK1 do
    initdat1(@dataK1,g_single);

  dataK2:=typeDataGetE.create(getKer2L,0,1);

  VK2:=Tvector.create;
  AddTochildList(VK2);
  with VK2 do
    initdat1(@dataK2,g_single);

end;


destructor Tmseq.destroy;
var
  i,j:smallInt;
begin
  if assigned(b) then FreeMem(b);
  if assigned(mG) then Freemem(mG);
  if assigned(mT) then Freemem(mT);
  if assigned(tabdec) then freemem(tabDec);
  if assigned(fmt) then Freemem(fmt);

  grid.free;

  VK1.free;
  VK2.free;


  inherited destroy;
end;

function Tmseq.getKer1L(i:integer):float;
var
  x,y,tau:integer;
begin
  if (ntau>0) and assigned(ker1) then
  begin
    tau:=i mod ntau;
    i:=i div ntau;
    y:= i mod ny;
    x:=i div ny;
    result:=ker1[x,y,tau];
  end
  else result:=0;
end;

function Tmseq.getKer2L(i:integer):float;
var
  x1,y1,t1,x2,y2,t2:integer;
begin
  if (ntau>0) and assigned(ker2) then
  begin
    t2:=i mod ntau;
    i:=i div ntau;

    y2:= i mod ny;
    i:=i div ny;

    x2:= i mod nx;
    i:=i div nx;

    t1:=i mod ntau;
    i:=i div ntau;

    y1:= i mod ny;
    x1:=i div ny;

    result:=ker2[x1,y1,t1,x2,y2,t2];
  end
  else result:=0;
end;


procedure Tmseq.setChildNames;
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


function Parity(n:integer):boolean;assembler;pascal;
asm
  mov  eax,1
  mov  ecx,n
  test ecx,ecx
  jp   @@1
  mov  eax,0
@@1:
end;

procedure Tmseq.CalculMsequence;
var
  i  : integer;
  x1,x2,x3,q : word;

begin
  initParams;

  if assigned(b) then freemem(b);
  if assigned(mG) then freemem(mG);
  if assigned(mT) then freemem(mT);

  length0:=DeuxPuissance(ordre0)-1;
  GetMem(b,length0*sizeOf(shortint));
  GetMem(mG,length0*sizeOf(word));
  GetMem(mT,length0*sizeOf(word));

  x1:=1;
  b^[0]:=-1;
  mT^[0]:=1;
  q:=DeuxPuissance(ordre0-1);

  for i:=1 to length0-1 do
    begin
      if (x1 and q)<>q then x1:= x1 shl 1
                       else x1:= (x1 shl 1) xor valtap0;
      x1:=x1 and length0;
      if x1 and 1=0 then b^[i]:=1 else b^[i]:=-1;
      mT^[i]:=x1;
    end;


  x2:=1;
  mG^[0]:=1;
  for i:=1 to length0-1 do
     begin
       x1:=x2;
       x2:=x1 shr 1;
       x3:=x1 and valTap0;
       if parity(x3) then x3:=0
                     else x3:=1;
       x2:=x2+q*x3;
       mG^[i]:=x2;
     end;

end;


function TestTap(ordre,Xtap:word):boolean;
var
  i  : integer;
  x1,x2,x3,q : word;
  l0:integer;

  mT:Tlist;
begin
  result:=true;

  l0:=DeuxPuissance(ordre)-1;
  mT:=Tlist.create;

  x1:=1;
  mT.Add(pointer(1));
  q:=DeuxPuissance(ordre-1);

  for i:=1 to l0-1 do
    begin
      if (x1 and q)<>q then x1:= x1 shl 1
                       else x1:= (x1 shl 1) xor Xtap;
      x1:=x1 and l0;

      if mt.IndexOf(pointer(x1))>=0 then
      begin
        result:=false;
        break;
      end;
      mT.Add(pointer(x1));
    end;

  mt.Free;
end;



class function Tmseq.STMClassName:AnsiString;
  begin
    STMClassName:='Msequence';
  end;

procedure Tmseq.initParams;
begin
  index:=-1;
  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);
  pseq:=DeuxPuissance(ordre0) div (nx*ny);

  with timeMan do
  begin
    nbCycle:=DeuxPuissance(ordre0)-1;
    dureeC:=dtON+dtOff+pause;
    tend:=torg+dureeC*nbCycle;
  end;

end;


procedure Tmseq.InitMvt;
  var
    i,j:integer;
    deg1:typeDegre;
  begin
    SortSyncPulse;
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

    obvis.deg.lum:=20;



    grid.obvisA[1]:=obvis;

    grid.obvisA[2]:=Tresizable(obvis.clone(false));
    grid.obvisA[2].deg.lum:=0;

  end;

procedure TMseq.initObvis;
begin
  grid.obvisA[1].prepareS;
  grid.obvisA[2].prepareS;
end;

function Tmseq.Von(x,y:integer):boolean;
var
  k:integer;
begin
  k:=(index+pseq*(x+nx*y) ) mod length0;
  result:=(b^[k]=1);
end;

procedure Tmseq.calculeMvt;
var
  i,j:integer;
begin
  if (timeS mod dureeC=0)  then inc(Index);

  for i:=0 to nx-1 do
    for j:=0 to ny-1 do
        grid.obvisOn^[i+nx*j]:=Von(i,j);
end;

procedure Tmseq.doneMvt;
begin

  grid.obvisA[2].free;
  obvis:=grid.obvisA[1];

  grid.obvisA[1]:=nil;
  grid.obvisA[2]:=nil;
end;

procedure Tmseq.setVisiFlags(obOn:boolean);
begin
  if affStim and ObON then Grid.FlagOnScreen:=true;
  if affControl and ObON then Grid.FlagOnControl:=true;
end;

procedure Tmseq.buildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin
      if tout then setvarConf('OBVIS',intG(obvis),sizeof(intG));
      setVarConf('ORDER',ordre0,sizeof(ordre0));
    end;
  end;

procedure Tmseq.CompleteLoadInfo;
begin
  CheckOldIdent;
  majPos;
end;

function Tmseq.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetMseq;;
end;

procedure Tmseq.orderChange;
begin
  calculMsequence;
end;

procedure Tmseq.installDialog(var form:Tgenform;var newF:boolean);
begin
    installForm(form,newF);

    with TgetMseq(form) do
    begin
      enOrder.setVar(ordre0,T_longInt);
      enOrder.setMinMax(8,16);

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
      cbDivX.setNumVar(nbDivX,T_smallint);

      cbDivY.setString('2|4|8|16');
      cbDivY.setNumVar(nbDivY,T_smallint);

      enLum1.setVar(lum[1],T_single);
      enLum1.setMinMax(0,10000);

      enLum2.setVar(lum[2],T_single);
      enLum2.setMinMax(0,10000);

      cbExpansion.setString('25|50|100|200|400');
      cbExpansion.setNumVar(Expansion,T_smallint);

      selectRFD:=SelectRF;

      CBadjust.setvar(adjustObjectSize);

      onControlD:=SetOnControl;   {Ces procédures doivent être mises en place}
      onScreenD:=SetOnScreen;     {AVANT de modifier checked }
      orderChangeD:=orderChange;

      CbOnControl.checked:=onControl;
      CbOnScreen.checked:=onScreen;

      initCBvisual(self,typeUO(obvis));
      updateAllCtrl(form);
    end;
end;

function CpMseq(var a,b:PtabShort;max:integer):integer;
var
  i,j:integer;
begin
  i:=0;
  repeat
    j:=0;
    while (j<max) and (b^[j]=a^[(i+j) mod max]) do inc(j);
    inc(i);
  until (j=max) or (i=max);

  if j=max
    then result:=i-1
    else result:=-1;
end;


{ si b est égale à a décalée de tau et multipliée par a , on obtient:
}
function CpMseqMultiplieeDecale(var a:PtabShort;max:integer;tau:integer):integer;
var
  i,j:integer;
begin
  i:=0;
  repeat
    j:=0;
    while (j<max) and (a^[(j+tau) mod max]*a^[j]=a^[(i+j) mod max]) do inc(j);
    inc(i);
  until (j=max) or (i=max);

  if j=max
    then result:=i-1
    else result:=-1;
end;


function Tmseq.Compare(m:Tmseq):integer;
begin
  result:=CpMseq(b,m.b,length0);
end;

procedure Tmseq.BuildTbDiff;
var
  i:integer;
  f:file;
  res:integer;
begin
  if tabdec<>nil then freemem(tabdec);
  getmem(tabdec,length0*sizeof(smallint));
  tabdec^[0]:=0;

  for i:=1 to length0-1 do
  begin
    tabDec^[i]:=CpMseqMultiplieeDecale(b,length0,i);
    if i mod 1000=0 then statusLineTxt(Istr(i));
  end;
end;

function Tmseq.saveTbDiff(st:AnsiString):boolean;
var
  f:TfileStream;
begin
  result:=false;
  if (st='') or not assigned(tabdec) then exit;

  f:=nil;
  try
  f:=TfileStream.Create(st,fmCreate);

  f.write(tabDec^,length0*2);
  f.free;
  result:=true;

  except
  f.free;
  result:=false;
  end;
end;

function Tmseq.LoadTbDiff(st:AnsiString):boolean;
var
  f:TfileStream;
  res:integer;
begin
  result:=false;
  if (st='') then exit;

  f:=nil;
  try
  f:=TfileStream.create(st,fmOpenRead);

  if f.Size<>length0*2 then
    begin
      f.free;
      exit;
    end;

  if tabdec<>nil then freemem(tabdec);
  getmem(tabdec,length0*2);

  f.read(tabDec^,length0*2);
  f.free;
  result:=true;

  except
  f.Free;
  result:=false;
  end;
end;

procedure Tmseq.fmtS(VData:Tvector);
var
  i,mtSortie,dist,mtentree,blockStart,block,paire,x1,x2: integer;
  a,b:single;
  cc:PtabSingle;
begin
  if assigned(fmt) then freemem(fmt);
  getmem(fmt,length0*sizeof(single));

  getmem(cc,(length0+1)*sizeof(single));

  TRY
  cc^[0]:=0;
  {permutation sur les colonnes (G)}
  for i:=0 to length0-1 do
    begin
      mtEntree:=mg^[i];
      cc^[mtEntree]:=VData.Yvalue[i];
    end;

  {FWT}
  dist:= 1;
  blockStart:= length0;
  repeat
    x1:=0;
    blockStart:=blockStart div 2;
    for block:=blockStart downTo 0 do
      begin
        x2:= x1+dist;
        for paire:=0 to (dist-1) do
            begin
              a:=cc^[x1];
              b:=cc^[x2];
              cc^[x1]:=(a+b);
              cc^[x2]:=(a-b);
              inc(x1);
              inc(x2);
            end;
        x1:=x2;
        end;
    dist:=(dist+dist) and length0;
  until (dist=0);

  {permutation sur les lignes (T)}
  for i:=0 to (length0-1) do
    begin
      mtSortie:=mt^[i];
      fmt^[i]:=cc^[mtSortie];
    end;

  FINALLY
  freemem(cc);
  END;
end;

procedure Tmseq.FirstOrder(var mat:Tmatrix;tau:integer);
var
  i,j:integer;
begin
  initParams;
  mat.modify(mat.tpNum,1,1,nx,ny);

  for i:=0 to nX-1 do
  for j:=0 to nY-1 do
    mat.Zvalue[1+i,1+j]:=kernel1[i,j,tau];
end;

procedure Tmseq.SecondOrder(var mat:Tmatrix;x1,y1,t1,t2:integer);
var
  i,j:integer;
begin
  initParams;
  mat.modify(mat.tpNum,1,1,nx,ny);

  for i:=0 to nX-1 do
  for j:=0 to nY-1 do
    mat.Zvalue[1+i,1+j]:= Kernel2[x1,y1,t1,i,j,t2];
end;

procedure Tmseq.SecondOrder1(var mat:Tmatrix;tau1,dx,dy,dt:integer);
var
  i,j:integer;
begin
  initParams;
  mat.modify(mat.tpNum,1,1,nx,ny);

  for i:=max(0,-dx) to min(nX-1,nX-dx-1) do
  for j:=max(0,-dy) to min(nY-1,nY-dy-1) do
    mat.Zvalue[1+i,1+j]:= kernel2[i,j,tau1,i+dx,j+dx,tau1+dt];

end;


function Tmseq.getKernel1(x,y,tau:integer):float;
begin
  result:=ker1[x,y,tau];
end;

procedure Tmseq.setKernel1(x,y,tau:integer;w:float);
begin
  if (x>=0) and (x<nx) and (y>=0) and (y<ny) and (tau>=tau1) and (tau<=tau2)
    then ker1[x,y,tau-tau1]:=w;
end;



function Tmseq.getKernel2(x1,y1,t1,x2,y2,t2:integer):float;
begin
  result:=ker2[x1,y1,t1,x2,y2,t2];
end;

procedure Tmseq.setKernel2(x1,y1,t1,x2,y2,t2:integer;w:float);
begin
  if (x1>=0) and (x1<nx) and (y1>=0) and (y1<ny) and (t1>=tau1) and (t1<=tau2)
     and
     (x2>=0) and (x2<nx) and (y2>=0) and (y2<ny) and (t2>=tau1) and (t2<=tau2)
    then ker2[x1,y1,t1-tau1,x2,y2,t2-tau1]:=w;

end;


procedure Tmseq.CalculK1(t1,t2:integer);
var
  x,y,tau:integer;
begin
  initParams;

  tau1:=t1;
  tau2:=t2;
  Ntau:=t2-t1+1;

  setLength(ker1,nx,ny,ntau);

  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  for tau:=0 to ntau-1 do
    ker1[x,y,tau]:=fmt^[(length0+ pseq*(x+nX*y)- tau) mod length0]/length0;

  dataK1.create(getKer1L,0,nx*ny*ntau-1);
  VK1.initdat1(@dataK1,g_single);
end;

procedure Tmseq.CorrectFMT(t1,t2:integer);
var
  x,y,tau:integer;
begin
  initParams;

  tau1:=t1;
  tau2:=t2;
  Ntau:=t2-t1+1;

  for x:=0 to nx-1 do
  for y:=0 to ny-1 do
  for tau:=0 to ntau-1 do
    fmt^[(length0+ pseq*(x+nX*y)- tau) mod length0]:=0;
end;


procedure Tmseq.CalculK2(t1,t2:integer);
var
  x1,y1,k1,x2,y2,k2:integer;
  index,index1,index2:integer;
begin
  initParams;

  tau1:=t1;
  tau2:=t2;
  Ntau:=t2-t1+1;

  setLength(ker2,nx,ny,ntau,nx,ny,ntau);

  if assigned(tabdec) then
    for x1:=0 to nx-1 do
    for y1:=0 to ny-1 do
    for k1:=0 to ntau-1 do
    for x2:=0 to nx-1 do
    for y2:=0 to ny-1 do
    for k2:=0 to ntau-1 do
      begin
        index1:=pseq*(x1+nX*y1)-k1 ;
        index2:=pseq*(x2+nX*y2)-k2 ;
        index:=(index1+tabdec^[(index2-index1+length0) mod length0]+length0) mod length0;
        ker2[x1,y1,k1,x2,y2,k2]:=fmt^[index]/({2*}length0);
      end;

  for x1:=0 to nx-1 do
  for y1:=0 to ny-1 do
  for k1:=0 to ntau-1 do
    ker2[x1,y1,k1,x1,y1,k1]:=0;

  dataK2.create(getKer2L,0,sqr(nx*ny*ntau)-1);
  VK2.initdat1(@dataK2,g_single);
end;

function Tmseq.testK2(t1,t2:integer):integer;
var
  flag:array of word;
  i:integer;
  x1,y1,k1,x2,y2,k2:integer;
  nb:array[0..30] of integer;
  st:AnsiString;
begin
  setLength(flag,length0);
  fillchar(flag[0],length0*2,0);

  if assigned(fmt) then freemem(fmt);
  getmem(fmt,length0*sizeof(single));
  for i:=0 to length0-1 do
    fmt^[i]:=i+1;

  calculK2(t1,t2);

  for x1:=0 to nx-1 do
  for y1:=0 to ny-1 do
  for k1:=0 to ntau-1 do
  for x2:=0 to nx-1 do
  for y2:=0 to ny-1 do
  for k2:=0 to ntau-1 do
    begin
      i:=round(ker2[x1,y1,k1,x2,y2,k2]*length0);
      if i>0 then inc(flag[i-1]);
    end;

  fillchar(nb,sizeof(nb),0);
  for i:=0 to length0-1 do
    if flag[i]<=30 then inc(nb[flag[i]]);

  st:='';
  for i:=0 to 30 do st:=st+Istr(nb[i])+crlf;
  messageCentral(st);
  result:=0;
end;

type
  TKrecord=record
             code:integer;
             value:single;
           end;
  PKrecord=^TKrecord;

  TKrecord2=record
              index1,index2:integer;
              value:single;
            end;
  PKrecord2=^TKrecord2;

var
  Klist:TlistG;


function compareK(Item1, Item2: Pointer): Integer;
begin
  if PKrecord(item1)^.value<PKrecord(item2)^.value then result:=-1
  else
  if PKrecord(item1)^.value>PKrecord(item2)^.value then result:=1
  else result:=0;
end;

procedure Tmseq.BuildK1list(tmin,tmax:integer;var RA:TrealArray;seuil1,seuil2:float);
var
  i,k:integer;
  x,y,tau:integer;
  Nt:integer;
  w:TKrecord;

procedure decode(k:integer;var x,y,tau:integer);
begin
  x:=k mod Nx;
  k:=k div Nx;

  y:= k mod Ny;
  k:=k div Ny;

  tau:=k;
end;

begin
  Klist:=TlistG.create(sizeof(TKrecord));

  TRY
    Nt:=tmax-tmin+1;

    RA.modify(5,Nx*Ny*Nt);

    i:=0;
    for tau:=0 to nt-1 do
    for y:=0 to ny-1 do
    for x:=0 to nx-1 do
      begin
        w.value:=Kernel1[x,y,tmin+tau];
        if (w.value<=seuil1) or (w.value>=seuil2) then
          begin
            w.code:=i;
            Klist.add(@w);
          end;
        inc(i);
      end;

    Klist.sort(compareK);

    for i:=0 to nx*ny*nt-1 do
    begin
      k:=PKrecord(Klist[i]).code;
      decode(k,x,y,tau);
      RA.value[1,i+1]:=x+1;
      RA.value[2,i+1]:=y+1;
      RA.value[3,i+1]:=tau+tmin;
      RA.value[4,i+1]:=PKrecord(Klist[i]).value;
      RA.value[5,i+1]:=(length0+ pseq*(x+nX*y)- tau) mod length0;
    end;

  FINALLY
    Klist.free;
  END;
end;

procedure Tmseq.BuildK2list(tmin,tmax:integer;var RA:TrealArray;seuil1,seuil2:float);
var
  i,k:integer;
  x1,y1,t1,x2,y2,t2:integer;
  Nt:integer;
  w:TKrecord;
  w0:single;
  index1,index2:integer;

procedure decode(k:integer;var x1,y1,t1,x2,y2,t2:integer);
begin
  x1:=k mod Nx;
  k:=k div Nx;

  y1:=k mod Ny;
  k:=k div Ny;

  t1:=k mod Nt;
  k:=k div Nt;

  x2:=k mod Nx;
  k:=k div Nx;

  y2:=k mod Ny;
  k:=k div Ny;

  t2:=k;
end;

begin
  Klist:=TlistG.create(sizeof(TKrecord));

  TRY
    Nt:=tmax-tmin+1;

    RA.modify(8,Nx*Ny*Nt*Nx*Ny*Nt);

    i:=0;
    for t2:=0 to nt-1 do
    for y2:=0 to ny-1 do
    for x2:=0 to nx-1 do
    for t1:=0 to nt-1 do
    for y1:=0 to ny-1 do
    for x1:=0 to nx-1 do
      begin
        w.value:=Kernel2[x1,y1,tmin+t1,x2,y2,tmin+t2];
        if (w.value<=seuil1) or (w.value>=seuil2) then
          begin
            w.code:=i;
            Klist.add(@w);
          end;

        inc(i);
      end;

    Klist.sort(compareK);

    for i:=0 to Klist.count-1 do
    begin
      k:=PKrecord(Klist[i])^.code;
      decode(k,x1,y1,t1,x2,y2,t2);
      RA.value[1,i+1]:=x1+1;
      RA.value[2,i+1]:=y1+1;
      RA.value[3,i+1]:=t1+tmin;
      RA.value[4,i+1]:=x2+1;
      RA.value[5,i+1]:=y2+1;
      RA.value[6,i+1]:=t2+tmin;

      RA.value[7,i+1]:=PKrecord(Klist[i])^.value;

      index1:=pseq*(x1+nX*y1)-t1 ;
      index2:=pseq*(x2+nX*y2)-t2 ;
      RA.value[8,i+1]:=
        (index1+tabdec^[(index2-index1+length0) mod length0]+length0) mod length0;

    end;

  FINALLY
    Klist.free;
  END;
end;




procedure Tmseq.ReBuildData1(tmin,tmax:integer;var vec:Tvector;seuil1,seuil2:float);
var
  i,t:integer;
  x,y,tau:integer;
  Nt:integer;
  w:TKrecord;

  data:typedataB;
begin
  Klist:=TlistG.create(sizeof(TKrecord));

  TRY
    Nt:=tmax-tmin+1;

    vec.initTemp1(0,length0-1,g_single);

    for tau:=0 to nt-1 do
    for y:=0 to ny-1 do
    for x:=0 to nx-1 do
      begin
        w.value:=Kernel1[x,y,tmin+tau];
        if (w.value<=seuil1) or (w.value>=seuil2) then
          begin
            w.code:=(pseq*(x+nx*y)-tau +length0) mod length0;
            Klist.add(@w);
          end;
      end;

    data:=vec.data;

    for t:=0 to length0-1 do
    begin
      vec.Yvalue[t]:=0;
      for i:=0 to Klist.count-1 do
        with PKrecord(Klist[i])^ do
        data.addE(t,value*b^[(code+t) mod length0]);

    end;

  FINALLY
    Klist.free;
  END;
end;


procedure Tmseq.ReBuildData2(tmin,tmax:integer;var vec:Tvector;seuil1,seuil2:float);
var
  i,t:integer;
  x1,y1,t1,x2,y2,t2:integer;
  Nt:integer;
  w:TKrecord2;

  data:typedataB;
begin
  Klist:=TlistG.create(sizeof(TKrecord2));

  TRY
    Nt:=tmax-tmin+1;

    vec.initTemp1(0,length0-1,g_single);

    for t1:=0 to nt-1 do
    for y1:=0 to ny-1 do
    for x1:=0 to nx-1 do
    for t2:=0 to nt-1 do
    for y2:=0 to ny-1 do
    for x2:=0 to nx-1 do
      begin
        w.value:=Kernel2[x1,y1,tmin+t1,x2,y2,tmin+t2];
        if (w.value<=seuil1) or (w.value>=seuil2) then
          begin
            w.index1:=(pseq*(x1+nx*y1)-t1 +length0) mod length0;
            w.index2:=(pseq*(x2+nx*y2)-t2 +length0) mod length0;
            Klist.add(@w);
          end;
      end;

    data:=vec.data;

    for t:=0 to length0-1 do
    begin
      vec.Yvalue[t]:=0;
      for i:=0 to Klist.count-1 do
        with PKrecord2(Klist[i])^ do
        data.addE(t,value*b^[(index1+t) mod length0]*b^[(index2+t) mod length0]);

    end;

  FINALLY
    Klist.free;
  END;
end;

procedure Tmseq.Simulate(var RA:TrealArray;var vec:Tvector);
var
  i,t:integer;
  x1,y1,t1,x2,y2,t2:integer;
  w:TKrecord2;

  data:typedataB;
begin
  initParams;
  Klist:=TlistG.create(sizeof(TKrecord2));

  TRY
    vec.initTemp1(0,length0-1,g_single);

    for i:=1 to RA.nblig do
      begin
        w.value:=RA.value[7,i];
        if w.value<>0 then
          begin
            x1:=roundL(RA.value[1,i])-1;
            y1:=roundL(RA.value[2,i])-1;
            t1:=roundL(RA.value[3,i]);
            w.index1:=(pseq*(x1+nx*y1)-t1 +length0) mod length0;

            x2:=roundL(RA.value[4,i])-1;
            y2:=roundL(RA.value[5,i])-1;
            t2:=roundL(RA.value[6,i]);
            if x2<0
              then w.index2:=-1
              else w.index2:=(pseq*(x2+nx*y2)-t2 +length0) mod length0;

            Klist.add(@w);
          end;
      end;

    data:=vec.data;

    for t:=0 to length0-1 do
    begin
      vec.Yvalue[t]:=0;
      for i:=0 to Klist.count-1 do
        with PKrecord2(Klist[i])^ do
        if index2=-1
          then data.addE(t,value*b^[(index1+t) mod length0])
          else data.addE(t,value*b^[(index1+t) mod length0]*b^[(index2+t) mod length0]);
    end;

  FINALLY
    Klist.free;
  END;
end;



{*************************** Méthodes STM ************************************}

var
  E_order:integer;
  E_loadTbDiff:integer;
  E_SaveTbDiff:integer;
  E_shiftTable:integer;
  E_index:integer;

  E_data:integer;
  E_fmt:integer;
  E_XYpos:integer;

  E_ker1:integer;
  E_ker2:integer;

procedure proTmsequence_create(name:AnsiString;order:integer;var pu:typeUO);
begin
  createPgObject(name,pu,Tmseq);

  ControleParam(order,8,16,E_order);
  with Tmseq(pu) do
  begin
    ordre0:=order;
    valtap0:=defaultValtap(ordre0);
    calculMsequence;

    setChildNames;
  end;
end;

procedure proTmsequence_order(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tmseq(pu) do
  begin
    ordre0:=ww;
    valtap0:=defaultValtap(ordre0);
    calculMsequence;

    if assigned(fmt) then
      begin
        freemem(fmt);
        fmt:=nil;
      end;
    if assigned(tabdec) then
      begin
        freemem(tabdec);
        tabdec:=nil;
      end;

  end;
end;

function fonctionTmsequence_order(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  result:=ordre0;
end;

procedure proTmsequence_valtap(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  begin
    valtap0:=ww;
    calculMsequence;

    if assigned(fmt) then
      begin
        freemem(fmt);
        fmt:=nil;
      end;
    if assigned(tabdec) then
      begin
        freemem(tabdec);
        tabdec:=nil;
      end;
  end;
end;


function fonctionTmsequence_valtap(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  result:=valtap0;
end;

procedure proTmsequence_BuildShiftTable(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmseq(pu) do BuildTbDiff;
end;

procedure proTmsequence_LoadShiftTable(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  if not loadTbDiff(st) then sortieErreur(E_loadTbDiff);
end;

procedure proTmsequence_SaveShiftTable(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  if not saveTbDiff(st) then sortieErreur(E_saveTbDiff);
end;

function fonctionTmsequence_ShiftTable(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  begin
    if not assigned(tabDec) or (n<0) or (n>length0-1) then sortieErreur(E_ShiftTable);
    result:=tabDec^[n];
  end;
end;

function fonctionTmsequence_Bvalue(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  begin
    if not assigned(b) or (n<0) or (n>length0-1) then sortieErreur(E_Index);
    result:=b^[n];
  end;
end;

function fonctionTmsequence_MTvalue(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  begin
    if not assigned(mT) or (n<0) or (n>length0-1) then sortieErreur(E_Index);
    result:=mT^[n];
  end;
end;

function fonctionTmsequence_MGvalue(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  begin
    if not assigned(mG) or (n<0) or (n>length0-1) then sortieErreur(E_Index);
    result:=mG^[n];
  end;
end;


function fonctionTmsequence_length(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmseq(pu) do result:=length0;
end;

procedure proTmsequence_BuildFMT(var Vdata:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(Vdata));

  if not (Vdata.Istart=0) or
     not (Vdata.Iend>=Tmseq(pu).length0-1)
       then sortieErreur(E_data);


  with Tmseq(pu) do fmtS(Vdata);
end;

function fonctionTmsequence_FMTvalue(n:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  begin
    if not assigned(fmt) then sortieErreur(E_fmt);
    if (n<0) or (n>length0-1) then sortieErreur(E_Index);
    result:=fmt^[n];
  end;
end;


procedure proTmsequence_FirstOrder(var mat:Tmatrix;tau:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));

  if not assigned(Tmseq(pu).fmt) then sortieErreur(E_fmt);

  Tmseq(pu).firstOrder(mat,tau);
end;

procedure proTmsequence_SecondOrder(var mat:Tmatrix;x1,y1,t1,t2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));

  if not assigned(Tmseq(pu).fmt) then sortieErreur(E_fmt);
  if not assigned(Tmseq(pu).tabDec) then sortieErreur(E_shiftTable);

  Tmseq(pu).SecondOrder(mat,x1-1,y1-1,t1,t2);
end;

procedure proTmsequence_SecondOrder1(var mat:Tmatrix;tau1,dx,dy,dt:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));

  Tmseq(pu).SecondOrder1(mat,tau1,dx,dy,dt);
end;


function fonctionTmsequence_Kernel1(x,y,tau:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  begin
    if not assigned(fmt) then sortieErreur(E_fmt);
    if (x<1) or (x>nx) or
       (y<1) or (y>ny) then sortieErreur(E_XYpos);

    result:=kernel1[x-1,y-1,tau];
  end;
end;

procedure proTmsequence_Kernel1(x,y,t:integer;w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  begin
    if not assigned(ker1) then sortieErreur(E_ker1);
    if (x<1) or (x>nx) or
       (y<1) or (y>ny) or
       (t<tau1) or (t>tau2) then sortieErreur(E_XYpos);

    kernel1[x-1,y-1,t]:=w;
  end;
end;


function fonctionTmsequence_Kernel2(x1,y1,t1,x2,y2,t2:integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  begin
    if not assigned(fmt) then sortieErreur(E_fmt);
    if not assigned(tabdec) then sortieErreur(E_ShiftTable);

    if (x1<1) or (x1>nx) or
       (y1<1) or (y1>ny) or
       (x2<1) or (x2>nx) or
       (y2<1) or (y2>ny) then sortieErreur(E_XYpos);

    result:=kernel2[x1-1,y1-1,t1,x2-1,y2-1,t2];
  end;
end;

procedure proTmsequence_Kernel2(x1,y1,t1,x2,y2,t2:integer;w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmseq(pu) do
  begin
    if not assigned(ker2) then sortieErreur(E_ker2);

    if (x1<1) or (x1>nx) or
       (y1<1) or (y1>ny) or
       (x2<1) or (x2>nx) or
       (y2<1) or (y2>ny) or
       (t1<tau1) or (t1>tau2) or
       (t2<tau1) or (t2>tau2)
          then sortieErreur(E_XYpos);

    kernel2[x1-1,y1-1,t1,x2-1,y2-1,t2]:=w;
  end;
end;



procedure proTmsequence_BuildK1list(tmin,tmax:integer;var RA:TrealArray;
                                    seuil1,seuil2:float;
                                    var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(RA));
  with Tmseq(pu) do BuildK1list(tmin,tmax,RA,seuil1,seuil2);
end;

procedure proTmsequence_BuildK2list(tmin,tmax:integer;var RA:TrealArray;
                                    seuil1,seuil2:float;
                                    var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(RA));
  with Tmseq(pu) do BuildK2list(tmin,tmax,RA,seuil1,seuil2);
end;

procedure proTmsequence_ReBuildData1(tmin,tmax:integer;var vec:Tvector;
                                     seuil1,seuil2:float;
                                     var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));
  with Tmseq(pu) do reBuildData1(tmin,tmax,vec,seuil1,seuil2);
end;

procedure proTmsequence_ReBuildData2(tmin,tmax:integer;var vec:Tvector;
                                     seuil1,seuil2:float;
                                     var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));
  with Tmseq(pu) do reBuildData2(tmin,tmax,vec,seuil1,seuil2);
end;


procedure proTmsequence_Simulate(var RA:TrealArray;
                                  var vec:Tvector;
                                  var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));
  verifierObjet(typeUO(RA));

  with Tmseq(pu) do simulate(ra,vec);
end;

function fonctionTmsequence_VK1(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with Tmseq(pu) do result:=@VK1.myAd;
end;

function fonctionTmsequence_VK2(var pu:typeUO):Tvector;
begin
  verifierObjet(pu);
  with Tmseq(pu) do result:=@VK2.myAd;
end;

procedure proTmsequence_BuildK1(t1,t2:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tmseq(pu) do CalculK1(t1,t2);
end;

procedure proTmsequence_CorrectFMT(t1,t2:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tmseq(pu) do CorrectFMT(t1,t2);
end;


procedure proTmsequence_BuildK2(t1,t2:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tmseq(pu) do CalculK2(t1,t2);
end;

function fonctionTestMseqTap(ordre,Xtap:integer):boolean;
begin
  result:=TestTap(ordre,Xtap);
end;

function fonctionTmsequence_testK2(t1,t2:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);

  result:=Tmseq(pu).testK2(t1,t2);
end;

Initialization
AffDebug('Initialization Stmmseq0',0);

registerObject(Tmseq,stim);

installError(E_order,'TMsequence: order out of range');
installError(E_saveTbDiff,'TMsequence: unable to save ShifTable');
installError(E_loadTbDiff,'TMsequence: unable to load ShifTable');
installError(E_ShiftTable,'TMsequence: ShifTable error');
installError(E_index,'TMsequence: index out of range');

installError(E_ker1,'TMsequence: kernel1 not available ');
installError(E_ker2,'TMsequence: kernel2 not available ');

end.
