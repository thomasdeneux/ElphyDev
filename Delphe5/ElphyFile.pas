unit ElphyFile;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysUtils,
     util1,Gdos,clock0,
     DataGeneFile,ElphyFormat,ObjFile1,
     AcqDef2,acqInf2,stimInf2,
     varconf1,
     stmDef,stmObj,stmvec1,saveOpt1,blocInf0,
     Mtag0,
     stmError,
     DBrecord1;

type
  TstimBlock=TstimInfo;
  TacqBlock=TacqInfo;

type
  TElphyFile= class(TdataGeneFile)

             private
                fileHeader:THeaderObjectFile;

                Fcom:TcommentBlock;
                FfileInfo:TfileInfoBlock;
                FEpInfo:TepInfoBlock;
                Fstim:TstimBlock;
                Facq:TacqBlock;
                Fseq:TseqBlock;
                Ftag:TUserTagBlock;

                FDBfileInfo:TDBrecord;
                FDBepInfo:TDBrecord;

                DataSize:int64;
                DataSizeOffset:int64;

                FdataOpen:boolean;

                function getBCom:TcommentBlock;
                function getBfileInfo:TfileInfoBlock;
                function getBEpInfo:TepInfoBlock;
                function getBstim:TstimBlock;
                function getBacq:TacqBlock;
                function getBseq:TseqBlock;
                function getBtag:TuserTagBlock;

                function getDBfileInfo:TDBrecord;
                function getDBEpInfo:TDBrecord;


                procedure updateSeq;

                procedure createFile0(st:AnsiString);
                procedure append0(st:AnsiString);

             protected
                procedure setContinu(b:boolean);override;
                function getContinu:boolean;override;
                procedure setTagMode(b:TtagMode);override;
                function getTagMode:TtagMode;override;
                procedure setTagShift(b:integer);override;
                function getTagShift:integer;override;

                procedure setComment(st:AnsiString);override;
                function getComment:AnsiString;override;

             public
                constructor create;override;
                destructor destroy;override;

                property Bcom:TcommentBlock read getBcom;
                property BfileInfo:TfileInfoBlock read getBfileInfo;
                property BEpInfo:TepInfoBlock read getBEpInfo;
                property Bstim:TstimBlock read getBstim;
                property Bacq:TacqBlock read getBacq;
                property Bseq:TseqBlock read getBseq;
                property Btag:TuserTagBlock read getBtag;

                property DBfileInfo:TDBrecord read getDBfileInfo;
                property DBEpInfo:TDBrecord read getDBEpInfo;

                class function STMClassName:AnsiString;override;

                procedure ecrirePreSeq;override;
                procedure ecrirePostSeq;override;

                procedure createFile(st:AnsiString);override;
                procedure createAcqFile(st:AnsiString);
                procedure Append(st:AnsiString);override;
                procedure AppendAcqFile(st:AnsiString);

                procedure save;override;
                procedure close(Const NominalIndex:longword=0);override;

                function setFileInfoSize(size:integer):boolean;override;
                function setEpInfoSize(size:integer):boolean;override;
                function getFileInfoSize:integer;override;
                function getEpInfoSize:integer;override;

                procedure copyFileInfo(p:pointer;sz:integer);override;
                procedure copyEpInfo(p:pointer;sz:integer);override;


                procedure setAcqInf(p:pointer);override;
                procedure setStim(p:pointer);override;

                procedure setSeqRecord(var seq:TseqRecord; FFormat: integer);       // 6-12-16
                procedure setChannel0(num: integer; Dy,y0: double; unitY: string);
                procedure setChannel1(num: integer; Dy,y0: double; unitY: string; KS: integer);  // 6-12-16

                function getFileInfo(var x;nb,dep:integer):boolean;override;
                function setFileInfo(var x;nb,dep:integer):boolean;override;
                function readFileInfo(var x;nb:integer):boolean;override;
                function writeFileInfo(var x;nb:integer):boolean;override;
                procedure resetFileInfo;override;

                function getEpInfo(var x;nb,dep:integer):boolean;override;
                function setEpInfo(var x;nb,dep:integer):boolean;override;
                function readEpInfo(var x;nb:integer):boolean;override;
                function writeEpInfo(var x;nb:integer):boolean;override;
                procedure resetEpInfo;override;

                procedure setKsampling(n:integer;k:word);override;
                procedure setKtype(n:integer;k:typetypeG);override;

                procedure openDataBlock;
                function closeDataBlock(Const NominalIndex:integer=0):boolean;

                function createUtagStream(code1,index,ep1:integer;tm:TdateTime;st: AnsiString):TmemoryStream;
                procedure InsertSound(var buf;size:integer; first:boolean;tm:TdateTime);

                procedure SaveEvtArray(evtTab:TElphyEvtTab;isEvt:TElphyIsEvt);

                procedure setDBfileInfo(var db: TDBrecord);override;
                procedure setDBepInfo(var db: TDBrecord);override;    
              end;


