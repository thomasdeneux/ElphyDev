unit stmKLmat;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,sysutils,
     util1,Dgraphic,tbe0,stmdef,stmObj,stmDobj1,stmMat1,stmPg,Ncdef2,stmvec1,MathKernel0,debug0,
     VlistA1,
     ippdefs17, ipps17,
     DtbEdit2,
     stmMatU1,
     matlab_matrix,matlab_mat,
     stmSpkWave1, cyberK2;


const
  typesKLSupportes=[g_single,g_double,G_singleComp,G_doubleComp];

type
  TKLoperation=(normal,transpose,transConj);

type
  Tmat= class(Tmatrix)
          constructor create;overload;override;
          constructor create(tp:typetypeG;nRows, Ncols: integer);overload;
          constructor create32(tp:typetypeG;nRows, Ncols: integer);

          class function SupportType(tp:typetypeG):boolean;override;
          procedure initData(n1, n2, m1, m2: Integer; tNombre: typeTypeG);
          procedure initTemp(n1,n2,m1,m2:longint;tNombre:typeTypeG);override;
          procedure ReinitTemp;
          procedure addCols(nb:integer);
          procedure removeCols(nb:integer);
          procedure AddLines(nb:integer);
          procedure RemoveLines(nb:integer);
          procedure setSize(nRows, Ncols: integer);overload;
          procedure setSize(tp:typetypeG;nRows, Ncols: integer);overload;


          property RowCount:integer read nblig;
          property ColCount:integer read nbcol;

          class function STMClassName:AnsiString;override;

          procedure DsetI(i,j:integer;x:float);override;
          function DgetI(i,j:integer):float;override;

          procedure DsetE(i,j:integer;x:float);override;
          function DgetE(i,j:integer):float;override;
          function DgetColName(i:integer):AnsiString;

          procedure createEditForm;override;
          procedure DinvalidateCell(i,j:integer);override;

          procedure ColtoVec(n:integer;vec:Tvector);override;
          procedure VecToCol(vec:Tvector;n:integer);override;
          procedure LinetoVec(n:integer;vec:Tvector);override;
          procedure VecToLine(vec:Tvector;n:integer);override;

          procedure loadFromVector(vec:Tvector);

          procedure sortie(st:AnsiString);


          procedure prod(src1,src2:Tmat);overload;
          procedure prod(src1,src2:Tmat;op1,op2:TKLoperation);overload;
          procedure prod(src1,src2:Tmat;op1,op2:TKLoperation;alpha,beta:TdoubleComp);overload;
          procedure prod(src1:Tmat;src2:Tvector);overload;
          procedure prod(src1:Tmat;src2:Tvector;op1:TKLoperation);overload;

          procedure Mcov1(src:Tmat);
          procedure Mcov2(src:Tmat);
          procedure Mcov(src:Tmat;Fline:boolean);

          procedure copy(mat:Tmat);overload;
          procedure copy(vec:Tvector);overload;

          procedure extract(mat:Tmat;lig1,lig2,col1,col2:integer);
          procedure extractCol(mat:Tmat;j:integer);
          procedure extractRow(mat:Tmat;i:integer);
          procedure transpose;
          procedure ColMeans(mat:Tmat);
          procedure LineMeans(mat:Tmat);

          function FrobNorm:float;
          procedure normalizeFrob;

          procedure SVDS(matU,matV,sigma:Tmat);
          procedure SVDD(matU,matV,sigma:Tmat);
          procedure SVD(matU,matV,sigma:Tmat);

          procedure solveChk(matB, matX: Tmat);
          procedure solveLqr(trans: char; matB, matX: Tmat);
          function colSum(n:integer):float;

          function isZero:boolean;
          function getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;override;
          procedure setMxArray(mxArray:MxArrayPtr;Const invertIndices:boolean=false);override;
        end;


procedure proTmat_create(name:AnsiString;t:integer;i1,i2,j1,j2:longint;var pu:typeUO);pascal;

procedure proTmat_create_1(t:integer;i1,i2,j1,j2:longint;var pu:typeUO);pascal;
procedure proTmat_create_2(t:integer;nrow,ncol:longint;var pu:typeUO);pascal;


procedure proTmat_Mcov(var src:Tmat;Fline:boolean;var pu:typeUO);pascal;

procedure proTmat_prod(var src1,src2:Tmat;var pu:typeUO);pascal;
procedure proTmat_prod_1(var src1,src2:Tmat;op1,op2:integer;var pu:typeUO);pascal;
procedure proTmat_prod_2(var src1,src2:Tmat;op1,op2:integer;alpha,beta:TdoubleComp;var pu:typeUO);pascal;

procedure proTmat_prod1(var src1,src2:Tmat;op1,op2:integer;var pu:typeUO);pascal;
procedure proTmat_prod2(var src1,src2:Tmat;op1,op2:integer;alpha,beta:TdoubleComp;var pu:typeUO);pascal;

procedure proTmat_loadFromVector(var src:Tvector;var pu:typeUO);pascal;

procedure proMcov(var Vlist:TVlist;var dest:Tmat;Vexp:boolean);pascal;
procedure proMcov_1(var wf:TwavelistA;var dest:Tmat);pascal;

function fonctionEigenVectors1(var src,dest:Tmat;var Vec:Tvector):integer;pascal;

procedure proTmat_copy(var src:Tmat; var pu:typeUO);pascal;
procedure proTmat_extract(var src:Tmat;row1,row2,col1,col2:integer;var pu:typeUO);pascal;
procedure proTmat_extractCol(var src:Tmat;col:integer;var pu:typeUO);pascal;
procedure proTmat_extractRow(var src:Tmat;row:integer;var pu:typeUO);pascal;

procedure proTmat_LineMeans(var src:Tmat;var pu:typeUO);pascal;
procedure proTmat_ColMeans(var src:Tmat;var pu:typeUO);pascal;

procedure proTmat_transpose(var pu:typeUO);pascal;

function fonctionTmat_FrobNorm(var pu:typeUO):float;pascal;
procedure proTmat_normalizeFrob(var pu:typeUO);pascal;

procedure proTmat_add(var mat:Tmat;var pu:typeUO);pascal;
procedure proTmat_sub(var mat:Tmat;var pu:typeUO);pascal;
procedure proTmat_AddNum(w:TfloatComp;var pu:typeUO);pascal;
procedure proTmat_MulNum(w:TfloatComp;var pu:typeUO);pascal;

procedure proTmat_SVD(var matU,matV,sigma:Tmat;var pu:typeUO);pascal;

implementation



{ Tmat }

constructor Tmat.create;
begin
  inherited;

end;

constructor Tmat.create(tp:typetypeG;nRows, Ncols: integer);
begin
  inherited create;
  setSize(tp,nRows, Ncols);
end;

constructor Tmat.create32(tp:typetypeG;nRows, Ncols: integer);
begin
  Falign32Bytes:=true;
  create(tp,nRows,Ncols);
end;

class function Tmat.SupportType(tp:typetypeG):boolean;
begin
  result:=(tp in typesKLSupportes);
end;

