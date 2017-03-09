unit filter1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

{$R+}
uses util1,
     Ncdef2,stmError,stmvec1 ;

type
  typeFiltre=record
               a:array[0..12] of float;   {coeff du numérateur }
               b:array[0..12] of float;   {coeff du dénominateur }
               n:integer;                 {degré du numérateur }
               m:integer;                 {degré du dénominateur }
             end;
  typeInitFiltre=array[0..12] of float;



procedure proFilter(tp:integer;passeHaut:boolean;
                    ordre:integer;Fc:float;var source,dest:Tvector;
                    x1,x2:float);pascal;

procedure proFilterC(var source,dest:Tvector;
                     x1,x2:float;
                     var coeffA;sizeA:integer;
                     var coeffB;sizeB:integer;
                     passeHaut:boolean);pascal;


IMPLEMENTATION

function alpha(n,p:integer):integer;
  var
    i,a:integer;
  begin
    a:=1;
    for i:=1 to n-p do a:=a*(p+i);
    for i:=1 to n-p do a:=a div i;
    if p mod 2=0 then alpha:=a else alpha:=-a;
  end;

function grandA(f:typeFiltre;u:integer):float;
  var
    j:integer;
    x:float;
  begin
    with f do
    BEGIN
      x:=0;
      for j:=u to n do x:=x+a[j]*alpha(j,u);
    END;
    grandA:=x;
  end;

function grandB(f:typeFiltre;u:integer):float;
  var
    j:integer;
    x:float;
  begin
    with f do
    BEGIN
      x:=0;
      for j:=u to m do x:=x+b[j]*alpha(j,u);
    END;
    grandB:=x;
  end;

procedure CalculFiltre(var source,dest:typeFiltre);
  var
    u:integer;
    b0:float;
  begin
    fillchar(dest,sizeof(dest),0);
    dest.m:=source.m;
    dest.n:=source.n;

    b0:=grandB(source,0);
    for u:=0 to source.n do dest.a[u]:=grandA(source,u)/b0;
    for u:=1 to source.m do dest.b[u]:=-grandB(source,u)/b0;
  end;



procedure ConvertitPasseHaut(var f:typeFiltre);
  var
    i:integer;
    x:float;
  begin
    with f do
    begin
      for i:=0 to m div 2 do
        begin
          x:=a[i];
          a[i]:=a[m-i];
          a[m-i]:=x;

          x:=b[i];
          b[i]:=b[m-i];
          b[m-i]:=x;
        end;
      n:=m;
    end;
  end;

procedure CalculBessel(var f:typeFiltre;ordre:integer;omegaC:float;
                       PHaut:boolean);
  var
    f0:typeFiltre;
    i:integer;
    y:float;
    st1,st2:AnsiString;

  function bes(n,k:integer):float;
    begin
      if (n=0) and (k=0) then bes:=1
      else
      if (n=1) and ( (k=0) or (k=1) ) then bes:=1
      else
      if (k=n) then bes:=1
      else
      if (n<k) then bes:=0
      else
      if (k=0) or (k=1) then bes:=(2*n-1)*bes(n-1,k)
      else
      bes:=(2*n-1)*bes(n-1,k)+bes(n-2,k-2);
    end;

  function p(x:float;n:integer):float;
    var i:integer;
        y:float;
    begin
      y:=1;
      for i:=1 to n do y:=y*x;
      p:=y;
    end;


  begin
    if (ordre>12) or (OmegaC<=0) then exit;
    with f0 do
    BEGIN
      fillchar(f0,sizeof(f0),0);
      n:=0;
      m:=ordre;
      a[0]:=bes(ordre,0);
      for i:=0 to ordre do b[i]:=bes(ordre,i);

    END;
    if Phaut then convertitPasseHaut(f0);
    with f0 do
    BEGIN
      for i:=0 to 12 do
        begin
          a[i]:=a[i]/p(omegaC,i);
          b[i]:=b[i]/p(omegaC,i);
        end;
    END;
    calculFiltre(f0,f);
    {
    with f do
    begin
      st1:='';
      for i:=0 to n do st1:=st1+Estr1(a[i],10,6);
      st2:='';
      for i:=0 to m do st2:=st2+Estr1(b[i],10,6);
      messageCentral(st1+'|'+st2);

    end;
    }
  end;

