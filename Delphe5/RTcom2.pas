unit RTcom2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,messages,sysutils,ExtCtrls,
     ntx41, util1, stmdef,RTLog1, debug0,
     stmvec1, evalvar1, MemoForm, RTdef0,
     Gedit5;


{ Elphy appelle d'abord initRTobjects
  Cette procédure crée:
    - les sémaphores hsemaphore1, hsemaphore1, hPrintSem
    - une mailbox hMailBox1
    - les mémoires partagées
           hmem      (pointer= pzone ,      size= ShareMemSize)
           hAcqMem   (pointer= pAcqZone ,   size= AcqShareMemSize)
           hPrintMem (pointer= pPrintZone , size= PrintZoneSize )


  Au début de Pzone se trouve un record TshareMemRec
    TshareMemRec=record
                   size:integer;
                   startFlag:BOOL;
                   EndFlag:BOOL;
                   EndFlag1:BOOL;
                   ReadLineFlag:BOOL;
                 end;

  Au début de PAcqZone se trouve un record TAcqShareMemRec
    TAcqShareMemRec=record
                      size: integer;      // Taille totale de la zone Acquisition
                      Count:integer;      // Compteur acquisition
                      URec: TRTRecInfo;   // Contient les paramètres d'acquisition
                    end;

  Au début de PprintZone se trouve un record TprintMem
    TprintMem=record
                size:integer;
                Iread:integer;
                Iwrite:integer;
                buf:array[0..MaxPrintBuf-1] of char;
              end;

  Elphy affecte les valeurs de ces structures.


  La zone acquisition est divisée en deux parties égales.
   Partie 1:  TacqShareMemRec + un buffer pour les voies qui entrent dans Elphy.
   Partie 2:  un buffer pour les voies qui sortent de Elphy

  Le premier buffer est donc un peu plus petit que le second.


  Après avoir initialisés les objets RT, Elphy utilise CatalogHandle pour transmettre
  les handles des objets créés au système INTIME.

  Ensuite, on utilise ntxCreateRTProcess pour lancer le programme rta

  rta récupère les handles transmis avec LookupRtHandle
      initialise ses adresses
      et utilise mailbox1 pour signaler "bien reçu"

  Elphy attend mailbox1 .
  Dés reception,
    - il crée le thread ThreadCom
    - il positionne StartFlag dans MemRec
    - et envoie le signal sur hSemaphore2 

}




procedure StartWinEmul(stExe,stBin,stHoc:AnsiString);
procedure StopWinEmul;

function GetSymList(cat,delay:integer):TstringList;

{ User commands
  Renvoie 0 pour OK ou bien un code d'erreur
}
function StartRT:integer;
function StopRT:integer;
function SetRTdefaults:integer;
function GetTestData(VnbData,VTdata:Tvector):integer;
function GetTestData2(VnbData,VTdata:Tvector):integer;
function SetNrnText(st:AnsiString):integer;
function GetNrnValue1(var w:double):integer;
function GetNrnStepDuration:double;
function SetPstimOffset(n:integer):integer;


function GetCount:integer;

function GetAcqBufferAd:pointer;
function GetAcqBufferSize:integer;

function GetStimBufferAd:pointer;
function GetStimBufferSize:integer;

function SendTextCommand(st:AnsiString; delay0:integer): boolean;
function GetNrnValue(st:AnsiString):double;

procedure SetRTrecInfo(rec: TRTrecInfo);

function RTconsole:TconsoleE;
procedure SetRTFlagStim(w:boolean);


implementation

procedure initRTconsole;forward;


var
  RTLocation:NTXLOCATION;
  RTroot,hSemaphore1,hSemaphore2,hMailBox1,hmem,hAcqMem:NTXHANDLE;
  pZone,pAcqZone:pointer;


Const

  ShareMemSize = 1024*1000;
  AcqShareMemSize = 1024*1000;
  PrintZoneSize = 8192;


Const
  MaxPrintBuf=4096;
type
  TprintMem=record
              size:integer;
              Iread:integer;
              Iwrite:integer;
              buf:array[0..MaxPrintBuf-1] of char;
            end;
var
  hPrintMem: NTXHANDLE;
  hPrintSem: NTXHANDLE;
  pPrintZone:pointer;


  PrintMem:^TprintMem;

var
  PwinStackOut:pointer;     // Adresse de la mémoire de communication
  PStackOut:pointer ;       // pointeur d'écriture/lecture
  PstackOutEnd:pointer;

  PwinStackIn:pointer;      // Adresse de la mémoire de communication
  PStackIn:pointer ;        // pointeur d'écriture/lecture
  PstackInEnd:pointer;



type
  TshareMemRec=record
                 size:integer;
                 startFlag:BOOL;
                 EndFlag:BOOL;
                 EndFlag1:BOOL;
                 ReadLineFlag:BOOL;  // signale que readline est actif;
               end;
  PmemRec=^TshareMemRec;


  TAcqShareMemRec=record
                    size: integer;      // Taille totale de la zone Acquisition
                    Count:integer;      // Compteur acquisition

                    URec: TRTRecInfo;

                  end;
  PAcqMemRec=^TAcqShareMemRec;

var
  MemRec:PMemRec;
  AcqMemRec:PAcqMemRec;





var
  MsgList:Tlist;



procedure ErrorMessage(st:AnsiString);
begin
end;

function errorString(status:integer):AnsiString;
var
  res:integer;
begin
  setlength(result,255);
  res:=ntxLoadRtErrorString(status,@result[1],254);
  if (res>=0) and (res<255) then setlength(result,res);
end;

function LastErrorString:AnsiString;
var
  status:integer;
begin
  status:=ntxGetLastRtError;
  result:=errorString(status);
end;


Const
  K_chdir                        =1;
  K_getcwd                       =2;

  K_BeginPaint                   =4;
  K_BitBlt                       =5;
  K_BringWindowToTop             =6;
  K_ClientToScreen               =7;
  K_CombineRgn                   =8;

  K_CopyFileA                    =10;
  K_CreateBitmapIndirect         =11;
  K_CreateBrushIndirect          =12;
  K_CreateCompatibleBitmap       =13;
  K_CreateCompatibleDC           =14;
  K_CreateCursor                 =15;
  K_CreateFontIndirectA          =16;
  K_CreatePalette                =17;
  K_CreatePen                    =18;
  K_CreatePenIndirect            =19;
  K_CreatePolygonRgn             =20;
  K_CreateRectRgn                =21;
  K_CreateRectRgnIndirect        =22;
  K_CreateWindowExA              =23;
  K_DefWindowProcA               =24;
  K_DeleteDC                     =25;
  K_DeleteObject                 =26;
  K_DestroyCursor                =27;
  K_DestroyWindow                =28;
  K_DispatchMessageA             =29;
  K_DPtoLP                       =30;
  K_EndDoc                       =31;
  K_EndPage                      =32;
  K_EndPaint                     =33;
  K_FindClose                    =34;
  K_FindFirstFileA               =35;
  K_FindNextFileA                =36;
  K_GetBitmapBits                =37;
  K_GetCharABCWidthsA            =38;
  K_GetClassInfoA                =39;
  K_GetClientRect                =40;
  K_GetClipBox                   =41;
  K_GetDC                        =42;
  K_GetDesktopWindow             =43;
  K_GetDeviceCaps                =44;
  K_GetMapMode                   =45;
  K_GetMessageA                  =46;
  K_GetMessageTime               =47;
  K_GetObjectA                   =48;
  K_GetPixel                     =49;
  K_GetPrivateProfileStringA     =50;
  K_GetProfileStringA            =51;
  K_GetPropA                     =52;
  K_GetStockObject               =53;
  K_GetSystemMetrics             =54;
  K_GetTextMetricsA              =55;
  K_GetUpdateRect                =56;
  K_GetVersion                   =57;
  K_GetViewportExtEx             =58;
  K_GetViewportOrgEx             =59;
  K_GetWindowRect                =60;
  K_GetWorldTransform            =61;
  K_InvalidateRect               =62;
  K_IsWindowVisible              =63;
  K_LineTo                       =64;
  K_LoadBitmapA                  =65;
  K_LoadCursorA                  =66;
  K_LoadIconA                    =67;
  K_LPtoDP                       =68;
  K_MessageBeep                  =69;
  K_MessageBoxA                  =70;
  K_MoveToEx                     =71;
  K_MoveWindow                   =72;
  K_OutputDebugStringA           =73;
  K_PeekMessageA                 =74;
  K_Polygon                      =75;
  K_Polyline                     =76;
  K_PostQuitMessage              =77;
  K_RealizePalette               =78;
  K_Rectangle                    =79;
  K_RegisterClassA               =80;
  K_ReleaseCapture               =81;
  K_ReleaseDC                    =82;
  K_RemovePropA                  =83;
  K_ResizePalette                =84;
  K_SelectClipRgn                =85;
  K_SelectObject                 =86;
  K_SelectPalette                =87;
  K_SetBkMode                    =88;
  K_SetCapture                   =89;
  K_SetClassLongA                =90;
  K_SetCursor                    =91;
  K_SetMapMode                   =92;
  K_SetPaletteEntries            =93;
  K_SetPixel                     =94;
  K_SetPropA                     =95;
  K_SetRectRgn                   =96;
  K_SetROP2                      =97;
  K_SetTextAlign                 =98;
  K_SetTextColor                 =99;
  K_SetUnhandledExceptionFilter  =100;
  K_SetViewportExtEx             =101;
  K_SetWindowExtEx               =102;
  K_SetWindowOrgEx               =103;
  K_SetWindowPos                 =104;
  K_SetWindowTextA               =105;
  K_ShowWindow                   =106;
  K_StartDocA                    =107;
  K_StartPage                    =108;
  K_StretchBlt                   =109;
  K_TextOutA                     =110;
  K_TranslateMessage             =111;
  K_UpdateWindow                 =112;
  K_ValidateRect                 =113;
  K_WinExec                      =114;

  K_DrawTextA                    =115;
  K_CreatePolyPolygonRegion      =116;
  K_GetModuleHandleA             =117;
  K_ExpandFileName               =118;

  K_UserCommand                  =200;
  K_GetSymList                   =201;
  K_TextCommand                  =202;


  MSG_UserCommand                =WM_USER;
  MSG_GetSymList                 =WM_USER+1;
  MSG_TextCommand                =WM_USER+2;

var
  statInst:array[1..118] of integer;

