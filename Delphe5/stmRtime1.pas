unit stmRtime1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,Dgraphic,varconf1,
     stmdef,stmObj,stmVec1,
     stmPg,stmError,Ncdef2,
     windriver0;


type
  TRtimeDevice=
    class(typeUO)
    private
      VendorID, DeviceID, CardNum:integer;
      Fopen,Frunning:boolean;
      PCIdrv:TPCIdriver;

      Vtemp:Tvector;         {Templates décomposition et reconstruction}

      function Init(vd,dev,num:integer):boolean;

    public
      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;override;

      procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;

      function initialise(st:AnsiString):boolean;override;

      procedure setChildNames;override;
      procedure saveToStream(f:Tstream;Fdata:boolean);override;
      function loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;override;
      procedure ProcessMessage(id:integer;source:typeUO;p:pointer);override;

      procedure Start(sampInt:integer);
      procedure Stop;
      function getCount:integer;
      function LostInt:integer;

    end;

procedure proTRtimeDevice_create(name:AnsiString;vd,dev,num:integer;var pu:typeUO);pascal;
procedure proTRtimeDevice_create_1(vd,dev,num:integer;var pu:typeUO);pascal;
procedure proTRtimeDevice_start(SampInt:integer;var pu:typeUO);pascal;
procedure proTRtimeDevice_stop(var pu:typeUO);pascal;
function fonctionTRtimeDevice_getCount(var pu:typeUO):integer;pascal;
function fonctionTRtimeDevice_LostInt(var pu:typeUO):integer;pascal;

implementation

{ TRtimeDevice }

constructor TRtimeDevice.create;
begin
  inherited;

  PCIdrv:=TPCIdriver.create;

  Vtemp:=Tvector.create;
  Vtemp.initTemp1(0,1,G_single);
  AddTochildList(Vtemp);

end;

destructor TRtimeDevice.destroy;
begin
  Vtemp.free;

  PCIdrv.free;
  inherited;
end;

class function TRtimeDevice.stmClassName: AnsiString;
begin
  result:='RtimeDevice';
end;

function TRtimeDevice.initialise(st: AnsiString): boolean;
begin
  result:=inherited initialise(st);
  setChildNames;
end;

procedure TRtimeDevice.setChildNames;
begin
  with Vtemp do
  begin
    ident:=self.ident+'.Vtemp';
  end;
end;

procedure TRtimeDevice.saveToStream(f: Tstream; Fdata: boolean);
begin
  inherited saveToStream(f,Fdata);

  Vtemp.saveToStream(f,Fdata);
end;

function TRtimeDevice.loadFromStream(f: Tstream; size: LongWord;Fdata: boolean): boolean;
begin
  result:=inherited loadFromStream(f,size,Fdata);

  if not result then exit;
  if f.position>=f.size then exit;

  if result then result:=Vtemp.loadAsChild(f,Fdata);
end;


procedure TRtimeDevice.BuildInfo(var conf: TblocConf; lecture,
  tout: boolean);
begin
  inherited;
  conf.setvarconf('VendorID',VendorID,sizeof(VendorID));
  conf.setvarconf('DeviceID',DeviceID,sizeof(DeviceID));
  conf.setvarconf('CardNum',CardNum,sizeof(CardNum));

end;


procedure TRtimeDevice.ProcessMessage(id: integer; source: typeUO;
  p: pointer);
begin
  inherited;

end;

function TRtimeDevice.Init(vd,dev,num:integer):boolean;
begin
  result:=PCIdrv.Open(vd,dev,num);
  if result then
  begin
    VendorID:=vd;
    DeviceID:=dev;
    CardNum:=num;
    Fopen:=true;


  end;
end;

procedure TRtimeDevice.Start(sampInt:integer);
begin
  if Fopen then
  begin
    PCIdrv.setAcq(sampInt);
    Frunning:=true;
  end;
end;

procedure TRtimeDevice.Stop;
begin
  if Fopen and Frunning then
  begin
    PCIdrv.doneAcq;
    Frunning:=false;
  end;
end;

function TRtimeDevice.getCount: integer;
begin
  result:=PCIdrv.cntData;
end;

function TRtimeDevice.LostInt: integer;
begin
  result:=PCIdrv.cntLost;
end;


{************************** Méthodes STM ********************************}

var
  E_initDevice:integer;
  E_notOpen:integer;
  E_notRunning:integer;

procedure proTRtimeDevice_create(name:AnsiString;vd,dev,num:integer;var pu:typeUO);
begin
  createPgObject(name,pu,TRtimeDevice);

  with TRtimeDevice(pu) do
  begin
    setChildNames;
    if not Init(vd,dev,num)
      then sortieErreur(E_initDevice);

  end;
end;

procedure proTRtimeDevice_create_1(vd,dev,num:integer;var pu:typeUO);
begin
  proTRtimeDevice_create('',vd,dev,num,pu);
end;


procedure proTRtimeDevice_start(SampInt:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TRtimeDevice(pu) do
  begin
    if not Fopen
      then sortieErreur(E_notOpen);
    start(sampInt);
  end;
end;

procedure proTRtimeDevice_stop(var pu:typeUO);
begin
  verifierObjet(pu);
  with TRtimeDevice(pu) do
  begin
    if not Fopen
      then sortieErreur(E_notOpen);
    if not Frunning
      then sortieErreur(E_notRunning);
    stop;
  end;
end;

function fonctionTRtimeDevice_getCount(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TRtimeDevice(pu) do
  begin
    result:=getCount;
  end;
end;

function fonctionTRtimeDevice_LostInt(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TRtimeDevice(pu) do
  begin
    result:=LostInt;
  end;
end;


Initialization
AffDebug('Initialization stmRtime1',0);
registerObject(TRtimeDevice,data);


installError(E_initDevice,'TRTimedevice: device not initialized');
installError(E_notOpen,'TRTimedevice: device not open');
installError(E_notRunning,'TRTimedevice: device not running');

end.
