unit stmMatAve1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses windows,
     classes,graphics,forms,controls,

     util1,Gdos,DdosFich,Dgraphic,Dgrad1, dtf0, debug0,
     Dpalette,Ncdef2,formMenu,
     editcont,cood0, matCooD0,
     tpVector,

     stmDef,stmObj,defForm,
     getVect0,visu0,
     inivect0,
     varconf1,
     stmMat1,
     stmError,stmPg;

type
  TmatAverage=  class(Tmatrix)
                  Count:longint;
                  Sqrs,stdDev,stdUp,stdDw:Tmatrix;
                  FStdOn:boolean;

                  constructor create;override;
                  destructor destroy;override;

                  class function STMClassName:AnsiString;override;
                  function initialise(st:AnsiString):boolean;override;

                  procedure setChildNames;override;
                  procedure setChilds;

                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                  procedure saveToStream(f:Tstream;Fdata:boolean);override;
                  function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;

                  procedure Proprietes(sender:Tobject);override;
                  function loadFromStream1(f:Tstream;size:LongWord;Fdata:boolean):boolean;


                  Procedure Add0(mat:Tmatrix;complet:boolean);
                  Procedure Add(mat:Tmatrix);
                  Procedure Add1(mat:Tmatrix);

                  Procedure Sub0(mat:Tmatrix;complet:boolean);
                  Procedure Sub(mat:Tmatrix);
                  Procedure Sub1(mat:Tmatrix);

                  procedure updateStdDev;

                  Procedure AddEx0(mat:Tmatrix;Xorg,Yorg:float;complet:boolean);
                  Procedure AddEx(mat:Tmatrix;Xorg,Yorg:float);
                  Procedure AddEx1(mat:Tmatrix;Xorg,Yorg:float);


                  procedure reset;
                  procedure clear;override;

                  procedure setStdON(w:boolean);
                  property stdOn:boolean read FstdOn write setStdON;

                  procedure modify(tNombre:typeTypeG;i1,j1,i2,j2:integer);override;
                end;



{***************** Déclarations STM pour TmatAverage *****************************}
procedure proTmatAverage_create(name:AnsiString;t:smallint;n1,n2,m1,m2:longint;var pu:typeUO);pascal;
procedure proTmatAverage_create_1(t:smallint;n1,n2,m1,m2:longint;var pu:typeUO);pascal;

Procedure proTmatAverage_Add(var p, pu:typeUO); pascal;
Procedure proTmatAverage_AddEx(var p:typeUO;xorg,yorg:float;var pu:typeUO); pascal;

Procedure proTmatAverage_Add1(var p, pu:typeUO); pascal;
Procedure proTmatAverage_UpdateStdDev(var pu:typeUO); pascal;

procedure proTmatAverage_reset(var pu:typeUO);pascal;

procedure proTmatAverage_count(x:longint;var pu:typeUO);pascal;
function fonctionTmatAverage_Count(var pu:typeUO):longint;pascal;


procedure proTmatAverage_StdOn(w:boolean;var pu:typeUO); pascal;
function fonctionTmatAverage_StdOn(var pu:typeUO):boolean; pascal;

function fonctionTmatAverage_MSqrs(var pu:typeUO):Tmatrix;pascal;
function fonctionTmatAverage_MstdDev(var pu:typeUO):Tmatrix;pascal;
function fonctionTmatAverage_MStdUp(var pu:typeUO):Tmatrix;pascal;
function fonctionTmatAverage_MStdDw(var pu:typeUO):Tmatrix;pascal;

IMPLEMENTATION


{********************** Méthodes de TmatAverage ****************************}

constructor TmatAverage.create;
begin
  inherited;

  Sqrs:=Tmatrix.create;
  stdDev:=Tmatrix.create;
  stdUp:=Tmatrix.create;
  stdDw:=Tmatrix.create;

  Sqrs.Flags.Findex:=false;
  Sqrs.Flags.Ftype:=false;
  StdDev.Flags.Findex:=false;
  StdDev.Flags.Ftype:=false;
  StdUp.Flags.Findex:=false;
  StdUp.Flags.Ftype:=false;
  StdDw.Flags.Findex:=false;
  StdDw.Flags.Ftype:=false;

  stdON:=false;

  setChilds;

  AddTochildList(sqrs);
  AddTochildList(stdDev);
  AddTochildList(stdUp);
  AddTochildList(stdDw);

end;

