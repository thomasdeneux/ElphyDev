unit hdf5;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


{$Z+,A+}

Const
  DLLname='HDF5DLL';

  {Modules convertis:      H5public.H
                           H5Ipublic.H
                           H5Fpublic.H

  }

{************************************************* H5public.H *****************************************}

(* Version numbers *)
Const
  H5_VERS_MAJOR=1;	(* For major interface/format changes  	     *)
  H5_VERS_MINOR=6;	(* For minor interface/format changes  	     *)
  H5_VERS_RELEASE=5;	(* For tweaks, bug-fixes, or development     *)
  H5_VERS_SUBRELEASE='';(* For pre-releases like snap0       *)
			(* Empty string for real releases.           *)
  H5_VERS_INFO='HDF5 library version: 1.6.5';      (* Full version string *)


(*
 * Status return values.  Failed integer functions in HDF5 result almost
 * always in a negative value (unsigned failing functions sometimes return
 * zero for failure) while successfull return is non-negative (often zero).
 * The negative failure value is most commonly -1, but don't bet on it.  The
 * proper way to detect failure is something like:
 *
 * 	if ((dset = H5Dopen (file, name))<0) {
 *	    fprintf (stderr, "unable to open the requested dataset\n");
 *	}
 *)

type
  herr_t=integer;

(*
 * Boolean type.  Successful return values are zero (false) or positive
 * (true). The typical true value is 1 but don't bet on it.  Boolean
 * functions cannot fail.  Functions that return `htri_t' however return zero
 * (false), positive (true), or negative (failure). The proper way to test
 * for truth from a htri_t function is:
 *
 * 	if ((retval = H5Tcommitted(type))>0) {
 *	    printf("data type is committed\n");
 *	} else if (!retval) {
 * 	    printf("data type is not committed\n");
 *	} else {
 * 	    printf("error determining whether data type is committed\n");
 *	}
 *)
  hbool_t=longword;
  htri_t=integer;

(* Define the ssize_t type if it not is defined *)
type
  ssize_t=integer;    { Au pif , essayer int64 }
  hsize_t=integer;
  hssize_t=integer;
  size_t=integer;


(*
 * File addresses have there own types.
 *)
   haddr_t= int64;


(* Functions in H5.c *)
var
  H5open:            function: herr_t;cdecl;
  H5close:           function: herr_t;cdecl;
  H5dont_atexit:     function: herr_t;cdecl;
  H5garbage_collect: function: herr_t;cdecl;
  H5set_free_list_limits:
                     function( reg_global_lim,reg_list_lim, arr_global_lim, arr_list_lim, blk_global_lim,
                               blk_list_lim:integer):herr_t;cdecl;
  H5get_libversion:  function(var majnum, minnum, relnum: longword):herr_t;cdecl;
  H5check_version:   function( majnum, minnum, relnum:longword): herr_t;cdecl;



{************************************************* H5Ipublic.h *****************************************}

(*
 * Group values allowed.  Start with `1' instead of `0' because it makes the
 * tracing output look better when hid_t values are large numbers.  Change the
 * GROUP_BITS in H5I.c if the MAXID gets larger than 32 (an assertion will
 * fail otherwise).
 *
 * When adding groups here, add a section to the 'misc19' test in test/tmisc.c
 * to verify that the H5I{inc|dec|get}_ref() routines work correctly with in.
 *
 *)
type
  H5I_type_t= ( H5I_BADID		= (-1),	(*invalid Group				    *)
                H5I_FILE		= 1,	(*group ID for File objects		    *)
                H5I_GROUP,		        (*group ID for Group objects		    *)
                H5I_DATATYPE,         	        (*group ID for Datatype objects		    *)
                H5I_DATASPACE,	                (*group ID for Dataspace objects	    *)
                H5I_DATASET,	                (*group ID for Dataset objects		    *)
                H5I_ATTR,		        (*group ID for Attribute objects	    *)
                H5I_REFERENCE,	                (*group ID for Reference objects	    *)
                H5I_VFL,			(*group ID for virtual file layer	    *)
                H5I_GENPROP_CLS,                (*group ID for generic property list classes *)
                H5I_GENPROP_LST,                (*group ID for generic property lists       *)

                H5I_NGROUPS		        (*number of valid groups, MUST BE LAST!	    *)
               );

(* Type of atoms to return to users *)
  hid_t=integer;

(* An invalid object ID. This is also negative for error return. *)
Const
  H5I_INVALID_HID=   -1;

var
(* Public API functions *)
   H5Iget_type:       function(id:hid_t):H5I_type_t;cdecl;
   H5Iget_file_id:    function(id:hid_t):hid_t ;cdecl;
   H5Iget_name:       function(id:hid_t; name:Pchar; size: size_t):ssize_t ;cdecl;
   H5Iinc_ref:        function(id:hid_t):integer;cdecl;
   H5Idec_ref:        function(id:hid_t):integer;cdecl;
   H5Iget_ref:        function(id:hid_t):integer;cdecl;



{************************************************* H5Dpublic.h ***************************************}


