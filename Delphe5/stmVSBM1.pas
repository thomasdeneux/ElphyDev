unit stmVSBM1;

{ mars 2015 TVSbitmap implémente une texture BMtexture compatible avec Cuda (D3DPOOL_DEFAULT),
            donc, l'accès direct avec lock est impossible.
            Pour la charger à partir d'un fichier, on charge une autre texture BMtexture0 ( D3DPOOL_MANAGED )
            que l'on copie ensuite dans BMtexture

  Pour
}

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, classes,stdCtrls,graphics,sysutils,math,
     editCont,
     {$IFDEF DX11}
     {$ELSE}
     Direct3D9G, D3DX9G,
     {$ENDIF}

     DibG,
     util1,Dgraphic,debug0,Gdos,listG,
     stmDef,stmObj,stmobv0,varconf1,Ncdef2,stmError,

     defForm,Dpalette,sysPal32,stmPg,getVSBM1,
     stmMat1,
     D7random1,
     cuda1;


type
  TBMVertex = packed record
    x, y, z: Single; // The untransformed position for the vertex
    color: DWORD;    // The vertex color
    u,v: single;
  end;

  TBMvertexArray= array[0..1000] of TBMVertex;
  PBMvertexArray = ^TBMvertexArray;

const
  BMVertexCte = D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1;

type
  TVSbitmap=
          class(Tresizable)
            vertices: PBMVertexArray;
            CurrentCol:integer;

            x0,y0:single;
            theta0: single;
            stFile:AnsiString;
            fileOK:boolean;

            Frandom,Fmix:boolean;
            Rlist:TlistG;
            NxG,NyG,dxG,dyG:integer;

            Hdib:Tdib;
            Alpha: array of array of byte;

            dxBM, dyBM: single;  // dimensions réelles du bitmap
                                 // imageWidth, imageHeight
            BMTexture: IDirect3DTexture9;

            FTileMode:boolean;
            FBorderMode:Boolean;
            BorderColor:longWord;
            Ag:single;

            BMCudaResource: pointer;
            RegisterCount:integer;
            MapResourceCount:integer;

            FblendCurrentAlpha:boolean;

            FilterMode:integer;

            constructor create;override;
            destructor destroy;override;
            class function STMClassName:AnsiString;override;

            procedure CreateBMtexture;
            procedure LoadTextureFromDib;
            function ResourceNeeded:boolean;override;

            procedure freeBM;override;
            procedure BuildResource;override;
            procedure Blt(const degV: typeDegre);override;
            procedure store2(var NV:integer;Ax,Ay:float;Const Falloc:boolean=false);override;

            function DialogForm:TclassGenForm;override;
            procedure installDialog(var form:Tgenform;var newF:boolean);
                                   override;


            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
            procedure CompleteLoadInfo;override;
            function getInfo:AnsiString;override;

            procedure AlphaDefault;
            function LoadFromFile(st:AnsiString):boolean;
            function LoadFromMatrix(mat:Tmatrix;Const UseVSlum:boolean=false):boolean;
            function LoadAlphaFromMatrix(mat:Tmatrix;Freal:boolean):boolean;
            function SAveToMatrix(mat:Tmatrix):boolean;

            procedure initRandom(dx1,dy1:integer);
            procedure doneRandom;
            procedure randomizeRlist(seed:integer);
            procedure drawRandom(x,y,xs,ys:integer);
            procedure drawRandom2(x,y,xs,ys:integer);

            procedure setPixel(x,y:integer;w:Dword);
            function getPixel(x,y:integer):Dword;
            property Pixels[x,y:integer]:Dword read getPixel write setPixel;

            function getParamAd(name:AnsiString; var tp: typeNombre): pointer;override;
            procedure VerifyPixelPos(x,y:integer);
            function Width: integer;
            function height: integer;

            procedure registerCuda;
            procedure UnRegisterCuda;
            procedure MapResource;
            procedure UnMapResource;

            procedure initBM(w,h:integer);
            procedure fillLum(Alum,AnAlpha:single);

            procedure DisplayVSBM(source: TVSbitmap; x0, y0, theta: single; AlphaMode,LumMode:integer;
                                             Alpha1,Alpha2, Lum1,Lum2: float);

            function PixSum(comp,ref:integer):integer;
          end;



procedure proTVSbitmap_create(var pu:typeUO);pascal;
procedure proTVSbitmap_create_1(name:AnsiString;var pu:typeUO);pascal;

