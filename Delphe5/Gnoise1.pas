unit GNoise1;

{ Bruits utilisés par stmRev1, stmDN2, stmDNter1, stmGaborDense1

  Tous les indices commencent à zéro.

  TBBnoise est le bruit historique des m-séquences
    f renvoie -1 ou +1
    getState renvoie 0 ou 1

  TBBnoise1 est le bruit utilisé par Olivier dans GaborNoise
    f renvoie 0 à  Nmax-1
    getState renvoie 0 à Nmax-1

  TXYnoise est le bruit utilisé par DenseNoise
    f renvoie -1 où +1
    getState renvoie 0 ou 1

  TXYnoise1 est le bruit utilisé par TMNoise
    f renvoie -Nmax div 2 où +Nmax div 2
    getState renvoie 0 à Nmax-1

}

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses util1, D7random1;
                                                                                                                
type
  TgridNoise=class
               Nx,Ny,seed,tmax:integer;

               constructor create(Nx1,Ny1,seed1,tmax1:integer);
               procedure modify(Nx1,Ny1,seed1,tmax1:integer);virtual;

               function f(x,y,t:integer):integer;virtual;
               function getState(x,y,t:integer):integer;virtual;
               procedure setState(x,y,t,w:integer);virtual;
               procedure getTimeVector(x,y,t:integer;vec:Ptabsingle;nb:integer);virtual;

               property State[x,y,t:integer]:integer read getState write setState;
             end;

  TBBNoise=  class(TgridNoise)
               lgBB:integer;
               BB:array of shortInt;
               pseq:integer;

               constructor create(Nx1,Ny1,seed1,tmax1:integer);
               procedure modify(Nx1,Ny1,seed1,tmax1:integer);override;

               function f(x,y,t:integer):integer;override;
               function getState(x,y,t:integer):integer;override;
               procedure getTimeVector(x,y,t:integer;vec:Ptabsingle;nb:integer);override;
             end;

 TBBNoise1=  class(TgridNoise)
               lgBB:integer;
               BB:array of shortInt;
               pseq:integer;
               Nmax:integer;

               constructor create(Nx1,Ny1,Nmax1,seed1,tmax1:integer);
               procedure modify(Nx1,Ny1,seed1,tmax1:integer);override;

               function f(x,y,t:integer):integer;override;
               function getState(x,y,t:integer):integer;override;
               procedure getTimeVector(x,y,t:integer;vec:Ptabsingle;nb:integer);override;
             end;


  TXYNoise=  class(TgridNoise)
               G0:array of array of array of shortint;

               constructor create(Nx1,Ny1,seed1,tmax1:integer; const FillG0:boolean=true);overload;
               constructor create(Nx1,Ny1,seed1,tmax1,Nx2,Ny2:integer);overload;

               procedure modify(Nx1,Ny1,seed1,tmax1:integer);override;

               function f(x,y,t:integer):integer;override;
               procedure getTimeVector(x,y,t:integer;vec:Ptabsingle;nb:integer);override;
               function getState(x,y,t:integer):integer;override;
               procedure setState(x,y,t,w:integer);override;
             end;

  TXYNoise1=  class(TXYNoise)
               Bmin,Bmax:integer;
               constructor create(Nx1,Ny1,Bmin1,Bmax1,seed1,tmax1:integer; const FillG0:boolean=true);
               procedure modify(Nx1,Ny1,seed1,tmax1:integer);override;
               function getState(x,y,t:integer):integer;override;
               procedure setState(x,y,t,w:integer);override;
             end;


  TseqElt=   record
                X,Y,Z,FP: byte;  { 0 à n-1 }
              end;

  TrevNoise= class(TgridNoise)
               G0:array of TseqElt;
               Nz:integer;
               constructor create(Nx1,Ny1,Nz1,seed1:integer);
               function getState(x1,y1,t1:integer):integer;override;
               procedure setState(x,y,t,w:integer);override;
               function f(x,y,t:integer):integer;override;
             end;


implementation

{ TgridNoise }

constructor TgridNoise.create(Nx1, Ny1, seed1,tmax1: integer);
begin
  Nx:=Nx1;
  Ny:=Ny1;
  seed:=seed1;
  tmax:=tmax1;
end;

procedure TgridNoise.modify(Nx1, Ny1, seed1,tmax1: integer);
begin
  Nx:=Nx1;
  Ny:=Ny1;
  seed:=seed1;
  tmax:=tmax1;
end;

function TgridNoise.f(x, y, t: integer): integer;
begin
end;

procedure TgridNoise.getTimeVector(x, y, t: integer; vec: Ptabsingle; nb: integer);
begin
end;

function TgridNoise.getState(x,y,t:integer):integer;
begin
end;

