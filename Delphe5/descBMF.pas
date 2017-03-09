unit descBMF;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,sysutils,
     util1,dtf0,Spk0,ficDefAc,debug0,
     stmDef,descac1,bmf1;


type

  TbmfRec=record
            size:word;
            offset:integer;
            offsetData:integer;
            HeaderMod:BmfModuleHeader;
          case integer of
            1:(  signal:BMFsignal);
            2:(  xy:    BMFxySignal);
          end;
  PbmfRec=^TbmfRec;

  TBMFlist=class(Tlist)
             destructor destroy;override;
             procedure add(var m:BMFmoduleHeader;f:TfileStream;var ok:boolean);
           end;

  TBMFdescriptor=class(TfileDescriptor)
                 private
                    BMFlist:TBMFlist;

                    stDat:AnsiString;

                    Qnbvoie:integer;
                    NumModule:array[1..16] of integer;
                    Qnbpt:array[1..16] of integer;
                    typeData:array[1..16] of typetypeG;
                    chName:array[1..16] of AnsiString;

                    nbseqDat0:integer;
                    duree0:float;

                  public
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
                    function channelName(num:integer):AnsiString;override;

                    class function FileTypeName:AnsiString;override;
                  end;


IMPLEMENTATION

{****************** Méthodes de TBMFlist ************************************}

function getString(var t;long:integer):AnsiString;
begin
  setlength(result,long);
  move(t,result[1],long);
end;



destructor TBMFlist.destroy;
var
  i:integer;
begin
  for i:=0 to count-1 do freemem(Pbmfrec(items[i]),Pbmfrec(items[i])^.size);
  inherited destroy;
end;

procedure TBMFlist.add(var m:BMFmoduleHeader;f:TfileStream;var ok:boolean);
var
  recSize,addSize:integer;
  p:^TbmfRec;
  ident:AnsiString;
  res:intG;
begin
  try
  ident:=getString(m.ident,10);
  recSize:=sizeof(BMFmoduleHeader)+10;
  if ident=SignalType then addSize:=sizeof(BMFsignal)
  else
  if ident=XYSignalType then addSize:=sizeof(BMFxySignal)
  else addSize:=0;

  inc(recSize,addSize);
  getmem(p,recSize);
  p^.size:=recSize;
  p^.offset:=f.Position;
  p^.offsetData:=p^.offset+addSize;
  p^.HeaderMod:=m;
  f.read(p^.signal,addSize);

  inherited add(p);
  ok:=true;
  except
  ok:=false;
  end;
end;


{****************** Méthodes de TBMFdescriptor ******************************}

constructor TBMFdescriptor.create;
begin
  bmfList:=TbmfList.create;
end;

destructor TBMFdescriptor.destroy;
begin
  bmflist.destroy;
end;


