unit stmcurs;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,controls,forms,menus,
     util1,Dgraphic,debug0,BMex1,
     varconf1,stmdef,stmobj,stmData0,stmDplot,stmDobj1,
     curProp1,stmvec1,Ncdef2,Dtrace1,
     stmPopUp,
     stmPg;

{ Les paramètres du curseur sont dans CurProp1 . (TcurRec)

  Le curseur travaille sur un objet TdataPlot (stmDplot)
                       ou un objet TdataObj (stmDobj1) pour certains modes.

  La Position est dans rec.p0 . Position est en valeurs réelles pour les
  styles X ou Y, mais en indices pour le mode Index.
}

type

  TLcursor= class(Tdata0)
               rec:TcurRec;
               refB,zoomB:typeUO;

               PgOnChange:Tpg2Event;

               vertical:boolean;
               xcur:array[1..2] of float;
               Captionrect:array[1..2] of Trect;

               OnClk:Tpg2Event;

               Fcapture:boolean;
               NumCap:integer;
               deltaCap:integer;
               IrectCap:Trect;

               Shift0: TShiftState;
               Fonclick:procedure (num:integer;shift:TshiftState) of object;


                 {utilisé par TcursorList}
               constructor create;override;
               destructor destroy;override;
               class function STMClassName:AnsiString;override;
               procedure FreeRef;override;



               procedure adjustRefAndZoom;
               procedure calculePositions;

               procedure saveRects(BMex:TbitmapEx);
               procedure paintCursor(BMex:TbitmapEx);override;

               procedure createForm;override;
               function CursorForm:Tform;

               procedure Fmodify(num:integer;x:float);

               procedure Finvalidate2;
               { Finvalidate2 a pour effet d'invalider  toutes les régions de toutes
                 les fenêtres ou se trouve le curseur.
                 Finvalidate2 invalide aussi les objets associés.
                 On doit l'appeler après une modif.
               }
               procedure initParams;
               function getCaption(num:integer):AnsiString;
               procedure ChangeObRef(ref:typeUO);
               procedure ChangeZoomVec(ref:typeUO);
               procedure centrer(num:integer);

               function showModal:integer;

               procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
               procedure completeLoadInfo;override;
               procedure RetablirReferences(list:Tlist);override;
               procedure ClearReferences;override;
               procedure processMessage(id:integer;source:typeUO;p:pointer);override;

               function GetPosition(n:integer):float;
               procedure SetPosition(n:integer;x:float);

               function GetXPosition(n:integer):float;
               procedure SetXPosition(n:integer;x:float);

               function GetYPosition(n:integer):float;
               procedure SetYPosition(n:integer;x:float);


               function ScreenToPos(w:integer):float;

               function MouseDownMG2(Irect:Trect;
                   Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean; override;
               function MouseMoveMG2(x,y:integer):boolean;override;
               procedure MouseUpMG2(x,y:integer);override;

               function MouseRightMG2(numOrdre:integer;Irect:Trect;
                   Shift: TShiftState; Xc,Yc,X,Y: Integer;
                   var uoMenu:typeUO):boolean;override;


               function getPopUp:TpopupMenu;override;
               procedure Proprietes(sender:Tobject);

               procedure installSource(w:TypeUO);
               procedure installZoom(w:TypeUO);

               property position[n:integer]:float read GetPosition write SetPosition;
               property Xposition[n:integer]:float read GetXPosition write SetXPosition;
               property Yposition[n:integer]:float read GetYPosition write SetYPosition;

               procedure setEmbedded(v:boolean);override;
               function ActiveEmbedded(TheParent:TwinControl; x1,y1,w1,h1:integer):Trect;override;
               procedure UnActiveEmbedded;override;


             end;



procedure proTcursor_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTcursor_create_1(var pu:typeUO);pascal;

procedure proTcursor_position1(w:float;var pu:typeUO);pascal;
function fonctionTcursor_position1(var pu:typeUO):float;pascal;

procedure proTcursor_position2(w:float;var pu:typeUO);pascal;
function fonctionTcursor_position2(var pu:typeUO):float;pascal;

procedure proTcursor_position(i:smallint;w:float;var pu:typeUO);pascal;
function fonctionTcursor_position(i:smallint;var pu:typeUO):float;pascal;

procedure proTcursor_Xposition1(w:float;var pu:typeUO);pascal;
function fonctionTcursor_Xposition1(var pu:typeUO):float;pascal;

procedure proTcursor_Xposition2(w:float;var pu:typeUO);pascal;
function fonctionTcursor_Xposition2(var pu:typeUO):float;pascal;

procedure proTcursor_Xposition(i:smallint;w:float;var pu:typeUO);pascal;
function fonctionTcursor_Xposition(i:smallint;var pu:typeUO):float;pascal;

procedure proTcursor_Yposition1(w:float;var pu:typeUO);pascal;
function fonctionTcursor_Yposition1(var pu:typeUO):float;pascal;

procedure proTcursor_Yposition2(w:float;var pu:typeUO);pascal;
function fonctionTcursor_Yposition2(var pu:typeUO):float;pascal;

procedure proTcursor_Yposition(i:smallint;w:float;var pu:typeUO);pascal;
function fonctionTcursor_Yposition(i:smallint;var pu:typeUO):float;pascal;



procedure proTcursor_posMin(w:float;var pu:typeUO);pascal;
function fonctionTcursor_posMin(var pu:typeUO):float;pascal;

procedure proTcursor_posMax(w:float;var pu:typeUO);pascal;
function fonctionTcursor_posMax(var pu:typeUO):float;pascal;

procedure proTcursor_SmallIncrement(w:float;var pu:typeUO);pascal;
function fonctionTcursor_SmallIncrement(var pu:typeUO):float;pascal;

procedure proTcursor_LargeIncrement(w:float;var pu:typeUO);pascal;
function fonctionTcursor_LargeIncrement(var pu:typeUO):float;pascal;

procedure proTcursor_visible(w:boolean;var pu:typeUO);pascal;
function fonctionTcursor_visible(var pu:typeUO):boolean;pascal;

procedure proTcursor_Locked(w:boolean;var pu:typeUO);pascal;
function fonctionTcursor_Locked(var pu:typeUO):boolean;pascal;

procedure proTcursor_style(w:smallint;var pu:typeUO);pascal;
function fonctionTcursor_style(var pu:typeUO):smallint;pascal;

procedure proTcursor_WinContent(w:smallint;var pu:typeUO);pascal;
function fonctionTcursor_WinContent(var pu:typeUO):smallint;pascal;

procedure proTcursor_TrackSource(w:boolean;var pu:typeUO);pascal;
function fonctionTcursor_TrackSource(var pu:typeUO):boolean;pascal;

procedure proTcursor_color(w:longint;var pu:typeUO);pascal;
function fonctionTcursor_color(var pu:typeUO):longint;pascal;

procedure proTcursor_CaptionColor(w:longint;var pu:typeUO);pascal;
function fonctionTcursor_CaptionColor(var pu:typeUO):longint;pascal;


procedure proTcursor_InstallSource(var w:TypeUO;var pu:typeUO);pascal;
procedure proTcursor_InstallZoom(var w:TypeUO;var pu:typeUO);pascal;

procedure proTcursor_title(w:AnsiString;var pu:typeUO);pascal;
function fonctionTcursor_title(var pu:typeUO):AnsiString;pascal;

procedure proTcursor_doubleCursor(w:boolean;var pu:typeUO);pascal;
function fonctionTcursor_doubleCursor(var pu:typeUO):boolean;pascal;


procedure proTcursor_decimal(w:smallint;var pu:typeUO);pascal;
function fonctionTcursor_decimal(var pu:typeUO):smallint;pascal;

procedure proTcursor_WindowWidth(w:smallint;var pu:typeUO);pascal;
function fonctionTcursor_WindowWidth(var pu:typeUO):smallint;pascal;

procedure proTcursor_OnChange(w:integer;var pu:typeUO);pascal;
function fonctionTcursor_OnChange(var pu:typeUO):integer;pascal;

procedure proTcursor_OnClick(p:integer;var pu:typeUO);pascal;
function fonctionTcursor_OnClick(var pu:typeUO):integer;pascal;

function fonctionTcursor_ShowModal(var pu:typeUO):integer;pascal;

procedure proCurseurX(var pu:typeUO;var xx:float;titre:AnsiString);pascal;
procedure proCurseurY(var pu:typeUO;var xx:float;titre:AnsiString);pascal;

implementation

uses cursor1;

constructor TLcursor.create;
begin
  with rec do
  begin
    color:=clBlue;
    capColor:=clBlack;

    dxC1:=1;
    dxC2:=10;
    di1:=1;
    di2:=10;
    xminC:=0;
    xmaxC:=10000;

    deci:=6;
    Wwidth:=320;
    showSB:=true;
  end;


  inherited create;
end;

destructor TLcursor.destroy;
begin
  messageToRef(UOmsg_destroy,nil);
  ChangeObRef(nil);
  ChangeZoomVec(nil);

  inherited destroy;
end;

procedure TLcursor.freeRef;
begin
  installSource(nil);
  installZoom(nil);

end;

class function TLcursor.STMClassName:AnsiString;
begin
  STMClassName:='Cursor';
end;


procedure TLcursor.setPosition(n:integer;x:float);
begin
  if x<rec.xminC then x:=rec.xminC;
  if x>rec.xmaxC then x:=rec.xmaxC;

  rec.p0[n]:=x;
  if assigned(form) then
    with TlineCursor(form) do UpdateCtrls(n);
  Finvalidate2;
end;

function TLcursor.GetPosition(n:integer):float;
begin
  result:=rec.p0[n];
end;

procedure TLcursor.setXPosition(n:integer;x:float);
begin
  if assigned(rec.obref) and (rec.obref is Tvector) and (rec.style=csIndex)
    then position[n]:=Tvector(rec.ObRef).invconvx(x)
    else position[n]:=x;
end;

function TLcursor.GetXPosition(n:integer):float;
begin
  if assigned(rec.obref) and (rec.obref is Tvector) and (rec.style=csIndex)
    then result:=Tvector(rec.ObRef).convx(roundL(position[n]))
    else result:=position[n];
end;

procedure TLcursor.setYPosition(n:integer;x:float);
begin
  if rec.style=csY
    then position[n]:=x;
end;

function TLcursor.GetYPosition(n:integer):float;
begin
  if assigned(rec.obref) and (rec.obref is Tvector) and (rec.style=csIndex)
    then result:=Tvector(rec.ObRef).Yvalue[roundL(position[n])]
    else result:=position[n];
end;


procedure TLcursor.SaveRects(BMex:TbitmapEx);
var
  rr:Trect;
  i,k,nb:integer;
begin
  if not assigned(BMex) then exit;

  nb:=ord(rec.double)+1;

  if vertical then
    for i:=1 to nb do
    begin
      k:=convWx(xcur[i]);
      rr:=rect(LeftGlb+k,TopGlb+y1act,LeftGlb+k+1,TopGlb+y2act);

      BMex.saveRect(rr);

      rr:=captionRect[i];
      inc(rr.left,leftGlb+x1act);
      inc(rr.right,leftGlb+x1act);
      inc(rr.top,topGlb+y1act);
      inc(rr.bottom,topGlb+y1act);

      BMex.saveRect(rr);
    end
  else
  for i:=1 to nb do
    begin
      k:=convWy(xcur[i]);
      rr:=rect(LeftGlb+x1act,TopGlb+k,LeftGlb+x2act,TopGlb+k+1);

      BMex.saveRect(rr);

      rr:=captionRect[i];
      inc(rr.left,leftGlb+x1act);
      inc(rr.right,leftGlb+x1act);
      inc(rr.top,topGlb+y1act);
      inc(rr.bottom,topGlb+y1act);

      BMex.saveRect(rr);
    end
end;


procedure TLcursor.paintCursor(BMex:TbitmapEx);
var
  i:integer;
  color1,color2:integer;
begin
  if not rec.visible then exit;

  calculePositions;

  SaveRects(BMex);

  if PRprinting and PRmonochrome then
    begin
      color1:=clBlack;
      color2:=clWHite;
    end
  else
    begin
      color1:=rec.color;
      color2:=rec.capColor;
    end;                                                       

  if not vertical then
    begin
       linehor(xcur[1],color1,false);
       if rec.double then linehor(xcur[2],color1,false);
    end
  else
    begin
      linever(xcur[1],color1,false);
      if rec.double then linever(xcur[2],color1,false);
    end;

  canvasGlb.pen.color:=color1;
  canvasGlb.brush.color:=Color2;

  with CaptionRect[1] do
  canvasGlb.roundRect(x1act+left,y1act+top,x1act+right,y1act+bottom,4,4);

  if rec.double then
    with CaptionRect[2] do
    canvasGlb.roundRect(x1act+left,y1act+top,x1act+right,y1act+bottom,4,4);

end;

procedure TLcursor.calculePositions;
var
  i,i0,j0:integer;
begin
  {la fenêtre sélectionnée est le cadre intérieur}
  with rec do
  begin
    vertical:=style<>csY;
    xcur[1]:=p0[1];
    xcur[2]:=p0[2];

    if style=csIndex then
      if assigned(obref) and (obref is Tvector) then
        with Tvector(obref) do
        begin
          if modeT=DM_evt1 then
            begin
              if inrangeI(roundL(p0[1]))
                then xcur[1]:=Yvalue[roundL(p0[1])]
                else xcur[1]:=0;
            end
          else xcur[1]:=convx(roundL(p0[1]));

          if double then
            begin
              if modeT=DM_evt1 then
                begin
                  if inrangeI(roundL(p0[2]))
                    then xcur[2]:=Yvalue[roundL(p0[2])]
                    else xcur[2]:=0;
                end
              else xcur[2]:=convx(roundL(p0[2]));
            end;
        end;
  end;

  {CaptionRect contient les coo du caption dans le rectangle intérieur}
  if vertical then
  for i:=1 to 2 do
    begin
      i0:=convWx(xcur[i])-x1act;
      j0:=y2act-10-y1act;
      CaptionRect[i]:=rect(i0-5,j0-3,i0+5,j0+3);
    end
  else
  for i:=1 to 2 do
    begin
      j0:=convWy(xcur[i])-y1act;
      i0:=10;
      CaptionRect[i]:=rect(i0-3,j0-5,i0+3,j0+5);
    end;

end;

function TLcursor.ScreenToPos(w:integer):float;
begin
  with rec do
  begin
    case style of
      csX: result:=invConvWx(w);
      csY: result:=invConvWy(w);
      csIndex:
        if assigned(obref) and (obref is Tvector) then
          with Tvector(obref) do
          begin
            if modeT=DM_evt1 then
              begin
                result:=invconvWx(w);
                result:=getFirstEvent(result);
              end
            else result:=invconvx(invconvWx(w));

          end
        else result:=0;
    end;
  end;
end;

function TLcursor.MouseDownMG2(Irect:Trect;
                   Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean;
var
  i,x1,y1:integer;
begin
  shift0:=shift;
  {coo du clic dans le rectangle intérieur}
  x1:=x+x1act-Irect.left;
  y1:=y+y1act-Irect.top;


  result:=false;
  Fcapture:=false;

  if not rec.visible then exit;

  with Irect do setWindow(left,top,right,bottom);
  with rec.obref do Dgraphic.setWorld(Xmin,Ymin,Xmax,Ymax);

  calculePositions;

  for i:=1 to 2 do
    if ptInRect(CaptionRect[i],classes.point(x1,y1)) then
      begin
        Fcapture:=true;
        NumCap:=i;
        IrectCap:=Irect;

        if vertical then DeltaCap:=x1act+x1-ConvWx(xcur[i])
                    else DeltaCap:=y1act+y1-ConvWy(xcur[i]);
        result:=true;

      end;

  {affdebug('MouseDownMG2 FALSE '+Istr(x)+'/'+Istr(y)+' '
                  +Istr(CaptionRect[1].left)+'/'+Istr(CaptionRect[1].top));}
end;

function TLcursor.MouseMoveMG2(x,y:integer):boolean;
begin
  result:=Fcapture;

  if result and not rec.CurLocked then
    begin
      with IrectCap do setWindow(left,top,right,bottom);
      with rec.obref do Dgraphic.setWorld(Xmin,Ymin,Xmax,Ymax);

      if vertical then
        begin
          x:=x-deltaCap;
          if x<IrectCap.left then x:=IrectCap.left;
          if x>IrectCap.right then x:=IrectCap.right;
          Position[numCap]:=screenToPos(x);
        end
      else
        begin
          y:=y-DeltaCap;
          if y<IrectCap.top then y:=IrectCap.top;
          if y>IrectCap.bottom then y:=IrectCap.bottom;
          Position[numCap]:=screenToPos(y);
        end;
    end;

end;

procedure TLcursor.MouseUpMG2(x,y:integer);
begin
  if Fcapture then
    begin
      with onClk do
        if valid then pg.executerProcedure1(ad,tagUO);
      if assigned(Fonclick) then FonClick(tagUO,shift0);
      Finvalidate2;
    end;
  Fcapture:=false;
end;

function TLcursor.MouseRightMG2(numOrdre:integer;Irect:Trect;
                Shift: TShiftState; Xc,Yc,X,Y: Integer;var uoMenu:typeUO):boolean;
var
  i,x1,y1:integer;
  x10,y10,x20,y20:integer;
begin
  getWindowG(x10,y10,x20,y20);

  {coo du clic dans le rectangle intérieur}
  x1:=x+x1act-Irect.left;
  y1:=y+y1act-Irect.top;

  result:=false;
  uoMenu:=nil;

  if not rec.visible then exit;

  with Irect do setWindow(left,top,right,bottom);
  with rec.obref do Dgraphic.setWorld(Xmin,Ymin,Xmax,Ymax);

  calculePositions;

  for i:=1 to 2 do
    if ptInRect(CaptionRect[i],classes.point(x1,y1)) then
      begin
        result:=true;
        uoMenu:=self;
      end;

  setWindow(x10,y10,x20,y20);
end;


procedure TLcursor.adjustRefAndZoom;
var
  x,x1,x2,delta:float;
begin
  with rec do
  begin
    case style of
      csY:  begin
              exit;
            end;
      csX:  begin
              x:=p0[1];
            end;
      csIndex:
            if assigned(obref) and (obref is Tvector) then
              with Tvector(obref) do
              begin
                if (modeT=DM_evt1) then
                  begin
                    if inrangeI(roundL(p0[1]))
                      then x:=Yvalue[roundL(p0[1])]
                      else x:=0;
                  end
                else x:=convx(roundL(p0[1]));
              end;
    end;

    if assigned(obref) and trackSource then
      with obref do
      begin
        if x<Xmin then
          begin
            delta:=Xmax-Xmin;
            while x<Xmin do
            begin
              Xmin:=Xmin-delta;
              Xmax:=Xmax-delta;
            end;
            messageCpx;
            invalidate;
          end
        else
        if x>Xmax then
          begin
            delta:=Xmax-Xmin;
            while x>Xmax do
            begin
              Xmin:=Xmin+delta;
              Xmax:=Xmax+delta;
            end;
            messageCpx;
            invalidate;
          end
      end;

    if assigned(zoomVec) and (zoomVec is Tvector) then
      with Tvector(ZoomVec) do
      begin
        delta:=(Xmax-Xmin)/2;
        X1:=x-delta;
        X2:=x+delta;
        if (x1<>Xmin) or (x2<>Xmax) then
          begin
            Xmin:=x1;
            Xmax:=x2;
            invalidate;
          end;
      end;

  end;
end;


procedure TLcursor.Fmodify(num:integer;x:float);
begin
  rec.p0[num]:=x;
  Finvalidate2;
end;



procedure TLcursor.Finvalidate2;
begin
  with rec do
  begin
    if assigned(obref) then
      begin
        obref.invalidateCursors;

        adjustRefAndZoom;
        with pgOnChange do
        if valid then pg.executerProcedure1(ad,tagUO);
      end;
  end;
end;


procedure TLcursor.ChangeObRef(ref:typeUO);
begin

  if assigned(rec.obref) and rec.visible then
      begin
        rec.visible:=false;
        rec.obref.invalidateCursors;
        rec.visible:=true;
      end;

  derefObjet(typeUO(rec.obRef));
  rec.obref:=TdataPlot(ref);
  refobjet(Ref);
  Finvalidate2;
end;

procedure TLcursor.ChangeZoomVec(ref:typeUO);
begin
  derefObjet(typeUO(rec.zoomVec));
  rec.zoomVec:=TdataPlot(ref);
  refobjet(Ref);
  Finvalidate2;
end;

procedure TLcursor.centrer(num:integer);
begin
  with rec do
  if style=csY
    then YPosition[num]:=(obref.Ymin+obref.Ymax)/2
    else XPosition[num]:=(obref.Xmin+obref.Xmax)/2;
end;

procedure TLcursor.initParams;
begin
  with rec do
  begin
    if dxc1<=0 then dxc1:=1;
    if dxc2<=0 then dxc2:=1;


    if assigned(obref) and (obref is Tvector) then
      with Tvector(obref) do
      begin
        case Style of
          csX: if xminC>=XmaxC then
               begin
                xminC:=Xstart;
                xmaxC:=Xend;
              end;
          csY:begin
                xminC:=-1E6;
                xmaxC:=1E6;
              end;
          csIndex:
              begin
                xminC:=Istart;
                xmaxC:=Iend;

                dxc1:=roundL(dxC1);
                if dxc1<=0 then dxc1:=1;

                dxc2:=roundL(dxC2);
                if dxc2<=0 then dxc2:=10;
              end;
        end;
      end
    else
      begin
        xminC:=-dxC1*10000;
        xmaxC:=dxC1*10000;
      end;
  end;
end;

function TLcursor.getCaption(num:integer):AnsiString;
var
  I1,I2:integer;
  x1,x2:float;
  valid1,valid2:boolean;
begin
  result:='';
  with rec do
  begin
    x1:=p0[1];
    x2:=p0[2];
    { Règler d'abord les styles simples }

    case style of
      csX: begin
             case num of
               1: result:='x1='+Estr(x1,deci);
               2: result:='x2='+Estr(x2,deci);
               3: result:='x2-x1='+Estr(x2-x1,deci);
             end;
             exit;
           end;
      csY: begin
             case num of
               1: result:='y1='+Estr(x1,deci);
               2: result:='y2='+Estr(x2,deci);
               3: result:='y2-y1='+Estr(x2-x1,deci);
             end;
             exit;
           end;
    end;

    if not assigned(obref) OR not (obref is Tvector) then exit;
    { Les autres styles s'appliquent aux vecteurs (plus tard aux matrices) }

    I1:=roundL(p0[1]);
    I2:=roundL(p0[2]);
    X1:=Tvector(obref).convx(I1);
    X2:=Tvector(obref).convx(I2);

    valid1:=Tvector(obref).inrangeI(I1);
    valid2:=Tvector(obref).inrangeI(I2);


    case winContent of
      wcI: case num of
             1: result:='I1='+Istr(I1);
             2: result:='I2='+Istr(I2);
             3: result:='I2-I1='+Istr(I2-I1);
            end;

      wcJ: case num of
             1: if valid1 then result:='J1='+Estr(Tvector(obref).Jvalue[I1],deci);
             2: if valid2 then result:='J2='+Estr(Tvector(obref).Jvalue[I1],deci);
             3: if valid1 and valid2 then
                 result:='J2-J1='+Estr( Tvector(obref).Jvalue[I2]
                                      -Tvector(obref).Jvalue[I1],deci);
            end;

      wcX: case num of
             1: result:='X1='+Estr(X1,deci);
             2: result:='X2='+Estr(X2,deci);
             3: result:='X2-X1='+Estr(X2-X1,deci);
            end;

      wcY: case num of
             1: if valid1 then result:='Y1='+Estr(Tvector(obref).Yvalue[I1],deci);
             2: if valid2 then result:='Y2='+Estr(Tvector(obref).Yvalue[I1],deci);
             3: if valid1 and valid2 then
                  result:='Y2-Y1='+Estr( Tvector(obref).Yvalue[I2]
                                      -Tvector(obref).Yvalue[I1],deci);
            end;

      wcIpJ:
           case num of
             1: begin
                  result:= 'I1='+Istr(I1)+'   ';
                  if valid1 then result:=result+'J1='+Istr(Tvector(obref).Jvalue[I1]);
                end;
             2: begin
                  result:= 'I2='+Istr(I2)+'   ';
                  if valid2 then result:=result+'J2='+Istr(Tvector(obref).Jvalue[I2]);
                end;
             3: begin
                  result:= 'I2-I1='+Istr(I2-I1)+'   ';
                  if valid1 and valid2 then result:=result+
                         'J2-J1='+Istr( Tvector(obref).Jvalue[I2]
                                      -Tvector(obref).Jvalue[I1]);
                end;
            end;

      wcIpX:
           case num of
             1: result:= 'I1='+Istr(I1)+'   '+
                         'X1='+Estr(X1,deci);
             2: result:= 'I2='+Istr(I2)+'   '+
                         'X2='+Estr(X2,deci);
             3: result:= 'I2-I1='+Istr(I2-I1)+'   '+
                         'X2-X1='+Estr( X2-X1,deci);
            end;

      wcIpY:
           case num of
             1: begin
                  result:= 'I1='+Istr(I1)+'   ';
                  if valid1 then result:=result+
                         'Y1='+Estr(Tvector(obref).Yvalue[I1],deci);
                end;
             2: begin
                  result:= 'I2='+Istr(I2)+'   ';
                  if valid2 then result:=result+
                         'Y2='+Estr(Tvector(obref).Yvalue[I2],deci);
                end;
             3: begin
                  result:= 'I2-I1='+Istr(I2-I1)+'   ';
                  if valid1 and valid2 then result:=result+
                         'Y2-Y1='+Estr( Tvector(obref).Yvalue[I2]
                                      -Tvector(obref).Yvalue[I1],deci);
                end;
            end;


      wcXpY:
           case num of
             1: begin
                  result:= 'X1='+Estr(X1,deci)+'   ';
                  if valid1 then result:=result+
                         'Y1='+Estr(Tvector(obref).Yvalue[I1],deci);
                end;
             2: begin
                  result:= 'X2='+Estr(X2,deci)+'   ';
                  if valid2 then result:=result+
                         'Y2='+Estr(Tvector(obref).Yvalue[I2],deci);
                end;
             3: begin
                  result:= 'X2-X1='+Estr(X2-X1,deci)+'   ';
                  if valid1 and valid2 then result:=result+
                         'Y2-Y1='+Estr( Tvector(obref).Yvalue[I2]
                                      -Tvector(obref).Yvalue[I1],deci);
                end;
            end;

    end;
  end;
end;

function TLcursor.showModal:integer;
begin
  if Fembedded then exit;

  if not assigned(form) then createForm;

  TlineCursor(form).Fmodale:=true;

  rec.visible:=true;
  if assigned(rec.obref) then rec.obref.invalidateCursors;
  showModal:=form.showModal;

  rec.visible:=false;
  if assigned(rec.obref) then rec.obref.invalidateCursors;
end;

procedure TLcursor.createForm;
begin
  form:=TlineCursor.create(formStm);
  with TlineCursor(form) do
  begin
    ownerC:=self;
    caption:=ident;
  end;
end;

function TLcursor.CursorForm:Tform;
begin
  if not assigned(form) then createForm;
  result:=form;
end;

procedure TLcursor.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setvarconf('CurRec',Rec,sizeof(Rec));
  end;
end;

procedure TLcursor.completeLoadInfo;
begin
  {On range la référence dans une variable auxiliaire et on met la référence à nil.
   De cette façon, si rétablirReferences ne change pas la référence, on ne risque pas
   de pointer sur n'importe quoi.
  }
  refB:=Rec.ObRef;
  zoomB:=Rec.ZoomVec;

  Rec.ObRef:=nil;
  Rec.ZoomVec:=nil;

  inherited;
end;

procedure TLcursor.RetablirReferences(list:Tlist);
var
  i:integer;
  p:pointer;
begin
  for i:=0 to list.count-1 do
    begin
     p:=typeUO(list.items[i]).myAd;
     if p=refB then
       begin
         rec.obref:=list.items[i];
         refObjet(rec.obref);
       end;
     if p=zoomB then
       begin
         rec.zoomVec:=list.items[i];
         refObjet(rec.zoomVec);
       end;
    end;

  initParams;
  recupForm;

end;

procedure TLcursor.ClearReferences;
begin
  rec.obref:=nil;
  rec.ZoomVec:=nil;
end;

procedure TLcursor.processMessage(id:integer;source:typeUO;p:pointer);
var
  i:integer;
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        if (rec.obref=source) then installSource(nil);
        if (rec.zoomVec=source) then installZoom(nil);

      end;
    UOmsg_invalidate,UOmsg_invalidateData:
      begin
        if (rec.obref=source) then
          begin
            if assigned(form) then
              begin
                TLineCursor(form).initData;
                //for i:=1 to 2 do TlineCursor(form).UpdateCtrls(i);
                adjustRefAndZoom;
                with pgOnChange do
                if valid then pg.executerProcedure1(ad,tagUO);
              end
            else initParams;
          end;
      end;

  end;
end;

function TLcursor.getPopUp:TpopupMenu;
begin
  with PopUps do
  begin
    PopUpItem(pop_Tcursor,'Tcursor_Show').onclick:=self.Show;
    PopUpItem(pop_Tcursor,'Tcursor_Properties').onclick:=Proprietes;

    result:=pop_Tcursor;
  end;
end;

procedure TLcursor.Proprietes(sender:Tobject);
begin
  if not assigned(form) then createForm;
  TLineCursor(form).BpropClick(sender);
end;

procedure TLcursor.installSource(w:TypeUO);
begin
  ChangeObRef(w);
  if assigned(form)
    then with TlineCursor(form) do init(Bprop.Visible)
    else initParams;

end;


procedure TLcursor.installZoom(w:TypeUO);
begin
  ChangeZoomVec(w);
end;


{******************* Méthodes Stm de TCursor ******************************}

var
  E_indicePos:integer;
  E_increment:integer;
  E_style:integer;
  E_decimal:integer;
  E_Wwidth:integer;
  E_winContent:integer;

procedure proTcursor_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TLcursor);
end;

procedure proTcursor_create_1(var pu:typeUO);
begin
  proTcursor_create('', pu);
end;

procedure proTcursor_position1(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu) do Position[1]:=w;
end;

function fonctionTcursor_position1(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLcursor(pu) do result:=Position[1];
end;

procedure proTcursor_position2(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu) do Position[2]:=w;
end;

function fonctionTcursor_position2(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLcursor(pu) do result:=Position[2];
end;


procedure proTcursor_position(i:smallint;w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(i,1,2,E_indicePos);
  with TLcursor(pu) do Position[i]:=w;
end;

function fonctionTcursor_position(i:smallint;var pu:typeUO):float;
begin
  verifierObjet(pu);
  controleParam(i,1,2,E_indicePos);
  with TLcursor(pu) do result:=Position[i];
end;

procedure proTcursor_Xposition1(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu) do XPosition[1]:=w;
end;

function fonctionTcursor_Xposition1(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLcursor(pu) do result:=XPosition[1];
end;

procedure proTcursor_Xposition2(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu) do XPosition[2]:=w;
end;

function fonctionTcursor_Xposition2(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLcursor(pu) do result:=XPosition[2];
end;


procedure proTcursor_Xposition(i:smallint;w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(i,1,2,E_indicePos);
  with TLcursor(pu) do XPosition[i]:=w;
end;

function fonctionTcursor_Xposition(i:smallint;var pu:typeUO):float;
begin
  verifierObjet(pu);
  controleParam(i,1,2,E_indicePos);
  with TLcursor(pu) do result:=XPosition[i];
end;

procedure proTcursor_Yposition1(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu) do YPosition[1]:=w;
end;

function fonctionTcursor_Yposition1(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLcursor(pu) do result:=YPosition[1];
end;

procedure proTcursor_Yposition2(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu) do YPosition[2]:=w;
end;

function fonctionTcursor_Yposition2(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLcursor(pu) do result:=YPosition[2];
end;


procedure proTcursor_Yposition(i:smallint;w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(i,1,2,E_indicePos);
  with TLcursor(pu) do YPosition[i]:=w;
end;

function fonctionTcursor_Yposition(i:smallint;var pu:typeUO):float;
begin
  verifierObjet(pu);
  controleParam(i,1,2,E_indicePos);
  with TLcursor(pu) do result:=YPosition[i];
end;








procedure proTcursor_posMin(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do
  begin
    xminC:=w;
    if xmaxC<=xminC then xmaxC:=xminC+1;
  end;
end;

function fonctionTcursor_posMin(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=xminC;
end;

procedure proTcursor_posMax(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do
  begin
    xmaxC:=w;
    if xmaxC<=xminC then xminC:=xmaxC-1;
  end;
end;

function fonctionTcursor_posMax(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=xmaxC;
end;

procedure proTcursor_SmallIncrement(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(w,1E-100,1E300,E_increment);
  with TLcursor(pu),rec do dxC1:=w;
end;

function fonctionTcursor_SmallIncrement(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=dxC1;
end;

procedure proTcursor_LargeIncrement(w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(w,1E-100,1E300,E_increment);
  with TLcursor(pu),rec do dxC2:=w;
end;

function fonctionTcursor_LargeIncrement(var pu:typeUO):float;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=dxC2;
end;


procedure proTcursor_visible(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do
  begin
    visible:=w;
    Finvalidate2;
  end;
end;

function fonctionTcursor_visible(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=visible;
end;

procedure proTcursor_Locked(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do CurLocked:=w;
end;

function fonctionTcursor_Locked(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=CurLocked;
end;


procedure proTcursor_TrackSource(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do
  begin
    TrackSource:=w;
    Finvalidate2;
  end;
end;

function fonctionTcursor_TrackSource(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=TrackSource;
end;


procedure proTcursor_style(w:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(w,0,maxCursorStyle-1,E_style);
  with TLcursor(pu),rec do
  begin
    byte(style):=w;
    Finvalidate2;
  end;
end;

function fonctionTcursor_style(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=ord(style);
end;

procedure proTcursor_WinContent(w:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  controleParam(w,0,ord(high(TwinContent)),E_WinContent);
  with TLcursor(pu),rec do
  begin
    byte(WinContent):=w;
    Finvalidate2;
  end;
end;

function fonctionTcursor_WinContent(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=ord(WinContent);
end;


procedure proTcursor_color(w:longint;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do
  begin
    color:=w;
    Finvalidate2;
  end;
end;

function fonctionTcursor_color(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=color;
end;

procedure proTcursor_CaptionColor(w:longint;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do
  begin
    Capcolor:=w;
    Finvalidate2;
  end;
end;

function fonctionTcursor_CaptionColor(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=CapColor;
end;


procedure proTcursor_InstallSource(var w:TypeUO;var pu:typeUO);
begin
  verifierObjet(pu);

  if @w<>nil then
    begin
      verifierObjet(w);
      TLcursor(pu).installSource(w);
    end
  else TLcursor(pu).installSource(nil);
end;

procedure proTcursor_InstallZoom(var w:TypeUO;var pu:typeUO);
begin
  verifierObjet(pu);

  if @w<>nil then
    begin
      verifierObjet(w);
      TLcursor(pu).ChangeZoomVec(w);
    end
  else TLcursor(pu).ChangeZoomVec(nil);

end;


procedure proTcursor_title(w:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do title:=w;
end;

function fonctionTcursor_title(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=title;
end;

procedure proTcursor_doubleCursor(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do double:=w;
end;

function fonctionTcursor_doubleCursor(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=double;
end;


procedure proTcursor_decimal(w:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do
  begin
    controleParam(w,0,25,E_decimal);
    deci:=w;
  end;
end;

function fonctionTcursor_decimal(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=deci;
end;

procedure proTcursor_WindowWidth(w:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do
  begin
    controleParam(w,100,screen.width,E_Wwidth);
    Wwidth:=w;
  end;
end;

function fonctionTcursor_WindowWidth(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  with TLcursor(pu),rec do result:=Wwidth;
end;

procedure proTcursor_OnChange(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu) do PgOnChange.setad(w);
end;

function fonctionTcursor_OnChange(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TLcursor(pu) do result:=PgOnChange.ad;
end;

function fonctionTcursor_ShowModal(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TLcursor(pu) do result:=showModal;
end;

procedure proTcursor_OnClick(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TLcursor(pu).onClk do setAd(p);
end;

function fonctionTcursor_OnClick(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TLcursor(pu).OnClk.ad;
end;




procedure proCurseurX(var pu:typeUO;var xx:float;titre:AnsiString);
var
  Lcursor:TLcursor;
  delta:float;
begin
  verifierObjet(pu);

  Lcursor:=TLcursor.create;
  try
    with Lcursor,rec do
    begin

      p0[1]:=xx;
      title:=titre;
      rec.style:=csX;

      if pu is TdataObj
        then delta:=TdataObj(pu).Xend-TdataObj(pu).Xstart
        else delta:=10000;
      rec.dxc1:=minP10(delta/1000);
      rec.dxc2:=100*rec.dxc1;
      changeObref(TdataPlot(pu));
      initParams;

      if showModal=mrOK then xx:=p0[1];
    end;
  finally
    Lcursor.free;
  end;
end;

procedure proCurseurY(var pu:typeUO;var xx:float;titre:AnsiString);
var
  Lcursor:TLcursor;
begin
  verifierObjet(pu);

  Lcursor:=TLcursor.create;
  try
    with Lcursor,rec do
    begin

      p0[1]:=xx;
      title:=titre;
      style:=csY;
      rec.dxc1:=0.1;
      rec.dxc2:=1;
      changeObref(TdataPlot(pu));
      initParams;

      if showModal=mrOK then xx:=p0[1];
    end;
  finally
    Lcursor.free;
  end;
end;


procedure TLcursor.setEmbedded(v: boolean);
begin
  Fembedded:=v;

  if not assigned(form) then createForm;
  with TlineCursor(Form) do
  begin
    init(false);
    setEmbeddedParams(v);
    visible:=false;
  end;
end;

function TLcursor.ActiveEmbedded(TheParent: TwinControl; x1, y1, w1, h1: integer): Trect;
begin
  with TlineCursor(Form).BackPanel do
  begin
    Align:= AlNone;
    parent:=TheParent;

    if (w1>0) and (h1>0) then setBounds(x1,y1,w1,h1)
    else
    begin
      left:=x1;
      top:=y1;
    end;

    result:=rect(left,top,left+width,top+height);
  end;
end;

procedure TLcursor.UnActiveEmbedded;
begin
  TlineCursor(Form).BackPanel.Parent:=TlineCursor(Form);
  TlineCursor(Form).BackPanel.align:=alClient;
end;

Initialization
AffDebug('Initialization stmcurs',0);

registerObject(TLcursor,data);


end.
