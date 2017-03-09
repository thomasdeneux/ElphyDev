unit descdac2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, classes, sysutils,
     util1,dtf0,descac1,spk0,blocInf0,debug0,Mtag0,Mtag2,
     FdefDac2,stmDef,
     acqDef2
     ;


type
  TDAC2Descriptor=
               class(TAC1Descriptor)
                 private
                    infoDac2:typeInfoDAC2; { Bloc info brut tiré du fichier }
                    HeaderSize:integer;
                    Mtag:PMtagArray;
                    MtagOffset:integer;    {offset du bloc MtagOffset, y compris header}
                    CommentOffset:integer; {idem}

                 protected

                 public

                    constructor create;override;
                    destructor destroy;override;

                    procedure readExtraInfo(f:TfileStream);
                    function initDF(st:AnsiString):boolean;

                    function init(st:AnsiString):boolean;override;
                    function nbvoie:integer;override;

                    function NbVoiesAnalog:integer;override;

                    function getData1(voie,seq:integer):typeDataB;override;
                    function getTpNum(voie,seq:integer):typetypeG;override;
                    function getDataTag(voie,seq:integer):typeDataB;override;

                    function FichierContinu:boolean;override;

                    procedure displayInfo;override;
                    function unitX:AnsiString;override;
                    function unitY(num:integer):AnsiString;override;

                    function FileheaderSize:integer;override;
                    function getInfoDac2:PinfoDac2;
                    function getFileInfoCopy:TblocInfo;

                    function getMtag(numseq:integer):PMtagArray;override;
                    property getMtagOffset:integer read MtagOffset;

                    property getCommentOffset:integer read CommentOffset;

                    procedure getElphyTag(numseq:integer;var tags:TtagRecArray;
                                var x0u,dxu:float);override;

                    class function FileTypeName:AnsiString;override;
                  end;


implementation


{****************** Méthodes de TDAC2descriptor ******************************}

constructor TDAC2Descriptor.create;
begin
  inherited;
end;

destructor TDAC2Descriptor.destroy;
begin
  if assigned(Mtag) then Freemem(Mtag,Mtag^.size);

  inherited;
end;

procedure TDAC2Descriptor.readExtraInfo(f:TfileStream);
var
  header:typeHeaderDac2;
  p:integer;
  res:intG;
  USize:integer;
begin
  Usize:=1;
  while (f.Position<HeaderSize-1) and(Usize>0) do
  begin
    p:=f.Position;
    f.read(header,sizeof(header));

    {messageCentral(header.id);}
    USize:=header.tailleInfo-sizeof(header);
    if header.Id='USER INFO' then
      begin
        BlocFileInfo.free;
        BlocFileInfo:=TblocInfo.create(USize);
        FileInfoOffset:=f.Position;
        BlocFileInfo.read(f);
      end
    else
    if header.Id='COMMENT' then
      begin
        if (USize>0) and (USize<maxAvail) then
          begin
            setlength(comment,USize);
            CommentOffset:=f.Position-sizeof(header);
            f.read(comment[1],USize);
            comment:=FsupespaceFin(comment);
          end;
      end
    else
    if header.id='MTAG' then
      begin
        getmem(Mtag,Usize);
        MtagOffset:=f.Position-sizeof(header);
        f.Read(Mtag^,Usize);
      end
    else

    if header.id='DAC2STIM' then
      begin
      end
    else
    if header.id='ACQINF' then
      begin
      end;

    f.Position:=p+header.tailleInfo;
  end;
end;

{$O-}
function TDAC2Descriptor.initDF(st:AnsiString):boolean;
var
  res:intG;
  i:integer;
  f:TfileStream;
  headerDac2:typeHeaderDac2;
begin
  initDF:=false;

  stDat:=st;
  f:=nil;
  TRY
  f:=TfileStream.create(stDat,fmOpenRead);

  storeFileParams(f);

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
  with infoDac2 do f.read(infoDAc2,sizeof(typeHeaderDac2));
  f.read(infoDAc2.nbvoie,infoDAc2.tailleInfo-sizeof(typeHeaderDac2));

  if infoDAc2.id<>SignatureDAC2main then
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
  begin
    if continu then
      begin
        preSeqI:=0;
        postSeqI:=0;
      end;
    if withTags and (TagShift=0) then tagShift:=4;
  end;

  SampleSize:=tailleTypeG[infoDac2.tpData];

  if infoDac2.continu then
    begin
      if infoDac2.nbvoie>0
        then nbptSeq0:=(f.Size-headerSize) div (infoDac2.nbvoie*sampleSize)
        else nbptSeq0:=0;
    end
  else nbptSeq0:=infoDac2.nbpt;


  longueurDat:=f.Size-headerSize;
  with infoDac2 do
     tailleSeq:=preseqI+postSeqI+nbptSeq0*sampleSize*nbvoie;

  if nbPtSeq0<>0
    then nbSeqDat0:=(f.Size-headerSize) div tailleSeq
    else nbSeqDat0:=0;

  readExtraInfo(f);


  duree0:=infoDac2.dxu*nbPtSeq0;

  BlocEpInfo.free;
  BlocEpInfo:=TblocInfo.create(infoDac2.postSeqI);

  result:=true;
  f.free;
  Except
  result:=false;
  f.Free;
  end;

  {messageCentral('Dxu='+Estr(infoDac2.Dxu,6));}
end;

function TDAC2Descriptor.init(st:AnsiString):boolean;
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

