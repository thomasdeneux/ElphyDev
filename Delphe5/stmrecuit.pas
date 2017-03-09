unit stmrecuit;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,dgraphic,math,
     stmObj,stmdef,stmmat1,stmvec1,stmgraph2,debug0;

{$R+}    {range checking}
{version AVEC  PINWHEELS }

procedure prorecuit(var extpots:Tmatrix ; var extcentres : TxyPlot ; var extevolution,extxp,extyp : Tvector);pascal;

implementation



function Norm(x,y:double):double;
begin
  result:=sqrt( sqr(x)+sqr(y) );
end;

const
  taille = 200;            {environnement : grille taille*taille}
  nbpin = 0;
  nbpoles=6+30;
  nb_essais_max = 40 ;            {type 1 = 40}     {type 2 = 40}
  nb_succes_max = 10 ;            {type 1 = 10}     {type 2 = 10}
  Tinit=200;                      {type 1 = 150}    {type 2 = 150}
  Tmin=20;                      {type 1 = 30}     {type 2 = 20}
  dT=2;                           {type 1 = 3}      {type 2 = 2}
  kdemarre=0.01;                  {type 1 = 0.01}   {type 2 = 0.01}
  k=0.0025; {constante de boltzman}{type 1 = 0.003}  {type 2 = 0.003}
  dxmax=10;
  dymax=10;
  dphimax=3;
  R=10;  {rayon d'interdiction}

type matricespotentiels = array[1..taille,1..taille,1..12] of single; {matrice des potentiels en chaque point }


var
  centres : array[1..nbpoles+1,1..3] of integer; { coordonnees des centres des poles, et de l'angle phi}
  newpots,matpots : matricespotentiels;



function Vpot(ro, theta, phi : float):float;    { On va definir une fonction potentiel Vi= f( ro, theta, phi)  }

const
  a=10;    { en fait axe horizontal}
  b=5;  {et vertical }
  b2=b/2;   { ellipse centrale   }
  f=1.5;     { facteur de taille des potentiels sous liminaires}
  cmax = 2; { valeur max champ recepteur central  ==1 ds cas normal }
  smax = 0.5; {valeur max du champ sous liminaire}
  divangle = 2;    {division de l'angle du champ lateral p.r a pi/3 }

var
  xrel,yrel,ropap,thetapap,limro,Vi : float;

begin

  Vi:=0;
  { on reconstruit la position relative en x,y}
  xrel:=ro*cos(theta);
  yrel:=ro*sin(theta);

{ sur le point }
  if ro=0 then Vi:=0;

{ on est dans l'ellipse centrale, facilitatrice //  le 4 vient du b/2*b/2}
  if (xrel*xrel/(a*a)+yrel*yrel/(b2*b2)<=1) and (ro>0) then
        Vi:=cmax*(xrel*xrel/(a*a)+yrel*yrel/(b2*b2))-1*cmax ;       {de -cmax a 0 }

{on est dans l'ellipse exterieure, inhibitrice}
  if (xrel*xrel/(a*a)+yrel*yrel/(b2*b2)>1) and (xrel*xrel/(a*a)+yrel*yrel/(b*b)<=1) then
        Vi:=(xrel*xrel/(a*a)+yrel*yrel/(b*b))*(-0.5*cmax)+0.5*cmax; {de 0.5*cmax a 0, a une legere approximation pres  }


  ropap:=Norm(xrel-11,yrel);
  thetapap:=Angle(xrel-11,yrel);
  limro:=a*f;

  if (ropap<=limro) and (abs(thetapap)<=pi/(3*divangle)) then
  begin
    Vi:=smax/2;
    if (abs(phi-thetapap)<pi/(3*divangle)) then
      Vi:=-smax;                                                                 {type 3}
      {Vi:=-smax*cos(2*(phi-thetapap));}                                                {type 2}
      {Vi:=(smax*ropap/limro-smax)*cos(1.5*divangle*thetapap)*cos(2*phi);}        {type 1}
  end;

  ropap:=Norm(xrel+11,yrel);
  thetapap:=Angle(xrel+11,yrel);

  if (ropap<=limro) and ((abs(thetapap-pi)<=pi/(3*divangle)) or (abs(thetapap+pi)<=pi/(3*divangle))) then
  begin
    Vi:=smax/2;
    if ((abs(phi-thetapap-pi)<pi/(3*divangle)) or (abs(phi-thetapap+pi)<pi/(3*divangle))) then
      Vi:=-smax;                                                                 {type 3}
      {Vi:=-smax*cos(2*(phi-thetapap+pi));}                                              {type 2}
      {Vi:=(smax*ropap/limro-smax)*abs(cos(1.5*divangle*(thetapap-pi)))*cos(2*phi);}  {type 1}
  end;

    result:=Vi;
end;




function Pinpot(ro, theta, phi : float):float; {fonction potentiel des pinwheels}

const
  D = 20;   {distance d'interaction maximales des pinwheels }
  pmax = 0.7;     {valeur max de l'interaction}

var
  Vi : float;

begin

  Vi:=0;

  if (ro<D) and (((theta <-pi-pi/12 ) and (theta >-2*pi+pi/12)) or ((theta <pi-pi/12 ) and (theta >0+pi/12))) then
  begin
    Vi:=pmax/2;
    if not(((theta <-pi-pi/3+pi/12 ) and(theta >-2*pi+pi/3-pi/12)) or ((theta <2*pi/3+pi/12 ) and (theta >pi/3-pi/12)))
    and (abs(cos((phi-theta)))>0.8) then
      {Vi:=-pmax*cos(2*(phi-theta));}
      Vi:=-pmax;
  end;

  result:=Vi;

end;



procedure Vtot(x0,y0,phi0 : integer);      {calcul du potentiel total en un point}

var
  cpt : integer;

begin

  for cpt:=7 to nbpoles do
    matpots[x0,y0,phi0]:=matpots[x0,y0,phi0]+Vpot(norm(x0-centres[cpt,1],y0-centres[cpt,2]),Angle((x0-centres[cpt,1]),(y0-centres[cpt,2]))-pi/12*centres[cpt,3],pi/12*(phi0-centres[cpt,3]));

end;


procedure Pintot(x0,y0,phi0 : integer);      {calcul du potentiel total en un point}

var
  cpt : integer;

begin

  for cpt:=1 to nbpin do
    matpots[x0,y0,phi0]:=matpots[x0,y0,phi0]+Pinpot(norm(x0-centres[cpt,1],y0-centres[cpt,2]),Angle((x0-centres[cpt,1]),(y0-centres[cpt,2]))-pi/6*centres[cpt,3],pi/12*phi0-pi/6*centres[cpt,3]);

end;



procedure Vdepart;

var
  i,j,k : integer;

begin

  statuslinetxt('Vdepart');
  for i:=1 to taille do
    for j:=1 to taille do
     for k:=1 to 12 do
       Vtot(i,j,k);                    { ca ca va etre long...}

end;


procedure Pindepart;

var
  i,j,k : integer;

begin

  statuslinetxt('Pindepart');
  for i:=1 to taille do
    for j:=1 to taille do
     for k:=1 to 12 do
       Pintot(i,j,k);            { on duplique...}

end;



procedure init;

var
  i,j,k : integer;

begin
  randomize;
  {initialiser centres}

  centres[1,1]:=30;
  centres[1,2]:=40;
  centres[1,3]:=10;

  centres[2,1]:=170;
  centres[2,2]:=40;
  centres[2,3]:=2;

  centres[3,1]:=170;
  centres[3,2]:=160;
  centres[3,3]:=4;

  centres[4,1]:=30;
  centres[4,2]:=160;
  centres[4,3]:=8;

  centres[5,1]:=100;
  centres[5,2]:=3;
  centres[5,3]:=12;

  centres[6,1]:=100;
  centres[6,2]:=197;
  centres[6,3]:=6;

  for i:=7 to nbpoles do
  begin
    centres[i,1]:= (((i-7) mod 5))*30+40;
    centres[i,2]:= ((floor(i/5-1) mod 4))*25+62;
    centres[i,3]:=(i mod 12)+1;
    Affdebug(istr(centres[i,1]),17);
    Affdebug(istr(centres[i,2]),17);
    Affdebug(istr(centres[i,3]),17);
  end;



{initialiser matpots}
  for i:=1 to taille do
    for j:=1 to taille do
      for k:=1 to 12 do
        matpots[i,j,k]:=0;

  Pindepart;
  Vdepart;

end;


function testoccup(x0,y0,no:integer):boolean;     { peut on occuper une case ? }

var
  cpt : integer;
  test : boolean;
begin

  test:=False;
  if (x0<=0) or (x0>taille) or (y0<=0) or (y0>taille) then test:=true;

  for cpt:=1 to nbpoles do
  begin
    if (Norm(x0-centres[cpt,1],y0-centres[cpt,2])<R) and (cpt<>no) then test:=True;
  end;

  result:=test;

end;



function energie(no,dx0,dy0,dphi0 : integer ):float;

var
  somme : float;
  i,j,k,cpt : integer;

begin
  for i:=1 to taille do
    for j:=1 to taille do
      for k:=1 to 12 do
        newpots[i,j,k]:= matpots[i,j,k]-Vpot(norm(i-centres[no,1],j-centres[no,2]),Angle((i-centres[no,1]),(j-centres[no,2]))-pi/12*centres[no,3],pi/12*(k-centres[no,3]))
                      + Vpot(norm(i-centres[no,1]-dx0,j-centres[no,2]-dy0),Angle((i-centres[no,1]-dx0),(j-centres[no,2]-dy0))-pi/12*(((centres[no,3]+dphi0) mod 12)+1),pi/12*(k-(((centres[no,3]+dphi0) mod 12)+1)));
  somme:=0;

  for cpt:=1 to nbpoles do
  begin
    somme:=somme+newpots[centres[cpt,1],centres[cpt,2],centres[cpt,3]];
  end;
                         
  somme:=somme-newpots[centres[no,1],centres[no,2],centres[no,3]] + newpots[centres[no,1]+dx0,centres[no,2]+dy0,((centres[no,3]+dphi0) mod 12)+1];
  result:=somme;

end;

procedure prorecuit(var extpots:Tmatrix ; var extcentres : TxyPlot ; var extevolution,extxp,extyp : Tvector);

var

  nrj_nouvelle,nrj_courante,T,deltaE,r,kutil : real;
  dx0,dy0,dphi0,no,nb_essais_T,nb_succes_T,i,j,cpt,aie : integer;

begin
  Affdebug('nouveau lancement',17);

  verifierObjet(typeUO(extpots));
  extpots.initTemp(1,taille,1,taille,g_single);

  verifierVecteurTemp(extevolution);
  extevolution.initTemp1(1,30000,g_single);
  verifierVecteurTemp(extxp);
  extxp.initTemp1(1,nbpoles+1,g_single);
  verifierVecteurTemp(extyp);
  extyp.initTemp1(1,nbpoles+1,g_single);

  verifierObjet(typeUO(extCentres));

  with extCentres do
  begin
    clear;
    addPolyLIne;
  end;

  T:=Tinit;
  kutil:=kdemarre;
  init;
  cpt:=0;   {compteur de l'evolution}


  while (T >= Tmin) do
  begin
    Affdebug(' ',17);
    Affdebug('T = ' + estr(T,1),17);
    nb_essais_T:=0;
    nb_succes_T:=0;
    if(Tinit-T)>3*dT then kutil:=k;

    while (nb_essais_T < nb_essais_max) or (nb_succes_T < nb_succes_max) do
    begin
        aie:=0;
        statuslinetxt('T = ' + estr(T,1) + '   nb_essais_T = ' + istr(nb_essais_T) + '   nb_succes_T = ' + istr(nb_succes_T) + '   testoccup pas content : ' + istr(aie));
        Affdebug(' ',17);
        Affdebug('nb_essais_T = ' + istr(nb_essais_T),17);
        Affdebug('nb_succes_T = ' + istr(nb_succes_T),17);
        dx0:=random(2*dxmax)-dxmax+1;
        dy0:=random(2*dymax)-dymax+1;
        dphi0:=random(2*dphimax)-dphimax+1;
        no:=random(nbpoles-6)+7;
        if (centres[no,3]+dphi0)<0 then dphi0:=12+centres[no,3]+dphi0;


        while (testoccup(centres[no,1]+dx0,centres[no,2]+dy0,no)) and (aie<100) do  { la case est elle libre ? (<R) // si non on recommence !}
        begin
          inc(aie);
          statuslinetxt('T = ' + estr(T,1) + '   nb_essais_T = ' + istr(nb_essais_T) + '   nb_succes_T = ' + istr(nb_succes_T) + '   testoccup pas content : ' + istr(aie));
          dx0:=random(2*dxmax)-dxmax+1;
          dy0:=random(2*dymax)-dymax+1;
          dphi0:=random(2*dphimax)-dphimax+1;
          no:=random(nbpoles-6)+7;
          if (centres[no,3]+dphi0)<0 then dphi0:=12+centres[no,3]+dphi0;
        end;

        inc(nb_essais_T);

        nrj_nouvelle:=energie(no,dx0,dy0,dphi0);
        deltaE:=nrj_nouvelle - nrj_courante;
        Affdebug('delta E: '+ estr(deltaE,5),17);

        if deltaE<=0 then
        begin
          nrj_courante:=nrj_nouvelle;
          inc(centres[no,1],dx0);
          inc(centres[no,2],dy0);
          centres[no,3]:=((centres[no,3]+dphi0) mod 12)+1;
          matpots:=newpots;
        end;

        if deltaE>0 then
        begin
          r:=random;
          Affdebug('r = ',17);
          Affdebug(estr(r,5),17);
          Affdebug('exp(-deltaE/(kutil*T)) = '+ estr(exp(-deltaE/(kutil*T)),5),17);
          if r<exp(-deltaE/(kutil*T)) then
          begin
            nrj_courante:=nrj_nouvelle;
            inc(centres[no,1],dx0);
            inc(centres[no,2],dy0);
            centres[no,3]:= ((centres[no,3]+dphi0) mod 12)+1;
            matpots:=newpots;
            inc(nb_succes_T);
            Affdebug('succes !',17);
          end;
        end;
        inc(cpt);
        extevolution.yvalue[cpt]:=nrj_courante;
    end;
    T:=T-dT;

  for i:=1 to taille do
  for j:=1 to taille do
    extpots.Zvalue[i,j]:=matPots[i,j,12];

  end;    {fin du while T<Tmin}


  statuslinetxt('fini le recuit ! a table !');

  for i:=1 to nbPoles do
  begin
    extCentres.polylines[0].addPoint(centres[i,1],centres[i,2]);
    extxp.yvalue[i]:=centres[i,1];
    extyp.yvalue[i]:=centres[i,2];
  end;



end;




end.

