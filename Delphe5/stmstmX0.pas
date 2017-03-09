unit stmstmX0;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, classes,messages,graphics,forms,sysUtils,
     util1,Gdos,Dgraphic,clock0,dtf0,
     debug0,
     syspal32,

     Dprocess,Ncdef2,
     stmdef,stmObj,stmobv0,KBlist0,
     spk0,
     varConf1,stmdf0,stmError,
     stmSys0;



type
  TTimeMan=   record
                tOrg:     longint;
                dtOn:     longint;
                dtOff:    longint;
                Pause:    longint;
                nbCycle:  longint;
              end;


  TStim=      class(TvisualObject)
                 obvis:Tresizable;

                 timeMan:TtimeMan;

                 timeS:longint;         { timeS=timeProcess-timeMan.torg }
                 dureeC:longint;        { dureeC:=Dton+DtOff+pause }
                 tend:longint;          { tend:=torg+dureeC*nbCycle }

                 ControlClearMode:boolean;

                 syncPulse: Tlist;


                 CyclicPulse:array[1..5] of longint;
                 nbCyclicPulse:smallInt;


                 sync,Csync:integer;
                 dureeSU1,dtSyncU1:integer;

                 track:boolean;
                 active:boolean;

                 constructor create;override;
                 destructor destroy;override;
                 procedure freeRef;override;

                 procedure setObvis(uo:typeUO);virtual;

                 Property CycleCount:integer read timeMan.nbCycle write timeMan.nbCycle;
                 Property DtON:integer read timeMan.DtOn write timeMan.DtOn;
                 Property DtOff:integer read timeMan.DtOff write timeMan.DtOff;
                 Property tOrg:integer read timeMan.tOrg write timeMan.tOrg;



                 procedure refresh;virtual;
                 procedure installe;virtual;
                 procedure desinstalle;virtual;

                 procedure SortSyncPulse;
                 procedure InitMvt; virtual;
                 procedure InitObvis;virtual;
                 procedure calculeMvt; virtual;
                 procedure doneMvt;virtual;
                 procedure setVisiFlags(obOn:boolean);virtual;
                 function valid:boolean;virtual;

                 procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                 procedure saveToStream(f:Tstream;Fdata:boolean);override;
                 function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;

                 procedure RetablirReferences(list:Tlist);override;
                 procedure ClearReferences;override;

                 procedure processMessage(id:integer;source:typeUO;p:pointer);override;

                 procedure AddToStimList(list:Tlist);override;

               end;

{ Dans Tstim, on a introduit obvis, ce qui n'est pas très malin car un stimulus n'utilisera pas forcément
  cet objet visuel. Si le stimulus n'utilise pas obvis, il faudra surcharger les méthodes suivantes:

  setVisiFlags
  Valid
  RetablirReferences
  ClearReferences
  ProcessMessage
  AddToStimList
}


  TlisteStim=class(Tlist)
               StmSys:TsystemVS;

               constructor create;
               destructor destroy;override;

               procedure build;
               procedure saveObjects(var f:file);
               procedure saveToStream(f:TfileStream);
               procedure installe;
               procedure desinstalle;
               procedure LoadObjects(var f:file);
               procedure LoadFromStream(f:Tstream);
               procedure FreeAndClear;

               procedure calculeFrameCount;
               procedure PushGlobals;
               procedure PopGlobals;
               procedure setGlobals;

             end;

  var
    listeStim:TlisteStim;
    { liste des stimulus installés par installeStimuli}


procedure proTstm_StartTime(w:float;var pu:typeUO);pascal;
function fonctionTstm_StartTime(var pu:typeUO):float;pascal;

procedure proTstm_Active(w:boolean;var pu:typeUO);pascal;
function fonctionTstm_Active(var pu:typeUO):boolean;pascal;


procedure proTstm_setVisualObject(var puOb,pu:typeUO);pascal;

