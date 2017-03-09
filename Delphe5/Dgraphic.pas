
Unit Dgraphic;       { Unité Graphic pour Delphi }

Interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  Windows,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  util1,BMex1;

var
  canvasGlb:Tcanvas;
  x1act,y1act,x2act,y2act:integer;
  topGlb,leftGlb,WidthGlb,HeightGlb:integer;

  BMexGlb:TbitmapEx;

const
  PRprinting:boolean=false;
  PRmetafile:boolean=false;

  PRmonochrome:boolean=false;
  PRwhiteBackGnd:boolean=true;
  PRlandscape:boolean=false;
  PRdraft:boolean=false;
  PRprintName:boolean=false;

  PRPwidth:single=0;
  PRPheight:single=0;

  PRfontMag:single=1;
  PRautoFont:boolean=true;

  PRkeepAspectRatio:boolean=true;
  PRfactor:single=0;

  PRSymbMag:single=1;
  PRAutoSymb:boolean=true;

  PrintComment:string[160]='';

  AbortDisplay:boolean=false;

  PRfileName:Ansistring='';

  PRsplitMatrix:boolean=false;

procedure initGraphic(c:Tcanvas;left,top,width,height:integer);overload;
procedure initGraphic(bm:TbitmapEx);overload;

procedure doneGraphic;

procedure setWindow(x1,y1,x2,y2:integer;const UpdateWorld: boolean=false);
procedure mainWindow;

procedure clearWindow(col:Tcolor);


procedure setWorld(x1,y1,x2,y2:float);
procedure getWorld(var x1,y1,x2,y2:float);
procedure SetPropWorld(x1,y1,x2:float);

function convWx(x:float):integer;
function convWy(y:float):integer;

function convWxInvert(x:float):integer;
function convWyInvert(y:float):integer;


function invconvWx(i:integer):float;
function invconvWy(j:integer):float;


function convWIx(x:longint):integer;
function convWIy(y:longint):integer;



procedure DrawBorder(col:Tcolor);
procedure DrawBorderOut(col:Tcolor);

procedure lineVer(x:float;col:Tcolor;modeXor:boolean);
procedure lineHor(y:float;col:Tcolor;modeXor:boolean);
procedure droite(a,b:float;col:Tcolor;modeXor:boolean);
procedure LineToSegment(a,b,xw1,yw1,xw2,yw2:float;var x1,y1,x2,y2:float);


procedure SetClippingON;
procedure SetClippingOFF;
procedure SetClipRegion(x1,y1,x2,y2:integer);
procedure ResetClipRegion;

procedure PushCol;
procedure PopCol;

procedure textOutG(x,y:integer;st:AnsiString);
procedure getWindowG(var x1,y1,x2,y2:integer);

procedure SwapColorsGlb;
function RectToString(r:Trect):AnsiString;

{$MINENUMSIZE 1}
{$A-}



procedure affPave(i1,j1,i2,j2:integer;col:longint);
procedure UpDateAff;

function getNormalPosition(wnd:hwnd):Trect;

procedure PushG;
procedure PopG;

function roundG(x:float):integer;

IMPLEMENTATION

uses debug0;



const
  clip:boolean=false;      { ne sert que pour drawBorderOut pour remettre
                             le clip après le tracé}
  manualClip:boolean=false;{ Affecté par setClipRegion et resetClipRegion }

var
  xW1,yW1,xW2,yW2:double;
  aWx,aWy:double;
  bWx,bWy:integer;


Const

  AfastX:longint=1;
  BfastX:longint=0;
  X1fastX:longint=0;
  PfastX:integer=0;
  AfastY:longint=1;
  BfastY:longint=0;
  Y1fastY:longint=0;
  PfastY:integer=0;




function BadCanvas:boolean;
begin
  result:= (canvasGlb=nil);
  {if result then
    messageCentral('Dgraphic: canvas=nil'); }
end;


procedure initGraphic(c:Tcanvas;left,top,width,height:integer);
begin
  pushG;
  affDebug('InitGraphic '+LongToHexa(intG(c)),19);
  {if canvasGlb<>nil
    then messageCentral('initGraphic canvasGlb<>nil');}

  canvasGlb:=c;
  if BadCanvas then exit;

  topGlb:=top;
  leftGlb:=left;
  WidthGlb:=width;
  HeightGlb:=height;

  resetClipRegion;
  setWindow(0,0,WidthGlb,HeightGlb);

  affdebug('initGraphic '+Istr(intG(c)),3);
