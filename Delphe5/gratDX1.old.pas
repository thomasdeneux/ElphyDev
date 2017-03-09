unit gratDX1.old;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, classes,stdCtrls,graphics,
     editCont,
     {$IFDEF DX9}
     DXtypes, Direct3D9, D3DX9,
     {$ELSE}
     DirectXG,DXdrawsG,
     {$ENDIF}
     DibG,
     util1,debug0,Dgraphic,
     stmDef,stmObj,stmobv0,varconf1,Ncdef2,stmError,

     defForm,getGrat2,getGab1,Dpalette,sysPal32,
     stmPg,stmGraph2;

type
  TLgrating=
          class(Tresizable)
            periode:single;    { Paramètres primaires ajoutés à deg }
            phase:single;
            contrast:single;
            Fellipse:boolean;
            orientation:single;

            periode1:single;    {Valeurs au moment de createHardBM}
            phase1:single;
            contrast1:single;
            Fond1:single;
            Fellipse1:boolean;
            orientation1:single;
            UseContour1: boolean;

            periodeAff:single;  {Valeurs au moment de createAffBM}
            phaseAff:single;
            contrastAff:single;
            FellipseAff:boolean;
            orientationAff:single;

            {$IFDEF DX9}
            VB: IDirect3DVertexBuffer9;
            GratingTexture: IDirect3DTexture9;
            GaussTexture: IDirect3DTexture9;

            Nvertex: integer;

           {$ELSE}
            BigBM,BMmask:TdirectDrawSurface;
            {$ENDIF}
            modeX:boolean;
            periodeX,periodeY:float;


            constructor create;override;
            destructor destroy;override;
            class function STMClassName:AnsiString;override;


            function ResourceNeeded:boolean;override;
            function AffaspectChanged:boolean;override;


            procedure freeBM;override;
            procedure BuildResource;override;
            procedure blt;override;

            procedure buildBMaff;override;



            function DialogForm:TclassGenForm;override;
            procedure installDialog(var form:Tgenform;var newF:boolean);
                                    override;


            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
            procedure setCircular(v:boolean);

            procedure afficheC;override;

            procedure setPhase(x:float);override;
            function getInfo:AnsiString;override;
          end;

  TLgabor=class(TLgrating)
            Lx,Ly:single;

            Lx1,Ly1:single;

            constructor create;override;
            class function STMClassName:AnsiString;override;


            function ResourceNeeded:boolean;override;
            function AffaspectChanged:boolean;override;

            procedure BuildResource;override;
            {$IFDEF DX9}

            procedure CreateGratingTexture;
            procedure CreateGaussTexture;
            procedure blt;override;
            {$ENDIF}

            procedure buildBMaff;override;


            function DialogForm:TclassGenForm;override;
            procedure installDialog(var form:Tgenform;var newF:boolean);
                                    override;

            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;

            procedure scrollV(sender:Tobject;x:float;ScrollCode: TScrollCode);
            function getInfo:AnsiString;override;
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



procedure proTLgabor_create(var pu:typeUO);pascal;
procedure proTLgabor_create_1(name:AnsiString;var pu:typeUO);pascal;

procedure proTLgabor_Lx(x:float;var pu:typeUO);pascal;
function fonctionTLgabor_Lx(var pu:typeUO):float;pascal;

procedure proTLgabor_Ly(x:float;var pu:typeUO);pascal;
function fonctionTLgabor_Ly(var pu:typeUO):float;pascal;


implementation


type
  TgratingVertex = packed record
    x, y, z: Single; // The untransformed position for the vertex
    color: DWORD;    // The vertex color
    u,v: single;
  end;

  TgvArray= array[0..0] of TgratingVertex;
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

  TgabVArray= array[0..0] of TgaborVertex;
  PgabvArray = ^TgabvArray;

const
  GaborVertexCte = D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX2;


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



function TLgrating.AffaspectChanged:boolean;
begin
  AffaspectChanged:=inherited AffaspectChanged OR
                    (periode<>periodeAff) OR
                    (contrast<>contrastAff) OR
                    (phase<>phaseAff) OR
                    (Fellipse<>FellipseAff) OR
                    (orientation<>orientationAff);
end;



{$IFDEF DX9}

procedure TLgrating.freeBM;
begin
  inherited;
  GratingTexture:=nil;
  VB:=nil;
end;


function TLgrating.ResourceNeeded:boolean;
begin
  result:= (VB=nil) or (GratingTexture=nil) or (Fellipse<>Fellipse1) or (UseContour<>UseContour);
end;

Const
  Nfan=100;

procedure TLgrating.BuildResource;
var
  i,j: integer;
  bm:Tbitmap;
  memoryStream: TmemoryStream;
  res:integer;

  vertices: array of TgratingVertex;
  NV: integer;
  col:integer;
  ori,Lphase: float;
  pvertices: pointer;
  xG,yG: single;

