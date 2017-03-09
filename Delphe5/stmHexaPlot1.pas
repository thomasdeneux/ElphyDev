unit stmHexaPlot1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,types, graphics, sysutils, math,
     util1,Dgraphic,
     stmdef,stmObj,debug0,
     stmGraph2,stmMat1,stmCplot1,
     ncdef2,stmPg,
     visu0,Dtrace1, Dpalette, HexaCood0;


type
  THpoint = record
              x,y:integer;
              mark:boolean;
            end;

  TarrayOfPoints= array of THpoint;

  Ttraj=  record
            p1,p2: integer;
          end;

  TarrayOfTtraj = array of Ttraj;
  TNNB= array of array of integer;

  THexaPlot=class(TXYplot)
           private
             Forder:integer;
             Fvalues: array of array of float;

             x0traj, y0traj:float;
             deltaPoint:float;
             Theta0:float;

             Fpoints: TarrayOfPoints;
             FSpoints: TarrayOfPoints;

             Ftraj0:  TarrayOfTtraj;
             FStraj: TarrayOfTtraj;

             NNB0: TNNB;
             NNBS: TNNB;

             NNB:TNNB;
             Ftraj: TarrayOfTtraj;
             Cvalues: function (p:integer):float of object;

             level0:float;
             Vmark:array of boolean;

             Cplot:TXYplot;
             dpal:TDpalette;
             palName:AnsiString;
             degP:typeDegre;

             FlagUpdate:boolean;

             function getValues(i,j:integer):float;
             procedure setValues(i,j:integer;w:float);

             function getPValues(p:integer):float;

             procedure setOrder(n:integer);
             procedure PtToXYScreen(p:integer;var X,Y:float);

             procedure setUpoints(var pts:TarrayOfPoints; n:integer);

             procedure SetTraj(Fpoints: TarrayOfPoints; var Ftraj: TarrayOfTtraj);

             procedure UpdateXYplot;
             procedure AddHexa(xc,yc,R,alpha:float;Ycol:float);
             procedure BuildHexaPlot;
             procedure BuildSmoothHexaPlot;

             procedure calculNNB(Ftraj: TarrayOfTtraj; var NNB:TNNB);
             procedure stockerH(i:integer);
             function fermer(i1,i2:integer):boolean;
             procedure traiterH(i:integer; var b:boolean);
             procedure CalculCplot(var cplot1:TXYplot; level:float; smooth:boolean);

             function SmoothValues(p:integer):float;

             procedure setPalColor(n:integer;x:integer);
             function getPalColor(n:integer):integer;


             property Gamma:single read visu.gamma write visu.gamma;
             property TwoCol:boolean read visu.twoCol write visu.TwoCol;
             property PalColor[n:integer]:integer read getPalColor write setPalColor;
             property DisplayMode:byte read visu.modeMat write visu.modeMat;

             function NearTraj(var s1,s2:Ttraj) :boolean;
             function Periph(var s:Ttraj):boolean;
           public

             constructor create;override;
             destructor destroy;override;
             class function STMClassName:AnsiString;override;
             function ChooseCoo1:boolean;override;
             procedure cadrerZ(sender:Tobject);override;
             procedure autoscaleZ;override;

             property Order:integer read Forder write setOrder;
             property Values[i,j:integer]:float  read getValues write setValues;

             procedure display; override;
             procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);override;

           end;

procedure proTHexaPlot_create(order: integer;var pu:typeUO);pascal;
procedure proTHexaPlot_HexaMode(n: integer;var pu:typeUO);pascal;
function fonctionTHexaPlot_HexaMode(var pu:typeUO):integer;pascal;
procedure proTHexaPlot_BuildContour(var plot: TXYPlot; level:float;smooth:boolean; var pu:typeUO);pascal;

procedure proTHexaPlot_AutoscaleZ(var pu:typeUO);pascal;

function fonctionTHexaPlot_Zvalue(i,j:longint;var pu:typeUO):float;pascal;
procedure proTHexaPlot_Zvalue(i,j:longint;w:float;var pu:typeUO);pascal;


