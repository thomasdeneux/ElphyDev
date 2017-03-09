unit gratDX1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, classes,stdCtrls,graphics, sysutils,
     editCont,
     {$IFDEF DX11}

     {$ELSE}
     DXtypes, Direct3D9G, D3DX9G, Cuda1,
     {$ENDIF}
     DibG,
     util1,debug0,Dgraphic,
     stmDef,stmObj,stmobv0,varconf1,Ncdef2,stmError,

     defForm,getGrat2,getGab1,Dpalette,sysPal32,
     stmPg,stmGraph2;




type
  TgratingVertex = packed record
    x, y, z: Single; // The untransformed position for the vertex
    color: DWORD;    // The vertex color
    u1,v1: single;
  end;

  TgvArray= array[0..1000] of TgratingVertex;
  PgvArray = ^TgvArray;

const
  GratingVertexCte = D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1;

type
  TgaborVertex = packed record
    x, y, z: Single; // The untransformed position for the vertex
    color: DWORD;    // The vertex color
    u1,v1: single;
    u2,v2: single;
  end;

  TgabVArray= array[0..1000] of TgaborVertex;
  PgabvArray = ^TgabvArray;

const
  GaborVertexCte = D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX2;

type
  TLgrating=
          class(Tresizable)
            CurrentCol: integer;
            CurrentOri,CurrentPhase: float;

            vertices: PgvArray;
            periode:single;    { Paramètres primaires ajoutés à deg }
            phase:single;
            contrast:single;
            Fellipse:boolean;
            orientation:single;
            FsquareWave: boolean;

            periode1:single;    {Valeurs au moment de createHardBM}
            phase1:single;
            contrast1:single;
            Fond1:single;
            Fellipse1:boolean;
            orientation1:single;
            UseContour1: boolean;
            BlendAlpha1:float;

            periodeAff:single;  {Valeurs au moment de createAffBM}
            phaseAff:single;
            contrastAff:single;
            FellipseAff:boolean;
            orientationAff:single;

            modeX:boolean;
            periodeX,periodeY:float;


            constructor create;override;
            destructor destroy;override;
            class function STMClassName:AnsiString;override;


            procedure CreateGratingTexture(var gr:IDirect3DTexture9;square, forcer:boolean);
            procedure CreateGaussTexture(forcer:boolean);
            procedure CreateEllipseTexture(forcer: boolean);

            procedure CudaTest(n:integer);


            function ResourceNeeded:boolean;override;

            procedure freeBM;override;
            procedure BuildResource;override;
            procedure store2(var NV:integer;Ax,Ay: float;Const Falloc:boolean=false);override;
            procedure Blt(const degV: typeDegre);override;


            function DialogForm:TclassGenForm;override;
            procedure installDialog(var form:Tgenform;var newF:boolean);
                                    override;


            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
            procedure setCircular(v:boolean);

            procedure afficheC;override;

            procedure setPhase(x:float);override;
            function getInfo:AnsiString;override;

            function getParamAd(name:Ansistring;var   tp: typeNombre): pointer;override;
          end;

  TLgabor=class(TLgrating)
            Lx,Ly:single;

            Lx1,Ly1:single;
            vertices: PgabvArray;


            constructor create;override;
            class function STMClassName:AnsiString;override;


            function ResourceNeeded:boolean;override;

            procedure BuildResource;override;
            procedure Blt(const degV: typeDegre);override;

            function DialogForm:TclassGenForm;override;
            procedure installDialog(var form:Tgenform;var newF:boolean);
                                    override;

            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;

            procedure scrollV(sender:Tobject;x:float;ScrollCode: TScrollCode);
            function getInfo:AnsiString;override;

            function getParamAd(name:Ansistring;var tp: typeNombre): pointer;override;

            procedure store2(var NV:integer;Ax,Ay: float;Const Falloc:boolean=false);override;
          end;



procedure proTLgrating_create(var pu:typeUO);pascal;
procedure proTLgrating_create_1(name:AnsiString;var pu:typeUO);pascal;


procedure proTLgrating_period(x:float;var pu:typeUO);pascal;
function fonctionTLgrating_period(var pu:typeUO):float;pascal;

procedure proTLgrating_phase(x:float;var pu:typeUO);pascal;
function fonctionTLgrating_phase(var pu:typeUO):float;pascal;


procedure proTLgrating_contrast(x:float;var pu:typeUO);pascal;
function fonctionTLgrating_contrast(var pu:typeUO):float;pascal;

procedure proTLgrating_diameter(x:float;var pu:typeUO);pascal;
function fonctionTLgrating_diameter(var pu:typeUO):float;pascal;

procedure proTLgrating_elliptic(x:boolean;var pu:typeUO);pascal;
function fonctionTLgrating_elliptic(var pu:typeUO):boolean;pascal;

procedure proTLgrating_orientation(x:float;var pu:typeUO);pascal;
function fonctionTLgrating_orientation(var pu:typeUO):float;pascal;
procedure proTLgrating_CudaTest(n:integer;var pu:typeUO);pascal;

procedure proTLgrating_SquareWave(x:boolean;var pu:typeUO);pascal;
function fonctionTLgrating_SquareWave(var pu:typeUO):boolean;pascal;



procedure proTLgabor_create(var pu:typeUO);pascal;
procedure proTLgabor_create_1(name:AnsiString;var pu:typeUO);pascal;

procedure proTLgabor_Lx(x:float;var pu:typeUO);pascal;
function fonctionTLgabor_Lx(var pu:typeUO):float;pascal;

procedure proTLgabor_Ly(x:float;var pu:typeUO);pascal;
function fonctionTLgabor_Ly(var pu:typeUO):float;pascal;


implementation

type
  Tquad=record
          b,g,r,a: single;
        end;
  TquadArray= array[1..1000] of Tquad;
  PquadArray= ^TquadArray;