procedure Tmat.initData(n1, n2, m1, m2: Integer; tNombre: typeTypeG);
begin
  data.free;
  data:=nil;

  with inf,visu do
  begin
    inf.imin:=n1;
    inf.imax:=n2;
    inf.jmin:=m1;
    inf.jmax:=m2;
  end;

  case tNombre of
    G_single:      data:=TdataKLtbS.create(tb^,n1,n2,m1,m2);
    G_double:      data:=TdataKLtbD.create(tb^,n1,n2,m1,m2);
    G_singleComp:  data:=TdataKLTbScomp.create(tb^,n1,n2,m1,m2);
    G_doubleComp:  data:=TdataKLTbDcomp.create(tb^,n1,n2,m1,m2);
  end;

  if data<>nil then
    begin
      data.ax:=inf.dxu;
      data.bx:=inf.x0u;
      data.ay:=inf.dyu;
      data.by:=inf.y0u;
      data.az:=inf.dzu;
      data.bz:=inf.z0u;
    end;

  invalidate;
end;


procedure Tmat.initTemp(n1, n2, m1, m2: Integer; tNombre: typeTypeG);
var
  taille:longint;

begin
  nblig:=n2-n1+1;
  nbcol:=m2-m1+1;
  taille:=tailleTypeG[tNombre]*nbCol*nbLig;

  TdataObj(self).initTemp0(tNombre,taille,true);

  initData(n1, n2, m1, m2,tNombre);
end;

procedure Tmat.ReinitTemp;
var
  size:integer;
begin
  size:=totSize;
  nblig:=Iend-Istart+1;
  nbCol:=Jend-Jstart+1;
  FtotSize:=int64(EltSize)*nbcol*nblig;
  if reallocmemory(size,totSize,true) then
  begin
    if totSize>size then fillchar(PtabOctet(tb)^[size],totSize-size,0);
  end
  else MemoryErrorMessage('Tmat.ReinitTemp in '+ident);
end;

procedure Tmat.addCols(nb:integer);
begin
  inc(inf.Jmax,nb);
  ReinitTemp;
end;

procedure Tmat.removeCols(nb:integer);
begin
  dec(inf.Jmax,nb);
  if inf.Jmax<inf.Jmin then inf.Jmax:=inf.Jmin-1;
  ReinitTemp;
end;


procedure Tmat.AddLines(nb:integer);
var
  Isize,OldNbRow:integer;
  i:integer;
begin
  Isize:=EltSize*RowCount;
  OldNbRow:=RowCount;

  inc(inf.Imax,nb);
  reinitTemp;

  for i:=ColCount-1 downto 0 do
  begin
    move(Ptaboctet(tb)^[EltSize*OldNbRow*i],PtabOctet(tb)^[EltSize*RowCount*i],Isize);
    fillchar(PtabOctet(tb)^[EltSize*(RowCount*i+OldNbRow)],(RowCount-OldNbRow)*EltSize,0);
  end;
end;

procedure Tmat.RemoveLines(nb:integer);
var
  Newsize,OldNbRow:integer;
  i:integer;
begin
  OldNbRow:=RowCount;

  dec(inf.Imax,nb);
  if inf.Imax<inf.Imin then inf.Imax:=inf.Imin-1;
  nblig:=inf.Imax-inf.Imin+1;

  Newsize:=EltSize*RowCount;
  for i:=0 to ColCount-1 do
    move(PtabOctet(tb)^[EltSize*OldNbRow*i],PtabOctet(tb)^[EltSize*RowCount*i],Newsize);

  reinitTemp;
end;


procedure Tmat.setSize(nRows, Ncols: integer);
var
  Fedit:boolean;
begin
  Fedit:=assigned(editForm) and editForm.visible;
  if Fedit then editForm.hide;

  if nRows>RowCount
    then addLines(nRows-RowCount)
    else removeLines(RowCount-nRows);

  if ncols>ColCount
    then addCols(ncols-ColCount)
    else removeCols(ColCount-nCols);

  initData(1,nRows,1,Ncols,tpNum);

  if assigned(editForm) then adjustEditForm;
  if Fedit then editForm.show;
end;

procedure Tmat.setSize(tp:typetypeG;nRows, Ncols: integer);
begin
  initTemp(1,Nrows,1,Ncols,tp);
end;


procedure Tmat.createEditForm;
begin
  deciSize:=(Jend-Jstart+1)*(1+ord(isComplex));
  setlength(Tbdeci,deciSize);
  fillchar(tbDeci[0],deciSize,3);

  if not assigned(editform)
    then Editform:=TtableEdit.create(formStm);

  with EditForm do
  begin
    installe(Jstart,Istart,Jend,Iend);
    caption:=ident;

    getTabValue:=DgetE;
    setTabValue:=DsetE;
    getColName:=DgetColName;

    getDeciValue:=self.getDeci;
    setDeciValue:=self.setDeci;

    invalidateCellD:=DinvalidateCell;
    invalidateVectorD:=DinvalidateVector;
    invalidateAllD:=DinvalidateAll;

    setKvalueD:=DsetKvalue;
    clearData:=self.clear;

    adjustFormSize;
    UseKvalue1.visible:=true;
  end;

end;

procedure Tmat.DinvalidateCell(i, j: integer);
begin
  FinvCell:=true;
  invCol:=j;
  invRow:=i;
  messageToRef(UOmsg_SimpleRefresh,nil);
  invalidateForm;
  FinvCell:=false;
end;



{ Calcul d'une matrice de covariance: chaque ligne de src est une réalisation
  d'un vecteur aléatoire.
  On obtient une matrice src.ColCount x src.ColCount
}
procedure Tmat.Mcov1(src: Tmat);
var
  i,j,nb1,nb2:integer;
  i1,i2:integer;
  m:array of double;
  p:array of pointer;
  ss:single;
  dd:double;


begin
  IPPStest;

  nb1:=src.ColCount;
  nb2:=src.nblig;
  initTemp(1,nb1,1,nb1,tpNum);

  setLength(p,nb1);
  with src do
  for i:=Jstart to Jend do p[i-Jstart]:=getP(Istart,i);

  setLength(m,nb1);
  for i:=0 to nb1-1 do
    case src.tpNum of
      G_single:  begin
                    ippsSum_32f(Psingle(p[i]),nb2,@ss,ippAlgHintNone);
                    m[i]:=ss/nb2;
                 end;
      G_double:  begin
                   ippsSum_64f(Pdouble(p[i]),nb2,@dd);
                   m[i]:=dd/nb2;
                 end;
    end;

  for i:=0 to nb1-1 do
  for j:=0 to i do
  begin
    case src.tpNum of
      G_single:  begin
                   ippsDotProd_32f(Psingle(p[i]),Psingle(p[j]), nb2, @ss);
                   Zvalue[i+1,j+1]:=ss/(nb2-1) - m[i]*m[j]*nb2/(nb2-1);
                 end;
      G_double:  begin
                   ippsDotProd_64f(Pdouble(p[i]),Pdouble(p[j]), nb2, Pdouble(@dd));
                   Zvalue[i+1,j+1]:=dd/(nb2-1) - m[i]*m[j]*nb2/(nb2-1);
                 end;
    end;
    Zvalue[j+1,i+1]:=Zvalue[i+1,j+1];
  end;
  IPPSend;
end;

{ Calcul d'une matrice de covariance: chaque colonne de src est une réalisation
  d'un vecteur aléatoire.
  On obtient une matrice src.ColCount x src.ColCount
}
procedure Tmat.Mcov2(src: Tmat);
var
  i,j,nb1,nb2:integer;
  i1,i2:integer;
  m:array of double;
  t:array of array of double;

  dd: double;
