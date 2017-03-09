unit descdac2B;

{Dans une version Beta, plusieurs paramètres integer étaient déclarés Smallint.
Pour pouvoir charger les fichiers data enregistrés pendant cette période, on déclare
le descripteur TDAC2DescriptorB}

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, Classes,SysUtils,
     util1,dtf0,descac1,spk0,blocInf0,debug0,
     stmDef;


{ un fichier DAC2 commence par typeHeaderDac2: le mot clé permet d'identifier le
  type de fichier. TailleInfo donne la taille totale du bloc d'info qui précède les
  données.

  On trouve ensuite plusieurs sous-blocs qui commencent tous par un enregistrement
  de type typeHeaderDac2 (id+taille).

  Le premier bloc est appelé 'MAIN' et contient typeInfoDac2
  Ensuite, on pourra trouver zéro plusieurs blocs. Par exemple, un bloc 'STIM'
  et un bloc 'USER INFO' .
}
const
  signatureDAC2='DAC2/GS/2000';
  signatureDAC2Seq='DAC2SEQ';
  signatureDAC2main='MAIN';


type
  typeHeaderDac2B=object
                   id:string[15];      {garder 15 comme pour Acquis1}
                   tailleInfo:smallint;
                   procedure init(taille:integer);
                   procedure init2(ident:AnsiString;taille:integer);
                   procedure write(f:TfileStream);
                 end;

  TAdcChannel=record
                uY:string[10];
                Dyu,Y0u:double;
              end;

  TextraInfoSeq=record
                end;


  typeInfoSeqDAC2B=
              object
                id:string[7];    {'DAC2SEQ'}
                tailleInfo:smallint;

                nbvoie:byte;
                nbpt:integer;
                tpData:typeTypeG;

                postSeqI:integer;

                uX:string[10];
                Dxu,x0u:double;

                adcChannel:array[1..16] of TAdcChannel;

                extraInfo:TextraInfoSeq;

                procedure init(nbvoie1:integer);
                procedure write(f:TfileStream);
                function seqSize:integer;
                function dataSize:integer;
              end;


  typeInfoDAC2B=
              object
                id:string[15];      {garder 15 comme pour Acquis1}
                tailleInfo:smallint;

                nbvoie:byte;
                nbpt:integer;
                tpData:typeTypeG;

                uX:string[10];
                Dxu,x0u:double;

                adcChannel:array[1..16] of TAdcChannel;

                preseqI,postSeqI:smallint;
                continu:boolean;
                VariableEp:boolean;
                WithTags:boolean;

                procedure init(taille:integer);
                procedure write( f:TfileStream);
                procedure setInfoSeq(var infoSeq:typeInfoSeqDAC2B);
                function controleOK:boolean;
              end;



  TDAC2DescriptorB=
               class(TAC1Descriptor)
                 private
                    infoDac2:typeInfoDAC2B; { Bloc info brut tiré du fichier }
                    HeaderSize:integer;

                 protected

                  public
                    constructor create;override;
                    destructor destroy;override;

                    procedure readExtraInfo(f:TfileStream);
                    function initDF(st:AnsiString):boolean;

                    function init(st:AnsiString):boolean;override;
                    function nbvoie:integer;override;
                    function getData(voie,seq:integer;var evtMode:boolean):typeDataB;override;
                    function getTpNum(voie,seq:integer):typetypeG;override;
                    function getDataTag(voie,seq:integer):typeDataB;override;

                    function FichierContinu:boolean;override;

                    procedure displayInfo;override;
                    function unitX:AnsiString;override;
                    function unitY(num:integer):AnsiString;override;

                    function FileheaderSize:integer;

                    class function FileTypeName:AnsiString;override;
                  end;



implementation

{************************ Méthodes de TypeHeaderDAC2 ***********************}

procedure TypeHeaderDAC2B.init(taille:integer);
begin
  fillchar(id,sizeof(id),0);
  id:=signatureDAC2;
  tailleInfo:=taille;
end;

procedure TypeHeaderDAC2B.init2(ident:AnsiString;taille:integer);
begin
  fillchar(id,sizeof(id),0);
  id:=ident;
  tailleInfo:=taille;
end;

procedure TypeHeaderDAC2B.write(f:TfileStream);
begin
  f.Write(self,sizeof(TypeHeaderDAC2B));
end;

{************************ Méthodes de TypeInfoDAC2 ***********************}

procedure TypeInfoDAC2B.init(taille:integer);
var
  i:integer;
