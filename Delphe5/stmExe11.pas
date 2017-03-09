unit stmexe11;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses SysUtils,
     util1,Gdos,Dgraphic,debug0,
     ficDefAc,Ncdef2,
     stmDef,stmObj, stmError,
     stmvec1,math;



procedure ProLissage( var source,dest:Tvector;Cte:integer;x1,x2:float);pascal;
procedure ProLissage_1( var source,dest:Tvector;Cte:integer);pascal;

procedure ProIntegrer(var source,dest:Tvector;Cte:integer;x1,x2:float);pascal;
procedure ProIntegrer_1(var source,dest:Tvector;Cte:integer);pascal;


procedure proLissageGauss(var source,dest:Tvector;sig,x1,x2:float);pascal;
procedure proLissageGauss_1(var source,dest:Tvector;sig:float);pascal;

procedure ProEnveloppeS(var source,dest:Tvector;lAna,x1,x2:float); pascal;
procedure ProEnveloppeS_1(var source,dest:Tvector;lAna:float); pascal;

procedure ProEnveloppeI(var source,dest:Tvector;lAna,x1,x2:float); pascal;
procedure ProEnveloppeI_1(var source,dest:Tvector;lAna:float); pascal;


procedure ProSupSpike(var source,dest:Tvector;seuil,lmax,x1,x2:float); pascal;
procedure ProSupSpike_1(var source,dest:Tvector;seuil,lmax:float); pascal;

procedure ProIntegrer1(var source,dest:Tvector;CtI,CtM:integer;x1,x2:float);pascal;
procedure ProIntegrer1_1(var source,dest:Tvector;CtI,CtM:integer);pascal;


procedure ProPente(var source:Tvector;x1,x2:float;var a,b,sigma:float);pascal;
procedure ProPenteMax(var source:Tvector;Nb:integer;x1,x2:float;var a,b,sigma:float);pascal;
procedure ProPenteMin(var source:Tvector;Nb:integer;x1,x2:float;var a,b,sigma:float);pascal;
function fonctionDatePente:float;pascal;

function FonctionIntegrale(var source:Tvector;x1c,x2c,x1r,x2r:float):float;pascal;
function FonctionEnergie(var source:Tvector;x1c,x2c,x1r,x2r:float):float;pascal;
function FonctionIntegrale1(var source:Tvector;x1c,x2c,Y0:float):float;pascal;
function FonctionEnergie1(var source:Tvector;x1c,x2c,Y0:float):float;pascal;
function FonctionEnergie2(var source:Tvector;x1c,x2c,Y0:float;up:boolean):float;pascal;
function FonctionIntAbs(var source:Tvector;x1c,x2c:float):float;pascal;
function FonctionIntAbs1(var source:Tvector;x1c,x2c,y0:float):float;pascal;

procedure ProDerivee(var source,dest:Tvector;N:smallint;fmul:float);pascal;
procedure ProDeriveeEx(var source,dest:Tvector;N:smallint;x1,x2:float);pascal;

procedure ProDerivative1(var source,destD,destReg:Tvector;N:smallint;x1,x2:float);pascal;

procedure proDistri(var source,dest:Tvector;x1,x2:float);pascal;
procedure proDistri1(var source,dest:Tvector;x1,x2:float);pascal;

procedure proEventFreq(var source,dest:Tvector;x1,x2,dt:float);pascal;
procedure proEventFreq1(var source,dest:Tvector;dt:float);pascal;

procedure proBootStrap(var vx,vy,vn:Tvector;var va,vb:Tvector;nbIt:integer);pascal;

function FonctionIntAbove(var source:Tvector;
                          x1c,x2c,y0:float;var len:float):float;pascal;
function FonctionIntBelow(var source:Tvector;
                          x1c,x2c,y0:float;var len:float):float;pascal;

procedure proCorrectSpike(var Source,dest: Tvector; hh,linhib:float);pascal;
procedure proCorrectSpike2(var Source: Tvector; Xdet:float);pascal;

IMPLEMENTATION


var
  E_lissage:integer;
  E_EventFreq:integer;
  E_BootStrap1:integer;


const
  DatePente:float=0;


procedure cadrageX(t:Tvector;var i1,i2:longint);
begin
  if t.data=nil then exit;
  with t.data do
  begin
    if i1<indiceMin then i1:=indiceMin;
    if i2>indiceMax then i2:=indicemax;
  end;

  if i1>i2 then sortieErreur(E_parametre);
end;


procedure IntegrerLisser(source,dest:Tvector;Cte:integer;x1,x2:float;
                         int:boolean);
  var
    i,j,k:longint;
    m:longint;
    i1,i2:longint;
    buf:PtabEntier;
    l:integer;
  begin
    dest.controleReadOnly;
    dest.extendDim(source,G_none);

    dest.dxu:=source.dxu;
    dest.x0u:=source.x0u;
    dest.dyu:=source.dyu;
    dest.y0u:=source.y0u;

    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);


    cadrageX(source,i1,i2);
    cadrageX(dest,i1,i2);



    if (cte<0) or (cte>1000000) then sortieErreur(E_lissage);
    if cte=0 then cte:=1;

    if maxAvail<word(cte)*2 then sortieErreur(E_mem);

    source.data.open;
    dest.data.open;
    getmem(buf,cte*sizeof(smallint));
    l:=0;

    i:=I1+Cte;
    j:=I1+Cte div 2+1;
    m:=0;
    for k:=I1 to I1+Cte-1 do
      begin
        buf^[k-I1]:=source.data.getI(k);
        if int
          then inc(m,abs(buf^[k-I1]))
          else inc(m,buf^[k-I1]);
      end;
    for k:=I1 to j-1 do dest.data.setI(k,m div Cte);
    while i<=I2 do
      begin
        if int then dec(m,abs(buf^[l])) else dec(m,buf^[l]);
        buf^[l]:=source.data.getI(i);
        if int then inc(m,abs(buf^[l])) else inc(m,buf^[l]);
        inc(l);
        if l=Cte then l:=0;

        dest.data.setI(j,m div Cte);
        inc(i);
        inc(j);
      end;
    for k:=j to I2 do dest.data.setI(k,m div Cte);
    freemem(buf,cte*2);
    source.data.close;
    dest.data.close;
  end;


procedure IntegrerLisserS(source,dest:Tvector;Cte:integer;x1,x2:float; int:boolean);
var
  i,j,k:longint;
  m:float;
  i1,i2:longint;
  buf:PtabFloat;
  l:integer;