function fonctionTHexaPlot_PointCount(p: integer;var pu:typeUO):integer;pascal;
function fonctionTHexaPlot_Ipoint(p: integer;var pu:typeUO):integer;pascal;
function fonctionTHexaPlot_Jpoint(p: integer;var pu:typeUO):integer;pascal;

function fonctionTHexaPlot_Zpoint(p: integer;var pu:typeUO):float;pascal;
procedure proTHexaPlot_Zpoint(p:longint;w:float;var pu:typeUO);pascal;

function fonctionTHexaPlot_Mark(p: integer;var pu:typeUO):boolean;pascal;
procedure proTHexaPlot_Mark(p:longint;w:boolean;var pu:typeUO);pascal;


function fonctionTHexaPlot_Zmin(var pu:typeUO):float;pascal;
procedure proTHexaPlot_Zmin(x:float;var pu:typeUO);pascal;

function fonctionTHexaPlot_Zmax(var pu:typeUO):float;pascal;
procedure proTHexaPlot_Zmax(x:float;var pu:typeUO);pascal;

function fonctionTHexaPlot_gamma(var pu:typeUO):float;pascal;
procedure proTHexaPlot_gamma(x:float;var pu:typeUO);pascal;

function fonctionTHexaPlot_TwoColors(var pu:typeUO):boolean;pascal;
procedure proTHexaPlot_TwoColors(x:boolean;var pu:typeUO);pascal;

function fonctionTHexaPlot_PalColor(n:smallint;var pu:typeUO):smallInt;pascal;
procedure proTHexaPlot_PalColor(n:smallint;x:smallInt;var pu:typeUO);pascal;

procedure proTHexaPlot_DisplayMode(x:integer;var pu:typeUO);pascal;
function fonctionTHexaPlot_DisplayMode(var pu:typeUO):integer;pascal;

procedure proTHexaPlot_PalName(x:AnsiString;var pu:typeUO);pascal;
function fonctionTHexaPlot_PalName(var pu:typeUO):AnsiString;pascal;

function fonctionTHexaPlot_theta(var pu:typeUO):float;pascal;
procedure proTHexaPlot_theta(x:float;var pu:typeUO);pascal;

implementation


function Hpoint(x1,y1:integer;m:boolean):THpoint;
begin
  with result do
  begin
    x:=x1;
    y:=y1;
    mark:=m;
  end;
end;

function Idistance(p1,p2:THpoint):float;
var
  i,j:integer;
begin
  i:=p1.X-p2.X;
  j:=p1.y-p2.y;

  result:=sqrt(sqr(cos(pi/3)*j+i)+sqr(sin(pi/3)*j));                      
end;


function ThexaPlot.NearTraj(var s1,s2:Ttraj) :boolean;
  function NearPoint(var p1,p2:integer):boolean;
  var
    d:float;
  begin
    d:=Idistance(Fpoints[p1],Fpoints[p2]);
    NearPoint:= (d>0.999) and (d<1.001);
  end;

  function SamePoint(var p1,p2:integer):boolean;
  begin
    SamePoint:=(p1=p2);
  end;

begin
  NearTraj:=  samePoint(s1.p1,s2.p1) and NearPoint(s1.p2,s2.p2)
              or
              samePoint(s1.p2,s2.p2) and NearPoint(s1.p1,s2.p1)
              or
              samePoint(s1.p1,s2.p2) and NearPoint(s1.p2,s2.p1)
              or
              samePoint(s1.p2,s2.p1) and NearPoint(s1.p1,s2.p2);
end;

function ThexaPlot.Periph(var s:Ttraj):boolean;
begin
  Periph:=(abs(Fpoints[s.p1].x)=order) or (abs(Fpoints[s.p1].y)=order) or (abs(Fpoints[s.p1].x +Fpoints[s.p1].y)=3)
          or
          (abs(Fpoints[s.p2].x)=order) or (abs(Fpoints[s.p2].y)=order) or (abs(Fpoints[s.p2].x +Fpoints[s.p2].y)=3);
end;


{ THexaPlot }

constructor THexaPlot.create;
begin
  inherited;

  palColor[1]:=1;
  palColor[2]:=2;
  
  deltaPoint:=1;
end;

destructor THexaPlot.destroy;
begin

  inherited;
end;

