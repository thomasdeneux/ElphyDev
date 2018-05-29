unit stmGraph2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,forms,controls,menus,stdCtrls,
     editcont,
     util1,Gdos,DdosFich,Dgraphic,
     Dpalette,Ncdef2,formMenu,

     stmDef,stmObj,
     varconf1,stmDPlot,
     debug0,
     listG,dtf0,Dtrace1,
     stmError,stmPg,
     XYPedit1,stmPopup,

     stmvec1,geometry1;

type
  TpointL=record
            x,y:integer;
            color:integer;
            Xlabel,Ylabel:smallint;
          end;

  PpointL=^TpointL;

  TpointS=record
            x,y:single;
            color:integer;
            Xlabel,Ylabel:smallint;
          end;
  PpointS=^TpointS;

  TpolyRec=record
              tpNum:typetypeG;
              color,color2:integer;
              blup:word;
              modeT,tailleT:byte;
              lineWidth:byte;
              version: byte;
              UsePointColor: boolean;

           end;


  TpolyLine=class(TlistG)
            private
              rec:TpolyRec;
              procedure setX(i:integer;w:float);
              function getX(i:integer):float;

              procedure setY(i:integer;w:float);
              function getY(i:integer):float;

              procedure setCol(i:integer;w:integer);
              function getCol(i:integer):integer;

              procedure setXlabel(i:integer;w:integer);
              function getXlabel(i:integer):integer;

              procedure setYlabel(i:integer;w:integer);
              function getYlabel(i:integer):integer;

            public
              labels: TstringList;
              LabelFont:Tfont;

              constructor create(tp:typetypeG);
              destructor destroy;override;
              procedure addPoint(x,y:float;const col:integer=0);
              procedure loadFromVectors(v1,v2,v3:Tvector;i1,i2:integer);
              procedure loadPolyLine(p:Tpolyline);

              property Xvalue[i:integer]:float read getX write setX;  {i commence à 0 }
              property Yvalue[i:integer]:float read getY write setY;
              property PointColor[i:integer]: integer read getCol write setCol;
              property Xlabel[i:integer]: integer read getXlabel write setXlabel;
              property Ylabel[i:integer]: integer read getYlabel write setYlabel;


              procedure writeToStream(f:Tstream);override;
              function readFromStream(f:Tstream):boolean;override;
              function WriteSize:integer;

              procedure intersection(p1,p2:TpolyLine);
              procedure rotate(x0,y0,theta:float);
              procedure translate(dx0,dy0:float);
              function area:float;
              procedure rectangle(x,y,dx,dy,theta:float);
              property color:integer read rec.color write rec.color;
              property color2:integer read rec.color2 write rec.color2;
              property modeT:byte read rec.modeT write rec.modeT;
              property tailleT:byte read rec.tailleT write rec.tailleT;
              property lineWidth:byte read rec.lineWidth write rec.lineWidth;

              procedure getLimits(var x1,y1, x2,y2: float);
            end;

  TXYplot=class(TDataPlot)
           private
              list0:Tlist;

              decimale:array[1..2] of byte;
              editForm:TXYPlotEditor;
              EditLine:integer;

              modeTbid,tailleTbid,lineWbid:byte;
              NumPolyDisp:integer;

              procedure setEvalue(i,j:integer;x:float);
              function getEvalue(i,j:integer):float;

              procedure DinvalidateCell(i,j:integer);
              procedure DinvalidateVector(i:integer);
              procedure DinvalidateAll;

              function getPolyLineCount:integer;
              procedure setPolyLineCount(n:integer);
              function getPolyLine(i:integer):TpolyLine; { i commence à 0 }

              procedure installEditPage;
              procedure EditChangeColor;
              procedure EditDeletePolyline;
              procedure EditInsertPolyline;

              procedure onChangeD(sender:Tobject);
              procedure onChangeCB(sender:Tobject);
           public
              NextColor,NextColor2:integer;

              constructor create;override;
              destructor destroy;override;

              class function STMClassName:AnsiString;override;

              procedure clear;

              procedure setColorT(w:longint);override;
              procedure setColorT2(w:longint);override;
              procedure setLargeurTrait(w:byte);override;
              procedure setmodeT(w:byte);override;
              procedure settailleT(w:byte);override;

              function ChooseCoo1:boolean;override;

              procedure OndisplayPoint(n:integer);
              procedure display0(FirstUO:typeUO; ExternalWorld,logX,logY:boolean);
              procedure display; override;
              procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);override;

              procedure AddPolyLine;
              procedure deletePolyline(index:integer);
              procedure InsertPolyline(index:integer);
              function LastPolyLine:Tpolyline;


              property PolylineCount:integer read getPolyLineCount write setPolyLineCount;
              procedure getLimits(var x1,y1,x2,y2:float);


              procedure cadrerX(sender:Tobject);override;
              procedure cadrerY(sender:Tobject);override;

              procedure autoscaleX;override;
              procedure autoscaleY;override;

              property polyLines[i:integer]:TpolyLine read getPolyLine; { i commence à 0 }

              procedure createEditForm;
              procedure EditPlot(sender:Tobject);

              function getPopUp:TpopUpMenu;override;
              procedure invalidate;override;

              procedure saveData( f:Tstream);override;
              function loadData(f:Tstream):boolean;override;
              procedure copyDataFrom(p:typeUO);override;
            end;


{ Comme la propriété Polylines de TXYplot donne directemement un Tpolyline
  les méthodes stm ne s'écrivent pas avec VAR pu: typeUO

}
procedure proTpolyLine_addPoint(x,y:float; pu:pointer);pascal;
procedure proTpolyLine_addPoint_1(x,y:float; col:integer; pu:pointer);pascal;

