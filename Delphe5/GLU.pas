(*++ BUILD Version: 0004    // Increment this if a change has global effects

Copyright (c) 1985-95, Microsoft Corporation

Module Name:

    glu.h

Abstract:

    Procedure declarations, constant definitions and macros for the OpenGL
    Utility Library.

--*)

(*
** Copyright 1991-1993, Silicon Graphics, Inc.
** All Rights Reserved.
**
** This is UNPUBLISHED PROPRIETARY SOURCE CODE of Silicon Graphics, Inc.;
** the contents of this file may not be disclosed to third parties, copied or
** duplicated in any form, in whole or in part, without the prior written
** permission of Silicon Graphics, Inc.
**
** RESTRICTED RIGHTS LEGEND:
** Use, duplication or disclosure by the Government is subject to restrictions
** as set forth in subdivision (c)(1)(ii) of the Rights in Technical Data
** and Computer Software clause at DFARS 252.227-7013, and/or in similar or
** successor clauses in the FAR, DOD or NASA FAR Supplement. Unpublished -
** rights reserved under the Copyright Laws of the United States.
*)

(*
** Return the error string associated with a particular error code.
** This will return 0 for an invalid error code.
**
** The generic function prototype that can be compiled for ANSI or Unicode
** is defined as follows:
**
** LPCTSTR APIENTRY gluErrorStringWIN (GLenum errCode);
*)