procedure TgridNoise.setState(x,y,t,w:integer);
begin
end;

{ TBBNoise }

constructor TBBNoise.create(Nx1, Ny1, seed1,tmax1: integer);
var
  i:integer;
begin
  inherited;

  tmax:=maxEntierLong;
  lgBB:=65536;
  setLength(bb,lgBB);

  GsetRandSeed(seed);
  for i:=0 to lgBB-1 do
    bb[i]:=Grandom(2)*2-1;

  if nx*ny<>0
    then pseq:=lgBB div (nx*ny)
    else pseq:=1;
end;

procedure TBBNoise.modify(Nx1, Ny1, seed1,tmax1: integer);
var
  i:integer;
begin
  Nx:=Nx1;
  Ny:=Ny1;
  if nx*ny<>0
    then pseq:=lgBB div (nx*ny)
    else pseq:=1;

  if seed1<>seed then
  begin
    seed:=seed1;
    GsetRandSeed(seed);
    for i:=0 to lgBB-1 do
      bb[i]:=Grandom(2)*2-1;
  end;
end;


function TBBNoise.f(x, y, t: integer): integer;
begin
  result:=BB[(t+(x+nx*y)*pseq +lgBB) mod lgBB];
end;

procedure TBBNoise.getTimeVector(x, y, t: integer; vec: Ptabsingle; nb: integer);
var
  i,k1:integer;
begin
  k1:=t+(x+nx*y)*pseq +lgBB;
  for i:=0 to nb-1 do
    vec^[i]:=BB[(k1+i) mod lgBB];
end;

function TBBNoise.getState(x,y,t:integer):integer;
begin
  result:=(f(x,y,t)+1) div 2;
end;



{ TBBNoise1 }

constructor TBBNoise1.create(Nx1, Ny1,Nmax1, seed1,tmax1: integer);
var
  i:integer;
begin
  inherited create(Nx1,Ny1,seed1,tmax1);

  Nmax:=Nmax1;
  tmax:=maxEntierLong;
  lgBB:=65536;
  setLength(bb,lgBB);

  GsetRandSeed(seed);
  for i:=0 to lgBB-1 do
    bb[i]:=Grandom(Nmax);
  if nx*ny<>0
    then pseq:=lgBB div (nx*ny)
    else pseq:=1;
end;

procedure TBBNoise1.modify(Nx1, Ny1, seed1,tmax1: integer);
var
  i:integer;
begin
  Nx:=Nx1;
  Ny:=Ny1;
  if nx*ny<>0
    then pseq:=lgBB div (nx*ny)
    else pseq:=1;

  if seed1<>seed then
  begin
    seed:=seed1;
    GsetRandSeed(seed);
    for i:=0 to lgBB-1 do
      bb[i]:=Grandom(Nmax);
  end;
end;


function TBBNoise1.f(x, y, t: integer): integer;
begin
  result:=BB[(t+(x+nx*y)*pseq +lgBB) mod lgBB];
end;

procedure TBBNoise1.getTimeVector(x, y, t: integer; vec: Ptabsingle; nb: integer);
var
  i,k1:integer;
begin
  k1:=t+(x+nx*y)*pseq +lgBB;
  for i:=0 to nb-1 do
    vec^[i]:=BB[(k1+i) mod lgBB];
end;

function TBBNoise1.getState(x,y,t:integer):integer;
begin
  result:=f(x,y,t);
end;


{ TXYNoise }

constructor TXYNoise.create(Nx1, Ny1, seed1,tmax1: integer; const FillG0:boolean=true);
var
  i,j,k:integer;
begin
  inherited create(Nx1, Ny1, seed1,tmax1);
  setLength(G0,Nx1,Ny1,tmax1);

  if FillG0 then
  begin
    GsetRandSeed(seed);
    for i:=0 to Nx-1 do
    for j:=0 to Ny-1 do
    for k:=0 to tmax-1 do
      G0[i,j,k]:=Grandom(2)*2-1;
  end;
end;

constructor TXYNoise.create(Nx1,Ny1,seed1,tmax1,Nx2,Ny2:integer);
var
  i,j,k:integer;
  gdum:array of array of shortint;
begin
  inherited create(Nx1,Ny1,seed1,tmax1);
  setLength(G0,Nx1,Ny1,tmax1);
  setLength(Gdum,Nx2,Ny2);

  GsetRandSeed(seed);
  for k:=0 to tmax-1 do
  begin
    for i:=0 to Nx2-1 do
    for j:=0 to Ny2-1 do
      Gdum[i,j]:=Grandom(2)*2-1;

    for i:=0 to Nx-1 do
    for j:=0 to Ny-1 do
      G0[i,j,k]:=Gdum[Grandom(Nx2),Grandom(Ny2)];
  end;
