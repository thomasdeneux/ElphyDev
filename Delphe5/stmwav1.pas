unit stmWav1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, mmsystem, classes, sysutils,
     util1, Dgraphic, Debug0,
     stmDef, stmObj, stmVec1,
     Ncdef2, stmError,stmPg;

type
   TRiffSgn=array[1..4] of char;

   TChunkHeader =
      record
        ckID:     TRiffSgn;   { four-character chunk ID }
        ckSize:   longint;    { length of data in chunk }
      end;


   TWaveFormat =
     record
       wFormatTag:         word;
       nChannels:          word;
       nSamplesPerSec:     longint;
       nAvgBytesPerSec:    longint;
       nBlockAlign:        word;
       nBitsPerSample:     word;
     end;

{Le fichier .wav contient:

   un chunkHeader 'RIFF' avec size=filesize-8

   un mot 'WAVE'

   un chunkHeader 'fmt ' avec size= sizeof(TwaveFormat) =16
   suivi de TwaveFormat

   un chunkHeader 'data' avec size= taille des données
   suivi des données
}
  TwaveHeader=
    record
      RiffChunkHeader: TchunkHeader;
      Wave:TriffSgn;
      FmtChunkHeader: TchunkHeader;
      format:TwaveFormat;
      DataChunkHeader: TchunkHeader;
    end;

  TwaveFile=class(typeUO)
              fileName:AnsiString;
              header: TwaveHeader;
              open:boolean;

              constructor create;override;

              class function STMClassName:AnsiString;override;

              procedure createFile(st:AnsiString);
              procedure OpenFile(st:AnsiString);
              procedure saveVector(v:Tvector);
              procedure save2Vectors(v1,v2:Tvector);
              procedure play;

              procedure LoadVector(v: Tvector; ch:integer);

            end;


procedure proTwaveFile_CreateFile(stFile:AnsiString;var pu:typeUO);pascal;
procedure proTwaveFile_CreateFile_1(stFile:AnsiString; SamplePerSec:integer; var pu:typeUO);pascal;

procedure proTwaveFile_OpenFile(stFile:AnsiString;var pu:typeUO);pascal;

procedure proTwaveFile_play(var pu:typeUO);pascal;
procedure proTwaveFile_saveVector(var v:Tvector;var pu:typeUO);pascal;
procedure proTwaveFile_save2Vectors(var v1,v2:Tvector;var pu:typeUO);pascal;

procedure proTvector_loadFromWaveFile(stFile:AnsiString;ch:integer; var pu:Tvector);pascal;

implementation

var
  E_createFile:integer;
  E_openFile:integer;

  E_play:integer;

class function TwaveFile.STMClassName:AnsiString;
  begin
    STMClassName:='WaveFile';
  end;

constructor TwaveFile.create;
begin
  with header do
  begin
    RiffChunkHeader.ckId:='RIFF';
    RiffChunkHeader.ckSize:=0; {reçoit fileSize-8}

    Wave:='WAVE';

    FmtChunkHeader.ckId:='fmt ';
    FmtChunkHeader.ckSize:=16;

    with format do
    begin
      wFormatTag:=1;
      nChannels:=1;
      nSamplesPerSec:=11025 {22050};
      nAvgBytesPerSec:=2*nChannels*nSamplesPerSec;
      nBlockAlign:=2*nChannels;
      nBitsPerSample:=16;
    end;

    DataChunkHeader.ckId:='data';
    DataChunkHeader.ckSize:=0; {reçoit 2*nChannels*nbSample}
  end;
end;



procedure TwaveFile.createFile(st:AnsiString);
begin
  fileName:=st;
  open:=true;
end;

procedure TwaveFile.OpenFile(st:AnsiString);
var
  res:intG;
  f: TfileStream;
begin
  try
  f:=TfileStream.Create(st,fmOpenRead);
  f.read(header,sizeof(Header));
  f.free;
  Open:=true;
  fileName:=st;
  except
  f.free;
  Open:=false;
  fileName:='';
  end;
end;

procedure TwaveFile.saveVector(v:Tvector);
var
  res:intG;
  nbsample:integer;
  x:double;
  i:integer;
  y:smallint;
  f:TfileStream;
begin
  if not open then exit;

  with v do
  begin
    nbSample:=truncL((Xend-Xstart)*header.format.nSamplesPerSec);
    {messageCentral('nbSample='+Istr(nbSample));}
  end;

  header.RiffChunkHeader.ckSize:=sizeof(header)+nbsample*2-8;
  header.DataChunkHeader.ckSize:=nbsample*2;

  try
  f:=TfileStream.Create(fileName,fmCreate);
  f.write(Header,sizeof(Header));

  for i:=0 to nbSample-1 do
    with v do
    begin
      x:=Xstart+(Xend-Xstart)/(nbSample-1)*i;
      y:=data.getI(invConvx(x));
      f.Write(y,sizeof(y));
    end;

  f.free;
  except
  f.free;
  end;

  open:=false;
