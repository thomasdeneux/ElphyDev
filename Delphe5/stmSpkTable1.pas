unit StmSpkTable1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses windows,classes,graphics,sysutils, Controls,Dialogs,

     util1,Dgraphic,Dtrace1, debug0,
     dtf0,
     stmDef,stmObj,
     varconf1,
     stmVec1,
     NcDef2,stmPg,
     NexFile1;


{
}
type
  TspkArray = array of array of array of integer;  { [ep, ch, i ] }
  Tattarray = array of array of array of byte;     { [ep, ch, i ] }

type
  TSpkTable=   class(typeUO)
                  FnbEp,FnbCh:integer; { Sert à sauver/charger une cfg }
                  Plens:PtabLong;      { Sert à sauver/charger une cfg }
                  TPlens:integer;      { Sert à sauver/charger une cfg }

                  Att:TattArray;    { Att[ ep, ch , i] = 0 à 5 }

                  constructor create;override;
                  destructor destroy;override;

                  class function STMClassName:AnsiString;override;
                  function getInfo:AnsiString;override;
                  procedure setDims(nbEp,nbCh:integer);
                  function totAttCount:integer;

                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                  procedure CompleteLoadInfo;override;
                  procedure CompleteSaveInfo;override;

                  function loadData(f:Tstream):boolean; override;
                  procedure saveData(f:Tstream); override;

                  procedure InitDF(var attLen1:TarrayOfArrayOfInteger);
                  function getdataAtt(ch,ep:integer):typeDataB;

                  function loadFromNexFile(df:typeUO;stf:AnsiString;Const DeltaJeeter:float=0):integer;

                  function NbEp:integer;
                  function NbCh:integer;
                end;



{***************** Déclarations STM pour TvectorSpk *****************************}

procedure proTSpkTable_create(var pu:typeUO);pascal;

function fonctionTspkTable_EpCount(var pu:typeUO):integer;pascal;
function fonctionTspkTable_ChCount(var pu:typeUO):integer;pascal;
function fonctionTspkTable_SpkCount(ep,ch:integer;var pu:typeUO):integer;pascal;


procedure proTSpkTable_Att(ep,ch,n:integer;w:integer;var pu:typeUO);pascal;
function fonctionTSpkTable_Att(ep,ch,n:integer;var pu:typeUO):integer;pascal;


procedure proTSpkTable_LoadFromNexFile(var df:typeUO; stf:AnsiString;var pu:typeUO);pascal;
procedure proTSpkTable_LoadFromNexFile_1(var df:typeUO; stf:AnsiString;DeltaT:float;var pu:typeUO);pascal;


implementation

uses stmDf0, descElphy1;

{ TSpkTable }


constructor TSpkTable.create;
begin
  inherited;

end;

destructor TSpkTable.destroy;
begin
  inherited;
end;

class function TSpkTable.STMClassName: AnsiString;
begin
  result:='SpkTable';
end;

function TSpkTable.getInfo: AnsiString;
begin
  result:=inherited getInfo +
          'EpCount = '+Istr(nbEp)+crlf+
          'ChCount = '+Istr(nbCh)+crlf+
          'AttCount  = '+Istr(TotAttCount)+crlf;

end;

function TspkTable.totAttCount:integer;
var
  i,j:integer;
begin
  result:=0;
  for i:=0 to length(att)-1 do
  for j:=0 to length(att[i])-1 do
    result:=result+length(att[i,j]);
end;

procedure TSpkTable.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
var
  i,j:integer;
begin
  inherited;
  if not lecture then
  begin
    FnbEp:=nbEp;
    FnbCh:=nbCh;
    TPlens:=NbEp*NbCh*4;
    getmem(Plens,TPlens);
    for i:=0 to NbEp-1 do
    for j:=0 to NbCh-1 do
      if assigned(att[i])
        then Plens^[i+NbEp*j]:=length(att[i,j])
        else Plens^[i+NbEp*j]:=0;
  end;


  conf.SetVarConf('NbEp',FNbEp,sizeof(FNbEp)) ;
  conf.setVarConf('NbCh',FNbCh, sizeof(FNbCh));

  conf.setDynConf('AttLens',Plens,TPlens);
end;

