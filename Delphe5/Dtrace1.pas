unit Dtrace1;

{$O+,F+}

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
     Dialogs,
     util1,Dgraphic,Gdos,Dgrad1,dtf0,debug0;


const
  modeEffacement:boolean=false;

  DM_DOT=1;
  DM_LINE=2;
  DM_SQUARE=3;
  DM_TRIANGLE=4;
  DM_DIAMOND=5;
  DM_CIRCLE=6;
  DM_PLUS=7;
  DM_MULT=8;
  DM_STAR=9;
  DM_HISTO0=10;
  DM_HISTO1=11;
  DM_HISTO2=12;
  DM_HISTO3=13;
  DM_EVT1=14;
  DM_EVT2=15;
  DM_Line_square=16;
  DM_Line_TRIANGLE=17;
  DM_Line_DIAMOND=18;
  DM_Line_CIRCLE=19;
  DM_Line_PLUS=20;
  DM_Line_MULT=21;
  DM_Line_STAR=22;
  DM_Line_FillB=23;
  DM_PolyGon=24;


const
  nbStyleTrace=24;
  LongNomStyleTrace=17;

  tbStyleTrace:array[1..nbStyleTrace] of string[LongNomStyleTrace]=(
                                         'DOTS',
                                         'LINES',
                                         'SQUARES',
                                         'TRIANGLES',
                                         'DIAMONDS',
                                         'CIRCLES',
                                         'PLUS',
                                         'MULT',
                                         'STARS',
                                         'HISTO0',
                                         'HISTO1',
                                         'HISTO2',
                                         'HISTO3',
                                         'EVT1',
                                         'EVT2',
                                         'LINES+SQUARES',
                                         'LINES+TRIANGLES',
                                         'LINES+DIAMONDS',
                                         'LINES+CIRCLES',
                                         'LINES+PLUS',
                                         'LINES+MULT',
                                         'LINES+STARS',
                                         'LINES/FILL',
                                         'POLYGONS'
                                         );

  {TPenStyle =(psSolid, psDash, psDot, psDashDot, psDashDotDot,
               psClear, psInsideFrame); }


  nbStyleTrait=5;
  LongNomStyleTrait=17;

  tbStyleTrait:array[1..nbStyleTrait] of string[LongNomStyleTrait]=(
                                         'SOLID',
                                         'DASH',
                                         'DOT',
                                         'DASH-DOT',
                                         'DASH-DOT-DOT');


type
  typePointA=class
               tailleSymbole:integer;      { en pixels }
               color2:integer;             {utilisé par les modes double symbole}

               Ibase,Jbase:integer;
               Jmini,Jmaxi,previousI,Jlast:integer;
               Fcompact:boolean;
               colPixel:Tcolor;

               constructor create(t:word);

               procedure afficher(i,j:integer);virtual;
               procedure AfficherPremierPoint(i,j,nbmax:integer);virtual;
               procedure AfficherDernierPoint(i,inext:integer);virtual;
             end;

  tabpoint=array[1..10000] of Tpoint;
  PtabPoint=^tabPoint;

  typeTraitA=class(typePointA)
               tab:array of Tpoint;
               nbpoint,nbAff:integer;
               FpolyGon:boolean;
               destructor destroy;override;
               procedure afficher(i,j:integer);override;
               procedure AfficherPremierPoint(i,j,nbmax:integer);override;
               procedure AfficherDernierPoint(i,inext:integer);override;

               procedure ranger(i,j:integer);virtual;
             end;

  typeCarreA=class(typePointA)
               procedure afficher(i,j:integer);override;
             end;

  typeTriangleA=class(typePointA)
               procedure afficher(i,j:integer);override;
             end;

  typeDiamantA=class(typePointA)
               procedure afficher(i,j:integer);override;
             end;

  typeCercleA=class(typePointA)
               procedure afficher(i,j:integer);override;
             end;

  typePlusA=class(typePointA)
               procedure afficher(i,j:integer);override;
             end;

  typeMultA=class(typePointA)
               procedure afficher(i,j:integer);override;
             end;

  typeEtoileA=class(typePointA)
               procedure afficher(i,j:integer);override;
             end;


  typeHistoA=class(typePointA)
               procedure afficher(i,j:integer);override;
               procedure AfficherDernierPoint(i,inext:integer);override;
             end;

  typeHisto1A=class(typePointA)
               procedure afficher(i,j:integer);override;
               procedure AfficherDernierPoint(i,inext:integer);override;
             end;

  typeHisto2A=class(typePointA)
               procedure afficher(i,j:integer);override;
               procedure AfficherDernierPoint(i,inext:integer);override;
             end;

  typeHisto3A=class(typePointA)
               procedure afficher(i,j:integer);override;
               procedure AfficherDernierPoint(i,inext:integer);override;
             end;

  typeDot1A= class(typePointA)
               procedure afficher(i,j:integer);override;
             end;

  typeDot2A= class(typePointA)
               procedure afficher(i,j:integer);override;
             end;

  typeTraitCarreA=
             class(typePointA)
               trait:typeTraitA;
               SymbAux:typePointA;
               

               constructor create(t:integer);

               destructor destroy;override;
               procedure afficher(i,j:integer);override;
               procedure AfficherPremierPoint(i,j,nbmax:integer);override;
               procedure AfficherDernierPoint(i,inext:integer);override;
             end;

  typeTraitTriA=
             class(typeTraitCarreA)
               constructor create(t:integer);
             end;

  typeTraitDiamA=
             class(typeTraitCarreA)
               constructor create(t:integer);
             end;

  typeTraitCercleA=
             class(typeTraitCarreA)
               constructor create(t:integer);
             end;

  typeTraitPlusA=
             class(typeTraitCarreA)
               constructor create(t:integer);
             end;

  typeTraitMulA=
             class(typeTraitCarreA)
               constructor create(t:integer);
             end;

  typeTraitEtoileA=
             class(typeTraitCarreA)
               constructor create(t:integer);
             end;

  typeTraitRempliA=
             class(typeTraitA)
               procedure ranger(i,j:integer);override;
               procedure AfficherDernierPoint(i,inext:integer);override;
             end;


