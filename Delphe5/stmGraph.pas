unit stmgraph;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,graphics,forms,controls,menus,

     util1,Gdos,DdosFich,Dgraphic,Dgrad1,dtf0,Dtrace1,
     Dpalette,Ncdef2,formMenu,
     editcont,cood0,
     tpForm0,

     stmDef,stmObj,defForm,
     getVect0,getMat0,visu0,
     inivect0,
     varconf1,stmDPlot,stmvec1,
     debug0,stmCurs,
     stmError,stmPg,
     inigra0;

type
  Tgraph= class(TDataPlot)
           private
                  FlagSave: boolean;
                  FdumSave: boolean;
                  FownedVectors: boolean;
                  procedure setOwnedVectors(w: boolean);
                  procedure setChildList;
           public
                  vecX,vecY,vecSigma:Tvector;
                  vec1b,vec2b,vecSb:Tvector;

                  AutoLimit:boolean;
                  Imin,Imax:integer;

                  property OwnedVectors: boolean read FownedVectors write setOwnedVectors;

                  procedure setIstart(w:integer);override;
                  function getIstart:integer;override;
                  procedure setIend(w:integer);override;
                  function getIend:integer;override;
                  procedure setChildNames;override;


                  constructor create;override;
                  destructor destroy;override;

                  class function STMClassName:AnsiString;override;
                  procedure freeRef;override;

                  procedure initData(v1,v2,vs:Tvector;n1,n2:integer);

                  procedure display; override;
                  procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;
                                          const order:integer=-1); override;

                  procedure LimitesGraphe(var i1,i2:integer);

                  procedure cadrerX(sender:Tobject);override;
                  procedure cadrerY(sender:Tobject);override;

                  procedure autoscaleX;override;
                  procedure autoscaleY;override;

                  procedure proprietes(sender:Tobject);override;

                  function initialise(st:AnsiString):boolean;override;

                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                  procedure completeLoadInfo;override;
                  procedure saveToStream( f:Tstream;Fdata:boolean);override;
                  function  loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;



                  procedure RetablirReferences(list:Tlist);override;
                  procedure resetAll;override;

                  procedure processMessage(id:integer;source:typeUO;p:pointer);override;
                  function getmean(x1,x2:float):float;override;
                end;


procedure proTgraph_create(name:AnsiString;var Xvec,Yvec:Tvector;
                           ideb,ifin:longint;var pu:typeUO);pascal;

procedure proTgraph_create_1(var Xvec,Yvec:Tvector;
                           ideb,ifin:longint;var pu:typeUO);pascal;
procedure proTgraph_create_2(var pu:typeUO);pascal;


procedure proTgraph_modify(var Xvec,Yvec:Tvector;
                          iStart,iEnd:longint;var pu:typeUO);pascal;

procedure proTgraph_setErrorData(var vec:Tvector;var pu:typeUO);pascal;

procedure proTgraph_AutoLimit(x:boolean;var pu:typeUO);pascal;
function fonctionTgraph_AutoLimit(var pu:typeUO):boolean;pascal;

procedure proTgraph_OwnedVectors(x:boolean;var pu:typeUO);pascal;
function fonctionTgraph_OwnedVectors(var pu:typeUO):boolean;pascal;

function fonctionTgraph_VecX(var pu:typeUO):pointer;pascal;
function fonctionTgraph_VecY(var pu:typeUO):pointer;pascal;
function fonctionTgraph_VecSigma(var pu:typeUO):pointer;pascal;

implementation

var
  E_symbolSize:integer;
  E_lineWidth:integer;

constructor Tgraph.create;
begin
  inherited;

end;


destructor Tgraph.destroy;
begin
  if FownedVectors then
  begin
    vecX.Free;
    vecX:=nil;
    vecY.Free;
    vecY:=nil;
    vecSigma.Free;
    vecSigma:=nil;
    ClearChildList;
  end
  else
  begin
    derefObjet(typeUO(vecX));
    derefObjet(typeUO(vecY));
    derefObjet(typeUO(vecSigma));
  end;
  inherited destroy;
end;

