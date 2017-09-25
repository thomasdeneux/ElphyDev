unit Multg1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,forms,controls,Dialogs,menus,extCtrls,sysutils,

     {$IFDEF DX11 } {$ELSE} DXTypes, Direct3D9G, D3DX9G, {$ENDIF}
     util1,Dgraphic,DdosFich,BMex1,
     stmDef,stmObj,multg0,getVect0,defForm,varconf1,formrec0,
     stmData0,stmPlot1,stmDplot,
     inimulg0,formMenu,fontEx0,
     Ncdef2,debug0,stmError,
     stmU1,
     stmPopUp,
     stmCurs,stmCooX1,
     stmPg,ObjFile1,
     stmDlg,
     dacInsp1,
     visu0,
     stmObjList1;
     

{
Tmultigraph gère une fenêtre du genre Acquis1. La fenêtre peut contenir
un nombre quelconque de sous-fenêtres (les cadres), et chaque sous-fenêtre
peut contenir un nombre quelconque d'objets.

Les objets peuvent afficher n'importe quoi avec leurs méthodes
  display
  displayTitle
  displayInside

Gestion des clicks souris:
Double-click gauche: fait apparaitre un menu popup spécifique à l'objet
  multigraph: options, design, etc...

Click droite:
  - en mode design, fait apparaitre un popup qui permet d'ajouter
  ou d'enlever un cadre.
  - sinon, fait apparaitre un popup spécifique à l'objet contenu dans le cadre.
  Quand il y a plusieurs objets dans le cadre, le popup contient d'abord la
  liste des objets, et chaque sous-menu est le popup spécifique à l'objet.
}

type

  TmultiGraph=class(Tdata0)
              protected
                pop:TpopUpMenu;    {id}
                posWin:PposWin;    {pointe sur un buffer qui reçoit les données
                                    à sauver ou charger}
                sizewin:integer;   {taille de ce buffer}
                FnewPosWin:boolean;

                UOcap:typeUO;      {objet capturé par la souris}

                OldcanvasGlb:Tcanvas;
                Oldx1act,Oldy1act,Oldx2act,Oldy2act:integer;

                DlgList:Tlist;


                procedure mouseDownRightG(numC:integer;Shift: TShiftState;
                                xc,yc,x,y,numCadre:integer);
                procedure mouseDownLeftG(numC:integer;Shift: TShiftState;xc,yc,x,y:integer);

                procedure mouseMoveLeftG(x,y:integer);
                procedure mouseUpLeftG(x,y:integer);

                procedure Do3D(plot:typeUO;rect0:Trect);
                
                procedure displayG(pageRec:TpageRec;numW,NumList:integer);
                procedure displayEmptyG(pageRec:TpageRec;numW,numList:integer);
                procedure displayG1(p:pointer;extWorld,logX,logY:boolean;mode,taille:integer);
                procedure removeG(p:pointer);
                procedure displayTitle(st:AnsiString;num,col:integer);
                procedure displayNum(num:integer);
                procedure setWindowInG(listU:Tlist);
                procedure installProcs;
                procedure SaveWindowBMPClick(sender:Tobject);
                procedure SaveWindowJPEGClick(sender:Tobject);

                procedure ShowTitlesHint(x,y:integer;listU:Tlist);

                procedure CreateSimpleMG;
                procedure CreateObjList;

                procedure setCaption(st:AnsiString);
                function getCaption:AnsiString;

                procedure setIdent(st:AnsiString);override;
              public
                Fdestroying: boolean;
                DumShowTitle: boolean;

                property caption: AnsiString read getCaption write setCaption;
                function formG:TmultiGform;
                function ExtForm:boolean;

                procedure createOld;
                constructor create;override;
                constructor createWithForm(form1:TmultiGform);

                class function STMClassName:AnsiString;override;

                procedure init(nx,ny:integer);
                destructor destroy;override;

                function DialogForm:TclassGenForm;override;
                procedure installDialog(var form:Tgenform;var newF:boolean);
                                   override;

                function addObjectOnGrid(page,i,j:integer;u:typeUO;Wtype:integer;mode2:boolean):boolean;
                function addObject(page,i:integer;u:typeUO; Wtype:integer;mode2:boolean):boolean;

                function addMGDialog(u:Tdialog; AlignMode:TcdAlign ):boolean;
                procedure UpdateMGDialogs;
                procedure ClearMGdialogs;

                function initialise(st:AnsiString):boolean;override;

                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                procedure completeLoadInfo;override;
                procedure completeSaveInfo;override;

                function dragOverG(source:Tobject):boolean;virtual;
                procedure dragDropG(source:Tobject;num:integer);
                procedure SpecialdragDropG(firstObj,dest:pointer;x,y:integer);

                procedure RetablirReferences(list:Tlist);override;
                procedure ClearReferences;override;
                procedure ResetAll;override;

                procedure processMessage(id:integer;source:typeUO;p:pointer);
                    override;

                procedure show(sender:Tobject);override;

                procedure resetForm;
                procedure FdrawCursor(list:Tlist;bmDest:TbitmapEx);

                procedure Defaults;

                procedure test;
                procedure FreeResources3DG;

                procedure MgFromPage(mg:Tmultigraph;ObjList:TobjectList; numPage:integer);
                procedure MgFromWindow(mg:Tmultigraph;ObjList:TobjectList; numPage,NumW:integer);
                procedure CreateMgFromWindow(sender: Tobject);
                procedure CreateObjListFromWindow(sender: Tobject);

                procedure SavePageAsObjFile;
                procedure LoadPageFromObjFile;

                function getMgList: TstringList;
              end;


 {
 TmultiGraphDAC est identique à TmultiGraph mais la fenêtre utilisée est la
 fenêtre principale de l'application formStm.
 Dans ce cas, formStm doit être du type TmultiGform.
 }

  TmultiGraphDAC=class(Tmultigraph)
    constructor create;override;
    class function STMClassName:AnsiString;override;
    procedure completeLoadInfo;override;

  end;


function multigraph0:Tmultigraph;



procedure proTmultiGraph_create(name:AnsiString;nx,ny:integer;var pu:typeUO);pascal;
procedure proTmultiGraph_create_1(nx,ny:integer;var pu:typeUO);pascal;
procedure proTmultiGraph_create_2(var pu:typeUO);pascal;

procedure proTmultiGraph_screenNum(i:integer;var pu:typeUO);pascal;

function fonctionTmultiGraph_screenNum(var pu:typeUO):integer;pascal;
procedure proTmultiGraph_selectScreen(i:integer;var pu:typeUO);pascal;

procedure proTmultiGraph_initGrid(page,i,j:integer;var pu:typeUO);pascal;
procedure proTmultiGraph_addObjectOnGrid(page,i,j:integer;var u,pu:typeUO);pascal;
procedure proTmultiGraph_addObject(page,i:integer;var u,pu:typeUO);pascal;

procedure proTmultiGraph_addDialog(page,i:integer;var u,pu:typeUO);pascal;
procedure proTmultiGraph_addObjectEx(page,i:integer;var u,pu:typeUO);pascal;
procedure proTmultiGraph_addObjectEx_1(page,i:integer;var u:typeUO; mode:integer;var pu:typeUO);pascal;

procedure proTmultiGraph_addCursor(page,i:integer;var u,pu:typeUO);pascal;


procedure proTmultiGraph_addMGDialog(AlignMode:integer; var u,pu:typeUO);pascal;
procedure proTmultiGraph_ClearMGDialogs(var pu:typeUO);pascal;

procedure proTmultiGraph_clearObjects(page,i:integer;var pu:typeUO);pascal;
procedure proTmultiGraph_color(x:longint;var pu:typeUO);pascal;
function fonctionTmultiGraph_color(var pu:typeUO):longint;pascal;

procedure proTmultiGraph_caption(st:AnsiString;var pu:typeUO);pascal;
function fonctionTmultiGraph_caption(var pu:typeUO):AnsiString;pascal;

procedure proTmultiGraph_refresh(var pu:typeUO);pascal;
procedure proTmultiGraph_update(var pu:typeUO);pascal;
procedure proTmultiGraph_updatePages(var pu:typeUO);pascal;

procedure proTmultiGraph_show(var pu:typeUO);pascal;

procedure proTmultiGraph_Droite(a,b:float;var pu:typeUO);pascal;
procedure proTmultiGraph_Line(x1,y1,x2,y2:float;var pu:typeUO);pascal;
procedure proTmultiGraph_lineTo(x,y:float;var pu:typeUO);pascal;
procedure proTmultiGraph_moveto(x,y:float;var pu:typeUO);pascal;
procedure proTmultiGraph_LineVer(x0:float;var pu:typeUO);pascal;
procedure proTmultiGraph_LineHor(y0:float;var pu:typeUO);pascal;

procedure proTmultiGraph_setWindow(num:integer;var pu:typeUO);pascal;
function fonctionTmultiGraph_getWindow(var pu:typeUO):integer;pascal;
procedure proTmultiGraph_getWindowPos(page,win:integer;var x1,y1,x2,y2:Integer;var pu:typeUO);pascal;

procedure proTmultiGraph_selectWindow(var p:typeUO;var pu:typeUO);pascal;
procedure proTmultiGraph_setWindowEx(x1,y1,x2,y2:integer;var pu:typeUO);pascal;
procedure proTmultiGraph_getWindowEx(var x1,y1,x2,y2:Integer;var pu:typeUO);pascal;

procedure proTmultiGraph_selectWorld(var p:typeUO;var pu:typeUO);pascal;
procedure proTmultiGraph_setWorld(x1,y1,x2,y2:float;var pu:typeUO);pascal;
procedure proTmultiGraph_getWorld(var x1,y1,x2,y2:float;var pu:typeUO);pascal;
procedure proTmultiGraph_clearWindow(tout:boolean;var pu:typeUO);pascal;
procedure proTmultiGraph_DrawBorder(var pu:typeUO);pascal;
procedure proTmultiGraph_DrawBorderOut(var pu:typeUO);pascal;

procedure proTmultiGraph_OutText(x,y:integer;st:AnsiString;var pu:typeUO);pascal;
procedure proTmultiGraph_OutTextW(x,y:integer;st:AnsiString;var pu:typeUO);pascal;
procedure proTmultiGraph_SetClippingON(var pu:typeUO);pascal;
procedure proTmultiGraph_SetClippingOff(var pu:typeUO);pascal;

procedure proTmultiGraph_Graduations(stX,stY:AnsiString;echX,echY:boolean;var pu:typeUO);pascal;
procedure proTmultiGraph_setcolor(num:integer;var pu:typeUO);pascal;
procedure proTmultiGraph_setWriteMode(mode:integer;var pu:typeUO);pascal;
procedure proTmultiGraph_AfficherSymbole(x,y:float;numSymb,taille:integer;var pu:typeUO);pascal;

procedure proTmultiGraph_clearScreen(var pu:typeUO);pascal;
procedure proTmultiGraph_resetScreen(var pu:typeUO);pascal;
function fonctionTmultigraph_GetWin(var p:pointer;var pu:typeUO):integer;pascal;

function fonctionTmultigraph_winCount(page:integer;var pu:typeUO):integer;pascal;


procedure proTmultiGraph_DisplayObject(var ob,pu:typeUO);pascal;
procedure proTmultiGraph_SetVectorMode(mode,taille:integer;var pu:typeUO);pascal;
procedure proTmultiGraph_SetLogMode(logx,logy:boolean;var pu:typeUO);pascal;

procedure proTmultiGraph_Pencolor(n:integer;var pu:typeUO);pascal;
function fonctionTmultiGraph_Pencolor(var pu:typeUO):integer;pascal;

procedure proTmultiGraph_PenMode(n:integer;var pu:typeUO);pascal;
function fonctionTmultiGraph_PenMode(var pu:typeUO):integer;pascal;

procedure proTmultiGraph_PenWidth(n:integer;var pu:typeUO);pascal;
function fonctionTmultiGraph_PenWidth(var pu:typeUO):integer;pascal;

procedure proTmultiGraph_VectorMode(n:integer;var pu:typeUO);pascal;
function fonctionTmultiGraph_VectorMode(var pu:typeUO):integer;pascal;

procedure proTmultiGraph_symbolSize(n:integer;var pu:typeUO);pascal;
function fonctionTmultiGraph_symbolSize(var pu:typeUO):integer;pascal;

procedure proTmultiGraph_LogX(n:boolean;var pu:typeUO);pascal;
function fonctionTmultiGraph_LogX(var pu:typeUO):boolean;pascal;

procedure proTmultiGraph_LogY(n:boolean;var pu:typeUO);pascal;
function fonctionTmultiGraph_LogY(var pu:typeUO):boolean;pascal;

function fonctionTmultiGraph_Font(var pu:typeUO):pointer;pascal;

procedure proTmultiGraph_Transparent(n:boolean;var pu:typeUO);pascal;
function fonctionTmultiGraph_Transparent(var pu:typeUO):boolean;pascal;

procedure proTmultigraph_AfficherTrace(var S:TypeUO;var pu:typeUO);pascal;



function fonctionTmultiGraph_DefineWindow(page,x1,y1,x2,y2:integer;var pu:typeUO):integer;
            pascal;
function fonctionTmultiGraph_DefineGrid(page,x1,y1,x2,y2,nx,ny:integer;var pu:typeUO):integer;
            pascal;


procedure proTmultiGraph_PageWidth(w:integer;var pu:typeUO); pascal;
function fonctionTmultiGraph_PageWidth(var pu:typeUO):integer; pascal;

procedure proTmultiGraph_PageHeight(w:integer;var pu:typeUO); pascal;
function fonctionTmultiGraph_PageHeight(var pu:typeUO):integer; pascal;

function fonctionTmultiGraph_PageLeft(var pu:typeUO):integer;pascal;
function fonctionTmultiGraph_PageTop(var pu:typeUO):integer;pascal;

procedure proTmultiGraph_savePage(st:AnsiString;var pu:typeUO); pascal;
procedure proTmultiGraph_savePageAsPNG(st:AnsiString;var pu:typeUO); pascal;
Procedure proTmultiGraph_SavePageAsJPEG(st:AnsiString;quality:integer;
                                        var pu:typeUO); pascal;
procedure proTmultiGraph_DestroyAllWindows(page:Integer;var pu:typeUO);pascal;
procedure proTmultiGraph_PrintCurrentPage(var pu:typeUO);pascal;

