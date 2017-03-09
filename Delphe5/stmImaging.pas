unit stmImaging;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysUtils,
     util1, Gdos,
     stmDef,stmObj, stmMat1,stmMatA1,stmPg,NcDef2,debug0;

Const
//-----------------------------------------------
// Field: lFileType.
//-----------------------------------------------
  RAWBLOCK_FILE = 11;
  DCBLOCK_FILE =  12;
  SUM_FILE =      13;
  IMAGE_FILE =    14;
//-----------------------------------------------
// Field: lFileSubtype.
//-----------------------------------------------
  FROM_VDAQ =     11;
  FROM_ORA =      12;
//-----------------------------------------------
// Field: lDataType.
//-----------------------------------------------
  DAT_UCHAR =     11;
  DAT_USHORT =    12;
  DAT_LONG =      13;
  DAT_FLOAT =     14;

//-----------------------------------------------
// Header used by COiFiles.
//-----------------------------------------------

type
  TOIHEADER=record
                  // Data integrity
      lFileSize: longint;
      lCheckSum_Header: longint; // beginning with the lLen Header field
      lCheckSum_Data:   longint;
                  // Common to all data files
      lLenHeader:   longint;
      lVersionID:   longint;
      lFileType:    longint;     // e.g. DCBLOCK_FILE, RAWBLOCK_FILE
      lFileSubtype: longint;     // e.g. FROM_VDAQ, FROM_ORA
      lDataType:    longint;     // e.g. DAT_UCHAR, DAT_USHORT
      lSizeOf:      longint;     // e.g. sizeof(long), sizeof(float)
      lFrameWidth:  longint;
      lFrameHeight: longint;
      lNFramesPerStim: longint;
      lNStimuli:    longint;
      lInitialXBinFactor: longint;      // from data acquisition
      lInitialYBinFactor: longint;      // from data acquisition
      lXBinFactor:  longint;            // this file
      lYBinFactor:  longint;            // this file
      acUserName:array[1..32] of char;
      acRecordingDate:array[1..16] of char;
      lX1ROI:       longint;
      lY1ROI:       longint;
      lX2ROI:       longint;
      lY2ROI:       longint;
                  // Locate data and ref frames
      lStimOffs:    longint;
      lStimSize:    longint;
      lFrameOffs:   longint;
      lFrameSize:   longint;
      lRefOffs:     longint;
      lRefSize:     longint;
      lRefWidth:    longint;
      lRefHeight:   longint;
                  // Common to data files that have undergone some form of "compression"
                  // or "summing"; i.e. The data in the current file may be the

                  // result of having summed blocks 'a'-'f', frames 1-7
      aushWhichBlocks: array[1..16] of word; // 256 bits => max of 256 blocks per expt
      aushWhichFrames: array[1..16] of word; // 256 bits => max of 256 frames per
                  // condition
                  // Data analysis
      fLoClip:      single;
      fHiClip:      single;
      lLoPass:      longint;
      lHiPass:      longint;
      acOperationsPerformed:array[1..64] of char;
                 // Ora-specific—not needed by Vdaq
      fMagnification:single;
      ushGain:       word;
      ushWavelength: word;
      lExposureTime: longint;
      lNRepetitions: longint;      // # of repetitions
      lAcquisitionDelay: longint;  // delay of DAQ relative to Stim-Go
      lInterStimInterval: longint; // time interval between Stim-Go's
      acCreationDate: array[1..16] of char;
      acDataFilename: array[1..64] of char;
      acOraReserved: array[1..256] of char;
                // Vdaq-specific
      lIncludesRefFrame: longint;    // 0 or 1
      acListOfStimuli: array[1..256] of char;
      lNVideoFramesPerDataFrame: longint;
      lNTrials:     longint;
      lScaleFactor: longint;      // NFramesAvgd * Bin * Trials
      fMeanAmpGain: single;
      fMeanAmpDC:   single;
      ucBegBaselineFrameNo: byte ; // SUM-FR/DC File (i.e. compressed)
      ucEndBaselineFrameNo: byte;  // SUM-FR/DC File (i.e. compressed)
      ucBegActivityFrameNo: byte;  // SUM-FR/DC File (i.e. compressed)
      ucEndActivityFrameNo: byte;  // SUM-FR/DC File (i.e. compressed)
      acVdaqReserved: array[1..252] of char;
                // User-defined
      acUser: array[1..256] of char;
                // Comment
      acComment: array[1..256] of char;
    end;

    POIHEADER= ^TOIHEADER;

    TOIfile=
      class(typeUO)
      private
        header: TOIHEADER;

        stFile:AnsiString;

        function getDataType:integer;
      public
        constructor create;override;
        destructor destroy;override;

        class function STMClassName:AnsiString;override;

        procedure OpenFile(st:AnsiString);

        property HeaderLength:   longint read header.lLenHeader;
        property VersionID:      longint read header.lVersionID;
        property FileType:       longint read header.lFileType;
        property FileSubtype:    longint read header.lFileSubtype;
        property DataType:       longint read getDataType;
        property SizeOfData:     longint read header.lSizeOf;
        property FrameWidth:     longint read header.lFrameWidth;
        property FrameHeight:    longint read header.lFrameHeight;
        property FramesPerStim:  longint read header.lNFramesPerStim;
        property NStim:          longint read header.lNStimuli;

        function FrameSize:integer;

        procedure LoadFrame(stim,frame:integer;mat:Tmatrix);
      end;