function ThexaPlot.getValues(i,j:integer):float;
begin
  if (i>=-order) and (i<=order) and (j>=-order) and (j<=order)
    then result:=Fvalues[order+i,order+j]
    else result:=0;
end;

procedure ThexaPlot.setValues(i,j:integer;w:float);
begin
  if (i>=-order) and (i<=order) and (j>=-order) and (j<=order)
    then Fvalues[order+i,order+j]:=w;
end;

procedure THexaPlot.setOrder(n: integer);
var
  i,j:integer;
  d:float;
const
  TT=2.2;
begin
  Forder:=n;
  setUpoints(Fpoints,n);
  setLength(FSpoints,0);

  setLength(Ftraj,0);
  setLength(FStraj,0);

  setLength(NNB0,0);
  setLength(NNBS,0);

  setLength(Fvalues,2*order+1,2*order+1);
  for i:=0 to high(Fvalues) do
  for j:=0 to high(Fvalues[0]) do
    Fvalues[i,j]:=0;

  {Provisoire
  for i:=0 to high(Fpoints) do
  with Fpoints[i] do
  begin
    d:=Idistance(point(x,y),point(1,1));
    Fvalues[order+x,order+y]:= 127+100*sin(2*pi/TT*d);
  end;
  }
end;


class function THexaPlot.STMClassName: AnsiString;
begin
  result:='HexaPlot';
end;

function THexaPlot.ChooseCoo1:boolean;
var
  chg:boolean;
  title0:AnsiString;
  palName0:AnsiString;
  wf0:TwfOptions;
begin
  Initvisu0;

  title0:=title;
  palName0:=palName;

  if Hexacood.choose(title0,visu0^,palName0,degP,cadrerX,cadrerY,cadrerZ) then
    begin
      chg:= not visu.compare(visu0^) or (title<>title0) or (palName0<>palName);
      visu.Assign(visu0^);
      title:=title0;
      palName:=palName0;
      theta0:=degP.theta;
    end
  else chg:=false;

  DoneVisu0;
  chooseCoo1:=chg;

  if chg then UpdateXYplot;
end;

procedure THexaPlot.cadrerZ(sender:Tobject);
var
  i:integer;
  z,min,max:float;
begin
  if length(Fpoints)=0 then exit;

  min:=1E1000;
  max:=-1E1000;

  for i:=0 to high(Fpoints) do
  with Fpoints[i] do
  begin
    z:=values[x,y];
    if z<min then min:=z;
    if z>max then max:=z;
  end;

  visu0^.Zmin:=min;
  visu0^.Zmax:=max;
end;

procedure THexaPlot.autoscaleZ;
var
  i:integer;
  z,min,max:float;
begin
  if length(Fpoints)=0 then exit;

  min:=1E1000;
  max:=-1E1000;

  for i:=0 to high(Fpoints) do
  with Fpoints[i] do
  begin
    z:=values[x,y];
    if z<min then min:=z;
    if z>max then max:=z;
  end;

  Zmin:=min;
  Zmax:=max;
end;


procedure ThexaPlot.PtToXYScreen(p:integer;var X,Y:float);
var
  x1,y1:float;
  sin0,cos0:float;
  i,j:integer;
begin
  i:= Fpoints[p].x;
  j:= Fpoints[p].y;

  x1:=(cos(pi/3)*j+i)*DeltaPoint;
  y1:=sin(pi/3)*j*DeltaPoint;

  sin0:=sin(theta0*Pi/180);
  cos0:=cos(theta0*Pi/180);

  x:=x1*cos0-y1*sin0 + X0traj;
  y:=x1*sin0+y1*cos0 + Y0traj;
end;


procedure ThexaPlot.setUpoints(var pts:TarrayOfPoints; n:integer);
var
  i,j:integer;
  d:float;
  p0:THpoint;
begin
  p0:=Hpoint(0,0,false);
  setLength(pts,0);
  for i:=-n to n do
  for j:=-n to n do
  begin
    d:=Idistance(p0,Hpoint(i,j,false));
    if (d<n +0.001) and (abs(i+j)<=n) then
    begin
      setLength(pts,length(pts)+1);
      with pts[High(pts)] do
      begin
        x:=i;
        y:=j;
        mark:=false;
      end;
    end;
  end;
end;