function TDAC2descriptor.getData1(voie,seq:integer):typeDataB;
var
  infoSeq:typeInfoSeqDAC2;
  res:intG;
  f:TfileStream;
  i:integer;
  offsetS:integer;
  data0:typeDataB;
begin
  result:=nil;
  if not Fdat or (voie<0) or (voie>infoDac2.nbvoie) or (seq>nbseqDat) then exit;

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

        for i:=1 to infoDac2.nbvoie do
          infoDac2.adcChannel[i]:=infoSeq.adcChannel[i];
      end
    else preseqI:=0;

    if ((voie=1) or (voie=0)) and (postSeqI<>0) then
      begin
        f.Position:= offsetS+tailleSeq-postSeqI;
        BlocEpInfo.read(f);
      end;

    f.free;
    f:=nil;

    if infoDac2.nbvoie=0 then exit;

    offsetS:=offsetS+preseqI+sampleSize*(voie-1);

   { A la suite d'une erreur, le type rangé dans le fichier a été G_word au lieu de G_smallint pendant
    un certain temps;
    Heureusement, les cartes d'acq ne rangent que des smallint dans les fichiers
    Y compris les cartes CB pour lesquelles on convertit les word en smallint.

    }
    data0:=nil;
    case Tpdata of
       G_word, G_smallint:
                  if withTags then
                  data0:=typedataFileIdigi.create
                    (stdat,offsetS,infoDac2.nbvoie,0,nbptSeq0-1,false,TagShift)
                  else
                  data0:=typedataFileI.create
                    (stdat,offsetS,infoDac2.nbvoie,0,nbptSeq0-1,false);
       G_single:  data0:=typedataFileS.create
                    (stdat,offsetS,infoDac2.nbvoie,0,nbptSeq0-1,false);

       G_longint: data0:=typedataFileL.create
                    (stdat,offsetS,infoDac2.nbvoie,0,nbptSeq0-1,false);

    end;
    data0.setConversionX(Dxu,X0u);
    data0.setConversionY(AdcChannel[voie].Dyu,AdcChannel[voie].Y0u);

    result:=data0;
    Except
      f.free;
      result:=nil;
    end;
    {messageCentral('Dxu='+Estr(infoDac2.Dxu,6)+' '+infoDac2.ux);}
  end;
end;


function TDAC2Descriptor.getTpNum(voie,seq:integer):typetypeG;
begin
  if Fdat and not Fevt
    then getTpNum:=infoDac2.tpdata
  else
  if not Fdat and Fevt
    then getTpNum:=G_longint
  else
  begin
    if voie<=nbVoiesAnalog
      then result:=infoDac2.tpdata
      else result:=G_longint;
  end;

end;

function TDAC2Descriptor.getDataTag(voie,seq:integer):typeDataB;
var
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



function TDAC2Descriptor.nbVoie:integer;
begin
  if Fdat and not Fevt
    then nbvoie:=infoDac2.nbvoie
  else
  if Fevt then
    nbvoie:=16
  else nbvoie:=0;
end;

function TDAC2Descriptor.NbVoiesAnalog: integer;
begin
  if Fdat
    then result:=infoDac2.nbvoie
    else result:=0;
end;


function TDAC2Descriptor.FichierContinu:boolean;
begin
  FichierContinu:=Fdat and infoDac2.continu;
end;

procedure TDAC2Descriptor.displayInfo;
var
  BoiteInfo:typeBoiteInfo;
  i,j:integer;
begin
  with BoiteInfo do
  begin
    BoiteInfo.init('File Informations');

    writeln(ExtractFileName(stDat)+'  '+Udate(DateD)+'  '+Utime(DateD) );
    writeln('Format: DAC2');
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

        writeln('File header size='+Istr(headerSize));
        writeln('Ep header size='+Istr(infoDac2.preseqI));
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

function TDAC2Descriptor.unitX:AnsiString;
begin
  if Fdat
    then unitX:=infoDac2.ux
    else unitX:=statEv.unitXSP;
end;

function TDAC2Descriptor.unitY(num:integer):AnsiString;
begin
  if Fdat
    then unitY:=infoDac2.adcChannel[num].uy
    else unitY:='';
end;


function TDAC2Descriptor.FileheaderSize:integer;
begin
  FileheaderSize:=HeaderSize;
end;

function TDAC2Descriptor.getInfoDac2:PinfoDac2;
begin
  result:=@infoDac2;
end;

function TDAC2Descriptor.getFileInfoCopy:TblocInfo;
begin
  result:=BlocFileInfo.copy;
end;


function TDAC2Descriptor.getMtag(numseq:integer):PMtagArray;
begin
  result:=nil;

  if assigned(Mtag) then
    begin
      getmem(result,Mtag^.size);
      move(Mtag^,result^,Mtag^.size);
    end;
end;


procedure TDac2Descriptor.getElphyTag(numseq:integer;var tags:TtagRecArray;
                                var x0u,dxu:float);
var
  i:integer;
begin
  if not assigned(Mtag) then exit;

  setLength(tags,Mtag^.nb);
  for i:=0 to Mtag^.nb-1 do
    with tags[i] do
    begin
      SampleIndex:=Mtag^.t[i+1].date;
      Stime:=0;
      code:=0;
      ep:=1;
      st:='';
    end;

  dxu:=infoDac2.Dxu/nbvoie;
  x0u:=0;

end;


class function TDAC2Descriptor.FileTypeName: AnsiString;
begin
  result:='DAC2';
end;

end.