implementation


constructor TElphyFile.create;
begin
  inherited;

end;

destructor TElphyFile.destroy;
begin
  close;
  
  Fcom.free;
  FfileInfo.free;
  FEpInfo.free;
  Fstim.free;
  Facq.free;
  Fseq.free;

  Ftag.free;
  FDBfileInfo.free;
  FDBepInfo.free;

  inherited;
end;

class function TElphyFile.STMClassName:AnsiString;
begin
  result:='ElphyFile';
end;

function TElphyFile.getBCom:TcommentBlock;
begin
  if not assigned(FCom) then FCom:=TcommentBlock.create;
  result:=FCom;
end;

function TElphyFile.getBfileInfo:TfileInfoBlock;
begin
  if not assigned(FfileInfo) then FfileInfo:=TfileInfoBlock.create;
  result:=FfileInfo;
end;

function TElphyFile.getBEpInfo:TepInfoBlock;
begin
  if not assigned(FEpInfo) then FEpInfo:=TepInfoBlock.create;
  result:=FEpInfo;
end;

function TElphyFile.getBstim:TstimBlock;
begin
  if not assigned(Fstim) then Fstim:=TstimBlock.create;
  result:=Fstim;
end;

function TElphyFile.getBacq:TacqBlock;
begin
  if not assigned(Facq) then Facq:=TacqBlock.create;
  result:=Facq;
end;


function TElphyFile.getBseq:TseqBlock;
begin
  if not assigned(Fseq) then Fseq:=TseqBlock.create;
  result:=Fseq;
end;

function TElphyFile.getBtag:TuserTagBlock;
begin
  if not assigned(Ftag) then Ftag:=TuserTagBlock.create;
  result:=Ftag;
end;

function TElphyFile.getDBfileInfo:TDBrecord;
begin
  if not assigned(FDBfileInfo) then
  begin
    FDBfileInfo:=TDBrecord.create;
    FDBfileInfo.ident:='DBfileInfo';
    FDBfileInfo.StId:='File Info';
  end;
  result:=FDBfileInfo;
end;

function TElphyFile.getDBEpInfo:TDBrecord;
begin
  if not assigned(FDBEpInfo) then
  begin
    FDBEpInfo:=TDBrecord.create;
    FDBEpInfo.ident:='DBepInfo';
    FDBEpInfo.stId:='Ep Info';
  end;
  result:=FDBEpInfo;
end;



procedure TElphyFile.setContinu(b:boolean);
begin
  Bseq.seq.continu:=b;
end;

function TElphyFile.getContinu:boolean;
begin
  result:=Bseq.seq.continu;
end;

procedure TElphyFile.setTagMode(b:TtagMode);
begin
  Bseq.seq.TagMode:=b;
end;

function TElphyFile.getTagMode:TtagMode;
begin
  result:=Bseq.seq.TagMode;
end;

procedure TElphyFile.setTagShift(b:integer);
begin
  Bseq.seq.TagShift:=b;
end;

function TElphyFile.getTagShift:integer;
begin
  result:=Bseq.seq.TagShift;
end;

procedure TElphyfile.setComment(st:AnsiString);
begin
  Bcom.stCom:=st;
end;

function TElphyfile.getComment:AnsiString;
begin
  result:=Bcom.stCom;
end;


procedure TElphyFile.ecrirePreSeq;
begin
  Bseq.seq.CyberTime:= AcqCybTime;
  AcqCybTime:=0;
  Bseq.seq.PCTime:=AcqPCtime;
  AcqPCtime:=0;
  Bseq.saveToStream0(f,false);
  OpenDataBlock;
end;

procedure TElphyFile.ecrirePostSeq;
begin
  CloseDataBlock;
  if assigned(FepInfo) then BepInfo.saveToStream0(f,false);
  if assigned(FDBepInfo) then DBepInfo.saveToStream0(f,false);
end;

procedure TElphyFile.updateSeq;
var
  i:integer;
begin
  with BSeq,seq do
  begin
    nbVoie:=channelCount;

    if assigned(channels[1])
      then nbpt:=channels[1].invconvx(Xend[1])-channels[1].invconvx(Xstart[1])+1
      else nbpt:=0;

    if continu then nbpt:=0;

    uX:=saveRec.ux;
    x0u:=Xorg;
    dxu:=saveRec.Dx;

    for i:=1 to channelCount do
        initChannel0(i-1, saveRec.Dy[i], saveRec.Y0[i], saveRec.uY[i]);

    tpData:=saveRec.tp;
  end;