procedure ThexaPlot.SetTraj(Fpoints: TarrayOfPoints; var Ftraj: TarrayOfTtraj);
var
  i,j:integer;
  d:integer;
begin
  for i:=0 to high(Fpoints) do
  for j:=i to high(Fpoints) do
  begin
    d:=round(Idistance(Fpoints[i],Fpoints[j]));
    if d=1 then
    begin
      setLength(Ftraj,length(Ftraj)+1);
      with Ftraj[high(Ftraj)] do
      begin
        p1:=i;
        p2:=j;
      end;
    end;
  end;
end;







procedure ThexaPlot.AddHexa(xc,yc,R,alpha:float;Ycol:float);
var
  i:integer;
  col:integer;
begin
  col:= dpal.ColorPal(Ycol);

  addPolyLine;
  with LastPolyLine do
  begin
    for i:=0 to 6 do addPoint(xc+R*cos(pi/3*i+pi/6+alpha),yc+R*sin(pi/3*i+pi/6+alpha));
    color:=col;
    color2:=col;
    modeT:=DM_polygon;
  end;
end;

procedure ThexaPlot.BuildHexaPlot;
var
  i,k:integer;
  xr,yr:float;
begin
  dpal:=TDpalette.create;
  with visu do
  begin
    dpal.setColors(TmatColor(color).col1,TmatColor(color).col2,TwoCol,0);
    dpal.setType(palName);
    dpal.SetPalette(Zmin,Zmax,gamma);
  end;

  for i:=0 to high(Fpoints) do
  begin
    PtToXYscreen(i,xr,yr);
    AddHexa(xr,yr,deltaPoint/sqrt(3),theta0*pi/180 ,getPvalues(i));
  end;

  dpal.free;
end;

procedure ThexaPlot.BuildSmoothHexaPlot;
var
  i,k:integer;
  xr,yr:float;
begin
  dpal:=TDpalette.create;
  with visu do
  begin
    dpal.setColors(TmatColor(color).col1,TmatColor(color).col2,TwoCol,0);
    dpal.setType(palName);
    dpal.SetPalette(Zmin,Zmax,gamma);
  end;

  if not assigned(FSpoints) then setUpoints(FSpoints,order*3);
  DeltaPoint:=DeltaPoint/3;

  for i:=0 to high(FSpoints) do
  begin
    PtToXYscreen(i,xr,yr);
    AddHexa(xr,yr,deltaPoint/sqrt(3),theta0*pi/180 ,Smoothvalues(i));
  end;

  DeltaPoint:=DeltaPoint*3;
  dpal.free;
end;


procedure THexaPlot.UpdateXYplot;
var
  i:integer;
  x1,y1:float;
begin
  clear;

  case visu.ModeMat of
    0: BuildHexaPlot;
    1: BuildSmoothHexaPlot;
    2: begin
         nextColor:=scaleColor;
         for i:=0 to high(Ftraj) do
         begin
          addPolyLine;
          with polylines[i] do
          begin
            PtToXyscreen(Ftraj[i].p1,x1,y1);
            addPoint(x1,y1);
            PtToXyscreen(Ftraj[i].p2,x1,y1);
            addPoint(x1,y1);
          end;
         end;
       end;
  end;

  flagUpDate:=false;
end;



procedure ThexaPlot.calculNNB(Ftraj: TarrayOfTtraj; var NNB:TNNB);
var
  i,j:integer;
  k:array of integer;
begin
  setLength(NNB,length(Ftraj),4);
  for i:=0 to high(NNB) do
  for j:=0 to high(NNB[0]) do
    NNB[i,j]:=-1;

  setLength(k,length(Ftraj));
  for i:=0 to high(k) do k[i]:=0;

  for i:=0 to high(Ftraj) do
    for j:=0 to high(Ftraj) do
    if nearTraj(Ftraj[i],Ftraj[j]) then
    if k[i]<4 then
    begin
      NNB[i,k[i]]:=j;
      inc(k[i]);
    end
    else messageCentral('k[i]=4 for i='+Istr(i));
end;



var
  ptCount:integer;
  lastI:integer;



procedure ThexaPlot.stockerH(i:integer);
var
  x,y,vv1,vv2:float;
  x1,y1,x2,y2:float;
