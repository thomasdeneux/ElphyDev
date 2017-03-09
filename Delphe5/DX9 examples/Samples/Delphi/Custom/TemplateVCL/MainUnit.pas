(*----------------------------------------------------------------------------*
 *                                                                            *
 *  Template application - Direct3D9 in VCL                                   *
 *                                                                            *
 *  This template provides simple VCL Delphi application that renders D3D     *
 *  objects in VCL TPanel in windowed mode and can also run render D3D (in    *
 *  special window) then running in fullscreen mode.                          *
 *  Template even allows to move/rotate 'The Teapot' with mouse.              *
 *                                                                            *
 *  Template was written to provide compact starting point then creating      *
 *  Direct3D applications with Delphi (using VCL library)                     *
 *                                                                            *
 *  Copyright (c) 2005 by Alexey Barkovoy                                     *
 *  E-Mail: clootie@clootie.ru                                                *
 *                                                                            *
 *  Modified: 29-Aug-2005                                                     *
 *                                                                            *
 *  Latest version can be downloaded from:                                    *
 *     http://www.clootie.ru                                                *
 *----------------------------------------------------------------------------*)

unit MainUnit;

interface

uses
  Windows, Messages, Classes, SysUtils,
  Forms, Controls, StdCtrls, ExtCtrls, ComCtrls, Menus, AppEvnts,
  Direct3D9, D3DX9, DXUT;

