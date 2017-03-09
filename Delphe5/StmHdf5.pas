unit StmHdf5;

interface

uses strUtils,
     util1, stmObj, hdf5dll, hdf5_lite,
     stmPG, ncdef2, stmvec1;

type
  Thdf5file = class(typeUO)
              private
                fileName:AnsiString;
                fileID : integer;
              public
                constructor create;override;
                destructor destroy;override;

                class function STMClassName:AnsiString;override;

                procedure OpenFile(stf: AnsiString);
                function getString(id: AnsiString; var error:integer): AnsiString;
                function getInt(id: AnsiString; var error:integer): int64;
                function getReal(id: AnsiString; var error:integer): float;


                procedure getVector(id:AnsiString; vec: Tvector; var error:integer);
                procedure getAttributeVector(id:AnsiString; vec: Tvector; var error:integer);
                procedure getDataSetInfo(id:AnsiString; vec: Tvector; var tp: typetypeG; var tpSize, error:integer);
              end;


procedure proThdf5File_OpenFile(stFile:AnsiString;var pu:typeUO);pascal;

function fonctionThdf5file_getString(id: AnsiString; var error:integer; var pu: typeUO): AnsiString;pascal;
function fonctionThdf5file_getString_1(id: AnsiString; var pu: typeUO): AnsiString;pascal;

function fonctionThdf5file_getInt(id: AnsiString; var error:integer; var pu: typeUO): int64;pascal;
function fonctionThdf5file_getInt_1(id: AnsiString; var pu: typeUO): int64;pascal;

function fonctionThdf5file_getReal(id: AnsiString; var error:integer; var pu: typeUO): double;pascal;
function fonctionThdf5file_getReal_1(id: AnsiString; var pu: typeUO): double;pascal;

procedure proThdf5file_getVector(id: AnsiString; var vec: Tvector; var error:integer; var pu: typeUO);pascal;
procedure proThdf5file_getVector_1(id: AnsiString; var vec: Tvector; var pu: typeUO);pascal;

procedure proThdf5file_getDataSetInfo(id:AnsiString; var vec: Tvector; var tp, tpSize, error:integer; var pu:typeUO);pascal;
procedure proThdf5file_getDataSetInfo_1(id:AnsiString; var vec: Tvector; var tp, tpSize:integer; var pu:typeUO);pascal;

implementation

{ Thdf5file }

constructor Thdf5file.create;
begin
  inherited;
  if not InitHdf5 or not InitHdf5_lite
    then sortieErreur('Hdf5 library not loaded');


end;

destructor Thdf5file.destroy;
var
  status: integer;
begin
  if fileID>0 then
    status := hdf5.H5Fclose(fileID);

  inherited;
end;

procedure SplitID( st:AnsiString; var st1,st2: AnsiString);
var
  k1,k2: integer;
begin
  k1:=0;
  repeat
    k2:=posEx('/',st,k1+1);
    if k2>0 then k1:=k2;
  until k2=0;

  st1:=copy(st,1,k1);
  st2:=copy(st,k1+1,length(st));
end;

function Thdf5file.getInt(id: AnsiString; var error:integer): int64;
var
  st,st1,st2: AnsiString;
  dims: array[1..100] of hsize_t;
  type_class: H5T_class_t;
  type_size: size_t;

  buf: array[1..32] of int64;

  rank:integer;
begin
  splitID(id,st1,st2);

  error:= H5LTget_attribute_ndims( fileId, @st1[1],@st2[1], rank);
  if (rank<>0) then error:= -1001;
  if (error<0) then exit;

  error:= H5LTget_attribute_info( fileID,@st1[1],@st2[1],@dims, type_class, type_size);

  if (error>=0) and (type_class=H5T_integer)  then
  begin
    error:= H5LTget_attribute( fileId, @st1[1],@st2[1], hdf5.H5T_STD_I64LE , @buf );
    if error>=0 then result:= buf[1];
  end;

end;


function Thdf5file.getReal(id: AnsiString; var error:integer): float;
var
  st,st1,st2: AnsiString;
  dims: hsize_t;
  type_class: H5T_class_t;
  mem_type_id: hid_t;
  type_size: size_t;
  ss: single;
  dd: double;
  rank: integer;

begin
  splitID(id,st1,st2);

  error:= H5LTget_attribute_ndims( fileId, @st1[1],@st2[1], rank);
  if (rank<>0) then error:= -1001;
  if (error<0) then exit;

  error:= H5LTget_attribute_info( fileID,@st1[1],@st2[1],@dims, type_class, type_size);
  if (error>=0) and (type_class=H5T_float) then
  begin
    case type_size of
      4: begin
           error:= H5LTget_attribute_float(fileID,@st1[1],@st2[1] ,@ss);
           if error>=0 then result:=ss;
         end;
      8: begin
           error:= H5LTget_attribute_double(fileID,@st1[1],@st2[1] ,@dd);
           if error>=0 then result:=dd;
         end;
      else error:=-1000;
    end;
  end;
