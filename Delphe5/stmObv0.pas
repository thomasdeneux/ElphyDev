unit Stmobv0;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,controls,forms,sysUtils,
     util1,Gdos,Dgraphic,DdosFich,editCont,
     formMenu,
     Stmdef,StmObj,
     syspal32,

     getdeg0,defForm,getDisk0,
     varConf1,Dpalette,
     Ncdef2,sysmask0,debug0,
     {$IFDEF DX11}
     {$ELSE}
     DXTypes, Direct3D9G, D3DX9G,
     {$ENDIF}
     DibG,BMex1,
     clock0,
     stmPg,
     stmMat1,stmGraph2;


type
  TvisualObject=
           class(typeUO)

           private
              FOnScreen:boolean;
              FonControl:boolean;
              Flocked:boolean;
              FisOnScreen:boolean;
              FisOnCtrl:boolean;
           protected
              capture:boolean;

           public

              ControlColor:longint;
              DlineWidth:integer;
              Dcolor:integer;


              procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;


              function getOnScreen:boolean;override;
              procedure setOnScreen(v:boolean);override;
              procedure setFlagOnScreen(v:boolean);override;

              function getOnControl:boolean;override;
              procedure setOnControl(v:boolean);override;
              procedure setFlagOnControl(v:boolean);override;

              function getLocked:boolean;override;
              procedure setLocked(v:boolean);override;

              function getIsOnScreen:boolean;override;
              procedure setIsOnScreen(v:boolean);override;

              function getIsOnCtrl:boolean;override;
              procedure setIsOnCtrl(v:boolean);override;

              destructor destroy;override;

              function getRsegment(n:smallInt;var AB:TRsegment;
                                   var theta:float):boolean;virtual;
              procedure AlignOnVisualObject(ob:TvisualObject;numO,num:smallInt);
                                  virtual;
              function isVisual:boolean;override;

              procedure setPhase(phase:float);virtual;

              function getParamAd(name:Ansistring; var tp: typeNombre): pointer;virtual;
           end;

{  Tresizable:

   Tous les objets susceptibles d'être animés descendent de Tresizable.
   Dans Tstim: obvis:Tresizable

   deg caractérise la position (x,y,dx,dy,theta) de l'objet sur l'écran.

   HardBM est une surface DX qui contient l'image projetée sur l'écran à chaque
rafraichissement. Cette surface n'est recalculée que si les paramètres dx,dy,theta
ou un autre paramètre d'aspect à changé.

   CreateHardBM crée cette surface et calcule des paramètres utilisables ultérieurement:

   poly est le rectangle calculé à partir de deg

   Les sommets sont numérotés  3 - 4
                               |   |
                               2 - 1

   xminEx,yminEx,xmaxEx,ymaxEx contiennent les coo extrêmes du rectangle poly
   xorg et yorg sont les coordonnées du centre du rectangle dans le HardBM
   deg1 contient la valeur de deg au moment de createHardBM.
   Un objet réel doit mémoriser également les paramètres d'aspect qui, en cas de
changement, nécessitent une reconstruction de HardBM.


   BMaff est l'équivalent de HardBM sur l'écran de contrôle.  De la même façon, on a:
   CreateBMaff
   polyAff
   BMaff
   xminAff et yminAff
   xaff et yaff
   degAff

   Les surfaces allouées sont légèrement plus grandes que nécessaire. Un objet
réel ne doit donc pas se baser sur HardBM.width ou hardBM.height.

    Chaque fois qu'un objet est sélectionné sur l'écran de controle, on définit
9 régions sensibles à la souris (rgn)
}


type
  TBarVertex = packed record
    x, y, z: Single; // The untransformed position for the vertex
    color: DWORD;    // The vertex color
    u1,v1:single;
  end;

  TBarVertexArray = Array[0..1000] of TBarVertex;
  PBarVertexArray = ^TBarVertexArray;

const
  BarVertexCte = D3DFVF_XYZ or D3DFVF_DIFFUSE or D3DFVF_TEX1;



