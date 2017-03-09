unit DescLabchart1;

Interface
uses windows,classes,sysUtils,
     util1,dtf0,Spk0,ficDefAc,debug0,descac1,
     stmDef,Mtag0,Mtag2;


type
  TLabchartFileHeader= record
      magic: array[1..4] of AnsiChar;
      Version: integer;
      SecPerTick: double;
      Year: integer;
      Month: integer;
      Day: integer;
      Hour: integer;
      Minute: integer;
      Seconds: double;
      trigger: double;
      Nchannels: integer;
      SamplesPerChannel: integer;
      TimeChannel:integer;
      DataFormat: integer;
    end;

  TLabchartChannelHeader=record
      Title: array[1..32] of AnsiChar;
      Units: array[1..32] of AnsiChar;
      scale: double;
      offset: double;
      RangeHigh: double;
      RangeLow: double;
    end;


  TLabchartDescriptor=class(TfileDescriptor)
                  private
                    FileHeader: TLabchartFileHeader;
                    ChannelHeader: array of TLabchartChannelHeader;

                    stDat: AnsiString;
                  public
                    property Nchannels:integer read FileHeader.Nchannels;
                    property DataFormat: integer read FileHeader.DataFormat;
                    property SamplesPerChannel: integer read FileHeader.SamplesPerChannel;
                    property SecPerTick: double read FileHeader.SecPerTick;

                    constructor create;override;
                    destructor destroy;override;

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


IMPLEMENTATION

{****************** Méthodes de TLabchartDescriptor ******************************}

constructor TLabchartDescriptor.create;
begin
end;

destructor TLabchartDescriptor.destroy;
begin

end;


function TLabchartDescriptor.init(st:AnsiString):boolean;
var
  f:TfileStream;
  i:integer;

begin
  result:=false;
  stDat:=st;
  f:=nil;

  try
  f:=TfileStream.create(st,fmOpenRead);
  storeFileParams(f);
  f.Read(FileHeader,sizeof(FileHeader));

  with FileHeader do
  if (magic[1]<>'C') or (magic[2]<>'F') or (magic[3]<>'W') or (magic[4]<>'B')
     OR
     (Nchannels<1) or (Nchannels>100) then
  begin
    f.free;
    exit;
  end;

  setlength(channelHeader,FileHeader.Nchannels);
  f.read(channelHeader[0], sizeof(channelHeader[0])*FileHeader.Nchannels);
  result:=true;

  finally
  f.Free;
  end;

end;



function TLabchartDescriptor.getData(voie,seq:integer;var evtMode:boolean):typeDataB;
var
  offsetS:integer;
  data0:typeDataB;
  SampSize:integer;
begin
  if (voie<1) or (voie>Nchannels) or (seq>1) then
    begin
      result:=nil;
      exit;
    end;

  OffsetS:=sizeof(TLabchartFileHeader)+sizeof(TLabchartChannelHeader)*Nchannels;

  case DataFormat of
    1: begin
         data0:=typedataFileD.create(stdat,offsetS+(voie-1)*8,Nchannels,0,SamplesPerChannel-1,false);
         data0.setConversionY(1,0);
       end;
    2: begin
         data0:=typedataFileS.create(stdat,offsetS+(voie-1)*4,Nchannels,0,SamplesPerChannel-1,false);
         data0.setConversionY(1,0);
       end;
    3: begin
         data0:=typedataFileI.create(stdat,offsetS+(voie-1)*2,Nchannels,0,SamplesPerChannel-1,false);
         with ChannelHeader[voie-1] do data0.setConversionY(scale,scale*offset);
       end;
  end;

  data0.setConversionX(SecPerTick,0);
  result:=data0;
end;

function TLabchartDescriptor.getTpNum(voie,seq:integer):typetypeG;
begin
  case DataFormat of
    1: result:= g_double;
    2: result:= g_single;
    3: result:= g_smallint;
  end;
end;


function TLabchartDescriptor.nbVoie:integer;
begin
  result:= Nchannels;
end;

function TLabchartDescriptor.nbSeqDat:integer;
begin
  result:=1;
end;

function TLabchartDescriptor.nbPtSeq(voie:integer):integer;
begin
  result:= SamplesPerChannel;
end;


function TLabchartDescriptor.FichierContinu:boolean;
begin
  result:=true;
end;

procedure TLabchartDescriptor.displayInfo;
var
  BoiteInfo:typeBoiteInfo;
  i,j:integer;
begin
  with BoiteInfo do
  begin
    BoiteInfo.init('File Informations');

    writeln(extractFileName(stDat)+'  '+Udate(DateD)+'  '+Utime(DateD) );
    write(Istr(nbVoie)+' channel ');
    if nbvoie>1 then write('s');

    writeln('Duration:    '+Estr1(SamplesPerChannel*SecPerTick,10,3)+' sec');
    writeln('Sampling interval per channel:'+Estr1(SecPerTick,10,6)+' sec');


    done;
  end;

end;



function TLabchartDescriptor.unitX: AnsiString;
begin
  result:= 'sec';
end;

function TLabchartDescriptor.unitY(num:integer): AnsiString;
begin
  with ChannelHeader[num-1] do
  result:= tabToString(Units,32);
end;

class function TLabchartDescriptor.FileTypeName: AnsiString;
begin
  result:='Labchart Binary File';
end;

end.
