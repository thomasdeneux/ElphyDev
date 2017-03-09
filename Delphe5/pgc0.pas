unit pgc0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysutils,forms,
     util1,Dgraphic,listG,
     Ncdef2,symbac3,Dulex5,
     procac2,adProc2,
     memoForm,
     debug0,
     viewListG2,
     stmdef;

Const
{$IFDEF WIN64}
  PgcExt = '.PGC64';
{$ELSE}
  PgcExt = '.PGC';
{$ENDIF}

type
  TpgContext=class
              cs:pointer;
              CodeSize:integer;
              DS:pointer;
              DataSize:integer;

              PlexTrait,PlexInit,PlexFin,PlexInit0,PlexCont:integer;
              PlexProgram:TstringList;

              tableSymbole:TtableSymbole;
              compileOK:boolean;

              adList,Ulist:TlistG;   {liste des adresses des lignes de code numligne+ad }
              BlockList: Tlist;      {liste des adresses des débuts de blocs (procédures et programs) }
              Funit:boolean;

              UsesList:TstringList;

              tabProc:TtabDefProc;
              tabAdr:TtabAdresse;
              ownerForm:Tform;
              ownerName:AnsiString;

              TxtFileName:AnsiString;
              TxtFileDate:TdateTime;
              stImplicit:AnsiString;

              stError:AnsiString;
              ObjNameList:TstringList;

              constructor create(tbPrc:TtabDefProc;tbAdr:TtabAdresse;
                                 ownerF:Tform;caption,stImp:AnsiString
                                  );
              destructor destroy;override;
              procedure reset;
              procedure resetVars;

              Procedure InfoCode;

              function getLine(ad:integer;var stf:AnsiString;var CurBloc,NumProg:integer):integer;
              function FindAddress(line1:integer;stFile:string): integer;

              procedure savePg(stf:AnsiString;TextDate:TdateTime);
              procedure saveBadPg(stf:AnsiString;TextDate:TdateTime);

              function loadPg0(stf:AnsiString;PgNamesOnly:boolean):boolean;

              function loadPg(stf:AnsiString):boolean;
              function loadPgNames(stf:AnsiString):boolean;

              function ObjetExiste(st:AnsiString):boolean;

              function loadUnit(st:AnsiString;var errC: AnsiString; var ligC,colC:integer;
                                var errFile:AnsiString;Fbuild:boolean; var IsCompiled: boolean):TpgContext;
              function loadUses(var errC: AnsiString;var ligC,colC:integer;
                                var errFile:AnsiString;Fbuild:boolean; var isCompiled:boolean):boolean;
              procedure replaceAdSymbByAbs(main:boolean);

              procedure replaceAdSymbByTrueAd(Plex1,Plex2: PtUlex);

              procedure linkPg;
              procedure copierCodeSymb;
              procedure CreerListeSymb(TbSymb: TtableSymbole; Pstart:ptUlex; main:boolean);
              procedure copierAdListe(pgc:TpgContext;ad,sz,numU:integer);

              procedure compiler(stF:AnsiString;var error: AnsiString;var lig,col:integer;
                                 var ErrFile:AnsiString;Fbuild:boolean);

              procedure compilerExtra(stF:TstringList;var Pcode,Pend:pointer; Pdata:pointer; var error: AnsiString; var lig,col:integer;
                                 var ErrFile:AnsiString;Fbuild:boolean);

              procedure DisplayPgCode;

              procedure DisplayAdList;
              function getAdListData(n:integer):AnsiString;

              procedure DisplayUList;
              function getUListData(n:integer):AnsiString;

              procedure ViewProgStat;

              procedure InitTables;
              procedure InitBlockList;
              procedure GetBlockInfo(ad:integer;var ProcAd, NumProg:integer);

              function getSymboleFileName(Pdef: PdefSymbole): string;
              function getSymboleInfo(Pdef: PdefSymbole): string;
              function  FindProjectFile(st: AnsiString): AnsiString;
            end;


  TheaderPGC=record
               id:String[15];
               tailleHeader:integer; {=sizeof(TheaderPGC) }

               PrcVersion:integer;   { doit rester le 3ème champ}
               FormatVersion:word;

               PTrait,PInit,PFin,PInit0,PCont:integer;
               LPlexProgram:word;
               TxtDate:TdateTime;
               LUlist:word;
               IsUnit:boolean;
             end;

const
  PGCsgn='ELPHY EXE/2001';
  FormatVersion0=16;

type
  TadListRecord=record
                  ad:integer;
                  num:integer;
                end;
  PadListRecord=^TadListRecord;

  TUListRecord=record
                 ad:integer;
                 num:integer;
               end;
  PUListRecord=^TUListRecord;

var
  CompHis:TstringList;

procedure ClearMainUsesList;

implementation

uses
  Ncompil3,
  FdefDac2;


{***************************** Méthodes de TpgContext ***********************}

type
  TPgcURecord=record
                   cs:pointer;
                   pgc:TpgCOntext;
                   numU:integer;
                 end;
  PPgcURecord=^TPgcURecord;

var
  MainUsesList:Tstringlist;  // Liste principales des noms d'unités, en majuscules (sans path ou ext)

  listeSource,listeDest,listeSymbTab:Tlist;
  listePgcU:TlistG;



procedure ClearMainUsesList;
var
  i:integer;
begin
  for i:=0 to MainUsesList.count-1 do
    TpgContext(MainUsesList.objects[i]).free;
  MainUsesList.clear;

end;

constructor TpgContext.create(tbPrc:TtabDefProc;tbAdr:TtabAdresse;
                                 ownerF:Tform;caption,stImp:AnsiString
                                  );