type
  typeStyleTrace=(nulA,pointA,traitA,carreA,triangleA,DiamantA,
                  cercleA,plusA,multA,etoileA,
                  HistoA,Histo1A,Histo2A,Histo3A,dot1A,dot2A,
                  traitCarreA,traitTriA,traitDiamA,traitCercleA,traitPlusA,
                  traitMultA,traitEtoileA,traitRempliA,PolyGonA);

  typeFonctionEE=function(x:float):float of object;
  typeFonctionII=function(i:integer):integer of object;

  Tunivers=class
               XminA,XmaxA,YminA,YmaxA:float;
               exXminA,exXmaxA,exYminA,exYmaxA:float;
               modeLogX,modeLogY:boolean;
               couleurG,couleurBK:Tcolor;
               {font:TFont;}
               ux,uy:string[10];
               CadreCompletA:boolean;
               cadreOnA:boolean;
               epCadreA:integer;
               echX,echY:boolean;

               TickExtA:boolean;
               LongTickA:integer;
               epTickA:integer;
               grilleOnA:boolean;

               inverseXA,inverseYA:boolean;

               constructor create;
               destructor destroy;override;
               function error:integer;virtual;
               procedure setWorld(x1,y1,x2,y2:float);
               procedure setModeLog(LogX,LogY:boolean);

               procedure setUnites(unitx,unity:AnsiString);
               procedure setEchelle(echelleX,echelleY:boolean);

               procedure setCadre(complet:boolean;Ep:integer);
               procedure SetTicks(Externe:boolean;long,ep:integer);
               procedure setGrille(grille:boolean);
               procedure setInverse(invX,invY:boolean);

               procedure graduations;
               procedure effaceGraduations;
               procedure setcolorGrad(num,numBk:longint);
             end;

  TonDisplayPoint=procedure (i:integer) of object;

  Ttrace0=class
               U:Tunivers;

               Name:string[20];
               point:typePointA;
               styleA:typeStyleTrace;
               color,color2,colorEC:longint;

               styleT:TpenStyle;
               largeurT:integer;

               onDisplayPoint:TonDisplayPoint;

               constructor create(Univers:Tunivers);
               destructor destroy;override;
               function error:integer;virtual;
               procedure setColorTrace(n:longint);
               procedure setColorTrace2(n:longint);

               procedure setColorEC(n:longint);
               procedure setStyle(Style:integer;t:word);
               procedure setTrait(largeur,style:integer);


               procedure afficher;virtual;

               procedure cadrerX;virtual;
               procedure cadrerY;virtual;

               function Xinf:float;virtual;
               function Xsup:float;virtual;

               procedure pushCadrer(var b:boolean);
               Procedure SaisieCoo(wnd:hwnd;Modif,FontModif:boolean);

               Procedure SauverASCII
                  (var f:text;larchamp,deci:integer;sep:char);virtual;

               function identA(x:float):float;
               function logA(x:float):float;
             end;

  TtraceTableau=class(Ttrace0)
                     dataY:typedataB;
                     pas:integer;
                     SmoothF:integer; // 1 <==> nb=3
                     constructor create(Univers:Tunivers;p:pointer);
                     destructor destroy;override;
                     procedure setData(p:pointer);
                     procedure setPas(n:word);
                     function error:integer;override;

                     function cvx0(i:integer):integer;
                     function cvy0(i:integer):integer;

                     procedure afficherPoints(Idd,Iff:integer);
                     procedure afficher;override;

                     procedure cadrerX;override;
                     procedure cadrerY;override;

                     Procedure SauverASCII
                       (var f:text;larchamp,deci:integer;sep:char);override;
                   end;

    TtraceTableauDouble=
                   class(TtraceTableau)
                     dataX,dataSig:typedataB;
                     IminG,ImaxG:longint;
                     constructor create(Univers:Tunivers;px,py,ps:pointer);
                     destructor destroy;override;
                     procedure setIminImax(i1,i2:longint);
                     procedure setData(px,py,ps:pointer);
                     function error:integer;override;
                     procedure afficher;override;

                     procedure cadrerX;override;
                     procedure cadrerY;override;

                     Procedure SauverASCII
                       (var f:text;larchamp,deci:integer;sep:char);override;
                   end;

    TtraceFonction=
                   class(Ttrace0)
                     getX,getY:typeFonctionEE;
                     m1,m2:float;
                     nbPt:integer;
                     nbError0:integer;
                     constructor create(Univers:Tunivers);
                     procedure setFonction(gX,gY:typeFonctionEE;
                                           v1,v2:float;nb:integer);
                     destructor destroy;override;
                     function error:integer;override;
                     function nbError:integer;
                     procedure afficher;override;

                     Procedure SauverASCII
                       (var f:text;larchamp,deci:integer;sep:char);override;
                   end;



procedure AfficheMessageErreur(num:integer);


type
  TtraceEv=     class(Ttrace0)
                     data:typedataEV;
                     voie:integer;  { voie de 0 … 15 }
                     constructor create(Univers:Tunivers;p:pointer;
                                      voie1:integer);
                     destructor destroy;override;
                     procedure setData(p:pointer);
                     function error:integer;override;
                     procedure afficher;override;
                   end;

procedure displaySymbol(numSymb:typeStyleTrace;taille,color:integer;x,y:float);

IMPLEMENTATION


procedure AfficheMessageErreur(num:integer);
  var
    i:integer;
  begin
    if num=0 then exit;

    case num of
      1,2: MessageCentral('Coordonnées incorrectes');

      3: MessageCentral('Xmin et Xmax doivent être strictement positifs ');
      4: MessageCentral('Ymin et Ymax doivent être strictement positifs ');

      10,11:MessageCentral('Pas de données à traiter');
      12:MessageCentral('Vecteurs de dimensions différentes');
      20:MessageCentral('Fonction mal définie');
    end;

  end;



{*********************** Méthodes de typePointA **************************}


constructor typePointA.create(t:word);
  begin
    if (t>0) and (t<=5000) then tailleSymbole:=t;
  end;


procedure typePointA.afficher(i,j:integer);
  begin
    with canvasGlb do Pixels[i,j]:=colPixel;
  end;

procedure typePointA.AfficherPremierPoint(i,j,nbmax:integer);
begin
  afficher(i,j);
end;

procedure typePointA.AfficherDernierPoint(i,inext:integer);
  begin
  end;


{*********************** Méthodes de typetraitA **************************}


destructor typeTraitA.destroy;
  begin
  end;

procedure typeTraitA.ranger(i,j:integer);
var
  k:integer;
begin
  if nbAff<nbpoint then
    begin
      inc(nbAff);
      tab[nbAff-1].x:=i;
      tab[nbAff-1].y:=j;

      if nbAff=nbPoint then
        begin
          if FpolyGon then
            begin
              canvasGlb.brush.color:=color2;
              canvasGlb.polyGon(tab);
            end
          else
          begin
            canvasGlb.brush.style:= bsClear; // Obligatoire pour pen.Style<>psSolid
            canvasGlb.polyLine(tab);
          end;
          nbAff:=1;
          tab[0].x:=i;
          tab[0].y:=j;
        end;
    end;
end;

procedure typetraitA.afficher(i,j:integer);
begin
  if not Fcompact then
    begin
      with canvasGlb do ranger(i,j);
      {affdebug(Istr(i)+' '+Istr(j) );}
      exit;
    end;

  if i<>PreviousI then
    begin
      if Jmini=Jmaxi then
        begin
          ranger(previousI,Jmaxi);
          Jlast:=Jmaxi;
        end
      else
      if abs(Jlast-Jmini)<abs(Jlast-Jmaxi) then
        begin
          ranger(previousI,Jmini);
          ranger(previousI,Jmaxi);
          Jlast:=Jmaxi;
        end
      else
        begin
          ranger(previousI,Jmaxi);
          ranger(previousI,Jmini);
          Jlast:=Jmini;
        end;

      Jmini:=j;
      Jmaxi:=j;
    end
  else
    begin
      if j<Jmini then Jmini:=j
      else
      if j>Jmaxi then Jmaxi:=j;
    end;

  previousI:=i;
