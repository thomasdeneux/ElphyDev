unit stmMCC;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,dtf0,
     CBWgs520,Ncdef2,stmObj,stmPG,stmVec1;

type
  TMCCinterface=
    class(typeUO)
    private
      boardNum:integer;
      boardName:AnsiString;

      bufIn:PtabWord;
      NchanIN,NsampleIn:integer;

      bufOut:PtabWord;
      NchanOut,NsampleOut:integer;

      VinList,VoutList:Tlist;

      function getVectorIn(i:integer):Tvector;
      procedure ClearVectors;

      function getVectorOut(i:integer):Tvector;

      procedure BuildChildList;
    public
      property Vin[i:integer]:Tvector read getVectorIn;
      property Vout[i:integer]:Tvector read getVectorOut;

      constructor create;override;
      destructor destroy;override;
      function init(num:integer):boolean;

      class function STMClassName:AnsiString;override;

      {Digital IO }
      function DConfigPort(PortNum:Integer; Direction:Integer):Integer;
      function DIn(PortNum:Integer; var DataValue:integer;tpx:integer):Integer;
      function DOut(PortNum,DataValue:Word):Integer;

      function DConfigBit(portType, BitNum, Direction:integer): integer;
      function DBitIn(PortType:Integer; BitNum:Integer;var BitValue:integer;tpx:integer):Integer;
      function DBitOut(PortType:Integer; BitNum:Integer;BitValue:Word):Integer;

      {Analog IO}
      function AIn(channel,range:integer;var dataValue:word):integer;
      function Aout(channel,range:integer;dataValue:word):integer;

      procedure setAinBuffer(Nb,len:integer);
      procedure setAoutBuffer(Nb,len:integer);

      procedure setAinChannelScale(num:integer;j1,j2:integer;y1,y2:float;uy:AnsiString);
      procedure setAoutChannelScale(num:integer;j1,j2:integer;y1,y2:float;uy:AnsiString);

      function AinScan(Vlow,rate,range,options:integer):integer;
      function AoutScan(Vlow,rate,range,options:integer):integer;


      function C9513Config(CounterNum:Integer;
                          GateControl:Integer; CounterEdge:Integer;
                          CountSource:Integer; SpecialGate:Integer;
                          Reload:Integer; RecycleMode:Integer;
                          BCDMode:Integer; CountDirection:Integer;
                          OutputControl:Integer):Integer;
      function C9513Init(ChipNum:Integer; FOutDivider:Integer;
                        FOutSource:Integer; Compare1:Integer; Compare2:Integer;
                        TimeOfDay:Integer):Integer;
      function CLoad(RegNum:Integer; LoadValue:Word): Integer;
      function CLoad32(RegNum:Integer; LoadValue:Longint): Integer;
      function CStatus(CounterNum:Integer; var StatusBits:Longint):Integer;

    end;

procedure proTMCCinterface_create(num:integer; var pu:typeUO);pascal;
function fonctionTMCCinterface_DConfigPort(PortNum:Integer; Direction:Integer;var pu:typeUO):Integer;pascal;
function fonctionTMCCinterface_DIn(PortNum:Integer; var DataValue:integer;tpx:integer;var pu:typeUO):Integer;pascal;
function fonctionTMCCinterface_DOut(PortNum,DataValue:Word;var pu:typeUO):Integer;pascal;

function fonctionTMCCinterface_DConfigBit(portType, BitNum, Direction:integer;var pu:typeUO): integer;pascal;
function fonctionTMCCinterface_DBitIn(PortType:Integer; BitNum:Integer;var BitValue:integer;tpx:integer;var pu:typeUO):Integer;pascal;
function fonctionTMCCinterface_DBitOut(PortType:Integer; BitNum:Integer;BitValue:integer;var pu:typeUO):Integer;pascal;


function fonctionTMCCinterface_BoardName(var pu:typeUO):AnsiString;pascal;

function fonctionTMCCinterface_AIn(channel,range:integer;var dataValue:word;var pu:typeUO):integer;pascal;
function fonctionTMCCinterface_Aout(channel,range:integer;dataValue:word;var pu:typeUO):integer;pascal;

