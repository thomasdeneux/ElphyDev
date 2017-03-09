unit DescIgor;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses windows,classes,sysutils,
     util1,dtf0,Spk0,ficDefAc,debug0,descac1,
     stmDef,IgorBin;


type

  TIGORdescriptor=class(TfileDescriptor)
    private
      BufBinHeader:TBinHeader5;
      BufWaveHeader:TwaveHeader5;

      stDat:AnsiString;
      

      function BinHeader1:PbinHeader1;
      function BinHeader2:PbinHeader2;
      function BinHeader3:PbinHeader3;
      function BinHeader5:PbinHeader5;

      function WaveHeader2:wavePtr2;
      function WaveHeader5:wavePtr5;

      procedure SwapBH1;
      procedure SwapBH2;
      procedure SwapBH3;
      procedure SwapBH5;

      procedure SwapWH2;
      procedure SwapWH5;

      function doCheckSum(f:TfileStream):boolean;
      function isWH5:boolean;
    public
      constructor create;override;
      destructor destroy;override;

      property Version:smallint read BufBinHeader.version;

      function init(st:AnsiString):boolean;override;
      function nbvoie:integer;override;
      function nbSeqDat:integer;override;
      function nbPtSeq(voie:integer):integer;override;
      function getData(voie,seq:integer;var evtMode:boolean):typeDataB;override;
      function getTpNum(voie,seq:integer):typetypeG;override;
      function FichierContinu:boolean;override;

      procedure displayInfo;override;
      function unitX:AnsiString;override;
      function unitY(num:integer):AnsiString;override;

      class function FileTypeName:AnsiString;override;
    end;

implementation


procedure SwapBytes(var x;n:integer);
var
  tb:  array[0..1000] of byte;
  tbx: array[0..1000] of byte absolute x;
  i:integer;
begin
  for i:=0 to n-1 do
    tb[i]:=tbx[n-i-1];
  move(tb,tbx,n);
end;

{ TIGORdescriptor }

function TIGORdescriptor.BinHeader1: PbinHeader1;
begin
  result:=@bufBinHeader;
end;

function TIGORdescriptor.BinHeader2: PbinHeader2;
begin
  result:=@bufBinHeader;
end;

function TIGORdescriptor.BinHeader3: PbinHeader3;
begin
  result:=@bufBinHeader;
end;

function TIGORdescriptor.BinHeader5: PbinHeader5;
begin
  result:=@bufBinHeader;
end;

function TIGORdescriptor.WaveHeader2: wavePtr2;
begin
  result:=@bufWaveHeader;
end;

function TIGORdescriptor.WaveHeader5: wavePtr5;
begin
  result:=@bufWaveHeader;
end;

function TIGORdescriptor.doCheckSum(f:TfileStream):boolean;
var
  buf:array[1..1000] of smallint;
  i,N,res:integer;
  w:smallint;
begin
  f.Position:=0;

  case version of
    1,$0100: N:=134;
    2,$0200: N:=142;
    3,$0300: N:=146;
    5,$0500: N:=384;
    else N:=0;
  end;

  f.read(buf,N);
  if version>5 then
    for i:=1 to N div 2 do swapBytes(buf[i],2);

  w:=0;
  for i:=1 to N div 2 do
    w:=w+buf[i];

  result:=(w=0);
end;


constructor TIGORdescriptor.create;
begin
  inherited;

end;

function TIGORdescriptor.init(st: AnsiString): boolean;
var
  f:TfileStream;
  res:integer;
begin
  result:=false;

  stDat:=st;
  f:=nil;
  TRY
  f:=TfileStream.create(stDat,fmOpenRead);

  storeFileParams(f);

  fillchar(bufBinHeader,sizeof(bufBinHeader),0);
  f.Read(bufBinHeader,2);              {lire version}

  case version of
    1,$0100:
       begin
         f.Read(bufBinHeader.checksum,sizeof(TbinHeader1)-2);
         f.Read(bufWaveHeader,110);
         if version=$0100 then
         begin
           swapBH1;
           swapWH2;
         end;
       end;
    2,$0200:
       begin
         f.Read(bufBinHeader.checksum,sizeof(TbinHeader2)-2);
         f.Read(bufWaveHeader,110);
         if version=$0200 then
         begin
           swapBH2;
           swapWH2;
         end;
       end;
    3,$0300:
       begin
         f.Read(bufBinHeader.checksum,sizeof(TbinHeader3)-2);
         f.Read(bufWaveHeader,110);
         if version=$0300 then
         begin
           swapBH3;
           swapWH2;
         end;
       end;
    5,$0500:
       begin
         f.Read(bufBinHeader.checksum,sizeof(TbinHeader5)-2);
         f.Read(bufWaveHeader,320);
         if version=$0500 then
         begin
           swapBH5;
           swapWH5;
         end;
       end;

    else
      begin
        f.free;
        exit;
      end;
  end;

  result:=DoCheckSum(f);
  f.free;
  Except
  f.free;
  result:=false;
  end;