procedure Tgraph.freeRef;
begin
  inherited;
  if FownedVectors then
  begin

  end
  else
  begin
    derefObjet(typeUO(vecX));
    derefObjet(typeUO(vecY));
    derefObjet(typeUO(vecSigma));
  end;
end;

procedure Tgraph.initData(v1,v2,vs:Tvector;n1,n2:integer);
begin
  OwnedVectors:= false;

  Imin:=n1;
  Imax:=n2;

  derefObjet(typeUO(vecX));
  derefObjet(typeUO(vecY));
  derefObjet(typeUO(vecSigma));

  vecX:=v1;
  vecY:=v2;
  vecSigma:=vs;

  refObjet(typeUO(vecX));
  refObjet(typeUO(vecY));
  refObjet(typeUO(vecSigma));

  if Imin>Imax then autoLimit:=true;

  invalidate;
end;

class function Tgraph.STMClassName:AnsiString;
begin
  STMClassName:='Graph';
end;


procedure Tgraph.display;
var
  dataX,dataY,dataS:typedataB;
var
  i1,i2:integer;
begin
  if assigned(vecX) then dataX:=vecX.data else dataX:=nil;
  if assigned(vecY) then dataY:=vecY.data else dataY:=nil;
  if assigned(vecSigma) and (vecSigma.Icount>0) then dataS:=vecSigma.data else dataS:=nil;

  limitesGraphe(i1,i2);

  visu.displayGraph(dataX,dataY,dataS,i1,i2);
end;

procedure Tgraph.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);
var
  ds:typedataB;
  i1,i2:integer;
begin
  if not assigned(vecX) or not assigned(vecY) then exit;
  if assigned(vecSigma) and (vecSigma.Icount>0) then ds:=vecSigma.data else ds:=nil;

  limitesGraphe(i1,i2);
  visu.displayGraph0(vecX.data,vecY.data,ds,i1,i2,
                         extWorld,false,logX,logY,0,0);
end;

procedure Tgraph.LimitesGraphe(var i1,i2:integer);
begin
  i1:=0;
  i2:=0;
  if not assigned(vecX) or not assigned(vecY) then exit;

  if autoLimit then
    begin
      if vecX.Istart<vecY.Istart
        then i1:=vecY.Istart
        else i1:=vecX.Istart;

      if vecX.Iend<vecY.Iend
        then i2:=vecX.Iend
        else i2:=vecY.Iend;
    end
  else
    begin
      i1:=Imin;
      i2:=Imax;
    end;
end;

procedure Tgraph.cadrerX(sender:Tobject);
var
  min,max:float;
  i1,i2:integer;
begin
  if not assigned(vecX) or not assigned(vecY) then exit;
  limitesGraphe(i1,i2);
  {messageCentral(Istr(vecX.data^.indicemin)+' '+Istr(vecX.data^.indicemax));}
  if vecX.data<>nil then
    begin
      vecX.data.limitesY(min,max,i1,i2);
      {messageCentral(Estr(min,3)+' '+Estr(max,3));}
      if min<=max then
        begin
          visu0^.Xmin:=min;
          visu0^.Xmax:=max;
        end;
    end;
end;

procedure Tgraph.cadrerY(sender:Tobject);
var
  min,max:float;
  i1,i2:integer;
begin
  if not assigned(vecX) or not assigned(vecY) then exit;
  limitesGraphe(i1,i2);
  if vecY.data<>nil then
    begin
      vecY.data.limitesY(min,max,i1,i2);
      if min<=max then
        begin
          visu0^.Ymin:=min;
          visu0^.Ymax:=max;
        end;
    end;
end;

procedure Tgraph.autoscaleX;
var
  min,max:float;
  i1,i2:integer;
begin
  if not assigned(vecX) or not assigned(vecY) then exit;

  limitesGraphe(i1,i2);
  if (vecX.data<>nil) and (i1<=i2) then
    begin
      vecX.data.limitesY(min,max,i1,i2);
      if min<=max then
        begin
          setXmin(min);
          setXmax(max);
        end;
    end;
end;

procedure Tgraph.autoscaleY;
var
  min,max:float;
  i1,i2:integer;
begin
  if not assigned(vecX) or not assigned(vecY) then exit;
  limitesGraphe(i1,i2);
  if (vecY.data<>nil) and (i1<=i2) then
    begin
      vecY.data.limitesY(min,max,i1,i2);
      if min<=max then
        begin
          Ymin:=min;
          Ymax:=max;
        end;
    end;