procedure proTMCCinterface_SetAinBuffer(Nchan1,Nsample1:integer;var pu:typeUO);pascal;
procedure proTMCCinterface_SetAoutBuffer(Nchan1,Nsample1:integer;var pu:typeUO);pascal;


procedure proTMCCinterface_setAinChannelScale(num:integer;j1,j2:integer;y1,y2:float;uy:AnsiString;var pu:typeUO);pascal;
procedure proTMCCinterface_setAoutChannelScale(num:integer;j1,j2:integer;y1,y2:float;uy:AnsiString;var pu:typeUO);pascal;

function fonctionTMCCinterface_AinScan(Vlow, rate, range, options: integer;var pu:typeUO): integer;pascal;
function fonctionTMCCinterface_AoutScan(Vlow, rate, range, options: integer;var pu:typeUO): integer;pascal;

function fonctionTMCCinterface_StopBackGround(functionType:integer;var pu:typeUO): integer;pascal;
function fonctionTMCCinterface_AloadQueue(var ChanArray;size1:integer;tp1:word;
                                          var GainArray;size2:integer;tp2:word;
                                              count:integer;var pu:typeUO): integer;pascal;

function fonctionTMCCinterface_Vin(i:integer;var pu:typeUO):pointer;pascal;
function fonctionTMCCinterface_Vout(i:integer;var pu:typeUO):pointer;pascal;

function fonctionTMCCinterface_AinCount(var pu:typeUO):integer;pascal;
function fonctionTMCCinterface_AoutCount(var pu:typeUO):integer;pascal;





function fonctioncbDConfigPort(Boardnum:Integer; PortNum:Integer; Direction:Integer):Integer;pascal;
function fonctioncbDIn(BoardNum:Integer; PortNum:Integer; var DataValue:integer;tpx:integer):Integer;pascal;
function fonctioncbDOut(BoardNum,PortNum,DataValue:Word):Integer;pascal;


function fonctionTMCCinterface_C9513Config(CounterNum, GateControl, CounterEdge,
  CountSource, SpecialGate, Reload, RecycleMode, BCDMode, CountDirection,
  OutputControl: Integer; var pu:typeUO): Integer;pascal;

function fonctionTMCCinterface_C9513Init(ChipNum, FOutDivider, FOutSource,
  Compare1, Compare2, TimeOfDay: Integer; var pu:typeUO): Integer;pascal;
function fonctionTMCCinterface_CLoad(RegNum: Integer; LoadValue: Word; var pu:typeUO): Integer;pascal;
function fonctionTMCCinterface_CLoad32(RegNum, LoadValue: Integer; var pu:typeUO): Integer;pascal;
function fonctionTMCCinterface_CStatus(CounterNum: Integer; var StatusBits: Integer; var pu:typeUO): Integer;pascal;




implementation



{ TMCCinterface }


procedure testCBlib;
begin
  if not initCBlib then sortieErreur('MCC library not installed');
end;


constructor TMCCinterface.create;
begin
  inherited;
  VinList:=Tlist.create;
  VoutList:=Tlist.create;


end;

destructor TMCCinterface.destroy;
begin
  cbStopBackGround(boardNum,AIfunction);

  clearVectors;

  cbWinBufFree(intG(bufIn));
  inherited;
end;

procedure TMCCinterface.BuildChildList;
var
  i:integer;
begin
  clearChildList;
  for i:=1 to VinList.count do
    addToChildList(VinList[i-1]);

  for i:=1 to VoutList.count do
    addToChildList(VoutList[i-1]);
end;


function TMCCinterface.getVectorIn(i: integer): Tvector;
begin
  if (i>=1) and (i<=VinList.Count)
    then result:=Tvector(VinList[i-1])
    else result:=nil;
end;

function TMCCinterface.getVectorOut(i: integer): Tvector;
begin
  if (i>=1) and (i<=VoutList.Count)
    then result:=Tvector(VoutList[i-1])
    else result:=nil;
end;


procedure TMCCinterface.ClearVectors;
var
  i:integer;
