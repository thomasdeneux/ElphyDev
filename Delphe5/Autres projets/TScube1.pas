unit TScube1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
  util1,Dgraphic,
  DirectXG,DXclassG,D3DutilsG, StdCtrls, editcont,dibG, DXDrawsG;


const
  maxMat=20;

type
  Tcube=array[0..23] of TD3Dvertex;

  Tface=array[0..3] of TD3Dvertex;


type
  TForm1 = class(TForm)
    DXDraw1: TDXDraw;
    Panel1: TPanel;
    sbAlpha: TscrollbarV;
    sbBeta: TscrollbarV;
    sbDist: TscrollbarV;
    Lalpha: TLabel;
    Lbeta: TLabel;
    Ldist: TLabel;
    sbLightX: TscrollbarV;
    sbLightY: TscrollbarV;
    sbLightZ: TscrollbarV;
    LlightX: TLabel;
    LlightY: TLabel;
    LlightZ: TLabel;
    sbFov: TscrollbarV;
    Lfov: TLabel;
    procedure DXDraw1InitializeSurface(Sender: TObject);
    procedure sbAlphaScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbBetaScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbDistScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure FormCreate(Sender: TObject);
    procedure sbLightXScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbLightYScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbLightZScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbFovScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure DXDraw1Initialize(Sender: TObject);
    procedure DXDraw1Finalize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    cube:Tcube;
    alpha,beta,Dist:single;
    Xlight,Ylight,Zlight:single;

    fFOV, fAspect, fNearPlane, fFarPlane:single;

    mat:array[1..maxMat,1..maxMat] of integer;
    matV:array[0..maxMat*maxMat*24-1] of TD3Dvertex;

    faces:array[1..10000] of Tface;
    nbfaces:integer;

    FTexture: TDirect3DTexture2;
    FTextureImage: TDIB;
    Fcolor:array[0..5] of integer;

    procedure makeCube;
    procedure setView;
    procedure Display;
    procedure setFormLight;
    procedure setFormProjection;

    procedure makeCube1(var v;x,y,z:single);
    procedure makeMat;
    procedure makeMat2;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure FrontFace(var face:Tface;x1,x2,y1,y2,z:float);
const
  n0:TD3Dvector=(x:0;y:0;z:-1);
begin
  face[0] := MakeD3DVERTEX( MakeD3DVECTOR( x1, y2, z), n0, 0.0, 0.0 );
  face[1] := MakeD3DVERTEX( MakeD3DVECTOR( x2, y2, z), n0, 1/8, 0.0 );
  face[2] := MakeD3DVERTEX( MakeD3DVECTOR( x1, y1, z), n0, 0.0, 1.0 );
  face[3] := MakeD3DVERTEX( MakeD3DVECTOR( x2, y1, z), n0, 1/8, 1.0 );
end;

procedure BackFace(var face:Tface;x1,x2,y1,y2,z:float);
const
  n1:TD3Dvector=(x:0;y:0;z:1);
begin
  face[0] := MakeD3DVERTEX( MakeD3DVECTOR( x1, y2, z), n1, 2/8, 0.0 );
  face[1] := MakeD3DVERTEX( MakeD3DVECTOR( x1, y1, z), n1, 2/8, 1.0 );
  face[2] := MakeD3DVERTEX( MakeD3DVECTOR( x2, y2, z), n1, 1/8, 0.0 );
  face[3] := MakeD3DVERTEX( MakeD3DVECTOR( x2, y1, z), n1, 1/8, 1.0 );
end;

procedure TopFace(var face:Tface;x1,x2,y,z1,z2:float);
const
  n2:TD3Dvector=(x:0;y:1;z:0);
begin
  face[0] := MakeD3DVERTEX( MakeD3DVECTOR( x1, y, z2), n2, 2/8, 0.0 );
  face[1] := MakeD3DVERTEX( MakeD3DVECTOR( x2, y, z2), n2, 3/8, 0.0 );
  face[2] := MakeD3DVERTEX( MakeD3DVECTOR( x1, y, z1), n2, 2/8, 1.0 );
  face[3] := MakeD3DVERTEX( MakeD3DVECTOR( x2, y, z1), n2, 3/8, 1.0 );
