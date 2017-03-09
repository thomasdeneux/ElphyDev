unit stmXYZplot1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,Types,graphics,forms,controls,menus,stdCtrls,
     editcont,math, printers, clipbrd, sysutils,
     util1,Gdos,DdosFich,Dgraphic,
     Dpalette,Ncdef2,formMenu,

     stmDef,stmObj,
     varconf1,stmPlot1,
     debug0,
     listG,dtf0,Dtrace1,
     stmError,stmPg,
     stmPopup,

     stmvec1,
     gl,glu,
     glut,
     cgTypes,cgLight,
     GlGsU1,
     coodXYZ,
     dibG,
     stmGraph2, stmMat1, stmIntTable,
     BMex1, GLprintDlg, tbm0;


type
  TpointL3D= record
               x,y,z:integer;
               color: integer;
             end;
  PpointL3D=^TpointL3D;

  TpointS3D=record
              x,y,z:single;
              color: integer;
             end;
  PpointS3D=^TpointS3D;

  TpolyRec3D=record
               tpNum:typetypeG;
               color:integer;
               mode:byte;
               SymbolSize:double;
               SymbolSize2:double;
               theta,phi:single;
               DottedLine:boolean;
               Version: byte; { 1 à partir du 01-02-2012 }
               UsePointColor: boolean;
             end;

 TXYZInf3D=record
              D0,Fov:single;
              thetaD,phiD:single;
              scaling3D:boolean;
              RefAxis: byte;
              Fortho: boolean;
            end;


  TpolyLine3D=
            class(TlistG)
            private

              procedure setX(i:integer;w:float);
              function getX(i:integer):float;

              procedure setY(i:integer;w:float);
              function getY(i:integer):float;

              procedure setZ(i:integer;w:float);
              function getZ(i:integer):float;

              procedure setCol(i:integer;w:integer);
              function getCol(i:integer):integer;

            public
              rec:TpolyRec3D;
              constructor create(tp:typetypeG);
              procedure addPoint(x,y,z:float;const col:integer=0);
              procedure loadFromVectors(v1,v2,v3,v4:Tvector;i1,i2:integer);
              procedure loadPolyLine(p:Tpolyline3D);

              property Xvalue[i:integer]:float read getX write setX;  {i commence à 0 }
              property Yvalue[i:integer]:float read getY write setY;
              property Zvalue[i:integer]:float read getZ write setZ;
              property PointColor[i:integer]: integer read getCol write setCol;

              procedure writeToStream(f:Tstream);override;
              function readFromStream(f:Tstream):boolean;override;
              function WriteSize:integer;

              property color:integer read rec.color write rec.color;
              property mode:byte read rec.mode write rec.mode;
              property SymbolSize:double read rec.SymbolSize write rec.SymbolSize;
              property SymbolSize2:double read rec.SymbolSize2 write rec.SymbolSize2;
              property theta:single read rec.theta write rec.theta;
              property Phi:single read rec.Phi write rec.Phi;
              property DottedLine:boolean read rec.DottedLine write rec.DottedLine;
            end;

  TXYZplot=
           class(TPlot)
           private
              list0:Tlist;

              decimale:array[1..2] of byte;
              EditLine:integer;

              ModelViewParams,ProjectionParams: T16Darray;
              ViewPortParams:TviewportArray;

              Fcap:boolean;
              xCap,yCap:integer;
              PhiDorg,ThetaDorg:double;

              OnMouseUp:Tpg2Event;

              procedure setEvalue(i,j:integer;x:float);
              function getEvalue(i,j:integer):float;


              procedure DinvalidateCell(i,j:integer);
              procedure DinvalidateVector(i:integer);
              procedure DinvalidateAll;

              function getPolyLineCount:integer;
              procedure setPolyLineCount(n:integer);
              function getPolyLine(i:integer):TpolyLine3D; { i commence à 0 }

              procedure installEditPage;
              procedure EditChangeColor;
              procedure EditDeletePolyline;
              procedure EditInsertPolyline;

              procedure onChangeD(sender:Tobject);
              procedure onChangeCB(sender:Tobject);

              procedure setBM(w,h: integer);
           public
              NextColor:integer;
              inf3D:TXYZinf3D;
              Command3D:Tform;

              Xmin,Xmax,Ymin,Ymax,Zmin,Zmax:double;
              ScaleColor:integer;
              FshowScale,FshowGrid:boolean;
              Cgx,Cgy,Cgz:float;
              fX,fY,fZ,fsymb:float;
              Dmin,Dmax:float;

              PrnWidth,PrnHeight: integer;
              PrnAspect:boolean;

              constructor create;override;
              destructor destroy;override;

              class function STMClassName:AnsiString;override;
              procedure clear;

              property D0:single read inf3D.D0 write inf3D.D0;
              property ThetaD:single read inf3D.thetaD write inf3D.thetaD;
              property PhiD:single read inf3D.PhiD write inf3D.PhiD;
              property Fov:single read inf3D.Fov write inf3D.Fov;
              property Scaling3D:boolean read inf3D.Scaling3D write inf3D.Scaling3D;
              property refAxis:byte read inf3D.refAxis write inf3D.refAxis;
              property Fortho:boolean read inf3D.Fortho write inf3D.Fortho;

              procedure chooseCoo(sender:Tobject);override;
              function ChooseCoo1:boolean;

              procedure display; override;
              procedure displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);override;

              procedure AddPolyLine;
              procedure deletePolyline(index:integer);
              procedure InsertPolyline(index:integer);
              function LastPolyLine:TpolyLine3D;

              property PolylineCount:integer read getPolyLineCount write setPolyLineCount;
              procedure getLimits(var x1,y1,x2,y2,z1,z2:float);

              procedure cadrerX(sender:Tobject);
              procedure cadrerY(sender:Tobject);
              procedure cadrerZ(sender:Tobject);

              procedure autoscaleX;
              procedure autoscaleY;
              procedure autoscaleZ;

              property polyLines[i:integer]:TpolyLine3D read getPolyLine; { i commence à 0 }

              procedure createEditForm;
              procedure EditPlot(sender:Tobject);

              function getPopUp:TpopUpMenu;override;
              procedure invalidate;override;

              procedure saveData( f:Tstream);override;
              function loadData(f:Tstream):boolean;override;
              procedure copyDataFrom(p:typeUO);override;
              procedure createCommand3D;
              procedure Show3Dcommands(sender:Tobject);
              procedure UpdateCommand3D;

              procedure DisplayAxis;
              procedure DisplayGLtext(x,y,z:float;st:AnsiString;xpix,ypix,xa,ya:single);
              procedure setLight(Prepare,Flight:boolean);
              procedure InitD0;

              function MouseDownMG(numOrdre:integer;Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean;override;
              function MouseMoveMG(x,y:integer):boolean;override;
              procedure MouseUpMG(x,y:integer; mg:typeUO);override;

              procedure GetProj(x,y,z:double;var x1,y1,z1:double);
              procedure ProjectToXYplot(xp:TXYplot);
              procedure ProjectToMatrix(mat:Tmatrix);
              procedure ProjectToMatrix1(NumPol:integer;mat:Tmatrix;table:Ttable3);

              procedure PrintSaveCopy(sender: Tobject);
            end;


{ Comme la propriété Polylines de TXYZplot donne directemement un TpolyLine3D
  les méthodes stm ne s'écrivent pas avec VAR pu: typeUO

}
procedure proTpolyLine3D_addPoint(x,y,z:float; pu:pointer);pascal;
procedure proTpolyLine3D_addPoint_1(x,y,z:float; col: integer; pu:pointer);pascal;


procedure proTpolyLine3D_loadFromVectors(var v1,v2,v3:Tvector;i1,i2:integer; pu:pointer);pascal;
procedure proTpolyLine3D_loadFromVectors_1(var v1,v2,v3,v4:Tvector;i1,i2:integer; pu:pointer);pascal;

procedure proTpolyLine3D_loadPolyline(p:TpolyLine3D; pu:pointer);pascal;

function fonctionTpolyLine3D_count( pu:pointer):longint;pascal;

procedure proTpolyLine3D_X(i:longint;w:float; pu:pointer);pascal;
function fonctionTpolyLine3D_X(i:longint; pu:pointer):float;pascal;

procedure proTpolyLine3D_Y(i:longint;w:float; pu:pointer);pascal;
function fonctionTpolyLine3D_Y(i:longint; pu:pointer):float;pascal;

procedure proTpolyLine3D_Z(i:longint;w:float; pu:pointer);pascal;
function fonctionTpolyLine3D_Z(i:longint; pu:pointer):float;pascal;

procedure proTpolyLine3D_PointColor(i:longint;w:integer; pu:pointer);pascal;
function fonctionTpolyLine3D_PointColor(i:longint; pu:pointer):integer;pascal;

procedure proTpolyLine3D_clear( pu:pointer);pascal;

procedure proTpolyLine3D_Color(w:integer; pu:pointer);pascal;
function fonctionTpolyLine3D_Color(pu:pointer):integer;pascal;

procedure proTpolyLine3D_UsePointColor(w:boolean; pu:pointer);pascal;
function fonctionTpolyLine3D_UsePointColor(pu:pointer):boolean;pascal;


procedure proTpolyLine3D_Mode(x:integer;pu:pointer);pascal;
function fonctionTpolyLine3D_Mode(pu:pointer):integer;pascal;

procedure proTpolyLine3D_SymbolSize(x:float;pu:pointer);pascal;
function fonctionTpolyLine3D_SymbolSize(pu:pointer):float;pascal;

procedure proTpolyLine3D_SymbolSize2(x:float;pu:pointer);pascal;
function fonctionTpolyLine3D_SymbolSize2(pu:pointer):float;pascal;

procedure proTpolyLine3D_Theta(x:float;pu:pointer);pascal;
function fonctionTpolyLine3D_Theta(pu:pointer):float;pascal;

procedure proTpolyLine3D_Phi(x:float;pu:pointer);pascal;
function fonctionTpolyLine3D_Phi(pu:pointer):float;pascal;

procedure proTpolyLine3D_DottedLine(x:boolean;pu:pointer);pascal;
function fonctionTpolyLine3D_DottedLine(pu:pointer):boolean;pascal;


procedure proTXYZplot_create(stName:AnsiString;var pu:typeUO);pascal;
procedure proTXYZplot_create_1(var pu:typeUO);pascal;

procedure proTXYZplot_addPolyLine(var pu:typeUO);pascal;
function fonctionTXYZplot_count(var pu:typeUO):longint;pascal;
procedure proTXYZplot_clear(var pu:typeUO);pascal;

function fonctionTXYZplot_polyLines(i:integer;var pu:typeUO):pointer;pascal;
function fonctionTXYZplot_last(var pu:typeUO):pointer;pascal;

procedure proTXYZplot_NextColor(w:integer;var pu:typeUO);pascal;
function fonctionTXYZplot_NextColor(var pu:typeUO):integer;pascal;

procedure proTXYZplot_ScaleColor(w:integer;var pu:typeUO);pascal;
function fonctionTXYZplot_ScaleColor(var pu:typeUO):integer;pascal;

procedure proTXYZplot_AutoscaleX(var pu:typeUO);pascal;
procedure proTXYZplot_AutoscaleY(var pu:typeUO);pascal;
procedure proTXYZplot_AutoscaleZ(var pu:typeUO);pascal;

function fonctionTXYZplot_Xmin(var pu:typeUO):float;pascal;
procedure proTXYZplot_Xmin(x:float;var pu:typeUO);pascal;

function fonctionTXYZplot_Xmax(var pu:typeUO):float;pascal;
procedure proTXYZplot_Xmax(x:float;var pu:typeUO);pascal;

function fonctionTXYZplot_Ymin(var pu:typeUO):float;pascal;
procedure proTXYZplot_Ymin(x:float;var pu:typeUO);pascal;

function fonctionTXYZplot_Ymax(var pu:typeUO):float;pascal;
procedure proTXYZplot_Ymax(x:float;var pu:typeUO);pascal;


function fonctionTXYZplot_Zmin(var pu:typeUO):float;pascal;
procedure proTXYZplot_Zmin(x:float;var pu:typeUO);pascal;

function fonctionTXYZplot_Zmax(var pu:typeUO):float;pascal;
procedure proTXYZplot_Zmax(x:float;var pu:typeUO);pascal;

function fonctionTXYZplot_D0(var pu:typeUO):float;pascal;
procedure proTXYZplot_D0(x:float;var pu:typeUO);pascal;

function fonctionTXYZplot_ThetaD(var pu:typeUO):float;pascal;
procedure proTXYZplot_ThetaD(x:float;var pu:typeUO);pascal;

function fonctionTXYZplot_PhiD(var pu:typeUO):float;pascal;
procedure proTXYZplot_PhiD(x:float;var pu:typeUO);pascal;

function fonctionTXYZplot_FOV(var pu:typeUO):float;pascal;
procedure proTXYZplot_FOV(x:float;var pu:typeUO);pascal;

procedure proTXYZplot_InitD0(var pu:typeUO);pascal;

function fonctionTXYZplot_ShowScale(var pu:typeUO):boolean;pascal;
procedure proTXYZplot_ShowScale(x:boolean;var pu:typeUO);pascal;

function fonctionTXYZplot_ShowGrid(var pu:typeUO):boolean;pascal;
procedure proTXYZplot_ShowGrid(x:boolean;var pu:typeUO);pascal;

function fonctionTXYZplot_Scaling3D(var pu:typeUO):boolean;pascal;
procedure proTXYZplot_Scaling3D(x:boolean;var pu:typeUO);pascal;

function fonctionTXYZplot_RefAxis(var pu:typeUO):integer;pascal;
procedure proTXYZplot_RefAxis(x:integer;var pu:typeUO);pascal;

function fonctionTXYZplot_Ortho(var pu:typeUO):boolean;pascal;
procedure proTXYZplot_Ortho(x:boolean;var pu:typeUO);pascal;


procedure proTXYZplot_GetProjection(x,y,z:float;var x1,y1,z1:float;var pu:typeUO);pascal;
procedure proTXYZplot_ProjectToMatrix(var mat:Tmatrix;var pu:typeUO);pascal;
procedure proTXYZplot_ProjectToMatrix1(NumPol:integer;var mat:Tmatrix;var table:Ttable3;var pu:typeUO);pascal;
procedure proTXYZplot_ProjectToXYplot(var xp:TxyPlot;var pu:typeUO);pascal;

procedure proTXYZplot_OnMouseUp(p:integer;var pu:typeUO);pascal;
function fonctionTXYZplot_onMouseUp(var pu:typeUO):integer;pascal;

implementation

uses XYZ3Dform;
{*************************** Méthodes de TpolyLine3D ***************************}


constructor TpolyLine3D.create(tp:typetypeG);
begin
  rec.tpNum:=tp;
  rec.color:=DefPenColor;
  rec.Version:=1;
  inherited create(sizeof(TpointL3D));
end;

procedure TpolyLine3D.addPoint(x,y,z:float; const col:integer=0);
var
  pL:TpointL3D;
  pS:TpointS3D;
begin
  case rec.tpNum of
    g_longint: begin
                 pL.x:=roundL(x);
                 pL.y:=roundL(y);
                 pL.z:=roundL(z);
                 pL.color:=col;

                 add(@pL);
               end;
    g_single:  begin
                 pS.x:=x;
                 pS.y:=y;
                 pS.z:=z;
                 pS.color:=col;
                 add(@pS);
               end;
  end;
end;

procedure TpolyLine3D.loadFromVectors(v1, v2, v3,v4: Tvector; i1, i2: integer);
var
  i:integer;
begin
  if assigned(v1) and assigned(v2) and assigned(v3) and
     (i1>=v1.Istart) and (i2<=v1.Iend) and
     (i1>=v2.Istart) and (i2<=v2.Iend) and
     (i1>=v3.Istart) and (i2<=v3.Iend) then
  begin
    if not assigned(v4) then
    begin
      for i:=i1 to i2 do addPoint(v1.Yvalue[i],v2.Yvalue[i],v3.Yvalue[i]);
    end
    else
    begin
      if (i1>=v4.Istart) and (i2<=v4.Iend) then
        for i:=i1 to i2 do addPoint(v1.Yvalue[i],v2.Yvalue[i],v3.Yvalue[i], v4.Jvalue[i]);
    end;
  end
end;

procedure TpolyLine3D.loadPolyLine(p: TpolyLine3D);
var
  i:integer;
begin
  if assigned(p) then
  for i:=0 to p.count-1 do
    addPoint(p.Xvalue[i],p.Yvalue[i],p.Zvalue[i],p.PointColor[i]);
end;


procedure TpolyLine3D.setX(i:integer;w:float);
begin
  case rec.tpNum of
    g_longint: PpointL3D(items[i]).x:=roundL(w);
    g_single:  PpointS3D(items[i]).x:=w;
  end;
end;

function TpolyLine3D.getX(i:integer):float;
begin
  case rec.tpNum of
    g_longint: result:=PpointL3D(items[i]).x;
    g_single:  result:=PpointS3D(items[i]).x;
  end;
end;

procedure TpolyLine3D.setY(i:integer;w:float);
begin
  case rec.tpNum of
    g_longint: PpointL3D(items[i]).y:=roundL(w);
    g_single:  PpointS3D(items[i]).y:=w;
  end;
end;

function TpolyLine3D.getY(i:integer):float;
begin
  case rec.tpNum of
    g_longint: result:=PpointL3D(items[i]).y;
    g_single:  result:=PpointS3D(items[i]).y;
  end;
end;

procedure TpolyLine3D.setZ(i:integer;w:float);
begin
  case rec.tpNum of
    g_longint: PpointL3D(items[i]).z:=roundL(w);
    g_single:  PpointS3D(items[i]).z:=w;
  end;
end;

function TpolyLine3D.getZ(i:integer):float;
begin
  case rec.tpNum of
    g_longint: result:=PpointL3D(items[i]).z;
    g_single:  result:=PpointS3D(items[i]).z;
  end;
end;

procedure TpolyLine3D.setCol(i:integer;w:integer);
begin
  PpointL3D(items[i]).color:=w;
end;

function TpolyLine3D.getCol(i:integer):integer;
begin
  result:=PpointL3D(items[i]).color;
end;


procedure TpolyLine3D.writeToStream(f:Tstream);
var
  w,res:integer;
begin
  w:=sizeof(Rec);
  f.writeBuffer(w,sizeof(w));        {Ecrire RecSize }
  rec.Version:=1;
  f.WriteBuffer(rec,sizeof(rec));    {Ecrire Rec }

  inherited writeToStream(f);                    {Puis le contenu de la liste}
end;

function TpolyLine3D.readFromStream(f:Tstream):boolean;
type
  TOldpoint= record
               x,y,z: integer;
             end;
var
  w,res,i:integer;
  old: ToldPoint;
  oldList: TlistG;
begin
  result:=false;
  res:=f.Read(w,sizeof(w));   {Lire RecSize}
  if (res<>sizeof(w)) or (w>sizeof(rec)) then exit;

  fillchar(rec,sizeof(rec),0);
  res:=f.Read(rec,w);

  result:= (res=w);
  if not result then exit;

  if rec.Version=0 then result:= inherited ReadFromStream(f)
  else
  begin           { Version 1 avec Point color }
    try
    oldList:=TlistG.create(sizeof(ToldPoint));
    result:= oldList.readFromStream(f);
    if result then
    begin
      Count:=oldList.Count;
      for i:=0 to count-1 do
        system.move(oldList[i]^,items[i]^,sizeof(ToldPoint));
      { On copie x,y,z. Color contiendra zéro }
    end;
    finally
    oldList.free;
    end;
  end;
end;

function TpolyLine3D.writeSize:integer;
begin
  result:=4+sizeof(rec)+inherited writeSize;
end;



{*************************** Méthodes de TXYZplot ***************************}

constructor TXYZplot.create;
begin
  inherited;
  list0:=Tlist.create;

  with inf3D do
  begin
    D0:=100;
    Fov:=50;
    thetaD:=0;
    phiD:=45;
  end;

  Scaling3D:=true;
  FshowGrid:=true;
  FshowScale:=true;
  refAxis:=1;

  Xmin:=0;
  Xmax:=100;
  Ymin:=0;
  Ymax:=100;
  Zmin:=0;
  Zmax:=100;
end;

destructor TXYZplot.destroy;
begin
  clear;
  list0.free;
  command3D.Free;
  inherited destroy;
end;

procedure TXYZplot.clear;
var
  i:integer;
begin
  with list0 do
  for i:= 0 to count-1 do TpolyLine3D(items[i]).free;
  list0.clear;
end;

class function TXYZplot.STMClassName:AnsiString;
begin
  STMClassName:='XYZplot';
end;


procedure GglColor( color:integer);
begin
  {
  glBlendFunc(GL_SRC_COLOR, GL_DST_COLOR);
  glEnable( GL_BLEND );
  glEnable( GL_ALPHA_TEST );
  }
  glColor3f(byte(color)/255,byte(color shr 8)/255,byte(color shr 16)/255);
end;


procedure TXYZplot.DisplayGLtext(x,y,z:float;st:AnsiString;xpix,ypix,xa,ya:single);
var
  i,j,k:integer;
  dib:Tdib;
  tab:packed array of byte;
  bb:byte;
  TextSize:TagSize;

  L,H,Lmem:integer;

begin
  x:=x*Fx;
  y:=y*Fy;
  z:=z*Fz;

  dib:=Tdib.create;
  with dib do
  begin
    //initrgbDib(256,32);
    setSize(256,32,1);
    fill(0);
    canvas.Font.Name:='Arial';
    canvas.font.Style:= [];
    canvas.font.color:=clWhite;
    canvas.brush.color:=clBlack;
    canvas.TextOut(0,0,st);
    H:=canvas.TextHeight(st);
    L:=canvas.TextWidth(st);
  end;

  Lmem:=(L div 32+1)*32;

  setLength(tab,Lmem*H div 8);
  for i:=0 to Lmem div 8-1 do
  for j:=0 to H-1 do
  begin
    bb:=0;
    for k:=0 to 7 do
      bb:=bb or ord(dib.Pixels[i*8+k,j]<>0)*$80 shr k;
    tab[(H-1-j)*(Lmem div 8)+i]:=bb;
  end;
  dib.free;



  glRasterPos3f(x,y,z);
  glBitmap(Lmem,H,xpix+xa*L,ypix+ya*H,0,0,@tab[0]);

end;

Const
  mat_ambient:array[1..4] of single = ( 0.2, 0.2, 0.2, 1.0 );

  mat_diffuse:array[1..4] of single = ( 0.8, 0.8, 0.8, 1.0 );
  mat_specular:array[1..4] of single = ( 1.0, 1.0, 1.0, 1.0 );
  mat_shininess:array[1..1] of single = ( 50.0 );

  light_ambient:array[1..4] of single = ( 0.0, 0.0, 0.0, 1.0 );

  light_diffuse:array[1..4] of single = ( 1.0, 1.0, 1.0, 1.0 );
  light_specular:array[1..4] of single = ( 1.0, 1.0, 1.0, 1.0 );

  light_position:array[1..4] of single = ( 1.0, 1.0, 1.0, 0.0 );

  lmodel_ambient:array[1..4] of single = ( 0.2, 0.2, 0.2, 1.0 );

procedure TXYZplot.setLight(Prepare,Flight:boolean);
begin
  if Prepare then
  begin
    glMaterialfv(GL_FRONT, GL_AMBIENT, @mat_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, @mat_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, @mat_specular);
    glMaterialfv(GL_FRONT, GL_SHININESS, @mat_shininess);

    glLightfv(GL_LIGHT0, GL_AMBIENT, @light_ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, @light_diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, @light_specular);
    glLightfv(GL_LIGHT0, GL_POSITION, @light_position);

    glLightModelfv(GL_LIGHT_MODEL_AMBIENT, @lmodel_ambient);
  end;

  if Flight then
  begin
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);

    glDepthFunc(GL_LESS);
    glEnable(GL_DEPTH_TEST);
    // Enable color tracking
    glEnable(GL_COLOR_MATERIAL);
  end
  else
  begin
    glDisable(GL_LIGHTING);
    glDisable(GL_LIGHT0);
  end;



