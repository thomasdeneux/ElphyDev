unit matlab_mat;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,util1,Ncdef2,matlab_matrix,debug0;


type
  Tpmf=pointer;

  tabPchar=array[0..1000] of Pansichar;
  PtabPchar=^tabPchar;

var
(*
 * Open a MAT-file "filename" using mode "mode".  Return
 * a pointer to a MATFile for use with other MAT API functions.
 *
 * Current valid entries for "mode" are
 * "r"  == read only.
 * "w"  == write only (deletes any existing file with name <filename>).
 * "w4" == as "w", but create a MATLAB 4.0 MAT-file.
 * "u"  == update.  Read and write allowed, existing file is not deleted.
 *
 * Return NULL if an error occurs.
 *)

  matOpen: function(filename:Pansichar; mode:Pansichar):Tpmf;cdecl;



(*
 * Close a MAT-file opened with matOpen.
 *
 * Return zero for success, EOF on error.
 *)
  matClose: function(pmf:Tpmf):integer;cdecl;


(*
 * Return the ANSI C FILE pointer obtained when the MAT-file was opened.
 *)

 matGetFp: function(pmf: Tpmf): pointer;cdecl;

(*
 * Write array value with the specified name to the MAT-file, deleting any
 * previously existing variable with that name in the MAT-file.
 *
 * Return zero for success, nonzero for error.
 *)

 matPutVariable: function(pmf:Tpmf; name:Pansichar; pA: MxArrayPtr):integer;cdecl;

(*
 * Write array value with the specified name to the MAT-file pMF, deleting any
 * previously existing variable in the MAT-file with the same name.
 *
 * The variable will be written such that when the MATLAB LOAD command
 * loads the variable, it will automatically place it in the
 * global workspace and establish a link to it in the local
 * workspace (as if the command "global <varname>" had been
 * issued after the variable was loaded.)
 *
 * Return zero for success, nonzero for error.
 *)

 matPutVariableAsGlobal: function(pmf:Tpmf;name:Pansichar;pA: MxArrayPtr):integer;cdecl;


(*
 * Read the array value for the specified variable name from a MAT-file.
 *
 * Return NULL if an error occurs.
 *)

  matGetVariable: function(pmf: Tpmf;name: Pansichar): MxArrayPtr;cdecl;

(*
 * Read the next array value from the current file location of the MAT-file
 * pMF.  This function should only be used in conjunction with
 * matOpen and matClose.  Passing pMF to any other API functions
 * will cause matGetNextVariable() to work incorrectly.
 *
 * Return NULL if an error occurs.
 *)

 matGetNextVariable: function(pmf:Tpmf;var namePtr: Pansichar):MxArrayPtr;cdecl;

(*
 * Read the array header of the next array value in a MAT-file.
 * This function should only be used in conjunction with
 * matOpen and matClose.  Passing pMF to any other API functions
 * will cause matGetNextVariableInfo to work incorrectly.
 *
 * See the description of matGetVariableInfo() for the definition
 * and valid uses of an array header.
 *
 * Return NULL if an error occurs.
 *)

 matGetNextVariableInfo: function(pmf: Tpmf;var namePtr: Pansichar):MxArrayPtr;cdecl;


(*
 * Read the array header for the variable with the specified name from
 * the MAT-file.
 *
 * An array header contains all the same information as an
 * array, except that the pr, pi, ir, and jc data structures are
 * not allocated for non-recursive data types.  That is,
 * Cells, structures, and objects contain pointers to other
 * array headers, but numeric, string, and sparse arrays do not
 * contain valid data in their pr, pi, ir, or jc fields.
 *
 * The purpose of an array header is to gain fast access to
 * information about an array without reading all the array's
 * actual data.  Thus, functions such as mxGetM, mxGetN, and mxGetClassID
 * can be used with array headers, but mxGetPr, mxGetPi, mxGetIr, mxGetJc,
 * mxSetPr, mxSetPi, mxSetIr, and mxSetJc cannot.
 *
 * An array header should NEVER be returned to MATLAB (for example via the
 * MEX API), or any other non-matrix access API function that expects a
 * full mxArray (examples include engPutVariable(), matPutVariable(), and
 * mexPutVariable()).
 *
 * Return NULL if an error occurs.
 *)

  matGetVariableInfo: function(pmf: Tpmf;name: Pansichar):MxArrayPtr;cdecl;

(*
 * Remove a variable with with the specified name from the MAT-file pMF.
 *
 * Return zero on success, non-zero on error.
 *)

  matDeleteVariable: function(pmf: Tpmf; name: Pansichar):integer;cdecl;


(*
 * Get a list of the names of the arrays in a MAT-file.
 * The array of strings returned by this function contains "num"
 * entries.  It is allocated with one call to mxCalloc, and so
 * can (must) be freed with one call to mxFree.
 *
 * If there are no arrays in the MAT-file, return value
 * is NULL and num is set to zero.  If an error occurs,
 * return value is NULL and num is set to a negative number.
 *)

  matGetDir: function( pmf:Tpmf;var num:integer):PtabPchar;cdecl;


function initMatLabMat:boolean;
function testMatlabMat:boolean;

implementation



var
  Ftried, FOK:boolean;
  hMat:intG;

function initMatLabMat:boolean;
begin
  if Ftried then
  begin
    result:=FOK;
    exit;
  end;

  Ftried:=true;
  FOK:=false;
  result:=FOK;

  // on privilégie la version de Matlab installée
  hMat:= LoadMatlabDll('libmat.dll');
  //messageCentral('hmat = '+int64str(hMat));
  // sinon on prend les dlls de la distribution Elphy
  if hMat=0 then hMat:=GloadLibrary( Appdir+'Matlab\bin\'+'libmat.dll');
  if hMat=0 then exit;

  FOK:=true;
  result:=FOK;


  matOpen:=getProc(hMat,'matOpen');
  matClose:=getProc(hMat,'matClose');
  matGetFp:=getProc(hMat,'matGetFp');
  matPutVariable:=getProc(hMat,'matPutVariable');
  matPutVariableAsGlobal:=getProc(hMat,'matPutVariableAsGlobal');
  matGetVariable:=getProc(hMat,'matGetVariable');
  matGetNextVariable:=getProc(hMat,'matGetNextVariable');
  matGetNextVariableInfo:=getProc(hMat,'matGetNextVariableInfo');
  matGetVariableInfo:=getProc(hMat,'matGetVariableInfo');
  matDeleteVariable:=getProc(hMat,'matDeleteVariable');
  matGetDir:=getProc(hMat,'matGetDir');
  //messageCentral('libmat loaded');
end;


Procedure FreeMatLabMat;
begin
  if hMat<>0 then freeLibrary(hMat);
  hMat:=0;
end;

function testMatlabMat:boolean;
begin
  result:=initMatlabMat;
  if not result then sortieErreur('Unable to call matlab dll');
end;


Initialization
AffDebug('Initialization matlab_mat',0);

finalization
freeMatLabMat;



end.