procedure proTVSbitmap_fileName(ww:AnsiString;var pu:typeUO);pascal;
function fonctionTVSbitmap_fileName(var pu:typeUO):AnsiString;pascal;
procedure proTVSbitmap_x0(ww:float;var pu:typeUO);            pascal;
function fonctionTVSbitmap_x0(var pu:typeUO):float;         pascal;
procedure proTVSbitmap_y0(ww:float;var pu:typeUO);            pascal;
function fonctionTVSbitmap_y0(var pu:typeUO):float;         pascal;

procedure proTVSbitmap_theta0(ww:float;var pu:typeUO);pascal;
function fonctionTVSbitmap_theta0(var pu:typeUO):float;pascal;

procedure proTVSbitmap_Pixels(x, y: integer; w: Dword;var pu:typeUO);pascal;
function fonctionTVSbitmap_Pixels(x, y: integer;var pu:typeUO):Dword;pascal;

function fonctionTVSbitmap_width(var pu:typeUO):integer;         pascal;
function fonctionTVSbitmap_height(var pu:typeUO):integer;         pascal;

procedure proTVSbitmap_PixLum(x,y: integer; w: Float;var pu:typeUO);pascal;
function fonctionTVSbitmap_PixLum(x,y: integer;var pu:typeUO):float;pascal;

procedure proTVSbitmap_saveToFile(stF:AnsiString;var pu:typeUO);pascal;
procedure proTVSbitmap_setBounds(Awidth,Aheight:integer;var pu:typeUO);pascal;


function fonctionTVSbitmap_LoadFromMatrix(var mat: Tmatrix;var pu:typeUO): boolean;pascal;
function fonctionTVSbitmap_LoadFromMatrix_1(var mat: Tmatrix;UseVSlum:boolean;var pu:typeUO): boolean;pascal;

function fonctionTVSbitmap_LoadAlphaFromMatrix(var mat: Tmatrix;FReal: boolean;var pu:typeUO): boolean;pascal;
function fonctionTVSbitmap_SaveToMatrix(var mat: Tmatrix;var pu:typeUO): boolean;pascal;


function fonctionTVSbitmap_ImageWidth(var pu:typeUO):float;pascal;
procedure proTVSbitmap_ImageWidth(w:float; var pu:typeUO);pascal;

function fonctionTVSbitmap_ImageHeight(var pu:typeUO):float;pascal;
procedure proTVSbitmap_ImageHeight(w:float; var pu:typeUO);pascal;

function fonctionTVSbitmap_Dx0(var pu:typeUO):float;pascal;
procedure proTVSbitmap_Dx0(w:float; var pu:typeUO);pascal;

function fonctionTVSbitmap_Dy0(var pu:typeUO):float;pascal;
procedure proTVSbitmap_Dy0(w:float; var pu:typeUO);pascal;


function fonctionTVSbitmap_TileMode(var pu:typeUO):boolean;pascal;
procedure proTVSbitmap_TileMode(w:boolean; var pu:typeUO);pascal;

procedure proTVSbitmap_SetBorderLum(lum1, alpha1:float ; var pu:typeUO);pascal;
procedure proTVSbitmap_ReSetBorderLum( var pu:typeUO);pascal;

procedure proTVSbitmap_LumFactor(w:float ; var pu:typeUO);pascal;
function fonctionTVSbitmap_LumFactor(var pu:typeUO): float;pascal;

procedure proTVSbitmap_AlphaIsLumFactor(w:boolean ; var pu:typeUO);pascal;
function fonctionTVSbitmap_AlphaIsLumFactor(var pu:typeUO): boolean;pascal;

procedure proTVSbitmap_fillLum(Alum, AnAlpha: float;var pu:typeUO);pascal;
procedure proTVSbitmap_DisplayVSBM(var source: TVSbitmap; x0, y0, theta: float;
                                   AlphaMode,LumMode:integer;
                                   Alpha1,Alpha2, Lum1,Lum2: float; var pu:typeUO);pascal;

function fonctionTVSbitmap_PixSum(comp,ref:integer; var pu:typeUO): integer;pascal;


function fonctionTVSbitmap_FilterMode(var pu:typeUO):integer;pascal;
procedure proTVSbitmap_FilterMode(w:integer; var pu:typeUO);pascal;

implementation

{ TVSbitmap }

constructor TVSbitmap.create;
begin
  inherited;

  //noTheta:=true;
  Rlist:=TlistG.create(sizeof(Trect));
  hdib:=Tdib.Create;

  FTileMode:=true;

  dxBM:=40;
  dyBM:=30;
  
  Ag:=-1;
  FilterMode:=2;  // 1= nearest  2= linear  3= anisotropic

end;

