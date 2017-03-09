unit MatForMKL;

               N'est plus utilisée

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,math,sysutils,
     util1,mathKernel0,
     ISPGS1,stmISPL1,
     DtbEdit2;


{ MKL utilise la notation matricielle A[i,j]
    i numéro de ligne
    j numéro de colonne

  On note A(m,n) une matrice à m lignes et n colonnes

  Le stockage se fait colonne par colonne et l'adresse de l'élément (i,j) est
  j+nbLigne*i

  SetSize(m,n) change la taille en préservant les données existantes.
}

type
  TKLmat= class
          private
            Fdouble:boolean;
            t:pointer;
            Frow1,Frow2,Fcol1,Fcol2:integer;
            NbRow,NbCol:integer;
            Totsize:integer;
            EltSize:integer;

            QRtauS:array of single;
            QRtauD:array of double;

            procedure initVar;
            procedure sortie(st:string);

            function columnAd(n:integer):pointer;
          public
            constructor create(DoubleP:boolean;nRows,Ncols:integer);overload;
            constructor create(DoubleP:boolean;R1,R2,c1,c2:integer);overload;

            destructor destroy;override;

            function getE(i,j:integer):float;
            procedure setE(i,j:integer;w:float);

            procedure AddLines(nb:integer);
            procedure addCols(nb:integer);
            procedure RemoveLines(nb:integer);
            procedure removeCols(nb:integer);

            property Zvalue[i,j:integer]:float read getE write setE;default;
            property RowCount:integer read nbRow;
            property ColCount:integer read nbCol;
            property tab:pointer read t;

            property row1:integer read Frow1;
            property row2:integer read Frow2;
            property col1:integer read Fcol1;
            property col2:integer read Fcol2;

            Property Pcol[n:integer]:pointer read ColumnAd;

            procedure setSize(nRows,Ncols:integer);overload;
            procedure setSize(doubleP:boolean;nRows,Ncols:integer);overload;

            procedure clear;
            procedure copy(mat:TKLmat);

            procedure multiply(matA,matB:TKLmat; transA,transB:char);
            procedure mulNum(w:float);
            procedure solveLqr(trans:char;matB,matX:TKLmat;saveSelf:boolean);

            procedure solveCHK(matB,matX:TKLmat);

            procedure QRfactor;

            function compress2bits(var nb:integer):PtabOctet;
            procedure Decompress2bits(tbB:PtabOctet;nb:integer);

            function colSum(n:integer):float;
            procedure fill(w:float);
            procedure EditModal;

            procedure SVDS(matU,matV,sigma:TKLmat);
            procedure SVDD(matU,matV,sigma:TKLmat);
            procedure SVD(matU,matV,sigma:TKLmat);

          end;



IMPLEMENTATION



{Compression d'un tableau contenant seulement des 0, 1 et -1
 Chaque nombre est codé sur deux bits.
 Si N est le nb d'élts, on Nb= N div 4 +1 octets;
 Le facteur de compression est donc toujours 32
}

procedure DoubleToBits(tb:PtabDouble;nb:integer;tbB:PtabOctet);
{la mémoire allouée à tbB est nb div 4 +1 }
var
  i,j:integer;
  w:byte;
  dd:double;
begin
  i:=0;
  j:=0;
  repeat
    dd:=tb^[i];              {pour chaque nombre, on sauve deux bits }
    w:=w shl 1 + ord(dd<0);  {le premier vaut 1 pour les nbs strictement négatifs }
    w:=w shl 1 + ord(dd>0);  {le second vaut 1 pour les nbs strictement positifs }

    inc(i);
    if i mod 4=0 then
    begin
      tbB^[j]:=w;
      inc(j);
    end;
  until i>=nb;

  tb^[j]:=w;
end;

procedure BitsToDouble(tbB:PtabOctet;tb:PtabDouble; nb:integer);
{nb doit être connu. c'est le nb d'élts de tb}
var
  i,j:integer;
  w,z:byte;
begin
  i:=0;
  j:=0;
  w:=tbB^[i];
  repeat
    z:=w and $C0;              { on garde les 2 bits de poids fort }
    if z=0 then tb^[j]:=0
    else
    if z=1 shl 6 then tb^[j]:=1
    else tb^[j]:=-1;

    inc(j);
    w:=w shl 2;
    if j mod 4=0 then
    begin
      inc(i);
      w:=tbB^[i];
    end;
  until j>=nb;
