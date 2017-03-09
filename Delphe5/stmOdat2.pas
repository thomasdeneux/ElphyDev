unit stmOdat2;

{ Nouvelle version à partir du 15 mai 2014

  Les fichiers suivants sont impliqués:
  stmOdat2.pas
  stmAveA1.pas
  stmPstA1.pas
  stmCorA1.pas
  stmMatA1.pas

  Ces fichiers sont à récupérer dans delphe5.zip du 9 mai

  Le but est de rendre possible l'utilisation de tableaux avec un nombre de dimensions différent de 2


}

interface

uses windows,classes,menus,graphics,controls,
     math,
     util1,Dgraphic,Dtrace1,Ncdef2,debug0,varconf1,
     stmDef,stmObj,stmpopup,visu0,
     stmDobj1,stmvec1,stmMat1,
     iniarr0,dtf0,stmAve1,
     VAgetOpt1,editCont,
     stmError,stmPg;

type
  tabTvector=array[0..1] of TdataObj;
  PtabTvector=^tabTvector;

  TVectorArray=class(TdataObj)
           private
             Fdestroying: boolean;
           protected

             FnoDestroyVectors:boolean;
             uo:PtabTvector;                           // k=  i-imin à une dimension
                                                       // k=  nblig*(i-imin)+j-jmin  à deux dimensions
                                                       // pour garder la compatibilté avec la version précédente
             indmin,indmax: array[1..10] of integer;   // New on se limite à nbDim=10
             indminA,indmaxA: array[1..10] of integer; // uniquement pour loadFromStream
             nbDim:integer;                            // New

             pop:TpopupMenu;

             UObase:TUOclass;

             Fcompact: boolean;                        // Si compact, on ne sauve pas les vecteurs un par un

             procedure setXmin(x:double);override;
             procedure setXmax(x:double);override;
             procedure setYmin(x:double);override;
             procedure setYmax(x:double);override;
             procedure setZmin(x:double);override;
             procedure setZmax(x:double);override;

             procedure setUnitX(st:AnsiString);override;
             procedure setUnitY(st:AnsiString);override;

             procedure setcolorT(w:longint);override;
             procedure setmodeT(w:byte);override;
             procedure settailleT(w:byte);override;
             procedure setlargeurTrait(w:byte);override;
             procedure setstyleTrait(w:byte);override;
             procedure setmodeLogX(w:boolean);override;
             procedure setmodeLogY(w:boolean);override;
             procedure setgrille(w:boolean);override;
             procedure setcpX(w:smallint);override;
             procedure setcpY(w:smallint);override;
             procedure setcpZ(w:smallint);override;

             procedure setechX(w:boolean);override;
             procedure setechY(w:boolean);override;
             procedure setFtickX(w:boolean);override;
             procedure setFtickY(w:boolean);override;
             procedure setCompletX(w:boolean);override;
             procedure setcompletY(w:boolean);override;
             procedure setTickExtX(w:boolean);override;
             procedure setTickExtY(w:boolean);override;
             procedure setScaleColor(w:longint);override;

             procedure setinverseX(w:boolean);override;
             procedure setinverseY(w:boolean);override;

             procedure setDx(x:double);  override;
             procedure setX0(x:double);  override;
             procedure setDy(x:double);  override;
             procedure setY0(x:double);  override;
             procedure setDz(x:double);  override;
             procedure setZ0(x:double);  override;

             procedure setCpxMode(w:byte);override;

             procedure setIstart(w:integer);override;
             procedure setIend(w:integer);override;

             function PosToGrid(x,y:integer):Tpoint;

             function MouseDownMG(numOrdre:integer;Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X, Y: Integer):boolean;override;

             procedure reinit;virtual;

             function getVector(i,j:integer):Tvector;


             function CanCompact: boolean;virtual;
             procedure saveData(f:Tstream);override;
             function loadData(f:Tstream):boolean;override;

           public
             FnoClip:boolean;
             DxAff,DyAff:single;
             Mleft,Mtop,Mright,Mbottom:single;

             IdispMin,IdispMax,JdispMin,JdispMax:integer;
             DxInt,DyInt:single;
             onHint:Tpg2Event;

             JdispInvert: boolean;

             constructor create;override;
             class function STMClassName:AnsiString;override;
             procedure initChildList;override;

             procedure setChildNames;override;

             procedure freeVectors;
             destructor destroy;override;

             procedure initArray0(ind1,ind2: TarrayOfInteger);
             procedure initArray(i1,i2,j1,j2:integer);virtual;

             procedure InitArray1( i1,i2: integer);virtual;

             procedure initVectors(n1,n2:longint;tNombre:typeTypeG);
             procedure initVectorEx(i,j:integer;p:typedataB;tNombre:typeTypeG);
             procedure setVectorEx(k:integer;vec:Tvector);

             function nbObj:integer;
             function imin: integer;
             function imax: integer;
             function jmin: integer;
             function jmax: integer;
             function nblig: integer;
             function nbCol: integer;
             function Dim(i:integer): integer;
             function BuildIdent(k:integer):string;virtual;



             function initOK:boolean;

             procedure updateVectorParams;virtual;
             procedure clear;override;
             procedure invalidate;override;


             function ChooseCoo1:boolean;override;


             procedure AutoScaleX;      override;
             procedure AutoScaleY;      override;
             procedure AutoScaleY1;      override;
             procedure cadrerX(sender:Tobject);override;
             procedure cadrerY(sender:Tobject);override;

             property Vector[i,j:integer]:Tvector read getvector;default;

             function buildMap(var m:Tmatrix;x1,x2:float;mode:integer):boolean;
             function buildZscoreMap(var m:Tmatrix;x1,x2:float;mode:integer):boolean;

             function initialise(st:AnsiString):boolean;override;

             procedure display;override;
             function getInsideWindow:Trect;override;

             procedure proprietes(sender:Tobject);override;
             procedure Options(sender:Tobject);
             function getPopUp:TpopupMenu;override;

             procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
             procedure completeLoadInfo;override;
             procedure saveToStream( f:Tstream;Fdata:boolean);override;
             function  loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;

             procedure initDisp;

             function BuildIntMaps(mat1,mat2:Tmatrix;tau1,tau2,seuilP,seuilM:float;Norm:boolean):boolean;
             function BuildZscoreIntMaps(mat1,mat2:Tmatrix;tau1,tau2,seuilP,seuilM:float):boolean;

             procedure IntMapStats(VMean1,Vmean2,VStd1,Vstd2:Tvector;seuilP,seuilM,tMax,dtau:float;Norm:boolean);
             procedure MeanStdDev(x1,x2:float;var vm,vstd:float);

             procedure OptStats(x1,x2,dxm:float;var VMean,VStd:float);
             procedure OptMatrix(x1,x2,dxm:float; Vmean,Vstd: float; Mopt,Mlat: Tmatrix);
             procedure Threshold(th:float;Fup,Fdw:boolean);

             function BuildXTMap(var m: Tmatrix;x1,x2,dtau,dxt:float;mode:integer;
                                 FY,FZscore:boolean;
                                 Xref:float;FrefSym:boolean;Zth:float;mode1:integer;AgTh:integer ):boolean;
             function BuildXTMap1(var m: Tmatrix;x1,x2,dtau,dxt:float;mode:integer;FY,FZscore,FrefSym:boolean;
                                 Zth:float;vecM,vecStd:Tvector;mode1:integer;AgTh:integer):boolean;

             function BuildXTIntMaps(mat1,mat2:Tmatrix;x1,x2,dtau,dxt,seuilP,seuilM:float;
                                 FY,FZscore:boolean;
                                 Xref:float;FrefSym:boolean;Zth:float;mode:integer;AgTh:integer ):boolean;
             function BuildXTIntMaps1(mat1,mat2:Tmatrix;x1,x2,dtau,dxt,seuilP,seuilM:float;
                                 FY,FZscore,FrefSym:boolean;Zth:float;vecM,vecStd:Tvector;mode:integer;
                                 AgTh:integer ):boolean;

             procedure autoscaleI;
             procedure autoscaleJ;

             procedure MedianVector(vec: Tvector);
             procedure subVector(vec:Tvector);
             procedure AddNum(num:TfloatComp);

           end;



procedure proTplotArray_Overlap(x:boolean;var pu:typeUO);pascal;
function fonctionTplotArray_Overlap(var pu:typeUO):boolean;pascal;

procedure proTplotArray_dxWF(x:float;var pu:typeUO);pascal;
function fonctionTplotArray_dxWF(var pu:typeUO):float;pascal;

procedure proTplotArray_dyWF(x:float;var pu:typeUO);pascal;
function fonctionTplotArray_dyWF(var pu:typeUO):float;pascal;

procedure proTplotArray_Mleft(x:float;var pu:typeUO);pascal;
function fonctionTplotArray_Mleft(var pu:typeUO):float;pascal;

procedure proTplotArray_Mtop(x:float;var pu:typeUO);pascal;
function fonctionTplotArray_Mtop(var pu:typeUO):float;pascal;

procedure proTplotArray_Mright(x:float;var pu:typeUO);pascal;
function fonctionTplotArray_Mright(var pu:typeUO):float;pascal;

procedure proTplotArray_Mbottom(x:float;var pu:typeUO);pascal;
function fonctionTplotArray_Mbottom(var pu:typeUO):float;pascal;

function fonctionTplotArray_Imin(var pu:typeUO):integer;pascal;
function fonctionTplotArray_Imax(var pu:typeUO):integer;pascal;
function fonctionTplotArray_Jmin(var pu:typeUO):integer;pascal;
function fonctionTplotArray_Jmax(var pu:typeUO):integer;pascal;

procedure proTplotArray_dxInt(x:float;var pu:typeUO);pascal;
function fonctionTplotArray_dxInt(var pu:typeUO):float;pascal;

procedure proTplotArray_dyInt(x:float;var pu:typeUO);pascal;
function fonctionTplotArray_dyInt(var pu:typeUO):float;pascal;

procedure proTplotArray_Idispmin(x:integer;var pu:typeUO);pascal;
function fonctionTplotArray_Idispmin(var pu:typeUO):integer;pascal;

procedure proTplotArray_Idispmax(x:integer;var pu:typeUO);pascal;
function fonctionTplotArray_Idispmax(var pu:typeUO):integer;pascal;

procedure proTplotArray_Jdispmin(x:integer;var pu:typeUO);pascal;
function fonctionTplotArray_Jdispmin(var pu:typeUO):integer;pascal;

procedure proTplotArray_JdispInvert(x:boolean;var pu:typeUO);pascal;
function fonctionTplotArray_JdispInvert(var pu:typeUO):boolean;pascal;


procedure proTplotArray_Jdispmax(x:integer;var pu:typeUO);pascal;
function fonctionTplotArray_Jdispmax(var pu:typeUO):integer;pascal;

procedure proTplotArray_setGrid(x1,y1,x2,y2:integer;var pu:typeUO);pascal;
procedure proTplotArray_autoscaleI(var pu:typeUO);pascal;
procedure proTplotArray_autoscaleJ(var pu:typeUO);pascal;

