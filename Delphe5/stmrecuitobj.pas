unit stmrecuitobj;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,dgraphic,math,
     stmObj,stmdef,stmmat1,stmvec1,stmgraph2,debug0,stmpg;

{$R+}    {range checking}
{c'est un objet ! :-)  }
{version AVEC  PINWHEELS }


type

        matricespotentiels = array[1..200,1..200,1..12] of single; { of array of array} {matrice des potentiels en chaque point }
        tableauxsuivants = array[1..300,0..5] of integer; { suivants dans une chaine }

        TAFanneal=class(typeUO)

              private

                taille,nbpin,nbpoles,nb_essais_max,nb_succes_max,
                Tinit,Tmin,dT,dxmax,dymax,dphimax,R,T,cpt,indice_passage : integer;
                kdemarre, k, kutil,nrj_courante : real;


                newpots,matpots : matricespotentiels;
                centres : array[1..300,1..3] of integer; { coordonnees des centres des poles, et de l'angle phi}
                suivants,nextsuivants : tableauxsuivants;
                nbchain,passage : array[1..300] of integer;      {nb d'elements dans la chaine a laquelle appartient un centre}
                                                                 {points deja visités dans une chaine }

                function Vpot(ro, theta, phi : float):float;
                function Pinpot(ro, theta, phi : float):float;
                procedure Vtot(x0,y0,phi0 : integer);
                procedure Pintot(x0,y0,phi0 : integer);
                procedure Vdepart;
                procedure Pindepart;
                procedure supprime_doubles(no:integer);
                function testoccup(x0,y0,no:integer):boolean;
                function est_centre(x,y,phi,no : integer ):integer;
                function deja_passe(no : integer):integer;
                function recurcount(no,anc,noinit,prim : integer ):integer;
                function energie(no,dx0,dy0,dphi0 : integer ):float;



              public

                constructor create;override;
                destructor destroy;override;

                class function STMClassName:AnsiString;override;

                procedure Init(var extpots:Tmatrix ; var extevolution,extxp,extyp : Tvector);
                procedure CalculIter(var extpots:Tmatrix ; var extevolution,extxp,extyp : Tvector);

              end;

procedure proTAFanneal_create(stName:AnsiString;var pu:typeUO);pascal;
procedure proTAFanneal_Init(var extpots:Tmatrix ; var extevolution,extxp,extyp : Tvector ; var pu:typeUO);pascal;
procedure proTAFanneal_CalculIter(var extpots:Tmatrix ; var extevolution,extxp,extyp : Tvector ; var pu:typeUO);pascal;
function fonctionTAFanneal_T(var pu : typeUO):integer;pascal;


implementation


function Norm(x,y:double):double;
begin
  result:=sqrt( sqr(x)+sqr(y) );
end;


{**************************************************************************************************************}
{definitions des fonctions "private" de l'objet}


constructor TAFanneal.create;
begin
  inherited create;
  taille:=200;
  nbpin := 0;
  nbpoles:=6+36;
  nb_essais_max := 40 ;            {type 1 = 40}     {type 2 = 40}
  nb_succes_max := 10 ;            {type 1 = 10}     {type 2 = 10}
  Tinit:=200;                      {type 1 = 150}    {type 2 = 150}
  Tmin:=20 ;                       {type 1 = 30}     {type 2 = 20}
  dT:=2;                           {type 1 = 3}      {type 2 = 2}
  kdemarre:=0.01;                  {type 1 = 0.01}   {type 2 = 0.01}
  k:=0.003; {constante de boltzman}{type 1 = 0.003}  {type 2 = 0.003}
  dxmax:=20;
  dymax:=20;
  dphimax:=3;
  R:=10;  {rayon d'interdiction}
  nrj_courante:=0;

 { setlength(newpots,taille+1,taille+1,13);
  setlength(matpots,taille+1,taille+1,13);      }

end;

destructor TAFanneal.destroy;
begin
  inherited;
end;

class function TAFanneal.STMClassName: AnsiString;
begin
   result := 'AFanneal';
end;

function TAFanneal.Vpot(ro, theta, phi : float):float;    { On va definir une fonction potentiel Vi= f( ro, theta, phi)  }

const
  a=10;    { en fait axe horizontal}
  b=5; {et vertical }
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

{grosse ellipse exterieure}
  if (xrel*xrel/((a*2.5)*(a*2.5))+yrel*yrel/((b*4)*(b*4))<=1) and (ro>0) then
        Vi:=smax/2;

{ sur le point }
  if ro=0 then Vi:=0

{ on est dans l'ellipse centrale, facilitatrice //  le 4 vient du b/2*b/2}
  else if (xrel*xrel/(a*a)+yrel*yrel/(b2*b2)<=1) and (ro>0) then
        Vi:=cmax*(xrel*xrel/(a*a)+yrel*yrel/(b2*b2))-1*cmax        {de -cmax a 0 }

{on est dans l'ellipse exterieure, inhibitrice}
  else if (xrel*xrel/(a*a)+yrel*yrel/(b2*b2)>1) and (xrel*xrel/(a*a)+yrel*yrel/(b*b)<=1) then
        Vi:=(xrel*xrel/(a*a)+yrel*yrel/(b*b))*(-0.5*cmax)+0.5*cmax; {de 0.5*cmax a 0, a une legere approximation pres  }


  ropap:=Norm(xrel-11*a/10,yrel);
  thetapap:=Angle(xrel-11*a/10,yrel);
  limro:=a*f;

  if (ropap<=limro) and (abs(thetapap)<=pi/(3*divangle)) then
  begin
    Vi:=smax/2;
    if (abs(phi-thetapap)<pi/(3*divangle)) or (abs(phi-thetapap)>pi-pi/(3*divangle)) then
      Vi:=-smax;                                                                 {type 3}
      {Vi:=-smax*cos(2*(phi-thetapap));}                                                {type 2}
      {Vi:=(smax*ropap/limro-smax)*cos(1.5*divangle*thetapap)*cos(2*phi);}        {type 1}
  end;

  ropap:=Norm(xrel+11*a/10,yrel);
  thetapap:=Angle(xrel+11*a/10,yrel);
  if thetapap<0 then thetapap:=2*pi+thetapap;

  if (ropap<=limro) and ((abs(thetapap-pi)<=pi/(3*divangle)) or (abs(thetapap+pi)<=pi/(3*divangle))) then
  begin
    Vi:=smax/2;
    if (abs(phi-thetapap-pi)<pi/(3*divangle)) or (abs(phi-thetapap+pi)<pi/(3*divangle)) or (abs(phi-thetapap+pi)>(pi-pi/(3*divangle)))       then

      Vi:=-smax;                                                                 {type 3}
      {Vi:=-smax*cos(2*(phi-thetapap+pi));}                                              {type 2}
      {Vi:=(smax*ropap/limro-smax)*abs(cos(1.5*divangle*(thetapap-pi)))*cos(2*phi);}  {type 1}
  end;

    result:=Vi;
end;




function TAFanneal.Pinpot(ro, theta, phi : float):float; {fonction potentiel des pinwheels}

const
 D = 30;  {distance d'interaction maximales des pinwheels }
  pmax = 2;     {valeur max de l'interaction}

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




procedure TAFanneal.Vtot(x0,y0,phi0 : integer);      {calcul du potentiel total en un point}

var
  cpt : integer;

begin

  for cpt:=7 to nbpoles do
    matpots[x0,y0,phi0]:=matpots[x0,y0,phi0]+Vpot(norm(x0-centres[cpt,1],y0-centres[cpt,2]),Angle((x0-centres[cpt,1]),(y0-centres[cpt,2]))-pi/12*centres[cpt,3],pi/12*(phi0-centres[cpt,3]));

end;


procedure TAFanneal.Pintot(x0,y0,phi0 : integer);      {calcul du potentiel total en un point}

var
  cpt : integer;

begin

  for cpt:=1 to nbpin do
    matpots[x0,y0,phi0]:=matpots[x0,y0,phi0]+Pinpot(norm(x0-centres[cpt,1],y0-centres[cpt,2]),Angle((x0-centres[cpt,1]),(y0-centres[cpt,2]))-pi/6*centres[cpt,3],pi/12*phi0-pi/6*centres[cpt,3]);

end;



procedure TAFanneal.Vdepart;

var
  i,j,k : integer;

begin

  statuslinetxt('Vdepart');
  for i:=1 to taille do
    for j:=1 to taille do
     for k:=1 to 12 do
       Vtot(i,j,k);                    { ca ca va etre long...}

end;


procedure TAFanneal.Pindepart;

var
  i,j,k : integer;

begin

  statuslinetxt('Pindepart');
  for i:=1 to taille do
    for j:=1 to taille do
     for k:=1 to 12 do
       Pintot(i,j,k);            { on duplique...}

end;



procedure TAFanneal.Init(var extpots:Tmatrix ; var extevolution,extxp,extyp : Tvector);

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
  centres[5,2]:=10;
  centres[5,3]:=12;

  centres[6,1]:=100;
  centres[6,2]:=190;
  centres[6,3]:=6;

  for i:=7 to nbpoles do
  begin
    centres[i,1]:= (((i-7) mod 7))*30+10;            {*30 + 40}
    centres[i,2]:= ((floor(i/7-1) {mod 6}))*30+10;      {*25+  62}
    centres[i,3]:=(i mod 12)+1;           {equirepartition ideale pour nbpoles = 6+k*12}
    Affdebug(istr(centres[i,1]),17);
    Affdebug(istr(centres[i,2]),17);
    Affdebug(istr(centres[i,3]),17);
  end;

  {  centres[7,1]:=100;
    centres[7,2]:=100;
    centres[7,3]:=12;
   centres[8,1]:=150;
    centres[8,2]:=30;
    centres[8,3]:=12;            }        { tests a la mano }

{initialiser matpots}
  for i:=1 to taille do
    for j:=1 to taille do
      for k:=1 to 12 do
      begin
        matpots[i,j,k]:=0;
        newpots[i,j,k]:=0;
      end;

  Pindepart;
  Vdepart;


{initialisation suivants}
  for i:=1 to 300 do
    for j:=0 to 5 do
    begin
      suivants[i,j]:=0;
      nextsuivants[i,j]:=0;
    end;


{verifications/initialisations objets interfaces}
  verifierObjet(typeUO(extpots));
  extpots.initTemp(1,taille,1,taille,g_single);

  verifierVecteurTemp(extevolution);
  extevolution.initTemp1(1,50000,g_single);
  verifierVecteurTemp(extxp);
  extxp.initTemp1(1,nbpoles+1,g_single);
  verifierVecteurTemp(extyp);
  extyp.initTemp1(1,nbpoles+1,g_single);

 {initialisation des variables d'etat}

  T:=Tinit;
  kutil:=kdemarre;
  cpt:=0;   {compteur de l'evolution}

end;


function TAFanneal.testoccup(x0,y0,no:integer):boolean;     { peut on occuper une case ? }

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


function TAFanneal.est_centre(x,y,phi,no : integer ):integer;

var
  cpt,plop : integer;

begin
  plop:=0;
  for cpt:=7 to nbpoles do
  begin
    if cpt<>no then
      if (centres[cpt,1]=x) and (centres[cpt,2]=y) and (centres[cpt,3]=phi) then
        plop:=cpt;
  end;
  result:=plop;
end;



function TAFanneal.deja_passe(no : integer):integer;

var
  cptind,blip : integer;

begin
  blip:=0;
  for cptind:=1 to indice_passage-1 do
    if passage[cptind]=no then blip:=1;

  result:=blip;
end;


procedure TAFanneal.supprime_doubles(no:integer);

var
  cpt,cpt2,cpt3 : integer;

begin
  for cpt:=1 to nextsuivants[no,0] do
  begin
    for cpt2:=cpt to nextsuivants[no,0] do
    begin
      if (cpt2>cpt) and (nextsuivants[no,cpt]=nextsuivants[no,cpt2]) then
      begin
        {on supprime le cpt2}
        for cpt3:=cpt2+1 to nextsuivants[no,0] do
          nextsuivants[no,cpt3-1]:=nextsuivants[no,cpt3];
        nextsuivants[no,nextsuivants[no,0]]:=0;
        nextsuivants[no,0]:=nextsuivants[no,0]-1;
      end;
    end;
  end;

end;


function TAFanneal.recurcount(no,anc,noinit,prim : integer ):integer;

var
  cpt,accu,dj: integer;

begin
  accu:=1;
  cpt:=1;

  inc(indice_passage);
  passage[indice_passage]:=no;
  {affdebug('on recupere : no = '+istr(no),17);   }
  dj:=deja_passe(no);
  {affdebug('dj = '+istr(dj),17); }
  if (dj>0) then
  begin
    {  affdebug('boucle ! sur no = '+istr(no),17);
      affdebug('et prim = '+istr(prim),17);   }
      cpt:=nextsuivants[no,0];
      accu:=50;
  end

   else if (dj=0) then
   begin
     while cpt<=nextsuivants[no,0] do
     begin
     { affdebug('on a cpt= '+istr(cpt),17);
       affdebug('on a indice passage = '+istr(indice_passage),17);
       affdebug('on a prim = '+istr(prim),17);  }
       if (nextsuivants[no,cpt]<>anc) then
       begin
        { affdebug('avec nextsuivants[no,0] = '+istr(nextsuivants[no,0]),17);
          affdebug('avec cpt = '+istr(cpt),17);
          affdebug('on repasse : nextsuivants[no,cpt]= '+istr(nextsuivants[no,cpt]),17);             }
          accu:=accu+recurcount(nextsuivants[no,cpt],no,noinit,prim+1);
       end
       else if (nextsuivants[no,cpt]=anc) and (nextsuivants[no,0]=1) then
         accu:=accu;

       inc(cpt);
     end;
   end;
  result:=accu;

end;


function TAFanneal.energie(no,dx0,dy0,dphi0 : integer ):float;

var
  somme,V,Vd : float;
  i,j,k,cpt{,cpt2,indicemax,new,anchain }: integer;

begin

  { for i:=1 to 300 do
     for j:=0 to 5 do
      nextsuivants[i,j]:=suivants[i,j];      }

  for i:=1 to taille do
    for j:=1 to taille do
      for k:=1 to 12 do
      begin
        V:=Vpot(norm(i-centres[no,1],j-centres[no,2]),Angle((i-centres[no,1]),(j-centres[no,2]))-pi/12*centres[no,3],pi/12*(k-centres[no,3]));
        Vd:=Vpot(norm(i-centres[no,1]-dx0,j-centres[no,2]-dy0),Angle((i-centres[no,1]-dx0),(j-centres[no,2]-dy0))-pi/12*(((centres[no,3]+dphi0) mod 12)+1),pi/12*(k-(((centres[no,3]+dphi0) mod 12)+1)));
        newpots[i,j,k]:= matpots[i,j,k] - V + Vd;

     {   new:=est_centre(i,j,k,no);
        if new>0 then
        begin
        {affdebug('est centre = '+ istr(new),17);
          if V<0 then
          begin
          {  affdebug('V<0 sur centre = '+ istr(new),17);
            for cpt:=1 to nextsuivants[no,0] do
            begin
              if nextsuivants[no,cpt]=new then
              begin
              {  affdebug('on enleve : no = '+istr(new),17);
                affdebug('indicemax = '+istr(nextsuivants[no,0]),17);
                for cpt2:=cpt+1 to nextsuivants[no,0] do
                  nextsuivants[no,cpt2-1]:=nextsuivants[no,cpt2];
                nextsuivants[no,nextsuivants[no,0]]:=0;
                nextsuivants[no,0]:=nextsuivants[no,0]-1;
              end;
            end;
          end;

          if Vd<0 then
          begin
            affdebug('Vd<0 sur centre = '+ istr(new),17);
            nextsuivants[no,0]:=nextsuivants[no,0]+1;
            indicemax:=nextsuivants[no,0];
            affdebug('nouveau suivant : new = '+istr(new),17);
            affdebug('indicemax = '+istr(indicemax),17);
            nextsuivants[no,indicemax]:=new;
          end;

        end;  }
      end;    

  {anchain:=nbchain[no];
  for cpt:=7 to nbpoles do
  begin
    supprime_doubles(cpt);
    indice_passage:=0;
    affdebug('pole numero = '+ istr(cpt),17);
    for cpt2:=0 to nextsuivants[cpt,0] do affdebug('suivant '+ istr(cpt2)+' = ' + istr(nextsuivants[cpt,cpt2]),17);
    nbchain[cpt]:=0;   recurcount(cpt,0,cpt,1);
    affdebug('valeur chaine = '+ istr(nbchain[cpt]),17);
  end;               }

  somme:=0;

  for cpt:=7 to nbpoles do
  begin
    somme:=somme+newpots[centres[cpt,1],centres[cpt,2],centres[cpt,3]]{*sqrt(nbchain[cpt])};
  end;

  somme:=somme-newpots[centres[no,1],centres[no,2],centres[no,3]]{*sqrt(anchain)} + newpots[centres[no,1]+dx0,centres[no,2]+dy0,((centres[no,3]+dphi0) mod 12)+1]{*sqrt(nbchain[no])};
  result:=somme;

end;

procedure TAFanneal.CalculIter(var extpots:Tmatrix ; var extevolution,extxp,extyp : Tvector);

var

  nrj_nouvelle,deltaE,r : real;
  dx0,dy0,dphi0,no,nb_essais_T,nb_succes_T,i,j,l,aie : integer;

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
        dx0:=random(2*dxmax+1)-dxmax;
        dy0:=random(2*dymax+1)-dymax;
        dphi0:=random(2*dphimax+1)-dphimax; {somme des orientations nulle :=-1 }
        no:=random(nbpoles-6)+7;
        if (centres[no,3]+dphi0)<0 then dphi0:=12+centres[no,3]+dphi0;


        while (testoccup(centres[no,1]+dx0,centres[no,2]+dy0,no)) and (aie<100) do  { la case est elle libre ? (<R) // si non on recommence !}
        begin
          inc(aie);
          statuslinetxt('T = ' + estr(T,1) + '   nb_essais_T = ' + istr(nb_essais_T) + '   nb_succes_T = ' + istr(nb_succes_T) + '   testoccup pas content : ' + istr(aie));
          dx0:=random(2*dxmax+1)-dxmax;
          dy0:=random(2*dymax+1)-dymax;
          dphi0:=random(2*dphimax+1)-dphimax; {somme des orientations nulle := -1 }
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
          for i:=1 to taille do
              for j:=1 to taille do
                for l:=1 to 12 do
                  matpots[i,j,l]:=newpots[i,j,l];

          for i:=1 to 300 do
            for j:=0 to 5 do
              suivants[i,j]:=nextsuivants[i,j];

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
            for i:=1 to taille do
              for j:=1 to taille do
                for l:=1 to 12 do
                  matpots[i,j,l]:=newpots[i,j,l];

            for i:=1 to 300 do
              for j:=0 to 5 do
                suivants[i,j]:=nextsuivants[i,j];

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
    extpots.Zvalue[i,j]:=matpots[i,j,12];

  for i:=1 to nbPoles do
  begin
    extxp.yvalue[i]:=centres[i,1];
    extyp.yvalue[i]:=centres[i,2];
  end;

end;




{**************************************************************************************************************}
{methodes externes de l'objet}


procedure proTAFanneal_create(stName:AnsiString;var pu:typeUO);

begin
  createPgObject(stname,pu,TAFanneal);
end;


procedure proTAFanneal_Init(var extpots:Tmatrix ; var extevolution,extxp,extyp : Tvector ; var pu:typeUO);pascal;

begin
  verifierObjet(pu);
  with TAFanneal(pu) do init(extpots,extevolution,extxp,extyp);
end;


procedure proTAFanneal_CalculIter(var extpots:Tmatrix ; var extevolution,extxp,extyp : Tvector ; var pu:typeUO);pascal;

begin
  verifierObjet(pu);
  with TAFanneal(pu) do CalculIter(extpots,extevolution,extxp,extyp);
end;


function fonctionTAFanneal_T(var pu : typeUO):integer;pascal;

begin
  verifierobjet(pu);
  result:=TAFanneal(pu).T;
end;


end.