begin
  with Ftraj[i] do
  begin
    vv1:=CValues(p1);
    vv2:=CValues(p2);

    PtToXYscreen(p1,x1,y1);
    PtToXYscreen(p2,x2,y2);
  end;

  if vv2<>vv1 then
  begin
    x:=x1+(x2-x1)*(level0-vv1)/(vv2-vv1);
    y:=y1+(y2-y1)*(level0-vv1)/(vv2-vv1);
  end;


  Cplot.lastPolyLine.addPoint(x,y);
  lastI:=i;
  inc(ptCount);


end;

function ThexaPlot.fermer(i1,i2:integer):boolean;
begin
  result:=nearTraj(Ftraj[i1],Ftraj[i2]);
  if result then stockerH(i1);

end;


procedure ThexaPlot.traiterH(i:integer; var b:boolean);
var
  j, nb:integer;
  b1:boolean;
begin
  b:=false;
  if (i<0) or (i>=length(Ftraj)) or not Vmark[i] then exit;


  stockerH(i);
  Vmark[i]:=false;

  nb:=PtCount;

  b1:=false;
  for j:=0 to 3 do
    if not b1 then traiterH( NNB[i,j],b1 );

  b:=true;

end;


procedure ThexaPlot.CalculCplot(var cplot1:TXYplot; level:float; smooth:boolean);
var
  i:integer;
  nb,ifp:integer;
  b,res:boolean;
  smFact:integer;
begin
  Cplot:=Cplot1;
  level0:=level;

  smFact:=3;

  if smooth then
  begin
    if not assigned(FSpoints) then setUpoints(FSpoints,order*smFact);
    if not assigned(FStraj) then setTraj(FSpoints,FStraj);
    if not assigned(NNBS) then calculNNB(FStraj,NNBS);
    Ftraj:=FStraj;
    NNB:=NNBS;
    Cvalues:=SmoothValues;
    DeltaPoint:=DeltaPoint/smFact;
  end
  else
  begin
    if not assigned(Fpoints) then setUpoints(Fpoints,order);
    if not assigned(Ftraj0) then setTraj(Fpoints,Ftraj0);
    if not assigned(NNB0) then calculNNB(Ftraj0,NNB0);
    Ftraj:=Ftraj0;
    NNB:=NNB0;
    Cvalues:=getPValues;
  end;

  setLength(Vmark,length(Ftraj));
  for i:=0 to high(Ftraj) do
  with Ftraj[i] do
  Vmark[i]:= ((CValues(p1)<level0) and (CValues(p2)>=level0)
             or
             (CValues(p2)<level0) and (CValues(p1)>=level0))
             AND
             ( not Fpoints[p1].mark and not Fpoints[p2].mark );





  if (Cplot.PolylineCount=0) or (Cplot.lastPolyline.count>0) then Cplot.addPolyLine;

  for i:=0 to high(Ftraj) do
    if Vmark[i] and Periph(Ftraj[i]) then
    begin
       if Cplot.lastpolyLine.count>0 then Cplot.addPolyLine;
       nb:=ptCount;
       traiterH(i,b);
       ifp:=lastI;

       if not fermer(i,ifp) then
       if b and (ptCount>nb+1) then
       begin
         Vmark[i]:=true;
         Cplot.addPolyLine;
         traiterH(i,b);

         res:=fermer(ifp,lastI);
       end;


    end;

  for i:=0 to high(Ftraj) do
    if Vmark[i] then
    begin
       if Cplot.lastPolyline.count>0 then Cplot.addPolyLine;
       nb:=ptCount;
       traiterH(i,b);
       ifp:=lastI;

       if not fermer(i,ifp) then
       if b and (ptCount>nb+1) then
       begin
         Vmark[i]:=true;
         Cplot.addPolyLine;
         traiterH(i,b);

         res:=fermer(ifp,lastI);
       end;
    end;

  Cplot:=nil;
  if smooth then DeltaPoint:=DeltaPoint*smFact;
end;

function ThexaPlot.SmoothValues(p:integer):float;
var
  im,jm,ir,jr: integer;