end;

function Thdf5file.getString(id: AnsiString; var error:integer): AnsiString;
var
  st,st1,st2: AnsiString;
  dims: hsize_t;
  type_class: H5T_class_t;
  type_size: size_t;
begin
  splitID(id,st1,st2);

  error:= H5LTget_attribute_info( fileID,@st1[1],@st2[1], @dims, type_class, type_size);
  if (error>=0) and (type_class=H5T_string) then
  begin
    setLength(st,type_size);
    error:= H5LTget_attribute_string(fileID,@st1[1],@st2[1] ,@st[1]);
    result:=st;
  end;

end;



procedure Thdf5file.getVector(id: AnsiString; vec: Tvector; var error: integer);
var
  st,st1,st2: AnsiString;
  dims: array[1..100] of hsize_t;
  type_class: H5T_class_t;
  type_size: size_t;
  rank: integer;

  bufI: array of integer;
  bufD: array of double;
  i:integer;
  Ntot: integer;
begin
  error:=  H5LTget_dataset_ndims(fileId,@id[1], rank);

  if (error=0)  then
  begin
    error:= H5LTget_dataset_info( fileId, @id[1], @dims, type_class, type_size);
    if error>=0 then
    begin
      Ntot:=1;
      for i:= 1 to rank do Ntot:= Ntot*dims[i];

      case type_Class of
        h5t_integer :
          begin
            if type_size<=2 then
             begin
               vec.modify(g_smallint,1, Ntot);
               error:= H5LTread_dataset( fileid, @id[1], hdf5.H5T_STD_U16LE, vec.tb);
             end
            else
             begin
               vec.modify(g_longint,1, Ntot);
               error:= H5LTread_dataset( fileid, @id[1], hdf5.H5T_STD_U32LE, vec.tb);
             end;
          end;
        h5t_float :
          begin
            if type_size<=4 then
            begin
              vec.modify(g_single,1, Ntot);
              error:= H5LTread_dataset( fileid, @id[1], hdf5.H5T_IEEE_F32LE, vec.tb);
            end
            else
            begin
              vec.modify(g_double,1, Ntot);
              error:= H5LTread_dataset( fileid, @id[1], hdf5.H5T_IEEE_F64LE, vec.tb);
            end;
          end;
        else error:=-1000;
      end;
    end;

  end;
end;

procedure Thdf5file.getAttributeVector(id: AnsiString; vec: Tvector;  var error: integer);
var
  st,st1,st2: AnsiString;
  dims: array[1..100] of hsize_t;
  type_class: H5T_class_t;
  type_size: size_t;
  rank: integer;

  bufI: array of integer;
  bufD: array of double;
  i:integer;
  Ntot: integer;
begin
  splitID(id,st1,st2);
  error:=  H5LTget_Attribute_ndims(fileId,@st1[1],@st2[1], rank);

  if (error=0)  then
  begin
    error:= H5LTget_Attribute_info( fileId, @st1[1],@st2[1], @dims, type_class, type_size);
    if error>=0 then
    begin
      Ntot:=1;
      for i:= 1 to rank do Ntot:= Ntot*dims[i];

      case type_Class of
        h5t_integer :
          begin
            if type_size<=2 then
             begin
               vec.modify(g_smallint,1, Ntot);
               error:= H5LTget_attribute( fileid,  @st1[1],@st2[1], hdf5.H5T_STD_U16LE, vec.tb);
             end
            else
             begin
               vec.modify(g_longint,1, Ntot);
               error:= H5LTget_attribute( fileid,  @st1[1],@st2[1], hdf5.H5T_STD_U32LE, vec.tb);
             end;
          end;
        h5t_float :
          begin
            if type_size<=4 then
            begin
              vec.modify(g_single,1, Ntot);
              error:= H5LTget_attribute( fileid,  @st1[1],@st2[1], hdf5.H5T_IEEE_F32LE, vec.tb);
            end
            else
            begin
              vec.modify(g_double,1, Ntot);
              error:= H5LTget_attribute( fileid,  @st1[1],@st2[1], hdf5.H5T_IEEE_F64LE, vec.tb);
            end;
          end;
        else error:=-1000;
      end;
    end;

  end;
end;