procedure store(i,j: integer);
begin
  with vertices[NV] do
  begin
    x:= -deg.dx/2 +deg.dx*i;
    y:= -deg.dy/2 +deg.dy*j ;
    z:=0;
    color:=  col;

    u:= (x*cos(ori)+y*sin(ori))/periode;
    v:= (-x*sin(ori)+y*cos(ori)+Lphase)/periode;
  end;
  inc(NV);
end;

procedure store2(Ax,Ay: single);
begin
  with vertices[NV] do
  begin
    x:=Ax;
    y:=Ay;
    z:=0;
    color:=  col;

    u:= (x*cos(ori)+y*sin(ori))/periode;
    v:= (-x*sin(ori)+y*cos(ori)+Lphase)/periode;
  end;
  inc(NV);
end;

begin
  // Create Texture
  bm:=Tbitmap.create;
  bm.Width:=512;
  bm.Height:=512;

  with bm.Canvas,syspal do
  for i:= 0 to bm.Width-1 do
  for j:= 0 to bm.height-1 do
  begin
    col:=lumIndex(BKlum+contrast*BKlum*cos(2*pi/512*j));
    pixels[i,j]:=rgb(0,col,0);
  end;

  Fellipse1:=Fellipse;
  UseContour1:=UseContour;

  memoryStream:= TmemoryStream.Create;
  bm.SaveToStream(memoryStream);

  res:=D3DXCreateTextureFromFileInMemory(DXscreen.Idevice,memoryStream.Memory,memoryStream.Size,GratingTexture);

  memoryStream.free;
  bm.free;

  col:=  syspal.DX9color(deg.lum);
  ori:=orientation*pi/180;
  Lphase:= -frac(phase/360)*periode;

  if UseContour and (length(Contour)>0) then
  begin
    Nvertex:=0;
    for i:=0 to length(Contour)-1 do
      Nvertex:=Nvertex + length(contour[i])+1 ;
    setLength(vertices,Nvertex);

    NV:=0;
    for i:=0 to length(Contour)-1 do
    if length(contour[i])>0 then
    begin
      xG:=0;
      yG:=0;
      for j:=0 to length(contour[i])-1 do
      with contour[i,j] do
      begin
        xG:=xG+x;
        yG:=yG+y;
      end;
      xG:=xG/length(contour[i]);
      yG:=yG/length(contour[i]);

      store2(xG,yG);
      for j:=0 to length(contour[i])-1 do
      with contour[i,j] do store2(x,y);
    end;
  end
  else

  if not Fellipse then
  begin
    setLength(vertices,4);
    NV:=0;
    store(0,1);
    store(0,0);
    store(1,1);
    store(1,0);

    Nvertex:=4;
  end
  else
  begin
    setLength(vertices,Nfan+2);
    NV:=0;

    store2(0,0);

    for i:=1 to Nfan+1 do store2(deg.dx/2*cos(2*pi/Nfan*(i-1)), deg.dy/2*sin(2*pi/Nfan*(i-1)) );
    Nvertex:=Nfan+2;
  end;

  VB:=nil;
  if FAILED(DXscreen.IDevice.CreateVertexBuffer(SizeOf(TgratingVertex)*Nvertex, 0, GratingVertexCte, D3DPOOL_DEFAULT, VB, nil)) then Exit;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then Exit;
  CopyMemory(pVertices, @vertices[0], SizeOf(TgratingVertex)*Nvertex);
  VB.Unlock;

  DX9end;
end;

procedure TLgrating.blt;
var
  mat,mTrans, mRot, mScale: TD3DMatrix;
  res:integer;
  pVertices: pGvArray;
  i,j, NV, Np: integer;
  ori,Lphase: float;
  xG,yG:single;

procedure modify(i,j:integer);
begin
  with pvertices^[NV] do      //
  begin
    x:= -deg.dx/2 +deg.dx*i;
    y:= -deg.dy/2 +deg.dy*j ;

    u:= (x*cos(ori)+y*sin(ori))/periode;
    v:= (-x*sin(ori)+y*cos(ori)+Lphase)/periode;
  end;
  inc(NV);
end;

procedure modify2(Ax,Ay:single);
begin
  with pvertices^[NV] do      //
  begin
    x:= Ax;
    y:= Ay ;

    u:= (x*cos(ori)+y*sin(ori))/periode;
    v:= (-x*sin(ori)+y*cos(ori)+Lphase)/periode;
  end;
  inc(NV);
end;


