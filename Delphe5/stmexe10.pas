unit stmExe10;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses sysUtils,
     util1,Gdos,DdosFich,Dgraphic,clock0,
     ficDefAc,Ncdef2,
     stmdef,stmObj,stmVec1,
     stmError,stmPg,debug0;


type
  TsearchWinRec=record
                  index:integer;
                  y1,y2:float;
                  IsAbs:boolean;
                  iref:integer;
                end;
  TsearchWin=array of TsearchWinRec;


const
  modeRechercheEtendu:boolean=false;

  Every10000:procedure of object=nil;

procedure ProTransferer(var dest,source:Tvector);pascal;
procedure ProTransferer1(var dest,source:Tvector;x1,x2,xd:float);pascal;


procedure ProOpposer(var dest,source:Tvector);pascal;
procedure ProAdditionnerSeq(var dest,U1,U2:Tvector);pascal;
procedure ProSoustraireSeq(var dest,U1,U2:Tvector); pascal;
procedure PromultiplyVector(var dest,U1,U2:Tvector);pascal;

procedure ProDivideVector(var dest,U1,U2:Tvector);pascal;
procedure ProDivideVector1(var dest,U1,U2:Tvector;max:float);pascal;

procedure ProAugmenterSeq(var dest,source:Tvector;x:float);pascal;
procedure ProKmultiplyVector(var dest,source:Tvector;x:float);pascal;
procedure proRotationOrigine(var t:Tvector;x0:float);pascal;
procedure proRotateVector1(var source,dest:Tvector;x0:float);pascal;

procedure ProTransfertUnites(var source,dest:Tvector);pascal;

Function FonctionNextExtrema(var source:Tvector;x2,ll,hh:float;
                             var xp1,xp2:float;var up:boolean):float;pascal;

function FonctionPremierMaximum(var source:Tvector;x1,x2,ll,hh:float;
                                tout:boolean):float;pascal;
function FonctionPremierMinimum(var source:Tvector;x1,x2,ll,hh:float;
                                tout:boolean):float;pascal;
function FonctionDernierMaximum(var source:Tvector;x1,x2,ll,hh:float;
                                  tout:boolean):float;pascal;
function FonctionDernierMinimum(var source:Tvector;x1,x2,ll,hh:float;
                                  tout:boolean):float;pascal;
function FonctionPremiereMarche(var source:Tvector;x1,x2,ll,hh:float;
                                positive:boolean):float;pascal;
function FonctionDerniereMarche(var source:Tvector;x1,x2,ll,hh:float;
                                  positive:boolean):float;pascal;

function FonctionPremierDepassement(var source:Tvector;x1,x2,y0:float;
                                positif:boolean):float;pascal;
function FonctionDernierDepassement(var source:Tvector;x1,x2,y0:float;
                                positif:boolean):float;pascal;

procedure proSetModeRecherche(etendu:boolean);pascal;

function FonctionMAXI(var source:Tvector;x1,x2:float):float;pascal;
function FonctionMINI(var source:Tvector;x1,x2:float):float;pascal;
function FonctionMAXIX(var source:Tvector;x1,x2:float):float;pascal;
function FonctionMINIX(var source:Tvector;x1,x2:float):float;pascal;
function FonctionMAXIR(var source:Tvector;x1,x2,x1r,x2r:float):float;pascal;
function FonctionMINIR(var source:Tvector;x1,x2,x1r,x2r:float):float;pascal;
function FonctionMOYENNE(var source:Tvector;x1,x2:float):float;pascal;
function FonctionECARTTYPE(var source:Tvector;x1,x2:float):float;pascal;

function FonctionPA1(var source:Tvector;
                     x1c,x2c,x1r,x2r,N1:float):float;pascal;
function FonctionPA2(var source:Tvector;
                     y1,x1c,x2c:float):float;pascal;
function FonctionTM1(var source:Tvector;x1,x2:float;montee:boolean;
                     var x1r,x2r:float):float;pascal;
function FonctionTM2(var source:Tvector;x10,x20,x1,x2,Np:float;montee:boolean;
                     var x1r,x2r:float):float;pascal;


function FonctionPremierMaximum1(var source:Tvector;x1,x2,ll,hh:float;
                                 var xp1,xp2:float):float;pascal;
function FonctionDernierMaximum1(var source:Tvector;x1,x2,ll,hh:float;
                                 var xp1,xp2:float):float;pascal;
function FonctionPremierMinimum1(var source:Tvector;x1,x2,ll,hh:float;
                                 var xp1,xp2:float):float;pascal;
function FonctionDernierMinimum1(var source:Tvector;x1,x2,ll,hh:float;
                                 var xp1,xp2:float):float;pascal;

function fonctionShape1(var s:Tvector;p1:integer;
                        var pu:Tvector;nb:integer):float;pascal;

procedure SearchExtrema(var source,dest:Tvector;x1,x2,hh,linhib:float;Fup,Fdw:boolean;
                      Vabs,Vamp,Vdt:Tvector;const winList:TsearchWin=nil);
procedure SearchSteps(source,dest:Tvector;x1,x2,hh,ll,linhib:float;Fup,Fdw:boolean;
                      VHinit,VHtot,VLtot:Tvector;OptionP:boolean;
                      const winList:TsearchWin=nil );
procedure SearchCrossings(var source,dest:Tvector;x1,x2,hh,linhib:float;
                      Fup,Fdw:boolean;const winList:TsearchWin=nil);
procedure SearchSlopes(var source,dest:Tvector;x1,x2,hh,ll,linhib:float;
                      Fup,Fdw:boolean;const winList:TsearchWin=nil);

procedure SearchEvt1(var source,dest:Tvector;x1,x2:float;var winList:array of TsearchWin;linhib:float);




IMPLEMENTATION

var
  E_transferer1:integer;
  E_rotation:integer;




procedure ProTransferer(var dest,source:Tvector);
begin
  VerifierVecteur(source);
  VerifierVecteur(dest);
  VadjustIstartIendTpNum(source,dest);

  dest.copyDataFrom(source);
end;


procedure ProTransferer1(var dest,source:Tvector;x1,x2,xd:float);
var
  i1,i2,id:integer;
begin
  verifierVecteur(source);
  verifierVecteur(dest);

  dest.controleReadOnly;

  dest.dxu:=source.dxu;

  i1:=source.invconvX(x1);
  i2:=source.invconvX(x2);
  id:=dest.invconvX(xd);

  dest.copyDataFromVec(source,i1,i2,id);
end;

procedure ProAugmenterSeq(var dest,source:Tvector;x:float);
  var
    i:integer;
  begin
    controleVsourceVdest(source,dest,G_none);

    source.data.open;
    dest.data.open;

    for i:=dest.data.indiceMin to dest.data.indiceMax do
      dest.data.setE(i,source.data.getE(i)+x);

    source.data.close;
    dest.data.close;
  end;

procedure ProKmultiplyVector(var dest,source:Tvector;x:float);
  var
    i:integer;
  begin
    controleVsourceVdest(source,dest,G_none);

    source.data.open;
    dest.data.open;

    try
      for i:=dest.data.indiceMin to dest.data.indiceMax do
        dest.data.setE(i,source.data.getE(i)*x);
    finally
      source.data.close;
      dest.data.close;
    end;
  end;


procedure ProOpposer(var dest,source:Tvector);
  var
    i:integer;
  begin
    controleVsourceVdest(source,dest,G_none);

    source.data.open;
    dest.data.open;

    for i:=dest.data.indiceMin to dest.data.indiceMax do
      dest.data.setE(i,-source.data.getE(i));

    source.data.close;
    dest.data.close;
  end;

procedure IntervalleCommun(v1,v2:Tvector;var x1,x2:integer);
begin
  if v1.data.indicemin>v2.data.indicemin
    then x1:=v1.data.indicemin
    else x1:=v2.data.indicemin;

  if v1.data.indicemax<v2.data.indicemax
    then x2:=v1.data.indicemax
    else x2:=v2.data.indicemax;
end;

procedure ProAdditionnerSeq(var dest,U1,U2:Tvector);
  var
    i,i1,i2:integer;
  begin
    verifierVecteur(U1);
    verifierVecteur(U2);
    verifierVecteur(dest);

    dest.controleReadOnly;
    dest.extendDim(U1,G_none);

    dest.dxu:=U1.dxu;
    dest.x0u:=U1.x0u;
    dest.dyu:=U1.dyu;
    dest.y0u:=U1.y0u;

    dest.data.open;
    U1.data.open;
    U2.data.open;

    intervalleCommun(u1,u2,i1,i2);

    for i:=i1 to i2 do
      dest.data.setE(i,U1.data.getE(i)+U2.data.getE(i));

    dest.data.close;
    U1.data.close;
    U1.data.close;
  end;

procedure ProSoustraireSeq(var dest,U1,U2:Tvector);
  var
    i,i1,i2:integer;
    j0:integer;
  begin
    verifierVecteur(U1);
    verifierVecteur(U2);
    verifierVecteur(dest);
    dest.controleReadOnly;
    dest.extendDim(U1,G_none);

    dest.dxu:=U1.dxu;
    dest.x0u:=U1.x0u;
    dest.dyu:=U1.dyu;
    dest.y0u:=U1.y0u;

    dest.data.open;
    U1.data.open;
    U2.data.open;

    intervalleCommun(u1,u2,i1,i2);
    for i:=i1 to i2 do
      dest.data.setE(i,U1.data.getE(i)-U2.data.getE(i));

    dest.data.close;
    U1.data.close;
    U1.data.close;
  end;

