unit Stmpsth1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses Windows,math,
     classes,graphics,forms,controls,

     util1,Gdos,DdosFich,Dgraphic,Dgrad1,dtf0,Dtrace1,
     Dpalette,Ncdef2,formMenu,
     editcont,cood0, matCooD0,
     tpVector,

     debug0,
     stmDef,stmObj,defForm,
     getVect0,getMat0,visu0,
     inivect0,
     varconf1,
     stmDobj1,stmVec1,
     stmError,stmPg;

type
  TPsth=        class(TVector)
                  CountA: integer; {Sert pour la sauvegarde }
                  Count:integer;
                  inHz:boolean;

                  lastI1,lastI2:integer;
                  class function STMClassName:AnsiString;override;

                  procedure initTemp(n1,n2:longint;tNombre:typeTypeG;
                                 Lclasse:float);

                  Procedure Add(vec:Tvector);
                  Procedure AddEx(vec:Tvector;Xorg:float;const im1:integer=0;const im2:integer=-1);
                  Procedure AddEx1(vec:Tvector;Xorg:float);
                  Procedure AddSqr(vec:Tvector);
                  Procedure AddSqrEx(vec:Tvector;Xorg:float);
                  Procedure setInHz(x:boolean);

                  procedure reset;
                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                  procedure proprietes(sender:Tobject);override;
                  function loadData(f:Tstream):boolean;override;
                end;

  Tcorrelogram= class(Tpsth)
                  class function STMClassName:AnsiString;override;

                  Procedure Add(vec1,vec2:Tvector;x1,x2:float);
                  Procedure Add1(vec1,vec2:Tvector;x1,x2:float);

                end;



{***************** Déclarations STM pour Tpsth *****************************}

procedure proTpsth_create(name:AnsiString;t:integer;n1,n2:longint;
                          Lclasse:float;var pu:typeUO);pascal;
procedure proTpsth_create_1(t:integer;n1,n2:longint; Lclasse:float;var pu:typeUO);pascal;

procedure proTpsth_modify(t:integer;n1,n2:longint;
                          Lclasse:float;var pu:typeUO);pascal;


Procedure proTPsth_Add(var p, pu:typeUO); pascal;
Procedure proTPsth_AddEx(var p:typeUO;xorg:float;var pu:typeUO); pascal;
Procedure proTPsth_AddSqr(var p, pu:typeUO); pascal;


procedure proTPsth_reset(var pu:typeUO);pascal;

procedure proTPsth_InHz(x:boolean;var pu:typeUO);pascal;
function fonctionTPsth_inHz(var pu:typeUO):boolean;pascal;

procedure proTPsth_count(x:longint;var pu:typeUO);pascal;
function fonctionTPsth_Count(var pu:typeUO):longint;pascal;

procedure proTPsth_BinWidth(x:float;var pu:typeUO);pascal;
function fonctionTPsth_BinWidth(var pu:typeUO):float;pascal;

procedure proTcorrelogram_create(name:AnsiString;t:smallint;n1,n2:longint;
                          Lclasse:float;var pu:typeUO);pascal;
procedure proTcorrelogram_create_1(t:smallint;n1,n2:longint; Lclasse:float;var pu:typeUO);pascal;


Procedure proTcorrelogram_Add(var p1,p2:typeUO;x1,x2:float;var pu:typeUO);pascal;
Procedure proTcorrelogram_Add1(var p1,p2:typeUO;x1,x2:float;var pu:typeUO);pascal;

IMPLEMENTATION


{********************** Méthodes de TPsth ****************************}

class function Tpsth.STMClassName:AnsiString;
begin
  STMClassName:='Psth';
end;

procedure Tpsth.initTemp(n1,n2:longint;tNombre:typeTypeG;Lclasse:float);
begin
  inherited initTemp1(n1,n2,tNombre);
  dxu:=Lclasse;
  visu.modeT:=dm_histo0;
end;

Procedure TPsth.Add(vec:Tvector);
var
  data1:typedataB;
  i,k:integer;
begin
  if not assigned(vec) or not assigned(data) or not assigned(vec.data) then exit;

  data1:=vec.data;

  for i:=data1.indicemin to data1.indicemax do
    begin
      k:=floor((data1.getE(i)-data.bx)/data.ax);
      if (k>=data.indiceMin) and (k<=data.indiceMax)
              then data.addI(k,1);
    end;

  inc(count);
  visu.ux:=vec.visu.ux;
  setInHz(inHz);
  invalidate;
end;

