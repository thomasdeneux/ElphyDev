unit FicDefAc;
{Version Delphi}

{ La description de l'entête est dans fichac1.doc }
{ Pour imprimer les offsets, on peut utiliser offsetAC.Pas }

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,dtf0;

const
  maxMarqueAcq=100;

type
  TypeMarqueAcq=record
                  l:char;
                  n:SmallInt;
                end;
  typeTabMarqueAcq=array[1..maxMarqueAcq] of typeMarqueAcq;

const
  signatureAC1='ACQUIS1/GS/1991';
  tailleInfoAC1=1024;  { valeur minimale du bloc info }

type
  typeInfoAC1=object
                id:string[15];
                tailleInfo:SmallInt;
                nbvoie:byte;
                nbpt:SmallInt;
                uX:string[3];
                uY:array[1..6] of string[3];
                i1,i2:SmallInt;
                x1,x2:float;
                j1,j2:array[1..6] of SmallInt;
                y1,y2:array[1..6] of float;

                NbMacq:SmallInt;
                Macq:typeTabMarqueAcq;   { 300 octets }
                Xmini,Xmaxi,Ymini,Ymaxi:array[1..6] of float;
                modeA:array[1..6] of byte;
                continu:boolean;
                preseqI,postSeqI:SmallInt;
                EchelleSeqI:boolean;
                nbptEx:word;          { Qnbpt=nbptEx*32768+nbpt }

                x1s,x2s:single;
                y1s,y2s:array[1..6] of single;
                Xminis,Xmaxis,Yminis,Ymaxis:array[1..6] of single;
                nseq:SmallInt;
                tpData:typeTypeG;
                NoAnalogData:boolean;

                procedure init(taille:integer);
                             { Fixe la valeur de tailleInfo et la signature }
                (*
                procedure sauver(var f:file);
                             { Sauve un bloc de 1024 octets sans se soucier
                               de tailleInfo. Les champs au-del… de la taille
                               de typeInfoAc1 contiendront 0 }
                procedure charger(var f:file;var ok:boolean);
                *)
                function Fperiode:float;
                function FdureeSeq:float;
                procedure copierSingle;
              end;

  typeInfoSeqAC1=
              object
                uX:string[3];
                uY:array[1..6] of string[3];
                i1,i2:SmallInt;
                x1,x2:float;
                j1,j2:array[1..6] of SmallInt;
                y1,y2:array[1..6] of float;
                procedure init;
                procedure sauver(var f:file);
                procedure charger(var f:file);
              end;

const
  tokBoolean= 1;
  tokByte=    2;
  tokInteger= 3;
  tokLongint= 4;
  tokExtended=5;
  tokString=  6;

type
  typePostSeqRec=record
                   case tok:byte of
                     tokBoolean: (bb:boolean);
                     tokByte:    (xb:byte);
                     tokInteger: (xi:SmallInt);
                     tokLongint: (xl:longint);
                     tokExtended:(xe:float);
                     tokString:  (st:string[255]);
                   end;
  PtrPostSeqRec=^typePostSeqRec;



type
  typeInfoPostSeq=
            object
              tailleBuf:Integer;
              buf:PtabOctet;
              ad:Integer;
              procedure init(taille:integer);
              procedure done;

              procedure setByte(x:byte);
              procedure setBoolean(x:boolean);
              procedure setInteger(x:SmallInt);
              procedure setLongint(x:longint);
              procedure setExtended(x:float);
              procedure setString(st0:AnsiString);

              function getByte(n:integer):byte;
              function getBoolean(n:integer):boolean;
              function getInteger(n:integer):SmallInt;
              function getLongint(n:integer):longint;
              function getExtended(n:integer):float;
              function getString(n:integer):AnsiString;

              function suivant(p:PtrPostSeqRec):PtrPostSeqRec;

              procedure sauver(var f:file);
              procedure charger(var f:file);

              function getInfo(var x;nb,dep:integer):boolean;
              function setInfo(var x;nb,dep:integer):boolean;

              function readInfo(var x;nb:integer):boolean;
              function writeInfo(var x;nb:integer):boolean;
              procedure resetInfo;
            end;

typeInfoFich=object(typeInfoAc1)
               typeFich:SmallInt;
               longDat:longint;
               offtag:longint;
               spaceTag:longint;
               nbtag:word;
               error:SmallInt;
               procedure init;
               procedure charger(var f:file);

               function getDx:float;
               function getX0:float;
               function getDy(n:integer):float;
               function getY0(n:integer):float;


               function getTag(n:integer):longint;
             end;




IMPLEMENTATION

{********************* M‚thodes de typeInfoAc1 *****************************}

procedure typeInfoAC1.init(taille:integer);
  begin
    fillchar(self,sizeof(typeInfoAc1),0);
    id:=signatureAC1;
    tailleInfo:=taille;
  end;

(*
procedure typeInfoAC1.sauver(var f:file);
  var
    res:intG;
    buf:pointer;
  begin
    getmem(buf,1024);
    fillchar(buf^,1024,0);
    move(self,buf^,sizeof(typeInfoAC1));
    GblockWrite(f,buf^,1024,res);
    freemem(buf,1024);
  end;

procedure typeInfoAC1.charger(var f:file;var ok:boolean);
  var
    res:intG;
    buf:pointer;
  begin
    getmem(buf,1024);
    Gblockread(f,buf^,1024,res);
    move(buf^,self,sizeof(typeInfoAC1));
    freemem(buf,1024);
    ok:=(id=signatureAC1);
  end;
*)
function typeInfoAC1.Fperiode:float;
  begin
    if (i2<>i1) and (nbvoie<>0)
      then Fperiode:=(x2-x1)/(i2-i1)/nbvoie
      else Fperiode:=0;
  end;

function typeInfoAC1.FdureeSeq:float;
  begin
    FdureeSeq:=Fperiode*nbpt*nbvoie;
  end;

procedure typeInfoAC1.copierSingle;
  var
    i:integer;
  begin
    x1s:=x1;
    x2s:=x2;
    for i:=1 to 6 do
      begin
        y1s[i]:=y1[i];
        y2s[i]:=y2[i];

        XminiS[i]:=Xmini[i];
        XmaxiS[i]:=Xmaxi[i];
        YminiS[i]:=Ymini[i];
        YmaxiS[i]:=Ymaxi[i];

      end;
  end;


{********************* M‚thodes de typeInfoSeqAc1 **************************}

procedure typeInfoSeqAC1.init;
  begin
  end;

procedure typeInfoSeqAC1.sauver(var f:file);
  var
    res:integer;
  begin
    blockwrite(f,self,sizeof(typeInfoSeqAC1),res);
  end;

procedure typeInfoSeqAC1.charger(var f:file);
  begin
  end;

{********************* M‚thodes de typeInfoPostSeq *************************}

procedure typeInfoPostSeq.init(taille:integer);
  begin
    if (taille<=0) or (taille>maxavail) then
      begin
        buf:=nil;
        tailleBuf:=0;
      end
    else
      begin
        getmem(buf,taille);
        tailleBuf:=taille;
        ad:=0;
      end;
  end;

procedure typeInfoPostSeq.done;
  begin
    if tailleBuf<>0 then freemem(buf,tailleBuf);
    tailleBuf:=0;
    buf:=nil;
    ad:=0;
  end;

procedure typeInfoPostSeq.setBoolean(x:Boolean);
  var
    pp:PtrPostSeqRec;
  begin
    if (buf<>nil) and (ad+sizeof(Boolean)<tailleBuf) then
      begin
        pp:=@buf;
        inc(intG(pp),ad);
        with pp^ do
        begin
          tok:=tokBoolean;
          bb:=x;
          inc(ad,1+sizeof(Boolean));
        end;
      end;
  end;


procedure typeInfoPostSeq.setByte(x:Byte);
  var
    pp:PtrPostSeqRec;
  begin
    if (buf<>nil) and (ad+sizeof(Byte)<tailleBuf) then
      begin
        pp:=@buf;
        inc(intG(pp),ad);
        with pp^ do
        begin
          tok:=tokByte;
          xb:=x;
          inc(ad,1+sizeof(Byte));
        end;
      end;
  end;

procedure typeInfoPostSeq.setInteger(x:SmallInt);
  var
    pp:PtrPostSeqRec;
  begin
    if (buf<>nil) and (ad+sizeof(SmallInt)<tailleBuf) then
      begin
        pp:=@buf;
        inc(intG(pp),ad);
        with pp^ do
        begin
          tok:=tokInteger;
          xi:=x;
          inc(ad,1+sizeof(SmallInt));
        end;
      end;
  end;

procedure typeInfoPostSeq.setlongint(x:longint);
  var
    pp:PtrPostSeqRec;
  begin
    if (buf<>nil) and (ad+sizeof(longint)<tailleBuf) then
      begin
        pp:=@buf;
        inc(intG(pp),ad);
        with pp^ do
        begin
          tok:=tokLongint;
          xl:=x;
          inc(ad,1+sizeof(longint));
        end;
      end;
  end;

procedure typeInfoPostSeq.setExtended(x:float);
  var
    pp:PtrPostSeqRec;
  begin
    if (buf<>nil) and (ad+sizeof(float)<tailleBuf) then
      begin
        pp:=@buf;
        inc(intG(pp),ad);
        with pp^ do
        begin
          tok:=tokExtended;
          xe:=x;
          inc(ad,1+sizeof(extended));
        end;
      end;
  end;

procedure typeInfoPostSeq.setString(st0:AnsiString);
  var
    pp:PtrPostSeqRec;
  begin
    if (buf<>nil) and (ad+length(st0)+1<tailleBuf) then
      begin
        pp:=@buf;
        inc(intG(pp),ad);
        with pp^ do
        begin
          tok:=tokExtended;
          st:=st0;
          inc(ad,1+length(st)+1);
        end;
      end;
  end;

function typeInfoPostSeq.getBoolean(n:integer):boolean;
  var
    p:ptrPostSeqRec;
    i:integer;
  begin
    getBoolean:=false;
    if buf=nil then exit;
    p:=ptrPostSeqRec(buf);
    i:=1;
    while (i<n) and (p^.tok<>0) do
    begin
      inc(i);
      p:=suivant(p);
    end;
    if (i=n) and (p^.tok=tokBoolean) then getBoolean:=p^.bb;
  end;

function typeInfoPostSeq.suivant(p:ptrPostSeqRec):ptrPostSeqRec;
  var
    t:integer;
  begin
    case p^.tok of
      tokBoolean: t:=2;
      tokByte:    t:=2;
      tokInteger: t:=3;
      tokLongint: t:=5;
      tokExtended:t:=9;
      tokString:  t:=length(p^.st)+2;
      else        t:=0;
    end;
    inc(intG(p),t);
    suivant:=p;
  end;

function typeInfoPostSeq.getByte(n:integer):byte;
  var
    p:ptrPostSeqRec;
    i:integer;
  begin
    getByte:=0;
    if buf=nil then exit;
    p:=ptrPostSeqRec(buf);
    i:=1;
    while (i<n) and (p^.tok<>0) do
    begin
      inc(i);
      p:=suivant(p);
    end;
    if (i=n) and (p^.tok=tokByte) then getByte:=p^.xb;
  end;

function typeInfoPostSeq.getinteger(n:integer):SmallInt;
  var
    p:ptrPostSeqRec;
    i:integer;
  begin
    getinteger:=0;
    if buf=nil then exit;
    p:=ptrPostSeqRec(buf);
    i:=1;
    while (i<n) and (p^.tok<>0) do
    begin
      inc(i);
      p:=suivant(p);
    end;
    if (i=n) and (p^.tok=tokInteger) then getInteger:=p^.xi;
  end;

function typeInfoPostSeq.getLongint(n:Integer):Longint;
  var
    p:ptrPostSeqRec;
    i:integer;
  begin
    getLongint:=0;
    if buf=nil then exit;
    p:=ptrPostSeqRec(buf);
    i:=1;
    while (i<n) and (p^.tok<>0) do
    begin
      inc(i);
      p:=suivant(p);
    end;
    if (i=n) and (p^.tok=tokLongint) then getLongint:=p^.xl;
  end;

function typeInfoPostSeq.getExtended(n:Integer):float;
  var
    p:ptrPostSeqRec;
    i:integer;
  begin
    getExtended:=0;
    if buf=nil then exit;
    p:=ptrPostSeqRec(buf);
    i:=1;
    while (i<n) and (p^.tok<>0) do
    begin
      inc(i);
      p:=suivant(p);
    end;
    if (i=n) and (p^.tok=tokExtended) then getExtended:=p^.xe;
  end;

function typeInfoPostSeq.getString(n:Integer):AnsiString;
  var
    p:ptrPostSeqRec;
    i:integer;
  begin
    getString:='';
    if buf=nil then exit;
    p:=ptrPostSeqRec(buf);
    i:=1;
    while (i<n) and (p^.tok<>0) do
    begin
      inc(i);
      p:=suivant(p);
    end;
    if (i=n) and (p^.tok=tokString) then getString:=p^.st;
  end;



procedure typeInfoPostSeq.sauver(var f:file);
  var
    res:integer;
  begin
    if buf<>nil then blockwrite(f,buf^,tailleBuf,res);
  end;

procedure typeInfoPostSeq.charger(var f:file);
  var
    res:integer;
  begin
    if buf<>nil then blockread(f,buf^,tailleBuf,res);
  end;

function typeInfoPostSeq.getInfo(var x;nb,dep:integer):boolean;
  begin
    if (buf=nil) or (dep<0) or (tailleBuf<dep+nb) then
      begin
        fillchar(x,nb,0);
        getInfo:=false;
        exit;
      end;

    move(buf^[dep],x,nb);
    getInfo:=true;
  end;


function typeInfoPostSeq.setInfo(var x;nb,dep:integer):boolean;
  begin
    if (buf=nil) or (dep<0) or (tailleBuf<dep+nb)
      then setInfo:=false
      else
        begin
          move(x,buf^[dep],nb);
          setInfo:=true;
        end;
  end;

function typeInfoPostSeq.readInfo(var x;nb:integer):boolean;
  begin
    readInfo:=getInfo(x,nb,ad);
    inc(ad,nb);
  end;

function typeInfoPostSeq.writeInfo(var x;nb:integer):boolean;
  begin
    writeInfo:=setInfo(x,nb,ad);
    inc(ad,nb);
  end;

procedure typeInfoPostSeq.resetInfo;
  begin
    ad:=0;
  end;


{********************** M‚thodes de TypeInfoFich **************************}

procedure typeInfoFich.init;
  begin
    fillchar(self,sizeof(typeInfoFich),0);
    typeFich:=0;
  end;

procedure typeInfoFich.charger(var f:file);
  var
    res:integer;
    buf:pointer;
    

  function lireAC:boolean;
    begin
      lireAC:=false;
      with typeInfoAC1(buf^) do
      begin
        if id<>signatureAC1 then exit;
        move(buf^,self,sizeof(typeInfoAC1));
        typeFich:=5;
        longdat:=fileSize(f)-tailleInfo;
      end;
      lireAC:=true;
    end;

  function lirePCLAMP:boolean;
    type
      typeBufFetch=record
                     typeF:    single;
                     nbChan:   single;
                     nbSample: single;
                     nbEpisode:single;
                     Clock1:   single;
                     Clock2:   single;
                     bid1:     array[7..22] of single;
                     tagInfo:  single;
                     bid5:     array[24..30] of single;
                     ascending:single;
                     FirstChan:single;
                     bid2:     array[33..80] of single;
                     comment:  array[1..77] of char;
                     bid3:     array[1..243] of byte;
                     ExtOffset:array[0..15] of single;
                     ExtGain:  array[0..15] of single;
                     bid4:     array[1..32] of single;
                     unitM:    array[0..15] of array[1..8] of char;
                   end;

    var
      i,j:integer;
      v:array[1..6] of integer;
      res:integer;
    begin
      lirePclamp:=false;
      with typeBufFetch(buf^) do
      begin
        if (typeF<>1) and (typeF<>10) then exit;

        Continu:=(typeF=10);

        nbvoie:=roundI(nbChan);
        nbpt:=roundI(nbSample);

        v[1]:=roundI(firstChan) and $0F;
        if ascending=0
          then for i:=2 to nbVoie do v[i]:=(v[i-1]+1) and $0F
          else for i:=2 to nbVoie do v[i]:=(v[i-1]-1) and $0F;
        uX:='ms ';
        i1:=0;
        i2:=nbpt;
        x1:=0;
        x2:=Clock1*nbPt*nbVoie*0.001;

        if Continu then
        begin
          uX:='sec';
          X2:=x2/1000;
        end;


        for i:=1 to nbVoie do
          begin
            uY[i]:='';
            for j:=1 to 8 do
              if (unitM[v[i]][j]<>#0) and (unitM[v[i]][j]<>' ')
                then uY[i]:=uY[i]+unitM[v[i]][j];
            J1[i]:=0;
            J2[i]:=2048;
            Y1[i]:=extOffset[v[i]];
            if abs(extGain[v[i]])>1E-20 then
              Y2[i]:=10.0/extGain[v[i]]+extOffset[v[i]];
            {writeln(Estr(extGain[v[i]],9));}
          end;

        typeFich:=2;
        tailleInfo:=1024;
        longdat:=roundL(nbEpisode*nbSample*2);
        OffTag:=512*roundL(TagInfo);
        seek(f,OffTag);
        blockread(f,nbtag,2,res);
        inc(offTag,2);
        SpaceTag:=4;
      end;

      lirePclamp:=true;
    end;

  function lireABF:boolean;
    type
      Pinteger=^integer;
      Psingle=^single;
      Plongint=^longint;


    var
      i:integer;
      w:longint;
      v:integer;

      periode1{,periode2}:float;
      ADCres:longint;
      ADCrange,ScaleF:float;
      ADCdiv:integer;

      p:PtabOctet;
      seizeBit:boolean;

    function Finteger(n:integer):integer;
      begin
         Finteger:=Pinteger(@p^[n])^;
      end;

    function Fsingle(n:integer):single;
      begin
         Fsingle:=Psingle(@p^[n])^;
      end;

    function Flong(n:integer):longint;
      begin
         Flong:=Plongint(@p^[n])^;
      end;

    function Fstring(n,l:integer):AnsiString;
      var
        st:string[255];
      begin
        byte(st[0]):=l;
        move(p^[n],st[1],l);
        Fstring:=st;
      end;

    function numPhysique(n:integer):integer;   { n de 0 … 15 }
      begin
        numPhysique:=Finteger(410+n*2);
      end;

    begin
      p:=buf;

      lireABF:=false;
      if Fstring(0,4)<>'ABF ' then exit;

      TailleInfo:=512*Flong(40);

      w:=Finteger(8);
      Continu:= (w=1) or (w=3);

      nbvoie:=Finteger(120);

      nbpt:=Flong(138);
      if Continu then nbpt:=1000;

      uX:='ms ';

      Periode1:=Fsingle(122);
      {Periode2:=Fsingle(126);}

      i1:=0;
      i2:=nbpt;
      x1:=0;
      x2:=Periode1*nbPt*nbVoie*0.001;

      if Continu then
        begin
          uX:='sec';
          X2:=x2/1000;
        end;

      ADCres:=Flong(252);
      SeizeBit:=(ADCres>2048);
      if ADCres>=32768 then ADCdiv:=2 else ADCdiv:=1;

      ADCrange:=Fsingle(244);

      for i:=1 to nbVoie do
        begin
          v:=numPhysique(i-1);
          uY[i]:=Fstring(602+v*8,8);

          J1[i]:=0;
          J2[i]:=ADCres div ADCdiv;

          Y1[i]:=Fsingle(986+v*4);
          ScaleF:=Fsingle(922+v*4)*Fsingle(730+v*4)*ADCdiv;
          if SeizeBit then scaleF:=scaleF/16;
          if scaleF<>0
            then Y2[i]:=ADCrange/scaleF+Fsingle(986+v*4);
        end;

      typeFich:=7;
      longDat:=Flong(10)*2;

      OffTag:=512*Flong(44);
      nbtag:=Flong(48);
      SpaceTag:=64;

      lireABF:=true;
    end;

  procedure controle;
    var
      i:integer;
    begin
      if error<>0 then exit;
      if (nbvoie<1) or (nbvoie>6) then
        begin
          error:=2;
          exit;
        end;
      if (nbpt<1) then
        begin
          error:=3;
          exit;
        end;
      if (i1>=i2) or (x1>=x2) then
        begin
          error:=4;
          exit;
        end;

      for i:=1 to nbvoie do
        if not( (j1[i]<j2[i]) and (y1[i]<y2[i]) or
                (j2[i]<j1[i]) and (y2[i]<y1[i]) ) then
        begin
         {
          messageCentral(Istr(j1[i])+' '+Istr(j2[i])+' '+
                         Estr1(y1[i],15,5)+' '+Estr1(y2[i],15,5));
          }
          error:=5;
          exit;
        end;
    end;

  begin
    getmem(buf,1024);
    fillchar(buf^,1024,0);
    blockread(f,buf^,1024,res);

    error:=0;
    if not lireAC then
      if not LirePclamp then
        if not LireABF then
          error:=1;;

    freemem(buf,1024);
    controle;
    {messageCentral('Error='+Istr(error));}
  end;


function typeInfoFich.getDx:float;
  begin
    getDx:=(X2-X1)/(I2-I1);
  end;

function typeInfoFich.getX0:float;
  begin
     getX0:=X1-I1*getDx;
  end;

function typeInfoFich.getDy(n:integer):float;
  begin
    getDy:=(y2[n]-y1[n])/(j2[n]-j1[n]);
  end;

function typeInfoFich.getY0(n:integer):float;
  begin
    getY0:=Y1[n]-J1[n]*getDy(n);
  end;

function typeInfoFich.getTag(n:integer):longint;
  begin
    getTag:=0;
  end;




end.
