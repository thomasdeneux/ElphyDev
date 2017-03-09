unit tbe0;


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,math,
     util1,Gdos,Dgraphic,listG;

{ TdataTbE est un tableau de réels étendus du type Acquis1. C'est-à-dire
              un tableau de pointeurs pointant chacun sur un vecteur de réels }

{ TdataTbI (tbE)  est un tableau ordinaire de nombres entiers }
{ TdataTbL (tbI)  est un tableau ordinaire de nombres entiers longs }
{ TdataTbEO(tbE)  est un tableau ordinaire de réels étendus }
{ TdataTbS (tbEO) est un tableau ordinaire de singles }

{ Cette explication ne correspond plus à la hiérarchie actuelle : tous les tableaux
maintenant héritent de tbMem, qui lui-même hérite de tbB }

{ Le stockage est colonne par colonne:
    getI:=PtabEntier(t)^[nblig*(i-Imin)+j-Jmin];


{saveToFile sauve ligne par ligne pour tous les objets sauf TdataTbE

}

type
  TdataTbB=
          class
            Imin,Imax,Jmin,Jmax:integer;
            NbCol,NbLig:integer;
            ax,bx,ay,by,az,bz:float;
            modeCpx:byte;
            KeepFile:boolean;
            Totsize:integer;
            EltSize:integer;

            procedure initVar;virtual;
            destructor destroy;override;



            function getI(i,j:integer):integer;virtual;
            procedure setI(i,j:integer;w:integer);virtual;
            procedure addI(i,j:integer;w:integer);virtual;

            function getE(i,j:integer):float;virtual;
            procedure setE(i,j:integer;w:float);virtual;
            procedure addE(i,j:integer;w:float);virtual;

            function getIm(i,j:integer):float;virtual;
            procedure setIm(i,j:integer;w:float);virtual;

            function getCpx(i,j:integer):TfloatComp;virtual;
            procedure setCpx(i,j:integer;w:TfloatComp);virtual;

            function getMdl(i,j:integer):float;virtual;
            function getP(i,j:integer):pointer;virtual;

            function convx(i:integer):float;
            function invconvx(x:float):integer;
            function invconvxR(x:float):float;


            function convy(i:integer):float;
            function invconvy(x:float):integer;
            function invconvyR(x:float):float;

            function convz(i:integer):float;
            function invconvz(x:float):integer;

            procedure insererLignes(numL,nb:integer);virtual;
            procedure insererColonnes(numC,nb:integer);virtual;
            procedure supprimerLignes(numL,nb:integer);virtual;
            procedure supprimerColonnes(numC,nb:integer);virtual;

            function getName:AnsiString;virtual;

            procedure getMinMax(x1,x2,y1,y2:float;var Vmin,Vmax:float);
            procedure getMinMaxE(var Vmin,Vmax:float);overload;virtual;
            procedure getMinMaxE(var Vmin,Vmax:float;var Imini,Jmini,Imaxi,Jmaxi:integer);overload;virtual;

            procedure getMinMaxI(var Vmin,Vmax:integer);virtual;

            procedure getMinMaxWithTH(th1,th2:float;var Vmin,Vmax:float);

            procedure NonZeroCells(var im,jm:integer);
            function NZlines(col:integer):integer;

            procedure raz;virtual;
            procedure fill(i1,i2,j1,j2:integer;x:float);

            procedure addMat(var mat:TdataTbB);
            procedure subMat(var mat:TdataTbB);


            procedure saveToStream(fx:Tstream);virtual;
            procedure loadFromStream(fx:Tstream);virtual;

            {Ces 3 fonctions renvoient 0 si i ou j hors limites}
            function getValA(i,j:integer):float;
            function getsmoothValA3(i,j:integer):float;
            function getsmoothValA3bis(i,j:integer):float;

            function getCpxValA(i,j:integer):TfloatComp;
            function getCpxsmoothValA3(i,j:integer):TfloatComp;
            function getCpxsmoothValA3bis(i,j:integer):TfloatComp;

            property Zvalue[i,j:integer]:float read getE write setE;default;
            property Jvalue[i,j:integer]:integer read getI write setI;

            procedure switchRows(n1,n2:integer);virtual;
            procedure switchColumns(n1,n2:integer);virtual;
            procedure multAdd(Multiplier:Float;ReferenceRow,ChangingRow: integer);virtual;
            procedure RowDiv(Divisor : Float; Row: integer);

            procedure modifyAd(ad:pointer);virtual;
            function PixRatio:float;
            function AspectRatio:float;
          end;

  TdataTbMem=
            class(TdataTbB)
              t:pointer;
              FreeTbOnDestroy:boolean;

              procedure modifyAd(ad:pointer);override;
              function EltAd(i,j:integer):pointer;virtual;
              procedure raz;override;

              procedure saveToStream(fx:Tstream);override;
              procedure loadFromStream(fx:Tstream);override;
              destructor destroy;override;

              procedure switchRows(n1,n2:integer);override;
              procedure switchColumns(n1,n2:integer);override;


            end;

  TdataTbShort=
            class(TdataTbMem)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getI(i,j:integer):integer;override;
              procedure setI(i,j:integer;w:integer);override;
              procedure addI(i,j:integer;w:integer);override;

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;
            end;

  TdataTbByte=
            class(TdataTbMem)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getI(i,j:integer):integer;override;
              procedure setI(i,j:integer;w:integer);override;
              procedure addI(i,j:integer;w:integer);override;

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;
            end;


    TdataTbI=
            class(TdataTbMem)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getI(i,j:integer):integer;override;
              procedure setI(i,j:integer;w:integer);override;
              procedure addI(i,j:integer;w:integer);override;

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;
            end;

    TdataTbL=
            class(TdataTbMem)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getI(i,j:integer):integer;override;
              procedure setI(i,j:integer;w:integer);override;
              procedure addI(i,j:integer;w:integer);override;

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;
            end;

  TdataTbE=
            class(TdataTbMem)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);



              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;
            end;

  TdataTbS=
            class(TdataTbMem)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;
            end;

  TdataTbD=
            class(TdataTbMem)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;
            end;

  TdataTbScomp=
            class(TdataTbMem)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;

              function getIm(i,j:integer):float;override;
              procedure setIm(i,j:integer;w:float);override;

              function getCpx(i,j:integer):TfloatComp;override;
              procedure setCpx(i,j:integer;w:TfloatComp);override;

              function getMdl(i,j:integer):float;override;
            end;

  TdataTbDcomp=
            class(TdataTbMem)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;

              function getIm(i,j:integer):float;override;
              procedure setIm(i,j:integer;w:float);override;

              function getCpx(i,j:integer):TfloatComp;override;
              procedure setCpx(i,j:integer;w:TfloatComp);override;

              function getMdl(i,j:integer):float;override;
            end;

  TdataTbExtComp=
            class(TdataTbMem)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;

              function getIm(i,j:integer):float;override;
              procedure setIm(i,j:integer;w:float);override;

              function getCpx(i,j:integer):TfloatComp;override;
              procedure setCpx(i,j:integer;w:TfloatComp);override;

              function getMdl(i,j:integer):float;override;
            end;


type
  typeEEE=function(x1,x2:float):float of object;

  TdataFoncEE=
            class(TdataTbB)
              f0:typeEEE;
              constructor create(f:typeEEE;i1,i2,j1,j2:integer;x1,x2,y1,y2:float);

              function getE(i,j:integer):float;override;
              function getP(i,j:integer):pointer;override;
            end;

