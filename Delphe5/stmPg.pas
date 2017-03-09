unit stmPG;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,forms,controls,menus,stdCtrls,messages,Dialogs,
     sysutils, math,

     util1,Gdos,DdosFich,Dgraphic,
     formMenu,

     stmDef,stmObj,
     varconf1,
     debug0,
     stmError,Npopup,formRec0,

     Ncdef2,
     Ncompil3,
     {$IFDEF WIN64} Nexe64 {$ELSE} Nexe3 {$ENDIF} ,
     symbac3,
     dacadp2,adProc2,
     {$IFDEF FPC} Gedit5fpc {$ELSE} Gedit5 {$ENDIF} ,
     comPg1,
     listG,
     pgc0,
     evalvar1,
     stmFifoError;

     {stmMark0,stmObv0,stmVS0; dans implementation }


type
  TProcessPhase=(Phase_init0,Phase_init,Phase_Process,Phase_end,phase_Cont,Phase_Global);
  setOfProcessPhase=set Of TProcessPhase;
var
  ProcessPhase: TProcessPhase;

type
  TarrayOfFloat=array of float;

  TbreakPoint= record
                 ad: integer;
                 line: integer;
                 stFile: string[255];
               end;
  PbreakPoint= ^TbreakPoint;

  TbreakPointList=
         class(TlistG)
            constructor create;
            function Add(ad1,line1:integer; stF:string): Integer;
            function GetBreakPoint(Index: Integer): PbreakPoint;
            property BreakPoint[index:integer]: PbreakPoint read GetBreakPoint; default;
            function IsBreakPoint(n:integer): PbreakPoint;
         end;

type
  TPG2=  class(TypeUO)
           private
             Gedit:Tedit5;
             inspectVar:TconsoleE;
             pgContext:TpgContext;

             pgCom:TpgCommand;

             Xerror:  integer;      { Dernier code d'erreur: 0=pas d'erreur;  -1 si Shift-Escape }
             XAdError:integer;
             PosError:integer;

             FormRecEdit,FormRecCom:Tformrec;
             FormRecEditCom:TformRec;

             numeroCompilation:integer;

             CpList:TlistG; {Maintient une liste d'actions à entreprendre quand le
                             programme se termine}
             Title0:AnsiString;
             stFileNames:AnsiString;
             primaryFile0:AnsiString;
             primaryFdate: integer;
             fontDesc,PfontDesc:TfontDescriptor;
             stEval:AnsiString;

             ProcT00,ProcT0,ProcT1,ProcT2:integer;

             childPg:Tpg2;
             FshowMenu:boolean;


             BKpt: TbreakPointList;
             LastProcU:integer;

             procedure compilerPg(stSource:AnsiString;var error:AnsiString;var lig,col:integer;
                                  var stfile:AnsiString;Fbuild:boolean);
             procedure installPopUp(ok:boolean);
             procedure showPgMenu;

             function executerProgX(p:pointer): boolean;
             procedure executerProcT(p:integer);

             procedure ErreurExe(posErr:integer);
             procedure ProcessMessage(id:integer;source:typeUO;p:pointer);
               override;

             procedure FreeObj(var p:pointer);
             function ObjHasName(p:pointer;st:AnsiString):boolean;

             procedure setXpos(x:integer);
             procedure setYpos(y:integer);

             function getXpos:integer;
             function getYpos:integer;

             function getNumProc(st:AnsiString):integer;

             procedure executeCpList(num1:integer);
             procedure executeTerminationList;
             function getPrimaryFile:AnsiString;
             procedure setPrimaryFile(st:AnsiString);
             procedure clearPrimaryFile;

             procedure EvaluerVar(st:AnsiString);
             procedure ShowCompHis;

             procedure getLocalCount(var nbObj,nbSt,nbgvar:integer);
             procedure FreeLocal(nbObj,nbSt,nbgvar:integer);

             procedure ExecutePg;
             procedure DebugPg(p: PtUlex; NumP,AdP:integer);
             function HintPg(st:string):string;
             procedure FindDecPg(st:string);

             procedure StepOver;
             procedure TraceInto;
             procedure StopDebugPg;

             procedure BuildBkPtList;
             procedure AddBreakPoint;
             procedure ClearBreakPoints;

             
           public
             localObj,localString,LocalVariant:Tlist;

             finExeUpg2: boolean;
             // Novembre 2012: auparavant finExeU arrêtait seulement le programme en cours
             // par exemple, si on stoppait un gestionnaire d'événement, le programme principal continuait à tourner
             // L'idée est d'utiliser le même booléen pour tous les blocs exécutés dans un PG2

             ProcessPhase: TProcessPhase;
             constructor create;override;
             destructor destroy;override;

             class function STMClassName:AnsiString;override;

             procedure show(sender:Tobject);override;
             procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
                override;
             procedure completeLoadInfo;override;
             procedure resetAll;override;

             function initialise(st:AnsiString):boolean;override;

             procedure popExecute(p:integer);
             procedure MenuExecute(p:integer);

             function executerProc(proc:pointer): boolean;


             procedure traitement00;
             procedure traitement0;
             procedure traitement1;
             procedure traitement2;
             procedure traitementCont;

             function Ftraitement00:boolean;
             function Ftraitement0:boolean;
             function Ftraitement1:boolean;
             function Ftraitement2:boolean;
             function FtraitementCont:boolean;

             procedure ManageProcedure(ad:integer);
             procedure ManageProcedure1(ad,num:integer);

             procedure executerProcedure(ad:integer);
             procedure executerProcedure1(ad,num:integer);
             function executerFunctionB(ad:integer): boolean;

             procedure executerProcedure2(ad,num1,num2:integer);
             procedure executerProcedure2I1F(ad,num1,num2:integer;float1:float);


             procedure executerBuildEp(ad:integer;seq:integer;var vec:typeUO);
             procedure executerGetPointColor(ad:integer;ind:integer;var col:integer);
             procedure executerOnDragDrop(ad:integer;var vec:typeUO;x,y:float);
             procedure executerMatSelect(ad:integer;var mat:typeUO;x,y:integer);
             procedure executerMatHint(ad:integer;var mat:typeUO;x,y:float;var stH:AnsiString);
             procedure executerVlistSelect(ad:integer;var Vlist:typeUO;n:integer);

             procedure executerMouseUpMg(ad:integer;var mg,plot:typeUO);
             procedure executerPopUpClick(ad:integer;var plot:typeUO);

             procedure executerOnServerEvent(ad:integer;var buffer:typeUO);

             function executerRFunc(ad:integer;tb:PtabFloat1;nb:integer):float;
             function executerGetK(ad:integer;tt,z:integer;w:float):float;

             function PlexInit:integer;
             function PlexTrait:integer;
             function PlexFin:integer;
             function PlexInit0:integer;
             function PlexCont:integer;
             function PlexProgram:TstringList;
             function loadPgNames(stf:AnsiString):boolean;

             procedure showPopUp;
             procedure showEditor;
             procedure executeTool;

             property Xpos:integer read getXpos write setXpos;
             property Ypos:integer read getYpos write setYpos;

             function NomParDefaut(var pu:typeUO):AnsiString;
             function NomControle(var pu:typeUO;name:AnsiString):AnsiString;

             procedure StopProgram;
             procedure ActiveProgram;

             procedure AddToCpList(p:procedureOfObject);

             procedure setTitle(st:AnsiString);override;
             function getTitle:AnsiString;override;

             function assignObject(st:AnsiString;var pu:typeUO):integer;

             function primaryFile:AnsiString;

             procedure resetProgram;
             function VarClass(var pu:typeUO):TUOclass;

             function IsMyVar(var pu:typeUO):boolean;
             function getProcInfo(ad:integer;var st:AnsiString):PdefSymbole;

             procedure InstallProcT(p00,p0,p1,p2:integer);

             procedure HideNextPopUp;

             procedure executePgCommand(st:AnsiString);
             function LoadAndInstallPrimary(st:AnsiString):boolean;

             function FindPgContext(stFile: AnsiString): TPG2;

             procedure ProcessInspLine(st:AnsiString; EditSrc: Tedit5);
             procedure ProcessInspLine1(st: AnsiString; Pg2Src: Tpg2);
             function ProcessInspLine2(st: AnsiString; Pg2Src: Tpg2;var stOut: AnsiString):boolean;

             procedure ShowCommandWindow;

             property LastError: integer read Xerror;

             procedure ShowFile(stFile: Ansistring;lig:integer);

             function DepToP(n:integer):pointer;
             function PtoDep(p:pointer):intG;
             procedure SetDebugMode(w: boolean);
             procedure ToggleDebugMode;

             procedure ProcessProcedure(message:Tmessage);
             procedure ProcessProcedure1(message:Tmessage);

             procedure CheckEditorFiles;
             procedure setUserShortcuts(w:boolean);
           end;

{ Tpg2Event permet d'introduire les gestionnaires d'événement Pg2.
  ad est une adresse de procédure Pg2
  A chaque affectation, on range le numero de compilation dans numero. Ce qui permet
  de vérifier la validité de l'adresse: si numero est différent de NumeroCompilation,
  l'adresse n'est plus valable.
  On part du principe que setAd est appelé uniquement par un programme pg2, activeMacro
  indique alors le programme TPG2 concerné.
}
  Tpg2Event=object
              numero:integer;
              Ad:integer;    {depuis le 19-12, adresse absolue de la procédure}
              Pg:TPG2;
              procedure setAd(adresse:integer);
              function valid:boolean;
            end;
  PPG2event=^Tpg2Event;

const
  maxPg2ShortCut=10;

