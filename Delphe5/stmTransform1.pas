unit stmTransform1;

interface

uses classes, sysutils,
      util1, stmdef,stmObj, stmObv0, stmMvtX1, cuda1, stmPG, sysPal32, Direct3D9G,
      stmstmX0, Dprocess, stmVSBM1,
      stmvec1,ncdef2,
      debug0;


{ TVStransform effectue une transformation des pixels d'une surface  ( un VSbitmap)
    obSource est la source
    obvis est la destination

    si obsource vaut nil, la source est désignée par obvis
    si obvis vaut nil, la destination est la RenderSurface de l'écran de stimulation

  TVStransform se comporte comme n'importe quel stimulus mais:
      - c'est DoTransform qui agit sur l'affichage.
      - quand la destination est stimScreen (obvis=nil), Dotransform est appelé après l'affichage des autres stims
      - sinon, Dotransform est appelé pendant CalculMvt
      - setVisiFlags est modifié pour tenir compte du cas (obvis=nil) et de DispDisable

}

type
  TVStransform = class(TonOff)
                   tf: TransformClass;     // objet C++ associé
                   x1,y1,dx1,dy1:single;   // rectangle source en coordonnées réelles
                   x2,y2,dx2,dy2:single;   // rectangle dest en coordonnées réelles

                   mvtON:boolean;
                   RgbMask: integer;
                   obSource: TVSbitmap;  // bitmap source, obvis est la destination
                   DispDisable: boolean; // si la destination est un bm intermédiaire, inutile de l'afficher

                   dxSrc,dySrc:single;   // dim réelles de l'objet source
                   wSrc,hsrc:integer;    // dim en pixels de l'objet source

                   dxDest,dyDest:single; // dim réelles de l'objet dest
                   wDest,hDest:integer;  // dim en pixels de l'objet dest

                   xcSrc, ycSrc:single;  // position du centre en pixels dans le rectangle source
                   xcDest, ycDest:single;// position du centre en pixels dans le rectangle dest


                   TransformON: boolean;
                   ParamValue: array of array of double;
                   FsingleTransform: boolean;  // positionné par execute uniquement
                                               // remis à false immédiatement

                   StimScreenAsSource: boolean;

                   constructor create;override;
                   destructor destroy;override;
                   class function stmClassName: AnsiString;override;
                   procedure freeRef;override;
                   procedure processMessage(id:integer;source:typeUO;p:pointer);override;

                   procedure DoTransform;

                   procedure DoTransform1;virtual;  // vide
                   procedure InitSrcRect(xa,ya,dxa,dya:float);
                   procedure InitDestRect(xa,ya,dxa,dya:float);
                   // les descendants doivent implémenter Init et DoTransform1
                   procedure InitMvt;override;
                   procedure doneMvt;override;
                   procedure CalculeMvt;override;


                   function valid:boolean;override;

                   procedure setObvis(uo:typeUO);override;
                   procedure setSource(uo:typeUO);virtual;

                   procedure setVisiFlags(flag:boolean);override;
                   procedure initObvis;override;

                   procedure AddTraj1(num:Integer; vec: Tvector);
                   function AddTraj( st: AnsiString; vec: Tvector): integer;virtual;
                   procedure updateTraj(numcycle:integer);virtual; // transfert les vecteurs traj dans les params courants
                   procedure updateTraj1(numcycle:integer);        // appelle updateTraj
                   function MaxTrajParams:integer;virtual;

                   function execute:integer;
                   function UseRenderSurface: boolean;virtual;
                 end;

  TVSpolarToCart = class(TVStransform)

                   class function stmClassName: AnsiString;override;

                   procedure DoTransform1;override;
                   procedure Init(xa,ya,dxa,dya:float);

                 end;


  TVSwave = class(TVStransform)

                   x0,y0,Amp,f0,v0,tau:float;
                   x0I,y0I: integer;
                   yrefI:integer;
                   AmpI,v0I, tauI: float;
                   yref:float;
                   waveMode: integer;


                   constructor create;override;
                   destructor destroy;override;
                   class function stmClassName: AnsiString;override;

                   procedure setObvis(uo:typeUO);override;
                   procedure setSource(uo:typeUO);override;


                   procedure Init(xa,ya,dxa,dya, x01,y01,Amp1,f01,v01,tau1:float);
                   procedure DoTransform1;override;

                   procedure InitMvt;override;
                   procedure doneMvt;override;
                   function AddTraj(st:AnsiString;vec:Tvector): integer;override;
                 end;

  TVSsmooth = class(TVStransform)
                   Nlum, Nalpha:integer;

                   x0,y0,dmax1,dmax2:float;      // Centre et distance max de l'atténuation
                   x0I,y0I,dm1,dm2: integer;   // idem converties

                   LumRefI: array[1..3] of integer;

                   LumRef: float;

                   class function stmClassName: AnsiString;override;

                   procedure InitMvt;override;
                   procedure DoTransform1;override;

                   function MaxTrajParams: integer;override;
                   function AddTraj(st:AnsiString;vec:Tvector):integer;override;
                   procedure updateTraj(numCycle:integer);override;
                 end;

  TVSrings = class(TVStransform)

                   x0,y0,AmpBase,Amp,WaveLen,Phi,tau:float;

                   x0I,y0I: integer;

                   AmpBaseI, AmpI,WaveLenI, tauI: float;

                   waveMode: integer;


                   constructor create;override;
                   destructor destroy;override;
                   class function stmClassName: AnsiString;override;

                   procedure setSource(uo:typeUO);override;


                   procedure Init(x01,y01,Amp0,Amp1,waveLen1,Phi1,tau1:float);
                   procedure DoTransform1;override;

                   procedure InitMvt;override;
                   procedure doneMvt;override;
                   function AddTraj(st:AnsiString;vec:Tvector): integer;override;
                   function UseRenderSurface: boolean;override;
                 end;

  TtransformList=class(Tlist)
                    function UseRenderSurface:boolean;
                    procedure DoRenderSurfaceTransforms;
                    procedure RegisterRenderSurface;
                    procedure UnRegisterRenderSurface;
                 end;