{ Ces quatre procedures STM doivent être réécrites pour les descendants }
procedure proTvectorArray_create(name:AnsiString;i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTvectorArray_create_1(i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTvectorArray_create_2(i1,i2:integer;var pu:typeUO);pascal;



procedure proTVectorArray_modify(i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTVectorArray_modify_1(i1,i2:integer;var pu:typeUO);pascal;

procedure proTVectorArray_initObjects(tn:integer;n1,n2:longint;var pu:typeUO);pascal;
function fonctionTvectorArray_V(i,j:integer;var pu:typeUO):pointer;pascal;
function fonctionTvectorArray_V_1(i:integer;var pu:typeUO):pointer;pascal;

procedure proTvectorArray_BuildMap(var m:Tmatrix;x1,x2:float;mode:integer;var pu:typeUO);pascal;
procedure proTvectorArray_BuildZscoreMap(var m:Tmatrix;x1,x2:float;mode:integer;var pu:typeUO);pascal;
procedure proTvectorArray_BuildIntMaps(var mat1,mat2:Tmatrix;tau1,tau2,seuilP,seuilM:float;
                                        Norm:boolean;var pu:typeUO);pascal;
procedure proTvectorArray_BuildZscoreIntMaps(var mat1,mat2:Tmatrix;tau1,tau2,seuilP,seuilM:float;
                                         var pu:typeUO);pascal;

procedure proTvectorArray_MeanStdDev(x1, x2: float; var vm, vstd: float;var pu:typeUO);pascal;
procedure proTvectorArray_IntMapStats(var VMean1,Vmean2,VStd1,Vstd2:Tvector;
                                       seuilP,seuilM,tMax,dtau:float;Norm:boolean;var pu:typeUO);pascal;

procedure proTvectorArray_OptStats(x1,x2,dxm:float;var VMean,VStd:float;var pu:typeUO);pascal;
procedure proTvectorArray_OptMatrix(x1,x2,dxm:float;Vmean,Vstd: float;var Mopt,Mlat: Tmatrix;
                                     var pu:typeUO);pascal;

procedure proTvectorArray_Threshold(th:float;Fup,Fdw:boolean;var pu:typeUO);pascal;

procedure proTvectorArray_BuildXTMap(var m: Tmatrix;x1,x2,dtau,dxt:float;mode:integer;
                        FY,FZscore:boolean;
                        Xref:float;FrefSym:boolean;
                        Zth:float;mode1:integer;AgTh:integer;
                        var pu:typeUO);pascal;
procedure proTvectorArray_BuildXTMap1(var m: Tmatrix;x1,x2,dtau,dxt:float;mode:integer;
                        FY,FZscore,FrefSym:boolean;
                        Zth:float;var vecM,vecStd:Tvector;mode1:integer;
                        AgTh:integer;var pu:typeUO);pascal;



procedure proTvectorArray_BuildXTIntMaps(var mat1,mat2:Tmatrix;x1,x2,dtau,dxt,seuilP,seuilM:float;
                                 FY,FZscore:boolean;
                                 Xref:float;FrefSym:boolean;Zth:float;mode:integer;
                                 AgTh:integer;var pu:typeUO);pascal;
procedure proTvectorArray_BuildXTIntMaps1(var mat1,mat2:Tmatrix;x1,x2,dtau,dxt,seuilP,seuilM:float;
                                 FY,FZscore,FrefSym:boolean;
                                 Zth:float;var vecM,vecStd:Tvector;mode:integer;
                                 AgTh:integer;var pu:typeUO);pascal;


procedure proTVectorArray_MedianVector(var vec: Tvector;var pu:typeUO);pascal;
procedure proTvectorArray_SubVector(var vec:Tvector;var pu:typeUO);pascal;
procedure proTvectorArray_AddNum(num:TfloatComp;var pu:typeUO);pascal;

procedure proTvectorArray_OnHint(p:integer;var pu:typeUO);pascal;
function fonctionTvectorArray_OnHint(var pu:typeUO):integer;pascal;

procedure proTvectorArray_CpxMode(x:integer;var pu:typeUO);pascal;
function fonctionTvectorArray_CpxMode(var pu:typeUO):integer;pascal;

procedure proVAadd(var src1,src2,dest:TvectorArray);pascal;
procedure proVAsub(var src1,src2,dest:TvectorArray);pascal;
procedure proVAmul(var src1,src2,dest:TvectorArray);pascal;
procedure proVAdiv(var src1,src2,dest:TvectorArray);pascal;

procedure proVAmulNum(var src: TvectorArray; num:TfloatComp);pascal;
procedure proVAaddNum(var src: TvectorArray; num:TfloatComp);pascal;


implementation

uses stmVecU1;

constructor TvectorArray.create;
begin
  inherited;

  UObase:=Tvector;

  echX:=false;
  echY:=false;
  FtickX:=false;
  FtickY:=false;
  completX:=false;
  completY:=false;


end;


class function TvectorArray.STMClassName:AnsiString;
begin
  STMClassName:='VectorArray';
end;

procedure TVectorArray.freeVectors;
var
  i:integer;
begin
  Fdestroying:=true;  // bloque setCpx et setCpy

  if uo<>nil then
    begin
      if not FnoDestroyVectors then
        for i:=0 to nbobj-1 do
          uo^[i].free;

      freemem(uo);
      uo:=nil;
    end;

  fillchar(indmin,sizeof(indmin),0);
  fillchar(indmax,sizeof(indmax),0);

  nbDim:=0;

  initChildList;
  Fdestroying:=false;
end;

destructor TVectorArray.destroy;
begin
  freeVectors;
  pop.free;
  inherited destroy;
end;

procedure TVectorArray.initArray0(ind1, ind2: TarrayOfInteger);
var
  taille:longint;
  i:integer;
begin
  freeVectors;

  nbDim:=length(ind1);
  for i:=1 to nbdim do
  begin
    indmin[i]:=ind1[i-1];
    indmax[i]:=ind2[i-1];
  end;

  inherited initTemp0(tpNum,0,true);

  taille:= nbobj*sizeof(pointer);
  if (taille<maxavail) then
  begin
    getmem(uo,taille);
    fillchar(uo^,taille,0);

    if (IdispMin=0) and (IdispMax=0) and (JdispMin=0) and (JdispMax=0)
      then initDisp;
  end;
end;



procedure TVectorArray.initArray(i1,i2,j1,j2:integer);
var
  ind1, ind2: TarrayOfInteger;

begin
  setlength(ind1,2);
  setlength(ind2,2);

  ind1[0]:=i1;
  ind1[1]:=j1;
  ind2[0]:=i2;
  ind2[1]:=j2;

  initArray0(ind1, ind2);
end;

procedure TVectorArray.InitArray1(i1, i2: integer);
var
  ind1, ind2: TarrayOfInteger;

begin
  setlength(ind1,1);
  setlength(ind2,1);

  ind1[0]:=i1;
  ind2[0]:=i2;

  initArray0(ind1, ind2);
end;


procedure TvectorArray.initDisp;
begin
  IdispMin:=imin;
  IdispMax:=imax;
  if JdispInvert then
  begin
    JdispMin:=jmax;
    JdispMax:=jmin;
  end
  else
  begin
    JdispMin:=jmin;
    JdispMax:=jmax;
  end
end;


function TVectorArray.getvector(i,j:integer):Tvector;
begin
  if nbdim=2 then
  begin
    if (i>=imin) and (i<=imax) and (j>=jmin) and (j<=jmax) and assigned(uo)
     then result:=Tvector(uo^[nblig*(i-imin)+j-jmin])
     else result:=nil;
  end
  else result:=nil;
end;

function TvectorArray.BuildIdent(k:integer): string;  // k commence à zéro
var
  i,j:integer;
begin
  result:=']';
  for i:= nbdim downto 2 do
  begin
    j:= k mod dim(i);
    k:= k div dim(i);
    result:= ','+Istr( indmin[i]+j)+result;
  end;

  result:=   ident+'.v['+Istr(indmin[1]+k)+ result;
end;

procedure TVectorArray.initVectors(n1,n2:longint;tNombre:typeTypeG);
var
  i,j,k:integer;
begin
  inf.Imin:=n1;
  inf.Imax:=n2;
  inf.tpNum:=tNombre;

  for k:=0 to nbobj-1 do
  begin
    if not FnoDestroyVectors then uo^[k].free;

    uo^[k]:=Tvector.create;
    Tvector(uo^[k]).initTemp1(n1,n2,tnombre);
    uo^[k].Fchild:=true;

    uo^[k].ident:= BuildIdent(k);
  end;

  initChildList;
  updateVectorParams;
end;

procedure TVectorArray.setChildNames;
var
  i,j,k:integer;
begin

  if initOK then
  for k:=0 to nbobj-1 do
    begin
      uo^[k].ident:= BuildIdent(k);
      uo^[k].setChildNames;
    end;
end;


procedure TVectorArray.initChildList;
var
  i,j,k:integer;
begin
  ClearChildList;
  if initOK then
  for k:= 0 to nbobj-1 do AddTochildList(uo^[k]);
end;


procedure TVectorArray.initVectorEx(i,j:integer;p:typedataB;tNombre:typeTypeG);
var
  k:integer;
begin
  if nbdim=2 then
  begin
    inf.Imin:=p.indicemin;
    inf.Imax:=p.indicemax;

    k:=nblig*(i-imin)+j-jmin;
    if not FnoDestroyVectors then uo^[k].free;

    uo^[k]:=Tvector.create;
    Tvector(uo^[k]).initDat1ex(p,tnombre);

    uo^[k].Fchild:=true;
    uo^[k].ident:=ident+'.v['+Istr(i)+','+Istr(j)+']';

    uo^[k].visu.assign(visu);
  end;
end;

procedure TVectorArray.setVectorEx(k:integer;vec:Tvector);
begin
  if nbDim=2 then
  begin
    inf.Imin:=vec.Istart;
    inf.Imax:=vec.Iend;
    inf.tpNum:=vec.tpNum;

    if not FnoDestroyVectors then uo^[k].free;

    uo^[k]:=vec;
    FnoDestroyVectors:=true;

    uo^[k].visu.assign(visu);
  end;
end;


function TVectorArray.initOK:boolean;
begin
  initOK:=assigned(uo) and (nbobj>0) and assigned(uo^[0]) and not Fdestroying;
end;


procedure TvectorArray.display;
var
  i,j:integer;
  x1,y1,x2,y2:integer;
  dxf,dyf:float;
  vv:Tvector;
  ddL,ddR,ddT,ddB:integer;
  xx,yy:float;
  dxA,dyA:float;
  xx0,yy0:float;

  Mtop1,Mleft1,Mright1,Mbottom1:float;
  nbc,nbl:integer;
  Ltot,Htot:float;
  incDx,incDy:float;
  DxIntA,DyIntA:float;
  Ivec,Jvec:integer;
begin
  if nbdim<>2 then exit;
  if not initOK then exit;

  //if (Idispmax=IdispMin) or (Jdispmax=JdispMin) then exit;
  dxA:=dxAff/100;
  dyA:=dyAff/100;

  nbc:=abs(Idispmax-IdispMin)+1;
  nbl:=abs(Jdispmax-JdispMin)+1;

  getWindowG(x1,y1,x2,y2);

  Mtop1:=(y2-y1+1)*Mtop/100;
  Mleft1:=(x2-x1+1)*Mleft/100;
  Mbottom1:=(y2-y1+1)*Mbottom/100;
  Mright1:=(x2-x1+1)*Mright/100;

  Ltot:=x2-x1+1-Mleft1-Mright1;
  Htot:=y2-y1+1-Mtop1-Mbottom1;
  dxf:=Ltot*(1-abs(dxA)) / nbc;
  dyf:=Htot*(1-abs(dyA)) / nbl;

  IncDx:=Ltot*dxA/nbl;
  IncDy:=Htot*dyA/nbc;

  DxIntA:=dxf*DxInt/100;
  DyIntA:=dyf*DyInt/100;

  if dxA>=0 then xx0:=0 else xx0:=-Ltot*dxA;
  if dyA>=0 then yy0:=0 else yy0:=-Htot*dyA;

  if echX then
    begin
      ddT:=0;
      ddB:=0
    end
  else
    begin
      ddT:=-DispVec_top+1;
      ddB:=-DispVec_bottom+1;
    end;

  if echY then
    begin
      ddL:=0;
      ddR:=0
    end
  else
    begin
      ddL:=-DispVec_Left+1;
      ddR:=-DispVec_Right+1;
    end;


  if FnoClip then setClipRegion(x1,y1,x2,y2);

  for i:=0 to nbc-1 do
  begin
    for j:=0 to nbl-1 do
      begin
        xx:=xx0+x1+dxf*i+(j+0.5)*incDx +Mleft1;
        yy:=yy0+y1+dyf*j+(i+0.5)*incDy +Mtop1;
        setWindow(round(xx+dxIntA)+ddL,round(yy+DyIntA)+ddT,
                  round(xx+dxf-DxIntA)-1-ddR,round(yy+dyf-DyIntA-1-ddB) );

        if IDispMin<IdispMax then Ivec:= IdispMin+i else Ivec:=IdispMin-i;
        if JDispMin<JdispMax then Jvec:= JdispMin+j else Jvec:=JdispMin-j;

        vv:=vector[Ivec,Jvec];
        if assigned(vv) then vv.display;
        if testEscape then break;
      end;
    if testEscape then break;
  end;

  resetClipRegion;
end;

function TvectorArray.ChooseCoo1:boolean;
begin
  result:=inherited chooseCoo1;
  if result then updateVectorParams;
end;


procedure TvectorArray.updateVectorParams;
var
  i:integer;
  dum:Tfont;
begin
  if not initOK then exit;

  { On copie Visu dans tous les vecteurs.
    On traite soigneusement l'objet font de visu}

  for i:=0 to nbobj-1 do
    begin
      uo^[i].visu.assign(visu);

      uo^[i].CpxMode:=cpxMode;

      uo^[i].Dxu:=dxu;
      uo^[i].x0u:=x0u;
      uo^[i].Dyu:=dyu;
      uo^[i].y0u:=y0u;
    end;
end;

procedure TvectorArray.clear;
var
  i:integer;
begin
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].clear;
end;

procedure TvectorArray.invalidate;
var
  i:integer;
begin
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].invalidate;
  inherited;
end;


procedure TvectorArray.setDx(x:double);
var
  i:integer;
begin
  inherited setDx(x);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Dxu:=x;
end;

procedure TvectorArray.setX0(x:double);
var
  i:integer;
begin
  inherited setx0(x);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].x0u:=x;
end;

procedure TvectorArray.setDy(x:double);
var
  i:integer;
begin
  inherited setDy(x);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Dyu:=x;
end;

procedure TvectorArray.setY0(x:double);
var
  i:integer;
begin
  inherited setY0(x);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Y0u:=x;
end;

procedure TvectorArray.setDz(x:double);
var
  i:integer;
begin
  inherited setDz(x);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Dzu:=x;
end;

procedure TvectorArray.setZ0(x:double);
var
  i:integer;
begin
  inherited setz0(x);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].z0u:=x;
