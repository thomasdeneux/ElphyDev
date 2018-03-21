unit Stmdef;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,messages,sysutils,classes,graphics,math,
     forms,controls,stdCtrls,extCtrls,buttons,comCtrls,Dialogs,


     util1,Gdos,Dgraphic,dtf0,
     DIBG,BMex1,

     varconf1,formRec0,

     {$IFDEF DX11}
     DXscr11,
     {$ELSE}
     DXtypes, Direct3D9G, D3DX9G, DXscr9,
     {$ENDIF}
     Dpalette,Dprocess,Ddosfich,
     debug0,

     Ncdef2;




type
  procedureOfObject=procedure of object;

  Trien=class
           procedure DuTout;
         end;
var
  rien:Trien;

type
  T16bytes=array[1..16] of byte;

  DriverString=string[30];

const
  StDatafile0= 'DataFile0';
  StMultigraph0='MultiGraph0';
  StRealArray0= 'RealArray0';
  StAcquis1='Acquis1';
  stPg0='PG0';
  stVisualStim='VisualStim';
  stMacroMan='InstMacro0';

  stAcqInfo0='Acquisition';
  stStimInfo0='Stimulator';
  stMstim='Mstimulator';

  DacDataFile:pointer=nil;
  DacMultiGraph:pointer=nil;
  DacRealArray:pointer=nil;
  DacAcquis1:pointer=nil;
  DacPg:pointer=nil;
  DacMacroMan:pointer=nil;

  DacAcqInfo:pointer=nil;
  DacStimInfo:pointer=nil;
  DacMstim:pointer=nil;


const
  stTmp='SM';

var
  formStm:Tform;
  panelSeq:Tpanel;
  panelNomDat:Tpanel;
  panelStatProcess:Tpanel;
  speedControlStm:TspeedButton;
  FormControlStm:Tform;

  updateVisualInspector:procedure of object;

  HKpaintPaint:procedure of object;
  HKpaintScreen:procedure of object;


  HKpaintSort:procedure of object;
  HKpaintSetZ:procedure of object;

  TotalDataInfo:smallInt;


  getDataFileName:function:AnsiString of object;

  nomTextePg:String[255]; {permet uniquement de récupérer les anciennes config }

var
  DXcontrol:TbitmapEx;

{$IFDEF DX11}
  DXscreen: TDXscreen11;
{$ELSE}
  DXscreen: TDXscreen9;

{$ENDIF}

  FlagSimulation:boolean;



const

  GfastMove:boolean=false;

  FmodeBuffer=true;
  {si vrai, les buffers d'acquisition ne sont pas libérés
   C'est toujours le cas actuellement
  }

  UserMinimalTimeInBuffer: double=0; { en secondes}  { En acquisition continue, impose une taille minimale du buffer principal }
var
  UserMaxMultiEvt: integer;

type
  TVSspot= record
             x,y,lum: single;    // lum n'est plus utilisé
           end;
 
var
  FtopSync:boolean;     {Utilisé par la simulation uniquement}
  VSsyncMode:integer;   { 0 pour RB line, 1 pour spots }

  VSsyncSpot:array[1..2] of TVSspot;
  VScontSpot:array[1..2] of TVSspot;

  VSspotSize: single;

  VSSyncInput:byte=0;         {Vtag1,Vtag2,v1,v2...}
  VSControlInput:byte=1;      {id. }

  VSnotrigger: boolean= false;       {Default=Digital trigger }


var
  stgenCfg:ShortString;
  stCfg:ShortString;

const
  lastCaption:String[50]='';

  stFichierRF:AnsiString='';



var
  StCfgHistory:AnsiString;
  StDatHistory:AnsiString;


const
  E_boxPg=401;


const
  wTop:smallInt=100;
  wLeft:smallInt=100;
  wWidth:smallInt=800;
  wHeight:smallInt=600;
  wState:byte=0;

  degradePal:byte=1;
  degradePal1:byte=2;

var
  controlFormRec:TformRec;
  InspFormRec:TformRec;

type
  typeDegre=record
              x,y,dx,dy,theta:single;
              Fuse, FControl: boolean;
              lum:single;
            end;
  Pdegre=^typeDegre;

  TRPoint=record
               x,y:float;
             end;
  PRpoint=^TRpoint;

  TRsegment=array[1..2] of TRpoint;

  typePoly5=array[1..5] of TPoint;    {la disposition est  3 - 4   }
                                      {                    |   |   }
                                      {                    2 - 1   }
  typePoly5R=array[1..5] of TRPoint;



const
  degNul:typeDegre=(x:0;y:0;dx:5;dy:1;theta:0;Fuse:false;Fcontrol:false;lum:100);

  stDXdriver:AnsiString='';  // pour DX9 , seul stDXdriver est important

  Tfreq:float=6665; {Période de rafraichissement à 150 Hz en microsecondes
                     pour 3D PRophet MX 64 PRO }
  SavedTfreq:float=0;

  ScreenHeight:float=30;
  ScreenWidth: float= 0;

  ScreenDistance:float=57;

  SSwidth:integer=1920;
  SSheight:integer=1080;
  SSrefreshRate:Dword=60;
  SSbitCount:integer=8;

  depth0:smallInt=8;

  Affstim:boolean=true;
  AffControl:boolean=false;

  AnimationON:boolean=false;

  extraTime:longint=0;
  FrameCount:longint=180;    { nb de trames pour une séquence
                               est calculé par TlisteStim.installe
                             }

  
  DegXmax:float=20;
  DegYmax:float=15;
  DDegMin:float=30/640;

  devColBK:integer=0;
  devColBK1:integer=0;

  VisualObjectIsMask:boolean=false;

const
  mouseDisplay:boolean=true;


// Ces variables permettent d'accéder à des éléments de la fiche principale mdac
var
  StatusLine:Tpanel;
  Pmouse:Tpanel;
  TimePanel:TPanel;
  CountPanel:Tpanel;
  SavePanel:Tpanel;
  PgButton: TbitBtn;





