unit mdac;

interface


uses
  Windows,  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,extDlgs,
  Menus, ExtCtrls, StdCtrls, Buttons, ComCtrls,
  clipbrd, registry, mmsystem,filectrl, strUtils,
  Direct3D9G, D3DX9G,

  adpmru,
  debug0,
  util1,Dgraphic,Gdos,DdosFich,chrono0,dtf0,
  stmError,
  stmDef, stmObj,
  multg0,multG1,

  Rarray1,
  stmDf0,stmAc1,                                                            
  Dcfg1, dacCfg,
  dacInsp1,dacSys,

  stmvec1,stmMat1,
  clock0,
  Npopup,
  descAc1,descDac2,descDac2B,descPCl,descABF,descBMF,descEpc9,
  descElphy1,descIgor,descVal1,descEDF1,descSTK1,descLabChart1,
  descBinary1,
  tbm0,
  AcqDef2,acqInf2,stimInf2,Dparac2,
  acqBuf1,Daffac1,Wacq1,AcqBrd1,
  stmCooX1,
  dacMstim3,
  ProcFile,
  compg1,
  stmPg,
  objFile1,
   {$IFDEF DX11} FxCtrlDX11 {$ELSE} FxCtrlDX9 {$ENDIF} ,
  stmObv0,stmMark0,stmVS0,
  ElphyHead,

  Imacro1,

  Gedit5 ,

  listG,
  Ncdef2,Hlist0,
  FdefDac2,acqCom1,
  matrix0,
  recorder1,
  mtag2, BMex1,syspal32,


  Wave1,Fplayer1,

  Math,stmImaging,
  pwrdaq32G,
  matLab0,
  ippdefs17,ipps17,

  Geometry1,
  heap0,
  EvtAcq1,
  evalVec1,
  matlab_mat,matlab_matrix,
  UlexC,
  {$IFNDEF WIN64}  stmTcpIp1, ElphyServer1, {$ENDIF}
  dibG,
  RTcom2,
  ntx,
  AcqInterfaces,
  simpleODE,

  HTMLhelp1,
  StdColorsDlg1,DefColorsDlg1

  ,NIbrd1, RTneuronBrd, cbBrd1, itcmm,

  stmNrev1,
  ElphyOpt1,
  dataOpt1,
  getDXdev1,
  D7random1,
  MemManager1,
  doubleExt,
  mathKernel0,
  stmMemo1,
  GL, glu,
  DateForm1,
  SerialCom1,
  stmFifoError,
  NrnDll1, memoform, SimRTneuronBrd,
  cuda1,
  CudaNpp1,
  CudaRT1,
  DNkernel1,
  MathSpeedTest,
  testDX9,
  stmMotionCloud3,
  SearchPath1,
  Laguerre1,
  lcr_api,
  RestClientTest,
  cyberK4, cyberKbrd2,
  hdf5dll, hdf5_lite;





 {$IF CompilerVersion >=22}
 {$IFDEF WIN64}
   {$DEFINE VERANSI}
 {$ELSE}
   {$DEFINE VERSTRING}
 {$ENDIF}
 {$ELSE}
   {$DEFINE VERANSI}
 {$IFEND}



 Const
 {$IFDEF WIN64}
   DefCaption='Elphy64';
 {$ELSE}
   DefCaption='Elphy2';
 {$ENDIF}

