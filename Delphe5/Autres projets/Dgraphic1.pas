unit Dgraphic1;
{ N'est pas utilisée . Voir Dgraphic }


Interface

uses
  Windows,
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  util1,BMex1;


type
  TcanvasEx=class
  private
    clip:boolean;      { ne sert que pour drawBorderOut pour remettre
                               le clip après le tracé}
    manualClip:boolean;{ Affecté par setClipRegion et resetClipRegion }

    xW1,yW1,xW2,yW2:double;
    aWx,aWy:double;
    bWx,bWy:integer;

    AfastX:longint;
    BfastX:longint;
    X1fastX:longint;
    PfastX:integer;
    AfastY:longint;
    BfastY:longint;
    Y1fastY:longint;
    PfastY:integer;

    Pcol,Bcol:Tcolor;
    Psty:TpenStyle;
    Bsty:TbrushStyle;
    Pwid:integer;

    procedure InitVar;
  public
    canvasGlb:Tcanvas;
    x1act,y1act,x2act,y2act:integer;
    topGlb,leftGlb,WidthGlb,HeightGlb:integer;
    BMexGlb:TbitmapEx;

    AbortDisplay:boolean;
    Isprinting:boolean;
    Ismetafile:boolean;


    constructor create(c:Tcanvas;left,top,width,height:integer);overload;
    constructor create(bm:TbitmapEx);overload;

    destructor destroy;override;

    procedure setWindow(x1,y1,x2,y2:integer);
    procedure mainWindow;
    procedure clearWindow(col:Tcolor);

    procedure setWorld(x1,y1,x2,y2:float);
    procedure getWorld(var x1,y1,x2,y2:float);

    function convWx(x:float):integer;
    function convWy(y:float):integer;

    function invconvWx(i:integer):float;
    function invconvWy(j:integer):float;

    function convWIx(x:longint):integer;
    function convWIy(y:longint):integer;

    procedure DrawBorder(col:Tcolor);
    procedure DrawBorderOut(col:Tcolor);

    procedure lineVer(x:float;col:Tcolor;modeXor:boolean);
    procedure lineHor(y:float;col:Tcolor;modeXor:boolean);
    procedure droite(a,b:float;col:Tcolor;modeXor:boolean);

    procedure SetClippingON;
    procedure SetClippingOFF;
    procedure SetClipRegion(x1,y1,x2,y2:integer);
    procedure ResetClipRegion;

    procedure PushCol;
    procedure PopCol;

    procedure textOutG(x,y:integer;st:string);
    procedure getWindowG(var x1,y1,x2,y2:integer);

    procedure affPave(i1,j1,i2,j2:integer;col:longint);
  end;

IMPLEMENTATION

uses debug0;



procedure TcanvasEx.InitVar;
begin
  AfastX:=1;
  AfastY:=1;

end;


constructor TcanvasEx.create(c:Tcanvas;left,top,width,height:integer);
begin
  affDebug('InitGraphic '+LongToHexa(integer(c)),19);
  {if canvasGlb<>nil
    then messageCentral('initGraphic canvasGlb<>nil');}

  canvasGlb:=c;
  if c=nil then exit;

  topGlb:=top;
  leftGlb:=left;
  WidthGlb:=width;
  HeightGlb:=height;

  resetClipRegion;
  setWindow(0,0,WidthGlb,HeightGlb);

  affdebug('initGraphic '+Istr(integer(c)),3);
  initVar;
end;

constructor TcanvasEx.create(bm:TbitmapEx);
begin
  affDebug('InitGraphic BM ',19);
  bmexGlb:=bm;

  {if canvasGlb<>nil
    then messageCentral('initGraphic BM canvasGlb<>nil');}

  with bm do
  begin
    canvasGlb:=canvas;

    if canvas=nil then exit;
    topGlb:=0;
    leftGlb:=0;
    WidthGlb:=width;
    HeightGlb:=height;
    resetClipRegion;
    setWindow(0,0,WidthGlb,HeightGlb);
  end;

  initVar;
end;

destructor TcanvasEx.destroy;
begin
  affDebug('doneGraphic ',19);
  setClippingOff;
end;


procedure TcanvasEx.setWindow(x1,y1,x2,y2:integer);
  begin
    if x2<=x1 then x2:=x1+1;
    if y2<=y1 then y2:=y1+1;
    x1act:=x1;
    y1act:=y1;
    x2act:=x2;
    y2act:=y2;

    setClippingON;
  end;

procedure TcanvasEx.getWindowG(var x1,y1,x2,y2:integer);
  begin
    x1:=x1act;
    y1:=y1act;
    x2:=x2act;
    y2:=y2act;
  end;


procedure TcanvasEx.mainWindow;
begin
  setWindow(0,0,WidthGlb,HeightGlb);
end;



procedure TcanvasEx.PushCol;
begin
  if CanvasGlb=nil then exit;
  PCol:=canvasGlb.pen.color;
  Psty:=canvasGlb.pen.style;
  pwid:=canvasGlb.pen.width;

  BCol:=canvasGlb.brush.color;
  Bsty:=canvasGlb.brush.style;
end;

procedure TcanvasEx.PopCol;
begin
  if canvasGlb=nil then exit;
  canvasGlb.pen.color:=Pcol;
  canvasGlb.pen.style:=Psty;
  canvasGlb.pen.width:=Pwid;

  canvasGlb.brush.color:=Bcol;
  canvasGlb.brush.style:=Bsty;
end;


procedure TcanvasEx.textOutG(x,y:integer;st:string);
begin
  if CanvasGlb=nil then exit;
  canvasGlb.textOut(x1act+x,y1act+y,st);
end;

procedure TcanvasEx.DrawBorder(col:Tcolor);
begin
  if CanvasGlb=nil then exit;
  with canvasGlb do
  begin
    pushCol;
    pen.color:=col;
    brush.style:=bsclear;
    rectangle(x1act,y1act,x2act+1,y2act+1);
    popCol;
  end;
end;

procedure TcanvasEx.DrawBorderOut(col:Tcolor);
var
 clp:boolean;
begin
  clp:=clip;
  if CanvasGlb=nil then exit;
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


procedure TcanvasEx.clearWindow(col:Tcolor);
begin
  if (CanvasGlb=nil) or ISprinting then exit;

  with canvasGlb do
  begin
    pushCol;
    pen.color:=col;
    brush.color:=col;
    rectangle(x1act,y1act,x2act+1,y2act+1);
    popCol;
  end;
end;


procedure TcanvasEx.setWorld(x1,y1,x2,y2:float);
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


function TcanvasEx.convWIx(x:longint):integer;
  begin
    convWIx:=x1act+AfastX*(x-X1fastX) shr PfastX+BfastX;
   end;

function TcanvasEx.convWIy(y:longint):integer;
  begin
    {convWIy:=y1act+AfastY*(y-Y1fastY) shr PfastY+BfastY;}

    result:=AfastY*(y-Y1fastY);
    if result>0 then result:=y1act+result shr PfastY+BfastY
                else result:=y1act-(-result) shr PfastY+BfastY;

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


function TcanvasEx.convWx(x:float):integer;
  begin
    convWx:=roundG(x1act+(x-xW1)*aWx);
  end;

function TcanvasEx.convWy(y:float):integer;
  begin
    convWy:=roundG(y1act+aWy*(y-yW1)+bWy);
  end;

function TcanvasEx.invconvWx(i:integer):float;
  begin
    result:=(i-x1act)/aWx+xW1;
  end;

function TcanvasEx.invconvWy(j:integer):float;
  begin
    result:=(j-y1act-bWy)/aWy+yW1;
  end;


procedure TcanvasEx.getWorld(var x1,y1,x2,y2:float);
  begin
    x1:=xW1;
    x2:=xW2;
    y1:=yW1;
    y2:=yW2;
  end;


procedure TcanvasEx.SetClippingON;
  var
    clipRgn:hrgn;
    n:integer;
  begin
    if manualClip then exit;
    if canvasGlb=nil then exit;

    ClipRgn:=createRectRgn(x1act+leftGlb,y1act+topGlb,
                           x2act+leftGlb+1,y2act+topGlb+1);
    n:=selectClipRgn(canvasGlb.handle,Cliprgn);
    deleteObject(clipRgn);
    clip:=true;
  end;


procedure TcanvasEx.SetClippingOFF;
  var
    n:integer;
    clipRgn:hrgn;
  begin
    {CorelDraw n'accepte pas le copier-coller avec ce qui suit ==> ISprinting }
    if manualClip then exit;

    if canvasGlb=nil then exit;

    ClipRgn:=createRectRgn(leftGlb,topGlb,
                           leftGlb+widthGlb,topGlb+heightGlb);

    if ISmetafile
      then n:=selectClipRgn(canvasGlb.handle,Cliprgn)
      else n:=selectClipRgn(canvasGlb.handle,0);

    {Il faut 0 pour openGL !!!
     Auparavant, 0 ne marchait pas
    }

    deleteObject(clipRgn);
    clip:=false;
  end;

procedure TcanvasEx.SetClipRegion(x1,y1,x2,y2:integer);
  var
    n:integer;
    clipRgn:hrgn;
  begin
    if canvasGlb=nil then exit;
    ClipRgn:=createRectRgn(leftGlb+x1,topGlb+y1,leftGlb+x2,topGlb+y2);
    n:=selectClipRgn(canvasGlb.handle,Cliprgn);
    deleteObject(clipRgn);
    clip:=false;
    ManualClip:=true;
  end;

procedure TcanvasEx.ResetClipRegion;
begin
  ManualClip:=false;
  setClippingOff;
end;


procedure TcanvasEx.lineVer(x:float;col:Tcolor;modeXor:boolean);
  var
    oldpm:TpenMode;
  begin
    if canvasGlb=nil then exit;
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

procedure TcanvasEx.lineHor(y:float;col:Tcolor;modeXor:boolean);
  var
    oldpm:TpenMode;
  begin
    if canvasGlb=nil then exit;
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


procedure TcanvasEx.droite(a,b:float;col:Tcolor;modeXor:boolean);
  var
    x1,y1,x2,y2:float;
    oldpm:TpenMode;
  begin
    if canvasGlb=nil then exit;
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

      moveto(convWx(x1),convWy(y1));
      lineto(convWx(x2),convWy(y2));

      if modeXor then pen.mode:=oldpm;
    end;
    popCol;
  end;


procedure TcanvasEx.affPave(i1,j1,i2,j2:integer;col:longint);
  begin
    if canvasGlb=nil then exit;
    with canvasGlb do
    begin
      pen.color:=col;
      pen.style:=psSolid;
      brush.color:=col;
      brush.style:=bsSolid;
      rectangle(i1,j1,i2,j2);
    end;
  end;


end.
