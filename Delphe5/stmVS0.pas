unit stmVS0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes, graphics,
     util1,Dgraphic,debug0,
     stmdef,stmObj,varconf1,multg1,
     Ncdef2,stmError,
     stmData0,
      {$IFDEF DX11}FxCtrlDX11 {$ELSE} FxCtrlDX9  {$ENDIF},
     wacq1,stmstmX0,stmObv0,stmMark0,
     syspal32,visuSys1,getDXdev1,
     stmvec1,stmMat1,stmMList,stmdf0,
     objfile1,
     stmDetector1,
     Dprocess;

type
  TvisualStim=
    class(Tdata0)
      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;

      procedure createForm;override;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure CompleteLoadInfo;override;

      function initialise(st:AnsiString):boolean;override;

      function FXcontrol:TFXcontrol;

      procedure RetablirReferences(list:Tlist);override;
      procedure setTrackObvis(uo:typeUO);
      procedure ClearReferences;override;
      procedure processMessage(id:integer;source:typeUO;p:pointer);override;

      procedure UpdateRightPanel;
      procedure Reactivate;
      procedure InstallDetector(det: Tdetector);
      procedure RemoveDetectors;
    end;

var
  VisualStim:TvisualStim;

  VSpaintOnScreen:boolean;

function fonctionVisualStim:pointer;pascal;
function fonctionTsystem_RFsys(n:integer;var pu:typeUO):pointer;pascal;
function fonctionACleft:pointer;pascal;
function fonctionACright:pointer;pascal;


procedure proTvisualStim_InitAcqParams(var pu:typeUO);pascal;

procedure proTvisualStim_AnimateSeq(num:integer;var pu:typeUO);pascal;
procedure proTvisualStim_Animate(var pu:typeUO);pascal;
procedure proTvisualStim_Animate_1(var f: Tobjectfile; var pu:typeUO);pascal;
procedure proTvisualStim_Animate_2(delayMS:integer;var pu:typeUO);pascal;
procedure proTvisualStim_Animate_3(delayMS:integer;var f: Tobjectfile;var pu:typeUO);pascal;

procedure proTvisualStim_OnStartAnimate1(p:integer;var pu:typeUO);pascal;
function fonctionTvisualStim_OnStartAnimate1(var pu:typeUO):integer;pascal;

procedure proTvisualStim_OnStartAnimate2(p:integer;var pu:typeUO);pascal;
function fonctionTvisualStim_OnStartAnimate2(var pu:typeUO):integer;pascal;

procedure ProTvisualStim_TestStopStim(var pu:typeUO);pascal;

function fonctionTvisualStim_OpenDataFile(var pu:typeUO):boolean;pascal;
function fonctionTvisualStim_AppendDataFile(var pu:typeUO):boolean;pascal;

function fonctionTvisualStim_abortStim(var pu:typeUO):boolean;pascal;

procedure proTvisualStim_StopStim( w:boolean; var pu:typeUO);pascal;
function fonctionTvisualStim_StopStim(var pu:typeUO):boolean;pascal;

function fonctionTvisualStim_Vsynchro(var pu:typeUO):pointer;pascal;
function fonctionTvisualStim_Vcontrol(var pu:typeUO):pointer;pascal;


function fonctionTsystem_ControlScreen(var pu:typeUO):pointer;pascal;
function FonctionTcontrolScreen_Xmouse(var pu:typeUO):float; pascal;
function FonctionTcontrolScreen_Ymouse(var pu:typeUO):float; pascal;

function FonctionTcontrolScreen_ShiftON(var pu:typeUO):boolean;pascal;
function FonctionTcontrolScreen_CtrlON(var pu:typeUO):boolean; pascal;
function FonctionTcontrolScreen_AltON(var pu:typeUO):boolean;  pascal;

procedure proTcontrolScreen_clear(var pu:typeUO);pascal;
procedure proTcontrolScreen_DisplayAll(var pu:typeUO);pascal;
procedure proTcontrolScreen_Refresh(var pu:typeUO);pascal;
procedure proTcontrolScreen_showTracks(n:integer;b:boolean;var pu:typeUO);pascal;
function fonctionTcontrolScreen_showTracks(n:integer;var pu:typeUO):boolean;pascal;
procedure proTcontrolScreen_ClearTracks(n:integer;var pu:typeUO);pascal;

procedure proTcontrolScreen_OnMrUp(p:integer;var pu:typeUO);pascal;
function fonctionTcontrolScreen_OnMrUp(var pu:typeUO):integer;pascal;

procedure proTcontrolScreen_Active(w:boolean;var pu:typeUO);pascal;
function fonctionTcontrolScreen_Active(var pu:typeUO):boolean;pascal;

procedure proTcontrolScreen_StopOnClick(w:boolean;var pu:typeUO);pascal;
function fonctionTcontrolScreen_StopOnClick(var pu:typeUO):boolean;pascal;


function fonctionTsystem_StimScreen(var pu:typeUO):pointer;pascal;
procedure proTStimScreen_clear(var pu:typeUO);pascal;
procedure proTStimScreen_DisplayAll(var pu:typeUO);pascal;

function fonctionTstimScreen_BackGroundLum(var pu:typeUO):float;pascal;
procedure proTstimScreen_BackGroundLum(w:float;var pu:typeUO);pascal;


function fonctionTstimScreen_ColorIndexMode(var pu:typeUO):boolean;pascal;
procedure proTstimScreen_ColorIndexMode(w:boolean;var pu:typeUO);pascal;

function fonctionTstimScreen_UseGammaRamp(var pu:typeUO):boolean;pascal;
procedure proTstimScreen_UseGammaRamp(w:boolean;var pu:typeUO);pascal;


procedure proTstimScreen_Active(w:boolean;var pu:typeUO);pascal;
function fonctionTstimScreen_Active(var pu:typeUO):boolean;pascal;

procedure proTstimScreen_SetSyncLine(Fsync,Fcont:boolean;var pu:typeUO);pascal;

function fonctionTstimScreen_Height(var pu:typeUO):float;pascal;
function fonctionTstimScreen_width(var pu:typeUO):float;pascal;

function fonctionTstimScreen_PixHeight(var pu:typeUO):integer;pascal;
function fonctionTstimScreen_PixWidth(var pu:typeUO):integer;pascal;

procedure proTstimScreen_Refresh(var pu:typeUO);pascal;


function FonctionTvisualObject_SELECTED(var pu:typeUO):boolean;pascal;