destructor TmatAverage.destroy;
begin
  Sqrs.free;
  stdDev.free;
  stdUp.free;
  stdDw.free;

  inherited;
end;

class function TmatAverage.STMClassName:AnsiString;
begin
  STMClassName:='MatAverage';
end;

function TmatAverage.initialise(st:AnsiString):boolean;
begin
  result:= inherited initialise(st);
  if result then setChilds;
end;


procedure TmatAverage.setChildNames;
var
  i:integer;
begin
  with Sqrs do
  begin
    ident:=self.ident+'.Msqrs';
    title:=ident;
    notPublished:=true;
    Fchild:=true;
  end;

  with stdDev do
  begin
    ident:=self.ident+'.MstdDev';
    title:=ident;
    notPublished:=true;
    Fchild:=true;
  end;

  with stdUp do
  begin
    ident:=self.ident+'.MstdUp';
    title:=ident;
    notPublished:=true;
    Fchild:=true;
  end;

  with stdDw do
  begin
    ident:=self.ident+'.MstdDw';
    title:=ident;
    notPublished:=true;
    Fchild:=true;
  end;
end;


procedure TmatAverage.setChilds;
begin
  setChildNames;

  Sqrs.visu.color:=clBlue;
  stdDev.visu.color:=clBlue;
  stdUp.visu.color:=clGreen;
  stdDw.visu.color:=clGreen;
end;


procedure TmatAverage.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;

  with conf do
    setvarconf('Count',count,sizeof(count));
end;


procedure TmatAverage.saveToStream(f:Tstream;Fdata:boolean);
var
  i,old:integer;
begin
  old:=count;
  if not Fdata then
    count:=0;
  inherited saveToStream(f,Fdata);
  count:=old;

  Sqrs.saveToStream(f,Fdata);
  stdDev.saveToStream(f,Fdata);
  stdUp.saveToStream(f,Fdata);
  stdDw.saveToStream(f,Fdata);
end;

function TmatAverage.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
  var
    st1:string[255];
    posf:LongWord;
    ok:boolean;
    posIni:LongWord;
    i:integer;
  begin
    ok:=inherited loadFromStream(f,size,Fdata);
    result:=ok;

    if not Fdata then count:=0;

    if not ok then
    begin
      setChilds;
      exit;
    end;

    if f.position>=f.Size  then
      begin
        result:=true;
        exit;
      end;

    posIni:=f.position;
    st1:=readHeader(f,longWord(size));
    ok:=(st1=Tmatrix.stmClassName) and
        (Sqrs.loadFromStream(f,size,Fdata)) and
        (Sqrs.NotPublished);
    if not ok then
      begin
        f.Position:=Posini;
        result:=ok;
        setChilds;
        exit;
      end;

    posIni:=f.position;
    st1:=readHeader(f,longWord(size));
    ok:=(st1=Tmatrix.stmClassName) and
        (stdDev.loadFromStream(f,size,Fdata)) and
        (stdDev.NotPublished);
    if not ok then
      begin
        f.Position:=Posini;
        result:=ok;
        setChilds;
        exit;
      end;

    posIni:=f.position;
    st1:=readHeader(f,longWord(size));
    ok:=(st1=Tmatrix.stmClassName) and
        (stdUp.loadFromStream(f,size,Fdata)) and
        (stdUp.NotPublished);
    if not ok then
      begin
        f.Position:= Posini;
        result:=ok;
        setChilds;
        exit;
      end;

    posIni:=f.position;
    st1:=readHeader(f,longWord(size));
    ok:=(st1=Tmatrix.stmClassName) and
        (stdDw.loadFromStream(f,size,Fdata)) and
        (stdDw.NotPublished);
    if not ok then
      begin
        f.Position:=Posini;
        result:=ok;
        setChilds;
        exit;
      end;

    setChilds;
    result:=ok;
  end;


function TmatAverage.loadFromStream1(f:Tstream;size:LongWord;Fdata:boolean):boolean;
begin
  result:=inherited loadFromStream(f,size,Fdata);
  setChilds;
end;


Procedure TmatAverage.Add0(mat:Tmatrix;complet:boolean);
var
  i,j,i1,i2,j1,j2:integer;
