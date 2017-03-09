unit StmVecSpk1;


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses windows,classes,graphics,

     util1,Dgraphic,Dtrace1, debug0,
     dtf0,
     stmDef,stmObj,
     varconf1,
     stmVec1,
     NcDef2,stmPg;


{ TvectorSpk est un vecteur qui utilise data et dataAtt
    son affichage standard utilise dataAtt pour changer la couleur des spikes

  Il possède des vecteurs enfants Vunit qui représentent les spikes pour chaque attribut.
  Vunit est basé sur un objet typeDataSpkExt construit à partir de data et dataAtt.
}

type
  TvectorSpk=   class(TVector)
                  VUCount,VUcountR:longint;
                  Vunit:array of Tvector;
                  FUseStdColors:boolean;
                  UspkCount:array of integer;

                  constructor create;override;
                  destructor destroy;override;

                  class function STMClassName:AnsiString;override;
                  procedure setVectors(nb:integer); // nb = nb total d'unités en comptant la valeur 0
                                                    // nb= 5 signifie 0 1 2 3 4
                  function initialise(st:AnsiString):boolean;override;
                  procedure setChildNames;override;

                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                  procedure saveToStream(f:Tstream;Fdata:boolean);override;
                  function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;
                  procedure proprietes(sender:Tobject);override;

                  function loadFromStream1(f:Tstream;size:LongWord;Fdata:boolean):boolean;
                  procedure modify(tNombre:typeTypeG;i1,i2:integer);override;

                  procedure InitData(dataT,dataA:typeDataB; Finvalidate: boolean);
                  procedure OndisplayPoint(i:integer);

                  procedure modifyLimits(i1,i2:integer; const WithI1:boolean=true);override;
                end;



{***************** Déclarations STM pour TvectorSpk *****************************}
procedure proTvectorSpk_create(t:smallint;n1,n2:longint;var pu:typeUO);pascal;

procedure proTvectorSpk_Uvalue(n:integer;w:integer;var pu:typeUO);pascal;
function fonctionTvectorSpk_Uvalue(n:integer;var pu:typeUO):integer;pascal;
procedure proTvectorSpk_UseStdColors(w:boolean;var pu:typeUO);pascal;
function fonctionTvectorSpk_UseStdColors(var pu:typeUO):boolean;pascal;
function fonctionTvectorSpk_VU(n:integer;var pu:typeUO):pointer;pascal;

function fonctionTvectorSpk_VUcount(var pu:typeUO):integer;pascal;


IMPLEMENTATION


{********************** Méthodes de TvectorSpk ****************************}

constructor TvectorSpk.create;
begin
  inherited;
  setVectors(6);
  setChildNames;
  OnDPsys:=OnDisplayPoint;
  FuseStdColors:=true;
end;

destructor TvectorSpk.destroy;
begin
  setVectors(0);
  inherited;
end;

class function TvectorSpk.STMClassName:AnsiString;
begin
  result:='VectorSpk';
end;



procedure TvectorSpk.setVectors(nb:integer);
var
  i,oldnb:integer;
begin
  oldNb:=length(Vunit);
  VUcount:=nb;

  for i:=VUcount to oldNb-1 do    { si nb<oldNb, détruire les objets }
    Vunit[i].free;

  setLength(Vunit,VUcount);      { ajuster la taille des tableaux }

  for i:=oldNb to VUcount-1 do    {si nb>oldNb, créer les objets }
  begin
    Vunit[i]:=Tvector.create;
    with Vunit[i] do
    begin
      notPublished:=true;
      Fchild:=true;
      modeT:=DM_evt1;
      Ymin:=-1;
      Ymax:=2;
    end;
  end;

  ClearChildList;
  for i:=0 to VUcount-1 do
    addToChildList(Vunit[i]);
end;


function TvectorSpk.initialise(st:AnsiString):boolean;
begin
  result:= inherited initialise(st);
  if result then setChildNames;
end;


procedure TvectorSpk.setChildNames;
var
  i:integer;
begin
  for i:=0 to high(Vunit) do
  with Vunit[i] do
  begin
    ident:=self.ident+'.Vu'+Istr(i);
    notPublished:=true;
    Fchild:=true;
    readOnly:=self.readOnly;
    if self.FuseStdColors and (i<=10) then visu.color:=stdColors[i];
    if not (modeT in [DM_evt1,DM_evt2]) then modeT:=DM_evt1;
  end;
end;

procedure TvectorSpk.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;
  if not lecture then VUcountR:=VUcount;

  with conf do
  begin
    setvarconf('VUCount',VUcountR,sizeof(VUcount));
    setvarconf('StdCol',FuseStdColors,sizeof(FuseStdColors));
  end;
end;


procedure TvectorSpk.saveToStream(f:Tstream;Fdata:boolean);
var
  i:integer;
begin
  inherited saveToStream(f,Fdata);

  for i:=0 to VUcount-1 do Vunit[i].saveToStream(f,Fdata);
end;

function TvectorSpk.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  st1:string[255];
  ok:boolean;
  pos1,posIni:LongWord;
  i:integer;
  OldstID:string[30];
  stID: AnsiString;
  conf:TblocConf;
  n:integer;


function identifier(st:AnsiString;var n:integer):boolean;
var
  k,code:integer;
begin
  k:=length(ident);
  result:=(copy(st,1,k+1)=ident+'.');
  if not result then exit;

  delete(st,1,k+1);
  n:=0;
  if st='' then exit;

  if copy(st,1,2)='Vu' then
    begin
      delete(st,1,2);
      val(st,n,code);
      result:= (code=0) and (n>=0) and (n<=VUcount);
    end
  else result:=false;
end;

