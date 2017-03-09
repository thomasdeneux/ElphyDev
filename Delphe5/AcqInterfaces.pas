unit AcqInterfaces;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     stmdef ;

type
  TAcqInterFaces=class
    drivers:TstringList;
    currentDriver1,currentDriver2:AnsiString;

    constructor create;
    destructor destroy;override;
    function choose(var st1:DriverString):boolean;
    function install(st1:driverstring):boolean;
    function exist:boolean;
  end;

var
  boards:TacqInterfaces;

procedure RegisterBoard(BrdName:AnsiString;brdType:pointer);

implementation

uses ParSystem, AcqBrd1 ;


{******************** Méthodes de TacqInterfaces *****************************}

constructor TacqInterfaces.create;
begin
  drivers:=TstringList.create;
end;

destructor TacqInterfaces.destroy;
begin
  drivers.free;
end;

function TacqInterfaces.choose(var st1:Driverstring):boolean;
begin
  if paramSystem.execution(st1,drivers)then install(st1);
end;

function TacqInterfaces.install(st1:driverstring):boolean;
var
  index:integer;
begin
  result:=(st1=currentDriver1);
  if result then exit;

  board.free;
  board:=nil;

  index:=drivers.indexof(st1);
  if index<0 then st1:='';

  currentDriver1:=st1;

  if st1='' then
    begin
      result:=false;
      exit;
    end;

  board:=TinterfaceClass(drivers.objects[index]).create(st1);
  if assigned(board) then board.loadOptions;

  result:=true;
end;



function TacqInterfaces.exist:boolean;
begin
  result:=drivers.count>0;
end;

procedure RegisterBoard(BrdName:AnsiString;brdType:pointer);
begin
  if not assigned(boards) then boards:=TacqInterfaces.create;

  boards.drivers.AddObject(BrdName,brdType) ;
end;

end.