begin
  if not assigned(mat) or not assigned(data) or not assigned(mat.data) then exit;

  i1:=Istart;
  i2:=Iend;
  j1:=Jstart;
  j2:=Jend;

  if count=0 then
    begin
      if (i1<>mat.Istart) or (i2<>mat.Iend) or (j1<>mat.Jstart) or (j2<>mat.Jend) then
        begin
          i1:=mat.Istart;
          i2:=mat.Iend;
          j1:=mat.Jstart;
          j2:=mat.Jend;

          initTemp(i1,i2,j1,j2,tpNum);
          if stdOn then setStdOn(true);
        end;

      dxu:=mat.dxu;
      x0u:=mat.x0u;
      dyu:=mat.dyu;
      y0u:=mat.y0u;
      if tpNum<g_single then
      begin
         dzu:=mat.Dzu;
         z0u:=mat.z0u;
      end;
    end
  else
    begin
      if i1<mat.Istart then i1:=mat.Istart;
      if i2>mat.Iend then i2:=mat.Iend;
      if j1<mat.Jstart then j1:=mat.Jstart;
      if j2>mat.Jend then j2:=mat.Jend;
    end;

  inc(count);
  for i:=i1 to i2 do
  for j:=j1 to j2 do
    data.setE(i,j,((count-1)*data.getE(i,j)+mat.data.getE(i,j))/count );

  if iscomplex then
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      data.setIm(i,j,((count-1)*data.getIm(i,j)+mat.data.getIm(i,j))/count );

  visu.ux:=mat.visu.ux;

  { Rappel stdDev= sqrt((sx2-sqr(Sx)/N)/(N-1)); }

  if stdON  then
  begin
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      sqrs.data.setE(i,j,sqrs.data.getE(i,j)+sqr(mat.data.getE(i,j)));

    if isComplex then
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      sqrs.data.setE(i,j,sqrs.data.getE(i,j)+sqr(mat.data.getIm(i,j)));
    if complet then updateStdDev;
  end;

  invalidate;
end;

procedure TmatAverage.updateStdDev;
var
  i,j:integer;
begin
  if stdON  and (count>1) then
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
    begin
      stdDev.data.setE(i,j, sqrs.data.getE(i,j)-sqr(data.getE(i,j))*count) ;

      if isComplex then
      stdDev.data.setE(i,j, stdDev.data.getE(i,j)-sqr(data.getIm(i,j))*count);

      stdDev.data.setE(i,j,sqrt( abs(stdDev.data.getE(i,j)/(count-1))));

      stdUp.data.setE(i,j,data.getE(i,j)+stdDev.data.getE(i,j) );
      stdDw.data.setE(i,j,data.getE(i,j)-stdDev.data.getE(i,j) );

      if isComplex then
      begin
        stdUp.data.setIm(i,j,data.getIm(i,j)+stdDev.data.getE(i,j) );
        stdDw.data.setIm(i,j,data.getIm(i,j)-stdDev.data.getE(i,j) );
      end;
    end;
end;


Procedure TmatAverage.Add(mat:Tmatrix);
begin
  add0(mat,true);
end;

Procedure TmatAverage.Add1(mat:Tmatrix);
begin
  add0(mat,false);
end;

Procedure TmatAverage.Sub0(mat:Tmatrix;complet:boolean);
var
  i,j,i1,i2,j1,j2:integer;
begin
  if not assigned(mat) or not assigned(data) or not assigned(mat.data) then exit;
  if count=0 then exit;

  i1:=Istart;
  i2:=Iend;
  j1:=Jstart;
  j2:=Jend;

  if i1<mat.Istart then i1:=mat.Istart;
  if i2>mat.Iend then i2:=mat.Iend;
  if j1<mat.Jstart then j1:=mat.Jstart;
  if j2>mat.Jend then j2:=mat.Jend;

  dec(count);
  for i:=i1 to i2 do
  for j:=j1 to j2 do
    data.setE(i,j,((count+1)*data.getE(i,j)-mat.data.getE(i,j))/count );

  if iscomplex then
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      data.setIm(i,j,((count+1)*data.getIm(i,j)-mat.data.getIm(i,j))/count );

  visu.ux:=mat.visu.ux;

  { Rappel stdDev= sqrt((sx2-sqr(Sx)/N)/(N-1)); }

  if stdON  then
  begin
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      sqrs.data.setE(i,j,sqrs.data.getE(i,j)-sqr(mat.data.getE(i,j)));

    if isComplex then
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      sqrs.data.setE(i,j,sqrs.data.getE(i,j)-sqr(mat.data.getIm(i,j)));

    if complet then updateStdDev;
  end;

  invalidate;
end;