procedure proTpolyLine_loadFromVectors(var v1,v2:Tvector;i1,i2:integer; pu:pointer);pascal;
procedure proTpolyLine_loadFromVectors_1(var v1,v2,v3:Tvector;i1,i2:integer; pu:pointer);pascal;

procedure proTpolyLine_loadPolyline(p:Tpolyline; pu:pointer);pascal;

function fonctionTpolyLine_count( pu:pointer):longint;pascal;

procedure proTpolyLine_X(i:longint;w:float; pu:pointer);pascal;
function fonctionTpolyLine_X(i:longint; pu:pointer):float;pascal;

procedure proTpolyLine_Y(i:longint;w:float; pu:pointer);pascal;
function fonctionTpolyLine_Y(i:longint; pu:pointer):float;pascal;

procedure proTpolyLine_clear( pu:pointer);pascal;

procedure proTpolyLine_Color(w:integer; pu:pointer);pascal;
function fonctionTpolyLine_Color(pu:pointer):integer;pascal;

procedure proTpolyLine_PointColor(i:longint;w:integer; pu:pointer);pascal;
function fonctionTpolyLine_PointColor(i:longint; pu:pointer):integer;pascal;

procedure proTpolyLine_UsePointColor(w:boolean; pu:pointer);pascal;
function fonctionTpolyLine_UsePointColor(pu:pointer):boolean;pascal;


procedure proTpolyLine_Color2(w:integer; pu:pointer);pascal;
function fonctionTpolyLine_Color2(pu:pointer):integer;pascal;

procedure proTpolyLine_LineWidth(w:integer; pu:pointer);pascal;
function fonctionTpolyLine_LineWidth(pu:pointer):integer;pascal;

procedure proTpolyline_Mode(x:integer;pu:pointer);pascal;
function fonctionTpolyline_Mode(pu:pointer):integer;pascal;

procedure proTpolyline_SymbolSize(x:integer;pu:pointer);pascal;
function fonctionTpolyline_SymbolSize(pu:pointer):integer;pascal;

procedure proTpolyLine_intersection(p1,p2:TpolyLine; pu:pointer);pascal;
procedure proTpolyLine_rotate(x0,y0,theta:float; pu:pointer);pascal;
procedure proTpolyLine_translate(dx0,dy0:float; pu:pointer);pascal;
function fonctionTpolyLine_area(pu:pointer):float;pascal;
procedure proTpolyLine_rectangle(x,y,dx,dy,theta:float; pu:pointer);pascal;


function fonctionTpolyline_font(pu: pointer):pointer;pascal;
function fonctionTpolyline_Label(i:integer;pu: pointer): AnsiString;pascal;
procedure proTpolyline_Label(i:integer;w: AnsiString;pu: pointer);pascal;

function fonctionTpolyline_Xlabel(i:integer;pu: pointer): integer;pascal;
procedure proTpolyline_Xlabel(i:integer;w: integer;pu: pointer);pascal;
function fonctionTpolyline_Ylabel(i:integer;pu: pointer): integer;pascal;
procedure proTpolyline_Ylabel(i:integer;w: integer;pu: pointer);pascal;



procedure proTXYplot_create(stName:AnsiString;var pu:typeUO);pascal;
procedure proTXYplot_create_1(var pu:typeUO);pascal;

procedure proTXYplot_addPolyLine(var pu:typeUO);pascal;
function fonctionTXYplot_count(var pu:typeUO):longint;pascal;
procedure proTXYplot_clear(var pu:typeUO);pascal;

function fonctionTXYplot_polyLines(i:integer;var pu:typeUO):pointer;pascal;
function fonctionTXYplot_last(var pu:typeUO):pointer;pascal;

procedure proTXYplot_NextColor(w:integer;var pu:typeUO);pascal;
function fonctionTXYplot_NextColor(var pu:typeUO):integer;pascal;

procedure proTXYplot_NextColor2(w:integer;var pu:typeUO);pascal;
function fonctionTXYplot_NextColor2(var pu:typeUO):integer;pascal;



implementation


uses stmMat1;

{*************************** Méthodes de TpolyLine ***************************}


constructor TpolyLine.create(tp:typetypeG);
begin
  rec.tpNum:=tp;
  rec.color:=DefPenColor;
  rec.version:=2;                     // 0:seulement X,Y    1: avec color    2: on ajoute Xlabel, Ylabel
  labels:=TstringList.create;
  LabelFont:=Tfont.create;
  inherited create(sizeof(TpointS));
end;

destructor TpolyLine.destroy;
begin
  LabelFont.free;
  Labels.free;
  inherited;
end;

procedure TpolyLine.addPoint(x,y:float;const col:integer=0);
var
  pL:TpointL;
  pS:TpointS;
begin
  case rec.tpNum of
    g_longint: begin
                 pL.x:=roundL(x);
                 pL.y:=roundL(y);
                 pL.color:=col;
                 pL.Xlabel:=2;
                 pL.Ylabel:=2;

                 add(@pL);
               end;
    g_single:  begin
                 pS.x:=x;
                 pS.y:=y;
                 pS.color:=col;
                 pS.Xlabel:=2;
                 pS.Ylabel:=2;

                 add(@pS);
               end;

  end;
  Labels.Add('');
end;

procedure TpolyLine.loadFromVectors(v1, v2, v3: Tvector; i1, i2: integer);
var
  i:integer;
