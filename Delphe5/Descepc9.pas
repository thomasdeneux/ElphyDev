unit descEpc9;


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,sysUtils,
     util1,dtf0,debug0,descac1;


type
  TEPCrec=
        record
          Offset:longint;
          nbPt:longint;
          dy1,dy2:double;
          Fleak,FsecondTrace:boolean;
          dataForm:byte;
          dx:double;
          gr,se,sw:integer;
          recMode:byte;
        end;

  PEPCrec=^TEPCrec;

  TEPClist=class(Tlist)
             destructor destroy;override;
             procedure add(var m:TEPCrec);
           end;



  TEPCdescriptor=class(TfileDescriptor)

                 private
                   error:integer;
                   LevelCount:smallInt;
                   levelSize:array[1..5] of smallInt;
                   nbSweep:integer;

                   stimInt:PtabDouble1;
                   nbstim:smallInt;

                   LevelCountStim:smallInt;
                   levelSizeStim:array[1..5] of smallInt;

                   epcList:TepcList;

                   procedure charger(stPul,stpgf:AnsiString);
                   procedure readHeader(f:TfileStream);
                   procedure readRoot(f:TfileStream);
                   procedure readGroup(f:TfileStream;numG:integer);
                   procedure readSerie(f:TfileStream;numG,numS:integer);
                   procedure readSweep(f:TfileStream;numG,numS,numSW,mode:integer);

                   procedure ReadHeaderStim(f:TfileStream);
                   procedure readRootStim(f:TfileStream);
                   procedure readStimulation(f:TfileStream;numS:integer);
                   procedure readstimRecord(f:TfileStream;numS,numR:integer);

                 public
                   constructor create;override;
                   destructor destroy;override;

                   function init(st:AnsiString):boolean;override;

                   class function FileTypeName:AnsiString;override;
                   {function nbvoie:integer;override;

                   function nbSeqDat:integer;override;
                   function nbPtSeq(voie:integer):integer;override;
                   function getData(voie,seq:integer):PdataE;override;
                   function getTpNum(voie,seq:integer):typetypeG;override;
                   function dataFileAge:integer;override;
                   function FichierContinu:boolean;override;

                   procedure displayInfo(handle:Thandle);override;}

              end;

IMPLEMENTATION


{*************************** structures EPC9 ******************************}

const
  magicNumber=1701147220;

