unit Dgrad1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,graphics,
     util1,Dgraphic,debug0;

const
  IndiceEspacementTick:integer=100;


type
  typeGradHor=class
                Ltick0:integer;
                Ltick:integer;
                EpaisseurTick:integer;
                EpaisseurCadre:integer;
                grille:boolean;
                Ftick:boolean;
                color,ColorBK:Tcolor;
                u:string[10];
                log,ech,complet,externe:boolean;
                x1w,y1w,x2w,y2w:integer;
                inverse:boolean;

                constructor create;
                procedure setUnites(ux:AnsiString);
                procedure setLog(log0:boolean);
                procedure setEch(ech0:boolean);
                procedure setComplet(cp0:boolean);
                procedure setTicks(ep,long:integer;ext:boolean);
                procedure setGrille(gon:boolean);
                procedure setColors(col,colBk:Tcolor);
                procedure setCadre(CdON:boolean;ep:integer);
                procedure setExternal(ext:boolean);
                procedure affiche;virtual;
                procedure affiche0;
                procedure setExternalWindow(x1,y1,x2,y2:integer);
                procedure setInverse(w:boolean);
              end;

  typeGradVer=class(typeGradHor)
                procedure affiche;override;
                procedure affiche0;
              end;


  typeGrad=   class
                gh:typeGradHor;
                gv:typeGradVer;

                Fx0,Fy0:boolean;
                constructor create;
                destructor destroy;override;

                procedure setUnites(ux,uy:AnsiString);
                procedure setLog(logX,logY:boolean);
                procedure setEch(echX,echY:boolean);
                procedure setComplet(cpx,cpy:boolean);
                procedure setTicks(ep,long:integer;ext:boolean);
                procedure setGrille(gon:boolean);
                procedure setColors(col,colBK:Tcolor);

                procedure setCadre(CdONX,cdONY:boolean;ep:integer);
                procedure setExternal(extX,extY:boolean);
                procedure setInverse(invX,invY:boolean);

                procedure setZeroAxis(xx,yy:boolean);

                procedure affiche;virtual;
                destructor done;
              end;


IMPLEMENTATION


function chaineGrad(x,xdv:float):AnsiString;
  var
    st:AnsiString;
    p:integer;
  begin
    {affdebug('chaineGrad='+estr(x,3)+' '+estr(xdv,3) );}

    if abs(x)<xdv/10000 then st:='0'
    else
    if (abs(x)<1E7) and (abs(x)>=1E-5) then
      begin
        str(x:20:10,st);
        st:=Fsupespace(st);
        if pos('.',st)>0 then
        while (length(st)>0) and (st[length(st)]='0') do delete(st,length(st),1);
        if (length(st)>0) and (st[length(st)]='.') then delete(st,length(st),1);
        if st='-0' then st:='0';
      end
    else
      begin
        str(x,st);
        delete(st,5,13);
        if copy(st,3,2)='.0' then delete(st,3,2);
        if (length(st)>4) and (st[length(st)-4]='+') then delete(st,length(st)-4,1);
        p:=length(st)-3;
        while (p>0) and (st[p]='0') do delete(st,p,1);
        if st[1]=' ' then delete(st,1,1);
      end;

    chaineGrad:=st;
  end;


{ *********************** méthodes de typeGradHor ************************ }

constructor typeGradHor.create;
  begin
    Ltick0:=0;
    EpaisseurTick:=1;
    EpaisseurCadre:=1;
    grille:=false;
    Ftick:=true;
    color:=clBlack;
    colorBk:=clWhite;
    u:='';
    log:=false;
    ech:=true;
    complet:=true;
    externe:=false;
  end;


procedure typeGradHor.setUnites(ux:AnsiString);
  begin
    u:=ux;
  end;

procedure typeGradHor.setLog(log0:boolean);
  begin
    log:=log0;
  end;

procedure typeGradHor.setEch(ech0:boolean);
  begin
    ech:=ech0;
  end;

procedure typeGradHor.setComplet(cp0:boolean);
  begin
    complet:=cp0;
  end;

procedure typeGradHor.setTicks(ep,long:integer;ext:boolean);
  begin
    Ltick0:=long;
    EpaisseurTick:=ep;
    externe:=ext;
  end;

procedure typeGradHor.setExternal(ext:boolean);
  begin
    externe:=ext;
  end;

