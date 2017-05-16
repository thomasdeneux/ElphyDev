unit OIblock1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysUtils,
     util1,Gdos,stmobj,ElphyFormat,varconf1,NcDef2, debug0,
     ippdefs17,ipps17, 
     stmImaging,
     objFile1;

type
  {TOIBlock permet de créer et de gérer un bloc Optical Imaging dans un fichier Elphy

  }
  TOImainRecord= record
                   Nx,Ny:integer;
                   tpNum:typetypeG;
                   WithRefFrame:boolean;
                   FrameCount:integer;
                 end;

  TOIBlock=
    class(TElphyFileBlock)
    private
      MainInfo:TOImainRecord;
      OIheader: TOIheader;

    public
      Pdata:pointer;
      dataSize:longword;
      posData: int64;
      RSHFile:AnsiString;

      stSource:Ansistring;

      destructor destroy;override;

      property Nx:integer read mainInfo.Nx write mainInfo.Nx;
      property Ny:integer read mainInfo.Ny write mainInfo.Ny;
      property tpNum:typetypeG read mainInfo.tpNum write mainInfo.tpNum;
      property WithRefFrame:boolean read mainInfo.WithRefFrame write mainInfo.WithRefFrame;
      property FrameCount:integer read mainInfo.FrameCount write mainInfo.FrameCount;

      class function STMClassName:AnsiString;override;
      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      function getInfo:AnsiString;override;

      procedure ReadOIfilesRSH(StSrc:AnsiString);
      procedure AnalyseRSD(stSrc:AnsiString);
      procedure ReadOIfilesBLK(StSrc:AnsiString);

      procedure ReadOIfilesGSH(StSrc:AnsiString);

      procedure ReadOIfiles(StSrc:AnsiString;tp:integer);

      function getExtraInfo:string;
    end;



procedure AppendOIblocks(src,dest:AnsiString; tpF:integer);
procedure proAppendOIblocks(src,dest:AnsiString);pascal;
procedure proAppendOIblocks_1(src,dest:AnsiString; tpF:integer);pascal;

implementation

{ TOIBlock }


class function TOIBlock.STMClassName: AnsiString;
begin
  result:='OIblock';
end;

procedure TOIBlock.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  conf.setvarConf('Main',mainInfo,sizeof(mainInfo));
  conf.setStringConf('RSH',RSHFile);
  conf.setStringConf('Source',stSource);
  if lecture then
  begin
    conf.setdataConf('data',PosData,DataSize);
    conf.SetVarConf('OIheader',OIheader, sizeof(OIheader));
  end
  else
  begin
    conf.SetVarConf('data',Pdata^,DataSize);
    if OIheader.lLenHeader<>0 then conf.SetVarConf('OIheader',OIheader, sizeof(OIheader));
  end;

  { En lecture, on note la position et la taille des datas
    En écriture, on sauve les datas }
end;

(*
  Dans un répertoire oi , on trouve plusieurs groupes de fichiers.
  Un groupe a l'allure suivante:
    Ger0216-0.rsh           fichier texte Header
    Ger0216-0.rsm           image de référence (1 seule frame)
    Ger0216-0(0).rsd        premier bloc 256 frames
    Ger0216-0(1).rsd        second
    Ger0216-0(2).rsd        etc...
    Ger0216-0(3).rsd

  Voici un exemple de fichier rsh :

//UltimaExpMan 20040830
//x=128/y=100/lskp=20/rskp=8/blk=256
//cmp=0/bit=16/mon=14/sft=0/prc=0
page_frames=1024
page_number=0
sample_time=  1.0msec
sample_mode=SDIF
reset_mode=0
gain_mode=0
average=1
trigger_src=Ext
trigger_pos=pre_trg
interval=1.0sec
pls_delay=  0.0msec
pls_width=  1.0msec
pls_interval=  1.0msec
pls_number=1
pls2_delay=  0.0msec
pls2_width=  0.0msec
pls2_interval=  0.0msec
pls2_number=0
stim_mode=0
dout_value=0
sync_mode=1
dual_cam=0
plsfile=
name=4*Ger0216-0(0)
cmnt=
Data-File-List
Ger0216-0.rsm
Ger0216-0(0).rsd
Ger0216-0(1).rsd
Ger0216-0(2).rsd
Ger0216-0(3).rsd

A la fin du fichier rsh , on a la liste des fichiers data
*)


{ReadOIfilesRSH lit un groupe. StSrc doit être un fichier RSH  ou GSH}