begin
  dest.controleReadOnly;
  dest.extendDim(source,G_none);

  dest.dxu:=source.dxu;
  dest.x0u:=source.x0u;
  i1:=source.invConvX(x1);
  i2:=source.invConvX(x2);


  cadrageX(source,i1,i2);
  cadrageX(dest,i1,i2);


  if (cte<0) or (cte>1000000) then sortieErreur(E_lissage);
  if cte=0 then cte:=1;

  if maxAvail<cte*10 then sortieErreur(E_mem);

  source.data.open;
  dest.data.open;
  getmem(buf,cte*sizeof(float));

  l:=0;

  i:=I1+Cte;
  j:=I1+Cte div 2+1;
  m:=0;
  for k:=I1 to I1+Cte-1 do
    begin
      buf^[k-I1]:=source.data.getE(k);
      if int
        then m:=m+abs(buf^[k-I1])
        else m:=m+buf^[k-I1];
    end;
  for k:=I1 to j-1 do dest.data.setE(k,m/Cte);
  while i<=I2 do
    begin
      if int then m:=m-abs(buf^[l]) else m:=m-buf^[l];
      buf^[l]:=source.data.getE(i);
      if int then m:=m+abs(buf^[l]) else m:=m+buf^[l];
      inc(l);
      if l=Cte then l:=0;

      dest.data.setE(j,m/cte);
      inc(i);
      inc(j);
    end;
  for k:=j to I2 do dest.data.setE(k,m/cte);

  if source.isComplex then
  begin
    l:=0;

    i:=I1+Cte;
    j:=I1+Cte div 2+1;
    m:=0;
    for k:=I1 to I1+Cte-1 do
      begin
        buf^[k-I1]:=source.data.getIm(k);
        if int
          then m:=m+abs(buf^[k-I1])
          else m:=m+buf^[k-I1];
      end;
    for k:=I1 to j-1 do dest.data.setIm(k,m/Cte);
    while i<=I2 do
      begin
        if int then m:=m-abs(buf^[l]) else m:=m-buf^[l];
        buf^[l]:=source.data.getIm(i);
        if int then m:=m+abs(buf^[l]) else m:=m+buf^[l];
        inc(l);
        if l=Cte then l:=0;

        dest.data.setIm(j,m/cte);
        inc(i);
        inc(j);
      end;
    for k:=j to I2 do dest.data.setIm(k,m/cte);
  end;

  freemem(buf,cte*10);
  source.data.close;
  dest.data.close;
end;


procedure ProLissage(var source,dest:Tvector;Cte:integer;x1,x2:float);
  begin
    verifierVecteur(source);
    verifierVecteur(dest);
    dest.controleReadOnly;

    if (source.inf.tpNum=G_smallint) and (dest.inf.tpNum=G_smallint)
      then integrerLisser(source,dest,Cte,x1,x2,false)
      else integrerLisserS(source,dest,Cte,x1,x2,false);
  end;

procedure ProLissage_1(var source,dest:Tvector;Cte:integer);
begin
  verifierVecteur(source);
  ProLissage(source,dest,Cte,source.Xstart,source.Xend);
end;


procedure ProIntegrer(var source,dest:Tvector;Cte:integer;x1,x2:float);
  begin
    verifierVecteur(source);
    verifierVecteur(dest);
    dest.controleReadOnly;

    if (source.inf.tpNum=G_smallint) and (dest.inf.tpNum=G_smallint)
      then integrerLisser(source,dest,Cte,x1,x2,true)
      else integrerLisserS(source,dest,Cte,x1,x2,true);

  end;

procedure ProIntegrer_1(var source,dest:Tvector;Cte:integer);
begin
  ProIntegrer( source,dest, Cte,source.Xstart, source.Xend);
end;



procedure proLissageGauss(var source,dest:Tvector;sig,x1,x2:float);
  var
    i,j,k:longint;
    m:longint;
    i1,i2:longint;
    buf:Ptabsingle;
    l,isig,cte:integer;
    gmax:float;

  function f(I0:longint):float;
    var
      i,Imin,Imax:longint;
      m:float;
    begin
      if I0-cte<I1 then Imin:=I1 else Imin:=I0-cte;
      if I0+cte>I2 then Imax:=I2 else Imax:=I0+cte;
      m:=0;
      for i:=Imin to Imax do
        m:=m+source.data.getE(i)*buf^[i-i0+Cte];
                                    {exp(-0.5*sqr((i-i0)/isig));}
      f:=m;
    end;

  function g(I0:longint):float;
    var
      i,Imin,Imax:longint;
      m:float;
    begin
      if I0-cte<I1 then Imin:=I1 else Imin:=I0-cte;
      if I0+cte>I2 then Imax:=I2 else Imax:=I0+cte;
      m:=0;
      for i:=Imin to Imax do
        m:=m+buf^[i-i0+Cte];{ exp(-0.5*sqr((i-i0)/isig));}
      g:=m;
    end;


  begin
    verifierVecteur(source);
    verifierVecteur(dest);
    dest.controleReadOnly;

    dest.extendDim(source,G_none);

    dest.dxu:=source.dxu;
    dest.x0u:=source.x0u;

    if (source.inf.tpNum=G_smallint) and (dest.inf.tpNum=G_smallint) then
      begin
        dest.dyu:=source.dyu;
        dest.y0u:=source.y0u;
      end;

    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);
    cadrageX(source,i1,i2);
    cadrageX(dest,i1,i2);

    isig:=source.invConvX(sig)-source.invConvX(0);

    ControleParametre(isig,1,8000);

    cte:=isig*2;
    if maxAvail<word(2*cte+1)*4 then sortieErreur(E_mem);
    getmem(buf,word(2*cte+1)*4);

    source.data.open;
    dest.data.open;

    for i:=0 to Cte*2 do
        buf^[i]:=exp(-0.5*sqr((i-Cte)/isig));
    gmax:=g((i1+i2) div 2);
    for i:=I1 to I2 do
      begin
        if (i>I1+cte) and (i<I2-Cte)
          then dest.data.setE(i,f(i)/gmax)
          else dest.data.setE(i,f(i)/g(i));
      end;

    source.data.close;
    dest.data.close;
    freemem(buf,word(2*cte+1)*4);
  end;

procedure proLissageGauss_1(var source,dest:Tvector;sig:float);
begin
  proLissageGauss( source,dest,sig,source.Xstart,source.Xend);
end;