begin
  IPPStest;

  nb1:=src.nblig;
  nb2:=src.ColCount;
  initTemp(1,nb1,1,nb1,tpNum);

  with src do
  begin
    setLength(t,nblig,nbcol);
    for i:=Istart to Iend do
    for j:=Jstart to Jend do
      t[i-Istart,j-Jstart]:=Zvalue[i,j];
  end;


  setLEngth(m,nb1);
  for i:=0 to nb1-1 do
  begin
    ippsSum_64f(Pdouble(@t[i,0]),nb2,@dd);
    m[i]:=dd/nb2;
  end;

  for i:=0 to nb1-1 do
  for j:=0 to i do
  begin
    ippsDotProd_64f(Pdouble(@t[i,0]),Pdouble(@t[j,0]),nb2,Pdouble(@dd));
    Zvalue[i+1,j+1]:=dd/(nb2-1) - m[i]*m[j]*nb2/(nb2-1);

    Zvalue[j+1,i+1]:=Zvalue[i+1,j+1];
  end;

  IPPSend;
end;

procedure Tmat.Mcov(src: Tmat;Fline:boolean);
begin
  if Fline
    then Mcov1(src)
    else Mcov2(src);
end;

procedure Tmat.prod(src1, src2: Tmat);
var
  alpha,beta:single;
  alphaD,betaD:double;
  m,n,k:integer;
begin
  if not assigned(src1) or not assigned(src2) then sortie('Tmat.prod : invalid operands');
  if src1.tpNum<>src2.tpNum then sortie('Tmat.prod : invalid types');


  m:=src1.Nblig;            { (m,k) x (k,n) ==> (m,n)  }
  k:=src1.NbCol;

  if src2.nblig<>k then sortie('Tmat.prod : invalid dim');
  n:=src2.NbCol;


  initTemp(1,m,1,n,src1.tpNum);

  case tpNum of
    G_single:       sgemm('N','N', m,n,k, 1,
                    src1.tb,src1.nblig,src2.tb,src2.nblig ,
                    0, tb,nblig);
    G_double:       dgemm('N','N', m,n,k, 1,
                    src1.tb,src1.nblig,src2.tb,src2.nblig ,
                    0, tb,nblig);
    G_singleComp:   cgemm('N','N', m,n,k, singleComp(1,0),
                    src1.tb,src1.nblig,src2.tb,src2.nblig ,
                    singleComp(0,0), tb,nblig);
    G_doubleComp:   zgemm('N','N', m,n,k, doubleComp(1,0),
                    src1.tb,src1.nblig,src2.tb,src2.nblig ,
                    doubleComp(0,0), tb,nblig);
  end;

end;


const
  opName:array[TKLoperation] of char=('N','T','C');

procedure Tmat.prod(src1, src2: Tmat;op1,op2:TKLoperation);
var
  alpha,beta:single;
  alphaD,betaD:double;
  m,n,k:integer;
begin
  if not assigned(src1) or not assigned(src2) then sortie('Tmat.prod : invalid operands');
  if src1.tpNum<>src2.tpNum then sortie('Tmat.prod : invalid types');

  if op1=normal then
  begin
    m:=src1.Nblig;            { (m,k) x (k,n) ==> (m,n)  }
    k:=src1.NbCol;
  end
  else
  begin
    m:=src1.NbCol;
    k:=src1.Nblig;
  end;

  if op2=normal then
  begin
    if src2.nblig<>k then sortie('Tmat.prod : invalid dim');
    n:=src2.NbCol;
  end
  else
  begin
    if src2.nbcol<>k then sortie('Tmat.prod : invalid dim');
    n:=src2.Nblig;
  end;

  initTemp(1,m,1,n,src1.tpNum);

  case tpNum of
    G_single:       sgemm(opName[op1],opName[op2], m,n,k, 1,
                    src1.tb,src1.nblig,src2.tb,src2.nblig ,
                    0, tb,nblig);
    G_double:       dgemm(opName[op1],opName[op2], m,n,k, 1,
                    src1.tb,src1.nblig,src2.tb,src2.nblig ,
                    0, tb,nblig);
    G_singleComp:   cgemm(opName[op1],opName[op2], m,n,k, singleComp(1,0),
                    src1.tb,src1.nblig,src2.tb,src2.nblig ,
                    singleComp(0,0), tb,nblig);
    G_doubleComp:   zgemm(opName[op1],opName[op2], m,n,k, doubleComp(1,0),
                    src1.tb,src1.nblig,src2.tb,src2.nblig ,
                    doubleComp(0,0), tb,nblig);
  end;
end;

procedure Tmat.prod(src1, src2: Tmat;op1,op2:TKLoperation;alpha,beta:TdoubleComp);
var
  m,n,k:integer;
begin
  if not assigned(src1) or not assigned(src2) then sortie('Tmat.prod : invalid operands');
  if src1.tpNum<>src2.tpNum then sortie('Tmat.prod : invalid types');

  if op1=normal then
  begin
    m:=src1.Nblig;            { (m,k) x (k,n) ==> (m,n)  }
    k:=src1.NbCol;
  end
  else
  begin
    m:=src1.NbCol;
    k:=src1.Nblig;
  end;

  if op2=normal then
  begin
    if src2.nblig<>k then sortie('Tmat.prod : invalid dim');
    n:=src2.NbCol;
  end
  else
  begin
    if src2.nbcol<>k then sortie('Tmat.prod : invalid dim');
    n:=src2.Nblig;
  end;

  initTemp(1,m,1,n,src1.tpNum);

  case tpNum of
    G_single:       sgemm(opName[op1],opName[op2], m,n,k, alpha.x,
                    src1.tb,src1.nblig,src2.tb,src2.nblig ,
                    beta.x, tb,nblig);
    G_double:       dgemm(opName[op1],opName[op2], m,n,k, alpha.x,
                    src1.tb,src1.nblig,src2.tb,src2.nblig ,
                    beta.x, tb,nblig);
    G_singleComp:   cgemm(opName[op1],opName[op2], m,n,k, singleComp(alpha.x,alpha.y),
                    src1.tb,src1.nblig,src2.tb,src2.nblig ,
                    singleComp(beta.x,beta.y), tb,nblig);
    G_doubleComp:   zgemm(opName[op1],opName[op2], m,n,k, alpha,
                    src1.tb,src1.nblig,src2.tb,src2.nblig ,
                    beta, tb,nblig);
  end;

end;

procedure Tmat.prod(src1:Tmat;src2:Tvector);
var
  alpha,beta:single;
  alphaD,betaD:double;
  m,n,k:integer;
begin
  if not assigned(src1) or not assigned(src2) then sortie('Tmat.prod : invalid operands');
  if src1.tpNum<>src2.tpNum then sortie('Tmat.prod : invalid types');


  m:=src1.Nblig;            { (m,k) x (k,n) ==> (m,n)  }
  k:=src1.NbCol;

  if src2.Icount<>k then sortie('Tmat.prod : invalid dim');
  n:=1;


  initTemp(1,m,1,n,src1.tpNum);

  case tpNum of
    G_single:       sgemm('N','N', m,n,k, 1,
                    src1.tb,src1.nblig,src2.tb,k ,
                    0, tb,nblig);
    G_double:       dgemm('N','N', m,n,k, 1,
                    src1.tb,src1.nblig,src2.tb,k ,
                    0, tb,nblig);
    G_singleComp:   cgemm('N','N', m,n,k, singleComp(1,0),
                    src1.tb,src1.nblig,src2.tb,k ,
                    singleComp(0,0), tb,nblig);
    G_doubleComp:   zgemm('N','N', m,n,k, doubleComp(1,0),
                    src1.tb,src1.nblig,src2.tb,k ,
                    doubleComp(0,0), tb,nblig);
  end;
