unit descElphy1;


interface

uses windows,classes,forms,sysUtils,
     util1,Gdos,dtf0,descac1,spk0,blocInf0,debug0,
     Mtag2,
     stmdef,stmObj,ElphyFormat,OIblock1,stmOIseq1,
     acqDef2,
     objFile1,stmsys0,dataGeneFile,
     DBrecord1,
     PCL0;




var
  FlookForObj: boolean;          // A positionner pour rechercher les objets
                                 // ralentit énormément le chargement

type

  TEpFrecord=
    record
      OffSeq:int64;                     { Offset bloc seq }
      OffEpInfo:int64;                  { Offset bloc EpInfo }
      OffDBEpInfo:int64;                { Offset bloc DBEpInfo }
      OffVisuSys: int64;

      OffVstim:int64;                   { Offset bloc Stimulateur visuel}
      TotSize:longWord;                 { Taille des données analogiques (bytes)}
      datas:TKsegArray;                 { Tableau des segments analogiques }
      sounds:TKsegArray;                { Tableau des segments SON }
      tags:TtagRecArray;                { Tableau des Utags }
      evts:array of TKsegArray;         { Tableau des segments evt }
      spks:array of TKsegArray;         { Tableau des segments SPK }
      atts:array of TKsegArray;         { Tableau des segments att }
      Wspks:array of TKsegArray;        { Tableau des segments WSPK }
      CybTag: TKsegArray;               { Tableau des segments CyberTag }
      pcls: TKsegArray;                 { Tableau des segments PCL }
      Wavelen,Pretrig:smallint;
      WaveSize:integer;
      cybTime:double;                   { temps du CyberK en secondes }
      PCtime:longword;                  { temps du PC en millisecondes }

      nbSpk:integer;                    { nombre de canaux Vspk dans l'épisode
                                          Lu dans le bloc Rspk
                                        }
      SpkScale: TevtScaling;
      WaveScale: TspkWaveScaling;
      ElphyTime: TdateTime;
      CorrectedCybTime: double;
    end;

  TElphyDescriptor=
     class(TfileDescriptor)
       private
         OIblocks:array of ToiBlock;
         OIseqs:array of TOIseq;

         AttLen:TarrayOfArrayOfInteger; { tableau des nbs de spikes par épisode et par canal
                                          s'applique aux voies SPK ou WSPK
                                        }
         AnaLen:TarrayOfArrayOfInteger; { tableau des nbs de points par épisode et par canal
                                          s'applique aux voies analog et EVT
                                        }

         TotTime:float;

         vecStream:Tstream;

         NomIndexMax:longword;
         NbSpkTable:integer;

         Fhaspcl:boolean;

         PCLfilter: array of integer; // Numéros des blocks DBrecord avec id='_PCLfilter'

         VisuInfo: TDBrecord;

         function getFileStream: TStream;
         function getVecFileStream: TStream;

       public
         Fcontinu:boolean;
         stDat:AnsiString;

         fileSize0:int64;           {mis en place à chaque init ou reinit }

         currentEp:integer;         {Episode courant , commence à 1 }
         FileInfoOffset: int64;

         ObjFile:TobjectFile;

         BCom:TcommentBlock;        {LE commentaire (inutile: jamais utilisé) }
         BfileInfo:TfileInfoBlock;  {LE bloc fileInfo}
         DBfileInfo: TDBrecord;
         BEpInfo:TepInfoBlock;      {Bloc EpInfo de la séquence courante}
         DBepInfo:TDBrecord;
         Bseq:TseqBlock;            {Bloc Seq de la séquence courante}

         seqs:array of TepFrecord;  {Regroupe des infos pour chaque séquence}

         voieTagX:integer;

         infoForm:Tform;


          constructor create;override;
          destructor destroy;override;

          function init0(numClasse0:integer):boolean;
          function init(st:AnsiString):boolean;override;

          function reinit:boolean;

          procedure BuildAnalen;
          procedure initEpisod(num:integer);override;
          function nbvoie:integer;override;
          function nbSpk:integer;override;
          function nbSeqDat:integer;override;
          function nbPtSeq(voie:integer):integer;override;

          function getData(voie,seq0:integer;var evtMode:boolean):typeDataB;override;
          function getTpNum(voie,seq:integer):typetypeG;override;
          function getDataTag(voie,seq0:integer):typeDataB;override;
          function getDataSpk(voie,seq0:integer):typeDataB;override;
          function getDataAtt(voie,seq0:integer):typeDataB;override;
          function getDataSpkWave(voie,seq0:integer;var wavelen1,pretrig1:integer;var scaling:TspkWaveScaling):typeDataB;override;

          function getSound(voie:integer):typeDataB;override;

          function FichierContinu:boolean;override;

          procedure displayInfo;override;
          function unitX:AnsiString;override;
          function unitY(num:integer):AnsiString;override;

          function getFileInfoCopy:TblocInfo;


          function nbSeqEv:integer;override;
          function dateEvFile:integer;virtual;

          function channelName(num:integer):AnsiString;override;

          function DureeSeq:float;override;
          function EpDuration:float;override;

          procedure SauverBlocEpInfo;
          function getEpInfo(var x;size,dep:integer):boolean;override;
          function SetEpInfo(var x;size,dep:integer):boolean;override;
          function ReadEpInfo(var x;size:integer):boolean;override;
          function WriteEpInfo(var x;size:integer):boolean;override;
          procedure ResetEpInfo;override;

          procedure SauverBlocFileInfo;
          function GetFileInfo(var x;size,dep:integer):boolean;override;
          function SetFileInfo(var x;size,dep:integer):boolean;override;
          function ReadFileInfo(var x;size:integer):boolean;override;
          function WriteFileInfo(var x;size:integer):boolean;override;
          procedure ResetFileInfo;override;

          function fileInfoSize:integer;override;
          function EpInfoSize:integer;override;

          function getFileInfoBuf:pointer;override;
          function EpInfo:pointer;override;

          procedure copyEvHeader(f:TfileStream);override;
          procedure copyEvEp(num:integer;f:TfileStream);override;

          function isAcquis1:boolean;override;

          function getVSposition(NumEp:integer):int64;
          procedure CopyToBuffer(buf:pointer;bufSize:integer);override;

          procedure getElphyTag(numseq:integer;var tags:TtagRecArray;
                                var x0u,dxu:float);override;

          function SearchName(st: AnsiString;numOc:integer): integer;
          function SearchAndload(st:AnsiString;numOc:integer;pu:typeUO):boolean;

          function getOIblock(n:integer):TOIblock;
          function OIseqCount:integer;override;

          property  FileStream:TStream read getfileStream;
          procedure FreeFileStream;override;

          function getOIseq(n:integer;Const Finit:boolean=true):TOIseq;override;
          procedure AppendOIblocks(Src: AnsiString; const tpF:integer=1);

          procedure BuildOIvecFile(stF:AnsiString);
          procedure setOIvecFile(stF:AnsiString);

          class function FileTypeName:AnsiString;override;

          function ReadDBFileInfo:TDBrecord;
          function ReadDBepInfo:TDBrecord;

          function getAttlen:TarrayOfArrayOfInteger;override;

          function getVTotCount(n:integer):integer;override;      {nb total de points sur v[n] }
          function getVspkTotCount(n:integer):integer;override;   {nb total de spikes sur vspk[n] }
          function getWspkTotCount(n:integer):integer;override;   {nb total de spikes sur Wspk[n] }
          function getVtagTotCount: integer;override;

          procedure getVNbSamps(n: integer;var nbSamps: TarrayOfInteger);override;
          procedure getVspkNbSamps(n: integer;  var nbSamps: TarrayOfInteger);override;
          procedure getVtagNbSamps(var nbSamps: TarrayOfInteger);override;

          function getTimeSpan: float;override;

          function CyberTime(ep:integer):double;override;
          function PCtime(ep:integer):longword;override;
          function CorrectedCyberTime(ep:integer):double;override;

          function SpkTableCount: integer;override;

          function getVcounts(n,ep:integer):integer;
          function getVtagCounts(n,ep:integer):integer;
          function getVspkCounts(n,ep:integer):integer;

          function HasPCL:boolean;override;
          procedure getPCLdata(var OIpcl: TOIseqPCL; ep:integer);override;

          procedure CloseLastDataBlock;

          function ReadPCLfilter(n:integer):TDBrecord;override;
          function ElphyDataTime(ep:integer): TdateTime;
          function EpPCtime(ep: integer): longword;

          procedure getVisuInfo(vs: TDBrecord);
        end;


procedure ElphyFileToAnalogBinaryFile(stSrc,stDest: AnsiString; Vchan:TarrayOfInteger;  var VstartPos: TarrayOfInt64;  DW: integer; mux:boolean);