type
  TthreadCom=class(Tthread)
             private
                Procedure Processchdir;
                Procedure Processgetcwd;

                Procedure ProcessBeginPaint;
                Procedure ProcessBitBlt;
                Procedure ProcessBringWindowToTop;
                Procedure ProcessClientToScreen;
                Procedure ProcessCombineRgn;

                Procedure ProcessCopyFileA;
                Procedure ProcessCreateBitmapIndirect;
                Procedure ProcessCreateBrushIndirect;
                Procedure ProcessCreateCompatibleBitmap;
                Procedure ProcessCreateCompatibleDC;
                Procedure ProcessCreateCursor;
                Procedure ProcessCreateFontIndirectA;
                Procedure ProcessCreatePalette;
                Procedure ProcessCreatePen;
                Procedure ProcessCreatePenIndirect;
                Procedure ProcessCreatePolygonRgn;
                Procedure ProcessCreatePolyPolygonRgn;
                Procedure ProcessCreateRectRgn;
                Procedure ProcessCreateRectRgnIndirect;
                Procedure ProcessCreateWindowExA;
                Procedure ProcessDefWindowProcA;
                Procedure ProcessDeleteDC;
                Procedure ProcessDeleteObject;
                Procedure ProcessDestroyCursor;
                Procedure ProcessDestroyWindow;
                Procedure ProcessDispatchMessageA;
                Procedure ProcessDPtoLP;
                Procedure ProcessEndDoc;
                Procedure ProcessEndPage;
                Procedure ProcessEndPaint;
                Procedure ProcessFindClose;
                Procedure ProcessFindFirstFileA;
                Procedure ProcessFindNextFileA;
                Procedure ProcessGetBitmapBits;
                Procedure ProcessGetCharABCWidthsA;
                Procedure ProcessGetClassInfoA;
                Procedure ProcessGetClientRect;
                Procedure ProcessGetClipBox;
                Procedure ProcessGetDC;
                Procedure ProcessGetDesktopWindow;
                Procedure ProcessGetDeviceCaps;
                Procedure ProcessGetMapMode;
                Procedure ProcessGetMessageA;

                Procedure ProcessGetMessageTime;
                Procedure ProcessGetObjectA;
                Procedure ProcessGetPixel;
                Procedure ProcessGetPrivateProfileStringA;
                Procedure ProcessGetProfileStringA;
                Procedure ProcessGetPropA;
                Procedure ProcessGetStockObject;
                Procedure ProcessGetSystemMetrics;
                Procedure ProcessGetTextMetricsA;
                Procedure ProcessGetUpdateRect;
                Procedure ProcessGetVersion;
                Procedure ProcessGetViewportExtEx;
                Procedure ProcessGetViewportOrgEx;
                Procedure ProcessGetWindowRect;
                Procedure ProcessGetWorldTransform;
                Procedure ProcessInvalidateRect;
                Procedure ProcessIsWindowVisible;
                Procedure ProcessLineTo;
                Procedure ProcessLoadBitmapA;
                Procedure ProcessLoadCursorA;
                Procedure ProcessLoadIconA;
                Procedure ProcessLPtoDP;
                Procedure ProcessMessageBeep;
                Procedure ProcessMessageBoxA;
                Procedure ProcessMoveToEx;
                Procedure ProcessMoveWindow;
                Procedure ProcessOutputDebugStringA;
                Procedure ProcessPeekMessageA;
                Procedure ProcessPolygon;
                Procedure ProcessPolyline;
                Procedure ProcessPostQuitMessage;
                Procedure ProcessRealizePalette;
                Procedure ProcessRectangle;
                Procedure ProcessRegisterClassA;
                Procedure ProcessReleaseCapture;
                Procedure ProcessReleaseDC;
                Procedure ProcessRemovePropA;
                Procedure ProcessResizePalette;
                Procedure ProcessSelectClipRgn;
                Procedure ProcessSelectObject;
                Procedure ProcessSelectPalette;
                Procedure ProcessSetBkMode;
                Procedure ProcessSetCapture;
                Procedure ProcessSetClassLongA;
                Procedure ProcessSetCursor;
                Procedure ProcessSetMapMode;
                Procedure ProcessSetPaletteEntries;
                Procedure ProcessSetPixel;
                Procedure ProcessSetPropA;
                Procedure ProcessSetRectRgn;
                Procedure ProcessSetROP2;
                Procedure ProcessSetTextAlign;
                Procedure ProcessSetTextColor;
                Procedure ProcessSetUnhandledExceptionFilter;
                Procedure ProcessSetViewportExtEx;
                Procedure ProcessSetWindowExtEx;
                Procedure ProcessSetWindowOrgEx;
                Procedure ProcessSetWindowPos;
                Procedure ProcessSetWindowTextA;
                Procedure ProcessShowWindow;
                Procedure ProcessStartDocA;
                Procedure ProcessStartPage;
                Procedure ProcessStretchBlt;
                Procedure ProcessTextOutA;
                Procedure ProcessTranslateMessage;
                Procedure ProcessUpdateWindow;
                Procedure ProcessValidateRect;
                Procedure ProcessWinExec;

                Procedure ProcessDrawTextA;
                Procedure ProcessGetModuleHandleA;
                Procedure ProcessExpandFileName;
                Procedure ProcessGetSymList;
                Procedure ProcessUserCommand;

                Procedure ProcessSetSymbolNames;
                Procedure ProcessSetAcqScaleParams;
                Procedure ProcessSetOutputNumbers;
                Procedure ProcessSetOutScaleParams;

                Procedure ProcessTextCommand;

                procedure ProcessInst;
                procedure execute;override;
             end;

type
  TthreadConsole= class(Tthread)
                    procedure execute;override;
                    procedure ProcessStrings;
                    function nextChar: char;
                    function empty:boolean;
                 end;


var
  threadCom:TthreadCom;
  threadConsole:TthreadConsole;

  hProcess: NTXHANDLE;


procedure CatalogHandle(hh:pointer;Name:Ansistring);                         // Mettre hh=nil pour décataloguer
var
  hdum:pointer;
begin
  hdum:= ntxLookupNtxHandle(RTroot,PAnsichar(Name),0 );                      // Décataloguer le handle
  if hdum<>NTX_BAD_NTXHANDLE                                             // Il peut être là à cause d'un précédent plantage
    then ntxUncatalogNtxHandle(RTroot,hdum,PAnsichar(Name));

  if hh<>nil then
    if ntxCatalogNtxHandle(RTroot,hh,PAnsichar(Name))<>0 then ;
end;

procedure UncatalogHandle(Name:AnsiString);
begin
  CatalogHandle(nil,Name);
end;


function InitRTobjects:boolean;
var
  hh:pointer;

begin
  RTlocation:=ntxGetFirstLocation;
  RTroot:=ntxGetRootRTprocess(RTlocation);
  if RTroot=NTX_BAD_NTXHANDLE then
  begin
    messageCentral('Unable to find INTIME system');
    result:=false;
    exit;
  end;


  hSemaphore1 := ntxCreateRtSemaphore( RTlocation, 0, 1,NTX_FIFO_QUEUING);               // Créer les objets RT
  hSemaphore2 := ntxCreateRtSemaphore( RTlocation, 0, 1,NTX_FIFO_QUEUING);
  hPrintSem := ntxCreateRtSemaphore( RTlocation, 0, 1,NTX_FIFO_QUEUING);
  hMailBox1 :=   ntxCreateRtMailbox(RTlocation, NTX_DATA_MAILBOX or NTX_FIFO_QUEUING );

  hmem := ntxAllocateRtMemory(RTlocation, ShareMemSize);
  pzone:= ntxMapRtSharedMemoryEx(hMem, NTX_MAP_WRITE or NTX_MAP_UNALIGNED );                                                 // Créer les mémoires partagées
  if pzone=nil then messageCentral(LastErrorString);

  hAcqMem := ntxAllocateRtMemory(RTlocation, AcqShareMemSize);
  pAcqZone:= ntxMapRtSharedMemoryEx(hAcqMem,  NTX_MAP_WRITE or NTX_MAP_UNALIGNED);

  hPrintMem := ntxAllocateRtMemory(RTlocation, PrintZoneSize);
  pPrintZone:= ntxMapRtSharedMemoryEx(hPrintMem , NTX_MAP_WRITE or NTX_MAP_UNALIGNED);

  if assigned(Pzone) then                                                        // Initialiser la mémoire partagée 1
  begin                                                                          // Premier mot = size
    fillchar(Pzone^,ShareMemSize,0);
    Pinteger(Pzone)^:=ShareMemSize;
  end;

  if assigned(PAcqzone) then
  begin
    fillchar(PAcqzone^,AcqShareMemSize,0);
    Pinteger(PAcqzone)^:=AcqShareMemSize;
  end;

  if assigned(PPrintzone) then
  begin
    fillchar(PPrintzone^,PrintZoneSize,0);
    Pinteger(PPrintzone)^:=PrintZoneSize;
    PrintMem:=PPrintzone;
  end;


  CatalogHandle(hSemaphore1,'SEMAPHORE1');
  CatalogHandle(hSemaphore2,'SEMAPHORE2');
  CatalogHandle(hPrintSem,'PRINTSEM');
  CatalogHandle(hMailBox1,'MAILBOX1');
  CatalogHandle(hMem,'MEM1');
  CatalogHandle(hAcqMem,'ACQMEM1');
  CatalogHandle(hPrintMem,'PRINTMEM');

  result:= (hSemaphore1<>NTX_Bad_NtxHandle) and
           (hSemaphore2<>NTX_Bad_NtxHandle) and
           (hPrintSem<>NTX_Bad_NtxHandle) and
           (hMailBox1<>NTX_Bad_NtxHandle) and
           assigned(Pzone) and
           assigned(PAcqZone) and
           assigned(PPrintZone);

  if not result then
    messageCentral('hSemaphore1='+Istr(intG(hSemaphore1))+crlf+
                 'hSemaphore2='+Istr(intG(hSemaphore2))+crlf+
                 'hMailBox1='+Istr(intG(hMailBox1))+crlf+
                 'hMem='+Istr(intG(hMem))+crlf+
                 'pzone='+Istr(intG(pZone))+crlf+
                 'hAcqMem='+Istr(intG(hAcqMem))+crlf+
                 'pAcqZone='+Istr(intG(pAcqZone))
                 );

end;


Procedure DeleteRTobjects;
begin
  UnCatalogHandle('SEMAPHORE1');
  UnCatalogHandle('SEMAPHORE2');
  UnCatalogHandle('PRINTSEM');
  UnCatalogHandle('MAILBOX1');
  UnCatalogHandle('MEM1');
  UnCatalogHandle('ACQMEM1');
  UnCatalogHandle('PRINTMEM1');


  ntxDeleteRtMailbox(hMailBox1);
  ntxDeleteRtSemaphore(hSemaphore1);
  ntxDeleteRtSemaphore(hSemaphore2);
  ntxDeleteRtSemaphore(hPrintSem);
  ntxFreeRtMemory(hMem);
  ntxFreeRtMemory(hAcqMem);
  ntxFreeRtMemory(hPrintMem);
end;

function WaitBox1:boolean;
var
  RTmessage:array[1..128] of byte;
  N:word;
begin
  repeat
    N:=ntxReceiveRtData(hMailBox1,@RTmessage,1000);
  until (N<>NTX_Error) or testEscape;

  result:=(N=4);
  if not result then messageCentral('RT program does not respond');
end;



function InitRTcom(stExe,stBin,stHoc:AnsiString):boolean;
var
  att:NTXPROCATTRIBS;
  stExeFile1,stBinFile1,stHocFile1:AnsiString;
  stParam:AnsiString;
  i,res:integer;

begin
  result:=false;
  if not initNtxDLL then exit;
  if not initNtxExDLL then exit;;

  stExeFile1:=FsupespaceDebutEtFin(stExe);

  stBinFile1:=FsupespaceDebutEtFin(stBin);
  if stBinFile1='' then stBinFile1:=stExeFile1;
  for i:=1 to length(stBinFile1) do
  if stBinFile1[i]='\' then stBinFile1[i]:='/';

  stParam:='"'+stBinFile1+'"';
  stHocFile1:=FsupespaceDebutEtFin(stHoc);
  if stHocFile1<>'' then
  begin
    for i:=1 to length(stHocFile1) do
      if stHocFile1[i]='\' then stHocFile1[i]:='/';
    stParam:=stParam+' "'+stHocFile1+'"';
  end;
  if not InitRTobjects then exit;


  { Version Intime 3.1 la combinaison qui marche est 0,$FFFFFFFF,0,32 }
  att.dwPoolMin:=0;
  att.dwPoolMax:=$FFFFFFFF;
  att.dwVsegSize:=0;
  att.dwObjDirSize:= 64;

  hProcess:=ntxCreateRTProcess(RTlocation, PAnsichar(stExeFile1),PAnsichar(stParam),@att ,0);
  if hProcess=pointer(-1) then
  begin
    if stExeFile1<>'' then  messageCentral('Unable to load '+stExeFile1+crlf+
                                            LastErrorString );
    exit;
  end;

  { Le programme sous intime envoie un message dans MailBox1 pour signaler la fin de son initialisation
    Donc, on attend ce message.
  }
//  messageCentral('InitRTcom Debug Pause');
  result:=WaitBox1;

end;

procedure InstallAddresses;
begin
  MemRec:=Pzone;

  PwinStackIn:= pointer(intG(pzone)+sizeof(TshareMemRec));
  PwinStackOut:=pointer(intG(pzone)+(memrec^.size div 2));

  PStackIn:=PwinStackIn;
  PStackOut:=PwinStackOut;

  PstackInEnd:=PwinStackOut;
  PstackOutEnd:=pointer(intG(pzone)+memrec^.size );

  AcqMemRec:=PAcqZone;
end;

procedure StopWinEmul;
var
  res:boolean;
  Msg:TMsg;
  FlagFin:boolean;
  cnt:integer;
begin
  {messageCentral('StopWinEmul 1');}

  if not assigned(ThreadCom) then exit;
  FlagFin:=false;
  res:=PostThreadMessage(ThreadCom.ThreadID, WM_QUIT, 0, 0);
  res:=PostThreadMessage(ThreadCom.ThreadID, WM_QUIT, 0, 0);
  res:=PostThreadMessage(ThreadCom.ThreadID, WM_QUIT, 0, 0);
  res:=PostThreadMessage(ThreadCom.ThreadID, WM_QUIT, 0, 0);
  res:=PostThreadMessage(ThreadCom.ThreadID, WM_QUIT, 0, 0);

  if res=false then messageCentral('INTIME doesn''t respond' );

  cnt:=0;
  if assigned(formStm)and formstm.Visible then
  repeat
    if peekMessage(Msg, 0 {formStm.Handle},wm_keydown,wm_keydown,pm_remove) then
    begin
      if msg.wparam= vk_escape then Flagfin:=true;
      translateMessage(Msg);
      DispatchMessage(Msg);
    end;
    sleep(20);
    inc(cnt);
  until MemRec^.endFlag or FlagFin or (cnt>=50);

//  if MemRec^.endFlag=false then messageCentral('StopWinEmul 2 endflag='+Bstr(MemRec^.endFlag));

  if not MemRec^.endFlag then
  begin
    MemRec^.endFlag1:=true;
    ntxReleaseRtSemaphore(hSemaphore1,1);
    ntxReleaseRtSemaphore(hSemaphore2,1);
    cnt:=0;
    repeat
      sleep(20);
      inc(cnt)
    until ThreadCom.Terminated or testEscape or (cnt>=50);
  end;
  {messageCentral('StopWinEmul 3');}

  if assigned(NtxDeleteRTprocess) then NtxDeleteRTprocess(hProcess); { version 4.0 only }

  hProcess:=nil;
  ThreadCom.Free;
  ThreadCom:=nil;

  threadConsole.Terminate;
  ntxReleaseRtSemaphore(hPrintSem,1);
  cnt:=0;
  repeat
    sleep(20);
    inc(cnt)
  until ThreadConsole.Terminated or testEscape or (cnt>=50);

  {messageCentral('StopWinEmul 4');}
  threadConsole.Free;
  threadConsole:=nil;

  {if waitBox1 then } DeleteRTobjects;
  {messageCentral('StopWinEmul 5');}