procedure PromultiplyVector(var dest,U1,U2:Tvector);
  var
    i,i1,i2:integer;
    j0:integer;
  begin
    verifierVecteur(U1);
    verifierVecteur(U2);
    verifierVecteur(dest);
    dest.controleReadOnly;
    dest.extendDim(U1,G_none);

    dest.dxu:=U1.dxu;
    dest.x0u:=U1.x0u;
    dest.dyu:=U1.dyu;
    dest.y0u:=U1.y0u;

    dest.data.open;
    U1.data.open;
    U2.data.open;

    intervalleCommun(u1,u2,i1,i2);

    if (dest.tbSmallint<>nil) and (U1.tbSmallint<>nil) and (U2.tbSmallint<>nil)  then
      for i:=i1 to i2 do dest.tbSmallint^[i]:=U1.tbSmallint^[i]*U2.tbSmallint^[i]
    else
    if (dest.tbLong<>nil) and (U1.tbLong<>nil) and (U2.tbLong<>nil)  then
      for i:=i1 to i2 do dest.tbLong^[i]:=U1.tbLong^[i]*U2.tbLong^[i]
    else
      for i:=i1 to i2 do
        dest.data.setE(i,U1.data.getE(i)*U2.data.getE(i));

    dest.data.close;
    U1.data.close;
    U1.data.close;
  end;

procedure ProDivideVector(var dest,U1,U2:Tvector);
  var
    i,i1,i2:integer;
    y:float;
  begin
    verifierVecteur(U1);
    verifierVecteur(U2);
    verifierVecteur(dest);
    dest.controleReadOnly;
    dest.extendDim(U1,G_none);

    dest.dxu:=U1.dxu;
    dest.x0u:=U1.x0u;
    dest.dyu:=U1.dyu;
    dest.y0u:=U1.y0u;

    dest.data.open;
    U1.data.open;
    U2.data.open;

    intervalleCommun(u1,u2,i1,i2);
    for i:=i1 to i2 do
      begin
        y:=U2.data.getE(i);
        if y<>0
          then dest.data.setE(i,U1.data.getE(i)/y)
          else dest.data.setE(i,0);
      end;
    dest.data.close;
    U1.data.close;
    U1.data.close;
  end;

procedure ProDivideVector1(var dest,U1,U2:Tvector;max:float);
  var
    i,i1,i2:integer;
    y:float;
  begin
    verifierVecteur(U1);
    verifierVecteur(U2);
    verifierVecteur(dest);
    dest.controleReadOnly;
    dest.extendDim(U1,G_none);

    dest.dxu:=U1.dxu;
    dest.x0u:=U1.x0u;
    dest.dyu:=U1.dyu;
    dest.y0u:=U1.y0u;

    dest.data.open;
    U1.data.open;
    U2.data.open;

    intervalleCommun(u1,u2,i1,i2);
    for i:=i1 to i2 do
      begin
        y:=U2.data.getE(i);
        if y<>0
          then dest.data.setE(i,U1.data.getE(i)/y)
          else dest.data.setE(i,max);
      end;
    dest.data.close;
    U1.data.close;
    U1.data.close;
  end;



procedure proRotationOrigine(var t:Tvector;x0:float);
  var
    i0,i:integer;
    buf:Ptabsingle;
  begin
    verifierVecteur(t);
    t.controleReadOnly;

    with t.data do
    begin
      i0:=roundL(invConvX(x0));
      if i0=0 then exit;


      if maxAvail<abs(i0)*sizeof(single) then sortieErreur(E_mem);
      getmem(buf,abs(i0)*sizeof(single));
      t.data.open;

      controleParam(i0,indiceMin,indiceMax,E_rotation);

      if i0>0 then
      begin
        for i:=indicemin to indicemin+i0-1 do buf^[i-indicemin]:=getE(i);
        for i:=indicemin+i0 to indiceMax do setE(i-i0,getE(i));
        for i:=0 to i0-1 do setE(indicemax-i0+i+1,buf^[i]);
      end
      else
      begin
        i0:=-i0;
        for i:=indicemax-i0+1 to indicemax do buf^[i-indicemax+i0-1]:=getE(i);
        for i:=indiceMax-i0 downto indicemin  do setE(i+i0,getE(i));
        for i:=0 to i0-1 do setE(indicemin+i,buf^[i]);
      end;

      t.data.close;
      freemem(buf);
    end;
  end;

procedure proRotateVector1(var source,dest:Tvector;x0:float);
var
  i0,i1,i,nb,sz:integer;
  buf1,buf2:PtabOctet;
begin
  controleVsourceVdest(source,dest,source.tpNum);

  buf1:=source.data.getPointer;
  buf2:=dest.data.getPointer;

  with dest do
  begin
    nb:=Iend-Istart+1;
    i0:=roundL(invConvX(x0));
    controleParam(i0,istart,iend,E_rotation);

    if source.inf.temp and dest.inf.temp and (buf1<>nil) and (buf2<>nil) then
      begin
        sz:=tailletypeG[source.tpNum];
        i0:=i0-Istart;
        move(buf1^[i0*sz],buf2^[0],(nb-i0)*sz);
        move(buf1^[0],buf2^[(nb-i0)*sz],(i0)*sz);
      end
    else
      begin
        source.data.open;
        data.open;
        i1:=istart;
        for i:=Istart to Iend do
          data.setE((i-i1-i0+nb) mod nb+i1,source.data.getE(i));
        data.close;
        source.data.close;
      end;
  end;

end;


procedure ProTransfertUnites(var source,dest:Tvector);
  begin
    verifierVecteur(source);
    verifierVecteur(dest);

    dest.dxu:=source.dxu;
    dest.x0u:=source.x0u;
    dest.dyu:=source.dyu;
    dest.y0u:=source.y0u;
  end;


procedure NextExt1(var source:Tvector;i2:integer;h:integer;
                      var p,p1,p2:integer;var up:boolean);
  var
    i:integer;
    j0:integer;

  procedure trouverMax;
    var
      max,w:integer;
      j:integer;
    begin
      with source.data do
      begin
        max:=getI(i);
        j:=i;
        repeat
          inc(j);
          w:=getI(j);
          if (w>max) then
            begin
              i:=j;
              max:=w;
            end;
        until (j>i2) or (max-w>=h);
        p2:=j;
      end;

      if j>i2 then i:=i2;
    end;


  procedure trouverMin;
    var
      min,w:integer;
      j:integer;
    begin

      with source.data do
      begin
        min:=getI(i);
        j:=i;
        repeat
          inc(j);
          w:=getI(j);
          if (w<min) then
            begin
              i:=j;
              min:=w;
            end;
        until (j>i2) or (w-min>=h);
        p2:=j;
      end;

      if j>i2 then i:=i2;
    end;

  begin
    source.data.open;

    if up then
      begin
        i:=p2;
        trouverMin;

        if i<i2 then
          begin
            j0:=source.data.getI(i)+h;
            p:=i;
            repeat
              dec(i);
            until (i<=p1) or (source.data.getI(i)>j0);
            p1:=i;
          end
        else
          begin
            p:=i2;
            p2:=i2;
          end;
      end
    else
      begin
        i:=p2;
        trouverMax;

        if i<i2 then
          begin
            j0:=source.data.getI(i)-h;
            p:=i;
            repeat
              dec(i);
            until (i<=p1) or (source.data.getI(i)<j0);
            p1:=i;
          end
        else
          begin
            p:=i2;
            p2:=i2;
          end;
      end;

    up:=not up;
    source.data.close;
  end;

procedure NextExt1Ex(var source:Tvector;i2:integer;h:float;
                      var p,p1,p2:integer;var up:boolean);
  var
    i:integer;
    y0:float;

  procedure trouverMax;
    var
      max,w:float;
      j:integer;
    begin
      with source.data do
      begin
        max:=getE(i);
        j:=i;
        repeat
          inc(j);
          w:=getE(j);
          if (w>max) then
            begin
              i:=j;
              max:=w;
            end;
        until (j>i2) or (max-w>=h);
        p2:=j;
      end;

      if j>i2 then i:=i2;
    end;


  procedure trouverMin;
    var
      min,w:float;
      j:integer;
    begin

      with source.data do
      begin
        min:=getE(i);
        j:=i;
        repeat
          inc(j);
          w:=getE(j);
          if (w<min) then
            begin
              i:=j;
              min:=w;
            end;
        until (j>i2) or (w-min>=h);
        p2:=j;
      end;

      if j>i2 then i:=i2;
    end;

  begin
    source.data.open;

    if up then
      begin
        i:=p2;
        trouverMin;

        if i<i2 then
          begin
            y0:=source.data.getE(i)+h;
            p:=i;
            repeat
              dec(i);
            until (i<=p1) or (source.data.getE(i)>y0);
            p1:=i;
          end
        else
          begin
            p:=i2;
            p2:=i2;
          end;
      end
    else
      begin
        i:=p2;
        trouverMax;

        if i<i2 then
          begin
            y0:=source.data.getE(i)-h;
            p:=i;
            repeat
              dec(i);
            until (i<=p1) or (source.data.getE(i)<y0);
            p1:=i;
          end
        else
          begin
            p:=i2;
            p2:=i2;
          end;
      end;

    up:=not up;
    source.data.close;
  end;