end;

procedure TvectorArray.setCpxMode(w:byte);
var
  i:integer;
begin
  inherited setCpxMode(w);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].CpxMode:=w;
end;

procedure TVectorArray.setIend(w: integer);
var
  i:integer;
begin
  inherited;
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Iend:=w;
end;

procedure TVectorArray.setIstart(w: integer);
var
  i:integer;
begin
  inherited;
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Istart:=w;
end;


procedure TvectorArray.AutoScaleX;
var
  i:integer;
  x1,x2:float;
begin
  if not initOK then exit;

  x1:=1E20;
  x2:=-1E20;

  for i:=0 to nbObj-1 do
    begin
      if uo^[i].Xstart<x1
        then x1:=uo^[i].Xstart;
      if uo^[i].Xend>x2
        then x2:=uo^[i].Xend;
    end;

  if x2>=x1 then
  begin
    visu.Xmin:=x1;
    visu.Xmax:=x2;
  end;

  for i:=0 to nbObj-1 do
    begin
      uo^[i].Xmin:=Xmin;
      uo^[i].Xmax:=Xmax;
    end;

end;

procedure TvectorArray.AutoScaleY;
var
  i:integer;
begin
  if not initOK then exit;

  visu.Ymax:=-1E20;
  visu.Ymin:=1E20;
  for i:=0 to nbObj-1 do
    begin
      uo^[i].autoscaleY;
      if uo^[i].visu.Ymin<visu.Ymin
        then visu.Ymin:=uo^[i].visu.Ymin;
      if uo^[i].visu.Ymax>visu.Ymax
        then visu.Ymax:=uo^[i].visu.Ymax;
    end;

  for i:=0 to nbObj-1 do
    begin
      uo^[i].Ymin:=Ymin;
      uo^[i].Ymax:=Ymax;
    end;
end;

procedure TvectorArray.AutoScaleY1;
var
  i:integer;
begin
  if not initOK then exit;

  visu.Ymax:=-1E20;
  visu.Ymin:=1E20;
  for i:=0 to nbObj-1 do
    begin
      uo^[i].autoscaleY1;
      if uo^[i].visu.Ymin<visu.Ymin
        then visu.Ymin:=uo^[i].visu.Ymin;
      if uo^[i].visu.Ymax>visu.Ymax
        then visu.Ymax:=uo^[i].visu.Ymax;
    end;

  for i:=0 to nbObj-1 do
    begin
      uo^[i].Ymin:=Ymin;
      uo^[i].Ymax:=Ymax;
    end;
end;

procedure TVectorArray.cadrerX(sender:Tobject);
var
  i:integer;
  x1,x2:float;

begin
  x1:=1E20;
  x2:=-1E20;

  for i:=0 to nbObj-1 do
    begin
      if uo^[i].Xstart<x1
        then x1:=uo^[i].Xstart;
      if uo^[i].Xend>x2
        then x2:=uo^[i].Xend;
    end;

  if x2>=x1 then
  begin
    visu0^.Xmin:=x1;
    visu0^.Xmax:=x2;
  end;
end;


procedure TvectorArray.cadrerY(sender:Tobject);
var
  i:integer;
begin
  if not initOK then exit;

  visu0^.Ymax:=-1E20;
  visu0^.Ymin:=1E20;
  for i:=0 to nbObj-1 do
    begin
      uo^[i].autoscaleY;
      if uo^[i].visu.Ymin<visu0^.Ymin
        then visu0^.Ymin:=uo^[i].visu.Ymin;
      if uo^[i].visu.Ymax>visu0^.Ymax
        then visu0^.Ymax:=uo^[i].visu.Ymax;
    end;
end;

procedure TvectorArray.setXmax(x:double);
var
  i:integer;
begin
  inherited setXmax(x);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Xmax:=x;
end;

procedure TvectorArray.setXmin(x:double);
var
  i:integer;
begin
  inherited setXmin(x);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Xmin:=x;
end;

procedure TvectorArray.setYmax(x:double);
var
  i:integer;
begin
  inherited setYmax(x);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Ymax:=x;
end;

procedure TvectorArray.setYmin(x:double);
var
  i:integer;
begin
  inherited setYmin(x);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Ymin:=x;
end;

procedure TvectorArray.setZmax(x:double);
var
  i:integer;
begin
  inherited setZmax(x);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Zmax:=x;
end;

procedure TvectorArray.setZmin(x:double);
var
  i:integer;
begin
  inherited setZmin(x);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Zmin:=x;
end;


procedure TvectorArray.setUnitX(st:AnsiString);
var
  i:integer;
begin
  inherited setUnitX(st);

  if initOK then
      for i:=0 to nbObj-1 do uo^[i].UnitX:=st;
end;

procedure TvectorArray.setUnitY(st:AnsiString);
var
  i:integer;
begin
  inherited setUnitY(st);

  if initOK then
      for i:=0 to nbObj-1 do uo^[i].UnitY:=st;
end;


procedure TvectorArray.setcolorT(w:longint);
var
  i:integer;
begin
  inherited setColorT(w);

  if initOK then
      for i:=0 to nbObj-1 do uo^[i].colorT:=w;
end;


procedure TvectorArray.setmodeT(w:byte);
var
  i:integer;
begin
  inherited setmodeT(w);

  if initOK then
      for i:=0 to nbObj-1 do uo^[i].modeT:=w;
end;

procedure TvectorArray.settailleT(w:byte);
var
  i:integer;
begin
  inherited setTailleT(w);

  if initOK then
      for i:=0 to nbObj-1 do uo^[i].tailleT:=w;
end;

procedure TvectorArray.setlargeurTrait(w:byte);
var
  i:integer;
begin
  inherited setLargeurTrait(w);

  if initOK then
      for i:=0 to nbObj-1 do uo^[i].largeurTrait:=w;
end;

procedure TvectorArray.setstyleTrait(w:byte);
var
  i:integer;
begin
  inherited setStyleTrait(w);

  if initOK then
      for i:=0 to nbObj-1 do uo^[i].styleTrait:=w;
end;

procedure TvectorArray.setmodeLogX(w:boolean);
var
  i:integer;
begin
  inherited setModeLogX(w);

  if initOK then
      for i:=0 to nbObj-1 do uo^[i].modeLogX:=w;
end;

procedure TvectorArray.setmodeLogY(w:boolean);
var
  i:integer;
begin
  inherited setModeLogY(w);

  if initOK then
      for i:=0 to nbObj-1 do uo^[i].modeLogY:=w;
end;

procedure TvectorArray.setgrille(w:boolean);
var
  i:integer;
begin
  inherited setGrille(w);

  if initOK then
      for i:=0 to nbObj-1 do uo^[i].Grille:=w;
end;

procedure TvectorArray.setcpX(w:smallint);
var
  i:integer;
begin
  inherited setCpx(w);

  if initOK then
      for i:=0 to nbObj-1 do uo^[i].Cpx:=w;
end;

procedure TvectorArray.setcpY(w:smallint);
var
  i:integer;
begin
  inherited setCpy(w);

  if initOK then
      for i:=0 to nbObj-1 do uo^[i].Cpy:=w;
end;

procedure TvectorArray.setcpZ(w:smallint);
var
  i:integer;
begin
  inherited setCpz(w);
  if initOK then
    for i:=0 to nbObj-1 do uo^[i].Cpz:=w;
end;


procedure TvectorArray.setechX(w:boolean);
var
  i:integer;
begin
  inherited setEchX(w);

  if initOK then
    for i:=0 to nbObj-1 do uo^[i].EchX:=w;
end;

procedure TvectorArray.setechY(w:boolean);
var
  i:integer;
begin
  inherited setEchY(w);

  if initOK then
    for i:=0 to nbObj-1 do uo^[i].EchY:=w;
end;

procedure TvectorArray.setFtickX(w:boolean);
var
  i:integer;
begin
  inherited setFtickX(w);

  if initOK then
    for i:=0 to nbObj-1 do uo^[i].FtickX:=w;
end;

procedure TvectorArray.setFtickY(w:boolean);
var
  i:integer;
begin
  inherited setFtickY(w);

  if initOK then
    for i:=0 to nbObj-1 do uo^[i].FtickY:=w;
end;

procedure TvectorArray.setCompletX(w:boolean);
var
  i:integer;
begin
  inherited setCompletX(w);

  if initOK then
    for i:=0 to nbObj-1 do uo^[i].CompletX:=w;
end;

procedure TvectorArray.setcompletY(w:boolean);
var
  i:integer;
begin
  inherited setCompletY(w);

  if initOK then
    for i:=0 to nbObj-1 do uo^[i].CompletY:=w;
end;

procedure TvectorArray.setTickExtX(w:boolean);
var
  i:integer;
begin
  inherited setTickExtX(w);

  if initOK then
    for i:=0 to nbObj-1 do uo^[i].TickExtX:=w;
end;

procedure TvectorArray.setTickExtY(w:boolean);
var
  i:integer;
begin
  inherited setTickExtY(w);

  if initOK then
    for i:=0 to nbObj-1 do uo^[i].TickExtY:=w;
end;

procedure TvectorArray.setScaleColor(w:longint);
var
  i:integer;
