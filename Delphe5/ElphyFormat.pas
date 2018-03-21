unit ElphyFormat;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysUtils,
     util1,Gdos, debug0,
     stmdef, stmObj,varConf1,blocInf0,
     DataGeneFile,cyberK2,
     acqDef2
     ;

{ Nouveau format de fichier de données.

  Le fichier contiendra l'entête des fichiers d'objets Dac2 (ObjFile1), soit 18 octets.

  Ensuite, une suite de blocs tous complètement indépendants, chaque bloc ayant le
  format d'un objet, comme dans les fichiers d'objets ou de configuration.
  C'est à dire:

  BLOC=
    - un mot de 4 octets représentant la taille totale du bloc (y compris ces 4 octets)
    - un mot clé string de longueur quelconque identifiant le bloc
    - les données du bloc

  Donc, un programme pourra lire les blocs (ou objets) qui l'intéressent et ignorer
  les autres.

  Cas particulier:
    - si la taille d'un bloc est -1, le bloc se termine à la fin du fichier

  Ce sera le cas pour un bloc de données pour une acquisition continue, lorsque
  le fichier n'aura pas été fermé correctement.

  Il n'y a pas d'entête de fichier dans le sens Acquis1 ou Dac2.
  Les blocs actuels sont les suivants:

  TcommentBlock
  TFileInfoBlock
  TEpInfoBlock
  TstimBlock
  TacqBlock
  TUtagBlock
  TseqBlock
  TRdataBlock
  TReventBlock

  Les données sont constituées d'un bloc Seq suivi par:
  - un ou plusieurs blocs Rdata
  - un ou plusieurs blocs Revt

  Entre les blocs Rdata ou Revt peuvent s'intercaler d'autres blocs.

  Les autres blocs sont des blocs d'information.
  Il est possible de ranger des objets (vecteurs, matrices) dans le même fichier.
}



