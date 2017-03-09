unit DataGeneFile;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysUtils,
     util1,Gdos,
     stmObj,stmvec1,saveOpt1,
     stmError,debug0,DBrecord1 ;

const
  miniComSize=400;

{ FileInfo est sauvé dans createFile
  EpInfo est sauvé avec Save.

}


type
  TtagMode=(tmNone,
            tmDigiData,         // 4 or 2 bits in ADC values
            tmITC,              // One 16-bit channel dedicated to digital inputs
            tmCyberK            // Only transitions are stored in 16-bit words 
            );
  TDataGeneFile=
            class(typeUO)

                error:integer;
                ignoreError:boolean;
                fileName:AnsiString;
                f:TfileStream;

                open:boolean;

                channelCount:integer;
                Channels:array[1..16] of Tvector;
                Xstart,Xend:array[1..16] of float;
                Xorg:float;

                TagChCount:integer;
                TagCh:array[1..4] of Tvector;
                TagXstart,TagXend,TagSeuil:array[1..16] of float;

                saveRec:TsaveRecord;

                constructor create;override;
                destructor destroy;override;

                procedure setContinu(b:boolean);virtual;
                function getContinu:boolean;virtual;
                procedure setTagMode(b:TtagMode);virtual;
                function getTagMode:TtagMode;virtual;
                procedure setTagShift(b:integer);virtual;
                function getTagShift:integer;virtual;

                procedure setComment(st:AnsiString);virtual;
                function getComment:AnsiString;virtual;

                property continu:boolean read getcontinu write setcontinu;
                property TagMode:TtagMode read getTagMode write setTagMode;
                property TagShift:integer read gettagShift write settagShift;
                property comment:AnsiString read getComment write setComment;

                procedure processMessage(id:integer;source:typeUO;p:pointer);override;

                procedure setChannel(num:integer;v:Tvector;x1,x2:float);virtual;
                procedure setTagChannel(num:integer;v:Tvector;x1,x2,seuil:float);virtual;
                procedure ecrirePreSeq;virtual;

                procedure ecrirePostSeq;virtual;

                procedure createFile(st:AnsiString);virtual;
                procedure Append(st:AnsiString);virtual;

                procedure save;virtual;
                procedure close(Const NominalIndex:longword=0);virtual;
                procedure reopen;virtual;

                procedure installeOptions(saveRec1:TsaveRecord);virtual;
                procedure MajOptions;virtual;

                function setFileInfoSize(size:integer):boolean;virtual;
                function getFileInfoSize:integer;virtual;
                function setEpInfoSize(size:integer):boolean;virtual;
                function getEpInfoSize:integer;virtual;

                procedure copyFileInfo(p:pointer;sz:integer);virtual;
                procedure copyEpInfo(p:pointer;sz:integer);virtual;


                procedure Erase;virtual;


                function errorString:AnsiString;

                procedure setMtag(p:pointer);virtual;
                procedure UpdateMtag;virtual;
                procedure UpdateComment(st:AnsiString);virtual;

                procedure allocateMtag(nb:integer);virtual;
                procedure addMtag(tt:float;code:integer);virtual;

                procedure setAcqInf(p:pointer);virtual;
                procedure setStim(p:pointer);virtual;

                function getFileInfo(var x;nb,dep:integer):boolean;virtual;
                function setFileInfo(var x;nb,dep:integer):boolean;virtual;
                function readFileInfo(var x;nb:integer):boolean;virtual;
                function writeFileInfo(var x;nb:integer):boolean;virtual;
                procedure resetFileInfo;virtual;

                function getEpInfo(var x;nb,dep:integer):boolean;virtual;
                function setEpInfo(var x;nb,dep:integer):boolean;virtual;
                function readEpInfo(var x;nb:integer):boolean;virtual;
                function writeEpInfo(var x;nb:integer):boolean;virtual;
                procedure resetEpInfo;virtual;

                procedure setKsampling(n:integer;k:word);virtual;
                procedure setKtype(n:integer;k:typetypeG);virtual;

                procedure setDBfileInfo(var db: TDBrecord);virtual;
                procedure setDBepInfo(var db: TDBrecord);virtual;

              end;

Implementation

constructor TDataGeneFile.create;
begin
  inherited;

  notPublished:=true;
  SaveRec.init;

  channelCount:=1;
end;

destructor TDataGeneFile.destroy;
var
  i:integer;
begin
  for i:=1 to 16 do
    derefObjet(typeUO(channels[i]));

  for i:=1 to 4 do
    derefObjet(typeUO(TagCh[i]));

  inherited;
end;


procedure TDataGeneFile.setContinu(b:boolean);
begin
end;

function TDataGeneFile.getContinu:boolean;
begin
end;

procedure TDataGeneFile.setTagMode(b:TtagMode);
begin
end;

function TDataGeneFile.getTagMode:TtagMode;
begin
end;

procedure TDataGeneFile.setTagShift(b:integer);
begin
end;

function TDataGeneFile.getTagShift:integer;
begin
end;

procedure TDataGeneFile.setComment(st:AnsiString);
begin
end;