type
  stringType=array[0..13] of char;
  CommentType=array[0..79] of char;
  RootTextType=array[0..4,0..79] of char;

  userParamType=record
                  value: double;
                  name:  stringType;
                  Units: array[0..1] of char;
                end;

  recModeType=byte;
  epc9stateType=array[0..103] of byte;

  typeEPCheader=
          record
            magic:       longint;
            LevelCount:  longint;
            levelSize:   array[1..10] of longint;
          end;

  typeEPCroot=
         record
           version:      smallInt;
           versionName:  stringType;
           FileName:     stringType;
           Comments:     RootTextType;
           StartTime:    double;
         end;

  typeEPCgroup=
         record
           lbl:         stringType;
           text:        commentType;
           expNumber:   longint;
           extra:       double;
         end;

  typeEPCserie=
         record
           time:        double;
           bandW:       double;
           PipetteP:    double;
           CellP:       double;
           PipetteR:    double;
           SealR:       double;
           BGnoise:     double;
           Temperature: double;
           PipettePress:double;
           UserParam1:  UserParamType;
           UserParam2:  UserParamType;
           RecMode:     RecModeType;
           filler1:     boolean;
           comment:     commentType;

           EPC9state:   EPC9stateType;
           intSol,
           extSol:      longint;
           extraYunit1: array[0..1] of char;
           extraYunit2: array[0..1] of char;
           DispYunit1:  array[0..3] of char;
           DispYunit2:  array[0..3] of char;

           Furak:       double;
           FuraMin:     double;
           FuraMax:     double;

           LockInExtP:  double;
           timer:       double;
           extra:       array[0..3] of double;
         end;

         dataAbsType=byte;
         dataFormatType=(int16,int32,real32,real64);
         address=longint;
         set16=word;

  typeEPCsweep=
        record
           time:        double;
           stimCount:   longint;
           sweepCount:  longint;
           AveCount:    longint;
           leak:        boolean;
           secTrace:    boolean;
           lbl1:         stringType;
           DataPoints:  longint;
           Data:        longint;
           Dataptr:     address;

           DataFactor1: double;
           DataFactor2: double;
           Cslow,
           Gserie,
           RsValue,
           RsFrac,
           ZeroCur,
           OnLineY,
           onLineX:      double;

           TotalPoints:  longint;
           Offset:       longint;
           SweepKind:    set16;
           furaPoints:   longint;
           furaData:     longint;
           furaPtr:      Address;

           OnLineY2,
           onLineX2:     double;
           DispFactor1,
           DispFactor2:  double;

           DataFormat:   DataFormatType;
           DataAbs:      DataAbsType;
           timer:        double;

           Spares:       array[0..9] of char;

        end;

  typeStimRecord=
        record
          bid:array[1..10] of byte;
        end;

  Ttrigger=
        record
          seg:         smallInt;
          time:        double;
          len:         double;
          amp:         double;
          dac:         smallInt;
        end;

  typeStimulation=
        record
          fileName:       array[0..13] of char;
          entryName:      array[0..13] of char;
          sampleInterval: double;
          filterFactor:   double;
          sweepInterval:  double;
          Nsweep:         longint;
          Nrepeat:        longint;
          RepeatWait:     double;
          LKseq:          array[0..13] of char;
          LKwait:         double;

          LKcount:        longint;
          LKsize:         double;

          LKhold:         double;
          LKalt:          boolean;
          AltLKAve:       boolean;
          LKdelay:        double;
          trig:           array[0..2] of Ttrigger;

          Ntrig:          smallInt;
          RXseg:          smallInt;
          RYseg:          smallInt;

          writeMode:      byte;
          IncMode:        byte;

          totSWlen:       longint;
          maxSwLen:       longint;

          inputCh:        smallInt;
          gu:             byte;

          relAbs:         boolean;
          hasCont:        boolean;
          LogInc:         boolean;

          stimDac:        smallInt;
          adc1:           smallInt;
          adc2:           smallInt;
          Yunit1:         array[0..1] of char;
          Yunit2:         array[0..1] of char;

          VmemInc:        single;
          extTrig:        byte;
          FileTmp:        boolean;
          stimKind:       word;

          LockInCycle:    double;
          LockInAmp:      double;

          furaOn:         boolean;
          VmemMode:       byte;

          F1,F2,F3,F4,F5,F6,F7:double;
          FR:             smallInt;

          LNskip:         longint;
          LNrev:          double;
          lnMode:         byte;
          CfgMacro:       array[0..15] of char;
          endMacro:       array[0..15] of char;

          ampModeKind:    byte;
          filler1:        boolean;
        end;

  typeRootStim=
       record
         version:smallInt;
       end;

{************************ routines de conversion UNIX **********************}

function SmallUnix(w1:smallint):smallint;
  var
    t1:array[1..2] of byte ABSOLUTE w1;
    w2:smallint;
    t2:array[1..2] of byte ABSOLUTE w2;
    i:integer;
  begin
    for i:=1 to 2 do t2[3-i]:=t1[i];
    SmallUnix:=w2;
  end;


function longUnix(w1:longint):longint;
  var
    t1:array[1..4] of byte ABSOLUTE w1;
    w2:longint;
    t2:array[1..4] of byte ABSOLUTE w2;
    i:integer;
  begin
    for i:=1 to 4 do t2[5-i]:=t1[i];
    longUnix:=w2;
  end;

function doubleUnix(w1:double):double;
  var
    t1:array[1..8] of byte ABSOLUTE w1;
    w2:double;
    t2:array[1..8] of byte ABSOLUTE w2;
    i:integer;
  begin
    for i:=1 to 8 do t2[9-i]:=t1[i];
    doubleUnix:=w2;
  end;

function getString(var t;long:integer):AnsiString;
begin
  setlength(result,long);
  move(t,result[1],long);
