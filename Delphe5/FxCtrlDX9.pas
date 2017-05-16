unit FXctrlDX9;

interface

uses
  Windows,  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus, MMsystem,
  printers,clipBrd,

  DIBG,
  DXtypes, Direct3D9G, D3DX9G, DXscr9,

  editcont,
  util1,debug0,DdosFich,Dgraphic,
  stmdef,stmObj,dacInsp1,

  stmObv0,
  defForm,
  stmPg,NcDef2,stmError,
  syspal32,

  Dprocess,stmstmX0,KBlist0,
  clock0,

  VisuSys1,actifStm,stmMark0,
  wacq1,
  acqDef2,acqInf2,stimInf2,
  AcqBuf1,listG,acqBrd1,
  FdefDac2,

  ElphyFormat,ElphyFile,stmdf0,
  Daffac1,multg1,
  descElphy1,
  repFile1,DrawFile1,
  myAvi0,BMex1,

  stmvec1,stmMat1,stmMList,
  ippdefs17,ipps17,
  ippMat1,stmMatU1,

  EvtAcq1,
  MesureRefreshTime,
  NIbrd1,
  stmBMcorrection1,
  viewListG2,
  CreateAVI1,
  objfile1,

  stmDetector1,
  stmTexFile,
  memoForm;


{ Vtag1 recoit les tops Synchro = Entrée TAG correspond à RED       ===> bit0
  Vtag2 recoit les tops contrôle = Entrée START correspond à BLUE   ===> bit1

  C'est le premier top Contrôle qui démarre l'acquisition. Il faut en général connecter l'entrée contrôle
à l'entrée trigger de la carte.
  Générer des tops synchro n'est pas indispensable sinon pour l'analyse.
}

type
  TeventProg=(mlDown,mlUp,mrDown,mrUp);


{ TstmTrack mémorise les tracks, c'est à dire les points marquant les spikes sur
l'écran de contrôle, sous deux formes différentes:
  surf est une surface de même taille que DXcontrol et est projetée en mode transparent
sur DXcontrol.
  pointList contient la liste des points (x,y + couleur) et permet le réaffichage
quand la surface est perdue.
}

const
  trackPosMax=64;

