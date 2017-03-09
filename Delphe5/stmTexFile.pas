unit stmTexFile;

interface

uses classes,sysutils,graphics,
     util1,Gdos, DibG,
     stmObj,stmPg,stmError,Ncdef2,debug0,
     stmStreamer1,
     stmMat1,
     BMex1;

type
  TtextureFile=class(typeUO)

              private
                fileName:AnsiString;
                Nx,Ny:integer;
                tpNum:typetypeG;
                TexHeader:TtexHeader;
                HeaderSize,ImageSize:integer;
                TexPosition:integer;
              public
                f:TfileStream;
                constructor create;override;
                destructor destroy;override;

                class function STMClassName:AnsiString;override;

                procedure CreateFile(st:AnsiString;Nx1,Ny1:integer; tpNum1:typetypeG);
                procedure OpenFile(st:AnsiString);

                procedure writeImage(stImage:AnsiString;mode:integer);
                procedure writeMatrix(mat: Tmatrix);
                procedure writeBM( bm: TbitmapEx);

                procedure ReadMatrix(mat: Tmatrix);

                function count:integer;
              end;


procedure proTtextureFile_CreateFile(stFile:AnsiString;Nx1,Ny1,tpNum1:integer;var pu:typeUO);pascal;
procedure proTtextureFile_OpenFile(stFile:AnsiString;var pu:typeUO);pascal;
procedure proTtextureFile_Close(var pu:typeUO);pascal;


procedure proTtextureFile_writeImage(stImage:AnsiString;mode: integer;var pu:typeUO);pascal;
procedure proTtextureFile_writeMatrix(var mat: Tmatrix;var pu:typeUO);pascal;
procedure proTtextureFile_ReadMatrix(var mat: Tmatrix;var pu:typeUO);pascal;

function fonctionTtextureFile_count(var pu:typeUO): integer;pascal;
function fonctionTtextureFile_position(var pu:typeUO): integer;pascal;
procedure proTtextureFile_position(n:integer; var pu:typeUO);pascal;

function fonctionTtextureFile_Nx(var pu:typeUO): integer;pascal;
function fonctionTtextureFile_Ny(var pu:typeUO): integer;pascal;
function fonctionTtextureFile_NumType(var pu:typeUO): integer;pascal;


implementation

{ TtextureFile }


constructor TtextureFile.create;
begin
  inherited;
end;

destructor TtextureFile.destroy;
begin
  f.free;
  inherited;
end;


procedure TtextureFile.CreateFile(st:AnsiString;Nx1,Ny1:integer; tpNum1:typetypeG);
var
  TexHeader: TtexHeader;
begin
  try
    Nx:=Nx1;
    Ny:=Ny1;
    tpNum:=tpNum1;

    with TexHeader do
    begin
      ident:=TexHeaderIdent;
      mySize:=sizeof(TexHeader);
      Nx:=Nx1;
      Ny:=Ny1;
      tpNum:=tpNum1;
    end;

    f:=nil;
    f:=TfileStream.Create(st,fmCreate);
    f.Write(TexHeader,sizeof(texHeader));
    fileName:=st;
  except
    f.Free;
    f:=nil;
    fileName:='';
  end;

  HeaderSize:=sizeof(TexHeader);
  ImageSize:=Nx*Ny*TailleTypeG[tpNum];
  TexPosition:=1;
end;

procedure TtextureFile.OpenFile(st: AnsiString);
var
  TexHeader: TtexHeader;
  Nb:integer;
begin
  f:=nil;
  try
    f:=TfileStream.Create(st,fmOpenReadWrite);
    fileName:=st;
  except
    f:=nil;
    fileName:='';
  end;

  if assigned(f) then
  begin
    Nb:= sizeof(texHeader.Ident)+sizeof(texHeader.mySize);
    f.read(texHeader, Nb);

    if TexHeader.ident<>TexHeaderIdent then
    begin
      f.Free;
      f:=nil;
      exit;
    end;

    f.Read(TexHeader.Nx,TexHeader.mySize-Nb);
    Nx:=TexHeader.Nx;
    Ny:=TexHeader.Ny;
    tpNum:=TexHeader.tpNum;
    HeaderSize:=TexHeader.mySize;
    ImageSize:=Nx*Ny*TailleTypeG[tpNum];
    TexPosition:=1;
  end;