end;

procedure TXYZplot.display;
const
  spec: array [0..3] of GLfloat = (0.5, 0.5, 0.5, 0.5);
  spec1: array [0..3] of GLfloat = (1, 1, 1, 1);

var
  i,j:integer;
  asp:float;
  Kf,a,b:float;
  L: TCGLight;
  xC,yc:float;
  IendEff,JendEff:integer;
  Flight:boolean;

begin
  if BmExGlb=nil then exit;

  cgx:=(Xmin+Xmax)/2;
  cgy:=(Ymin+Ymax)/2;
  cgz:=(Zmin+Zmax)/2;

  if not Scaling3D or (abs(Xmax-Xmin)<1E-100) or(abs(Ymax-Ymin)<1E-100) or(abs(Zmax-Zmin)<1E-100) then
  begin
    Fx:=1;
    Fy:=1;
    Fz:=1;
  end
  else
  if (abs(Xmax-Xmin)>=abs(Ymax-Ymin)) and (abs(Xmax-Xmin)>=abs(Zmax-Zmin)) then
  begin
    Fx:=1;
    Fy:=abs(Xmax-Xmin)/abs(Ymax-Ymin);
    Fz:=abs(Xmax-Xmin)/abs(Zmax-Zmin);
  end
  else
  if (abs(Ymax-Ymin)>=abs(Xmax-Xmin)) and (abs(Ymax-Ymin)>=abs(Zmax-Zmin)) then
  begin
    Fy:=1;
    Fx:=abs(Ymax-Ymin)/abs(Xmax-Xmin);
    Fz:=abs(Ymax-Ymin)/abs(Zmax-Zmin);
  end
  else
  begin
    Fz:=1;
    Fx:=abs(Zmax-Zmin)/abs(Xmax-Xmin);
    Fy:=abs(Zmax-Zmin)/abs(Ymax-Ymin);
  end;

  if scaling3D then
  case RefAxis of
    2:   Fsymb:= Fy;
    3:   Fsymb:= Fz;
    else Fsymb:= Fx;
  end
  else Fsymb:=1;

  selectClipRgn(BMexGlb.canvas.handle,0);

  if not BmExGlb.initGLpaint then exit;

  glViewPort(x1act,BmExGlb.height-y2act,x2act-x1act,y2act-y1act);
  asp:=(x2act-x1act)/(y2act-y1act);



  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;

  Dmin:=D0/30;
  Dmax:=D0*30;

  if Fortho
    then glOrtho(-D0/2,D0/2,-D0/2/asp,D0/2/asp,Dmin,Dmax)
    else gluPerspective(inf3D.fov,asp,Dmin,Dmax);

  glMatrixMode(GL_MODELVIEW);
  glClearColor(1,0,0,0);
  glClear({GL_COLOR_BUFFER_BIT or} GL_DEPTH_BUFFER_BIT);
  glColor3f(0,0,1);

  glLoadIdentity;
  setLight(true,false );



  glLoadIdentity;
  with inf3D do
  gluLookAt(D0*sin(PhiD*pi/180)*cos(ThetaD*pi/180)+Cgx*Fx,D0*sin(PhiD*pi/180)*sin(ThetaD*pi/180)+Cgy*Fy ,D0*cos(PhiD*pi/180)+Cgz*Fz,
            Cgx*Fx,Cgy*Fy,Cgz*Fz,
            -cos(PhiD*pi/180)*cos(ThetaD*pi/180),-cos(PhiD*pi/180)*sin(ThetaD*pi/180),sin(PhiD*pi/180));


  glGetDoublev(GL_MODELVIEW_MATRIX,@ModelViewParams);
  glGetDoublev(GL_PROJECTION_MATRIX,@ProjectionParams);
  glGetIntegerv(GL_VIEWPORT,@ViewPortParams);


  GGlColor(ScaleColor);
  DisplayAxis;

  for i:=0 to polylineCount-1 do
  with polylines[i] do
  begin
    setLight(false,mode in [2,4,6] );
    case mode of
      0:begin
          GglColor(color);
          glBegin(GL_POINTS);
          for j:=0 to count-1 do
          begin
            if rec.UsePointColor then GglColor(PointColor[j]);
            glVertex3f(Xvalue[j]*Fx,Yvalue[j]*Fy,Zvalue[j]*Fz);
          end;
          glEnd;
        end;

      1:begin
          GglColor(color);
          if SymbolSize<>0 then glLineWidth(SymbolSize);
          if DottedLine then
          begin
            glEnable (GL_LINE_STIPPLE);
            glLineStipple (1, $0707);
          end;
          glBegin(GL_LINE_STRIP);
          for j:=0 to count-1 do
          begin
            if rec.UsePointColor then GglColor(PointColor[j]);
            glVertex3f(Xvalue[j]*Fx,Yvalue[j]*Fy,Zvalue[j]*Fz);
          end;
          glEnd;
        end;

      2..7:
         begin
          GglColor(color);
          for j:=0 to count-1 do
          begin
            glPushMatrix;
            glTranslatef(Xvalue[j]*Fx,Yvalue[j]*Fy,Zvalue[j]*Fz);
            if mode in [4..7] then
            begin
              glrotatef(theta,0,0,1);
              glrotatef(phi,0,1,0);
            end;
            if rec.UsePointColor then GglColor(PointColor[j]);
            {$IFNDEF WIN64}
            case mode of
              2:glutSolidSphere(SymbolSize*Fsymb,10,8);
              3:glutWireSphere(SymbolSize*Fsymb,10,8);
              4:glutSolidCube(SymbolSize*Fsymb);
              5:glutWireCube(SymbolSize*Fsymb);
              6:glutSolidCone(SymbolSize*Fsymb,SymbolSize2*Fsymb,10,8);
              7:glutWireCone(SymbolSize*Fsymb,SymbolSize2*Fsymb,10,8);
            end;
            {$ENDIF}
            glPopMatrix;
          end;
        end;
    end;
  end;
  BmExGlb.doneGLpaint;
