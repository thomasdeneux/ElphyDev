unit MKL_DFTI;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,util1;



(* return error values: *)
const
  DFTI_NO_ERROR                    =0;
  DFTI_MEMORY_ERROR                =1;
  DFTI_INVALID_CONFIGURATION       =2;
  DFTI_INCONSISTENT_CONFIGURATION  =3;
  DFTI_MULTITHREADED_ERROR         =4;
  DFTI_BAD_DESCRIPTOR              =5;
  DFTI_UNIMPLEMENTED               =6;
  DFTI_MKL_INTERNAL_ERROR          =7;

  DFTI_NUMBER_OF_THREADS_ERROR =    8;
  DFTI_1D_LENGTH_EXCEEDS_INT32 =    9;

  DFTI_MAX_MESSAGE_LENGTH = 80; (* Maximum length of error string *)
  DFTI_MAX_NAME_LENGTH = 10;    (* Maximum length of descriptor name *)
  DFTI_VERSION_LENGTH = 198;    (* Maximum length of MKL version string *)
  DTI_ERROR_CLASS = 60;         (* (deprecated) *)

(* Descriptor configuration parameters [default values in brackets] *)
{  DFTI_CONFIG_PARAM }
Const
    (* Domain for forward transform. No default value *)
    DFTI_FORWARD_DOMAIN = 0;

    (* Dimensionality, or rank. No default value *)
    DFTI_DIMENSION = 1;

    (* Length(s) of transform. No default value *)
    DFTI_LENGTHS = 2;

    (* Floating point precision. No default value *)
    DFTI_PRECISION = 3;

    (* Scale factor for forward transform [1.0] *)
    DFTI_FORWARD_SCALE  = 4;

    (* Scale factor for backward transform [1.0] *)
    DFTI_BACKWARD_SCALE = 5;

    (* Exponent sign for forward transform [DFTI_NEGATIVE]  *)
    (* DFTI_FORWARD_SIGN = 6; ## NOT IMPLEMENTED *)

    (* Number of data sets to be transformed [1] *)
    DFTI_NUMBER_OF_TRANSFORMS = 7;

    (* Storage of finite complex-valued sequences in complex domain
       [DFTI_COMPLEX_COMPLEX] *)
    DFTI_COMPLEX_STORAGE = 8;

    (* Storage of finite real-valued sequences in real domain
       [DFTI_REAL_REAL] *)
    DFTI_REAL_STORAGE = 9;

    (* Storage of finite complex-valued sequences in conjugate-even
       domain [DFTI_COMPLEX_REAL] *)
    DFTI_CONJUGATE_EVEN_STORAGE = 10;

    (* Placement of result [DFTI_INPLACE] *)
    DFTI_PLACEMENT = 11;

    (* Generalized strides for input data layout [tigth, row-major for
       C] *)
    DFTI_INPUT_STRIDES = 12;

    (* Generalized strides for output data layout [tight, row-major
       for C] *)
    DFTI_OUTPUT_STRIDES = 13;

    (* Distance between first input elements for multiple transforms
       [0] *)
    DFTI_INPUT_DISTANCE = 14;

    (* Distance between first output elements for multiple transforms
       [0] *)
    DFTI_OUTPUT_DISTANCE = 15;

    (* Effort spent in initialization [DFTI_MEDIUM] *)
    (* DFTI_INITIALIZATION_EFFORT = 16, ## NOT IMPLEMENTED *)

    (* Use of workspace during computation [DFTI_ALLOW] *)
    DFTI_WORKSPACE = 17;

    (* Ordering of the result [DFTI_ORDERED] *)
    DFTI_ORDERING = 18;

    (* Possible transposition of result [DFTI_NONE] *)
    DFTI_TRANSPOSE = 19;

    (* User-settable descriptor name [""] *)
    DFTI_DESCRIPTOR_NAME = 20; (* DEPRECATED *)

    (* Packing format for DFTI_COMPLEX_REAL storage of finite
       conjugate-even sequences [DFTI_CCS_FORMAT] *)
    DFTI_PACKED_FORMAT = 21;

    (* Commit status of the descriptor - R/O parameter *)
    DFTI_COMMIT_STATUS = 22;

    (* Version string for this DFTI implementation - R/O parameter *)
    DFTI_VERSION = 23;

    (* Ordering of the forward transform - R/O parameter *)
    (* DFTI_FORWARD_ORDERING  = 24, ## NOT IMPLEMENTED *)

    (* Ordering of the backward transform - R/O parameter *)
    (* DFTI_BACKWARD_ORDERING = 25, ## NOT IMPLEMENTED *)

    (* Number of user threads that share the descriptor [1] *)
    DFTI_NUMBER_OF_USER_THREADS = 26;


(* Values of the descriptor configuration parameters *)
(* enum DFTI_CONFIG_VALUE *)

Const
    (* DFTI_COMMIT_STATUS *)
    DFTI_COMMITTED = 30;
    DFTI_UNCOMMITTED = 31;

    (* DFTI_FORWARD_DOMAIN *)
    DFTI_COMPLEX = 32;
    DFTI_REAL = 33;
    (* DFTI_CONJUGATE_EVEN = 34,   ## NOT IMPLEMENTED *)

    (* DFTI_PRECISION *)
    DFTI_SINGLE = 35;
    DFTI_DOUBLE = 36;

    (* DFTI_FORWARD_SIGN *)
    (* DFTI_NEGATIVE = 37;         ## NOT IMPLEMENTED *)
    (* DFTI_POSITIVE = 38;         ## NOT IMPLEMENTED *)

    (* DFTI_COMPLEX_STORAGE and DFTI_CONJUGATE_EVEN_STORAGE *)
    DFTI_COMPLEX_COMPLEX = 39;
    DFTI_COMPLEX_REAL = 40;

    (* DFTI_REAL_STORAGE *)
    DFTI_REAL_COMPLEX = 41;
    DFTI_REAL_REAL = 42;

    (* DFTI_PLACEMENT *)
    DFTI_INPLACE = 43;          (* Result overwrites input *)
    DFTI_NOT_INPLACE = 44;      (* Have another place for result *)

    (* DFTI_INITIALIZATION_EFFORT *)
    (* DFTI_LOW = 45;              ## NOT IMPLEMENTED *)
    (* DFTI_MEDIUM = 46;           ## NOT IMPLEMENTED *)
    (* DFTI_HIGH = 47;             ## NOT IMPLEMENTED *)

    (* DFTI_ORDERING *)
    DFTI_ORDERED = 48;
    DFTI_BACKWARD_SCRAMBLED = 49;
    (* DFTI_FORWARD_SCRAMBLED = 50; ## NOT IMPLEMENTED *)

    (* Allow/avoid certain usages *)
    DFTI_ALLOW = 51;            (* Allow transposition or workspace *)
    DFTI_AVOID = 52;
    DFTI_NONE = 53;

    (* DFTI_PACKED_FORMAT (for storing congugate-even finite sequence
       in real array) *)
    DFTI_CCS_FORMAT = 54;       (* Complex conjugate-symmetric *)
    DFTI_PACK_FORMAT = 55;      (* Pack format for real DFT *)
    DFTI_PERM_FORMAT = 56;      (* Perm format for real DFT *)
    DFTI_CCE_FORMAT = 57;       (* Complex conjugate-even *)



type
  Tdesc = pointer;

var
  DftiCreateDescriptor:
    function( var handle:Tdesc; precision, domain,dimension:integer;p:pointer):integer;cdecl;
   { p est un pointeur sur un tableau d'entiers
   }

  DftiCopyDescriptor: function(handle1: Tdesc; var handle2:Tdesc):integer;cdecl;
  DftiCommitDescriptor: function( handle: Tdesc):integer;cdecl;

  DftiSetValueI: function( handle: Tdesc; optName:integer; ii:integer):integer;cdecl;
  DftiSetValueS: function( handle: Tdesc; optName:integer; ss:single):integer;cdecl;
  DftiSetValueD: function( handle: Tdesc; optName:integer; dd:double):integer;cdecl;
  DftiSetValueP: function( handle: Tdesc; optName:integer; pp:pointer):integer;cdecl;


  DftiGetValue: function( handle: Tdesc; optName:integer; p1:pointer):integer;cdecl;

  DftiComputeForward1:      function(handle: Tdesc; x1:pointer ):integer;cdecl;
  DftiComputeForward2:      function(handle: Tdesc; x1:pointer ):integer;cdecl;
  DftiComputeForward3:      function(handle: Tdesc; x1:pointer ):integer;cdecl;
  DftiComputeForward4:      function(handle: Tdesc; x1:pointer ):integer;cdecl;

  DftiComputeBackward1:     function(handle: Tdesc; x1:pointer ):integer;cdecl;
  DftiComputeBackward2:     function(handle: Tdesc; x1:pointer ):integer;cdecl;
  DftiComputeBackward3:     function(handle: Tdesc; x1:pointer ):integer;cdecl;
  DftiComputeBackward4:     function(handle: Tdesc; x1:pointer ):integer;cdecl;

  DftiFreeDescriptor:       function( handle: Tdesc):integer;cdecl;

  DftiErrorMessage:         function(var status:longint):Pansichar;cdecl;
  DftiErrorClass:           function(var status,errorClass:longint):integer;cdecl;



function InitDFTI( hh:Thandle):boolean;

implementation



var
  hlib:intG;


function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));

//  if result=nil then messageCentral(st+'=nil');

end;

function InitDFTI( hh:Thandle):boolean;
begin
  hLib:=hh;
  if hLib=0 then exit;

  DftiCreateDescriptor:= getProc(hlib,'mkl_DftiCreateDescriptor');                 
  DftiCommitDescriptor:= getProc(hlib,'mkl_DftiCommitDescriptor');
  DftiCopyDescriptor:= getProc(hlib,'mkl_DftiCopyDescriptor');

  DftiSetValueI:= getproc(hlib,'mkl_DftiSetValueI');
  DftiSetValueP:= getproc(hlib,'mkl_DftiSetValueP');
  DftiSetValueD:= getproc(hlib,'mkl_DftiSetValueD');
  DftiSetValueS:= getproc(hlib,'mkl_DftiSetValueS');

  DftiGetValue:= getproc(hlib,'mkl_DftiGetValue');

  DftiComputeForward1:= getproc(hlib,'mkl_DftiComputeForward1');
  DftiComputeForward2:= getproc(hlib,'mkl_DftiComputeForward2');
  DftiComputeForward3:= getproc(hlib,'mkl_DftiComputeForward3');
  DftiComputeForward4:= getproc(hlib,'mkl_DftiComputeForward4');

  DftiComputeBackward1:= getproc(hlib,'mkl_DftiComputeBackward1');
  DftiComputeBackward2:= getproc(hlib,'mkl_DftiComputeBackward2');
  DftiComputeBackward3:= getproc(hlib,'mkl_DftiComputeBackward3');
  DftiComputeBackward4:= getproc(hlib,'mkl_DftiComputeBackward4');

  DftiFreeDescriptor:= getproc(hlib,'mkl_DftiFreeDescriptor');

  DftiErrorMessage:= getproc(hlib,'mkl_DftiErrorMessage');
  DftiErrorClass:= getproc(hlib,'mkl_DftiErrorClass');

end;




end.