type
  Tresizable=
          class(TvisualObject)

          protected
            xminEx,yminEx,xmaxEx,ymaxEx:integer;

          public
            deg:typeDegre;       { deg contient les coo primaires }
            MultiDeg: array of typeDegre;
            RgbColor: integer;   { pour DX9, il devient possible d'utiliser toutes les couleurs }
                                 { RgbColor est une couleur Windows fabriquée avec rgb }
            BlendAlpha, BlendAlpha1: single;
            Zdistance: integer;

            poly:typePoly5;      { rectangle correspondant à deg sur écran stim}
            deg1:typeDegre;      { deg au moment ou l'on crée HardBM }

            NvertexTot:integer;
            Nvertex: array of integer;

            VB: Idirect3DVertexBuffer9;
            MaskTexture: IDirect3DTexture9;

            
            xorg,yorg:smallInt;  { position du centre du HardBM }



            polyAff:typePoly5;   { rectangle correspondant à poly sur controle}
            degAff:typeDegre;    { deg au moment du calcul de BMaff }
            BMaff:TbitmapEx;
            xaff,yaff:smallInt;  { position du centre du BMaff }
            xminaff,yminaff:smallInt;



            rgn:array[0..8] of hRgn;       { Régions utilisées par la souris }
            NumCap:smallInt;               { numéro de la zone de capture }
                                           { 0: tout
                                             1 à 4: angles
                                             5 à 8: milieux des cotés}
            dxMouse,dyMouse:smallInt;      { coo souris par rapport au deg au
                                             moment du MouseDown }

            markedSide:smallInt;           { coté marqué 1 à 4 }
            MarkedSideVisible:boolean;
            degini:typeDegre;              { stocké au moment du mouseDown }


            Fmask:boolean;                 { si true, s'affiche en tant que masque }


          public

            FastMove:boolean;

            Nodim:boolean;                 { Vaut true si les dimensions ne
                                             peuvent changer }
            NoTheta:boolean;               { Vaut true si theta ne
                                             peut changer }


            UseContour:boolean;
            Contour:array of array of TRpoint;
            ContourMode:D3DPRIMITIVETYPE;

            MagnifyContour,RotateContour:boolean;

            BlendOp,BlendOpAlpha:integer;

            constructor create;override;


            function ResourceNeeded:boolean;virtual;
            procedure Blt(const degV: typeDegre);virtual;

            function createBMaff:boolean;
            procedure BltAff;


            procedure creerRegions;override;
            procedure detruireRegions;override;

            procedure afficheS;override;

            procedure afficheC;override;


            { procédures appelées par HKpaint }
            procedure MouseUp(Button: TMouseButton;
                            Shift: TShiftState; X, Y: smallInt);override;
            function MouseDown(Button: TMouseButton;
                            Shift: TShiftState; X, Y: smallInt):boolean;override;
                 {renvoie true si l'objet est capturé}
            function MouseMove(Shift: TShiftState;
                            X, Y: smallInt):smallInt; override;
                 {renvoie:  0 si non concerné
                            1 si la position est modifiée
                            2 si la taille est modifiée }

            procedure ProcessMessage(id:integer;source:typeUO;p:pointer);
               override;



            procedure afficheFast;

            { Ces 6 procédures sont utilisées uniquement par inspobj2 }
            procedure extraDialog(sender:Tobject);override;
            function DialogForm:TclassGenForm;override;
            procedure installDialog(var form:Tgenform;var newF:boolean);
                                                                   override;

            { Lire et écrire deg en texte }
            function readTxt(st:AnsiString):boolean;
            function writeTxt(st:AnsiString):boolean;

            procedure ShowHandles;override;

            function getRsegment(n:smallInt;var AB:TRsegment
                                       ;var theta:float):boolean; override;
            procedure AlignOnVisualObject(ob:TvisualObject;numO,num:smallInt);override;
            destructor destroy;override;

            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
            function getInfo:AnsiString;override;

            procedure BuildResource;virtual;
            procedure buildBMaff;virtual;

            procedure freeBM;override;

            procedure prepareS;    {prépare BM avant une animation}
            procedure prepareC;    {si un obvis n'utilise pas de BM, il faut}
                                   {surcharger avec une méthode vide }

            procedure Display;override;
            function Plotable:boolean;override;

            procedure AddToStimList(list:Tlist);override;
            procedure CompleteLoadInfo;override;

            procedure BMtoMat(mat:Tmatrix);

            procedure setContour(plot:TXYplot; const mode:D3DPRIMITIVETYPE= D3DPRIMITIVETYPE(0));
            function getParamAd(name:AnsiString; var tp: typeNombre): pointer;override;


            function MainColor: Dword;
            
            function GetIsMask: boolean;override;
            procedure SetIsMask(w: boolean);override;

            function getD3DZ: integer;override;

            procedure store2(var NV:integer;x,y:float;Const Falloc:boolean=false);virtual;
            procedure BuildContourVertices(Falloc:boolean);
            procedure BltContourVertices;

            function SetBlendOp: boolean;override;
          end;

  TRF= class(Tresizable)
            constructor create;override;
            class function STMClassName:AnsiString;override;

            procedure BuildResource;override;
            procedure Blt(const degV: typeDegre);override;
            
          end;


  TBar=class(Tresizable)
       private
            vertices: PbarVertexArray;
            CurrentCol:integer;
       public
            constructor create;override;

            class function STMClassName:AnsiString;override;

            procedure BuildResource;override;

            procedure Blt(const degV: typeDegre);override;

            procedure buildBMaff;override;

            procedure CompleteLoadInfo;override;
            procedure BuildMaskSingle(mat:Tmatrix);
            procedure store2(var NV:integer;Ax,Ay:float;Const Falloc:boolean=false);override;
          end;

  Tdisk=class(Tresizable)
            Nfan: integer;
            constructor create;override;
            class function STMClassName:AnsiString;override;

            procedure BuildResource;override;

            procedure Blt(const degV: typeDegre);override;
            
            procedure buildBMaff;override;

          end;

var
  RFsys:array[1..5] of TRF;
const
  stRF:array[1..5] of string[3]=('RF1','RF2','RF3','RF4','RF5');



procedure proTvisualObject_onScreen(b:boolean;var pu:typeUO);pascal;
function fonctionTvisualObject_onScreen(var pu:typeUO):boolean;pascal;
procedure proTvisualObject_onControl(b:boolean;var pu:typeUO);pascal;
function fonctionTvisualObject_onControl(var pu:typeUO):boolean;pascal;



procedure proTvisualObject_alignOnObject(var p:Tresizable;numO,num:integer;
                                         var pu:TypeUO);pascal;

procedure proTresizable_Lum(ww:float;var pu:typeUO);pascal;
function fonctionTresizable_Lum(var pu:typeUO):float;pascal;

procedure proTresizable_RgbColor(ww:integer;var pu:typeUO);pascal;
function fonctionTresizable_RgbColor(var pu:typeUO):integer;pascal;

procedure proTresizable_BlendAlpha(ww: float;var pu:typeUO);pascal;
function fonctionTresizable_BlendAlpha(var pu:typeUO):float;pascal;

procedure proTresizable_Zdistance(ww: smallint;var pu:typeUO);pascal;
function fonctionTresizable_Zdistance(var pu:typeUO):smallint;pascal;

procedure proTresizable_ControlColor(ww:longint;var pu:typeUO);pascal;
function fonctionTresizable_ControlColor(var pu:typeUO):longint;pascal;



procedure proTresizable_x(ww:float;var pu:typeUO);pascal;
function fonctionTresizable_x(var pu:typeUO):float;pascal;
procedure proTresizable_y(ww:float;var pu:typeUO);pascal;
function fonctionTresizable_y(var pu:typeUO):float;pascal;
procedure proTresizable_dx(ww:float;var pu:typeUO);pascal;
function fonctionTresizable_dx(var pu:typeUO):float;pascal;
procedure proTresizable_dy(ww:float;var pu:typeUO);pascal;
function fonctionTresizable_dy(var pu:typeUO):float;pascal;
procedure proTresizable_theta(ww:float;var pu:typeUO);pascal;
function fonctionTresizable_theta(var pu:typeUO):float;pascal;

procedure proTresizable_setParams(xa,ya,dxa,dya,thetaa,luma:float;var pu:typeUO);pascal;
procedure proTresizable_saveToMat(var mat:Tmatrix;var pu:typeUO);pascal;


procedure proTresizable_markedSide(num:integer;var pu:typeUO);pascal;
function fonctionTresizable_markedSide(var pu:typeUO):integer;pascal;
procedure proTresizable_markedSideVisible(b:boolean;var pu:typeUO);pascal;
function fonctionTresizable_markedSideVisible(var pu:typeUO):boolean;pascal;

procedure proTresizable_Dcolor(num:integer;var pu:typeUO);pascal;
function fonctionTresizable_Dcolor(var pu:typeUO):integer;pascal;

procedure proTresizable_DlineWidth(num:integer;var pu:typeUO);pascal;
function fonctionTresizable_DlineWidth(var pu:typeUO):integer;pascal;

procedure proTresizable_Fmask(b:boolean;var pu:typeUO);pascal;
function fonctionTresizable_Fmask(var pu:typeUO):boolean;pascal;

procedure proTresizable_UseContour(x:boolean;var pu:typeUO);pascal;
function fonctionTresizable_UseContour(var pu:typeUO):boolean;pascal;

procedure proTresizable_RotateContour(x:boolean;var pu:typeUO);pascal;
function fonctionTresizable_RotateContour(var pu:typeUO):boolean;pascal;

procedure proTresizable_MagnifyContour(x:boolean;var pu:typeUO);pascal;
function fonctionTresizable_MagnifyContour(var pu:typeUO):boolean;pascal;

procedure proTresizable_SetContour(var plot:TXYplot;var pu:typeUO);pascal;
procedure proTresizable_SetContour_1(var plot:TXYplot;mode: integer;var pu:typeUO);pascal;

procedure proTresizable_AddMultiDisplay(xA,yA,dxA,dyA,thetaA:float;var pu:typeUO);pascal;
procedure proTresizable_ResetMultiDisplay(var pu:typeUO);pascal;

procedure proTresizable_BlendOp(num:integer;var pu:typeUO);pascal;
function fonctionTresizable_BlendOp(var pu:typeUO):integer;pascal;

procedure proTresizable_BlendOpAlpha(num:integer;var pu:typeUO);pascal;
function fonctionTresizable_BlendOpAlpha(var pu:typeUO):integer;pascal;

procedure proTbar_create(var pu:typeUO);pascal;
procedure proTbar_create_1(name:AnsiString;var pu:typeUO);pascal;


procedure proTdisk_create(var pu:typeUO);pascal;
procedure proTdisk_create_1(name:AnsiString;var pu:typeUO);pascal;

procedure proTdisk_dx(ww:float;var pu:typeUO);pascal;
function fonctionTdisk_dx(var pu:typeUO):float;pascal;
procedure proTdisk_dy(ww:float;var pu:typeUO);pascal;
function fonctionTdisk_dy(var pu:typeUO):float;pascal;
procedure proTdisk_Diameter(ww:float;var pu:typeUO);pascal;
function fonctionTdisk_Diameter(var pu:typeUO):float;pascal;

procedure proTRF_create(var pu:typeUO);pascal;
procedure proTRF_create_1(name:AnsiString;var pu:typeUO);pascal;



IMPLEMENTATION


{*********************   Méthodes de TvisualObject  **************************}


procedure TvisualObject.AlignOnVisualObject(ob:TvisualObject;numO,num:smallInt);
begin
end;

procedure TvisualObject.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;
  with conf do
  begin
    setvarConf('ONCONTROL',FonControl,sizeof(FonControl));
    setvarConf('ONSCREEN',FOnScreen,sizeof(FOnScreen));
  end;
end;

destructor TvisualObject.destroy;
begin
  onScreen:=false;
  inherited;
end;

function TvisualObject.getOnScreen: boolean;
begin
  result:=FonScreen;
end;

procedure TvisualObject.setFlagOnScreen(v: boolean);
begin
  FonScreen:=v;
end;

procedure TvisualObject.SetOnScreen(v: boolean);
begin
  if FonScreen<>v then
    begin
      Fonscreen:=v;
      HKpaintScreen;
    end;
end;

function TvisualObject.getOnControl: boolean;
begin
  result:=FonControl;
end;

procedure TvisualObject.setFlagOnControl(v: boolean);
begin
  FonControl:=v;
end;

procedure TvisualObject.SetOnControl(v: boolean);
begin
  if v and (DispPriority=1) then
    begin
      FonControl:=v;
      bringToFront;
    end
  else
  if FonControl<>v then
    begin
      FonControl:=v;
      HKpaintPaint;
    end;
end;

function TvisualObject.getLocked:boolean;
begin
  result:=Flocked;
end;

procedure TvisualObject.setLocked(v:boolean);
begin
  Flocked:=v;
end;

function TvisualObject.getIsOnScreen:boolean;
begin
  result:=FisOnScreen;
end;

procedure TvisualObject.setIsOnScreen(v:boolean);
begin
  FisOnScreen:=v;
end;

function TvisualObject.getIsOnCtrl:boolean;
begin
  result:=FisOnCtrl;
end;

procedure TvisualObject.setIsOnCtrl(v:boolean);
begin
  FisOnCtrl:=v;
end;


function TvisualObject.getRsegment(n:smallInt;var AB:TRsegment;
                                        var theta:float):boolean;
begin
  getRsegment:=false;
end;

function TvisualObject.isVisual:boolean;
begin
  isVisual:=true;
end;


procedure TvisualObject.setPhase(phase:float);
begin

end;

function TvisualObject.getParamAd(name: AnsiString; var tp: typeNombre): pointer;
begin
  name:= UpperCase(name);
  tp:= nbBoole;
  if name='ONSCREEN' then result:= @FonScreen
  else result:=nil;
end;


{*********************   Méthodes de Tresizable   ***************************}

constructor Tresizable.create;
begin
  inherited;
  fastMove:=false;
  deg:=degNul;
  controlColor:=clGreen;

  RotateContour:=true;
  MagnifyContour:=true;

  rgbColor:=-1;
  BlendAlpha:=1;

  ContourMode:= D3DPRIMITIVETYPE(0);//D3DPT_TRIANGLEFAN;
end;


function Tresizable.ResourceNeeded:boolean;
begin
  result:=(VB=nil);
end;


procedure Tresizable.creerRegions;
var
  i,xm,ym:integer;
begin
  for i:=0 to 8 do
    if rgn[i]<>0 then deleteObject(rgn[i]);

  rgn[0]:=createPolygonRgn(polyAff,5,winding);
  for i:=1 to 4 do
    with polyAff[i] do
    begin
      rgn[i]:=createRectRgn(x-2,y-2,x+2,y+2);

      xm:=(x+polyAff[i+1].x) div 2;
      ym:=(y+polyAff[i+1].y) div 2;
      rgn[i+4]:=createRectRgn(xm-2,ym-2,xm+2,ym+2);
    end;

end;

procedure Tresizable.detruireRegions;
var
  i:integer;
begin
  for i:=0 to 8 do
    if rgn[i]<>0 then
      begin
        deleteObject(rgn[i]);
        rgn[i]:=0;
      end;
end;

procedure Tresizable.ShowHandles;
var
  i,xm,ym:integer;
begin
  for i:=1 to 4 do
    with polyAff[i] do
    begin
      drawHandle(x,y);
      xm:=(x+polyAff[i+1].x) div 2;
      ym:=(y+polyAff[i+1].y) div 2;
      drawHandle(xm,ym);
    end;
end;


procedure Tresizable.afficheC;
var
  i:Integer;
  xc,yc:Integer;
begin
  degToPolyAff(deg,polyAff);

  xc:=(polyAff[3].x+polyAff[4].x) div 2;
  yc:=(polyAff[3].y+polyAff[4].y) div 2;

  with canvasGlb do
  begin
      pen.color:=controlColor;
      brush.color:=controlColor;
      brush.Style:=bsSolid;

      if MarkedSideVisible and (markedSide<>0) then
        begin
          moveto(polyAff[1].x,polyAff[1].y);
          for i:=2 to 5 do
            begin
              if i-1=markedSide then pen.Color:=ClRed
                                else pen.Color:=ControlColor;
              lineto(polyAff[i].x,polyAff[i].y);
            end;
          pen.color:=controlColor;
        end
      else polyLine(polyAff);
      ellipse(xc-3,yc-3,xc+3,yc+3);
  end;

  creerRegions;
end;

procedure Tresizable.afficheS;
var
  i:integer;
  DegDum:typeDegre;
begin
  degToPoly(deg,poly);
  if ResourceNeeded then BuildResource;

  blt(deg);
  for i:=0 to high(MultiDeg) do
  begin
    degDum:= MultiDeg[i];
    degDum.x:= degDum.x+ deg.x;
    degDum.y:= degDum.y+ deg.y;
    degDum.theta:= degDum.theta+ deg.theta;
    blt(degDum);
  end;

end;




procedure Tresizable.BMtoMat(mat: Tmatrix);
var
  i,j:integer;
  p:PtabOctet;
  b:byte;
begin

end;


procedure Tresizable.buildBMaff;
begin
end;

procedure Tresizable.BuildResource;
begin
end;

procedure Tresizable.freeBM;
begin
  MaskTexture:=nil;
  VB:=nil;

end;


procedure Tresizable.prepareS;
begin
  //messageCentral(ident +'   PrepareS');
  if (DXscreen=nil) or not DXscreen.candraw then
  begin
    //messageCentral('EXIT');
    exit;
  end;
  degToPoly(deg,poly);

  if IsMask then VisualObjectIsMask:=true;
  if ResourceNeeded then  BuildResource;
  //messageCentral(ident +'   PrepareS Done');
end;

procedure Tresizable.prepareC;
begin
  buildBMaff;
end;




procedure Tresizable.afficheFast;
var
  i:integer;
  p1:typePoly5;
begin
  if (DXcontrol=nil) then exit;

  degToPolyAff(deg,p1);


  with DXcontrol.canvas do
  begin
    pen.style:=psSolid;
    pen.mode:=pmXor;
    pen.color:=clWhite;
    polyLine(p1);
  end;
end;



function Tresizable.MouseDown(Button: TMouseButton;
                            Shift: TShiftState; X, Y: smallInt):boolean;
var
  i:integer;
begin
  mouseDown:=false;
  if not onControl then exit;

  if  button=mbLeft then
    begin
      for i:=8 downto 0 do
      if PtInRegion(rgn[i],x,y) then
        begin
          dxMouse:=X-DegToXc(deg.x);
          dyMouse:=Y-DegToYc(deg.y);
          capture:=true;
          numCap:=i;
          mouseDown:=true;

          degini:=deg;
          if FastMove or GfastMove then AfficheFast;
          exit;
        end;
    end
  else
  if button=mbright then
    begin

    end;
end;

function Tresizable.MouseMove(Shift: TShiftState; X, Y: smallInt):smallInt;
var
  dxs,dys:float;
  alpha:float;
  s,m,p:TRpoint;
  polyR:typePoly5R;
  oldDeg:typeDegre;
  old:single;
begin
  MouseMove:=0;
  if not onControl then exit;

  if not capture then exit;

  if FastMove or GfastMove then afficheFast;
  oldDeg:=deg;
  case numCap of
    0:begin
        if not locked then
          begin
            deg.x:=XCtoDeg(x-dxMouse);
            deg.y:=YCtoDeg(y-dyMouse);
            if not (FastMove or GfastMove) and not compareMem(@deg,@oldDeg,sizeof(deg))
              then majPos;
          end;
        MouseMove:=1;
      end;
    1..4:
      begin
        if not (locked or NoDim) then
          begin
            alpha:=-deg.theta*pi/180;
            if (numCap=2) or (numCap=3) then alpha:=alpha+pi;

            dxs:=XCtoDeg(x)-deg.x;
            dys:=YCtoDeg(y)-deg.y;
            deg.dx:=abs(2*dxs*cos(alpha)-2*dys*sin(alpha));
            deg.dy:=abs(2*dxs*sin(alpha)+2*dys*cos(alpha));
            if degToPix(deg.dx)<=1 then
              begin
                deg.dx:=PixToDeg(2);
                capture:=false;
              end;
            if degToPix(deg.dy)<=1 then
              begin
                deg.dy:=PixToDeg(2);
                capture:=false;
              end;
            if not (FastMove or GfastMove) and not compareMem(@deg,@oldDeg,sizeof(deg))
              then majPos;
          end;
        MouseMove:=2;
      end;
    5..8:
      begin
        if not (locked or NoDim) then
          begin
            degToPolyR(degIni,polyR);

            s.x:=XCtoDeg(x);
            s.y:=YCtoDeg(y);

            m.x:=(polyR[numcap-4].x+polyR[numcap-3].x)/2;
            m.y:=(polyR[numcap-4].y+polyR[numcap-3].y)/2;


            p.x:=s.x+polyR[numcap-3].x-m.x;
            p.y:=s.y+polyR[numcap-3].y-m.y;

            deg:=degIni;
            alignVerticeOnSegment(deg, numcap-4,s,p);
            if not (FastMove or GfastMove) and not compareMem(@deg,@oldDeg,sizeof(deg))
              then majPos;
          end;
        MouseMove:=3;
      end;
  end;
  if FastMove or GfastMove then afficheFast;
end;

procedure Tresizable.MouseUp(Button: TMouseButton;
                            Shift: TShiftState; X, Y: smallInt);
begin
  if not onControl then exit;

  if not capture then exit;
  capture:=false;

  if FastMove or GfastMove then
    begin
      AfficheFast;
      majpos;
    end;
end;

function Tresizable.DialogForm:TclassGenForm;
begin
  DialogForm:=TdegForm;
end;

procedure Tresizable.ProcessMessage(id:integer;source:typeUO;p:pointer);
begin
  if (id=UOmsg_freeHardBM) or (id=UOmsg_colorsChanged) then freeBM;
end;


procedure Tresizable.installDialog(var form:Tgenform;var newF:boolean);
  begin
    inherited;
    majPos;

    TdegForm(Form).onScreenD:=setOnScreen;
    TdegForm(Form).onControlD:=SetOnControl;
    TdegForm(Form).onlockD:=setLocked;
    TdegForm(Form).majpos:=majpos;

    TdegForm(Form).setDeg(deg,onScreen,onControl,Flocked);
  end;

function Tresizable.writeTxt(st:AnsiString): boolean;
  var
    f:text;
  begin
    try
    result:=false;
    assignFile(f,st);
    rewrite(f);
    writeln(f,Istr(roundI(deg.x)));
    writeln(f,Istr(roundI(deg.y)));
    writeln(f,Istr(roundI(deg.dx)));
    writeln(f,Istr(roundI(deg.dy)));
    writeln(f,Istr(roundI(deg.theta)));
    close(f);
    result:=true;
    except
    {$I-}close(f); {$I+}
    end;
  end;

function Tresizable.readTxt(st:AnsiString): boolean;
  var
    f:text;
    st1:AnsiString;
    code:integer;
  begin
    try
    result:=false;
    assign(f,st);
    reset(f);
    readln(f,st1);
    val(st1,deg.x,code);
    readln(f,st1);
    val(st1,deg.y,code);
    readln(f,st1);
    val(st1,deg.dx,code);
    readln(f,st1);
    val(st1,deg.dy,code);
    readln(f,st1);
    val(st1,deg.theta,code);
    close(f);
    result:=true;
    except
    {$I-}close(f); {$I+}
    end;
  end;

procedure Tresizable.extraDialog(sender:Tobject);
  const
    nInit:integer=1;
  var
    n:integer;
    x,y:integer;
    stgen:AnsiString;
  begin
    x:=Tform(sender).left;
    y:=Tform(sender).top+Tform(sender).height+2;

    n:=ShowMenu(Tcomponent(sender),
                'File menu',
                'Load|Save',Ninit,
                x,y);
    case n of
      1: if ChoixFichierStandard(stGen,stFichierRF,nil) then
              begin
                if readTxt(stFichierRF) then
                  begin
                    updateVisualInspector;
                    majPos;
                  end;
              end;
      2: if SauverFichierStandard(stFichierRF,'')
              then writeTxt(stFichierRF);
    end;

  end;

function Tresizable.getRsegment(n:smallInt;var AB:TRsegment;
                                        var theta:float):boolean;
  var
    polyR:typePoly5R;
    ok:boolean;
    old:single;
  begin
    ok:=(n>=1) and (n<=4);
    getRsegment:=ok;
    if ok then
      begin
        degToPolyR(deg,polyR);
        AB[1]:=polyR[n];
        AB[2]:=polyR[n+1];
      end;
    theta:=deg.theta;
  end;

procedure Tresizable.AlignOnVisualObject(ob:TvisualObject;numO,num:smallInt);
  var
    AB:TRsegment;
    theta:float;
  begin
    if ob.getRsegment(numO,AB,theta) then
      begin
        deg.theta:=theta;
        alignVerticeOnSegment(deg,num,AB[1],AB[2]);
      end;
  end;

destructor Tresizable.destroy;
  begin
    freeBM;

    BMaff.free;
    BMaff:=nil;

    isMask:=false;

    inherited destroy;
  end;


procedure Tresizable.Blt(const degV: typeDegre);
begin
end;


function Tresizable.createBMaff:boolean;
var
  i:integer;
  xmin,ymin,xmax,ymax:integer;
begin
  BMaff.free;
  BMaff:=nil;
  degAff:=deg;

  result:=false;
  if not assigned(DXcontrol) then exit;

  xmin:=polyAff[1].x;
  xmax:=xmin;
  ymin:=polyAff[1].y;
  ymax:=ymin;

  for i:=2 to 4 do
    with polyAff[i] do
    begin
      if x>xmax then xmax:=x;
      if x<xmin then xmin:=x;
      if y>ymax then ymax:=y;
      if y<ymin then ymin:=y;
    end;

  BMaff:=TbitmapEx.create;
  BMaff.width:=xmax-xmin+1  +10;
  BMaff.Height:=ymax-ymin+1 +10;

  xAff:=(xmax-xmin) div 2;
  yAff:=(ymax-ymin) div 2;

  xminAff:=xmin;
  yminAff:=ymin;

  result:=true;
end;

procedure Tresizable.bltAff;
begin
  if not assigned(DXcontrol) then exit;
  DXcontrol.canvas.draw(degToXC(deg.x)-xaff,degToYC(deg.y)-yAff,BMaff);
end;

procedure Tresizable.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    inherited;
    with conf do
    begin
      setVarConf('DEG',deg,sizeof(deg));
    end;
  end;

function Tresizable.getInfo:AnsiString;
begin
  with deg do
  result:=inherited getInfo+CRLF+
          'x=    '+Estr1(x,10,3)+CRLF+
          'y=    '+Estr1(y,10,3)+CRLF+
          'dx=   '+Estr1(dx,10,3)+CRLF+
          'dy=   '+Estr1(dy,10,3)+CRLF+
          'theta='+Estr1(theta,10,3) +CRLF+
          'lum = '+Estr1(lum,10,3) +CRLF+
          'OnScreen= '+Bstr(Onscreen);

end;
                         
procedure Tresizable.Display;
var
  PR:typePoly5R;
  i:integer;
begin
  DegToPolyR(deg,PR);

  with canvasGlb do
  begin
    pen.Width:=DlineWidth;
    pen.Color:=Dcolor;

    moveto(convWx(PR[1].x),convWy(PR[1].y));
    for i:=2 to 5 do
      lineto(convWx(PR[i].x),convWy(PR[i].y));
  end;

end;

function Tresizable.Plotable:boolean;
begin
  result:=true;
end;

procedure Tresizable.AddToStimList(list:Tlist);
begin
  if (list.indexof(self)<0) and OnScreen then list.add(self);
end;

procedure Tresizable.completeLoadInfo;
begin
    inherited completeLoadInfo;
    with deg do
    begin
      if x<-degXmax then x:=-degXmax;
      if x>degXmax then x:=degXmax;

      if y<-degYmax then y:=-degYmax;
      if y>degYmax then y:=degYmax;

      if dx<DDegMin then dx:=DDegMin;
      if dx>2*DegXMax then dx:=2*DegXmax;

      if dy<DDegMin then dy:=DDegMin;
      if dy>2*DegXMax then dy:=2*DegXmax;


    end;
end;

procedure Tresizable.setContour(plot: TXYplot; const mode:D3DPRIMITIVETYPE=D3DPRIMITIVETYPE(0));
var
  i,j:integer;
  Dx0,Dy0: single;
begin
  Dx0:=deg.dx;
  Dy0:=deg.dy;

  if Dx0<=0 then Dx0:=1;
  if Dy0<=0 then Dy0:=1;

  setLength(contour,0,0);
  with plot do
  begin
    setlength(contour, PolylineCount);
    for i:=0 to PolylineCount-1 do
    with Polylines[i] do
    begin
      setLength(contour[i], count);
      for j:=0 to Count-1 do
      begin
        contour[i][j].x:= Xvalue[j]/Dx0;
        contour[i][j].y:= Yvalue[j]/Dy0;
      end;
    end;
  end;

  contourMode:= mode;
end;

function Tresizable.getParamAd(name:AnsiString; var tp: typeNombre): pointer;
begin
  tp:= nbSingle;

  name:=UpperCase(name);
  if name='X' then result:=@deg.x
  else
  if name='Y' then result:=@deg.y
  else
  if name='DX' then result:=@deg.dx
  else
  if name='DY' then result:=@deg.dy
  else
  if name='THETA' then result:=@deg.theta
  else
  if name='LUM' then result:=@deg.lum
  else result:= inherited getParamAd(name,tp);

end;


function Tresizable.MainColor: Dword;
begin
  if Ismask then result:=DevColBK
  else
  if RgbColor<>-1  then result:= D3Dcolor_xrgb(RgbColor and $FF, (rgbColor shr 8) and $FF, (rgbColor shr 16) )
  else
  result:= syspal.DX9color(deg.lum,BlendAlpha);
end;

function Tresizable.GetIsMask: boolean;
begin
  result:=Fmask;
end;

procedure Tresizable.SetIsMask(w: boolean);
var
  k:integer;
begin
  Fmask:=w;
  k:=MaskList.IndexOf(self);
  if w and (k<0) then MaskList.Add(self)
  else
  if not w and (k>=0) then MaskList.delete(k);
end;

function Tresizable.getD3DZ: integer;
begin
  result:=Zdistance;
end;

procedure Tresizable.store2(var NV: integer; x, y: float;Const Falloc:boolean=false);
begin

end;

procedure Tresizable.BuildContourVertices(Falloc: boolean);
var
  i,j: integer;
  xG,yG:single;
  NV: integer;

begin
  if contourMode=  D3DPRIMITIVETYPE(0) then
  begin
    // on ajoute deux points: le barycentre + le point de retour
    NvertexTot:=0;
    for i:=0 to length(Contour)-1 do
      NvertexTot:=NvertexTot + length(contour[i])+2 ;

    NV:=0;
    for i:=0 to length(Contour)-1 do
    if length(contour[i])>0 then
    begin
      xG:=0;
      yG:=0;
      for j:=0 to length(contour[i])-1 do
      with contour[i,j] do
      begin
        xG:=xG+x;
        yG:=yG+y;
      end;
      xG:=xG/length(contour[i]);
      yG:=yG/length(contour[i]);

      store2(NV,xG,yG,Falloc);
      for j:=0 to length(contour[i])-1 do
        with contour[i,j] do store2(NV,x,y,Falloc);
      with contour[i,0] do store2(NV,x,y,Falloc);
    end;
  end
else
  begin
    NvertexTot:=0;
    for i:=0 to length(Contour)-1 do
      NvertexTot:=NvertexTot + length(contour[i]);

    NV:=0;
    for i:=0 to length(Contour)-1 do
    if length(contour[i])>0 then
    begin
      for j:=0 to length(contour[i])-1 do
        with contour[i,j] do store2(NV,x,y,Falloc);
    end;
  end;

end;

Procedure Tresizable.BltContourVertices;
var
  i,NV,res:integer;
  nb1,nb2: integer;

begin
  NV:=0;
  if contourMode= D3DPRIMITIVETYPE(0) then
  begin
    for i:=0 to length(Contour)-1 do
    begin
      if length(contour[i])>0 then
        res:=DXscreen.IDevice.DrawPrimitive(D3DPT_TRIANGLEFAN,NV ,length(Contour[i]) );
      inc(NV,length(Contour[i])+2);
    end;
  end
  else
  begin
    case contourMode of
      D3DPT_POINTLIST:     begin nb1:=0; nb2:=1; end;
      D3DPT_LINELIST:      begin nb1:=0; nb2:=2; end;
      D3DPT_LINESTRIP:     begin nb1:=1; nb2:=1; end;
      D3DPT_TRIANGLELIST:  begin nb1:=0; nb2:=3; end;
      D3DPT_TRIANGLESTRIP: begin nb1:=2; nb2:=1; end;
      D3DPT_TRIANGLEFAN:   begin nb1:=2; nb2:=1; end;
      else exit;
    end;

    for i:=0 to length(Contour)-1 do
    begin
      if length(contour[i])>0 then
        res:=DXscreen.IDevice.DrawPrimitive(ContourMode,NV ,length(Contour[i]) div nb2 - nb1 );
       inc(NV,length(Contour[i]));
    end;
  end;
end;


function Tresizable.SetBlendOp: boolean;
begin
  result:= (BlendOp>0) or (BlendOpAlpha>0);

  
  with DXscreen.Idevice do
  begin
    SetRenderState(D3DRS_ALPHABLENDENABLE,itrue );
    SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, itrue);

    case BlendOp of
      1: begin
           SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);         // Keep DEST
           SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ZERO);
           SetRenderState(D3DRS_DESTBLEND,  D3DBLEND_ONE );
         end;
      2: begin
           SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);         // COPY SRC
           SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ONE);
           SetRenderState(D3DRS_DESTBLEND,  D3DBLEND_ZERO );
         end;
      3: begin
           SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);         // Use ALPHA SRC
           SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SrcALPHA);     //  Si alpha source=0 , c'est le fond qui reste
           SetRenderState(D3DRS_DESTBLEND,  D3DBLEND_InvSrcALPHA );
         end;
      4: begin
           SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);         // Use ALPHA DEST
           SetRenderState(D3DRS_SRCBLEND, D3DBLEND_DestAlpha);    //  Si alpha dest=0 , c'est le fond qui reste
           SetRenderState(D3DRS_DESTBLEND,  D3DBLEND_InvDestAlpha );
         end;
      5: begin
           SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_MAX);         // MAX (SRC , DEST)
           SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ONE);
           SetRenderState(D3DRS_DESTBLEND,  D3DBLEND_ONE );
         end;
      6: begin
           SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_MIN);         // MIN (SRC , DEST)
           SetRenderState(D3DRS_SRCBLEND, D3DBLEND_ONE);
           SetRenderState(D3DRS_DESTBLEND,  D3DBLEND_ONE );
         end;
    end;

    case BlendOpAlpha of
      1: begin
           SetRenderState(D3DRS_BLENDOPALPHA, D3DBLENDOP_ADD);         // Keep DEST
           SetRenderState(D3DRS_SRCBLENDALPHA, D3DBLEND_ZERO);
           SetRenderState(D3DRS_DESTBLENDALPHA,  D3DBLEND_ONE );
         end;
      2: begin
           SetRenderState(D3DRS_BLENDOPALPHA, D3DBLENDOP_ADD);         // COPY SRC
           SetRenderState(D3DRS_SRCBLENDALPHA, D3DBLEND_ONE);
           SetRenderState(D3DRS_DESTBLENDALPHA,  D3DBLEND_ZERO );
         end;
      3: begin
           SetRenderState(D3DRS_BLENDOPALPHA, D3DBLENDOP_ADD);         // Use ALPHA SRC
           SetRenderState(D3DRS_SRCBLENDALPHA, D3DBLEND_SrcALPHA);     //  Si alpha source=0 , c'est le fond qui reste
           SetRenderState(D3DRS_DESTBLENDALPHA,  D3DBLEND_InvSrcALPHA );
         end;
      4: begin
           SetRenderState(D3DRS_BLENDOPALPHA, D3DBLENDOP_ADD);         // Use ALPHA DEST
           SetRenderState(D3DRS_SRCBLENDALPHA, D3DBLEND_DestAlpha);      //  Si alpha dest=0 , c'est le fond qui reste
           SetRenderState(D3DRS_DESTBLENDALPHA,  D3DBLEND_InvDestAlpha );
         end;
      5: begin
           SetRenderState(D3DRS_BLENDOPALPHA, D3DBLENDOP_MAX);         // MAX (SRC , DEST)
           SetRenderState(D3DRS_SRCBLENDALPHA, D3DBLEND_ONE);
           SetRenderState(D3DRS_DESTBLENDALPHA,  D3DBLEND_ONE );
         end;
      6: begin
           SetRenderState(D3DRS_BLENDOPALPHA, D3DBLENDOP_MIN);         // MIN (SRC , DEST)
           SetRenderState(D3DRS_SRCBLENDALPHA, D3DBLEND_ONE);
           SetRenderState(D3DRS_DESTBLENDALPHA,  D3DBLEND_ONE );
         end;
    end;
  end;
