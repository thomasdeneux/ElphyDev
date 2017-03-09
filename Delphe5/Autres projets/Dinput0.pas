unit Dinput0;

interface

uses windows,sysUtils,
     util1;

type
  TDIcontrol=class (Tobject)
               Dinput:IdirectInput;
               KBdevice:IdirectInputDevice;
               MouseDevice:IdirectInputDevice;
               constructor create(wnd:hwnd);
               procedure Acquire;
               procedure unAcquire;

               procedure term(st:string);
               destructor destroy;override;

               function getKB(n:integer):integer;
             end;

var
  diControl:TdiControl;

implementation

constructor TDIcontrol.create(wnd:hwnd);
var
  dd:hresult;
begin
  { Création de DirectInput }
  dd:=DirectInputCreate(hinstance,DirectInput_Version,Dinput,nil);
  if dd<>di_ok then
    begin
      Dinput:=nil;
      term('DirectInputcreate failed '+Istr(dd) ) ;
    end;
  { Création de Keyboard device }
  dd:=Dinput.createDevice(@GUID_SysKeyBoard,KBdevice,nil);
  if dd<>di_ok then term('KB CreateDevice ' +longToHexa(dd) ) ;

  KBdevice.setDataFormat(@c_dfDIKeyboard);
  if dd<>di_ok then term('KB setDataFormat ' +Istr(dd) ) ;

  dd:=KBdevice.setCooperativeLevel(wnd,DISCL_foreGround or DISCL_NonExclusive);
  if dd<>di_ok then term('KB setCooperativeLevel ' +Istr(dd) ) ;

  { Création de Mouse device }
  dd:=Dinput.createDevice(@GUID_SysMouse,Mousedevice,nil);
  if dd<>di_ok then term('Mouse CreateDevice ' +longToHexa(dd) ) ;

  Mousedevice.setDataFormat(@c_dfDImouse);
  if dd<>di_ok then term('Mouse setDataFormat ' +Istr(dd) ) ;

  dd:=Mousedevice.setCooperativeLevel(wnd,DISCL_foreGround or DISCL_Exclusive);
  if dd<>di_ok then term('Mouse setCooperativeLevel ' +Istr(dd) ) ;

end;

procedure TDIcontrol.term(st:string);
begin
  if Dinput<>nil then
    begin
      if KBdevice<>nil then
        begin
          KBdevice.unAcquire;
          KBdevice.release;
          KBdevice:=nil;
        end;

      if MouseDevice<>nil then
        begin
          MouseDevice.unAcquire;
          MouseDevice.release;
          MouseDevice:=nil;
        end;

      Dinput.release;
      Dinput:=nil;
    end;

  if st<>'' then
    raise Exception.Create (st);

end;

destructor TDIcontrol.destroy;
begin
  term('');
  inherited;
end;

procedure TDIcontrol.Acquire;
var
  dd:hresult;
begin
  dd:=KBdevice.acquire;
  if (dd<>di_ok) and (dd<>s_false) then
    raise Exception.Create (
        Format ( 'KB Acquire failed: %x', [ dd ] ) ) ;

  dd:=MouseDevice.acquire;
  if (dd<>di_ok) and (dd<>s_false) then
    raise Exception.Create (
        Format ( 'Mouse Acquire failed: %x', [ dd ] ) ) ;

end;

procedure TDIcontrol.unAcquire;
var
  dd:hresult;
begin
  dd:=KBdevice.unacquire;
  if dd<>di_ok then
    raise Exception.Create (
        Format ( 'KB unAcquire failed: %x', [ dd ] ) ) ;

  dd:=MouseDevice.unAcquire;
  if (dd<>di_ok) and (dd<>s_false) then
    raise Exception.Create (
        Format ( 'Mouse unAcquire failed: %x', [ dd ] ) ) ;


end;

function TDIcontrol.getKB(n:integer):integer;
var
  tab:array[0..255] of byte;
  dd:hresult;
begin
  dd:=KBdevice.getDeviceState(256,@tab);
  getKB:=tab[n];
end;

end.