procedure Integrer1ex
          (var source,dest:Tvector;CtI,CtM:integer;x1,x2:float);
  var
    i,j,k:longint;
    m,ma:float;
    i1,i2:longint;
    buf,bufMa:Ptabsingle;
    l,l1,lma:integer;
    y:float;
    v:integer;
    fin:boolean;
  begin
    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);

    cadrageX(source,i1,i2);
    cadrageX(dest,i1,i2);

    ControleParametre(CtI,1,32000);
    ControleParametre(CtM,CtI,32000);

    if maxAvail<ctM*sizeof(single) then sortieErreur(E_mem);
    getmem(buf,ctM*sizeof(single));

    if maxAvail<ctI*4 then
      begin
        freemem(buf);
        sortieErreur(E_mem);
      end;

    getmem(bufMa,ctI*sizeof(single));

    dest.data.open;
    source.data.open;

    l:=0;

    i:=I1+CtM;
    j:=I1+CtI div 2;
    m:=0;
    ma:=0;
    for k:=I1 to I1+CtM-1 do
      begin
        buf^[k-I1]:=source.data.getE(k);
        m:=m+buf^[k-I1];
      end;
    for k:=I1 to I1+CtI-1 do
      begin
        bufma^[k-I1]:=abs(buf^[k-I1]-m/CtM );
        ma:=ma+bufma^[k-I1];
      end;
    lma:=0;
    l1:=CtI;
    if l1=CtM then l1:=0;

    for k:=I1 to j-1 do dest.data.setE(k,ma/Cti );

    fin:=false;

    while (j<=I2) and not fin do
    begin
      if j mod 1000=0 then
        begin
          if testEscape then fin:=true;
        end;
      y:=buf^[l];
      m:=m-y;
      buf^[l]:=source.data.getE(i);
      m:=m+buf^[l];

      ma:=ma-bufma^[lma];
      bufma^[lma]:=abs(buf^[l1]-m /CtM);
      ma:=ma+bufma^[lma];

      inc(lma);
      if lma=ctI then lma:=0;

      inc(l1);
      if l1=CtM then l1:=0;

      inc(l);
      if l=CtM then l:=0;

      dest.data.setE(j,ma/CtI);
      if i<i2 then inc(i);
      inc(j);
    end;
    freemem(buf,ctM*4);
    freemem(bufMA,ctI*4);

    dest.data.close;
    source.data.close;

  end;


procedure ProIntegrer1
          (var source,dest:Tvector;CtI,CtM:integer;x1,x2:float);
  var
    i,j,k:longint;
    m,ma:longint;
    i1,i2:longint;
    buf,bufMa:PtabEntier;
    l,l1,lma:integer;
    y:integer;
    v:integer;
    fin:boolean;
  begin
    verifierVecteur(source);
    verifierVecteur(dest);
    dest.controleReadOnly;

    dest.extendDim(source,G_none);

    dest.dxu:=source.dxu;
    dest.x0u:=source.x0u;
    dest.dyu:=source.dyu;
    dest.y0u:=source.y0u;

    if (source.inf.tpNum<>G_smallint) or (dest.inf.tpNum<>G_smallint) then
      begin
        Integrer1ex(source,dest,CtI,CtM,x1,x2);
        exit;
      end;

    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);

    cadrageX(source,i1,i2);
    cadrageX(dest,i1,i2);

    ControleParametre(CtI,1,32000);
    ControleParametre(CtM,CtI,32000);

    if maxAvail<word(ctM)*sizeof(smallint) then sortieErreur(E_mem);
    getmem(buf,ctM*sizeof(smallint));

    if maxAvail<word(ctI)*sizeof(smallint) then
      begin
        freemem(buf);
        sortieErreur(E_mem);
      end;

    getmem(bufMa,ctI*sizeof(smallint));

    dest.data.open;
    source.data.open;

    l:=0;

    i:=I1+CtM;
    j:=I1+CtI div 2;
    m:=0;
    ma:=0;
    for k:=I1 to I1+CtM-1 do
      begin
        buf^[k-I1]:=source.data.getI(k);
        inc(m,buf^[k-I1]);
      end;
    for k:=I1 to I1+CtI-1 do
      begin
        bufma^[k-I1]:=abs(buf^[k-I1]-m div CtM );
        inc(ma,bufma^[k-I1]);
      end;
    lma:=0;
    l1:=CtI;
    if l1=CtM then l1:=0;

    for k:=I1 to j-1 do dest.data.setI(k,ma div Cti );

    fin:=false;

    while (j<=I2) and not fin do
    begin
      if j mod 1000=0 then
        begin
          if testEscape then fin:=true;
        end;
      y:=buf^[l];
      dec(m,y);
      buf^[l]:=source.data.getI(i);
      inc(m,buf^[l]);

      dec(ma,bufma^[lma]);
      bufma^[lma]:=abs(buf^[l1]-m div CtM);
      inc(ma,bufma^[lma]);

      inc(lma);
      if lma=ctI then lma:=0;

      inc(l1);
      if l1=CtM then l1:=0;

      inc(l);
      if l=CtM then l:=0;

      dest.data.setI(j,ma div CtI);
      if i<i2 then inc(i);
      inc(j);
    end;
    freemem(buf,ctM*2);
    freemem(bufMA,ctI*2);

    dest.data.close;
    source.data.close;

  end;

procedure ProIntegrer1_1(var source,dest:Tvector;CtI,CtM:integer);
begin
  ProIntegrer1(source,dest,CtI,CtM,source.Xstart,source.Xend);
end;

procedure CalculEnveloppe1ex(t1,t2:Tvector;Ic1,Ic2,lANA:longint;inf:boolean);
  var
    Ip,I0,i,j:longint;
    a,b:float;
    mini:longint;
    yi,yp,y0:float;

  begin
    t1.data.open;
    t1.data.open;

    Ip:=Ic1;      yp:=t1.data.getE(Ip);
    I0:=Ic1+1;    y0:=t1.data.getE(I0);

    t2.data.setE(Ip,yp);
    repeat
      a:=(y0-yp)/(I0-Ip);
      b:=-a*Ip +yp;

      i:=I0;
      if Ic2<Ip+lANA then mini:=Ic2
                     else mini:=Ip+lANA;

      if inf then
        repeat
          inc(i);
          yi:=t1.data.getE(i);
        until (i>mini) or (yi<a*i+ b)
      else
        repeat
          inc(i);
          yi:=t1.data.getE(i);
        until (i>mini) or (yi>a*i+ b);

      if (i>mini) then
        begin
          for j:=Ip+1 to I0 do t2.data.setE(j,a*j+b);
          Ip:=I0;    yp:=y0;
          I0:=Ip+1;  y0:=t1.data.getE(I0);
        end
      else
        begin
          I0:=i;
          y0:=t1.data.getE(I0);
        end;
    until Ip=Ic2;
    t1.data.close;
    t1.data.close;

  end;


procedure CalculEnveloppe1(t1,t2:Tvector;Ic1,Ic2,lANA:longint;inf:boolean);
  var
    Ip,I0,i,j:longint;
    a,b:float;
    mini:longint;
    yi,yp,y0:integer;

  begin
    t1.data.open;
    t1.data.open;

    Ip:=Ic1;      yp:=t1.data.getI(Ip);
    I0:=Ic1+1;    y0:=t1.data.getI(I0);

    t2.data.setI(Ip,yp);
    repeat
      a:=(y0-yp)/(I0-Ip);
      b:=-a*Ip +yp;

      i:=I0;
      if Ic2<Ip+lANA then mini:=Ic2
                     else mini:=Ip+lANA;

      if inf then
        repeat
          inc(i);
          yi:=t1.data.getI(i);
        until (i>mini) or (yi<a*i+ b)
      else
        repeat
          inc(i);
          yi:=t1.data.getI(i);
        until (i>mini) or (yi>a*i+ b);

      if (i>mini) then
        begin
          for j:=Ip+1 to I0 do t2.data.setI(j,roundI(a*j+b));
          Ip:=I0;    yp:=y0;
          I0:=Ip+1;  y0:=t1.data.getI(I0);
        end
      else
        begin
          I0:=i;
          y0:=t1.data.getI(I0);
        end;
    until Ip=Ic2;
    t1.data.close;
    t1.data.close;

  end;