end;


{*********************   Méthodes de TRF   ***************************}

constructor TRF.create;
  begin
    inherited create;
    with deg do
    begin
      x:=0;
      y:=0;
      dx:=10;
      dy:=4;
      lum:=25;
    end;
    fastMove:=false;
    ControlColor:=clWhite;
  end;

class function TRF.STMClassName:AnsiString;
  begin
    STMClassName:='RF';
  end;


procedure TRF.BuildResource;
var
  vertices: array of TbarVertex;
  i,j:integer;
  col: Dword;
  up: boolean;

  pVertices: Pointer;

begin
  col:=  MainColor;
  setLength(vertices,5);
  fillchar(vertices[0],sizeof(vertices[0])*5,0);
  with vertices[0] do
  begin
    x:=-0.5;
    y:= 0.5;
    z:= 0;
    color:= col;
  end;
  with vertices[1] do
  begin
    x:=-0.5;
    y:=-0.5;
    z:= 0;
    color:= col;
  end;
  with vertices[2] do
  begin
    x:= 0.5;
    y:= -0.5;
    z:= 0;
    color:= col;
  end;
  with vertices[3] do
  begin
    x:= 0.5;
    y:= 0.5;
    z:= 0;
    color:= col;
  end;
  with vertices[4] do
  begin
    x:=-0.5;
    y:= 0.5;
    z:= 0;
    color:= col;
  end;


  VB:=nil;
  if FAILED(DXscreen.IDevice.CreateVertexBuffer(SizeOf(TBarVertex)*5, 0, BarVertexCte, D3DPOOL_DEFAULT, VB, nil)) then Exit;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then Exit;
  CopyMemory(pVertices, @vertices[0], SizeOf(TBarVertex)*5);
  VB.Unlock;

  DX9end;