end;

procedure Tmat.prod(src1:Tmat;src2:Tvector;op1:TKLoperation);
var
  alpha,beta:single;
  alphaD,betaD:double;
  m,n,k:integer;
begin
  if not assigned(src1) or not assigned(src2) then sortie('Tmat.prod : invalid operands');
  if src1.tpNum<>src2.tpNum then sortie('Tmat.prod : invalid types');

  if op1=normal then
  begin
    m:=src1.Nblig;            { (m,k) x (k,n) ==> (m,n)  }
    k:=src1.NbCol;
  end
  else
  begin
    m:=src1.NbCol;
    k:=src1.Nblig;
  end;

  if src2.Icount<>k then sortie('Tmat.prod : invalid dim');
  n:=1;

  initTemp(1,m,1,n,src1.tpNum);

  case tpNum of
    G_single:       sgemm(opName[op1],'N', m,n,k, 1,
                    src1.tb,src1.nblig,src2.tb,k ,
                    0, tb,nblig);
    G_double:       dgemm(opName[op1],'N', m,n,k, 1,
                    src1.tb,src1.nblig,src2.tb,k ,
                    0, tb,nblig);
    G_singleComp:   cgemm(opName[op1],'N', m,n,k, singleComp(1,0),
                    src1.tb,src1.nblig,src2.tb,k ,
                    singleComp(0,0), tb,nblig);
    G_doubleComp:   zgemm(opName[op1],'N', m,n,k, doubleComp(1,0),
                    src1.tb,src1.nblig,src2.tb,k ,
                    doubleComp(0,0), tb,nblig);
  end;
end;

procedure Tmat.sortie(st: AnsiString);
begin
  raise exception.create(st);
end;

class function Tmat.STMClassName: AnsiString;
begin
  result:='Mat';
end;

function Tmat.DgetE(i, j: integer): float;
var
  index:integer;
begin
  if isComplex then
  begin
    index:=Jstart+(i-Jstart) div 2 ;
    case (i-Jstart) mod 2 of
      0: result:= Zvalue[j,index];
      1: result:= Imvalue[j,index];
    end;
  end
  else result:=Zvalue[j,i];
end;

function Tmat.DgetI(i, j: integer): float;
begin
  result:=getI(j,i);
end;

procedure Tmat.DsetE(i, j: integer; x: float);
var
  index:integer;
begin
  if isComplex then
  begin
    index:=Jstart+(i-Jstart) div 2 ;
    case (i-Jstart) mod 2 of
      0: Zvalue[j,index]:=x;
      1: Imvalue[j,index]:=x;
    end;
  end
  else Zvalue[j,i]:=x;
end;

procedure Tmat.DsetI(i, j: integer; x: float);
begin
  setI(j,i,roundL(x));
end;

function Tmat.DgetColName(i:integer):AnsiString;
var
  index:integer;
begin
  if isComplex then
  begin
    index:=Jstart+(i-Jstart) div 2 ;
    case (i-Jstart) mod 2 of
      0: result:= Istr(index)+'.Re';
      1: result:= Istr(index)+'.Im';
    end;
  end
  else result:= Istr(i);
end;

procedure TMat.LinetoVec(n: integer; vec: Tvector);
var
  i,sz:integer;
begin
  if (n<Istart) or (n>Iend) then sortieErreur('Tmat.lineToVec : index out of range');

  vec.initTemp1(Jstart,Jend,tpNum);
  vec.dxu:=dyu;
  vec.x0u:=y0u;
  vec.dyu:=dzu;
  vec.x0u:=z0u;

  sz:=tailleTypeG[tpNum];

  with vec do
  begin
    for i:=Istart to Iend do move(self.getP(n,i)^,data.getP(i)^,sz);
  end;
end;

procedure TMat.ColtoVec(n: integer; vec: Tvector);
var
  i,sz:integer;
begin
  if (n<Jstart) or (n>Jend) then sortieErreur('Tmat.ColToVec : index out of range');

  vec.initTemp1(Istart,Iend,tpNum);
  vec.dxu:=dxu;
  vec.x0u:=x0u;
  vec.dyu:=dzu;
  vec.x0u:=z0u;

  sz:=tailleTypeG[tpNum];

  with vec do
  begin
    for i:=Istart to Iend do move(self.getP(i,n)^,data.getP(i)^,sz);
  end;
end;


procedure TMat.VecToLine(vec: Tvector; n: integer);
var
  i,sz:integer;
begin
  if (n<Istart) or (n>Iend) then sortieErreur('Tmat.VecToLine : index out of range');

  if vec.Icount<>Jcount
    then sortieErreur('TMat.VecToLine : vec and matrix line have different sizes');

  if (vec.tpNum=tpNum) then
  begin
    sz:=tailleTypeG[tpNum];
    for i:=0 to Jcount-1 do
      move(vec.getP(vec.Istart+i)^,getP(n,Jstart+i)^,sz);
  end
  else
    for i:=0 to vec.Icount-1 do
      CpxValue[n,Jstart+i]:=vec.CpxValue[vec.Istart+i];
end;



procedure TMat.VecToCol( vec: Tvector;n: integer);
var
  i,sz:integer;
begin
  if (n<Jstart) or (n>Jend) then sortieErreur('TMat.VecToCol : index out of range' );
  if vec.Icount<>Icount
    then sortieErreur('TMat.VecToCol : vec and matrix column have different sizes');

  if vec.tpNum=tpNum then
  begin
    sz:=tailleTypeG[tpNum];
    for i:=0 to Icount-1 do move(vec.getP(vec.Istart+i)^,getP(Istart+i,n)^,sz);
  end
  else
    for i:=0 to Icount-1 do cpxValue[Istart+i,n]:=vec.CpxValue[vec.Istart+i];
end;


procedure TMat.loadFromVector(vec: Tvector);
begin
  initTemp(vec.Istart,vec.Iend,1,1,vec.tpNum);
  vecToCol(vec,1);
end;

procedure Tmat.copy(mat: Tmat);
var
  j:integer;
begin
  initTemp(mat.Istart,mat.Iend,mat.Jstart,mat.Jend,mat.tpNum);
  move(mat.getP(Istart,Jstart)^,getP(Istart,Jstart)^,totSize);
end;

procedure Tmat.copy(vec:Tvector);
var
  j:integer;
begin
  initTemp(vec.Istart,vec.Iend,1,1,vec.tpNum);
  move(vec.getP(Istart)^,getP(Istart,Jstart)^,totSize);
end;


procedure Tmat.extract(mat: Tmat; lig1,lig2,col1,col2: integer);
var
  j:integer;
begin
  initTemp(1,lig2-lig1+1,1,col2-col1+1,mat.tpNum);
  for j:=col1 to col2 do
    move(mat.getP(lig1,j)^,getP(1,j-col1+1)^,Icount*tailleTypeG[tpNum]);
end;



