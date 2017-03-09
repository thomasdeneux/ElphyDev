unit stmSymbs1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,menus,graphics,sysutils,controls,
     util1,Dgraphic,varconf1,Dtrace1,
     stmDef,stmObj,stmPlot1, stmDplot, stmPopup,
     lineHorProp,stmSymbProp,linFuncProp,editCont,lineProp,
     stmPg,debug0;

type

  TsymbPlot=
    class(Tplot)
    public
      visible:boolean;
      color:integer;

      constructor create;override;
      function getPopUp:TpopUpMenu;override;
      procedure createForm;override;
      function getTitle:AnsiString;override;
      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;

      procedure display0;virtual;
      procedure display;override;
      procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);override;
    end;


  TlineHorRec=record
                pos0:float;
                width0:integer;
                style0:integer;
              end;
  TLineHor=
        class(TsymbPlot)
          private
            rec:TlineHorRec;

          public
            constructor create;override;

            class function STMClassName:AnsiString;override;

            procedure display0; override;
            procedure Proprietes(sender:Tobject);override;
            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
          end;

  TLineVer=
        class(TlineHor)
            class function STMClassName:AnsiString;override;
            procedure display0; override;
        end;

  TsymbRec=record
             x0,y0:float;
             size0:integer;
             style0:integer;
           end;

  TstmSymb=
        class(TsymbPlot)
          private
            rec:TsymbRec;
          public
            constructor create;override;

            class function STMClassName:AnsiString;override;

            procedure display0; override;
            procedure Proprietes(sender:Tobject);override;
            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
          end;

  TellipseRec=
           record
             x0,y0:float;
             PixWidth0,PixHeight0,penWidth0:integer;
             brushStyle0:integer;
             width0,height0:float;
           end;

  TstmEllipse=
        class(TsymbPlot)
          private
            rec:TEllipseRec;
          public
            constructor create;override;

            class function STMClassName:AnsiString;override;

            procedure display0; override;
            procedure Proprietes(sender:Tobject);override;
            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
          end;


  TbarSymbol=
        class(TsymbPlot)
          private
            deg:TypeDegre;
          public
            constructor create;override;

            class function STMClassName:AnsiString;override;

            procedure display0; override;
            procedure Proprietes(sender:Tobject);override;
            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
          end;


  TdroiteRec=
           record
             a,b:float;
             width0:integer;
             style0:integer;
           end;

  TlinearFunc=
        class(TsymbPlot)
          private
            rec:TdroiteRec;
          public
            constructor create;override;

            class function STMClassName:AnsiString;override;

            procedure display0; override;


            procedure Proprietes(sender:Tobject);override;
            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
          end;


  TlineRec=
           record
             x1,y1,x2,y2:float;
             width0:integer;
             style0:integer;
           end;

  Tline=
        class(TsymbPlot)
          private
            rec:TlineRec;
          public
            constructor create;override;

            class function STMClassName:AnsiString;override;

            procedure display0; override;
            procedure Proprietes(sender:Tobject);override;
            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
          end;


Function fonctionTsymbPlot_color(var pu:typeUO):longint;pascal;
Procedure proTsymbPlot_color(w:longint;var pu:typeUO);pascal;
Function fonctionTsymbPlot_visible(var pu:typeUO):boolean;pascal;
Procedure proTsymbPlot_visible(w:boolean;var pu:typeUO);pascal;

Procedure proTsymbol_create(stName:AnsiString;x,y:float;color:longint;style:integer;var pu:typeUO);pascal;
Procedure proTsymbol_create_1(x,y:float;color:longint;style:integer;var pu:typeUO);pascal;

Function fonctionTsymbol_x(var pu:typeUO):float;pascal;
Procedure proTsymbol_x(w:float;var pu:typeUO);pascal;
Function fonctionTsymbol_y(var pu:typeUO):float;pascal;
Procedure proTsymbol_y(w:float;var pu:typeUO);pascal;
Function fonctionTsymbol_style(var pu:typeUO):integer;pascal;
Procedure proTsymbol_style(w:integer;var pu:typeUO);pascal;
Function fonctionTsymbol_size(var pu:typeUO):integer;pascal;
Procedure proTsymbol_size(w:integer;var pu:typeUO);pascal;