end;

procedure TRF.Blt(const degV: typeDegre);
var
  mat,mTrans, mRot, mScale: TD3DMatrix;
  pVertices: PbarVertexArray;
  col, res, i:integer;
begin
  if (@degV=@deg) and (deg.lum<>deg1.lum) then
  begin
    col:= MainColor;
    if FAILED(VB.Lock(0, 0, pointer(pVertices), 0)) then Exit;
    for i:=0 to 4 do pVertices^[i].color:=col;
    VB.Unlock;
  end;

  with degV do
  begin
    D3DXMatrixScaling(mScale,dx,dy,1);
    D3DXMatrixTranslation(mTrans,x,y,Zdistance);
    D3DXMatrixRotationZ(mRot, theta*pi/180);
    D3DXMatrixMultiply(mat,mScale,mRot);
    D3DXMatrixMultiply(mat,mat,mTrans);

    res:=DXscreen.IDevice.SetTransform(D3DTS_WORLD, mat);

    DXscreen.Idevice.SetTextureStageState(0, D3DTSS_COLOROP,   D3DTOP_DISABLE);

    res:=DXscreen.IDevice.SetStreamSource(0, VB, 0, SizeOf(TBarVertex));
    res:=DXscreen.IDevice.SetFVF(BarVertexCte);
    res:=DXscreen.IDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, 4 );
  end;

  deg1:=deg;
  DX9end;
