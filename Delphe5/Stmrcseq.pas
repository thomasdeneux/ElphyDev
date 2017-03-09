unit Stmrcseq;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,stmdef, D7random1;

type
  tPlace =
    record
      X,Y   : integer;
      contrast : word;
    end;

  tRealPoint = record
     X,Y : float;
  end;

  pRevCorDegree = ^tRevCorDegree;
  tRevCorDegree =
    record
      Place : tPlace;
      Centre : tRealPoint;
    end;

const
  MaxPlaces = 1000;
  MatMAX = 50;

type
  pSequence = ^TSequence;
  TSequence= array[0..MaxPlaces] of TRevCorDegree;

procedure RandSequence(Seed,XDiv,YDiv,Expansion,Scotome:integer;RF:typeDegre;
                       SeqStim : pSequence);

IMPLEMENTATION


Type
  tMatrice = array [0..MatMAX,0..MatMAX] of boolean;

  tMatriceOnOff = array [0..1] of tMatrice;


procedure CalculeCentre(nX,nY,XDiv,YDiv:word;RF:typeDegre;var Stim:tRevCorDegree);
  var
    point : tRealPoint;
  begin
    with Stim do
      begin
        point.x := ((place.x  - nX / 2 + 0.5) * RF.dX) / XDiv;
        point.y := ((place.y  - nY / 2 + 0.5) * RF.dY) / YDiv;
        DegRotationR(point.x,point.y,centre.x,centre.y,0,0,RF.theta);
        centre.x:=centre.x+RF.x;
        centre.y:=centre.y+RF.y;
      end;

  end;

procedure RandPlace(nX,nY:word;var Place : tPlace);
  begin
    with Place do
      begin
        X := Grandom(nX);  { x appartient a [0,nX-1] }
        Y := Grandom(nY);
        contrast := Grandom(2);
      end;
  end;

procedure InitPlace(nX,nY,XDiv,YDiv:word;newPlace:tPlace;RF:typeDegre;
                    var Stim:tRevCorDegree);
  begin
    with Stim.Place do
      begin
        X := newPlace.X;
        Y := newPlace.Y;
        contrast := newPlace.contrast;
        CalculeCentre(nX,nY,XDiv,YDiv,RF,Stim);
      end;
  end;

procedure TrouvePlaceLibre
    (Mat : tMatriceOnOff;
    nX,nY:word;
    var nPlace: tPlace);
  var
    i, j, k : word;
    trouve : boolean;
  begin
    trouve := FALSE;
    for i:=0 to nX-1 do
      for j:=0 to nY-1 do
        for k:=0 to 1 do
          if (Mat[k][i,j]=FALSE) then
            begin
              nPlace.X := i;
              nPlace.Y := j;
              nPlace.contrast := k;
              { k := 2;  pour stopper la recherche }
              trouve := TRUE;
            end;
  end;

procedure RandSequence(Seed,XDiv,YDiv,Expansion,Scotome:integer;RF:typeDegre;
                       SeqStim : pSequence);
  var
    MemoMat : tMatriceOnOff;
    nX,nY,XInf,XSup,YInf,YSup : integer;
    i, j, k, NbPlace : word;
    nouvPlace   : tPlace;

  begin

    nX := round(Xdiv*Expansion/100.0);
    nY := round(Ydiv*Expansion/100.0);

    GsetRandSeed(Seed);

    NbPlace := 0;
    for i:=0 to nX-1 do
      for j:=0 to nY-1 do
        for k:=0 to 1 do
          begin
            MemoMat[k][i,j]:=FALSE;
            inc(NbPlace);
          end;

    XInf := round(nX/2.0 - XDiv*(Scotome/100)/2.0);
    XSup := round(nX/2.0 + XDiv*(Scotome/100)/2.0);
    YInf := round(nY/2.0 - YDiv*(Scotome/100)/2.0);
    YSup := round(nY/2.0 + YDiv*(Scotome/100)/2.0);

    if (Scotome <> 0) then
      for i:= XInf to XSup-1 do
        for j:= YInf to YSup-1 do
          for k:=0 to 1 do
            begin
              MemoMat[k][i,j]:=TRUE;
              dec(NbPlace);
            end;

    SeqStim^[0].place.x := NbPlace;

    for i:= 1 to NbPlace-1 do { le dernier est facile a trouver }
      begin
        { cherche une place libre }
        repeat RandPlace(nX,nY,nouvPlace);
        until (MemoMat[nouvPlace.contrast][nouvPlace.X,nouvPlace.Y] = FALSE);
        { la charge dans la sequence }
        InitPlace(nX,nY,XDiv,YDiv,nouvPlace,RF,SeqStim^[i]);
        { actualise la matrice Memo }
        MemoMat[nouvPlace.contrast][nouvPlace.X,nouvPlace.Y] := TRUE;
      end;

    { trouve la derniere place }
    TrouvePlaceLibre(MemoMat,nX,nY,nouvPlace);
    { et la charge dans la sequence }
    InitPlace(nX,nY,XDiv,YDiv,nouvPlace,RF,SeqStim^[NbPlace]);

  end;




end.