var
  GratingTexture0: IDirect3DTexture9;
  GratingTextureSqr0: IDirect3DTexture9;

  GaussTexture0: IDirect3DTexture9;
  EllipseTexture0: IDirect3DTexture9;


procedure FreeGratDXResources;
var
  res: integer;
begin
  if initCudaLib1 and (gratingTexture0<>nil) then
  begin
    //res:=UnregisterResources;
    //if res<>0 then messageCentral('UnregisterResources='+Istr(res));
  end;

  GratingTexture0 := nil;
  GratingTextureSqr0 := nil;
  GaussTexture0   := nil;
  EllipseTexture0 := nil;
end;



var
  E_period:integer;
  E_phase:integer;
  E_contrast:integer;
  E_diameter:integer;

constructor TLgrating.create;
  begin
    inherited create;
    FastMove:=false;

    deg:=degNul;

    periode:=2;
    contrast:=0.8;

    phase1:=-11111;

  end;

destructor TLgrating.destroy;
  begin
    inherited destroy;
  end;

class function TLgrating.STMClassName:AnsiString;
  begin
    STMClassName:='LGrating';
  end;





procedure TLgrating.freeBM;
begin
  inherited;
  VB:=nil;
end;

Const
  TexUsage = 0; //D3DUSAGE_AUTOGENMIPMAP;
  // Quand TexUsage=0, il faut MipLevels=1
  // Quand TexUsage=D3DUSAGE_AUTOGENMIPMAP, il faut MipLevels=0
  // Je ne vois pas de différence d'affichage


procedure TLgrating.CreateGratingTexture(var gr:IDirect3DTexture9;square, forcer: boolean);
var
  i,j: integer;
  res:integer;
  xRect: D3DLOCKED_RECT;
  p:PtabLong;
  alpha, L0: single;
  gg:single;
Const
  TextureSize=512;

var
  pq: PquadArray;
  grDum:IDirect3DTexture9;
begin
  if (Gr<>nil) and not forcer then
  begin
    //Affdebug('TLgrating.CreateGratingTexture :
    exit;
  end;
  DXscreen.messageRef('Before CreateGratingTexture');

  GrDum:=nil;
  res:=D3DXCreateTexture(DXscreen.Idevice,TextureSize,TextureSize,1, 0,
                        TexFormat,
                        D3DPOOL_SYSTEMMEM,
                        GrDum);
  Gr:=nil;
  res:=D3DXCreateTexture(DXscreen.Idevice,TextureSize,TextureSize,ord(TexUsage=0),TexUsage,
                        TexFormat,
                        D3DPOOL_DEFAULT,
                        Gr);


  if GrDum.LockRect( 0, xrect, nil, 0) =0 then
  begin
    L0:= TextureSize/6;

    if square then
    with xRect do
    begin
      case TexFormat of
        D3DFMT_A8R8G8B8:
          begin
            for j:= 0 to TextureSize-1 do
            begin
              p:=  pointer(intG(pbits)+pitch*j);
              for i:= 0 to TextureSize-1 do
              begin
                gg:= cos(2*pi/TextureSize*j);
                if gg>=0
                  then p^[i]:=syspal.DX9colorI(255,0)
                  else p^[i]:=syspal.DX9colorI(0,0);
              end;
            end;
          end;
        D3DFMT_A32B32G32R32F:
          begin
            for j:= 0 to TextureSize-1 do
            begin
              pq:=  pointer(intG(pbits)+pitch*j);
              fillchar(pq^,TextureSize*16,0);
              for i:= 0 to TextureSize-1 do
              begin
                gg:= cos(2*pi/TextureSize*j);
                if gg>=0 then pq^[i].g:=1;
              end;
            end;
          end;
      end;
    end
    else
    with xRect do
    begin
      case TexFormat of
        D3DFMT_A8R8G8B8:
          begin
            for j:= 0 to TextureSize-1 do
            begin
              p:=  pointer(intG(pbits)+pitch*j);
              for i:= 0 to TextureSize-1 do
                p^[i]:=syspal.DX9colorI(round(128+ 127*cos(2*pi/TextureSize*j)),0) ;
            end;
          end;
        D3DFMT_A32B32G32R32F:
          begin
            for j:= 0 to TextureSize-1 do
            begin
              pq:= pointer(intG(pbits)+pitch*j);
              fillchar(pq^,TextureSize*16,0);
              for i:= 0 to TextureSize-1 do
                pq^[i].g:=  0.5+ 0.499*cos(2*pi/TextureSize*j);
            end;
          end;
      end;
    end;

    res:=GrDum.UnlockRect(0);
  end;
  DXscreen.Idevice.updateTexture(grDum,gr);
  grDum:=nil;

  DXscreen.messageRef('CreateGratingTexture');
end;

procedure TLgrating.CudaTest(n:integer);
var
  i,j,k,t0:integer;
  res:integer;
  xRect: D3DLOCKED_RECT;
  p:PtabLong;
  alpha, L0: single;
  gg:single;
type
  Tquad=record
          b,g,r,a: single;
        end;
  TquadArray= array[1..1] of Tquad;
  PquadArray= ^TquadArray;
var
  pq: PquadArray;


Const
  TextureSize=512;

