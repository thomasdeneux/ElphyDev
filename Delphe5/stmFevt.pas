unit stmFevt;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes, sysutils,
     util1,dtf0,spk0,Dgraphic,
     Ncdef2,
     stmDef ;


procedure proResetEvtFile(numF:smallint;st:AnsiString;numS:integer);pascal;
procedure ProRewriteEvtFile(numF:smallint;st:AnsiString;dxF,dureeF:float;ux:AnsiString);pascal;
procedure proCloseEvtFile(numF:smallint);pascal;

function fonctionFgetEvt(numF,v:smallint;i:longint):float;pascal;
function fonctionFgetEvtL(numF,v:smallint;i:longint):longint;pascal;
procedure proFgetEvtX(numF:smallint;i:longint;var d:longint;var x:word);pascal;
procedure proFsetEvt(numF,v:smallint;d:float);pascal;
procedure proFsetEvtL(numF,v:smallint;d:longint);pascal;
procedure proFsetEvtX(numF,d:longint;x:word);pascal;

function FonctionFConvEvt(numF:smallint;i:longint):float;pascal;
function fonctionFnbEvt(numF,voie:smallint):longint;pascal;

procedure resetStmFevt;

implementation

const
  maxFichierEvt=10;
type
  typeFileEVT=   record
                   deltaXF,dureeSeqF:float;
                   uxF:String[3];
                   evt:typedataFileEV;
                 end;


var
  fichierEvt:array[1..maxFichierEvt] of ^typeFileEVT;



procedure controleEvt(numF:smallint);
  begin
    if (numF<1) or (numF>maxFichierEvt) then sortieErreur(E_NumFichier);
    if fichierEvt[numF]=nil then sortieErreur(E_fichierNonOuvert);
  end;

procedure proResetEvtFile(numF:smallint;st:AnsiString;numS:integer);
  var
    f:TfileStream;
    info:typeInfoSpk;
    ok:boolean;
    deb,fin:longint;
    n,m:longint;
    ev:typeSP;
    res:intG;
    count:longint;
  begin
    if numS<1 then numS:=1;
    if (numF<1) or (numF>maxFichierEvt) then sortieErreur(E_NumFichier);
    if st='' then sortieErreur(E_NomDeFichierIncorrect);

    if fichierEvt[numF]<>nil then sortieErreur(E_fichierDejaOuvert);

    new(fichierEvt[numF]);
    with fichierEvt[numF]^ do
    begin
      evt:=nil;
      f:=nil;
      try
      f:=TfileStream.Create(st,fmOpenReadWrite);

      info.charger(f,ok);

      if not ok then sortieErreur('Unable to open file '+st);

      deltaXF:=info.deltaX;
      dureeSeqF:=info.dureeSeq;
      uxf:=info.ux;

      f.Position:=info.tailleInfo;
      m:=0;
      deb:=f.Position;
      while (m<numS)  do
      begin
        res:=f.read(ev,sizeof(ev));
        if (res<>0) and (ev.x=0) then
          begin
            inc(m);
            deb:=f.Position+ev.date;
            f.Position:=deb;
          end;
      end;

      repeat
        res:=f.read(ev,sizeof(ev));
      until (ev.x=0) or (res<>sizeof(ev));

      count:=(f.Position-deb) div 6;
      if res=sizeof(ev) then dec(count);

      f.free;

      evt:=typeDataFileEv.create(st,deb,1,0,count-1,true);
      evt.setConversionX(DeltaXF,0);
      except
      f.Free;
      end;
    end;
  end;

function fonctionFgetEvt(numF,v:smallint;i:longint):float;
  begin
    controleEvt(numF);
    with fichierEvt[numF]^,evt do
    begin
      setMask(v-1);
      fonctionFgetEvt:=evt.getE(indicemin+i-1);
    end;
  end;

function fonctionFgetEvtL(numF,v:smallint;i:longint):longint;
  begin
    controleEvt(numF);
    with fichierEvt[numF]^,evt do
    begin
      setMask(v-1);
      fonctionFgetEvtL:=evt.getL(indicemin+i-1);
    end;
  end;

procedure proFgetEvtX(numF:smallint;i:longint;var d:longint;var x:word);
  begin
    controleEvt(numF);
    with fichierEvt[numF]^,evt do
    begin
      X:=getX(indicemin+i-1);
      d:=getD(indicemin+i-1);
    end;
  end;


procedure proFsetEvt(numF,v:smallint;d:float);
  begin
    controleEvt(numF);
    with fichierEvt[numF]^,evt do
    begin
      setMask(v-1);
      evt.setEvE(d);
    end;
  end;

procedure proFsetEvtL(numF,v:smallint;d:longint);
  begin
    controleEvt(numF);
    with fichierEvt[numF]^,evt do
    begin
      setMask(v-1);
      evt.setEvL(d);
    end;
  end;

procedure proFsetEvtX(numF,d:longint;x:word);
  begin
    controleEvt(numF);
    with fichierEvt[numF]^,evt do
    begin
      evt.setEvX(d-1,x);
    end;
  end;


procedure proCloseEvtFile(numF:smallint);
  begin
    controleEvt(numF);
    with fichierEvt[numF]^ do
      if evt<>nil then evt.free;
    dispose(fichierEvt[numF]);
    fichierEvt[numF]:=nil;
  end;

procedure ProRewriteEvtFile(numF:smallint;st:AnsiString;dxF,dureeF:float;ux:AnsiString);
  var
    f:TfileStream;
    ok:boolean;
    ev:typeSP;
    res:intG;
  begin
    if (numF<1) or (numF>maxFichierEvt) then sortieErreur(E_NumFichier);
    if st='' then sortieErreur(E_NomDeFichierIncorrect);

    if fichierEvt[numF]<>nil then sortieErreur(E_fichierDejaOuvert);

    new(fichierEvt[numF]);
    with fichierEvt[numF]^ do
    begin
      deltaXF:=dxF;
      dureeSeqF:=dureeF;
      uxf:=ux;
      evt:=nil;

      f:=nil;
      try
      f:=TfileStream.create(st,fmCreate);

      ecrireSPK(f,dxF,dureeF,uX,dureeF=0);
      fillchar(ev,sizeof(ev),0);
      f.write(ev,sizeof(ev));
      f.free;

      evt:=typeDataFileEv.create(st,128+sizeof(ev),1,0,-2,true);
      evt.setConversionX(DeltaXF,0);

      except
        f.Free;
        sortieErreur('Unable to create file '+st);
      end;
      
    end;
  end;

function FonctionFConvEvt(numF:smallint;i:longint):float;
  begin
    controleEvt(numF);
    with fichierEvt[numF]^,evt do
    begin
      FonctionFConvEvt:=convx(i);
    end;
  end;


function fonctionFnbEvt(numF,voie:smallint):longint;
  begin
    controleEVT(numF);
    controleParametre(voie,0,16);
    with fichierEvt[numF]^,evt do
    begin
      if voie=0 then fonctionFNbEvt:=indicemax-indicemin+1
                else fonctionFNbEvt:=statEV.n[voie-1];
    end;
  end;


procedure resetStmFevt;
  var
    i:integer;
  begin
    for i:=1 to maxFichierEvt do
      if fichierEvt[i]<>nil then
        begin
          with fichierEvt[i]^ do
          begin
            evt.free;
          end;
          dispose(fichierEvt[i]);
          fichierEvt[i]:=nil;
        end;
  end;


end.