var
  TransformList: Ttransformlist;   { Liste des objets du type TVStransform }


procedure proTVStransform_setSource(var puOb,pu:typeUO);pascal;
procedure proTVStransform_setStimScreenAsSource(var pu:typeUO);pascal;

procedure proTVStransform_setDestination(var puOb,pu:typeUO);pascal;
procedure proTVStransform_setDestination_1(var puOb:typeUO; DisableDisplay:boolean; var pu:typeUO);pascal;
procedure proTVStransform_AddTraj(st: AnsiString; var vec: Tvector;var pu:typeUO);pascal;
procedure proTVStransform_Execute(var pu:typeUO);pascal;

procedure proTVSpolarToCart_create(var pu:typeUO);pascal;
procedure proTVSpolarToCart_create_1(x1,y1,dx1,dy1:float;var pu:typeUO);pascal;


procedure proTVSwave_create(x01,y01,Amp1,f01,v01,tau1:float;var pu:typeUO);pascal;
procedure proTVSwave_create_1(x01,y01,Amp1,f01,v01,tau1,x1,y1,dx1,dy1:float;var pu:typeUO);pascal;

procedure proTVSwave_yref(w:float;var pu: typeUO);pascal;
function fonctionTVSwave_yref(var pu: typeUO):float;pascal;

procedure proTVSwave_WaveMode(w:integer;var pu: typeUO);pascal;
function fonctionTVSwave_WaveMode(var pu: typeUO):integer;pascal;

procedure proTVSsmooth_create(N1, N2:integer;var pu:typeUO);pascal;
procedure proTVSsmooth_setAttenuationParams(xA,yA,dA1,dA2,lum:float;var pu:typeUO);pascal;