var
  i:integer;
begin
  tabProc:=tbPrc;
  tabAdr:=tbAdr;
  ownerForm:=ownerF;
  ownerName:=caption;
  stImplicit:=stImp;

  PlexProgram:=TstringList.create;
  tableSymbole:=TtableSymbole.create;

  AdList:=TlistG.create(sizeof(TadListRecord));
  UList:=TlistG.create(sizeof(TUListRecord));
  BlockList:=Tlist.create;

  UsesList:=TstringList.create;

  ObjNameList:=TstringList.create;
  with tabProc do
  for i:=0 to nbTypeObjet-1 do
    ObjNameList.add(ObjectName(i));
end;

procedure TpgContext.reset;
begin
  tableSymbole.reset;

  freemem(ds);
  ds:=nil;
  dataSize:=0;

  freemem(cs);
  cs:=nil;

  codeSize:=0;

  PlexTrait:=-1;
  PlexInit:=-1;
  PlexInit0:=-1;
  PlexFin:=-1;
  PlexCont:=-1;

  PlexProgram.clear;

  compileOK:=false;

  AdList.clear;
  Ulist.clear;
  BlockList.clear;

  UsesList.clear;
  Funit:=false;
end;

procedure TpgContext.resetVars;
begin
  tableSymbole.FreeObjects;
  tableSymbole.freeVars;
end;

destructor TpgContext.destroy;
begin
  reset;
  PlexProgram.free;
  tableSymbole.free;

  AdList.free;
  Ulist.Free;
  BlockList.free;

  UsesList.free;
  ObjNameList.free;
  inherited;
end;

Procedure TpgContext.InfoCode;
begin
  if not compileOK then messageCentral('Program is not compiled')
  else ViewProgStat;
end;

function TpgContext.getLine(ad:integer;var stf:AnsiString; var CurBloc,NumProg:integer):integer;
var
  p:^TadListRecord;
  k:integer;
  numU:integer;
begin
  P:=adList.getSortedItemDword(ad,0,k);
  if assigned(p)
    then result:=p^.num
    else result:=1;

  stF:=txtFileName;

  if (Ulist.count>0) and (ad>=PUlistRecord(Ulist[0])^.ad) then
    begin
      numU:=PUlistRecord(Ulist.getSortedItemDword(ad,0,k))^.num;
      if (numU>=0) and (numU<UsesList.Count)
        then stF:= FindProjectFile(UsesList[numU])
        else stF:='?';
    end;

  getBlockInfo(ad,CurBloc,NumProg);

end;

function TpgContext.FindAddress(line1:integer;stFile:string): integer;
var
  i:integer;
  Admin,AdMax: integer;
  NumUnit: integer;
begin
  result:=-1;
  if CompareText(stFile,TxtFileName)=0
    then NumUnit:=0
    else NumUnit:= UsesList.IndexOf(stFile)+1;
  if NumUnit<0 then exit;

  if NumUnit=0
    then Admin:=0
    else Admin:= PUlistRecord(Ulist[NumUnit-1])^.ad;

  if NumUnit<Ulist.count
    then Admax:= PUlistRecord(Ulist[NumUnit])^.ad
    else AdMax:= MaxEntierLong;

  with AdList do
  for i:=0 to count-1 do
    with PUlistRecord(AdList[i])^ do
    if (num=line1) and (ad>=AdMin) and (ad<AdMax) then
    begin
      result:=ad;
      exit;
    end;

end;

{$I DacVer.pas}

procedure TpgContext.savePg(stf:AnsiString;TextDate:TdateTime);
var
  header:TheaderPGC;
  f:TfileStream;
  res:integer;
  stPlex:AnsiString;
  adPlex:array[0..1000] of pointer;
  i:integer;
  AdListSize,UlistSize:integer;
  stU:AnsiString;

begin
  if PlexProgram.count>0 then
    with PlexProgram do
    begin
      stPlex:=strings[0];
      adPlex[0]:=objects[0];
      for i:=1 to count-1 do
        begin
          stPlex:=stPlex+'|'+strings[i];
          adPlex[i]:=objects[i];
        end;
    end
  else stPlex:='';

  f:=TfileStream.create(stf,fmCreate);

  with header do
  begin
    id:=PGCsgn;
    PRCversion:=DacVersion;
    FormatVersion:=FormatVersion0;
    tailleHeader:=sizeof(header);

    PTrait:=PlexTrait;
    PInit:=PlexInit;
    PFin:=PlexFin;
    PInit0:=PlexInit0;
    PCont:=PlexCont;

    LPlexProgram:=length(stPlex);

    TxtDate:=TextDate;

    LUlist:=length(UsesList.Text);
    IsUnit:=Funit;
  end;


  f.Write(header,sizeof(header));

  stU:=UsesList.text;
  f.Write(stU[1],length(stU));

  f.Write(stPlex[1],length(stPlex));
  f.Write(adPlex,PlexProgram.count*sizeof(pointer));

  f.Write(codeSize,sizeof(codeSize));
  f.Write(cs^,codeSize);

  tableSymbole.write(f);

  AdListSize:=adList.count*sizeof(TadListRecord);
  f.Write(AdListSize,sizeof(AdListSize));
  f.Write(AdList.getPointer^,AdList.count*sizeof(TadListRecord));

  UListSize:=UList.count*sizeof(TUListRecord);
  f.Write(UlistSize,sizeof(UlistSize));
  f.Write(UList.getPointer^,UList.count*sizeof(TUListRecord));


  f.free;
end;

procedure TpgContext.saveBadPg(stf:AnsiString;TextDate:TdateTime);
var
  header:TheaderPGC;
  f:TfileStream;
  res:integer;