end;


function TXYNoise.f(x, y, t: integer): integer;
begin
  if (t>=0) and (t<tmax)
    then result:=G0[x,y,t]
    else result:=0;

end;

function TXYNoise.getState(x,y,t:integer):integer;
begin
  result:=(f(x,y,t)+1) div 2;
end;

procedure TXYNoise.setState(x,y,t,w:integer);
begin
  g0[x,y,t]:=w;
end;


procedure TXYNoise.getTimeVector(x, y, t: integer; vec: Ptabsingle;
  nb: integer);
var
  i,k:integer;
begin
  for i:=0 to nb-1 do vec^[i]:=f(x,y,t+i);

end;

procedure TXYNoise.modify(Nx1, Ny1, seed1,tmax1: integer);
var
  i,j,k:integer;

begin
  if (Nx<>Nx1) or (Ny<>Ny1) or (seed<>seed1) or (tmax1<>tmax) then
  begin
    Nx:=Nx1;
    Ny:=Ny1;
    seed:=seed1;
    tmax:=tmax1;

    setLength(G0,Nx1,Ny1,tmax1);

    GsetRandSeed(seed);
    for i:=0 to Nx-1 do
    for j:=0 to Ny-1 do
    for k:=0 to tmax-1 do
      G0[i,j,k]:=Grandom(2)*2-1;

  end;


 {   then create(Nx1,Ny1,seed1,tmax1);  }
 // Forme interdite par XE3

end;

{ TXYNoise1 }

constructor TXYNoise1.create(Nx1, Ny1, Bmin1, Bmax1, seed1,tmax1: integer; const FillG0:boolean=true);
var
  i,j,k:integer;
  N:integer;
begin
  inherited create(Nx1, Ny1, seed1,tmax1,false);
  setLength(G0,Nx1,Ny1,tmax1);
  Bmin:=Bmin1;
  Bmax:=Bmax1;

  if FillG0 then
  begin
    N:=Bmax-Bmin+1;
    GsetRandSeed(seed);
    for i:=0 to Nx-1 do
    for j:=0 to Ny-1 do
    for k:=0 to tmax-1 do
      G0[i,j,k]:=Grandom(N)+Bmin;
  end;
end;


procedure TXYNoise1.modify(Nx1, Ny1, seed1,tmax1: integer);
var
  i,j,k:integer;
  N:integer;
begin
  if (Nx<>Nx1) or (Ny<>Ny1) or (seed<>seed1) or (tmax1<>tmax) then
  begin
    Nx:=Nx1;
    Ny:=Ny1;
    seed:=seed1;
    tmax:=tmax1;

    setLength(G0,Nx1,Ny1,tmax1);

    N:=Bmax-Bmin+1;
    GsetRandSeed(seed);
    for i:=0 to Nx-1 do
    for j:=0 to Ny-1 do
    for k:=0 to tmax-1 do
      G0[i,j,k]:=Grandom(N)+Bmin;
  end;
{
    then create(Nx1,Ny1,Bmin,Bmax,seed1,tmax1);
     // Forme interdite par XE3
}
end;

function TXYNoise1.getState(x,y,t:integer):integer;
begin
  result:=f(x,y,t)-Bmin;
end;

procedure TXYNoise1.setState(x,y,t,w:integer);
begin
  g0[x,y,t]:=w;
end;



{ TrevNoise }

constructor TrevNoise.create(Nx1, Ny1, Nz1, seed1: integer);
var
  i,j:integer;
  x1,y1,z1:integer;
  elt:TSeqElt;
begin
  nz:=nz1;
  inherited create(Nx1,Ny1,seed1,Nx1*Ny1*Nz1);

  setLength(G0,tmax+1);

  i:=0;
  for x1:=0 to nx-1 do
  for y1:=0 to ny-1 do
  for z1:=0 to nz-1 do
  with G0[i] do
  begin
    x:=x1;
    y:=y1;
    z:=z1;
    FP:=0;
    inc(i);
  end;

  GsetRandSeed (Seed);

  for i:=0 to tmax do
  begin
    j:=Grandom(tmax+1);
    elt:=G0[i];
    G0[i]:=G0[j];
    G0[j]:=elt;
  end;

end;

function TrevNoise.f(x, y, t: integer): integer;
begin
  result:=getState(x,y,t);
end;

function TrevNoise.getState(x1, y1, t1: integer): integer;
begin
  if (t1>=0) and (t1<=tmax) then
  with G0[t1] do
  if (x=x1) and (y=y1)
    then result:=z
    else result:=Nz
  else result:=Nz;
end;

procedure TrevNoise.setState(x,y,t,w:integer);
begin
end;


end.