const

  FrecVideo:boolean=false;

  BMvideo:Tbitmap=nil;
  videoStGene:AnsiString='SM';
  cntVideo:integer=0;

  pg1Rgb:array[1..4] of integer=(0,0,0,0);

  {$IFDEF WIN64}
  FcudaVersion: integer =3;
  {$ELSE}
  FcudaVersion: integer =2;
  {$ENDIF}

  FdirectXversion: integer =2;

  //TexFormat = D3DFMT_A32B32G32R32F; //  avril 2016 : devient l'unique format des textures
  TexFormat = D3DFMT_A8R8G8B8;

  CudaStream0: pointer=nil;
const
  Msg_message=    wm_user+0;

  msg_endAcq1=    wm_user+2;
  msg_endAcq2=    wm_user+3;
  msg_shortcut=   wm_user+4;
  msg_DXdraw1=    wm_user+5;
  msg_DXdraw2=    wm_user+6;

  msg_XMouseDown= wm_user+7;
  msg_XmouseMove= wm_user+8;
  msg_XMouseUp=   wm_user+9;

  msg_command=    wm_user+10;

  msg_server=     wm_user+11;
  msg_NIboards=   wm_user+12;
  msg_KeyBoardAcq=wm_user+13;

  msg_ReloadFile= wm_user+14;
  msg_CloseLastDataBlock= wm_user+15;

  msg_NrnTextCommand= wm_user+20;

  msg_StopDebug = wm_user+21;
  msg_Procedure = wm_user+22;
  msg_Procedure1 = wm_user+23;

  msg_PosDialogs = wm_user+24;

type
  TvarPg1=class             {variables utilisées par pg1}
          canvasPg1:Tcanvas;

          cLeft,cTop,cWidth,cHeight:integer;

          win0:integer;      {cadre courant 0 à count-1}
          winEx:boolean;     {si vrai, on dessine dans le cadre ci-dessous
                              au lieu du cadre win0}
          x1winEx,y1winEx,x2winEx,y2winEx:integer;

          X1win0,Y1win0,X2win0,Y2win0:float; {le world utilisé}
          xg,yg:float;       {position écriture}

          logX0,LogY0:boolean;
          mode0:byte;
          taille0:byte;
          clip0:boolean;

          transparent:boolean;
          pen0,oldpenG:Tpen;
          brush0,oldBrushG:Tbrush;
          font0,oldFontG:Tfont;
          invertPenFont:boolean;

          Xtext,Ytext:integer;
          XtextStart:integer;
          FontText:Tfont;
          Htext,Ltext:integer;

          constructor create;
          destructor destroy;override;

          procedure SaveCanvas;
          procedure RestoreCanvas;
        end;



var
  specialDrag:pointer;

var
  AcquisitionON:boolean;

  LastVersion:integer;

const
  CalibFileName:AnsiString='Calib1.txt';
var
  ChmHelp:boolean;


  ElphyServerAdd:string[20];
  ElphyServerPort:integer;


  FlagNsServer:boolean;

  FlagActivate: boolean;

Const
  NsServerPort:integer = 50190;

type
  ToutputType=(TO_analog,TO_digiBit,TO_digi8,TO_digi16,TO_Neuron);