Procedure TPsth.AddEx(vec:Tvector;Xorg:float;const im1:integer=0;const im2:integer=-1);
var
  data1:typedataB;
  i,i1,i2,k:integer;
  dataImin, dataImax, data1Imin, data1Imax: integer;
begin
  if not assigned(vec) or not assigned(data) or not assigned(vec.data) then exit;

  data1:=vec.data;

  dataImin:= data.indiceMin;
  dataImax:= data.indiceMax;
  data1Imin:= data1.indiceMin;
  data1Imax:= data1.indiceMax;

  if im2>=im1 then
  begin
    xorg:=X0u+Xorg;

    for i:=im1 to im2 do
      begin
        k:=floor((data1.getE(i)-Xorg)/data.ax);
        if (k>=dataIMin) then
        begin
          if (k<=dataIMax)
            then data.addI(k,1)
            else break;
        end;
      end;

  end
  else
  begin
    if (lastI1>=vec.Istart) and (lastI1<=vec.Iend) and (vec[lastI1]<=Xorg+Xstart)
      then i1:=lastI1
      else i1:=vec.Istart;

    if (lastI2>=vec.Istart) and (lastI2<=vec.Iend) and  (vec[lastI2]>=Xorg+Xend)
      then i2:=lastI2
      else i2:=vec.Iend;

    {lastI1:=vec.getFirstEvent(Xorg+Xstart,I1,I2);}

    xorg:=X0u+Xorg;

    lastI1:=-1;
    for i:=i1 to data1Imax do
      begin
        k:=floor((data1.getE(i)-Xorg)/data.ax);
        if (k>=dataIMin) then
        begin
          if lastI1=-1 then lastI1:=i;
          if (k<=dataIMax)
            then data.addI(k,1)
            else
            begin
              lastI2:=i-1;
              break;
            end;
        end;
      end;
  end;
  inc(count);
  visu.ux:=vec.visu.ux;
  setInHz(inHz);
  invalidate;
end;

{Attention: pas de rapport avec Taverage.addEx1
 Utilisé dans stmMatU1 JPcont, JPmixte, etc...
}

Procedure TPsth.AddEx1(vec:Tvector;Xorg:float);
var
  data1:typedataB;
  i,k:integer;
begin
  if not assigned(vec) or not assigned(data) or not assigned(vec.data) then exit;

  data1:=vec.data;

  xorg:=data.bx+Xorg;

  for i:=data1.indicemin to data1.indicemax do
    begin
      k:=floor((data1.getE(i)-Xorg)/data.ax);
      if (k>=0) and (k<=data.indiceMax) then   {On ne garde que le premier ev avec k>=0}
      begin
        data.addI(k,1);
        break;
      end;
    end;

  inc(count);
  visu.ux:=vec.visu.ux;
  setInHz(inHz);
  invalidate;
end;



Procedure TPsth.AddSqr(vec:Tvector);
var
  data1:typedataB;
  i,k:integer;
  k0,nb0:integer;
begin
  if not assigned(vec) or not assigned(data) or not assigned(vec.data) then exit;

  data1:=vec.data;

  k0:=data.indiceMin-1;
  nb0:=0;

  for i:=data1.indicemin to data1.indicemax do
    begin
      k:=floor((data1.getE(i)-data.bx)/data.ax);
      if k<>k0 then
        begin
          if (k0>=data.indiceMin) and (k0<=data.indiceMax) then data.addI(k0,sqr(nb0));
          k0:=k;
          nb0:=0;
        end;
      inc(nb0);
    end;

  if (k0>=data.indiceMin) and (k0<=data.indiceMax) then data.addI(k0,sqr(nb0));

  inc(count);
  visu.ux:=vec.visu.ux;
  setInHz(inHz);
end;

Procedure TPsth.AddSqrEx(vec:Tvector;Xorg:float);
var
  data1:typedataB;
  i,k:integer;
  k0,nb0:integer;
begin
  if not assigned(vec) or not assigned(data) or not assigned(vec.data) then exit;

  data1:=vec.data;

  xorg:=data.bx+Xorg;

  k0:=data.indiceMin-1;
  nb0:=0;

  for i:=data1.indicemin to data1.indicemax do
    begin
      k:=floor((data1.getE(i)-Xorg)/data.ax);
      if k<>k0 then
        begin
          if (k0>=data.indiceMin) and (k0<=data.indiceMax) then data.addI(k0,sqr(nb0));
          k0:=k;
          nb0:=0;
        end;
      inc(nb0);
    end;

  if (k0>=data.indiceMin) and (k0<=data.indiceMax) then data.addI(k0,sqr(nb0));

  inc(count);
  visu.ux:=vec.visu.ux;
  setInHz(inHz);
