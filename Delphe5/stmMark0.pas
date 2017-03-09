unit stmMark0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,controls,forms,
     util1,Dgraphic,editCont,Dpalette,
     stmDef,stmObj,stmObv0,defForm,
     syspal32,
     getMark0, debug0
     {$IFDEF DX11}
     {$ELSE}
     , Direct3D9G, D3DX9G;
     {$ENDIF}


type
  Tmark=class(Tbar)

            constructor create;override;
            class function STMClassName:AnsiString;override;

            
            procedure Blt(const degV: typeDegre);override;

            procedure BuildResource;override;
            procedure afficheC;override;

            function DialogForm:TclassGenForm;override;
            procedure installDialog(var form:Tgenform;var newF:boolean);override;

            procedure display;override;
            procedure completeLoadInfo;override;
        end;


var
  ACleft, ACright:Tmark;

const
  stACleft='ACleft';
  stACright='ACright';

implementation

const
  Lmark=20;

constructor Tmark.create;
begin
  inherited create;
  noDim:=true;
  noTheta:=true;

  deg.dx:=pixToDeg(Lmark*2);
  deg.dy:=pixToDeg(Lmark*2);

end;


class function Tmark.STMClassName:AnsiString;
begin
  STMClassName:='Mark';
end;



procedure Tmark.BuildResource;
var
  vertices: array of TbarVertex;
  i,j,col:integer;
  up: boolean;

  pVertices: Pointer;

begin
  col:=  syspal.DX9color(deg.lum);
  setLength(vertices,5);
  with vertices[0] do
  begin
    x:=-1;
    y:= 0;
    color:= col;
  end;
  with vertices[1] do
  begin
    x:= 1;
    y:= 0;
    color:= col;
  end;
  with vertices[2] do
  begin
    x:= 0;
    y:= 0;
    color:= col;
  end;
  with vertices[3] do
  begin
    x:= 0;
    y:= -1;
    color:= col;
  end;
  with vertices[4] do
  begin
    x:= 0;
    y:= 1;
    color:= col;
  end;


  VB:=nil;
  if FAILED(DXscreen.IDevice.CreateVertexBuffer(SizeOf(TBarVertex)*5, 0, BarVertexCte, D3DPOOL_DEFAULT, VB, nil)) then Exit;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then Exit;
  CopyMemory(pVertices, @vertices[0], SizeOf(TBarVertex)*5);
  VB.Unlock;

  DX9end;

end;

procedure Tmark.Blt(const degV: typeDegre);
var
  mTrans: TD3DMatrix;
  res:integer;
begin
  with deg do
  begin
    D3DXMatrixTranslation(mTrans,x,y,0);

    res:=DXscreen.IDevice.SetTransform(D3DTS_WORLD, mTrans);

    DXscreen.Idevice.SetTextureStageState(0, D3DTSS_COLOROP,   D3DTOP_DISABLE);

    res:=DXscreen.IDevice.SetStreamSource(0, VB, 0, SizeOf(TBarVertex));
    res:=DXscreen.IDevice.SetFVF(BarVertexCte);
    res:=DXscreen.IDevice.DrawPrimitive(D3DPT_LINESTRIP, 0, 4 );
  end;

  DX9end;
end;



procedure Tmark.afficheC;
var
  x1,x2,y1,y2:integer;
  i:integer;
begin
  x1:=DegToXC(deg.x)-Lmark;
  x2:=DegToXC(deg.x)+Lmark;

  y1:=DegToYC(deg.y)-Lmark;
  y2:=DegToYC(deg.y)+Lmark;

  with canvasGlb do
  begin
      pen.color:=clWhite;
      brush.style:=bsClear;

      moveto(x1,(y1+y2) div 2);
      lineto(x2,(y1+y2) div 2);
      moveto((x1+x2) div 2,y1);
      lineto((x1+x2) div 2,y2);
  end;

  degToPolyAff(deg,polyAff);

  creerRegions;
end;

function Tmark.DialogForm:TclassGenForm;
begin
  DialogForm:=TmarkForm;
end;

procedure Tmark.installDialog(var form:Tgenform;var newF:boolean);
  begin
    majPos;

    installForm(form,newF);

    TmarkForm(Form).onScreenD:=SetOnScreen;
    TmarkForm(Form).onControlD:=SetOnControl;
    TmarkForm(Form).onlockD:=setLocked;
    TmarkForm(Form).majpos:=majpos;

    TmarkForm(Form).setDeg(deg,onScreen,onControl,locked);
  end;

procedure Tmark.display;
var
  x1,y1,x2,y2:integer;
begin
  x1:=convWx(deg.x-Lmark);
  x2:=convWx(deg.x+Lmark);

  y1:=convWy(deg.y-Lmark);
  y2:=convWy(deg.y+Lmark);

  with canvasGlb do
  begin
    pen.color:=clBlack;
    brush.style:=bsClear;

    moveto(x1,(y1+y2) div 2);
    lineto(x2,(y1+y2) div 2);
    moveto((x1+x2) div 2,y1);
    lineto((x1+x2) div 2,y2);
  end;
end;

procedure Tmark.completeLoadInfo;
begin
  inherited;

  deg.dx:=pixToDeg(Lmark*2);
  deg.dy:=pixToDeg(Lmark*2);

end;

{
function fonctionTsystem_ACleft(var pu:typeUO):pointer;
begin
  fonctionTsystem_ACleft:=@ACleft;
end;

function fonctionTsystem_ACright(var pu:typeUO):pointer;
begin
  fonctionTsystem_ACright:=@ACright;
end;
}

Initialization
AffDebug('Initialization stmMark0',0);

if testUnic then registerObject(Tmark,obvis);

end.