var
  MonoPaletteNumber:integer;  { Choisi par l'utilisateur }
  SysPaletteNumber:integer;   { Choisi par le système }


  StdColors:array[0..10] of integer;   { Couleurs standard pour afficher les spikes }
  DefBKcolor,DefScaleColor,DefPenColor:integer;

var
  AcqCybTime:double;
  AcqPCTime:longword;

  NSVflagGlb:array[1..128] of boolean;
  NSVtagFlagGlb:array[1..16] of boolean;
  SpkTableNumGlb:integer;
  LastAcqCommand:integer;

type
  TevtScaling = record
                  Dxu,x0u:double;
                  unitX:string[10];
                end;

  TspkWaveScaling=record
                    dxu,x0u:double;
                    unitX:string[10];
                    dyu,y0u:double;
                    unitY:string[10];
                    dxuSource:double;
                    unitXsource:string[10];
                    tpNum: typetypeG;
                  end;

var
  activatelist: array of TnotifyEvent;
  ExitingElphy:boolean;

  VisualStimOpen: boolean;

  Pg2SearchPath:AnsiString;
  Pg2CurrentPath:AnsiString; // reçoit le répertoire du fichier principal au moment de la compilation

var
  WarningList: TstringList;

procedure AddWarning(st:AnsiString; res:integer);

function Rpoint(x,y:float):TRpoint;

procedure DegRotation
          (x1,y1:single;var x2,y2:single;x0,y0:single;angle:single);
procedure DegRotationR
          (x1,y1:float;var x2,y2:float;x0,y0:float;angle:float);

procedure DegToPoly(const deg:typeDegre;var poly:typePoly5);
procedure DegToPolyAff(const deg:typeDegre;var poly:typePoly5);
procedure DegToPolyR(const deg:typeDegre;var PR:typePoly5R);
procedure DegToPolyRX(const deg:typeDegre;var PR:typePoly5R);
procedure GetPolyExtent(const poly:typePoly5;var xmin,ymin,xmax,ymax:integer);
procedure GetPolyExtentR(const poly:typePoly5R;var xmin,ymin,xmax,ymax:integer);

function Sconvx(x:float):integer;
function Sconvy(y:float):integer;
function Sinvconvx(x:longint):float;
function Sinvconvy(y:longint):float;


function calculTheta(x,y:single):single;
function calculArg(x,y:float):float;
procedure calculXY(x,y,x1,y1:single;theta:single;var xd,yd:single);



procedure UpDateAff;




procedure interPolyHline(const poly:Typepoly5;j0:integer;var i1,i2:integer);
procedure interPolyHlineR(const poly:Typepoly5R;j0:integer;var i1,i2:integer);

procedure interDegEllipse(const deg:typeDegre;j0:integer;var i1,i2:integer);

function TreeDepth(node:TtreeNode):integer;

procedure statusLineTxt(st:AnsiString);
procedure statusLineTxt1(st:AnsiString);

function GreenScaleColorTable: TRGBQuads;
{Crée la palette du stimulateur visuel:
  0: couleur transparente =0
  1 à 253: niveaux de vert
  254: BLEU pour tops Controle
  255: ROUGE pour tops synchro
}

function GreenColorTable: TRGBQuads;
{ Que du vert de 0 à 255
}

function MonoColorTable(MaxWhite: boolean): TRGBQuads;


procedure sendStmMessage(st:AnsiString);
function getStmMessage(i:integer):AnsiString;


function testUnic:boolean;


procedure AddFreeResourceProc(proc: Tprocedure);
procedure FreeMainResources;



function fonctionSystem:pointer;pascal;
function fonctionMultigraph0:pointer;pascal;
function fonctionDatafile0:pointer;pascal;
function fonctionRealArray0:pointer;pascal;
function fonctionAcquis1:pointer;pascal;

function XtoDeg(x:integer):float;
function YtoDeg(y:integer):float;
function DegToX(xdeg:float):integer;
function DegToY(ydeg:float):integer;

function DegToXR(xdeg:float):float;
function DegToYR(ydeg:float):float;

function PixToDeg(dx:integer):float;
function degToPix(dxDeg:float):integer;
function degToPixR(dxDeg:float):float;

function CmToPix(dxCm:float):integer;

function RPixToDeg(dx:float):float;

function XCtoDeg(xc:integer):float;
function YCtoDeg(yc:integer):float;
function DegToXC(xdeg:float):integer;
function DegToYC(ydeg:float):integer;

function PixCToDeg(dx:integer):float;
function degToPixC(dxDeg:float):integer;

procedure calculateScreenConst;
procedure CalculateControlConst;


var
  StmHintVisible: boolean;
procedure ShowStmHint(x,y:integer;st:AnsiString);
procedure HideStmHint;

function Xframe:float;

procedure installSSprinter(w,h:integer);
procedure resetSSprinter;

procedure proSendCommand(num:integer);pascal;
procedure proSendCommand_1(num:integer;delay:integer);pascal;


procedure CreateMainMask;
procedure FreeMainMask;

function getStdColor(n:integer):integer;

function FlagRTNeuron:boolean;


procedure DX9end;

procedure intersectionSegments(a,b,c,d:TRpoint;var m:TRpoint);
function longueurSegment(a,b:TRpoint):float;
function AngleSegment(a,b:TRpoint):float;


procedure alignVerticeOnSegment(var deg:typeDegre; num:smallInt;a,b:TRpoint);

procedure setPgButtonState;
procedure setPgButtonText(st:string);
procedure  LeaveStoppedState;
function TestDebugMode: boolean;



procedure AddToActivateList( f: TnotifyEvent);
function initDirectX9(msg:boolean): boolean;

procedure MatrixTranslation2D(var mat: TD3DMatrix; du,dv: single);

function CudaRgbMask(const Falpha: boolean=false):integer;

implementation

uses AcqBrd1,RTneuronBrd,stmPG;



function Rpoint(x,y:float):TRpoint;
begin
  result.x:=x;
  result.y:=y;
end;

{ DegToPoly construit un polynome directement utilisable pour l'affichage
  sur l'écran de stim à partir de deg

  La numérotation des sommets en coordonnées réelles est:

                         3 - 4
                         |   |
                         2 - 1
}
procedure DegToPoly(const deg:typeDegre;var poly:typePoly5);
  var
    i:Integer;
    dx2,dy2:single;
    PR:typePoly5R;

  begin
    with deg do
    begin
      dx2:=dx/2;
      dy2:=dy/2;

      DegRotationR
        (dx2,-dy2,PR[1].x,PR[1].y,0,0,theta);
      DegRotationR
        (-dx2,-dy2,PR[2].x,PR[2].y,0,0,theta);

      PR[3].x:=-PR[1].x;
      PR[3].y:=-PR[1].y;
      PR[4].x:=-PR[2].x;
      PR[4].y:=-PR[2].y;

      for i:=1 to 4 do
        begin
          poly[i].x:=DegToX(PR[i].x+x);
          poly[i].y:=DegToY(PR[i].y+y);
        end;

      Poly[5]:=Poly[1];
    end;
  end;

procedure DegToPolyAff(const deg:typeDegre;var poly:typePoly5);
  var
    i:Integer;
    dx2,dy2:single;
    PR:typePoly5R;

  begin
    with deg do
    begin
      dx2:=dx/2;
      dy2:=dy/2;

      DegRotationR
        (dx2,-dy2,PR[1].x,PR[1].y,0,0,theta);
      DegRotationR
        (-dx2,-dy2,PR[2].x,PR[2].y,0,0,theta);

      PR[3].x:=-PR[1].x;
      PR[3].y:=-PR[1].y;
      PR[4].x:=-PR[2].x;
      PR[4].y:=-PR[2].y;

      for i:=1 to 4 do
        begin
          poly[i].x:=DegToXC(PR[i].x+x);
          poly[i].y:=DegToYC(PR[i].y+y);
        end;

      Poly[5]:=Poly[1];
    end;
  end;


{ DegToPolyR ne fait aucune conversion
  Construit le polynome dans les unités de Deg
}
procedure DegToPolyR(const deg:typeDegre;var PR:typePoly5R);
  var
    i:Integer;
    dx2,dy2:float;

  begin
    with deg do
    begin
      dx2:=dx/2;
      dy2:=dy/2;

      DegRotationR
        (dx2,-dy2,PR[1].x,PR[1].y,0,0,theta);
      DegRotationR
        (-dx2,-dy2,PR[2].x,PR[2].y,0,0,theta);

      PR[3].x:=-PR[1].x;
      PR[3].y:=-PR[1].y;
      PR[4].x:=-PR[2].x;
      PR[4].y:=-PR[2].y;

      for i:=1 to 4 do
        begin
          PR[i].x:=PR[i].x+x;
          PR[i].y:=PR[i].y+y;
        end;

      PR[5]:=PR[1];
    end;
  end;

{ DegToPolyRX fait une conversion
  Construit le polynome dans les unités de Deg puis les convertit en pixels réels
}
procedure DegToPolyRX(const deg:typeDegre;var PR:typePoly5R);
var
  i:Integer;
begin
  DegToPolyR(deg,PR);
  for i:=1 to 4 do
  begin
    PR[i].x:=DegToXR(PR[i].x);
    PR[i].y:=DegToYR(PR[i].y);
  end;

  PR[5]:=PR[1];
end;


procedure intersectionSegments(a,b,c,d:TRpoint;var m:TRpoint);
  var
    k1,k2:double;
  begin
    if (a.y=b.y) and (c.y=d.y) then exit;

    if a.y=b.y then
      begin
        m.y:=a.y;
        k2:=(d.x-c.x)/(d.y-c.y);
        m.x:=c.x+k2*(m.y-c.y);
      end
    else
    if c.y=d.y then
      begin
        m.y:=c.y;
        k1:=(b.x-a.x)/(b.y-a.y);
        m.x:=a.x+k1*(m.y-a.y);
      end
    else
      begin
        k1:=(b.x-a.x)/(b.y-a.y);
        k2:=(d.x-c.x)/(d.y-c.y);
        if k1=k2 then exit;

        m.y:=(c.x-a.x+k1*a.y-k2*c.y)/(k1-k2);
        m.x:=a.x+k1*(m.y-a.y);
      end;
  end;

function longueurSegment(a,b:TRpoint):float;
  var
    d1,d2:float;
  begin
    d1:=a.x-b.x;
    d2:=a.y-b.y;
    longueurSegment:=sqrt(sqr(d1)+sqr(d2));
  end;

function AngleSegment(a,b:TRpoint):float;
  var
    x,y,theta:float;
  begin
    x:=b.x-a.x;
    y:=b.y-a.y;
    if abs(x)<1E-5 then theta:=pi/2
    else theta:=arctan(y/x);
    if x<0 then theta:=theta+pi;
    if theta>pi then theta:=theta-2*pi;
    Result:={-} theta*180/pi;
  end;



procedure alignVerticeOnSegment(var deg:typeDegre; num:smallInt;a,b:TRpoint);
  var
    s1,s2,s3,s4:smallInt;
    polyR:Typepoly5R;
    old:single;
  begin
    {deg.theta:=angleSegment(a,b)+90;}
    degToPolyR(deg,polyR);

    if num>1 then s1:=num-1 else s1:=4;
    s2:=num;
    if num<4 then s3:=num+1 else s3:=1;
    if num<4 then s4:=num+2 else s4:=2;

    intersectionSegments(polyR[s1],polyR[s2],a,b,polyR[s2]);
    intersectionSegments(polyR[s3],polyR[s4],a,b,polyR[s3]);

    deg.x:=(polyR[1].x+polyR[3].x)/2;
    deg.y:=(polyR[1].y+polyR[3].y)/2;

    deg.dx:=LongueurSegment(polyR[1],polyR[2]);
    deg.dy:=LongueurSegment(polyR[2],polyR[3]);
  end;



procedure GetPolyExtent(const poly:typePoly5;var xmin,ymin,xmax,ymax:integer);
var
  i:integer;
begin
  xmin:=poly[1].x;
  xmax:=xmin;
  ymin:=poly[1].y;
  ymax:=ymin;

  for i:=2 to 4 do
    with poly[i] do
    begin
      if x>xmax then xmax:=x;
      if x<xmin then xmin:=x;
      if y>ymax then ymax:=y;
      if y<ymin then ymin:=y;
    end;
end;

procedure GetPolyExtentR(const poly:typePoly5R;var xmin,ymin,xmax,ymax:integer);
var
  i:integer;
  xminR,yminR,xmaxR,ymaxR:float;
begin
  xminR:=poly[1].x;
  xmaxR:=xminR;
  yminR:=poly[1].y;
  ymaxR:=yminR;

  for i:=2 to 4 do
    with poly[i] do
    begin
      if x>xmaxR then xmaxR:=x;
      if x<xminR then xminR:=x;
      if y>ymaxR then ymaxR:=y;
      if y<yminR then yminR:=y;
    end;

  xmin:=floor(xminR);
  xmax:=floor(xmaxR);
  ymin:=floor(yminR);
  ymax:=floor(ymaxR);

end;


procedure DegRotationR
          (x1,y1:float;var x2,y2:float;x0,y0:float;angle:float);
  var
    sin0,cos0:float;
    dx,dy:float;
  begin
    dx:=x1-x0;
    dy:=y1-y0;
            {Le chgt de signe de l'angle des premières versions est supprimé }
    sin0:=sin(angle*Pi/180);
    cos0:=cos(angle*Pi/180);
    x2:=dx*cos0-dy*sin0+x0;
    y2:=dx*sin0+dy*cos0+y0;
  end;

procedure DegRotation
          (x1,y1:single;var x2,y2:single;x0,y0:single;angle:single);

  var
    sin0,cos0:single;
    dx,dy:single;
  begin
    dx:=x1-x0;
    dy:=y1-y0;
            {Le chgt de signe de l'angle des premières versions est supprimé }
    sin0:=sin(angle*Pi/180);
    cos0:=cos(angle*Pi/180);
    x2:=dx*cos0-dy*sin0+x0;
    y2:=dx*sin0+dy*cos0+y0;
  end;


{*********************** Fonctions de conversion ******************************}

var
  Kscreen:float;     { Degrés visuels par pixel }
  KscreenAff: float; { Degrés visuels par pixel controle }

procedure CalculateControlConst;
begin
  if assigned(DXcontrol) then KscreenAff:=ScreenHeight*180/ScreenDistance/pi/DXcontrol.height;
end;

function CmToDegreVisuel(x: float): float;
begin
  result:= x/ScreenDistance*180/pi;
end;

procedure calculateScreenConst;
begin
  if (SSheight=0) or (SSheight=0)  then
    begin
      SSheight:=480;
      SSwidth:=640;
    end;
  Kscreen:=ScreenHeight*180/ScreenDistance/pi/SSheight;  // deg visuels par pixel 

  CalculateControlConst;

  DegXmax:= CmToDegreVisuel(ScreenHeight* SSwidth/SSHeight );
  DegYmax:= CmToDegreVisuel(ScreenHeight);
  DDegMin:= CmToDegreVisuel(ScreenHeight/SSheight);

  ScreenWidth:=ScreenHeight*SSwidth/SSheight;
end;


{********************** Conversion Degrés visuels - pixels ********************}

function XtoDeg(x:integer):float;
begin
  result:=Kscreen*(x-SSwidth div 2);
end;

function YtoDeg(y:integer):float;
begin
  result:=-Kscreen*(y-SSheight div 2);
end;

function DegToX(xdeg:float):integer;
begin
  result:=roundL(SSwidth div 2+ xdeg/Kscreen);
end;

function DegToY(ydeg:float):integer;
begin
  result:=roundL(SSheight div 2 - ydeg/Kscreen);
end;

function DegToXR(xdeg:float):float;
begin
  result:=SSwidth div 2+ xdeg/Kscreen;
end;

function DegToYR(ydeg:float):float;
begin
  result:=SSheight div 2 - ydeg/Kscreen;
end;


function PixToDeg(dx:integer):float;
begin
  result:=Kscreen*dx;
end;

function RPixToDeg(dx:float):float;
begin
  result:=Kscreen*dx;
end;


function degToPix(dxDeg:float):integer;
begin
  result:=roundL(dxdeg/Kscreen);
end;

function degToPixR(dxDeg:float):float;
begin
  result:=dxdeg/Kscreen;
end;


// Conversion des cm en pixels
// Utilisé pour la position des spots
function CmToPix(dxCm:float):integer;
begin
  result:=roundL(dxCm/ScreenHeight * SSheight);
end;

(*
{********************** Conversion Degrés visuels - pixels controle ***********}

function XCtoDeg(xc:integer):float;
begin
  result:=Kscreen*(SinvConvX(xc)-SSwidth div 2);
end;

function YCtoDeg(yc:integer):float;
begin
  result:=-Kscreen*(SinvConvY(yc)-SSheight div 2);
end;

function DegToXC(xdeg:float):integer;
begin
  result:=SconvX(SSwidth div 2+ xdeg/Kscreen);
end;

function DegToYC(ydeg:float):integer;
begin
  result:=SconvY(SSheight div 2 - ydeg/Kscreen);
end;

function PixCToDeg(dx:integer):float;
begin
  result:=Kscreen*dx*SSwidth/DXcontrol.Width;
end;

function degToPixC(dxDeg:float):integer;
begin
  result:=SconvX(dxdeg/Kscreen);
end;
*)

{********************** Conversion Degrés visuels - pixels controle ***********}

function XCtoDeg(xc:integer):float;
begin
  result:=KscreenAff*(xc-DXcontrol.width div 2);
end;

function YCtoDeg(yc:integer):float;
begin
  result:=-KscreenAff*(yc-DXcontrol.height div 2);
end;

function DegToXC(xdeg:float):integer;
begin
  result:= roundL(DXcontrol.width div 2+ xdeg/KscreenAff);
end;

function DegToYC(ydeg:float):integer;
begin
  result:=roundL( DXcontrol.height div 2 - ydeg/KscreenAff);
end;

function PixCToDeg(dx:integer):float;
begin
  result:=KscreenAff*dx;
end;

function degToPixC(dxDeg:float):integer;
begin
  result:=roundL(dxdeg/KscreenAff);
end;

{********************** Installe conversion pour imprimante ********************}

var
  PPflag:boolean;
  PPheight,PPwidth:integer;

procedure installSSprinter(w,h:integer);
begin
  PPheight:=h;
  PPwidth:=w;

  PPflag:=true;
end;

procedure resetSSprinter;
begin
  PPflag:=false;
end;

{********************** Conversion Pixels - pixels controle ***********}

function Sconvx(x:float):integer;
begin
  if PPflag
    then result:= roundI(x*PPwidth/SSwidth)
    else result:=roundI(x*DXcontrol.width/SSwidth);
end;

function Sconvy(y:float):integer;
begin
  if PPflag
    then result:=roundI(y*PPheight/SSheight)
    else result:=roundI(y*DXcontrol.height/SSheight);
end;

function Sinvconvx(x:longint):float;
begin
  if PPflag
    then result:=1.0*x*SSwidth/PPwidth
    else result:=1.0*x*SSwidth/DXcontrol.width;
end;

function Sinvconvy(y:longint):float;
begin
  if PPflag
    then result:=1.0*y*SSheight/PPheight
    else result:=1.0*y*SSheight/DXcontrol.height;
end;



{*****************************************************************************}

{ calculTheta travaille en pixels controle
  Renvoie l'angle de la perpendiculaire au vecteur (X,Y) avec l'axe Ox
              est utilisée par FXctrl0
}

function calculTheta(x,y:single):single;
var
  theta:single;
begin
  if x=0 then
    begin
      if y>0 then calculTheta:=180
             else calculTheta:=0;
      exit;
    end;

  theta:=arctan(y/x)*180/pi;
  if x<0 then
    if y>0 then theta:=theta+180
           else theta:=theta-180;
  theta:=theta+90;
  if theta>180 then theta:=theta-360;
  calculTheta:=-theta;
end;

{ calculArg travaille en unités réelles
  Renvoie l'angle du vecteur (X,Y) avec l'axe des X
              est utilisée par stmMvtX1
}

function calculArg(x,y:float):float;
var
  theta:float;
begin
  if x=0 then
    begin
      if y>0 then result:=90
             else result:=-90;
      exit;
    end;

  theta:=arctan(y/x)*180/pi;
  if x<0 then
    if y>0 then theta:=theta+180
           else theta:=theta-180;
  if theta>180 then theta:=theta-360;
  result:=theta;
end;


{ calculXY travaille en degrés visuels
           est utilisée par FXctrl0
}
procedure calculXY(x,y,x1,y1:single;theta:single;var xd,yd:single);
  var
    t:float;
  begin
    {theta:=-theta;}
    if (theta=90) or (theta=-90) then
      begin
        xd:=x1;
        yd:=y;
        exit;
      end;

    t:=sin(theta*pi/180)/cos(theta*pi/180);
    xd:=(x+x1*sqr(t)+(y-y1)*t)/(1+sqr(t));
    yd:=y1+t*(xd-x1);
  end;


procedure UpDateAff;
var
  msg:Tmsg;
begin
  while peekMessage(msg,0,wm_paint,wm_paint,pm_remove) do
  begin
    translateMessage(msg);
    dispatchMessage(msg);
  end;
end;


{calcule les points d'intersection i1 et i2 entre un rectangle typePoly5 et
une droite horizontale d'ordonnée j0.
 travaille en pixels
 est utilisée par gratDX1
}
procedure interPolyHline(const poly:Typepoly5;j0:integer;var i1,i2:integer);
  var
    i,n:integer;
    x0:float;
    v:array[1..4] of integer;
  begin

    n:=0;
    for i:=1 to 4 do
      begin
        if poly[i].y<>poly[i+1].y then
          begin
            x0:=poly[i].x+longint(j0-poly[i].y)*(poly[i+1].x-poly[i].x)
                                  /(poly[i+1].y-poly[i].y) ;
            if (x0>=poly[i].x) and (x0<=poly[i+1].x) or
               (x0>=poly[i+1].x) and (x0<=poly[i].x) then
             begin
               inc(n);
               v[n]:=roundI(x0);
             end;
          end;

      end;
    i1:=v[1];
    i2:=i1;
    for i:=2 to n do
      begin
        if v[i]<i1 then i1:=v[i];
        if v[i]>i2 then i2:=v[i];
      end;
  end;


{ La même chose en réels. i1 est supérieur ou égal à la limite inf
                          i2 est inférieur ou égal à la limite sup }
procedure interPolyHlineR(const poly:Typepoly5R;j0:integer;var i1,i2:integer);
  var
    i,n:integer;
    x0:float;
    v:array[1..4] of float;
    x1,x2:float;
  begin

    n:=0;
    for i:=1 to 4 do
      begin
        if poly[i].y<>poly[i+1].y then
          begin
            x0:=poly[i].x+(j0-poly[i].y)*(poly[i+1].x-poly[i].x)
                                  /(poly[i+1].y-poly[i].y) ;
            if (x0>=poly[i].x) and (x0<=poly[i+1].x) or
               (x0>=poly[i+1].x) and (x0<=poly[i].x) then
             begin
               inc(n);
               v[n]:=x0;
             end;
          end;

      end;
    x1:=v[1];
    x2:=x1;
    for i:=2 to n do
      begin
        if v[i]<x1 then x1:=v[i];
        if v[i]>x2 then x2:=v[i];
      end;

    i1:=floor(x1);
    i2:=floor(x2);
  end;



{calcule les points d'intersection i1 et i2 entre une ellipse inscrite dans deg
et une droite horizontale d'ordonnée j0.
 Travaille en pixels
 DEG doit être fourni en UNITES PIXELS ou PIXELS CONTROLE.
 Utilisé par stmObv0, GratDX1
}

procedure interDegEllipse(const deg:typeDegre;j0:integer;var i1,i2:integer);
var
  a,b,sin0,cos0:float;
  a1,b1,c1:float;
  delta:float;
begin
  a:=deg.dx/2;
  b:=deg.dy/2;
  sin0:=sin(deg.theta*pi/180);
  cos0:=cos(deg.theta*pi/180);
  a1:=sqr(a*sin0)+sqr(b*cos0);
  b1:=sqr(a*cos0)+sqr(b*sin0);
  c1:=(sqr(a)-sqr(b))*sin0*cos0;

  delta:=sqr(c1*(j0-deg.y))-a1*(b1*sqr(j0-deg.y)-sqr(a*b));
  if delta<0 then
    begin
      i1:=0;
      i2:=-1;
      exit;
    end;

  i1:=roundL( deg.x+ (-c1*(j0-deg.y)-sqrt(delta))/a1);
  i2:=roundL( deg.x+(-c1*(j0-deg.y)+sqrt(delta))/a1);
end;


procedure Trien.DuTout;
begin
end;

{TvarPg1}

constructor TvarPg1.create;
begin
  pen0:=Tpen.create;
  brush0:=Tbrush.create;
  font0:=Tfont.create;

  fontText:=Tfont.create;
  fontText.name:='Courier New';
  fontText.size:=8;
  Xtext:=0;
  Ytext:=0;

  Ltext:=7;
  Htext:=14;

  clip0:=true;
end;

destructor TvarPg1.destroy;
begin
  pen0.free;
  brush0.free;
  font0.free;

  fontText.free;
end;

procedure TvarPg1.SaveCanvas;
begin
  if assigned(CanvasPg1) then
  begin
    oldPenG:=canvasPg1.pen;
    canvasPg1.pen:=pen0;

    oldBrushG:=canvasPg1.brush;
    canvasPg1.brush:=brush0;

    oldFontG:=canvasPg1.font;
    canvasPg1.font:=font0;

    invertPenFont:=true;
  end;
end;


procedure TvarPg1.RestoreCanvas;
begin
  if assigned(CanvasPg1) and InvertPenFont then
  begin
    canvasPg1.pen:= OldPenG;
    canvasPg1.brush:=OldBrushG;
    canvasPg1.font:=oldFontG;

    invertPenFont:=false;
  end;
end;


function TreeDepth(node:TtreeNode):integer;
begin
  result:=0;
  if node=nil then exit;

  inc(result);
  while node.parent<>nil do
  begin
    inc(result);
    node:=node.parent;
  end;
end;

procedure statusLineTxt(st:AnsiString);
begin
  statusLine.Alignment:=taCenter;
  statusLine.caption:=st;
  statusLine.update;
end;

procedure statusLineTxt1(st:AnsiString);
begin
  statusLine.Alignment:=taLeftJustify;
  statusLine.caption:=st;
  statusLine.update;
  
end;


function GreenScaleColorTable: TRGBQuads;
var
  i: Integer;
begin
  with Result[0] do    {0 est la couleur transparente}
  begin
    rgbRed := 0;
    rgbGreen := 0;
    rgbBlue := 0;
    rgbReserved := 0;
  end;

  for i:=1 to 255 do   {1 contient la couleur 0,.... 255 contient 254}
    with Result[i] do
    begin
      rgbRed := 0;
      rgbGreen :=i-1;
      rgbBlue := 0;
      rgbReserved := 0;
    end;

  with Result[255] do    {couleur des tops synchro}
  begin
    rgbRed := 255;
    rgbGreen := 0;
    rgbBlue := 0;
    rgbReserved := 0;
  end;

  with Result[254] do    {couleur des tops Contrôle}
  begin
    rgbRed := 0;
    rgbGreen := 0;
    rgbBlue := 255;
    rgbReserved := 0;
  end;

end;

function GreenColorTable: TRGBQuads;
var
  i: Integer;
begin
  for i:=0 to 255 do   
    with Result[i] do
    begin
      rgbRed := 0;
      rgbGreen :=i;
      rgbBlue := 0;
      rgbReserved := 0;
    end;
end;


function MonoColorTable(MaxWhite: boolean): TRGBQuads;
var
  i: Integer;
  Vred,Vgreen,Vblue:boolean;
  n:integer;
begin
  n:=sysPaletteNumber;
  if n=0 then n:=2;          { palette verte par défaut }

  Vred:=(n in [1,4,5,7]);
  Vgreen:=(n in [2,4,6,7]);
  Vblue:=(n in [3,5,6,7]);

  with Result[0] do    {0 est la couleur transparente}
  begin
    rgbRed := 0;
    rgbGreen := 0;
    rgbBlue := 0;
    rgbReserved := 0;
  end;

  for i:=1 to 255 do   {1 contient la couleur 0,.... 255 contient 254}
    with Result[i] do
    begin
      rgbRed := (i-1)*ord(Vred);
      rgbGreen :=(i-1)*ord(VGreen);
      rgbBlue := (i-1)*ord(VBlue);
      rgbReserved := 0;
    end;

  if n=2 then
  begin
    with Result[255] do    {couleur des tops synchro}
    begin
      rgbRed := 255;
      rgbGreen := 0;
      rgbBlue := 0;
      rgbReserved := 0;
    end;

    with Result[254] do    {couleur des tops Contrôle}
    begin
      rgbRed := 0;
      rgbGreen := 0;
      rgbBlue := 255;
      rgbReserved := 0;
    end;
  end;

  if MaxWhite then
  begin
    with Result[255] do    {couleur des tops synchro}
    begin
      rgbRed := 0;
      rgbGreen := 255;
      rgbBlue := 0;
      rgbReserved := 0;
    end;

    with Result[254] do    {couleur des tops Contrôle}
    begin
      rgbRed := 0;
      rgbGreen := 255;
      rgbBlue := 0;
      rgbReserved := 0;
    end;
  end;

end;



{*********************** Gestion des messages STM ****************************}
type
  TStringFifo=class
              private
                strings:array[0..19] of AnsiString;
                FifoIn:integer;
              public
                function Put(st:AnsiString):integer;
                function get(i:integer):AnsiString;
              end;

var
  StringMsgs:TStringFifo;


function TstringFifo.Put(st:AnsiString):integer;
begin
  strings[FifoIn mod 20]:=st;
  result:=FifoIn;
  inc(FifoIn);
end;

function TstringFifo.get(i:integer):AnsiString;
begin
  result:=strings[i mod 20];
end;

procedure sendStmMessage(st:AnsiString);
begin
  postMessage(formStm.handle,msg_message,stringMsgs.Put(st),0);
end;

function getStmMessage(i:integer):AnsiString;
begin
  result:=stringMsgs.get(i);
end;



function testUnic:boolean;
var
  f:Text;
  st,stf:AnsiString;

const
  Ftest:boolean=false;
  Floaded:boolean=false;
begin
  if not Floaded then
  begin
    Floaded:=true;

    try
    stf:=AppDir + 'unic-key.txt';
    Ftest:=FileExists(stf);
    if Ftest then
    begin
      assign(f, AppDir + 'unic-key.txt');
      reset(f);
      readln(f,st);
      close(f);
      Ftest:= (st='55611289450321256548413287895202');
    end;
    except
    end;

  end;
  
  result:=Ftest;
end;


function fonctionSystem:pointer;
const
  sys:pointer=nil;
begin
  result:=@sys;
end;

function fonctionMultigraph0:pointer;
begin
  result:=@DacMultigraph;
end;

function fonctionDatafile0:pointer;
begin
  result:=@DacDatafile;
end;

function fonctionRealArray0:pointer;
begin
  result:=@DacRealArray;
end;

function fonctionAcquis1:pointer;
begin
  result:=@DacAcquis1;
end;


var
  HintW:ThintWindow;

procedure ShowStmHint(x,y:integer;st:AnsiString);
var
  rr:Trect;
  h:integer;
begin
  if not assigned(hintW)
    then hintW:=ThintWindow.create(formStm);



  rr:=hintW.CalcHintRect(400,st,nil);
  h:=rr.Bottom-rr.top;
  rr:=rect(rr.Left+x,rr.Top+y-h,rr.Right+x,rr.Bottom+y-h);
  if rr.top<0 then
  begin
    rr.Bottom:=rr.Bottom-rr.top+10;
    rr.Top:=10;
  end;

  if rr.right>screen.DeskTopWidth then
  begin
    rr.left := rr.left-(rr.right-screen.DeskTopWidth)-10;
    rr.right:=screen.DeskTopWidth-10;
  end;

  hintW.activateHint(rr,st);
  stmHintVisible:=true;
end;

procedure HideStmHint;
begin
  if assigned(HintW)
    then hintW.releaseHandle;
  stmHintVisible:=false;
end;

function Xframe:float;
begin
  result:=Tfreq/1E6;
end;

procedure proSendCommand(num:integer);
begin
  postMessage(formStm.handle,msg_command,num,0);
end;

procedure proSendCommand_1(num:integer;delay:integer);
begin
  postMessage(formStm.handle,msg_command,num,delay);
end;


var
  FreeResourceList: Tlist;

procedure AddFreeResourceProc(proc: Tprocedure);
begin
  if not assigned(FreeResourceList) then FreeResourceList:= Tlist.create;

  FreeResourceList.Add(@proc);
end;

procedure FreeMainResources;
var
  i:integer;
begin
  if assigned(FreeResourceList) then
  with FreeResourceList do
  for i:=0 to count-1 do Tprocedure(items[i]);
end;

procedure CreateMainMask;
begin
end;

procedure FreeMainMask;
begin
end;


function getStdColor(n:integer):integer;
begin
  if (n>=1) and (n<=10)
    then result:=StdColors[n]
    else result:=StdColors[0];
end;

function FlagRTNeuron:boolean;
begin
  {$IFDEF WIN64}
  result:=false;
  {$ELSE}
  result:=(board is TRTNIinterface);
  {$ENDIF}
end;

procedure DX9end;
begin
  setPrecisionMode(pmExtended);
end;

Const
  PgButtonText:string='PG';

procedure PaintPgButton(bkCol,FontCol:integer) ;
var
  w:double;
  xx:integer;
begin
  with PgButton.Glyph,Canvas do
  begin
    width:=PgButton.Width-5;
    height:=PgButton.Height-5;

    pen.Color:= BKcol;               // BackGround
    pen.Style:=psSolid;
    brush.Color:=BKcol;
    brush.Style:=bsSolid;
    fillrect(rect(0,0,width,height));

    pixels[0,height-1]:=clYellow;    // transparent color

    font.Color:= FontCol;            // text
    font.Name:='Times New Roman';
    font.style:=[fsBold];
    font.Size:=9;

    xx:= (width-textExtent(PgButtonText).cx) div 2;
    textOut(xx,0,PgButtonText);
  end;
  PgButton.Update;
end;


procedure setPgButtonState;
begin
  if FstoppedState then PaintPgButton(clRed,clBlack)
  else
  if Fdebugmode then PaintPgButton(clLime,clBlack)
  else PaintPgButton(clYellow,clBlack);
end;

procedure setPgButtonText(st:string);
begin
  PgButtonText:=st;
  setPgButtonState;
end;

procedure  LeaveStoppedState;
begin
  StepMode:=0;
  if FstoppedState then
  begin
    finExe:=true;
    TPG2(DacPg).finExeUpg2:=true;
    FlagStopDebug:=true;
  end;
end;

function TestDebugMode: boolean;
begin
  result:= FstoppedState;
  if FstoppedState then
    if MessageDlg(' Exit Debug Mode ?',mtConfirmation, [mbYes,mbNo],0)=mrYes
      then LeaveStoppedState;
end;


procedure AddToActivateList( f: TnotifyEvent);
begin
  setLength(ActivateList,length(ActivateList)+1);
  ActivateList[high(ActivateList)]:=f;
end;

function initDirectX9(msg:boolean): boolean;
begin
  result:= initDirect3D9lib and initD3DX9lib;
  //result:=true;
  if msg and not result then
      messageCentral('Unable to install DX9 '+crlf+
                   'Try to update DirectX on Microsoft site'
                  );
end;


procedure MatrixTranslation2D(var mat: TD3DMatrix; du,dv: single);
begin
  fillchar(mat,sizeof(mat),0);
  mat._11:=1;
  mat._22:=1;
  mat._33:=1;
  mat._44:=1;

  mat._31 := du;
  mat._32 := dv;
end;

function CudaRgbMask(const Falpha: boolean=false):integer;
begin
  case sysPaletteNumber of
    1:  Result := 4;
    2:  Result := 2;
    3:  Result := 1;
    4:  Result := 6;
    5:  Result := 5;
    6:  Result := 3;
    else Result := 7;
  end;
  if Falpha then result:=result+8;
end;

procedure AddWarning(st:AnsiString; res:integer);
begin
{$IFDEF DEBUG}
  //if res<>0 then
    warningList.Add(st +'=' +Istr(res));
{$ENDIF}
end;


Initialization
AffDebug('Initialization stmDef',0);

rien:=Trien.create;


updateVisualInspector:=rien.duTout;

HKpaintPaint:=rien.duTout;
HKpaintScreen:=rien.duTout;

HKpaintSort:=rien.duTout;
HKpaintSetZ:=rien.duTout;

pg1rgb[1]:=rgb(255,0,0);
pg1rgb[2]:=rgb(0,255,0);
pg1rgb[3]:=rgb(0,0,255);
pg1rgb[4]:=rgb(255,255,0);



StringMsgs:=TstringFifo.create;

stdColors[0]    := rgb(255,255,255);
stdColors[1]    := rgb(255,0,0);
stdColors[2]    := rgb(0,255,0);
stdColors[3]    := rgb(255,0,255);
stdColors[4]    := rgb(255,255,0);
stdColors[5]    := rgb(0,255,255);
stdColors[6]    := rgb(128,0,0);
stdColors[7]    := rgb(0,128,0);
stdColors[8]    := rgb(128,0,128);
stdColors[9]    := rgb(128,128,128);
stdColors[10]   := rgb(0,0,255);

DefBKcolor:=clWhite;
DefScaleColor:=clBlack;
DefPenColor:=clBlack;

fillchar(NSVflagGlb,sizeof(NSVflagGlb),1);
fillchar(NSVtagFlagGlb,sizeof(NSVtagFlagGlb),1);

with VSsyncSpot[1] do
begin
  x:=1  ;
  y:=1 ;
end;

with VSsyncSpot[2] do
begin
  x:= 1 ;
  y:= 1 +1.27;
end;

with VScontSpot[1] do
begin
  x:= 1 +1.27 ;
  y:= 1;
end;


with VScontSpot[2] do
begin
  x:= 1 +1.27 ;
  y:= 1 +1.27;
end;

VSspotSize:=1;

WarningList:= TstringList.Create;

finalization


resetTmpFiles(stTmp);

StringMsgs.free;

end.
