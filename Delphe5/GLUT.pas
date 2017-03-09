unit Glut;

// Copyright (c) Mark J. Kilgard, 1994, 1995, 1996. */

(* This program is freely distributable without licensing fees  and is
   provided without guarantee or warrantee expressed or  implied. This
   program is -not- in the public domain. *)

{******************************************************************************}
{ Converted to Delphi by Tom Nuydens (tom@delphi3d.net)                        }
{   Contributions by Igor Karpov (glygrik@hotbox.ru)                           }
{   For the latest updates, visit Delphi3D: http://www.delphi3d.net            }
{******************************************************************************}

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  SysUtils, Windows, GL,Glu,
  util1,debug0;

type
  PInteger = ^Integer;
  PPChar = ^Pansichar;
  TGlutVoidCallback = procedure; stdcall;
  TGlut1IntCallback = procedure(value: Integer); stdcall;
  TGlut2IntCallback = procedure(v1, v2: Integer); stdcall;
  TGlut3IntCallback = procedure(v1, v2, v3: Integer); stdcall;
  TGlut4IntCallback = procedure(v1, v2, v3, v4: Integer); stdcall;
  TGlut1Char2IntCallback = procedure(c: Byte; v1, v2: Integer); stdcall;

const
  GLUT_API_VERSION                = 3;
  GLUT_XLIB_IMPLEMENTATION        = 12;
  // Display mode bit masks.
  GLUT_RGB                        = 0;
  GLUT_RGBA                       = GLUT_RGB;
  GLUT_INDEX                      = 1;
  GLUT_SINGLE                     = 0;
  GLUT_DOUBLE                     = 2;
  GLUT_ACCUM                      = 4;
  GLUT_ALPHA                      = 8;
  GLUT_DEPTH                      = 16;
  GLUT_STENCIL                    = 32;
  GLUT_MULTISAMPLE                = 128;
  GLUT_STEREO                     = 256;
  GLUT_LUMINANCE                  = 512;

  // Mouse buttons.
  GLUT_LEFT_BUTTON                = 0;
  GLUT_MIDDLE_BUTTON              = 1;
  GLUT_RIGHT_BUTTON               = 2;

  // Mouse button state.
  GLUT_DOWN                       = 0;
  GLUT_UP                         = 1;

  // function keys
  GLUT_KEY_F1                     = 1;
  GLUT_KEY_F2                     = 2;
  GLUT_KEY_F3                     = 3;
  GLUT_KEY_F4                     = 4;
  GLUT_KEY_F5                     = 5;
  GLUT_KEY_F6                     = 6;
  GLUT_KEY_F7                     = 7;
  GLUT_KEY_F8                     = 8;
  GLUT_KEY_F9                     = 9;
  GLUT_KEY_F10                    = 10;
  GLUT_KEY_F11                    = 11;
  GLUT_KEY_F12                    = 12;
  // directional keys
  GLUT_KEY_LEFT                   = 100;
  GLUT_KEY_UP                     = 101;
  GLUT_KEY_RIGHT                  = 102;
  GLUT_KEY_DOWN                   = 103;
  GLUT_KEY_PAGE_UP                = 104;
  GLUT_KEY_PAGE_DOWN              = 105;
  GLUT_KEY_HOME                   = 106;
  GLUT_KEY_END                    = 107;
  GLUT_KEY_INSERT                 = 108;

  // Entry/exit  state.
  GLUT_LEFT                       = 0;
  GLUT_ENTERED                    = 1;

  // Menu usage state.
  GLUT_MENU_NOT_IN_USE            = 0;
  GLUT_MENU_IN_USE                = 1;

  // Visibility  state.
  GLUT_NOT_VISIBLE                = 0;
  GLUT_VISIBLE                    = 1;

  // Window status  state.
  GLUT_HIDDEN                     = 0;
  GLUT_FULLY_RETAINED             = 1;
  GLUT_PARTIALLY_RETAINED         = 2;
  GLUT_FULLY_COVERED              = 3;

  // Color index component selection values.
  GLUT_RED                        = 0;
  GLUT_GREEN                      = 1;
  GLUT_BLUE                       = 2;

  // Layers for use.
  GLUT_NORMAL                     = 0;
  GLUT_OVERLAY                    = 1;

  // Stroke font constants (use these in GLUT program).
  GLUT_STROKE_ROMAN		  = Pointer(0);
  GLUT_STROKE_MONO_ROMAN	  = Pointer(1);

  // Bitmap font constants (use these in GLUT program).
  GLUT_BITMAP_9_BY_15		  = Pointer(2);
  GLUT_BITMAP_8_BY_13		  = Pointer(3);
  GLUT_BITMAP_TIMES_ROMAN_10	  = Pointer(4);
  GLUT_BITMAP_TIMES_ROMAN_24	  = Pointer(5);
  GLUT_BITMAP_HELVETICA_10	  = Pointer(6);
  GLUT_BITMAP_HELVETICA_12	  = Pointer(7);
  GLUT_BITMAP_HELVETICA_18	  = Pointer(8);

  // glutGet parameters.
  GLUT_WINDOW_X                   = 100;
  GLUT_WINDOW_Y                   = 101;
  GLUT_WINDOW_WIDTH               = 102;
  GLUT_WINDOW_HEIGHT              = 103;
  GLUT_WINDOW_BUFFER_SIZE         = 104;
  GLUT_WINDOW_STENCIL_SIZE        = 105;
  GLUT_WINDOW_DEPTH_SIZE          = 106;
  GLUT_WINDOW_RED_SIZE            = 107;
  GLUT_WINDOW_GREEN_SIZE          = 108;
  GLUT_WINDOW_BLUE_SIZE           = 109;
  GLUT_WINDOW_ALPHA_SIZE          = 110;
  GLUT_WINDOW_ACCUM_RED_SIZE      = 111;
  GLUT_WINDOW_ACCUM_GREEN_SIZE    = 112;
  GLUT_WINDOW_ACCUM_BLUE_SIZE     = 113;
  GLUT_WINDOW_ACCUM_ALPHA_SIZE    = 114;
  GLUT_WINDOW_DOUBLEBUFFER        = 115;
  GLUT_WINDOW_RGBA                = 116;
  GLUT_WINDOW_PARENT              = 117;
  GLUT_WINDOW_NUM_CHILDREN        = 118;
  GLUT_WINDOW_COLORMAP_SIZE       = 119;
  GLUT_WINDOW_NUM_SAMPLES         = 120;
  GLUT_WINDOW_STEREO              = 121;
  GLUT_WINDOW_CURSOR              = 122;
  GLUT_SCREEN_WIDTH               = 200;
  GLUT_SCREEN_HEIGHT              = 201;
  GLUT_SCREEN_WIDTH_MM            = 202;
  GLUT_SCREEN_HEIGHT_MM           = 203;
  GLUT_MENU_NUM_ITEMS             = 300;
  GLUT_DISPLAY_MODE_POSSIBLE      = 400;
  GLUT_INIT_WINDOW_X              = 500;
  GLUT_INIT_WINDOW_Y              = 501;
  GLUT_INIT_WINDOW_WIDTH          = 502;
  GLUT_INIT_WINDOW_HEIGHT         = 503;
  GLUT_INIT_DISPLAY_MODE          = 504;
  GLUT_ELAPSED_TIME               = 700;

  // glutDeviceGet parameters.
  GLUT_HAS_KEYBOARD               = 600;
  GLUT_HAS_MOUSE                  = 601;
  GLUT_HAS_SPACEBALL              = 602;
  GLUT_HAS_DIAL_AND_BUTTON_BOX    = 603;
  GLUT_HAS_TABLET                 = 604;
  GLUT_NUM_MOUSE_BUTTONS          = 605;
  GLUT_NUM_SPACEBALL_BUTTONS      = 606;
  GLUT_NUM_BUTTON_BOX_BUTTONS     = 607;
  GLUT_NUM_DIALS                  = 608;
  GLUT_NUM_TABLET_BUTTONS         = 609;

  // glutLayerGet parameters.
  GLUT_OVERLAY_POSSIBLE           = 800;
  GLUT_LAYER_IN_USE               = 801;
  GLUT_HAS_OVERLAY                = 802;
  GLUT_TRANSPARENT_INDEX          = 803;
  GLUT_NORMAL_DAMAGED             = 804;
  GLUT_OVERLAY_DAMAGED            = 805;

  // glutVideoResizeGet parameters.
  GLUT_VIDEO_RESIZE_POSSIBLE       = 900;
  GLUT_VIDEO_RESIZE_IN_USE         = 901;
  GLUT_VIDEO_RESIZE_X_DELTA        = 902;
  GLUT_VIDEO_RESIZE_Y_DELTA        = 903;
  GLUT_VIDEO_RESIZE_WIDTH_DELTA    = 904;
  GLUT_VIDEO_RESIZE_HEIGHT_DELTA   = 905;
  GLUT_VIDEO_RESIZE_X              = 906;
  GLUT_VIDEO_RESIZE_Y              = 907;
  GLUT_VIDEO_RESIZE_WIDTH          = 908;
  GLUT_VIDEO_RESIZE_HEIGHT         = 909;

  // glutGetModifiers return mask.
  GLUT_ACTIVE_SHIFT                = 1;
  GLUT_ACTIVE_CTRL                 = 2;
  GLUT_ACTIVE_ALT                  = 4;

  // glutSetCursor parameters.
  // Basic arrows.
  GLUT_CURSOR_RIGHT_ARROW          = 0;
  GLUT_CURSOR_LEFT_ARROW           = 1;
  // Symbolic cursor shapes.
  GLUT_CURSOR_INFO                 = 2;
  GLUT_CURSOR_DESTROY              = 3;
  GLUT_CURSOR_HELP                 = 4;
  GLUT_CURSOR_CYCLE                = 5;
  GLUT_CURSOR_SPRAY                = 6;
  GLUT_CURSOR_WAIT                 = 7;
  GLUT_CURSOR_TEXT                 = 8;
  GLUT_CURSOR_CROSSHAIR            = 9;
  // Directional cursors.
  GLUT_CURSOR_UP_DOWN              = 10;
  GLUT_CURSOR_LEFT_RIGHT           = 11;
  // Sizing cursors.
  GLUT_CURSOR_TOP_SIDE             = 12;
  GLUT_CURSOR_BOTTOM_SIDE          = 13;
  GLUT_CURSOR_LEFT_SIDE            = 14;
  GLUT_CURSOR_RIGHT_SIDE           = 15;
  GLUT_CURSOR_TOP_LEFT_CORNER      = 16;
  GLUT_CURSOR_TOP_RIGHT_CORNER     = 17;
  GLUT_CURSOR_BOTTOM_RIGHT_CORNER  = 18;
  GLUT_CURSOR_BOTTOM_LEFT_CORNER   = 19;
  // Inherit from parent window.
  GLUT_CURSOR_INHERIT              = 100;
  // Blank cursor.
  GLUT_CURSOR_NONE                 = 101;
  // Fullscreen crosshair (if available).
  GLUT_CURSOR_FULL_CROSSHAIR       = 102;

  // GLUT game mode sub-API.
  // glutGameModeGet.
  GLUT_GAME_MODE_ACTIVE           = 0;
  GLUT_GAME_MODE_POSSIBLE         = 1;
  GLUT_GAME_MODE_WIDTH            = 2;
  GLUT_GAME_MODE_HEIGHT           = 3;
  GLUT_GAME_MODE_PIXEL_DEPTH      = 4;
  GLUT_GAME_MODE_REFRESH_RATE     = 5;
  GLUT_GAME_MODE_DISPLAY_CHANGED  = 6;

var
// GLUT initialization sub-API.
  glutInit: procedure(argcp: PInteger; argv: PPChar); stdcall;
  glutInitDisplayMode: procedure(mode: Word); stdcall;
  glutInitDisplayString: procedure(const str: Pansichar); stdcall;
  glutInitWindowPosition: procedure(x, y: Integer); stdcall;
  glutInitWindowSize: procedure(width, height: Integer); stdcall;
  glutMainLoop: procedure; stdcall;

// GLUT window sub-API.
  glutCreateWindow: function(const title: Pansichar): Integer; stdcall;
  glutCreateSubWindow: function(win, x, y, width, height: Integer): Integer; stdcall;
  glutDestroyWindow: procedure(win: Integer); stdcall;
  glutPostRedisplay: procedure; stdcall;
  glutPostWindowRedisplay: procedure(win: Integer); stdcall;
  glutSwapBuffers: procedure; stdcall;
  glutGetWindow: function: Integer; stdcall;
  glutSetWindow: procedure(win: Integer); stdcall;
  glutSetWindowTitle: procedure(const title: Pansichar); stdcall;
  glutSetIconTitle: procedure(const title: Pansichar); stdcall;
  glutPositionWindow: procedure(x, y: Integer); stdcall;
  glutReshapeWindow: procedure(width, height: Integer); stdcall;
  glutPopWindow: procedure; stdcall;
  glutPushWindow: procedure; stdcall;
  glutIconifyWindow: procedure; stdcall;
  glutShowWindow: procedure; stdcall;
  glutHideWindow: procedure; stdcall;
  glutFullScreen: procedure; stdcall;
  glutSetCursor: procedure(cursor: Integer); stdcall;
  glutWarpPointer: procedure(x, y: Integer); stdcall;

// GLUT overlay sub-API.
  glutEstablishOverlay: procedure; stdcall;
  glutRemoveOverlay: procedure; stdcall;
  glutUseLayer: procedure(layer: GLenum); stdcall;
  glutPostOverlayRedisplay: procedure; stdcall;
  glutPostWindowOverlayRedisplay: procedure(win: Integer); stdcall;
  glutShowOverlay: procedure; stdcall;
  glutHideOverlay: procedure; stdcall;

// GLUT menu sub-API.
  glutCreateMenu: function(callback: TGlut1IntCallback): Integer; stdcall;
  glutDestroyMenu: procedure(menu: Integer); stdcall;
  glutGetMenu: function: Integer; stdcall;
  glutSetMenu: procedure(menu: Integer); stdcall;
  glutAddMenuEntry: procedure(const caption: Pansichar; value: Integer); stdcall;
  glutAddSubMenu: procedure(const caption: Pansichar; submenu: Integer); stdcall;
  glutChangeToMenuEntry: procedure(item: Integer; const caption: Pansichar; value: Integer); stdcall;
  glutChangeToSubMenu: procedure(item: Integer; const caption: Pansichar; submenu: Integer); stdcall;
  glutRemoveMenuItem: procedure(item: Integer); stdcall;
  glutAttachMenu: procedure(button: Integer); stdcall;
  glutDetachMenu: procedure(button: Integer); stdcall;

// GLUTsub-API.
  glutDisplayFunc: procedure(f: TGlutVoidCallback); stdcall;
  glutReshapeFunc: procedure(f: TGlut2IntCallback); stdcall;
  glutKeyboardFunc: procedure(f: TGlut1Char2IntCallback); stdcall;
  glutMouseFunc: procedure(f: TGlut4IntCallback); stdcall;
  glutMotionFunc: procedure(f: TGlut2IntCallback); stdcall;
  glutPassiveMotionFunc: procedure(f: TGlut2IntCallback); stdcall;
  glutEntryFunc: procedure(f: TGlut1IntCallback); stdcall;
  glutVisibilityFunc: procedure(f: TGlut1IntCallback); stdcall;
  glutIdleFunc: procedure(f: TGlutVoidCallback); stdcall;
  glutTimerFunc: procedure(millis: Word; f: TGlut1IntCallback; value: Integer); stdcall;
  glutMenuStateFunc: procedure(f: TGlut1IntCallback); stdcall;
  glutSpecialFunc: procedure(f: TGlut3IntCallback); stdcall;
  glutSpaceballMotionFunc: procedure(f: TGlut3IntCallback); stdcall;
  glutSpaceballRotateFunc: procedure(f: TGlut3IntCallback); stdcall;
  glutSpaceballButtonFunc: procedure(f: TGlut2IntCallback); stdcall;
  glutButtonBoxFunc: procedure(f: TGlut2IntCallback); stdcall;
  glutDialsFunc: procedure(f: TGlut2IntCallback); stdcall;
  glutTabletMotionFunc: procedure(f: TGlut2IntCallback); stdcall;
  glutTabletButtonFunc: procedure(f: TGlut4IntCallback); stdcall;
  glutMenuStatusFunc: procedure(f: TGlut3IntCallback); stdcall;
  glutOverlayDisplayFunc: procedure(f:TGlutVoidCallback); stdcall;
  glutWindowStatusFunc: procedure(f: TGlut1IntCallback); stdcall;

// GLUT color index sub-API.
  glutSetColor: procedure(cell: Integer; red, green, blue: GLfloat); stdcall;
  glutGetColor: function(ndx, component: Integer): GLfloat; stdcall;
  glutCopyColormap: procedure(win: Integer); stdcall;

// GLUT state retrieval sub-API.
  glutGet: function(t: GLenum): Integer; stdcall;
  glutDeviceGet: function(t: GLenum): Integer; stdcall;

// GLUT extension support sub-API
  glutExtensionSupported: function(const name: Pansichar): Integer; stdcall;
  glutGetModifiers: function: Integer; stdcall;
  glutLayerGet: function(t: GLenum): Integer; stdcall;

// GLUT font sub-API
  glutBitmapCharacter: procedure(font : pointer; character: Integer); stdcall;
  glutBitmapWidth: function(font : pointer; character: Integer): Integer; stdcall;
  glutStrokeCharacter: procedure(font : pointer; character: Integer); stdcall;
  glutStrokeWidth: function(font : pointer; character: Integer): Integer; stdcall;
  glutBitmapLength: function(font: pointer; const str: Pansichar): Integer; stdcall;
  glutStrokeLength: function(font: pointer; const str: Pansichar): Integer; stdcall;

// GLUT pre-built models sub-API
  glutWireSphere: procedure(radius: GLdouble; slices, stacks: GLint); stdcall;
  glutSolidSphere: procedure(radius: GLdouble; slices, stacks: GLint); stdcall;
  glutWireCone: procedure(base, height: GLdouble; slices, stacks: GLint); stdcall;
  glutSolidCone: procedure(base, height: GLdouble; slices, stacks: GLint); stdcall;
  glutWireCube: procedure(size: GLdouble); stdcall;
  glutSolidCube: procedure(size: GLdouble); stdcall;
  glutWireTorus: procedure(innerRadius, outerRadius: GLdouble; sides, rings: GLint); stdcall;
  glutSolidTorus: procedure(innerRadius, outerRadius: GLdouble; sides, rings: GLint); stdcall;
  glutWireDodecahedron: procedure; stdcall;
  glutSolidDodecahedron: procedure; stdcall;
  glutWireTeapot: procedure(size: GLdouble); stdcall;
  glutSolidTeapot: procedure(size: GLdouble); stdcall;
  glutWireOctahedron: procedure; stdcall;
  glutSolidOctahedron: procedure; stdcall;
  glutWireTetrahedron: procedure; stdcall;
  glutSolidTetrahedron: procedure; stdcall;
  glutWireIcosahedron: procedure; stdcall;
  glutSolidIcosahedron: procedure; stdcall;

// GLUT video resize sub-API.
  glutVideoResizeGet: function(param: GLenum): Integer; stdcall;
  glutSetupVideoResizing: procedure; stdcall;
  glutStopVideoResizing: procedure; stdcall;
  glutVideoResize: procedure(x, y, width, height: Integer); stdcall;
  glutVideoPan: procedure(x, y, width, height: Integer); stdcall;

// GLUT debugging sub-API.
  glutReportErrors: procedure; stdcall;

var
  //example glutGameModeString('1280x1024:32@75');
  glutGameModeString : procedure (const AString : Pansichar); stdcall;
  glutEnterGameMode : function : integer; stdcall;
  glutLeaveGameMode : procedure; stdcall;
  glutGameModeGet : function (mode : GLenum) : integer; stdcall;

function InitGLUT:boolean;
procedure FreeGlut;

function InitOpenGL:boolean;

implementation

uses forms;

var
  hDLL: THandle;

  OpenGLOK:boolean;

function InitOpenGL:boolean;
begin
  if not OpenGLOK then OpenGLOK:=initGL and initGlu and initGlut;
  result:=OpenGLOK;
  if not result then messageCentral('InitOpenGl=false');
end;

procedure FreeGlut;
begin

  FreeLibrary(hDLL);

  @glutInit := nil;
  @glutInitDisplayMode := nil;
  @glutInitDisplayString := nil;
  @glutInitWindowPosition := nil;
  @glutInitWindowSize := nil;
  @glutMainLoop := nil;
  @glutCreateWindow := nil;
  @glutCreateSubWindow := nil;
  @glutDestroyWindow := nil;
  @glutPostRedisplay := nil;
  @glutPostWindowRedisplay := nil;
  @glutSwapBuffers := nil;
  @glutGetWindow := nil;
  @glutSetWindow := nil;
  @glutSetWindowTitle := nil;
  @glutSetIconTitle := nil;
  @glutPositionWindow := nil;
  @glutReshapeWindow := nil;
  @glutPopWindow := nil;
  @glutPushWindow := nil;
  @glutIconifyWindow := nil;
  @glutShowWindow := nil;
  @glutHideWindow := nil;
  @glutFullScreen := nil;
  @glutSetCursor := nil;
  @glutWarpPointer := nil;
  @glutEstablishOverlay := nil;
  @glutRemoveOverlay := nil;
  @glutUseLayer := nil;
  @glutPostOverlayRedisplay := nil;
  @glutPostWindowOverlayRedisplay := nil;
  @glutShowOverlay := nil;
  @glutHideOverlay := nil;
  @glutCreateMenu := nil;
  @glutDestroyMenu := nil;
  @glutGetMenu := nil;
  @glutSetMenu := nil;
  @glutAddMenuEntry := nil;
  @glutAddSubMenu := nil;
  @glutChangeToMenuEntry := nil;
  @glutChangeToSubMenu := nil;
  @glutRemoveMenuItem := nil;
  @glutAttachMenu := nil;
  @glutDetachMenu := nil;
  @glutDisplayFunc := nil;
  @glutReshapeFunc := nil;
  @glutKeyboardFunc := nil;
  @glutMouseFunc := nil;
  @glutMotionFunc := nil;
  @glutPassiveMotionFunc := nil;
  @glutEntryFunc := nil;
  @glutVisibilityFunc := nil;
  @glutIdleFunc := nil;
  @glutTimerFunc := nil;
  @glutMenuStateFunc := nil;
  @glutSpecialFunc := nil;
  @glutSpaceballMotionFunc := nil;
  @glutSpaceballRotateFunc := nil;
  @glutSpaceballButtonFunc := nil;
  @glutButtonBoxFunc := nil;
  @glutDialsFunc := nil;
  @glutTabletMotionFunc := nil;
  @glutTabletButtonFunc := nil;
  @glutMenuStatusFunc := nil;
  @glutOverlayDisplayFunc := nil;
  @glutWindowStatusFunc := nil;
  @glutSetColor := nil;
  @glutGetColor := nil;
  @glutCopyColormap := nil;
  @glutGet := nil;
  @glutDeviceGet := nil;
  @glutExtensionSupported := nil;
  @glutGetModifiers := nil;
  @glutLayerGet := nil;
  @glutBitmapCharacter := nil;
  @glutBitmapWidth := nil;
  @glutStrokeCharacter := nil;
  @glutStrokeWidth := nil;
  @glutBitmapLength := nil;
  @glutStrokeLength := nil;
  @glutWireSphere := nil;
  @glutSolidSphere := nil;
  @glutWireCone := nil;
  @glutSolidCone := nil;
  @glutWireCube := nil;
  @glutSolidCube := nil;
  @glutWireTorus := nil;
  @glutSolidTorus := nil;
  @glutWireDodecahedron := nil;
  @glutSolidDodecahedron := nil;
  @glutWireTeapot := nil;
  @glutSolidTeapot := nil;
  @glutWireOctahedron := nil;
  @glutSolidOctahedron := nil;
  @glutWireTetrahedron := nil;
  @glutSolidTetrahedron := nil;
  @glutWireIcosahedron := nil;
  @glutSolidIcosahedron := nil;
  @glutVideoResizeGet := nil;
  @glutSetupVideoResizing := nil;
  @glutStopVideoResizing := nil;
  @glutVideoResize := nil;
  @glutVideoPan := nil;
  @glutReportErrors := nil;

end;


function InitGLUT:boolean;
var
  argc: integer;
  argv: array[1..2] of Pchar;
  var1,var2: string[50];
begin
  result:=true;
  if hDLL<>0 then exit;

  hDLL:=GloadLibrary('glut32.dll');

  result:=(hDLL<>0);
    if not result then messageCentral('InitGlut=false');
  if not result then exit;


  @glutInit := GetProc(hDLL, 'glutInit');
  @glutInitDisplayMode := GetProc(hDLL, 'glutInitDisplayMode');
  @glutCreateWindow := GetProc(hDLL, 'glutCreateWindow');
  @glutCreateSubWindow := GetProc(hDLL, 'glutCreateSubWindow');
  @glutDestroyWindow := GetProc(hDLL, 'glutDestroyWindow');
  @glutPostRedisplay := GetProc(hDLL, 'glutPostRedisplay');
  @glutPostWindowRedisplay := GetProc(hDLL, 'glutPostWindowRedisplay');
  @glutSwapBuffers := GetProc(hDLL, 'glutSwapBuffers');
  @glutGetWindow := GetProc(hDLL, 'glutGetWindow');
  @glutSetWindow := GetProc(hDLL, 'glutSetWindow');
  @glutSetWindowTitle := GetProc(hDLL, 'glutSetWindowTitle');
  @glutSetIconTitle := GetProc(hDLL, 'glutSetIconTitle');
  @glutPositionWindow := GetProc(hDLL, 'glutPositionWindow');
  @glutReshapeWindow := GetProc(hDLL, 'glutReshapeWindow');
  @glutPopWindow := GetProc(hDLL, 'glutPopWindow');
  @glutPushWindow := GetProc(hDLL, 'glutPushWindow');
  @glutIconifyWindow := GetProc(hDLL, 'glutIconifyWindow');
  @glutShowWindow := GetProc(hDLL, 'glutShowWindow');
  @glutHideWindow := GetProc(hDLL, 'glutHideWindow');
  @glutFullScreen := GetProc(hDLL, 'glutFullScreen');
  @glutSetCursor := GetProc(hDLL, 'glutSetCursor');
  @glutWarpPointer := GetProc(hDLL, 'glutWarpPointer');
  @glutEstablishOverlay := GetProc(hDLL, 'glutEstablishOverlay');
  @glutRemoveOverlay := GetProc(hDLL, 'glutRemoveOverlay');
  @glutUseLayer := GetProc(hDLL, 'glutUseLayer');
  @glutPostOverlayRedisplay := GetProc(hDLL, 'glutPostOverlayRedisplay');
  @glutPostWindowOverlayRedisplay := GetProc(hDLL, 'glutPostWindowOverlayRedisplay');
  @glutShowOverlay := GetProc(hDLL, 'glutShowOverlay');
  @glutHideOverlay := GetProc(hDLL, 'glutHideOverlay');
  @glutCreateMenu := GetProc(hDLL, 'glutCreateMenu');
  @glutDestroyMenu := GetProc(hDLL, 'glutDestroyMenu');
  @glutGetMenu := GetProc(hDLL, 'glutGetMenu');
  @glutSetMenu := GetProc(hDLL, 'glutSetMenu');
  @glutAddMenuEntry := GetProc(hDLL, 'glutAddMenuEntry');
  @glutAddSubMenu := GetProc(hDLL, 'glutAddSubMenu');
  @glutChangeToMenuEntry := GetProc(hDLL, 'glutChangeToMenuEntry');
  @glutChangeToSubMenu := GetProc(hDLL, 'glutChangeToSubMenu');
  @glutRemoveMenuItem := GetProc(hDLL, 'glutRemoveMenuItem');
  @glutAttachMenu := GetProc(hDLL, 'glutAttachMenu');
  @glutDetachMenu := GetProc(hDLL, 'glutDetachMenu');
  @glutDisplayFunc := GetProc(hDLL, 'glutDisplayFunc');
  @glutReshapeFunc := GetProc(hDLL, 'glutReshapeFunc');
  @glutKeyboardFunc := GetProc(hDLL, 'glutKeyboardFunc');
  @glutMouseFunc := GetProc(hDLL, 'glutMouseFunc');
  @glutMotionFunc := GetProc(hDLL, 'glutMotionFunc');
  @glutPassiveMotionFunc := GetProc(hDLL, 'glutPassiveMotionFunc');
  @glutEntryFunc := GetProc(hDLL, 'glutEntryFunc');
  @glutVisibilityFunc := GetProc(hDLL, 'glutVisibilityFunc');
  @glutIdleFunc := GetProc(hDLL, 'glutIdleFunc');
  @glutTimerFunc := GetProc(hDLL, 'glutTimerFunc');
  @glutMenuStateFunc := GetProc(hDLL, 'glutMenuStateFunc');
  @glutSpecialFunc := GetProc(hDLL, 'glutSpecialFunc');
  @glutSpaceballMotionFunc := GetProc(hDLL, 'glutSpaceballMotionFunc');
  @glutSpaceballRotateFunc := GetProc(hDLL, 'glutSpaceballRotateFunc');
  @glutSpaceballButtonFunc := GetProc(hDLL, 'glutSpaceballButtonFunc');
  @glutButtonBoxFunc := GetProc(hDLL, 'glutButtonBoxFunc');
  @glutDialsFunc := GetProc(hDLL, 'glutDialsFunc');
  @glutTabletMotionFunc := GetProc(hDLL, 'glutTabletMotionFunc');
  @glutTabletButtonFunc := GetProc(hDLL, 'glutTabletButtonFunc');
  @glutMenuStatusFunc := GetProc(hDLL, 'glutMenuStatusFunc');
  @glutOverlayDisplayFunc := GetProc(hDLL, 'glutOverlayDisplayFunc');
  @glutWindowStatusFunc := GetProc(hDLL, 'glutWindowStatusFunc');
  @glutSetColor := GetProc(hDLL, 'glutSetColor');
  @glutGetColor := GetProc(hDLL, 'glutGetColor');
  @glutCopyColormap := GetProc(hDLL, 'glutCopyColormap');
  @glutGet := GetProc(hDLL, 'glutGet');
  @glutDeviceGet := GetProc(hDLL, 'glutDeviceGet');
  @glutExtensionSupported := GetProc(hDLL, 'glutExtensionSupported');
  @glutGetModifiers := GetProc(hDLL, 'glutGetModifiers');
  @glutLayerGet := GetProc(hDLL, 'glutLayerGet');
  @glutBitmapCharacter := GetProc(hDLL, 'glutBitmapCharacter');
  @glutBitmapWidth := GetProc(hDLL, 'glutBitmapWidth');
  @glutStrokeCharacter := GetProc(hDLL, 'glutStrokeCharacter');
  @glutStrokeWidth := GetProc(hDLL, 'glutStrokeWidth');
  @glutBitmapLength := GetProc(hDLL, 'glutBitmapLength');
  @glutStrokeLength := GetProc(hDLL, 'glutStrokeLength');
  @glutWireSphere := GetProc(hDLL, 'glutWireSphere');
  @glutSolidSphere := GetProc(hDLL, 'glutSolidSphere');
  @glutWireCone := GetProc(hDLL, 'glutWireCone');
  @glutSolidCone := GetProc(hDLL, 'glutSolidCone');
  @glutWireCube := GetProc(hDLL, 'glutWireCube');
  @glutSolidCube := GetProc(hDLL, 'glutSolidCube');
  @glutWireTorus := GetProc(hDLL, 'glutWireTorus');
  @glutSolidTorus := GetProc(hDLL, 'glutSolidTorus');
  @glutWireDodecahedron := GetProc(hDLL, 'glutWireDodecahedron');
  @glutSolidDodecahedron := GetProc(hDLL, 'glutSolidDodecahedron');
  @glutWireTeapot := GetProc(hDLL, 'glutWireTeapot');
  @glutSolidTeapot := GetProc(hDLL, 'glutSolidTeapot');
  @glutWireOctahedron := GetProc(hDLL, 'glutWireOctahedron');
  @glutSolidOctahedron := GetProc(hDLL, 'glutSolidOctahedron');
  @glutWireTetrahedron := GetProc(hDLL, 'glutWireTetrahedron');
  @glutSolidTetrahedron := GetProc(hDLL, 'glutSolidTetrahedron');
  @glutWireIcosahedron := GetProc(hDLL, 'glutWireIcosahedron');
  @glutSolidIcosahedron := GetProc(hDLL, 'glutSolidIcosahedron');
  @glutVideoResizeGet := GetProc(hDLL, 'glutVideoResizeGet');
  @glutSetupVideoResizing := GetProc(hDLL, 'glutSetupVideoResizing');
  @glutStopVideoResizing := GetProc(hDLL, 'glutStopVideoResizing');
  @glutVideoResize := GetProc(hDLL, 'glutVideoResize');
  @glutVideoPan := GetProc(hDLL, 'glutVideoPan');
  @glutReportErrors := GetProc(hDLL, 'glutReportErrors');
  @glutGameModeString := GetProc(hDLL, 'glutGameModeString');
  @glutEnterGameMode  := GetProc(hDLL, 'glutEnterGameMode');
  @glutLeaveGameMode  := GetProc(hDLL, 'glutLeaveGameMode');
  @glutGameModeGet    := GetProc(hDLL, 'glutGameModeGet');


end;


end.
