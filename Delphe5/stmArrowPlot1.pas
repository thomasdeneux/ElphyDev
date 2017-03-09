unit stmArrowPlot1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,forms,controls,menus,stdCtrls,
     editcont,
     util1,Gdos,DdosFich,Dgraphic,
     Dpalette,Ncdef2,

     stmDef,stmObj,
     varconf1,stmDPlot,
     debug0,
     listG,dtf0,Dtrace1,
     stmError,stmPg,
     XYPedit1,stmPopup,

     stmvec1,geometry1,
     BinFile1;

type

  Tarrow=object
           x,y:single;
           len,theta:single;
           TipLen,TipWidth:single;
           color:integer;
           lineWidth:single;
           Xlabel,Ylabel:integer;
           procedure display;
         end;
  Parrow=^Tarrow;

  TarrowList=class(TlistG)
            private


              procedure setX(i:integer;x:float);
              function getX(i:integer):float;

              procedure setY(i:integer;x:float);
              function getY(i:integer):float;

              procedure setLen(i:integer;x:float);
              function getLen(i:integer):float;

              procedure setTheta(i:integer;x:float);
              function getTheta(i:integer):float;

              procedure setColor(i:integer;x:integer);
              function getColor(i:integer):integer;

              procedure setTipLen(i:integer;x:float);
              function getTipLen(i:integer):float;

              procedure setTipWidth(i:integer;x:float);
              function getTipWidth(i:integer):float;

              procedure setXlabel(i:integer;x:integer);
              function getXlabel(i:integer):integer;

              procedure setYlabel(i:integer;x:integer);
              function getYlabel(i:integer):integer;

            public
              Def:Tarrow;

              constructor create;
              procedure addPoint(x1,y1,len1,theta1:float;
                                 Const col1:integer=-1;
                                 const lineWidth1:float=-1;
                                 const TipLen1: float=-1;
                                 const TipWidth1:float=-1);

              property X[i:integer]:float read getX write setX;  {i commence à 0 }
              property Y[i:integer]:float read getY write setY;
              property Len[i:integer]:float read getLen write setLen;
              property Theta[i:integer]:float read getTheta write setTheta;
              property TipLen[i:integer]:float read getTipLen write setTipLen;
              property TipWidth[i:integer]:float read getTipWidth write setTipWidth;
              property Color[i:integer]:integer read getColor write setColor;
              property Xlabel[i:integer]:integer read getXlabel write setXlabel;  {i commence à 0 }
              property Ylabel[i:integer]:integer read getYlabel write setYlabel;

            end;

  TarrowPlot=class(TDataPlot)
           private
              Arrows: Tarrowlist;
              labels: TstringList;
              LabelFont:Tfont;
           public
              constructor create;override;
              destructor destroy;override;

              class function STMClassName:AnsiString;override;

              procedure clear;

              function ChooseCoo1:boolean;override;

              procedure display0(ExternalWorld,logX,logY:boolean);
              procedure display; override;
              procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean; const order:integer=-1);override;

              procedure cadrerX(sender:Tobject);override;
              procedure cadrerY(sender:Tobject);override;

              procedure autoscaleX;override;
              procedure autoscaleY;override;

              procedure invalidate;override;

              procedure getWorldPriorities(var Fworld,FlogX,FlogY:boolean;
                                           var x1,y1,x2,y2:float);override;

              procedure saveAsSingle(f:Tstream);override;
              procedure addPoint(x1,y1,len1,theta1:float;
                                 Const col1:integer=-1;
                                 const lineWidth1:float=-1;
                                 const TipLen1: float=-1;
                                 const TipWidth1:float=-1;
                                 const lbl:string='');

            end;


procedure proTArrowPlot_create(var pu:typeUO);pascal;
procedure proTArrowPlot_addPoint(x,y,len,theta:float;color:integer; lineWidth,tipLen,TipWidth:float;var pu:typeUO);pascal;
procedure proTArrowPlot_addPoint_1(x,y,len,theta:float;color:integer; var pu:typeUO);pascal;
procedure proTArrowPlot_addPoint_2(x,y,len,theta:float; var pu:typeUO);pascal;
function fonctionTArrowPlot_count(var pu:typeUO):longint;pascal;
procedure proTArrowPlot_clear(var pu:typeUO);pascal;

procedure proTArrowPlot_SaveSingleData(var binF: TbinaryFile;var pu:typeUO);pascal;

function fonctionTArrowPlot_X(i:integer;var pu:typeUO): float;pascal;
procedure proTArrowPlot_X(i:integer;w: float;var pu:typeUO);pascal;

function fonctionTArrowPlot_Y(i:integer;var pu:typeUO): float;pascal;
procedure proTArrowPlot_Y(i:integer;w: float;var pu:typeUO);pascal;