end;

function Tgraph.getmean(x1, x2: float): float;
begin
  if assigned(vecY)
    then result:=vecY.getMean(x1,x2)
    else result:=0;
end;

procedure Tgraph.proprietes;
var
  n1,n2:integer;
  v1,v2,vs:Tvector;
  Fowned: boolean;
begin
  v1:=vecX;
  v2:=vecY;
  vs:=vecSigma;
  n1:=imin;
  n2:=imax;
  Fowned:= OwnedVectors;
  if initGraph.execution(ident+' properties',v1,v2,vS,n1,n2,autoLimit,Fowned) then
  begin
    if OwnedVectors and not Fowned then
    begin
      v1:=nil;
      v2:=nil;
      vs:=nil;
    end;

    OwnedVectors:= Fowned;

    if not OwnedVectors  then initdata(v1,v2,vS,n1,n2);
  end;
end;


function Tgraph.initialise(st:AnsiString):boolean;
var
  n1,n2:integer;
  v1,v2,vs:Tvector;
  Fowned: boolean;
begin
  inherited initialise(st);

  v1:=nil;
  v2:=nil;
  vs:=nil;
  n1:=0;
  n2:=0;
  if initGraph.execution('New graph:'+ident,v1,v2,vS,n1,n2,autoLimit,Fowned) then
  begin
    OwnedVectors:= Fowned;
    if not OwnedVectors  then initdata(v1,v2,vS,n1,n2);
    initialise:=true;
  end
  else initialise:=false;
end;

procedure Tgraph.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  FdumSave:=true;
  inherited buildInfo(conf,lecture,tout);

  conf.setvarConf('AutoLimit',AutoLimit,sizeof(AutoLimit));
  conf.setvarConf('Imin',Imin,sizeof(Imin));
  conf.setvarConf('Imax',Imax,sizeof(Imax));

  if FlagSave
    then conf.setvarConf('OwnedVectors',FdumSave,sizeof(FdumSave))
    else conf.setvarConf('OwnedVectors',FOwnedVectors,sizeof(FOwnedVectors));

  if lecture then
    begin
      conf.setvarConf('vecX',vec1b,sizeof(vecX));
      conf.setvarConf('vecY',vec2b,sizeof(vecY));
      conf.setvarConf('vecSigma',vecSb,sizeof(vecSigma));
    end
  else
    begin
      conf.setvarConf('vecX',vecX,sizeof(vecX));
      conf.setvarConf('vecY',vecY,sizeof(vecY));
      conf.setvarConf('vecSigma',vecSigma,sizeof(vecSigma));
    end;

end;


procedure TGraph.RetablirReferences(list:Tlist);
var
  i:integer;
  p:pointer;
begin
  if not OwnedVectors then
  for i:=0 to list.count-1 do
  begin
     p:=typeUO(list.items[i]).myAd;
     if p=vec1b then
       begin
         vecX:=list.items[i];
         refObjet(vecX);
       end;
     if p=vec2b then
       begin
         vecY:=list.items[i];
         refObjet(vecY);
       end;
     if p=vecSb then
       begin
         vecSigma:=list.items[i];
         refObjet(vecSigma);
       end;
  end;
end;

procedure Tgraph.resetAll;
begin
  if assigned(form) then TPform(form).invalidate;
end;

procedure Tgraph.processMessage(id:integer;source:typeUO;p:pointer);
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_invalidateData:
      begin
        if (vecX=source) or (vecY=source) or (vecSigma=source) then
          begin
            messageToRef(UOmsg_invalidate,nil);
            if assigned(form) then TPform(form).invalidate;
          end;
      end;


    UOmsg_destroy:
      begin
        if not OwnedVectors and ((vecX=source) or (vecY=source) or (vecSigma=source)) then
          begin
            if vecX=source then
              begin
                vecX:=nil;
                derefObjet(source);
              end;

            if vecY=source then
              begin
                vecY:=nil;
                derefObjet(source);
              end;

            if vecSigma=source then
              begin
                vecSigma:=nil;
                derefObjet(source);
              end;

            messageToRef(UOmsg_invalidate,nil);
            if assigned(form) then TPform(form).invalidate;
          end;
      end;

  end;
