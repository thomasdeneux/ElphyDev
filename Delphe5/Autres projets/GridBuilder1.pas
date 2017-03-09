unit GridBuilder1;

interface

uses util1, FdefDac2;

type
  TBuildGrid=class
               Npos:integer; { Nombre de positions }
               Memory:integer; { Memoire du système }
               maxLength:integer;
               maxGrid:integer;
               grid:array of smallint;                { suite de grilles}
               sum,newSum:array of array of array of single; { sum[p1,p2,tau] }

               function getSM(p,t:integer):integer;

               property SM[p,t:integer]:integer read getSM;
               constructor create(nb,m0,maxL:integer);
               procedure addGrid(num:integer);
               procedure addGridRandom(num:integer);
               procedure calcul;

               procedure normalize;
               procedure WriteSums;
             end;

procedure TestBuildGrid;

implementation

{ TBuildGrid }

constructor TBuildGrid.create(nb, m0, maxL: integer);
var
  i:integer;
begin
  Npos:=nb;
  memory:=m0;
  maxLength:=maxL;

  maxGrid:=1;
  for i:=1 to Nb do maxGrid:=maxGrid*2;

  setLength(sum,Nb,Nb,m0);
  setLength(Newsum,Nb,Nb,m0);

  setLength(grid,maxLength);

end;

procedure TBuildGrid.addGridRandom(num:integer);
var
  p1,p2,tau:integer;
begin
  grid[num]:=random(maxGrid-1)+1;

  for p1:=0 to npos-1 do
  for p2:=0 to npos-1 do
  for tau:=0 to memory-1 do
  begin
    Sum[p1,p2,tau]:=Sum[p1,p2,tau]+SM[p1,num]*SM[p2,num-tau];
  end;
end;

procedure TBuildGrid.AddGrid(num:integer);
var
  eval,maxSum:double;
  g,g0,p1,p2,tau:integer;
  nbS:integer;
begin
  Eval:=1E20;

  for g:=1 to maxGrid-1 do
  begin
    grid[num]:=g;

    maxSum:=0;
    nbS:=0;
    for p1:=0 to npos-1 do
    for p2:=0 to npos-1 do
    for tau:=0 to memory-1 do
    if (p1<>p2) or (tau>0) then
    begin
      maxSum:=maxSum+abs(Sum[p1,p2,tau]+SM[p1,num]*SM[p2,num-tau]);
      inc(nbS);
      {if abs(newSum)>maxSum then maxSum:=abs(newSum);}
    end;
    maxSum:=maxSum/nbS;

    if maxSum<Eval then
    begin
      Eval:=maxSum;
      g0:=g;
    end;
  end;

  grid[num]:=g0;

  for p1:=0 to npos-1 do
  for p2:=0 to npos-1 do
  for tau:=0 to memory-1 do
  begin
    Sum[p1,p2,tau]:=Sum[p1,p2,tau]+SM[p1,num]*SM[p2,num-tau];
  end;


end;

procedure TBuildGrid.calcul;
var
  i:integer;
  p1,p2,tau:integer;
begin
  for p1:=0 to npos-1 do
  for p2:=0 to npos-1 do
  for tau:=0 to memory-1 do
    Sum[p1,p2,tau]:=0;

  for i:=0 to memory-1 do
    grid[i]:=1+random(maxGrid-1);

  for i:=0 to memory-1 do
  begin
    for p1:=0 to npos-1 do
    for p2:=0 to npos-1 do
    for tau:=0 to memory-1 do
      if i>=tau then
        Sum[p1,p2,tau]:=Sum[p1,p2,tau]+SM[p1,i]*SM[p2,i-tau];
  end;


  for i:=memory to maxlength-1 do AddGrid(i);

end;


function TBuildGrid.getSM(p, t: integer): integer;
begin
  if t>=0
    then result:= ((grid[t] shr p) and 1 )*2-1
    else result:=0;
end;


procedure TBuildGrid.normalize;
var
  p1,p2,tau:integer;
begin
  for p1:=0 to npos-1 do
  for p2:=0 to npos-1 do
  for tau:=0 to memory-1 do
    if Sum[p1,p2,tau]<>0 then
      Sum[p1,p2,tau]:=Sum[p1,p2,tau]/maxLength;

end;

procedure TBuildGrid.WriteSums;
begin
  SaveArrayAsDac2File('c:\dac2\Grid.dat',grid[0],maxLength,G_smallint);
  SaveArrayAsDac2File('c:\dac2\BuildGrid.dat',Sum[0,0,0],memory,G_single);
end;





procedure TestBuildGrid;
var
  grid:Tbuildgrid;

begin
  grid:=Tbuildgrid.create(4,50,1000);
  grid.calcul;

  grid.writeSums;

  grid.free;
end;

end.