destructor TVSbitmap.destroy;
begin
  Rlist.free;
  hdib.free;
  inherited;
end;

class function TVSbitmap.STMClassName: AnsiString;
begin
  result:='VSbitmap';
end;



function TVSbitmap.ResourceNeeded: boolean;
begin
  result:= (VB=nil) or (BMtexture=nil );
end;



// appelé dans buildResource ou initMvt/doneMvt
procedure TVSbitmap.CreateBMtexture;
var
  res:integer;
begin
  if not assigned(hdib) then exit;

  res:=D3DXCreateTexture(DXscreen.Idevice,hdib.width,hdib.height,0,0,D3DFMT_A8R8G8B8,D3DPOOL_DEFAULT,BMtexture);
  if res<>0 then exit;

  LoadTextureFromDib;
end;


procedure TVSbitmap.LoadTextureFromDib;
var
  i,j: integer;
  res:integer;
  xRect: D3DLOCKED_RECT;
  p:PtabLong;
  p1: PtabOctet;
  w: longword;
  BMTexture0: IDirect3DTexture9;
begin
  if not assigned(hdib) then exit;
  if not assigned(BMtexture) then exit;

  res:=D3DXCreateTexture(DXscreen.Idevice,hdib.width,hdib.height,0,0,D3DFMT_A8R8G8B8, D3DPOOL_SYSTEMMEM ,BMtexture0);
  //messageCentral('res='+Istr(res));
  if (res=0) and (BMtexture0.LockRect( 0, xrect, nil, 0) = 0) then
  begin
    with xRect do
    begin
      for j:= 0 to hdib.height-1 do
      begin
        p1:=hdib.ScanLine[j];
        p:= pointer(intG(pbits)+pitch*j);
        for i:= 0 to hdib.width-1 do
        begin
          case hdib.BitCount of
            8:   p^[i]:= syspal.DX9colorI(p1^[i], Alpha[i,j] );
            24:  p^[i]:= D3Dcolor_rgba(p1^[i*3+2] ,p1^[i*3+1] , p1^[i*3] , Alpha[i,j] );
            32:  p^[i]:= D3Dcolor_rgba(p1^[i*4+2] ,p1^[i*4+1] , p1^[i*4] , Alpha[i,j] );

            else
            begin
              w:=hdib.pixels[i,j];
              p^[i]:= D3Dcolor_rgba( w and $FF, (w shr 8) and $FF, (w shr 16) and $FF , Alpha[i,j] );
            end;
          end;
        end;
      end;
    end;

    res:=BMTexture0.UnlockRect(0);

    if res=0 then res:= DXscreen.Idevice.UpdateTexture(BMtexture0,BMtexture);
    if res<>0 then WarningList.add('UpdateTexture= '+Istr(res));
    BMTexture0:=nil;
  end;
end;


procedure TVSbitmap.store2(var NV:integer;Ax,Ay:float;Const Falloc:boolean=false);
var
  Ax1,Ay1: float;
begin
  if Falloc and (NV=0) then getmem(vertices,NvertexTot*sizeof(TbmVertex));

  with vertices^[NV] do
  begin
    x:=Ax;
    y:=Ay;
    z:= 0;
    color:=  CurrentCol;

    u:= Ax;
    v:= -Ay;

  end;
  inc(NV);
end;

procedure TVSbitmap.BuildResource;
var
  NV: integer;
  pVertices: pointer;


begin
  affdebug('VSBM.buildResource',98);
  createBMtexture;
  LoadTextureFromDib;

  CurrentCol:=  0;//syspal.DX9color(0);

  if UseContour and (length(Contour)>0) then  BuildContourVertices(true)
  else
  begin
    NvertexTot:=4;
    getmem(vertices,NvertexTot*sizeof(TBMVertex));
    fillchar(vertices^,sizeof(vertices^[0])*4,0);
    NV:=0;
    store2(NV,-0.5, 0.5);
    store2(NV,-0.5,-0.5);
    store2(NV, 0.5, 0.5);
    store2(NV, 0.5,-0.5);
  end;

  VB:=nil;
  if FAILED(DXscreen.IDevice.CreateVertexBuffer(SizeOf(TBMVertex)*NvertexTot, 0, BMVertexCte, D3DPOOL_DEFAULT, VB, nil)) then Exit;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then Exit;
  CopyMemory(pVertices, @vertices[0], SizeOf(TBMVertex)*NvertexTot);
  VB.Unlock;

  freemem(vertices);
  DX9end;
end;