function fonctionTArrowPlot_Len(i:integer;var pu:typeUO): float;pascal;
procedure proTArrowPlot_Len(i:integer;w: float;var pu:typeUO);pascal;

function fonctionTArrowPlot_Theta(i:integer;var pu:typeUO): float;pascal;
procedure proTArrowPlot_Theta(i:integer;w: float;var pu:typeUO);pascal;

function fonctionTArrowPlot_Label(i:integer;var pu:typeUO): AnsiString;pascal;
procedure proTArrowPlot_Label(i:integer;w: AnsiString;var pu:typeUO);pascal;

function fonctionTarrowPlot_font(var pu:typeUO):pointer;pascal;

function fonctionTArrowPlot_Xlabel(i:integer;var pu:typeUO): integer;pascal;
procedure proTArrowPlot_Xlabel(i:integer;w: integer;var pu:typeUO);pascal;
function fonctionTArrowPlot_Ylabel(i:integer;var pu:typeUO): integer;pascal;
procedure proTArrowPlot_Ylabel(i:integer;w: integer;var pu:typeUO);pascal;


implementation


{ Tarrow }
type
  TRpoint=record
            x,y:double;
          end;

procedure Tarrow.display;
var
  i:integer;
  pR:array[0..7] of TRpoint;
  p:array[0..7] of Tpoint;
  x2,y2:double;
begin
  if len=0 then exit;
  
  pr[0].x:=0;
  pr[0].y:=-lineWidth/2;

  pr[1].x:=Len-TipLen;
  pr[1].y:=-lineWidth/2;

  pr[2].x:=Len-TipLen;
  pr[2].y:=-TipWidth/2;

  pr[3].x:=Len;
  pr[3].y:=0;

  pr[4].x:=Len-TipLen;
  pr[4].y:=TipWidth/2;

  pr[5].x:=Len-TipLen;
  pr[5].y:=lineWidth/2;

  pr[6].x:=0;
  pr[6].y:=lineWidth/2;

  pr[7].x:=0;
  pr[7].y:=-lineWidth/2;

  for i:=0 to 7 do
  begin
    with pr[i] do
    begin
      x2:=x*cos(theta)-y*sin(theta);
      y2:=x*sin(theta)+y*cos(theta);
    end;
    p[i].x:=convWx( self.x+x2 );
    p[i].y:=convWy( self.y+y2 );
  end;

  canvasGlb.Pen.Color:=color;
  canvasGlb.brush.Color:=color;

  canvasGlb.Polygon(p);
end;


{ TarrowList }

procedure TarrowList.addPoint(x1,y1,len1,theta1:float;Const col1:integer=-1; const lineWidth1:float=-1; const TipLen1: float=-1;const TipWidth1:float=-1);
begin
  def.x:=x1;
  def.y:=y1;
  def.len:=len1;
  def.theta:=theta1;

  if col1>=0 then def.color:=col1;
  if TipLen1>0 then def.TipLen:=TipLen1;
  if TipWidth1>0 then def.TipWidth:=TipWidth1;
  if lineWidth1>0 then def.lineWidth:=lineWidth1;

  add(@def);
end;

constructor TarrowList.create;
begin
  inherited create(sizeof(Tarrow));
  def.TipLen:=2;
  def.TipWidth:=1;
  def.lineWidth:=1;
end;

function TarrowList.getColor(i: integer): integer;
begin
  if (i>=0) and (i<count) then result:=Parrow(items[i])^.color;
end;

function TarrowList.getLen(i: integer): float;
begin
  if (i>=0) and (i<count) then result:=Parrow(items[i])^.Len;
end;

function TarrowList.getTheta(i: integer): float;
begin
  if (i>=0) and (i<count) then result:=Parrow(items[i])^.Theta;
end;

function TarrowList.getTipLen(i: integer): float;
begin
  if (i>=0) and (i<count) then result:=Parrow(items[i])^.TipLen;
end;

function TarrowList.getTipWidth(i: integer): float;
begin
  if (i>=0) and (i<count) then result:=Parrow(items[i])^.TipWidth;
end;

function TarrowList.getX(i: integer): float;
begin
  if (i>=0) and (i<count) then result:=Parrow(items[i])^.x;
end;

function TarrowList.getXlabel(i: integer): integer;
begin
  if (i>=0) and (i<count) then result:=Parrow(items[i])^.xlabel;
end;

function TarrowList.getY(i: integer): float;
begin
  if (i>=0) and (i<count) then result:=Parrow(items[i])^.y;
end;

function TarrowList.getYlabel(i: integer): integer;
begin
  if (i>=0) and (i<count) then result:=Parrow(items[i])^.ylabel;
end;

procedure TarrowList.setColor( i,x: integer);
begin
  if (i>=0) and (i<count) then Parrow(items[i])^.color:=x;
end;