procedure typeGradHor.setGrille(gon:boolean);
  begin
    grille:=gon;
  end;

procedure typeGradHor.setColors(col,colBK:Tcolor);
  begin
    color:=col;
    colorBk:=colBK;
  end;

procedure typeGradHor.setCadre(CdON:boolean;ep:integer);
  begin
    Ftick:=CdON;
    epaisseurCadre:=ep;
  end;

procedure typeGradHor.affiche;
  var
    a,dv:float;
    i,j,c,k,c1:integer;
    fl:boolean;
    st:AnsiString;
    xmin,ymin,xmax,ymax:float;
    xg,xd:float;

    tabTick:typeTabTick;
    Nbtick:integer;


    OldAlign,oldBk:word;
    Hcar,Lcar,dyCar:integer;

    Fdec:boolean;

  procedure Ticker(x:float);
    var
      i,j1,j2:integer;
    begin
      if not Ftick and not grille then exit;

      i:=convWx(x);
      j1:=convWy(Ymin);
      j2:=convWy(Ymax);
      if not grille then
        begin
          canvasGlb.moveto(i,j1+1);
          if externe then canvasGlb.lineto(i,j1+Ltick+1)
                     else canvasGlb.lineto(i,j1-Ltick-1);
          if complet then
            begin
              canvasGlb.moveto(i,j2-1);
              if externe then canvasGlb.lineto(i,j2-Ltick-1)
                         else canvasGlb.lineto(i,j2+Ltick+1);
            end;
        end
      else
        begin
          canvasGlb.moveto(i,j1);
          canvasGlb.lineto(i,j2-1);
        end;
    end;


  begin        { of GgraduationsHOR }
    getWorld(Xmin,Ymin,Xmax,Ymax);
    if (Xmin=Xmax) or Log and ((Xmin<=0) or (Xmax<=0)) then exit;

    pushCol;
    canvasGlb.pen.color:=color;
    canvasGlb.pen.style:=psSolid;
    canvasGlb.brush.color:=colorBK;
    canvasGlb.brush.style:=bsClear;
    canvasGlb.font.color:=color;

    Hcar:=canvasGlb.textHeight('0');
    Lcar:=canvasGlb.textWidth('0');
    dyCar:=Hcar div 8 +1;


    if (x1w=x2w) or (y1w=y2w)
      then setClippingOff
      else setWindow(x1w,y1w,x2w,y2w);

    if Ftick then
      begin
        canvasGlb.pen.color:=color;
        canvasGlb.pen.style:=psSolid;;
        canvasGlb.pen.width:=EpaisseurCadre;

        canvasGlb.moveto(x1act-1,y2act+1);
        canvasGlb.lineto(x2act+2,y2act+1);
        if complet then
          begin
            canvasGlb.moveto(x1act-1,y1act-1);
            canvasGlb.lineto(x2act+2,y1act-1);
          end;
      end;

    if grille then canvasGlb.pen.style:=psDot;
    canvasGlb.pen.width:=EpaisseurTick;

    if Ltick0<>0
      then Ltick:=Ltick0
      else Ltick:=widthGlb div 250 +1;
    if externe then dycar:=dycar+Ltick;

    IndiceEspacementTick:=8*Lcar+EpaisseurCadre;

    OldAlign:=setTextAlign(canvasGlb.handle,TA_Center or TA_Top);


    if inverse then
      begin
        xg:=Xmax;
        xd:=Xmin;
      end
    else
      begin
        xg:=Xmin;
        xd:=Xmax;
      end;
    Fdec:=(Xg>xd);

    if Log then
      begin

        setworld(log10(Xg),Ymin,log10(Xd),Ymax);
        tickLog(Xg,Xd,NbTick,tabTick);
        c:=0;
        dv:=division(xd-xg);

        for i:=1 to Nbtick do
          begin
            a:=log10(tabTick[i].w);

            ticker(a);

            if tabTick[i].aff and ech then
              begin
                st:=chaineGrad(tabTick[i].w,dv);

                if c=0 then
                  begin
                    st:=' '+st+' '+u;
                    for j:=1 to length(u) do st:=' '+st;
                  end;
                CanvasGlb.TextOut(convWx(a),y2act+dyCar,st);
              end;
            inc(c);

          end;

      end
    else
      begin
        setworld(Xg,Ymin,Xd,Ymax);
        dv:=division(Xd-Xg);
        a:=dv*trunc(Xg/dv);
        if (a<Xg) and not Fdec then a:=a+dv
        else
        if (a>Xg) and Fdec then a:=a-dv;

        if convWx(a+dv)-convWx(a)<>0
          then k:=IndiceEspacementTick div abs( convWx(a+dv)-convWx(a)) +1
          else k:=1;

        if Xg*Xd<0
          then c:=10*k+roundI(a/dv)
          else c:=0;

        c1:=c;
        while not Fdec and (a<=xd) or Fdec and (a>=xd) do
          begin
            ticker(a);

            if (c mod k=0) and ech then
              begin
                st:=chaineGrad(a,dv);
                if c=c1 then
                  begin
                    st:=' '+st+' '+u;
                    for i:=1 to length(u) do st:=' '+st;
                  end;
                canvasGlb.Textout(convWx(a),y2act+dyCar,st);
              end;
            if Fdec then a:=a-dv else a:=a+dv;
            inc(c);
          end;
      end;

    canvasGlb.Pen.style:=psSolid;
    canvasGlb.Pen.width:=1;

    setTextAlign(canvasGlb.handle,OldAlign);
    setworld(Xmin,Ymin,Xmax,Ymax);
    setClippingOn;
    popCol;
  end;