procedure proTvisualStim_TrackingPoint(num,ww:integer;var pu:typeUO); pascal;
function fonctionTvisualStim_TrackingPoint(num:integer;var pu:typeUO):integer; pascal;
procedure proTvisualStim_TrackShift(num:integer;ww:integer;var pu:typeUO); pascal;
function fonctionTvisualStim_TrackShift(num:integer;var pu:typeUO):integer; pascal;
procedure proTvisualStim_TrackColor(num:integer;ww:integer;var pu:typeUO); pascal;
function fonctionTvisualStim_TrackColor(num:integer;var pu:typeUO):integer; pascal;

procedure proTvisualStim_PeriodPerChannel(w:float;var pu:typeUO);pascal;
function fonctionTvisualStim_PeriodPerChannel(var pu:typeUO):float;pascal;

function fonctionTvisualStim_ErrorCount(var pu:typeUO):integer;pascal;
function fonctionTvisualStim_ErrorPos(i:integer;var pu:typeUO):float;pascal;

procedure proTvisualstim_ExtraTime(w:float;var pu:typeUO);pascal;
function fonctionTvisualstim_ExtraTime(var pu:typeUO):float;pascal;

procedure proTvisualstim_DisableStims(var pu:typeUO);pascal;

procedure proTresizable_tracked(b:boolean;var pu:typeUO);pascal;
function fonctionTresizable_tracked(var pu:typeUO):boolean;pascal;

Function fonctionTvisualStim_DetChannel(num:Integer;var pu:typeUO):integer;pascal;
Procedure proTvisualStim_DetChannel(num,w:Integer;var pu:typeUO);pascal;

Function fonctionTvisualStim_TrackThreshold(num:Integer;var pu:typeUO):float;pascal;
Procedure proTvisualStim_TrackThreshold(num:Integer;w:float;var pu:typeUO);pascal;

Function fonctionTvisualStim_TrackDetectMode(num:Integer;var pu:typeUO):integer;pascal;
Procedure proTvisualStim_TrackDetectMode(num:Integer;w:integer;var pu:typeUO);pascal;

Function fonctionTvisualStim_Tframe(var pu:typeUO):float;pascal;
procedure proTvisualStim_Tframe(w:float;var pu:typeUO);pascal;
procedure proTvisualStim_resetTframe(var pu:typeUO);pascal;

Procedure proTvisualStim_BuildSim(var Smask:Tmatrix;var Xpos,Ypos:Tvector;Nx,Ny:integer;
                                  var Mlist:TmatList;var pu:typeUO);pascal;

Procedure proTvisualStim_BuildSim_1(x1,y1,x2,y2: integer; var Mlist:TmatList;LumValues: boolean; var pu:typeUO);pascal;
Procedure proTvisualStim_BuildSim_2( x,y,Dx,Dy: float; var Mlist:TmatList; LumValues: boolean;  var pu:typeUO);pascal;
Procedure proTvisualStim_BuildSim_3(x1,y1,x2,y2: integer; stf: AnsiString; LumValues: boolean; var pu:typeUO);pascal;
Procedure proTvisualStim_BuildSim_4( x,y,Dx,Dy: float; stf: AnsiString; LumValues: boolean; var pu:typeUO);pascal;

Function fonctionTvisualStim_FsaveObjects(var pu:typeUO):boolean;pascal;
procedure proTvisualStim_FsaveObjects(w:boolean;var pu:typeUO);pascal;


procedure proTvisualStim_MatAddCos(var mat:Tmatrix;Amp,Periode,Phi,Ori:float;var pu:typeUO);pascal;
procedure proTvisualStim_MatSetSize(var mat:Tmatrix;w,h:float;var pu:typeUO);pascal;

procedure proTvisualStim_MatLumToPix(var mat:Tmatrix;var pu:typeUO);pascal;
procedure proTvisualStim_MatPixToLum(var mat:Tmatrix;var pu:typeUO);pascal;


procedure proTvisualStim_Show(var pu:typeUO);pascal;
procedure proTvisualStim_Hide(var pu:typeUO);pascal;

procedure proTvisualStim_installDetector(var det, pu:typeUO);pascal;
procedure proTvisualStim_RemoveDetectors(var pu:typeUO);pascal;

function fonctionTcontrolScreen_Tracks(n:integer;var pu:typeUO):pointer;pascal;

Function fonctionTtracks_count(pu:typeUO):integer;pascal;
procedure proTtracks_count(w:integer;pu:typeUO);pascal;

procedure proTtracks_addPoint(x,y:float;col:integer;pu:typeUO);pascal;
procedure proTtracks_deletePoint(n:integer;pu:typeUO);pascal;

Function fonctionTtracks_XP(n:integer;pu:typeUO):float;pascal;
procedure proTtracks_XP(n:integer;w:float;pu:typeUO);pascal;

Function fonctionTtracks_YP(n:integer;pu:typeUO):float;pascal;
procedure proTtracks_YP(n:integer;w:float;pu:typeUO);pascal;

Function fonctionTtracks_colorP(n:integer;pu:typeUO):integer;pascal;
procedure proTtracks_colorP(n:integer;w:integer;pu:typeUO);pascal;

procedure proTtracks_clear(pu:typeUO);pascal;


procedure proTVisualStim_VSlineto(x,y:float;var pu:typeUO);pascal;
procedure proTVisualStim_VSmoveto(x,y:float;var pu:typeUO);pascal;

procedure proTVisualStim_VSpenLum(x:float;var pu:typeUO);pascal;
function fonctionTVisualStim_VSpenLum(var pu:typeUO):float;pascal;

procedure proTVisualStim_VSbrushLum(x:float;var pu:typeUO);pascal;
function fonctionTVisualStim_VSbrushLum(var pu:typeUO):float;pascal;


procedure proTVisualStim_VSpenWidth(x:integer;var pu:typeUO);pascal;
function fonctionTVisualStim_VSpenWidth(var pu:typeUO):integer;pascal;

procedure proTVisualStim_VSpenColor(x:integer;var pu:typeUO);pascal;
function fonctionTVisualStim_VSpenColor(var pu:typeUO):integer;pascal;

procedure proTVisualStim_VSpolygon(var Vx,Vy:Tvector;var pu:typeUO);pascal;

procedure proBMtool(num:integer; stSource,stDest:AnsiString; a1,a2,a3:float;var his:Tvector);pascal;

