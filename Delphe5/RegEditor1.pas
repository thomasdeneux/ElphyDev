unit RegEditor1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Menus,math,
  Buttons, EditScroll1, editcont,
  util1,Dgraphic,DdosFich,DibG,Dpalette,BMex1,visu0, debug0,
  stmDef,stmObj,stmDplot,stmDobj1,stmMat1,Regions1,stmRegion1,stmBMplot1,stmOIseq1,
  ComCtrls,
  DBrecord1;


{ La fiche permet d'éditer un objet TregionList avec un objet TdataObj en arrière plan.

  La procédure Install reçoit trois paramètres: owner, dataObj et regionList.
  owner est égal à dataObj ou RegionList

  Actuellement, l'utilisateur ne peut pas changer ces objets.

  TregEditor peut être créée par
    TBitmapPlot et descendants (TOIseq)
    Tmatrix et descendants
    TregionList
}

type
  TRegEditor = class(TForm)
    PaintBox0: TPaintBox;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelMouse: TPanel;
    Panel4: TPanel;
    Bcadrer: TBitBtn;
    PopupRegion: TPopupMenu;
    Region1: TMenuItem;
    Delete1: TMenuItem;
    Edit1: TMenuItem;
    MainMenu1: TMainMenu;
    Regions1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    Clear1: TMenuItem;
    scrollbarV: TscrollbarV;
    scrollbarH: TscrollbarV;
    ColorDialog1: TColorDialog;
    Coordinates1: TMenuItem;
    Showlist1: TMenuItem;
    File1: TMenuItem;
    LoadBK1: TMenuItem;
    SaveBK1: TMenuItem;
    SelectAll1: TMenuItem;
    UnSelectAll1: TMenuItem;
    PanelRight: TPanel;
    PageControl1: TPageControl;
    TabRegions: TTabSheet;
    GBdisplay: TGroupBox;
    cbDisplayRegions: TCheckBoxV;
    cbDisplayPixels: TCheckBoxV;
    PregionColor: TPanel;
    BregionColor: TButton;
    Panel3: TPanel;
    Brectangle: TSpeedButton;
    Bcircle: TSpeedButton;
    Bpolygon: TSpeedButton;
    Bselect: TSpeedButton;
    Btrajectory: TSpeedButton;
    GroupBox1: TGroupBox;
    Lhighlight: TLabel;
    SBhighlight: TScrollBar;
    BhighLightColor: TButton;
    PhighlightColor: TPanel;
    BhighSelect: TButton;
    TabCoo: TTabSheet;
    PanelX: TPanel;
    LG0: TLabel;
    SBG0: TscrollbarV;
    BautoG0: TBitBtn;
    PanelZ: TPanel;
    BautoZ: TBitBtn;
    ESCzmin: TEditScroll;
    ESCZmax: TEditScroll;
    GroupOIseq: TGroupBox;
    Lindex1: TLabel;
    sbindex: TscrollbarV;
    PanelPCL: TPanel;
    BitBtn1: TBitBtn;
    EscBinX: TEditScroll;
    EscBinY: TEditScroll;
    EscBinT: TEditScroll;
    Options1: TMenuItem;
    Lindex2: TLabel;
    LNframe: TLabel;
    enNframe: TeditNum;
    cbNoOverlap: TCheckBoxV;
    BsmartRect: TSpeedButton;
    TabFilters: TTabSheet;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    cbFilterActive: TCheckBoxV;
    BupdateFilter: TButton;
    BsaveFilter: TButton;
    FilterX: TEditScroll;
    FilterY: TEditScroll;
    FilterDx: TEditScroll;
    FilterDy: TEditScroll;
    TabScales: TTabSheet;
    GroupBox4: TGroupBox;
    EsOriginX: TEditScroll;
    EsOriginY: TEditScroll;
    GroupBox5: TGroupBox;
    enXaxisPix: TeditNum;
    Label1: TLabel;
    enXaxisDx: TeditNum;
    Label2: TLabel;
    esXaxisUnits: TeditString;
    GroupBox6: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    enYaxisPix: TeditNum;
    enYaxisDy: TeditNum;
    esYaxisUnits: TeditString;
    FilterTheta: TEditScroll;
    GroupBox7: TGroupBox;
    FilterVx: TEditScroll;
    FilterVy: TEditScroll;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox0Paint(Sender: TObject);
    procedure BcadrerClick(Sender: TObject);
    procedure SBG0ScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure BautoG0Click(Sender: TObject);
    procedure BautoZClick(Sender: TObject);
    procedure BrectangleClick(Sender: TObject);
    procedure PaintBox0MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox0MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBox0MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox0DblClick(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure cbDisplayRegionsClick(Sender: TObject);
    procedure cbDisplayPixelsClick(Sender: TObject);
    procedure Load1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure Clear1Click(Sender: TObject);
    procedure sbindexScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure scrollbarHScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure scrollbarVScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure BregionColorClick(Sender: TObject);
    procedure Coordinates1Click(Sender: TObject);
    procedure Showlist1Click(Sender: TObject);
    procedure LoadBK1Click(Sender: TObject);
    procedure SaveBK1Click(Sender: TObject);
    procedure SelectAll1Click(Sender: TObject);
    procedure UnSelectAll1Click(Sender: TObject);
    procedure BhighLightColorClick(Sender: TObject);
    procedure SBhighlightScroll(Sender: TObject; ScrollCode: TScrollCode;
      var ScrollPos: Integer);
    procedure BhighSelectClick(Sender: TObject);
    procedure PaintBox0EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure BcircleClick(Sender: TObject);
    procedure Options1Click(Sender: TObject);
    procedure EscBinTExit(Sender: TObject);
    procedure enNframeExit(Sender: TObject);
    procedure cbNoOverlapClick(Sender: TObject);
    procedure cbFilterActiveClick(Sender: TObject);
    procedure BsaveFilterClick(Sender: TObject);
  private
    { Déclarations privées }
    owner0:TdataPlot;                {égal à dataPlot ou regionList}

    FdataPlot:TdataObj;           {objet backGround}
    regionList0:TregionList;      {les régions}


    BMfen:TbitmapEx;
    Fvalid:boolean;

    xs1,ys1,xs2,ys2:float;         { rectangle source dans l'image : coo fichier }

    pop:TpopUpMenu;
    Fcap:boolean;                  { signale qu'une région est en construction }
    Fpoly:boolean;                 { signale qu'un polygone est en construction }

    FdisplayRegions:boolean;

    reg:Treg;
    FclosePoly:boolean;

    stFile:AnsiString;


    rectI:Trect;

    Zmini,Zmaxi:float;


    FlagUpdate:boolean;
    FlagUpdateG0:boolean;
    FlagUpdateHighlight:boolean;

    RegSel:integer;             { numéro de la région sélectionnée -1 =aucune}
    HandleSel:integer;          { numéro de la poignée sélectionnée 0 =aucune }
    Xmove,Ymove: float;


//    visuI:TvisuInfo;

    DumBinX, DumBinY: integer;
    DumBinDt: double;
    DumNframeU:integer;
    DumNoOverlap: boolean;

    DumOriginX, DumOriginY: single;
    DumDeltaX, DumDeltaY: single;
    DumXpix, DumYpix: integer;
    DumUnitX, DumUnitY: AnsiString;

    HpanelPCL:integer;
    TopEnNframe: integer;
    TopLNframe: integer;
    TopNoOverlap: integer;

    TheLine:Trect;
    Fline:boolean;

    Frotate: boolean;
    Xrotate, Yrotate: integer;
    OldXs, OldYs: integer;

    PopupX,PopupY:integer;
    procedure drawLine;
    procedure setLine(x1,y1,x2,y2:float);


    procedure resizeBM;
    procedure BMpaint;
    procedure DrawBM;


    procedure setG0Ctrl;

    procedure setIndexCtrl;
    procedure setHighLightCtrl;

    procedure selectTool(num:integer);
    procedure setSelectedTool;
    procedure initBMfenGraphic;
    procedure initPaintbox0Graphic;

    procedure changeZminmax;
    procedure setLumContCtrl;

    procedure changeBinX;
    procedure changeBinY;
    procedure changeBinDT;
    procedure ChangeNframeU(sender: Tobject);
    procedure setPCLcontrol;
    procedure ChangeFilter;
    procedure ChangeScale;
    procedure ChangeScale1(sender: Tobject);


    procedure UpdateControls;

    procedure installRegionList(rr:TregionList);
    procedure installDataPlot(dd:TdataObj);

    function inverseX:boolean;
    function inverseY:boolean;


    procedure UpdateBK;

    procedure SetNewWorld(xD,yD,Gd:float);
    procedure SetCoupledXY;

  public
    { Déclarations publiques }
    LoadBK,SaveBK: procedure of object;

    property regionList:TregionList read RegionList0;
    property dataPlot:TdataObj read FdataPlot;

    procedure invalidate;override;
    procedure ProcessMessage(id:integer;source:typeUO;p:pointer);
    procedure install(owner: TdataPlot;dataObj:TdataObj;Rlist:TregionList);

    function PBMouseDown(Fext:boolean; Button: TMouseButton;  Shift: TShiftState; X, Y: Integer):boolean;
    function PBMouseMove(Fext:boolean; Shift: TShiftState; X,Y: Integer):boolean;
    procedure PBMouseUp(Fext:boolean; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    procedure PaintReg(Fext:boolean);
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

{ TregEditor }
uses RegEditOptions, stmdf0;

procedure TRegEditor.resizeBM;
begin
  if (BMfen.width<>paintbox0.width) or (BMfen.height<>paintbox0.height) then
  begin
    BMfen.width:=paintbox0.width;
    BMfen.height:=paintbox0.height;

    Fvalid:=false;
  end;
end;

procedure TRegEditor.initBMfenGraphic;
var
  n:integer;
begin
  initGraphic(BMfen);
  with rectI do setWindow(left,top,right,bottom);

  n:= ord(inverseX) +2*ord(inverseY);
  case n of
    0: setWorld(xs1,ys1,xs2,ys2);
    1: setWorld(xs2,ys1,xs1,ys2);
    2: setWorld(xs1,ys2,xs2,ys1);
    3: setWorld(xs2,ys2,xs1,ys1);
  end;
end;

procedure TRegEditor.initPaintbox0Graphic;
var
  n:integer;
begin
  with paintBox0 do initGraphic(canvas,left,top,width,height);
  with rectI do setWindow(left,top,right,bottom);

  n:= ord(inverseX) +2*ord(inverseY);
  case n of
    0: setWorld(xs1,ys1,xs2,ys2);
    1: setWorld(xs2,ys1,xs1,ys2);
    2: setWorld(xs1,ys2,xs2,ys1);
    3: setWorld(xs2,ys2,xs1,ys1);
  end;
end;


procedure TRegEditor.BMpaint;
var
  Fworld,FlogX,FlogY:boolean;

begin
  initGraphic(BMfen);
  ClearWindow(owner0.BKcolor);

  if assigned(dataPlot) then
  begin
    with dataPlot do
    begin
      rectI:=getInsideWindow;
      display;

      with rectI do setWindow(left,top,right,bottom);
      getWorldPriorities(Fworld,FlogX,FlogY,xs1,ys1,xs2,ys2);
      // getWorldPriority renvoie un world qui dépend de la fenêtre courante.

      Dgraphic.setWorld(xs1,ys1,xs2,ys2);
      with rectI do

      if FdisplayRegions
        then regionList.displayInside(dataPlot,false,false,false);
    end;
  end
  else
  if FdisplayRegions then
  with regionList do
  begin
    rectI:=getInsideWindow;

    display;
    getWorld(xs1,ys1,xs2,ys2);
  end;

  doneGraphic;
end;



procedure TRegEditor.DrawBM;
begin
  paintbox0.canvas.draw(0,0,BMfen);
end;



procedure TRegEditor.PaintBox0Paint(Sender: TObject);
begin
  resizeBM;

  BMfen.restoreRects;
  if not Fvalid then BMpaint;
  { Ajouter ici les dessins extra BMfen }
  DrawBM;

  PaintReg(false);
  if Frotate then drawLine;

  Fvalid:=true;
end;

procedure TRegEditor.PaintReg(Fext:boolean);
begin
  if assigned(reg) then
  begin
    if not Fext then initPaintBox0graphic;

    canvasGlb.Brush.Style:=bsClear;
    reg.draw;

    if not Fext then doneGraphic;
  end;

end;



procedure TRegEditor.FormCreate(Sender: TObject);
begin
  BMfen:=TbitmapEx.create;
  FdisplayRegions:=true;

  xs2:=1;
  ys2:=1;
  RegSel:=-1;



end;

procedure TRegEditor.FormDestroy(Sender: TObject);
begin
  BMfen.free;
end;

procedure TRegEditor.invalidate;
var
  rr:Trect;
begin
  updateControls;

  Fvalid:=false;
  if not assigned(paintbox0) then exit;
  with paintbox0 do rr:=rect(left,top,left+Width-1,top+height-1);
  invalidateRect(handle,@rr,false);
end;

const
  Ovalue=1E1000;

procedure TRegEditor.SetNewWorld(xD,yD,Gd:float);
var
  visuDum:TvisuInfo;
begin
  if not assigned(owner0) then exit;

  initGraphic(BMfen);

  with owner0 do
  begin
    if Gd<>Ovalue then Gdisp:=Gd;
    if Xd<>Ovalue then xDisp:=Xd;
    if Yd<>Ovalue then yDisp:=Yd;
    GdispToWorld(GDisp,xdisp,ydisp);
    invalidate;
  end;
  doneGraphic;
end;

procedure TRegEditor.scrollbarHScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  SetNewWorld(x,Ovalue,Ovalue);
end;

procedure TRegEditor.scrollbarVScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  SetNewWorld(Ovalue,x,Ovalue);
end;


procedure TRegEditor.BcadrerClick(Sender: TObject);
begin
  SetNewWorld(0,0,Ovalue);
end;


procedure TRegEditor.SBG0ScrollV(Sender: TObject; x: Extended; ScrollCode: TScrollCode);
begin
  if not FlagUpdateG0 then
  begin
    SetNewWorld(Ovalue,Ovalue,x);
    setG0ctrl;
  end;
end;

procedure TRegEditor.BautoG0Click(Sender: TObject);
begin
  SetNewWorld(Ovalue,Ovalue,1);
  setG0ctrl;
end;

procedure TRegEditor.BautoZClick(Sender: TObject);
begin
  if assigned(dataPlot) then
  begin
    dataPlot.AutoScaleZ;
    dataPlot.invalidate;
    setLumContCtrl;
  end;
end;

procedure TRegEditor.setG0Ctrl;
begin
  FlagUpdateG0:=true;
  SBG0.setParams(owner0.GDisp,0.1,100);
  LG0.Caption:='G0='+Estr(owner0.GDisp,3);
  FlagUpdateG0:=false;
end;


procedure TRegEditor.setLumContCtrl;
begin
  if assigned(dataPlot) then
  with dataPlot do
  begin
    FlagUpdate:=true;
    ESCzmin.init(visu.zmin,g_double,-10000,10000,3);
    ESCzmin.onChange := ChangeZminmax;

    ESCzmax.init(visu.zmax,g_double,-10000,10000,3);
    ESCzmax.onChange := ChangeZminmax;
    FlagUpdate:=false;
  end;
end;

procedure TRegEditor.setIndexCtrl;
var
  tt:float;
begin
  if assigned(dataPlot) and (dataPlot is TOiSeq) then
  with TOIseq(dataPlot) do
  begin
    SBindex.setParams(index ,0,FrameCount-1);
    tt:=dataPlot.IndexToReal(index);
    Lindex1.Caption:='Index= '+Estr(index,3);
    Lindex2.Caption:='t = '+Estr(tt,3)+' '+unitX;     
  end;
end;


procedure TRegEditor.BrectangleClick(Sender: TObject);
begin
  ;
end;

function TRegEditor.PBMouseDown(Fext:boolean; Button: TMouseButton; Shift: TShiftState; X, Y: Integer):boolean;
var
  tool,num:integer;
  handleDum:integer;
  p:Tpoint;
  XR1, YR1: float;
  x1,y1:single;
begin
  result:=false;
  if not assigned(regionList) then exit;
  HandleSel:=0;
  tool:=regionList.toolSelected;

  if not Fext and (tool=0) and assigned(dataPlot) and dataPlot.GbeginDrag then paintBox0.beginDrag(false)
  else
  if (tool=4) then                                     {outil de sélection}
    case button of
      mbLeft: begin                                    {déplacement de la région}
                if not Fext then initBMfenGraphic;

                HandleSel:= regionList.regList.ptInHandleRect(x,y);

                Xmove:= invconvWx(x);
                Ymove:= invconvWy(y);

                if HandleSel=0 then
                begin
                  RegSel:=regionList.regList.ptInRegion(Xmove,Ymove,handleSel);

                  if not(ssCtrl in shift) and not ((RegSel>=0) and (regionList.selected[RegSel])) then
                  begin
                    regionList.regList.clearSelection;
                    if (regsel<0) and assigned(dataPlot) and dataPlot.GbeginDrag then paintBox0.beginDrag(false);
                  end;

                  regionList.regList.AddSelection(RegSel);
                end;
                invalidate;
                if not Fext then doneGraphic;
                exit;
              end;
      mbRight:begin                                    {clic droit: on identifie la région }
                p:=paintbox0.clientToScreen(point(x,y));
                if not Fext then initBMfenGraphic;

                Num:=regionList.regList.ptInRegion(invconvWx(x),invconvWy(y),handleDum);
                if (num>=0) and regionList.Selected[num] then
                begin                                  {on fait apparaitre un popup pour la région sélectionnée }
                  region1.caption:='Region '+Istr(Num+1); ;
                  PopupX:=p.x;
                  PopupY:=p.y;
                  popupRegion.Popup(p.x,p.y);
                end
                else
                begin
                  FRotate:= regionList.regList.canRotate(XR1,YR1);
                  Xrotate:=convWx(xR1);
                  Yrotate:=convWy(YR1);

                  if Frotate then
                  begin
                    setLine(x,y,Xrotate, Yrotate);
                    oldXs:=x;
                    oldYs:=y;

                  end;
                end;

                if not Fext then doneGraphic;
                exit;
              end;
    end;

  if button=mbRight then
  begin
    Fcap:=false;
    Fpoly:=false;
    FclosePoly:=false;
    reg.Free;
    reg:=nil;
    invalidate;
    exit;
  end;

  if FclosePoly then
  begin
    FclosePoly:=false;
    exit;
  end;

  if not Fext then initBMfenGraphic;

  x1:=invconvWx(x);
  y1:=invconvWy(y);


  case tool of
    1: begin
         reg:=TrectReg.create(x1,y1);     {Création nouveau rectangle}
         Fcap:=true;
       end;
    2: begin                            {Création nouvel ellipse}
         reg:=TellipseReg.create(x1,y1);
         Fcap:=true;
       end;
    3: begin                            {Création nouveau polygone}
         if not Fpoly then reg:=TpolygonReg.create(x1,y1);
         Fcap:=true;
         Fpoly:=true;
       end;

    5: begin                            {Création nouveau polygone}
         reg:=TpolygonReg.create(x1,y1);
         Fcap:=true;
         Fpoly:=false;
       end;
    6: begin
         reg:=TSmartRectReg.create(x1,y1);     {Création nouveau rectangle}
         Fcap:=true;
       end;
  end;

  if assigned(reg) then reg.color:=regionList.regList.Defcolor;
  if not Fext then doneGraphic;

  result:=Fcap;
end;

procedure TRegEditor.PaintBox0MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  PBMouseDown(false,Button, Shift, X, Y);
end;

function TRegEditor.PBMouseMove(Fext:boolean; Shift: TShiftState; X, Y: Integer):boolean;
var
  x1,y1: float;
  i1,j1:integer;
  z1:float;
  tool:integer;
  th: float;
begin
  result:=false;
  if not assigned(regionList) then exit;
  tool:=regionList.toolSelected;

  if not Fext then initBMfenGraphic;

  x1:= invconvWx(x);
  y1:= invconvWy(y);


  if not Frotate then
  begin
    if assigned(dataPlot) then
    begin
      i1:= dataPlot.invconvx(x1);
      j1:= dataPlot.invconvy(y1);
    end
    else
    begin
      i1:=Round(x1);
      j1:=Round(y1);
    end;

    if assigned(dataPlot) and (dataPlot is TOiSeq) then
    with TOIseq(dataPlot) do
    begin
      if (i1>=0) and (i1<Icount) and (j1>=0) and (j1<Jcount)
        then z1:=mat[index].Zvalue[i1,j1]
        else z1:=0;
      PanelMouse.caption:=Estr(x1,3)+'/'+Estr(y1,3)+' : '+Estr(z1,3) ;
    end
    else
    PanelMouse.caption:=Estr(i1,0)+'/'+Estr(j1,0);
  end;

  if HandleSel>0 then
  begin
    regionList.regList.modifySelection(HandleSel,x1-Xmove,y1-Ymove);
    Xmove:=x1;
    Ymove:=y1;
    invalidate;
  end
  else
  if tool=4 then
  begin
    if RegSel>=0 then                   {Déplacement région }
    begin
      regionList.regList.moveSelection(x1-Xmove,y1-Ymove);
      Xmove:=x1;
      Ymove:=y1;
      invalidate;
    end
    else
    if Frotate then
    begin
      if (oldXs<>x) or (oldYs<>y) then
      begin
        if x-xRotate<>0
          then th:=regionList.regList.ModifyTheta((x-xRotate)*(1-2*ord(inverseX)),(y-yRotate)*(1-2*ord(inverseY)))
          else th:=0;
        setLine(xRotate,yRotate,x,y);

        oldXs:=x;
        oldYs:=y;

        PanelMouse.caption:=' Theta = '+ Estr(th,3);
      end
    end;
  end
  else
  if Fcap then
  begin
    if tool=5
      then reg.addPoint(x1,y1)
      else reg.MovePt(x1,y1,false);                {Construction région}
    invalidateRect(handle,nil,false);
  end;
  if not Fext then doneGraphic;

  result:=true;
end;

procedure TRegEditor.PaintBox0MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  PBMouseMove(false,Shift, X, Y);
end;

procedure TRegEditor.PBMouseUp(Fext:boolean; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tool:integer;
  x1,y1: float;
begin
  if not assigned(regionList) then exit;
  tool:=regionList.toolSelected;

  if not Fext then initBMfenGraphic;
  x1:= invconvWx(x);
  y1:= invconvWy(y);

  RegSel:=-1;
  HandleSel:=-1;

  if Fcap then
  begin
    if tool=5 then
    begin
      reg.addPoint(x1,y1);
      reg.close;
    end
    else reg.MovePt(x1,y1,true);                   {On termine la région commencée}

    if Fpoly then
    begin
      reg.AddPoint(x1,y1);
    end
    else
    begin
      regionList.regList.Add(reg);
      reg:=nil;
      Fcap:=false;

    end;
    setHighLightCtrl;
  end;
  if not Fext then doneGraphic;

  regionList.invalidateData;
end;

procedure TRegEditor.PaintBox0MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Frotate then
  begin
    Frotate:=false;
    invalidate;
  end
  else PBMouseUp(false,Button, Shift, X, Y);

  selectTool(4);
end;

procedure TRegEditor.selectTool(num:integer);
begin
  case num of
    1: Brectangle.down := true;
    2: Bcircle.down := true;
    3: Bpolygon.down := true;
    4: Bselect.down := true;
    5: Btrajectory.Down := true;
    6: BsmartRect.down := true;
  end;
  if assigned(regionList) and (num in [1..6]) then regionList.toolSelected:=num;
end;

procedure TRegEditor.setSelectedTool;
var
  res:integer;
begin
  if not assigned(regionList) then res:=0
  else
  if Brectangle.down then res:=1
  else
  if Bcircle.down then res:=2
  else
  if Bpolygon.down then res:=3
  else
  if Bselect.down then res:=4
  else
  if Btrajectory.Down then res:=5
  else
  if BsmartRect.down then res:=6
  else res:=0;

  regionList.toolSelected:=res;
end;

procedure TRegEditor.PaintBox0DblClick(Sender: TObject);
begin
  if not assigned(regionList) then exit;
  if Fpoly then
  begin
    initBMfenGraphic;
    reg.close;

    regionList.regList.Add(reg);
    reg:=nil;
    Fcap:=false;
    Fpoly:=false;
    regionList.invalidate;
    doneGraphic;

    FclosePoly:=true;
  end;
end;

procedure TRegEditor.Delete1Click(Sender: TObject);
begin
  if not assigned(regionList) then exit;

  with regionList.regList do
  begin
    deleteSelection;
  end;
  regionList.invalidateData;
end;

procedure TRegEditor.Edit1Click(Sender: TObject);
begin
  if not assigned(regionList) then exit;

  with regionlist.regList do
  if (LastSelected >=0) and (LastSelected< Count)
    and region[LastSelected].edit('Region '+Istr(LastSelected+1),PopupX+20,PopupY+20)
      then invalidate;
end;

procedure TRegEditor.cbDisplayRegionsClick(Sender: TObject);
begin
  cbDisplayRegions.UpdateVar;
  if not FlagUpdate then invalidate;
end;

procedure TRegEditor.cbDisplayPixelsClick(Sender: TObject);
begin
  cbDisplayPixels.UpdateVar;
  if not FlagUpdate then invalidate;
end;

procedure TRegEditor.Load1Click(Sender: TObject);
var
  st:AnsiString;
begin
  if not assigned(regionList) then exit;
  if stFile='' then stFile:='*.rgn';
  st:=GchooseFile('Choose a region file',stFile);
  if st<>'' then
  begin
    regionList.regList.loadFromFile(st,dataPlot);
    stFile:=st;
    regionList.invalidate;
    invalidate;
  end;
end;

procedure TRegEditor.Save1Click(Sender: TObject);
var
  st:AnsiString;
begin
  if not assigned(regionList) then exit;
  st:=GsaveFile('Choose a region file',stFile,'rgn');
  if st<>'' then
  begin
    regionList.regList.saveToFile(st,dataPlot);
    stFile:=st;
  end;
end;


procedure TRegEditor.Clear1Click(Sender: TObject);
begin
  if assigned(regionList) and (messageDlg('Clear region list ?',mtConfirmation,[mbOK,mbCancel],0)= mrOK) then
  begin
    regionList.regList.clear;
    regionList.invalidate;
    invalidate;
  end;
end;

procedure TRegEditor.ProcessMessage(id: integer; source: typeUO; p: pointer);
begin
  if source=dataPlot then
  case id of
    uomsg_destroy:        installdataPlot(nil);
    uomsg_invalidate,
    uomsg_invalidateData: invalidate;
  end
  else
  if source=RegionList then
  case id of
    uomsg_destroy:        installRegionList(nil);
    uomsg_invalidate,
    uomsg_invalidateData: invalidate;
  end;
end;

procedure TRegEditor.sbindexScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  if assigned(dataPlot) and (dataPlot is TOiSeq) then
  with Toiseq(dataPlot) do
  begin
    index:=round(x);
    invalidate
  end;
  setIndexCtrl;
end;


procedure TRegEditor.BregionColorClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    color:=regionList.regList.Defcolor;
    if execute then
    begin
      regionList.regList.Defcolor:=color;
      PRegionColor.color:=color;
      PRegionColor.invalidate;
      self.invalidate;
      RegionList.invalidate;
    end;
  end;
end;

procedure TRegEditor.changeZminmax;
begin
  if not FlagUpdate then owner0.invalidate;
end;


procedure TRegEditor.Coordinates1Click(Sender: TObject);
begin
  owner0.chooseCoo(sender);
end;


procedure TRegEditor.Showlist1Click(Sender: TObject);
begin
  regionList.EditRegionList;
end;

procedure TRegEditor.UpdateControls;
var
  nbI,nbJ:float;
begin
  flagUpdate:=true;

  if assigned(dataPlot) and (dataPlot.Icount>0) and (dataPlot.Jcount>0) then
  with dataPlot do
  begin
    nbI:=abs(Icount*Dxu);
    nbJ:=abs(Jcount*Dyu);
  end
  else
  begin
    nbI:=100;
    nbJ:=100;
  end;

  if not assigned(scrollbarV) then exit;

  scrollbarV.SetParams(owner0.yDisp,-nbJ/2,nbJ/2);
  scrollbarV.LargeChange:=10;

  scrollbarH.SetParams(owner0.xDisp,-nbI/2,nbI/2);
  scrollbarH.LargeChange:=10;

  setG0Ctrl;
  setLumContCtrl;
  setHighLightCtrl;

  cbDisplayRegions.setVar(FdisplayRegions);


  setIndexCtrl;
  setPCLcontrol;


  flagUpdate:=false;
end;

procedure TRegEditor.installDataPlot(dd: TdataObj);
begin
  FdataPlot:=dd;
  updateControls;
end;


procedure TRegEditor.installRegionList(rr: TregionList);
begin
  regionList0:=rr;

  flagUpdate:=true;

  if assigned(regionList) then
  begin
    cbDisplayPixels.setVar(regionList.Fpix);
    PregionColor.Color:=regionList.regList.Defcolor;
    PhighlightColor.Color:=regionList.regList.HighLightColor;
  end;

  flagUpdate:=false;
end;

function TRegEditor.inverseX: boolean;
begin
  result:=owner0.inverseX;
end;

function TRegEditor.inverseY: boolean;
begin
  result:=owner0.inverseY;
end;

procedure TRegEditor.install(owner: TdataPlot; dataObj: TdataObj;  Rlist: TregionList);
begin
  owner0:=owner;
  installDataPlot(dataObj);
  installRegionList(Rlist);


  GroupOIseq.visible:=(dataObj is TOIseq);
  tabScales.TabVisible:= (dataObj is TOIseqPCL);
  tabFilters.TabVisible:= (dataObj is TOIseqPCL);

  PanelZ.Visible:=(dataObj is Tmatrix) or (dataObj is TOIseq);

  File1.visible:=(owner=Rlist);

  HpanelPCL:=panelPCL.Height;
  TopEnNframe:=enNframe.top;
  TopLNframe:=LNframe.top;
  TopNoOverlap:=cbNoOverlap.Top;

  setCoupledXY;
end;


procedure TRegEditor.LoadBK1Click(Sender: TObject);
begin
  if assigned(LoadBK) then LoadBK;
end;

procedure TRegEditor.SaveBK1Click(Sender: TObject);
begin
  if assigned(SaveBK) then SaveBK;
end;

procedure TRegEditor.updateBK;
begin
end;


procedure TRegEditor.SelectAll1Click(Sender: TObject);
begin
  regionList.SelectAll;
  regionList.invalidateData;
end;

procedure TRegEditor.UnSelectAll1Click(Sender: TObject);
begin
  regionList.UnselectAll;
  regionList.invalidateData;
end;

procedure TRegEditor.BhighLightColorClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    color:=regionList.regList.HighLightColor;
    if execute then
    begin
      regionList.regList.HighLightColor:=color;
      PhighlightColor.color:=Color;
      PhighlightColor.invalidate;
      self.invalidate;
      RegionList.invalidate;
    end;
  end;
end;

procedure TRegEditor.setHighLightCtrl;
var
  max:integer;
begin
  FlagUpdateHighlight:=true;
  if assigned(regionList) then
  with regionList.regList do
  begin
    if (NumHighLight<-1) or (NumHighLight>count-1) then NumHighLight:=-1;

    if count=0 then max:=1 else max:=count-1;
    SBhighLight.setParams(NumHighLight ,-1,max);
    if NumHighLight>=0
      then LhighLight.Caption:='Region '+Istr(NumHighLight+1)
      else LhighLight.Caption:='';
  end;
  FlagUpdateHighlight:=false;
end;

procedure TRegEditor.SBhighlightScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if not FlagUpdateHighlight then
  begin
    regionlist.regList.NumHighLight:=scrollPos;

    setHighLightCtrl;
    invalidate;
  end;
end;

procedure TRegEditor.BhighSelectClick(Sender: TObject);
begin
  with regionList.regList do
  if (numHighLight>=0) and (numHighLight<count) then
  begin
    region[NumHighLight].selected:= not region[NumHighLight].selected ;
    regionList.invalidateData;
  end;
end;

procedure TRegEditor.PaintBox0EndDrag(Sender, Target: TObject; X,
  Y: Integer);
begin
  resetDragUO;
end;

procedure TRegEditor.BcircleClick(Sender: TObject);
begin
  setSelectedTool;
end;


procedure TRegEditor.changeBinX;
begin
  if not FlagUpdate then
  with TOIseqPCL(dataPlot) do
  begin
    BinX:=dumBinX;
    invalidate;
  end;
end;

procedure TRegEditor.changeBinY;
begin
  if not FlagUpdate then
  with TOIseqPCL(dataPlot) do
  begin
    BinY:=dumBinY;
    invalidate;
  end;
end;

procedure TRegEditor.changeBinDT;
var
  oldT: float;
  ii: integer;
begin
  if not FlagUpdate then
  with TOIseqPCL(dataPlot) do
  begin
    if NoOverlap or (NframeU=0) then
    begin
      oldT:=index*BinDT;

      BinDt:=dumBinDt;
      initFrames0(false);

      ii:= floor(oldT/deltaT);
      if ii<0 then ii:=0
      else
      if ii>=frameCount then ii:=frameCount-1;
      index:=ii;
    end
    else
    begin
      BinDT:=dumBinDT;
      initFrames0(false);
    end;

    invalidate;
  end;
end;

procedure TRegEditor.ChangeFilter;
begin
  if not FlagUpdate then
  begin
    TOIseqPCL(dataPlot).UpdateFilter;
  end;
end;

procedure TRegEditor.setPCLcontrol;
var
  DxMax:single;
begin
  if assigned(dataPlot) and (dataPlot is TOIseqPCL) then
  with TOIseqPCL(dataPlot) do
  begin
    PanelPCL.Visible:=true;
    tabScales.tabVisible:= true;
    tabFilters.tabVisible:= true;

    DumBinX:=BinX;
    DumBinY:=BinY;
    DumBinDt:=BinDt;


    if NoOverlap
      then DumNframeU:=FrameCount
      else DumNframeU:=NframeU;
    DumNoOverlap:=NoOverlap;

    FlagUpdate:=true;
    EscBinX.init(DumbinX,g_longint,1,256,0);
    ESCBinX.onChange := ChangeBinX;

    EscBinY.init(DumbinY,g_longint,1,256,0);
    ESCBinY.onChange := ChangeBinY;

    EscBinT.init(DumBinDt,g_double,1,10000,0);
    EscBinT.sb.dxSmall:=10;
    EscBinT.sb.dxLarge:=100;
    ESCBinT.onChange := ChangeBinDt;

    enNframe.setVar(DumNframeU,t_longint);
    enNframe.setMinMax(0,10000);
    enNframe.OnChange:= ChangeNframeU;
    enNframe.readOnly:=NoOverlap;

    cbNoOverlap.setVar(DumNoOverlap);
    cbNoOverlap.UpdateVarOnToggle:=true;

    DxMax:= abs(NxBase*Dxu0);

    FilterVX.init(PhotonFilter.Vx,g_single,-DxMax,DxMax,3);
    FilterVX.sb.dxSmall:=DxMax/200;
    FilterVX.sb.dxLarge:=DxMax/20;
    FilterVX.onChange := ChangeFilter;

    FilterVy.init(PhotonFilter.Vy,g_single,-DxMax,DxMax,3);
    FilterVy.sb.dxSmall:=DxMax/200;
    FilterVy.sb.dxLarge:=DxMax/20;
    FilterVy.onChange := ChangeFilter;


    FilterX.init(PhotonFilter.RotX,g_single,-DxMax,DxMax,3);
    FilterX.sb.dxSmall:=DxMax/200;
    FilterX.sb.dxLarge:=DxMax/20;
    FilterX.onChange := ChangeFilter;

    FilterY.init(PhotonFilter.RotY,g_single,-DxMax,DxMax,3);
    FilterY.sb.dxSmall:=DxMax/200;
    FilterY.sb.dxLarge:=DxMax/20;
    FilterY.onChange := ChangeFilter;

    FilterTheta.init(PhotonFilter.RotTheta,g_single,-360,360,1);
    FilterTheta.sb.dxSmall:=0.1;
    FilterTheta.sb.dxLarge:=1;
    FilterTheta.onChange := ChangeFilter;

    FilterDX.init(PhotonFilter.dx,g_single,-DxMax,DxMax,3);
    FilterDX.sb.dxSmall:=DxMax/200;
    FilterDX.sb.dxLarge:=DxMax/20;
    FilterDX.onChange := ChangeFilter;

    FilterDY.init(PhotonFilter.dy,g_single,-DxMax,DxMax,3);
    FilterDY.sb.dxSmall:=DxMax/200;
    FilterDY.sb.dxLarge:=DxMax/20;
    FilterDY.onChange := ChangeFilter;

    cbFilterActive.setVar(PhotonFilter.active);

    DumOriginX:= -x0u/Dxu0;
    DumOriginY:= -y0u/Dyu0;
    DumXpix:= NxBase;
    DumYpix:= NyBase;
    DumDeltaX:= DumXpix*Dxu0;
    DumDeltaY:= DumYpix*Dyu0;
    DumUnitX:= UnitX;
    DumUnitY:= UnitY;

    EsOriginX.init(DumOriginX,g_single,-1000,1000,1);
    EsOriginX.sb.dxSmall:=1;
    EsOriginX.sb.dxLarge:=10;
    EsOriginX.onChange := ChangeScale;

    EsOriginY.init(DumOriginY,g_single,-1000,1000,1);
    EsOriginY.sb.dxSmall:=1;
    EsOriginY.sb.dxLarge:=10;
    EsOriginY.onChange := ChangeScale;

    enXaxisPix.setVar(DumXpix,g_longint);
    enXaxisPix.OnExit:= ChangeScale1;
    enXaxisDX.setvar(DumDeltaX,g_single);
    enXaxisDX.OnExit:= ChangeScale1;
    esXaxisUnits.setString(DumUnitX,10);
    esXaxisUnits.OnExit:= ChangeScale1;

    enYaxisPix.setVar(DumYpix,g_longint);
    enYaxisPix.OnExit:= ChangeScale1;
    enYaxisDY.setvar(DumDeltaY,g_single);
    enYaxisDY.OnExit:= ChangeScale1;
    esYaxisUnits.setString(DumUnitY,10);
    esYaxisUnits.OnExit:= ChangeScale1;


    FlagUpdate:=false;
  end
  else
  begin
    PanelPCL.Visible:=false;
    tabScales.tabVisible:= false;
    tabFilters.tabVisible:= false;
  end;
end;


procedure TRegEditor.ChangeScale;
begin
  if FlagUpdate then exit;

  updateAllVar(self);
  with TOIseqPCL(dataPlot) do
  begin
    Dxu0:= DumDeltaX/DumXpix;
    X0u:=  -DumOriginX*Dxu0;
    Dyu0:= DumDeltaY/DumYpix;
    Y0u:=  -DumOriginY*Dyu0;

    Dxu:= Dxu0*BinX;
    Dyu:= Dyu0*BinY;


    unitX:=DumUnitX;
    unitY:=DumUnitY;

    invalidate;
  end;
end;

procedure TRegEditor.ChangeScale1(sender: Tobject);
begin
  ChangeScale;
end;



procedure TRegEditor.Options1Click(Sender: TObject);
begin
  RegOptions.execute(owner0);
  SetCoupledXY;
end;

procedure TRegEditor.SetCoupledXY;
begin
  if owner0.CoupledBinXY then
  begin
    EscBinY.Visible:=false;
    EscBinX.Lb.Caption:='BinXY';
    PanelPCL.Height:=HpanelPCL-EscBinY.Height;
    LNframe.Top:=TopLNframe-EscBinY.Height;
    enNframe.Top:=TopEnNframe-EscBinY.Height;
    cbNoOverlap.Top:=TopNoOverlap-EscBinY.Height;
  end
  else
  begin
    EscBinY.Visible:=true;
    EscBinX.Lb.Caption:='BinXY';
    PanelPCL.Height:=HpanelPCL;
    LNframe.Top:=TopLNframe;
    enNframe.Top:=TopEnNframe;
    cbNoOverlap.Top:=TopNoOverlap;
  end
end;

procedure TRegEditor.EscBinTExit(Sender: TObject);
begin
  ;
end;

procedure TRegEditor.enNframeExit(Sender: TObject);
begin
  if not FlagUpdate then
  with TOIseqPCL(dataPlot) do
  begin
    enNframe.UpdateVar;
    initFrames0(false);
  end;
end;

procedure TRegEditor.ChangeNframeU(sender: Tobject);
begin
  with TOIseqPCL(dataPlot) do
  begin
    if not NoOverlap then
    begin
      enNFrame.UpdateVar;
      NframeU:=DumNframeU;
    end;
  end;

  ChangeBinDt;
end;

procedure TRegEditor.cbNoOverlapClick(Sender: TObject);
begin
  cbNoOverlap.UpdateVar;
  with TOIseqPCL(dataPlot) do
  begin
    NoOverlap:=DumNoOverlap;
    enNFrame.ReadOnly:=NoOverlap;
    if NoOverlap then
    begin
      DumNframeU:=FrameCount;
      Update;
    end
    else
    begin
      enNFrame.UpdateVar;
      NframeU:=DumNframeU;
    end;
  end;
  ChangeBinDt;
end;

procedure TRegEditor.drawLine;
begin
  with paintbox0.canvas do
  begin
    pen.style:=psSolid;
    pen.mode:=pmXor;
    pen.color:=clwhite;
    with theLine do
    begin
      moveto(left,top);
      lineto(right,bottom);
    end;
    pen.mode:=pmCopy;
  end;
  Fline:=false;
end;

procedure TRegEditor.setLine(x1, y1, x2, y2: float);
begin
  TheLine:=rect(roundL(x1),roundL(y1),roundL(x2),roundL(y2));
  Fline:=true;
  Invalidate;
end;


procedure TRegEditor.cbFilterActiveClick(Sender: TObject);
begin
  cbFilterActive.UpdateVar;
  if not FlagUpdate then changeFilter;
end;

procedure TRegEditor.BsaveFilterClick(Sender: TObject);
var
  db: TDBrecord;
begin
  if MessageDlg('Save filter parameters to data file ?', mtConfirmation,
    [mbOk, mbCancel], 0) = mrCancel then exit;

  db:= TDBrecord.create;
  db.ident:='_PCLfilter';
  try
  TOIseqPCL(dataPlot).PCLfilterToDB(db);
  dataFile0.AppendObject(db);
  finally
  db.Free;
  end;
end;

Initialization
AffDebug('Initialization RegEditor1',0);
{$IFDEF FPC}
{$I RegEditor1.lrs}
{$ENDIF}
end.