{******************************************************************************}
{ Converted to Delphi by Tom Nuydens (tom@delphi3d.net)                        }
{ For the latest updates, visit Delphi3D: http://www.delphi3d.net              }
{******************************************************************************}

unit GLu;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  SysUtils, Windows, GL,
  util1, debug0;

type
  TViewPortArray = array [0..3] of GLint;
  T16dArray = array [0..15] of GLdouble;
  TCallBack = procedure;
  T3dArray = array [0..2] of GLdouble;
  T4pArray = array [0..3] of Pointer;
  T4fArray = array [0..3] of GLfloat;
  PPointer = ^Pointer;

var
  gluErrorString: function(errCode: GLenum): PGLubyte; stdcall;
  gluErrorUnicodeStringEXT: function(errCode: GLenum): PWideChar; stdcall;
  gluGetString: function(name: GLenum): PGLubyte; stdcall;
  gluOrtho2D: procedure(left,right, bottom, top: GLdouble); stdcall;
  gluPerspective: procedure(fovy, aspect, zNear, zFar: GLdouble); stdcall;
  gluPickMatrix: procedure(x, y, width, height: GLdouble; viewport: TViewPortArray); stdcall;
  gluLookAt: procedure(eyex, eyey, eyez, centerx, centery, centerz, upx, upy, upz: GLdouble); stdcall;
  gluProject: function(objx, objy, objz: GLdouble; const modelMatrix, projMatrix: T16dArray; viewport: TViewPortArray; winx, winy, winz: PGLdouble): Integer; stdcall;
  gluUnProject: function(winx, winy, winz: GLdouble; const modelMatrix, projMatrix: T16dArray; viewport: TViewPortArray; objx, objy, objz: PGLdouble): Integer; stdcall;
  gluScaleImage: function(format: GLenum; widthin, heightin: GLint; typein: GLenum; const datain: Pointer; widthout, heightout: GLint; typeout: GLenum; dataout: Pointer): Integer; stdcall;
  gluBuild1DMipmaps: function(target: GLenum; components, width: GLint; format, atype: GLenum; const data: Pointer): Integer; stdcall;
  gluBuild2DMipmaps: function(target: GLenum; components, width, height: GLint; format, atype: GLenum; const data: Pointer): Integer; stdcall;

type
  GLUnurbs = record end;                PGLUnurbs = ^GLUnurbs;
  GLUquadric = record end;              PGLUquadric = ^GLUquadric;
  GLUtesselator = record end;           PGLUtesselator = ^GLUtesselator;

  // backwards compatibility:
  GLUnurbsObj = GLUnurbs;               PGLUnurbsObj = PGLUnurbs;
  GLUquadricObj = GLUquadric;           PGLUquadricObj = PGLUquadric;
  GLUtesselatorObj = GLUtesselator;     PGLUtesselatorObj = PGLUtesselator;
  GLUtriangulatorObj = GLUtesselator;   PGLUtriangulatorObj = PGLUtesselator;

var
  gluNewQuadric: function: PGLUquadric; stdcall;
  gluDeleteQuadric: procedure(state: PGLUquadric); stdcall;
  gluQuadricNormals: procedure(quadObject: PGLUquadric; normals: GLenum); stdcall;
  gluQuadricTexture: procedure(quadObject: PGLUquadric; textureCoords: GLboolean); stdcall;
  gluQuadricOrientation: procedure(quadObject: PGLUquadric; orientation: GLenum); stdcall;
  gluQuadricDrawStyle: procedure(quadObject: PGLUquadric; drawStyle: GLenum); stdcall;
  gluCylinder: procedure(qobj: PGLUquadric; baseRadius, topRadius, height: GLdouble; slices, stacks: GLint); stdcall;
  gluDisk: procedure(qobj: PGLUquadric; innerRadius, outerRadius: GLdouble; slices, loops: GLint); stdcall;
  gluPartialDisk: procedure(qobj: PGLUquadric; innerRadius, outerRadius: GLdouble; slices, loops: GLint; startAngle, sweepAngle: GLdouble); stdcall;
  gluSphere: procedure(qobj: PGLuquadric; radius: GLdouble; slices, stacks: GLint); stdcall;
  gluQuadricCallback: procedure(qobj: PGLUquadric; which: GLenum; fn: TCallBack); stdcall;
  gluNewTess: function: PGLUtesselator; stdcall;
  gluDeleteTess: procedure(tess: PGLUtesselator); stdcall;
  gluTessBeginPolygon: procedure(tess: PGLUtesselator; polygon_data: Pointer); stdcall;
  gluTessBeginContour: procedure(tess: PGLUtesselator); stdcall;
  gluTessVertex: procedure(tess: PGLUtesselator; coords: T3dArray; data: Pointer); stdcall;
  gluTessEndContour: procedure(tess: PGLUtesselator); stdcall;
  gluTessEndPolygon: procedure(tess: PGLUtesselator); stdcall;
  gluTessProperty: procedure(tess: PGLUtesselator; which: GLenum; value: GLdouble); stdcall;
  gluTessNormal: procedure(tess: PGLUtesselator; x, y, z: GLdouble); stdcall;
  gluTessCallback: procedure(tess: PGLUtesselator; which: GLenum;fn: TCallBack); stdcall;
  gluGetTessProperty: procedure(tess: PGLUtesselator; which: GLenum; value: PGLdouble); stdcall;
  gluNewNurbsRenderer: function: PGLUnurbs; stdcall;
  gluDeleteNurbsRenderer: procedure(nobj: PGLUnurbs); stdcall;
  gluBeginSurface: procedure(nobj: PGLUnurbs); stdcall;
  gluBeginCurve: procedure(nobj: PGLUnurbs); stdcall;
  gluEndCurve: procedure(nobj: PGLUnurbs); stdcall;
  gluEndSurface: procedure(nobj: PGLUnurbs); stdcall;
  gluBeginTrim: procedure(nobj: PGLUnurbs); stdcall;
  gluEndTrim: procedure(nobj: PGLUnurbs); stdcall;
  gluPwlCurve: procedure(nobj: PGLUnurbs; count: GLint; aarray: PGLfloat; stride: GLint; atype: GLenum); stdcall;
  gluNurbsCurve: procedure(nobj: PGLUnurbs; nknots: GLint; knot: PGLfloat; stride: GLint; ctlarray: PGLfloat; order: GLint; atype: GLenum); stdcall;
  gluNurbsSurface: procedure(nobj: PGLUnurbs; sknot_count: GLint; sknot: PGLfloat; tknot_count: GLint; tknot: PGLfloat; s_stride, t_stride: GLint; ctlarray: PGLfloat; sorder, torder: GLint; atype: GLenum); stdcall;
  gluLoadSamplingMatrices: procedure(nobj: PGLUnurbs; const modelMatrix, projMatrix: T16dArray; viewport: TViewPortArray); stdcall;
  gluNurbsProperty: procedure(nobj: PGLUnurbs; aproperty: GLenum; value: GLfloat); stdcall;
  gluGetNurbsProperty: procedure(nobj: PGLUnurbs; aproperty: GLenum; value: PGLfloat); stdcall;
  gluNurbsCallback: procedure(nobj: PGLUnurbs; which: GLenum; fn: TCallBack); stdcall;

(**** Callback function prototypes ****)

type
  // gluQuadricCallback
  GLUquadricErrorProc = procedure(p: GLenum); stdcall;

  // gluTessCallback
  GLUtessBeginProc = procedure(p: GLenum); stdcall;
  GLUtessEdgeFlagProc = procedure(p: GLboolean); stdcall;
  GLUtessVertexProc = procedure(p: Pointer); stdcall;
  GLUtessEndProc = procedure; stdcall;
  GLUtessErrorProc = procedure(p: GLenum); stdcall;
  GLUtessCombineProc = procedure(p1: T3dArray; p2: T4pArray; p3: T4fArray; p4: PPointer); stdcall;
  GLUtessBeginDataProc = procedure(p1: GLenum; p2: Pointer); stdcall;
  GLUtessEdgeFlagDataProc = procedure(p1: GLboolean; p2: Pointer); stdcall;
  GLUtessVertexDataProc = procedure(p1, p2: Pointer); stdcall;
  GLUtessEndDataProc = procedure(p: Pointer); stdcall;
  GLUtessErrorDataProc = procedure(p1: GLenum; p2: Pointer); stdcall;
  GLUtessCombineDataProc = procedure(p1: T3dArray; p2: T4pArray; p3: T4fArray;
                                     p4: PPointer; p5: Pointer); stdcall;

  // gluNurbsCallback
  GLUnurbsErrorProc = procedure(p: GLenum); stdcall;


//***           Generic constants               ****/

const
  // Version
  GLU_VERSION_1_1                 = 1;
  GLU_VERSION_1_2                 = 1;

  // Errors: (return value 0 = no error)
  GLU_INVALID_ENUM                = 100900;
  GLU_INVALID_VALUE               = 100901;
  GLU_OUT_OF_MEMORY               = 100902;
  GLU_INCOMPATIBLE_GL_VERSION     = 100903;

  // StringName
  GLU_VERSION                     = 100800;
  GLU_EXTENSIONS                  = 100801;

  // Boolean
  GLU_TRUE                        = GL_TRUE;
  GLU_FALSE                       = GL_FALSE;


  //***           Quadric constants               ****/

  // QuadricNormal
  GLU_SMOOTH              = 100000;
  GLU_FLAT                = 100001;
  GLU_NONE                = 100002;

  // QuadricDrawStyle
  GLU_POINT               = 100010;
  GLU_LINE                = 100011;
  GLU_FILL                = 100012;
  GLU_SILHOUETTE          = 100013;

  // QuadricOrientation
  GLU_OUTSIDE             = 100020;
  GLU_INSIDE              = 100021;

  // Callback types:
  //      GLU_ERROR       = 100103;


  //***           Tesselation constants           ****/

  GLU_TESS_MAX_COORD              = 1.0e150;

  // TessProperty
  GLU_TESS_WINDING_RULE           = 100140;
  GLU_TESS_BOUNDARY_ONLY          = 100141;
  GLU_TESS_TOLERANCE              = 100142;

  // TessWinding
  GLU_TESS_WINDING_ODD            = 100130;
  GLU_TESS_WINDING_NONZERO        = 100131;
  GLU_TESS_WINDING_POSITIVE       = 100132;
  GLU_TESS_WINDING_NEGATIVE       = 100133;
  GLU_TESS_WINDING_ABS_GEQ_TWO    = 100134;

  // TessCallback
  GLU_TESS_BEGIN          = 100100;    // void (CALLBACK*)(GLenum    type)
  GLU_TESS_VERTEX         = 100101;    // void (CALLBACK*)(void      *data)
  GLU_TESS_END            = 100102;    // void (CALLBACK*)(void)
  GLU_TESS_ERROR          = 100103;    // void (CALLBACK*)(GLenum    errno)
  GLU_TESS_EDGE_FLAG      = 100104;    // void (CALLBACK*)(GLboolean boundaryEdge)
  GLU_TESS_COMBINE        = 100105;    { void (CALLBACK*)(GLdouble  coords[3],
                                                            void      *data[4],
                                                            GLfloat   weight[4],
                                                            void      **dataOut) }
  GLU_TESS_BEGIN_DATA     = 100106;    { void (CALLBACK*)(GLenum    type,
                                                            void      *polygon_data) }
  GLU_TESS_VERTEX_DATA    = 100107;    { void (CALLBACK*)(void      *data,
                                                            void      *polygon_data) }
  GLU_TESS_END_DATA       = 100108;    // void (CALLBACK*)(void      *polygon_data)
  GLU_TESS_ERROR_DATA     = 100109;    { void (CALLBACK*)(GLenum    errno,
                                                            void      *polygon_data) }
  GLU_TESS_EDGE_FLAG_DATA = 100110;    { void (CALLBACK*)(GLboolean boundaryEdge,
                                                            void      *polygon_data) }
  GLU_TESS_COMBINE_DATA   = 100111;    { void (CALLBACK*)(GLdouble  coords[3],
                                                            void      *data[4],
                                                            GLfloat   weight[4],
                                                            void      **dataOut,
                                                            void      *polygon_data) }

  // TessError
  GLU_TESS_ERROR1     = 100151;
  GLU_TESS_ERROR2     = 100152;
  GLU_TESS_ERROR3     = 100153;
  GLU_TESS_ERROR4     = 100154;
  GLU_TESS_ERROR5     = 100155;
  GLU_TESS_ERROR6     = 100156;
  GLU_TESS_ERROR7     = 100157;
  GLU_TESS_ERROR8     = 100158;

  GLU_TESS_MISSING_BEGIN_POLYGON  = GLU_TESS_ERROR1;
  GLU_TESS_MISSING_BEGIN_CONTOUR  = GLU_TESS_ERROR2;
  GLU_TESS_MISSING_END_POLYGON    = GLU_TESS_ERROR3;
  GLU_TESS_MISSING_END_CONTOUR    = GLU_TESS_ERROR4;
  GLU_TESS_COORD_TOO_LARGE        = GLU_TESS_ERROR5;
  GLU_TESS_NEED_COMBINE_CALLBACK  = GLU_TESS_ERROR6;

  //***           NURBS constants                 ****/

  // NurbsProperty
  GLU_AUTO_LOAD_MATRIX            = 100200;
  GLU_CULLING                     = 100201;
  GLU_SAMPLING_TOLERANCE          = 100203;
  GLU_DISPLAY_MODE                = 100204;
  GLU_PARAMETRIC_TOLERANCE        = 100202;
  GLU_SAMPLING_METHOD             = 100205;
  GLU_U_STEP                      = 100206;
  GLU_V_STEP                      = 100207;

  // NurbsSampling
  GLU_PATH_LENGTH                 = 100215;
  GLU_PARAMETRIC_ERROR            = 100216;
  GLU_DOMAIN_DISTANCE             = 100217;


  // NurbsTrim
  GLU_MAP1_TRIM_2                 = 100210;
  GLU_MAP1_TRIM_3                 = 100211;

  // NurbsDisplay
  //      GLU_FILL                = 100012;
  GLU_OUTLINE_POLYGON             = 100240;
  GLU_OUTLINE_PATCH               = 100241;

  // NurbsCallback
  //      GLU_ERROR               = 100103;

  // NurbsErrors
  GLU_NURBS_ERROR1        = 100251;
  GLU_NURBS_ERROR2        = 100252;
  GLU_NURBS_ERROR3        = 100253;
  GLU_NURBS_ERROR4        = 100254;
  GLU_NURBS_ERROR5        = 100255;
  GLU_NURBS_ERROR6        = 100256;
  GLU_NURBS_ERROR7        = 100257;
  GLU_NURBS_ERROR8        = 100258;
  GLU_NURBS_ERROR9        = 100259;
  GLU_NURBS_ERROR10       = 100260;
  GLU_NURBS_ERROR11       = 100261;
  GLU_NURBS_ERROR12       = 100262;
  GLU_NURBS_ERROR13       = 100263;
  GLU_NURBS_ERROR14       = 100264;
  GLU_NURBS_ERROR15       = 100265;
  GLU_NURBS_ERROR16       = 100266;
  GLU_NURBS_ERROR17       = 100267;
  GLU_NURBS_ERROR18       = 100268;
  GLU_NURBS_ERROR19       = 100269;
  GLU_NURBS_ERROR20       = 100270;
  GLU_NURBS_ERROR21       = 100271;
  GLU_NURBS_ERROR22       = 100272;
  GLU_NURBS_ERROR23       = 100273;
  GLU_NURBS_ERROR24       = 100274;
  GLU_NURBS_ERROR25       = 100275;
  GLU_NURBS_ERROR26       = 100276;
  GLU_NURBS_ERROR27       = 100277;
  GLU_NURBS_ERROR28       = 100278;
  GLU_NURBS_ERROR29       = 100279;
  GLU_NURBS_ERROR30       = 100280;
  GLU_NURBS_ERROR31       = 100281;
  GLU_NURBS_ERROR32       = 100282;
  GLU_NURBS_ERROR33       = 100283;
  GLU_NURBS_ERROR34       = 100284;
  GLU_NURBS_ERROR35       = 100285;
  GLU_NURBS_ERROR36       = 100286;
  GLU_NURBS_ERROR37       = 100287;

//***           Backwards compatibility for old tesselator           ****/

var
  gluBeginPolygon: procedure(tess: PGLUtesselator); stdcall;
  gluNextContour: procedure(tess: PGLUtesselator; atype: GLenum); stdcall;
  gluEndPolygon: procedure(tess: PGLUtesselator); stdcall;

const
  // Contours types -- obsolete!
  GLU_CW          = 100120;
  GLU_CCW         = 100121;
  GLU_INTERIOR    = 100122;
  GLU_EXTERIOR    = 100123;
  GLU_UNKNOWN     = 100124;

  // Names without "TESS_" prefix
  GLU_BEGIN       = GLU_TESS_BEGIN;
  GLU_VERTEX      = GLU_TESS_VERTEX;
  GLU_END         = GLU_TESS_END;
  GLU_ERROR       = GLU_TESS_ERROR;
  GLU_EDGE_FLAG   = GLU_TESS_EDGE_FLAG;

function InitGLU:boolean;
procedure FreeGLu;

implementation

var
  hDLL: THandle;
  
procedure FreeGLu;
begin

  @gluErrorString := nil;
  @gluErrorUnicodeStringEXT := nil;
  @gluGetString := nil;
  @gluOrtho2D := nil;
  @gluPerspective := nil;
  @gluPickMatrix := nil;
  @gluLookAt := nil;
  @gluProject := nil;
  @gluUnProject := nil;
  @gluScaleImage := nil;
  @gluBuild1DMipmaps := nil;
  @gluBuild2DMipmaps := nil;
  @gluNewQuadric := nil;
  @gluDeleteQuadric := nil;
  @gluQuadricNormals := nil;
  @gluQuadricTexture := nil;
  @gluQuadricOrientation := nil;
  @gluQuadricDrawStyle := nil;
  @gluCylinder := nil;
  @gluDisk := nil;
  @gluPartialDisk := nil;
  @gluSphere := nil;
  @gluQuadricCallback := nil;
  @gluNewTess := nil;
  @gluDeleteTess := nil;
  @gluTessBeginPolygon := nil;
  @gluTessBeginContour := nil;
  @gluTessVertex := nil;
  @gluTessEndContour := nil;
  @gluTessEndPolygon := nil;
  @gluTessProperty := nil;
  @gluTessNormal := nil;
  @gluTessCallback := nil;
  @gluGetTessProperty := nil;
  @gluNewNurbsRenderer := nil;
  @gluDeleteNurbsRenderer := nil;
  @gluBeginSurface := nil;
  @gluBeginCurve := nil;
  @gluEndCurve := nil;
  @gluEndSurface := nil;
  @gluBeginTrim := nil;
  @gluEndTrim := nil;
  @gluPwlCurve := nil;
  @gluNurbsCurve := nil;
  @gluNurbsSurface := nil;
  @gluLoadSamplingMatrices := nil;
  @gluNurbsProperty := nil;
  @gluGetNurbsProperty := nil;
  @gluNurbsCallback := nil;
  @gluBeginPolygon := nil;
  @gluNextContour := nil;
  @gluEndPolygon := nil;

  FreeLibrary(hDLL);

end;



function InitGLU:boolean;
begin
  result:=true;
  if hDLL<>0 then exit;

  hDLL:=GloadLibrary('glu32.dll');

  result:=(hDLL<>0);
    if not result then messageCentral('InitGLU=false');
  if not result then exit;

  @gluErrorString := GetProc(hDLL, 'gluErrorString');
  @gluErrorUnicodeStringEXT := GetProc(hDLL, 'gluErrorUnicodeStringEXT');
  @gluGetString := GetProc(hDLL, 'gluGetString');
  @gluOrtho2D := GetProc(hDLL, 'gluOrtho2D');
  @gluPerspective := GetProc(hDLL, 'gluPerspective');
  @gluPickMatrix := GetProc(hDLL, 'gluPickMatrix');
  @gluLookAt := GetProc(hDLL, 'gluLookAt');
  @gluProject := GetProc(hDLL, 'gluProject');
  @gluUnProject := GetProc(hDLL, 'gluUnProject');
  @gluScaleImage := GetProc(hDLL, 'gluScaleImage');
  @gluBuild1DMipmaps := GetProc(hDLL, 'gluBuild1DMipmaps');
  @gluBuild2DMipmaps := GetProc(hDLL, 'gluBuild2DMipmaps');
  @gluNewQuadric := GetProc(hDLL, 'gluNewQuadric');
  @gluDeleteQuadric := GetProc(hDLL, 'gluDeleteQuadric');
  @gluQuadricNormals := GetProc(hDLL, 'gluQuadricNormals');
  @gluQuadricTexture := GetProc(hDLL, 'gluQuadricTexture');
  @gluQuadricOrientation := GetProc(hDLL, 'gluQuadricOrientation');
  @gluQuadricDrawStyle := GetProc(hDLL, 'gluQuadricDrawStyle');
  @gluCylinder := GetProc(hDLL, 'gluCylinder');
  @gluDisk := GetProc(hDLL, 'gluDisk');
  @gluPartialDisk := GetProc(hDLL, 'gluPartialDisk');
  @gluSphere := GetProc(hDLL, 'gluSphere');
  @gluQuadricCallback := GetProc(hDLL, 'gluQuadricCallback');
  @gluNewTess := GetProc(hDLL, 'gluNewTess');
  @gluDeleteTess := GetProc(hDLL, 'gluDeleteTess');
  @gluTessBeginPolygon := GetProc(hDLL, 'gluTessBeginPolygon');
  @gluTessBeginContour := GetProc(hDLL, 'gluTessBeginContour');
  @gluTessVertex := GetProc(hDLL, 'gluTessVertex');
  @gluTessEndContour := GetProc(hDLL, 'gluTessEndContour');
  @gluTessEndPolygon := GetProc(hDLL, 'gluTessEndPolygon');
  @gluTessProperty := GetProc(hDLL, 'gluTessProperty');
  @gluTessNormal := GetProc(hDLL, 'gluTessNormal');
  @gluTessCallback := GetProc(hDLL, 'gluTessCallback');
  @gluGetTessProperty := GetProc(hDLL, 'gluGetTessProperty');
  @gluNewNurbsRenderer := GetProc(hDLL, 'gluNewNurbsRenderer');
  @gluDeleteNurbsRenderer := GetProc(hDLL, 'gluDeleteNurbsRenderer');
  @gluBeginSurface := GetProc(hDLL, 'gluBeginSurface');
  @gluBeginCurve := GetProc(hDLL, 'gluBeginCurve');
  @gluEndCurve := GetProc(hDLL, 'gluEndCurve');
  @gluEndSurface := GetProc(hDLL, 'gluEndSurface');
  @gluBeginTrim := GetProc(hDLL, 'gluBeginTrim');
  @gluEndTrim := GetProc(hDLL, 'gluEndTrim');
  @gluPwlCurve := GetProc(hDLL, 'gluPwlCurve');
  @gluNurbsCurve := GetProc(hDLL, 'gluNurbsCurve');
  @gluNurbsSurface := GetProc(hDLL, 'gluNurbsSurface');
  @gluLoadSamplingMatrices := GetProc(hDLL, 'gluLoadSamplingMatrices');
  @gluNurbsProperty := GetProc(hDLL, 'gluNurbsProperty');
  @gluGetNurbsProperty := GetProc(hDLL, 'gluGetNurbsProperty');
  @gluNurbsCallback := GetProc(hDLL, 'gluNurbsCallback');

  @gluBeginPolygon := GetProc(hDLL, 'gluBeginPolygon');
  @gluNextContour := GetProc(hDLL, 'gluNextContour');
  @gluEndPolygon := GetProc(hDLL, 'gluEndPolygon');
  
end;


end.