type
  typeElt=record
            index:integer;
            value:float;
          end;
  PElt=^typeElt;

  TarrayOfElt=array of typeElt;
  TdataSparseTbE=
            class(TdataTbB)
              lines:array of TlistG;
              constructor create(i1,i2,j1,j2:integer);
              destructor destroy;override;

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure setLine(j:integer;tb:TarrayOfElt);

              procedure switchRows(n1,n2:integer);override;
              procedure multAdd(Multiplier:Float;ReferenceRow,ChangingRow: integer);override;
              procedure copyto(dest:TdataTbB);
            end;

            {*********************** Data for MKL ********************}
            {On échange les roles de i et j qui correspondent resp. aux lignes et colonnes
             Le stockage est toujours colonne par colonne.

            }

  TdataKLTbS=
            class(TdataTbMem)
            private
              procedure AddLines(nb:integer);
              procedure addCols(nb:integer);
              procedure RemoveLines(nb:integer);
              procedure removeCols(nb:integer);
            public
              procedure setSize(nRows,Ncols:integer);

              procedure initVar;override;
              procedure ReallocTab;

              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;
            end;

  TdataKLTbD=
            class(TdataKLTbS)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;
            end;

  TdataKLTbScomp=
            class(TdataKLTbS)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;

              function getIm(i,j:integer):float;override;
              procedure setIm(i,j:integer;w:float);override;

              function getCpx(i,j:integer):TfloatComp;override;
              procedure setCpx(i,j:integer;w:TfloatComp);override;

              function getMdl(i,j:integer):float;override;
            end;

  TdataKLTbDcomp=
            class(TdataKLTbS)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;

              function getIm(i,j:integer):float;override;
              procedure setIm(i,j:integer;w:float);override;

              function getCpx(i,j:integer):TfloatComp;override;
              procedure setCpx(i,j:integer;w:TfloatComp);override;

              function getMdl(i,j:integer):float;override;
            end;

type
  TdataTbMemLine=
            class(TdataTbMem)
              function EltAd(i,j:integer):pointer;override;

            end;

  TdataTbIline=
            class(TdataTbMemLine)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getI(i,j:integer):integer;override;
              procedure setI(i,j:integer;w:integer);override;
              procedure addI(i,j:integer;w:integer);override;

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;
            end;

    TdataTbLline=
            class(TdataTbMemLine)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getI(i,j:integer):integer;override;
              procedure setI(i,j:integer;w:integer);override;
              procedure addI(i,j:integer;w:integer);override;

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;
            end;

  TdataTbSline=
            class(TdataTbMemLine)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;
            end;

  TdataTbScompLine=
            class(TdataTbMemLine)
              constructor create(var tb;i1,i2,j1,j2:integer);
              constructor createTab(i1,i2,j1,j2:integer);

              function getE(i,j:integer):float;override;
              procedure setE(i,j:integer;w:float);override;
              procedure addE(i,j:integer;w:float);override;
              function getP(i,j:integer):pointer;override;

              function getIm(i,j:integer):float;override;
              procedure setIm(i,j:integer;w:float);override;

              function getCpx(i,j:integer):TfloatComp;override;
              procedure setCpx(i,j:integer;w:TfloatComp);override;

              function getMdl(i,j:integer):float;override;
            end;


IMPLEMENTATION

{******************** Méthodes de TdataTbB *****************************}


procedure TdataTbB.initvar;
begin
  nbcol:=Imax-Imin+1;
  nblig:=Jmax-Jmin+1;
  ax:=1;
  bx:=0;
  ay:=1;
  by:=0;
  az:=1;
  bz:=0;
  totSize:=EltSize*nbcol*nblig;
end;

destructor TdataTbB.destroy;
begin
end;


function TdataTbB.getE(i,j:integer):float;
begin
  getE:=0;
end;

function TdataTbB.getP(i,j:integer):pointer;
begin
  result:=nil;
end;

procedure TdataTbB.setE(i,j:integer;w:float);
begin
end;

procedure TdataTbB.addE(i,j:integer;w:float);
begin
end;

function TdataTbB.getI(i,j:integer):integer;
begin
  getI:=round(getE(i,j));
end;

procedure TdataTbB.setI(i,j:integer;w:integer);
begin
  setE(i,j,w);
end;

procedure TdataTbB.addI(i,j:integer;w:integer);
begin
  setE(i,j,getE(i,j)+w);
end;

function TdataTbB.getIm(i,j:integer):float;
begin
  result:=0;
end;

procedure TdataTbB.setIm(i,j:integer;w:float);
begin
end;

function TdataTbB.getCpx(i,j:integer):TfloatComp;
begin
  result.x:=getE(i,j);
  result.y:=0;
end;


procedure TdataTbB.setCpx(i,j:integer;w:TfloatComp);
begin
  setE(i,j,w.x);
end;

function TdataTbB.getMdl(i,j:integer):float;
begin
  result:=getE(i,j);
end;

function TdataTbB.convX(i:integer):float;
begin
  convX:=aX*i+bX;
end;

function TdataTbB.invConvX(x:float):integer;
begin
  if aX<>0 then invConvX:=roundL((x-bX)/aX);
end;

function TdataTbB.invConvXR(x:float):float;
begin
  if aX<>0 then result:=(x-bX)/aX;
end;


function TdataTbB.convY(i:integer):float;
begin
  convY:=aY*i+bY;
end;

function TdataTbB.invConvY(x:float):integer;
begin
  if aY<>0 then invConvY:=roundL((x-bY)/aY);
end;

function TdataTbB.invConvYR(x:float):float;
begin
  if aY<>0 then result:=(x-bY)/aY;
end;

function TdataTbB.convZ(i:integer):float;
begin
  convZ:=aZ*i+bZ;
end;

function TdataTbB.invConvZ(x:float):integer;
begin
  if aZ<>0 then invConvZ:=roundL((x-bZ)/aZ);
end;


procedure TdataTbB.insererLignes(numL,nb:integer);
begin
end;

procedure TdataTbB.insererColonnes(numC,nb:integer);
begin
end;

procedure TdataTbB.supprimerLignes(numL,nb:integer);
begin
end;

procedure TdataTbB.supprimerColonnes(numC,nb:integer);
begin
end;

function TdataTbB.getName:AnsiString;
begin
end;

procedure TdataTbB.getMinMaxI(var Vmin,Vmax:integer);
var
  i,j:integer;
  x:integer;
begin
  for j:=Jmin to Jmax do
    for i:=Imin to Imax do
      begin
        x:=getI(i,j);
        if x<Vmin then Vmin:=x;
        if x>Vmax then Vmax:=x;
      end;
end;

procedure TdataTbB.getMinMaxE(var Vmin,Vmax:float);
var
  i,j:integer;
  x:float;
begin
  for j:=Jmin to Jmax do
    for i:=Imin to Imax do
      begin
        x:=getE(i,j);
        if x<Vmin then Vmin:=x;
        if x>Vmax then Vmax:=x;
      end;
end;

procedure TdataTbB.getMinMaxE(var Vmin,Vmax:float;var Imini,Jmini,Imaxi,Jmaxi:integer);
var
  i,j:integer;
  x:float;
begin
  for j:=Jmin to Jmax do
    for i:=Imin to Imax do
      begin
        x:=getE(i,j);
        if x<Vmin then
        begin
          Vmin:=x;
          Imini:=i;
          Jmini:=j;
        end;
        if x>Vmax then
        begin
          Vmax:=x;
          Imaxi:=i;
          Jmaxi:=j;
        end;
      end;
end;

procedure TdataTbB.getMinMax(x1,x2,y1,y2:float;var Vmin,Vmax:float);
var
  i,j:integer;
  x:float;