Function FonctionNextExtrema(var source:Tvector;x2,ll,hh:float;
                             var xp1,xp2:float;var up:boolean):float;
  var
    i1,i2,p,p1,p2:integer;
  begin
    verifierVecteur(source);

    i2:=source.invConvX(x2);
    i1:=0;
    source.cadrageX(i1,i2);
    p1:=source.invConvX(xp1);
    p2:=source.invConvX(xp2);

    if source.inf.tpNum=G_smallint
      then NextExt1(source,i2,roundI(hh/source.Dyu),p,p1,p2,up)
      else NextExt1ex(source,i2,hh,p,p1,p2,up);

    FonctionNextExtrema:=source.convX(p);
    xp1:=source.convX(p1);
    xp2:=source.convX(p2);
  end;


function AcceptEvent(Vsource:Tvector;i0:integer;const Iwin:TsearchWin):boolean;
var
  i:integer;
  y,y0:float;
begin
  result:=true;

  if assigned(Iwin) then
  begin
    for i:=0 to high(Iwin) do
    with Iwin[i] do
    begin
      y:=Vsource.Yvalue[i0+index];
      if isAbs
        then result:=result and (y>=y1) and (y<y2)
      else
        begin
          y0:=Vsource.Yvalue[i0+iref];
          result:=result and (y>=y1+y0) and (y<y2+y0);
        end;
    end;
  end;
end;


procedure SearchExtrema(var source,dest:Tvector;x1,x2,hh,linhib:float;Fup,Fdw:boolean;
           Vabs,Vamp,Vdt:Tvector;const winList:TsearchWin=nil);
var
  i,i1,i2,p,p1,p2:integer;
  Imin,Imax:integer;
  min,max,w:double;
  up:boolean;

  x,y,lastX,lastY:double;
  lastp:integer;
  dlinhib:float;


procedure store;
begin
  if (p<=lastp+dlinhib) or not acceptEvent(source,p,winList) then exit;
  x:=source.convx(p);
  y:=source.data.getE(p);
  dest.addToList(x);
  if assigned(Vabs) then Vabs.addToList(y);
  if assigned(Vamp) then Vamp.addToList(y-lastY);
  if assigned(Vdt) then Vdt.addToList(x-lastX);
  lastp:=p;
end;

begin
  verifierVecteur(source);
  verifierVecteur(dest);

  i1:=source.invConvX(x1);
  i2:=source.invConvX(x2);
  source.cadrageX(i1,i2);
  lastp:=i1;

  dlinhib:=source.invConvX(lInhib)-source.invConvX(0);

  i:=i1;
  Imin:=i;
  Imax:=i;
  min:=source.data.getE(i);
  max:=min;

  repeat
     inc(i);
     if getFlagClock(2) then
       begin
         if TestEscape then exit;
         if assigned(every10000) then every10000;
       end;

     w:=source.data.getE(i);
     if w>max then
       begin
         max:=w;
         Imax:=i;
       end
     else
     if w<min then
       begin
         min:=w;
         Imin:=i;
       end;
  until (i>=i2)
        or
        (Imin>Imax) and (max-min>=hh) and (w-min>=hh)
        or
        (Imin<Imax) and (max-min>=hh) and (max-w>=hh);

  if i>=i2 then exit;

  up:=(Imin<Imax);
  if up then
    begin
      lastX:=source.convx(Imax);
      lastY:=source.data.getE(Imax);
    end
  else
    begin
      lastX:=source.convx(Imin);
      lastY:=source.data.getE(Imin);
    end;

  if up and Fup then
    begin
      lastp:=Imax;
      dest.addToList(lastX);
      if assigned(Vabs) then Vabs.addToList(lastY);
      if assigned(Vamp) then Vamp.addToList(0);
      if assigned(Vdt) then Vdt.addToList(0);
    end
  else
  if not up and Fdw then
    begin
      lastp:=Imin;
      dest.addToList(source.convx(Imin));
      if assigned(Vabs) then Vabs.addToList(source.data.getE(Imin));
      if assigned(Vamp) then Vamp.addToList(0);
      if assigned(Vdt) then Vdt.addToList(0);
    end;

  p2:=i;

  if source.inf.tpNum=G_smallint then
    repeat
      if getFlagClock(2) then
        begin
          if TestEscape then exit;
          if assigned(every10000) then every10000;
        end;

      NextExt1(source,i2,roundI(hh/source.Dyu),p,p1,p2,up);
      if up and Fup then store
      else
      if not up and Fdw then store;
      lastX:=x;
      lastY:=y;
    until p2>=i2
  else
    repeat
      if getFlagClock(2) then
        begin
          if TestEscape then exit;
          if assigned(every10000) then every10000;
        end;

      NextExt1ex(source,i2,hh,p,p1,p2,up);
      if up and Fup then store
      else
      if not up and Fdw then store;
      lastX:=x;
      lastY:=y;
    until p2>=i2;

end;


procedure SearchCrossings(var source,dest:Tvector;x1,x2,hh,lInhib:float;
                          Fup,Fdw:boolean;const winList:TsearchWin=nil);
var
  i,i1,i2:integer;
  w,w1:double;
  dlInhib:integer;
begin
  verifierVecteur(source);
  verifierVecteur(dest);

  i1:=source.invConvX(x1);
  i2:=source.invConvX(x2);
  source.cadrageX(i1,i2);

  i:=i1;
  w1:=source.data.getE(i);
  dlinhib:=source.invConvX(lInhib)-source.invConvX(0);

  repeat
     inc(i);
     w:=source.data.getE(i);
     if Fup and (w1<hh) and (w>=hh) and acceptEvent(source,i,winList) then
       begin
         dest.addToList(source.convx(i));
         inc(i,dlinhib);
       end
     else
     if Fdw and (w1>=hh) and (w<hh) and acceptEvent(source,i,winList) then
       begin
         dest.addToList(source.convx(i));
         inc(i,dlinhib);
       end;
     w1:=w;

     if getFlagClock(2) then
       begin
         if TestEscape then exit;
         if assigned(every10000) then every10000;
       end;

  until i>=i2;

end;

procedure SearchSteps(source,dest:Tvector;x1,x2,hh,ll,lInhib:float;Fup,Fdw:boolean;
                      VHinit,VHtot,VLtot:Tvector; optionP:boolean;const winList:TsearchWin=nil );
var
  i,i1,i2:integer;
  w:double;
  dl,dlInhib:integer;
  i0:integer;
begin
  verifierVecteur(source);
  verifierVecteur(dest);

  i1:=source.invConvX(x1);
  i2:=source.invConvX(x2);
  source.cadrageX(i1,i2);

  dl:=source.invConvX(ll)-source.invConvX(0);
  i:=i1+dl;

  dlinhib:=source.invConvX(lInhib)-source.invConvX(0);

  while (i<=i2) do
  begin
     w:=source.data.getE(i)-source.data.getE(i-dl);
     if Fup and (w>=hh) and acceptEvent(source,i,winList) then
       begin
         dest.addToList(source.convx(i));
         i0:=i;
         if assigned(VHinit) then VHinit.addToList(w);

         if OptionP then
           while (i<i2) and (source.data.getE(i+1)-source.data.getE(i-dl+1)>=hh)
           do inc(i);

         if assigned(VHtot)
           then VHtot.addToList(source.data.getE(i)-source.data.getE(i0-dl) );
         if assigned(VLtot) then VLtot.addToList( (i-i0+dl)*source.dxu );

         if i<i0+dlInhib then i:=i0+dlInhib;
       end
     else
     if Fdw and (w<=-hh) and acceptEvent(source,i,winList) then
       begin
         dest.addToList(source.convx(i));
         i0:=i;
         if assigned(VHinit) then VHinit.addToList(w);

         if OptionP then
           while (i<i2) and (source.data.getE(i+1)-source.data.getE(i-dl+1)<=-hh)
           do inc(i);

         if assigned(VHtot)
           then VHtot.addToList(source.data.getE(i)-source.data.getE(i0-dl) );
         if assigned(VLtot) then VLtot.addToList( (i-i0+dl)*source.dxu );

         if i<i0+dlInhib then i:=i0+dlInhib;
       end;
     inc(i);

     if getFlagClock(2) then
       begin
         if TestEscape then exit;
         if assigned(every10000) then every10000;
       end;
  end;

end;

procedure SearchSlopes(var source,dest:Tvector;x1,x2,hh,ll,linhib:float;
                       Fup,Fdw:boolean;const winList:TsearchWin=nil);
var
  i,i1,i2:integer;
  w,w1:double;
  dl:integer;
  dlinhib:integer;
begin
  verifierVecteur(source);
  verifierVecteur(dest);

  i1:=source.invConvX(x1);
  i2:=source.invConvX(x2);
  source.cadrageX(i1,i2);

  dlinhib:=source.invConvX(lInhib)-source.invConvX(0);
  dl:=source.invConvX(ll)-source.invConvX(0);
  i:=i1+dl;

  w1:=source.data.getE(i)-source.data.getE(i-dl);
  while (i<i2) do
  begin
     inc(i);
     w:=source.data.getE(i)-source.data.getE(i-dl);

     if Fup and (w-w1>=hh) and acceptEvent(source,i,winList) then
       begin
         dest.addToList(source.convx(i));
         inc(i,dlinhib);
       end
     else
     if Fdw and (w1-w>=hh) and acceptEvent(source,i,winList) then
       begin
         dest.addToList(source.convx(i));
         inc(i,dlinhib);
       end;

     w1:=w;

     if getFlagClock(2) then
       begin
         if TestEscape then exit;
         if assigned(every10000) then every10000;
       end;
  end;
end;