Procedure TmatAverage.sub(mat:Tmatrix);
begin
  sub0(mat,true);
end;

Procedure TmatAverage.sub1(mat:Tmatrix);
begin
  sub0(mat,false);
end;



Procedure TmatAverage.AddEx0(mat:Tmatrix;Xorg,Yorg:float;complet:boolean);
var
  i,j,i0,j0,i1,i2,j1,j2:integer;
begin

  if not assigned(mat) or not assigned(data) or not assigned(mat.data) then exit;

  i0:=mat.invconvx(Xorg);
  j0:=mat.invconvy(Yorg);

  i1:=Istart;
  i2:=Iend;
  j1:=Jstart;
  j2:=Jend;

  if i1+i0<mat.Istart then i1:=mat.Istart-i0;
  if i2+i0>mat.Iend then i2:=mat.Iend-i0;
  if j1+j0<mat.Jstart then j1:=mat.Jstart-j0;
  if j2+j0>mat.Jend then j2:=mat.Jend-j0;

  if count=0 then
    begin
      dxu:=mat.dxu;
      dyu:=mat.Dyu;

      if tpNum<g_single then
      begin
         dzu:=mat.Dzu;
         z0u:=mat.Z0u;
      end;
    end;

  inc(count);

  (*
  if (tpnum=g_double) and (mat.inf.temp) and (mat.tpNum=g_double) and initISPL then
  begin
    nspdbMpy1(count-1,@PtabDouble(tb)^[i1-Istart],i2-i1+1);
    nspdbAdd2(@PtabDouble(mat.tb)^[i0+i1-mat.Istart] , @PtabDouble(tb)^[i1-Istart], i2-i1+1);
    nspdbMpy1(1/count,@PtabDouble(tb)^[i1-Istart],i2-i1+1);
  end
  else
  *)
  for i:=i1 to i2 do
  for j:=j1 to j2 do
    data.setE(i,j,((count-1)*data.getE(i,j)+mat.data.getE(i+i0,j+j0))/count );

  if isComplex then
  for i:=i1 to i2 do
  for j:=j1 to j2 do
    data.setIm(i,j,((count-1)*data.getIm(i,j)+mat.data.getIm(i+i0,j+j0))/count );

  visu.ux:=mat.visu.ux;
  visu.uy:=mat.visu.uy;

  if stdON then
  begin
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      sqrs.data.setE(i,j,sqrs.data.getE(i,j)+sqr(mat.data.getE(i+i0,j+j0)));

    if isComplex then
    for i:=i1 to i2 do
    for j:=j1 to j2 do
      sqrs.data.setE(i,j,sqrs.data.getE(i,j)+sqr(mat.data.getIm(i,j)));

    if complet then updateStdDev;
  end;

  invalidate;
end;

Procedure TmatAverage.AddEx(mat:Tmatrix;Xorg,Yorg:float);
begin
  addEx0(mat,Xorg,Yorg,true);
end;

Procedure TmatAverage.AddEx1(mat:Tmatrix;Xorg,Yorg:float);
begin
  addEx0(mat,Xorg,Yorg,false);
end;


procedure TmatAverage.reset;
begin
  count:=0;
  inherited clear;

  sqrs.clear;
  stdDev.clear;
  stdUp.clear;
  stdDw.clear;
end;

procedure TmatAverage.clear;
begin
  reset;
end;

procedure TmatAverage.setStdON(w:boolean);
begin
  FstdOn:=w;
  if w then
    begin
      sqrs.initTemp(Istart,Iend,Jstart,Jend,G_extended);
      stdDev.initTemp(Istart,Iend,Jstart,Jend,inf.tpNum);
      stdUp.initTemp(Istart,Iend,Jstart,Jend,inf.tpNum);
      stdDw.initTemp(Istart,Iend,Jstart,Jend,inf.tpNum);
    end
  else
    begin
      sqrs.initTemp(0,0,0,0,G_extended);
      stdDev.initTemp(0,0,0,0,inf.tpNum);
      stdUp.initTemp(0,0,0,0,inf.tpNum);
      stdDw.initTemp(0,0,0,0,inf.tpNum);
    end;

  sqrs.dxu:=dxu;
  sqrs.x0u:=x0u;
  sqrs.dyu:=dyu;
  sqrs.y0u:=y0u;
  sqrs.dzu:=dzu;
  sqrs.z0u:=z0u;

  sqrs.cpx:=cpx;
  sqrs.cpy:=cpy;

  stdDev.dxu:=dxu;
  stdDev.x0u:=x0u;
  stdDev.dyu:=dyu;
  stdDev.y0u:=y0u;
  stdDev.dzu:=dzu;
  stdDev.z0u:=z0u;

  stdDev.cpx:=cpx;
  stdDev.cpy:=cpy;

  stdUp.dxu:=dxu;
  stdUp.x0u:=x0u;
  stdUp.dyu:=dyu;
  stdUp.y0u:=y0u;
  stdUp.dzu:=dzu;
  stdUp.z0u:=z0u;

  stdUp.cpx:=cpx;
  stdUp.cpy:=cpy;
  stdUp.cpz:=cpz;

  stdDw.dxu:=dxu;
  stdDw.x0u:=x0u;
  stdDw.dyu:=dyu;
  stdDw.y0u:=y0u;
  stdDw.dzu:=dzu;
  stdDw.z0u:=z0u;

  stdDw.cpx:=cpx;
  stdDw.cpy:=cpy;
  stdDw.cpz:=cpz;