begin
  im:= floor(Fpoints[p].x/3);
  jm:= floor(Fpoints[p].y/3);
  ir:=(Fpoints[p].x+300) mod 3;
  jr:=(Fpoints[p].y+300) mod 3;

  case ir of
    0: case jr of
         0: result:= Values[im,jm];
         1: result:= Values[im,jm]*2/3 + Values[im,jm+1]/3 ;
         2: result:= Values[im,jm]/3 + Values[im,jm+1]*2/3 ;
       end;
    1: case jr of
         0: result:= Values[im,jm]*2/3 + Values[im+1,jm]/3 ;
         1: result:= Values[im,jm]/3 + Values[im,jm+1]/3 + Values[im+1,jm]/3;
         2: result:= Values[im,jm+1]*2/3 + Values[im+1,jm]/3 ;
       end;
    2: case jr of
         0: result:= Values[im,jm]/3 + Values[im+1,jm]*2/3 ;
         1: result:= Values[im,jm+1]/3 + Values[im+1,jm]*2/3;
         2: result:= Values[im+1,jm]/3 + Values[im,jm+1]/3 + Values[im+1,jm+1]/3;
       end;
  end;
end;

procedure THexaPlot.setPalColor(n:integer;x:integer);
begin
  case n of
    1:TmatColor(visu.Color).col1:=x;
    2:TmatColor(visu.Color).col2:=x;
  end;
end;

function THexaPlot.getPalColor(n:integer):integer;
begin
  case n of
    1:result:=TmatColor(visu.Color).col1;
    2:result:=TmatColor(visu.Color).col2;
  end;
end;

procedure THexaPlot.display;
begin
  if FlagUpdate then UpdateXYplot;
  inherited;
end;

procedure THexaPlot.displayInside(FirstUO: typeUO; extWorld, logX,
  logY: boolean; const order: integer);
begin
  if FlagUpdate then UpdateXYplot;
  inherited;
end;



{******************************************* Méthodes stm ***********************************}

procedure proTHexaPlot_create(order: integer;var pu:typeUO);
begin
  if (order<0) or (order>1000)
    then sortieErreur('THexaPlot : order out of range');

  createPgObject('',pu,ThexaPlot);
  ThexaPlot(pu).setOrder(order);
  ThexaPlot(pu).UpdateXYplot;
end;