type
  Tpg2ShortCuts=class
                  pg2Ev:  array[1..maxPg2ShortCut] of Tpg2Event;
                  vk1,vk2:array[1..maxPg2ShortCut] of integer;
                  tp:     array[1..maxPg2ShortCut] of byte;
                  procedure add(adproc,v1,v2:integer;tpProc:integer);
                  procedure validate;
                  procedure invalidate;
                  procedure execute(num:integer);
                end;

var
  ShortCuts:Tpg2ShortCuts;

  TerminationList:TlistG;

procedure proInstallShortcut(adproc:integer;vk1,vk2:integer);pascal;
procedure proInstallShortcut1(adproc:integer;vk1,vk2:integer);pascal;
procedure proResetShortcuts;pascal;


procedure proTobject_free(var pu:typeUO);pascal;

procedure createPgObject(name:AnsiString;var pu:typeUO;tp:TUOclass);

procedure proTobject_assign(st:AnsiString;var pu:typeUO);pascal;


procedure controleProcessPhase(phase:setOfProcessPhase);

procedure AddToCpList(p:procedureOfObject);
{Ajoute une action à la liste d'actions à entreprendre quand la macro active
 se terminera.
 Seuls les objets permanents peuvent introduire des actions dans cette liste.
 La liste est vidée à chaque fois que le programme se termine.

 Utilisé dans FXctrl0 : TFXcontrol.opendata
}

procedure AddToTerminationList(p:procedureOfObject);
{Ajoute une action à la liste d'actions à entreprendre quand un programme
 se termine.
 Ces actions sont permanentes contrairement aux actions de CpList.

 Utilisé par TvisualStim
}
procedure RemoveFromTerminationList(p:procedureOfObject);

function TesterFinPg:boolean;
{Utilisée par les fonctions stm qui durent longtemps et souhaitent tester
 Shift-Escape}

function QuestionFinPg:boolean;
{Utilisée par FXctrl0}



procedure proTobject_clone_1(st:AnsiString;var modele:typeUO;var pu:typeUO);pascal;
procedure proTobject_clone(var modele:typeUO;var pu:typeUO);pascal;

procedure proTobject_CopyObject(var modele:typeUO;Fdata:boolean;var pu:typeUO);pascal;

{ ActiveMacro est la macro en cours d'exécution. La variable est mise en place
par la macro et CreatePgObject l'utilise pour affecter Owner.
}
var
  ActiveMacro:TPG2;


procedure proTmacro_create(stF:AnsiString;var pu:typeUO);pascal;
procedure proTmacro_executeCommand(st:AnsiString;var pu:typeUO);pascal;
procedure proTmacro_showMenu(var pu:typeUO);pascal;
procedure proTmacro_showMenu_1(FshowMenu:boolean;var pu:typeUO);pascal;
procedure proTmacro_reset(var pu:typeUO);pascal;

function fonctionTmacro_path(var pu:typeUO): AnsiString;pascal;
function fonctionTmacro_fileName(var pu:typeUO): AnsiString;pascal;


procedure proReleasePgMenu;pascal;

var
  NumTransType1, NumTransType2:integer;

function FonctionTranstype1(st:AnsiString;NumObj:integer):pointer;pascal;
function FonctionTranstype2(var uo:typeUO;NumObj:integer):pointer;pascal;

implementation

uses stmMark0,stmObv0,stmVS0,
     AcqBrd1,RTneuronBrd,
     acqDef2;

const
  stImplicit='system'+
             '|multigraph0'+
             '|dataFile0'+
             '|realArray0'+
             '|Acquis1';


var
  pgList:Tlist;

constructor TPG2.create;
var
  stH:AnsiString;
begin
  inherited;

  Gedit:=Tedit5.create(formStm);
  Gedit.formStyle:=fsStayOnTop;

  inspectVar:=TconsoleE.Create(formstm);
  inspectvar.Init(Gedit);
  inspectvar.ProcessLine:=ProcessInspLine;

  pgContext:=TpgContext.create(tabProc2,adresseProcedure,formStm,ident,stImplicit);

  pgContext.tableSymbole.freeThisObject:=freeObj;
  pgContext.tableSymbole.ObjectHasName:=ObjHasName;

  with Gedit do
  begin
    compilerPg:=self.compilerPg;

    CodePg:=pgContext.DisplayPgCode;
    SymbolePg:=pgContext.tableSymbole.DisplayTable;
    AdlistPg:=pgContext.DisplayAdList;
    UlistPg:=pgContext.DisplayUList;

    getPrimary:=getPrimaryFile;
    setPrimary:=setPrimaryFile;
    clearPrimary:=ClearPrimaryFile;

    InfoPg:=pgContext.InfoCode;

    executePg:=self.ExecutePg;
    ToggleDebugMode:= self.ToggleDebugMode;
    StepOver:= self.StepOver;
    TraceInto:= self.TraceInto;
    StopDebugPg:= self.StopDebugPg;
    AddBreakPoint:=self.AddBreakPoint;
    ClearBreakPoint:=self.ClearBreakPoints;

    HintPg:= self.HintPg;
    FindDecPg:=self.FindDecPg;

    EvalPg:=EvaluerVar;
    resetPg:=resetProgram;
    DisplayErrors:=fifoError.DisplayHistory;
    ShowCommandPg:=ShowCommandWindow;

    compHistory:=ShowCompHis;

    installHelp(tabProc2, AppDir +'elphy.chm');

    setUserShortcuts:= self.setUserShortcuts;
  end;

  PgCom:=TpgCommand.create(formStm);
  PgCom.showEdit:=Gedit.show;
  PgCom.messageErreurPg:=erreurExe;

  pgList.add(self);
  processPhase:=phase_global;

  CpList:=TlistG.create(sizeof(procedureOfObject));

  LocalObj:=Tlist.Create;
  LocalString:=Tlist.Create;
  LocalVariant:=Tlist.Create;

  BKpt:=TbreakPointList.create;

end;

function TPG2.DepToP(n: integer): pointer;
begin
  if n>=0
    then result:=pointer( intG(pgContext.cs)+ n)
    else result:=nil;
end;

function TPG2.PtoDep(p:pointer):intG;
begin
  result:= intG(p)-intG(pgContext.cs);
end;

destructor TPG2.destroy;
begin
  pgContext.free;
  inspectVar.Free;
  Gedit.free;
  PgCom.free;
  pgList.remove(self);
  LocalObj.Free;
  LocalString.Free;
  LocalVariant.Free;

  BKpt.free;

  inherited;
end;


class function TPG2.STMClassName:AnsiString;
begin
  result:='Macro';
end;


procedure TPG2.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildinfo(conf,lecture,tout);

  formRecEdit.setForm(Gedit);
  formRecCom.setForm(PgCom);
  formRecEditCom.setForm(Inspectvar);

  if not lecture then
    begin
      fontToDesc(Gedit.TheFont,fontDesc);
      fontToDesc(Gedit.PrintFont,PfontDesc);

      if fileExists(PrimaryFile0) then PrimaryFdate:=fileAge(PrimaryFile0);
    end;

  with conf do
  begin
    stfileNames:=Gedit.fileNames;

    setStringConf('FileName',stfileNames);
    setStringConf('PrimaryFile',PrimaryFile0);
    setVarConf('PrimaryFdate',PrimaryFdate,sizeof(PrimaryFdate));

    setStringConf('stEval',stEval);

    setvarconf('FormRecE',FormRecEdit,sizeof(FormRecEdit));
    setvarconf('FormRecC',FormRecCom,sizeof(FormRecCom));
    setvarconf('FormRecI',FormRecEditCom,sizeof(FormRecEditCom));

    setStringConf('LastFile',Gedit.lastFile);

    setStringConf('Title',title0);
    setvarConf('Font',FontDesc,sizeof(FontDesc));
    setvarConf('PFont',PFontDesc,sizeof(PFontDesc));
  end;
end;

procedure TPG2.completeLoadInfo;
var
  stPgc:AnsiString;
  st:AnsiString;
