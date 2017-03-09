unit RTcom1;

interface

uses windows,classes,messages,sysutils,
     ntx, util1;


Const
//  stFileRTcom = 'D:\VSprojects\WinEmul1\Debug\WinEmul1.rta';
  stFileRTcom = 'D:\VSprojects\nrnVS6\rtdebug\NrnRT1.rta';
//    stFileRTcom = 'D:\VSprojects\nrnVS6\nrnRT3\debug\NrnRT3.rta';

  LauchRTA = true;
var
  stat:array[1..200] of integer;
  Nstat:integer;



function InitRTcom(Launch:boolean):boolean;
procedure InstallAddresses;
procedure initMsgList;


procedure StartWinEmul;
procedure StopWinEmul;
procedure PostTest;

implementation

uses test0;

var
  FlagStat:boolean;
  FlagCall:boolean;

function errorString(status:integer):string;
var
  res:integer;
begin
  setlength(result,255);
  res:=ntxLoadRtErrorString(status,@result[1],254);
  setlength(result,res);
end;


procedure MemoWriteln(st:string);
begin
{
  form1.memo1.Lines.Add(st);
  form1.memo1.Invalidate;
}
end;

procedure MemoWriteln2(st:string);
begin
{
  form1.memo1.Lines.Add(st);
  form1.memo1.Invalidate;
}
end;

procedure MemoWriteln3(st:string);
begin

  form1.memo1.Lines.Add(st);
  form1.memo1.Invalidate;

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

  K_GetSymList                   =200;

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

                procedure ProcessInst;
                procedure execute;override;
             end;



var
  RTLocation:NTXLOCATION;
  RTroot,hSemaphore,hSemaphore2,hMailBox,hmem:NTXHANDLE;
  pZone:pointer;

  threadCom:TthreadCom;


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
               end;
  PmemRec=^TshareMemRec;
var
  MemRec:PMemRec;
  shareMemSize:integer;

function InitRTcom(Launch:boolean):boolean;
var
  status:integer;
  att:NTXPROCATTRIBS;
  hProc: NTXHANDLE;
begin
  result:=false;
  if not initNtxDLL then exit;
  if not initNtxExDLL then exit;;

  RTlocation:=ntxGetFirstLocation;
  RTroot:=ntxGetRootRTprocess(RTlocation);
  if RTroot=NTX_BAD_NTXHANDLE then messageCentral('RTroot=bad');

  if Launch then
  begin
    att.dwPoolMin:=1024*1024*32;
    att.dwPoolMax:=$FFFFFFFF;
    att.dwVsegSize:=1024*1024*16;
    att.dwObjDirSize:= 64;


    hProc:=ntxCreateRTProcess(RTlocation, stFileRTcom,'',@att,0);
    if hProc=pointer(-1) then
    begin
      messageCentral('Unable to load '+stFileRTcom);
      exit;
    end;
  end
  else
  begin
    {Si hSemaphore existe au lancement, on le détruit}
    hSemaphore:=ntxLookupNtxHandle(RTroot,'SEMAPHORE1',0);
    if hSemaphore<>NTX_BAD_NTXHANDLE
      then ntxUncatalogNtxHandle(RTroot,hSemaphore,'SEMAPHORE1');
  end;

  repeat
    hSemaphore:=ntxLookupNtxHandle(RTroot,'SEMAPHORE1',1000);
    if testEscape then exit;
  until (hSemaphore<>NTX_BAD_NTXHANDLE);


  hSemaphore2:=ntxLookupNtxHandle(RTroot,'SEMAPHORE2',1000);

  hMailBox:=ntxLookupNtxHandle(RTroot,'MAILBOX1',1000);
  hMem:=ntxLookupNtxHandle(RTroot,'MEM1',1000);
  pzone:=ntxMapRtSharedMemory(hMem );

  if assigned(pzone) then shareMemSize:=Pinteger(pzone)^;


  status:=ntxGetLastRtError;

  if pzone=nil then
  begin
    messageCentral(errorString(status)+crlf+
                 'ShareMemSize='+Istr(ShareMemSize)
                  );

    messageCentral('hSemaphore='+Istr(integer(hSemaphore))+crlf+
                 'hSemaphore2='+Istr(integer(hSemaphore2))+crlf+
                 'hMailBox='+Istr(integer(hMailBox))+crlf+
                 'hMem='+Istr(integer(hMem))+crlf+
                 'pzone='+Istr(integer(pZone))+crlf+
                 'error='+Istr(status)
                 );
    exit;
  end;

  result:=true;