procedure CalculEnveloppe0(var source,dest:Tvector;lAna,x1,x2:float;inf:boolean);
  var
    l,i1,i2:longint;
  begin
    verifierVecteur(source);
    verifierVecteur(dest);
    dest.controleReadOnly;

    dest.extendDim(source,G_none);

    dest.dxu:=source.dxu;
    dest.x0u:=source.x0u;
    dest.dyu:=source.dyu;
    dest.y0u:=source.y0u;

    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);

    cadrageX(source,i1,i2);
    cadrageX(dest,i1,i2);

    l:=roundL(abs(lana/source.inf.Dxu));

    if (source.inf.tpNum<>G_smallint) or (dest.inf.tpNum<>G_smallint)
      then CalculEnveloppe1ex(source,dest,I1,I2,l,inf)
      else CalculEnveloppe1(source,dest,I1,I2,l,inf);
  end;

procedure ProEnveloppeI(var source,dest:Tvector;lAna,x1,x2:float);
  begin
    CalculEnveloppe0(source,dest,lana,x1,x2,true);
  end;

procedure ProEnveloppeI_1(var source,dest:Tvector;lAna:float);
begin
  CalculEnveloppe0(source,dest,lana,source.Xstart,source.Xend,true);
end;



procedure ProEnveloppeS(var source,dest:Tvector;lAna,x1,x2:float);
  begin
    CalculEnveloppe0(source,dest,lana,x1,x2,false);
  end;

procedure ProEnveloppeS_1(var source,dest:Tvector;lAna:float);
begin
  CalculEnveloppe0(source,dest,lana,source.Xstart,source.Xend,false);
end;


procedure SupSpikeEx(var source,dest:Tvector;
                          seuil,lmax,x1,x2:float);
  var
    i,i0:longint;
    ic1,ic2:longint;
    l:longint;

  procedure ranger(Ip,I0:longint);
    var
      a,b:float;
      i:longint;
    begin
      with source.data do
      begin
        a:=(getE(I0)-getE(Ip))/(I0-Ip);
        b:=-a*Ip +getE(Ip);
      end;
      for i:=Ip+1 to I0 do
        dest.data.setE(i,a*i+b);
    end;

  function SpTrouve(var i:longint):boolean;
    var
      Imax:longint;
    begin
      with source.data do
      begin
        SpTrouve:=false;
        if getE(i)-getE(i-1)<seuil then exit;
        Imax:=i+l;
        while (i<Imax) and (getE(i)-getE(i-1)>-seuil) do inc(i);
        if i=Imax then exit;
        SpTrouve:=true;
        while (i<Imax+l) and (getE(i)-getE(i-1)<=-seuil) do inc(i);
        dec(i);
      end;
    end;

  begin
    ic1:=source.invConvX(x1);
    ic2:=source.invConvX(x2);

    cadrageX(source,ic1,ic2);
    cadrageX(dest,ic1,ic2);

    l:=roundI(abs(lmax/source.inf.Dxu));
                                                      
    source.data.open;
    dest.data.open;

    for i:=0 to Ic1 do dest.data.setE(i,source.data.getE(i));
    i:=Ic1+1;
    repeat
      i0:=i;
      if SpTrouve(i0) then
        begin
          if i0>Ic2 then i0:=Ic2;
          ranger(i-1,i0);
          i:=i0;
        end
      else dest.data.setE(i,source.data.getE(i));
      inc(i);
    until i>Ic2;
    for i:=Ic2 to dest.inf.Imax do dest.data.setE(i,source.data.getE(i));
    source.data.close;
    dest.data.close;
  end;

procedure SupSpike(var source,dest:Tvector;
                          seuil,lmax,x1,x2:float);
  var
    i,i0:longint;
    ic1,ic2:longint;
    s,l:longint;

  procedure ranger(Ip,I0:longint);
    var
      a1,a2,b,i:longint;
    begin
      with source.data do
      begin
        a1:=getI(I0)-getI(Ip);
        a2:=I0-Ip;               { a=a1/a2 }
        b:=-longint(a1)*Ip div a2 +getI(Ip);
      end;
      for i:=Ip+1 to I0 do
        dest.data.setI(i,longint(a1)*i div a2 +b);
    end;

  function SpTrouve(var i:longint):boolean;
    var
      Imax:longint;
    begin
      with source.data do
      begin
        SpTrouve:=false;
        if getI(i)-getI(i-1)<s then exit;
        Imax:=i+l;
        while (i<Imax) and (getI(i)-getI(i-1)>-s) do inc(i);
        if i=Imax then exit;
        SpTrouve:=true;
        while (i<Imax+l) and (getI(i)-getI(i-1)<=-s)
          do inc(i);
        dec(i);
      end;
    end;

  begin
    ic1:=source.invConvX(x1);
    ic2:=source.invConvX(x2);

    cadrageX(source,ic1,ic2);
    cadrageX(dest,ic1,ic2);

    s:=roundI(abs(seuil/source.inf.Dyu));
    l:=roundI(abs(lmax/source.inf.Dxu));


    source.data.open;
    dest.data.open;

    for i:=0 to Ic1 do dest.data.setI(i,source.data.getI(i));
    i:=Ic1;
    repeat
      i0:=i;
      if SpTrouve(i0) then
        begin
          if i0>Ic2 then i0:=Ic2;
          ranger(i-1,i0);
          i:=i0;
        end
      else dest.data.setI(i,source.data.getI(i));
      inc(i);
    until i>Ic2;
    for i:=Ic2 to dest.inf.Imax do dest.data.setI(i,source.data.getI(i));
    source.data.close;
    dest.data.close;

  end;

procedure proSupSpike(var source,dest:Tvector;
                          seuil,lmax,x1,x2:float);
  begin
    verifierVecteur(source);
    verifierVecteur(dest);
    dest.controleReadOnly;

    dest.extendDim(source,G_none);

    dest.dxu:=source.dxu;
    dest.x0u:=source.x0u;
    dest.dyu:=source.dyu;
    dest.y0u:=source.y0u;

    if (source.inf.tpNum<>G_smallint) or (dest.inf.tpNum<>G_smallint)
      then supSpikeEx(source,dest,seuil,lmax,x1,x2)
      else supSpike(source,dest,seuil,lmax,x1,x2);
  end;

