unit matlab_matrix;

Interface

uses Windows,util1,Ncdef2,debug0;

type
  size_t=integer;
  MxArrayPtr=pointer;
  PmxChar=pointer;
  mxLogical=bool;
  PmxLogical=^mxLogical;
var
  { allocate memory, notifying registered listener }
  mxMalloc: function(n: size_t):pointer;cdecl;          { number of bytes }

  { allocate cleared memory, notifying registered listener.}
  mxCalloc: function(n,size :size_t):pointer;cdecl;  { number of objects , size of objects }


  { free memory, notifying registered listener. }
  mxFree: procedure(p:pointer);cdecl;                 {pointer to memory to be freed }


  { reallocate memory, notifying registered listener.}
  mxRealloc: function(p:pointer; size: size_t):pointer;cdecl;

{$Z4}
type
  mxClassID=(
	mxUNKNOWN_CLASS,
	mxCELL_CLASS,
	mxSTRUCT_CLASS,
	mxLOGICAL_CLASS,
	mxCHAR_CLASS,
	mxSPARSE_CLASS,		{ OBSOLETE! DO NOT USE }
	mxDOUBLE_CLASS,
	mxSINGLE_CLASS,
	mxINT8_CLASS,
	mxUINT8_CLASS,
	mxINT16_CLASS,
	mxUINT16_CLASS,
	mxINT32_CLASS,
	mxUINT32_CLASS,
	mxINT64_CLASS,		{ place holder - future enhancements }
	mxUINT64_CLASS,		{ place holder - future enhancements }
	mxFUNCTION_CLASS,
        mxOPAQUE_CLASS,
	mxOBJECT_CLASS);

  mxComplexity=( mxREAL, mxCOMPLEX);

{$Z1}