(* Values for the H5D_LAYOUT property *)
type
  H5D_layout_t =(
    H5D_LAYOUT_ERROR	= -1,

    H5D_COMPACT		= 0,	(*raw data is very small		     *)
    H5D_CONTIGUOUS	= 1,	(*the default				     *)
    H5D_CHUNKED		= 2,	(*slow and fancy			     *)
    H5D_NLAYOUTS	= 3	(*this one must be last!		     *)
                );

(* Values for the space allocation time property *)
  H5D_alloc_time_t =(
    H5D_ALLOC_TIME_ERROR	=-1,
    H5D_ALLOC_TIME_DEFAULT  	=0,
    H5D_ALLOC_TIME_EARLY	=1,
    H5D_ALLOC_TIME_LATE	=2,
    H5D_ALLOC_TIME_INCR	=3
                );

(* Values for the status of space allocation *)
  H5D_space_status_t =(
    H5D_SPACE_STATUS_ERROR	=-1,
    H5D_SPACE_STATUS_NOT_ALLOCATED	=0,
    H5D_SPACE_STATUS_PART_ALLOCATED	=1,
    H5D_SPACE_STATUS_ALLOCATED		=2
                     );

(* Values for time of writing fill value property *)
  H5D_fill_time_t =(
    H5D_FILL_TIME_ERROR	=-1,
    H5D_FILL_TIME_ALLOC =0,
    H5D_FILL_TIME_NEVER	=1,
    H5D_FILL_TIME_IFSET	=2
                    );

(* Values for fill value status *)
  H5D_fill_value_t =(
    H5D_FILL_VALUE_ERROR        =-1,
    H5D_FILL_VALUE_UNDEFINED    =0,
    H5D_FILL_VALUE_DEFAULT      =1,
    H5D_FILL_VALUE_USER_DEFINED =2
                     );

(* Define the operator function pointer for H5Diterate() *)
type
  H5D_operator_t=function(elem:pointer;  type_id: hid_t; ndim:longword;var point:hsize_t; operator_data:pointer):herr_t;

var
   H5Dcreate: function (file_id:hid_t ; name:Pchar; type_id:hid_t ; space_id:hid_t ; plist_id:hid_t ):hid_t;
   H5Dopen: function (file_id:hid_t ; name:Pchar):hid_t ;
   H5Dclose: function( dset_id: hid_t):herr_t ;
   H5Dget_space: function (dset_id: hid_t ):hid_t ;
   H5Dget_space_status: function(dset_id:hid_t ; var  allocation:H5D_space_status_t):herr_t ;
   H5Dget_type: function (dset_id:hid_t ):hid_t ;
   H5Dget_create_plist: function ( dset_id:hid_t):hid_t ;
   H5Dget_storage_size: function( dset_id:hid_t): hsize_t;
   H5Dget_offset: function( dset_id:hid_t): haddr_t;
   H5Dread: function (dset_id:hid_t ; mem_type_id:hid_t ; mem_space_id:hid_t ;file_space_id:hid_t ; plist_id:hid_t ; buf:pointer):herr_t ;
   H5Dwrite: function (dset_id:hid_t ; mem_type_id:hid_t ; mem_space_id:hid_t ;file_space_id:hid_t ; plist_id:hid_t ; buf:pointer):herr_t ;
   H5Dextend: function (dset_id:hid_t ; var size :  hsize_t ):herr_t ;
   H5Diterate: function(buf:pointer; type_id:hid_t ; space_id:hid_t ;op:H5D_operator_t ; operator_data:pointer):herr_t;
   H5Dvlen_reclaim: function(type_id:hid_t ; space_id:hid_t ; plist_id:hid_t ; buf:pointer):herr_t ;
   H5Dvlen_get_buf_size: function(dataset_id:hid_t ; type_id:hid_t ; space_id:hid_t ; var  size:hsize_t):herr_t ;
   H5Dfill: function(fill:pointer; fill_type:hid_t ; buf:pointer;buf_type:hid_t ; space: hid_t):herr_t ;
   H5Dset_extent: function (dset_id:hid_t ; var  size: hsize_t):herr_t ;
   H5Ddebug: function( dset_id : hid_t):herr_t ;



{************************************************* H5Fpublic.H *****************************************}