procedure ProSupSpike_1(var source,dest:Tvector;seuil,lmax:float);
begin
  ProSupSpike(source,dest,seuil,lmax,source.Xstart,source.Xend);
end;

procedure ProPente(var source:Tvector;x1,x2:float;
                      var a,b,sigma:float);
  var
    i1,i2:longint;
  begin
    verifierVecteur(source);

    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);
    cadrageX(source,i1,i2);

    source.data.lineFit(i1,i2,a,b,sigma);
  end;

procedure ProPenteMax(var source:Tvector;Nb:integer;x1,x2:float;
                         var a,b,sigma:float);
  var
    i1,i2:longint;
    ipente:longint;
  begin
    verifierVecteur(source);

    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);
    cadrageX(source,i1,i2);

    source.data.PlusGrandePente(i1,i2,nb,a,b,sigma,ipente);
    DatePente:=source.convX(ipente);
  end;

procedure ProPenteMin(var source:Tvector;Nb:integer;x1,x2:float;
                         var a,b,sigma:float);
  var
    i1,i2:longint;
    ipente:longint;
  begin
    verifierVecteur(source);

    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);
    cadrageX(source,i1,i2);

    source.data.PlusPetitePente(i1,i2,nb,a,b,sigma,ipente);
    DatePente:=source.convX(ipente);
  end;


function fonctionDatePente:float;
  begin
    fonctionDatePente:=datePente;
  end;



procedure ProDerivee(var source,dest:Tvector;N:smallint;fmul:float);
  var
    i,i1,i2:longint;
    y1:float;
    a,b,r:float;
  begin
    verifierVecteur(source);
    verifierVecteur(dest);

    dest.extendDim(source,G_none);

    dest.dxu:=source.dxu;
    dest.x0u:=source.x0u;
    dest.dyu:=source.dyu;
    dest.y0u:=source.y0u;

    i1:=source.inf.imin;
    i2:=source.inf.imax;

    ControleParametre(N,1,32000);

    source.data.open;
    dest.data.open;

    if (source.inf.tpNum=G_smallint) and (dest.inf.tpNum=G_smallint) then
      begin
        if fmul=0 then
          begin
            for i:=i1+1 to i2-1 do
              begin
                source.data.lineFit(i-1,i+1,a,b,r);
                if abs(a)>fmul then fmul:=abs(a);
              end;
            fmul:=fmul/10000;
          end;

        dest.dyu:=fmul;
        dest.y0u:=0;
      end;

    for i:=i1+N to i2-N do
      dest.data.setE(i,source.data.FastSlope(i-N,i+N));

    y1:=dest.data.getE(i1+N);
    for i:=i1 to i1+N-1 do dest.data.setE(i,y1);

    y1:=dest.data.getE(i2-N);
    for i:=i2-N+1 to i2 do dest.data.setE(i,y1);

    source.data.close;
    dest.data.close;
  end;

procedure ProDeriveeEx(var source,dest:Tvector;N:smallint;x1,x2:float);
  var
    i,i1,i2:longint;
    y1:float;
  begin
    verifierVecteur(source);
    verifierVecteur(dest);

    if dest.tpNum in [G_byte,G_smallint,G_longint]
      then  dest.extendDim(source,G_single)
      else  dest.extendDim(source,G_none);

    dest.dxu:=source.dxu;
    dest.x0u:=source.x0u;
    dest.dyu:=source.dyu;
    dest.y0u:=source.y0u;

    i1:=source.invConvx(x1);
    i2:=source.invConvx(x2);
    cadrageX(source,i1,i2);

    ControleParametre(N,1,32000);

    source.data.open;
    dest.data.open;

    for i:=i1+N to i2-N do
      dest.data.setE(i,source.data.FastSlope(i-N,i+N));

    y1:=dest.data.getE(i1+N);
    for i:=i1 to i1+N-1 do dest.data.setE(i,y1);

    y1:=dest.data.getE(i2-N);
    for i:=i2-N+1 to i2 do dest.data.setE(i,y1);

    source.data.close;
    dest.data.close;
  end;

procedure ProDerivative1(var source,destD,destReg:Tvector;N:smallint;x1,x2:float);
  var
    i,i1,i2:longint;
    y1,a,b,R:float;
  begin
    verifierVecteur(source);
    verifierVecteur(destD);
    verifierVecteur(destReg);

    if destD.tpNum in [G_byte,G_smallint,G_longint]
      then  destD.extendDim(source,G_single)
      else  destD.extendDim(source,G_none);

    if destReg.tpNum in [G_byte,G_smallint,G_longint]
      then  destReg.extendDim(source,G_single)
      else  destReg.extendDim(source,G_none);


    destD.dxu:=source.dxu;
    destD.x0u:=source.x0u;
    destReg.dxu:=source.dxu;
    destReg.x0u:=source.x0u;

    i1:=source.invConvx(x1);
    i2:=source.invConvx(x2);
    cadrageX(source,i1,i2);

    ControleParametre(N,1,32000);

    source.data.open;
    destD.data.open;

    for i:=i1+N to i2-N do
      begin
        source.data.lineFit(i-N,i+N,a,b,R);
        destD.data.setE(i,a);
        destReg.data.setE(i,R);
      end;

    y1:=destD.data.getE(i1+N);
    for i:=i1 to i1+N-1 do destD.data.setE(i,y1);

    y1:=destD.data.getE(i2-N);
    for i:=i2-N+1 to i2 do destD.data.setE(i,y1);

    y1:=destReg.data.getE(i1+N);
    for i:=i1 to i1+N-1 do destReg.data.setE(i,y1);

    y1:=destReg.data.getE(i2-N);
    for i:=i2-N+1 to i2 do destReg.data.setE(i,y1);


    source.data.close;
    destD.data.close;
  end;




function FonctionIntegrale(var source:Tvector;
                           x1c,x2c,x1r,x2r:float):float;
  var
    i:integer;
    Ymoy,Ytot:float;
    i1c,i2c,i1r,i2r:longint;
  begin
    verifierVecteur(source);
    i1c:=source.invConvX(x1c);
    i2c:=source.invConvX(x2c);
    cadrageX(source,i1c,i2c);
    i1r:=source.invConvX(x1r);
    i2r:=source.invConvX(x2r);
    cadrageX(source,i1r,i2r);

    source.data.open;

    if (source.inf.tpNum=G_smallint) then
      begin
        Ymoy:=0;
        for i:=I1r to I2r do Ymoy:=Ymoy+source.data.getI(i);
        Ymoy:=Ymoy / (I2r-I1r+1);

        Ytot:=0;
        for i:=I1c to I2c do Ytot:=Ytot+source.data.getI(i);
        Ytot:=Ytot-Ymoy*(I2c-I1c+1);
        FonctionIntegrale:=source.inf.Dxu*source.inf.Dyu*Ytot;
      end
    else
      begin
        Ymoy:=source.data.moyenne(I1r,I2r);

        Ytot:=0;
        for i:=I1c to I2c do Ytot:=Ytot+source.data.getE(i);
        Ytot:=Ytot-Ymoy*(I2c-I1c+1);
        FonctionIntegrale:=source.inf.Dxu*Ytot;
      end;
    source.data.close;

  end;