begin
  if FAILED(VB.Lock(0, 0, pointer(pVertices), 0)) then Exit;

  NV:=0;
  ori:=orientation*pi/180;
  Lphase:= -frac(phase/360)*periode;

  if UseContour then
  begin
    NV:=0;
    for i:=0 to length(Contour)-1 do
    if length(contour[i])>0 then
    begin
      xG:=0;
      yG:=0;
      for j:=0 to length(contour[i])-1 do
      with contour[i,j] do
      begin
        xG:=xG+x;
        yG:=yG+y;
      end;
      xG:=xG/length(contour[i]);
      yG:=yG/length(contour[i]);

      with  deg do modify2(xG*dx/dx0,yG*dx/dx0);
      for j:=0 to length(contour[i])-1 do
      with contour[i,j] do modify2(deg.dx/dx0*x,deg.dy/dy0*y);
    end;
  end
  else
  if not Fellipse then
  begin
    modify(0,1);
    modify(0,0);
    modify(1,1);
    modify(1,0);
  end
  else
  begin
    modify2(0,0);
    for i:=1 to Nfan+1 do modify2(deg.Dx/2*cos(2*pi/Nfan*(i-1)), deg.dy/2*sin(2*pi/Nfan*(i-1)) );

  end;
  VB.Unlock;


  with deg do
  begin
    D3DXMatrixTranslation(mTrans,x,y,0);
    D3DXMatrixRotationZ(mRot, theta*pi/180);
    D3DXMatrixMultiply(mat,mRot,mTrans);

    res:=DXscreen.IDevice.SetTransform(D3DTS_WORLD, mat);

    DXscreen.Idevice.SetTexture(0,GratingTexture);

      // Set up the default texture states.

    DXscreen.Idevice.SetTextureStageState(0, D3DTSS_COLOROP,   D3DTA_TEXTURE);
    DXscreen.Idevice.SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    DXscreen.Idevice.SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);
    DXscreen.Idevice.SetTextureStageState(0, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);

    // Set up the default sampler states.

    DXscreen.Idevice.SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
    DXscreen.Idevice.SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
    DXscreen.Idevice.SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );
    DXscreen.Idevice.SetSamplerState(0, D3DSAMP_ADDRESSU,  D3DTADDRESS_WRAP );
    DXscreen.Idevice.SetSamplerState(0, D3DSAMP_ADDRESSV,  D3DTADDRESS_WRAP );


    res:=DXscreen.IDevice.SetStreamSource(0, VB, 0, SizeOf(TgratingVertex));
    res:=DXscreen.IDevice.SetFVF(GratingVertexCte);

    if UseContour then
    begin
      Np:=0;
      for i:=0 to length(contour)-1 do
      begin
        res:=DXscreen.IDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, Np, length(contour[i])-1 );
        Np:=Np+  length(contour[i])+1;
      end;
    end
    else
    if not Fellipse
      then res:=DXscreen.IDevice.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2 )
      else res:=DXscreen.IDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Nfan );

    DXscreen.Idevice.SetTexture(0,nil);
  end;

  DX9end;
end;


{$ELSE}

procedure TLgrating.freeBM;
begin
  inherited;
  BMmask.free;
  BMmask:=nil;

  BigBM.free;
  BigBM:=nil;
end;

function TLgrating.ResourceNeeded:boolean;
begin
  ResourceNeeded:=inherited ResourceNeeded OR
                 (periode<>periode1) OR
                 (Fellipse<>Fellipse1) OR
                 (orientation<>orientation1) OR
                 (contrast<>contrast1) OR
                 (UseContour<>UseContour1);
end;

procedure TLgrating.BuildResource;
var
  ymin,ymax:integer;
  i,j,i1,i2:integer;
  cost,sint,d:float;
  k,k1,k2:integer;
  devC:integer;

  r,xx,x0,y0:float;
  degB:typeDegre;

  p:PtabOctet;
  desc:TDDsurfaceDesc2;

  periodeG:float;
  Hdib:Tdib;

  xw,yw:float;
  Apoly:array of Tpoint;