type

  { TMainDac }

  TMainDac = class(TMultiGform)
    About1: TMenuItem;
    Help1: TMenuItem;
    Introduction1: TMenuItem;
    PanelBottom: TPanel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Load1: TMenuItem;
    Nextfile1: TMenuItem;
    Previousfile1: TMenuItem;
    Informations1: TMenuItem;
    Gotoepisode1: TMenuItem;
    Configuration1: TMenuItem;
    Load2: TMenuItem;
    Programming2: TMenuItem;
    Save1: TMenuItem;
    Options2: TMenuItem;
    Print1: TMenuItem;
    Objects1: TMenuItem;
    Edit1: TMenuItem;
    New1: TMenuItem;
    Analysis1: TMenuItem;
    Programming1: TMenuItem;
    Executeprogram1: TMenuItem;
    Processfile1: TMenuItem;
    Spreadsheet1: TMenuItem;
    Pnomdat: TPanel;
    Panel4: TPanel;
    PanSequence: TPanel;
    Bprevious: TBitBtn;
    Bnext: TBitBtn;
    Averaging1: TMenuItem;
    Copy1: TMenuItem;
    InstallTools1: TMenuItem;
    Debug1: TMenuItem;
    DacAcq1: TMenuItem;
    DacAcqParams: TMenuItem;
    DacStim1: TMenuItem;
    Start1: TMenuItem;
    RestartNeuron: TMenuItem;
    Systemdac1: TMenuItem;
    Nextepisode1: TMenuItem;
    Previousepisode1: TMenuItem;
    Shortcuts1: TMenuItem;
    ssu1: TMenuItem;
    ssu2: TMenuItem;
    ssu3: TMenuItem;
    ssu4: TMenuItem;
    ssu5: TMenuItem;
    Ass: TMenuItem;
    ass1: TMenuItem;
    ass2: TMenuItem;
    ass3: TMenuItem;
    ass4: TMenuItem;
    ass5: TMenuItem;
    ass6: TMenuItem;
    ass7: TMenuItem;
    ass8: TMenuItem;
    ass9: TMenuItem;
    ass0: TMenuItem;
    Startandsave1: TMenuItem;
    PanelTime: TPanel;
    PanelCount: TPanel;
    PanelStatus: TPanel;
    ObjectFiles1: TMenuItem;
    Visualstim1: TMenuItem;
    Timer1: TTimer;
    Controlpanel1: TMenuItem;
    Psave: TPanel;
    Continue1: TMenuItem;
    Programreset1: TMenuItem;
    New2: TMenuItem;
    Comments1: TMenuItem;
    Play1: TMenuItem;
    setElphyServer: TMenuItem;
    Properties1: TMenuItem;
    ssu6: TMenuItem;
    ssu7: TMenuItem;
    ssu8: TMenuItem;
    ssu9: TMenuItem;
    ssu10: TMenuItem;
    Tools1: TMenuItem;
    ToolsFile1: TMenuItem;
    MRUdat: TadpMRU;
    N1: TMenuItem;
    MRUcfg: TadpMRU;
    N2: TMenuItem;
    Quit1: TMenuItem;
    StandardColors1: TMenuItem;
    StandardColors2: TMenuItem;
    DefaultColors1: TMenuItem;
    RTNeuronParameters1: TMenuItem;
    ShowConsole1: TMenuItem;
    ShowCommands1: TMenuItem;
    Timer2: TTimer;
    ShowErrorMessages1: TMenuItem;
    Bexe: TBitBtn;
    Open1: TMenuItem;
    CloseAll1: TMenuItem;
    LoadBinaryFile1: TMenuItem;
    Load3: TMenuItem;
    Parameters1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Load1Click(Sender: TObject);
    procedure BpreviousClick(Sender: TObject);
    procedure BnextClick(Sender: TObject);
    procedure Gotoepisode1Click(Sender: TObject);
    procedure Nextfile1Click(Sender: TObject);
    procedure Previousfile1Click(Sender: TObject);
    procedure Informations1Click(Sender: TObject);
    procedure Load2Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Programming1Click(Sender: TObject);
    procedure Spreadsheet1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure Averaging1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure DacAcqParamsClick(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure ResetNeuronClick(Sender: TObject);
    procedure Systemdac1Click(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ssu5Click(Sender: TObject);
    procedure DacStim1Click(Sender: TObject);
    procedure ass9Click(Sender: TObject);
    procedure Startandsave1Click(Sender: TObject);
    procedure Processfile1Click(Sender: TObject);
    procedure Executeprogram1Click(Sender: TObject);
    procedure Introduction1Click(Sender: TObject);
    procedure Programming2Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure DacAcq1Click(Sender: TObject);
    procedure Visualstim1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Controlpanel1Click(Sender: TObject);
    procedure Continue1Click(Sender: TObject);
    procedure InstallTools1Click(Sender: TObject);
    procedure Programreset1Click(Sender: TObject);
    procedure New2Click(Sender: TObject);
    procedure Play1Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure setElphyServerClick(Sender: TObject);
    procedure Debug1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure StandardColors2Click(Sender: TObject);
    procedure Quit1Click(Sender: TObject);
    procedure DefaultColors1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RTNeuronParameters1Click(Sender: TObject);
    procedure ShowConsole1Click(Sender: TObject);
    procedure Options2Click(Sender: TObject);
    procedure ShowCommands1Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);


    {$IFDEF VERANSI}
    procedure MRUdatClick(Sender: TObject; const FileName: AnsiString);  // AnsiString nécessaire pour XE
    procedure MRUcfgClick(Sender: TObject; const FileName: AnsiString);
    {$ELSE}
    procedure MRUdatClick(Sender: TObject; const FileName: String);     // Mais delphi7 a besoin de String!
    procedure MRUcfgClick(Sender: TObject; const FileName: String);     //
    {$ENDIF}
    procedure ShowErrorMessages1Click(Sender: TObject);
    procedure CloseAll1Click(Sender: TObject);
    procedure Objects1Click(Sender: TObject);
    procedure LoadBinaryFile1Click(Sender: TObject);
    procedure Parameters1Click(Sender: TObject);

  protected
    assX:array[0..9] of TmenuItem;


    Bfile1:TmenuItem;
    file1max:integer;
    Bconfig1:TmenuItem;
    config1max:integer;

    CfgItem:array[1..5] of TmenuItem;
    fileItem:array[1..5] of TmenuItem;

    nbColTab,nbligTab:integer;

    popPg:TpopupPg;

    nomGfc:AnsiString;
    nomGfcNs:AnsiString;

    nomProg:AnsiString;
    nomHlp:AnsiString;

    Vtest:integer;

    FirstActivate:boolean;

    Analyse1max:integer;
    DelayedAction: integer;

    procedure Rien;


    procedure MessageMsg(var message:Tmessage);message msg_message;

    procedure MessageTerminateThread(var message:Tmessage);message msg_EndAcq1;
    procedure MessageThreadTerminated(var message:Tmessage);message msg_EndAcq2;

    procedure MessageShortCut(var message:Tmessage);message msg_shortCut;

    procedure MessageServer(var message:Tmessage);message msg_server;
    procedure MessageNI(var message:Tmessage);message msg_NIboards;
    procedure MessageKBacq(var message:Tmessage);message msg_KeyBoardAcq;

    procedure MessageReloadFile(var message:Tmessage);message msg_ReloadFile;
    procedure MessageCloseLastDataBlock(var message:Tmessage);message msg_CloseLastDataBlock;

    procedure MessageProcedure(var message:Tmessage);message msg_Procedure;
    procedure MessageProcedure1(var message:Tmessage);message msg_Procedure1;

    function Running:boolean;

    procedure installToolsMenu;


    procedure OnAppActivate(sender:Tobject);
    procedure AppActivate(sender:Tobject);
  public
    procedure FormCreate1;virtual;
    procedure initCfg(lecture,base:boolean);virtual;

    procedure NewGfc(st:AnsiString);
    function LoadGFC(stF:AnsiString;base:boolean):boolean;
    function LoadGFCobj(stF:AnsiString;base:boolean): boolean;
    procedure SaveGFC(stF:AnsiString;base:boolean);

    function LoadNsGFC(stF:AnsiString):integer;
    procedure SaveNsGFC(stF:AnsiString);

    procedure NouvelleCfg(first:boolean);virtual;


    procedure affNumSeqDac(num:integer);
    procedure affNomDatDac(st:AnsiString);

    function test:integer;
    procedure startAcq(Fsave,Freprise:boolean);

    procedure waveTestproc(var buf;nb:integer);

    procedure MessageCommand(var message:Tmessage);message msg_command;

    procedure NewObjectFile1Click(Sender: TObject);
    procedure SelectObjectFile(sender: Tobject);
    procedure DeleteObjectFile(sender: Tobject);
  end;

var
  MainDac: TMainDac;


implementation

uses CopyClip0, DigiOpt0,
     editcont,formDlg2, evalvar1,
     nsAPItypes,
     stmVecMatLab;



{$R *.DFM} 
procedure TmainDac.rien;
begin
end;

function TMainDac.Running:boolean;
begin
  result:=assigned(acquisition) and acquisition.acqON OR animationON;
end;


procedure TMainDac.FormCreate1;
var
  i:integer;
  hsem:integer;
  st,ext:AnsiString;
begin
  {$IFDEF FPC}
  initPRC;
  {$ENDIF}

  {$IFDEF WIN64}
  enteteCfg1:='DAC2';
  nomGfc:= AppData+'DAC64.GFC';
  {$ELSE}
  enteteCfg1:='DAC2';
  nomGfc:= AppData+'DAC2.GFC';
  {$ENDIF}

  nomGfcNs:='ElphyNeuroShare.gfc';

  for i:=1 to paramCount do
  begin
    st:=paramstr(i);
    if st='ns_server' then FlagNsServer:=true
    else
    begin
      ext:=UpperCase(extractFileExt(st));
      if (ext='.GFC') then
      begin
        if extractFilePath(st)<>''
          then nomGfc:=st
          else nomGfc:=AppData+st;
      end;
    end;

    { à compléter }
  end;


  {$IFDEF FPC}
  {$IFDEF WIN64}
  nomProg:='ELPHY64';
  {$ELSE}
  nomProg:='ELPHYFPC';
  {$ENDIF}
  {$ELSE}
  nomProg:='ELPHY';
  {$ENDIF}
  formStm:=self; {Affecter avant acquisition.create}


  DriverAcqOK:=Boards.Exist;

  {DacAcq1.visible:=driverAcqOK;}
  if driverAcqOK then acquisition:=Tacquisition.create;

  AcqCommand:=TacqCommand.create(self);

  VisualStim1.visible:=TestUnic and not FlagNsServer;

  file1max:=file1.count;
  config1max:=configuration1.count;
  Bfile1:=file1;
  Bconfig1:=configuration1;

  Analyse1max:=Analysis1.count;

  nbColTab:=32;
  nbligTab:=2000;


  statusLine:=PanelStatus;
  TimePanel:=PanelTime;
  panelNomdat:=Pnomdat;
  panelSeq:=PanSequence;
  CountPanel:=PanelCount;

  SavePanel:=PSave;  // utilisé pour indiquer le nombre d'erreurs en stimulation visuelle
                     //         pour indiquer "Program Stopped" en mode debug                 
  PgButton:= Bexe;

  HKpaintPaint:=Rien;
  HKpaintSort:=Rien;
  HKpaintSetZ:=Rien;



  {Il faut créer manuellement les fiches qui contiennent des params de cfg}
  ProcessFileForm:=TProcessFileForm.create(self);

   {$IFNDEF WIN64}
  if FlagNsServer then
  begin
    caption:=NomProg+' NeuroShare Server';
    MgCaption:= Caption;
    ElphyServer:= TserverA.create;
    ElphyServer.setup('',NsServerPort,true,0);
    LoadNsGFC(AppData+nomGfcNs);
    nouvelleCfg(true);
    WindowState:=wsMinimized;
    hsem:=OpenSemaphore(EVENT_ALL_ACCESS,true,'Elphy NsServer SEM');
    if hsem<>0 then ReleaseSemaphore(hsem,1,nil);
  end
  else
  {$ENDIF}
  begin
    LoadGFC(nomGfc,true);
    nouvelleCfg(true);
    installToolsMenu;

    //caption:=NomProg+' '+LastCaption;
    Caption:=DefCaption;
    MgCaption:= Caption;
  end;

  popPg:=TpopupPg.create(self);

  registerFileDesc(TElphyDescriptor);
  registerFileDesc(TAC1descriptor);
  registerFileDesc(TDAC2descriptor);
  registerFileDesc(TDAC2descriptorB);

  registerFileDesc(TpclampDescriptor);
  registerFileDesc(TABFDescriptor);
  registerFileDesc(TBMFdescriptor);
  registerFileDesc(TEPCdescriptor);

  registerFileDesc(TigorDescriptor);
  registerFileDesc(TValDescriptor);
  registerFileDesc(TEDFDescriptor);
  registerFileDesc(TstkDescriptor);

  registerFileDesc(TLabChartDescriptor);

  assX[0]:=ass0;
  assX[1]:=ass1;
  assX[2]:=ass2;
  assX[3]:=ass3;
  assX[4]:=ass4;
  assX[5]:=ass5;
  assX[6]:=ass6;
  assX[7]:=ass7;
  assX[8]:=ass8;
  assX[9]:=ass9;

  setPgButtonState;
end;

procedure TMainDac.OnAppActivate(Sender: TObject);
begin
  Tpg2(DacPg).CheckEditorFiles;
end;

procedure TMainDac.AppActivate(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to High(ActivateList) do ActivateList[i](sender);

end;

procedure TMainDac.FormCreate(Sender: TObject);
begin
  inherited;

  Application.ShowHint := True;

  formCreate1;

  AddToActivateList(OnAppActivate);
  Application.OnActivate:=AppActivate;

  MainHW:= handle;
end;


const
  ImStopCount:integer=3;
{ Arrêt immédiat en 3 étapes:
    1: on essaie FlagStopPanic:=true;
    2: on accepte la fermeture classique
    3: on appelle Halt;

  Si l'utilisateur répond NON, on remet le compteur à 3
}

procedure TMainDAc.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if testDebugMode then
  begin
    CanClose:=false;
    exit;
  end;

  if AcquisitionON then
    begin
      if MessageDlg('Acquisition is running. Immediate stop ?',mtConfirmation, [mbYes,mbNo],0)=mrYes then
      begin
        FlagStopPanic:=true;
        Dec(ImStopCount);
        if ImStopCount=0 then halt;
      end
      else ImStopCount:=3;

      CanClose := (ImStopCount=1);
      exit;
    end;

  if not FlagnsServer then
  if MessageDlg('Quit '+nomProg+' ?', mtConfirmation,
    [mbOk, mbCancel], 0) = mrCancel then
      begin
        CanClose := False;
        exit;
      end
    else ExitingElphy:=true;
end;

procedure TMainDac.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;

  CloseAll1Click(self);
  
  if not FlagNsServer then
  begin
    saveGfc(nomGfc,true);
    if assigned(board) then board.saveOptions;
  end
  else saveNsGfc(AppData+nomGfcNs);

  mainObjList.free;
  board.Free;         {Permet la fermeture de RT-Neuron }

  popPg.free;
end;


procedure TmainDac.initCfg(lecture,base:boolean);
  var
    rec:Trect;
  begin
    nomTextePg:='';

    if not lecture  then
      begin
        rec:=getNormalPosition(handle);

        wState:=byte(windowState);
        {windowState:=wsNormal;}
        wtop:=rec.top;
        wLeft:=rec.Left;
        wWidth:=rec.right-rec.left;
        wHeight:=rec.bottom-rec.top;
        {windowState:=TwindowState(wstate);}

        if assigned(memoA) then AcqComment:=memoA.stList.text;

        encodeObjectList(ObjectsToRefresh,stObjectsToRefresh);
        encodeObjectList(ObjectsToClear,stObjectsToClear);

        acqCommand.initCfgInfo;
      end;

    initCfg0Dac(lecture);
    if base then initCfgBaseDac;
  end;

function TmainDac.LoadGFC(stF:AnsiString;base:boolean):boolean;
begin
  allouerCfg1(200);
  initcfg(true,base);
  result:=(lirecfg1(stf)=0);
  resetCfg1;

  calculateScreenConst;

  if result then
  begin
    if Fmaj(extractFileName(stf))<>'DAC2.GFC' then stCfg:=stf;
    result:= LoadGFCobj(stF,base);
  end;

  if not result then messageCentral('Unable to read '+stf );
end;


function TmainDac.LoadGFCobj(stF:AnsiString;base:boolean): boolean;
var
  f:TfileStream;
begin
  syslist.pack;

  try
  result:=false;
  f:=nil;
  f:=TfileStream.Create(stF,fmOpenRead);
  f.Position:=EndCfgOffset;

  mainObjList.clear(base);
  dacPg:=nil;

  FlagObjectFile:=false;
  mainObjList.loadFromStream(f,f.Size-EndCfgOffset,base);
  f.Free;
  result:=true;
  except
  f.free;
  end;

end;

procedure TmainDac.SaveGFC(stF:AnsiString;base:boolean);
var
  f:TfileStream;
begin
  sysList.pack;

  allouerCfg1(200);
  initcfg(false,base);
  Ecrirecfg1( stf);
  resetCfg1;

  f:=nil;
  try
  f:=TfileStream.Create(stf,fmOpenReadWrite);
  f.Position:=f.Size;
  mainObjList.saveToStream(f);

  finally
  f.Free;
  end;
  
end;

function TmainDac.LoadNsGFC(stF:AnsiString):integer;
begin

  allouerCfg1(200);
  setVarConf1('NSVFLAG',   NsVflagGlb,  sizeof(NsVflagGlb));
  setVarConf1('NSVTAGFLAG',   NsVtagflagGlb,  sizeof(NsVtagflagGlb));
  setVarConf1('SPKTABLENUM', SpkTableNumGlb,  sizeof(spkTableNumGlb));
  result:=lirecfg1(stf);
  resetCfg1;
  
end;


procedure TmainDac.SaveNsGFC(stF:AnsiString);
begin

  allouerCfg1(200);
  setVarConf1('NSVFLAG',   NsVflagGlb,  sizeof(NsVflagGlb));
  setVarConf1('NSVTAGFLAG',   NsVtagflagGlb,  sizeof(NsVtagflagGlb));
  Ecrirecfg1(stf);
  resetCfg1;

end;


procedure TmainDac.NouvelleCfg(first:boolean);
var
  i:integer;
   p:typeUO;
begin
  if first then
    begin
      top:=wtop;
      Left:=wLeft;
      Width:=wWidth;
      Height:=wHeight;
      windowState:=TwindowState(wState);

      Boards.install(AcqDriver1);
      if testUnic
        then syspal.ChangeCalib(calibFileName);

      MRUcfg.Text:=stCfgHistory;
      MRUdat.Text:=stDatHistory;

      if MemManagerSize<>0 then
        if MemManager=nil then messageCentral('Unable to install Memory Manager');

      SysPaletteNumber:=MonoPaletteNumber;
    end;


  {messageCentral(AcqComment);}
  if assigned(memoA) then memoA.stList.text:=AcqComment;

  decodeObjectList(stObjectsToRefresh,ObjectsToRefresh);
  decodeObjectList(stObjectsToClear,ObjectsToClear);



  with mainObjList do
  begin
    p:=getAd(stDataFile0);
    if p=nil then
      begin
        p:=TdataFile.create;
        TdataFile(p).initialise(stDataFile0);
        add(p,UO_main);
      end;
    with TDataFile(p) do
    begin
      resetTitles;
      AfficherNumSeq:=AffNumSeqDAC;
      AfficherNomDat:=AffNomDatDAC;
      getDataFileName:=getFileName;
      Fsystem:=true;
    end;
    dacDataFile:=p;

    verifyMulti(TmultigraphDAC);

    p:=getAd(stMultiGraph0);
    if p=nil then
      begin
        p:=TmultiGraphDAC.create;
        TmultiGraphDAC(p).ident:= stMultiGraph0;
        TmultiGraphDAC(p).init(1,2);
        add(p,UO_main);
      end;
    p.Fsystem:=true;
    dacMultiGraph:=p;



    p:=getAd(stRealArray0);
    if p=nil then
      begin
        p:=TrealArray.create;
        TrealArray(p).ident:=stRealArray0;
        TrealArray(p).initTemp(nbColTab,nbLigTab);
        add(p,UO_main);
      end;
    p.Fsystem:=true;
    dacRealArray:=p;

    p:=getAd(stAcquis1);
    if p=nil then
      begin
        p:=Tacquis1.create;
        Tacquis1(p).initialise(stAcquis1);
        add(p,UO_main);
      end;
    p.Fsystem:=true;
    dacAcquis1:=p;
    Tacquis1(p).resetTitles;

    p:=getAd(stPg0);
    if p<>nil then dacPg:=p
    else
      begin
        dacPg:=TPg2.create;
        TPg2(dacPg).initialise(stPg0);
        add(dacPg,UO_main);
      end;
    TPg2(dacPg).Fsystem:=true;
    TPg2(dacPg).FsingleLoad:=false;

    p:=getAd(stMacroMan);
    if p=nil then
      begin
        p:=TmacroManager.create;
        TmacroManager(p).initialise(stMacroMan);
        add(p,UO_main);
      end;
    dacMacroMan:=p;
    TmacroManager(p).NotPublished:=true;
    TmacroManager(p).Fsystem:=true;
    TmacroManager(p).FsingleLoad:=true;



    p:=getAd(stAcqInfo0);
    if p=nil then
      begin
        p:=TacqInfo.create;
        TacqInfo(p).initialise(stAcqInfo0);
        add(p,UO_main);
      end;
    with TacqInfo(p) do
    begin
      Fsystem:=true;
    end;
    dacAcqInfo:=p;

    p:=getAd(stStimInfo0);
    if p=nil then
      begin
        p:=TstimInfo.create;
        TstimInfo(p).initialise(stStimInfo0);
        add(p,UO_main);
      end;
    with TstimInfo(p) do
    begin
      Fsystem:=true;
    end;
    dacStimInfo:=p;


    p:=getAd(stMstim);
    if p=nil then
      begin
        p:=TmultigraphStim.create;
        TmultiGraphStim(p).ident:= 'Mstimulator';
        TmultiGraphStim(p).init(1,2);
        add(p,UO_main);
      end;
    with TmultigraphStim(p) do
    begin
      Fsystem:=true;
      NotPublished:=true;
    end;
    dacMStim:=p;


    AcqInf.initStimInfo(dacStimInfo);
    ParamStim.initAcqInfo(dacAcqInfo);

    if AcqInfOld.Qnbvoie<>0
      then AcqInf.OldToNew(@AcqInfOld);

    if paramStimOld2.id<>'' then
    paramStim.Old2ToNew(paramStimOld2);


    if paramStimOld.id<>'' then
    paramStim.OldToNew(paramStimOld);


    if testUnic then
    begin
      p:=getAd(stVisualStim);
      if p=nil then
        begin
          p:=TvisualStim.create;
          TvisualStim(p).ident:=stVisualStim;
          add(p,UO_main);
        end;
      p.Fsystem:=true;
      VisualStim:=TvisualStim(p);
      p.NotPublished:=false;
      p.FsingleLoad:=true;

      for i:=1 to 5 do
      begin
        p:=getAd(stRF[i]);
        if p<>nil then RFsys[i]:=TRF(p)
        else
          begin
            RFsys[i]:=TRF.create;
            RFsys[i].ident:='RF'+Istr(i);
            add(RFsys[i],UO_main);
          end;
        RFsys[i].Fsystem:=true;
        RFsys[i].NotPublished:=false;
        RFsys[i].FsingleLoad:=true;
      end;

      p:=getAd(stACleft);
      if p<>nil then ACleft:=Tmark(p)
      else
        begin
          ACleft:=Tmark.create;
          ACleft.ident:='ACleft';
          add(ACleft,UO_main);
        end;
      ACleft.Fsystem:=true;
      ACleft.NotPublished:=false;
      ACleft.FsingleLoad:=true;

      p:=getAd(stACright);
      if p<>nil then ACright:=Tmark(p)
      else
        begin
          ACright:=Tmark.create;
          ACright.ident:='ACright';
          add(ACright,UO_main);
        end;
      ACright.Fsystem:=true;
      ACright.NotPublished:=false;
      ACright.FsingleLoad:=true;
    end;

    p:=getAd(stStmInspector);
    if p=nil then
      begin
        p:=TstmInspector.create;
        p.ident:=stStmInspector;
        add(p,UO_main);
      end;
    p.Fsystem:=true;
    p.FsingleLoad:=true;
    uoInspector:=TStmInspector(p);
  end;

  mainObjList.resetAll;

  acqCommand.restoreForm;

end;


procedure TMainDac.Load1Click(Sender: TObject);
begin
  if Running then exit;

  with TdataFile(dacDataFile) do
  begin
    DloadFile;
    MRUdat.addItem(stFichier);
    stDatHistory:=MRUdat.Text;
  end;
end;

procedure TMainDac.BpreviousClick(Sender: TObject);
begin
  if Running then exit;

  TdataFile(dacDataFile).DPrevSeq;
  PanSequence.caption:=Istr(TdataFile(dacDataFile).EpNum);
end;

procedure TMainDac.BnextClick(Sender: TObject);
begin
  if Running then exit;

  TdataFile(dacDataFile).DnextSeq;
  PanSequence.caption:=Istr(TdataFile(dacDataFile).EpNum);
end;

procedure TMainDac.Gotoepisode1Click(Sender: TObject);
begin
  if Running then exit;
  TdataFile(dacDataFile).ChooseEpisode;
end;

procedure TMainDac.Nextfile1Click(Sender: TObject);
begin
  if Running then exit;
  TdataFile(dacDataFile).DnextFile;
end;


procedure TMainDac.Previousfile1Click(Sender: TObject);
begin
  if Running then exit;
  TdataFile(dacDataFile).DpreviousFile;
end;

procedure TMainDac.Informations1Click(Sender: TObject);
begin
  if Running then exit;
  TdataFile(dacDataFile).DfileInfo;
end;

procedure TMainDac.NewGfc(st:AnsiString);
begin
  if loadGFC(st,false) then
    begin
      nouvelleCfg(false);
      LastCaption:=extractFileName(stCfg);
      caption:=DefCaption;  //NomProg+' '+LastCaption;
      MgCaption:= Caption;
      
      MRUcfg.AddItem(stCfg);
      stCfgHistory:=MRUcfg.Text;

      affNomDatDac('');
      affNumSeqDac(1);
    end;
end;

procedure TMainDac.Load2Click(Sender: TObject);
var
  stg,st:AnsiString;
begin
  if Running then exit;

  stg:=stgenCfg;
  st:= stCfg;
  if choixFichierStandard(stg,st,nil) then
  begin
    stgenCfg:=stg;
    stCfg:=st;
    newGfc(stCfg);
  end;
end;

procedure TMainDac.Save1Click(Sender: TObject);
var
  st:AnsiString;
begin
  if Running then exit;
  st:=stCfg;
  if sauverFichierStandard(st,'GFC') then
    begin
      stCfg:=st;
      saveGFC(stCfg,false);
      LastCaption:=ExtractFileName(stCfg);
      //caption:=NomProg+' '+LastCaption;
    end;
end;


procedure TMainDac.Programming1Click(Sender: TObject);
begin
  if Running then exit;
  if assigned(dacPg) then Tpg2(dacPg).showEditor;
end;


procedure TmainDac.MessageMsg(var message:Tmessage);
{Méthode exécutée à la reception de msg_message}
var
  st:AnsiString;
  boiteInfo:typeBoiteInfo;
begin
  st:=getStmMessage(message.wparam);

  with Boiteinfo do
  begin
    init('ERROR');
    writeln(st);
    done;
  end;
end;

procedure TMainDac.Spreadsheet1Click(Sender: TObject);
begin
  TrealArray(dacRealArray).show(nil);
end;

procedure TMainDac.Edit1Click(Sender: TObject);
begin
   UOinspector.show(self);
end;

procedure TMainDac.New1Click(Sender: TObject);
begin
  if nouvelObjet(3)<>nil then UOinspector.update;  {type data uniquement}
end;

procedure TMainDac.Averaging1Click(Sender: TObject);
begin
  if Running then exit;
  TdataFile(dacDataFile).Daveraging;
end;

procedure TMainDac.affNumSeqDac(num:integer);
begin
  PanSequence.caption:=Istr(num);
end;

procedure TMainDac.affNomDatDac(st:AnsiString);
begin
  PnomDat.caption:=st;
  Caption:=TdataFile(DacDataFile).getFileName;
  MgCaption:= Caption;
end;

procedure TMainDac.Copy1Click(Sender: TObject);
begin
  if Running then exit;
  if copyClip.execution then copyToClipBoard;
end;

function TmainDac.test:integer;assembler;
asm
  mov  edx,self.Vtest
  mov  eax,edx
end;



procedure TMainDac.DacAcqParamsClick(Sender: TObject);
begin

  if acquisitionON  then exit;

  paramAcq.execution(acqInf);
  
end;


procedure TMainDac.DacAcq1Click(Sender: TObject);
var
  ok:boolean;
begin

  ok:=assigned(board);
  DacAcqParams.enabled:=ok;
  DacStim1.enabled:=ok;
  Start1.enabled:=ok;
  Startandsave1.enabled:=not Running and ok;
  continue1.Enabled:=not Running and ok and (acqinf.DFformat=ElphyFormat1) and datafile0.isElphyFile;

  RestartNeuron.Visible:= assigned(board) and (board is TRTNIinterface);
  RTNeuronParameters1.Visible:=assigned(board) and (board is TRTNIinterface);
  ShowConsole1.Visible:=assigned(board) and (board is TRTNIinterface);
  
end;


procedure TmainDac.startAcq(Fsave,Freprise:boolean);
begin

  PanelBottom.Show;
  with Acquisition do
  begin
     startAcq(Fsave,Freprise);
     if not Fsave then LastAcqCommand:=1
     else
     if Fsave and not Freprise then LastAcqCommand:=2
     else
     if Fsave and Freprise then LastAcqCommand:=3;
  end;

end;

procedure TMainDac.Start1Click(Sender: TObject);
begin

  if Acquisition.acqON then
  begin
    if (getKeyState(VK_control) and $8000<>0) then
       if MessageDlg('Immediate stop ?',mtConfirmation, [mbYes,mbNo],0)=mrYes
         then FlagStopPanic:=true;
    FlagStop:=true;
    acquisition.setState(S_waitEnd);
  end
  else startAcq(false,false);

end;

procedure TMainDac.Startandsave1Click(Sender: TObject);
begin
  startAcq(true,false);
end;

procedure TMainDac.Continue1Click(Sender: TObject);
begin
  startAcq(true,true);
end;


{Chaque fois qu'un des threads d'acquisition se termine, il envoie le message
msg_EndAcq1 . Une fois que tous les threads sont terminés, un message msg_EndAcq2
est envoyé}
procedure TmainDac.MessageTerminateThread(var message:Tmessage);{message msg_EndAcq1;}
begin
  with message do Acquisition.endAcq(wparam);
end;

{Message envoyé par Tacquisition.EndAcq une fois que tous les threads sont arrêtés}
procedure TmainDac.MessageThreadTerminated(var message:Tmessage);{message msg_EndAcq2;}
begin
  acquisition.setState(S_stopped);
  acquisition.DisplayBoardErrorMsg;
end;

procedure TMainDac.ResetNeuronClick(Sender: TObject);
begin

  if assigned(board) and (board is TRTNIinterface)
    then TRTNIinterface(board).RestartNeuron;
    
end;

procedure TMainDac.Systemdac1Click(Sender: TObject);
begin

  if acquisitionON then exit;
  boards.choose(AcqDriver1);
  
end;

procedure TMainDac.File1Click(Sender: TObject);
begin

  inherited;
  FastCoo.reset;
  
end;

procedure TMainDac.PaintBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  p:Tpoint;
  pg:Tpg2; 
begin

  inherited;

  if shift=[ssCtrl,ssShift,ssLeft] then
    begin
      p.x:=x;
      p.y:=y;

      p:=paintbox1.clientToScreen(p);

      Tpg2(dacPg).Xpos:=p.x;
      Tpg2(dacPg).Ypos:=p.y;

      pg:=dacpg;
      pg.Xpos:=p.x;
      pg.Ypos:=p.y;

      Pg.showPopUp;
    end;
    
end;


{Initialise les shortCuts}
procedure TmainDac.MessageShortCut(var message:Tmessage);
var
  num,vk2:word;
  {$IF CompilerVersion >=22}
  vk1: word;
  {$ELSE}
  vk1:byte;
  {$IFEND}
  mm:TmenuItem;
  i:integer;
begin
  num:=loword(message.wparam);
  vk1:=hiword(message.wparam);
  vk2:=message.lparam;

  case num of
    { 10 raccourcis PG2}
    1: mm:=ssu1;
    2: mm:=ssu2;
    3: mm:=ssu3;
    4: mm:=ssu4;
    5: mm:=ssu5;
    6: mm:=ssu6;
    7: mm:=ssu7;
    8: mm:=ssu8;
    9: mm:=ssu9;
    10:mm:=ssu10;

    {En début d'acquisition, on initialise les raccourcis Mtag}
    100: begin
           for i:=0 to 9 do assX[i].shortcut:=shortcut(ord('0')+i,[ssCtrl]);
           exit;
         end;
    {En fin d'acquisition, on les neutralise }
    101: begin
           for i:=0 to 9 do assX[i].shortcut:=shortcut(0,[]);
           exit;
         end;

    else exit;
  end;              

  {$IF CompilerVersion >=22}
  mm.shortcut:=shortcut(vk2,TshiftState(vk1));
  {$ELSE}
   mm.shortcut:=shortcut(vk2,TshiftState(vk1));
  {$IFEND}
end;

procedure TMainDac.ssu5Click(Sender: TObject);
begin

  ShortCuts.execute(TmenuItem(sender).tag);
  
end;


procedure TmainDac.MessageCommand(var message:Tmessage);
begin
  if not assigned(board) then exit;

  update;
  if assigned(activeMacro) then activeMacro.hideNextPopUp;

  if message.Lparam>0 then
  begin
    timer2.Interval:=message.LParam;
    timer2.Enabled:=true;
    DelayedAction:=message.Wparam;
  end
  else
  begin
    
    case message.WParam of
      1: if not running then Start1Click(nil);

      2: if not running then Startandsave1Click(nil);

      3: if not Running and (acqinf.DFformat=ElphyFormat1) and datafile0.isElphyFile then Continue1Click(nil);

      4: if running then Start1Click(nil);
    end;
  end;
end;


procedure TMainDac.DacStim1Click(Sender: TObject);
begin

  if not AcquisitionON then Mstimulator.execution;

end;

procedure TMainDac.ass9Click(Sender: TObject);
begin
  with acquisition do
  if AcqOn then setMtag( TmenuItem(sender).tag);        
end;


procedure TMainDac.Processfile1Click(Sender: TObject);
begin
  if Running then exit;
  ProcessFileForm.execution;
end;

procedure TMainDac.Executeprogram1Click(Sender: TObject);
var
  pg:Tpg2;
begin
  if animationON then
    begin
      VisualStim.FXcontrol.stopStim:=true;
      exit;
    end;

  pg:=dacpg;

  pg.Xpos:=Tpg2(dacPg).Xpos;
  pg.Ypos:=Tpg2(dacPg).Ypos;

  if assigned(pg) then
  begin
    Pg.showPopUp;
  end;
end;

procedure TMainDac.Introduction1Click(Sender: TObject);
var
  st:Ansistring;
begin
  st:= AppDir +'elphy.chm';
  HTMLhelp(0,Pansichar(st),HH_DISPLAY_TOPIC,0);
end;

procedure TMainDac.Programming2Click(Sender: TObject);
var
  st:Ansistring;
begin

  st:= AppDir +'elphy.chm';

  HTMLhelp(0,Pansichar(st),HH_DISPLAY_TOPIC,0);

end;

procedure TMainDac.About1Click(Sender: TObject);
begin
   ElphyEntete.show;
end;



procedure TMainDac.Visualstim1Click(Sender: TObject);
begin
  if not initDirectX9(true) then exit;

//  if assigned(DXscreen) then DXscreen.initDX9; //Test
  VisualStimOpen:=true;
  VisualStim.show(self);

end;

procedure TMainDac.FormActivate(Sender: TObject);
begin
  {if not FirstActivate then
    begin
      ElphyEntete.show;
      ElphyEntete.setFocus;
    end;
  FirstActivate:=true;}
end;

{$I Dacver.pas}

procedure TMainDac.FormShow(Sender: TObject);
begin
  inherited;

  if not FirstActivate and not FlagNsServer then
  begin
    if LastVersion<>DacVersion then
    begin
      AddToSearchPath(AppDir+'lib', Pg2SearchPath, false); // Appdir contient un slash final
                                                          // les paths ne contiennent pas de slash final

      
      ElphyEntete.BinfoClick(nil);
    end;

    ElphyEntete.show;
    ElphyEntete.BOK.setFocus;

    LastVersion:=DacVersion;
  end;

  FirstActivate:=true;

end;

procedure TMainDac.Timer1Timer(Sender: TObject);
begin
  {Donne le focus à la fenêtre Entete}
  
  if ElphyEntete.Visible and not FlagNsServer then
  begin
    ElphyEntete.show;
    timer1.Enabled:=false;
  end;

  //if stmHintVisible then HideStmHint;
end;

procedure TMainDac.Controlpanel1Click(Sender: TObject);
begin

  AcqCommand.Show;
  
end;

var
  aa:array[1..10] of integer;

function cle(i:integer):float;
begin
  result:=aa[i];
end;

procedure echange(i,j:integer);
var
  s:integer;
begin
  s:=aa[i];
  aa[i]:=aa[j];
  aa[j]:=s;
end;


type
  Ttype=record
          x,y:integer;
        end;
  Ptype=^Ttype;

procedure TMainDac.InstallTools1Click(Sender: TObject);
begin

  if Running then exit;
  TmacroManager(DacMacroMan).Menu;
  installToolsMenu;
  
end;


procedure TMainDac.Programreset1Click(Sender: TObject);
begin

  if Running then exit;
  if assigned(dacPg) then Tpg2(dacPg).resetProgram;
  
end;

procedure TMainDac.New2Click(Sender: TObject);
begin

  if Running then exit;
  mainObjList.clear(false);

  nouvelleCfg(false);
  multigraph0.Defaults;
  caption:= DefCaption; // NomProg;
  MgCaption:= Caption;
  LastCaption:='';

  affNomDatDac('');
  affNumSeqDac(1);
end;

procedure TMainDac.waveTestproc(var buf;nb:integer);
const
  cnt:integer=0;
begin

  inc(cnt);
  statuslineTxt(Istr(cnt));

end;

{$IFDEF VERANSI}
procedure TMainDac.MRUdatClick(Sender: TObject; const FileName: AnsiString);
begin
  if Running then exit;
  if FileName='' then exit;

  if not fileExists(FileName) then
    begin
      MRUdat.RemoveItem(FileName);
      messageCentral('Unable to load '+FileName);
      exit;
    end;

  TdataFile(dacDataFile).installFile0(FileName,true,false);
end;

procedure TMainDac.MRUcfgClick(Sender: TObject; const FileName: AnsiString);
begin
  if Running then exit;
  NewGfc(FileName);
end;

{$ELSE}
procedure TMainDac.MRUdatClick(Sender: TObject; const FileName: String);
begin
  if Running then exit;
  if FileName='' then exit;

  if not fileExists(FileName) then
    begin
      MRUdat.RemoveItem(FileName);
      messageCentral('Unable to load '+FileName);
      exit;
    end;

  TdataFile(dacDataFile).installFile0(FileName,true,false);
end;

procedure TMainDac.MRUcfgClick(Sender: TObject; const FileName: String);
begin
  if Running then exit;
  NewGfc(FileName);
end;
{$ENDIF}


procedure TMainDac.Play1Click(Sender: TObject);
begin

  dataFile0.playFile;

end;


procedure TMainDac.Properties1Click(Sender: TObject);
begin

  inherited;
  dataFile0.Proprietes(nil);
  
end;


procedure TMainDac.MessageServer(var message: Tmessage);
{$IFNDEF WIN64}
var
  server:TserverA;
begin
  server:=TserverA(message.WParam);

  {Le serveur principal gère les messages systèmes et ignore tout le reste}
  if server=ElphyServer
    then ProcessElphyServerMessages
    else server.ProcessBuffer(self);
end;
{$ELSE}
begin
end;
{$ENDIF}


procedure TMainDac.setElphyServerClick(Sender: TObject);
var
  dlg:TdlgForm2;
  active0:boolean;
begin
 {$IFNDEF WIN64}
  active0:=assigned(ElphyServer);

  dlg:=TdlgForm2.create(formStm);
  try
  dlg.borderStyle:=bsDialog;
  dlg.Caption:='Elphy server';

  dlg.setShortString('IP address',ElphyServerAdd,20,20);
  dlg.setNumVar('Port',ElphyServerPort,g_longint,6,0);
  dlg.setBoolean('Active',active0);


  if dlg.ShowModal=mrOK then
  begin
    updateAllVar(dlg);
    if active0 then
    begin
      if not assigned(ElphyServer) then ElphyServer:=TserverA.create;
      ElphyServer.setup(ElphyServerAdd,ElphyServerPort,true,0);
    end
    else
    begin
      ElphyServer.Free;
      ElphyServer:=nil;
    end;
  end;

  finally
  dlg.free;
  end;
  {$ENDIF}
end;


procedure ProDum(var st:AnsiString);
begin
  ShowStringInfo(st);
end;

type
  Iinter=interface(Iunknown)
            procedure show;
            procedure dormir;
            function getref:integer;
         end;

  TobjInter=class(TInterfacedObject,Iinter)
              w:real;
              constructor create;
              procedure show;
              procedure dormir;
              function getref:integer;
            end;

  constructor TobjInter.create;
  begin
    w:=123;
  end;

  procedure TobjInter.show;
  begin
    messageCentral('OKOK='+Estr(w,3));
  end;

  procedure TobjInter.dormir;
  begin

  end;

  function TobjInter.getref:integer;
  begin
    result:=refcount;
  end;




procedure TmainDac.installToolsMenu;
var
  m:TmenuItem;
  i:integer;
begin

  inherited;
  FastCoo.Reset;

  Tools1.Clear;
  TmacroManager(DacMacroMan).installToolsMenu(Tools1);

end;



procedure testX(st:AnsiString);
begin
  st:=st+'Xafter eight';
  showStringInfo(st);
end;


procedure testWinExec;
begin
//  SetEnvironmentVariable('NEURONHOME','c:\nrn');
  SetEnvironmentVariable('NU','c:/nrn');

  setCurrentDirectory('c:\nrn\modeles\tcfluct');
  winexec('c:\nrn\bin\rxvt -e c:/nrn/bin/sh c:/nrn/lib/mknrndllA.sh c:/nrn',SW_SHOW);



// Ces deux lignes fonctionnent
//  setCurrentDirectory('d:\nrn431-c6\demo\release');
//  winexec('c:\nrndum\bin\rxvt -e c:/nrndum/bin/sh c:/nrndum/lib/mknrndll.sh c:/nrndum',SW_SHOW);


//  setCurrentDirectory('d:\nrn431-c6\demo\release');
//  winexec('c:\nrndum\bin\rxvt -e c:/nrndum/bin/sh c:/nrndum/lib/mknrndll.sh c:/nrndum',SW_SHOW);

  //winexec('c:\nrndum\bin\rxvt -e c:/nrndum/bin/sh c:/nrndum/lib/essai.sh c:/nrndum',SW_SHOW);

  //executeProcess('c:\nrn\bin\rxvt.exe','c:\nrn\bin\rxvt.exe -e sh c:/nrn/lib/essai.sh');
end;




procedure TMainDac.FormDestroy(Sender: TObject);
begin
  inherited;

  formStm:=nil;

end;



procedure TMainDac.MessageNI(var message: Tmessage);
begin

  TNIboard(board).relancerNI;

end;



procedure TmainDac.MessageKBacq(var message:Tmessage);
begin

  if MessageDlg('Continue ?', mtConfirmation, [mbYes,mbNo],0)=mrYes
    then acquisition.KeyBoardStart:=true
    else FlagStop:=true;
end;

procedure TmainDac.MessageReloadFile(var message:Tmessage);
begin
  TdataFile(dacDataFile).ReloadFile;
end;

procedure TmainDac.MessageCloseLastDataBlock(var message:Tmessage);
begin
  TdataFile(dacDataFile).CloseLastDataBlock;
end;

procedure TmainDac.MessageProcedure(var message:Tmessage);
begin
  Tpg2(dacPg).ProcessProcedure(message);
end;

procedure TmainDac.MessageProcedure1(var message:Tmessage);
begin
  Tpg2(dacPg).ProcessProcedure1(message);
end;

procedure TMainDac.StandardColors2Click(Sender: TObject);
begin

  StdColorsDlg.execute(stdColors);

end;

procedure TMainDac.Quit1Click(Sender: TObject);
begin
  close;

end;

procedure TMainDac.DefaultColors1Click(Sender: TObject);
begin
  DefColorsDlg.execute(DefBKcolor,DefScaleColor,DefPenColor);
end;




procedure TMainDac.RTNeuronParameters1Click(Sender: TObject);
begin

  if assigned(board) and (board is TRTNIInterface)
    then TRTNIInterface(board).RTNeuronDialog;

end;

procedure TMainDac.ShowConsole1Click(Sender: TObject);
begin
  if assigned(board) then board.showRTconsole;
end;

var
  dir:AnsiString;

Function HighLightCode(st:AnsiString):integer;
var
  i:integer;
begin
  st:=UpperCase(st);
  result:=0;
  for i:=1 to length(st) do
  if st[i] in ['A'..'Z'] then inc(result,ord(st[i])-64);
end;


procedure TMainDac.Options2Click(Sender: TObject);
begin

  ElphyOpt.execute;

end;

procedure TMainDac.ShowCommands1Click(Sender: TObject);
begin
  if assigned(dacPg) then Tpg2(dacPg).ShowCommandWindow;

end;


function myfunc(n:integer):AnsiString;pascal;
begin
  result:='Testing Purpose '+Istr(n);
end;


const
  seed: integer=0;

function Rnd(maxValue:integer): integer;
var
  i: int64;

begin
  seed:=seed* $8088405 + 1;
  i := longword(seed) * int64(maxValue);
  i:=  i shr 32;

  result:= i;
end;


var
  xxx:double;
procedure Aproc;
begin
  xxx:=xxx+1;
end;







procedure TMainDac.Timer2Timer(Sender: TObject);
begin
  timer2.enabled:=false;

  case DelayedAction of
    1: if not running then Start1Click(nil);

    2: if not running then Startandsave1Click(nil);

    3: if not Running and (acqinf.DFformat=ElphyFormat1) and datafile0.isElphyFile then Continue1Click(nil);

    4: if running then Start1Click(nil);
  end;
end;



procedure TMainDac.ShowErrorMessages1Click(Sender: TObject);
begin
  fifoError.DisplayHistory;
end;

procedure ippGAdd_32f_I( p1,p2:Psingle; N:integer);
var
  pfin: Psingle;
  i:integer;
begin
  pfin:=pointer(intG(p1)+N*sizeof(single));
  repeat
    p1^:=p1^+p2^;
    inc(intG(p1),8);
    inc(intG(p2),8);
  until p1=pfin;
end;                                                                 


(*
procedure TMainDac.Debug1Click(Sender: TObject);
const
  N=10000000;
var
  p1,p2: array of single;
  i,j:integer;
begin
  setLength(p1,N);
  setLength(p2,N);

  for i:=0 to N-1 do
  begin
    p1[i]:=1;
    p2[i]:=2;
  end;
  i:=max(i,j);
  // Doubles: 8 secondes contre 4 secondes en Delphi7
  //          5 secondes contre 4 secondes pour XE2
  //          1 Giga additions

  // avec MKL vdAdd , même temps que IPP



  initChrono;
  for i:=1 to 100 do
   // for j:=0 to N-1 do p1[j]:=p1[j]+p2[j];
    ippGAdd_32f_I(@p1[0],@p2[0],N);

  messageCentral(chrono);


  initChrono;
  for i:=1 to 100 do
    vsAdd(N,@p1[0],@p2[0],@p2[0]);

  messageCentral(chrono);


  initChrono;
  for i:=1 to 100 do
    ippsAdd_32f_I(@p1[0],@p2[0],N);

  messageCentral(chrono);

end;


procedure TMainDac.Debug1Click(Sender: TObject);
var
  stL:TstringList;
  st,stf:string;
  pcDef:integer;
  stMot:AnsiString;
  tp:typeLexBase;
  x:float;
  error:integer;
  i,j,nbN:integer;

  tb:array[0..30,-30..30] of single;
  f:TfileStream;
begin
  stf:='D:\dac2\pedro\*.rtf';
  stL:=TstringList.Create;
  stf:=GchooseFile('',stf);
  if stf='' then exit;
  stL.LoadFromFile(stf);

  st:=stL.text;
  while pos('''',st)>0 do st[pos('''',st)]:=';'  ;
  pcdef:=0;
  nbN:=0;
  repeat
    lireULexBase(st, pcDef, stMot,tp, x, error,[';']);
    if (tp=nombreB) and (error=0) then
    begin
      inc(nbN);
      i:= (nbN-1) div 61 ;
      j:= 30-(nbN-1) mod 61;
      tb[i,j]:=x;

      //if (nbN-1) mod 61= 0 then messageCentral('i='+Istr(i)+'  x= '+Estr(x,3))
    end;

  until tp=finB;

  messageCentral('nb='+Istr(nbN));
  stL.free;

  stF:= NouvelleExtension(stF,'sss');
  f:=TfileStream.Create(stF, fmCreate);
  f.Write(tb,sizeof(tb));
  f.Free;

end;
*)

// Appelée quand on clique sur Objects dans le menu principal
procedure TMainDac.Objects1Click(Sender: TObject);
var
  i,k:integer;
  m,m1:TmenuItem;
  st:string;
begin
  ObjectFiles1.clear;                               // On supprime tout dans "Object Files"

  m:=TmenuItem.create(ObjectFiles1);               //  Open
  m.caption:='Open';
  m.OnClick:= NewObjectFile1Click;
  ObjectFiles1.add(m);

  k:=-1;
  for i:=0 to MainObjFileList.count-1 do
  begin
    st:= TobjectFile( MainObjFileList[i]).fileName;//  Liste des fichiers ouverts
    if st<>'' then
    begin
      inc(k);
      m:=TmenuItem.create(ObjectFiles1);
      m.caption:= st;
      m.tag:=k;
      ObjectFiles1.add(m);

      m1:=TmenuItem.create(m);
      m1.caption:= 'Show';
      m1.tag:=k;
      m1.OnClick:= SelectObjectFile;
      m.add(m1);

      m1:=TmenuItem.create(m);
      m1.caption:= 'Close';
      m1.tag:=k;
      m1.OnClick:= DeleteObjectFile;
      m.add(m1);

    end
    else
    begin
      TobjectFile( MainObjFileList[i]).Free;
      MainObjFileList[i]:=nil;
    end;
  end;
  MainObjFileList.Pack;

  m:=TmenuItem.create(ObjectFiles1);            // Close All
  m.caption:='Close All';
  m.OnClick:= CloseAll1Click ;
  ObjectFiles1.add(m);
end;

// Appelée quand on clique sur un nom de fichier
procedure TmainDac.SelectObjectFile(sender: Tobject);
begin
  TobjectFile( MainObjFileList[TmenuItem(sender).tag]).show(self);
end;

procedure TmainDac.DeleteObjectFile(sender: Tobject);
begin
  MainObjList.Remove(MainObjFileList[TmenuItem(sender).tag]) ;
  TobjectFile( MainObjFileList[TmenuItem(sender).tag]).free;
end;

var
  stObjFile: string;

// Appelée quand on clique sur Objects/Open
procedure TMainDac.NewObjectFile1Click(Sender: TObject);
var
  st:shortstring;
  p: TobjectFile;
  i:integer;
begin
  i:=0;
  repeat
    inc(i);
    st:='ObjFile'+Istr(i);
  until MainObjList.accept(st);

  p:= TobjectFile.create;
  if p.initialise(st) then
  begin
    MainObjList.add(p,UO_main);
    if p.GopenFile
      then p.show(nil)
      else p.Free;
  end
  else p.free;

end;

// Appelée quand on clique sur Objects/Close ALL
procedure TMainDac.CloseAll1Click(Sender: TObject);
var
  i:integer;
begin
  for i:= MainObjFileList.Count-1 downto 0 do
  begin
    MainObjList.Remove(MainObjFileList[i]) ;
    TobjectFile( MainObjFileList[i]).free;
  end;
end;




procedure SingleToGreen(pSrc: Psingle; pDst: Plongint; len:integer);
var
  pAux:Plongint;
begin
  getmem(pAux,len*4);
  ippsConvert_32f32s_Sfs(pSrc, pDst,      len,ippRndZero,0);
  ippsAndC_32u_I(255, Plongword(pDst), len);
  ippsLshiftC_32s( pDst, 8,pAux,len);
  ippsAddC_32s_Sfs(pAux, 255, pDst, len, 0);
  freemem(pAux);
end;

procedure ByteToGreen(pSrc: Psingle; pDst: Psingle; len:integer;a,b:single);
begin
  IppsTest;
  ippsmulC_32f(Psrc,a,Pdst,len);
  ippsAddC_32f_I(b,Psingle(pDst),len);
  IppsEnd;
end;


procedure ByteToGreen1(pSrc: Pbyte; pDst: Plongint; len:integer;a,b:single);
var
  i:integer;
begin
  for i:=0 to len-1 do
    PtabSingle(pDst)^[i]:= a*PtabSingle(Psrc)^[i]+b;
end;


procedure BuildXYmap;
var
  i,j:integer;
  R,theta,w:real;
Const
  Nx=512;
  Ny=512;
var
  xmap,ymap:  array of array of single;

begin
  setlength(xmap,Nx,Ny);
  setlength(ymap,Nx,Ny);


  for i:=0 to Nx-1 do
  for j:=0 to Ny-1 do
  begin
    R:=sqrt( sqr(i-Nx/2)+sqr(j-Ny/2));
    theta:=angle(i-Nx/2,j-Ny/2);

    xmap[i,j]:= R;
    ymap[i,j]:= (theta+pi)*(Ny)/(2*pi);
  end;

end;


function getTextFactor:float;
var
  dc:HDC;
  nn:integer;
begin
  dc:=getDC(mainDac.handle);
  nn:=GetDeviceCaps(DC, LOGPIXELSX	);
  releasedc(mainDac.handle,dc);
  result:=nn/96;
end;

procedure TestMx;
var
  mx: mxArrayPtr;
  nfields:integer;
  fieldNames: array of Ansistring;
  p:array[1..2] of pointer;
begin
  if not testMatlabMat then exit;
  if not testMatlabMatrix then exit;

  setlength(FieldNames,2);
  fieldNames[0]:='Hello';
  fieldNames[1]:='Boys';
  p[1]:=@fieldNames[0][1];
  p[2]:=@fieldNames[1][1];

  nfields:=2;
  mx:= mxCreateStructMatrix(1,1,nfields,@p);

  mxSetFieldByNumber(mx,0,0,mxCreateString('Voleur'));
  mxSetFieldByNumber(mx,0,1,mxCreateString('Chevaux'));

  saveMxArrayToMatFile(mx,'D:\testest.mat','DumDum',false);
end;


procedure testHDF5dll;
var
   file_id, dataset_id : hid_t ;
   status: herr_t;
   i, j:integer;
   dset_data: array[0..3,0..5] of integer;

   st: AnsiString;
   stObj: AnsiString;
   stAttName: AnsiString;
   stAtt: AnsiString;
   error: integer;

   dims: hsize_t;
   type_class: H5T_class_t;
   type_size: size_t;

begin

  if not InitHdf5 then messageCentral('hdf5 = false');
  if not InitHdf5_lite then messageCentral('hdf5_lite=false');


  st:='D:\Dac2\Yannick\Test phy 2016\BLOCKNAME_MST82_ele1_ele64.kwik';

  with hdf5 do
  begin
     // Open an existing file.
     file_id := H5Fopen(@st[1], H5F_ACC_RDONLY, H5P_DEFAULT);

     setLength(stAtt,20);
     for i:= 1 to length(stAtt) do stAtt[i]:='.';

     error:= H5LTget_attribute_info( file_id,'/','creator_version',
                                    @dims, type_class, type_size);

     messageCentral('dims='+Istr(dims)+crlf+
                          'type_class='+Istr(ord(type_class))+crlf+
                          'type_size='+Istr(type_size));
     setLength(stAtt,type_size);
     error:= H5LTget_attribute_string(file_id,'/','creator_version' ,@stAtt[1]);
     messageCentral(stAtt + '  '+Istr(error));

     error:= H5LTget_attribute_string(file_id,'/application_data/spikedetekt/','detect_spikes' ,@stAtt[1]);
     messageCentral(stAtt + '  '+Istr(error));


     // Close the file.
     status := H5Fclose(file_id);
  end;



end;




procedure TMainDac.Debug1Click(Sender: TObject);
var
  buf: pointer;
  bufsize: integer;
  i: integer;
  status,nb1,nb2: integer;
const                                                 
  max=200000;                                     
  size=1000;
begin
  for i:=1 to 10000000 do
  begin
    nb1:=1000+i;
    nb2:=35;
    status := ippsConvolveGetBufferSize(nb1, nb2, _ipp32f, ippAlgAuto, @bufSize);
    if (status<>0) or (bufSize=0) then
    begin
      messageCentral('status='+Istr(status) + '   bufSize='+Istr(bufSize)+'  i='+Istr(i)+' --'+Istr(ord(_ipp64f)));
      break;
    end;
  end;
  messageCentral('OK    bufSize='+Istr(bufSize));
end;



procedure TMainDac.LoadBinaryFile1Click(Sender: TObject);
begin
  if Running then exit;

  with TdataFile(dacDataFile) do
  begin
    DloadBinaryFile;
    //MRUdat.addItem(stFichier);
    //stDatHistory:=MRUdat.Text;
  end;;

end;

procedure TMainDac.Parameters1Click(Sender: TObject);
begin
  with TdataFile(dacDataFile) do
  begin
    GetBinaryFileParams;
  end;;


end;

Initialization
AffDebug('Initialization mdac',0);

end.