end;

procedure typeTraitA.AfficherPremierPoint(i,j,nbmax:integer);
begin
  setLength(tab,0);
  nbPoint:=0;
  nbAff:=0;
  if nbmax>0 then
    begin
      nbPoint:=nbMax;
      if nbPoint>8000 then nbpoint:=8000;
      setLength(tab,nbpoint);
      fillchar(tab[0],sizeof(Tpoint)*nbpoint,0);
    end;
  ranger(i,j);
end;


procedure typeTraitA.AfficherDernierPoint(i,inext:integer);
var
  j,k:integer;
  f:text;
begin
  if  Fcompact then
  with canvasGlb do
  begin
    ranger(i,Jmini);
    ranger(i,Jmaxi);
  end;

  setLength(tab,nbAff);
  if FpolyGon then
    begin
      canvasGlb.brush.color:=color2;
      canvasGlb.polyGon(tab);
    end
  else
  begin
    canvasGlb.brush.style:= bsClear;
    canvasGlb.polyLine(tab);
  end;

  setLength(tab,0);
  nbPoint:=0;
  nbAff:=0;
end;

{*********************** Méthodes de typetraitRempliA **************************}

procedure typeTraitRempliA.ranger(i,j:integer);
var
  col:integer;
begin
  if nbAff<nbpoint then
    begin
      inc(nbAff);
      tab[nbAff-1].x:=i;
      tab[nbAff-1].y:=j;

      if nbAff=nbPoint-2 then
        begin
          tab[nbAff].x:=i;
          tab[nbAff].y:=y2act;
          tab[nbAff+1].x:=tab[0].x;
          tab[nbAff+1].y:=y2act;

          canvasGlb.brush.color:=color2;

          setLength(tab,nbAff+2);
          canvasGlb.polygon(tab);

          col:=canvasGlb.pen.color;
          canvasGlb.pen.color:=color2;
          canvasGlb.moveto(tab[0].x,tab[0].y);
          canvasGlb.lineto(tab[0].x,y2act);
          canvasGlb.lineto(tab[nbAff].x,y2act);
          canvasGlb.lineto(tab[nbAff].x,tab[nbAff-1].y);
          canvasGlb.pen.color:=col;

          nbAff:=1;
          tab[nbAff-1].x:=i;
          tab[nbAff-1].y:=j;
        end;
    end;
end;


procedure typeTraitRempliA.AfficherDernierPoint(i,inext:integer);
var
  j:integer;
  f:text;
  col:integer;
begin
  if  Fcompact then
  with canvasGlb do
  begin
    ranger(i,Jmini);
    ranger(i,Jmaxi);
  end;

  tab[nbAff].x:=i;
  tab[nbAff].y:=y2act;
  tab[nbAff+1].x:=tab[0].x;
  tab[nbAff+1].y:=y2act;

  canvasGlb.brush.color:=color2;
  setLength(tab,nbAff+2);
  canvasGlb.polygon(tab);

  col:=canvasGlb.pen.color;
  canvasGlb.pen.color:=color2;
  canvasGlb.moveto(tab[0].x,tab[0].y);
  canvasGlb.lineto(tab[0].x,y2act);
  canvasGlb.lineto(tab[nbAff].x,y2act);
  canvasGlb.lineto(tab[nbAff].x,tab[nbAff-1].y);
  canvasGlb.pen.color:=col;

  setLength(tab,0);
  nbPoint:=0;
  nbAff:=0;
end;



{*********************** Méthodes de typecarreA **************************}


procedure typecarreA.afficher(i,j:integer);
  begin
    with canvasGlb do
      rectangle(i-tailleSymbole div 2,j-tailleSymbole div 2,
                i+tailleSymbole div 2,j+tailleSymbole div 2)
  end;




{*********************** Méthodes de typeTriangleA *************************}

procedure typeTriangleA.afficher(i,j:integer);
  var
    p:array[1..3] of Tpoint;
  begin
    p[1].x:= i+tailleSymbole div 2; p[1].y:=round(j+0.2886751*tailleSymbole);
    p[2].x:= i;                     p[2].y:=round(j-0.5773502*tailleSymbole);
    p[3].x:= i-tailleSymbole div 2; p[3].y:=round(j+0.2886751*tailleSymbole);

    with canvasGlb do polygon(p);
  end;



{*********************** Méthodes de typeDiamantA *************************}

procedure typeDiamantA.afficher(i,j:integer);
  var
    p:array[1..4] of Tpoint;
  begin
    p[1].x:= i+tailleSymbole div 2;  p[1].y:=j;
    p[2].x:= i;                      p[2].y:=j+tailleSymbole div 2;
    p[3].x:= i-tailleSymbole div 2;  p[3].y:=j;
    p[4].x:= i;                      p[4].y:=j-tailleSymbole div 2;

    with canvasGlb do polygon(p);
  end;



{*********************** Méthodes de typeCercleA *************************}

procedure typeCercleA.afficher(i,j:integer);
  var
    a:integer;
  begin
    a:=tailleSymbole div 2;
    with canvasGlb do ellipse(i-a,j-a,i+a,j+a);
  end;



{*********************** Méthodes de typePlusA *************************}


procedure typePlusA.afficher(i,j:integer);
  var
    a:integer;
  begin
    a:=tailleSymbole div 2;

    with canvasGlb do
    begin
      moveto(i-a,j);
      lineto(i+a,j);
      moveto(i,j-a);
      lineto(i,j+a);
    end;
  end;


{*********************** Méthodes de typeMultA *************************}

procedure typeMultA.afficher(i,j:integer);
  var
    a:integer;
  begin
    a:=tailleSymbole div 2;

    with canvasGlb do
    begin
      moveto(i-a,j-a);
      lineto(i+a,j+a);
      moveto(i+a,j-a);
      lineto(i-a,j+a);
    end;
  end;



{*********************** Méthodes de typeEtoileA *************************}



procedure typeEtoileA.afficher(i,j:integer);
  var
    a,k:integer;
  begin
    a:=tailleSymbole div 2;

    with canvasGlb do
    for k:=0 to 2 do
      begin
        moveto(i+roundI(a*cos(k*Pi/3)*2) ,
               j+roundI(a*sin(k*Pi/3)*2) );
        lineto(i+roundI(a*cos(Pi+k*Pi/3)*2) ,
               j+roundI(a*sin(Pi+k*Pi/3)*2) );
      end;
  end;



{*********************** Méthodes de typeHistoA *************************}

procedure typeHistoA.afficher(i,j:integer);
  var
    last:Tpoint;
  begin
    with canvasGlb do
    begin
      last:=penPos;
      if last.y<Jbase
        then rectangle(last.x,last.y,i+1,Jbase+1)
        else rectangle(last.x,Jbase,i+1,last.y+1);

      moveto(i,j);
    end;
  end;

procedure typeHistoA.AfficherDernierPoint(i,inext:integer);
  begin
    with canvasGlb do afficher(inext,penPos.Y);
  end;


{*********************** Méthodes de typeHisto1A *************************}