end;




procedure TickNormEx(x1,x2:float;var nbTick:integer;var tabTick:typeTabTick);
var
  i:integer;
  delta:float;
begin
  TickNorm(x1,x2,nbTick,tabTick,1);
  move(tabTick[1],tabTick[2],nbTick*sizeof(tabTick[1]));
  tabTick[1].w:=x1;
  tabTick[nbTick+2].w:=x2;
  nbTick:=nbTick+2;

  delta:=tabTick[3].w-tabTick[2].w;
  for i:=1 to nbTick do
    tabTick[i].aff:=(tabTick[i].w-X1>delta*0.8) and (X2-tabTick[i].w>delta*0.8);
end;

procedure TXYZplot.DisplayAxis;
var
   NbTickX,NbTickY,NbTickZ:integer;
   tabTickX,tabTickY,tabTickZ:typeTabTick;

   i,j,k:integer;
   quad:integer;
   Up:boolean;
   FXmin, FXmax, FYmin, FYmax, FZmin, FZmax: boolean;
   ZZ,ZZb:float;
   LeftXpix,LeftYpix,LeftXa,LeftYa:float;
   RightXpix,RightYpix,RightXa,RightYa:float;
   ThetaR,ThetaDum:float;

procedure Vertex(x,y,z:float);
begin
  glVertex3f(x*Fx,y*Fy,z*Fz);