procedure proTVSrings_create(x01,y01,Amp0,Amp1,waveLen1,Phi1,tau1:float;var pu:typeUO);pascal;


implementation


{ TVStransform }

constructor TVStransform.create;
begin
  inherited;
  TransformList.Add(self);
  //if assigned(DXscreen) then DXscreen.CheckRenderSurface;

  case sysPaletteNumber of
    1:  RgbMask := 4;
    2:  RgbMask := 2;
    3:  RgbMask := 1;
    4:  RgbMask := 6;
    5:  RgbMask := 5;
    6:  RgbMask := 3;
    else RgbMask := 7;
  end;

  dx1:= screenWidth;
  dy1:= screenHeight;
  dx2:= screenWidth;
  dy2:= screenHeight;

  TransformON:=true;
end;

destructor TVStransform.destroy;
begin
  TransformList.Remove(self);
  if assigned(DXscreen) then DXscreen.CheckRenderSurface;
  derefObjet(typeUO(obSource));
  inherited;
end;

procedure TVSTransform.freeRef;
begin
  inherited;
  derefObjet(typeUO(obSource));
end;



procedure TVStransform.DoTransform;
var
  objetON:boolean;

begin
  if not active or not TransformON then exit;
  with timeMan do objetON:=(timeS mod DureeC<DtOn) and (timeProcess<tend);

  if objetON then DoTransform1;

end;

procedure TVStransform.DoTransform1;
begin
end;

procedure TVStransform.InitMvt;
var
  res:integer;
  woffset1,hoffset1,width1, height1:integer;
  woffset2,hoffset2,width2, height2:integer;

  SrcResource, DestResource: pointer;
begin
  inherited;
  initObvis;

  updateTraj1(0);

  // Destination
  if obvis<>nil then
  begin
    wDest:=    TVSbitmap(obvis).Width;
    hDest:=    TVSbitmap(obvis).Height;
    dxDest:=   TVSbitmap(obvis).dxBM;
    dyDest:=   TVSbitmap(obvis).dyBM;

    woffset2:=  round(wDest/2+ (x2-dx2/2)* wDest/DxDest );
    hoffset2:=  round(hDest/2+ (y2-dy2/2)* hDest/DyDest );

    width2 :=   wdest; //degToPix(dx2);
    height2 :=  hdest; //degToPix(dy2);

    if woffset2<0 then woffset2:=0;
    if hoffset2<0 then hoffset2:=0;
    if woffset2 + width2>= wDest then width2:=  wDest- woffset2;
    if hoffset2 + height2>=hDest then height2:= hDest- hoffset2;
  end
  else
  begin
    wDest:=    SSWidth;
    hDest:=    SSHeight;
    dxDest:=   ScreenWidth;
    dyDest:=   ScreenHeight;

    woffset2:= degToX(x2-dx2/2);
    hoffset2:= degToY(y2+dy2/2);

    width2 :=   degToPix(dx2);
    height2 :=  degToPix(dy2);

    if woffset2<0 then woffset2:=0;
    if hoffset2<0 then hoffset2:=0;
    if woffset2 + width2>=SSWidth then width2:= SSwidth - woffset2;
    if hoffset2 + height2>=SSheight then height2:= SSheight - hoffset2;
  end;


  if obSource<>nil then
  begin
    wSrc:=    obSource.Width;
    hSrc:=    obSource.Height;
    dxSrc:=   obSource.dxBM;
    dySrc:=   obSource.dyBM;

    woffset1:=  round(wSrc/2+ (x1-dx1/2)* wSrc/DxSrc );
    hoffset1:=  round(hSrc/2+ (y1-dy1/2)* hSrc/DySrc );

    width1 :=   wsrc; //degToPix(dx1);
    height1 :=  hsrc; //degToPix(dy1);

    if woffset1<0 then woffset1:=0;
    if hoffset1<0 then hoffset1:=0;
    if woffset1 + width1>= wSrc then width1:=  wSrc- woffset1;
    if hoffset1 + height1>=hSrc then height1:= hSrc- hoffset1;

  end
  else
  //if StimScreenAsSource then  //
  begin
    wSrc:=    wDest;
    hSrc:=    hDest;
    dxSrc:=   dxDest;
    dySrc:=   dyDest;

    woffset1:= wOffset2;
    hoffset1:= hOffset2;

    width1 :=   width2;
    height1 :=  height2;
  end;





  xcSrc:= wSrc/2 -wOffset1;
  ycSrc:= hSrc/2 - hOffset1;
  xcDest:= wDest/2 -wOffset2;
  ycDest:= hDest/2 - hOffset2;

  DXscreen.CheckRenderSurface;

  if (obvis=nil)and UseRenderSurface then
  begin
    DXscreen.registerCuda;
    DestResource:= DXscreen.RenderResource;
  end
  else
  if obvis<>nil then
  begin
    TVSbitmap(obvis).registerCuda;
    DestResource:= TVSbitmap(obvis).BMCudaResource;
  end;

  if StimScreenAsSource and UseRenderSurface then
  begin
    DXscreen.registerCuda;
    SrcResource:= DXscreen.RenderResource;
  end
  else
  if (obsource<>nil) then
  begin
    obSource.registerCuda;
    SrcResource:= obSource.BMCudaResource;
  end
  else SrcResource:=nil;

  tf:= InitTransform(SrcResource, DestResource);
  cuda1.initSrcRect(tf,woffset1,hoffset1,width1,height1);
  cuda1.initDestRect(tf,woffset2,hoffset2,width2,height2);
  cuda1.initCenters(tf,xcSrc,ycSrc,xcDest,ycDest);
  mvtON:=true;

  cuda1.SetStream0(tf,cudaStream0);