procedure Tmat.extractCol(mat: Tmat; j: integer);
begin
  initTemp(1,mat.Icount,1,1,mat.tpNum);
  move(mat.getP(mat.Istart,j)^,getP(1,1)^,totSize);
end;


procedure Tmat.extractRow(mat: Tmat; i: integer);
var
  j:integer;
begin
  initTemp(1,1,1,mat.Jcount,mat.tpNum);
  for j:=mat.Jstart to mat.Jend do
    move(mat.getP(i,j)^,getP(1,j-mat.Jstart+1)^,EltSize);
end;


procedure Tmat.ColMeans(mat: Tmat);
var
  j:integer;
  ss:single;
  dd:double;
  sc: TsingleComp;
  dc: TdoubleComp;
begin
  {On moyenne les colonnes, on obtient un vecteur ligne }

  initTemp(1,1,1,mat.Jcount,mat.tpNum);

  for j:=1 to Jcount do
  begin
    case tpNum of
      G_single: begin
                  ippsSum_32f(Psingle(mat.getP(mat.Istart,j+mat.Jstart-1)),mat.Icount,@ss,ippAlgHintNone);
                  Zvalue[1,j]:= ss/mat.Icount;
                end;
      G_double: begin
                  ippsSum_64f(Pdouble(mat.getP(mat.Istart,j+mat.Jstart-1)),mat.Icount,@dd);
                  Zvalue[1,j]:= dd/mat.Icount;
                end;

      G_singleComp: begin
                      ippsSum_32fc(PsingleComp(mat.getP(mat.Istart,j+mat.Jstart-1)),mat.Icount,@sc,ippAlgHintNone);
                      PsingleComp(getP(1,j))^.x:=sc.x/mat.Icount;
                      PsingleComp(getP(1,j))^.y:=sc.y/mat.Icount;
                    end;
      G_doubleComp: begin
                      ippsSum_64fc(PdoubleComp(mat.getP(mat.Istart,j+mat.Jstart-1)),mat.Icount,@dc);
                      PdoubleComp(getP(1,j))^.x:=dc.x/mat.Icount;
                      PdoubleComp(getP(1,j))^.y:=dc.y/mat.Icount;
                    end;
    end;
  end;
end;

procedure Tmat.LineMeans(mat: Tmat);
var
  i,j:integer;
  w:double;
begin
{ on moyenne les lignes, on obtient un vecteur colonne }
  initTemp(1,mat.Icount,1,1,mat.tpNum);

  for i:=mat.Istart to mat.Iend do
  begin
    w:=0;
    for j:=mat.Jstart to mat.Jend do w:=w+mat.Zvalue[i,j];
    Zvalue[i-mat.Istart+1,1]:=w;
  end;

  if tpNum>g_double then
  for i:=mat.Istart to mat.Iend do
  begin
    w:=0;
    for j:=mat.Jstart to mat.Jend do w:=w+mat.Imvalue[i,j];
    Imvalue[i-mat.Istart+1,1]:=w;
  end;

end;

procedure Tmat.transpose;
var
  mat:Tmat;
  i,j:integer;
begin
  mat:=Tmat.Create;
  try
  mat.initTemp(Istart,Iend,Jstart,Jend,tpNum);
  move(getP(Istart,Jstart)^,mat.getP(Istart,Jstart)^,totSize);

  initTemp(Jstart,Jend,Istart,Iend,tpNum);

  for i:=Istart to Iend do
  for j:=Jstart to Jend do
    move(mat.getP(j,i)^,getP(i,j)^,EltSize);

  finally
    mat.free;
  end;
end;


function Tmat.FrobNorm: float;
var
  ss: single;
  dd: double;
begin
  IPPStest;
  case tpNum of
    G_single:        begin
                       ippsNorm_L2_32f(Psingle(tb),Icount*Jcount,@ss);
                       result:=ss;
                     end;
    G_double:        begin
                       ippsNorm_L2_64f(Pdouble(tb),Icount*Jcount,@dd);
                       result:=dd;
                     end;
    G_singleComp:    begin
                       ippsNorm_L2_32fc64f(PsingleComp(tb),Icount*Jcount,@dd);
                       result:=dd;
                     end;
    G_doubleComp:    begin
                       ippsNorm_L2_64fc64f(PdoubleComp(tb),Icount*Jcount,@dd);
                       result:=dd;
                     end;
  end;

  IPPSend;
end;



procedure Tmat.normalizeFrob;
var
  w:float;
  sc: TsingleComp;
  dc: TdoubleComp;
begin
  w:=FrobNorm;
  if w=0 then exit;

  IPPStest;
  case tpNum of
    G_single:      ippsMulC_32f_I(1/w,Psingle(tb),Icount*Jcount);
    G_double:      ippsMulC_64f_I(1/w,Pdouble(tb),Icount*Jcount);
    G_singleComp:  begin
                     sc.x:=1/w;
                     sc.y:=0;
                     ippsMulC_32fc_I(sc,PsingleComp(tb),Icount*Jcount);
                   end;
    G_doubleComp:  begin
                     dc.x:=1/w;
                     dc.y:=0;
                     ippsMulC_64fc_I(dc,PdoubleComp(tb),Icount*Jcount);
                   end;
  end;

  IPPSend;
end;

procedure Tmat.SVDS(matU, matV, sigma: Tmat);
begin

end;

procedure Tmat.SVDD(matU, matV, sigma: Tmat);
var
  upper:boolean;
  tt,dd,ee:array of double;
  tauq,taup:array of double;
  work:array of double;

  lwork:integer;
  mini,maxi:integer;
  info:integer;

  uplo:char;
  i,j:integer;

  tb0:pointer;
  matUtb,matVtb:pointer;
  matUnbRow,matVnbRow:integer;
  matK:Tmat;

  nru,nrv:integer;

begin
  matK:=Tmat.create;
  TRY
  upper:=RowCount>=ColCount;
  if upper then
  begin
    mini:=ColCount;
    maxi:=RowCount;
  end
  else
  begin
    mini:=RowCount;
    maxi:=ColCount;
  end;

  setLength(dd,mini);
  setLength(ee,mini-1);
  setLength(tauq,mini);
  setLength(taup,mini);

  lwork:=(ColCount+RowCount)*64;
  setLength(work,lwork);

  if assigned(matU) then
  begin
    matU.setSize(g_double,maxi,maxi);
    for i:=IStart to Iend do
    for j:=Jstart to Jend do
      matU.Zvalue[i,j]:=Zvalue[i,j];
    tb0:=matU.tb;
  end
  else
  if assigned(matV) then
  begin
    matV.setSize(g_double,maxi,maxi);
    for i:=IStart to Iend do
    for j:=Jstart to Jend do
      matV.Zvalue[i,j]:=Zvalue[i,j];
    tb0:=matV.tb;
  end
  else
  begin
    matK.setSize(g_double,maxi,maxi);
    for i:=IStart to Iend do
    for j:=Jstart to Jend do
      matK.Zvalue[i,j]:=Zvalue[i,j];
    tb0:=matK.tb;
  end;

  dgebrd ( RowCount, ColCount, tb0, maxi, @dd[0], @ee[0], @tauq[0], @taup[0], @work[0], lwork, info );

  matUtb:=nil;
  matUnbRow:=maxi;
  matVtb:=nil;
  matVnbRow:=maxi;

  if assigned(matU) and assigned(matV) then matV.copy(matU);
  if assigned(matU) then
  begin
    matUtb:=matU.tb;
    matUnbRow:=matU.RowCount;
  end;
  if assigned(matV) then
  begin
    matVtb:=matV.tb;
    matVnbRow:=matV.RowCount;
  end;

  if assigned(matU) or assigned(matV) then
  begin
    dorgbr ( 'P', mini,ColCount, RowCount, matVtb,matVnbrow, @tauP[0], @work[0], lwork, info );
    dorgbr ( 'Q', RowCount,mini, ColCount, matUtb,matUnbrow, @tauQ[0], @work[0], lwork, info );
  end;

  if upper then uplo:='U' else uplo:='L';
  lwork:=mini*4;
  setLength(work,lwork);

  if assigned(matU)
    then nru:=RowCount
    else nru:=0;

  if assigned(matV)
    then nrv:=ColCount
    else nrv:=0;

  dbdsqr ( uplo, mini, nrv, nru, 0, @dd[0], @ee[0],
           matVtb, matVnbRow, matUtb,matUnbrow, nil,1, @work[0], info );

  if assigned(matU) then matU.setSize(RowCount,RowCount);
  if assigned(matV) then matV.setSize(ColCount,ColCount);

  sigma.setSize(g_double,mini,1);
  move(dd[0],sigma.tb^,sigma.RowCount*8);

  FINALLY
  matK.free;
  end;