end;

procedure BottomFace(var face:Tface;x1,x2,y,z1,z2:float);
const
  n3:TD3Dvector=(x:0;y:-1;z:0);
begin
  face[0] := MakeD3DVERTEX( MakeD3DVECTOR( x1, y, z2), n3, 3/8, 0.0 );
  face[1] := MakeD3DVERTEX( MakeD3DVECTOR( x1, y, z1), n3, 3/8, 1.0 );
  face[2] := MakeD3DVERTEX( MakeD3DVECTOR( x2, y, z2), n3, 4/8, 0.0 );
  face[3] := MakeD3DVERTEX( MakeD3DVECTOR( x2, y, z1), n3, 4/8, 1.0 );
end;


procedure RightFace(var face:Tface;x,y1,y2,z1,z2:float);
const
  n4:TD3Dvector=(x:1;y:0;z:0);
begin
  face[0] := MakeD3DVERTEX( MakeD3DVECTOR( x, y2, z1), n4, 4/8, 0.0 );
  face[1] := MakeD3DVERTEX( MakeD3DVECTOR( x, y2, z2), n4, 5/8, 0.0 );
  face[2] := MakeD3DVERTEX( MakeD3DVECTOR( x, y1, z1), n4, 4/8, 1.0 );
  face[3] := MakeD3DVERTEX( MakeD3DVECTOR( x, y1, z2), n4, 5/8, 1.0 );
end;

procedure LeftFace(var face:Tface;x,y1,y2,z1,z2:float);
const
  n5:TD3Dvector=(x:-1;y:0;z:0);
begin
  face[0] := MakeD3DVERTEX( MakeD3DVECTOR(x, y2, z1), n5, 6/8, 0.0 );
  face[1] := MakeD3DVERTEX( MakeD3DVECTOR(x, y1, z1), n5, 6/8, 1.0 );
  face[2] := MakeD3DVERTEX( MakeD3DVECTOR(x, y2, z2), n5, 5/8, 0.0 );
  face[3] := MakeD3DVERTEX( MakeD3DVECTOR(x, y1, z2), n5, 5/8, 1.0 );
end;



procedure TForm1.MakeCube;
var
  n0, n1, n2, n3, n4, n5: TD3DVector;
begin

  // Define the normals for the cube
  n0 := MakeD3DVector( 0.0, 0.0,-1.0 ); // Front face
  n1 := MakeD3DVector( 0.0, 0.0, 1.0 ); // Back face
  n2 := MakeD3DVector( 0.0, 1.0, 0.0 ); // Top face
  n3 := MakeD3DVector( 0.0,-1.0, 0.0 ); // Bottom face
  n4 := MakeD3DVector( 1.0, 0.0, 0.0 ); // Right face
  n5 := MakeD3DVector(-1.0, 0.0, 0.0 ); // Left face

  // Front face
  Cube[0] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0, 1.0,-1.0), n0, 0.0, 0.0 );
  Cube[1] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0, 1.0,-1.0), n0, 1.0, 0.0 );
  Cube[2] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0,-1.0,-1.0), n0, 0.0, 1.0 );
  Cube[3] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0,-1.0,-1.0), n0, 1.0, 1.0 );

  // Back face
  Cube[4] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0, 1.0, 1.0), n1, 1.0, 0.0 );
  Cube[5] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0,-1.0, 1.0), n1, 1.0, 1.0 );
  Cube[6] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0, 1.0, 1.0), n1, 0.0, 0.0 );
  Cube[7] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0,-1.0, 1.0), n1, 0.0, 1.0 );

  // Top face
  Cube[8] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0, 1.0, 1.0), n2, 0.0, 0.0 );
  Cube[9] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0, 1.0, 1.0), n2, 1.0, 0.0 );
  Cube[10] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0, 1.0,-1.0), n2, 0.0, 1.0 );
  Cube[11] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0, 1.0,-1.0), n2, 1.0, 1.0 );

  // Bottom face
  Cube[12] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0,-1.0, 1.0), n3, 0.0, 0.0 );
  Cube[13] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0,-1.0,-1.0), n3, 0.0, 1.0 );
  Cube[14] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0,-1.0, 1.0), n3, 1.0, 0.0 );
  Cube[15] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0,-1.0,-1.0), n3, 1.0, 1.0 );

  // Right face
  Cube[16] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0, 1.0,-1.0), n4, 0.0, 0.0 );
  Cube[17] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0, 1.0, 1.0), n4, 1.0, 0.0 );
  Cube[18] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0,-1.0,-1.0), n4, 0.0, 1.0 );
  Cube[19] := MakeD3DVERTEX( MakeD3DVECTOR( 1.0,-1.0, 1.0), n4, 1.0, 1.0 );

  // Left face
  Cube[20] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0, 1.0,-1.0), n5, 1.0, 0.0 );
  Cube[21] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0,-1.0,-1.0), n5, 1.0, 1.0 );
  Cube[22] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0, 1.0, 1.0), n5, 0.0, 0.0 );
  Cube[23] := MakeD3DVERTEX( MakeD3DVECTOR(-1.0,-1.0, 1.0), n5, 0.0, 1.0 );