procedure typeGradHor.affiche0;
  var
    a,dv:float;
    i,j,c,k,c1:integer;
    fl:boolean;
    st:AnsiString;
    xmin,ymin,xmax,ymax:float;
    xg,xd:float;
    y:integer;

    tabTick:typeTabTick;
    Nbtick:integer;


    OldAlign,oldBk:word;
    Hcar,Lcar,dxcar,dyCar:integer;

    Fdec:boolean;

  procedure Ticker(x:float);
    var
      i1,j1:integer;
    begin
      i1:=convWx(x);
      j1:=convWy(0);
      canvasGlb.moveto(i1,j1);
      canvasGlb.lineto(i1,j1-Ltick);
    end;


  begin        { of typeGradHor.affiche0}
    getWorld(Xmin,Ymin,Xmax,Ymax);
    if (Xmin=Xmax) or Log and ((Xmin<=0) or (Xmax<=0)) then exit;

    if (Ymin>0) or (Ymax<0) then exit;
    y:=convWy(0);

    pushCol;
    canvasGlb.pen.color:=color;
    canvasGlb.pen.style:=psSolid;
    canvasGlb.brush.color:=colorBK;
    canvasGlb.brush.style:=bsClear;
    canvasGlb.font.color:=color;

    Hcar:=canvasGlb.textHeight('0');
    Lcar:=canvasGlb.textWidth('0');
    dxCar:=Lcar div 8+epaisseurCadre+1;
    dyCar:=Hcar div 8 +1;

    if (x1w=x2w) or (y1w=y2w)
      then setClippingOff
      else setWindow(x1w,y1w,x2w,y2w);

    canvasGlb.pen.color:=color;
    canvasGlb.pen.style:=psSolid;;
    canvasGlb.pen.width:=EpaisseurCadre;


    canvasGlb.moveto(x1act-1,y);
    canvasGlb.lineto(x2act+2,y);

    canvasGlb.pen.width:=EpaisseurTick;

    if Ltick0<>0
      then Ltick:=Ltick0
      else Ltick:=widthGlb div 250 +1;
    if externe then dycar:=dycar+Ltick;

    IndiceEspacementTick:=8*Lcar+EpaisseurCadre;

    OldAlign:=setTextAlign(canvasGlb.handle,TA_Center or TA_Top);

    if inverse then
      begin
        xg:=Xmax;
        xd:=Xmin;
      end
    else
      begin
        xg:=Xmin;
        xd:=Xmax;
      end;
    Fdec:=(Xg>xd);

    if Log then
      begin

        setworld(log10(Xg),Ymin,log10(Xd),Ymax);
        tickLog(Xg,Xd,NbTick,tabTick);
        c:=0;
        dv:=division(xd-xg);

        for i:=1 to Nbtick do
          begin
            a:=log10(tabTick[i].w);

            ticker(a);

            if tabTick[i].aff and ech then
              begin
                st:=chaineGrad(tabTick[i].w,dv);

                if st='0' then
                begin
                  setTextAlign(canvasGlb.handle,TA_Right or TA_Top);
                  CanvasGlb.TextOut(convWx(a)-dxcar,y+dyCar,st);
                  setTextAlign(canvasGlb.handle,TA_Center or TA_Top);
                end
                else CanvasGlb.TextOut(convWx(a),y+dyCar,st);
              end;
            inc(c);

          end;

      end
    else
      begin
        setworld(Xg,Ymin,Xd,Ymax);
        dv:=division(Xd-Xg);
        a:=dv*trunc(Xg/dv);
        if (a<Xg) and not Fdec then a:=a+dv
        else
        if (a>Xg) and Fdec then a:=a-dv;

        if convWx(a+dv)-convWx(a)<>0
          then k:=IndiceEspacementTick div abs( convWx(a+dv)-convWx(a)) +1
          else k:=1;

        if Xg*Xd<0
          then c:=10*k+roundI(a/dv)
          else c:=0;

        c1:=c;
        while not Fdec and (a<=xd) or Fdec and (a>=xd) do
          begin
            ticker(a);

            if (c mod k=0) and ech then
              begin
                st:=chaineGrad(a,dv);
                if st='0' then
                begin
                  setTextAlign(canvasGlb.handle,TA_Right or TA_Top);
                  CanvasGlb.TextOut(convWx(0)-dxcar,y+1,st);
                  setTextAlign(canvasGlb.handle,TA_Center or TA_Top);
                end
                else canvasGlb.Textout(convWx(a),y+dyCar,st);
              end;
            if Fdec then a:=a-dv else a:=a+dv;
            inc(c);
          end;
      end;

    canvasGlb.Pen.style:=psSolid;
    canvasGlb.Pen.width:=1;

    setTextAlign(canvasGlb.handle,OldAlign);
    setworld(Xmin,Ymin,Xmax,Ymax);
    setClippingOn;
    popCol;
  end;