procedure TarrowList.setLen( i: integer; x: float);
begin
  if (i>=0) and (i<count) then Parrow(items[i])^.Len:=x;
end;

procedure TarrowList.setTheta(i: integer; x: float);
begin
  if (i>=0) and (i<count) then Parrow(items[i])^.Theta:=x;
end;

procedure TarrowList.setTipLen(i: integer; x: float );
begin
  if (i>=0) and (i<count) then Parrow(items[i])^.TipLen:=x;
end;

procedure TarrowList.setTipWidth(i: integer; x: float);
begin
  if (i>=0) and (i<count) then Parrow(items[i])^.TipWidth:=x;
end;

procedure TarrowList.setX(i: integer; x: float);
begin
  if (i>=0) and (i<count) then Parrow(items[i])^.X:=x;
end;

procedure TarrowList.setXlabel(i, x: integer);
begin
  if (i>=0) and (i<count) then Parrow(items[i])^.Xlabel:=x;
end;

procedure TarrowList.setY( i: integer; x: float);
begin
  if (i>=0) and (i<count) then Parrow(items[i])^.Y:=x;
end;

procedure TarrowList.setYlabel(i, x: integer);
begin
  if (i>=0) and (i<count) then Parrow(items[i])^.Ylabel:=x;
end;

{ TarrowPlot }

procedure TarrowPlot.addPoint(x1, y1, len1, theta1: float;
  const col1: integer; const lineWidth1, TipLen1, TipWidth1: float;
  const lbl: string);
begin
  arrows.addPoint(x1, y1, len1, theta1, col1, lineWidth1, TipLen1, TipWidth1);
  labels.Add(lbl);
end;

procedure TarrowPlot.autoscaleX;
begin
  inherited;

end;

procedure TarrowPlot.autoscaleY;
begin
  inherited;

end;

procedure TarrowPlot.cadrerX(sender: Tobject);
begin
  inherited;

end;

procedure TarrowPlot.cadrerY(sender: Tobject);
begin
  inherited;

end;

function TarrowPlot.ChooseCoo1: boolean;
begin
  result:=inherited ChooseCoo1;
end;

procedure TarrowPlot.clear;
begin
  Arrows.Clear;
end;

constructor TarrowPlot.create;
begin
  inherited;
  Arrows:=Tarrowlist.create;
  Labels:=TstringList.create;
  LabelFont:=Tfont.Create;
end;

destructor TarrowPlot.destroy;
begin
  Arrows.Free;
  Labels.Free;
  LabelFont.free;
  inherited;
end;

procedure TarrowPlot.display;
var
  x1,y1,x2,y2:integer;
  BKcolor:longint;
  old:Tfont;
  rectI:Trect;
  R,Y0:float;
const
  dd=5;
begin
  old:=canvasGlb.font;
  canvasGlb.font:=visu.fontVisu;

  BKcolor:=canvasGlb.brush.color;

  getWindowG(x1,y1,x2,y2);

  rectI:=getInsideWindow;

  with rectI do
  begin
    setWindow(left,top,right,bottom);
    if right>left then R:=(bottom-top)/(right-left) else R:=1;
  end;

  Y0:=(Ymin+Ymax)/2;

  Ymin:=Y0- R*(Xmax-Xmin)/2;
  Ymax:=Y0+ R*(Xmax-Xmin)/2;


  display0(false,false,false);
  visu.DisplayScale;

  setWindow(x1,y1,x2,y2);

  canvasGlb.brush.color:=BKcolor;
  canvasGlb.font:=old;
end;

procedure TarrowPlot.display0(ExternalWorld, logX, logY: boolean);
var
  pcol,bcol:Tcolor;
  psty:TpenStyle;
  bsty:TbrushStyle;
  i:integer;

  oldFont:Tfont;
begin
  if not externalWorld then  Dgraphic.setWorld(xmin,ymin,xmax,ymax);

  with canvasGlb do
  begin
    pcol:=pen.color;
    psty:=pen.style;

    bcol:=brush.color;
    bsty:=brush.style;

    pen.Style:=psSolid;
    brush.Style:=bsSolid;

    oldFont:=font;
    font:=LabelFont;

    for i:=0 to arrows.count-1 do
    with PArrow(arrows[i])^ do
    begin
      display;
      brush.Style:=bsClear;
      textOut(convWx(x)+Xlabel,convWy(y)+Ylabel,Labels[i]);
      brush.Style:=bsSolid;
    end;

    pen.color:=pcol;
    pen.style:=psty;

    brush.color:=bcol;
    brush.style:=bsty;
    font:=oldFont;
  end;

end;




procedure TarrowPlot.displayInside(FirstUO: typeUO; extWorld, logX, logY: boolean; const order:integer=-1);
begin
  display0(true,logX,logY);

end;