Procedure proTEllipse_create(x,y:float;w,h,color:integer;var pu:typeUO);pascal;
Function fonctionTEllipse_x(var pu:typeUO):float;pascal;
Procedure proTEllipse_x(w:float;var pu:typeUO);pascal;
Function fonctionTEllipse_y(var pu:typeUO):float;pascal;
Procedure proTEllipse_y(w:float;var pu:typeUO);pascal;
Function fonctionTellipse_pixwidth(var pu:typeUO):integer;pascal;
Procedure proTellipse_pixwidth(w:integer;var pu:typeUO);pascal;
Function fonctionTellipse_pixheight(var pu:typeUO):integer;pascal;
Procedure proTellipse_pixheight(w:integer;var pu:typeUO);pascal;
Function fonctionTellipse_lineWidth(var pu:typeUO):integer;pascal;
Procedure proTellipse_lineWidth(w:integer;var pu:typeUO);pascal;
Function fonctionTellipse_BrushStyle(var pu:typeUO):integer;pascal;
Procedure proTellipse_BrushStyle(w:integer;var pu:typeUO);pascal;


Procedure proTbarSymbol_create(x,y,dx,dy,theta:float;color:integer;var pu:typeUO);pascal;
Function fonctionTbarSymbol_x(var pu:typeUO):float;pascal;
Procedure proTbarSymbol_x(w:float;var pu:typeUO);pascal;
Function fonctionTbarSymbol_y(var pu:typeUO):float;pascal;
Procedure proTbarSymbol_y(w:float;var pu:typeUO);pascal;
Function fonctionTbarSymbol_dx(var pu:typeUO):float;pascal;
Procedure proTbarSymbol_dx(w:float;var pu:typeUO);pascal;
Function fonctionTbarSymbol_dy(var pu:typeUO):float;pascal;
Procedure proTbarSymbol_dy(w:float;var pu:typeUO);pascal;
Function fonctionTbarSymbol_theta(var pu:typeUO):float;pascal;
Procedure proTbarSymbol_theta(w:float;var pu:typeUO);pascal;


Procedure proTlineHor_create(stName:AnsiString;y0:float;color:longint;style:integer;var pu:typeUO);pascal;
Procedure proTlineHor_create_1(y0:float;color:longint;style:integer;var pu:typeUO);pascal;

Function fonctionTlineHor_y(var pu:typeUO):float;pascal;
Procedure proTlineHor_y(w:float;var pu:typeUO);pascal;
Function fonctionTlineHor_style(var pu:typeUO):integer;pascal;
Procedure proTlineHor_style(w:integer;var pu:typeUO);pascal;
Function fonctionTlineHor_width(var pu:typeUO):integer;pascal;
Procedure proTlineHor_width(w:integer;var pu:typeUO);pascal;


Procedure proTlineVer_create(stName:AnsiString;y0:float;color:longint;style:integer;var pu:typeUO);pascal;
Procedure proTlineVer_create_1(y0:float;color:longint;style:integer;var pu:typeUO);pascal;

Function fonctionTlineVer_x(var pu:typeUO):float;pascal;
Procedure proTlineVer_x(w:float;var pu:typeUO);pascal;
Function fonctionTlineVer_style(var pu:typeUO):integer;pascal;
Procedure proTlineVer_style(w:integer;var pu:typeUO);pascal;
Function fonctionTlineVer_width(var pu:typeUO):integer;pascal;
Procedure proTlineVer_width(w:integer;var pu:typeUO);pascal;


Procedure proTlinearFunc_create(stName:AnsiString;a,b:float;color:longint;style:integer;var pu:typeUO);pascal;
Procedure proTlinearFunc_create_1(a,b:float;color:longint;style:integer;var pu:typeUO);pascal;

Function fonctionTlinearFunc_a(var pu:typeUO):float;pascal;
Procedure proTlinearFunc_a(w:float;var pu:typeUO);pascal;
Function fonctionTlinearFunc_b(var pu:typeUO):float;pascal;
Procedure proTlinearFunc_b(w:float;var pu:typeUO);pascal;
Function fonctionTlinearFunc_style(var pu:typeUO):integer;pascal;
Procedure proTlinearFunc_style(w:integer;var pu:typeUO);pascal;
Function fonctionTlinearFunc_width(var pu:typeUO):integer;pascal;
Procedure proTlinearFunc_width(w:integer;var pu:typeUO);pascal;

