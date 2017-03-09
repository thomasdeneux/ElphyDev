unit Dac2file;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysUtils,
     util1,Gdos,clock0, debug0,
     DataGeneFile,
     Fdefdac2,varconf1,
     Ncdef2,stmDef,stmObj,stmvec1,saveOpt1,blocInf0,
     Mtag0,
     stmError,stmPg,
     acqDef2
     ;

const
  miniComSize=400;

{ FileInfo est sauvé dans createFile
  EpInfo est sauvé avec Save.

}


type
  Textrabloc=record
               name:string[15];
               TotSize:integer;
               p:pointer;
             end;

  TDac2File= class(TdataGeneFile)
             private
                header:typeInfoDac2;

                FileInfo,EpInfo:TblocInfo;


                infoSeq:typeInfoSeqDac2;

                StComment:AnsiString;

                Mtag:PMtagArray;
                MtagOffset:integer;
                CommentOffset:integer;
                FallocMtag:boolean;


                acq:PacqRecord;
                stim:PparamStim;

                function verifierInfo1:integer;
                function verifierInfo2:integer;

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

                class function STMClassName:AnsiString;override;


                procedure ecrirePreSeq;override;
                procedure ecrirePostSeq;override;

                procedure createFile(st:AnsiString);override;
                procedure Append(st:AnsiString);override;

                procedure save;override;

                function setFileInfoSize(size:integer):boolean;override;
                function setEpInfoSize(size:integer):boolean;override;
                function getFileInfoSize:integer;override;
                function getEpInfoSize:integer;override;

                procedure copyFileInfo(p:pointer;sz:integer);override;
                procedure copyEpInfo(p:pointer;sz:integer);override;

                procedure setMtag(p:pointer);override;
                procedure UpdateMtag;override;
                procedure UpdateComment(st:AnsiString);override;

                procedure allocateMtag(nb:integer);override;
                procedure addMtag(tt:float;code:integer);override;

                procedure setAcqInf(p:pointer);override;
                procedure setStim(p:pointer);override;

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

              end;

procedure proTDac2File_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTDac2File_create_1(var pu:typeUO);pascal;
procedure proTDac2File_ChannelCount(nb:integer;var pu:typeUO);pascal;
function fonctionTDac2File_ChannelCount(var pu:typeUO):integer;pascal;

procedure proTDac2File_TagChannelCount(nb:integer;var pu:typeUO);pascal;
function fonctionTDac2File_TagChannelCount(var pu:typeUO):integer;pascal;

procedure proTDac2File_Xorg(w:float;var pu:typeUO);pascal;
function fonctionTDac2File_Xorg(var pu:typeUO):float;pascal;

procedure proTDac2File_Continuous(w:boolean;var pu:typeUO);pascal;
function fonctionTDac2File_Continuous(var pu:typeUO):boolean;pascal;


procedure proTDac2File_setChannel(num:integer;
                  var v:Tvector;x1,x2:float;var pu:typeUO);pascal;

procedure proTDac2File_setTagChannel(num:integer;
                  var v:Tvector;x1,x2,seuil:float;var pu:typeUO);pascal;

procedure proTDac2File_createFile(st:AnsiString;var pu:typeUO);pascal;
procedure proTDac2File_Append(st:AnsiString;var pu:typeUO);pascal;

procedure proTDac2File_save(var pu:typeUO);pascal;

procedure proTDac2File_close(var pu:typeUO);pascal;