end;

procedure TForm1.MakeCube1(var v;x,y,z:single);
var
  n0, n1, n2, n3, n4, n5: TD3DVector;
  cube:Tcube absolute v;
begin

  // Define the normals for the cube
  n0 := MakeD3DVector( 0.0, 0.0,-1.0 ); // Front face
  n1 := MakeD3DVector( 0.0, 0.0, 1.0 ); // Back face
  n2 := MakeD3DVector( 0.0, 1.0, 0.0 ); // Top face
  n3 := MakeD3DVector( 0.0,-1.0, 0.0 ); // Bottom face
  n4 := MakeD3DVector( 1.0, 0.0, 0.0 ); // Right face
  n5 := MakeD3DVector(-1.0, 0.0, 0.0 ); // Left face

  // Front face
  Cube[0] := MakeD3DVERTEX( MakeD3DVECTOR(x,   y+1, -z), n0, 0.0, 0.0 );
  Cube[1] := MakeD3DVERTEX( MakeD3DVECTOR(x+1, y+1, -z), n0, 1.0, 0.0 );
  Cube[2] := MakeD3DVERTEX( MakeD3DVECTOR(x,   y,   -z), n0, 0.0, 1.0 );
  Cube[3] := MakeD3DVERTEX( MakeD3DVECTOR(x+1, y,   -z), n0, 1.0, 1.0 );

  // Back face
  Cube[4] := MakeD3DVERTEX( MakeD3DVECTOR( x,  y+1, 0), n1, 1.0, 0.0 );
  Cube[5] := MakeD3DVERTEX( MakeD3DVECTOR( x,  y,   0), n1, 1.0, 1.0 );
  Cube[6] := MakeD3DVERTEX( MakeD3DVECTOR( x+1,y+1, 0), n1, 0.0, 0.0 );
  Cube[7] := MakeD3DVERTEX( MakeD3DVECTOR( x+1,y,   0), n1, 0.0, 1.0 );

  // Top face
  Cube[8] := MakeD3DVERTEX( MakeD3DVECTOR(  x,  y+1, 0), n2, 0.0, 0.0 );
  Cube[9] := MakeD3DVERTEX( MakeD3DVECTOR(  x+1,y+1, 0), n2, 1.0, 0.0 );
  Cube[10] := MakeD3DVERTEX( MakeD3DVECTOR( x,  y+1, -z), n2, 0.0, 1.0 );
  Cube[11] := MakeD3DVERTEX( MakeD3DVECTOR( x+1,y+1, -z), n2, 1.0, 1.0 );

  // Bottom face
  Cube[12] := MakeD3DVERTEX( MakeD3DVECTOR( x,   y, 0), n3, 0.0, 0.0 );
  Cube[13] := MakeD3DVERTEX( MakeD3DVECTOR( x,   y, -z), n3, 0.0, 1.0 );
  Cube[14] := MakeD3DVERTEX( MakeD3DVECTOR( x+1, y, 0), n3, 1.0, 0.0 );
  Cube[15] := MakeD3DVERTEX( MakeD3DVECTOR( x+1, y, -z), n3, 1.0, 1.0 );

  // Right face
  Cube[16] := MakeD3DVERTEX( MakeD3DVECTOR( x+1, y+1, -z), n4, 0.0, 0.0 );
  Cube[17] := MakeD3DVERTEX( MakeD3DVECTOR( x+1, y+1, 0), n4, 1.0, 0.0 );
  Cube[18] := MakeD3DVERTEX( MakeD3DVECTOR( x+1, y,   -z), n4, 0.0, 1.0 );
  Cube[19] := MakeD3DVERTEX( MakeD3DVECTOR( x+1, y,   0), n4, 1.0, 1.0 );

  // Left face
  Cube[20] := MakeD3DVERTEX( MakeD3DVECTOR( x, y+1, -z), n5, 1.0, 0.0 );
  Cube[21] := MakeD3DVERTEX( MakeD3DVECTOR( x, y,   -z), n5, 1.0, 1.0 );
  Cube[22] := MakeD3DVERTEX( MakeD3DVECTOR( x, y+1, 0), n5, 0.0, 0.0 );
  Cube[23] := MakeD3DVERTEX( MakeD3DVECTOR( x, y,   0), n5, 0.0, 1.0 );