end;

procedure initGraphic(bm:TbitmapEx);
begin
  pushG;
  affDebug('InitGraphic BM ',19);
  bmexGlb:=bm;

  {if canvasGlb<>nil
    then messageCentral('initGraphic BM canvasGlb<>nil');}

  with bm do
  begin
    canvasGlb:=canvas;

    if BadCanvas then exit;
    topGlb:=0;
    leftGlb:=0;
    WidthGlb:=width;
    HeightGlb:=height;
    resetClipRegion;
    setWindow(0,0,WidthGlb,HeightGlb);
  end;

end;

procedure doneGraphic;
begin
  popG;

  affDebug('doneGraphic ',19);
  setClippingOff;
  {
  bmExGlb:=nil;
  canvasGlb:=nil;
  }
end;

procedure setWindow(x1,y1,x2,y2:integer; const UpdateWorld: boolean=false);
begin
  if x2<=x1 then x2:=x1+1;
  if y2<=y1 then y2:=y1+1;
  x1act:=x1;
  y1act:=y1;
  x2act:=x2;
  y2act:=y2;

  setClippingON;
  if UpdateWorld then setWorld(xw1,yw1,xw2,yw2);
end;

procedure getWindowG(var x1,y1,x2,y2:integer);
  begin
    x1:=x1act;
    y1:=y1act;
    x2:=x2act;
    y2:=y2act;
  end;


procedure mainWindow;
  begin
    setWindow(0,0,WidthGlb,HeightGlb);
  end;


var
  Pcol,Bcol:Tcolor;
  Psty:TpenStyle;
  Bsty:TbrushStyle;
  Pwid:integer;

procedure PushCol;
  begin
    if BadCanvas then exit;
    PCol:=canvasGlb.pen.color;
    Psty:=canvasGlb.pen.style;
    pwid:=canvasGlb.pen.width;

    BCol:=canvasGlb.brush.color;
    Bsty:=canvasGlb.brush.style;
  end;

procedure PopCol;
  begin
    if BadCanvas then exit;
    canvasGlb.pen.color:=Pcol;
    canvasGlb.pen.style:=Psty;
    canvasGlb.pen.width:=Pwid;

    canvasGlb.brush.color:=Bcol;
    canvasGlb.brush.style:=Bsty;
  end;


procedure textOutG(x,y:integer;st:AnsiString);
  begin
    if BadCanvas then exit;
    canvasGlb.textOut(x1act+x,y1act+y,st);
  end;

procedure DrawBorder(col:Tcolor);
  begin
    if BadCanvas then exit;
    with canvasGlb do
    begin
      pushCol;
      pen.color:=col;
      brush.style:=bsclear;
      rectangle(x1act,y1act,x2act+1,y2act+1);
      popCol;
    end;
  end;

procedure DrawBorderOut(col:Tcolor);
  var
   clp:boolean;
  begin
    clp:=clip;
    if BadCanvas then exit;
    with canvasGlb do
    begin
      pushCol;
      pen.color:=col;
      brush.style:=bsclear;
      setClippingOff;
      rectangle(x1act-1,y1act-1,x2act+2,y2act+2);
      if clp then setClippingON;
      popCol;
    end;
  end;


procedure clearWindow(col:Tcolor);
  begin
    if BadCanvas or PRprinting then exit;

    with canvasGlb do
    begin
      pushCol;
      pen.color:=col;
      pen.style:=psSolid;
      brush.color:=col;
      brush.Style:=bsSolid;

      rectangle(x1act,y1act,x2act+1,y2act+1);
      popCol;
    end;
  end;


procedure setWorld(x1,y1,x2,y2:float);
  var
    a:real;
  begin
    if (x1=x2) or (y1=y2) then exit;

    xW1:=x1;
    xW2:=x2;
    yW1:=y1;
    yW2:=y2;

    aWx:=(x2act-x1act)/(xW2-xW1);
    aWy:=(y1act-y2act)/(yW2-yW1);

    bWy:=y2act-y1act;

    a:=(x2act-x1act)/(xW2-xW1);
    BfastX:=roundL(-a*(xW1-roundL(xW1)));
    X1fastX:=roundL(xW1);
    PfastX:=0;
    while (abs(a)<10000) and (PfastX<16) do
    begin
      a:=a*2;
      inc(PfastX);
    end;
    AfastX:=roundL(a);

    a:=(y2act-y1act)/(yW1-yW2);
    BfastY:=roundL(-a*(yW1-roundL(yW1)))+y2act-y1act;
    Y1fastY:=roundL(yW1);
    PfastY:=0;
    while (abs(a)<10000) and (PfastY<16) do
    begin
      a:=a*2;
      inc(PfastY);
    end;
    AfastY:=roundL(a);
  end;