begin
  if not createHardBM then exit;

  BMmask:=TdirectdrawSurface.create(DXscreen.DDraw);
  fillchar(desc,sizeof(desc),0);
  with desc do
  begin
    dwSize:=sizeof(desc);
    dwFlags:=DDSD_CAPS+DDSD_height+DDSD_width;
    ddsCaps.dwCaps:=DDSCAPS_offscreenPlain;
    dwWidth:=hardBM.width;
    dwHeight:=hardBM.height;
  end;
  BMmask.createSurface(desc);

  sint:=sin((deg.theta+orientation)*pi/180);
  cost:=cos((deg.theta+orientation)*pi/180);
  modeX:=(abs(sint)>abs(cost));

  periodeG:=degToPix(periode);
  if modeX
    then periodeX:=periodeG/sint
    else periodeY:=periodeG/cost;


  BigBM:=TdirectdrawSurface.create(DXscreen.DDraw);
  fillchar(desc,sizeof(desc),0);
  with desc do
  begin
    dwSize:=sizeof(desc);
    dwFlags:=DDSD_CAPS+DDSD_height+DDSD_width;
    ddsCaps.dwCaps:=DDSCAPS_offscreenPlain;
    dwWidth:=xmaxEx-xminEx+10;
    dwHeight:=ymaxEx-yminEx+10;

    if modeX
      then inc(dwWidth,round(abs(periodeX)+1))
      else inc(dwHeight,round(abs(periodeY)+1));

  end;

  BigBM.createSurface(desc);



  periode1:=periode;
  Fellipse1:=Fellipse;
  orientation1:=orientation;
  contrast1:=contrast;


  cost:=cos(-(deg.theta+orientation)*pi/180);
  sint:=sin(-(deg.theta+orientation)*pi/180);

  if deg.dx<deg.dy then r:=deg.dx/2 else r:=deg.dy/2;
  x0:=xorg;
  y0:=yorg;

  degB:=deg;
  degB.x:=xorg;
  degB.y:=yorg;
  degB.dx:=degToPix(deg.dx);
  degB.dy:=degToPix(deg.dy);



  k1:=bigBM.bitCount div 8;
  case bigBM.bitCount of
    8:   begin
           k2:=0;
           devC:=1;
         end;
    32:  begin
           k2:=1;
           devC:=$01010101;
         end;
    else begin
           k2:=0;
           devC:=1;
         end;
  end;

  {Calcul de BigBM}
  HDib:=Tdib.create;       { Création de HardDib }
  HDib.SetSize(bigBM.Width ,BigBM.height,BigBM.bitCount);
  HDib.ColorTable:= MonoColorTable(VSsyncMode=1);

  TRY
    with Hdib do
    begin
      fill(0);
      for j:=0 to height-1 do
        begin
          p:=scanline[j];
          for i:=0 to width-1 do
            begin
              d:=((j-yOrg)*cost-(i-xOrg)*sint);
              with syspal do
              p^[i*k1+k2]:=lumIndex(BKlum+contrast*BKlum*cos(2*pi/periodeG*d));
            end;
        end;
    end;
    BigBM.LoadFromDIB(HDib);  {Rangement du résultat dans HardBM }
    BigBM.TransparentColor:=0;

  finally
    Hdib.Free;
  end;


    {Calcul du masque}

  if UseContour and (length(Contour)>0) then
  begin
    BMmask.Fill(0);
    devC:=getDevColor(BMmask,rgb(0,127,0));
    for j:=0 to length(contour)-1 do
    begin
      setlength(Apoly,length(contour[j]));

      for i:=0 to length(contour[j])-1 do
      begin
        if MagnifyContour then
          begin
            xw:=contour[j][i].x *deg.dx/Dx0;
            yw:=contour[j][i].y *deg.dy/Dy0;
          end
          else
          begin
            xw:=contour[j][i].x ;
            yw:=contour[j][i].y ;
          end;

        if RotateContour then degRotationR(xw,yw,xw,yw,0,0,deg.theta);

        Apoly[i].X:= BMmask.Width div 2+ DegToPix(xw);
        Apoly[i].Y:= BMmask.Height div 2- DegToPix(yw);
      end;

      with BMmask do
      try
        with canvas do
        begin
          pen.Color:=rgb(0,127,0);
          brush.color:=rgb(0,127,0);
          polygon(Apoly);
        end;
      finally
        canvas.release;
      end;
    end;
  end
  else
  with BMmask do
  begin
    fill(0);
    try
    lock;
    for j:=0 to height-1 do
      begin
        p:=scanline[j];
        if Fellipse
          then interDegEllipse(degB,j,i1,i2)
          else interPolyHline(poly,j,i1,i2);
        fillchar(p^[i1*k1],(i2-i1+1)*k1,1);
      end;
    finally
      unlock;
    end;
  end;

  BMmask.transparentColor:=devC;

  phase1:=11111111;
end;

procedure TLgrating.blt;
var
  phiR:float;
begin
  if (DXscreen=nil) or not DXscreen.candraw then exit;

  if phase<>phase1 then
    begin
      phiR:=frac(phase/360);
      if phiR<0 then phiR:=phiR+1;

      if modeX then
        begin
          phiR:=frac(phase/360*periodeX/abs(periodeX));
          if phiR<0 then phiR:=phiR+1;

          HardBM.Draw(0,0,
                      rect(round(abs(periodeX)*phiR),0,bigBM.width,bigBM.height),
                      bigBM,false);
        end
      else
        begin
          phiR:=frac(phase/360*periodeY/abs(periodeY));
          if phiR<0 then phiR:=phiR+1;

          HardBM.Draw(0,0,
                         rect(0,round(abs(periodeY)*phiR),bigBM.width,bigBM.height),
                         bigBM,false);
        end;

      hardBM.Draw(0,0,BMmask,true);
      phase1:=phase;
    end;

  inherited blt;
