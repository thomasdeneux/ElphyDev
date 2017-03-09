unit ReducStim1;

interface
uses windows, classes,
     ippdefs,ipps,
     util1;


procedure getMask(mask: PtabSingle;Ni,Nj:integer; xp,yp: TarrayOfInteger; mat,tbS:PtabSingle;Nx,Ny, SSwidth: integer);

implementation

uses syspal32, ncdef2,stmPG;



procedure getMask(mask: PtabSingle;Ni,Nj:integer; xp,yp: TarrayOfInteger; mat,tbS:PtabSingle;Nx,Ny, SSwidth: integer);
var
  i,k:integer;

function getDotProd(i0,j0:integer): single;
var
  res: integer;
  j:integer;
  w:single;
begin
  result:=0;
  for j:=0 to Nj-1 do
  begin
    res:= IppsDotProd_32f(@tbS^[(j0+j)*SSwidth+i0],@mask[j*Ni], Ni, @w);
    result:=result+w;
  end;
end;

begin
  k:=0;
  for i:=0 to Nx*Ny-1 do
  begin
    mat^[k]:= syspal.PixToLum( getDotProd(Xp[k],Yp[k]));
    inc(k);
  end;
end;



end.