Procedure proTline_create(stName:AnsiString;x1a,y1a,x2a,y2a:float;color:longint;style:integer;var pu:typeUO);pascal;
Procedure proTline_create_1(x1a,y1a,x2a,y2a:float;color:longint;style:integer;var pu:typeUO);pascal;
Function fonctionTline_x1(var pu:typeUO):float;pascal;
Procedure proTline_x1(w:float;var pu:typeUO);pascal;
Function fonctionTline_y1(var pu:typeUO):float;pascal;
Procedure proTline_y1(w:float;var pu:typeUO);pascal;
Function fonctionTline_x2(var pu:typeUO):float;pascal;
Procedure proTline_x2(w:float;var pu:typeUO);pascal;
Function fonctionTline_y2(var pu:typeUO):float;pascal;
Procedure proTline_y2(w:float;var pu:typeUO);pascal;
Function fonctionTline_style(var pu:typeUO):integer;pascal;
Procedure proTline_style(w:integer;var pu:typeUO);pascal;
Function fonctionTline_width(var pu:typeUO):integer;pascal;
Procedure proTline_width(w:integer;var pu:typeUO);pascal;



implementation

{************************* Méthodes de TsymbPlot ******************************}

constructor TsymbPlot.create;
begin
  inherited;
  visible:=true;
end;

function TsymbPlot.getPopUp:TpopUpMenu;
begin
  with PopUps do
  begin
    PopupItem(pop_Tsymbs,'Tsymbs_Properties').onClick:=Proprietes;

    result:=pop_Tsymbs;
  end;
end;


procedure TsymbPlot.createForm;
begin
end;

function TsymbPlot.getTitle:AnsiString;
begin
  result:='';
end;

procedure TsymbPlot.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setvarConf('vs',visible,sizeof(visible));
    setvarConf('cl',color,sizeof(color));
  end;
end;

procedure TSymbPlot.display0;
begin
end;

procedure TSymbPlot.display;
var
  x1,y1,x2,y2: integer;
  rr: float;
begin
  getWindowG(x1,y1,x2,y2);
  if y1<>y2 then rr:=abs((x2-x1)/(y2-y1)) else exit;
  Dgraphic.setWorld(-100*rr,-100,100*rr,100);
  display0;
end;

procedure TSymbPlot.displayInside(FirstUO: typeUO; extWorld, logX, logY: boolean; const order:integer=-1);
begin
  if assigned(FirstUO) and (firstUO is TdataPlot) then
  with TdataPlot(FirstUO) do
  begin
    if inverseX and not inverseY then Dgraphic.setWorld(Xmax,Ymin,Xmin,Ymax)
    else
    if not inverseX and inverseY then Dgraphic.setWorld(Xmin,Ymax,Xmax,Ymin)
    else
    if inverseX and inverseY then Dgraphic.setWorld(Xmax,Ymax,Xmin,Ymin)
    else Dgraphic.setWorld(Xmin,Ymin,Xmax,Ymax);
  end;

  display0;
end;


{************************* Méthodes de TlineHor ******************************}

constructor TlineHor.create;
begin
  inherited;
  rec.width0:=1;
end;

class function TlineHor.STMClassName:AnsiString;
begin
  result:='LineHor';
end;

procedure TlineHor.display0;
begin
  if not visible then exit;

  with canvasGlb do
  begin
    pen.Style :=TpenStyle(rec.style0);
    pen.width:=rec.width0;
  end;

  with rec do lineHor(pos0,color,false);

  with canvasGlb do
  begin
    pen.Style :=psSolid;
    pen.width:=1;
  end;
end;

procedure TlineHor.Proprietes(sender:Tobject);
begin
  with getLineHor,rec do
  begin
    caption:=ident;

    enPos.setvar(pos0,t_extended);
    Pcolor.color:=self.color;
    enWidth.setvar(width0,t_longint);
    with cbStyle do
    begin
      setStringArray(tbStyleTrait,longNomStyleTrait,nbStyleTrait);
      setVar(style0,T_longint,0);
    end;

    cbVisible.setvar(self.visible);

    if showModal=mrok then
      begin
        updateAllvar(getLineHor);
        self.color:=Pcolor.color;
        self.invalidate;
      end;
  end;
end;

procedure TlineHor.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setvarConf('Rec',rec,sizeof(rec));
  end;
end;



{************************* Méthodes de TlineVer ******************************}

class function TLineVer.STMClassName:AnsiString;
begin
  result:='LineVer';