begin
   GratingTexture0:=nil;
   res:=D3DXCreateTexture(DXscreen.Idevice,TextureSize,TextureSize,ord(TexUsage=0),TexUsage,
                        D3DFMT_A8R8G8B8,
                        D3DPOOL_DEFAULT,
                        GratingTexture0);

  if initCudaLib1 and assigned(gratingTexture0) then
  begin
    res:=RegisterTexture( GratingTexture0, TextureSize, TextureSize);
    if res<>0 then messageCentral('RegisterResources='+Istr(res));

    t0:=getTickCount;
    for i:=1 to n do FillGrating;
    t0:=getTickCount-t0;
    UnRegisterTextures;

    messageCentral('t1='+Estr(t0/n,3)+' ms');
  end;

  //13 mars 2014 : le test donne 0.46 ms pour un appel à RunCuda sur GTX 550 Ti

  GratingTexture0:=nil;
  res:=D3DXCreateTexture(DXscreen.Idevice,TextureSize,TextureSize,ord(TexUsage=0), TexUsage ,
                        D3DFMT_A8R8G8B8,   { D3DFMT_A32B32G32R32F}
                        D3DPOOL_DEFAULT,   { }
                        GratingTexture0);

  if GratingTexture0.LockRect( 0, xrect, nil, 0) =0 then
  begin
    L0:= TextureSize/6;

    t0:=getTickCount;
    for k:=1 to n do
    with xRect do
    begin
      for j:= 0 to TextureSize-1 do
      begin
        p:=  pointer(intG(pbits)+pitch*j);
        pq:= pointer(p);
        for i:= 0 to TextureSize-1 do
          p^[i]:=syspal.DX9colorI(round(128+ 127*cos(2*pi/TextureSize*j)),0) ;
          //p^[i]:=round(128+ 127*cos(2*pi/TextureSize*j)) shl 8 ;
      end;
    end;
    t0:=getTickCount-t0;

    res:=GratingTexture0.UnlockRect(0);

    messageCentral('t2='+Estr(t0/n,3)+' ms');

  end;
  //13 mars 2014 : le test donne 15 ms pour un calcul sur une locked texture

end;

procedure TLgrating.CreateGaussTexture(forcer:boolean);
var
  i,j: integer;
  res:integer;
  xRect: D3DLOCKED_RECT;
  p:PtabLong;
  alpha, L0: single;

  pq: PquadArray;
  grDum:IDirect3DTexture9;
Const
  TextureSize=512;
begin
  if (GaussTexture0<>nil) and not forcer then exit;

  // avec DX9ex, D3DPOOL_MANAGED est interdit.
  // Il faut charger une tex D3DPOOL_SYStEMMEM et la copier dans une tex D3DPOOL__default avec updatetexture

  res:=D3DXCreateTexture(DXscreen.Idevice,TextureSize,TextureSize,ord(TexUsage=0),TexUsage,TexFormat,D3DPOOL_DEFAULT ,GaussTexture0);
  res:=D3DXCreateTexture(DXscreen.Idevice,TextureSize,TextureSize,1,0 ,TexFormat,D3DPOOL_SYSTEMMEM ,grDum);
  if res<>0 then
  begin
    messageCentral('D3DXCreateTexture = '+Istr(res and $FFFF) );
    exit;
  end;

  if grDum.LockRect( 0, xrect, nil, 0) =0 then
  begin
    L0:= TextureSize/6;

    with xRect do
    begin
      case TexFormat of
        D3DFMT_A8R8G8B8:      for j:= 0 to TextureSize-1 do
                              begin
                                p:= pointer(intG(pbits)+pitch*j);
                                for i:= 0 to TextureSize-1 do
                                begin
                                  alpha:= 255 *exp(- sqr((i-TextureSize/2)/L0)-sqr((j-TextureSize/2)/L0));
                                  p^[i]:=syspal.DX9colorI(0,round(alpha) );
                                end;
                              end;
        D3DFMT_A32B32G32R32F: for j:= 0 to TextureSize-1 do
                              begin
                                pq:= pointer(intG(pbits)+pitch*j);
                                fillchar(pq^,TextureSize*16,0);
                                for i:= 0 to TextureSize-1 do
                                  pq^[i].a:= exp(- sqr((i-TextureSize/2)/L0)-sqr((j-TextureSize/2)/L0));
                              end;
      end;
    end;


    res:=GrDum.UnlockRect(0);
  end;
  Dxscreen.Idevice.UpdateTexture(grDum,GaussTexture0);
  GrDum:=nil;
  DXscreen.messageRef('CreateGaussTexture');
end;

procedure TLgrating.CreateEllipseTexture(forcer: boolean);
var
  i,j: integer;
  bm:Tbitmap;
  res:integer;
  xRect: D3DLOCKED_RECT;
  p1,p01:PtabOctet;
  grDum:IDirect3DTexture9;
Const
  TextureSize=512;

begin
  if (EllipseTexture0<>nil) and not forcer then exit;

  bm:=Tbitmap.create;
  bm.PixelFormat:=pf32bit;
  bm.Width:=TextureSize;
  bm.Height:=TextureSize;

  with bm.Canvas do
  begin
    pen.Color:=clBlack;
    pen.Style:=psSolid;

    brush.color:=clBlack;
    brush.style:=bsSolid;
    rectangle(0,0,TextureSize,TextureSize);

    brush.Color:=$FFFFFF;
    pen.Color:= $FFFFFF;
    ellipse(0,0,TextureSize,TextureSize);
  end;


  res:=D3DXCreateTexture(DXscreen.Idevice,TextureSize,TextureSize,ord(TexUsage=0),TexUsage,D3DFMT_A8R8G8B8,D3DPOOL_DEFAULT,EllipseTexture0);
  res:=D3DXCreateTexture(DXscreen.Idevice,TextureSize,TextureSize,1,0,D3DFMT_A8R8G8B8,D3DPOOL_SYSTEMMEM,grDum);
  if res<>0 then
  begin
    AffDebug(' TLgrating.CreateEllipseTexture : res='+Istr(res),112);
    exit;
  end;
  if grDum.LockRect( 0, xrect, nil, 0) =0 then
  begin
    with xRect do
    begin
      for j:= 0 to TextureSize-1 do
      begin
        // On copie la ligne en décalant de 1 octet afin d'affecter la composante alpha
        p01:=bm.ScanLine[j];
        p1:= pointer(intG(pbits)+pitch*j);
        move(p01^,p1^[1],4*TextureSize-1);
      end;
    end;

    res:=grDum.UnlockRect(0);
  end;
  DXscreen.Idevice.UpdateTexture(grDum,EllipseTexture0);
  grDum:=nil;
  bm.Free;
end;