begin
  CheckOldIdent;

  if ident=stPg0 then
    begin
      formRecCom.visible:=false;
      PgCom.ComVisible:=false;
    end;

  formRecEdit.restoreForm(Tform(Gedit),nil);
  descToFont(fontDesc,Gedit.TheFont);
  descToFont(PfontDesc,Gedit.PrintFont);

  Gedit.setHighLighterColors;

  formRecEditCom.restoreForm(Tform(InspectVar),nil);
  inspectvar.Init(Gedit);

  formRecCom.restoreForm(Tform(PgCom),nil);

  pgContext.ownerName:=ident;

  if title0='' then title0:=ident;

  { Chercher PrimaryFile0 dans le même répertoire que stCfg }
  st:=extractFilePath(stCfg)+extractFileName(primaryfile0);
  if fichierExiste(st) and (PrimaryFdate=FileAge(st)) then primaryFile0:=st;

  { S'il n'existe pas, on garde le répertoire d'origine }
  if not fichierExiste(PrimaryFile0) then PrimaryFile0:='';
end;

procedure TPG2.resetAll;
var
  error: AnsiString;
  lig,col:integer;
  stFile:AnsiString;
  st,stPgc:AnsiString;
  loadOk:boolean;
begin
  Gedit.caption0:=ident;
  Gedit.caption:=ident;

  if ident=stPg0 then
    begin
      {nomTextePg permet de récupérer les anciennes config}
      if (nomTextePg<>'') then
        begin
          st:=extractFilePath(stCfg)+extractFileName(nomTextePg);
          if fichierExiste(st) then Gedit.FileNames:=st
          else
          if fichierExiste(nomTextePg) then Gedit.FileNames:=nomTextePg;
        end
      else
      Gedit.fileNames:= stfileNames;
    end
  else
  Gedit.FileNames:=stfileNames;

  if primaryfile0<>''
    then Gedit.installFile(primaryfile0,false);

  Gedit.stPrimary:=PrimaryFile;

  if primaryFile<>'' then
  begin
    loadOK:=Pgcontext.loadPg(PrimaryFile);

    if loadOK then
      begin
        inc(numeroCompilation);
        InstallProcT(0,0,0,0);
        ExecuterProgX(pgContext.cs);
        if Xerror>0 then messageCentral('Error while initializing '+PrimaryFile);
        installPopUp(true);
      end
    else
      begin
        compilerPg(primaryFile,error,lig,col,stFile,true);
        if error<>'' then Gedit.forcerPosition(lig,col,stFile,1);
      end;
  end;


  Gedit.adpMRU1.Text:=stTxtHistory;

  inspectvar.Caption:=ident+' commands';
end;

function TPG2.getNumProc(st:AnsiString):integer;
begin
  if assigned(tabProc2) then result:=tabProc2.getNumProcHlp(st);
end;



procedure TPG2.compilerPg(stSource:AnsiString;var error:AnsiString;var lig,col:integer;var stfile:AnsiString;
                          Fbuild:boolean );
var
  i:integer;
begin
  if TestDebugMode then exit;

  Pg2CurrentPath:=extractFilePath(stSource);

  if not assigned(tabProc2) then
    begin
      messageCentral('PRC file not installed');
      exit;
    end;

  with Gedit do
  begin
    saveAll1Click(nil);
    ResetError;
    ResetStepLine;
  end;
  compHis.clear;

  pgContext.compiler(stSource,error,lig,col,stfile,Fbuild);
  clearMainUsesList;
  inc(numeroCompilation);
  InstallProcT(0,0,0,0);

  if error='' then
    begin
      ExecuterProgX(pgContext.cs);
      if Xerror>0 then messageCentral('Error while initializing '+stSource);
    end
  else Gedit.stLastError:=pgContext.stError;

  installPopUp(error='');
  shortCuts.invalidate;

  if board is TRTNIinterface then TRTNIinterface(board).RestartNeuron;
end;

procedure TPG2.show(sender:Tobject);
begin

  PgCom.show;
end;

procedure TPG2.ErreurExe(posErr:integer);
var
  ad:integer;
  st:AnsiString;
  ligne,AdError:integer;
  boiteInfo:typeBoiteInfo;
  stF:String;
begin
  if acquisitionON then FlagStop:=true;

  st:= FifoError.get(posErr, stF, ligne,AdError);

  Gedit.stlastError:= 'ERROR at '+Istr(integer(adError))+CRLF+
                      st+CRLF+
                      'in '+stF +' line '+Istr(ligne) ;

  messageCentral(Gedit.stlastError);

  if stF<>'?' then
    begin
      Gedit.forcerLigne(stF,ligne,false,2);
      if Gedit.visible then Gedit.show;
    end;
end;

function TPG2.ExecuterProgX(p:pointer): boolean;
var
  stError:AnsiString;
  stF:Ansistring;
  ligne: integer;
  OldMacro:Tpg2;
  debugPg1: TelphyDebugPg;
  i,j, ad1, curAd, NumProg:integer;
const
  flag:boolean=false;
begin
  TRY
  //if Flag then exit;
  flag:=true;

  setExceptionMask(ExceptionMask0);

  Xerror:=0;
  XadError:=0;
  if (p=nil) then exit;

  OldMacro:=ActiveMacro;
  ActiveMacro:=self;
  Gedit.ResetError;
  Gedit.ResetStepLine;

  LastProcU:=0;
  // Quand on reste dans le meme pg2, on ne met pas finExeU à false
  if ActiveMacro<>OldMacro then FinExeUpg2:=false;

  BuildBkPtList;

  if FDebugMode
    then DebugPg1:=DebugPg
    else DebugPg1:=nil;

  with PgContext do
  result:= executerProg(cs,ds,p,Xerror,XAdError,FinExeUpg2,adresseProcedure.adr, getLocalCount, FreeLocal,localString, LocalVariant, DebugPg1);

  ActiveMacro:=OldMacro;

  if Xerror>0 then
  begin
    if Xerror=1 then stError:=getStdError
                else stError:=getErrorString(Xerror);

    if stError='' then stError:='Run Time error '+Istr(Xerror);

    ligne:=PgContext.getLine(XadError,stF,CurAd,NumProg);
    posError:=fifoError.put(stError,XAderror,ligne,stF);
  end;
  FINALLY
  flag:=false;
  END;
end;

function Tpg2.executerProc(proc:pointer): boolean; {Pointeur sur une zone de code}
var
  IdCpList:integer;
begin
  IdCplist:=CpList.count;

  executerProgX(proc);// (intG(proc)-intG(pgContext.CS));
  if Xerror>0 then postMessage(PgCom.handle,msg_EndExecute,Xerror,PosError);

  executeCpList(IdCpList);
  executeTerminationList;

end;

procedure Tpg2.executerProcT(p:integer);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do
  begin
    genre:=procU;
    adU:=p;
    nbParU:=0;
  end;

  executerProgX(@prog); //intG(@prog)-intG(pgContext.CS));
end;

procedure TPG2.popExecute(p:integer);
begin
  StepMode:=0;
  pgCom.FhidePgPopUp:=false;
  {Quand l'utilisateur clique sur le menu popup, cette méthode est exécutée.}
  CpList.clear;
  executerProgX(deptoP(p));
  postMessage(PgCom.handle,msg_EndExecute,Xerror,Poserror);
  {On poste un message qui va provoquer soit la réouverture du menu, soit
  l'affichage d'un message d'erreur}

  ExecuteCpList(0);
  executeTerminationList;
end;

procedure TPG2.MenuExecute(p:integer);
begin
  pgCom.FhidePgPopUp:=TRUE;
  { Identique à la commande précédente mais le popup n'est pas réaffiché
    Appelé par TmacroManager ( Imacro1.pas )
  }
  CpList.clear;
  executerProgX(deptoP(p));
  postMessage(PgCom.handle,msg_EndExecute,Xerror,Poserror);
  {On poste un message qui va provoquer soit la réouverture du menu, soit
  l'affichage d'un message d'erreur}

  ExecuteCpList(0);
  executeTerminationList;
end;


procedure TPG2.executePgCommand(st:AnsiString);
var
  i:integer;
begin
  with pgContext do
  begin
    i:=pgContext.PlexProgram.IndexOf(st);
    if i>=0 then executerProgX(deptoP(intG(PlexProgram.Objects[i])));
  end;
end;




procedure TPG2.installPopUp(ok:boolean);
var
  i:integer;
begin
  with PgCom do
  begin
    setTitle(ident);

    popPg.clear;

    if ok then
      begin
        with pgContext.PlexProgram do
        for i:=0 to count-1 do PopPg.addObject(strings[i],objects[i]);

        popPg.buildPopupMenu;

        popPg.executeD:=popExecute;
      end;
  end;
end;

procedure TPG2.showPgMenu;
begin
  PgCom.showPopUp;
end;

procedure TPG2.ExecuteTool;
begin
  if PlexProgram.Count>0 then executerProgX(depToP(intG(PlexProgram.Objects[0])));
end;

function TPG2.initialise(st:AnsiString):boolean;
begin
  result:=inherited initialise(st);
  PgCom.setTitle(ident);
  Gedit.caption0:=ident;
  Gedit.caption:=ident;
  title0:=ident;

  PgCom.ComVisible:=(ident<>stPg0);
  pgContext.ownerName:=ident;

  if st=stPg0 then FinexeU:=@finExeUpg2;
end;

procedure TPG2.ProcessMessage(id:integer;source:typeUO;p:pointer);
begin
  if id=UOmsg_destroy then
  begin
    if source is Tpg2 then childPg:=nil
    else
    pgContext.tableSymbole.clearObject(source);
  end
  else
  if id=UOmsg_ReleaseMenu then
  begin
    if (source=childPg) and FshowMenu then PgCom.showPopUp;
    childPg:=nil;
    FshowMenu:=false;
  end;

end;

procedure Tpg2.FreeObj(var p:pointer);
begin
  if assigned(p) then
    begin
      if typeUO(p).UOowner=self then typeUO(p).free
      else derefObjet(typeUO(p));
    end;
  p:=nil;
end;

function Tpg2.ObjHasName(p:pointer;st:AnsiString):boolean;
begin
  result:=(typeUO(p^).ident=st);
end;


{TesterFin est appelé par Nexe2 entre chaque instruction}
function TesterFin:boolean;
var
  ad,line:integer;
  CurAd,NumProg: integer;
  stF:AnsiString;
begin
  result:=false;

  if getFlagClock(1) then
    if testShiftEscape(formstm.Handle) then
      begin
        ad:=getCurrentExeAd;
        line:=activeMacro.pgContext.getLine(Ad,stF,CurAd,NumProg);
        stF:='Ad='+Istr(ad)+' Line '+Istr(line)+' in '+stF;
        if messageDlg('Stop program? '+crlf+stF,mtConfirmation,[mbYes,mbNo],0)=mrYes then
          result:=true;
      end;
  if result and exeON then flagStop:=true;
end;


function QuestionFinPg:boolean;
var
  ad,line,CurAd,NumProg:integer;
  stF:AnsiString;
begin
  ad:=getCurrentExeAd;
  line:=activeMacro.pgContext.getLine(Ad,stF,CurAd,NumProg);
  stF:='Ad='+Istr(ad)+' Line '+Istr(line)+' in '+stF;

  result:= messageDlg('Stop program? '+crlf+stF,mtConfirmation,[mbYes,mbNo],0)=mrYes ;

  {$IFDEF WIN64}
  result:= windows.MessageBox(0,PChar('Stop program? '+crlf+stF) ,'Elphy64',MB_ICONQUESTION or MB_YESNO or MB_taskMODAL or MB_TOPMOST)=IDYES;
  {$ELSE}
  result:= windows.MessageBox(0,PChar('Stop program? '+crlf+stF) ,'Elphy2',MB_ICONQUESTION or MB_YESNO or MB_taskMODAL or MB_TOPMOST)=IDYES;
  {$ENDIF}

  finExeU^:=result;
  finExe:=result;

  if result and acquisitionON then flagStop:=true;
end;

function TesterFinPg:boolean;
begin
  result:=testShiftEscape and  (not exeON or QuestionFinPg) ;
end;



procedure Tpg2.traitement00;
begin
  processPhase:=phase_init0;
  if procT00>0
    then ExecuterProcT(procT00)
    else ExecuterProgX(deptoP(pgContext.plexInit0));
  processPhase:=phase_global;
  if Xerror>0 then postMessage(PgCom.handle,msg_EndExecute,Xerror,PosError);
end;

procedure Tpg2.traitement0;
begin
  processPhase:=phase_init;
  if procT0>0
    then ExecuterProcT(procT0)
    else ExecuterProgX(deptoP(pgContext.plexInit));
  processPhase:=phase_global;
  if Xerror<>0 then postMessage(PgCom.handle,msg_EndExecute,Xerror,PosError);
end;

procedure Tpg2.traitement1;
begin
  processPhase:=phase_process;
  if procT1>0
    then ExecuterProcT(procT1)
    else ExecuterProgX(depToP(pgContext.plexTrait));
  processPhase:=phase_global;
  if Xerror>0 then postMessage(PgCom.handle,msg_EndExecute,Xerror,PosError);
end;

procedure Tpg2.traitement2;
begin
  processPhase:=phase_end;
  if procT2>0
    then ExecuterProcT(procT2)
    else ExecuterProgX(deptoP(pgContext.plexFin));
  processPhase:=phase_global;
  if Xerror>0 then postMessage(PgCom.handle,msg_EndExecute,Xerror,PosError);
end;

procedure Tpg2.traitementCont;
begin
  processPhase:=phase_cont;
  ExecuterProgX(deptoP(pgContext.plexCont));
  processPhase:=phase_global;
  if Xerror >0 then postMessage(PgCom.handle,msg_EndExecute,Xerror,PosError);
end;

function Tpg2.Ftraitement00:boolean;
begin
  result:=(pgContext.plexInit0<>-1) or (ProcT00>0);
end;

function Tpg2.Ftraitement0:boolean;
begin
  result:=(pgContext.plexInit<>-1)  or (ProcT0>0);
end;

function Tpg2.Ftraitement1:boolean;
begin
  result:=(pgContext.plexTrait<>-1)  or (ProcT1>0);
end;

function Tpg2.Ftraitement2:boolean;
begin
  result:=(pgContext.plexFin<>-1)  or (ProcT2>0);
end;

function Tpg2.FtraitementCont:boolean;
begin
  result:=pgContext.plexCont<>-1;
end;

// En mode Debug, on s'efforce d'éviter les appels  multiples
procedure Tpg2.ManageProcedure(ad:integer);
const
  flag:boolean=false;
begin
  if flag then exit; //éviter la réentrance
  flag:=true;

  if not FdebugMode then executerProcedure(ad)
  else
  if not FstoppedState then postMessage(formstm.handle,msg_Procedure,ad,0);
  flag:=false;
end;

procedure Tpg2.executerProcedure(ad:integer); {ad=déplacement par rapport à cs}
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=0;
  end;

  executerProc(pprog);
end;

procedure Tpg2.ManageProcedure1(ad,num:integer);
const
  flag:boolean=false;
begin
  //if flag then exit; //éviter la réentrance
  //flag:=true;

  if not FdebugMode then executerProcedure1(ad,num)
  else
  if not FstoppedState then postMessage(formstm.handle,msg_Procedure1,ad,num);

  //flag:=false;
end;


{Tprocedure1=procedure(num:longint);}
procedure TPG2.executerProcedure1(ad,num:integer);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=1;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbL;
    vnbl:=num;
  end;

  executerProc(pprog);
end;

function TPG2.executerFunctionB(ad:integer):boolean;
var
  prog:array[1..1000] of byte;
  pprog,plex:ptUlex;
  i:integer;
  x:boolean;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  plex^.genre:=affectVar;
  plex:=UlexSuivant(plex);

  with plex^ do
  begin
    genre:=refSys;
    adSys:=@x;
    tpSys:=nbBoole;
  end;

  plex:=UlexSuivant(plex);

  with plex^ do
  begin
    genre:=foncU;
    adU:=ad;
    nbParU:=0;
    tpres1:=nbBoole;
  end;

  executerProc(pprog);
  result:=x;
end;

{Tprocedure2=procedure(num1,num2:longint);}
procedure TPG2.executerProcedure2(ad,num1,num2:integer);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=2;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbL;
    vnbl:=num1;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbL;
    vnbl:=num2;
  end;

  executerProc(pprog);
end;

procedure TPG2.executerProcedure2I1F(ad,num1,num2:integer;float1:float);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=3;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbL;
    vnbl:=num1;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbL;
    vnbl:=num2;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbExtended;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbR;
    vnbR:=float1;
  end;

  executerProc(pprog);
end;




{TmatSelect=procedure(var mat:Tmatrix;x,y:integer); }
procedure TPG2.executerMatSelect(ad:integer;var mat:typeUO;x,y:integer);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do                 {ProcU }
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=3;
  end;


  plex:=UlexSuivant(plex);      { Paramètre Mat }
  with plex^ do
  begin
    genre:=param;
    tpParam:=refObject;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=variObject;
    Vob:= 0; {nomDesObjets.indexof('TMATRIX');}
    adOb:=intG(@mat.myAd)-intG(pgContext.ds);
  end;

  plex:=UlexSuivant(plex);    { Paramètre x }
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbL;
    vnbl:=x;
  end;

  plex:=UlexSuivant(plex);    { Paramètre y }
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbL;
    vnbl:=y;
  end;

  executerProc(pprog);
end;

{TmatHint=procedure(var mat:Tmatrix;x,y:integer;var stH:AnsiString); }
procedure TPG2.executerMatHint(ad:integer;var mat:typeUO;x,y:float;var stH:AnsiString);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do                 {ProcU }
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=4;
  end;


  plex:=UlexSuivant(plex);      { Paramètre Mat }
  with plex^ do
  begin
    genre:=param;
    tpParam:=refObject;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=variObject;
    Vob:=0; { nomDesObjets.indexof('TMATRIX');}
    adOb:=intG(@mat.myAd)-intG(pgContext.ds);
  end;

  plex:=UlexSuivant(plex);    { Paramètre x }
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbExtended;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbR;
    vnbr:=x;
  end;

  plex:=UlexSuivant(plex);    { Paramètre y }
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbExtended;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbr;
    vnbr:=y;
  end;

  plex:=UlexSuivant(plex);    { Paramètre stH }
  with plex^ do
  begin
    genre:=param;
    tpParam:=refAnsiString;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=variAnsiString;
    adV:=intG(@stH)-intG(pgContext.ds);
  end;

  executerProc(pprog);
end;



{TVlistSelect=procedure(var Vlist:TVlist0;n:integer); }
procedure TPG2.executerVlistSelect(ad:integer;var Vlist:typeUO;n:integer);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do                 {ProcU }
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=2;
  end;


  plex:=UlexSuivant(plex);      { Paramètre Vlist }
  with plex^ do
  begin
    genre:=param;
    tpParam:=refObject;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=variObject;
    Vob:= 0; {nomDesObjets.indexof('TVLIST0');}
    adOb:=intG(@Vlist.myAd)-intG(pgContext.ds);
  end;

  plex:=UlexSuivant(plex);    { Paramètre n }
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbL;
    vnbl:=n;
  end;

  executerProc(pprog);
end;

procedure TPG2.executerMouseUpMg(ad:integer;var mg,plot:typeUO);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do                 {ProcU }
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=2;
  end;


  plex:=UlexSuivant(plex);      { Paramètre Mg }
  with plex^ do
  begin
    genre:=param;
    tpParam:=refObject;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=variObject;
    Vob:= 0;
    adOb:=intG(@mg.myAd)-intG(pgContext.ds);
  end;

  plex:=UlexSuivant(plex);      { Paramètre plot }
  with plex^ do
  begin
    genre:=param;
    tpParam:=refObject;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=variObject;
    Vob:= 0;
    adOb:=intG(@plot.myAd)-intG(pgContext.ds);
  end;


  executerProc(pprog);
end;

procedure TPG2.executerPopUpClick(ad:integer;var plot:typeUO);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do                 {ProcU }
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=1;
  end;

  plex:=UlexSuivant(plex);      { Paramètre plot }
  with plex^ do
  begin
    genre:=param;
    tpParam:=refObject;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=variObject;
    Vob:= 0;
    adOb:=intG(@plot.myAd)-intG(pgContext.ds);
  end;

  executerProc(pprog);
end;


{TbuildEp=procedure(seq:longint;var vec:Tvector);}
procedure TPG2.executerBuildEp(ad:integer;seq:integer;var vec:typeUO);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=2;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbL;
    vnbl:=seq;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=refObject;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=variObject;
    Vob:= 0; {nomDesObjets.indexof('TVECTOR');}
    adOb:=intG(@vec.myAd)-intG(pgContext.ds);
  end;

  executerProc(pprog);
end;


{TgetPointColor=procedure(ind:longint;var col:longint);}
procedure TPG2.executerGetPointColor(ad:integer;ind:integer;var col:integer);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=2;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbL;
    vnbl:=ind;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=refLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=refSys;
    tpSys:=nbLong;
    adSys:=@col;
  end;


  executerProc(pprog);
end;

{TonDragDrop=procedure(x,y:real);}
procedure TPG2.executerOnDragDrop(ad:integer;var vec:typeUO;x,y:float);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=3;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=refObject;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=variobject;
    Vob:= 0; { nomDesObjets.indexof('TVECTOR');}
    adOb:=intG(@vec.myAd)-intG(pgContext.ds);
  end;


  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbExtended;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbR;
    vnbr:=x;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbExtended;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbR;
    vnbr:=y;
  end;

  executerProc(pprog);
end;

procedure TPG2.executerOnServerEvent(ad:integer;var buffer:typeUO);
var
  prog:array[1..100] of byte;
  pprog,plex:ptUlex;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  with plex^ do
  begin
    genre:=procU;
    adU:=ad;
    nbParU:=1;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=param;
    tpParam:=refObject;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=variobject;
    Vob:= 0; { nomDesObjets.indexof('TBUFFER'); }
    adOb:=intG(buffer)-intG(pgContext.ds);
  end;


  executerProc(pprog);
end;


function TPG2.executerRFunc(ad:integer;tb:PtabFloat1;nb:integer):float;
var
  prog:array[1..1000] of byte;
  pprog,plex:ptUlex;
  i:integer;
  x:float;
begin
  if nb<=0 then
  begin
    result:=0;
    exit;
  end;

  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  plex^.genre:=affectVar;
  plex:=UlexSuivant(plex);

  with plex^ do
  begin
    genre:=refSys;
    adSys:=@x;
    tpSys:=nbExtended;
  end;

  plex:=UlexSuivant(plex);

  with plex^ do
  begin
    genre:=foncU;
    adU:=ad;
    nbParU:=nb;
    tpres1:=nbExtended;
  end;

  for i:=1 to nb do
  begin
    plex:=UlexSuivant(plex);
    with plex^ do
    begin
      genre:=param;
      tpParam:=nbExtended;
    end;

    plex:=UlexSuivant(plex);
    with plex^ do
    begin
      genre:=nbR;
      vnbr:=tb^[i];
    end;
  end;

  executerProc(pprog);
  result:=x;
end;

function Tpg2.executerGetK(ad:integer;tt,z:integer;w:float):float;
var
  prog:array[1..1000] of byte;
  pprog,plex:ptUlex;
  i:integer;
  x:float;
begin
  fillchar(prog,sizeof(prog),ord(stop));

  pprog:=@prog;
  plex:=pprog;

  plex^.genre:=affectVar;
  plex:=UlexSuivant(plex);

  with plex^ do
  begin
    genre:=refSys;
    adSys:=@x;
    tpSys:=nbExtended;
  end;

  plex:=UlexSuivant(plex);

  with plex^ do
  begin
    genre:=foncU;                 { fonction  }
    adU:=ad;
    nbParU:=3;                    { 3 paramètres }
    tpres1:=nbExtended;           { type réel }
  end;

  plex:=UlexSuivant(plex);        { param 1 tt }
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbL;
    vnbL:=tt;
  end;

  plex:=UlexSuivant(plex);       { param 2 z }
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbLong;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbL;
    vnbL:=z;
  end;

  plex:=UlexSuivant(plex);       { param 3 w }
  with plex^ do
  begin
    genre:=param;
    tpParam:=nbExtended;
  end;

  plex:=UlexSuivant(plex);
  with plex^ do
  begin
    genre:=nbR;
    vnbR:=w;
  end;


  executerProc(pprog);
  result:=x;
end;






function Tpg2.PlexInit:integer;
begin
  result:=pgcontext.PlexInit;
end;

function Tpg2.PlexTrait:integer;
begin
  result:=pgcontext.PlexTrait;
end;

function Tpg2.PlexFin:integer;
begin
  result:=pgcontext.PlexFin;
end;

function Tpg2.PlexInit0:integer;
begin
  result:=pgcontext.PlexInit0;
end;

function Tpg2.PlexCont:integer;
begin
  result:=pgcontext.PlexCont;
end;

function Tpg2.PlexProgram:TstringList;
begin
  result:=pgcontext.PlexProgram;
end;

procedure Tpg2.showPopUp;
begin
  if assigned(childPg)
    then childPg.showPopup
    else PgCom.showPopUp;
end;

procedure Tpg2.showEditor;
begin
  if Gedit.windowstate=wsMinimized then Gedit.windowstate:=wsMaximized;
  Gedit.show;
end;

procedure Tpg2.setXpos(x:integer);
begin
  pgCom.left:=x;
end;

procedure Tpg2.setYpos(y:integer);
begin
  pgCom.top:=y;
end;

function Tpg2.getXpos:integer;
begin
  result:=pgCom.left;
end;

function Tpg2.getYpos:integer;
begin
  result:=pgCom.top;
end;

function TPG2.NomParDefaut(var pu:typeUO):AnsiString;
begin
  result:=ident+'.'+pgContext.tableSymbole.getVariableName(@pu);
end;

function TPG2.NomControle(var pu:typeUO;name:AnsiString):AnsiString;
  { name est un nom proposé par l'utilisateur. On le garde s'il n'existe pas.
    Sinon, on donne un nom par défaut avec numéro }
  { Le controle des noms ralentit énormément le pg }
begin
  name:=ident+'.'+Fsupespace(name);
  if (name=ident+'.') {or PgContext.ObjetExiste(name)}
      then nomControle:=nomParDefaut(pu)
      else nomControle:=name;
end;

procedure TPG2.StopProgram;
begin
  finExe:=true;
  finExeU^:=true;
end;

procedure TPG2.ActiveProgram;
begin
  finExeU^:=false;
  finExe:=false;
  errorExe:=0;
end;

procedure TPG2.executeCpList(num1:integer);
var
  i:integer;
begin
  for i:=num1 to cpList.count-1 do
    procedureOFObject(cpList[i]^);

end;

procedure TPG2.executeTerminationList;
var
  i:integer;
begin
  for i:=0 to TerminationList.count-1 do
    procedureOFObject(TerminationList[i]^);
end;

procedure TPG2.AddToCpList(p:procedureOfObject);
begin
  cpList.add(@@p);
end;

procedure AddToCpList(p:procedureOfObject);
begin
  if assigned(activeMacro) then
    with activeMacro do AddToCpList(p);
end;

procedure AddToTerminationList(p:procedureOfObject);
begin
  TerminationList.Add(@@p);
end;

procedure RemoveFromTerminationList(p:procedureOfObject);
begin
  TerminationList.remove(@@p);
end;


procedure TPg2.setTitle(st:AnsiString);
begin
  title0:=st;
end;

function TPg2.getTitle:AnsiString;
begin
  result:=title0;
end;

{*************************** Méthodes de Pg2Event *****************************}

procedure Tpg2event.setAd(adresse:integer);
begin
  pg:=activeMacro;
  numero:=pg.numeroCompilation;
  ad:=adresse;
end;

function Tpg2Event.valid:boolean;
begin
  result:=(ad>0) and (pgList.indexof(pg)>=0) and (numero=pg.NumeroCompilation);
end;


{******************** Gestion des shortcuts *********************************}

procedure Tpg2ShortCuts.add(adProc,v1,v2:integer;tpProc:integer);
var
  k:integer;
begin
  k:=0;
  repeat
    inc(k);
  until (k>Maxpg2ShortCut) or (not pg2Ev[k].valid);
  if k>Maxpg2ShortCut then exit;

  pg2Ev[k].setad(adProc);

  vk1[k]:=v1;
  vk2[k]:=v2;

  tp[k]:=tpProc;

  validate;
end;

procedure Tpg2ShortCuts.validate;
var
  i:integer;
begin
  for i:=1 to Maxpg2ShortCut do
    if pg2Ev[i].valid
      then sendmessage(formStm.handle,msg_shortcut,vk1[i] shl 16 +i,vk2[i])
      else sendmessage(formStm.handle,msg_shortcut,i,0);
end;

procedure Tpg2ShortCuts.invalidate;
var
  i:integer;
begin
  for i:=1 to Maxpg2ShortCut do
    sendmessage(formStm.handle,msg_shortcut,i,0);
end;

procedure Tpg2ShortCuts.execute(num:integer);
begin
  with pg2Ev[num] do
    if valid then
      begin
        if tp[num]=0
          then pg.executerProcedure(ad)
          else pg.executerProcedure2(ad,vk1[num],vk2[num]);
      end;
end;

function TPG2.VarClass(var pu:typeUO):TUOclass;
var
  numObj:integer;
  stClassName:AnsiString;
begin
  result:=nil;
  numObj:=pgContext.tablesymbole.getVariableType(@pu);
  if numObj<0 then exit;

  stClassName:=tabProc2.tbObjet[numObj].stName;
  delete(stClassName,1,1);

  result:=stmClass(stClassName);
end;


function TPG2.assignObject(st:AnsiString;var pu:typeUO):integer;
var
  p:typeUO;
  numObj:integer;
  stClassName:AnsiString;
  tp:TUOclass;
begin
  p:=getGlobalObject(st);

  if (p=nil) then
    begin
      result:=E_InvalidObjectName;
      exit;
    end;

  if not (p.classType=varClass(pu)) then
    begin
      result:=E_InvalidObjectType;
      exit;
    end;

  if assigned(pu) and(pu.UOowner=self) and (pu.refCount=0)
    then pu.free
    else derefObjet(pu);

  pu:=p;
  refObjet(pu);
end;


procedure proInstallShortcut(adproc:integer;vk1,vk2:integer);
begin
  shortCuts.add(adproc,vk1,vk2,0);
end;

procedure proInstallShortcut1(adproc:integer;vk1,vk2:integer);
begin
  shortCuts.add(adproc,vk1,vk2,1);
end;

procedure proResetShortcuts;
begin
  shortCuts.invalidate;
end;

var
  E_noDestroy:integer;
  E_processPhase:integer;
  E_var:integer;

procedure proTobject_free(var pu:typeUO);
  begin
    if not activeMacro.IsMyVar(pu) then sortieErreur(E_var);

    if not assigned(pu) then exit;

    {On ne détruit que les objets possédés par le programme}
    if pu.UOowner=activeMacro then pu.free;

    ActiveMacro.LocalObj.remove(@pu);
    pu:=nil;
  end;



procedure createPgObject(name:AnsiString;var pu:typeUO;tp:TUOclass);
var
  k,w:integer;
  st1:AnsiString;
begin
  { Si la variable objet n'est pas assignée et s'il s'agit d'un paramètre passé par référence
  on vérifie que son type est bien exactement égal à tp
    Pour cela, on s'appuie sur la liste des objets et sur stmClassName. Il y aurait problème si stmClassName
  ne correspondait pas au nom programme
  }
  if not assigned(pu) and assigned(RefObjectStack) then
  begin
    k:=RefObjectStack.indexof(@pu);
    if k>=0 then
    begin
      w:=intG(RefObjectTypes[k]);
      st1:=ActiveMacro.pgContext.tabProc.tbObjet[w].stName;
      if (k>=0) and (Fmaj(st1)<>'T'+Fmaj(tp.STMClassName))
        then sortieErreur('Constructor doesn''t match variable type');
    end;
  end;

  { Si la variable objet est déjà assignée, il est facile de verifier la correspondance de type. }
  if assigned(pu) and (pu.ClassType<>tp)
    then sortieErreur('Constructor doesn''t match variable type');

  {Libérer l'objet}
  proTobject_free(pu);

  {et le recréer }
  pu:=TP.create;
  pu.Fstatus:=UO_PG;

  pu.UOowner:=ActiveMacro;
  pu.PgAd:=@pu;

  if (intG(@pu)>=intG(stackSeg)) and (intG(@pu)<intG(stackSeg)+StackSize) then
  begin
    ActiveMacro.LocalObj.add(@pu);
    if name=''
      then pu.ident:=activeMacro.ident+'.Loc'
      else pu.ident:=activeMacro.ident+'.'+name;
  end
  else pu.ident:=ActiveMacro.nomControle(pu,name);

end;


procedure proTobject_clone_1(st:AnsiString;var modele:typeUO;var pu:typeUO);
begin
  verifierObjet(modele);

  if not (modele.classType=ActiveMacro.varClass(pu)) then
    begin
      sortieErreur(E_InvalidObjectType);
      exit;
    end;

  proTobject_free(pu);

  pu:=modele.clone(true);

  pu.Fstatus:=UO_PG;
  pu.ident:=ActiveMacro.nomControle(pu,st);
  pu.UOowner:=ActiveMacro;
  pu.NotPublished:=false;
end;

procedure proTobject_clone(var modele:typeUO;var pu:typeUO);
begin
  proTobject_clone_1('', modele, pu);
end;


procedure proTobject_CopyObject(var modele:typeUO;Fdata:boolean;var pu:typeUO);
begin
  verifierObjet(modele);
  verifierObjet(pu);

  if not (modele.classType=pu.classType) then
    begin
      sortieErreur(E_InvalidObjectType);
      exit;
    end;

  pu.loadFromObject(modele,Fdata);
end;


procedure proTobject_assign(st:AnsiString;var pu:typeUO);
begin
  activeMacro.assignObject(st,pu);
end;


procedure controleProcessPhase(phase:setOfProcessPhase);
begin
  if not (processPhase in phase)
    then sortieErreur(E_processPhase);
end;



function TPG2.primaryFile: AnsiString;
begin
  if primaryFile0<>'' then result:=primaryFile0
  else
  result:=Gedit.CurrentFile;
end;

function TPG2.getPrimaryFile: AnsiString;
var
  st:AnsiString;
begin
  st:=primaryFile0;
  if st='' then
    st:=NouvelleExtension(Gedit.lastFile,'.pg2');
  st:=GchooseFile('Choose primary file',st);
  if st<>'' then
    begin
      primaryFile0:=st;
      result:=st;
    end;
end;

procedure TPG2.setPrimaryFile(st: AnsiString);
begin
  if (st<>'') and (st<>'NONAME.pg2')
    then primaryFile0:=st;
end;


procedure TPG2.clearPrimaryFile;
begin
  primaryFile0:='';
end;

procedure TPG2.EvaluerVar(st: AnsiString);
begin
  inspectvar.evaluerVar(st);
end;

function getSt(const infT:typeInfoTab;tp:typeNombre;n:integer;var p:pointer):AnsiString;
var
  i:integer;
begin
  if n>infT.nbrang then
    begin
      result:=tpnbToString(tp,p,6);
      inc(intG(p),tailleNombre[tp]);
    end
  else
    begin
      result:='('+getSt(infT,tp,n+1,p);
      for i:=infT.r[n].minT+1 to infT.r[n].maxT do
        result:=result+','+getSt(infT,tp,n+1,p);
      result:=result+')';
    end;
end;


function getEvalString(Pcode:PtUlex; Pdata:pointer;nbdeci:integer):AnsiString;
begin
  case Pcode^.genre of
    variByte:      result:=Istr(Pbyte(Pdata)^);
    variShort:     result:=Istr(Pshort(Pdata)^);
    variI:         result:=Istr(Psmallint(Pdata)^);
    variWord:      result:=Istr(Pword(Pdata)^);
    variL:         result:=Istr(Plongint(Pdata)^);
    variDword:     result:=Istr(Plongword(Pdata)^);

    variSingle:    result:=Estr(Psingle(Pdata)^,nbdeci);

    variDouble:    result:=Estr(Pdouble(Pdata)^,nbdeci);
    variR:         result:=Estr(Pextended(Pdata)^,nbdeci);

    variSingleComp:result:=Estr(PsingleComp(Pdata)^.x,nbdeci)+' + i '+Estr(PsingleComp(Pdata)^.y,nbdeci);
    variDoubleComp:result:=Estr(PdoubleComp(Pdata)^.x,nbdeci)+' + i '+Estr(PdoubleComp(Pdata)^.y,nbdeci);
    variExtComp:   result:=Estr(PfloatComp(Pdata)^.x,nbdeci)+' + i '+Estr(PfloatComp(Pdata)^.y,nbdeci);

    variVariant:   result:='';
    variDateTime:  result:='';

    variB:         result:= Bstr(Pboolean(Pdata)^);
    variChar:      result:= Pansichar(Pdata)^;
    variC:         result:= PshortString(Pdata)^;
    variANSIString:result:= PansiString(Pdata)^;

    variObject:    result:='';
    variDef:       result:='';

  end;
end;

function getEvalString2(Pcode:PtUlex; Pdata:pointer;nbdeci:integer):AnsiString;
begin
  case Pcode^.tpSys of
    nbByte:      result:=Istr(Pbyte(Pdata)^);
    nbShort:     result:=Istr(Pshort(Pdata)^);
    nbSmall:     result:=Istr(Psmallint(Pdata)^);
    nbWord:      result:=Istr(Pword(Pdata)^);
    nbLong:      result:=Istr(Plongint(Pdata)^);
    nbDword:     result:=Istr(Plongword(Pdata)^);

    nbSingle:    result:=Estr(Psingle(Pdata)^,nbdeci);

    nbDouble:    result:=Estr(Pdouble(Pdata)^,nbdeci);
    nbExtended:  result:=Estr(Pextended(Pdata)^,nbdeci);

    nbSingleComp:result:=Estr(PsingleComp(Pdata)^.x,nbdeci)+' + i '+Estr(PsingleComp(Pdata)^.y,nbdeci);
    nbDoubleComp:result:=Estr(PdoubleComp(Pdata)^.x,nbdeci)+' + i '+Estr(PdoubleComp(Pdata)^.y,nbdeci);
    nbExtComp:   result:=Estr(PfloatComp(Pdata)^.x,nbdeci)+' + i '+Estr(PfloatComp(Pdata)^.y,nbdeci);

    nbBoole:     result:= Bstr(Pboolean(Pdata)^);
    nbChar:      result:= Pansichar(Pdata)^;
    nbChaine:    result:= PshortString(Pdata)^;
    nbANSIString:result:= PansiString(Pdata)^;

    else    result:='';

  end;
end;

function TPG2.FindPgContext(stFile: AnsiString): TPG2;
var
  i:integer;
begin
  result:=nil;
  stFile:=Fmaj(stFile);
  if Fmaj(PgContext.TxtFileName)=stFile then
  begin
    result:= self;
    exit;
  end;

  with PgList do
  for i:=0 to count-1 do
    if Fmaj(TPG2(PgList[i]).pgContext.TxtFileName)=stFile then
    begin
      result:= TPG2(PgList[i]);
      exit;
    end;
end;

procedure TPG2.ProcessInspLine(st: AnsiString; EditSrc: Tedit5);
var
  pg2bis: Tpg2;
begin
  pg2bis:= FindPgContext(EditSrc.currentFile);
  if assigned(Pg2bis) then pg2bis.processInspLine1(st,self);
end;


procedure TPG2.ProcessInspLine1(st: AnsiString; Pg2Src: Tpg2);
var
  stOut:AnsiString;
begin
  if st='' then exit;
  if st[length(st)]<>';' then st:=st+';';

  ProcessInspLine2(st, Pg2Src, stOut);

  Pg2Src.inspectvar.AddLine(stOut);
end;

function TPG2.ProcessInspLine2(st: AnsiString; Pg2Src: Tpg2;var stOut: AnsiString):boolean;
var
  i:integer;
  Pcode,Pend,Pdata:pointer;
  error: AnsiString;
  lig,col:integer;
  errFile: AnsiString;
  stF:TstringList;

  Xerr,XadErr:integer;
  stError:AnsiString;
  FlagAnsiString: boolean;
  oldMacro: Tpg2;


begin
  result:=true;
  stOut:='';

  if st='' then exit;
  if st[length(st)]<>';' then st:=st+';';

  result:=false;
  FlagAnsiString:=false;
  getmem(Pdata,5000);
  fillchar(Pdata^,5000,0);

  stF:=TstringList.Create;
  stF.Text:=st;


  try
    pgContext.compilerExtra(stF,Pcode,Pend,Pdata,error,lig,col,errFile,true);

    if error='' then
    begin
      pgContext.replaceAdSymbByTrueAd(Pcode,Pend);

      Xerr:=0;
      XadErr:=0;

      OldMacro:=ActiveMacro;
      ActiveMacro:=self;

      FlagAnsiString:=PtUlex(Pcode)^.tpSys=nbAnsiString;

      FinExeUpg2:=false;
      with pgContext do executerProg(cs,ds,Pcode,Xerr,XAdErr,FinExeUpg2,adresseProcedure.adr,getLocalCount,FreeLocal,localString,LocalVariant,nil);
      ActiveMacro:=OldMacro;
      if Xerr<>0 then
        begin
          if Xerr=1 then stError:=getStdError
                    else stError:=getErrorString(Xerr);

          if stError='' then stError:='Run Time error '+Istr(Xerror);
          for i:=1 to length(stError) do
            if stError[i]<' ' then stError[i]:=' ';

          stOut:=stError;
        end
      else
      begin
        StOut:=GetEvalString2(pointer(intG(Pcode)+1),Pdata,3);
        result:=true;
       end;
    end
    else stOut:=pgContext.stError;

  finally
    stF.Free;

    if FlagAnsiString then PansiString(Pdata)^:='';
    freemem(Pdata);
  end;
end;




procedure TPG2.resetProgram;
begin
  if testDebugMode then exit;

  pgContext.resetVars;
  shortcuts.invalidate;
  SpecialDrag:=nil;         // ajouté le 2-11-2010
  if board is TRTNIinterface then TRTNIinterface(board).RestartNeuron;
end;



function TPG2.IsMyVar(var pu: typeUO): boolean;
begin
{
  messageCentral('@pu='+Istr(intG(@pu))+crlf+
                 'stackSeg='+Istr(intG(stackSeg))+crlf+
                 'stackSize='+Istr(stackSize)
                 );
 }

  with pgContext do
  result:=(intG(@pu)>=intG(DS)) and                      {dans DS }
          (intG(@pu)<intG(DS)+dataSize)
          OR                                                   {ou}
          (intG(@pu)>=intG(stackSeg)) and
          (intG(@pu)<intG(stackSeg)+StackSize)           {dans SS}
          ;
end;

procedure TPG2.ShowCompHis;
begin
  messageCentral(compHis.text);
end;

function TPG2.getProcInfo(ad:integer;var st:AnsiString):PdefSymbole;
begin
  result:=pgContext.tableSymbole.getProcInfo(ad);
  if assigned(result)
    then st:=pgContext.tableSymbole.getProcStringInfo(result)
    else st:='';
end;


procedure TPG2.InstallProcT(p00, p0, p1, p2: integer);
begin
  procT00:=p00;
  procT0:=p0;
  procT1:=p1;
  procT2:=p2;
end;


procedure TPG2.FreeLocal(nbObj,nbSt,nbgvar: integer);
var
  i:integer;
type
  PUO=^typeUO;
begin
  for i:=nbObj to localObj.Count-1 do
    PUO(localObj[i])^.Free;
  localObj.count:=nbObj;

  for i:=nbSt to localString.Count-1 do
  begin
    {messageCentral(PpseudoString(localString[i])^.st);}
    PansiString(localString[i])^:='';
  end;
  localString.count:=nbSt;

  for i:=nbgvar to localVariant.Count-1 do
    PGvariant(localVariant[i])^.finalize;
  localVariant.count:=nbgvar;

end;

procedure TPG2.getLocalCount(var nbObj,nbSt,nbgvar:integer);
begin
  nbObj:=LocalObj.Count;
  nbSt:=LocalString.Count;
  nbgvar:=LocalVariant.Count;
end;

procedure TPG2.HideNextPopUp;
begin
  pgCom.FhidePgPopUp:=true;
end;

function TPG2.LoadAndInstallPrimary(st:AnsiString):boolean;
var
  error: AnsiString;
  lig,col:integer;
  stFile:AnsiString;
begin
  Gedit.installFile(st,false);

  Gedit.stPrimary:=PrimaryFile;

  if primaryFile<>'' then
  begin
    if Pgcontext.loadPg(PrimaryFile) then
      begin
        inc(numeroCompilation);
        InstallProcT(0,0,0,0);
        ExecuterProgX(pgContext.cs);
        if Xerror>0 then messageCentral('Error while initializing '+PrimaryFile);
        installPopUp(true);
        result:=(Xerror=0);
      end
    else
      begin
        compilerPg(primaryFile,error,lig,col,stFile,true);
        if error<>'' then Gedit.forcerPosition(lig,col,stFile,1);
        result:=(error='');
      end;
  end;
end;

procedure TPG2.ShowCommandWindow;
begin
  inspectvar.Show;
end;


{*************************** Méthodes stm de Tmacro **************************}

procedure proTmacro_create(stF:AnsiString;var pu:typeUO);
var
  loadOK:boolean;
  error: AnsiString;
  lig,col:integer;
  stFile:AnsiString;
  oldMacro:Tpg2;
begin
  stFile:=stF;
  createPgObject('',pu,Tpg2);

  if not fichierExiste(stFile) then sortieErreur('Tmacro.create : file not found');

  with Tpg2(pu) do
  begin
    primaryfile0:=stFile;

    Gedit.installFile(primaryfile0,false);
    Gedit.stPrimary:=PrimaryFile;

    loadOK:=Pgcontext.loadPg(PrimaryFile);

    try
    oldMacro:=activeMacro;
    if loadOK then
      begin
        inc(numeroCompilation);
        InstallProcT(0,0,0,0);
        ExecuterProgX(pgContext.cs);
        if Xerror>0 then messageCentral('Error while initializing '+stF);
        installPopUp(true);
      end
    else
      begin
        compilerPg(primaryFile,error,lig,col,stFile,true);
        if error<>'' then Gedit.forcerPosition(lig,col,stFile,1);
      end;

    finally
    ActiveMacro:=oldMacro;;
    end;

  end;
end;

procedure proTmacro_executeCommand(st:AnsiString;var pu:typeUO);
var
  i:integer;
  oldMacro:Tpg2;
  IdCpList:integer;
begin
  verifierObjet(typeUO(pu));
  oldMacro:=activeMacro;
  try
  with Tpg2(pu) do
  begin
    i:=PlexProgram.IndexOf(st);
    if i>=0 then
    begin
      pgCom.FhidePgPopUp:=true;
      IdCpList:=CpList.count;
      executerProgX(depToP(intG(PlexProgram.Objects[i])));
      postMessage(PgCom.handle,msg_EndExecute,Xerror,Poserror);
      {On poste un message qui va provoquer soit la réouverture du menu, soit
      l'affichage d'un message d'erreur}

      ExecuteCpList(IdCpList);
      executeTerminationList;

    end;
  end;
  finally
  ActiveMacro:=oldMacro;;
  with Tpg2(pu) do
  if Xerror<>0 then sortieErreur('Tmacro.executeCommand('''+PlexProgram[i]+''')  Error ');
  end;
end;

procedure proTmacro_showMenu(var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  activeMacro.HideNextPopUp;
  activeMacro.childPg:=Tpg2(pu);
  activeMacro.FshowMenu:=false;

  with Tpg2(pu) do
  begin
    showPopup;
  end;
end;

procedure proTmacro_showMenu_1(FshowMenu:boolean;var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  activeMacro.HideNextPopUp;
  activeMacro.childPg:=Tpg2(pu);
  activeMacro.FshowMenu:=FshowMenu;

  with Tpg2(pu) do
  begin
    showPopup;
  end;
end;


procedure proTmacro_reset(var pu:typeUO);
begin
  verifierObjet(typeUO(pu));
  with Tpg2(pu) do
  begin
    resetProgram;
  end;
end;

function fonctionTmacro_path(var pu:typeUO): AnsiString;
begin
  verifierObjet(typeUO(pu));
  with Tpg2(pu) do
  begin
    result:= extractFilePath(pgContext.TxtFileName);
  end;
end;

function fonctionTmacro_fileName(var pu:typeUO): AnsiString;
begin
  verifierObjet(typeUO(pu));
  with Tpg2(pu) do
  begin
    result:= pgContext.TxtFileName;
  end;
end;


procedure proReleasePgMenu;
begin
  activeMacro.HideNextPopUp;
  activeMacro.MessageToRef(uomsg_releaseMenu,nil);
end;


function TPG2.loadPgNames(stf: AnsiString): boolean;
begin
  result:=pgContext.loadPgNames(stf);
end;


function FonctionTranstype1(st:AnsiString;numObj:integer):pointer;
var
  p:typeUO;
  n1:integer;
begin
  p:=syslist.objectByName(st);
  if not assigned(p) then sortieErreur('Unable to find '+st);

  with ActiveMacro.pgContext.tabProc do
  begin
    n1:=getNumObj1('T'+Fmaj(p.STMClassName));
    if isChild(n1,numObj)
      then result:=@p.myad
      else sortieErreur('Bad type');
  end;
  //if ('T'+Fmaj(p.STMClassName)=Fmaj(ActiveMacro.pgContext.tabProc.tbObjet[numObj].stName))
  //  then result:=@p.myad
  //  else sortieErreur('Bad type');
end;

function FonctionTranstype2(var uo:typeUO;NumObj:integer):pointer;
var
  n1:integer;
begin
  verifierObjet(uo);

  with ActiveMacro.pgContext.tabProc do
  begin
    n1:=getNumObj1('T'+Fmaj(uo.STMClassName));
    if isChild(n1,numObj)
      then result:=@uo.myad
      else sortieErreur('Bad type');
  end;

  //if ('T'+Fmaj(uo.STMClassName)=Fmaj(ActiveMacro.pgContext.tabProc.tbObjet[numObj].stName))
  //  then result:=@uo.myad
  //  else sortieErreur('Bad type');
end;




procedure TPG2.ShowFile(stFile: Ansistring; lig: integer);
begin
  Gedit.ForcerLigne(stFile,lig,true,2);
end;

// DebugPg est exécuté au début de chaque instruction en mode debug.
procedure TPG2.DebugPg(p: PtUlex;NumP,AdP: integer);
var
  pbreak: PbreakPoint;
  msg: Tmsg;
  CurAd,NumProg,ww:integer;
  line:integer;
  stf:Ansistring;
begin

  if p^.genre= stop then
  begin
    ProcNameOnStop:= pgContext.tableSymbole.getProcedureNAme(AdP);
    exit;
  end;

  CurAd:= PtoDep(p);
  if (CurAd<0) or (CurAd>=PgContext.CodeSize) then exit;
  // signifie que le code a été fabriqué par ExecuterProc

  pBreak:=  BKpt.isBreakPoint(CurAd);
  if assigned(pBreak) or (stepMode>0) then
  begin
    if assigned(pBreak) then with pBreak^ do Gedit.ForcerLigne(stFile,line,true,3)
    else
    if stepMode=2 then
    begin
      if NumP=LastProcU then
      begin
        line:=pgContext.getLine(CurAd,stf,ww,NumProg);
        Gedit.ForcerLigne(stf,line,true,3);
      end
      else exit;
    end
    else
    if stepMode=1 then
    begin
      line:=pgContext.getLine(CurAd,stf,ww,NumProg);
      Gedit.ForcerLigne(stf,line,true,3);
    end;

    LastProcU:=NumP;
    Gedit.ModifyCaption(' (Stopped)');

   // messageCentral('Break at ad='+Istr(ad)+'  line='+Istr(line)+' in '+stFile );

    FstoppedState:=true;
    SetPgButtonState;

    ProcNameOnStop:= pgContext.tableSymbole.getProcedureNAme(AdP);

    FlagStopDebug:=true;
    while FlagStopDebug do application.ProcessMessages;

    FstoppedState:=false;
    SetPgButtonState;
    Gedit.ModifyCaption('');
    Gedit.ResetStepLine;

  end;

end;

procedure TPG2.SetDebugMode(w: boolean);
begin
  FDebugMode:= w;

  if w
    then Gedit.debug1.caption:='Exit Debug Mode'
    else Gedit.debug1.caption:='Enter Debug Mode';

  Gedit.TraceInto1.Enabled:= w;
  Gedit.StepOver1.Enabled := w;
  Gedit.StopDebug1.Enabled:= w;

  setPgButtonState;
  leaveStoppedState;
end;

procedure TPG2.ToggleDebugMode;
begin
  setDebugMode(not FDebugMode);

end;


procedure TPG2.ExecutePg;
begin

  StepMode:=0;
  if FStoppedState then
  begin
    //PostMessage(formStm.handle,msg_stopDebug,0,0);
    FlagStopDebug:=false;
    Gedit.ResetError;
    Gedit.ResetStepLine;
  end
  else showPgMenu;
end;

procedure TPG2.StepOver;   // pas à pas F8
begin
  if FstoppedState then
  begin
    StepMode:=2;

   // PostMessage(formStm.handle,msg_stopDebug,0,0);
   FlagStopDebug:=false;
  end;
end;

procedure TPG2.TraceInto;  // pas à pas approfondi F7
begin
  if FstoppedState then
  begin
    StepMode:=1;

    //PostMessage(formStm.handle,msg_stopDebug,0,0);
    FlagStopDebug:=false;
  end;
end;

procedure TPG2.StopDebugPg;
begin
  LeaveStoppedState;
end;


procedure TPG2.BuildBkPtList;
var
  i,j,ad1:integer;
begin
  BkPt.clear;
  with Gedit do
  begin
    for i:=0 to pageCount-1 do
    with editor[i] do
    begin
      for j:=0 to BreakPointCount-1 do
      begin
        ad1:= pgContext.FindAddress(BreakPoint(j),fileName);
        if ad1>=0 then BKpt.add( ad1, BreakPoint(j), fileName);
      end;
    end;
  end;
end;

procedure TPG2.AddBreakPoint;
begin
  if FstoppedState then
  begin
    BuildBkPtList;
  end;

end;

procedure TPG2.ClearBreakPoints;
begin

end;

function TPG2.HintPg(st: string): string;
var
  ad1,ProcAd,NumProg:integer;
  stProc:AnsiString;
  Pdef:PdefSymbole;

begin
  result:='';
  if not pgContext.compileOK then exit;

  with Gedit.CurrentEditor do
  begin
    ad1:= pgContext.FindAddress(caretY,fileName);

    pgContext.GetBlockInfo(ad1,ProcAd,NumProg);
  end;

  st:=Fmaj(st);
  if NumProg<=0 then
  begin
    stProc:= Fmaj(pgContext.tableSymbole.getProcedureName(ProcAd));

    Pdef:= pgContext.tableSymbole.getSymbole(stProc+'.'+st);
    if Pdef=nil then Pdef:= pgContext.tableSymbole.getSymbole(st);
  end
  else Pdef:= pgContext.tableSymbole.getSymbole(st);

  if Pdef<>nil
       then result:= pgContext.getSymboleInfo(Pdef);

end;

procedure TPG2.FindDecPg(st: string);
var
  ad1,ProcAd,NumProg:integer;
  stProc:AnsiString;
  Pdef:PdefSymbole;
  stF: AnsiString;

begin
  if not pgContext.compileOK then exit;

  with Gedit.CurrentEditor do
  begin
    ad1:= pgContext.FindAddress(caretY,fileName);      // Adresse du code en se basant sur le numéro de ligne
    pgContext.GetBlockInfo(ad1,ProcAd,NumProg);        // Somme nous dans une procédure ? Sommes nous dans un programme ?
  end;

  st:=Fmaj(st);
  if NumProg<=0 then
  begin
    stProc:= Fmaj(pgContext.tableSymbole.getProcedureName(ProcAd));  // Si on est à l'intérieur d'une procédure

    Pdef:= pgContext.tableSymbole.getSymbole(stProc+'.'+st);         // Si on cherche le nom qualifié  (variable locale)
    if Pdef=nil then Pdef:= pgContext.tableSymbole.getSymbole(st);   // Si pas trouvé,  on cherche le symbole dans la table.
  end
  else Pdef:= pgContext.tableSymbole.getSymbole(st);                 // Dans un bloc programme, on cherche directement le symbole dans la table

  if Pdef<>nil then
  begin
    stF:= pgContext.getSymboleFileName(Pdef);
    Gedit.ForcerLigne(stF,Pdef^.lineNum, true,1);
  end;
end;



{ TbreakPointList }

constructor TbreakPointList.create;
begin
  inherited create(sizeof(TbreakPoint));
end;

function TbreakPointList.Add(ad1, line1: integer; stF: string): Integer;
var
  bk :TbreakPoint;
begin
  bk.ad:= ad1;
  bk.line:= line1;
  bk.stFile:= stF;
  result:= inherited add(@bk);
end;


function TbreakPointList.GetBreakPoint(Index: Integer): PbreakPoint;
begin
  result:=get(index);
end;

function TbreakPointList.IsBreakPoint(n: integer): PbreakPoint;
var
  i:integer;
begin
  for i:=0 to count-1 do
  if PbreakPoint(items[i])^.ad=n then
  begin
    result:= items[i];
    exit;
  end;
  result:= nil;
end;





procedure TPG2.ProcessProcedure(message: Tmessage);
begin
  if not FstoppedState then executerProcedure(message.WParam);
end;

procedure TPG2.ProcessProcedure1(message: Tmessage);
begin
  if not FstoppedState then executerProcedure1(message.WParam,message.LParam);
end;



procedure TPG2.CheckEditorFiles;
begin
  Gedit.CheckEditorFiles;
end;

procedure TPG2.setUserShortcuts(w: boolean);
begin
  if assigned(shortcuts) then
  begin
    if w then shortcuts.validate else shortcuts.invalidate;
  end;
end;



Initialization
AffDebug('Initialization stmPG',0);

Ncdef2.testerFinExe:=testerFin;
registerObject(TPG2,data);
pgList:=Tlist.create;
shortCuts:=Tpg2shortCuts.create;

installError(E_noDestroy,'Cannot modify this object');
installError(E_processPhase,'Process phase error');
installError(E_var,'Cannot destroy this object');

TerminationList:=TlistG.create(sizeof(procedureOfObject));

finalization
pgList.free;
TerminationList.free;

end.