procedure TVSbitmap.Blt(const degV: typeDegre);
var
  mat,mTrans, mRot, mScale,mscale2: TD3DMatrix;
  res:integer;
  pVertices: pBMVertexArray;
  i,j, NV, Np: integer;
  stage:integer;

begin
  if (DXscreen=nil) or not DXscreen.candraw then exit;


  with degV, DXscreen.Idevice do
  begin
    // Position du rectangle affiché
    D3DXMatrixScaling(mScale,dx,dy,1);
    D3DXMatrixTranslation(mTrans,x,y,Zdistance);
    D3DXMatrixRotationZ(mRot, theta*pi/180);
    D3DXMatrixMultiply(mat,mScale,mRot);
    D3DXMatrixMultiply(mat,mat,mTrans);
    res:=DXscreen.IDevice.SetTransform(D3DTS_WORLD, mat);

    // Position de l'image (la texture)
    stage:=0;
    SetTexture(stage,BMTexture);
    SetTextureStageState( stage, D3DTSS_TEXTURETRANSFORMFLAGS, D3DTTFF_COUNT2 );
    D3DXMatrixScaling(mScale,dx,dy,1);                     // on passe en coordonnées réelles -0.5/0.5 devient -dx/2 +dx/2
    D3DXMatrixRotationZ(mRot, theta0*pi/180);              // on fait tourner
    MatrixTranslation2D(mTrans,x0+DxBM/2, -y0+dyBM/2);     // on positionne l'image
    D3DXMatrixScaling(mScale2,1/dxBM,1/dyBM,1);            // on revient en coordonnées texture 0..1

    D3DXMatrixMultiply(mat,mScale,mRot);
    D3DXMatrixMultiply(mat,mat,mTrans);
    D3DXMatrixMultiply(mat,mat,mScale2);

    SetTransform( D3DTS_TEXTURE0, mat);

    SetTextureStageState(stage, D3DTSS_COLOROP,   D3DTOP_SELECTARG1);
    SetTextureStageState(stage, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    SetTextureStageState(stage, D3DTSS_ALPHAOP,   D3DTOP_SELECTARG1 );
    SetTextureStageState(stage, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);        // Alpha doit valoir 255 par défaut dans la texture


    SetSamplerState(stage, D3DSAMP_MINFILTER, FilterMode );
    SetSamplerState(stage, D3DSAMP_MAGFILTER, FilterMode );
    SetSamplerState(stage, D3DSAMP_MIPFILTER, FilterMode );

    if FTileMode then
    begin
      SetSamplerState(stage, D3DSAMP_ADDRESSU,  D3DTADDRESS_WRAP );     // l'image sera dupliquée dans les deux directions
      SetSamplerState(stage, D3DSAMP_ADDRESSV,  D3DTADDRESS_WRAP );
    end
    else
    begin
      if FborderMode then SetSamplerState(stage, D3DSAMP_BORDERCOLOR, BorderColor ) //Couleur demandée par l'utilisateur
      else
      if Fmask then SetSamplerState(stage, D3DSAMP_BORDERCOLOR, DevColBK1 )         //couleur de fond avec alpha=0
      else SetSamplerState(stage, D3DSAMP_BORDERCOLOR, DevColBK );                  //couleur de fond avec alpha=1
      SetSamplerState(stage, D3DSAMP_ADDRESSU,    D3DTADDRESS_BORDER );
      SetSamplerState(stage, D3DSAMP_ADDRESSV,    D3DTADDRESS_BORDER );
    end;
    inc(stage);

    if (Ag>=0) and (Ag<=1) then
    begin
      SetSamplerState(Stage, D3DSAMP_MINFILTER, FilterMode );
      SetSamplerState(Stage, D3DSAMP_MAGFILTER, FilterMode );
      SetSamplerState(Stage, D3DSAMP_MIPFILTER, FilterMode );

      SetTextureStageState(Stage, D3DTSS_CONSTANT, syspal.DX9colorI(round(Ag*255),255) );
      SetTextureStageState(Stage, D3DTSS_COLOROP,   D3DTOP_MODULATE);
      SetTextureStageState(Stage, D3DTSS_COLORARG1, D3DTA_CURRENT);
      SetTextureStageState(Stage, D3DTSS_COLORARG2, D3DTA_CONSTANT);

      SetTextureStageState(Stage, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);
      inc(stage);
    end
    else
    if FblendCurrentAlpha then
    begin
      SetSamplerState(Stage, D3DSAMP_MINFILTER, FilterMode );
      SetSamplerState(Stage, D3DSAMP_MAGFILTER, FilterMode );
      SetSamplerState(Stage, D3DSAMP_MIPFILTER, FilterMode );

      SetTextureStageState(Stage, D3DTSS_CONSTANT, 0 );
      SetTextureStageState(Stage, D3DTSS_COLOROP,   D3DTOP_BLENDCURRENTALPHA);
      SetTextureStageState(Stage, D3DTSS_COLORARG1, D3DTA_CURRENT);
      SetTextureStageState(Stage, D3DTSS_COLORARG2, D3DTA_CONSTANT);

      SetTextureStageState(Stage, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);
      inc(stage);
    end;


    SetTextureStageState(stage, D3DTSS_COLOROP,   D3DTOP_DISABLE);
    SetTextureStageState(stage, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);

    res:=SetStreamSource(0, VB, 0, SizeOf(TBMVertex));
    res:=SetFVF(BMVertexCte);


    if UseContour then BltContourVertices
    else
    res:=DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2 );


  end;

  DX9end;
