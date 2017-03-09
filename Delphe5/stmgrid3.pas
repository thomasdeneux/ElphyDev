unit stmGrid3;

{ janvier 2004: TgridEx est utilisée par stmDN2 , stmDNter1 et stmPlayGrid1

  obvisA est un tableau 2D de pointeurs non controlés. Il doit être rempli par l'objet
  appelant avant l'animation.
}

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,
     util1,debug0,
     stmdef,stmObj,
     {$IFDEF DX11}
     {$ELSE}
     DXTypes, Direct3D9G, D3DX9G,
     {$ENDIF}
     stmObv0;

type
  TgridEx=class(Tresizable)
            nX,nY:smallInt;

            GridCol: array of array of integer;


            constructor create;override;
            class function STMClassName:AnsiString;override;


            procedure initGrille(deg1:typeDegre;nbx,nby:integer);

            procedure BuildResource;override;
            procedure freeBM;override;
            procedure afficheS;override;

            destructor destroy;override;

          end;


implementation


{*********************   Méthodes de TgridEx   ***************************}


constructor TgridEx.create;
begin
  inherited create;
end;



procedure TgridEx.initGrille(deg1:typeDegre;nbx,nby:integer);
var
  i,j:integer;
begin

  deg:=deg1;
  degToPoly(deg,poly);


  nx:=nbx;
  ny:=nby;

  BuildResource;


  setLength(GridCol,nbX,nbY);

end;


class function TgridEx.STMClassName:AnsiString;
  begin
    STMClassName:='Grid';
  end;


Type
  TgridVertex = packed record
    x, y, z: Single; // The untransformed position for the vertex
    color: DWORD;    // The vertex color
  end;

  TgridVertexArray = Array[0..1000] of TgridVertex;
  PgridVertexArray = ^TGridVertexArray;

const
  GridVertexCte = D3DFVF_XYZ or D3DFVF_DIFFUSE;


procedure TgridEx.BuildResource;
var
  vertices: array of TgridVertex;
  i,j,col:integer;
  up: boolean;
  NVmax: integer;
  NV2:integer;
  xG,yG,dxG,dyG:single;

  pVertices: Pointer;

  procedure store(i,j,col: integer);
  begin
    with vertices[NV2] do
    begin
      x:=xG + dxG*i;
      y:=yG + dyG*j;
      z:=0;
      color:=  col;
    end;
    inc(NV2);
  end;

begin
  NVmax:=(Nx+2)*(Ny+1)*4;
  setLength(vertices,NVmax);

  xG:=-0.5;
  yG:=-0.5;

  dxG:=1/Nx;
  dyG:=1/Ny;

  NV2:=0;

  for j:=0 to Ny-1 do
  begin
    for i:=0 to Nx-1 do
    begin
      if (i=0) and (j<>0) then
      begin
        store(Nx,j+1,col);
        store(0,j+1,col);
      end;
      store(i,j+1,col);
      store(i,j,col);
      store(i+1,j+1,col);
      store(i+1,j,col);
    end;
  end;

  VB:=nil;
  if DXscreen.IDevice.CreateVertexBuffer(SizeOf(TgridVertex)*NV2, 0, GridVertexCte, D3DPOOL_DEFAULT, VB, nil)<>0 then Exit;

  if FAILED(VB.Lock(0, 0, pVertices, 0)) then Exit;
  CopyMemory(pVertices, @vertices[0], SizeOf(TgridVertex)*NV2);
  VB.Unlock;

end;

procedure TgridEx.freeBM;
begin
  inherited;

  VB:=nil;
end;

procedure TgridEx.afficheS;
var
  mat,mTrans, mRot, mScale: TD3DMatrix;
  res:integer;
  pVertices: PgridVertexArray;
  i,j,k: integer;
  NV: integer;
begin

  if (DXscreen=nil) or not DXscreen.candraw then exit;
  if VB=nil then exit;

  if FAILED(VB.Lock(0, 0, pointer(pVertices), 0)) then Exit;

  NV:=0;
  for j:=0 to Ny-1 do
  begin
    for i:=0 to Nx-1 do
    begin
      if (i=0) and (j<>0) then
      begin
        inc(NV,2);
      end;
      for k:=NV to NV+3 do pVertices^[k].color:=GridCol[i,j];
      inc(NV,4);
    end;
  end;

  VB.Unlock;

  DXscreen.IDevice.SetRenderState(D3DRS_CULLMODE, {D3DCULL_NONE} D3DCULL_CW );
  with deg do
  begin
    D3DXMatrixScaling(mScale,dx,dy,1);
    D3DXMatrixTranslation(mTrans,x,y,0);
    D3DXMatrixRotationZ(mRot, theta*pi/180);
    D3DXMatrixMultiply(mat,mScale,mRot);
    D3DXMatrixMultiply(mat,mat,mTrans);

    res:=DXscreen.IDevice.SetTransform(D3DTS_WORLD, mat);

    DXscreen.Idevice.SetTextureStageState(0, D3DTSS_COLOROP,   D3DTOP_DISABLE);

    res:=DXscreen.IDevice.SetStreamSource(0, VB, 0, SizeOf(TgridVertex));
    res:=DXscreen.IDevice.SetFVF(GridVertexCte);
    res:=DXscreen.IDevice.DrawPrimitive(D3DPT_TRIANGLESTRIP, 0, NV-2 );
  end;
  DXscreen.IDevice.SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
end;


destructor TgridEx.destroy;
begin
  inherited destroy;
end;

end.
