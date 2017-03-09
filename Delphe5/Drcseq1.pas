unit Drcseq1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
{$O+,F+}

uses util1,Ncdef2,D7random1;

procedure RandSequence(Seed,Scotome,expansion:integer;
                       var NbdivX,NbDivY:integer;
                       sequence:PtabEntier1;var nb:integer);

procedure proRandseq(seed,scotome,expansion:integer;
                     var nbdivX,nbdivY:integer;
                     var tb;size:integer;tpn:word;var nbplace:integer);pascal;

function fonctionParity(n:integer):boolean;pascal;

IMPLEMENTATION

const
  matMax=50;

Type
  tMatrice = array [0..MatMAX,0..MatMAX] of boolean;

  tMatriceOnOff = array [0..1] of tMatrice;



procedure TrouvePlaceLibre(Mat : tMatriceOnOff;
                           nX,nY:integer;
                           var x,y,z:integer);
  var
    i, j, k : integer;
  begin
    for i:=0 to nX-1 do
      for j:=0 to nY-1 do
        for k:=0 to 1 do
          if (Mat[k][i,j]=FALSE) then
            begin
              X := i;
              Y := j;
              Z := k;
              exit;
            end;
  end;


procedure RandSequence(Seed,Scotome,expansion:integer;
                       var NbdivX,NbDivY:integer;
                       sequence:PtabEntier1;var nb:integer);
  var
    MemoMat : tMatriceOnOff;
    i, j, k: integer;
    x,y,contrast:integer;
    Xinf,Xsup,Yinf,Ysup:integer;
    nbPlace:integer;
    nx,ny:integer;

  function codage(x,y,z:integer):integer;
    begin
      codage:=ny*2*x+2*y+z+1;
    end;

  begin
    fillchar(MemoMat,sizeof(Memomat),0);

    nX := round(nbDivX*Expansion/100.0);
    nY := round(nbDivY*Expansion/100.0);

    GsetRandSeed(Seed);

    NbPlace :=nx*ny*2;

    XInf := roundI(nX/2.0 - nbDivX*(Scotome/100)/2.0);
    XSup := roundI(nX/2.0 + nbDivX*(Scotome/100)/2.0) -1;
    YInf := roundI(nY/2.0 - nbDivY*(Scotome/100)/2.0);
    YSup := roundI(nY/2.0 + nbDivY*(Scotome/100)/2.0) -1;

    if (Scotome <> 0) then
      for i:= XInf to XSup do
        for j:= YInf to YSup do
          for k:=1 to 2 do
            begin
              MemoMat[k,i,j]:=TRUE;
              dec(NbPlace);
            end;


    for i:= 1 to NbPlace-1 do { le dernier est facile a trouver }
      begin
        repeat
          X := Grandom(nX);
          Y := Grandom(nY);
          contrast := Grandom(2);
        until (MemoMat[contrast][X,Y] = FALSE);
        if i<=nb then sequence^[i]:=codage(x,y,contrast);
        MemoMat[contrast][X,Y] := TRUE;
      end;

    TrouvePlaceLibre(MemoMat,nX,nY,x,y,contrast);
    if nbPlace<=nb then sequence^[NbPlace]:=codage(x,y,contrast);

    nbDivX:=nx;
    nbdivY:=ny;
    nb:=nbPlace;
  end;

procedure proRandseq(seed,scotome,expansion:integer;
                     var nbdivX,nbdivY:integer;
                     var tb;size:integer;tpn:word;var nbplace:integer);
  begin
    nbPlace:=size div 2;
    RandSequence(Seed,scotome,expansion,
                 Nbdivx,Nbdivy,
                 @tb,nbPlace);
    if nbPlace>size div 2 then sortieErreur(E_parametre);
  end;

function fonctionParity(n:integer):boolean;assembler;
asm
  mov  eax,1
  mov  ebx,n
  test ebx,ebx
  jp   @@1
  mov  eax,0
@@1:
end;


end.
