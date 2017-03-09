unit stmRaster1;


interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, classes,menus,sysutils, Graphics,
     util1,Dgraphic,Dtrace1,varconf1,visu0,
     stmDef,stmObj,stmPg,stmDplot,stmPopup,coodRaster, debug0;

type
  TrasterPlot=class(TdataPlot)
          private
            oldTailleT,oldModeT:integer;
            UOlist:Tlist;
          public
            Ftitle:boolean;
            Hline:integer;
            Wtitle:integer;


            constructor create;override;
            destructor destroy;override;

            class function STMClassName:AnsiString;override;

            function ChooseCoo1:boolean;override;

            procedure display0;
            procedure display; override;

            function getPopUp:TpopUpMenu;override;

            procedure getWorldPriorities(var Fworld,FlogX,FlogY:boolean; var x1,y1,x2,y2:float);override;

            procedure SetCurrentWorld(num2:integer;x1w,y1w,x2w,y2w:float); override;
            function SetCurrentWindow(num2:integer; rectI:Trect):boolean; override;

            function getInsideWindow:Trect;override;
            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;

            procedure ModifyPlot(num2:integer;plot:typeUO);override;
            procedure RestorePlot(num2:integer;plot:typeUO);override;

            procedure DisplayEmpty;override;

            function MouseDownMG(numOrdre:integer;Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean; override;

            function MouseMoveMG(x,y:integer):boolean;override;
            procedure MouseUpMG(x,y:integer; mg:typeUO);override;

          end;

procedure proTrasterPlot_create(var pu:typeUO);pascal;

Procedure proTrasterPlot_LineHeight(w:integer;var pu:typeUO);pascal;
function fonctionTrasterPlot_LineHeight(var pu:typeUO):integer;pascal;

Procedure proTrasterPlot_TitleWidth(w:integer;var pu:typeUO);pascal;
function fonctionTrasterPlot_TitleWidth(var pu:typeUO):integer;pascal;

Procedure proTrasterPlot_FTitle(w:boolean;var pu:typeUO);pascal;
function fonctionTrasterPlot_FTitle(var pu:typeUO):boolean;pascal;


implementation

constructor TrasterPlot.create;
begin
  inherited;

  visu.echY:=false;
  visu.FtickY:=false;

  Hline:=15;
  tailleT:=12;
  Ftitle:=true;
  Wtitle:=120;
  UOlist:=Tlist.Create;
end;

destructor TrasterPlot.destroy;
begin
  UOlist.Free;
  inherited;
end;

class function TrasterPlot.STMClassName:AnsiString;
begin
  result:='RasterPlot';
end;


function TrasterPlot.ChooseCoo1:boolean;
var
  chg:boolean;
  title0:AnsiString;
  Hline0,Wtitle0:integer;
  Ftitle0:boolean;
begin
  InitVisu0;

  title0:=title;
  Hline0:=Hline;
  Wtitle0:=Wtitle;
  Ftitle0:=Ftitle;

  if getRasterCoo.choose(self) then
    begin
      chg:= not visu.compare(visu0^) or (title<>title0) or (Hline0<>Hline) or (Wtitle0<>Wtitle) or (Ftitle0<>Ftitle);
      visu.assign(visu0^);
      title:=title0;
    end
  else chg:=false;

  DoneVisu0;

  chooseCoo1:=chg;
end;




function TrasterPlot.getPopUp:TpopUpMenu;
begin
  with PopUps do
  begin
    PopupItem(pop_Tcoo,'Tcoo_Coordinates').onClick:=ChooseCoo;

    result:=pop_Tcoo;
  end;
end;


procedure TrasterPlot.getWorldPriorities(var Fworld,FlogX,FlogY:boolean;
                            var x1,y1,x2,y2:float);
begin
  Fworld:=true;
  FlogX:=visu.modelogX;
  FlogY:=visu.modelogY;

  if visu.inverseX then
    begin
      x1:=visu.Xmax;
      x2:=visu.Xmin;
    end
  else
    begin
      x1:=visu.Xmin;
      x2:=visu.Xmax;
    end;

  if visu.inverseY then
    begin
      y1:=visu.Ymax;
      y2:=visu.Ymin;
    end
  else
    begin
      y1:=visu.Ymin;
      y2:=visu.Ymax;
    end;

end;


function TrasterPlot.SetCurrentWindow(num2: integer; rectI: Trect):boolean;
var
  y1,y2:integer;
  dd:integer;
begin
  dd:=(Hline-tailleT) div 2;

  y1:=rectI.top+(num2-1)*Hline +dd;
  y2:=rectI.top+ num2*Hline +dd;

  result:=(y2<=rectI.Bottom);

  if result then
    with rectI do setWindow(left,y1,right,y2);
end;

procedure TrasterPlot.SetCurrentWorld(num2: integer; x1w, y1w, x2w, y2w: float);
begin
  Dgraphic.setWorld(x1w,-1,x2w,0);

end;

procedure TrasterPlot.display0;
var
  oldGrille:boolean;
  y:integer;
begin
  visu.echY:=false;
  visu.FtickY:=false;

  with getInsideWindow do setWindow(left,top,right,bottom);
  drawBorderOut(visu.ScaleColor);

  oldGrille:=visu.Grille;
  visu.grille:=false;
  visu.displayScale;
  visu.grille:=oldGrille;

  if visu.grille then
  begin
    canvasGlb.Pen.Color:=clGray;
    y:=y1act;
    repeat
      canvasGlb.MoveTo(x1act,y);
      canvasGlb.LineTo(x2act,y);
      inc(y,Hline);
    until y>=y2act;
  end;
end;

procedure TrasterPlot.display;
begin
  Display0;
  UOlist.Clear;
end;

procedure TrasterPlot.DisplayEmpty;
var
  i:integer;
begin
  canvasGlb.brush.Style:=bsClear;
  canvasGlb.Font.Color:=scaleColor;


  for i:=0 to UOlist.Count-1 do
    if syslist.IndexOf(UOlist[i])>=0
      then canvasGlb.textOut(x1act+3,y1act+DispVec_Top + i*Hline + (Hline-tailleT) div 2,typeUO(UOlist[i]).title)
      else canvasGlb.textOut(x1act+3,y1act+DispVec_Top + i*Hline + (Hline-tailleT) div 2,'PAS VU '+Istr(i));

  display0;
end;



function TrasterPlot.getInsideWindow: Trect;
begin
  result:=visu.getInsideT;
  result.Left:=x1act+Wtitle*ord(Ftitle) +3;
end;

procedure TrasterPlot.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;

  with conf do
  begin
    setvarconf('Hline',Hline,sizeof(Hline));
    setvarconf('Wtitles',Wtitle,sizeof(Wtitle));
    setvarconf('Ftitle',Ftitle,sizeof(Ftitle));
  end;

end;

procedure TrasterPlot.ModifyPlot(num2:integer;plot: typeUO);
var
  st:AnsiString;
begin
  if (plot is TdataPlot) then
  begin
    oldTailleT:=TdataPlot(plot).tailleT;
    oldModeT:=TdataPlot(plot).modeT;

    TdataPlot(plot).tailleT:=tailleT;
    TdataPlot(plot).modeT:=dm_evt1;


    if Ftitle and (y2act>y1act+2) then
    begin
      st:=TdataPlot(plot).title;
      if num2=1 then UOlist.Clear;
      UOlist.Add(plot);

      canvasGlb.brush.Style:=bsClear;
      canvasGlb.Font.Color:=TdataPlot(plot).scaleColor;

      setClippingOff;
      canvasGlb.textOut(x1act-Wtitle,y1act,st);
      setClippingOn;
    end;
  end
  else
  begin
    oldTailleT:=-1;
    oldModeT:=-1;
  end;
end;

procedure TrasterPlot.RestorePlot(num2:integer;plot: typeUO);
begin
  if plot is TdataPlot then
  begin
    if oldTailleT>0 then TdataPlot(plot).tailleT:=OldTailleT;
    if oldmodeT>0 then TdataPlot(plot).modeT:=OldModeT;
  end;
end;


function TrasterPlot.MouseDownMG(numOrdre: integer; Irect: Trect;
  Shift: TShiftState; Xc, Yc, X, Y: Integer): boolean;
begin

end;

function TrasterPlot.MouseMoveMG(x, y: integer): boolean;
begin

end;

procedure TrasterPlot.MouseUpMG(x, y: integer; mg:typeUO);
begin
  inherited;

end;








{*****************************  Méthodes STM **********************************}


procedure proTrasterPlot_create(var pu:typeUO);
begin
  createPgObject('',pu,TrasterPlot);
end;


Procedure proTrasterPlot_LineHeight(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TrasterPlot(pu).Hline:=w;
end;

function fonctionTrasterPlot_LineHeight(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TrasterPlot(pu).Hline;
end;


Procedure proTrasterPlot_TitleWidth(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TrasterPlot(pu).Wtitle:=w;
end;

function fonctionTrasterPlot_TitleWidth(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:= TrasterPlot(pu).Wtitle;
end;


Procedure proTrasterPlot_FTitle(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TrasterPlot(pu).Ftitle:=w;
end;

function fonctionTrasterPlot_FTitle(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:= TrasterPlot(pu).Ftitle;
end;




Initialization
AffDebug('Initialization stmRaster1',0);

registerObject(TrasterPlot,data);

end.
