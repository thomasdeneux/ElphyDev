unit BMplotForm1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,Menus,
  Buttons, EditScroll1, editcont,
  util1,Dgraphic,DdosFich,DibG,Dpalette,BMex1,visu0,
  stmObj,stmMat1,Regions1,stmRegion1,stmBMplot1,stmOIseq1;

type
  TBMplotForm = class(TForm)
    PaintBox0: TPaintBox;
    PanelRight: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelMouse: TPanel;
    Panel4: TPanel;
    Bcadrer: TBitBtn;
    PanelX: TPanel;
    LG0: TLabel;
    SBG0: TscrollbarV;
    Panel5: TPanel;
    BG0: TBitBtn;
    BautoZ: TBitBtn;
    Panel6: TPanel;
    Brectangle: TSpeedButton;
    Bcircle: TSpeedButton;
    Bpolygon: TSpeedButton;
    Bselect: TSpeedButton;
    PopupRegion: TPopupMenu;
    Region1: TMenuItem;
    Delete1: TMenuItem;
    Edit1: TMenuItem;
    GBdisplay: TGroupBox;
    cbDisplayRegions: TCheckBoxV;
    cbDisplayPixels: TCheckBoxV;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Load1: TMenuItem;
    Save1: TMenuItem;
    Clear1: TMenuItem;
    GroupBox1: TGroupBox;
    Lindex: TLabel;
    sbindex: TscrollbarV;
    scrollbarV: TscrollbarV;
    scrollbarH: TscrollbarV;
    PregionColor: TPanel;
    BregionColor: TButton;
    ColorDialog1: TColorDialog;
    ESCzmin: TEditScroll;
    ESCZmax: TEditScroll;
    Coordinates1: TMenuItem;
    cbFillMode: TCheckBoxV;
    Showlist1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PaintBox0Paint(Sender: TObject);
    procedure BcadrerClick(Sender: TObject);
    procedure SBG0ScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure BG0Click(Sender: TObject);
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
    procedure cbFillModeClick(Sender: TObject);
    procedure Showlist1Click(Sender: TObject);
  private
    { Déclarations privées }

    BMfen:TbitmapEx;
    Fvalid:boolean;

    xs1,ys1,xs2,ys2:float;         { rectangle source dans l'image : coo fichier }
    xr1,yr1,xr2,yr2:float;         { rectangle source dans l'image : coo réelles }

    pop:TpopUpMenu;
    Fcap:boolean;
    Fpoly:boolean;


    FdisplayRegions,FshowPix:boolean;
    regionList:TregionList;

    reg:Treg;
    FclosePoly:boolean;

    stFile:string;

    inverseX,inverseY:boolean;
    rectI:Trect;

    Zmini,Zmaxi:float;

    Fzmin:float;
    Fzmax:float;

    FlagUpdate:boolean;

    NumSelMove:integer;
    Xmove,Ymove:integer;

    curColor:integer;
    
    procedure resizeBM;
    procedure BMpaint;
    procedure DrawBM;

    procedure setG0Ctrl;
    procedure setLumContCtrl;
    procedure setIndexCtrl;

    procedure DisplayRegions;
    function ToolSelected:integer;
    procedure initBMfenGraphic;
    procedure initPaintbox0Graphic;

    procedure changeZmin;
    procedure changeZmax;

  public
    { Déclarations publiques }
    oiseq0:TBitmapPlot;
    procedure invalidate;override;
    procedure installOIseq(oi:TbitmapPlot);
    procedure ProcessMessage(id:integer;source:typeUO;p:pointer);
  end;


implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

{ TDesignForm }


procedure TBMplotForm.resizeBM;
begin
  if (BMfen.width<>paintbox0.width) or (BMfen.height<>paintbox0.height) then
  begin
    BMfen.width:=paintbox0.width;
    BMfen.height:=paintbox0.height;

    Fvalid:=false;
  end;
end;

procedure TBMplotForm.initBMfenGraphic;
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

procedure TBMplotForm.initPaintbox0Graphic;
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


procedure TBMplotForm.BMpaint;
var
  Fworld,FlogX,FlogY:boolean;
begin
  BMfen.fill(0);

  if assigned(oiseq0) then
  begin
    initGraphic(BMfen);
    with oiseq0 do
    begin
      rectI:=getInsideWindow;
      display;
      getWorldPriorities(Fworld,FlogX,FlogY,xs1,ys1,xs2,ys2);
    end;
    doneGraphic;
  end
  else
  with BMfen do rectI:=rect(0,0,width-1,height-1);

  with rectI do setWindow(left,top,right,bottom);
  if FdisplayRegions or FshowPix
    then displayRegions;
end;



procedure TBMplotForm.DrawBM;
begin
  paintbox0.canvas.draw(0,0,BMfen);
end;



procedure TBMplotForm.PaintBox0Paint(Sender: TObject);
begin
  resizeBM;

  BMfen.restoreRects;
  if not Fvalid then BMpaint;
  { Ajouter ici les dessins extra BMfen }
  DrawBM;

  if assigned(reg) then
  begin
    initPaintBox0graphic;
    canvasGlb.Brush.Style:=bsClear;

    reg.draw;
    doneGraphic;
  end;

  Fvalid:=true;
end;


procedure TBMplotForm.installOIseq(oi: TbitmapPlot);
var
  nbI,nbJ:integer;
begin
  flagUpdate:=true;
  oiseq0:=oi;
  if assigned(oiseq0) then
  begin
    inverseX:=oiseq0.inverseX;
    inverseY:=oiseq0.inverseY;
    regionList:=oiseq0.regionList;

  end;

  if (oi.Icount>0) and (oi.Jcount>0) then
  begin
    nbI:=oi.Icount;
    nbJ:=oi.Jcount;
  end
  else
  begin
    nbI:=10;
    nbJ:=10;
  end;


  scrollbarV.SetParams(oiseq0.yDisp,-nbJ/2,nbJ/2);
  scrollbarV.LargeChange:=10;

  scrollbarH.SetParams(oiseq0.xDisp,-nbI/2,nbI/2);
  scrollbarH.LargeChange:=10;

  setG0Ctrl;
  setLumContCtrl;

  cbDisplayRegions.setVar(FdisplayRegions);
  cbDisplayPixels.setVar(FshowPix);
  cbFillMode.setVar(oiseq0.regionList.Ffill);

  setIndexCtrl;

  PregionColor.Color:=curColor;
  flagUpdate:=false;
end;



procedure TBMplotForm.FormCreate(Sender: TObject);
begin
  BMfen:=TbitmapEx.create;
  FdisplayRegions:=true;

  xs2:=1;
  ys2:=1;
  NumSelMove:=-1;

  inverseX:=false;
  inverseY:=true;
end;

procedure TBMplotForm.FormDestroy(Sender: TObject);
begin
  BMfen.free;
end;

procedure TBMplotForm.invalidate;
var
  rr:Trect;
begin
  if assigned(oiseq0) then installoiseq(oiseq0);

  Fvalid:=false;
  if not assigned(paintbox0) then exit;
  with paintbox0 do rr:=rect(left,top,left+Width-1,top+height-1);
  invalidateRect(handle,@rr,false);
  {
  panelRight.Invalidate;
  panelMouse.Invalidate;
  }
end;

procedure TBMplotForm.BcadrerClick(Sender: TObject);
begin
  installOIseq(oiseq0);
  oiseq0.invalidate;
end;


procedure TBMplotForm.SBG0ScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  oiseq0.GDisp:=x;
  setG0ctrl;
  oiseq0.invalidate;
end;

procedure TBMplotForm.BG0Click(Sender: TObject);
begin
  oiseq0.GDisp:=1;
  setG0ctrl;
  oiseq0.invalidate;
end;

procedure TBMplotForm.BautoZClick(Sender: TObject);
begin
  if assigned(oiseq0) then
  begin
    if oiseq0 is TOIseq then
    TOIseq(oiseq0).AutoScaleZ(false);
    setLumContCtrl;

  end;
  oiseq0.invalidate;

end;

procedure TBMplotForm.setG0Ctrl;
begin
  SBG0.setParams(oiseq0.GDisp,0.1,100);
  LG0.Caption:='G0='+Estr(oiseq0.GDisp,3);
end;


procedure TBMplotForm.setLumContCtrl;
begin
  if assigned(oiseq0) then
  with oiseq0 do
  begin
    FZmin:=Zmin;
    FZmax:=Zmax;

    ESCzmin.init(Fzmin,g_extended,-10000,10000,3);
    ESCzmin.onChange := ChangeZmin;

    ESCzmax.init(Fzmax,g_extended,-10000,10000,3);
    ESCzmax.onChange := ChangeZmax;
  end;
end;

procedure TBMplotForm.setIndexCtrl;
begin
  if assigned(oiseq0) and (oiseq0 is TOiSeq) then
  with TOIseq(oiseq0) do
  begin
    SBindex.setParams(index ,0,FrameCount-1);
    Lindex.Caption:='Frame='+Estr(index,3);
  end;
end;


procedure TBMplotForm.DisplayRegions;
begin
  if FdisplayRegions then
  begin
    initBMfenGraphic;
    regionList.draw(FshowPix);
    doneGraphic;
  end;
end;

procedure TBMplotForm.BrectangleClick(Sender: TObject);
begin
  ;
end;

procedure TBMplotForm.PaintBox0MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  tool,num:integer;
  p:Tpoint;
begin
  tool:=toolSelected;

  if (tool=4) then
    case button of
      mbLeft: begin
                initBMfenGraphic;

                Xmove:=round(invconvWx(x));
                Ymove:=round(invconvWy(y));

                NumSelMove:=regionList.reg.ptInRegion(invconvWx(x),invconvWy(y));
                regionList.reg.NumSel:=NumSelMove;

                oiseq0.invalidate;
                doneGraphic;
                exit;
              end;
      mbRight:begin
                p:=paintbox0.clientToScreen(point(x,y));
                initBMfenGraphic;

                Num:=regionList.reg.ptInRegion(invconvWx(x),invconvWy(y));
                if num=regionList.reg.NumSel then
                begin
                  region1.caption:='Region '+Istr(regionList.reg.NumSel); ;
                  popupRegion.Popup(p.x,p.y);
                end;

                doneGraphic;
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
    oiseq0.invalidate;
    exit;
  end;

  if FclosePoly then
  begin
    FclosePoly:=false;
    exit;
  end;

  initBMfenGraphic;
  x:=round(invconvWx(x));
  y:=round(invconvWy(y));

  case tool of
    1: begin
         reg:=TrectReg.create(x,y);
         Fcap:=true;
       end;
    2: begin
         reg:=TellipseReg.create(x,y);
         Fcap:=true;
       end;
    3: begin
         if not Fpoly then reg:=TpolygonReg.create(x,y);
         Fcap:=true;
         Fpoly:=true;
       end;
  end;

  if assigned(reg) then reg.color:=curColor;
  doneGraphic;
end;

procedure TBMplotForm.PaintBox0MouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  x1,y1:integer;
  i1,j1:integer;
  z1:float;
begin
  initBMfenGraphic;
  x1:=round(invconvWx(x));
  y1:=round(invconvWy(y));

  i1:=round(invconvWx(x)-0.5);
  j1:=round(invconvWy(y)-0.5);

  if assigned(oiseq0) and (oiseq0 is TOiSeq) then
  with TOIseq(oiseq0) do
  begin
    if (i1>=0) and (i1<Icount) and (j1>=0) and (j1<Jcount)
      then z1:=mat[index].Zvalue[i1,j1]
      else z1:=0;
    PanelMouse.caption:=Estr(i1,0)+'/'+Estr(j1,0)+' : '+Estr(z1,3) ;
  end
  else
  PanelMouse.caption:=Estr(i1,0)+'/'+Estr(j1,0);


  if toolSelected=4 then
  begin
    if NumSelMove>=0 then
    begin
      regionList.reg.region[NumSelMove].move(x1-Xmove,y1-Ymove);
      Xmove:=x1;
      Ymove:=y1;
      invalidate;
    end;
  end
  else
  if Fcap then
  begin
    reg.MovePt(x1,y1,false);
    invalidateRect(handle,nil,false);
  end;
  doneGraphic;
end;

procedure TBMplotForm.PaintBox0MouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  initBMfenGraphic;
  x:=round(invconvWx(x));
  y:=round(invconvWy(y));

  NumSelMove:=-1;

  if Fcap then
  begin
    reg.MovePt(x,y,true);
    if Fpoly then
    begin
      reg.AddPoint(x,y);
    end
    else
    begin
      regionList.reg.Add(reg);
      reg:=nil;
      Fcap:=false;
      regionList.invalidate;
    end;
  end;
  doneGraphic;
  invalidate;
end;

function TBMplotForm.ToolSelected: integer;
begin
  if Brectangle.down then result:=1
  else
  if Bcircle.down then result:=2
  else
  if Bpolygon.down then result:=3
  else
  if Bselect.down then result:=4
  else result:=0;
end;

procedure TBMplotForm.PaintBox0DblClick(Sender: TObject);
begin
  if Fpoly then
  begin
    initBMfenGraphic;
    reg.close;

    regionList.reg.Add(reg);
    reg:=nil;
    Fcap:=false;
    Fpoly:=false;
    regionList.invalidate;
    doneGraphic;

    FclosePoly:=true;
  end;
end;

procedure TBMplotForm.Delete1Click(Sender: TObject);
begin
  with regionList.reg do
  begin
    delete(numsel);
    numsel:=-1;
  end;
  regionList.invalidate;
end;

procedure TBMplotForm.Edit1Click(Sender: TObject);
begin
   ;
end;

procedure TBMplotForm.cbDisplayRegionsClick(Sender: TObject);
begin
  cbDisplayRegions.UpdateVar;
  if not FlagUpdate then oiseq0.invalidate;
end;

procedure TBMplotForm.cbDisplayPixelsClick(Sender: TObject);
begin
  cbDisplayPixels.UpdateVar;
  if not FlagUpdate then oiseq0.invalidate;
end;

procedure TBMplotForm.Load1Click(Sender: TObject);
var
  st:string;
begin
  if stFile='' then stFile:='*.rgn';
  st:=GchooseFile('Choose a region file',stFile);
  if st<>'' then
  begin
    if not regionList.reg.loadFromFile(st)
      then messageCentral('Unable to load '+ExtractFileName(st));
    stFile:=st;
    regionList.invalidate;
  end;
end;

procedure TBMplotForm.Save1Click(Sender: TObject);
var
  st:string;
begin
  st:=GsaveFile('Choose a region file',stFile,'rgn');
  if st<>'' then
  begin
    if not regionList.reg.saveToFile(st)
      then messageCentral('Unable to save '+ExtractFileName(stFile));
    stFile:=st;
  end;
end;


procedure TBMplotForm.Clear1Click(Sender: TObject);
begin
  if messageDlg('Clear region list ?',mtConfirmation,[mbOK,mbCancel],0)= mrOK then
  begin
    regionList.reg.clear;
    regionList.invalidate;
  end;
end;

procedure TBMplotForm.ProcessMessage(id: integer; source: typeUO; p: pointer);
begin
  if source=oiseq0 then
  case id of
    uomsg_destroy:        installoiseq(nil);
    uomsg_invalidate,
    uomsg_invalidateData: installoiseq(oiseq0);
  end;
end;

procedure TBMplotForm.sbindexScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  if assigned(oiseq0) and (oiseq0 is TOiSeq) then
  with Toiseq(oiseq0) do
  begin
    index:=round(x);
    invalidate;
  end;
  setIndexCtrl;
end;

procedure TBMplotForm.scrollbarHScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  oiseq0.xDisp:=x;
  oiseq0.invalidate;

end;

procedure TBMplotForm.scrollbarVScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  oiseq0.yDisp:=x;
  oiseq0.invalidate;
end;

procedure TBMplotForm.BregionColorClick(Sender: TObject);
begin
  with colorDialog1 do
  begin
    color:=curColor;
    if execute then
    begin
      CurColor:=color;
      PRegionColor.color:=curColor;
      PRegionColor.invalidate;
      self.invalidate;
      RegionList.invalidate;
    end;
  end;
end;

procedure TBMplotForm.changeZmax;
begin
  if not FlagUpdate then
  if assigned(oiseq0) then
  begin
    oiseq0.Zmax:=FZmax;
    oiseq0.invalidate;
  end;

end;

procedure TBMplotForm.changeZmin;
begin
  if not FlagUpdate then
  if assigned(oiseq0) then
  begin
    oiseq0.Zmin:=FZmin;
    oiseq0.invalidate;
  end;
end;

procedure TBMplotForm.Coordinates1Click(Sender: TObject);
begin
  oiseq0.chooseCoo(sender);
end;

procedure TBMplotForm.cbFillModeClick(Sender: TObject);
begin
  cbFillMode.UpdateVar;
  if not flagUpdate then oiseq0.invalidate;
end;

procedure TBMplotForm.Showlist1Click(Sender: TObject);
begin
  regionList.EditRegionList;
end;

end.