end;



procedure TmatAverage.modify(tNombre:typeTypeG;i1,j1,i2,j2:integer);
begin
  clear;
  inherited;

  setStdOn(FStdON);
end;


procedure TmatAverage.Proprietes(sender: Tobject);
begin
  matProp('Count= '+Istr(count));
end;


{*********************** Méthodes STM pour TmatAverage ********************}


procedure proTmatAverage_create(name:AnsiString;t:smallint;n1,n2,m1,m2:longint;
                             var pu:typeUO);
begin
  if not TmatAverage.supportType(typeTypeG(t))
      then sortieErreur('TmatAverage.create: Type not supported');
  if n1>n2 then  sortieErreur('TmatAverage: start index must be lower than end index');

  createPgObject(name,pu,TmatAverage);

  with TmatAverage(pu) do
  begin
    title:=ident;
    setChilds;
    initTemp(n1,n2,m1,m2,TypetypeG(t));
  end;
end;

procedure proTmatAverage_create_1(t:smallint;n1,n2,m1,m2:longint;var pu:typeUO);
begin
  proTmatAverage_create('',t,n1,n2,m1,m2,pu);
end;

procedure proTmatAverage_StdOn(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TmatAverage(pu).setStdON(w);
end;

function fonctionTmatAverage_StdOn(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TmatAverage(pu).stdOn;
end;



Procedure proTmatAverage_Add(var p, pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(p);

    TmatAverage(pu).add(Tmatrix(p));
  end;

Procedure proTmatAverage_Add1(var p, pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(p);

    TmatAverage(pu).add1(Tmatrix(p));
  end;

Procedure proTmatAverage_UpdateStdDev(var pu:typeUO);
  begin
    verifierObjet(pu);

    TmatAverage(pu).updateStdDev;
  end;



Procedure proTmatAverage_AddEx(var p:typeUO;xorg,yorg:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    verifierObjet(p);

    TmatAverage(pu).addEx(Tmatrix(p),xorg,yorg);
  end;

procedure proTmatAverage_reset(var pu:typeUO);
  begin
    verifierObjet(pu);
    TmatAverage(pu).reset;
  end;

procedure proTmatAverage_count(x:longint;var pu:typeUO);
  begin
    verifierObjet(pu);
    TmatAverage(pu).count:=x;
  end;

function fonctionTmatAverage_Count(var pu:typeUO):longint;
  begin
    verifierObjet(pu);
    fonctionTmatAverage_Count:=TmatAverage(pu).count;
  end;


function fonctionTmatAverage_MSqrs(var pu:typeUO):Tmatrix;
begin
  verifierObjet(pu);
  with TmatAverage(pu) do result:=@Sqrs.myAd;
end;

function fonctionTmatAverage_MstdDev(var pu:typeUO):Tmatrix;
begin
  verifierObjet(pu);
  with TmatAverage(pu) do result:=@stdDev.myAd;
end;

function fonctionTmatAverage_MStdUp(var pu:typeUO):Tmatrix;
begin
  verifierObjet(pu);
  with TmatAverage(pu) do result:=@StdUp.myAd;
end;

function fonctionTmatAverage_MStdDw(var pu:typeUO):Tmatrix;
begin
  verifierObjet(pu);
  with TmatAverage(pu) do result:=@StdDw.myAd;
end;

Initialization
AffDebug('Initialization stmMatAve1',0);


registerObject(TmatAverage,data);


end.