procedure typeGradHor.setExternalWindow(x1,y1,x2,y2:integer);
begin
  x1w:=x1;
  x2w:=x2;
  y1w:=y1;
  y2w:=y2;
end;

procedure typeGradHor.setInverse(w:boolean);
begin
  inverse:=w;
end;

{ *********************** méthodes de typeGradVer ************************ }


procedure typeGradVer.affiche;
  var
    a,dv:float;
    i,k,c1:integer;
    first:boolean;
    fl:boolean;
    st:AnsiString;
    xmin,ymin,xmax,ymax:float;

    tabTick:typeTabTick;
    Nbtick:integer;

    OldAlign:word;

    x,y:integer;
    Hcar,Lcar,dxcar:integer;
    pen,oldpen:hpen;
    oldBk:integer;

    yb,yh:float;
    Fdec:boolean;

  procedure Ticker(x:float);
    var
      i1,i2,j:integer;
    begin
      if not Ftick and not grille then exit;
      j:=convWy(x);
      i1:=convWx(Xmin);
      i2:=convWx(Xmax);
      if not grille then
        begin
          canvasGlb.moveto(i1-1,j);
          if externe then canvasGlb.lineto(i1-LTick-1,j)
                     else canvasGlb.lineto(i1+LTick+1,j);
          if complet then
            begin
              canvasGlb.moveto(i2+1,j);
              if externe then canvasGlb.lineto(i2+LTick+1,j)
                         else canvasGlb.lineto(i2-LTick-1,j);
            end;
        end
      else
        begin
          canvasGlb.moveto(i1,j);
          canvasGlb.lineto(i2,j);
        end;
    end;

  begin
    getWorld(Xmin,Ymin,Xmax,Ymax);
    if (Ymin=Ymax) or  Log and ((Ymin<=0) or (Ymax<=0)) then exit;

    if inverse then
      begin
        yb:=Ymax;
        yh:=Ymin;
      end
    else
      begin
        yb:=Ymin;
        yh:=Ymax;
      end;

    Fdec:=yh<yb;

    if (x1w=x2w) or (y1w=y2w)
      then setClippingOff
      else setWindow(x1w,y1w,x2w,y2w);

    pushCol;
    canvasGlb.pen.color:=color;
    canvasGlb.pen.style:=psSolid;
    canvasGlb.brush.color:=colorBK;
    canvasGlb.brush.style:=bsClear;
    canvasGlb.font.color:=color;

    Hcar:=canvasGlb.textHeight('0');
    Lcar:=canvasGlb.textWidth('0');
    dxCar:=Lcar div 8+epaisseurCadre+1;

    if Ftick then
      begin
        canvasGlb.pen.width:=EpaisseurCadre;
        canvasGlb.moveto(x1act-1,y1act-1);
        canvasGlb.lineto(x1act-1,y2act+2);
        if complet then
          begin
            canvasGlb.moveto(x2act+1,y1act-1);
            canvasGlb.lineto(x2act+1,y2act+2);
          end;
      end;

    if grille then canvasGlb.pen.style:=psDot;
    canvasGlb.pen.width:=EpaisseurTick;


    if Ltick0<>0 then Ltick:=Ltick0
    else Ltick:=widthGlb div 250+1;
    if externe then dxcar:=dxcar+Ltick;

    OldAlign:=setTextAlign(canvasGlb.handle,TA_Right or TA_Bottom);

     if log then
      begin
        setworld(Xmin,log10(Yb),Xmax,log10(Yh));
        tickLog(Yb,Yh,NbTick,tabTick);
        dv:=division(abs(yh-yb));
      end
    else
      begin
        setWorld(Xmin,Yb,Xmax,Yh);

        dv:=division(abs(yh-yb));
        a:=dv*int(Yb/dv);
        if convWy(a)-convWy(a+dv)<>0
          then k:={30} 2*Hcar div abs(convWy(a)-convWy(a+dv)) +1
          else k:=1;
        tickNorm(yb,yh,nbtick,tabtick,k);
      end;

    first:=true;

    for i:=1 to Nbtick do
      begin
        if log
          then a:=log10(tabtick[i].w)
          else a:=tabtick[i].w;
        Ticker(a);

        if tabTick[i].aff and ech then
          begin
            st:=chaineGrad(tabtick[i].w,dv);
            x:=x1act-dxCar;
            y:=convWy(a);
            if first then
              if y+Hcar div 2>y2act
                then y:=y2act-Hcar div 2;
            canvasGlb.TextOut(x,y+Hcar div 2,st);
            if first then
               begin
                 st:=' '+u;
                 canvasGlb.textOut(x,y-Hcar div 2-3,st);
                 first:=false;
               end;
          end;

      end;
    setTextAlign(canvasGlb.handle,OldAlign);
    setworld(Xmin,Ymin,Xmax,Ymax);

    canvasGlb.Pen.style:=psSolid;
    canvasGlb.Pen.width:=1;

    setClippingOn;
  end;