begin
  ok:=inherited loadFromStream(f,size,Fdata);
  result:=ok;

  if not ok then exit;

  if f.position>=f.Size  then
    begin
      result:=true;
      exit;
    end;


  setVectors(VUcountR);

  repeat
    posIni:=f.position;
    st1:=readHeader(f,size);

    if (st1=Tvector.STMClassName) then
    begin
      pos1:=f.position;
      conf:=TblocConf.create(st1);
      conf.setvarConf('IDENT',OldStId,sizeof(OldStId));
      conf.setStringConf('IDENT1',StId);

      result:=(conf.lire1(f,size)=0);
      conf.free;
      f.Position:=pos1;
      if stId='' then stId:=OldSTId;

                                                   {ident.VU1 }
      result:=identifier(stId,n);
      if result and (n>=0) and (n<VUcountR) then
      begin
        if result then result:=Vunit[n].loadFromStream(f,size,Fdata);

        with Vunit[n] do
        if not modeT in [DM_Evt1,DM_EVT2]
          then modeT:=DM_Evt1;
      end
      else f.Position:=posini+size;
    end
    else
    begin
      result:=false;
      f.Position:=posini+size;
    end;
  until (f.position>=f.size) or not result;
  f.Position:=posini;

  setChildNames;
  result:=true;
end;


function TvectorSpk.loadFromStream1(f:Tstream;size:LongWord;Fdata:boolean):boolean;
begin
  result:=inherited loadFromStream(f,size,Fdata);
  setChildNames;
end;





procedure TvectorSpk.modify(tNombre: typeTypeG; i1, i2: integer);
begin
  inherited;

end;

procedure TvectorSpk.proprietes(sender: Tobject);
begin
  inherited;

end;

procedure TvectorSpk.InitData(dataT, dataA: typeDataB; Finvalidate: boolean);       { dates + att pour une électrode }
var
  i:integer;
  dataSpk:typeDataSpkExt;
  bb:byte;
begin
  initDat0(dataT,G_longint);
  initAtt(dataA);

  setLength(UspkCount,VUcount);
  fillchar(UspkCount[0],sizeof(integer)*length(UspkCount),0);
  if assigned(dataA) then
  with dataA do
  for i:=indiceMin to indiceMax do
  begin
    bb:=getI(i);
    if bb<VUcount then inc(UspkCount[bb]);
  end;

  for i:=0 to VUcount-1 do
  begin
    dataSpk:=typeDataSpkExt.create(dataT,dataA,i,1,UspkCount[i]); { objet sélectionnant un attribut }
    Vunit[i].initDat1Ex(dataSpk,g_longint);
  end;

  if Finvalidate then invalidateData;
end;

procedure TvectorSpk.OndisplayPoint(i: integer);
var
  bb:byte;
begin
  if FuseStdColors then
  begin
    bb:=dataAtt.getI(i);
    if (bb>=0) and (bb<=10)
      then canvasGlb.pen.color:=StdColors[bb]
      else canvasGlb.pen.color:=StdColors[0];
  end
  else canvasGlb.pen.color:=visu.color;
end;


procedure TvectorSpk.modifyLimits(i1, i2: integer; const WithI1: boolean);
var
  i:integer;
  bb:byte;
begin
  if assigned(dataAtt) then
  with dataAtt do
  for i:=indiceMax+1 to i2 do
  begin
    bb:=getI(i);
    if bb<VUcount then inc(UspkCount[bb]);
  end;

  inherited;

  for i:=0 to VUcount-1 do
  begin
    Vunit[i].modifyLimits(1,USpkCount[i],WithI1);
  end;

end;


{*********************** Méthodes STM pour TvectorSpk ********************}

procedure proTvectorSpk_create(t:smallint;n1,n2:longint;var pu:typeUO);
begin
  if not (typeTypeG(t) in typesVecteursSupportes)
      then sortieErreur('TvectorSpk.create : invalid number type' );

  if n2<n1 then n2:=n1-1;
  createPgObject('',pu,TvectorSpk);

  with TvectorSpk(pu) do
  begin
    setChildNames;
    initTemp1(n1,n2,TypetypeG(t));
  end;
end;


procedure proTvectorSpk_Uvalue(n:integer;w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TvectorSpk(pu) do
  begin
    if inf.readOnly then sortieErreur('TvectorSpk.Uvalue : this object is ReadOnly');
    if assigned(dataAtt) and (n>=dataAtt.indiceMin) and (n<=dataAtt.indiceMax)
      then dataAtt.setI(n,w)
      else sortieErreur('TvectorSpk.Uvalue : index out of range');
  end;
end;

function fonctionTvectorSpk_Uvalue(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TvectorSpk(pu) do
  begin
    if assigned(dataAtt) and (n>=dataAtt.indiceMin) and (n<=dataAtt.indiceMax)
      then result:=dataAtt.getI(n)
      else sortieErreur('TvectorSpk.Uvalue : index out of range');
  end;
end;

procedure proTvectorSpk_UseStdColors(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TvectorSpk(pu) do
  begin
    FuseStdColors:=w;
    invalidate;
  end;
end;

function fonctionTvectorSpk_UseStdColors(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= TvectorSpk(pu).FuseStdColors;
end;

function fonctionTvectorSpk_VU(n:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TvectorSpk(pu) do
  begin
    if (n<0) or (n>=length(Vunit)) then sortieErreur('TvectorSpk.VU : index out of range');
    result:=@Vunit[n];
  end;
end;

function fonctionTvectorSpk_VUcount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TvectorSpk(pu) do
  begin
    result:=VUcount;
  end;
end;


Initialization
AffDebug('Initialization StmVecSpk1',0);

registerObject(TvectorSpk,data);

end.