end;

procedure initMsgList;
begin
  if assigned(MSgList) then exit;

  MsgList:=Tlist.Create;

  MsgList.Add(pointer(WM_DESTROY));
  MsgList.Add(pointer(WM_CREATE));
  MsgList.Add(pointer(WM_CLOSE));
  MsgList.Add(pointer(WM_PAINT));
  MsgList.Add(pointer(WM_ERASEBKGND));
  MsgList.Add(pointer(WM_LBUTTONDOWN));
  MsgList.Add(pointer(WM_LBUTTONUP));
  MsgList.Add(pointer(WM_MBUTTONDOWN));
  MsgList.Add(pointer(WM_MBUTTONUP));
  MsgList.Add(pointer(WM_RBUTTONDOWN));
  MsgList.Add(pointer(WM_RBUTTONUP));
  MsgList.Add(pointer(WM_MOUSEMOVE));
  MsgList.Add(pointer(WM_CHAR));
  MsgList.Add(pointer(WM_SIZE));
  MsgList.Add(pointer(WM_MOVE));
  MsgList.Add(pointer(WM_COMMAND));
  MsgList.Add(pointer(WM_HSCROLL));
  MsgList.Add(pointer(WM_VSCROLL));
  MsgList.Add(pointer(WM_PALETTECHANGED));
  MsgList.Add(pointer(WM_QUERYNEWPALETTE));
  MsgList.Add(pointer(WM_KEYDOWN));
  MsgList.Add(pointer(WM_SETFOCUS));
  MsgList.Add(pointer(WM_KILLFOCUS));
{  MsgList.Add(pointer(WM_GETMINMAXINFO));}
  MsgList.Add(pointer(WM_CLOSE));
end;


procedure StartWinEmul(stExe,stBin,stHoc:AnsiString);
begin
  if assigned(ThreadCom) then exit;

  //messageCentral('Start WinEmul');
  initRTconsole;
  threadConsole:=TthreadConsole.Create(false);

  if not initRTcom(stExe,stBin,stHoc) then exit;
  InstallAddresses;
  initMsgList;

  threadCom:=TthreadCom.Create(false);
  threadCom.Priority:= tpHighest;

  MemRec^.startFlag:=TRUE;
  ntxReleaseRtSemaphore(hSemaphore2,1);
end;


function ControleStackOut(n:integer):boolean;
begin
  if (longword(PstackOut)<longword(PWinstackOut)) or (longword(PstackOut)>longword(PstackOutEnd)-n) then
  begin
    ErrorMessage('StackOut overflow');
    PostThreadMessage(ThreadCom.ThreadID, WM_QUIT, 0, 0);
    result:=false
  end
  else result:=true;
end;

procedure PushInt( X:integer);
begin
  if not ControleStackOut(4) then exit;

  Pinteger(PStackOut)^:=X;
  inc(intG(PStackOut),4);
end;

procedure PushBytes(p:Pbyte; count:integer);
begin
  if not ControleStackOut(count) then exit;
  move(p^,PStackOut^,count);
  inc(intG(PStackOut),count);
end;


procedure PushString(st:AnsiString);
var
  len:integer;
begin
  len:= length(st);
  if not ControleStackOut(len+5) then exit;

  PushInt(len);
  if len>0 then PushBytes(@st[1],length(st));
end;


function PopInt:integer;
begin
  if not ControleStackOut(4) then exit;
  move(PStackOut^,result,4);
  inc(intG(PStackOut),4);
end;

procedure PopBytes(p:PBYTE; count:integer);
begin
  if not ControleStackOut(count) then exit;
  move(PStackOut^,p^,count);
  inc(intG(PStackOut),count);
end;

function PopString:AnsiString;
var
  n:integer;
begin
  n:=PopInt;
  if not ControleStackOut(n) then exit;
  setLength(result,n);
  if n>0 then move(PStackOut^,result[1],n);
  inc(intG(PStackOut),n);
end;

function PopResourceString(var w:integer):AnsiString;
var
  n:integer;
begin
  n:=PopInt;
  if not ControleStackOut(n) then exit;
  if n<0 then
  begin
    w:=-n;
    result:='';
  end
  else
  begin
    w:=0;
    setLength(result,n);
    move(PStackOut^,result[1],n);
    inc(intG(PStackOut),n);
  end;
end;

function PresourceString(var st:AnsiString;w:integer):pointer;
begin
  if w>0
    then result:=pointer(w)
    else result:=PansiChar(st);
end;


{******************* Gestion des window proc ***********************************************}

var
  RTwndProc:array[1..5] of pointer;
  NbRTwndProc:integer;



type
  TwinProcParam=record
                  flag:BOOL;
                  func: pointer;
                  wnd: HWND;
                  Msg: UINT;
                  wParam: integer;
                  lParam: integer;
                  res:LRESULT;
                  extraSize:integer;
                end;
  PwinProcParam= ^TwinProcParam;



function ControlePstackIn:boolean;
begin
  if longword(PstackIn)>longword(PstackInEnd)-sizeof(TwinProcParam) then
  begin
    ErrorMessage('StackIN overflow');
    PostThreadMessage(ThreadCom.ThreadID, WM_QUIT, 0, 0);
    result:=false
  end
  else result:=true;
end;