begin
  inherited setScaleColor(w);

  if initOK then
    for i:=0 to nbObj-1 do uo^[i].ScaleColor:=w;
end;


procedure TvectorArray.setinverseX(w:boolean);
var
  i:integer;
begin
  inherited setInverseX(w);

  if initOK then
    for i:=0 to nbObj-1 do uo^[i].InverseX:=w;
end;

procedure TvectorArray.setinverseY(w:boolean);
var
  i:integer;
begin
  inherited setInverseY(w);

  if initOK then
    for i:=0 to nbObj-1 do uo^[i].InverseY:=w;
end;




function TvectorArray.initialise(st:AnsiString):boolean;
var
  i1,i2,j1,j2:longint;
  n1,n2:longint;
  tnombre:typetypeG;
begin
  {inherited initialise(st);}
  i1:=1;
  i2:=10;
  j1:=1;
  j2:=10;
  n1:=0;
  n2:=99;
  tNombre:=G_smallint;

  if initTvectorArray.execution(st,i1,i2,j1,j2,n1,n2  ,tNombre) then
    begin
      initArray(i1,i2,j1,j2);
      initVectors(n1,n2,tNombre);
      ident:=st;
      initialise:=true;
    end
  else initialise:=false;
end;

function TVectorArray.PosToGrid(x, y: integer): Tpoint;
var
  i,j:integer;
  x1,y1,x2,y2:integer;
  dxf,dyf:float;
  vv:Tvector;
  ddL,ddR,ddT,ddB:integer;
  xx,yy:float;
  dxA,dyA:float;
  xx0,yy0:float;

  Mtop1,Mleft1,Mright1,Mbottom1:float;
  nbc,nbl:integer;
  Ltot,Htot:float;
  incDx,incDy:float;
  DxIntA,DyIntA:float;
  Ivec,Jvec:integer;

  rect1: Trect;
  pt: Tpoint;
begin
  if (Idispmax=IdispMin) or (Jdispmax=JdispMin) then exit;

  pt:=point(x,y);

  dxA:=dxAff/100;
  dyA:=dyAff/100;

  nbc:=abs(Idispmax-IdispMin)+1;
  nbl:=abs(Jdispmax-JdispMin)+1;

  getWindowG(x1,y1,x2,y2);

  Mtop1:=(y2-y1+1)*Mtop/100;
  Mleft1:=(x2-x1+1)*Mleft/100;
  Mbottom1:=(y2-y1+1)*Mbottom/100;
  Mright1:=(x2-x1+1)*Mright/100;

  Ltot:=x2-x1+1-Mleft1-Mright1;
  Htot:=y2-y1+1-Mtop1-Mbottom1;
  dxf:=Ltot*(1-abs(dxA)) / nbc;
  dyf:=Htot*(1-abs(dyA)) / nbl;

  IncDx:=Ltot*dxA/nbl;
  IncDy:=Htot*dyA/nbc;

  DxIntA:=dxf*DxInt/100;
  DyIntA:=dyf*DyInt/100;

  if dxA>=0 then xx0:=0 else xx0:=-Ltot*dxA;
  if dyA>=0 then yy0:=0 else yy0:=-Htot*dyA;

  if echX then
    begin
      ddT:=0;
      ddB:=0
    end
  else
    begin
      ddT:=-DispVec_top+1;
      ddB:=-DispVec_bottom+1;
    end;

  if echY then
    begin
      ddL:=0;
      ddR:=0
    end
  else
    begin
      ddL:=-DispVec_Left+1;
      ddR:=-DispVec_Right+1;
    end;


  for i:=0 to nbc-1 do
  for j:=0 to nbl-1 do
    begin
      xx:=xx0+dxf*i+(j+0.5)*incDx +Mleft1;
      yy:=yy0+dyf*j+(i+0.5)*incDy +Mtop1;
      rect1:= rect(round(xx+dxIntA)+ddL,round(yy+DyIntA)+ddT,
                round(xx+dxf-DxIntA)-1-ddR,round(yy+dyf-DyIntA-1-ddB) );
      if PtInRect(rect1,pt) then
      begin
        if IDispMin<IdispMax then Ivec:= IdispMin+i else Ivec:=IdispMin-i;
        if JDispMin<JdispMax then Jvec:= JdispMin+j else Jvec:=JdispMin-j;
        result.X:=Ivec;
        result.Y:=Jvec;
        exit;
      end;
    end;

  result.X:= -1;
  result.Y:= -1;
end;


function TvectorArray.MouseDownMG(numOrdre:integer;Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X, Y: Integer):boolean;
var
  i,j,k:integer;
  mi,mj:TmenuItem;
  x1,y1,x2,y2:integer;
  nbColDisp,nbligDisp:integer;
  stHint:AnsiString;
  stUserHint:AnsiString;
  pt:Tpoint;
