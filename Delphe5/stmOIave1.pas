unit stmOIave1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,Dgraphic, debug0,

     stmDef,stmObj,
     varconf1,
     Ncdef2,stmError,stmPg,
     stmOIseq1,
     ippDefs,ipps,ippsovr;

type
  TOIseqAverage=class(TOIseq)
                private
                  Sx2:array of array of double;
                public
                  Count:longint;
                  stdDev:TOIseq;
                  FStdOn:boolean;


                  constructor create;override;
                  destructor destroy;override;

                  class function STMClassName:AnsiString;override;
                  function initialise(st:AnsiString):boolean;override;

                  procedure setChildNames;override;
                  procedure setChilds;

                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                  procedure saveToStream(f:Tstream;Fdata:boolean);override;
                  function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;

                  function loadFromStream1(f:Tstream;size:LongWord;Fdata:boolean):boolean;

                  Procedure Add(OIseq:TOIseq);

                  procedure update;

                  procedure reset;
                  procedure clear;override;

                  procedure setStdON(w:boolean);
                  property stdOn:boolean read FstdOn write setStdON;

                end;



{***************** Déclarations STM pour TOIseqAverage *****************************}
procedure proTOIseqAverage_create(var pu:typeUO);pascal;

Procedure proTOIseqAverage_Add(var p, pu:typeUO); pascal;

Procedure proTOIseqAverage_Update(var pu:typeUO); pascal;
procedure proTOIseqAverage_reset(var pu:typeUO);pascal;

function fonctionTOIseqAverage_Count(var pu:typeUO):longint;pascal;

procedure proTOIseqAverage_StdOn(w:boolean;var pu:typeUO); pascal;
function fonctionTOIseqAverage_StdOn(var pu:typeUO):boolean; pascal;

function fonctionTOIseqAverage_OIstdDev(var pu:typeUO):TOIseq;pascal;

IMPLEMENTATION


{********************** Méthodes de TOIseqAverage ****************************}

constructor TOIseqAverage.create;
begin
  inherited;

  stdDev:=TOIseq.create;
  stdDev.initMem(1,1,1,false,tpNum);
  stdON:=false;

  setChilds;
  AddTochildList(stdDev);
end;

destructor TOIseqAverage.destroy;
begin
  stdDev.free;

  inherited;
end;

class function TOIseqAverage.STMClassName:AnsiString;
begin
  STMClassName:='OIseqAverage';
end;

function TOIseqAverage.initialise(st:AnsiString):boolean;
begin
  result:= inherited initialise(st);
  if result then setChilds;
end;


procedure TOIseqAverage.setChildNames;
var
  i:integer;
begin
  with stdDev do
  begin
    ident:=self.ident+'.OIstdDev';
    notPublished:=true;
    Fchild:=true;
  end;
end;

procedure TOIseqAverage.setChilds;
begin
  setChildNames;
end;


procedure TOIseqAverage.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;

  with conf do
    setvarconf('Count',count,sizeof(count));
end;


procedure TOIseqAverage.saveToStream(f:Tstream;Fdata:boolean);
var
  i,old:integer;
begin
  old:=count;
  if not Fdata then count:=0;
  inherited saveToStream(f,Fdata);
  count:=old;

  stdDev.saveToStream(f,Fdata);
end;

function TOIseqAverage.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
  var
    st1:String[255];
    posf:LongWord;
    ok:boolean;
    posIni:LongWord;
    i:integer;
  begin
    ok:=inherited loadFromStream(f,size,Fdata);
    result:=ok;

    if not Fdata then count:=0;

    if not ok then
    begin
      setChilds;
      exit;
    end;

    if f.position>=f.Size  then
      begin
        result:=true;
        exit;
      end;

    posIni:=f.position;
    st1:=readHeader(f,longWord(size));
    ok:=(st1=TOIseq.stmClassName) and
        (stdDev.loadFromStream(f,size,Fdata)) and
        (stdDev.NotPublished);
    if not ok then
      begin
        f.Position:=Posini;
        result:=ok;
        setChilds;
        exit;
      end;

    setChilds;
    result:=ok;
  end;


