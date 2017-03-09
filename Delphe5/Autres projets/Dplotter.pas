unit Dplotter;

INTERFACE
uses util1,Gdos;

const
  Ptrame:integer=4;

  Protation:boolean=false;

  PlargeurPlume:real=0;


procedure PInit(st:string);
procedure PReset;

procedure Pworld(x1,y1,x2,y2:float);
procedure PWindow(x1,y1,x2,y2:integer;clip:boolean);

procedure Pmove(x,y:float);
procedure PmoveR(x,y:float);

procedure Pdraw(x,y:float);
procedure Ppoint(x,y:float);

procedure PPlume(n:integer);
procedure PpenUP;
procedure PpenDW;

procedure PRectangle(x1,y1,x2,y2:float);

procedure PtailleCarR(x,y:float);
procedure PtailleCarA(x,y:float);  { x et y en centimŠtres }
procedure Plabel(st:string);
procedure PTexteVertical;
procedure PTexteHorizontal;

procedure PsymbTriangle(x,y:float;d:float);   { d en millimŠtres }
procedure PsymbCarre(x,y:float;d:float);      { d est la dimension  }
procedure PsymbCercle(x,y:float;d:float);     { maximale d'un symbole }

procedure PsymbPlus(x,y:float;d:float);
procedure PsymbMult(x,y:float;d:float);
procedure PsymbEtoile(x,y:float;d:float);
procedure PsymbDiamant(x,y:float;d:float);

procedure PgetWorld(var x1,y1,x2,y2:float);
procedure Pgraduations
  (var uX,uY;cx,cy:float;complet,LogV,LogH,echV,echH,ext:boolean);

procedure PgraduationsHOR
   (var ux;cx,cy:float;complet,LogH,echH,ext:boolean);
procedure PgraduationsVER
   (var uy;cx,cy:float;complet,LogV,echV:boolean);

procedure Pborder;
procedure PhalfBorder;
procedure PtraceHistoAmp(var Hist;X0,dX:float;mode:integer;t:typeType);
procedure PtraceTableau(var tab;t:typeType);
                                    {le world est ‚tabli en coo. tableau}
                                    {le tableau commence … 0:           }
                                    {             array[0..n] of ...    }
procedure Plegende(x,y,h,l:float;vertical,centrage:boolean;st:string);

procedure PpaperSize(n:integer); { n=3 ou 4 pour A3 A4 }
procedure Pspeed(n:integer); { n=1 … 38 en cm/s. Si n=0, vitesse par d‚faut }
                             {                             38.1 cm/s sur HP }

procedure PlotHisto0(x1,y1,x2,y2:float);
  { Trace un rectangle d'histogramme noirci en utilisant Ptrame }
procedure PlotHisto1(x1,y1,x2,y2:float);
  { Trace un rectangle d'histogramme vide sans la partie inf‚rieure }
procedure PlotHisto2(x1,y1,x2,y2:float);
  { Trace un rectangle d'histogramme avec uniquement le contour sup‚rieur }


procedure StandardFontDefinition(SymbolSet:integer;b1:boolean;
                                 FontSpacing:integer;b2:boolean;
                                 Pitch:real;b3:boolean;
                                 Height:real;b4:boolean;
                                 Posture:integer;b5:boolean;
                                 StrokeWeight:integer;b6:boolean;
                                 TypeFace:integer;b7:boolean);

procedure PPenWidth(x:float);

IMPLEMENTATION

type st20=string[20];

var
  x:float;
  Plt:text;
  x1act,y1act,x2act,y2act:integer;
  xW1,yW1,xW2,yW2:float;
  clip0:boolean;


function cr(x:float):st20;
  var
    st:st20;
  begin
    str(x:20:4,st);
    supespace(st);
    if pos('.',st)<>0 then
      while st[length(st)]='0' do delete(st,length(st),1);
    if st[length(st)]='.' then delete(st,length(st),1);
    cr:=st;
  end;

function convWx(x:float):integer;
  begin
    convWx:=roundL(x1act+(x-xW1)*(x2act-x1act)/(xW2-xW1)) ;
  end;

function convWy(y:float):integer;
  begin
    convWy:=roundL(y1act+ (y-yW1)*(y2act-y1act)/(yW2-yW1)) ;
  end;


procedure PInit(st:string);
  var
    i:integer;
  begin
    x1act:=0;x2act:=15000;y1act:=0;y2act:=10000;
    xW1:=0;xW2:=15000;yW1:=0;yW2:=10000;
    clip0:=false;

    assign(plt,st);
    GrewriteT(plt);

    if Protation then GwriteT(plt,'IN;RO90;IP;IW;SC')
                 else GwriteT(plt,'IN;IP;IW;SC');

    if PlargeurPlume>0 then GwriteT(plt,'PW'+Estr(PlargeurPlume,2)+';');

  end;

procedure PReset;
  begin
    GwriteT(plt,'SP0;IP;');
    GcloseT(plt);
  end;

procedure PPenWidth(x:float);
  begin
    if x>0 then
      begin
        PlargeurPlume:=x;
        GwriteT(plt,'PW'+Estr(PlargeurPlume,2)+';');
      end;
  end;


procedure Pwindow(x1,y1,x2,y2:integer;clip:boolean);
  begin
    x1act:=x1;
    y1act:=y1;
    x2act:=x2;
    y2act:=y2;
    clip0:=clip;
    if clip then
      GwriteT(plt,'IW'+Istr(x1)+','+Istr(y1)+','+Istr(x2)+','+Istr(y2)+';')
    else
      GwriteT(plt,'IW;');
  end;

procedure Pworld(x1,y1,x2,y2:float);
  begin
    if (x1=x2) or (y1=y2) then exit;
    xW1:=x1;
    yW1:=y1;
    xW2:=x2;
    yW2:=y2;
  end;

procedure Pmove(x,y:float);
  begin
    GwriteT(plt,'PUPA'+Istr(convWx(x))+','+Istr(convWy(y))+';');
  end;

procedure PmoveR(x,y:float);
  begin
    GwriteT(plt,'PUPR'+Istr(convWx(xW1+x)-x1act)+','+Istr(convWy(yW1+y)-y1act)+';');
  end;


procedure Pdraw(x,y:float);
  begin
    GwriteT(plt,'PDPA'+Istr(convWx(x))+','+Istr(convWy(y))+';');
  end;

procedure Ppoint(x,y:float);
  begin
    GwriteT(plt,'PUPA'+Istr(convWx(x))+','+Istr(convWy(y))+';PD;');
  end;

procedure PRectangle(x1,y1,x2,y2:float);
  begin
    GwriteT(plt,'PUPA'+Istr(convWx(x1))+','+Istr(convWy(y1))+'PD'+
              Istr(convWx(x2))+','+Istr(convWy(y1))+','+
              Istr(convWx(x2))+','+Istr(convWy(y2))+','+
              Istr(convWx(x1))+','+Istr(convWy(y2))+','+
              Istr(convWx(x1))+','+Istr(convWy(y1))+';');
  end;


procedure PPlume(n:integer);
  begin
    GwriteT(plt,'SP'+Istr(n)+';');
  end;


procedure PpenUP;
  begin
    GwriteT(plt,'PU;');
  end;

procedure PpenDW;
  begin
    GwriteT(plt,'PD;');
  end;

procedure PtailleCarR(x,y:float);
  begin
    GwriteT(plt,'SI'+cr(abs(x2act-x1act)*x/40000)+','+
                   cr(abs(y2act-y1act)*y/40000)+';');
  end;

procedure PtailleCarA(x,y:float);
  begin
    GwriteT(plt,'SI'+cr(x)+','+cr(y)+';');
  end;

procedure Plabel(st:string);
  begin
    GwriteT(plt,'LB'+st+#3+';');
  end;

procedure PTexteVertical;
  begin
    GwriteT(plt,'DI0,1;');
  end;

procedure PTexteHorizontal;
  begin
    GwriteT(plt,'DI;');
  end;

procedure PsymbTriangle(x,y:float;d:float);
  var
    i,j,a,h:integer;
  begin
    d:=d*10;
    if not ( (xw1<=x) and (x<=xW2) OR (xw2<=x) and (x<=xw1) )
       or
       not ( (yw1<=y) and (y<=yW2) OR (yw2<=y) and (y<=yw1) )
       then exit;
    i:=convWx(x);
    j:=convWy(y);
    a:=trunc(d*2);
    h:=trunc(d*4/3);
    GwriteT(plt,'PUPA'+Istr(i-a)  +','+Istr( j-h)+  ';'+
                'PD'+Istr(i+a)+','+Istr(j-h)+ ','
                    +Istr(i) +',' +Istr(j+2*h)+ ','
                    +Istr(i-a) +',' +Istr(j-h) + ';');
  end;

procedure PsymbCarre(x,y:float;d:float);
  var
    i,j,a:integer;
  begin
    d:=d*10;
    if not ( (xw1<=x) and (x<=xW2) OR (xw2<=x) and (x<=xw1) )
       or
       not ( (yw1<=y) and (y<=yW2) OR (yw2<=y) and (y<=yw1) )
       then exit;
    i:=convWx(x);
    j:=convWy(y);
    a:=trunc(d*2);
    GwriteT(plt,'PUPA'+Istr(i-a)+','+Istr(j-a)+  ';'+
              'PD'+Istr(i+a)+','+Istr(j-a)+ ','+
                   Istr(i+a)+','+Istr(j+a)+','+
                   Istr(i-a)+','+Istr(j+a)+','+
                   Istr(i-a)+','+Istr(j-a)+';');
  end;


procedure PsymbDiamant(x,y:float;d:float);
  var
    i,j,a:integer;
  begin
    d:=d*10;
    if not ( (xw1<=x) and (x<=xW2) OR (xw2<=x) and (x<=xw1) )
       or
       not ( (yw1<=y) and (y<=yW2) OR (yw2<=y) and (y<=yw1) )
       then exit;
    i:=convWx(x);
    j:=convWy(y);
    a:=trunc(d*2);
    GwriteT(plt,'PUPA'+Istr(i-a)+ ','+Istr(j)  +  ';'+
              'PD' +Istr(i)+   ',' +Istr(j-a)+  ','
                   +Istr(i+a)+ ',' +Istr(j) +  ','
                   +Istr(i)  + ',' +Istr(j+a)+ ','
                   +Istr(i-a)+ ',' +Istr(j)+  ';');
  end;


procedure PsymbEtoile(x,y:float;d:float);
  var
    i,j,k:integer;
  begin
    d:=d*10;
    if not ( (xw1<=x) and (x<=xW2) OR (xw2<=x) and (x<=xw1) )
       or
       not ( (yw1<=y) and (y<=yW2) OR (yw2<=y) and (y<=yw1) )
       then exit;
    i:=convWx(x);
    j:=convWy(y);

    for k:=0 to 2 do
      begin
         GwriteT(plt,'PUPA'+Istr(i+trunc(d*cos(k*Pi/3)*2)) +','+
                          Istr(j+trunc(d*sin(k*Pi/3)*2))+';'+
                     'PD'+Istr(i+trunc(d*cos(Pi+k*Pi/3)*2))+','+
                          Istr(j+trunc(d*sin(Pi+k*Pi/3)*2))+';');
      end;
  end;


procedure PsymbCercle(x,y:float;d:float);
  var
    i,j,a:integer;
  begin
    d:=d*10;
    if not ( (xw1<=x) and (x<=xW2) OR (xw2<=x) and (x<=xw1) )
       or
       not ( (yw1<=y) and (y<=yW2) OR (yw2<=y) and (y<=yw1) )
       then exit;
    i:=convWx(x);
    j:=convWy(y);
    a:=trunc(d*2);
    GwriteT(plt,'PUPA'+Istr(i)+','+Istr(j)+  ';'+
                'CI'+Istr(a)+','+Istr(30)+  ';');
  end;

procedure PsymbPlus(x,y:float;d:float);
  var
    i,j,a:integer;
  begin
    d:=d*10;
    if not ( (xw1<=x) and (x<=xW2) OR (xw2<=x) and (x<=xw1) )
       or
       not ( (yw1<=y) and (y<=yW2) OR (yw2<=y) and (y<=yw1) )
       then exit;
    i:=convWx(x);
    j:=convWy(y);
    a:=trunc(d*2);
    GwriteT(plt,'PUPA'+Istr(i-a) +','+Istr(j)+ ';'+
              'PD'+Istr(i+a) +','+Istr(j) +  ';'+
              'PU'+Istr(i)+  ',' +Istr(j+a)+  ';'+
              'PD'+Istr(i)+  ',' +Istr(j-a)+  ';');
  end;

procedure PsymbMult(x,y:float;d:float);
  var
    i,j,a:integer;
  begin
    d:=d*10;
    if not ( (xw1<=x) and (x<=xW2) OR (xw2<=x) and (x<=xw1) )
       or
       not ( (yw1<=y) and (y<=yW2) OR (yw2<=y) and (y<=yw1) )
       then exit;
    i:=convWx(x);
    j:=convWy(y);
    a:=trunc(d*2);
    GwriteT(plt,'PUPA'+Istr(i-a)+','+Istr(j-a)+  ';'+
                'PD'  +Istr(i+a)+','+Istr( j+a)+ ';'+
                'PU'  +Istr(i-a)+','+Istr(j+a)+ ';'+
                'PD'  +Istr(i+a)+','+Istr(j-a)+ ';');
  end;



procedure PgetWorld(var x1,y1,x2,y2:float);
  begin
    x1:=xW1;
    x2:=xW2;
    y1:=yW1;
    y2:=yW2;
  end;

procedure PgraduationsHOR
   (var uX;cx,cy:float;complet,LogH,echH,Ext:boolean);
  var
      a,dv,dx,dy:float;
      i,j,c,k:integer;
      fl,f:boolean;
      st:string;
      lmax:integer;

      unitX:string ABSOLUTE ux;

      tabTick:typeTabTick;
      Nbtick:integer;

      xW1a,xW2a,yW1a,yW2a:float;
      clip:boolean;
      DeltaY:float;

    begin        { of PgraduationsHOR }
      if (xW1>=xW2) or  LogH and (xW1<=0) then exit;

      Xw1a:=xW1;
      Xw2a:=xW2;
      Yw1a:=yW1;
      Yw2a:=yW2;

      clip:=clip0;
      Pwindow(x1act,y1act,x2act,y2act,false);
      PtaillecarR(cx,cy);

      if LogH then
        begin
          Pworld(log10(xW1a),0,log10(xW2a),100);
          tickLog(xW1a,xW2a,NbTick,tabTick);
          dx:=(xW2-xW1)/100;
          dy:=1;
          if Ext then DeltaY:=-1.5*cy-dy
                 else DeltaY:=-1.5*cy;
          c:=0;
          for i:=1 to Nbtick do
            begin
              a:=log10(tabTick[i].w);
              Pmove(a,0);
              if not Ext then Pdraw(a,dy)
                         else Pdraw(a,-dy);

              if tabTick[i].aff and echH then
                begin
                  st:=chaineGrad(tabTick[i].w);
                  Pmove(a-(length(st) div 2)*cx*dx,DeltaY);
                  if c=0 then
                    begin
                      st:=' '+st+' '+unitX;
                      for j:=1 to length(unitX) do st:=' '+st;
                    end;
                  Plabel(st);
                end;
              inc(c);
            end;

          if complet then
            for i:=1 to Nbtick do
              begin
                a:=log10(tabTick[i].w);
                Pmove(a,100);Pdraw(a,100-dy);
              end;
        end
      else
        begin
          Pworld(xW1a,0,xW2a,100);
          dv:=division(xW2-xW1);
          dx:=(xW2-xW1)/100;
          dy:=1;
          if Ext then DeltaY:=-1.5*cy-dy
                 else DeltaY:=-1.5*cy;
          a:=dv*trunc(xW1/dv);
          if a<xW1 then a:=a+dv;

          lmax:=0;
          while a<xW2 do
            begin
              if length(chainegrad(a))>lmax then lmax:=length(chainegrad(a));
              a:=a+dv;
            end;
          f:=(lmax*cx*dx*1.5<dv/3);

          a:=dv*trunc(xW1/dv);
          if a<xW1 then a:=a+dv;
          c:=0;
          while a<xW2 do
            begin
              Pmove(a,0);
              if Ext then Pdraw(a,-dy)
                     else Pdraw(a,dy);
              if echH and  ((c mod 2=0) or f) then
                begin
                  Pmove(a-cx*dx,DeltaY);
                  st:=chainegrad(a);
                  Plabel(st);
                end;
              if echH and (c=0) then
                begin
                  Plabel(' ');
                  Plabel(unitX);
                end;
              a:=a+dv;
              inc(c);
            end;

          if complet then
            begin
              a:=dv*trunc(xW1/dv);
              if a<xW1 then a:=a+dv;
              while a<xW2 do
                begin
                  Pmove(a,100);Pdraw(a,100-dy);
                  a:=a+dv;
                end;
            end;
        end;

      Pwindow(x1act,y1act,x2act,y2act,clip);
      Pworld(xW1a,yW1a,xW2a,yW2a);
    end;         { of PgraduationsHOR }




procedure PgraduationsVER
   (var uy;cx,cy:float;complet,LogV,echV:boolean);
  var
      a,dv,dx,dy:float;
      i,c,k:integer;
      fl,f:boolean;
      st:string;
      lmax:integer;

      unitY:string ABSOLUTE uy;

      tabTick:typeTabTick;
      Nbtick:integer;

      xW1a,xW2a,yW1a,yW2a:float;
      clip:boolean;

    begin        { of PgraduationsVER }
      if (yW1>=yW2) or LogV and (yW1<=0) then exit;

      Xw1a:=xW1;
      Xw2a:=xW2;
      Yw1a:=yW1;
      Yw2a:=yW2;

      clip:=clip0;
      Pwindow(x1act,y1act,x2act,y2act,false);
      PtaillecarR(cx,cy);

      if LogV then
        begin
          Pworld(0,log10(Yw1a),100,log10(Yw2a));
          tickLog(Yw1a,Yw2a,NbTick,TabTick);
          dx:=1;
          dy:=(Yw2-Yw1)/100;
          c:=0;
          for i:=1 to NbTick do
            begin
              a:=log10(tabTick[i].w);
              Pmove(0,a);Pdraw(dx,a);
              if tabTick[i].aff and echV then
                begin
                  st:=chainegrad(tabTick[i].w);
                  Pmove(xW1-cx*dx*1.5*length(st),a-cy*dy/2);
                  Plabel(st);
                end;
              if echV and (c=0) then
                begin
                  PmoveR(-dx*1.5*(length(unitY)+1),dy*5);
                  Plabel(' ');
                  Plabel(unitY);
                end;
              inc(c);
            end;

          if complet then
            for i:=1 to NbTick do
              begin
                a:=log10(tabTick[i].w);
                Pmove(100,a);Pdraw(100-dx,a);
              end;

        end
      else
        begin
          Pworld(0,yW1a,100,yW2a);
          dx:=1;
          dy:=(Yw2-Yw1)/100;
          dv:=division(Yw2-Yw1);

          a:=dv*trunc(Yw1/dv);
          if a<Yw1 then a:=a+dv;
          c:=0;
          f:=( abs( (Yw1-Yw2)/dv )<6 );
          while a<Yw2 do
            begin
              Pmove(0,a);Pdraw(dx,a);
              if echV and  ((c mod 2=0) or f) then
                begin
                  st:=chainegrad(a);
                  Pmove(xW1-cx*dx*1.5*length(st),a-cy*dy/2);
                  Plabel(st);
                end;
              if echV and (c=0) then
                begin
                  PmoveR(-dx*1.5*(length(unitY)+1),dy*5);
                  Plabel(' ');
                  Plabel(unitY);
                end;
              a:=a+dv;
              inc(c);
            end;

          if complet then
            begin
              a:=dv*trunc(Yw1/dv);
              if a<Yw1 then a:=a+dv;
              while a<Yw2 do
                begin
                  Pmove(100,a);Pdraw(100-dx,a);
                  a:=a+dv;
                end;
            end;

        end;
      Pwindow(x1act,y1act,x2act,y2act,clip);
      Pworld(xW1a,yW1a,xW2a,yW2a);
    end;         { of PgraduationsVER }


procedure Pgraduations
   (var ux,uY;cx,cy:float;complet,LogV,LogH,echV,echH,ext:boolean);
  begin
    PgraduationsHOR(ux,cx,cy,complet,LogH,echH,ext);
    PgraduationsVER(uy,cx,cy,complet,LogV,echV);
  end;

procedure Pborder;
  begin
    Prectangle(xW1,yW1,xW2,yW2);
  end;

procedure PHalfBorder;
  begin
    GwriteT(plt,'PUPA'+Istr(convWx(xW1))+','+Istr(convWy(yW2))+'PD'+
              Istr(convWx(xW1))+','+Istr(convWy(yW1))+','+
              Istr(convWx(xW2))+','+Istr(convWy(yW1))+';');
  end;

procedure PlotHisto1(x1,y1,x2,y2:float);
  var
    i1,j1,i2,j2:integer;
  begin
    i1:=convWx(x1);
    i2:=convWx(x2);
    j1:=convWy(y1);
    j2:=convWy(y2);
    GwriteT(plt,'PDPA'+Istr(i1)+','+Istr(j2)+','+        { monter }
                   Istr(i2)+','+Istr(j2)+','+        { à droite }
                   Istr(i2)+','+Istr(j1)+';');       { descendre }
  end;

procedure PlotHisto2(x1,y1,x2,y2:float);
  var
    i1,j1,i2,j2:integer;
  begin
    i1:=convWx(x1);
    i2:=convWx(x2);
    j1:=convWy(y1);
    j2:=convWy(y2);
    GwriteT(plt,'PDPA'+Istr(i1)+','+Istr(j2)+','+         { monter ou descendre }
                   Istr(i2)+','+Istr(j2)+';');        { … droite }
  end;

procedure PlotHisto0(x1,y1,x2,y2:float);
  var
    i1,j1,i2,j2:integer;
    i:integer;
  begin
    i1:=convWx(x1);
    i2:=convWx(x2);
    j1:=convWy(y1);
    j2:=convWy(y2);
    i:=i1;
    while i+Ptrame<=i2 do
      begin
        GwriteT(plt,'PDPA'+Istr(i)+','+Istr(j2)+','+           { monter }
                       Istr(i)+Istr(Ptrame)+','+Istr(j2)+','+  { à droite }
                       Istr(i+Ptrame)+','+Istr(j1)+';');       { descendre }
        inc(i,Ptrame);
      end;
  end;


procedure PtraceHistoAmp(var Hist;X0,dX:float;mode:integer;t:typeType);
  var
    tabO:array[0..64000] of byte    ABSOLUTE hist;
    tabE:array[0..32000] of integer ABSOLUTE hist;
    tabL:array[0..16000] of longint ABSOLUTE hist;
    tabR:array[0..10000] of real    ABSOLUTE hist;
    tabX:array[0..6000] of extended ABSOLUTE hist;

    i:integer;
    x:extended;
    ym1,ym2:integer;
  begin
    i:=0;
    while x0>xW1 do
      begin
        x0:=x0-dX;
        dec(i);
        if i<-32000 then exit;
      end;

    while x0<xW1-dX do
      begin
        x0:=x0+dX;
        inc(i);
        if i>32000 then exit;
      end;



    Pmove(xW1,0);
    Pdraw(xW2,0);
    Pmove(x0,0);
    PpenDW;

    repeat
      case t of
        octet:      x:=tabO[i];
        entier:     x:=tabE[i];
        entierLong: x:=tabL[i];
        reel:       x:=tabR[i];
        etendu:     x:=tabX[i];
      end;
      case mode of
        1: PlotHisto1(X0, 0, X0+dX, x);
        2: PlotHisto2(X0, 0, X0+dX, x);
        3: PlotHisto0(X0, 0, X0+dX, x);
      end;
      X0:=X0+dX;
      inc(i);
      if i>32000 then exit;
    until X0>=xW2;
    PpenUp;
  end;

procedure PtraceTableau(var tab;t:typeType);
  var
    tabO:array[0..64000] of byte    ABSOLUTE tab;
    tabE:array[0..32000] of integer ABSOLUTE tab;
    tabL:array[0..16000] of longint ABSOLUTE tab;
    tabR:array[0..10000] of real    ABSOLUTE tab;
    tabX:array[0..6000] of extended ABSOLUTE tab;
    i:integer;
    x:float;
  begin
    for i:=trunc(xW1)+1 to trunc(xW2) do
      begin
        case t of
          octet:      x:=tabO[i];
          entier:     x:=tabE[i];
          entierLong: x:=tabL[i];
          reel:       x:=tabR[i];
          etendu:     x:=tabX[i];
        end;
        if i=trunc(xW1)+1 then Pmove(i,x)
                          else Pdraw(i,x);
      end;
  end;

procedure Plegende(x,y,h,l:float;vertical,centrage:boolean;st:string);
  var
    dx,dy:float;
    x1,y1,x2,y2:float;
  begin
    PgetWorld(x1,y1,x2,y2);
    Pworld(0,0,1000,1000);
    dx:=abs(xW2-xW1)/100;
    dy:=abs(yW2-yW1)/100;
    if not vertical then
      if centrage
        then Pmove(xW1+dx*(x-l*1.5*length(st)/2),yW1+dy*(y-h))
        else Pmove(xW1+dx*x,yW1+dy*y)
    else
      if centrage
        then Pmove(xW1+dx*(x-h),yW1+dy*(y-l*1.5*length(st)/2))
        else Pmove(xW1+dx*x,yW1+dy*y);

    PtailleCarR(l,h);
    if vertical then PtexteVertical;
    Plabel(st);
    PtexteHorizontal;
    Pworld(x1,y1,x2,y2);
  end;


procedure PpaperSize(n:integer);
  begin
    GwriteT(plt,'PS'+Istr(n)+';');
  end;

procedure Pspeed(n:integer);
  begin
    if n<=0 then GwriteT(plt,'VS;')
            else GwriteT(plt,'VS'+Istr(n)+';');
  end;



procedure StandardFontDefinition(SymbolSet:integer;b1:boolean;
                                 FontSpacing:integer;b2:boolean;
                                 Pitch:real;b3:boolean;
                                 Height:real;b4:boolean;
                                 Posture:integer;b5:boolean;
                                 StrokeWeight:integer;b6:boolean;
                                 TypeFace:integer;b7:boolean);
  begin

    GwriteT(plt,'SD');
    if b1 then GwriteT(plt,'1,'+Istr(SymbolSet)+';');
    if b2 then GwriteT(plt,'2,'+Istr(FontSpacing)+';');
    if b3 then GwriteT(plt,'3,'+cr(Pitch)+';');
    if b4 then GwriteT(plt,'4,'+cr(Height)+';');
    if b5 then GwriteT(plt,'5,'+Istr(Posture)+';');
    if b6 then GwriteT(plt,'6,'+Istr(StrokeWeight)+';');
    if b7 then GwriteT(plt,'7,'+Istr(TypeFace)+';');

    if not( b1 or b2 or b3 or b4 or b5 or b6 or b7) then GwriteT(plt,';');


  end;


end.