(*
 * These are the bits that can be passed to the `flags' argument of
 * H5Fcreate() and H5Fopen(). Use the bit-wise OR operator (|) to combine
 * them as needed.  As a side effect, they call H5check_version() to make sure
 * that the application is compiled with a version of the hdf5 header files
 * which are compatible with the library to which the application is linked.
 * We're assuming that these constants are used rather early in the hdf5
 * session.
 *
 * NOTE: When adding H5F_ACC_* macros, remember to redefine them in H5Fprivate.h
 *
 *)

Const
  H5F_ACC_RDONLY=  $0000;       (*absence of rdwr => rd-only *)
  H5F_ACC_RDWR	=  $0001;       (*open for read and write    *)
  H5F_ACC_TRUNC =  $0002;	 (*overwrite existing files   *)
  H5F_ACC_EXCL	=  $0004;	 (*fail if file already exists*)
  H5F_ACC_DEBUG	=  $0008;	 (*print debug info	     *)
  H5F_ACC_CREAT	=  $0010;	 (*create non-existing files  *)

(* Flags for H5Fget_obj_count() & H5Fget_obj_ids() calls *)

  H5F_OBJ_FILE	    =  $0001;       (* File objects *)
  H5F_OBJ_DATASET   =  $0002;       (* Dataset objects *)
  H5F_OBJ_GROUP	    =  $0004;       (* Group objects *)
  H5F_OBJ_DATATYPE  =  $0008;       (* Named datatype objects *)
  H5F_OBJ_ATTR      =  $0010;       (* Attribute objects *)
  H5F_OBJ_ALL 	    =  H5F_OBJ_FILE or H5F_OBJ_DATASET or H5F_OBJ_GROUP or H5F_OBJ_DATATYPE or H5F_OBJ_ATTR;
  H5F_OBJ_LOCAL     =  $0020;      (* Restrict search to objects opened through current file ID *)
                                     (* (as opposed to objects opened through any file ID accessing this file) *)


(* The difference between a single file and a set of mounted files *)
type
  H5F_scope_t = (H5F_SCOPE_LOCAL,	(*specified file handle only		*)
                 H5F_SCOPE_GLOBAL,	(*entire virtual file			*)
                 H5F_SCOPE_DOWN         (*for internal use only			*)
                );

(* Unlimited file size for H5Pset_external() *)
Const
  H5F_UNLIMITED=-1;

(* How does file close behave?
 * H5F_CLOSE_DEFAULT - Use the degree pre-defined by underlining VFL
 * H5F_CLOSE_WEAK    - file closes only after all opened objects are closed
 * H5F_CLOSE_SEMI    - if no opened objects, file is close; otherwise, file
		       close fails
 * H5F_CLOSE_STRONG  - if there are opened objects, close them first, then
		       close file
 *)
type
  H5F_close_degree_t=(  H5F_CLOSE_DEFAULT   = 0,
                        H5F_CLOSE_WEAK      = 1,
                        H5F_CLOSE_SEMI      = 2,
                        H5F_CLOSE_STRONG    = 3
                      );


(* Functions in H5F.c *)
var
  H5Fis_hdf5:            function (filename:Pchar):htri_t ;cdecl;
  H5Fcreate:             function (filename:Pchar;flags:longword;create_plist:hid_t;access_plist:hid_t):hid_t;cdecl;
  H5Fopen:               function (filename:Pchar;flags:longword;access_plist:hid_t):hid_t;cdecl;
  H5Freopen:             function(file_id:hid_t):hid_t;cdecl;
  H5Fflush:              function(object_id:hid_t ;scope:H5F_scope_t ):herr_t ;cdecl;
  H5Fclose:              function (file_id:hid_t ):herr_t ;cdecl;
  H5Fget_create_plist:   function (file_id:hid_t ):hid_t ; cdecl;
  H5Fget_access_plist:   function ( file_id:hid_t):hid_t ; cdecl;
  H5Fget_obj_count:      function( file_id:hid_t; types:longword):integer;cdecl;
  H5Fget_obj_ids:        function(file_id:hid_t;types:longword;max_objs:integer; var obj_id_list: hid_t):integer;cdecl;
  H5Fget_vfd_handle:     function(file_id:hid_t ; fapl:hid_t ; var file_handle:pointer):herr_t ;cdecl;
  H5Fmount:              function(loc:hid_t;name:Pchar;child: hid_t ;  plist:hid_t):herr_t ;cdecl;
  H5Funmount:            function(loc:hid_t ;name:Pchar):herr_t ;cdecl;
  H5Fget_freespace:      function( file_id:hid_t):hssize_t ;cdecl;
  H5Fget_filesize:       function( file_id:hid_t; var size:hsize_t):herr_t;cdecl;
  H5Fget_name:           function(obj_id:hid_t ; name:Pchar;size: size_t ):ssize_t;cdecl;



{**************************************************** H5FDpublic.H *********************************}

(*
 * Types of allocation requests. The values larger than H5FD_MEM_DEFAULT
 * should not change other than adding new types to the end. These numbers
 * might appear in files.
 *)
type
 H5FD_mem_t =(
    H5FD_MEM_NOLIST	= -1,			(*must be negative*)
    H5FD_MEM_DEFAULT	= 0,			(*must be zero*)
    H5FD_MEM_SUPER      = 1,
    H5FD_MEM_BTREE      = 2,
    H5FD_MEM_DRAW       = 3,
    H5FD_MEM_GHEAP      = 4,
    H5FD_MEM_LHEAP      = 5,
    H5FD_MEM_OHDR       = 6,

    H5FD_MEM_NTYPES				(*must be last*)
              );

(*
 * A free-list map which maps all types of allocation requests to a single
 * free list.  This is useful for drivers that don't really care about
 * keeping different requests segregated in the underlying file and which
 * want to make most efficient reuse of freed memory.  The use of the
 * H5FD_MEM_SUPER free list is arbitrary.
 *)

 Const
   H5FD_FLMAP_SINGLE:array[1..7] of H5FD_mem_t =(
    H5FD_MEM_SUPER,			(*default*)
    H5FD_MEM_SUPER,			(*super*)
    H5FD_MEM_SUPER,			(*btree*)
    H5FD_MEM_SUPER,			(*draw*)
    H5FD_MEM_SUPER,			(*gheap*)
    H5FD_MEM_SUPER,			(*lheap*)
    H5FD_MEM_SUPER			(*ohdr*)
                    );

(*
 * A free-list map which segregates requests into `raw' or `meta' data
 * pools.
 *)
