unit ac1file;

interface

uses classes,
     util1,Gdos,clock0,
     ficdefAc,varconf1,blocInf0,
     Ncdef2,stmDef,stmObj,stmvec1,stmError,saveOpt1;

type
  Tac1File=   class(typeUO)
                error:integer;
                ignoreError:boolean;
                fileName:string;
                f:file;
                header:typeInfoAC1;


                FileInfo,EpInfo:TblocInfo;

                open:boolean;

                channelCount:integer;
                Channels:array[1..6] of Tvector;
                Xstart,Xend:array[1..6] of float;
                Xorg:float;

                ChannelsB:array[1..6] of Tvector;

                saveRec:TsaveRecord;

                constructor create;override;
                destructor destroy;override;

                class function STMClassName:string;override;


                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure RetablirReferences(list:Tlist);override;
                procedure processMessage(id:integer;source:typeUO;p:pointer);override;

                function verifierInfo1:integer;
                function verifierInfo2:integer;

                procedure setChannel(num:integer;v:Tvector;x1,x2:float);
                procedure ecrireEchelle(var f:file);
                procedure createFile(st:string);
                procedure Append(st:string);

                procedure save;
                procedure close;

                property continu:boolean read header.continu write header.continu;
                procedure installeOptions(saveRec1:TsaveRecord);
                procedure MajOptions;
              end;

procedure proTac1File_create(name:String;var pu:typeUO);pascal;
procedure proTac1File_ChannelCount(nb:smallint;var pu:typeUO);pascal;
function fonctionTac1File_ChannelCount(var pu:typeUO):smallint;pascal;

procedure proTac1File_Xorg(w:float;var pu:typeUO);pascal;
function fonctionTac1File_Xorg(var pu:typeUO):float;pascal;

procedure proTac1File_Continuous(w:boolean;var pu:typeUO);pascal;
function fonctionTac1File_Continuous(var pu:typeUO):boolean;pascal;

procedure proTac1File_setChannel(num:integer;
                  var v:Tvector;x1,x2:float;var pu:typeUO);pascal;

procedure proTac1File_createFile(st:String;var pu:typeUO);pascal;
procedure proTac1File_Append(st:String;var pu:typeUO);pascal;

procedure proTac1File_save(var pu:typeUO);pascal;

procedure proTac1File_close(var pu:typeUO);pascal;

