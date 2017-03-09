unit DescBinary1;


INTERFACE


uses windows,classes,sysUtils,
     util1,dtf0, descac1,
     stmDef;


type
  TbinaryRec=  record
                 HeaderSize:integer;
                 DataSize:int64;
                 NumType: typetypeG;
                 Nchannel: integer;
                 FMux: boolean;
                 Continuous: boolean;
                 SamplePerEpisode: integer;
                 Dx: double;
                 x0: double;
                 unitX: string[20];
                 Dy: double;
                 y0: double;
                 unitY: string[20];
               end;

  TbinaryDescriptor= class( TfileDescriptor )
                  public
                    binRec: TbinaryRec;

                    stDat: Ansistring;
                    dateD: integer;
                    FileAgeD: TdateTime;

                    EpSize: integer;

                    constructor create;override;
                    destructor destroy;override;

                    procedure InitParams(rec:TbinaryRec);
                    function init(st:AnsiString):boolean;override;
                    procedure initEpisod(num:integer);override;
                    function nbvoie:integer;override;
                    function nbSeqDat:integer;override;
                    function nbPtSeq(voie:integer):integer;override;

                    function getData(voie,seq:integer;var EvtMode:boolean):typeDataB;override;
                    function getTpNum(voie,seq:integer):typetypeG;override;
                    function FichierContinu:boolean;override;

                    procedure displayInfo;override;
                    function unitX:AnsiString;override;
                    function unitY(num:integer):AnsiString;override;

                    function FileheaderSize:integer;override;

                    class function FileTypeName:AnsiString;override;


                  end;


procedure BinaryRecToStringList(var rec: TbinaryRec; stText:TstringList);
procedure StringListToBinaryRec(stText:TStringList;var rec: TbinaryRec);


IMPLEMENTATION

{ TbinaryDescriptor }

constructor TbinaryDescriptor.create;
begin
  inherited;

end;

destructor TbinaryDescriptor.destroy;
begin

  inherited;
end;

procedure TbinaryDescriptor.displayInfo;
begin
  inherited;

end;

function TbinaryDescriptor.FichierContinu: boolean;
begin
  result:=binRec.Continuous;
end;

function TbinaryDescriptor.FileheaderSize: integer;
begin
  result:=binRec.HeaderSize;
end;

class function TbinaryDescriptor.FileTypeName: AnsiString;
begin
  result:= 'Binary';
end;


function TbinaryDescriptor.getData(voie, seq: integer;  var EvtMode: boolean): typeDataB;
var
  offset: int64;
  nbp: integer;
begin
  EvtMode:= false;
  
  with binRec do
  begin
    if Fmux then
    begin
      offset:= HeaderSize +(voie-1)* tailleTypeG[binrec.NumType]  +EpSize*(seq-1);
      nbp:= nbPtSeq(1);
      case NumType of
         G_smallint,
         g_word:   result:= typedataFileI.create( stdat, offset, Nchannel, 0,nbp-1,false);
         G_single: result:= typedataFileS.create( stdat, offset, Nchannel, 0,nbp-1,false);
      end;
    end
    else
    begin
      nbp:= nbPtSeq(1);
      offset:= HeaderSize +(voie-1)*nbp*tailleTypeG[NumType]  +EpSize*(seq-1);
      
      case NumType of
         G_smallint,
         g_word:   result:= typedataFileI.create( stdat, offset, 1, 0,nbp-1,false);
         G_single: result:= typedataFileS.create( stdat, offset, 1, 0,nbp-1,false);
      end;
    end;
  end;

  if assigned(result) then
  begin
    result.setConversionX(binrec.Dx,binrec.X0);
    result.setConversionY(binrec.Dy,binrec.y0);
  end;
end;

function TbinaryDescriptor.getTpNum(voie, seq: integer): typetypeG;
begin
  result:= binrec.NumType;
end;

function TbinaryDescriptor.init(st: AnsiString): boolean;
var
  f:TfileStream;