end;

begin
  if not FshowGrid then exit;

  TickNormEx(Xmin,Xmax, NbTickX,tabTickX);
  TickNormEx(Ymin,Ymax, NbTickY,tabTickY);
  TickNormEx(Zmin,Zmax, NbTickZ,tabTickZ);

  quad:=trunc((inf3D.thetaD+3600)/90) mod 4;
  Up:=(inf3D.phiD<90);

  FXmin:=false;
  FXmax:=false;
  FYmin:=false;
  FYmax:=false;
  FZmin:=false;
  FZmax:=false;

  if Up then FZmin:=true else FZmax:=true;
  case quad of
    0:begin
        FXmin:=true;
        FYmin:=true;
      end;
    1:begin
        FXmax:=true;
        FYmin:=true;
      end;
    2:begin
        FXmax:=true;
        FYmax:=true;
      end;
    3:begin
        FXmin:=true;
        FYmax:=true;
      end;
  end;

  if FZmin then
  begin
    for i:=1 to NbTickX do
    begin
      glBegin(GL_LINE_STRIP);
      Vertex(tabTickX[i].w,Ymin,Zmin);
      Vertex(tabTickX[i].w,Ymax,Zmin);
      glEnd;
    end;
    for i:=1 to NbTickY do
    begin
      glBegin(GL_LINE_STRIP);
      Vertex(Xmin,tabTickY[i].w,Zmin);
      Vertex(Xmax,tabTickY[i].w,Zmin);
      glEnd;
    end;
  end;

  if FZmax then
  begin
    for i:=1 to NbTickX do
    begin
      glBegin(GL_LINE_STRIP);
      Vertex(tabTickX[i].w,Ymin,Zmax);
      Vertex(tabTickX[i].w,Ymax,Zmax);
      glEnd;
    end;
    for i:=1 to NbTickY do
    begin
      glBegin(GL_LINE_STRIP);
      Vertex(Xmin,tabTickY[i].w,Zmax);
      Vertex(Xmax,tabTickY[i].w,Zmax);
      glEnd;
    end;
  end;

  if FXmin then
  begin
    for i:=1 to NbTickY do
    begin
      glBegin(GL_LINE_STRIP);
      Vertex(Xmin,tabTickY[i].w,Zmin);
      Vertex(Xmin,tabTickY[i].w,Zmax);
      glEnd;
    end;
    for i:=1 to NbTickZ do
    begin
      glBegin(GL_LINE_STRIP);
      Vertex(Xmin,Ymin,tabTickZ[i].w);
      Vertex(Xmin,Ymax,tabTickZ[i].w);
      glEnd;
    end;
  end;

  if FXmax then
  begin
    for i:=1 to NbTickY do
    begin
      glBegin(GL_LINE_STRIP);
      Vertex(Xmax,tabTickY[i].w,Zmin);
      Vertex(Xmax,tabTickY[i].w,Zmax);
      glEnd;
    end;
    for i:=1 to nbTickZ do
    begin
      glBegin(GL_LINE_STRIP);
      Vertex(Xmax,Ymin,tabTickZ[i].w);
      Vertex(Xmax,Ymax,tabTickZ[i].w);
      glEnd;
    end;
  end;

  if FYmin then
  begin
    for i:=1 to NbTickX do
    begin
      glBegin(GL_LINE_STRIP);
      Vertex(tabTickX[i].w,Ymin,Zmin);
      Vertex(tabTickX[i].w,Ymin,Zmax);
      glEnd;
    end;
    for i:=1 to NbTickZ do
    begin
      glBegin(GL_LINE_STRIP);
      Vertex(Xmin,Ymin,tabTickZ[i].w);
      Vertex(Xmax,Ymin,tabTickZ[i].w);
      glEnd;
    end;
  end;

  if FYmax then
  begin
    for i:=1 to NbTickX do
    begin
      glBegin(GL_LINE_STRIP);
      Vertex(tabTickX[i].w,Ymax,Zmin);
      Vertex(tabTickX[i].w,Ymax,Zmax);
      glEnd;
    end;

    for i:=1 to NbTickZ do
    begin
      glBegin(GL_LINE_STRIP);
      Vertex(Xmin,Ymax,tabTickZ[i].w);
      Vertex(Xmax,Ymax,tabTickZ[i].w);
      glEnd;
    end;
  end;

  if not FshowScale then exit;
  thetaR:=(thetaD-floor(thetaD/90)*90)*pi/180;
  if thetaR>pi/4 then thetaDum:=pi/4 else thetaDum:=thetaR;

  if Up then
  begin
    ZZ:=Zmin;
    ZZb:=Zmax;
    LeftXa:=0.5+0.5*thetaDum/(pi/4);
    LeftYa:=1;
    LeftXpix:=10*thetaR/(pi/2);
    LeftYpix:=10*(1-thetaR/(pi/2));

    if thetaR<pi/4
      then RightXa:=0
      else RightXa:=0.5*(thetaR-pi/4)/(pi/4);
    RightYa:= 1;
    RightXpix:=-10*(1-thetaR/(pi/2));
    RightYpix:=10*thetaR/(pi/2);
  end
  else
  begin
    ZZ:=Zmax;
    ZZb:=Zmin;
    LeftXa:=0.5+0.5*thetaDum/(pi/4);
    LeftYa:=0;
    LeftXpix:=10*thetaR/(pi/2);
    LeftYpix:=-10*(1-thetaR/(pi/2));

    RightXa:= 0.5*thetaDum/(pi/4);
    RightYa:= 0;
    RightXpix:=-10*(1-thetaR/(pi/2));
    RightYpix:=-10*thetaR/(pi/2);
  end;

  case Quad of
    0:begin
        for i:=2 to NbTickY-1 do
          if tabTickY[i].aff then DisplayGLtext(Xmax,tabTickY[i].w,ZZ,Estr(tabTickY[i].w,3),LeftXpix,LeftYpix,LeftXa,LeftYa);
        for i:=2 to NbTickX-1 do
          if tabTickX[i].aff then DisplayGLtext(tabTickX[i].w,Ymax,ZZ, Estr(tabTickX[i].w,3),RightXpix,RightYpix,RightXa,RightYa);
        for i:=2 to NbTickZ-1 do
          if tabTickZ[i].aff then DisplayGLtext(Xmax,Ymin,tabTickZ[i].w, Estr(tabTickZ[i].w,3),10,0,1,0.5);

        DisplayGLtext(Xmax+(Xmax-Xmin)*0.05,Ymin,ZZ,'X',0,0,0.5,0.5);
        DisplayGLtext(Xmin,Ymax+(Ymax-Ymin)*0.05,ZZ,'Y',0,0,0.5,0.5);
        DisplayGLtext(Xmin,Ymin,ZZb+(ZZb-ZZ)*0.05,'Z',0,0,0.5,0.5);
      end;

    1:begin
        for i:=2 to NbTickX-1 do
          if tabTickX[i].aff then DisplayGLtext(tabTickX[i].w,Ymax,ZZ,Estr(tabTickX[i].w,3),LeftXpix,LeftYpix,LeftXa,LeftYa);
        for i:=2 to NbTickY-1 do
          if tabTickY[i].aff then DisplayGLtext(Xmin,tabTickY[i].w,ZZ, Estr(tabTickY[i].w,3),RightXpix,RightYpix,RightXa,RightYa);
        for i:=2 to NbTickZ-1 do
          if tabTickZ[i].aff then DisplayGLtext(Xmax,Ymax,tabTickZ[i].w, Estr(tabTickZ[i].w,3),10,0,1,0.5);

        DisplayGLtext(Xmin-(Xmax-Xmin)*0.05,Ymin,ZZ,'X',0,0,0.5,0.5);
        DisplayGLtext(Xmax,Ymax+(Ymax-Ymin)*0.05,ZZ,'Y',0,0,0.5,0.5);
        DisplayGLtext(Xmax,Ymin,ZZb+(ZZb-ZZ)*0.05,'Z',0,0,0.5,0.5);
      end;

    2:begin
        for i:=2 to NbTickY-1 do
          if tabTickY[i].aff then DisplayGLtext(Xmin,tabTickY[i].w,ZZ,Estr(tabTickY[i].w,3),LeftXpix,LeftYpix,LeftXa,LeftYa);
        for i:=2 to NbTickX-1 do
          if tabTickX[i].aff then DisplayGLtext(tabTickX[i].w,Ymin,ZZ, Estr(tabTickX[i].w,3),RightXpix,RightYpix,RightXa,RightYa);
        for i:=2 to NbTickZ-1 do
          if tabTickZ[i].aff then DisplayGLtext(Xmin,Ymax,tabTickZ[i].w, Estr(tabTickZ[i].w,3),10,0,1,0.5);

        DisplayGLtext(Xmin-(Xmax-Xmin)*0.05,Ymax,ZZ,'X',0,0,0.5,0.5);
        DisplayGLtext(Xmax,Ymin-(Ymax-Ymin)*0.05,ZZ,'Y',0,0,0.5,0.5);
        DisplayGLtext(Xmax,Ymax,ZZb+(ZZb-ZZ)*0.05,'Z',0,0,0.5,0.5);
      end;
    3:begin
        for i:=2 to NbTickX-1 do
          if tabTickX[i].aff then DisplayGLtext(tabTickX[i].w,Ymin,ZZ,Estr(tabTickX[i].w,3),LeftXpix,LeftYpix,LeftXa,LeftYa);
        for i:=2 to NbTickY-1 do
          if tabTickY[i].aff then DisplayGLtext(Xmax,tabTickY[i].w,ZZ, Estr(tabTickY[i].w,3),RightXpix,RightYpix,RightXa,RightYa);
        for i:=2 to NbTickZ-1 do
          if tabTickZ[i].aff then DisplayGLtext(Xmin,Ymin,tabTickZ[i].w, Estr(tabTickZ[i].w,3),10,0,1,0.5);

        DisplayGLtext(Xmax+(Xmax-Xmin)*0.05,Ymax,ZZ,'X',0,0,0.5,0.5);
        DisplayGLtext(Xmin,Ymin-(Ymax-Ymin)*0.05,ZZ,'Y',0,0,0.5,0.5);
        DisplayGLtext(Xmin,Ymax,ZZb+(ZZb-ZZ)*0.05,'Z',0,0,0.5,0.5);
      end;
  end;