end;




{*********************   Méthodes de Tbar   ***************************}

constructor Tbar.create;
  begin
    inherited create;
    deg:=degNul;
    fastMove:=false;
  end;


class function Tbar.STMClassName:AnsiString;
  begin
    STMClassName:='Bar';
  end;



procedure Tbar.store2(var NV:integer;Ax,Ay:float;Const Falloc:boolean=false);
begin
  if Falloc and (NV=0) then getmem(vertices,NvertexTot*sizeof(TbarVertex));

  with vertices^[NV] do
  begin
    x:=Ax;
    y:=Ay;
    z:= 0;
    color:=  CurrentCol;
  end;
  inc(NV);
end;


procedure Tbar.BuildResource;
var
  i,j:integer;
  up: boolean;

  pVertices: Pointer;
  xG,yG:single;
  NV: integer;

begin

  CurrentCol:= MainColor;
  if UseContour and (length(Contour)>0) then
  begin
    BuildContourVertices(true);
  end
  else
  begin
    NvertexTot:=4;
    getmem(vertices,NvertexTot*sizeof(TbarVertex));
    fillchar(vertices^,sizeof(vertices^[0])*4,0);
    with vertices[0] do
    begin
      x:=-0.5;
      y:= 0.5;
      color:= CurrentCol;
      u1:=0;
      v1:=1;
    end;
    with vertices[1] do
    begin
      x:=-0.5;
      y:=-0.5;
      color:= CurrentCol;
      u1:=0;
      v1:=0;
    end;
    with vertices[2] do
    begin
      x:= 0.5;
      y:= 0.5;
      color:= CurrentCol;
      u1:=1;
      v1:=1;
    end;
    with vertices[3] do
    begin
      x:= 0.5;
      y:=-0.5;
      color:= CurrentCol;
      u1:=1;
      v1:=0;
    end;
  end;

  VB:=nil;
  if FAILED(DXscreen.IDevice.CreateVertexBuffer(SizeOf(TBarVertex)*NvertexTot, 0, BarVertexCte, D3DPOOL_DEFAULT, VB, nil)) then Exit;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then Exit;
  CopyMemory(pVertices, @vertices[0], SizeOf(TBarVertex)*NvertexTot);
  VB.Unlock;
  freemem(vertices);
  vertices:=nil;

  DX9end;