procedure proTstm_setSyncPulse(date:float;var pu:typeUO);pascal;
procedure proTstm_setCyclicSyncPulse(date:float;var pu:typeUO);pascal;
procedure proTstm_setCyclicSyncPulse1(t,trep:float;var pu:typeUO);pascal;

procedure proTstm_resetSyncPulse(var pu:typeUO);pascal;



IMPLEMENTATION

uses stmTransform1;

var
  E_startTime:integer;
  E_extraTime:integer;



{*********************   Méthodes de Tstim  ************************}

constructor TStim.create;
begin
  inherited create;
  with TimeMan do
  begin
    DtON:=60;
    nbCycle:=1;
  end;
  active:=true;
  SyncPulse:=Tlist.Create;
end;

destructor TStim.destroy;
begin
  derefObjet(typeUO(obvis));
  inherited destroy;
  SyncPulse.Free;
end;

procedure Tstim.freeRef;
begin
  inherited;
  derefObjet(typeUO(obvis));
end;

procedure Tstim.setObvis(uo:typeUO);
begin
  derefObjet(typeUO(obvis));
  obvis:=Tresizable(uo);
  refObjet(typeUO(obvis));
end;

function compare(Item1, Item2: Pointer): Integer;
begin
  result:= intG(item1)-intG(item2);
end;

procedure Tstim.SortSyncPulse;
begin
  SyncPulse.Sort(compare);
end;


procedure Tstim.InitMvt;
begin
  SortSyncPulse;
end;

procedure Tstim.initObvis;
begin
end;

procedure Tstim.calculeMvt;
begin
end;

procedure Tstim.doneMvt;
begin
end;

procedure Tstim.refresh;
var
  objetON:boolean;

