unit stmJp;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses math,util1,Dtrace1,dtf0,
     stmdef,stmObj,stmvec1,stmMat1,
     stmError,stmPg,Ncdef2, debug0;

type
  TJpsth=       class(TMatrix)
                  count:longint;

                  class function STMClassName:AnsiString;override;
                  Procedure Add(vec1,vec2:Tvector);
                  procedure AddEx(vec1,vec2:Tvector;xorg:float);
                end;

  T2Dcorre=     class(TJpsth)

                  class function STMClassName:AnsiString;override;
                  Procedure Add(vec1,vec2:Tvector;x1,x2:float);

                end;


procedure proTjpsth_create(name:AnsiString;tp:smallint;i1,i2,j1,j2:longint;
                          Lclasse:float;var pu:typeUO);pascal;
procedure proTjpsth_create_1(tp:smallint;i1,i2,j1,j2:longint; Lclasse:float;var pu:typeUO);pascal;

Procedure proTJpsth_Add(var vec1,vec2:Tvector;var pu:typeUO);pascal;

procedure proTJpsth_BinWidth(w:float;var pu:typeUO);pascal;
function fonctionTJpsth_BinWidth(var pu:typeUO):float;pascal;

procedure proTJpsth_Count(w:longint;var pu:typeUO);pascal;
function fonctionTJpsth_Count(var pu:typeUO):longint;pascal;



procedure proT2Dcorre_create(name:AnsiString;t:smallint;i1,i2,j1,j2:longint;
                          LclasseX,LclasseY:float;var pu:typeUO);pascal;

procedure proT2Dcorre_create_1(t:smallint;i1,i2,j1,j2:longint;
                          LclasseX,LclasseY:float;var pu:typeUO);pascal;


Procedure proT2Dcorre_Add(var vec1,vec2:Tvector;x1,x2:float;var pu:typeUO);pascal;

procedure proT2Dcorre_BinWidthX(w:float;var pu:typeUO);pascal;
function fonctionT2Dcorre_BinWidthX(var pu:typeUO):float;pascal;

procedure proT2Dcorre_BinWidthY(w:float;var pu:typeUO);pascal;
function fonctionT2Dcorre_BinWidthY(var pu:typeUO):float;pascal;


implementation

var
  E_binWidth:integer;

{********************** Méthodes de TJPSTH ********************************}


Procedure Tjpsth.Add(vec1,vec2:Tvector);
var
  data1,data2:typedataB;
  i,j,x,y:integer;
  Lclasse:float;
begin
  if not assigned(data) or
     not assigned(vec1) or not assigned(vec1.data) or
     not assigned(vec2) or not assigned(vec2.data)
      then exit;

  data1:=vec1.data;
  data2:=vec2.data;
  Lclasse:=data.ax;

  for i:=data1.Indicemin to data1.Indicemax do
    begin
      x:=truncL(data1.getE(i)/Lclasse+1000000)-1000000;
      if (x>=data.Imin) and (x<=data.Imax) then
        for j:=data2.indicemin to data2.indicemax do
          begin
            y:=truncL(data2.getE(j)/Lclasse+1000000)-1000000;
            if (y>=data.Jmin) and (y<=data.Jmax) then
                data.addI(x,y,1);
          end;
    end;
end;

procedure TJpsth.AddEx(vec1, vec2: Tvector; xorg: float);
var
  data1,data2:typedataB;
  i,j,x,y:integer;
  Lclasse:float;
  i1,j1:integer;
begin
  if not assigned(data) or
     not assigned(vec1) or not assigned(vec1.data) or
     not assigned(vec2) or not assigned(vec2.data)
      then exit;

  data1:=vec1.data;
  data2:=vec2.data;
  Lclasse:=data.ax;
  xorg:=data.bx+Xorg;

  i1:=vec1.getFirstEvent(xorg);
  j1:=vec2.getFirstEvent(xorg);
  for i:=i1 to data1.Indicemax do
    begin
      x:=floor((data1.getE(i)-xorg)/Lclasse);
      if (x>=data.Imin) and (x<=data.Imax) then
        for j:= j1 to data2.indicemax do
          begin
            y:=floor((data2.getE(j)-xorg)/Lclasse);
            if (y>=data.Jmin) and (y<=data.Jmax)
              then data.addI(x,y,1)
              else break;
          end
      else break;
    end;
end;

class function Tjpsth.STMClassName:AnsiString;
begin
  STMClassName:='Jpsth';
end;

{********************** Méthodes de T2Dcorre ********************************}

class function T2Dcorre.STMClassName:AnsiString;
begin
  STMClassName:='2Dcorre';
end;

Procedure T2Dcorre.Add(vec1,vec2:Tvector;x1,x2:float);
var
  data1,data2:typedataB;

  Imin,Imax,Jmin,Jmax:longint;

  i,j,j1:longint;
  k,q:longint;
  dd,diff,vi:float;
  LclasseX,LclasseY:float;
  date0:float;

