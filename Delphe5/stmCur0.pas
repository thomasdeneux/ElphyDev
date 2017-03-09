unit stmCur0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

{TstmCur est l'ancêtre de TwinCur dans stmWinCur}

uses windows,classes,menus,graphics,sysutils,controls,
     util1,Dgraphic,varconf1,Dtrace1,BMex1,
     stmDef,stmObj,stmPlot1,stmDplot,stmPopup,stmvec1,
     stmPg,

     iniVzoom;

type

  TstmCur=
    class(TypeUO)
    protected
      obref0,obRefB:TdataPlot;
      xcur,ycur:array of float;

      Fcapture:boolean;
      NumCap:integer;
      IrectCap:Trect;

      CapRect:array of Trect;
      DxCap,DyCap:integer;

      color0:integer;
      visible0:boolean;

      procedure installObref(ref:TdataPlot);

      procedure setVisible(b:boolean);
      function getVisible:boolean;

      procedure setCurLocked(b:boolean);
      function getCurLocked:boolean;

      function GetPosition(n:integer):TRpoint;
      procedure SetPosition(n:integer;p:TRpoint);



      procedure setCapRect;virtual;
      procedure ModifyPoint(num:integer;p:TRpoint);virtual;

    public
      constructor create;override;
      destructor destroy;override;
      procedure FreeRef;override;

      class function STMClassName:AnsiString;override;
      function initialise(st:AnsiString):boolean;override;



      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
      procedure RetablirReferences(list:Tlist);override;
      procedure processMessage(id:integer;source:typeUO;p:pointer);override;


      procedure invalidateAfter;virtual;

      function MouseDownMG2(Irect:Trect;
          Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean; override;
      function MouseMoveMG2(x,y:integer):boolean;override;
      procedure MouseUpMG2(x,y:integer);override;

      property visible:boolean read getVisible write setVisible;
      property CurLocked:boolean read getCurLocked write setCurLocked;
      property position[n:integer]:TRpoint read GetPosition write SetPosition;

      procedure paintCursor(BMex:TbitmapEx); override;

      property obref:TdataPlot read obref0 write installObRef;
      property color:integer read color0 write color0;
    end;


implementation

{ TstmCur }


constructor TstmCur.create;
begin
  inherited;

  setLength(xcur,1);
  setLength(ycur,1);

  xcur[0]:=10;
  ycur[0]:=10;

  setLength(capRect,1);

  visible0:=true;
end;

destructor TstmCur.destroy;
begin
  FreeRef;
  inherited;
end;


procedure TstmCur.FreeRef;
begin
  inherited;
  obref:=nil;
end;


function TstmCur.initialise(st: AnsiString): boolean;
var
  src:TdataPlot;
begin
  inherited initialise(st);

  src:=obref;

  result:=initVzoom.execution('Test cursor: '+st,Tvector(src));

  if result then installObRef(src);
end;

procedure TstmCur.installObref(ref: TdataPlot);
begin
  derefObjet(typeUO(obref0));
  obref0:=TdataPlot(ref);
  refobjet(ref);
end;

procedure TstmCur.invalidateAfter;
begin
  if assigned(obref) then obref.InvalidateCursors;
end;

procedure TstmCur.paintCursor(BMex:TbitmapEx);
var
  rr:Trect;
  i0,j0:integer;
begin
  if assigned(BMex) then
  begin
    i0:=convWx(xcur[0]);
    j0:=convWx(ycur[0]);

    rr:=rect(LeftGlb+i0-3,TopGlb+j0-3,LeftGlb+i0+3,TopGlb+j0+3);

    BMex.saveRect(rr);
  end;

  if visible then displaySymbol(carreA,3,color0,xcur[0],ycur[0]);
end;



class function TstmCur.STMClassName: AnsiString;
begin
  result:='TestCur';
end;

function TstmCur.MouseDownMG2(Irect: Trect; Shift: TShiftState; Xc, Yc, X,
  Y: Integer): boolean;
var
  i,x1,y1:integer;
begin
  {coo du clic dans le rectangle intérieur}
  x1:=x+x1act-Irect.left;
  y1:=y+y1act-Irect.top;

  result:=false;
  Fcapture:=false;

  if not visible then exit;

  with Irect do setWindow(left,top,right,bottom);
  with obref do Dgraphic.setWorld(Xmin,Ymin,Xmax,Ymax);

  setCaprect;

  for i:=0 to high(CapRect) do
    if ptInRect(CapRect[i],classes.point(x1,y1)) then
      begin
        Fcapture:=true;
        NumCap:=i;
        IrectCap:=Irect;

        DxCap:=x1act+x1-ConvWx(xcur[i]);
        DyCap:=y1act+y1-ConvWy(ycur[i]);
        result:=true;
      end;

end;

function TstmCur.MouseMoveMG2(x, y: integer): boolean;
var
  p:TRpoint;
begin
  result:=Fcapture;

  if result and not CurLocked then
    begin
      with IrectCap do setWindow(left,top,right,bottom);

      with obref do Dgraphic.setWorld(Xmin,Ymin,Xmax,Ymax);

      x:=x-dxCap;
      if x<IrectCap.left then x:=IrectCap.left;
      if x>IrectCap.right then x:=IrectCap.right;


      y:=y-DyCap;
      if y<IrectCap.top then y:=IrectCap.top;
      if y>IrectCap.bottom then y:=IrectCap.bottom;

      p.x:=invConvWx(x);
      p.y:=invConvWy(y);
      position[numcap]:=p;

    end;

end;

procedure TstmCur.MouseUpMG2(x, y: integer);
begin
  if Fcapture then
    begin
      invalidateAfter;
    end;
  Fcapture:=false;
end;

function TstmCur.getVisible: boolean;
begin
  result:=visible0;
end;

procedure TstmCur.setVisible(b: boolean);
begin
  visible0:=b;
end;

procedure TstmCur.setCaprect;
var
  i0,j0:integer;
begin
  i0:=convWx(xcur[0])-x1act;
  j0:=convWy(ycur[0])-y1act;

  CapRect[0]:=rect(i0-5,j0-3,i0+5,j0+3);

end;

function TstmCur.getCurLocked: boolean;
begin
  result:=false;
end;

procedure TstmCur.setCurLocked(b: boolean);
begin

end;


procedure TstmCur.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;
  with conf do
  begin
    if lecture
      then setvarconf('ObRef',obRefB,sizeof(pointer))
      else setvarconf('ObRef',obRef0,sizeof(pointer));

    setvarconf('Xcur',Xcur[0],sizeof(float)*(high(xcur)+1));
    setvarconf('Ycur',Ycur[0],sizeof(float)*(high(ycur)+1));

    setvarconf('Visible',visible0,sizeof(visible0));
    setvarconf('color0',color0,sizeof(color0));

  end;
end;

procedure TstmCur.processMessage(id: integer; source: typeUO; p: pointer);
begin
  inherited processMessage(id,source,p);
  case id of
    UOmsg_destroy:
      begin
        if obref=source then installObRef(nil);
      end;
  end;
end;

procedure TstmCur.RetablirReferences(list: Tlist);
var
  i:integer;
  p:pointer;
begin
  for i:=0 to list.count-1 do
    begin
      p:=typeUO(list.items[i]).myAd;
      if p=obrefB then installObRef(list.items[i]);
    end;

end;

function TstmCur.GetPosition(n: integer): TRpoint;
begin
  result.x:=xcur[n];
  result.y:=ycur[n];
end;

procedure TstmCur.SetPosition(n: integer; p: TRpoint);
begin
  ModifyPoint(n,p);
  invalidateAfter;
end;

procedure TstmCur.ModifyPoint(num: integer; p: TRpoint);
begin
  xcur[num]:=p.x;
  ycur[num]:=p.y;
end;



Initialization
AffDebug('Initialization stmCur0',0);

{registerObject(TstmCur,data);}

end.