end;


procedure TForm1.makeMat;
var
  i,j:integer;
begin
  for i:=1 to maxMat do
    for j:=1 to maxMat do
      makeCube1(matV[ ((i-1)*maxMat+j-1)*24],i-maxMat/2,j-maxMat/2,mat[i,j]);

end;


procedure Tform1.makeMat2;
var
  i,j:integer;
  last:single;


begin
  nbFaces:=0;

  for j:=1 to maxMat do
    begin
      last:=0;
      for i:=1 to maxMat do
        begin
          inc(nbfaces);
          if mat[i,j]>last
            then LeftFace(faces[nbfaces],i,j,j+1,-mat[i,j],-last)
            else RightFace(faces[nbfaces],i,j,j+1,-last,-mat[i,j]);
            inc(nbfaces);
          FrontFace(faces[nbfaces],i,i+1,j,j+1,-mat[i,j]);
          last:=mat[i,j];
        end;

      inc(nbfaces);
      if last>0
        then RightFace(faces[nbfaces],maxMat+1,j,j+1,-last,0)
        else LeftFace(faces[nbfaces],maxMat+1,j,j+1,0,-last)
    end;

  for i:=1 to maxMat do
    begin
      last:=0;
      for j:=1 to maxMat do
        begin
          inc(nbfaces);
          if mat[i,j]>last
            then BottomFace(faces[nbfaces],i,i+1,j,-mat[i,j],-last)
            else TopFace(faces[nbfaces],i,i+1,j,-last,-mat[i,j]);
          last:=mat[i,j];
        end;
      inc(nbfaces);
      if last>0
        then TopFace(faces[nbfaces],i,i+1,maxMat+1,-last,0)
        else BottomFace(faces[nbfaces],i,i+1,maxMat+1,0,-last);
    end;

  inc(nbfaces);
  BackFace(faces[nbfaces],1,maxMat+1,1,maxMat+1,0);
end;


procedure TForm1.DXDraw1InitializeSurface(Sender: TObject);
var
  vp: TD3DViewport7;
  mtrl: TD3DMaterial7;
  i,delta:integer;