procedure proTvisualstim_SyncDebugMode(w:boolean;var pu:typeUO);pascal;
function fonctionTvisualstim_SyncDebugMode(var pu:typeUO):boolean;pascal;

procedure proTvisualstim_ImmediateTrigger(w:boolean;var pu:typeUO);pascal;
function fonctionTvisualstim_ImmediateTrigger(var pu:typeUO):boolean;pascal;

procedure InvalidateControlScreen;
procedure proTvisualstim_SetFakeData(num:integer;var vec:Tvector;var pu:typeUO);pascal;


function fonctionTvisualstim_PixToLum(pix:integer;var pu:typeUO):float;pascal;
function fonctionTvisualstim_LumToPix(Lum:float;var pu:typeUO):integer;pascal;

implementation

uses mdac, stmPg, stmVecU1;

constructor TvisualStim.create;
begin
  inherited;
  CandestroyForm:=false;
  createForm;

  addToTerminationList(UpdateRightPanel);
end;

destructor TvisualStim.destroy;
var
  i:integer;
begin
  RemoveFromTerminationList(UpdateRightPanel);
  derefObjet(typeUO(FXcontrol.TrackObvis));

  removeDetectors;

  inherited;
  visualStim:=nil;
end;

class function TvisualStim.stmClassName:AnsiString;
begin
  result:='VisualStim';
end;

procedure TvisualStim.createForm;
begin
  form:=TFXcontrol.create(formStm);
end;

procedure TvisualStim.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf,FXcontrol do
  begin
    setVarconf('BKlum',syspal.BKlum,sizeof(syspal.BKlum));

    setVarconf('LumMax',syspal.LuminanceMax,sizeof(syspal.LuminanceMax));

    setvarconf('TrChan',TrackChannel,sizeof(TrackChannel));
    setvarconf('TrSP',TrackSeuilP,sizeof(TrackSeuilP));
    setvarconf('TrMo',TrackMode,sizeof(TrackMode));

    setvarconf('TrPoint',TrackPoint,sizeof(TrackPoint));

    setvarconf('TrCol',TrackColor,sizeof(TrackColor));

    setvarconf('DotSz',DotSize,sizeof(DotSize));
    setvarconf('TrSh',TrackShift,sizeof(TrackShift));

    setvarconf('TrDelay',TrackDelay,sizeof(TrackDelay));

    setvarConf('TrOb',Trackobvis,sizeof(pointer));


    setvarconf('UseAcq',FacqInterface,sizeof(FacqInterface));
    setvarconf('AlActive',FalwaysActivate,sizeof(FalwaysActivate));
    setvarconf('DispAna',FdisplayData,sizeof(FdisplayData));

    setvarconf('WinMode',FwinMode,sizeof(FwinMode));
    setvarconf('RedFactor',RedFactor,sizeof(RedFactor));
    setvarconf('QualityJpeg',QualityJpeg,sizeof(QualityJpeg));
    setStringConf('stfAVI',stfAVI);
    setStringConf('stfTex',stfTex);

    setvarconf('Tbase',Tbase,sizeof(Tbase));  // ajouté le 9-05-2016
  end;
end;

procedure TvisualStim.CompleteLoadInfo;
var
  KeyON:boolean;
  i:integer;
begin
  CheckOldIdent;
  calculateScreenConst;
  formRec.restoreHiddenForm(form,createForm);

  KeyOn:=false;
  for i:=1 to 100 do
  if getKeyState(vk_shift) and $8000<>0 then KeyON:=true;

  if keyON then GetDXdevice;

  if not form.visible and testUnic and FXcontrol.FalwaysActivate then
    begin
      postMessage(FXcontrol.handle,Msg_DXdraw1,0,0);
    end;

  syspal.updateColors;
end;

function TvisualStim.initialise(st:AnsiString):boolean;
begin

end;

function TvisualStim.FXcontrol:TFXcontrol;
begin
  if not assigned(form)
    then createForm;
  result:=TFXcontrol(form);
end;

procedure TVisualStim.RetablirReferences(list:Tlist);
var
  i:integer;
begin
  for i:=0 to list.count-1 do
    if typeUO(list.items[i]).myAd=FXcontrol.Trackobvis then
      begin
        FXcontrol.Trackobvis:=Tresizable(list.items[i]);
        refObjet(FXcontrol.Trackobvis);
        exit;
      end;
  FXcontrol.TrackObvis:=nil;
end;

procedure TVisualStim.setTrackObvis(uo:typeUO);
begin
  derefObjet(typeUO(FXcontrol.Trackobvis));
  FXcontrol.Trackobvis:=Tresizable(uo);
  refObjet(typeUO(FXcontrol.Trackobvis));
end;

procedure TvisualStim.ClearReferences;
begin
  FXcontrol.Trackobvis:=nil;
end;

procedure TvisualStim.processMessage(id:integer;source:typeUO;p:pointer);
var
  i:integer;
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        if (FXcontrol.trackobvis=source) then
          begin
            FXcontrol.trackobvis:=nil;
            derefObjet(source);
          end;
        if assigned(FXcontrol.detector) then
          for i:=0 to FXcontrol.detector.count-1 do
          if typeUO(FXcontrol.detector[i]) = source then
          begin
            FXcontrol.detector.Delete(i);
            derefObjet(source);
            break;
          end;
      end;
  end;
end;

procedure TvisualStim.UpdateRightPanel;
begin
  if assigned(form)
    then TFXcontrol(form).UpdateRightPanel(self);
end;

procedure TvisualStim.InstallDetector(det: Tdetector);
begin
  if FXcontrol.detector.IndexOf(det)<0 then FXcontrol.detector.Add(det);
  refObjet(det);
end;

procedure TvisualStim.RemoveDetectors;
var
  i:integer;
  det: Tdetector;
begin
  for i:=0 to FXcontrol.detector.count-1 do
  begin
    det:= FXcontrol.detector[i];
    derefObjet(typeUO(det));
  end;
  FXcontrol.detector.Clear;
end;


{*************************** Méthodes STM de TvisualStim **********************}

var
  E_RFsys:integer;
  E_trackNum:integer;
  E_trackPoint:integer;
  E_trackColor:integer;
  E_shift:integer;

  E_errorIndex:integer;
  E_extraTime:integer;

procedure proTvisualStim_InitAcqParams(var pu:typeUO);
begin
  if not assigned(VisualStim) then exit;

  resetProcess;

  listeStim.build;

  listeStim.installe;

  with VisualStim.FXcontrol do initAcqParams;

  listeStim.desinstalle;
  listeStim.clear;

  resetProcess;