end;


class function TtextureFile.STMClassName: AnsiString;
begin
  result:='TexFile';
end;

procedure TtextureFile.writeImage(stImage: AnsiString;mode: integer);
var
  bm:Tdib;
  i,j:integer;
  tb:array of byte;
  p1: PtabOctet;
  colByte:integer;
begin
  colByte:= mode-1;  // mode désigne la composante R , G ou B à utiliser (3, 2 ou 1)

  if tpNum<>g_byte then exit;
  if not assigned(f) then sortieErreur('TtextureFile.writeImage : file not open');

  bm:=Tdib.Create;
  try
    LoadDibFromFile(bm, stImage);
    if (bm.Width<>Nx) or (bm.Height<>Ny) then sortieErreur('TtextureFile.write : bad image size');

    setLength(tb,Nx*Ny);
    for j:= 0 to bm.height-1 do
    begin
      p1:=bm.ScanLine[j];
      for i:= 0 to bm.width-1 do
      begin
        case bm.BitCount of
          8:   tb[i+Nx*j]:= p1^[i];
          24:  tb[i+Nx*j]:= p1^[i*3+colByte] ;
          32:  tb[i+Nx*j]:= p1^[i*4+colByte] ;
        end;
      end;
    end;

    f.Position:=f.Size;       // on écrit forcément à la fin ?
    f.Write(tb[0],Nx*Ny);
  finally
  bm.free;
  end;
end;

procedure TtextureFile.writeMatrix(mat: Tmatrix);
var
  i,j:integer;
  w:integer;
  tb:array of byte;
  tbS:array of single;
begin
  if not assigned(f) then sortieErreur('TtextureFile.writeMatrix : file not open');
  if (mat.Icount<>Nx) or (mat.Jcount<>Ny) then sortieErreur('TtextureFile.write : bad matrix size');

  case tpNum of
    g_byte:   begin
                setLength(tb,Nx*Ny);
                for j:= 0 to Ny-1 do
                for i:= 0 to Nx-1 do
                begin
                  w:= mat.Kvalue[mat.Istart+i,mat.Jstart+j];
                  if w<0 then w:=0
                  else
                  if w>253 then w:=253;
                  tb[i+Nx*j]:= w;
                end;

                f.Position:=f.Size;
                f.Write(tb[0],Nx*Ny);
              end;
    g_single: begin
                setLength(tbS,Nx*Ny);
                for j:= 0 to Ny-1 do
                for i:= 0 to Nx-1 do
                  tbS[i+Nx*j]:=  mat[mat.Istart+i,mat.Jstart+j];

                f.Position:=f.Size;
                f.Write(tbS[0],Nx*Ny*4);
              end;
  end;
end;

procedure TtextureFile.writeBM( bm: TbitmapEx);
var
  i,j:integer;
  tb:array of byte;
  tbS:array of single;
  p2: PtabOctet;
begin
  if not assigned(f) then sortieErreur('TtextureFile.writeMatrix : file not open');
  if (bm.Width<>Nx) or (bm.Height<>Ny) then sortieErreur('TtextureFile.write : bad matrix size');

  case tpNum of
    g_byte:   begin
                setLength(tb,Nx*Ny);
                for j:= 0 to Ny-1 do
                begin
                  p2:=bm.ScanLine[j];
                  for i:=0 to Nx-1 do
                     tb[i+Nx*j]:=p2^[i];
                end;

                f.Position:=f.Size;
                f.Write(tb[0],Nx*Ny);
              end;
    g_single: begin
                setLength(tbS,Nx*Ny);
                for j:= 0 to Ny-1 do
                begin
                  p2:=bm.ScanLine[j];
                  for i:=0 to Nx-1 do
                     tbS[i+Nx*j]:=p2^[i];
                end;

                f.Position:=f.Size;
                f.Write(tbS[0],Nx*Ny*4);
              end;
  end;