function TBMFdescriptor.init(st:AnsiString):boolean;
  var
    FileHeader:   BmfFileHeader;
    ModuleHeader: BmfModuleHeader;

    ok:boolean;
    p0:integer;

    f:TfileStream;
    res:intG;

    stT:AnsiString;
    i:integer;

  begin
    result:=false;

    f:=nil;
  TRY
    stDat:=st;
    f:=TfileStream.create(stDat,fmOpenRead);

    storeFileParams(f);

    bmflist.clear;

    fillChar(FileHeader,sizeof(FileHeader),0);
    fillChar(ModuleHeader,sizeof(ModuleHeader),0);

    f.read(FileHeader,sizeof(FileHeader));

    if not( getString(FileHeader.ident,23)=BMFident) then
      begin
        f.free;
        exit;
      end;

    ok:=true;
    while ok do
    begin
      fillchar(ModuleHeader,sizeof(ModuleHeader),0);
      f.read(ModuleHeader,sizeof(ModuleHeader));
      p0:=f.Position;
      ok:=(getString(ModuleHeader.keyWord,6)=Module);
      if ok then bmflist.add(moduleHeader,f,ok);

      if ok then f.Position:=p0+ModuleHeader.size;
    end;
  f.free;
  except
  f.free;
  end;

  with bmfList do
  begin
    Qnbvoie:=0;
    nbSeqDat0:=0;
    for i:=0 to count-1 do
      with Pbmfrec(items[i])^ do
      begin
        if HeaderMod.ident=Signaltype then
          begin
            inc(Qnbvoie);
            NumModule[Qnbvoie]:=i;

            case signal.dataType of
              single_data:  typeData[Qnbvoie]:=G_single;
              integer_data: typeData[Qnbvoie]:=G_smallint;
              {else exit;}
            end;

            Qnbpt[Qnbvoie]:=signal.nbPointsEp;
            chName[Qnbvoie]:=getString(headerMod.title,25);

            if signal.nbEpisodes>nbSeqDat0 then nbSeqDat0:=signal.nbEpisodes;
          end;
      end;
  end;

  stT:='';
  with bmfList do
  for i:=0 to count-1 do
    with Pbmfrec(items[i])^ do
    begin
      stT:=stT+getString(HeaderMod.ident,10)+'  '+getString(HeaderMod.title,25);
      if HeaderMod.ident=Signaltype
        then stT:=stT+' '+Istr(signal.NbPointsEp)+'/'+Istr(signal.NbEpisodes)+#13+#10
                    +'   interval_us'+Estr(signal.interval_us,3)+#13+#10
                    +'   offset_us'+Estr(signal.offset_us,3)+#13+#10
                    +'   dataType='+Istr(signal.dataType)+#13+#10
                    {+signal.unitX+#13+#10}
                    {+signal.unitY+#13+#10}
                    +'   gain='+Estr(signal.gain,3)+#13+#10
                    +'   cutOffRate_hz='+Estr(signal.cutOffRate_hz,3)+#13+#10
                    +'   adcMaxScale='+Estr(signal.adcMaxScale_mv,3)+#13+#10
                    +'   adcNbBits='+Istr(signal.adcNbBits)+#13+#10
                    {+signal.epStartUnit+#13+#10}

        else stT:=stT+#13+#10;
    end;
//  messageCentral(stT);

  init:=true;
end;



function TBMFdescriptor.getData(voie,seq:integer;var evtMode:boolean):typeDataB;
var
  data0:typeDataB;
  i:integer;
  x0,y0,dx,dy:float;
  maxbit:integer;
  offsetS:integer;
begin
  getData:=nil;
  evtMode:=false;
  
  if (voie<1) or (voie>Qnbvoie) then exit;

  with Pbmfrec(bmfList.items[numModule[voie]])^,signal do
  begin
    if (seq<1) or (seq>nbEpisodes) then exit;

    x0:=0;
    dx:=Interval_us/1000;

    maxBit:=1;
    for i:=1 to ADCnbBits do maxbit:=maxbit*2;

    y0:=0;
    try
      if maxbit<>0 then dy:=ADCMaxScale_mV/maxbit;
      if gain<>0 then dy:=dy/Gain else dy:=1;
    except
      dy:=1;
    end;

    if typeData[voie]=G_single then dy:=1;

    offsetS:=offsetData+(seq-1)*nbPointsEp*tailleTypeG[typeData[voie]];
    case typedata[voie] of
       G_smallint: data0:=typedataFileI.create
                    (stdat,offsetS,1,0,nbpointsEp-1,false);
       G_single:  data0:=typedataFileS.create
                    (stdat,offsetS,1,0,nbpointsEp-1,false);

    end;
  end;
  { Windows n'accepte pas que l'on ouvre plusieurs fois le même fichier.
    Il faut donc fermer le fichier à chaque chargement du buffer }
  data0.setConversionX(Dx,X0);
  data0.setConversionY(Dy,Y0);

  getData:=data0;

end;

function TBMFdescriptor.getTpNum(voie,seq:integer):typetypeG;
begin
  getTpNum:=typeData[voie];
end;


function TBMFdescriptor.nbVoie:integer;
begin
  nbvoie:=Qnbvoie;
end;

function TBMFdescriptor.nbSeqDat:integer;
begin
  nbseqDat:=nbSeqDat0;
end;

function TBMFdescriptor.nbPtSeq(voie:integer):integer;
begin
  nbPtSeq:=Qnbpt[voie]
end;


function TBMFdescriptor.FichierContinu:boolean;
begin
  FichierContinu:=false;
end;

procedure TBMFdescriptor.displayInfo;
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

    for i:=1 to nbvoie do
      with Pbmfrec(bmfList.items[numModule[i]])^,signal do
      begin
        writeln('          Voie '+Istr(i));
        writeln(Istr(Qnbpt[i])+' samples' );
        writeln('Episode duration:'+Estr1(nbPointsEp*interval_us/1000,10,3)+' ms');
        write(Istr(nbEpisodes)+' episode');
        if nbEpisodes>1 then write('s');
      end;

    done;
  end;

end;

function TBMFdescriptor.channelName(num:integer):AnsiString;
begin
  channelName:=chName[num];
end;



class function TBMFdescriptor.FileTypeName: AnsiString;
begin
  result:='BMF';
end;

end.