function FonctionEnergie(var source:Tvector;
                         x1c,x2c,x1r,x2r:float):float;
  var
    i:integer;
    tot,Ymoy:float;
    i1c,i2c,i1r,i2r:longint;
  begin
    verifierVecteur(source);

    i1c:=source.invConvX(x1c);
    i2c:=source.invConvX(x2c);
    cadrageX(source,i1c,i2c);
    i1r:=source.invConvX(x1r);
    i2r:=source.invConvX(x2r);
    cadrageX(source,i1r,i2r);

    source.data.open;

    if (source.inf.tpNum=G_smallint) then
      begin
        Ymoy:=0;
        for i:=I1r to I2r do Ymoy:=Ymoy+source.data.getI(i);
        Ymoy:=Ymoy / (I2r-I1r+1);

        tot:=0;
        for i:=I1c to I2c do tot:=tot+sqr(1.0*source.data.getI(i)-Ymoy);
        FonctionEnergie:=source.inf.Dxu*sqr(source.inf.Dyu)*tot;
      end
    else
      begin
        Ymoy:=source.data.moyenne(I1r,I2r);

        tot:=0;
        for i:=I1c to I2c do tot:=tot+sqr(source.data.getE(i)-Ymoy);
        FonctionEnergie:=source.inf.Dxu*tot;
      end;
    source.data.close;
  end;



function FonctionIntegrale1(var source:Tvector;
                            x1c,x2c,Y0:float):float;
  var
    i:longint;
    Ytot:float;
    i1c,i2c:longint;
    J0:float;
  begin
    verifierVecteur(source);

    i1c:=source.invConvX(x1c);
    i2c:=source.invConvX(x2c);
    cadrageX(source,i1c,i2c);

    source.data.open;

    if (source.inf.tpNum=G_smallint) then
      begin
        J0:=(Y0-source.y0u)/source.Dyu;
        Ytot:=0;
        for i:=I1c to I2c do Ytot:=Ytot+source.data.getI(i);
        Ytot:=Ytot-J0*(I2c-I1c+1);
        FonctionIntegrale1:=source.inf.Dxu*source.inf.Dyu*Ytot;
      end
    else
      begin
        Ytot:=0;
        for i:=I1c to I2c do Ytot:=Ytot+source.data.getE(i);
        Ytot:=Ytot-Y0*(I2c-I1c+1);
        FonctionIntegrale1:=source.inf.Dxu*Ytot;
      end;

    source.data.close;
  end;

function FonctionIntAbs1(var source:Tvector;
                         x1c,x2c,y0:float):float;
  var
    i:longint;
    tot:longint;
    Ytot:float;
    J0:integer;
    i1c,i2c:longint;
  begin
    verifierVecteur(source);

    i1c:=source.invConvX(x1c);
    i2c:=source.invConvX(x2c);
    cadrageX(source,i1c,i2c);

    source.data.open;
    if (source.inf.tpNum=G_smallint) then
      begin
        J0:=source.invConvY(y0);
        tot:=0;
        for i:=I1c to I2c do inc(tot,abs(source.data.getI(i)-J0));
        FonctionIntAbs1:=source.inf.Dxu*source.inf.Dyu*tot;
      end
    else
      begin
        Ytot:=0;
        for i:=I1c to I2c do Ytot:=Ytot+abs(source.data.getE(i)-Y0);
        FonctionIntAbs1:=source.inf.Dxu*Ytot;
      end;
    source.data.close;
  end;

function FonctionIntAbs(var source:Tvector;
                        x1c,x2c:float):float;
  begin
    FonctionIntAbs:=FonctionIntAbs1(source,x1c,x2c,0);
  end;




function FonctionEnergie1(var source:Tvector;
                          x1c,x2c,Y0:float):float;
  var
    i:longint;
    tot:float;
    i1c,i2c:longint;
    J0:integer;
  begin
    verifierVecteur(source);

    i1c:=source.invConvX(x1c);
    i2c:=source.invConvX(x2c);
    cadrageX(source,i1c,i2c);
    J0:=source.invConvY(Y0);

    source.data.open;
    if (source.inf.tpNum=G_smallint) then
      begin
        tot:=0;
        for i:=I1c to I2c do tot:=tot+sqr(1.0*source.data.getI(i)-J0);
        FonctionEnergie1:=source.inf.Dxu*sqr(source.inf.Dyu)*tot;
      end
    else
      begin
        tot:=0;
        for i:=I1c to I2c do tot:=tot+sqr(source.data.getE(i)-Y0);
        FonctionEnergie1:=source.inf.Dxu*tot;
      end;
    source.data.close;
  end;

function FonctionEnergie2(var source:Tvector;
                          x1c,x2c,Y0:float;up:boolean):float;
  var
    i:longint;
    tot:float;
    i1c,i2c:longint;
    J0,j:integer;
    y:float;
  begin
    verifierVecteur(source);

    i1c:=source.invConvX(x1c);
    i2c:=source.invConvX(x2c);
    cadrageX(source,i1c,i2c);


    source.data.open;
    if (source.inf.tpNum=G_smallint) then
      begin
        J0:=source.invConvY(Y0);
        tot:=0;
        for i:=I1c to I2c do
          begin
            j:=source.data.getI(i)-J0;
            if ((j>0) and up) or ((j<0) and not up) then
              tot:=tot+sqr(1.0*j);
          end;
        FonctionEnergie2:=source.inf.Dxu*sqr(source.inf.Dyu)*tot;
      end
    else
      begin
        tot:=0;
        for i:=I1c to I2c do
          begin
            y:=source.data.getE(i)-Y0;
            if ((y>0) and up) or ((y<0) and not up) then
              tot:=tot+sqr(y);
          end;
        FonctionEnergie2:=source.inf.Dxu*tot;
      end;
    source.data.close;
  end;

procedure proDistri(var source,dest:Tvector;x1,x2:float);
var
  i,i1,i2,j:longint;
  y1,x0,dx:float;

const
  epsilon=0;
begin
  verifiervecteur(source);
  verifiervecteur(dest);


  i1:=source.invConvx(x1);
  i2:=source.invConvx(x2);
  cadrageX(source,i1,i2);

  source.data.open;
  dest.data.open;

  {dest.data.raz;}
  x0:=dest.inf.x0u-epsilon;
  dx:=dest.inf.dxu;

  for i:=i1 to i2 do
    begin
      y1:=source.data.getE(i);
      j:=floor((y1-x0)/dx);
      if (j>=dest.Istart) and (j<=dest.Iend) then
        dest.data.addE(j,1);
    end;


  source.data.close;
  dest.data.close;
end;