implementation

uses stmstmX0,ElphyInfo1,stmSpkTable1,
     stmVec1,
     NcDef2,stmPg ;

{****************** Méthodes de TElphyDescriptor ******************************}

constructor TElphyDescriptor.create;
begin
  inherited;

  objFile:=TobjectFile.create;
  objFile.NotPublished:=true;
end;

destructor TElphyDescriptor.destroy;
var
  i:integer;
begin
  infoform.free;

  for i:=0 to high(OiBlocks) do
  begin
    oiBlocks[i].Free;
    oiSeqs[i].Free;
  end;

  objFile.free;

  BCom.free;
  BfileInfo.free;
  DBfileInfo.free;
  BEpInfo.free;
  DBEpInfo.free;
  Bseq.free;

  vecStream.Free;

  inherited;
end;

function TElphyDescriptor.init0(numClasse0:integer):boolean;
var
  stmName:AnsiString;
  stmIdent:AnsiString;
  UOclass:TUOclass;
  OK:boolean;
  i:integer;
  Rseq:TseqBlock;
  Rdata:TRdataBlock;
  Rsound:TRsoundBlock;
  Revt:TReventBlock;
  Rspk:TRspkBlock;
  RWspk:TRspkWaveBlock;
  RcybTag: TRcyberTagBlock;
  Utag:TuserTagBlock;
  Rpcl: TRpclBlock;

  Isize:LongWord;
  EPX:integer;
  numB:integer;

  n:integer;
begin

  Rseq:=TseqBlock.create;
  Rdata:=TRdataBlock.create;
  Rsound:=TRsoundBlock.create;
  Revt:=TReventBlock.create;
  Rspk:=TRspkBlock.create;
  RWspk:=TRspkWaveBlock.create;
  Utag:=TUserTagBlock.create;
  RcybTag:= TRcyberTagBlock.create;
  Rpcl:=TRpclBlock.create;

  if assigned(fileStream) then
  TRY

  with objFile do
  begin
    for numB:=numClasse0 to stClasses.count-1 do
    begin
      stmName:=  stClasses[numB];
      stmIdent:= stNames[numB];
      UOclass:=stmClass(stmName);
      filestream.Position:=BlockOffset[numB];

      if UOclass=TUserTagBlock then
         begin
           Utag.Utag.ep:=-1;
           Utag.Utag.withObj:=false;
           Utag.loadX(fileStream);

           if length(seqs)=0 then
           begin
             setLength(seqs,length(seqs)+1);
             fillchar(seqs[high(seqs)],sizeof(TepFrecord),0);
           end;

           if (Utag.Utag.ep>=0) and (Utag.Utag.ep<length(seqs))
             then EPX:=Utag.Utag.ep
             else EPX:=high(seqs);

           with seqs[EPX] do
           begin
             setLength(tags,length(tags)+1);
             with tags[high(tags)] do
             begin
               SampleIndex:=Utag.Utag.SampleIndex;
               Stime:=Utag.Utag.Stime;
               code:=Utag.Utag.code;
               ep:=EPX;
               st:=Utag.stCom;
               ObjOffs:=BlockOffset[numB+1];
             end;
           end;

         end
       else
       if (UOclass=TseqBlock) then
         begin
           Rseq.loadX(fileStream);
           if (length(seqs)=0) OR (seqs[high(seqs)].OffSeq>0) then
           begin
             setLength(seqs,length(seqs)+1);
             fillchar(seqs[high(seqs)],sizeof(TepFrecord),0);

             setLength(attlen,length(attlen)+1);
             //setlength(attlen[high(attlen)],Rseq.seq.nbSpk);
             //fillchar(attlen[high(attlen)][0], Rseq.seq.nbSpk*4,0);

           end;
           with seqs[high(seqs)] do
           begin
             OffSeq:=  BlockOffset[numB];
             cybTime:= Rseq.seq.CyberTime;
             PCTime:=  Rseq.seq.PCTime;
           end;

         end
       else
       if (stmName='RDATA') and (length(seqs)>0) then
         begin
           Rdata.loadX(fileStream);
           with seqs[high(seqs)] do
           begin
             if length(datas)=0 then ElphyTime:=Rdata.Stime;

             setLength(datas,high(datas)+2);
             with datas[high(datas)] do
             begin
               Off:=Rdata.DataOffset;
               Size:=Rdata.Datasize;
               inc(totSize,size);
               if Rdata.NomIndex>NomIndexMax then NomIndexMax:= Rdata.NomIndex;
             end;
           end;
         end
       else
       if (stmName='RSOUND') and (length(seqs)>0) then
         begin
           Rsound.loadX(fileStream);

           with seqs[high(seqs)] do
           begin
             setLength(sounds,high(sounds)+2);
             with sounds[high(sounds)] do
             begin
               Off:=Rsound.DataOffset;
               Size:=Rsound.Datasize;
               inc(totSize,size);
             end;
           end;
         end
       else
       if (stmName='REVT') and (length(seqs)>0) then
         begin
           Revt.expectedNbEv:=Rseq.EvtChCount;
           Revt.loadX(fileStream);
           with seqs[high(seqs)] do
           begin
             setLength(evts,Revt.nbVev);
             Isize:=0;
             for i:=0 to Revt.nbVev-1 do
             begin
               setLength(evts[i],length(evts[i])+1);
               with evts[i][high(evts[i])] do
               begin
                 Off:=Revt.DataOffset+Isize;
                 Size:=Revt.nbEv[i]*4;
                 Isize:=Isize+size;
               end;
             end;
           end;
         end
       else
       if (stmName='RSPK') and (length(seqs)>0) then
         begin
           Rspk.loadX(fileStream);
           with seqs[high(seqs)] do
           begin
             nbspk:= Rspk.nbVev;       // ajouté  mai 2013
             SpkScale:=Rspk.scaling;   // id

             setLength(spks,Rspk.nbVev);
             setLength(atts,Rspk.nbVev);

             if length(attlen[high(attlen)])=0 then
             begin
               setlength(attlen[high(attlen)],Rspk.nbVev);
               fillchar(attlen[high(attlen),0],Rspk.nbVev,0);
             end;

             Isize:=0;
             for i:=0 to Rspk.nbVev-1 do
             begin
               setLength(spks[i],length(spks[i])+1);
               with spks[i][high(spks[i])] do
               begin
                 Off:=Rspk.DataOffset+Isize;
                 Size:=Rspk.nbEv[i]*4;
                 Isize:=Isize+size;
               end;

               setLength(atts[i],length(atts[i])+1);
               with atts[i][high(atts[i])] do
               begin
                 Off:=Rspk.DataOffset+Isize;
                 Size:=Rspk.nbEv[i];
                 Isize:=Isize+size;
               end;

               inc(attlen[high(attlen),i],Rspk.nbEv[i]);
             end;
           end;
         end
       else
       if (stmName=TRspkWaveBlock.STMClassName) and (length(seqs)>0) then
         begin
           RWspk.loadX(fileStream);
           with seqs[high(seqs)] do
           begin
             waveScale:=Rwspk.scaling;

             waveSize:=RWspk.waveSize;
             waveLen:=RWspk.Wavelen;
             Pretrig:=RWspk.Pretrig;
             setLength(Wspks,RWspk.nbVev);

             Isize:=0;
             for i:=0 to RWspk.nbVev-1 do
             begin
               setLength(Wspks[i],length(Wspks[i])+1);
               with Wspks[i][high(Wspks[i])] do
               begin
                 Off:=RWspk.DataOffset+Isize;
                 Size:=RWspk.nbEv[i]*RWspk.waveSize;
                 Isize:=Isize+size;
               end;
             end;
           end;
         end
       else
       if (stmName=TRCyberTagBlock.STMClassName) and (length(seqs)>0) then
         begin
           RcybTag.loadX(fileStream);
           with seqs[high(seqs)] do
           begin
             setLength(CybTag,length(CybTag)+1);
             with cybtag[high(cybTag)] do
             begin
               Off:=RCybTag.DataOffset;
               Size:=RCybTag.dataSize;
             end;
           end;
         end
       else
        if (stmName=TRpclBlock.STMClassName) and (length(seqs)>0) then
         begin
           Rpcl.loadX(fileStream);
           with seqs[high(seqs)] do
           begin
             setLength(pcls,length(pcls)+1);
             with pcls[high(pcls)] do
             begin
               Off:=Rpcl.DataOffset;
               Size:=Rpcl.nbphoton*sizeof(TPCLrecord);
             end;
           end;
           Fhaspcl:=true;
         end
       else
       if (UOclass=TepInfoBlock) and (length(seqs)>0)  then
         begin
           with seqs[high(seqs)] do
           begin
             OffEpInfo:=fileStream.position;
           end;
         end
       else
       if (UOclass=TsystemVS) and (length(seqs)>0)  then
         begin
           with seqs[high(seqs)] do
           begin
             OffVisuSys:=fileStream.position;
           end;
         end

       else
       if (UOclass=TDBrecord) then
       begin
         if (stmIdent='Ep Info') and (length(seqs)>0)  then
         begin
           with seqs[high(seqs)] do
           begin
             OffDBEpInfo:=fileStream.position;
           end;
         end
         else
         if (stmIdent='_PCLfilter')  then
         begin
           setlength(PCLfilter,length(PCLfilter)+1);
           PCLfilter[high(PCLfilter)]:=numB;
         end
       end
       else
       if (UOclass=TOIblock)   then
         begin
           n:=length(oiBlocks);
           setLength(oiBlocks,n+1);
           setLength(oiSeqs,n+1);

           oiBlocks[n]:=ToiBlock.create;
           oiBlocks[n].loadX(fileStream);

           oiSeqs[n]:=Toiseq.create;
           oiSeqs[n].NotPublished:=true;
           oiSeqs[n].ident:=ident+'.OIseq['+Istr(n+1)+']';
         end
       else
       if (UOclass=TspkTable)
         then inc(NbSpkTable)

       else
       if testUnic and assigned(UOclass) and (UOclass.inheritsFrom(Tstim)
          or (UOclass=TsystemVS)) then
         begin
           with seqs[high(seqs)] do
           if OffVstim=0 then OffVstim:=fileStream.position;
         end
       else
       if not assigned(UOclass) then
         begin
           if (numB>0) and (stClasses[numB-1]='RDATA') then
             with seqs[high(seqs)],datas[high(datas)] do
             if size=0 then
               size:=fileStream.size-Off;
         end;
      end;

  end;


  result:=true;

  Rseq.free;
  Rdata.Free;
  Rsound.free;
  Revt.free;
  Rspk.Free;
  RWspk.Free;
  Utag.free;
  RCybTag.Free;

  EXCEPT
  Rseq.free;
  Rdata.Free;
  Rsound.free;
  Revt.free;
  Rspk.Free;
  RWspk.Free;
  Utag.free;
  RCybTag.Free;

  END;