function TOIseqAverage.loadFromStream1(f:Tstream;size:LongWord;Fdata:boolean):boolean;
begin
  result:=inherited loadFromStream(f,size,Fdata);
  setChilds;
end;


Procedure TOIseqAverage.Add(OIseq:TOIseq);
 var
  FlagMem:boolean;
  i:integer;
  tempBuf:array of double;
  tp:typetypeG;
begin
  if OIseq.Nframe=0 then exit;

  flagMem:=oiseq.InMemory;
  if not flagMem then oiseq.InMemory:=true;

  if count=0 then
  begin
    if oiseq.tpNum in [g_single,g_double]
      then tp:=oiseq.tpNum
      else tp:=G_single;
    initMem(OIseq.Nx,OIseq.Ny,OIseq.Nframe,OIseq.WithRefFrame,tp ,oiseq.Fcompact);

    dxu:=OIseq.Dxu;
    x0u:=OIseq.X0u;
    unitX:=OIseq.unitX;
    dyu:=OIseq.Dyu;
    y0u:=OIseq.y0u;
    unitY:=OIseq.unitY;

    setlength(Sx2,Nframe+ord(withRefFrame),Nx*Ny);
    for i:=0 to Nframe-1 +ord(withRefFrame) do
      fillchar(Sx2[i][0],Nx*Ny*8,0);
  end;

  setLength(tempBuf,Nx*Ny);

  ippsTest;
  if oiseq.InMemory then
  begin
    for i:=0 to Nframe-1 do
      ippsAdd(Psingle(oiseq.mainBuf[i]),Psingle(mainBuf[i]),Nx*Ny);
  end
  else
  begin
    for i:=0 to Nframe-1 do
      ippsAdd(oiseq.mat[i].tbS,Psingle(mainBuf[i]),Nx*Ny);
  end;

  if withRefFrame then
    ippsAdd(oiseq.matRef.tbS, matRef.tbS, Nx*Ny);

  if stdON then
  begin
    if oiseq.InMemory then
    begin
      for i:=0 to Nframe-1 do
      begin
        ippsConvert(Psingle(oiseq.mainBuf[i]),Pdouble(@TempBuf[0]),Nx*Ny);
        ippsSqr(Pdouble(@TempBuf[0]),Nx*Ny);
        ippsAdd(Pdouble(@TempBuf[0]),@Sx2[i][0],Nx*Ny);
      end;
    end
    else
    begin
      for i:=0 to Nframe-1 do
      begin
        ippsConvert(oiseq.mat[i].tbS,Pdouble(@TempBuf[0]),Nx*Ny);
        ippsSqr(Pdouble(@TempBuf[0]),Nx*Ny);
        ippsAdd(Pdouble(@TempBuf[0]),@Sx2[i][0],Nx*Ny);
      end;
    end;

    if withRefFrame then
    begin
      ippsConvert(oiseq.matref.tbS,Pdouble(@TempBuf[0]),Nx*Ny);
      ippsSqr(Pdouble(@TempBuf[0]),Nx*Ny);
      ippsAdd(Pdouble(@TempBuf[0]),@Sx2[Nframe][0],Nx*Ny);
    end;
  end;

  inc(count);
  ippsEnd;

  if not flagMem then oiseq.InMemory:=false;
end;

procedure TOIseqAverage.update;
var
  i:integer;
  tempBuf:array of double;