begin
  if assigned(v1) and assigned(v2) and
     (i1>=v1.Istart) and (i2<=v1.Iend) and
     (i1>=v2.Istart) and (i2<=v2.Iend) then
  begin
    if not assigned(v3) then
      for i:=i1 to i2 do addPoint(v1[i],v2[i])
    else
    if (i1>=v3.Istart) and (i2<=v3.Iend) then
      for i:=i1 to i2 do addPoint(v1[i],v2[i],v3.Jvalue[i]);
  end;
end;

procedure TpolyLine.loadPolyLine(p: Tpolyline);
var
  i:integer;
begin
  if assigned(p) then
  for i:=0 to p.count-1 do
    addPoint(p.Xvalue[i],p.Yvalue[i],p.PointColor[i]);
end;


procedure TpolyLine.setX(i:integer;w:float);
begin
  case rec.tpNum of
    g_longint: PpointL(items[i]).x:=roundL(w);
    g_single:  PpointS(items[i]).x:=w;
  end;
end;

function TpolyLine.getX(i:integer):float;
begin
  case rec.tpNum of
    g_longint: result:=PpointL(items[i]).x;
    g_single:  result:=PpointS(items[i]).x;
  end;
end;

procedure TpolyLine.setY(i:integer;w:float);
begin
  case rec.tpNum of
    g_longint: PpointL(items[i]).y:=roundL(w);
    g_single:  PpointS(items[i]).y:=w;
  end;
end;

function TpolyLine.getY(i:integer):float;
begin
  case rec.tpNum of
    g_longint: result:=PpointL(items[i]).y;
    g_single:  result:=PpointS(items[i]).y;
  end;
end;

procedure TpolyLine.setCol(i:integer;w:integer);
begin
  PpointL(items[i]).color:=w;
end;

function TpolyLine.getCol(i:integer):integer;
begin
  result:=PpointL(items[i]).color;
end;

procedure TpolyLine.setXlabel(i:integer;w:integer);
begin
  PpointL(items[i]).Xlabel:=w;
end;

function TpolyLine.getXlabel(i:integer):integer;
begin
  result:=PpointL(items[i]).Xlabel;
end;

procedure TpolyLine.setYlabel(i:integer;w:integer);
begin
  PpointL(items[i]).Ylabel:=w;
end;

function TpolyLine.getYlabel(i:integer):integer;
begin
  result:=PpointL(items[i]).Ylabel;
end;


procedure TpolyLine.writeToStream(f:Tstream);
var
  w,res,len:integer;
  stLab:string;
begin
  w:=sizeof(Rec);
  f.writeBuffer(w,sizeof(w));        {Ecrire RecSize }
  rec.version:=2;
  f.WriteBuffer(rec,sizeof(rec));    {Ecrire Rec }

  inherited writeToStream(f);        {Puis le contenu de la liste}

  stLab:=labels.Text;
  len:=length(stLab);
  f.Write(len,sizeof(len));
  if len>0 then f.Write(stLab[1],len);
end;


function TpolyLine.readFromStream(f:Tstream):boolean;
type
  TOldpoint= record
               x,y: integer;
             end;
var
  w,res,i:integer;
  old: ToldPoint;
  oldList: TlistG;
  stLab:string;
  len:integer;
begin
  result:=false;
  res:=f.Read(w,sizeof(w));     {Lire RecSize}
  if (res<>sizeof(w)) or (w>sizeof(rec)) then exit;

  fillchar(rec,sizeof(rec),0);  { Puis le rec enregistré }
  res:=f.Read(rec,w);           { qui peut être plus petit que le rec actuel }
                                { les champs supplémentaires seront nuls }
  result:= (res=w);
  if not result then exit;

  if rec.Version=2 then
  begin
    result:= inherited ReadFromStream(f);    { lire la liste }
    f.Read(len,sizeof(len));                 { et les labels }
    if len>0 then
    begin
      setlength(stLab,len);
      f.Read(stLab[1],len);
      labels.Text:=stLab;
    end;
  end
  else
  begin           { Version 0 ou 1, sans Point color ou sans labels}
    try
    oldList:=TlistG.create(sizeof(ToldPoint));
    result:= oldList.readFromStream(f);     // la liste se charge quelle que soit la taille des elts
    if result then                          // en sortie, EltSize est à jour
    begin
      Count:=oldList.Count;
      for i:=0 to count-1 do
        system.move(oldList[i]^,items[i]^,oldList.EltSize);
      { On copie x,y,z. Color contiendra zéro, Xlabel et Ylabel aussi }

    end;
    finally
    oldList.free;
    end;
  end;
end;


function TpolyLine.writeSize:integer;
begin
  result:=4+sizeof(rec)+inherited writeSize +sizeof(integer)+length(labels.Text);
end;

procedure TpolyLine.intersection(p1,p2:TpolyLine);
var
  poly1,poly2,poly3:TpolyR;
  i:integer;
begin
  if not assigned(p1) or not assigned(p2) then exit;

  setLength(poly1,p1.Count);
  for i:=0 to p1.Count-1 do
  begin
    poly1[i].x:=p1.Xvalue[i];
    poly1[i].y:=p1.Yvalue[i];
  end;

  setLength(poly2,p2.Count);
  for i:=0 to p2.Count-1 do
  begin
    poly2[i].x:=p2.Xvalue[i];
    poly2[i].y:=p2.Yvalue[i];
  end;

  poly3:=PolyRinter(poly1,poly2);

  clear;
  for i:=0 to high(poly3) do addPoint(poly3[i].x,poly3[i].y);
end;

procedure TpolyLine.rotate(x0,y0,theta: float);
var
  i:integer;
  x2,y2:float;
begin
  for i:=0 to count-1 do
  begin
    DegRotationR(Xvalue[i],Yvalue[i],x2,y2,x0,y0,theta);
    Xvalue[i]:=x2;
    Yvalue[i]:=y2;
  end;