end;

function TElphyDescriptor.init(st:AnsiString):boolean;
var
  ftest:TfileStream;
  header:TheaderObjectFile;

begin
  setLength(seqs,0);
  result:=false;

  {Vérifier que le fichier est du type Elphy car objfile accepte aussi DAC2 }
  stDat:=st;
  TRY
    ftest:=nil;
    ftest:=TfileStream.create(stDat,fmOpenRead);

    fileSize0:=ftest.size;

    storeFileParams(ftest);
    header.id:='';
    ftest.read(header,sizeof(header));
  EXCEPT
    ftest.free;
    exit;
  END;

  ftest.free;
  if header.id<>ObjectFileId then exit;


  {Initialiser ObjFile }
  objFile.OpenFile(st,FlookForObj);

  with objFile do
  begin
    typeUO(Bcom):=CreateOcc(1,TcommentBlock);
    typeUO(BfileInfo):=CreateOcc(1,TfileInfoBlock, FileInfoOffset);

    typeUO(DBfileInfo):=CreateOcc(1,TDBrecord);
    if assigned(DBfileInfo) then
      if (DBfileInfo.stId<>'File Info') then
      begin
        DBfileInfo.free;
        DBfileInfo:=nil;
      end
      else DBfileInfo.Fchild:=true;

    typeUO(Bseq):=CreateOcc(1,TseqBlock);
  end;

  result:=init0(0);

  if FlookForObj then displayInfo;
  FlookForObj:=false;
end;

function TElphyDescriptor.Reinit:boolean;
var
  header:TheaderObjectFile;
  oldClasseCount:integer;
begin
  oldClasseCount:=objFile.stClasses.count;
  {reInitialiser ObjFile }
  fileSize0:=objFile.analyzeFile1(fileSize0);

  with objFile do
  begin
    if not assigned(Bcom) then typeUO(Bcom):=CreateOcc(1,TcommentBlock);
    if not assigned(BfileInfo) then typeUO(BfileInfo):=CreateOcc(1,TfileInfoBlock);
    if not assigned(Bseq) then typeUO(Bseq):=CreateOcc(1,TseqBlock);
  end;

  result:=init0(oldClasseCount);
end;


procedure TElphyDescriptor.BuildAnalen;
var
  i,j,num:integer;
  size:longword;
  Rseq:TseqBlock;
  numVeV:integer;
  timeT,prevT: float;
begin
  setLength(analen,length(seqs));
  TotTime:=0;

  if assigned(fileStream) then
  TRY
    Rseq:=TseqBlock.create;
    for num:=0 to high(seqs) do
    begin
      fileStream.Position:=seqs[num].offSeq;
      readHeader(fileStream,size);
      Rseq.loadFromStream(fileStream,size,false);
      Rseq.BuildMask(seqs[num].TotSize);

      setLength(analen[num],Rseq.seq.nbvoie);

      numVeV:=-1;
      for i:=1 to Rseq.seq.nbvoie do
      begin
        analen[num,i-1]:=Rseq.SamplePerChan(i-1);
        if Rseq.Ksampling[i-1]=0{ analen[num,i-1]=0} then                  { voies EVT }
        begin
          inc(numVeV);
          for j:=0 to high(seqs[num].evts[numVeV]) do
            analen[num,i-1]:= analen[num,i-1] + seqs[num].evts[numVeV][j].size div 4 ;
        end;
      end;

      seqs[num].cybTime:=Rseq.seq.CyberTime;
      seqs[num].PCTime:=Rseq.seq.PCTime;

      TotTime:=TotTime+Rseq.Tmax;

      // calcul de correctedCybTime
      timeT :=seqs[num].cybTime;   // temps absolu en secondes
      if (num>0) and ((TimeT<prevT) or (timeT>10000)) then timeT:= prevT;
      seqs[num].CorrectedCybTime:= timeT;
      prevT:= timeT+ Rseq.Tmax/1000;

    end;

    if Rseq.seq.uX<>'sec' then TotTime:=TotTime/1000;
  FINALLY
    Rseq.free;
  END;
end;

procedure TElphyDescriptor.initEpisod(num:integer);
var
  i,Kmin:integer;
  size:longword;
begin
  currentEp:=num;
  voieTagX:=-1;

  if assigned(fileStream) then
  TRY
    fileStream.Position:=seqs[num-1].offSeq;
    readHeader(fileStream,size);
    Bseq.loadFromStream(fileStream,size,false);
    Bseq.BuildMask(seqs[num-1].TotSize);

    case Bseq.seq.FormatOption of
      0:if length(seqs[num-1].CybTag)>0 then voieTagX:=1
        else
        if Bseq.seq.TagMode<>tmNone then
        begin
          Kmin:=100000;
          for i:=1 to Bseq.seq.nbvoie do
            if (Bseq.Ksampling[i-1]>0) and (Bseq.Ksampling[i-1]<Kmin) then
            begin
              voieTagX:=i;
              Kmin:=Bseq.Ksampling[i-1];
            end;

          if Bseq.seq.TagMode=tmITC then voieTagX:=Bseq.seq.nbvoie;
        end;
      1:begin
          if length(seqs[num-1].CybTag)>0 then voieTagX:=1
          else
          // on considère que la voie tags est la dernière
          if Bseq.seq.TagMode=tmITC then voieTagX:=Bseq.seq.nbvoie;
        end;
    end;
    with seqs[num-1] do
    begin
      if OffEpInfo<>0 then
        begin
          if not assigned(BepInfo) then BepInfo:=TepInfoBlock.create;
          fileStream.Position:=OffEpInfo;
          readHeader(fileStream,size);
          BepInfo.loadFromStream(fileStream,size,false);
        end
      else
        begin
          BepInfo.free;
          BepInfo:=nil;
        end;

      if OffDBEpInfo<>0 then
        begin
          if not assigned(DBepInfo) then DBepInfo:=TDBrecord.create;
          fileStream.Position:=OffDBEpInfo;
          readHeader(fileStream,size);
          DBepInfo.loadFromStream(fileStream,size,false);
        end
      else
        begin
          DBepInfo.free;
          DBepInfo:=nil;
        end;
    end;

  EXCEPT
  END;
end;


function TElphyDescriptor.getData(voie,seq0:integer;var evtMode:boolean):typeDataB;
var
  size:LongWord;
  i:integer;
  offsetS:integer;
  data0:typeDataB;
  mask:Tmsk;
  maskSize:TmskSize;
  shift:integer;
  fini:boolean;
  Kmin:integer;
  NonVide:boolean;
  voieEv:integer;
  Dx1:float;