begin
  { Rappel:      sigma²=1/(N-1)*( Sx2 - ( Sx)²/N )

                 moy = Sx/N
  }
  if count>1 then
  begin
    ippsTest;

    if stdON then
    begin
      setLength(tempBuf,Nx*Ny);
      stdDev.initMem(Nx,Ny,Nframe,withRefFrame,tpNum,Fcompact);

      for i:=0 to Nframe-1 do
      begin
        ippsConvert(Psingle(mainBuf[i]),Pdouble(@TempBuf[0]),Nx*Ny);      { Sx }
        ippsSqr(Pdouble(@TempBuf[0]),Nx*Ny);                              { (Sx)² }
        ippsMulC(1/count,Pdouble(@TempBuf[0]),Nx*Ny);                     { (Sx)²/N }
        ippsSub(Pdouble(@TempBuf[0]),@Sx2[i][0],Nx*Ny);                   { Sx² - (Sx)²/N }
        ippsMulC(1/(count-1),Pdouble(@Sx2[i][0]),Nx*Ny);                  { ( Sx² - (Sx)²/N ) / (N-1) }
        ippsSqrt(Pdouble(@Sx2[i][0]),Nx*Ny);                              { racine }

        ippsConvert(Pdouble(@Sx2[i][0]),Psingle(stdDev.mainBuf[i]),Nx*Ny);
      end;

      if withRefFrame then
      begin
        ippsConvert(matref.tbS,Pdouble(@TempBuf[0]),Nx*Ny);               { Sx }
        ippsSqr(Pdouble(@TempBuf[0]),Nx*Ny);                              { (Sx)² }
        ippsMulC(1/count,Pdouble(@TempBuf[0]),Nx*Ny);                     { (Sx)²/N }
        ippsSub(Pdouble(@TempBuf[0]),@Sx2[Nframe][0],Nx*Ny);              { Sx² - (Sx)²/N }
        ippsMulC(1/(count-1),Pdouble(@Sx2[Nframe][0]),Nx*Ny);             { ( Sx² - (Sx)²/N ) / (N-1) }
        ippsSqrt(Pdouble(@Sx2[Nframe][0]),Nx*Ny);                         { racine }

        ippsConvert(Pdouble(@Sx2[Nframe][0]),stdDev.matRef.tbS,Nx*Ny);
      end;
    end;

    for i:=0 to Nframe-1 do
      ippsMulC(1/count,Psingle(mainBuf[i]),Nx*Ny);                        { moyenne= Sx/N }

    if withRefFrame then
      ippsMulC(1/count,matref.tbS,Nx*Ny);                                 { moyenne= Sx/N }

    ippsEnd;

    setlength(Sx2,0,0);
  end;
end;



procedure TOIseqAverage.reset;
begin
  count:=0;
  fill(0);
  stdDev.fill(0);
end;

procedure TOIseqAverage.clear;
begin
  reset;
end;


procedure TOIseqAverage.setStdON(w: boolean);
begin
  if count=0
    then FstdON:=w
    else sortieErreur('TOIseqAverage.StdON : count is not zero');
end;



{*********************** Méthodes STM pour TOIseqAverage ********************}

var
  E_typeNombre:integer;
  E_indexOrder:integer;

procedure proTOIseqAverage_create(var pu:typeUO);
begin
  createPgObject('',pu,TOIseqAverage);

  with TOIseqAverage(pu) do
  begin
    initMem(1,1,1,false,g_single,false);
  end;
end;


procedure proTOIseqAverage_StdOn(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseqAverage(pu).setStdON(w);
end;

function fonctionTOIseqAverage_StdOn(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=TOIseqAverage(pu).stdOn;
end;



Procedure proTOIseqAverage_Add(var p, pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(p);

  with TOIseqAverage(pu) do
  begin
    if (count>0) and ((TOIseq(p).Nx<>Nx) or (TOIseq(p).Ny<>Ny) or
                      (TOIseq(p).Nframe<>Nframe) or (TOIseq(p).withRefFrame<>withRefFrame)
                     )
      then sortieErreur('TOIseqAverage.Add : oiseq parameters does''nt match average parameters');
    add(TOIseq(p));
  end;
end;


Procedure proTOIseqAverage_Update(var pu:typeUO);
begin
  verifierObjet(pu);

  TOIseqAverage(pu).update;
end;


procedure proTOIseqAverage_reset(var pu:typeUO);
begin
  verifierObjet(pu);
  TOIseqAverage(pu).reset;
end;

function fonctionTOIseqAverage_Count(var pu:typeUO):longint;
begin
  verifierObjet(pu);
  fonctionTOIseqAverage_Count:=TOIseqAverage(pu).count;
end;


function fonctionTOIseqAverage_OIstdDev(var pu:typeUO):TOIseq;
begin
  verifierObjet(pu);
  with TOIseqAverage(pu) do result:=@stdDev.myAd;
end;



Initialization
AffDebug('Initialization stmOIave1',0);

registerObject(TOIseqAverage,data);

end.