end;

procedure TpolyLine.translate(dx0,dy0: float);
var
  i:integer;
begin
  for i:=0 to count-1 do
  begin
    Xvalue[i]:= Xvalue[i] + dx0;
    Yvalue[i]:= Yvalue[i] + dy0;
  end;
end;

function TpolyLine.area:float;
var
  i:integer;
begin
  result:=0;

  for i:=0 to count-2 do
    result:=result+(xvalue[i+1]-xvalue[i])*(yvalue[i+1]+yvalue[i])/2;

  result:=abs(result);
end;

procedure TpolyLine.rectangle(x,y,dx,dy,theta:float);
var
  i:Integer;
  dx2,dy2:float;
  PR:array[1..5] of TRpoint;
begin
  dx2:=dx/2;
  dy2:=dy/2;

  DegRotationR
      (dx2,-dy2,PR[1].x,PR[1].y,0,0,theta);
  DegRotationR
      (-dx2,-dy2,PR[2].x,PR[2].y,0,0,theta);

  PR[3].x:=-PR[1].x;
  PR[3].y:=-PR[1].y;
  PR[4].x:=-PR[2].x;
  PR[4].y:=-PR[2].y;

  for i:=1 to 4 do
    begin
      PR[i].x:=PR[i].x+x;
      PR[i].y:=PR[i].y+y;
    end;

  PR[5]:=PR[1];

  for i:=1 to 5 do addPoint(PR[i].x,PR[i].y);
end;


procedure TpolyLine.getLimits(var x1, y1, x2, y2: float);
var
  j:integer;
  x,y:float;
begin
  x1:=maxFloat;
  x2:=-maxFloat;
  y1:=maxFloat;
  y2:=-maxFloat;

  for j:=0 to count-1 do
  begin
    x:=getX(j);
    y:=getY(j);
    if x<x1 then x1:=x;
    if x>x2 then x2:=x;
    if y<y1 then y1:=y;
    if y>y2 then y2:=y;
  end;

  if x1=maxFloat then
    begin
      x1:=0;
      x2:=0;
    end;

  if y1=maxFloat then
    begin
      y1:=0;
      y2:=0;
    end;

end;



{*************************** Méthodes de TXYplot ***************************}

constructor TXYplot.create;
begin
  inherited;
  visu.keepRatio:=true;

  list0:=Tlist.create;

end;

destructor TXYplot.destroy;
var
  i:integer;
begin
  clear;
  editForm.free;
  list0.Free;
  inherited destroy;
end;

procedure TXYPlot.clear;
var
  i:integer;
begin
  with list0 do
  for i:= 0 to count-1 do TpolyLine(items[i]).free;
  list0.clear;
end;

class function TXYplot.STMClassName:AnsiString;
begin
  STMClassName:='XYplot';
end;

procedure TXYplot.setColorT(w:longint);
var
  i:integer;
begin
  inherited;
  for i:=0 to polylineCount-1 do polyLines[i].rec.color:=w;
  NextColor:=w;
end;

procedure TXYplot.setColorT2(w:longint);
var
  i:integer;
begin
  inherited;
  for i:=0 to polylineCount-1 do polyLines[i].rec.color2:=w;
  NextColor2:=w;
end;

procedure TXYplot.setLargeurTrait(w:byte);
var
  i:integer;
begin
  inherited;
  for i:=0 to polylineCount-1 do polyLines[i].rec.lineWidth:=w;
end;

procedure TXYplot.setmodeT(w:byte);
var
  i:integer;
begin
  inherited;
  for i:=0 to polylineCount-1 do polyLines[i].rec.modeT:=w;
end;

procedure TXYplot.settailleT(w:byte);
var
  i:integer;
begin
  inherited;
  for i:=0 to polylineCount-1 do polyLines[i].rec.tailleT:=w;
end;

procedure TXYplot.OndisplayPoint(n:integer);
var
  col:integer;
begin
  col:= polyLines[NumPolyDisp].PointColor[n];
  canvasGlb.Pen.Color:=col;
  canvasGlb.brush.Color:=col;
end;

procedure TXYplot.display0(FirstUO:typeUO; ExternalWorld,logX,logY:boolean);
var
  data1,data2:typedataTab;
  univers:TUnivers;
  trace:TTraceTableauDouble;
  x1,y1,x2,y2:float;
  mt,tt:integer;
  i,j:integer;
  oldFont: Tfont;
begin
  if list0.count<=0 then exit;

  data1:=typedataS.createStep(nil,sizeof(TpointS),0,0,1);
  data2:=typedataS.createStep(nil,sizeof(TpointS),0,0,1);

  univers:=Tunivers.create;
  if (FirstUO is Tmatrix) and Tmatrix(FirstUO).getMainWorld(x1,y1,x2,y2) then
  begin
    univers.setWorld(x1,y1,x2,y2);
    univers.setModeLog(LogX,LogY)
  end
  else
  if externalWorld then
    begin
      Dgraphic.getWorld(x1,y1,x2,y2);
      univers.setWorld(x1,y1,x2,y2);
      univers.setModeLog(LogX,LogY)
    end
  else
    begin
      univers.setWorld(xmin,ymin,xmax,ymax);
      univers.setModeLog(modeLogX,modeLogY);
    end;
  univers.setInverse(inverseX,inverseY);

  trace:=TTraceTableauDouble.create(univers,data1,data2,nil);


  with trace do
  begin
    setStyle(modeT,tailleT);
    setTrait(largeurTrait,styleTrait);

    for i:=0 to list0.count-1 do
      with TpolyLine(list0.items[i]) do
      begin
        data1.p:=getPointer;
        data1.indicemin:=0;
        data1.indicemax:=count-1;

        data2.p:=@getPointer^[4];
        data2.indicemin:=0;
        data2.indicemax:=count-1;

        if rec.UsePointColor then trace.onDisplayPoint:=self.OndisplayPoint;
        if PRprinting and PRmonochrome then setColorTrace(clBlack)
        else
          begin
            setColorTrace(rec.color);
            setColorTrace2(rec.color2);
            setTrait(rec.lineWidth,0);
            setStyle(rec.modeT,rec.tailleT);
          end;


        trace.setIminImax(0,count-1);
        NumPolyDisp:=i;
        afficher;

        with CanvasGlb do
        begin
          oldFont:=font;
          font:=LabelFont;
          brush.Style:=bsClear;

          for j:=0 to count-1 do
          with PpointS(items[j])^ do
            textOut(convWx(x)+Xlabel,convWy(y)+Ylabel,Labels[j]);

          brush.Style:=bsSolid;
          font:=oldFont;
        end;  
      end;
  end;

  trace.free;
  univers.free;