end;

procedure InstallAddresses;
begin
  MemRec:=Pzone;

  PwinStackIn:= pointer(integer(pzone)+sizeof(TshareMemRec));
  PwinStackOut:=pointer(integer(pzone)+(memrec^.size div 2));

  PStackIn:=PwinStackIn;
  PStackOut:=PwinStackOut;

  PstackInEnd:=PwinStackOut;
  PstackOutEnd:=pointer(integer(pzone)+memrec^.size );
end;

procedure StopWinEmul;
var
  res:boolean;
  Msg:TMsg;
  FlagFin:boolean;
begin
  if not assigned(ThreadCom) then exit;
  MemoWriteln3('StopWin 1');
  FlagFin:=false;
  res:=PostThreadMessage(ThreadCom.ThreadID, WM_QUIT, 0, 0);
  {messageCentral('res='+Bstr(res));}
  repeat
    if peekMessage(Msg,form1.Handle,wm_keydown,wm_keydown,pm_remove) then
    begin
      if msg.wparam= vk_escape then Flagfin:=true;
      translateMessage(Msg);
      DispatchMessage(Msg);
    end;

  until MemRec^.endFlag or FlagFin;
  MemoWriteln3('StopWin 2');

  if not MemRec^.endFlag then
  begin
    MemRec^.endFlag1:=true;
    ntxReleaseRtSemaphore(hSemaphore,1);
    ntxReleaseRtSemaphore(hSemaphore2,1);
    repeat
    until ThreadCom.Terminated or testEscape;
  end;

  MemoWriteln3('StopWin 3');
  ThreadCom.Free;
  ThreadCom:=nil;
  MemoWriteln3('StopWin 4');
end;


procedure StartWinEmul;
begin
  if assigned(ThreadCom) then exit;

  if not initRTcom(LauchRTA) then exit;
  InstallAddresses;
  initMsgList;

  threadCom:=TthreadCom.Create(false);
  threadCom.Priority:= tpHighest;

  MemRec^.startFlag:=TRUE;
  ntxReleaseRtSemaphore(hSemaphore2,1);
  form1.Lstatus.Caption:='Running';
end;


function ControleStackOut(n:integer):boolean;
begin
  if (longword(PstackOut)<longword(PWinstackOut)) or (longword(PstackOut)>longword(PstackOutEnd)-n) then
  begin
    MemoWriteln2('StackOut overflow');
    PostThreadMessage(ThreadCom.ThreadID, WM_QUIT, 0, 0);
    result:=false
  end
  else result:=true;
end;

procedure PushInt( X:integer);
begin
  if not ControleStackOut(4) then exit;

  Pinteger(PStackOut)^:=X;
  inc(integer(PStackOut),4);
end;

procedure PushBytes(p:Pbyte; count:integer);
begin
  if not ControleStackOut(count) then exit;
  move(p^,PStackOut^,count);
  inc(integer(PStackOut),count);
end;


procedure PushString(st:string);
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
  inc(integer(PStackOut),4);
end;

procedure PopBytes(p:PBYTE; count:integer);
begin
  if not ControleStackOut(count) then exit;
  move(PStackOut^,p^,count);
  inc(integer(PStackOut),count);
end;

function PopString:string;
var
  n:integer;
begin
  n:=PopInt;
  if not ControleStackOut(n) then exit;
  setLength(result,n);
  if n>0 then move(PStackOut^,result[1],n);
  inc(integer(PStackOut),n);