end;

procedure proTvisualStim_AnimateSeq(num:integer;var pu:typeUO);
begin
  if not assigned(VisualStim) then exit;

  with VisualStim.FXcontrol do
  begin
    {affNumSeq(num);}
    stimulerSeq(num=1);
  end;
end;

procedure proTvisualStim_Animate(var pu:typeUO);
begin
  if not assigned(VisualStim) then exit;

  with VisualStim.FXcontrol do
  begin
    stimulerSeq(true);
  end;
end;

procedure proTvisualStim_Animate_1(var f: Tobjectfile; var pu:typeUO);
begin
  if not assigned(VisualStim) then exit;
  verifierObjet(typeUO(f));

  with VisualStim.FXcontrol do
  begin
    stimulerSeq(true, 0, f);
  end;
end;

procedure proTvisualStim_Animate_2(delayMS:integer;var pu:typeUO);
begin
  if not assigned(VisualStim) then exit;

  with VisualStim.FXcontrol do
  begin
    stimulerSeq(true, delayMS,nil);
  end;
end;

procedure proTvisualStim_Animate_3(delayMS:integer; var f: Tobjectfile; var pu:typeUO);
begin
  if not assigned(VisualStim) then exit;
  verifierObjet(typeUO(f));

  with VisualStim.FXcontrol do
  begin
    stimulerSeq(true, delayMS, f);
  end;
end;


function fonctionTvisualStim_OpenDataFile(var pu:typeUO):boolean;
begin
  if not assigned(VisualStim) then exit;

  result:=acquisition.openFile;
  if result then VisualStim.FXcontrol.OpenDataFile;
end;

function fonctionTvisualStim_AppendDataFile(var pu:typeUO):boolean;
begin
  if not assigned(VisualStim) then exit;

  result:=VisualStim.FXcontrol.AppendDF;
end;


function fonctionTvisualStim_abortStim(var pu:typeUO):boolean;
begin
  if not assigned(VisualStim) then exit;
  result:=VisualStim.FXcontrol.FinImmediate;
end;

function fonctionTvisualStim_StopStim(var pu:typeUO):boolean;
begin
  if not assigned(VisualStim) then exit;
  result:=VisualStim.FXcontrol.StopStim;
end;

procedure proTvisualStim_StopStim( w:boolean; var pu:typeUO);pascal;
begin
  if not assigned(VisualStim) then exit;
  VisualStim.FXcontrol.StopStim:= w;
end;


procedure proTvisualStim_PeriodPerChannel(w:float;var pu:typeUO);
begin
  if not assigned(VisualStim) then exit;
  VisualStim.FXcontrol.Tbase:=w;
end;

function fonctionTvisualStim_PeriodPerChannel(var pu:typeUO):float;
begin
  if not assigned(VisualStim) then exit;
  result:=VisualStim.FXcontrol.Tbase;
end;

procedure proTvisualstim_ExtraTime(w:float;var pu:typeUO);
begin
  if not assigned(VisualStim) then exit;
  controleParam(w,0,10000,E_extraTime);
  extraTime:=round(w*1E6/Tfreq);
end;

function fonctionTvisualstim_ExtraTime(var pu:typeUO):float;
begin
  if not assigned(VisualStim) then exit;
  result:=extraTime*Tfreq/1E6;
end;


{*************************** Méthodes STM de TcontrolScreen *******************}

function fonctionTsystem_ControlScreen(var pu:typeUO):pointer;
const
  p:pointer=nil;
begin
  result:=@p;
end;


function FonctionTcontrolScreen_Xmouse(var pu:typeUO):float;
begin
  if assigned(VisualStim) then
    result:=XCtoDeg(VisualStim.FXcontrol.Xmouse);
end;

function FonctionTcontrolScreen_Ymouse(var pu:typeUO):float;
begin
  if assigned(VisualStim) then
    result:=YCtoDeg(VisualStim.FXcontrol.Ymouse);
end;

function FonctionTcontrolScreen_ShiftON(var pu:typeUO):boolean;
begin
  if assigned(VisualStim) then
    result:=VisualStim.FXcontrol.ShiftKeyON;
end;

function FonctionTcontrolScreen_CtrlON(var pu:typeUO):boolean;
begin
  if assigned(VisualStim) then
    result:=VisualStim.FXcontrol.CtrlKeyON;
end;

function FonctionTcontrolScreen_AltON(var pu:typeUO):boolean;
begin
  if assigned(VisualStim) then
    result:=VisualStim.FXcontrol.AltKeyON;
end;

procedure proTcontrolScreen_clear(var pu:typeUO);
begin
  if assigned(VisualStim) then VisualStim.FXcontrol.clear2Click(nil);
end;

procedure proTcontrolScreen_DisplayAll(var pu:typeUO);
begin
  if assigned(VisualStim) then VisualStim.FXcontrol.DisplayAll2Click(nil);
end;

procedure proTcontrolScreen_Refresh(var pu:typeUO);
begin
  if assigned(VisualStim) then VisualStim.FXcontrol.PaintControl;
end;

procedure proTcontrolScreen_showTracks(n:integer;b:boolean;var pu:typeUO);
begin
  controleParametre(n,1,2);
  if assigned(VisualStim) then VisualStim.FXcontrol.TracksON[n]:=b;
end;

function fonctionTcontrolScreen_showTracks(n:integer;var pu:typeUO):boolean;
begin
  controleParametre(n,1,2);
  if assigned(VisualStim) then result:=VisualStim.FXcontrol.tracksON[n];
end;

procedure proTcontrolScreen_ClearTracks(n:integer;var pu:typeUO);
begin
  controleParametre(n,1,2);
  if assigned(VisualStim) then
    case n of
      1: visualStim.FXcontrol.cleartracks1Click(nil);
      2: visualStim.FXcontrol.cleartracks21Click(nil);
    end;
end;

procedure proTcontrolScreen_OnMrUp(p:integer;var pu:typeUO);
begin
  if assigned(visualStim) then
    with visualStim.FXcontrol.EventProg[mrUp] do setAd(p);
end;

function fonctionTcontrolScreen_OnMrUp(var pu:typeUO):integer;
begin
  if assigned(visualStim) then
    result:=visualStim.FXcontrol.EventProg[mrUp].ad;
end;