procedure premierMax1(var source:Tvector;i1,i2:integer;l:integer;h:integer;
                      var p,p1,p2:integer;versplus:boolean);
  var
    i,Ideb,Ifin:integer;
    ok:boolean;

  function trouver:boolean;
    var
      min,max:integer;
      j,Imin,Imax:integer;
    begin
      trouver:=false;

      if i-l<i1 then Imin:=i1
                else Imin:=i-l;
      if i+l>i2 then Imax:=i2
                else Imax:=i+l;

      with source.data do
      begin
        max:=getI(i);
        j:=i;
        repeat
          dec(j);
          if (j<Imin) or (getI(j)>max) then exit;
        until (max-getI(j)>=h);
        p1:=j;

        j:=i;
        repeat
          inc(j);
          if (j>Imax) or (getI(j)>max) then exit;
        until (max-getI(j)>=h);
        p2:=j;
      end;

      trouver:=true;
    end;

  begin
    source.data.open;

    Ideb:=i1+1;
    Ifin:=i2-1;

    ok:=false;

    if versPlus then
      begin
        i:=Ideb;
        while (i<=Ifin) and not OK do
          begin
            ok:=trouver;
            inc(i);
          end;
        if ok then p:=i-1 else p:=i2;
      end
    else
      begin
        i:=Ifin;
        while (i>=Ideb) and not OK do
          begin
            ok:=trouver;
            dec(i);
          end;
        if ok then p:=i+1 else p:=i1;
      end;

    source.data.close;
  end;

procedure premierMax1ex(var source:Tvector;i1,i2:integer;l:integer;h:float;
                      var p,p1,p2:integer;versplus:boolean);
  var
    i,Ideb,Ifin:integer;
    ok:boolean;

  function trouver:boolean;
    var
      min,max:float;
      j,Imin,Imax:integer;
    begin
      trouver:=false;

      if i-l<i1 then Imin:=i1
                else Imin:=i-l;
      if i+l>i2 then Imax:=i2
                else Imax:=i+l;

      with source.data do
      begin
        max:=getE(i);
        j:=i;
        repeat
          dec(j);
          if (j<Imin) or (getE(j)>max) then exit;
        until (max-getE(j)>=h);
        p1:=j;

        j:=i;
        repeat
          inc(j);
          if (j>Imax) or (getE(j)>max) then exit;
        until (max-getE(j)>=h);
        p2:=j;
      end;

      trouver:=true;
    end;

  begin
    source.data.open;

    Ideb:=i1+1;
    Ifin:=i2-1;

    ok:=false;

    if versPlus then
      begin
        i:=Ideb;
        while (i<=Ifin) and not OK do
          begin
            ok:=trouver;
            inc(i);
          end;
        if ok then p:=i-1 else p:=i2;
      end
    else
      begin
        i:=Ifin;
        while (i>=Ideb) and not OK do
          begin
            ok:=trouver;
            dec(i);
          end;
        if ok then p:=i+1 else p:=i1;
      end;

    source.data.close;
  end;



procedure PremierMax01(var source:Tvector;x1,x2,ll,hh:float;
                       versplus:boolean;var xp,xp1,xp2:float);
  var
    i1,i2,p,p1,p2:integer;
    l,h:integer;
  begin
    verifierVecteur(source);

    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);
    source.cadrageX(i1,i2);
    l:=roundI(ll/source.Dxu);
    h:=roundI(hh/source.Dyu);

    if (source.inf.tpNum=G_smallint)
      then premierMax1(source,i1,i2,l,h,p,p1,p2,versplus)
      else premierMax1ex(source,i1,i2,l,hh,p,p1,p2,versplus);

    xp:=source.convX(p);
    xp1:=source.convX(p1);
    xp2:=source.convX(p2);
  end;

function FonctionPremierMaximum1(var source:Tvector;x1,x2,ll,hh:float;
                                 var xp1,xp2:float):float;
  var
    xp:float;
  begin
     premierMax01(source,x1,x2,ll,hh,true,xp,xp1,xp2);
     FonctionPremierMaximum1:=xp;
  end;

function FonctionDernierMaximum1(var source:Tvector;x1,x2,ll,hh:float;
                                 var xp1,xp2:float):float;
  var
    xp:float;
  begin
     premierMax01(source,x1,x2,ll,hh,false,xp,xp1,xp2);
     FonctionDernierMaximum1:=xp;
  end;

procedure premierMin1(var source:Tvector;i1,i2:integer;l:integer;h:integer;
                      var p,p1,p2:integer;versplus:boolean);
  var
    i,Ideb,Ifin:integer;
    ok:boolean;

  function trouver:boolean;
    var
      min:integer;
      j,Imin,Imax:integer;
    begin
      trouver:=false;

      if i-l<i1 then Imin:=i1
                else Imin:=i-l;
      if i+l>i2 then Imax:=i2
                else Imax:=i+l;

      with source.data do
      begin
        min:=getI(i);
        j:=i;
        repeat
          dec(j);
          if (j<Imin) or (getI(j)<min) then exit;
        until (getI(j)-min>=h);
        p1:=j;

        j:=i;
        repeat
          inc(j);
          if (j>Imax) or (getI(j)<min) then exit;
        until (getI(j)-min>=h);
        p2:=j;
      end;

      trouver:=true;
    end;

  begin
    verifierVecteur(source);
    source.data.open;

    Ideb:=i1+1;
    Ifin:=i2-1;

    ok:=false;

    if versPlus then
      begin
        i:=Ideb;
        while (i<=Ifin) and not OK do
          begin
            ok:=trouver;
            inc(i);
          end;
        if ok then p:=i-1 else p:=i2;
      end
    else
      begin
        i:=Ifin;
        while (i>=Ideb) and not OK do
          begin
            ok:=trouver;
            dec(i);
          end;
        if ok then p:=i+1 else p:=i1;
      end;

    source.data.close;
  end;

procedure premierMin1ex(var source:Tvector;i1,i2:integer;l:integer;h:float;
                      var p,p1,p2:integer;versplus:boolean);
  var
    i,Ideb,Ifin:integer;
    ok:boolean;

  function trouver:boolean;
    var
      min:float;
      j,Imin,Imax:integer;
    begin
      trouver:=false;

      if i-l<i1 then Imin:=i1
                else Imin:=i-l;
      if i+l>i2 then Imax:=i2
                else Imax:=i+l;

      with source.data do
      begin
        min:=getE(i);
        j:=i;
        repeat
          dec(j);
          if (j<Imin) or (getE(j)<min) then exit;
        until (getE(j)-min>=h);
        p1:=j;

        j:=i;
        repeat
          inc(j);
          if (j>Imax) or (getE(j)<min) then exit;
        until (getE(j)-min>=h);
        p2:=j;
      end;

      trouver:=true;
    end;

  begin
    verifierVecteur(source);
    source.data.open;

    Ideb:=i1+1;
    Ifin:=i2-1;

    ok:=false;

    if versPlus then
      begin
        i:=Ideb;
        while (i<=Ifin) and not OK do
          begin
            ok:=trouver;
            inc(i);
          end;
        if ok then p:=i-1 else p:=i2;
      end
    else
      begin
        i:=Ifin;
        while (i>=Ideb) and not OK do
          begin
            ok:=trouver;
            dec(i);
          end;
        if ok then p:=i+1 else p:=i1;
      end;

    source.data.close;
  end;

procedure PremierMin01(var source:Tvector;x1,x2,ll,hh:float;
                       versplus:boolean;var xp,xp1,xp2:float);
  var
    i1,i2,p,p1,p2:integer;
    l,h:integer;
  begin
    verifierVecteur(source);
    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);
    source.cadrageX(i1,i2);
    l:=roundI(ll/source.Dxu);
    h:=roundI(hh/source.Dyu);

    if (source.inf.tpNum=G_smallint)
      then premierMin1(source,i1,i2,l,h,p,p1,p2,versplus)
      else premierMin1ex(source,i1,i2,l,hh,p,p1,p2,versplus);

    xp:=source.convX(p);
    xp1:=source.convX(p1);
    xp2:=source.convX(p2);
  end;

function FonctionPremierMinimum1(var source:Tvector;x1,x2,ll,hh:float;
                                 var xp1,xp2:float):float;
  var
    xp:float;
  begin
     premierMin01(source,x1,x2,ll,hh,true,xp,xp1,xp2);
     FonctionPremierMinimum1:=xp;
  end;

function FonctionDernierMinimum1(var source:Tvector;x1,x2,ll,hh:float;
                                 var xp1,xp2:float):float;
  var
    xp:float;
  begin
     premierMin01(source,x1,x2,ll,hh,false,xp,xp1,xp2);
     FonctionDernierMinimum1:=xp;
  end;



