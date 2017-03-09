unit ObjFile1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,forms,sysutils,comCtrls,graphics,

     util1,Gdos,Dgraphic,Ddosfich,varconf1, listG,
     Ncdef2,stmDef,stmObj,stmError,stmPg,
     Ocom1,formrec0,ObjFileO,DnDobj1,
     debug0,Dcfg1,
     dacInsp1;



{ Fichiers d'objets

}

const
  ObjectFileId='DAC2 objects';

  DefGenObjFile:AnsiString='*.dat';


type
  {$IFDEF WIN64}
  ToffsetList= class(Tlist)
                protected
                  function Get(Index: Integer): int64;
                  procedure Put(Index: Integer; Item: int64);

                public
                 function add(p: int64): integer;
                 property Items[Index: Integer]: int64 read Get write Put; default;
               end;
  {$ELSE}
  ToffsetList= class(TlistG)
                protected
                  function Get(Index: Integer): int64;
                  procedure Put(Index: Integer; Item: int64);

                public
                 constructor create;
                 function add(p: int64): integer;

                 property Items[Index: Integer]: int64 read Get write Put; default;
               end;
  {$ENDIF}


type
  THeaderObjectFile=
               object
                 id:string[15];
                 size:smallint;      { 18 octets}
                 procedure init;
               end;

  TObjectFile=class(typeUO)

              private
                Hoffset:integer;     {Offset du header }
                Fvalid:boolean;      {indique si les listes sont valides }
                CurPos:integer;      { Numéro de l'objet courant dans la fenêtre commande}



                Numload:integer;    { numéro du prochain objet à charger. Commence à 0 }

                File0:TfileStream;

                FOffsets:TOffsetlist;            { Offsets des objets dans le fichier}
                Fsizes:Tlist;                    { Block sizes : valeurs lues en début de bloc }

                function getFileStream:TfileStream;
                function getBlockOffset(n:integer):int64;
                function getBlockSize(n:integer):int64;
                function getBlockCount:integer;
              public
                fileName:AnsiString;
                FfileSize:int64;

                FileHeader: THeaderObjectFile;


                Command:TobjFileCommand;        {fenêtre de commandes }
                FormRecCom:Tformrec;            {sauvegarde fenêtre}

                stClasses:TstringList;          {listes décrivant les objets }
                stNames:TstringList;            {elles sont mises en place par analyzeFile}

                Owners,MyAds:Tlist;             {Valeurs de Owner et MyAd}

                MainOffsets:Toffsetlist;              {Offsets des objets principaux}

                Fupdate:boolean;
                currentUO:typeUO;               { objet courant }

                error:integer;
                Foptions:TObjectFileRecord;


                property fileStream:TfileStream read getFileStream;
                property BlockOffset[n:integer]:int64 read getBlockOffset;
                property BlockSize[n:integer]:int64 read getBlockSize;
                property BlockCount:integer read getBlockCount;
                procedure FreeFileStream;

                function GopenFile: boolean;
                procedure GcloseFile;
                procedure GnewFile;
                procedure GonChange(node:TtreeNode);

                procedure DisplayInfo;
                procedure DisplayGraph;

                procedure GDragDrop(source:Tobject);
                function GdragOver:boolean;
                function GbeginDrag:boolean;

                procedure updateCommand;
                procedure BuildMainOffsets;
                function analyzeFile(Const FlookForObj: boolean=false): int64;
                function analyzeFile1(posf0:int64):int64;



                constructor create;override;
                destructor destroy;override;

                class function STMClassName:AnsiString;override;
                function initialise(st:AnsiString):boolean;override;

                procedure createFile(st:AnsiString);
                function OpenFile(st:AnsiString;Const FlookForObj: boolean=false): int64;
                procedure close;

                function save(pu:typeUO):int64;

                procedure show(sender:Tobject);override;
                procedure ChooseObject(TUO:TUOclass;var ob:typeUO);

                procedure buildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;
                procedure ProcessMessage(id:integer;source:typeUO;p:pointer);override;

                function load(pu:typeUO; Const Fref:boolean=true):boolean;
                function seek(num:longWord):boolean;

                function loadThisUO(num:integer):typeUO;


                function SearchName(st:AnsiString;numOc:integer;const ShortMode: boolean= True):integer;
                function SearchAndload(st:AnsiString;numOc:integer;pu:typeUO):boolean;
                function SearchCreateAndLoad(st:AnsiString;numOc:integer;UOclass:TUOclass):typeUO;

                function SearchRdataTime(numOc:integer):TdateTime;
                function SearchClass(numOc:integer;UOclass:TUOclass): integer;
                function SearchClassAndload(numOc:integer;pu:typeUO):boolean;

                function CreateOcc(numOc: integer;UOclass: TUOclass): typeUO;overload;
                function CreateOcc(numOc: integer;UOclass: TUOclass; var offs: int64): typeUO;overload;

                function classCount(UOclass:TUOclass): integer;

                function ObjCount:integer;
                function MainObjCount:integer;

                procedure AppendOIblocks(Src: AnsiString; tpF:integer);

                procedure CloseOpenFiles;
                function copy(f2: TobjectFile;num:integer):boolean;

                procedure setFstatus(status: TUOstatus);override;
                procedure setFoptions( options:TObjectFileRecord );

                procedure CreateCommand;
              end;



procedure proTObjectFile_CreateFile(stFile:AnsiString;var pu:typeUO);pascal;
procedure proTObjectFile_OpenFile(stFile:AnsiString;var pu:typeUO);pascal;
procedure proTObjectFile_close(var pu:typeUO);pascal;


procedure proTobjectFile_seek(num:integer;var pu:typeUO);pascal;


procedure proTObjectFile_save(var ob, pu:typeUO);pascal;

procedure proTObjectFile_load(var ob, pu:typeUO);pascal;
function fonctionTObjectFile_load1(var ob, pu:typeUO):boolean;pascal;
function fonctionTObjectFile_SearchAndload(st:AnsiString;numOc:integer;var ob,pu:typeUO):boolean;pascal;
function fonctionTObjectFile_SearchTypeAndload(numOc:integer;var ob,pu:typeUO):boolean;pascal;

procedure proTObjectFile_load_1(var ob:typeUO; SkipDisplay:boolean; var pu:typeUO);pascal;
function fonctionTObjectFile_load1_1(var ob:typeUO; SkipDisplay:boolean; var pu:typeUO ):boolean;pascal;
function fonctionTObjectFile_SearchAndload_1(st:AnsiString;numOc:integer;var ob:typeUO; SkipDisplay:boolean; var pu:typeUO):boolean;pascal;
function fonctionTObjectFile_SearchTypeAndload_1(numOc:integer;var ob:typeUO; skipDisplay:boolean; var pu:typeUO):boolean;pascal;

procedure proTObjectFile_load_2(var ob:typeUO; SkipDisplay,KeepCoo:boolean; var pu:typeUO);pascal;
function fonctionTObjectFile_load1_2(var ob:typeUO; SkipDisplay,KeepCoo:boolean; var pu:typeUO ):boolean;pascal;
function fonctionTObjectFile_SearchAndload_2(st:AnsiString;numOc:integer;var ob:typeUO; SkipDisplay,KeepCoo:boolean; var pu:typeUO):boolean;pascal;
function fonctionTObjectFile_SearchTypeAndload_2(numOc:integer;var ob:typeUO; skipDisplay,KeepCoo:boolean; var pu:typeUO):boolean;pascal;


procedure proTObjectFile_position(n:integer;var pu:typeUO);pascal;
function fonctionTObjectFile_position(var pu:typeUO):integer;pascal;

function AppendObjectFile(st1,st2:AnsiString):boolean;
function fonctionAppendObjectFile(st1,st2:AnsiString):boolean;pascal;
procedure proTobjectFile_AppendOI(Src: AnsiString;var pu:typeUO);pascal;
procedure proTobjectFile_AppendOI_1(Src: AnsiString;tpF: integer; var pu:typeUO);pascal;

procedure proRemoveOIblocks(st1,st2:AnsiString);pascal;

function fonctionTobjectFile_count(var pu:typeUO):integer;pascal;
function fonctionTobjectFile_Objcount(var pu:typeUO):integer;pascal;
function fonctionTobjectFile_MainCount(var pu:typeUO):integer;pascal;


function fonctionTObjectFile_ClassNames(n:integer;var pu:typeUO):AnsiString;pascal;
function fonctionTObjectFile_ObjNames(n:integer;var pu:typeUO):AnsiString;pascal;
function fonctionTObjectFile_ObjOffsets(n:integer;var pu:typeUO):Int64;pascal;
function fonctionTObjectFile_ObjSizes(n:integer;var pu:typeUO):Integer;pascal;

procedure proTobjectFile_Copy(var f2: TobjectFile; num: integer; var pu: typeUO);pascal;

implementation

uses stmDobj1,OIblock1,stmOIseq1, ElphyFormat;

var
  ObjectFiles:Tlist;



procedure THeaderObjectFile.init;
begin
  id:=ObjectFileId;
  size:=sizeof(THeaderObjectFile);
end;



class function TObjectFile.STMClassName:AnsiString;
  begin
    STMClassName:='ObjectFile';
  end;

constructor TObjectFile.create;
begin
  inherited;

  FileHeader.init;

//  Command:=TobjFileCommand.create(formStm);
//  Command.init(self);

  setFoptions(ObjFileDefOptions);

  stClasses:=TstringList.create;
  stNames:=TstringList.create;
  FOffsets:=TOffsetlist.create;
  FSizes:=Tlist.create;

  MainOffsets:=Toffsetlist.create;
  Owners:=Tlist.create;
  MyAds:=Tlist.create;

  curPos:=-1;

  objectFiles.Add(self);
end;

destructor TObjectFile.destroy;
begin
  close;

  Fupdate:=true;
  command.free;

  stClasses.free;
  stNames.free;
  FOffsets.free;
  Fsizes.free;
  MainOffsets.free;

  Owners.free;
  myAds.Free;

  file0.Free;

  objectFiles.Remove(self);

  if Fstatus=UO_main then MainObjFileList.remove(self);
  inherited;
end;

procedure TobjectFile.CreateCommand;
begin
  if not assigned(Command) then
  begin
    Command:=TobjFileCommand.create(formStm);
    Command.init(self);
    updateCommand;
  end;
end;

procedure TObjectFile.close;
var
  f:TfileStream;
begin
  freeFileStream;
  if fileName<>'' then
    begin
      f:=nil;
      try
      f:=TfileStream.create(fileName,fmOpenRead);
      if f.size=sizeof(fileHeader) then
      begin
        f.Free;
        f:=nil;
        deletefile(fileName);
      end;

      finally
      f.Free;
      end;
    end;
  fileName:='';
  Fvalid:=false;

  if assigned(command) then command.Caption:=Ident;
end;

procedure TObjectFile.createFile(st:AnsiString);
var
  f:TfileStream;
begin
  GcloseFile;

  try
  f:=TfileStream.Create(st,fmCreate);
  f.Write(FileHeader,sizeof(FileHeader));
  f.Free;
  except
  error:=99;
  end;

  if error=0 then fileName:=st;
  NumLoad:=0;
  Fvalid:=false;
end;

function TObjectFile.OpenFile(st:AnsiString;Const FlookForObj: boolean=false):int64;
var
  header:THeaderObjectFile;
  f:TfileStream;
begin
  GcloseFile;

  TRY
    Try
      try
        f:=TfileStream.create(st,fmOpenRead);
      except
        closeOpenFiles;
        f:=TfileStream.create(st,fmOpenRead);
      end;
      header.id:='';
      f.Read(header,sizeof(THeaderObjectFile));
      FfileSize:=f.Size;
    finally
      f.Free;
    end;

    if (header.id=ObjectFileId) then Hoffset:=header.size
    else
    if (header.id='DAC2') then
      begin
        allouerCfg1(10);
        error:=lirecfg1(st);
        resetCfg1;
        Hoffset:=EndCfgOffset;
      end
    else error:=1;
  except
     error:=99;
  end;

  if error=0
    then fileName:=st
    else close;

  if error=0 then result:=AnalyzeFile( FlookForObj);
  NumLoad:=0;

  if assigned(command) then command.Caption:=Ident+' : '+fileName;
end;


procedure TObjectFile.updateCommand;
type
  Tprof=record
          ad,nd:pointer;
        end;
var
  i,j:integer;
  prof:array[1..100] of Tprof;
  nbProf:integer;
  IP:integer;
  ad1,owner1:pointer;
  node1:TtreeNode;

begin
  if not assigned(command) then exit;

  NbProf:=0;
  fillchar(prof,sizeof(prof),0);

  Fupdate:=true;

  with command.treeView1 do
  begin
    items.clear;
    items.BeginUpDate;
    for i:=0 to stNames.count-1 do
      if (stClasses[i]<>'RDATA') and (stClasses[i]<>'RSOUND') then
      begin
        ad1:=myads[i];
        owner1:=owners[i];

        affdebug(Istr1(longWord(ad1),10)+Istr1(intG(owner1),10)+'   '+stNames[i] ,13);
        IP:=0;
        if owner1<>nil then
          for j:=nbprof downto 1 do
            if owner1 = prof[j].ad
              then IP:=j;

        if IP<>0
          then node1:=items.addChildObject(prof[IP].nd,stnames[i],pointer(i))
          else node1:=items.addChildObject(nil,stClasses[i]+'/'+stNames[i],pointer(i));

        with Prof[IP+1] do
        begin
          ad:=ad1;
          nd:=node1;
        end;
        nbProf:=IP+1;
      end;
    items.EndUpDate;
  end;

  Fupdate:=false;
end;


procedure TObjectFile.BuildMainOffsets;
type
  Tprof=record
          ad,nd:pointer;
        end;
var
  i,j:integer;
  prof:array[1..100] of Tprof;
  nbProf:integer;
  IP:integer;
  ad1,owner1:pointer;

begin
  MainOffsets.clear;
  NbProf:=0;
  fillchar(prof,sizeof(prof),0);

  for i:=0 to stNames.count-1 do
    begin
      ad1:=myads[i];
      owner1:=owners[i];

      IP:=0;
      if owner1<>nil then
        for j:=nbprof downto 1 do
          if owner1 = prof[j].ad
            then IP:=j;

      if IP=0 then MainOffsets.Add(FOffsets[i]);

      with Prof[IP+1] do
      begin
        ad:=ad1;
        nd:=nil;
      end;
      nbProf:=IP+1;
    end;

end;


procedure LookForObject1(f:TfileStream;var posf:int64);
var
  st:string;
  sz:integer;
  p:integer;
  stName:string;
begin
  while (posf<f.Size) do
  begin
    if f.Size-posf>100000
      then sz:= 100000
      else sz:= f.Size-posf;

    setlength(st,sz);
    f.Position:=posf;
    f.Read(st[1],sz);

    p:=FindUOclassName(st,stName);
    if (p>0) and (stName<>'RF') then
    begin
      posf:=posf+p-6;
      f.Position:=posf;
      exit;
    end;

    posf:=posf+100000-40;
  end;

end;


function TObjectFile.analyzeFile(Const FlookForObj: boolean= false): int64;
var
  posf:int64;
  size:LongWord;
  stmName:AnsiString;
  ok:boolean;
  conf:TblocConf;

  OldIdent0:string[30];
  Ident0: AnsiString;

  Fchild0:boolean;
  myAd0:pointer;
  stComment0:AnsiString;

  {Dans les vieux fichiers, le bloc data ne contenait pas une valeur Size correcte.
  Inf0 et oldInf servent seulement à corriger cette taille
  }

  inf0:TinfoDataObj;
  oldInf:ToldinfoDataObj;
  nextDataSize:integer;
  lastStmName:AnsiString;

  sizeConf:integer;
  owner1:typeUO;
  cnt:integer;

procedure LookForObject;
var
  p:typeUO;
begin
  p:=nil;

  while (posf<fileStream.size) and not assigned(p) do
  begin
    fileStream.Position:=posf;
    stmName:=readHeader(fileStream,size);           {lire l'entête}
    p:=createUO(stmName,false);
    //if not (p is TSeqBlock) then
    if not assigned(p) then
    begin
      posf:=posf+1;
      if assigned(p) then p.Free;
      p:=nil;
    end;
  end;
  if assigned(p) then p.Free;

end;

begin
  stClasses.clear;
  stNames.clear;
  FOffsets.clear;
  Fsizes.clear;

  Owners.clear;
  MyAds.Clear;

  posf:=Hoffset;

  result:=0;

  if assigned(fileStream) then
  TRY
  result:=fileStream.Size;

   if FlookForObj then LookForObject;

  cnt:=0;
  size:=1;
  nextdataSize:=0;
  while (posf<fileStream.size) and (size<>0) and not testEscape {and (cnt<453)} do
  begin
    fileStream.Position:=posf;
    stmName:=readHeader(fileStream,size);           {lire l'entête}

    {messageCentral(stmName+'#'+' '+Istr(size)+' '+Istr(posf));}

    if (stmName='') then
      begin
        //fileStream.Position:=posf;
        //LookForObject;
        posf:=fileStream.Size;
        size:=0;
      end
    else
    if stmName='DATA' then
      begin
        if (size=sizeof(TdataHeader)) then
          begin
            if (lastStmName='Vector') or
               (lastStmName='Psth') or
               (lastStmName='Correlogram') then
                 with inf0 do size:=size+tailleTypeG[tpNum]*(Imax-Imin+1)

            else
            if (lastStmName='Matrix') or
               (lastStmName='Jpsth') or
               (lastStmName='2DCorre') then
                 with inf0 do size:=size+tailleTypeG[tpNum]*(Imax-Imin+1)*(Jmax-Jmin+1);
            {messageCentral(lastStmName+' '+Istr(size));}
          end;

        if (lastStmName='MatFitting') and (inf0.tpNum=G_smallint)
          then size:=10+(size-10)*10 div 2;

      end
    else
    if {(stmClass(stmName)<>nil) and }(stmName<>'') and (size<>0) then
      begin
        ident0:='';
        OldIdent0:='';
        stComment0:='';
        fillchar(inf0,sizeof(inf0),0);
        fillchar(oldinf,sizeof(oldinf),0);
        owner1:=nil;
        myAd0:=nil;
        Fchild0:=false;

        if (stmName='RDATA') or (stmName='RSOUND') then
        begin
          ok:=true;
        end
        else
        begin
          conf:=TblocConf.create(stmName);
          with conf do
          begin
            setvarConf('IDENT',Oldident0,sizeof(Oldident0));
            setStringConf('IDENT1',ident0);
            setvarConf('MYAD',myAd0,sizeof(myAd0));
            setvarConf('FCHILD',Fchild0,sizeof(Fchild0));
            setStringConf('COM',stComment0);
            setVarConf('OBJINF',inf0,sizeof(inf0));
            setvarconf('INF',oldinf,sizeof(oldinf));
            setvarconf('OWNER',owner1,sizeof(owner1));
          end;
          if size>1000
            then sizeConf:=1000
            else sizeConf:=size;
          ok:=(conf.lire1(fileStream,sizeConf)=0);
          conf.free;
        end;

        if ok then
          begin
            if ident0='' then ident0:=OldIdent0;

            if (oldInf.imin<>0) or (oldInf.imax<>0) then
            with inf0 do
            begin
              tpNum:=oldInf.tpNum;
              imin:=oldInf.imin;
              imax:=oldInf.imax;
              jmin:=oldInf.jmin;
              jmax:=oldInf.jmax;
            end;

            stclasses.add(stmName);
            stNames.add(ident0);
            FOffsets.add(posf);
            Fsizes.add(pointer(size));

            myAds.add(myAd0);
            if Fchild0
              then owners.add(owner1)
              else owners.add(nil);
            nextDataSize:=inf0.dataSize;
            lastStmName:=stmName;
          end;
      end;
    if FlookForObj then
    begin
      posf:=posf+10;                     //
      LookForObject1(fileStream,posf);   // DEBUG ONLY
    end
    else posf:=int64(posf)+size;         // A remplacer par les deux lignes qui suivent pour rechercher les mots-clés

    inc(cnt);
  end;

  Fvalid:=true;
  curPos:=-1;
  UpdateCommand;

  EXCEPT
  freeFileStream;
  curPos:=-1;
  UpdateCommand;
  END;

  BuildMainOffsets;
end;

function TObjectFile.analyzeFile1(posf0:int64):int64;
var
  size:LongWord;
  posf:int64;
  stmName:AnsiString;
  ok:boolean;
  conf:TblocConf;

  OldIdent0:string[30];
  Ident0: AnsiString;

  Fchild0:boolean;
  myAd0:pointer;
  stComment0:AnsiString;

  sizeConf:integer;
  owner1:typeUO;
begin
  posf:=posf0;
  result:=0;

  if assigned(fileStream) then
  TRY
  fileStream.Position:= posf0;
  result:=fileStream.Size;

  size:=1;
  while (posf<fileStream.size) and (size<>0) do
  begin
    fileStream.Position:=posf;
    stmName:=readHeader(fileStream,size);           {lire l'entête}

    {messageCentral(stmName+'#'+' '+Istr(size)+' '+Istr(posf));}

    if stmName='' then
      begin
        posf:=fileStream.size;
        size:=0;
      end
    else
    if (stmName<>'') and (stmName<>'DATA') and (size<>0) then
      begin
        ident0:='';
        OldIdent0:='';
        owner1:=nil;

        conf:=TblocConf.create(stmName);
        with conf do
        begin
          setvarConf('IDENT',Oldident0,sizeof(Oldident0));
          setStringConf('IDENT1',ident0);
          setvarConf('MYAD',myAd0,sizeof(myAd0));
          setvarConf('FCHILD',Fchild0,sizeof(Fchild0));
          setvarconf('OWNER',owner1,sizeof(owner1));
        end;
        if size>1000
          then sizeConf:=1000
          else sizeConf:=size;
        ok:=(conf.lire1(fileStream,sizeConf)=0);
        conf.free;

        if ok then
          begin
            if Ident0='' then Ident0:=OldIdent0;
            stclasses.add(stmName);
            stNames.add(ident0);
            FOffsets.add(posf);
            Fsizes.add(pointer(size));

            myAds.add(myAd0);

            if Fchild0
              then owners.add(owner1)
              else owners.add(nil);
          end;
      end;
    inc(posf,size);
  end;

  Fvalid:=true;
  curPos:=-1;
  UpdateCommand;

  EXCEPT
  freeFileStream;
  curPos:=-1;
  UpdateCommand;
  END;

  BuildMainOffsets;
end;


function TObjectFile.GopenFile: boolean;
var
  st:AnsiString;
begin
  result:= false;
  st:=fileName;
  if st='' then st:=DefGenObjFile;
  st:=GchooseFile('Open an object file',st);
  if st='' then exit;

  defGenObjFile:=st;
  openFile(st);
  result:=true;
end;


procedure TObjectFile.GnewFile;
var
  st:AnsiString;
begin
  st:=GsaveFile('New object file',extractFilePath(fileName),'oac');
  if st='' then exit;

  createFile(st);
end;

procedure TObjectFile.GcloseFile;
begin
  close;

  stClasses.clear;
  stNames.clear;
  FOffsets.clear;
  Fsizes.clear;

  MainOffsets.clear;
  Owners.Clear;
  myAds.clear;

  curPos:=-1;
  currentUO.free;
  currentUO:=nil;
  if assigned(command) then
  begin
    command.UOdisplay1.Uplot:=currentUO;
    updateCommand;
    command.UOdisplay1.invalidate;
    command.memo1.clear;
  end;  
end;

procedure TObjectFile.DisplayInfo;
var
  oldName:AnsiString;
begin
  with command.memo1 do
  begin
    clear;
    text:=Istr(curPos)+':  ';

    if assigned(CurrentUO) then
      begin
        oldName:=currentUO.ident;
        currentUO.ident:=stNames[curPos];
        text:=text+currentUO.getInfo;
        currentUO.ident:=oldName;
      end
    else text:=text+'currentUO=nil';
  end;
end;

procedure TObjectFile.DisplayGraph;
begin
    if Foptions.FdisplayGraph and assigned(currentUO)
      then currentUO.display;
end;


procedure TObjectFile.GonChange(node:TtreeNode);
var
  num:integer;
  ok:boolean;

  i:integer;
  st:AnsiString;

begin
  if Fupdate then exit;

  if not Fvalid then analyzeFile;

  if assigned(node) then num:=intG(node.data)
  else
  if stClasses.count>0 then num:=0
  else num:=-1;

  if assigned(fileStream) and (num<>CurPos)then
    begin
      ok:=true;

      TRY
      curPos:=num;
      if (Foptions.FdisplayInfo or  Foptions.FdisplayGraph) and
         (curPos>=0) and (curPos<stClasses.count) then
        begin
          fileStream.Position:=FOffsets[curPos];

          currentUO.free;

          FlagObjectFile:=true;
          currentUO:=readAndCreateUO(fileStream,UO_main,false,true);
          FlagObjectFile:=false;

          if assigned(currentUO) then
            with currentUO do
            begin
              {ident:=self.ident+'_CurrentUO';}
              notPublished:=true;

              clearReferences;
              resetMyAd;
              setChildNames;

              UOowner:=self;
            end
          else ok:=false;

          if Foptions.FdisplayInfo then DisplayInfo;
          command.UOdisplay1.Uplot:=currentUO;
          command.UOdisplay1.invalidate;
          curPos:=num;
        end;

      EXCEPT
      freeFileStream
      END;
    end;

  {if not ok then analyzeFile;}

end;

function TObjectFile.GdragOver:boolean;
begin
  if not Fvalid then analyzeFile;

  result:=(DragUOsource is TstmInspector)
           OR
          (DragUOsource is TobjectFile) and (DragUOsource<>self);
end;

procedure TObjectFile.GDragDrop(source:Tobject);
var
  pu:typeUO;
  st:AnsiString;
  posf: int64;
begin
   if not Fvalid then analyzeFile;

   pu:=DraggedUO;
   resetDragUO;
   if not assigned(pu) then exit;

   st:=pu.stComment;

   if DragAndDropObject.execution(pu.ident,st) then
     begin
       pu.stComment:=st;
       posf:=save(pu);
       analyzeFile1(posf);
     end;
end;

function TObjectFile.GbeginDrag:boolean;
begin
  DragUOsource:=self;
  DraggedUO:=currentUO;
end;

procedure TObjectFile.show(sender:Tobject);
begin
  if not Fvalid then analyzeFile;
  CreateCommand;
  command.PanelBottom.Visible:=false;
  command.show;
end;

procedure TObjectFile.ChooseObject(TUO:TUOclass;var ob:typeUO);
begin
  GopenFile;
  if filename<>'' then
  begin
    createCommand;
    command.chooseObject(TUO,ob);
  end;
end;


procedure TObjectFile.buildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildinfo(conf,lecture,tout);

  if not lecture then
    if assigned(command) then FontToDesc(command.panel1.font,Foptions.FontRec);

  formRecCom.setForm(Command);
  with conf do
  begin
    setStringConf('FileName',fileName);
    setvarconf('FormRecC',FormRecCom,sizeof(FormRecCom));
    setvarconf('Foptions',Foptions,sizeof(Foptions));
  end;
end;

procedure TobjectFile.setFoptions( options: TObjectFileRecord );
begin
  Foptions:=options;
  if assigned(command) then
  with Command do
  begin
    DescToFont(Foptions.FontRec,Panel1.font);
    Panel1.color:=Foptions.color;
    invalidate;
  end;
end;

procedure TObjectFile.completeLoadInfo;
var
  stPgc:AnsiString;
begin
  inherited;

  formRecCom.restoreForm(Tform(Command),nil);

  if assigned(command) then command.caption:=ident+' '+fileName;
  setFoptions(Foptions) ;

  if (fileName<>'') then
  begin
    if FichierExiste(fileName)
      then openFile(fileName)
      else createFile(fileName);
  end;
end;

function TObjectFile.initialise(st:AnsiString):boolean;
begin
  result:=inherited initialise(st);
  if assigned(command)
    then Command.caption:=ident+' '+fileName;
end;

function TObjectFile.save(pu:typeUO): int64;
begin
  if assigned(fileStream) then
  try
    result:=fileStream.size;
    filestream.Position:= result;
//    fileStream.Seek(result,soFromBeginning);   Ne pas utiliser Seek
    pu.saveToStream(fileStream,true);
  except
    freeFileStream;
    result:=-1;
  end;
  Fvalid:=false;
end;

function TObjectFile.load(pu:typeUO; Const Fref:boolean=true):boolean;
begin
  result:=false;
  if not assigned(fileStream) or not assigned(pu) then exit;

  if not Fvalid then analyzeFile;
  if numLoad>=MainOffsets.count then exit;

  TRY
    fileStream.Position:= Mainoffsets[numLoad];
    result:=pu.loadX(fileStream,Fref);

    inc(NumLoad);
  EXCEPT
    freeFileStream;
  END;

end;

function TObjectFile.loadThisUO(num:integer):typeUO;
var
  UOclass: TUOclass;
begin
  result:=nil;
  if not assigned(fileStream) then exit;
  if not Fvalid then analyzeFile;

  if (num<0) or (num>=stNames.Count) then exit;

  TRY
    fileStream.Position:= Foffsets[num];
    UOclass:=stmClass(stClasses[num]);
    result:=UOclass.create;
    if assigned(result) then
      if not result.loadX(fileStream) then result.free;

  EXCEPT
    result.free;
    result:=nil;
    freeFileStream;
  END;

end;


function TobjectFile.seek(num:longWord):boolean;
begin
  if not Fvalid then analyzeFile;
  if (num>=1) and (num<=Mainoffsets.count)
    then NumLoad:=num-1;
end;


procedure TObjectFile.ProcessMessage(id: integer; source: typeUO;
  p: pointer);
begin
  inherited;
  if assigned(command) then command.UODisplay1.processMessage(id,source,p);
end;

function ShortName(st:string):string;
var
  k:integer;
begin
  repeat
    k:= pos('.',st);
    if k>0 then delete(st,1,k);
  until k=0;
  result:= Fmaj(st);
end;

function TObjectFile.SearchName(st: AnsiString;numOc:integer;const ShortMode: boolean= True): integer;
var
  i:integer;
  st1:AnsiString;
  num:integer;
begin
  result:=-1;
  if ShortMode
    then st:=ShortName(st)
    else st:=Fmaj(st);
  num:=0;

  if NumOc>0 then
  for i:=0 to stNames.count-1 do
  begin
    if ShortMode
      then st1:=ShortName(stNames[i])
      else st1:=Fmaj(stNames[i]);

    if st=st1 then
    begin
      inc(num);
      if num=numOc then
      begin
        result:=i;
        exit;
      end;
    end;
  end
  else
  begin               // si NumOc<0 , on commence par la fin
    NumOc:=-NumOc;
    for i:=stNames.count-1 downto 0 do
    begin
      if ShortMode
        then st1:=ShortName(stNames[i])
        else st1:=Fmaj(stNames[i]);

      if st=st1 then
      begin
        inc(num);
        if num=numOc then
        begin
          result:=i;
          exit;
        end;
      end;
    end
  end;
end;


function TObjectFile.SearchAndload(st:AnsiString;numOc:integer;pu:typeUO):boolean;
var
  num:integer;
begin
  result:=false;
  if not assigned(fileStream) or not assigned(pu) then exit;

  if not Fvalid then analyzeFile;

  if st='' then st:=pu.ident;
  num:=searchName(st,numOc);

  if num<0 then exit;

  TRY
    fileStream.Position:=FOffsets[num];           { Offsets généraux}
    result:=pu.loadX(fileStream);
  EXCEPT
    freeFileStream;
  END;
end;

function TObjectFile.SearchRdataTime(numOc:integer):TdateTime;
var
  num:integer;
  pu: TRdataBlock;
begin
  result:=0;
  if not assigned(fileStream) or not assigned(pu) then exit;

  if not Fvalid then analyzeFile;

  num:=searchName('RDATA',numOc);

  if num<0 then exit;

  pu:=TRdataBlock.create;
  TRY
    fileStream.Position:=FOffsets[num];           { Offsets généraux}

    if pu.loadFromStream(fileStream,0,false) then result:=pu.Stime;
  EXCEPT
  END;
  pu.Free;
end;


function TObjectFile.SearchCreateAndLoad(st: AnsiString; numOc: integer;UOclass: TUOclass): typeUO;
var
  num:integer;
  ok:boolean;
begin
  result:=nil;
  if not assigned(fileStream)  then exit;

  if not Fvalid then analyzeFile;

  num:=searchName(st,numOc);
  if num<0 then exit;

  result:=UOclass.create;
  TRY
    fileStream.Position:=FOffsets[num];           { Offsets généraux}
    ok:=result.loadX(fileStream);
  EXCEPT
    freeFileStream;
  END;

  if not ok then
  begin
    result.free;
    result:=nil;
  end;
end;

function TObjectFile.SearchClass(numOc:integer;UOclass:TUOclass): integer;
var
  i:integer;
  stC,st1:AnsiString;
  num:integer;
begin
  result:=-1;
  stC:=Fmaj(UOclass.stmClassName);
  num:=0;

  if NumOc>0 then
  for i:=0 to stClasses.count-1 do
  begin
    st1:=Fmaj(stClasses[i]);

    if stC=st1 then
    begin
      inc(num);
      if num=numOc then
      begin
        result:=i;
        exit;
      end;
    end;
  end
  else
  begin
    NumOc:=-NumOc;
    for i:= stClasses.count-1 downto 0 do
    begin
      st1:=Fmaj(stClasses[i]);

      if stC=st1 then
      begin
        inc(num);
        if num=numOc then
        begin
          result:=i;
          exit;
        end;
      end;
    end;
  end;

end;

function TObjectFile.SearchClassAndload(numOc:integer;pu:typeUO):boolean;
var
  num:integer;
begin
  result:=false;
  if (fileName='') or not assigned(pu) then exit;

  if not Fvalid then analyzeFile;

  num:=searchClass(numOc,TUOclass(pu.classtype));

  if num<0 then exit;

  TRY
    fileStream.Position:=FOffsets[num];           { Offsets généraux}
    result:=pu.loadX(fileStream);
  EXCEPT
    freeFileStream;
  END;
end;


function TObjectFile.CreateOcc(numOc: integer;UOclass: TUOclass): typeUO;
var
  num:integer;
  ok:boolean;
begin
  result:=nil;
  if not assigned(fileStream)  then exit;

  if not Fvalid then analyzeFile;

  num:=searchClass(numOc,UOclass);
  if num<0 then exit;

  result:=UOclass.create;
  TRY
    fileStream.Position:=FOffsets[num];           { Offsets généraux}
    ok:=result.loadX(fileStream);
  EXCEPT
    freeFileStream;
  END;

  if not ok then
  begin
    result.free;
    result:=nil;
  end;
end;

function TObjectFile.CreateOcc(numOc: integer;UOclass: TUOclass; var offs: int64): typeUO;
var
  num:integer;
  ok:boolean;
begin
  result:=nil;
  if not assigned(fileStream)  then exit;

  if not Fvalid then analyzeFile;

  num:=searchClass(numOc,UOclass);
  if num<0 then exit;

  result:=UOclass.create;
  TRY
    fileStream.Position:=FOffsets[num];           { Offsets généraux}
    ok:=result.loadX(fileStream);
    offs:=FOffsets[num];
  EXCEPT
    freeFileStream;
  END;

  if not ok then
  begin
    result.free;
    result:=nil;
  end;
end;



function TObjectFile.ClassCount(UOclass:TUOclass): integer;
var
  i:integer;
  stC:AnsiString;
begin
  result:=0;
  stC:=Fmaj(UOclass.stmClassName);

  for i:=0 to stClasses.count-1 do
  begin
    if stC=Fmaj(stClasses[i]) then inc(result);
  end;
end;



function TObjectFile.ObjCount: integer;
begin
  result:=stClasses.count;
end;

function TObjectFile.MainObjCount: integer;
begin
  result:=MainOffsets.count;
end;


{ copie les objets de st2 à la fin de st1
  on se contente d'enlever le header de st2 et de copier tout le reste
  à la fin de st1
}

function AppendObjectFile(st1,st2:AnsiString):boolean;
var
  f1,f2:TfileStream;
  header1,header2: THeaderObjectFile;
begin
  result:=true;
  try
  try
    fillchar(header1,sizeof(header1),0);
    f1:=TfileStream.Create(st1,fmOpenReadWrite);
    f1.Read(header1,sizeof(header1));

    fillchar(header2,sizeof(header2),0);
    f2:=TfileStream.Create(st2,fmOpenRead);
    f2.Read(header2,sizeof(header2));

    if (header1.id=ObjectFileId) and (header2.id=ObjectFileId) then
    begin
      f1.Position:=f1.size;
      f2.Position:=header2.size;
      f1.CopyFrom(f2, f2.size-header2.size);
    end;
  finally
    f1.Free;
    f2.Free;
  end;

  except
  result:=false;
  end;

end;

function TObjectFile.getFileStream: TfileStream;
begin
  if not assigned(file0) then
    try
      file0:=TfileStream.create(fileName,fmOpenReadWrite);
    except
      CloseOpenFiles;
      try
        file0:=TfileStream.create(fileName,fmOpenReadWrite);
      except
        try
          file0:=TfileStream.create(fileName,fmOpenRead);
        except
          file0:=nil;
        end;
      end;
    end;

  result:=file0;
end;

procedure TObjectFile.FreeFileStream;
begin
  file0.free;
  file0:=nil;
end;


{ Critère de tri:
  on suppose que les noms de fichier se terminent par un numéro
  exemple data123-12  (N=12) ou encore data32BETA25 (N=25)

  on extrait les derniers chiffres et on classe suivant les numéros croissants.
}

function CompareFiles(List: TStringList; Index1, Index2: Integer): Integer; {-1 si i1 précède i2}
var
  st1,st2:AnsiString;
  i:integer;
  i1,i2,code1,code2:integer;
Const
  digits=['0'..'9'];

begin
  st1:=list[index1];
  st2:=list[index2];

  i:=pos('.',st1);
  if i>0 then delete(st1,i,100);


  i:=length(st1);
  while (i>0) and (st1[i] in digits) do dec(i);
  if i>0 then delete(st1,1,i);
  val(st1,index1,code1);

  i:=pos('.',st2);
  if i>0 then delete(st2,i,100);

  i:=length(st2);
  while (i>0) and (st2[i] in digits) do dec(i);
  if i>0 then delete(st2,1,i);
  val(st2,index2,code2);

  if (code1=0) and (code2=0) then result:=index1-index2
  else result:=0;
end;


procedure TObjectFile.AppendOIblocks(Src: AnsiString; tpF:integer);
var
  files:TstringList;
  searchRec:TsearchRec;
  i:integer;
  stPath:AnsiString;
  oi:ToiBlock;
begin
  stPath:=extractFilePath(src);                      {Analyser le nom générique}
  files:=TstringList.create;
  if findFirst(src,faAnyFile,searchRec)=0 then
  repeat
    files.Add(searchRec.Name);
  until findNext(searchRec)<>0;
  findClose(searchRec);

  files.CustomSort(compareFiles);                    {et trier les noms de fichier}

  oi:=ToiBlock.create;
  TRY
  for i:=0 to files.count-1 do
  begin
    oi.ReadOIfiles(stPath+files[i], tpF);            {Charger les séquences dans OI}
    save(oi);                                        {sauver OI }
  end;
  FINALLY
  files.free;
  oi.free;
  END;
end;

function TObjectFile.copy(f2: TobjectFile;num:integer): boolean;
var
  p: int64;
  sz:longword;
  st:AnsiString;
begin
  result:=false;
  if (fileName='') or not assigned(f2) then exit;

  if not f2.Fvalid then f2.analyzeFile;

  if (num>=0) and (num<f2.ObjCount) then
  try
    fileStream.Position:=fileStream.Size;
    f2.fileStream.Position:=f2.FOffsets[num];
    fileStream.CopyFrom(f2.fileStream,integer(f2.Fsizes[num]));

    if f2.fileStream.Position<f2.fileStream.Size then
    begin
      p:=f2.fileStream.position;
      st:=readHeader(f2.fileStream,sz);
      if st='DATA' then
      begin
        f2.fileStream.Position:= p;
        fileStream.CopyFrom(f2.fileStream,sz);
      end;
    end;
  EXCEPT
    freeFileStream;
  END
  else exit;
  Fvalid:=false;
  result:=true;
end;

procedure TObjectFile.setFstatus(status: TUOstatus);
begin
  inherited;
  if (status=UO_main) and (MainObjFileList.indexof(self)<0)
    then MainObjFileList.add(self);
end;



{****************** Méthodes STM de TObjectFile ****************************}


procedure proTObjectFile_createFile(stFile:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TobjectFile);

  with TobjectFile(pu) do
  begin
    createFile(stFile);
    if fileName='' then
      begin
        proTobject_free(pu);
        sortieErreur('TobjectFile.createFile error ');
      end;

  end;
end;

procedure proTObjectFile_OpenFile(stFile:AnsiString;var pu:typeUO);
begin
  createPgObject('',pu,TobjectFile);

  with TobjectFile(pu) do
  begin
    OpenFile(stFile);
    if fileName='' then
      begin
        proTobject_free(pu);
        sortieErreur('TobjectFile.openFile error ');
      end;
  end;
end;

procedure proTObjectFile_close(var pu:typeUO);
begin
  proTobject_free(pu);
end;

function fonctionTobjectFile_count(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TobjectFile(pu).ObjCount;
end;

function fonctionTobjectFile_Objcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TobjectFile(pu).ObjCount;
end;


function fonctionTobjectFile_Maincount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TobjectFile(pu).MainObjCount;
end;


procedure proTobjectFile_seek(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TobjectFile(pu).seek(num);
end;




procedure proTObjectFile_save(var ob, pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(ob);

  if TobjectFile(pu).save(ob)<0 then sortieErreur('TObjectFile: Write error');
end;


procedure proTObjectFile_load(var ob, pu:typeUO);
var
  ok:boolean;
begin
  verifierObjet(pu);
  verifierObjet(ob);

  ok:=TobjectFile(pu).load(ob);
  if not ok then sortieErreur('TobjectFile.load error ');
end;

procedure proTObjectFile_load_1(var ob:typeUO; SkipDisplay:boolean; var pu:typeUO);
begin
  try
    FDoNotLoadDisplayParams:= skipDisplay;
    proTObjectFile_load(ob, pu);
  finally
    FDoNotLoadDisplayParams:= false;
  end;
end;

procedure proTObjectFile_load_2(var ob:typeUO; SkipDisplay,KeepCoo:boolean; var pu:typeUO);
begin
  try
    FDoNotLoadDisplayParams:= skipDisplay;
    FKeepCoordinates:=KeepCoo;
    proTObjectFile_load(ob, pu);
  finally
    FDoNotLoadDisplayParams:= false;
    FKeepCoordinates:=false;
  end;
end;


function fonctionTObjectFile_load1(var ob, pu:typeUO):boolean;
begin
  verifierObjet(pu);
  verifierObjet(ob);

  result:=TobjectFile(pu).load(ob);
end;

function fonctionTObjectFile_load1_1(var ob:typeUO; SkipDisplay:boolean; var pu:typeUO ):boolean;
begin
  try
    FDoNotLoadDisplayParams:= skipDisplay;
    result:= fonctionTObjectFile_load1(ob, pu);
  finally
    FDoNotLoadDisplayParams:= false;
  end;
end;

function fonctionTObjectFile_load1_2(var ob:typeUO; SkipDisplay,KeepCoo:boolean; var pu:typeUO ):boolean;
begin
  try
    FDoNotLoadDisplayParams:= skipDisplay;
    FKeepCoordinates:=KeepCoo;
    result:= fonctionTObjectFile_load1(ob, pu);
  finally
    FDoNotLoadDisplayParams:= false;
    FKeepCoordinates:=false;
  end;
end;

function fonctionTObjectFile_SearchAndload(st:AnsiString;numOc:integer;var ob,pu:typeUO):boolean;
begin
  verifierObjet(pu);
  verifierObjet(ob);

  result:=TobjectFile(pu).SearchAndload(st,numOc,ob);
end;


function fonctionTObjectFile_SearchAndload_1(st:AnsiString;numOc:integer;var ob: typeUO; SkipDisplay:boolean; var pu:typeUO):boolean;
begin
  try
    FDoNotLoadDisplayParams:= skipDisplay;
    result:= fonctionTObjectFile_SearchAndload(st,numOc,ob,pu);
  finally
    FDoNotLoadDisplayParams:= false;
  end;
end;

function fonctionTObjectFile_SearchAndload_2(st:AnsiString;numOc:integer;var ob: typeUO; SkipDisplay,KeepCoo:boolean; var pu:typeUO):boolean;
begin
  try
    FDoNotLoadDisplayParams:= skipDisplay;
    FKeepCoordinates:=KeepCoo;
    result:= fonctionTObjectFile_SearchAndload(st,numOc,ob,pu);
  finally
    FDoNotLoadDisplayParams:= false;
    FKeepCoordinates:=false;
  end;
end;


function fonctionTObjectFile_SearchTypeAndload(numOc:integer;var ob,pu:typeUO):boolean;
begin
  verifierObjet(pu);
  verifierObjet(ob);

  result:=TobjectFile(pu).searchClassAndLoad(numOc,ob);
end;

function fonctionTObjectFile_SearchTypeAndload_1(numOc:integer;var ob:typeUO; skipDisplay:boolean; var pu:typeUO):boolean;
begin
  try
    FDoNotLoadDisplayParams:= skipDisplay;
    result:= fonctionTObjectFile_SearchTypeAndload(numOc,ob,pu);
  finally
    FDoNotLoadDisplayParams:= false;
  end;
end;

function fonctionTObjectFile_SearchTypeAndload_2(numOc:integer;var ob:typeUO; skipDisplay,KeepCoo:boolean; var pu:typeUO):boolean;
begin
  try
    FDoNotLoadDisplayParams:= skipDisplay;
    FKeepCoordinates:=KeepCoo;
    result:= fonctionTObjectFile_SearchTypeAndload(numOc,ob,pu);
  finally
    FDoNotLoadDisplayParams:= false;
    FKeepCoordinates:=false;
  end;
end;

procedure proTObjectFile_position(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TobjectFile(pu) do
  begin
    if (n<1) or (n>MainOffsets.count)
      then sortieErreur('TobjectFile: invalid position');
    numload:=n-1;
  end;
end;

function fonctionTObjectFile_position(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TobjectFile(pu) do
  result:=numload+1;

end;

function fonctionAppendObjectFile(st1,st2:AnsiString):boolean;
begin
  result:=AppendObjectFile(st1,st2);
end;

procedure proTobjectFile_AppendOI_1(Src: AnsiString;tpF:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TobjectFile(pu).AppendOIblocks(Src,tpF);
end;

procedure proTobjectFile_AppendOI(Src: AnsiString;var pu:typeUO);
begin
  proTobjectFile_AppendOI_1(src,1,pu);
end;


procedure proRemoveOIblocks(st1,st2:AnsiString);
var
  f1,f2:Tfilestream;
  header: THeaderObjectFile;
  size: longword;
  posf:int64;
  stmName:AnsiString;
begin
  f1:=nil;
  f2:=nil;

  try
  f1:=Tfilestream.Create(st1,fmOpenRead);
  f2:=Tfilestream.Create(st2,fmCreate);

  f1.Read(header,sizeof(header));
  f2.write(header,sizeof(header));

  while (f1.position<f1.size) do
  begin
    posf:=f1.position;
    stmName:=readHeader(f1,size);           {lire l'entête}
    if size<>0 then
    begin
      if stmName<>TOIblock.STMClassName then
      begin
        f1.position:=posf;
        f2.copyfrom(f1,size);
      end
      else f1.position:= posf+size;
    end
    else
    begin
      f1.position:= posf;
      f2.copyfrom(f1,f1.Size-posf);
    end;
 end;

 finally
 f1.Free;
 f2.free;
 end;

end;



procedure TObjectFile.CloseOpenFiles;
var
  i:integer;
begin
  with ObjectFiles do
  for i:=0 to count-1 do
    if (items[i]<>self) then TobjectFile(items[i]).FreeFileStream;

end;

function TObjectFile.getBlockOffset(n: integer): int64;
begin
  result:= Foffsets[n];
end;

function TObjectFile.getBlockSize(n: integer): int64;
var
  diff:int64;
begin
  result:= longword(Fsizes[n]);

  if n<BlockCount-1
    then diff:= BlockOffset[n+1]-BlockOffset[n]
    else diff:= FFileSize-BlockOffset[n];

  if diff<result then result:=diff;   // Dans ce cas, il y a eu un problème à l'acquisition.

  { modifié le 29 aout 2011}

end;


function TObjectFile.getBlockCount: integer;
begin
  result:= Foffsets.Count;
end;



function fonctionTObjectFile_ClassNames(n:integer;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TobjectFile(pu) do
  begin
    if (n<1) or (n>stClasses.count) then sortieErreur('TobjectFile.ClassNames : index out of range');
    result:=stClasses[n-1];
  end;
end;

function fonctionTObjectFile_ObjNames(n:integer;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TobjectFile(pu) do
  begin
    if (n<1) or (n>stNames.count) then sortieErreur('TobjectFile.ObjNames : index out of range');
    result:=stNames[n-1];
  end;
end;

function fonctionTObjectFile_ObjOffsets(n:integer;var pu:typeUO):Int64;
begin
  verifierObjet(pu);
  with TobjectFile(pu) do
  begin
    if (n<1) or (n>Foffsets.count) then sortieErreur('TobjectFile.ObjOffsets : index out of range');
    result:= FOffsets[n-1];
  end;
end;

function fonctionTObjectFile_ObjSizes(n:integer;var pu:typeUO):Integer;
begin
  verifierObjet(pu);
  with TobjectFile(pu) do
  begin
    if (n<1) or (n>Foffsets.count) then sortieErreur('TobjectFile.ObjSizes : index out of range');
    result:=integer(Fsizes[n-1]);
  end;
end;

procedure proTobjectFile_Copy(var f2: TobjectFile;num:integer; var pu: typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(f2));
  TobjectFile(pu).copy(f2,num-1);
end;

{ ToffsetList }
{$IFDEF WIN64}

function ToffsetList.add(p: int64): integer;
begin
  result:= inherited add(pointer(p));
end;

function ToffsetList.Get(Index: Integer): int64;
begin
  result:= int64(inherited get(index));
end;

procedure ToffsetList.Put(Index: Integer; Item: int64);
begin
  inherited put(index, pointer(item)) ;
end;

{$ELSE}

function ToffsetList.add(p: int64): integer;
begin
  result:= inherited add(@p);
end;

constructor ToffsetList.create;
begin
  inherited create(sizeof(int64));
end;


function ToffsetList.Get(Index: Integer): int64;
begin
  result:= Pint64(inherited get(index))^;
end;

procedure ToffsetList.Put(Index: Integer; Item: int64);
begin
  inherited put(index,@item) ;
end;

{$ENDIF}


Initialization
AffDebug('Initialization objFile1',0);


registerObject(TobjectFile,data);

ObjectFiles:=Tlist.create;

end.