end;

procedure TXYZplot.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);
begin
end;

function TXYZplot.ChooseCoo1:boolean;
begin
  result:=cooXYZ.choose(self);
end;

procedure TXYZplot.chooseCoo(sender:Tobject);
begin
  if chooseCoo1 then invalidate;
end;

function TXYZplot.getPolyLineCount:integer;
begin
  result:=list0.count;
end;

procedure TXYZplot.setPolyLineCount(n:integer);
begin
  list0.count:=n;
end;

procedure TXYZplot.addPolyLine;
var
  poly:TpolyLine3D;
begin
  poly:=TpolyLine3D.create(g_single);
  poly.rec.color:=Nextcolor;

  list0.add(poly);
end;

procedure TXYZplot.deletePolyLine(index:integer);
begin
  TpolyLine3D(list0[index]).free;
  list0.delete(index);
end;

procedure TXYZplot.insertPolyLine(index:integer);
var
  poly:TpolyLine3D;
begin
  poly:=TpolyLine3D.create(g_single);
  poly.rec.color:=Nextcolor;
  list0.insert(index,poly);
end;

function TXYZplot.LastPolyLine:TpolyLine3D;
begin
  result:=TpolyLine3D(list0.Last);
end;

procedure TXYZplot.getLimits(var x1,y1,x2,y2,z1,z2:float);
var
  i,j:integer;
  x,y,z:float;