end;

procedure Tgraph.setOwnedVectors(w: boolean);
var
  vec: Tvector;
begin
  if w = FownedVectors then exit;
  FownedVectors:=w;

  if w then
  begin
    if assigned(vecX) then
    begin
      vec:= vecX;
      derefObjet(typeUO(vecX));
      typeUO(vecX):= vec.clone(true);
    end
    else vecX:= Tvector.create(t_single,1,0);

    if assigned(vecY) then
    begin
      vec:= vecY;
      derefObjet(typeUO(vecY));
      typeUO(vecY):= vec.clone(true);
    end
    else vecY:= Tvector.create(t_single,1,0);

    if assigned(vecSigma) then
    begin
      vec:= vecSigma;
      derefObjet(typeUO(vecSigma));
      typeUO(vecSigma):= vec.clone(true);
    end
    else vecSigma:= Tvector.create(t_single,1,0);

  end
  else
  begin
    vecX.Free;
    vecX:=nil;
    vecY.Free;
    vecY:=nil;
    vecSigma.Free;
    vecSigma:=nil;
  end;

  setChildNames;
  setChildList;

end;


procedure Tgraph.completeLoadInfo;
begin
  inherited;

end;

function Tgraph.loadFromStream(f: Tstream; size: LongWord; Fdata: boolean): boolean;
var
  st1,stID:AnsiString;
  LID:integer;
  posIni:LongWord;
  i,j:integer;

  vec:Tvector;
begin
  freeRef;
  OwnedVectors:= false;

  result:=inherited loadFromStream(f,size,false);
  if not result OR (f.position>=f.size) then exit;

  // on vient de charger FownedVectors + vec1b, vec2b, vecSb
  // de plus vecX, vecY et vecSigma valent nil;

  if OwnedVectors then     // les anciens fichiers contiennent false, les nouveaux true
  begin
    stID:=ident;
    LID:=length(ident);
    posIni:=f.position;

    for i:=1 to 3 do
    if result then
    begin
      st1:=readHeader(f,size);
      if (st1=Tvector.STMClassName) then
      begin
        vec:=Tvector.create;
        with vec do
        begin
          result:=loadFromStream(f,size,Fdata);
          result:=result and Fchild;
          result:=result and (copy(ident,1,LID)=stID);
          if result then
            case i of
              1: vecX:= vec;
              2: vecY:= vec;
              3: vecSigma:= vec;
            end
          else vec.Free;
        end;
      end;
    end;

    if not result then f.Position:=posini;
  end;
  setChildNames;
  setChildList;
end;



procedure Tgraph.saveToStream(f: Tstream; Fdata: boolean);
var
  vx,vy,vs: Tvector;
  oldX,oldY,oldS: AnsiString;
  oldChildX, oldChildY, oldChildS: boolean;
begin
  FlagSave:= Fdata;
  inherited;

  if OwnedVectors or Fdata then
  begin

    if assigned(vecX) then
    begin
      oldX:=vecX.ident;
      oldChildX:= vecX.Fchild;
      vx:= vecX;
    end
    else vx:= Tvector.create(t_single,0,-1);

    vx.Fchild:=true;
    vx.ident:= ident+'.vecX';

    if assigned(vecY) then
    begin
      oldY:=vecY.ident;
      oldChildY:= vecY.Fchild;
      vy:= vecY;
    end
    else vy:= Tvector.create(t_single,0,-1);

    vy.Fchild:=true;
    vy.ident:= ident+'.vecY';

    if assigned(vecSigma) then
    begin
      oldS:=vecSigma.ident;
      oldChildS:= vecSigma.Fchild;
      vs:= vecSigma;
    end
    else vs:= Tvector.create(t_single,0,-1);

    vs.Fchild:=true;
    vs.ident:= ident+'.vecSigma';

    try
    vx.saveToStream(f,Fdata);
    vy.saveToStream(f,Fdata);
    vs.saveToStream(f,Fdata);

    finally

    if assigned(vecX) then
    begin
      vecX.Fchild:= oldChildX;
      vecX.ident:= oldX;
    end
    else vx.Free;

    if assigned(vecY) then
    begin
      vecY.Fchild:= oldChildY;
      vecY.ident:= oldY;
    end
    else vy.Free;

    if assigned(vecSigma) then
    begin
      vecSigma.Fchild:= oldChildS;
      vecSigma.ident:= oldS;
    end
    else vs.Free;

    end;
  end;

  FlagSave:= false;
