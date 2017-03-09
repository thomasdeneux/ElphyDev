unit descac1;

INTERFACE

uses windows,classes,sysUtils,
     util1,dtf0,Spk0,ficDefAc,debug0,blocInf0,Mtag0,
     Mtag2,
     varconf1,
     stmDef,
     acqDef2 ,
     stmOIseq1,
     DBrecord1
     ;


type

{ TfileDescriptor est l'objet permettant le chargement d'un fichier de données }
{ Il devrait exister un objet descendant de TfileDescriptor pour chaque type de
  fichier (Acquis1, ABF, Pclamp, etc...

  Un objet de ce type doit pouvoir donner toutes les info nécessaires à TdataFile
  et créer les objets data à la demande.

  TfileDescriptor crée des objets data mais ne les détruit jamais. Ce n'est
  qu'un outil qui permet d'obtenir des descripteurs de données.

}

  TfileDescriptor=class
                  public
                    comment:AnsiString;
                    fileSizeD: int64;
                    dateD: integer;
                    FileAgeD: TdateTime;

                    constructor create;virtual;
                    destructor destroy;override;

                    procedure storeFileParams(f:TfileStream);

                    function init(st:AnsiString):boolean;virtual;

                    function getEvtInfo(num:integer):typedataEv;virtual;


                    procedure initEpisod(num:integer);virtual;
                    function nbvoie:integer;virtual;
                    function nbSpk:integer;virtual;
                    function nbSeqDat:integer;virtual;
                    function nbPtSeq(voie:integer):integer;virtual;

                    function getData(voie,seq:integer;var EvtMode:boolean):typeDataB;virtual;
                    function getTpNum(voie,seq:integer):typetypeG;virtual;
                    function getDataTag(voie,seq:integer):typeDataB;virtual;
                    function getDataSpk(voie,seq:integer):typeDataB;virtual;
                    function getDataAtt(voie,seq:integer):typeDataB;virtual;
                    function getDataSpkWave(voie,seq:integer;var wavelen1,pretrig1:integer; var scaling:TspkWaveScaling):typeDataB;virtual;

                    function getSound(voie:integer):typeDataB;virtual;

                    function nbSeqEv:integer;virtual;
                    function dateEvFile:integer;virtual;
                    function FichierContinu:boolean;virtual;

                    procedure displayInfo;virtual;
                    function channelName(num:integer):AnsiString;virtual;
                    function unitX:AnsiString;virtual;
                    function unitY(num:integer):AnsiString;virtual;

                    function DureeSeq:float;virtual;
                    function EpDuration:float;virtual;

                    procedure SauverPostSeq;virtual;
                    function getEpInfo(var x;size,dep:integer):boolean;virtual;
                    function SetEpInfo(var x;size,dep:integer):boolean;virtual;
                    function ReadEpInfo(var x;size:integer):boolean;virtual;
                    function WriteEpInfo(var x;size:integer):boolean;virtual;
                    procedure ResetEpInfo;virtual;


                    function GetFileInfo(var x;size,dep:integer):boolean;virtual;
                    function SetFileInfo(var x;size,dep:integer):boolean;virtual;
                    function ReadFileInfo(var x;size:integer):boolean;virtual;
                    function WriteFileInfo(var x;size:integer):boolean;virtual;
                    procedure ResetFileInfo;virtual;

                    function fileInfoSize:integer;virtual;
                    function EpInfoSize:integer;virtual;

                    function getFileInfoBuf:pointer;virtual;
                    function EpInfo:pointer;virtual;

                    procedure copyEvHeader(f:TfileStream);virtual;
                    procedure copyEvEp(num:integer;f:TfileStream);virtual;

                    function FileheaderSize:integer;virtual;

                    function isAcquis1:boolean;virtual;

                    function getMtag(numseq:integer):PMtagArray;virtual;
                    procedure getElphyTag(numseq:integer;var tags:TtagRecArray;
                                          var x0u,dxu:float);virtual;
                    procedure CopyToBuffer(buf:pointer;bufSize:integer);virtual;
                    procedure FreeFileStream;virtual;

                    function getOIseq(n:integer;Const Finit:boolean=true):TOIseq;virtual;
                    function OIseqCount:integer;virtual;

                    class function FileTypeName:AnsiString;virtual;

                    function getAttlen:TarrayOfArrayOfInteger;virtual;

                    function getVTotCount(n:integer):integer;virtual;      {nb total de points sur v[n] }
                    function getVspkTotCount(n:integer):integer;virtual;   {nb total de spikes sur vspk[n] }
                    function getWspkTotCount(n:integer):integer;virtual;   {nb total de spikes sur Wspk[n] }
                    function getVtagTotCount: integer;virtual;

                    procedure getVNbSamps(n: integer;var nbSamps: TarrayOfInteger);virtual;
                    procedure getVspkNbSamps(n: integer;  var nbSamps: TarrayOfInteger);virtual;
                    procedure getVtagNbSamps(var nbSamps: TarrayOfInteger);virtual;

                    function getTimeSpan: float;virtual;
                    function CyberTime(ep:integer):double;virtual;
                    function PCtime(ep:integer):longword;virtual;
                    function CorrectedCyberTime(ep:integer):double;virtual;

                    function SpkTableCount:integer;virtual;
                    procedure getPCLdata(var pcl:TOIseqPCL; ep:integer);virtual;
                    function HasPCL:boolean;virtual;
                    function ReadPCLfilter(n: integer): TDBrecord;virtual;
                  end;

  TdescClass=class of TfileDescriptor;


{Bloc stimulation des fichiers Acquis1 version 1}
type
  typeParamStim1=  record
                      ident:string[8];
                      CadStim:float;

                      modeSortieAna:array[1..5] of byte;

                      DureeAna:    array[1..5] of float;

                      AmplitudeAna:array[1..5] of smallint;
                      IncrementAna:array[1..5] of smallint;
                      Vinitiale:array[1..5] of smallint;
                      Vfinale:array[1..5] of smallint;

                      modeSortieNum:array[1..4] of byte;

                      DateNum: array[1..4,1..5] of float;
                      DureeNum:array[1..4,1..5] of float;
                      largeurPulse:  array[1..4] of float;
                      cadencePulse:  array[1..4] of float;
                      cadenceSalve:  array[1..4] of float;
                      NbSalve:       array[1..4] of smallint;
                      NbPulse:       array[1..4] of smallint;

                      Jru1Stim:smallint;
                      Jru2Stim:smallint;
                      Yru1Stim:float;
                      Yru2Stim:float;
                      unitYstim:string[3];

                      XminStim,XmaxStim,YminStim,YmaxStim:float;

                      DelaiTrain: array[1..4] of float;
                      repetition: smallint;

                      AmplitudeAnaE:array[1..5] of float;
                      IncrementAnaE:array[1..5] of float;
                      VinitialeE:array[1..5] of float;
                      VfinaleE:array[1..5] of float;

                    end;


{Bloc stimulation des fichiers Acquis1 version 2}
type
  typeSegmentAna=record
                   mode:byte;
                   duree,amp,incAmp,incDuree,Vinit,Vfinale:single;
                 end;

  typeSortieAna=record
                  seg:array[1..10] of typeSegmentAna;
                  repetition: smallint;
                  Jru1,Jru2:smallint;
                  Yru1,Yru2:single;
                  YminStim,YmaxStim:single;
                  unitY:string[3];
                end;

  typePulseNum= record
                  date,duree,incDate,incDuree:single;
                  repetition:smallint;
                end;

  typeSortieNum=record
                  mode:byte;
                  pulse:array[1..10] of typePulseNum;
                  largeurPulse,cadencePulse,cadenceSalve:single;
                  NbSalve, NbPulse:smallint;
                  DelaiTrain: single;
                end;

  typeParamStimEx=  record
                        id:string[15];          { même entête que infoAc1 }
                        tailleInfo:SmallInt;

                        CadStim:single;

                        sAna:array[1..2] of typeSortieAna;

                        SNum:array[1..7] of typeSortieNum;

                        XminStim,XmaxStim:single;
                      end;



  TAC1Descriptor=class(TfileDescriptor)
                 private
                    infoAc1:typeInfoAC1; { Bloc info brut tiré du fichier }
                    x0u,dxu:double;
                    y0u,dyu:array[1..6] of double;


                    procedure initParamStimEx(var pp:typeParamStimEx);
                    procedure stim3to4(var pp:typeParamStim1;var pp1:typeParamStimEx);
                    procedure setParamStim(var pp:typeParamStimEx);

                 protected
                    stDat:AnsiString;    { nom fichier data }
                    stSP: AnsiString;     { nom fichier evt associé }

                    nbptSeq0:integer; { nombre de points par séquence lu dans
                                        l'entête ou bien correspondant à tout
                                        le fichier pour un fichier continu }
                    tailleSeq:integer;{ taille effective d'une séquence tenant
                                        compte de preseq,postSeq,nbptSeq0 et
                                        noAnalogData }

                    nbSeqDat0:integer;{ nombre de séquences (DAT ou (et) EVT) }

                    duree0:float;     { durée d'une séquence analogique }


                    sampleSize:integer;

                    numSeqC:integer;
                    Fdat,Fevt:boolean;

                    statEv:TtabStatEv;
                    longueurDat:integer;

                    BlocEpInfo,BlocFileInfo:TblocInfo;
                    fileInfoOffset:integer;

                    tabsEv: T16PtabLong;

                  public
                    constructor create;override;
                    destructor destroy;override;

                    function ControleEchelleX:boolean;
                    function ControleEchelleY(v:integer):boolean;

                    procedure readExtraInfo(f:TfileStream);
                    function initDF(st:AnsiString):boolean;
                    function initEVT(st:AnsiString):boolean;

                    function init(st:AnsiString):boolean;override;
                    function getEvtInfo(num:integer):typedataEv;override;
                    function nbvoie:integer;override;
                    function nbSeqDat:integer;override;
                    function nbSeqEv:integer;override;
                    function nbPtSeq(voie:integer):integer;override;

                    function NbVoiesAnalog:integer;virtual;

                    function getDataEvt(voie,seq:integer):typeDataB;
                    function getData1(voie,seq:integer):typeDataB;virtual;
                    function getMixedData(voie,seq:integer;var evtMode:boolean):typeDataB;

                    function getData(voie,seq:integer;var evtMode:boolean):typeDataB;override;
                    function getTpNum(voie,seq:integer):typetypeG;override;

                    function dateEvFile:integer;override;
                    function FichierContinu:boolean;override;

                    procedure displayInfo;override;
                    function unitX:AnsiString;override;
                    function unitY(num:integer):AnsiString;override;

                    procedure SauverPostSeq;override;
                    function getEpInfo(var x;size,dep:integer):boolean;override;
                    function SetEpInfo(var x;size,dep:integer):boolean;override;
                    function ReadEpInfo(var x;size:integer):boolean;override;
                    function WriteEpInfo(var x;size:integer):boolean;override;
                    procedure ResetEpInfo;override;


                    procedure SauverFileInfo;
                    function GetFileInfo(var x;size,dep:integer):boolean;override;
                    function SetFileInfo(var x;size,dep:integer):boolean;override;
                    function ReadFileInfo(var x;size:integer):boolean;override;
                    function WriteFileInfo(var x;size:integer):boolean;override;
                    procedure ResetFileInfo;override;

                    function fileInfoSize:integer;override;
                    function EpInfoSize:integer;override;

                    function DureeSeq:float;override;

                    function getFileInfoBuf:pointer;override;
                    function EpInfo:pointer;override;

                    procedure copyEvHeader(f:TfileStream);override;
                    procedure copyEvEp(num:integer;f:TfileStream);override;

                    function FileheaderSize:integer;override;
                    function isAcquis1:boolean;override;

                    function getSM2Info(num:integer;stName,st:AnsiString;var w;size:integer):boolean;
                    function getSM2RF(num:integer;var x,y,dx,dy,theta:float):boolean;


                    class function FileTypeName:AnsiString;override;
                  end;


var
  TDesc:array of TdescClass;

Procedure registerFileDesc(t:TdescClass);

IMPLEMENTATION


Procedure registerFileDesc(t:TdescClass);
begin
  setlength(Tdesc,length(Tdesc)+1);
  Tdesc[High(TDesc)]:=t;
end;

{****************** Méthodes de TfileDescriptor ******************************}

constructor TfileDescriptor.create;
begin
end;

destructor TfileDescriptor.destroy;
begin
  inherited;
end;

procedure TfileDescriptor.storeFileParams(f: TfileStream);
begin
  if assigned(f) then
  begin
    fileSizeD:=f.Size;
    dateD:=FileGetDate(f.Handle);
    FileAgeD:=  FileDateToDateTime(dateD);
  end;
end;


function TfileDescriptor.init(st:AnsiString):boolean;
begin
  init:=false;
end;

procedure TfileDescriptor.initEpisod(num: integer);
begin

end;

function TfileDescriptor.nbvoie:integer;
begin
  nbvoie:=0;
end;

function TfileDescriptor.nbSpk:integer;
begin
  result:=0;
end;


function TfileDescriptor.nbSeqDat:integer;
begin
  nbseqdat:=0;
end;

function TfileDescriptor.nbPtSeq(voie:integer):integer;
begin
  nbPtSeq:=0;
end;

function TfileDescriptor.getData(voie,seq:integer;var evtMode:boolean):typeDataB;
begin
  getData:=nil;
end;

function TfileDescriptor.getDataTag(voie,seq:integer):typeDataB;
begin
  getDataTag:=nil;
end;

function TfileDescriptor.getDataSpk(voie,seq:integer):typeDataB;
begin
  result:=nil;
end;

function TfileDescriptor.getDataAtt(voie,seq:integer):typeDataB;
begin
  result:=nil;
end;

function TfileDescriptor.getDataSpkWave(voie,seq:integer;var wavelen1,pretrig1:integer;var scaling:TspkWaveScaling):typeDataB;
begin
  result:=nil;
end;

function TfileDescriptor.getSound(voie: integer): typeDataB;
begin
  result:=nil;
end;


function TfileDescriptor.getTpNum(voie,seq:integer):typetypeG;
begin
  getTpNum:=G_smallint;
end;




function TfileDescriptor.getEvtInfo(num:integer):typedataEv;
begin
  getEvtInfo:=nil;
end;



function TfileDescriptor.nbSeqEv:integer;
begin
  nbSeqEv:=0;
end;


function TfileDescriptor.dateEvFile:integer;
begin
  dateEvFile:=0;
end;

function TfileDescriptor.FichierContinu:boolean;
begin
  FichierContinu:=false;
end;

procedure TfileDescriptor.displayInfo;
begin
end;

function TfileDescriptor.channelName(num:integer):AnsiString;
begin
  channelName:='';
end;

function TfileDescriptor.unitX:AnsiString;
begin
  unitX:='';
end;

function TfileDescriptor.unitY(num:integer):AnsiString;
begin
  unitY:='';
end;

function TfileDescriptor.DureeSeq:float;
begin
  result:=0;
end;

function TfileDescriptor.EpDuration:float;
begin
  result:=DureeSeq;
end;

procedure TfileDescriptor.SauverPostSeq;
begin
end;

function TfileDescriptor.getEpInfo(var x;size,dep:integer):boolean;
begin
  result:=false;
end;

function TfileDescriptor.SetEpInfo(var x;size,dep:integer):boolean;
begin
  result:=false;
end;

function TfileDescriptor.ReadEpInfo(var x;size:integer):boolean;
begin
  result:=false;
end;

function TfileDescriptor.WriteEpInfo(var x;size:integer):boolean;
begin
  result:=false;
end;

procedure TfileDescriptor.ResetEpInfo;
begin
end;

function TfileDescriptor.GetFileInfo(var x;size,dep:integer):boolean;
begin
  result:=false;
end;

function TfileDescriptor.SetFileInfo(var x;size,dep:integer):boolean;
begin
  result:=false;
end;

function TfileDescriptor.ReadFileInfo(var x;size:integer):boolean;
begin
  result:=false;
end;

function TfileDescriptor.WriteFileInfo(var x;size:integer):boolean;
begin
  result:=false;
end;

procedure TfileDescriptor.ResetFileInfo;
begin
end;


function TfileDescriptor.fileInfoSize:integer;
begin
  result:=0;
end;

function TfileDescriptor.EpInfoSize:integer;
begin
  result:=0;
end;


function TfileDescriptor.getFileInfoBuf:pointer;
begin
  result:=nil;
end;

function TfileDescriptor.EpInfo:pointer;
begin
  result:=nil;
end;

procedure TfileDescriptor.copyEvHeader(f:TfileStream);
begin
end;

procedure TfileDescriptor.copyEvEp(num:integer;f:TfileStream);
begin
end;

function TfileDescriptor.FileheaderSize:integer;
begin
  result:=0;
end;

function TfileDescriptor.isAcquis1:boolean;
begin
  result:=false;
end;

function TfileDescriptor.getMtag(numseq:integer):PMtagArray;
begin
  result:=nil;
end;

procedure TfileDescriptor.getElphyTag(numseq:integer;var tags:TtagRecArray;
                                      var x0u,dxu:float);
begin
  setLength(tags,0);
end;

procedure TfileDescriptor.CopyToBuffer(buf:pointer;bufSize:integer);
begin

end;

procedure TfileDescriptor.FreeFileStream;
begin
end;

function TfileDescriptor.getOIseq(n: integer;Const Finit:boolean=true): TOIseq;
begin
  result:=nil;
end;

function TfileDescriptor.OIseqCount: integer;
begin
  result:=0;
end;

class function TfileDescriptor.FileTypeName: AnsiString;
begin
  result:='';
end;


function TfileDescriptor.getAttlen: TarrayOfArrayOfInteger;
begin
  result:=nil;
end;


function TfileDescriptor.getVspkTotCount(n: integer): integer;
begin
  result:=0;
end;

function TfileDescriptor.getVTotCount(n: integer): integer;
begin
  result:=nbSeqDat*nbptSeq(n);
end;

function TfileDescriptor.getVtagTotCount: integer;
begin
  result:=0;
end;

function TfileDescriptor.getWspkTotCount(n: integer): integer;
begin
  result:=0;
end;

function TfileDescriptor.getTimeSpan: float;
begin
  result:=dureeSeq*nbSeqDat;
end;

procedure TfileDescriptor.getVNbSamps(n: integer; var nbSamps: TarrayOfInteger);
var
  i:integer;
begin
  setLength(nbSamps,nbSeqDat);
  for i:=0 to high(nbSamps) do nbSamps[i]:=nbptSeq(i-1);
end;

procedure TfileDescriptor.getVtagNbSamps(var nbSamps: TarrayOfInteger);
begin

end;

procedure TfileDescriptor.getVspkNbSamps(n: integer;  var nbSamps: TarrayOfInteger);
begin

end;

function TfileDescriptor.CyberTime(ep:integer): double;
begin
  result:=0;
end;

function TfileDescriptor.PCtime(ep:integer): longword;
begin
  result:=0;
end;

function TfileDescriptor.CorrectedCyberTime(ep:integer): double;
begin
  result:=0;
end;


function TfileDescriptor.SpkTableCount: integer;
begin
  result:=0;
end;

procedure TfileDescriptor.getPCLdata(var pcl: TOIseqPCL; ep:integer);
begin

end;

function TfileDescriptor.HasPCL:boolean;
begin
  result:=false;
end;

{****************** Méthodes de TAC1descriptor ******************************}



constructor TAC1Descriptor.create;
begin
  BlocEpInfo:=TblocInfo.create(0);
  BlocFileInfo:=TblocInfo.create(0);
end;

destructor TAC1Descriptor.destroy;
var
  i:integer;
begin
  statEv.free;
  BlocEpInfo.free;
  BlocFileInfo.free;
  for i:=0 to 15 do
  if tabsEv[i]<>nil then freemem(tabsEv[i]);

  inherited;
end;

function TAC1Descriptor.ControleEchelleX:boolean;
begin
  with infoAc1 do
  if (I1<>I2) and (x1<>x2) then
    begin
      Dxu:=(X2-X1)/(I2-I1);
      X0u:=X1-I1*Dxu;
      controleEchelleX:=true;
    end
  else controleEchelleX:=false;
end;

function TAC1Descriptor.ControleEchelleY(v:integer):boolean;
begin
  with infoAc1 do
  if (j1[v]<>j2[v]) and (y1[v]<>y2[v])  then
    begin
      Dyu[v]:=(Y2[v]-Y1[v])/(J2[v]-J1[v]);
      Y0u[v]:=Y1[v]-J1[v]*Dyu[v];
      controleEchelleY:=true;
    end
  else controleEchelleY:=false;
end;

procedure TAC1Descriptor.initParamStimEx(var pp:typeParamStimEx);
  var
    s,i:integer;
  begin
    fillchar(PP,sizeof(PP),0);
    with PP do
    begin
      id:='PARSTIMEX';
      tailleInfo:=sizeof(pp);
      cadStim:=1;
      for s:=1 to 2 do
        with sana[s] do
        begin
          for i:=1 to 10 do seg[i].mode:=1;
          Jru2:=2048;
          Yru2:=10000;
        end;
      for i:=1 to 7 do snum[i].mode:=1;
    end;
  end;



procedure TAC1Descriptor.stim3to4(var pp:typeParamStim1;var pp1:typeParamStimEx);
  var
    i,j:integer;
  begin
    initParamStimEx(pp1);
    with PP1 do
    begin
       CadStim:=pp.CadStim;
       with sana[1] do
       begin
         repetition:=pp.repetition;
         Jru1:=      pp.Jru1stim;
         Jru2:=      pp.Jru2stim;
         Yru1:=      pp.Yru1stim;
         Yru2:=      pp.Yru2stim;
         YminStim:=  pp.Yminstim;
         YmaxStim:=  pp.Ymaxstim;
         unitY:=     pp.UnitYstim;
         for i:=1 to 5 do
           begin
             seg[i].mode:=   pp.modeSortieAna[i];
             seg[i].duree:=  pp.dureeAna[i];
             seg[i].amp:=    pp.AmplitudeAnaE[i];
             seg[i].incAmp:= pp.IncrementAnaE[i];
             seg[i].Vinit:=  pp.VinitialeE[i];
             seg[i].Vfinale:=pp.VfinaleE[i];
           end;
       end;
       for i:=1 to 4 do
         with snum[i] do
         begin
           mode:=        pp.modeSortieNum[i];
           for j:=1 to 5 do
             with pulse[j] do
             begin
               date:= pp.dateNum[i,j];
               duree:=pp.dureeNum[i,j];
             end;
           largeurPulse:=pp.largeurPulse[i];
           cadencePulse:=pp.cadencePulse[i];
           cadenceSalve:=pp.cadenceSalve[i];
           NbSalve:=     pp.NbSalve[i];
           NbPulse:=     pp.NbPulse[i];
           DelaiTrain:=  pp.DelaiTrain[i];
         end;
    end;

  end;

procedure TAC1Descriptor.setParamStim(var pp:typeParamStimEx);
var
  i,j:integer;
begin

end;

procedure TAC1Descriptor.readExtraInfo(f:TfileStream);
var
  buf:array[1..1024] of byte;
  info1:typeInfoAC1 ABSOLUTE buf;
  pp:typeParamStim1 ABSOLUTE buf;
  pp1:typeParamStimEx;

  p:intG;
  res:intG;
  userBlockSize:integer;
begin
  f.Position:=1024;
  while (f.Position<infoAc1.tailleInfo-1)  do
  begin
    p:=f.Position;
    with info1 do f.Read(info1,sizeof(id)+sizeof(tailleInfo));
    {messageCentral(info1.id);}
    if (info1.Id='PARSTIM3') then
      begin

        f.read(info1.nbvoie,1024-sizeof(info1.id)-sizeof(info1.tailleInfo));

        Stim3to4(pp,pp1);
        SetParamStim(pp1);

      end
    else
    if info1.id='PARSTIMEX' then
      begin
        initParamStimEx(pp1);
        f.read(PP1.cadStim,
                     sizeof(PP1)-sizeof(info1.id)-sizeof(info1.tailleInfo));
        SetParamStim(pp1);
      end
    else
    if info1.Id='USER INFO' then
      begin
        UserBlockSize:=info1.tailleInfo-sizeof(info1.id)-sizeof(info1.tailleInfo);
        BlocFileInfo.free;
        BlocFileInfo:=TblocInfo.create(UserBlockSize);
        FileInfoOffset:=f.Position;
        BlocFileInfo.read(f);
      end;
  end;
end;

function TAC1Descriptor.initDF(st:AnsiString):boolean;
var
  res:intG;
  i:integer;
  f:TfileStream;
begin
  initDF:=false;

  stDat:=st;
  f:=nil;
  try
  f:=TfileStream.create(st,fmOpenReadWrite);
  
  storeFileParams(f);

  fillchar(infoAc1,sizeof(infoAc1),0);

  f.read(infoAc1,sizeof(infoAc1));

  if (infoAc1.id<>signatureAC1) then
    begin
      f.free;
      exit;
    end;

  if (infoAc1.nbvoie<1) or (infoAc1.nbvoie>16) then
   begin
      f.free;
      messageCentral('anomalous number of channels: '+Istr(infoAc1.nbvoie));
      exit;
    end;

  if byte(infoAc1.tpData)=0 then infoAc1.tpData:=G_smallint;

  SampleSize:=tailleTypeG[infoAc1.tpData];
  if not (infoAc1.tpData in [G_word,G_smallint,G_single]) then
    begin
      messageCentral('Unrecognized number type '+Istr(byte(infoAc1.tpData)));
      f.free;
      exit;
    end;

  nbptSeq0:=infoAc1.nbpt+longint(infoAc1.nbptEx)*32768;
  if infoAc1.continu
    then nbptSeq0:=(f.Size-infoAc1.tailleInfo) div (infoAc1.nbvoie*sampleSize);

  with infoAc1 do
  if not controleEchelleX then
    begin
      f.free;
      messageCentral('Anomalous X-scale parameters' );
      exit;
    end;

  for i:=1 to infoAc1.nbvoie do
    with infoAc1 do
    if not controleEchelleY(i) then
      begin
        f.free;
        messageCentral('Anomalous Y-scale parameters '
          +Istr(i)+'/'+Istr(j1[i])+'/'+Istr(j2[i])+'/'+
                       Estr(y1[i],3)+'/'+Estr(j2[i],3)
          );
        exit;
      end;


  longueurDat:=f.size-infoAc1.tailleInfo;
  with infoAc1 do
    if noAnalogData
      then tailleSeq:=preseqI+postSeqI
      else tailleSeq:=preseqI+postSeqI+nbptSeq0*sampleSize*nbvoie;

  if nbPtSeq0<>0
    then nbSeqDat0:=(f.Size-infoAc1.tailleInfo) div tailleSeq
    else nbSeqDat0:=0;
  if nbSeqDat0=0 then infoAc1.NoAnalogData:=true;

  readExtraInfo(f);


  duree0:=dxu*nbPtSeq0;

  BlocEpInfo.free;
  BlocEpInfo:=TblocInfo.create(infoAc1.postSeqI);

  f.free;
  result:=true;

  except
  f.Free;
  result:=false;
  end;
end;

function TAC1Descriptor.initEvt(st:AnsiString):boolean;
begin
  initEvt:=false;
  if not fileExists(st) then exit;
  stSP:=st;

  statEV:=TtabStatEv.create;
  if not statEV.initFile(st) then
    begin
      statEv.free;
      statEv:=nil;
    end
  else initEvt:=true;
end;

function TAC1Descriptor.init(st:AnsiString):boolean;
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

function TAC1descriptor.getData1(voie,seq:integer):typeDataB;
var
  infoSeq:typeInfoSeqAC1;
  res:intG;
  f:TfileStream;
  i:integer;
  offsetS:integer;
  data0:typeDataB;
begin
  getData1:=nil;
  if not Fdat or (voie<0) or (voie>infoAc1.nbvoie) or (seq>nbseqDat) then exit;

  numSeqC:=seq;

  with infoAc1 do
  begin
    offsetS:=tailleInfo+(seq-1)*tailleSeq;

    if echelleSeqI or (voie=1) and (postSeqI<>0) then
      begin
        f:=nil;
        try
        f:=TfileStream.Create(stDat,fmOpenRead);

        if echelleSeqI  then
          begin
            f.Position:=offsetS;
            f.read(infoSeq,sizeof(infoSeq));
            with infoSeq do
            begin
              ControleEchelleX;
              for i:=1 to infoAc1.nbvoie do
                ControleEchelleY(i);
            end;
          end;

        if (voie=1) or (voie=0) and (postSeqI<>0) then
          begin
            f.Position:=offsetS+tailleSeq-postSeqI;
            BlocEpInfo.read(f);
          end;

        f.free;
        except
        f.free;
        end;
      end;

    if noAnalogData or (voie=0) then exit;

    offsetS:=offsetS+preseqI+sampleSize*(voie-1);

    case Tpdata of
       G_smallint,g_word: data0:=typedataFileI.create(
                    stdat,offsetS,infoAc1.nbvoie,0,nbptSeq0-1,false);
       G_single:  data0:=typedataFileS.create(
                    stdat,offsetS,infoAc1.nbvoie,0,nbptSeq0-1,false);

    end;
  end;
  { Windows n'accepte pas que l'on ouvre plusieurs fois le même fichier.
    Il faut donc fermer le fichier à chaque chargement du buffer }
  data0.setConversionX(Dxu,X0u);
  data0.setConversionY(Dyu[voie],Y0u[voie]);

  getData1:=data0;
end;

function TAC1descriptor.getDataEvt(voie,seq:integer):typeDataB;
var
  i:integer;
  data0:typedataL;
begin
  if voie=1 then
    begin
      for i:=0 to 15 do
        if tabsEv[i]<>nil then
          begin
            freemem(tabsEv[i]);
            tabsEv[i]:=nil;
          end;

      statEv.loadSeq(seq,tabsEv);
    end;

  with statEv.stat[seq]^ do
  begin
    data0:=typeDataL.create(tabsEv[voie-1],1,1,1,n[voie-1]);
    data0.setConversionX(statEV.DeltaXSP,0);
    data0.setConversionY(statEV.DeltaXSP,0);

    data0.canFreeMem:=false;
    result:=data0;
    tabsEv[voie-1]:=nil;
  end;
end;


function TAC1descriptor.NbVoiesAnalog:integer;
begin
  if infoAc1.noAnalogData
    then result:=0
    else result:=infoAc1.nbvoie;
end;

function TAC1descriptor.getMixedData(voie,seq:integer;var evtMode:boolean):typeDataB;
begin
  if (NbVoiesAnalog=0) and (voie=1) then getData1(0,seq);

  if voie<=nbvoiesAnalog then
    begin
      result:=getData1(voie,seq);
      evtMode:=false;
    end
  else
    begin
      result:=getDataEvt(voie-NbVoiesAnalog,seq);
      evtMode:=true;
    end;
end;

function TAC1descriptor.getData(voie,seq:integer;var evtMode:boolean):typeDataB;
begin
  if Fdat and not Fevt then
    begin
      result:=getData1(voie,seq);
      evtMode:=false;
    end
  else
  if not Fdat and Fevt then
    begin
      result:=getDataEvt(voie,seq);
      evtMode:=true;
    end
  else result:=getMixedData(voie,seq,evtMode);

end;


function TAC1Descriptor.getTpNum(voie,seq:integer):typetypeG;
begin
  if Fdat and not Fevt
    then getTpNum:=infoAc1.tpdata
  else
  if not Fdat and Fevt
    then getTpNum:=G_longint
  else
  begin
    if voie<=nbVoiesAnalog
      then result:=infoAc1.tpdata
      else result:=G_longint;
  end;
end;

function TAC1Descriptor.getEvtInfo(num:integer):typedataEv;
var
  dataEV0:typedataFileEV;
begin
  getEvtInfo:=nil;
  if Fevt then
    with statEv do
    begin
      if (num>=1) and (num<=count) then
        begin
          with PrecEv(items[num-1])^ do
          begin
            dataEV0:=typeDataFileEv.create(stSP,debut+info,1,0,Spcount-1,false);
            dataEV0.setConversionX(DeltaXSP,0);
            getEvtInfo:=dataEV0;
          end;
        end;
    end;
end;

function TAC1Descriptor.getSM2Info(num:integer;stName,st:AnsiString;var w;size:integer):boolean;
var
  f:TfileStream;
  ok:boolean;
  conf:TblocConf;
  posmax:integer;
begin
  result:=false;
  if Fevt then
    with statEv do
    begin
      if (num>=1) and (num<=count) then
        begin
          with PrecEv(items[num-1])^ do
          begin
            TRY
              f:=nil;
              conf:=nil;

              f:=TfileStream.create(stDat,fmOpenRead);
              f.position:=debut;
              posMax:=debut+info;

              conf:=TblocConf.create(stName);
              conf.SetVarConf(st, w,size);

              repeat
                ok:=(conf.lire(f)=0);
              until ok or (f.position>=posmax);

              conf.free;
              f.free;
              result:=ok;

            EXCEPT
              conf.free;
              f.free;
            END;
          end;
        end;
    end;
end;

function TAC1Descriptor.getSM2RF(num:integer;var x,y,dx,dy,theta:float):boolean;
type
  typeDegre=record
              x,y,dx,dy,theta:single;
              col:smallInt;
            end;
var
  f:TfileStream;
  ok:boolean;
  conf:TblocConf;
  posmax:integer;
  rf:typeDegre;

begin
  fillchar(rf,sizeof(rf),0);
  result:=false;
  if Fevt then
    with statEv do
    begin
      if (num>=1) and (num<=count) then
        begin
          with PrecEv(items[num-1])^ do
          begin
            TRY
              f:=nil;
              conf:=nil;

              f:=TfileStream.create(stDat,fmOpenRead);
              f.Position:=debut;
              posMax:=debut+info;

              conf:=TblocConf.create('Revcor');
              conf.SetVarConf('RFdeg',RF,sizeof(RF));

              repeat
                ok:=(conf.lire(f)=0);
              until ok or (f.position>=posmax);

              conf.free;
              f.free;
              result:=ok;
            EXCEPT
              conf.free;
              f.free;
            END;
          end;
        end;
    end;

  x:=rf.x;
  y:=rf.y;
  dx:=rf.dx;
  dy:=rf.dy;
  theta:=rf.theta;
end;


function TAC1Descriptor.nbVoie:integer;
begin
  if Fdat and not Fevt
    then nbvoie:=infoAc1.nbvoie
  else
  if Fevt then
    nbvoie:=16;
end;

function TAC1Descriptor.nbSeqDat:integer;
begin
  if Fdat then result:=nbSeqDat0
  else
  if Fevt and assigned(statEv)
    then result:=statEv.count
  else result:=0;
end;

function TAC1Descriptor.nbSeqEv:integer;
begin
  if assigned(statEv)
    then nbseqEv:=statEv.count
    else nbSeqEv:=0;
end;

function TAC1Descriptor.nbPtSeq(voie:integer):integer;
begin
  nbPtSeq:=nbptSeq0;
end;


function TAC1Descriptor.dateEvFile:integer;
begin
  if assigned(statEv)
    then dateEvFile:=statEV.date
    else dateEvFile:=0;
end;

function TAC1Descriptor.FichierContinu:boolean;
begin
  FichierContinu:=Fdat and infoAc1.continu;
end;

procedure TAc1Descriptor.displayInfo;
var
  BoiteInfo:typeBoiteInfo;
  i,j:integer;
begin
  with BoiteInfo do
  begin
    BoiteInfo.init('File Informations');

    writeln(ExtractFileName(stDat)+'  '+Udate(DateD)+'  '+Utime(DateD) );
    writeln('Format: Acquis1');
    writeln('Header size: '+Istr(infoAc1.tailleInfo));
    writeln('Episode header size: '+Istr(infoAc1.preseqI));
    writeln('Episode info size: '+Istr(infoAc1.postSeqI));
    writeln('');
    if Fdat then
      begin
        write(Istr(nbVoie)+' channel');
        if nbvoie>1 then write('s ') else write(' ');

        if not FichierContinu then
          begin
            writeln('  '+Istr(nbPtSeq0)+' samples/channel' );
            writeln('Episode duration:'+Estr1(Duree0,10,3)+' '+infoAc1.uX);
            write(Istr(nbSeqDat)+' episode');
            if nbSeqDat>1 then writeln('s') else writeln('');
          end
        else
          begin
            writeln('         Continuous file');
            writeln('Duration:    '+Estr1(Duree0,10,3)+' '+infoAc1.uX);
            writeln('Sampling interval per channel:'+Estr1(Dxu,10,6)+' '+infoAc1.uX);
          end;

        writeln('File info block size='+Istr(BlocFileInfo.tailleBuf));
        writeln('Episode info block size='+Istr(infoAc1.postSeqI));

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

function TAc1Descriptor.unitX:AnsiString;
begin
  if Fdat
    then unitX:=infoAc1.ux
    else unitX:=statEv.unitXSP;
end;

function TAc1Descriptor.unitY(num:integer):AnsiString;
begin
  if Fdat
    then unitY:=infoAc1.uy[num]
    else unitY:='';
end;

function TAc1Descriptor.DureeSeq:float;
begin
  result:=duree0;
end;


function TAc1Descriptor.FileheaderSize:integer;
begin
  FileheaderSize:=infoAc1.tailleInfo;
end;

function TAc1Descriptor.isAcquis1:boolean;
begin
  result:=true;
end;


procedure TAc1Descriptor.SauverPostSeq;
var
  f:TfileStream;
begin
  if (stDat='') or (BlocEpinfo.tailleBuf=0)  then exit;

  f:=nil;
  TRY
  f:=TfileStream.create(stDat,fmOpenRead);

  f.Position:=FileHeaderSize+TailleSeq*numseqC-BlocEpinfo.tailleBuf ;
  BlocEpInfo.write(f);
  f.Free;
  Except
  f.Free;
  end;
end;

function TAc1Descriptor.getEpInfo(var x;size,dep:integer):boolean;
begin
  result:=BlocEpInfo.getInfo(x,size,dep);
end;

function TAc1Descriptor.SetEpInfo(var x;size,dep:integer):boolean;
begin
  result:=BlocEpInfo.setInfo(x,size,dep);
  sauverPostSeq;
end;

function TAc1Descriptor.ReadEpInfo(var x;size:integer):boolean;
begin
  result:=BlocEpInfo.readInfo(x,size);
end;

function TAc1Descriptor.WriteEpInfo(var x;size:integer):boolean;
begin
  result:=BlocEpInfo.writeInfo(x,size);
  sauverPostSeq;
end;

procedure TAc1Descriptor.ResetEpInfo;
begin
  BlocEpInfo.resetInfo;
end;


procedure TAc1Descriptor.SauverFileInfo;
var
  f:TfileStream;
begin
  if (stDat='') or (BlocFileInfo.tailleBuf=0)  then exit;

  f:=nil;
  TRY
  f:=TfileStream.Create(stDat,fmOpenReadWrite);

  f.Position:=FileInfoOffset;
  BlocFileInfo.write(f);
  f.free;
  Except
  f.free;
  End;
end;

function TAc1Descriptor.getFileInfo(var x;size,dep:integer):boolean;
begin
  result:=BlocFileInfo.getInfo(x,size,dep);
end;

function TAc1Descriptor.SetFileInfo(var x;size,dep:integer):boolean;
begin
  result:=BlocFileInfo.setInfo(x,size,dep);
  sauverFileInfo;
end;

function TAc1Descriptor.ReadFileInfo(var x;size:integer):boolean;
begin
  result:=BlocFileInfo.readInfo(x,size);
end;

function TAc1Descriptor.WriteFileInfo(var x;size:integer):boolean;
begin
  result:=BlocFileInfo.writeInfo(x,size);
  sauverFileInfo;
end;

procedure TAc1Descriptor.ResetFileInfo;
begin
  BlocFileInfo.resetInfo;
end;



function TAc1Descriptor.fileInfoSize:integer;
begin
  fileInfoSize:=BlocFileInfo.tailleBuf;
end;

function TAc1Descriptor.EpInfoSize:integer;
begin
  EpInfoSize:=BlocEpinfo.tailleBuf;
end;


function TAc1Descriptor.getFileInfoBuf:pointer;
begin
  result:=BlocFileInfo.buf;
end;


function TAc1Descriptor.EpInfo:pointer;
begin
  result:=BlocEpInfo.buf;
end;

procedure TAc1Descriptor.copyEvHeader(f:TfileStream);
var
  f1:TfileStream;
begin
  if (stSP='') or not assigned(statEv) then exit;

  f1:=nil;
  TRY
  f1:=TfileStream.Create(stSP,fmOpenRead);

  f.CopyFrom(f1,statEv.headerSize);

  f1.free;
  Except
  f1.Free;
  End;
end;

procedure TAc1Descriptor.copyEvEp(num:integer;f:TfileStream);
var
  f1:TfileStream;
begin
  if (stSP='') or not assigned(statEv) then exit;

  f1:=nil;
  TRY
  f1:=TfileStream.create(stSP,fmOpenRead);

  with PrecEv(statEv.items[num-1])^ do
  begin
    f1.Position:=debut-6;
    f.CopyFrom(f1,6+info+spCount*6);
  end;
  f1.free;
  Except
  f1.Free;
  End;
end;





class function TAC1Descriptor.FileTypeName: AnsiString;
begin
  result:='Acquis1';
end;





function TfileDescriptor.ReadPCLfilter(n: integer): TDBrecord;
begin

end;

end.
