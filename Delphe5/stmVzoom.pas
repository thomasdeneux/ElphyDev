unit stmVzoom;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses Windows,
     classes,graphics,forms,controls,

     util1, debug0,
     stmDef,stmObj,varconf1,
     stmVec1,
     stmError,stmPg,
     iniVzoom;

type
  TimageVector= class(TVector)
                 Vsource:Tvector;

                 sourceB:Tvector;

                 destructor destroy;override;
                 class function STMClassName:AnsiString;override;
                 procedure freeRef;override;

                 function initialise(st:AnsiString):boolean;override;
                 procedure proprietes(sender:Tobject);override;
                 procedure installSource(ref:Tvector);
                 procedure ChangeData;


                 procedure saveData(f:Tstream);override;  {vide}
                 function loadData(f:Tstream):boolean;override;  {vide }


                 procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                 procedure completeLoadInfo;override;
                 procedure RetablirReferences(list:Tlist);override;
                 procedure ClearReferences;override;
                 procedure processMessage(id:integer;source:typeUO;p:pointer);override;

               end;



{***************** Déclarations STM pour TimageVector *****************************}


procedure proTimageVector_create(name:AnsiString;var src,pu:typeUO); pascal;
procedure proTimageVector_create_1(var src,pu:typeUO); pascal;
procedure proTimageVector_installSource(var vec,pu:typeUO);pascal;


IMPLEMENTATION


{********************** Méthodes de TimageVector ****************************}

destructor TimageVector.destroy;
begin
  installSource(nil);
  inherited destroy;
end;

procedure TimageVector.freeRef;
begin
  inherited;
  installSource(nil);
end;

class function TimageVector.STMClassName:AnsiString;
begin
  STMClassName:='ImageVector';
end;

function TimageVector.initialise(st:AnsiString):boolean;
var
  src:Tvector;
begin
  ident:=st;
  src:=Vsource;

  if initVzoom.execution('New VectorZoom: '+st,src) then
    begin
      installSource(src);
      initialise:=true;
    end
  else initialise:=false;
end;

procedure TimageVector.proprietes(sender:Tobject);
var
  src:Tvector;
begin
  src:=Vsource;

  if initVzoom.execution('New VectorZoom: '+ident,src)
    then installSource(src);
end;

procedure TimageVector.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    if lecture
      then setvarconf('Source',sourceB,sizeof(sourceB))
      else setvarconf('Source',Vsource,sizeof(Vsource));
  end;
end;

procedure Timagevector.completeLoadInfo;
begin
  { On ne pas pas appeler inherited }
  CheckOldIdent;
  visu.controle;

  recupForm;
  if assigned(form) then
    begin
      form.caption:=ident;
      form.color:=BKcolor;
    end;
end;



procedure TimageVector.RetablirReferences(list:Tlist);
var
  i:integer;
  p:pointer;
begin
  for i:=0 to list.count-1 do
    begin
     p:=typeUO(list.items[i]).myAd;
     if p=sourceB then
       begin
         installSource(list.items[i]);
       end;
    end;

  recupForm;

end;

procedure TimageVector.ClearReferences;
begin
  Vsource:=nil;
end;

procedure TimageVector.processMessage(id:integer;source:typeUO;p:pointer);
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        if (Vsource=source) then
          begin
            installSource(nil);
          end;
      end;
    UOmsg_invalidateData:
      begin
        if (Vsource=source) then
          begin
            changeData;
          end;
      end;

  end;
end;

procedure TimageVector.ChangeData;
begin
  if assigned(Vsource) then
    begin
      data:=Vsource.data;
      inf:=Vsource.inf;
      inf.temp:=false;
      inf.readOnly:=Vsource.readOnly;
    end
  else
    begin
      data:=nil;
    end;
  invalidate;
end;

procedure TimageVector.installSource(ref:Tvector);
begin
  derefObjet(typeUO(Vsource));
  Vsource:=ref;
  refobjet(ref);
  changeData;
end;


function TimageVector.loadData(f: Tstream): boolean;
begin
  result:=true;
end;

procedure TimageVector.saveData(f: Tstream);
begin

end;

{*********************** Méthodes STM pour TimageVector ********************}

Procedure proTimageVector_create(name:AnsiString;var src,pu:typeUO);
begin
  createPgObject(name,pu,TimageVector);
  with TimageVector(pu) do installSource(Tvector(src));
end;

procedure proTimageVector_create_1(var src,pu:typeUO);
begin
  proTimageVector_create('', src,pu);
end;

procedure proTimageVector_installSource(var vec,pu:typeUO);
begin
  verifierObjet(pu);
  with TimageVector(pu) do installSource(Tvector(vec));
end;



Initialization
AffDebug('Initialization stmVzoom',0);

{installError(E_dataEvExpected,'TimageVector: Event data expected');}

registerObject(TimageVector,data);

end.