end;



destructor TIGORdescriptor.destroy;
begin

  inherited;
end;

procedure TIGORdescriptor.displayInfo;
begin
  inherited;

end;

function TIGORdescriptor.FichierContinu: boolean;
begin
  result:=false;
end;

function TIGORdescriptor.getData(voie, seq: integer;
  var evtMode: boolean): typeDataB;
var
  i:integer;
  offsetS:integer;
  data0:typeDataB;

  nbpt:integer;
begin
  result:=nil;
  if (voie<>1) or (seq>1)
    then exit;

  evtMode:=false;

  case version of
    1,$0100: offsetS:= sizeof(TbinHeader1)+110;
    2,$0200: offsetS:= sizeof(TbinHeader2)+110;
    3,$0300: offsetS:= sizeof(TbinHeader3)+110;
    5,$0500: offsetS:= sizeof(TbinHeader5)+320;
  end;

  nbpt:=nbptSeq(1);

  data0:=nil;
  case getTpNum(1,1) of
    G_smallint: data0:=typedataFileI.create(stdat,offsetS,nbvoie,0,nbpt-1,false);
    G_single:  data0:=typedataFileS.create(stdat,offsetS,nbvoie,0,nbpt-1,false);
  end;

  if version>255 then data0.setUnix;
  if isWH5
    then data0.setConversionX(waveHeader5^.sfA[1],waveHeader5^.sfB[1])
    else data0.setConversionX(waveHeader2^.hsA,waveHeader2^.hsB);

  {
  data0^.setConversionY(Dyu[voie],Y0u[voie]);
  }

  result:=data0;
end;

function TIGORdescriptor.getTpNum(voie, seq: integer): typetypeG;
var
  tp:integer;
begin
  if isWH5
    then tp:=waveHeader5^.typeW
    else tp:=waveHeader2^.typeW;

  case tp of
    NT_I8:     result:=G_short;
    NT_I16:    result:=G_smallint;
    NT_I32:    result:=G_longint;
    NT_FP32:   result:=G_single;
    NT_FP64:   result:=G_double;

    NT_I8   + NT_UNSIGNED:     result:=G_byte;
    NT_I16  + NT_UNSIGNED:     result:=G_word;
    else       result:=G_none;
  end;


end;


function TIGORdescriptor.nbPtSeq(voie: integer): integer;
var
  waveDataSize:integer;
  t:integer;
begin
  if isWH5
    then waveDataSize:=BinHeader5^.wfmSize-320
    else waveDataSize:=BinHeader2^.wfmSize-110-16;

  t:=tailleTypeG[getTpNum(1,1)];
  if t<>0
    then result:=waveDataSize div t
    else result:=0;
end;

function TIGORdescriptor.nbSeqDat: integer;
begin
  result:=1;
end;

function TIGORdescriptor.nbvoie: integer;
begin
  result:=1;
end;


procedure TIGORdescriptor.SwapBH1;
begin
  with BinHeader1^ do
  begin
    swapBytes(wfmSize,sizeof(wfmSize));
    swapBytes(checksum,sizeof(checksum));
  end;

end;

procedure TIGORdescriptor.SwapBH2;
begin
  with BinHeader2^ do
  begin
    swapBytes(wfmSize,sizeof(wfmSize));
    swapBytes(noteSize,sizeof(noteSize));
    swapBytes(pictSize,sizeof(pictSize));
    swapBytes(checksum,sizeof(checksum));
  end;
end;

procedure TIGORdescriptor.SwapBH3;
begin
 with BinHeader3^ do
  begin
    swapBytes(wfmSize,sizeof(wfmSize));
    swapBytes(noteSize,sizeof(noteSize));
    swapBytes(formulaSize,sizeof(formulaSize));
    swapBytes(pictSize,sizeof(pictSize));
    swapBytes(checksum,sizeof(checksum));
  end;
end;