end;


procedure TXYplot.display;
var
  x1,y1,x2,y2:integer;
  BKcolor:longint;
  old:Tfont;
  rectI:Trect;
const
  dd=5;
begin
  old:=canvasGlb.font;
  canvasGlb.font:=visu.fontVisu;

  BKcolor:=canvasGlb.brush.color;

  getWindowG(x1,y1,x2,y2);

  rectI:=getInsideWindow;

  with rectI do setWindow(left,top,right,bottom);

  display0(nil, false,false,false);
  visu.DisplayScale;

  setWindow(x1,y1,x2,y2);

  canvasGlb.brush.color:=BKcolor;
  canvasGlb.font:=old;
end;


procedure TXYplot.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);
begin
  display0(FirstUO,extWorld,logX,logY);
end;

function TXYplot.ChooseCoo1:boolean;
var
  col1,col2:integer;
begin
  col1:=colorT;
  col2:=colorT2;
  result:=inherited chooseCoo1;
  if result and ( (col1<>colorT) or (col2<>colorT2) ) then
    begin
      colorT:=visu.color;
      colorT2:=visu.color;
    end;
end;



function TXYplot.getPolyLineCount:integer;
begin
  result:=list0.count;
end;

procedure TXYplot.setPolyLineCount(n:integer);
begin
  list0.count:=n;
end;

procedure TXYplot.addPolyLine;
var
  poly:TpolyLine;
begin
  poly:=TpolyLine.create(g_single);
  poly.rec.color:=Nextcolor;
  poly.rec.color2:=Nextcolor2;
  poly.rec.modeT:=modeT;
  poly.rec.tailleT:=TailleT;
  poly.rec.lineWidth:=largeurTrait;

  list0.add(poly);
end;

procedure TXYplot.deletePolyLine(index:integer);
begin
  Tpolyline(list0[index]).free;
  list0.delete(index);
end;

procedure TXYplot.insertPolyLine(index:integer);
var
  poly:TpolyLine;
begin
  poly:=TpolyLine.create(g_single);
  poly.rec.color:=Nextcolor;
  poly.rec.color2:=Nextcolor2;
  list0.insert(index,poly);
end;

function TXYplot.LastPolyLine:Tpolyline;
begin
  result:=TpolyLine(list0.Last);
end;

procedure TXYplot.getLimits(var x1,y1,x2,y2:float);
var
  i,j:integer;
  x,y:float;
begin
  x1:=maxFloat;
  x2:=-maxFloat;
  y1:=maxFloat;
  y2:=-maxFloat;

  for i:= 0 to polyLineCount-1 do
    with TpolyLine(list0.items[i]) do
    for j:=0 to count-1 do
      begin
        x:=getX(j);
        y:=getY(j);
        if x<x1 then x1:=x;
        if x>x2 then x2:=x;
        if y<y1 then y1:=y;
        if y>y2 then y2:=y;
      end;

  if x1=maxFloat then
    begin
      x1:=0;
      x2:=0;
    end;

  if y1=maxFloat then
    begin
      y1:=0;
      y2:=0;
    end;

end;



procedure TXYplot.cadrerX(sender:Tobject);
var
  x1,x2,y1,y2:float;
begin
  getLimits(x1,y1,x2,y2);
  with visu0^ do
  begin
    Xmin:=x1;
    Xmax:=x2;
  end;
end;

procedure TXYplot.cadrerY(sender:Tobject);
var
  x1,x2,y1,y2:float;
begin
  getLimits(x1,y1,x2,y2);
  with visu0^ do
  begin
    Ymin:=y1;
    Ymax:=y2;
  end;
end;

procedure TXYplot.autoscaleX;
var
  x1,x2,y1,y2:float;
begin
  getLimits(x1,y1,x2,y2);
  with visu do
  begin
    Xmin:=x1;
    Xmax:=x2;
  end;
end;

procedure TXYplot.autoscaleY;
var
  x1,x2,y1,y2:float;
begin
  getLimits(x1,y1,x2,y2);
  with visu do
  begin
    Ymin:=y1;
    Ymax:=y2;
  end;
end;

function TXYplot.getPolyLine(i:integer):TpolyLine;
begin
  result:=TpolyLine(list0.items[i]);
end;

procedure TXYPlot.setEvalue(i,j:integer;x:float);
begin
  if (EditLine=polyLineCount) then
    begin
      addPolyLine;

      
      EditForm.cbSelected.setNumList(1,polyLineCount+1,1);
      EditForm.cbSelected.setVar (EditLine,t_longint,0);

      installEditPage;
    end;

  if (EditLine>=0) and (EditLine<polyLineCount) then
    with polylines[EditLine] do
    begin
      if j=count+1 then addPoint(0,0);
      if j<=count then
      case i of
        1: Xvalue[j-1]:=x;
        2: Yvalue[j-1]:=x;
      end
    end;