procedure proTcontrolScreen_Active(w:boolean;var pu:typeUO);
begin
  affControl:=w;
  if assigned(visualStim) then
    visualStim.FXcontrol.speedControl.down:=w;
end;

function fonctionTcontrolScreen_Active(var pu:typeUO):boolean;
begin
  result:=affControl;
end;

procedure proTcontrolScreen_StopOnClick(w:boolean;var pu:typeUO);
begin
  if assigned(visualStim) then
    visualStim.FXcontrol.FStopOnClick:=w;
end;

function fonctionTcontrolScreen_StopOnClick(var pu:typeUO):boolean;
begin
  result:=visualStim.FXcontrol.FStopOnClick;
end;

{*************************** Méthodes STM de TstimScreen **********************}

function fonctionTsystem_StimScreen(var pu:typeUO):pointer;
const
  p:pointer=nil;
begin
  result:=@p;
end;


procedure proTStimScreen_clear(var pu:typeUO);
begin
  if assigned(VisualStim) then VisualStim.FXcontrol.clear1Click(nil);
end;

procedure proTStimScreen_DisplayAll(var pu:typeUO);
begin
  if assigned(VisualStim) then VisualStim.FXcontrol.DisplayAll1Click(nil);
end;

function fonctionTstimScreen_BackGroundLum(var pu:typeUO):float;
begin
  result:=syspal.BKlum;
end;

procedure proTstimScreen_BackGroundLum(w:float;var pu:typeUO);pascal;
begin
  syspal.BKlum:=w;
  syspal.update;
end;

function fonctionTstimScreen_ColorIndexMode(var pu:typeUO):boolean;
begin
  result:=syspal.FIndexMode;
end;

procedure proTstimScreen_ColorIndexMode(w:boolean;var pu:typeUO);
begin
  syspal.FIndexMode:=w;

  if w
    then syspal.resetGamma
    else syspal.BuildGamma;

  syspal.update;
end;

function fonctionTstimScreen_UseGammaRamp(var pu:typeUO):boolean;
begin
  result:=syspal.FuseGammaRamp;
end;

procedure proTstimScreen_UseGammaRamp(w:boolean;var pu:typeUO);
begin
  syspal.FuseGammaRamp:=w;
  syspal.BuildGamma;

  syspal.update;
end;

procedure proTstimScreen_Active(w:boolean;var pu:typeUO);
begin
  affStim:=w;
  if assigned(visualStim) then
    visualStim.FXcontrol.speedStim.down:=w;
end;

function fonctionTstimScreen_Active(var pu:typeUO):boolean;
begin
  result:=affStim;
end;

procedure proTstimScreen_SetSyncLine(Fsync,Fcont:boolean;var pu:typeUO);
begin
  if assigned(visualStim) then
    visualStim.FXcontrol.SetSyncLine(Fsync,Fcont);
end;

function FonctionTvisualObject_SELECTED(var pu:typeUO):boolean;
begin
  if not assigned(VisualStim) then exit;
  verifierObjet(pu);
  result:=assigned(pu) and (pu=VisualStim.FXcontrol.selectedObject);
end;

function fonctionTstimScreen_Height(var pu:typeUO):float;
begin
  result:=ScreenHeight/ScreenDistance * 180/pi;
end;

function fonctionTstimScreen_width(var pu:typeUO):float;
begin
  result:=ScreenWidth/ScreenDistance * 180/pi ;
end;

function fonctionTstimScreen_PixHeight(var pu:typeUO):integer;
begin
  result:=SSheight;
end;

function fonctionTstimScreen_PixWidth(var pu:typeUO):integer;
begin
  result:=SSwidth;
end;

procedure proTstimScreen_Refresh(var pu:typeUO);
begin
  //syspal.update;
  Visualstim.FXcontrol.updateStimScreen;

end;

{************************** Méthodes STM de TvisualStim ***********************}

procedure proTvisualStim_TrackingPoint(num:integer;ww:integer;var pu:typeUO);
begin
  if not assigned(VisualStim) then exit;
  ControleParam(num,1,2,E_tracknum);
  ControleParam(ww,0,9,E_trackPoint);
  VisualStim.FXcontrol.TrackPoint[num]:=ww;
end;

function fonctionTvisualStim_TrackingPoint(num:integer;var pu:typeUO):integer;
begin
  ControleParam(num,1,2,E_tracknum);
  result:=VisualStim.FXcontrol.TrackPoint[num];
end;

procedure proTvisualStim_TrackShift(num:integer;ww:integer;var pu:typeUO);
begin
  ControleParam(num,1,2,e_tracknum);
  ControleParam(ww,-100,100,E_shift);
  VisualStim.FXcontrol.TrackShift[num]:=ww;
end;

function fonctionTvisualStim_TrackShift(num:integer;var pu:typeUO):integer;
begin
  ControleParam(num,1,2,e_trackNum);
  result:=VisualStim.FXcontrol.TrackShift[num];
end;

procedure proTvisualStim_TrackColor(num:integer;ww:integer;var pu:typeUO);
begin
  ControleParam(num,1,2,e_trackNum);
  VisualStim.FXcontrol.TrackColor[num]:=ww;
end;

function fonctionTvisualStim_TrackColor(num:integer;var pu:typeUO):integer;
begin
  ControleParam(num,1,2,e_trackNum);
  result:=VisualStim.FXcontrol.TrackColor[num];
end;

function fonctionTvisualStim_ErrorCount(var pu:typeUO):integer;
begin
  if assigned(visualStim)
    then result:=visualStim.FXcontrol.errorList.count;
end;

function fonctionTvisualStim_ErrorPos(i:integer;var pu:typeUO):float;
begin
  if assigned(visualStim) then
  with visualStim.FXcontrol do
  begin
    if (i>=1) and (i<=errorList.count) then
      result:=intG(visualStim.FXcontrol.errorList[i-1])*Tfreq
      else sortieErreur(E_errorIndex);
  end;
end;

procedure proTvisualstim_DisableStims(var pu:typeUO);
begin
  if assigned(visualStim) then
  with visualStim.FXcontrol do disableStims;
end;