function TDataGeneFile.getComment:AnsiString;
begin
end;


procedure TDataGeneFile.processMessage(id:integer;source:typeUO;p:pointer);
var
  j:integer;
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        for j:=1 to 16 do
          if (channels[j]=source) then
            begin
              channels[j]:=nil;
              derefObjet(source);
            end;

        for j:=1 to 4 do
          if (Tagch[j]=source) then
            begin
              Tagch[j]:=nil;
              derefObjet(source);
            end;
      end;
  end;
end;

procedure TDataGeneFile.setChannel(num:integer;v:Tvector;x1,x2:float);
begin
  if (num<1) or (num>ChannelCount) then exit;

  derefObjet(typeUO(channels[num]));
  channels[num]:=v;
  refObjet(channels[num]);

  xstart[num]:=x1;
  xend[num]:=x2;
end;

procedure TDataGeneFile.setTagChannel(num:integer;v:Tvector;x1,x2,seuil:float);
begin
  if (num<1) or (num>TagChCount) then exit;

  derefObjet(typeUO(Tagch[num]));
  Tagch[num]:=v;
  refObjet(Tagch[num]);

  TagXstart[num]:=x1;
  TagXend[num]:=x2;
  tagSeuil[num]:=seuil;
end;


procedure TDataGeneFile.ecrirePreSeq;
begin
end;

procedure TDataGeneFile.ecrirePostSeq;
begin
end;

procedure TDataGeneFile.createFile(st:AnsiString);
begin
end;

procedure TDataGeneFile.Append(st:AnsiString);
begin
end;

procedure TDataGeneFile.save;
begin
end;

procedure TDataGeneFile.close(Const NominalIndex:longword=0);
begin
  if not open then exit;
  f.free;
  open:=false;
  affDebug('Close DataGeneFile',1);
end;

procedure TDataGeneFile.reopen;
begin
  if open then exit;

  f:=TfileStream.create(fileName,fmOpenReadWrite);
  f.position:=f.Size;

  open:=true;
end;


procedure TDataGeneFile.installeOptions(saveRec1:TsaveRecord);
begin
  saveRec1.copyTo(saveRec);
end;

procedure TDataGeneFile.MajOptions;
var
  i:integer;
begin
  if (channelCount<1) or not assigned(channels[1]) then exit;
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
      if Yauto[i] and assigned(channels[i]) then
        begin
          Dy[i]:=channels[i].Dyu;
          y0[i]:=channels[i].y0u;
          uy[i]:=channels[i].unitY;
        end;

  end;
end;

function TDataGeneFile.setFileInfoSize(size:integer):boolean;
begin
end;

function TDataGeneFile.setEpInfoSize(size:integer):boolean;
begin
end;

procedure TDataGeneFile.copyFileInfo(p:pointer;sz:integer);
begin
end;

procedure TDataGeneFile.copyEpInfo(p:pointer;sz:integer);
begin
end;

procedure TDataGeneFile.Erase;
begin
  close;
  deleteFile(fileName);
end;

function TDataGeneFile.errorString:AnsiString;
begin
  result:=#10+#13+getErrorString(error);
end;

procedure TDataGeneFile.setMtag(p:pointer);
begin
end;

procedure TDataGeneFile.UpdateMtag;
begin
end;

procedure TDataGeneFile.UpdateComment(st:AnsiString);
begin
end;

procedure TDataGeneFile.allocateMtag(nb:integer);
begin
end;

procedure TDataGeneFile.addMtag(tt:float;code:integer);
begin
end;

procedure TDataGeneFile.setAcqInf(p:pointer);
begin
end;

procedure TDataGeneFile.setStim(p:pointer);
begin
end;


function TDataGeneFile.getEpInfo(var x; nb, dep: integer): boolean;
begin
end;

function TDataGeneFile.getFileInfo(var x; nb, dep: integer): boolean;
begin
end;

function TDataGeneFile.readEpInfo(var x; nb: integer): boolean;
begin
end;

function TDataGeneFile.readFileInfo(var x; nb: integer): boolean;
begin
end;

procedure TDataGeneFile.resetEpInfo;
begin
end;

procedure TDataGeneFile.resetFileInfo;
begin
end;

function TDataGeneFile.setEpInfo(var x; nb, dep: integer): boolean;
begin
end;

function TDataGeneFile.setFileInfo(var x; nb, dep: integer): boolean;
begin
end;

function TDataGeneFile.writeEpInfo(var x; nb: integer): boolean;
begin
end;

function TDataGeneFile.writeFileInfo(var x; nb: integer): boolean;
begin
end;

function TDataGeneFile.getEpInfoSize: integer;
begin
end;

function TDataGeneFile.getFileInfoSize: integer;
begin
end;

procedure TDataGeneFile.setKsampling(n: integer; k: word);
begin

end;

procedure TDataGeneFile.setKtype(n:integer;k:typetypeG);
begin

end;

procedure TDataGeneFile.setDBfileInfo(var db: TDBrecord);
begin
end;

procedure TDataGeneFile.setDBepInfo(var db: TDBrecord);
begin
end;

end.
