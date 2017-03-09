unit stmmatA1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,graphics,sysutils,
     util1,Dgraphic,stmdef,stmObj,varconf1,debug0,
     stmvec1,stmMat1,matCood0,
     stmOdat2,visu0,
     Ncdef2,stmError,stmPg;

type
  TmatrixArray=
    class(TvectorArray)

    protected
      FdegP:typeDegre; {theta fait double emploi avec visu.theta}

      FpalName:AnsiString;

      procedure setTheta(x:single);
      procedure setAspectRatio(x:single);
      procedure setGamma(x:single);
      procedure setTwoCol(x:boolean);

      procedure setKeepRatio(w:boolean);override;

      procedure setPalColor(n:integer;x:integer);
      function getPalColor(n:integer):integer;

      procedure setDisplayMode(n:byte);
      procedure setPalName(st:AnsiString);

      function CanCompact: boolean;virtual;
      procedure saveData(f:Tstream);override;
      function loadData(f:Tstream):boolean;override;

    public
      property theta:single read FdegP.theta write setTheta;
      property Gamma:single read visu.gamma write setGamma;
      property TwoCol:boolean read visu.twoCol write setTwoCol;
      property PalColor[n:integer]:integer read getPalColor write setPalColor;
      property DisplayMode:byte read visu.modeMat write setDisplayMode;
      property PalName:AnsiString read FpalName write setPalName;


      class function STMClassName:AnsiString;override;

      constructor create;override;

      procedure initMatrix(tNombre:typetypeG;i1,i2,j1,j2:integer);
      function Matrix(i,j:integer):TMatrix;

      function ChooseCoo1:boolean;override;

      procedure AutoScaleY;      override;
      procedure cadrerY(sender:Tobject);override;
      procedure AutoScaleZ;      override;
      procedure AutoScaleZsym;
      procedure cadrerZ(sender:Tobject);override;
      procedure cadrerC(sender:Tobject);override;
      procedure updateVectorParams;override;

      procedure getMinMaxI(var Vmin,Vmax:integer);
      procedure getMinMax(var Vmin,Vmax:float);

      procedure buildMap(mat:Tmatrix;i1,i2,j1,j2:integer;mode:integer);
      procedure buildMap1(mat:Tmatrix;i1,i2,j1,j2:integer;Vmoy,Vsig:float;
                          mode:integer;Fabove:boolean);

      procedure buildVectorArray(VA:TvectorArray;i1,i2:integer);

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure completeLoadInfo;override;
      procedure reinit;override;
      function BuildIdent(k:integer): string;override;

      procedure saveToStream( f:Tstream;Fdata:boolean);override;
      function  loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;
    end;