end;


procedure TVStransform.doneMvt;
begin
  cuda1.SetStream0(tf,0);

  DoneTransform(tf);
  mvtON:=false;


//  if (obvis<>nil) then TVSbitmap(obvis).unregisterCuda else DXscreen.UnregisterCuda;
//  if (obSource<>nil) then obSource.unregisterCuda else DXscreen.UnregisterCuda;

end;


procedure TVStransform.CalculeMvt;
var
  tcycle, num:integer;
begin
  if (obvis=nil) or not initCudaLib1 then exit;

  tCycle:=timeS mod dureeC;
  num:= timeS div dureeC;
  UpdateTraj1(num);

  if (tcycle=0) and (num<CycleCount) then
  begin
    TVSbitmap(obvis).MapResource;
    if assigned(ObSource) then TVSbitmap(obSource).MapResource;

    DoTransform;

    TVSbitmap(obvis).UnMapResource;
    if assigned(ObSource) then TVSbitmap(obSource).UnMapResource;
  end;
end;


procedure TVStransform.InitSrcRect(xa, ya, dxa, dya: float);
begin
  x1:=xa;
  y1:=ya;
  dx1:=dxa;
  dy1:=dya;
end;

procedure TVStransform.InitDestRect(xa, ya, dxa, dya: float);
begin
  x2:=xa;
  y2:=ya;
  dx2:=dxa;
  dy2:=dya;
end;

class function TVStransform.stmClassName: AnsiString;
begin
  result:='VStransform';
end;

function TVStransform.valid: boolean;
begin
  result:=true;
end;

procedure TVStransform.AddTraj1(num:Integer; vec: Tvector);
var
  i:integer;
begin
  if vec.Icount<cycleCount then sortieErreur( 'T'+stmClassName+'.AddTraj : Not enough data in vector');

  setLength(paramValue[num],vec.Icount);
  for i:=0 to vec.Icount-1 do
    paramValue[num,i]:= vec[vec.Istart+i];
end;


function TVStransform.MaxTrajParams: integer;
begin
  result:=1;
end;