procedure proTDac2File_GetEpInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTDac2File_SetEpInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTDac2File_ReadEpInfo(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTDac2File_WriteEpInfo(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTDac2File_ResetEpInfo(var pu:typeUO);pascal;

procedure proTDac2File_GetFileInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTDac2File_SetFileInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTDac2File_ReadFileInfo(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTDac2File_WriteFileInfo(var x;size:integer;tpn:word;var pu:typeUO);pascal;
procedure proTDac2File_ResetFileInfo(var pu:typeUO);pascal;

procedure proTDac2File_EpInfoSize(w:integer;var pu:typeUO);pascal;
function fonctionTDac2File_EpInfoSize(var pu:typeUO):integer;pascal;

procedure proTDac2File_FileInfoSize(w:integer;var pu:typeUO);pascal;
function fonctionTDac2File_FileInfoSize(var pu:typeUO):integer;pascal;

procedure proTdac2file_addMtag(tt:float;code:integer;var pu:typeUO);pascal;
procedure proTdac2file_allocMtag(nb:integer;var pu:typeUO);pascal;

implementation

uses descDac2;


var
  E_nbvoie:integer;
  E_numVoie:integer;

  E_0:integer;
  E_1:integer;
  E_2:integer;
  E_3:integer;
  E_4:integer;
  E_5:integer;
  E_6:integer;

  E_101:integer;
  E_102:integer;
  E_103:integer;
  E_104:integer;
  E_105:integer;
  E_106:integer;

  E_Dac2:integer;
  E_setEpInfo:integer;
  E_getEpInfo:integer;

  E_setFileInfo:integer;
  E_getFileInfo:integer;
  E_infoSize:integer;

  E_numTag:integer;

constructor TDac2file.create;
begin
  inherited;

  epInfo:=TblocInfo.create(0);
  FileInfo:=TblocInfo.create(0);

end;

destructor TDac2file.destroy;
var
  i:integer;
begin
  FileInfo.free;
  EpInfo.free;
  close;

  if FallocMtag and assigned(MTag) then freemem(MTag,Mtag^.size);

  inherited;
end;


procedure TDac2file.setContinu(b:boolean);
begin
  header.continu:=b;
end;

function TDac2file.getContinu:boolean;
begin
  result:=header.continu;
end;

procedure TDac2file.setTagMode(b:TtagMode);
begin
  header.withTags:=(b=tmDigiData);
end;

function TDac2file.getTagMode:TtagMode;
begin
  if header.withTags
    then result:=tmDigiData
    else result:=tmNone;
end;

procedure TDac2file.setTagShift(b:integer);
begin
  header.TagShift:=b;
end;

function TDac2file.getTagShift:integer;
begin
  result:=header.TagShift;
end;

procedure TDac2file.setComment(st:AnsiString);
begin
  stComment:=st;
end;

function TDac2file.getComment:AnsiString;
begin
  result:=stComment;
end;

class function TDac2file.STMClassName:AnsiString;
begin
  result:='Dac2File';
end;



{Vérification avant createFile}
function TDac2file.verifierInfo1:integer;
var
  i,nbsample:integer;
begin
  {
  if channelCount<1 then
    begin
      result:=e_0;
      exit;
    end;
  }
  if (channelCount=0) and (tagChCount>0) then
    begin
      result:=e_0;
      exit;
    end;

  for i:=1 to channelCount do
    if not Assigned(channels[i]) or not Assigned(channels[i].data) then
      begin
        result:=e_1;    { Données non valides }
        exit;
      end;

  for i:=1 to TagchCount do
    if not Assigned(Tagch[i]) or not Assigned(Tagch[i].data) then
      begin
        result:=e_1;    { Données non valides }
        exit;
      end;


  if assigned(channels[1])
    then nbSample:=channels[1].invconvx(Xend[1])-channels[1].invconvx(Xstart[1])+1
    else nbsample:=0;

  if nbSample<0 then
    begin
      result:=e_2;      { nombre de points par voie négatif }
      exit;
    end;

  for i:=2 to channelCount do
    if nbSample<>channels[i].invconvx(Xend[i])-channels[i].invconvx(Xstart[i])+1 then
      begin
        result:=e_3;    { nombre de points par voie différents pour chaque vecteur }
        exit;
      end;

  for i:=1 to TagchCount do
    if nbSample<>Tagch[i].invconvx(TagXend[i])-Tagch[i].invconvx(tagXstart[i])+1 then
      begin
        result:=e_3;    { nombre de points par voie différents pour chaque vecteur }
        exit;
      end;


  for i:=2 to channelCount do
    if saveRec.Xauto and (channels[i].dxu<>channels[1].dxu) then
      begin
        result:=e_4;    { Dxu différents selon le vecteur }
        exit;
      end;

  for i:=1 to TagchCount do
    if saveRec.Xauto and (Tagch[i].dxu<>channels[1].dxu) then
      begin
        result:=e_4;    { Dxu différents selon le vecteur }
        exit;
      end;


  for i:=1 to channelCount do
    if saveRec.tpAuto and (channels[i].inf.tpNum<>saveRec.tp) then
      begin
        result:=e_5;    { types de données différents selon le vecteur }
        exit;
      end;

  if saveRec.tpAuto and (channels[1].inf.tpNum<>G_smallint) and (tagChCount>0) then
    begin
      result:=e_6;
      exit;
    end;


  result:=0;
end;

{vérification avant save}
function TDac2file.verifierInfo2:integer;
var
  i:integer;
begin
  if channelCount<>header.nbvoie then
      begin
        result:=e_101;   { le nb de voies à changé depuis la création }
        exit;
      end;

  for i:=1 to channelCount do
    if not Assigned(channels[i]) or not Assigned(channels[i].data) then
      begin
        result:=e_102;   { données non valides }
        exit;
      end;

  for i:=1 to TagchCount do
    if not Assigned(TagCh[i]) or not Assigned(Tagch[i].data) then
      begin
        result:=e_102;   { données non valides }
        exit;
      end;


  for i:=1 to channelCount do
    if not continu and
       (header.nbpt<>channels[i].invconvx(Xend[i])-channels[i].invconvx(Xstart[i])+1) then
      begin
        result:=e_103;   { le nb de points dans chaque voie a changé depuis la création}
        exit;
      end;

  for i:=1 to TagchCount do
    if not continu and
       (header.nbpt<>Tagch[i].invconvx(tagXend[i])-TagCh[i].invconvx(tagXstart[i])+1) then
      begin
        result:=e_103;   { le nb de points dans chaque voie a changé depuis la création}
        exit;
      end;


  for i:=1 to channelCount do
    begin
      if SaveRec.tpAuto and
         not( (header.tpData=channels[i].inf.tpNum)
              or
              (header.tpData=G_single) and (channels[i].inf.tpNum=G_extended)
            )
       then
        begin
          result:=e_106; { Le type de données est différent du type à la création }
          exit;          { et on est en mode tpAuto }
        end;             { en not tpAuto, on fait une conversion de type}

    end;

  result:=0;
end;

procedure TDac2File.createFile(st:AnsiString);
var
  headerDac2:typeHeaderDac2;
  info:typeInfoDac2;
  res:intG;
  i:integer;
  nbSample:integer;
  tailleTot:integer;
  CommentHeader,MtagHeader,AcqHeader,stimHeader:typeheaderDac2;
  lcom:integer;
begin
  majOptions;

  error:=verifierInfo1;
  if (error<>0) and not ignoreError then exit;

  while length(comment)<MiniComSize do comment:=comment+' ';

  tailleTot:=sizeof(headerDac2)+sizeof(header);
  if FileInfo.tailleBuf>0
    then inc(tailleTot,sizeof(headerDac2)+FileInfo.tailleBuf);

  if comment<>'' then inc(tailleTot,sizeof(CommentHeader)+length(comment));

  HeaderDac2.init(tailleTot);

  with header do
  begin
    id:=signatureDac2main;     {On ne peut pas appeler init}
    tailleInfo:=sizeof(typeInfoDac2);
    nbVoie:=channelCount;

    if assigned(channels[1])
      then nbSample:=channels[1].invconvx(Xend[1])-channels[1].invconvx(Xstart[1])+1
      else nbsample:=0;

    nbPt:=nbSample;

    uX:=saveRec.ux;
    x0u:=Xorg;
    dxu:=saveRec.Dx;

    for i:=1 to channelCount do
      begin
        adcChannel[i].uY:=saveRec.uY[i];

        adcChannel[i].y0u:=saveRec.Y0[i];
        adcChannel[i].dyu:=saveRec.Dy[i];
      end;


    preSeqI:=sizeof(typeInfoSeqDac2)-(16-channelCount)*sizeof(TadcChannel);

    tpData:=saveRec.tp;

    postSeqI:=EpInfo.tailleBuf;
  end;

  info:=header;

  f:=TfileStream.create(st,fmCreate);

  headerDac2.write(f);

  header.write(f);

  if FileInfo.tailleBuf<>0 then
    with HeaderDac2 do
    begin
      init2('USER INFO',FileInfo.tailleBuf+sizeof(HeaderDac2));
      Write(f);
      fileInfo.write(f);
    end;



  CommentOffset:=f.position;
  CommentHeader.init(sizeof(typeHeaderDac2)+length(comment));
  CommentHeader.id:='COMMENT';
  CommentHeader.write(f);
  f.Write(stcomment[1],length(stcomment));

  if assigned(Mtag) then
    begin
      MtagOffset:=f.position;
      MtagHeader.init2('MTAG',sizeof(typeHeaderDac2)+Mtag^.size);
      MtagHeader.Uwrite(f);
      f.Write(Mtag^,Mtag^.size);
    end;

  if assigned(Acq) then
    begin
      AcqHeader.init2('ACQINF',sizeof(typeHeaderDac2)+sizeof(Acq^));
      AcqHeader.Uwrite(f);
      f.write(Acq^,sizeof(Acq^));
    end;

  if assigned(stim) then
    begin
      stimHeader.init2('DAC2STIM',sizeof(typeHeaderDac2)+sizeof(stim^));
      stimHeader.Uwrite(f);
      f.Write(stim^,sizeof(stim^));
    end;


  header.setInfoSeq(infoSeq);

  Open:=true;
  fileName:=st;

end;

procedure TDac2File.Append(st:AnsiString);
var
  desc:TDAC2Descriptor;

begin
  error:=0;
  MajOptions;
  close;

  epInfo.free;
  epInfo:=nil;
  fileInfo.free;
  fileInfo:=nil;


  desc:=TDAC2Descriptor.create;
  if not desc.initDF(st) then
    begin
      epInfo:=TblocInfo.create(0);
      fileInfo:=TblocInfo.create(0);
      error:=E_Dac2;
      desc.free;
      exit;
    end;

  try
  header:=desc.getInfoDac2^;
  channelCount:=header.nbvoie;
  epInfo:=TblocInfo.create(header.postSeqI);

  Mtag:=desc.getMtag(1);
  FallocMtag:=assigned(Mtag);
  MtagOffset:=desc.getMtagOffset;

  Comment:=desc.Comment;
  CommentOffset:=desc.getCommentOffset;

  fileInfo:=desc.getFileInfoCopy;

  f:=TfileStream.create(st,fmOpenReadWrite);
  f.Position:=f.Size;

  open:=true;
  header.setInfoSeq(infoSeq);

  finally
  desc.free;
  end;
end;


procedure TDac2file.ecrirePreSeq;
  begin
    infoSeq.write(f);
  end;

procedure TDac2file.ecrirePostSeq;
  begin
    EpInfo.write(f);
  end;


procedure TDac2File.save;
var
  res:intG;
  i,j,k,l:integer;
  n,i1,i2:integer;
  w:smallint;

  buf:pointer;
  m:int64;
  Nmax:integer;
  ts:word;
  tpDest:typetypeG;
  y:float;

begin
  error:=verifierInfo2;
  if error<>0 then exit;

  if not continu then ecrirePreSeq;

  i1:=channels[1].invConvX(xstart[1]);
  i2:=channels[1].invConvX(xend[1]);


  tpDest:=saveRec.tp;
  ts:=tailleTypeG[tpDest];

  m:=maxavail;
  if m>60000 then m:=60000;
  getmem(buf,m);
  fillchar(buf^,m,0);

  Nmax:=m div ts;

  if channelCount=1 then channels[1].data.open;

  n:=0;
  for i:=i1 to i2 do
    begin
      for j:=1 to channelCount do
        begin
          if (i>=channels[j].Istart) and (i<=channels[j].Iend)
            then y:=channels[j].data.getE(i)
            else y:=0;

          case tpDest of
            G_smallint:
              begin
                PtabEntier(buf)^[n]:=
                           roundL((y-saveRec.y0[j])/saveRec.dy[j]);
                if TagMode=tmDigiData then
                  begin
                    w:=PtabEntier(buf)^[n] shl tagShift;
                    for l:=1 to TagChCount do
                      if (i>=Tagch[l].Istart) and (i<=Tagch[l].Iend) and
                         (Tagch[l].data.getE(i)>TagSeuil[l])
                        then w:=w or word(1) shl (l-1);
                    PtabEntier(buf)^[n]:=w;
                  end;
              end;
            G_longint: PtabLong(buf)^[n]:=
                           roundL((y-saveRec.y0[j])/saveRec.dy[j]);
            G_single:  Ptabsingle(buf)^[n]:=y
          end;

          inc(n);
          if n=Nmax then
            begin
              f.write(buf^,ts*Nmax);
              fillchar(buf^,m,0);
              n:=0;
            end;
        end;
    end;
  if n<>0 then f.write(buf^,n*ts);

  if channelCount=1 then channels[1].data.close;

  freemem(buf,m);

  if not continu and (epInfo.tailleBuf<>0)
    then f.Write(epInfo.buf^,epInfo.tailleBuf);
end;


function TDac2File.setFileInfoSize(size:integer):boolean;
begin
  fileInfo.free;
  try
    fileInfo:=TblocInfo.create(size);
    result:=true;
  except
    fileInfo:=TblocInfo.create(0);
    result:=false;
  end;
  saveRec.fileBlock:=size;
end;

function TDac2File.setEpInfoSize(size:integer):boolean;
begin
  EpInfo.free;
  try
    EpInfo:=TblocInfo.create(size);
    result:=true;
  except
    EpInfo:=TblocInfo.create(0);
    result:=false;
  end;
  saveRec.EpBlock:=size;
end;

function TDac2File.getEpInfoSize: integer;
begin
  result:=EpInfo.tailleBuf;
end;

function TDac2File.getFileInfoSize: integer;
begin
  result:=FileInfo.tailleBuf;
end;


procedure Tdac2file.setMtag(p:pointer);
begin
  if FallocMtag and assigned(MTag) then freemem(MTag,Mtag^.size);
  Mtag:=p;
  FallocMtag:=false;
end;

procedure Tdac2file.UpdateMtag;
begin
  if not open or not assigned(Mtag) then exit;
  f.position:=MtagOffset+sizeof(typeHeaderDac2);
  f.Write(Mtag^,Mtag^.size);
end;

procedure Tdac2file.UpdateComment(st:AnsiString);
var
  res:integer;
begin
  if not open or (comment='') then exit;
  f.position:=CommentOffset+sizeof(typeHeaderDac2);

  while (length(st)<length(comment)) do st:=st+' ';
  st:=copy(st,1,length(comment));

  f.Write(st[1],length(st));
  comment:=st;
end;


procedure Tdac2file.allocateMtag(nb:integer);
begin
  if assigned(Mtag) then exit;

  getmem(MTag,8+nb*sizeof(TMtag));
  MTag^.init(nb);

  FallocMtag:=true;
end;

procedure Tdac2file.addMtag(tt:float;code:integer);
begin
  if (channelCount=0) then exit;

  if not assigned(Mtag) then
    begin
      if not open then allocateMtag(200)
                  else exit;
    end;

  Mtag^.add(channels[1].invconvx(tt)*channelCount,code);
end;


procedure Tdac2file.setAcqInf(p:pointer);
begin
  acq:=p;
end;

procedure Tdac2file.setStim(p:pointer);
begin
  stim:=p;
end;

procedure Tdac2file.copyFileInfo(p:pointer;sz:integer);
begin
  if assigned(p) and assigned(fileInfo) then
    begin
      if sz<=fileInfo.tailleBuf then sz:=fileInfo.tailleBuf;
      move(p^,fileInfo.buf^,sz)
    end;
end;

procedure Tdac2file.copyEpInfo(p:pointer;sz:integer);
begin
  if assigned(p) and assigned(epInfo) then
    begin
      if sz<=epInfo.tailleBuf then sz:=epInfo.tailleBuf;
      move(p^,epInfo.buf^,sz)
    end;
end;

function TDac2File.getEpInfo(var x; nb, dep: integer): boolean;
begin
  result:=EpInfo.getInfo(x,nb,dep);
end;

function TDac2File.getFileInfo(var x; nb, dep: integer): boolean;
begin
  result:=FileInfo.getInfo(x,nb,dep);
end;

function TDac2File.readEpInfo(var x; nb: integer): boolean;
begin
  result:=EpInfo.readInfo(x,nb);
end;

function TDac2File.readFileInfo(var x; nb: integer): boolean;
begin
  result:=FileInfo.readInfo(x,nb);
end;

procedure TDac2File.resetEpInfo;
begin
  EpInfo.resetInfo;
end;

procedure TDac2File.resetFileInfo;
begin
  fileInfo.resetInfo;
end;

function TDac2File.setEpInfo(var x; nb, dep: integer): boolean;
begin
  result:=EpInfo.setInfo(x,nb,dep);
end;

function TDac2File.setFileInfo(var x; nb, dep: integer): boolean;
begin
  result:=FileInfo.setInfo(x,nb,dep);
end;

function TDac2File.writeEpInfo(var x; nb: integer): boolean;
begin
  result:=EpInfo.writeInfo(x,nb);
end;

function TDac2File.writeFileInfo(var x; nb: integer): boolean;
begin
  result:=FileInfo.writeInfo(x,nb);
end;


{************************** Méthodes STM ********************************}

procedure proTDac2File_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TDac2File);
end;

procedure proTDac2File_create_1(var pu:typeUO);
begin
  proTDac2File_create('',pu);
end;

procedure proTDac2File_ChannelCount(nb:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (nb<1) or (nb>16) then sortieErreur(E_nbvoie);

  with TDac2File(pu) do channelCount:=nb;
end;

function fonctionTDac2File_ChannelCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDac2File(pu) do result:=channelCount;
end;

procedure proTDac2File_TagChannelCount(nb:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (nb<0) or (nb>2) then sortieErreur(E_nbvoie);

  with TDac2File(pu) do
  begin
    TagchCount:=nb;
    if nb>0 then
    begin
      TagMode:=tmDigiData;
      tagShift:=2;
    end
    else
    begin
      TagMode:=tmNone;
      tagShift:=0;
    end;
  end;
end;

function fonctionTDac2File_TagChannelCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDac2File(pu) do result:=TagchCount;
end;


procedure proTDac2File_Xorg(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDac2File(pu) do Xorg:=w;
end;

function fonctionTDac2File_Xorg(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TDac2File(pu) do result:=Xorg;
end;

procedure proTDac2File_Continuous(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  with TDac2File(pu) do
    if not open then continu:=w;
end;

function fonctionTDac2File_Continuous(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TDac2File(pu) do result:=continu;
end;


procedure proTDac2File_setChannel(num:integer;var v:Tvector; x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with TDac2File(pu) do
  begin
    if (num<1) or (num>channelCount) then sortieErreur(E_numVoie);
    setChannel(num,v,x1,x2);
  end;
end;

procedure proTDac2File_setTagChannel(num:integer;var v:Tvector; x1,x2,seuil:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with TDac2File(pu) do
  begin
    if (num<1) or (num>TagchCount) then sortieErreur(E_numTag);
    setTagChannel(num,v,x1,x2,seuil);
  end;
end;


procedure proTDac2File_createFile(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);

  with TDac2File(pu) do
  begin
    createFile(st);
    if error<>0 then sortieErreur(error);
  end;
end;

procedure proTDac2File_append(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);

  with TDac2File(pu) do
  begin
    append(st);
    if error<>0 then sortieErreur(error);
  end;
end;


procedure proTDac2File_save(var pu:typeUO);
begin
  verifierObjet(pu);

  with TDac2File(pu) do
  begin
    save;
    if error<>0 then sortieErreur(error);
  end;
end;

procedure proTDac2File_close(var pu:typeUO);
begin
  verifierObjet(pu);

  with TDac2File(pu) do close;
end;

procedure proTDac2File_GetEpInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDac2File(pu) do
  begin
    if not EpInfo.getInfo(x,size,dep) then sortieErreur(E_getEpInfo);
  end;
end;

procedure proTDac2File_SetEpInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDac2File(pu) do
  begin
    if not EpInfo.setInfo(x,size,dep) then sortieErreur(E_setEpInfo);
  end;
end;

procedure proTDac2File_ReadEpInfo(var x;size:integer;tpn:word;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDac2File(pu) do
  begin
    if not EpInfo.readInfo(x,size) then sortieErreur(E_getEpInfo);
  end;
end;

procedure proTDac2File_WriteEpInfo(var x;size:integer;tpn:word;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDac2File(pu) do
  begin
    if not EpInfo.writeInfo(x,size) then sortieErreur(E_setEpInfo);
  end;
end;

procedure proTDac2File_ResetEpInfo(var pu:typeUO);
begin
  verifierObjet(pu);
  with TDac2File(pu) do
  begin
    EpInfo.resetInfo;
  end;
end;


procedure proTDac2File_GetFileInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDac2File(pu) do
  begin
    if not FileInfo.getInfo(x,size,dep) then sortieErreur(E_getFileInfo);
  end;
end;

procedure proTDac2File_SetFileInfo(var x;size:integer;tpn:word;dep:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDac2File(pu) do
  begin
    if not FileInfo.setInfo(x,size,dep) then sortieErreur(E_setFileInfo);
  end;
end;

procedure proTDac2File_ReadFileInfo(var x;size:integer;tpn:word;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDac2File(pu) do
  begin
    if not FileInfo.readInfo(x,size) then sortieErreur(E_getFileInfo);
  end;
end;

procedure proTDac2File_WriteFileInfo(var x;size:integer;tpn:word;var pu:typeUO);
begin
  verifierObjet(pu);
  with TDac2File(pu) do
  begin
    if not FileInfo.writeInfo(x,size) then sortieErreur(E_setFileInfo);
  end;
end;

procedure proTDac2File_ResetFileInfo(var pu:typeUO);
begin
  verifierObjet(pu);
  with TDac2File(pu) do
  begin
    FileInfo.resetInfo;
  end;
end;


procedure proTDac2File_EpInfoSize(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(w,0,2E9,E_infoSize);
  with TDac2File(pu) do setEpInfoSize(w);
end;


function fonctionTDac2File_EpInfoSize(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDac2File(pu) do
  begin
    if assigned(EpInfo)
      then result:=EpInfo.tailleBuf
      else result:=0;
  end;
end;

procedure proTDac2File_FileInfoSize(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(w,0,2E9,E_InfoSize);

  with TDac2File(pu) do setFileInfoSize(w);
end;


function fonctionTDac2File_FileInfoSize(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TDac2File(pu) do
  begin
    if assigned(FileInfo)
      then result:=FileInfo.tailleBuf
      else result:=0;
  end;
end;


procedure proTdac2file_addMtag(tt:float;code:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TDac2File(pu).addMtag(tt,code);
end;

procedure proTdac2file_allocMtag(nb:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TDac2File(pu).allocateMtag(nb);
end;




Initialization
AffDebug('Initialization Dac2file',0);

installError(E_nbvoie,'TDac2file: Channel count out of range');
installError(E_numVoie,'TDac2file: Channel number out of range');

installError(E_0,'TDac2file: channel count = 0 !');
installError(E_1,'TDac2file: data not valid');
installError(E_2,'TDac2file: invalid number of samples');
installError(E_3,'TDac2file: channels have different numbers of samples');
installError(E_4,'TDac2file: channels have different X-scale parameters');
installError(E_5,'TDac2file: channels have different types of number');
installError(E_6,'TDac2file: Channel type must be T_smallint when tagChannelCount<>0');


installError(E_101,'TDac2file: channel count has changed');
installError(E_102,'TDac2file: data not valid');
installError(E_103,'TDac2file: Sample count has changed');
installError(E_104,'TDac2file: X-scale parameters have changed');
installError(E_105,'TDac2file: Y-scale parameters have changed');
installError(E_106,'TDac2file: Number type has changed');

installError(E_Dac2,'TDac2file: file format is not Acquis1');

installError(E_numTag,'TDac2file: Tag Channel number out of range');

installError(  E_setEpInfo,'TDac2file: setEpInfo error');
installError(  E_getEpInfo,'TDac2file: getEpInfo error');

installError(  E_setFileInfo,'TDac2file: setFileInfo error');
installError(  E_getFileInfo,'TDac2file: getFileInfo error');
installError(  E_infoSize,'TDac2file: InfoSize error');


end.