function TLgrating.ResourceNeeded:boolean;
begin
  result:= (VB=nil) or (GratingTexture0=nil) or (Fellipse<>Fellipse1) or FsquareWave and (GratingTextureSqr0=nil) or (UseContour<>UseContour1) or (BlendAlpha<>BlendAlpha1);
  //messageCentral(ident +'  ResourceNeeded = '+Bstr(result));
end;

Const
  Nfan=100;

procedure TLgrating.store2(var NV:integer;Ax,Ay: float;Const Falloc:boolean=false);
begin
  if Falloc and (NV=0) then getmem(vertices,NvertexTot*sizeof(TgratingVertex));
  with vertices[NV] do
  begin
    x:=Ax;
    y:=Ay;
    z:= 0;
    color:=  Currentcol;

    u1:= Ax; // (Ax*cos(Currentori)+Ay*sin(Currentori))/periode;
    v1:= Ay; // (-Ax*sin(Currentori)+Ay*cos(CurrentOri)+Currentphase)/periode;

  end;
  inc(NV);
end;

procedure TLgrating.BuildResource;
var
  i,j: integer;
  res:integer;

  NV: integer;
  pvertices: pointer;
  Tred: single;


begin
  //messageCentral(ident +'  BuildResource');

  Fellipse1:=Fellipse;
  UseContour1:=UseContour;
  BlendAlpha1:=BlendAlpha;

  CurrentCol:=  syspal.DX9color(deg.lum,BlendAlpha);
  CurrentOri:=orientation*pi/180;
  CurrentPhase:= -frac(phase/360)*periode;

  CreateGaussTexture(false);
  CreateGratingTexture(gratingTexture0,false,false);
  CreateGratingTexture(gratingTextureSqr0,true,false);

  if UseContour and (length(Contour)>0) then BuildContourVertices(true)
  else
  if not Fellipse then
  begin
    NvertexTot:=4;
    getmem(vertices,NvertexTot*sizeof(TgratingVertex));
    fillchar(vertices^,sizeof(vertices^[0])*4,0);
    NV:=0;
    store2(NV,-0.5,0.5);
    store2(NV,-0.5,-0.5);
    store2(NV, 0.5,0.5);
    store2(NV, 0.5,-0.5);

  end
  else
  begin
    NvertexTot:=Nfan+2;
    getmem(vertices,NvertexTot*sizeof(TgratingVertex));
    fillchar(vertices^,sizeof(vertices^[0])*4,0);
    NV:=0;
    store2(NV,0,0);

    for i:=1 to Nfan+1 do store2(NV,0.5*cos(2*pi/Nfan*(i-1)), 0.5*sin(2*pi/Nfan*(i-1)) );
  end;


  DXscreen.messageRef('BuildVB1');
  VB:=nil;
  if FAILED(DXscreen.IDevice.CreateVertexBuffer(SizeOf(TgratingVertex)*NvertexTot, 0, GaborVertexCte, D3DPOOL_DEFAULT, VB, nil))  then
  begin
    AffDebug(' TLgrating.BuildResource : CreateVertexBuffer error',112);
    Exit;
  end;
  if FAILED(VB.Lock(0, 0, pVertices, 0)) then AffDebug(' TLgrating.BuildResource VBlock error',112)
  else
  begin
    CopyMemory(pVertices, @vertices[0], SizeOf(TgratingVertex)*NvertexTot);
    VB.Unlock;
  end;
  DXscreen.messageRef('BuildVB2');
  freemem(vertices);
  DX9end;

end;



procedure TLgrating.Blt(const degV: typeDegre);
var
  mat,mTrans, mRot, mScale: TD3DMatrix;
  res:integer;
  pVertices: pGvArray;
  i,j, Np: integer;
  Ag,Bg:single;
  Stage:integer;

