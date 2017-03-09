unit FdefDac2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,sysutils,
     util1,Gdos,dtf0,descac1,spk0,blocInf0,debug0,Mtag0;


{ Définition de la structure d'un fichier Elphy/Dac2

  Un fichier DAC2 commence par typeHeaderDac2: le mot clé permet d'identifier le
  type de fichier. TailleInfo donne la taille totale du bloc d'info qui précède les
  données.

  On trouve ensuite plusieurs sous-blocs qui commencent tous par un enregistrement
  de type typeHeaderDac2 (id+taille).

  Le premier bloc est appelé 'MAIN' et contient typeInfoDac2
  Ensuite, on pourra trouver zéro ou plusieurs blocs. Par exemple, un bloc 'STIM'
  et un bloc 'USER INFO' .
}
const
  signatureDAC2='DAC2/GS/2000';
  signatureDAC2Seq='DAC2SEQ';
  signatureDAC2main='MAIN';


type
  typeHeaderDac2=object
                   id:string[15];      {garder 15 comme pour Acquis1}
                   tailleInfo:integer;
                   procedure init(taille:integer);
                   procedure init2(ident:AnsiString;taille:integer);
                   procedure write(var f:file);overload;
                   procedure write(f:TfileStream);overload;

                   procedure UWrite(var f:file);overload;
                   procedure UWrite(f:TfileStream);overload;

                 end;

  TAdcChannel=record              { 27 octets }
                uY:string[10];
                Dyu,Y0u:double;
              end;


  {Bloc écrit avant chaque séquence
   On n'écrit que les infos correspondant au nombre de voies.
   Après adcChannel, on pourra ajouter des info mais le déplacement ne sera pas
   fixe.
  }
  typeInfoSeqDAC2=
              object
                id:string[7];    {'DAC2SEQ'}
                tailleInfo:integer;

                nbvoie:byte;
                nbpt:integer;
                tpData:typeTypeG;

                postSeqI:integer;

                uX:string[10];
                Dxu,x0u:double;

                adcChannel:array[1..16] of TAdcChannel;             { 49 octets + nbvoie*27 }

                procedure init(nbvoie1:integer);
                procedure write(var f:file);overload;
                procedure write(f:TfileStream);overload;

                function seqSize:integer;
                function dataSize:integer;
              end;


  typeInfoDAC2=
              object
                id:string[15];      {garder 15 comme pour Acquis1}
                tailleInfo:integer;

                nbvoie:byte;
                nbpt:integer;
                tpData:typeTypeG;

                uX:string[10];
                Dxu,x0u:double;

                adcChannel:array[1..16] of TAdcChannel;

                preseqI,postSeqI:integer;
                continu:boolean;
                VariableEp:boolean;
                WithTags:boolean;
                TagShift:byte;

                procedure init(taille:integer);
                procedure write(var f:file);overload;
                procedure write(f:TfileStream);overload;

                procedure setInfoSeq(var infoSeq:typeInfoSeqDAC2);
                function controleOK:boolean;
              end;

  PinfoDac2=^TypeInfoDac2;



procedure SaveArrayAsDac2File(st:AnsiString;var tb;NbPt1,NbV1:integer;tp:typetypeG);overload;
procedure SaveArrayAsDac2File(st:AnsiString;var tb;NbPt1:integer;tp:typetypeG);overload;


implementation

{************************ Méthodes de TypeHeaderDAC2 ***********************}

procedure TypeHeaderDAC2.init(taille:integer);
begin
  fillchar(id,sizeof(id),0);
  id:=signatureDAC2;
  tailleInfo:=taille;
end;

procedure TypeHeaderDAC2.init2(ident:AnsiString;taille:integer);
begin
  fillchar(id,sizeof(id),0);
  id:=ident;
  tailleInfo:=taille;
end;

procedure TypeHeaderDAC2.write(var f:file);
var
  res:integer;
begin
  blockWrite(f,self,sizeof(TypeHeaderDAC2),res);
end;

procedure TypeHeaderDAC2.write(f:TfileStream);
var
  res:intG;
begin
  f.write(self,sizeof(TypeHeaderDAC2));
end;


