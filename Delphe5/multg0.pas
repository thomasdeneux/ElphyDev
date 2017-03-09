unit Multg0;

interface

uses
  jpeg, PNGimage,

  Windows, SysUtils,  Messages, Classes, Graphics, Controls,
  math,
  Forms, Dialogs, ExtCtrls, Menus, Printers, ComCtrls, StdCtrls, Buttons,
  clipBrd,

  util1, Gdos,Dgraphic, Dpalette,DdosFich,BMex1,
  editCont,opMulti1,fontEx0,printMG0,
  debug0,
  stmError,Ncdef2,Dtrace1,Dgrad1,
  stmdef,stmObj,
  tbm0,diviwin,
  clock0,thdTimer,
  stmCooX1,
  stmData0,gl,

  {$IFDEF DX11} {$ELSE} DXTypes, Direct3D9G, D3DX9G, {$ENDIF}

  visu0, DibG, formMenu;
  

var
  flagTest:boolean;

var
  E_invalidWin0:integer;
  E_setWorld:integer;
  E_page:integer;
  E_selectWindow:integer;
  E_defineWindow:integer;
  E_defineGrid:integer;
  E_saveJpeg:integer;
  E_divide:integer;

type
  { TsmallRect sert uniquement à la sauvegarde sur disque:
      pour sauver, on crée une structure contenant, pour chaque fenêtre:
        -les coo fenêtre
        -le nombre Nb d'objets contenus dans la fenêtre
        -les Nb pointeurs sur les objets
  }
  TsmallRect=record
               x1,y1,x2,y2:smallint;
               nb:smallInt;
               pu:array[1..10000] of integer; { en fait nb pointeurs }
             end;
  PsmallRect=^TsmallRect;

  TsmallRect1=
             record
               sz:smallint;                   {taille de la partie fixe}
               x1,y1,x2,y2:smallint;
               Flabel:boolean;                {Flabel n'est plus utilisé mais pourrait être contenu }
                                              {dans une vieille config }
             end;

  PsmallRect1=^TsmallRect1;

  TsmallRect2=
             record
             case integer of
               1:(nb:smallInt;
                  pu:array[1..10000] of integer); { en fait nb pointeurs }

               2:(color1,BKcolor1:integer;       {Etait utilisé par les labels}
                  transparent:boolean;
                  DescFont:TFontDescriptor;
                  txt:shortString);
             end;
  PsmallRect2=^TsmallRect2;



  TposWin=array[0..200000] of byte;   // Program de Florian : au moins 40 pages, la limite de 60000 octets insuffisante
  PposWin=^TposWin;


  { Les cadres gèrent la position des fenêtres de Tmultigraph
    Les coordonnées absolues sont les coo quand la fenêtre MG a pour dimensions 10000x10000
    Ces coo sont fixées une fois pour toutes au moment du design.
    Les coo réelles tiennent compte des dimensions vraies de la fenêtre MG
  }
  TcdAlign=(cdAlNone,cdAlTop,cdAlBottom,cdAlLeft,cdAlRight);

  TpageRec=class;

  Tcadre=class
           x1,y1,x2,y2:integer; { Coo. "absolues" de 0 à 10000 }
           rect:Trect;          { Coo. vraies dans la fenêtre actuelle }
           pu:Tlist;            { Liste d'objets utilisateur }
           puRef:Tlist;         { utilisé par retablirReferences, on charge dans
                                  puRef et, après validation, les pointeurs sont
                                  rangés dans pu }
           rb:array[1..4] of Trect; { les 4 bords: ils sont à l'intérieur du }
                                    { grand rectangle }

           dx,dy:integer;       { coo point de capture dans la zone }
           FCvalid:boolean;      { à redessiner sur BM si false }

           Cback:boolean;
           CdAlign:TcdAlign;
           OwnerC: TpageRec;

           procedure init(xa1,ya1,xa2,ya2:integer);   {fixe les coo absolues}
           procedure initRect(w,h:integer);           {calcule les coo réelles basées sur les dim du canvas courant }
           procedure initPos(w,h:integer);            {calcule les coo absolues }
           procedure affiche(canvas:Tcanvas;rr:Trect);{affiche le contour en pointillés}
           procedure setBords;

           function Inside(x,y:integer):integer;
           function setCurseurs(x,y:integer;cont:Tcontrol):boolean;

           function traiteMouseDown(x,y:integer):integer;
           function traiteMouseMove(paintbox:TpaintBox;zonecap:integer;
                     x,y,minX,maxX,minY,maxY:integer):boolean;

           function traiteMouseDblClk(x,y:integer):boolean;

           constructor create(Apage:TpageRec);
           destructor destroy;override;

           function getUO(n:integer):typeUO;
           property UO[n:integer]:typeUO read getUO;
           function UOcount:integer;

           function FirstUO:typeUO;
           function getInsideWindow:Trect;

           procedure setCvalid(w:boolean);
           property Cvalid:boolean read FCvalid write setCvalid;
         end;



  TmultiGform=class;

  TpageRec=class
           private

             function getCadre(w,i:integer):Tcadre; { w=1 or 2 ; i commence à zéro}
           public
             MultiGF:TmultiGform;
             cadreList: array[1..2] of Tlist;    { liste de cadres }
                                  { mai 2013: on introduit une nouvelle liste de fenêtres pouvant se recouvrir
                                   ces fenêtres sont afichées avant les fenêtres normales
                                 }
             BMfen:TbitmapEx;    { bitmap recevant les dessins}

             nbX,nbY: array[1..2] of smallint;   { dimensions de la grille si on a appelé initGrid }

             BKcolorP:integer;   { couleur de fond }
             scaleColorP:integer;{ couleur des échelles }
             fontP:Tfont;        { font pour l'affichage des plots }
             PageFontP:boolean;  { quand PageFontP vaut True }

             showOutLine:boolean; {afficher un rectangle montrant le contour de chaque cadre }
             FshowTitle:boolean;  {afficher les titres}
             FshowNum:boolean;    {afficher les numéros}


             FvisuP:PvisuInfo;
             FuseVparams:boolean;

             FPage2valid:boolean;

             constructor create(mgf:TmultiGform;col:integer);
             destructor destroy;override;

             property cadre[w,i:integer]:Tcadre read getCadre; {l'indice commence à zéro}
             function CadreCount(w:integer):integer;

             procedure resizeBM(forcer:boolean);

             procedure drawBM;
             procedure drawRect(rr:Trect);
             procedure BMpaint(forcer:boolean);
             procedure DrawCursors1;
             procedure updateBM;

             procedure setPageValid(b:boolean);
             function getPageValid:boolean;
            {PageValid est false quand TOUS les cadres sont non valides }
             property PageValid:boolean read getPageValid write setPageValid;
             procedure invalidateP;

             procedure setPage2Valid(b:boolean);
             property Page2Valid:boolean read FPage2Valid write setPage2Valid;



             function initGrid(nx,ny:integer; Wtype:integer):boolean;
             function AddOnGrid(i,j:integer;p:pointer;Wtype:integer;mode2:boolean):boolean;
             function AddObject(n:integer;p:typeUO;Wtype:integer; mode2:boolean):boolean;
             procedure ClearObjects(w:integer;Wtype:integer);
             function GetWin(p:pointer;Wtype:integer):integer;
             function DefineWindow(x1,y1,x2,y2:integer;Wtype:integer;Fback:boolean):integer;

             function DefineGrid(x1,y1,x2,y2,nx,ny:integer;Wtype:integer;back:boolean):integer;
             procedure DestroyAllWindows(NumType:integer);
             procedure SaveAsBMP(st:AnsiString);
             procedure SaveAsPNG(st:AnsiString);
             procedure SaveAsJPEG(st:AnsiString;quality:integer);

             procedure DrawPage(canvas:Tcanvas;w,h:integer);
             procedure SaveAsEmf(stf:AnsiString);

             procedure hardcopy;
             procedure imprimer;

             procedure DivideWindow(num,nbx,nby,Wtype:integer; back:boolean);
             function NewWindow(x,y:integer):integer;
             procedure DestroyWindows(num,nb,Wtype:Integer);

             function getInsideWindow(n,Wtype:integer):Trect;

             function visuP:PvisuInfo;
             function visuFlags:PvisuFlags;
             function UseVparams:boolean;

             procedure assign(rec: TpageRec);
           end;

  TsaveRec=record
             sz:integer;
             nom:string[20];
             nbC:integer;
             nX,nY:smallint;
             BKcolP:integer;
             FontDescP:TfontDescriptor;
             PageFontP:boolean;
             scaleColP:integer;

             showOutLineP:boolean;  // Ajoutés le 4-12-14
             FshowTitleP:boolean;
             FshowNumP:boolean;

             nbC2: integer;         // nombre de cadres du type 2 , ajouté le 10-04-15
           end;
  PsaveRec=^TsaveRec;



  { TMultiGform }

  TMultiGform = class(TForm)
    PopupNew: TPopupMenu;
    Newwindow1: TMenuItem;
    PopupDestroy: TPopupMenu;
    Destroywindow1: TMenuItem;
    Clearwindow1: TMenuItem;
    PopupMain: TPopupMenu;
    Options1: TMenuItem;
    Design1: TMenuItem;
    PaintBox1: TPaintBox;
    Panel1Top: TPanel;
    TabPage1: TTabControl;
    Newpage1: TMenuItem;
    Deletepage1: TMenuItem;
    Bprint: TBitBtn;
    Refresh1: TMenuItem;
    Dividewindow1: TMenuItem;
    CurrentPage1: TMenuItem;
    AllPagesExceptCurrent1: TMenuItem;
    Pages1: TMenuItem;
    MgTools: TMenuItem;
    CreateSimpleMultigraph1: TMenuItem;
    CreateObjectList1: TMenuItem;
    SavePage1: TMenuItem;
    LoadPage1: TMenuItem;
    MultigraphList1: TMenuItem;
    procedure FormPaint(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Design1Click(Sender: TObject);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Newwindow1Click(Sender: TObject);
    procedure Destroywindow1Click(Sender: TObject);
    procedure PaintBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure PaintBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Clearwindow1Click(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure Newpage1Click(Sender: TObject);
    procedure Deletepage1Click(Sender: TObject);
    procedure TabPage1Change(Sender: TObject);
    procedure BprintClick(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure Reset1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Dividewindow1Click(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure TabPage1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure AllPagesExceptCurrent1Click(Sender: TObject);
    procedure Pages1Click(Sender: TObject);
    procedure CreateSimpleMultigraph1Click(Sender: TObject);
    procedure CreateObjectList1Click(Sender: TObject);
    procedure SavePage1Click(Sender: TObject);
    procedure LoadPage1Click(Sender: TObject);
    procedure MultigraphList1Click(Sender: TObject);
  private
    { Déclarations private }

    DesignON:boolean;        { true quand on dessine les cadres }
    zonecap:integer;         { zone capturée }
    rectcap:integer;         { numéro rectangle capturé }
    rectInit:Trect;          { rectangle au moment de la capture }
                             { ou rectangle proposé pour new window }

    ClearRect:Trect;
    minXZ,maxXZ,minYZ,maxYZ:integer; { limites autorisées pendant mousemove }


    thd:TthreadedTimer;
    FlagStatus:boolean;

    FpageList:Tlist; 

    popMainPos:Tpoint;

    //DragSizeMode: boolean;
    //Frestored: boolean;
    PB1deltaW, PB1deltaH: integer;

    procedure DesignMouseDown(Button: TMouseButton;
                   Shift: TShiftState; X, Y: Integer);
    procedure DesignMouseMove( Shift: TShiftState; X,Y: Integer);
    procedure DesignMouseUp(Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);

    procedure designMouseRight(x,y:integer);

    function positionValable(cads:Tlist;n:integer):boolean;
    procedure ChercheMinZmaxZ;

    procedure setValid(page,num,wt:integer;b:boolean);
    function getValid(page,num,wt:integer):boolean;



    { Ces trois messages sont envoyés par une fenêtre encapsulée dans la forme.
      Voir Tdialog dans stmDialog.
    }
    procedure XmouseUp   (var message:Tmessage );message Msg_XmouseUp;
    procedure XmouseDown (var message:Tmessage );message Msg_XmouseDown;
    procedure XmouseMove (var message:Tmessage );message Msg_XmouseMOve;

    procedure setWinCursors(x,y:integer);

  public
    mgOwner:typeUO;      {l'objet multigraph propriétaire }

    VarPg1:TvarPg1;      {contexte d'affichage pour pg1 }


    BKcolorDef:Tcolor;   {couleur de fond par défaut}
    TitleFont:TfontEx;   {fonte des titres}

    mouseDownRight:procedure(numC:integer;Shift: TShiftState;xc,yc,x,y,numCadre:integer) of object;
                         {appelée en cas de click droit dans un cadre design off}
    mouseDownLeft: procedure(numC:integer;Shift: TShiftState;xc,yc,x,y:integer) of object;
                         {appelée en cas de click gauche dans un cadre design off}

    mouseMoveLeft: procedure(x,y:integer) of object;
    mouseUpLeft:   procedure(x,y:integer) of object;

    displayInWindow:procedure (pageRec:TpageRec;numW,numList:integer) of object;
    displayEmpty:procedure (pageRec:TpageRec;numW,numList:integer)  of object;
    displayIn:procedure (p:pointer;extWorld,logX,logY:boolean;
                                  mode,taille:integer) of object;
    setWindowIN:procedure (listU:Tlist) of object;
    dragOver:function(source:Tobject):boolean of object;
    dragDrop:procedure(source:Tobject;num:integer) of object;
    SpecialDragDrop:procedure(firstObj,dest:pointer;x,y:integer) of object;
    libereObjet:procedure(p:pointer) of object;

    CreateSimpleMultigraph: procedure of object;
    CreateObjectList: procedure of object;
    SavePageAsObjectFile: procedure of object;
    LoadPageFromObjectFile: procedure of object;
    getMultigraphList: function: TstringList of Object;


    Fdestroying: boolean;


    IDX9: IDirect3D9;
    Idevice: IDirect3DDevice9;
    MultiSampleType: TD3DMultiSampleType;
    MultiSampleQuality: integer;

    PresentParam: TD3DPresentParameters;
    renderSurface, InterSurface:Idirect3Dsurface9;
    
    FreeResources3D: procedure of object;

    flagPos:boolean;
    MgCaption: AnsiString;

    property valid[page,num,wt:integer]:boolean read getValid write setValid;

    procedure reset;
    procedure selectCadre(page,num,Wtype:integer);
    procedure selectCadreW(num,Wtype:integer);

    function initGrid(page,nx,ny:integer):boolean;
    function AddOnGrid(page,i,j:integer;p:pointer;Wtype:integer; mode2:boolean):boolean;
    function AddObject(page,n:integer;p:typeUO;Wtype:integer; mode2:boolean):boolean;

    procedure clearPage(num:integer);

    function getP(page,n,Wtype:integer):Tlist;  {renvoie pu de la page Page}
    function getPref(page,n,Wtype:integer):Tlist;  {renvoie puRef --}

    function count(page,Wtype:integer):integer; {renvoie le nombre de cadres }
    function CurrentPage:integer;         {0 à N-1}
    function PageCount:integer;           {nb pages }

    function CurPageRec:TpageRec;

    { getPosWin alloue toujours un buffer de taille maximale (60000) et range les
      infos fenêtres dans ce buffer. On renvoie la taille utile dans size.
      setPosWin récupère les infos du buffer et les range dans l'objet multigraph
    }
    procedure getPosWin(var pw:Pposwin;var size:integer);
    procedure setPosWin(pw:Pposwin;size:integer);

    { idem nouvelle version }
    procedure getPosWin1(var pw:Pposwin;var size:integer);
    procedure setPosWin1(pw:Pposwin;size:integer; const numP:integer=-1);

    procedure clearRef;
    procedure initG(canvas:Tcanvas;left,top,width,height:integer);
    procedure initCurrentG;
    procedure BMpaint(NumP:integer;forcer:boolean);
    procedure updateBM;

    procedure ajoutePage(st:AnsiString);
    procedure insertPage(num:integer;st:AnsiString);

    function selectPage(num:integer):boolean;
    procedure deletePage(num:integer);
    procedure deleteAllPages;

    procedure copyTo(stf:AnsiString);
    procedure copyToClipBoard;

    procedure PositionnePrinter(var Pleft,Ptop,Pwidth,Pheight:integer);
    procedure imprimer;
    procedure HardCopy;
    procedure saveToFile;

    procedure invalidateRect1(rect:Trect);
    procedure invaliderCadre(num:integer);
    procedure invalidateBorders(num:integer);
    procedure RepaintBorders(num:integer);

    procedure setCadre0;             {appelé avant chaque opération pg1}
    procedure setFenetre0;
    procedure resetFenetre0;         {appelé après chaque opération pg1}

    procedure InvaliderFenetre0;

    procedure Pg1Droite(a,b:float);
    procedure Pg1Line(x1,y1,x2,y2:float);
    procedure Pg1lineTo(x,y:float);
    procedure Pg1moveto(x,y:float);
    procedure Pg1LineVer(x0:float);
    procedure Pg1LineHor(y0:float);

    procedure Pg1setWindow(num:integer);
    function Pg1getWindow:integer;

    procedure Pg1selectWindow(p:pointer);
    procedure Pg1setWindowEx(x1,y1,x2,y2:integer);
    procedure Pg1getWindowEx(var x1,y1,x2,y2:Integer);

    procedure Pg1setWorld(x1,y1,x2,y2:float);
    procedure Pg1setXWorld(x1,y1,x2:float;Fup:boolean);

    procedure Pg1getWorld(var x1,y1,x2,y2:float);
    procedure Pg1clearWindow(tout:boolean);
    procedure Pg1DrawBorder;
    procedure Pg1DrawBorderOut;

    procedure VSrectangle(x,y,dx,dy,theta:float);

    procedure Pg1OutText(x,y:integer;st:AnsiString);
    procedure Pg1OutTextW(x,y:integer;st:AnsiString);
    procedure Pg1SetTextStyle(font,dir,charSize:integer);
    procedure Pg1SetClippingON;
    procedure Pg1SetClippingOff;

    procedure Pg1Graduations(stX,stY:AnsiString;echX,echY:boolean);
    procedure Pg1AfficherSymbole(x,y:float;numSymb,taille:integer);

    procedure Pg1clearScreen;
    procedure Pg1resetScreen;
    function Pg1GetWin(p:pointer):integer;

    function getRect(p:pointer;var numFen,numOrdre:integer;var firstPlot:typeUO):Trect;

    procedure Pg1DisplayObject(p:pointer);
    function Pg1ClearObjects(page,w:integer):boolean;

    procedure Pg1gotoxy(x,y:integer);
    procedure Pg1gotoxyW(x,y:integer);
    procedure Pg1write(st:AnsiString);
    procedure Pg1writeln(st:AnsiString);

    function pg1WinCount(page:integer):integer;



    procedure pg1SavePage(num:integer;st:AnsiString);
    procedure pg1SavePageAsJpeg(num:integer;st:AnsiString;quality:integer);
    procedure pg1SavePageAsPNG(num:integer;st:AnsiString);

    procedure Savewin(win:integer;st:AnsiString;jpeg:boolean;Wtype:integer);



    procedure RemoveObject(numCadre,numObj:integer);
    procedure libereObjets(pu:Tlist);
    procedure removeFromWin(sender:Tobject);

    procedure BringObjectToFront(numCadre,numObj:integer);
    procedure BringToFront(sender:Tobject);

    function getBM:TbitmapEx;
    procedure drawBM;
    procedure drawRect(page:integer;rr:Trect);
    procedure drawCursors1(numP:integer);
    procedure posDialogs;
    procedure printDialogs;
    procedure UpdateBMs;

    procedure invalidate;override;
    {on réécrit invalidate pour ne pas avoir un effacement systématique
     avant l'affichage}

    procedure controlePage(page:integer);
    procedure controlePageWin(page,win:integer);

    function getCadre(num:integer):Trect;

    function getPageRec(num:integer):TpageRec;
    function getPageIndex(st:AnsiString):integer;


    property pageRec[num:integer]:TpageRec read getPageRec;  {l'indice commence à zéro}

    procedure PosDlg(p:typeUO;rect:Trect;IsVisible:boolean);
    procedure PrintDlg(bm:TbitmapEx;p:typeUO;rect:Trect);
    function getUO(page,cadre,num,Wtype:integer):typeUO;

    procedure Pg1GetWindowPos(page,win:integer;var xx1,yy1,xx2,yy2:integer);

    property PageList: Tlist read FpageList;


    function InitDX9: boolean;
    function InitDevice: boolean;
    procedure SetDeviceParams;

    function TestDevice: boolean;
    
    {
    procedure MessageEnterSizeMove(var message:Tmessage);message wm_EnterSizeMove;
    procedure ExitEnterSizeMove(var message:Tmessage);message wm_ExitSizeMove;

    procedure MessageWPchanging(var message:Tmessage);message wm_sizing;
    procedure MessageWPchanged(var message:Tmessage);message wm_size;
    
    procedure MessageWmSize(var message: Tmessage);message wm_size;
    }
    procedure MessagePosDlg(var message:Tmessage);message  msg_PosDialogs;
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

uses stmPlot1;

{*********************  Méthodes de Tcadre ********************************}

constructor Tcadre.create(Apage: TpageRec);
begin
  OwnerC:=Apage;
  inherited create;
end;

destructor Tcadre.destroy;
begin
  pu.free;
  puRef.free;
end;

procedure Tcadre.init(xa1,ya1,xa2,ya2:integer);
begin
  x1:=xa1;
  x2:=xa2;
  y1:=ya1;
  y2:=ya2;
end;

procedure Tcadre.initRect(w,h:integer);
var
  Hrect,Lrect:integer;
begin
  with rect do
  begin
    Hrect:=bottom-top;
    Lrect:=left-right;
  end;
  case cdAlign of
    cdAlNone:   begin
                  rect.left:=roundI(x1*w/10000);
                  rect.right:=roundI(x2*w/10000);
                  rect.top:=roundI(y1*h/10000);
                  rect.bottom:=roundI(y2*h/10000);
                end;

    cdAlTop:    begin
                  rect.left:=roundI(x1*w/10000);
                  rect.right:=roundI(x2*w/10000);
                  rect.top:=roundI(y1*h/10000);
                  rect.Bottom:=rect.top+Hrect;
                end;

    cdAlBottom: begin
                  rect.left:=roundI(x1*w/10000);
                  rect.right:=roundI(x2*w/10000);
                  rect.bottom:=roundI(y2*h/10000);
                  rect.top:=rect.Bottom-Hrect;
                end;

    cdAlLeft:   begin
                  rect.top:=roundI(y1*h/10000);
                  rect.bottom:=roundI(y2*h/10000);

                  rect.left:=roundI(x1*w/10000);
                  rect.right:=rect.Left+Lrect;
                end;

    cdAlRight:  begin
                  rect.top:=roundI(y1*h/10000);
                  rect.bottom:=roundI(y2*h/10000);
                  rect.right:=roundI(x2*w/10000);
                  rect.left:=rect.Right-Lrect;
                end;

  end;
  setBords;
end;

procedure Tcadre.initPos(w,h:integer);
begin
  x1:=roundI(rect.left*10000/w);
  x2:=roundI(rect.right*10000/w);
  y1:=roundI(rect.top*10000/h);
  y2:=roundI(rect.bottom*10000/h);
  setBords;
end;


procedure Tcadre.affiche(canvas:Tcanvas;rr:Trect);
begin
  with canvas do
  begin
    pen.mode:=pmNotXor;
    pen.color:=clBlack;
    pen.style:=psDot;
    pen.width:=1;
    brush.style:=bsClear;

    with rr do rectangle(left+2,top+2,right-1,bottom-1);

    pen.mode:=pmCopy;
    pen.style:=psSolid;
    pen.width:=1;
    brush.style:=bsSolid;
  end;
end;

procedure Tcadre.setBords;
  const
    pix=5;
  var
    i:integer;
  begin
    for i:=1 to 4 do rb[i]:=rect;
    rb[1].top:=rect.top;
    rb[1].bottom:=rect.top+pix;

    rb[2].left:=rect.right-pix;
    rb[2].right:=rect.right;

    rb[3].top:=rect.bottom-pix;
    rb[3].bottom:=rect.bottom;

    rb[4].left:=rect.left;
    rb[4].right:=rect.left+pix;

  end;


function Tcadre.setCurseurs(x,y:integer;cont:Tcontrol):boolean;
  begin
    setCurseurs:=true;
    case inside(x,y) of
      1,3: cont.cursor:=crSizeNS;
      2,4: cont.cursor:=crSizeWE;
      5:   cont.cursor:=crSize;
      else setCurseurs:=false;
    end;
  end;

function Tcadre.Inside(x,y:integer):integer;
  var
    p:Tpoint;
    i:integer;
  begin
    p.x:=x;
    p.y:=y;

    for i:=1 to 4 do
      if PtInRect(rb[i],p) then
        begin
          inside:=i;
          exit;
        end;
    if PtInRect(rect,p) then inside:=5
    else
    inside:=0;
  end;

function Tcadre.traiteMouseDown(x,y:integer):integer;
  var
    zonecap:integer;
  begin
    zoneCap:=inside(x,y);
    if zonecap>0  then
      begin
        if zoneCap=5 then
          begin
            dx:=x-rect.left;
            dy:=y-rect.top;
          end
        else
          begin
            dx:=x-rb[zoneCap].left;
            dy:=y-rb[zoneCap].top;
          end;

      end;
    traiteMouseDown:=zonecap;
  end;

function Tcadre.traiteMouseMove(paintBox:TpaintBox;zonecap:integer;
         x,y,minX,maxX,minY,maxY:integer):boolean;
  var
    l,h:integer;
    oldRect:Trect;
  begin
    if zoneCap<>0 then
      begin

        oldRect:=rect;

        x:=x-dx;
        y:=y-dy;

        if x<minX then x:=minX else if x>maxX then x:=maxX;
        if y<minY then y:=minY else if y>maxY then y:=maxY;

        case zonecap of
          1:rect.top:=y;
          2:rect.right:=x;
          3:rect.bottom:=y;
          4:rect.left:=x;
          5:begin
              l:=rect.right-rect.left;
              h:=rect.bottom-rect.top;

              rect.left:=x;
              rect.right:=rect.left+l;

              rect.top:=y;
              rect.bottom:=rect.top+h;
            end;
        end;

        if not compareMem(@rect,@oldRect,sizeof(rect)) then
          begin
            affiche(paintBox.canvas,oldRect);
            affiche(paintBox.canvas,Rect);
          end;

        traiteMouseMove:=true;
      end
    else
    traiteMouseMove:=setCurseurs(x,y,paintBox);
  end;


function Tcadre.traiteMouseDblClk(x,y:integer):boolean;
  begin
    traiteMouseDblClk:=(inside(x,y)=5);
  end;

function Tcadre.getUO(n:integer):typeUO;
begin
  if assigned(pu) and (n<pu.count)
    then result:=pu[n]
    else result:=nil;
end;

function Tcadre.UOcount:integer;
begin
  if assigned(pu)
    then result:=pu.Count
    else result:=0;
end;

function Tcadre.FirstUO:typeUO;
var
  i:integer;
begin
  result:=nil;
  for i:=0 to UOcount-1 do
    if uo[i].withInside then
      begin
        result:=uo[i];
        exit;
      end;
end;

function Tcadre.getInsideWindow: Trect;
var
  p:typeUO;
begin
  p:=FirstUO;
  if assigned(p) then
    begin
      with rect do setWindow(left,top,right,bottom);
      with ownerC do
      begin
        if pageFontP then p.swapFont(FontP,scaleColorP);           { Attention, devient différent de p.getInsideWindow }
        if UseVparams then p.swapVisu(visuP,visuFlags);
      end;
      try
        result:=p.getInsideWindow;
      finally
      with ownerC do
      begin
        if pageFontP then p.swapFont(FontP,scaleColorP);
        if UseVparams then p.swapVisu(visuP,visuFlags);
      end;
      end;
    end
  else result:=rect;
end;

procedure Tcadre.SetCvalid(w:boolean);
begin
  FCvalid:=w;
  if not w then ownerC.Page2valid:=false;
end;


{******************  Méthodes de TpageRec ********************************}

constructor TpageRec.create(mgf:TmultiGform;col:integer);
begin
  multiGF:=mgf;
  BKcolorP:=col;
  BMfen:=TbitmapEx.create;
  initGraphic(BMfen);
  clearWindow(BKcolorP);
  doneGraphic;

  fontP:=Tfont.create;


  cadreList[1]:=Tlist.create;
  cadreList[2]:=Tlist.create;

  Page2valid:=true;
end;

destructor TpageRec.destroy;
var
  i,j:integer;
begin
  for j:=1 to 2 do
  begin
    for i:=0 to cadreList[j].count-1 do
      Tcadre(cadreList[j][i]).free;
    cadreList[j].free;
  end;

  BMfen.free;
  fontP.free;

  if assigned(FvisuP) then
  begin
    FvisuP^.done;
    dispose(FvisuP);
    FvisuP:=nil;
  end;


end;

function TpageRec.getCadre(w,i:integer):Tcadre;
begin
  result:=Tcadre(cadreList[w][i]);
end;

function TpageRec.CadreCount(w:integer):integer;
begin
  result:=cadreList[w].count;
end;


procedure TpageRec.resizeBM(forcer:boolean);
var
  i,w:integer;
begin
  if  forcer or (BMfen.width<>MultiGF.paintbox1.width) or
      (BMfen.height<>MultiGF.paintbox1.height)  then
    begin
      BMfen.width:=MultiGF.paintbox1.width;
      BMfen.height:=MultiGF.paintbox1.height;

      for w:= 1 to 2 do
      begin
        for i:=0 to Cadrecount(w)-1 do
          with cadre[w,i] do
          begin
            initRect(MultiGF.paintBox1.width,MultiGF.paintBox1.height);
            Cvalid:=false;
          end;
      end;
    end;
end;


procedure TpageRec.drawBM;
begin
  MultiGF.paintbox1.canvas.draw(0,0,BMfen);
end;

procedure TpageRec.drawRect(rr:Trect);
begin
  // MultiGF.paintbox1.Canvas.CopyRect(rr, BMfen.Canvas,rr);
  BMfen.CopyRectTo(MultiGF.paintbox1.Canvas,rr);
end;

procedure TpageRec.BMpaint(forcer:boolean);
var
  i:integer;
  kW:integer;
  Fpaint2: boolean;

begin
  TRY

  if BMfen=nil then exit;

  BMfen.restoreRects;

  initGraphic(BMfen);
  multiGF.varPg1.canvasPg1:=BMfen.Canvas;

  if forcer or not pageValid or not page2valid then clearWindow(BKcolorP);
  with multiGF.clearRect do
  if left<right then
  begin
    setWindow(left,top,right,bottom);
    clearWindow(BKcolorP);
    right:=left;
  end;
    {canvasGlb.font.assign(font);
    canvasGlb.brush.color:=BKcolorP; }

  Fpaint2:= forcer or not page2Valid;
  if CadreCount(2)>0 then
  begin
    if not Fpaint2 then
    for i:=0 to CadreCount(1)-1 do
      with cadre[1,i] do
         if not Cvalid then Fpaint2:=true;

    if Fpaint2 then
    for i:=0 to CadreCount(2)-1 do
    with cadre[2,i] do
      if Cback then
        begin
          with rect do setWindow(left,top,right,bottom);
          if assigned(multiGF.DisplayInWindow) then multiGF.displayInWindow(self,i,2);
        end;
  end;

  for i:=0 to CadreCount(1)-1 do
    begin
      with cadre[1,i] do
      begin
        if forcer or not Cvalid or Fpaint2 then
        begin
          with rect do setWindow(left,top,right,bottom);

          with canvasGlb do
          begin
            pen.color:=BKcolorP;
            pen.style:=psSolid;
            brush.color:=BKcolorP;
            brush.style:=bsSolid;

            if cadreCount(2)=0 then rectangle(x1act,y1act,x2act+1,y2act+1);
          end;
          if multiGF.curpageRec.showOutline then drawBorder(clGray);

          if assigned(multiGF.DisplayInWindow) then multiGF.displayInWindow(self,i,1);
          Cvalid:=true;
        end;
      end;
    end;
  //if cadreCount>0 then mainWindow;

  if forcer or not pageValid or not page2valid then
  for i:=0 to CadreCount(2)-1 do
  with cadre[2,i] do
    if not Cback then
      begin
        with rect do setWindow(left,top,right,bottom);
        if assigned(multiGF.DisplayInWindow) then multiGF.displayInWindow(self,i,2);
      end;

  page2valid:=true;
  FINALLY
  doneGraphic;
  END;
end;

procedure TPageRec.drawCursors1;
var
  i,j:integer;
begin
  if BMfen=nil then exit;

  with BMfen do
  begin
    clearRects;
    initGraphic(BMfen);

    for i:=0 to cadreCount(1)-1 do
      with cadre[1,i] do
      begin
        if assigned(pu) and (pu.count>0) then
          begin
            with getInsideWindow do Dgraphic.setWindow(left,top,right,bottom);
            for j:=0 to pu.count-1 do TypeUO(pu[j]).DisplayCursors(BMfen);
          end;
      end;
    doneGraphic;
  end;
end;

procedure TPageRec.UpdateBM;
begin
   resizeBM(false);
   BMpaint(false);
   DrawCursors1;
end;

procedure TpageRec.setPageValid(b:boolean);
var
  i:integer;
begin
  for i:=0 to cadrecount(1)-1 do
    cadre[1,i].Cvalid:=b;
end;

function TpageRec.getPageValid:boolean;
var
  i:integer;
begin
  result:=false;
  for i:=0 to cadrecount(1)-1 do
    if cadre[1,i].Cvalid then
      begin
        result:=true;
        exit;
      end;
end;

procedure TpageRec.setPage2Valid(b:boolean);
begin
  if not b and (cadreCount(2)>0)
    then Fpage2valid:=false
    else Fpage2valid:=true;
end;

procedure TpageRec.invalidateP;
begin
  with multigf do
  if curPageRec=self then invalidate;
end;

function TpageRec.initGrid(nx,ny:integer;Wtype:integer):boolean;
var
  i,j:integer;
  dx,dy:float;
  cd:Tcadre;
begin
  result:=false;
  if (nx<=0) or (ny<=0) then sortieErreur('TMGpage.initGrid : bad parameter');

  for i:=0 to cadreCount(Wtype)-1 do
    with cadre[Wtype,i] do
    begin
      multiGF.libereObjets(pu);
      free;
    end;
  cadreList[Wtype].clear;

  nbX[Wtype]:=nx;
  nbY[Wtype]:=ny;

  dx:=10000/nx;
  dy:=10000/ny;

  for j:=1 to ny do
    for i:=1 to nx do
      begin
        cd:=Tcadre.create(self);
        CadreList[Wtype].add(cd);
        cd.init(truncI(dx*(i-1)),truncI(dy*(j-1)),
                truncI(dx*i)-1, truncI(dy*j)-1);
        cd.initRect(multiGF.paintBox1.width,multiGF.paintBox1.height);
      end;

  pageValid:=false;
  invalidateP;

  result:=true;
end;

function TpageRec.AddOnGrid(i,j:integer;p:pointer;Wtype:integer;mode2:boolean):boolean;
var
  n:integer;
begin
  result:=false;
  if (i<1) or (i>nbX[Wtype]) or (j<1) or (j>nby[Wtype])
    then sortieErreur('TMGpage.addOnGrid : bad grid position');

  n:=(j-1)*nbX[Wtype]+i-1;
  if n<cadreCount(Wtype) then result:=addObject(n,p,Wtype,mode2);
end;

{AddObject renvoie true si l'objet a été ajouté dans la liste pu
 Quand AddObject renvoie false:
   - ou bien la page ou le cadre n'était pas valable
   - ou bien l'objet existait déjà dans le cadre
}

function TpageRec.AddObject(n:integer;p:typeUO;Wtype:integer; mode2:boolean):boolean;
// n= NumCadre commence à 0
// uo
// Wtype=1 ou 2
// mode2 utilisé par certains objets
begin
  result:=false;
  if (n<0) or (n>=cadreCount(Wtype)) then sortieErreur('TMGpage.addObject : bad window number');

  with cadre[Wtype,n] do
  begin
    if not assigned(pu) then pu:=Tlist.create;

    if not mode2 and (p is Tplot) then
    begin                               { cas des Tplot }
      if assigned(uo[0]) and  UO[0].Embedded then exit;
      if pu.indexof(p)<0 then
      begin
        pu.add(p);
        Cvalid:=false;
        Result:=true;
        multiGF.invalidateRect1(rect);
      end;
    end
    else
    begin
      p.Embedded:=true;
      if p.Embedded then
      begin
        if pu.count>0 then exit;
        pu.add(p);
        Result:=true;
        {multiGF.PosDlg(p,rect,false );}
        multiGF.invalidateRect1(rect);
      end
    end;
  end;
end;

procedure TpageRec.ClearObjects(w:integer;Wtype:integer);
begin
  if (w<0) or (w>=cadreCount(Wtype))
    then sortieErreur('TmgPage.ClearObjects : invalid window number');

  with cadre[Wtype,w] do
  begin
    multiGF.libereObjets(pu);
    pu.free;
    pu:=nil;
    Cvalid:=false;
  end;
end;

function TpageRec.GetWin(p:pointer;Wtype:integer):integer;
var
  i,j:integer;
begin
  for i:=0 to cadrecount(Wtype)-1 do
    with cadre[Wtype,i] do
      if assigned(pu) then
        for j:=0 to pu.count-1 do
          if pu.items[j]=p then
            begin
              result:=i+1;
              exit;
            end;
  result:=0;
end;

function TpageRec.DefineWindow(x1,y1,x2,y2:integer;Wtype:integer;Fback:boolean):integer;
var
  cd:Tcadre;
begin
  result:=0;
  if (x1<0) or (x2<=x1) or (x2>multiGF.paintbox1.width)
     or
     (y1<0) or (y2<=y1) or (y2>multiGF.paintbox1.height)
    then exit; //sortieErreur('TmgPage.defineWindow : invalid parameters');

  cd:=Tcadre.create(self);
  CadreList[Wtype].add(cd);
  cd.rect:=rect(x1,y1,x2,y2);
  if (Wtype=1) and  not multiGF.positionvalable(cadreList[1],cadrecount(1)-1) then
    begin
      cadreList[1].remove(cd);
      exit;
      //sortieErreur('TmgPage.defineWindow : invalid parameters');
    end;

  result:=cadreCount(Wtype);
  cd.initPos(multiGF.paintbox1.width,multiGF.paintbox1.height);
  cd.Cback:=Fback;

  pageValid:=false;
  invalidateP;
end;


function TpageRec.DefineGrid(x1,y1,x2,y2,nx,ny:integer;Wtype:integer;back:boolean):integer;
var
  i,j:integer;
  dx,dy:float;
  cd:Tcadre;
begin
  if (x1<0) or (x2<=x1) or (x2>multiGF.paintbox1.width)
     or
     (y1<0) or (y2<=y1) or (y2>multiGF.paintbox1.height)
    then sortieErreur('TmgPage.defineGrid : invalid window position');

  result:=0;

  cd:=Tcadre.create(self);
  CadreList[Wtype].add(cd);
  cd.rect:=rect(x1,y1,x2,y2);
  if (Wtype=1) and not multiGF.positionvalable(cadreList[1],cadrecount(1)-1) then
    begin
      cadreList[1].remove(cd);
      sortieErreur('TmgPage.defineGrid : invalid window position');
    end;

  result:=cadrecount(Wtype);

  cadreList[Wtype].remove(cd);
  dx:=(x2-x1)/nx;
  dy:=(y2-y1)/ny;
  if (dx<=1) or (dy<=1) then sortieErreur('TmgPage.defineGrid : invalid window position');

  for j:=1 to ny do
    for i:=1 to nx do
      begin
        cd:=Tcadre.create(self);
        cd.Cback:= back;
        CadreList[Wtype].add(cd);
        cd.rect:=rect(x1+truncI(dx*(i-1)),y1+truncI(dy*(j-1)),
                      x1+truncI(dx*i)-1, y1+truncI(dy*j)-1);
        cd.initPos(multiGF.paintbox1.width,multiGF.paintbox1.height);
      end;


  pageValid:=false;
  invalidateP;

end;

procedure TpageRec.DestroyAllWindows(NumType:integer);
var
  i:integer;
begin
  if NumType in [0,1] then
  begin
    for i:=0 to cadrecount(1)-1 do
      with cadre[1,i] do
      begin
        multiGF.libereObjets(pu);
        free;
        cadreList[1][i]:=nil;
      end;
    cadreList[1].pack;
    nbx[1]:=0;
    nby[1]:=0;
  end;

  if NumType in [0,2] then
  begin
    for i:=0 to cadrecount(2)-1 do
      with cadre[2,i] do
      begin
        multiGF.libereObjets(pu);
        free;
        cadreList[2][i]:=nil;
      end;
    cadreList[2].pack;
    nbx[2]:=0;
    nby[2]:=0;
  end;

  pageValid:=false;
  invalidateP;
end;

procedure TpageRec.SaveAsBMP(st:AnsiString);
begin
  updateBM;
  try
    bmfen.saveToFile(st);
  except
    sortieErreur('TmgPage.saveAsBMP : unable to save '+st);
  end;
end;

procedure TpageRec.SaveAsJpeg(st:AnsiString;quality:integer);
var
  hh:Thandle;
  jp:TjpegImage;
  bm0:Tbitmap;
begin
  updateBM;
  try
  try
    bm0:=Tbitmap.create;
    begin
      bm0.height:=bmfen.Height;
      bm0.width:=bmfen.width;
      bm0.canvas.draw(0,0,bmfen);
    end;
    jp:=TjpegImage.create;
    jp.assign(bm0);
    jp.compressionQuality:=quality;
    jp.saveToFile(st);
  finally
    jp.free;
    bm0.Free;
  end;
  except
    sortieErreur(E_saveJpeg);
  end;
end;

procedure TpageRec.SaveAsPNG(st:AnsiString);
{$IFDEF FPC}
type
  TpngObject = TPortableNetworkGraphic;
{$ENDIF}
var
  hh:Thandle;
  png:TpngObject;
  bm0:Tbitmap;
begin
  updateBM;
  try
  try
    bm0:=Tbitmap.create;
    begin
      bm0.height:=bmfen.Height;
      bm0.width:=bmfen.width;
      bm0.canvas.draw(0,0,bmfen);
    end;

    PNG := TPNGObject.Create;
    PNG.Assign(bm0);    //Convert data into png
    PNG.SaveToFile(st);
  finally
    PNG.free;
    bm0.Free;
  end;
  except
    sortieErreur('Error saving PNG file');
  end;
end;

procedure TPageRec.DrawPage(canvas:Tcanvas;w,h:integer);
var
  i,j:integer;
  colBK:integer;
begin
{
  with canvas do
  begin
    pen.Color:=clRed;
    rectangle(10,10,900,500);
    exit;
  end;
 }
  if PRWhiteBackGnd or PRmonochrome
    then colBK:=clwhite
    else colBK:=BKcolorP;

  with Canvas do
  begin
    multiGF.initG(canvas,0,0,w,h);
    clearWindow(colBK);

    canvas.font.assign(font);
    canvas.brush.color:=colBK;

    for i:=0 to Cadrecount(2)-1 do
      begin
        with cadre[2,i] do
        if Cback then
        begin
          initRect(w,h);
          with rect do setWindow(left,top,right,bottom);
          clearWindow(colBK);
          if multiGF.curpageRec.showOutline then drawBorder(clGray);

          if assigned(multiGF.DisplayInWindow) then multiGF.displayInWindow(self,i,2);
          initRect(BMfen.width,BMfen.height);
        end;
      end;


    for i:=0 to Cadrecount(1)-1 do
      begin
        with cadre[1,i] do
        begin
          initRect(w,h);
          with rect do setWindow(left,top,right,bottom);
          clearWindow(colBK);
          if multiGF.curpageRec.showOutline then drawBorder(clGray);

          if assigned(multiGF.DisplayInWindow) then multiGF.displayInWindow(self,i,1);
          initRect(BMfen.width,BMfen.height);
        end;
      end;

    for i:=0 to CadreCount(1)-1 do
      with cadre[1,i] do
      begin
        if assigned(pu) then
          begin
            initRect(w,h);

            with getInsideWindow do Dgraphic.setWindow(left,top,right,bottom);
            for j:=0 to pu.count-1 do TypeUO(pu[j]).DisplayCursors(nil);

            initRect(BMfen.width,BMfen.height);
          end;
      end;

    for i:=0 to Cadrecount(2)-1 do
      begin
        with cadre[2,i] do
        if not Cback then
        begin
          initRect(w,h);
          with rect do setWindow(left,top,right,bottom);
          clearWindow(colBK);
          if multiGF.curpageRec.showOutline then drawBorder(clGray);

          if assigned(multiGF.DisplayInWindow) then multiGF.displayInWindow(self,i,2);
          initRect(BMfen.width,BMfen.height);
        end;
      end;

  end;

  doneGraphic;
end;

procedure CopyMetaToClipBoard(MetaFileHandle: Thandle);
var
  Data: THandle;
  Format: Word;
begin
  OpenClipboard(FormStm.handle);
  try
    EmptyClipboard;

    Format := CF_ENHMETAFILE;
    Data := CopyEnhMetaFile(MetaFileHandle, nil);
    SetClipboardData(Format, Data);

  finally
    CloseClipboard;
  end;
end;


procedure TpageRec.SaveAsEmf(stf:AnsiString);
var
  meta:TMetaFile;
  metaCanvas:TMetafileCanvas;
  w,h:integer;
begin
  PRmetaFile:=true;
  Meta:= TMetafile.Create;
  try
    w:=printer.pageWidth;
    h:=roundL (w*BMfen.height/BMfen.width);
    meta.width:=w;
    meta.height:=h;
    metaCanvas:=TMetafileCanvas.Create(Meta, printer.Canvas.handle);      // à vérifier

    PRprinting:=true;

    PRfactor:=w/Bmfen.width;
    if PRautoSymb then PRsymbMag:=PRfactor;

    if (PRsymbMag<1) or (PRsymbMag>20) then PRsymbMag:=1;

    if PRautoFont then PRfontmag:=PRfactor;
    if (PRfontMag<0.2) or (PRfontMag>50) then PRfontMag:=1;

  except
    w:=BMfen.width;
    h:=BMfen.height;
    meta.width:=w;
    meta.height:=h;
    metaCanvas:=TMetafileCanvas.Create(Meta, BMfen.canvas.handle);

    PRprinting:=false;
  end;

  try
    drawPage(metaCanvas,w,h);
  finally
    metaCanvas.Free;
    PRprinting:=false;
    PRmetaFile:=false;
  end;

  meta.enhanced:=true;

  if stf=''
    then clipboard.assign(meta)
    else meta.saveToFile(stF);
  meta.free;

end;


procedure TpageRec.imprimer;
var
  colBK:Tcolor;
  i,j:integer;
  Ptop,Pleft,Pwidth,Pheight:integer;
begin
  updateBM;
  if PRWhiteBackGnd or PRmonochrome
    then colBK:=clwhite
    else colBK:=BKcolorP;

  if PRLandscape
    then printer.orientation:=poLandscape
    else printer.orientation:=poPortrait;

  printer.beginDoc;
  multiGF.positionnePrinter(Pleft,Ptop,Pwidth,Pheight);

  PRprinting:=true;

  with printer do multiGF.initG(canvas,0,0,printer.PageWidth,printer.PageHeight);
  with canvasGlb do
  begin
    pen.style:=psSolid;
    pen.mode:=pmCopy;
  end;

  if PRautoSymb then PRsymbMag:=PRfactor;
  if (PRsymbMag<1) or (PRsymbMag>20) then PRsymbMag:=1;

  if PRautoFont then PRFontMAg:=1;
  if (PRfontMag<0.2) or (PRfontMag>50) then PRfontMag:=1;

  canvasGlb.brush.color:=colBK;

  if colBK<>clWhite then clearWindow(colBK);

  for i:=0 to Cadrecount(2)-1 do
    with cadre[2,i] do
    if Cback then
      begin
        initRect(Pwidth,Pheight);
        with rect do setWindow(Pleft+left,Ptop+top,Pleft+right,Ptop+bottom);
        if multiGF.curpageRec.showOutline then drawBorder(clGray);

        if assigned(multiGF.DisplayInWindow) then multiGF.displayInWindow(self,i,1);
        initRect(multiGF.paintbox1.width,multiGF.paintbox1.height);
      end;


  for i:=0 to Cadrecount(1)-1 do
    with cadre[1,i] do
      begin
        initRect(Pwidth,Pheight);
        with rect do setWindow(Pleft+left,Ptop+top,Pleft+right,Ptop+bottom);
        if multiGF.curpageRec.showOutline then drawBorder(clGray);

        if assigned(multiGF.DisplayInWindow) then multiGF.displayInWindow(self,i,1);
        initRect(multiGF.paintbox1.width,multiGF.paintbox1.height);
      end;

  for i:=0 to CadreCount(1)-1 do
    with cadre[1,i] do
    begin
      if assigned(pu) then
        begin
          initRect(Pwidth,Pheight);
          {
          with cadre[i].rect do
            Dgraphic.setWindow(Pleft+left,Ptop+top,Pleft+right,Ptop+bottom);
          }
          with getInsideWindow do Dgraphic.setWindow(Pleft+left,Ptop+top,Pleft+right,Ptop+bottom);
          for j:=0 to pu.count-1 do TypeUO(pu[j]).DisplayCursors(nil);

          initRect(multiGF.paintbox1.width,multiGF.paintbox1.height);
        end;
    end;

  for i:=0 to Cadrecount(2)-1 do
    with cadre[2,i] do
    if not Cback then
      begin
        initRect(Pwidth,Pheight);
        with rect do setWindow(Pleft+left,Ptop+top,Pleft+right,Ptop+bottom);
        if multiGF.curpageRec.showOutline then drawBorder(clGray);

        if assigned(multiGF.DisplayInWindow) then multiGF.displayInWindow(self,i,1);
        initRect(multiGF.paintbox1.width,multiGF.paintbox1.height);
      end;


  PRprinting:=false;
  doneGraphic;
  printer.endDoc;
end;

procedure TpageRec.HardCopy;
var
  i,j:integer;
  c:Tcolor;
  bm:TbitmapEx;
  stB:AnsiString;
  Ptop,Pleft,Pwidth,Pheight:integer;
  colBK:integer;
begin
  updateBM;

  if PRmonochrome or PRwhiteBackGnd then
    begin
      bm:=TbitmapEx.create;
      bm.width:=bmFen.width;
      bm.height:=bmFen.height;

      with bmfen do
      begin
        colBK:=RgbToRawColor(pixelFormat,BKcolorP);
        if PRmonochrome then
          begin
            for i:=0 to width-1 do
              for j:=0 to height-1 do
                begin
                  c:=pixels[i,j];
                  if c=colBK then bm.pixels[i,j]:=clWhite
                             else bm.pixels[i,j]:=clBlack;
                end;
          end
        else
          begin
            for i:=0 to width-1 do
              for j:=0 to height-1 do
                begin
                  c:=pixels[i,j];
                  if c=colBK then bm.pixels[i,j]:=clWhite
                             else bm.pixels[i,j]:=c;
                end;
          end
      end;
    end
  else bm:=bmfen;
  stB:=getTmpName('bmp');
  bm.saveToFile(stB);


  if PRLandscape
    then printer.orientation:=poLandscape
    else printer.orientation:=poPortrait;
  printer.beginDoc;
  multiGF.positionnePrinter(Pleft,Ptop,Pwidth,Pheight);

  with printer do
    displayBitmap(stB,canvas,Pleft,Ptop,Pleft+Pwidth,Ptop+Pheight);

  printer.endDoc;

  if PRmonochrome or PRwhiteBackGnd then bm.free;
  effacerFichier(stB);
end;

procedure TpageRec.DivideWindow(num,nbx,nby,Wtype:integer;back:boolean);
var
  rect1:Trect;
begin
  controleParam(num,0,cadreCount(Wtype)-1,'TmgPage.divideWindow : invalid window number');
  controleParam(nbx,1,1000,'TmgPage.divideWindow : invalid parameter');
  controleParam(nby,1,1000,'TmgPage.divideWindow : invalid parameter');

  with cadre[Wtype,num] do
  begin
    rect1:=rect;
    with rect1 do
    begin
      if right-left<10*nbx then exit;
      if bottom-top<10*nby then exit;
    end;

    multiGF.libereObjets(pu);

    free;
  end;

  cadreList[Wtype].delete(num);
  cadreList[Wtype].pack;

  with rect1 do DefineGrid(left,top,right,bottom,nbx,nby,Wtype,back);
end;

function TPageRec.NewWindow(x,y:integer):integer;
var
  i,zone:integer;
  cd:Tcadre;
begin
  result:=-1;

  i:=0;
  zone:=0;
  resizeBM(false); {garantit que les rectangles soient à jour}

  while (i<cadrecount(1)) and (zone=0) do
  begin
    zone:=cadre[1,i].inside(x,y);
    inc(i);           { sommes nous dans un cadre? }
  end;;
  dec(i);

  if zone>0 then exit;{ si oui, exit avec -1}

  cd:=Tcadre.create(self);
  CadreList[1].add(cd);
  cd.rect:=rect(x,y,x+5,y+5);

  if multiGF.positionValable(cadreList[1],cadrecount(1)-1) then
    begin
      repeat dec(cd.rect.left) until not multiGF.positionValable(cadreList[1],cadrecount(1)-1);
      inc(cd.rect.left);
      repeat inc(cd.rect.right) until not multiGF.positionValable(cadreList[1],cadrecount(1)-1);
      dec(cd.rect.right);
      repeat dec(cd.rect.top) until not multiGF.positionValable(cadreList[1],cadrecount(1)-1);
      inc(cd.rect.top);
      repeat inc(cd.rect.bottom) until not multiGF.positionValable(cadreList[1],cadrecount(1)-1);
      dec(cd.rect.bottom);

      cd.initPos(multiGF.paintbox1.width,multiGF.paintbox1.height);

      result:=cadreCount(1)-1;
    end;
end;


procedure TpageRec.DestroyWindows(num,nb,Wtype:Integer);
var
  i:integer;
begin
  if (num<0) or (num>=cadreCount(Wtype))
    then sortieErreur('TmgPage.DestroyWindows : invalid window number');
  if num+nb>cadreCount(Wtype) then nb:=cadreCount(Wtype)-num;

  for i:=num+nb-1 downto num do
  begin
    with cadre[Wtype,i] do
    begin
      multiGF.libereObjets(pu);
      free;
    end;

    cadreList[Wtype].delete(i);
    cadreList[Wtype].pack;
  end;

  invalidateP;
end;

function TpageRec.getInsideWindow(n,Wtype: integer): Trect;
begin
  result:=cadre[Wtype,n].getInsideWindow;
end;

function TpageRec.visuP:PvisuInfo;
begin
  if not assigned(FvisuP) then
  begin
    new(FvisuP);
    FvisuP^.init;
  end;
  result:=FvisuP;
end;

function TpageRec.visuFlags:PvisuFlags;
begin
  if not assigned(visuP.FvisuFlags) then visuP.InitVisuFlags;
  result:=visuP.FvisuFlags;
end;

function TpageRec.UseVparams:boolean;
begin
  result:=FuseVparams;
end;

procedure TpageRec.assign(rec: TpageRec);
var
  i,j:integer;
  cd:Tcadre;
begin
  // On copie tous les cadres
  for i:=1 to 2 do
  begin
    for j:=0 to rec.cadreList[i].Count-1 do
    begin
      cd:=Tcadre.create(self);
      cadreList[i].Add(cd);
      with rec.cadre[i,j] do cd.init(x1,y1,x2,y2);
    end;
  end;
   // mais pas les listes d'objets

   //On copie ensuite les paramètres
   nbX:= rec.nbX;
   nbY:=rec.nbY;

   BKcolorP:= rec.BKcolorP;
   scaleColorP:=rec.scaleColorP;
   fontP.Assign(rec.fontP);
   PageFontP:=rec.PageFontP;

   showOutLine:=rec.showOutLine;
   FshowTitle:=rec.FshowTitle;
   FshowNum:=rec.FshowNum;


   if assigned(rec.FvisuP) then
   begin
     new(FvisuP);
     FvisuP^.init;
     FvisuP^.assign(rec.FvisuP^);
   end;

   FuseVparams:=rec.FuseVparams;

   FPage2valid:=rec.FPage2valid;

end;

{******************  Méthodes de TmultiGform *****************************}


function TMultiGform.getPageRec(num:integer):TpageRec;
begin
  if (num>=0) and (num<FpageList.Count)
    then result:=TpageRec(FpageList[num])
    else result:=nil;
end;

function TMultiGform.getPageIndex(st:AnsiString):integer;
var
  i:integer;
begin
  st:=Fmaj(st);
  with TabPage1.tabs do
  for i:=0 to count-1 do
    if Fmaj(strings[i])=st then
    begin
      result:=i;
      exit;
    end;
  result:=-1;
end;


procedure TMultiGform.drawBM;
begin
  curPageRec.drawBM;
end;

procedure TMultiGform.drawRect(page:integer;rr:Trect);
begin
  if page=currentPage
    then pageRec[Page].drawrect(rr);
end;


procedure TMultiGform.PosDlg(p:typeUO;rect:Trect;IsVisible:boolean);
begin
  Fdestroying:=true;
  if assigned(p) then p.ActiveEmbedded(self,rect.left+paintbox1.left+2,rect.top+paintbox1.top+2,
                                            rect.right-rect.left-4,rect.bottom-rect.top-4);

  Fdestroying:=false;
  {
    with p.embeddedForm do
    begin
      parent:=self;
      visible:=IsVisible;
      setBounds(rect.left+paintbox1.left+2,rect.top+paintbox1.top+2,rect.right-rect.left-4,rect.bottom-rect.top-4);
    end;
  }
end;

procedure TMultiGform.PrintDlg(bm:TbitmapEx;p:typeUO;rect:Trect);
begin
  if assigned(p) then
  begin
    bm.Canvas.Lock;
    try
      p.paintImageTo(bm.Canvas.Handle, rect.Left, rect.Top);
    finally
      bm.Canvas.Unlock;
    end;

  end;
end;


procedure TMultiGform.PosDialogs;
var
  i:integer;
begin
  with curPageRec do
  for i:=0 to cadreCount(1)-1 do
    with cadre[1,i] do PosDlg(UO[0],rect,true );

end;

procedure TMultiGform.PrintDialogs;
var
  i:integer;
begin
  flagTest:=true;
  with curPageRec do
  for i:=0 to cadreCount(1)-1 do
    with cadre[1,i] do PrintDlg(bmfen,UO[0],rect );
  flagTest:=false;
end;

procedure TMultiGform.FormResize(Sender: TObject);
begin
  tabpage1.width:=width-Bprint.left-Bprint.width-20;

  paintbox1.Width:=  Width - PB1deltaW;
  paintbox1.Height:= Height - PB1deltaH;

  Affdebug('Resize '+Istr(width)+'  '+Istr(height)+'  '+Istr(paintbox1.width)+'  '+Istr(paintbox1.height),131);
end;

procedure TMultiGform.updateBM;
begin
  curPageRec.resizeBM(false);

  BMpaint(currentPage,false);
  drawCursors1(currentPage);
end;

//var
//  FormPaintON: boolean;

procedure TMultiGform.FormPaint(Sender: TObject);
var
  i:integer;
  msg: Tmsg;
  cnt:integer;
begin
  if FlagTest then exit;

  Affdebug('FormPaint '+Istr(width)+'  '+Istr(height)+'  '+Istr(paintbox1.width)+'  '+Istr(paintbox1.height),131);


  //FormPaintON:=true;

  if Fdestroying then exit;  // with XE2, formpaint is called when a parent is changed

  curPageRec.resizeBM(false);


  if assigned(Idevice) and ( (PresentParam.BackBufferWidth<> Width) or (PresentParam.BackBufferHeight<>Height) ) then
  begin
    PresentParam.BackBufferWidth:= Width;
    PresentParam.BackBufferHeight:=Height;
    Idevice.reset(PresentParam);
  end;
  

  BMpaint(currentPage,false);
  drawCursors1(currentPage);

  drawBM;

  if DesignON then
    with curPageRec do
    begin
      for i:=0 to cadreCount(1)-1 do
        with cadre[1,i] do
        begin
          with paintBox1 do initRect(width,height);
          affiche(paintBox1.canvas,rect);
        end;
    end;

  //if not flagPos then
  posDialogs;

  Affdebug('FormPaint End '+Istr(paintbox1.width)+'  '+Istr(paintbox1.height),131);
  //FormPaintON:=false;
end;


procedure TMultiGform.initG(canvas:Tcanvas;left,top,width,height:integer);
begin
  initGraphic(canvas,left,top,width,height);
  with varPg1 do
  begin
    canvasPg1:=canvas;
    cleft:=left;
    ctop:=top;
    cwidth:=width;
    cheight:=height;
  end;
end;

procedure TMultiGform.initCurrentG;
begin
  with varPg1,curPageRec.BMfen do
  begin
    canvasPg1:=canvas;
    cleft:=0;
    ctop:=0;
    cwidth:=width;
    cheight:=height;
  end;
end;

procedure TMultiGform.BMPaint(numP:integer;forcer:boolean);
begin
  pagerec[numP].BMpaint(forcer);
end;


procedure TMultiGform.drawCursors1(numP:integer);
begin
  PageRec[numP].drawcursors1;
end;


procedure TMultiGform.UpdateBMs;
var
  i:integer;
begin
  for i:=0 to pageCount-1 do
    PageRec[i].updateBM;
end;

{ sélectionne un cadre dans un bitmap
}
procedure TmultiGform.selectCadre(page,num,Wtype:integer);
begin
  with pageRec[page] do
  begin
    with BMfen do initGraphic(canvas,0,0,width,height);
    with cadre[Wtype,num] do
       with rect do Dgraphic.setWindow(left,top,right,bottom);
  end;
end;

{ sélectionne un cadre sur l'écran
}
procedure TmultiGform.selectCadreW(num,Wtype:integer);
begin
  with paintBox1 do initGraphic(canvas,left,top,width,height);
  with pageRec[currentPage] do
  begin
    with cadre[Wtype,num] do
       with rect do Dgraphic.setWindow(left,top,right,bottom);
  end;
end;



function TMultiGform.initGrid(page,nx,ny:integer):boolean;
begin
  result:=false;
  if (page<0) or (page>=pageCount) then exit;

  result:=pageRec[page].initGrid(nx,ny,1);
end;

function TMultiGform.AddOnGrid(page,i,j:integer;p:pointer;Wtype:integer; mode2:boolean):boolean;
begin
  if (page<0) or (page>=pageCount) then exit;
  result:=pageRec[page].AddOnGrid(i,j,p,Wtype,mode2);
end;

{AddObject renvoie true si l'objet a été ajouté dans la liste pu
 Quand AddObject renvoie false:
   - ou bien la page ou le cadre n'était pas valable
   - ou bien l'objet existait déjà dans le cadre
}

function TMultiGform.AddObject(page,n:integer;p:typeUO; Wtype:integer; mode2: boolean):boolean;
begin
  AddObject:=false;
  if (page<0) or (page>=pageCount) then exit;
  result:=pageRec[page].AddObject(n,p,Wtype,mode2);  // ici Wtype=1 ???
end;

function disjoint(var r1,r2:Trect):boolean;
  begin
    disjoint:= (r1.right <=r2.left) or
               (r2.right <=r1.left) or
               (r1.bottom <= r2.top) or
               (r2.bottom <= r1.top);
  end;

function TMultiGform.positionValable(cads:Tlist;n:integer):boolean;
  var
    v:boolean;
    i:integer;
    rectN:Trect;
  begin
    rectN:=Tcadre(cads.items[n]).rect;

    v:=true;
    for i:=0 to cads.count-1 do
      if i<>n then v:=v and disjoint(Tcadre(cads.items[i]).rect,rectN);

    with rectN do
     v:=v and (left>=0) and (right<=paintBox1.width)
          and (top>=0) and (bottom<=paintBox1.height);
    positionValable:=v;
  end;


procedure TMultiGform.ChercheMinZmaxZ;
var
  rr:tRect;
  pr:Prect;
  bid:integer;
  h,l:integer;
begin
  with curPageRec do
  begin
    rr:=cadre[1,rectCap].rect;
    pr:=@cadre[1,rectCap].rect;

    h:=rr.bottom-rr.top;
    l:=rr.right-rr.left;

    case ZoneCap of
      1: begin
           repeat dec(pr^.top) until not positionValable(cadreList[1],rectCap);
           minYZ:=pr^.top+1;
           maxYZ:=pr^.bottom;
         end;
      2: begin
           repeat inc(pr^.right) until not positionValable(cadreList[1],rectCap);
           minXZ:=pr^.left;
           maxXZ:=pr^.right-1;
         end;
      3: begin
           repeat inc(pr^.bottom) until not positionValable(cadreList[1],rectCap);
           minYZ:=pr^.top;
           maxYZ:=pr^.bottom-1;
         end;
      4: begin
           repeat dec(pr^.left) until not positionValable(cadreList[1],rectCap);
           minXZ:=pr^.left+1;
           maxXZ:=pr^.right;
         end;
      5: begin
           repeat dec(pr^.top) until not positionValable(cadreList[1],rectCap);
           minYZ:=pr^.top+1;
           pr^:=rr;

           repeat dec(pr^.left) until not positionValable(cadreList[1],rectCap);
           minXZ:=pr^.left+1;
           pr^:=rr;

           repeat inc(pr^.bottom) until not positionValable(cadreList[1],rectCap);
           maxYZ:=pr^.bottom-1-h;
           pr^:=rr;

           repeat inc(pr^.right) until not positionValable(cadreList[1],rectCap);
           maxXZ:=pr^.right-1-l;
         end;

    end;

    pr^:=rr;
  end;
end;

procedure TMultiGform.DesignMouseDown(Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer);
var
  i,j,z,z1,z2,i1,i2:integer;
begin
  zonecap:=0;
  z:=0;
  z1:=0;

  with curPageRec do
  begin
    for i:=0 to Cadrecount(1)-1 do
    begin
      z:=cadre[1,i].traiteMouseDown(x,y);
      if z<>0 then
        begin
          z1:=z;
          i1:=i;
        end;
    end;

    if z1<>0 then
      begin
        zonecap:=z1;
        i:=i1;
      end;

    if zoneCap>0 then
      begin
        {setCapture(handle);}
        rectinit:=cadre[1,i].rect;
        RectCap:=i;
        ChercheMinZmaxZ;
        with cadre[1,rectCap] do
        if (uoCount>0) then uo[0].UnActiveEmbedded;

        FlagStatus:=true;
        with cadre[1,rectCap].rect do
          statusline.caption:=Istr(rectCap+1)+': '+Istr(left)+' '+Istr(top)+' '+Istr(right)+' '+Istr(bottom);
      end;
  end;
end;

procedure TMultiGform.setWinCursors(x,y:integer);
var
  i:integer;
begin
  with curPageRec do
  begin
    i:=0;
    while (i<Cadrecount(1)) and  not cadre[1,i].setCurseurs(x,y,paintBox1) do
      inc(i);
    if i>=CadreCount(1) then paintbox1.Cursor:=crDefault;
  end;
end;

procedure TMultiGform.DesignMouseMove( Shift: TShiftState; X,Y: Integer);
var
  i:integer;
begin
  if not (ssLeft in Shift) then
    begin
      DesignMouseUp(mbLeft,shift, X, Y);
      setWinCursors(x,y);
    end
  else
    with curPageRec do
    if zoneCap>0 then
    begin
      ChercheMinZmaxZ;
      cadre[1,rectCap].traiteMouseMove
        (paintBox1,zonecap,x,y,minXZ,maxXZ,minYZ,maxyZ);

      if flagStatus then
      with cadre[1,rectCap].rect do
        statusline.caption:=Istr(rectcap+1)+': '+Istr(left)+' '+Istr(top)+' '+Istr(right)+' '+Istr(bottom);

    end
    else setWinCursors(x,y);

end;

procedure TMultiGform.DesignMouseUp(Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);
var
  rectFin:Trect;
  j:integer;
begin
  if zonecap>0 then
    with curPageRec do
    begin
      cadre[1,rectCap].initPos(paintbox1.width,paintbox1.height);
      rectFin:=cadre[1,rectCap].rect;

      if not equalRect(rectinit,rectfin) then
        begin
          clearRect:=rectInit;
          cadre[1,rectCap].Cvalid:=false;

          invalidateRect1(rectInit);
          invalidateRect1(cadre[1,rectCap].rect);
        end;

      with cadre[1,rectCap] do
      if (uoCount>0) then uo[0].UnActiveEmbedded;

      statusline.caption:='';
      FlagStatus:=false;
      {releaseCapture;}
      zoneCap:=0;
      rectcap:=0;
    end;


end;

procedure TMultiGform.designMouseRight(x,y:integer); {screen coo}
var
  i,zone:integer;
  cd:Tcadre;
  pp:Tpoint;
begin
  with curPageRec do
  begin
    pp:=paintBox1.screenToClient(classes.point(x,y));

    i:=0;
    zone:=0;
    while (i<Cadrecount(1)) and (zone=0) do
    begin
      zone:=cadre[1,i].inside(pp.x,pp.y);
      inc(i);           { sommes nous dans un cadre? }
    end;;
    dec(i);

    if zone>0 then      { si oui, menu destroy}
      begin
        rectCap:=i;
        popupDestroy.popup(x,y)
      end
    else                { si non, on calcule rectInit puis menu New }
      begin
        cd:=Tcadre.create(curPageRec);
        CadreList[1].add(cd);
        cd.rect:=rect(pp.x,pp.y,pp.x+5,pp.y+5);

        if positionValable(cadreList[1],Cadrecount(1)-1) then
          begin
            repeat dec(cd.rect.left) until not positionValable(cadreList[1],CadreCount(1)-1);
            inc(cd.rect.left);
            repeat inc(cd.rect.right) until not positionValable(cadreList[1],CadreCount(1)-1);
            dec(cd.rect.right);
            repeat dec(cd.rect.top) until not positionValable(cadreList[1],CadreCount(1)-1);
            inc(cd.rect.top);
            repeat inc(cd.rect.bottom) until not positionValable(cadreList[1],CadreCount(1)-1);
            dec(cd.rect.bottom);

            rectInit:=cd.rect;
            cd.free;
            cadreList[1].remove(cd);
            cadreList[1].pack;

            popupNew.popup(x,y);
          end;
      end;
  end;
end;

procedure TMultiGform.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  n:integer;
  p:Tpoint;
begin
  {x et y sont les coo Paintbox1 ou bitmap}
  FastCoo.reset;
  if shift=[ssCtrl,ssShift,ssLeft] then exit;
  {réservé au positionnement du menu programme}

  zonecap:=0;
  {releaseCapture;}

  case button of
    mbleft:  if designON then
               begin
                 designMouseDown(button,shift,x,y);
                 exit;
               end
             else
               with curPageRec do
               begin
                 if not assigned(mouseDownLeft) then exit;


                 for n:=0 to cadreCount(1)-1 do
                   with cadre[1,n] do
                   if ptInRect(rect,classes.point(x,y)) then
                     begin
                       with rect do
                       begin
                         with paintBox1 do initGraphic(canvas,left,top,width,height);
                         setWindow(left,top,right,bottom);
                         p:=paintbox1.clientToScreen(classes.point(left,top));
                       end;

                       {La fenêtre courante est définie par le cadre}
                       {on transmet les coo écran du cadre et les coo du point dans le cadre}
                       MouseDownLeft(n,shift,p.x,p.y,x-rect.left,y-rect.top);
                       {statusline.caption:=Istr(p.x)+' '+Istr(p.y)+' '
                         +Istr(x-rect.left)+' '+Istr(y-rect.top) ;
                       statusline.update;}
                       doneGraphic;
                       exit;
                     end;
               end;
    mbRight:
      if not designON then
        with curPageRec do
        begin
          if not assigned(mouseDownRight) then exit;
          for n:=0 to cadrecount(1)-1 do
            with cadre[1,n] do
            if ptInRect(rect,classes.point(x,y)) then
              begin
                with rect do
                begin
                  with paintBox1 do initGraphic(canvas,left,top,width,height);
                  setWindow(left,top,right,bottom);
                  p:=paintbox1.clientToScreen(classes.point(left,top));
                end;

                MouseDownRight(n,shift,p.x,p.y,x-rect.left,y-rect.top,n);
                doneGraphic;
                exit;
              end;
        end
      else
        begin
          p:=paintbox1.clientToScreen(classes.point(x,y));
          designMouseRight(p.x,p.y);
        end;
  end;
end;

procedure TMultiGform.PaintBox1DblClick(Sender: TObject);
var
  ok:boolean;
begin
//  ok:= windows.getCursorPos(popMainPos);  // ne fonctionne pas en win64. Donc popMainPos est ajusté dans Paintbox1MouseMove

  popUpMain.popup(popMainPos.x,popMainPos.y);
end;


procedure TMultiGform.ajoutePage(st:AnsiString);
var
  rec:TpageRec;
  i:integer;
begin
  rec:=TpageRec.create(self,BKcolorDef);

  i:=tabPage1.tabs.count+1;
  if st='' then st:='Page '+Istr(i);

  while getPageIndex(st)>=0 do
  begin
    inc(i);
    st:='Page '+Istr(i);
  end;

  {with tabPage1 do tabs.addObject(st,rec);}
  tabPage1.Tabs.Add(st);
  FpageList.add(rec);
end;

procedure TMultiGform.insertPage(num:integer;st:AnsiString);
var
  rec:TpageRec;
  i:integer;
begin
  rec:=TpageRec.create(self,BKcolorDef);

  i:=tabPage1.tabs.count+1;
  if st='' then st:='Page '+Istr(i);

  while getPageIndex(st)>=0 do
  begin
    inc(i);
    st:='Page '+Istr(i);
  end;

  {with tabPage1 do tabs.insertObject(num,st,rec);}
  tabPage1.tabs.insert(num,st);
  FpageList.insert(num,rec);
end;


function TMultiGform.selectPage(num:integer):boolean;
var
  i:integer;
begin
  if (num<0) or (num>=tabPage1.tabs.count) then
    begin
      selectPage:=false;
      exit;
    end;

  tabPage1.tabIndex:=num;
  invalidate;

  initCurrentG;
  selectPage:=true;
end;

procedure TMultiGform.deletePage(num:integer);
begin
  if tabPage1.tabs.count<=1 then exit;
  if num>=tabPage1.tabs.count then exit;

  clearPage(num);

//  tabPage1.tabs.objects[num].Free;
//  tabPage1.tabs.delete(num);

  tabPage1.tabs.delete(num);
  TpageRec(FpageList[num]).Free;
  FpageList.delete(num);


  if (tabPage1.tabIndex<0) or (tabPage1.tabIndex>=tabPage1.tabs.count)
   then tabPage1.tabIndex:=tabPage1.tabs.count-1;

  selectPage(tabPage1.tabIndex);
end;

procedure TMultiGform.deleteAllPages;
var
  i,num: integer;
begin
  num:=CurrentPage;
  for i:=PageCount-1 downto 0 do
    if (i<>num) and (PageCount>1)
      then deletePage(i);
end;


procedure TMultiGform.FormCreate(Sender: TObject);
begin
  FpageList:=Tlist.create;
  varPg1:=TvarPg1.create;

  BKcolorDef:=DefBKcolor;
  Titlefont:=TfontEx.create;

  ajoutePage('');
  tabPage1.tabIndex:=0;

  selectPage(0);

  // Si PaintBox1.Align = AlClient, on obtient des effets pervers en redimensionnant la fenêtre
  // On ajuste les dimensions de PaintBox1 dans FormResize.
  // On crée avec AlClient mais on fixe AlNone juste après la création

  // La méthode devrait marcher aussi pour MainDac (il y a la status line en plus)

  PB1deltaW:=width - PaintBox1.width;
  PB1deltaH:=Height- PaintBox1.height;
  PaintBox1.Align:=AlNone;
end;

procedure TMultiGform.Reset;
var
  i,j:integer;
begin
  with tabPage1 do
  begin
    for i:=1 to tabs.count-1 do
     begin
       deletePage(currentPage);
     end;
  end;
  clearPage(currentPage);
end;

procedure TMultiGform.FormDestroy(Sender: TObject);
var
  i:integer;
begin
  varPg1.free;

  with tabPage1 do
  begin
    for i:=0 to tabs.count-1 do
      pagerec[i].Free;
    tabs.clear;
  end;

  FpageList.free;
end;

procedure TMultiGform.clearPage(num:integer);
var
  i,j:integer;
begin
  if (num<0) or (num>=tabPage1.Tabs.Count) then exit;

  with PageRec[num] do
  begin
    for j:=1 to 2 do
    begin
      for i:=0 to cadreCount(j)-1 do
      with cadre[j,i] do
      begin
        libereObjets(pu);
        free;
      end;
      cadreList[j].clear;
    end;
  end;
end;

procedure TMultiGform.clearRef;
var
  i,j:integer;
begin
  for j:=1 to 2 do
  with curPageRec do
  for i:=0 to cadrecount(j)-1 do
    with cadre[j,i] do
    begin
      puRef.free;
      puRef:=nil;
    end;
end;


function TMultiGform.getP(page,n,Wtype:integer):Tlist;
begin
  with pageRec[page] do
    if (n>=0) and (n<CadreCount(Wtype))
      then getP:=cadre[Wtype,n].pu
      else getP:=nil;
end;

function TMultiGform.getPref(page,n,Wtype:integer):Tlist;
begin
  with pageRec[page] do
    if (n>=0) and (n<CadreCount(Wtype))
      then getPref:=cadre[Wtype,n].puRef
      else getPref:=nil;
end;


function TMultiGform.count(page,Wtype:integer):integer;
begin
  count:=pageRec[page].cadrecount(Wtype);
end;

function TMultiGform.CurrentPage:integer;
begin
  CurrentPage:=tabPage1.tabIndex;
end;

function TMultiGform.PageCount:integer;
begin
  PageCount:=tabPage1.tabs.count;
end;

function TMultiGform.CurPageRec:TpageRec;
begin
  result:=pageRec[currentPage];
end;

procedure TMultiGform.setValid(page,num,wt:integer;b:boolean);
var
  i:integer;
begin
  with PageRec[page].cadre[wt,num] do
  begin
    Cvalid:=b;
    if page=currentPage then invalidateRect1(rect);
  end;
end;

function TMultiGform.getValid(page,num,wt:integer):boolean;
begin
  with pageRec[page].cadre[wt,num] do
    getValid:=Cvalid;
end;




procedure TMultiGform.Design1Click(Sender: TObject);
var
  i:integer;
begin
  update;
  designON:=not designON;

  if designON then
    begin
      Design1.caption:='End design';
      options1.enabled:=false;
      newPage1.enabled:=false;
      deletepage1.enabled:=false;

      with curPageRec do
      for i:=0 to Cadrecount(1)-1 do
        with cadre[1,i] do
        begin
          initRect(paintBox1.width,paintBox1.height);

          affiche(paintBox1.canvas,rect);
        end;
      invalidate;
    end
  else
    begin
      Design1.caption:='Design';
      options1.enabled:=true;
      newPage1.enabled:=true;
      deletepage1.enabled:=true;

      with curPageRec do
      for i:=0 to CadreCount(1)-1 do
        with cadre[1,i] do
        begin
          affiche(paintBox1.canvas,rect);
          initPos(paintBox1.width,paintBox1.height);

        end;

      if flagStatus then
      begin
        statusline.caption:='';
        FlagStatus:=false;
      end;
      {statusline.caption:='ZUT';}
      paintbox1.Cursor:=crDefault;
      invalidate;
    end;
end;

{ N'est plus utilisée . Voir getPosWin1 }
procedure TMultiGform.getPosWin(var pw:Pposwin;var size:integer);
var
  i:integer;
procedure rangerPage(num:integer);
var
  i,j:integer;
begin
  with PsaveRec(@pw[size])^,pageRec[num] do                {ranger les paramètres de la page}
  begin
    sz:=sizeof(TsaveRec);
    nbC:=cadrecount(1);
    nom:=tabPage1.tabs.strings[num];
    nx:=pageRec[num].nbx[1];
    ny:=pageRec[num].nby[1];
  end;
  inc(size,sizeof(TsaveRec));

  with pageRec[num] do
  begin
    for i:=0 to Cadrecount(1)-1 do                     {puis pour chaque cadre }
      with PsmallRect(@pw[size])^ do
      begin                                    {les coo }
        x1:=cadre[1,i].x1;
        y1:=cadre[1,i].y1;
        x2:=cadre[1,i].x2;
        y2:=cadre[1,i].y2;
        if assigned(cadre[1,i].pu) then     { le nb d'objets}
          begin                                   { et }
            nb:=cadre[1,i].pu.count;        { les objets }
            for j:=0 to nb-1 do
              pu[j+1]:=intG(cadre[1,i].pu[j]);
          end
         else nb:=0;
        inc(size,10+nb*4);
      end;
  end;
end;

begin
  new(pw);
  size:=0;
  fillchar(pw^,sizeof(pw^),0);

  Plongint(@pw[size])^:=tabPage1.tabs.count;    {ranger le nb de pages}
  inc(size,4);


  for i:=0 to tabPage1.tabs.count-1 do
    rangerPage(i); {puis chaque page}

end;


{ Peut être utilisée pour lire d'anciennes config. }
procedure TMultiGform.setPosWin(pw:Pposwin;size:integer);
var
  i,k,N:integer;

procedure lirePage(num:integer);
var
  sizeRec,nbCad:integer;
  i,j,ofs:integer;
  cd:Tcadre;
begin

  with PsaveRec(@pw[k])^do
  begin
    sizeRec:=sz;
    nbcad:=nbC;
    tabPage1.tabs.strings[num]:=nom;

    ofs:=sizeof(sz)+sizeof(nbc)+sizeof(nom)+sizeof(nX)+sizeof(nY) ;
    if ofs<=sizerec then
      with pageRec[num] do
      begin
        nbX[1]:=nx;
        nbY[1]:=ny;
      end;
  end;
  inc(k,sizeRec);

  with pageRec[num] do
  for i:=0 to nbCad-1 do
    begin
      cd:=Tcadre.create(pageRec[num]);
      CadreList[1].add(cd);
      with PsmallRect(@pw[k])^ do
      begin
        cd.init(x1,y1,x2,y2);
        if nb<>0 then
          begin
            cd.puRef:=Tlist.create;
            for j:=1 to nb do cd.puRef.add(pointer(pu[j]));
          end;
        inc(k,10+nb*4);
      end;
    end;
end;

begin
  reset;

  k:=0;
  N:=Plongint(@pw[k])^; {nb de pages }
  inc(k,4);

  pageRec[0].BKcolorP:=BKcolorDef;
  for i:=1 to N-1 do ajoutePage('');  {la page 0 existe toujours}

  for i:=0 to N-1 do
    begin
      lirePage(i);
      pageRec[i].pageValid:=false;
    end;

  invalidate;
end;


// TODO: cadrelist[2] n'est pas sauvée
procedure TMultiGform.getPosWin1(var pw:Pposwin;var size:integer);
var
  i:integer;
procedure rangerPage(num:integer);
var
  i,j,wt:integer;
begin
  with PsaveRec(@pw[size])^ do  {ranger les paramètres de la page}
  begin
    sz:=sizeof(TsaveRec);
    nbC:=pageRec[num].cadrecount(1);
    nom:=tabPage1.tabs.strings[num];
    nx:=pageRec[num].nbx[1];
    ny:=pageRec[num].nby[1];
    BKcolP:=pageRec[num].BKcolorP;
    scaleColP:=pageRec[num].ScaleColorP;
    fontToDesc(pageRec[num].fontP,fontDescP);
    pageFontP:=pageRec[num].PageFontP;

    showOutLineP:= pageRec[num].showOutLine;
    FshowTitleP:=  pageRec[num].FshowTitle;
    FshowNumP:=    pageRec[num].FshowNum;
    nbC2:=pageRec[num].cadrecount(2);
  end;
  inc(size,sizeof(TsaveRec));

  with pageRec[num] do
  begin
    for wt:=1 to 2 do
    for i:=0 to cadrecount(wt)-1 do
      begin                                      {puis pour chaque cadre }
        with PsmallRect1(@pw[size])^ do
        begin                                    {les coo }
          sz:=sizeof(TsmallRect1);
          x1:=cadre[wt,i].x1;
          y1:=cadre[wt,i].y1;
          x2:=cadre[wt,i].x2;
          y2:=cadre[wt,i].y2;
        end;
        inc(size,sizeof(TsmallRect1));

        with PsmallRect2(@pw[size])^ do
        begin
          if assigned(cadre[wt,i].pu) then              { le nb d'objets}
            begin                                    { et }
              nb:=cadre[wt,i].pu.count;                 { les objets }
              for j:=0 to nb-1 do
                pu[j+1]:=intG(cadre[wt,i].pu.items[j]); { en 64 bits, on range la partie basse de l'adresse }
            end
           else nb:=0;
          inc(size,sizeof(nb)+nb*sizeof(integer));  { pointer }
        end;
      end;
  end;
end;

begin
  new(pw);
  size:=0;
  fillchar(pw^,sizeof(pw^),0);

  Plongint(@pw[size])^:=tabPage1.Tabs.count;    {ranger le nb de pages}
  inc(size,sizeof(longint));


  for i:=0 to tabPage1.Tabs.count-1 do
    rangerPage(i); {puis chaque page}

end;



procedure TMultiGform.setPosWin1(pw:Pposwin;size:integer; const numP:integer=-1);
var
  i,k,N:integer;

procedure lirePage(num:integer);
var
  sizeRec:integer;
  nbCad: array[1..2] of integer;
  i,j,ofs,wt:integer;
  cd:Tcadre;
  Flab:boolean;
  curNum:integer;
  Flag:boolean;

begin
  if numP=-1 then curNum:=num else curNum:=0;
  flag:= (numP=-1) or (num=numP);

  with PsaveRec(@pw[k])^ do
  begin
    sizeRec:=sz;
    nbcad[1]:=nbC;
    nbCad[2]:=0;
    if flag then
    begin
      tabPage1.tabs.strings[CurNum]:=nom;

      ofs:=sizeof(sz)+sizeof(nbc)+sizeof(nom)+sizeof(nx)+sizeof(ny);
      if ofs<=sizerec then
        with pageRec[CurNum] do
        begin
          nbX[1]:=nx;
          nbY[1]:=ny;
        end;

      inc(ofs,sizeof(BKcolP));
      if ofs<=sizerec
        then pageRec[CurNum].BKcolorP:=BKcolP
        else pageRec[CurNum].BKcolorP:=BKcolorDef;

      inc(ofs,sizeof(FontDescP));
      if ofs<=sizerec
        then DescToFont(fontDescP,pageRec[CurNum].fontP);

      inc(ofs,sizeof(PageFontP));
      if ofs<=sizerec
        then pageRec[CurNum].PagefontP:=pageFontP;

      inc(ofs,sizeof(ScaleColP));
      if ofs<=sizerec
        then pageRec[CurNum].ScaleColorP:=ScaleColP;

      inc(ofs,sizeof(showOutLineP));
      if ofs<=sizerec
        then pageRec[CurNum].showOutLine:= showOutLineP;

      inc(ofs,sizeof(FshowTitleP));
      if ofs<=sizerec
        then pageRec[CurNum].FshowTitle:= FshowTitleP;

      inc(ofs,sizeof(FshowNumP));
      if ofs<=sizerec
        then pageRec[CurNum].FshowNum:= FshowNumP;

      inc(ofs,sizeof(nbC2));
      if ofs<=sizerec
        then nbCad[2]:= nbC2;
    end;
  end;
  inc(k,sizeRec);

  with pageRec[CurNum] do
  for wt:=1 to 2 do
  for i:=0 to nbCad[wt]-1 do
    begin
      if flag then cd:=Tcadre.create(pageRec[CurNum]);
      if flag then CadreList[wt].add(cd);
      with PsmallRect1(@pw[k])^ do
      begin
        if flag then cd.init(x1,y1,x2,y2);
        inc(k,sz);
        if flag then Flab:=Flabel;
      end;

      with PsmallRect2(@pw[k])^ do
      begin
        if not Flab then
          begin
            if (nb<>0) and flag then
              begin
                cd.puRef:=Tlist.create;
                for j:=1 to nb do cd.puRef.add(pointer(pu[j]));
              end;
            inc(k,sizeof(nb)+nb*sizeof(integer));      {pointer }
          end
        else
          begin
            if flag then
            begin
              cadreList[wt].Delete(cadreList[wt].Count-1);      {Détruire le label}
              cd.Free;
            end;

            inc(k,sizeof(color1)
                 +sizeof(BKcolor1)
                 +sizeof(transparent)
                 +sizeof(descFont)
                 +1+length(txt));
          end;
      end;
    end;
end;

begin
  reset;

  k:=0;
  N:=Plongint(@pw[k])^; {nb de pages }
  inc(k,sizeof(longint));

  if NumP=-1 then
    for i:=1 to N-1 do ajoutePage('');  {la page 0 existe toujours}

  for i:=0 to N-1 do
    begin
      lirePage(i);
      if (i=0) or (numP=-1) then pageRec[i].pageValid:=false;
    end;

  invalidate;
end;


procedure TMultiGform.PaintBox1MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  with paintBox1 do initGraphic(canvas,left,top,width,height);

  if designON then designMouseMove(shift,x,y)
  else
  if shift=[ssLeft] then mouseMoveLeft(x,y);

  popMainPos:= paintbox1.clientToScreen(classes.point(x,y));  // ajouté le 15 juin 2016

  doneGraphic;
end;


procedure TMultiGform.PaintBox1MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  HideStmHint;

  with paintBox1 do initGraphic(canvas,left,top,width,height);
  if designON then designMouseUp(button,shift,x,y)
  else
  {if shift=[ssLeft] then}                           { Pourquoi le test est-il supprimé? }
  if assigned(mouseUpLeft) then mouseUpLeft(x,y);
  doneGraphic;
end;

procedure TMultiGform.Newwindow1Click(Sender: TObject);
var
  cd:Tcadre;
begin
  cd:=Tcadre.create(curPageRec);
  curPageRec.cadreList[1].add(cd);
  cd.rect:=rectinit;
  cd.initPos(paintbox1.width,paintbox1.height);
  cd.affiche(paintbox1.canvas,cd.rect);

  rectCap:=0;
  zonecap:=0;
end;

procedure TMultiGform.Destroywindow1Click(Sender: TObject);
begin
  with curPageRec.cadre[1,rectCap] do
  begin
    affiche(paintbox1.canvas,rect);
    clearRect:=rect;

    libereObjets(pu);

    free;
  end;

  with curPageRec do
  begin
    cadreList[1].delete(rectCap);
    cadreList[1].pack;
  end;

  rectCap:=0;
  zonecap:=0;

  invalidate;
end;

procedure TMultiGform.Clearwindow1Click(Sender: TObject);
begin
  with curpageRec.cadre[1,rectCap] do
  begin
    libereObjets(pu);
    pu.free;
    pu:=nil;
    clearRect:=rect;
    Cvalid:=false;
  end;
  rectCap:=0;
  zonecap:=0;
  invalidate;
end;

procedure TMultiGform.libereObjets(pu:Tlist);
var
  i:integer;
begin
  if assigned(pu) then
  begin
    for i:=0 to pu.count-1 do libereObjet(pu.items[i]);
    pu.clear;
  end;
end;

procedure TMultiGform.RemoveObject(numCadre,numObj:integer);
begin
  with curPageRec.cadre[1,numCadre] do
  begin
    libereObjet(pu.items[numObj]);
    pu.delete(numObj);
    pu.pack;
    if pu.count=0 then
      begin
        pu.free;
        pu:=nil;
      end;
    clearRect:=rect;
    Cvalid:=false;
  end;
  rectCap:=0;
  zonecap:=0;
  invalidate;
end;

procedure TmultiGform.removeFromWin(sender:Tobject);
var
  numCadre,numObj:integer;
begin
  numCadre:=hiword(TmenuItem(sender).tag);
  numObj:=loword(TmenuItem(sender).tag);

  removeObject(numCadre,numObj);
end;

procedure TMultiGform.BringObjectToFront(numCadre,numObj:integer);
begin
  with curPageREc.cadre[1,numCadre] do
  begin
    pu.move(numObj,0);

    typeUO(pu.items[0]).messageToRef(UOmsg_BringToFront,nil);
    typeUO(pu.items[1]).messageToRef(UOmsg_sendToBack,nil);
  end;

  if acquisitionON then
    begin
      RepaintBorders(numCadre);
      invalidateBorders(numCadre);
      update;
    end
  else
    begin
      clearRect:=curPageREc.cadre[1,numCadre].rect;
      curPageREc.cadre[1,numCadre].Cvalid:=false;
      rectCap:=0;
      zonecap:=0;

      invalidate;
    end;
end;


procedure TmultiGform.BringToFront(sender:Tobject);
var
  numCadre,numObj:integer;
begin
  numCadre:=hiword(TmenuItem(sender).tag);
  numObj:=loword(TmenuItem(sender).tag);

  BringObjectToFront(numCadre,numObj);

end;


procedure TMultiGform.PaintBox1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  i:integer;
begin
  accept:=false;

  if (sender=paintbox1) and assigned(dragOver) then
    with curPageRec do
    for i:=0 to cadrecount(1)-1 do
      with cadre[1,i] do
        if (inside(x,y)>0) then
          begin
            if assigned(specialDrag)
              then accept:=assigned(pu) and (pu.indexof(specialDrag)>=0)
              else accept:=dragOver(source);
            exit;
          end;
end;

procedure TMultiGform.PaintBox1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  i:integer;
begin
  if (sender=paintbox1) and assigned(dragDrop) then
    with curPageREc do
    for i:=0 to cadrecount(1)-1 do
      with cadre[1,i] do
        if inside(x,y)>0 then
          begin
            if assigned(specialDrag) then
              begin
                 with rect do
                 begin
                   with paintBox1 do initGraphic(canvas,left,top,width,height);
                   setWindow(left,top,right,bottom);
                 end;
                 SpecialdragDrop(pu.items[0],specialDrag,x-rect.left,y-rect.top);
              end
            else dragDrop(source,i);
            clearRect:=rect;
            Cvalid:=false;
            invalidateRect1(rect);
            if assigned(specialDrag) then doneGraphic;
            exit;
          end;
end;


procedure TMultiGform.Options1Click(Sender: TObject);
var
  st:Ansistring;
  i:integer;
begin
  with optionsMultg1 do
  begin
    CBoutline.setvar(curpageRec.showOutline);
    CBtitles.setvar(curpageRec.FshowTitle);
    CBnum.setvar(curpageRec.FshowNum);


    AdBKcolor:=@CurPageRec.BKColorP;
    AdTitlefont:=TitleFont.font;

    AdScalecolor:=@CurPageRec.scaleColorP;
    AdScalefont:=curPageRec.FontP;

    cbScaleFont.setVar(curpageRec.pageFontP);
    BscaleFont.Enabled:=curpageRec.pageFontP;
    BscaleColor.Enabled:=curpageRec.pageFontP;
    PanelScaleColor.visible:=curpageRec.pageFontP;

    EsMgCaption.setString(MgCaption,50);

    with tabPage1 do st:=tabs.strings[tabIndex];
    ESname.setString(st,20);
  end;

  if optionsMultg1.showModal=mrOK then
    begin
      updateAllVar(optionsMultg1);

      TitleFont.font:=optionsMultg1.AdTitlefont;
      with tabPage1 do tabs.strings[tabIndex]:=st;

      curPageRec.PageValid:=false;
      caption:= MgCaption;
      invalidate;
    end;

end;


procedure TMultiGform.Newpage1Click(Sender: TObject);
begin
  ajoutePage('');
end;

procedure TMultiGform.Deletepage1Click(Sender: TObject);
begin
  deletePage(currentPage);
end;

procedure TMultiGform.AllPagesExceptCurrent1Click(Sender: TObject);
begin
  deleteAllPages;
end;


procedure TMultiGform.TabPage1Change(Sender: TObject);
begin
  selectPage(tabpage1.tabIndex)
end;

procedure TMultiGform.TabPage1Changing(Sender: TObject; var AllowChange: Boolean);
var
  i:integer;
begin
  with CurPageRec do
  for i:=0 to Cadrecount(1)-1 do
    with cadre[1,i] do
    if assigned(uo[0]) then uo[0].UnActiveEmbedded;

  FastCoo.reset;
end;

(*
procedure TMultiGform.DrawPageXX(canvas:Tcanvas;w,h:integer);
var
  i,j:integer;
  colBK:integer;
begin
{
  with canvas do
  begin
    pen.Color:=clRed;
    rectangle(10,10,900,500);
    exit;
  end;
 }
  if PRWhiteBackGnd or PRmonochrome
    then colBK:=clwhite
    else colBK:=curPageRec.BKcolorP;

  with Canvas,curPageRec do
  begin
    initG(canvas,0,0,w,h);
    clearWindow(colBK);

    canvas.font.assign(font);
    canvas.brush.color:=colBK;

    for i:=0 to Cadrecount-1 do
      begin
        with cadre[i] do
        begin
          initRect(w,h);
          with rect do setWindow(left,top,right,bottom);
          clearWindow(colBK);
          if showOutline then drawBorder(clGray);

          if assigned(DisplayInWindow) then displayInWindow(curPageRec,i,1);
          initRect(paintbox1.width,paintbox1.height);
        end;
      end;

    for i:=0 to CadreCount-1 do
      with cadre[i] do
      begin
        if assigned(pu) then
          begin
            initRect(w,h);

            with getInsideWindow do Dgraphic.setWindow(left,top,right,bottom);
            for j:=0 to pu.count-1 do TypeUO(pu[j]).DisplayCursors(nil);

            initRect(paintbox1.width,paintbox1.height);
          end;
      end;

  end;

  doneGraphic;
end;
*)
procedure TMultiGform.copyTo(stf:AnsiString);
var
  meta:TMetaFile;
  metaCanvas:TMetafileCanvas;
  w,h:integer;
begin
  PRmetaFile:=true;
  with curPageREc do
  begin
    Meta:= TMetafile.Create;
    try
      w:=printer.pageWidth;
      h:=roundL (w*BMfen.height/BMfen.width);
      meta.width:=w;
      meta.height:=h;
      {$IFDEF FPC}
      metaCanvas:=TMetafileCanvas.Create(Meta, printer.canvas.handle);
      {$ELSE}
      metaCanvas:=TMetafileCanvas.Create(Meta, printer.handle);
      {$ENDIF}
      PRprinting:=true;

      PRfactor:=w/paintbox1.width;
      if PRautoSymb then PRsymbMag:=PRfactor;

      if (PRsymbMag<1) or (PRsymbMag>20) then PRsymbMag:=1;

      if PRautoFont then PRfontmag:=PRfactor;
      if (PRfontMag<0.2) or (PRfontMag>50) then PRfontMag:=1;

    except
      w:=BMfen.width;
      h:=BMfen.height;
      meta.width:=w;
      meta.height:=h;
      metaCanvas:=TMetafileCanvas.Create(Meta, paintbox1.canvas.handle);

      PRprinting:=false;
    end;

    try
      drawPage(metaCanvas,w,h);
    finally
      metaCanvas.Free;
      PRprinting:=false;
      PRmetaFile:=false;
    end;

    meta.enhanced:=true;

    if stf=''
      then {$IFDEF FPC} CopyMetaToClipBoard(meta.Handle)
           {$ELSE}      clipboard.assign(meta)
           {$ENDIF}
      else meta.saveToFile(stF);
    meta.free;
  end;
end;

procedure TMultiGform.copyToClipboard;
begin
  if PRdraft then
  begin
    PrintDialogs;
    clipBoard.assign(curPageRec.BMfen);
  end
  else copyto('');
end;

procedure TMultiGform.PositionnePrinter(var Pleft,Ptop,Pwidth,Pheight:integer);
var
  delta,dh:integer;
begin
  with printer,canvas do
  begin
    font.name:='Times New Roman';
    font.size:=10;
    font.style:=[fsBold];

    pen.Color:=clBlack;
    pen.Style:=psSolid;

    brush.Color:=clWhite;
    brush.Style:=bsClear;

    delta:=printer.PageWidth div 60;
    Ptop:=delta;
    Pleft:=delta;

    dh:=0;
    if PRprintName then dh:=1;
    if PrintComment<>'' then inc(dh);
    if PRprintName or (PrintComment<>'') then inc(dh);
    dh:=dh*textHeight('Un');

    Pwidth:=printer.PageWidth-delta*2;

    PRfactor:=Pwidth/paintbox1.width;

    if PRkeepAspectRatio or PRdraft then
      begin
        Pheight:=round(Pwidth*(paintbox1.height/paintbox1.width));
        if Pheight>printer.PageHeight-delta*2-dh then
          begin
            Pheight:=printer.PageHeight-delta*2-dh;
            Pwidth:=round(Pheight*(paintbox1.width/paintbox1.height));
          end;
      end
    else Pheight:=printer.PageHeight-delta*2-dh;

    if PRprintName then
      begin
        textOut(Pleft,Ptop,dateToStr(date)+'    '+getDataFileName);
        Ptop:=Ptop+textHeight('Un');
      end;
    font.style:=[];
    if PrintComment<>'' then
      begin
        textOut(Pleft,Ptop,PrintComment);
        Ptop:=Ptop+textHeight('Un');
      end;
    if PRprintName or (PrintComment<>'') then Ptop:=Ptop+textHeight('Un');
  end;
end;

procedure TMultiGform.imprimer;
var
  colBK:Tcolor;
  i,j:integer;
  Ptop,Pleft,Pwidth,Pheight:integer;
begin
  if PRWhiteBackGnd or PRmonochrome
    then colBK:=clwhite
    else colBK:=curPageRec.BKcolorP;

  if PRLandscape
    then printer.orientation:=poLandscape
    else printer.orientation:=poPortrait;

  printer.beginDoc;
  positionnePrinter(Pleft,Ptop,Pwidth,Pheight);

  PRprinting:=true;

  with printer do initG(canvas,0,0,printer.PageWidth,printer.PageHeight);
  with canvasGlb do
  begin
    pen.style:=psSolid;
    pen.mode:=pmCopy;
  end;

  if PRautoSymb then PRsymbMag:=PRfactor;
  if (PRsymbMag<1) or (PRsymbMag>20) then PRsymbMag:=1;

  if PRautoFont then PRFontMAg:=1;
  if (PRfontMag<0.2) or (PRfontMag>50) then PRfontMag:=1;

  canvasGlb.font.assign(font);

  canvasGlb.font.size:=round(canvasGlb.font.size*PRfontMag);

  canvasGlb.brush.color:=colBK;

  if colBK<>clWhite then clearWindow(colBK);

  with curPageRec do
  for i:=0 to Cadrecount(2)-1 do
    with cadre[2,i] do
    if Cback then
      begin
        initRect(Pwidth,Pheight);
        with rect do setWindow(Pleft+left,Ptop+top,Pleft+right,Ptop+bottom);
        if showOutline then drawBorder(clGray);

        if assigned(DisplayInWindow) then displayInWindow(curPageRec,i,1);
        initRect(paintbox1.width,paintbox1.height);
      end;



  with curPageRec do
  for i:=0 to Cadrecount(1)-1 do
    with cadre[1,i] do
      begin
        initRect(Pwidth,Pheight);
        with rect do setWindow(Pleft+left,Ptop+top,Pleft+right,Ptop+bottom);
        if showOutline then drawBorder(clGray);

        if assigned(DisplayInWindow) then displayInWindow(curPageRec,i,1);
        initRect(paintbox1.width,paintbox1.height);
      end;

  with curPageRec do
  for i:=0 to CadreCount(1)-1 do
    with cadre[1,i] do
    begin
      if assigned(pu) then
        begin
          initRect(Pwidth,Pheight);

          with getInsideWindow do Dgraphic.setWindow(Pleft+left,Ptop+top,Pleft+right,Ptop+bottom);
          for j:=0 to pu.count-1 do TypeUO(pu[j]).DisplayCursors(nil);

          initRect(paintbox1.width,paintbox1.height);
        end;
    end;

  with curPageRec do
  for i:=0 to Cadrecount(2)-1 do
    with cadre[2,i] do
    if not Cback then
      begin
        initRect(Pwidth,Pheight);
        with rect do setWindow(Pleft+left,Ptop+top,Pleft+right,Ptop+bottom);
        if showOutline then drawBorder(clGray);

        if assigned(DisplayInWindow) then displayInWindow(curPageRec,i,1);
        initRect(paintbox1.width,paintbox1.height);
      end;


  PRprinting:=false;
  doneGraphic;
  printer.endDoc;
end;

procedure testImprimante;
begin

end;

procedure TMultiGform.HardCopy;
var
  i,j:integer;
  c:Tcolor;
  bm:TbitmapEx;
  stB:AnsiString;
  Ptop,Pleft,Pwidth,Pheight:integer;
  colBK:integer;
begin
  stB:=getTmpName('bmp');
  with curPageREc do
  if PRmonochrome or PRwhiteBackGnd then
    begin
      colBK:=RgbToRawColor(bmfen.PixelFormat,BKcolorP);

      bm:=TbitmapEx.create;
      with bmfen do bm.SetSize(width,height,bitCount);

      with bmfen do
      begin
        if PRmonochrome then
          begin
            for i:=0 to width-1 do
              for j:=0 to height-1 do
                begin
                  c:=pixels[i,j];
                  if c = colBK
                    then bm.pixels[i,j]:=clWhite
                    else bm.pixels[i,j]:=clBlack;
                end;
          end
        else
          begin
            for i:=0 to width-1 do
              for j:=0 to height-1 do
                begin
                  c:=pixels[i,j];
                  if c = colBK
                    then bm.pixels[i,j]:=clWhite
                    else bm.pixels[i,j]:=c;
                end;
          end
      end;
      bm.saveToFile(stB);
    end
  else bmfen.saveToFile(stB);


  if PRLandscape
    then printer.orientation:=poLandscape
    else printer.orientation:=poPortrait;
  printer.beginDoc;
  positionnePrinter(Pleft,Ptop,Pwidth,Pheight);

  with printer do
    displayBitmap(stB,canvas,Pleft,Ptop,Pleft+Pwidth,Ptop+Pheight);

  printer.endDoc;

  if PRmonochrome or PRwhiteBackGnd then bm.free;
  effacerFichier(stB);
end;

procedure TMultiGform.saveToFile;
var
  ext:AnsiString;
begin
  if PRdraft then ext:='.BMP' else ext:='.EMF';

  PRfileName:=nouvelleExtension(PRfileName,ext);

  if sauverFichierStandard(PRfileName,ext) then
    if PRdraft then curPageREc.BmFen.saveToFile(PRfileName)
    else copyto(PRfileName);
end;

procedure TMultiGform.BprintClick(Sender: TObject);
begin
  if not animationON then
  case printMgDialog.execution of
    mrOK: if PRdraft then hardcopy else imprimer;
    101:  SaveToFile;
    102:  CopyToClipboard;
  end;
end;

{ invalide un rectangle de l'écran et non du bitmap
  rect est donné en coordonnées bitmap ou paintbox1
}
procedure TMultiGform.invalidateRect1(rect:Trect);
begin
  with rect do
  begin
    inc(left,paintbox1.left);
    inc(right,paintbox1.left+1);
    inc(top,paintbox1.top);
    inc(bottom,paintbox1.top+1);
    windows.invalidateRect(handle,@rect,false);
  end;
end;

procedure TMultiGform.invalidateBorders(num:integer);
var
  rect,rectI:Trect;
begin
  initGraphic(curpageRec.BMfen);
  rect:=curpageRec.cadre[1,num].rect;
  with rect do setWindow(left,top,right,bottom);
  setWindowIN(curpageRec.cadre[1,num].pu);
  with rectI do getWindowG(left,top,right,bottom);

  invalidateRect1(classes.rect(rect.Left,rect.Top,rectI.Left,rect.Bottom));
  invalidateRect1(classes.rect(rect.Left,rectI.bottom,rect.right,rect.Bottom));

  doneGraphic;
end;

procedure TMultiGform.RepaintBorders(num:integer);
var
  rect,rectI:Trect;
begin
  initGraphic(curpageRec.BMfen);
  rect:=curpageRec.cadre[1,num].rect;
  with rect do setWindow(left,top,right,bottom);
  setWindowIN(curpageRec.cadre[1,num].pu);
  with rectI do getWindowG(left,top,right,bottom);

  setWindow(rect.Left,rect.Top,rectI.Left,rect.Bottom);
  clearWindow(curpageRec.BKcolorP);
  setWindow(rect.Left,rectI.bottom,rect.right,rect.Bottom);
  clearWindow(curpageRec.BKcolorP);

  with rect do setWindow(left,top,right,bottom);
  displayEmpty(curpageRec,num,1);
  doneGraphic;
end;


{ invalide à l'écran le cadre de numéro num
}
procedure TmultiGform.invaliderCadre(num:integer);
begin
  with curpageRec.cadre[1,num] do
  invalidateRect1(rect);
end;

procedure TMultiGform.Refresh1Click(Sender: TObject);
begin
  //curPageRec.saveAsBmp('D:\delphe5\test.bmp');

  curPageRec.pageValid:=false;
  invalidate;
end;

procedure TMultiGform.Reset1Click(Sender: TObject);
begin

end;

                 { Opérations Tmultigraph en PG1}

procedure TmultiGform.setFenetre0;
begin
  with curPageREc,varPg1 do
  begin
    initGraphic(canvasPg1,cleft,ctop,cwidth,cheight);

    if WinEx then setWindow(x1winEx,y1winEx,x2winEx,y2winEx )
    else
      begin
        if (win0>=0) and (win0<cadreCount(1))  then
          with cadre[1,win0],rect do
          begin
            setWindow(left,top,right,bottom);
            if assigned(setWindowIN) then setWindowIN(pu);
          end
        else sortieErreur(E_invalidWin0);
      end;
    if not clip0 then setClippingOff;

    setworld(X1win0,Y1win0,X2win0,Y2win0);

    varPg1.saveCanvas;
  end;
end;

procedure TmultiGform.InvaliderFenetre0;
var
  x1,y1,x2,y2:integer;
begin
  getWindowG(x1,y1,x2,y2);
  invalidateRect1(rect(x1,y1,x2,y2));
end;

procedure TmultiGform.setcadre0;
begin
  with curPageREc,varPg1 do
  begin
    initGraphic(canvasPg1,cleft,ctop,cwidth,cheight);

    if (win0>=0) and (win0<cadrecount(1))  then
      with cadre[1,win0].rect do
        setWindow(left,top,right,bottom)
    else exit;

    setworld(X1win0,Y1win0,X2win0,Y2win0);

    oldPenG:=canvas.pen;
    canvas.pen:=pen0;

    oldBrushG:=canvas.brush;
    canvas.brush:=brush0;

    oldFontG:=canvas.font;
    canvas.font:=font0;

    invertPenFont:=true;
  end;
end;

procedure TmultiGform.resetFenetre0;
begin
  varPg1.RestoreCanvas;
  doneGraphic;
end;

procedure TmultiGform.Pg1Droite(a,b:float);
  var
    x1,y1,x2,y2:float;
    i:integer;
  begin
    with varPg1 do
    begin
      setFenetre0;
      TRY
      if a=0 then
        begin
          x1:=X1win0;
          x2:=X2win0;
          y1:=b;
          y2:=b;
        end
      else
        begin
          x1:=X1win0;
          y1:=x1*a+b;
          if y1<Y1win0 then
            begin
              y1:=Y1win0;
              x1:=(y1-b)/a;
            end
          else
          if y1>Y2win0 then
            begin
              y1:=Y2win0;
              x1:=(y1-b)/a;
            end;

          x2:=X2win0;
          y2:=x2*a+b;
          if y2<Y1win0 then
            begin
              y2:=Y1win0;
              x2:=(y2-b)/a;
            end
          else
          if y2>Y2win0 then
            begin
              y2:=Y2win0;
              x2:=(y2-b)/a;
            end;
        end;

      with canvasGlb do
      begin
        moveto(convWx(x1),convWy(y1));
        lineto(convWx(x2),convWy(y2));
      end;

      invaliderFenetre0;

      FINALLY
      resetFenetre0;
      END;

    end;
  end;

procedure TmultiGform.Pg1Line(x1,y1,x2,y2:float);
begin
  setFenetre0;

  try
    with canvasGlb do
    begin
      moveto(convWx(x1),convWy(y1));
      lineto(convWx(x2),convWy(y2));
    end;
    varPg1.xg:=x2;
    varPg1.yg:=y2;
    invaliderFenetre0;
  finally
    resetFenetre0;
  end;
end;

procedure TmultiGform.Pg1lineTo(x,y:float);
begin
  with varPg1 do pg1line(xg,yg,x,y);
end;

procedure TmultiGform.Pg1moveto(x,y:float);
begin
  varPg1.xg:=x;
  varPg1.yg:=y;
end;

procedure TmultiGform.Pg1LineVer(x0:float);
begin
  with varPg1 do pg1line(x0,Y1win0,x0,Y2win0);
end;

procedure TmultiGform.Pg1LineHor(y0:float);
begin
  with varPg1 do pg1line(X1win0,y0,X2win0,y0);
end;

procedure TmultiGform.Pg1setWindow(num:integer);
var
  n:integer;
begin
  n:=num-1;
  if (n<0) or (n>=pageRec[currentPage].cadreCount(1))
    then sortieErreur(E_invalidWin0);
  with varPg1 do
  begin
    win0:=n;
    winEx:=false;
    clip0:=true;
  end;
end;

function TmultiGform.Pg1getWindow:integer;
begin
  result:=varPg1.win0+1;
end;

procedure TmultiGform.Pg1selectWindow(p:pointer);
var
  i,j:integer;
begin
  with curPageREc do
  for i:=0 to cadrecount(1)-1 do
    with cadre[1,i] do
      if assigned(pu) then
        for j:=0 to pu.count-1 do
          if pu.items[j]=p then
            begin
              varPg1.win0:=i;
              varPg1.winEx:=false;
              varPg1.clip0:=true;
              exit;
            end;
  sortieErreur(E_selectWindow);
end;


procedure TmultiGform.Pg1setWindowEx(x1,y1,x2,y2:integer);
begin
  with varPg1 do
  begin
    winEx:=true;

    x1winEx:=x1;
    x2winEx:=x2;
    y1winEx:=y1;
    y2winEx:=y2;
    clip0:=true;
  end;
end;

procedure TmultiGform.Pg1getWindowEx(var x1,y1,x2,y2:Integer);
begin
  with varPg1 do
  begin
    if WinEx then
      begin
        x1:=x1winEx;
        y1:=y1winEx;
        x2:=x2winEx;
        y2:=y2winEx;
      end
    else
      with curPageREc do
      begin
        if (win0>=0) and (win0<cadrecount(1))  then
          with cadre[1,win0].rect do
          begin
            x1:=left;
            y1:=top;
            x2:=right;
            y2:=bottom;
          end
        else sortieErreur(E_invalidWin0);
      end;
  end;
end;

procedure TmultiGform.Pg1GetWindowPos(page,win:integer;var xx1,yy1,xx2,yy2:integer);
begin
  ControlePageWin(page,win);

  with pageRec[page].cadre[1,win] do
  begin
    initRect(paintbox1.width,paintbox1.height);
    xx1:=rect.left;
    xx2:=rect.Right;
    yy1:=rect.top;
    yy2:=rect.bottom;
  end;
end;

procedure TmultiGform.Pg1setWorld(x1,y1,x2,y2:float);
begin
  if (x1=x2) or (y1=y2) then sortieErreur(E_setWorld);
  with varPg1 do
  begin
    x1win0:=x1;
    x2win0:=x2;
    y1win0:=y1;
    y2win0:=y2;
  end;
end;

procedure TmultiGform.Pg1setXWorld(x1,y1,x2:float;Fup:boolean);
var
  x1f,y1f,x2f,y2f:integer;
  dum:float;
begin
  if (x1=x2) then sortieErreur(E_setWorld);
  with varPg1 do
  begin
    Pg1getWindowEx(x1f,y1f,x2f,y2f);
    x1win0:=x1;
    x2win0:=x2;
    y1win0:=y1;
    y2win0:=y1+(x2-x1)*(y2f-y1f)/(x2f-x1f);

    if not Fup then
      begin
        dum:=y1win0;
        y1win0:=y2win0;
        y2win0:=dum;
      end;
  end;
end;


procedure TmultiGform.Pg1getWorld(var x1,y1,x2,y2:float);
begin
  with varPg1 do
  begin
    x1:=x1win0;
    x2:=x2win0;
    y1:=y1win0;
    y2:=y2win0;
  end;
end;

procedure TmultiGform.Pg1clearWindow(tout:boolean);
begin
  with varPg1,curPageREc do
  begin
    if WinEx then
      begin
        setWindow(x1winEx,y1winEx,x2winEx,y2winEx );
        clearWindow(BKcolorP);
        invalidateRect1(rect(x1act,y1act,x2act,y2act));
        exit;
      end;

    if (win0>=0) and (win0<cadrecount(1)) then
      begin
        if tout
          then setCadre0
          else setFenetre0;

        clearWindow(BKcolorP);
        invalidateRect1(rect(x1act,y1act,x2act,y2act));
        resetFenetre0;
      end
    else sortieErreur(E_invalidWin0);
  end;
end;

procedure TmultiGform.Pg1DrawBorder;
var
  k:integer;
begin
  setFenetre0;
  with varpg1 do
  begin
    drawBorder(pen0.color);
    k:=pen0.width;
  end;
  invalidateRect1(rect(x1act-k,y1act-k,x2act+k,y2act+k));
  resetFenetre0;
end;

procedure TmultiGform.VSrectangle(x,y,dx,dy,theta:float);
var
  deg:typeDegre;
  PR:typePoly5R;
  i:integer;
begin
  setFenetre0;

  deg.x:=x;
  deg.y:=y;
  deg.dx:=dx;
  deg.dy:=dy;
  deg.theta:=theta;

  DegToPolyR(deg,PR);

  try
    with canvasGlb do
    begin
      moveto(convWx(PR[1].x),convWy(PR[1].y));
      for i:=2 to 5 do
        lineto(convWx(PR[i].x),convWy(PR[i].y));
    end;
  finally

    invaliderFenetre0;
    resetFenetre0;
  end;
end;

procedure TmultiGform.Pg1DrawBorderOut;
var
  k:integer;
begin
  setFenetre0;
  with varpg1 do
  begin
    drawBorderOut(pen0.color);
    k:=pen0.width;
  end;

  invalidateRect1(rect(x1act-k,y1act-k,x2act+k,y2act+k));
  resetFenetre0;
end;


procedure TmultiGform.Pg1OutText(x,y:integer;st:AnsiString);
var
  w,h:integer;
begin
  with varPg1 do initGraphic(canvasPg1,cleft,ctop,cwidth,cheight);

  with canvasGlb,varPg1 do
  begin
    oldBrushG:=brush;
    brush.color:=curPageRec.BKcolorP;
    if transparent
      then brush.style:=bsclear
      else brush.style:=bsSolid;

    oldFontG:=font;
    font:=font0;

    TextOut(x,y,st);
    w:=TextWidth(st);
    h:=textHeight(st);
    font:=oldFontG;
    brush:=oldBrushG;
  end;

  invalidateRect1(rect(x,y,x+w,y+h));
end;

procedure TmultiGform.Pg1OutTextW(x,y:integer;st:AnsiString);
var
  x1,y1,x2,y2:integer;
  w,h:integer;
begin
  setFenetre0;
  with canvasGlb,varpg1 do
  begin
    brush.color:=curPageRec.BKcolorP;
    if transparent
      then brush.style:=bsclear
      else brush.style:=bsSolid;

    TextOutG(x,y,st);
    with canvasGlb do
    begin
      w:=TextWidth(st);
      h:=textHeight(st);
    end;
  end;

  getWindowG(x1,y1,x2,y2);
  invalidateRect1(rect(x1+x,y1+y,x1+x+w,y1+y+h));
  resetFenetre0;
end;


procedure TmultiGform.Pg1SetTextStyle(font,dir,charSize:integer);
begin
end;

procedure TmultiGform.Pg1SetClippingON;
begin
  with varPg1 do clip0:=true;
end;

procedure TmultiGform.Pg1SetClippingOff;
begin
  with varPg1 do clip0:=false;
end;


procedure TmultiGform.Pg1Graduations(stX,stY:AnsiString;echX,echY:boolean);
var
  grad:typeGrad;
begin
  setFenetre0;
  with varPg1 do
  begin
    Dgraphic.setWorld( X1win0,Y1win0,X2win0,Y2win0);
    grad:=typeGrad.create;
    with grad do
    begin
      setUnites(stX,stY);
      setLog(LogX0,LogY0);

      setEch(echX,echY);
      {
      setCadre(FtickX,FtickY,1);
      setComplet(completX,completY);
      setExternal(tickExtX,tickExtY);

      setGrille(grille);
      }
      setColors(pen0.color,curPageRec.bkcolorP);

      affiche;
    end;
    grad.free;
  end;
  resetFenetre0;
end;

procedure TmultiGform.Pg1AfficherSymbole(x,y:float;numSymb,taille:integer);
begin
  setFenetre0;

  TRY
    with varPg1 do
    begin
      displaySymbol(typeStyleTrace(numSymb),taille,pen0.color,convWx(x),convWy(y));
      invaliderFenetre0;

      xg:=x;
      yg:=y;
    end;
  FINALLY
    resetFenetre0;
  END;
end;



procedure TmultiGform.Pg1clearScreen;
begin
  with curPageREc,varPg1 do
  begin
    initGraphic(canvasPg1,cleft,ctop,cwidth,cheight);
    clearWindow(BKcolorP);
    doneGraphic;
  end;
  invalidate;
end;

procedure TmultiGform.Pg1resetScreen;
begin
  curPageRec.pageValid:=false;
  invalidate;
end;

function TmultiGform.Pg1GetWin(p:pointer):integer;
var
  i,j:integer;
begin
  with curPageREc do
  for i:=0 to cadrecount(1)-1 do
    with cadre[1,i] do
      if assigned(pu) then
        for j:=0 to pu.count-1 do
          if pu.items[j]=p then
            begin
              Pg1GetWin:=i+1;
              exit;
            end;
  Pg1GetWin:=0;
end;

function TmultiGform.getRect(p:pointer;var numFen,numOrdre:integer;var FirstPlot:typeUO):Trect;
var
  i,j:integer;
begin

  with curPageREc do
  for i:=0 to cadrecount(1)-1 do
  begin
    numOrdre:=-1;
    with cadre[1,i] do
    for j:=0 to UOcount-1 do
    begin
      {if UO[j].withInside then inc(numOrdre);}
      if UO[j]=p then
        begin
          result:=rect;
          numFen:=i;
          numOrdre:=j;  {09-06-09 : on renvoie le vrai numéro plutôt que le numéro du premier objet avec inside }
          FirstPlot:=UO[0];
          exit;
        end;
    end;
  end;
  fillchar(result,sizeof(result),0);
  numFen:=-1;
  numOrdre:=-1;
end;


procedure TmultiGform.Pg1DisplayObject(p:pointer);
begin
  setFenetre0;
  try
  with varpg1 do displayIn(p,true,logX0,logY0,mode0,taille0);
  finally
  invaliderFenetre0;
  resetFenetre0;
  end;
end;

procedure TmultiGform.Pg1gotoxy(x,y:integer);
begin
  with varpg1 do
  begin
    Xtext:=Ltext*(x-1);
    Ytext:=Htext*(y-1);
  end;
end;

procedure TmultiGform.Pg1gotoxyW(x,y:integer);
begin
  with varPg1 do initGraphic(canvasPg1,cleft,ctop,cwidth,cheight);

  with varpg1,curPageREc do
  begin
    if WinEx then setWindow(x1winEx,y1winEx,x2winEx,y2winEx )
    else
      begin
        if (win0>=0) and (win0<cadrecount(1))  then
          with cadre[1,win0],rect do
          begin
            setWindow(left,top,right,bottom);
            if assigned(setWindowIN) then setWindowIN(pu);
          end
        else exit;
      end;

    XtextStart:=x1act;
    Xtext:=x1act+Ltext*(x-1);
    Ytext:=y1act+Htext*(y-1);
  end;
end;

procedure TmultiGform.Pg1write(st:AnsiString);
var
  w,h:integer;
begin
  with varPg1 do initGraphic(canvasPg1,cleft,ctop,cwidth,cheight);
  with canvasGlb,varPg1 do
  begin
    oldBrushG:=brush;
    brush.color:=curPageRec.BKcolorP;
    brush.style:=bsSolid;

    oldFontG:=font;
    font:=fontText;
    if curPageRec.BKcolorP=clBlack
      then font.color:=clWhite
      else font.color:=clBlack;

    with varpg1 do
    begin
      w:=textWidth(st);
      h:=textHeight(st);
      TextOut(xText,yText,st);
      invalidateRect1(rect(xText,yText,xText+w,yText+h));
      Xtext:=Xtext+w;
    end;

    font:=oldFontG;
    brush:=oldBrushG;
  end;
end;

procedure TmultiGform.Pg1writeln(st:AnsiString);
var
  w,h:integer;
begin
  with varPg1 do initGraphic(canvasPg1,cleft,ctop,cwidth,cheight);

  with canvasGlb,varPg1 do
  begin
    oldBrushG:=brush;
    brush.color:=curPageRec.BKcolorP;
    brush.style:=bsSolid;

    oldFontG:=font;
    font:=fontText;
    if curPageRec.BKcolorP=clBlack
      then font.color:=clWhite
      else font.color:=clBlack;

    w:=textWidth(st);
    h:=textHeight(st);
    TextOut(xText,yText,st);
    invalidateRect1(rect(xText,yText,xText+w,yText+h));

    Xtext:=XtextStart;
    Ytext:=Ytext+Htext;

    font:=oldFontG;
    brush:=oldBrushG;
  end;
end;

function TmultiGform.pg1WinCount(page:integer):integer;
begin
  if page=0
    then pg1WinCount:= pageRec[currentPage].cadreCount(1)
  else
  if (page>0) and (page<=pageCount)
    then pg1WinCount:= pageRec[Page-1].cadreCount(1)
  else sortieErreur(E_page);
end;

function TmultiGform.Pg1ClearObjects(page,w:integer):boolean;
var
  n:integer;
begin
  Pg1ClearObjects:=false;
  n:=w;

  if (page<0) or (page>=pageCount) then exit;
  if (w<0) or (w>=pageRec[page].cadreCount(1)) then exit;

  with PageREc[page].cadre[1,n] do
  begin
    libereObjets(pu);
    pu.free;
    pu:=nil;
    Cvalid:=false;
  end;
  Pg1ClearObjects:=true;
end;


procedure TMultiGform.pg1SavePage(num:integer;st:AnsiString);
begin
  controlePage(num);

  with pageRec[num] do
  begin
    try
      bmfen.saveToFile(st);
    except
      sortieErreur(E_ecriture);
    end;
  end;
end;

procedure TMultiGform.Savewin(win:integer;st:AnsiString;jpeg:boolean;Wtype:integer);
var
  bm:Tbitmap;
  jp:TjpegImage;
begin
  try
    bm:=Tbitmap.create;
    with curPageREc,cadre[Wtype,win],rect do
    begin
      bm.height:=bottom-top;
      bm.width:=right-left;
      bm.canvas.copyrect(classes.rect(0,0,bm.width-1,bm.height-1),bmfen.canvas,rect);
    end;

    if jpeg then
    begin
      try
        jp:=TjpegImage.create;
        jp.assign(bm);
        jp.compressionQuality:=100;
        jp.saveToFile(st);
      finally
        jp.free;
      end;
    end
    else bm.saveToFile(st);
  finally
    bm.Free;
  end;
end;


procedure TmultiGform.pg1SavePageAsJpeg(num:integer;st:AnsiString;quality:integer);
var
  hh:Thandle;
  jp:TjpegImage;
  bm0:Tbitmap;
begin
  controlePage(num);

  with pageRec[num] do
  begin
    try
    try
      bm0:=Tbitmap.create;
      begin
        bm0.height:=bmfen.Height;
        bm0.width:=bmfen.width;
        bm0.canvas.draw(0,0,bmfen);
      end;
      jp:=TjpegImage.create;
      jp.assign(bm0);
      jp.compressionQuality:=100;
      jp.saveToFile(st);
    finally
      jp.free;
      bm0.Free;
    end;
    except
      sortieErreur(E_saveJpeg);
    end;
  end;
end;

procedure TmultiGform.pg1SavePageAsPNG(num:integer;st:AnsiString);
{$IFDEF FPC}
type
  TpngObject =  TPortableNetworkGraphic;
{$ENDIF}
var
  hh:Thandle;
  png:TpngObject;
  bm0:Tbitmap;
begin
  controlePage(num);

  with pageRec[num] do
  begin
    try
    try
      bm0:=Tbitmap.create;
      begin
        bm0.height:=bmfen.Height;
        bm0.width:=bmfen.width;
        bm0.canvas.draw(0,0,bmfen);
      end;

      PNG := TPNGObject.Create;
      PNG.Assign(bm0);    //Convert data into png
      PNG.SaveToFile(st);
    finally
      PNG.free;
      bm0.Free;
    end;
    except
      sortieErreur(E_saveJpeg);
    end;
  end;
end;





procedure TMultiGform.Dividewindow1Click(Sender: TObject);
var
  rect1:Trect;
const
  nbxA:integer=2;
  nbyA:integer=2;
begin
  if not divideWin.execution(nbxA,nbyA) then exit;

  rect1:=curPageREc.cadre[1,rectCap].rect;
  with rect1 do
  begin
    if right-left<10*nbxA then exit;
    if bottom-top<10*nbyA then exit;
  end;

  Destroywindow1Click(nil);


  with rect1 do
    CurPageRec.DefineGrid(left,top,right,bottom,nbxA,nbyA,1,false);
end;


function TMultiGform.getBM:TbitmapEx;
begin
  getBM:=curPageREc.BMfen;
end;

procedure TMultiGform.invalidate;
begin
  invalidateRect(handle,nil,false);
  {le invalidate de Delphi doit appeler invalidateRect(handle,nil,true), ce qui
   efface d'abord la fenêtre avant de réafficher }
end;

procedure TMultiGform.controlePage(page:integer);
begin
  if (page<0) or (page>=pageCount) then sortieErreur(E_page);
end;

procedure TMultiGform.controlePageWin(page,win:integer);
begin
  controlePage(page);
  with pageRec[page] do
    if (win<0) or (win>=cadrecount(1)) then sortieErreur(E_invalidWin0);
end;


procedure TMultiGform.FormDeactivate(Sender: TObject);
begin
  FastCoo.reset;
end;

function TmultiGform.getCadre(num:integer):Trect;
begin
  with curPageREc do
  if (num>=0) and (num<cadrecount(1))
    then result:=cadre[1,num].rect
    else result:=rect(0,0,0,0);
end;



function TMultiGform.getUO(page, cadre, num,Wtype: integer): typeUO;
var
  list:Tlist;
begin
  list:=getP(page,cadre,Wtype);
  if assigned(list) and (num<list.Count)
    then result:=list[num]
    else result:=nil;
end;



procedure TMultiGform.XmouseDown(var message: Tmessage);
var
  p:Tpoint;
begin
  p:=classes.Point(message.WParam ,message.Lparam);
  p:=paintbox1.ScreenToClient(p);
  paintBox1MouseDown(nil,mbLeft,[ssLeft],p.x,p.y);
end;


procedure TMultiGform.XmouseMove(var message: Tmessage);
var
  p:Tpoint;
begin
  p:=classes.Point(message.WParam ,message.Lparam);
  p:=paintbox1.ScreenToClient(p);
  paintBox1MouseMove(nil,[ssLeft],p.x,p.y);
end;

procedure TMultiGform.XmouseUp(var message: Tmessage);
var
  p:Tpoint;
begin
  p:=classes.Point(message.WParam ,message.Lparam);
  p:=paintbox1.ScreenToClient(p);
  paintBox1MouseUp(nil,mbLeft,[ssLeft],p.x,p.y);
end;






procedure TMultiGform.Pages1Click(Sender: TObject);
 var
  i,k:integer;
  st:shortstring;
  list:TstringList;

  p:Tpoint;
const
  Ninit:integer=1;

begin
  p:=popMainPos;
  {
  if p.x<20 then p.X:=20;
  if p.x>screen.Width-100 then p.x:= screen.Width-100;
  if p.y<20 then p.y:=20;
  if p.y>screen.Height-100 then p.x:= screen.Height-100;
  }
  list:=TstringList.create;
  for i:=0 to tabPage1.tabs.Count-1 do list.Add(tabPage1.Tabs[i]);

  k:=ShowMenu1(self,'Pages',list, Ninit,p.x,p.y);
  if k>0 then SelectPage(k-1);
  list.free;
end;




function TMultiGform.InitDX9: boolean;
var
  i,res,quality:integer;
  k,q:integer;
begin
  result:=initDirect3D9lib and initD3DX9lib;
  //if not result then exit;

  IDX9 := Direct3DCreate9(D3D_SDK_VERSION);
  result:= (IDX9 <> nil);

  MultiSampleType:= D3DMULTISAMPLE_NONE;
  MultiSampleQuality:= 0;

  for i:=2 to 16 do
  begin
    res:=IDX9.CheckDeviceMultiSampleType(0,D3DDEVTYPE_HAL, D3DFMT_A8R8G8B8, true,  TD3DMultiSampleType(i), @q);
    if res=0 then
    begin
      MultiSampleType:=  TD3DMultiSampleType(i);
      MultiSampleQuality:= q-1;
    end;
  end;;

  //messageCentral('MultiSample:='+Istr( ord(multiSampleType))+'  quality='+Istr(MultiSampleQuality));
end;


function TMultiGform.InitDevice: boolean;
var
  res: integer;
begin
  result:=false;
  if IDX9=nil then exit;

  Idevice:=nil;
  renderSurface:=nil;
  InterSurface:=nil;

  FillChar(PresentParam, SizeOf(PresentParam), 0);
  PresentParam.Windowed := true;
  PresentParam.SwapEffect := D3DSWAPEFFECT_DISCARD;
  //PresentParam.hDeviceWindow:=Handle;
  PresentParam.BackBufferFormat := D3DFMT_A8R8G8B8;
  PresentParam.EnableAutoDepthStencil := True;
  PresentParam.AutoDepthStencilFormat := D3DFMT_D16;
  PresentParam.MultiSampleType := MultiSampleType;
  PresentParam.MultiSampleQuality := MultiSampleQuality;


  Res:= IDX9.CreateDevice( D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, handle, D3DCREATE_HARDWARE_VERTEXPROCESSING, @PresentParam, Idevice);

  setPrecisionMode(pmExtended);
  Result:= (res=0);
  if result then SetDeviceParams;

end;

function TMultiGform.TestDevice: boolean;
var
  hr: hresult;
  tt:integer;
begin
  result:=false;
  if Idevice=nil then exit;

  hr:=Idevice.TestCooperativeLevel;
  if FAILED(hr) then
  begin
    if assigned(FreeResources3D) then FreeResources3D;
    renderSurface:=nil;
    InterSurface:=nil;
    tt:=0;
    repeat
      delay(100);
      hr:= Idevice.Reset(PresentParam);
      tt:=tt+100;
      if tt>3000 then exit;
    until hr = 0 ;
    result:= (hr=0);

    SetDeviceParams;

  end
  else result:=true;
end;

procedure TMultiGform.SetDeviceParams;
var
  ViewPort: TD3DVIEWPORT9;

begin
  IDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_CCW);
  IDevice.SetRenderState(D3DRS_ZENABLE, iTrue);

  with ViewPort do
  begin
    x:=paintbox1.Left;
    y:=paintbox1.top;
    width:= paintbox1.width;
    height:= paintbox1.height;
    minZ:=0;
    maxZ:=1;
  end;
  Idevice.SetViewport(Viewport);

  // On crée une première RenderTarget du type MultiSample mais non lockable
  Idevice.CreateRenderTarget(PresentParam.BackBufferWidth,PresentParam.BackBufferHeight,D3DFMT_A8R8G8B8, MultiSampleType , MultiSampleQuality, false, renderSurface, Nil);
  Idevice.SetRenderTarget(0,renderSurface);

   // Puis on crée une seconde RenderTarget du type Non MultiSample mais lockable
  Idevice.CreateRenderTarget( PresentParam.BackBufferWidth,PresentParam.BackBufferHeight,D3DFMT_A8R8G8B8, D3DMULTISAMPLE_NONE, 0,true, InterSurface, nil);

  //  Pendant le render
  //        - on va créer l'image sur renderSurface
  //        - on va la copier sur InterSurface
  //        - puis on va la copier sur bmfen
end;



(*
procedure TMultiGform.MessageEnterSizeMove(var message: Tmessage);
begin
  DragSizeMode:= true;
  inherited;
  AffDebug('EnterSizeMove',131);
end;

procedure TMultiGform.ExitEnterSizeMove(var message: Tmessage);
begin
  DragSizeMode:= false;
  Frestored:=true;
  inherited;
  AffDebug('ExitSizeMove',131);
end;


procedure TMultiGform.MessageWPchanged(var message: Tmessage);
begin
  flagPos:=false;
  Affdebug('Wm_Size ',131);
  inherited;
end;

procedure TMultiGform.MessageWPchanging(var message: Tmessage);
begin
  flagPos:=true;
  Affdebug('Ww_sizing ',131);
  inherited;
end;

procedure TMultiGform.MessageWmSize(var message: Tmessage);
begin
  case message.WParam of
    SIZE_RESTORED: begin
                     Frestored:=true;
                   end;
  end;
  inherited;

end;
*)


procedure TMultiGform.MessagePosDlg(var message: Tmessage);
var
  cnt:integer;
  msg: Tmsg;
begin
  posDialogs;

  cnt:=0;
  while peekMessage(msg,self.Handle,msg_posDialogs,msg_posDialogs,pm_remove) do inc(cnt);
  affdebug('MessageposDlg '+Istr(cnt),131);
end;

procedure TMultiGform.CreateSimpleMultigraph1Click(Sender: TObject);
begin
  if assigned(CreateSimpleMultigraph) then CreateSimpleMultigraph;
end;

procedure TMultiGform.CreateObjectList1Click(Sender: TObject);
begin
  if assigned(CreateObjectList) then CreateObjectList;
end;

procedure TMultiGform.SavePage1Click(Sender: TObject);
begin
  if assigned(SavePageAsObjectFile) then SavePageAsObjectFile;
end;

procedure TMultiGform.LoadPage1Click(Sender: TObject);
begin
  if assigned(LoadPageFromObjectFile) then LoadPageFromObjectFile;
end;

procedure TMultiGform.MultigraphList1Click(Sender: TObject);
var
  i,k:integer;
  st:shortstring;
  list:TstringList;

  p:Tpoint;
const
  Ninit:integer=1;

begin
  if not assigned(getMultigraphList) then exit;

  p:=popMainPos;

  list:= getMultigraphList;
  k:=ShowMenu1(self,'Multigraphs',list, Ninit,p.x,p.y);
  if k>0 then typeUO(list.objects[k-1]).show(self) ;
  list.free;
end;




Initialization
AffDebug('Initialization multg0',0);

installError(E_invalidWin0,'Multigraph:Invalid window number');
installError(E_setWorld,'Multigraph: invalid setWorld parameters');
installError(E_page,'Multigraph: invalid page number');
installError(E_selectWindow,'Multigraph.selectWindow: vector is not on screen');
installError(E_defineWindow,'Multigraph.defineWindow: invalid parameter');
installError(E_defineGrid,'Multigraph.defineGrid: invalid parameter');

installError(E_saveJpeg,'Multigraph.savePageAsJpeg: unable to save as JPEG');

{$IFDEF FPC}
{$I Multg0.lrs}
{$ENDIF}
end.