end;

{****************** Méthodes de TEPClist ************************************}

destructor TEPClist.destroy;
var
  i:integer;
begin
  for i:=0 to count-1 do dispose(PepcRec(items[i]));
  inherited destroy;
end;

procedure TEPClist.add(var m:TepcRec);
var
  p:PepcRec;
begin
  new(p);
  p^:=m;
  inherited add(p);
end;



{*********************** Methodes de TEPCdescriptor **************************}

constructor TEPCdescriptor.create;
  begin
    epcList:=TepcList.create;

  end;

destructor TEPCdescriptor.destroy;
  begin
    if assigned(stimInt) then freeMem(stimInt,sizeof(double)*nbstim);
    epcList.free;
  end;


procedure TEPCdescriptor.readSweep(f:TfileStream;numG,numS,numSW,mode:integer);
  var
    res:intG;
    i:integer;
    nb:longint;
    recSweep:typeEPCsweep;
    p:longint;
    ch:char;
    stmCnt:longint;
    sweep:TEPCrec;
  begin
    error:=3;
    p:=f.Position;
    inc(nbSweep);
    f.read(recSweep,sizeof(recSweep));
    f.Position:=p+levelSize[4];

    f.read(nb,sizeof(nb));

    with recSweep,sweep do
    begin
      Offset:=longUnix(data);
      nbPt:=longUnix(dataPoints);
      dy1:=doubleUnix(dataFactor1);
      dy2:=doubleUnix(dataFactor2);
      Fleak:=leak;
      FsecondTrace:=secTrace;
      dataForm:=ord(dataFormat);
      stmCnt:=longUnix(stimCount);
      dx:=stimInt^[stmCnt];
      gr:=numG;
      se:=numS;
      sw:=numSW;
      RecMode:=mode;
    end;

    epcList.add(sweep);
  end;


procedure TEPCdescriptor.readSerie(f:TfileStream;numG,numS:integer);
  var
    res:intG;
    i:integer;
    nb:longint;
    recSerie:typeEPCserie;
    p:intG;
    ch:char;
  begin
    error:=3;
    p:=f.Position;
    f.read(recSerie,sizeof(recSerie));
    f.Position:=p+levelSize[3];

    f.read(nb,sizeof(nb));
    nb:=longUnix(nb);
    if nb<=0 then exit;
    {
    with recSerie do
    begin
      writeln(recMode);
      for i:=0 to 103 do write(EPC9state[i]);writeln;

      ch:=readkey;
      if ch=#27 then halt;
    end;
    }

    for i:=1 to nb do
      readSweep(f,numG,numS,i,recSerie.recMode);
  end;


procedure TEPCdescriptor.readGroup(f:TfileStream;numG:integer);
  var
    res:intG;
    i:integer;
    nb:longint;
    recGroup:typeEPCgroup;
    p:intG;
  begin
    error:=3;
    p:=f.Position;
    f.read(recGroup,sizeof(recGroup));
    f.Position:=p+levelSize[2];

    f.read(nb,sizeof(nb));
    nb:=longUnix(nb);
    if nb<=0 then exit;

    for i:=1 to nb do
      readSerie(f,numG,i);
  end;

procedure TEPCdescriptor.readRoot(f:TfileStream);
  var
    res:intG;
    i:integer;
    nb:longint;
    recRoot:typeEPCroot;
    p:longint;
  begin
    error:=2;
    p:=f.Position;
    f.read(recroot,sizeof(recRoot));
    f.Position:=p+levelSize[1];
    f.read(nb,sizeof(nb));
    nb:=longUnix(nb);
    if nb<=0 then exit;

    for i:=1 to nb do
      readGroup(f,i);
  end;

procedure TEPCdescriptor.ReadHeader(f:TfileStream);
  var
    recHeader:typeEPCheader;
    res:intG;
    i:integer;
  begin
    error:=1;
    f.read(recHeader,8);
    if recHeader.magic<>magicNumber then exit;

    levelCount:=longUnix(recHeader.levelCount);
    if (levelCount<1) or (levelCount>5) then exit;

    for i:=1 to levelCount do
      begin
        f.read(recHeader.levelSize[i],4);
        levelSize[i]:=longUnix(recHeader.levelSize[i]);
        if levelSize[i]<=0 then exit;
      end;
    readRoot(f);
  end;