function fonctionTmultiGraph_NewWindow(page,x,y:integer;var pu:typeUO):integer;pascal;

procedure proTmultiGraph_divideWindow(page,num,nx,ny:integer;var pu:typeUO);pascal;
procedure proTmultiGraph_destroyWindows(page,num,cnt:integer;var pu:typeUO);pascal;

procedure proTmultiGraph_setXworld(x1,y1,x2:float;Fup:boolean;var pu:typeUO);pascal;
procedure proTmultiGraph_VSrectangle(x,y,dx,dy,theta:float;var pu:typeUO);pascal;


{---------------------}
function fonctionTmultigraph_MgPage(st:AnsiString;var pu:typeUO):pointer;pascal;
function fonctionTmultigraph_MgPage_1(n:integer;var pu:typeUO):pointer;pascal;
function fonctionTmultigraph_PageCount(var pu:typeUO):integer;pascal;

procedure proTmultiGraph_selectPage(st:AnsiString;var pu:typeUO);pascal;
procedure proTmultigraph_AddPage(stname:AnsiString;var pu:typeUO);pascal;
procedure proTmultigraph_InsertPage(num:integer;stname:AnsiString;var pu:typeUO);pascal;
procedure proTmultigraph_DeletePage(stname:AnsiString;var pu:typeUO);pascal;
procedure proTmultigraph_DeleteAllPages(stname:AnsiString;var pu:typeUO);pascal;
function fonctionTmultigraph_PageIndex(st:AnsiString;var pu:typeUO):integer;pascal;

{----------------------}
procedure proTMGpage_color(w:integer;pu:typeUO);pascal;
function fonctionTMGpage_color(pu:typeUO):integer;pascal;

function fonctionTMGpage_name(pu:typeUO):AnsiString;pascal;

procedure proTMGpage_ScaleColor(w:integer;pu:typeUO);pascal;
function fonctionTMGpage_ScaleColor(pu:typeUO):integer;pascal;

function fonctionTMGpage_font(pu:typeUO):Tfont;pascal;
function fonctionTMGpage_PageFont(pu:typeUO):boolean;pascal;
procedure proTMGpage_PageFont(w:boolean;pu:typeUO);pascal;

function fonctionTMGpage_ShowTitles(pu:typeUO):boolean;pascal;
procedure proTMGpage_ShowTitles(w:boolean;pu:typeUO);pascal;

function fonctionTMGpage_ShowOutlines(pu:typeUO):boolean;pascal;
procedure proTMGpage_ShowOutLines(w:boolean;pu:typeUO);pascal;

function fonctionTMGpage_ShowNumbers(pu:typeUO):boolean;pascal;
procedure proTMGpage_ShowNumbers(w:boolean;pu:typeUO);pascal;




procedure proTMGpage_initGrid(nx,ny:integer;pu:typeUO);pascal;
procedure proTMGpage_initGrid_1(nx,ny,Wtype:integer;pu:typeUO);pascal;


procedure proTMGpage_addObjectOnGrid(i,j:integer;var plot:Tplot;pu:typeUO);pascal;
procedure proTMGpage_addObjectOnGrid_1(i,j:integer;var plot:Tplot;Wtype:integer;pu:typeUO);pascal;


procedure proTMGpage_addObject(w:integer;var u:Tplot;pu:typeUO);pascal;
procedure proTMGpage_addObject_1(w:integer;var u:Tplot;Wtype:integer;pu:typeUO);pascal;

procedure proTMGpage_addDialog(w:integer;var u:Tdialog;pu:typeUO);pascal;
procedure proTMGpage_addObjectEx(w:integer;var u:TypeUO;pu:typeUO);pascal;
procedure proTMGpage_addObjectEx_1(w:integer;var u:TypeUO;mode: integer; pu:typeUO);pascal;

procedure proTMGpage_addCursor(w:integer;var u:TLcursor;pu:typeUO);pascal;

procedure proTMGpage_ClearObjects(w:integer;pu:typeUO);pascal;
procedure proTMGpage_ClearObjects_1(w:integer;Wtype:integer; pu:typeUO);pascal;

procedure proTMGpage_getWindowPos(win:integer;var x1,y1,x2,y2:integer;pu:typeUO);pascal;
function fonctionTMGpage_GetWin(var p:Tplot;pu:typeUO):integer;pascal;

function fonctionTMGpage_winCount(pu:typeUO):integer;pascal;
function fonctionTMGpage_winCount_1(Wtype:integer; pu:typeUO):integer;pascal;

function fonctionTMGpage_DefineWindow(x1,y1,x2,y2:integer;pu:typeUO):integer;pascal;
function fonctionTMGpage_DefineWindow_1(x1,y1,x2,y2:integer;Wtype:integer;Fback:boolean;pu:typeUO):integer;pascal;

function fonctionTMGpage_DefineGrid(x1,y1,x2,y2,nx,ny:integer;pu:typeUO):integer;pascal;
function fonctionTMGpage_DefineGrid_1(x1,y1,x2,y2,nx,ny,Wtype:integer;pu:typeUO):integer;pascal;

procedure proTMGpage_DestroyAllWindows(pu:typeUO);pascal;
procedure proTMGpage_DestroyAllWindows_1(Wtype:Integer;pu:typeUO);pascal;


Procedure proTMGpage_SaveAsBMP(st:AnsiString;pu:typeUO);pascal;
Procedure proTMGpage_SaveAsPNG(st:AnsiString;pu:typeUO);pascal;
Procedure proTMGpage_SaveAsJPEG(st:AnsiString;quality:integer;pu:typeUO);pascal;
Procedure proTMGpage_SaveAsEmf(st:AnsiString;pu:typeUO);pascal;

procedure proTMGpage_Print(pu:typeUO);pascal;

procedure proTMGpage_divideWindow(Win,nx,ny:integer;pu:typeUO);pascal;
procedure proTMGpage_divideWindow_1(Win,nx,ny,Wtype:integer;pu:typeUO);pascal;

function fonctionTMGpage_newWindow(x,y:integer;pu:typeUO):integer;pascal;

procedure proTMGpage_destroyWindows(win,count:integer;pu:typeUO);pascal;
procedure proTMGpage_destroyWindows_1(win,count,Wtype:integer;pu:typeUO);pascal;

procedure proTMGpage_WinAlign(win,value:integer;pu:typeUO);pascal;
function fonctionTMGpage_WinAlign(win:integer;pu:typeUO):integer;pascal;

procedure proTMultigraph_WinAlign(page1,win,value:integer;var pu:typeUO);pascal;
function fonctionTMultigraph_WinAlign(page1,win:integer;var pu:typeUO):integer;pascal;

procedure proTMultigraph_ToolbarVisible(value:boolean;var pu:typeUO);pascal;
function fonctionTMultigraph_ToolbarVisible(var pu:typeUO):boolean;pascal;

function fonctionTMultigraph_CurMgPage(var pu:typeUO):pointer;pascal;

function fonctionTMgPage_UseVparams(pu:typeUO):boolean;pascal;
procedure proTMgPage_UseVparams(w:boolean; pu:typeUO);pascal;
function fonctionTMgPage_Vparams(pu:typeUO):pointer;pascal;


procedure proTMGpage_Vflag(n:integer;w:boolean; pu:typeUO);pascal;
function fonctionTMGpage_Vflag(n:integer; pu:typeUO): boolean;pascal;

function fonctionTmgVparams_Xmin( pu:typeUO): float;pascal;
procedure proTmgVparams_Xmin(w:float; pu:typeUO);pascal;
function fonctionTmgVparams_Xmax( pu:typeUO): float;pascal;
procedure proTmgVparams_Xmax(w:float; pu:typeUO);pascal;
function fonctionTmgVparams_Ymin( pu:typeUO): float;pascal;
procedure proTmgVparams_Ymin(w:float; pu:typeUO);pascal;
function fonctionTmgVparams_Ymax( pu:typeUO): float;pascal;
procedure proTmgVparams_Ymax(w:float; pu:typeUO);pascal;

function fonctionTmgVparams_color( pu:typeUO): longint;pascal;
procedure proTmgVparams_color(w:longint; pu:typeUO);pascal;
function fonctionTmgVparams_color2( pu:typeUO): longint;pascal;
procedure proTmgVparams_color2(w:longint; pu:typeUO);pascal;

function fonctionTmgVparams_mode( pu:typeUO): longint;pascal;
procedure proTmgVparams_mode(w:longint; pu:typeUO);pascal;

function fonctionTmgVparams_SymbolSize( pu:typeUO): longint;pascal;
procedure proTmgVparams_SymbolSize(w:longint; pu:typeUO);pascal;

function fonctionTmgVparams_LineWidth( pu:typeUO): longint;pascal;
procedure proTmgVparams_LineWidth(w:longint; pu:typeUO);pascal;