procedure TIGORdescriptor.SwapBH5;
begin
  with BinHeader5^ do
  begin
    swapBytes(checksum,sizeof(checksum));
    swapBytes(wfmSize,sizeof(wfmSize));
    swapBytes(formulaSize,sizeof(formulaSize));
    swapBytes(noteSize,sizeof(noteSize));

    swapBytes(dataEUnitsSize,sizeof(dataEUnitsSize));
    swapBytes(dimEUnitsSize,sizeof(dimEUnitsSize));
    swapBytes(dataEUnitsSize,sizeof(dataEUnitsSize));

    swapBytes(dimLabelsSize,sizeof(dimLabelsSize));
    swapBytes(sIndicesSize,sizeof(sIndicesSize));
    swapBytes(optionsSize1,sizeof(optionsSize1));
    swapBytes(optionsSize2,sizeof(optionsSize2));
  end;
end;

procedure TIGORdescriptor.SwapWH2;
begin
  with WaveHeader2^ do
  begin
    swapBytes(typeW,sizeof(typeW));
    swapBytes(next,sizeof(next));

    swapBytes(whVersion,sizeof(whVersion));
    swapBytes(srcFldr,sizeof(srcFldr));
    swapBytes(HfileName,sizeof(HfileName));

    swapBytes(npnts,sizeof(npnts));

    swapBytes(aModified,sizeof(aModified));
    swapBytes(hsA,sizeof(hsA));
    swapBytes(hsB,sizeof(hsB));

    swapBytes(wModified,sizeof(wModified));
    swapBytes(swModified,sizeof(swModified));
    swapBytes(fsValid,sizeof(fsValid));
    swapBytes(topFullScale,sizeof(topFullScale));
    swapBytes(botFullScale,sizeof(botFullScale));

    swapBytes(formula,sizeof(formula));
    swapBytes(depID,sizeof(depID));
    swapBytes(creationDate,sizeof(creationDate));

    swapBytes(modDate,sizeof(modDate));
    swapBytes(waveNoteH,sizeof(waveNoteH));
  end;
end;

procedure TIGORdescriptor.SwapWH5;
var
  i:integer;
begin
  with WaveHeader5^ do
  begin
    swapBytes(creationDate,sizeof(creationDate));
    swapBytes(modDate,sizeof(modDate));

    swapBytes(npnts,sizeof(npnts));
    swapBytes(typeW,sizeof(typeW));
    swapBytes(dLock,sizeof(dLock));

    swapBytes(whVersion,sizeof(whVersion));
    swapBytes(whpad2,sizeof(whpad2));

    for i:=1 to MAXDIMS do
    begin
      swapBytes(nDim[i],sizeof(nDim[i]));
      swapBytes(sfA[i],sizeof(sfA[i]));
      swapBytes(sfB[i],sizeof(sfB[i]));
    end;

    swapBytes(fsValid,sizeof(fsValid));
    swapBytes(whpad3,sizeof(whpad3));
    swapBytes(topFullScale,sizeof(topFullScale));
    swapBytes(botFullScale,sizeof(botFullScale));

    swapBytes(dataEUnits,sizeof(dataEUnits));

    for i:=1 to MAXDIMS do
    begin
      swapBytes(dimEUnits[i],sizeof(dimEUnits[i]));
      swapBytes(dimLabels[i],sizeof(dimLabels[i]));
    end;

    swapBytes(waveNoteH,sizeof(waveNoteH));

  end;
end;

function TIGORdescriptor.isWH5: boolean;
begin
  result:=(version=5) or (version=$0500);
end;

function TIGORdescriptor.unitX: AnsiString;
var
  i:integer;
begin
  result:='';
  i:=0;
  if isWH5 then
    with waveHeader5^ do
    while(i<4) and (DimUnits[1,i+1]<>#0) do
    begin
      inc(i);
      result:=result+DimUnits[1,i];
    end
  else
    with waveHeader2^ do
    while(i<4) and (xUnits[i+1]<>#0) do
    begin
      inc(i);
      result:=result+xUnits[i];
    end;
end;

function TIGORdescriptor.unitY(num: integer): AnsiString;
var
  i:integer;
begin
  result:='';
  i:=0;
  if isWH5 then
    with waveHeader5^ do
    while(i<4) and (DataUnits[i+1]<>#0) do
    begin
      inc(i);
      result:=result+DataUnits[i];
    end
  else
    with waveHeader2^ do
    while(i<4) and (DataUnits[i+1]<>#0) do
    begin
      inc(i);
      result:=result+DataUnits[i];
    end;
end;

class function TIGORdescriptor.FileTypeName: AnsiString;
begin
  result:='IGOR wav';
end;

end.