procedure SetPropWorld(x1,y1,x2:float);
var
  y2:float;
begin
  if x2act>x1act then y2:= y1+ (y2act-y1act)/(x2act-x1act)*(x2-x1) else y2:=y1;
  setWorld(x1,y1,x2,y2);
end;


function convWIx(x:longint):integer;
begin
  if x>=0
    then result:=x1act+AfastX*(x-X1fastX) shr PfastX+BfastX
    else result:=convWx(x);
 end;

function convWIy(y:longint):integer;
  begin
    {convWIy:=y1act+AfastY*(y-Y1fastY) shr PfastY+BfastY;}

    result:=AfastY*(y-Y1fastY);
    if result>0 then result:=y1act+result shr PfastY+BfastY
                else result:=y1act-(-result) shr PfastY+BfastY;

   end;

function convWx(x:float):integer;
  begin
    convWx:=roundG(x1act+(x-xW1)*aWx);
  end;


function convWy(y:float):integer;
  begin
    convWy:=roundG(y2act+aWy*(y-yW1));
  end;

function convWxInvert(x:float):integer;
  begin
    result:=roundG(x2act-(x-xW1)*aWx);
  end;


function convWyInvert(y:float):integer;
  begin
    result:=roundG(y1act-aWy*(y-yW1));
  end;


function invconvWx(i:integer):float;
  begin
    result:=(i-x1act)/aWx+xW1;
  end;

function invconvWy(j:integer):float;
  begin
    result:=(j-y1act-bWy)/aWy+yW1;
  end;


procedure getWorld(var x1,y1,x2,y2:float);
  begin
    x1:=xW1;
    x2:=xW2;
    y1:=yW1;
    y2:=yW2;
  end;


procedure SetClippingON;
  var
    clipRgn:hrgn;
    n:integer;
  begin
    if manualClip then exit;
    if BadCanvas then exit;

    ClipRgn:=createRectRgn(x1act+leftGlb,y1act+topGlb,
                           x2act+leftGlb+1,y2act+topGlb+1);
    n:=selectClipRgn(canvasGlb.handle,Cliprgn);
    deleteObject(clipRgn);
    clip:=true;
  end;