procedure proTHexaPlot_HexaMode(n: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (n<0) or (n>2)
    then sortieErreur('THexaPlot.HexaMode :  value out of range');

  with ThexaPlot(pu) do
  begin
    visu.ModeMat:=n;
    UpdateXYplot;
    invalidate;
  end;
end;

function fonctionTHexaPlot_HexaMode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=ThexaPlot(pu).visu.ModeMat;
end;

procedure proTHexaPlot_BuildContour(var plot: TXYPlot; level:float;smooth:boolean; var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(plot));
  ThexaPlot(pu).calculCplot( plot,level,smooth) ;

end;

procedure proTHexaPlot_AutoscaleZ(var pu:typeUO);
begin
  verifierObjet(pu);
  with ThexaPlot(pu) do
  begin
    autoScaleZ;
    if (cpz<>0) then  messageCpz;
    FlagUpdate:=true;
  end;
end;


function fonctionTHexaPlot_Zvalue(i,j:longint;var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=THexaPlot(pu).values[i,j];
  end;

procedure proTHexaPlot_Zvalue(i,j:longint;w:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with THexaPlot(pu) do
    begin
      values[i,j]:=w;
      FlagUpdate:=true;
    end;
  end;

function fonctionTHexaPlot_PointCount(p: integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= length(THexaPlot(pu).Fpoints);
end;

function fonctionTHexaPlot_Ipoint(p: integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with THexaPlot(pu) do
  begin
    if (p<1) or (p>length(Fpoints)) then sortieErreur('ThexaPlot.Ipoint : index out of range');
    result:= Fpoints[p-1].X;
  end;
end;

function fonctionTHexaPlot_Jpoint(p: integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with THexaPlot(pu) do
  begin
    if (p<1) or (p>length(Fpoints)) then sortieErreur('ThexaPlot.Jpoint : index out of range');
    result:= Fpoints[p-1].Y;
  end;
end;

function fonctionTHexaPlot_Zpoint(p: integer;var pu:typeUO):float;
begin
  verifierObjet(pu);
  with THexaPlot(pu) do
  begin
    if (p<1) or (p>length(Fpoints)) then sortieErreur('ThexaPlot.Zpoint : index out of range');
    result:= values[ Fpoints[p-1].x,Fpoints[p-1].y] ;
  end;
end;

procedure proTHexaPlot_Zpoint(p:longint;w:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with THexaPlot(pu) do
  begin
    if (p<1) or (p>length(Fpoints)) then sortieErreur('ThexaPlot.Zpoint : index out of range');
    values[ Fpoints[p-1].x,Fpoints[p-1].y] := w;
  end;
end;

function fonctionTHexaPlot_Mark(p: integer;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with THexaPlot(pu) do
  begin
    if (p<1) or (p>length(Fpoints)) then sortieErreur('ThexaPlot.Mark : index out of range');
    result:= Fpoints[p-1].mark ;
  end;
end;

procedure proTHexaPlot_Mark(p:longint;w:boolean;var pu:typeUO);pascal;
begin
  verifierObjet(pu);
  with THexaPlot(pu) do
  begin
    if (p<1) or (p>length(Fpoints)) then sortieErreur('ThexaPlot.Mark : index out of range');
    Fpoints[p-1].mark := w;
  end;
end;



function fonctionTHexaPlot_Zmin(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=THexaPlot(pu).visu.Zmin;
  end;

procedure proTHexaPlot_Zmin(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with THexaPlot(pu) do
    begin
      visu.Zmin:=x;
      if (cpz<>0) then
        begin
          messageCpz;
          messageToRef(UOmsg_invalidate,nil);
        end;
      FlagUpdate:=true;
    end;
  end;

function fonctionTHexaPlot_Zmax(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=THexaPlot(pu).visu.Zmax;
  end;

procedure proTHexaPlot_Zmax(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with THexaPlot(pu) do
    begin
      visu.Zmax:=x;
      if (cpz<>0) then
        begin
          messageCpz;
          messageToRef(UOmsg_invalidate,nil);
        end;
      FlagUpdate:=true;
    end;
  end;

function fonctionTHexaPlot_gamma(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=THexaPlot(pu).visu.gamma;
  end;

procedure proTHexaPlot_gamma(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with THexaPlot(pu) do
    begin
      visu.gamma:=x;
      FlagUpdate:=true;
    end;
  end;

function fonctionTHexaPlot_TwoColors(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    result:=THexaPlot(pu).TwoCol;
  end;

procedure proTHexaPlot_TwoColors(x:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    with THexaPlot(pu) do
    begin
      TwoCol:=x;
      FlagUpdate:=true;
    end;
  end;

function fonctionTHexaPlot_PalColor(n:smallint;var pu:typeUO):smallInt;
  begin
    verifierObjet(pu);
    controleParametre(n,1,2);
    result:=THexaPlot(pu).PalColor[n];
  end;

procedure proTHexaPlot_PalColor(n:smallint;x:smallInt;var pu:typeUO);
  begin
    verifierObjet(pu);
    controleParametre(n,1,2);
    with THexaPlot(pu) do
    begin
      PalColor[n]:=x;
      FlagUpdate:=true;
    end;
  end;


procedure proTHexaPlot_DisplayMode(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (x<0) or (x>2) then sortieErreur('ThexaPlot.DisplayMode : value out of range');;
  with THexaPlot(pu) do
  begin
    DisplayMode:=x;
    FlagUpdate:=true;
  end;
end;

function fonctionTHexaPlot_DisplayMode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=THexaPlot(pu).DisplayMode;
end;

procedure proTHexaPlot_PalName(x:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with THexaPlot(pu) do
  begin
    PalName:=x;
    FlagUpdate:=true;
  end;
end;

function fonctionTHexaPlot_PalName(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=THexaPlot(pu).PalName;
end;

function fonctionTHexaPlot_theta(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=THexaPlot(pu).degP.theta;
  end;

procedure proTHexaPlot_theta(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with THexaPlot(pu) do
    begin
      degP.theta:=x;
      FlagUpdate:=true;
    end;
  end;




function THexaPlot.getPValues(p: integer): float;
begin
   result:= GetValues(Fpoints[p].x,Fpoints[p].y);
end;

end.
