unit DirectD0;

interface

uses classes,Forms, SysUtils, DirectXGS, Windows, Graphics,
util1,debug0,Dpalette;


type
  {TDDcanvas définit un canvas attaché à une surface directdraw. Ce qui permet
   d'utiliser facilement les fonctions GDI sur une surface }
  TDDcanvas =
      class(Tcanvas)
      private
        Fsurface:IdirectDrawSurface4;
      public
        constructor Create(Asurface: IdirectDrawSurface4 );
        destructor Destroy; override;
      end;

  {TDDsurface encapsule une surface DirectDraw}
  TDDsurface=
    class
      surface:IDirectDrawSurface4 ;
      canvas:TDDcanvas;
      canvasRef:integer;
      attached:boolean;

      lpSurface:PtabOctet;
      width,height,pitch:integer;

      constructor create(ddraw:IdirectDraw4;var surfaceDesc:TDDSURFACEDESC2);
      constructor createAttached(MainSurf:IdirectDrawSurface4;
                                 var BackCaps:TDDSCAPS2);
      destructor destroy;override;

      procedure initCanvas;
      procedure doneCanvas;
      procedure clear(color:integer);
      procedure clearRect(rr:Trect;color:integer);

      procedure lock;
      procedure unlock;
      function PixelAd(i,j:integer):PtabOctet;
      procedure FillLine(var tb;i,j,nb:integer);
      procedure setColorKey(n1,n2:integer);

      procedure restore;
    end;


  {TDDscreen permet de gérer complètement un objet directDraw en mode plein écran
   exclusif, avec 2 buffers, une palette et un clipper.
  }
  TDDScreen = class
    public
    ddraw:IdirectDraw4;
    Front, Back: TDDSurface ;

    PaletteON: IDirectDrawPalette ;
    clipper:IdirectDrawClipper;

    constructor Create (Width, Height, Depth: DWORD;Numguid:integer) ;
    destructor Destroy ; override ;
    procedure Flip(wait:boolean) ;virtual;
    procedure flipRect(rr:Trect);
    procedure BltBackRect(surf:TDDsurface;rr:Trect);
    function createSingleSurface(dx,dy:integer):TDDsurface;
    procedure BLT(surf:TDDsurface;x,y:integer);

    function getCaps:string;
  end ;

  {TDDnormalWindow permet de gérer complètement un objet directDraw en mode
   fenêtre normale.
  }
  TDDNormalWindow = class ( TDDscreen)
    public
    wnd0:hwnd;
    constructor Create(wnd:hwnd;ppal:PmaxLogPalette) ;
    destructor destroy;override;
    procedure flip(wait:boolean);override;
    procedure modifySize;
  end ;


procedure initDirectD0;
function createRectClipper(ddraw:IdirectDraw4; x1,y1,x2,y2:integer):IdirectDrawClipper;


IMPLEMENTATION

{--------- TDDcanvas -------------}

constructor TDDcanvas.Create(Asurface: IdirectDrawSurface4 );
var
  dd:Hresult;
  dc:hdc;
begin
  inherited create;
  Fsurface:=Asurface;
  dd:=Fsurface.getDC(dc);
  if dd<>DD_OK then messageCentral('TDDcanvas.create failed: '+longtoHexa(dd)+' '+DDerrorString(dd) ) ;
  handle:=dc;
end;


destructor TDDcanvas.Destroy;
var
  dd:hresult;
  hand:Thandle;
begin
  hand:=handle;
  handle:=0;
  if hand<>0 then
    begin
      dd:=Fsurface.releaseDC(hand);
      if dd<>DD_OK then  messageCentral('TDDcanvas.destroy failed: '+longtoHexa(dd)+' '+DDerrorString(dd) );
    end;
  inherited destroy;
end;

{------------ TDDsurface -----------}

constructor TDDsurface.create(ddraw:IdirectDraw4;var surfaceDesc:TDDSURFACEDESC2);
var
  dd:hresult;
begin
  if ddraw=nil then
    begin
      affdebug('TDDsurface.create ddraw=nil',0);
      exit;
    end;

  affdebug('TDDsurface.create 001',0);
  dd := DDraw.CreateSurface ( SurfaceDesc, surface, nil ) ;
  affdebug('TDDsurface.create 002 '+Istr(dd)+DDerrorString(dd),0);
  if dd <> DD_OK then
    begin
      messageCentral('IDirectDraw.CreateSurface failed:'
               +Istr(surfaceDesc.dwWidth)+' '
               +Istr(surfaceDesc.dwHeight)
               +longtoHexa(dd)+' '+DDerrorString(dd) ) ;
      exit;
    end;

  fillchar(surfaceDesc,sizeof(surfaceDesc),0);
  surfaceDesc.dwSize:=sizeof(surfaceDesc);

  affdebug('TDDsurface.create 002bis',0);
  dd:=surface.getSurfaceDesc(surfaceDesc);
  affdebug('TDDsurface.create 003',0);

  width:=surfaceDesc.dwWidth;
  height:=surfaceDesc.dwHeight;
  pitch:=surfaceDesc.lPitch;
end;

constructor TDDsurface.createAttached(MainSurf:IdirectDrawSurface4;
                                      var BackCaps:TDDSCAPS2);
var
  dd:hresult;
begin
  if mainSurf=nil then exit;
  dd := MainSurf.GetAttachedSurface (BackCaps, surface);
  if dd <> DD_OK then
    messageCentral('IDirectDrawSurface.GetAttachedSurface failed: '+longtoHexa(dd)+' '+DDerrorString(dd) );
  attached:=true;
end;

destructor TDDsurface.destroy;
var
  dd:hresult;
begin
  if surface=nil then exit;
  doneCanvas;
  if (surface<>nil) and not attached then
    begin
      surface:=nil;
    end;
end;

procedure TDDsurface.initCanvas;
begin
  if surface=nil then exit;
  restore;
  if canvasRef=0 then canvas:=TDDcanvas.create(surface);
  inc(canvasRef);
end;

procedure TDDsurface.doneCanvas;
begin
  if surface=nil then exit;
  if canvasRef>0 then dec(canvasRef);
  if (canvas<>nil) and (canvasRef=0) then
    begin
      canvas.free;
      canvas:=nil;
    end;
end;

procedure TDDsurface.clear(color:integer);
var
  TestBltEx: TDDBLTFX ;
  dd:hresult;
begin
  if surface=nil then exit;

  fillchar(TestBltEx,sizeof(TestBltEx),0);
  TestBltEx.dwSize := sizeof ( TestBltEx ) ;
  TestBltEx.dwFillColor := Color ;

  dd:=Surface.Blt ( nil, nil,nil, DDBLT_COLORFILL + DDBLT_WAIT, @TestBltEx ) ;
  if dd<>DD_OK then messageCentral('surface.BLT failed: '+longtoHexa(dd)+' '+DDerrorString(dd));

end;

procedure TDDsurface.clearRect(rr:Trect;color:integer);
var
  TestBltEx: TDDBLTFX ;
  dd:hresult;
begin
  if surface=nil then exit;

  if isRectEmpty(rr) then exit;

  zeroMemory(@TestBltEx,sizeof(TestBltEx));
  TestBltEx.dwSize := sizeof ( TestBltEx ) ;
  TestBltEx.dwFillColor := Color ;
  dd:=Surface.Blt ( @rr, nil,nil, DDBLT_COLORFILL + DDBLT_WAIT, @TestBltEx ) ;
  if dd<>DD_OK then messageCentral('surface.BLT failed: '+longtoHexa(dd)+' '+DDerrorString(dd)
                    +' '+Istr(rr.left)+' '+Istr(rr.top)
                    +' '+Istr(rr.right)+' '+Istr(rr.bottom)
  );
end;



procedure TDDsurface.lock;
var
  dd:hresult;
  surfaceDesc:TDDSURFACEDesc2;
begin
  if surface=nil then exit;
  surfaceDesc.dwSize:=sizeof(surfaceDesc);

  dd:=surface.lock(nil,surfaceDesc,ddlock_wait,0);
  if dd <> DD_OK then messageCentral('surface.lock failed: '+longtoHexa(dd)+' '+DDerrorString(dd));

  lpSurface:=surfaceDesc.lpSurface;
  width:=surfaceDesc.dwWidth;
  height:=surfaceDesc.dwHeight;
  pitch:=surfaceDesc.lPitch;

end;

procedure TDDsurface.unlock;
var
  dd:hresult;
begin
  if surface=nil then exit;
  dd:=surface.unlock(nil);
  if dd <> DD_OK then messageCentral('surface.unlock failed: '+longtoHexa(dd)+' '+DDerrorString(dd)) ;
end;

function TDDsurface.PixelAd(i,j:integer):PtabOctet;
var
  dd:hresult;
begin
  if surface=nil then exit;
  PixelAd:=Pointer(integer(lpSurface)+j*pitch+i);
end;

procedure TDDsurface.FillLine(var tb;i,j,nb:integer);
begin
  if surface=nil then exit;
  if (j<0) or (j>=height) or (i>=width) then exit;

  if i<0 then
    begin
      nb:=nb+i;
      if nb<=0 then exit;
      i:=0;
    end
  else
  if (i+nb>width) then nb:=width-i;

  move(tb,pixelAd(i,j)^,nb);
end;

procedure TDDsurface.setColorKey(n1,n2:integer);
var
  colorKey:TDDColorKey;
  dd:Hresult;
begin
  if surface=nil then exit;
  with colorKey do
  begin
    dwColorSpaceLowValue:=n1;
    dwColorSpaceHighValue:=n2;
  end;
  dd:=surface.setColorKey(DDCKEY_SrcBlt,@colorKey);
  if dd<>DD_OK then messageCentral('surface.setColorKey failed: '+longtoHexa(dd)+' '+DDerrorString(dd));
end;

procedure TDDsurface.restore;
begin
  if (surface.isLost=DDerr_surfaceLost) then surface._restore; 
end;

var
  RecGuid:array[0..5] of Tguid;
  guid0:array[0..5] of Pguid;
  nbGuid:integer;
  stDesc:string;


function callBack(guid:Pguid;desc,driver:lpstr;context:pointer;hm:Thandle):bool;stdCall;
  begin
    if guid<>nil then
      begin
        recGuid[nbGuid]:=guid^;
        guid0[nbguid]:=@recGuid[nbGuid];
      end
    else guid0[nbguid]:=nil;
    inc(nbguid);
    stDesc:=stDesc+desc+'|';
    callBack:=true;
  end;


procedure initDirectD0;
begin
  InitializeDDraw;
  nbguid:=0;
  stDesc:='';
  if not assigned(DirectDrawEnumerateEx) then exit;
  DirectDrawEnumerateEx(@callback,nil,7);
  delete(stDesc,length(stDesc),1);
end;


function createRectClipper(ddraw:IdirectDraw4; x1,y1,x2,y2:integer):IdirectDrawClipper;
type
  TRG=record
        rgnDataHeader:TrgnDataHeader;
        rr:Trect;
      end;
var
  rgn:TRG;
  dd:hresult;
  clipper:IdirectDrawClipper;
begin
  dd:=ddraw.createClipper(0,clipper,nil);
  if dd <> DD_OK then messageCentral('CreateClipper failed: '+longtoHexa(dd)+' '+DDerrorString(dd));

  with rgn,rgnDataHeader do
  begin
    dwSize:=sizeof(rgnDataHeader);
    itype:=rdh_rectangles;
    nCount:=1;
    nRgnSize:=sizeof(Trect);
    rcBound:=rect(0,0,0,0);
    rr:=rect(x1,y1,x2,y2);
  end;

  dd:=clipper.setClipList(@rgn,0);
  if dd <> DD_OK then messageCentral('Clipper.setClipList failed: '+longtoHexa(dd)+' '+DDerrorString(dd));

  createRectClipper:=clipper;
end;

{-----------------------------------------------------------
 TDDSCREEN
 -----------------------------------------------------------}

constructor TDDScreen.Create ( Width, Height, Depth: DWORD;Numguid:integer ) ;
var
  SurfaceDesc: TDDSURFACEDESC2;


  BackCaps: TDDSCAPS2 ;
  i: Integer ;
  DD:hresult;
  ddrawBid:IdirectDraw;
  PalEntry: Array [ 0..255 ] of TPaletteEntry ;

begin
  if (numGuid<0) or (numGuid>=nbGuid) then
    begin
      messageCentral('No secondary screen');
      exit;
    end;

  affdebug('TDDScreen.Create 1',0);

  dd := DirectDrawCreate ( guid0[numGuid], DDrawBid, nil ) ;
  if dd <> DD_OK then messageCentral('DirectDrawCreate failed: '+longtoHexa(dd)+' '+DDerrorString(dd));


  dd:=DDrawBid.queryInterface(IID_IDirectDraw4,DDraw);
  if dd <> DD_OK then messageCentral('QueryInterface failed: '+longtoHexa(dd)+' '+DDerrorString(dd));

  DDrawBid:=nil ;



  dd := Ddraw.SetCooperativeLevel ( Application.Handle,
      DDSCL_FULLSCREEN + DDSCL_ALLOWREBOOT + {DDSCL_NOWINDOWCHANGES +}
      DDSCL_EXCLUSIVE ) ;
  if dd <> DD_OK then messageCentral('SetCooperativeLevel failed: '+longtoHexa(dd)+' '+DDerrorString(dd));

  dd := Ddraw.SetDisplayMode ( Width, Height, Depth,0,0 ) ;
  if dd <> DD_OK then messageCentral('SetDisplayMode failed: '+longtoHexa(dd)+' '+DDerrorString(dd));


  fillchar(surfaceDesc,sizeof(surfaceDesc),0);
  with surfaceDesc do
  begin
    dwSize:= sizeof ( SurfaceDesc ) ;
    dwFlags:= DDSD_CAPS + DDSD_BACKBUFFERCOUNT ;
    dwBackBufferCount:= 1 ;
    ddsCaps.dwCaps:= DDSCAPS_PRIMARYSURFACE + DDSCAPS_FLIP + DDSCAPS_COMPLEX;
  end;

  Front:=TDDsurface.create(Ddraw, SurfaceDesc);

  BackCaps.dwCaps := DDSCAPS_BACKBUFFER ;
  Back:=TDDsurface.createAttached(Front.surface,BackCaps);

  for i:=0 to 255 do
  with PalEntry [i] do
  begin
    peRed :=0  ;
    peGreen :=i ;
    peBlue :=0 ;

    peFlags := 0 ;
  end ;
  dd:=Ddraw.CreatePalette ( DDPCAPS_8BIT+DDPCAPS_Allow256, @PalEntry[0], PaletteON, nil ) ;
  if dd<>DD_OK then messageCentral('ddraw.createPalette failed: '+longtoHexa(dd)+' '+DDerrorString(dd));

  dd:=Front.surface.SetPalette ( PaletteOn ) ;
  if dd<>DD_OK then messageCentral('surface.setPalette failed: '+longtoHexa(dd)+' '+DDerrorString(dd));

  dd:=PaletteON.setEntries(0,0,256,@PalEntry[0]);
  if dd<>DD_OK then messageCentral('palette.setEntries failed: '+longtoHexa(dd)+' '+DDerrorString(dd));

  clipper:=createRectClipper(ddraw,0,0,640,480);

  dd:=front.surface.setClipper(clipper);
  if dd<>DD_OK then messageCentral('surface.setClipper failed: '+longtoHexa(dd)+' '+DDerrorString(dd));

  dd:=back.surface.setClipper(clipper);
  if dd<>DD_OK then messageCentral('surface.setClipper failed: '+longtoHexa(dd)+' '+DDerrorString(dd));

    affdebug('TDDScreen.Create 2',0);
end ;

destructor TDDScreen.Destroy ;
begin
  if ddraw=nil then exit;

  clipper:=nil;
  {paletteON:=nil;}

  back.free;
  Front.free;

  Ddraw:=nil ;

  inherited Destroy ;
end ;


procedure TDDScreen.Flip(wait:boolean) ;
var
  v:longint;
  dd:hresult;
  b:longint;
  DDBLTFX:TDDBLTFX;
begin
  if ddraw=nil then exit;

  repeat until dd_ok=Front.surface.Flip ( nil, DDFLIP_WAIT *ord(wait)) ;
end ;

procedure TDDscreen.flipRect(rr:Trect);
var
  DDBLTFX:TDDBLTFX;
  dd:hresult;
begin
  fillchar(DDBLTFX,sizeof(DDBLTFX),0);
  DDBLTFX.dwSize:= sizeof ( DDBLTFX ) ;

  dd:=front.surface.blt(@rr,back.surface,@rr,0,@DDBLTFX);
end;

procedure TDDscreen.BltBackRect(surf:TDDsurface;rr:Trect);
var
  DDBLTFX:TDDBLTFX;
  dd:hresult;
begin
  fillchar(DDBLTFX,sizeof(DDBLTFX),0);
  DDBLTFX.dwSize:= sizeof ( DDBLTFX ) ;

  dd:=back.surface.blt(@rr,surf.surface,@rr,DDBLT_keySrc,@DDBLTFX);
end;


function TDDscreen.createSingleSurface(dx,dy:integer):TDDsurface;
var
  SurfaceDesc: TDDSURFACEDESC2;
begin
  if ddraw=nil then exit;

  fillchar(surfaceDesc,sizeof(surfaceDesc),0);
  with surfaceDesc do
  begin
    dwSize:= sizeof ( SurfaceDesc ) ;
    dwFlags:= DDSD_CAPS+DDSD_height+DDSD_width;
    ddsCaps.dwCaps:= DDSCAPS_offscreenPlain;
    dwWidth:=dx;
    dwHeight:=dy;
  end;

  createSingleSurface:=TDDsurface.create(Ddraw, SurfaceDesc);
end ;

procedure TDDscreen.BLT(surf:TDDsurface;x,y:integer);
var
  DDBLTFX:TDDBLTFX;

var
  rr1,rr2:Trect;
  dd:hresult;
begin
  if ddraw=nil then exit;
  { BLT se plante quand x et y sont simultanément égaux à zéro.
    Provisoirement, on interdit le blt sur le point (0,0)
    Il faut aussi que les deux rectangles aient les mêmes dimensions.
  }
  if (x<=-surf.width+1) or (y<=-surf.height+1) then exit;

  fillchar(DDBLTFX,sizeof(DDBLTFX),0);
  DDBLTFX.dwSize:= sizeof ( DDBLTFX ) ;
  if (x=0) and (y=0) and (back.width=surf.width) and (back.height=surf.height)  then
    begin
      dd:=back.surface.blt(nil,surf.surface,nil,
            DDBLT_keySrc,
            @DDBLTFX);
    end
  else
  if (x<=0) and (y<=0) then
    begin
      rr1:=rect(-x+1,-y+1,surf.width,surf.height);
      rr2:=rect(1,1,x+surf.width,y+surf.height);

      dd:=back.surface.blt(@rr2,surf.surface,@rr1,
            DDBLT_keySrc,
            @DDBLTFX);
    end
  else
    begin
      rr1:=rect(0,0,surf.width,surf.height);
      rr2:=rect(x,y,x+surf.width,y+surf.height);
      dd:=back.surface.blt(@rr2,surf.surface,@rr1,
            DDBLT_keySrc,
            @DDBLTFX);
    end;

  if dd <> DD_OK then
    messageCentral('surface.blt failed: '+
                    Istr(x)+' '+Istr(y)+' '+
                    Istr(x+surf.width)+' '+ Istr(y+surf.height) + ' '+
                    Istr(back.width)+' '+ Istr(back.height)+
                    longtoHexa(dd)+' '+DDerrorString(dd));
end;

function TDDscreen.getCaps:string;
var
  bb:array[1..1000] of byte;
  DDdriverCaps:TDDCaps absolute bb;
  DDHelCaps:TDDCaps;
  st:string;
  dd:hresult;
begin
  if ddraw=nil then exit;
  fillchar(DDdriverCaps,sizeof(DDdriverCaps),0);
  fillchar(DDHelCaps,sizeof(DDHelCaps),0);

  DDdriverCaps.dwSize:=sizeof(DDdriverCaps);
  DDHelCaps.dwSize:=sizeof(DDHelCaps);

  dd:=ddraw.getCaps(DDdriverCaps,DDhelCaps);

  with DDdriverCaps do st:=
    'hResult=    '     +longtoHexa(dd)+' '+DDerrorString(dd)+#13+#10+
    'DwCaps=     '     +longtoHexa(DwCaps)+#13+#10+
    'DwCaps2=    '     +longtoHexa(DwCaps2)+#13+#10+
    'DwCkeyCaps= '     +longtoHexa(DwCkeyCaps)+#13+#10+
    'DwFXCaps=   '     +longtoHexa(DwFXCaps)+#13+#10+
    'DwFXAlphaCaps=  ' +longtoHexa(DwFXAlphaCaps)+#13+#10+
    'DwPalCaps=  '     +longtoHexa(DwPalCaps)+#13+#10+
    'VidMemTotal=  '   +Istr(dwVidMemTotal)+#13+#10+
    'VidMemFree=  '    +Istr(dwVidMemFree)+#13+#10
    ;

  getCaps:=st;
end;

{-----------------------------------------------------------
 TDDNormalWindow
 -----------------------------------------------------------}


constructor TDDNormalWindow.Create(wnd:hwnd;ppal:PmaxLogPalette) ;
var
  SurfaceDesc: TDDSURFACEDESC2;
  BackCaps: TDDSCAPS ;
  i: Integer ;
  DD:hresult;
  ddrawBid:IdirectDraw;
  PalEntry: Array [ 0..255 ] of TPaletteEntry ;
  dc:hdc;

  rect:Trect;
  clp:IdirectDrawClipper;
begin

  wnd0:=wnd;
  dd := DirectDrawCreate ( guid0[0], DDrawBid, nil ) ;
  affdebug('NW DirectDrawCreate : '+longtoHexa(dd)+' '+DDerrorString(dd),0);

  dd:=DDrawBid.queryInterface(IID_IDirectDraw4,DDraw);
  affdebug('NW QueryInterface : '+longtoHexa(dd)+' '+DDerrorString(dd),0);

  DDrawBid:=nil;
  affdebug('TDDNormalWindow.Create 4',0) ;

  dd := Ddraw.SetCooperativeLevel ( 0, DDSCL_NORMAL );
  affdebug('NW SetCooperativeLevel : '+longtoHexa(dd)+' '+DDerrorString(dd),0);

  fillchar(surfaceDesc,sizeof(surfaceDesc),0);
  with SurfaceDesc do
  begin
    dwSize:= sizeof ( SurfaceDesc ) ;
    dwFlags:= DDSD_CAPS ;
    ddsCaps.dwCaps:= DDSCAPS_PRIMARYSURFACE ;
  end;

  affdebug('Avant TDDsurface.create',0);
  Front:=TDDsurface.create(Ddraw, SurfaceDesc);
  affdebug('Front.surface='+longtoHexa(integer(front.surface)),0) ;
  affdebug('TDDNormalWindow.Create 6',0) ;
  getClientRect(wnd,rect);


  Back:=createSingleSurface(rect.right,rect.bottom);
  affdebug('Back='+Istr(integer(back))+'  '+Istr(rect.right)+'  '+Istr(rect.bottom),0);
  dd:=ddraw.createClipper(0,clipper,nil);
  affdebug('NW CreateClipper : '+longtoHexa(dd)+' '+DDerrorString(dd),0);

  dd:=Clipper.setHwnd(0,wnd0);
  affdebug('NW Clipper.setHwnd : '+longtoHexa(dd)+' '+DDerrorString(dd),0);

  dd:=front.surface.setClipper(clipper);
  affdebug('surface.setClipper : '+longtoHexa(dd)+' '+DDerrorString(dd),0);


  with rect do clp:=createRectClipper(ddraw,left,top,right,bottom);

  dd:=back.surface.setClipper(clp);
  affdebug('surface.setClipper : '+longtoHexa(dd)+' '+DDerrorString(dd),0 );
  clp:=nil;
  affdebug('TDDNormalWindow.Create 9',0) ;

  fillchar(surfaceDesc,sizeof(surfaceDesc),0);
  surfaceDesc.dwSize:=sizeof(surfaceDesc);
  dd:=front.surface.getSurfaceDesc(surfaceDesc);
  affdebug('NW getSurfaceDesc :'+longtoHexa(dd)+' '+DDerrorString(dd),0 );

  if surfaceDesc.ddpfPixelFormat.dwFlags and DDPF_PaletteIndexed8 <>0 then
    begin
      affdebug('TDDNormalWindow.Create 10bis',0);
      dc:=getDC(0);
            affdebug('TDDNormalWindow.Create 10bis 1',0);
      getSystemPaletteEntries(dc,0,256,PalEntry);
            affdebug('TDDNormalWindow.Create 10bis 2',0);
      releaseDC(0,dc);
            affdebug('TDDNormalWindow.Create 10bis 3',0);


      if ppal<>nil then
        for i:=0 to 159 do
          palEntry[10+i]:=ppal^.palpalEntry[i];



      {fillchar(palEntry,sizeof(palEntry),0);}
      for i:=0 to 9 do
        with palEntry[i] do
        begin
          peflags:=pc_explicit;
          peRed:=i;
        end;

      for i:=10 to 245 do
        with palEntry[i] do
        begin
          peflags:=pc_noCollapse or pc_reserved;
        end;

      for i:=246 to 255 do
        with palEntry[i] do
        begin
          peflags:=pc_explicit;
          peRed:=i;
        end;



      dd:=Ddraw.CreatePalette ( DDPCAPS_8BIT, @PalEntry[0], PaletteON, nil ) ;
      affdebug('NW ddraw.createPalette : '+longtoHexa(dd)+' '+DDerrorString(dd)+'  '+Bstr(dd=DD_OK),0);

      affDebug('Front.surface.isLost= '+longtoHexa(Front.surface.isLost),0);


      dd:=Front.surface.SetPalette ( PaletteOn ) ;
      affdebug('NW surface.setPalette : '+longtoHexa(dd)+' '+DDerrorString(dd)+'  '+Bstr(dd=DD_OK),0);

      dd:=back.surface.SetPalette ( PaletteOn ) ;
      affdebug('NW surface.setPalette : '+longtoHexa(dd)+' '+DDerrorString(dd)+'  '+Bstr(dd=DD_OK),0);

    end;


  affdebug('TDDNormalWindow.Create 20',0) ;
  {Front.clear(0);}
end ;

destructor TDDNormalWindow.destroy;
begin
  inherited;
  affdebug('TDDNormalWindow.destroy',0);
end;

{
procedure TDDNormalWindow.updateClipper;
var
  dd:hresult;
begin
  dd:=Clipper.setHwnd(0,wnd0);
  if dd <> DD_OK then
    raise Exception.Create ( Format ('NW Clipper.setHwnd failed: %x', [ dd ] ) ) ;

  dd:=front.surface.setClipper(clipper);
  if dd<>DD_OK then raise Exception.Create (
        Format ( 'surface.setClipper failed: %x', [ dd ] ) ) ;
end;
}

procedure TDDNormalWindow.flip(wait:boolean);
var
  DDBLTFX:TDDBLTFX;
var
  rr1,rr2:Trect;
  dd:hresult;
  p:Tpoint;
  b,v:longint;
begin
  fillchar(DDBLTFX,sizeof(DDBLTFX),0);
  DDBLTFX.dwSize:= sizeof ( DDBLTFX ) ;

  if wait then ddraw.waitForVerticalBlank(DDwaitVB_blockBegin,0);

  {
  if wait then
  repeat
    v:=Ddraw.GetVerticalBlankStatus(@b);
  until b<>0;
  }
  rr1:=rect(0,0,back.width,back.height);
  p:=point(0,0);
  windows.clientToScreen(wnd0,p);
  rr2:=rect(p.x,p.y,p.x+back.width,p.y+back.height);
  dd:=front.surface.blt(@rr2,back.surface,@rr1,
            0,
            @DDBLTFX);
end;

procedure TDDNormalWindow.modifySize;
var
  rect:Trect;
  clp:IdirectDrawClipper;
  dd:integer;
begin
  getClientRect(wnd0,rect);

  back.free;
  Back:=createSingleSurface(rect.right,rect.bottom);

  with rect do clp:=createRectClipper(ddraw,left,top,right,bottom);

  dd:=back.surface.setClipper(clp);
  affdebug('surface.setClipper : '+longtoHexa(dd)+' '+DDerrorString(dd),0 );
  clp:=nil;

  dd:=back.surface.SetPalette ( PaletteOn ) ;

end;


initialization
initDirectD0;
affdebug('initialization initDirectD0',0);


end.
