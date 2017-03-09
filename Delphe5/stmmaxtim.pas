unit stmmaxtim;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,dgraphic,math,
     stmObj,stmdef,stmmat1,stmgraph2;

procedure promaxtim(var extpots:Tmatrix ; var extcentres : TxyPlot);pascal;

implementation

 const
  taille = 200;            {environnement : grille taille*taille}
  nbsimul = 1;
  nbpolesmax = 50;  { passés en parametres       }


var
  centres : array[1..nbpolesmax+1,1..3] of integer; { coordonnees des centres des poles, et de l'angle phi}
  matpots : array[1..taille,1..taille,1..12] of float; {matrice des potentiels en chaque point }
  nbpoles : integer;
  Vmax,Vmin : float;


function testoccup(x0,y0:integer):boolean;     { peut on occuper une case ? }

var
  cpt : integer;
  test : boolean;
begin

  test:=False;
  for cpt:=1 to nbpoles do
  begin
    if  sqrt(sqr(x0-centres[cpt,1]) + sqr(y0-centres[cpt,2])) <20 then test:=True;
  end;

  result:=test;

end;


function Vpot(ro, theta, phi : float):float;    { On va definir une fonction potentiel Vi= f( ro, theta, phi)  }

const
  a=20;    { en fait axe horizontal}
  b=10;  {et vertical }
  b2=b/2;   { ellipse centrale   }
  f=1.5;     { facteur de reduction des potentiels sous liminaires}
  smax = 1; {valeur max du champ sous liminaire}

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
        Vi:=(xrel*xrel/(a*a)+yrel*yrel/(b2*b2))-1 ;       {de -1 a 0 }

{on est dans l'ellipse exterieure, inhibitrice}
  if (xrel*xrel/(a*a)+yrel*yrel/(b2*b2)>1) and (xrel*xrel/(a*a)+yrel*yrel/(b*b)<=1) then
        Vi:=(xrel*xrel/(a*a)+yrel*yrel/(b*b))*(-0.5)+0.5; {de 0.5 a 0, a une legere approximation pres  }


  ropap:=Norm([xrel-23,yrel]);
  thetapap:=Angle(xrel-23,yrel);
  limro:=a*f;

  if (ropap<=limro) and (abs(thetapap)<=pi/3) then
    Vi:=(smax*ropap/limro-smax)*cos(1.5*thetapap)*cos(2*phi);

  ropap:=Norm([xrel+23,yrel]);
  thetapap:=Angle(xrel+23,yrel);

  if (ropap<=limro) and ((abs(thetapap-pi)<=pi/3) or (abs(thetapap+pi)<=pi/3)) then
    Vi:=(smax*ropap/limro-smax)*abs(cos(1.5*(thetapap-pi)))*cos(2*phi);

    result:=Vi;
end;


procedure Vtot(x0,y0,phi0 : integer);      {calcul du potentiel total en un point}

begin
  matpots[x0,y0,phi0]:=matpots[x0,y0,phi0] +
                       Vpot( sqrt( sqr(x0-centres[nbpoles,1]) + sqr(y0-centres[nbpoles,2])),
                            Angle((x0-centres[nbpoles,1]),(y0-centres[nbpoles,2]))-pi/12*centres[nbpoles,3],
                            pi/12*(phi0-centres[nbpoles,3]));
end;



procedure Vextrema;          {recherche des extrema du potentiel, et remplissage de matpots }

var
  i,j,k : integer;

begin

  Vmax:=0;
  Vmin:=-0.001;

  for i:=1 to taille do
  begin
    for j:=1 to taille do
    begin
      for k:=1 to 12 do
      begin
        Vtot(i,j,k);                    { ca ca va etre long...}
        if matpots[i,j,k]>Vmax then Vmax:=matpots[i,j,k];
        if matpots[i,j,k]<Vmin then Vmin:=matpots[i,j,k];       {ou pas...}
      end;
    end;
  end;

end;



procedure promaxtim(var extpots:Tmatrix ;var extcentres: TxyPlot);

var
  poleplus : boolean;
  x0,y0,phi0,cptsimul,i,j,k : integer;
  r,v,vprim : real;

begin
  verifierObjet(typeUO(extpots));
  extpots.initTemp(1,taille,1,taille,g_single);

  verifierObjet(typeUO(extCentres));

  with extCentres do
  begin
    clear;
    addPolyLIne;
  end;

  for cptsimul:=1 to nbsimul do   { nombre simulations}
  begin

{initialiser centres}
  for i:=1 to nbpolesmax do
  begin
    for j:=1 to 3 do
    begin
      centres[i,j]:=0;
    end;
  end;



{initialiser matpots}
  for i:=1 to taille do
  begin
    for j:=1 to taille do
    begin
      for k:=1 to 12 do
      begin
        matpots[i,j,k]:=0;
      end;
    end;
  end;

{ creation du premier pole  }
  x0:=Floor(taille/2);
  y0:=Floor(taille/4);
  phi0:=12;
  nbpoles:=1;
  centres[nbpoles,1]:=x0;
  centres[nbpoles,2]:=y0;
  centres[nbpoles,3]:=phi0;


    while (nbpoles<=nbpolesmax) do               {ici on entame la grosse boucle }
    begin

    {tirage d'un point au hasard, et distribution de probas pour voir si on le laisse}
    statuslinetxt(istr(nbpoles));
    poleplus:=False;
    Vextrema;

    while (poleplus=False) do                  {tant qu'on a pas trouvé un nouveau pole}
    begin
        x0:=Floor(random(taille))+1;
        y0:=Floor(random(taille))+1;
        phi0:=Floor(random(12))+1;  {discretisation de l'angle phi en 12}
        r:=random;

        while (testoccup(x0,y0)) do  { la case est elle libre ? (<2) // si non on recommence !}
        begin
            x0:=Floor(random(taille))+1;
            y0:=Floor(random(taille))+1;
            phi0:=Floor(random(12))+1;  {discretisation de l'angle phi en 12}
            r:=random;
        end;

        v:=(matpots[x0,y0,phi0]-Vmin)/(Vmax-Vmin);  { normalisation du potentiel}
        vprim:=(-1)/(1+exp(15*v-7.5))+1;
        if r>v then
        begin
            nbpoles:=nbpoles+1;
            centres[nbpoles,1]:=x0;
            centres[nbpoles,2]:=y0;
            centres[nbpoles,3]:=phi0;
            poleplus:=True;
        end;
      end;
    end;
  end;

  for i:=1 to taille do
  for j:=1 to taille do
    extpots.Zvalue[i,j]:=matPots[i,j,12];

  for i:=1 to nbPoles do
    extCentres.polylines[0].addPoint(centres[i,1],centres[i,2]);

end;




end.





