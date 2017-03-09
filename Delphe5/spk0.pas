unit Spk0;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
uses classes, sysutils,
     util1,Ncdef2,dtf0,Dgraphic;


const
  signatureSPK='ACQUIS1/SPK/GS/1996';
  tailleInfoSPK=128;  { valeur minimale du bloc info }
{$A-}
type
  typeInfoSPK=object
                id:string[20];
                tailleInfo:word;
                DeltaX:single;
                DureeSeq:single;
                uX:string[3];

                procedure init(taille:integer;dx,duree:float;unitx:AnsiString);
                procedure sauver( f:Tstream);
                procedure charger( f:Tstream;var ok:boolean);
              end;

type
  TstatEv= array[0..15] of longint;
  TrecEv=record
           debut:longint;              {Adresse du début du bloc info }
           info:longint;               {taille du bloc info }
           SpCount:longint;            {nombre d'événements total sans compter ev0}
           n:TstatEv;                  {nbs d'ev par voie }
           datemax:longint;            {date maximale }
         end;
  PrecEv=^TrecEv;

  {Rem: dans le fichier, on trouve:
    - l'entete
    - une suite de séquences formées de:
       - un ev de code 0 et date égale à la taille du bloc info
       - le bloc info
       - une suite d'ev

    Une séquence se termine quand on trouve un nouvel ev de code 0 ou à la fin
    du fichier.

    Le début d'une séquence est en TrecEv.debut-6
  }

type
  T16PtabLong=array[0..15] of PtabLong;
  TtabStatEv=class(Tlist)
             private
               function getStat(seq:integer):PrecEv;
             public
               unitXsp:string[10];
               DeltaXSP:double;
               DureeSeqSP:double;
               HeaderSize:integer;
               date:longint;
               ntot:TstatEv;
               stDat:AnsiString;

               procedure ajoute(deb:longint;inf:longint;cnt:longint;
                                var nb:TstatEv;max:longint);
               function initFile(st:AnsiString):boolean;
               procedure clear;override;

               property stat[seq:integer]:PrecEv read getStat;
               procedure loadSeq(numseq:integer;var p:T16PtabLong);
             end;



procedure ecrireSPK( f:Tstream;
                    periode,dureeSeq:float;unitX:AnsiString;continu:boolean);


IMPLEMENTATION


procedure typeInfoSPK.init(taille:integer;dx,duree:float;unitx:AnsiString);
  begin
    id:=signatureSPK;
    tailleInfo:=taille;
    if tailleInfo<tailleInfoSPK then tailleInfo:=tailleInfoSPK;
    deltaX:=dx;
    dureeSeq:=duree;
    ux:=unitx;
  end;

procedure typeInfoSPK.sauver(f:Tstream);
  var
    res:intG;
    buf:pointer;
  begin
    getmem(buf,tailleInfoSPK);
    fillchar(buf^,tailleInfoSPK,0);
    move(self,buf^,sizeof(typeInfoSPK));
    f.Write(buf^,tailleInfoSPK);
    freemem(buf,tailleInfoSPK);
  end;

procedure typeInfoSPK.charger(f:Tstream;var ok:boolean);
  var
    res:intG;
    buf:pointer;
  begin
    getmem(buf,tailleInfoSPK);
    f.Read(buf^,tailleInfoSPK);
    move(buf^,self,sizeof(typeInfoSPK));
    freemem(buf,tailleInfoSPK);
    ok:=(id=signatureSPK);
  end;

procedure ecrireSPK(f:Tstream;
                    periode,dureeSeq:float;unitX:AnsiString;continu:boolean);
  var
    info:typeInfoSPK;
  begin
    if continu then dureeSeq:=0;
    info.init(128,periode,dureeSeq,unitX);
    info.sauver(f);
  end;


procedure TtabStatEv.ajoute(deb:longint;inf:longint;cnt:longint;
                            var nb:TstatEv;max:longint);
  var
    p:PrecEv;
    i:integer;
  begin
    new(p);
    p^.debut:=deb;
    p^.info:=inf;
    p^.Spcount:=cnt;
    p^.n:=nb;
    p^.dateMax:=max;
    add(p);

    for i:=0 to 15 do inc(ntot[i],nb[i]);
    if max*deltaXSP>dureeSeqSP then dureeSeqSP:=max*deltaXSP;
  end;

procedure TtabStatEv.clear;
  var
    i:integer;
  begin
    for i:=0 to count-1 do
      dispose(PrecEv(items[i]));
    fillchar(ntot,sizeof(ntot),0);
    inherited clear;
  end;

function TtabStatEv.initFile(st:AnsiString):boolean;
  var
    f:TfileStream;
    res:intG;
    inf:typeInfoSpk;
    ok:boolean;
    deb,cnt:longint;
    TailleInf:word;
    ev:typeSP;
    j:integer;
    nb:TstatEv;
    datemax:longint;
  begin
    result:=false;
    clear;

    stDat:=st;
    f:=nil;
    try
    f:=TfileStream.create(st,fmOpenReadWrite);
    date:=fileGetDate(f.handle);

    fillchar(inf,sizeof(inf),0);
    inf.charger(f,ok);

    f.Position:=inf.tailleInfo;

    unitXsp:=inf.uX;
    DeltaXSP:=singleToEx(inf.deltaX);
    DureeSeqSP:=singleToEx(inf.dureeSeq);
    HeaderSize:=inf.tailleInfo;

    if ok  and (f.Size=headerSize) then
    begin
      result:=true;
      f.free;
      exit;
    end;

    f.read(ev,sizeof(ev));

    if not ok  or (ev.x<>0) then
    begin
      f.free;
      exit;
    end;

    fillchar(nb,sizeof(nb),0);
    datemax:=0;
    deb:=-1;
    repeat
      if ev.x=0 then
        begin
          if deb>=0 then
            begin
              cnt:=(f.Position-deb-tailleInf-6) div 6;
              ajoute(deb,tailleInf,cnt,nb,datemax);
              fillchar(nb,sizeof(nb),0);
            end;
          tailleInf:=ev.date;
          deb:=f.Position;            {deb pointe après ev0, sur le bloc info}
          f.Position:=f.Position+ev.date;
        end
      else
        begin
          for j:=0 to 15 do
            if ev.x and (word(1) shl j)<>0 then inc(nb[j]);
          if ev.date>datemax then datemax:=ev.date;
        end;
      f.read(ev,sizeof(ev));
    until (res<>sizeof(ev));

    cnt:=(f.Position-deb) div 6;
    ajoute(deb,TailleInf,cnt,nb,datemax);
    f.free;
    result:=true;

    except
    f.free;
    result:=false;
    end;
  end;

function TtabStatEv.getStat(seq:integer):PrecEv;
begin
  if (seq>=1) and (seq<=count)
    then result:=items[seq-1]
    else result:=nil;
end;

procedure TtabStatEv.loadSeq(numseq:integer;var p: T16PtabLong);
var
  i,j,pfile:integer;
  f:TfileStream;
  res:intG;
  ev:typeSP;
  nb,nbmax:array[0..15] of integer;
begin
  with stat[numseq]^ do
  begin
    for i:=0 to 15 do
      if (n[i]>0) and (n[i]<100000) then
      begin
        nbmax[i]:=n[i];
        getmem(p[i],n[i]*sizeof(longint));
      end;

    pfile:=debut+info;
  end;

  f:=nil;
  try
  f:=TfileStream.Create(stDat,fmOpenReadWrite);
  f.Position:=pfile;
  fillchar(nb,sizeof(nb),0);

  repeat
    res:= f.read(ev,sizeof(ev));

    for j:=0 to 15 do
      if ev.x and (word(1) shl j)<>0 then
      begin
        if nb[j]<nbmax[j]
          then p[j]^[nb[j]]:=ev.date;
          {else messageCentral('TtabstaEv.loadSeq error');}
        inc(nb[j]);
      end;
  until (res<>sizeof(ev)) or (ev.x=0) ;

  f.free;

  except
  f.free;
  end;

end;


end.