type
  TMainForm = class(TForm)
    DisplayPanel: TPanel;
    Splitter1: TSplitter;
    MainMenu1: TMainMenu;
    StatusBar: TStatusBar;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    About1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    ButtonPanel: TPanel;
    Splitter2: TSplitter;
    FullScreenButton: TButton;
    FullScreen: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure OnToggleFullscreen(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure About1Click(Sender: TObject);
    procedure DisplayPanelResize(Sender: TObject);
    procedure FullScreenButtonClick(Sender: TObject);
  private
    { Private declarations }
    m_hwndRenderFullScreen:  HWND;
    function CheckForLostFullscreen: HResult;
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

///////////////////////////////////////////////////////////////////////////

const
  sAppName = 'Clootie - VCL Direct3D Template';

implementation

uses RenderUnit;


{$R *.dfm}


//-----------------------------------------------------------------------------
// Name: FullScreenWndProc()
// Desc: The WndProc funtion used when the app is in fullscreen mode. This is
//       needed simply to trap the ESC key.
//-----------------------------------------------------------------------------
function FullScreenWndProc(hWnd: HWND; msg: UINT; wParam: WPARAM;
  lParam: LPARAM): LRESULT; stdcall;
begin
  if (msg = WM_CLOSE) then
  begin
    // User wants to exit, so go back to windowed mode and exit for real
    MainForm.OnToggleFullScreen(nil);
    PostMessage(Application.Handle, WM_CLOSE, 0, 0);
  end;

  if (msg = WM_SETCURSOR) then SetCursor(0);

  // User wants to leave fullscreen mode
  if (msg = WM_KEYUP) and (wParam = VK_ESCAPE) then
    MainForm.OnToggleFullScreen(nil);

  if Assigned(m_ArcBall) then
    m_ArcBall.HandleMessages(hWnd, Msg, wParam, lParam);

  Result:= DefWindowProc(hWnd, msg, wParam, lParam);
end;

procedure TMainForm.FormShow(Sender: TObject);
{$WRITEABLECONST ON}
const
  wndClass: TWndClass = (
    style: CS_HREDRAW or CS_VREDRAW;
    lpfnWndProc: @FullScreenWndProc; cbClsExtra: 0; cbWndExtra: 0; hInstance: 0;
    hIcon: 0; hCursor: 0; hbrBackground: 0; lpszMenuName: nil;
    lpszClassName: 'Fullscreen Window'
  );
{$WRITEABLECONST OFF}
begin
  // Register a class for a fullscreen window
  wndClass.hbrBackground:= GetStockObject(WHITE_BRUSH);
  Windows.RegisterClass(wndClass);

  // We create the fullscreen window (not visible) at startup, so it can
  // be the focus window.  The focus window can only be set at CreateDevice
  // time, not in a Reset, so ToggleFullscreen wouldn't work unless we have
  // already set up the fullscreen focus window.
  m_hwndRenderFullScreen:= CreateWindow('Fullscreen Window', nil,
                               WS_POPUP, 0, 0, Screen.Width, Screen.Height,
                               Application.Handle, 0, 0, nil);

  //////////////////////////////////////////////////////////////

  CreateCustomDXUTobjects;

  // Set the callback functions
  DXUTSetCallbackDeviceCreated(OnCreateDevice);
  DXUTSetCallbackDeviceReset(OnResetDevice);
  DXUTSetCallbackDeviceLost(OnLostDevice);
  DXUTSetCallbackDeviceDestroyed(OnDestroyDevice);
  DXUTSetCallbackMsgProc(MsgProc);
  DXUTSetCallbackFrameRender(OnFrameRender);
  DXUTSetCallbackFrameMove(OnFrameMove);

  // Initialize DXUT and create the desired Win32 window and Direct3D device for the application
  DXUTInit(True, True, True); // Parse the command line, handle the default hotkeys, and show msgboxes
  DXUTSetCursorSettings(True, True); // Show the cursor and clip it when in full screen
  // DXUTCreateWindow('EmptyProject');
  DXUTSetWindow(m_hwndRenderFullScreen{?}, m_hwndRenderFullScreen, DisplayPanel.Handle, False);
  DXUTCreateDevice(D3DADAPTER_DEFAULT, true, 640, 480, IsDeviceAcceptable, ModifyDeviceSettings);

  // Start the render loop
  // DXUTMainLoop;
end;

//-----------------------------------------------------------------------------
// Name: OnToggleFullScreen()
// Desc: Called when user toggles the fullscreen mode
//-----------------------------------------------------------------------------
procedure TMainForm.OnToggleFullscreen(Sender: TObject);
begin
  DXUTToggleFullScreen;
end;

function TMainForm.CheckForLostFullscreen: HResult;
begin
  Result:= S_OK;

  if DXUTIsWindowed then Exit;

  if FAILED(DXUTGetD3DDevice.TestCooperativeLevel) then
  begin
    DXUTToggleFullScreen; // ForceWindowed;
    SetFocus;
    Application.BringToFront;
  end;
end;

procedure TMainForm.WndProc(var Message: TMessage);
var
  Handled: Boolean;
begin
  Handled := m_ArcBall.HandleMessages(Handle, Message.Msg, Message.WParam, Message.LParam) = iTrue;
  if not Handled then inherited;
end;

procedure TMainForm.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
var
  strStatsPrev: String;
begin
  Done:= True;

  // Do not render if the app is minimized
  if IsIconic(Application.Handle) then Exit;

  // Update and render a frame
  CheckForLostFullscreen;
  strStatsPrev:= DXUTGetFrameStats;
  DXUTRender3DEnvironment;
  if (strStatsPrev <> DXUTGetFrameStats) then
    StatusBar.Panels[0].Text:= DXUTGetFrameStats;

  // Keep requesting more idle time
  Done:= False;
end;

procedure TMainForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  {ExitCode:= DXUTGetExitCode;}

  DXUTFreeState;
  DestroyCustomDXUTobjects;

  DestroyWindow(m_hwndRenderFullScreen);
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
  Application.MessageBox(
    'This demo shows simple template for usage of Direct3D9 with VCL forms.'#10+
    'Demo support resizing of client window at run-time and going to/from fullscreen mode.'#10#10+
    'This and other demos can be found at http://www.clootie.ru/',
    'Clootie - VCL Direct3D9 template for 2005 DirectX SDK', MB_ICONINFORMATION or MB_OK);
end;

procedure TMainForm.DisplayPanelResize(Sender: TObject);
begin
  DXUTPause(True, True);
  DXUTStaticWndProc(DXUTGetHWND, WM_EXITSIZEMOVE, 0, 0);
end;

procedure TMainForm.FullScreenButtonClick(Sender: TObject);
begin
  OnToggleFullscreen(nil);
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

end.