procedure typeHisto1A.afficher(i,j:integer);
  var
    last:Tpoint;
    sty:TbrushStyle;

  begin
    with canvasGlb do
    begin
      last:=penPos;
      sty:=brush.style;
      brush.style:=bsclear;
      if last.y<Jbase
        then rectangle(last.x,last.y,i+1,Jbase+1)
        else rectangle(last.x,Jbase,i+1,last.y+1);

      moveto(i,j);
      brush.style:=sty;
    end;
  end;


procedure typeHisto1A.AfficherDernierPoint(i,inext:integer);
  var
    last:Tpoint;
  begin
    with canvasGlb do afficher(inext,penPos.y);
  end;



{*********************** Méthodes de typeHisto2A *************************}

procedure typeHisto2A.afficher(i,j:integer);
  begin
    with canvasGlb do
    begin
      lineto(i,penPos.y);
      lineto(i,j);
    end;
  end;


procedure typeHisto2A.AfficherDernierPoint(i,inext:integer);
  begin
    with canvasGlb do afficher(inext,penPos.y);
  end;

{*********************** Méthodes de typeHisto3A ************************}

procedure typeHisto3A.afficher(i,j:integer);
  var
    last:Tpoint;
    penColor:Tcolor;
  begin
    with canvasGlb do
    begin

      last:=penPos;

      if last.y<=Jbase
        then rectangle(last.x+1,last.y,i+1,Jbase+1)
        else rectangle(last.x+1,Jbase-1,i+1,last.y);

      penColor:=pen.color;
      pen.color:=color2;
      moveto(last.x,last.y);
      lineto(i,last.y);
      lineto(i,j);
      pen.Color:=penColor;

    end;
  end;

procedure typeHisto3A.AfficherDernierPoint(i,inext:integer);
  begin
    with canvasGlb do afficher(inext,penPos.y);
  end;


{*********************** Méthodes de typeDot1A *************************}

procedure typeDot1A.afficher(i,j:integer);
  begin
    with canvasGlb do
    begin
      moveto(i,j);
      lineto(i,j+tailleSymbole);
    end;
  end;

{*********************** Méthodes de typeDot2A *************************}

procedure typeDot2A.afficher(i,j:integer);
  begin
    with canvasGlb do
    begin
      moveto(i,0);
      lineto(i,y2act);
    end;
  end;


{*********************** Méthodes de typeTraitCarreA *************************}

constructor typeTraitCarreA.create(t:integer);
begin
  trait:=typeTraitA.create(t);


  symbAux:=typeCarreA.create(t);
end;

destructor typeTraitCarreA.destroy;
begin
  trait.free;
  symbAux.free;
end;

procedure typeTraitCarreA.afficher(i,j:integer);
var
  col:integer;
begin
  canvasGlb.moveto(previousI,Jlast);
  canvasGlb.lineto(i,j);
  
  col:=canvasGlb.pen.color;
  canvasGlb.pen.color:=color2;
  canvasGlb.brush.color:=color2;
  symbAux.afficher(previousI,Jlast);
  canvasGlb.pen.color:=col;
  canvasGlb.brush.color:=col;

  previousI:=i;
  Jlast:=j;

end;

procedure typeTraitCarreA.AfficherPremierPoint(i,j,nbmax:integer);
var
  col:integer;
begin
  previousI:=i;
  Jlast:=j;

  afficher(i,j);
end;

procedure typeTraitCarreA.AfficherDernierPoint(i,inext:integer);
var
  col:integer;
begin

  col:=canvasGlb.pen.color;
  canvasGlb.pen.color:=color2;
  canvasGlb.brush.color:=color2;
  symbAux.afficher(previousI,Jlast);
  canvasGlb.pen.color:=col;
  canvasGlb.brush.color:=col;
end;


{*********************** Méthodes de typeTraitTriA *************************}

constructor typeTraitTriA.create(t:integer);
begin
  trait:=typeTraitA.create(t);
  symbAux:=typeTriangleA.create(t);
end;


{*********************** Méthodes de typeTraitDiamA *************************}

constructor typeTraitDiamA.create(t:integer);
begin
  trait:=typeTraitA.create(t);
  symbAux:=typeDiamantA.create(t);
end;


{*********************** Méthodes de typeTraitCercleA *************************}

constructor typeTraitCercleA.create(t:integer);
begin
  trait:=typeTraitA.create(t);
  symbAux:=typeCercleA.create(t);
end;


{*********************** Méthodes de typeTraitPlusA *************************}

constructor typeTraitPlusA.create(t:integer);
begin
  trait:=typeTraitA.create(t);
  symbAux:=typePlusA.create(t);
end;


{*********************** Méthodes de typeTraitMulA *************************}

constructor typeTraitMulA.create(t:integer);
begin
  trait:=typeTraitA.create(t);
  symbAux:=typeMultA.create(t);
end;


{*********************** Méthodes de typeTraitEtoileA *************************}

constructor typeTraitEtoileA.create(t:integer);
begin
  trait:=typeTraitA.create(t);
  symbAux:=typeEtoileA.create(t);
end;


{*********************** Méthodes de Tunivers ***************************}

constructor Tunivers.create;
  begin
    XminA:=0;
    XmaxA:=1000;
    YminA:=0;
    YmaxA:=1000;
    modeLogX:=false;
    modeLogY:=false;;

    ux:='';
    uy:='';
    CadreCompletA:=true;
    cadreOnA:=true;
    epCadreA:=1;

    echX:=true;
    echY:=true;
    TickExtA:=false;
    couleurG:=clBlack;
    couleurBK:=clwhite;

    LongTickA:=0;
    epTickA:=1;
    grilleOnA:=false;

  end;

destructor Tunivers.destroy;
  begin

  end;

procedure Tunivers.setWorld(x1,y1,x2,y2:float);
  begin
    exXminA:=XminA;
    exXmaxA:=XmaxA;
    exYminA:=YminA;
    exYmaxA:=YmaxA;
    XminA:=x1;
    XmaxA:=x2;
    YminA:=y1;
    YmaxA:=y2;
  end;

procedure Tunivers.setModeLog(LogX,LogY:boolean);
  begin
    modeLogX:=logX;
    modeLogY:=logY;
  end;

procedure Tunivers.setUnites(unitx,unity:AnsiString);
  begin
    ux:=unitX;
    uy:=unitY;
  end;

procedure Tunivers.setEchelle(echelleX,echelleY:boolean);
  begin
    echX:=echelleX;
    echY:=echelleY;
  end;

procedure Tunivers.setCadre(complet:boolean;Ep:integer);
  begin
    CadreCompletA:=complet;
    epCadreA:=ep;
  end;

procedure Tunivers.SetTicks(Externe:boolean;long,ep:integer);
  begin
    TickExtA:=Externe;
    LongTickA:=long;
    epTickA:=ep;
  end;

procedure Tunivers.setGrille(grille:boolean);
  begin
    grilleOnA:=grille;
  end;

procedure Tunivers.setInverse(invX,invY:boolean);
begin
  inverseXA:=invX;
  inverseYA:=invY;
end;