end;

function Tgraph.getIend: integer;
begin
  result:= Imax;
end;

function Tgraph.getIstart: integer;
begin
  result:=Imin;
end;

procedure Tgraph.setIend(w: integer);
begin
  Imax:= w;
end;

procedure Tgraph.setIstart(w: integer);
begin
  Imin:= w;
end;

procedure Tgraph.setChildNames;
begin
  if OwnedVectors then
  begin
    if assigned(vecX) then vecX.ident:= ident+'.vecX';
    if assigned(vecY) then vecY.ident:= ident+'.vecY';
    if assigned(vecSigma) then vecSigma.ident:= ident+'.vecSigma';
  end;

end;

procedure Tgraph.setChildList;
begin
  ClearChildList;
  if OwnedVectors then
  begin
    AddToChildList(vecX);
    AddToChildList(vecY);
    AddToChildList(vecSigma);
  end;
end;


{************************** Méthodes STM ***********************************}

procedure proTgraph_create(name:AnsiString;var Xvec,Yvec:Tvector;
                           ideb,ifin:longint;var pu:typeUO);
begin
  verifierObjet(typeUO(Xvec));
  verifierObjet(typeUO(Yvec));

  createPgObject(name,pu,Tgraph);

  with Tgraph(pu) do
  begin
    initData(Xvec,Yvec,nil,Ideb,Ifin);
  end;
end;

procedure proTgraph_create_1(var Xvec,Yvec:Tvector;
                           ideb,ifin:longint;var pu:typeUO);
begin
  proTgraph_create('',Xvec,Yvec, ideb,ifin, pu);
end;

procedure proTgraph_create_2(var pu:typeUO);
begin
  createPgObject('',pu,Tgraph);
  Tgraph(pu).OwnedVectors:=true;
end;



procedure proTgraph_modify(var Xvec,Yvec:Tvector;
                           iStart,iEnd:longint;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(Xvec));
  verifierObjet(typeUO(Yvec));
  Tgraph(pu).initData(Xvec,Yvec,nil,Istart,Iend);
end;

procedure proTgraph_setErrorData(var vec:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec));
  with Tgraph(pu) do initData(vecX,vecY,vec,Imin,Imax);
end;


procedure proTgraph_lineWidth(x:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  if x<=0 then sortieErreur(E_lineWidth);
  with Tgraph(pu) do visu.largeurTrait:=x;
end;

function fonctionTgraph_lineWidth(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  result:=Tgraph(pu).visu.largeurTrait;
end;

procedure proTgraph_AutoLimit(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tgraph(pu) do AutoLimit:=x;
end;

function fonctionTgraph_AutoLimit(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=Tgraph(pu).AutoLimit;
end;

procedure proTgraph_OwnedVectors(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  Tgraph(pu).OwnedVectors:= x;
end;

function fonctionTgraph_OwnedVectors(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=Tgraph(pu).OwnedVectors;
end;

function fonctionTgraph_VecX(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tgraph(pu) do
  if not OwnedVectors
    then result:= @vecX
    else sortieErreur('Tgraph.VecX : access allowed only when OwnedVectors = True');
end;

function fonctionTgraph_VecY(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tgraph(pu) do
  if not OwnedVectors
    then result:= @vecY
    else sortieErreur('Tgraph.VecY : access allowed only when OwnedVectors = True');
end;

function fonctionTgraph_VecSigma(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tgraph(pu) do
  if not OwnedVectors
    then result:= @vecSigma
    else sortieErreur('Tgraph.VecSigma : access allowed only when OwnedVectors = True');
end;



Initialization
  AffDebug('Initialization stmGraph',0);
  installError(E_symbolSize,'Tgraph: invalid symbol size');
  installError(E_lineWidth,'Tgraph: invalid line width');

  registerObject(Tgraph,data);
end.