function TVStransform.AddTraj( st: AnsiString; vec: Tvector):integer;
begin
  if length(paramValue)=0 then setLength(paramValue,MaxTrajParams);
  st:=UpperCase(st);

  result:=-1;
  if st='TRANSFORMON' then result:=0;

  if result>=0 then AddTraj1(result,vec);
end;

procedure TVStransform.updateTraj(numcycle: integer);
begin
  if length(paramvalue)>0 then
  begin
    if length(paramvalue[0])>numCycle then TransformON := (paramValue[0,numCycle]<>0);
  end;
end;

procedure TVStransform.updateTraj1(numcycle: integer);
begin
  if not FsingleTransform then updateTraj(numcycle);
end;




procedure TVStransform.setObvis(uo: typeUO);
begin
  if uo is TVSbitmap then
  begin
    inherited;
    with TVSbitmap(uo) do initDestRect(0,0,dxBM,dyBM);
  end;
end;

procedure TVStransform.setSource(uo: typeUO);
begin
  if uo is TVSbitmap then
  begin
    derefObjet(typeUO(ObSource));
    obSource:=TVSbitmap(uo);
    refObjet(typeUO(obSource));
    with TVSbitmap(uo) do initSrcRect(0,0,dxBM,dyBM);
  end;
end;

procedure TVStransform.setVisiFlags(flag: boolean);
begin
  if (obvis<>nil) and initCudaLib1 and flag and not DispDisable
    then obvis.FlagOnScreen:=true;
end;

procedure TVStransform.initObvis;
begin
  if assigned(obvis) then obvis.prepareS;
  if assigned(obSource) then obSource.prepareS;
end;

procedure TVStransform.processMessage(id: integer; source: typeUO; p: pointer);
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        if (obSource=source) then
          begin
            obSource:=nil;
            derefObjet(source);
          end;
      end;
  end;
end;

function TVStransform.execute: integer;
begin
  FsingleTransform:=true;

  InitMvt;

  try
  TVSbitmap(obvis).MapResource;
  if assigned(ObSource) then TVSbitmap(obSource).MapResource;

  DoTransform1;

  TVSbitmap(obvis).UnMapResource;
  if assigned(ObSource) then TVSbitmap(obSource).UnMapResource;

  finally
  FsingleTransform:=false;
  DoneMvt;
  result:=0;  // code d'erreur ?
  end;
end;

function TVStransform.UseRenderSurface: boolean;
begin
  result:= (obvis=nil) or StimScreenAsSource;
end;


{TVSpolarToCart }

class function TVSpolarToCart.stmClassName: AnsiString;
begin
  result:='VSpolarToCart';
end;


procedure TVSpolarToCart.Init(xa, ya, dxa, dya: float);
begin
  initSrcRect(xa,ya,dxa,dya);
  initDestRect(xa,ya,dxa,dya);
end;

procedure TVSpolarToCart.DoTransform1;
var
  res:integer;
begin
  res:=TransformCartToPol1(tf,syspal.BKcolIndex);
end;



{ TVSwave }

constructor TVSwave.create;
begin
  inherited;
end;

destructor TVSwave.destroy;
begin
  inherited;
end;


class function TVSwave.stmClassName: AnsiString;
begin
  result:='VSwave';
end;

procedure TVSwave.doneMvt;
begin
  inherited;

end;

procedure TVSwave.setObvis(uo: typeUO);
begin
  inherited;
  //obsource:=TVSbitmap(obvis);
end;

procedure TVSwave.setSource(uo: typeUO);
begin
  inherited;
  //obvis:= obSource;
end;

procedure TVSwave.Init(xa,ya,dxa,dya, x01,y01,Amp1,f01,v01,tau1:float);
begin
  initSrcRect(xa,ya,dxa,dya);
  initDestRect(xa,ya,dxa,dya);

  x0:= x01;
  y0:= y01;
  Amp:= Amp1;
  f0:= f01;
  v0:= v01;

  if tau1>0 then tau:=tau1 else tau:=0;
end;


procedure TVSwave.DoTransform1;
var
  res:integer;
  a,b: single;