end;

procedure TLineVer.display0;
begin
  if not visible then exit;

  with canvasGlb do
  begin
    pen.Style :=TpenStyle(rec.style0);
    pen.width:=rec.width0;
  end;

  with rec do lineVer(pos0,color,false);

  with canvasGlb do
  begin
    pen.Style :=psSolid;
    pen.width:=1;
  end;

end;

{************************* Méthodes de TstmSymb ******************************}

constructor TstmSymb.create;
begin
  inherited;
  rec.size0:=3;
end;

class function TstmSymb.STMClassName:AnsiString;
begin
  result:='Symbol';
end;

procedure TstmSymb.display0;
var
  i,j:integer;
begin
  if not visible then exit;

  try
  with rec do
  displaySymbol(typeStyleTrace(style0),size0,color,x0,y0)

  finally
  with canvasGlb do
  begin
    pen.Style :=psSolid;
    pen.width:=1;
    brush.Style:=bsClear;
  end;

  end;
end;



procedure TstmSymb.Proprietes(sender:Tobject);
begin
  with getSymbol,rec do
  begin
    caption:=ident;

    enX.setvar(x0,t_extended);
    enY.setvar(y0,t_extended);
    Pcolor.color:=self.color;
    enSize.setvar(size0,t_longint);

    with cbStyle do
    begin
      setStringArray(tbStyleTrace,longNomStyleTrace,nbStyleTrace);
      setVar(style0,T_longint,1);
    end;

    cbVisible.setvar(self.visible);

    if showModal=mrok then
      begin
        updateAllvar(getSymbol);
        self.color:=Pcolor.color;
        self.invalidate;
      end;
  end;
end;

procedure TstmSymb.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setvarConf('Rec',rec,sizeof(rec));
  end;
end;


{************************* Méthodes de TstmEllipse ******************************}

constructor TstmEllipse.create;
begin
  inherited;
  rec.pixWidth0:=3;
  rec.PixHeight0:=3;
  rec.penWidth0:=1;
end;

class function TstmEllipse.STMClassName:AnsiString;
begin
  result:='Ellipse';
end;

procedure TstmEllipse.display0;
var
  i,j:integer;
begin
  if not visible then exit;

  try

  with rec do
  begin
    i:=convWx(x0);
    j:=convWy(y0);
    with canvasGlb do
    begin
      pen.color:=color;
      pen.Width:=penWidth0;

      brush.Style:=TbrushStyle(brushStyle0);
      brush.Color:=clGray;

      ellipse(i-pixwidth0 div 2,j-pixheight0 div 2,i+pixwidth0 div 2,j+pixheight0 div 2);
    end;
  end;

  finally
  with canvasGlb do
  begin
    pen.Style :=psSolid;
    pen.width:=1;
    brush.Style:=bsClear;
  end;

  end;
end;



procedure TstmEllipse.Proprietes(sender:Tobject);
begin
end;

procedure TstmEllipse.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setvarConf('Rec',rec,sizeof(rec));
  end;
end;

{ TbarSymbol }

constructor TbarSymbol.create;
begin
  inherited;
  deg.dx:=10;
  deg.dy:=10;
end;

class function TbarSymbol.STMClassName: AnsiString;
begin
  result:='BarSymb';
end;

procedure TbarSymbol.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;
  with conf do
  begin
    setvarConf('Rec',deg,sizeof(deg));
  end;
end;

procedure TbarSymbol.display0;
 var
  i:integer;
  xc,yc:integer;
  PR:typePoly5R;
  poly: typePoly5;
begin
  DegToPolyR( deg, PR );
  for i:=1 to 5 do
  with poly[i] do
  begin
    x:=convWx(PR[i].x);
    y:=convWy(PR[i].y);
  end;

  with canvasGlb do
  begin
    pen.style:=psSolid;
    pen.color:=color;;
    brush.style:=bsSolid;
    brush.color:=color;
    polygon(poly);
  end;
end;


procedure TbarSymbol.Proprietes(sender: Tobject);
begin
  inherited;

end;


{************************* Méthodes de TlinearFunc ******************************}

constructor TlinearFunc.create;
begin
  inherited;
  rec.width0:=1;
end;

class function TlinearFunc.STMClassName:AnsiString;
begin
  result:='LinearFunc';
end;