procedure premierMax(var source:Tvector;i1,i2:integer;l,h:integer;
                     var p:integer;tout,versplus:boolean);
  var
    i,Ideb,Ifin:integer;
    ok:boolean;

  function trouver:boolean;
    var
      min,max:integer;
      j,Imin,Imax:integer;
    begin
      trouver:=false;

      if i-l<i1 then Imin:=i1
                else Imin:=i-l;
      if i+l>i2 then Imax:=i2
                else Imax:=i+l;

      with source.data do
      begin
        max:=getI(i);
        min:=32767;
        if (i<Imax) and (getI(i+1)>max) then exit;
        for j:=Imin to i-1 do
          begin
            if getI(j)>max then exit;
            if getI(j)<min then min:=getI(j);
          end;
        if max-min<h then
          begin
            if not modeRechercheEtendu then exit;
            j:=Imin-1;
            while (j>=i1) and (getI(j)<=max) and (max-getI(j)<h) do
              dec(j);
            if (j<i1) or (getI(j)>max)  then exit;
          end;


        min:=32767;
        for j:=i+1 to Imax do
          begin
            if getI(j)>max then exit;
            if getI(j)<min then min:=getI(j);
          end;
        if max-min<h then
          begin
            if not modeRechercheEtendu then exit;
            j:=Imax+1;
            while (j<=i2) and (getI(j)<=max) and (max-getI(j)<h) do
              inc(j);
            if (j>i2) or (getI(j)>max)  then exit;
          end;
      end;

      trouver:=true;
    end;

  begin

    source.data.open;

    if Tout then
      begin
        Ideb:=i1+1;
        Ifin:=i2-1;
      end
    else
      begin
        Ideb:=i1+l;
        Ifin:=i2-l;
      end;

    ok:=false;

    if versPlus then
      begin
        i:=Ideb;
        while (i<=Ifin) and not OK do
          begin
            ok:=trouver;
            inc(i);
          end;
        if ok then p:=i-1 else p:=i2;
      end
    else
      begin
        i:=Ifin;
        while (i>=Ideb) and not OK do
          begin
            ok:=trouver;
            dec(i);
          end;
        if ok then p:=i+1 else p:=i1;
      end;

    source.data.close;
  end;

procedure premierMaxEx(var source:Tvector;i1,i2:integer;l:integer;h:float;
                     var p:integer;tout,versplus:boolean);
  var
    i,Ideb,Ifin:integer;
    ok:boolean;

  function trouver:boolean;
    var
      min,max:float;
      j,Imin,Imax:integer;
    begin
      trouver:=false;

      if i-l<i1 then Imin:=i1
                else Imin:=i-l;
      if i+l>i2 then Imax:=i2
                else Imax:=i+l;

      with source.data do
      begin
        max:=getE(i);
        min:=1E100;
        if (i<Imax) and (getE(i+1)>max) then exit;
        for j:=Imin to i-1 do
          begin
            if getE(j)>max then exit;
            if getE(j)<min then min:=getE(j);
          end;
        if max-min<h then
          begin
            if not modeRechercheEtendu then exit;
            j:=Imin-1;
            while (j>=i1) and (getE(j)<=max) and (max-getE(j)<h) do
              dec(j);
            if (j<i1) or (getE(j)>max)  then exit;
          end;


        min:=1E100;
        for j:=i+1 to Imax do
          begin
            if getE(j)>max then exit;
            if getE(j)<min then min:=getE(j);
          end;
        if max-min<h then
          begin
            if not modeRechercheEtendu then exit;
            j:=Imax+1;
            while (j<=i2) and (getE(j)<=max) and (max-getE(j)<h) do
              inc(j);
            if (j>i2) or (getE(j)>max)  then exit;
          end;
      end;

      trouver:=true;
    end;

  begin

    source.data.open;

    if Tout then
      begin
        Ideb:=i1+1;
        Ifin:=i2-1;
      end
    else
      begin
        Ideb:=i1+l;
        Ifin:=i2-l;
      end;

    ok:=false;

    if versPlus then
      begin
        i:=Ideb;
        while (i<=Ifin) and not OK do
          begin
            ok:=trouver;
            inc(i);
          end;
        if ok then p:=i-1 else p:=i2;
      end
    else
      begin
        i:=Ifin;
        while (i>=Ideb) and not OK do
          begin
            ok:=trouver;
            dec(i);
          end;
        if ok then p:=i+1 else p:=i1;
      end;

    source.data.close;
  end;


function PremierMax0(var source:Tvector;x1,x2,ll,hh:float;
                                tout,versplus:boolean):float;
  var
    i1,i2,p:integer;
    l,h:integer;
  begin
    verifierVecteur(source);
    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);
    source.cadrageX(i1,i2);
    l:=roundI(ll/source.Dxu);
    h:=roundI(hh/source.Dyu);

    if (source.inf.tpNum=G_smallint)
      then premierMax(source,i1,i2,l,h,p,tout,versplus)
      else premierMaxEx(source,i1,i2,l,hh,p,tout,versplus);

    PremierMax0:=source.convX(p);
  end;

function FonctionPremierMaximum(var source:Tvector;x1,x2,ll,hh:float;
                                tout:boolean):float;
  begin
     FonctionPremierMaximum:=premierMax0(source,x1,x2,ll,hh,tout,true);
  end;

function FonctionDernierMaximum(var source:Tvector;x1,x2,ll,hh:float;
                                  tout:boolean):float;
  begin
     FonctionDernierMaximum:=premierMax0(source,x1,x2,ll,hh,tout,false);
  end;

procedure premierMin(var source:Tvector;i1,i2:integer;l,h:integer;
                     var p:integer;tout,versPlus:boolean);
  var
    i,Ideb,Ifin:integer;
    ok:boolean;

  function trouver:boolean;
    var
      min,max,u:integer;
      j,Imin,Imax:integer;
    begin
      trouver:=false;
      if i-l<i1 then Imin:=i1
                else Imin:=i-l;
      if i+l>i2 then Imax:=i2
                else Imax:=i+l;

      with source.data do
      begin
        min:=getI(i);
        max:=-32767;
        if (i<Imax) and (getI(i+1)<min) then exit;
        for j:=Imin to i-1 do
          begin
            u:=getI(j);
            if u<min then exit;
            if u>max then max:=u;
          end;
        if max-min<h then
          begin
            if not modeRechercheEtendu then exit;
            j:=Imin-1;
            while (j>=i1) and (getI(j)>=min) and (getI(j)-min<h) do
              dec(j);
            if (j<i1) or (getI(j)<min)  then exit;
          end;

        max:=-32767;
        for j:=i+1 to Imax do
          begin
            u:=getI(j);
            if u<min then exit;
            if u>max then max:=u;
          end;
        if max-min<h then
          begin
            if not modeRechercheEtendu then exit;
            j:=Imax+1;
            while (j<=i2) and (getI(j)>=min) and (getI(j)-min<h) do
              inc(j);
            if (j>i2) or (getI(j)<min) then exit;
          end;
      end;

      trouver:=true;
    end;

  begin
    source.data.open;
    if Tout then
      begin
        Ideb:=i1+1;
        Ifin:=i2-1;
      end
    else
      begin
        Ideb:=i1+l;
        Ifin:=i2-l;
      end;


    ok:=false;

    if versPlus then
      begin
        i:=Ideb;
        while (i<=Ifin) and not OK do
          begin
            ok:=trouver;
            inc(i);
          end;
        if ok then p:=i-1 else p:=i2;
      end
    else
      begin
        i:=Ifin;
        while (i>=Ideb) and not OK do
          begin
            ok:=trouver;
            dec(i);
          end;
        if ok then p:=i+1 else p:=i1;
      end;
    source.data.close;
  end;

procedure premierMinEx(var source:Tvector;i1,i2:integer;l:integer;h:float;
                     var p:integer;tout,versPlus:boolean);
  var
    i,Ideb,Ifin:integer;
    ok:boolean;

  function trouver:boolean;
    var
      min,max,u:float;
      j,Imin,Imax:integer;
    begin
      trouver:=false;
      if i-l<i1 then Imin:=i1
                else Imin:=i-l;
      if i+l>i2 then Imax:=i2
                else Imax:=i+l;

      with source.data do
      begin
        min:=getE(i);
        max:=-1E100;
        if (i<Imax) and (getE(i+1)<min) then exit;
        for j:=Imin to i-1 do
          begin
            u:=getE(j);
            if u<min then exit;
            if u>max then max:=u;
          end;
        if max-min<h then
          begin
            if not modeRechercheEtendu then exit;
            j:=Imin-1;
            while (j>=i1) and (getE(j)>=min) and (getE(j)-min<h) do
              dec(j);
            if (j<i1) or (getE(j)<min)  then exit;
          end;

        max:=-1E100;
        for j:=i+1 to Imax do
          begin
            u:=getE(j);
            if u<min then exit;
            if u>max then max:=u;
          end;
        if max-min<h then
          begin
            if not modeRechercheEtendu then exit;
            j:=Imax+1;
            while (j<=i2) and (getE(j)>=min) and (getE(j)-min<h) do
              inc(j);
            if (j>i2) or (getE(j)<min) then exit;
          end;
      end;

      trouver:=true;
    end;

  begin
    source.data.open;
    if Tout then
      begin
        Ideb:=i1+1;
        Ifin:=i2-1;
      end
    else
      begin
        Ideb:=i1+l;
        Ifin:=i2-l;
      end;


    ok:=false;

    if versPlus then
      begin
        i:=Ideb;
        while (i<=Ifin) and not OK do
          begin
            ok:=trouver;
            inc(i);
          end;
        if ok then p:=i-1 else p:=i2;
      end
    else
      begin
        i:=Ifin;
        while (i>=Ideb) and not OK do
          begin
            ok:=trouver;
            dec(i);
          end;
        if ok then p:=i+1 else p:=i1;
      end;
    source.data.close;
  end;


function PremierMin0(var source:Tvector;x1,x2,ll,hh:float;
                                tout,versplus:boolean):float;
  var
    i1,i2,p:integer;
    l,h:integer;
  begin
    verifierVecteur(source);

    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);
    source.cadrageX(i1,i2);
    l:=roundI(ll/source.Dxu);
    h:=roundI(hh/source.Dyu);

    if source.inf.tpNum=G_smallint
      then premierMin(source,i1,i2,l,h,p,tout,versplus)
      else premierMinEx(source,i1,i2,l,hh,p,tout,versplus);
    PremierMin0:=source.convX(p);
  end;