begin
  if waveMode=0
    then a:= 2*pi*f0/v0I
    else a:= 2*pi*f0/v0;
  b:= 2*pi*f0*timeS*Xframe;

  res:= WaveTransform1(tf,AmpI,a,b, tauI, x0I,y0I,yrefI,true, RgbMask,Wavemode=1);
  if res<>0 then WarningList.add('DoTransform1= '+Istr(res) );
  //statuslineTxt(Istr(timeS)+'   '+Estr(b,3));
end;

procedure TVSwave.InitMvt;
begin
  inherited;

  AmpI:= Amp/syspal.GammaGain;

  if yRef>=0
    then yrefI:= syspal.LumIndex(yref)
    else yrefI:= -syspal.LumIndex(yref);

  if obvis=nil then
  begin
    x0I:= degToX(x0);
    y0I:= degToY(y0);
  end
  else
  with TVSbitmap(obvis) do
  begin
    x0I:=   round(width/2+  self.x0*width/DxBM );
    y0I:=   round(height/2+ self.y0*height/DyBM );
  end;

  v0I:=   DegToPixR(v0);
  tauI:=   DegToPixR(tau);
end;

function TVSwave.AddTraj(st: AnsiString; vec: Tvector):integer;
begin
  result:= inherited AddTraj(st,vec);

end;



{ TVSsmooth }


procedure TVSsmooth.DoTransform1;
var
  i,n:integer;
begin
  x0I:= round(wsrc/Dxsrc*x0 ) +wsrc div 2;
  y0I:= -round(hsrc/Dysrc*y0) +hsrc div 2;
  dm1:= round(hsrc/Dysrc*dmax1);
  dm2:= round(hsrc/Dysrc*dmax2);


  n:= syspal.LumIndex(LumRef);
  for i:=1 to 3 do
    LumRefI[i]:=  ((RgbMask shr (i-1)) and 1 ) * n;

  SmoothSurface(tf, Nlum, Nalpha , x0I,y0I,dm1,dm2, @LumRefI);

end;

procedure TVSsmooth.InitMvt;
begin
  inherited;
  initDumRect(tf);

  x0I:= round(wsrc/Dxsrc*x0 ) +wsrc div 2;
  y0I:= -round(hsrc/Dysrc*y0) +hsrc div 2;
end;


class function TVSsmooth.stmClassName: AnsiString;
begin
  result:='VSsmooth';
end;


function TVSsmooth.MaxTrajParams: integer;
begin
  result:= inherited MaxTrajParams +5;
end;

function TVSsmooth.AddTraj(st: AnsiString; vec: Tvector): integer;
var
  base:integer;
begin
  st:=UpperCase(st);
  result:= inherited AddTraj(st,vec);

  if result<0 then
  begin
    base:= inherited MaxTrajParams;
    if st='X0' then result:= base +0
    else
    if st='Y0' then result:= base +1
    else
    if st='LUMREF' then result:= base +2
    else
    if st='DMAX1' then result:= base +3
    else
    if st='DMAX2' then result:= base +4;

    if result>=0 then AddTraj1(result,vec);
  end;

end;

procedure TVSsmooth.updateTraj(numCycle: integer);
var
  base:integer;
begin
  if length(paramvalue)>0 then
  begin
    inherited UpdateTraj(numCycle);
    base:= inherited MaxTrajParams;
    if length(paramvalue[base +0])>numCycle then x0:=paramValue[base +0,numCycle];
    if length(paramvalue[base +1])>numCycle then y0:=paramValue[base +1,numCycle];
    if length(paramvalue[base +2])>numCycle then LumRef:=paramValue[base +2,numCycle];
    if length(paramvalue[base +3])>numCycle then Dmax1:=paramValue[base +3,numCycle];
    if length(paramvalue[base +4])>numCycle then Dmax2:=paramValue[base +4,numCycle];
  end;
end;



{ TVSrings }

constructor TVSrings.create;
begin
  inherited;