begin
  for i:=0 to VinList.Count-1 do
    Tvector(VinList[i]).free;

  for i:=0 to VoutList.Count-1 do
    Tvector(VoutList[i]).free;
end;


class function TMCCinterface.STMClassName: AnsiString;
begin
  result:='MCCinterface';
end;

function TMCCinterface.init(num: integer): boolean;
var
  ULstat:integer;
begin
  boardNum:=num;
  setLength(boardName,BoardNameLen);
  ULstat:=cbGetBoardName(BoardNum,@BoardName[1]);
  result:=(ULstat=0);
end;


function TMCCinterface.DConfigPort(PortNum, Direction: Integer): Integer;
begin
  testCBlib;
  result:=cbDConfigPort(Boardnum, PortNum, Direction);
end;

function TMCCinterface.DIn(PortNum: Integer; var DataValue: integer;tpx: integer): Integer;
var
  w:word;
  dataB:byte absolute dataValue;
  dataW:word absolute dataValue;

begin
  testCBlib;
  result:=cbDIn(BoardNum,PortNum,w);
  case typeNombre(tpx) of
    nbByte,nbshort: dataB:=w;
    nbsmall,nbWord: dataW:=w;
    nbLong,nbDword: dataValue:=w;
  end;
end;

function TMCCinterface.DConfigBit(portType, BitNum, Direction:integer): integer;
begin
  testCBlib;
  result:=cbDconfigBit(BoardNum,portType, BitNum, Direction);
end;

function TMCCinterface.DBitIn(PortType:Integer; BitNum:Integer;var BitValue:integer;tpx:integer):Integer;
var
  w:word;
  dataB:byte absolute BitValue;
  dataW:word absolute BitValue;

begin
  testCBlib;
  result:=cbDBitIn(BoardNum,portType, BitNum, w);
  case typeNombre(tpx) of
    nbByte,nbshort: dataB:=w;
    nbsmall,nbWord: dataW:=w;
    nbLong,nbDword: BitValue:=w;
  end;

end;

function TMCCinterface.DBitOut(PortType:Integer; BitNum:Integer;BitValue:Word):Integer;
begin
  testCBlib;
  result:=cbDBitOut(BoardNum,portType, BitNum, BitValue);
end;



function TMCCinterface.DOut(PortNum, DataValue: Word): Integer;
begin
  testCBlib;
  result:=cbDOut(BoardNum,PortNum,DataValue);
end;

function TMCCinterface.AIn(channel,range:integer;var dataValue:word):integer;
begin
  testCBlib;
  result:=cbAin(BoardNum,channel,range,DataValue);
end;

function TMCCinterface.Aout(channel,range:integer;dataValue:word):integer;
begin
  testCBlib;
  result:=cbAout(BoardNum,channel,range,DataValue);
end;

procedure TMCCinterface.setAinBuffer(Nb,len:integer);
var
  i:integer;
  oldN:integer;
  vec:Tvector;
  data0:TypeDataI;
begin
  cbWinBufFree(intG(bufIn));
  bufIn:=nil;
  oldN:=NchanIN;

  NchanIN:=Nb;
  NsampleIn:=len;
  bufIn:=pointer(cbWinBufAlloc(Nb*len));

  for i:=oldN+1 to NchanIN do
  begin
    vec:=Tvector.create;
    data0:=typeDataI.create(@bufIn[i-1],NchanIN,0,0,NsampleIn-1);
    vec.initdat1Ex(data0,g_smallint);
    vec.inf.readOnly:=false;
    vec.ident:=self.ident+'.Vin'+Istr(i);
    VinList.add(vec);
  end;

  for i:=NchanIN+1 to oldN do Tvector(VinList[i]).Free;
  VinList.Count:=NchanIN;

  BuildChildList;
end;

procedure TMCCinterface.setAoutBuffer(Nb,len:integer);
var
  i:integer;
  oldN:integer;
  vec:Tvector;
  data0:TypeDataI;