end;


procedure TVSbitmap.freeBM;
begin
  unregisterCuda;
  BMtexture:=nil;
  VB:=nil;
end;

procedure TVSbitmap.drawRandom(x,y,xs,ys:integer);
begin
end;

procedure TVSbitmap.drawRandom2(x,y,xs,ys:integer);
begin
end;


procedure TVSbitmap.initRandom(dx1,dy1:integer);
var
  w,h:integer;
  RR:Trect;
  i,j:integer;
begin
  if dx1<=0 then dx1:=10;
  if dy1<=0 then dy1:=10;

  dxG:=dx1;
  dyG:=dy1;

  w:=degToPix(deg.dx);
  h:=degToPix(deg.dy);

  nxG:=w div dxG;
  if w mod dxG<>0 then inc(nxG);

  nyG:=h div dyG;
  if h mod dyG<>0 then inc(nyG);

  Rlist.clear;

  for i:=0 to nxG-1 do
  for j:=0 to nyG-1 do
    begin
      RR.Left:=i*dxG;
      RR.Right:=(i+1)*dxG;
      RR.top:=j*dyG;
      RR.bottom:=(j+1)*dyG;

      Rlist.add(@RR);
    end;

  Frandom:=true;
end;

procedure TVSbitmap.randomizeRlist(seed:integer);
var
  i:integer;
begin
  GsetRandSeed(seed);
  for i:=0 to Rlist.Count-1 do
    Rlist.Exchange(i,Grandom(Rlist.count));

end;

procedure TVSbitmap.doneRandom;
begin
  Frandom:=false;
  Rlist.clear;
end;


procedure TVSbitmap.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;

  with conf do
  begin
    setvarconf('x0',x0,sizeof(x0));
    setvarconf('y0',y0,sizeof(y0));

    setStringConf('StFile',stfile);
  end;
end;

function TVSbitmap.getInfo: AnsiString;
begin
  result:=inherited getInfo+ crlf+
          'x0=    '+Estr1(x0,10,3)+CRLF+
          'y0=    '+Estr1(y0,10,3)+CRLF+
          stFile;
end;


function TVSbitmap.DialogForm: TclassGenForm;
begin
  result:=TgetVSBM;
end;


procedure TVSbitmap.installDialog(var form: Tgenform; var newF: boolean);
begin
  installForm(form, newF);

  TgetVSBM(Form).init(self);
end;




procedure TVSbitmap.CompleteLoadInfo;
begin
  inherited;
  LoadFromFile(stFile);
end;

procedure TVSbitmap.AlphaDefault;
var
  i,j:integer;
begin
  if assigned(hdib) then
  begin
    setLength(Alpha,hDib.Width,hDib.Height);
    for i:=0 to hDib.width-1 do
    for j:=0 to hDib.height-1 do
      Alpha[i,j]:=255;
  end
  else setLength(Alpha,0);
end;

function TVSbitmap.LoadFromFile(st:AnsiString):boolean;
begin
  stFile:=st;
  result:=fichierExiste(st);
  if result then
  begin
    hdib.LoadFromFile(stFile);
    AlphaDefault;

    DxBM:= hdib.Width/1024*40;
    DyBM:= hdib.Height/1024*40;
    

    freeBM;
  end;
end;

function TVSbitmap.LoadFromMatrix(mat: Tmatrix;Const UseVSlum:boolean=false): boolean;
var
  zmin1,zmax1:float;
begin
  try
    if UseVSlum then
    begin
      zmin1:=mat.zmin;
      zmax1:=mat.zmax;

      mat.zmin:=0;

      mat.zmax:= syspal.Lmax;
      mat.MatToDib(hDib,false);

      mat.zmin:= zmin1;
      mat.zmax:= zmax1;
    end
    else mat.MatToDib(hDib,true);

    deg.dx:=mat.Icount*mat.dxu;
    deg.dy:=mat.Jcount*mat.dyu;
    AlphaDefault;
    result:=true;
  except
    result:=false;
  end;