begin
  result:=false;
  if nbdim<>2 then exit;
  if numOrdre<>0 then exit;
  if not assigned(uo) then exit;

  if not ((shift=[ssCtrl,ssLeft]) or (shift=[ssShift,ssLeft])) then exit;

  pt:= posToGrid(x,y);
  if pt.x<0 then exit;

  result:=true;
  k:=nblig*(pt.x-Imin) + (pt.y-Jmin);
  {
  getWindowG(x1,y1,x2,y2);

  nbColDisp:=abs(IdispMax-IdispMin)+1;
  nbLigDisp:=abs(JdispMax-JdispMin)+1;

  if IdispMin<IdispMax
    then i:=IdispMin+truncL(nbcolDisp*x/(x2-x1)) -Imin
    else i:=IdispMin-truncL(nbcolDisp*x/(x2-x1)) -Imin;

  if JdispMin<JdispMax
    then j:=JdispMin+truncL(nbligDisp*y/(y2-y1)) -Jmin
    else j:=JdispMin-truncL(nbligDisp*y/(y2-y1)) -Jmin;

  if (i<0) or (i>=nbcol) then exit;
  if (j<0) or (j>=nblig) then exit;

  k:=nblig*i+j;
  }
  if not assigned(uo^[k]) then exit;

  if shift=[ssShift,ssLeft] then
  begin
    stHint:='('+Istr(Imin+i)+','+Istr(Jmin+j)+')' ;
    with onHint do
    if valid then
    begin
      pg.executerMatHint(ad,typeUO(self.MyAd),Imin+i,Jmin+j,stUserHint);
      stHint:=stHint+crlf+stUserHint;
    end;

    ShowStmHint(xc+x,yc+y,stHint);

  end
  else
  begin
    if assigned(pop) then pop.free;

    pop:=TpopUpMenu.create(nil);

    mi:=TmenuItem.create(pop);

    mi.caption:=typeUO(uo^[k]).ident; {item avec nom de l'objet}

    CopyPopup(mi,typeUO(uo^[k]).getPopup);

    pop.items.add(mi);

    pop.popup(xc+x,yc+y);
  end;
end;

function TvectorArray.getInsideWindow:Trect;
var
  x1,y1,x2,y2:integer;
begin
  getWindowG(x1,y1,x2,y2);

  getInsideWindow:=rect(x1,y1,x2,y2);
end;

procedure TvectorArray.proprietes(sender:Tobject);
var
  i1,i2,j1,j2,n1,n2:integer;
  tNombre:typetypeG;
begin
  if FnoDestroyVectors then exit;

  i1:=imin;
  i2:=imax;
  j1:=jmin;
  j2:=jmax;

  n1:=Istart;
  n2:=Iend;
  tNombre:=tpNum;

  if initTvectorArray.execution(ident,i1,i2,j1,j2,n1,n2,tNombre) and
     ((i1<>imin) or
      (i2<>imax) or
      (j1<>jmin) or
      (j2<>jmax) or
      (n1<>Istart) or
      (n2<>Iend) or
      (tNombre<>tpNum)
     ) then
    begin
      initArray(i1,i2,j1,j2);
      initVectors(n1,n2,tNombre);
      invalidate;
    end

end;

procedure TvectorArray.Options(sender:Tobject);
begin
  if nbdim<>2 then exit;
  with VAgetOptions do
  begin
    caption:=ident+' options';

    cbOverlap.setvar(FnoClip);
    enDeltaX.setvar(dxAff,t_single);
    enDeltaX.setminmax(-100,100);
    enDeltaY.setvar(dyAff,t_single);
    enDeltaY.setminmax(-100,100);

    enLeft.setvar(Mleft,t_single);
    enLeft.setminmax(0,100);

    enRight.setvar(Mright,t_single);
    enRight.setminmax(0,100);

    enTop.setvar(Mtop,t_single);
    enTop.setminmax(0,100);

    enBottom.setvar(Mbottom,t_single);
    enBottom.setminmax(0,100);

    enIdispMin.setvar(IdispMin,t_longint);
    enIdispMax.setvar(IdispMax,t_longint);
    enJdispMin.setvar(JdispMin,t_longint);
    enJdispMax.setvar(JdispMax,t_longint);

    enDxInt.setvar(DxInt,t_single);
    enDyInt.setvar(DyInt,t_single);

    Imini:=Imin;
    Imaxi:=Imax;
    Jmini:=Jmin;
    Jmaxi:=Jmax;

    if showModal=mrOK then
      begin
        updateAllVar(VAgetOptions);
        self.invalidate;
      end;
  end;


end;

function TvectorArray.getPopUp:TpopupMenu;
begin
  with PopUps do
  begin
    PopUpItem(pop_TvectorArray,'TvectorArray_Coordinates').onclick:=ChooseCoo;
    PopupItem(pop_TvectorArray,'TvectorArray_Show').onclick:=self.Show;
    PopupItem(pop_TvectorArray,'TvectorArray_Properties').onclick:=Proprietes;
    PopupItem(pop_TvectorArray,'TvectorArray_Options').onclick:=Options;


    PopupItem(pop_TvectorArray,'TvectorArray_SaveObject').onclick:=SaveObjectToFile;
    PopupItem(pop_TvectorArray,'TvectorArray_Clone').onclick:=CreateClone;

    result:=pop_TvectorArray;
  end;
end;

procedure TvectorArray.reinit;
begin
  if NbDim=1
    then initArray1(indminA[1],indmaxA[1])                        // NbDim=1
    else initArray(indminA[1],indmaxA[1],indminA[2],indmaxA[2]);  // NbDim=2
  initVectors(Istart,Iend,tpNum);

end;

procedure TvectorArray.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setvarconf('Dxaff',DxAff,sizeof(DxAff));
    setvarconf('Dyaff',DyAff,sizeof(DyAff));

    setvarconf('Mleft',Mleft,sizeof(Mleft));
    setvarconf('Mtop',Mtop,sizeof(Mtop));
    setvarconf('Mright',Mright,sizeof(Mright));
    setvarconf('Mbottom',Mbottom,sizeof(Mbottom));

    if lecture then
    begin
      nbDim:=2;
      setvarconf('imin',indminA[1],sizeof(integer));
      setvarconf('imax',indmaxA[1],sizeof(integer));
      setvarconf('jmin',indminA[2],sizeof(integer));
      setvarconf('jmax',indmaxA[2],sizeof(integer));

      setvarconf('IndMin',indminA,sizeof(indmin));
      setvarconf('IndMax',indmaxA,sizeof(indmax));
      Fcompact:=false;
    end
    else
    begin
      setvarconf('IndMin',indmin,sizeof(indmin));
      setvarconf('IndMax',indmax,sizeof(indmax));
    end;

    setvarconf('NbDim',nbDim,sizeof(nbDim));
    setvarconf('Fcompact',Fcompact,sizeof(Fcompact));

    setvarconf('FnoClip',FnoClip,sizeof(FnoClip));

    setvarconf('IdispMin',IdispMin,sizeof(IdispMin));
    setvarconf('IdispMax',IdispMax,sizeof(IdispMax));
    setvarconf('JdispMin',JdispMin,sizeof(JdispMin));
    setvarconf('JdispMax',JdispMax,sizeof(JdispMax));
    setvarconf('DxInt',DxInt,sizeof(DxInt));
    setvarconf('DyInt',DyInt,sizeof(DyInt));
  end;
end;

procedure TvectorArray.completeLoadInfo;
begin
  inherited;
  recupForm;
end;

procedure TvectorArray.saveToStream( f:Tstream;Fdata:boolean);
var
  i:integer;
begin
  Fcompact:=CanCompact;
  saveToStreamBase(f,false); // calls the typeUO procedure

  if FCompact and Fdata then saveData(f)
  else
  if initOK then
    for i:=0 to nbobj-1 do Tvector(uo[i]).saveToStream(f,Fdata);
end;


function  TvectorArray.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  st1,stID:AnsiString;
  LID:integer;
  posIni:LongWord;
  i,j:integer;
  v11:Tvector;

begin
  result:= loadFromStreamBase(f,size,false);  // calls the typeUO procedure
  if not result OR (f.position>=f.size) then exit;

  reinit;

  if Fcompact and Fdata then
  begin
    result:=loadData(f);
    setChildNames;
    for i:=0 to nbobj-1 do Tvector(uo[i]).visu.assign(visu);
    exit;
  end;

  stID:=ident;
  LID:=length(ident);
  posIni:=f.position;

  for i:=0 to nbobj-1 do
  begin
    st1:=readHeader(f,size);

    if (st1=UObase.STMClassName) then
    with Tvector(uo[i]) do
    begin
      result:=loadFromStream(f,size,Fdata);
      result:=result and Fchild;
      result:=result and (copy(ident,1,LID)=stID);
    end;
    if not result then break;
  end;

  if not result then
    begin
      result:=false;
      f.Position:=posini;
    end;

  setChildNames;
  result:=true;

  v11:= Tvector(uo[0]);
  if assigned(v11) then
  begin
    inf.imin:=v11.Istart;
    inf.imax:=  v11.Iend;
    inf.dxu:=   v11.Dxu;
    inf.x0u:=   v11.x0u;
    inf.dyu:=   v11.dyu;
    inf.y0u:=   v11.y0u;
    inf.tpNum:= v11.tpNum;
  end;

end;

procedure TvectorArray.MeanStdDev(x1, x2: float; var vm, vstd: float);
var
  i,j:integer;
  i1,i2,Nt:integer;
  s,s2:float;
begin
  vm:=0;
  vstd:=0;
  if not initOK then exit;

  i1:=invconvx(x1);
  i2:=invconvx(x2);

  if i1<Istart then i1:=Istart;
  if i2>Iend then i2:=Iend;
  if i2<i1 then exit;

  s:=0;
  s2:=0;
  for i:=0 to nbobj-1 do
  begin
    s:=s+Tvector(uo[i]).sum(i1,i2);
    s2:=s2+Tvector(uo[i]).sumSqrs(i1,i2);
  end;
  Nt:= nbObj*(i2-i1+1);

  if Nt>0 then vm:=s/Nt;
  if Nt>1 then vstd:= sqrt(abs(s2-s*s/Nt)/(Nt-1));     { Rappel stdDev= sqrt((sx2-sqr(Sx)/N)/(N-1)); }
end;



function TvectorArray.buildMap(var m:Tmatrix;x1,x2:float;mode:integer):boolean;
var
  i1,i2:longint;
  i,j:integer;
  nb:integer;
begin
  result:=false;
  if nbDim<>2 then exit;
  if not initOK then exit;

  if x1<Xstart then x1:=Xstart;
  if x2>Xend then x2:=Xend;

  i1:=invconvx(x1);
  i2:=invconvx(x2);

  if (i1<Istart) or (i2<i1) or (Iend<i2) then
  begin
    messageCentral('BuildMap error');
    exit;
  end;
  
  m.initTemp(Imin,Imax,Jmin,Jmax,m.tpNum);

  nb:= i2-i1+1;

  for i:=Imin to Imax do
  for j:=Jmin to Jmax do
    case mode of
      0:  m.data.setE(i,j,vector[i,j].sum(i1,i2) );
      1:  m.data.setE(i,j,vector[i,j].sumSqrs(i1,i2) );
      2:  m.data.setE(i,j,vector[i,j].sumMdls(i1,i2) );
      3:  m.data.setE(i,j,vector[i,j].sumPhi(i1,i2) );
      4:  m.data.setE(i,j,vector[i,j].sum(i1,i2)/nb );
    end;
  result:=true;
end;

function TvectorArray.BuildZscoreMap(var m: Tmatrix;x1,x2:float;mode:integer ):boolean;
var
 i,j: integer;
 xm,xstd:float;
 mr:Tmatrix;

begin
  result:=BuildMap(m,x1,x2,mode);
  if not result then exit;

  mr:=Tmatrix.create;
  mr.inf.tpNum:=g_single;

  try
    if not BuildMap(mr, -x2,-x1,mode) then exit;

    with mr do
    begin
      xm:=mean(Istart,Iend,Jstart,Jend);
      xstd:=stdDev(Istart,Iend,Jstart,Jend);
    end;

    if xstd>0 then
    with m do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
       Zvalue[i,j]:=(Zvalue[i,j]-xm)/xstd;

  finally
    mr.free;
  end;

end;

{ XTsum calcule une colonne (ou ligne) d'une matrice XT
  mr contient les données brutes
  m est la destination
  n est le numéro de la colonne (si Fy=true) ou de la ligne de m calculée
  Si FZscore, on calcule la carte en Zscore
  xm, xstd: valeur moyenne et stddev pour le calcul de Zscore
  Zth : seuil de Zscore
  AgTh: seuil pour les mode agrégats
  mode1: valeurs possibles:
    1: Somme des valeurs d'une colonne
    2: Maximum des valeurs d'une colonne

    3,4: Comme 1 et 2 mais on remplace d'abord chaque valeur de m par le nombre
       de pixels agrégés.


}
procedure XTsum(mr,m:Tmatrix;n:integer;FZscore,FY:boolean;xm,xstd,Zth:float;mode1:integer;AgTh:integer);
var
  w:float;
  i,j:integer;
begin
  if FZscore and (xstd>0) then     {Remplacer les valeurs de mr par des Zscores seuillés }
    with mr do
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
    begin
      w:=(Zvalue[i,j]-xm)/xstd;
      if w>=Zth
        then Zvalue[i,j]:=w
        else Zvalue[i,j]:=0;
    end;

  if (mode1=3) or (mode1=4) then
  begin
    mr.BuildCnxMap(Zth,0,0);  { modes 3 et 4: on calcule les agrégats}
    if AgTh>0 then            { seuillage }
      with mr do
      for i:=Istart to Iend do
      for j:=Jstart to Jend do
        if Zvalue[i,j]<AgTh
          then Zvalue[i,j]:=0;
  end
  else
  if (mode1=5) or (mode1=6) then
    mr.BuildCnxMap(Zth,1,AgTh);  { modes 5 et 6: on calcule les agrégats
                                     en gardant les valeurs de Zscore   }


  case mode1 of
    1,3,5:
      with mr do
      if FY then
        for i:=Istart to Iend do       {Somme des colonnes }
        begin
          w:=0;
          for j:=Jstart to Jend do
            w:=w+Zvalue[i,j];
          m.Zvalue[n,i]:=w;
        end
        else
        for j:=Jstart to Jend do       {Somme des lignes }
        begin
          w:=0;
          for i:=Istart to Iend do
            w:=w+Zvalue[i,j];
          m.Zvalue[n,j]:=w;
        end;

    2,4,6:
      with mr do
      if FY then
        for i:=Istart to Iend do       {Somme des colonnes }
        begin
          w:=-1E30;
          for j:=Jstart to Jend do
            if Zvalue[i,j]>w then w:=Zvalue[i,j];
          m.Zvalue[n,i]:=w;
        end
        else
        for j:=Jstart to Jend do       {Somme des lignes }
        begin
          w:=-1E30;
          for i:=Istart to Iend do
            if Zvalue[i,j]>w then w:=Zvalue[i,j];
          m.Zvalue[n,j]:=w;
        end;
  end;
end;



function TvectorArray.BuildXTMap(var m: Tmatrix;x1,x2,dtau,dxt:float;mode:integer;
                                 FY,FZscore:boolean;
                                 Xref:float;FrefSym:boolean;Zth:float;mode1:integer;
                                 AgTh:integer ):boolean;
var
  i,j,n,nb: integer;
  w,xm,xstd:float;
  mr:Tmatrix;
  xA,xB,xA1,xB1:float;

begin
  result:=false;
  if nbDim<>2 then exit;
  if (dxt<=0) or (x2<=x1) or not initOK then exit;

  //nb:=round((x2-x1-dtau)/dxt); correction sept 2014
  //if nb<=0 then exit;

  if dtau>x2-x1 then exit;

  nb:=trunc((x2-x1-dtau)/dxt) +1;


  if FY
    then m.initTemp(0,nb-1,Imin,Imax,m.tpNum)
    else m.initTemp(0,nb-1,Jmin,Jmax,m.tpNum);

  m.Dxu:=dxt;
  m.X0u:=x1;
  m.keepRatio:=false;

  mr:=Tmatrix.create;
  mr.inf.tpNum:=g_single;

  TRY
  if FZscore and not FrefSym then
  begin
    BuildMap(mr,Xref,Xref+dtau,mode);
    with mr do
    begin
      xm:=mean(Istart,Iend,Jstart,Jend);
      xstd:=stdDev(Istart,Iend,Jstart,Jend);
    end;
  end;


  for n:=0 to nb-1 do
  begin
    xA:=x1+n*dxt;
    xB:=x1+n*dxt+dtau;

    if FZscore and FrefSym then
    begin
      if xA>=0 then xA1:=-xB
               else xA1:=Xstart;
      if xA1<Xstart then xA1:=Xstart;
      xB1:=xA1+dtau;
      BuildMap(mr, xA1,xB1,mode);

      with mr do
      begin
        xm:=mean(Istart,Iend,Jstart,Jend);
        xstd:=stdDev(Istart,Iend,Jstart,Jend);
      end;
    end;

    result:=BuildMap(mr,xA,xB,mode);

    XTsum(mr,m,n,FZscore,FY,xm,xstd,Zth,mode1,AgTh);
  end;


  FINALLY
    mr.free;
  END;
end;

function TvectorArray.BuildXTMap1(var m: Tmatrix;x1,x2,dtau,dxt:float;mode:integer;
                              FY,FZscore,FrefSym:boolean;
                              Zth:float;vecM,vecStd:Tvector;mode1:integer;
                              AgTh:integer):boolean;
var
  i,j,n,nb: integer;
  w,xm,xstd:float;
  mr:Tmatrix;

begin
  result:=false;
  if nbDim<>2 then exit;
  if (dxt<=0) or (x2<=x1) or not initOK then exit;


  //nb:=round((x2-x1-dtau)/dxt); correction sept 2014
  //if nb<=0 then exit;
  if dtau>x2-x1 then exit;
  nb:=trunc((x2-x1-dtau)/dxt) +1;


  if FY
    then m.initTemp(0,nb-1,Imin,Imax,m.tpNum)
    else m.initTemp(0,nb-1,Jmin,Jmax,m.tpNum);

  m.Dxu:=dxt;
  m.X0u:=x1;
  m.keepRatio:=false;

  mr:=Tmatrix.create;
  mr.inf.tpNum:=g_single;

  TRY

  for n:=0 to nb-1 do
  begin
    result:=BuildMap(mr,x1+n*dxt,x1+n*dxt+dtau,mode);

    if FZscore then
    begin
      if FrefSym then
      begin
        xm:=vecM.Rvalue[-abs(x1+n*dxt)];
        xstd:=vecStd.Rvalue[-abs(x1+n*dxt)];
      end
      else
      begin
        xm:=vecM.Rvalue[x1+n*dxt];
        xstd:=vecStd.Rvalue[x1+n*dxt];
      end;
    end;

    XTsum(mr,m,n,FZscore,FY,xm,xstd,Zth,mode1,AgTh);
  end;


  FINALLY
    mr.free;
  END;
end;




function TvectorArray.BuildIntMaps(mat1, mat2: Tmatrix; tau1,tau2,seuilP,seuilM: float;
                                    Norm: boolean):boolean;
var
 i,j: integer;
 intSup,intInf:float;
 LAbove, LBelow: float;

begin
  result:=false;
  if nbDim<>2 then exit;
  if not initOK then exit;

  if assigned(mat1) then
  with mat1 do
  if (Istart<>Imin) or (Iend<>Imax) or (Jstart<>Jmin) or (Jend<>Jmax)
    then initTemp(Imin,Imax,Jmin,Jmax,tpNum);

  if assigned(mat2) then
  with mat2 do
  if (Istart<>Imin) or (Iend<>Imax) or (Jstart<>Jmin) or (Jend<>Jmax)
    then initTemp(Imin,Imax,Jmin,Jmax,tpNum);

  for i:= Imin to Imax do
  for j:= Jmin to Jmax do
    begin
      IntSup:= vector[i,j].IntAbove(tau1,tau2,seuilP,LAbove);
      IntInf:= vector[i,j].IntBelow(tau1,tau2,seuilM,LBelow);

      if not Norm then
        begin
          if assigned(mat1) then mat1.Zvalue[i,j] := IntSUP;
          if assigned(mat2) then mat2.Zvalue[i,j] := IntINF;
        end
      else
        begin
          if assigned(mat1) and (Labove>0) then mat1.Zvalue[i,j] := intSUP/LAbove;
          if assigned(mat2) and (LBelow>0) then mat2.Zvalue[i,j] := IntINF/LBelow;
        end;
    end;
  result:=true;
end;

function TvectorArray.BuildXTIntMaps(mat1,mat2:Tmatrix;x1,x2,dtau,dxt,seuilP,seuilM:float;
                                     FY,FZscore:boolean;
                                     Xref:float;FrefSym:boolean;Zth:float;mode:integer;
                                     AgTh:integer ):boolean;
var
  i,j,k,n,nb: integer;
  w,xm,xstd:float;
  mr,m:array[1..2] of Tmatrix;
  xA,xB,xA1,xB1:float;

begin
  result:=false;
  if nbDim<>2 then exit;
  if (dxt<=0) or (x2<=x1) or not initOK then exit;

  //w:=floor(x1/dxt)*dxt;
  //if w<x1 then x1:=w+dxt else x1:=w;

  //x2:=floor( (x2-dtau)/dxt)*dxt;

  //nb:=round((x2-x1)/dxt)+1;
  //if nb<=0 then exit;
  if dtau>x2-x1 then exit;
  nb:=trunc((x2-x1-dtau)/dxt) +1;

  m[1]:=mat1;
  m[2]:=mat2;

  for i:=1 to 2 do
  if assigned(m[i]) then
  begin
    if FY
      then m[i].initTemp(0,nb-1,Imin,Imax,m[i].tpNum)
      else m[i].initTemp(0,nb-1,Jmin,Jmax,m[i].tpNum);

    m[i].Dxu:=dxt;
    m[i].X0u:=x1;
    m[i].keepRatio:=false;
  end;

  for i:=1 to 2 do
  begin
    mr[i]:=Tmatrix.create;
    mr[i].inf.tpNum:=g_single;
  end;

  TRY
  if FZscore and not FrefSym then
  begin
    if not BuildIntMaps(mr[1], mr[2], Xref,Xref+dtau,seuilP,seuilM, false) then exit;

    with mr[1] do
    begin
      xm:=mean(Istart,Iend,Jstart,Jend);
      xstd:=stdDev(Istart,Iend,Jstart,Jend);
    end;
  end;


  for n:=0 to nb-1 do
  begin
    xA:=x1+n*dxt;
    xB:=x1+n*dxt+dtau;

    if FZscore and FrefSym then
    begin
      if xA>=0 then xA1:=-xB
               else xA1:=Xstart;
      if xA1<Xstart then xA1:=Xstart;
      xB1:=xA1+dtau;
      if not BuildIntMaps(mr[1], mr[2], xA1,xB1,seuilP,seuilM, false) then exit;

      with mr[1] do
      begin
        xm:=mean(Istart,Iend,Jstart,Jend);
        xstd:=stdDev(Istart,Iend,Jstart,Jend);
      end;
    end;

    if not BuildIntMaps(mr[1], mr[2],xA,xB,seuilP,seuilM, false) then exit;
    for k:=1 to 2 do
      if assigned(m[k]) then XTsum(mr[k],m[k],n,FZscore,FY,xm,xstd,Zth,mode,AgTh);
  end;

  FINALLY
    for i:=1 to 2 do mr[i].free;
  END;
end;

function TvectorArray.BuildXTIntMaps1(mat1,mat2:Tmatrix;x1,x2,dtau,dxt,seuilP,seuilM:float;
                                     FY:boolean;FZscore,FrefSym:boolean;
                                     Zth:float;vecM,vecStd:Tvector;mode:integer;
                                     AgTh:integer ):boolean;
var
  i,j,k,n,nb: integer;
  w,xm,xstd:float;
  mr,m:array[1..2] of Tmatrix;

begin
  result:=false;
  if nbDim<>2 then exit;
  if (dxt<=0) or (x2<=x1) or not initOK then exit;

  //nb:=round((x2-x1-dtau)/dxt);
  //if nb<=0 then exit;

  if dtau>x2-x1 then exit;
  nb:=trunc((x2-x1-dtau)/dxt) +1;


  m[1]:=mat1;
  m[2]:=mat2;

  for i:=1 to 2 do
  if assigned(m[i]) then
  begin
    if FY
      then m[i].initTemp(0,nb-1,Imin,Imax,m[i].tpNum)
      else m[i].initTemp(0,nb-1,Jmin,Jmax,m[i].tpNum);

    m[i].Dxu:=dxt;
    m[i].X0u:=x1;
    m[i].keepRatio:=false;
  end;

  for i:=1 to 2 do
  begin
    mr[i]:=Tmatrix.create;
    mr[i].inf.tpNum:=g_single;
  end;

  TRY
  for n:=0 to nb-1 do
  begin
    if not BuildIntMaps(mr[1], mr[2],x1+n*dxt,x1+n*dxt+dtau,seuilP,seuilM, false) then exit;

    for k:=1 to 2 do
    begin
      if FZscore then
      begin
        xm:=vecM.Rvalue[x1+n*dxt];
        xstd:=vecStd.Rvalue[x1+n*dxt];
      end;

      if assigned(m[k]) then XTsum(mr[k],m[k],n,FZscore,FY,xm,xstd,Zth,mode,AgTh);
    end;
  end;


  FINALLY
    for i:=1 to 2 do mr[i].free;
  END;
end;


function TvectorArray.BuildZscoreIntMaps(mat1, mat2: Tmatrix; tau1,tau2,seuilP,seuilM: float):boolean;
var
 i,j,k: integer;
 xm,xstd:float;

 mr,mt:array[1..2] of Tmatrix;

begin
  result:=BuildIntMaps(mat1, mat2, tau1,tau2,seuilP,seuilM, false);
  if not result then exit;


  mt[1]:=mat1;
  mt[2]:=mat2;

  for k:=1 to 2 do
  begin
    mr[k]:=Tmatrix.create;
    mr[k].inf.tpNum:=g_single;
  end;

  try
    if not BuildIntMaps(mr[1], mr[2], -tau2,-tau1,seuilP,seuilM, false) then exit;
    for k:=1 to 2 do
    begin
      with mr[k] do
      begin
        xm:=mean(Istart,Iend,Jstart,Jend);
        xstd:=stdDev(Istart,Iend,Jstart,Jend);
      end;

      if xstd>0 then
      with mt[k] do
      for i:=Istart to Iend do
      for j:=Jstart to Jend do
         Zvalue[i,j]:=(Zvalue[i,j]-xm)/xstd;
    end;



  finally
    for i:=1 to 2 do mr[i].free;
  end;

end;


procedure TvectorArray.IntMapStats(VMean1,Vmean2,VStd1,Vstd2:Tvector;seuilP,seuilM,tMax,dtau:float;Norm:boolean);
var
  tmaxi:integer;
  i:integer;
  mat1, mat2: Tmatrix;
begin
  if nbDim<>2 then exit;
  tmaxi:=round(tMax);
  Vmean1.modify(g_single,0,tMaxi); Vmean1.Dxu:=1; Vmean1.x0u:=0;
  Vstd1.modify(g_single,0,tMaxi);  Vmean2.Dxu:=1; Vmean2.x0u:=0;
  Vmean2.modify(g_single,0,tMaxi); Vstd1.Dxu:=1; Vstd1.x0u:=0;
  Vstd2.modify(g_single,0,tMaxi);  Vstd2.Dxu:=1; Vstd2.x0u:=0;

  mat1:=Tmatrix.create;
  mat1.inf.tpNum:=g_single;

  mat2:=Tmatrix.create;
  mat2.inf.tpNum:=g_single;

  TRY
  for i:=0 to tmaxi do
  begin
    BuildIntMaps(mat1, mat2,Xstart+i,Xstart+i+dtau,seuilP,seuilM,Norm);
    with mat1 do Vmean1.Yvalue[i]:=mean(Istart,Iend,Jstart,Jend);
    with mat1 do Vstd1.Yvalue[i]:=stdDev(Istart,Iend,Jstart,Jend);
    with mat2 do Vmean2.Yvalue[i]:=mean(Istart,Iend,Jstart,Jend);
    with mat2 do Vstd2.Yvalue[i]:=stdDev(Istart,Iend,Jstart,Jend);
  end;

  FINALLY
    mat1.Free;
    mat2.free;
  END;
end;

(* Version dans laquelle on optimise à la fois x et dx

procedure TvectorArray.OptStats(x1,x2,dxm:float;VMean,VStd:Tvector);
var
  i,j:integer;
  VZ,VT:float;
  x:float;
  N:integer;

  mat:Tmatrix;
begin
  mat:=Tmatrix.create;
  mat.initTemp(Imin,Imax,Jmin,Jmax,g_single);

  Vmean.initTemp1(1,trunc((x2-x1)/dxm),g_single);
  Vmean.Dxu:=dxm;
  Vmean.X0u:=0;

  Vstd.initTemp1(1,trunc((x2-x1)/dxm),g_single);
  Vstd.Dxu:=dxm;
  Vstd.X0u:=0;

  x:=dxm;

  TRY
  repeat
    N:=round(x/dxu);
    for i:= Imin to Imax do
    for j:= Jmin to Jmax do
      begin
        vector[i,j].Maxlis(x1,x2,N,VZ,VT);
        mat.Zvalue[i,j]:=vz;
      end;

    with mat do Vmean.Rvalue[x]:=mean(Istart,Iend,Jstart,Jend);
    with mat do Vstd.Rvalue[x]:=stdDev(Istart,Iend,Jstart,Jend);

    x:=x+dxm;
  until x>x2-x1;

  FINALLY
  mat.free;
  END;

end;



procedure TvectorArray.OptMatrix(x1,x2,dxm:float; Vmean,Vstd: Tvector; Mopt, Mwidth, Mlat: Tmatrix);
var
  i,j,k:integer;
  VZ,VT,VZmax,Wmax,Tmax:float;
  x:float;
  N:integer;

begin
  with Mopt do initTemp(Imin,Imax,Jmin,Jmax,tpNum);
  with Mwidth do initTemp(Imin,Imax,Jmin,Jmax,tpNum);
  with Mlat do initTemp(Imin,Imax,Jmin,Jmax,tpNum);

  for i:= Imin to Imax do
  for j:= Jmin to Jmax do
  begin
    VZmax:=0;
    Wmax:=dxm;
    Tmax:=0;

    x:=dxm;
    repeat
      N:=round(x/dxu);
      vector[i,j].Maxlis(x1,x2,N,VZ,VT);
      VZ:=(VZ-Vmean.Rvalue[x])/Vstd.Rvalue[x];
      if VZ>VZmax then
        begin
          VZmax:=VZ;
          Wmax:=x;
          Tmax:=VT;
        end;
      x:=x+dxm;
    until x>x2-x1;


    Mopt.Zvalue[i,j]:=VZmax;
    Mwidth.Zvalue[i,j]:=Wmax;
    Mlat.Zvalue[i,j]:=Tmax;


  end;
end;
*)


procedure TvectorArray.OptStats(x1,x2,dxm:float;var VMean,VStd:float);
var
  i,j:integer;
  VZ,VT:float;
  N:integer;

  mat:Tmatrix;
begin
  if nbDim<>2 then exit;
  mat:=Tmatrix.create;
  mat.initTemp(Imin,Imax,Jmin,Jmax,g_single);


  TRY
    N:=round(dxm/dxu);
    for i:= Imin to Imax do
    for j:= Jmin to Jmax do
      begin
        vector[i,j].Maxlis(x1,x2,N,VZ,VT);
        mat.Zvalue[i,j]:=vz;
      end;

    with mat do Vmean:=mean(Istart,Iend,Jstart,Jend);
    with mat do Vstd:=stdDev(Istart,Iend,Jstart,Jend);


  FINALLY
  mat.free;
  END;

end;



procedure TvectorArray.OptMatrix(x1,x2,dxm:float;Vmean,Vstd:float; Mopt,Mlat: Tmatrix);
var
  i,j,k:integer;
  VZ,VT,VZmax,Wmax,Tmax:float;
  N:integer;

begin
  if nbDim<>2 then exit;
  with Mopt do initTemp(Imin,Imax,Jmin,Jmax,tpNum);
  with Mlat do initTemp(Imin,Imax,Jmin,Jmax,tpNum);

  N:=round(dxm/dxu);

  for i:= Imin to Imax do
  for j:= Jmin to Jmax do
  begin
    vector[i,j].Maxlis(x1,x2,N,VZ,VT);

    Mopt.Zvalue[i,j]:=(VZ-Vmean)/Vstd;
    Mlat.Zvalue[i,j]:=VT;
  end;
end;


procedure TvectorArray.Threshold(th:float;Fup,Fdw:boolean);
var
  i,j:integer;
begin
  for i:= 0 to nbobj-1 do
    Tvector(uo[i]).Threshold(th,Fup,Fdw);
end;

procedure TVectorArray.autoscaleI;
begin
  IdispMin:=Imin;
  IdispMax:=Imax;;
end;

procedure TVectorArray.autoscaleJ;
begin
  JdispMin:=Jmin;
  JdispMax:=Jmax;;
end;

procedure TVectorArray.MedianVector(vec: Tvector);
var
  t:TArrayOfDouble;
  i,j:integer;
begin
  if not initOK then exit;
  setLength(t,nbObj);
  VadjustIstartIend(Tvector(uo[0]),vec);
  for i:=vec.Istart to vec.Iend do
  begin
    for j:=0 to nbObj-1 do
      t[j]:=Tvector(uo^[j]).Yvalue[i];
    vec.Yvalue[i]:=mediane(t,nbObj);
  end;
end;

procedure TVectorArray.subVector(vec:Tvector);
var
  i:integer;
begin
  if not initOK then exit;

  for i:=0 to nbObj-1 do
    proVsub(Tvector(uo^[i]),vec,Tvector(uo^[i]));
end;



procedure TVectorArray.AddNum(num:TfloatComp);
var
  i:integer;
begin
  if not initOK then exit;

  for i:=0 to nbObj-1 do
    proVaddNum( Tvector(uo^[i]),num);
end;


{***********************  Méthodes STM de TvectorArray ********************}

var
  E_vectorArrayCreate:integer;
  E_lineWidth:integer;
  E_affectation:integer;
  E_indice:integer;
  E_typeVector:integer;

procedure proTvectorArray_create(name:AnsiString;i1,i2,j1,j2:integer;var pu:typeUO);
begin
  createPgObject(name,pu,TvectorArray);

  if (i1>i2) or (j1>j2)  then sortieErreur('TvectorArray.create : bad index');

  with TvectorArray(pu) do initArray(i1,i2,j1,j2);
end;

procedure proTvectorArray_create_1(i1,i2,j1,j2:integer;var pu:typeUO);
begin
  proTvectorArray_create('',i1,i2,j1,j2, pu);
end;

procedure proTvectorArray_create_2(i1,i2:integer;var pu:typeUO);
begin
  createPgObject('',pu,TvectorArray);

  if (i1>i2)  then sortieErreur('TvectorArray.create : bad index');

  with TvectorArray(pu) do initArray1(i1,i2);
end;


procedure proTVectorArray_modify(i1,i2,j1,j2:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  if (i1>i2) or (j1>j2)  then sortieErreur('T'+pu.STMClassName+'.modify : bad index');

  with TvectorArray(pu) do initArray(i1,i2,j1,j2);
end;

procedure proTVectorArray_modify_1(i1,i2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (i1>i2)  then sortieErreur('T'+pu.STMClassName+'.modify : bad index');

  with TvectorArray(pu) do initArray1(i1,i2);
end;


procedure proTVectorArray_initObjects(tn:integer;n1,n2:longint;var pu:typeUO);
begin
  if not (typeTypeG(tn) in typesVecteursSupportes)
    then sortieErreur(E_typeVector);

  verifierObjet(pu);
  with TvectorArray(pu) do initVectors(n1,n2,typeTypeG(tn));
end;


procedure proTvectorArray_BuildMap(var m:Tmatrix;x1,x2:float;mode:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(m));
  with TvectorArray(pu) do
  begin
    if x1<Xstart then x1:=Xstart;
    if x2>Xend then x2:=Xend;

    controleParametre(mode,0,4);
    buildMap(m,x1,x2,mode);
  end;
end;

procedure proTvectorArray_BuildZscoreMap(var m:Tmatrix;x1,x2:float;mode:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(m));
  with TvectorArray(pu) do
  begin
    controleParametre(x1,Xstart,Xend);
    controleParametre(x2,Xstart,Xend);
    controleParametre(mode,0,3);
    buildZscoreMap(m,x1,x2,mode);
  end;
end;

function fonctionTvectorArray_V(i,j:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);

  with TvectorArray(pu) do
  begin
    if nbDim<>2 then sortieErreur('T'+stmClassName+'.V[i,j] : bad dimension');
    ControleParam(i,Imin,Imax,E_indice);
    ControleParam(j,Jmin,Jmax,E_indice);
    result:=@uo^[nblig*(i-imin)+j-jmin];
  end;
end;

function fonctionTvectorArray_V_1(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);

  with TvectorArray(pu) do
  begin
    if nbDim<>1 then sortieErreur('T'+stmClassName+'.V[i] : bad dimension');
    ControleParam(i,Imin,Imax,E_indice);
    result:=@uo^[i-imin];
  end;
end;


procedure proTplotArray_Overlap(x:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    TvectorArray(pu).FnoClip:=x;
  end;

function fonctionTplotArray_Overlap(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    result:=TvectorArray(pu).FnoClip;
  end;

procedure proTplotArray_dxWF(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TvectorArray(pu).dxAff:=x;
  end;

function fonctionTplotArray_dxWF(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TvectorArray(pu).dxAff;
  end;




procedure proTplotArray_dyWF(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TvectorArray(pu).dyAff:=x;
  end;

function fonctionTplotArray_dyWF(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TvectorArray(pu).dyAff;
  end;

procedure proTplotArray_dxInt(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TvectorArray(pu).dxInt:=x;
  end;

function fonctionTplotArray_dxInt(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TvectorArray(pu).dxInt;
  end;

procedure proTplotArray_dyInt(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TvectorArray(pu).dyInt:=x;
  end;

function fonctionTplotArray_dyInt(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TvectorArray(pu).dyInt;
  end;


procedure proTplotArray_Mleft(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TvectorArray(pu).Mleft:=x;
  end;

function fonctionTplotArray_Mleft(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TvectorArray(pu).Mleft;
  end;

procedure proTplotArray_Mtop(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TvectorArray(pu).Mtop:=x;
  end;

function fonctionTplotArray_Mtop(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TvectorArray(pu).Mtop;
  end;

procedure proTplotArray_Mright(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TvectorArray(pu).Mright:=x;
  end;

function fonctionTplotArray_Mright(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TvectorArray(pu).Mright;
  end;

procedure proTplotArray_Mbottom(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TvectorArray(pu).Mbottom:=x;
  end;

function fonctionTplotArray_Mbottom(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TvectorArray(pu).Mbottom;
  end;

function fonctionTplotArray_Imin(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TvectorArray(pu).Imin;
end;

function fonctionTplotArray_Imax(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TvectorArray(pu).Imax;
end;

function fonctionTplotArray_Jmin(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TvectorArray(pu).Jmin;
end;

function fonctionTplotArray_Jmax(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TvectorArray(pu).Jmax;
end;

procedure proTplotArray_Idispmin(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TvectorArray(pu).IdispMin:=x;
end;

function fonctionTplotArray_Idispmin(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TvectorArray(pu).IdispMin;
end;

procedure proTplotArray_Idispmax(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TvectorArray(pu).IdispMax:=x;
end;

function fonctionTplotArray_Idispmax(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TvectorArray(pu).IdispMax;
end;

procedure proTplotArray_Jdispmin(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TvectorArray(pu).JdispMin:=x;
end;

function fonctionTplotArray_Jdispmin(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TvectorArray(pu).JdispMin;
end;


procedure proTplotArray_Jdispmax(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TvectorArray(pu).JdispMax:=x;
end;

function fonctionTplotArray_Jdispmax(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TvectorArray(pu).JdispMax;
end;

procedure proTplotArray_JdispInvert(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TvectorArray(pu) do
  begin
    JdispInvert:=x;
    initDisp;
  end;
end;

function fonctionTplotArray_JdispInvert(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TvectorArray(pu).JdispInvert;
end;


procedure proTplotArray_setGrid(x1,y1,x2,y2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TvectorArray(pu) do
  begin
    IdispMin:=x1;
    IdispMax:=x2;
    JdispMin:=y1;
    JdispMax:=y2;
  end;
end;

procedure proTplotArray_autoscaleI(var pu:typeUO);
begin
  verifierObjet(pu);
  TvectorArray(pu).autoscaleI;
end;

procedure proTplotArray_autoscaleJ(var pu:typeUO);
begin
  verifierObjet(pu);
  TvectorArray(pu).autoscaleJ;
end;



procedure proTvectorArray_BuildIntMaps(var mat1,mat2:Tmatrix;tau1,tau2,seuilP,seuilM:float;
                                        Norm:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  with TvectorArray(pu) do
  BuildIntMaps(mat1,mat2,tau1,tau2,seuilP,seuilM,Norm);
end;

procedure proTvectorArray_BuildZscoreIntMaps(var mat1,mat2:Tmatrix;tau1,tau2,seuilP,seuilM:float;
                                        var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat1));
  verifierObjet(typeUO(mat2));

  with TvectorArray(pu) do
  BuildZscoreIntMaps(mat1,mat2,tau1,tau2,seuilP,seuilM);
end;


procedure proTvectorArray_MeanStdDev(x1, x2: float; var vm, vstd: float;var pu:typeUO);
begin
  verifierObjet(pu);

  with TvectorArray(pu) do
    MeanStdDev(x1, x2, vm, vstd);
end;

procedure proTvectorArray_IntMapStats(var VMean1,Vmean2,VStd1,Vstd2:Tvector;
                                       seuilP,seuilM,tMax,dtau:float;Norm:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(Vmean1);
  verifierVecteur(Vmean2);
  verifierVecteur(Vstd1);
  verifierVecteur(Vstd2);


  with TvectorArray(pu) do
  IntMapStats(VMean1,Vmean2,VStd1,Vstd2,seuilP,seuilM,tMax,dtau,Norm);
end;

procedure proTvectorArray_OptStats(x1,x2,dxm:float;var VMean,VStd:float;var pu:typeUO);
begin
  verifierObjet(pu);

  with TvectorArray(pu) do
  OptStats(x1,x2,dxm,VMean,VStd);
end;

procedure proTvectorArray_OptMatrix(x1,x2,dxm:float;Vmean,Vstd: float;var Mopt,Mlat: Tmatrix;
                                     var pu:typeUO);

begin
  verifierObjet(pu);
  verifierObjet(typeUO(Mopt));
  verifierObjet(typeUO(Mlat));

  with TvectorArray(pu) do
  OptMatrix(x1,x2,dxm, Vmean,Vstd, Mopt, Mlat);
end;

procedure proTvectorArray_Threshold(th:float;Fup,Fdw:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TvectorArray(pu) do Threshold(th,Fup,Fdw);
end;

procedure proTvectorArray_BuildXTMap(var m: Tmatrix;x1,x2,dtau,dxt:float;mode:integer;
                        FY,FZscore:boolean;
                        Xref:float;FrefSym:boolean;Zth:float;mode1:integer;
                        AgTh:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(m));

  with TvectorArray(pu) do
  BuildXTMap(m,x1,x2,dtau,dxt,mode,FY, FZscore, Xref,FrefSym,Zth,mode1,AgTh);

end;

procedure proTvectorArray_BuildXTMap1(var m: Tmatrix;x1,x2,dtau,dxt:float;mode:integer;
                        FY,FZscore,FrefSym:boolean;
                        Zth:float;var vecM,vecStd:TVector;mode1:integer;
                        AgTh:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(m));
  verifierVecteur(vecM);
  verifierVecteur(vecStd);


  with TvectorArray(pu) do
  BuildXTMap1(m,x1,x2,dtau,dxt,mode,FY,FZscore,FrefSym,Zth,vecM,vecStd,mode1,AgTh);
end;


procedure proTvectorArray_BuildXTIntMaps(var mat1,mat2:Tmatrix;x1,x2,dtau,dxt,seuilP,seuilM:float;
                                 FY,FZscore:boolean;Xref:float;FrefSym:boolean;Zth:float;mode:integer;
                                 AgTh:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  if (mat1=nil) and (mat2=nil) then sortieErreur('TvectorArray.BuildXTIntMaps : mat1 AND mat2 not assigned');
  // on peut avoir mat1=nil ou mat2=nil }
  with TvectorArray(pu) do
  BuildXTintMaps(mat1,mat2,x1,x2,dtau,dxt,seuilP,seuilM,FY,FZscore,Xref,FrefSym,Zth,mode,AgTh);
end;

procedure proTvectorArray_BuildXTIntMaps1(var mat1,mat2:Tmatrix;x1,x2,dtau,dxt,seuilP,seuilM:float;
                        FY,FZscore,FrefSym:boolean;
                        Zth:float;var vecM,vecStd:Tvector;mode:integer;
                        AgTh:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  if (mat1=nil) and (mat2=nil) then sortieErreur('TvectorArray.BuildXTIntMaps : mat1 AND mat2 not assigned');

  with TvectorArray(pu) do
  BuildXTintMaps1(mat1,mat2,x1,x2,dtau,dxt,seuilP,seuilM,FY,FZscore,FrefSym,Zth,vecM,vecStd,mode,AgTh);
end;

procedure proTVectorArray_MedianVector(var vec: Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  TVectorArray(pu).MedianVector(vec);
end;

procedure proTvectorArray_SubVector(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  TVectorArray(pu).subVector(vec);
end;

procedure proTvectorArray_AddNum(num:TfloatComp;var pu:typeUO);
begin
  verifierObjet(pu);
  TVectorArray(pu).AddNum(num);
end;


procedure proTvectorArray_OnHint(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TvectorArray(pu).onHint do setAd(p);
end;

function fonctionTvectorArray_OnHint(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TvectorArray(pu).OnHint.ad;
end;

procedure proTvectorArray_CpxMode(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (x>=0) and (x<=3)
    then TvectorArray(pu).CpxMode:=x
    else sortieErreur('TvectorArray.CpxMode out of range');  
end;

function fonctionTvectorArray_CpxMode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TvectorArray(pu).CpxMode;
end;


function CompareVAarray(src1,src2:TvectorArray):boolean;
begin
  result:= (src1.imin=src2.imin) and (src1.imax=src2.imax) and
           (src1.jmin=src2.jmin) and (src1.jmax=src2.jmax);
end;

function CompareVAvector(src1,src2:TvectorArray):boolean;
begin
  result:= (src1.Istart=src2.Istart) and (src1.Iend=src2.Iend) ;
end;

function CompareVA(src1,src2:TvectorArray):boolean;
begin
  result:= compareVAArray(src1,src2) and CompareVavector(src1,src2);
end;


procedure  AdjustVA(model,dest:TvectorArray);
begin
  with model do
  begin
    if not compareVAarray(model,dest) then dest.initArray(Imin,Imax,Jmin,Jmax);
    if not compareVAvector(model,dest) then dest.initVectors(Istart,Iend,tpNum);
  end;
end;

procedure VAop(var src1,src2,dest:TvectorArray; op:string);
var
  i,j:integer;
  v1,v2,v3:Tvector;
  opNum:integer;
begin
  verifierObjet(typeUO(src1));
  verifierObjet(typeUO(src2));
  verifierObjet(typeUO(dest));

  if not CompareVA(src1,src2) then sortieErreur(op+' : src1 and src2 have different structures');
  AdjustVA(src1,dest);

  if op='VAadd' then opNum:=1
  else
  if op='VAsub' then opNum:=2
  else
  if op='VAmul' then opNum:=3
  else
  if op='VAdiv' then opNum:=4;

  with dest do
  for i:=Imin to Imax do
  for j:=Jmin to Jmax do
  begin
    v1:= src1[i,j];
    v2:= src2[i,j];
    v3:= dest[i,j];
    case opNum of
      1: proVadd( v1,v2,v3);
      2: proVsub( v1,v2,v3);
      3: proVmul( v1,v2,v3);
      4: proVdiv( v1,v2,v3);
    end;
  end;

end;

procedure proVAadd(var src1,src2,dest:TvectorArray);
begin
   VAop( src1,src2,dest,'VAadd');
end;

procedure proVAsub(var src1,src2,dest:TvectorArray);
begin
   VAop( src1,src2,dest,'VAsub');
end;

procedure proVAmul(var src1,src2,dest:TvectorArray);
begin
   VAop( src1,src2,dest,'VAmul');
end;

procedure proVAdiv(var src1,src2,dest:TvectorArray);
begin
   VAop( src1,src2,dest,'VAdiv');
end;

procedure proVAmulNum(var src: TvectorArray; num:TfloatComp);
var
  i,j:integer;
  v1:Tvector;
begin
  verifierObjet(typeUO(src));

  with src do
  for i:=Imin to Imax do
  for j:=Jmin to Jmax do
  begin
    v1:= src[i,j];
    proVmulNum(v1,num);
  end;

end;

procedure proVAaddNum(var src: TvectorArray; num:TfloatComp);
var
  i,j:integer;
  v1:Tvector;
begin
  verifierObjet(typeUO(src));

  with src do
  for i:=Imin to Imax do
  for j:=Jmin to Jmax do
  begin
    v1:= src[i,j];
    proVaddNum(v1,num);
  end;

end;



function TVectorArray.nbObj: integer;
var
  i:integer;
begin
  if nbdim>0 then
  begin
    result:=indmax[1]-indmin[1]+1;
    for i:=2 to nbDim do result:=result*(indmax[i]-indmin[i]+1);
  end
  else result:=0;
end;

function TVectorArray.imax: integer;
begin
  if nbDim>0
    then result:= indmax[1]
    else result:= -1;

end;

function TVectorArray.imin: integer;
begin
  if nbDim>0
    then result:= indmin[1]
    else result:= 0;
end;

function TVectorArray.jmax: integer;
begin
  if nbDim>1
    then result:= indmax[2]
    else result:= -1;
end;

function TVectorArray.jmin: integer;
begin
  if nbDim>1
    then result:= indmin[2]
    else result:= 0;
end;

function TVectorArray.nbCol: integer;
begin
  if nbDim>0
    then result:= indmax[1]-indmin[1]+1
    else result:= 0;
end;

function TVectorArray.nblig: integer;
begin
  if nbDim>1
    then result:= indmax[2]-indmin[2]+1
    else result:= 0;
end;

function TVectorArray.Dim(i: integer): integer;
begin
  if (i>0) and (i<=nbDim)
    then result:= indmax[i]-indmin[i]+1
    else result:=0;
end;


// On peut compacter si tous les vecteurs ont la même structure
function TVectorArray.CanCompact: boolean;
var
  i:integer;
  tpNum1: typetypeG;
  i1,i2: integer;
  Dx1, x01, Dy1, y01: double;
begin
  result:= initOK and (nbObj>0);
  if result then
  begin
    with Tvector(uo[0]) do
    begin
      tpNum1:= tpNum;
      i1:= Istart;
      i2:=Iend;
      Dx1:=Dxu;
      x01:=x0u;
      Dy1:=Dyu;
      y01:=y0u;
    end;
    for i:=1 to nbobj-1 do
      with Tvector(uo[i]) do
      if (tpNum1<> tpNum) or( i1<> Istart) or (i2<>Iend) or (Dx1<>Dxu) or(x01<>x0u) or (Dy1<>Dyu) or (y01<>y0u) then
      begin
        result:=false;
        exit;
      end;

    inf.tpNum:= tpNum1;
    Istart:= i1;
    Iend:= i2;
    Dxu:=Dx1;
    x0u:=x01;
    Dyu:=Dy1;
    y0u:=y01;
  end
  else
  begin
    Istart:= 0;
    Iend:= -1;
    Dxu:=1;
    x0u:=0;
    Dyu:=1;
    y0u:=0;
  end;
end;

function TVectorArray.loadData(f: Tstream): boolean;
var
  i,size:integer;
begin
  result:=readDataHeader(f,size);
  if result=false then exit;

  if size<>(Iend-Istart+1)*tailleTypeG[tpNum]*nbObj then exit;

  for i:=0 to nbObj-1 do
  with Tvector(uo[i]) do
    if assigned(data) then data.readBlockFromStream(f,0,Istart,Iend,tpNum);

  modifiedData:=true;
end;



procedure TVectorArray.saveData(f: Tstream);
var
  i,sz:integer;
begin
  if not CanCompact then exit;

  sz:=(Iend-Istart+1)*tailleTypeG[tpNum]*nbObj;
  writeDataHeader(f,sz);
  for i:=0 to nbObj-1 do
  with Tvector(uo[i]) do
    if assigned(data) then data.writeBlockToStream(f,Istart,Iend,tpNum);


end;


Initialization
AffDebug('Initialization stmOdat2',0);
  installError(E_vectorArrayCreate,'TVectorArray.create: invalid parameter');
  installError(E_lineWidth,'TvectorArray: invalid line width');

  installError(E_indice,'TvectorArray: index out of range');

  installError(E_typeVector,'TvectorArray.initVectors: Type not supported');

  registerObject(TVectorArray,data);
end.