begin
  cbWinBufFree(intG(bufOut));
  bufOut:=nil;
  oldN:=NchanOut;

  NchanOut:=Nb;
  NsampleOut:=len;
  bufOut:=pointer(cbWinBufAlloc(Nb*len));

  for i:=oldN+1 to NchanOut do
  begin
    vec:=Tvector.create;
    data0:=typeDataI.create(@bufOut[i-1],NchanOut,0,0,NsampleOut-1);
    vec.initdat1Ex(data0,g_smallint);
    vec.inf.readOnly:=false;
    vec.ident:=self.ident+'.Vout'+Istr(i);
    VoutList.add(vec);
  end;

  for i:=NchanOut+1 to oldN do Tvector(VoutList[i]).Free;
  VoutList.Count:=NchanOut;

  BuildChildList;
end;


procedure TMCCinterface.setAinChannelScale(num:integer;j1,j2:integer;y1,y2:float;uy:AnsiString);
begin
  with Vin[num] do
  begin
    if j1<>j2
      then dyu:=(Y2-Y1)/(j2-j1)
      else dyu:=1;

    y0u:=Y1-J1*Dyu;
  end;
end;

procedure TMCCinterface.setAoutChannelScale(num:integer;j1,j2:integer;y1,y2:float;uy:AnsiString);
begin
  with Vout[num] do
  begin
    if j1<>j2
      then dyu:=(Y2-Y1)/(j2-j1)
      else dyu:=1;

    y0u:=Y1-J1*Dyu;
  end;
end;


function TMCCinterface.AinScan(Vlow, rate, range, options: integer): integer;
var
  i:integer;
begin
  testCBlib;
  for i:=1 to NchanIN do
  begin
    Vin[i].Dxu:=1/rate*1000;
    Vin[i].unitX:='ms';
  end;
  result:=cbAInScan(BoardNum,Vlow,Vlow+NchanIN-1,NsampleIn*NchanIN,rate,range,intG(bufIn),options);
end;


function TMCCinterface.AoutScan(Vlow, rate, range, options: integer): integer;
var
  i:integer;
begin
  testCBlib;
  for i:=1 to NchanOut do
  begin
    Vout[i].Dxu:=1/rate*1000;
    Vout[i].unitX:='ms';
  end;
  result:=cbAoutScan(BoardNum,Vlow,Vlow+NchanOut-1,NsampleOut*NchanOut,rate,range,intG(bufOut),options);
end;


function TMCCinterface.C9513Config(CounterNum, GateControl, CounterEdge,
  CountSource, SpecialGate, Reload, RecycleMode, BCDMode, CountDirection,
  OutputControl: Integer): Integer;
begin
  result:= cbC9513Config(BoardNum,CounterNum, GateControl, CounterEdge,
           CountSource, SpecialGate, Reload, RecycleMode, BCDMode, CountDirection,
           OutputControl);
end;

function TMCCinterface.C9513Init(ChipNum, FOutDivider, FOutSource,
  Compare1, Compare2, TimeOfDay: Integer): Integer;
begin
  result:= cbC9513Init(BoardNum, ChipNum, FOutDivider, FOutSource,Compare1, Compare2, TimeOfDay);
end;

function TMCCinterface.CLoad(RegNum: Integer; LoadValue: Word): Integer;
begin
  result:= cbCLoad(BoardNum,RegNum, LoadValue);
end;

function TMCCinterface.CLoad32(RegNum, LoadValue: Integer): Integer;
begin
  result:= cbCLoad32(BoardNum, RegNum, LoadValue);
end;

function TMCCinterface.CStatus(CounterNum: Integer; var StatusBits: Integer): Integer;
begin
  result:= cbCStatus(BoardNum,CounterNum, StatusBits);
end;


{ Méthodes STM de TMCCinterface }

procedure proTMCCinterface_create(num:integer; var pu:typeUO);
begin
  testCBlib;
  createPgObject('',pu,TMCCinterface);
  if not TMCCinterface(pu).init(num)
    then sortieErreur('MCCinterface not found');

  {Vérifier la validité du numéro}
end;