end;

function TXYPlot.getEvalue(i,j:integer):float;
begin
  result:=0;
  if (EditLine>=0) and (EditLine<polyLineCount) then
    with polylines[EditLine] do
    if j<=count then
    case i of
      1: result:=Xvalue[j-1];
      2: result:=Yvalue[j-1];
    end;
end;

procedure TXYplot.DinvalidateCell(i,j:integer);
begin
  invalidate;
end;

procedure TXYplot.DinvalidateVector(i:integer);
begin
  invalidate;
end;

procedure TXYplot.DinvalidateAll;
begin
  invalidate;
end;

procedure TXYplot.onChangeD(sender:Tobject);
begin
  invalidate;
end;

procedure TXYplot.onChangeCB(sender:Tobject);
begin
  updateAllVar(editForm);
  invalidate;
end;


procedure TXYPlot.installEditPage;
begin
  if assigned(EditForm) then
  with EditForm do
  begin
    if PolyLineCount=0 then
      begin
        EditLine:=0;
        installe(1,1,2,1,@decimale);
      end
    else
      begin
        if EditLine<0 then EditLine:=0;
        if EditLine>=PolyLineCount+1 then EditLine:=PolyLineCount;
        if Editline=PolyLineCount
          then installe(1,1,2,1,@decimale)
          else installe(1,1,2,PolyLines[EditLine].count+1,@decimale)
      end;

    cbSelected.setNumList(1,polyLineCount+1,1);  
    cbSelected.setVar (EditLine,t_longint,0);
    

    caption:=ident+' Polyline '+Istr(EditLine+1);

    Lcount.caption:='Count: '+Istr(polylineCount);

    if EditLine<polylineCount then
      begin
        Bcolor.init(polylines[EditLine].rec.color);
        Bcolor2.init(polylines[EditLine].rec.color2);

        Bcolor.onChange:=onChangeD;
        Bcolor2.onChange:=onChangeD;

        with cbStyle do
        begin
          setStringArray(tbStyleTrace,longNomStyleTrace,nbStyleTrace);
          setValues(TraceStyleValues);
          setVar(polylines[EditLine].rec.ModeT,T_byte,1);
          onChange:=onChangeCB;
        end;

        with cbSymbolSize do
        begin
          setNumList(1,20,1);
          setVar(polylines[EditLine].rec.tailleT,T_byte,1);
          onChange:=onChangeCB;
        end;

        with cbLineWidth do
        begin
          setNumList(1,20,1);
          setVar(polylines[EditLine].rec.lineWidth,T_byte,1);
          onChange:=onChangeCB;
        end;

      end
    else
      begin
        Bcolor.reset(colorT);
        Bcolor2.reset(colorT2);

        Bcolor.onChange:=nil;
        Bcolor2.onChange:=nil;

        with cbStyle do
        begin
          setStringArray(tbStyleTrace,longNomStyleTrace,nbStyleTrace);
          setValues(TraceStyleValues);
          setVar(ModeTbid,T_byte,1);
        end;

        with cbSymbolSize do
        begin
          setNumList(1,20,1);
          setVar(tailleTbid,T_byte,1);
        end;

        with cbLineWidth do
        begin
          setNumList(1,20,1);
          setVar(lineWbid,T_byte,1);
        end;

      end;
  end;

end;

procedure TXYplot.EditChangeColor;
begin
  {
  if (EditLine>=0) and (EditLine<polylineCount) then
    begin
      polylines[EditLine].rec.color:=editForm.Pcolor.color;
      polylines[EditLine].rec.color2:=editForm.Pcolor2.color;
    end;
  }
  invalidate;
end;

procedure TXYplot.EditDeletePolyline;
begin
  if (EditLine>=0) and (EditLine<polylineCount) then
    begin
      DeletePolyLine(EditLine);
      installEditPage;
      invalidate;
    end;
end;

procedure TXYplot.EditInsertPolyline;
begin
  if (EditLine>=0) and (EditLine<polylineCount) then
    begin
      InsertPolyLine(EditLine);
      installEditPage;
      invalidate;
    end;
end;


procedure TXYPlot.createEditForm;
begin
  fillchar(decimale,2,3);

  Editform:=TXYplotEditor.create(formStm);
  with EditForm do
  begin
    installEditPage;
    ExtendMode:=true;

    getTabValue:=getEvalue;
    setTabValue:=setEvalue;

    invalidateCellD:=DinvalidateCell;
    invalidateVectorD:=DinvalidateVector;
    invalidateAllD:=DinvalidateAll;
    {
    setKvalueD:=DsetKvalue;
    clearData:=self.clear;
    }
    changePage:=InstallEditPage;
    changeColor:=EditChangeColor;
    DeletePolyline:=EditDeletePolyline;
    InsertPolyline:=EditInsertPolyline;

    adjustFormSize;
    UseKvalue1.visible:=false;
  end;
end;

procedure TXYPlot.EditPlot(sender:Tobject);
begin
  if not assigned(editForm) then createEditForm;
  installEditPage;
  EditForm.show;
end;