procedure proTmgVparams_LogX(x:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_LogX( pu:typeUO):boolean;pascal;

procedure proTmgVparams_LogY(x:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_LogY( pu:typeUO):boolean;pascal;

procedure proTmgVparams_Xscale(x:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_Xscale( pu:typeUO):boolean;pascal;

procedure proTmgVparams_Yscale(x:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_Yscale( pu:typeUO):boolean;pascal;

procedure proTmgVparams_Xticks(x:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_Xticks( pu:typeUO):boolean;pascal;

procedure proTmgVparams_Yticks(x:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_Yticks( pu:typeUO):boolean;pascal;

procedure proTmgVparams_ExtTicksX(x:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_ExtTicksX( pu:typeUO):boolean;pascal;

procedure proTmgVparams_ExtTicksY(x:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_ExtTicksY( pu:typeUO):boolean;pascal;

procedure proTmgVparams_RightTicks(x:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_RightTicks( pu:typeUO):boolean;pascal;

procedure proTmgVparams_TopTicks(x:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_TopTicks( pu:typeUO):boolean;pascal;


procedure proTmgVparams_ZeroAxisX(x:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_ZeroAxisX( pu:typeUO):boolean;pascal;
procedure proTmgVparams_ZeroAxisY(x:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_ZeroAxisY( pu:typeUO):boolean;pascal;


procedure proTmgVparams_keepAspectRatio(b:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_keepAspectRatio( pu:typeUO):boolean;pascal;
procedure proTmgVparams_inverseX(b:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_inverseX( pu:typeUO):boolean;pascal;
procedure proTmgVparams_inverseY(b:boolean; pu:typeUO);pascal;
function fonctionTmgVparams_inverseY( pu:typeUO):boolean;pascal;


implementation

uses NewMGlist1;

var
  E_page:integer;
  E_pageOrWindow:integer;
  E_initGrid:integer;
  E_newWindow:integer;

var
  mgList: Tlist;


procedure TmultiGraph.installProcs;
begin
  with formG do
  begin
    mgOwner:=self;

    mouseDownRight:=mouseDownRightG;
    mouseDownLeft:=mouseDownLeftG;
    mouseMoveLeft:=mouseMoveLeftG;
    mouseUpLeft:=mouseUpLeftG;

    displayInWindow:=DisplayG;
    displayEmpty:=displayEmptyG;
    displayIn:=DisplayG1;
    setWindowIn:=setWindowInG;
    dragOver:=dragOverG;
    dragDrop:=dragDropG;
    SpecialdragDrop:=SpecialdragDropG;

    FreeResources3D:= FreeResources3DG;

    libereObjet:=removeG;
    CreateSimpleMultigraph:= CreateSimpleMG;
    CreateObjectList:= CreateObjList;

    SavePageAsObjectFile:= SavePageAsObjFile;
    LoadPageFromObjectFile:= LoadPageFromObjFile;
    getMultigraphList:=  getMgList;

  end;
end;

procedure TmultiGraph.createOld;
begin
  inherited create;
end;

constructor TmultiGraph.create;
begin
  inherited create;

  MgList.Add(self);

  form:=TmultiGForm.create(FormStm);
  installProcs;

  DlgList:=Tlist.Create;
end;

constructor TmultiGraph.createWithForm(form1:TmultiGform);
begin
  inherited create;

  MgList.Add(self);
  form:=form1;
  CanDestroyForm:=false;
  //form.parent:=formStm;
  installProcs;
  DlgList:=Tlist.Create;
end;

function Tmultigraph.formG:TmultiGform;
begin
  result:=TmultiGform(form);
end;

function Tmultigraph.ExtForm:boolean;
begin
  result:=not canDestroyForm;
end;

class function TmultiGraph.STMClassName:AnsiString;
begin
  STMClassName:='MultiGraph';
end;

procedure TmultiGraph.init(nx,ny:integer);
begin
  if not ExtForm then
  begin
    caption:=ident;
    formG.FormStyle:= fsStayOnTop;
  end;
  with formG do initGrid(currentpage,nx,ny);
  {affdebug('MG init');}
end;

destructor TmultiGraph.destroy;
var
  i,j,p,wt:integer;
  listU:Tlist;
  uo:typeUO;
begin

  {affDebug('MG destroy');}
  with formG do
  begin
    Fdestroying:=true;

    for p:=0 to pageCount-1 do
    for wt:=1 to 2 do
      for i:=0 to count(p,wt)-1 do
        begin
          listU:=getP(p,i,wt);
          if assigned(listU) then
            for j:=0 to listU.count-1 do
              begin
                uo:=typeUO(listU.items[j]);
                if assigned(uo) then uo.UnActiveEmbedded;
                if assigned(uo)
                  then affDebug('Multigraph.Destroy '+uo.ident+' '+Istr(p)+'/'+Istr(i)+'/'+Istr(j),1 )
                  else affDebug('Multigraph.Destroy uo=nil '+uo.ident+' '+Istr(p)+'/'+Istr(i)+'/'+Istr(j),1 );

                derefObjet(uo);
                listU.items[j]:=nil;
              end;
        end;
  {affDebug('Finito deref');}
  end;

  for i:=0 to DlgList.Count-1 do
  begin
    uo:=dlgList[i];
    Tdialog(uo).dlg.Parent:=nil;
    derefObjet(uo);
  end;

  formG.Fdestroying:=false;

  if ExtForm then formG.reset;

  pop.free;
  DlgList.Free;

  MgList.remove(self);
  inherited destroy;
end;


function Tmultigraph.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetVector;
end;

procedure TmultiGraph.installDialog(var form:Tgenform;var newF:boolean);
begin
  installForm(form,newF);

  TgetVector(Form).onshowD:=show;
end;

function TmultiGraph.addObjectOnGrid(page,i,j:integer;u:typeUO;Wtype:integer;mode2:boolean):boolean;
begin
  result:=formG.addOnGrid(Page,i,j,u,Wtype,mode2);
  if result then refObjet(u);
end;

function TmultiGraph.addObject(page,i:integer;u:typeUO;Wtype:integer;mode2:boolean):boolean;
begin
  result:=false;
  with formG do
  begin
    if (page<0) or (page>=pageCount) then exit;
    if (i<0) or (i>=count(page,1)) then exit;
  end;

  with formG do
  begin
    if formG.addObject(Page,i,u, Wtype,mode2) then refObjet(u);
  end;

  result:=true;
end;

function TmultiGraph.addMGDialog(u: Tdialog; AlignMode: TcdAlign): boolean;
begin
  result:=false;
  if dlgList.IndexOf(u)>=0 then exit;

  case AlignMode of
    cdAlTop:     u.dlg.Align:=alTop;
    cdAlBottom:  u.dlg.Align:=alBottom;
    cdAlLeft:    u.dlg.Align:=alLeft;
    cdAlRight:   u.dlg.Align:=alRight;
    else exit;
  end;

  u.dlg.BorderStyle:=bsNone;
  u.dlg.Parent:=nil;
  DlgList.Add(u);
  refObjet(u);

  result:=true;
  UpdateMGDialogs;
end;

procedure Tmultigraph.UpdateMGDialogs;
var
  i:integer;
begin
  with formG do
  begin
    paintBox1.Align:=AlNone;
    for i:=0 to dlgList.Count-1 do
      Tdialog(dlgList[i]).dlg.Parent:=nil;

    for i:=0 to dlgList.Count-1 do
    begin
      Tdialog(dlgList[i]).dlg.Parent:=formG;
      Tdialog(dlgList[i]).dlg.Visible:=true;
    end;
    paintBox1.Align:=AlClient;
  end;
end;

procedure Tmultigraph.ClearMGDialogs;
var
  i:integer;
begin
  for i:=0 to DlgList.Count-1 do
     Tdialog(dlgList[i]).dlg.Parent:=nil;
end;

procedure TmultiGraph.ShowTitlesHint(x,y:integer;listU:Tlist);
var
  stHint:AnsiString;
  i:integer;
begin
  stHint:='';
  for i:=0 to listU.count-1 do
    begin
      stHint:=stHint+typeUO(listU[i]).title;
      if i<>listU.count-1 then stHint:=stHint+crlf;
    end;


  ShowStmHint(x,y,stHint);
end;

{
mouseDownLeftG est appelée en cas de click gauche dans un cadre design off
on reçoit le numéro du cadre
          les coordonnées écran du cadre
          et la position de la souris en coordonnées cadre.
On appelle les méthodes MouseDownMG des objets de la liste.
}
procedure TmultiGraph.mouseDownLeftG(numC:integer;Shift: TShiftState;xc,yc,x,y:integer);
var
  i:integer;
  x1,y1,x2,y2:integer;
  Irect:Trect;
  Fworld,FlogX,FlogY:boolean;
  x1w,y1w,x2w,y2w:float;
  p:Tpoint;
  listU:Tlist;
  curfont:Tfont;
begin

  listU:=formG.curPageRec.cadre[1,numC].pu;
  if not assigned(listU) or (listU.count=0) then exit;

  Irect:=formG.curPageRec.getInsideWindow(numC,1);
  getWindowG(x1,y1,x2,y2);

  if (ssAlt in shift) and not (ssCtrl in Shift) then
  begin
    ShowTitlesHint(xc+x ,yc+y,listU);
    exit;
  end;


  x1w:=0;
  y1w:=0;
  x2w:=100;
  y2w:=100;
  if Tplot(listU.items[0]).withInside then
    Tplot(listU.items[0]).getWorldPriorities(Fworld,FlogX,FlogY,x1w,y1w,x2w,y2w);

  {La fenêtre courante est le cadre.
   Irect contient le rectangle intérieur
   Le world courant est celui du premier objet.
   xc et yc sont les coordonnées écran du cadre
   x et y sont les coordonnées du curseur dans le cadre
  }


  { On appelle mouseDownMG de tous les objets du cadre. On s'arrête quand
    la méthode renvoie true. Cet objet devient l'objet capturé UOcap.
    Plus tard, mouseMoveMG et mouseUpMg seront appelés pour UOcap.
  }
  UOcap:=nil;

  if formG.curpageRec.PageFontP then
  begin
    curFont:=Tfont.create;
    curfont.Assign(formG.curpageRec.fontP);
  end
  else curFont:=nil;

  TRY
  for i:=0 to listU.count-1 do
    begin
      setWorld(x1w,y1w,x2w,y2w);
      with typeUO(listU.items[i]) do
      begin
        if assigned(curfont) then swapFont(curFont,formG.CurpageRec.ScaleColorP);

        if MouseDownMG(i,Irect, Shift, xc,yc, x,y) or HasMgClickEvent then
        begin
          UOcap:=typeUO(listU.items[i]);
          if assigned(curfont) then swapFont(curFont,formG.CurpageRec.ScaleColorP);
          exit;
        end
        else
        if assigned(curfont) then swapFont(curFont,formG.CurpageRec.ScaleColorP);
      end;

      setWindow(x1,y1,x2,y2);
    end;
  FINALLY
    curFont.Free;
  END;
end;

procedure TmultiGraph.mouseMoveLeftG(x,y:integer);
begin
  if UOcap=nil then exit;
  { x et y sont les coordonnées du curseur dans paintbox1 (ou dans le bitmap sous-jacent) }

  if not UOcap.mouseMoveMG(x,y) then UOcap:=nil else formG.paintBox1.update;
end;

procedure TmultiGraph.mouseUpLeftG(x,y:integer);
begin
  if UOcap<>nil then UOcap.mouseUpMG(x,y,self);
  UOcap:=nil;
end;




procedure TmultiGraph.SaveWindowBMPClick(sender:Tobject);
const
  stF:AnsiString='';
var
  st:AnsiString;
begin
  st:= GsaveFile('Save Window as BMP',stF,'BMP');
  if st<>'' then
    begin
      formG.saveWin(TmenuItem(sender).tag,st,false,1);
      stF:=st;
    end;
end;

procedure TmultiGraph.SaveWindowJPEGClick(sender:Tobject);
const
  stF:AnsiString='';
var
  st:AnsiString;
begin
  st:= GsaveFile('Save Window as JPEG',stF,'JPG');
  if st<>'' then
    begin
      formG.saveWin(TmenuItem(sender).tag,st,true,1);
      stF:=st;
    end;
end;

{
mouseDownRightG est appelée en cas de click droit dans un cadre design off
on reçoit le numéro du cadre
          les coordonnées écran du cadre
          et la position de la souris en coordonnées cadre.

On interroge d'abord les objets de la liste avec mouseDownMG. Si un objet renvoie true,
c'est qu'il a traité le message. S'il renvoie un pointeur sur un objet uo, on crée un
menu popup pour cet objet.

Si tous les objets ont renvoyé false, on crée un menu popup basé sur les méthodes
popup_nbitem, popup_caption et popup_onClick des objets du cadre.
}

procedure TmultiGraph.mouseDownRightG(numC:integer;Shift: TShiftState;xc,yc,x,y,numCadre:integer);
var
  i,j:integer;
  mi,mj:TmenuItem;

  x1,y1,x2,y2:integer;
  Irect:Trect;
  uo:typeUO;
  flag:boolean;
  listU:Tlist;

begin
  UOcap:=nil;
  listU:=formG.curPageRec.cadre[1,numC].pu;
  if not assigned(listU) or (listU.count=0) then exit;

  FirstUOPopUp:=nil;
  with listU do
  for i:=0 to count-1 do
  if typeUO(items[i]).WithInside then
  begin
    FirstUOpopup:=items[i];
    break;
  end;

  Irect:=formG.curPageRec.getInsideWindow(numC,1);

  getWindowG(x1,y1,x2,y2);
  {La fenêtre courante est le cadre. Irect contient le rectangle intérieur}

  i:=0;
  flag:=false;
  repeat
    flag:= typeUO(listU.items[i]).MouseRightMG(formG,i,Irect, Shift, xc,yc, x,y,uo);
    setWindow(x1,y1,x2,y2);
    inc(i);
  until flag or (i>listU.count-1);

  if flag then
    begin
      if uo<>nil then            {par exemple, uo est un curseur}
        begin
          if assigned(pop) then pop.free;
          pop:=TpopUpMenu.create(nil);

          mi:=TmenuItem.create(pop);

          mi.caption:=uo.ident; {item avec nom de l'objet}

          CopyPopup(mi,uo.getPopup);

          pop.items.add(mi);

          pop.popup(xc+x,yc+y);
        end;
      exit;
    end;


  if assigned(pop) then pop.free;
  pop:=TpopUpMenu.create(nil);

  for i:=0 to listU.count-1 do
  begin
    mi:=TmenuItem.create(pop);

    mi.caption:=typeUO(listU[i]).ident; {item avec nom de l'objet}

    CopyPopup(mi,typeUO(listU[i]).getPopup);

    mj:=TmenuItem.create(mi);                 { ajouter remove}
    mj.caption:='Remove from window';
    mj.onClick:=formG.RemoveFromWin;
    mj.tag:=numCadre shl 16+i;
    mi.add(mj);

    if i>0 then
      begin
        mj:=TmenuItem.create(mi);             { ajouter bring to front}
        mj.caption:='Bring to front';
        mj.onClick:=formG.BringToFront;
        mj.tag:=numCadre shl 16+i;
        mi.add(mj);
      end;
    typeUO(listU[i]).getUserPopUp(mi);
    pop.items.add(mi);
  end;



  mi:=TmenuItem.create(pop);            { Window }
  mi.caption:='Window';

  mj:=TmenuItem.create(mi);             { Window. save as BMP}
  mj.caption:='Save as BMP';
  mj.onClick:=SaveWindowBMPClick;
  mj.tag:=numCadre;
  mi.add(mj);

  mj:=TmenuItem.create(mi);             { Window. save as Jpeg}
  mj.caption:='Save as JPEG';
  mj.onClick:=SaveWindowJPEGClick;
  mj.tag:=numCadre;
  mi.add(mj);

  mj:=TmenuItem.create(mi);             { Window. Create MG}
  mj.caption:='Create Multigraph';
  mj.onClick:=CreateMgFromWindow;
  mj.tag:=numCadre;
  mi.add(mj);

  mj:=TmenuItem.create(mi);             { Window. Create MG}
  mj.caption:='Clone Window';
  mj.onClick:=CreateObjListFromWindow;
  mj.tag:=numCadre;
  mi.add(mj);



  pop.items.add(mi);


  pop.popup(xc+x,yc+y);
end;

procedure TmultiGraph.displayTitle(st:AnsiString;num,col:integer);
var
  oldFont:Tfont;
begin
  oldFont:=canvasGlb.font;
  if PRprinting and PRmonochrome then col:=0;

  setTextAlign(canvasGlb.handle,TA_left or TA_Top);

  canvasGlb.font:=formG.TitleFont.font;

  try
    if PRprinting then
      canvasGlb.font.size:=round(canvasGlb.font.size*PRfontMag);

    canvasGlb.font.color:=col;
    canvasGlb.brush.style:=bsClear;
    if formG.curpageRec.FshowNum
      then textoutG(5+canvasGlb.textwidth('00'),5+canvasGlb.textHeight('1')*num,st)
      else textoutG(5,5+canvasGlb.textHeight('1')*num,st);

    if PRprinting
        then canvasGlb.font.size:=round(canvasGlb.font.size/PRfontMag);

  finally
    canvasGlb.font:=oldFont;
  end;
end;

procedure TmultiGraph.displayNum(num:integer);
var
  oldFont:Tfont;
begin
  setTextAlign(canvasGlb.handle,TA_left or TA_Top);
  oldFont:=canvasGlb.font;
  canvasGlb.font:=formG.TitleFont.font;
  try
  textoutG(5,5,Istr(num+1));
  finally
  canvasGlb.font:=oldFont;
  end;
end;



procedure TmultiGraph.Do3D(plot:typeUO;rect0:Trect);
var
  ViewPort: TD3DVIEWPORT9;

  i,j:integer;
  res:longword;

  xRect: D3DLOCKED_RECT;
  p1: PtabLong;
  p2: PtabLong;


begin
  if formG=nil then exit;
  with formG do
  begin
    if IDX9=nil then
      if not initDX9 then exit;
    if Idevice=nil then
      if not initDevice then exit;

    if not TestDevice then exit;
  end;

  with ViewPort do
  begin
    x:=rect0.Left;
    y:=rect0.top;
    width:= rect0.Right-rect0.Left;
    height:= rect0.Bottom-rect0.Top;
    minZ:=0;
    maxZ:=1;
  end;
  formG.Idevice.SetViewport(Viewport);

  plot.display3DX(formG.Idevice);

  //formG.Idevice.present(nil,nil,0,nil);

  with formG do
  res:= Idevice.StretchRect( renderSurface, nil, InterSurface, nil, D3DTEXF_NONE);
  if res<>0 then exit;

  with formG do
  if (InterSurface<>nil) and (InterSurface.LockRect(xRect,Nil, D3DLOCK_READONLY )=0) then
  begin
    with xrect do
    for j:=rect0.Top to rect0.bottom-1 do
    begin
      p1:=pointer(intG(pbits)+pitch*(j));
      p2:=curPagerec.bmfen.ScanLine[j];
      for i:=rect0.Left to rect0.Right-1 do
        p2^[i]:= p1^[i] and $FFFFFF;

    end;
    InterSurface.UnlockRect;
  end;

end;


procedure TmultiGraph.displayG(pageRec:TpageRec;numW,NumList:integer);
var
  i:integer;
  rect0,rectI:Trect;
  st:AnsiString;
  Finside,Fworld,FlogX,FlogY:boolean;
  plot,FirstPlot:typeUO;
  x1w,y1w,x2w,y2w:float;
  posTit:integer;
  curFont:Tfont;
  FlagFont:boolean;
  listU:Tlist;
  num2:integer;
  canDraw:boolean;
  Flag3D:boolean;
begin
  listU:=pageRec.cadre[NumList,numW].pu;
  if not assigned(listU) or (listU.count=0) then exit;

  FlagFont:=pageRec.PageFontP;
  if FlagFont then
  begin
    curFont:=Tfont.create;
    curfont.Assign(pageRec.fontP);
  end
  else curFont:=nil;

  TRY
  postit:=0;
  with listU do
  begin
    Finside:=false;
    Fworld:=false;
    Flag3D:=false;

    with rect0 do getWindowG(left,top,right,bottom);

    x1w:=0;
    y1w:=0;
    x2w:=100;
    y2w:=100;

    Num2:=0;

    for i:=0 to count-1 do
      begin
        plot:=typeUO(items[i]);

        if not Finside then                                  { Premier objet }
          begin

            Flag3D:=plot.is3D;
            if Flag3D then Do3D(plot,rect0)
            else
            
            begin
              with rect0 do setWindow(left,top,right,bottom);
              plot.swapContext(numW,formG.varPg1,true);
              try
                if FlagFont then plot.swapFont(curFont,pageRec.ScaleColorP);
                with pageRec do
                  if UseVparams
                  then plot.swapVisu(visuP,visuFlags);
                plot.display;                                  { Affichage complet avec coo}

                with rect0 do setWindow(left,top,right,bottom);
                rectI:=plot.getInsideWindow;
                with rectI do setWindow(left,top,right,bottom);
                if formG.curpageRec.FshowTitle and not StringEmpty(plot.title) then    { + le titre }
                  with plot do
                  begin
                    displayTitle(title,posTit,getTitlecolor);
                    inc(postit);
                  end;
                if formG.curpageRec.FshowNum and (i=0) then displayNum(numW);{+ le numéro }
                if plot.withInside then
                  begin
                    Finside:=true;
                    plot.getWorldPriorities(Fworld,FlogX,FlogY,x1w,y1w,x2w,y2w);

                    FirstPlot:=plot;                             { Positionner flags pour la suite }
                  end;

              finally
                plot.swapContext(numW,formG.varPg1,false);
                if FlagFont then plot.swapFont(curFont,pageRec.scaleColorP);
                with pageRec do
                  if UseVparams then plot.swapVisu(visuP,visuFlags);
              end;
            end;
          end
        else
        if not flag3D then
          begin
            inc(num2);

            Plot.swapContext(numW,formG.varPg1,true);
            try
              if Fworld then
              begin
                FirstPlot.SetCurrentWorld(num2,x1w,y1w,x2w,y2w);
                canDraw:=FirstPlot.SetCurrentWindow(num2,rectI);
              end
              else
              begin
                with rectI do setWindow(left,top,right,bottom);  { Objets en second plan }
                canDraw:=true;
              end;

              if canDraw then
              try
                if FlagFont then plot.swapFont(curFont,pageRec.scaleColorP);
                with pageRec do
                if UseVparams then plot.swapVisu(visuP,visuFlags);

                if y2act>y1act+1 then
                try
                FirstPlot.modifyPlot(num2,plot);                          { ne fait rien en général }
                plot.displayInside(FirstPlot,Fworld,FlogX,FlogY);    { on s'appuie sur le cadre fixé par le premier objet }
                finally
                FirstPlot.RestorePlot(num2,plot);                         { ne fait rien en général }
                end;

                with rectI do setWindow(left,top,right,bottom);
                if formG.curpageRec.FshowTitle and not StringEmpty(plot.title) then        { + le titre }
                  with plot do
                  begin
                    displayTitle(title,posTit,getTitlecolor);
                    inc(postit);
                  end;
              finally
                if FlagFont then plot.swapFont(curFont,pageRec.scaleColorP);
                with pageRec do
                if UseVparams then plot.swapVisu(visuP,visuFlags);
              end;

            finally
              plot.swapContext(numW,formG.varPg1,false);
            end;
          end;
      end;
  end;

  FINALLY
    curFont.free;
  END;
end;

procedure TmultiGraph.displayEmptyG(pageRec:TpageRec;numW,NumList:integer);
var
  i:integer;
  rect0,rectI:Trect;
  st:AnsiString;
  Finside,Fworld,FlogX,FlogY:boolean;
  plot,FirstPlot:typeUO;
  x1w,y1w,x2w,y2w:float;
  posTit:integer;
  curFont:Tfont;
  FlagFont:boolean;
  listU:Tlist;
begin
  listU:=pageRec.cadre[NumList,numW].pu;

  if not assigned(listU) or (listU.count=0) then exit;

  FlagFont:=pageRec.PageFontP;
  if FlagFont then
  begin
    curFont:=Tfont.create;
    curfont.Assign(pageRec.fontP);
  end
  else curFont:=nil;

  postit:=0;
  with listU do
  begin
    Finside:=false;
    Fworld:=false;

    with rect0 do getWindowG(left,top,right,bottom);

    x1w:=0;
    y1w:=0;
    x2w:=100;
    y2w:=100;

    for i:=0 to count-1 do
      begin
        plot:=typeUO(items[i]);

        if not Finside then
          begin
            with rect0 do setWindow(left,top,right,bottom);
            plot.swapContext(numW,formG.varPg1,true);
            if FlagFont then plot.swapFont(curFont,pageRec.ScaleColorP);
            with pageRec do
                if UseVparams then plot.swapVisu(visuP,visuFlags);
            try
              plot.displayEmpty;

              with rect0 do setWindow(left,top,right,bottom);
              rectI:=plot.getInsideWindow;
              with rectI do setWindow(left,top,right,bottom);
              if formG.curpageRec.FshowTitle and not StringEmpty(plot.title) then
                with plot do
                begin
                  displayTitle(title,posTit,getTitlecolor);
                  inc(postit);
                end;
              if formG.curpageRec.FshowNum and (i=0) then displayNum(numW);
              if plot.withInside then
                begin
                  Finside:=true;
                  plot.getWorldPriorities(Fworld,FlogX,FlogY,x1w,y1w,x2w,y2w);
                  FirstPlot:=plot;
                end;
            finally
              plot.swapContext(numW,formG.varPg1,false);
              if FlagFont then plot.swapFont(curFont,pageRec.ScaleColorP);
              with pageRec do
                if UseVparams then plot.swapVisu(visuP,visuFlags);
            end;
          end
        else

          begin
            with rectI do setWindow(left,top,right,bottom);

            Plot.swapContext(numW,formG.varPg1,true);
            try
              setWorld(x1w,y1w,x2w,y2w);
              {statusLineTxt(Estr(x1w,3)+' '+Estr(y1w,3)+' '+Estr(x2w,3)+' '+Estr(y2w,3) );}
              if FlagFont then plot.swapFont(curFont,pageRec.ScaleColorP);
              with pageRec do
                if UseVparams then plot.swapVisu(visuP,visuFlags);
              if not plot.withInside
                then plot.displayInside(FirstPlot,Fworld,FlogX,FlogY);

            finally
              if FlagFont then plot.swapFont(curFont,pageRec.ScaleColorP);
              with pageRec do
                if UseVparams then plot.swapVisu(visuP,visuFlags);
              plot.swapContext(numW,formG.varPg1,false);
            end;

            with rectI do setWindow(left,top,right,bottom);
            if formG.curpageRec.FshowTitle and not StringEmpty(plot.title) then
              with plot do
              begin
                displayTitle(title,posTit,getTitlecolor);
                inc(postit);
              end;
          end;
      end;
  end;
end;


{displayG1 est appelé par Pg1DisplayObject uniquement}
procedure TmultiGraph.displayG1(p:pointer;extWorld,logX,logY:boolean;mode,taille:integer);
var
  OldMode,OldTaille:integer;
begin
  typeUO(p).swapContext(0,formG.varPg1,true);
  try
  if typeUO(p) is TdataPlot then
  begin
    oldMode:=TdataPlot(p).modeT;
    oldTaille:=TdataPlot(p).tailleT;
    TdataPlot(p).modeT := mode;
    TdataPlot(p).tailleT := taille;
  end;

  typeUO(p).displayInside(nil,extWorld,logX,logY);
  finally
    TdataPlot(p).modeT := oldmode;
    TdataPlot(p).tailleT := oldtaille;
  typeUO(p).swapContext(0,formG.varPg1,false);
  end;
end;

procedure TmultiGraph.setWindowInG(listU:Tlist);
var
  rectI:Trect;
begin
  if assigned(listU) and (listU.count>0) then
    with listU do
    begin
      rectI:=TypeUO(items[0]).getInsideWindow;
      with rectI do setWindow(left,top,right,bottom);
    end;
end;


procedure TmultiGraph.removeG(p:pointer);
begin
  if assigned(p) then typeUO(p).UnActiveEmbedded;
  derefObjet(typeUO(p));
end;

function TmultiGraph.initialise(st:AnsiString):boolean;
var
  n1,n2:longint;
begin
  if initTmultiGraph.execution(st,n1,n2) then
    begin
      ident:=st;
      init(n1,n2);
      initialise:=true;
    end
  else initialise:=false;
end;

procedure TmultiGraph.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;

  if lecture then FnewPoswin:=false else FnewPoswin:=true;

  formG.getPosWin1(poswin,sizewin);

  with conf do
  begin
    setVarConf('WinSize',Sizewin,sizeof(Sizewin));

    if lecture then setVarConf('Poswin',Poswin^,sizeof(Poswin^))
               else setVarConf('Poswin',Poswin^,sizeWin);
    if lecture then setVarConf('Poswin1',Poswin^,sizeof(Poswin^))
               else setVarConf('Poswin1',Poswin^,sizeWin);
    setVarConf('NewPosWin',FnewPoswin,sizeof(FnewPosWin));

    setVarConf('BKcolor',formG.BKcolorDef,sizeof(formG.BKcolorDef));
    DumShowTitle:= false;
    if lecture then  setVarConf('ShowTitles',DumShowTitle,sizeof(DumShowTitle));
    setVarConf('TitleFont',formG.titleFont.desc,sizeof(formG.titleFont.desc));
    setStringConf('MgCaption',formG.MgCaption);
  end;
end;

procedure TmultiGraph.completeLoadInfo;
var
  i:integer;
begin
  CheckOldIdent;

  {Ne pas appeler inherited de Tdata0 }
  if FnewPosWin
    then formG.setPoswin1(posWin,sizewin)
    else formG.setPoswin(posWin,sizewin);

  if formG.MgCaption=''
    then formG.caption:= ident
    else formG.caption:= formG.MgCaption;
  dispose(poswin);

  if DumShowTitle then
    with formG do
    for i:=0 to PageCount-1 do pageRec[i].FshowTitle:= true;

  formRec.restoreForm(form,nil);
end;

procedure TmultiGraph.completeSaveInfo;
begin
  dispose(poswin);
end;

function TmultiGraph.dragOverG(source:Tobject):boolean;
begin
  dragOverG:= assigned(DragUOsource)
              and
              ( (DragUOsource.plotable) or
                (DragUOsource is TstmInspector) or
                (DragUOsource is TobjectFile)
              )
              and
              assigned(draggedUO) and (draggedUO.plotable);
end;

procedure TmultiGraph.dragDropG(source:Tobject;num:integer);
begin
   if not assigned(DraggedUO) then exit;

   if DragUOsource is TobjectFile then draggedUO:=cloneObjet(DraggedUO);
   if not assigned(DraggedUO) then exit;

   if formG.addObject(formG.currentPage,num,DraggedUO,1,false)
     then refObjet(DraggedUO);
   resetDragUO;
end;

procedure TmultiGraph.SpecialdragDropG(firstObj,dest:pointer;x,y:integer);
var
  pu:typeUO;
  Irect:Trect;
begin
  Irect:=TypeUO(firstObj).getInsideWindow;
  typeUO(dest).specialDrop(Irect,x,y);
  SpecialDrag:=nil;
end;


procedure TmultiGraph.RetablirReferences(list:Tlist);
var
  i,j,k,page,wt:integer;
  lu,list1:Tlist;
  ppu:typeUO;
  p:pointer;
begin
  list1:=Tlist.create;

  for page:=0 to formG.pageCount-1 do
    for wt:=1 to 2 do
    for j:=0 to formG.count(page,wt)-1 do
      begin
        lu:=formG.getPref(page,j,wt);                             // liste de pointeurs tronqués en 64 bits
        if assigned(lu) then
        begin
          list1.clear;
          for i:=0 to lu.count-1 do list1.add(nil);

          for i:=0 to list.count-1 do
            begin
              p:=typeUO(list.items[i]).myAd;                      // 25-9-17 : myAd n'est plus tronqué
              intG(p):= intG(p) and $FFFFFFFF;                    // donc, on tronque p pour faire les comparaisons
              k:=lu.indexof(p);
              if k>=0 then
                list1.items[k]:=list.items[i];
            end;

          for i:=0 to list1.count-1 do
            begin
              ppu:=list1.items[i];
              if assigned(ppu) and formG.addObject(page,j,ppu,wt,false) then //Wtype=1 ,mode2=false
              begin
                {messageCentral(ppu.ident);}
                refObjet(ppu);
              end;
            end;
        end;
      end;

  {affDebug('MG RetablirRef');}

  formG.clearRef;

  list1.free;
  {formG.refreshBM;}

  {affDebug('MG RetablirRef OK');}
end;

procedure TmultiGraph.ClearReferences;
begin
  formG.clearRef;
end;

procedure TmultiGraph.resetAll;
begin
  formG.curPageRec.resizeBM(true);
end;

procedure TmultiGraph.MgFromPage(mg:Tmultigraph;objList: TobjectList; numPage: integer);        // numPage commence à 0
var
  i,j,k:integer;
  list:Tlist;
  DumList:Tlist;
  uo:typeUO;
  stId,stOld: AnsiString;
begin
  DumList:= Tlist.create;

  mg.formG.FormStyle:= fsStayOnTop;

  mg.formG.pageRec[0].assign(formG.pageRec[numPage]);

  for i:=1 to 2 do
  for j:=0 to formG.Count(numPage,i)-1 do
  begin
    list:=formG.getP(numPage,j,i);
    if assigned(list) then
      for k:=0 to list.count-1 do
      begin
        uo:= list[k];
        if assigned(Objlist) and not uo.Embedded then
        begin
          stId:=uo.ident;
          stOld:=stId;
          if uo.UOowner is TobjectList then delete(stId,1,pos('.',stId));
          if copy(stId,1,4)='PG0.' then delete(stId,1,4);
          if pos('.PG0.',stId)>0 then delete(stId,pos('.PG0.',stId),4);
          uo.ident:= stId;

          if DumList.IndexOf(uo)<0 then
          begin
            DumList.Add(uo);
            uo:= ObjList.addObject(uo);
          end;
          typeUO(list[k]).ident:=stOld;
        end;

        if not uo.Embedded then
          if mg.formG.AddObject(0,j,uo,i, false) then mg.refobjet(uo);
      end;
  end;

  DumList.Free;
end;

procedure Tmultigraph.MgFromWindow(mg:Tmultigraph;ObjList:TobjectList; numPage,NumW:integer);
var
  i,j,k:integer;
  list:Tlist;
  uo:typeUO;
begin
  mg.formG.FormStyle:= fsStayOnTop;

  with mg.formG.pageRec[0] do
  begin
    assign(formG.pageRec[numPage]);
    DestroyAllWindows(1);
    NewWindow(1,1);
  end;

  list:=formG.getP(numPage,numW,1);
  if assigned(list) then
    for k:=0 to list.count-1 do
    begin
      uo:= list[k];

      if assigned(Objlist) and not uo.Embedded then uo:= ObjList.addObject(uo);

      if not uo.Embedded then
        if mg.formG.AddObject(0,0,uo,1, false) then mg.refobjet(uo);
    end;


end;



procedure TmultiGraph.processMessage(id:integer;source:typeUO;p:pointer);
var
  i,j,page,wt:integer;
  listU:Tlist;
  pp:typeUO;
  rectI:Trect;
  Finside:boolean;
begin
  {affDebug('ProcessMsg '+Istr(id)+' '+ident);}
  case id of
    UOmsg_invalidate,UOmsg_invalidateData:
      with formG do
      begin
        for page:=0 to pageCount-1 do
        for wt:=1 to 2 do
          begin
            for i:=0 to count(page,wt)-1 do
              begin
                {affdebug(Istr(page)+' '+Istr(i));}
                listU:=getP(page,i,wt);
                if assigned(listU) then
                  with listU do
                  begin
                    {affdebug('===>'+Istr(listU.count));}
                    for j:=0 to count-1 do
                      if typeUO(items[j])=source then valid[page,i,wt]:=false;
                  end;
              end;
          end;
      end;

    UOmsg_update:
      with formG do
      begin
        affdebug('UOmsg_update 0',15);
        for page:=0 to pageCount-1 do
        for wt:=1 to 2 do
          begin
            for i:=0 to count(page,wt)-1 do
              begin
                {affdebug(Istr(page)+' '+Istr(i));}
                listU:=getP(page,i,wt);
                if assigned(listU) then
                  with listU do
                  begin
                    for j:=0 to count-1 do
                      if typeUO(items[j])=source
                        then valid[page,i,wt]:=false;
                  end;
              end;
          end;
        updateBM;
        update;
      end;

    UOmsg_updateBM:
      with formG do
      begin
        affdebug('UOmsg_update 0',15);
        for page:=0 to pageCount-1 do
        for wt:=1 to 2 do
          begin
            for i:=0 to count(page,wt)-1 do
              begin
                {affdebug(Istr(page)+' '+Istr(i));}
                listU:=getP(page,i,wt);
                if assigned(listU) then
                  with listU do
                  begin
                    for j:=0 to count-1 do
                      if typeUO(items[j])=source
                        then valid[page,i,wt]:=false;
                  end;
              end;
          end;
        updateBM;
      end;

    UOmsg_PaintEmpty:
      with formG,CurPageRec do
      begin
        for wt:=1 to 2 do
        for i:=0 to cadreCount(wt)-1 do
        with cadre[wt,i] do
        begin
          for j:=0 to UOcount-1 do
            if UO[j]=source then
            begin
              initGraphic(BMfen);
              with rect do setWindow(left,top,right,bottom);
              clearWindow(BKcolorP);
              displayEmptyG(curpageRec,i,1);
              doneGraphic;
              invalidateRect1(rect);
              break;
            end;
        end;
        update;
      end;


    UOmsg_SimpleRefresh:
      with formG do
      begin
        for page:=0 to pageCount-1 do
        for wt:=1 to 2 do
          begin
            for i:=0 to count(page,wt)-1 do
              begin
                Finside:=false;
                listU:=getP(page,i,wt);
                if assigned(listU) and (listU.indexof(source)>=0) then
                  with listU do
                  begin
                    for j:=0 to count-1 do
                      begin
                        if not Finside then
                          begin
                            if page=currentPage then
                              begin
                                selectCadre(page,i,wt);
                                canvasGlb.brush.color:=curPageRec.BKcolorP;
                              end;

                            if (typeUO(items[j])=source) then
                              begin
                                if page=currentPage then
                                  begin
                                    TypeUO(items[j]).display;
                                    formG.invaliderCadre(i);
                                  end
                                else valid[page,i,wt]:=false;
                              end;

                            if page=currentPage then
                              begin
                                rectI:=TypeUO(items[j]).getInsideWindow;
                                if typeUO(items[j]) is TdataPlot then Finside:=true;
                              end;
                          end
                        else
                          begin
                            if typeUO(items[j])=source then
                              begin
                                if page=currentPage then
                                  begin
                                    with rectI do setWindow(left,top,right,bottom);
                                    TypeUO(items[j]).displayInside(nil,false,false,false);
                                    formG.invaliderCadre(i);
                                  end
                                else valid[page,i,wt]:=false;
                              end;
                          end;
                      end;
                    if count>0 then doneGraphic;
                  end;
              end;
          end;
        if not exeON then update;
      end;

    UOmsg_DisplayGUI:
      with formG do
      begin
        page:=currentPage;
        formG.paintbox1.Refresh;
        for wt:=1 to 2 do
        for i:=0 to count(page,wt)-1 do
          begin
            Finside:=false;
            listU:=getP(page,i,wt);
            if assigned(listU) then
              with listU do
              begin
                for j:=0 to count-1 do
                  begin
                    if not Finside then
                      begin
                        selectCadreW(i,wt);

                        if (typeUO(items[j])=source) then typeUO(items[j]).displayGUI;

                        rectI:=typeUO(items[j]).getInsideWindow;
                        Finside:=typeUO(items[j]).WithInside;
                      end
                    else
                      begin
                        if typeUO(items[j])=source then
                          begin
                            with rectI do setWindow(left,top,right,bottom);
                            typeUO(items[j]).displayGUI;
                          end;
                      end;
                  end;
                if count>0 then doneGraphic;
              end;
          end;
      end;


    UOmsg_destroy:
      begin
        with formG do
        begin
          for page:=0 to pageCount-1 do
          for wt:=1 to 2 do
            begin
              for i:=0 to count(page,wt)-1 do
                begin
                  listU:=getP(page,i,wt);
                  if assigned(listU) then
                    with listU do
                    begin
                      for j:=0 to count-1 do
                        if typeUO(items[j])=source then
                           begin
                             items[j]:=nil;
                             pp:=source;
                             {pp est mis à nil, donc on n'utilise pas source}
                             {if assigned(pp) then
           affDebug('MGDR '+pp.ident+' '+Istr(page)+'/'+Istr(i)+'/'+Istr(j) );}
                             derefObjet(pp);
                             valid[page,i,wt]:=false;
                           end;
                      pack; {ne pas mettre pack dans la boucle}
                    end;
                end;
                {affDebug('ProcessMsg Destroy OK '+ident);}
            end;
           {affDebug('ProcessMsg Destroy OK for all '+ident);}
        end;

        for i:=0 to dlgList.Count-1 do
        if source=dlgList[i] then
        begin
           derefObjet(source);
           dlgList.Delete(i);
           UpdateMGDialogs;
           exit;
        end;
      end;
    UOmsg_cursor:
      with formG do
      begin
        {affDebug('MG UOmsg_cursor 000'+source.ident);}
        page:=currentPage;

        for i:=0 to count(page,1)-1 do
          begin
            listU:=getP(page,i,1);
            if assigned(listU) then
              with listU do
              begin
                for j:=0 to count-1 do
                  if typeUO(items[j])=source then
                      formG.invaliderCadre(i);
              end;
          end;
      end;

    UOmsg_addObject:
      begin
        for page:=0 to formG.pageCount-1 do
        for wt:=1 to 2 do
        for i:=0 to formG.count(page,wt)-1 do
          begin
            listU:=formG.getP(page,i,wt);
            if assigned(listU) then
              with listU do
              begin
                for j:=0 to count-1 do
                  if typeUO(items[j])=source then
                    addObject(page,i,typeUO(p),1,false);
              end;
          end;
      end;
  end;
end;

procedure TmultiGraph.FdrawCursor(list:Tlist;bmDest:TbitmapEx);
var
  i:integer;
begin
  with TypeUO(list.items[0]).getInsideWindow do setWindow(left,top,right,bottom);

  for i:=0 to list.count-1 do TypeUO(list.items[i]).DisplayCursors(bmDest);
end;


procedure TmultiGraph.show;
begin
  formG.show;
end;

procedure TmultiGraph.resetForm;
begin
  formG.reset;
end;


{**************************** Méthodes de TmultigraphDAC ***************}

constructor TmultiGraphDAC.create;
begin
  createWithForm(TmultiGform(formStm));
end;

class function TmultiGraphDAC.STMClassName:AnsiString;
begin
  STMclassName:='MGDAC';
end;

procedure TmultiGraphDAC.completeLoadInfo;
begin
//  formG.color:=formG.BKcolorDef;
  if FnewPosWin
    then formG.setPoswin1(posWin,sizewin)
    else formG.setPoswin(posWin,sizewin);


  dispose(poswin);

  {affDebug('MG CompleteloadInfo');}
end;




{**************************** Méthodes stm de Tmultigraph ***************}

procedure proTmultiGraph_create(name:AnsiString;nx,ny:integer;var pu:typeUO);
  begin
    createPgObject(name,pu,Tmultigraph);

    TmultiGraph(pu).init(nx,ny);
    TmultiGraph(pu).formG.formStyle:=fsStayOnTop;
  end;

procedure proTmultiGraph_create_1(nx,ny:integer;var pu:typeUO);
begin
  proTmultiGraph_create('',nx,ny, pu);
end;

procedure proTmultiGraph_create_2(var pu:typeUO);
begin
  createPgObject('',pu,Tmultigraph);
  
  with TmultiGraph(pu) do
  begin
    caption:=ident;
    formG.formStyle:=fsStayOnTop;
  end;
end;

procedure proTmultiGraph_ScreenNum(i:integer;var pu:typeUO);
var
  dum:boolean;
  begin
    verifierObjet(pu);

    with TmultiGraph(pu).formG do
    begin
      TabPage1Changing(nil, dum);
      if not selectPage(i-1) then sortieErreur(E_page);
    end;
    updateAff;
  end;


function fonctionTmultiGraph_ScreenNum(var pu:typeUO):integer;
  begin
    verifierObjet(pu);

    result:=TmultiGraph(pu).formG.currentPage+1;
  end;

procedure proTmultiGraph_selectScreen(i:integer;var pu:typeUO);
  begin
    proTmultiGraph_ScreenNum(i,pu);
  end;


procedure proTmultiGraph_initGrid(page,i,j:integer;var pu:typeUO);
  begin
    verifierObjet(pu);

    if not TmultiGraph(pu).formG.initGrid(page-1,i,j)
      then sortieErreur(E_initGrid);
  end;


procedure proTmultiGraph_addObjectOnGrid(page,i,j:integer;var u,pu:typeUO);
  begin
    verifierObjet(u);
    verifierObjet(pu);

    if not TmultiGraph(pu).addObjectOnGrid(page-1,i,j,u,1,false)
      then sortieErreur(E_pageOrWindow);
  end;

procedure proTmultiGraph_addObject(page,i:integer;var u,pu:typeUO);
  begin
    verifierObjet(u);
    verifierObjet(pu);

    if not TmultiGraph(pu).addObject(page-1,i-1,u,1,false)
      then sortieErreur(E_pageOrWindow);
  end;

procedure proTmultiGraph_addDialog(page,i:integer;var u,pu:typeUO);
  begin
    verifierObjet(u);
    verifierObjet(pu);

    if not TmultiGraph(pu).addObject(page-1,i-1,u,1,false)
      then sortieErreur(E_pageOrWindow);
  end;

procedure proTmultiGraph_addObjectEx(page,i:integer;var u,pu:typeUO);
begin
  verifierObjet(u);
  verifierObjet(pu);

  if not TmultiGraph(pu).addObject(page-1,i-1,u,1,false)
    then sortieErreur(E_pageOrWindow);
end;

procedure proTmultiGraph_addObjectEx_1(page,i:integer;var u: typeUO; mode:integer;var pu:typeUO);
begin
  verifierObjet(u);
  verifierObjet(pu);

  if not TmultiGraph(pu).addObject(page-1,i-1,u,1,mode<>1)
    then sortieErreur(E_pageOrWindow);
end;


procedure proTmultiGraph_addCursor(page,i:integer;var u,pu:typeUO);
  begin
    verifierObjet(u);
    verifierObjet(pu);

    if not TmultiGraph(pu).addObject(page-1,i-1,u,1,false)
      then sortieErreur(E_pageOrWindow);
  end;

procedure proTmultiGraph_addMGDialog(AlignMode:integer; var u,pu:typeUO);
begin
  verifierObjet(u);
  verifierObjet(pu);

  if not TmultiGraph(pu).addMGDialog(Tdialog(u),TcdAlign(AlignMode))
    then sortieErreur('Tmultigraph.addMGDialog : unable to install dialog');
end;

procedure proTmultiGraph_ClearMGDialogs(var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).ClearMGDialogs;
end;


procedure proTmultiGraph_clearObjects(page,i:integer;var pu:typeUO);
  begin
    verifierObjet(pu);

    if not TmultiGraph(pu).formG.pg1ClearObjects(page-1,i-1)
      then sortieErreur(E_pageOrWindow);
  end;


procedure proTmultiGraph_color(x:longint;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu) do
  begin
//    formG.color:=x;
    formG.BKcolorDef:=x;
//    if x=0 then formG.font.color:=clWhite;
  end;
end;

function fonctionTmultiGraph_color(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  fonctionTmultiGraph_color:=TmultiGraph(pu).formG.BKcolorDef;
end;

procedure proTmultiGraph_caption(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).caption:=st;
end;

function fonctionTmultiGraph_caption(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:= TmultiGraph(pu).caption;
end;

procedure proTmultiGraph_refresh(var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do
  begin
    CurPageRec.PageValid:=false;
    refresh;
  end;
end;

procedure proTmultiGraph_update(var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.update;
end;

procedure proTmultiGraph_updatePages(var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.updateBMs;
end;


procedure proTmultiGraph_show(var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.show;
end;


procedure proTmultiGraph_Droite(a,b:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1Droite(a,b);
end;

procedure proTmultiGraph_Line(x1,y1,x2,y2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1line(x1,y1,x2,y2);
end;

procedure proTmultiGraph_lineTo(x,y:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1lineto(x,y);
end;

procedure proTmultiGraph_moveto(x,y:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1moveto(x,y);
end;

procedure proTmultiGraph_LineVer(x0:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1linever(x0);
end;

procedure proTmultiGraph_LineHor(y0:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1lineHor(y0);
end;

procedure proTmultiGraph_setWindow(num:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1SetWindow(num);
end;

function fonctionTmultiGraph_getWindow(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=TmultiGraph(pu).formG.pg1GetWindow;
end;

procedure proTmultiGraph_getWindowPos(page,win:integer;var x1,y1,x2,y2:Integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1GetWindowPos(page-1,win-1,x1,y1,x2,y2);
end;

procedure proTmultiGraph_selectWindow(var p:typeUO;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(p);
  TmultiGraph(pu).formG.pg1SelectWindow(p);
end;

procedure proTmultiGraph_setWindowEx(x1,y1,x2,y2:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1SetWindowEx(x1,y1,x2,y2);
end;

procedure proTmultiGraph_getWindowEx(var x1,y1,x2,y2:Integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1GetWindowEx(x1,y1,x2,y2);
end;

procedure proTmultiGraph_selectWorld(var p:typeUO;var pu:typeUO);
var
  x1,y1,x2,y2:float;
begin
  verifierObjet(pu);
  verifierObjet(p);
  if p is TdataPlot then
    begin
      Tdataplot(p).getWorld(x1,y1,x2,y2);
      TmultiGraph(pu).formG.pg1SetWorld(x1,y1,x2,y2);
    end;  
end;

procedure proTmultiGraph_setWorld(x1,y1,x2,y2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1SetWorld(x1,y1,x2,y2);
end;

procedure proTmultiGraph_getWorld(var x1,y1,x2,y2:float;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1GetWorld(x1,y1,x2,y2);
end;

procedure proTmultiGraph_clearWindow(tout:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1ClearWindow(tout);
end;

procedure proTmultiGraph_DrawBorder(var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1DrawBorder;
end;

procedure proTmultiGraph_DrawBorderOut(var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1DrawBorderOut;
end;


procedure proTmultiGraph_OutText(x,y:integer;st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1OutText(x,y,st);
end;

procedure proTmultiGraph_OutTextW(x,y:integer;st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.pg1OutTextW(x,y,st);
end;


procedure proTmultiGraph_SetClippingON(var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.Pg1setClippingON;
end;

procedure proTmultiGraph_SetClippingOff(var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.Pg1setClippingOff;
end;


procedure proTmultiGraph_Graduations(stX,stY:AnsiString;echX,echY:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.Pg1Graduations(stX,stY,echX,echY);
end;

procedure proTmultiGraph_setcolor(num:integer;var pu:typeUO);
var
  col:integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG,varpg1 do
  begin
    case num of
      1..4: col:=Pg1Rgb[num]
      else col:=num;
    end;
    pen0.color:=col;
    brush0.color:=col;
  end;
end;

procedure proTmultiGraph_setWriteMode(mode:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  if (mode>=0) and (mode<=ord(high(TpenMode))) then
    with TmultiGraph(pu).formG,varPg1 do
    begin
      case mode of
        0: pen0.Mode:=pmCopy;
        1: pen0.Mode:=pmXor;
        else pen0.Mode:=TpenMode(mode);
      end;
    end;
end;

procedure proTmultiGraph_AfficherSymbole(x,y:float;numSymb,taille:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.Pg1AfficherSymbole(x,y,numSymb,taille);
end;

procedure proTmultiGraph_clearScreen(var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.Pg1ClearScreen;
end;

procedure proTmultiGraph_resetScreen(var pu:typeUO);
begin
  verifierObjet(pu);
  TmultiGraph(pu).formG.Pg1ResetScreen;
end;

function fonctionTmultigraph_GetWin(var p:pointer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  fonctionTmultigraph_GetWin:=TmultiGraph(pu).formG.Pg1GetWin(p);
end;

function fonctionTmultigraph_winCount(page:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do
     fonctionTmultigraph_winCount:=Pg1WinCount(page);
end;



procedure proTmultiGraph_DisplayObject(var ob,pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(ob);

  with TmultiGraph(pu).formG do pg1DisplayObject(ob);
end;

procedure proTmultiGraph_SetVectorMode(mode,taille:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    mode0:=mode;
    taille0:=taille;
  end;
end;

procedure proTmultiGraph_SetLogMode(logx,logy:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    logX0:=logX;
    logY0:=logY;
  end;
end;

procedure proTmultiGraph_Pencolor(n:integer;var pu:typeUO);pascal;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    pen0.color:=n;
    brush0.color:=n;
  end;
end;

function fonctionTmultiGraph_Pencolor(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    fonctionTmultiGraph_Pencolor:=pen0.color;
  end;
end;

procedure proTmultiGraph_PenMode(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    if (n>=0) and (n<=ord(high(TpenMode))) then pen0.mode:=TpenMode(n);
  end;
end;

function fonctionTmultiGraph_PenMode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    fonctionTmultiGraph_PenMode:=ord(pen0.mode);
  end;
end;


procedure proTmultiGraph_PenWidth(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    pen0.width:=n;
  end;
end;

function fonctionTmultiGraph_PenWidth(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    fonctionTmultiGraph_PenWidth:=pen0.width;
  end;
end;


procedure proTmultiGraph_VectorMode(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    mode0:=n;
  end;
end;

function fonctionTmultiGraph_VectorMode(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    fonctionTmultiGraph_VectorMode:=mode0;
  end;
end;


procedure proTmultiGraph_symbolSize(n:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    taille0:=n;
  end;
end;

function fonctionTmultiGraph_symbolSize(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    fonctionTmultiGraph_SymbolSize:=taille0;
  end;
end;


procedure proTmultiGraph_LogX(n:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    logX0:=n;
  end;
end;

function fonctionTmultiGraph_LogX(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    fonctionTmultiGraph_LogX:=logX0;
  end;
end;


procedure proTmultiGraph_LogY(n:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    logY0:=n;
  end;
end;

function fonctionTmultiGraph_LogY(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    fonctionTmultiGraph_LogY:=logY0;
  end;
end;


function fonctionTmultiGraph_Font(var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with Tmultigraph(pu).formG.varPg1 do
  begin
    result:=Font0;
  end;
end;

procedure proTmultiGraph_Transparent(n:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    Transparent:=n;
  end;
end;

function fonctionTmultiGraph_Transparent(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG.varPg1 do
  begin
    fonctionTmultiGraph_Transparent:=transparent;
  end;
end;

procedure proTmultigraph_AfficherTrace(var S:TypeUO;var pu:typeUO);
begin
  proTmultigraph_DisplayObject(s,pu);
end;


function fonctionTmultiGraph_DefineWindow(page,x1,y1,x2,y2:integer;var pu:typeUO):integer;
var
  mg:TPageRec;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    mg:=formG.pageRec[page-1];
    if mg=nil then sortieErreur('Tmultigraph.DefineWindow : invalid page number');
  end;
  result:= mg.DefineWindow(x1,y1,x2,y2,1,false);
end;

function fonctionTmultiGraph_DefineGrid(page,x1,y1,x2,y2,nx,ny:integer;var pu:typeUO):integer;
var
  mg:TPageRec;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    mg:=formG.pageRec[page-1];
    if mg=nil then sortieErreur('Tmultigraph.DefineGrid: invalid page number');
  end;
 result:= mg.defineGrid(x1,y1,x2,y2,nx,ny,1,false);
end;

function fonctionTmultiGraph_NewWindow(page,x,y:integer;var pu:typeUO):integer;
var
  mg:TPageRec;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    mg:=formG.pageRec[page-1];
    if mg=nil then sortieErreur('Tmultigraph.DefineGrid: invalid page number');
  end;
  result:= mg.NewWindow(x,y);
end;

procedure proTmultiGraph_divideWindow(page,num,nx,ny:integer;var pu:typeUO);
var
  mg:TPageRec;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    mg:=formG.pageRec[page-1];
    if mg=nil then sortieErreur('Tmultigraph.DefineGrid: invalid page number');
  end;
  mg.DivideWindow(num-1,nx,ny,1,false);
end;

procedure proTmultiGraph_destroyWindows(page,num,cnt:integer;var pu:typeUO);
var
  mg:TPageRec;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    mg:=formG.pageRec[page-1];
    if mg=nil then sortieErreur('Tmultigraph.DefineGrid: invalid page number');
  end;
  mg.DestroyWindows(num-1,cnt,1);

end;


function fonctionTmultiGraph_PageWidth(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do
    fonctionTmultiGraph_PageWidth:=paintBox1.width;
end;




procedure proTmultiGraph_PageWidth(w:integer;var pu:typeUO);
var
  w0:integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do
  begin
    w0:=w+width-paintBox1.Width;

    if w0<=screen.width then width:=w0;
  end;
end;


function fonctionTmultiGraph_PageHeight(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do
    fonctionTmultiGraph_PageHeight:=paintBox1.Height;
end;

procedure proTmultiGraph_PageHeight(w:integer;var pu:typeUO);
var
  w0:integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do
  begin
    w0:=w+height-paintBox1.height;

    if w0<=screen.height then Height:=w0;
  end;
end;

function fonctionTmultiGraph_PageLeft(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do
  result:=Left;
end;

function fonctionTmultiGraph_PageTop(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do
  result:=top+paintbox1.top;
end;


procedure proTmultiGraph_savePage(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do Pg1savePage(currentPage,st);
end;

Procedure proTmultiGraph_SavePageAsJPEG(st:AnsiString;quality:integer;
                                        var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do Pg1savePageAsJpeg(currentPage,st,quality);
end;

Procedure proTmultiGraph_SavePageAsPng(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do Pg1savePageAsPng(currentPage,st);
end;


procedure proTmultiGraph_DestroyAllWindows(page:Integer;var pu:typeUO);
var
  mg:TPageRec;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    mg:=formG.pageRec[page-1];
    if mg=nil then sortieErreur('Tmultigraph.DefineGrid: invalid page number');
  end;
  mg.DestroyAllWindows(1);
end;

procedure proTmultiGraph_PrintCurrentPage(var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmultigraph(pu).formG.curpageRec do
    if PRdraft then hardcopy else imprimer;
end;

procedure proTmultiGraph_setXworld(x1,y1,x2:float;Fup:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do pg1setXworld(x1,y1,x2,Fup);

end;

procedure proTmultiGraph_VSrectangle(x,y,dx,dy,theta:float;var pu:typeUO);
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do VSrectangle(x,y,dx,dy,theta);
end;


function multigraph0:Tmultigraph;
begin
  result:=DacMultigraph;
end;


procedure TmultiGraph.Defaults;
begin
  with formG do
  begin
    tabPage1.tabs.strings[0]:='Page 1';
    BKcolorDef:=clWhite;
    curPageRec.BKcolorP:=clWhite;
    invalidate;
  end;
end;

procedure TmultiGraph.test;
begin
  formG.CurPageRec.BMfen.restoreRects;
  formG.drawBM;
end;

{-----------------------------------------------------------------------------}

function fonctionTmultigraph_MgPage(st:AnsiString;var pu:typeUO):pointer;
var
  i:integer;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    i:=formG.getPageIndex(st);
    if i<0 then sortieErreur('Tmultigraph.MGpage : invalid name');
    result:=formG.pageRec[i];
  end;
end;

function fonctionTmultigraph_MgPage_1(n:integer;var pu:typeUO):pointer;
var
  i:integer;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    result:=formG.pageRec[n-1];
    if result=nil then sortieErreur('Tmultigraph.MgPage : invalid page number');
  end;
end;

function fonctionTmultigraph_PageCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
    result:=formG.PageCount;
end;

procedure proTmultigraph_AddPage(stname:AnsiString;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    i:=formG.getPageIndex(stName);
    if i>=0 then sortieErreur('Tmultigraph.AddPage : invalid name');
    formG.ajoutePage(stName)
  end;
end;

procedure proTmultigraph_InsertPage(num:integer;stname:AnsiString;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    i:=formG.getPageIndex(stName);
    if i>=0 then sortieErreur('Tmultigraph.InsertPage : invalid name');

    formG.insertPage(num-1,stName);
  end;
end;

procedure proTmultigraph_DeletePage(stname:AnsiString;var pu:typeUO);
var
  i:integer;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    i:=formG.getPageIndex(stName);
    if i<0 then sortieErreur('Tmultigraph.DeletePage : invalid name');
    if formG.PageCount<=1 then exit;

    formG.deletePage(i);
  end;
end;

procedure proTmultigraph_DeleteAllPages(stname:AnsiString;var pu:typeUO);
var
  num,i:integer;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    num:=formG.getPageIndex(stName);

    for i:=formG.PageCount-1 downto 0 do
    if (i<>num) and (formG.PageCount>1)
      then formG.deletePage(i);
  end;
end;

procedure proTmultiGraph_selectPage(st:AnsiString;var pu:typeUO);
var
  dum:boolean;
  i:integer;
begin
  verifierObjet(pu);

  with TmultiGraph(pu).formG do
  begin
    TabPage1Changing(nil, dum);
    i:=getPageIndex(st);
    if i<0 then sortieErreur('Tmultigraph.selectMgPage : invalid page name');
    if not selectPage(i)
      then sortieErreur('Tmultigraph.selectMgPage : unable to select page');
  end;
  updateAff;
end;

function fonctionTmultigraph_PageIndex(st:AnsiString;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TmultiGraph(pu).formG do
    result:=getPageIndex(st)+1;
end;

{------------------------------------------------------------------------------}

procedure proTMGpage_color(w:integer;pu:typeUO);
begin
  with TpageRec(pu) do
  begin
    BKcolorP:=w;
    PageValid:=false;
    invalidateP;
  end;
end;

function fonctionTMGpage_color(pu:typeUO):integer;
begin
  with TpageRec(pu) do
  begin
    result:=BKcolorP;
  end;
end;

procedure proTMGpage_ScaleColor(w:integer;pu:typeUO);
begin
  with TpageRec(pu) do
  begin
    ScalecolorP:=w;
    PageValid:=false;
    invalidateP;
  end;
end;

function fonctionTMGpage_Scalecolor(pu:typeUO):integer;
begin
  with TpageRec(pu) do
  begin
    result:=ScaleColorP;
  end;
end;

function fonctionTMGpage_name(pu:typeUO):AnsiString;pascal;
var
  i:integer;
begin
  with TpageRec(pu) do
  begin
    //i:= multiGF.TabPage1.Tabs.IndexOfObject(pu);
    i:= multiGF.PageList.IndexOf(pu);

    result:=multiGF.TabPage1.Tabs.Strings[i];
  end;
end;



function fonctionTMGpage_font(pu:typeUO):Tfont;
begin
  with TpageRec(pu) do
  begin
    result:=FontP;
  end;
end;


function fonctionTMGpage_PageFont(pu:typeUO):boolean;
begin
  with TpageRec(pu) do
  begin
    result:=PageFontP;
  end;
end;

procedure proTMGpage_PageFont(w:boolean;pu:typeUO);
begin
  with TpageRec(pu) do
  begin
    if PageFontP<>w then
    begin
      PageValid:=false;
      invalidateP;
    end;
    PageFontP:=w;
  end;
end;


function fonctionTMGpage_ShowTitles(pu:typeUO):boolean;
begin
  with TpageRec(pu) do
  begin
    result:=FShowTitle;
  end;
end;

procedure proTMGpage_ShowTitles(w:boolean;pu:typeUO);
begin
  with TpageRec(pu) do
  begin
    FshowTitle:=w;
  end;
end;

function fonctionTMGpage_ShowOutlines(pu:typeUO):boolean;
begin
  with TpageRec(pu) do
  begin
    result:=ShowOutline;
  end;
end;

procedure proTMGpage_ShowOutLines(w:boolean;pu:typeUO);
begin
  with TpageRec(pu) do
  begin
    ShowOutline:=w;
  end;
end;


function fonctionTMGpage_ShowNumbers(pu:typeUO):boolean;
begin
  with TpageRec(pu) do
  begin
    result:=FShowNum;
  end;
end;

procedure proTMGpage_ShowNumbers(w:boolean;pu:typeUO);
begin
  with TpageRec(pu) do
  begin
    FshowNum:= w;
  end;
end;




procedure proTMGpage_initGrid(nx,ny:integer;pu:typeUO);
begin
  TpageRec(pu).initGrid(nx,ny,1);
end;

procedure proTMGpage_initGrid_1(nx,ny,Wtype:integer;pu:typeUO);
begin
  controleParam(Wtype,1,2,'TmgPage.InitGrid : Wtype must be 1 or 2');
  TpageRec(pu).initGrid(nx,ny,Wtype);
end;


procedure proTMGpage_addObjectOnGrid(i,j:integer;var plot:Tplot;pu:typeUO);
begin
  verifierObjet(typeUO(plot));
  if TpageRec(pu).addOnGrid(i,j,plot,1,false)
    then TpageRec(pu).multiGF.mgOwner.refObjet(plot);
end;

procedure proTMGpage_addObjectOnGrid_1(i,j:integer;var plot:Tplot;Wtype:integer; pu:typeUO);
begin
  controleParam(Wtype,1,2,'TmgPage.AddObjectOnGrid : Wtype must be 1 or 2');
  verifierObjet(typeUO(plot));
  if TpageRec(pu).addOnGrid(i,j,plot,Wtype,false)
    then TpageRec(pu).multiGF.mgOwner.refObjet(plot);
end;


procedure proTMGpage_addObject(w:integer;var u:Tplot;pu:typeUO);
begin
  verifierObjet(typeUO(u));
  if TpageRec(pu).addObject(w-1,u,1,false)
    then TpageRec(pu).multiGF.mgOwner.refObjet(u);
end;

procedure proTMGpage_addObject_1(w:integer;var u:Tplot;Wtype:integer;pu:typeUO);
begin
  verifierObjet(typeUO(u));
  if TpageRec(pu).addObject(w-1,u,Wtype,false)
    then TpageRec(pu).multiGF.mgOwner.refObjet(u);
end;

procedure proTMGpage_addDialog(w:integer;var u:Tdialog;pu:typeUO);
begin
  verifierObjet(typeUO(u));
  with TpageRec(pu) do
    if addObject(w-1,u,1,false)
      then multiGF.mgOwner.refObjet(u);
end;

procedure proTMGpage_addObjectEx(w:integer;var u:TypeUO;pu:typeUO);
begin
  verifierObjet(typeUO(u));

  with TpageRec(pu) do
    if addObject(w-1,u,1,false)
      then multiGF.mgOwner.refObjet(u)
      else sortieErreur('AddObjectEx : cannot put object in a page');
end;

procedure proTMGpage_addObjectEx_1(w:integer;var u:TypeUO;mode:integer; pu:typeUO);
begin
  verifierObjet(typeUO(u));

  with TpageRec(pu) do
    if addObject(w-1,u,1,mode<>1)
      then multiGF.mgOwner.refObjet(u)
      else sortieErreur('AddObjectEx : cannot put object in a page');
end;


procedure proTMGpage_addCursor(w:integer;var u:TLcursor;pu:typeUO);
begin
  verifierObjet(typeUO(u));
  TLcursor(u).show(nil);

  with TpageRec(pu) do
  begin
    if addObject(w-1,u,1,false)
      then multiGF.mgOwner.refObjet(u)
      else exit;
  end;

  with TLcursor(u).form do
  begin
    parent:=TpageRec(pu).multiGF;
    BorderStyle := BsNone;
  end;

end;

procedure proTMGpage_ClearObjects(w:integer;pu:typeUO);
begin
  TpageRec(pu).ClearObjects(w-1,1);
end;

procedure proTMGpage_ClearObjects_1(w:integer;Wtype:integer; pu:typeUO);pascal;
begin
  controleParam(Wtype,1,2,'TmgPage.ClearObjects : Wtype must be 1 or 2');
  TpageRec(pu).ClearObjects(w-1,Wtype);
end;


procedure proTMGpage_getWindowPos(win:integer;var x1,y1,x2,y2:integer;pu:typeUO);
begin
  with TpageRec(pu) do
  begin
    if (win<1) or (win>cadreCount(1)) then sortieErreur('TmgPage.getWindowPos : bad window number');
    with cadre[1,win-1].rect do
    begin
      x1:=left;
      x2:=Right;
      y1:=top;
      y2:=bottom;
    end;
  end;
end;

function fonctionTMGpage_GetWin(var p:Tplot;pu:typeUO):integer;
begin
  result:=TpageRec(pu).getwin(p,1);
end;

function fonctionTMGpage_winCount(pu:typeUO):integer;
begin
  result:= TpageRec(pu).CadreCount(1);
end;

function fonctionTMGpage_winCount_1(Wtype:integer; pu:typeUO):integer;
begin
  controleParam(Wtype,1,2,'TmgPage.WinCount : Wtype must be 1 or 2');
  result:= TpageRec(pu).CadreCount(Wtype);
end;


function fonctionTMGpage_DefineWindow(x1,y1,x2,y2:integer;pu:typeUO):integer;
begin
  result:=TpageRec(pu).defineWindow(x1,y1,x2,y2,1,false);
end;

function fonctionTMGpage_DefineWindow_1(x1,y1,x2,y2:integer;Wtype:integer;Fback:boolean;pu:typeUO):integer;
begin
  controleParam(Wtype,1,2,'TmgPage.DefineWindow : Wtype must be 1 or 2');
  result:=TpageRec(pu).defineWindow(x1,y1,x2,y2,Wtype,Fback);
end;

function fonctionTMGpage_DefineGrid(x1,y1,x2,y2,nx,ny:integer;pu:typeUO):integer;
begin
  result:=TpageRec(pu).defineGrid(x1,y1,x2,y2,nx,ny,1,false);
end;

function fonctionTMGpage_DefineGrid_1(x1,y1,x2,y2,nx,ny,Wtype:integer;pu:typeUO):integer;
begin
  controleParam(Wtype,1,2,'TmgPage.DefineGrid : Wtype must be 1 or 2');
  result:=TpageRec(pu).defineGrid(x1,y1,x2,y2,nx,ny,Wtype,true);
end;


procedure proTMGpage_DestroyAllWindows(pu:typeUO);
begin
  TpageRec(pu).DestroyAllWindows(0);
end;

procedure proTMGpage_DestroyAllWindows_1(Wtype:integer;pu:typeUO);
begin
  controleParam(Wtype,1,2,'TmgPage.DestroyAllWindows : Wtype must be 1 or 2');
  if not (Wtype in [0..2]) then sortieErreur('DestroyAllWindows : invalid parameter');
  TpageRec(pu).DestroyAllWindows(Wtype);
end;


Procedure proTMGpage_SaveAsBMP(st:AnsiString;pu:typeUO);
begin
  TpageRec(pu).SaveAsBMP(st);
end;

Procedure proTMGpage_SaveAsPNG(st:AnsiString;pu:typeUO);
begin
  TpageRec(pu).SaveAsPNG(st);
end;

Procedure proTMGpage_SaveAsJPEG(st:AnsiString;quality:integer;pu:typeUO);
begin
  TpageRec(pu).SaveAsJPEG(st,quality);
end;

Procedure proTMGpage_SaveAsEmf(st:AnsiString;pu:typeUO);
begin
  TpageRec(pu).SaveAsEmf(st);
end;


procedure proTMGpage_Print(pu:typeUO);
begin
  with TpageRec(pu) do
  begin
    if PRdraft
      then hardcopy
      else imprimer;
  end;
end;

procedure proTMGpage_divideWindow(Win,nx,ny:integer;pu:typeUO);
begin
  TpageRec(pu).divideWindow(Win-1,nx,ny,1,false);
end;

procedure proTMGpage_divideWindow_1(Win,nx,ny,Wtype:integer;pu:typeUO);
begin
  controleParam(Wtype,1,2,'TmgPage.divideWindow : Wtype must be 1 or 2');
  TpageRec(pu).divideWindow(Win-1,nx,ny,Wtype,true);
end;


function fonctionTMGpage_newWindow(x,y:integer;pu:typeUO):integer;
begin
  TpageRec(pu).NewWindow(x,y);
end;

procedure proTMGpage_destroyWindows(win,count:integer;pu:typeUO);
begin
  TpageRec(pu).destroyWindows(win-1,count,1);
end;

procedure proTMGpage_destroyWindows_1(win,count,Wtype:integer;pu:typeUO);
begin
  controleParam(Wtype,1,2,'TmgPage.destroyWindows : Wtype must be 1 or 2');
  TpageRec(pu).destroyWindows(win-1,count,Wtype);
end;


procedure proTMGpage_WinAlign(win,value:integer;pu:typeUO);
begin
  with TpageRec(pu) do
  begin
    if (win<1) or (win>Cadrecount(1)) then sortieErreur('TMGpage.WinAlign : bad window number');
    if (value<0) or (value>4) then sortieErreur('TMGpage.WinAlign : Illegal Align value');
    cadre[1,win-1].cdAlign:=TcdAlign(value);
  end;
end;

function fonctionTMGpage_WinAlign(win:integer;pu:typeUO):integer;
begin
  with TpageRec(pu) do
  begin
    if (win<1) or (win>Cadrecount(1)) then sortieErreur('TMGpage.WinAlign : bad window number');
    result:=ord(cadre[1,win-1].cdAlign);
  end;
end;

procedure proTMultigraph_WinAlign(page1,win,value:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    if (page1<1) or (page1>formG.pageCount) then sortieErreur('TMutigraph.WinAlign : bad page number');
    if (win<1) or (win>formG.pageRec[page1-1].CadreCount(1)) then sortieErreur('TMultigraph.WinAlign : bad window number');
    if (value<0) or (value>4) then sortieErreur('TMGpage.WinAlign : Illegal Align value');
    formG.pageRec[page1-1].cadre[1,win-1].CdAlign:=TcdAlign(value);
  end;
end;

function fonctionTMultigraph_WinAlign(page1,win:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    if (page1<1) or (page1>formG.pageCount) then sortieErreur('TMutigraph.WinAlign : bad page number');
    if (win<1) or (win>formG.pageRec[page1-1].CadreCount(1)) then sortieErreur('TMultigraph.WinAlign : bad window number');
    result:=ord(formG.pageRec[page1-1].cadre[1,win-1].CdAlign);
  end;
end;

procedure proTMultigraph_ToolbarVisible(value:boolean;var pu:typeUO);
begin
  if pu=multigraph0 then exit;

  verifierObjet(pu);
  Tmultigraph(pu).formG.Panel1Top.Visible:=value;
end;


function fonctionTMultigraph_ToolbarVisible(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=Tmultigraph(pu).formG.Panel1Top.Visible;
end;


function fonctionTMultigraph_CurMgPage(var pu:typeUO):pointer;
var
  i:integer;
begin
  verifierObjet(pu);
  with Tmultigraph(pu) do
  begin
    i:=formG.TabPage1.TabIndex;

    result:=formG.pageRec[i];
  end;
end;

function fonctionTMgPage_UseVparams(pu:typeUO):boolean;
begin
  result:= TpageRec(pu).FuseVparams;
end;

procedure proTMgPage_UseVparams(w:boolean; pu:typeUO);
begin
  TpageRec(pu).FuseVparams:=w;
  if w then
    with TpageRec(pu) do
    begin
      visuP;
      visuFlags;
    end;
end;

function fonctionTMgPage_Vparams(pu:typeUO):pointer;
begin
  result:= TpageRec(pu).visuP;
end;

procedure proTMGpage_Vflag(n:integer;w:boolean; pu:typeUO);
begin
  if (n<0) or (n>ord(high(TvisuFlagIndex))) then sortieErreur('TMGpage.Vflag : index out of range');
  TpageRec(pu).visuFlags^[TvisuFlagIndex(n)]:=w;
end;

function fonctionTMGpage_Vflag(n:integer; pu:typeUO): boolean;
begin
  if (n<0) or (n>ord(high(TvisuFlagIndex))) then sortieErreur('TMGpage.Vflag : index out of range');
  result:= TpageRec(pu).visuFlags^[TvisuFlagIndex(n)];
end;

{ Stm functions for TmgVparams }

function fonctionTmgVparams_Xmin( pu:typeUO): float;
begin
  result:=PvisuInfo(pu)^.Xmin;
end;

procedure proTmgVparams_Xmin(w:float; pu:typeUO);
begin
  PvisuInfo(pu)^.Xmin:=w;
  PvisuInfo(pu)^.FvisuFlags^[VF_Xmin]:=true;
end;

function fonctionTmgVparams_Xmax( pu:typeUO): float;
begin
  result:=PvisuInfo(pu)^.Xmax;
end;

procedure proTmgVparams_Xmax(w:float; pu:typeUO);
begin
  PvisuInfo(pu)^.Xmax:=w;
  PvisuInfo(pu)^.FvisuFlags^[VF_Xmax]:=true;
end;

function fonctionTmgVparams_Ymin( pu:typeUO): float;
begin
  result:=PvisuInfo(pu)^.Ymin;
end;

procedure proTmgVparams_Ymin(w:float; pu:typeUO);
begin
  PvisuInfo(pu)^.Ymin:=w;
  PvisuInfo(pu)^.FvisuFlags^[VF_Ymin]:=true;
end;

function fonctionTmgVparams_Ymax( pu:typeUO): float;
begin
  result:=PvisuInfo(pu)^.Ymax;
end;

procedure proTmgVparams_Ymax(w:float; pu:typeUO);
begin
  PvisuInfo(pu)^.Ymax:=w;
  PvisuInfo(pu)^.FvisuFlags^[VF_Ymax]:=true;
end;


function fonctionTmgVparams_color( pu:typeUO): longint;
begin
  result:=PvisuInfo(pu)^.color;
end;

procedure proTmgVparams_color(w:longint; pu:typeUO);
begin
  PvisuInfo(pu)^.color:=w;
  PvisuInfo(pu)^.FvisuFlags^[VF_color]:=true;
end;

function fonctionTmgVparams_color2( pu:typeUO): longint;
begin
  result:=PvisuInfo(pu)^.color2;
end;

procedure proTmgVparams_color2(w:longint; pu:typeUO);
begin
  PvisuInfo(pu)^.color2:=w;
  PvisuInfo(pu)^.FvisuFlags^[VF_color2]:=true;
end;

function fonctionTmgVparams_mode( pu:typeUO): longint;
begin
  result:=PvisuInfo(pu)^.modeT;
end;

procedure proTmgVparams_mode(w:longint; pu:typeUO);
begin
  PvisuInfo(pu)^.modeT:=w;
  PvisuInfo(pu)^.FvisuFlags^[VF_modeT]:=true;
end;

function fonctionTmgVparams_SymbolSize( pu:typeUO): longint;
begin
  result:=PvisuInfo(pu)^.tailleT;
end;

procedure proTmgVparams_SymbolSize(w:longint; pu:typeUO);
begin
  PvisuInfo(pu)^.tailleT:=w;
  PvisuInfo(pu)^.FvisuFlags^[VF_tailleT]:=true;
end;


function fonctionTmgVparams_LineWidth( pu:typeUO): longint;
begin
  result:=PvisuInfo(pu)^.largeurTrait;
end;

procedure proTmgVparams_LineWidth(w:longint; pu:typeUO);
begin
  PvisuInfo(pu)^.largeurTrait:=w;
  PvisuInfo(pu)^.FvisuFlags^[VF_largeurTrait]:=true;
end;


procedure proTmgVparams_LogX(x:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.modelogX:=x;
  PvisuInfo(pu)^.FvisuFlags^[VF_modelogX]:=true;
end;

function fonctionTmgVparams_LogX( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.modelogX;
end;

procedure proTmgVparams_LogY(x:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.modelogY:=x;
  PvisuInfo(pu)^.FvisuFlags^[VF_modelogY]:=true;
end;

function fonctionTmgVparams_LogY(pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.modelogY;
end;

procedure proTmgVparams_Xscale(x:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.echX:=x;
  PvisuInfo(pu)^.FvisuFlags^[VF_echX]:=true;
end;

function fonctionTmgVparams_Xscale( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.echX;
end;

procedure proTmgVparams_Yscale(x:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.echY:=x;
  PvisuInfo(pu)^.FvisuFlags^[VF_echY]:=true;
end;

function fonctionTmgVparams_Yscale( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.echY;
end;

procedure proTmgVparams_Xticks(x:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.FtickX:=x;
  PvisuInfo(pu)^.FvisuFlags^[VF_FtickX]:=true;
end;

function fonctionTmgVparams_Xticks( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.FtickX;
end;

procedure proTmgVparams_Yticks(x:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.FtickY:=x;
  PvisuInfo(pu)^.FvisuFlags^[VF_FtickY]:=true;
end;

function fonctionTmgVparams_Yticks( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.FtickY;
end;

procedure proTmgVparams_ExtTicksX(x:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.TickExtX:=x;
  PvisuInfo(pu)^.FvisuFlags^[VF_TickExtX]:=true;
end;

function fonctionTmgVparams_ExtTicksX( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.TickExtX;
end;


procedure proTmgVparams_ExtTicksY(x:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.TickExtY:=x;
  PvisuInfo(pu)^.FvisuFlags^[VF_TickExtY]:=true;
end;

function fonctionTmgVparams_ExtTicksY( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.TickExtY;
end;


procedure proTmgVparams_RightTicks(x:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.completY:=x;
  PvisuInfo(pu)^.FvisuFlags^[VF_completY]:=true;
end;

function fonctionTmgVparams_RightTicks( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.completY;
end;

procedure proTmgVparams_TopTicks(x:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.completX:=x;
  PvisuInfo(pu)^.FvisuFlags^[VF_completX]:=true;
end;

function fonctionTmgVparams_TopTicks( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.completX;
end;


procedure proTmgVparams_ZeroAxisX(x:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.FscaleX0:=x;
  PvisuInfo(pu)^.FvisuFlags^[VF_FscaleX0]:=true;
end;

function fonctionTmgVparams_ZeroAxisX( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.FscaleX0;
end;


procedure proTmgVparams_ZeroAxisY(x:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.FscaleY0:=x;
  PvisuInfo(pu)^.FvisuFlags^[VF_FscaleY0]:=true;
end;

function fonctionTmgVparams_ZeroAxisY( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.FscaleY0;
end;


procedure proTmgVparams_keepAspectRatio(b:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.keepRatio:=b;
  PvisuInfo(pu)^.FvisuFlags^[VF_keepRatio]:=true;
end;

function fonctionTmgVparams_keepAspectRatio( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.keepRatio;
end;

procedure proTmgVparams_inverseX(b:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.inverseX:=b;
  PvisuInfo(pu)^.FvisuFlags^[VF_inverseX]:=true;
end;

function fonctionTmgVparams_inverseX( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.inverseX;
end;


procedure proTmgVparams_inverseY(b:boolean; pu:typeUO);
begin
  PvisuInfo(pu)^.inverseY:=b;
  PvisuInfo(pu)^.FvisuFlags^[VF_inverseY]:=true;
end;

function fonctionTmgVparams_inverseY( pu:typeUO):boolean;
begin
  result:=PvisuInfo(pu)^.inverseY;
end;



procedure TmultiGraph.FreeResources3DG;
var
  i,j,p,wt:integer;
  listU:Tlist;
  uo:typeUO;
begin
  with formG do
  begin
    for p:=0 to pageCount-1 do
    for wt:=1 to 2 do
      for i:=0 to count(p,wt)-1 do
        begin
          listU:=getP(p,i,wt);
          if assigned(listU) then
            for j:=0 to listU.count-1 do
              begin
                uo:=typeUO(listU.items[j]);
                uo.FreeDXresources;
              end;
        end;
  end;

end;

function CreerMG: Tmultigraph;
var
  stName,stTitle: AnsiString;
  i:integer;
begin
  result:=nil;

  i:=0;
  repeat
    inc(i);
    stName:= 'MG'+Istr(i);
  until MainObjList.accept(stName);

  with NewMGlist do
  begin
    accept:=MainObjList.accept;
    if not execution(stName,stTitle) then exit;
  end;

  result:= Tmultigraph.create;
  result.ident:= stName;
  if stTitle<>'' then result.caption:= stTitle;
  result.notPublished:=false;
  result.Fchild:=false;

  MainObjList.add(result,UO_temp);
end;

function CreerMGlist(var stTitle: AnsiString): TobjectList;
var
  stName: AnsiString;
  i:integer;
begin
  result:=nil;

  i:=0;
  repeat
    inc(i);
    stName:= 'MGlist'+Istr(i);
  until MainObjList.accept(stName);

  with NewMGlist do
  begin
    accept:=MainObjList.accept;
    if not execution(stName,stTitle) then exit;
  end;

  result:= TobjectList.create;
  result.ident:= stName;
  result.notPublished:=false;
  result.Fchild:=false;

  MainObjList.add(result,UO_temp);
end;


procedure TmultiGraph.CreateSimpleMG;
var
  mg: Tmultigraph;
begin
  typeUO(mg):= CreerMG;
  if assigned(mg) then
  begin
    mgFromPage(mg,nil,formG.CurrentPage);
    mg.show(self);
  end;

end;

procedure Tmultigraph.CreateObjList; // crée un Multigraph à partir d'une page
var
  objList: TobjectList;
  mg: Tmultigraph;
  Atitle: AnsiString;
begin
  typeUO(objList):= CreerMGlist(Atitle);
  if assigned(objlist) then
  begin
    mg:=Tmultigraph.create;
    mg.ident:=objList.ident+'.'+ident;

    if Atitle<>'' then mg.Caption:= Atitle else mg.Caption:= mg.Ident;

    objList.AddToList(mg);

    mgFromPage(mg,objlist,formG.CurrentPage);
    mg.show(self);
  end;
end;

procedure TmultiGraph.CreateMgFromWindow(sender: Tobject);
var
  mg: Tmultigraph;
begin
  typeUO(mg):= CreerMG;
  if assigned(mg) then
  begin
    mgFromWindow(mg,nil,formG.CurrentPage,TmenuItem(sender).Tag);
    mg.show(self);
  end;
end;

procedure TmultiGraph.CreateObjListFromWindow(sender: Tobject);
var
  objList: TobjectList;
  mg: Tmultigraph;
  Atitle: AnsiString;
begin
  typeUO(objList):= CreerMGlist(Atitle);
  if assigned(objlist) then
  begin
    mg:=Tmultigraph.create;
    mg.ident:=objList.ident+'.'+ident;

    if Atitle<>'' then mg.Caption:= Atitle else mg.Caption:= mg.Ident;

    objList.AddToList(mg);

    mgFromWindow(mg,objlist,formG.CurrentPage,TmenuItem(sender).Tag);
    mg.show(self);
  end;
end;

const
  DefMgFile:AnsiString='*.MGP';

procedure TmultiGraph.LoadPageFromObjFile;
var
  f:TobjectFile;
  objList: TobjectList;
  st:AnsiString;
  res:boolean;
  i:integer;
begin

  st:=DefMgFile;
  st:=GchooseFile('Open an object file',st);
  if st='' then exit;

  DefMgFile:=st;


  ObjList:=TobjectList.create;
  f:= TobjectFile.create;
  try
  f.openFile(st);
  res:= f.load(ObjList,false);

  finally
  f.free;
  end;

  i:=0;
  repeat
    inc(i);
    st:='MGlist'+Istr(i);
  until MainObjList.accept(st);
  ObjList.ChangeName(st);
   MainObjList.add(ObjList,UO_temp);

  ObjList.setLocalRef;
  ObjList.setChildNames;

  with objlist do
  if (count>0) and (Objects[1] is Tmultigraph) then
  with Tmultigraph(Objects[1]).formG do
  begin
    formStyle:=fsStayOnTop;
    //caption:= Objects[1].ident;
    show;
  end;
end;

procedure TmultiGraph.SavePageAsObjFile;
var
  objList: TobjectList;
  mg: Tmultigraph;

  oac:TobjectFile;
  stSave:AnsiString;

begin
  objList:= TobjectList.create;
  objList.ident:='MGlist';
  mg:=Tmultigraph.create;
  mg.ident:='MG';
  mg.caption:=caption;

  try
  objList.AddToList(mg);
  oac:=TobjectFile.create;

  mgFromPage(mg,objlist,formG.CurrentPage);

  if not sauverFichierStandard(stSave,'MGP') then exit;

  if fileExists(stSave) then
    if MessageDlg('File already exists. Continue ?',mtConfirmation,[mbYes,mbNo],0)<>mrYes  then exit;

  oac.createFile(stSave);
  if oac.error<>0 then
  begin
    messageCentral('Error creating '+stSave);
    exit;
  end;

  oac.save(objList);
  if oac.error<>0 then
    begin
      messageCentral('Error saving '+stSave);
      exit;
    end;

  finally
  oac.free;
  objList.Free;
  end;
end;

function TmultiGraph.GetMgList: TstringList;
var
  i,k:integer;


begin
  result:=TstringList.create;
  for i:=0 to MgList.count-1 do
    result.AddObject(typeUO(Mglist[i]).ident, Mglist[i]);

end;

function TmultiGraph.getCaption: AnsiString;
begin
  if formG<>nil then result:= formG.MgCaption;
end;

procedure TmultiGraph.setCaption(st: AnsiString);
begin
  if formG<>nil then
  begin
    formG.MgCaption:=st;
    formG.Caption:=st;
  end;
end;



procedure TmultiGraph.setIdent(st: AnsiString);
var
  stCap:AnsiString;
begin
  stCap:=caption;    // on neutralise le setident de Tdata0
  inherited;
  caption:=stCap;
end;

Initialization
AffDebug('Initialization multg1',0);

installError(E_page,'Tmultigraph: invalid page number');
installError(E_pageOrWindow,'Tmultigraph: invalid page or window number');
installError(E_initGrid,'Tmultigraph: unable to create a grid');
installError(E_newWindow,'Tmultigraph: unable to create a new window');

MgList:=Tlist.create;


registerObject(TmultiGraph,data);
registerObject(TmultiGraphDAC,sys);

end.
