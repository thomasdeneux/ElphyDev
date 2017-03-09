unit FXctrl0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows,  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDrawsG, ExtCtrls, StdCtrls, ComCtrls, Buttons, Menus, MMsystem,
  printers,clipBrd,

  DIBG,DirectXG,DXscr0,

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
  ippdefs,ipps,ippsovr,

  EvtAcq1,
  MesureRefreshTime,
  NIbrd1,
  stmDetector1;


{ Vtag1 recoit les tops Synchro = Entrée TAG correspond à RED       ===>bit0
  Vtag2 recoit les tops contrôle = Entrée START correspond à BLUE   ===>bit1

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
                 rect1: Trect;
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
    procedure SaveasBMP1Click(Sender: TObject);
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
    procedure Test1Click(Sender: TObject);
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



    DevColBlue, DevColRed, DevColBlack, DevColWhite: integer;

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
    procedure CalculateSize(var NewWidth, NewHeight: Integer);

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

    onStartAnimate1,onStartAnimate2:Tpg2Event;

    FSaveObjects:boolean;
    FStopOnClick:boolean;



    TestSampleInt:double;
    TestAcqDuration:double;

    Detector:Tdetector;

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
    procedure stimulerSeq1(AcqAuto,saveAuto,Fredraw,Finitboard:boolean);
    procedure StimulerSeq(Finitboard:boolean);

    procedure BuildAvi(stf:AnsiString);

    function getDotProd(i0,j0:integer;Smask:Tmatrix):single;
    Procedure ReducStim(Smask:Tmatrix;Xpos,Ypos:Tvector;Nx,Ny:integer;Mlist:TmatList);

    procedure MesureRefreshTime1;

    procedure InitAcqParams;
    procedure startAcq(SaveAuto,Finitboard:boolean);
    procedure startRedraw;
    procedure EndRedraw;
    procedure EndAcq(wholeData:boolean);
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
    procedure getBm(bm:TbitmapEx);
    procedure clearScreen;
    procedure setDevColors;

    procedure InitialiseDXscreen0;
    procedure InitialiseDXscreen1;
    procedure InitialiseDXscreen;
    procedure invalidate;override;
  end;



implementation

uses mdac,stmVS0,acqStmPrm;


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


{******************************* TFXcontrol **********************************}

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
    CalculateControlConst;
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


procedure TFXcontrol.CalculateSize(var NewWidth, NewHeight: Integer);
var
  h,l,capSize:integer;
begin
  capSize:=height-clientHeight;
  H:=NewHeight-PanelTop.height-PanelBottom.height-capSize;
  L:=NewWidth-PanelRight.width;

  if L>SSwidth*h div SSheight
    then NewWidth:=SSwidth*H div SSheight+panelRight.width
    else NewHeight:=SSheight*L div SSwidth +PanelTop.height+PanelBottom.height+capSize;
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


  DXscreenB:=TDXscreenB.create(self);
  with DXscreenB.DXDraw0.Display do
  begin
    i:=indexof(SSwidth,SSheight,SSbitCount,SSrefreshRate);
    if i>=0 then
      begin
        width:=SSwidth;
        height:=SSheight;
        bitCount:=SSbitCount;
        refreshRate:=SSrefreshRate;
      end
    else
      begin
        i:=indexof(SSwidth,SSheight,SSbitCount,0);
        if i>=0 then
          begin
            width:=SSwidth;
            height:=SSheight;
            bitCount:=SSbitCount;
          end;
      end;

  end;
  DXscreenB.finalizeG:=updateStimScreen;

  application.onActivate:=ActivateDX;
  application.onDeActivate:=DeActivateDX;

  errorList:=Tlist.create;
  Tbase:=0.125;

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
begin

  with DXscreen do
  case VSsyncMode of
    0: if w then surface.fillRect(rect(0,0,Display.width div 2-1,1),devColRed);
    1: if w then
       begin
         with VSsyncRect[1+ ord(syncRectOrder)] do surface.fillRect(Rect1,255);
         with VSsyncRect[1+ ord(not syncRectOrder)] do surface.fillRect(Rect1,devColBlack);
         syncRectOrder:=not syncRectOrder;
       end
       else
       begin
         with VSsyncRect[1] do surface.fillRect(Rect1,devColBlack);
         with VSsyncRect[2] do surface.fillRect(Rect1,devColBlack);
       end;
  end;
end;

procedure TFXcontrol.PaintTopControl(w:boolean);
begin
  with DXscreen do
  case VSsyncMode of
    0: if w then surface.fillRect(rect(Display.width div 2,0,Display.width-1,1),devColBlue);
    1: if w then
       begin
          if ContRectOrder then
          begin
            with VScontRect[1] do surface.fillRect(Rect1,255);
            with VScontRect[2] do surface.fillRect(Rect1,devColBlack);
          end
          else
          begin
            with VScontRect[2] do surface.fillRect(Rect1,255);
            with VScontRect[1] do surface.fillRect(Rect1,devColBlack);
          end;
         {
         with VScontRect[1+ ord(ContRectOrder)] do surface.fillRect(Rect1,devCol);
         with VScontRect[1+ ord(not ContRectOrder)] do surface.fillRect(Rect1,devColBlack);
         }
         ContRectOrder:= not ContRectOrder;
       end
       else
       begin
         with VScontRect[1] do surface.fillRect(Rect1,devColBlack);
         with VScontRect[2] do surface.fillRect(Rect1,devColBlack);
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
    VSsyncRect[i].rect1.left:=     degToPix(x - VSspotSize/2);
    VSsyncRect[i].rect1.right:=    degToPix(x + VSspotSize/2);
    VSsyncRect[i].rect1.top:=      degToPix(y - VSspotSize/2);
    VSsyncRect[i].rect1.bottom:=   degToPix(y + VSspotSize/2);

    VSsyncRect[i].devcol:= devColWhite; //syspal.lumIndex(lum);
  end;

  for i:=1 to 2 do
  with VScontSpot[i] do
  begin
    VScontRect[i].rect1.left:=    degToPix(x - VSspotSize/2);
    VScontRect[i].rect1.right:=   degToPix(x + VSspotSize/2);
    VScontRect[i].rect1.top:=     degToPix(y - VSspotSize/2);
    VScontRect[i].rect1.bottom:=  degToPix(y + VSspotSize/2);

    VScontRect[i].devcol:= devColWhite; //syspal.lumIndex(lum);
  end;

end;


procedure TFXcontrol.paintScreenSurface;
var
  i:integer;
begin
  if not assigned(DXscreen) or not DXscreen.canDraw then exit;

  with DXscreen do
  begin
    surface.fill(devColBK);

    {for i:=0 to 255 do surface.fillRect(rect(i*2-1,0,i*2+3,SSheight), i);}
    {Essai de Clipper
     DXscreenB.DXdraw0.surface.Clipper:=DXscreenB.DXdraw0.clipper;
    }

    if assigned(DXmainMask) then
      DXmainMask.Fill(devcolBK);


    for i:=0 to HKpaint.count-1 do
      with typeUO(HKpaint.items[i]) do
      if onScreen then
        begin
          afficheS;
          if AnimationON and not isOnScr then FlagOnScreen:=false;
          {En animation, on remet le flag à false systématiquement}
        end;

    if assigned(DXmainMask) then
    begin
      DXmainMask.transparentColor:=0;
      surface.draw(0,0,DXmainMask,true);
    end;
    {Essai de Clipper
    DXscreenB.DXdraw0.surface.Clipper:=nil;
    }
    PaintTopSync(FtopSync);


    PaintTopControl(FtopControle);


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
  TheLine:=rect(roundI(x1),roundI(y1),roundI(x2),roundI(y2));
  Fline:=true;
end;

procedure TFXcontrol.FormShow(Sender: TObject);
begin
  speedStim.down:=affStim;
  speedControl.down:=affControl;

  if not assigned(DXscreen) or not DXscreen.Initialized
    then InitialiseDXscreen;
  if DXscreenB.inMemory then DXscreenB.Show;

  RFsys[1].OnScreen:=not RFsys[1].OnScreen;
  RFsys[1].OnScreen:=not RFsys[1].OnScreen;

end;


procedure TFXcontrol.InitialiseDXscreen0;
const
  nx=40;
  ny=30;
  dd=10;
var
  rectClip:array[0..nx*ny-1] of Trect;
  i,j:integer;

begin
  if TdirectDraw.Drivers.Count<=2 then exit;

  with DXscreenB.DXdraw0 do
  begin
    if initialized then Finalize;

    Display.Width:=SSwidth;
    Display.height:=SSheight;
    Display.refreshRate:=SSrefreshRate;
    Display.bitCount:=SSbitCount;

    SysPaletteNumber:=MonoPaletteNumber*ord(not visualStim.FXcontrol.FacqInterface);
    if Display.bitCount=8 then
        colorTable:=MonoColorTable(VSsyncMode=1);
    calculateScreenConst;



    try
      Initialize;
    except
      SSwidth:=640;
      SSheight:=480;
      SSrefreshRate:=0;
      SSbitCount:=8;

      Display.Width:=SSwidth;
      Display.height:=SSheight;
      Display.refreshRate:=SSrefreshRate;
      Display.bitCount:=SSbitCount;

      calculateScreenConst;
      try
        Initialize;
      except
      end;
      messageCentral('Unable to apply screen parameters');
      FalwaysActivate:=false;
    end;

    if initialized then
    begin
      secondScreen:=true;

      {Essai de Clipper
      for i:=0 to nx-1 do
      for j:=0 to ny-1 do
      with rectClip[i+j*nx] do
      begin
        left:=i*dd*2;
        right:=left+dd;
        top:=j*dd*2;
        bottom:=top+dd;
      end;

      clipper.SetClipRects(rectClip);
      }
      DXscreen:=DXscreenB.DXdraw0;
      HKpaintScreen:=paintScreen;
      syspal.update;
    end;
  end;
end;

procedure TFXcontrol.InitialiseDXscreen1;
begin
  DXscreenB.inMemory:=true;
  with DXscreenB.DXdraw0 do
  begin
    if initialized then Finalize;

    Display.Width:=SSwidth;
    Display.height:=SSheight;
    Display.refreshRate:=0;
    Display.bitCount:=SSbitCount;

    SysPaletteNumber:=MonoPaletteNumber*ord(not visualStim.FXcontrol.FacqInterface);
    if Display.bitCount=8 then
        colorTable:=MonoColorTable(VSsyncMode=1);
    calculateScreenConst;

    options:=options-[doFullScreen, doCenter] ;

    try
      Initialize;
    except
      SSwidth:=640;
      SSheight:=480;
      SSrefreshRate:=0;
      SSbitCount:=8;

      Display.Width:=SSwidth;
      Display.height:=SSheight;
      Display.refreshRate:=SSrefreshRate;
      Display.bitCount:=SSbitCount;

      calculateScreenConst;
      try
        Initialize;
      except
      end;
      messageCentral('Unable to apply screen parameters');
      FalwaysActivate:=false;
    end;

    if initialized then
    begin
      secondScreen:=false;

      DXscreen:=DXscreenB.DXdraw0;
      HKpaintScreen:=paintScreen;
      syspal.update;
      visible:=true;
    end;
  end;
end;


procedure TFXcontrol.InitialiseDXscreen;
begin
  InitialiseDXscreen0;
  if not DXscreenB.DXdraw0.initialized
    then InitialiseDXscreen1;
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
  if assigned(DXscreen) then
  begin
    devColBlue:=getDevColor(DXscreen.surface,clblue);
    devColRed:=getDevColor(DXscreen.surface,clred);

    {devColBK:=getDevColor(DXscreen.surface,rgb(0,syspal.BKcolIndex,0));}
    devColBK:=syspal.BKcolIndex;
    devColBlack:=getDevColor(DXscreen.surface,clBlack);
    devColWhite:=getDevColor(DXscreen.surface,clWhite);
  end;

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
  k:integer;
begin
  if affControl and (timeProcess mod 5=0)  then PaintControl;

  paintScreen;

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

    if assigned(DXscreen) and not DXscreenB.inMemory and (VSNoTrigger=false)
      then ModeSynchro:=MSNumPlus
      else ModeSynchro:=MSimmediat;

    if DXscreenB.inMemory then DXscreenB.Show;
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

procedure TFXcontrol.StartAcq(SaveAuto,Finitboard:boolean);
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


  acquisition.startAcqVS(FdisplayData,saveAuto and assigned(facq),Finitboard);
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
  Fdetect:boolean;
begin
  Ftrack:=assigned(trackObvis);
  Fdetect:= assigned(detector);

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
        asm
          mov  ax,x
          mov  cx,shiftDigi
          sar  ax,cl
          mov  x,ax
        end;


        trame:=round(i*periodeG/Xframe);

        for tr:=1 to 2 do
          with stmTrack[tr] do
          if voie=j then traiter(trame,x);
      end;

      if (QKSU[j+1]=0) then traiterEvt(i,j);
    end;

  if Fdetect then Detector.Update(AcqIndex);
  DernierTraite:=AcqIndex;
end;


procedure TFXcontrol.traiterDataMulti;
var
  i,j,k:integer;
  x:smallint;
  trame:integer;

  Ftrack:boolean;
  Fdetect:boolean;
begin
  Ftrack:=assigned(trackObvis);
  Fdetect:= assigned(detector);

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

  if Fdetect then Detector.Update(AcqIndex);
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

procedure TFXcontrol.stimulerSeq1(AcqAuto,saveAuto,Fredraw,Finitboard:boolean);
       { auparavant, il faut construire listeStim }
var
  i:integer;
  Msg: TMsg;
  flagFinExe:boolean;
  st:AnsiString;
  pp:Tpoint;

  tt:array[1..10] of integer;
  FlagNoTrigger:boolean;
begin
  setSpotParams;
  {On repère tous les objets déjà affichés.
   Ces objets resteront affichés pendant l'animation.
  }
  Fdigi:=assigned(board) and (board.dataFormat in [Fdigi1200,Fdigi1322]);
  VisualObjectIsMask:=false;

  with HKpaint do
  for i:=0 to count-1 do
  with TypeUO(items[i]) do
  begin
    isOnScr:=onScreen;
    isOnCtrl:=onControl;
    if (TypeUO(items[i]) is Tresizable) and OnScreen and Tresizable(items[i]).Fmask then VisualObjectIsMask:=true;
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

  if VisualObjectIsMask then createMainMask;

  FlagAcq:=AcqAuto and FAcqInterface and assigned(board);

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

  with OnStartAnimate1 do
  if valid then pg.executerProcedure(ad);

  if FlagAcq then
  begin
    startAcq(saveAuto,Finitboard);      {lancer l'acquisition}
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

  datafile0.FreeFileStream;
  FlagNoTrigger:=false;


  repeat
    FtopControle:= (TimeProcess=-1) or (timeProcess mod 2=1);

    if FlagAcq then AcqIndex:=threadInt.ExecuteLoop
    else
    if Fredraw then AcqIndex:=RedrawLoop;

    FtopSync:=(timeProcess=-1) ;

    executeProcess;

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

    while peekMessage(Msg,Handle,0,0,pm_remove) and (msg.message<>wm_paint) do
    begin
      case msg.message of                         { clic dans controlScreen }
        wm_lbuttonDown,wm_lbuttonUp:
          begin
            if FStopOnClick then FinImmediate:=true;
          end;
      end;
    end;

    while peekMessage(Msg,multigraph0.formG.Handle,0,0,pm_remove) and (msg.message<>wm_paint) do
    begin
      affDebug('Message='+Istr(Msg.message)+' '+Istr(msg.wParam)+' '+Istr(msg.lParam),11);

      case msg.message of
        wm_lbuttonDown,wm_lbuttonUp:
          begin
            pp:= screenToClient(msg.pt);
            if pp.y<25 then dispatchMessage(msg);
          end;
      end;
    end;
    {
    while peekMessage(Msg, 0,0,0,pm_remove) do  // Test purpose only
    begin
      translateMessage(msg);
      dispatchMessage(msg);
    end;
    }
  until (timeProcess>=FrameCount) or finImmediate;

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
  freeMainMask;

  {messageCentral('TT='+Istr(tt[2]-tt[1]));}
end;

procedure TFXcontrol.BuildAvi(stf:AnsiString);
const
  FPS=30;
var
  avi:TsimpleAvi;
  bm:TbitmapEx;
  i,cnt,rapp:integer;

begin

  VisualObjectIsMask:=false;
  with HKpaint do
  for i:=0 to count-1 do
  with TypeUO(items[i]) do
  begin
    isOnScr:=onScreen;
    isOnCtrl:=onControl;
    {if OnScreen then true;}
  end;


  listeStim.build;

  bm:=TbitmapEx.create;
  bm.ColorTable:=MonoColorTable(false);
  bm.UpdatePalette;
  getbm(bm);

  resetProcess;

  listeStim.installe;
  if VisualObjectIsMask then createMainMask;


  installeProcess(paintScreenNoWait);

  animationON:=true;

  FtopSync:=false;
  FtopControle:=false;
  paintScreen;
  paintScreen;

  rapp:=round( 1/FPS/Xframe);
  if rapp<=0 then rapp:=1;

  avi:=TsimpleAvi.create(stf,bm,FPS);
  cnt:=0;
  repeat
    executeProcess;
    getbm(bm);

    if cnt mod rapp=0
      then avi.save(bm);
    inc(cnt);
  until (timeProcess>=FrameCount) or TestEscape;

  clearScreen;
  getbm(bm);
  avi.save(bm);

  avi.free;

  animationON:=false;

  listeStim.desinstalle;

  FtopSync:=false;
  FtopControle:=false;
  PaintPage;

  Fsim:=false;
  listeStim.Clear;
  freeMainMask;

end;

function TFXcontrol.getDotProd(i0,j0:integer;Smask:Tmatrix):single;
var
  Hmask,Lmask,HLmask:integer;
  p:PtabOctet;
  ptemp:ptabSingle;
  i,j,k:integer;
  LumG,indexBK:single;
  pmask:PtabSingle;
  dd:double;

begin
  LumG:=syspal.GammaGain;
  indexBK:=syspal.BKcolIndex;
  pmask:=Smask.tb;
  Hmask:=Smask.Icount;
  Lmask:=Smask.Jcount;
  HLmask:=Hmask*Lmask;

  getmem(ptemp,Hmask*Lmask*4);

  for j:=0 to Hmask-1 do
  begin
    p:=BMsimulation.scanline[j0+j];
    ippsConvert(Pbyte(@p^[i0]),Psingle(@ptemp^[Lmask*j]),Lmask);
  end;

  if syspal.FusegammaRamp then
  begin
    ippsAddC(-indexBK,  Psingle(ptemp), HLmask);
    ippsMulC(LumG,  Psingle(ptemp), HLmask);
  end
  else
  begin
    for i:=0 to HLmask-1 do
       pTemp^[i]:=syspal.indexToLum(round(pTemp^[i]))-syspal.BKlum;
  end;


  ippsDotProd(Psingle(pTemp),Psingle(pmask),HLmask,Pdouble(@dd));
  result:=dd;

  freemem(ptemp);
end;

{
procedure saveIm(stF:AnsiString);
begin
  bm.setSize(BMsimulation.Width,BMsimulation.height,8);
  with BMsimulation do
  begin
    try
      bm.Canvas.CopyRect(Rect(0, 0, bm.Width, bm.Height), Canvas, ClientRect);
    finally
      canvas.release;
    end;
  end;
  bm.Compress;
  bm.saveToFile(stF);
end;
}


procedure TFXcontrol.ReducStim(Smask:Tmatrix;Xpos,Ypos:Tvector;Nx,Ny:integer;Mlist:TmatList);
var
  desc:TDDsurfaceDesc2;
  mask:Tmatrix;
  mat:Tmatrix;
  i,j,k:integer;
  bm:Tdib;
  nbPix:integer;

begin
  IPPSTest;

  if (DXscreen=nil) or not DXscreen.candraw then exit;

  bm:=TbitmapEx.create;
  bm.ColorTable:=MonoColorTable(false);
  bm.UpdatePalette;

  VisualObjectIsMask:=false;

  BMsimulation:=TdirectdrawSurface.create(DXscreen.DDraw);
  fillchar(desc,sizeof(desc),0);
  with desc do
  begin
    dwSize:=sizeof(desc);
    dwFlags:=DDSD_CAPS+DDSD_height+DDSD_width;
    ddsCaps.dwCaps:=DDSCAPS_offscreenPlain;
    dwWidth:=SSwidth;
    dwHeight:=SSheight  ;
  end;
  BMsimulation.createSurface(desc);
  FlagSimulation:=true;

  mat:=Tmatrix.create;
  mat.initTemp(1,Nx,1,Ny,g_single);

  listeStim.build;
  if VisualObjectIsMask then createMainMask;

  resetProcess;

  listeStim.installe;
  animationON:=true;

  FtopSync:=false;
  FtopControle:=false;

  nbPix:=0;
  with Smask do
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
  if Zvalue[i,j]<>0 then inc(nbPix);

  TRY
    repeat
      executeProcess;

      BMsimulation.fill(devColBK);

      for i:=0 to HKpaint.count-1 do
      with typeUO(HKpaint.items[i]) do
      if onScreen then
        begin
          afficheS;
          if AnimationON and not isOnScr then FlagonScreen:=false;
        end;

      {saveIm('c:\dac2\test'+Istr(timeProcess)+'.bmp');}
      with BMsimulation do
      begin
        try
        lock;

        k:=0;
        for i:=0 to Nx-1 do
        for j:=0 to Ny-1 do
        begin
          mat[i+1,j+1]:=getDotProd(Xpos.Jvalue[k],Ypos.Jvalue[k],Smask)/nbPix;
          inc(k);
        end;
        finally
          unlock;
        end;
      end;

      Mlist.addMatrix(mat);

    until (timeProcess>=FrameCount) or TestEscape;

  FINALLY
    animationON:=false;

    listeStim.desinstalle;

    FtopSync:=false;
    FtopControle:=false;

    Fsim:=false;
    listeStim.Clear;

    BMsimulation.free;
    FlagSimulation:=false;

    mat.free;
    bm.free;

    if SavedTfreq<>0 then
    begin
      Tfreq:=SavedTfreq;
      SavedTfreq:=0;
    end;


    IPPSend;
    freeMainMask;
  END;
end;


procedure TFXcontrol.StimulerSeq(Finitboard:boolean);
begin
  listeStim.build;

  stimulerSeq1(true,true,false,Finitboard);

  listeStim.clear;

  PaintControl;
  PaintScreen;
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

    if VSnoTrigger
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
    DXscreen.surface.fill(devColBK);

    inc(cnt);

    PaintTopSync(true);
    PaintTopControl(true);

    DXscreen.flip(true);

    //TNIboard(board).setDOStatic((cnt<10), (cnt<10));

    PanelStatusX.Caption:=Istr(AcqIndex);
    PanelStatusX.update;

    AcqIndex:=threadInt.ExecuteLoop;

//    TNIboard(board).setDOStatic(false,false);

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
  acquisition.fAcq:=facq;
  
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
    Acquisition.fAcq:=nil;
    facq:=nil;
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

  Acquisition.PrepElphyFile(false,Qnb);

  facq.reopen;
  facq.ecrirePreSeq;

  if FmultiMainBuf then
  with AcqInf do
  begin
    j:=0;
    setLength(bufS,Qnb*nbvoieAcq*2);
    for i:=0 to Qnb-1 do
    for k:=0 to nbVoieAcq-1 do
    begin
      if (QKSU[k+1]<>0) and (i  mod QKSU[k+1]=0)  then
      begin
        with MultimainBuf[k] do
          bufS[j]:=GetSmall(i div QKSU[k+1]);
        inc(j);
      end;
    end;
    facq.f.Write(bufS[0],j*2);
    setLength(bufS,0);
  end
  else
  If not FdownSampling then with acqInf do facq.f.Write(mainBuf^,Qnb*nbvoieAcq*2)
  else
  with acqInf do
  begin
    j:=0;
    setLength(bufS,Qnb*nbvoieAcq*2);
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
    end;
    facq.f.Write(bufS[0],j*2);
    setLength(bufS,0);
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
      facq.close;
      facq.free;
      facq:=nil;
      acquisition.fAcq:=nil;
    end;
end;


{ Appelé par un PG2 uniquement}
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

      if Von2 and not Von1 then
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
  if p<>nil then
  begin
    updateList;
    changeSelection(p);
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
    changeSelection(p);
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
  if not assigned(DXscreen) then exit;

  DXscreen.Initialize;

  if DXscreen.canDraw then
  with DXscreen do
  begin
    surface.fill(devColBK);

    flip(true);
  end;

end;

procedure TFXcontrol.DeActivateDX(sender:Tobject);
begin
{
  if not assigned(DXscreen) then exit;
  DXscreen.Finalize;
}
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
            stimulerSeq1(false,false,true,false);
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

procedure TFXcontrol.getBm(bm:TbitmapEx);
var
  i,j:integer;
begin
  bm.setSize(DXscreen.surface.Width,DXscreen.surface.height,8);
  with DXscreen.surface do
  begin
    try
      bm.Canvas.CopyRect(Rect(0, 0, bm.Width, bm.Height), Canvas, ClientRect);

    finally
      canvas.release;
    end;
  end;
  bm.Compress;
end;

procedure TFXcontrol.SaveasBMP1Click(Sender: TObject);
var
  bm:TbitmapEx;
  i,j:integer;
const
  stf:AnsiString='';
begin
  bm:=TbitmapEx.create;
  bm.ColorTable:=MonoColorTable(false);
  bm.UpdatePalette;
    getBM(bm);

  {
  bm.Width:=DXscreen.surface.Width;
  bm.height:=DXscreen.surface.height;
  with DXscreen.surface do
  begin
    try
    with canvas do
    begin
      for i:=0 to width-1 do
      for j:=0 to height-1 do
        begin
          bm.Canvas.pixels[i,j]:=DXscreen.surface.pixels[i,j]*256;
        end;
    end;

    finally
    canvas.release;
    end;
  end;
  }

  stF:=GchooseFile('Save BMP',stF);
  if stF<>'' then bm.saveToFile(stF);


end;

procedure TFXcontrol.SetSyncLine(Fsync,Fcontrol:boolean);
begin
  FtopSync:=Fsync;
  FtopControle:=Fcontrol;
  UpdateStimScreen;
end;

procedure TFXcontrol.Displaysync1Click(Sender: TObject);
begin
  setSyncLine(true,true);
end;


procedure TFXcontrol.DXDraw1Initializing(Sender: TObject);
begin
;  {with dxDraw1 do driver:=drivers[1].GUID;}
end;

procedure TFXcontrol.BstopClick(Sender: TObject);
begin
  StopStim:=true;
    {messageCentral(Istr(devcolRed)+'  '+Istr(devcolBlue));}
end;

procedure TFXcontrol.CompEnter(Sender: TObject);
begin
  if sender is TeditNum then TeditNum(sender).UpdateCtrl;
end;


procedure TFXcontrol.CreateAVI1Click(Sender: TObject);
const
  stf:AnsiString='';
begin
  stf:= GchooseFile('Choose a file name',stf);
  if stf<>''
    then BuildAvi(stf);
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

procedure TFXcontrol.Test1Click(Sender: TObject);
const
  Inv:boolean=false;
var
  gammaRamp:TDDGammaRamp;
  i,res:integer;
begin
  fillchar(gammaRamp,sizeof(gammaRamp),0);

  if not inv then
    with gammaRamp do
    for i:=0 to 255 do
    begin
      red[i]:=65280-256*i;
      green[i]:=65280-256*i;
      blue[i]:=65280-256*i;
    end
  else
    with gammaRamp do
    for i:=0 to 255 do
    begin
      red[i]:=256*i;
      green[i]:=256*i;
      blue[i]:=256*i;
    end;
  inv:=not inv;

  res:=DXscreen.primary.GammaControl.SetGammaRamp(0,GammaRamp);
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


{ TraiterEvt remplace la valeur dans MainBuf par  1 si evt, 0 autrement
             on veille à ne pas modifier les voies tags

             on range aussi les evt dans EvtTab
}
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





Initialization
AffDebug('Initialization FXctrl0',0);
{$IFDEF FPC}
{$I FXctrl0.lrs}
{$ENDIF}
end.