procedure proTOIfile_OpenFile(stF:AnsiString;var pu:typeUO);pascal;
procedure proTOIfile_LoadFrame(Stim,Frame:integer;var mat:Tmatrix;var pu:typeUO);pascal;
procedure proTOIfile_LoadFile(var mat:TmatrixArray;var pu:typeUO);pascal;

function fonctionTOIfile_fileName(var pu:typeUO):AnsiString;pascal;
function fonctionTOIfile_StimCount(var pu:typeUO):integer;pascal;
function fonctionTOIfile_FramesPerStim(var pu:typeUO):integer;pascal;
function fonctionTOIfile_FrameWidth(var pu:typeUO):integer;pascal;
function fonctionTOIfile_FrameHeight(var pu:typeUO):integer;pascal;
function fonctionTOIfile_DataType(var pu:typeUO):integer;pascal;


implementation

{ TOIfile }

constructor TOIfile.create;
begin
  inherited;

end;

destructor TOIfile.destroy;
begin

  inherited;
end;

function TOIfile.getDataType: integer;
begin
  case header.lDataType of
    DAT_UCHAR:  result:=ord(g_byte);
    DAT_USHORT: result:=ord(g_word);
    DAT_LONG:   result:=ord(g_longint);
    DAT_FLOAT:  result:=ord(g_single);
  end;
end;

procedure TOIfile.OpenFile(st: AnsiString);
var
  f:TfileStream;
begin
  try
  f:=nil;
  f:=TfileStream.create(st,fmOpenRead);
  f.read(header,sizeof(Header));
  stFile:=st;
  f.free;
  except
  f.Free;
  stFile:='';
  end;
end;

class function TOIfile.STMClassName: AnsiString;
begin
  result:='IOfile';
end;

procedure TOIfile.LoadFrame(stim, frame: integer; mat: Tmatrix);
var
  f:TfileStream;
  buf:pointer;
  i,j:integer;
begin
  try
  getmem(buf,FrameSize);
  fillchar(buf^,FrameSize,0);

  f:=nil;
  f:=TfileStream.create(stFile,fmOpenRead);
  f.position:=HeaderLength+((stim-1)*FramesPerStim+frame-1)*FrameSize;
  f.Read(buf^,FrameSize);

  mat.initTemp(0,FrameWidth-1,0,FrameHeight-1,g_single);

  with mat do
  case header.lDataType of
    DAT_UCHAR: for i:=0 to frameWidth-1 do
               for j:=0 to frameHeight-1 do
               PtabSingle(tb)^[i*FrameHeight+j]:=PtabOctet(buf)^[j*FrameWidth+i];

    DAT_USHORT:for i:=0 to frameWidth-1 do
               for j:=0 to frameHeight-1 do
               PtabSingle(tb)^[i*FrameHeight+j]:=PtabEntier(buf)^[j*FrameWidth+i];

    DAT_LONG:  for i:=0 to frameWidth-1 do
               for j:=0 to frameHeight-1 do
               PtabSingle(tb)^[i*FrameHeight+j]:=PtabLong(buf)^[j*FrameWidth+i];

    DAT_FLOAT: for i:=0 to frameWidth-1 do
               for j:=0 to frameHeight-1 do
               PtabSingle(tb)^[i*FrameHeight+j]:=PtabSingle(buf)^[j*FrameWidth+i];
  end;


  finally
  f.Free;
  freemem(buf);
  end;
end;


function TOIfile.FrameSize: integer;
begin
  result:=FrameWidth*FrameHeight*SizeOfData;
end;



procedure proTOIfile_OpenFile(stF:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TOIfile);
  with TOIfile(pu) do
  begin
    openFile(stF);
  end;
end;

function fonctionTOIfile_fileName(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TOIfile(pu).stFile;
end;

function fonctionTOIfile_StimCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TOIfile(pu).NStim;
end;

function fonctionTOIfile_FramesPerStim(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TOIfile(pu).FramesPerStim;
end;

function fonctionTOIfile_FrameWidth(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TOIfile(pu).FrameWidth;
end;

function fonctionTOIfile_FrameHeight(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TOIfile(pu).FrameHeight;
end;

function fonctionTOIfile_DataType(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TOIfile(pu).DataType;
end;


procedure proTOIfile_LoadFrame(Stim,Frame:integer;var mat:Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));
  with TOIfile(pu) do
  begin
    if stFile='' then sortieErreur('TOIfile: No data file');
    loadFrame(Stim,Frame, mat);
  end;
end;

procedure proTOIfile_LoadFile(var mat:TmatrixArray;var pu:typeUO);
var
  i,j:integer;
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));
  with TOIfile(pu) do
  begin
    if stFile='' then sortieErreur('TOIfile: No data file');

    mat.initArray(1,FramesPerStim,1,Nstim);
    mat.initMatrix(g_single,0,0,0,0);

    for i:=1 to FramesPerStim do
    for j:=1 to Nstim do
      loadFrame(j,i,mat.matrix(i,j));

    mat.keepRatio:=true;
    mat.AspectRatio:=FrameHeight/FrameWidth;

    mat.autoscaleI;
    mat.autoscaleJ;
    mat.autoscaleX;
    mat.autoscaleY;

  end;
end;


Initialization
AffDebug('Initialization stmImaging',0);
  registerObject(TOIfile,data);

end.
