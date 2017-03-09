unit TextFile1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysutils,
     util1,Gdos,
     stmObj,stmPg,stmError,Ncdef2,debug0;

type
  TtextFile=class(typeUO)

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

                function readln:AnsiString;
                procedure writeln(st:AnsiString);

                function fileSize:int64;
                function eof:boolean;
              end;


procedure proTtextFile_Reset(stFile:AnsiString;var pu:typeUO);pascal;
procedure proTtextFile_Rewrite(stFile:AnsiString;var pu:typeUO);pascal;
procedure proTtextFile_close(var pu:typeUO);pascal;

function fonctionTtextFile_fileSize(var pu:typeUO):int64;pascal;

function fonctionTtextFile_Readln(var pu:typeUO): AnsiString;pascal;
procedure proTtextFile_writeln(st:AnsiString;var pu:typeUO);pascal;
function fonctionTtextFile_eof(var pu:typeUO): boolean;pascal;

implementation

{ TtextFile }

procedure TtextFile.close;
begin
  f.free;
  f:=nil;
end;

constructor TtextFile.create;
begin
  inherited;

end;

destructor TtextFile.destroy;
begin
  f.free;
  inherited;
end;

function TtextFile.fileSize: int64;
begin
  if assigned(f)
    then result:=f.Size
    else result:=-1;
end;


procedure TtextFile.ResetFile(st: AnsiString);
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

procedure TtextFile.RewriteFile(st: AnsiString);
begin
  try
    f:=TfileStream.Create(st,fmCreate);
    fileName:=st;
  except
    f:=nil;
    fileName:='';
  end;
end;

class function TtextFile.STMClassName: AnsiString;
begin
  result:='TextFile';
end;

function TtextFile.readln: AnsiString;
var
  c:char;
begin
  if not assigned(f) then sortieErreur('TtextFile.writeln : file not open');

  result:='';
  while f.Position < f.Size do
  begin
    f.Read(c,1);
    if c=#13 then
    begin
      f.Read(c,1);
      if c<>#10 then f.position:=f.position-1;
      exit;
    end
    else
    if c=#10 then
    begin
      f.Read(c,1);
      if c<>#13 then f.position:=f.position-1;
      exit;
    end
    else result:=result+c;
  end;

end;

procedure TtextFile.writeln(st: AnsiString);
begin
  if not assigned(f) then sortieErreur('TtextFile.writeln : file not open');

  st:=st+crlf;
  f.Write(st[1],length(st));
end;

function TtextFile.eof: boolean;
begin
  if assigned(f)
    then result:= (f.Position=f.Size)
    else sortieErreur('TtextFile.eof : file not open');
end;


{********************************* Méthodes STM ******************************}


procedure proTtextFile_Reset(stFile:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TtextFile);

  with TtextFile(pu) do
  begin
    ResetFile(stFile);
    if not assigned(f) then
      begin
        proTobject_free(pu);
        sortieErreur('TtextFile.reset : Unable to open '+stFile);
      end;
  end;
end;

procedure proTtextFile_Rewrite(stFile:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TtextFile);

  with TtextFile(pu) do
  begin
    RewriteFile(stFile);
    if not assigned(f) then
      begin
        proTobject_free(pu);
        sortieErreur('TtextFile.rewrite : Unable to create '+stFile);
      end;
  end;
end;

procedure proTtextFile_close(var pu:typeUO);
begin
  proTobject_free(pu);
end;


function fonctionTtextFile_fileSize(var pu:typeUO):int64;
begin
  verifierObjet(pu);
  result:=TtextFile(pu).fileSize;
  if result<0 then sortieErreur('TtextFile.fileSize error');
end;


function fonctionTtextFile_Readln(var pu:typeUO): AnsiString;
begin
  verifierObjet(pu);
  result:=TtextFile(pu).Readln;
end;

procedure proTtextFile_writeln(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TtextFile(pu).Writeln(st);
end;


function fonctionTtextFile_eof(var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  result:=TtextFile(pu).eof;
end;



Initialization
AffDebug('Initialization TextFile1',0);


registerObject(TtextFile,sys);

end.