end;

function TVSbitmap.LoadAlphaFromMatrix(mat:Tmatrix;Freal:boolean):boolean;
var
  i,j:integer;
  w:float;
begin
  result:= false;
  if (mat.Icount<>hdib.Width) or (mat.Jcount<>hdib.height) then exit;

  setLength(Alpha,mat.Icount,mat.Jcount);
  for i:=0 to mat.Icount-1 do
  for j:=0 to mat.Jcount-1 do
  begin
    w:= mat[i,j];
    if Freal then
    begin
      if w<0 then w:=0
      else
      if w>1 then w:=1;
      Alpha[i,j]:= ceil(w*255);
    end
    else
    begin
      if w<0 then w:=0
      else
      if w>255 then w:=255;
      Alpha[i,j]:= round(w);
    end;
  end;
  result:=true;
end;

function TVSbitmap.SaveToMatrix(mat: Tmatrix): boolean;
begin
  result:=mat.DibToMat(hdib);
end;


function TVSbitmap.getPixel(x, y: integer): Dword;
begin
  result:=hdib.Pixels[x,y];
end;

procedure TVSbitmap.setPixel(x, y: integer; w: Dword);
begin
  hdib.Pixels[x,y]:=w;
end;

function TVSbitmap.getParamAd(name: AnsiString; var tp: typeNombre): pointer;
begin
  name:= Uppercase(name);
  tp:= nbSingle;

  if name='X0' then result:=@x0
  else
  if name='Y0' then result:=@y0
  else
  if name='THETA0' then result:=@theta0
  else
  if name='LUMFACTOR' then result:=@Ag
  else
  if name='ALPHAISLUMFACTOR' then
  begin
    result:=@FBlendCurrentAlpha;
    tp:= nbBoole;
  end
  else
  result:= inherited getParamAd(name,tp);

end;



procedure TVSbitmap.VerifyPixelPos(x,y:integer);
begin
  if not assigned(hdib) or (x<0) or (x>=hdib.Width) or (y<0) or (y>=hdib.height)
    then sortieErreur('TVSbitmap : bad pixel coordinates');
end;

function TVSbitmap.height: integer;
begin
  result:= hdib.Height;
end;

function TVSbitmap.Width: integer;
begin
  result:= hdib.width;
end;

procedure TVSbitmap.initBM(w, h: integer);
begin
  if assigned(hdib) and (w<>hdib.Width) or (h<>hdib.Height) then
  begin
    hdib.setSize(w,h,8);
    hDib.fill(0);
    AlphaDefault;
  end;
end;

procedure TVSbitmap.registerCuda;
var
  res:integer;
begin
  if BMCudaResource=nil then
  begin
    res:=cuda1.RegisterTransformSurface(BMtexture, BMCudaResource);
    if res<>0 then WarningList.add('RegisterTransformSurface ='+Istr(res));
  end;

  (*
  if (registerCount=0) then
  begin
    res:=cuda1.RegisterTransformSurface(BMtexture, BMCudaResource);
    if res<>0 then WarningList.add('RegisterTransformSurface ='+Istr(res));
    MapResourceCount:=0;
  end;
  inc(RegisterCount);
  *)

end;

procedure TVSbitmap.UnRegisterCuda;
var
  res:integer;
begin
  if BMCudaResource<>nil then
  begin
    res:=cuda1.UnRegisterTransformSurface(BMCudaResource);
    BMCudaResource:=nil;
    if res<>0 then WarningList.add('UnRegisterTransformSurface ='+Istr(res));
  end;

  (*
  dec(RegisterCount);
  if (registerCount=0) and (BMcudaResource<>nil) then
  begin
    res:=cuda1.UnRegisterTransformSurface(BMCudaResource);
    BMCudaResource:=nil;
    if res<>0 then WarningList.add('UnRegisterTransformSurface ='+Istr(res));
    MapResourceCount:=0;
  end;
  *)
end;


procedure TVSbitmap.MapResource;
var
  res:integer;
begin
  if MapResourceCount=0 then
  begin
    res:=cuda1.MapResources(@BMCudaResource ,1);
    if res<>0 then WarningList.add( ident+'  MapResources ='+Istr(res));
  end;
  inc(MapResourceCount);
end;

procedure TVSbitmap.UnMapResource;
var
  res:integer;