end;

function PopResourceString(var w:integer):string;
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
    inc(integer(PStackOut),n);
  end;
end;

function PresourceString(var st:string;w:integer):pointer;
begin
  if w>0
    then result:=pointer(w)
    else result:=Pchar(st);
end;


{******************* Gestion des window proc ***********************************************}

var
  RTwndProc:array[1..5] of pointer;
  NbRTwndProc:integer;

  MsgList:Tlist;

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

function ControlePstackIn:boolean;
begin
  if longword(PstackIn)>longword(PstackInEnd)-sizeof(TwinProcParam) then
  begin
    MemoWriteln2('StackIN overflow');
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

  MemoWriteln2('WindowProc Before '+Istr(num)+' win= '+Istr(wnd)+' msg='+Istr(msg) );
  p:=PwinProcParam(PstackIn);
  if not controlePstackIn then exit;

  if form1.ButtonFlag then
    MemoWriteln3('WindoProc1 msg='+Istr(msg));


  p^.func:=RTwndProc[num];
  p^.wnd:=wnd;
  p^.msg:=msg;
  p^.wparam:=wparam;
  p^.lparam:=lparam;
  inc(integer(PstackIn),sizeof(TwinProcParam));
  Pextra:=PstackIn;

  case msg of
    WM_CREATE:        begin
                        move(pointer(lparam)^,PstackIn^,sizeof(TCREATESTRUCT));
                        inc(integer(PstackIn),sizeof(TCREATESTRUCT));
                        p^.extraSize:=sizeof(TCREATESTRUCT);
                      end;
                      
    WM_GETMINMAXINFO: if lparam<>0 then
                      begin
                        move(pointer(lparam)^,PstackIn^,sizeof(TminmaxInfo));
                        inc(integer(PstackIn),sizeof(TminmaxInfo));
                        p^.extraSize:=sizeof(TminmaxInfo);
                      end;
    else p^.extraSize:=0;
  end;


  p^.flag:=true;
  ntxReleaseRtSemaphore(hSemaphore2,1);
  MemoWriteln2('WindowProc Between func='+Istr(integer(p^.func)));

  cnt:=0;
  cntProcess:=0;
  fillchar(cntErr,sizeof(cntErr),0);

  if (msg=15) then
  begin
    FlagStat:=true;
    fillchar(stat,sizeof(stat),0);
  end;

  repeat
    tt:=getTickCount;
    res:=ntxWaitForRtSemaphore(hSemaphore, 1,100);
    if memrec^.EndFlag1 then exit;

    tt:=getTickCount-tt;
    if tt>ttmax then ttmax:=tt;

    if (res=NTX_ERROR) then
    begin
      error:= ntxGetLastRtError;
      if error<>1 then MemoWriteln3('WinProc error='+Istr(error));
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

      MemoWriteln('winproc0 endflag');
      exit;
    end;
    inc(cnt);
  until (not p^.flag) and (res=0);
  if (msg=15) then FlagStat:=false;

  case msg of
    WM_GETMINMAXINFO: if lparam<>0 then
                      begin
                        move(Pextra^,pointer(lparam)^,sizeof(TminmaxInfo));
                      end;
  end;


  result:=p^.res;
  PstackIn:=p;

  if cnt>2 then
{    MemoWriteln3('WindowProc '+Istr(num)+' win= '+Istr(wnd)+' msg='+Istr(msg)+'  cnt='+Istr(cnt) +'  ttmax='+Istr(ttmax) );
    MemoWriteln3('WindoProc msg='+Istr(msg)+'  Err='+Istr1(cntErr[1],5)+Istr1(cntErr[2],5)+
                                  Istr1(cntErr[3],5)+Istr1(cntErr[4],5)+Istr1(cntErr[5],5)+
                                  Istr1(cntErr[6],5)+' cntProcess='+Istr(cntProcess) );         }
  if form1.ButtonFlag then
    MemoWriteln3('WindoProc msg='+Istr(msg));

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
begin
  repeat
    res:=ntxWaitForRtSemaphore(hSemaphore, 1,1000);

    if (res=NTX_ERROR) or MemRec^.EndFlag
      then terminate
      else ProcessInst;
  until terminated ;

  MemoWriteln('ThreadCom is stopped');