begin
  f:=nil;
  try
  f:= TfileStream.Create(stf,fmCreate);

  fillchar(header,sizeof(header),0);
  with header do
  begin
    id:=PGCsgn;
    tailleHeader:=sizeof(header);
    IsUnit:=Funit;
  end;

  f.Write(header,sizeof(header));
  f.free;
  except
  f.free;
  end;
end;


function TpgContext.loadPg0(stf:AnsiString;PgNamesOnly:boolean):boolean;
var
  header:TheaderPGC;
  f:TfileStream;
  res:integer;
  stPlex:AnsiString;
  adPlex:array[0..1000] of pointer;
  i,k:integer;

  AdListSize,UlistSize:integer;
  stU:AnsiString;
  textDate:TdateTime;
begin
{ On essaie de charger le fichier pgc s'il existe
  La fonction renvoie false si
    - le format est mauvais
    - la version ne correspond pas
    etc..
}
  result:=false;

  TRY
  TxtFileName:=stF;
  if not fileExists(stF) then exit;                      { Le fichier existe ? }

  Textdate:=FileDateToDateTime(FileAge(stF));

  stF:=ChangeFileExt(stf,PgcExt);
  if not FileExists(stF) then exit;

  f:=nil;
  try
  f:=TfileStream.create(stf,fmOpenRead);
  fillchar(header,sizeof(header),0);
  f.Read(header.id,sizeof(header.id)+sizeof(header.tailleHeader));
  if header.id<>PGCsgn then
    begin
      f.free;
      messageCentral(extractFileName(stf)+' is not an Elphy code file');
      exit;
    end;
                                                           { C'est un bon pgc }
  reset;

  f.Read(header.PrcVersion,header.tailleHeader-sizeof(header.id)-sizeof(header.tailleHeader));

  if (header.PrcVersion<>DacVersion) or
     (header.FormatVersion<>FormatVersion0) or
     (header.txtDate<>TextDate) and (TextDate<>0)
  then
    begin
      {messageCentral(extractFileName(stf)+' is no longer a valid code');}
      exit;
    end;
                                                           { avec la bonne version }

  with header do
  begin
    setLength(stU,LUlist);
    f.Read(stU[1],LUlist);
    UsesList.Text:=stU;

    setLength(stPlex,LPlexProgram);
    f.Read(stPlex[1],LplexProgram);

    PlexProgram.clear;
    repeat
      k:=pos('|',stPlex);
      if k<=0 then k:=length(stPlex)+1;
      if k>1 then PlexProgram.add(copy(stPlex,1,k-1));
      delete(stPlex,1,k);
    until stPlex='';

    f.Read(adPlex,sizeof(Pointer)*PlexProgram.count);
    for i:=0 to PlexProgram.count-1 do
      PlexProgram.objects[i]:=adPlex[i];

    PlexTrait:=PTrait;
    PlexInit:=PInit;
    PlexFin:=PFin;
    PlexInit0:=PInit0;
    PlexCont:=PCont;

    Funit:=IsUnit;
  end;

  if PgNamesOnly then
  begin
    result:=true;
    exit;
  end;

  f.Read(codeSize,sizeof(codeSize));
  if CodeSize>0 then
    begin
      getmem(cs,codeSize+codeExtraSize);
      f.Read(cs^,codeSize);
    end;

  if not tableSymbole.Read(f) then
    begin
      freemem(cs);
      cs:=nil;
      exit;
    end;

  if not Funit then tableSymbole.allouerDS(ds,dataSize);

  f.Read(AdlistSize,sizeof(AdListSize));
  if AdListSize>0 then
    begin
      adList.count:=AdListSize div sizeof(TadListRecord);
      f.Read(AdList.getPointer^,AdListSize);
    end;

  f.Read(UlistSize,sizeof(UListSize));
  if UListSize>0 then
    begin
      UList.count:=UListSize div sizeof(TUListRecord);
      f.Read(UList.getPointer^,UListSize);
    end;

  InitBlockList;
  finally
  f.free;
  end;

  result:=true;
  EXCEPT
  result:=false;
  END;

  compileOK:=result;
end;

function TpgContext.loadPg(stf:AnsiString):boolean;
begin
  result:= loadPg0(stf,false);
end;

function TpgContext.loadPgNames(stf:AnsiString):boolean;
begin
  result:= loadPg0(stf,true);
end;


function TpgContext.ObjetExiste(st:AnsiString):boolean;
begin
  result:=tableSymbole.ObjetExiste(st);
end;



function  TpgContext.FindProjectFile(st: AnsiString): AnsiString;
begin
  if extractFileExt(st)='' then st:= st+'.PG2';
  result:=Pg2CurrentPath+ extractFileName(st);     { on cherche le fichier d'abord dans le répertoire courant }
  if not FileExists(result)                                               { puis dans la liste de répertoires }
    then result:=FindFileInPathList(result,Pg2SearchPath);
end;

function TpgContext.loadUnit(st:AnsiString;var errC:AnsiString;var ligC,colC:integer;
                             var errFile:AnsiString; Fbuild:boolean; var IsCompiled: boolean):TpgContext;
var
  i:integer;
  stTxt:AnsiString;
  stF:AnsiString;
  ok:boolean;
  isComp:boolean;

begin
  st:=Fmaj(st);
  i:=MainUsesList.IndexOf(st);                      {Si l'unité est déjà en mémoire }
  if i>=0 then
    begin
      result:=TpgContext(MainUsesList.objects[i]);  {on l'utilise }
      i:=UsesList.indexof(st);
      if i>=0
        then UsesList.objects[i]:=result            {elle peut être déjà dans les uses ? }
        else UsesList.AddObject(st,result);
      exit;
    end;

  result:=nil;

  stTxt:= FindProjectFile(st+'.PG2');
  if stTxt='' then exit;

  stF:=ChangeFileExt(stTxt,PgcExt);
  result:=TpgContext.create(tabProc,tabAdr,nil,'',stImplicit);
  ok:=result.loadPg(stTxt);                         { Charger le code si possible }
  if not ok or Fbuild then                          { sinon compiler }
    begin
      result.compiler(stTxt,errC,ligC,colC, errFile,Fbuild);
      ok:=(errC='');
      Iscompiled:= ok;
    end
  else IsCompiled:=false;

  if ok then
    begin
      MainUsesList.addObject(st,result);
      result.tableSymbole.MainNum:= MainUsesList.count;
      i:=UsesList.indexof(st);
      if i>=0
        then UsesList.objects[i]:=result
        else UsesList.AddObject(st,result);

      isComp:=false;
      ok:=ok and result.loadUses(errC,ligC,colC,errFile,Fbuild, isComp );
    end;

  if ok and isComp then
  begin
    result.compiler(stTxt,errC,ligC,colC, errFile,Fbuild);
    ok:=(errC='');
    Iscompiled:= ok;
  end;

  if not ok then
    begin
      result.free;
      result:=nil;
    end
  else initTables;

end;

function TpgContext.loadUses(var errC: AnsiString; var ligC,colC:integer;
                             var errFile:AnsiString;Fbuild:boolean;var isCompiled:boolean):boolean;
var
  i:integer;
  p1:TpgContext;
  isComp:boolean;
begin
  result:=false;
  isCompiled:=false;

  for i:=0 to UsesList.count-1 do
    begin
      isComp:=false;
      p1:=loadUnit(UsesList[i],errC,ligC,colC,errFile,Fbuild, isComp);
      if isComp then Iscompiled:=true;
      if p1=nil then exit;
    end;
  result:=true;
end;

{Copier les adresses des lignes de code pour retrouver les erreurs }
procedure TpgContext.copierAdListe(pgc: TpgContext; ad, sz,numU: integer);
var
  k:integer;
  la:TadListRecord;
  lu:TUlistRecord;
  pla:PadListRecord;
begin
  lu.ad:=codeSize;
  lu.num:=numU;
  Ulist.add(@lu);

  pla:=PAdListrecord(pgc.adList.getSortedItemDword(ad+3,0,k));
  {correction +3 car les procédures commencent 3 octets après}

  if assigned(pla) then
  repeat
    la:= PAdListRecord(pgc.adList.Items[k])^;
    if la.ad<ad+sz then
      begin
        la.ad:=la.ad-ad+codeSize;
        adList.add(@la);
        inc(k);
      end
    else break;
  until k>=pgc.adList.count;

end;

{ replaceAdSymbByAbs remplace les déplacements contenus dans le code par des adresses absolues
  Les déplacements (adV, adU...) donnent la position du symbole correspondant dans la
  table des symboles.
  On les remplace par des pointeurs qui donnent directement l'adresse du symbole.

  Si Main=true (pg principal):
    - on ne touche pas à la table des symboles
    - on peut mettre l'adresse finale en place directement (déplacement dans cs ou ds)
  Sinon
    - on appelle tableSymbole.replaceAdSymbByAbs(CSmain)

}
procedure TpgContext.replaceAdSymbByAbs(main:boolean);
var
  plex1,pfin:ptUlex;
  adPgc:array[0..255] of TpgContext; { reçoit les adresses des pgc de l'unité courante (0)
                                    et des unités qu'elle utilise (1, 2,..) }
  i:integer;
begin
  adPgc[0]:=self;
  for i:=0 to UsesList.count-1 do
    adPgc[i+1]:=pointer(UsesList.objects[i]); {}

  if not main then tableSymbole.replaceAdByAbs(intG(cs));

  plex1:=cs;
  pfin:=cs;
  inc(intG(pfin),CodeSize);

  while (Plex1^.genre<>finFich) and (intG(plex1)<intG(pfin)) do
  with plex1^ do
  begin
    case genre of
      procU,foncU:
        begin
          adU:=intG(adPgc[numUnitProc].tableSymbole.SymbAbs(adU));
          if main and (numUnitProc=0)
            then adU:=PdefSymbole(adu)^.infP.adresse;
        end;
      variByte..variAnsiString,variObject:
        if (adV>=0) then
        begin
          adV:=intG(adPgc[numUnitVar].tableSymbole.SymbAbs(adV));
          if main and (numUnitVar=0)
            then adV:=PdefSymbole(adv)^.infV.deplacement;
        end;

      variDef:
        if (adDef>=0) then
        begin
          adDef:=intG(adPgc[numUnitDef].tableSymbole.SymbAbs(adDef));
          if main and (numUnitDef=0)
            then adDef:=PdefSymbole(adDef)^.infV.deplacement;
        end;
    end;
    Plex1:=UlexSuivant(Plex1);
  end;
end;

procedure TpgContext.replaceAdSymbByTrueAd(Plex1,Plex2: PtUlex);
var
  i:integer;
begin
  while (intG(plex1)<intG(plex2)) and (Plex1^.genre<>finFich)  do
  with plex1^ do
  begin
    case genre of
      procU,foncU:        adU:=tableSymbole.SymbAbs(adU)^.infP.adresse;

      variByte..variAnsiString,variObject:
        if (adV>=0) and (adV<tableSymbole.tableSize) then adV:=tableSymbole.SymbAbs(adV)^.infV.deplacement;

      variDef:
        if (adDef>=0) and (adV<tableSymbole.tableSize) then  adDef:= tableSymbole.SymbAbs(adDef)^.infV.deplacement;
    end;
    Plex1:=UlexSuivant(Plex1);
  end;
end;


{ CreerListeSymb range dans listeSource tous les symboles utilisés qui ne sont pas
 dans la table principale.
 Pstart est placé au début du code dans le primary file ou bien au début d'une procédure dans une unité
}
procedure TpgContext.CreerListeSymb(TbSymb: TtableSymbole; Pstart:ptUlex;Main:boolean);
var
  Plex1:ptUlex;
begin
  Plex1:=Pstart;
  while not( (Plex1^.genre=stop) and not main or (Plex1^.genre=finFich)) do
  begin
    with plex1^ do
    begin
      case genre of
        procU,foncU:
          begin
            if ((numUnitProc>0) or not main)
               and (listeSource.indexof(pointer(adU))<0) then
              begin
                listeSource.add(pointer(adU));
                if numUnitProc=0
                  then listeSymbTab.add(tbSymb )
                  else listeSymbTab.add( TbSymb.tables[NumUnitProc]);      // (TpgContext(UsesList.Objects[NumUnitProc-1]).tableSymbole );

                CreerListeSymb(TbSymb.tables[NumUnitProc], pointer(PdefSymbole(adU)^.infP.adresse),false);
              end;
          end;
        variByte..variAnsiString,variObject:
          begin
            if ( (numUnitVar>0) or not main)
               and (adV<>-1) and (listeSource.indexof(pointer(adV))<0) then
              begin
                listeSource.add(pointer(adV));
                if numUnitVar=0
                  then listeSymbTab.add(tbSymb )
                  else listeSymbTab.add( TbSymb.tables[NumUnitVar]);  //TpgContext(UsesList.Objects[NumUnitVar-1]).tableSymbole );
              end;
          end;
         variDef:
          begin
            if ( (numUnitDef>0) or not main)
               and (adDef<>-1) and (listeSource.indexof(pointer(adDef))<0) then
              begin
                listeSource.add(pointer(adDef));
                if numUnitVar=0
                  then listeSymbTab.add(tbSymb )
                  else listeSymbTab.add(TbSymb.tables[NumUnitDef]); //  TpgContext(UsesList.Objects[NumUnitDef-1]).tableSymbole );
              end;
          end;

        vid:begin
              messageCentral('CreerListeSymb Plex^.genre=vid en '
                 +Istr(intG(plex1)-intG(pstart)));
              exit;
            end;
      end;
    end;

    Plex1:=UlexSuivant(Plex1);
  end;
end;

{ Copier le code et les symboles .
}
procedure TpgContext.copierCodeSymb;
var
  Pdef:PdefSymbole;
  symbT:TtableSymbole;
  Pstart,Plex1,Plink:ptUlex;
  sz:integer;
  i,k:integer;
  sp:PPgcURecord;
  listeSec,listeDep:Tlist;

begin
  listeSec:=Tlist.create;
  listeDep:=Tlist.create;

  tableSymbole.InitierSymbole(listeSec,listeDep);

  for i:=0 to listeSource.count-1 do
  begin
    Pdef:=listeSource[i];
    symbT:=listeSymbTab[i];

    case Pdef^.ident of
      SprocU:
        begin
          Pstart:=pointer(Pdef^.infP.adresse);
          ListeDest.add(pointer(codeSize));

          {Chercher la taille de la procédure}
          Plex1:=Pstart;
          while (Plex1^.genre<>stop) do
          begin
            if Plex1^.genre=vid then messageCentral('CopierCodeSymb 1/ Plex1^.genre=vid');
            Plex1:=UlexSuivant(Plex1);
          end;
          sz:=intG(Plex1)-intG(Pstart)+1; {Inclure le stop}

          {Réallouer le code}
          reallocmem(cs,codeSize+codeExtraSize+sz);
          Plink:=cs;
          inc(intG(Plink),codeSize);

          {Et copier la procédure}
          move(Pstart^,Plink^,sz);


          sp:=listePgcU.getSortedItemDword(longword(Pstart),0,k);
          {
          with sp^ do messageCentral
          ('k='+Istr(k)+' '+Istr(intG(Pstart))+' '+Istr(intG(pgc))+' '+Istr(numU));
          }
          {Copier les adresses des débuts des lignes de source}
          with sp^ do
          copierAdListe(pgc,intG(Pstart)-intG(pgc.cs),sz,numU);


          {Copier aussi le symbole}
          tableSymbole.copierSymbole(listeSec,listeDep,Pdef,symbT,codeSize);

          inc(codeSize,sz);
        end;

      Svar:
        begin
          ListeDest.add(pointer(tableSymbole.dataSize));
          tableSymbole.copierSymbole(listeSec,listeDep,Pdef,symbT,0);
        end;
      {else tableSymbole.copierSymbole(Pdef,symbT,0);}

    end;

  end;

  listeSec.free;
  listeDep.free;
end;


{      LINK

  L'opération LINK consiste à créer un seul segment de code à partir des diférents modules.
  Comme on veut pouvoir inspecter les variables globales, on copie aussi les symboles des
  tables secondaires dans la table principale.

  Au moment du link, tous les pgc sont en mémoire, correctement compilés.
  Il ne devrait donc pas y avoir d'erreur.

  1- On remplace toutes les adresses dans le code par des adresses absolues
     Les déplacements de Symbole deviennent des PdefSymbole
     On remplace également les adresses de code dans les symboles par des adresses absolues.
     Les déplacements de code deviennent des adresses de code PtUlex

  2- On crée la liste des symboles externes utilisés en balayant récursivement le code source.
     On obtient listeSource.

  3- On copie tous les segments de code externes utilisés dans le segment principal
     ainsi que les symboles utilisés. Dans le symbole copié, on range l'adresse de code
     absolue utile.

  4- on remplace toutes les adresses absolues dans le code par des déplacements.
     on remplace aussi les adresses absolues dans les symboles par des déplacements.

}
procedure TpgContext.linkPg;
var
  plex1,pfin:ptUlex;
  i,k:integer;
  tot:integer;
  pgc:TpgCOntext;
  sp:TPgcURecord;
begin
  InitTables;

  listeSource.clear;
  listeSymbTab.clear;

  listePgcU.clear;
  listeDest.clear;

  {Donner à chaque table de symbole une pseudo adresse des données}
  tot:=dataSize;
  for i:=0 to mainUsesList.count-1 do
    with TpgContext(mainUsesList.objects[i]).tableSymbole  do
    begin
      setLinkPosition(tot);
      tot:=tot+dataSize;
    end;

  {Etablir la liste des correspondances pgc-numU}
  for i:=0 to mainUsesList.count-1 do
  begin
    pgc:=TpgContext(mainUsesList.objects[i]);
    sp.cs:=pgc.cs;
    sp.pgc:=pgc;
    sp.numU:=i;
    listePgcU.Add(@sp);
  end;

  listePgcU.sortDword(0);
  {
  for i:=0 to mainUsesList.count-1 do
    with PPgcURecord(listePgcU[i])^ do
    messageCentral(Istr(intG(cs))+' '+Istr(intG(pgc))+' '+Istr(numU));
  }

  {Remplacer les déplacements des procédures par des adresses
                   absolues dans tous les pgc en mémoire}
  AffDebug('linkPg 1',111);
  replaceAdSymbByAbs(true);
  AffDebug('linkPg 2',111);
  for i:=0 to mainUsesList.count-1 do
    TpgContext(mainUsesList.objects[i]).replaceAdSymbByAbs(false);
  AffDebug('linkPg 3',111);

  {Créer la liste des symboles externes utilisés}
  CreerListeSymb(tableSymbole,cs,true);

  AffDebug('linkPg 4',111);
  {Copier le code externe }
  CopierCodeSymb;

  AffDebug('linkPg 5',111);
  {Remplacer les adresses absolues par des déplacements}
  plex1:=cs;
  pfin:=Plex1;
  inc(intG(Pfin),codeSize);

  while intG(plex1)<intG(pfin) do
  begin
    with plex1^ do
    begin
      case genre of
        procU,foncU:
          begin
            k:=listeSource.indexof(pointer(adU));
            if k>=0 then adU:=intG(listeDest[k]);
          end;
        variByte..variAnsiString,variObject:
           if adV<>-1 then
           begin
            k:=listeSource.indexof(pointer(adV));
            if k>=0 then adV:=intG(listeDest[k]);
          end;
        variDef:
           if adDef<>-1 then
           begin
            k:=listeSource.indexof(pointer(adDef));
            if k>=0 then adDef:=intG(listeDest[k]);
          end;
      end;
    end;
    Plex1:=UlexSuivant(Plex1);
  end;

  AffDebug('linkPg 6',111);
  listeSource.clear;
  listePgcU.clear;
  listeDest.clear;

  tableSymbole.resetUnitAtt;
  tableSymbole.finalize;

  InitBlockList;
end;

procedure TpgContext.compiler(stF:AnsiString;var error: AnsiString;var lig,col:integer;
                              var ErrFile:AnsiString;Fbuild:boolean);
var
  compil:Tcompil;

  st,st1:AnsiString;
  U:TUtextFile;
  i:integer;
  Pdum:pointer;
begin
  reset;

  TxtFileName:=stF;
  compHis.add(stF);


  TxtFileDate:=fileDateToDateTime(FileAge(stF));

  U:=TUtextFile.create(stF);

  compil:=Tcompil.create(tabProc,tabAdr);
  compil.ownerForm:=ownerForm;
  compil.ownerName:=ownerName;

  TRY
    with compil do
    begin
      init(U,self);
      resetImplicit;

      st:=stImplicit;
      while NextStringG(st,st1) do setImplicit(st1);

      compilerPg(error,lig,col,ErrFile,Fbuild,nil,nil,Pdum);
      if error='' then
      begin
        if not Funit
           then linkPg;

        if not Funit then
          begin
            tableSymbole.allouerDS(DS,dataSize);
            UsesList.Clear;
            for i:=0 to mainUsesList.count-1 do
              UsesList.add(mainUsesList.Strings[i]);
          end;

        savePg(ChangeFileExt(TxtfileName,PgcExt),TxtFileDate);
      end
      else saveBadPg(ChangeFileExt(TxtfileName,PgcExt),TxtFileDate);
      stError:=compil.lastError;
    end;
  FINALLY
    compil.free;
    U.Free;
  END;
end;

procedure TpgContext.compilerExtra(stF:TstringList;var Pcode,Pend: pointer;Pdata:pointer; var error: AnsiString; var lig,col:integer;
                                 var ErrFile:AnsiString;Fbuild:boolean);
var
  compil:Tcompil;

  st,st1:AnsiString;
  U: TUTextStringList;
  i:integer;

begin

  Pcode:=pointer(intG(cs)+CodeSize);

  U:=TUTextStringList.create(stF);

  compil:=Tcompil.create(tabProc,tabAdr);
  compil.ownerForm:=ownerForm;
  compil.ownerName:=ownerName;

  TRY
    with compil do
    begin
      init(U,self);
      resetImplicit;

      st:=stImplicit;
      while NextStringG(st,st1) do setImplicit(st1);

      CurrentPrefix:=ProcNameOnStop+'.';

      compilerPg(error,lig,col,ErrFile,Fbuild,Pcode,Pdata,Pend);


      stError:=compil.lastError;
    end;
  FINALLY
    compil.free;
    U.Free;
  END;
end;


procedure TpgContext.DisplayPgCode;
  var
    viewText:TviewText;
    plex1,plex2:ptUlex;
    stX:AnsiString;
    j:integer;
    pFin:ptUlex;
  begin
    if (cs=nil) or (codeSize>20000) then exit;

    viewText:=TviewText.create(nil);
    pfin:=cs;

    inc(intG(pfin),codeSize);

    ViewText.caption:='pg1code.txt';
    plex1:=cs;

    ViewText.memo1.clear;
    ViewText.memo1.lines.add('Symbol size='+Istr(tableSymbole.tableSize));
    ViewText.memo1.lines.add('Code size='+Istr(CodeSize));
    ViewText.memo1.lines.add('Data size='+Istr(DataSize));
    ViewText.memo1.lines.add('');
    repeat
      with plex1^ do
      begin
        stX:=Jgauche(Istr(intG(plex1)-intG(cs)),10)+ nomLex(genre)+'   ';
        case genre of
              nbi: stX:=stX+Istr(vnbI);
              nbl: stX:=stX+Istr(vnbL);
              nbr: stX:=stX+Estr1(vnbR,12,3);
              chaineCar,motNouveau: stX:=stX+st;
              constCar:stX:=stX+vc;
              param: stX:=stX+' '+tpNumName[tpParam];
              proced:stX:=stX+Istr(nbParP);
              fonc:  stX:=stX+'  NbP= '+Istr(nbParF)+'  TpR= '+Istr(ord(tpRes))+'  NumF= '+Istr(NumFonc);
              motGoto:stX:=stX+Istr(adresse);
              forUp,forDw:stX:=stX+Istr(depfin);

              variI,variL,variByte,variShort,variWord,variDword,variInt64,
              variR,variSingle,variDouble,
              variSingleComp,variDoubleComp,variExtComp,
              variB,variANSIstring: stX:= stX+Istr(adV)+' u='+Istr(numUnitVar);
              variC:                stX:= stX+Istr(adVc)+' u='+Istr(numUnitVar1) +'  l='+Istr(longC);

              variLocI,variLocL,variLocByte,variLocShort,variLocWord,variLocDword,variLocInt64,
              variLocR,variLocSingle,variLocDouble,
              variLocSingleComp,variLocDoubleComp,variLocExtComp,
              variLocB,refAbs,
              variLocANSIstring: stX:=stX+Istr(dep);

              variLocC:  stX:=stX+Istr(dep)+' l='+Istr(longC);


              variDef:               stX:=stX+'  ad='+Istr(adDef)+'  sz='+Istr(sz)+'  Unit='+Istr(NumUnitDef);
              variLocDef,refLocDef:  stX:=stX+'  dep='+Istr(DepDef)+'  sz='+Istr(sz1);

              procU,foncU: stX:=stX+Istr(intG(adU));
              tableCase:
                         begin
                           stX:=stX+Istr(nbcase)+' '+Istr(depElse)+' '+Istr(depFinCase);
                           plex2:=Plex1;
                           inc(intG(plex2),13);
                           for j:=1 to nbcase do
                             begin
                               stX:=stX+'/'+Istr(plongint(plex2)^);
                               inc(intG(plex2),4);
                               stX:=stX+'-'+Istr(plongint(plex2)^);
                               inc(intG(plex2),4);
                               stX:=stX+'-'+Istr(plongint(plex2)^);
                               inc(intG(plex2),4);
                               stX:=stX+'-'+Istr(plongint(plex2)^);
                               inc(intG(plex2),4);
                             end;
                         end;
              variObject:stX:=stX+Istr(ord(vob))+' '+Istr(adOb);

              TPobjectInd:stX:=stX+Istr(depTPO);

              andBI,orBI: stX:=stX+' '+Istr(depLog);
              CV:         stX:=stX+' Dep='+Istr(CVdep)+' Sz='+Istr(CVsz)+' tp='+ tpNumName[CVtp];
              CVObj:      stX:=stX+' '+Istr(CVdep1)+' '+tpNumName[CVtp1]+'  '+Istr(ord(cvo));

              motArray:   begin
                             stX:=stX+' MAnbR='+Istr(MAnbr)+' MAsize='+Istr(MAsize);
                             for j:=1 to MAnbr do stX:=stX+'  '+Istr(MA[j].mini)+'/'+Istr(MA[j].maxi);
                          end;
              tpInd: stX:=stX+'  depInd='+Istr(depInd)+' tpInd1='+ tpNumName[tpInd1]+'  szInd='+Istr(szInd) ;

        end;
      end;
      ViewText.memo1.lines.add(stX);

      Plex1:=UlexSuivant(Plex1);
    until {(Plex1^.genre=finFich) or} (intG(plex1)>=intG(pfin));

    ViewText.showModal;

    ViewText.free;
  end;


procedure TpgContext.DisplayAdList;
var
  ListGViewer: TListGViewer;
begin
   ListGViewer:=TListGViewer.create(nil);
   with ListGViewer do
   begin
     setdata('Ad list', getAdListData,Adlist.Count);
     showModal;
   end;
   ListGViewer.free;
end;

function TpgContext.getAdListData(n: integer): AnsiString;
begin
  if (n>=0) and (n<adList.Count) then
    with PAdListRecord(adList[n])^ do
    result:=Istr1(ad,10)+Istr1(num,10)
  else result:='';
end;

procedure TpgContext.DisplayUList;
var
  ListGViewer: TListGViewer;
begin
   ListGViewer:=TListGViewer.create(nil);
   with ListGViewer do
   begin
     setdata('Ulist ',getUListData,Ulist.Count);
     showModal;
   end;
   ListGViewer.free;
end;

function TpgContext.getUListData(n: integer): AnsiString;
var
  stF:string;
begin
  if (n>=0) and (n<UList.Count) then
    with PUlistRecord(UList[n])^ do
    begin
      result:=Istr1(ad,10)+Istr1(num,10);
      if (num>=0) and (num<UsesList.Count)
        then stF:= FindProjectFile(UsesList[num])
        else stF:='?';
      result:= result+'   '+stF;
    end
  else result:='';
end;




procedure TpgContext.ViewProgStat;
var
  p,pfin:ptUlex;
  tb:array[0..255] of integer;
  viewText:TviewText;
  i:integer;
begin
  if cs=nil then exit;

  fillchar(tb,sizeof(tb),0);
  p:=cs;
  pfin:=cs;
  inc(intG(pfin),codeSize);

  repeat
    inc(tb[ord(p^.genre)]);
    p:=UlexSuivant(p);
  until intG(p)>=intG(pfin);

//  SaveArrayAsDac2File(debugPath+ 'StatPg.dat',tb,256,G_longint);
  viewText:=TviewText.create(nil);
  ViewText.caption:='Pg2 Stat';

  ViewText.memo1.clear;
  with ViewText.memo1.lines do
  begin
    add('Program compiled');
    add('Code size = '+Istr(codeSize));
    add('Data size = '+Istr(dataSize));
    add('Symbol size = '+Istr(TableSymbole.TableSize));
    add('Object count='+Istr(TableSymbole.objectCount));
    add('Symbol count='+Istr(TableSymbole.Count));
    add('Line list count='+Istr(AdList.count));
    add('');
    for i:=0 to 255 do
    if tb[i]>0 then
      add(nomlex(typelex(i))+ ' = '+Istr(tb[i]));
  end;
  ViewText.showModal;
  ViewText.free;
end;

procedure TpgContext.InitTables;
var
  i:integer;
  pgc:TpgContext;
begin
  tableSymbole.tables[0]:=tableSymbole;
  for i:=0 to usesList.count-1 do
  begin
    pgc:=TpgContext(usesList.objects[i]);
    tableSymbole.tables[i+1]:=pgc.tableSymbole;
    TpgContext(usesList.objects[i]).InitTables;
  end;
end;


function BlockListCompare(Item1, Item2: Pointer): Integer;
begin
  result:= intG(Item1)-intG(Item2);
end;

procedure TpgContext.InitBlockList;
var
  i:integer;
begin
  BlockList.clear;
  tableSymbole.GetProcList(BlockList);

  if PlexTrait>=0 then BlockList.add(pointer(PlexTrait));
  if PlexInit>=0 then BlockList.add(pointer(PlexInit));
  if PlexFin>=0 then BlockList.add(pointer(PlexFin));
  if PlexInit0>=0 then BlockList.add(pointer(PlexInit0));
  if PlexCont>=0 then BlockList.add(pointer(PlexCont));

  with PlexProgram do
    for i:=0 to count-1 do BlockList.add( objects[i]);

  BlockList.Add(pointer(CodeSize));

  BlockList.sort(BlockListCompare);
end;



procedure TpgContext.GetBlockInfo(ad: integer; var ProcAd, NumProg: integer);
var
  i,res: integer;
begin
  ProcAd:=-1;
  NumProg:=-1;

  with BlockList do
  for i:=0 to count-2 do
  if (intG(items[i])<=ad) and (ad<intG(items[i+1])) then
  begin
    ProcAd:=intG(items[i]);
    break;
  end;
  if ProcAd>=0 then exit;


  with PlexProgram do
  for i:=0 to count-1 do
    if intG(objects[i])=ad then
    begin
      NumProg:=i+1;
      break;
    end;

  if (PlexTrait=ad) then NumProg:=101
  else
  if (PlexInit=ad)  then NumProg:=102
  else
  if (PlexFin=ad)   then NumProg:=103
  else
  if (PlexInit0=ad) then NumProg:=104
  else
  if (PlexCont=ad) then NumProg:=105;
end;

function TpgContext.getSymboleFileName(Pdef: PdefSymbole): string;
begin
  if Pdef^.UnitNum=0 then result:=txtFileName
  else
  if (Pdef^.UnitNum>0) and ( Pdef^.UnitNum<=UsesList.Count) then
    result:= FindProjectFile( UsesList[Pdef^.UnitNum-1] );
end;

function TpgContext.getSymboleInfo(Pdef: PdefSymbole): string;
var
  stf:AnsiString;
begin
  result:= TableSymbole.getSymboleInfo(Pdef,objNameList);

  stF:=getSymboleFileName(Pdef);
  stf:=extractFileName(stF);

  result:=result+' - '+stf+'('+Istr(Pdef^.LineNum)+')';

end;

Initialization
AffDebug('Initialization pgc0',0);
  MainUsesList:=Tstringlist.create;
  listeSource:=Tlist.create;
  listeSymbTab:=Tlist.create;
  listePgcU:=TlistG.create(sizeof(TPgcURecord));
  listeDest:=Tlist.create;
  CompHis:=TstringList.create;

finalization
  MainUsesList.free;
  listeSource.free;
  listePgcU.free;
  listeDest.free;
  compHis.free;
end.