end;
{$ENDIF}

procedure TLgrating.buildBMaff;
begin
end;

procedure TLgrating.afficheC;
var
  i:Integer;
  xc,yc:Integer;
begin
  degToPoly(deg,poly);
  for i:=1 to 5 do
    begin
      polyAff[i].x:=Sconvx(poly[i].x);
      polyAff[i].y:=Sconvy(poly[i].y);
    end;

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





function TLgabor.AffaspectChanged:boolean;
begin
  AffaspectChanged:=inherited AffaspectChanged OR
                    (periode<>periodeAff) OR
                    (contrast<>contrastAff) OR
                    (phase<>phaseAff) OR
                    (Fellipse<>FellipseAff) OR
                    (orientation<>orientationAff);
end;


{$IFDEF DX9}

function TLgabor.ResourceNeeded:boolean;
begin
  result:= (VB=nil) or (GratingTexture=nil) or (GaussTexture=nil) or (Fellipse<>Fellipse1);
end;


procedure TLgabor.CreateGratingTexture;
var
  i,j: integer;
  bm:Tbitmap;
  memoryStream: TmemoryStream;
  res:integer;
begin

  bm:=Tbitmap.create;
  bm.Width:=2;
  bm.Height:=512;

  with bm.Canvas do
  for i:= 0 to bm.Width-1 do
  for j:= 0 to bm.height-1 do
   pixels[i,j]:=rgb(0,round(128+ 100*cos(2*pi/512*j)),0);

  memoryStream:= TmemoryStream.Create;
  bm.SaveToStream(memoryStream);

  res:=D3DXCreateTextureFromFileInMemory(DXscreen.Idevice,memoryStream.Memory,memoryStream.Size,GratingTexture);
  memoryStream.free;
  bm.free;
end;


procedure TLgabor.CreateGaussTexture;
var
  i,j: integer;
  res:integer;
  xRect: D3DLOCKED_RECT;
  p:PtabLong;
  alpha, L0: single;
Const
  TextureSize=512;
begin
  res:=D3DXCreateTexture(DXscreen.Idevice,TextureSize,TextureSize,0,D3DUSAGE_AUTOGENMIPMAP,D3DFMT_A8R8G8B8,D3DPOOL_MANAGED,GaussTexture);

  if GaussTexture.LockRect( 0, xrect, nil, 0) =0 then
  begin
    L0:= TextureSize/6;

    with xRect do
    begin
      for j:= 0 to TextureSize-1 do
      begin
        p:= pointer(intG(pbits)+pitch*j);
        for i:= 0 to TextureSize-1 do
        begin
          alpha:= 255 *exp(- sqr((i-TextureSize/2)/L0)-sqr((j-TextureSize/2)/L0));
          p^[i]:=D3Dcolor_rgba(0,0,0,round(alpha) );
        end;
      end;
    end;

    res:=GaussTexture.UnlockRect(0);
  end;
end;


procedure TLgabor.BuildResource;
var
  i,j: integer;
  bm:Tbitmap;
  memoryStream: TmemoryStream;
  res:integer;

  vertices: array of TgaborVertex;
  NV: integer;
  col:integer;
  ori,Lphase: float;
  pvertices: pointer;
  xG,yG: single;
  Tred: single;

procedure store(i,j: integer);
begin
  with vertices[NV] do
  begin
    x:= -deg.dx/2 +deg.dx*i;
    y:= -deg.dy/2 +deg.dy*j ;
    z:=0;
    color:=  col;

    u2:= (x*cos(ori)+y*sin(ori))/periode;
    v2:= (-x*sin(ori)+y*cos(ori)+Lphase)/periode;

    u1:= 0.5+(x*cos(ori)+y*sin(ori))/(6*Lx);
    v1:= 0.5+(-x*sin(ori)+y*cos(ori))/(6*Ly);

  end;
  inc(NV);
end;

procedure store2(Ax,Ay: single);
begin
  with vertices[NV] do
  begin
    x:=Ax;
    y:=Ay;
    z:=0;
    color:=  col;

    u2:= (x*cos(ori)+y*sin(ori))/periode;
    v2:= (-x*sin(ori)+y*cos(ori)+Lphase)/periode;

    u1:= 0.5+(x*cos(ori)+y*sin(ori))/(6*Lx);
    v1:= 0.5+(-x*sin(ori)+y*cos(ori))/(6*Ly);

  end;
  inc(NV);
end;