procedure typeHeaderDac2.UWrite(var f:file);
var
  header:typeHeaderDac2;{header fichier}
  res:integer;
begin
  seek(f,0);
  blockread(f,header,sizeof(header),res);
  header.tailleInfo:=header.tailleInfo+tailleInfo;
  seek(f,0);
  blockwrite(f,header,sizeof(header),res);

  seek(f,fileSize(f));
  blockwrite(f,self,sizeof(TypeHeaderDAC2),res);

end;

procedure typeHeaderDac2.UWrite(f:TfileStream);
var
  header:typeHeaderDac2;{header fichier}
  res:integer;
begin
  f.position:=0;
  f.read(header,sizeof(header));
  header.tailleInfo:=header.tailleInfo+tailleInfo;
  f.Position:=0;
  f.write(header,sizeof(header));

  f.Position:=f.size;
  f.write(self,sizeof(TypeHeaderDAC2));

end;



{************************ Méthodes de TypeInfoDAC2 ***********************}

procedure TypeInfoDAC2.init(taille:integer);
var
  i:integer;
begin
  fillchar(id,sizeof(TypeInfoDAC2),0);
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

procedure TypeInfoDAC2.write(var f:file);
var
  res:integer;
begin
  blockWrite(f,self,sizeof(TypeInfoDAC2),res);
end;

procedure TypeInfoDAC2.write(f:TfileStream);
begin
  f.Write(self,sizeof(TypeInfoDAC2));
end;


procedure TypeInfoDAC2.setInfoSeq(var infoSeq:typeInfoSeqDAC2);
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

function typeInfoDac2.controleOK:boolean;
var
  i:integer;
begin
  result:=false;
  if (nbvoie<0) or (nbvoie>16) then
   begin
      messageCentral('Anomalous number of channels: '+Istr(nbvoie));
      exit;
    end;

  if not (tpData in [G_word, G_smallint,G_longint,G_single]) then
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

{******************** Méthodes de typeInfoSeqDAC2 *************************}

procedure typeInfoSeqDAC2.init(nbvoie1:integer);
var
  i:integer;
begin
  id:=signatureDAC2Seq;
  tailleInfo:=sizeof(TypeInfoSeqDAC2)-sizeof(TadcChannel)*(16-nbvoie1);
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


procedure typeInfoSeqDAC2.write(var f:file);
var
  res:integer;
begin
  blockWrite(f,self,tailleInfo,res);
end;

procedure typeInfoSeqDAC2.write(f:TfileStream);
begin
  f.Write(self,tailleInfo);
end;


function typeInfoSeqDAC2.DataSize:integer;
begin
  result:=nbpt*nbvoie*tailleTypeG[tpData];
end;

function typeInfoSeqDAC2.seqSize:integer;
begin
  result:=tailleInfo+dataSize+postSeqI;
end;



procedure SaveArrayAsDac2File(st:AnsiString;var tb;NbPt1,nbV1:integer;tp:typetypeG);
var
  res:integer;
  header:typeInfoDac2;
  headerDac2:typeHeaderDac2;
  infoseq:typeInfoSeqDAC2;
  tailleTot:integer;
  f:TfileStream;
begin
  tailleTot:=sizeof(headerDac2)+sizeof(header);

  HeaderDac2.init(tailleTot);
  header.init(sizeof(typeInfoDac2));
  InfoSeq.init(NbV1);

  with header do
  begin
    nbVoie:=nbV1;
    nbPt:=nbPt1 div nbV1;
    preSeqI:=sizeof(typeInfoSeqDac2)-(16-NbV1)*sizeof(TadcChannel);
    tpData:=tp;
  end;

  f:=nil;
  try
  f:=TfileStream.create(st,fmCreate);

  headerDac2.write(f);

  header.write(f);
  header.setInfoSeq(infoSeq);
  infoseq.write(f);

  f.Write(tb,nbPt1*tailleTypeG[tp]);
  f.Free;

  except
  f.free;
  end;
end;

procedure SaveArrayAsDac2File(st:AnsiString;var tb;NbPt1:integer;tp:typetypeG);
begin
  SaveArrayAsDac2File(st,tb,NbPt1,1,tp);
end;



end.