H5FD_FLMAP_DICHOTOMY:array[1..7] of H5FD_mem_t =(
    H5FD_MEM_SUPER,			(*default*)
    H5FD_MEM_SUPER,			(*super*)
    H5FD_MEM_SUPER,			(*btree*)
    H5FD_MEM_DRAW,			(*draw*)
    H5FD_MEM_SUPER,			(*gheap*)
    H5FD_MEM_SUPER,			(*lheap*)
    H5FD_MEM_SUPER			(*ohdr*)
                    );

(*
 * The default free list map which causes each request type to use it's own
 * free-list.
 *)
  H5FD_FLMAP_DEFAULT: array[1..7] of H5FD_mem_t =(
    H5FD_MEM_DEFAULT,			(*default*)
    H5FD_MEM_DEFAULT,			(*super*)
    H5FD_MEM_DEFAULT,			(*btree*)
    H5FD_MEM_DEFAULT,			(*draw*)
    H5FD_MEM_DEFAULT,			(*gheap*)
    H5FD_MEM_DEFAULT,			(*lheap*)
    H5FD_MEM_DEFAULT			(*ohdr*)
                     );


(* Define VFL driver features that can be enabled on a per-driver basis *)
(* These are returned with the 'query' function pointer in H5FD_class_t *)
    (*
     * Defining the H5FD_FEAT_AGGREGATE_METADATA for a VFL driver means that
     * the library will attempt to allocate a larger block for metadata and
     * then sub-allocate each metadata request from that larger block.
     *)
 H5FD_FEAT_AGGREGATE_METADATA   = $00000001;
    (*
     * Defining the H5FD_FEAT_ACCUMULATE_METADATA for a VFL driver means that
     * the library will attempt to cache metadata as it is written to the file
     * and build up a larger block of metadata to eventually pass to the VFL
     * 'write' routine.
     *
     * Distinguish between updating the metadata accumulator on writes and
     * reads.  This is particularly (perhaps only, even) important for MPI-I/O
     * where we guarantee that writes are collective, but reads may not be.
     * If we were to allow the metadata accumulator to be written during a
     * read operation, the application would hang.
     *)
  H5FD_FEAT_ACCUMULATE_METADATA_WRITE    = $00000002;
  H5FD_FEAT_ACCUMULATE_METADATA_READ     = $00000004;
  H5FD_FEAT_ACCUMULATE_METADATA   = H5FD_FEAT_ACCUMULATE_METADATA_WRITE or H5FD_FEAT_ACCUMULATE_METADATA_READ;
    (*
     * Defining the H5FD_FEAT_DATA_SIEVE for a VFL driver means that
     * the library will attempt to cache raw data as it is read from/written to
     * a file in a "data seive" buffer.  See Rajeev Thakur's papers:
     *  http://www.mcs.anl.gov/~thakur/papers/romio-coll.ps.gz
     *  http://www.mcs.anl.gov/~thakur/papers/mpio-high-perf.ps.gz
     *)
  H5FD_FEAT_DATA_SIEVE            = $00000008;
    (*
     * Defining the H5FD_FEAT_AGGREGATE_SMALLDATA for a VFL driver means that
     * the library will attempt to allocate a larger block for "small" raw data
     * and then sub-allocate "small" raw data requests from that larger block.
     *)
  H5FD_FEAT_AGGREGATE_SMALLDATA   = $00000010;


(* Forward declaration *)
typedef struct H5FD_t H5FD_t;

(* Class information for each file driver *)
typedef struct H5FD_class_t {
    const char *name;
    haddr_t maxaddr;
    H5F_close_degree_t fc_degree;
    hsize_t (*sb_size)(H5FD_t *file);
    herr_t  (*sb_encode)(H5FD_t *file, char *name(*out*),
                         unsigned char *p(*out*));
    herr_t  (*sb_decode)(H5FD_t *f, const char *name, const unsigned char *p);
    size_t  fapl_size;
    void *  (*fapl_get)(H5FD_t *file);
    void *  (*fapl_copy)(const void *fapl);
    herr_t  (*fapl_free)(void *fapl);
    size_t  dxpl_size;
    void *  (*dxpl_copy)(const void *dxpl);
    herr_t  (*dxpl_free)(void *dxpl);
    H5FD_t *(*open)(const char *name, unsigned flags, hid_t fapl,
                    haddr_t maxaddr);
    herr_t  (*close)(H5FD_t *file);
    int     (*cmp)(const H5FD_t *f1, const H5FD_t *f2);
    herr_t  (*query)(const H5FD_t *f1, unsigned long *flags);
    haddr_t (*alloc)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id, hsize_t size);
    herr_t  (*free)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id,
                    haddr_t addr, hsize_t size);
    haddr_t (*get_eoa)(H5FD_t *file);
    herr_t  (*set_eoa)(H5FD_t *file, haddr_t addr);
    haddr_t (*get_eof)(H5FD_t *file);
    herr_t  (*get_handle)(H5FD_t *file, hid_t fapl, void**file_handle);
    herr_t  (*read)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl,
                    haddr_t addr, size_t size, void *buffer);
    herr_t  (*write)(H5FD_t *file, H5FD_mem_t type, hid_t dxpl,
                     haddr_t addr, size_t size, const void *buffer);
    herr_t  (*flush)(H5FD_t *file, hid_t dxpl_id, unsigned closing);
    herr_t  (*lock)(H5FD_t *file, unsigned char *oid, unsigned lock_type, hbool_t last);
    herr_t  (*unlock)(H5FD_t *file, unsigned char *oid, hbool_t last);
    H5FD_mem_t fl_map[H5FD_MEM_NTYPES];
} H5FD_class_t;