end;


{******************** Méthodes de TKLmat *****************************}


procedure TKLmat.initvar;
var
  size:integer;
begin
  size:=totSize;

  nbRow:=Frow2-Frow1+1;
  nbCol:=Fcol2-Fcol1+1;
  totSize:=EltSize*nbcol*nbRow;
  reallocmem(t,totSize);

  if totSize>size
    then fillchar(PtabOctet(t)^[size],totSize-size,0);
end;


constructor TKLmat.create(DoubleP:boolean;r1,r2,c1,c2:integer);
begin
  Fdouble:=doubleP;
  Frow1:=r1;
  Frow2:=r2;
  Fcol1:=c1;
  Fcol2:=c2;

  if Fdouble
    then EltSize:=8
    else EltSize:=4;

  InitVar;
  if not initMKLib then messageCentral('MKL not initialized');

end;

constructor TKLmat.create(DoubleP:boolean;Nrows,Ncols:integer);
begin
  Fdouble:=doubleP;
  Frow1:=0;
  Frow2:=Nrows-1;
  Fcol1:=0;
  Fcol2:=Ncols-1;

  if Fdouble
    then EltSize:=8
    else EltSize:=4;

  InitVar;

  if not initMKLib then messageCentral('MKL not initialized');
end;

destructor TKLmat.destroy;
begin
  freemem(t);
end;

function TKLmat.getE(i,j:integer):float;
begin
  if Fdouble
    then result:=PtabDouble(t)^[nbrow*(j-Fcol1)+i-Frow1]
    else result:=Ptabsingle(t)^[nbrow*(j-Fcol1)+i-Frow1];
end;

procedure TKLmat.setE(i,j:integer;w:float);
begin
  if Fdouble
    then PtabDouble(t)^[nbrow*(j-Fcol1)+i-Frow1]:=w
    else PtabSingle(t)^[nbrow*(j-Fcol1)+i-Frow1]:=w;
end;

procedure TKLmat.addCols(nb:integer);
begin
  inc(Fcol2,nb);
  initvar;
end;

procedure TKLmat.removeCols(nb:integer);
begin
  dec(Fcol2,nb);
  if Fcol2<Fcol1 then Fcol2:=Fcol1-1;
  initvar;
end;


procedure TKLmat.AddLines(nb:integer);
var
  Isize,OldNbRow:integer;
  i:integer;
begin
  Isize:=EltSize*nbRow;
  OldNbRow:=nbRow;

  inc(Frow2,nb);
  initvar;

  for i:=nbCol-1 downto 0 do
  begin
    move(Ptaboctet(t)^[EltSize*OldNbRow*i],PtabOctet(t)^[EltSize*nbrow*i],Isize);
    fillchar(PtabOctet(t)^[EltSize*(nbrow*i+OldNbRow)],(nbrow-OldNbRow)*EltSize,0);
  end;
end;

procedure TKLmat.RemoveLines(nb:integer);
var
  Newsize,OldNbRow:integer;
  i:integer;
begin
  OldNbRow:=nbRow;

  dec(Frow2,nb);
  if Frow2<Frow1 then Frow2:=Frow1-1;
  nbRow:=Frow2-Frow1+1;

  Newsize:=EltSize*nbRow;
  for i:=0 to nbCol-1 do
    move(PtabOctet(t)^[EltSize*OldNbRow*i],PtabOctet(t)^[EltSize*nbrow*i],Newsize);

  initvar;
end;


procedure TKLmat.setSize(nRows, Ncols: integer);
begin
  if nRows>nbRow
    then addLines(nRows-nbRow)
    else removeLines(nbRow-nRows);

  if ncols>nbCol
    then addCols(ncols-nbCol)
    else removeCols(nbCol-nCols);

end;

procedure TKLmat.setSize(doubleP:boolean;nRows,Ncols:integer);
begin
  create(doubleP,nRows,Ncols);
end;


procedure TKLmat.clear;
begin
  fillchar(t^,totSize,0);
end;

