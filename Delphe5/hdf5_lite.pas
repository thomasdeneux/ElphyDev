unit hdf5_lite;

interface

uses windows, util1, hdf5dll;


(* Flag definitions for H5LTopen_file_image() *)
Const
  H5LT_FILE_IMAGE_OPEN_RW   =    1;       (* Open image for read-write *)
  H5LT_FILE_IMAGE_DONT_COPY =    2;       (* The HDF5 lib won't copy   *)
(* user supplied image buffer. The same image is open with the core driver.  *)
  H5LT_FILE_IMAGE_DONT_RELEASE = 4;       (* The HDF5 lib won't        *)
(* deallocate user supplied image buffer. The user application is reponsible *)
(* for doing so.                                                             *)
  H5LT_FILE_IMAGE_ALL  =         7;

type
  H5LT_lang_t = (
    H5LT_LANG_ERR = -1, (*this is the first*)
    H5LT_DDL      = 0,  (*for DDL*)
    H5LT_C        = 1,  (*for C*)
    H5LT_FORTRAN  = 2,  (*for Fortran*)
    H5LT_NO_LANG  = 3   (*this is the last*)
    );


(*-------------------------------------------------------------------------
 *
 * Make dataset functions
 *
 *-------------------------------------------------------------------------
 *)

var
  H5LTmake_dataset: function(  loc_id: hid_t;
                               dset_name: PansiChar;
                               rank: integer;
                               dims: pointer;
                               type_id: hid_t;
                               buffer: pointer ) :  herr_t; cdecl;

  H5LTmake_dataset_char,
  H5LTmake_dataset_short,
  H5LTmake_dataset_int,
  H5LTmake_dataset_long,
  H5LTmake_dataset_float,
  H5LTmake_dataset_double,
  H5LTmake_dataset_string: function( loc_id: hid_t ;
                                     dset_name: PansiChar;
                                     rank: integer;
                                     dims: pointer;
                                     buffer: pointer ): herr_t; cdecl;


(*-------------------------------------------------------------------------
 *
 * Read dataset functions
 *
 *-------------------------------------------------------------------------
 *)

  H5LTread_dataset: function( loc_id: hid_t;
                              dset_name: PansiChar;
                              type_id: hid_t;
                              buffer:pointer ):herr_t; cdecl;

  H5LTread_dataset_char,
  H5LTread_dataset_short,
  H5LTread_dataset_int,
  H5LTread_dataset_long,
  H5LTread_dataset_float,
  H5LTread_dataset_double,
  H5LTread_dataset_string: function( loc_id: hid_t;
                                     dset_name: PansiChar;
                                     buffer:pointer ):herr_t; cdecl;

(*-------------------------------------------------------------------------
 *
 * Query dataset functions
 *
 *-------------------------------------------------------------------------
 *)


  H5LTget_dataset_ndims: function(loc_id:  hid_t ;
                                  dset_name: PansiChar;
                                  var rank: integer ):herr_t; cdecl;

  H5LTget_dataset_info: function( loc_id:  hid_t ;
                                  dset_name: PansiChar;
                                  dims: pointer;
                                  var type_class:H5T_class_t;
                                  var type_size: size_t ):herr_t; cdecl;

  H5LTfind_dataset: function( loc_id: hid_t; name: PansiChar ):herr_t; cdecl;



(*-------------------------------------------------------------------------
 *
 * Set attribute functions
 *
 *-------------------------------------------------------------------------
 *)


   H5LTset_attribute_string: function(  loc_id: hid_t;
                                              obj_name: Pansichar;
                                              attr_name: Pansichar;
                                              attr_data: PansiChar ): herr_t;

 H5LTset_attribute_char,
 H5LTset_attribute_uchar,

 H5LTset_attribute_short,
 H5LTset_attribute_ushort,
 H5LTset_attribute_int,
 H5LTset_attribute_uint,
 H5LTset_attribute_long,
 H5LTset_attribute_long_long,
 H5LTset_attribute_ulong,
 H5LTset_attribute_float,
 H5LTset_attribute_double: function( loc_id: hid_t;
                                     obj_name: Pansichar;
                                     attr_name: Pansichar;
                                     attr_data: Pointer;
                                     size: size_t): herr_t;cdecl;


(*-------------------------------------------------------------------------
 *
 * Get attribute functions
 *
 *-------------------------------------------------------------------------
 *)

 H5LTget_attribute:  function( loc_id: hid_t;
                                       obj_name: PansiChar;
                                       attr_name: Pansichar;
                                       mem_type_id: hid_t;
                                       data:pointer ): herr_t;cdecl;

 H5LTget_attribute_string,
 H5LTget_attribute_char,
 H5LTget_attribute_uchar,
 H5LTget_attribute_short,
 H5LTget_attribute_ushort,
 H5LTget_attribute_int,
 H5LTget_attribute_uint,
 H5LTget_attribute_long,
 H5LTget_attribute_long_long,
 H5LTget_attribute_ulong,
 H5LTget_attribute_float,
 H5LTget_attribute_double:  function ( loc_id: hid_t;
                                       obj_name: Pansichar;
                                       attr_name: Pansichar;
                                       data: pointer ): herr_t;cdecl;


(*-------------------------------------------------------------------------
 *
 * Query attribute functions
 *
 *-------------------------------------------------------------------------
 *)


 H5LTget_attribute_ndims: function(  loc_id: hid_t;
                                     obj_name: PansiChar;
                                     attr_name: Pansichar;
                                     var rank: integer ): herr_t;cdecl;

 H5LTget_attribute_info: function( loc_id: herr_t;
                                    obj_name: Pansichar;
                                    attr_name: Pansichar;
                                    dims: pointer;
                                    var type_class: H5T_class_t;
                                    var type_size: size_t ): herr_t;cdecl;





(*-------------------------------------------------------------------------
 *
 * General functions
 *
 *-------------------------------------------------------------------------
 *)

 H5LTtext_to_dtype: function( text: Pansichar; lang_type: H5LT_lang_t): hid_t ;cdecl;

 H5LTdtype_to_text: function( dtype: hid_t; str: Pansichar;  lang_type:H5LT_lang_t; var len: size_t):herr_t ;cdecl;


(*-------------------------------------------------------------------------
 *
 * Utility functions
 *
 *-------------------------------------------------------------------------
 *)

  H5LTfind_attribute: function( loc_id:hid_t; name: Pansichar ):herr_t;cdecl;

  H5LTpath_valid: function(loc_id: hid_t ; path: Pansichar;  check_object_valid: hbool_t):htri_t ;cdecl;

(*-------------------------------------------------------------------------
 *
 * File image operations functions
 *
 *-------------------------------------------------------------------------
 *)

H5LTopen_file_image: function ( buf_ptr: pointer; buf_size:  size_t ; flags: integer): hid_t ;cdecl;


function InitHdf5_lite: boolean;

implementation

Const
  DLLname = 'hdf5_hl';

var
  hh: Thandle;

function InitHdf5_lite: boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary(Appdir+'\hdf5\'+DLLname);
  result:=(hh<>0);
  if not result then exit;


  H5LTmake_dataset:= getProc(hh,'H5LTmake_dataset');
  H5LTmake_dataset_char:= getProc(hh,'H5LTmake_dataset_char');
  H5LTmake_dataset_short:= getProc(hh,'H5LTmake_dataset_short');
  H5LTmake_dataset_int:= getProc(hh,'H5LTmake_dataset_int');
  H5LTmake_dataset_long:= getProc(hh,'H5LTmake_dataset_long');
  H5LTmake_dataset_float:= getProc(hh,'H5LTmake_dataset_float');
  H5LTmake_dataset_double:= getProc(hh,'H5LTmake_dataset_double');
  H5LTmake_dataset_string:= getProc(hh,'H5LTmake_dataset_string');

  H5LTread_dataset:= getProc(hh,'H5LTread_dataset');

  H5LTread_dataset_char:= getProc(hh,'H5LTread_dataset_char');
  H5LTread_dataset_short:= getProc(hh,'H5LTread_dataset_short');
  H5LTread_dataset_int:= getProc(hh,'H5LTread_dataset_int');
  H5LTread_dataset_long:= getProc(hh,'H5LTread_dataset_long');
  H5LTread_dataset_float:= getProc(hh,'H5LTread_dataset_float');
  H5LTread_dataset_double:= getProc(hh,'H5LTread_dataset_double');
  H5LTread_dataset_string:= getProc(hh,'H5LTread_dataset_string');

  H5LTget_dataset_ndims:= getProc(hh,'H5LTget_dataset_ndims');

  H5LTget_dataset_info:= getProc(hh,'H5LTget_dataset_info');

  H5LTfind_dataset:= getProc(hh,'H5LTfind_dataset');

  H5LTset_attribute_string:= getProc(hh,'H5LTset_attribute_string');

  H5LTset_attribute_char:= getProc(hh,'H5LTset_attribute_char');
  H5LTset_attribute_uchar:= getProc(hh,'H5LTset_attribute_uchar');

  H5LTset_attribute_short:= getProc(hh,'H5LTset_attribute_short');
  H5LTset_attribute_ushort:= getProc(hh,'H5LTset_attribute_ushort');
  H5LTset_attribute_int:= getProc(hh,'H5LTset_attribute_int');
  H5LTset_attribute_uint:= getProc(hh,'H5LTset_attribute_uint');
  H5LTset_attribute_long:= getProc(hh,'H5LTset_attribute_long');
  H5LTset_attribute_long_long:= getProc(hh,'H5LTset_attribute_long_long');
  H5LTset_attribute_ulong:= getProc(hh,'H5LTset_attribute_ulong');
  H5LTset_attribute_float:= getProc(hh,'H5LTset_attribute_float');
  H5LTset_attribute_double:= getProc(hh,'H5LTset_attribute_double');

  H5LTget_attribute:= getProc(hh,'H5LTget_attribute');

  H5LTget_attribute_string:= getProc(hh,'H5LTget_attribute_string');
  H5LTget_attribute_char:= getProc(hh,'H5LTget_attribute_char');
  H5LTget_attribute_uchar:= getProc(hh,'H5LTget_attribute_uchar');
  H5LTget_attribute_short:= getProc(hh,'H5LTget_attribute_short');
  H5LTget_attribute_ushort:= getProc(hh,'H5LTget_attribute_ushort');
  H5LTget_attribute_int:= getProc(hh,'H5LTget_attribute_int');
  H5LTget_attribute_uint:= getProc(hh,'H5LTget_attribute_uint');
  H5LTget_attribute_long:= getProc(hh,'H5LTget_attribute_long');
  H5LTget_attribute_long_long:= getProc(hh,'H5LTget_attribute_long_long');
  H5LTget_attribute_ulong:= getProc(hh,'H5LTget_attribute_ulong');
  H5LTget_attribute_float:= getProc(hh,'H5LTget_attribute_float');
  H5LTget_attribute_double:= getProc(hh,'H5LTget_attribute_double');

  H5LTget_attribute_ndims:= getProc(hh,'H5LTget_attribute_ndims');

  H5LTget_attribute_info:= getProc(hh,'H5LTget_attribute_info');

  H5LTtext_to_dtype:= getProc(hh,'H5LTtext_to_dtype');

  H5LTdtype_to_text:= getProc(hh,'H5LTdtype_to_text');

  H5LTfind_attribute:= getProc(hh,'H5LTfind_attribute');
  H5LTpath_valid:= getProc(hh,'H5LTpath_valid');

  H5LTopen_file_image:= getProc(hh,'H5LTopen_file_image');
end;



end.