function fonctionTMCCinterface_BoardName(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
    result:=BoardName;
end;

function fonctionTMCCinterface_DConfigPort(PortNum:Integer; Direction:Integer;var pu:typeUO):Integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
    result:=DConfigPort(PortNum, Direction);
end;

function fonctionTMCCinterface_DIn(PortNum:Integer; var DataValue:integer;tpx:integer;var pu:typeUO):Integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
    result:=DIN(PortNum,DataValue,tpx );
end;

function fonctionTMCCinterface_DOut(PortNum,DataValue:Word;var pu:typeUO):Integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
    result:=DOut(PortNum,DataValue);
end;

function fonctionTMCCinterface_DConfigBit(portType, BitNum, Direction:integer;var pu:typeUO): integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
    result:=DConfigBit(portType, BitNum, Direction);
end;

function fonctionTMCCinterface_DBitIn(PortType:Integer; BitNum:Integer;var BitValue:integer;tpx:integer;var pu:typeUO):Integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
    result:=DBitIn(PortType, BitNum,BitValue,tpx);
end;

function fonctionTMCCinterface_DBitOut(PortType:Integer; BitNum:Integer;BitValue:integer;var pu:typeUO):Integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
    result:=DBitOut(PortType,BitNum,BitValue);
end;



function fonctionTMCCinterface_AIn(channel,range:integer;var dataValue:word;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
    result:=Ain(channel,range,dataValue);
end;

function fonctionTMCCinterface_Aout(channel,range:integer;dataValue:word;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
    result:=Aout(channel,range,dataValue);
end;

procedure proTMCCinterface_SetAinBuffer(Nchan1,Nsample1:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  if (Nchan1<1) or (Nchan1>16)
    then sortieErreur('TMCCinterface. setAinBuffer : channel count out of range');

  if (Nsample1<1) then sortieErreur('TMCCinterface. setAinBuffer : sample count out of range');

  with TMCCinterface(pu) do
    setAinBuffer(Nchan1,Nsample1);
end;

procedure proTMCCinterface_SetAoutBuffer(Nchan1,Nsample1:integer;var pu:typeUO);
begin
  verifierObjet(pu);

  if (Nchan1<1) or (Nchan1>16)
    then sortieErreur('TMCCinterface. setAoutBuffer : channel count out of range');

  if (Nsample1<1) then sortieErreur('TMCCinterface. setAoutBuffer : sample count out of range');

  with TMCCinterface(pu) do
    setAoutBuffer(Nchan1,Nsample1);
end;


procedure proTMCCinterface_setAinChannelScale(num:integer;j1,j2:integer;y1,y2:float;uy:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);

  with TMCCinterface(pu) do
  begin
    if (Num<1) or (Num>NchanIN)
      then sortieErreur('TMCCinterface. setAinChannelScale : channel number out of range');
    if j1=j2
      then sortieErreur('TMCCinterface. setAinChannelScale : j1=j2 !');

    setAinChannelScale(num,j1,j2,y1,y2,uy);
  end;
end;

procedure proTMCCinterface_setAoutChannelScale(num:integer;j1,j2:integer;y1,y2:float;uy:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);

  with TMCCinterface(pu) do
  begin
    if (Num<1) or (Num>NchanOut)
      then sortieErreur('TMCCinterface. setAoutChannelScale : channel number out of range');
    if j1=j2
      then sortieErreur('TMCCinterface. setAoutChannelScale : j1=j2 !');

    setAoutChannelScale(num,j1,j2,y1,y2,uy);
  end;
end;



function fonctionTMCCinterface_AinScan(Vlow, rate, range, options: integer;var pu:typeUO): integer;
begin
  verifierObjet(pu);

  with TMCCinterface(pu) do
  result:=AinScan(Vlow, rate, range, options);
end;

function fonctionTMCCinterface_AoutScan(Vlow, rate, range, options: integer;var pu:typeUO): integer;
begin
  verifierObjet(pu);

  with TMCCinterface(pu) do
  result:=AoutScan(Vlow, rate, range, options);
end;


function fonctionTMCCinterface_StopBackGround(functionType:integer;var pu:typeUO): integer;
begin
  verifierObjet(pu);

  with TMCCinterface(pu) do
  result:=cbStopBackGround(boardNum,functionType);
end;

function fonctionTMCCinterface_AloadQueue(var ChanArray;size1:integer;tp1:word;
                                          var GainArray;size2:integer;tp2:word;
                                              count:integer;var pu:typeUO): integer;
var
  chan:array[1..16] of smallint absolute ChanArray;
  gain:array[1..16] of smallint absolute GainArray;

begin
  verifierObjet(pu);

  if not (typetypeG(tp1) in [g_smallint,g_word]) or
     not (typetypeG(tp2) in [g_smallint,g_word])
    then sortieErreur('TMCCinterface.AloadQueue : bad array type');

  size1:=size1 div 2;
  size2:=size2 div 2;

  if (size1 div 2<count) or (size2 div 2<count)
    then sortieErreur('TMCCinterface.AloadQueue : bad array size');

  if (count<1) or (count>16)
    then sortieErreur('TMCCinterface.AloadQueue : bad count');

  with TMCCinterface(pu) do
  result:=cbAloadQueue(boardNum,chan[1],Gain[1],count);
end;



function fonctionTMCCinterface_Vin(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
  begin
    if (i<1) or (i>NchanIN) then sortieErreur('TMCCinterface.Vin : index out of range');
    result:=@Vin[i].myAd;
  end;
end;

function fonctionTMCCinterface_Vout(i:integer;var pu:typeUO):pointer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
  begin
    if (i<1) or (i>NchanOut) then sortieErreur('TMCCinterface.Vout : index out of range');
    result:=@Vout[i].myAd;
  end;
end;


function fonctionTMCCinterface_AinCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
  begin
    result:=NchanIN;
  end;
end;

function fonctionTMCCinterface_AoutCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
  begin
    result:=NchanOut;
  end;
end;












{ Routines initiales }


function fonctioncbDConfigPort(Boardnum:Integer; PortNum:Integer; Direction:Integer):Integer;
begin
  testCBlib;
  result:=cbDConfigPort(Boardnum, PortNum, Direction);
end;

function fonctioncbDIn(BoardNum:Integer; PortNum:Integer; var DataValue:integer;tpx:integer):Integer;
var
  w:word;
  dataB:byte absolute dataValue;
  dataW:word absolute dataValue;

begin
  testCBlib;
  result:=cbDIn(BoardNum,PortNum,w);
  case typeNombre(tpx) of
    nbByte,nbshort: dataB:=w;
    nbsmall,nbWord: dataW:=w;
    nbLong,nbDword: dataValue:=w;
  end;
end;

function fonctioncbDOut(BoardNum,PortNum,DataValue:Word):Integer;
begin
  testCBlib;
  result:=cbDOut(BoardNum,PortNum,DataValue);
end;



function fonctionTMCCinterface_C9513Config(CounterNum, GateControl, CounterEdge,
  CountSource, SpecialGate, Reload, RecycleMode, BCDMode, CountDirection,
  OutputControl: Integer; var pu:typeUO): Integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
  result:= C9513Config(CounterNum, GateControl, CounterEdge,
           CountSource, SpecialGate, Reload, RecycleMode, BCDMode, CountDirection,
           OutputControl);
end;

function fonctionTMCCinterface_C9513Init(ChipNum, FOutDivider, FOutSource,
  Compare1, Compare2, TimeOfDay: Integer; var pu:typeUO): Integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
  result:= C9513Init(ChipNum, FOutDivider, FOutSource,Compare1, Compare2, TimeOfDay);
end;

function fonctionTMCCinterface_CLoad(RegNum: Integer; LoadValue: Word; var pu:typeUO): Integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
  result:= CLoad(RegNum, LoadValue);
end;

function fonctionTMCCinterface_CLoad32(RegNum, LoadValue: Integer; var pu:typeUO): Integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
  result:= CLoad32(RegNum, LoadValue);
end;

function fonctionTMCCinterface_CStatus(CounterNum: Integer; var StatusBits: Integer; var pu:typeUO): Integer;
begin
  verifierObjet(pu);
  with TMCCinterface(pu) do
  result:= CStatus(CounterNum, StatusBits);
end;



end.