begin
  FillChar(vp, SizeOf(vp), 0);
  vp.dwX := 0;
  vp.dwY := 0;
  vp.dwWidth := DXDraw1.SurfaceWidth;
  vp.dwHeight := DXDraw1.SurfaceHeight;
  vp.dvMinZ := 0.0;
  vp.dvMaxZ := 1.0;

  DXDraw1.D3DDevice7.SetViewport(vp);

  FillChar(mtrl, SizeOf(mtrl), 0);
  mtrl.ambient.r := 0.5;
  mtrl.ambient.g := 0.5;
  mtrl.ambient.b := 0.5;
  mtrl.diffuse.r := 0.5;
  mtrl.diffuse.g := 0.5;
  mtrl.diffuse.b := 0.5;
  mtrl.specular.r := 0.5;
  mtrl.specular.g := 0.5;
  mtrl.specular.b := 0.5;
  DXDraw1.D3DDevice7.SetMaterial( mtrl );
  DXDraw1.D3DDevice7.SetRenderState( D3DRENDERSTATE_AMBIENT, $ffffffff);
  {DXDraw1.D3DDevice7.SetRenderState( D3DRENDERSTATE_SPECULARMATERIALSOURCE, $ffffffff);}
  DXDraw1.D3DDevice7.SetRenderState( D3DRENDERSTATE_SHADEMODE,ord(D3Dshade_Flat));

  setFormProjection;

  MakeCUBE;
  makeMat;
  makeMat2;

  setFormLight;

  delta:=FTextureImage.width div 8;
  for i:=0 to 5 do
  begin
    FTextureImage.Canvas.Brush.Style := bsSolid;
    FTextureImage.Canvas.Brush.Color := Fcolor[i];
    FTextureImage.Canvas.Pen.Style := psSolid;
    FTextureImage.Canvas.Pen.Color := clBlack;
    FTextureImage.Canvas.Rectangle(i*delta, 0, (i+1)*delta, FTextureImage.Height);
  end;

  FTexture.Load;

end;

procedure Tform1.setFormProjection;
var
  matProj: TD3DMatrix;
begin
{
  FilLChar(matProj, SizeOf(matProj), 0);
  matProj._11 :=  2.0;
  matProj._22 :=  2.0;
  matProj._33 :=  1.0;
  matProj._34 :=  1.0;
  matProj._43 := -1.0;
}
  D3DUtil_SetProjectionMatrix(matProj, fFOV*pi/180, fAspect, fNearPlane, fFarPlane);
  DXDraw1.D3DDevice7.SetTransform( D3DTRANSFORMSTATE_PROJECTION, matProj );
end;

procedure Tform1.setFormLight;
var
  light:TD3Dlight7;
begin
  D3Dutil_InitLight(light,D3Dlight_directional,Xlight,Ylight,Zlight);
  DXDraw1.D3DDevice7.SetLight(0,light);
  DXDraw1.D3DDevice7.lightEnable(0,true);
end;

procedure Tform1.setView;
var
  matView, matWorld: TD3DMatrix;
  vFrom, vAt, vWorldUp: TD3DVector;
  alpha1,beta1:single;
begin
  vAt:=makeD3Dvector(0,0,0);
  alpha1:=pi/180*alpha;
  beta1:=pi/180*beta;
  Vfrom:=makeD3Dvector( Dist*cos(alpha1)*sin(beta1),
                        Dist*sin(alpha1),
                        -Dist*cos(alpha1)*cos(beta1)
                       );
  vWorldUp:=makeD3Dvector(0,1,0);

  D3DUtil_SetViewMatrix(matView,vFrom, vAt, vWorldUp);
  DXDraw1.D3DDevice7.SetTransform( D3DTRANSFORMSTATE_VIEW, matView);

  FillChar(matWorld, SizeOf(matWorld), 0);
  matWorld._11 :=  1;
  matWorld._22 :=  1;
  matWorld._33 :=  1;
  matWorld._44 :=  1;

  matWorld._41:=-maxmat/2-1;
  matWorld._42:=-maxmat/2-1;


  DXDraw1.D3DDevice7.SetTransform( D3DTRANSFORMSTATE_WORLD, matWorld);
end;

procedure Tform1.Display;
var
  r: TD3DRect;
  i:integer;