procedure TlinearFunc.display0;
begin
  if not visible then exit;
  with canvasGlb do
  begin
    pen.Style :=psSolid;
    pen.width:=rec.width0;
    pen.color:=self.color;
  end;

  with rec do droite(a,b,color,false);

  with canvasGlb do
  begin
    pen.Style :=psSolid;
    pen.width:=1;
  end;
end;

procedure TlinearFunc.Proprietes(sender:Tobject);
begin
  with getLineFunc,rec do
  begin
    caption:=ident;

    enA.setvar(a,t_extended);
    enB.setvar(b,t_extended);
    Pcolor.color:=self.color;
    enWidth.setvar(width0,t_longint);


    with cbStyle do
    begin
      setStringArray(tbStyleTrait,longNomStyleTrait,nbStyleTrait);
      setVar(style0,T_longint,0);
    end;

    cbVisible.setvar(self.visible);

    if showModal=mrok then
      begin
        updateAllvar(getLineFunc);
        self.color:=Pcolor.color;
        self.invalidate;
      end;
  end;
end;

procedure TlinearFunc.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setvarConf('Rec',rec,sizeof(rec));
  end;
end;




{************************* Méthodes de Tline **********************************}

constructor Tline.create;
begin
  inherited;
  rec.width0:=1;
end;

class function Tline.STMClassName:AnsiString;
begin
  result:='Line';
end;

procedure Tline.display0;
begin
  if not visible then exit;
  with canvasGlb do
  begin
    pen.Style :=TpenStyle(rec.style0);
    pen.width:=rec.width0;
    pen.color:=self.color;

    moveto(convWx(rec.x1),convWy(rec.y1));
    lineto(convWx(rec.x2),convWy(rec.y2));
  end;

  with canvasGlb do
  begin
    pen.Style :=psSolid;
    pen.width:=1;
  end;
end;




procedure Tline.Proprietes(sender:Tobject);
begin
  with getLine,rec do
  begin
    caption:=ident;

    enx1.setvar(x1,t_extended);
    eny1.setvar(y1,t_extended);
    enx2.setvar(x2,t_extended);
    eny2.setvar(y2,t_extended);

    Pcolor.color:=self.color;
    enWidth.setvar(width0,t_longint);


    with cbStyle do
    begin
      setStringArray(tbStyleTrait,longNomStyleTrait,nbStyleTrait);
      setVar(style0,T_longint,0);
    end;

    cbVisible.setvar(self.visible);

    if showModal=mrok then
      begin
        updateAllvar(getLine);
        self.color:=Pcolor.color;
        self.invalidate;
      end;
  end;
end;

procedure Tline.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setvarConf('Rec',rec,sizeof(rec));
  end;
end;




{**************************** Méthodes stm Tsymbs *****************************}