procedure TarrowPlot.getWorldPriorities(var Fworld, FlogX, FlogY: boolean;
  var x1, y1, x2, y2: float);
begin
  Fworld:=true;
  FlogX:=visu.modelogX;
  FlogY:=visu.modelogY;
  x1:=visu.Xmin;
  x2:=visu.Xmax;
  y1:=visu.Ymin;
  y2:=visu.Ymax;


end;

procedure TarrowPlot.invalidate;
begin
  inherited;

end;


procedure TarrowPlot.saveAsSingle(f: Tstream);
var
  i:integer;
begin
  for i:=0 to arrows.count-1 do
  with PArrow(arrows[i])^ do
  begin
    f.Write(x,sizeof(single));
    f.Write(y,sizeof(single));
    f.Write(len,sizeof(single));
    f.Write(theta,sizeof(single));
  end;
end;

class function TarrowPlot.STMClassName: AnsiString;
begin
  result:='ArrowPlot';
end;



procedure proTArrowPlot_create(var pu:typeUO);
begin
  createPgObject('',pu,TArrowPlot);
end;

procedure proTArrowPlot_addPoint(x,y,len,theta:float;color:integer; lineWidth,tipLen,TipWidth:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TarrowPlot(pu).addPoint(x,y,len,theta,color,lineWidth,tipLen,TipWidth,'');
end;

procedure proTArrowPlot_addPoint_1(x,y,len,theta:float;color:integer; var pu:typeUO);
begin
  verifierObjet(pu);
  TarrowPlot(pu).addPoint(x,y,len,theta,color);
end;

procedure proTArrowPlot_addPoint_2(x,y,len,theta:float; var pu:typeUO);
begin
  verifierObjet(pu);
  TarrowPlot(pu).addPoint(x,y,len,theta);
end;


function fonctionTArrowPlot_count(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  result:=TarrowPlot(pu).arrows.Count;
end;

procedure proTArrowPlot_clear(var pu:typeUO);
begin
  verifierObjet(pu);
  TarrowPlot(pu).arrows.Clear;
end;

procedure proTArrowPlot_SaveSingleData(var binF: TbinaryFile;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(binF));

  TarrowPlot(pu).saveAsSingle(binF.f);
end;

function fonctionTArrowPlot_X(i:integer;var pu:typeUO): float;
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.X : index out of range');
    result:= arrows.X[i-1];
  end;
end;

procedure proTArrowPlot_X(i:integer;w: float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.X : index out of range');
    arrows.X[i-1]:=w;
  end;
end;

function fonctionTArrowPlot_Y(i:integer;var pu:typeUO): float;
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.Y : index out of range');
    result:= arrows.Y[i-1];
  end;
end;

procedure proTArrowPlot_Y(i:integer;w: float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.Y : index out of range');
    arrows.Y[i-1]:=w;
  end;
end;

function fonctionTArrowPlot_Len(i:integer;var pu:typeUO): float;
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.Len : index out of range');
    result:= arrows.Len[i-1];
  end;
end;

procedure proTArrowPlot_Len(i:integer;w: float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.Len : index out of range');
    arrows.Len[i-1]:=w;
  end;
end;

function fonctionTArrowPlot_Theta(i:integer;var pu:typeUO): float;
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.Theta : index out of range');
    result:= arrows.Theta[i-1];
  end;
end;

procedure proTArrowPlot_Theta(i:integer;w: float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.Theta : index out of range');
    arrows.Theta[i-1]:=w;
  end;
end;


function fonctionTarrowPlot_font(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    result:= LabelFont;
  end;
end;

function fonctionTArrowPlot_Label(i:integer;var pu:typeUO): AnsiString;
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.Label : index out of range');
    result:=Labels[i-1];
  end;
end;

procedure proTArrowPlot_Label(i:integer;w: AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.Label : index out of range');
    Labels[i-1]:=w;
  end;
end;

function fonctionTArrowPlot_Xlabel(i:integer;var pu:typeUO): integer;
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.Xlabel : index out of range');
    result:= arrows.Xlabel[i-1];
  end;
end;

procedure proTArrowPlot_Xlabel(i:integer;w: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.Xlabel : index out of range');
    arrows.Xlabel[i-1]:=w;
  end;
end;

function fonctionTArrowPlot_Ylabel(i:integer;var pu:typeUO): integer;
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.Ylabel : index out of range');
    result:= arrows.Ylabel[i-1];
  end;
end;

procedure proTArrowPlot_Ylabel(i:integer;w: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TarrowPlot(pu) do
  begin
    if (i<1) or (i> arrows.count)  then sortieErreur('TArrowPlot.Ylabel : index out of range');
    arrows.Ylabel[i-1]:=w;
  end;
end;


Initialization
AffDebug('Initialization stmArrowPlot1',0);

registerObject(TArrowPlot,data);

end.