function FonctionPremierMinimum(var source:Tvector;x1,x2,ll,hh:float;
                                tout:boolean):float;
  begin
     FonctionPremierMinimum:=premierMin0(source,x1,x2,ll,hh,tout,true);
  end;

function FonctionDernierMinimum(var source:Tvector;x1,x2,ll,hh:float;
                                  tout:boolean):float;
  begin
     FonctionDernierMinimum:=premierMin0(source,x1,x2,ll,hh,tout,false);
  end;

procedure premiereM(var t:Tvector;i1,i2,l,h:integer;var p:integer;
                        Positive,versPlus:boolean);
  var
    i,Ideb,Ifin:integer;
    ok:boolean;
    buf:PtabEntier;
    d,j:integer;

  begin
    if maxAvail<l*2 then sortieErreur(E_mem);

    getmem(buf,l*sizeof(smallint));
    t.data.open;

    ok:=false;
    if versplus then
      begin
        for i:=0 to l-1 do buf^[i]:=t.data.getI(i1+i);
        j:=0;
        i:=i1+l;
        while (i<i2) and not OK do
          begin
            d:=-buf^[j];
            buf^[j]:=t.data.getI(i);
            inc(d,buf^[j]);
            if positive then ok:=(d>=h) else ok:=(-d>=h);

            inc(i);
            inc(j);
            if j=l then j:=0;
            if testerFinPg then
              begin
                freemem(buf,l*2);
                t.data.close;
                exit;
              end;
          end;
        if ok then p:=i-1-l else p:=i2;
      end
    else
      begin
        for i:=0 to l-1 do buf^[i]:=t.data.getI(i2-i);
        j:=0;
        i:=i2-l;
        while (i>i1) and not OK do
          begin
            d:=-buf^[j];
            buf^[j]:=t.data.getI(i);
            inc(d,buf^[j]);
            if positive then ok:=(d>=h) else ok:=(-d>=h);

            dec(i);
            inc(j);
            if j=l then j:=0;
            if testerFinPg then
              begin
                freemem(buf,l*2);
                t.data.close;
                exit;
              end;
          end;
        if ok then p:=i+1 else p:=i1;
      end;

    freemem(buf,l*2);
    t.data.close;
  end;

procedure premiereMex(var t:Tvector;i1,i2,l:integer;h:float;var p:integer;
                        Positive,versPlus:boolean);
  var
    i,Ideb,Ifin:integer;
    ok:boolean;
    buf:PtabSingle;
    j:integer;
    d:float;
  begin
    if maxAvail<l*4 then sortieErreur(E_mem);

    getmem(buf,l*sizeof(single));
    t.data.open;

    ok:=false;
    if versplus then
      begin
        for i:=0 to l-1 do buf^[i]:=t.data.getE(i1+i);
        j:=0;
        i:=i1+l;
        while (i<i2) and not OK do
          begin
            d:=-buf^[j];
            buf^[j]:=t.data.getE(i);
            d:=d+buf^[j];
            if positive then ok:=(d>=h) else ok:=(-d>=h);

            inc(i);
            inc(j);
            if j=l then j:=0;
            if testerFinPg then
              begin
                freemem(buf,l*4);
                t.data.close;
                exit;
              end;
          end;
        if ok then p:=i-1-l else p:=i2;
      end
    else
      begin
        for i:=0 to l-1 do buf^[i]:=t.data.getE(i2-i);
        j:=0;
        i:=i2-l;
        while (i>i1) and not OK do
          begin
            d:=-buf^[j];
            buf^[j]:=t.data.getE(i);
            d:=d+buf^[j];
            if positive then ok:=(d>=h) else ok:=(-d>=h);

            dec(i);
            inc(j);
            if j=l then j:=0;
            if testerFinPg then
              begin
                freemem(buf,l*4);
                t.data.close;
                exit;
              end;
          end;
        if ok then p:=i+1 else p:=i1;
      end;

    freemem(buf,l*4);
    t.data.close;
  end;

function PremiereM0(var source:Tvector;x1,x2,ll,hh:float;
                                positive,versPlus:boolean):float;
  var
    i1,i2:integer;
    l,h,p:integer;
  begin
    verifierVecteur(source);
    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);
    source.cadrageX(i1,i2);
    l:=roundL(ll/source.Dxu);
    h:=roundL(hh/source.Dyu);

    if (l<1) or (l>30000) or (h<1)  then
        sortieErreur(E_parametre);

    if (i1+l>i2) then
     begin
       if positive
         then PremiereM0:=source.convx(i2)
         else PremiereM0:=source.convx(i1);
       exit;
     end;

    if source.inf.tpNum=G_smallint
      then premiereM(source,i1,i2,l,h,p,positive,versPlus)
      else premiereMex(source,i1,i2,l,hh,p,positive,versPlus);

    PremiereM0:=source.convX(p);
  end;

function FonctionPremiereMarche(var source:Tvector;x1,x2,ll,hh:float;
                                positive:boolean):float;
  begin
    FonctionPremiereMarche:=PremiereM0(source,x1,x2,ll,hh,positive,true);
  end;

function FonctionDerniereMarche(var source:Tvector;x1,x2,ll,hh:float;
                                  positive:boolean):float;
  begin
    FonctionDerniereMarche:=PremiereM0(source,x1,x2,ll,hh,positive,false);
  end;

function FonctionPremierDepassement(var source:Tvector;x1,x2,y0:float;
                                    positif:boolean):float;
  var
    i,i1,i2:integer;
    j0:integer;
  begin
    verifierVecteur(source);
    i1:=source.invConvX(x1);
    i2:=source.invConvX(x2);

    source.cadrageX(i1,i2);
    j0:=source.invConvY(y0);

    i:=i1;
    source.data.open;

    (*
    if source.inf.tpNum=G_smallint then
      begin
        if positif then
          begin
            while (i<i2) and (source.data.getI(i)>=j0) do inc(i);
            while (i<i2) and (source.data.getI(i)<j0) do inc(i);
          end
        else
          begin
            while (i<i2) and (source.data.getI(i)<j0) do inc(i);
            while (i<i2) and (source.data.getI(i)>=j0) do inc(i);
          end;
      end
    else
    *)
      begin
        if positif then
          begin
            while (i<i2) and (source.data.getE(i)>=y0) do inc(i);
            while (i<i2) and (source.data.getE(i)<y0) do inc(i);
          end
        else
          begin
            while (i<i2) and (source.data.getE(i)<y0) do inc(i);
            while (i<i2) and (source.data.getE(i)>=y0) do inc(i);
          end;
      end;

    FonctionPremierDepassement:=source.convX(i);
    source.data.close;
  end;



function FonctionDernierDepassement(var source:Tvector;x1,x2,y0:float;
                                positif:boolean):float;
  var
    i,i1,i2:integer;
    j0:integer;
  begin
    verifierVecteur(source);

    i1:=source.invconvX(x1);
    i2:=source.invconvX(x2);
    source.cadrageX(i1,i2);
    j0:=source.invconvY(y0);

    i:=i2;
    source.data.open;
    (*
    if source.inf.tpNum=G_smallint then
      begin
        if positif then
          begin
            while (i>i1) and (source.data.getI(i)<j0) do dec(i);
            while (i>i1) and (source.data.getI(i)>=j0) do dec(i);
          end
        else
          begin
            while (i>i1) and (source.data.getI(i)>j0) do dec(i);
            while (i>i1) and (source.data.getI(i)<=j0) do dec(i);
          end;
      end
    else
    *)
      begin
        if positif then
          begin
            while (i>i1) and (source.data.getE(i)<y0) do dec(i);
            while (i>i1) and (source.data.getE(i)>=y0) do dec(i);
          end
        else
          begin
            while (i>i1) and (source.data.getE(i)>y0) do dec(i);
            while (i>i1) and (source.data.getE(i)<=y0) do dec(i);
          end;
      end;

    FonctionDernierDepassement:=source.convX(i);
    source.data.close;
  end;


procedure proSetModeRecherche(etendu:boolean);
  begin
    ModeRechercheEtendu:=etendu;
  end;


function FonctionMAXI(var source:Tvector;x1,x2:float):float;
  var
    i1,i2,i:integer;
    max,j:integer;
  begin
    verifierVecteur(source);
    i1:=source.invconvX(x1);
    i2:=source.invconvX(x2);
    source.cadrageX(i1,i2);
    FonctionMaxi:=source.data.maxi(i1,i2);
  end;

function FonctionMINI(var source:Tvector;x1,x2:float):float;
  var
    i1,i2,i:integer;
    max,j:integer;
  begin
    verifierVecteur(source);
    i1:=source.invconvX(x1);
    i2:=source.invconvX(x2);
    source.cadrageX(i1,i2);
    FonctionMini:=source.data.mini(i1,i2);
  end;

function FonctionMAXIX(var source:Tvector;x1,x2:float):float;
  var
    i1,i2,i:integer;
  begin
    verifierVecteur(source);
    i1:=source.invconvX(x1);
    i2:=source.invconvX(x2);
    source.cadrageX(i1,i2);
    with source.data do FonctionMaxiX:=convx(maxiX(i1,i2));
  end;


function FonctionMINIX(var source:Tvector;x1,x2:float):float;
  var
    i1,i2:integer;
  begin
    verifierVecteur(source);
    i1:=source.invconvX(x1);
    i2:=source.invconvX(x2);
    source.cadrageX(i1,i2);
    with source.data do FonctionMiniX:=convx(miniX(i1,i2));
  end;

function FonctionMAXIR(var source:Tvector;x1,x2,x1r,x2r:float):float;
  begin
    FonctionMAXIR:=FonctionMaxi(source,x1,x2)
                   -FonctionMoyenne(source,x1r,x2r);
  end;