function Tunivers.error:integer;
  begin
    if XminA=XmaxA then error:=1
    else
    if YminA=YmaxA then error:=2
    else
    if modeLogX and ((XminA<=0) or (XmaxA<=0)) then error:=3
    else
    if modeLogY and ((YminA<=0) or (YmaxA<=0)) then error:=4
    else
    error:=0;
  end;

procedure Tunivers.graduations;
  var
    grad:typeGrad;
  begin

    if error<>0 then exit;
    Dgraphic.setWorld(XminA,YminA,XmaxA,YmaxA);

    grad:=typeGrad.create;
    with grad do
    begin
      setUnites(ux,uy);
      setLog(modelogX,modelogY);
      setEch(echX,echY);
      setTicks(epTickA,LongTickA,TickExtA);
      setGrille(grilleOnA);
      setColors(couleurG,couleurBK);
      setComplet(CadreCompletA,CadreCompletA);
      setCadre(cadreOnA,cadreOnA,epCadreA);
      affiche;
    end;
    grad.free;
    {canvasGlb.font.assign(oldfont);}
  end;

procedure Tunivers.Effacegraduations;
  begin
    if error<>0 then exit;
    Dgraphic.setWorld(exXminA,exYminA,exXmaxA,exYmaxA);
    {
    setColorWR(colBK);
    Ggraduations(ux,uy,false,modelogY,modelogX,echY,echX);
    setColorWR(couleurDefaut);
    }
  end;


procedure Tunivers.setcolorGrad(num,numBk:longint);
  begin
    couleurG:=num;
    couleurBK:=numBK;
  end;


{*********************** Méthodes de Ttrace0 ****************************}

constructor Ttrace0.create(Univers:Tunivers);
  begin
    U:=Univers;
    color:=0;
    colorEC:=0;
    point:=TypePointA.create(1);
    styleA:=pointA;
    styleT:=psSolid;
    largeurT:=1;

  end;


destructor Ttrace0.destroy;
  begin
    point.free;
  end;

procedure Ttrace0.setStyle(Style:integer;T:word);
  begin
    point.free;

    if PRprinting then T:=round(T*PRsymbMag);

    case typeStyleTrace(style) of
      pointA:   point:=typePointA.create(t);
      traitA:   point:=typetraitA.create(t);
      carreA:   point:=typecarreA.create(t);

      triangleA:point:=typeTriangleA.create(t);
      DiamantA: point:=typeDiamantA.create(t);
      CercleA:  point:=typeCercleA.create(t);
      PlusA:    point:=typePlusA.create(t);
      multA:    point:=typeMultA.create(t);
      etoileA:  point:=typeEtoileA.create(t);

      HistoA:   point:=typeHistoA.create(t);

      Histo1A:  point:=typeHisto1A.create(t);
      Histo2A:  point:=typeHisto2A.create(t);
      Histo3A:  point:=typeHisto3A.create(t);

      dot1A:    point:=typeDot1A.create(t);
      dot2A:    point:=typeDot2A.create(t);

      traitCarreA:  point:=typeTraitCarreA.create(t);
      traitTriA:    point:=typeTraitTriA.create(t);
      traitDiamA:   point:=typeTraitDiamA.create(t);
      traitCercleA: point:=typeTraitCercleA.create(t);
      traitPlusA:   point:=typeTraitPlusA.create(t);
      traitMultA:   point:=typeTraitMulA.create(t);
      traitEtoileA: point:=typeTraitEtoileA.create(t);

      traitRempliA: point:=typetraitRempliA.create(t);

      PolygonA: begin
                  point:=typetraitA.create(t);
                  typetraitA(point).Fpolygon:=true;
                end;

      else      point:=typetraitA.create(t);
    end;
    styleA:=typeStyleTrace(style);
  end;

procedure Ttrace0.setColorTrace(n:longint);
  begin
    color:=n;
  end;

procedure Ttrace0.setColorTrace2(n:longint);
  begin
    color2:=n;
  end;


procedure Ttrace0.setColorEC(n:longint);
  begin
    colorEC:=n;
  end;

procedure Ttrace0.setTrait(largeur,style:integer);
  begin
    if (style>=1) and (style<=nbstyleTrait)
      then styleT:= TpenStyle(style-1)
      else styleT:=psSolid;
    largeurT:=largeur;
  end;

function Ttrace0.error:integer;
  begin
    error:=U.error;
  end;

procedure Ttrace0.afficher;
  begin
  end;

procedure Ttrace0.cadrerX;
  begin
  end;

procedure Ttrace0.cadrerY;
  begin
  end;

procedure Ttrace0.pushCadrer(var b:boolean);
  begin
  end;

function Ttrace0.Xinf:float;
  begin
    Xinf:=0;
  end;

function Ttrace0.Xsup:float;
  begin
    Xsup:=0;
  end;



Procedure Ttrace0.SaisieCoo(wnd:hwnd;Modif,FontModif:boolean);
  begin

  end;

Procedure Ttrace0.SauverASCII
              (var f:text;larchamp,deci:integer;sep:char);
  begin
  end;

function Ttrace0.identA(x:float):float;
  begin
    identA:=x;
  end;

function Ttrace0.LogA(x:float):float;
  begin
    LogA:=log10(x);
  end;



{*********************** Méthodes de TtraceTableau **********************}

constructor TtraceTableau.create(Univers:Tunivers;p:pointer);
  begin
    inherited create(univers);
    dataY:=p;
    pas:=1;
  end;

procedure TtraceTableau.setData(p:pointer);
  begin
    dataY:=p;
  end;

destructor TtraceTableau.destroy;
  begin
    inherited;
  end;

procedure TtraceTableau.setPas(n:word);
  begin
    pas:=n;
  end;

function TtraceTableau.error:integer;
  var
    i:integer;
  begin
    error:=inherited error;
  end;


function ArretDemande1:boolean;
  var
    v:integer;
  begin
    ArretDemande1:=false;
    if testEscape then
      begin
        if messageDlg('Fin de l''affichage?',mtInformation,[mbOk],0)=MRyes
          then ArretDemande1:=true;
      end;
  end;

function TtraceTableau.cvx0(i:integer):integer;
var
  modeEvt:boolean;
begin
  modeEvt:=(point.classType=typeDot1A) or (point.classType=typeDot2A);
  with U,dataY do
  if modeLogX then
    begin
      if modeEvt
        then cvx0:=convWx(log10(getE(i)))
        else cvx0:=convWx(log10(convX(i)));
    end
  else
    begin
      if modeEvt then cvx0:=convWx(getE(i))
      else cvx0:=convWx(i);
    end;
end;

function TtraceTableau.cvy0(i:integer):integer;
var
  modeEvt:boolean;
begin
  modeEvt:=(point.classType=typeDot1A) or (point.classType=typeDot2A);
  with U,dataY do
  if modeLogY then
    begin
      if modeEvt then cvy0:=convWy(0)
      else
      if SmoothF>0 then cvy0:=convWy(log10(getSmoothE(i,SmoothF)))
      else
      if SmoothF<0 then cvy0:=convWy(log10(getSmoothB(i,-SmoothF)))
      else
      cvy0:=convWy(log10(getE(i)));
    end
  else
    begin
      if modeEvt then cvy0:=convWy(0)
      else
      if SmoothF>0 then cvy0:=convWy(getSmoothE(i,SmoothF))
      else
      if SmoothF<0 then cvy0:=convWy(getSmoothB(i,-SmoothF))
      else
      cvy0:=convWy(getE(i));
    end;