begin
  x1:=1E1000;
  x2:=-1E1000;
  y1:=1E1000;
  y2:=-1E1000;
  z1:=1E1000;
  z2:=-1E1000;

  for i:= 0 to polyLineCount-1 do
    with TpolyLine3D(list0.items[i]) do
    for j:=0 to count-1 do
      begin
        x:=getX(j);
        y:=getY(j);
        z:=getZ(j);
        if x<x1 then x1:=x;
        if x>x2 then x2:=x;
        if y<y1 then y1:=y;
        if y>y2 then y2:=y;
        if z<z1 then z1:=z;
        if z>z2 then z2:=z;
      end;

  if x1=1E1000 then
    begin
      x1:=0;
      x2:=0;
    end;

  if y1=1E1000 then
    begin
      y1:=0;
      y2:=0;
    end;

  if z1=1E1000 then
    begin
      z1:=0;
      z2:=0;
    end;

end;

procedure TXYZplot.cadrerX(sender:Tobject);
var
  x1,x2,y1,y2,z1,z2:float;
begin
  getLimits(x1,y1,x2,y2,z1,z2);
  Xmin:=x1;
  Xmax:=x2;
end;

procedure TXYZplot.cadrerY(sender:Tobject);
var
  x1,x2,y1,y2,z1,z2:float;
begin
  getLimits(x1,y1,x2,y2,z1,z2);
  Ymin:=y1;
  Ymax:=y2;
end;

procedure TXYZplot.cadrerZ(sender:Tobject);
var
  x1,x2,y1,y2,z1,z2:float;
begin
  getLimits(x1,y1,x2,y2,z1,z2);
  Zmin:=z1;
  Zmax:=z2;
end;

procedure TXYZplot.autoscaleX;
var
  x1,x2,y1,y2,z1,z2:float;
begin
  getLimits(x1,y1,x2,y2,z1,z2);
  Xmin:=x1;
  Xmax:=x2;
end;

procedure TXYZplot.autoscaleY;
var
  x1,x2,y1,y2,z1,z2:float;
begin
  getLimits(x1,y1,x2,y2,z1,z2);
  Ymin:=y1;
  Ymax:=y2;
end;

procedure TXYZplot.autoscaleZ;
var
  x1,x2,y1,y2,z1,z2:float;
begin
  getLimits(x1,y1,x2,y2,z1,z2);
  Zmin:=z1;
  Zmax:=z2;
end;

function TXYZplot.getPolyLine(i:integer):TpolyLine3D;
begin
  result:=TpolyLine3D(list0.items[i]);
end;

procedure TXYZplot.setEvalue(i,j:integer;x:float);
begin
end;

function TXYZplot.getEvalue(i,j:integer):float;
begin
end;

procedure TXYZplot.DinvalidateCell(i,j:integer);
begin
  invalidate;
end;

procedure TXYZplot.DinvalidateVector(i:integer);
begin
  invalidate;
end;

procedure TXYZplot.DinvalidateAll;
begin
  invalidate;
end;

procedure TXYZplot.onChangeD(sender:Tobject);
begin
  invalidate;
end;

procedure TXYZplot.onChangeCB(sender:Tobject);
begin
  invalidate;
end;


procedure TXYZplot.installEditPage;
begin
end;

procedure TXYZplot.EditChangeColor;
begin
end;

procedure TXYZplot.EditDeletePolyline;
begin
end;

procedure TXYZplot.EditInsertPolyline;
begin
end;


procedure TXYZplot.createEditForm;
begin
end;

procedure TXYZplot.EditPlot(sender:Tobject);
begin
end;

function TXYZplot.getPopUp:TpopupMenu;
begin
  with PopUps do
  begin
    PopupItem(pop_TXYZPlot,'TXYZplot_Coordinates').onClick:=ChooseCoo;
    PopupItem(pop_TXYZPlot,'TXYZplot_ShowPlot').onClick:=self.Show;
    PopupItem(pop_TXYZPlot,'TXYZplot_Show3Dcommands').onClick:=self.Show3Dcommands;

    PopupItem(pop_TXYZPlot,'TXYZplot_Properties').onClick:=Proprietes;
//    PopupItem(pop_TXYZPlot,'TXYZplot_Edit').onClick:=EditPlot;

    PopupItem(pop_TXYZPlot,'TXYZplot_SaveObject').onClick:=SaveObjectToFile;
    PopupItem(pop_TXYZPlot,'TXYZplot_Clone').onClick:=CreateClone;

    PopupItem(pop_TXYZPlot,'TXYZplot_PrintSaveCopy').onClick:=PrintSaveCopy;

    result:= pop_TXYZplot;
  end;
  
end;

procedure TXYZplot.invalidate;
begin
  inherited;
end;

procedure TXYZplot.saveData(f:Tstream);
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

function TXYZplot.loadData(f:Tstream):boolean;
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

end;

procedure TXYZplot.copyDataFrom(p:typeUO);
var
  i:integer;
begin
  if not (p is TXYZplot) then exit;

  clear;

  for i:=0 to TXYZplot(p).PolylineCount-1 do
  begin
    addPolyLine;
    polyLines[i].Count:=TXYZplot(p).polyLines[i].count;
    polyLines[i].rec:=TXYZplot(p).polyLines[i].rec;
    move(TXYZplot(p).polyLines[i].getPointer^,polyLines[i].getPointer^,8*polyLines[i].count);
  end;
end;


procedure TXYZplot.Show3Dcommands(sender: Tobject);
begin
  if not assigned(Command3D) then createCommand3D;
  if assigned(Command3D) then
    begin
      Command3D.show;
    end;
end;

procedure TXYZplot.createCommand3D;
begin
  command3D:=TXYZplot3Dcom.create(formstm);
  with TXYZplot3Dcom(command3D) do
  begin
    caption:=ident+': 3D commands';
    init(self);
  end;
end;

procedure TXYZplot.UpdateCommand3D;
begin
  if assigned(command3D) then
    TXYZplot3Dcom(command3D).init(self);
end;


procedure TXYZplot.InitD0;
begin
  D0:=abs(Xmax-Xmin)*2;
  if abs(Ymax-Ymin)*2>D0 then D0:= abs(Ymax-Ymin)*2;
  if abs(Zmax-Zmin)*2>D0 then D0:= abs(Zmax-Zmin)*2;
  Updatecommand3D;
end;




function TXYZplot.MouseDownMG(numOrdre: integer; Irect: Trect; Shift: TShiftState; Xc, Yc, X, Y: Integer): boolean;
begin
  if numOrdre<>0 then exit;

  Fcap:=true;
  xcap:=x1act+x;
  ycap:=y1act+y;
  PhiDorg:=PhiD;
  ThetaDorg:=ThetaD;
  result:=true;
end;

function TXYZplot.MouseMoveMG(x, y: integer): boolean;
begin
  if Fcap then
  begin
    x:=xCap-x;
    y:=yCap-y;

    PhiD:=PhiDorg+ 90*y/(y2act-y1act);
//   while PhiD<0 do PhiD:=PhiD+180;
//   while PhiD>180 do PhiD:=PhiD-180;

    ThetaD:=ThetaDorg+180*x/(x2act-x1act);
    invalidate;
    Updatecommand3D;
    result:=true;
  end
  else result:=false;
end;

procedure TXYZplot.MouseUpMG(x, y: integer; mg: typeUO);
begin
  Fcap:=false;
  if onMouseUp.valid then
    onMouseUp.pg.executerPopupClick(onMouseUp.ad,TypeUO(self));
end;

procedure TXYZplot.GetProj(x, y, z: double; var x1, y1, z1: double);
begin
  gluProject(x,y,z,ModelViewParams,ProjectionParams,ViewPortParams,@x1,@y1,@z1);
  x1:=x1/ViewPortParams[2]*100;
  y1:=y1/ViewPortParams[2]*100;
end;

procedure TXYZplot.ProjectToXYplot(xp:TXYplot);
var
  i,j:integer;
  x1,y1,z1:double;
