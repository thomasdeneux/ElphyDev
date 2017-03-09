unit stmWinCur;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,menus,graphics,sysutils,controls,

     util1,Dgraphic,varconf1,Dtrace1,BMex1,
     stmDef,stmObj,stmPlot1,stmDplot,stmPopup,stmvec1,stmCur0,
     stmPg,

     iniVzoom;

type

  TWposition=record
               x,y,h:float;
             end;

  TwinCur=
    class(TstmCur)
    protected

      procedure setCapRect;override;
      procedure ModifyPoint(num:integer;p:TRpoint);override;

      procedure setWposition(w:TWposition);
      function getWposition:TWposition;
    public
      constructor create;override;

      class function STMClassName:AnsiString;override;
      function initialise(st:AnsiString):boolean;override;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure RetablirReferences(list:Tlist);override;
      procedure processMessage(id:integer;source:typeUO;p:pointer);override;

      procedure saveRects(BMex:TbitmapEx);
      procedure paintCursor(BMex:TbitmapEx); override;

      property Wposition:TWposition read getWposition write setWposition;

    end;


implementation

{ TwinCur }


constructor TwinCur.create;
begin
  inherited;

  setLength(xcur,2);
  setLength(ycur,2);

  xcur[0]:=10;
  ycur[0]:=10;
  xcur[1]:=10;
  ycur[1]:=20;


  setLength(capRect,2);
end;

function TwinCur.initialise(st: AnsiString): boolean;
begin
  result:= inherited initialise(st);
end;

procedure TwinCur.SaveRects(BMex:TbitmapEx);
var
  i0,j0,i1,j1:integer;
  u:integer;
  rr:Trect;
begin
  if not assigned(BMex) then exit;

  i0:=convWx(xcur[0]);
  j0:=convWy(ycur[0]);
  i1:=convWx(xcur[1]);
  j1:=convWy(ycur[1]);

  if j1<j0 then
    begin
      u:=j0;
      j0:=j1;
      j1:=u;
    end;


  rr:=rect(LeftGlb+i0-3,TopGlb+j0-5,LeftGlb+i0+3,TopGlb+j1+5);

  BMex.saveRect(rr);
end;


procedure TwinCur.paintCursor(BMex:TbitmapEx);
var
  i0,j0,i1,j1:integer;
  u:integer;
  p:array[1..3] of Tpoint;

begin
  if not visible then exit;

  SaveRects(BMex);

  with canvasGlb do
  begin
    pen.color:=color0;
    pen.Style:=psSolid;
    brush.color:=color0;
    brush.Style:=bsSolid;

    i0:=convWx(xcur[0]);
    j0:=convWy(ycur[0]);
    i1:=convWx(xcur[1]);
    j1:=convWy(ycur[1]);

    if j1<j0 then
      begin
        u:=j0;
        j0:=j1;
        j1:=u;
      end;

    moveto(i0,j0);
    lineto(i1,j1);

    p[1]:= point(i0,j1);       {Point du bas. Triangle pointe en haut}
    p[2]:= point(i0-2,j1+4);
    p[3]:= point(i0+2,j1+4);
    polygon(p);

    p[1]:= point(i1,j0);       {Point du haut. Triangle pointe en bas}
    p[2]:= point(i1-2,j0-4);
    p[3]:= point(i1+2,j0-4);
    polygon(p);
  end;
end;


procedure TwinCur.ModifyPoint(num: integer; p: TRpoint);
var
  h:float;
begin
  h:=ycur[1]-ycur[0];
  xcur[num]:=p.x;
  ycur[num]:=p.y;

  if num=0 then
    begin
      xcur[1]:=p.x;
      ycur[1]:=ycur[0]+h;
    end
  else
    begin
      xcur[1]:=xcur[0];

    end;
end;

procedure TwinCur.setCapRect;
var
  i0,j0,i1,j1:integer;
begin
  i0:=convWx(xcur[0])-x1act;
  j0:=convWy(ycur[0])-y1act;
  i1:=convWx(xcur[1])-x1act;
  j1:=convWy(ycur[1])-y1act;

  if j0<=j1 then
    begin
      CapRect[0]:=rect(i0-2,j0-4,i0+2,j0);
      CapRect[1]:=rect(i1-2,j1,i1+2,j1+4);
    end
  else
    begin
      CapRect[0]:=rect(i0-2,j0,i0+2,j0+4);
      CapRect[1]:=rect(i1-2,j1-4,i1+2,j1);
    end;

end;




procedure TwinCur.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;

end;

procedure TwinCur.processMessage(id: integer; source: typeUO; p: pointer);
begin
  inherited;

end;

procedure TwinCur.RetablirReferences(list: Tlist);
begin
  inherited;

end;


class function TwinCur.STMClassName: AnsiString;
begin
  result:='WinCursor';
end;

function TwinCur.getWposition: TWposition;
begin
  with result do
  begin
    x:=xcur[0];
    y:=ycur[0];
    h:=ycur[1]-ycur[0];
  end;
end;

procedure TwinCur.setWposition(w: TWposition);
begin
  with w do
  begin
    ModifyPoint(0,Rpoint(w.x,w.y));
    ModifyPoint(1,Rpoint(w.x,w.y+w.h));
  end;
  invalidateAfter;
end;

Initialization
AffDebug('Initialization stmWinCur',0);

registerObject(TwinCur,data);

end.