begin
  fillchar(id,sizeof(id),0);
  id:=signatureDac2Main;
  tailleInfo:=taille;
  nbvoie:=1;
  nbpt:=1000;
  uX:='';
  Dxu:=1;
  x0u:=0;

  for i:=1 to 16 do
    with adcChannel[i] do
    begin
      y0u:=0;
      dyu:=1;
      uy:='';
    end;

  continu:=false;
  preseqI:=0;
  postSeqI:=0;

  tpData:=G_smallint;
end;

procedure TypeInfoDAC2B.write(f:TfileStream);
begin
  f.Write(self,sizeof(TypeInfoDAC2B));
end;


procedure TypeInfoDAC2B.setInfoSeq(var infoSeq:typeInfoSeqDAC2B);
var
  i:integer;
begin
  infoSeq.init(nbvoie);

  infoSeq.nbvoie:=nbvoie;
  infoSeq.tpData:=tpData;

  infoSeq.postSeqI:=postSeqI;

  infoSeq.ux:=ux;
  infoSeq.dxu:=dxu;
  infoSeq.x0u:=x0u;
    for i:=1 to nbvoie do
      infoSeq.adcChannel[i]:=adcChannel[i];

end;

function typeInfoDac2B.controleOK:boolean;
var
  i:integer;
begin
  result:=false;
  if (nbvoie<0) or (nbvoie>16) then
   begin
      messageCentral('Anomalous number of channels: '+Istr(nbvoie));
      exit;
    end;

  if not (tpData in [G_smallint,G_single]) then
    begin
      messageCentral('Unrecognized number type '+Istr(byte(tpData)));
      exit;
    end;

  if dxu<=0 then
    begin
      messageCentral('Anomalous X-scale parameters' );
      exit;
    end;

  for i:=1 to nbvoie do
    if adcChannel[i].Dyu=0 then
      begin
        messageCentral('Anomalous Y-scale parameters');
        exit;
      end;


  result:=true;
end;

{******************** Méthodes de typeInfoSeqDAC2B *************************}

procedure typeInfoSeqDAC2B.init(nbvoie1:integer);
var
  i:integer;
begin
  id:=signatureDAC2Seq;
  tailleInfo:=sizeof(typeInfoSeqDAC2B)-sizeof(TadcChannel)*(16-nbvoie1);
  nbvoie:=nbvoie1;
  nbpt:=1000;
  uX:='';
  Dxu:=1;
  x0u:=0;

  for i:=1 to 16 do
    with adcChannel[i] do
    begin
      y0u:=0;
      dyu:=1;
      uy:='';
    end;

  postSeqI:=0;

  tpData:=G_smallint;

end;


procedure typeInfoSeqDAC2B.write(f:TfileStream);
begin
  f.Write(self,tailleInfo);
end;

function typeInfoSeqDAC2B.DataSize:integer;
begin
  result:=nbpt*nbvoie*tailleTypeG[tpData];
end;

function typeInfoSeqDAC2B.seqSize:integer;
begin
  result:=tailleInfo+dataSize+postSeqI;
end;


{****************** Méthodes de TDAC2DescriptorB ******************************}

constructor TDAC2DescriptorB.create;
begin
  inherited;
end;

destructor TDAC2DescriptorB.destroy;
begin
  inherited;
end;

procedure TDAC2DescriptorB.readExtraInfo( f:TfileStream);
var
  header:TypeHeaderDAC2B;
  p:integer;
  res:intG;
  userBlockSize:integer;
begin
  while (f.Position<HeaderSize-1)  do
  begin
    p:=f.Position;
    f.read(header,sizeof(header));
    if header.Id='USER INFO' then
      begin
        UserBlockSize:=header.tailleInfo-sizeof(header);
        BlocFileInfo.free;
        BlocFileInfo:=TblocInfo.create(UserBlockSize);
        FileInfoOffset:=f.Position;
        BlocFileInfo.read(f);
      end
    else exit;
  end;
end;

{$O-}
function TDAC2DescriptorB.initDF(st:AnsiString):boolean;
var
  res:intG;
  i:integer;
  f:TfileStream;
  headerDac2:TypeHeaderDAC2B;