begin
  CurrentOri:=orientation*pi/180;
  CurrentPhase:= -frac(phase/360)*periode;

  with deg, DXscreen.Idevice do
  begin
    D3DXMatrixScaling(mScale,dx,dy,1);
    D3DXMatrixTranslation(mTrans,x,y,Zdistance);
    D3DXMatrixRotationZ(mRot, theta*pi/180);
    D3DXMatrixMultiply(mat,mScale,mRot);
    D3DXMatrixMultiply(mat,mat,mTrans);

    res:= SetTransform(D3DTS_WORLD, mat);

    Stage:=0;

    if FsquareWave
      then SetTexture(0,GratingTextureSqr0)
      else SetTexture(0,GratingTexture0);

    // Test Start

    SetTextureStageState( 0, D3DTSS_TEXTURETRANSFORMFLAGS, D3DTTFF_COUNT2 );

    D3DXMatrixScaling(mScale,dx/periode,dy/periode,1);
    MatrixTranslation2D(mTrans,0, Currentphase/periode);
    D3DXMatrixRotationZ(mRot, -orientation*pi/180);
    D3DXMatrixMultiply(mat,mScale,mRot);
    D3DXMatrixMultiply(mat,mat,mTrans);

    SetTransform( D3DTS_TEXTURE0, mat);

    // Test End
    SetTextureStageState(Stage, D3DTSS_COLOROP,   D3DTOP_SELECTARG1);
    SetTextureStageState(Stage, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    SetTextureStageState(Stage, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);

    SetSamplerState(Stage, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
    SetSamplerState(Stage, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
    SetSamplerState(Stage, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );
    SetSamplerState(Stage, D3DSAMP_ADDRESSU,  D3DTADDRESS_WRAP );
    SetSamplerState(Stage, D3DSAMP_ADDRESSV,  D3DTADDRESS_WRAP );

    (*
    if Fellipse or UseContour then
    begin
      inc(stage);
      if UseContour
        then SetTexture(Stage,MaskTexture)
        else SetTexture(Stage,EllipseTexture0);

      SetTextureStageState(Stage, D3DTSS_CONSTANT, syspal.DX9colorI(128 ,255) );
      SetTextureStageState(Stage, D3DTSS_COLOROP,   D3DTOP_BLENDTEXTUREALPHA);
      SetTextureStageState(Stage, D3DTSS_COLORARG1, D3DTA_CURRENT);
      SetTextureStageState(Stage, D3DTSS_COLORARG2, D3DTA_CONSTANT);

      SetTextureStageState(Stage, D3DTSS_ALPHAOP,   D3DTOP_SELECTARG1);
      SetTextureStageState(Stage, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);


      SetSamplerState(Stage, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
      SetSamplerState(Stage, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
      SetSamplerState(Stage, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );
      SetSamplerState(Stage, D3DSAMP_ADDRESSU,  D3DTADDRESS_WRAP );
      SetSamplerState(Stage, D3DSAMP_ADDRESSV,  D3DTADDRESS_WRAP );

    end;
    *)

    inc(stage);

    Ag:=2*syspal.BKcolIndex/255*Contrast;
    if Ag>0.99 then Ag:=0.99;
    Bg:=syspal.BKcolIndex/255-Ag/2;

    SetSamplerState(Stage, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
    SetSamplerState(Stage, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
    SetSamplerState(Stage, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );

    SetTextureStageState(Stage, D3DTSS_CONSTANT, syspal.DX9colorI(round(Ag*255),255) );
    SetTextureStageState(Stage, D3DTSS_COLOROP,   D3DTOP_MODULATE);
    SetTextureStageState(Stage, D3DTSS_COLORARG1, D3DTA_CURRENT);
    SetTextureStageState(Stage, D3DTSS_COLORARG2, D3DTA_CONSTANT);

    SetTextureStageState(Stage, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);

    inc(stage);
    SetSamplerState(Stage, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
    SetSamplerState(Stage, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
    SetSamplerState(Stage, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );

    SetTextureStageState(Stage, D3DTSS_CONSTANT, syspal.DX9colorI(round(Bg*255),round(BlendAlpha*255)) );
    SetTextureStageState(Stage, D3DTSS_COLOROP,   D3DTOP_ADD);
    SetTextureStageState(Stage, D3DTSS_COLORARG1, D3DTA_CURRENT);
    SetTextureStageState(Stage, D3DTSS_COLORARG2, D3DTA_CONSTANT);

    SetTextureStageState(Stage, D3DTSS_ALPHAOP,   D3DTOP_MODULATE);
    SetTextureStageState(Stage, D3DTSS_ALPHAARG1, D3DTA_CONSTANT);
    SetTextureStageState(Stage, D3DTSS_ALPHAARG2, D3DTA_CURRENT);


    inc(stage);
    SetTextureStageState(Stage, D3DTSS_COLOROP,   D3DTOP_DISABLE);
    SetTextureStageState(Stage, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);

    res:=SetStreamSource(0, VB, 0, SizeOf(TgratingVertex));
    res:=SetFVF(GratingVertexCte);

    if UseContour then BltContourVertices
    else
    if not Fellipse
      then res:=DXscreen.IDevice.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2 )
      else res:=DXscreen.IDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Nfan );

    //DXscreen.Idevice.SetTexture(0,nil);
  end;

  DX9end;
end;





procedure TLgrating.afficheC;
var
  i:Integer;
  xc,yc:Integer;
begin
  degToPolyAff(deg,polyAff);

  xc:=(polyAff[1].x+polyAff[2].x) div 2;
  yc:=(polyAff[1].y+polyAff[2].y) div 2;

  with canvasGlb do
  begin
      pen.color:=clWhite;
      if MarkedSideVisible and (markedSide<>0) then
        begin
          moveto(polyAff[1].x,polyAff[1].y);
          for i:=2 to 5 do
            begin
              if i-1=markedSide then pen.Color:=ClRed
                                else pen.Color:=ClWhite;
              lineto(polyAff[i].x,polyAff[i].y);
            end;
          pen.color:=clWhite;
        end
      else polyLine(polyAff);
      ellipse(xc-3,yc-3,xc+3,yc+3);
  end;

  creerRegions;
end;



function TLgrating.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetGrating2;
end;

procedure TLgrating.setCircular(v:boolean);
begin
  if Fellipse<>v then
    begin
      Fellipse:=v;
      majpos;
    end;
end;


procedure TLgrating.installDialog(var form:Tgenform;var newF:boolean);
begin
  inherited installDialog(form,newF);

  TgetGrating2(Form).setGratingParams(contrast,periode,phase,orientation,Fellipse);;
  TgetGrating2(Form).circleD:=setCircular;
end;

procedure TLgrating.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin
      setVarConf('PERIODE',periode,sizeof(periode));
      setVarConf('PHASE',phase,sizeof(phase));
      setVarConf('CONTRAST',contrast,sizeof(contrast));
      setVarConf('CIRCLE',Fellipse,sizeof(Fellipse));
      setVarConf('ORIENT',orientation,sizeof(orientation));
      setVarConf('SQUAREWAVE',FsquareWave,sizeof(FsquareWave));
    end;
  end;


procedure TLgrating.setPhase(x:float);
begin
  phase:=x;
end;

function TLgrating.getInfo:AnsiString;
begin
  result:=inherited getInfo+CRLF+
          'Period='+Estr(periode,3)+crlf+
          'Phase='+Estr(phase,3)+crlf+
          'Contrast='+Estr(contrast,3)+crlf+
          'Orientation='+Estr(orientation,3);


end;

function TLgrating.getParamAd(name:Ansistring;var tp: typeNombre): pointer;
begin
  name:= Uppercase(name);

  tp:=nbSingle;
  if name='PERIOD' then result:=@periode
  else
  if name='PHASE' then result:=@Phase
  else
  if name='CONTRAST' then result:=@Contrast
  else
  if name='ORIENTATION' then result:=@Orientation
  else
  result:= inherited getParamAd(name,tp);

end;


{******************** Méthodes STM de TLgrating ***********************}

procedure proTLgrating_create(var pu:typeUO);
begin
  createPgObject('',pu,TLgrating);
end;

procedure proTLgrating_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TLgrating);
end;

procedure proTLgrating_period(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  if (x<=0) or (x>1000) then sortieErreur(E_period);
  with TLgrating(pu) do
  if x<>periode then
    begin
      periode:=x;
      majpos;
    end;
end;

function fonctionTLgrating_period(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLgrating(pu) do result:=periode;
end;

procedure proTLgrating_phase(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLgrating(pu) do
  if x<>phase then
    begin
      phase:=x;
      majpos;
    end;
end;

function fonctionTLgrating_phase(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLgrating(pu) do result:=phase;
end;


procedure proTLgrating_contrast(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  if (x<=0) then sortieErreur(E_contrast);
  with TLgrating(pu) do
  if x<>contrast then
    begin
      contrast:=x;
      majpos;
    end;
end;

function fonctionTLgrating_contrast(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLgrating(pu) do result:=contrast;
end;

procedure proTLgrating_diameter(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  if (x<=0) then sortieErreur(E_diameter);
  with TLgrating(pu) do
  if (x<>deg.dx) or (x<>deg.dy) then
    begin
      deg.dx:=x;
      deg.dy:=x;
      majpos;
    end;
end;

function fonctionTLgrating_diameter(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLgrating(pu) do
  begin
    if deg.dx<deg.dy then result:=deg.dx else result:=deg.dy;
  end;
end;

procedure proTLgrating_elliptic(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLgrating(pu) do
  if (x<>Fellipse) then
    begin
      Fellipse:=x;
      majpos;
    end;
end;

function fonctionTLgrating_elliptic(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TLgrating(pu) do
  begin
    result:=Fellipse;
  end;
end;

procedure proTLgrating_SquareWave(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLgrating(pu) do
  if (x<>FSquareWave) then
    begin
      FSquareWave:=x;
      majpos;
    end;
end;

function fonctionTLgrating_SquareWave(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TLgrating(pu) do
  begin
    result:=FSquareWave;
  end;
end;

procedure proTLgrating_orientation(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLgrating(pu) do
  if x<>orientation then
    begin
      orientation:=x;
      majpos;
    end;
end;

function fonctionTLgrating_orientation(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLgrating(pu) do result:=orientation;
end;

procedure proTLgrating_CudaTest(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLgrating(pu) do
  begin
     CudaTest(n);
  end;
end;


{****************************** Méthodes de TLgabor **************************}

constructor TLgabor.create;
  begin
    inherited create;

    Lx:=5;
    Ly:=5;
  end;


class function TLgabor.STMClassName:AnsiString;
  begin
    STMClassName:='LGabor';
  end;








function TLgabor.ResourceNeeded:boolean;
begin
  result:= (VB=nil) or (GratingTexture0=nil) or (GaussTexture0=nil) or (Fellipse<>Fellipse1) or
           FsquareWave and (GratingTextureSqr0=nil)  or (UseContour<>UseContour1) or (BlendAlpha<>BlendAlpha1);
end;

procedure TLgabor.store2(var NV:integer;Ax,Ay: float;Const Falloc:boolean=false);
begin
  if Falloc and (NV=0) then getmem(vertices,NvertexTot*sizeof(TgaborVertex));
  with vertices[NV] do
  begin
    x:=Ax;
    y:=Ay;
    z:= 0;
    color:=  Currentcol;

    u2:= Ax;
    v2:= Ay;

    u1:= Ax;
    v1:= Ay;

  end;
  inc(NV);
end;

procedure TLgabor.BuildResource;
var
  i,j: integer;
  res:integer;

  NV: integer;
  pvertices: pointer;
  xG,yG: single;
  Tred: single;


begin
  Fellipse1:=Fellipse;
  UseContour1:=UseContour;
  BlendAlpha1:=BlendAlpha;

  CurrentCol:=  syspal.DX9color(deg.lum,BlendAlpha);
  CurrentOri:=orientation*pi/180;
  CurrentPhase:= -frac(phase/360)*periode;

  CreateGaussTexture(false);
  CreateGratingTexture(gratingTexture0,false,false);
  CreateGratingTexture(gratingTextureSqr0,true,false);

  if UseContour and (length(Contour)>0) then  BuildContourVertices(true)
  else
  if not Fellipse then
  begin
    NvertexTot:=4;
    getmem(vertices,NvertexTot*sizeof(TgaborVertex));
    fillchar(vertices^,sizeof(vertices^[0])*4,0);
    NV:=0;
    store2(NV,-0.5,0.5);
    store2(NV,-0.5,-0.5);
    store2(NV, 0.5,0.5);
    store2(NV, 0.5,-0.5);
  end
  else
  begin
    NvertexTot:=Nfan+2;
    getmem(vertices,NvertexTot*sizeof(TgaborVertex));
    fillchar(vertices^,sizeof(vertices^[0])*4,0);
    NV:=0;
    store2(NV,0,0);

    for i:=1 to Nfan+1 do store2(NV,0.5*cos(2*pi/Nfan*(i-1)), 0.5*sin(2*pi/Nfan*(i-1)) );
  end;

  VB:=nil;
  if FAILED(DXscreen.IDevice.CreateVertexBuffer(SizeOf(TgaborVertex)*NvertexTot, 0, GaborVertexCte, D3DPOOL_DEFAULT, VB, nil)) then
  begin
    AffDebug(' TLgabor.BuildResource : CreateVertexBuffer error ',112);
    Exit;
  end;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then AffDebug(' TLgabor.BuildResource : VBlock error ',112)
  else
  begin
    CopyMemory(pVertices, @vertices[0], SizeOf(TgaborVertex)*NvertexTot);
    VB.Unlock;
  end;
  freemem(vertices);
  vertices:=nil;
  DX9end;
end;

procedure TLgabor.Blt(const degV: typeDegre);
var
  mat,mTrans, mRot, mScale, mscale2: TD3DMatrix;
  res:integer;
  i,j, NV, Np: integer;
  Ag,Bg: single;

begin
  NV:=0;
  CurrentOri:=orientation*pi/180;
  CurrentPhase:= -frac(phase/360)*periode;

  (*
   GaussTexture contient alpha décroissant de 1 à 0 , soit exp(-x²)

   GratingTexture contient 0.5 + 0.5*sin(x)

   Op 1 crée 0.5 + 0.5*exp(-x²)*sin(x)

   Op 2 multiplie par A
   Op 3 ajoute B

   Au final , on a A/2+B +A/2*exp(-x²)*sin(x)

   A/2 est l'amplitude de la sinusoïde
   A/2+B doit être égal au backGround,  donc B = BackGround -A/2

 *)

  with deg,DXscreen.Idevice do
  begin
    // Positionnement de l'objet
    D3DXMatrixScaling(mScale,dx,dy,1);
    D3DXMatrixTranslation(mTrans,x,y,Zdistance);
    D3DXMatrixRotationZ(mRot, theta*pi/180);
    D3DXMatrixMultiply(mat,mScale,mRot);
    D3DXMatrixMultiply(mat,mat,mTrans);

    res:= SetTransform(D3DTS_WORLD, mat);


    // Positionnement Texture0 (gaussienne):

    SetTexture(0,GaussTexture0);
    SetTextureStageState( 0, D3DTSS_TEXTURETRANSFORMFLAGS, D3DTTFF_COUNT2 );

    D3DXMatrixScaling(mScale,dx, dy,1);
    D3DXMatrixRotationZ(mRot, -orientation*pi/180);
    MatrixTranslation2D(mTrans,3*Lx,3*Ly);
    D3DXMatrixScaling(mScale2,1/(6*Lx),1/(6*Ly),1);
    D3DXMatrixMultiply(mat,mScale,mRot);
    D3DXMatrixMultiply(mat,mat,mTrans);
    D3DXMatrixMultiply(mat,mat,mScale2);
    SetTransform( D3DTS_TEXTURE0, mat);


    SetTextureStageState(0, D3DTSS_COLOROP,   D3DTOP_SELECTARG1);
    SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);

    SetTextureStageState(0, D3DTSS_ALPHAOP,   D3DTOP_SELECTARG1);
    SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);

    SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
    SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
    SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );
    SetSamplerState(0, D3DSAMP_ADDRESSU,  D3DTADDRESS_BORDER );
    SetSamplerState(0, D3DSAMP_ADDRESSV,  D3DTADDRESS_BORDER );
    SetSamplerState(0, D3DSAMP_BORDERCOLOR, D3Dcolor_rgba(0,0,0,0)  );

    // Positionnement Texture1 (grating):
    if FsquareWave
      then SetTexture(1,GratingTextureSqr0)
      else SetTexture(1,GratingTexture0);

    SetTextureStageState( 1, D3DTSS_TEXTURETRANSFORMFLAGS, D3DTTFF_COUNT2 );

    D3DXMatrixScaling(mScale,dx/periode,dy/periode,1);
    MatrixTranslation2D(mTrans,0, Currentphase/periode);
    D3DXMatrixRotationZ(mRot, -orientation*pi/180);
    D3DXMatrixMultiply(mat,mScale,mRot);
    D3DXMatrixMultiply(mat,mat,mTrans);

    SetTransform( D3DTS_TEXTURE1, mat);


    SetTextureStageState(1, D3DTSS_CONSTANT, syspal.DX9colorI(128,255) );
    SetTextureStageState(1, D3DTSS_COLOROP,   D3DTOP_BLENDCURRENTALPHA);
    SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    SetTextureStageState(1, D3DTSS_COLORARG2, D3DTA_CONSTANT);

    SetTextureStageState(1, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);

    SetSamplerState(1, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
    SetSamplerState(1, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
    SetSamplerState(1, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );
    SetSamplerState(1, D3DSAMP_ADDRESSU,  D3DTADDRESS_WRAP );
    SetSamplerState(1, D3DSAMP_ADDRESSV,  D3DTADDRESS_WRAP );

    // Stages 2 & 3: règlage des amplitudes
    Ag:=2*syspal.BKcolIndex/255*Contrast;
    if Ag>0.99 then Ag:=0.99;
    Bg:=syspal.BKcolIndex/255-Ag/2;

    SetSamplerState(2, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
    SetSamplerState(2, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
    SetSamplerState(2, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );

    SetTextureStageState(2, D3DTSS_CONSTANT, syspal.DX9colorI(round(Ag*255),255) );
    SetTextureStageState(2, D3DTSS_COLOROP,   D3DTOP_MODULATE);
    SetTextureStageState(2, D3DTSS_COLORARG1, D3DTA_CURRENT);
    SetTextureStageState(2, D3DTSS_COLORARG2, D3DTA_CONSTANT);

    SetTextureStageState(3, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);

    SetSamplerState(3, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
    SetSamplerState(3, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
    SetSamplerState(3, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );

    SetTextureStageState(3, D3DTSS_CONSTANT, syspal.DX9colorI(round(Bg*255),round(BlendAlpha*255)) );
    SetTextureStageState(3, D3DTSS_COLOROP,   D3DTOP_ADD);
    SetTextureStageState(3, D3DTSS_COLORARG1, D3DTA_CURRENT);
    SetTextureStageState(3, D3DTSS_COLORARG2, D3DTA_CONSTANT);

//      DXscreen.Idevice.SetTextureStageState(3, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);
    SetTextureStageState(3, D3DTSS_ALPHAOP,   D3DTOP_SELECTARG1);
    SetTextureStageState(3, D3DTSS_ALPHAARG1, D3DTA_CONSTANT);

    DXscreen.Idevice.SetTextureStageState(4, D3DTSS_COLOROP,   D3DTOP_DISABLE);
    DXscreen.Idevice.SetTextureStageState(4, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);

    res:=SetStreamSource(0, VB, 0, SizeOf(TgaborVertex));
    res:=SetFVF(GaborVertexCte);


    if UseContour then BltContourVertices
    else
    if not Fellipse
      then res:=DXscreen.IDevice.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2 )
      else res:=DXscreen.IDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Nfan );

    DXscreen.Idevice.SetTextureStageState(0, D3DTSS_COLOROP,   D3DTOP_DISABLE);
    DXscreen.Idevice.SetTextureStageState(1, D3DTSS_COLOROP,   D3DTOP_DISABLE);
    DXscreen.Idevice.SetTextureStageState(2, D3DTSS_COLOROP,   D3DTOP_DISABLE);

  end;

  DX9end;
end;


function TLgabor.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetGabor1;
end;

procedure TLgabor.installDialog(var form:Tgenform;var newF:boolean);
  begin
    installForm(form,newF);

    majPos;
    TgetGabor1(Form).onScreenD:=SetOnScreen;
    TgetGabor1(Form).onControlD:=SetonControl;
    TgetGabor1(Form).onlockD:=setLocked;
    TgetGabor1(Form).majpos:=majpos;

    TgetGabor1(Form).setDeg(deg,onScreen,onControl,locked);

    TgetGabor1(Form).enContrast.setVar(contrast,T_single);
    TgetGabor1(Form).enContrast.setMinMax(0,1);

    TgetGabor1(Form).enPeriod.setVar(Periode,T_single);
    TgetGabor1(Form).enPeriod.setMinMax(0,10000);

    TgetGabor1(Form).enPhase.setVar(Phase,T_single);
    TgetGabor1(Form).enPhase.setMinMax(0,0);

    TgetGabor1(Form).enOrient.setVar(orientation,T_single);
    TgetGabor1(Form).enOrient.setMinMax(0,0);


    TgetGabor1(Form).sbContrast.setParams(contrast,0.01,1);
    TgetGabor1(Form).sbContrast.dxSmall:=0.01;
    TgetGabor1(Form).sbContrast.dxLarge:=0.1;
    TgetGabor1(Form).sbContrast.onScrollV:=scrollV;

    TgetGabor1(Form).sbPhase.setParams(phase,-360,360);
    TgetGabor1(Form).sbPhase.onScrollV:=scrollV;

    TgetGabor1(Form).sbPeriod.setParams(periode,DdegMin,DegXmax);
    TgetGabor1(Form).sbPeriod.dxSmall:=0.01;
    TgetGabor1(Form).sbPeriod.dxLarge:=0.1;

    TgetGabor1(Form).sbPeriod.onScrollV:=scrollV;

    TgetGabor1(Form).sbOrient.setParams(orientation,-360,360);
    TgetGabor1(Form).sbOrient.onScrollV:=scrollV;

    TgetGabor1(Form).enLx.setVar(Lx,T_single);
    TgetGabor1(Form).enLx.decimal:=2;
    TgetGabor1(Form).enLx.setMinMax(0.1,100);

    TgetGabor1(Form).sbLx.setParams(Lx,0.1,100);
    TgetGabor1(Form).sbLx.dxSmall:=0.01;
    TgetGabor1(Form).sbLx.dxLarge:=0.1;
    TgetGabor1(Form).sbLx.onScrollV:=scrollV;

    TgetGabor1(Form).enLy.setVar(Ly,T_single);
    TgetGabor1(Form).enLy.decimal:=2;
    TgetGabor1(Form).enLy.setMinMax(0.1,100);

    TgetGabor1(Form).sbLy.setParams(Ly,0.1,100);
    TgetGabor1(Form).sbLy.dxSmall:=0.01;
    TgetGabor1(Form).sbLy.dxLarge:=0.1;
    TgetGabor1(Form).sbLy.onScrollV:=scrollV;

  end;

procedure TLgabor.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin
      setVarConf('LX',Lx,sizeof(Lx));
      setVarConf('LY',Ly,sizeof(Ly));
    end;
  end;


procedure TLgabor.scrollV(sender:Tobject;x:float;ScrollCode: TScrollCode);
begin
  case TscrollbarV(sender).tag of
    6: orientation:=x;
    7: contrast:=x;
    8: periode:=x;
    9: phase:=x;
    10: Lx:=x;
    11: Ly:=x;
  end;

  updateVisualInspector;
  majpos;
end;

function TLgabor.getInfo:AnsiString;
begin
  result:=inherited getInfo+CRLF+
          'Lx='+Estr(Lx,3)+crlf+
          'Ly='+Estr(Ly,3);
end;

function TLgabor.getParamAd(name:Ansistring;var tp: typeNombre): pointer;
begin
  name:= Uppercase(name);
  tp:=nbSingle;

  if name='LX' then result:=@Lx
  else
  if name='LY' then result:=@Ly
  else
  result:= inherited getParamAd(name,tp);

end;



{********************** Méthodes STM de TLgabor *****************************}

procedure proTLgabor_create(var pu:typeUO);
begin
  createPgObject('',pu,TLgabor);
end;

procedure proTLgabor_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TLgabor);
end;


procedure proTLgabor_Lx(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLgabor(pu) do
  if x<>lx then
    begin
      lx:=x;
      majpos;
    end;
end;

function fonctionTLgabor_Lx(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLgabor(pu) do result:=Lx;
end;

procedure proTLgabor_Ly(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLgabor(pu) do
  if x<>Ly then
    begin
      Ly:=x;
      majpos;
    end;
end;

function fonctionTLgabor_Ly(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLgabor(pu) do result:=Ly;
end;





Initialization
AffDebug('Initialization gratDX1',0);

installError(E_period,'TLgrating: Invalid period');
installError(E_phase,'TLgrating: Invalid phase');
installError(E_contrast,'TLgrating: Invalid contrast');
installError(E_diameter,'TLgrating: Invalid diameter');

if TestUnic then
begin
  registerObject(TLgrating,obvis);
  registerObject(TLgabor,obvis);
end;


AddFreeResourceProc( FreeGratDXResources);


finalization


FreeGratDXResources;


end.