begin
  Vmin:=1E300;
  Vmax:=-1E300;
  for j:=invConvY(y1) to invConvY(y2) do
    for i:=invConvX(x1) to invConvX(x2) do
      begin
        x:=getE(i,j);
        if x<Vmin then Vmin:=x;
        if x>Vmax then Vmax:=x;
      end;
end;

procedure TdataTbB.getMinMaxWithTH(th1,th2:float;var Vmin,Vmax:float);
var
  i,j:integer;
  x:float;
begin
  for j:=Jmin to Jmax do
  for i:=Imin to Imax do
    begin
      x:=getE(i,j);
      if (x<Vmin) and (x>=Th1) then Vmin:=x;
      if (x>Vmax) and (x<=Th2) then Vmax:=x;
    end;
end;



procedure TdataTbB.NonZeroCells(var Im,Jm:integer);
var
  i,j:integer;
  x:float;
begin
  Im:=0;
  Jm:=0;
  for j:=Jmin to Jmax do
    for i:=Imin to Imax do
      begin
        x:=getE(i,j);
        if x<>0 then
          begin
            if i>Im then Im:=i;
            if j>Jm then Jm:=j;
          end;
      end;
end;

function TdataTbB.NZlines(col:integer):integer;
  var
    j:integer;
    x:float;
  begin
    for j:=Jmax downto Jmin do
      begin
        x:=getE(col,j);
        if x<>0 then
          begin
            NZlines:=j-Jmin+1;
            exit;
          end;
      end;
    NZlines:=0;
  end;


procedure TdataTbB.raz;
begin
end;

procedure TdataTbB.fill(i1,i2,j1,j2:integer;x:float);
var
  i,j:integer;
begin
  if i1<Imin then i1:=Imin;
  if i2>Imax then i2:=Imax;
  if j1<Jmin then j1:=Jmin;
  if j2>Jmax then j2:=Jmax;


  for j:=j1 to j2 do
    for i:=i1 to i2 do
      setE(i,j,x);
end;


procedure TdataTbB.addMat(var mat:TdataTbB);
var
  i,j:integer;
begin
  for j:=Jmin to Jmax do
    for i:=Imin to Imax do
      addE(i,j,mat.getE(i,j));
end;

procedure TdataTbB.subMat(var mat:TdataTbB);
var
  i,j:integer;
begin
  for j:=Jmin to Jmax do
    for i:=Imin to Imax do
      addE(i,j,-mat.getE(i,j));
end;

procedure TdataTbB.saveToStream(fx:Tstream);
begin
end;


procedure TdataTbB.loadFromStream(fx:Tstream);
begin
end;

function TdataTbB.getValA(i,j:integer):float;
begin
  if (i>=Imin) and (i<=Imax) and
     (j>=Jmin) and (j<=Jmax)
    then result:=getE(i,j)
    else result:=0;
end;

function TdataTbB.getsmoothValA3(i,j:integer):float;
var
  w:float;
  i1,j1,im,jm:integer;

begin
  result:=0;

  if (i<=Imin) or (i>=Imin+3*(Imax-Imin+1)-1) or
     (j<=Jmin) or (j>=Jmin+3*(Jmax-Jmin+1)-1)
   then exit;

  i1:=(i-Imin) div 3 +Imin;
  j1:=(j-Jmin) div 3 +Jmin;
  im:=(i-Imin) mod 3;
  jm:=(j-Jmin) mod 3;

  w:=0;
  case im of
    0: case jm of
         0: w:=4*getE(i1,j1)+2*getE(i1-1,j1)+2*getE(i1,j1-1)+getE(i1-1,j1-1);
         1: w:=6*getE(i1,j1)+3*getE(i1-1,j1);
         2: w:=4*getE(i1,j1)+2*getE(i1-1,j1)+2*getE(i1,j1+1)+getE(i1-1,j1+1);
       end;
    1: case jm of
         0: w:=6*getE(i1,j1)+3*getE(i1,j1-1);
         1: w:=9*getE(i1,j1);
         2: w:=6*getE(i1,j1)+3*getE(i1,j1+1);
       end;
    2: case jm of
         0: w:=4*getE(i1,j1)+2*getE(i1+1,j1)+2*getE(i1,j1-1)+getE(i1+1,j1-1);
         1: w:=6*getE(i1,j1)+3*getE(i1+1,j1);
         2: w:=4*getE(i1,j1)+2*getE(i1+1,j1)+2*getE(i1,j1+1)+getE(i1+1,j1+1);
       end;
  end;

  result:=w/9;

end;


function TdataTbB.getSmoothValA3bis(i,j:integer):float;
var
  w:float;
  i1,j1,im,jm:integer;
  nb:integer;

function getVal(i,j,k:integer):float;
begin
  result:=0;
  if (i<Imin) or (i>Imax) or (j<Jmin) or (j>Jmax) then exit;
  result:=getE(i,j);
  if result<>0 then inc(nb,k);
end;

begin

  result:=0;

  i1:=(i-Imin) div 3 +Imin;
  j1:=(j-Jmin) div 3 +Jmin;
  im:=(i-Imin) mod 3;
  jm:=(j-Jmin) mod 3;

  if getE(i1,j1)=0 then exit;

  nb:=0;
  w:=0;
  case im of
    0: case jm of
         0: w:=4*getVal(i1,j1,4)+2*getVal(i1-1,j1,2)+2*getVal(i1,j1-1,2)+getVal(i1-1,j1-1,1);
         1: w:=6*getVal(i1,j1,6)+3*getVal(i1-1,j1,3);
         2: w:=4*getVal(i1,j1,4)+2*getVal(i1-1,j1,2)+2*getVal(i1,j1+1,2)+getVal(i1-1,j1+1,1);
       end;
    1: case jm of
         0: w:=6*getVal(i1,j1,6)+3*getVal(i1,j1-1,3);
         1: w:=9*getVal(i1,j1,9);
         2: w:=6*getVal(i1,j1,6)+3*getVal(i1,j1+1,3);
       end;
    2: case jm of
         0: w:=4*getVal(i1,j1,4)+2*getVal(i1+1,j1,2)+2*getVal(i1,j1-1,2)+getVal(i1+1,j1-1,1);
         1: w:=6*getVal(i1,j1,6)+3*getVal(i1+1,j1,3);
         2: w:=4*getVal(i1,j1,4)+2*getVal(i1+1,j1,2)+2*getVal(i1,j1+1,2)+getVal(i1+1,j1+1,1);
       end;
  end;

  if nb>0 then w:=w/nb else w:=0;

  result:=w;

end;


function TdataTbB.getCpxValA(i,j:integer):TfloatComp;
begin
  if (i>=Imin) and (i<=Imax) and
     (j>=Jmin) and (j<=Jmax)
    then result:=getCpx(i,j)
    else result:=CpxNumber(0,0);
end;

function TdataTbB.getCpxSmoothValA3(i,j:integer):TfloatComp;
var
  oldMode:byte;
  w1,w2:float;
begin
  oldMode:=ModeCpx;
  ModeCpx:=0;
  w1:=getSmoothValA3(i,j);
  ModeCpx:=1;
  w2:=getSmoothValA3(i,j);
  ModeCpx:=oldMode;

  result:=CpxNumber(w1,w2);
end;


function TdataTbB.getCpxSmoothValA3bis(i,j:integer):TfloatComp;
var
  oldMode:byte;
  w1,w2:float;
begin
  oldMode:=ModeCpx;
  ModeCpx:=0;
  w1:=getSmoothValA3bis(i,j);
  ModeCpx:=1;
  w2:=getSmoothValA3bis(i,j);
  ModeCpx:=oldMode;

  result:=CpxNumber(w1,w2);