procedure TOIBlock.ReadOIfilesRSH(StSrc:AnsiString);
var
  rsh,srcs:TstringList;
  st:AnsiString;
  Ffiles:boolean;
  stPath,stExt:AnsiString;
  value,code:integer;
  i:integer;
begin
  if Fmaj(extractFileExt(stSrc))='.GSH' then
  begin
    ReadOIfilesGSH(StSrc);
    exit;
  end;

  Nx:=100;
  Ny:=100;
  tpNum:=G_smallint;
  FrameCount:=0;
  WithRefFrame:=false;

  Freemem(Pdata);
  Pdata:=nil;
  dataSize:=0;

  Ffiles:=false;
  srcs:=TstringList.create;
  rsh:=TstringList.create;

  stPath:=extractFilePath(stSrc);

  TRY
  {Faire la liste des fichiers}
  rsh.LoadFromFile(stSrc);

  for i:=0 to rsh.Count-1 do
  begin
    st:=rsh[i];
    if copy(st,1,11 )='page_frames' then
    begin
      delete(st,1,12);
      val(st,value,code);
      if code=0 then FrameCount:=value;
    end
    else
    if st='Data-File-List' then Ffiles:=true
    else
    if Ffiles then srcs.Add(stPath+st);
  end;


  {Analyser les fichiers }
  for i:=0 to srcs.Count-1 do
  begin
    st:=srcs[i];
    stExt:=extractFileExt(st);
    if stExt='.rsm' then WithRefFrame:=true;
    AnalyseRSD(st);
  end;

  rshFile:=rsh.Text;

  FINALLY
  srcs.Free;
  rsh.free;
  END;
end;