end;

procedure TElphyFile.createFile0(st:AnsiString);
begin
  f:=TfileStream.create(st,fmCreate);

  fileHeader.init;
  f.write(FileHeader,sizeof(fileHeader));

  while length(Bcom.stCom)<MiniComSize do Bcom.stcom:=Bcom.stcom+' ';
  Bcom.saveToStream0(f,false);

  if BFileInfo.blocinfo.tailleBuf  <>0 then BfileInfo.saveToStream0(f,false);
  if assigned(FDBfileInfo) then DBfileInfo.saveToStream0(f,false);

  if assigned(Facq) then Facq.saveToStream0(f,false);
  if assigned(Fstim) then Fstim.saveToStream0(f,false);

  Open:=true;
  fileName:=st;
end;

procedure TElphyFile.createFile(st:AnsiString);
begin
  majOptions;
  createFile0(st);
end;

procedure TElphyFile.createAcqFile(st:AnsiString);
begin
  createFile0(st);
  if continu then ecrirePreSeq;
end;

procedure TElphyFile.Append0(st:AnsiString);
begin
  open:=false;
  f:=TfileStream.Create(st,fmOpenReadWrite);
  f.Read(fileheader,sizeof(FileHeader));

  open:=(fileheader.id=ObjectFileId);

  if open then
    begin
      fileName:=st;
      f.Position:=f.size;
      if continu then openDataBlock;
    end
  else f.free;
end;

procedure TElphyFile.Append(st:AnsiString);
begin
end;

procedure TElphyFile.AppendAcqFile(st:AnsiString);
begin
  append0(st);
end;

procedure TElphyFile.save;
begin
end;

function TElphyFile.setFileInfoSize(size:integer):boolean;
begin
  with BfileInfo do
  begin
    blocInfo.free;
    try
      blocInfo:=TblocInfo.create(size);
      result:=true;
    except
      blocInfo:=TblocInfo.create(0);
      result:=false;
    end;
  end;
end;

function TElphyFile.setEpInfoSize(size:integer):boolean;
begin
  with BEpInfo do
  begin
    blocInfo.free;
    try
      blocInfo:=TblocInfo.create(size);
      result:=true;
    except
      blocInfo:=TblocInfo.create(0);
      result:=false;
    end;
  end;
end;

function TElphyFile.getEpInfoSize: integer;
begin
  result:=BepInfo.blocInfo.tailleBuf;
end;

function TElphyFile.getFileInfoSize: integer;
begin
  result:=BfileInfo.blocInfo.tailleBuf;
end;

procedure TElphyFile.copyFileInfo(p:pointer;sz:integer);
begin
end;

procedure TElphyFile.copyEpInfo(p:pointer;sz:integer);
begin
end;

procedure TElphyFile.setAcqInf(p:pointer);
begin

end;

procedure TElphyFile.setStim(p:pointer);
begin

end;

procedure TElphyFile.openDataBlock;
begin
  DataSizeOffset:=f.position;
  DataSize:=0;    {Pour les séquences, on pourrait donner la valeur exacte}

  WriteRdataHeader(f,DataSize,Now,true);

  FdataOpen:=true;
end;

function TElphyFile.closeDataBlock(Const NominalIndex:integer=0):boolean;
var
  tot:longword;
begin
  result:=FdataOpen;
  if not FdataOpen then exit;

  tot:=f.size-DataSizeOffset;

  if tot<>DataSize then
    begin
      f.Position:=DataSizeOffset;
      f.write(tot,sizeof(tot));

      f.Position:=DataSizeOffset + TRdataBlock.NindexOffset;
      f.Write(NominalIndex,sizeof(NominalIndex));

      f.Position:=f.size;
    end;

  FdataOpen:=false;
end;

procedure TElphyFile.setSeqRecord(var seq:TseqRecord; FFormat: integer);
begin
  case Fformat of
    0:  Bseq.init0(seq);
    1:  Bseq.init1(seq);
  end;
end;

procedure TElphyFile.setChannel0(num: integer; Dy,y0: double; unitY: string);
begin
  Bseq.initChannel0(num, Dy,y0, unitY);
end;

procedure TElphyFile.setChannel1(num: integer; Dy,y0: double; unitY: string; KS: integer);
begin
  Bseq.initChannel1(num ,0, Bseq.Ktype[num] , 0,Bseq.seq.nbpt div KS, Bseq.seq.Dxu * KS , Bseq.seq.x0u, Bseq.seq.uX, Dy,y0, unitY);