end;

procedure TthreadCom.ProcessInst;
var
  NumInst:integer;
  Pindex:pointer;
  Pflag:PBOOL;
begin
  Pindex:=PstackOut;
  inc(integer(PstackOut),4);
  Pflag:=PstackOut;
  inc(integer(PstackOut),4);

  NumInst:=Pinteger(Pindex)^;
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
  end;

  if (FlagStat) and (NumInst>=1) and (NumInst<=200) then inc(stat[NumInst]);
  inc(Nstat);

  MemoWriteln('Process '+Istr(Pinteger(Pindex)^)+'  PstackOut='+Istr((integer(PstackOut)-integer(PwinStackOut)))
                         +' Pindex='+Istr((integer(Pindex)-integer(PwinStackOut))));
  PstackOut:=Pindex;
  PFlag^:=true;
  ntxReleaseRtSemaphore(hSemaphore2,1);
end;



Procedure TThreadCom.Processchdir;
var
  st:string;
  res:integer;
begin
  st:=PopString;

  chdir(st);
  res:= IOresult;
  if res=0
    then PushInt(0)
    else PushInt(-1);
  MemoWriteln('chdir '+Istr(res)+' '+st);
end;

Procedure TThreadCom.Processgetcwd;
var
  st:string;
  nmax:integer;
begin
  nmax:=PopInt;
  st:=GetCurrentDir;
  st:=copy(st,1,nmax);
  MemoWriteln('nmax='+Istr(nmax)+' : '+st+'...len='+Istr(length(st)));
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

  pushInt(integer(res));
end;

Procedure TThreadCom.ProcessBringWindowToTop;
var
  wnd:HWND;
  res:BOOL;
  point:Tpoint;
begin
  wnd:=Popint;
  res:= BringWindowToTop(Wnd);
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  lpExistingFileName, lpNewFileName:string;
  bFailIfExists:BOOL;
  res:BOOL;
begin
  lpExistingFileName:=PopString;
  lpNewFileName:=PopString;
  bFailIfExists:=BOOL(PopInt);

  res:=CopyFile(Pchar(lpExistingFileName),Pchar(lpNewFileName),bFailIfExists);
  PushInt(integer(res));

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
 PushInt(integer(res));

 with p1 do
 Memowriteln3('CreateBitmapIndirect'+
    Istr1(bmType,6)+
    Istr1(bmWidth,6)+
    Istr1(bmHeight,6)+
    Istr1(bmWidthBytes,6)+
    Istr1(bmPlanes,6)+
    Istr1(bmBitsPixel,6)+
    Istr1(integer(bmBits),10));

end;

Procedure TThreadCom.ProcessCreateBrushIndirect;
var
  p1: TLogBrush;
  res:HBRUSH;
begin
  PopBytes(@p1,sizeof(TlogBrush));
  res:=CreateBrushIndirect(p1);
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessCreateCompatibleDC;
var
  res:HDC;
  DC: HDC;
begin
  DC:=PopInt;
  res:=CreateCompatibleDC(DC);
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessCreateFontIndirectA;
var
  p1: TLogFont;
  res: HFONT;
begin
  PopBytes(@p1,sizeof(TLogFont));
  res:= CreateFontIndirect(p1);
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessCreatePalette;
var
  LP: array[1..1028] of byte;
  LogPalette: TLogPalette absolute LP;
  res: Hpalette;
begin
  PopBytes(@LP,1028);
  res:=CreatePalette(LogPalette);
  PushInt(integer(res));

  Memowriteln3('CreatePalette');
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessCreatePenIndirect;
var
  LogPen: TLogPen;
  res: Hpen;