begin

  col:=  syspal.DX9color(deg.lum);
  ori:=orientation*pi/180;
  Lphase:= -frac(phase/360)*periode;

  CreateGaussTexture;
  CreateGratingTexture;

  if UseContour and (length(Contour)>0) then
  begin
    Nvertex:=0;
    for i:=0 to length(Contour)-1 do
      Nvertex:=Nvertex + length(contour[i])+1 ;
    setLength(vertices,Nvertex);

    NV:=0;
    for i:=0 to length(Contour)-1 do
    if length(contour[i])>0 then
    begin
      xG:=0;
      yG:=0;
      for j:=0 to length(contour[i])-1 do
      with contour[i,j] do
      begin
        xG:=xG+x;
        yG:=yG+y;
      end;
      xG:=xG/length(contour[i]);
      yG:=yG/length(contour[i]);

      store2(xG,yG);
      for j:=0 to length(contour[i])-1 do
      with contour[i,j] do store2(x,y);
    end;
  end
  else

  if not Fellipse then
  begin
    setLength(vertices,4);
    NV:=0;
    store(0,1);
    store(0,0);
    store(1,1);
    store(1,0);

    Nvertex:=4;
  end
  else
  begin
    setLength(vertices,Nfan+2);
    NV:=0;

    store2(0,0);

    for i:=1 to Nfan+1 do store2(deg.dx/2*cos(2*pi/Nfan*(i-1)), deg.dy/2*sin(2*pi/Nfan*(i-1)) );
    Nvertex:=Nfan+2;
  end;

  VB:=nil;
  if FAILED(DXscreen.IDevice.CreateVertexBuffer(SizeOf(TgaborVertex)*Nvertex, 0, GaborVertexCte, D3DPOOL_DEFAULT, VB, nil)) then Exit;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then Exit;
  CopyMemory(pVertices, @vertices[0], SizeOf(TgaborVertex)*Nvertex);
  VB.Unlock;

  DX9end;
end;

procedure TLgabor.blt;
var
  mat,mTrans, mRot, mScale: TD3DMatrix;
  res:integer;
  pVertices: pGabvArray;
  i,j, NV, Np: integer;
  ori,Lphase: float;
  xG,yG:single;
  Ag,Bg: single;

procedure modify(i,j:integer);
begin
  with pvertices^[NV] do      //
  begin
    x:= -deg.dx/2 +deg.dx*i;
    y:= -deg.dy/2 +deg.dy*j ;

    u2:= (x*cos(ori)+y*sin(ori))/periode;
    v2:= (-x*sin(ori)+y*cos(ori)+Lphase)/periode;

    u1:= 0.5+ (x*cos(ori)+y*sin(ori))/(6*Lx);
    v1:= 0.5+ (-x*sin(ori)+y*cos(ori))/(6*Ly);

  end;
  inc(NV);
end;

procedure modify2(Ax,Ay:single);
begin
  with pvertices^[NV] do      //
  begin
    x:= Ax;
    y:= Ay ;

    u2:= (x*cos(ori)+y*sin(ori))/periode;
    v2:= (-x*sin(ori)+y*cos(ori)+Lphase)/periode;

    u1:= 0.5+ (x*cos(ori)+y*sin(ori))/(6*Lx);
    v1:= 0.5+ (-x*sin(ori)+y*cos(ori))/(6*Ly);

  end;
  inc(NV);
end;