end;


function TElphyFile.getEpInfo(var x; nb, dep: integer): boolean;
begin
  result:=BepInfo.blocInfo.getInfo(x,nb,dep);
end;

function TElphyFile.getFileInfo(var x; nb, dep: integer): boolean;
begin
  result:=BfileInfo.blocInfo.getInfo(x,nb,dep);
end;

function TElphyFile.readEpInfo(var x; nb: integer): boolean;
begin
  result:=BepInfo.blocInfo.readInfo(x,nb);
end;

function TElphyFile.readFileInfo(var x; nb: integer): boolean;
begin
  result:=BfileInfo.blocInfo.readInfo(x,nb);
end;

procedure TElphyFile.resetEpInfo;
begin
  BepInfo.blocInfo.resetInfo;
end;

procedure TElphyFile.resetFileInfo;
begin
  BfileInfo.blocInfo.resetInfo;
end;

function TElphyFile.setEpInfo(var x; nb, dep: integer): boolean;
begin
  result:=BepInfo.blocInfo.setInfo(x,nb,dep);
end;

function TElphyFile.setFileInfo(var x; nb, dep: integer): boolean;
begin
  result:=BfileInfo.blocInfo.setInfo(x,nb,dep);
end;

function TElphyFile.writeEpInfo(var x; nb: integer): boolean;
begin
  result:=BepInfo.blocInfo.writeInfo(x,nb);
end;

function TElphyFile.writeFileInfo(var x; nb: integer): boolean;
begin
  result:=BfileInfo.blocInfo.writeInfo(x,nb);
end;



procedure TElphyFile.setKsampling(n: integer; k: word);
begin
  Bseq.Ksampling[n-1]:=k;
end;

procedure TElphyFile.setKtype(n: integer; k: typetypeG);
begin
  Bseq.Ktype[n-1]:=k;
end;

procedure TElphyFile.close(Const NominalIndex:longword=0);
begin
  closeDataBlock(NominalIndex);

  inherited;
end;

function TElphyFile.createUtagStream(code1,index,ep1:integer;tm:TdateTime;st: AnsiString):TmemoryStream;
begin
  result:=TmemoryStream.create;

  with Btag.Utag do
  begin
    sampleIndex:=index;
    Stime:=tm;
    code:=code1;
    ep:=ep1;
  end;
  Btag.stCom:=st;

  Btag.saveToStream0(result,false);

end;


procedure TElphyFile.InsertSound(var buf;size:integer; first:boolean;tm:TdateTime);
type
  TRsoundHeader=
    record
      BlockSize:integer;
      st:string[6];
      hrec:TRdataRecord;
    end;

var
  flag:boolean;
  h:TRsoundHeader;
  res:integer;
begin
  flag:=FdataOpen;
  closeDataBlock;

  with h do
  begin
    BlockSize:=sizeof(h)+size;
    st:='RSOUND';
    hrec.mySize:=sizeof(TRdataRecord);
    hrec.Sfirst:=first;
    hrec.Stime:=tm;
  end;
  f.Write(h,sizeof(h));
  f.Write(buf,size);

  if flag then openDataBlock;
end;


{ evtTab est un tableau de tableaux d'entiers
  isEvt est un tableau de booléens indiquant les voies Evt
}
procedure TElphyFile.SaveEvtArray(evtTab: TElphyEvtTab; isEvt: TElphyIsEvt);
var
  flag:boolean;
  size,nbV:integer;
  nb:array[0..255] of integer;
  i:integer;
begin
  size:=0;
  nbV:=0;

  for i:=0 to high(isEvt) do
  if isEvt[i] then
    begin
      inc(nbV);
      nb[nbV-1]:=length(evtTab[i]);
      size:=size+length(EvtTab[i]);
    end;

  if size=0 then exit;
  size:=(size+nbV+1)*sizeof(integer);

  flag:=closeDataBlock;

  WriteReventHeader(f,size,now,false);

  f.Write(NbV,sizeof(nbV));
  f.Write(Nb[0],nbV*4);

  for i:=0 to high(isEvt) do
    if isEvt[i] then
      f.Write(EvtTab[i][0],length(EvtTab[i])*4);

  if flag then openDataBlock;
end;




procedure TElphyFile.setDBepInfo(var db: TDBrecord);
begin
  DBepInfo.assign(db);
end;

procedure TElphyFile.setDBfileInfo(var db: TDBrecord);
begin
  DBfileInfo.assign(db);
end;

end.