procedure proTMatrixArray_create(name:AnsiString;i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTMatrixArray_create_1(i1,i2,j1,j2:integer;var pu:typeUO);pascal;
procedure proTMatrixArray_initObjects(tn:integer;i1,i2,j1,j2:longint;var pu:typeUO);pascal;
function fonctionTMatrixArray_M(i,j:integer;var pu:typeUO):pointer;pascal;
procedure proTMatrixArray_modify(i1,i2,j1,j2:integer;var pu:typeUO);pascal;

function fonctionTMatrixArray_Jstart(var pu:typeUO):longint;pascal;
function fonctionTMatrixArray_Jend(var pu:typeUO):longint;pascal;
function fonctionTMatrixArray_Ystart(var pu:typeUO):float;pascal;
function fonctionTMatrixArray_Yend(var pu:typeUO):float;pascal;

procedure proTMatrixArray_AutoscaleZ(var pu:typeUO);pascal;
procedure proTMatrixArray_AutoscaleZsym(var pu:typeUO);pascal;


procedure proTmatrixArray_Dz(x:float;var pu:typeUO);pascal;
function fonctionTmatrixArray_Dz(var pu:typeUO):float;pascal;

procedure proTmatrixArray_Z0(x:float;var pu:typeUO);pascal;
function fonctionTmatrixArray_Z0(var pu:typeUO):float;pascal;

function FonctionTmatrixArray_convZ(i:longint;var pu:typeUO):float;pascal;
function FonctionTmatrixArray_invconvZ(x:float;var pu:typeUO):longint;pascal;

procedure proTmatrixArray_getMinMaxI(var Vmin,Vmax:longint;var pu:typeUO);pascal;
procedure proTmatrixArray_getMinMax(var Vmin,Vmax:float;var pu:typeUO);pascal;

function fonctionTmatrixArray_Zmin(var pu:typeUO):float;pascal;
procedure proTmatrixArray_Zmin(x:float;var pu:typeUO);pascal;

function fonctionTmatrixArray_Zmax(var pu:typeUO):float;pascal;
procedure proTmatrixArray_Zmax(x:float;var pu:typeUO);pascal;


function fonctionTmatrixArray_theta(var pu:typeUO):float;pascal;
procedure proTmatrixArray_theta(x:float;var pu:typeUO);pascal;

function fonctionTmatrixArray_AspectRatio(var pu:typeUO):float;pascal;
procedure proTmatrixArray_AspectRatio(x:float;var pu:typeUO);pascal;

function fonctionTmatrixArray_PixelRatio(var pu:typeUO):float;pascal;
procedure proTmatrixArray_PixelRatio(x:float;var pu:typeUO);pascal;

function fonctionTmatrixArray_gamma(var pu:typeUO):float;pascal;
procedure proTmatrixArray_gamma(x:float;var pu:typeUO);pascal;

function fonctionTmatrixArray_TwoColors(var pu:typeUO):boolean;pascal;
procedure proTmatrixArray_TwoColors(x:boolean;var pu:typeUO);pascal;

function fonctionTmatrixArray_PalColor(n:integer;var pu:typeUO):integer;pascal;
procedure proTmatrixArray_PalColor(n:integer;x:integer;var pu:typeUO);pascal;

procedure proTmatrixArray_PalName(x:AnsiString;var pu:typeUO);pascal;
function fonctionTmatrixArray_PalName(var pu:typeUO):AnsiString;pascal;

procedure proTmatrixArray_DisplayMode(x:integer;var pu:typeUO);pascal;
function fonctionTmatrixArray_DisplayMode(var pu:typeUO):integer;pascal;

procedure proTmatrixArray_buildMap(var mat: Tmatrix;
              i1, i2, j1, j2: integer;mode:integer;var pu:typeUO);pascal;

procedure proTmatrixArray_buildMap1(var mat: Tmatrix;
              i1, i2, j1, j2: integer;Vmoy,Vsig:float;
              mode:integer;Fabove:boolean;var pu:typeUO);pascal;


procedure proTmatrixArray_BuildVectorArray(var VA:TvectorArray;i1,i2:integer;
                                           var pu:typeUO);pascal;


implementation

constructor TmatrixArray.create;
begin
  inherited;
  visu.color:=longint(2) shl 16+1;
  keepRatio:=true;

  UObase:=Tmatrix;
end;

class function TMatrixArray.STMClassName:AnsiString;
begin
  STMClassName:='MatrixArray';
end;


procedure TMatrixArray.initMatrix(tNombre:typeTypeG;i1,i2,j1,j2:integer);
var
  i,j,k:integer;
begin
  inf.Imin:=i1;
  inf.Imax:=i2;
  inf.Jmin:=j1;
  inf.Jmax:=j2;

  for k:= 0 to nbobj-1 do
    begin
      uo^[k].free;  
      uo^[k]:=TMatrix.create;
      TMatrix(uo^[k]).initTemp(i1,i2,j1,j2,tnombre);

      uo^[k].Fchild:=true;
      uo^[k].ident:= BuildIdent(k);
    end;

  initChildList;

  autoscaleX;
  autoscaleY;
  updateVectorParams;
end;

function TMatrixArray.Matrix(i,j:integer):TMatrix;
  begin
    if (nbdim=2) and  (i>=imin) and (i<=imax) and (j>=jmin) and (j<=jmax) and assigned(uo)
     then result:=TMatrix(uo^[nblig*(i-imin)+j-jmin])
     else result:=nil;
  end;


procedure TmatrixArray.updateVectorParams;
var
  i:integer;
begin
  inherited;
  if not initOK then exit;

  for i:=0 to nbObj-1 do
    begin
      Tmatrix(uo^[i]).palname:=palname;
      Tmatrix(uo^[i]).degP:=FdegP;
    end;

end;

function TmatrixArray.ChooseCoo1:boolean;
  var
    title0:AnsiString;
    palName0:AnsiString;
  begin
    InitVisu0;

    title0:=title;
    palName0:=palName;

    if Matcood.choose(title0,visu0^,palName0,nil,FdegP,cadrerX,cadrerY,cadrerZ,cadrerC) then
      begin
        result:= not visu.compare(visu0^) or (title<>title0)
              or (palName0<>palName);
        visu.assign(visu0^);
        title:=title0;
        palName:=palName0;
      end
    else result:=false;

    DoneVisu0;

    if result then updateVectorParams;
  end;


procedure TmatrixArray.AutoScaleY;
var
  i:integer;
  y1,y2:float;
begin
  if not initOK then exit;

  y1:=1E20;
  y2:=-1E20;

  for i:=0 to nbobj-1 do
    begin
      if Tmatrix(uo^[i]).Ystart<y1
        then y1:=Tmatrix(uo^[i]).Ystart;
      if Tmatrix(uo^[i]).Yend>y2
        then y2:=Tmatrix(uo^[i]).Yend;
    end;

  if y2>=y1 then
  begin
    visu.Ymin:=y1;
    visu.Ymax:=y2;
  end;

  updateVectorParams;
end;

procedure TmatrixArray.AutoScaleZ;
var
  i:integer;
  Vmin,Vmax:float;
begin
  if not initOK then exit;

  Vmin:=1E20;
  Vmax:=-1E20;
  getMinMax(Vmin,Vmax);
  Zmin:=Vmin;
  Zmax:=Vmax;
end;

procedure TmatrixArray.AutoScaleZsym;
var
  i:integer;
  Vmin,Vmax:float;
begin
  if not initOK then exit;

  Vmin:=1E20;
  Vmax:=-1E20;
  getMinMax(Vmin,Vmax);

  if abs(Vmin)<abs(Vmax) then
    begin
      Zmin:=-abs(Vmax);
      Zmax:=abs(Vmax);
    end
  else
    begin
      Zmin:=-abs(Vmin);
      Zmax:=abs(Vmin);
    end;
end;


procedure TmatrixArray.cadrerY(sender:Tobject);
begin
  visu0^.Ymin:=Ystart;
  visu0^.Ymax:=Yend;
  updateVectorParams;
end;


procedure TmatrixArray.cadrerZ(sender:Tobject);
var
  Vmin,Vmax:float;
begin
  if not initOK then exit;
  Vmin:=1E300;
  Vmax:=-1E300;
  getMinMax(Vmin,Vmax);
  visu0^.Zmin:=Vmin;
  visu0^.Zmax:=Vmax;
end;

procedure TmatrixArray.cadrerC(sender:Tobject);
begin
end;

procedure TmatrixArray.getMinMaxI(var Vmin,Vmax:integer);
var
  i:integer;
begin
  if not initOK then exit;

  for i:=0 to nbObj-1 do Tmatrix(uo^[i]).getMinMaxI(Vmin,Vmax);
end;

procedure TmatrixArray.getMinMax(var Vmin,Vmax:float);
var
  i:integer;
begin
  if not initOK then exit;

  for i:=0 to nbObj-1 do Tmatrix(uo^[i]).getMinMax(Vmin,Vmax);
end;


procedure TmatrixArray.setTheta(x:single);
var
  i:integer;
begin
  if not initOK then exit;

  FdegP.theta:=x;
  for i:=0 to nbObj-1 do Tmatrix(uo^[i]).theta:=x;
end;

procedure TmatrixArray.setAspectRatio(x:single);
var
  i:integer;
begin
  if not initOK then exit;
  inherited aspectRatio:=x;
  for i:=0 to nbObj-1 do Tmatrix(uo^[i]).aspectRatio:=x;
end;

procedure TmatrixArray.setGamma(x:single);
var
  i:integer;
begin
  if not initOK then exit;
  visu.gamma:=x;
  for i:=0 to nbObj-1 do Tmatrix(uo^[i]).gamma:=x;
end;

procedure TmatrixArray.setTwoCol(x:boolean);
var
  i:integer;
begin
  if not initOK then exit;
  visu.twoCol:=x;
  for i:=0 to nbObj-1 do Tmatrix(uo^[i]).twoCol:=x;
end;

procedure TmatrixArray.setKeepRatio(w:boolean);
var
  i:integer;
begin
  if not initOK then exit;
  inherited setKeepRatio(w);
  for i:=0 to nbObj-1 do
    Tmatrix(uo^[i]).KeepRatio:=w;
end;


procedure TmatrixArray.setPalColor(n:integer;x:integer);
var
  i:integer;
begin
  if not initOK then exit;

  case n of
    1:TmatColor(visu.Color).col1:=x;
    2:TmatColor(visu.Color).col2:=x;
  end;
  for i:=0 to nbObj-1 do Tmatrix(uo^[i]).PalColor[n]:=x;
end;

function TmatrixArray.getPalColor(n:integer):integer;
begin
  case n of
    1:result:=TmatColor(visu.Color).col1;
    2:result:=TmatColor(visu.Color).col2;
  end;
end;

procedure TmatrixArray.setDisplayMode(n:byte);
var
  i:integer;
begin
  if not initOK then exit;
  visu.modeMat:=n;
  for i:=0 to nbObj-1 do Tmatrix(uo^[i]).DisplayMode:=n;
end;

procedure TmatrixArray.setPalName(st:AnsiString);
var
  i:integer;
begin
  if not initOK then exit;
  FpalName:=st;
  for i:=0 to nbObj-1 do Tmatrix(uo^[i]).PalName:=st;
end;



procedure TmatrixArray.buildMap(mat: Tmatrix; i1, i2, j1, j2: integer;mode:integer);
var
  i,j:integer;
begin
  if not initOK then exit;
  if (i1<Istart) or (i2<i1) or (Iend<i2) then exit;
  if (j1<Jstart) or (j2<j1) or (Jend<j2) then exit;

  mat.initTemp(Imin,Imax,Jmin,Jmax,mat.tpNum);

  case mode of
    0: for i:=imin to Imax do
         for j:=Jmin to Jmax do
           mat.Zvalue[i,j]:=matrix(i,j).sum(i1,i2,j1,j2);
    1: for i:=imin to Imax do
         for j:=Jmin to Jmax do
           mat.Zvalue[i,j]:=matrix(i,j).sumSqrs(i1,i2,j1,j2);
    2: for i:=imin to Imax do
         for j:=Jmin to Jmax do
           mat.Zvalue[i,j]:=matrix(i,j).sumMdls(i1,i2,j1,j2);

  end;
end;

procedure TmatrixArray.buildMap1(mat:Tmatrix;i1,i2,j1,j2:integer;Vmoy,Vsig:float;
                                 mode:integer;Fabove:boolean);
var
  i,j:integer;
  z,seuil1,seuil2:float;
begin
  if not initOK then exit;
  if (i1<Istart) or (i2<i1) or (Iend<i2) then exit;
  if (j1<Jstart) or (j2<j1) or (Jend<j2) then exit;

  mat.initTemp(Imin,Imax,Jmin,Jmax,mat.tpNum);

  if Fabove
    then seuil1:=-1E100
    else seuil1:=Vmoy-Vsig;

  seuil2:=Vmoy+Vsig;

  for i:=imin to Imax do
  for j:=Jmin to Jmax do
    begin
      case mode of
        0: z:=matrix(i,j).sum(i1,i2,j1,j2);
        1: z:=matrix(i,j).sumSqrs(i1,i2,j1,j2);
        2: z:=matrix(i,j).sumMdls(i1,i2,j1,j2);
      end;
      if (z<seuil1) or (z>seuil2) then
        begin
          if Vsig<>0
            then mat.Zvalue[i,j]:=(z-Vmoy)/Vsig
            else mat.Zvalue[i,j]:=z-Vmoy;
        end
      else mat.Zvalue[i,j]:=0;
    end;
end;


procedure TmatrixArray.buildVectorArray(VA: TvectorArray; i1, i2:integer);
var
  i,j,k:integer;
  i1o,i2o,j1o,j2o:integer;

begin
  if not initOK then exit;
  if (i1<Istart) or (i2<i1) or (Iend<i2) then exit;

  i1o:=VA.IdispMin;
  i2o:=VA.IdispMax;
  j1o:=VA.JdispMin;
  j2o:=VA.JdispMax;

  VA.initArray(Imin,Imax,Jmin,Jmax) ;

  VA.IdispMin:=i1o;
  VA.IdispMax:=i2o;
  VA.JdispMin:=j1o;
  VA.JdispMax:=j2o;

  VA.initVectors(Jstart,Jend,VA.tpNum );

  for i:=imin to Imax do
  for j:=Jmin to Jmax do
  for k:=Jstart to Jend do
    va[i,j].Yvalue[k]:=matrix(i,j).sum(i1,i2,k,k);
end;

procedure TmatrixArray.BuildInfo(var conf: TblocConf; lecture,
  tout: boolean);
begin
  inherited;

  with conf do
  begin          
    setvarconf('FdegP',FdegP,sizeof(FdegP));
    setStringConf('FpalName',FpalName);
  end;
end;

procedure TmatrixArray.completeLoadInfo;
begin
  inherited;

end;

procedure TmatrixArray.reinit;
begin
  initArray(imin,imax,Jmin,Jmax);
  initMatrix(tpNum,Istart,Iend,Jstart,Jend);

end;

function TmatrixArray.BuildIdent(k:integer): string;  // k commence à zéro
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

  result:=   ident+'.m['+Istr(indmin[1]+k)+ result;
end;


procedure TmatrixArray.saveToStream( f:Tstream;Fdata:boolean);
var
  i:integer;
  conf:TblocConf;
begin
  Fcompact:= CanCompact;
  saveToStreamBase(f,Fdata); // calls the typeUO procedure

  if FCompact and Fdata then saveData(f)
  else
  if initOK then
    for i:=0 to nbobj-1 do Tmatrix(uo[i]).saveToStream(f,Fdata);
end;


function  TmatrixArray.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  st1,stID:AnsiString;
  LID:integer;
  posIni:LongWord;
  i,j:integer;
  v11:Tmatrix;

begin
  result:= loadFromStreamBase(f,size,false);  // calls the typeUO procedure
  if not result OR (f.position>=f.size) then exit;

  reinit;

  if Fcompact and Fdata then
  begin
    result:=loadData(f);
    setChildNames;
    for i:=0 to nbobj-1 do Tmatrix(uo[i]).visu.assign(visu);
    exit;
  end;

  stID:=ident;
  LID:=length(ident);
  posIni:=f.position;

  for i:=0 to nbobj-1 do
  begin
    st1:=readHeader(f,size);

    if (st1=UObase.STMClassName) then
    with Tmatrix(uo[i]) do
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

  v11:= Tmatrix(uo[0]);
  if assigned(v11) then
  begin
    inf.imin:=  v11.Istart;
    inf.imax:=  v11.Iend;
    inf.jmin:=  v11.Jstart;
    inf.jmax:=  v11.Jend;
    inf.dxu:=   v11.Dxu;
    inf.x0u:=   v11.x0u;
    inf.dyu:=   v11.dyu;
    inf.y0u:=   v11.y0u;
    inf.tpNum:= v11.tpNum;
  end;

end;

{***********************  Méthodes STM de TMatrixArray ********************}

var
  E_MatrixArrayCreate:integer;
  E_indice:integer;
  E_typeVector:integer;
  E_typeMatrix:integer;
  E_buildMap:integer;

procedure proTMatrixArray_create(name:AnsiString;i1,i2,j1,j2:integer;var pu:typeUO);
begin
  createPgObject(name,pu,TMatrixArray);

  controleParam(i1,-16000,16000,E_MatrixArrayCreate);
  controleParam(i2,i1,i1+16000,E_MatrixArrayCreate);
  controleParam(j1,-16000,16000,E_MatrixArrayCreate);
  controleParam(j2,j1,j1+16000,E_MatrixArrayCreate);

  with TMatrixArray(pu) do initArray(i1,i2,j1,j2);
end;

procedure proTMatrixArray_create_1(i1,i2,j1,j2:integer;var pu:typeUO);
begin
  proTMatrixArray_create('',i1,i2,j1,j2, pu);
end;  

procedure proTMatrixArray_initObjects(tn:integer;i1,i2,j1,j2:longint;var pu:typeUO);
begin
  if not Tmatrix.supportType(typeTypeG(tn))
    then sortieErreur(E_typeMatrix);

  verifierObjet(pu);
  with TMatrixArray(pu) do iniTMatrix(typeTypeG(tn),i1,i2,j1,j2);
end;



function fonctionTMatrixArray_M(i,j:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);

  with TMatrixArray(pu) do
  begin
    ControleParam(i,Imin,Imax,E_indice);
    ControleParam(j,Jmin,Jmax,E_indice);
    result:=@uo^[nblig*(i-imin)+j-jmin];
  end;
end;

procedure proTMatrixArray_modify(i1,i2,j1,j2:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  controleParametre(i1,-16000,16000);
  controleParametre(i2,i1,i1+16000);
  controleParametre(j1,-16000,16000);
  controleParametre(j2,j1,j1+16000);

  with TMatrixArray(pu) do initArray(i1,i2,j1,j2);
end;

function fonctionTMatrixArray_Jstart(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  result:= TmatrixArray(pu).Jstart;
end;

function fonctionTMatrixArray_Jend(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  result:= TmatrixArray(pu).Jend;
end;

function fonctionTMatrixArray_Ystart(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:= TmatrixArray(pu).Ystart;
end;

function fonctionTMatrixArray_Yend(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:= TmatrixArray(pu).Yend;;
end;

procedure proTMatrixArray_AutoscaleZ(var pu:typeUO);
begin
  verifierObjet(pu);
  TmatrixArray(pu).autoscaleZ;
end;

procedure proTMatrixArray_AutoscaleZsym(var pu:typeUO);
begin
  verifierObjet(pu);
  TmatrixArray(pu).autoscaleZsym;
end;


procedure proTmatrixArray_Dz(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    if x=0 then sortieErreur(E_parametre);
    TmatrixArray(pu).Dzu:=x;
  end;

function fonctionTmatrixArray_Dz(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrixArray_Dz:=TmatrixArray(pu).Dzu;
  end;

procedure proTmatrixArray_Z0(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TmatrixArray(pu).Z0u:=x;
  end;

function fonctionTmatrixArray_Z0(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrixArray_z0:=TmatrixArray(pu).Z0u;
  end;


function FonctionTmatrixArray_convZ(i:longint;var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrixArray_convZ:=TmatrixArray(pu).convZ(i);
  end;

function FonctionTmatrixArray_invconvZ(x:float;var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    fonctionTmatrixArray_invconvZ:=TmatrixArray(pu).invconvZ(x);
  end;


procedure proTmatrixArray_getMinMaxI(var Vmin,Vmax:longint;var pu:typeUO);
  begin
    verifierObjet(pu);
    TmatrixArray(pu).getMinMaxI(Vmin,Vmax);
  end;

procedure proTmatrixArray_getMinMax(var Vmin,Vmax:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TmatrixArray(pu).getMinMax(Vmin,Vmax);
  end;


function fonctionTmatrixArray_Zmin(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrixArray_Zmin:=TmatrixArray(pu).Zmin;
  end;

procedure proTmatrixArray_Zmin(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TmatrixArray(pu).Zmin:=x;
  end;

function fonctionTmatrixArray_Zmax(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrixArray_Zmax:=TmatrixArray(pu).Zmax;
  end;

procedure proTmatrixArray_Zmax(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TmatrixArray(pu).Zmax:=x;
  end;



function fonctionTmatrixArray_theta(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrixArray_theta:=TmatrixArray(pu).theta;
  end;

procedure proTmatrixArray_theta(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TmatrixArray(pu).theta:=x;
  end;

function fonctionTmatrixArray_AspectRatio(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrixArray_AspectRatio:=TmatrixArray(pu).AspectRatio;
  end;

procedure proTmatrixArray_AspectRatio(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TmatrixArray(pu).AspectRatio:=x;
  end;

function fonctionTmatrixArray_PixelRatio(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TmatrixArray(pu).PixelRatio;
  end;

procedure proTmatrixArray_PixelRatio(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TmatrixArray(pu).PixelRatio:=x;
  end;


function fonctionTmatrixArray_gamma(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTmatrixArray_gamma:=TmatrixArray(pu).gamma;
  end;

procedure proTmatrixArray_gamma(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TmatrixArray(pu).gamma:=x;
  end;

function fonctionTmatrixArray_TwoColors(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    fonctionTmatrixArray_TwoColors:=TmatrixArray(pu).TwoCol;
  end;

procedure proTmatrixArray_TwoColors(x:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    TmatrixArray(pu).TwoCol:=x;
  end;

function fonctionTmatrixArray_PalColor(n:integer;var pu:typeUO):integer;
  begin
    verifierObjet(pu);
    controleParametre(n,1,2);
    result:=TmatrixArray(pu).PalColor[n];
  end;

procedure proTmatrixArray_PalColor(n:integer;x:integer;var pu:typeUO);
  begin
    verifierObjet(pu);
    controleParametre(n,1,2);
    TmatrixArray(pu).PalColor[n]:=  x;
  end;

procedure proTmatrixArray_DisplayMode(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatrixArray(pu).DisplayMode:=x;
end;

function fonctionTmatrixArray_DisplayMode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TmatrixArray(pu).DisplayMode;
end;

procedure proTmatrixArray_PalName(x:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatrixArray(pu).PalName:=x;
end;

function fonctionTmatrixArray_PalName(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TmatrixArray(pu).PalName;
end;

procedure proTmatrixArray_buildMap(var mat: Tmatrix; i1, i2, j1, j2: integer;mode:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUo(mat));

  With TmatrixArray(pu) do
  if (i1<Istart) or (i1>Iend) or
     (i2<Istart) or (i2>Iend) or
     (j1<Jstart) or (j1>Jend) or
     (j2<Jstart) or (j2>Jend)
    then sortieErreur(E_buildMap);

  TmatrixArray(pu).buildMap(mat,i1, i2, j1, j2,mode);
end;

procedure proTmatrixArray_buildMap1(var mat: Tmatrix;
              i1, i2, j1, j2: integer;Vmoy,Vsig:float;mode:integer;Fabove:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUo(mat));

  With TmatrixArray(pu) do
  if (i1<Istart) or (i1>Iend) or
     (i2<Istart) or (i2>Iend) or
     (j1<Jstart) or (j1>Jend) or
     (j2<Jstart) or (j2>Jend)
    then sortieErreur(E_buildMap);


  TmatrixArray(pu).buildMap1(mat,i1, i2, j1, j2,Vmoy,Vsig,mode,Fabove);
end;


procedure proTmatrixArray_BuildVectorArray(var VA:TvectorArray;i1,i2:integer;
                                           var pu:typeUO);pascal;
begin
  verifierObjet(pu);
  verifierObjet(typeUo(va));

  TmatrixArray(pu).buildVectorArray(va, i1, i2);
end;


// On peut compacter si tous les vecteurs ont la même structure
function TMatrixArray.CanCompact: boolean;
var
  i:integer;
  tpNum1: typetypeG;
  i1,i2,j1,j2: integer;
  Dx1, x01, Dy1, y01: double;
begin
  result:=inherited CanCompact;
  if result then
  begin
    with TMatrix(uo[0]) do
    begin
      j1:= Jstart;
      j2:= Jend;
    end;
    for i:=1 to nbobj-1 do
      with TMatrix(uo[i]) do
      if (j1<>Jstart) or (j2<>Jend) or FContour then
      begin
        result:=false;
        exit;
      end;
    Jstart:= j1;
    Jend:= j2;
  end
  else
    if not(initOK and (nbObj>0)) then
      begin
        Jstart:= 0;
        Jend:= -1;
      end;
end;

function TMatrixArray.loadData(f: Tstream): boolean;
var
  i,size:integer;
begin
  result:=readDataHeader(f,size);
  if result=false then exit;

  if size<>(Iend-Istart+1)*(Jend-Jstart+1)*tailleTypeG[tpNum]*nbObj then exit;

  for i:=0 to nbObj-1 do
  with Tmatrix(uo[i]) do
    if assigned(data) then data.loadFromStream(f);

  modifiedData:=true;
end;



procedure TMatrixArray.saveData(f: Tstream);
var
  i,sz:integer;
begin
  if not CanCompact then exit;

  sz:=(Iend-Istart+1)*(Jend-Jstart+1)*tailleTypeG[tpNum]*nbObj;
  writeDataHeader(f,sz);
  for i:=0 to nbObj-1 do
  with TMatrix(uo[i]) do
    if assigned(data) then data.saveToStream(f);
end;

Initialization
AffDebug('Initialization stmmatA1',0);
  registerObject(TmatrixArray,data);

  installError(E_MatrixArrayCreate,'TMatrixArray.create: invalid parameter');

  installError(E_indice,'TMatrixArray: index out of range');

  installError(E_typeMatrix,'TMatrixArray.initMatrix: Type not supported');
  installError(E_buildMap,'TMatrixArray.buildMap: index out of range');


end.