begin
  xp.clear;
  for i:=0 to PolyLineCount-1 do
  begin
    xp.AddPolyLine;
    with polylines[i] do
    for j:=0 to count-1 do
    begin
      gluProject(xvalue[j]*Fx,yvalue[j]*Fy,zvalue[j]*Fz,ModelViewParams,ProjectionParams,ViewPortParams,@x1,@y1,@z1);

//      x1:=(x1-viewPortParams[0])/ViewPortParams[2]*100;
//      y1:=(y1-viewPortParams[1])/ViewPortParams[3]*100;


      xp.lastPolyline.addPoint(x1,y1);
    end;
  end;
end;

procedure TXYZplot.ProjectToMatrix(mat:Tmatrix);
var
  i,j,i1,j1:integer;
  x1,y1,z1:double;
  Nx,Ny:integer;
begin
  with mat do modify(tpNum,Istart,Jstart,Iend,Jstart+round(ViewPortParams[3]/ViewPortParams[2]*Icount)-1);
  mat.clear;
  for i:=0 to PolyLineCount-1 do
  begin
    with polylines[i] do
    for j:=0 to count-1 do
    begin
      gluProject(xvalue[j]*Fx,yvalue[j]*Fy,zvalue[j]*Fz,ModelViewParams,ProjectionParams,ViewPortParams,@x1,@y1,@z1);
      i1:=mat.Istart+trunc((x1-ViewPortParams[0])/ViewPortParams[2]*mat.Icount);
      j1:=mat.Jstart+trunc((y1-ViewPortParams[1])/ViewPortParams[3]*mat.Jcount);
      if (i1>=mat.Istart) and (i1<=mat.Iend) and (j1>=mat.Jstart) and  (j1<=mat.Jend) then mat.incI(i1,j1);
    end;
  end;
end;

procedure TXYZplot.ProjectToMatrix1(NumPol:integer;mat:Tmatrix;table:Ttable3);
var
  i,j,i1,j1,i2,j2:integer;
  x1,y1,z1:double;
  Nx,Ny:integer;
begin
  with mat do modify(tpNum,Istart,Jstart,Iend,Jstart+round(ViewPortParams[3]/ViewPortParams[2]*Icount)-1);
  mat.clear;
  table.clear;
  setlength(table.att,mat.Icount,mat.Jcount);
  with polylines[NumPol],table do
    for j:=0 to count-1 do
    begin
      gluProject(xvalue[j]*Fx,yvalue[j]*Fy,zvalue[j]*Fz,ModelViewParams,ProjectionParams,ViewPortParams,@x1,@y1,@z1);

      i1:=mat.Istart+trunc((x1-ViewPortParams[0])/ViewPortParams[2]*mat.Icount);
      j1:=mat.Jstart+trunc((y1-ViewPortParams[1])/ViewPortParams[3]*mat.Jcount);

      i2:=i1-mat.Istart;
      j2:=j1-mat.Jstart;

      if (i1>=mat.Istart) and (i1<=mat.Iend) and (j1>=mat.Jstart) and  (j1<=mat.Jend) then
      begin
        mat.incI(i1,j1);

        setlength(att[i2,j2],length(att[i2,j2])+1);
        att[i2,j2,high(att[i2,j2])]:=j+1;
      end;
    end;
end;

procedure TXYZplot.setBM(w,h: integer);
var
  bm:TbitmapEx;
begin
  bm:=TbitmapEx.create;
  bm.width:=w;
  bm.height:=h;

  initGraphic(bm);
  display;
  doneGraphic;
  {
  bm.saveToFile(stB);
  if PRLandscape
    then printer.orientation:=poLandscape
    else printer.orientation:=poPortrait;
  printer.beginDoc;
  positionnePrinter(Pleft,Ptop,Pwidth,Pheight);

  with printer do
    displayBitmap(stB,canvas,Pleft,Ptop,Pleft+Pwidth,Ptop+Pheight);
  printer.endDoc;

  effacerFichier(stB);
  }
end;


procedure TXYZplot.PrintSaveCopy(sender: Tobject);
var
  w,h,res:integer;

  bm:TbitmapEx;
  stB,ext:AnsiString;
Const
  stFile:AnsiString='';
  colorBK: integer=clWhite;
  quality: integer=100;
begin
  res:=GLPrintForm.execute(ident,w,h,colorBK,quality);
  if res>100 then
  try
    bm:=TbitmapEx.create;
    bm.width:=w;
    bm.height:=h;


    initGraphic(bm);
    clearWindow(colorBK);
    display;
    doneGraphic;

    case res of
     101: begin
            stB:=getTmpName('bmp');
            bm.saveToFile(stB);
            if PRLandscape
              then printer.orientation:=poLandscape
              else printer.orientation:=poPortrait;
            printer.beginDoc;
//            positionnePrinter(Pleft,Ptop,Pwidth,Pheight);

            with printer do
              displayBitmap(stB,canvas,0,0,PageWidth,PageHeight);
            printer.endDoc;

            effacerFichier(stB);
          end;

     102: begin
            stFile:=GSaveFile('Save to BMP file',stFile,'BMP');
            ext:=Fmaj(extractfileExt(stFile));
            if stFile<>'' then
            begin
              if (ext='.JPG') or (ext='.JPEG') then bm.SaveAsJpeg(stFile,quality)
              else
              if (ext='.PNG') then bm.SaveAsPNG(stFile)
              else bm.SaveToFile(stFile);
            end;
          end;

     103: clipBoard.assign(bm);
    end;
  finally
    bm.free;
  end;
end;



{************************* Méthodes STM de TpolyLine3D **********************}

var
  E_line:integer;
  E_line1:integer;

procedure proTpolyLine3D_addPoint(x,y,z:float; pu:pointer);
begin
  with TpolyLine3D(pu) do addPoint(x,y,z);
end;

procedure proTpolyLine3D_addPoint_1(x,y,z:float; col:integer; pu:pointer);
begin
  with TpolyLine3D(pu) do addPoint(x,y,z,col);
end;


function fonctionTpolyLine3D_count( pu:pointer):longint;
begin
  result:=TpolyLine3D(pu).count;
end;

procedure proTpolyLine3D_X(i:longint;w:float; pu:pointer);
begin
  with TpolyLine3D(pu) do
  begin
    controleParam(i,1,count,E_line);
    setX(i-1,w);
  end;
end;

function fonctionTpolyLine3D_X(i:longint; pu:pointer):float;
begin
  with TpolyLine3D(pu) do
  begin
    controleParam(i,1,count,E_line);
    result:=getX(i-1);
  end;
end;

procedure proTpolyLine3D_Y(i:longint;w:float; pu:pointer);
begin
  with TpolyLine3D(pu) do
  begin
    controleParam(i,1,count,E_line);
    setY(i-1,w);
  end;
end;

function fonctionTpolyLine3D_Y(i:longint; pu:pointer):float;
begin
  with TpolyLine3D(pu) do
  begin
    controleParam(i,1,count,E_line);
    result:=getY(i-1);
  end;
end;

procedure proTpolyLine3D_Z(i:longint;w:float; pu:pointer);
begin
  with TpolyLine3D(pu) do
  begin
    controleParam(i,1,count,E_line);
    setZ(i-1,w);
  end;
end;

function fonctionTpolyLine3D_Z(i:longint; pu:pointer):float;
begin
  with TpolyLine3D(pu) do
  begin
    controleParam(i,1,count,E_line);
    result:=getZ(i-1);
  end;
end;

procedure proTpolyLine3D_PointColor(i:longint;w:integer; pu:pointer);
begin
  with TpolyLine3D(pu) do
  begin
    controleParam(i,1,count,E_line);
    setCol(i-1,w);
  end;
end;


function fonctionTpolyLine3D_PointColor(i:longint; pu:pointer):integer;
begin
  with TpolyLine3D(pu) do
  begin
    controleParam(i,1,count,E_line);
    result:=getCol(i-1);
  end;
end;


procedure proTpolyLine3D_clear( pu:pointer);
begin
  with TpolyLine3D(pu) do clear;
end;

procedure proTpolyLine3D_Color(w:integer; pu:pointer);
begin
  TpolyLine3D(pu).rec.color:=w;
end;

function fonctionTpolyLine3D_Color(pu:pointer):integer;
begin
  result:= TpolyLine3D(pu).rec.color;
end;

procedure proTpolyLine3D_UsePointColor(w:boolean; pu:pointer);
begin
  TpolyLine3D(pu).rec.UsePointColor:=w;
end;