procedure AppliquerFiltre(var source,dest:Tvector;
                          var lastE,lastS:typeInitFiltre;
                          f:typeFiltre;
                          i1,i2:longint;
                          inverse:boolean);
  var
    i:integer;
    j0:integer;
    x,y:float;

  function filtre(w:float):float;
    var
      u:integer;
    begin
      move(lastE[0],lastE[1],sizeof(lastE)-sizeof(lastE[0]));
      move(lastS[0],lastS[1],sizeof(lastS)-sizeof(lastS[0]));
      lastE[0]:=w;
      lastS[0]:=0;
      with f do
      BEGIN
        for u:=0 to n do lastS[0]:=lastS[0]+lastE[u]*a[u];
        for u:=1 to m do lastS[0]:=lastS[0]+lastS[u]*b[u];
      END;
      filtre:=lastS[0];
    end;

  begin

    with f do
    begin
      x:=0;
      for i:=0 to n do x:=x+a[i];
      y:=0;
      for i:=0 to m do y:=y+b[i];
    end;
    {
    with f do
      messageCentral('n='+Istr(n)+'  m='+Istr(m)+crlf+
                      Estr(a[0],6)+'  '+Estr(a[1],6)+crlf+
                      Estr(a[2],6)+'  '+Estr(a[3],6)+crlf+
                      Estr(a[4],6)+'  '+Estr(a[5],6)+crlf+
                      Estr(b[0],6)+'  '+Estr(b[1],6)+crlf+
                      Estr(b[2],6)+'  '+Estr(b[3],6)+crlf+
                      Estr(b[4],6)+'  '+Estr(b[5],6)+crlf+
                      Estr(x,12)+crlf+
                      Estr(y,12)
                      );
     }
    source.data.open;
    dest.data.open;

    with dest.data do
    begin
      if inverse then
        for i:=i2 downto i1 do
          setE(i,filtre(source.data.getE(i)))
      else
        for i:=i1 to i2 do
          setE(i,filtre(source.data.getE(i)));
    end;

    source.data.close;
    dest.data.close;
  end;


var
  E_ordreFiltre:integer;
  E_FrequenceCarac:integer;

procedure proFilter(tp:integer;passeHaut:boolean;
                    ordre:integer;Fc:float;
                    var source,dest:Tvector;
                    x1,x2:float);
  var
    fil:typeFiltre;
    lastE,lastS:typeInitFiltre;
    i,i1,i2:longint;
    inverse:boolean;
  begin
    controleParam(ordre,1,12,E_ordreFiltre);
    controleParam(Fc,1E-20,1E1000,E_FrequenceCarac);

    controleVsourceVdest(source,dest,G_none);


    inverse:=x1>x2;
    if inverse then
       begin
         i2:=source.invconvX(x1);
         i1:=source.invconvX(x2);
       end
    else
      begin
         i1:=source.invconvX(x1);
         i2:=source.invconvX(x2);
       end;

    source.cadrageX(i1,i2);
    dest.cadrageX(i1,i2);

    if Fmaj(source.unitX)='SEC'
      then Fc:=Fc*source.Dxu
      else Fc:=Fc*source.Dxu/1000;

    case tp of
      1: CalculBessel(fil,ordre,2*pi*Fc,PasseHaut);
    end;

    if inverse then
    with source.data do
      for i:=0 to 12 do lastE[i]:=getE(i2)
    else
    with source.data do
      for i:=0 to 12 do lastE[i]:=getE(i1);

    if not passeHaut
      then lastS:=lastE
      else fillchar(lastS,sizeof(lastS),0);

    AppliquerFiltre(source,dest,lastE,lastS,fil,i1,i2,inverse);

  end;

procedure proFilterC(var source,dest:Tvector;
                     x1,x2:float;
                     var coeffA;sizeA:integer;
                     var coeffB;sizeB:integer;
                     passeHaut:boolean);
  var
    a1:typeTabFloat ABSOLUTE coeffA;
    b1:typeTabFloat ABSOLUTE coeffB;
    na,nb:integer;
    fil:typeFiltre;
    lastE,lastS:typeInitFiltre;
    i,i1,i2:longint;
    inverse:boolean;
  begin
    controleVsourceVdest(source,dest,G_none);

    inverse:=x1>x2;
    if inverse then
       begin
         i2:=source.invconvX(x1);
         i1:=source.invconvX(x2);
       end
    else
      begin
         i1:=source.invconvX(x1);
         i2:=source.invconvX(x2);
       end;

    source.cadrageX(i1,i2);
    dest.cadrageX(i1,i2);

    na:=sizeA div sizeof(float);
    nb:=sizeB div sizeof(float);

    with fil do
    begin
      for i:=0 to na-1 do a[i]:=a1[i];
      for i:=0 to nb-1 do b[i]:=b1[i];
      n:=na-1;
      while (n>0) and (a[n]=0) do dec(n);
      m:=nb-1;
      while (m>0) and (b[m]=0) do dec(m);
    end;

    if inverse then
    with source.data do
      for i:=0 to 12 do lastE[i]:=getE(i2)
    else
    with source.data do
      for i:=0 to 12 do lastE[i]:=getE(i1);

    if not passeHaut
      then lastS:=lastE
      else fillchar(lastS,sizeof(lastS),0);

    AppliquerFiltre(source,dest,lastE,lastS,fil,i1,i2,inverse);

  end;


end.