end;


procedure TtextureFile.ReadMatrix(mat: Tmatrix);
var
  i,j:integer;
  w:integer;
  tb:array of byte;
  tbS:array of single;
begin
  if (TexPosition<1) or (texPosition>count)
    then sortieErreur('TtextureFile_ReadMatrix : Position out of range');
  if not assigned(f) then sortieErreur('TtextureFile.ReadMatrix : file not open');
  mat.initTemp(0,Nx-1,0,Ny-1,g_single);

  case tpNum of
    g_byte:   begin
                setLength(tb,Nx*Ny);
                f.Position:=HeaderSize+(TexPosition-1)*ImageSize;
                f.Read(tb[0],Nx*Ny);

                for j:= 0 to Ny-1 do
                for i:= 0 to Nx-1 do
                  mat[i,j]:= tb[i+Nx*j];
              end;
    g_single: begin
                setLength(tbS,Nx*Ny);
                f.Position:=HeaderSize+(TexPosition-1)*ImageSize;
                f.Read(tbS[0],Nx*Ny*4);

                for j:= 0 to Ny-1 do
                for i:= 0 to Nx-1 do
                  mat[i,j]:= tbS[i+Nx*j];
              end;
  end;
  inc(TexPosition);
end;


function TtextureFile.count: integer;
begin
  if ImageSize>0
    then result:=(f.Size-HeaderSize) div ImageSize
    else result:=0;
end;

{********************************* Méthodes STM ******************************}

procedure proTtextureFile_CreateFile(stFile:AnsiString;Nx1,Ny1,tpNum1:integer;var pu:typeUO);
begin
  createPgObject('',pu,TtextureFile);

  with TtextureFile(pu) do
  begin
    CreateFile(stFile,Nx1,Ny1,typetypeG(tpNum1));
    if not assigned(f) then
      begin
        proTobject_free(pu);
        sortieErreur('TtextureFile.createFile : unable to create file');
      end;
  end;
end;

procedure proTtextureFile_OpenFile(stFile:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TtextureFile);

  with TtextureFile(pu) do
  begin
    OpenFile(stFile);
    if not assigned(f) then
      begin
        proTobject_free(pu);
        sortieErreur('TtextureFile.OpenFile : unable to open file');
      end;
  end;
end;

function fonctionTtextureFile_Nx(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:=TtextureFile(pu).Nx;
end;

function fonctionTtextureFile_Ny(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:=TtextureFile(pu).Ny;
end;

function fonctionTtextureFile_NumType(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:=ord(TtextureFile(pu).tpNum);
end;


function fonctionTtextureFile_count(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:=TtextureFile(pu).count;
end;

function fonctionTtextureFile_position(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:=TtextureFile(pu).TexPosition;
end;

procedure proTtextureFile_position(n:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  if (n<1) or (n>TtextureFile(pu).count) then sortieErreur('TtextureFile.position : bad parameter');

  TtextureFile(pu).TexPosition:=n;
end;


procedure proTtextureFile_close(var pu:typeUO);
begin
  proTobject_free(pu);
end;


procedure proTtextureFile_writeImage(stImage:AnsiString;mode:integer;var pu:typeUO);
var
  res:integer;
begin
  verifierObjet(pu);
  TtextureFile(pu).WriteImage(stImage,mode);
end;

procedure proTtextureFile_writeMatrix(var mat: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);
  TtextureFile(pu).writeMatrix(mat);
end;

procedure proTtextureFile_ReadMatrix(var mat: Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);
  TtextureFile(pu).readMatrix(mat);
end;



Initialization

registerObject(TtextureFile,sys);

end.