begin
  stDat:=st;
  result:=false;
  f:=nil;

  try
  f:=TfileStream.create(st,fmOpenRead);
  storeFileParams(f);
  result:= true;
  finally
  f.Free;
  end;

  EpSize:=  binrec.SamplePerEpisode* tailleTypeG[binRec.NumType]*binrec.Nchannel;
  if not binrec.Continuous and (binrec.HeaderSize+EpSize>FileSizeD) then result:=false;
end;

procedure TbinaryDescriptor.initEpisod(num: integer);
begin
  inherited;

end;

procedure TbinaryDescriptor.InitParams(rec: TbinaryRec);
begin
  binrec:=rec;
end;

function TbinaryDescriptor.nbPtSeq(voie: integer): integer;
begin
  if not FichierContinu
    then result:=binrec.SamplePerEpisode
    else result:=(fileSizeD-binrec.headerSize) div (binrec.Nchannel*tailleTypeG[binrec.numType]);
end;

function TbinaryDescriptor.nbSeqDat: integer;
begin
  if not FichierContinu
    then result:= (fileSizeD-binrec.headerSize) div EpSize
    else result:=1;
end;

function TbinaryDescriptor.nbvoie: integer;
begin
  result:= binRec.Nchannel;
end;

function TbinaryDescriptor.unitX: AnsiString;
begin
  result:= binrec.unitX;
end;

function TbinaryDescriptor.unitY(num: integer): AnsiString;
begin
  result:= binrec.unitY;
end;

procedure BinaryRecToStringList(var rec: TbinaryRec; stText:TstringList);
begin
  stText.Clear;
  with rec do
  begin
    stText.add('HeaderSize='+Istr(HeaderSize));
    stText.add('DataSize='+Istr(DataSize));
    stText.add('NumType='+typeNameG[NumType]);
    stText.add('Nchannel='+Istr(Nchannel));
    stText.add('FMux='+Bstr(FMux));
    stText.add('Continuous='+Bstr(Continuous));
    stText.add('SamplePerEpisode='+Istr(SamplePerEpisode));
    stText.add('Dx='+Estr0(Dx));
    stText.add('x0='+Estr0(x0));
    stText.add('unitX='+unitX);
    stText.add('Dy='+Estr0(Dy));
    stText.add('y0='+Estr0(y0));
    stText.add('unitY='+unitY);
  end;

end;

procedure StringListToBinaryRec(stText:TStringList;var rec: TbinaryRec);
var
  st, st1,st2: ansiString;
  i,k: integer;
begin
  for i:= 0 to stText.Count-1 do
  begin
    st:=stText[i];
    k:= pos('=',st);
    if k<2 then exit;

    st1:=upperCase(copy(st,1,k-1));

    delete(st,1,k);
    st2:=Fsupespace(st);
    st2:= uppercase(st2);

    if st1='HEADERSIZE' then rec.HeaderSize:= valI(st2)
    else
    if st1='DATASIZE' then rec.DataSize:= valI(st2)
    else
    if st1='NUMTYPE' then rec.NumType:= TypeNameToTypeG(st2)
    else
    if st1='NCHANNEL' then rec.DataSize:= valI(st2)
    else
    if st1='FMUX' then rec.Fmux:= (st2='TRUE')
    else
    if st1='CONTINUOUS' then rec.Continuous:= (st2='TRUE')
    else
    if st1='SAMPLEPEREPISODE' then rec.SamplePerEpisode:= valI(st2)
    else
    if st1='DX' then rec.Dx:= valR(st2)
    else
    if st1='X0' then rec.X0:= valR(st2)
    else
    if st1='UNITX' then rec.UnitX:= st
    else
    if st1='DY' then rec.Dy:= valR(st2)
    else
    if st1='Y0' then rec.Y0:= valR(st2)
    else
    if st1='UNITY' then rec.UnitY:= st;

  end;
end;


end.