function fonctionTpolyLine3D_UsePointColor(pu:pointer):boolean;
begin
  result:=TpolyLine3D(pu).rec.UsePointColor;
end;

procedure proTpolyLine3D_Mode(x:integer;pu:pointer);
begin
  controleParametre(x,0,7);
  TpolyLine3D(pu).rec.mode:=x;
end;

function fonctionTpolyLine3D_Mode(pu:pointer):integer;
begin
  fonctionTpolyLine3D_Mode:=TpolyLine3D(pu).rec.mode;
end;

procedure proTpolyLine3D_SymbolSize(x:float;pu:pointer);
begin
  if x<0 then x:=0;
  TpolyLine3D(pu).rec.SymbolSize:=x;
end;

function fonctionTpolyLine3D_SymbolSize(pu:pointer):float;
begin
  fonctionTpolyLine3D_SymbolSize:=TpolyLine3D(pu).rec.SymbolSize;
end;

procedure proTpolyLine3D_SymbolSize2(x:float;pu:pointer);
begin
  if x<0 then x:=0;
  TpolyLine3D(pu).SymbolSize2:=x;
end;

function fonctionTpolyLine3D_SymbolSize2(pu:pointer):float;
begin
  result:=TpolyLine3D(pu).SymbolSize2;
end;

procedure proTpolyLine3D_Theta(x:float;pu:pointer);
begin
  TpolyLine3D(pu).Theta:=x;
end;

function fonctionTpolyLine3D_Theta(pu:pointer):float;
begin
  result:=TpolyLine3D(pu).Theta;
end;

procedure proTpolyLine3D_Phi(x:float;pu:pointer);
begin
  TpolyLine3D(pu).Phi:=x;
end;

function fonctionTpolyLine3D_Phi(pu:pointer):float;
begin
  result:=TpolyLine3D(pu).Phi;
end;

procedure proTpolyLine3D_DottedLine(x:boolean;pu:pointer);
begin
  TpolyLine3D(pu).DottedLine:=x;
end;

function fonctionTpolyLine3D_DottedLine(pu:pointer):boolean;
begin
  result:=TpolyLine3D(pu).DottedLine;
end;


procedure proTpolyLine3D_loadFromVectors(var v1,v2,v3:Tvector;i1,i2:integer; pu:pointer);
begin
  verifierVecteur(v1);
  verifierVecteur(v2);
  verifierVecteur(v3);

  TpolyLine3D(pu).loadFromVectors(v1,v2,v3,nil,i1,i2);
end;

procedure proTpolyLine3D_loadFromVectors_1(var v1,v2,v3,v4:Tvector;i1,i2:integer; pu:pointer);
begin
  verifierVecteur(v1);
  verifierVecteur(v2);
  verifierVecteur(v3);
  verifierVecteur(v4);

  TpolyLine3D(pu).loadFromVectors(v1,v2,v3,v4,i1,i2);
end;


procedure proTpolyLine3D_loadPolyline(p:TpolyLine3D; pu:pointer);
begin
  TpolyLine3D(pu).loadPolyline(p);
end;




{************************* Méthodes STM de TXYZplot ***************************}


procedure proTXYZplot_create(stName:AnsiString;var pu:typeUO);
begin
  createPgObject(stname,pu,TXYZplot);
end;

procedure proTXYZplot_create_1(var pu:typeUO);
begin
  createPgObject('',pu,TXYZplot);
end;

procedure proTXYZplot_addPolyLine(var pu:typeUO);
begin
  verifierObjet(pu);
  with TXYZplot(pu) do addPolyLine;
end;

function fonctionTXYZplot_count(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).polyLineCount;
end;

procedure proTXYZplot_clear(var pu:typeUO);
begin
  verifierObjet(pu);
  with TXYZplot(pu) do clear;
end;


function fonctionTXYZplot_polyLines(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TXYZplot(pu) do
  begin
    ControleParam(i,1,PolyLineCount,E_line1);
    result:=list0.items[i-1];
  end;
end;

function fonctionTXYZplot_last(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TXYZplot(pu) do
  begin
    result:=list0.Last;
  end;
end;


procedure proTXYZplot_NextColor(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).NextColor:=w;
end;

function fonctionTXYZplot_NextColor(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).NextColor;
end;


procedure proTXYZplot_ScaleColor(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).ScaleColor:=w;
end;

function fonctionTXYZplot_ScaleColor(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).ScaleColor;
end;



procedure proTXYZplot_AutoscaleX(var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).autoscaleX;
end;

procedure proTXYZplot_AutoscaleY(var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).autoscaleY;
end;

procedure proTXYZplot_AutoscaleZ(var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).autoscaleZ;
end;

function fonctionTXYZplot_Xmin(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).Xmin;
end;

procedure proTXYZplot_Xmin(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).Xmin:=x;
end;

function fonctionTXYZplot_Xmax(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).Xmax;
end;

procedure proTXYZplot_Xmax(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).Xmax:=x;
end;

function fonctionTXYZplot_Ymin(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).Ymin;
end;

procedure proTXYZplot_Ymin(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).Ymin:=x;
end;

function fonctionTXYZplot_Ymax(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).Ymax;
end;

procedure proTXYZplot_Ymax(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).Ymax:=x;
end;

function fonctionTXYZplot_Zmin(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).Zmin;
end;

procedure proTXYZplot_Zmin(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).Zmin:=x;
end;

function fonctionTXYZplot_Zmax(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).Zmax;
end;

procedure proTXYZplot_Zmax(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).Zmax:=x;
end;

function fonctionTXYZplot_D0(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).inf3D.D0;
end;

procedure proTXYZplot_D0(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).inf3D.D0:=x;
end;


function fonctionTXYZplot_ThetaD(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).inf3D.ThetaD
end;

procedure proTXYZplot_ThetaD(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).inf3D.ThetaD:=x;
end;

function fonctionTXYZplot_PhiD(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).inf3D.PhiD
end;

procedure proTXYZplot_PhiD(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).inf3D.PhiD:=x;
end;

function fonctionTXYZplot_FOV(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).inf3D.FOV
end;

procedure proTXYZplot_FOV(x:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).inf3D.FOV:=x;
end;

procedure proTXYZplot_InitD0(var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).initD0;
end;

function fonctionTXYZplot_ShowScale(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).FshowScale;
end;

procedure proTXYZplot_ShowScale(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).FShowScale:=x;
end;

function fonctionTXYZplot_ShowGrid(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).FshowGrid;
end;

procedure proTXYZplot_ShowGrid(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).FShowGrid:=x;
end;

function fonctionTXYZplot_Scaling3D(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).Scaling3D;
end;

procedure proTXYZplot_Scaling3D(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).Scaling3D:=x;
end;

function fonctionTXYZplot_Ortho(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).FOrtho;
end;

procedure proTXYZplot_Ortho(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).FOrtho:=x;
end;

function fonctionTXYZplot_RefAxis(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).refAxis;
end;

procedure proTXYZplot_RefAxis(x:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TXYZplot(pu).refAxis:=x;
end;


procedure proTXYZplot_GetProjection(x,y,z:float;var x1,y1,z1:float;var pu:typeUO);
var
  xd,yd,zd:double;
begin
  verifierObjet(pu);
  TXYZplot(pu).getProj(x,y,z,xd,yd,zd);
  x1:=xd;
  y1:=yd;
  z1:=zd;
end;

procedure proTXYZplot_ProjectToMatrix(var mat:Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));
  TXYZplot(pu).ProjectToMatrix(mat);
end;

procedure proTXYZplot_ProjectToMatrix1(NumPol:integer;var mat:Tmatrix;var table:Ttable3;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(mat));
  if not assigned(table) then createPgObject('',typeUO(table),TTable3);
  with TXYZplot(pu) do
  begin
    if (NumPol<1) or (NumPol>polylineCount) then sortieErreur('TXYZplot.ProjectToMatrix1 : polyline number out of range');
    ProjectToMatrix1(NumPol-1,mat,table);
  end;  
end;


procedure proTXYZplot_ProjectToXYplot(var xp:TxyPlot;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(xp));
  TXYZplot(pu).ProjectToXYplot(xp);
end;

procedure proTXYZplot_OnMouseUp(p:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TXYZplot(pu).onMouseUp do setAd(p);
end;

function fonctionTXYZplot_onMouseUp(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TXYZplot(pu).OnMouseUp.ad;
end;


Initialization
AffDebug('Initialization stmXYZplot1',0);

installError(E_line,'TpolyLine3D:line number out of range');
installError(E_line1,'TXYZplot:line number out of range');

registerObject(TXYZplot,data);

end.