(* A free list is a singly-linked list of address/size pairs. *)
typedef struct H5FD_free_t {
    haddr_t		addr;
    hsize_t		size;
    struct H5FD_free_t	*next;
} H5FD_free_t;

(*
 * The main datatype for each driver. Public fields common to all drivers
 * are declared here and the driver appends private fields in memory.
 *)
struct H5FD_t {
    hid_t               driver_id;      (*driver ID for this file   *)
    const H5FD_class_t *cls;            (*constant class info       *)
    unsigned long       fileno[2];      (* File serial number       *)
    unsigned long       feature_flags;  (* VFL Driver feature Flags *)
    hsize_t             threshold;      (* Threshold for alignment  *)
    hsize_t             alignment;      (* Allocation alignment     *)
    hsize_t             reserved_alloc; (* Space reserved for later alloc calls *)

    (* Metadata aggregation fields *)
    hsize_t             def_meta_block_size;  (* Metadata allocation
                                               * block size (if
                                               * aggregating metadata) *)
    hsize_t             cur_meta_block_size;  (* Current size of metadata
                                               * allocation region left *)
    haddr_t             eoma;                 (* End of metadata
                                               * allocated region *)

    (* "Small data" aggregation fields *)
    hsize_t             def_sdata_block_size;   (* "Small data"
                                                 * allocation block size
                                                 * (if aggregating "small
                                                 * data") *)
    hsize_t             cur_sdata_block_size;   (* Current size of "small
                                                 * data" allocation
                                                 * region left *)
    haddr_t             eosda;                  (* End of "small data"
                                                 * allocated region *)

    (* Metadata accumulator fields *)
    unsigned char      *meta_accum;     (* Buffer to hold the accumulated metadata *)
    haddr_t             accum_loc;      (* File location (offset) of the
                                         * accumulated metadata *)
    size_t              accum_size;     (* Size of the accumulated
                                         * metadata buffer used (in
                                         * bytes) *)
    size_t              accum_buf_size; (* Size of the accumulated
                                         * metadata buffer allocated (in
                                         * bytes) *)
    unsigned            accum_dirty;    (* Flag to indicate that the
                                         * accumulated metadata is dirty *)
    haddr_t             maxaddr;        (* For this file, overrides class *)
    H5FD_free_t        *fl[H5FD_MEM_NTYPES]; (* Freelist per allocation type *)
    hsize_t             maxsize;        (* Largest object on FL, or zero *)
};

#ifdef __cplusplus
extern "C" {
#endif

(* Function prototypes *)
H5_DLL hid_t H5FDregister(const H5FD_class_t *cls);
H5_DLL herr_t H5FDunregister(hid_t driver_id);
H5_DLL H5FD_t *H5FDopen(const char *name, unsigned flags, hid_t fapl_id,
                        haddr_t maxaddr);
H5_DLL herr_t H5FDclose(H5FD_t *file);
H5_DLL int H5FDcmp(const H5FD_t *f1, const H5FD_t *f2);
H5_DLL int H5FDquery(const H5FD_t *f, unsigned long *flags);
H5_DLL haddr_t H5FDalloc(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id, hsize_t size);
H5_DLL herr_t H5FDfree(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id,
                       haddr_t addr, hsize_t size);
H5_DLL haddr_t H5FDrealloc(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id,
                           haddr_t addr, hsize_t old_size, hsize_t new_size);
H5_DLL haddr_t H5FDget_eoa(H5FD_t *file);
H5_DLL herr_t H5FDset_eoa(H5FD_t *file, haddr_t eof);
H5_DLL haddr_t H5FDget_eof(H5FD_t *file);
H5_DLL herr_t H5FDget_vfd_handle(H5FD_t *file, hid_t fapl, void**file_handle);
H5_DLL herr_t H5FDread(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id,
                       haddr_t addr, size_t size, void *buf(*out*));
H5_DLL herr_t H5FDwrite(H5FD_t *file, H5FD_mem_t type, hid_t dxpl_id,
                        haddr_t addr, size_t size, const void *buf);
H5_DLL herr_t H5FDflush(H5FD_t *file, hid_t dxpl_id, unsigned closing);

#ifdef __cplusplus
}
#endif
#endif

{H5Ppublic.H}

(* Default Template for creation, access, etc. templates *)
Const
  H5P_DEFAULT=0;

(* Public headers needed by this file *)
(*
#include "H5public.h"
#include "H5Ipublic.h"
#include "H5Dpublic.h"
#include "H5Fpublic.h"
#include "H5FDpublic.h"
#include "H5MMpublic.h"
#include "H5Zpublic.h"
*)
type
 off_t=integer;

(* Define property list class callback function pointer types *)
type
  H5P_cls_create_func_t= function(prop_id: hid_t;var create_data):herr_t;cdecl;

  H5P_cls_copy_func_t = function (new_prop_id:hid_t ; old_prop_id:hid_t; var copy_data):herr_t ;
  H5P_cls_close_func_t= function (prop_id:hid_t ; var close_data: pointer):herr_t;

(* Define property list callback function pointer types *)
  H5P_prp_cb1_t= function (name: Pchar; size:  size_t; var value:pointer):herr_t ;
  H5P_prp_cb2_t= function (prop_id:hid_t ; name:Pchar; size:size_t;var value):herr_t;

  H5P_prp_create_func_t = H5P_prp_cb1_t;
  H5P_prp_set_func_t = H5P_prp_cb2_t;
  H5P_prp_get_func_t = H5P_prp_cb2_t;
  H5P_prp_delete_func_t = H5P_prp_cb2_t;
  H5P_prp_copy_func_t = H5P_prp_cb1_t;

  H5P_prp_compare_func_t= function(var value1;var value2; size:size_t):integer;
  H5P_prp_close_func_t = H5P_prp_cb1_t;

(* Define property list iteration function type *)
  H5P_iterate_t = function( id:hid_t; name:Pchar;var iter_data):herr_t;


(* Public functions *)

var

H5Pcreate_class: function(parent:hid_t ; name:Pchar;
                cls_create:H5P_cls_create_func_t ; create_data: pointer;
                cls_copy:H5P_cls_copy_func_t ; copy_data:pointer;
                cls_close:H5P_cls_close_func_t ; close_data:pointer):hid_t ;

H5Pget_class_name: function(pclass_id:hid_t ):Pchar;
H5Pcreate: function(cls_id:hid_t ):hid_t ;

H5Pregister: function(cls_id:hid_t ; name:Pchar; size:size_t ;
            def_value:pointer; prp_create:H5P_prp_create_func_t ;
            prp_set:H5P_prp_set_func_t ;prp_get: H5P_prp_get_func_t  ;
            prp_del:H5P_prp_delete_func_t ;
            prp_copy:H5P_prp_copy_func_t ;
            prp_close:H5P_prp_close_func_t ):herr_t ;

H5Pinsert: function(plist_id:hid_t ; name:Pchar; size:size_t ;
            value:pointer; prp_set:H5P_prp_set_func_t ; prp_get:H5P_prp_get_func_t ;
            prp_delete:H5P_prp_delete_func_t ;
            prp_copy:H5P_prp_copy_func_t ;
            prp_close:H5P_prp_close_func_t ):herr_t ;

H5Pset: function(plist_id: hid_t ; name:Pchar; value:pointer):herr_t ;
H5Pexist: function(plist_id: hid_t ; name: Pchar):htri_t ;
H5Pget_size: function(id: hid_t ; name:Pchar; size: size_t):herr_t ;
H5Pget_nprops: function(id: hid_t ; var  nprops:size_t):herr_t ;
H5Pget_class: function( plist_id:hid_t):hid_t ;
H5Pget_class_parent: function(pclass_id:hid_t ):hid_t ;
H5Pget: function(plist_id: hid_t ; name:Pchar; value:pointer):herr_t ;
H5Pequal: function(id1: hid_t ;  id2:hid_t):htri_t ;
H5Pisa_class: function(plist_id: hid_t ;  pclass_id: hid_t):htri_t ;
H5Piterate: function(id: hid_t ;var idx: integer; iter_func: H5P_iterate_t ;iter_data:pointer):integer ;

H5Pcopy_prop: function(dst_id: hid_t ; src_id: hid_t ; name:Pchar):herr_t ;
H5Premove: function(plist_id: hid_t ; name:Pchar):herr_t ;
H5Punregister: function(pclass_id: hid_t ; name:Pchar):herr_t ;
H5Pclose_class: function( plist_id:hid_t):herr_t ;
H5Pclose: function( plist_id: hid_t):herr_t ;
H5Pcopy: function(plist_id:hid_t ):hid_t ;

H5Pget_version: function(plist_id: hid_t ; var boot,freelist, stab,shhdr: longword):herr_t ;
H5Pset_userblock: function(plist_id: hid_t ;  size:hsize_t):herr_t ;
H5Pget_userblock: function( plist_id:hid_t; var size:hsize_t):herr_t ;
H5Pset_alignment: function(fapl_id: hid_t ; threshold: hsize_t ; alignment:hsize_t):herr_t ;

H5Pget_alignment: function(fapl_id: hid_t ; var threshold: hsize_t ;var alignment:hsize_t):herr_t ;
H5Pset_sizes: function(plist_id: hid_t ;  sizeof_addr: size_t;  sizeof_size: size_t):herr_t ;
H5Pget_sizes: function(plist_id: hid_t ; var sizeof_addr: size_t ; var sizeof_size:size_t):herr_t ;

H5Pset_sym_k: function(plist_id: hid_t ; ik,lk:longword):herr_t ;
H5Pget_sym_k: function(plist_id: hid_t ;var ik, lk: longword):herr_t ;

H5Pset_istore_k: function(plist_id: hid_t ; ik:longword):herr_t ;
H5Pget_istore_k: function(plist_id: hid_t ;var ik:longword):herr_t ;
H5Pset_layout: function(plist_id: hid_t ;  layout:H5D_layout_t):herr_t ;

H5Pget_layout: function( plist_id:hid_t):H5D_layout_t ;

H5Pset_chunk: function(plist_id: hid_t ; ndims: integer ; var dim: hsize_t ):herr_t ;
H5Pget_chunk: function(plist_id:hid_t ; max_ndims:integer ; var dim:hsize_t):integer ;
H5Pset_external: function(plist_id:hid_t ; name:Pchar; offset:off_t ;size:hsize_t):herr_t ;
H5Pget_external_count: function(plist_id:hid_t ):integer ;
H5Pget_external: function(plist_id:hid_t ; idx:longword; name_size:size_t ;
          name:Pchar;var offset: off_t;  var size:hsize_t):herr_t ;
H5Pset_driver: function(plist_id:hid_t ; driver_id:hid_t ;driver_info:pointer):herr_t ;
H5Pget_driver: function(plist_id:hid_t ):hid_t ;

H5Pget_driver_info: function(plist_id:hid_t ):pointer;
H5Pset_family_offset: function(fapl_id:hid_t ;  offset:hsize_t):herr_t ;
H5Pget_family_offset: function(fapl_id:hid_t ;  var offset:hsize_t):herr_t ;
H5Pset_multi_type: function(fapl_id:hid_t ; tp:H5FD_mem_t ):herr_t ;
H5Pget_multi_type: function(fapl_id:hid_t ; var tp:H5FD_mem_t ):herr_t ;

H5Pset_buffer: function(plist_id:hid_t ; size:size_t ; tconv:pointer;bkg:pointer):herr_t ;
H5Pget_buffer: function(plist_id:hid_t ; var tconv:pointer;var bkg:pointer):size_t ;

H5Pset_preserve: function(plist_id:hid_t ;  status:hbool_t):herr_t ;
H5Pget_preserve: function( plist_id:hid_t):int ;
H5Pmodify_filter: function(plist_id:hid_t ; filter:H5Z_filter_t ;flags:longword; cd_nelmts:size_t ;var cd_values:longword):herr_t ;

H5Pset_filter: function(plist_id:hid_t ; filter:H5Z_filter_t ; flags:longword; cd_nelmts:size_t ; var c_values:longword):herr_t ;
H5Pget_nfilters: function( plist_id:hid_t):integer ;
H5Pget_filter: function(plist_id:hid_t ; filter:longword,
       var flags:longword,
       var cd_nelmts:size_t ;
       var cd_values:longword ;
       namelen:size_t ; name:Pchar):H5Z_filter_t ;

H5Pget_filter_by_id: function(hid_t plist_id, H5Z_filter_t id,
       unsigned int *flags(*out*),
       size_t *cd_nelmts(*out*),
       unsigned cd_values[](*out*),
       size_t namelen, char name[]):H5Z_filter_t ;

H5Pall_filters_avail: function(hid_t plist_id):htri_t ;
H5Pset_deflate: function(hid_t plist_id, unsigned aggression):herr_t ;
H5Pset_szip: function(hid_t plist_id, unsigned options_mask, unsigned pixels_per_block):herr_t ;
H5Pset_shuffle: function(hid_t plist_id):herr_t ;
H5Pset_fletcher32: function(hid_t plist_id):herr_t ;
H5Pset_edc_check: function(hid_t plist_id, H5Z_EDC_t check):herr_t ;
H5Pget_edc_check: function(hid_t plist_id):H5Z_EDC_t ;
H5Pset_filter_callback: function(hid_t plist_id, H5Z_filter_func_t func,void* op_data):herr_t ;

H5Pset_cache: function(hid_t plist_id, int mdc_nelmts, size_t rdcc_nelmts,size_t rdcc_nbytes, double rdcc_w0):herr_t ;
H5Pget_cache: function(hid_t plist_id, int *mdc_nelmts(*out*),
       size_t *rdcc_nelmts(*out*),
       size_t *rdcc_nbytes(*out*), double *rdcc_w0):herr_t ;


H5Pset_btree_ratios: function(hid_t plist_id, double left, double middle,double right):herr_t ;

H5Pget_btree_ratios: function(hid_t plist_id, double *left(*out*),
       double *middle(*out*),
       double *right(*out*)):herr_t ;

H5Pset_fill_value: function(hid_t plist_id, hid_t type_id, const void *value):herr_t ;
H5Pget_fill_value: function(hid_t plist_id, hid_t type_id,void *value(*out*)):herr_t ;
H5Pfill_value_defined: function(hid_t plist, H5D_fill_value_t *status):herr_t ;
H5Pset_alloc_time: function(hid_t plist_id, H5D_alloc_time_t alloc_time):herr_t ;
H5Pget_alloc_time: function(hid_t plist_id, H5D_alloc_time_t *alloc_time(*out*)):herr_t ;
H5Pset_fill_time: function(hid_t plist_id, H5D_fill_time_t fill_time):herr_t ;
H5Pget_fill_time: function(hid_t plist_id, H5D_fill_time_t	*fill_time(*out*)):herr_t ;
H5Pset_gc_references: function(hid_t fapl_id, unsigned gc_ref):herr_t ;
H5Pget_gc_references: function(hid_t fapl_id, unsigned *gc_ref(*out*)):herr_t ;
H5Pset_fclose_degree: function(hid_t fapl_id, H5F_close_degree_t degree):herr_t ;
H5Pget_fclose_degree: function(hid_t fapl_id, H5F_close_degree_t *degree):herr_t ;
H5Pset_vlen_mem_manager: function(hid_t plist_id,
                                       H5MM_allocate_t alloc_func,
                                       void *alloc_info, H5MM_free_t free_func,
                                       void *free_info):herr_t ;
H5Pget_vlen_mem_manager: function(hid_t plist_id,
                                       H5MM_allocate_t *alloc_func,
                                       void **alloc_info,
                                       H5MM_free_t *free_func,
                                       void **free_info):herr_t ;
H5Pset_meta_block_size: function(hid_t fapl_id, hsize_t size):herr_t ;
H5Pget_meta_block_size: function(hid_t fapl_id, hsize_t *size(*out*)):herr_t ;

H5Pset_sieve_buf_size: function(hid_t fapl_id, size_t size):herr_t ;
H5Pget_sieve_buf_size: function(hid_t fapl_id, size_t *size(*out*)):herr_t ;

H5Pset_hyper_vector_size: function(hid_t fapl_id, size_t size):herr_t ;
H5Pget_hyper_vector_size: function(hid_t fapl_id, size_t *size(*out*)):herr_t ;
H5Pset_small_data_block_size: function(hid_t fapl_id, hsize_t size):herr_t ;
H5Pget_small_data_block_size: function(hid_t fapl_id, hsize_t *size(*out*)):herr_t ;
H5Premove_filter: function(hid_t plist_id, H5Z_filter_t filter):herr_t ;




function InitHDF5:boolean;
procedure freeHDF5;

implementation

uses windows,math,util1,ncdef2;

var
  hh:integer;


function getProc(hh:Thandle;st:string):pointer;
begin
  result:=GetProcAddress(hh,Pchar(st));
  if result=nil then messageCentral(st+'=nil');
               {else messageCentral(st+' OK');}
end;

function InitHDF5:boolean;
begin
  result:=true;
  if hh<>0 then exit;

  hh:=GloadLibrary(DLLname);

  result:=(hh<>0);
  if not result then exit;

  H5open:=getProc(hh,'H5open');
  H5close:=getProc(hh,'H5close');
  H5dont_atexit:=getProc(hh,'H5dont_atexit');
  H5garbage_collect:=getProc(hh,'H5garbage_collect');
  H5set_free_list_limits:=getProc(hh,'H5set_free_list_limits');
  H5get_libversion:=getProc(hh,'H5get_libversion');
  H5check_version:=getProc(hh,'H5check_version');

  H5Iget_type:=getProc(hh,'H5Iget_type');
  H5Iget_file_id:=getProc(hh,'H5Iget_file_id');
  H5Iget_name:=getProc(hh,'H5Iget_name');
  H5Iinc_ref:=getProc(hh,'H5Iinc_ref');
  H5Idec_ref:=getProc(hh,'H5Idec_ref');
  H5Iget_ref:=getProc(hh,'H5Iget_ref');

  H5Fis_hdf5:=getProc(hh,'H5Fis_hdf5');
  H5Fcreate:=getProc(hh,'H5Fcreate');
  H5Fopen:=getProc(hh,'H5Fopen');
  H5Freopen:=getProc(hh,'H5Freopen');
  H5Fflush:=getProc(hh,'H5Fflush');
  H5Fclose:=getProc(hh,'H5Fclose');
  H5Fget_create_plist:=getProc(hh,'H5Fget_create_plist');
  H5Fget_access_plist:=getProc(hh,'H5Fget_access_plist');
  H5Fget_obj_count:=getProc(hh,'H5Fget_obj_count');
  H5Fget_obj_ids:=getProc(hh,'H5Fget_obj_ids');
  H5Fget_vfd_handle:=getProc(hh,'H5Fget_vfd_handle');
  H5Fmount:=getProc(hh,'H5Fmount');
  H5Funmount:=getProc(hh,'H5Funmount');
  H5Fget_freespace:=getProc(hh,'H5Fget_freespace');
  H5Fget_filesize:=getProc(hh,'H5Fget_filesize');
  H5Fget_name:=getProc(hh,'H5Fget_name');

end;


procedure freeHDF5;
begin
  if hh<>0 then freeLibrary(hh);
  hh:=0;
end;


procedure HDF5test;
begin
  if not initHDF5 then sortieErreur('unable to initialize HDF5 library');
end;

Initialization
AffDebug('Initialization hdf5',0);

finalization
freeHDF5;

end.