type
  TElphyFileBlock=
    class(typeUO)
      constructor create;override;
    end;


  TcommentBlock=
    class(TElphyFileBlock)
      stCom:AnsiString;

      class function STMClassName:AnsiString;override;
      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      function getInfo:AnsiString;override;
    end;

  TFileInfoBlock=
    class(TElphyFileBlock)
      blocInfo:TblocInfo;

      blocExterne:boolean;
      constructor create;override;
      destructor destroy;override;

      class function STMClassName:AnsiString;override;

      procedure setBloc(bloc:TblocInfo);
      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      function getInfo:AnsiString;override;
    end;

  TEpInfoBlock=
    class(TFileInfoBlock)
      class function STMClassName:AnsiString;override;
      function getInfo:AnsiString;override;
    end;


  TuserTagRecord=
    record
      SampleIndex:integer;
      Stime:TdateTime;
      code:byte;
      ep:integer;
      withObj: boolean;
    end;

  TUserTagBlock=
    class(TElphyFileBlock)
      Utag:TuserTagRecord;
      stCom:AnsiString;

      constructor create;override;
      destructor destroy;override;

      class function STMClassName:AnsiString;override;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      function getInfo:AnsiString;override;
    end;

  { Structure d'une séquence:
    On part du principe qu'à 'acquisition, on a nbvoie multiplexées contenant
    chacune nbpt échantillons.
    En fait, on ne sauve pas tous les points, soit parce qu'on a décimé certaines voies (Ksampling0>1),
    soit parce qu'on les a transformées en voies événements (Ksampling0=0) .
    Il suffit de connaitre le facteur de downsampling pour chaque voie pour connaitre la
    structure du fichier.
    Ksampling0=1 signifie que tous les pts ont été sauvés
    Ksampling0=n signifie que 1 point sur n a été sauvé
    Ksampling0=0 signifie qu'aucun point n'a été sauvé

    Pour les voies Tag avec tagMode=itc , la dernière voie est telle que Ksampling0=1
  }

  TseqRecord=
    record
      nbvoie:byte;       {nbvoie à l'acquisition. Même si une voie n'est pas sauvée. Inclut la voie tag }
      nbpt:integer;      {nbpt nominal = cas ou Ksampling0=1 pour chaque voie}
      tpData:typeTypeG;  {type des échantillons, a été remplacé par Ktype0 }

      uX:string[10];     {unités de temps}
      Dxu,x0u:double;    {Dxu par voie}

      continu:boolean;   {si vrai, le fichier est continu}

      TagMode:TtagMode;
      TagShift:byte;

      DxuSpk,X0uSpk: double; { introduit pour CyberK, paramètres des waveforms uniquement }
      nbSpk:integer;         { '' }
      DyuSpk,Y0uSpk: double; { '' }
      unitXspk,unitYSpk:string[10];      { '' }
      CyberTime: double;     { temps du cyberK en secondes }
      PCtime:longword;       { temps PC  en millisecondes }
      DigEventCh: integer;   { numéro de la voie Evt utilisant les compteurs NI }
      DigEventDxu:double;    { période échantillonnage correspondante }
      DxEvent: double;       { période échantillonnage des voies evt ordinaires. Par défaut, on avait Dxu / nbvoie . }
      FormatOption: byte;    { ajouté le 26 mars 2011 . =0 jusqu'à cette date.
                               1: les voies deviennent des vecteurs 100% indépendants }
    end;

  TAdcChannel=record
                uY:string[10];
                Dyu,Y0u:double;
              end;
  TadcChannels=array of TadcChannel;

  TAdcChannel2=record
                ChanType:byte;        // 0: analog ou tag      1: Evt    si tmItc , la dernière voie est la voie tag
                tpNum: typetypeG;     // number type
                imin, imax: integer;
                ux:string[10];
                Dxu,x0u:double;
                uY:string[10];
                Dyu,Y0u:double;
              end;
  TadcChannels2=array of TadcChannel2;


  TseqBlock=
    class(TElphyFileBlock)
    private
      adcChannel:TAdcChannels;  { description des canaux}
      SamplePerChan0:array of integer; {0 signifie EVT}
      Ktype0:array of typetypeG; { ajouté en juin 2008 }
      Ksampling0:array of word;  { facteurs de sous-échantillonnage: 1 par défaut }

      adcChannel2:TAdcChannels2;

      procedure CalculAgSampleCount;
      procedure setDsize(nb:int64);     {fixe les valeurs de SamplePerChan0 }

      procedure setKtype(n:integer;tp:typetypeG);
      function getKtype(n:integer):typetypeG;

      procedure setKsampling(n:integer;w:word);
      function getKsampling(n:integer):word;


    public
      {Paramètres sauvés dans le fichier}
      seq:TseqRecord;

      {Paramètres calculés }

      SampleTot:integer;
      chanMask:array of integer; {Le masque a la taille d'un agrégat. On range le numéro de voie (0 à nbvoie-1)
                                  dans chaque élément.                 }
      AgSampleCount:integer;     {Taille d'agrégat calculée avec getAgSampleCount en nombre d'échantillons}
      AgSize:integer;            {Taille de l'agrégat en octets }
      ppcm0:integer;             {ppcm des Ksampling0 positifs}

      Tmax:float;                {Durée de la séquence en secondes ou ms, ajouté juillet 2009 , calculé avec SamplePerChan0 }

      Offset2: array of integer; {Offsets dans le bloc Rdata}

      constructor create;override;

      class function STMClassName:AnsiString;override;

      procedure setVarSizes(conf:TblocConf);
      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure completeLoadInfo;override;
      {function loadFromStream(f:Tstream;size:longWord;Fdata:boolean):boolean;override;}

      function getInfo:AnsiString;override;


      procedure BuildMask(DataSz:int64);{construction de chanMask, calcul de SamplePerChan0}
      function UnderSampled:boolean;

      function AnalogChCount:integer;
      function EvtChCount:integer;

      procedure init0(Const seq1:TseqRecord ); // initialisation en format 0
      procedure init1(Const seq1:TseqRecord ); // initialisation en format 1

      function SamplePerChan(num : integer): integer;
      procedure initChannel0(num: integer; Dy,y0: double; unitY: string);
      procedure initChannel1(num: integer; ChanType1:byte; tp: typetypeG; i1, i2: integer;
                             Dx,x0:double; unitX:string; Dy,y0: double; unitY: string);

      function getDyu(num: integer): double;
      function getY0u(num: integer): double;
      function getUnitY(num: integer): string;

      function getDxu(num: integer): double;
      function getX0u(num: integer): double;
      function getUnitX(num: integer): string;

      function getChanType(num: integer): integer;
      function getImin(num: integer): integer;
      function getImax(num: integer): integer;

      function getOffset2(num: integer): integer;

      property Ktype[n:integer]: typetypeG read getKtype write setKtype;
      property Ksampling[n:integer]: word read getKsampling write setKsampling;
    end;

  TRdataRecord=record
                 MySize:word;       {Taille du record}
                 SFirst:boolean;    {si vrai , il y a eu une pause avant ce bloc}
                 Stime:TdateTime;   {Date du PC à l'enregistrement}
                 Nindex:longword;
               end;

  TRdataBlock=
    class(TElphyFileBlock)
    private
      off0:int64;
      size0:longword; {offset et taille des données après loadObject}
      rec:TRdataRecord;
    public
      function dataSize:longword;
      function dataOffset:int64;
      class function NindexOffset:integer;          {Offset de Nindex à partir du début du bloc (position de "Block Size" }
      class function STMClassName:AnsiString;override;

      property NomIndex:longword read rec.NIndex;
      property Stime: TdateTime read rec.Stime;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;
      function getInfo:AnsiString;override;
    end;

  TRevent=record
            date:integer;
            code:byte;
          end;

  

  TReventBlock=
    class(TRdataBlock)
    public
      scaling: TevtScaling;
      expectedNbEv:integer;
      nbVev:integer;
      nbev:array of integer;
      constructor create;override;
      class function STMClassName:AnsiString;override;
      function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;
      function getInfo:AnsiString;override;
    end;

  TRspkBlock=
    class(TReventBlock)
    public
      class function STMClassName:AnsiString;override;
    end;



  TRspkWaveBlock=
    class(TRdataBlock)
    public
      scaling: TSpkWaveScaling;

      Wavelen:integer;            {Paramètres sauvés dans cet ordre }
      Pretrig:integer;
      nbVev:integer;
      nbev:array of integer;

      waveSize:integer;           {=ElphySpkPacketFixedSize + nbptSpk*2; }

      class function STMClassName:AnsiString;override;
      function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;
      function getInfo:AnsiString;override;
    end;

  TRsoundBlock=
    class(TRdataBlock)
    public
      class function STMClassName:AnsiString;override;
    end;

  TRcyberTagBlock=
    class(TRdataBlock)
    public
      class function STMClassName:AnsiString;override;
    end;

  TRpclBlock=
    class(TRdataBlock)
    public
      nbPhoton:integer;
      Funix:boolean;
      class function STMClassName:AnsiString;override;
      function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;
      function getInfo:AnsiString;override;
    end;


procedure WriteRdataHeader(f:TStream;size:integer;tm:TdateTime;first:boolean);
{size est la taille des données proprement dites}

procedure WriteReventHeader(f:TStream;size:integer;tm:TdateTime;first:boolean);
{size est la taille des données proprement dites}

procedure WriteRspkHeader(f:TStream;size:integer;tm:TdateTime;first:boolean;scale: TevtScaling);
{size est la taille des données proprement dites}

procedure WriteRSPKwaveHeader(f:TStream;size:integer;tm:TdateTime;first:boolean;scale: TSpkWaveScaling);

procedure WriteRcyberTagHeader(f:TStream;size:integer;tm:TdateTime;first:boolean);

procedure WriteRPCLHeader(f:TStream;size:integer;tm:TdateTime;first:boolean);

implementation

{********************** Méthodes de TElphyFileBlock *****************************}

constructor TElphyFileBlock.create;
begin
  inherited;   {on pourrait ne pas appeler inherited }
  notPublished:=true;
end;

{********************** Méthodes de TcommentBlock *****************************}

class function TcommentBlock.STMClassName:AnsiString;
begin
  result:='B_comment';
end;

procedure TcommentBlock.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  conf.setStringconf('STCOM',stCom);
end;

function TcommentBlock.getInfo:AnsiString;
begin
  result:=inherited getInfo+
          stCom+CRLF;
end;

{********************** Méthodes de TFileInfoBlock ****************************}

constructor TFileInfoBlock.create;
begin
  inherited;
  blocInfo:=TblocInfo.create(0);
end;

destructor TFileInfoBlock.destroy;
begin
  if not BlocExterne then blocInfo.free;
  inherited;
end;

class function TFileInfoBlock.STMClassName:AnsiString;
begin
  result:='B_Finfo';
end;

procedure TFileInfoBlock.setBloc(bloc:TblocInfo);
begin
  if assigned(blocInfo) and not BlocExterne then blocInfo.free;
  blocInfo:=bloc;
  blocExterne:=true;
end;

procedure TFileInfoBlock.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  conf.setDynConf('USR',blocInfo.buf,blocinfo.tailleBuf);
end;

function TFileInfoBlock.getInfo:AnsiString;
begin
  if assigned(blocInfo) then
  result:=inherited getInfo+
          'Size: '+Istr(blocInfo.tailleBuf)+' bytes'+CRLF;
end;


{********************** Méthodes de TEpInfoBlock ****************************}

class function TEpInfoBlock.STMClassName:AnsiString;
begin
  result:='B_Einfo';
end;

function TEpInfoBlock.getInfo:AnsiString;
begin
  result:=inherited getInfo;
end;

{********************** Méthodes de TUserTagBlock ****************************}

constructor TUserTagBlock.create;
begin
  inherited;
end;

destructor TUserTagBlock.destroy;
begin
  inherited;
end;

class function TUserTagBlock.STMClassName:AnsiString;
begin
  result:='B_UTag';
end;


procedure TUserTagBlock.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  conf.setVarConf('Utag',Utag,Sizeof(Utag));
  conf.SetStringConf('Text=',stCom);
end;

function TUserTagBlock.getInfo:AnsiString;
begin
  with Utag do
  result:=inherited getInfo+
          'SampleIndex='+Istr(SampleIndex)+crlf+
          'Stime='+dateTimeToStr(Stime)+crlf+
          'Code='+Istr(code)+crlf+
          'Ep='+Istr(ep)+crlf+
          'WithObj='+Bstr(WithObj)+crlf+
          'Text='+stCom;

end;

{********************** Méthodes de TSeqBlock ****************************}

constructor TseqBlock.create;
var
  i:integer;
begin
  inherited;
end;

class function TseqBlock.STMClassName:AnsiString;
begin
  result:='B_Ep';
end;


procedure TseqBlock.setVarSizes(conf:TblocConf);
begin
  case seq.FormatOption of
    0:begin
        setLength(adcChannel,seq.nbvoie);
        setLength(Ksampling0,seq.nbvoie);
        setLength(SamplePerChan0,seq.nbvoie);

        setLength(Ktype0,seq.nbvoie);
        fillchar(Ktype0[0],seq.nbvoie,ord(G_smallint));

        conf.ModifyVar('Adc',AdcChannel[0],seq.nbvoie*sizeof(TadcChannel));
        conf.ModifyVar('Ksamp',Ksampling0[0],seq.nbvoie*sizeof(Ksampling0[0]));
        conf.ModifyVar('Ktype',Ktype0[0],seq.nbvoie*sizeof(Ktype0[0]));
      end;

    1:begin
        setLength(adcChannel2,seq.nbvoie);

        conf.ModifyVar('Adc2',AdcChannel2[0],seq.nbvoie*sizeof(TadcChannel2));
      end;
  end;
end;

procedure TseqBlock.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  if lecture then
  begin
    fillchar(seq,sizeof(seq),0);
  end;
  {seq contient nbvoie. Juste après la lecture de seq, setVarSizes est appelée pour fixer la
  taille des tableaux (adcChannel, etc...)    }

  conf.SetVarConf('Ep',seq,sizeof(seq),SetVarSizes); { onRead = SetVarSizes }

  if lecture or (seq.FormatOption=0) then
  begin
    conf.setVarConf('Adc',AdcChannel[0],seq.nbvoie*sizeof(TadcChannel));
    conf.setVarConf('Ksamp',Ksampling0[0],seq.nbvoie*sizeof(Ksampling0[1]));
    conf.setVarConf('Ktype',Ktype0[0],seq.nbvoie*sizeof(Ktype0[0]));
  end;
  if lecture or (seq.FormatOption=1) then
  begin
    conf.setVarConf('Adc2',AdcChannel2[0],seq.nbvoie*sizeof(TadcChannel2));
  end;
end;

procedure TseqBlock.completeLoadInfo;
var
  i: integer;
begin
{
  if (seq.FormatOption=1)  then                          // TEST 15 mars 2018
  for i:=0 to high(AdcChannel2) do
    with AdcChannel2[i] do
    begin
      if (Imax = seq.nbpt) or
         (Imax = seq.nbpt div 3) or
         (Imax = seq.nbpt div 15) or
         (Imax = seq.nbpt div 30)
         then Imax:= Imax-1;
    end;
 }
  calculAgSampleCount;
end;

function TseqBlock.getInfo:AnsiString;
var
  i:integer;
  NumEv: integer;
begin
  result:=inherited getInfo+
          'Analog Channel count='+Istr(AnalogChCount)+CRLF+
          'Evt Channel count='+Istr(EvtChCount)+CRLF+

          'Samples per channel='+Istr(seq.nbpt)+CRLF+
          'Data type='+TypeNameG[seq.tpData]+CRLF+

          'UnitX='+seq.uX+CRLF+
          'Dx='+Estr(seq.dxu,9)+CRLF+
          'X0='+Estr(seq.x0u,9)+CRLF+
          'Continuous='+Bstr(seq.continu)+CRLF+
          'TagMode='+Istr(ord(seq.TagMode))+CRLF+
          'TagShift='+Istr(seq.tagShift)+CRLF+CRLF;

  NumEv:=0;
  case seq.FormatOption of
    0:  for i:=0 to High(AdcChannel) do
          with adcChannel[i] do
          if Ksampling0[i]>0
             then result:=result+Istr(i+1)+': ADC Dy='+Estr(dyu,9)+' y0='+Estr(y0u,9)+' ('+uY+')'
                                +' KS='+Istr(Ksampling0[i])+' type='+TypeNameG[Ktype0[i]]+CRLF
             else
             begin
               inc(NumEv);
               result:=result+Istr(i+1)+': EVT'+Istr(numEv)+CRLF;
             end;
    1:  for i:=0 to High(AdcChannel2) do
          with adcChannel2[i] do
          if ChanType=0
             then result:=result+Istr(i+1)+': ADC Dy='+Estr(dyu,9)+' y0='+Estr(y0u,9)+' ('+uY+')'
                                +' Dx='+Estr(Dxu,9)+' type='+TypeNameG[tpNum]+CRLF
             else
             begin
               inc(NumEv);
               result:=result+Istr(i+1)+': EVT'+Istr(numEv)+CRLF;
             end;
  end;
  result:=result+crlf+
    'CyberTime='+Estr(seq.cyberTime,3);
  result:=result+crlf+
    'PCTime='+Istr(seq.PCtime);
end;

procedure TseqBlock.CalculAgSampleCount; {taille d'un agrégat en nb d'échantillons}
var
  i,n:integer;
begin
  case seq.FormatOption of
    0: begin
          ppcm0:=1;
          for i:=0 to seq.nbvoie-1 do
          begin
            if Ksampling0[i]>0
              then ppcm0:=ppcm(ppcm0,Ksampling0[i]);
          end;                             { on calcule le ppcm des Ksampling0>0 }

          AgSampleCount:=0;
          for i:=0 to seq.nbvoie-1 do      { AgSampleCount est la somme des quotients ppcm/Ksampling0}
            if Ksampling0[i]>0
              then AgSampleCount:=AgSampleCount+ppcm0 div Ksampling0[i];
       end;
    1: begin
         n:=0;
         setLength(Offset2, length(AdcChannel2));
         for i:=0 to high(AdcChannel2) do
         with AdcChannel2[i] do
         begin
           offset2[i]:=n;
           n:=n+ tailleTypeG[tpNum]*(Imax-Imin+1);
         end;
       end;
  end;
end;

procedure TseqBlock.setDsize(nb:int64); {nb est la taille du bloc de données}
var
  i,j,rest,vv:integer;
  nbAg,it:int64;
  tt:float;
begin
  if seq.FormatOption<>0 then exit;

  if AgSampleCount=0 then                 {setDsize fixe les valeurs de SamplePerChan0 }
    begin                                 {en tenant compte du fait que le dernier agrégat }
      for i:=0 to seq.nbvoie-1 do         {peut ne pas être complet}
        SamplePerChan0[i]:=0;
      exit;
    end;

  nbAg:=nb div AgSize;                    {nombre d'agrégats complets }

  for i:=0 to seq.nbvoie-1 do
    if Ksampling0[i]>0
      then SamplePerChan0[i]:=nbAg*ppcm0 div Ksampling0[i]
      else SamplePerChan0[i]:=0;

  rest:=nb mod AgSize;                    {agrégat incomplet }
  it:=0; { taille }
  j:=0; { indice dans l'Ag }
  while it<rest do
  begin
    vv:= chanMask[j];
    if (vv>=0) and (vv <seq.nbvoie) then    { condition inutile ?}
    begin
      inc(SamplePerChan0[vv]);
      inc(it,TailleTypeG[Ktype0[vv]]);
      inc(j);
    end
    else
    begin
      messageCentral('TseqBlock.setDsize error vv='+Istr(vv));
      break;
    end;
  end;

  Tmax:=0;
  for i:=0 to seq.nbvoie-1 do
    if Ksampling0[i]>0 then
    begin
      tt:=SamplePerChan0[i]*Ksampling0[i]*seq.Dxu;
      if Ksampling0[i]=1 then
      begin
        Tmax:=tt;
        exit;
      end;
      if tt>Tmax then Tmax:=tt;
    end;

end;

procedure TseqBlock.BuildMask(dataSz:int64);
var
  i,j,k:integer;
begin
  if seq.FormatOption<>0 then exit;

  CalculAgSampleCount;

  setLength(chanMask,AgSampleCount);
  AgSize:=0;
  i:=0;
  k:=0;
  repeat
    for j:=0 to seq.nbvoie-1 do
      if (Ksampling0[j]<>0) and (i mod Ksampling0[j]=0) then
        begin
          chanMask[k]:=j;
          AgSize:=AgSize+TailleTypeG[Ktype0[j]];
          inc(k);

          if k>=AgSampleCount then break;
        end;
    inc(i);
  until k>=AgSampleCount;

  setDsize(dataSz);
end;

function TseqBlock.UnderSampled:boolean;
var
  i:integer;
begin
  result:=false;
  if seq.FormatOption<>0 then exit;

  for i:=0 to seq.nbvoie-1 do
  if Ksampling0[i]>1 then
    begin
      result:=true;
      exit;
    end;
end;

function TseqBlock.AnalogChCount:integer;
var
  i:integer;
begin
  result:=0;

  case seq.FormatOption of
    0: begin
         for i:=0 to seq.nbvoie-1 do
         if Ksampling0[i]>0 then inc(result);
         if seq.TagMode=tmITC then dec(result);              // on ne compte pas les voies digitales
       end;
    1: begin
         for i:=0 to high(AdcChannel2) do
           if AdcChannel2[i].ChanType=0 then inc(result);
       end;
  end;
end;

function TseqBlock.EvtChCount:integer;
var
  i:integer;
begin
  result:=0;
   case seq.FormatOption of
     0: for i:=0 to seq.nbvoie-1 do
          if Ksampling0[i]=0 then inc(result);
     1: for i:=0 to high(AdcChannel2) do
          if AdcChannel2[i].ChanType=1 then inc(result);
   end;
end;

procedure TseqBlock.init0(const seq1: TseqRecord);
begin
  seq:=seq1;
  seq.FormatOption:=0;

  setLength(adcChannel,seq.nbvoie);
  setLength(Ksampling0,seq.nbvoie);
  setLength(samplePerChan0,seq.nbvoie);

  setLength(Ktype0,seq.nbvoie);
  fillchar(Ktype0[0],seq.nbvoie,ord(g_smallint));
end;

procedure TseqBlock.init1(const seq1: TseqRecord);
begin
  seq:=seq1;
  seq.FormatOption:=1;

  setLength(adcChannel2,seq.nbvoie);
end;

function TseqBlock.SamplePerChan(num: integer): integer;
begin
  case seq.FormatOption of
    0: result:= SamplePerChan0[num];
    1: with AdcChannel2[num] do result:= imax-imin+1;
  end;
end;


procedure TseqBlock.initChannel0(num: integer; Dy, y0: double; unitY: string);
begin
  with AdcChannel[num] do
  begin
    Dyu:= Dy;
    Y0u:= Y0;
    uy:=unitY;
  end;
end;

procedure TseqBlock.initChannel1(num: integer; ChanType1:byte; tp: typetypeG; i1, i2: integer;
                                 Dx,x0:double; unitX:string; Dy,y0: double; unitY: string);
begin
  with AdcChannel2[num] do
  begin
    ChanType:=ChanType1;
    tpNum:=tp;
    imin:=i1;
    imax:=i2;
    Dxu:= Dx;
    x0u:= x0;
    ux:=unitX;
    Dyu:= Dy;
    Y0u:= Y0;
    uy:=unitY;
  end;
end;

function TseqBlock.getDxu(num: integer): double;
begin
  case seq.FormatOption of
    0: result:=seq.Dxu;
    1: result:=AdcChannel2[num].Dxu;
  end;
end;

function TseqBlock.getX0u(num: integer): double;
begin
  case seq.FormatOption of
    0: result:=seq.X0u;
    1: result:=AdcChannel2[num].X0u;
  end;
end;

function TseqBlock.getUnitX(num: integer): string;
begin
  case seq.FormatOption of
    0: result:=seq.ux;
    1: result:=AdcChannel2[num].ux;
  end;
end;


function TseqBlock.getDyu(num: integer): double;
begin
  case seq.FormatOption of
    0: result:=AdcChannel[num].Dyu;
    1: result:=AdcChannel2[num].Dyu;
  end;
end;

function TseqBlock.getY0u(num: integer): double;
begin
  case seq.FormatOption of
    0: result:=AdcChannel[num].Y0u;
    1: result:=AdcChannel2[num].Y0u;
  end;
end;

function TseqBlock.getUnitY(num: integer): string;
begin
  case seq.FormatOption of
    0: result:=AdcChannel[num].uy;
    1: result:=AdcChannel2[num].uy;
  end;
end;

procedure TseqBlock.setKtype(n:integer;tp:typetypeG);
begin
  case seq.FormatOption of
    0: Ktype0[n]:=tp;
    1: AdcChannel2[n].tpNum:=tp;
  end;
end;

function TseqBlock.getKtype(n:integer):typetypeG;
begin
  case seq.FormatOption of
    0: result:=Ktype0[n];
    1: result:=AdcChannel2[n].tpNum;
  end;
end;

procedure TseqBlock.setKsampling(n:integer;w:word);
begin
  case seq.FormatOption of
    0: Ksampling0[n]:= w;
  end;
end;

function TseqBlock.getKsampling(n:integer):word;
begin
  case seq.FormatOption of
    0: result:=Ksampling0[n];
    else result:=1;
  end;
end;


function TseqBlock.getChanType(num: integer): integer;
begin
  result:= AdcChannel2[num].ChanType;
end;

function TseqBlock.getImin(num: integer): integer;
begin
  result:= AdcChannel2[num].Imin;
end;

function TseqBlock.getImax(num: integer): integer;
begin
  result:= AdcChannel2[num].Imax;
end;

function TseqBlock.getOffset2(num: integer): integer;
begin
  result:=Offset2[num];
end;

{********************** Méthodes de TRdataBlock ****************************}

function TRdataBlock.dataSize:longword;
begin
  result:=size0;
end;

function TRdataBlock.dataOffset:int64;
begin
  result:=off0;
end;

class function TRdataBlock.NindexOffset:integer;
begin
  result:=5+length(stmClassName) + sizeof(word)+ sizeof(boolean)+ sizeof(TdateTime);
end;


class function TRdataBlock.STMClassName:AnsiString;
begin
  result:='RDATA';
end;

procedure TRdataBlock.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  {Vide mais il est nécessaire de surcharger typeUO.buildinfo}
end;

function TRdataBlock.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  sz:integer;
begin
  fillchar(rec,sizeof(rec),0);
  f.ReadBuffer(rec.mySize,sizeof(rec.mySize));    { lire mySize 2 octets }
  if rec.MySize >sizeof(rec)                      { puis le reste de rec }
    then rec.MySize :=sizeof(rec);                { En procédant ainsi, on se réserve la possibilité }
  f.ReadBuffer(rec.Sfirst,rec.mySize-2);          { d'ajouter des champs dans rec }

  off0:=f.position;                               { Position des données }
  size0:=size-5-length(stmClassName)-rec.mySize;  { Taille des données. On enlève les dix octets
                                                    d'entête : 'RDATA' + taille}

  f.Position:=f.Position+size0;
end;

function TRdataBlock.getInfo:AnsiString;
begin
  result:=inherited getInfo+
  'Raw data offset: '+IntToStr(off0)+crlf+
  'Raw data size: '+IntToStr(size0)+' bytes'+crlf+
  'Date: '+ dateTimeToStr(rec.Stime)+crlf
  ;
end;


type
  TRdataHeader=
    record
      BlockSize:integer;
      st:String[5];
      hrec:TRdataRecord;
    end;


procedure WriteRawHeader(f:TStream;size:integer;tm:TdateTime;first:boolean;ident:shortstring;Const extra: pointer=nil;Const ExtraSize: integer=0);
var
  hrec:TRdataRecord;
  BlockSize:integer;
begin
  BlockSize:=4 +
             length(ident) +1 +
             sizeof(hrec) +
             size +
             ExtraSize;

  hrec.mySize:=sizeof(TRdataRecord) +extraSize;
  hrec.Sfirst:=first;
  hrec.Stime:=tm;

  f.Write(blockSize,sizeof(blockSize));
  f.Write(ident,length(ident)+1);
  f.Write(hrec,sizeof(hrec));
  if extra<>nil then f.Write(extra^,ExtraSize);

end;

procedure WriteRdataHeader(f:TStream;size:integer;tm:TdateTime;first:boolean);
begin
  writeRawHeader(f,size,tm,first,'RDATA');
end;


{********************** Méthodes de TReventBlock ****************************}

constructor TReventBlock.create;
begin
  inherited;
  expectedNbEv:=-1;
end;

class function TReventBlock.STMClassName:AnsiString;
begin
  result:='REVT';
end;

function TReventBlock.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  sz:integer;
  pos0: int64;
begin
  pos0:= f.Position;
  fillchar(rec,sizeof(rec),0);
  f.readBuffer(rec.mySize,sizeof(rec.mySize));    // lire mySize
  sz:=rec.MySize -2;                              // taille restante

  if sz >sizeof(rec)-2
    then f.readBuffer(rec.Sfirst,sizeof(rec)-2);  // le rec original  sz:= sz-sizeof(rec)+2;


  fillchar(scaling,sizeof(scaling),0);
  if sz > sizeof(scaling) then f.Read(scaling,sizeof(scaling)); // scaling optionnel

  f.Position:=pos0+rec.MySize;                    // dans tous les cas, on saute rec.mySize octets

  f.readBuffer(nbVev,sizeof(nbvEv));

  if (expectedNbEv>=0) then nbVEv:=expectedNbEv;
  if (nbVeV<0) or (nbVeV>256) then nbVeV:=1;

  setLength(nbeV,nbVeV);
  f.readBuffer(nbEv[0],nbvEv*sizeof(integer));


  off0:=f.position;
  size0:=size-5-length(stmClassName)-rec.mySize-sizeof(integer)*(nbVeV+1);

  f.Position:=f.Position+size0;
end;

function TReventBlock.getInfo: AnsiString;
var
  st:AnsiString;
  i:integer;
  tot:integer;
begin
  result:=inherited getInfo;

  if scaling.Dxu<>0 then
    with scaling do
    result:= result + 'Dx = '+Estr(Dxu,9)+crlf+
                      'x0 = '+Estr(x0u,9)+crlf+
                      'unitX= '+unitX +crlf;

  st:='';
  for i:=0 to high(nbEv) do
    st:=st+Istr1(i+1,3)+': '+Istr(nbEv[i])+crlf;

  result:=result +
  'ChCount='+Istr(nbVeV)+crlf+
  'Event counts='+crlf+
  st;

  tot:=0;
  for i:=0 to high(nbEv) do
    tot:= tot+nbEv[i];

  result:=result+crlf+Istr(tot);

end;


procedure WriteReventHeader(f:TStream;size:integer;tm:TdateTime;first:boolean);
begin
  writeRawHeader(f,size,tm,first,'REVT');
end;

{ TRspkBlock }

class function TRspkBlock.STMClassName: AnsiString;
begin
  result:='RSPK';
end;


procedure WriteRSPKHeader(f:TStream;size:integer;tm:TdateTime;first:boolean;scale: TevtScaling);
begin
  writeRawHeader(f,size,tm,first,'RSPK',@scale,sizeof(scale));
end;

{ TRspkWaveBlock }

function TRspkWaveBlock.loadFromStream(f: Tstream; size: LongWord; Fdata: boolean): boolean;
var
  sz:integer;
  pos0:int64;
begin
  pos0:= f.Position;
  fillchar(rec,sizeof(rec),0);
  f.readBuffer(rec.mySize,sizeof(rec.mySize));    // lire mySize
  sz:=rec.MySize -2;                              // taille restante

  if sz >sizeof(rec)-2
    then f.readBuffer(rec.Sfirst,sizeof(rec)-2);  // le rec original  sz:= sz-sizeof(rec)+2;


  fillchar(scaling,sizeof(scaling),0);
  if sz > sizeof(scaling) then f.Read(scaling,sizeof(scaling)); // scaling optionnel

  f.Position:=pos0+rec.MySize;                    // dans tous les cas, on saute rec.mySize octets

  f.readBuffer(WaveLen,sizeof(WaveLen));
  f.readBuffer(Pretrig,sizeof(Pretrig));
  f.readBuffer(nbVev,sizeof(nbvEv));
  if (nbVeV>0) and (nbVeV<256) then
  begin
    setLength(nbeV,nbVeV);
    f.readBuffer(nbEv[0],nbvEv*sizeof(integer));
  end;

  waveSize:=ElphySpkPacketFixedSize + WaveLen*2;

  off0:=f.position;
  size0:=size-5-length(stmClassName)-rec.mySize-sizeof(integer)*(nbVeV+3);

  f.Position:=pos0+size;
end;


class function TRspkWaveBlock.STMClassName: AnsiString;
begin
  result:='RspkWave';
end;


function TRspkWaveBlock.getInfo: AnsiString;
var
  st:AnsiString;
  i:integer;
begin
  result:=inherited getInfo;

  if scaling.Dxu<>0 then
  with scaling do
  result:= result + 'Dx = '+Estr(Dxu,9)+crlf +
                    'x0 = '+Estr(x0u,9)+crlf +
                    'unitX= '+unitX +crlf +
                    'Dy = '+Estr(Dyu,9)+crlf +
                    'y0 = '+Estr(y0u,9)+crlf +
                    'unitY = '+unitY +crlf +
                    'DxSource = '+Estr(DxuSource,9)+crlf+
                    'unitXsource= '+unitXsource +crlf;

  st:='';
  for i:=0 to high(nbEv) do
    st:=st+Istr1(i+1,3)+': '+Istr(nbEv[i])+crlf;

  result:= result+
  'WaveLen = '+Istr(Wavelen)+crlf+
  'Pretrig = '+Istr(Pretrig)+crlf+
  'ChCount = '+Istr(nbVeV)+crlf+
  'Event counts= '+crlf+
  st;

end;





procedure WriteRSPKwaveHeader(f:TStream;size:integer;tm:TdateTime;first:boolean; scale: TSpkWaveScaling);
begin
  writeRawHeader(f,size,tm,first,'RspkWave', @scale, sizeof(scale));
end;


{ Méthodes de TRsoundBlock }

class function TRsoundBlock.STMClassName: AnsiString;
begin
  result:='RSOUND';
end;


{ TRcyberTag }

class function TRcyberTagBlock.STMClassName: AnsiString;
begin
  result:='RCyberTag';
end;

procedure WriteRcyberTagHeader(f:TStream;size:integer;tm:TdateTime;first:boolean);
begin
  writeRawHeader(f,size,tm,first,'RCyberTag');
end;

{ TRpclBlock }

function TRpclBlock.loadFromStream(f: Tstream; size: LongWord; Fdata: boolean): boolean;
var
  sz:integer;
  p:int64;
begin
  p:=f.Position;
  fillchar(rec,sizeof(rec),0);
  f.readBuffer(rec.mySize,sizeof(rec.mySize));
  if rec.MySize >sizeof(rec)
    then rec.MySize :=sizeof(rec);
  f.readBuffer(rec.Sfirst,rec.mySize-2);

  f.readBuffer(nbPhoton,sizeof(nbPhoton));

  off0:=f.position;
  size0:=size-5-length(stmClassName)-rec.mySize-sizeof(nbPhoton);

  f.Position:=p+size;
end;

class function TRpclBlock.STMClassName: AnsiString;
begin
  result:='RPCL';
end;

function TRpclBlock.getInfo: AnsiString;
begin
  result:=inherited getInfo+
          'nbPhoton='+Istr(nbPhoton)+CRLF;

end;


procedure WriteRPCLHeader(f:TStream;size:integer;tm:TdateTime;first:boolean);
begin
  writeRawHeader(f,size,tm,first,'RPCL');
end;



Initialization
AffDebug('Initialization ElphyFormat',0);

registerObject(TcommentBlock,sys);
registerObject(TUserTagBlock,sys);
registerObject(TfileInfoBlock,sys);
registerObject(TepInfoBlock,sys);

registerObject(TseqBlock,sys);
registerObject(TRdataBlock,sys);
registerObject(TReventBlock,sys);
registerObject(TRspkBlock,sys);
registerObject(TRspkWaveBlock,sys);

registerObject(TRsoundBlock,sys);
registerObject(TRcyberTagBlock,sys);
registerObject(TRpclBlock,sys);

end.