procedure TSpkTable.CompleteLoadInfo;
var
  i,j:integer;
begin
  CheckOldIdent;
  setDims(FnbEp,FnbCh);

  for i:=0 to NbEp-1 do
  for j:=0 to NbCh-1 do
    setLength(Att[i,j],Plens^[i+NbEp*j]);

  freemem(Plens);
  Plens:=nil;
  TPlens:=0;
end;

procedure TSpkTable.CompleteSaveInfo;
begin
  freemem(Plens);
  Plens:=nil;
  TPlens:=0;
end;


procedure TSpkTable.setDims(nbEp, nbCh: integer);
begin
  setLength(att,nbEp,nbCh);
end;

procedure TSpkTable.saveData(f: Tstream);
var
  size,i,j:integer;
begin
  size:=TotAttCount;
  writeDataHeader(f,size);

  for i:=0 to high(att) do
  for j:=0 to high(att[i]) do
    f.Write(att[i,j,0], length(att[i,j]));
end;

function TSpkTable.loadData(f: Tstream): boolean;
var
  size,i,j:integer;
begin
  result:=readDataHeader(f,size);
  if result=false then exit;

  for i:=0 to high(att) do
  for j:=0 to high(att[i]) do
    f.Read(att[i,j,0], length(att[i,j]));

end;

procedure TSpkTable.InitDF(var attLen1:TarrayOfArrayOfInteger);
var
  i,j:integer;
begin
  if assigned(attlen1) then
  begin
    setDims(length(attlen1), length(attlen1[0]));

    for i:=0 to nbEp-1 do
    for j:=0 to nbCh-1 do
    if length(attlen1[i])>0 then
    begin
      setlength(att[i,j],attlen1[i,j]);
      fillchar(att[i,j,0],attlen1[i,j],0);
    end;
  end;
end;

function TSpkTable.getdataAtt(ch, ep: integer): typeDataB;
begin
  dec(ch);
  dec(ep);
  if (ep>=0) and (ep<length(att)) and (ch>=0) and (ch<length(att[0]))
    then result:=typeDataByte.create(@att[ep,ch,0],1,1,1,length(att[ep,ch]))
    else result:=nil;
end;



function DecodeName(stName:AnsiString;var ch,uu:integer): boolean;
var
  st,st1:AnsiString;
  code:integer;
begin
  result:=false;
  if Fmaj(copy(stName,1,4))<>'WSPK' then exit;

  st:=stName;

  delete(st,1,4);             { st = '12ub_wf' }
  while (st<>'') and not(st[length(st)] in ['0'..'9']) do delete(st,length(st),1);
  val(st,ch,code);            { st = '12' }
  if (code<>0) or (ch<1) or (ch>128) then exit;

  st1:=stName;
  delete(st1,1,4+length(st));           { st1 = 'ub_wf' }

  if pos('-',st1)>0 then delete(st1,pos('-',st1),100); {'ub'}
  st1:=lowercase(st1);

  if (st1='') or (st1[length(st1)] ='u')
    then uu:=0
    else uu:=ord(st1[length(st1)])-ord('a')+1;
  result:=true;
end;

function TSpkTable.loadFromNexFile(df:typeUO; stf: AnsiString;Const DeltaJeeter:float=0): integer;
var
  f:TfileStream;
  NexHeader: TNexFileHeader;
  NexVar: array of TNexVarHeader;

  stName,st,st1:AnsiString;
  tp1:integer;
  ch:integer;
  unit1:integer;

  i,k,code,uu:integer;
  NexSpks:array of array of array of integer;  { NexSpks[ch,unit][i]  ch et unit commencent à 0 }
  Spk:TspkArray;
  nbtot,n1tot:array of integer;

  isrc: array of integer;
  tt,ep,min:integer;
  nbSamps,deltaEp: TarrayOfInteger;

  UOK:array[0..3,1..128] of boolean;
  tpUtil:integer;
  DeltaJeeterI:integer;