end;


procedure TtraceTableau.afficherPoints(Idd,Iff:integer);
  var
    i:longint;
    Imin,Imax:longint;
    flagMax:boolean;

    k,k1:integer;

    pcol,bcol:Tcolor;
    psty:TpenStyle;
    bsty:TbrushStyle;
    pwid:integer;
    xb:float;
    ib:integer;
    modeEvt:boolean;

    nbmax:integer;

  procedure setW;
    var
      x1,x2,y1,y2:float;
    begin
      with U do
      begin
        if modeLogX then
          begin
            x1:=log10(XminA);
            x2:=log10(XmaxA);
          end
        else
        if modeEvt then
          begin
            x1:=xminA;
            x2:=xmaxA;
          end
        else
          begin
            x1:=dataY.invConvXreel(XminA);
            x2:=dataY.invConvXreel(XmaxA);
          end;

        if modeLogY then
          begin
            y1:=log10(YminA);
            y2:=log10(YmaxA);
          end
        else
        if modeEvt then
          begin
            y1:=YminA;
            y2:=YmaxA;
          end
        else
        begin
          y1:=YminA;
          y2:=YmaxA;
        end;

        if inverseXA then
          begin
            xb:=x1;
            x1:=x2;
            x2:=xb;
          end;
        if inverseYA then
          begin
            xb:=y1;
            y1:=y2;
            y2:=xb;
          end;

        Dgraphic.setWorld(x1,y1,x2,y2);

        if modeLogX
          then point.Ibase:=0
          else point.Ibase:=convWx(dataY.invConvX(0));

        if modeLogY then point.Jbase:=y2act-y1act
        else

        point.Jbase:=convWy(0);
      end;
    end;




  begin
    if error<>0 then exit;

    AbortDisplay:=false;
    modeEvt:=(point.classType=typeDot1A) or (point.classType=typeDot2A);
    with U,dataY do
    begin
      open;
      if Idd>Iff then
      begin
        close;
        exit;
      end;
      setW;

      if modeEvt then
        begin
          Imin:=Idd;
          while (Imin<Iff) and (dataY.getE(Imin+1)<XminA) do inc(Imin);
          Imax:=Iff;
          while (Imax>Idd) and (dataY.getE(Imax-1)>XmaxA) do dec(Imax);

        end
      else
        begin
          Imin:=roundL(invConvX(XminA));
          Imax:=roundL(invConvX(XmaxA));
        end;

      if Imin>Imax then
        begin
          Ib:=Imin;
          Imin:=Imax;
          Imax:=Ib;
        end;

      if cvx0(Imin)>x1act then dec(Imin);

      inc(Imax);
      if Imin<Idd then Imin:=Idd;
      if Imax>Iff then Imax:=Iff;
      if Imax<Imin then
      begin
        close;
        exit;
      end;

      i:=Imin;

      FlagMax:=(Imax-Imin>100000); { au del… de 100000 pts, on teste le
                                     clavier tous les 10000 pts }


      with canvasGlb do
      begin
        pcol:=pen.color;
        pwid:=pen.width;
        psty:=pen.style;

        bcol:=brush.color;
        bsty:=brush.style;

        pen.color:=color;
        pen.width:=largeurT;
        pen.style:=styleT;

        point.colPixel:=color;
        brush.color:=color;
        brush.style:=bsSolid;

        //brush.style:=bsClear;


      end;

      point.color2:=color2;

      {affDebug('Dtrace1.affTableau '+Istr(Imin)+'/'+Istr(Imax));}
      k:=0;

      point.Fcompact:=((Imax-Imin+1) > (x2act-x1act+1)*4);
      point.Jmini:=cvy0(iMin);
      point.Jmaxi:=point.Jmini;
      point.Jlast:=point.Jmini;

      point.PreviousI:=cvx0(Imin);

      if point.Fcompact then nbmax:=(x2act-x1act+1)*2+10 else nbmax:=Imax-Imin+1;
      if assigned(OnDisplayPoint) then OnDisplayPoint(Imin);

      canvasGlb.moveto(point.previousI,cvy0(Imin));
      point.afficherPremierPoint(point.previousI,cvy0(Imin),nbmax);

      inc(i);
      while i<=Imax do
        begin
          if ModeEffacement then
            begin
              k1:=convWx(i);
              if k1<>k then
                begin
                  lineVer(i,rgb(255,255,255),false);
                  k:=k1;
                end;
            end;
          if assigned(OnDisplayPoint) then OnDisplayPoint(i);
          point.afficher(cvx0(i),cvy0(i));
          inc(i,pas);
          if FlagMax and (i mod 10000=0) and testEscape then
            begin
              AbortDisplay:=true;
              i:=Imax+1;
            end;
        end;
      point.AfficherdernierPoint(cvx0(Imax),cvx0(Imax+1));
      close;


      with canvasGlb do
      begin
        pen.color:=pcol;
        pen.width:=pwid;
        pen.style:=psty;

        brush.color:=bcol;
        brush.style:=bsty;
      end;

    end;
    {affDebug('Dtrace1 BKcolor='+Istr(intG(canvasGlb.brush.color)));}
  end;

procedure TtraceTableau.afficher;
begin
  with dataY do afficherPoints(indiceMin,indiceMax);
end;

function ArretDemande:boolean;
  var
    v:integer;
  begin
  end;

procedure TtraceTableau.cadrerX;
  begin
    with U,dataY do limitesX(XminA,XmaxA);
  end;


procedure TtraceTableau.cadrerY;
  begin
    with U,dataY do limitesY(YminA,YmaxA,0,0);
  end;

Procedure TtraceTableau.SauverASCII
  (var f:text;larchamp,deci:integer;sep:char);
  var
    Imin,Imax,i:longint;
    st:AnsiString;

  begin
    if error<>0 then exit;
    with U,dataY do
    begin
      if Indicemin>IndiceMax then exit;

      Imin:=roundL(invConvX(XminA));
      Imax:=roundL(invConvX(XmaxA));
      if Imin>invConvX(XminA) then dec(Imin);
      if Imax<invConvX(XmaxA) then inc(Imax);
      if Imin<indiceMin then Imin:=indiceMin;
      if Imax>indiceMax then Imax:=indiceMax;

      i:=Imin;

      while i<=Imax do
        begin
          st:=Estr1(convX(i),larchamp,deci)+sep
             +Estr1(getE(i),larchamp,deci);
          writeln(f,st);
          inc(i,pas);
        end;
    end;

  end;

{*********************** Méthodes de TtraceTableauDouble ****************}

constructor TtraceTableauDouble.create(Univers:Tunivers;px,py,ps:pointer);
  begin
    inherited create(Univers,py);
    dataX:=px;
    dataSig:=ps;
    IminG:=dataX.IndiceMin;
    ImaxG:=dataX.IndiceMax;
  end;

procedure TtraceTableauDouble.setIminImax(i1,i2:longint);
  begin
    IminG:=i1;
    ImaxG:=i2;
  end;