procedure proDistri1(var source,dest:Tvector;x1,x2:float);
var
  i,i1,i2,j:longint;
  y1,x0,dx:float;

const
  epsilon=0;
begin
  verifiervecteur(source);
  verifiervecteur(dest);


  i1:=source.invConvx(x1);
  i2:=source.invConvx(x2);
  cadrageX(source,i1,i2);

  source.data.open;
  dest.data.open;

  x0:=dest.inf.x0u-epsilon;
  dx:=dest.inf.dxu;

  for i:=i1 to i2 do
    begin
      y1:=source.data.getE(i);
      j:=floor((y1-x0)/dx);
      if j<dest.Istart then j:=dest.Istart;
      if j>dest.Iend then j:=dest.Iend;
      dest.data.addE(j,1);
    end;


  source.data.close;
  dest.data.close;
end;


procedure proEventFreq(var source,dest:Tvector;x1,x2,dt:float);
var
  i,iA,iB,n,max:integer;
  dt0,xA,xB:float;
begin
  verifierVecteur(source);
  verifierVecteur(dest);

  controleParam(dt,1E-20,1E20,E_EventFreq);

  dt0:=dest.dxu;

  dest.x0u:=x1+dt/2;

  n:=roundL((x2-x1-dt)/dt0);
  if n<1 then exit;

  dest.initTemp1(0,n-1,dest.tpNum);
  max:=source.Iend;

  xA:=x1;
  xB:=x1+dt;

  source.data.open;
  dest.data.open;


  IA:=source.Istart;
  while (iA<Max) and (source.data.getE(iA)<xA) do inc(iA);
  IB:=source.Istart;
  while (iB<Max) and (source.data.getE(iB)<xB) do inc(iB);

  for i:=0 to n-1 do
    begin
      dest.data.setE(i,(iB-iA)/dt);
      xA:=xA+dt0;
      while (iA<Max) and (source.data.getE(iA)<xA) do inc(iA);
      xB:=xB+dt0;
      while (iB<Max) and (source.data.getE(iB)<xB) do inc(iB);
    end;

  source.data.close;
  dest.data.close;
end;

procedure proEventFreq1(var source,dest:Tvector;dt:float);
var
  i,iA,iB,n,max:integer;
  xA,xB,dt0:float;
begin
  verifierVecteur(source);
  verifierVecteur(dest);

  if dt<=0 then sortieErreur(E_EventFreq);

  max:=source.Iend;
  dt0:=dest.Dxu;
  {
  xA:=dest.Xstart;
  xB:=xA+dt;

  IA:=source.Istart;
  while (iA<Max) and (source.Yvalue[iA]<xA) do inc(iA);
  IB:=source.Istart;
  while (iB<Max) and (source.Yvalue[iB]<xB) do inc(iB);

  while (xA<=dest.Xend) do
  begin
    i:=dest.invconvx(xA);
    dest.Yvalue[i]:=(iB-iA)/dt;
    xA:=xA+dt0;
    while (iA<Max) and (source.Yvalue[iA]<xA) do inc(iA);
    xB:=xB+dt0;
    while (iB<=Max) and (source.Yvalue[iB]<xB) do inc(iB);
  end;
  }

  IA:=source.Istart;
  IB:=source.Istart;
  for i:=dest.Istart to dest.Iend do
  begin
    xA:=dest.convx(i);
    XB:=XA+dt;
    while (iA<Max) and (source.Yvalue[iA]<xA) do inc(iA);
    while (iB<=Max) and (source.Yvalue[iB]<xB) do inc(iB);
    dest.Yvalue[i]:=(iB-iA)/dt;
  end;
end;


procedure proBootStrap(var vx,vy,vn:Tvector;var va,vb:Tvector;nbIt:integer);
var
  i,j,k,nb,n:integer;
  nbdata,nbgroupe:integer;
  tbX,tbY,tbX0,tbY0:ptabdouble;
  a,b:double;
  nbg,debg:array[1..100] of integer;


  procedure lineFit;
  var
    i:integer;
    sommeX,sommeX2,sommeY,sommeY2,sommeXY,delta:double;
    x,y:double;

  begin

    sommeX:=0;
    sommeX2:=0;
    sommeY:=0;

    sommeY2:=0;
    sommeXY:=0;
    for i:=0 to nbdata-1 do
      begin
        x:=tbX^[i];
        y:=tbY^[i];
        sommeX:=sommeX+x;
        sommeX2:=sommeX2+sqr(x);
        sommeY:=sommeY+y;
        sommeY2:=sommeY2+sqr(y);
        sommeXY:=sommeXY+x*y;
      end;
    delta:=NbData*sommeX2-sommeX*sommeX;
    b:=(sommeX2*sommeY-sommeX*sommeXY)/Delta;
    a:=(N*sommeXY-sommeX*sommeY)/Delta;
  end;



begin
  verifiervecteur(vx);
  verifiervecteur(vy);
  verifiervecteur(vn);
  verifiervecteur(va);
  verifiervecteur(vb);

  va.initList(va.tpnum);
  vb.initList(vb.tpNum);

  controleParam(nbIt,1,maxEntierLong,E_EventFreq);

  if (vx.Istart<>vy.Istart) or (vn.Istart<>vx.Istart) or (vx.Iend<>vy.Iend)
    then sortieErreur(E_BootStrap1);

  nbdata:=vn.sumI;
  if nbdata>vx.Iend-vx.Istart+1 then nbdata:=vx.Iend-vx.Istart+1;


  n:=0;
  nbgroupe:=0;
  i:=vn.Istart;
  while (i<=vn.Iend) and (vn.Jvalue[i]>0) and (n<nbdata) do
  begin
    k:=vn.Jvalue[i];
    inc(nbgroupe);
    debg[nbgroupe]:=n;
    if n+k<=nbdata
      then nbg[nbgroupe]:=k
      else nbg[nbgroupe]:=nbdata-n;
    n:=n+k;
  end;

  getmem(tbX,nbdata*sizeof(double));
  getmem(tbY,nbdata*sizeof(double));
  getmem(tbX0,nbdata*sizeof(double));
  getmem(tbY0,nbdata*sizeof(double));

  fillchar(tbX^,nbdata*sizeof(double),0);
  fillchar(tbY^,nbdata*sizeof(double),0);
  fillchar(tbX0^,nbdata*sizeof(double),0);
  fillchar(tbY0^,nbdata*sizeof(double),0);

  for i:=vx.Istart to vx.Istart+nbdata-1 do
    begin
      tbX0^[i-vx.Istart]:=vx.Yvalue[i];
      tbY0^[i-vx.Istart]:=vy.Yvalue[i];
    end;

  
  for i:=1 to nbIt do
    begin
      nb:=-1;
      for j:=1 to nbgroupe do
        begin
          k:=debg[j]+random(nbg[j]);
          inc(nb);
          tbX^[nb]:=tbX0^[k];
          tbY^[nb]:=tbY0^[k];
        end;

      for j:=nbgroupe+1 to nbdata do
        begin
          k:=random(nbdata);
          inc(nb);
          tbX^[nb]:=tbX0^[k];
          tbY^[nb]:=tbY0^[k];
        end;

      linefit;

      va.addToList(a);
      vb.addToList(b);

    end;

  freemem(tbX);
  freemem(tbY);
  freemem(tbX0);
  freemem(tbY0);