end;



procedure Tbar.Blt(const degV: typeDegre);
var
  mat,mTrans, mRot, mScale: TD3DMatrix;
  res:integer;
  pVertices: PbarVertexArray;
  i: integer;
  NV: integer;
begin
  if (@degV=@deg) and ((deg.lum<>deg1.lum) or (BlendAlpha <> BlendAlpha1)) then
  begin
    CurrentCol:= MainColor;
    if FAILED(VB.Lock(0, 0, pointer(pVertices), 0)) then Exit;
    for i:=0 to NvertexTot-1 do pVertices^[i].color:=CurrentCol;
    VB.Unlock;
  end;

  with degV do
  begin
    D3DXMatrixScaling(mScale,dx,dy,1);
    D3DXMatrixTranslation(mTrans,x,y,Zdistance);
    D3DXMatrixRotationZ(mRot, theta*pi/180);
    D3DXMatrixMultiply(mat,mScale,mRot);
    D3DXMatrixMultiply(mat,mat,mTrans);

    res:=DXscreen.IDevice.SetTransform(D3DTS_WORLD, mat);


    DXscreen.Idevice.SetTextureStageState(0, D3DTSS_COLOROP,   D3DTOP_DISABLE);
    DXscreen.Idevice.SetTextureStageState(0, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);

    res:=DXscreen.IDevice.SetStreamSource(0, VB, 0, SizeOf(TBarVertex));
    res:=DXscreen.IDevice.SetFVF(BarVertexCte);
    if UseContour then BltContourVertices
    else res:=DXscreen.IDevice.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, 2 );
  end;

  deg1:=deg;
  BlendAlpha1:=BlendAlpha;
end;



procedure Tbar.buildBMaff;
var
  i:integer;
  pol:typePoly5;
  xc,yc:integer;
begin
  createBMaff;
  pol:=polyAff;
  for i:=1 to 5 do
    begin
      dec(pol[i].x,xminAff);
      dec(pol[i].y,yminAff);
    end;

  xc:=(pol[3].x+pol[4].x) div 2;
  yc:=(pol[3].y+pol[4].y) div 2;

  with BMaff do
  begin
    fill(0);

    {Apparemment, il y a un bug dans DirectX qui fait que la dernière colonne
    n'est pas toujours remplie. D'où les 4 lignes suivantes}

    with BMaff.canvas do
    begin
      pen.style:=psSolid;
      pen.color:=clBlack;
      moveto(width-1,0);
      lineto(width-1,height);

      pen.style:=psSolid;
      pen.color:=clGreen;
      brush.style:=bsSolid;
      brush.color:=clGreen;
      polyline(pol);
      if markedSideVisible and (markedSide<>0) then
        begin
          with pol[markedSide-1] do moveto(x,y);
          with pol[markedSide] do lineto(x,y);
        end;
      pen.color:=clWhite;
      ellipse(xc-3,yc-3,xc+3,yc+3);
    end;
  end;