{Analyse d'un fichier RSD ou RSM}
procedure TOIBlock.AnalyseRSD(stSrc: AnsiString);
var
  f:TfileStream;
  size,nbL:int64;
  i:integer;
begin
  f:=nil;
  try
  f:=TfileStream.Create(stSrc,fmOpenRead);
  size:=f.size;

  Reallocmem(Pdata,DataSize+size);
  f.Read(PtabOctet(Pdata)^[dataSize],Size);
  finally
  f.Free;
  end;

  nbL:=size div 256;

  {Dans chaque ligne de 256 octets, on enlève 40 octets au début et 16 octets à la fin}
  for i:=0 to nbL-1 do
    move(PtabOctet(Pdata)^[dataSize+i*256+40],PtabOctet(Pdata)^[dataSize+i*200],200);

  reallocMem(Pdata,dataSize+nbL*200);
  dataSize:=dataSize+nbL*200;
end;

procedure TOIBlock.ReadOIfilesGSH(StSrc:AnsiString);
var
  rsh:TstringList;
  st,st1,st2:AnsiString;
  stGsd:AnsiString;
  value,code:integer;
  i:integer;
  FrameSize,OffFrame:integer;
  f:TfileStream;
  size,res:integer;

  k,extraX,extraY:integer;

const
  chiffres=['0'..'9'];
begin
  Nx:=100;
  Ny:=100;
  tpNum:=G_smallint;
  FrameCount:=0;
  WithRefFrame:= TRUE;

  Freemem(Pdata);
  Pdata:=nil;
  dataSize:=0;

  rsh:=TstringList.create;

  TRY
  rsh.LoadFromFile(stSrc);

  for i:=0 to rsh.Count-1 do
  begin
    st:=rsh[i];
    if copy(st,1,9 )='Data Size' then
    begin
      delete(st,1,9);
      while (length(st)>0) and not (st[1] in chiffres) do delete(st,1,1);

      st1:='';
      while (length(st)>0) and (st[1] in chiffres) do
      begin
        st1:=st1+st[1];
        delete(st,1,1);
      end;
      while (length(st)>0) and not (st[1] in chiffres) do delete(st,1,1);
      st2:='';
      while (length(st)>0) and (st[1] in chiffres) do
      begin
        st2:=st2+st[1];
        delete(st,1,1);
      end;
      val(st1,value,code);
      if code=0 then Nx:=value;
      val(st2,value,code);
      if code=0 then Ny:=value;
    end;
  end;

  rshFile:=rsh.Text;
  stGsd:=NouvelleExtension(stSrc,'.gsd');

  f:=nil;
  try
  f:=TfileStream.Create(stGsd,fmOpenRead);
  size:=f.size;

  k:=0;
  extraX:= 80 -k;
  extraY:=892+k*1025 ;
  FrameSize:=Nx*Ny*2 + extraX;
  OffFrame:=extraY;

  FrameCount:=(size-OffFrame) div FrameSize;

  Reallocmem(Pdata,Nx*Ny*2*FrameCount);

  for i:=0 to FrameCount-1 do
  begin
    f.Position:= OffFrame+i*FrameSize ;
    f.Read(PtabOctet(Pdata)^[Nx*Ny*2*i],Nx*Ny*2);
  end;

  finally
  f.free;
  end;
  dataSize:=Nx*Ny*2*FrameCount;

  FINALLY
  rsh.free;
  END;
end;

procedure TOIBlock.ReadOIfilesBLK(StSrc:AnsiString);
var
  f:TfileStream;
  sz:integer;
  nb:integer;
begin
  try
    f:=nil;
    f:=TfileStream.create(stSrc,fmOpenRead);
    f.read(OIheader,sizeof(OIHeader));

    f.Position:= OIheader.lLenHeader;

    with OIheader do
    begin
      Nx:= lFrameWidth;
      Ny:= lFrameHeight;
      FrameCount:= lNFramesPerStim*lNStimuli;
      WithRefFrame:=false;


      case lDataType of
        DAT_UCHAR:  tpNum:=G_byte;
        DAT_USHORT: tpNum:=G_word;
        DAT_LONG:   tpNum:=G_longint;
        DAT_FLOAT:  tpNum:=G_single;
      end;
      sz:=tailleTypeG[tpNum];

      DataSize:= lFrameWidth*lFrameHeight*lNFramesPerStim*lNStimuli*sz;
      Reallocmem(Pdata,Nx*Ny*FrameCount*sz);

      f.Read(Pdata^,DataSize);

    end;

    f.free;
  except
    f.Free;
  end;
end;



procedure TOIblock.ReadOIfiles(StSrc:AnsiString;tp:integer);
begin
  stSource:=stSrc;
  case tp of
    1: ReadOIfilesRSH(StSrc);
    2: ReadOIfilesBLK(StSrc);
  end;
end;


function TOIBlock.getInfo: AnsiString;
var
  Filelist:TstringList;
  i:integer;
begin
  Filelist:=TstringList.create;
  FileList.text:= getExtraInfo;

  result:=inherited getInfo+
          'Source='+stSource+cRLF+
          'Nx= '+Istr(Nx)+CRLF+
          'Ny= '+Istr(Ny)+CRLF+
          'FrameCount= '+Istr(FrameCount)+CRLF+
          'tp= '+TypeNameG[tpNum] +CRLF+
          'WithRefFrame= '+Bstr(WithRefFrame)+CRLF+
          'PosData= '+Int64str(PosData)+CRLF+
          'DataSize= '+Istr(DataSize)+CRLF+
           CRLF;

  if RSHfile<>'' then result:=result+'RSH file=  '+CRLF
  else
  if OIheader.lLenHeader<>0 then result:=result+'OI header=  '+CRLF;

  for i:=0 to FileList.Count-1 do
    result:=result+'        '+FileList[i]+CRLF;

  Filelist.Free;
end;

procedure AppendOIblocks(src,dest:AnsiString; tpF:integer);
var
  f:TobjectFile;
begin
  f:=TobjectFile.create;
  try
  f.openFile(dest);
  f.AppendOIblocks(src,tpF);
  finally
  f.free;
  end;
end;


procedure proAppendOIblocks_1(src,dest:AnsiString; tpF:integer);
begin
  if not fileExists(dest) then sortieErreur('AppendOIblocks : Destination file not found');
  if not (tpF in [1,2]) then sortieErreur('AppendOIblocks : Invalid File type');
  AppendOIblocks(src,dest,tpF);
end;

procedure proAppendOIblocks(src,dest:AnsiString);
begin
  AppendOIblocks(src,dest,1);
end;

destructor TOIBlock.destroy;
begin
  freemem(Pdata);
  inherited;
end;

function TOIBlock.getExtraInfo: string;
begin
  if RSHfile<>'' then result:=RSHfile
  else
  with OIheader do
  begin
    result:=

      'lVersionID = '+Istr(lVersionID) +CRLF+
      'lFileType = '+Istr(lFileType) +CRLF+
      'lFileSubtype = '+Istr(lFileSubtype) +CRLF+
      'lDataType = '+Istr(lDataType) +CRLF+
      'lSizeOf = '+Istr(lSizeOf) +CRLF+
      'lFrameWidth = '+Istr(lFrameWidth) +CRLF+
      'lFrameHeight = '+Istr(lFrameHeight) +CRLF+
      'lNFramesPerStim = '+Istr(lNFramesPerStim) +CRLF+
      'lNStimuli = '+Istr(lNStimuli) +CRLF+
      'lInitialXBinFactor = '+Istr(lInitialXBinFactor) +CRLF+
      'lInitialYBinFactor = '+Istr(lInitialYBinFactor) +CRLF+
      'lXBinFactor = '+Istr(lXBinFactor) +CRLF+
      'lYBinFactor = '+Istr(lYBinFactor) +CRLF+
      'acUserName = '+CharToString(@acUserName,32) +CRLF+
      'acRecordingDate = '+CharToString(@acRecordingDate,16) +CRLF+
      'lX1ROI = '+Istr(lX1ROI) +CRLF+
      'lY1ROI = '+Istr(lY1ROI) +CRLF+
      'lX2ROI = '+Istr(lX2ROI) +CRLF+
      'lY2ROI = '+Istr(lY2ROI) +CRLF+
      'lStimOffs = '+Istr(lStimOffs) +CRLF+
      'lStimSize = '+Istr(lStimSize) +CRLF+
      'lFrameOffs = '+Istr(lFrameOffs) +CRLF+
      'lFrameSize = '+Istr(lFrameSize) +CRLF+
      'lRefOffs = '+Istr(lRefOffs) +CRLF+
      'lRefSize = '+Istr(lRefSize) +CRLF+
      'lRefWidth = '+Istr(lRefWidth) +CRLF+
      'lRefHeight = '+Istr(lRefHeight) +CRLF+
      'aushWhichBlocks = '+CharToString(@aushWhichBlocks,16) +CRLF+
      'aushWhichFrames = '+CharToString(@aushWhichFrames,16) +CRLF+
      'fLoClip = '+Estr(fLoClip,6) +CRLF+
      'fHiClip = '+Estr(fHiClip,6) +CRLF+
      'lLoPass = '+Istr(lLoPass) +CRLF+
      'lHiPass = '+Istr(lHiPass) +CRLF+
      'acOperationsPerformed = '+CharToString(@acOperationsPerformed,6) +CRLF+
      'fMagnification = '+CharToString(@fMagnification,6) +CRLF+
      'ushGain = '+Istr(ushGain) +CRLF+
      'ushWavelength = '+Istr(ushWavelength) +CRLF+
      'lExposureTime = '+Istr(lExposureTime) +CRLF+
      'lNRepetitions = '+Istr(lNRepetitions) +CRLF+
      'lAcquisitionDelay = '+Istr(lAcquisitionDelay) +CRLF+
      'lInterStimInterval = '+Istr(lInterStimInterval) +CRLF+
      'acCreationDate = '+CharToString(@acCreationDate,64) +CRLF+
      'acDataFilename = '+CharToString(@acDataFilename,64) +CRLF+
      'acOraReserved = '+CharToString(@acOraReserved,256) +CRLF+
      'lIncludesRefFrame = '+Istr(lIncludesRefFrame) +CRLF+
      'acListOfStimuli = '+CharToString(@acListOfStimuli,256) +CRLF+
      'lNVideoFramesPerDataFrame = '+Istr(lNVideoFramesPerDataFrame) +CRLF+
      'lNTrials = '+Istr(lNTrials) +CRLF+
      'lScaleFactor = '+Estr(lScaleFactor,6) +CRLF+
      'fMeanAmpGain = '+Estr(fMeanAmpGain,6) +CRLF+
      'fMeanAmpDC = '+Estr(fMeanAmpDC,6) +CRLF+
      'ucBegBaselineFrameNo = '+Istr(ucBegBaselineFrameNo) +CRLF+
      'ucEndBaselineFrameNo = '+Istr(ucEndBaselineFrameNo) +CRLF+
      'ucBegActivityFrameNo = '+Istr(ucBegActivityFrameNo) +CRLF+
      'ucEndActivityFrameNo = '+Istr(ucEndActivityFrameNo) +CRLF+
      'acVdaqReserved = '+CharToString(@acVdaqReserved,256) +CRLF+
      'acUser = '+CharToString(@acUser,256) +CRLF+
      'acComment = '+CharToString(@acComment,256) ;


  end;
end;

Initialization
AffDebug('Initialization OIblock1',0);

registerObject(TOIBlock,sys);

end.