procedure TKLmat.multiply(matA,matB: TKLmat; transA,transB:char);
var
  alpha,beta:single;
  alphaD,betaD:double;
  m,n,k:integer;
begin
  if matA.Fdouble<>matB.Fdouble then sortie('TKLmat.multiply Fdouble');


  if (transA='N') or (transA='n') then
  begin
    m:=matA.NbRow;
    k:=matA.NbCol;
  end
  else
  begin
    m:=matA.NbCol;
    k:=matA.NbRow;
  end;

  if (transB='N') or (transB='n') then
  begin
    n:=matB.NbCol;
    if matB.nbRow<>k then sortie('TKLmat.multiply invalid dim');
  end
  else
  begin
    n:=matB.NbRow;
    if matB.nbCol<>k then sortie('TKLmat.multiply invalid dim');
  end;

  setSize(matA.Fdouble,m,n);

  if Fdouble then
  begin
    alphaD:=1;
    betaD:=0;
    dgemm(transa,transb, m,n,k,alphaD,
                matA.t,matA.nbRow, matB.t,matB.nbRow,
                betaD,
                t,nbRow);
  end
  else
  begin
    alpha:=1;
    beta:=0;
    sgemm(transa,transb, m,n,k,alpha,
                matA.t,matA.nbRow, matB.t,matB.nbRow,
                beta,
                t,nbRow);
  end;
end;

procedure TKLmat.solveLqr(trans: char; matB, matX: TKLmat;saveSelf:boolean);
var
  lwork,info:integer;
  work:pointer;
  x:integer;
  tbB:PtabOctet;
  nbIni:integer;
begin
{ Self contient le système d'équations
  matB est le second membre
  matX est destinée à recevoir la solution

  On sauve d'abord Self car la matrice sera écrasée par la factorisation QR.
  On copie aussi matB dans matX car matX sera écrasée par la solution.

  En sortie, on restitue matX.
  On n'a donc rien perdu.
}

  if matB.Fdouble<>Fdouble then sortie('TKLmat.solveLqr invalid types');

  matX.copy(matB);           { copier second membre dans matX }
  if saveSelf then tbB:=compress2bits(nbIni); {Sauver Self en compressé }

  lwork:=1000000;
  getmem(work,lwork*EltSize);
  try
    if Fdouble
      then dgels(trans,nbRow,nbCol,matX.nbCol,t,nbRow,matX.t,matX.nbRow,
                 work, lwork , info)
      else sgels(trans,nbRow,nbCol,matX.nbCol,t,nbRow,matX.t,matX.nbRow,
                 work, lwork , info);
  finally
    freemem(work);

    if saveSelf then
    begin
      decompress2bits(tbB,nbIni);     {restituer Self }
      freemem(tbB);
    end;
  end;
end;

procedure TKLmat.solveChk(matB, matX: TKLmat);
var
  info:integer;
begin
  if matB.Fdouble<>Fdouble then sortie('TKLmat.solveLqr invalid types');

  matX.copy(matB);           { copier second membre dans matX }

  if Fdouble then
    begin
      dpotrf('U',nbrow,t,nbrow, info );
      dpotrs('U',nbrow,matX.nbcol,t,nbrow,matX.t,matX.nbrow, info );
    end
  else
    begin
      spotrf('U',nbrow,t,nbrow, info );
      spotrs('U',nbrow,matX.nbcol,t,nbrow,matX.t,matX.nbrow, info );
    end;

  { la matrice est d'abord Cholesky-factorisée, son contenu est donc modifié
    puis le système est résolu.
    matB est conservé.
  }
end;



procedure TKLmat.copy(mat:TKLmat);
begin
  setSize(mat.nbrow,mat.nbcol);
  move(mat.t^,t^,totSize);
end;



procedure TKLmat.sortie(st: string);
begin
  raise exception.create(st);
end;


procedure TKLmat.mulNum(w: float);
var
  n,incx:integer;
  a:single;
  ad:double;
begin
  n:=nbcol*nbrow;
  incx:=1;

  if Fdouble then
  begin
    ad:=w;
    dscal(n,ad,t,incx);
  end
  else
  begin
    a:=w;
    sscal(n,a,t,incx);
  end;
end;

procedure TKLmat.QRfactor;
var
  lwork,info:integer;
  work:pointer;
  ltau:integer;