procedure Thdf5file.getDataSetInfo(id:AnsiString; vec: Tvector; var tp: typetypeG; var tpSize, error:integer);
var
  dims: array[1..100] of hsize_t;
  type_class: H5T_class_t;
  type_size: size_t;
  rank: integer;
  i: integer;
begin
  rank:=0;
  tpSize:=0;

  error:=  H5LTget_dataset_ndims(fileId,@id[1], rank);

  if (error=0) then
  begin
    error:= H5LTget_dataset_info( fileId, @id[1], @dims, type_class, type_size);

    vec.initList(g_longint);
    for i:=1 to rank do
      vec.addtoList(integer(dims[i]));              // sans le type cast , Delphi 7 fait n'importe quoi: conversion int64--> integer!

    case type_Class of
      h5t_integer :
        begin
          if type_size<=2 then tp:= g_smallint
          else
          if type_size<=4 then tp:= g_longint
          else
          tp:= g_int64;
        end;
      h5t_float :
        begin
          if type_size<=4 then tp:=g_single
          else
          tp:=g_double;
        end;
      else tp:=g_none;
    end;

    tpSize:=type_size;
  end;
end;

procedure Thdf5file.OpenFile(stf: AnsiString);
begin
   fileID := hdf5.H5Fopen(@stf[1], H5F_ACC_RDONLY, H5P_DEFAULT);
   if fileID>0 then fileName:= stf else fileName:='';


end;

class function Thdf5file.STMClassName: AnsiString;
begin
  result:= 'Hdf5file';
end;

//*****************************************************************************


procedure proThdf5File_OpenFile(stFile:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,Thdf5File);

  with Thdf5File(pu) do
  begin
    OpenFile(stFile);
    if fileID=0 then
      begin
        proTobject_free(pu);
        sortieErreur('Thdf5File.OpenFile : unable to open hdf5 file');
      end;
  end;
end;

function fonctionThdf5file_getString(id: AnsiString;var error:integer; var pu: typeUO): AnsiString;
begin
  verifierObjet(pu);
  result:= Thdf5File(pu).getString(id,error);
end;

function fonctionThdf5file_getString_1(id: AnsiString; var pu: typeUO): AnsiString;
var
  error: integer;
begin
  result:= fonctionThdf5file_getString(id, error, pu);
  if error<0 then sortieErreur('Thdf5file.getString : error = '+Istr(error));
end;


function fonctionThdf5file_getInt(id: AnsiString; var error:integer; var pu: typeUO): int64;
begin
  verifierObjet(pu);
  result:= Thdf5File(pu).getInt(id,error);
end;

function fonctionThdf5file_getInt_1(id: AnsiString; var pu: typeUO): int64;
var
  error: integer;
begin
  result:= fonctionThdf5file_getInt(id, error, pu);
  if error<>0 then sortieErreur('Thdf5file.getInt : error = '+Istr(error));
end;

function fonctionThdf5file_getReal(id: AnsiString; var error:integer;var pu: typeUO): double;
begin
  verifierObjet(pu);
  result:= Thdf5File(pu).getReal(id,error);
end;

function fonctionThdf5file_getReal_1(id: AnsiString; var pu: typeUO): double;
var
  error: integer;
begin
  result:= fonctionThdf5file_getReal(id, error, pu);
  if error<>0 then sortieErreur('Thdf5file.getReal : error = '+Istr(error));
end;

procedure proThdf5file_getVector(id: AnsiString; var vec: Tvector;var error: integer; var pu: typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));
  Thdf5File(pu).getVector(id,vec,error);
  if error<0 then Thdf5File(pu).getAttributeVector(id,vec,error);
end;

procedure proThdf5file_getVector_1(id: AnsiString; var vec: Tvector; var  pu: typeUO);
var
  error: integer;
begin
  proThdf5file_getVector(id, vec, error,pu);
  if error<0 then sortieErreur('Thdf5file. getVector : error ='+Istr(error));
end;

procedure proThdf5file_getDataSetInfo(id:AnsiString; var vec: Tvector; var tp, tpSize, error:integer; var pu:typeUO);
var
  tp1: typetypeG;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));
  Thdf5file(pu).getDataSetInfo(id, vec, tp1, tpSize, error);
  tp:=ord(tp1);
end;

procedure proThdf5file_getDataSetInfo_1(id:AnsiString; var vec: Tvector; var tp, tpSize:integer; var pu:typeUO);
var
  error:integer;
begin
  proThdf5file_getDataSetInfo(id, vec, tp, tpSize, error,pu);
  if error<0 then sortieErreur('Thdf5file. getDataSetInfo : error ='+Istr(error));
end;



end.