end;



procedure Tbar.completeLoadInfo;
  begin
    inherited completeLoadInfo;
  end;

procedure Tbar.BuildMaskSingle(mat:Tmatrix);
var
  i,j: integer;
  dib: Tdib;

  // On s'efforce de ne pas utiliser les paramètres poly, XminEx,... qui doivent disparaitre
  polyA:typePoly5;
  XminExA, XmaxExA, YminExA, YmaxExA: integer;
begin
  if not assigned(mat) then exit;

  degToPoly(deg,polyA);

  XminExA:=polyA[1].x;
  XmaxExA:=XminExA;
  YminExA:=polyA[1].y;
  YmaxExA:=YminExA;

  for i:=2 to 4 do
    with polyA[i] do
    begin
      if x>XmaxExA then XmaxExA:=x;
      if x<XminExA then XminExA:=x;
      if y>YmaxExA then YmaxExA:=y;
      if y<YminExA then YminExA:=y;
    end;


  for i:=1 to 5 do
     with polyA[i] do
     begin
       x:=x-XminExA;
       y:=y-YminExA;
     end;

  dib:=Tdib.Create;
  dib.SetSize(XmaxExA-XminExA+1,YmaxExA-YminExA+1,8);
  dib.fill(0);
  with dib.canvas do
  begin
    pen.Color:=    clwhite;
    pen.style:=    psSolid;
    pen.Width:=    1;
    brush.Color:=  clwhite;
    brush.style:=  bsSolid;

    polygon(polyA);
  end;

  {Pas d'inversion }
  mat.initTemp(0,dib.width-1,0,dib.height-1,G_single);
  for i:=0 to XmaxExA-XminExA do
  for j:=0 to YmaxExA-YminExA do
    mat.Zvalue[i,j]:=ord( Dib.Pixels[i,j]<>0);

  dib.Free;


end;

{*********************   Méthodes de Tdisk   ***************************}


constructor Tdisk.create;
begin
  inherited create;

  Nfan:=100;
end;


class function Tdisk.STMClassName:AnsiString;
  begin
    STMClassName:='disk';
  end;


procedure Tdisk.BuildResource;
var
  vertices: array of TbarVertex;
  i,j,col:integer;
  up: boolean;

  pVertices: Pointer;

begin
  col:= MainColor;
  setLength(vertices,NFan+2);

  with vertices[0] do
  begin
    x:= 0;
    y:= 0;
    z:= 0;
    color:= col;
  end;

  for i:=1 to Nfan+1 do
  with vertices[i] do
  begin
    x:= 0.5*cos(2*pi/Nfan*(i-1));
    y:= 0.5*sin(2*pi/Nfan*(i-1));
    z:= 0;
    color:= col;
  end;


  VB:=nil;
  if FAILED(DXscreen.IDevice.CreateVertexBuffer(SizeOf(TBarVertex)*(Nfan+2), 0, BarVertexCte, D3DPOOL_DEFAULT, VB, nil)) then Exit;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then Exit;
  CopyMemory(pVertices, @vertices[0], SizeOf(TBarVertex)*(Nfan+2));
  VB.Unlock;
  DX9end;
end;

procedure Tdisk.Blt(const degV: typeDegre);
var
  mat,mTrans, mRot, mScale: TD3DMatrix;
  res:integer;
  col, i: integer;
  pVertices: PbarVertexArray;
begin
  if (@degV=@deg) and  (deg.lum<>deg1.lum) then
  begin
    col:= MainColor;
    if FAILED(VB.Lock(0, 0, pointer(pVertices), 0)) then Exit;
    for i:=0 to Nfan+1 do pVertices^[i].color:=col;
    VB.Unlock;
  end;

  with degV do
  begin
    D3DXMatrixScaling(mScale,dx,dy,1);
    D3DXMatrixTranslation(mTrans,x,y,Zdistance);
    D3DXMatrixRotationZ(mRot, theta*pi/180);
    D3DXMatrixMultiply(mat,mScale,mRot);
    D3DXMatrixMultiply(mat,mat,mTrans);

    res:=DXscreen.IDevice.SetTransform(D3DTS_WORLD, mat);

    DXscreen.Idevice.SetTextureStageState(0, D3DTSS_COLOROP,   D3DTOP_DISABLE);
    DXscreen.Idevice.SetTextureStageState(0, D3DTSS_ALPHAOP,   D3DTOP_DISABLE);


    res:=DXscreen.IDevice.SetStreamSource(0, VB, 0, SizeOf(TBarVertex));
    res:=DXscreen.IDevice.SetFVF(BarVertexCte);
    res:=DXscreen.IDevice.DrawPrimitive(D3DPT_TRIANGLEFAN, 0, Nfan );
  end;
  DX9end;

  deg1:=deg;
end;


procedure Tdisk.BuildBMaff;
var
  degB:typeDegre;
  x1,x2,y1,y2,i1,i2,j:integer;
  pt1,pt2:array[1..4000] of Tpoint;
  nb:integer;
begin
  createBMaff;

  degB:=deg;
  degB.x:=xaff;
  degB.y:=yaff;
  degB.dx:=degToPixC(deg.dx);
  degB.dy:=degToPixC(deg.dy);


  with BMaff.canvas do
  begin
    BMaff.fill(0);

    {Apparemment, il y a un bug dans DirectX qui fait que la dernière colonne
    n'est pas toujours remplie. D'où les 4 lignes suivantes}

    with BMaff do
    begin
      pen.style:=psSolid;
      pen.color:=clBlack;
      moveto(width-1,0);
      lineto(width-1,height);
    end;

    pen.style:=psSolid;
    pen.color:=clGreen;
    brush.style:=bsSolid;
    brush.color:=clGreen;

    nb:=0;
    for j:=0 to BMaff.height-1 do
      begin
        interDegEllipse(degB,j,i1,i2);
        if (i2>=i1) and (nb<2000) then
          begin
            inc(nb);
            pt1[nb].x:=i1;
            pt1[nb].y:=j;

            pt2[nb].x:=i2;
            pt2[nb].y:=j;
          end;
      end;
    for j:=1 to nb do pt1[nb+j]:=pt2[nb-j+1];
    polygon(slice(pt1,2*nb));
  end;

end;




{************** Méthodes STM  de TvisualObject ***************************}

procedure proTvisualObject_onScreen(b:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    pu.onscreen:=b;
  end;

function fonctionTvisualObject_onScreen(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    fonctionTvisualObject_onScreen:=pu.onScreen;
  end;

procedure proTvisualObject_onControl(b:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    pu.onControl:=b;
  end;

function fonctionTvisualObject_onControl(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    fonctionTvisualObject_onControl:=pu.onControl;
  end;

procedure proTvisualObject_alignOnObject(var p:Tresizable;numO,num:integer;
                                         var pu:TypeUO);
  begin
    verifierObjet(pu);
    verifierObjet(typeUO(p));
    with TvisualObject(pu) do
    begin
      alignOnVisualObject(p,numO,num);
      majPos;
    end;
  end;


procedure proTresizable_lum(ww:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tresizable(pu) do
  if deg.lum<>ww then
    begin
      deg.lum:=ww;
      majPos;
    end;
end;

function fonctionTresizable_lum(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tresizable(pu).deg.lum;
end;


procedure proTresizable_RgbColor(ww:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tresizable(pu) do
  if rgbColor<>ww then
    begin
      rgbColor:=ww;
      majPos;
    end;
end;

function fonctionTresizable_RgbColor(var pu:typeUO): integer;
begin
  verifierObjet(pu);
  result:=Tresizable(pu).RgbColor;
end;

procedure proTresizable_BlendAlpha(ww: float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tresizable(pu) do
  if BlendAlpha<>ww then
    begin
      if ww<0 then ww:=0 else if ww>1 then ww:=1;
      BlendAlpha:=ww;
      majPos;
    end;
end;

function fonctionTresizable_BlendAlpha(var pu:typeUO):float;
begin
  verifierObjet(pu);
  result:=Tresizable(pu).BlendAlpha;
end;


procedure proTresizable_Zdistance(ww: smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tresizable(pu) do
  if Zdistance<>ww then
    begin
      Zdistance:=ww;
      HKpaint.SortThisVisualObject(HKpaint.IndexOf(pu));
      majPos;
    end;
end;

function fonctionTresizable_Zdistance(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  result:=Tresizable(pu).Zdistance;
end;


procedure proTresizable_ControlColor(ww:longint;var pu:typeUO);
var
  old:boolean;
begin
  verifierObjet(pu);
  with Tresizable(pu) do
  begin
    old:=onControl;
    onControl:=false;
    ControlColor:=ww;
    onControl:=old;
  end;
end;

function fonctionTresizable_Controlcolor(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  result:= Tresizable(pu).ControlColor;
end;



procedure proTresizable_x(ww:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tresizable(pu) do
    if deg.x<>ww then
      begin
        deg.x:=ww;
        majPos;
      end;
  end;

function fonctionTresizable_x(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tresizable(pu).deg.x;
  end;

procedure proTresizable_y(ww:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tresizable(pu) do
    if deg.y<>ww then
      begin
        deg.y:=ww;
        majPos;
      end;
  end;

function fonctionTresizable_y(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tresizable(pu).deg.y;
  end;

procedure proTresizable_dx(ww:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    controleParametre(ww,0.00001,1E6);
    with Tresizable(pu) do
    if deg.dx<>ww then
      begin
        deg.dx:=ww;
        majPos;
      end;
  end;

function fonctionTresizable_dx(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTresizable_dx:=Tresizable(pu).deg.dx;
  end;

procedure proTresizable_dy(ww:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    controleParametre(ww,0.00001,1E6);
    with Tresizable(pu) do
    if deg.dy<>ww then
      begin
        deg.dy:=ww;
        majPos;
      end;
  end;

function fonctionTresizable_dy(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTresizable_dy:=Tresizable(pu).deg.dy;
  end;

procedure proTresizable_theta(ww:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with Tresizable(pu) do
    if deg.theta<>ww then
      begin
        deg.theta:=ww;
        majPos;
      end;
  end;

function fonctionTresizable_theta(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTresizable_theta:=Tresizable(pu).deg.theta;
  end;



procedure proTresizable_markedSide(num:integer;var pu:typeUO);
  var
    b:boolean;
  begin
    verifierObjet(pu);
    with Tresizable(pu) do
    begin
      b:=onControl;
      onControl:=false;
      markedSide:=num;
      onControl:=b;
    end;
  end;

function fonctionTresizable_markedSide(var pu:typeUO):integer;
  begin
    verifierObjet(pu);
    with Tresizable(pu) do fonctionTresizable_markedSide:=markedSide;
  end;

procedure proTresizable_markedSideVisible(b:boolean;var pu:typeUO);
  var
    bb:boolean;
  begin
    verifierObjet(pu);
    with Tresizable(pu) do
    begin
      bb:=onControl;
      onControl:=false;
      markedSideVisible:=b;
      onControl:=bb;
    end;
  end;

function fonctionTresizable_markedSideVisible(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    with Tresizable(pu) do
      fonctionTresizable_markedSideVisible:=markedSideVisible;
  end;

procedure proTresizable_setParams(xa,ya,dxa,dya,thetaa,luma:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tresizable(pu),deg do
  begin
    x:=xa;
    y:=ya;
    dx:=dxa;
    dy:=dya;
    theta:=thetaa;
    lum:=luma;
    majpos;
  end;
end;

procedure proTresizable_saveToMat(var mat:Tmatrix;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierMatrice(mat);

  Tresizable(pu).BMtoMat(mat);

end;

procedure proTresizable_Dcolor(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tresizable(pu).Dcolor:=num;
end;

function fonctionTresizable_Dcolor(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= Tresizable(pu).Dcolor;
end;

procedure proTresizable_DlineWidth(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  Tresizable(pu).DlineWidth:=num;
end;

function fonctionTresizable_DlineWidth(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= Tresizable(pu).DlineWidth;
end;

procedure proTresizable_Fmask(b:boolean;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tresizable(pu).Ismask:=b;
  end;

function fonctionTresizable_Fmask(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    result:=Tresizable(pu).Ismask;
  end;

procedure proTresizable_UseContour(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tresizable(pu) do
    begin
      UseContour:=x;
      majpos;
    end;
end;

function fonctionTresizable_UseContour(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tresizable(pu) do result:=UseContour;
end;



procedure proTresizable_RotateContour(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tresizable(pu) do
    begin
      RotateContour:=x;
      majpos;
    end;
end;

function fonctionTresizable_RotateContour(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tresizable(pu) do result:=RotateContour;
end;


procedure proTresizable_MagnifyContour(x:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tresizable(pu) do
    begin
      MagnifyContour:=x;
      majpos;
    end;
end;

function fonctionTresizable_MagnifyContour(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with Tresizable(pu) do result:=MagnifyContour;
end;


procedure proTresizable_SetContour(var plot:TXYplot;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(plot));
  Tresizable(pu).SetContour(plot);
end;

procedure proTresizable_SetContour_1(var plot:TXYplot;mode: integer;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(plot));
  Tresizable(pu).SetContour(plot,D3DPRIMITIVETYPE(mode));
end;


procedure proTresizable_AddMultiDisplay(xA,yA,dxA,dyA,thetaA:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tresizable(pu) do
  begin
    setlength(MultiDeg,length(MultiDeg)+1);
    with MultiDeg[high(MultiDeg)] do
    begin
      x:= xA -deg.x;
      y:= yA -deg.y;
      dx:= dxA;
      dy:= dyA;
      theta:= thetaA -deg.theta;
    end;
  end;
end;

procedure proTresizable_ResetMultiDisplay(var pu:typeUO);
begin
  verifierObjet(pu);
  setLength(Tresizable(pu).MultiDeg, 0);
end;


procedure proTresizable_BlendOpAlpha(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tresizable(pu) do BlendOpAlpha:=num;
end;


function fonctionTresizable_BlendOpAlpha(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tresizable(pu) do result:=BlendOpAlpha;
end;


procedure proTresizable_BlendOp(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tresizable(pu) do BlendOp:=num;
end;


function fonctionTresizable_BlendOp(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tresizable(pu) do result:=BlendOp;
end;


{************** Méthodes STM  de Tbar *****************************}

procedure proTbar_create(var pu:typeUO);
begin
  createPgObject('',pu,Tbar);
end;

procedure proTbar_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,Tbar);
end;



{************** Méthodes STM  de TRF *****************************}

procedure proTRF_create(var pu:typeUO);
begin
  createPgObject('',pu,TRF);
end;


procedure proTRF_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TRF);
end;

{************** Méthodes STM  de Tdisk ********************************}

procedure proTdisk_create(var pu:typeUO);
begin
  createPgObject('',pu,Tdisk);
end;


procedure proTdisk_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,Tdisk);
end;


procedure proTdisk_diameter(ww:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    controleParametre(ww,0.00001,1E6);
    with Tdisk(pu) do
    if (deg.dx<>ww) or (deg.dy<>ww) then
      begin
        deg.dx:=ww;
        deg.dy:=ww;
        majPos;
      end;
  end;

function fonctionTdisk_diameter(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    if Tdisk(pu).deg.dx<Tdisk(pu).deg.dy
      then fonctionTdisk_diameter:=Tdisk(pu).deg.dx
      else fonctionTdisk_diameter:=Tdisk(pu).deg.dy;
  end;

procedure proTdisk_dx(ww:float;var pu:typeUO);
  begin
    proTdisk_diameter(ww,pu);
  end;

function fonctionTdisk_dx(var pu:typeUO):float;
  begin
    fonctionTdisk_dx:=fonctionTdisk_diameter(pu);
  end;

procedure proTdisk_dy(ww:float;var pu:typeUO);
  begin
    proTdisk_diameter(ww,pu);
  end;

function fonctionTdisk_dy(var pu:typeUO):float;
  begin
    fonctionTdisk_dy:=fonctionTdisk_diameter(pu);
  end;



Initialization
AffDebug('Initialization Stmobv0',0);

if TestUnic then
begin
  registerObject(TRF,obvis);
  registerObject(Tbar,obvis);
  registerObject(Tdisk,obvis);



end;

stmTresizable:=Tresizable;



end.