function FonctionMINIR(var source:Tvector;x1,x2,x1r,x2r:float):float;
  begin
    FonctionMINIR:=FonctionMini(source,x1,x2)
                   -FonctionMoyenne(source,x1r,x2r);
  end;


function FonctionMOYENNE(var source:Tvector;x1,x2:float):float;
  var
    i1,i2:integer;
  begin
    verifierVecteur(source);
    i1:=source.invconvX(x1);
    i2:=source.invconvX(x2);
    source.cadrageX(i1,i2);
    FonctionMoyenne:= source.data.moyenne(i1,i2);
  end;


function FonctionECARTTYPE(var source:Tvector;x1,x2:float):float;
  var
    i1,i2:integer;
  begin
    verifierVecteur(source);
    i1:=source.invconvX(x1);
    i2:=source.invconvX(x2);
    source.cadrageX(i1,i2);
    FonctionEcartType:=source.data.StdDev(i1,i2);
  end;

function PA1ex(var source:Tvector;
                    x1c,x2c,x1r,x2r,N1:float):float;
  const
    epsilon=0.001;
  var
    i:integer;
    i1c,i2c,i1r,i2r:integer;
    Y0,Ymax,Y1:float;
    Imax,i1,i2:integer;
  begin
    PA1ex:=0;
    i1c:=source.invconvX(x1c);
    i2c:=source.invconvX(x2c);
    i1r:=source.invconvX(x1r);
    i2r:=source.invconvX(x2r);
    source.cadrageX(i1c,i2c);
    source.cadrageX(i1r,i2r);
    if (N1<=0) or (N1>=100) then sortieErreur(E_parametre);


    with source.data do
    begin
      Imax:=maxiX(i1c,i2c);
      Y0:=  moyenne(i1r,i2r);
      Ymax:=getE(Imax);
    end;

    Y1:=Y0+ (Ymax-Y0)*N1/100 ;
    if (Y1<=Y0) or (Y1>=Ymax) then exit;

    i1:=Imax;
    while ( source.data.getE(i1)>Y1 ) and (i1>=I1c) do dec(i1);
    if i1<I1c then exit;

    i2:=Imax;
    while ( source.data.getE(i2)>Y1 ) and (i2<=I2c) do inc(i2);
    if i2>I2c then exit;

    PA1ex:=source.Dxu*(i2-i1);
  end;


function FonctionPA1(var source:Tvector;
                    x1c,x2c,x1r,x2r,N1:float):float;
  const
    epsilon=0.001;
  var
    i:integer;
    i1c,i2c,i1r,i2r:integer;
    J0,Jmax,J1,Imax,i1,i2:integer;
  begin
    verifierVecteur(source);
    if source.inf.tpNum<>G_smallint then
      begin
        FonctionPA1:=PA1ex(source,x1c,x2c,x1r,x2r,N1);
        exit;
      end;

    FonctionPA1:=0;
    i1c:=source.invconvX(x1c);
    i2c:=source.invconvX(x2c);
    i1r:=source.invconvX(x1r);
    i2r:=source.invconvX(x2r);
    source.cadrageX(i1c,i2c);
    source.cadrageX(i1r,i2r);
    if (N1<=0) or (N1>=100) then sortieErreur(E_parametre);


    with source.data do
    begin
      Imax:=maxiX(i1c,i2c);
      J0:=  roundI(invConvY(moyenne(i1r,i2r)));
      Jmax:=getI(Imax);
    end;

    J1:=J0+roundI( 1.0*(Jmax-J0)*N1/100 );
    if (J1<=J0) or (J1>=Jmax) then exit;

    i1:=Imax;
    while ( source.data.getI(i1)>J1 ) and (i1>=I1c) do dec(i1);
    if i1<I1c then exit;

    i2:=Imax;
    while ( source.data.getI(i2)>J1 ) and (i2<=I2c) do inc(i2);
    if i2>I2c then exit;

    FonctionPA1:=source.Dxu*(i2-i1);
  end;

function PA2ex(var source:Tvector;
                    y1,x1c,x2c:float):float;
  const
    epsilon=0.001;
  var
    i:integer;
    Ymax:float;
    Imax,i1,i2:integer;
    I1c,I2c:integer;
    Ya1,Ya2:float;
    x1,x2:float;
  begin
    PA2ex:=0;

    i1c:=source.invconvX(x1c);
    i2c:=source.invconvX(x2c);
    source.cadrageX(i1c,i2c);

    with source.data do
    begin
      Imax:=maxiX(i1c,i2c);
      Ymax:=getE(Imax);
    end;
    if (Y1>=Ymax) then exit;

    i1:=Imax;
    while ( source.data.getE(i1)>Y1 ) and (i1>=I1c) do dec(i1);
    if i1<I1c then exit;

    i2:=Imax;
    while (source.data.getE(i2)>Y1 ) and (i2<=I2c) do inc(i2);
    if i2>I2c then exit;

    Ya1:=source.data.getE(i1);
    Ya2:=source.data.getE(i1+1);
    if ya1<>ya2 then x1:=(y1-ya1)/(ya2-ya1)+i1
                else x1:=i1;

    Ya1:=source.data.getE(i2-1);
    Ya2:=source.data.getE(i2);
    if Ya1<>Ya2 then x2:=(Y1-Ya1)/(Ya2-Ya1)+i2
                else x2:=i2;


    PA2ex:=source.Dxu*(x2-x1);
  end;


function FonctionPA2(var source:Tvector;
                    y1,x1c,x2c:float):float;
  const
    epsilon=0.001;
  var
    i:integer;
    Jmax,Imax,i1,i2:integer;
    J1,I1c,I2c:integer;
    ja1,ja2:integer;
    x1,x2:float;
  begin
    verifierVecteur(source);
    if source.inf.tpNum=G_smallint then
      begin
        FonctionPA2:=PA2ex(source,y1,x1c,x2c);
        exit;
      end;

    FonctionPA2:=0;

    i1c:=source.invconvX(x1c);
    i2c:=source.invconvX(x2c);
    J1 :=source.invconvY(y1);
    source.cadrageX(i1c,i2c);

    with source.data do
    begin
      Imax:=maxiX(i1c,i2c);
      Jmax:=getI(Imax);
    end;
    if (J1>=Jmax) then exit;

    i1:=Imax;
    while ( source.data.getI(i1)>J1 ) and (i1>=I1c) do dec(i1);
    if i1<I1c then exit;

    i2:=Imax;
    while (source.data.getI(i2)>J1 ) and (i2<=I2c) do inc(i2);
    if i2>I2c then exit;

    ja1:=source.data.getI(i1);
    ja2:=source.data.getI(i1+1);
    if ja1<>ja2 then x1:=(j1-ja1)/(ja2-ja1)+i1
                else x1:=i1;

    ja1:=source.data.getI(i2-1);
    ja2:=source.data.getI(i2);
    if ja1<>ja2 then x2:=(j1-ja1)/(ja2-ja1)+i2
                else x2:=i2;


    FonctionPA2:=source.Dxu*(x2-x1);
  end;

function TM1ex(var source:Tvector;x1,x2:float;montee:boolean;
                     var x1r,x2r:float):float;
  const
    epsilon=0.001;
  var
    i:integer;
    i1,i2:integer;
    i1m,i2m:integer;
    Imin,Imax:integer;
    Ymin,Ymax,Ymax1,Ymin1:float;
  begin
    TM1ex:=0;
    i1:=source.invconvX(x1);
    i2:=source.invconvX(x2);
    source.cadrageX(i1,i2);

    with source.data do
    begin
      Imax:=maxiX(i1,i2);
      Imin:=miniX(i1,i2);
      if montee and (Imin>=Imax) or not montee and (Imax>=Imin) then
        begin
          TM1ex:=0;
          exit;
        end;
      Ymax:=getE(Imax);
      Ymin:=getE(Imin);

      Ymax1:=Ymax-(Ymax-Ymin)*0.1;
      Ymin1:=Ymin+(Ymax-Ymin)*0.1;

      if montee then
        begin
          i2m:=Imax;
          while ( getE(i2m)>Ymax1 ) and (i2m>i1) do dec(i2m);
          i1m:=Imin;
          while ( getE(i1m)<Ymin1 ) and (i1m<i2) do inc(i1m);
        end
      else
        begin
          i1m:=Imax;
          while ( getE(i1m)>Ymax1 ) and (i1m<i2) do inc(i1m);
          i2m:=Imin;
          while ( getE(i2m)<Ymin1 ) and (i2m>i1) do dec(i2m);
        end;

      x1r:=convX(i1m);
      x2r:=convX(i2m);
    end;

    TM1ex:=x2r-x1r;
  end;