end;


procedure TdataTbB.switchRows(n1,n2:integer);
var
  i:integer;
  w:float;
begin
  for i:=Imin to Imax do
  begin
    w:=Zvalue[i,n1];
    Zvalue[i,n1]:=Zvalue[i,n2];
    Zvalue[i,n2]:=w;
  end;
end;

procedure TdataTbB.switchColumns(n1,n2:integer);
var
  j:integer;
  w:float;
begin
  for j:=Jmin to Jmax do
  begin
    w:=Zvalue[n1,j];
    Zvalue[n1,j]:=Zvalue[n2,j];
    Zvalue[n2,j]:=w;
  end;
end;


procedure TdataTbB.multAdd(Multiplier:Float;ReferenceRow,ChangingRow: integer);
var
  i:integer;
begin
  for i:=Imin to Imax do
    Zvalue[i,ChangingRow]:=
      Zvalue[i,ChangingRow]+Multiplier*Zvalue[i,ReferenceRow];
end;

procedure TdataTbB.RowDiv(Divisor : Float; Row: integer);
var
  i:integer;
begin
  for i:=Imin to Imax do
    Zvalue[i,Row]:= Zvalue[i,Row]/divisor;
end;

procedure TdataTbB.modifyAd(ad:pointer);
begin
end;

function TdataTbB.PixRatio: float;
begin
  if ax<>0
    then result:=abs(ay/ax)
    else result:=1;
end;

function TdataTbB.AspectRatio: float;
begin
  if Imax>=Imin
   then result:=PixRatio*(Jmax-Jmin+1)/(Imax-Imin+1);
end;


{******************** Méthodes de TdataTbMem *****************************}

procedure TdataTbMem.modifyAd(ad:pointer);
begin
  t:=ad;
end;

destructor TdataTbMem.destroy;
begin
  if FreeTbOnDestroy then freemem(t);
end;

procedure TdataTbMem.raz;
begin
  if assigned(t)
    then fillchar(t^,totSize,0);
  end;

procedure TdataTbMem.saveToStream(fx:Tstream);
begin
  fx.writeBuffer(t^,totSize);
end;


procedure TdataTbMem.loadFromStream(fx:Tstream);
var
  res:intG;
begin
  res:=fx.read(t^,totSize);
end;

function TdataTbMem.EltAd(i,j:integer):pointer;
begin
  result:=@PtabOctet(t)^[(nblig*(i-Imin)+j-Jmin)*EltSize ];
    {(j-jmin)*nbcol+i-imin] pour un stockage par ligne };
end;


procedure TdataTbmem.switchRows(n1,n2:integer);
var
  i:integer;
  w:array[1..20] of byte;
begin
  for i:=Imin to Imax do
  begin
    move(EltAd(i,n1)^,w,EltSize);
    move(EltAd(i,n2)^,EltAd(i,n1)^,EltSize);
    move(w,EltAd(i,n2)^,EltSize);
  end;
end;

procedure TdataTbmem.switchColumns(n1,n2:integer);
var
  j:integer;
  w:array[1..20] of byte;
begin
  for j:=Jmin to Jmax do
  begin
    move(EltAd(n1,j)^,w,EltSize);
    move(EltAd(n2,j)^,EltAd(n1,j)^,EltSize);
    move(w,EltAd(n2,j)^,EltSize);
  end;
end;

{******************** Méthodes de TdataTbShort *****************************}