procedure proTresizable_tracked(b:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  if assigned(visualStim) then
    visualStim.setTrackObvis(Tresizable(pu));
end;

function fonctionTresizable_tracked(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  if assigned(visualStim) then
    result:=(pu=visualStim.FXcontrol.trackObvis);
end;

Function fonctionTvisualStim_DetChannel(num:Integer;var pu:typeUO):integer;
begin
  ControleParam(num,1,2,e_trackNum);
  if assigned(visualStim) then
    result:=visualStim.FXcontrol.TrackChannel[num];
end;

Procedure proTvisualStim_DetChannel(num,w:integer;var pu:typeUO);
begin
  ControleParam(num,1,2,e_trackNum);
  if assigned(visualStim) then
    visualStim.FXcontrol.TrackChannel[num]:=w;
end;

Function fonctionTvisualStim_TrackThreshold(num:Integer;var pu:typeUO):float;
begin
  ControleParam(num,1,2,e_trackNum);
  if assigned(visualStim) then
    result:=visualStim.FXcontrol.TrackSeuilP[num];
end;

Procedure proTvisualStim_TrackThreshold(num:integer;w:float;var pu:typeUO);
begin
  ControleParam(num,1,2,e_trackNum);
  if assigned(visualStim) then
    visualStim.FXcontrol.TrackSeuilP[num]:=w;
end;

Function fonctionTvisualStim_TrackDetectMode(num:Integer;var pu:typeUO):integer;
begin
  ControleParam(num,1,2,e_trackNum);
  if assigned(visualStim) then
    result:=visualStim.FXcontrol.TrackMode[num];
end;

Procedure proTvisualStim_TrackDetectMode(num:integer;w:integer;var pu:typeUO);
begin
  ControleParam(num,1,2,e_trackNum);
  if assigned(visualStim) then
    visualStim.FXcontrol.TrackMode[num]:=w;
end;

Function fonctionTvisualStim_Tframe(var pu:typeUO):float;
begin
  result:=Xframe;
end;

procedure proTvisualStim_Tframe(w:float;var pu:typeUO);
begin
  if SavedTfreq=0 then
    SavedTfreq:=Tfreq;

  Tfreq:=w*1E6;
end;

procedure proTvisualStim_resetTframe(var pu:typeUO);
begin
  if SavedTfreq<>0 then
    Tfreq:=SavedTfreq;
  SavedTfreq:=0;
end;


function fonctionVisualStim:pointer;
begin
  result:=@VisualStim;
end;

function fonctionTsystem_RFsys(n:integer;var pu:typeUO):pointer;
begin
  if (n<1) or (n>5) then sortieErreur(E_RFsys);
  result:=@RFsys[n];
end;

function fonctionACleft:pointer;
begin
  result:=@ACleft;
end;

function fonctionACright:pointer;
begin
  result:=@ACright;
end;

procedure proTvisualStim_OnStartAnimate1(p:integer;var pu:typeUO);
begin
  if assigned(visualStim) then
  with visualStim.FXcontrol.onStartAnimate1 do setAd(p);
end;


function fonctionTvisualStim_OnStartAnimate1(var pu:typeUO):integer;
begin
  if assigned(visualStim) then
  result:= visualStim.FXcontrol.onStartAnimate1.ad;
end;


procedure proTvisualStim_OnStartAnimate2(p:integer;var pu:typeUO);
begin
  if assigned(visualStim) then
  with visualStim.FXcontrol.onStartAnimate2 do setAd(p);
end;


function fonctionTvisualStim_OnStartAnimate2(var pu:typeUO):integer;
begin
  if assigned(visualStim) then
  result:= visualStim.FXcontrol.onStartAnimate2.ad;
end;


procedure ProTvisualStim_TestStopStim( var pu:typeUO);
var
  t:longword;
  flagFinExe: boolean;
begin
  if not assigned(visualStim) then exit;
  if not AnimationON then exit;

  flagFinExe:=false;
  visualStim.FXcontrol.TestStopStim(flagFinExe);
  if FlagFinExe and QuestionFinPg then  visualStim.FXcontrol.StopStim:= true;

end;



Procedure proTvisualStim_BuildSim(var Smask:Tmatrix;var Xpos,Ypos:Tvector;Nx,Ny:integer;
                                  var Mlist:TmatList;var pu:typeUO);
begin
  if not assigned(visualStim) then exit;

  verifierMatrice(Smask);
  verifierObjet(typeUO(Mlist));

  visualStim.FXcontrol.ReducStim(Smask,Xpos,Ypos,Nx,Ny,Mlist);
end;

Procedure proTvisualStim_BuildSim_1(x1,y1,x2,y2: integer; var Mlist:TmatList;LumValues: boolean; var pu:typeUO);
begin
  if not assigned(visualStim) then exit;

  verifierObjet(typeUO(Mlist));
  if (x1<0) or (x1>x2) or (x2>=SSwidth)
      or
     (y1<0) or (y1>y2) or (y2>=SSheight)
    then sortieErreur('TvisualStim.BuildSim : bad rectangle coordinates');

  visualStim.FXcontrol.ReducStim2(x1,y1,x2,y2,Mlist,LumValues);
end;

Procedure proTvisualStim_BuildSim_2( x,y,Dx,Dy: float; var Mlist:TmatList;LumValues: boolean; var pu:typeUO);pascal;
var
  x1,y1,x2,y2: integer;
begin
  if not assigned(visualStim) then exit;
  verifierObjet(typeUO(Mlist));

  x1:= degToX(x-DX/2);
  x2:= degToX(x+DX/2);

  y1:= degToY(y+DY/2); // inversion
  y2:= degToY(y-DY/2);

  if (x1<0) or (x1>x2) or (x2>=SSwidth)
      or
     (y1<0) or (y1>y2) or (y2>=SSheight)
    then sortieErreur('TvisualStim.BuildSim : bad rectangle coordinates');


  visualStim.FXcontrol.ReducStim2(x1,y1,x2,y2,Mlist, LumValues);
end;

Procedure proTvisualStim_BuildSim_3(x1,y1,x2,y2: integer;stf: AnsiString; LumValues: boolean; var pu:typeUO);
begin
  if not assigned(visualStim) then exit;

  if (x1<0) or (x1>x2) or (x2>=SSwidth)
      or
     (y1<0) or (y1>y2) or (y2>=SSheight)
    then sortieErreur('TvisualStim.BuildSim : bad rectangle coordinates');

  visualStim.FXcontrol.ReducStim2(x1,y1,x2,y2,nil,LumValues,stf);
end;

Procedure proTvisualStim_BuildSim_4( x,y,Dx,Dy: float; stf: AnsiString; LumValues: boolean; var pu:typeUO);
var
  x1,y1,x2,y2: integer;
begin
  if not assigned(visualStim) then exit;

  x1:= degToX(x-DX/2);
  x2:= degToX(x+DX/2);

  y1:= degToY(y+DY/2); // inversion
  y2:= degToY(y-DY/2);

  if (x1<0) or (x1>x2) or (x2>=SSwidth)
      or
     (y1<0) or (y1>y2) or (y2>=SSheight)
    then sortieErreur('TvisualStim.BuildSim : bad rectangle coordinates');


  visualStim.FXcontrol.ReducStim2(x1,y1,x2,y2,nil, LumValues,stf);
end;


Function fonctionTvisualStim_FsaveObjects(var pu:typeUO):boolean;
begin
  if assigned(visualStim) then
    result:=visualStim.FXcontrol.FsaveObjects;
end;

procedure proTvisualStim_FsaveObjects(w:boolean;var pu:typeUO);
begin
  if assigned(visualStim) then
    visualStim.FXcontrol.FsaveObjects:=w;
end;


procedure proTvisualStim_MatAddCos(var mat:Tmatrix;Amp,Periode,Phi,Ori:float;var pu:typeUO);
var
  i,j:integer;
  x,y,d:float;
  sint,cost,omega:float;

begin
  verifierMatrice(mat);

  phi:=phi*pi/180;

  cost:=cos(-ori*pi/180);
  sint:=sin(-ori*pi/180);

  omega:=2*pi/periode;

  with mat,data  do
  begin    
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
    begin
      x:=convx(i);
      y:=convy(j);
      d:=y*cost-x*sint;
      addE(i,j,Amp*cos(omega*d +phi ));
    end;
  end;
end;

procedure proTvisualStim_MatSetSize(var mat:Tmatrix;w,h:float;var pu:typeUO);
var
  wi,hi:integer;
begin
  verifierMatrice(mat);

  wi:=degToPix(w);
  hi:=degToPix(h);
  if (wi<=0) or (hi<=0)
    then sortieErreur('TvisualStim.MatSetSize : bad matrix width or height');

  mat.initTemp(0,wi-1,0,hi-1,mat.tpNum );
  mat.Dxu:=PixToDeg(1);
  mat.X0u:=-w/2;
  mat.Dyu:=PixToDeg(1);
  mat.Y0u:=-w/2;

end;

procedure proTvisualStim_MatLumToPix(var mat:Tmatrix;var pu:typeUO);
var
  i,j:integer;
begin
  verifierMatrice(mat);

  with mat do
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
    Zvalue[i,j]:=syspal.LumIndex(Zvalue[i,j]);

end;

procedure proTvisualStim_MatPixToLum(var mat:Tmatrix;var pu:typeUO);pascal;
var
  i,j:integer;
begin
  verifierMatrice(mat);

  with mat do
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
    Zvalue[i,j]:=syspal.PixToLum(Zvalue[i,j]);

end;


procedure proTvisualStim_Show(var pu:typeUO);
begin
  if assigned(visualStim) then
    visualStim.FXcontrol.Show;
end;

procedure proTvisualStim_Hide(var pu:typeUO);
begin
  if assigned(visualStim) then
    visualStim.FXcontrol.Hide;
end;


procedure proTvisualStim_installDetector(var det, pu:typeUO);
begin
  if assigned(visualStim) then
    visualStim.installDetector(Tdetector(det));
end;

procedure proTvisualStim_RemoveDetectors(var pu:typeUO);
begin
  if assigned(visualStim) then
    visualStim.RemoveDetectors;
end;


function fonctionTcontrolScreen_Tracks(n:integer;var pu:typeUO):pointer;
begin
  if (n<1) or (n>2) then sortieErreur('TvisualStim.tracks : invalid parameter');
  result:=visualStim.FXcontrol.stmTrack[n];
end;

Function fonctionTtracks_count(pu:typeUO):integer;
begin
  result:= TstmTrack(pu).PointList.Count;
end;

procedure proTtracks_count(w:integer;pu:typeUO);
begin
  if w<0 then sortieErreur('Ttracks.count must be positive');
  TstmTrack(pu).PointList.Count:=w;
end;

procedure proTtracks_addPoint(x,y:float;col:integer;pu:typeUO);
var
  point:TstmPoint;
begin
  point.xi:=x;
  point.yi:=y;
  point.col:=col;
  TstmTrack(pu).PointList.Add(@point);
end;

procedure proTtracks_deletePoint(n:integer;pu:typeUO);
begin
  if (n<1) or (n>TstmTrack(pu).PointList.Count)
    then sortieErreur('Ttracks.XP : index out of range');

  TstmTrack(pu).PointList.Delete(n-1);
end;


Function fonctionTtracks_XP(n:integer;pu:typeUO):float;
begin
  if (n<1) or (n>TstmTrack(pu).PointList.Count)
    then sortieErreur('Ttracks.XP : index out of range');

  result:= PstmPoint(TstmTrack(pu).PointList[n-1])^.xi;
end;


procedure proTtracks_XP(n:integer;w:float;pu:typeUO);
begin
  if (n<1) or (n>TstmTrack(pu).PointList.Count)
    then sortieErreur('Ttracks.XP : index out of range');

  PstmPoint(TstmTrack(pu).PointList[n-1])^.xi:=w;
end;


Function fonctionTtracks_YP(n:integer;pu:typeUO):float;
begin
  if (n<1) or (n>TstmTrack(pu).PointList.Count)
    then sortieErreur('Ttracks.XP : index out of range');

  result:= PstmPoint(TstmTrack(pu).PointList[n-1])^.yi;
end;

procedure proTtracks_YP(n:integer;w:float;pu:typeUO);
begin
  if (n<1) or (n>TstmTrack(pu).PointList.Count)
    then sortieErreur('Ttracks.XP : index out of range');

  PstmPoint(TstmTrack(pu).PointList[n-1])^.yi:=w;
end;


Function fonctionTtracks_colorP(n:integer;pu:typeUO):integer;
begin
  if (n<1) or (n>TstmTrack(pu).PointList.Count)
    then sortieErreur('Ttracks.XP : index out of range');

  result:=Dxcontrol.ColorFromDev(PstmPoint(TstmTrack(pu).PointList[n-1])^.col);
end;

procedure proTtracks_colorP(n:integer;w:integer;pu:typeUO);
begin
  if (n<1) or (n>TstmTrack(pu).PointList.Count)
    then sortieErreur('Ttracks.XP : index out of range');

  PstmPoint(TstmTrack(pu).PointList[n-1])^.col:=DXcontrol.DevColor(w);;
end;


procedure proTtracks_clear(pu:typeUO);
begin
  TstmTrack(pu).PointList.Clear;
end;


function fonctionTvisualStim_Vsynchro(var pu:typeUO):pointer;
begin
  case  VSSyncInput of  {Vtag1,Vtag2,v1,v2...}
    0, 1: result:=@datafile0.Vtag[VSSyncInput+1];
    else  result:=@datafile0.Fchannel[VSSyncInput-2];
  end;
end;

function fonctionTvisualStim_Vcontrol(var pu:typeUO):pointer;
begin
  case VSControlInput of  {Vtag1,Vtag2,v1,v2...}
    0, 1: result:=@datafile0.Vtag[VSSyncInput+1];
    else  result:=@datafile0.Fchannel[VSSyncInput-2];
  end;
end;



var

  VSpenLum:float;
  VSbrushLum:float;
  VSpenColor:integer;
  VSpenWidth:integer;

function LumToRGBex(lum:float):integer;
begin
  if lum=-1 then result:=rgb(255,0,0)
  else
  if lum=-2 then result:=rgb(0,0,255)
  else result:=SysPal.GreenRgb(VSpenlum);
end;

procedure proTVisualStim_VSlineto(x,y:float;var pu:typeUO);

begin
end;

procedure proTVisualStim_VSmoveto(x,y:float;var pu:typeUO);
begin
end;

procedure proTVisualStim_VSpenLum(x:float;var pu:typeUO);
begin
  VSpenLum:=x;
end;

function fonctionTVisualStim_VSpenLum(var pu:typeUO):float;
begin
  result:=VSpenLum;
end;

procedure proTVisualStim_VSbrushLum(x:float;var pu:typeUO);
begin
  VSbrushLum:=x;
end;

function fonctionTVisualStim_VSbrushLum(var pu:typeUO):float;
begin
  result:=VSbrushLum;
end;


procedure proTVisualStim_VSpenWidth(x:integer;var pu:typeUO);
begin
  VSpenWidth:=x;
end;

function fonctionTVisualStim_VSpenWidth(var pu:typeUO):integer;
begin
  result:=VSpenWidth;
end;

procedure proTVisualStim_VSpenColor(x:integer;var pu:typeUO);
begin
  VSpenColor:=x;
end;

function fonctionTVisualStim_VSpenColor(var pu:typeUO):integer;
begin
  result:=VSpenColor;
end;

procedure proTVisualStim_VSpolygon(var Vx,Vy:Tvector;var pu:typeUO);
begin
end;

procedure TvisualStim.Reactivate;
begin
   FXcontrol.InitialiseDXscreen;
end;


procedure proBMtool(num:integer; stSource,stDest:AnsiString; a1,a2,a3:float;var his:Tvector);
var
  i,j:integer;
  bm:Tbitmap;
  p: PtabOctet;
  w:float;
begin
  if assigned(his) and (num=3) then
  with his do
  begin
    modify(g_longint,0,255);
    dxu:=1;
    x0u:=0;
    dyu:=1;
    y0u:=0
  end;
  try
  bm:=Tbitmap.create;

  bm.LoadFromFile(stSource);
  if bm.PixelFormat= pf8bit then
  begin
    for j:=0 to bm.Height-1 do
    begin
      p:=bm.scanLine[j];
      case num of
        1:  begin
              for i:=0 to bm.width-1 do
              begin
                w:= a1* p^[i] +a2;
                if w<=0 then p^[i]:=0
                else
                if w>=255 then p^[i]:=255
                else p^[i]:=round(w);
              end;
            end;

        2:  begin
              for i:=0 to bm.width-1 do
              if p^[i]>0 then p^[i]:= round(a1* exp( a2*ln(p^[i]/a3)));
            end;

        3:  for i:=0 to bm.width-1 do his[p^[i]]:= his[p^[i]]+1;
      end;
    end;
    if (num=1) or (num=2) then bm.SaveToFile(stDest);
  end;

  finally
  bm.free;
  end;

end;

procedure proTvisualstim_SyncDebugMode(w:boolean;var pu:typeUO);
begin
  with VisualStim.FXcontrol do
  begin
    SyncDebugMode:=w;
    if w
      then VSnotrigger:= false
      else VSnotrigger:= true;
  end;
end;

function fonctionTvisualstim_SyncDebugMode(var pu:typeUO):boolean;
begin
  result:= VisualStim.FXcontrol.SyncDebugMode;
end;

procedure proTvisualstim_ImmediateTrigger(w:boolean;var pu:typeUO);
begin
  VSnotrigger:=w;
end;

function fonctionTvisualstim_ImmediateTrigger(var pu:typeUO):boolean;
begin
  result:= VSnotrigger;
end;

procedure InvalidateControlScreen;
begin
  if assigned(visualStim) and assigned(visualstim.form)
    then visualstim.form.Invalidate;
end;

procedure proTvisualstim_SetFakeData(num:integer;var vec:Tvector;var pu:typeUO);
var
  i,old:integer;
begin
  verifierVecteur(vec);
  verifierObjet(pu);
  dec(num);
  if (num<0) or (num>=512) then sortieErreur('TvisualStim.SetFakeData : Channel Number Out Of Range');

  old:= high(VfakeData);
  if num>old then
  begin
    setlength(VfakeData,num+1);
    for i:=old+1 to num do VfakeData[i]:=nil;
  end;

  VfakeData[num]:= Tvector.create(g_smallint,0,0);
  VfakeData[num].NotPublished:=true;
  proVcopy1(vec,VfakeData[num]);

end;

function fonctionTvisualstim_PixToLum(pix:integer;var pu:typeUO):float;
begin
  result:= syspal.IndexToLum(pix);
end;

function fonctionTvisualstim_LumToPix(Lum:float;var pu:typeUO):integer;
begin
  result:= syspal.LumIndex(Lum);
end;




Initialization
AffDebug('Initialization stmVS0',0);

if testUnic then registerObject(TvisualStim,sys);

installError(E_errorIndex,'Tvisualstim: error index out of range');



installError(E_RFsys, 'RFsys: index out of range');
installError(e_trackNum,'Track point number must be 1 or 2');
installError(E_trackPoint,'TrackPoint range is 1..9');
installerror(E_TrackColor,'TrackColor range is 1..7');
installerror(E_shift,'TrackShift range is -100..+100');

end.