function TXYplot.getPopUp:TpopupMenu;
begin
  with PopUps do
  begin
    PopupItem(pop_TXYPlot,'TXYPlot_Coordinates').onClick:=ChooseCoo;
    PopupItem(pop_TXYPlot,'TXYPlot_Show').onClick:=self.Show;
    PopupItem(pop_TXYPlot,'TXYPlot_Properties').onClick:=Proprietes;
    PopupItem(pop_TXYPlot,'TXYPlot_Edit').onClick:=EditPlot;

    PopupItem(pop_TXYPlot,'TXYPlot_SaveObject').onClick:=SaveObjectToFile;
    PopupItem(pop_TXYPlot,'TXYPlot_Clone').onClick:=CreateClone;

    result:=pop_TXYPlot;
  end;
end;

procedure TXYPlot.invalidate;
begin
  inherited;
  if assigned(editForm) and editForm.visible then installEditPage;
end;

procedure TXYPlot.saveData(f:Tstream);
var
  i,sz,nb,res:integer;
begin
  sz:=4;
  for i:=0 to PolyLineCount-1 do
    sz:=sz+polylines[i].WriteSize;
  writeDataHeader(f,sz);

  nb:=PolyLineCount;
  f.WriteBuffer(nb,sizeof(nb));
  for i:=0 to PolyLineCount-1 do
    polylines[i].WriteToStream(f);

end;

function TXYPlot.loadData(f:Tstream):boolean;
var
  size:integer;
  i,nb,res:integer;
begin
  result:=readDataHeader(f,size);
  if not result then exit;

  res:=f.read(nb,sizeof(nb));
  if (nb<0) or (res<>sizeof(nb)) then exit;

  for i:=1 to nb do
    Addpolyline;

  result:=true;
  for i:=0 to nb-1 do
    result:=result and PolyLines[i].readFromStream(f);

  if result then
  for i:=0 to list0.count -1 do
  with PolyLines[i] do
    if rec.modeT=0 then
    begin
      rec.modeT:=modeT;
      rec.tailleT:=tailleT;
      rec.lineWidth:=largeurTrait;
    end;
end;

procedure TXYplot.copyDataFrom(p:typeUO);
var
  i:integer;
begin
  if not (p is TXYplot) then exit;

  clear;

  for i:=0 to TXYplot(p).PolylineCount-1 do
  begin
    addPolyLine;
    polyLines[i].Count:=TXYplot(p).polyLines[i].count;
    polyLines[i].rec:=TXYplot(p).polyLines[i].rec;
    move(TXYplot(p).polyLines[i].getPointer^,polyLines[i].getPointer^,8*polyLines[i].count);
  end;
end;


{************************* Méthodes STM de Tpolyline **********************}

var
  E_line:integer;
  E_line1:integer;

procedure proTpolyLine_addPoint(x,y:float; pu:pointer);
begin
  with TpolyLine(pu) do addPoint(x,y);
end;

procedure proTpolyLine_addPoint_1(x,y:float; col:integer; pu:pointer);
begin
  with TpolyLine(pu) do addPoint(x,y,col);
end;


function fonctionTpolyLine_count( pu:pointer):longint;
begin
  result:=TpolyLine(pu).count;
end;

procedure proTpolyLine_X(i:longint;w:float; pu:pointer);
begin
  with TpolyLine(pu) do
  begin
    controleParam(i,1,count,E_line);
    setX(i-1,w);
  end;
end;

function fonctionTpolyLine_X(i:longint; pu:pointer):float;
begin
  with TpolyLine(pu) do
  begin
    controleParam(i,1,count,E_line);
    result:=getX(i-1);
  end;
end;

procedure proTpolyLine_Y(i:longint;w:float; pu:pointer);
begin
  with TpolyLine(pu) do
  begin
    controleParam(i,1,count,E_line);
    setY(i-1,w);
  end;
end;

function fonctionTpolyLine_Y(i:longint; pu:pointer):float;
begin
  with TpolyLine(pu) do
  begin
    controleParam(i,1,count,E_line);
    result:=getY(i-1);
  end;
end;

procedure proTpolyLine_PointColor(i:longint;w:integer; pu:pointer);
begin
  with TpolyLine(pu) do
  begin
    controleParam(i,1,count,E_line);
    setCol(i-1,w);
  end;
end;


function fonctionTpolyLine_PointColor(i:longint; pu:pointer):integer;
begin
  with TpolyLine(pu) do
  begin
    controleParam(i,1,count,E_line);
    result:=getCol(i-1);
  end;
end;

procedure proTpolyLine_UsePointColor(w:boolean; pu:pointer);
begin
  TpolyLine(pu).rec.UsePointColor:=w;
end;

function fonctionTpolyLine_UsePointColor(pu:pointer):boolean;
begin
  result:=TpolyLine(pu).rec.UsePointColor;
end;


procedure proTpolyLine_clear( pu:pointer);
begin
  with TpolyLine(pu) do clear;
end;

procedure proTpolyLine_Color(w:integer; pu:pointer);
begin
  TpolyLine(pu).rec.color:=w;
end;

function fonctionTpolyLine_Color(pu:pointer):integer;
begin
  result:= TpolyLine(pu).rec.color;
end;


procedure proTpolyLine_Color2(w:integer; pu:pointer);
begin
  TpolyLine(pu).rec.color2:=w;
end;

function fonctionTpolyLine_Color2(pu:pointer):integer;
begin
  result:= TpolyLine(pu).rec.color2;
end;

procedure proTpolyLine_LineWidth(w:integer; pu:pointer);
begin
  TpolyLine(pu).rec.lineWidth:=w;
end;

function fonctionTpolyLine_LineWidth(pu:pointer):integer;
begin
  result:=TpolyLine(pu).rec.lineWidth;
end;

procedure proTpolyLine_Mode(x:integer;pu:pointer);
begin
  controleParametre(x,1,nbStyleTrace);
  TpolyLine(pu).rec.modeT:=x;