procedure TEPCdescriptor.readstimRecord(f:TfileStream;numS,numR:integer);
  var
    res:intG;
    i:integer;
    nb:longint;
    rec:typeStimRecord;
    p:longint;
  begin
    error:=3;
    p:=f.Position;
    {Gblockread(f,rec,sizeof(rec),res);}
    f.Position:=p+levelSizeStim[3];
    f.read(nb,sizeof(nb));
  end;

procedure TEPCdescriptor.readStimulation(f:TfileStream;numS:integer);
  var
    res:intG;
    i:integer;
    nb:longint;
    rec:typeStimulation;
    p:longint;
    ch:char;
  begin
    error:=3;
    p:=f.Position;
    f.read(rec,sizeof(rec));
    f.Position:=p+levelSizeStim[2];

    stimInt^[numS]:=doubleUnix(rec.sampleInterval);

    f.read(nb,sizeof(nb));
    nb:=longUnix(nb);
    if nb<=0 then exit;
    {
    with rec do
    begin
      writeln(ampModeKind);
      writeln(adc1);
      writeln(adc2);
      write(Yunit1[0]);writeln(Yunit1[1]);
      write(Yunit2[0]);writeln(Yunit2[1]);

      ch:=readkey;
      if ch=#27 then halt;
    end;
    }
    for i:=1 to nb do
      readstimRecord(f,numS,i);
  end;


procedure TEPCdescriptor.readRootStim(f:TfileStream);
  var
    res:intG;
    i:integer;
    nb:longint;
    recRoot:typeRootStim;
    p:longint;
  begin
    error:=2;
    p:=f.Position;
    f.read(recroot,sizeof(recRoot));
    f.Position:=p+levelSizeStim[1];

    f.read(nb,sizeof(nb));
    nbstim:=longUnix(nb);
    if (nbstim<=0) or (nbStim>1000) then exit;
    getMem(stimInt,sizeof(double)*nbstim);

    for i:=1 to nbStim do
      readstimulation(f,i);
  end;


procedure TEPCdescriptor.ReadHeaderStim(f:TfileStream);
  var
    recHeader:typeEPCheader;
    res:intG;
    i:integer;
  begin
    error:=1;
    f.read(recHeader,8);
    if recHeader.magic<>magicNumber then exit;

    levelCountStim:=longUnix(recHeader.levelCount);
    if (levelCountStim<1) or (levelCountStim>5) then exit;

    for i:=1 to levelCountStim do
      begin
        f.read(recHeader.levelSize[i],4);
        levelSizeStim[i]:=longUnix(recHeader.levelSize[i]);
        if levelSizeStim[i]<=0 then exit;
      end;
    readRootStim(f);
  end;


procedure TEPCdescriptor.charger(stPul,stpgf:AnsiString);
  var
    f:TfileStream;
  begin
    f:=nil;
    TRY
    f:=TfileStream.create(stPgf,fmOpenRead);
    readHeaderStim(f);
    f.free;
    f:=nil;
    except
    f.Free;
    error:=100;
    exit;
    end;

    TRY
    f:=TfileStream.create(stPul,fmOpenRead);
    readHeader(f);
    f.free;
    Except
    f.free;
    error:=200;
    end;
  end;

function TEPCdescriptor.init(st:AnsiString):boolean;
  var
    stPul,stPgf: AnsiString;
  begin
    init:=false;
    stPul:=ChangeFileExt(st,'.pul');
    stPgf:=ChangeFileExt(st,'.pgf');

    if not( fileExists(st) and
            fileExists(stpgf) and
            fileExists(stpul) ) then
      begin
        error:=11;
        exit;
      end;

    charger(stPul,stPgf);
    init:=(error=0);
  end;



class function TEPCdescriptor.FileTypeName: AnsiString;
begin
  result:='EPC9';
end;

end.