begin
  if not assigned(data) or
     not assigned(vec1) or not assigned(vec1.data) or
     not assigned(vec2) or not assigned(vec2.data)
      then exit;

  data1:=vec1.data;
  data2:=vec2.data;

  Imin:=data.Imin;
  Imax:=data.Imax;
  Jmin:=data.Jmin;
  Jmax:=data.Jmax;

  LclasseX:=data.ax;
  LclasseY:=data.ay;
  date0:=   data.bx;

  diff:=Jmin*LclasseY;
  j1:=data2.indicemin;
  for i:=data1.indiceMin to data1.indiceMax do
    begin
      vi:=data1.getE(i);
      if (vi>0) and (vi>=x1) and (vi<=x2) then
      begin
        j:=j1;
        q:=truncL((vi-date0)/LclasseX);
        if (q>=Imin) and (q<=Imax) then
          begin
            while (j<=data2.indicemax) and
                  (data2.getE(j)-vi<Diff) do inc(j);
            j1:=j;
            dd:=(data2.getE(j)-vi)/LclasseY;
            while(j<=data2.indicemax) and (dd<=Jmax) do
              begin
                k:=floor(dd);
                if (k>=Jmin) and (k<=Jmax) then data.addI(q,k,1);

                inc(j);
                dd:=(data2.getE(j)-vi)/LclasseY;
              end;
          end;
      end
      else
      if vi>x2 then exit;
    end;

end;

{***********************  Méthodes STM de TJPSTH *****************************}


procedure proTjpsth_create(name:AnsiString;tp:smallint;i1,i2,j1,j2:longint;
                          Lclasse:float;var pu:typeUO);
  begin
    if not Tjpsth.SupportType(typetypeG(tp))
      then sortieErreur('Invalid type');

    createPgObject(name,pu,Tjpsth);

    with Tjpsth(pu) do
    begin
      initTemp(i1,i2,j1,j2,TypetypeG(tp));
      setDx(Lclasse);
      setDy(Lclasse);
    end;
  end;

procedure proTjpsth_create_1(tp:smallint;i1,i2,j1,j2:longint;Lclasse:float;var pu:typeUO);
begin
  proTjpsth_create('',tp,i1,i2,j1,j2, Lclasse, pu);
end;

Procedure proTJpsth_Add(var vec1,vec2:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec1));
  verifierObjet(typeUO(vec2));

  with Tjpsth(pu) do add(vec1,vec2);
end;

procedure proTJpsth_BinWidth(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  if w<=0 then sortieErreur(E_binWidth);
  with Tjpsth(pu) do
    begin
      setDx(w);
      setDy(w);
    end;
end;

function fonctionTJpsth_BinWidth(var pu:typeUO):float;
begin
  verifierObjet(pu);

  with Tjpsth(pu) do  result:=inf.dxu;
end;


procedure proTJpsth_Count(w:longint;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tjpsth(pu) do count:=w;
end;

function fonctionTJpsth_Count(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  with Tjpsth(pu) do result:=count;
end;


{***********************  Méthodes STM de T2DCorre ***************************}

procedure proT2Dcorre_create(name:AnsiString;t:smallint;i1,i2,j1,j2:longint;
                          LclasseX,LclasseY:float;var pu:typeUO);
  begin
    if not T2Dcorre.SupportType (typeTypeG(t))
      then sortieErreur('Invalid type');


   createPgObject(name,pu,T2Dcorre);

    with T2Dcorre(pu) do
    begin
      initTemp(i1,i2,j1,j2,TypetypeG(t));
      setDx(LclasseX);
      setDy(LclasseY);
    end;
  end;

procedure proT2Dcorre_create_1(t:smallint;i1,i2,j1,j2:longint;
                          LclasseX,LclasseY:float;var pu:typeUO);
begin
  proT2Dcorre_create('',t,i1,i2,j1,j2, LclasseX,LclasseY, pu);
end;


Procedure proT2Dcorre_Add(var vec1,vec2:Tvector;x1,x2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(vec1));
  verifierObjet(typeUO(vec2));

  with T2Dcorre(pu) do add(vec1,vec2,x1,x2);
end;


procedure proT2Dcorre_BinWidthX(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  if w<=0 then sortieErreur(E_binWidth);
  with T2Dcorre(pu) do  setDx(w);
end;

function fonctionT2Dcorre_BinWidthX(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with T2Dcorre(pu) do  result:=inf.dxu;
end;

procedure proT2Dcorre_BinWidthY(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  if w<=0 then sortieErreur(E_binWidth);
  with T2Dcorre(pu) do  setDy(w);
end;

function fonctionT2Dcorre_BinWidthY(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with T2Dcorre(pu) do  result:=inf.dyu;
end;


Initialization
AffDebug('Initialization stmJP',0);

installError(E_binWidth, 'Bin width must be positive');
registerObject(Tjpsth,data);
registerObject(T2Dcorre,data);

end.