begin
  with TdataFile(df).Vspk(1) do
    if unitX='ms'
      then DeltaJeeterI:= round(DeltaJeeter/dxu)
      else DeltaJeeterI:= round(DeltaJeeter*1000/dxu);

  TdataFile(df).BuildSpkArrays(Spk,Att);
  TelphyDescriptor(TdataFile(df).FileDesc).getVtagNbSamps(nbSamps);

  setLength(deltaEp,length(nbSamps));
  deltaEp[0]:=0;
  for i:=1 to high(nbSamps) do
    deltaEp[i]:=deltaEp[i-1]+nbSamps[i-1]-1;


  result:=100;
  if not FileExists(stf) then exit;

  TRY
  f:=TfileStream.Create(stf,fmOpenRead );
  f.Read(NexHeader,sizeof(NexHeader));


  with NexHeader do
  begin
    result:=101;
    if (NumVars<1) or (Numvars>1000) then exit;

    setLength(NexVar,NumVars);

    for i:=0 to NumVars-1 do f.Read(NexVar[i],sizeof(NexVar[i]));
  end;

  fillchar(UOk,sizeof(UOK),0);
  for i:=0 to NexHeader.Numvars-1 do
  begin
    stName:=PcharToString(@NexVar[i].name,64);        { stName = 'Wspk12b_wf' par exemple }
    tp1:=NexVar[i].type1;

    if decodeName(stName,ch,unit1) then
      if tp1 in [0,3] then Uok[tp1,ch]:=true;
  end;

  tpUtil:=-1;
  for i:=1 to 128 do
  begin
    if UOK[3,i] then
    begin
      tpUtil:=3;   // si tp =3 est présent (wspk), on le prend seulement s'il n'y a pas de de spk
      // break;
    end;
    if UOK[0,i] then
    begin
      tpUtil:=0;  // Si tp=0 est présent (spk), on utilise les spk
      break;
    end;
  end;

  {Charger les spikes dans NexSpks }


  for i:=0 to NexHeader.Numvars-1 do
  begin
    stName:=PcharToString(@NexVar[i].name,64);        { stName = 'Wspk12b_wf' par exemple }
    tp1:=NexVar[i].type1;
    if ( tp1=tpUtil) and decodeName(stName,ch,unit1) then
    begin
      dec(ch);
      if length(NexSpks)<=ch then setlength(NexSpks,ch+1);
      if length(NexSpks[ch])<=unit1 then setlength(NexSpks[ch],unit1+1);
      setLength(NexSpks[ch,unit1],NexVar[i].Count);

      f.position:= NexVar[i].dataOffset;
      f.Read(NexSpks[ch,unit1,0],NexVar[i].Count*4);
    end;
  end;

  result:=103;
  if length(Att[0])<length(NexSpks) then exit; { Le nombre de canaux doit être le même }

  setLength(NexSpks,length(Att[0]));

  { Vérifier que pour chaque canal, le nombre de spikes dans NexSpks est
    inférieur ou égal au nombre de spikes dans Att }
  setLength(nbtot,length(NexSpks));
  setLength(n1tot,length(NexSpks));

  result:=104;
  for ch:=0 to high(NexSpks) do
  begin
    { nb spikes par canal dans Att }
    nbTot[ch]:=0;
    for i:=0 to high(Att) do
      if assigned(att[i]) then  nbTot[ch]:=nbTot[ch]+length(Att[i,ch]);
    { nb spikes par canal dans le fichier NEX }
    n1tot[ch]:=0;
    for i:=0 to high(NexSpks[ch]) do n1tot[ch]:=n1tot[ch]+ length(NexSpks[ch,i]);


    { On exige l'égalité des nombres de spikes }
    if n1tot[ch] <> nbTot[ch] then exit;
  end;


  {Mettre à zéro la table , tous les spikes sont par défaut Unsorted  }
  for ep:=0 to high(att) do
  for ch:=0 to high(att[ep]) do
  for i:=0 to high(att[ep,ch]) do
    att[ep,ch,i]:=0;


  result:=105;
  { Transférer les spikes de NexSpks vers Att }
  for ch:=0 to high(Att[0]) do
  begin
    {Traitement canal ch }
    setlength(isrc,length(NexSpks[ch]));     {index par unité }
    fillchar(isrc[0],length(isrc)*4,0);


    for ep:= 0 to high(att) do
    if assigned(att[ep]) then
    for i:=0 to high(att[ep,ch]) do
    begin
      tt:=spk[ep,ch,i] {+DeltaEp[ep]};

      uu:=-1;
      min:=maxEntierLong;
      for k:=0 to high(isrc) do
      begin
        if (isrc[k]<length(NexSpks[ch,k])) and (NexSpks[ch,k,isrc[k]]<min) then
        begin
          uu:=k;
          min:=NexSpks[ch,k,isrc[k]];
        end;
      end;
      if (uu>=0) then
      begin
        if abs(tt-min)<=DeltaJeeterI then
        begin
          att[ep,ch,i]:=uu;
          inc(isrc[uu]);
        end
        else
        begin
          st:='LoadFromNEXfile Error Ep='+Istr(ep+1)+'  ch='+Istr(ch+1)+'  spk='+Istr(i+1)+'  .Continue ?';
          if MessageDlg(st, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then exit;
        end;

        {
        if tt>min
          then exit;
        }
      end;
    end;
  end;

  result:=0;
  FINALLY
  f.Free;
  END;

end;


function TSpkTable.NbCh: integer;
begin
  if length(Att)>0
    then result:=length(Att[0])
    else result:=0;
end;

function TSpkTable.NbEp: integer;
begin
  result:=length(Att);
end;



{******************************************** Méthodes STM ****************************}

procedure proTSpkTable_create(var pu:typeUO);
begin
  createPgObject('',pu,TspkTable);

end;

function fonctionTspkTable_EpCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TspkTable(pu).NbEp;
end;

function fonctionTspkTable_ChCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TspkTable(pu).NbCh;
end;

function fonctionTspkTable_SpkCount(ep,ch:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TspkTable(pu) do
  begin
    dec(ep);
    dec(ch);
    if (ep<0) or (ep>=nbEp) then sortieErreur('TSpkTable.SpkCount : Episode Number Out Of Range');
    if (ch<0) or (ch>=nbCh) then sortieErreur('TSpkTable.SpkCount : Channel Number Out Of Range');

    result:=length(Att[ep,ch]);
  end;
end;



procedure proTSpkTable_Att(ep,ch,n:integer;w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TspkTable(pu) do
  begin
    dec(ep);
    dec(ch);
    dec(n);
    if (ep<0) or (ep>=nbEp) then sortieErreur('TSpkTable.Att : Episode Number Out Of Range');
    if (ch<0) or (ch>=nbCh) then sortieErreur('TSpkTable.Att : Channel Number Out Of Range');
    if (n<0) or (n>=length(Att[ep,ch])) then sortieErreur('TSpkTable.Att : Index Out Of Range');

    Att[ep,ch,n]:=w;
  end;
end;

function fonctionTSpkTable_Att(ep,ch,n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TspkTable(pu) do
  begin
    dec(ep);
    dec(ch);
    dec(n);
    if (ep<0) or (ep>=nbEp) then sortieErreur('TSpkTable.Att : Episode Number Out Of Range');
    if (ch<0) or (ch>=nbCh) then sortieErreur('TSpkTable.Att : Channel Number Out Of Range');
    if (n<0) or (n>=length(Att[ep,ch])) then sortieErreur('TSpkTable.Att : Index Out Of Range');

    result:=Att[ep,ch,n];
  end;
end;

procedure proTSpkTable_LoadFromNexFile_1(var df:typeUO; stf:AnsiString; DeltaT:float;var pu:typeUO);
var
  code:integer;
  st:AnsiString;
begin
  verifierObjet(pu);
  verifierObjet(df);

  code:= TspkTable(pu).loadFromNexFile(df, stf, deltaT);

  case code of
    100: st:= 'File not found';
    101: st:= 'Number of NEX variables out of range';
    102: st:= 'Invalid NEX variable name';
    103: st:= 'Invalid channel count';
    104: st:= 'There are too many spikes in one channel of the NEX file';
    105: st:= 'A spike time in the NEX file is not present in the data file';
  end;

  if code <>0 then sortieErreur('TspkTable.LoadFromNexFile : unable to load table > '+st );
end;

procedure proTSpkTable_LoadFromNexFile(var df:typeUO; stf:AnsiString;var pu:typeUO);
begin
  proTSpkTable_LoadFromNexFile_1( df, stf, 0, pu);
end;


Initialization
AffDebug('Initialization StmSpkTable1',0);

registerObject(TspkTable,data);

end.