constructor TdataTbShort.create(var tb;i1,i2,j1,j2:integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=1;

  InitVar;
end;

constructor TdataTbShort.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbShort.getI(i,j:integer):integer;
begin
  getI:=PtabShort(t)^[nblig*(i-Imin)+j-Jmin];
end;

procedure TdataTbShort.setI(i,j:integer;w:integer);
begin
  PtabShort(t)^[nblig*(i-Imin)+j-Jmin]:=w;
end;

procedure TdataTbShort.addI(i,j:integer;w:integer);
begin
  inc(PtabShort(t)^[nblig*(i-Imin)+j-Jmin],w);
end;

function TdataTbShort.getE(i,j:integer):float;
begin
  getE:=convZ(PtabShort(t)^[nblig*(i-Imin)+j-Jmin]);
end;

function TdataTbShort.getP(i,j:integer):pointer;
begin
  result:=@PtabShort(t)^[nblig*(i-Imin)+j-Jmin];
end;


procedure TdataTbShort.setE(i,j:integer;w:float);
begin
  PtabShort(t)^[nblig*(i-Imin)+j-Jmin]:=invConvZ(w);
end;

procedure TdataTbShort.addE(i,j:integer;w:float);
begin
  inc(PtabShort(t)^[nblig*(i-Imin)+j-Jmin],invConvZ(w));
end;

{******************** Méthodes de TdataTbByte *****************************}

constructor TdataTbByte.create(var tb;i1,i2,j1,j2:integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=1;

  InitVar;
end;

constructor TdataTbByte.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbByte.getI(i,j:integer):integer;
begin
  getI:=PtabOctet(t)^[nblig*(i-Imin)+j-Jmin];
end;

procedure TdataTbByte.setI(i,j:integer;w:integer);
begin
  PtabOctet(t)^[nblig*(i-Imin)+j-Jmin]:=w;
end;

procedure TdataTbByte.addI(i,j:integer;w:integer);
begin
  inc(PtabOctet(t)^[nblig*(i-Imin)+j-Jmin],w);
end;

function TdataTbByte.getE(i,j:integer):float;
begin
  getE:=convZ(PtabOctet(t)^[nblig*(i-Imin)+j-Jmin]);
end;

function TdataTbByte.getP(i,j:integer):pointer;
begin
  result:=@PtabOctet(t)^[nblig*(i-Imin)+j-Jmin];
end;


procedure TdataTbByte.setE(i,j:integer;w:float);
begin
  PtabOctet(t)^[nblig*(i-Imin)+j-Jmin]:=invConvZ(w);
end;

procedure TdataTbByte.addE(i,j:integer;w:float);
begin
  inc(PtabOctet(t)^[nblig*(i-Imin)+j-Jmin],invConvZ(w));
end;



{******************** Méthodes de TdataTbI *****************************}

constructor TdataTbI.create(var tb;i1,i2,j1,j2:integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=2;

  InitVar;
end;

constructor TdataTbI.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(smallint));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbI.getI(i,j:integer):integer;
begin
  getI:=PtabEntier(t)^[nblig*(i-Imin)+j-Jmin];
end;

procedure TdataTbI.setI(i,j:integer;w:integer);
begin
  PtabEntier(t)^[nblig*(i-Imin)+j-Jmin]:=w;
end;

procedure TdataTbI.addI(i,j:integer;w:integer);
begin
  inc(PtabEntier(t)^[nblig*(i-Imin)+j-Jmin],w);
end;

function TdataTbI.getE(i,j:integer):float;
begin
  getE:=convZ(PtabEntier(t)^[nblig*(i-Imin)+j-Jmin]);
end;

function TdataTbI.getP(i,j:integer):pointer;
begin
  result:=@PtabEntier(t)^[nblig*(i-Imin)+j-Jmin];
end;


procedure TdataTbI.setE(i,j:integer;w:float);
begin
  PtabEntier(t)^[nblig*(i-Imin)+j-Jmin]:=invConvZ(w);
end;

procedure TdataTbI.addE(i,j:integer;w:float);
begin
  inc(PtabEntier(t)^[nblig*(i-Imin)+j-Jmin],invConvZ(w));
end;



{******************** M‚thodes de TdataTbL *****************************}

constructor TdataTbL.create(var tb;i1,i2,j1,j2:integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=4;

  InitVar;
end;

constructor TdataTbL.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(longint));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbL.getI(i,j:integer):integer;
  begin
    getI:=PtabLong(t)^[nblig*(i-Imin)+j-Jmin];
  end;

procedure TdataTbL.setI(i,j:integer;w:integer);
  begin
    PtabLong(t)^[nblig*(i-Imin)+j-Jmin]:=w;
  end;

procedure TdataTbL.addI(i,j:integer;w:integer);
  begin
    inc(PtabLong(t)^[nblig*(i-Imin)+j-Jmin],w);
  end;

function TdataTbL.getE(i,j:integer):float;
  begin
    getE:=convZ(PtabLong(t)^[nblig*(i-Imin)+j-Jmin]);
  end;

function TdataTbL.getP(i,j:integer):pointer;
  begin
    result:=@PtabLong(t)^[nblig*(i-Imin)+j-Jmin];
  end;

procedure TdataTbL.setE(i,j:integer;w:float);
  begin
    PtabLong(t)^[nblig*(i-Imin)+j-Jmin]:=invConvZ(w);
  end;

procedure TdataTbL.addE(i,j:integer;w:float);
  begin
    inc(PtabLong(t)^[nblig*(i-Imin)+j-Jmin],invConvZ(w));
  end;


{******************** M‚thodes de TdataTbE *****************************}

constructor TdataTbE.create(var tb;i1,i2,j1,j2:integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=10;

  InitVar;
end;

constructor TdataTbE.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(float));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbE.getE(i,j:integer):float;
  begin
    getE:=PtabFloat(t)^[nblig*(i-Imin)+j-Jmin];
  end;

function TdataTbE.getP(i,j:integer):pointer;
  begin
    result:=@PtabFloat(t)^[nblig*(i-Imin)+j-Jmin];
  end;

procedure TdataTbE.setE(i,j:integer;w:float);
  begin
    PtabFloat(t)^[nblig*(i-Imin)+j-Jmin]:=w;
  end;

procedure TdataTbE.addE(i,j:integer;w:float);
  var
    k:integer;
  begin
    k:=nblig*(i-Imin)+j-Jmin;
    PtabFloat(t)^[k]:=PtabFloat(t)^[k]+w;
  end;


{******************** Méthodes de TdataTbS *****************************}

constructor TdataTbS.create(var tb;i1,i2,j1,j2:integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=4;

  InitVar;
end;

constructor TdataTbS.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(single));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbS.getE(i,j:integer):float;
  begin
    getE:=PtabSingle(t)^[nblig*(i-Imin)+j-Jmin];
  end;

function TdataTbS.getP(i,j:integer):pointer;
begin
  result:=@PtabSingle(t)^[nblig*(i-Imin)+j-Jmin];
end;


procedure TdataTbS.setE(i,j:integer;w:float);
  begin
    PtabSingle(t)^[nblig*(i-Imin)+j-Jmin]:=w;
  end;

procedure TdataTbS.addE(i,j:integer;w:float);
  var
    k:integer;
  begin
    k:=nblig*(i-Imin)+j-Jmin;
    Ptabsingle(t)^[k]:=Ptabsingle(t)^[k]+w;
  end;

{******************** Méthodes de TdataTbD *****************************}

constructor TdataTbD.create(var tb;i1,i2,j1,j2:integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=8;

  InitVar;
end;

constructor TdataTbD.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(double));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbD.getE(i,j:integer):float;
  begin
    getE:=PtabDouble(t)^[nblig*(i-Imin)+j-Jmin];
  end;

function TdataTbD.getP(i,j:integer):pointer;
begin
  result:=@PtabDouble(t)^[nblig*(i-Imin)+j-Jmin];
end;


procedure TdataTbD.setE(i,j:integer;w:float);
  begin
    PtabDouble(t)^[nblig*(i-Imin)+j-Jmin]:=w;
  end;

procedure TdataTbD.addE(i,j:integer;w:float);
  var
    k:integer;
  begin
    k:=nblig*(i-Imin)+j-Jmin;
    PtabDouble(t)^[k]:=PtabDouble(t)^[k]+w;
  end;



{************************** Méthodes de TdataTbScomp ***********************}

function TdataTbScomp.getE(i, j: Integer): float;
var
  z:TsingleComp;
begin
  z:=PtabSingleComp(t)^[nblig*(i-Imin)+j-Jmin];
  case modeCpx of
     0: result:= z.x;
     1: result:= z.y;
     2: result:=sqrt(sqr(z.x)+sqr(z.y));
     3: result:=arctan2(z.y,z.x);
   end;
end;

constructor TdataTbScomp.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(TsingleComp));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbScomp.getP(i, j: Integer): pointer;
begin
  result:=@PtabSingleComp(t)^[nblig*(i-Imin)+j-Jmin];
end;

procedure TdataTbScomp.setE(i, j: Integer; w: float);
begin
  PtabSingleComp(t)^[nblig*(i-Imin)+j-Jmin].x:=w;
end;

procedure TdataTbScomp.addE(i, j: Integer; w: float);
begin
  with PtabSingleComp(t)^[nblig*(i-Imin)+j-Jmin] do x:=x+w;
end;

function TdataTbScomp.getIm(i, j: Integer): float;
begin
  result:=PtabSingleComp(t)^[nblig*(i-Imin)+j-Jmin].y;
end;

procedure TdataTbScomp.setIm(i, j: Integer; w: float);
begin
  PtabSingleComp(t)^[nblig*(i-Imin)+j-Jmin].y:=w;
end;

function TdataTbScomp.getCpx(i, j: Integer): TfloatComp;
begin
  with PtabSingleComp(t)^[nblig*(i-Imin)+j-Jmin] do
  begin
    result.x:=x;
    result.y:=y;
  end;
end;

procedure TdataTbScomp.setCpx(i, j: Integer; w: TfloatComp);
begin
  with PtabSingleComp(t)^[nblig*(i-Imin)+j-Jmin] do
  begin
    x:=w.x;
    y:=w.y;
  end;
end;

function TdataTbScomp.getMdl(i, j: Integer): float;
begin
  with PtabSingleComp(t)^[nblig*(i-Imin)+j-Jmin] do
  begin
    result:=sqrt(sqr(x)+sqr(y));
  end;
end;


constructor TdataTbScomp.create(var tb; i1, i2, j1, j2: Integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=8;

  InitVar;
end;

{************************** Méthodes de TdataTbDcomp ***********************}

function TdataTbDcomp.getE(i, j: Integer): float;
var
  z:TdoubleComp;
begin
  z:=PtabdoubleComp(t)^[nblig*(i-Imin)+j-Jmin];
  case modeCpx of
     0: result:= z.x;
     1: result:= z.y;
     2: result:=sqrt(sqr(z.x)+sqr(z.y));
     3: result:=arctan2(z.y,z.x);
   end;
end;

constructor TdataTbDcomp.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(TdoubleComp));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbDcomp.getP(i, j: Integer): pointer;
begin
  result:=@PtabdoubleComp(t)^[nblig*(i-Imin)+j-Jmin];
end;

procedure TdataTbDcomp.setE(i, j: Integer; w: float);
begin
  PtabdoubleComp(t)^[nblig*(i-Imin)+j-Jmin].x:=w;
end;

procedure TdataTbDcomp.addE(i, j: Integer; w: float);
begin
  with PtabdoubleComp(t)^[nblig*(i-Imin)+j-Jmin] do x:=x+w;
end;

function TdataTbDcomp.getIm(i, j: Integer): float;
begin
  result:=PtabdoubleComp(t)^[nblig*(i-Imin)+j-Jmin].y;
end;

procedure TdataTbDcomp.setIm(i, j: Integer; w: float);
begin
  PtabdoubleComp(t)^[nblig*(i-Imin)+j-Jmin].y:=w;
end;

function TdataTbDcomp.getCpx(i, j: Integer): TfloatComp;
begin
  with PtabdoubleComp(t)^[nblig*(i-Imin)+j-Jmin] do
  begin
    result.x:=x;
    result.y:=y;
  end;
end;

procedure TdataTbDcomp.setCpx(i, j: Integer; w: TfloatComp);
begin
  with PtabdoubleComp(t)^[nblig*(i-Imin)+j-Jmin] do
  begin
    x:=w.x;
    y:=w.y;
  end;
end;

function TdataTbDcomp.getMdl(i, j: Integer): float;
begin
  with PtabdoubleComp(t)^[nblig*(i-Imin)+j-Jmin] do
  begin
    result:=sqrt(sqr(x)+sqr(y));
  end;
end;


constructor TdataTbDcomp.create(var tb; i1, i2, j1, j2: Integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=16;

  InitVar;
end;


{************************** Méthodes de TdataTbExtcomp ***********************}

function TdataTbExtcomp.getE(i, j: Integer): float;
var
  z:TfloatComp;
begin
  z:=PtabfloatComp(t)^[nblig*(i-Imin)+j-Jmin];
  case modeCpx of
     0: result:= z.x;
     1: result:= z.y;
     2: result:=sqrt(sqr(z.x)+sqr(z.y));
     3: result:=arctan2(z.y,z.x);
   end;
end;

constructor TdataTbExtcomp.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(TfloatComp));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbExtcomp.getP(i, j: Integer): pointer;
begin
  result:=@PtabfloatComp(t)^[nblig*(i-Imin)+j-Jmin];
end;

procedure TdataTbExtcomp.setE(i, j: Integer; w: float);
begin
  PtabfloatComp(t)^[nblig*(i-Imin)+j-Jmin].x:=w;
end;

procedure TdataTbExtcomp.addE(i, j: Integer; w: float);
begin
  with PtabfloatComp(t)^[nblig*(i-Imin)+j-Jmin] do x:=x+w;
end;

function TdataTbExtcomp.getIm(i, j: Integer): float;
begin
  result:=PtabfloatComp(t)^[nblig*(i-Imin)+j-Jmin].y;
end;

procedure TdataTbExtcomp.setIm(i, j: Integer; w: float);
begin
  PtabfloatComp(t)^[nblig*(i-Imin)+j-Jmin].y:=w;
end;

function TdataTbExtcomp.getCpx(i, j: Integer): TfloatComp;
begin
  with PtabfloatComp(t)^[nblig*(i-Imin)+j-Jmin] do
  begin
    result.x:=x;
    result.y:=y;
  end;
end;

procedure TdataTbExtcomp.setCpx(i, j: Integer; w: TfloatComp);
begin
  with PtabfloatComp(t)^[nblig*(i-Imin)+j-Jmin] do
  begin
    x:=w.x;
    y:=w.y;
  end;
end;

function TdataTbExtcomp.getMdl(i, j: Integer): float;
begin
  with PtabfloatComp(t)^[nblig*(i-Imin)+j-Jmin] do
  begin
    result:=sqrt(sqr(x)+sqr(y));
  end;
end;


constructor TdataTbExtcomp.create(var tb; i1, i2, j1, j2: Integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=20;

  InitVar;
end;

 {********************* Méthodes de TdataFoncEE ****************************}


constructor TdataFoncEE.create(f:typeEEE;i1,i2,j1,j2:integer;x1,x2,y1,y2:float);
begin
  f0:=f;
  Imin:=i1;
  Jmin:=j1;
  Imax:=i2;
  Jmax:=j2;

  ax:=(x2-x1)/(i2-i1);
  bx:=x1-ax*i1;

  ay:=(y2-y1)/(j2-j1);
  by:=y1-ay*j1;

end;

function TdataFoncEE.getE(i,j:integer):float;
begin
  result:=f0(ax*i+bx,ay*j+by);
end;

function TdataFoncEE.getP(i,j:integer):pointer;
begin
  result:=nil;
end;




{ TdataSparseTbE }

constructor TdataSparseTbE.create(i1, i2, j1, j2: integer);
var
  i:integer;
begin
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=10;
  InitVar;

  setLength(lines,nblig);
  for i:=0 to nblig-1 do
    lines[i]:=TlistG.create(sizeof(typeElt));
end;

destructor TdataSparseTbE.destroy;
var
  i:integer;
begin
  for i:=0 to nblig-1 do
    lines[i].Free;
end;

procedure TdataSparseTbE.setE(i, j: integer; w: float);
var
  Elt:typeElt;
  p:^typeElt;
  k:integer;
begin
  with lines[j-Jmin] do
  begin
    if count=0 then
    begin
      if w<>0 then
      begin
        Elt.index:=i;
        Elt.value:=w;
        add(@ELt);
      end;  
    end
    else
    begin
      p:=getSortedItemDword(i,0,k);
      if p^.index=i then
      begin
        if w<>0
          then p^.value:=w
          else delete(k);
      end
      else
      if w<>0 then
      begin
        Elt.index:=i;
        Elt.value:=w;
        if p^.index<i
          then insert(k+1,@Elt)
          else insert(0,@Elt);
      end;
    end;
  end;
end;

function TdataSparseTbE.getE(i, j: integer): float;
var
  p:^typeElt;
  k:integer;
begin
  with lines[j-Jmin] do
  begin
    p:=getSortedItemDword(i,0,k);
    if assigned(p) and (p^.index=i)
      then result:=p^.value
      else result:=0;
  end;
end;



procedure TdataSparseTbE.setLine(j:integer;tb: TarrayOfElt);
var
  i:integer;
begin
  with lines[j-Jmin] do
  begin
    clear;
    for i:=0 to high(tb) do add(@tb[i]);
  end;
end;


procedure TdataSparseTbE.switchRows(n1, n2: integer);
var
  p:pointer;
begin
  p:=lines[n1-Jmin];
  lines[n1-Jmin]:=lines[n2-Jmin];
  lines[n2-Jmin]:=p;
end;

procedure TdataSparseTbE.multAdd(Multiplier:Float;ReferenceRow,ChangingRow: integer);
var
  i:integer;
begin
  with lines[ReferenceRow-Jmin] do
  for i:=0 to count-1 do
    with PElt(items[i])^ do
      Zvalue[index,ChangingRow]:=Zvalue[index,ChangingRow]+Multiplier*value;


end;

procedure TdataSparseTbE.copyto(dest: TdataTbB);
var
  i,j:integer;
begin
  dest.raz;
  for j:=Jmin to Jmax do
  with lines[j-Jmin] do
  for i:=0 to count-1 do
    with PElt(items[i])^ do dest[index,j]:=value;
end;



{ TdataKLTbS }

procedure TdataKLTbS.initvar;
begin
  inherited;
  nblig:=Imax-Imin+1;
  nbcol:=Jmax-Jmin+1;
end;

procedure TdataKLTbS.reallocTab;
var
  size:integer;
begin
  size:=totSize;
  initvar;

  reallocmem(t,totSize);
  if totSize>size
    then fillchar(PtabOctet(t)^[size],totSize-size,0);
end;

constructor TdataKLTbS.create(var tb; i1, i2, j1, j2: integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=4;

  InitVar;
end;

constructor TdataKLTbS.createTab(i1, i2, j1, j2: integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(single));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;

procedure TdataKLTbS.addCols(nb:integer);
begin
  inc(Jmax,nb);
  reallocTab;
end;

procedure TdataKLTbS.removeCols(nb:integer);
begin
  dec(Jmax,nb);
  if Jmax<Jmin then Jmax:=Jmin-1;
  reallocTab;
end;


procedure TdataKLTbS.AddLines(nb:integer);
var
  Isize,OldNbRow:integer;
  i:integer;
begin
  Isize:=EltSize*nblig;
  OldNbRow:=nblig;

  inc(Imax,nb);
  reallocTab;

  for i:=nbCol-1 downto 0 do
  begin
    move(Ptaboctet(t)^[EltSize*OldNbRow*i],PtabOctet(t)^[EltSize*nblig*i],Isize);
    fillchar(PtabOctet(t)^[EltSize*(nblig*i+OldNbRow)],(nblig-OldNbRow)*EltSize,0);
  end;
end;

procedure TdataKLTbS.RemoveLines(nb:integer);
var
  Newsize,OldNbRow:integer;
  i:integer;
begin
  OldNbRow:=nblig;

  dec(Imax,nb);
  if Imax<Imin then Imax:=Imin-1;
  nblig:=Imax-Imin+1;

  Newsize:=EltSize*nblig;
  for i:=0 to nbCol-1 do
    move(PtabOctet(t)^[EltSize*OldNbRow*i],PtabOctet(t)^[EltSize*nblig*i],Newsize);

  reallocTab;
end;


procedure TdataKLTbS.setSize(nRows, Ncols: integer);
begin
  if nRows>nblig
    then addLines(nRows-nblig)
    else removeLines(nblig-nRows);

  if ncols>nbCol
    then addCols(ncols-nbCol)
    else removeCols(nbCol-nCols);

end;




function TdataKLTbS.getE(i, j: integer): float;
begin
  result:=PtabSingle(t)^[nblig*(j-Jmin)+i-Imin];
end;

function TdataKLTbS.getP(i, j: integer): pointer;
begin
  result:=@PtabSingle(t)^[nblig*(j-Jmin)+i-Imin];
end;

procedure TdataKLTbS.setE(i, j: integer; w: float);
begin
  PtabSingle(t)^[nblig*(j-Jmin)+i-Imin]:=w;
end;

procedure TdataKLTbS.addE(i, j: integer; w: float);
var
  k:integer;
begin
  k:=nblig*(j-Jmin)+i-Imin;
  Ptabsingle(t)^[k]:=Ptabsingle(t)^[k]+w;
end;


{ TdataKLTbD }

constructor TdataKLTbD.create(var tb; i1, i2, j1, j2: integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=8;

  InitVar;
end;

constructor TdataKLTbD.createTab(i1, i2, j1, j2: integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(double));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;

function TdataKLtbD.getE(i, j: integer): float;
begin
  result:=PtabDouble(t)^[nblig*(j-Jmin)+i-Imin];
end;

function TdataKLtbD.getP(i, j: integer): pointer;
begin
  result:=@PtabDouble(t)^[nblig*(j-Jmin)+i-Imin];
end;

procedure TdataKLtbD.setE(i, j: integer; w: float);
begin
  PtabDouble(t)^[nblig*(j-Jmin)+i-Imin]:=w;
end;

procedure TdataKLtbD.addE(i, j: integer; w: float);
var
  k:integer;
begin
  k:=nblig*(j-Jmin)+i-Imin;
  PtabDouble(t)^[k]:=PtabDouble(t)^[k]+w;
end;



{ TdataKLTbScomp }

constructor TdataKLTbScomp.create(var tb; i1, i2, j1, j2: integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=8;

  InitVar;
end;

constructor TdataKLTbScomp.createTab(i1, i2, j1, j2: integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(TsingleComp));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;

function TdataKLTbScomp.getE(i, j: integer): float;
var
  z:TsingleComp;
begin
  z:=PtabSingleComp(t)^[nblig*(j-Jmin)+i-Imin];
  case modeCpx of
     0: result:= z.x;
     1: result:= z.y;
     2: result:=sqrt(sqr(z.x)+sqr(z.y));
     3: result:=arctan2(z.y,z.x);
   end;
end;


function TdataKLTbScomp.getP(i, j: integer): pointer;
begin
  result:=@PtabSingleComp(t)^[nblig*(j-Jmin)+i-Imin];
end;

procedure TdataKLTbScomp.setE(i, j: integer; w: float);
begin
  PtabSingleComp(t)^[nblig*(j-Jmin)+i-Imin].x:=w;
end;

procedure TdataKLTbScomp.addE(i, j: integer; w: float);
var
  k:integer;
begin
  k:=nblig*(j-Jmin)+i-Imin;
  PtabsingleComp(t)^[k].x:=PtabsingleComp(t)^[k].x+w;
end;

function TdataKLTbScomp.getIm(i, j: Integer): float;
begin
  result:=PtabSingleComp(t)^[nblig*(j-Jmin)+i-Imin].y;
end;

procedure TdataKLTbScomp.setIm(i, j: Integer; w: float);
begin
  PtabSingleComp(t)^[nblig*(j-Jmin)+i-Imin].y:=w;
end;

function TdataKLTbScomp.getCpx(i, j: Integer): TfloatComp;
begin
  with PtabSingleComp(t)^[nblig*(j-Jmin)+i-Imin] do
  begin
    result.x:=x;
    result.y:=y;
  end;
end;

procedure TdataKLTbScomp.setCpx(i, j: Integer; w: TfloatComp);
begin
  with PtabSingleComp(t)^[nblig*(j-Jmin)+i-Imin] do
  begin
    x:=w.x;
    y:=w.y;
  end;
end;

function TdataKLTbScomp.getMdl(i, j: Integer): float;
begin
  with PtabSingleComp(t)^[nblig*(j-Jmin)+i-Imin] do
  begin
    result:=sqrt(sqr(x)+sqr(y));
  end;
end;


{ TdataKLTbDcomp }

constructor TdataKLTbDcomp.create(var tb; i1, i2, j1, j2: integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=16;

  InitVar;
end;

constructor TdataKLTbDcomp.createTab(i1, i2, j1, j2: integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(TdoubleComp));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;



function TdataKLTbDcomp.getE(i, j: integer): float;
var
  z:TdoubleComp;
begin
  z:=PtabDoubleComp(t)^[nblig*(j-Jmin)+i-Imin];
  case modeCpx of
     0: result:= z.x;
     1: result:= z.y;
     2: result:=sqrt(sqr(z.x)+sqr(z.y));
     3: result:=arctan2(z.y,z.x);
   end;
end;


function TdataKLTbDcomp.getP(i, j: integer): pointer;
begin
  result:=@PtabDoubleComp(t)^[nblig*(j-Jmin)+i-Imin];
end;

procedure TdataKLTbDcomp.setE(i, j: integer; w: float);
begin
  PtabDoubleComp(t)^[nblig*(j-Jmin)+i-Imin].x:=w;
end;

procedure TdataKLTbDcomp.addE(i, j: integer; w: float);
var
  k:integer;
begin
  k:=nblig*(j-Jmin)+i-Imin;
  PtabDoubleComp(t)^[k].x:=PtabDoubleComp(t)^[k].x+w;
end;

function TdataKLTbDcomp.getIm(i, j: Integer): float;
begin
  result:=PtabDoubleComp(t)^[nblig*(j-Jmin)+i-Imin].y;
end;

procedure TdataKLTbDcomp.setIm(i, j: Integer; w: float);
begin
  PtabDoubleComp(t)^[nblig*(j-Jmin)+i-Imin].y:=w;
end;

function TdataKLTbDcomp.getCpx(i, j: Integer): TfloatComp;
begin
  with PtabDoubleComp(t)^[nblig*(j-Jmin)+i-Imin] do
  begin
    result.x:=x;
    result.y:=y;
  end;
end;

procedure TdataKLTbDcomp.setCpx(i, j: Integer; w: TfloatComp);
begin
  with PtabDoubleComp(t)^[nblig*(j-Jmin)+i-Imin] do
  begin
    x:=w.x;
    y:=w.y;
  end;
end;

function TdataKLTbDcomp.getMdl(i, j: Integer): float;
begin
  with PtabDoubleComp(t)^[nblig*(j-Jmin)+i-Imin] do
  begin
    result:=sqrt(sqr(x)+sqr(y));
  end;
end;



{******************** Méthodes de TdataTbMemLine *****************************}

function TdataTbMemLine.EltAd(i,j:integer):pointer;
begin
  result:=@PtabOctet(t)^[(nbcol*(j-Jmin)+i-Imin)*EltSize ];
end;


{******************** Méthodes de TdataTbIline *****************************}

constructor TdataTbIline.create(var tb;i1,i2,j1,j2:integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=2;

  InitVar;
end;

constructor TdataTbIline.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(smallint));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbIline.getI(i,j:integer):integer;
begin
  getI:=PtabEntier(t)^[nbcol*(j-Jmin)+i-Imin];
end;

procedure TdataTbIline.setI(i,j:integer;w:integer);
begin
  PtabEntier(t)^[nbcol*(j-Jmin)+i-Imin]:=w;
end;

procedure TdataTbIline.addI(i,j:integer;w:integer);
begin
  inc(PtabEntier(t)^[nbcol*(j-Jmin)+i-Imin],w);
end;

function TdataTbIline.getE(i,j:integer):float;
begin
  getE:=convZ(PtabEntier(t)^[nbcol*(j-Jmin)+i-Imin]);
end;

function TdataTbIline.getP(i,j:integer):pointer;
begin
  result:=@PtabEntier(t)^[nbcol*(j-Jmin)+i-Imin];
end;


procedure TdataTbIline.setE(i,j:integer;w:float);
begin
  PtabEntier(t)^[nbcol*(j-Jmin)+i-Imin]:=invConvZ(w);
end;

procedure TdataTbIline.addE(i,j:integer;w:float);
begin
  inc(PtabEntier(t)^[nbcol*(j-Jmin)+i-Imin],invConvZ(w));
end;



{******************** Méthodes de TdataTbL *****************************}

constructor TdataTbLline.create(var tb;i1,i2,j1,j2:integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=4;

  InitVar;
end;

constructor TdataTbLline.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(longint));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbLline.getI(i,j:integer):integer;
  begin
    getI:=PtabLong(t)^[nbcol*(j-Jmin)+i-Imin];
  end;

procedure TdataTbLline.setI(i,j:integer;w:integer);
  begin
    PtabLong(t)^[nbcol*(j-Jmin)+i-Imin]:=w;
  end;

procedure TdataTbLline.addI(i,j:integer;w:integer);
  begin
    inc(PtabLong(t)^[nbcol*(j-Jmin)+i-Imin],w);
  end;

function TdataTbLline.getE(i,j:integer):float;
  begin
    getE:=convZ(PtabLong(t)^[nbcol*(j-Jmin)+i-Imin]);
  end;

function TdataTbLline.getP(i,j:integer):pointer;
  begin
    result:=@PtabLong(t)^[nbcol*(j-Jmin)+i-Imin];
  end;

procedure TdataTbLline.setE(i,j:integer;w:float);
  begin
    PtabLong(t)^[nbcol*(j-Jmin)+i-Imin]:=invConvZ(w);
  end;

procedure TdataTbLline.addE(i,j:integer;w:float);
  begin
    inc(PtabLong(t)^[nbcol*(j-Jmin)+i-Imin],invConvZ(w));
  end;


{******************** Méthodes de TdataTbSline *****************************}

constructor TdataTbSline.create(var tb;i1,i2,j1,j2:integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=4;

  InitVar;
end;

constructor TdataTbSline.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(single));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbSline.getE(i,j:integer):float;
  begin
    getE:=PtabSingle(t)^[nbcol*(j-Jmin)+i-Imin];
  end;

function TdataTbSline.getP(i,j:integer):pointer;
begin
  result:=@PtabSingle(t)^[nbcol*(j-Jmin)+i-Imin];
end;


procedure TdataTbSline.setE(i,j:integer;w:float);
  begin
    PtabSingle(t)^[nbcol*(j-Jmin)+i-Imin]:=w;
  end;

procedure TdataTbSline.addE(i,j:integer;w:float);
  var
    k:integer;
  begin
    k:=nbcol*(j-Jmin)+i-Imin;
    Ptabsingle(t)^[k]:=Ptabsingle(t)^[k]+w;
  end;

{************************** Méthodes de TdataTbScompLine ***********************}

function TdataTbScompLine.getE(i, j: Integer): float;
var
  z:TsingleComp;
begin
  z:=PtabSingleComp(t)^[nbcol*(j-Jmin)+i-Imin];
  case modeCpx of
     0: result:= z.x;
     1: result:= z.y;
     2: result:=sqrt(sqr(z.x)+sqr(z.y));
     3: result:=arctan2(z.y,z.x);
   end;
end;

constructor TdataTbScompLine.createTab(i1,i2,j1,j2:integer);
begin
  getmem(t,(i2-i1+1)*(j2-j1+1)*sizeof(TSingleComp));
  create(t^,i1,i2,j1,j2);
  raz;
  FreeTbOnDestroy:=true;
end;


function TdataTbScompLine.getP(i, j: Integer): pointer;
begin
  result:=@PtabSingleComp(t)^[nbcol*(j-Jmin)+i-Imin];
end;

procedure TdataTbScompLine.setE(i, j: Integer; w: float);
begin
  PtabSingleComp(t)^[nbcol*(j-Jmin)+i-Imin].x:=w;
end;

procedure TdataTbScompLine.addE(i, j: Integer; w: float);
begin
  with PtabSingleComp(t)^[nbcol*(j-Jmin)+i-Imin] do x:=x+w;
end;

function TdataTbScompLine.getIm(i, j: Integer): float;
begin
  result:=PtabSingleComp(t)^[nbcol*(j-Jmin)+i-Imin].y;
end;

procedure TdataTbScompLine.setIm(i, j: Integer; w: float);
begin
  PtabSingleComp(t)^[nbcol*(j-Jmin)+i-Imin].y:=w;
end;

function TdataTbScompLine.getCpx(i, j: Integer): TfloatComp;
begin
  with PtabSingleComp(t)^[nbcol*(j-Jmin)+i-Imin] do
  begin
    result.x:=x;
    result.y:=y;
  end;
end;

procedure TdataTbScompLine.setCpx(i, j: Integer; w: TfloatComp);
begin
  with PtabSingleComp(t)^[nbcol*(j-Jmin)+i-Imin] do
  begin
    x:=w.x;
    y:=w.y;
  end;
end;

function TdataTbScompLine.getMdl(i, j: Integer): float;
begin
  with PtabSingleComp(t)^[nbcol*(j-Jmin)+i-Imin] do
  begin
    result:=sqrt(sqr(x)+sqr(y));
  end;
end;


constructor TdataTbScompLine.create(var tb; i1, i2, j1, j2: Integer);
begin
  t:=@tb;
  Imin:=i1;
  Imax:=i2;
  Jmin:=j1;
  Jmax:=j2;
  EltSize:=8;

  InitVar;
end;





end.
