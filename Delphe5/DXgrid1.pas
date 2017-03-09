unit DXgrid1;

interface

uses windows,DXTypes, Direct3D9G, D3DX9G,
     util1, stmObj;


type
  TmatInf3D=record
              D0,Fov:single;
              thetaX,thetaY,thetaZ:single;
              mode:byte;
            end;


type
  TDXgridVertex=
    record
      position:TD3DVECTOR ;
      normal:  TD3DVECTOR ;
      color:TD3DCOLOR;
    end;
const
  DXgridFormat=D3DFVF_XYZ or D3DFVF_NORMAL or D3DFVF_DIFFUSE;

{ TDXgrid permet d'afficher une matrice
  initData remplit le tableau Vertex
  Il faut appeler freeData à chaque fois que les données de la matrice sont modifiées

  InitResources construit le vertex buffer sur la carte graphique
  Il faut appeler FreeResources à chaque fois que ce buffer doit être reconstruit.

}
type
  TDXgrid= class
           private
             I1,I2,J1,J2: integer;
             Dx3D, x03D, Dy3D, y03D: single;

             vertex: array of TDXgridVertex;
             VB: Idirect3DVertexBuffer9;

             Material: TD3DMATERIAL9 ;
             LightDir: TD3DXVECTOR3;
             light: TD3DLIGHT9;


           public
             constructor create;

             procedure initData( mat1:TypeUO);
             procedure FreeData;

             procedure InitResources(Idevice: IDirect3DDevice9);
             procedure freeResources;

             procedure render(Idevice: IDirect3DDevice9);

             procedure Display(Idevice: IDirect3DDevice9; mat1: TypeUO);
           end;

implementation

{ TDXgrid }

uses stmMat1;


constructor TDXgrid.create;
begin
  fillchar(material, SizeOf(material),0);
  material.Diffuse.r := 1.0; material.Ambient.r := 1.0;
  material.Diffuse.g := 1.0; material.Ambient.g := 1.0;
  material.Diffuse.b := 0.0; material.Ambient.b := 0.0;
  material.Diffuse.a := 1.0; material.Ambient.a := 1.0;

  fillchar(light, sizeof(light),0);
  light._Type := D3DLIGHT_DIRECTIONAL;
  light.Diffuse.r := 1;
  light.Diffuse.g := 1;
  light.Diffuse.b := 1;

  light.ambient.r := 0.2;
  light.ambient.g := 0.2;
  light.ambient.b := 0.2;

  LightDir:= D3DXVector3(-1,-1,0 );
  D3DXVec3Normalize(light.Direction, LightDir);
  light.Range := 1000;

end;

procedure TDXgrid.display(Idevice: IDirect3DDevice9; mat1:typeUO);
var
  mat: Tmatrix absolute mat1;
  ViewPort: TD3DVIEWPORT9;

  res:longword;
  vEyePt, vLookatPt, vUpVec, CG: TD3DVector;
  Amat,matX,matZ: TD3Dmatrix;
  matWorld,matView,matProj: TD3Dmatrix;


  Kf:single;
begin

  with mat do
  begin
    Kf:=(Xmax-Xmin+ Ymax-Ymin )/2;          // largeur moyenne de l'objet
    CG.x:=(Xmin+Xmax)/2;
    CG.y:=(Ymin+Ymax)/2;
    CG.z:=(Zmin+Zmax)/2;
  end;


  Idevice.GetViewport (Viewport);

  Idevice.Clear(0, nil, D3DCLEAR_TARGET or D3DCLEAR_ZBUFFER, D3Dcolor_XRGB(0,0,0), 1, 0);


  IDevice.SetMaterial(Material);
  IDevice.SetLight(0, Light);

  IDevice.LightEnable(0, TRUE);
  IDevice.SetRenderState(D3DRS_LIGHTING, iTrue);
  IDevice.SetRenderState(D3DRS_AMBIENT, $00808080);

  D3DXMatrixTranslation(matWorld,-CG.x,-CG.y,-CG.z);
  
  with mat do
  if Zmin<>Zmax then
  begin
    D3DXMatrixScaling(Amat,1,1, Kf/(Zmax-Zmin)*100/inf3D.D0 );
    D3DXMatrixMultiply(matWorld,matWorld,Amat);
  end;

  D3DXMatrixRotationZ(Amat, mat.inf3D.thetaZ*pi/180);
  D3DXMatrixMultiply(matWorld,matWorld,Amat);

  D3DXMatrixRotationY(Amat, mat.inf3D.thetaX*pi/180);
  D3DXMatrixMultiply(matWorld,matWorld,Amat);

  IDevice.SetTransform(D3DTS_WORLD, matWorld);

  vEyePt:=    D3DXVector3(mat.inf3D.D0/100*Kf,0,0);
  vLookatPt:= D3DXVector3zero;
  vUpVec:=    D3DXVector3(0, 0, 1);
  D3DXMatrixLookAtRH(matView, vEyePt, vLookatPt, vUpVec);
  IDevice.SetTransform(D3DTS_VIEW, matView);

  D3DXMatrixPerspectiveFovRH(matProj, mat.inf3D.Fov *pi/180, viewport.width/ viewPort.Height, 1, 1000);
  IDevice.SetTransform(D3DTS_PROJECTION, matProj);
  IDevice.SetRenderState(D3DRS_SHADEMODE, D3DSHADE_FLAT);

  if (SUCCEEDED(Idevice.BeginScene)) then
  begin
   try
      render(Idevice);
    finally
      Idevice.EndScene;
    end;
  end;