end;

procedure Tmat.SVD(matU, matV, sigma: Tmat);
begin
  case tpNum of
    g_single: SVDS(matU, matV, sigma);
    g_double: SVDD(matU, matV, sigma);
  end;
end;

procedure Tmat.solveChk(matB, matX: Tmat);
var
  info:integer;
begin
  if not (tpNum in [G_single,G_double]) or ( matB.tpNum<>tpNum)
    then sortie('Tmat.solveLqr invalid types');

  matX.copy(matB);           { copier second membre dans matX }

  if tpNum=g_double then
    begin
      dpotrf('U',RowCount,tb,RowCount, info );
      if info>0 then sortieErreur('Unable to compute the Cholesky factorization')
      else
      if info<0 then sortieErreur('illegal parameter in Cholesky factorization');

      dpotrs('U',RowCount,matX.ColCount,tb,RowCount,matX.tb,matX.RowCount, info );
    end
  else
    begin
      spotrf('U',RowCount,tb,RowCount, info );
      if info>0 then sortieErreur('Unable to compute the Cholesky factorization')
      else
      if info<0 then sortieErreur('illegal parameter in Cholesky factorization');

      spotrs('U',RowCount,matX.ColCount,tb,RowCount,matX.tb,matX.RowCount, info );
    end;

  //IF info<>0 then messageCentral('SolveChk : error='+Istr(info));

  { la matrice est d'abord Cholesky-factorisée, son contenu est donc modifié
    puis le système est résolu.
    matB est conservé.
  }
end;

procedure Tmat.solveLqr(trans: char; matB, matX: Tmat);
var
  lwork,info:integer;
  work:array of byte;
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

  if not (tpNum in [G_single,G_double]) or ( matB.tpNum<>tpNum)
    then sortie('Tmat.solveLqr invalid types');

  matX.copy(matB);           { copier second membre dans matX }

  lwork:=1000000;
  setLength(work,lwork*EltSize);

  case tpNum of
    g_double: dgels(trans,RowCount,ColCount,matX.ColCount,tb,RowCount,matX.tb,matX.RowCount,
                    @work[0], lwork , info);
    g_single: sgels(trans,RowCount,ColCount,matX.ColCount,tb,RowCount,matX.tb,matX.RowCount,
                    @work[0], lwork , info);
  end;
end;


function Tmat.colSum(n:integer):float;
var
  i:integer;
begin
  result:=0;
  for i:=Istart to Iend do
    result:=result+Zvalue[i,n];
end;

function Tmat.isZero: boolean;
var
  i,j:integer;
begin
  result:=true;
  for i:=Istart to Iend do
  for j:=Jstart to Jend do
    if Zvalue[i,j]<>0 then
    begin
      result:=false;
      exit;
    end;
end;


function Tmat.getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;
var
  OKmove:boolean;
  complexity:mxComplexity;
  classID:mxClassID;
  t:pointer;
  i,j:integer;
  tpDest:typetypeG;
begin
  result:=nil;
  if not testMatlabMat then exit;
  if not testMatlabMatrix then exit;

  if (Icount<=0) or (Jcount<=0) then
  begin
    sortieErreur('Tmat.SaveToMatFile : source is empty');
    exit;
  end;

  if tpDest0=G_none
    then tpDest:=tpNum
    else tpDest:=tpDest0;

  if not (tpDest in MatlabTypes) then
  begin
    sortieErreur('Tmat.SaveToMatFile : invalid type');
    exit;
  end;

  classId:=TpNumToClassId(tpDest);
  complexity:=tpNumToComplexity(tpDest);

  OKmove:= inf.temp and (tpNum in [G_byte..G_double]) and (complexity=mxReal) and (tpNum=tpDest);

  result:=mxCreateNumericMatrix(Icount,Jcount,classID,complexity);
  if result=nil then
  begin
    sortieErreur('Tmat.SaveToMatFile : error 1');
    exit;
  end;
  t:= mxGetPr(result);
  if t=nil then
  begin
    sortieErreur('Tmat.SaveToMatFile : error 2');
    exit;
  end;

  if OKmove then  move(tb^,t^,Icount*Jcount*tailleTypeG[tpNum])
  else
  begin
    case tpDest of
      G_byte:         for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabOctet(t)^[i+Icount*j ]:=Kvalue[Istart+i,Jstart+j];
      G_short:        for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabShort(t)^[i+Icount*j ]:=Kvalue[Istart+i,Jstart+j];
      G_smallint:     for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabEntier(t)^[i+Icount*j ]:=Kvalue[Istart+i,Jstart+j];
      G_word:         for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabWord(t)^[i+Icount*j ]:=Kvalue[Istart+i,Jstart+j];
      G_longint:      for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabLong(t)^[i+Icount*j ]:=Kvalue[Istart+i,Jstart+j];
      G_single,
      G_singleComp:   for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabSingle(t)^[i+Icount*j ]:=Zvalue[Istart+i,Jstart+j];
      G_double,
      G_doubleComp,
      G_real,
      G_extended:     for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        PtabDouble(t)^[i+Icount*j ]:=Zvalue[Istart+i,Jstart+j];
    end;

    t:= mxGetPi(result);
    if (complexity=mxComplex) and assigned(t) then
      if tpDest=g_singleComp then
        for i:=0 to Icount-1 do
        for j:=0 to Jcount-1 do
          PtabSingle(t)^[i+Icount*j ]:=Zvalue[Istart+i,Jstart+j]
      else
        for i:=0 to Icount-1 do
        for j:=0 to Jcount-1 do
          PtabDouble(t)^[i+Icount*j ]:=Imvalue[Istart+i,Jstart+j];

  end;
end;

procedure Tmat.setMxArray(mxArray:MxArrayPtr;Const invertIndices:boolean=false);
var
  classID:mxClassID;
  isComp:boolean;
  t:pointer;
  tp:typetypeG;
  Nb1,Nb2:integer;
  i,j:integer;