end;

function fonctionTpolyLine_Mode(pu:pointer):integer;
begin
  fonctionTpolyLine_Mode:=TpolyLine(pu).rec.modeT;
end;

procedure proTpolyLine_SymbolSize(x:integer;pu:pointer);
begin
  controleParametre(x,1,10000);
  TpolyLine(pu).rec.tailleT:=x;
end;

function fonctionTpolyLine_SymbolSize(pu:pointer):integer;
begin
  fonctionTpolyLine_SymbolSize:=TpolyLine(pu).rec.TailleT;
end;


procedure proTpolyLine_loadFromVectors(var v1,v2:Tvector;i1,i2:integer; pu:pointer);
begin
  verifierVecteur(v1);
  verifierVecteur(v2);

  Tpolyline(pu).loadFromVectors(v1,v2,nil,i1,i2);
end;

procedure proTpolyLine_loadFromVectors_1(var v1,v2,v3:Tvector;i1,i2:integer; pu:pointer);
begin
  verifierVecteur(v1);
  verifierVecteur(v2);
  verifierVecteur(v3);

  Tpolyline(pu).loadFromVectors(v1,v2,v3,i1,i2);
end;

procedure proTpolyLine_loadPolyline(p:Tpolyline; pu:pointer);
begin
  Tpolyline(pu).loadPolyline(p);
end;

procedure proTpolyLine_intersection(p1,p2:TpolyLine; pu:pointer);
begin
  Tpolyline(pu).intersection(p1,p2);
end;

procedure proTpolyLine_rotate(x0,y0,theta:float; pu:pointer);
begin
  Tpolyline(pu).rotate(x0,y0,theta);
end;

procedure proTpolyLine_translate(dx0,dy0:float; pu:pointer);
begin
  Tpolyline(pu).translate(dx0,dy0);
end;

function fonctionTpolyLine_area(pu:pointer):float;pascal;
begin
  result:=Tpolyline(pu).area;
end;

procedure proTpolyLine_rectangle(x,y,dx,dy,theta:float; pu:pointer);
begin
  TpolyLine(pu).rectangle(x,y,dx,dy,theta);
end;


function fonctionTpolyline_font(pu: pointer):pointer;
begin
  with Tpolyline(pu) do
  begin
    result:= LabelFont;
  end;
end;

function fonctionTpolyline_Label(i:integer;pu: pointer): AnsiString;
begin
  with Tpolyline(pu) do
  begin
    if (i<1) or (i> count)  then sortieErreur('Tpolyline.Label : index out of range');
    result:=Labels[i-1];
  end;
end;

procedure proTpolyline_Label(i:integer;w: AnsiString;pu: pointer);
begin
  with Tpolyline(pu) do
  begin
    if (i<1) or (i> count)  then sortieErreur('Tpolyline.Label : index out of range');
    Labels[i-1]:=w;
  end;
end;

function fonctionTpolyline_Xlabel(i:integer;pu: pointer): integer;
begin
  with Tpolyline(pu) do
  begin
    if (i<1) or (i> count)  then sortieErreur('Tpolyline.Xlabel : index out of range');
    result:= Xlabel[i-1];
  end;
end;

procedure proTpolyline_Xlabel(i:integer;w: integer;pu: pointer);
begin
  with Tpolyline(pu) do
  begin
    if (i<1) or (i> count)  then sortieErreur('Tpolyline.Xlabel : index out of range');
    Xlabel[i-1]:=w;
  end;
end;

function fonctionTpolyline_Ylabel(i:integer;pu: pointer): integer;
begin
  with Tpolyline(pu) do
  begin
    if (i<1) or (i> count)  then sortieErreur('Tpolyline.Ylabel : index out of range');
    result:= Ylabel[i-1];
  end;
end;

procedure proTpolyline_Ylabel(i:integer;w: integer;pu: pointer);
begin
  with Tpolyline(pu) do
  begin
    if (i<1) or (i> count)  then sortieErreur('Tpolyline.Ylabel : index out of range');
    Ylabel[i-1]:=w;
  end;
end;




{************************* Méthodes STM de TXYplot ***************************}


procedure proTXYplot_create(stName:AnsiString;var pu:typeUO);
begin
  createPgObject(stname,pu,TXYplot);
end;

procedure proTXYplot_create_1(var pu:typeUO);
begin
  createPgObject('',pu,TXYplot);
end;

procedure proTXYplot_addPolyLine(var pu:typeUO);
begin
  verifierObjet(pu);
  with TXYplot(pu) do addPolyLine;
end;

function fonctionTXYplot_count(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  result:=TXYplot(pu).polyLineCount;
end;

procedure proTXYplot_clear(var pu:typeUO);
begin
  verifierObjet(pu);
  with TXYplot(pu) do clear;
end;


function fonctionTXYplot_polyLines(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TXYplot(pu) do
  begin
    ControleParam(i,1,PolyLineCount,E_line1);
    result:=list0.items[i-1];
  end;
end;

function fonctionTXYplot_last(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TXYplot(pu) do
  begin
    result:=list0.Last;
  end;
end;


procedure proTXYplot_NextColor(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYplot(pu).NextColor:=w;
end;

function fonctionTXYplot_NextColor(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TXYplot(pu).NextColor;
end;

procedure proTXYplot_NextColor2(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYplot(pu).NextColor2:=w;
end;

function fonctionTXYplot_NextColor2(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TXYplot(pu).NextColor2;
end;






Initialization
AffDebug('Initialization stmGraph2',0);

installError(E_line,'TpolyLine:line number out of range');
installError(E_line1,'TXYplot:line number out of range');

registerObject(TXYplot,data);

end.