type
  TFXcontrol=class;

  TstmPoint= record
               xi,yi:single;
               col:integer;
             end;
  PstmPoint=^TstmPoint;

  TstmTrack= class
               fx:TFXcontrol;
               voie:integer;              { voie logique de 0 à nbvoie-1 }
               PointList:TlistG;

               First:boolean;
               Fup,Fdw:boolean;
               seuilP:integer;
               TrackRising:boolean;

               Dsz:integer;
               DevcolorT:integer;

               constructor create;
               destructor destroy;override;

               procedure calculeTrackPos(const deg:typeDegre;tp:Integer;var xi,yi:single);
               procedure displayPoint(xi,yi:single;col:integer);
               procedure add(const deg:typeDegre);
               procedure clear;

               procedure DisplayPoints;
               procedure traiter(trame,x:integer);

               procedure Init(FX1:TFXcontrol;Num:integer);
             end;

  TSavedAcqParams=record
                    continu:boolean;
                    Qnbav:integer;
                    Qnbpt:integer;
                    Qnbvoie:integer;

                    DureePreTrigU:float;
                    DureeSeqU:float;
                    PeriodeCont:float;

                    ModeSynchro:TmodeSync;
                    voieSynchro:smallint;

                    Fdisplay:boolean;
                    Fimmediate:boolean;
                    Fcycled:boolean;
                    Fhold:boolean;

                    FFdat:boolean;
                    FValidation:boolean;

                    QvoieAcq:array[1..16] of byte;
                    jru1,jru2:array[1..16] of smallint;
                    yru1,yru2:array[1..16] of single;
                    ChannelType:array[1..16] of TinputType;    {0 .. 1}
                    EvtHysteresis:array[1..16] of single;
                    FRising:array[1..16] of boolean;
                    EvtThreshold:array[1..16] of single;
                    Qgain:array[1..16] of byte;   { gain pour chaque voie}

                  end;

   TVSspotRect= record
                 rect1: TD3Drect;
                 devcol: integer;
               end;


  TFXcontrol = class(TForm)
    PanelTop: TPanel;
    PanelBottom: TPanel;
    PanelRight: TPanel;
    PanelMouse: TPanel;
    PanelStatusX: TPanel;
    BBextra: TBitBtn;
    Binfo: TButton;
    Bdestroy: TButton;
    TreeView1: TTreeView;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    MainMenu1: TMainMenu;
    Palette1: TMenuItem;
    Stimulation1: TMenuItem;
    Animateobjects1: TMenuItem;
    Replay1: TMenuItem;
    Redraw1: TMenuItem;
    Options1: TMenuItem;
    Activestimuli1: TMenuItem;
    Acquisition1: TMenuItem;
    Screen1: TMenuItem;
    Clear1: TMenuItem;
    Displayall1: TMenuItem;
    Control1: TMenuItem;
    Clear2: TMenuItem;
    Displayall2: TMenuItem;
    Showtracks1: TMenuItem;
    cleartracks1: TMenuItem;
    SpeedControl: TSpeedButton;
    SpeedStim: TSpeedButton;
    Panel1: TPanel;
    Bfront: TBitBtn;
    Bback: TBitBtn;
    Objects1: TMenuItem;
    New1: TMenuItem;
    visualobject1: TMenuItem;
    stimulus1: TMenuItem;
    System1: TMenuItem;
    SpeedTrack1: TSpeedButton;
    SpeedRF1: TSpeedButton;
    SpeedAC: TSpeedButton;
    PanelSeqStim: TPanel;
    Btest: TButton;
    SpeedTrack2: TSpeedButton;
    Showtracks21: TMenuItem;
    Cleartracks21: TMenuItem;
    PanelError: TPanel;
    Open1: TMenuItem;
    Parameters1: TMenuItem;
    Append1: TMenuItem;
    SaveasBMP1: TMenuItem;
    SaveasBMP2: TMenuItem;
    Debug1: TMenuItem;
    Displaysync1: TMenuItem;
    Bstop: TBitBtn;
    CreateAVI1: TMenuItem;
    PanelControl: TPanel;
    PaintBox0: TPaintBox;
    Test1: TMenuItem;
    Copytoclipboard1: TMenuItem;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Bcadrer: TBitBtn;
    scrollbarH: TscrollbarV;
    scrollbarV: TscrollbarV;
    PanelX: TPanel;
    LG0: TLabel;
    SBG0: TscrollbarV;
    BautoG0: TBitBtn;
    ools1: TMenuItem;
    BitmapCorrection1: TMenuItem;
    ShowErrorList1: TMenuItem;
    VSparameters: TMenuItem;
    ShutDown1: TMenuItem;
    asBMP1: TMenuItem;
    asJPEG1: TMenuItem;
    asPNG1: TMenuItem;
    CreateTextureFile1: TMenuItem;
    ShowWarnings1: TMenuItem;
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure BBextraClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Palette1Click(Sender: TObject);
    procedure Animateobjects1Click(Sender: TObject);
    procedure visualobject1Click(Sender: TObject);
    procedure stimulus1Click(Sender: TObject);
    procedure BdestroyClick(Sender: TObject);
    procedure SpeedStimClick(Sender: TObject);
    procedure SpeedControlClick(Sender: TObject);
    procedure System1Click(Sender: TObject);
    procedure Activestimuli1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure Displayall1Click(Sender: TObject);
    procedure Clear2Click(Sender: TObject);
    procedure Displayall2Click(Sender: TObject);
    procedure SpeedTrack1Click(Sender: TObject);
    procedure SpeedRF1Click(Sender: TObject);
    procedure SpeedACClick(Sender: TObject);
    procedure BfrontClick(Sender: TObject);
    procedure BbackClick(Sender: TObject);
    procedure UpdateRightPanel(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Showtracks1Click(Sender: TObject);
    procedure cleartracks1Click(Sender: TObject);
    procedure Showtracks21Click(Sender: TObject);
    procedure Cleartracks21Click(Sender: TObject);
    procedure SpeedTrack2Click(Sender: TObject);
    procedure Acquisition1Click(Sender: TObject);
    procedure Replay1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Parameters1Click(Sender: TObject);
    procedure Append1Click(Sender: TObject);
    procedure Redraw1Click(Sender: TObject);
    procedure SaveImageClick(Sender: TObject);
    procedure Displaysync1Click(Sender: TObject);
    procedure DXDraw1Initializing(Sender: TObject);
    procedure BstopClick(Sender: TObject);
    procedure CreateAVI1Click(Sender: TObject);
    procedure PaintBox0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox0MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox0MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox0Paint(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SaveasBMP2Click(Sender: TObject);
    procedure Copytoclipboard1Click(Sender: TObject);
    procedure SBG0ScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure BautoG0Click(Sender: TObject);
    procedure BcadrerClick(Sender: TObject);
    procedure scrollbarHScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure scrollbarVScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure BitmapCorrection1Click(Sender: TObject);
    procedure ShowErrorList1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ShutDown1Click(Sender: TObject);
    procedure CreateTextureFile1Click(Sender: TObject);
    procedure ShowWarnings1Click(Sender: TObject);
  private
    { Private declarations }

    BMfen:TbitmapEx;

    TheLine:Trect;
    Fline:boolean;

    Fupdate:boolean;
    ob:typeUO;
    st0:AnsiString;

    InForm:Tgenform;  {modèle de fiche incluse}
    topExtra,height0,width0:integer;




    FtracksON:array[1..2] of boolean;


    DernierTraite:integer;

    maxSamples:integer;       { nb d'échantillons de la séquence d'acquisition}
    periodeG:float;           { Période d'échantillonnage en secondes.  Par voie 260309
                                Utilisée par traiterData }
    AcqIndex:integer;         { reçoit getSampleIndex à chaque cycle }

    lastTimer2:float;

    FlipOK:boolean;
    cntFlip:integer;

    FtopControle:boolean;


    facq:TElphyFile;
    FlagAcq:boolean;

    nbseqStim:integer;

    Fsim:boolean;
    Fopen,Fappend,FopenPg:boolean;



    DevColBlue, DevColGreen, DevColRed, DevColBlack, DevColWhite: integer;

    savedAcq:TSavedAcqParams;

    Fdigi:boolean;
    nbvoieAcq1,nbpt0,nbvEv:integer;

    QKSU:array of word;
    FdownSampling:boolean;

    voieCont,bitCont,voieSync,BitSync:integer;

    Gdisp,xDisp,yDisp:float;
    FlagUpdateG0:boolean;

    VSsyncRect:array[1..2] of TVSspotRect;
    VScontRect:array[1..2] of TVSspotRect;
    syncRectOrder: boolean;
    ContRectOrder: boolean;

    RectBEXE:Trect;


    procedure changeSelection(p:pointer);
    procedure updatePosition;
    procedure updateSize;
    procedure updateTheta;

    function UoSelectedOnControl:typeUO;
    procedure DXDraw1MouseDown1(Sender: TObject; Button: TMouseButton;
                                Shift: TShiftState; X, Y: Integer);
    procedure DXDraw1MouseUp1(Sender: TObject; Button: TMouseButton;
                              Shift: TShiftState; X, Y: Integer);

    procedure drawLine;
    procedure setLine(x1,y1,x2,y2:float);

    procedure MessageDX1(var message:Tmessage);message msg_DXdraw1;
    procedure MessageDX2(var message:Tmessage);message msg_DXdraw2;
    function CalculateSize(var NewWidth, NewHeight: Integer): boolean;

    procedure setTracksON(n:integer;b:boolean);
    function getTracksON(n:integer):boolean;

    procedure traiterDataSingle;
    procedure traiterDataMulti;
    procedure traiterData;

    procedure traiterDataRedraw;

    procedure traiterEvt(i,v:integer);
    procedure saveEvt(Imax:integer);

    procedure ActivateDX(sender:Tobject);
    procedure DeActivateDX(sender:Tobject);

    procedure Controltimes;
    function redrawLoop:integer;

    procedure SaveAcqParams;
    procedure RestoreAcqParams;

    procedure CompEnter(Sender: TObject);


    procedure resizeBM;
    procedure DrawBM;

    procedure setSyncCont;
    procedure setG0ctrl;
    function DxGdisp:float;
    function DyGdisp:float;
    procedure UpdateControls;

    function getErrorData(n:integer):AnsiString;
  public
    stmTrack:array[1..2] of TstmTrack;

    { Public declarations }
    rotateUO:Tresizable; {pointe sur l'objet affiché couramment
                          sélectionné }
    x00,y00:single;      {première position objet}
    x0,y0:single;        {ancienne position objet}
    oldXs,oldYs:integer; {ancienne position souris}
    ThetaLocked:boolean;

    finImmediate:boolean;  {positionné si l'utilisateur appuie sur F12 }
    StopStim:boolean;      {positionné si l'utilisateur appuie sur "S" (stop) }

    Xmouse,Ymouse:smallInt;
    ShiftKeyON,CtrlKeyON,AltKeyON:boolean;
    FacqInterface:boolean;
    FwinMode: boolean;
    FalwaysActivate:boolean;


    Tbase:float; {Période par voie en ms}
    FdisplayData:boolean;

    errorList:Tlist;

    TrackChannel:array[1..2] of integer;
    TrackSeuilP:array[1..2] of float;
    TrackMode:array[1..2] of byte;


    TrackPoint:array[1..2] of smallInt;

    TrackColor:array[1..2] of Integer;
    DotSize:array[1..2] of smallInt;
    TrackShift:array[1..2] of smallInt;

    TrackDelay:float;

    trackObvis:Tresizable;
    EventProg:array[TeventProg] of Tpg2Event;

    RepFirst,RepLast:integer;
    RepFileName:AnsiString;
    DrawFirst,DrawLast:integer;
    DrawClear,DrawFast:boolean;

    onStartAnimate1: Tpg2Event;
    onStartAnimate2: Tpg2Event;

    FSaveObjects:boolean;
    FStopOnClick:boolean;



    TestSampleInt:double;
    TestAcqDuration:double;
    stfAvi: Ansistring;

    qualityJPEG: integer;
    RedFactor:integer;
    SkipFactor: integer;

    stfTex: Ansistring;
    
    SyncDebugMode: boolean;
    SyncDebugModeA: boolean;

    MaskBar: Tbar;
    Detector:Tlist; // of Tdetector;

    property TracksON[n:integer]:boolean read getTracksON write setTracksON;

    procedure updateList;
    procedure changeObvis;

    procedure PaintTopSync(w:boolean);
    procedure PaintTopControl(w:boolean);
    procedure SetSpotParams;

    procedure PaintControl;
    procedure PaintControlSurface1;
    procedure PaintControlSurface;


    procedure paintScreen;
    procedure paintScreenNoWait;
    procedure updateStimScreen;
    procedure paintScreenSurface;

    procedure updateInform;

    procedure paintPage;
    procedure DisplayData;

    procedure VerifyFakeVectors;
    procedure stimulerSeq1(AcqAuto,saveAuto,Fredraw,FinitBoard:boolean; Const delayMS:integer=0);
    procedure StimulerSeq(FinitBoard:boolean; const delayMS:integer=0; const f:Tobjectfile=nil);
    procedure TestStopStim(var flagFinExe: boolean);

    procedure BuildAvi(Ftex:boolean);

    function getDotProd(i0,j0:integer;Smask:Tmatrix):single;
    Procedure ReducStim(Smask:Tmatrix;Xpos,Ypos:Tvector;Nx,Ny:integer;Mlist:TmatList);
    procedure ReducStim2(x1,y1,x2,y2: integer; Mlist:TmatList; LumValues:boolean; Const stTex: AnsiString='');

    procedure MesureRefreshTime1;

    procedure InitAcqParams;
    procedure startAcq(SaveAuto,FinitBoard:boolean);
    procedure startRedraw;
    procedure EndRedraw;
    procedure EndAcq(wholeData:boolean);
    procedure AbortAcq;
    procedure FinalizeEvt;

    procedure affNumSeq(num:integer);
    function selectedObject:typeUO;

    procedure opendata(Fappend:boolean);
    procedure openPgdata;
    procedure savedata(wholeData:boolean);
    procedure closedata;
    function appendDF:boolean;

    procedure DisableStims;
    procedure replay;
    procedure redraw;

    procedure openDataFile;
    procedure SetSyncLine(Fsync,Fcontrol:boolean);
    procedure clearScreen;
    procedure setDevColors;

    procedure InitialiseDXscreen;
    procedure invalidate;override;

  end;

var
  VfakeData:array of Tvector;

implementation

uses mdac,stmVS0,acqStmPrm, cuda1, stmTransform1;


{$IFNDEF FPC} {$R *.DFM} {$ENDIF}



var
  trackPos:array[0..trackPosMax-1] of typeDegre;



constructor TstmTrack.create;
begin
  pointList:=TlistG.create(sizeof(TstmPoint));
  DevcolorT:=clWhite;
  Dsz:=1;
end;

destructor TstmTrack.destroy;
begin
  pointList.free;
end;

procedure TstmTrack.init(fx1:TFXcontrol;num:integer);
begin
  fx:=fx1;
  with fx do
  begin
    DevcolorT:=DXcontrol.DevColor(Trackcolor[num]);
    Dsz:=DotSize[num] div 2;
    if Dsz<=0 then Dsz:=1;
    First:=true;

    voie:=TrackChannel[num]-1;
    with acqInf do
    begin
      if (voie>=0) and (voie< Qnbvoie) then
      begin
        seuilP:=roundL( (TrackSeuilP[num]-Y0u(voie+1))/Dyu(voie+1) );
        TrackRising:=(TrackMode[num]=0);
      end
      else seuilP:=100000;
    end;
  end;

end;

procedure TstmTrack.displayPoint(xi,yi:single;col:integer);
var
  x,y:integer;
begin
  TRY
    x:=degToXC(xi);
    y:=degToYC(yi);

    DXcontrol.fillRect(rect(x-Dsz,y-Dsz,x+Dsz,y+Dsz),col);
  Except

  end;
end;

procedure TstmTrack.DisplayPoints;
var
  i:integer;
  x,y:integer;
begin
  for i:=0 to pointList.count-1 do
    with PstmPoint(pointList[i])^ do
    begin
      x:=degToXC(xi);
      y:=degToYC(yi);
      DXcontrol.fillRect(rect(x-Dsz,y-Dsz,x+Dsz,y+Dsz),col);
    end;
end;

procedure TstmTrack.calculeTrackPos(const deg:typeDegre;tp:Integer;var xi,yi:single);

var
  poly:typePoly5R;
begin
  degToPolyR(Deg,poly);

  case tP of
    1..4:
       begin
         xi:=poly[tp].x;
         yi:=poly[tp].y;
       end;
    5..8:
       begin
         xi:=(poly[tp-4].x+poly[tp-3].x) / 2;
         yi:=(poly[tp-4].y+poly[tp-3].y) / 2;
       end;
    9: begin
         xi:=(poly[1].x+poly[3].x) / 2;
         yi:=(poly[1].y+poly[3].y) / 2;
       end;
  end;
end;

procedure TstmTrack.add(const deg:typeDegre);
var
  i:integer;
  pt:TstmPoint;
  x,y,ts:single;
begin
  for i:=1 to 2 do
    if fx.trackPoint[i]>0 then
      begin
        calculeTrackPos(deg,fx.trackPoint[i],x,y);

        with pt do
        begin
          ts:=PixCtoDeg(fx.TrackShift[i]);
          xi:=x+ts*cos(deg.theta*pi/180);
          yi:=y+ts*sin(deg.theta*pi/180);

          col:=devColorT;
        end;

        pointList.add(@pt);

        with pt do DisplayPoint(xi,yi,col);
      end;
end;

procedure TstmTrack.clear;
begin
  pointList.clear;
end;

procedure TstmTrack.traiter(trame,x:integer);
begin
  if First then
    begin
      Fup:=(x>=seuilP);
      First:=false;
      exit;
    end;

  if TrackRising then
  begin
    if not Fup then
      begin
        if x>=seuilP then
          begin
            Fup:=true;
            add(trackPos[trame mod trackPosMax]);
            affdebug('traiter Fup ' +Istr(trame)+'  '+Istr(x),10);
          end
        else Fup:=false;
      end
    else Fup:=(x>=seuilP);
  end
  else
  begin
    if Fup then
      begin
        if x<=seuilP then
          begin
            Fup:=false;
            add(trackPos[trame mod trackPosMax]);
          end
        else Fup:=true;
      end
    else Fup:=(x>=seuilP);
  end;
end;


{******************************* TFXcontrol9 **********************************}

procedure TFXcontrol.resizeBM;
var
  pwidth,pheight:integer;
begin
  pwidth:=round(paintbox0.width*Gdisp);
  pheight:=round(paintbox0.height*Gdisp);

  if (BMfen.width<>pwidth) or (BMfen.height<>pheight) then
  begin
    BMfen.width:=pwidth;
    BMfen.height:=pheight;
    calculateControlConst;
  end;
end;


function TFXcontrol.DxGdisp:float;
begin
  result:=round(xdisp-(Gdisp-1)*paintbox0.width/2);
end;

function TFXcontrol.DyGdisp:float;
begin
  result:=round(ydisp-(Gdisp-1)*paintbox0.height/2);
end;


procedure TFXcontrol.DrawBM;
begin
  paintbox0.canvas.draw(round(DxGdisp),round(DyGdisp),BMfen);
end;

procedure TFXcontrol.invalidate;
var
  rr:Trect;
begin
  updateControls;

  if not assigned(panelControl) then exit;

  invalidateRect(panelControl.handle,nil,false);
end;


function TFXcontrol.CalculateSize(var NewWidth, NewHeight: Integer): boolean;
var
  h,l,capSize:integer;
  oldH, oldW: integer;
begin
  capSize:=height-clientHeight;
  H:=NewHeight-PanelTop.height-PanelBottom.height-capSize;
  L:=NewWidth-PanelRight.width;

  if L>SSwidth*h div SSheight
    then NewWidth:=SSwidth*H div SSheight+panelRight.width
    else NewHeight:=SSheight*L div SSwidth +PanelTop.height+PanelBottom.height+capSize;

  result:=(NewWidth<>Width) or (NewHeight<>height);
end;

procedure TFXcontrol.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin

  calculateSize(newWidth,NewHeight);

  resize:=true;
end;

procedure TFXcontrol.UpdateList;
var
  i:integer;
  p0:TtreeNode;
  ob1:typeUO;

begin
  Fupdate:=true;
  HKpaint.Fmodified:=false;

  with treeView1 do
  begin
    items.clear;
    items.BeginUpDate;
    for i:=0 to HKpaint.count-1 do
      begin
        ob1:=TypeUO(HKpaint.items[i]);

        if not (ob1.Fchild or ob1.notPublished)
           then ob1.addToTree(treeView1,nil);
      end;
    items.EndUpDate;

    p0:=nil;
    for i:=0 to items.count-1 do
      if (ob=items[i].data) and (ob<>nil) then p0:=items[i];

    if (p0=nil) and (items.count>0) and (items[0].data<>nil) then p0:=items[0];
  end;


  if p0<>Nil then
    begin
      p0.selected:=true;
      ob:=p0.data;
      st0:=p0.text;
    end
  else
    begin
      ob:=nil;
      st0:='';
    end;



  changeObvis;

  Fupdate:=false;
end;


procedure TFXcontrol.changeObvis;
var
  i:integer;
  newF:boolean;
begin

  edit1.text:=st0;

  if ob=nil then exit;

  {if assigned(inform) then updateAllVar(inform);}

  ob.installDialog(inForm,newF);

  if newF then
    begin
      with inform do
      for i:=0 to componentCount-1 do
        if components[i] is Tcontrol then
        with Tcontrol(components[i]) do
        if (parent=inform) then
        begin
          parent:=panelRight;
          top:=top+25;
        end;
      bbExtra.top:=topExtra+inform.clientHeight;
      Binfo.top:=topExtra+inform.clientHeight;
      Bdestroy.top:=topExtra+inform.clientHeight;

      treeView1.bringtofront;
      updateAllCtrl(inform);
    end;

  ob.completeDialog(inform);

  Bdestroy.enabled:= (ob<>nil) and
                      not ob.Fsystem and
                      not ob.Fchild and
                      (ob.Fstatus<>UO_PG);
end;

procedure TFXcontrol.BBextraClick(Sender: TObject);
begin
  if assigned(ob) then ob.extraDialog(self);
end;



procedure TFXcontrol.changeSelection(p:pointer);
var
  i:integer;
begin
  updateList;
  with treeView1 do
  begin
    for i:=0 to items.count-1 do
      if items[i].data=p then
        begin
          items[i].selected:=true;
          exit;
        end;
  end;
end;

procedure TFXcontrol.updatePosition;
var
  msg:Tmsg;
begin
  if PeekMessage( Msg, handle,wm_mouseMove,wm_mouseMove,pm_noRemove)
  then exit;

  if assigned(inform) then inform.updatePosition;
end;

procedure TFXcontrol.updateSize;
var
  msg:Tmsg;
begin
  if PeekMessage( Msg, handle,wm_mouseMove,wm_mouseMove,pm_noRemove)
  then exit;

  if assigned(inform) then inform.updateSize;
end;

procedure TFXcontrol.updateTheta;
var
  msg:Tmsg;
begin
  if PeekMessage( Msg, handle,wm_mouseMove,wm_mouseMove,pm_noRemove)
  then exit;

  if assigned(inform) then inform.updateTheta;
end;


procedure TFXcontrol.FormCreate(Sender: TObject);
var
  i,h,l:integer;
begin
  Gdisp:=1;
  FacqInterface:=true;

  BMfen:=TbitmapEx.create;
  DXcontrol:=BMfen;

  HKpaintPaint:=PaintControl;

  UpdateVisualInspector:=updateInForm;

  l:=width;
  h:=height;
  calculateSize(l,h);
  width:=l;
  height:=h;

  topExtra:=BBextra.top;
  height0:=BBextra.top+BBextra.height+10;
  width0:=width;

  for i:=1 to 2 do stmTrack[i]:=TstmTrack.create;

  DXscreen:=TDXscreen9.create(self);
  DXscreen.initDX9;
  DXscreen.PaintProc:=PaintScreen;

  //DXscreenB.finalizeG:=updateStimScreen;

  AddToActivateList(ActivateDX);
  application.onDeActivate:=DeActivateDX;

  errorList:=Tlist.create;
  Tbase:=0.1;

  TrackChannel[1]:=1;
  TrackChannel[2]:=2;

  TrackPoint[1]:=9;
  TrackPoint[2]:=0;

  TrackColor[1]:=clYellow;
  TrackColor[2]:=cllime;

  DotSize[1]:=2;
  DotSize[2]:=2;

  TrackShift[1]:=2;
  TrackShift[2]:=-2;

  TrackDelay:=20;

  repFirst:=1;
  DrawFirst:=1;

  FSaveObjects:=true;

  TestSampleInt:=0.010;
  TestAcqDuration:=10;

  UpdateCOntrols;

  detector:=Tlist.Create;

  QualityJpeg:=100;
  RedFactor:=1;
  SkipFactor:=0;
end;

procedure TFXcontrol.FormDestroy(Sender: TObject);
var
  i:integer;
begin
{
  for i:=1 to 2 do
    stmTrack[i].free;
}
  errorList.free;

  detector.Free;
end;


procedure TFXcontrol.TreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  if Fupdate then exit;

  treeView1.visible:=false;

  ob:=node.data;
  st0:=node.text;
  changeObvis;
end;

procedure TFXcontrol.BitBtn1Click(Sender: TObject);
begin
  if HKpaint.FModified then updateList;

  treeview1.visible:=not treeview1.visible;
  treeview1.bringToFront;
end;


procedure TFXcontrol.PaintControlSurface;
begin
  if not assigned(DXcontrol) or not visible then exit;

  initGraphic(DXcontrol);
  clearWindow(clBlack);

  PaintControlSurface1;

  if Fline then drawLine;
  if not animationON and (UOselectedOnControl<>nil)
    then UOselectedOnControl.showHandles;

end;

procedure TFXcontrol.PaintControlSurface1;
var
  i,p:integer;
begin
  for i:=1 to 2 do
    if TracksOn[i] then stmTrack[i].DisplayPoints;

  for p:=1 downto 0 do
    for i:=0 to HKpaint.count-1 do
      with typeUO(HKpaint.items[i]) do
      begin
        MainWindow;
        if onControl then Paint(p);
        if animationON and not isOnCtrl and (p=0) then FlagOnControl:=false;
      end;
end;

procedure TFXcontrol.PaintControl;
begin
  resizeBM;
  PaintControlSurface;
  drawBM;
end;

procedure TFXcontrol.PaintTopSync(w:boolean);
var
  rectA: TD3Drect;
begin
  if SyncDebugModeA then w:=true;
  if FwinMode then exit;

  with DXscreen do
  case VSsyncMode of
    0: if w then
       begin
         with rectA do
         begin
           x1:=0; y1:=0; x2:=SSwidth div 2-1; y2:=1;
         end;
         Idevice.Clear(1,  @rectA, D3DCLEAR_TARGET, DevColRed, 1.0, 0);
       end;
    1: if w then
       begin
         // Quand on a deux tops consécutifs, on bascule d'un spot à l'autre.
         // Sinon, on utilise toujours le même
         if syncRectOrder then
         begin
           with VSsyncRect[2] do Idevice.Clear(1, @rect1, D3DCLEAR_TARGET, DevColWhite, 1.0, 0);
           with VSsyncRect[1] do Idevice.Clear(1, @rect1, D3DCLEAR_TARGET, DevColBlack, 1.0, 0);
         end
         else
         begin
           with VSsyncRect[1] do Idevice.Clear(1, @rect1, D3DCLEAR_TARGET, DevColWhite, 1.0, 0);
           with VSsyncRect[2] do Idevice.Clear(1, @rect1, D3DCLEAR_TARGET, DevColBlack, 1.0, 0);
         end;

         syncRectOrder:=not syncRectOrder;
       end
       else
       begin
         with VSsyncRect[1] do Idevice.Clear(1, @rect1, D3DCLEAR_TARGET, DevColBlack, 1.0, 0);
         with VSsyncRect[2] do Idevice.Clear(1, @rect1, D3DCLEAR_TARGET, DevColBlack, 1.0, 0);
         syncRectOrder:= false;
         // dés qu'on a un Noir , on bascule sur le premier spot
       end;
  end;
end;


procedure TFXcontrol.PaintTopControl(w:boolean);
var
  rectA: TD3Drect;
begin
  if SyncDebugModeA then w:=true;

  if FwinMode then exit;
  with DXscreen do
  case VSsyncMode of
    0: if w then
       begin
         with rectA do
         begin
           x1:=SSwidth div 2; y1:=0; x2:= SSwidth -1; y2:=1;
         end;
         Idevice.Clear(1,  @rectA, D3DCLEAR_TARGET, DevColBlue, 1.0, 0);
       end;
    1: if w then
       begin
         with VScontRect[1+ ord(contRectOrder)] do Idevice.Clear(1, @rect1, D3DCLEAR_TARGET, DevColWhite, 1.0, 0);
         with VScontRect[1+ ord(not contRectOrder)] do Idevice.Clear(1, @rect1, D3DCLEAR_TARGET, DevColBlack, 1.0, 0);
         contRectOrder:=not contRectOrder;
       end
       else
       begin
         with VScontRect[1] do Idevice.Clear(1, @rect1, D3DCLEAR_TARGET, DevColBlack, 1.0, 0);
         with VScontRect[2] do Idevice.Clear(1, @rect1, D3DCLEAR_TARGET, DevColBlack, 1.0, 0);
         contRectOrder:= false;
         // dés qu'on a un Noir , on bascule sur le premier spot
       end;
  end;
end;


procedure TFXcontrol.SetSpotParams;
var
  i:integer;
begin
  for i:=1 to 2 do
  with VSsyncSpot[i] do
  begin
    VSsyncRect[i].rect1.x1:=    CmToPix(x - VSspotSize/2);
    VSsyncRect[i].rect1.x2:=    CmToPix(x + VSspotSize/2);
    VSsyncRect[i].rect1.y1:=    CmToPix(y - VSspotSize/2);
    VSsyncRect[i].rect1.y2:=    CmToPix(y + VSspotSize/2);

    VSsyncRect[i].devcol:= DevColGreen; //syspal.lumIndex(lum);
  end;

  for i:=1 to 2 do
  with VScontSpot[i] do
  begin
    VScontRect[i].rect1.x1:=    CmToPix(x - VSspotSize/2);
    VScontRect[i].rect1.x2:=    CmToPix(x + VSspotSize/2);
    VScontRect[i].rect1.y1:=    CmToPix(y - VSspotSize/2);
    VScontRect[i].rect1.y2:=    CmToPix(y + VSspotSize/2);

    VScontRect[i].devcol:= DevColGreen; //syspal.lumIndex(lum);
  end;

end;

(*
 // Dans cette version, on utilise le Alpha de la source pour mélanger avec les objets déjà affichés
 // Defaut: il est impossible de distinguer le fond des objets affichés.

procedure TFXcontrol.paintScreenSurface;
var
  i,res:integer;
  vEyePt, vLookatPt, vUpVec: TD3DVector;
  mat: TD3Dmatrix;
  backBuf: Idirect3Dsurface9;
  FlagMask: boolean;

begin
  if not assigned(DXscreen) or not DXscreen.Initialized then exit;

  with DXscreen do
  begin
    if not TestDevice then exit;


    FlagMask:=assigned(maskbar) and (maskList.count>0);
    // on remplit le fond avec Alpha=0
    // on remplit aussi le Z-buffer avec 1
    if FlagMask
      then Idevice.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, DevcolBK1, 1 , 0) // Couleur BK avec alpha=0
      else Idevice.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, DevcolBK, 1 , 0); // Couleur BK avec alpha=1

    if (SUCCEEDED(Idevice.BeginScene)) then
    begin

      //View
      vEyePt:= D3DXVector3(0, 0,  -100000 );
      vLookatPt:= D3DXVector3(0, 0, 0.0);
      vUpVec:= D3DXVector3(0.0, 1.0, 0.0);
      D3DXMatrixLookAtLH(mat, vEyePt, vLookatPt, vUpVec);
      Idevice.SetTransform(D3DTS_VIEW, mat);

      //Projection
      //D3DXMatrixPerspectiveFovLH(mat,arctan(ScreenHeight*180/pi/ScreenDistance/2/1000)*2 , SSwidth/SSheight, -2, 2);
      D3DXMatrixOrthoLH(mat, ScreenWidth*180/pi/ScreenDistance, ScreenHeight*180/pi/ScreenDistance, 100000-32768, 100000+32767);
      // Le paramètre Z des objets vaut 0 par défaut . On peut lui attribuer une valeur comprise entre -32000 et +32000

      res:=IDevice.SetTransform(D3DTS_PROJECTION, mat);

      setBlendConfig(BC_sprite);
      IDevice.SetRenderState(D3DRS_ZENABLE, itrue);
      // On affiche les objets.
      for i:=0 to HKpaint.count-1 do
      with typeUO(HKpaint.items[i]) do
      if onScreen then
        begin
          if not isMask then afficheS;
          if AnimationON and not isOnScr then FlagOnScreen:=false;
           {En animation, on remet le flag à false systématiquement}
        end;                                                        // A ce stade, alpha=0 partout si mask, alpha=1 partout si pas de mask
      IDevice.SetRenderState(D3DRS_ZENABLE, ifalse);

      if FlagMask then
      begin
        //setBlendConfig(bc_AlphaZero);
        //maskBar.afficheS;

        setBlendConfig(BC_mask);
        // On affiche les objets masques avec alpha=1 . Seul alpha du BK est modifié
        for i:=0 to MaskList.count-1 do
          with typeUO(MaskList[i]) do
            if onScreen
              then afficheS;

        // On affiche le BK dans les régions où alpha=0
        if TransformList.count=0 then
        begin
          setBlendConfig(bc_final);
          maskBar.afficheS;
        end;
      end;

      Idevice.EndScene;
    end;

    for i:=0 to TransformList.count-1 do
       TVStransform(TransformList[i]).doTransform;

    PaintTopSync(FtopSync);
    PaintTopControl(FtopControle);

    if renderSurface<>nil then
    begin
      Idevice.getBackBuffer(0,0,D3DBACKBUFFER_TYPE_MONO,backBuf);
      res:= Idevice.StretchRect( renderSurface, nil, backBuf , nil, D3DTEXF_NONE);
      BackBuf:=nil;
    end;

    DX9end;
  end;
end;
*)


// 17-11-2014 On mélange en utilisant le alpha de la destination
procedure TFXcontrol.paintScreenSurface;
var
  i,res:integer;
  vEyePt, vLookatPt, vUpVec: TD3DVector;
  mat: TD3Dmatrix;
  backBuf: Idirect3Dsurface9;
  FlagMask: boolean;
  chg:boolean;

begin
  if not assigned(DXscreen) or not DXscreen.Initialized then exit;

  with DXscreen do
  begin
    if not TestDevice then
    begin
      affdebug('TestDevice=false',112);
      exit;
    end;

    FlagMask:=assigned(maskbar) and (maskList.count>0);
    // on remplit le fond avec Alpha=1
    // on remplit aussi le Z-buffer avec 1
    Idevice.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, DevcolBK, 1 , 0); // Couleur BK avec alpha=1

    if (SUCCEEDED(Idevice.BeginScene)) then
    begin

      //View
      vEyePt:= D3DXVector3(0, 0,  -100000 );
      vLookatPt:= D3DXVector3(0, 0, 0.0);
      vUpVec:= D3DXVector3(0.0, 1.0, 0.0);
      D3DXMatrixLookAtLH(mat, vEyePt, vLookatPt, vUpVec);
      Idevice.SetTransform(D3DTS_VIEW, mat);

      //Projection
      //D3DXMatrixPerspectiveFovLH(mat,arctan(ScreenHeight*180/pi/ScreenDistance/2/1000)*2 , SSwidth/SSheight, -2, 2);
      D3DXMatrixOrthoLH(mat, ScreenWidth*180/pi/ScreenDistance, ScreenHeight*180/pi/ScreenDistance, 100000-32768, 100000+32767);
      // Le paramètre Z des objets vaut 0 par défaut . On peut lui attribuer une valeur comprise entre -32000 et +32000

      res:=IDevice.SetTransform(D3DTS_PROJECTION, mat);

      setBlendConfig(BC_sprite2);                                   // On affiche les objets  en utilisant le alpha de la destination
      IDevice.SetRenderState(D3DRS_ZENABLE, itrue);                 // Si on utilise celui de la source, l'objet va se mélanger avec le fond

      for i:=0 to HKpaint.count-1 do
      with typeUO(HKpaint.items[i]) do
      if onScreen then
        begin
          if not isMask then
          begin
            //if DoNotCopyAlpha then setBlendConfig(BC_sprite3);
            chg:= setBlendOp;
            afficheS;
            if chg then setBlendConfig(BC_sprite2);
            //if DoNotCopyAlpha then setBlendConfig(BC_sprite2);
          end;
          if AnimationON and not isOnScr then FlagOnScreen:=false;
           {En animation, on remet le flag à false systématiquement}
        end;                                                        // A ce stade, alpha=1  ou bien une valeur venant d'un objet
      IDevice.SetRenderState(D3DRS_ZENABLE, ifalse);

      if FlagMask then
      begin
        setBlendConfig(bc_AlphaZero);                    //  impose Alpha=0 partout
        maskBar.afficheS;

        setBlendConfig(BC_mask);                         //  On affiche les objets masques en copiant seulement leur alpha
        for i:=0 to MaskList.count-1 do                  //  Si alpha=1 (cas général), on aura une ouverture
          with typeUO(MaskList[i]) do                    //  Pour les alpha intermédiaires, on aura une atténuation
            if onScreen
              then afficheS;

        // On affiche le BK dans les régions où alpha<1
        if not TransformList.UseRenderSurface then
        begin
          setBlendConfig(bc_final);
          maskBar.afficheS;
        end;
      end;

      Idevice.EndScene;
    end;

    if AnimationON
      then transformList.DoRenderSurfaceTransforms;        // Applique les transforms sur RenderSurface

    PaintTopSync(FtopSync);
    PaintTopControl(FtopControle);

    if renderSurface<>nil then
    begin
      Idevice.getBackBuffer(0,0,D3DBACKBUFFER_TYPE_MONO,backBuf);
      res:= Idevice.StretchRect( renderSurface, nil, backBuf , nil, D3DTEXF_NONE);
      BackBuf:=nil;
    end;

    DX9end;
  end;
end;


procedure TFXcontrol.paintScreen;
begin
  paintScreenSurface;
  if assigned(DXscreen) then DXscreen.flip(true)
  else
  if Fsim then
    begin
      repeat until getTimer2>=Tfreq;
      initTimer2;
    end;
  flipOK:=true;
end;

procedure TFXcontrol.paintScreenNoWait;
begin

  paintScreenSurface;
  if assigned(DXscreen) then DXscreen.flip(false);
end;

procedure TFXcontrol.updateStimScreen;
begin
  paintScreenNoWait;
  paintScreenNoWait;
  paintScreenNoWait;
end;

function TFXcontrol.UoSelectedOnControl:typeUO;
begin
  if HKpaint.FModified then updateList;

  if assigned(ob) and (ob.onControl)
    then result:=ob
    else result:=nil;
end;


procedure TFXcontrol.DXDraw1MouseDown1(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i:integer;
begin
{ On regarde d'abord si l'on a cliqué sur un des objets }
  if UOselectedOnControl<>nil then
    with UOselectedOnControl do
      if mouseDown(button,shift,x,y) then exit;

  for i:=0 to HKpaint.count-1 do
    with typeUO(HKpaint.items[i]) do
    begin
      if onControl and mouseDown(button,shift,x,y) then
        begin
          changeSelection(typeUO(HKpaint.items[i]));
          PanelBottom.caption:=ident;
          exit;
        end;
    end;

  {Si ce n'est pas le cas, on capture l'objet pour le faire tourner }

  if button=mbRight then
    begin
      thetaLocked:=(ssCtrl in shift);
      if UOselectedOnControl is Tresizable
        then rotateUO:=Tresizable(UOselectedOnControl)
        else rotateUO:=nil;

      if (rotateUO=nil) then exit;
      if rotateUO.locked or rotateUO.noTheta then exit;

      if not thetaLocked then
        begin
          oldXs:=x;
          oldYs:=y;
          x0:=degToXC(rotateUO.deg.x);
          y0:=degToYC(rotateUO.deg.y);

          if x-x0<>0 then
            with rotateUO do
            begin
              deg.theta:=calculTheta(x-x0,y-y0);
              setLine(x0,y0,x,y);
              majpos;
              updateTheta;
            end;
        end
      else
        begin
          oldXs:=x;
          oldYs:=y;
          x00:=rotateUO.deg.x;
          y00:=rotateUO.deg.y;
          x0:=degToXC(x00);
          y0:=degToXC(y00);

          calculXY(XCtoDeg(x),YCtoDeg(y),x00,y00,
                   rotateUO.deg.theta,
                   rotateUO.deg.x,rotateUO.deg.y);

          x0:=degToXC(rotateUO.deg.x);
          y0:=degToYC(rotateUO.deg.y);
          setLine(x0,y0,x,y);

          with rotateUO do
          begin
            majpos;
            updatePosition;
          end;

        end;
    end;
end;




procedure TFXcontrol.PaintBox0MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

  x:=x-round(DxGDisp);
  y:=y-round(DyGDisp);

  DXDraw1MouseDown1(Sender,Button,Shift,x,y);
  Xmouse:=x;
  Ymouse:=y;

  ShiftKeyON:=(ssShift in shift);
  CtrlKeyON:= (ssCtrl in shift);
  AltKeyON:=  (ssAlt in shift);

  case button of
    mbRight: with EventProg[mrDown] do
             if valid then pg.executerProcedure(ad);
    mbLeft:  with EventProg[mlDown] do
             if valid then pg.executerProcedure(ad);
  end;
end;

procedure TFXcontrol.PaintBox0MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  i,k:integer;
begin
  x:=x-round(DxGDisp);
  y:=y-round(DyGDisp);


  PanelMouse.caption:=Estr(XCtoDeg(x),2)+'/'+Estr(YCtoDeg(y),2);

  if rotateUO<>nil then
    begin
      if rotateUO.locked or rotateUO.noTheta then exit;
      if (oldXs<>x) or (oldYs<>y) then
        if not thetaLocked then
          begin
            if x-x0<>0 then
              with rotateUO do
              begin
                deg.theta:=calculTheta(x-x0,y-y0);
                setLine(x0,y0,x,y);
                majpos;
                updateTheta;
              end;

            oldXs:=x;
            oldYs:=y;
          end
        else
          begin
            oldXs:=x;
            oldYs:=y;

            calculXY(XCtoDeg(x),YCtoDeg(y),
                     x00,y00,rotateUO.deg.theta,rotateUO.deg.x,rotateUO.deg.y);

            x0:=DegToXC(rotateUO.deg.x);
            y0:=DegToYC(rotateUO.deg.y);

            setLine(x0,y0,x,y);
            with rotateUO do
            begin
              majpos;
              updateTheta;
            end;

            oldXs:=x;
            oldYs:=y;
          end;
      exit;
    end;

  for i:=0 to HKpaint.count-1 do
    if typeUO(HKpaint.items[i]).onControl then
    begin
      k:=typeUO(HKpaint.items[i]).mouseMove(shift,x,y);
      if k>0 then
        begin
          if (k=1) or (k=3) then updatePosition;
          if (k=2) or (k=3) then updateSize;
          exit;
        end;
    end;

end;


procedure TFXcontrol.DXDraw1MouseUp1(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i:integer;
begin
  if rotateUO<>nil then
    begin
      with rotateUO do
      begin
        majPos;
        updateTheta;
      end;
      rotateUO:=nil;
      exit;
    end;

  for i:=0 to HKpaint.count-1 do
    with typeUO(HKpaint.items[i]) do
    if onControl then mouseUp(button,shift,x,y);
end;


procedure TFXcontrol.PaintBox0MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  x:=x-round(DxGDisp);
  y:=y-round(DyGDisp);


  DXDraw1MouseUp1(Sender,Button,shift,X,Y);

  Xmouse:=x;
  Ymouse:=y;

  ShiftKeyON:=(ssShift in shift);
  CtrlKeyON:= (ssCtrl in shift);
  AltKeyON:=  (ssAlt in shift);

  case button of
    mbRight: with EventProg[mrUp] do
             if valid then pg.executerProcedure(ad);
    mbLeft:  with EventProg[mlUp] do
             if valid then pg.executerProcedure(ad);
  end;

  PaintControl;
end;


procedure TFXcontrol.drawLine;
begin
  with DXcontrol.canvas do
  begin
    pen.style:=psSolid;
    pen.mode:=pmCopy;
    pen.color:=clWhite;
    with theLine do
    begin
      moveto(left,top);
      lineto(right,bottom);
    end;
  end;
  Fline:=false;
end;

procedure TFXcontrol.setLine(x1,y1,x2,y2:float);
begin
  TheLine:=rect(roundL(x1),roundL(y1),roundL(x2),roundL(y2));
  Fline:=true;
end;

procedure TFXcontrol.FormShow(Sender: TObject);
begin
  speedStim.down:=affStim;
  speedControl.down:=affControl;

  if not assigned(DXscreen) or not DXscreen.Initialized
    then InitialiseDXscreen;

  //if DXscreenB.inMemory then DXscreenB.Show;

  RFsys[1].OnScreen:=not RFsys[1].OnScreen;
  RFsys[1].OnScreen:=not RFsys[1].OnScreen;

end;


procedure TFXcontrol.InitialiseDXscreen;
var
  res: boolean;
begin
  with DXscreen do
  begin
    if initialized then Finalize;

    res:= initDevice(FwinMode, stDXdriver, SSwidth, SSheight,SSrefreshRate);


    if not res then FalwaysActivate:=false;

    calculateScreenConst;

    if initialized then
    begin
      HKpaintScreen:=paintScreen;
      syspal.update;
      if not assigned(maskbar) then maskbar:=Tbar.create;
      with maskbar do
      begin
        deg.dx:=screenwidth+1;
        deg.dy:=screenHeight+1;
        deg.lum:= syspal.BKlum;
        NotPublished:=true;
      end;
    end;
  end;
end;


procedure TFXcontrol.MessageDX1(var message:Tmessage);
begin
  show;
  hide;
end;

procedure TFXcontrol.MessageDX2(var message:Tmessage);
var
  i:integer;
begin
  for i:=0 to HKpaint.count-1 do
    with TypeUO(HKpaint.items[i]) do freeBM;

  syspal.update;
end;

procedure TFXcontrol.setDevColors;
begin
  devColBlue:=  D3DCOLOR_XRGB(0,0,255);
  devColRed:=   D3DCOLOR_XRGB(255,0,0);
  devColGreen:= D3DCOLOR_XRGB(0,255,0);

  devColBK:=    syspal.DX9color(syspal.BKlum,1);
  devColBK1:=   syspal.DX9color(syspal.BKlum,0);

  devColBlack:= D3DCOLOR_XRGB(0,0,0);
  devColWhite:= D3DCOLOR_XRGB(255,255,255);;

  if assigned(maskbar) then maskbar.deg.lum:=syspal.BKlum;
end;


procedure TFXcontrol.Palette1Click(Sender: TObject);
begin
  sysPal.menu;
  setDevColors;
end;

procedure TFXcontrol.updateInform;
var
  newF:boolean;
begin
  if not assigned(inform) then exit;
  ob.installDialog(inForm,newF);
  ob.completeDialog(inform);

  {if assigned(inform) then updateAllCtrl(inform);}
end;



procedure TFXcontrol.paintPage;
var
  i,k:integer;
  x:float;
begin
  if affControl and (timeProcess mod 5=0)  then PaintControl;


  paintScreen;
  {
  TNIboard(board).setDOStatic(true, true);

  for i:=1 to 1000 do x:=x+sin(i);

  TNIboard(board).setDOStatic(false, false);
  }
end;

procedure TFXcontrol.DisplayData;
begin
  if (timeProcess mod 5=0) then
    begin
      threadAff.doAffVS(acqIndex);
      {statusLineTxt(Istr(acqIndex));}
    end;
end;

procedure TFXcontrol.SaveAcqParams;
var
  i:integer;
begin
  with SavedAcq do
  begin
    continu:=AcqInf.continu;
    periodeCont:=AcqInf.periodeCont;

    DureePreTrigU:=AcqInf.DureePreTrigU;

    Qnbvoie:=AcqInf.Qnbvoie;

    for i:=1 to 16 do
      QvoieAcq[i]:=AcqInf.QvoieAcq[i];

    DureeSeqU:=AcqInf.DureeSeqU;


    ModeSynchro:=AcqInf.ModeSynchro;
    voieSynchro:=AcqInf.voieSynchro;

    Fdisplay:=AcqInf.Fdisplay;
    Fimmediate:=AcqInf.Fimmediate;
    Fcycled:=AcqInf.Fcycled;
    Fhold:=AcqInf.Fhold;

    FFdat:=AcqInf.FFdat;
    FValidation:=AcqInf.FValidation;

    for i:=1 to 16 do
    begin
      jru1[i]:=AcqInf.jru1[i];
      jru2[i]:=AcqInf.jru2[i];
      yru1[i]:=AcqInf.yru1[i];
      yru2[i]:=AcqInf.yru2[i];

      QvoieAcq[i]:=      AcqInf.QvoieAcq[i];
      ChannelType[i]:=   AcqInf.ChannelType[i];
      EvtHysteresis[i]:= AcqInf.EvtHysteresis[i];
      FRising[i]:=       AcqInf.FRising[i];
      EvtThreshold[i]:=  AcqInf.EvtThreshold[i];
      Qgain[i]:=         AcqInf.Qgain[i];
    end;

  end;
end;

procedure TFXcontrol.RestoreAcqParams;
var
  i:integer;
begin
  with SavedAcq do
  begin
    AcqInf.continu:=continu;
    AcqInf.periodeCont:=periodeCont;

    AcqInf.DureePreTrigU:=DureePreTrigU;

    AcqInf.Qnbvoie:=Qnbvoie;
    for i:=1 to 16 do
      AcqInf.QvoieAcq[i]:=QvoieAcq[i];

    AcqInf.DureeSeqU:=DureeSeqU;
    AcqInf.ModeSynchro:=ModeSynchro;
    AcqInf.voieSynchro:=voieSynchro;

    AcqInf.Fdisplay:=Fdisplay;
    AcqInf.Fimmediate:=Fimmediate;
    AcqInf.Fcycled:=Fcycled;
    AcqInf.Fhold:=Fhold;

    AcqInf.FFdat:=FFdat;
    AcqInf.FValidation:=FValidation;

    for i:=1 to 16 do
    begin
      AcqInf.jru1[i]:=jru1[i];
      AcqInf.jru2[i]:=jru2[i];
      AcqInf.yru1[i]:=yru1[i];
      AcqInf.yru2[i]:=yru2[i];

      AcqInf.QvoieAcq[i]:=      QvoieAcq[i];
      AcqInf.ChannelType[i]:=   ChannelType[i];
      AcqInf.EvtHysteresis[i]:= EvtHysteresis[i];
      AcqInf.FRising[i]:=       FRising[i];
      AcqInf.EvtThreshold[i]:=  EvtThreshold[i];
      AcqInf.Qgain[i]:=         Qgain[i];
    end;

  end;
end;

procedure TFXcontrol.InitAcqParams;
begin
  with AcqInf do
  begin
    board.setVSoptions;
    continu:=false;

    if FrameCount=0 then FrameCount:=1;
    DureeSeqU:=FrameCount*Tfreq/1000;

    DureePreTrigU:=0;
    PeriodeCont:=Tbase;

    if assigned(DXscreen) and (VSnotrigger=false)
      then ModeSynchro:=MSNumPlus
      else ModeSynchro:=MSimmediat;

    Fdisplay:=false;
    Fimmediate:=false;
    Fcycled:=false;
    Fhold:=false;

    FFdat:=false;
    FValidation:=false;

    {Fstim:=false;}

    MaxSamples:=Qnbpt{*nbvoieAcq} -1;  { 260309 }
    (*
    messageCentral('MaxSamples='+Istr(maxSamples)+crlf+
                 'Qnbpt='+Istr(Qnbpt)+crlf+
                 'nbVoieAcq='+Istr(nbVoieAcq)
                 );
    *)
  end;


  paramStim.install;

end;

procedure TFXcontrol.StartAcq(SaveAuto,FinitBoard:boolean);
var
  i:integer;
begin
  SaveAcqParams;
  initAcqParams;

  FdownSampling:=false;

  setLength(QKSU,AcqInf.nbvoieAcq+1);
  for i:=1 to AcqInf.Qnbvoie do                     { voies analogiques ou Evt }
  begin
    QKSU[i]:=AcqInf.QKS[i];
    if AcqInf.ChannelType[i] in [TI_anaEvent, TI_digiEvent] then QKSU[i]:=0;
    if QKSU[i]<>1 then FdownSampling:=true;
  end;                                              { Fdown=true si downSampling ou EVT }
  with AcqInf do
  if nbVoieAcq>Qnbvoie then QKSU[nbVoieAcq]:=1;     { voie tag pour tagMode=itc }


  if Fopen then
    begin
      openData(false);
      Fopen:=false;
    end
  else
  if Fappend then
    begin
      openData(true);
      Fappend:=false;
    end
  else
  if FopenPg then
    begin
      openPgData;
      FopenPg:=false;
    end;

  for i:=1 to 2 do stmTrack[i].init(self,i);
  DernierTraite:=-1;


  EvtAcq1.init;


  acquisition.startAcqVS(FdisplayData,saveAuto and assigned(facq),FinitBoard);
  nbvoieAcq1:=AcqInf.nbvoieAcq;
  nbpt0:=nbAg0*nbvoieAcq1;
  nbvEv:=AcqInf.nbVoieEvt;

end;

procedure TFXcontrol.StartRedraw;
var
  i:integer;
begin
  SaveAcqParams;
  initAcqParams;

  for i:=1 to acqinf.Qnbvoie do
  begin
    acqInf.jru1[i]:=0;
    acqInf.jru2[i]:=1;
    acqInf.yru1[i]:=datafile0.channel(i).x0u;
    acqInf.yru2[i]:=datafile0.channel(i).Dyu;
  end;

  for i:=1 to 2 do stmTrack[i].init(self,i);
  DernierTraite:=-1;

  adjustMainBuffers;

  TdataFile(dacDataFile).copyToBuffer(mainBuf,mainBufSize);

  if FdisplayData then
    begin
      acquisition.BuildAcqContext(false);
      threadAff:=TthreadAff.create(acqContext,AcqInf.maxPts,
                                   AcqInf.periodeUS,acqInf.Fimmediate,true );
      updateAff;
    end;

  if FdisplayData then AcqContext.resetWindows;
end;

procedure TFXcontrol.FinalizeEvt;
var
  k: integer;
begin
  if assigned(facq) then exit;
  if FmultiMainBuf then exit;

  for k:=1 to AcqInf.Qnbvoie do
    if AcqInf.ChannelType[k] in [TI_anaEvent, TI_digiEvent]
      then EvtBuf[k].getSpikeCount(AcqInf.dureeSeq);
     { Fait avancer IndexT }
end;

procedure TFXcontrol.EndAcq(wholeData:boolean);
var
  i:integer;
begin
  acquisition.EndAcqVS;

  if facq=nil
    then FinalizeEvt
    else saveData(wholeData);
  FsaveObjects:=true;

  if assigned(facq) then
    begin
      if nbSeqStim=1 then
      begin
        DataFile0.installFile0(acqInfF.stdat,false,false);
        DataFile0.setEpNum(nbSeqStim);
      end
      else DataFile0.updateElphyFile;
    end
  else DataFile0.initdataAcq(0,1);
  DataFile0.acqON:=false;

  controlTimes;

  RestoreAcqParams;
  {saveMainBuf;}

  for i:=0 to high(VfakeData) do VfakeData[i].Free;
  setlength(VfakeData,0);

  
end;

procedure TFXcontrol.AbortAcq;
begin
  acquisition.EndAcqVS;

  if assigned(facq) then
    begin
      if nbSeqStim>1 then DataFile0.updateElphyFile;
    end
  else DataFile0.initdataAcq(0,1);
  DataFile0.acqON:=false;

  RestoreAcqParams;
end;


procedure TFXcontrol.EndRedraw;
begin
  threadAff.free;
  threadAff:=nil;

  AcqContext.free;
  RestoreAcqParams;

end;

procedure TFXcontrol.TraiterDataSingle;
var
  i,j,k,tr:integer;
  x:smallint;
  trame:integer;

  Ftrack:boolean;
begin
  Ftrack:=assigned(trackObvis);

  if Ftrack then
  begin
    trackPos[TimeProcess mod trackPosMax]:=trackObvis.deg;
  end;

  {A Refaire en mode Index par voie }
  for i:=DernierTraite+1 to AcqIndex do
  for j:=0 to nbvoieAcq1-1 do
    begin
      k:=i*nbvoieAcq1+j;
      if Ftrack then
      begin
        x:=mainBuf^[k mod nbpt0];

        if Fdigi then
        {$IFNDEF WIN64}
        asm
          mov  ax,x
          mov  cx,shiftDigi
          sar  ax,cl
          mov  x,ax
        end;
        {$ELSE}
         x:=sar(x,shiftDigi);
        {$ENDIF}


        trame:=round(i*periodeG/Xframe);

        for tr:=1 to 2 do
          with stmTrack[tr] do
          if voie=j then traiter(trame,x);
      end;

      if (QKSU[j+1]=0) then traiterEvt(i,j);

    end;

  for i:=0 to Detector.Count-1 do
     TDetector(detector[i]).Update(AcqIndex);
     
  DernierTraite:=AcqIndex;
end;


procedure TFXcontrol.traiterDataMulti;
var
  i,j,k:integer;
  x:smallint;
  trame:integer;

  Ftrack:boolean;
begin
  Ftrack:=assigned(trackObvis);

  if Ftrack then
  begin
    trackPos[TimeProcess mod trackPosMax]:=trackObvis.deg;
  end;


  for i:=DernierTraite+1 to AcqIndex do
  for k:=0 to nbvoieAcq1-1 do
    begin
      if Ftrack then
      begin
        with MultimainBuf[k] do
        x:=GetSmall(i div QKSU[k+1]);

        trame:=round(i*periodeG/Xframe);

        for j:=1 to 2 do
          with stmTrack[j] do
          if voie=k then traiter(trame,x);
      end;
    end;

  for i:=0 to Detector.Count-1 do
    TDetector(detector[i]).Update(AcqIndex);

  DernierTraite:=AcqIndex;
end;


procedure TFXcontrol.traiterData;
begin
  if FmultiMainBuf
    then traiterDataMulti
    else traiterDataSingle;
end;


procedure TFXcontrol.TraiterDataRedraw;
var
  i,j,tr:integer;
  x:integer;
  trame:integer;


begin
  if not assigned(trackObvis) then exit;

  trackPos[TimeProcess mod trackPosMax]:=trackObvis.deg;

  for i:=DernierTraite+1 to AcqIndex do
  for j:=0 to AcqInf.nbvoieAcq -1 do
    begin
      trame:=round(i*periodeG/Xframe);
      x:=dataFile0.channel(j+1).Jvalue[i];

      for tr:=1 to 2 do
        with stmTrack[tr] do
        if voie=j then traiter(trame,x);
    end;

  DernierTraite:=AcqIndex;
end;

function TFXcontrol.redrawLoop:integer;
begin
  result:=round(timeProcess*Tfreq/1E6/periodeG);
  if result<0 then result:=0;
end;

procedure TFXcontrol.VerifyFakeVectors;
var
  i,k:integer;
begin
  for k:= 0 to AcqInf.Qnbvoie-1 do
  if (high(VfakeData)>=k) and assigned(VfakeData[k]) then
    with VfakeData[k] do
    if (tpNum<>G_smallint) or (Istart<>0) or (Iend<AcqInf.Qnbpt-1) then
    begin
      free;
      VfakeData[k]:=nil;
    end;
end;


procedure TFXcontrol.stimulerSeq1(AcqAuto,saveAuto,Fredraw,FinitBoard:boolean; Const delayMS:integer=0);
       { auparavant, il faut construire listeStim }
var
  i:integer;
  x:float;
  Msg: TMsg;
  flagFinExe:boolean;
  st:AnsiString;
  pp:Tpoint;


  tt:array[1..10] of integer;
  FlagNoTrigger:boolean;
  Fstop:boolean;
  t0Delay:integer;

  res:integer;
  AnimationError:boolean;
  cnt:integer;

  time0: longword;
begin
  AnimationError:=false;
  WarningList.clear;
  time0:= getTickCount;

  t0Delay:=getTickCount;
  setSpotParams;
  {On repère tous les objets déjà affichés.
   Ces objets resteront affichés pendant l'animation.
  }
  Fdigi:=assigned(board) and (board.dataFormat in [Fdigi1200,Fdigi1322]);

  VerifyFakeVectors;


  with HKpaint do
  for i:=0 to count-1 do
  with TypeUO(items[i]) do
  begin
    isOnScr:=onScreen;
    isOnCtrl:=onControl;
  end;

  flagFinExe:=false;

  if syslist.indexof(trackObvis)<0 then trackObvis:=nil;

  fillchar(trackPos,sizeof(trackPos),0);

  updateAff;

  panelError.visible:=false;
  panelError.caption:='Error';



  resetProcess;

  listeStim.installe;                { Chaque stimulus installe sa procedure refresh
                                       dans la liste des processus     }


  FlagAcq:=AcqAuto and FAcqInterface and assigned(board) and not FwinMode;

  if not(Fredraw and DrawFast)
    then installeProcess(paintPage); { Affiche control }
                                     { Affiche stim }
                                     { attente et flip stim}

  if acqAuto then installeProcess(TraiterData)
  else
  if Fredraw then installeProcess(TraiterDataRedraw);

  if FlagAcq and FdisplayData then installeProcess(DisplayData);

  animationON:=true;

  setPgButtonText('Stop');
  finImmediate:=false;
  stopStim:=false;
  KBlist.clear;

  cntFlip:=0;

  FtopSync:=false;
  FtopControle:=false;
  paintScreen;
  paintScreen;

  with TmainDac(multigraph0.formG).Bexe do
  begin
    RectBEXE.Left:=left;
    RectBEXE.Right:=left+width;
    RectBEXE.Top:= top;
    RectBEXE.Bottom:= top+height;
  end;

  if delayMS>0 then
  begin
    while (getTickCount<t0Delay+delayMS) and not StopStim  do
    begin
      testStopStim(flagFinExe);
      if FlagFinExe and QuestionFinPg then  visualStim.FXcontrol.StopStim:= true;
    end;
  end;

  with OnStartAnimate1 do
  if valid then pg.executerProcedure(ad);

  if StopStim then
  begin
    listeStim.desinstalle;
    setPgButtonText('PG');
    AnimationON:=false;
    exit;
  end;

  if FlagAcq then
  begin
    startAcq(saveAuto,FinitBoard);      {lancer l'acquisition}
    if FlagStopPanic then exit;
  end
  else
  if Fredraw then startRedraw;

  tt[1]:=TimeGetTime;

  if FlagAcq then periodeG:=acqInf.periodeParVoieMS/1000
  else periodeG:=0.001;

  if not Assigned(DXscreen) then
    begin
      Fsim:=true;
      initTimer2;
    end;

  paintScreen;   {qui démarrera sur le premier top synchro}

  lastTimer2:=0;
  initTimer2;

  if (FlagAcq {or Fredraw}) and FdisplayData then AcqContext.resetWindows;

  with OnStartAnimate2 do
  if valid then pg.executerProcedure(ad);
  if StopStim then
  begin
    AbortAcq;
    listeStim.desinstalle;
    setPgButtonText('PG');
    AnimationON:=false;
    exit;
  end;



  datafile0.FreeFileStream;
  FlagNoTrigger:=false;

  SyncDebugModeA:=SyncDebugMode;
  
Try
  cnt:=0;
  AddWarning('Start ',getTickCount-time0);
  repeat
    inc(cnt);
    Affdebug('                Process Loop = '+Istr(cnt)+'  TimeProcess = '+Istr(timeProcess), 112);
    FtopControle:= (TimeProcess=-1) or (timeProcess mod 2=1);

    if FlagAcq then AcqIndex:=threadInt.ExecuteLoop
    else
    if Fredraw then AcqIndex:=RedrawLoop;

    FtopSync:=(timeProcess=-1) ;

    executeProcess;

    TestStopStim(flagFinExe);

    //if TimeProcess=100 then                                             // Permet de générer une erreur d'animation
    //  for i:=1 to 500000 do x:= x+sin(i);  { 1000000 ==> 135 ms }

  until (timeProcess>=FrameCount) or finImmediate;
  AddWarning('End ',getTickCount-time0);
except
  AnimationError:=true;
end;
  Affdebug('Loop End cnt = '+Istr(cnt)+'  FrameCount = '+Istr(FrameCount), 112);
  FtopSync:=false;
  FtopControle:=false;
  PaintPage;


  if not finImmediate and FlagAcq then
    begin
      repeat
        AcqIndex:=ThreadInt.executeLoop;
        FlagNoTrigger:= (AcqIndex<1);
      until (AcqIndex>=maxSamples) or FlagNoTrigger or testEscape ;

      if FlagNoTrigger then StopStim:=true;

      tt[2]:=TimeGetTime;
      traiterData;
    end
  else
  if not finImmediate and Fredraw then
    begin
      AcqIndex:=maxSamples;
      traiterDataRedraw;
    end
  else
  if finImmediate and FstopOnClick then
  begin
    AcqIndex:=ThreadInt.executeLoop;
    traiterData;
  end;


  animationON:=false;

  setPgButtonText('PG');

  listeStim.desinstalle;

  FtopSync:=false;
  FtopControle:=false;
  PaintPage;

  if FlagAcq or Fredraw then
  begin
    if FlagAcq
      then EndAcq(finImmediate and FstopOnClick)
      else EndRedraw;


    if errorList.count>0 then
      begin
        panelError.visible:=true;
        panelError.caption:='Error='+Istr(ErrorList.count);
      end;

    st:=Istr(ErrorList.count)+' error';
    if errorList.count>1 then st:=st+'s';
    SavePanel.caption:=st;
    if errorList.count>0
      then savePanel.font.color:=clred
      else savePanel.font.color:=clgreen;
    savePanel.Update;

    if FlagNoTrigger then messageCentral('No trigger detected');
  end;

  if exeOn and FlagFinExe then QuestionFinPg;
  Fsim:=false;

  FstopOnClick:=false;

  if AnimationError then sortieErreur('Animate error');

  {messageCentral('TT='+Istr(tt[2]-tt[1]));}
  AddWarning('Out ',getTickCount-time0);
end;

procedure TFXcontrol.TestStopStim(var flagFinExe: boolean);
var
  msg: Tmsg;

  pp: Tpoint;
begin
  //Test du clavier
  if getInputState then
    begin
      while peekMessage(Msg,0,wm_keydown,wm_keydown,pm_remove) do
      begin
        case msg.wparam of
          vk_F12:    begin                            { touche F12 }
                       finImmediate:=true;
                       StopStim:=true;
                     end;
          $53{vk_S}: StopStim:=true;                  { touche S }

          vk_escape: if getKeyState(vk_shift) and $8000<>0 then { Shift Escape }
                       FlagfinExe:=true;

          else
            begin
              KBList.store(msg.wparam,trackPos[timeProcess mod trackPosMax]);
            end;
        end;
      end;
    end;

  // Test du clic dans controlScreen
  while peekMessage(Msg,Handle,0,0,pm_remove) and (msg.message<>wm_paint) do
  begin
    case msg.message of
      wm_lbuttonDown,wm_lbuttonUp:
        begin
          if FStopOnClick then FinImmediate:=true;
        end;
    end;
  end;

  // Test du clic sur le bouton BEXE
  while peekMessage(Msg,multigraph0.formG.Handle,WM_LButtonDown,WM_MouseLast,pm_remove) do    // tout sauf MouseMove
  begin
    affDebug('Message='+Istr(msg.hwnd)+' '+ Istr(Msg.message)+' '+Istr(msg.wParam)+' '+Istr(msg.lParam),11);

    pp:= multigraph0.formG.screenToClient(msg.pt);
    if PtInRect(RectBEXE ,pp)  then dispatchMessage(msg);
  end;

end;


procedure ReductionImage( mat1,mat2: Tmatrix; N:integer);
var
  Mtempo,Mfil: Tmatrix;
begin
  Mtempo:=nil;
  Mfil:=nil;
  if N=1 then
  begin
    proMcopy(mat1,mat2);
    exit;
  end;

  Mfil:= Tmatrix.create(t_single,0,N-1,0,N-1);
  Mfil.fill(1/sqr(N));
  Mtempo:= Tmatrix.create(t_single,0,0,0,0);

  try
  proMconv_1(mat1,Mfil,Mtempo,true);
  mat2.modify(t_single,0,0, mat1.Icount div N-1,mat1.Jcount div N-1);
  proMresizeImage(Mtempo,mat2,1/N,-0.49999,1/N,-0.49999,1);
  with mat2 do
  begin
    ippsthreshold_32f_I(tbS,Icount*Jcount,0,ippCmpLess);
    ippsthreshold_32f_I(tbS,Icount*Jcount,255,ippCmpGreater);
  end;
  finally
  Mfil.Free;
  Mtempo.Free;
  end;
end;



procedure TFXcontrol.BuildAvi(FTex: boolean);
const
  FPS=30;
var
  avi:TsimpleAvi;
  bm:Tdib;
  mat1,mat2: Tmatrix;
  i,cnt,rapp:integer;
  OldScreenHeight: float;
  tex:TtextureFile;

  weff,heff:integer;
  OldFwinMode: boolean;
begin

  if RedFactor<1 then RedFactor:=1;

  weff:=SSwidth div RedFactor;
  heff:=SSheight div RedFactor;

  try

  with HKpaint do
  for i:=0 to count-1 do
  with TypeUO(items[i]) do
  begin
    isOnScr:=onScreen;
    isOnCtrl:=onControl;
  end;

  listeStim.build;

  if not Ftex then
  begin
    bm:=TbitmapEx.create;
    bm.ColorTable:=MonoColorTable(true);
    bm.UpdatePalette;

    bm.SetSize(weff, heff ,8);
  end;

  OldFwinMode:=FwinMode;
  FwinMode:=true;

  resetProcess;
  listeStim.installe;
  installeProcess(paintScreenNoWait);

  animationON:=true;

  FtopSync:=false;
  FtopControle:=false;
  paintScreen;
  paintScreen;

  
  if Ftex then
  begin
    tex:= TtextureFile.create;
    tex.NotPublished:=true;
    tex.CreateFile(stfTex,weff,heff,g_byte);    // TODO : sauver en mode réel ==> luminances vraies
    rapp:= SkipFactor;
  end
  else
  begin
    avi:=TsimpleAvi.create(stfAvi,bm,FPS);
    rapp:=round( 1/FPS/Xframe);
    if rapp<=0 then rapp:=1;
  end;

  cnt:=0;
  mat1:= Tmatrix.create(g_single,0,SSwidth-1,0,SSheight-1);
  mat2:= Tmatrix.create(g_single,0,weff-1,0,heff-1);

  repeat
    executeProcess;

    if cnt mod rapp=0 then
    begin
      DXscreen.getMatrix(mat1,false);
      ReductionImage(mat1,mat2,Redfactor);
      if Ftex then tex.writeMatrix(mat2)
      else
      begin
        mat2.MatToDib(bm,true);
        avi.save(bm);
      end;
    end;

    inc(cnt);
  until (timeProcess>=FrameCount) or TestEscape;

  clearScreen;
  DXscreen.getMatrix(mat1,false);
  ReductionImage(mat1,mat2,Redfactor);

  if Ftex then
  begin
    tex.writeMatrix(mat2);
    tex.free;
  end
  else
  begin
    mat2.MatToDib(bm,true);
    avi.save(bm);
    avi.Free;
  end;


  animationON:=false;

  listeStim.desinstalle;

  FtopSync:=false;
  FtopControle:=false;
  PaintPage;

  Fsim:=false;
  listeStim.Clear;
  freeMainMask;

  finally
  mat1.Free;
  mat2.Free;
  if not Ftex then bm.Free;
  FwinMode:= OldFwinMode;
  end;

end;

function TFXcontrol.getDotProd(i0,j0:integer;Smask:Tmatrix):single;
begin
end;



procedure TFXcontrol.ReducStim(Smask:Tmatrix;Xpos,Ypos:Tvector;Nx,Ny:integer;Mlist:TmatList);
var
  mat: Tmatrix;
  i,j,k: integer;
  TbMask:TarrayOfsingle;
  Vx,Vy: TarrayOfInteger;

begin
  SetLength(Vx,Xpos.Icount);
  SetLength(Vy,Xpos.Icount);

  for i:=Xpos.Istart to Xpos.Iend do
  begin
    Vx[i-Xpos.Istart]:= round(Xpos[i]);
    Vy[i-Xpos.Istart]:= round(Ypos[i]);
  end;

  setLength(tbMask,Smask.Icount*Smask.Jcount);
  with Smask do
  for i:= 0 to Icount-1 do
  for j:= 0 to Jcount-1 do
    tbmask[i+Icount*j]:= Smask[Istart+i,Jstart+j];


  with HKpaint do
  for i:=0 to count-1 do
  with TypeUO(items[i]) do
  begin
    isOnScr:=onScreen;
    isOnCtrl:=onControl;
  end;

  listeStim.build;

  resetProcess;

  listeStim.installe;


  installeProcess(paintScreenNoWait);

  animationON:=true;

  FtopSync:=false;
  FtopControle:=false;
  paintScreen;
  paintScreen;

  mat:=Tmatrix.create;
  mat.initTemp(1,Nx,1,Ny,g_single);

  try
  repeat
    executeProcess;

    DXscreen.getMaskMat(@tbMask[0],Smask.Icount,Smask.Jcount ,Vx,Vy,mat.tb,Nx,Ny);
    Mlist.AddMatrix(mat);

  until (timeProcess>=FrameCount) or TestEscape;

  finally
  clearScreen;

  animationON:=false;

  listeStim.desinstalle;

  FtopSync:=false;
  FtopControle:=false;
  PaintPage;

  Fsim:=false;
  listeStim.Clear;
  freeMainMask;

  mat.Free;
  end;
end;


procedure TFXcontrol.ReducStim2(x1,y1,x2,y2: integer; Mlist:TmatList; LumValues:boolean; Const stTex: AnsiString='');
var
  mat: Tmatrix;
  i,j,k: integer;
  Nx,Ny: integer;
  tex: Ttexturefile;
begin
  listeStim.build;
  resetProcess;
  listeStim.installe;

  installeProcess(paintScreenNoWait);
  animationON:=true;

  FtopSync:=false;
  FtopControle:=false;
  paintScreen;
  paintScreen;

  Nx:= x2-x1+1;
  Ny:= y2-y1+1;

  mat:=Tmatrix.create;
  mat.initTemp(1,Nx,1,Ny,g_single);

  try
    if stTex<>'' then
    begin
      tex:= TtextureFile.create;
      tex.NotPublished:=true;
      if LumValues
        then tex.CreateFile(stTex,Nx,Ny,g_single)
        else tex.CreateFile(stTex,Nx,Ny,g_byte);
    end
    else Mlist.clear;

    repeat
      executeProcess;

      DXscreen.getPixMat(x1,y1,x2,y2,mat.tb);
      if LumValues then
      with mat do
      for i:=Istart to Iend do
      for j:=Jstart to Jend do
        Zvalue[i,j]:= sysPal.PixToLum(Zvalue[i,j]);

      if stTex<>''
        then tex.writeMatrix(mat)
        else Mlist.AddMatrix(mat);

    until (timeProcess>=FrameCount) or TestEscape;

  finally
    if stTex<>'' then tex.Free;
    clearScreen;

    animationON:=false;

    listeStim.desinstalle;

    FtopSync:=false;
    FtopControle:=false;
    PaintPage;

    Fsim:=false;
    listeStim.Clear;
    freeMainMask;

    mat.Free;
  end;
end;

procedure TFXcontrol.StimulerSeq(FinitBoard:boolean; const delayMS:integer=0; const f:Tobjectfile=nil);
begin

  listeStim.build;

  stimulerSeq1(true,true,false,FinitBoard, delayMS);

  if assigned(f) then
  begin
    f.fileStream.Position:= f.fileStream.Size;
    listeStim.saveToStream(f.fileStream);
  end;

  listeStim.clear;

  PaintControl;
  PaintScreen;

  if SyncDebugMode then
  begin
    SyncDebugMode:= false;
    SyncDebugModeA:= false;
    VSnotrigger:=false;
  end;

end;

procedure TFXcontrol.MesureRefreshTime1;
var
  Von1,Von2:boolean;
  t1,t2:integer;
  i,j,k,nb:integer;
  maxI,nextI:integer;
  voieCont1:integer;
  indexT1,oldIndexT1:integer;
  cnt:integer;
begin
  if not assigned(board) then
    begin
      messageCentral('Acquisition board not installed');
      exit;
    end;

  with RefreshTimeMeasurement do
  begin
    enSampleInt.setVar(TestSampleInt,G_double);
    enSampleInt.setMinMax(0.001,100);

    enAcqDur.setVar(TestAcqDuration,G_double);
    enAcqDur.setMinMax(1,1000);

    if showModal=mrOK
      then updateAllVar(RefreshTimeMeasurement)
      else exit;
  end;


  SaveAcqParams;

  FtopSync:=false;
  FtopControle:=false;
  UpdateStimScreen;

  SetSpotParams;
  setSyncCont;

  with AcqInf do
  begin
    board.setVSoptions;
    continu:=false;
    Fstim:=false;

    DureeSeqU:=TestAcqDuration*1000;
    Qnbvoie:=1;
    if VSControlInput>=2 then         { correspond à v1, v2.. }
    begin
      QvoieAcq[1]:=QvoieAcq[VSControlInput-1];

      jru1[1]:=jru1[VSControlInput-1];
      jru2[1]:=jru2[VSControlInput-1];
      yru1[1]:=yru1[VSControlInput-1];
      yru2[1]:=yru2[VSControlInput-1];

      QvoieAcq[1]:=      QvoieAcq[VSControlInput-1];
      ChannelType[1]:=   TI_anaEvent;   //  channelType[VSControlInput-1];
      EvtHysteresis[1]:= EvtHysteresis[VSControlInput-1];
      FRising[1]:=       FRising[VSControlInput-1];
      EvtThreshold[1]:=  EvtThreshold[VSControlInput-1];
      Qgain[1]:=         Qgain[VSControlInput-1];
    end;


    PeriodeCont:=TestSampleInt;
    DureePretrigU:=0;

    if VSnotrigger
      then ModeSynchro:=MSimmediat
      else ModeSynchro:=MSNumPlus;

    Fdisplay:=false;
    Fimmediate:=false;
    Fcycled:=false;
    Fhold:=false;

    FFdat:=false;
    FValidation:=false;

    MaxSamples:=Qnbpt{*nbvoieAcq}-1  ;  {260309}
  end;

  setLength(QKSU,2);
  QKSU[0]:=0;

  acquisition.startAcqVS(false,false,true);

  nbvoieAcq1:=AcqInf.nbvoieAcq;
  nbpt0:=nbAg0*nbvoieAcq1;
  nbvEv:=AcqInf.nbVoieEvt;

  visualSys.Shape1.Visible:=true;
  visualSys.Shape1.update;

  maxI:=round(500/TestSampleInt);
  nextI:=maxI;

  cnt:=0;
  FtopSync:=true;
  FtopControle:=true;
  repeat
    DXscreen.fillBK(devColBK);

    inc(cnt);

    PaintTopSync(true);
    PaintTopControl(true);

    DXscreen.flip(true);

    //TNIboard(board).setDOStatic(true, true);

    PanelStatusX.Caption:=Istr(AcqIndex);
    PanelStatusX.update;

    AcqIndex:=threadInt.ExecuteLoop;

    //TNIboard(board).setDOStatic(false,false);

    if AcqIndex>nextI then
    begin
      visualSys.Shape1.Visible:=not visualSys.Shape1.Visible;
      visualSys.Shape1.update;
      nextI:=nextI+maxI;
    end;

  until (AcqIndex>=maxSamples {-round(100/AcqInf.periodeCont)}) or testEscape or flagStopPanic;

//  repeat until (AcqIndex>=maxSamples) or testEscape or flagStopPanic;

  board.DisplayErrorMsg;

  visualSys.Shape1.Visible:=false;
  visualSys.Shape1.update;
  Acquisition.EndAcqVS;

  FtopSync:=false;
  FtopControle:=false;
  UpdateStimScreen;


  nbVoieAcq1:=AcqInf.nbVoieAcq;

  if (VSControlInput>=2) and assigned(evtbuf[1]) then
  begin
    for i:=0 to acqInf.Qnbpt-1 do
      traiterEvt(i,0);

    IndexT1:=-1;
    nb:=evtBuf[1].ProcessSpikes(1,indexT1,oldIndexT1);

    if nb>1 then
    begin
      t1:=evtBuf[1].getLong(1);
      t2:=evtBuf[1].getLong(nb);
      Tfreq:= (t2-t1)*TestSampleInt*1000/(nb-1);
    end;
  end
  else
  begin
    VoieCont1:=nbVoieAcq1-1;
    if FmultiMainBuf
      then Von2:=MultiCyberTagBuf.getSmall(0) and BitCont<>0
      else Von2:= (mainBuf^[VoieCont1] and BitCont<>0);

    nb:=0;
    t1:=-1;
    t2:=0;

    for i:=1 to acqInf.Qnbpt-1 do
    begin
      Von1:=Von2;
      if FmultiMainBuf
        then Von2:=(MultiCyberTagBuf.getSmall(i) and BitCont<>0)
        else Von2:= (mainBuf^[i*nbVoieAcq1+VoieCont1] and BitCont<>0) ;
      if Von2 and not Von1 then
        begin
          if t1<0 then t1:=i;
          t2:=i;
          inc(nb);
        end;
    end;
    if nb>1
      then Tfreq:=(t2-t1)*TestSampleInt*1000/(nb-1);
  end;


  DataFile0.initdataAcq(0,1);
  RestoreAcqParams;
end;

procedure TFXcontrol.opendata(Fappend:boolean);
var
  i:integer;
begin
  if not Fappend then nbseqStim:=0;

  if assigned(facq) then facq.free;
  fAcq:=TElphyFile.create;
  Acquisition.fAcq:=fAcq;
  dataFile0.FreeFileStream;

  TRY
  with fAcq do
  begin
    if not Fappend then
      begin
        setFileInfoSize(AcqInf.FileInfoSize);
        setEpInfoSize(AcqInf.EpInfoSize);
        comment:=memoA.stList.text;
        while length(comment)<AcqInf.miniCommentSize do comment:=comment+' ';
        {setMTag(mainTag);}

        setAcqInf(@acqInf);
        if AcqInf.Fstim then setStim(@paramStim);


        createAcqFile(acqInfF.stdat);

        close;
      end
    else
      begin
        setAcqInf(@acqInf);
        if AcqInf.Fstim then setStim(@paramStim);

        AppendAcqFile(acqInfF.stdat);

        close;
      end;
  end;

  EXCEPT
    messageCentral('Unable to create '+acqinfF.stdat );
    facq.free;
    facq:=nil;
    Acquisition.fAcq:=nil;
    exit;
  END;

  if exeON then addToCpList(closeData);
end;

procedure TFXcontrol.openPgdata;
var
  i:integer;
begin
  nbseqStim:=0;

  TRY
  with fAcq do
  begin

    while length(comment)<AcqInf.miniCommentSize do comment:=comment+' ';

    setAcqInf(@acqInf);
    if AcqInf.Fstim then setStim(@paramStim);

    dataFile0.FreeFileStream;
    createAcqFile(acqInfF.stdat);

    close;
  end;

  EXCEPT
    messageCentral('Unable to create '+acqinfF.stdat );

    facq.free;
    facq:=nil;
    acquisition.fAcq:=nil;
    exit;
  END;

  addToCpList(closeData);
end;


procedure TFXcontrol.savedata(wholeData:boolean);
const
  maxBufS = 50000;
var
  res:integer;
  i,j,k:integer;

  bufS:array of smallint;
  Qnb:integer;


begin
  if facq=nil then exit;



  datafile0.FreeFileStream;


  if WholeData
    then Qnb:=acqinf.Qnbpt
    else Qnb:=dernierTraite -1;

  if Qnb<0 then Qnb:=0;

  Acquisition.PrepElphyFile(false, FmultiMainBuf, Qnb);

  facq.reopen;

  Acquisition.SaveObjectsToElphyFile(false);
  facq.ecrirePreSeq;

  if FmultiMainBuf then
  {
  with AcqInf do
  begin
    j:=0;
    setLength(bufS,maxBufS);
    for i:=0 to Qnb-1 do
    for k:=0 to nbVoieAcq-1 do
    begin
      if (QKSU[k+1]<>0) and (i  mod QKSU[k+1]=0)  then
      begin
        with MultimainBuf[k] do
          bufS[j]:=GetSmall(i div QKSU[k+1]);
        inc(j);
      end;
      if j=maxBufS-1 then
      begin
        facq.f.Write(bufS[0],j*2);
        j:=0;
      end;
    end;
    facq.f.Write(bufS[0],j*2);
    setLength(bufS,0);
  end
  }
  // 06-12-16  On sauve les données sans  re-multiplexer ==> un gain de temps énorme
  //   la même méthode est difficilement applicable pour les épisodes sans stim visuelle
  //   car on sauve les données à mesure.

  with AcqInf do
  begin
    for k:=0 to nbVoieAcq-1 do
      MultimainBuf[k].SaveAllData(fAcq.f);
  end

  else
  begin
    for k:=0 to AcqInf.nbVoieAcq-1 do
      if (length(VfakeData)>k) and  assigned(VFakeData[k]) then
        for i:=0 to Qnb-1 do mainBuf^[i*AcqInf.nbvoieAcq+k]:= VfakeData[k].Jvalue[i];

    If not FdownSampling then with acqInf do facq.f.Write(mainBuf^,Qnb*nbvoieAcq*2)
    else
    with acqInf do
    begin
      j:=0;
      setLength(bufS,maxBufS);
      for i:=0 to Qnb*nbvoieAcq-1 do
      begin
        k:=i mod nbvoieAcq;
        if (QKSU[k+1]=0) then {TraiterEvt(i)  déjà fait dans traiterData ? }
        else
        if (QKSU[k+1]<>0) and ((i div nbvoieAcq)  mod QKSU[k+1]=0)  then
        begin
          bufS[j]:=mainBuf^[i];
          inc(j);
        end;
        if j=maxBufS-1 then
        begin
          facq.f.Write(bufS[0],j*2);
          j:=0;
        end;
      end;
      facq.f.Write(bufS[0],j*2);
      setLength(bufS,0);
    end;
  end;

  facq.ecrirePostSeq;


  if FmultiMainBuf
    then acquisition.SaveEvtMulti(Qnb)
    else saveEvt(AcqInf.Qnbpt);


  if FSaveObjects then listeStim.saveToStream(facq.f);
  facq.close;

  flushFileBuffers(facq.f.handle);

  inc(nbseqStim);

  {SaveArrayAsDac2File('c:\delphe5\mainbuf.dat',mainBuf^,nbpt0,AcqInf.nbvoieAcq,G_smallint);}
end;

procedure TFXcontrol.closedata;
begin
  if assigned(facq) then
    begin
      //facq.reopen;
      //Acquisition.SaveObjectsToElphyFile(false);

      facq.close;
      facq.free;
      facq:=nil;
      acquisition.fAcq:=nil;
    end;
end;

procedure TFXcontrol.openDataFile;
var
  i:integer;
begin
  nbseqStim:=0;

  if assigned(facq) then facq.free;

  fAcq:=TElphyFile.create;
  acquisition.fAcq:=facq;

  with fAcq do
  begin
    setFileInfoSize(AcqInf.FileInfoSize);
    setEpInfoSize(AcqInf.EpInfoSize);
    comment:=memoA.stList.text;

    FopenPg:=true;
  end;
end;

function TFXcontrol.appendDF:boolean;
begin
  result:=TdataFile(dacdataFile).Filedesc is TElphyDescriptor;

  if result then
    begin
      acqinfF.stDat:=TdataFile(dacdataFile).stFichier;
      Fappend:=true;
    end;
end;


procedure TFXcontrol.Animateobjects1Click(Sender: TObject);
begin
  stimulerSeq(true);
  closedata;
end;

procedure TFXcontrol.Controltimes;
var
  i,t1:integer;
  tnom,minInt,maxInt:integer;
  Von1,Von2:boolean;
  cnt,nb:integer;
  min,max:float;
  InhibDelay: integer;
begin
  errorList.clear;

  if (VSControlInput>=2) then
  begin
    with datafile0.channel(VSControlInput-1) do
    begin
      min:=Tfreq*1.5/1000 ;
      max:=Tfreq*2.5/1000;

      for i:=Istart to Iend-1 do
      if (Yvalue[i+1]-Yvalue[i]<min) or (Yvalue[i+1]-Yvalue[i]>max)
        then errorList.add(pointer(i));
    end;
  end
  else
  begin
    setSyncCont;

    nbVoieAcq1:=AcqInf.nbVoieAcq;
    nbpt0:=nbAg0*nbvoieAcq1;


    tnom:=round(2*Tfreq/acqInf.periodeParVoie/1000);
    minInt:=tnom - tnom div 3;
    maxInt:=tnom + tnom div 3;
    InhibDelay:= tnom div 3;

    if FmultiMainBuf
      then Von2:=MultiCyberTagBuf.getSmall(0) and BitCont<>0
      else Von2:= (mainBuf^[VoieCont] and BitCont<>0);
    if Von2 then t1:=0 else t1:=-tnom;

    cnt:=0;
    for i:=1 to acqInf.Qnbpt-1 do
    begin
      Von1:=Von2;

      if FmultiMainBuf
        then Von2:=MultiCyberTagBuf.getSmall(i) and BitCont<>0
        else Von2:= (mainBuf^[(i*nbvoieAcq1+voieCont) mod nbpt0] and BitCont<>0) ;

      if Von2 and not Von1 and (i-t1>InhibDelay) then
        begin
          if (i-t1<minInt) or (i-t1>maxInt)
            then errorList.add(pointer(i));
          t1:=i;
          inc(cnt);
        end;
    end;
  end;

end;

procedure TFXcontrol.visualobject1Click(Sender: TObject);
var
  p:typeUO;
begin
  p:= nouvelObjet(1);
  if p<>nil  then
    begin
      updateList;
      ChangeSelection(p);
    end;
end;

procedure TFXcontrol.stimulus1Click(Sender: TObject);
var
  p:typeUO;
begin
  p:= nouvelObjet(2);
  if p<>nil then
    begin
      updateList;
      ChangeSelection(p);
    end;
end;

procedure TFXcontrol.BdestroyClick(Sender: TObject);
begin
  updateList;

  ob.free;
  mainObjList.supprime(ob);

  ob:=nil;
  st0:='';
  updateList;
end;

procedure TFXcontrol.SpeedStimClick(Sender: TObject);
begin
  affStim:=speedStim.down;
end;

procedure TFXcontrol.SpeedControlClick(Sender: TObject);
begin
  AffControl:=speedControl.down;
end;

procedure TFXcontrol.System1Click(Sender: TObject);
begin
  VisualSys.execution;
end;

procedure TFXcontrol.ShutDown1Click(Sender: TObject);
begin
  DXscreen.Finalize;
  //DXscreen.IDX9:=nil;  //Test
  hide;
  VisualStimOpen:=false;
end;


procedure TFXcontrol.Activestimuli1Click(Sender: TObject);
begin
  getActiveStim.execution;
end;

procedure TFXcontrol.clearScreen;
var
  i:integer;
begin
  with HKpaint do
  for i:=0 to count-1 do
    TypeUO(items[i]).FlagonScreen:=false;
  paintScreen;
  paintScreen;
  paintScreen;
end;

procedure TFXcontrol.Clear1Click(Sender: TObject);
begin
  clearScreen;
end;

procedure TFXcontrol.Displayall1Click(Sender: TObject);
var
  i:integer;
begin
  with HKpaint do
  for i:=0 to count-1 do
    TypeUO(items[i]).FlagonScreen:=true;
  paintScreen;
  paintScreen;
  paintScreen;
end;


procedure TFXcontrol.Clear2Click(Sender: TObject);
var
  i:integer;
begin
  with HKpaint do
  for i:=0 to count-1 do
    TypeUO(items[i]).FlagOnControl:=false;
  PaintControl;
end;

procedure TFXcontrol.Displayall2Click(Sender: TObject);
var
  i:integer;
begin
  with HKpaint do
  for i:=0 to count-1 do
    TypeUO(items[i]).FlagOnControl:=true;
  PaintControl;
end;


procedure TFXcontrol.SpeedTrack1Click(Sender: TObject);
begin
  TracksON[1]:=speedTrack1.Down ;
end;

procedure TFXcontrol.SpeedTrack2Click(Sender: TObject);
begin
  TracksON[2]:=speedTrack2.Down ;
end;

procedure TFXcontrol.SpeedRF1Click(Sender: TObject);
begin
  RFsys[1].onControl:=SpeedRF1.down;
end;

procedure TFXcontrol.SpeedACClick(Sender: TObject);
begin
  ACleft.onControl:=SpeedAC.down;
  ACright.onControl:=SpeedAC.down;
end;

procedure TFXcontrol.BfrontClick(Sender: TObject);
begin
  if assigned(ob) and (HKpaint.count>0) then
  begin
    with HKpaint do move(indexof(ob),count-1);
    PaintControl;
    paintScreen;
  end;
end;

procedure TFXcontrol.BbackClick(Sender: TObject);
begin
  if assigned(ob) and (HKpaint.count>0) then
  begin
    with HKpaint do move(indexof(ob),0);
    PaintControl;
    paintScreen;
  end;
end;

procedure TFXcontrol.setTracksON(n:integer;b:boolean);
begin
  FtracksON[n]:=b;
  if n=1 then
    begin
      speedTrack1.Down:=b;
      Showtracks1.checked:=b;
    end
  else
    begin
      speedTrack2.Down:=b;
      Showtracks21.checked:=b;
    end;

  PaintControl;
end;

function TFXcontrol.getTracksON(n:integer):boolean;
begin
  result:=FtracksON[n];
end;

procedure TFXcontrol.affNumSeq(num:integer);
begin
  PanelSeqStim.Caption:=Istr(num);
  PanelSeqStim.update;
end;


procedure TFXcontrol.UpdateRightPanel(Sender: TObject);
begin
  if assigned(inform) then updateAllCtrl(inform);
end;


procedure TFXcontrol.Showtracks1Click(Sender: TObject);
begin
  TracksON[1]:= not TracksON[1];
end;

procedure TFXcontrol.Showtracks21Click(Sender: TObject);
begin
  TracksON[2]:= not TracksON[2];
end;


procedure TFXcontrol.cleartracks1Click(Sender: TObject);
begin
  stmTrack[1].clear;
  PaintControl;
end;

procedure TFXcontrol.Cleartracks21Click(Sender: TObject);
begin
  stmTrack[2].clear;
  PaintControl;
end;


procedure TFXcontrol.ActivateDX(sender:Tobject);
begin

  FlagActivate:=true;
  //DXscreen.Show;
  //DXscreen.hide;
  exit;

  if VisualStimOpen and assigned(DXscreen) then
  begin
    //DXscreen.initDX9;                  //Test
    //DXscreen.PaintProc:=PaintScreen;   //Test

    initialiseDXscreen;
  end;
end;

procedure TFXcontrol.DeActivateDX(sender:Tobject);
begin

  FlagActivate:= false;
  exit;

  if assigned(DXscreen) then
  begin
    DXscreen.Finalize;
    //DXscreen.IDX9:=nil; //Test
  end;
end;

function TFXcontrol.selectedObject:typeUO;
begin
  result:=ob;
end;


procedure TFXcontrol.Redraw;
var
  df:TdataFile;
  f:TStream;
  posf:int64;
  i,num1,num2:integer;
begin
  df:=dacDataFile;
  f:=df.fileStream;
  if not assigned(df.fileDesc) or not assigned(f)  then exit;

  if DrawClear then
    begin
      stmTrack[1].clear;
      stmTrack[2].clear;
      PaintControl;
    end;

  TRY
    num1:=DrawFirst;
    if (num1<1) then num1:=1;
    if (num1>df.EpCount) then num1:=df.EpCount;
    num2:=DrawLast;
    if (num2<1) then num2:=1;
    if (num2>df.EpCount) then num2:=df.EpCount;

    i:=num1;
    repeat
      df.setEpNum(i);
      posf:=df.getVSposition;
      if posf>0 then
        begin
          f.Position:=posf;
          listeStim.loadFromStream(f);
          listeStim.pushGlobals;
          listeStim.SetGlobals;
          try
            stimulerSeq1(false,false,true,true);
          finally
            listeStim.popGlobals;
            listeStim.FreeAndClear;
          end;

        end;
      inc(i);
    until(i>num2) or stopStim;

  Finally

  end;


  PaintControl;
  PaintScreen;
end;


procedure TFXcontrol.Replay;
var
  f:TStream;
  desc:TelphyDescriptor;
  posf:int64;
  i,num1,num2:integer;
begin
  if not FileExists(repFileName) then
    begin
      messageCentral('File not found');
      exit;
    end;

  desc:=TelphyDescriptor.create;

  TRY
    if desc.init(repFileName) then
      begin
        f:=desc.FileStream;
        num1:=repFirst;
        if (num1<1) then num1:=1;
        if (num1>desc.nbSeqDat) then num1:=desc.nbSeqDat;
        num2:=repLast;
        if (num2<1) then num2:=1;
        if (num2>desc.nbSeqDat) then num2:=desc.nbSeqDat;

        i:=num1;
        repeat
          posf:=desc.getVSposition(i);
          if posf>0 then
            begin
              f.Position:=posf;
              listeStim.loadFromStream(f);
              listeStim.pushGlobals;
              listeStim.SetGlobals;
              try
                stimulerSeq1(true,true,false,true);
              finally
                listeStim.popGlobals;
                listeStim.FreeAndClear;
              end;
            end;
          inc(i);
        until(i>num2) or stopStim;
      end;
  FINALLY
    desc.free;
    closeData;
  END;

  PaintControl;
  PaintScreen;
end;

procedure TFXcontrol.Replay1Click(Sender: TObject);
begin
  with ReplayFile do
  begin
    init(self);
    if showModal=mrOK then
      begin
        updateAllVar(replayFile);
        Replay;
      end;
  end;
end;



procedure TFXcontrol.DisableStims;
var
  i:integer;
begin
  with HKpaint do
  for i:=0 to count-1 do
    if TypeUO(items[i]) is Tstim then Tstim(items[i]).active:=false;
end;

procedure TFXcontrol.Parameters1Click(Sender: TObject);
begin
  acqStimParam.execution(self);
end;

procedure TFXcontrol.Acquisition1Click(Sender: TObject);
begin
  Open1.checked:=Fopen;
  Append1.checked:=Fappend;
end;


procedure TFXcontrol.Open1Click(Sender: TObject);
begin
  if not Fopen
    then Fopen:=acquisition.openFile                               
    else Fopen:=false;
end;


procedure TFXcontrol.Append1Click(Sender: TObject);
begin
  if not Fappend
    then AppendDF
    else Fappend:=false;
end;

procedure TFXcontrol.Redraw1Click(Sender: TObject);
begin
  with RedrawFile do
  begin
    init(self);
    if showModal=mrOK then
      begin
        updateAllVar(reDrawFile);
        Redraw;
      end;
  end;

end;


procedure TFXcontrol.SaveImageClick(Sender: TObject);
var
  bm:Tdib;
  i,cnt,rapp:integer;
  OldScreenHeight: float;
  ext:string;
  palette:hPalette;
  w,h:integer;
  mat1,mat2: Tmatrix;
const
  stF:Ansistring='';
  widthBMP: integer=0;
  HeightBMP: integer=0;

begin
  if WidthBMP=0 then
  begin
    WidthBMP:=SSwidth div 4;
    HeightBMP:=SSHeight div 4;
  end;

  case TmenuItem(sender).Tag of
    1: ext:='bmp';
    2: ext:='jpg';
    3: ext:='png';
  end;

  stF:=ChangeFileExt(stF,'.'+ext);

  if createAVIform.execute('Save as '+Fmaj(ext)+' file',ext,stf,QualityJpeg,RedFactor) then
  begin
    if RedFactor<1 then RedFactor:=1;

    w:=SSwidth div redFactor;
    h:=SSheight div RedFactor;

    try

    bm:=TbitmapEx.create;
    bm.ColorTable:=MonoColorTable(true);
    bm.UpdatePalette;
    bm.SetSize(w, h, 8);

    mat1:=Tmatrix.create(g_single,0,SSwidth-1,0,SSheight-1);
    mat2:=Tmatrix.create(g_single,0,w-1,0,h-1);

    DXscreen.getMatrix(mat1,false);
    ReductionImage(mat1,mat2,Redfactor);

    mat2.MatToDib(bm,true);
    if (stF<>'') then saveDIBToFile(bm,stF);

    finally
    bm.free;
    mat1.Free;
    mat2.Free;

    end;
  end;
end;

procedure TFXcontrol.SetSyncLine(Fsync,Fcontrol:boolean);
begin
  FtopSync:=Fsync;
  FtopControle:=Fcontrol;
  UpdateStimScreen;
end;

procedure TFXcontrol.Displaysync1Click(Sender: TObject);
var
  Flagfin: boolean;
  msg: Tmsg;
begin
  SetSpotParams;
  setSyncCont;

  Flagfin:=false;
  repeat
    DXscreen.fillBK(devColBK);
    PaintTopSync(true);
    PaintTopControl(true);
    DXscreen.flip(true);

    while peekMessage(Msg,0,wm_keydown,wm_keydown,pm_remove) do
      if msg.wparam = vk_escape then Flagfin:=true;

    while peekMessage(Msg,0,wm_paint,wm_paint,pm_remove) do dispatchMessage(Msg);

  until flagFin;
  DX9end;
end;


procedure TFXcontrol.DXDraw1Initializing(Sender: TObject);
begin
;  {with dxDraw1 do driver:=drivers[1].GUID;}
end;

procedure TFXcontrol.BstopClick(Sender: TObject);
begin
  StopStim:=true;
end;

procedure TFXcontrol.CompEnter(Sender: TObject);
begin
  if sender is TeditNum then TeditNum(sender).UpdateCtrl;
end;


procedure TFXcontrol.CreateAVI1Click(Sender: TObject);
begin
  if createAVIform.execute('Create avi file','avi',stfAvi,qualityJpeg,RedFactor)
    then BuildAvi(false);
end;

procedure TFXcontrol.CreateTextureFile1Click(Sender: TObject);
begin
  if createAVIform.execute('Create Texture File','tex', stfTex,SkipFactor,RedFactor)
    then BuildAvi(true);

end;



procedure TFXcontrol.PaintBox0Paint(Sender: TObject);
begin
  paintControl;
end;


procedure TFXcontrol.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if assigned(inform)
    then inform.VKreturn;
end;

procedure TFXcontrol.SaveasBMP2Click(Sender: TObject);
const
  stF:AnsiString='*.bmp';
var
  OldOb:typeUO;
begin
  stF:=GchooseFile('Save Control Screen as BMP',stF);
  if stF<>'' then
  begin
    OldOb:=ob;
    ob:=nil;
    paintControlSurface;
    DXcontrol.saveToFile(stF);
    ob:=oldOb;
  end;
end;

procedure TFXcontrol.Copytoclipboard1Click(Sender: TObject);
{$IFDEF FPC}
begin

end;
{$ELSE}
const
  stf:AnsiString='';
var
  meta:TMetaFile;
  metaCanvas:TMetafileCanvas;
  w,h:integer;
begin
  PRmetaFile:=true;

  Meta:= TMetafile.Create;
  try
    w:=printer.pageWidth;
    h:=roundL (w*0.75{ Dxcontrol.height/Dxcontrol.width});

    meta.width:=w;
    meta.height:=h;
    metaCanvas:=TMetafileCanvas.Create(Meta, printer.handle);

    PRprinting:=true;

    PRfactor:=w/DxControl.width;
    if PRautoSymb then PRsymbMag:=PRfactor;

    if (PRsymbMag<1) or (PRsymbMag>20) then PRsymbMag:=1;

    if PRautoFont then PRfontmag:=PRfactor;
    if (PRfontMag<0.2) or (PRfontMag>50) then PRfontMag:=1;

  except
    w:=DxControl.width;
    h:=DxControl.height;
    meta.width:=w;
    meta.height:=h;
    metaCanvas:=TMetafileCanvas.Create(Meta, DxControl.canvas.handle);

    PRprinting:=false;
  end;

    installSSprinter(w,h);
  try

    initGraphic(metaCanvas,0,0,w,h);
    PaintControlSurface1;


  finally
    metaCanvas.Free;
    PRprinting:=false;
    PRmetaFile:=false;

    resetSSprinter;
  end;

  meta.enhanced:=true;

  if stf='' then clipboard.assign(meta) else meta.saveToFile(stF);
  meta.free;
end;
{$ENDIF}

procedure TFXcontrol.saveEvt(Imax:integer);
begin
  acquisition.SaveEvt(Imax);
end;


procedure TFXcontrol.traiterEvt(i,v: integer);
begin
  acquisition.TraiterEvt(i,v);

end;


procedure TFXcontrol.setSyncCont;
begin
  case VSSyncInput of
    0,1: begin
           voieSync:=acqInf.nbVoieAcq-1;
           BitSync:=1 shl VSSyncInput;
         end;
    else begin
           voieSync:=VSSyncInput-2;
           BitSync:=1;
         end;
  end;

  case VSControlInput of
    0,1: begin
           voieCont:=acqInf.nbVoieAcq-1;
           BitCont:=1 shl VSControlInput;
         end;
    else begin
           voieCont:=VSControlInput-2;
           BitCont:=1;
         end;
  end;
end;

procedure TFXcontrol.SBG0ScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  if not FlagUpdateG0 then
  begin
    Gdisp:=x;
    {CalculNewWorld;}
    invalidate;
  end;
end;

procedure TFXcontrol.setG0ctrl;
begin
  FlagUpdateG0:=true;
  SBG0.setParams(GDisp,1,5);
  LG0.Caption:='G0='+Estr(GDisp,3);
  FlagUpdateG0:=false;
end;

procedure TFXcontrol.BautoG0Click(Sender: TObject);
begin
  GDisp:=1;
  {CalculNewWorld;}
  invalidate;
end;

procedure TFXcontrol.BcadrerClick(Sender: TObject);
begin
  xDisp:=0;
  yDisp:=0;
  {CalculNewWorld;}
  invalidate;
end;

procedure TFXcontrol.scrollbarHScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  xDisp:=x;
  {CalculNewWorld;}
  invalidate;
end;

procedure TFXcontrol.scrollbarVScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  yDisp:=x;
  {CalculNewWorld;}
  invalidate;
end;

procedure TFXcontrol.UpdateControls;
begin
  if not assigned(scrollbarV) then exit;

  flagUpdateG0:=true;
  scrollbarV.SetParams(yDisp,-paintbox0.height/2*Gdisp,paintbox0.height/2*Gdisp );
  scrollbarV.LargeChange:=10;

  scrollbarH.SetParams(xDisp,-paintbox0.width/2*Gdisp,paintbox0.width/2*Gdisp );
  scrollbarH.LargeChange:=10;
  flagUpdateG0:=false;

  setG0ctrl;
end;





procedure TFXcontrol.BitmapCorrection1Click(Sender: TObject);
begin
  BMcorrection.execute;
end;

procedure TFXcontrol.ShowErrorList1Click(Sender: TObject);
var
  ListGViewer: TListGViewer;
begin
  if not assigned(errorList) or (errorList.count=0) then exit;

   ListGViewer:=TListGViewer.create(nil);
   with ListGViewer do
   begin
     setdata('Error list', getErrorData,ErrorList.Count);
     showModal;
   end;
   ListGViewer.free;
end;


function TFXcontrol.getErrorData(n: integer): AnsiString;
begin
  if VSControlInput>=2
    then result:= 'i= '+Istr1( intG(errorList[n]),7)+'  x= ' + Estr1(datafile0.channel(VSControlInput-1).Yvalue[IntG(errorList[n])],10,3)
    else result:='i= '+Istr1( intG(errorList[n]),7)+'  x= '+Estr1(IntG(errorList[n])*Tbase,10,3);
end;

procedure TFXcontrol.FormActivate(Sender: TObject);
Const
  SSwidthA: integer=0;
  SSheightA: integer=0;
var
  w,h: integer;
begin
  if (SSwidthA<>SSwidth) or (SSheightA<>SSheight) then
  begin
    SSwidthA:= SSwidth;
    SSheightA:=SSheight;
    w:=width;
    h:=height;
    if calculateSize(w,h) then
    begin
      width:=w;
      height:=h;
    end;
  end;
end;






procedure TFXcontrol.ShowWarnings1Click(Sender: TObject);
var
  viewText:TviewText;
  i:integer;
begin
  viewText:=TviewText.create(nil);
  ViewText.caption:='Warning messages';

  ViewText.memo1.Text:=WarningList.Text;

  ViewText.showModal;
  ViewText.free;

end;

Initialization
AffDebug('Initialization FXctrl0',0);
{$IFDEF FPC}
{$I FXctrl0.lrs}
{$ENDIF}
end.