end;

destructor TVSrings.destroy;
begin
  inherited;
end;

class function TVSrings.stmClassName: AnsiString;
begin
  result:= 'TVSrings';
end;

procedure TVSrings.doneMvt;
begin
  inherited;
end;

procedure TVSrings.DoTransform1;
var
  res:integer;
  a,b: single;
begin
  inherited;
  a:= 2*pi/WaveLenI;
  b:= Phi;

  res:= BuildRings1(tf,AmpBaseI, AmpI,a,b, tauI, x0I,y0I,RgbMask,Wavemode);
  if res<>0 then WarningList.add('DoTransform1= '+Istr(res) );
end;

procedure TVSrings.Init(x01,y01,Amp0,Amp1,waveLen1,Phi1,tau1:float);
begin
  x0:= x01;
  y0:= y01;
  AmpBase:= Amp0;
  Amp:= Amp1;
  WaveLen:= WaveLen1;
  Phi:=Phi1;

  if tau1>0 then tau:=tau1 else tau:=0;
end;

procedure TVSrings.InitMvt;
begin
  inherited;

  AmpBaseI:= AmpBase/syspal.GammaGain;
  AmpI:= Amp/syspal.GammaGain;

  if obvis=nil then
  begin
    x0I:= degToX(x0);
    y0I:= degToY(y0);
  end
  else
  with TVSbitmap(obvis) do
  begin
    x0I:=   round(width/2+  self.x0*width/DxBM );
    y0I:=   round(height/2+ self.y0*height/DyBM );
  end;

  WaveLenI:=   DegToPixR(WaveLen);
  tauI:=       DegToPixR(tau);
end;

procedure TVSrings.setSource(uo: typeUO);
begin
  // Rien
end;



function TVSrings.AddTraj(st: AnsiString; vec: Tvector): integer;
begin
  //TODO
end;


function TVSrings.UseRenderSurface: boolean;
begin
  result:= (obvis=nil);
end;

{ TtransformList }

procedure TtransformList.DoRenderSurfaceTransforms;
var
  i,res:integer;
begin
  if initCudaLib1 and UseRenderSurface and (DXscreen.renderResource<>nil) then
  begin
    res:=cuda1.MapResources(@DXscreen.renderResource,1);

    for i:=0 to count-1 do
      with TVStransform(items[i]) do
        if obvis=nil then DoTransform;

    res:=cuda1.UnMapResources(@DXscreen.renderResource,1);
  end;
end;



procedure TtransformList.RegisterRenderSurface;
var
  res:integer;
begin
  affdebug('RegisterRenderSurface',199);
  if initCudaLib1 then
  begin
    if UseRenderSurface then
    begin
      res:= cuda1.RegisterTransformSurface(Idirect3DTexture9(DXscreen.renderSurface), DXscreen.RenderResource);
      affdebug('RegisterTransformSurface '+Istr(res)+'  '+Istr(intG(DXscreen.renderSurface)),199);
    end;
  end;
end;

procedure TtransformList.UnRegisterRenderSurface;
var
  res:integer;
begin
  affdebug('UnRegisterRenderSurface',199);
  if initCudaLib1 then
  begin
    if UseRenderSurface then
    begin
      res:= cuda1.UnRegisterTransformSurface( DXscreen.RenderResource);
      affdebug('UnRegisterTransformSurface '+Istr(res)+'  '+Istr(intG(DXscreen.renderSurface)),199);
      DXscreen.RenderResource:=nil;
    end;
  end;
end;


function TtransformList.UseRenderSurface: boolean;
var
  i:integer;
begin
  result:=false;
  for i:=0 to count-1 do
  if TVStransform(items[i]).UseRenderSurface then
  begin
    result:=true;
    exit;
  end;

end;



{ Méthodes stm TVStransform}