begin
  if not assigned(mxArray) then exit;

  classID:=mxGetClassID(mxArray);
  isComp:= mxIsComplex(mxArray);
  tp:=classIDtoTpNum(classID,isComp);

  if not supportType(tp) then
  case tp of
    g_byte..g_longint: tp:=g_single;
  end;

  Nb1:=mxgetM(mxArray);
  Nb2:=mxgetN(mxArray);

  t:= mxGetPr(mxArray);

  if assigned(t) and (Nb1>0) and (Nb2>0) then
  begin
    initTemp(Istart,Istart+nb1-1,Jstart,Jstart+nb2-1,tp);
    case classID of
      mxInt8_class:   for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabShort(t)^[i+Icount*j];
      mxUInt8_class:  for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabOctet(t)^[i+Icount*j];

      mxInt16_class:  for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabEntier(t)^[i+Icount*j];
      mxUInt16_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabWord(t)^[i+Icount*j];

      mxInt32_class:  for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabLong(t)^[i+Icount*j];
      mxUInt32_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabLongWord(t)^[i+Icount*j];


      mxsingle_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabSingle(t)^[i+Icount*j];
      mxDouble_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Zvalue[Istart+i,Jstart+j]:=PtabDouble(t)^[i+Icount*j];
    end;

    t:= mxGetPi(mxArray);
    if assigned(t) and mxIsComplex(mxArray) then
    case classID of
      mxInt8_class:   for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabShort(t)^[i+Icount*j];
      mxUInt8_class:  for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabOctet(t)^[i+Icount*j];

      mxInt16_class:  for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabEntier(t)^[i+Icount*j];
      mxUInt16_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabWord(t)^[i+Icount*j];

      mxInt32_class:  for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabLong(t)^[i+Icount*j];
      mxUInt32_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabLongWord(t)^[i+Icount*j];


      mxsingle_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabSingle(t)^[i+Icount*j];
      mxDouble_class: for i:=0 to Icount-1 do
                      for j:=0 to Jcount-1 do
                        Imvalue[Istart+i,Jstart+j]:=PtabDouble(t)^[i+Icount*j];
    end;

  end;

end;

{******************** Méthodes STM pour Tmat *******************************}

procedure verifierMat(var pu:Tmat);
begin
  if (@pu=nil) or not assigned(pu) or not assigned(pu.data)
    then sortieErreur('invalidObject (Tmat)');
end;


procedure proTmat_create(name:AnsiString;
                   t:integer;i1,i2,j1,j2:longint;var pu:typeUO);
  begin
    if not (typeTypeG(t) in typesKLSupportes)
      then sortieErreur('Tmat.create : invalid type');

    if (i1>i2) or (j1>j2) then  sortieErreur('Tmat.create : bad index');

    createPgObject(name,pu,Tmat);
    with Tmat(pu) do
    begin
      initTemp(i1,i2,j1,j2,TypetypeG(t));
      autoscaleX;
      autoscaleY;
      setChildNames;
    end;
  end;

procedure proTmat_create_1(t:integer;i1,i2,j1,j2:longint;var pu:typeUO);
begin
  proTmat_create('', t,i1,i2,j1,j2, pu);
end;

procedure proTmat_create_2(t:integer;nrow,ncol:longint;var pu:typeUO);
begin
  proTmat_create('', t,1,nrow,1,ncol, pu);
end;



procedure createTmat(var pu:typeUO);
begin
  if not assigned(pu)
    then proTmat_create('',ord(g_single),0,0,0,0,pu);
end;

procedure proTmat_prod(var src1,src2:Tmat;var pu:typeUO);
begin
  verifierMat(src1);
  verifierMat(src2);

  createTmat(pu);
  Tmat(pu).prod(src1,src2);
end;

procedure proTmat_prod_1(var src1,src2:Tmat;op1,op2:integer;var pu:typeUO);
begin
  verifierMat(src1);
  verifierMat(src2);

  if (op1<0) or (op1>2) or (op2<0) or (op2>2)
    then sortieErreur('Tmat.prod : invalid operation');

  createTmat(pu);
  Tmat(pu).prod(src1,src2,TKLoperation(op1),TKLoperation(op2));
end;

procedure proTmat_prod_2(var src1,src2:Tmat;op1,op2:integer;alpha,beta:TdoubleComp;var pu:typeUO);pascal;
begin
  verifierMat(src1);
  verifierMat(src2);


  if (op1<0) or (op1>2) or (op2<0) or (op2>2)
    then sortieErreur('Tmat.prod : invalid operation');

  createTmat(pu);
  Tmat(pu).prod(src1,src2,TKLoperation(op1),TKLoperation(op2),alpha,beta);
end;


procedure proTmat_prod1(var src1,src2:Tmat;op1,op2:integer;var pu:typeUO);
begin
  proTmat_prod_1( src1,src2, op1,op2, pu);
end;

procedure proTmat_prod2(var src1,src2:Tmat;op1,op2:integer;alpha,beta:TdoubleComp;var pu:typeUO);
begin
  proTmat_prod_2(src1,src2, op1,op2,alpha,beta, pu);
end;

procedure proTmat_Mcov(var src:Tmat;Fline:boolean;var pu:typeUO);
var
  i,j,nb1,nb2:integer;
  i1,i2:integer;
  t:array of array of double;
  m:array of double;
begin
  verifierMat(src);

  createTmat(pu);
  Tmat(pu).Mcov(src,Fline);
end;



function fonctionEigenVectors1(var src,dest:Tmat;var Vec:Tvector):integer;
var
  work:pointer;
  lwork:integer;
  info:integer;
begin
  verifierMatrice(Tmatrix(src));
  verifierMatrice(Tmatrix(dest));
  verifierVecteur(Vec);
  if src=dest then sortieErreur('Dest must be different from src');

  if src.Icount<>src.Jcount
    then sortieErreur('Square matrix expected');
  Vmodify(vec,src.tpNum,1,src.Icount);

  MadjustIndexTpNum(src,dest);
  dest.copyDataFrom(src);

  lWork:=30*src.Icount;
  getmem(work,lwork*tailleTypeG[src.tpNum]);
  info:=0;

  try
  case src.tpNum of
    g_single: begin
                ssyev('V','U',src.Icount,dest.tb,src.Icount,vec.tb,work,lwork,info);
                //messageCentral('Work='+Estr(Psingle(work)^,3));
              end;
    g_double: begin
                dsyev('V','U',src.Icount,dest.tb,src.Icount,vec.tb,work,lwork,info);
                //messageCentral('Work='+Estr(Pdouble(work)^,3));
              end;
  end;
  finally
    freemem(work);
    result:=info;
  end;

end;

procedure proMcov(var Vlist:TVlist;var dest:Tmat;Vexp:boolean);
var
  i,j,nb1,nb2:integer;
  i1,i2:integer;
  t:array of array of double;
  m:array of double;
  dd:double;