begin
  if not DXDraw1.CanDraw then Exit;

  setView;

  {  Clear Screen  }
  r.x1 := 0;
  r.y1 := 0;
  r.x2 := DXDraw1.SurfaceWidth;
  r.y2 := DXDraw1.SurfaceHeight;
  if DXDraw1.ZBuffer<>nil then
    DXDraw1.D3DDevice7.Clear(1, r, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, $000000, 1, 0)
  else
    DXDraw1.D3DDevice7.Clear(1, r, D3DCLEAR_TARGET, $000000, 1, 0);

  { Draw Screen }
  asm FINIT end;
  DXDraw1.D3DDevice7.BeginScene;

  DXDraw1.D3DDevice7.SetTexture( 0, FTexture.Surface.IDDSurface7);
  {
  DXDraw1.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, cube[0], 4, 0);
  DXDraw1.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, cube[4], 4, 0);
  DXDraw1.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, cube[8], 4, 0);
  DXDraw1.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, cube[12], 4, 0);
  DXDraw1.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, cube[16], 4, 0);
  DXDraw1.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, cube[20], 4, 0);
  }
  {
  for i:=0 to maxmat*maxmat*6-1 do
    DXDraw1.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, matV[i*4], 4, 0);
  }
  {
  for i:=1 to nbfaces do
    DXDraw1.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, faces[i], 4, 0);
  }
  DXDraw1.D3DDevice7.DrawPrimitive(D3DPT_TRIANGLESTRIP, D3DFVF_VERTEX, faces[1], 4*nbFaces, 0);

  DXDraw1.D3DDevice7.EndScene;
  asm FINIT end;

  DXDraw1.Flip(false);
end;

procedure TForm1.sbAlphaScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  alpha:=x;
  Lalpha.caption:='Alpha='+Estr(alpha,1);
  Display;
end;

procedure TForm1.sbBetaScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  beta:=x;
  Lbeta.caption:='Beta='+Estr(Beta,1);
  Display;
end;

procedure TForm1.sbDistScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  Dist:=x;
  LDist.caption:='D='+Estr(Dist,1);
  Display;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i,j:integer;
  st:string;
begin
  dist:=10;
  sbAlpha.setParams(alpha,-90,90);
  sbBeta.setParams(Beta,-180,180);
  sbDist.setParams(Dist,1,100);

  Lalpha.caption:='Alpha='+Estr(alpha,1);
  Lbeta.caption:='Beta='+Estr(Beta,1);
  LDist.caption:='D='+Estr(Dist,1);

  Zlight:=-10;

  sblightX.setParams(Xlight,-100,100);
  sblightY.setParams(Ylight,-100,100);
  sblightZ.setParams(Zlight,-100,100);

  LlightX.caption:='Spot X='+Estr(Xlight,1);
  LlightY.caption:='Spot Y='+Estr(Ylight,1);
  LlightZ.caption:='Spot Z='+Estr(Zlight,1);

  fFOV:=45;
  fAspect:=1;
  fNearPlane:=1;
  fFarPlane:=100;

  sbfov.setParams(fFov,5,90);

  Lfov.caption:='FOV='+Estr(fFov,1);

  st:='';
  for i:=1 to maxMat do
    for j:=1 to maxMat do
      begin
        mat[i,j]:=1+random(5);
        st:=st+Istr(mat[i,j])+' ';
      end;

  Fcolor[0]:=rgb(255,0,0);
  Fcolor[1]:=rgb(0,255,0);
  Fcolor[2]:=rgb(0,0,255);
  Fcolor[3]:=rgb(255,255,0);
  Fcolor[4]:=rgb(0,255,255);
  Fcolor[5]:=rgb(255,0,255);

end;

procedure TForm1.sbLightXScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  Xlight:=x;
  LlightX.caption:='Spot X='+Estr(x,1);
  setFormLight;
  Display;
end;

procedure TForm1.sbLightYScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  Ylight:=x;
  LlightY.caption:='Spot Y='+Estr(x,1);
  setFormLight;
  Display;
end;

procedure TForm1.sbLightZScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  Zlight:=x;
  LlightZ.caption:='Spot Z='+Estr(x,1);
  setFormLight;
  Display;
end;

procedure TForm1.sbFovScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  fFov:=x;
  Lfov.caption:='Fov='+Estr(x,1);
  setFormProjection;
  Display;
end;

procedure TForm1.DXDraw1Initialize(Sender: TObject);
begin
  FTextureImage := TDIB.Create;
  FTextureImage.PixelFormat := MakeDIBPixelFormat(8, 8, 8);
  FTextureImage.SetSize(256, 256, 24);

  FTexture := TDirect3DTexture2.Create(DXDraw1, FTextureImage, False);
end;

procedure TForm1.DXDraw1Finalize(Sender: TObject);
begin
  FTexture.Free; FTexture := nil;
  FTextureImage.Free; FTextureImage := nil;
end;

end.