end;



Procedure TPsth.setInHz(x:boolean);
  begin
    inHz:=x;
    if inHz and (count>0) then
      begin
        if visu.ux='sec'
          then dyu:=1/dxu/count
          else dyu:=1/dxu/count*1000;
      end
    else dyu:=1;

    if inHz then visu.uy:='Hz' else visu.uy:='';
  end;


procedure TPsth.reset;
  begin
    count:=0;
    if data<>nil then data.raz;
  end;

function TPsth.loadData(f: Tstream): boolean;
begin
  result:= inherited loadData(f);
  if result then count:=countA
end;

procedure Tpsth.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setvarConf('InHz',InHz,sizeof(InHz));
    if lecture then
    begin
      setvarConf('CountA',CountA,sizeof(CountA));
      CountA:=0;
    end
    else setvarConf('CountA',Count,sizeof(Count));
    { en lecture Count est chargé dans CountA
      CountA est copié dans Count uniquement par loadData
    }

  end;
end;

{********************** Méthodes de Tcorrelogram ****************************}

class function Tcorrelogram.STMClassName:AnsiString;
begin
  STMClassName:='Correlogram';
end;

Procedure Tcorrelogram.Add(vec1,vec2:Tvector;x1,x2:float);
var
  i,j,k,j1:integer;
  x,vi,vj,min,max,diff,Lclasse:float;

  data1,data2:typedataB;
begin
  if not assigned(data) or
     not assigned(vec1) or not assigned(vec1.data) or (vec1.Iend<vec1.Istart) or
     not assigned(vec2) or not assigned(vec2.data) {or (vec2.Iend<vec2.Istart)}
      then exit;

  data1:=vec1.data;
  data2:=vec2.data;

  min:=data.indiceMin;
  max:=data.indiceMax;
  diff:=data.indiceMin*data.ax;
  Lclasse:=data.ax;

  j1:=data2.indicemin;

  for i:=data1.indiceMin{getFirst(x1)} to data1.indiceMax do
    begin
      j:=j1;
      vi:=data1.getE(i);
      if (vi>=x1) and (vi<=x2) then
        begin
          inc(count);
          while (j<=data2.indicemax) and
                  (data2.getE(j)-vi<Diff) do inc(j);
          j1:=j;
          if (j<=data2.indicemax) then x:=(data2.getE(j)-vi)/Lclasse;
          while (j<=data2.indicemax) and (x<Max+1) do
          begin
            k:=floor(x);
            vj:=data2.getE(j);
            if (vj>=x1) and (vj<=x2) and (k>=min) and (k<=max) then data.addI(k,1);
            inc(j);
            x:=(data2.getE(j)-vi)/Lclasse;
          end;
        end
      else
      if vi>x2 then break;
    end;

  visu.ux:=vec1.visu.ux;

  setInHz(inHz);
end;

Procedure Tcorrelogram.Add1(vec1,vec2:Tvector;x1,x2:float);
var
  i,j,k,j1:integer;
  x,vi,vj,min,max,diff,Lclasse:float;

  data1,data2:typedataB;
  tb:Ptablong;

begin
  if not assigned(data) or
     not assigned(vec1) or not assigned(vec1.data) or
     not assigned(vec2) or not assigned(vec2.data)
      then exit;

  getmem(tb,(Iend-Istart+1)*sizeof(longint));
  fillchar(tb^,(Iend-Istart+1)*sizeof(longint),0);

  data1:=vec1.data;
  data2:=vec2.data;

  min:=data.indiceMin;
  max:=data.indiceMax;
  diff:=data.indiceMin*data.ax;
  Lclasse:=data.ax;

  j1:=data2.indicemin;

  for i:=vec1.getFirstEvent(x1) to data1.indiceMax do
    begin
      j:=j1;
      vi:=data1.getE(i);
      if (vi>=x1) and (vi<=x2) then
        begin
          inc(count);
          while (j<=data2.indicemax) and
                  (data2.getE(j)-vi<Diff) do inc(j);
          j1:=j;
          x:=(data2.getE(j)-vi)/Lclasse;
          while (j<=data2.indicemax) and (x<Max+1) do
          begin
            k:=floor(x);
            vj:=data2.getE(j);
            if (vj>=x1) and (vj<=x2) and (k>=min) and (k<=max) then inc(tb^[k-Istart]);
            inc(j);
            x:=(data2.getE(j)-vi)/Lclasse;
          end;
        end
      else
      if vi>x2 then break;
    end;

  visu.ux:=vec1.visu.ux;

  for i:=0 to Iend-Istart do
    Yvalue[Istart+i]:=Yvalue[Istart+i]+tb^[i]/(x2-x1-i*dxu)*(x2-x1);

  freemem(tb,(Iend-Istart+1)*4);

  setInHz(inHz);