var
  { Return the class (catergory) of data that the array holds. }
  mxGetClassID : function(pa: MxArrayPtr): mxClassID;cdecl;

  { Get pointer to data }
  mxGetData: function(pa: MxArrayPtr):pointer;cdecl;



 { Set pointer to data }
   mxSetData: procedure(pa: MxArrayPtr ;newdata:pointer);cdecl;
                      { pointer to array; pointer to data }


 { Determine whether the specified array contains numeric (as opposed
  to cell or struct) data. }

  mxIsNumeric : function(pa: MxArrayPtr):bool;cdecl;

 { Determine whether the given array is a cell array.}
  mxIsCell: function(pa:MxArrayPtr ):bool;cdecl;


 { Determine whether the given array's logical flag is on. }
  mxIsLogical: function(pa: MxArrayPtr):bool ;cdecl;


 { Determine whether the given array contains character data.}
  mxIsChar: function(pa: MxArrayPtr):bool ;cdecl;


 { Determine whether the given array is a structure array.}
  mxIsStruct: function(pa: MxArrayPtr):bool ;cdecl;


 { Determine whether the given array is an opaque array.}
  mxIsOpaque: function(pa: MxArrayPtr):bool ;cdecl;

 { Returns true if specified array is a function object. }
  mxIsFunctionHandle: function(pa: MxArrayPtr):bool ;cdecl;

 { Is array user defined object}
  mxIsObject: function(pa: MxArrayPtr):bool ;cdecl;

 { Get imaginary data pointer for numeric array }
  mxGetImagData: function(pa: MxArrayPtr): pointer;cdecl;

 { Set imaginary data pointer for numeric array }
 mxSetImagData: procedure(pa: MxArrayPtr ; newdata:pointer);cdecl;

 { Determine whether the given array contains complex data. }
  mxIsComplex: function(pa: MxArrayPtr):bool ;cdecl;

 { Determine whether the given array is a sparse (as opposed to full). }
  mxIsSparse: function(pa: MxArrayPtr):bool ;cdecl;

 { Determine whether the specified array represents its data as
   double-precision floating-point numbers. }
  mxIsDouble: function(pa: MxArrayPtr):bool ;cdecl;


 { Determine whether the specified array represents its data as
  single-precision floating-point numbers. }
  mxIsSingle: function(pa: MxArrayPtr):bool ;cdecl;

 { Determine whether the specified array represents its data as
  signed 8-bit integers. }
  mxIsInt8: function(pa: MxArrayPtr):bool ;cdecl;

 { Determine whether the specified array represents its data as
  unsigned 8-bit integers. }
  mxIsUint8: function(pa: MxArrayPtr):bool ;cdecl;

 { Determine whether the specified array represents its data as
  signed 16-bit integers. }
  mxIsInt16: function(pa: MxArrayPtr):bool ;cdecl;

 { Determine whether the specified array represents its data as
  unsigned 16-bit integers. }
  mxIsUint16: function(pa: MxArrayPtr):bool ;cdecl;

 { Determine whether the specified array represents its data as
  signed 32-bit integers. }
  mxIsInt32: function(pa: MxArrayPtr):bool ;cdecl;

 { Determine whether the specified array represents its data as
   unsigned 32-bit integers. }
  mxIsUint32: function(pa: MxArrayPtr):bool ;cdecl;

 { Determine whether the specified array represents its data as
  signed 64-bit integers. }
  mxIsInt64: function(pa: MxArrayPtr):bool ;cdecl;

 { Determine whether the specified array represents its data as
   unsigned 64-bit integers.}
  mxIsUint64: function(pa: MxArrayPtr):bool ;cdecl;

 { Get real data pointer for numeric array }
  mxGetPr: function(pa: MxArrayPtr):pointer;cdecl;


 { Set real data pointer for numeric array }
 mxSetPr: procedure(pa:MxArrayPtr; pr:pointer);cdecl;

 { Get imaginary data pointer for numeric array}
  mxGetPi: function(pa: MxArrayPtr): pointer;cdecl;

 { Set imaginary data pointer for numeric array }
  mxSetPi: procedure(pa: MxArrayPtr; pi:pointer);cdecl;

 { Get string array data }
  mxGetChars: function(pa: MxArrayPtr): PmxChar;cdecl;


 { Get 8 bits of user data stored in the mxArray header.  NOTE: This state
   of these bits are not guaranteed to be preserved after API function
   calls. }
  mxGetUserBits: function(pa: MxArrayPtr):integer;cdecl;

 { Set 8 bits of user data stored in the mxArray header. NOTE: This state
  of these bits are not guaranteed to be preserved after API function
  calls. }
  mxSetUserBits: procedure(pa: MxArrayPtr;value:integer);cdecl;

 { Get the real component of the specified array's first data element.}
  mxGetScalar: function(pa: MxArrayPtr):double ;cdecl;


 { Is the isFromGlobalWorkspace bit set? }
  mxIsFromGlobalWS: function(pa:MxArrayPtr): bool;cdecl;

 { Set the isFromGlobalWorkspace bit. }
  mxSetFromGlobalWS: procedure(pa: MxArrayPtr ;global:bool);cdecl;

 { Get number of dimensions in array}
  mxGetNumberOfDimensions: function(pa:MxArrayPtr):integer;cdecl;

 { Get pointer to dimension array}
  mxGetDimensions: function(pa:MxArrayPtr):pointer;cdecl;

 { Get row dimension}
  mxGetM: function(pa: MxArrayPtr):integer;cdecl;

 { Set row dimension}
  mxSetM: procedure(pa: MxArrayPtr;m:integer);cdecl;

 { Get column dimension }
  mxGetN: function(pa:MxArrayPtr):integer;cdecl;

 { Is array empty }
 mxIsEmpty: function(pa:MxArrayPtr):bool;cdecl;

 { Get row data pointer for sparse numeric array }
  mxGetIr: function(pa: MxArrayPtr):pointer;cdecl;

 { Set row data pointer for numeric array }
  mxSetIr: procedure(pa:MxArrayPtr;newir:pointer);cdecl;

 { Get column data pointer for sparse numeric array }
  mxGetJc: function(pa:MxArrayPtr):pointer;cdecl;

 { Set column data pointer for numeric array }
  mxSetJc: procedure(pa:MxArrayPtr;newjc:pointer);cdecl;

 { Get maximum nonzero elements for sparse numeric array }
  mxGetNzmax: function(pa: MxArrayPtr):integer;cdecl;

 { Set maximum nonzero elements for numeric array }
  mxSetNzmax: procedure(pa: MxArrayPtr;nzmax:integer);cdecl;

 { Get number of elements in array}
  mxGetNumberOfElements: function(pa: MxArrayPtr):integer;cdecl;

 { Get array data element size }
  mxGetElementSize: function(pa:MxArrayPtr):integer;cdecl;

 { Return the offset (in number of elements) from the beginning of
  the array to a given subscript. }
  mxCalcSingleSubscript: function(pa:MxArrayPtr;nsubs:integer;subs:pointer):integer;cdecl;

 { Get number of structure fields in array }
  mxGetNumberOfFields: function(pa: MxArrayPtr):integer;cdecl;

 { Get a pointer to the specified cell element. }
  mxGetCell: function(pa:MxArrayPtr;i:integer):MxArrayPtr;cdecl;

 { Set an element in a cell array to the specified value. }
  mxSetCell: procedure(pa:MxArrayPtr;i:integer;value: MxArrayPtr);cdecl;

 { Return pointer to the nth field name }
  mxGetFieldNameByNumber: function(pa: MxArrayPtr;n:integer):PansiChar;cdecl;

 { Get the index to the named field. }
  mxGetFieldNumber: function(pa: MxArrayPtr ;name:PansiChar):integer;cdecl;

 { Return a pointer to the contents of the named field for
  the ith element (zero based).}
  mxGetFieldByNumber: function(pa: MxArrayPtr;i:integer;fieldnum:integer): MxArrayPtr;cdecl;

 { Set pa[i][fieldnum] = value }
  mxSetFieldByNumber: procedure(pa:MxArrayPtr;i:integer;fieldnum:integer; value: MxArrayPtr);cdecl;

 { Return a pointer to the contents of the named field for the ith
   element (zero based).  Returns NULL on no such field or if the
   field itself is NULL }
  mxGetField: function(pa:MxArrayPtr;i:integer;fieldname:PansiChar):MxArrayPtr;cdecl;

 { Set pa[i]->fieldname = value }
 mxSetField: procedure(pa:MxArrayPtr;i:integer;fieldname: PansiChar; value:MxArrayPtr);cdecl;

 { Return the name of an array's class. }
  mxGetClassName: function(pa:MxArrayPtr):PansiChar;cdecl;

 { Determine whether an array is a member of the specified class. }
  mxIsClass: function(pa:MxArrayPtr;name:PansiChar):bool;cdecl;

 { Set scalar double flag}
//  mxSetScalarDoubleFlag: procedure(pa:MxArrayPtr);cdecl;

 { Clear scalar double flag }
//  mxClearScalarDoubleFlag: procedure(pa:MxArrayPtr);cdecl;

 { Is scalar double flag set}
//  mxIsScalarDoubleFlagSet: function(pa:MxArrayPtr):bool;cdecl;

 { Set scalar flag if appropiate (double scalar) }
//  mxSetScalarDoubleFlagIfAppropiate: procedure(pa:MxArrayPtr);cdecl;

 { Mark data as unshareable }
//  mxSetDataPrivateFlag: procedure(pa: MxArrayPtr;val:bool);cdecl;

 { Is data unshareable? }
//  mxIsDataPrivate: function(pa:MxArrayPtr): bool;cdecl;

 { Create a numeric matrix and initialize all its data elements to 0. }
  mxCreateNumericMatrix: function(m,n:integer;classid: mxClassID;cmplx_flag:mxComplexity):MxArrayPtr;cdecl;

 { Set column dimension }
  mxSetN: procedure(pa:MxArrayPtr;n:integer);cdecl;

 { Set dimension array and number of dimensions.  Returns 0 on success and 1
  if there was not enough memory available to reallocate the dimensions array.}
  mxSetDimensions: function(pa:MxArrayPtr;size:pointer;ndims:integer):integer;cdecl;

 { mxArray destructor }
  mxDestroyArray: procedure(pa:MxArrayPtr);cdecl;

 { Create a numeric array and initialize all its data elements to 0. }
  mxCreateNumericArray: function(ndim:integer;dims:pointer;classId: mxClassID;flag:mxComplexity ):MxArrayPtr;cdecl;

 { Create a two-dimensional array to hold double-precision
  floating-point data; initialize each data element to 0. }
  mxCreateDoubleMatrix: function(m,n:integer;flag:mxComplexity):MxArrayPtr;cdecl;

 { Get a properly typed pointer to the elements of a logical array. }
  mxGetLogicals: function(pa:MxArrayPtr):PmxLogical;cdecl;

 { Create a logical array and initialize its data elements to false.}
  mxCreateLogicalArray:function(ndim:integer;dims:pointer):MxArrayPtr;cdecl;

 { Create a two-dimensional array to hold logical data and
   initializes each data element to false.}
  mxCreateLogicalMatrix:function(m,n:longword):MxArrayPtr;cdecl;


 { Create a logical scalar mxArray having the specified value.}
  mxCreateLogicalScalar:function(value: bool):MxArrayPtr; cdecl;

 { Returns true if the logical scalar value is true. }
  mxIsLogicalScalarTrue:function( pa:MxArrayPtr):bool;cdecl;


 { Create a double-precision scalar mxArray initialized to the value specified }
  mxCreateDoubleScalar:function(value:double):MxArrayPtr;cdecl;

 { Create a 2-Dimensional sparse array. }
  mxCreateSparse:function(m,n,nzmax:integer;flag: mxComplexity):MxArrayPtr;cdecl;

 { Create a 2-D sparse logical array }
  mxCreateSparseLogicalMatrix: function(m,n,nzmax:integer):MxArrayPtr;cdecl;

 { Copies characters from a MATLAB array to a char array
  nChars is the number of bytes in the output buffer }
  mxGetNChars:procedure(pa:MxArrayPtr;buf:PansiChar; nChars:integer);cdecl;

 { Converts a string array to a C-style string. }
  mxGetString:function(pa:MxArrayPtr; buf:PansiChar; buflen:integer):integer;cdecl;

 { Create a NULL terminated C string from an mxArray of type mxCHAR_CLASS
   Supports multibyte character sets.  The resulting string must be freed
   with mxFree.  Returns NULL on out of memory or non-character arrays.}
  mxArrayToString: function(pa:MxArrayPtr):PansiChar;cdecl;

 { Create a 1-by-n string array initialized to str.}
  mxCreateStringFromNChars:function(str:PansiChar;n:integer):MxArrayPtr;cdecl;

 { Create a 1-by-n string array initialized to null terminated string
   where n is the length of the string. }
  mxCreateString:function(str:PansiChar):MxArrayPtr;cdecl;

 { Create an N-Dimensional array to hold string data;
   initialize all elements to 0. }
  mxCreateCharArray:function(ndim:integer;dims:pointer):MxArrayPtr;cdecl;

 { Create a string array initialized to the strings in str. }
  mxCreateCharMatrixFromStrings:function(m:integer;str: pointer):MxArrayPtr;cdecl;

 { Create a 2-Dimensional cell array, with each cell initialized to NULL. }
  mxCreateCellMatrix:function(m,n:integer):MxArrayPtr;cdecl;

 { Create an N-Dimensional cell array, with each cell initialized to NULL.}
  mxCreateCellArray:function(ndim:integer; dims:pointer):MxArrayPtr;cdecl;

 { Create a 2-Dimensional structure array having the specified fields;
  initialize all values to NULL. }
  mxCreateStructMatrix: function(m,n,nfields:integer;fieldnames:pointer):MxArrayPtr;cdecl;

 { Create an N-Dimensional structure array having the specified fields;
   initialize all values to NULL. }
  mxCreateStructArray:function(ndim:integer;dims:pointer; nfields:integer; fieldnames:pointer):MxArrayPtr;cdecl;

 { Make a deep copy of an array, return a pointer to the copy.}
  mxDuplicateArray:function(pa: MxArrayPtr ):MxArrayPtr;cdecl;

 { Set classname of an unvalidated object array.  It is illegal to
   call this function on a previously validated object array.
   Return 0 for success, 1 for failure. }
  mxSetClassName: function(pa:MxArrayPtr;classname:PansiChar):integer;cdecl;

 { Add a field to a structure array. Returns field number on success or -1
   if inputs are invalid or an out of memory condition occurs. }
  mxAddField: function(pa:MxArrayPtr; fieldname:PansiChar):integer;cdecl;

 { Remove a field from a structure array.  Does nothing if no such field exists.
   Does not destroy the field itself.}
  mxRemoveField: procedure(pa:MxArrayPtr;field:integer);cdecl;

const
   DEEP= 0;
   SHALLOW= 1;

var
 { Only for JIT use. }
//  mxResizeArray: procedure( plhs:MxArrayPtr; nin:integer; ldim:pointer);cdecl;

 { Function for obtaining MATLAB's concept of EPS }
  mxGetEps: function:double;cdecl;

 { Function for obtaining MATLAB's concept of INF (Used in MEX-File callback). }
  mxGetInf:function:double; cdecl;

 { Function for obtaining MATLAB's concept of NaN (Used in MEX-File callback). }
  mxGetNaN: function: double;cdecl;

 { test for finiteness in a machine-independent manner }
  mxIsFinite: function(x: double):bool;cdecl;

 { test for infinity in a machine-independent manner }
  mxIsInf: function(x: double): bool;cdecl;

 {  test for NaN in a machine-independent manner }
  mxIsNaN: function(x:double):bool;cdecl;

type
   calloc_proc= function(nmemb:size_t;size: size_t):pointer;cdecl;
   free_proc= procedure(p:pointer);cdecl;
   malloc_proc=function(size:size_t):pointer;cdecl;
   realloc_proc=function(p:pointer;size:size_t):pointer;cdecl;


var
 { Set the memory allocation functions used by the matrix library. You must
   supply calloc, realloc, free and malloc functions when using mxSetAllocFcns.
   NOTE: the free function MUST handle the case when the pointer to be freed
   is NULL.  The default AllocFcns for the matrix library are based on the
   standard C library functions calloc, free, realloc, and malloc. }
  mxSetAllocFcns: procedure(
	callocfcn : calloc_proc;
	freefcn : free_proc;
	reallocfcn : realloc_proc;
	mallocfcn : malloc_proc);cdecl;





{ Get pointer to array name. }
  //mxGetName: function(pa:MxArrayPtr): PansiChar;cdecl;

{ Set array name.  This routine copies the string pointed to by s
  into the mxMAXNAM length character name field. }
  //mxSetName: procedure(pa:MxArrayPtr; st:PansiChar);cdecl;

{ Inc reference count for an array }
//  mxIncRefCount: procedure(pa:MxArrayPtr);cdecl;

{ Increment the reference count for an array. }
//  mxIncrementRefCount: function(pa:MxArrayPtr):integer;cdecl;

{ Decrement the reference count for an array. }
//  mxDecrementRefCount: function(pa:MxArrayPtr):integer;cdecl;

function initMatLabMatrix:boolean;
Procedure FreeMatLabMatrix;

function testMatlabMatrix:boolean;

implementation


var
  Ftried, FOK:boolean;
  hMatrix:intG;

function initMatLabMatrix:boolean;
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
  hMatrix:= LoadMatlabDll('libmx.dll');
  //messageCentral('hmatrix = '+int64str(hMatrix));
   // sinon on prend les dlls de la distribution Elphy
  if hMatrix=0 then hMatrix:=GloadLibrary( Appdir+'Matlab\bin\'+'libmx.dll');
   // Si on charge les dll de Elphy alors que Matlab est installé, il y a des effets catastrophiques.


  if hMatrix=0 then exit;

  FOK:=true;
  result:=FOK;

  mxMalloc:=getProc(hMatrix,'mxMalloc');
  mxCalloc:=getProc(hMatrix,'mxCalloc');
  mxFree:=getProc(hMatrix,'mxFree');
  mxRealloc:=getProc(hMatrix,'mxRealloc');
  mxGetClassID :=getProc(hMatrix,'mxGetClassID');
  mxGetData:=getProc(hMatrix,'mxGetData');
  mxSetData:=getProc(hMatrix,'mxSetData');
  mxIsNumeric :=getProc(hMatrix,'mxIsNumeric');
  mxIsCell:=getProc(hMatrix,'mxIsCell');
  mxIsLogical:=getProc(hMatrix,'mxIsLogical');
  mxIsChar:=getProc(hMatrix,'mxIsChar');
  mxIsStruct:=getProc(hMatrix,'mxIsStruct');
  mxIsOpaque:=getProc(hMatrix,'mxIsOpaque');
  mxIsFunctionHandle:=getProc(hMatrix,'mxIsFunctionHandle');
  mxIsObject:=getProc(hMatrix,'mxIsObject');
  mxGetImagData:=getProc(hMatrix,'mxGetImagData');
  mxSetImagData:=getProc(hMatrix,'mxSetImagData');
  mxIsComplex:=getProc(hMatrix,'mxIsComplex');
  mxIsSparse:=getProc(hMatrix,'mxIsSparse');
  mxIsDouble:=getProc(hMatrix,'mxIsDouble');
  mxIsSingle:=getProc(hMatrix,'mxIsSingle');
  mxIsInt8:=getProc(hMatrix,'mxIsInt8');
  mxIsUint8:=getProc(hMatrix,'mxIsUint8');
  mxIsInt16:=getProc(hMatrix,'mxIsInt16');
  mxIsUint16:=getProc(hMatrix,'mxIsUint16');
  mxIsInt32:=getProc(hMatrix,'mxIsInt32');
  mxIsUint32:=getProc(hMatrix,'mxIsUint32');
  mxIsInt64:=getProc(hMatrix,'mxIsInt64');
  mxIsUint64:=getProc(hMatrix,'mxIsUint64');
  mxGetPr:=getProc(hMatrix,'mxGetPr');
  mxSetPr:=getProc(hMatrix,'mxSetPr');
  mxGetPi:=getProc(hMatrix,'mxGetPi');
  mxSetPi:=getProc(hMatrix,'mxSetPi');
  mxGetChars:=getProc(hMatrix,'mxGetChars');
  mxGetUserBits:=getProc(hMatrix,'mxGetUserBits');
  mxSetUserBits:=getProc(hMatrix,'mxSetUserBits');
  mxGetScalar:=getProc(hMatrix,'mxGetScalar');
  mxIsFromGlobalWS:=getProc(hMatrix,'mxIsFromGlobalWS');
  mxSetFromGlobalWS:=getProc(hMatrix,'mxSetFromGlobalWS');
  mxGetNumberOfDimensions:=getProc(hMatrix,'mxGetNumberOfDimensions');
  mxGetDimensions:=getProc(hMatrix,'mxGetDimensions');
  mxGetM:=getProc(hMatrix,'mxGetM');
  mxSetM:=getProc(hMatrix,'mxSetM');
  mxGetN:=getProc(hMatrix,'mxGetN');
  mxIsEmpty:=getProc(hMatrix,'mxIsEmpty');
  mxGetIr:=getProc(hMatrix,'mxGetIr');
  mxSetIr:=getProc(hMatrix,'mxSetIr');
  mxGetJc:=getProc(hMatrix,'mxGetJc');
  mxSetJc:=getProc(hMatrix,'mxSetJc');
  mxGetNzmax:=getProc(hMatrix,'mxGetNzmax');
  mxSetNzmax:=getProc(hMatrix,'mxSetNzmax');
  mxGetNumberOfElements:=getProc(hMatrix,'mxGetNumberOfElements');
  mxGetElementSize:=getProc(hMatrix,'mxGetElementSize');
  mxCalcSingleSubscript:=getProc(hMatrix,'mxCalcSingleSubscript');
  mxGetNumberOfFields:=getProc(hMatrix,'mxGetNumberOfFields');
  mxGetCell:=getProc(hMatrix,'mxGetCell');
  mxSetCell:=getProc(hMatrix,'mxSetCell');
  mxGetFieldNameByNumber:=getProc(hMatrix,'mxGetFieldNameByNumber');
  mxGetFieldNumber:=getProc(hMatrix,'mxGetFieldNumber');
  mxGetFieldByNumber:=getProc(hMatrix,'mxGetFieldByNumber');
  mxSetFieldByNumber:=getProc(hMatrix,'mxSetFieldByNumber');
  mxGetField:=getProc(hMatrix,'mxGetField');
  mxSetField:=getProc(hMatrix,'mxSetField');
  mxGetClassName:=getProc(hMatrix,'mxGetClassName');
  mxIsClass:=getProc(hMatrix,'mxIsClass');

  {
  N'existent pas dans la version Matlab 2007

  mxSetScalarDoubleFlag:=getProc(hMatrix,'mxSetScalarDoubleFlag');
  mxClearScalarDoubleFlag:=getProc(hMatrix,'mxClearScalarDoubleFlag');
  mxIsScalarDoubleFlagSet:=getProc(hMatrix,'mxIsScalarDoubleFlagSet');
  mxSetScalarDoubleFlagIfAppropiate:=getProc(hMatrix,'mxSetScalarDoubleFlagIfAppropiate');
  mxSetDataPrivateFlag:=getProc(hMatrix,'mxSetDataPrivateFlag');
  mxIsDataPrivate:=getProc(hMatrix,'mxIsDataPrivate');
  }
  mxCreateNumericMatrix:=getProc(hMatrix,'mxCreateNumericMatrix');
  mxSetN:=getProc(hMatrix,'mxSetN');
  mxSetDimensions:=getProc(hMatrix,'mxSetDimensions');
  mxDestroyArray:=getProc(hMatrix,'mxDestroyArray');
  mxCreateNumericArray:=getProc(hMatrix,'mxCreateNumericArray');
  mxCreateDoubleMatrix:=getProc(hMatrix,'mxCreateDoubleMatrix');
  mxGetLogicals:=getProc(hMatrix,'mxGetLogicals');
  mxCreateLogicalArray:=getProc(hMatrix,'mxCreateLogicalArray');
  mxCreateLogicalMatrix:=getProc(hMatrix,'mxCreateLogicalMatrix');
  mxCreateLogicalScalar:=getProc(hMatrix,'mxCreateLogicalScalar');
  mxIsLogicalScalarTrue:=getProc(hMatrix,'mxIsLogicalScalarTrue');
  mxCreateDoubleScalar:=getProc(hMatrix,'mxCreateDoubleScalar');
  mxCreateSparse:=getProc(hMatrix,'mxCreateSparse');
  mxCreateSparseLogicalMatrix:=getProc(hMatrix,'mxCreateSparseLogicalMatrix');
  mxGetNChars:=getProc(hMatrix,'mxGetNChars');
  mxGetString:=getProc(hMatrix,'mxGetString');
  mxArrayToString:=getProc(hMatrix,'mxArrayToString');
  mxCreateStringFromNChars:=getProc(hMatrix,'mxCreateStringFromNChars');
  mxCreateString:=getProc(hMatrix,'mxCreateString');
  mxCreateCharArray:=getProc(hMatrix,'mxCreateCharArray');
  mxCreateCharMatrixFromStrings:=getProc(hMatrix,'mxCreateCharMatrixFromStrings');
  mxCreateCellMatrix:=getProc(hMatrix,'mxCreateCellMatrix');
  mxCreateCellArray:=getProc(hMatrix,'mxCreateCellArray');
  mxCreateStructMatrix:=getProc(hMatrix,'mxCreateStructMatrix');
  mxCreateStructArray:=getProc(hMatrix,'mxCreateStructArray');
  mxDuplicateArray:=getProc(hMatrix,'mxDuplicateArray');
  mxSetClassName:=getProc(hMatrix,'mxSetClassName');
  mxAddField:=getProc(hMatrix,'mxAddField');
  mxRemoveField:=getProc(hMatrix,'mxRemoveField');

  { N'existe pas dans la version Matlab 2007
  mxResizeArray:=getProc(hMatrix,'mxResizeArray');
  }
  mxGetEps:=getProc(hMatrix,'mxGetEps');
  mxGetInf:=getProc(hMatrix,'mxGetInf');
  mxGetNaN:=getProc(hMatrix,'mxGetNaN');
  mxIsFinite:=getProc(hMatrix,'mxIsFinite');
  mxIsInf:=getProc(hMatrix,'mxIsInf');
  mxIsNaN:=getProc(hMatrix,'mxIsNaN');
  {
  mxSetAllocFcns:=getProc(hMatrix,'mxSetAllocFcns');
  }
  //mxGetName:=getProc(hMatrix,'mxGetName'); n'existe pas dans win64
  //mxSetName:=getProc(hMatrix,'mxSetName'); n'existe pas dans win64

  {N'existe pas dans la version Matlab 2007
  mxIncRefCount:=getProc(hMatrix,'mxIncRefCount');
  }
  {
  mxIncrementRefCount:=getProc(hMatrix,'mxIncrementRefCount');
  mxDecrementRefCount:=getProc(hMatrix,'mxDecrementRefCount');
  }
  //messageCentral('libmx loaded');
end;


Procedure FreeMatLabMatrix;
begin
  if hMatrix<>0 then freeLibrary(hMatrix);
  hMatrix:=0;
end;

function testMatlabMatrix:boolean;
begin
  result:=initMatlabMatrix;
  if not result then sortieErreur('Unable to call matlab dll');
end;

Initialization
AffDebug('Initialization matlab_matrix',0);

finalization
  freeMatLabMatrix;


end.