end;

procedure TwaveFile.save2Vectors(v1,v2:Tvector);
var
  res:intG;
  nbsample,nbsample1,nbsample2:integer;
  x:double;
  i:integer;
  y:smallint;
  f:TfileStream;
begin
  if not open then exit;

  with v1 do
    nbSample1:=truncL((Xend-Xstart)*header.format.nSamplesPerSec);
  with v2 do
    nbSample2:=truncL((Xend-Xstart)*header.format.nSamplesPerSec);

  if nbSample1<nbSample2
    then nbSample:=nbSample1
    else nbSample:=nbSample2;

  header.RiffChunkHeader.ckSize:=sizeof(header)+nbsample*4-8;
  header.DataChunkHeader.ckSize:=nbsample*4;

  with header.format do
  begin
    nChannels:=2;
    nAvgBytesPerSec:=2*nChannels*nSamplesPerSec;
    nBlockAlign:=2*nChannels;
  end;

  try
  f:=TfileStream.create(fileName,fmCreate);

  f.Write(Header,sizeof(Header));

  for i:=0 to nbSample-1 do
    begin
      with v1 do
      begin
        x:=Xstart+(Xend-Xstart)/(nbSample-1)*i;
        y:=data.getI(invConvx(x));
        f.Write(y,sizeof(y));
      end;
      with v2 do
      begin
        x:=Xstart+(Xend-Xstart)/(nbSample-1)*i;
        y:=data.getI(invConvx(x));
        f.Write(y,sizeof(y));
      end;
    end;

  f.free;
  except
  f.free;
  end;
  open:=false;
end;


procedure TwaveFile.play;
begin
  if open then
    if not sndPlaySound(Pchar(fileName),snd_async) then
      sortieErreur(E_play);
end;


// ch vaut 0 ou 1
procedure TwaveFile.LoadVector(v: Tvector; ch: integer);
var
  nbCh:integer;
  nByte: integer;
  nbSample: integer;
  dataSize:integer;
  i:integer;
  w:smallint;
  f:TfileStream;
begin
  if not open then exit;

  nbCh:= header.format.nChannels;
  nbyte:=header.format.nBitsPerSample div 8;

  try
  f:=TfileStream.Create(fileName,fmOpenRead);
  f.position:= sizeof(Header);

  dataSize:= header.DataChunkHeader.ckSize;
  nbSample:=dataSize div(nbyte*nbch);

  v.modify(g_smallint,0,nbSample-1);
  v.Dxu:= 1/Header.format.nSamplesPerSec;
  v.unitX:='sec';

  if (nByte=2) and (nbCh=1) and v.inf.temp then f.Read(v.tb^,dataSize)
  else
  begin
    for i:=0 to nbSample-1 do
    begin
      w:=0;
      f.Position:=i*nByte*nbCh+ch*nByte;
      f.Read(w,nByte);
      v[i]:= w;
    end;
  end;


  finally
  f.free;
  end;

end;


procedure proTwaveFile_saveVector(var v:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with TwaveFile(pu) do saveVector(v);
end;

procedure proTwaveFile_save2Vectors(var v1,v2:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v1));
  verifierObjet(typeUO(v2));

  with TwaveFile(pu) do save2Vectors(v1,v2);
end;

procedure proTwaveFile_play(var pu:typeUO);
begin
  verifierObjet(pu);
  TwaveFile(pu).play;
end;

procedure proTwaveFile_CreateFile(stFile:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TwaveFile);

  with TwaveFile(pu) do
  begin
    createFile(stFile);
  end;
end;


procedure proTwaveFile_CreateFile_1(stFile:AnsiString; SamplePerSec:integer; var pu:typeUO);
begin
  createPgObject('',pu,TwaveFile);

  with TwaveFile(pu) do
  begin
    createFile(stFile);
    header.format.nSamplesPerSec:= SamplePerSec;
  end;
end;


procedure proTwaveFile_OpenFile(stFile:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TwaveFile);

  with TwaveFile(pu) do
  begin
    OpenFile(stFile);
    if not open then
      begin
        proTobject_free(pu);
        sortieErreur(E_OpenFile);
      end;
  end;
end;

procedure proTvector_loadFromWaveFile(stFile:AnsiString;ch:integer; var pu:Tvector);
var
  wave: TwaveFile;
begin
  verifierVecteurTemp(pu);
  if (ch<1) or (ch>2) then sortieErreur('Tvector.loadFromWaveFile : channel must be 1 or 2');

  try
  wave:= TwaveFile.create;
  wave.OpenFile(stFile);
  if not wave.open then sortieErreur('Tvector.loadFromWaveFile : unable to open '+stFile);

  wave.LoadVector(pu,ch-1);
  finally
  wave.Free;
  end;

end;


Initialization
AffDebug('Initialization stmwav1',0);
  installError(E_play,'TwaveFile: play error');

end.