end;

procedure TPsth.proprietes(sender: Tobject);
begin
  propVector('Count= '+Istr(count));
end;


{*********************** Méthodes STM pour Tpsth ********************}


var
  E_indexOrder:integer;

procedure proTpsth_create(name:AnsiString;t:integer;n1,n2:longint;
                          Lclasse:float;var pu:typeUO);
  begin
    if not (typeTypeG(t) in typesVecteursSupportes)
      then sortieErreur(E_parametre);

    if n2<n1-1 then  sortieErreur(E_indexOrder);
    createPgObject(name,pu,Tpsth);

    with Tpsth(pu) do
    begin
      initTemp(n1,n2,TypetypeG(t),Lclasse);
    end;
  end;

procedure proTpsth_create_1(t:integer;n1,n2:longint; Lclasse:float;var pu:typeUO);
begin
  proTpsth_create('',t,n1,n2,Lclasse,pu);
end;

procedure proTpsth_modify(t:integer;n1,n2:longint;
                          Lclasse:float;var pu:typeUO);
  begin
    if not (typeTypeG(t) in typesVecteursSupportes)
      then sortieErreur(E_parametre);

    if n2<n1-1 then  sortieErreur(E_indexOrder);
    with Tpsth(pu) do
    begin
      initTemp(n1,n2,TypetypeG(t),Lclasse);
      reset;
    end;
  end;


Procedure proTPsth_Add(var p, pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(p);

    Tpsth(pu).add(Tvector(p));
  end;

Procedure proTPsth_AddEx(var p:typeUO;xorg:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(p);

    Tpsth(pu).addEx(Tvector(p),xorg);
  end;

Procedure proTPsth_AddSqr(var p, pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(p);

    Tpsth(pu).addSqr(Tvector(p));
  end;


procedure proTPsth_reset(var pu:typeUO);
  begin
    verifierObjet(pu);
    Tpsth(pu).reset;
  end;

procedure proTPsth_InHz(x:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tpsth(pu).setInHz(x);
  end;

function fonctionTPsth_inHz(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    fonctionTPsth_inHz:=Tpsth(pu).inHz;
  end;

procedure proTPsth_count(x:longint;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tpsth(pu).count:=x;
  end;

function fonctionTPsth_Count(var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    fonctionTPsth_Count:=Tpsth(pu).count;
  end;

procedure proTPsth_BinWidth(x:float;var pu:typeUO);
  begin
    proTdataObject_Dx(x,pu);
  end;

function fonctionTPsth_BinWidth(var pu:typeUO):float;
  begin
    fonctionTPsth_BinWidth:=fonctionTdataObject_Dx(pu);
  end;


{*********************** Méthodes STM pour Tcorrelogram ********************}

procedure proTcorrelogram_create(name:AnsiString;t:smallint;n1,n2:longint;
                          Lclasse:float;var pu:typeUO);
  begin
    if not (typeTypeG(t) in typesVecteursSupportes)
      then sortieErreur(E_parametre);

    createPgObject(name,pu,Tcorrelogram);

    with Tcorrelogram(pu) do
    begin
      initTemp(n1,n2,TypetypeG(t),Lclasse);
    end;
  end;

procedure proTcorrelogram_create_1(t:smallint;n1,n2:longint;Lclasse:float;var pu:typeUO);
begin
  proTcorrelogram_create('',t,n1,n2,Lclasse,pu);
end;

Procedure proTcorrelogram_Add(var p1,p2:typeUO;x1,x2:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(p1);
    verifierObjet(p2);

    with Tcorrelogram(pu) do add(Tvector(p1),Tvector(p2),x1,x2);
  end;

Procedure proTcorrelogram_Add1(var p1,p2:typeUO;x1,x2:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(p1);
    verifierObjet(p2);

    with Tcorrelogram(pu) do add1(Tvector(p1),Tvector(p2),x1,x2);
  end;




Initialization
AffDebug('Initialization Stmpsth1',0);

installError(E_indexOrder,'Tpsth: start index must be lower than end index');
{installError(E_dataEvExpected,'TPsth: Event data expected');}

registerObject(Tpsth,data);
registerObject(Tcorrelogram,data);


end.