begin
  PopBytes(@LogPen,sizeof(LogPen));
  res:= CreatePenIndirect(LogPen);
  PushInt(integer(res));
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
  PushInt(integer(res));

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
  PushInt(integer(res));

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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessCreateRectRgnIndirect;
var
  p1: TRect;
  res:hrgn ;
begin
  PopBytes(@p1,sizeof(Trect));
  res:=CreateRectRgnIndirect(p1);
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessCreateWindowExA;
var
    dwExStyle: DWORD;
    lpClassName: string;
    w:integer;
    lpWindowName: string;
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

    if hinstance=0 then hinstance:=sysinit.HInstance;

    wnd:=CreateWindowExA(dwExStyle,PresourceString(lpClassName,w),Pchar(lpWindowName),dwStyle,
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessDeleteObject;
var
  p1: HGDIOBJ;
  res: BOOL;
begin
  p1:=PopInt;
  res:= DeleteObject(p1);
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessDestroyCursor;
var
  hCur: HCursor;
  res: BOOL;
begin
  hCur:=PopInt;
  res:= DestroyCursor(hCur);
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessDestroyWindow;
var
  Wnd: HWND;
  res: BOOL ;
begin
  Wnd:=PopInt;
  res:= DestroyWindow(Wnd);
  PushInt(integer(res));
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
  PushInt(integer(res));

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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessEndPage;
var
  DC: HDC;
  res: integer;
begin
  dc:=PopInt;
  res:= EndPage(DC);
  PushInt(integer(res));
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

  Pushint(integer(res));
end;

Procedure TThreadCom.ProcessFindClose;
var
  hFindFile: THandle;
  res: BOOL ;
begin
  hFindFile:=PopInt;
  res:= windows.FindClose(hFindFile);
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessFindFirstFileA;
var
  lpFileName: string;
  lpFindFileData: TWIN32FindDataA;
  res: THandle;
begin
  lpFileName:=PopString;
  res:= FindFirstFileA(Pchar(lpFileName), lpFindFileData);
  PushBytes(@lpFindFileData,sizeof(TWIN32FindDataA));

  PushInt(integer(res));
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

  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
  finally
  freemem(ABCstructs);
  end;
end;

Procedure TThreadCom.ProcessGetClassInfoA;
var
  hInstance: HINST;
  ClassName: string;
  w:integer;
  WndClass: TWndClass;
  res: BOOL ;
begin
  hInstance:=PopInt;
  ClassName:=PopResourceString(w);

  res:=GetClassInfo(hInstance, PresourceString(ClassName,w),WndClass);

  PushBytes(@WndClass,sizeof(TwndClass));
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessGetDC;
var
  wnd:Hwnd;
  res: integer ;
begin
  wnd:=PopInt;
  res:=getDc(wnd);
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessGetDesktopWindow;
var
  res: Hwnd;
begin
  res:=GetDeskTopWindow;
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessGetMapMode;
var
  dc:Hdc;
  res:integer ;
begin
  dc:=PopInt;
  res:= GetMapMode(dc);
  PushInt(integer(res));
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

  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessGetMessageTime;
var
  res:integer ;
begin
  res:= GetMessageTime;
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessGetPrivateProfileStringA;
var
  lpAppName, lpKeyName, lpDefault, lpReturnedString,lpFileName: string;
  nSize:integer;
  res: integer;
begin
  lpAppName :=PopString;
  lpKeyName :=PopString;
  lpDefault :=PopString;
  nSize:=PopInt;
  lpFileName:=PopString;

  setLength(lpReturnedString,nSize+1);
  res:=GetPrivateProfileStringA(Pchar(lpAppName), Pchar(lpKeyName), Pchar(lpDefault),
           Pchar(lpReturnedString),nSize,Pchar(lpFileName));
  PushString(lpReturnedString);
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessGetProfileStringA;
var
  lpAppName, lpKeyName, lpDefault,lpReturnedString:string;
  nsize:integer;
  res:integer;
begin
  lpAppName :=PopString;
  lpKeyName :=PopString;
  lpDefault :=PopString;
  nSize:=PopInt;
  setLength(lpReturnedString,nSize+1);
  res:=GetProfileString(Pchar(lpAppName), Pchar(lpKeyName), Pchar(lpDefault),
             Pchar(lpReturnedString),nSize);
  PushString(lpReturnedString);
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessGetPropA;
var
  Wnd: HWND;
  lpString: string;
  w:integer;
  res: THandle;
begin
  Wnd:=Popint;
  lpString:=PopResourceString(w);
  res:= GetPropA(Wnd, PresourceString(lpString,w));

  PushInt(integer(res));

  Memowriteln2('GetProp '+lpString+'stack='+Istr(integer(PstackOut)-Integer(PwinStackOut))+ ' wnd='+Istr(wnd)+' res='+Istr(res));
end;

Procedure TThreadCom.ProcessGetStockObject;
var
  index:integer;
  res:HGDIOBJ;
begin
  index:=Popint;
  res:= GetStockObject(Index);
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessGetSystemMetrics;
var
  index:integer;
  res: integer;
begin
  index:=PopInt;
  res:= GetSystemMetrics(Index);
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessIsWindowVisible;
var
  res:BOOL ;
  wnd:Hwnd;
begin
  wnd:=PopInt;
  res:=IsWindowVisible(wnd);
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessLoadBitmapA;
var
  hInstance: HINST;
  lpBitmapName: string;
  w:integer;
  res: HBITMAP;
begin
  hInstance:=PopInt;
  lpBitmapName:=PopResourceString(w);
  res:= LoadBitmap(hInstance,PresourceString(lpBitmapName,w));
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessLoadCursorA;
var
  hInstance: HINST;
  lpCursorName: string;
  res:HCURSOR;
  w:integer;
begin
  hInstance:=Popint;
  lpCursorName:=PopResourceString(w);
  res:= LoadCursor(hInstance, PresourceString(lpCursorName,w));

  PushInt(integer(res));
end;


Procedure TThreadCom.ProcessLoadIconA;
var
  hInstance: HINST;
  lpIconName: string;
  res:HICON;
  w:integer;
begin
  hInstance:=Popint;
  lpIconName:=PopResourceString(w);
  res:= LoadIcon(hInstance, PresourceString(lpIconName,w));
  PushInt(integer(res));
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
  PushInt(integer(res));

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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessMessageBoxA;
var
  Wnd: HWND;
  lpText, lpCaption: string;
  uType: UINT;
  res: Integer;
begin
  Wnd:=Popint;
  lpText:=PopString;
  lpCaption:=PopString;
  uType:=Popint;

  Res:=MessageBox(Wnd,Pchar(lpText),Pchar(lpCaption), uType);
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
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessOutputDebugStringA;
var
  st:string;
begin
  st:=PopString;
  OutputDebugStringA(Pchar(st));
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
  PushInt(integer(res));
  MemoWriteln('PeekMessage '+Istr(Msg.message)+Istr1(wnd,6)+' res='+Bstr(res));
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
  PushInt(integer(res));
  finally
  freemem(Points);
  {MemoWriteln3('Polygon dc='+Istr(dc)+' count='+Istr(count)+'res='+Bstr(res));}
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
end;


Procedure TThreadCom.ProcessRegisterClassA;
var
  WndClass : TWndClassA;
  menuName,classname:string;
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

  if w<>0 then MemoWriteln2('RegisterClass '+ClassName+' wndproc='+Istr(integer(pWndProc)) );
  PushInt(w);
end;

Procedure TThreadCom.ProcessReleaseCapture;
var
  res:BOOL;
begin
  res:=ReleaseCapture;
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessRemovePropA;
var
  Wnd: HWND;
  st:String;
  w:integer;
  res:Thandle;
begin
  wnd:=PopInt;
  st:=PopResourceString(w);

  if w<0
    then res:= RemoveProp(Wnd, pointer(-w))
    else res:= RemoveProp(Wnd, PChar(st));
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessSetCapture;
var
  wnd:Hwnd;
  res: Hwnd;
begin
  wnd:=PopInt;
  res:= SetCapture(Wnd);
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessSetCursor;
var
  hCur: HCURSOR;
  res: HCURSOR ;
begin
  hCur:=PopInt;
  res:= SetCursor(hCur);
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessSetPropA;
var
  Wnd: HWND;
  st:String;
  w:integer;
  hData: THandle;
  res: BOOL;
begin
  wnd:=PopInt;
  st:=PopResourceString(w);
  hData:=PopInt;
  if w>0
    then res:= SetProp(Wnd,Pointer(w), hData)
    else res:= SetProp(Wnd,Pchar(st), hData);
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
end;



Procedure TThreadCom.ProcessSetUnhandledExceptionFilter;
var
  res:integer ;
begin

  res:=0;
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessSetWindowTextA;
var
  Wnd: HWND;
  st:string;
  res: BOOL;
begin
  wnd:=PopInt;
  st:=PopString;
  res:= SetWindowText(Wnd,PChar(st));
  PushInt(integer(res));
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

  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessStartPage;
var
  DC: HDC;
  res: integer;
begin
  dc:=PopInt;
  res:= StartPage(DC);
  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessTextOutA;
var
  DC: HDC;
  X, Y: Integer;
  st:string;
  Count: Integer;
  res: BOOL;
begin
  DC   :=PopInt;
  X    :=PopInt;
  Y    :=PopInt;
  st   :=PopString;
  Count:=PopInt;
  res:= TextOut(DC,X, Y, Pchar(st), Count);
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessTranslateMessage;
var
  Msg: TMsg;
  res:BOOL;
begin
  PopBytes(@Msg,sizeof(Tmsg));
  res:= TranslateMessage(Msg);
  PushInt(integer(res));
end;


Procedure TThreadCom.ProcessUpdateWindow;
var
  wnd:HWND;
  res:BOOL;
begin
  wnd:=PopInt;
  res:= UpdateWindow(Wnd);

  PushInt(integer(res));
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
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessWinExec;
var
  CmdLine:string;
  uCmdShow: UINT;
  res: UINT;
begin
  CmdLine:=PopString;
  uCmdShow:=PopInt;

  res:= WinExec( Pchar(CmdLine), uCmdShow);
  PushInt(integer(res));
end;

Procedure TThreadCom.ProcessDrawTextA;
var
  DC: HDC;
  lpString: string;
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
  res:= DrawText(DC, Pchar(lpString), nCount, lpRect, uFormat);

  PushInt(res);
end;


procedure TthreadCom.ProcessGetModuleHandleA;
var
  lpString:string;
  res:integer;
begin
  lpString:=PopString;
  {res:=GetModuleHandleA(Pchar(lpString));}
  res:=sysinit.HInstance;
  MemoWriteln('GetModuleHandle '+lpString+'    res='+Istr(res));
  PushInt(res);
end;

procedure TthreadCom.ProcessExpandFileName;
var
  st:string;
  res:integer;
begin
  st:=PopString;
  MemoWriteln('Expand: '+st);
  st:=ExpandFileName(st);
  MemoWriteln('Expand: '+st);
  PushString(st);
  PushInt(0);
  MemoWriteln('Expanded');
end;


var
  stl:TstringList;

procedure TThreadCom.ProcessGetSymList;
var
  i,nb:integer;
begin
  nb:=PopInt;
  if not assigned(stl) then stl:=TstringList.create;

  for i:=0 to nb-1 do stl.Add(PopString);
  FlagCall:=false;
end;


procedure PostTest;
var
  i:integer;
begin
  FlagCall:=true;
  PostThreadMessage(ThreadCom.ThreadID, WM_USER+1, -1, 0);


  repeat until not FlagCall or testEscape;

  if assigned(stl) then
  with stl do
  for i:= 0 to count-1 do
    MemoWriteln3(strings[i] );

end;

initialization

finalization
  StopWinEmul;

end.