procedure proTac1File_GetEpInfo(var x;size,tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTac1File_SetEpInfo(var x;size,tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTac1File_ReadEpInfo(var x;size,tpn:word;var pu:typeUO);pascal;
procedure proTac1File_WriteEpInfo(var x;size,tpn:word;var pu:typeUO);pascal;
procedure proTac1File_ResetEpInfo(var pu:typeUO);pascal;

procedure proTac1File_GetFileInfo(var x;size,tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTac1File_SetFileInfo(var x;size,tpn:word;dep:integer;var pu:typeUO);pascal;
procedure proTac1File_ReadFileInfo(var x;size,tpn:word;var pu:typeUO);pascal;
procedure proTac1File_WriteFileInfo(var x;size,tpn:word;var pu:typeUO);pascal;
procedure proTac1File_ResetFileInfo(var pu:typeUO);pascal;

procedure proTac1File_EpInfoSize(w:integer;var pu:typeUO);pascal;
function fonctionTac1File_EpInfoSize(var pu:typeUO):integer;pascal;

procedure proTac1File_FileInfoSize(w:integer;var pu:typeUO);pascal;
function fonctionTac1File_FileInfoSize(var pu:typeUO):integer;pascal;


Implementation

const
  E_nbvoie=1050;
  E_numVoie=1051;

  E_1=1052;
  E_2=1053;
  E_3=1054;
  E_4=1055;
  E_5=1056;

  E_101=1062;
  E_102=1063;
  E_103=1064;
  E_104=1065;
  E_105=1066;
  E_106=1067;

  E_ac1=1070;
  E_setEpInfo=1071;
  E_getEpInfo=1072;

  E_setFileInfo=1073;
  E_getFileInfo=1074;
  E_infoSize=1075;


constructor Tac1file.create;
begin
  inherited;

  SaveRec.init;

  epInfo:=TblocInfo.create(0);
  FileInfo:=TblocInfo.create(0);

  channelCount:=1;
end;

destructor Tac1file.destroy;
var
  i:integer;
begin
  FileInfo.free;
  EpInfo.free;
  close;

  for i:=1 to 6 do dereferenceObjet(typeUO(channels[i]));
  inherited;
end;

class function Tac1file.STMClassName:string;
begin
  result:='Ac1File';
end;





procedure Tac1file.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  conf.setvarConf('ChCount',channelCount,sizeof(channelCount));
  conf.setvarConf('Continu',header.continu,sizeof(header.continu));

  if lecture
    then conf.setvarConf('channels',channelsB,sizeof(channelsB))
    else conf.setvarConf('channels',channels,sizeof(channels));

end;

procedure Tac1File.RetablirReferences(list:Tlist);
var
  i,j:integer;
  p:pointer;
begin
  for i:=0 to list.count-1 do
    begin
     p:=typeUO(list.items[i]).myAd;

     for j:=1 to 6 do
       if p=channelsB[j] then
         begin
           channels[j]:=list.items[i];
           referenceObjet(channels[j]);
       end;
    end;
end;

procedure Tac1File.processMessage(id:integer;source:typeUO;p:pointer);
var
  j:integer;
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        for j:=1 to 6 do
          if (channels[j]=source) then
            begin
              channels[j]:=nil;
              dereferenceObjet(source);
            end;
      end;
  end;
end;

procedure TAc1File.setChannel(num:integer;v:Tvector;x1,x2:float);
begin
  if (num<1) or (num>ChannelCount) then exit;

  dereferenceObjet(typeUO(channels[num]));
  channels[num]:=v;
  referenceObjet(channels[num]);

  xstart[num]:=x1;
  xend[num]:=x2;

end;


function Tac1file.verifierInfo1:integer;
var
  i,nbsample:integer;
begin
  for i:=1 to channelCount do
    if not Assigned(channels[i]) or not Assigned(channels[i].data) then
      begin
        result:=e_1;
        exit;
      end;

  nbSample:=channels[1].invconvx(Xend[1])-channels[1].invconvx(Xstart[1])+1;
  if nbSample<0 then
    begin
      result:=e_2;
      exit;
    end;

  for i:=2 to channelCount do
    if nbSample<>channels[i].invconvx(Xend[i])-channels[i].invconvx(Xstart[i])+1 then
      begin
        result:=e_3;
        exit;
      end;

  for i:=2 to channelCount do
    if saveRec.Xauto and (channels[i].dxu<>channels[1].dxu) then
      begin
        result:=e_4;
        exit;
      end;

  for i:=1 to channelCount do
    if saveRec.Yauto[i] and (channels[i].inf.tpNum<>saveRec.tp) then
      begin
        result:=e_5;
        exit;
      end;

  result:=0;
end;


function Tac1file.verifierInfo2:integer;
var
  i,nbsample:integer;
begin
  if channelCount<>header.nbvoie then
      begin
        result:=e_101;
        exit;
      end;

  for i:=1 to channelCount do
    if not Assigned(channels[i]) or not Assigned(channels[i].data) then
      begin
        result:=e_102;
        exit;
      end;

  nbsample:=header.nbpt+32768*header.nbptex;

  for i:=1 to channelCount do
    if not header.continu and
       (nbSample<>channels[i].invconvx(Xend[i])-channels[i].invconvx(Xstart[i])+1) then
      begin
        result:=e_103;
        exit;
      end;

  for i:=1 to channelCount do
    if not header.EchelleSeqI then
    begin
      if not header.continu and SaveRec.Xauto and
         ((exToSingle(xOrg)<>exToSingle(header.x1)) or
          (exToSingle(xOrg+channels[i].dxu)<>exToSingle(header.x2))) then
        begin
          result:=e_104;
          exit;
        end;

      if header.continu and
         (exToSingle(channels[i].dxu)<>exToSingle(header.x2-header.x1)) and
         SaveRec.Xauto then
        begin
          result:=e_104;
          exit;
        end;

      if SaveRec.Yauto[i] and
         ((exToSingle(header.y1[i])<>exToSingle(channels[i].Y0u)) or
          (exToSingle(header.y2[i])<>exToSingle(header.y1[i]+channels[i].Dyu)))
        then
        begin
          result:=e_105;
          exit;
        end;

      if SaveRec.tpAuto and
         not( (header.tpData=channels[i].inf.tpNum)
              or
              (header.tpData=G_single) and (channels[i].inf.tpNum=G_extended)
            )
       then
        begin
          result:=e_106;
          exit;
        end;

    end;

  result:=0;
end;

procedure TAc1File.createFile(st:string);
var
  buf:array[1..1024] of byte;
  info:typeInfoAC1 ABSOLUTE buf;
  res:intG;
  i:integer;
  nbSample:integer;
begin
  majOptions;

  error:=verifierInfo1;
  if (error<>0) and not ignoreError then exit;

  fillchar(buf,sizeof(buf),0);
  with header do
  begin
    id:=signatureAC1;
    tailleInfo:=1024;
    if FileInfo.tailleBuf<>0 then inc(tailleInfo,FileInfo.tailleBuf+18);
    nbVoie:=channelCount;

    nbSample:=channels[1].invconvx(Xend[1])-channels[1].invconvx(Xstart[1])+1;

    nbPt:=nbSample and 32767;
    nbPtEx:=nbSample shr 15;

    uX:=saveRec.ux;
    i1:=0;
    i2:=1;
    x1:=Xorg;
    x2:=x1+saveRec.Dx;

    for i:=1 to channelCount do
      begin
        uY[i]:=saveRec.uY[i];

        j1[i]:=0;
        j2[i]:=1;
        y1[i]:=saveRec.Y0[i];
        y2[i]:=y1[i]+saveRec.Dy[i];

        Xmini[i]:=Xorg;
        Xmaxi[i]:=Xorg+Xend[i]-Xstart[i];
        Ymini[i]:=channels[i].Ymin;
        Ymaxi[i]:=channels[i].Ymax;
        modeA[i]:=byte(channels[i].visu.modeT);
      end;

    copierSingle;

    if EchelleSeqI then preSeqI:=sizeof(typeInfoSeqAC1);

    tpData:=saveRec.tp;

    postSeqI:=EpInfo.tailleBuf;

    info:=header;

    assign(f,st);
    Grewrite(f,1);
    Gblockwrite(f,buf,1024,res);

    if FileInfo.tailleBuf<>0 then
      with info do
      begin
        id:='USER INFO';
        tailleInfo:=FileInfo.tailleBuf+sizeof(id)+sizeof(tailleInfo);
        GblockWrite(f,info,sizeof(id)+sizeof(tailleInfo),res);
        GblockWrite(f,fileInfo.buf,FileInfo.tailleBuf,res);
      end;

    if GIO<>0 then sortieErreur(GIO);
  end;

  Open:=(GIO=0);
  if Open then fileName:=st;

end;

procedure TAc1File.Append(st:string);
var
  buf:array[1..1024] of byte;
  info:typeInfoAC1 ABSOLUTE buf;
  res:intG;
  p:integer;

begin
  MajOptions;
  close;
  epInfo.free;
  epInfo:=nil;
  fileInfo.free;
  fileInfo:=nil;

  fillchar(buf,1024,0);
  assign(f,st);
  Greset(f,1);
  Gblockread(f,buf,1024,res);

  if info.id<>signatureAC1 then
    begin
      epInfo:=TblocInfo.create(0);
      fileInfo:=TblocInfo.create(0);
      error:=E_ac1;
      exit;
    end;

  header:=info;
  channelCount:=info.nbvoie;

  epInfo:=TblocInfo.create(header.postSeqI);

  p:=1024;
  Gblockread(f,info,1024,res);

  if (GIO=0) and (copy(info.id,1,7)='PARSTIM') then
    begin
      p:=p+res;
      Gblockread(f,info,1024,res);
    end;

  if (GIO=0) and (info.id='USER INFO') then
    begin
      fileInfo:=TblocInfo.create(info.tailleInfo);
      Gseek(f,p+18);
      fileInfo.read(f);
    end;

  if not assigned(fileInfo) then fileInfo:=TblocInfo.create(0);
  Gseek(f,GfileSize(f));
  if GIO=0 then open:=true;
end;


procedure Tac1file.ecrireEchelle(var f:file);
  var
    info:typeInfoSeqAC1;
    res:intG;
    i:integer;
  begin
    with info do
    begin
      uX:=saveRec.uX;

      i1:=0;
      i2:=1;
      x1:=Xorg;
      x2:=x1+saveRec.Dx;

      for i:=1 to channelCount do
        begin
          uY[i]:=saveRec.uY[i];
          j1[i]:=0;
          j2[i]:=1;
          y1[i]:=saveRec.Y0[i];
          y2[i]:=y1[i]+saveRec.Dy[i];
        end;
    end;

    GblockWrite(f,info,sizeof(info),res);
  end;


procedure TAc1File.save;
var
  res:intG;
  i,j,n,i1,i2:integer;

  buf:pointer;
  m:integer;
  Nmax:integer;
  ts:word;
  tpDest:typetypeG;
  y:float;

begin
  error:=verifierInfo2;
  if error<>0 then exit;

  if not continu and header.EchelleSeqI then ecrireEchelle(f);

  i1:=channels[1].invConvX(xstart[1]);
  i2:=channels[1].invConvX(xend[1]);


  tpDest:=saveRec.tp;
  ts:=tailleTypeG[tpDest];

  m:=maxavail;
  if m>60000 then m:=60000;
  getmem(buf,m);
  fillchar(buf^,m,0);

  Nmax:=m div (ts*channelCount);

  if channelCount=1 then channels[1].data^.open;

  n:=0;
  for i:=i1 to i2 do
    begin
      for j:=1 to channelCount do
        begin
          if (i>=channels[j].Istart) and (i<=channels[j].Iend)
            then y:=channels[j].data^.getE(i)
            else y:=0;

          case tpDest of
            G_smallint: PtabEntier(buf)^[n*channelCount+j-1]:=
                           roundL((y-saveRec.y0[j])/saveRec.dy[j]);
            G_longint: PtabLong(buf)^[n*channelCount+j-1]:=
                           roundL((y-saveRec.y0[j])/saveRec.dy[j]);
            G_single:  Ptabsingle(buf)^[n*channelCount+j-1]:=y
          end;

          inc(n);
          if n=Nmax then
            begin
              Gblockwrite(f,buf^,ts*channelCount*Nmax,res);
              fillchar(buf^,m,0);
              n:=0;
            end;
        end;
    end;
  if n<>0 then Gblockwrite(f,buf^,n*channelCount*ts,res);


  if channelCount=1 then channels[1].data^.close;

  freemem(buf,m);

  if not continu and (epInfo.tailleBuf<>0)
    then GblockWrite(f,epInfo.buf^,epInfo.tailleBuf,res);
end;

procedure TAc1File.close;
begin
  if not open then exit;
  Gclose(f);
  open:=false;
end;

procedure TAc1File.installeOptions(saveRec1:TsaveRecord);
begin
  saveRec1.copyTo(saveRec1);
end;

procedure TAc1File.MajOptions;
var
  i:integer;
begin
  if channelCount<1 then exit;
  with saveRec do
  begin
    if Xauto then
      begin
        Dx:=channels[1].Dxu;
        ux:=channels[1].unitX;
      end;

    if TpAuto then
      begin
        tp:=channels[1].inf.tpNum;
      end;

    for i:=1 to channelCount do
      if Yauto[i] then
        begin
          Dy[i]:=channels[i].Dyu;
          y0[i]:=channels[i].y0u;
          uy[i]:=channels[i].unitY;
        end;

  end;
end;


{************************** Méthodes STM ********************************}

procedure proTac1File_create(name:String;var pu:typeUO);
begin
  createPgObject(name,pu,Tac1File);
end;

procedure proTac1File_ChannelCount(nb:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  if (nb<1) or (nb>6) then sortieErreur(E_nbvoie);

  with Tac1File(pu) do channelCount:=nb;
end;

function fonctionTac1File_ChannelCount(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  with Tac1File(pu) do result:=channelCount;
end;

procedure proTac1File_Xorg(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tac1File(pu) do Xorg:=w;
end;

function fonctionTac1File_Xorg(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tac1File(pu) do result:=Xorg;
end;

procedure proTac1File_Continuous(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tac1File(pu) do
    if not open then header.continu:=w;
end;

function fonctionTac1File_Continuous(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tac1File(pu) do result:=header.continu;
end;


procedure proTac1File_setChannel(num:integer;var v:Tvector; x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(v));

  with Tac1File(pu) do
  begin
    if (num<1) or (num>channelCount) then sortieErreur(E_numVoie);
    setChannel(num,v,x1,x2);
  end;
end;

procedure proTac1File_createFile(st:String;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tac1File(pu) do
  begin
    createFile(st);
    if error<>0 then sortieErreur(error);
  end;
  if GIO<>0 then sortieErreur(GIO);
end;

procedure proTac1File_append(st:String;var pu:typeUO);
begin
  verifierObjet(pu);

  with Tac1File(pu) do
  begin
    append(st);
    if error<>0 then sortieErreur(error);
  end;
  if GIO<>0 then sortieErreur(GIO);
end;


procedure proTac1File_save(var pu:typeUO);
begin
  verifierObjet(pu);

  with Tac1File(pu) do
  begin
    save;
    if error<>0 then sortieErreur(error);
  end;
  if GIO<>0 then sortieErreur(GIO);
end;

procedure proTac1File_close(var pu:typeUO);
begin
  verifierObjet(pu);

  with Tac1File(pu) do close;
  if GIO<>0 then sortieErreur(GIO);
end;

procedure proTac1File_GetEpInfo(var x;size,tpn:word;dep:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tac1File(pu) do
  begin
    if not EpInfo.getInfo(x,size,dep) then sortieErreur(E_getEpInfo);
  end;
end;

procedure proTac1File_SetEpInfo(var x;size,tpn:word;dep:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tac1File(pu) do
  begin
    if not EpInfo.setInfo(x,size,dep) then sortieErreur(E_setEpInfo);
  end;
end;

procedure proTac1File_ReadEpInfo(var x;size,tpn:word;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tac1File(pu) do
  begin
    if not EpInfo.readInfo(x,size) then sortieErreur(E_getEpInfo);
  end;
end;

procedure proTac1File_WriteEpInfo(var x;size,tpn:word;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tac1File(pu) do
  begin
    if not EpInfo.writeInfo(x,size) then sortieErreur(E_setEpInfo);
  end;
end;

procedure proTac1File_ResetEpInfo(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tac1File(pu) do
  begin
    EpInfo.resetInfo;
  end;
end;


procedure proTac1File_GetFileInfo(var x;size,tpn:word;dep:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tac1File(pu) do
  begin
    if not FileInfo.getInfo(x,size,dep) then sortieErreur(E_getFileInfo);
  end;
end;

procedure proTac1File_SetFileInfo(var x;size,tpn:word;dep:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tac1File(pu) do
  begin
    if not FileInfo.setInfo(x,size,dep) then sortieErreur(E_setFileInfo);
  end;
end;

procedure proTac1File_ReadFileInfo(var x;size,tpn:word;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tac1File(pu) do
  begin
    if not FileInfo.readInfo(x,size) then sortieErreur(E_getFileInfo);
  end;
end;

procedure proTac1File_WriteFileInfo(var x;size,tpn:word;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tac1File(pu) do
  begin
    if not FileInfo.writeInfo(x,size) then sortieErreur(E_setFileInfo);
  end;
end;

procedure proTac1File_ResetFileInfo(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tac1File(pu) do
  begin
    FileInfo.resetInfo;
  end;
end;


procedure proTac1File_EpInfoSize(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(w,0,65535,E_infoSize);
  with Tac1File(pu) do
  begin
    EpInfo.free;
    EpInfo:=TblocInfo.create(w);
    saveRec.EpBlock:=w;
  end;
end;


function fonctionTac1File_EpInfoSize(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tac1File(pu) do
  begin
    if assigned(EpInfo)
      then result:=EpInfo.tailleBuf
      else result:=0;
  end;
end;

procedure proTac1File_FileInfoSize(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(w,0,65535,E_InfoSize);

  with Tac1File(pu) do
  begin
    FileInfo.free;
    FileInfo:=TblocInfo.create(w);
    saveRec.fileBlock:=w;
  end;
end;


function fonctionTac1File_FileInfoSize(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tac1File(pu) do
  begin
    if assigned(FileInfo)
      then result:=FileInfo.tailleBuf
      else result:=0;
  end;
end;




initialization

installError(E_nbvoie,'Tac1file: Channel count out of range');
installError(E_numVoie,'Tac1file: Channel number out of range');

installError(E_1,'Tac1file: data not valid');
installError(E_2,'Tac1file: invalid number of samples');
installError(E_3,'Tac1file: channels have different numbers of samples');
installError(E_4,'Tac1file: channels have different X-scale parameters');
installError(E_5,'Tac1file: channels have different types of number');

installError(E_101,'Tac1file: channel count has changed');
installError(E_102,'Tac1file: data not valid');
installError(E_103,'Tac1file: Sample count has changed');
installError(E_104,'Tac1file: X-scale parameters have changed');
installError(E_105,'Tac1file: Y-scale parameters have changed');
installError(E_106,'Tac1file: Number type has changed');

installError(E_ac1,'Tac1file: file format is not Acquis1');
installError(E_infoSize,'Tac1file: info size out of range');

end.