procedure SetClippingOFF;
  var
    n:integer;
    clipRgn:hrgn;
  begin
    {CorelDraw n'accepte pas le copier-coller avec ce qui suit ==> PRprinting }
    if manualClip then exit;

    if BadCanvas then exit;

    ClipRgn:=createRectRgn(leftGlb,topGlb,
                           leftGlb+widthGlb,topGlb+heightGlb);

    if PRmetafile
      then n:=selectClipRgn(canvasGlb.handle,Cliprgn)
      else n:=selectClipRgn(canvasGlb.handle,0);

    {Il faut 0 pour openGL !!!
     Auparavant, 0 ne marchait pas
    }

    deleteObject(clipRgn);
    clip:=false;
  end;

procedure SetClipRegion(x1,y1,x2,y2:integer);
  var
    n:integer;
    clipRgn:hrgn;
  begin
    if BadCanvas then exit;
    ClipRgn:=createRectRgn(leftGlb+x1,topGlb+y1,leftGlb+x2,topGlb+y2);
    n:=selectClipRgn(canvasGlb.handle,Cliprgn);
    deleteObject(clipRgn);
    clip:=false;
    ManualClip:=true;
  end;

procedure ResetClipRegion;
begin
  ManualClip:=false;
  setClippingOff;
end;




procedure lineVer(x:float;col:Tcolor;modeXor:boolean);
  var
    oldpm:TpenMode;
  begin
    if BadCanvas then exit;
    pushCol;
    with canvasGlb do
    begin
      pen.color:=col;
      if modeXor then
        begin
          oldpm:=pen.mode;
          pen.mode:=pmNotXor;
        end;
      moveto(convWx(x),y1act);
      lineto(convWx(x),y2act);

      if modeXor then pen.mode:=oldpm;
    end;
    popCol;
  end;

procedure lineHor(y:float;col:Tcolor;modeXor:boolean);
  var
    oldpm:TpenMode;
  begin
    if BadCanvas then exit;
    pushCol;
    with canvasGlb do
    begin
      pen.color:=col;
      if modeXor then
        begin
          oldpm:=pen.mode;
          pen.mode:=pmNotXor;
        end;

      moveto(x1act,convWy(y));
      lineto(x2act,convWy(y));

      if modeXor then pen.mode:=oldpm;
    end;
    popCol;
  end;

procedure LineToSegment(a,b,xw1,yw1,xw2,yw2:float;var x1,y1,x2,y2:float);
  begin
    if a=0 then
      begin
        x1:=xw1;
        x2:=xw2;
        y1:=b;
        y2:=b;
      end
    else
      begin
        x1:=xw1;
        y1:=x1*a+b;
        if y1<yw1 then
          begin
            y1:=yw1;
            x1:=(y1-b)/a;
          end
        else
        if y1>yw2 then
          begin
            y1:=yw2;
            x1:=(y1-b)/a;
          end;

        x2:=xw2;
        y2:=x2*a+b;
        if y2<yw1 then
          begin
            y2:=yw1;
            x2:=(y2-b)/a;
          end
        else
        if y2>yw2 then
          begin
            y2:=yw2;
            x2:=(y2-b)/a;
          end;
      end;
  end;


procedure droite(a,b:float;col:Tcolor;modeXor:boolean);
  var
    x,y:array[1..2] of float;
    xu,yu:float;
    i,k:integer;
    oldpm:TpenMode;
  begin
    if BadCanvas then exit;
    pushCol;
    with canvasGlb do
    begin
      pen.color:=col;
      if modeXor then
        begin
          oldpm:=pen.mode;
          pen.mode:=pmXor;
        end;

      if a=0 then
        begin
          x[1]:=xw1;
          x[2]:=xw2;
          y[1]:=b;
          y[2]:=b;
        end
      else
        begin
          k:=0;

          xu:=xw1;             {left}
          yu:=xu*a+b;

          if (yu>=yw1) and (yu<=yw2) OR (yu>=yw2) and (yu<=yw1) then
          begin
            inc(k);
            x[k]:=xu;
            y[k]:=yu;
          end;

          xu:=xw2;             {right}
          yu:=xu*a+b;

          if (yu>=yw1) and (yu<=yw2) OR (yu>=yw2) and (yu<=yw1) then
          begin
            inc(k);
            x[k]:=xu;
            y[k]:=yu;
          end;

          yu:=yw1;             {top}
          xu:=(yu-b)/a;

          if (k<2) and ((xu>=xw1) and (xu<=xw2) OR (xu>=xw2) and (xu<=xw1)) then
          begin
            inc(k);
            x[k]:=xu;
            y[k]:=yu;
          end;

          yu:=yw2;             {bottom}
          xu:=(yu-b)/a;

          if (k<2) and ((xu>=xw1) and (xu<=xw2) OR (xu>=xw2) and (xu<=xw1)) then
          begin
            inc(k);
            x[k]:=xu;
            y[k]:=yu;
          end;

        end;

      if k=2 then
      begin
        moveto(convWx(x[1]),convWy(y[1]));
        lineto(convWx(x[2]),convWy(y[2]));
      end;

      if modeXor then pen.mode:=oldpm;
    end;
    popCol;
  end;


procedure SwapColorsGlb;
var
  col:integer;
begin
  if BadCanvas then exit;
  with canvasGlb do
  begin
    col:=pen.color;
    pen.color:=brush.color;
    brush.color:=col;
  end;
end;





procedure affPave(i1,j1,i2,j2:integer;col:longint);
  begin
    if BadCanvas then exit;
    with canvasGlb do
    begin
      pen.color:=col;
      pen.style:=psSolid;
      brush.color:=col;
      brush.style:=bsSolid;
      rectangle(i1,j1,i2,j2);
    end;
  end;

procedure UpDateAff;
var
  msg:Tmsg;
begin
  while peekMessage(msg,0,wm_paint,wm_paint,pm_remove) do
  begin
    translateMessage(msg);
    dispatchMessage(msg);
  end;
end;

function getNormalPosition(wnd:hwnd):Trect;
var
  wp:TwindowPlacement;
begin
  wp.length:=sizeof(wp);
  getWindowPlacement(wnd,@wp);
  getNormalPosition:= wp.rcNormalPosition;
end;

type
  TgraphicStack=record
    OldcanvasGlb:Tcanvas;
    OldBMexGlb:TbitmapEx;
    Oldx1act,Oldy1act,Oldx2act,Oldy2act:integer;
    OldtopGlb,OldleftGlb,OldWidthGlb,OldHeightGlb:integer;

    Oldclip:boolean;
    OldmanualClip:boolean;

    OldxW1,OldyW1,OldxW2,OldyW2:double;
    OldaWx,OldaWy:double;
    OldbWx,OldbWy:integer;


    OldAfastX,OldBfastX,OldX1fastX,OldPfastX,
    OldAfastY,OldBfastY,OldY1fastY,OldPfastY:integer;
  end;

const
  maxStack=10;
var
  Gstack:array[1..maxStack] of TgraphicStack;
  GstackPos:integer;

procedure PushG;
begin
  if GstackPos>=maxStack then
  begin
    {messageCentral('Gstack overflow');}
    exit;
  end;

  inc(GstackPos);
  with Gstack[GstackPos] do
  begin
    OldCanvasGlb:=canvasGlb;
    OldBMexGlb:=BMexGlb;
    Oldx1act:=x1act;
    Oldy1act:=y1act;
    Oldx2act:=x2act;
    Oldy2act:=y2act;

    OldTopGlb:=TopGlb;
    OldLeftGlb:=LeftGlb;
    OldWidthGlb:=WidthGlb;
    OldHeightGlb:=HeightGlb;

    Oldclip:=clip;
    OldmanualClip:=manualClip;

    OldxW1:=xW1;
    OldyW1:=yW1;
    OldxW2:=xW2;
    OldyW2:=yW2;
    OldaWx:=aWx;
    OldaWy:=aWy;
    OldbWx:=bWx;
    OldbWy:=bWy;

    OldAfastX:=AfastX;
    OldBfastX:=BfastX;
    OldX1fastX:=X1fastX;
    OldPfastX:=PfastX;

    OldAfastY:=AfastY;
    OldBfastY:=BfastY;
    OldY1fastY:=Y1fastY;
    OldPfastY:=PfastY;
  end;
  affdebug('Push Gstack='+Istr(GstackPos),19);
end;

procedure PopG;
begin
  if GstackPos<=0 then
  begin
    {messageCentral('Gstack underflow');}
    exit;
  end;

  with Gstack[GstackPos] do
  begin
    CanvasGlb:=OldcanvasGlb;
    BMexGlb:=OldBMexGlb;
    x1act:=Oldx1act;
    y1act:=Oldy1act;
    x2act:=Oldx2act;
    y2act:=Oldy2act;

    TopGlb:=OldTopGlb;
    LeftGlb:=OldLeftGlb;
    WidthGlb:=OldWidthGlb;
    HeightGlb:=OldHeightGlb;

    clip:=Oldclip;
    manualClip:=OldmanualClip;

    xW1:=OldxW1;
    yW1:=OldyW1;
    xW2:=OldxW2;
    yW2:=OldyW2;
    aWx:=OldaWx;
    aWy:=OldaWy;
    bWx:=OldbWx;
    bWy:=OldbWy;

    AfastX:=OldAfastX;
    BfastX:=OldBfastX;
    X1fastX:=OldX1fastX;
    PfastX:=OldPfastX;

    AfastY:=OldAfastY;
    BfastY:=OldBfastY;
    Y1fastY:=OldY1fastY;
    PfastY:=OldPfastY;
  end;
  dec(GstackPos);
  affdebug('Pop Gstack='+Istr(GstackPos),19);
end;

function roundG(x:float):integer;
const
   max=20000;
begin
  if x>max then result:=max
  else
  if x<-max then result:=-max
  else result:=round(x);
end;

function RectToString(r:Trect):AnsiString;
begin
  result:='('+Istr(r.Left)+','+Istr(r.top)+'),('+Istr(r.right)+','+Istr(r.bottom)+')' ;
end;

end.