begin
  if MapResourceCount>0 then
  begin
    dec(MapResourceCount);
    if MapResourceCount=0 then
    begin
      res:=cuda1.UnMapResources(@BMCudaResource ,1);
      if res<>0 then WarningList.add( ident+'  UnMapResources ='+Istr(res));
    end;
  end;
end;

procedure TVSbitmap.fillLum(Alum, AnAlpha: single);
var
  bmCol,i,j: integer;
begin
  if not assigned(hdib) then exit;

  if Alum>=0 then
  begin
    if hdib.BitCount=8 then bmCol:=syspal.LumIndex(Alum)
    else
    if hdib.BitCount=24 then bmCol:= syspal.DX9color(Alum,0)
    else exit;

    hdib.fill(bmCol);
  end;

  if AnAlpha>=0 then
  begin
    if AnAlpha>1 then AnAlpha:=1;
    for i:=0 to hdib.Width-1 do
    for j:=0 to hdib.height-1 do
      alpha[i,j]:= round(AnAlpha*255);
  end;
end;

                       { Méthodes stm }


procedure proTVSbitmap_create(var pu:typeUO);
begin
  createPgObject('',pu,TVSbitmap);
end;

procedure proTVSbitmap_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TVSbitmap);
end;

procedure proTVSbitmap_fileName(ww:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  if not TVSbitmap(pu).LoadFromFile(ww)
    then sortieErreur('TVSbitmap: unable to load image from file');
end;

function fonctionTVSbitmap_fileName(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TVSbitmap(pu).stFile;
end;


procedure proTVSbitmap_x0(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).x0:=ww;
end;

function fonctionTVSbitmap_x0(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TVSbitmap(pu).x0;
end;

procedure proTVSbitmap_y0(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).y0:=ww;
end;

function fonctionTVSbitmap_y0(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TVSbitmap(pu).y0;
end;

procedure proTVSbitmap_theta0(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).theta0:=ww;
end;

function fonctionTVSbitmap_theta0(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TVSbitmap(pu).theta0;
end;

procedure proTVSbitmap_Pixels(x, y: integer; w: Dword;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).pixels[x,y]:=w;
end;

function fonctionTVSbitmap_Pixels(x, y: integer;var pu:typeUO):Dword;
begin
  verifierObjet(pu);
  result:=TVSbitmap(pu).pixels[x,y];
end;

procedure proTVSbitmap_Alpha(x, y: integer; w: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).VerifyPixelPos(x,y);
  TVSbitmap(pu).Alpha[x,y]:=w;
end;

function fonctionTVSbitmap_Alpha(x, y: integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  TVSbitmap(pu).VerifyPixelPos(x,y);
  result:=TVSbitmap(pu).Alpha[x,y];
end;


procedure proTVSbitmap_PixLum(x,y: integer; w: Float;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).pixels[x,y]:=syspal.LumIndex(w);
end;

function fonctionTVSbitmap_PixLum(x,y: integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=syspal.IndexToLum( TVSbitmap(pu).pixels[x,y]);
end;

function fonctionTVSbitmap_width(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TVSbitmap(pu).hdib.Width;
end;

function fonctionTVSbitmap_height(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TVSbitmap(pu).hdib.height;
end;

function fonctionTVSbitmap_ImageWidth(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TVSbitmap(pu).dxBM;
end;

procedure proTVSbitmap_ImageWidth(w:float; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).dxBM:=w;
end;


function fonctionTVSbitmap_ImageHeight(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TVSbitmap(pu).dyBM;
end;

procedure proTVSbitmap_ImageHeight(w:float; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).dyBM:=w;
end;

function fonctionTVSbitmap_Dx0(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TVSbitmap(pu).dxBM;
end;

procedure proTVSbitmap_Dx0(w:float; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).dxBM:=w;
end;


function fonctionTVSbitmap_Dy0(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TVSbitmap(pu).dyBM;
end;

procedure proTVSbitmap_Dy0(w:float; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).dyBM:=w;
end;


function fonctionTVSbitmap_TileMode(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= TVSbitmap(pu).FTileMode;
end;

procedure proTVSbitmap_TileMode(w:boolean; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).FTileMode:=w;
end;

function fonctionTVSbitmap_FilterMode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TVSbitmap(pu).filterMode;
end;

procedure proTVSbitmap_FilterMode(w:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).FilterMode:=w;
end;


procedure proTVSbitmap_SetBorderLum(lum1, alpha1:float ; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).FBorderMode:=true;
  TVSbitmap(pu).BorderColor:= syspal.DX9color(lum1,alpha1);;
end;

procedure proTVSbitmap_ReSetBorderLum( var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).FBorderMode:=false;
end;

procedure proTVSbitmap_LumFactor(w:float ; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).Ag:= w;
end;

function fonctionTVSbitmap_LumFactor(var pu:typeUO): float;
begin
  verifierObjet(pu);
  result:= TVSbitmap(pu).Ag;
end;


procedure proTVSbitmap_AlphaIsLumFactor(w:boolean ; var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).FBlendCurrentAlpha:= w;
end;

function fonctionTVSbitmap_AlphaIsLumFactor(var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  result:= TVSbitmap(pu).FBlendCurrentAlpha;
end;



procedure proTVSbitmap_setBounds(Awidth,Aheight:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  try
    with TVSbitmap(pu) do
    begin
      freeBM;
      initBM(Awidth,Aheight);
    end;
  except
    sortieErreur('TVSbitmap: setBounds error');
  end;
end;

procedure proTVSbitmap_saveToFile(stF:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  try
    TVSbitmap(pu).hdib.SaveToFile(stF);
  except
    sortieErreur('TVSbitmap: saveToFile error');
  end;
end;

function fonctionTVSbitmap_LoadFromMatrix(var mat: Tmatrix;var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));
  result:= TVSbitmap(pu).loadFromMatrix(mat);
end;


function fonctionTVSbitmap_LoadFromMatrix_1(var mat: Tmatrix;UseVSlum:boolean;var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));
  result:= TVSbitmap(pu).loadFromMatrix(mat,UseVSlum);
end;

function fonctionTVSbitmap_LoadAlphaFromMatrix(var mat: Tmatrix;FReal: boolean;var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));
  result:= TVSbitmap(pu).loadAlphaFromMatrix(mat,Freal);
end;


function fonctionTVSbitmap_SaveToMatrix(var mat: Tmatrix;var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));
  result:= TVSbitmap(pu).saveToMatrix(mat);
end;

procedure proTVSbitmap_fillLum(Alum, AnAlpha: float;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSbitmap(pu).fillLum(Alum,AnAlpha);
end;



procedure TVSbitmap.DisplayVSBM(source: TVSbitmap; x0, y0, theta: single; AlphaMode,LumMode:integer;
                                Alpha1,Alpha2, Lum1,Lum2: float);
var
  p:pointer;
  res:integer;
  AlphaArray,LumArray: array[1..4] of integer ;
begin
  AlphaArray[1]:= round(255*Alpha1);
  AlphaArray[2]:= round(255*Alpha2);
  AlphaArray[3]:= 0;
  AlphaArray[4]:= 0;

  LumArray[1]:= syspal.LumIndex(Lum1);
  LumArray[2]:= syspal.LumIndex(Lum2);
  LumArray[3]:= 0;
  LumArray[4]:= 0;

  registerCuda;
  source.registerCuda;

  MapResource;
  source.MapResource;

  res:= DisplaySurface( source.BMCudaResource, source.width, source.height,
                  BMCudaResource, width, height,
                  x0,-y0, theta*pi/180, 1,1,
                  source.width/2, source.height/2, width/2, height/2,
                  AlphaMode,LumMode,@AlphaArray,@LumArray, CudaRgbMask);

  source.UnMapResource;
  UnMapResource;

  //source.unregisterCuda;
  //unregisterCuda;

  if res<>0 then WarningList.add('DisplaySurface='+Istr(res));
end;

procedure proTVSbitmap_DisplayVSBM(var source: TVSbitmap; x0, y0, theta: float;
                                   AlphaMode,LumMode:integer;
                                   Alpha1,Alpha2, Lum1,Lum2: float; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(source));
  TVSbitmap(pu).DisplayVSBM( source, x0, y0, theta, AlphaMode,LumMode, Alpha1,Alpha2, Lum1,Lum2);
end;

function TVSbitmap.PixSum(comp,ref:integer): integer;
var
  pf: TransformClass;
begin
  result:=0;
  registerCuda;
  try
  MapResource;
  pf:= InitTransform(BMcudaResource,nil);
  if pf<>nil then
  begin
    initSrcRect(pf,0,0,Width,Height);
    result:= TexPixSum(pf,comp,ref);
    DoneTransform(pf);
  end;
  finally
  unMapResource;
  //unregisterCuda;
  end;
end;

function fonctionTVSbitmap_PixSum(comp,ref:integer; var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:= TVSbitmap(pu).PixSum(comp,ref);
end;

Initialization

AffDebug('Initialization stmVSBM1',0);
registerObject(TVSbitmap,obvis);


end.