begin
  data0:=nil;
  result:=nil;
  evtMode:=false;

  if seq0>nbseqDat then exit;
  if currentEp<>seq0 then initEpisod(seq0);

  if (voie<0) or (voie>nbvoie) then exit;

  if nbvoie=0 then exit;

  with Bseq,seq do
  begin
    case FormatOption of
      0:if Ksampling[voie-1]=0 then
          begin
            voieEv:=-1;
            for i:=1 to voie do
             if Ksampling[i-1]=0 then inc(voieEv);

            if high(seqs[seq0-1].evts)>=voieEv then
            begin
              data0:=typeDataFileSegL.create(getfileStream,seqs[seq0-1].evts[voieEv],false);
              if DxuSpk>0 then   { Vecteurs d'événements en CyberK , jamais utilisé  }
              begin
                data0.setConversionX(Dxu,X0u);
                data0.setConversionY(Dxu,X0u);
              end
              else
              begin             { vecteurs d'événements ordinaires }
                if DigEventCh=voie then
                begin
                  Dx1:=DigEventDxu;
                  if not continu then Dx1:=Dx1*1000;
                end
                else
                if DxEvent>0 then Dx1:=DxEvent
                else Dx1:=Dxu/nbvoie;
                data0.setConversionX(Dx1,X0u);
                data0.setConversionY(Dx1,X0u);
              end
            end;
            evtMode:=true;
          end
        else
          begin
            setLength(mask,Length(ChanMask));
            setLength(maskSize,Length(ChanMask));

            NonVide:=false;
            for i:=0 to high(mask) do
            begin
              mask[i]:=(chanMask[i]=voie-1);
              maskSize[i]:=  TailleTypeG[Ktype[chanMask[i]]];
              NonVide:=Nonvide or mask[i];
            end;
            NonVide:=NonVide and (segArraySize(seqs[seq0-1].datas)>0);

            if TagMode<>tmNone
              then shift:=TagShift
              else shift:=0;

            if nonVide then
              case Bseq.Ktype[voie-1] of
                g_smallint,g_word: data0:=typedataFileIK.create(getfileStream,mask,maskSize,seqs[seq0-1].datas,false,Shift,0);
                g_single:          data0:=typedataFileSK.create(getfileStream,mask,maskSize,seqs[seq0-1].datas,false);
                g_double:          data0:=typedataFileDK.create(getfileStream,mask,maskSize,seqs[seq0-1].datas,false);

              end
            else data0:=nil;

            if assigned(data0) then
              begin
                data0.setConversionX(Dxu*Ksampling[voie-1],X0u);
                data0.setConversionY(getDyu(voie-1),getY0u(voie-1));
              end;
          end;
      1:begin
          case Ktype[voie-1] of
            g_smallint: data0:=typedataFileI.create(getFileStream,seqs[seq0-1].datas[0].off + getOffset2(voie-1),1,getImin(voie-1),getImax(voie-1),false);
            g_single: data0:=typedataFileS.create(getFileStream,seqs[seq0-1].datas[0].off + getOffset2(voie-1),1,getImin(voie-1),getImax(voie-1),false);

          end;
          if assigned(data0) then
            begin
              data0.setConversionX(getDxu(voie-1),getX0u(voie-1));
              data0.setConversionY(getDyu(voie-1),getY0u(voie-1));
            end;
        end;
    end;
  end;

  result:=data0;

end;

function TElphyDescriptor.getTpNum(voie,seq:integer):typetypeG;
begin
  if assigned(Bseq) then
    begin
      if Bseq.Ksampling[voie-1]=0
        then result:=G_longint
        else result:=Bseq.Ktype[voie-1];
    end
  else
    result:=G_smallint;

  if result=g_word then result:=g_smallint;
  { A la suite d'une erreur, le type rangé dans le fichier a été G_word au lieu de G_smallint pendant
    un certain temps;
    Heureusement, les cartes d'acq ne rangent que des smallint dans les fichiers.
  }
end;

function TElphyDescriptor.getDataTag(voie,seq0:integer):typeDataB;
var
  size:integer;
  i:integer;
  offsetS:integer;
  data0:typeDataB;
  mask:Tmsk;
  maskSize:TmskSize;
  NonVide:boolean;

begin
  result:=nil;

  if (voie<0) or (seq0>nbseqDat) then exit;
  if voieTagX<=0 then exit;

  if length(seqs[seq0-1].CybTag)>0 then
    begin
      data0:=typeDataFileTagK.create(getFileStream,seqs[seq0-1].CybTag,1 shl (voie-1));
      if assigned(data0) then
      begin
        //data0.setConversionX(Dxu,X0u);
        if Fcontinu
          then data0.setConversionX(1/30000,0)  // modif 10-10-16
          else data0.setConversionX(1/30,0);
      end;
      result:= data0;
    end
  else
  case Bseq.seq.FormatOption of
    0:begin
        if Bseq.AnalogChCount=0 then exit;

        with Bseq,seq do
        begin
            setLength(mask,Length(ChanMask));
            setLength(maskSize,Length(ChanMask));

            NonVide:=false;
            for i:=0 to high(mask) do
            begin
              mask[i]:=(chanMask[i]=voietagX-1);
              maskSize[i]:=  TailleTypeG[Ktype[chanMask[i]]];
              NonVide:=Nonvide or mask[i];
            end;
            NonVide:=NonVide and (segArraySize(seqs[seq0-1].datas)>0);

            if nonVide
              then data0:= typedataFileIK.create(getfileStream,mask,maskSize,seqs[seq0-1].datas,false,0,1 shl (voie-1))
              else data0:=nil;

            if assigned(data0) then
              data0.setConversionX(Dxu*Ksampling[voietagX-1],X0u);
        end;

        result:=data0;
      end;
    1:begin
        with Bseq,seq do
        begin
          data0:=typedataFileDigiTag.create(getFileStream,seqs[seq0-1].datas[0].off + getOffset2(nbvoie-1),1,getImin(nbvoie-1),getImax(nbvoie-1),false,1 shl (voie-1));
          if assigned(data0) then
            data0.setConversionX(getDxu(voieTagX-1),getX0u(voieTagX-1));
        end;
        result:=data0;
      end;
  end;
end;

function TElphyDescriptor.getDataSpk(voie,seq0:integer):typeDataB;
var
  data0:typeDataB;
  voieEv:integer;

begin
  data0:=nil;
  result:=nil;

  if seq0>nbseqDat then exit;
  if currentEp<>seq0 then initEpisod(seq0);


  if (voie<1) or (voie>nbSpk) then exit;
  voieEv:=voie-1;

  with Bseq,seq do
  begin
    if high(seqs[seq0-1].spks)>=voieEv then
    begin
      data0:=typeDataFileSegL.create(getfileStream,seqs[seq0-1].spks[voieEv],false);

      if seqs[seq0-1].SpkScale.Dxu<>0 then  // Si le bloc scale existe dans le fichier
      with seqs[seq0-1].SpkScale do         // on l'utilise
      begin
        data0.setConversionX(Dxu,X0u);
        data0.setConversionY(Dxu,X0u);
      end
      else
      begin
        data0.setConversionX(Dxu,X0u);
        data0.setConversionY(Dxu,X0u);
      end
    end;
  end;

  result:=data0;
end;

function TElphyDescriptor.getDataAtt(voie,seq0:integer):typeDataB;
var
  data0:typeDataB;
  voieEv:integer;

begin
  data0:=nil;
  result:=nil;

  if seq0>nbseqDat then exit;
  if currentEp<>seq0 then initEpisod(seq0);

  if (voie<1) or (voie>nbSpk) then exit;
  voieEv:=voie-1;

  with Bseq,seq do
  begin
    if high(seqs[seq0-1].atts)>=voieEv then
    begin
      data0:=typeDataFileSegB.create(getfileStream,seqs[seq0-1].atts[voieEv],false);

      data0.setConversionX(Dxu,X0u);
      data0.setConversionY(Dxu,X0u);
    end;
  end;

  result:=data0;
end;

function TElphyDescriptor.getDataSpkWave(voie,seq0:integer;var wavelen1,pretrig1:integer; var scaling:TspkWaveScaling):typeDataB;
var
  data0:typeDataB;
  voieEv:integer;

begin
  data0:=nil;
  result:=nil;

  if seq0>nbseqDat then exit;
  if currentEp<>seq0 then initEpisod(seq0);

  if (voie<1) or (voie>nbSpk) then exit;
  voieEv:=voie-1;

  with Bseq,seq do
  begin
    if high(seqs[seq0-1].Wspks)>=voieEv then
    begin
      wavelen1:=seqs[seq0-1].wavelen;
      pretrig1:=seqs[seq0-1].pretrig;

      if (seqs[seq0-1].WaveScale.Dxu<>0) and (seqs[seq0-1].WaveScale.Dyu<>0) then  // un bricolage pour un oubli
      with seqs[seq0-1] do
      begin
        // Pour l'instant, le type est forcément smallint
        data0:=typeDataFileSegU.create(getfileStream,seqs[seq0-1].Wspks[voieEv],seqs[seq0-1].waveSize,false);
        scaling:= WaveScale;
      end
      else
      begin
        data0:=typeDataFileSegU.create(getfileStream,seqs[seq0-1].Wspks[voieEv],seqs[seq0-1].waveSize,false);

        scaling.dxu:=DxuSpk;
        scaling.x0u:=x0uSpk;
        scaling.unitX:=unitXspk;

        scaling.dyu:=DyuSpk;
        scaling.y0u:=y0uSpk;
        scaling.unitY:=unitYspk;

        scaling.dxuSource:=dxu;
        scaling.unitXsource:=unitX;
      end;
    end
    else
    begin
      wavelen1:=0;
      pretrig1:=0;
      scaling.dxu:=1;
      scaling.x0u:=0;
      scaling.unitX:='';

      scaling.dyu:=1;
      scaling.y0u:=0;
      scaling.unitY:='';

      scaling.dxuSource:=dxu;
      scaling.unitXsource:=unitX;
    end;
  end;

  result:=data0;
end;


function TElphyDescriptor.getSound(voie:integer):typeDataB;
var
  data0:typeDataB;
  mask:Tmsk;
begin
  data0:=nil;
  result:=nil;

  if (voie<1) or (voie>2) or not FichierContinu  or (length(seqs)=0) or (length(seqs[0].sounds)=0) then exit;

  setLength(mask,1);
  mask[0]:=true;

  data0:=typedataFileIK.create(getfileStream,mask,seqs[0].sounds,false,0,0);
  data0.setConversionX(1/8000,0);

  result:=data0;
end;


function TElphyDescriptor.nbVoie:integer;
begin

  // nbVoie inclut les voies analog et evt mais pas la voie tags(cumulée)
  // Pour les deux formats, si tagMode=tmItc, on décrémente nbvoie

  if assigned(Bseq) then
  with Bseq.seq do
  begin
    if tagMode=tmITC
      then result:=nbvoie-1
      else result:=nbvoie;
  end
  else nbvoie:=0;
end;

function TElphyDescriptor.nbSpk:integer;
begin
  if (currentEp>=1) and (CurrentEp<=length(seqs))
    then result:= seqs[CurrentEp-1].nbSpk
    else result:=0;
end;


function TElphyDescriptor.nbSeqDat:integer;
begin
  result:=high(seqs)+1;
end;

function TElphyDescriptor.nbPtSeq(voie:integer):integer;
begin
  if assigned(Bseq)
    then result:=Bseq.seq.nbpt
    else result:=0;
end;

function TElphyDescriptor.FichierContinu:boolean;
begin
   if assigned(Bseq)
    then result:=Bseq.seq.continu
    else result:=false;
end;

procedure TElphyDescriptor.displayInfo;
begin
  if not assigned(InfoForm) then
    begin
      InfoForm:=TElphyFileInfo.create(formStm);
      TElphyFileInfo(InfoForm).init(self);
    end;

  InfoForm.show;
end;

function TElphyDescriptor.unitX:AnsiString;
begin
  if assigned(Bseq)
    then unitX:=Bseq.seq.ux
    else unitX:='';
end;

function TElphyDescriptor.unitY(num:integer):AnsiString;
begin
  if assigned(Bseq)
    then unitY:=Bseq.getUnitY(num-1)
    else unitY:='';
end;


function TElphyDescriptor.getFileInfoCopy:TblocInfo;
begin
  if assigned(BFileInfo)
    then result:=BFileInfo.blocInfo.copy
    else result:=nil;
end;




function TElphyDescriptor.nbSeqEv:integer;
begin
  result:=0;
end;


function TElphyDescriptor.dateEvFile:integer;
begin
  result:=dateD;
end;


function TElphyDescriptor.channelName(num:integer):AnsiString;
begin
  result:='';
end;


function TElphyDescriptor.DureeSeq:float;
begin
  if assigned(Bseq)
    then result:=Bseq.seq.nbpt*Bseq.seq.Dxu
    else result:=0;

end;

function TElphyDescriptor.EpDuration:float;
begin
  if assigned(Bseq) then
  begin
    if not Bseq.seq.continu
      then result:=Bseq.seq.nbpt*Bseq.seq.Dxu
    else
    if NomIndexMax>0 then result:=NomIndexMax * Bseq.seq.Dxu
    else result:=0;
  end
  else result:=0;
end;

procedure TElphyDescriptor.SauverBlocEpInfo;
begin
  if assigned(fileStream) then
  begin
    fileStream.position:= seqs[currentEp-1].OffEpInfo ;
    BEpInfo.saveToStream(fileStream,false);
  end;
end;

function TElphyDescriptor.getEpInfo(var x;size,dep:integer):boolean;
begin
  if assigned(BepInfo)
    then result:=BEpInfo.blocInfo.getInfo(x,size,dep)
    else result:=false;
end;

function TElphyDescriptor.SetEpInfo(var x;size,dep:integer):boolean;
begin
  if assigned(BepInfo) then
    begin
      result:=BEpInfo.BlocInfo.setInfo(x,size,dep);
      sauverBlocEpInfo;
    end
  else result:=false;
end;

function TElphyDescriptor.ReadEpInfo(var x;size:integer):boolean;
begin
  if assigned(BepInfo)
    then result:=BEpInfo.BlocInfo.readInfo(x,size)
    else result:=false;
end;

function TElphyDescriptor.WriteEpInfo(var x;size:integer):boolean;
begin
  if assigned(BepInfo) then
    begin
      result:=BEpInfo.BlocInfo.writeInfo(x,size);
      sauverBlocEpInfo;
    end
  else result:=false;
end;

procedure TElphyDescriptor.ResetEpInfo;
begin
  if assigned(BepInfo) then
    BEpInfo.BlocInfo.ResetInfo;
end;

procedure TElphyDescriptor.SauverBlocFileInfo;
begin
  if assigned(fileStream) then
  begin
    fileStream.position:= FileInfoOffset;
    BfileInfo.saveToStream(fileStream,false);
  end;
end;


function TElphyDescriptor.getFileInfo(var x;size,dep:integer):boolean;
begin
  if assigned(BFileInfo)
    then result:=BFileInfo.blocInfo.getInfo(x,size,dep)
    else result:=false;
end;

function TElphyDescriptor.SetFileInfo(var x;size,dep:integer):boolean;
begin
  if assigned(BFileInfo) then
    begin
      result:=BFileInfo.BlocInfo.setInfo(x,size,dep);
      sauverBlocFileInfo;
    end
  else result:=false;
end;

function TElphyDescriptor.ReadFileInfo(var x;size:integer):boolean;
begin
  if assigned(BFileInfo)
    then result:=BFileInfo.BlocInfo.readInfo(x,size)
    else result:=false;
end;

function TElphyDescriptor.WriteFileInfo(var x;size:integer):boolean;
begin
  if assigned(BFileInfo) then
    begin
      result:=BFileInfo.BlocInfo.writeInfo(x,size);
      sauverBlocFileInfo;
    end
  else result:=false;
end;

procedure TElphyDescriptor.ResetFileInfo;
begin
  if assigned(BFileInfo) then
    BFileInfo.BlocInfo.ResetInfo;
end;


function TElphyDescriptor.fileInfoSize:integer;
begin
  if assigned(BfileInfo)
    then result:=BfileInfo.blocInfo.tailleBuf
    else result:=0;
end;

function TElphyDescriptor.EpInfoSize:integer;
begin
  if assigned(BEpInfo)
    then result:=BEpInfo.blocInfo.tailleBuf
    else result:=0;
end;


function TElphyDescriptor.getFileInfoBuf:pointer;
begin

end;

function TElphyDescriptor.EpInfo:pointer;
begin

end;


procedure TElphyDescriptor.copyEvHeader(f:TfileStream);
begin

end;

procedure TElphyDescriptor.copyEvEp(num:integer;f:TfileStream);
begin

end;


function TElphyDescriptor.isAcquis1:boolean;
begin
  result:=true;
end;

function TElphyDescriptor.getVSposition(NumEp:integer):int64;
begin
  result:=seqs[numEp-1].offVStim;
end;


{A faire: Avec Ksampling, dupliquer les échantillons dans Buf  (MainBuf FXctrl0) }
procedure TElphyDescriptor.CopyToBuffer(buf:pointer;bufSize:integer);
begin
end;

procedure TElphyDescriptor.getElphyTag(numseq:integer;var tags:TtagRecArray;
                                var x0u,dxu:float);
begin
  if (numSeq>0) and (numSeq<=length(seqs)) then
  begin
    tags:=seqs[numseq-1].tags;
    dxu:=Bseq.seq.Dxu;
    x0u:=0;
  end
  else
  begin
    tags:=nil;
    dxu:=1;
    x0u:=0;
  end;
end;


function TElphyDescriptor.SearchName(st: AnsiString;numOc:integer): integer;
begin
  result:=objFile.SearchName(st,numOc);
end;


function TElphyDescriptor.SearchAndload(st:AnsiString;numOc:integer;pu:typeUO):boolean;
begin
  result:=objFile.SearchAndLoad(st,numOc,pu);
end;

function TElphyDescriptor.getOIblock(n: integer): TOIblock;
begin
  result:=TOIblock.create;
  if not objFile.SearchClassAndload(n+1,result) then
  begin
    result.free;
    result:=nil;
  end;
end;

function TElphyDescriptor.OIseqCount: integer;
begin
  result:=objFile.classCount(TOIblock);
end;

function TElphyDescriptor.getFileStream: TStream;
begin
  if assigned(objFile)
    then result:=objFile.fileStream
    else result:=nil;
end;

function TElphyDescriptor.getVecFileStream: TStream;
begin
  result:=vecStream;
end;


function TElphyDescriptor.getOIseq(n: integer;Const Finit:boolean=true): TOIseq;
begin
  if (n>=0) and (n<length(OIseqs))
    then result:=OIseqs[n];

  if assigned(result)and Finit then
  begin
    if not result.initOK then result.initFile(getfileStream,OIblocks[n]);
  end;
end;


procedure TElphyDescriptor.AppendOIblocks(Src: AnsiString; const tpF:integer=1);
begin
  objFile.AppendOIblocks(src,tpF);
end;



procedure TElphyDescriptor.FreeFileStream;
begin
  objFile.FreeFileStream;
end;

procedure TElphyDescriptor.BuildOIvecFile(stF: AnsiString);
var
  oiseq:Toiseq;
  i:integer;
  f:TfileStream;
begin
  f:=TfileStream.Create(stF,fmCreate);

  try
  for i:=0 to OIseqCount-1 do
  begin
    oiseq:=getOIseq(i);
    if assigned(oiseq) then oiseq.BuildVecFile(f);
  end;

  finally
  f.free;
  end;
end;

procedure TElphyDescriptor.setOIvecFile(stF: AnsiString);
var
  i:integer;
  oiseq:Toiseq;
  offset:int64;
begin
  vecStream.free;
  vecStream:=nil;

  vecStream:=TfileStream.Create(stF,fmOpenRead);
  offset:=0;

  for i:=0 to OIseqCount-1 do
  begin
    oiseq:=getOIseq(i);
    if assigned(oiseq) then oiseq.setVecFile(getVecFileStream,offset);
  end;

end;

class function TElphyDescriptor.FileTypeName: AnsiString;
begin
  result:='ELPHY';
end;

function TElphyDescriptor.ReadDBepInfo: TDBrecord;
begin
  result:=DBepInfo;
end;

function TElphyDescriptor.ReadDBFileInfo: TDBrecord;
begin
  result:=DBfileInfo;
end;

function TElphyDescriptor.getAttlen: TarrayOfArrayOfInteger;
begin
  result:=attlen;
end;


function TElphyDescriptor.getVTotCount(n: integer): integer;
var
  i:integer;
begin
  if not assigned(analen) then BuildAnaLen;
  result:=0;
  for i:=0 to high(analen) do
    result:=result+analen[i,n-1];
end;

function TElphyDescriptor.getVtagTotCount: integer;
begin
  if VoieTagX>0
    then result:=getVTotCount(VoieTagX)
    else result:=0;
end;

function TElphyDescriptor.getVspkTotCount(n: integer): integer;
var
  i:integer;
begin
  result:=0;
  for i:=0 to length(attlen)-1 do
    result:=result+attlen[i,n-1];
end;


function TElphyDescriptor.getWspkTotCount(n: integer): integer;
var
  i:integer;
begin
  result:=0;
  for i:=0 to length(attlen)-1 do
    result:=result+attlen[i,n-1];
end;

procedure TElphyDescriptor.getVNbSamps(n: integer;  var nbSamps: TarrayOfInteger);
var
  i:integer;
begin
  if not assigned(analen) then BuildAnaLen;
  setLength(nbSamps,length(anaLen));
  for i:=0 to length(analen)-1 do
    nbSamps[i]:=analen[i,n-1];
end;

procedure TElphyDescriptor.getVspkNbSamps(n: integer;  var nbSamps: TarrayOfInteger);
var
  i:integer;
begin
  setLength(nbSamps,length(attLen));
  for i:=0 to length(attlen)-1 do
    nbSamps[i]:=attlen[i,n-1];
end;

procedure TElphyDescriptor.getVtagNbSamps(var nbSamps: TarrayOfInteger);
var
  i:integer;
begin
  if voieTagX>0 then
  begin
    if not assigned(analen) then BuildAnaLen;
    setLength(nbSamps,length(anaLen));
    for i:=0 to length(analen)-1 do
      nbSamps[i]:=analen[i,voieTagX-1];
  end
  else fillchar(nbSamps[0],length(nbSamps)*sizeof(nbSamps[0]),0);    
end;


function TElphyDescriptor.CyberTime(ep:integer): double;
begin
  if not assigned(analen) then BuildAnaLen;
  result:= seqs[ep-1].cybTime;
end;

function TElphyDescriptor.PCtime(ep:integer): longword;
begin
  result:= seqs[ep-1].PCTime;
end;

function TElphyDescriptor.CorrectedCyberTime(ep:integer): double;
begin
  if not assigned(analen) then BuildAnaLen;
  result:= seqs[ep-1].CorrectedCybTime;
end;

function TElphyDescriptor.getTimeSpan: float;
begin
  if not assigned(analen) then BuildAnaLen;
  result:=TotTime;
end;

function TElphyDescriptor.SpkTableCount: integer;
begin
  result:=nbSpkTable;
end;

function TElphyDescriptor.getVcounts(n, ep: integer): integer;
begin
  if not assigned(analen) then BuildAnaLen;
  if assigned(analen[ep-1]) then result := analen[ep-1,n-1] else result:=0;
end;

function TElphyDescriptor.getVspkCounts(n, ep: integer): integer;
begin
  if assigned(attlen[ep-1]) then result:= attlen[ep-1,n-1] else result:=0;
end;

function TElphyDescriptor.getVtagCounts(n, ep: integer): integer;
begin
  if voieTagX>0 then
  begin
    if not assigned(analen) then BuildAnaLen;
    result := analen[ep-1,voieTagX-1];
  end
  else result:=0;
end;


procedure TElphyDescriptor.getPCLdata(var OIpcl: TOIseqPCL; ep:integer);
var
  i:integer;
  ux:AnsiString;
begin
  if FichierContinu
    then uX:='sec'
    else uX:='ms';

  if (ep>=1) and (ep<=length(seqs)) then
  with seqs[ep-1] do
  begin
    for i:=0 to high(pcls) do
    begin
      fileStream.Position:= pcls[i].off;
      OIpcl.LoadBlock(i,fileStream,pcls[i].size, 0,EpDuration,uX);
    end;
  end;

end;

function TElphyDescriptor.HasPCL: boolean;
begin
  result:=Fhaspcl;
end;

procedure TElphyDescriptor.CloseLastDataBlock;
var
  n,sz: integer;
begin
  if assigned(fileStream) then
  with objFile do
  begin
    n:=stClasses.Count-1;
    if (n>=0) and (stClasses[n]='RDATA') then
    begin
      sz:=fileStream.size-BlockOffset[n];
      fileStream.Position:=BlockOffset[n];
      fileStream.Write(sz,4);
    end;
  end;
end;

function TElphyDescriptor.ReadPCLfilter(n: integer): TDBrecord;
begin
  if (n=0) or (n>length(PCLfilter)) then exit
  else
  if n<0 then n:= length(PCLfilter)-1
  else n:=n-1;

  if n>=0 then result:= TDBrecord(objFile.loadThisUO(PCLfilter[n]));
end;

function TElphyDescriptor.ElphyDataTime(ep: integer): TdateTime;
begin
  if (ep>0) and (ep<=length(seqs))
    then result:= seqs[ep-1].ElphyTime
    else result:=0;
end;

function TElphyDescriptor.EpPCtime(ep: integer): longword;
begin
  if (ep>0) and (ep<=length(seqs))
    then result:= seqs[ep-1].PCTime
    else result:=0;
end;

procedure TElphyDescriptor.getVisuInfo(vs: TDBrecord);
var
  visuSys: TsystemVS;
  size:cardinal;
begin
  if (CurrentEp>=1) and (CurrentEp<=length(seqs)) and (seqs[currentEp-1].OffVisuSys<>0) then
  with seqs[currentEp-1] do
  begin
    visuSys:= TsystemVS.create;
    fileStream.Position:=OffVisuSys;
    readHeader(fileStream,size);
    visuSys.loadFromStream(fileStream,size,false);
  end;

  with vs,visusys.inf do
  begin
    clearFields;
    setIntegerValue('TrackingPoint1',TrackPoint[1]);
    setIntegerValue('TrackingPoint2',TrackPoint[2]);
    setIntegerValue('TrackShif1',TrackShift[1]);
    setIntegerValue('TrackShif2',TrackShift[2]);

    setFloatValue('ExtraTime',extraTime*tfreq/1E6);
    setFloatValue('Tfreq', tfreq/1E6);
    setFloatValue('BKlum', BKlum);

    setFloatValue('RF1x', RF1.x);
    setFloatValue('RF1y', RF1.y);
    setFloatValue('RF1dx', RF1.dx);
    setFloatValue('RF1dy', RF1.dy);
    setFloatValue('RF1theta', RF1.theta);

    setFloatValue('ACleftX', ACleft.x);
    setFloatValue('ACleftY', ACleft.y);
    setFloatValue('ACrightX', ACright.x);
    setFloatValue('ACrightY', ACright.y);



  end;


  visuSys.free;
end;



//**************************************************************************************************************


procedure CopyEpWithDownSampling1( fsrc, fdest:Tstream;  Sizes, Mask, DSfactor:TarrayOfInteger; offsets: TarrayOfInt64; var StartPos: TarrayOfInt64; tp: typetypeG; mux:boolean);
const
  KmemMax= 100000;
var
  Nblock, Nmask:integer;
  i,j, cnt,sz,cnt2, block:integer;

  tbMem: array of array of smallint;
  Kmem: array of integer;

  tb: array of byte;
  max:integer;
  chan, chanOrder: array of integer;
  Nchan: integer;

  Ichan: array of integer;
  Wchan: array of double;
  index, ch:integer;
  wi:smallint;

begin

  Nmask:=length(mask);

  Nchan:=0;
  max:=1000;
  setLength(chan,max);
  setLength(chanOrder,max+1);

  for i:= 1 to max do
    for j:= 0 to high(mask) do
      if mask[j]=i then
      begin
        chan[Nchan]:=i;
        inc(Nchan);
        break;
      end;

  fillchar(chanOrder[0],(max+1)*sizeof(integer),0);
  for i:= 0 to Nchan-1 do chanOrder[chan[i]]:= i+1;

  for i:= 0 to Nmask-1 do mask[i]:= ChanOrder[mask[i]];  // Exemple: 0 3 7 9 11 est remplacé par 0 1 2 3 4

  Nblock:= length(offsets);
  if (Nblock=0) or (length(sizes)<>Nblock) then exit;

  sz:=   tailletypeG[typetypeG(tp)];

  setLength(Ichan,Nchan+1);
  setLength(Wchan,Nchan+1);
  fillchar(Ichan[0],(Nchan+1)*sizeof(integer),0);
  fillchar(Wchan[0],(Nchan+1)*sizeof(double),0);

  if not mux then
  begin
    setLength(tbmem,Nchan,KmemMax);
    setLength(Kmem,Nchan);
    for i:= 0 to Nchan-1 do Kmem[i]:= 0;
  end
  else
  begin
    setLength(tbMem,1,KmemMax);
    setLength(Kmem,1);
    Kmem[0]:=0;

    setLength(startPos,length(startPos)+1);    // En mode mux, on marque seulement le début d'épisode
    startPos[high(startPos)]:= fdest.position;
  end;

  index:=0;


  for block:=0 to Nblock-1 do
  begin
    fsrc.Position:=offsets[block];
    setlength(tb,Sizes[block]);
    fsrc.Read(tb[0],Sizes[block]);

    cnt:= 0;
    cnt2:=0;

    while (cnt<=Sizes[block]-sz) do
    begin
      ch:= mask[index];
      if ch>0 then
      begin
        wchan[ch]:= wchan[ch]+ Psmallint(@tb[cnt])^;
        inc(Ichan[ch]);
        if Ichan[ch]=DSfactor[ch] then
        begin
          wi:= round(wchan[ch]/DSfactor[ch]);
          if mux then
            begin
              tbMem[0,Kmem[0]]:=wi;
              inc(Kmem[0]);
              if Kmem[0]=KmemMax then
              begin
                fdest.WriteBuffer(tbmem[0,0],Kmem[0]*2);
                Kmem[0]:=0;
              end;
            end
            else
            begin
              tbMem[ch-1,Kmem[ch-1]]:=wi;
              inc(Kmem[ch-1]);
              if Kmem[ch-1]= length(tbMem[ch-1]) then setLength(tbMem[ch-1],length(tbMem[ch-1])+KmemMax);
            end;
          wchan[ch]:=0;
          Ichan[ch]:=0;
        end;
      end;
      inc(index);
      if index>high(mask) then index:=0;
      inc(cnt,sz);
    end;

    if TesterFinPg then break;
  end;

  if mux then
  begin
    //messageCentral('1 ==> '+Istr(fdest.Position)+'    '+Istr(fdest.Size) +'   '+Istr(Kmem[0]));
    if Kmem[0]>0
      then fdest.WriteBuffer(tbmem[0,0],Kmem[0]*2);
    //messageCentral('2 ==> '+Istr(fdest.Position)+'    '+Istr(fdest.Size));
  end
  else
  begin
    for i:= 0 to Nchan-1 do
    begin
      setLength(startPos,length(startPos)+1);                    // en mode non mux, on marque le début de chaque vecteur
      startPos[high(startPos)]:= fdest.position;
      fdest.writeBuffer(tbmem[i][0],Kmem[i]*2);
    end;
  end;

  //messageCentral('3 ==>'+IStr(fdest.position)+'   '+  Istr(Kmem[0]));
end;


procedure CopyEpWithoutDownSampling1( fsrc, fdest:Tstream;  Sizes, Mask: TarrayOfInteger; offsets: TarrayOfInt64; var StartPos: TarrayOfInt64; tp: typetypeG; mux:boolean);
const
  KmemMax= 100000;
var
  Nblock, Nmask:integer;
  i,j, cnt,sz,cnt2, block:integer;

  tbMem: array of array of smallint;
  Kmem: array of integer;

  tb: array of byte;
  max:integer;
  chan, chanOrder: array of integer;
  Nchan: integer;

  index, ch:integer;
  wi:smallint;

begin

  Nmask:=length(mask);

  Nchan:=0;
  max:=1000;
  setLength(chan,max);
  setLength(chanOrder,max+1);

  for i:= 1 to max do
    for j:= 0 to high(mask) do
      if mask[j]=i then
      begin
        chan[Nchan]:=i;
        inc(Nchan);
        break;
      end;

  fillchar(chanOrder[0],(max+1)*sizeof(integer),0);
  for i:= 0 to Nchan-1 do chanOrder[chan[i]]:= i+1;

  for i:= 0 to Nmask-1 do mask[i]:= ChanOrder[mask[i]];  // Exemple: 0 3 7 9 11 est remplacé par 0 1 2 3 4

  Nblock:= length(offsets);
  if (Nblock=0) or (length(sizes)<>Nblock) then exit;

  sz:=   tailletypeG[typetypeG(tp)];


  if not mux then
  begin
    setLength(tbmem,Nchan,KmemMax);
    setLength(Kmem,Nchan);
    for i:= 0 to Nchan-1 do Kmem[i]:= 0;
  end
  else
  begin
    setLength(tbMem,1,KmemMax);
    setLength(Kmem,1);
    Kmem[0]:=0;

    setLength(startPos,length(startPos)+1);    // En mode mux, on marque seulement le début d'épisode
    startPos[high(startPos)]:= fdest.position;
  end;

  index:=0;


  for block:=0 to Nblock-1 do
  begin
    fsrc.Position:=offsets[block];
    setlength(tb,Sizes[block]);
    fsrc.Read(tb[0],Sizes[block]);

    cnt:= 0;
    cnt2:=0;

    while (cnt<=Sizes[block]-sz) do
    begin
      ch:= mask[index];
      if ch>0 then
      begin
        wi:= Psmallint(@tb[cnt])^;
        if mux then
         begin
           tbMem[0,Kmem[0]]:=wi;
           inc(Kmem[0]);
           if Kmem[0]=KmemMax then
           begin
             fdest.WriteBuffer(tbmem[0,0],Kmem[0]*2);
             Kmem[0]:=0;
           end;
         end
         else
         begin
           tbMem[ch-1,Kmem[ch-1]]:=wi;
           inc(Kmem[ch-1]);
           if Kmem[ch-1]= length(tbMem[ch-1]) then setLength(tbMem[ch-1],length(tbMem[ch-1])+KmemMax);
         end;
      end;
      inc(index);
      if index>high(mask) then index:=0;
      inc(cnt,sz);
    end;

    if TesterFinPg then break;
  end;

  if mux then
  begin
    if Kmem[0]>0
      then fdest.WriteBuffer(tbmem[0,0],Kmem[0]*2);
  end
  else
  begin
    for i:= 0 to Nchan-1 do
    begin
      setLength(startPos,length(startPos)+1);                    // en mode non mux, on marque le début de chaque vecteur
      startPos[high(startPos)]:= fdest.position;
      fdest.writeBuffer(tbmem[i][0],Kmem[i]*2);
    end;
  end;

end;


procedure CopyEpWithDownSampling2( fsrc, fdest:Tstream;  Sizes, DSfactor,Indices: TarrayOfInteger; offsets: TarrayOfInt64; var StartPos: TarrayOfInt64; mux:boolean);
const
  KmemMax= 100000;
var
  Nblock:integer;
  i,j, block:integer;

  tbMem: array of array of smallint;
  Kmem: array of integer;

  tb: array of array of smallint;
  Nchan: integer;

  Num, nb1, max:integer;
  wi:smallint;

begin

  Nchan:= length(DSfactor)-1;

  Nblock:= length(offsets);
  if (Nblock=0) or (length(sizes)<>Nblock) then exit;

  if not mux then
  begin
    setLength(tbmem,Nchan,KmemMax);
    setLength(Kmem,Nchan);
    for i:= 0 to Nchan-1 do Kmem[i]:= 0;
  end
  else
  begin
    setLength(tbMem,1,KmemMax);
    setLength(Kmem,1);
    Kmem[0]:=0;

    setLength(startPos,length(startPos)+1);    // En mode mux, on marque seulement le début d'épisode
    startPos[high(startPos)]:= fdest.position;
  end;


  for block:=0 to Nblock-1 do
  begin
    fsrc.Position:=offsets[block]; // lecture du bloc
    setlength(tb,Nchan);

    max:= maxLongint;
    for Num:=0 to Nchan-1 do
    if DSfactor[Num+1]>0 then
    begin
      nb1:= (Indices[Num+1]-Indices[Num]) div 2 ;
      setLength(tb[Num],nb1);
      fsrc.Read(tb[Num,0],nb1*2);

      if max> nb1 div DSfactor[Num+1] then max:= nb1 div DSfactor[Num+1];
    end;

    for i:=0 to max-1 do
    for Num:=0 to Nchan-1 do
    begin
      if DSfactor[Num+1]>0 then
      begin
        wi:= tb[Num, i*DSfactor[Num+1]];

        if mux then
         begin
           tbMem[0,Kmem[0]]:=wi;
           inc(Kmem[0]);
           if Kmem[0]=KmemMax then
           begin
             fdest.WriteBuffer(tbmem[0,0],Kmem[0]*2);
             Kmem[0]:=0;
           end;
         end
         else
         begin
           tbMem[Num, Kmem[Num]]:=wi;
           inc(Kmem[Num]);
           if Kmem[Num]= length(tbMem[Num]) then setLength(tbMem[Num],length(tbMem[Num])+KmemMax);
         end;
      end;
    end;

    if TesterFinPg then break;
  end;

  if mux then
  begin
    if Kmem[0]>0
      then fdest.WriteBuffer(tbmem[0,0],Kmem[0]*2);
  end
  else
  begin
    for i:= 0 to Nchan-1 do
    begin
      setLength(startPos,length(startPos)+1);                    // en mode non mux, on marque le début de chaque vecteur
      startPos[high(startPos)]:= fdest.position;
      fdest.writeBuffer(tbmem[i][0],Kmem[i]*2);
    end;
  end;

end;



procedure ElphyFileToAnalogBinaryFile(stSrc,stDest: AnsiString; Vchan:TarrayOfInteger; var VstartPos: TarrayOfInt64; DW: integer; mux: boolean);
// DW= DownSampling souhaité par rapport à la fréquence de base
var
  f: TobjectFile;
  RdataCount: integer;
  Offsets: array[1..10000] of int64;
  Sizes: array[1..10000] of integer;
  RdataStart: array[1..10000] of boolean;


  Ksamp: array[1..200] of integer;

  i,j,k,n:integer;
  nb: integer;
  sz: smallint;

  Bep: TseqBlock;
  chCount: integer;

  fdest:TfileStream;
  Voff1: TarrayOfInt64;
  Vsize1,mask: TarrayOfInteger;
  DSfactor: TarrayOfInteger;
  indices: TarrayOfinteger;

  min,max: integer;
  ok: boolean;

begin
  f:= TobjectFile.create;
  f.OpenFile(stSrc);
  fdest:=nil;
  try
  RdataCount:=0;

  for k:=0 to f.objCount-1 do
  begin
    if f.stClasses[k]='B_Ep' then
    begin
      RdataStart[RdataCount+1]:= true;
    end;

    if f.stClasses[k]='RDATA' then
    begin
      inc(RdataCount);
      Offsets[RdataCount]:= f.BlockOffset[k];
      Sizes[RdataCount]:= f.BlockSize[k];
    end;
  end;

  // 2: correction: we need offsets and sizes of analog data blocks
  for k:=1 to RdataCount do
  begin
    f.fileStream.position:= Offsets[k]+10;  // Data position = offset + sizeof(BlockSize)+ 1 +length(ClassName) = offset+10
    f.fileStream.read(sz,sizeof(sz));       // sz= sizeof Rdata header
    Offsets[k]:= Offsets[k]+ 10 + sz;       // position of analog data
    Sizes[k]:= Sizes[k]- 10 -sz;
  end;

  Bep:=TseqBlock.create;
  f.SearchClassAndLoad(1, Bep );
  Bep.BuildMask(10000);
  ChCount:= Bep.AnalogChCount;
  for i:=1 to chCount do
    Ksamp[i]:= Bep.Ksampling[i-1];

  setLength(DSfactor, ChCount+1);
  fillchar(DSfactor[0],length(DSfactor)*4,0);


  if Bep.seq.FormatOption=1 then
  begin
    for k:= 0 to high(Vchan) do
      DSfactor[Vchan[k]]:= 1;

    setLength(indices,Bep.AnalogChCount+1);    // pour format2: index en bytes dans le bloc
    n:=0;
    for i:=1 to chCount do
    begin
      Indices[i-1]:= Bep.getOffset2(i-1);
      if DSfactor[i]>0 then
        DSfactor[i]:= DW div Ksamp[i];
    end;
    Indices[length(indices)-1]:=Sizes[1];

  end
  else
  begin
    setlength(mask,Bep.AgSampleCount);
    fillchar(mask[0],length(mask)*sizeof(integer),0);


    for k:= 0 to high(Vchan) do          // on copie le masque mais on ne garde
    for i:=0 to length(mask)-1 do        // que les canaux qui font partie de Vchan
      if Bep.chanMask[i]+1 = Vchan[k] then
      begin
        mask[i]:= Vchan[k];
        DSfactor[Vchan[k]]:= DW div Ksamp[Vchan[k]];   // Vrai facteur de sous-ech, 0 si inutilisé
      end;
  end;

  if Bep.seq.TagMode=tmItc then { ??? }
  begin
    // sauver la voie sup en plus
  end;



  fdest:= TfileStream.Create(StDest, fmCreate );
  setLength(VstartPos,0);

  for i:= 1 to RdataCount do
  begin
    if RdataStart[i] then
    begin
      j:= i;
      while (j<RdataCount) and not RdataStart[j+1] do inc(j);
      nB:= j-i+1;
      setLength(Voff1,nb);
      setLength(Vsize1,nb);
      for j:= 0 to nb-1 do
      begin
        Voff1[j]:= Offsets[i+j];
        Vsize1[j]:= Sizes[i+j];
      end;

      case Bep.seq.FormatOption of
        0: if DW<=1
            then copyEpWithoutDownSampling1(f.fileStream,fdest,VSize1,mask,Voff1,VStartPos,g_smallint,mux)
            else copyEpWithDownSampling1(f.fileStream,fdest,VSize1,mask,DSfactor,Voff1,VStartPos,g_smallint,mux);
        1: begin
              copyEpWithDownSampling2(f.fileStream,fdest,VSize1,DSfactor,indices,Voff1,VStartPos,mux);
           end;
      end;
    end;
    if finExe then break;
  end;

  finally
  Bep.free;
  fDest.free;
  f.free ;
  end;
end;




end.