procedure typeGradVer.affiche0;
  var
    a,dv:float;
    i,k,c1:integer;
    first:boolean;
    fl:boolean;
    st:AnsiString;
    xmin,ymin,xmax,ymax:float;

    tabTick:typeTabTick;
    Nbtick:integer;

    OldAlign:word;

    x,y:integer;
    Hcar,Lcar,dxcar:integer;
    pen,oldpen:hpen;
    oldBk:integer;

    yb,yh:float;
    Fdec:boolean;
    x0:integer;

  procedure Ticker(x:float);
    var
      j1:integer;
    begin
      j1:=convWy(x);
      canvasGlb.moveto(x0,j1);
      canvasGlb.lineto(x0+LTick,j1)
    end;

  begin
    getWorld(Xmin,Ymin,Xmax,Ymax);
    if (Ymin=Ymax) or  Log and ((Ymin<=0) or (Ymax<=0)) then exit;

    if(Xmin>0) or (Xmax<0) then exit;
    x0:=convWx(0);

    if inverse then
      begin
        yb:=Ymax;
        yh:=Ymin;
      end
    else
      begin
        yb:=Ymin;
        yh:=Ymax;
      end;

    Fdec:=yh<yb;

    if (x1w=x2w) or (y1w=y2w)
      then setClippingOff
      else setWindow(x1w,y1w,x2w,y2w);

    pushCol;
    canvasGlb.pen.color:=color;
    canvasGlb.pen.style:=psSolid;
    canvasGlb.brush.color:=colorBK;
    canvasGlb.brush.style:=bsClear;
    canvasGlb.font.color:=color;

    Hcar:=canvasGlb.textHeight('0');
    Lcar:=canvasGlb.textWidth('0');
    dxCar:=Lcar div 8+epaisseurCadre+1;

    canvasGlb.pen.width:=EpaisseurCadre;
    canvasGlb.moveto(x0,y1act-1);
    canvasGlb.lineto(x0,y2act+2);

    canvasGlb.pen.width:=EpaisseurTick;

    if Ltick0<>0 then Ltick:=Ltick0
    else Ltick:=widthGlb div 250+1;
    if externe then dxcar:=dxcar+Ltick;

    OldAlign:=setTextAlign(canvasGlb.handle,TA_Right or TA_Bottom);

    if log then
      begin
        setworld(Xmin,log10(Yb),Xmax,log10(Yh));
        tickLog(Yb,Yh,NbTick,tabTick);
        dv:=division(abs(yh-yb));
      end
    else
      begin
        setWorld(Xmin,Yb,Xmax,Yh);

        dv:=division(abs(yh-yb));
        a:=dv*int(Yb/dv);
        if convWy(a)-convWy(a+dv)<>0
          then k:={30} 2*Hcar div abs(convWy(a)-convWy(a+dv)) +1
          else k:=1;
        tickNorm(yb,yh,nbtick,tabtick,k);
      end;

    first:=true;

    for i:=1 to Nbtick do
      begin
        if log
          then a:=log10(tabtick[i].w)
          else a:=tabtick[i].w;
        Ticker(a);

        if tabTick[i].aff and ech then
          begin
            st:=chaineGrad(tabtick[i].w,dv);
            x:=x0-dxCar;
            y:=convWy(a);
            if first then
              if y+Hcar div 2>y2act
                then y:=y2act-Hcar div 2;

            if st='0' then
            begin
              setTextAlign(canvasGlb.handle,TA_Right or TA_Top);
              canvasGlb.TextOut(x0-dxCar,y+1,st);
              setTextAlign(canvasGlb.handle,TA_Right or TA_Bottom);
            end
            else canvasGlb.TextOut(x,y+Hcar div 2,st);
            {if first then
               begin
                 st:=' '+u;
                 canvasGlb.textOut(x,y-Hcar div 2-3,st);
                 first:=false;
               end;}
          end;

      end;
    setTextAlign(canvasGlb.handle,OldAlign);
    setworld(Xmin,Ymin,Xmax,Ymax);

    canvasGlb.Pen.style:=psSolid;
    canvasGlb.Pen.width:=1;

    setClippingOn;
  end;         { of Ggraduations }



