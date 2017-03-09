unit BinFile1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysutils,
     util1,Gdos,
     stmObj,stmPg,stmError,Ncdef2,debug0;


type
  TbinaryFile=class(typeUO)

              private
                fileName:AnsiString;
              public
                f:TfileStream;
                constructor create;override;
                destructor destroy;override;

                class function STMClassName:AnsiString;override;

                procedure ResetFile(st:AnsiString);
                procedure RewriteFile(st:AnsiString);
                procedure close;

                procedure saveAsSingle(pu:typeUO);
                function loadAsSingle(pu:typeUO):boolean;
                function seek(num:int64):boolean;

                function filePos:int64;
                function fileSize:int64;
              end;


procedure proTbinaryFile_Reset(stFile:AnsiString;var pu:typeUO);pascal;
procedure proTbinaryFile_Rewrite(stFile:AnsiString;var pu:typeUO);pascal;
procedure proTbinaryFile_close(var pu:typeUO);pascal;

function fonctionTbinaryFile_filePos(var pu:typeUO):int64;pascal;
function fonctionTbinaryFile_fileSize(var pu:typeUO):int64;pascal;
procedure proTbinaryFile_seek(num:int64;var pu:typeUO);pascal;

procedure proTbinaryFile_Read(var x;taille:integer;tpn:word;var pu:typeUO);pascal;
procedure proTbinaryFile_write(var x;taille:integer;tpn:word;var pu:typeUO);pascal;

procedure proTbinaryFile_BlockRead(var x;taille:integer;tpn:word;off,nb:integer;
                    var pu:typeUO);pascal;
procedure proTbinaryFile_Blockwrite(var x;taille:integer;tpn:word;off,nb:integer;
                    var pu:typeUO);pascal;


procedure proTbinaryFile_CopyFrom(var binF:TbinaryFile;nb:int64;var pu:typeUO);pascal;

function fonctionDeleteFile(FileName: AnsiString): Boolean;pascal;

implementation


{ TbinaryFile }

procedure TbinaryFile.close;
begin
  f.free;
  f:=nil;
end;

constructor TbinaryFile.create;
begin
  inherited;

end;

destructor TbinaryFile.destroy;
begin
  f.free;
  inherited;
end;

function TbinaryFile.filePos: int64;
begin
  if assigned(f)
    then result:=f.Position
    else result:=-1;
end;

function TbinaryFile.fileSize: int64;
begin
  if assigned(f)
    then result:=f.Size
    else result:=-1;
end;


procedure TbinaryFile.ResetFile(st: AnsiString);
begin
  try
    f:=TfileStream.Create(st,fmOpenReadWrite);
    fileName:=st;
  except
    try
      f:=TfileStream.Create(st,fmOpenRead);
      fileName:=st;
    except
      f:=nil;
      fileName:='';
    end;  
  end;
end;

procedure TbinaryFile.RewriteFile(st: AnsiString);
begin
  try
    f:=TfileStream.Create(st,fmCreate);
    fileName:=st;
  except
    f:=nil;
    fileName:='';
  end;
end;

procedure TbinaryFile.saveAsSingle(pu: typeUO);
begin
  pu.saveAsSingle(f);
end;

function TbinaryFile.loadAsSingle(pu: typeUO): boolean;
begin
  result:=pu.loadAsSingle(f);
end;


function TbinaryFile.seek(num: int64): boolean;
begin
  try
    if assigned(f) then
    begin
      f.position:=num;
      result:=true;
    end
    else result:=false;
  except
    result:=false;
  end;
end;

class function TbinaryFile.STMClassName: AnsiString;
begin
  result:='BinaryFile';
end;

{********************************* Méthodes STM ******************************}

var
  E_resetFile:integer;
  E_rewriteFile:integer;
  E_seek:integer;
  E_filePos:integer;
  E_fileSize:integer;
  E_block:integer;

procedure proTbinaryFile_Reset(stFile:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TbinaryFile);

  with TbinaryFile(pu) do
  begin
    ResetFile(stFile);
    if not assigned(f) then
      begin
        proTobject_free(pu);
        sortieErreur(E_Resetfile);
      end;
  end;
end;

procedure proTbinaryFile_Rewrite(stFile:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TbinaryFile);

  with TbinaryFile(pu) do
  begin
    RewriteFile(stFile);
    if not assigned(f) then
      begin
        proTobject_free(pu);
        sortieErreur(E_Rewritefile);
      end;
  end;
end;

procedure proTbinaryFile_close(var pu:typeUO);
begin
  proTobject_free(pu);
end;

function fonctionTbinaryFile_filePos(var pu:typeUO):int64;
begin
  verifierObjet(pu);
  result:=TbinaryFile(pu).filePos;
  if result<0 then sortieErreur(E_filePos);
end;

function fonctionTbinaryFile_fileSize(var pu:typeUO):int64;
begin
  verifierObjet(pu);
  result:=TbinaryFile(pu).fileSize;
  if result<0 then sortieErreur(E_fileSize);
end;


procedure proTbinaryFile_seek(num:int64;var pu:typeUO);
begin
  verifierObjet(pu);
  if not TbinaryFile(pu).seek(num) then sortieErreur(E_seek);
end;

procedure proTbinaryFile_Read(var x;taille:integer;tpn:word;var pu:typeUO);
var
  res:integer;
begin
  verifierObjet(pu);
  with TbinaryFile(pu) do f.Read(x,taille);
end;

procedure proTbinaryFile_write(var x;taille:integer;tpn:word;var pu:typeUO);
var
  res:integer;
begin
  verifierObjet(pu);
  with TbinaryFile(pu) do
    f.Write(x,taille);
end;

procedure proTbinaryFile_BlockRead(var x;taille:integer;tpn:word;off,nb:integer;var pu:typeUO);
var
  ad:Pbyte;
begin
  verifierObjet(pu);
  if (off<0) or (nb<0) or (off+nb>taille) or (Tbinaryfile(pu).f.position+nb> Tbinaryfile(pu).f.size)
    then sortieErreur('TbinaryFile.blockread : error pos='+Int64str(Tbinaryfile(pu).f.position)
                     +' filesize='+Int64str(Tbinaryfile(pu).f.size)+'  varsize='+Istr(taille)+' nbByte='+Istr(nb)); ;

  ad:=@x;
  inc(intG(ad),off);

  TbinaryFile(pu).f.read(ad^,nb);
end;

procedure proTbinaryFile_Blockwrite(var x;taille:integer;tpn:word;off,nb:integer;var pu:typeUO);
var
  ad:Pbyte;
begin
  verifierObjet(pu);
  if (off<0) or (nb<0) or (off+nb>taille)
    then sortieErreur(E_block);

  ad:=@x;
  inc(intG(ad),off);

  TbinaryFile(pu).f.write(ad^,nb);
end;


procedure proTbinaryFile_CopyFrom(var binF:TbinaryFile;nb:int64;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(binF));


  TbinaryFile(pu).f.CopyFrom(TbinaryFile(binF).f,nb);
end;



function fonctionDeleteFile(FileName: AnsiString): Boolean;
begin
  result:= DeleteFile(FileName);
end;

Initialization
AffDebug('Initialization BinFile1',0);

installError(E_resetFile,'TbinaryFile.reset error');
installError(E_rewriteFile,'Tbinary.rewrite error');
installError(E_filePos,'TbinaryFile.filePos error');
installError(E_seek,'TbinaryFile.seek error');

registerObject(TbinaryFile,sys);

end.