procedure TtraceTableauDouble.setData(px,py,ps:pointer);
  begin
    dataX:=px;
    dataY:=py;
    dataSig:=ps;
  end;

destructor TtraceTableauDouble.destroy;
  begin
    inherited;
  end;

function TtraceTableauDouble.error:integer;
  var
    i:integer;
  begin
    error:=inherited error;
  end;

procedure TtraceTableauDouble.afficher;
  var
    ix,iy:longint;
    x0:integer;
    yb,yh:float;

    pcol,bcol:Tcolor;
    psty:TpenStyle;
    bsty:TbrushStyle;
    pwid:integer;

  procedure setBase;
    begin
      with U do
      begin
        if modeLogx then point.Ibase:=x2act-x1act
        else point.Ibase:=convWx(0);

        if modeLogY then point.Jbase:=y2act-y1act
        else point.Jbase:=convWy(0);
      end;
    end;


  procedure setW;
    var
      x1,x2,y1,y2:float;
      xb:float;
    begin
      with U do
      begin
        if modeLogx then
          begin
            x1:=log10(xminA);
            x2:=log10(xmaxA);
          end
        else
          begin
            x1:=xminA;
            x2:=xmaxA;
          end;

        if modeLogY then
          begin
            y1:=log10(YminA);
            y2:=log10(YmaxA);
          end
        else
          begin
            y1:=YminA;
            y2:=YmaxA;
          end;

        if inverseXA then
          begin
            xb:=x1;
            x1:=x2;
            x2:=xb;
          end;
        if inverseYA then
          begin
            xb:=y1;
            y1:=y2;
            y2:=xb;
          end;

        Dgraphic.setWorld(x1,y1,x2,y2);
      end;
      setBase;
    end;

    function cvx0(i:integer):integer;
      begin
        {result:=10;}

        with U,dataX do
        if modeLogX then cvx0:=convWx(log10(getE(i)))
        else cvx0:=convWx(getE(i));
      end;

    function cvy0(i:integer):integer;
      begin
        {result:=10;}

        with U,dataY do
        if modeLogY then cvy0:=convWy(log10(getE(i)))
        else cvy0:=convWy(getE(i));
      end;



  begin
    if (dataX.Indicemin>DataX.IndiceMax) or
       (dataY.Indicemin>DataY.IndiceMax) or
       (error<>0) then exit;

    point.Fcompact:=false;

    setW;

    {On ne prend que les indices en coïncidence }
    if IminG<dataX.indiceMin  then IminG:=dataX.indiceMin;
    if IminG<dataY.indiceMin  then IminG:=dataY.indiceMin;
    if ImaxG>dataX.indiceMax  then ImaxG:=dataX.indiceMax;
    if ImaxG>dataY.indiceMax  then ImaxG:=dataY.indiceMax;

    if ImaxG<IminG then exit;

    ix:=IminG;
    iy:=IminG {+dataY.IndiceMin-dataX.IndiceMin};


    with canvasGlb do
    begin
      pcol:=pen.color;
      pwid:=pen.width;
      psty:=pen.style;

      bcol:=brush.color;
      bsty:=brush.style;

      pen.color:=color;
      pen.width:=largeurT;
      pen.style:=styleT;

      point.colPixel:=color;
      brush.color:=color;
      brush.style:=bsSolid;

      if ix<=ImaxG then moveto(cvx0(ix),cvy0(iy));
    end;

    point.color2:=color2;


    point.AfficherPremierPoint(cvx0(ix),cvy0(iy),ImaxG-IminG+1);

    while ix<=ImaxG do
      begin
        if dataSig<>nil then
          begin
            canvasGlb.pen.color:=colorEC;

            x0:=cvx0(ix);
            yh:=dataY.getE(iy)+dataSig.getE(iy);
            yb:=dataY.getE(iy)-dataSig.getE(iy);

            if not U.modeLogY then
              begin
                 canvasGlb.moveto(x0,convWy(yb));
                 canvasGlb.lineto(x0,convWy(yh));
              end
            else
              begin
                canvasGlb.moveto(x0,convWy(log10(yb)));
                canvasGlb.lineto(x0,convWy(log10(yh)));
              end;
            canvasGlb.pen.color:=color;
          end;
        if assigned(OnDisplayPoint) then OnDisplayPoint(ix);
        point.afficher(cvx0(ix),cvy0(iy));
        {affdebug(Estr1(dataX^.getE(ix),10,3)+'   '+Estr1(dataY^.getE(iy),10,3));}
        inc(ix,pas);
        inc(iy,pas);
      end;

    point.AfficherdernierPoint(cvx0(imaxG),cvx0(imaxG));
    {affdebug('=======================================');}


    with canvasGlb do
    begin
      pen.color:=pcol;
      pen.width:=pwid;
      pen.style:=psty;

      brush.color:=bcol;
      brush.style:=bsty;
    end;

  end;

procedure TtraceTableauDouble.cadrerX;
  begin
    with U,dataX do limitesY(XminA,XmaxA,0,0);
  end;


procedure TtraceTableauDouble.cadrerY;
  begin
    with U,dataY do limitesY(YminA,YmaxA,0,0);
  end;

Procedure TtraceTableauDouble.SauverASCII
  (var f:text;larchamp,deci:integer;sep:char);
  var
    Imin,Imax,i:longint;
    st:AnsiString;

  begin
     if (dataX.Indicemin>DataX.IndiceMax) or
       (dataY.Indicemin>DataY.IndiceMax) or
       (error<>0) then exit;

    with U do
    begin
      Imin:=roundL(dataX.invConvX(XminA));
      Imax:=roundL(dataX.invConvX(XmaxA));

      i:=Imin;

      while i<=Imax do
        begin
          st:=Estr1(dataX.getE(i),larchamp,deci)+sep
             +Estr1(dataY.getE(i),larchamp,deci);
          writeln(f,st);
          inc(i,pas);
        end;
    end;

  end;

{*********************** Méthodes de TtraceFonction *********************}




constructor TtraceFonction.create(Univers:Tunivers);
  begin
    inherited create(Univers);
    getX:=identA;
    getY:=identA;
    m1:=0;
    m2:=0;
    nbPt:=1;
    nbError0:=0;
  end;

procedure TtraceFonction.setFonction(gX,gY:typeFonctionEE;
                                        v1,v2:float;nb:integer);
  begin
    getX:=gX;
    getY:=gY;

    if v1<v2 then
      begin
        m1:=v1;
        m2:=v2;
      end
    else
      begin
        m1:=v2;
        m2:=v1;
      end;
    nbPt:=nb;
    nbError0:=0;
  end;

destructor TtraceFonction.destroy;
  begin
    inherited;
  end;

function TtraceFonction.error:integer;
  var
    i:integer;
  begin
    i:= inherited error;
    if i=0 then
      if (@getX=nil) or (@getY=nil) or (nbPt<1) then i:=20;
    error:=i;
  end;

function TtraceFonction.nbError:integer;
  begin
    nbError:=nbError0;
  end;