{ *********************** méthodes de typeGrad *************************** }

constructor typeGrad.create;
  begin
    gh:=typeGradHor.create;
    gv:=typeGradVer.create;
  end;

destructor typeGrad.destroy;
  begin
    gh.free;
    gv.free;
  end;


procedure typeGrad.setUnites(ux,uy:AnsiString);
  begin
    gh.setUnites(ux);
    gv.setUnites(uy);
  end;

procedure typeGrad.setLog(logX,logY:boolean);
  begin
    gh.setLog(logx);
    gv.setLog(logy);
  end;

procedure typeGrad.setEch(echX,echY:boolean);
  begin
    gh.setEch(echx);
    gv.setEch(echy);
  end;

procedure typeGrad.setComplet(cpx,cpy:boolean);
  begin
    gh.setComplet(cpx);
    gv.setComplet(cpy);
  end;

procedure typeGrad.setTicks(ep,long:integer;ext:boolean);
  begin
    gh.setTicks(ep,long,ext);
    gv.setTicks(ep,long,ext);
  end;

procedure typeGrad.setExternal(extX,extY:boolean);
  begin
    gh.setExternal(extX);
    gv.setExternal(extY);
  end;

  procedure typeGrad.setGrille(gon:boolean);
  begin
    gh.setGrille(gon);
    gv.setGrille(gon);
  end;

procedure typeGrad.setColors(col,colBK:Tcolor);
  begin
    gh.setColors(col,colBK);
    gv.setColors(col,colBK);
  end;


procedure typeGrad.setCadre(CdONX,cdONY:boolean;ep:integer);
  begin
    gh.setCadre(cdOnX,ep);
    gv.setCadre(cdOnY,ep);
  end;

procedure typeGrad.setInverse(invX,invY:boolean);
  begin
    gh.setInverse(invX);
    gv.setInverse(invY);
  end;

procedure typeGrad.affiche;
  begin
    if Fx0
      then gh.affiche0
      else gh.affiche;

    if Fy0
      then gv.affiche0
      else gv.affiche;
  end;

destructor typeGrad.done;
  begin
    gh.free;
    gv.free;
  end;

procedure typeGrad.setZeroAxis(xx, yy: boolean);
begin
  Fx0:=xx;
  Fy0:=yy;
end;





end.