begin
  lwork:=1000000;
  if nbrow>nbcol then ltau:=nbcol else ltau:=nbrow;

  getmem(work,lwork*EltSize);
  try
    if Fdouble then
    begin
      setLength(QRtauD,ltau);
      dgeqrf(nbRow,nbcol,t,nbrow,@QRtauD[0],work,lwork,info);
    end
    else
    begin
      setLength(QRtauS,ltau);
      sgeqrf(nbRow,nbcol,t,nbrow,@QRtauS[0],work,lwork,info);
    end;
  finally
    freemem(work);
  end;
end;




function TKLmat.compress2bits(var nb: integer): PtabOctet;
begin
  nb:=nbRow*nbCol;
  getmem(result,nb div 4+1);
  DoubleToBits(t,nb,result);
end;

procedure TKLmat.Decompress2bits(tbB: PtabOctet; nb: integer);
begin
  if nb<>nbRow*nbcol then exit;

  BitsToDouble(tbB,t, nb);
end;

function TKLmat.colSum(n: integer): float;
begin
  if Fdouble
    then result:= nspdSum(PCol[n], NbRow)
    else result:= nspsSum(PCol[n], NbRow);
end;

function TKLmat.columnAd(n: integer): pointer;
begin
  if Fdouble
    then result:=@PtabDouble(t)^[nbrow*(n-Fcol1)]
    else result:=@Ptabsingle(t)^[nbrow*(n-Fcol1)];
end;

procedure TKLmat.fill(w: float);
var
  i:integer;
begin
  if Fdouble then
    for i:=0 to nbrow*nbcol-1 do PtabDouble(t)^[i]:=w
  else
    for i:=0 to nbrow*nbcol-1 do Ptabsingle(t)^[i]:=w;
end;

procedure TKLmat.EditModal;
var
  decimale:array of byte;
  Editform:TarrayEditor;
begin
  setLength(decimale,nbCol);
  fillchar(decimale[0],nbcol,3);

  Editform:=TarrayEditor.create(nil);
  with EditForm do
  begin
    installe(Fcol1,Frow1,Fcol2,Frow2,decimale);
    caption:='';

    getTabValue:=getE;
    setTabValue:=setE;

    adjustFormSize;
    showModal;
  end;

  EditForm.free;
end;



procedure TKLmat.SVDD(matU, matV, sigma: TKLmat);
var
  upper:boolean;
  tt,dd,ee:array of double;
  tauq,taup:array of double;
  work:array of double;

  lwork:integer;
  mini:integer;
  info:integer;

  uplo:char;
begin
  upper:=nbRow>nbcol;
  if upper then mini:=nbcol else mini:=nbRow;

  setLength(dd,mini);
  setLength(ee,mini-1);
  setLength(tauq,mini);
  setLength(taup,mini);

  lwork:=(nbcol+nbrow)*64;
  setLength(work,lwork);
  dgebrd ( nbRow, nbCol, t, nbRow, @dd[0], @ee[0], @tauq[0], @taup[0], @work[0], lwork, info );

  matU.copy(self);
  dorgbr ( 'Q', nbrow,nbrow, nbcol, matU.t,matU.nbrow, @tauQ[0], @work[0], lwork, info );

  matV.copy(self);
  dorgbr ( 'P', nbcol,nbcol, nbrow, matV.t,matV.nbrow, @tauP[0], @work[0], lwork, info );

  if upper then uplo:='U' else uplo:='L';
  lwork:=(mini-1)*4;
  setLength(work,lwork);

  matU.setSize(true,nbRow,nbrow);
  matV.setSize(true,nbCol,nbCol);


  dbdsqr ( uplo, mini, nbRow, nbCol, 0, @dd[0], @ee[0],
           matV.t, matV.nbRow, matU.t,matU.nbrow, nil,0, @work[0], info );

  sigma.setSize(true,mini,1);
  move(dd[0],sigma.t^,sigma.NbRow*8);

end;

procedure TKLmat.SVDS(matU, matV, sigma: TKLmat);
begin
end;

procedure TKLmat.SVD(matU, matV, sigma: TKLmat);
begin
  if Fdouble
    then SVDD(matU, matV, sigma)
    else SVDS(matU, matV, sigma);
end;


end.