begin
  initDF:=false;

  stDat:=st;
  f:=nil;

  TRY
  f:=TfileStream.create(stDat,fmOpenRead);
  dateD:=FileGetDate(f.Handle);

  {Identifier d'abord le fichier}
  fillchar(headerDAc2,sizeof(headerDAc2),0);
  f.read(headerDAc2,sizeof(headerDAc2));
  if (headerDAc2.id<>signatureDAC2) then
    begin
      f.free;
      exit;
    end;

  headerSize:=headerDac2.tailleInfo;

  {Lire infoDac2}
  fillchar(infoDAc2,sizeof(infoDAc2),0);
  f.read(infoDAc2,sizeof(infoDAc2));

  if (infoDAc2.id<>SignatureDAC2main) then
    begin
      f.free;
      exit;
    end;

  {Controler le contenu de infoDac2}
  if not infoDac2.controleOK then
   begin
      f.free;
      exit;
    end;

  {en cas d'oubli, ajuster preseqI et postSeqI}
  with infoDac2 do
  if continu then
    begin
      preSeqI:=0;
      postSeqI:=0;
    end;

  SampleSize:=tailleTypeG[infoDac2.tpData];

  if infoDac2.continu
    then nbptSeq0:=(f.size-headerSize) div (infoDac2.nbvoie*sampleSize)
    else nbptSeq0:=infoDac2.nbpt;


  longueurDat:=f.size-headerSize;
  with infoDac2 do
     tailleSeq:=preseqI+postSeqI+nbptSeq0*sampleSize*nbvoie;

  if nbPtSeq0<>0
    then nbSeqDat0:=(f.size-headerSize) div tailleSeq
    else nbSeqDat0:=0;

  readExtraInfo(f);
  

  duree0:=infoDac2.dxu*nbPtSeq0;

  BlocEpInfo.free;
  BlocEpInfo:=TblocInfo.create(infoDac2.postSeqI);

  result:=true;
  f.free;
  Except
  f.free;
  result:=false;
  End;

  {messageCentral('Dxu='+Estr(infoDac2.Dxu,6));}
end;

function TDAC2DescriptorB.init(st:AnsiString):boolean;
  begin
    Fdat:=initDF(st);
    if Fdat then
      begin
        Fevt:=initEvt(ChangeFileExt(st,'.EVT'));
        if Fevt then       {cas de fichier DAT + fichier EVT }
          begin
            if nbSeqDat0<statEv.count then nbSeqDat0:=statEv.count;
            if nbSeqDat0=0 then nbSeqDat0:=1;
          end;
      end
    else
      begin                {cas de fichier EVT seul }
        Fevt:=initEvt(st);
        if FEvt then
          begin
            nbseqDat0:=statEv.count;
            nbptSeq0:=0;
            duree0:=statEv.dureeSeqSP;
          end;
      end;
    init:=Fdat or Fevt;
  end;

function TDAC2DescriptorB.getData(voie,seq:integer;var evtMode:boolean):typeDataB;
var
  infoSeq:typeInfoSeqDAC2B;
  res:intG;
  f:TfileStream;
  i:integer;
  offsetS:integer;
  data0:typeDataB;
begin
  getData:=nil;
  evtMode:=false;
  if not Fdat or (voie<1) or (voie>nbvoie) or (seq>nbseqDat) then exit;

  numSeqC:=seq;

  with infoDac2 do
  begin
    offsetS:=headerSize+(seq-1)*tailleSeq;

    f:=nil;
    TRY
    f:=TfileStream.create(stDat,fmOpenRead);

    {lire et copier les info séquence dans infoDac2}
    if not continu then
      begin
        f.Position:=offsetS;
        fillchar(infoSeq,sizeof(infoSeq),0);
        f.read(infoSeq,preSeqI);

        infoDac2.uX:=infoSeq.ux;
        infoDac2.Dxu:=infoSeq.Dxu;
        infoDac2.X0u:=infoSeq.x0u;

        for i:=1 to nbvoie do
          infoDac2.adcChannel[i]:=infoSeq.adcChannel[i];
      end
    else preseqI:=0;

    if ((voie=1) or (voie=0)) and (postSeqI<>0) then
      begin
        f.Position:=offsetS+tailleSeq-postSeqI;
        BlocEpInfo.read(f);
      end;

    f.free;
    Except
    f.Free;
    exit;
    End;

    if nbvoie=0 then exit;

    offsetS:=offsetS+preseqI+sampleSize*(voie-1);

    case Tpdata of
       G_smallint: if withTags then
                  data0:=typedataFileIdigi.create
                    (stdat,offsetS,nbvoie,0,nbptSeq0-1,false,4)
                  else
                  data0:=typedataFileI.create
                    (stdat,offsetS,nbvoie,0,nbptSeq0-1,false);
       G_single:  data0:=typedataFileS.create
                    (stdat,offsetS,nbvoie,0,nbptSeq0-1,false);

    end;
    data0.setConversionX(Dxu,X0u);
    data0.setConversionY(AdcChannel[voie].Dyu,AdcChannel[voie].Y0u);
  end;
  getData:=data0;
    {messageCentral('Dxu='+Estr(infoDac2.Dxu,6)+' '+infoDac2.ux);}
end;

function TDAC2DescriptorB.getTpNum(voie,seq:integer):typetypeG;
begin
  if Fdat then getTpNum:=infoDac2.tpdata
          else getTpNum:=G_smallint;
end;

function TDAC2DescriptorB.getDataTag(voie,seq:integer):typeDataB;
var
  res:intG;
  f:file;
  i:integer;
  offsetS:integer;
  data0:typeDataB;
begin
  getDataTag:=nil;
  if not Fdat or (voie<1) or (voie>2) or (seq>nbseqDat) or not infoDAc2.withTags
    then exit;

  numSeqC:=seq;

  with infoDac2 do
  begin
    if nbvoie=0 then exit;

    offsetS:=headerSize+(seq-1)*tailleSeq+preseqI;

    data0:=typedataFileDigiTag.create
                    (stdat,offsetS,nbvoie,0,nbptSeq0-1,false,voie) ;

    data0.setConversionX(Dxu,X0u);
  end;

  

  getDataTag:=data0;
end;



function TDAC2DescriptorB.nbVoie:integer;
begin
  if Fdat then nbvoie:=infoDac2.nbvoie
          else nbvoie:=0;
end;


function TDAC2DescriptorB.FichierContinu:boolean;
begin
  FichierContinu:=Fdat and infoDac2.continu;
end;

procedure TDAC2DescriptorB.displayInfo;
var
  BoiteInfo:typeBoiteInfo;
  i,j:integer;
begin
  with BoiteInfo do
  begin
    BoiteInfo.init('File Informations');

    writeln(ExtractFileName(stDat)+'  '+Udate(DateD)+'  '+Utime(DateD) );
    writeln('Format: DAC2 version B');
    writeln('Header size: '+Istr(infoDac2.tailleInfo));
    writeln('Episode header size: '+Istr(infoDac2.preseqI));
    writeln('Episode info size: '+Istr(infoDac2.postSeqI));

    if Fdat then
      begin
        write(Istr(nbVoie)+' channel');
        if nbvoie>1 then write('s ') else write(' ');;

        if not FichierContinu then
          begin
            writeln('  '+Istr(nbPtSeq0)+' samples/channel' );
            writeln('Episode duration:'+Estr1(Duree0,10,3)+' '+infoDac2.uX);
            write(Istr(nbSeqDat)+' episode');
            if nbSeqDat>1 then writeln('s') else writeln('');
          end
        else
          begin
            writeln('         Continuous file');
            writeln('Duration:    '+Estr1(Duree0,10,3)+' '+infoDac2.uX);
            writeln('Sampling interval per channel:'+Estr1(infoDac2.Dxu,10,6)+' '+infoDac2.uX);
          end;

        writeln('File info block size='+Istr(BlocFileInfo.tailleBuf));
        writeln('Episode info block size='+Istr(infoDac2.postSeqI));

      end;

    if assigned(statEv) then
      begin
        writeln('');
        writeln('  Numbers of events');

        for i:=0 to 3 do
          begin
            for j:=1 to 4 do
              write(Jgauche('E'+Istr(i*4+j)+':',5)
                    +Istr1(statEV.ntot[i*4+j-1],5)+' ');
            writeln('');
          end;
      end;


    done;
  end;

end;

function TDAC2DescriptorB.unitX:AnsiString;
begin
  if Fdat
    then unitX:=infoDac2.ux
    else unitX:=statEv.unitXSP;
end;

function TDAC2DescriptorB.unitY(num:integer):AnsiString;
begin
  if Fdat
    then unitY:=infoDac2.adcChannel[num].uy
    else unitY:='';
end;


function TDAC2DescriptorB.FileheaderSize:integer;
begin
  FileheaderSize:=HeaderSize;
end;



class function TDAC2DescriptorB.FileTypeName: AnsiString;
begin
  result:='DAC2 beta';
end;

end.