function WindowProc0(num:integer;Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
var
  p:PwinProcParam;
  res:integer;
  tt,ttmax,cnt,cntProcess:integer;
  error:integer;
  cntErr:array[1..6] of integer;
  Pextra:pointer;
begin

  if MsgList.IndexOf(pointer(Msg))<0 then
  begin
    result:=defWindowProc(wnd,Msg,wparam,lparam);
    exit;
  end;

  p:=PwinProcParam(PstackIn);
  if not controlePstackIn then exit;


  p^.func:=RTwndProc[num];
  p^.wnd:=wnd;
  p^.msg:=msg;
  p^.wparam:=wparam;
  p^.lparam:=lparam;
  inc(intG(PstackIn),sizeof(TwinProcParam));
  Pextra:=PstackIn;

  case msg of
    WM_CREATE:        begin
                        move(pointer(lparam)^,PstackIn^,sizeof(TCREATESTRUCT));
                        inc(intG(PstackIn),sizeof(TCREATESTRUCT));
                        p^.extraSize:=sizeof(TCREATESTRUCT);
                      end;

    WM_GETMINMAXINFO: if lparam<>0 then
                      begin
                        move(pointer(lparam)^,PstackIn^,sizeof(TminmaxInfo));
                        inc(intG(PstackIn),sizeof(TminmaxInfo));
                        p^.extraSize:=sizeof(TminmaxInfo);
                      end;
    else p^.extraSize:=0;
  end;


  p^.flag:=true;
  ntxReleaseRtSemaphore(hSemaphore2,1);

  cnt:=0;
  cntProcess:=0;
  fillchar(cntErr,sizeof(cntErr),0);

  repeat
    tt:=getTickCount;
    res:=ntxWaitForRtSemaphore(hSemaphore1, 1,10000);
    if memrec^.EndFlag1 then exit;

    tt:=getTickCount-tt;
    if tt>ttmax then ttmax:=tt;

    if (res=NTX_ERROR) then
    begin
      error:= ntxGetLastRtError;
      if error<>1 then ErrorMessage('WinProc error='+Istr(error));
      res:=0;
    end
    else
    begin
      error:=0;
      if (res<>NTX_ERROR) and p^.flag then
      begin
        threadCom.ProcessInst;
        inc(cntProcess);
      end;
    end;

    case error of
       E_OK      : inc(cntErr[1]);
       E_TIME    : inc(cntErr[2]);
       E_LIMIT   : inc(cntErr[3]);
       E_EXIST   : inc(cntErr[4]);
       E_TYPE    : inc(cntErr[5]);
       E_NTX_INTERNAL_ERROR: inc(cntErr[6]);
    end;



    if MemRec^.EndFlag then
    begin
      result:=defWindowProc(wnd,Msg,wparam,lparam);
      PostThreadMessage(ThreadCom.ThreadID, WM_QUIT, 0, 0);
      exit;
    end;
    inc(cnt);
  until (not p^.flag) and (res=0);

  case msg of
    WM_GETMINMAXINFO: if lparam<>0 then
                      begin
                        move(Pextra^,pointer(lparam)^,sizeof(TminmaxInfo));
                      end;
  end;

  result:=p^.res;
  PstackIn:=p;
end;

function WindowProc1(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  result:=WindowProc0(1,Wnd, Msg, wParam, lParam);
end;

function WindowProc2(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  result:=WindowProc0(2,Wnd, Msg, wParam, lParam);
end;


function WindowProc3(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  result:=WindowProc0(3,Wnd, Msg, wParam, lParam);
end;

function WindowProc4(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  result:=WindowProc0(4,Wnd, Msg, wParam, lParam);
end;

function WindowProc5(Wnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
begin
  result:=WindowProc0(5,Wnd, Msg, wParam, lParam);
end;

function getWndProc(p:pointer):pointer;
var
  i:integer;
begin
  result:=nil;
  if p=RTwndProc[1] then result:=@WindowProc1
  else
  if p=RTwndProc[2] then result:=@WindowProc2
  else
  if p=RTwndProc[3] then result:=@WindowProc3
  else
  if p=RTwndProc[4] then result:=@WindowProc4
  else
  if p=RTwndProc[5] then result:=@WindowProc5;

  if result=nil then
  begin
    inc(nbRTwndProc);
    RTwndProc[nbRTwndProc]:=p;
    case nbRTwndProc of
      1: result:=@WindowProc1;
      2: result:=@WindowProc2;
      3: result:=@WindowProc3;
      4: result:=@WindowProc4;
      5: result:=@WindowProc5;
    end;
  end;

end;

{**************************************************************************************}

{ TthreadCom }


procedure TthreadCom.execute;
var
  res:longword;
  error:integer;
begin
  repeat
    res:=ntxWaitForRtSemaphore(hSemaphore1, 1,1000);

    if (res=NTX_ERROR) then
    begin
      error:= ntxGetLastRtError;
      if error=1 then error:=0;
    end
    else error:=0;

    if (error<>0) or MemRec^.EndFlag {or testEscape}
      then terminate
      else ProcessInst;
  until terminated ;

end;

function nameInst(num:integer):AnsiString;
begin
  case num of
    K_chdir: result:='K_chdir';
    K_getcwd: result:='K_getcwd';

    K_BeginPaint: result:='K_BeginPaint';
    K_BitBlt: result:='K_BitBlt';
    K_BringWindowToTop: result:='K_BringWindowToTop';
    K_ClientToScreen: result:='K_ClientToScreen';
    K_CombineRgn: result:='K_CombineRgn';

    K_CopyFileA: result:='K_CopyFileA';
    K_CreateBitmapIndirect: result:='K_CreateBitmapIndirect';
    K_CreateBrushIndirect: result:='K_CreateBrushIndirect';
    K_CreateCompatibleBitmap: result:='K_CreateCompatibleBitmap';
    K_CreateCompatibleDC: result:='K_CreateCompatibleDC';
    K_CreateCursor: result:='K_CreateCursor';
    K_CreateFontIndirectA: result:='K_CreateFontIndirectA';
    K_CreatePalette: result:='K_CreatePalette';
    K_CreatePen: result:='K_CreatePen';
    K_CreatePenIndirect: result:='K_CreatePenIndirect';
    K_CreatePolygonRgn: result:='K_CreatePolygonRgn';
    K_CreateRectRgn: result:='K_CreateRectRgn';
    K_CreateRectRgnIndirect: result:='K_CreateRectRgnIndirect';
    K_CreateWindowExA: result:='K_CreateWindowExA';
    K_DefWindowProcA: result:='K_DefWindowProcA';
    K_DeleteDC: result:='K_DeleteDC';
    K_DeleteObject: result:='K_DeleteObject';
    K_DestroyCursor: result:='K_DestroyCursor';
    K_DestroyWindow: result:='K_DestroyWindow';
    K_DispatchMessageA: result:='K_DispatchMessageA';
    K_DPtoLP: result:='K_DPtoLP';
    K_EndDoc: result:='K_EndDoc';
    K_EndPage: result:='K_EndPage';
    K_EndPaint: result:='K_EndPaint';
    K_FindClose: result:='K_FindClose';
    K_FindFirstFileA: result:='K_FindFirstFileA';
    K_FindNextFileA: result:='K_FindNextFileA';
    K_GetBitmapBits: result:='K_GetBitmapBits';
    K_GetCharABCWidthsA: result:='K_GetCharABCWidthsA';
    K_GetClassInfoA: result:='K_GetClassInfoA';
    K_GetClientRect: result:='K_GetClientRect';
    K_GetClipBox: result:='K_GetClipBox';
    K_GetDC: result:='K_GetDC';
    K_GetDesktopWindow: result:='K_GetDesktopWindow';
    K_GetDeviceCaps: result:='K_GetDeviceCaps';
    K_GetMapMode: result:='K_GetMapMode';
    K_GetMessageA: result:='K_GetMessageA';
    K_GetMessageTime: result:='K_GetMessageTime';
    K_GetObjectA: result:='K_GetObjectA';
    K_GetPixel: result:='K_GetPixel';
    K_GetPrivateProfileStringA: result:='K_GetPrivateProfileStringA';
    K_GetProfileStringA: result:='K_GetProfileStringA';
    K_GetPropA: result:='K_GetPropA';
    K_GetStockObject: result:='K_GetStockObject';
    K_GetSystemMetrics: result:='K_GetSystemMetrics';
    K_GetTextMetricsA: result:='K_GetTextMetricsA';
    K_GetUpdateRect: result:='K_GetUpdateRect';
    K_GetVersion: result:='K_GetVersion';
    K_GetViewportExtEx: result:='K_GetViewportExtEx';
    K_GetViewportOrgEx: result:='K_GetViewportOrgEx';
    K_GetWindowRect: result:='K_GetWindowRect';
    K_GetWorldTransform: result:='K_GetWorldTransform';
    K_InvalidateRect: result:='K_InvalidateRect';
    K_IsWindowVisible: result:='K_IsWindowVisible';
    K_LineTo: result:='K_LineTo';
    K_LoadBitmapA: result:='K_LoadBitmapA';
    K_LoadCursorA: result:='K_LoadCursorA';
    K_LoadIconA: result:='K_LoadIconA';
    K_LPtoDP: result:='K_LPtoDP';
    K_MessageBeep: result:='K_MessageBeep';
    K_MessageBoxA: result:='K_MessageBoxA';
    K_MoveToEx: result:='K_MoveToEx';
    K_MoveWindow: result:='K_MoveWindow';
    K_OutputDebugStringA: result:='K_OutputDebugStringA';
    K_PeekMessageA: result:='K_PeekMessageA';
    K_Polygon: result:='K_Polygon';
    K_Polyline: result:='K_Polyline';
    K_PostQuitMessage: result:='K_PostQuitMessage';
    K_RealizePalette: result:='K_RealizePalette';
    K_Rectangle: result:='K_Rectangle';
    K_RegisterClassA: result:='K_RegisterClassA';
    K_ReleaseCapture: result:='K_ReleaseCapture';
    K_ReleaseDC: result:='K_ReleaseDC';
    K_RemovePropA: result:='K_RemovePropA';
    K_ResizePalette: result:='K_ResizePalette';
    K_SelectClipRgn: result:='K_SelectClipRgn';
    K_SelectObject: result:='K_SelectObject';
    K_SelectPalette: result:='K_SelectPalette';
    K_SetBkMode: result:='K_SetBkMode';
    K_SetCapture: result:='K_SetCapture';
    K_SetClassLongA: result:='K_SetClassLongA';
    K_SetCursor: result:='K_SetCursor';
    K_SetMapMode: result:='K_SetMapMode';
    K_SetPaletteEntries: result:='K_SetPaletteEntries';
    K_SetPixel: result:='K_SetPixel';
    K_SetPropA: result:='K_SetPropA';
    K_SetRectRgn: result:='K_SetRectRgn';
    K_SetROP2: result:='K_SetROP2';
    K_SetTextAlign: result:='K_SetTextAlign';
    K_SetTextColor: result:='K_SetTextColor';
    K_SetUnhandledExceptionFilter: result:='K_SetUnhandledExceptionFilter';
    K_SetViewportExtEx: result:='K_SetViewportExtEx';
    K_SetWindowExtEx: result:='K_SetWindowExtEx';
    K_SetWindowOrgEx: result:='K_SetWindowOrgEx';
    K_SetWindowPos: result:='K_SetWindowPos';
    K_SetWindowTextA: result:='K_SetWindowTextA';
    K_ShowWindow: result:='K_ShowWindow';
    K_StartDocA: result:='K_StartDocA';
    K_StartPage: result:='K_StartPage';
    K_StretchBlt: result:='K_StretchBlt';
    K_TextOutA: result:='K_TextOutA';
    K_TranslateMessage: result:='K_TranslateMessage';
    K_UpdateWindow: result:='K_UpdateWindow';
    K_ValidateRect: result:='K_ValidateRect';
    K_WinExec: result:='K_WinExec';

    K_DrawTextA: result:='K_DrawTextA';
    K_CreatePolyPolygonRegion: result:='K_CreatePolyPolygonRegion';
    K_GetModuleHandleA: result:='K_GetModuleHandleA';
    K_ExpandFileName: result:='K_ExpandFileName';

    K_UserCommand: result:='K_UserCommand';
    K_GetSymList: result:='K_GetSymList';
    K_TextCommand: result:='K_TextCommand';
    else result:='K_unknown';
  end;
end;


procedure TthreadCom.ProcessInst;
var
  NumInst:integer;
  Pindex:pointer;
  Pflag:PBOOL;
begin
  Pindex:=PstackOut;
  inc(intG(PstackOut),4);
  Pflag:=PstackOut;
  inc(intG(PstackOut),4);

  NumInst:=Pinteger(Pindex)^;

  if (NumInst>=1) and (NumInst<=118) then inc(StatInst[NumInst]);
  AffDebug('ProcessInst '+NameInst(NumInst),78);

  case NumInst of
    K_chdir                        : Processchdir;
    K_getcwd                       : Processgetcwd;

    K_BeginPaint                   : ProcessBeginPaint;
    K_BitBlt                       : ProcessBitBlt;
    K_BringWindowToTop             : ProcessBringWindowToTop;
    K_ClientToScreen               : ProcessClientToScreen;
    K_CombineRgn                   : ProcessCombineRgn;

    K_CopyFileA                    : ProcessCopyFileA;
    K_CreateBitmapIndirect         : ProcessCreateBitmapIndirect;
    K_CreateBrushIndirect          : ProcessCreateBrushIndirect;
    K_CreateCompatibleBitmap       : ProcessCreateCompatibleBitmap;
    K_CreateCompatibleDC           : ProcessCreateCompatibleDC;
    K_CreateCursor                 : ProcessCreateCursor;
    K_CreateFontIndirectA          : ProcessCreateFontIndirectA;
    K_CreatePalette                : ProcessCreatePalette;
    K_CreatePen                    : ProcessCreatePen;
    K_CreatePenIndirect            : ProcessCreatePenIndirect;
    K_CreatePolygonRgn             : ProcessCreatePolygonRgn;
    K_CreateRectRgn                : ProcessCreateRectRgn;
    K_CreateRectRgnIndirect        : ProcessCreateRectRgnIndirect;
    K_CreateWindowExA              : ProcessCreateWindowExA;
    K_DefWindowProcA               : ProcessDefWindowProcA;
    K_DeleteDC                     : ProcessDeleteDC;
    K_DeleteObject                 : ProcessDeleteObject;
    K_DestroyCursor                : ProcessDestroyCursor;
    K_DestroyWindow                : ProcessDestroyWindow;
    K_DispatchMessageA             : ProcessDispatchMessageA;
    K_DPtoLP                       : ProcessDPtoLP;
    K_EndDoc                       : ProcessEndDoc;
    K_EndPage                      : ProcessEndPage;
    K_EndPaint                     : ProcessEndPaint;
    K_FindClose                    : ProcessFindClose;
    K_FindFirstFileA               : ProcessFindFirstFileA;
    K_FindNextFileA                : ProcessFindNextFileA;
    K_GetBitmapBits                : ProcessGetBitmapBits;
    K_GetCharABCWidthsA            : ProcessGetCharABCWidthsA;
    K_GetClassInfoA                : ProcessGetClassInfoA;
    K_GetClientRect                : ProcessGetClientRect;
    K_GetClipBox                   : ProcessGetClipBox;
    K_GetDC                        : ProcessGetDC;
    K_GetDesktopWindow             : ProcessGetDesktopWindow;
    K_GetDeviceCaps                : ProcessGetDeviceCaps;
    K_GetMapMode                   : ProcessGetMapMode;
    K_GetMessageA                  : ProcessGetMessageA;

    K_GetMessageTime               : ProcessGetMessageTime;
    K_GetObjectA                   : ProcessGetObjectA;
    K_GetPixel                     : ProcessGetPixel;
    K_GetPrivateProfileStringA     : ProcessGetPrivateProfileStringA;
    K_GetProfileStringA            : ProcessGetProfileStringA;
    K_GetPropA                     : ProcessGetPropA;
    K_GetStockObject               : ProcessGetStockObject;
    K_GetSystemMetrics             : ProcessGetSystemMetrics;
    K_GetTextMetricsA              : ProcessGetTextMetricsA;
    K_GetUpdateRect                : ProcessGetUpdateRect;
    K_GetVersion                   : ProcessGetVersion;
    K_GetViewportExtEx             : ProcessGetViewportExtEx;
    K_GetViewportOrgEx             : ProcessGetViewportOrgEx;
    K_GetWindowRect                : ProcessGetWindowRect;
    K_GetWorldTransform            : ProcessGetWorldTransform;
    K_InvalidateRect               : ProcessInvalidateRect;
    K_IsWindowVisible              : ProcessIsWindowVisible;
    K_LineTo                       : ProcessLineTo;
    K_LoadBitmapA                  : ProcessLoadBitmapA;
    K_LoadCursorA                  : ProcessLoadCursorA;
    K_LoadIconA                    : ProcessLoadIconA;
    K_LPtoDP                       : ProcessLPtoDP;
    K_MessageBeep                  : ProcessMessageBeep;
    K_MessageBoxA                  : ProcessMessageBoxA;
    K_MoveToEx                     : ProcessMoveToEx;
    K_MoveWindow                   : ProcessMoveWindow;
    K_OutputDebugStringA           : ProcessOutputDebugStringA;
    K_PeekMessageA                 : ProcessPeekMessageA;
    K_Polygon                      : ProcessPolygon;
    K_Polyline                     : ProcessPolyline;
    K_PostQuitMessage              : ProcessPostQuitMessage;
    K_RealizePalette               : ProcessRealizePalette;
    K_Rectangle                    : ProcessRectangle;
    K_RegisterClassA               : ProcessRegisterClassA;
    K_ReleaseCapture               : ProcessReleaseCapture;
    K_ReleaseDC                    : ProcessReleaseDC;
    K_RemovePropA                  : ProcessRemovePropA;
    K_ResizePalette                : ProcessResizePalette;
    K_SelectClipRgn                : ProcessSelectClipRgn;
    K_SelectObject                 : ProcessSelectObject;
    K_SelectPalette                : ProcessSelectPalette;
    K_SetBkMode                    : ProcessSetBkMode;
    K_SetCapture                   : ProcessSetCapture;
    K_SetClassLongA                : ProcessSetClassLongA;
    K_SetCursor                    : ProcessSetCursor;
    K_SetMapMode                   : ProcessSetMapMode;
    K_SetPaletteEntries            : ProcessSetPaletteEntries;
    K_SetPixel                     : ProcessSetPixel;
    K_SetPropA                     : ProcessSetPropA;
    K_SetRectRgn                   : ProcessSetRectRgn;
    K_SetROP2                      : ProcessSetROP2;
    K_SetTextAlign                 : ProcessSetTextAlign;
    K_SetTextColor                 : ProcessSetTextColor;
    K_SetUnhandledExceptionFilter  : ProcessSetUnhandledExceptionFilter;
    K_SetViewportExtEx             : ProcessSetViewportExtEx;
    K_SetWindowExtEx               : ProcessSetWindowExtEx;
    K_SetWindowOrgEx               : ProcessSetWindowOrgEx;
    K_SetWindowPos                 : ProcessSetWindowPos;
    K_SetWindowTextA               : ProcessSetWindowTextA;
    K_ShowWindow                   : ProcessShowWindow;
    K_StartDocA                    : ProcessStartDocA;
    K_StartPage                    : ProcessStartPage;
    K_StretchBlt                   : ProcessStretchBlt;
    K_TextOutA                     : ProcessTextOutA;
    K_TranslateMessage             : ProcessTranslateMessage;
    K_UpdateWindow                 : ProcessUpdateWindow;
    K_ValidateRect                 : ProcessValidateRect;
    K_WinExec                      : ProcessWinExec;

    K_DrawTextA                    : ProcessDrawTextA;
    K_GetModuleHandleA             : ProcessGetModuleHandleA;
    K_expandFileName               : ProcessExpandFileName;

    K_GetSymList                   : ProcessGetSymList;
    K_UserCommand                  : ProcessUserCommand;
    K_TextCommand                  : ProcessTextCommand;
  end;



  PstackOut:=Pindex;
  PFlag^:=true;
  ntxReleaseRtSemaphore(hSemaphore2,1);
end;



Procedure TThreadCom.Processchdir;
var
  st:AnsiString;
  res:integer;
begin
  st:=PopString;

  chdir(st);
  res:= IOresult;
  if res=0
    then PushInt(0)
    else PushInt(-1);
end;

Procedure TThreadCom.Processgetcwd;
var
  st:AnsiString;
  nmax:integer;
begin
  nmax:=PopInt;
  st:=GetCurrentDir;
  st:=copy(st,1,nmax);
  PushString(st);
  if length(st)<=nmax
    then PushInt(0)
    else PushInt(-1);
end;

Procedure TThreadCom.ProcessBeginPaint;
var
  Wnd: HWND;
  lpPaint: TPaintStruct;
  res:HDC;
begin
  Wnd:=popint;
  res:= BeginPaint(Wnd,lpPaint);
  PushBytes(@lpPaint,sizeof(TPaintStruct));
  Pushint(res);
end;

Procedure TThreadCom.ProcessBitBlt;
var
  hdcDest:HDC;
  nXDest:integer;
  nYDest:integer;
  nWidth:integer;
  nHeight:integer;
  hdcSrc:HDC;
  nXSrc :integer;
  nYSrc :integer;
  dwRop :longword;
  res:BOOL;
begin
  hdcDest:=popint;
  nXDest:=popint;
  nYDest:=popint;
  nWidth:=popint;
  nHeight:=popint;
  hdcSrc:=popint;
  nXSrc :=popint;
  nYSrc :=popint;
  dwRop :=popint;

  res:=BitBlt(hdcDest,nXDest,nYDest,nWidth,nHeight,hdcSrc,nXSrc,nYSrc,dwRop);

  pushInt(intG(res));
end;

Procedure TThreadCom.ProcessBringWindowToTop;
var
  wnd:HWND;
  res:BOOL;
  point:Tpoint;
begin
  wnd:=Popint;
  res:= BringWindowToTop(Wnd);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessClientToScreen;
var
  wnd:HWND;
  res:BOOL;
  point:Tpoint;
begin
  wnd:=Popint;
  PopBytes(@point,sizeof(Tpoint));
  res:= ClientToScreen(Wnd,point);
  PushBytes(@point,sizeof(Tpoint));
  PushInt(intG(res));
end;


Procedure TThreadCom.ProcessCombineRgn;
var
  hrgnDest, hrgnSrc1, hrgnSrc2: HRGN;
  fnCombineMode:integer;
  res:integer;
begin
  hrgnDest:=popInt;
  hrgnSrc1:=popInt;
  hrgnSrc2:=popInt;
  fnCombineMode:=popInt;

  res:= CombineRgn(hrgnDest, hrgnSrc1, hrgnSrc2, fnCombineMode );
  PushInt(res);
end;

Procedure TThreadCom.ProcessCopyFileA;
var
  lpExistingFileName, lpNewFileName:AnsiString;
  bFailIfExists:BOOL;
  res:BOOL;
begin
  lpExistingFileName:=PopString;
  lpNewFileName:=PopString;
  bFailIfExists:=BOOL(PopInt);

  res:=CopyFileA(Pansichar(lpExistingFileName),Pansichar(lpNewFileName),bFailIfExists);
  PushInt(intG(res));

end;

Procedure TThreadCom.ProcessCreateBitmapIndirect;
var
  p1:TBitmap;
  res:Hbitmap;
  sz:integer;
  mm:pointer;
begin
 PopBytes(@p1,sizeof(TBitmap));
 with p1 do
 sz:=bmWidthBytes*bmHeight;

 if p1.bmBits<>nil then
 begin
   getmem(mm,sz);
   PopBytes(mm,sz);
   p1.bmBits:=mm;
 end;
 res:=CreateBitmapIndirect(p1);
 PushInt(intG(res));

end;

Procedure TThreadCom.ProcessCreateBrushIndirect;
var
  p1: TLogBrush;
  res:HBRUSH;
begin
  PopBytes(@p1,sizeof(TlogBrush));
  res:=CreateBrushIndirect(p1);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessCreateCompatibleBitmap;
var
  res:HBITMAP ;
  DC: HDC; Width, Height: Integer;
begin
  dc:=Popint;
  Width:=PopInt;
  Height:=PopInt;
  res:=CreateCompatibleBitmap(DC, Width, Height);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessCreateCompatibleDC;
var
  res:HDC;
  DC: HDC;
begin
  DC:=PopInt;
  res:=CreateCompatibleDC(DC);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessCreateCursor;
var
  res: Hcursor;
  h: Hinst;
  xHotSpot, yHotSpot, nWidth, nHeight: Integer;
  ANDPlane, XORPlane: array[0..255] of byte;
begin
  h        :=PopInt;
  xHotSpot :=PopInt;
  yHotSpot :=PopInt;
  nWidth   :=PopInt;
  nHeight  :=PopInt;
  PopBytes(@ANDplane,(nWidth div 8 +1)*nHeight);
  PopBytes(@XORplane,(nWidth div 8 +1)*nHeight);

  res:=CreateCursor(h,xHotSpot, yHotSpot, nWidth, nHeight, @ANDPlane, @XORPlane);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessCreateFontIndirectA;
var
  p1: TLogFont;
  res: HFONT;
begin
  PopBytes(@p1,sizeof(TLogFont));
  res:= CreateFontIndirect(p1);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessCreatePalette;
var
  LP: array[1..1028] of byte;
  LogPalette: TLogPalette absolute LP;
  res: Hpalette;
begin
  PopBytes(@LP,1028);
  res:=CreatePalette(LogPalette);
  PushInt(intG(res));

end;

Procedure TThreadCom.ProcessCreatePen;
var
  Style, Width: Integer; Color: COLORREF;
  res: Hpen ;
begin
  Style:=PopInt;
  Width:=PopInt;
  Color:=PopInt;
  res:= CreatePen(Style, Width,Color);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessCreatePenIndirect;
var
  LogPen: TLogPen;
  res: Hpen;
begin
  PopBytes(@LogPen,sizeof(LogPen));
  res:= CreatePenIndirect(LogPen);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessCreatePolyPolygonRgn;
var
  Points:pointer;
  PolyCount:PtabLong;
  count, fillmode: Integer;
  res:Hrgn ;
  nb,i:integer;
begin
  Points:=nil;
  PolyCount:=nil;

  try
  count:=PopInt;
  getmem(PolyCount,count*sizeof(integer));
  PopBytes(pointer(PolyCount),count*sizeof(integer));

  nb:=0;
  for i:=0 to count-1 do
    nb:=nb+PolyCount^[i];
  getmem(Points,nb*sizeof(Tpoint));
  PopBytes(Points,nb*sizeof(Tpoint));
  fillMode:=PopInt;

  res:=CreatePolyPolygonRgn(Points^, PolyCount^,count, fillMode);
  PushInt(intG(res));

  finally
  freemem(Points);
  freemem(PolyCount);
  end;
end;

Procedure TThreadCom.ProcessCreatePolygonRgn;
var
  Points:pointer;
  count, fillmode: Integer;
  res:Hrgn ;
begin
  Points:=nil;

  try
  count:=PopInt;
  getmem(Points,count*sizeof(Tpoint));
  PopBytes(Points,count*sizeof(Tpoint));
  fillMode:=PopInt;

  res:=CreatePolygonRgn(Points^, count, fillMode);
  PushInt(intG(res));

  finally
  freemem(Points);
  end;
end;

Procedure TThreadCom.ProcessCreateRectRgn;
var
  res:hrgn ;
  p1, p2, p3, p4: Integer;
begin
  p1:=PopInt;
  p2:=PopInt;
  p3:=PopInt;
  p4:=PopInt;
  res:=CreateRectRgn(p1, p2, p3, p4);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessCreateRectRgnIndirect;
var
  p1: TRect;
  res:hrgn ;
begin
  PopBytes(@p1,sizeof(Trect));
  res:=CreateRectRgnIndirect(p1);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessCreateWindowExA;
var
    dwExStyle: DWORD;
    lpClassName: AnsiString;
    w:integer;
    lpWindowName: AnsiString;
    dwStyle:Dword;
    X,Y,nWidth,nHeight: integer;
    hWndParent: HWND;
    Menu: HMENU;
    hInstance:HINST;
    lpParam: pointer;
    wnd:HWND;
begin
    dwExStyle:=PopInt;
    lpClassName:=PopResourceString(w);
    lpWindowName:=PopString;
    dwStyle:=PopInt;
    X:=PopInt;
    Y:=PopInt;
    nWidth:=PopInt;
    nHeight:=PopInt;
    hWndParent:=PopInt;
    Menu:=PopInt;
    hInstance:=PopInt;
    lpParam:=pointer(PopInt);

    {$IFDEF FPC}
    if hinstance=0 then hinstance:= MainInstance;
    {$ELSE}
    if hinstance=0 then hinstance:= sysinit.HInstance;
    {$ENDIF}

    wnd:=CreateWindowExA(dwExStyle,PresourceString(lpClassName,w),Pansichar(lpWindowName),dwStyle,
                         X,Y,nWidth,nHeight,hWndParent,Menu,hInstance,lpParam);

    PushInt(wnd);
end;

Procedure TThreadCom.ProcessDefWindowProcA;
var
  Wnd: HWND;
  Msg: UINT;
  wParam: integer;
  lParam: integer;
  res: LRESULT;
begin
  Wnd:=popint;
  Msg:=popint;
  wparam:=popint;
  lparam:=popint;
  res:= DefWindowProc(Wnd, Msg, wParam,lParam);

  Pushint(res);
end;

Procedure TThreadCom.ProcessDeleteDC;
var
  dc:Hdc;
  res: BOOL;
begin
  dc:=PopInt;
  res:=DeleteDC(DC);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessDeleteObject;
var
  p1: HGDIOBJ;
  res: BOOL;
begin
  p1:=PopInt;
  res:= DeleteObject(p1);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessDestroyCursor;
var
  hCur: HCursor;
  res: BOOL;
begin
  hCur:=PopInt;
  res:= DestroyCursor(hCur);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessDestroyWindow;
var
  Wnd: HWND;
  res: BOOL ;
begin
  Wnd:=PopInt;
  res:= DestroyWindow(Wnd);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessDispatchMessageA;
var
  Msg: TMsg;
  res:integer;
begin
  PopBytes(@Msg,sizeof(Tmsg));
  res:= DispatchMessage(Msg);
  PushInt(res);
end;


Procedure TThreadCom.ProcessDPtoLP;
var
  DC: HDC;
  Points:pointer;
  Count: Integer;
  res: BOOL ;
begin
  dc:=PopInt;
  Count:=PopInt;

  try
  getmem(Points,sizeof(Tpoint)*count);
  PopBytes(Points,sizeof(Tpoint)*count);
  res:= DPtoLP(DC, Points^, Count);
  PushBytes(Points,sizeof(Tpoint)*count);
  PushInt(intG(res));

  finally
  freemem(Points);
  end;
end;

Procedure TThreadCom.ProcessEndDoc;
var
  DC: HDC;
  res: integer;
begin
  dc:=PopInt;
  res:= EndDoc(DC);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessEndPage;
var
  DC: HDC;
  res: integer;
begin
  dc:=PopInt;
  res:= EndPage(DC);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessEndPaint;
var
  Wnd: HWND;
  lpPaint: TPaintStruct;
  res: BOOL;
begin
  Wnd:=Popint;
  popBytes(@lpPaint,sizeof(TPaintStruct));
  res:= EndPaint(Wnd, lpPaint);

  Pushint(intG(res));
end;

Procedure TThreadCom.ProcessFindClose;
var
  hFindFile: THandle;
  res: BOOL ;
begin
  hFindFile:=PopInt;
  res:= windows.FindClose(hFindFile);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessFindFirstFileA;
var
  lpFileName: AnsiString;
  lpFindFileData: TWIN32FindDataA;
  res: THandle;
begin
  lpFileName:=PopString;
  res:= FindFirstFileA(Pansichar(lpFileName), lpFindFileData);
  PushBytes(@lpFindFileData,sizeof(TWIN32FindDataA));

  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessFindNextFileA;
var
  hFindFile: THandle;
  lpFindFileData: TWIN32FindData;
  res: BOOL;
begin
  hFindFile:=PopInt;
  res:=FindNextFile(hFindFile,lpFindFileData);
  PushBytes(@lpFindFileData,sizeof(TWIN32FindDataA));

  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetBitmapBits;
var
  Bitmap: HBITMAP;
  count:integer;
  bits:pointer;
  res: integer;
begin
  bitmap:=PopInt;
  count:=PopInt;
  try
  getmem(Bits,count);
  res:= GetBitmapBits(Bitmap, Count,Bits);
  PushBytes(Bits,count);
  PushInt(intG(res));
  finally
  freemem(Bits);
  end;
end;

Procedure TThreadCom.ProcessGetCharABCWidthsA;
var
  DC: HDC;
  FirstChar, LastChar: UINT;
  ABCStructs:pointer;
  res: BOOL;
begin
  DC:=PopInt;
  FirstChar:=PopInt;
  LastChar:=PopInt;
  try
  getmem(ABCstructs,sizeof(ABC)*(LastChar-FirstChar+1));
  res:= GetCharABCWidths(DC,FirstChar, LastChar, ABCStructs^);
  PushBytes(ABCstructs,sizeof(ABC)*(LastChar-FirstChar+1));
  //res:=false;                            // Test
  PushInt(intG(res));
  finally
  freemem(ABCstructs);
  end;
end;

Procedure TThreadCom.ProcessGetClassInfoA;
var
  hInstance: HINST;
  ClassName: AnsiString;
  w:integer;
  WndClass: TWndClass;
  res: BOOL ;
begin
  hInstance:=PopInt;
  ClassName:=PopResourceString(w);

  res:=GetClassInfo(hInstance, PresourceString(ClassName,w),WndClass);

  PushBytes(@WndClass,sizeof(TwndClass));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetClientRect;
var
  Wnd: HWND;
  lpRect: TRect;
  res:BOOL;
begin
  Wnd:=Popint;
  res:= GetClientRect(Wnd, lpRect);
  PushBytes(@lpRect,sizeof(Trect));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetClipBox;
var
  dc:HDC;
  rect:Trect;
  res: integer;
begin
  dc:=PopInt;
  res:=GetClipBox(dc,rect);
  PushBytes(@rect,sizeof(Trect));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetDC;
var
  wnd:Hwnd;
  res: integer ;
begin
  wnd:=PopInt;
  res:=getDc(wnd);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetDesktopWindow;
var
  res: Hwnd;
begin
  res:=GetDeskTopWindow;
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetDeviceCaps;
var
  dc:HDC;
  index:integer;
  res: integer;
begin
  dc:=PopInt;
  index:=PopInt;
  res:=GetDeviceCaps(dc,index);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetMapMode;
var
  dc:Hdc;
  res:integer ;
begin
  dc:=PopInt;
  res:= GetMapMode(dc);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetMessageA;
var
  Msg: TMsg;
  Wnd: HWND;
  wMsgFilterMin, wMsgFilterMax: UINT;
  res:BOOL;
begin
  Wnd:=Popint;
  wMsgFilterMin:=Popint;
  wMsgFilterMax:=Popint;

  res:= GetMessage(Msg, Wnd, wMsgFilterMin, wMsgFilterMax);

  PushBytes(@Msg,sizeof(Tmsg));

  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetMessageTime;
var
  res:integer ;
begin
  res:= GetMessageTime;
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetObjectA;
var
  p1:HGDIOBJ;
  sz:integer;
  buf:pointer;
  res:integer ;
begin
  p1:=PopInt;
  sz:=PopInt;
  try
  getmem(buf,sz);
  res:=GetObjectA(p1,sz,buf);
  PushBytes(buf,sz);
  PushInt(intG(res));
  finally
  freemem(buf);
  end;
end;

Procedure TThreadCom.ProcessGetPixel;
var
  dc:hdc;
  x,y:integer;
  res: integer;                                             
begin
  dc:=PopInt;
  x:=PopInt;
  y:=PopInt;
  res:= GetPixel(dc,x,y);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetPrivateProfileStringA;
var
  lpAppName, lpKeyName, lpDefault, lpReturnedString,lpFileName: AnsiString;
  nSize:integer;
  res: integer;
begin
  lpAppName :=PopString;
  lpKeyName :=PopString;
  lpDefault :=PopString;
  nSize:=PopInt;
  lpFileName:=PopString;

  setLength(lpReturnedString,nSize+1);
  res:=GetPrivateProfileStringA(PansiChar(lpAppName), Pansichar(lpKeyName), Pansichar(lpDefault),
           PansiChar(lpReturnedString),nSize,PansiChar(lpFileName));
  PushString(lpReturnedString);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetProfileStringA;
var
  lpAppName, lpKeyName, lpDefault,lpReturnedString:AnsiString;
  nsize:integer;
  res:integer;
begin
  lpAppName :=PopString;
  lpKeyName :=PopString;
  lpDefault :=PopString;
  nSize:=PopInt;
  setLength(lpReturnedString,nSize+1);
  res:=GetProfileStringA(Pansichar(lpAppName), Pansichar(lpKeyName), Pansichar(lpDefault),
             Pansichar(lpReturnedString),nSize);
  PushString(lpReturnedString);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetPropA;
var
  Wnd: HWND;
  lpString: AnsiString;
  w:integer;
  res: THandle;
begin
  Wnd:=Popint;
  lpString:=PopResourceString(w);
  res:= GetPropA(Wnd, PresourceString(lpString,w));

  PushInt(intG(res));

end;

Procedure TThreadCom.ProcessGetStockObject;
var
  index:integer;
  res:HGDIOBJ;
begin
  index:=Popint;
  res:= GetStockObject(Index);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetSystemMetrics;
var
  index:integer;
  res: integer;
begin
  index:=PopInt;
  res:= GetSystemMetrics(Index);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetTextMetricsA;
var
  DC: HDC;
  TM: TTextMetric;
  res: BOOL;
begin
  dc:=PopInt;
  res:= GetTextMetrics(DC, TM);
  PushBytes(@TM,sizeof(TTextMetric));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetUpdateRect;
var
  Wnd: HWND;
  lpRect: TRect;
  bErase: BOOL;
  res: BOOL ;
begin
  wnd:=PopInt;
  bErase:=BOOL(PopInt);
  res:= GetUpdateRect(Wnd,lpRect, bErase);
  PushBytes(@lpRect,sizeof(Trect));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetVersion;
var
  res: integer;
begin
  res:=GetVersion;
  PushInt(res);
end;

Procedure TThreadCom.ProcessGetViewportExtEx;
var
  DC: HDC;
  Size: TSize;
  res: BOOL ;
begin
  dc:=PopInt;
  res:= GetViewportExtEx(DC, Size);
  PushBytes(@Size,sizeof(Tsize));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetViewportOrgEx;
var
  DC: HDC;
  Point: TPoint;
  res: BOOL;
begin
  dc:=PopInt;
  res:=GetViewportOrgEx(DC,Point);
  PushBytes(@Point,sizeof(Tpoint));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetWindowRect;
var
  Wnd: HWND;
  lpRect: TRect;
  res: BOOL;
begin
  wnd:=PopInt;
  res:= GetWindowRect(Wnd,lpRect);
  PushBytes(@lpRect,sizeof(Trect));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessGetWorldTransform;
var
  DC: HDC;
  p2: TXForm;
  res:BOOL ;
begin
  DC:=PopInt;
  res:=  GetWorldTransform(DC, p2);
  PushBytes(@p2,sizeof(TXFORM));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessInvalidateRect;
var
  Wnd: HWND;
  lpRect: TRect;
  bErase: BOOL;
  res:BOOL;
begin
  wnd:=PopInt;
  PopBytes(@lpRect,sizeof(Trect));
  bErase:=BOOL(PopInt);
  res:= InvalidateRect(Wnd,@lpRect,bErase);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessIsWindowVisible;
var
  res:BOOL ;
  wnd:Hwnd;
begin
  wnd:=PopInt;
  res:=IsWindowVisible(wnd);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessLineTo;
var
  DC: HDC;
  X, Y: Integer;
  res: BOOL;
begin
  DC:=PopInt;
  X:=PopInt;
  Y:=PopInt;

  res:= LineTo(DC,X, Y);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessLoadBitmapA;
var
  hInstance: HINST;
  lpBitmapName: AnsiString;
  w:integer;
  res: HBITMAP;
begin
  hInstance:=PopInt;
  lpBitmapName:=PopResourceString(w);
  res:= LoadBitmap(hInstance,PresourceString(lpBitmapName,w));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessLoadCursorA;
var
  hInstance: HINST;
  lpCursorName: AnsiString;
  res:HCURSOR;
  w:integer;
begin
  hInstance:=Popint;
  lpCursorName:=PopResourceString(w);
  res:= LoadCursor(hInstance, PresourceString(lpCursorName,w));

  PushInt(intG(res));
end;


Procedure TThreadCom.ProcessLoadIconA;
var
  hInstance: HINST;
  lpIconName: AnsiString;
  res:HICON;
  w:integer;
begin
  hInstance:=Popint;
  lpIconName:=PopResourceString(w);
  res:= LoadIcon(hInstance, PresourceString(lpIconName,w));
  PushInt(intG(res));
end;


Procedure TThreadCom.ProcessLPtoDP;
var
  DC: HDC;
  Points:pointer;
  Count: Integer;
  res: BOOL ;
begin
  dc:=PopInt;
  Count:=PopInt;

  try
  getmem(Points,sizeof(Tpoint)*count);
  PopBytes(Points,sizeof(Tpoint)*count);
  res:= LPtoDP(DC, Points^, Count);
  PushBytes(Points,sizeof(Tpoint)*count);
  PushInt(intG(res));

  finally
  freemem(Points);
  end;
end;

Procedure TThreadCom.ProcessMessageBeep;
var
  uType: UINT;
  res: BOOL;
begin
  uType:=PopInt;
  res:=MessageBeep(uType);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessMessageBoxA;
var
  Wnd: HWND;
  lpText, lpCaption: AnsiString;
  uType: UINT;
  res: Integer;
begin
  Wnd:=Popint;
  lpText:=PopString;
  lpCaption:=PopString;
  uType:=Popint;

  Res:=MessageBoxA(Wnd,Pansichar(lpText),Pansichar(lpCaption), uType);
  PushInt(Res);
end;

Procedure TThreadCom.ProcessMoveToEx;
var
  DC: HDC;
  x, y: Integer;
  point: TPoint;
  res: BOOL;
begin
  dc:=PopInt;
  x:=PopInt;
  y:=PopInt;
  res:= MoveToEx(DC,x,y,@Point);
  PushBytes(@point,sizeof(Tpoint));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessMoveWindow;
var
  Wnd: HWND;
  X, Y, nWidth, nHeight: Integer;
  bRepaint: BOOL;
  res: BOOL;
begin
  Wnd     :=PopInt;
  X       :=PopInt;
  Y       :=PopInt;
  nWidth  :=PopInt;
  nHeight :=PopInt;
  bRepaint:=BOOL(PopInt);

  res:= MoveWindow(Wnd, X, Y, nWidth, nHeight, bRepaint);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessOutputDebugStringA;
var
  st:AnsiString;
begin
  st:=PopString;
  OutputDebugStringA(PansiChar(st));
  PushInt(0);
end;

Procedure TThreadCom.ProcessPeekMessageA;
var
  Msg: TMsg;
  Wnd: HWND;
  wMsgFilterMin, wMsgFilterMax, wRemoveMsg: UINT;
  res:BOOL;
begin
  Wnd:=PopInt;
  wMsgFilterMin:=PopInt;
  wMsgFilterMax:=PopInt;
  wRemoveMsg:=PopInt;

  res:=PeekMessage( Msg,Wnd,wMsgFilterMin, wMsgFilterMax, wRemoveMsg);

  PushBytes(@Msg,sizeof(Tmsg));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessPolygon;
var
  DC: HDC;
  Points:pointer;
  Count: Integer;
  res:BOOL ;
begin
  DC:=PopInt;
  Count:=PopInt;
  try
  getmem(Points,sizeof(TPoint)*count);
  PopBytes(Points,sizeof(TPoint)*count);
  res:= Polygon(DC,Points^,Count);
  PushInt(intG(res));
  finally
  freemem(Points);
  end;
end;

Procedure TThreadCom.ProcessPolyline;
var
  DC: HDC;
  Points:pointer;
  Count: Integer;
  res:BOOL ;
begin
  DC:=PopInt;
  Count:=PopInt;
  try
  getmem(Points,sizeof(TPoint)*count);
  PopBytes(Points,sizeof(TPoint)*count);
  res:= Polyline(DC,Points^,Count);
  PushInt(intG(res));
  finally
  freemem(Points);
  end;
end;

Procedure TThreadCom.ProcessPostQuitMessage;
var
  nExitCode: Integer;
begin
  nExitCode:=popint;
  PostQuitMessage(nExitCode);
end;

Procedure TThreadCom.ProcessRealizePalette;
var
  dc:Hdc;
  res: integer;
begin
  dc:=PopInt;
  res:= RealizePalette(DC);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessRectangle;
var
  DC: HDC;
  X1, Y1, X2, Y2: Integer;
  res:BOOL;
begin
  DC :=PopInt;
  X1 :=PopInt;
  Y1 :=PopInt;
  X2 :=PopInt;
  Y2 :=PopInt;

  res:= Rectangle(DC, X1, Y1, X2, Y2);
  PushInt(intG(res));
end;


Procedure TThreadCom.ProcessRegisterClassA;
var
  WndClass : TWndClassA;
  menuName,classname:AnsiString;
  pWndProc:pointer;
  w:word;
  w1,w2:integer;
begin
  WndClass.style:=PopInt;

  pWndProc:=pointer(PopInt);

  WndClass.cbClsExtra:=PopInt;
  WndClass.cbWndExtra:=PopInt;
  WndClass.hInstance:=PopInt;
  WndClass.hIcon:=PopInt;
  WndClass.hCursor:=PopInt;
  WndClass.hbrBackground:=PopInt;
  MenuName:=popResourceString(w1);
  ClassName:=popResourceString(w2);

  WndClass.lpfnWndProc:=getWndProc(pWndProc);
  WndClass.lpszMenuName:= PresourceString(MenuName,w1);
  WndClass.lpszClassName:=PresourceString(ClassName,w2);

  w:= RegisterClassA(WndClass);

  PushInt(w);
end;

Procedure TThreadCom.ProcessReleaseCapture;
var
  res:BOOL;
begin
  res:=ReleaseCapture;
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessReleaseDC;
var
  Wnd: HWND;
  DC: HDC;
  res: integer;
begin
  Wnd:=PopInt;
  DC:=PopInt;
  res:= ReleaseDC(Wnd,DC);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessRemovePropA;
var
  Wnd: HWND;
  st:AnsiString;
  w:integer;
  res:Thandle;
begin
  wnd:=PopInt;
  st:=PopResourceString(w);

  if w<0
    then res:= RemovePropA(Wnd, pointer(-w))
    else res:= RemovePropA(Wnd, Pansichar(st));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessResizePalette;
var
  Palette: HPALETTE;
  Entries: UINT;
  res:BOOL ;
begin
  Palette:=PopInt;
  Entries:=PopInt;
  res:= ResizePalette(Palette, Entries);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSelectClipRgn;
var
  DC: HDC;
  Region: HRGN;
  res: integer;
begin
  dc:=PopInt;
  Region:=PopInt;
  res:= SelectClipRgn(DC,region);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSelectObject;
var
  DC: HDC;
  p2: HGDIOBJ;
  res: HGDIOBJ;
begin
  dc:=PopInt;
  p2:=PopInt;
  res:= SelectObject(DC, p2);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSelectPalette;
var
  DC: HDC;
  Palette: HPALETTE;
  ForceBackground: Bool;
  res:HPALETTE ;
begin
  dc:=PopInt;
  Palette:=PopInt;
  ForceBackGround:=BOOL(PopInt);
  res:=SelectPalette(DC,Palette,ForceBackground);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetBkMode;
var
  DC: HDC;
  BkMode: Integer;
  res: integer;
begin
  dc:=PopInt;
  BkMode:=PopInt;
  res:= SetBkMode(DC, BkMode);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetCapture;
var
  wnd:Hwnd;
  res: Hwnd;
begin
  wnd:=PopInt;
  res:= SetCapture(Wnd);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetClassLongA;
var
  Wnd: HWND;
  nIndex: Integer;
  dwNewLong: Longint;
  res: Dword;
begin
  Wnd:=PopInt;
  nIndex:=PopInt;
  dwNewLong:=PopInt;
  res:= SetClassLong(Wnd,nIndex,dwNewLong);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetCursor;
var
  hCur: HCURSOR;
  res: HCURSOR ;
begin
  hCur:=PopInt;
  res:= SetCursor(hCur);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetMapMode;
var
  DC: HDC;
  p2: Integer;
  res: Integer;
begin
  DC:=PopInt;
  p2:=PopInt;
  res:= SetMapMode(DC,p2);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetPaletteEntries;
var
  Palette: HPALETTE;
  StartIndex, NumEntries: UINT;
  PaletteEntries:pointer;
  res: integer ;
begin
  Palette:=PopInt;
  StartIndex:=PopInt;
  NumEntries:=PopInt;
  try
  getmem(PaletteEntries,sizeof(TPaletteEntry)*NumEntries);
  PopBytes(PaletteEntries,sizeof(TPaletteEntry)*NumEntries);
  res:= SetPaletteEntries(Palette, StartIndex, NumEntries, PaletteEntries^);
  PushInt(intG(res));
  finally
  freemem(PaletteEntries);
  end;
end;

Procedure TThreadCom.ProcessSetPixel;
var
  DC: HDC;
  X, Y: Integer;
  Color: COLORREF;
  res: COLORREF;
begin
  DC:=PopInt;
  x:=PopInt;
  y:=PopInt;
  Color:=PopInt;
  res:= SetPixel(DC, X, Y, Color);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetPropA;
var
  Wnd: HWND;
  st:AnsiString;
  w:integer;
  hData: THandle;
  res: BOOL;
begin
  wnd:=PopInt;
  st:=PopResourceString(w);
  hData:=PopInt;
  if w>0
    then res:= SetPropA(Wnd,Pointer(w), hData)
    else res:= SetPropA(Wnd,Pansichar(st), hData);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetRectRgn;
var
  rgn:hrgn;
  x1,y1,x2,y2:integer;
  res: BOOL ;
begin
  rgn:=PopInt;
  x1 :=PopInt;
  y1 :=PopInt;
  x2 :=PopInt;
  y2 :=PopInt;
  res:=SetRectRgn(rgn,x1,y1,x2,y2);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetROP2;
var
  dc:hdc;
  p2:integer;
  res: integer;
begin
  dc:=PopInt;
  p2:=PopInt;
  res:= setRop2(dc,p2);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetTextAlign;
var
  dc:hdc;
  flags:integer;
  res: integer;
begin
  dc:=PopInt;
  flags:=PopInt;
  res:= SetTextAlign(dc,flags);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetTextColor;
var
  dc:hdc;
  color:integer;
  res: integer;
begin
  dc:=PopInt;
  color:=PopInt;
  res:= SetTextColor(dc,color);
  PushInt(intG(res));
end;



Procedure TThreadCom.ProcessSetUnhandledExceptionFilter;
var
  res:integer ;
begin

  res:=0;
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetViewportExtEx;
var
  dc:hdc;
  x,y:integer;
  size:Tsize;
  res:BOOL;
begin
  dc:=PopInt;
  x:=PopInt;
  y:=PopInt;
  PopBytes(@size,sizeof(Tsize));
  res:= SetViewportExtEx(dc,x,y,@size);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetWindowExtEx;
var
  dc:hdc;
  x,y:integer;
  size:Tsize;
  res:BOOL;
begin
  dc:=PopInt;
  x:=PopInt;
  y:=PopInt;
  PopBytes(@size,sizeof(Tsize));
  res:= SetWindowExtEx(dc,x,y,@size);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetWindowOrgEx;
var
  dc:hdc;
  x,y:integer;
  point:Tpoint;
  res: BOOL;
begin
  dc:=PopInt;
  x:=PopInt;
  y:=PopInt;
  res:= SetWindowOrgEx(dc,x,y,@point);
  PushBytes(@point,sizeof(Tpoint));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetWindowPos;
var
  Wnd: HWND;
  hWndInsertAfter: HWND;
  X, Y, cx, cy: Integer;
  uFlags: UINT;
  res:BOOL ;
begin
  Wnd :=PopInt;
  hWndInsertAfter :=PopInt;
  X  :=PopInt;
  Y  :=PopInt;
  cx :=PopInt;
  cy :=PopInt;
  uFlags :=PopInt;

  res:=SetWindowPos(Wnd,hWndInsertAfter,X, Y, cx, cy,uFlags);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessSetWindowTextA;
var
  Wnd: HWND;
  st:AnsiString;
  res: BOOL;
begin
  wnd:=PopInt;
  st:=PopString;
  res:= SetWindowTextA(Wnd,PansiChar(st));
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessShowWindow;
var
  res:BOOL;
  Wnd: HWND;
  nCmdShow: Integer;
begin
  Wnd:=PopInt;
  nCmdShow:=PopInt;
  res:=ShowWindow(Wnd, nCmdShow);

  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessStartDocA;
var
  dc:hdc;
  DocInfo:TDocInfo;
  res:integer ;
begin
  dc:=PopInt;
  PopBytes(@DocInfo,sizeof(TDocInfo));

  res:=StartDoc(dc,DocInfo);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessStartPage;
var
  DC: HDC;
  res: integer;
begin
  dc:=PopInt;
  res:= StartPage(DC);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessStretchBlt;
var
  DestDC: HDC;
  X, Y, Width, Height: Integer;
  SrcDC: HDC;
  XSrc, YSrc, SrcWidth, SrcHeight: Integer;
  Rop: DWORD;
  res: BOOL;
begin
  DestDC   :=PopInt;
  X        :=PopInt;
  Y        :=PopInt;
  Width    :=PopInt;
  Height   :=PopInt;
  SrcDC    :=PopInt;
  XSrc     :=PopInt;
  YSrc     :=PopInt;
  SrcWidth :=PopInt;
  SrcHeight:=PopInt;
  Rop      :=PopInt;
  res:= StretchBlt(DestDC,X, Y, Width, Height,SrcDC,XSrc, YSrc, SrcWidth, SrcHeight,Rop);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessTextOutA;
var
  DC: HDC;
  X, Y: Integer;
  st:AnsiString;
  Count: Integer;
  res: BOOL;
begin
  DC   :=PopInt;
  X    :=PopInt;
  Y    :=PopInt;
  st   :=PopString;
  Count:=PopInt;
  res:= TextOutA(DC,X, Y, Pansichar(st), Count);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessTranslateMessage;
var
  Msg: TMsg;
  res:BOOL;
begin
  PopBytes(@Msg,sizeof(Tmsg));
  res:= TranslateMessage(Msg);
  PushInt(intG(res));
end;


Procedure TThreadCom.ProcessUpdateWindow;
var
  wnd:HWND;
  res:BOOL;
begin
  wnd:=PopInt;
  res:= UpdateWindow(Wnd);

  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessValidateRect;
var
  Wnd: HWND;
  Rect: TRect;
  res: BOOL;
begin
  wnd:=PopInt;
  PopBytes(@rect,sizeof(Trect));
  res:= ValidateRect(Wnd,@Rect);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessWinExec;
var
  CmdLine:AnsiString;
  uCmdShow: UINT;
  res: UINT;
begin
  CmdLine:=PopString;
  uCmdShow:=PopInt;

  res:= WinExec( PansiChar(CmdLine), uCmdShow);
  PushInt(intG(res));
end;

Procedure TThreadCom.ProcessDrawTextA;
var
  DC: HDC;
  lpString: AnsiString;
  nCount: Integer;
  lpRect: TRect;
  uFormat: UINT;
  res:integer;
begin
  DC:=popint;
  lpString:=PopString;
  nCount:=popint;
  PopBytes(@lpRect,sizeof(Trect));
  uFormat:=popint;
  res:= DrawTextA(DC, PansiChar(lpString), nCount, lpRect, uFormat);

  PushInt(res);
end;


procedure TthreadCom.ProcessGetModuleHandleA;
var
  lpString:AnsiString;
  res:integer;
begin
  lpString:=PopString;
  {res:=GetModuleHandleA(PansiChar(lpString));}
  {$IFDEF FPC}
  res:=MainInstance;
  {$ELSE}
  res:=sysinit.HInstance;
  {$ENDIF}
  PushInt(res);
end;

procedure TthreadCom.ProcessExpandFileName;
var
  st:AnsiString;
begin
  st:=PopString;
  st:=ExpandFileName(st);
  PushString(st);
  PushInt(0);
end;


var
  SymList:TstringList;
  FlagCall:boolean;
  UserCommandResult:integer;
  UserCommandBufferIN: PBYTE;
  UserCommandSizeIN:integer;

  UserCommandBufferOUT: PBYTE;
  UserCommandSizeOUT:integer;
  PbufOut: PBYTE;

{
procedure getStL(stL:TstringList);
var
  st:AnsiString;
  stL1:TstringList;
  i,j,nb:integer;
begin
  nb:=PopInt;

  for i:=1 to nb do
  begin
    st:=PopString;
    if (length(st)>0) and (st[length(st)]='.') then
    begin
      stL1:=TstringList.create;
      getStL(stL1);
      for j:=0 to stL1.count-1 do
        stL.Add(st+stL1[j]);
      stL1.Free;
    end
    else stL.Add(st);
  end;
end;
}

procedure getStL(stL:TstringList;RootName:AnsiString);
var
  i,nb:integer;
  st:AnsiString;
begin
  nb:=PopInt;
  stL.AddObject(RootName,pointer(nb));

  for i:=1 to nb do
  begin
    st:=PopString;
    if (length(st)>0) and (st[length(st)]='.')
      then getStL(stL,st)
      else stL.Add(st);
  end;
end;

procedure TThreadCom.ProcessGetSymList;
var
  i,nb:integer;
begin
  if not assigned(SymList) then SymList:=TstringList.create;

  SymList.Clear;
  getStL(SymList,'Root');

  //nb:=PopInt;
  //for i:=0 to nb-1 do SymList.Add(PopString);
  FlagCall:=false;
end;

procedure TThreadCom.ProcessUserCommand;
begin
  UserCommandResult:=PopInt;
  UserCommandSizeIN:=PopInt;

  Reallocmem(UserCommandBufferIN,UserCommandSizeIN);
  PopBytes(UserCommandBufferIN,UserCommandSizeIN);

  if UserCommandSizeOut<>0 then
  begin
    PushBytes(UserCommandBufferOut,UserCommandSizeOut);
    UserCommandSizeOut:=0;
  end;

  FlagCall:=false;
end;

procedure TthreadCom.ProcessSetSymbolNames;
var
  i:integer;
begin
  if assigned(SymList) then
  begin
    PushInt(SymList.Count);
    for i:=0 to SymList.Count-1 do PushString(SymList[i]);
  end
  else PushInt(0);

  FlagCall:=false;
end;


var
  integer1:array of integer;
  double1,double2:array of double;


Procedure TthreadCom.ProcessSetAcqScaleParams;
var
  i,n:integer;
begin
  n:=length(double1);
  PushInt(n);

  for i:=0 to n-1 do
  begin
    pushBytes(@double1[i],8);
    pushBytes(@double2[i],8);
  end;

  FlagCall:=false;
end;

Procedure TthreadCom.ProcessSetOutputNumbers;
var
  i,n:integer;
begin
  n:=length(integer1);
  PushInt(n);

  for i:=0 to n-1 do pushInt(integer1[i]);

  FlagCall:=false;
end;


Procedure TthreadCom.ProcessSetOutScaleParams;
var
  i,n:integer;
begin
  n:=length(double1);
  PushInt(n);

  for i:=0 to n-1 do
  begin
    pushBytes(@double1[i],8);
    pushBytes(@double2[i],8);
  end;

  FlagCall:=false;
end;


var
  string1:AnsiString;

procedure TthreadCom.ProcessTextCommand;
begin
  PushString(String1);
  FlagCall:=false;
end;


{*********************************** End TthreadCom Methods ******************}


function GetAcqBufferAd:pointer;
begin
  result:=AcqMemRec;
  inc(intG(result),sizeof(TAcqShareMemRec));
end;

function GetAcqBufferSize:integer;
begin
  if assigned(AcqMemRec)
    then result:=AcqMemRec^.size div 2 -sizeof(TAcqShareMemRec)
    else result:=0;
end;

function GetStimBufferAd:pointer;
begin
  result:=AcqMemRec;
  inc(intG(result), AcqMemRec^.size div 2);
end;

function GetStimBufferSize:integer;
begin
  if assigned(AcqMemRec)
    then result:=(AcqMemRec^.size) div 2
    else result:=0;
end;


Const
  Delay0=1000;

function WaitForFlagCall:boolean;
var
  t0:integer;
begin
  t0:=getTickCount;
  repeat until not FlagCall or (getTickCount-t0>Delay0) or MemRec^.EndFlag;

  result:= FlagCall;
end;

function WaitForReadLineFlag:boolean;
var
  t0:integer;
begin
  t0:=getTickCount;
  Repeat until MemRec^.ReadLineFlag or (getTickCount-t0>1000);
  result:=MemRec^.ReadLineFlag;
  if not result then messageCentral('Not Readline');

end;

{La procédure appelante doit libérer la stringList }
function GetSymList(cat,delay:integer):TstringList;
var
  i:integer;
  t0:integer;
begin
//  WaitForReadLineFlag;
  FlagCall:=true;

  {si l'appel précédent a échoué et si la réponse est arrivée trop tard }
  SymList.Free;
  SymList:=nil;

  PostThreadMessage(ThreadCom.ThreadID, MSG_GetSymList, cat, 0);

  t0:=getTickCount;
  repeat until not FlagCall or (getTickCount-t0>Delay);

  result:=SymList;
  SymList:=nil;
end;



function SendUserCommand(num,param:integer):integer;
var
  t0:integer;
  TimeOut:boolean;
begin
  FlagCall:=true;
  TimeOut:=false;
  t0:=getTickCount;
  repeat
    if PostThreadMessage(ThreadCom.ThreadID, MSG_UserCommand, num, param) then
    begin
      repeat
        timeOut:= (getTickCount-t0>Delay0);
      until not FlagCall or TimeOut;
    end
    else sleep(10);
    timeOut:= (getTickCount-t0>Delay0);
  until not FlagCall or TimeOut;

  if FlagCall
    then result:=1000
    else result:=UserCommandResult;
end;

{**************************** Gestion du buffer Out temporaire des User commands ********************************}

procedure ResetBufOut;
begin
  if not assigned(UserCommandBufferOUT) then getmem(UserCommandBufferOUT,1000);
  PbufOut:=UserCommandBufferOUT;
  UserCommandSizeOUT:=0;
end;

procedure PushBufInt( X:integer);
begin
  Pinteger(PbufOut)^:=X;
  inc(intG(PbufOut),4);
  inc(UserCommandSizeOUT,4);
end;

procedure PushBufBytes(p:Pbyte; count:integer);
begin
  move(p^,PbufOut^,count);
  inc(intG(PbufOut),count);
  inc(UserCommandSizeOUT,count);
end;


procedure PushBufString(st:AnsiString);
var
  len:integer;
begin
  len:= length(st);

  PushBufInt(len);
  if len>0 then PushBufBytes(@st[1],length(st));
end;



{User Command 1 }
function StartRT:integer;
begin
  result:=SendUserCommand(1,0);
end;

{User Command 2 }
function StopRT:integer;
begin
  result:=SendUserCommand(2,0);
end;


{User Command 3 }
function SetRTdefaults:integer;
begin
  result:=SendUserCommand(3, 0 );
end;

{User Command 4 }
function GetTestData(VnbData,VTdata:Tvector):integer;
var
  i,n:integer;
begin
  result:=SendUserCommand(4, 0 );

  n:=UserCommandSizeIN div 8;
  VnbData.modify(g_longint,0,n-1);
  VTData.modify(g_longint,0,n-1);

  for i:=0 to n-1 do
  begin
    VnbData.Jvalue[i]:=Ptablong(UserCommandBufferIN)^[i*2];
    VTData.Jvalue[i]:=Ptablong(UserCommandBufferIN)^[i*2+1];
  end;
end;

{User Command 10 }
function GetTestData2(VnbData,VTdata:Tvector):integer;
var
  i,n:integer;
begin
  result:=SendUserCommand(10, 0 );

  n:=UserCommandSizeIN div 8;
  VnbData.modify(g_longint,0,n-1);
  VTData.modify(g_longint,0,n-1);

  for i:=0 to n-1 do
  begin
    VnbData.Jvalue[i]:=Ptablong(UserCommandBufferIN)^[i*2];
    VTData.Jvalue[i]:=Ptablong(UserCommandBufferIN)^[i*2+1];
  end;
end;


{User Command 5 }
function SetNrnText(st:AnsiString):integer;
begin
  resetBufOut;
  PushBufString(st);
  result:=SendUserCommand(5, 0 );
end;

{User Command 6 }
function GetNrnValue1(var w:double):integer;
begin
  result:=SendUserCommand(6, 0 );

  if UserCommandSizeIN=8 then w:=Pdouble(UserCommandBufferIN)^;
end;

function GetNrnValue(st:AnsiString):double;
begin
  setNrnText(st);
  getNrnValue1(result);
end;

{User Command 7 }
function GetNrnStepDuration1(var w:double):integer;
begin
  result:=SendUserCommand(7, 0 );

  if UserCommandSizeIN=8 then w:=Pdouble(UserCommandBufferIN)^;
end;

{User Command 8 }
function SetPstimOffset(n:integer):integer;
begin
  result:=SendUserCommand(8, n );
end;


{User Command 9 }
function SetPstimON(bb:boolean):integer;
begin
  result:=SendUserCommand(9, ord(bb) );
end;


function GetNrnStepDuration:double;
begin
  GetNrnStepDuration1(result);
end;

function GetCount:integer;
begin
  if assigned(AcqMemRec)
    then result:=AcqMemRec^.Count
    else result:=0;

//  statuslineTxt(Istr(result));
end;



function SendTextCommand(st:AnsiString;delay0:integer): boolean;
var
  t0:integer;
  TimeOut:boolean;
begin
  if Memrec^.EndFlag then exit;
  String1:=st;

  FlagCall:=true;
  TimeOut:=false;

  t0:=getTickCount;
  repeat
    if PostThreadMessage(ThreadCom.ThreadID, MSG_TextCommand, 0, 0) then
    begin
      repeat
        timeOut:= (getTickCount-t0>Delay0);
      until not FlagCall or TimeOut;
    end
    else sleep(10);
    timeOut:= (getTickCount-t0>Delay0);
  until not FlagCall or TimeOut;
  String1:='';

  result:= not FlagCall;
end;

procedure SetRTRecInfo(rec: TRTrecInfo);
begin
  AcqMemRec^.URec:=rec;
end;

var
  consoleG:TconsoleE;

{ ConsoleTool }
const
  maxBuf=1000;
type
  TconsoleTool=class
                 timer1:Ttimer;
                 buf: array[0..maxBuf] of AnsiString;
                 Iread, Iwrite:integer;

                 constructor create;
                 destructor destroy;
                 procedure Timer1Timer(Sender: TObject);
                 procedure ProcessInputLine(st:AnsiString; editSrc: Tedit5);
                 function read:AnsiString;
                 procedure UpdateConsole;
                 procedure writeln(st:AnsiString);

                 procedure ShowStatInst(sender:Tobject);
               end;

var
  consoleTool:TconsoleTool;

{ TthreadConsole }

function TthreadConsole.empty: boolean;
begin
  result:=(PrintMem=nil) or(printMem^.Iread>=printMem^.Iwrite);
end;

procedure TthreadConsole.execute;
var
  res:word;
  error:integer;
  cnt:integer;
begin
  cnt:=0;
  repeat
    if (hPrintSem<>nil) then
    begin
      res:=ntxWaitForRtSemaphore(hPrintSem, 1,1000);
      if res<>NTX_ERROR then ProcessStrings
      else sleep(100);
    end
    else sleep(100);

  until terminated ;
end;

function TthreadConsole.nextChar: char;
begin
  with printMem^ do
  begin
    result:=  buf[Iread mod MaxPrintBuf];
    inc(Iread);
  end;
end;


procedure TthreadConsole.ProcessStrings;
var
  l,i:integer;
  st:AnsiString;
  ch:char;
begin
  while Not Empty do
  begin
    l:=0;
    for i:=0 to 3 do l:= l + byte(nextChar) shl (i*8);
    st:='';
    for i:=1 to l do
    begin
      ch:= nextChar;
      if (ord(ch)>=32) then st:=st+ch;
    end;
    consoleTool.writeln(st);
  end;
end;

{ RTconsole }


function RTconsole:TconsoleE;
begin
  if not assigned(consoleG) then initRTconsole;
  result:=consoleG;
end;


{ TconsoleTool }

constructor TconsoleTool.create;
begin
  timer1:=Ttimer.create(nil);
  timer1.OnTimer:=Timer1Timer;
  timer1.Interval:=200;
end;

destructor TconsoleTool.destroy;
begin
  timer1.Free;
end;

procedure TconsoleTool.ProcessInputLine(st: AnsiString; editSrc: Tedit5);
begin
  SendTextCommand(st,100);
end;

function TconsoleTool.read: AnsiString;
begin
  if Iread<Iwrite then
  begin
    result:=buf[Iread mod maxBuf];
    buf[Iread mod maxBuf]:='';
    inc(Iread);
  end;
end;

procedure TconsoleTool.Timer1Timer(Sender: TObject);
begin
  UpdateConsole;
end;

procedure TconsoleTool.UpdateConsole;
begin
   while Iread<Iwrite do RTconsole.AddLine(read);
end;

procedure TconsoleTool.writeln(st: AnsiString);
begin
  buf[Iwrite mod maxBuf]:=st;
  inc(Iwrite);
end;


function SortList(List: TStringList; Index1, Index2: Integer): Integer;
begin
  result:= intG(List.Objects[index2]) - intG(List.Objects[index1]) ;
end;

procedure TconsoleTool.ShowStatInst(sender:Tobject);
var
  stList:TstringList;
  form:TviewText;
  i:integer;
begin
  stList:=TstringList.create;
  for i:=1 to 118 do
    stList.AddObject(nameInst(i),pointer(StatInst[i]));
  stList.CustomSort(SortList);


  form:=TviewText.create(formStm);
  for i:=0 to stList.Count-1 do
    form.Memo1.Lines.Add(stList[i]+' = '+Istr( intG(stList.Objects[i])));


  form.showModal;
  form.free;
  stList.free;
end;

procedure initRTconsole;
begin
  if not assigned(consoleG) then
  begin
    consoleTool:=TconsoleTool.create;

    consoleG:=TconsoleE.Create(formstm);
    consoleG.Caption:='NEURON console';
    consoleG.Init(nil);
    consoleG.ProcessLine:=consoleTool.ProcessInputLine;
    consoleG.Debug1.Visible:=true;
    consoleG.Debug1.OnClick:=consoleTool.showStatInst;
  end;
end;

procedure SetRTFlagStim(w:boolean);
begin
  AcqMemRec^.URec.FlagStim:=w;
end;

Initialization
AffDebug('Initialization RTcom2',0);

finalization
  StopWinEmul;
  if assigned(hProcess) then ntxTerminateRtProcess(hProcess);

end.