end;

procedure TDXgrid.initData(mat1:TypeUO);
var
  i,j,n:integer;
  normx, normy, normz, normx1, normy1, normz1: TD3DVector;
  norm: TD3DVector;
  mat: Tmatrix absolute mat1;
  Vmin,Vmax:float;
  col:integer;

function convx3D(i:integer):single;
begin
  result:=Dx3D*i+x03D;
end;

function convy3D(i:integer):single;
begin
  result:=Dy3D*i+y03D;
end;

function get3DV(i,j:integer):single;
begin
  with mat do
  begin
    if inverseX then i:=I2+I1-i;
    if inverseY then j:=J2+J1-j;

    result:=getSmoothVal(i,j);
  end;
end;

procedure setVertex(i,j:integer;z:single;n:TD3Dvector;col:longword);
begin
  setlength(Vertex, length(Vertex)+1);
  with Vertex[length(Vertex)-1] do
  begin
    position := D3DXVECTOR3( convx3D(i),convy3D(j), z );
    normal   := n;
    color    := $FF000000 or col;
  end;
end;



begin
  if length(vertex)>0 then exit;

  VB:=nil;

  with Tmatrix(mat1) do
  begin
    I1:= Istart;
    J1:= Jstart;
    case visu.modeMat of
      0:    begin
              I2:=Iend;
              J2:=Jend;
              dx3D:=dxu;
              x03D:=x0u;
              dy3D:=dyu;
              y03D:=y0u;
            end;
      1,2:  begin
              I2:=Istart+(Iend-Istart+1)*3-1;
              J2:=Jstart+(Jend-Jstart+1)*3-1;
              dx3D:=dxu/3;
              x03D:=x0u + 2/3*Dxu;
              dy3D:=dyu/3;
              y03D:=y0u + 2/3*Dyu;;
            end;
    end;
  end;

  setLength(vertex,0);

  normx :=  D3DXVector3( 1 ,0, 0 );
  normx1 := D3DXVector3(-1 ,0, 0 );
  normy :=  D3DXVector3( 0, 1, 0 );
  normy1 := D3DXVector3( 0,-1, 0 );
  normz :=  D3DXVector3( 0, 0, 1 );
  normz1 := D3DXVector3( 0, 0,-1 );

  for j:=J1 to J2 do
  for i:=I1 to I2 do
  begin
    col:=random(256)*65536 +random(256)*256 +random(256)  ;
    //col:= rgb(128,128,128);
    setvertex(i,j,get3DV(i,j),normz, col);           //1
    setvertex(i,j+1,get3DV(i,j),normz, col);         //2
    setvertex(i+1,j,get3DV(i,j),normz, col);         //3

    setvertex(i+1,j+1,get3DV(i,j),normz, col);       //4
    setvertex(i+1,j,get3DV(i,j),normz, col);         //3
    setvertex(i,j+1,get3DV(i,j),normz,col);          //2

    if i<I2 then
    begin
      if get3DV(i+1,j)<get3DV(i,j) then Norm:=normx else Norm:=normx1;
      col:=random(256)*65536 +random(256)*256 +random(256)  ;

      setvertex(i+1,j,get3DV(i,j),norm,col);        //3
      setvertex(i+1,j+1,get3DV(i,j),norm,col);      //4
      setvertex(i+1,j,get3DV(i+1,j),norm,col);      //5

      setvertex(i+1,j+1,get3DV(i+1,j),norm,col);    //6
      setvertex(i+1,j,get3DV(i+1,j),norm,col);      //5
      setvertex(i+1,j+1,get3DV(i,j),norm,col);      //4
    end;

    if j<J2 then
    begin
      if get3DV(i,j+1)<get3DV(i,j) then Norm:=normy else Norm:=normy1;
      col:=random(256)*65536 +random(256)*256 +random(256)  ;

      setvertex(i+1,j+1,get3DV(i,j),norm,col);     //4
      setvertex(i,j+1, get3DV(i,j), norm,col);     //2
      setvertex(i+1,j+1, get3DV(i,j+1), norm,col); //6

      setvertex(i+1,j+1, get3DV(i,j+1), norm,col); //6
      setvertex(i,j+1, get3DV(i,j), norm,col);     //2
      setvertex(i,j+1, get3DV(i,j+1), norm,col);   //9
    end;
  end;

end;

procedure TDXgrid.InitResources(Idevice: IDirect3DDevice9);
var
  pVertices: pointer;
begin
  if VB<>nil then exit;

  if IDevice.CreateVertexBuffer( sizeof(TDXgridVertex)*length(Vertex),
                                    0, DXgridFormat ,
                                    D3DPOOL_DEFAULT, VB, nil )<>0 then exit;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then Exit;
  CopyMemory(pVertices, @vertex[0], SizeOf(TDXgridVertex)*length(vertex));
  VB.Unlock;
end;


procedure TDXgrid.FreeData;
begin
  setLength(vertex,0);
  FreeResources;
end;



procedure TDXgrid.render(Idevice: IDirect3DDevice9);
var
  i,j,N, res:integer;
begin
  res:=IDevice.SetStreamSource(0, VB, 0, SizeOf(TDXgridVertex));
  if res<>0 then exit;

  res:=IDevice.SetFVF(DXgridFormat);
  if res<>0 then exit;

  N:= length(vertex);
  IDevice.DrawPrimitive( D3DPT_TRIANGLELIST, 0, N div 3 );

end;



procedure TDXgrid.freeResources;
begin
  VB:=nil;
end;



end.