end;


function FonctionIntAbove(var source:Tvector;
                          x1c,x2c,y0:float;var len:float):float;
begin
  verifierVecteur(source);
  if x1c<source.Xstart then  x1c:=source.Xstart;
  if x2c>source.Xend then  x2c:=source.Xend;

  result:=source.IntAbove(x1c,x2c,y0,len);
end;

function FonctionIntBelow(var source:Tvector;
                          x1c,x2c,y0:float;var len:float):float;
begin
  verifierVecteur(source);
  if x1c<source.Xstart then  x1c:=source.Xstart;
  if x2c>source.Xend then  x2c:=source.Xend;

  result:=source.IntBelow(x1c,x2c,y0,len);
end;


procedure proCorrectSpike2(var Source: Tvector; Xdet:float);

var
  i1,i2:integer;           { zone d'analyse du spike }
  imax:integer;            { position du max du spike }
  diff0,diff1,diff2:float; { calcul de la dérivée seconde }
  ruptMax:float;           { valeur du max de la dérivée seconde }
  Iruptmax:integer;        { Position du max de la dérivée seconde }

  IstartS,IendS:integer;   { source.Istart et source.Iend}
  DxS,x0s:float;           { source.dxu }

  Ibas1,Ibas2:integer;     { Zone de calcul de la ligne de base (inclinée) }
  abas, bbas, rbas : float;{ Ligne de base = abas*x+bbas , rbas: coeff de régression }

  idumax:integer;          { indice du retour du spike }
  xdumax:float;            { abscisse du retour du spike }
  ydumax:float;            { ordonnée correspondante sur la droite abas, bbas}


  Idep,Ifinal:integer;

  yfinal, xfinal, ydep, xdep: float;
  pen, int : float;
  ampli, tau, ti : float;

  i:integer;
  x:float;

const
  nbreg = 5;
  DXbefore=1;
  DXafter=2;
  seuilAlpha=0.1;
  seuilPente=0.1;
  PenteDef=0.5;

  cnt:integer=0;
begin
  inc(cnt);
  {statuslineTxt('cnt='+Istr(cnt)); }


  verifierVecteur(source);
  source.controleReadOnly;

  IstartS:=source.Istart;
  IendS:=source.Iend;
  dxS:=source.dxu;
  x0S:=source.X0u;

  i1 := source.invconvx(Xdet - DXbefore);
  if i1 < Source.Istart then i1:= Source.Istart;

  i2:= source.invconvx( Xdet + DXafter);
  if i2 > Source.Iend-1 then i2 := Source.Iend-1;

  if i1>=i2-3 then exit;

  imax:=source.data.maxiX(i1,i2);

  ruptmax:=0;
  Iruptmax:=i1+1;                                {ajouté le 6-09-04 }
  diff1:= (Source.Yvalue[i1+1] - Source.Yvalue[i1]);
  for i:=i1+1 to imax do
  begin
    diff0:=diff1;
    diff1:= (Source.Yvalue[i+1] - Source.Yvalue[i]);
    diff2:=diff1-diff0;
    if diff2 > ruptmax then
      begin
        ruptmax := diff2;
        Iruptmax := i;
      end;
  end;
  if Iruptmax<IstartS+2 then exit;

  Ibas1:=Iruptmax-1-nbreg;
  Ibas2:=Iruptmax-1;
  if Ibas1<IstartS then Ibas1:=IstartS;

  source.data.lineFit(Ibas1,Ibas2,abas,bbas,rbas);

  while (Ibas1>IstartS) and (abas < 0) do
  begin
    dec(Ibas1);
    source.data.lineFit(Ibas1,Ibas2,abas,bbas,rbas);
  end;

  if abas < seuilPente then
  begin
    abas := PenteDef;
    bbas := Source.Yvalue[Ibas2] - abas * source.convx(Ibas2);
  end;

  idumax := Ibas2 + 2;
  while (idumax < IendS ) and (abas * source.convx(idumax) + bbas <  Source.Yvalue[idumax]) do inc(idumax);
  xdumax:=source.convx(idumax);
  {xdumax est le point de coupure du retour du spike}

  xdep := source.convx(Ibas2);
  ydep := abas * xdep + bbas;

  tau := (xdumax - xdep)/2;
  ydumax := abas * (xdep + tau) + bbas;

  ampli := (ydumax - ydep) / (tau * exp(-1));

  ti := 4*source.dxu;
  while (ampli * ti * exp(-ti/tau)) > seuilAlpha do  ti := ti + source.dxu;
  xfinal := ti + source.convx(Ibas2);

  if xfinal < source.xend
    then yfinal := Source.Rvalue[xfinal]
    else yfinal := Source.Yvalue[IendS];

  pen := (yfinal - ydep) / (xfinal - xdep);
  int := ydep - pen * xdep;

  Idep:=source.invconvx(xdep);
  Ifinal:=source.invconvx(xfinal);
  if Ifinal>IendS then Ifinal:=IendS;
  for i:=Idep to Ifinal do
    begin
      ti:=(i-Idep)*dxS;
      x:=i*dxS+x0S;
      Source.Yvalue[i] := (ampli * ti * exp(-ti/tau)) + (pen * x + int) ;
    end;

end;


procedure proCorrectSpike(var Source,dest: Tvector; hh,linhib:float);
var
  i,i1,i2:integer;
  dlinhib:integer;
  w,w1:float;
begin
  verifierVecteur(source);
  VerifierVecteur(source);

  if dest<>source then
  begin
    VerifierVecteur(dest);
    VadjustIstartIendTpNum(source,dest);

    dest.copyDataFrom(source);
  end;

  i1:=dest.Istart;
  i2:=dest.Iend;
  if i2-i1<1 then exit;

  i:=i2;
  w1:=dest.data.getE(i);
  dlinhib:=dest.invConvX(lInhib)-dest.invConvX(0);
  if dlinhib<=0 then dlinhib:=1;

  repeat
     dec(i);
     w:=dest.data.getE(i);
     if  (w1>=hh) and (w<hh) then
       begin
         proCorrectSpike2(dest,dest.convx(i));
         dec(i,dlinhib);
       end;
      w1:=w;

     if getFlagClock(2) and TestEscape then exit;

  until i<=i1;

end;


Initialization
AffDebug('Initialization stmexe11',0);

installError(E_lissage,'Smooth parameter out of range');
installError(E_EventFreq,'EventFreq: invalid parameter');

end.