Function fonctionTsymbPlot_color(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  result:=TsymbPlot(pu).color;
end;

Procedure proTsymbPlot_color(w:longint;var pu:typeUO);
begin
  verifierObjet(pu);
  TsymbPlot(pu).color:=w;
end;

Function fonctionTsymbPlot_visible(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TsymbPlot(pu).visible;
end;

Procedure proTsymbPlot_visible(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TsymbPlot(pu).visible:=w;
end;

Procedure proTsymbol_create(stName:AnsiString;x,y:float;color:longint;
                            style:integer;var pu:typeUO);
begin
  createPgObject(stName,pu,TstmSymb);

  TstmSymb(pu).rec.x0:=x;
  TstmSymb(pu).rec.y0:=y;
  TstmSymb(pu).color:=color;
  TstmSymb(pu).rec.style0:=style;
end;

Procedure proTsymbol_create_1(x,y:float;color:longint; style:integer;var pu:typeUO);
begin
  proTsymbol_create('',x,y,color, style, pu);
end;

Function fonctionTsymbol_x(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tstmsymb(pu).rec.x0;
end;

Procedure proTsymbol_x(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Tstmsymb(pu).rec.x0:=w;
end;

Function fonctionTsymbol_y(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tstmsymb(pu).rec.y0;
end;

Procedure proTsymbol_y(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Tstmsymb(pu).rec.y0:=w;
end;

Function fonctionTsymbol_style(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tstmsymb(pu).rec.style0;
end;

Procedure proTsymbol_style(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tstmsymb(pu).rec.style0:=w;
end;

Function fonctionTsymbol_size(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tstmsymb(pu).rec.size0;
end;

Procedure proTsymbol_size(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tstmsymb(pu).rec.size0:=w;
end;

{**************************** Méthodes stm de TstmEllipse *****************************}

Procedure proTEllipse_create(x,y:float;w,h,color:integer;var pu:typeUO);
begin
  createPgObject('',pu,TstmEllipse);

  TstmEllipse(pu).rec.x0:=x;
  TstmEllipse(pu).rec.y0:=y;
  TstmEllipse(pu).color:=color;
  TstmEllipse(pu).rec.pixWidth0:=w;
  TstmEllipse(pu).rec.pixHeight0:=h;
end;


Function fonctionTEllipse_x(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TstmEllipse(pu).rec.x0;
end;

Procedure proTEllipse_x(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TstmEllipse(pu).rec.x0:=w;
end;

Function fonctionTEllipse_y(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TstmEllipse(pu).rec.y0;
end;

Procedure proTEllipse_y(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TstmEllipse(pu).rec.y0:=w;
end;


Function fonctionTellipse_pixwidth(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TstmEllipse(pu).rec.pixwidth0;
end;

Procedure proTellipse_pixwidth(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tstmellipse(pu).rec.pixwidth0:=w;
end;

Function fonctionTellipse_pixheight(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TstmEllipse(pu).rec.pixheight0;
end;

Procedure proTellipse_pixheight(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TstmEllipse(pu).rec.pixheight0:=w;
end;

Function fonctionTellipse_lineWidth(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tstmellipse(pu).rec.penWidth0;
end;

Procedure proTellipse_lineWidth(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tstmellipse(pu).rec.penWidth0:=w;
end;

Function fonctionTellipse_BrushStyle(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tstmellipse(pu).rec.brushStyle0;
end;

Procedure proTellipse_BrushStyle(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tstmellipse(pu).rec.BrushStyle0:=w;
end;

{**************************** Méthodes stm de TbarSymbol *****************************}

Procedure proTbarSymbol_create(x,y,dx,dy,theta:float;color:integer;var pu:typeUO);
begin
  createPgObject('',pu,TbarSymbol);

  TbarSymbol(pu).deg.x:=x;
  TbarSymbol(pu).deg.y:=y;
  TbarSymbol(pu).deg.dx:=dx;
  TbarSymbol(pu).deg.dy:=dy;
  TbarSymbol(pu).deg.theta:=theta;
  TbarSymbol(pu).color:=color;
end;


Function fonctionTbarSymbol_x(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TbarSymbol(pu).deg.x;
end;

Procedure proTbarSymbol_x(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TbarSymbol(pu).deg.x:=w;
end;

Function fonctionTbarSymbol_y(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TbarSymbol(pu).deg.y;
end;

Procedure proTbarSymbol_y(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TbarSymbol(pu).deg.y:=w;
end;


Function fonctionTbarSymbol_dx(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TbarSymbol(pu).deg.dx;
end;

Procedure proTbarSymbol_dx(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TbarSymbol(pu).deg.dx:=w;
end;

Function fonctionTbarSymbol_dy(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TbarSymbol(pu).deg.dy;
end;

Procedure proTbarSymbol_dy(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TbarSymbol(pu).deg.dy:=w;
end;

Function fonctionTbarSymbol_theta(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TbarSymbol(pu).deg.theta;
end;

Procedure proTbarSymbol_theta(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TbarSymbol(pu).deg.theta:=w;
end;



{*********************************** Méthodes stm de TlineHor ***************************}

Procedure proTlineHor_create(stName:AnsiString;y0:float;color:longint;style:integer;var pu:typeUO);
begin
  createPgObject(stName,pu,TlineHor);

  TlineHor(pu).rec.pos0:=y0;
  TlineHor(pu).color:=color;
  TlineHor(pu).rec.style0:=style;
end;

Procedure proTlineHor_create_1(y0:float;color:longint;style:integer;var pu:typeUO);
begin
  proTlineHor_create('',y0,color,style, pu);
end;

Function fonctionTlineHor_y(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TlineHor(pu).rec.pos0;
end;

Procedure proTlineHor_y(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TlineHor(pu).rec.pos0:=w;
end;

Function fonctionTlineHor_style(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TlineHor(pu).rec.style0;
end;

Procedure proTlineHor_style(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TlineHor(pu).rec.style0:=w;
end;

Function fonctionTlineHor_width(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TlineHor(pu).rec.width0;
end;

Procedure proTlineHor_width(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TlineHor(pu).rec.width0:=w;
end;


Procedure proTlineVer_create(stName:AnsiString;y0:float;color:longint;
                             style:integer;var pu:typeUO);
begin
  createPgObject(stName,pu,TlineVer);

  TlineVer(pu).rec.pos0:=y0;
  TlineVer(pu).color:=color;
  TlineVer(pu).rec.style0:=style;
end;

Procedure proTlineVer_create_1(y0:float;color:longint;style:integer;var pu:typeUO);
begin
  proTlineVer_create('',y0,color,style, pu);
end;


Function fonctionTlineVer_x(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TlineVer(pu).rec.pos0;
end;

Procedure proTlineVer_x(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TlineVer(pu).rec.pos0:=w;
end;

Function fonctionTlineVer_style(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TlineVer(pu).rec.style0;
end;

Procedure proTlineVer_style(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TlineVer(pu).rec.style0:=w;
end;

Function fonctionTlineVer_width(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TlineHor(pu).rec.width0;
end;

Procedure proTlineVer_width(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TlineHor(pu).rec.width0:=w;
end;



Procedure proTlinearFunc_create(stName:AnsiString;a,b:float;color:longint;
                                style:integer;var pu:typeUO);
begin
  createPgObject(stName,pu,TlinearFunc);

  TlinearFunc(pu).rec.a:=a;
  TlinearFunc(pu).rec.b:=b;
  TlinearFunc(pu).color:=color;
  TlinearFunc(pu).rec.style0:=style;
end;

Procedure proTlinearFunc_create_1(a,b:float;color:longint; style:integer;var pu:typeUO);
begin
  proTlinearFunc_create('',a,b,color, style , pu);
end;

Function fonctionTlinearFunc_a(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TlinearFunc(pu).rec.a;
end;

Procedure proTlinearFunc_a(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TlinearFunc(pu).rec.a:=w;
end;

Function fonctionTlinearFunc_b(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TlinearFunc(pu).rec.b;
end;

Procedure proTlinearFunc_b(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TlinearFunc(pu).rec.b:=w;
end;

Function fonctionTlinearFunc_style(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TlinearFunc(pu).rec.style0;
end;

Procedure proTlinearFunc_style(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TlinearFunc(pu).rec.style0:=w;
end;

Function fonctionTlinearFunc_width(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TlinearFunc(pu).rec.width0;
end;

Procedure proTlinearFunc_width(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TlinearFunc(pu).rec.width0:=w;
end;



Procedure proTline_create(stName:AnsiString;x1a,y1a,x2a,y2a:float;color:longint;style:integer;var pu:typeUO);
begin
  createPgObject(stName,pu,Tline);

  Tline(pu).rec.x1:=x1a;
  Tline(pu).rec.y1:=y1a;
  Tline(pu).rec.x2:=x2a;
  Tline(pu).rec.y2:=y2a;

  Tline(pu).color:=color;
  Tline(pu).rec.style0:=style;
end;

Procedure proTline_create_1(x1a,y1a,x2a,y2a:float;color:longint;style:integer;var pu:typeUO);
begin
  proTline_create('',x1a,y1a,x2a,y2a,color,style,pu);

end;


Function fonctionTline_x1(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tline(pu).rec.x1;
end;

Procedure proTline_x1(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Tline(pu).rec.x1:=w;
end;

Function fonctionTline_y1(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tline(pu).rec.y1;
end;

Procedure proTline_y1(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Tline(pu).rec.y1:=w;
end;


Function fonctionTline_x2(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tline(pu).rec.x2;
end;

Procedure proTline_x2(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Tline(pu).rec.x2:=w;
end;

Function fonctionTline_y2(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tline(pu).rec.y2;
end;

Procedure proTline_y2(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  Tline(pu).rec.y2:=w;
end;

Function fonctionTline_style(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tline(pu).rec.style0;
end;

Procedure proTline_style(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tline(pu).rec.style0:=w;
end;

Function fonctionTline_width(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=Tline(pu).rec.width0;
end;

Procedure proTline_width(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tline(pu).rec.width0:=w;
end;







Initialization
AffDebug('Initialization stmSymbs1',0);

registerObject(TlineHor,data);
registerObject(TlineVer,data);
registerObject(TstmSymb,data);
registerObject(TlinearFunc,data);
registerObject(Tline,data);

end.