begin
  if FAILED(VB.Lock(0, 0, pointer(pVertices), 0)) then Exit;

  NV:=0;
  ori:=orientation*pi/180;
  Lphase:= -frac(phase/360)*periode;

  if UseContour then
  begin
    NV:=0;
    for i:=0 to length(Contour)-1 do
    if length(contour[i])>0 then
    begin
      xG:=0;
      yG:=0;
      for j:=0 to length(contour[i])-1 do
      with contour[i,j] do
      begin
        xG:=xG+x;
        yG:=yG+y;
      end;
      xG:=xG/length(contour[i]);
      yG:=yG/length(contour[i]);

      with  deg do modify2(xG*dx/dx0,yG*dx/dx0);
      for j:=0 to length(contour[i])-1 do
      with contour[i,j] do modify2(deg.dx/dx0*x,deg.dy/dy0*y);
    end;
  end
  else
  if not Fellipse then
  begin
    modify(0,1);
    modify(0,0);
    modify(1,1);
    modify(1,0);
  end
  else
  begin
    modify2(0,0);
    for i:=1 to Nfan+1 do modify2(deg.Dx/2*cos(2*pi/Nfan*(i-1)), deg.dy/2*sin(2*pi/Nfan*(i-1)) );

  end;
  VB.Unlock;

  (*
   GaussTexture contient alpha décroissant de 1 à 0 , soit exp(-x²)

   GratingTexture contient 0.5 + 0.5*sin(x)

   Op 0 crée 0.5 + 0.5*exp(-x²)*sin(x)

   Op 1 multiplie par A
   Op 2 ajoute B

   Au final , on a A/2+B +A/2*exp(-x²)*sin(x)

   A/2 est l'amplitude de la sinusoïde
   A/2+B doit être égal au backGround,  donc B = BackGround -A/2


 *)

  with deg do
  begin
    D3DXMatrixTranslation(mTrans,x,y,0);
    D3DXMatrixRotationZ(mRot, theta*pi/180);
    D3DXMatrixMultiply(mat,mRot,mTrans);

    res:=DXscreen.IDevice.SetTransform(D3DTS_WORLD, mat);

    with DXscreen.Idevice do
    begin
      SetTexture(0,GaussTexture);

      SetTextureStageState(0, D3DTSS_COLOROP,   D3DTOP_SELECTARG1);
      SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
      SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);

      SetTextureStageState(0, D3DTSS_ALPHAOP,   D3DTOP_SELECTARG1);
      SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
      SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);

      SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
      SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
      SetSamplerState(0, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );
      SetSamplerState(0, D3DSAMP_ADDRESSU,  D3DTADDRESS_BORDER );
      SetSamplerState(0, D3DSAMP_ADDRESSV,  D3DTADDRESS_BORDER );
      SetSamplerState(0, D3DSAMP_BORDERCOLOR, D3Dcolor_rgba(0,0,0,0)  );


      SetTexture(1,GratingTexture);
      SetTextureStageState(1, D3DTSS_CONSTANT, D3Dcolor_rgba(0,128,0,255) );
      SetTextureStageState(1, D3DTSS_COLOROP,   D3DTOP_BLENDCURRENTALPHA);
      SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_TEXTURE);
      SetTextureStageState(1, D3DTSS_COLORARG2, D3DTA_CONSTANT);

      SetSamplerState(1, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
      SetSamplerState(1, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
      SetSamplerState(1, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );
      SetSamplerState(1, D3DSAMP_ADDRESSU,  D3DTADDRESS_WRAP );
      SetSamplerState(1, D3DSAMP_ADDRESSV,  D3DTADDRESS_WRAP );

      Ag:=2*syspal.BKcolIndex/255*Contrast;
      Bg:=syspal.BKcolIndex/255-Ag/2;

      SetSamplerState(2, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
      SetSamplerState(2, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
      SetSamplerState(2, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );

      SetTextureStageState(2, D3DTSS_CONSTANT, D3Dcolor_rgba(0,round(Ag*255),0,255) );
      SetTextureStageState(2, D3DTSS_COLOROP,   D3DTOP_MODULATE);
      SetTextureStageState(2, D3DTSS_COLORARG1, D3DTA_CURRENT);
      SetTextureStageState(2, D3DTSS_COLORARG2, D3DTA_CONSTANT);

      SetSamplerState(3, D3DSAMP_MINFILTER, D3DTEXF_LINEAR );
      SetSamplerState(3, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR );
      SetSamplerState(3, D3DSAMP_MIPFILTER, D3DTEXF_LINEAR );

      SetTextureStageState(3, D3DTSS_CONSTANT, D3Dcolor_rgba(0,round(Bg*255),0,255) );
      SetTextureStageState(3, D3DTSS_COLOROP,   D3DTOP_ADD);
      SetTextureStageState(3, D3DTSS_COLORARG1, D3DTA_CURRENT);
      SetTextureStageState(3, D3DTSS_COLORARG2, D3DTA_CONSTANT);

      res:=SetStreamSource(0, VB, 0, SizeOf(TgaborVertex));
      res:=SetFVF(GaborVertexCte);
    end;

    if UseContour then
    begin
      Np:=0;
      for i:=0 to length(contour)-1 do
      begin
        res:=DXscreen.IDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, Np, length(contour[i])-1 );
        Np:=Np+  length(contour[i])+1;
      end;
    end
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


{$ELSE}

function TLgabor.ResourceNeeded:boolean;
begin
  ResourceNeeded:=(deg.dx<>deg1.dx) or (deg.dy<>deg1.dy)
                  or (deg.theta<>deg1.theta) or (deg.lum<>deg1.lum) or
                 (periode<>periode1) OR
                 (Fellipse<>Fellipse1) OR
                 (orientation<>orientation1) OR
                 (Lx<>Lx1) OR
                 (Ly<>Ly1) OR
                 (phase<>phase1) OR
                 (contrast<>contrast1);

end;

procedure TLgabor.BuildResource;
var
  ymin,ymax:integer;
  i,j,i1,i2:integer;
  cost,sint,d:float;
  k,k1,k2:integer;

  tb:array[0..2000] of byte;
  resol:float;

  r,xx,x0,y0:float;
  degB:typeDegre;

  g,gmin,gmax,di,dj:float;
  p:ptabOctet;

  LxG,LyG,periodeG:float;
  u:integer;

  Hdib:Tdib;
begin

  if not createHardBM then exit;

  periode1:=periode;
  Fellipse1:=Fellipse;
  orientation1:=orientation;
  Lx1:=Lx;
  Ly1:=Ly;
  phase1:=phase;
  contrast1:=contrast;

  LxG:=degToPix(Lx);
  LyG:=degToPix(Ly);
  periodeG:=degToPix(periode);


  cost:=cos(-(deg.theta+orientation)*pi/180);
  sint:=sin(-(deg.theta+orientation)*pi/180);

  if deg.dx<deg.dy then r:=deg.dx/2 else r:=deg.dy/2;
  x0:=xorg;
  y0:=yorg;

  degB:=deg;
  degB.x:=xorg;
  degB.y:=yorg;
  degB.dx:=degToPix(deg.dx);
  degB.dy:=degToPix(deg.dy);


  gmin:=syspal.BKlum*(1-contrast);
  gmax:=syspal.BKlum*(1+contrast);

  k1:=hardBM.bitCount div 8;
  case hardBM.bitCount of
    8:   k2:=0;
    32:  k2:=1;
    else k2:=0;
  end;

  HDib:=Tdib.create;       { Création de HardDib }
  HDib.SetSize(HardBM.Width ,HardBM.height,hardBM.bitCount);
  HDib.ColorTable:= MonoColorTable(VSsyncMode=1);

  TRY
    with Hdib do
    begin
      fill(0);
      for j:=0 to Hdib.height-1 do
        begin
          if Fellipse then
            begin
              interDegEllipse(degB,j,i1,i2);
            end
          else interPolyHline(poly,j,i1,i2);

          p:=scanline[j];

          for i:=i1 to i2 do
            begin
              di:=i-xOrg;
              dj:=j-yOrg;
              d:=dj*cost-di*sint;

              g:=(gmax-gmin)/2*exp(-0.5*(sqr((di*cost+dj*sint)/LxG)+sqr((-di*sint+dj*cost)/LyG)))
                 *cos(2*pi/periodeG*d+phase*pi/180)+(gmax+gmin)/2;
              with syspal do
              begin
                u:=lumIndex(g);
                if u=BKcolIndex
                  then p^[i*k1+k2]:=0
                  else p^[i*k1+k2]:=u;

              end;
            end;
        end;
    end;

    hardBM.LoadFromDIB(HDib);  {Rangement du résultat dans HardBM }
    hardBM.TransparentColor:=0;
  finally
    Hdib.Free;
  end;
end;
{$ENDIF}




procedure TLgabor.buildBMaff;
var
  i,j,k:integer;
  d:float;
  i1,i2:integer;
  cost,sint:float;

  tb:array[0..2000] of byte;
  pol:typePoly5;

  r,x0,y0,xx:float;
  degB:typeDegre;
  di,dj,g,gmin,gmax:float;
  p:ptabOctet;
  periodeG:float;

begin
  if not createBmaff then exit;

  periodeAff:=periode;
  phaseAff:=phase;
  contrastAff:=contrast;
  FellipseAff:=Fellipse;
  orientationAff:=orientation;

  degToPoly(deg,poly);
  for i:=1 to 5 do
    begin
      polyAff[i].x:=Sconvx(poly[i].x);
      polyAff[i].y:=Sconvy(poly[i].y);
    end;

  pol:=polyAff;
  for i:=1 to 5 do
    begin
      dec(pol[i].x,xminAff);
      dec(pol[i].y,yminAff);
    end;

  if deg.dx<deg.dy then r:=deg.dx/2 else r:=deg.dy/2;
  x0:=xaff;
  y0:=yaff;

  r:=Sconvx(r);

  periodeG:=degToPix(periode);

  with BMaff do
  begin
    fill(0);

    cost:=cos(-(deg.theta+orientation)*pi/180);
    sint:=sin(-(deg.theta+orientation)*pi/180);

    for j:=0 to height-1 do
      begin
        if Fellipse then
          begin
            degB:=deg;
            degB.x:=xaff;
            degB.y:=yaff;

            degB.dx:=degToPixC(deg.dx);
            degB.dy:=degToPixC(deg.dy);

            interDegEllipse(degB,j,i1,i2);
          end
        else
        interPolyHline(pol,j,i1,i2);

        p:=scanline[j];
        gmin:=1;
        gmax:=61;
        for i:=i1 to i2 do
          begin
            di:=Sinvconvx(i-xaff);
            dj:=Sinvconvy(j-yaff);
            d:=dj*cost-di*sint;

            g:=128*exp(-0.5*(sqr((di*cost+dj*sint)/Lx)+sqr((-di*sint+dj*cost)/Ly)))
               *cos(2*pi/periodeG*d+phase*pi/180)+128;


            pixels[i,j]:=rgb(0,round(g),0);
          end;
    end;
  end;
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

end.