begin
  IPPStest;

  verifierMat(dest);
  verifierobjet(typeUO(Vlist));

  with Vlist do
  begin
    if count<2 then sortieErreur('Vlist count must be higher than 2');
    i1:=vectors[1].Istart;
    i2:=vectors[1].Iend;
    for i:=2 to count do
      if (vectors[i].Istart<>i1) or (vectors[i].Iend<>i2)
       then sortieErreur('Vlist vectors must have equal bounds');
  end;

  if not Vexp then
  begin
    setLength(t,Vlist.count,i2-i1+1);
    for i:=1 to Vlist.count do
    for j:=i1 to i2 do
      t[i-1,j-i1]:=Vlist.Vectors[i].Yvalue[j];
  end
  else
  begin
    setLength(t,i2-i1+1,Vlist.count);
    for i:=1 to Vlist.count do
    for j:=i1 to i2 do
      t[j-i1,i-1]:=Vlist.Vectors[i].Yvalue[j];
  end;

  nb1:=length(t);
  nb2:=length(t[0]);
  Mmodify(dest,dest.tpNum,1,nb1,1,nb1);

  setLEngth(m,nb1);
  for i:=0 to nb1-1 do
  begin
    ippsSum_64f(Pdouble(@t[i,0]),nb2,@dd);
    m[i]:=dd/nb2;
  end;

  for i:=0 to nb1-1 do
  for j:=0 to i do
  begin
    ippsDotProd_64f(Pdouble(@t[i,0]),Pdouble(@t[j,0]),nb2,Pdouble(@dd));

    dest.Zvalue[i+1,j+1]:=dd/(nb2-1) - m[i]*m[j]*nb2/(nb2-1);
    dest.Zvalue[j+1,i+1]:=dest.Zvalue[i+1,j+1];
  end;
  IPPSend;
end;

procedure proMcov_1(var wf:TwavelistA;var dest:Tmat);
var
  i,j,nb1,nb2:integer;
  i0,i1,i2:integer;
  m:array of double;
  nblig,nbcol:integer;
  p0:PtabEntier;

  blocS:Tmat;
  Mbloc:integer;
  Neq:integer;
  w:double;
  Nstore:integer;
begin
  MKLtest;

  verifierMat(dest);
  verifierobjet(typeUO(wf));

  with wf do
  begin
    if maxindex<2 then sortieErreur('Wavelist count must be higher than 2');
    i1:=Istart;
    i2:=Iend;
  end;

  nb1:=i2-i1+1;
  nb2:=wf.maxIndex;
  Mmodify(dest,dest.tpNum,1,nb1,1,nb1);

  NbCol:=(wf.totSize+ElphySpkPacketFixedSize) div 2;
  NbLig:=wf.maxIndex;
  p0:=PtabEntier(wf.getPointer);
  i0:=ElphySpkPacketFixedSize div 2;

  setLength(m,nb1);
  fillchar(m[0],nb1*sizeof(m[0]),0);

  Mbloc:=1000;
  BlocS:=Tmat.create(G_double,Mbloc,nb1);
  Nstore:=0;

  for i:=0 to nb2-1 do
  begin
    for j:=0 to nb1-1 do
    begin
      w:=p0^[i0+j+ i*NbCol]*wf.Dyu;
      m[j]:=m[j]+w;
      BlocS[i mod Mbloc+1,j+1]:=w;
    end;
    inc(Nstore);

    if Nstore=Mbloc then
    begin
      dsyrk('U','T',Nb1,MBloc,1,BlocS.tb,Mbloc,1,dest.tb,Nb1);    { matH:= matH + BlocS'*BlocS }
      BlocS.clear;
      Nstore:=0;
    end;
  end;
  if Nstore>0 then
      dsyrk('U','T',Nb1,MBloc,1,BlocS.tb,Mbloc,1,dest.tb,Nb1);    { matH:= matH + BlocS'*BlocS }


  for i:=1 to dest.Iend do
  for j:=i to dest.Jend do
  begin
    dest[i,j]:=dest[i,j]/nb2 -m[i-1]*m[j-1]/sqr(Nb2);
    dest[j,i]:=dest[i,j];
  end;

  BlocS.Free;
  MKLend;
end;



procedure proTmat_loadFromVector(var src:Tvector;var pu:typeUO);
begin
  verifierVecteur(src);
  createTmat(pu);
  Tmat(pu).loadFromVector(src);
end;


procedure proTmat_extract(var src:Tmat;row1,row2,col1,col2:integer;var pu:typeUO);
begin
  verifierMat(src);
  createTmat(pu);

  if (row1<src.Istart) or (row1>src.Iend) or
     (row2<src.Istart) or (row2>src.Iend) or
     (row2<row1)  or
     (col1<src.Jstart) or (col1>src.Jend) or
     (col2<src.Jstart) or (col2>src.Jend) or
     (col2<col1)  then sortieErreur('Tmat.extract : index out of range');

  Tmat(pu).extract(src,row1,row2,col1,col2);

end;


procedure proTmat_extractCol(var src:Tmat;col:integer;var pu:typeUO);
begin
  verifierMat(src);
  createTmat(pu);

  if (col<src.Jstart) or (col>src.Jend)
     then sortieErreur('Tmat.extractCol : index out of range');

  Tmat(pu).extractCol(src,col);
end;

procedure proTmat_extractRow(var src:Tmat;row:integer;var pu:typeUO);
begin
  verifierMat(src);
  createTmat(pu);

  if (row<src.Istart) or (row>src.Iend)
     then sortieErreur('Tmat.extractRow : index out of range');

  Tmat(pu).extractRow(src,row);
end;


procedure proTmat_LineMeans(var src:Tmat;var pu:typeUO);
begin
  verifierMat(src);
  createTmat(pu);

  Tmat(pu).LineMeans(src);
end;

procedure proTmat_ColMeans(var src:Tmat; var pu:typeUO);
begin
  verifierMat(src);
  createTmat(pu);

  Tmat(pu).ColMeans(src);
end;

procedure proTmat_transpose(var pu:typeUO);pascal;
begin
  verifierMat(Tmat(pu));
  Tmat(pu).Transpose;
end;

procedure proTmat_copy(var src:Tmat; var pu:typeUO);
begin
  verifierMat(src);
  createTmat(pu);

  Tmat(pu).Copy(src);
end;

function fonctionTmat_FrobNorm(var pu:typeUO):float;
begin
  verifierMat(Tmat(pu));
  result:=Tmat(pu).FrobNorm;
end;

procedure proTmat_normalizeFrob(var pu:typeUO);
begin
  verifierMat(Tmat(pu));
  Tmat(pu).NormalizeFrob;
end;

procedure proTmat_add(var mat:Tmat;var pu:typeUO);
begin
  proMadd(Tmatrix(mat),Tmatrix(pu),Tmatrix(pu));
end;

procedure proTmat_sub(var mat:Tmat;var pu:typeUO);
begin
  proMsub(Tmatrix(pu),Tmatrix(mat),Tmatrix(pu));
end;

procedure proTmat_AddNum(w:TfloatComp;var pu:typeUO);
begin
  proMaddNum(Tmatrix(pu),w);
end;

procedure proTmat_MulNum(w:TfloatComp;var pu:typeUO);
begin
  proMmulNum(Tmatrix(pu),w);
end;

procedure proTmat_SVD(var matU,matV,sigma:Tmat;var pu:typeUO);
begin
  verifierMat(Tmat(pu));
  with Tmat(pu) do
  if (rowCount<1) or (colCount<1) then sortieErreur('Tmat_svd : invalid source size');

  createTMat(typeUO(sigma));     
  Tmat(pu).SVD(matU,matV,sigma);

end;



Initialization
AffDebug('Initialization stmKLMat',0);

registerObject(Tmat,data);

end.