begin
  timeS:=timeProcess-timeMan.tOrg;

  if (timeS<0) or (timeProcess>tend+1) then exit;

  if timeProcess<tEnd then
    begin
      if (Sync<SyncPulse.count) and (timeS=intG(SyncPulse[sync])) then
        begin
          FTopSync:=true;
          inc(sync);
        end;

      if timeS mod dureeC=0 then Csync:=1;
      if (CSync<=nbCyclicPulse) and (timeS mod dureeC =CyclicPulse[Csync]) then
        begin
          FTopSync:=true;
          inc(Csync);
        end;

      if (dureeSU1>0) and (timeS mod dureeSU1=dtSyncU1)
        then FTopSync:=true;
    end;


  calculeMvt;   { Dernier appel de calculeMvt avec tend+1 }

  with timeMan do objetON:=(timeS mod DureeC<DtOn) and (timeProcess<tend);
  { on transmet le flag d'affichage calculé par le modele périodique (dtOn+dtOff+cycleCount)
    mais l'objet n'est pas obligé de l'utiliser}
  setVisiFlags(objetON);
end;

procedure Tstim.setVisiFlags(obOn:boolean);
begin
  if assigned(obvis) and affStim and ObON then obvis.FlagOnScreen:=true;
  if assigned(obvis) and affControl and ObON then obvis.FlagOnControl:=true;
end;

function Tstim.valid:boolean;
begin
  valid:=assigned(obvis);
end;

procedure Tstim.installe;
  begin
    if not valid or not active  then exit;

    with TimeMan do
    begin
      dureeC:=dtON+dtOff+pause;     { Ces valeurs peuvent être modifiées par }
      tend:=torg+dureeC*nbCycle;    { initMvt. ie: Revcor }
    end;

    initMvt;
    initObvis;

    sync:=0;
    Csync:=1;

    installeProcess(refresh);
  end;


procedure Tstim.desinstalle;
  begin
    doneMvt;
  end;


procedure Tstim.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setvarConf('ACTIVE',active,sizeof(active));
    if tout then setvarConf('OBVIS',obvis,sizeof(pointer));
    setVarConf('TimeMan',timeMan,sizeof(timeMan));
  end;
end;

procedure Tstim.saveToStream(f:Tstream;Fdata:boolean);
begin
  inherited saveToStream(f,Fdata);           {sauve les infos du stim}
  (*
  if saveChild and assigned(obvis)
    then obvis.saveToStream(f,saveChild);        {puis les infos de l'obvis}
  *)
end;

function Tstim.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  st1:string[255];
  posf:LongWord;
  ok:boolean;
begin
  ok:=inherited loadFromStream(f,size,Fdata);
  result:=ok;
  (*
  if not ok or not withChild then exit;

  if Gfilepos(f)>=GfileSize(f) then
    begin
      loadObject:=true;
      exit;
    end;

  st1:=readHeader(f,size);

  typeUO(obvis):=CreateUO(st1,false);            { créer l'objet si possible }

  if (obvis<>nil) and (obvis is Tresizable)
    then
      begin
        ok:=obvis.loadObject(f,size,list,withChild);
        if ok and assigned(list) then
          begin
            list.add(obvis);
            refObjet(obvis);
          end;
      end
    else
      begin
        ok:=false;
        obvis.free;
        obvis:=nil;
        Gseek(f,GfilePos(f)+size-sizeof(size)-1-length(st1));
      end;
  loadObject:=ok;*)
end;

procedure Tstim.RetablirReferences(list:Tlist);
var
  i:integer;
begin
  for i:=0 to list.count-1 do
    if typeUO(list.items[i]).myAd=obvis then
      begin
        obvis:=Tresizable(list.items[i]);
        refObjet(obvis);
        exit;
      end;
  obvis:=nil;
end;

procedure Tstim.ClearReferences;
begin
  obvis:=nil;
end;

procedure Tstim.processMessage(id:integer;source:typeUO;p:pointer);
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        if (obvis=source) then
          begin
            obvis:=nil;
            derefObjet(source);
          end;
      end;
  end;
end;

procedure Tstim.AddToStimList(list:Tlist);
begin
  if valid and active then
    begin
      list.add(self);
      if (obvis<>nil) and (list.indexof(obvis)<0) then list.add(obvis);
    end;
end;



{************** Méthodes de TlisteStim **********************************}

constructor TlisteStim.create;
begin

  inherited;
  StmSys:=TsystemVS.create;
end;

destructor TlisteStim.destroy;
begin
  stmSys.free;
  inherited;
end;


procedure TlisteStim.build;   {construit la liste des stimulus opérationnels}
var                           {on écarte ceux tels que obvis=nil}
  i:integer;
begin
  clear;

  for i:=0 to syslist.count-1 do
    typeUO(syslist.items[i]).AddToStimList(self);

end;

procedure TlisteStim.installe;
var
  i:integer;
begin
  FrameCount:=0;
  for i:=0 to count-1 do
  if typeUO(items[i]) is Tstim then
    with Tstim(items[i]) do
    begin
      installe;
      if FrameCount<tend+extraTime then FrameCount:=tend+extraTime;
    end;
   TransformList.RegisterRenderSurface;
end;

procedure TlisteStim.desinstalle;
var
  i:integer;
begin
  resetProcess;
  for i:=0 to count-1 do
    if typeUO(items[i]) is Tstim then
        Tstim(items[i]).desinstalle;
   TransformList.UnRegisterRenderSurface;
end;

procedure TlisteStim.calculeFrameCount;
var
  i:integer;
begin
  FrameCount:=0;

  for i:=0 to syslist.count-1 do
    if (typeUO(syslist.items[i]) is Tstim) and
       (Tstim(syslist.items[i]).valid) and (Tstim(syslist.items[i]).active) then
      with Tstim(syslist.items[i]) do
        if FrameCount<tend+extraTime then FrameCount:=tend+extraTime;
end;


procedure TlisteStim.saveObjects(var f:file);
var
  i:integer;
begin
  stmSys.saveObject(f,false);         { - le bloc SYSTEM }

  for i:=0 to count-1 do              { - les blocs correspondant à }
      TypeUO(items[i]).saveObject(f,false); { chaque stimulus ou objet visuel}
end;

procedure TlisteStim.saveToStream(f:TfileStream);
var
  i:integer;
begin
  stmSys.saveToStream0(f,false);         { - le bloc SYSTEM }

  for i:=0 to count-1 do              { - les blocs correspondant à }
      TypeUO(items[i]).saveToStream0(f,false); { chaque stimulus ou objet visuel}
end;


procedure TlisteStim.LoadFromStream(f:Tstream);
var
  st1:string[255];
  p:typeUO;
  ok:boolean;
  i:integer;
  size:longword;
begin
  clear;

  ok:=true;
  repeat
    st1:='';
    st1:=readHeader(f,size);
    {messageCentral(st1);}
    if st1=TsystemVS.stmClassName then stmSys.loadFromStream(f,size,false)
    else
      begin
        p:=CreateUO(st1,false);            { créer l'objet si possible }
        if p is TvisualObject then
          begin                            { ne garder que les Visual objects }
            add(Tstim(p));
            ok:=p.loadFromStream(f,size,false);
            {messageCentral('Load '+p.ident);}
          end
        else
          begin
            p.free;
            ok:=false;
          end;
      end;
  until not ok or (f.position>=f.size) or testEscape;

  for i:=0 to count-1 do
    typeUO(items[i]).retablirReferences(self);
  stmSys.retablirReferences(self);

  for i:=0 to count-1 do
    if (typeUO(items[i]) is Tstim) and not (Tstim(items[i]).valid) then
      begin
        typeUO(items[i]).free;
        items[i]:=nil;
      end;

  pack;
end;



procedure TlisteStim.LoadObjects(var f:file);
var
  stream:ThandleStream;
begin
  stream:=ThandleStream.create(TfileRec(f).handle);
  try
    loadFromStream(stream);
  finally
    stream.free;
  end;

end;

procedure TlisteStim.FreeAndClear;
var
  i:integer;
begin
  for i:=0 to count-1 do typeUO(items[i]).free;
  inherited clear;
end;

procedure TlisteStim.PushGlobals;
begin
  stmsys.push;
end;

procedure TlisteStim.PopGlobals;
begin
  stmsys.pop;
end;

procedure TlisteStim.setGlobals;
begin
  stmsys.infToGlobal(stmsys.inf);
end;


{************** Méthodes STM  de Tstm *****************************}

procedure proTstm_StartTime(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(w,0,10000,E_startTime);
  with Tstim(pu) do timeMan.tOrg:=round(w*1E6/Tfreq);
end;

function fonctionTstm_StartTime(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with Tstim(pu) do result:=timeMan.tOrg*Tfreq/1E6;
end;



procedure proTstm_Active(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tstim(pu) do active:=w;
end;

function fonctionTstm_Active(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tstim(pu) do result:=active;
end;


procedure proTstm_setVisualObject(var puOb,pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(puOb);
    Tstim(pu).setobvis(puOb);
  end;


procedure proTstm_setSyncPulse(date:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tstim(pu).SyncPulse.Add( pointer(roundL(date/Tfreq*1E6)));
  end;


procedure proTstm_setCyclicSyncPulse(date:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tstim(pu) do
      if nbCyclicPulse<5 then
        begin
          inc(nbCyclicPulse);
          CyclicPulse[nbCyclicPulse]:=roundL(date/Tfreq*1E6);
        end;
  end;

procedure proTstm_setCyclicSyncPulse1(t,trep:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tstim(pu) do
  begin
    dtSyncU1:=roundL(t/Tfreq*1E6);
    dureeSU1:=roundL(trep/Tfreq*1E6);
  end;
end;

procedure proTstm_resetSyncPulse(var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tstim(pu) do
    begin
      SyncPulse.Clear;
    end;
  end;


{****************************************************************************}








Initialization
AffDebug('Initialization stmstmX0',0);
  initStmObj;
  if testUnic then listeStim:=TlisteStim.create;

  installError(E_startTime,'Tstm: invalid startTime');
  installError(E_extraTime,'Tstm: invalid extraTime');
end.