function FonctionTM1(var source:Tvector;x1,x2:float;montee:boolean;
                     var x1r,x2r:float):float;
  const
    epsilon=0.001;
  var
    i:integer;
    i1,i2:integer;
    i1m,i2m:integer;
    Imin,Imax:integer;
    Jmin,Jmax,Jmax1,Jmin1:integer;
  begin
    verifierVecteur(source);
    if source.inf.tpNum=G_smallint then
      begin
        FonctionTM1:=TM1ex(source,x1,x2,montee,x1r,x2r);
        exit;
      end;

    FonctionTM1:=0;
    i1:=source.invconvX(x1);
    i2:=source.invconvX(x2);
    source.cadrageX(i1,i2);

    with source.data do
    begin
      Imax:=maxiX(i1,i2);
      Imin:=miniX(i1,i2);
      if montee and (Imin>=Imax) or not montee and (Imax>=Imin) then
        begin
          fonctionTM1:=0;
          exit;
        end;
      Jmax:=getI(Imax);
      Jmin:=getI(Imin);

      Jmax1:=Jmax-roundI((Jmax-Jmin)*0.1);
      Jmin1:=Jmin+roundI((Jmax-Jmin)*0.1);

      if montee then
        begin
          i2m:=Imax;
          while ( getI(i2m)>Jmax1 ) and (i2m>i1) do dec(i2m);
          i1m:=Imin;
          while ( getI(i1m)<Jmin1 ) and (i1m<i2) do inc(i1m);
        end
      else
        begin
          i1m:=Imax;
          while ( getI(i1m)>Jmax1 ) and (i1m<i2) do inc(i1m);
          i2m:=Imin;
          while ( getI(i2m)<Jmin1 ) and (i2m>i1) do dec(i2m);
        end;

      x1r:=convX(i1m);
      x2r:=convX(i2m);
    end;

    FonctionTM1:=x2r-x1r;
  end;

function TM2ex(var source:Tvector;x10,x20,x1,x2,Np:float;montee:boolean;
                     var x1r,x2r:float):float;
  const
    epsilon=0.001;
  var
    i:integer;
    i10,i20:integer;
    i1,i2:integer;
    i1m,i2m:integer;
    Imin,Imax:integer;
    Y0,Ymin,Ymax,Ymax1,Ymin1:float;
  begin
    TM2ex:=0;
    i10:=source.invconvX(x10);
    i20:=source.invconvX(x20);
    i1:=source.invconvX(x1);
    i2:=source.invconvX(x2);
    source.cadrageX(i10,i20);
    source.cadrageX(i1,i2);
    if (Np<0) or (Np>=1) then sortieErreur(E_parametre);

    with source.data do
    begin
      y0:=moyenne(i10,i20);
      Imax:=maxiX(i1,i2);
      Imin:=MiniX(i1,i2);

      Ymax:=getE(Imax);
      Ymin:=getE(Imin);

      if montee and (Ymax<=Y0) or not montee and (Ymin>=Y0) then
          begin
            TM2ex:=0;
            exit;
          end;

      if montee then
        begin
          Ymax1:=Ymax-(Ymax-Y0)*Np;
          Ymin1:=Y0+(Ymax-Y0)*Np;
          i2m:=Imax;
          while ( getE(i2m)>Ymax1 ) and (i2m>i1) do dec(i2m);
          i1m:=I1;
          while ( getE(i1m)<Ymin1 ) and (i1m<i2) do inc(i1m);
        end
      else
        begin
          Ymax1:=Y0-(Y0-Ymin)*Np;
          Ymin1:=Ymin+(Y0-Ymin)*Np;
          i2m:=Imin;
          while ( getE(i2m)<Ymin1 ) and (i2m>i1) do dec(i2m);
          i1m:=I1;
          while ( getE(i1m)>Ymax1 ) and (i1m<i2) do inc(i1m);
        end;

      x1r:=convX(i1m);
      x2r:=convX(i2m);
    end;
    TM2ex:=x2r-x1r;
  end;


function FonctionTM2(var source:Tvector;x10,x20,x1,x2,Np:float;montee:boolean;
                     var x1r,x2r:float):float;
  const
    epsilon=0.001;
  var
    i:integer;
    i10,i20,j0:integer;
    i1,i2:integer;
    i1m,i2m:integer;
    Imin,Imax:integer;
    Jmin,Jmax,Jmax1,Jmin1:integer;
  begin
    verifierVecteur(source);
    if source.inf.tpNum=G_smallint then
      begin
        FonctionTM2:=TM2ex(source,x10,x20,x1,x2,Np,montee,x1r,x2r);
        exit;
      end;


    FonctionTM2:=0;
    i10:=source.invconvX(x10);
    i20:=source.invconvX(x20);
    i1:=source.invconvX(x1);
    i2:=source.invconvX(x2);
    source.cadrageX(i10,i20);
    source.cadrageX(i1,i2);
    if (Np<0) or (Np>=1) then sortieErreur(E_parametre);

    with source.data do
    begin
      j0:=roundI(invConvY(moyenne(i10,i20)));
      Imax:=maxiX(i1,i2);
      Imin:=MiniX(i1,i2);

      Jmax:=getI(Imax);
      Jmin:=getI(Imin);

      if montee and (Jmax<=J0) or not montee and (Jmin>=J0) then
          begin
            fonctionTM2:=0;
            exit;
          end;

      if montee then
        begin
          Jmax1:=Jmax-roundI((Jmax-J0)*Np);
          Jmin1:=J0+roundI((Jmax-J0)*Np);
          i2m:=Imax;
          while ( getI(i2m)>Jmax1 ) and (i2m>i1) do dec(i2m);
          i1m:=I1;
          while ( getI(i1m)<Jmin1 ) and (i1m<i2) do inc(i1m);
        end
      else
        begin
          Jmax1:=J0-roundI((J0-Jmin)*Np);
          Jmin1:=Jmin+roundI((J0-Jmin)*Np);
          i2m:=Imin;
          while ( getI(i2m)<Jmin1 ) and (i2m>i1) do dec(i2m);
          i1m:=I1;
          while ( getI(i1m)>Jmax1 ) and (i1m<i2) do inc(i1m);
        end;

      x1r:=convX(i1m);
      x2r:=convX(i2m);
    end;
    FonctionTM2:=x2r-x1r;
  end;

function fonctionShape1(var s:Tvector;p1:integer;
                        var pu:Tvector;nb:integer):float;
var
  i:integer;
  x0,x,y,ym:float;
begin
  verifierVecteur(s);
  verifierVecteur(pu);

  if (p1<s.data.Indicemin) or (p1+nb-1>s.data.indicemax)
    then sortieErreur(E_parametre);

  if (pu.data.Indicemin>0) or (pu.data.indicemax<nb-1)
    then sortieErreur(E_parametre);

  ym:=s.data.moyenne(p1,p1+nb-1);

  x:=0;
  y:=0;
  for i:=0 to nb-1 do
    begin
      x0:=pu.data.getE(i);
      x:=x+abs(x0-s.data.getE(p1+i)+ym);
      y:=y+abs(x0);
    end;

  if y<>0 then fonctionShape1:=x/y else fonctionShape1:=10;

end;
{
var
  ws:array of TsearchWin;

procedure echangeWS(i,j:integer);
var
  p:TsearchWin;
begin
  p:=ws[i];
  ws[i]:=ws[j];
  ws[j]:=p;
end;

function cleWS(i:integer):float;
begin
  result:=ws[i].x;
end;
}
procedure SearchEvt1(var source,dest:Tvector;x1,x2:float;var winList:array of TsearchWin;
                     Linhib:float);
var
  i,i1,i2,j:integer;

  Iwin:array[0..20] of integer;
  Ywin1,Ywin2:array[0..20] of float;
  nbWin:integer;
  i0,w:integer;
  y:float;
  ok:boolean;
  Iinc:integer;
  dinhib:integer;

  buf:array of single;
  Lbuf:integer;
  Ibuf,Isource:integer;

procedure NextPoint;
begin
  buf[Ibuf]:=source.data.getE(Isource);
  inc(Isource);
  Ibuf:=(Ibuf+1) mod Lbuf;
end;

begin
(*
  verifierVecteur(source);
  verifierVecteur(dest);

  i1:=source.invConvX(x1);
  i2:=source.invConvX(x2);
  source.cadrageX(i1,i2);

  dinhib:=source.invConvX(lInhib)-source.invConvX(0);

  {
  ws:=winList;
  sort(low(ws),high(ws),cleWS,echangeWS);
  }
  nbwin:=0;
  for i:=0 to high(winList) do
  begin
    Iwin[nbWin]:=source.invConvX(winlist[i].x);
    Ywin1[nbWin]:=winlist[i].y;
    Ywin2[nbWin]:=winlist[i].y+winlist[i].h;
    inc(nbwin);
  end;

  i0:=Iwin[0];
  Lbuf:=0;
  for i:=0 to nbwin-1 do
    begin
      Iwin[i]:=Iwin[i]-i0;
      if i2+Iwin[i]>source.Iend then i2:=source.Iend-Iwin[i];
      if Iwin[i]>Lbuf then Lbuf:=Iwin[i];
    end;
  Lbuf:=Lbuf+1;

  setLength(buf,Lbuf);

  IInc:=Iwin[nbwin-1];
  if Iinc<=0 then Iinc:=1;
  if Iinc<=dInhib then Iinc:=dInhib;


  Isource:=i1;
  Ibuf:=0;
  for i:=0 to Lbuf-1 do NextPoint;

  i:=i1;
  repeat
     ok:=true;
     for w:=0 to nbwin-1 do
       begin
         y:=buf[(i+Iwin[w]-i1) mod Lbuf];
         ok:=ok and (y>=Ywin1[w]) and (y<Ywin2[w]);
       end;
     if ok then
       begin
         dest.addToList(source.convx(i));
         for j:=1 to Iinc do NextPoint;
         i:=i+Iinc;
       end
     else
       begin
         inc(i);
         nextPoint;
       end;

     if getFlagClock(2) then
       begin
         if TestEscape then exit;
         if assigned(every10000) then every10000;
       end;

  until i>=i2;
*)
end;


Initialization
AffDebug('Initialization stmExe10',0);

installError(E_transferer1,'TransferTrace1: source index out of range');
installError(E_rotation,'RotateVector: bad origin');


end.