procedure proTVStransform_setSource(var puOb,pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(puOb);
  TVStransform(pu).setSource(puOb);
end;

procedure proTVStransform_setStimScreenAsSource(var pu:typeUO);pascal;
begin
  verifierObjet(pu);
  TVStransform(pu).StimScreenAsSource:=true;
end;


procedure proTVStransform_setDestination(var puOb,pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(puOb);
  TVStransform(pu).setObvis(puOb);
end;

procedure proTVStransform_setDestination_1(var puOb:typeUO; DisableDisplay:boolean; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(puOb);
  TVStransform(pu).setObvis(puOb);
  TVStransform(pu).DispDisable:= DisableDisplay;
end;

procedure proTVStransform_AddTraj(st: AnsiString; var vec: Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierVecteur(vec);
  if TVStransform(pu).AddTraj(st,vec)<0
    then sortieErreur('T'+pu.stmClassName+'.AddTraj : Bad Parameter Name') ;
end;

procedure proTVStransform_Execute(var pu:typeUO);
var
  k:integer;
begin
  verifierObjet(pu);
  k:= TVStransform(pu).Execute;
  if k<>0
    then sortieErreur('T'+pu.stmClassName+'.Execute : error = '+Istr(k)) ;
end;

{ Métodes stm TVSpolarToCart }

procedure proTVSpolarToCart_create(var pu:typeUO);
begin
  createPgObject('',pu,TVSpolarToCart);
  TVSpolarToCart(pu).Init(0,0,ScreenWidth,screenHeight);
end;

procedure proTVSpolarToCart_create_1(x1,y1,dx1,dy1:float;var pu:typeUO);
begin
  createPgObject('',pu,TVSpolarToCart);
  TVSpolarToCart(pu).Init(x1,y1,dx1,dy1);
end;

{ Méthodes stm  TVSwave }

procedure proTVSwave_create(x01,y01,Amp1,f01,v01,tau1:float;var pu:typeUO);
begin
  createPgObject('',pu,TVSwave);
  TVSwave(pu).Init(0,0,ScreenWidth,screenHeight,x01,y01,Amp1,f01,v01,tau1);
end;

procedure proTVSwave_create_1(x01,y01,Amp1,f01,v01,tau1,x1,y1,dx1,dy1:float;var pu:typeUO);
begin
  createPgObject('',pu,TVSwave);
  TVSwave(pu).Init(x1,y1,dx1,dy1,x01,y01,Amp1,f01,v01,tau1);
end;

procedure proTVSwave_yref(w:float;var pu: typeUO);
begin
  verifierObjet(pu);
  TVSwave(pu).yref:=w;
end;

function fonctionTVSwave_yref(var pu: typeUO):float;
begin
  verifierObjet(pu);
  result:= TVSwave(pu).yref;
end;

procedure proTVSwave_WaveMode(w:integer;var pu: typeUO);
begin
  verifierObjet(pu);
  TVSwave(pu).WaveMode:=w;
end;

function fonctionTVSwave_WaveMode(var pu: typeUO):integer;
begin
  verifierObjet(pu);
  result:= TVSwave(pu).WaveMode;
end;

{Méthodes stm TVSsmooth }

procedure proTVSsmooth_create(N1,N2:integer;var pu:typeUO);
begin
  createPgObject('',pu,TVSsmooth);;
  TVSsmooth(pu).Nlum:=N1;
  TVSsmooth(pu).Nalpha:=N2;
end;

procedure proTVSsmooth_setAttenuationParams(xA,yA,dA1,dA2,lum:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSsmooth(pu) do
  begin
    x0:=xA;
    y0:=yA;
    dmax1:=dA1;
    dmax2:=dA2;
    LumRef:=lum;
  end;
end;


procedure proTVSrings_create(x01,y01,Amp0, Amp1,waveLen1,Phi1,tau1:float;var pu:typeUO);
begin
  createPgObject('',pu,TVSrings);
  TVSrings(pu).Init(x01,y01,Amp0,Amp1,WaveLen1,Phi1,tau1);

end;


initialization
TransformList:= Ttransformlist.create;

end.