procedure TtraceFonction.afficher;
  var
    i:integer;
    v,v1,v2,delta:float;
    vnext:float;
    fLogX,fLogY:typeFonctionEE;
    SAerror:boolean;
    dum:typeFonctionEE;

    pcol,bcol:Tcolor;
    psty:TpenStyle;
    bsty:TbrushStyle;
    pwid:integer;


    procedure Afp;
      begin
        try
          SAError:=false;
          
          Point.afficher(convWx(fLogX(getX(v))),convWy(fLogY(getY(v))));
          {canvasGlb.lineto(convWx(fLogX(getX(v))),convWy(fLogY(getY(v))));}
          {affdebug(Istr(convWx(fLogX(getX(v))))+'  '+Istr(convWy(fLogY(getY(v)))));}
        except
          inc(nbError0);
          SAError:=true;
        end;;

      end;

    procedure mvt;
      begin
        try
          SAError:=false;
          canvasGlb.moveto(convWx(fLogX(getX(v))),convWy(fLogY(getY(v))));

        except
          inc(nbError0);
          SAError:=true;
        end;
      end;

  begin
    if error<>0 then exit;
    point.Fcompact:=false;
    with U do
    begin
      nbError0:=0;
      if modeLogX then fLogX:=logA
                  else fLogX:=identA;
      if modeLogY then fLogY:=logA
                  else fLogY:=identA;

      v1:=m1;v2:=m2;
      dum:=identA;
      {
      if @getX=@dum then
        begin
          if v1<XminA then v1:=XminA;
          if v2>XmaxA then v2:=XmaxA;
        end;
      if @getY=@dum then
        begin
          if v1<YminA then v1:=YminA;
          if v2>YmaxA then v2:=YmaxA;
        end;
       }
      Dgraphic.setWorld(fLogX(XminA),fLogY(YminA),fLogX(XmaxA),fLogY(YmaxA));

      if modeLogX or modeLogY
        then delta:=exp(ln(v2/v1)/nbPt)
        else delta:=(v2-v1)/nbPt;


      v:=v1;
      mvt;

      with canvasGlb do
      begin
        pcol:=pen.color;
        pwid:=pen.width;
        psty:=pen.style;

        bcol:=brush.color;
        bsty:=brush.style;


        pen.color:=color;
        pen.width:=largeurT;
        pen.style:=styleT;

        point.colPixel:=color;
        brush.color:=color;
        brush.style:=bsSolid;

      end;

      point.color2:=color2;

      SAerror:=false;

      point.Fcompact:=false;

      point.afficherPremierPoint(convWx(fLogX(getX(v))),convWy(fLogY(getY(v))),nbpt);
      if modeLogX or modeLogY
            then v:=v*delta
            else v:=v+delta;

      while v<v2 do
        begin
          if not SAerror then afp
                         else mvt;
          if modeLogX or modeLogY
            then v:=v*delta
            else v:=v+delta;
        end;

      if modeLogX or modeLogY
      then vnext:=v*delta
      else vnext:=v+delta;

      point.afficherDernierPoint(convWx(fLogX(getX(v))),convWx(fLogX(getX(vnext))) );

    end;

    with canvasGlb do
    begin
      pen.color:=pcol;
      pen.width:=pwid;
      pen.style:=psty;

      brush.color:=bcol;
      brush.style:=bsty;
    end;


  end;

Procedure TtraceFonction.SauverASCII
  (var f:text;larchamp,deci:integer;sep:char);
  begin
  end;

{*********************** Méthodes de TtraceEv *************************}

constructor TtraceEv.create(Univers:Tunivers;p:pointer;voie1:integer);
  begin
    inherited create(Univers);
    data:=p;
    voie:=voie1;
    {messageCentral('TtraceEv');}
  end;

procedure TtraceEv.setData(p:pointer);
  begin
    data:=p;
  end;

destructor TtraceEv.destroy;
  begin
    inherited;
  end;

function TtraceEv.error:integer;
  begin
    error:=inherited error;
  end;


procedure TtraceEv.afficher;
  var
    i:longint;
    Imin,Imax:longint;
    FlagMax:boolean;
    x:float;

    pcol,bcol:Tcolor;
    psty:TpenStyle;
    bsty:TbrushStyle;
    pwid:integer;


  procedure setW;
    begin
      with U do
      begin
        Dgraphic.setWorld(xminA,yminA,xmaxA,ymaxA);

        point.Ibase:=convWx(0);

        point.Jbase:=convWy(0);
      end;
    end;

  begin
    point.Fcompact:=false;

    if error<>0 then exit;
    with U,data do
    begin
      setMask(voie);
      
      if Indicemin>IndiceMax then exit;

      open;
      setW;

      Imin:=roundL(invConvX(XminA));
      Imax:=roundL(invConvX(XmaxA));


      if Imin>invConvX(XminA) then dec(Imin);
      if Imax<invConvX(XmaxA) then inc(Imax);
      if Imin<indiceMin then Imin:=indiceMin;
      if Imax>indiceMax then Imax:=indiceMax;

      with canvasGlb do
      begin
        pcol:=pen.color;
        pwid:=pen.width;
        psty:=pen.style;

        bcol:=brush.color;
        bsty:=brush.style;
      end;

      with canvasGlb do
      begin
        pen.color:=color;
        pen.width:=largeurT;
        pen.style:=styleT;

        point.colPixel:=color;
        brush.color:=color;
        brush.style:=bsSolid;
      end;


      i:=data.getFirst(XminA);

      x:=data.getE(i);
      canvasGlb.moveto(convWx(x),point.Jbase);

      while (i<=indiceMax) and (x<U.XmaxA) do
        begin
          if x<>0 then point.afficher(convWx(x),point.Jbase);
          inc(i);
          x:=data.getE(i);
        end;

      close;
    end;

    with canvasGlb do
    begin
      pen.color:=pcol;
      pen.width:=pwid;
      pen.style:=psty;

      brush.color:=bcol;
      brush.style:=bsty;
    end;

  end;


procedure displaySymbol(numSymb:typeStyleTrace;taille,color:integer;x,y:float);
var
  point:typePointA;
begin
  with canvasGlb do
  begin
    pen.color:=color;
    brush.color:=color;
  end;
  if PRprinting then Taille:=round(Taille*PRsymbMag);

  case typeStyleTrace(numSymb) of
    pointA:   point:=TypePointA.create(taille);
    traitA:   point:=TypetraitA.create(taille);
    carreA:   point:=TypecarreA.create(taille);
    triangleA:point:=TypeTriangleA.create(taille);
    DiamantA: point:=TypeDiamantA.create(taille);
    CercleA:  point:=TypeCercleA.create(taille);
    PlusA:    point:=TypePlusA.create(taille);
    multA:    point:=TypeMultA.create(taille);
    etoileA:  point:=TypeEtoileA.create(taille);
    HistoA:   point:=TypeHistoA.create(taille);
    Histo1A:  point:=TypeHisto1A.create(taille);
    Histo2A:  point:=TypeHisto2A.create(taille);
    dot1A:    point:=Typedot1A.create(taille);
    else exit;
  end;
  point.afficher(convWx(x),convWy(y));
  point.free;
end;

end.

