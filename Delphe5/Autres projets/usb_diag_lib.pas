{
 ----------------------------------------------------------------
 File - USB_DIAG_LIB.PAS

 Utility functions for printing device information,
 detecting USB devices
 
 Copyright (c) 2003 Jungo Ltd.  http://www.jungo.com
 ----------------------------------------------------------------
}

unit USB_diag_lib;

interface

uses
    Windows,
    SysUtils,
    WinDrvr,
    print_struct,
    status_strings;

type READ_PIPE_FUNC = function(hDevice : HANDLE; pBuffer : POINTER; dwSize : DWORD) : DWORD; stdcall;
type PROCESS_DATA_FUNC = procedure(pBuffer : POINTER; dwSize : DWORD; pContext : POINTER) stdcall;
type STOP_PIPE_FUNC = procedure(hDevice : HANDLE) stdcall;

const
    MAX_BUFFER_SIZE = 4096;
    BYTES_IN_LINE = 16;
    HEX_CHARS_PER_BYTE = 3; {2 digits and one space}
    HEX_STOP_POS = BYTES_IN_LINE*HEX_CHARS_PER_BYTE;

type
    USB_LISTEN_PIPE = record
        read_pipe_func : READ_PIPE_FUNC;
        stop_pipe_func : STOP_PIPE_FUNC;
    hDevice : HANDLE;
    dwPacketSize : DWORD;
        process_data_func : PROCESS_DATA_FUNC; { if NULL call PrintHexBuffer }
    pContext : PVOID;
    fStopped : BOOLEAN;
    hThread : HANDLE;
    end;

    PUSB_LISTEN_PIPE = ^USB_LISTEN_PIPE;

function USB_Get_WD_handle(phWD : PHANDLE) : BOOLEAN;
procedure USB_Print_device_info(dwVendorId : DWORD; dwProductId : DWORD);
procedure USB_Print_all_devices_info;
procedure USB_Print_device_Configurations(uniqueId : DWORD; configIndex : DWORD);

procedure PrintHexBuffer(pBuffer : POINTER; dwBytes : DWORD);
function GetHexBuffer(pBuffer : POINTER; dwBytes : DWORD) : DWORD;
function GetHexChar (line : string) : INTEGER;
procedure CloseListening(pListenPipe : PUSB_LISTEN_PIPE);
procedure ListenToPipe(pListenPipe : PUSB_LISTEN_PIPE);
function PipeListenHandler(pParam : POINTER) : DWORD stdcall;
function IsHexDigit(c : string) : BOOLEAN;


implementation

function  pipeType2Str(pipeType : DWORD) : STRING;
begin
    case pipeType of
    UsbdPipeTypeControl:
        pipeType2Str := 'Control';
    UsbdPipeTypeIsochronous:
        pipeType2Str := 'Isochronous';
    UsbdPipeTypeBulk:
        pipeType2Str := 'Bulk';
    UsbdPipeTypeInterrupt:
        pipeType2Str := 'Interrupt';
    else
        pipeType2Str := 'Unknown';
    end;
end;


function USB_Get_WD_handle(phWD : PHANDLE) : BOOLEAN;
var
    ver : SWD_VERSION;

begin
    phWD^ := INVALID_HANDLE_VALUE;
    phWD^ := WD_Open();

    { Check whether handle is valid and version OK }
    if phWD^ = INVALID_HANDLE_VALUE
    then
    begin
        Writeln('Cannot open WinDriver device');
        USB_Get_WD_handle := False;
        Exit;
    end;

    FillChar(ver, SizeOf(ver), 0);
    WD_Version(phWD^,ver);
    if ver.dwVer<WD_VER
    then
    begin
        Writeln('Error - incorrect WinDriver version');
        WD_Close (phWD^);
        phWD^ := INVALID_HANDLE_VALUE;
        USB_Get_WD_handle := False;
    end
    else
        USB_Get_WD_handle := True;
end;


procedure USB_Print_device_info(dwVendorId : DWORD; dwProductId : DWORD);
var
    i : DWORD;
    {strTransType, strStatus : STRING;}
    hWD : HANDLE;
    usbScan : WD_USB_SCAN_DEVICES;
    {openCloseInfo : WD_USB_OPEN_CLOSE;}
    genInfo : PWD_USB_DEVICE_GENERAL_INFO;
    tmp : string;
    dwStatus : DWORD;

begin
    if not USB_Get_WD_handle (@hWD)
    then
        Exit;

    FillChar(usbScan, SizeOf(usbScan), 0);
    usbScan.searchId.dwVendorId  := dwVendorId;
    usbScan.searchId.dwProductId := dwProductId;
    dwStatus := WD_UsbScanDevice(hWD,@usbScan);
    if dwStatus>0
    then
    begin
        Writeln('WD_UsbScanDevice failed with status $', IntToHex(dwStatus, 8), Stat2Str(dwStatus));
        WD_Close(hWD);
        Exit;
    end;
    for i:=1 to usbScan.dwDevices do
    begin
        genInfo := @usbScan.deviceGeneralInfo[i];

        Writeln('USB device - Vendor ID: ', IntToHex(usbScan.deviceGeneralInfo[i-1].deviceId.dwVendorId, 4),
            ', Product ID: ', IntToHex(usbScan.deviceGeneralInfo[i-1].deviceId.dwProductId, 4),
            ', unique ID: ', usbScan.uniqueId[i-1]);
        Writeln('      phisical address: 0x', IntToHex(usbScan.deviceGeneralInfo[i-1].deviceAddress, 4),
            ' Hub No. ',usbScan.deviceGeneralInfo[i-1].dwHubNum,
            ' Port No.',usbScan.deviceGeneralInfo[i-1].dwPortNum);
        if usbScan.deviceGeneralInfo[i-1].fFullSpeed <> 0 then
            Writeln('      Full speed, device has ',usbScan.deviceGeneralInfo[i-1].dwConfigurationsNum,
                'configuration(s)')
        else
            Writeln('      Low speed, device has ',usbScan.deviceGeneralInfo[i-1].dwConfigurationsNum,
               ' configuration(s)');

        if genInfo^.fHub <> 0 then
           if genInfo^.hubInfo.fBusPowered = 1 then
               Writeln('      Device is Hub, Hub has ', genInfo^.hubInfo.dwPorts,
                ' ports, Bus powered, ',genInfo^.hubInfo.dwHubControlCurrent,
                ' mA')
           else
               Writeln('      Device is Hub, Hub has ', genInfo^.hubInfo.dwPorts,
                ' ports, Self powered, ',genInfo^.hubInfo.dwHubControlCurrent,
                ' mA');
        Writeln('');
        if i < usbScan.dwDevices then
        begin
           Writeln('Press Enter to continue to the next device');
           Readln(tmp);
        end;
    end;
    WD_Close (hWD);
end;


procedure USB_Print_all_devices_info;
begin
    USB_Print_device_info(0, 0);
end;


procedure USB_Print_device_Configurations(uniqueId : DWORD; configIndex :  DWORD);
var
    config : WD_USB_CONFIGURATION;
    i, j : INTEGER;
    hWD : HANDLE;
    pInterface : PWD_USB_INTERFACE_DESC;
    pEndPoint : PWD_USB_ENDPOINT_DESC;
    tmp : string;
    dwStatus : DWORD;

begin
    if not USB_Get_WD_handle (@hWD)
    then
        Exit;

    FillChar(config, SizeOf(config), 0);
    config.uniqueId := uniqueId;
    config.dwConfigurationIndex := configIndex;
    dwStatus := WD_UsbGetConfiguration(hWD, @config);
    if dwStatus>0
    then
    begin
        Writeln('WD_UsbGetConfiguration failed with status $', IntToHex(dwStatus, 8), Stat2Str(dwStatus));
        WD_Close(hWD);
        Exit;
    end;

    Writeln('Configuration No. ', config.configuration.dwValue,
        ' has ', config.configuration.dwNumInterfaces,
        ' interface(s)');
    Writeln('configuration attributes: 0x', IntToHex(config.configuration.dwAttributes, 2),
        ' max power: ', config.configuration.MaxPower*2, 'mA');
    Writeln('');

    for i:=0 to config.dwInterfaceAlternatives-1 do
    begin
        pInterface := @config.UsbInterface[i].InterfaceDesc;
        Writeln('interface No. ', pInterface^.dwNumber,
            ', alternate setting: ', pInterface^.dwAlternateSetting,
            ', index: ', pInterface^.dwIndex);
        Writeln('end-points: ', pInterface^.dwNumEndpoints,
            ', class: 0x', IntToHex(pInterface^.dwClass, 2),
            ', sub-class: 0x', IntToHex(pInterface^.dwSubClass, 2),
            ', protocol: 0x', IntToHex(pInterface^.dwProtocol, 2));

        for j:=0 to pInterface^.dwNumEndpoints-1 do
        begin
            pEndPoint := @config.UsbInterface[i].Endpoints[j];
            Writeln('  end-point address: 0x',IntToHex(pEndPoint^.dwEndpointAddress, 2),
                ', attributes: 0x', IntToHex(pEndPoint^.dwAttributes, 2),
                ', max packet size: ', pEndPoint^.dwMaxPacketSize,
                ', Interval: ',pEndPoint^.dwInterval);
        end;
        Writeln('');
        if i < config.dwInterfaceAlternatives-1 then
        begin
           Writeln('Press Enter to continue to the next configuration');
           Readln(tmp);
        end;

    end;
    WD_Close (hWD);
end;


procedure PrintHexBuffer(pBuffer : POINTER; dwBytes : DWORD);
var
    pData  : PBYTE;
    pHex : array [0..HEX_STOP_POS-1] of CHAR; {48}
    pAscii : array [0..BYTES_IN_LINE-1] of CHAR; {16}
    offset, line_offset, i : DWORD;
    intVal : INTEGER;
    byteVal : BYTE;
    hexStr : string;

begin
    if dwBytes = 0 then
       Exit;

    pData := pBuffer;

    for offset:=0 to dwBytes-1 do
    begin
        line_offset := offset mod BYTES_IN_LINE;

        if (offset <> 0) and (line_offset = 0) then
        begin
            Write(pHex, '| ', pAscii);
            Writeln(' ');
        end;
        byteVal := PBYTE(DWORD(pData) + offset)^;
        hexStr :=  IntToHex(byteVal, 2);

        pHex[line_offset*HEX_CHARS_PER_BYTE] := hexStr[1];
        pHex[line_offset*HEX_CHARS_PER_BYTE+1] := hexStr[2];
        pHex[line_offset*HEX_CHARS_PER_BYTE+2] := ' ';
        if byteVal >= $20 then
            pAscii[line_offset] := CHAR(byteVal)
        else
            pAscii[line_offset] := '.';
    end;

    { print the last line. fill with blanks if needed }
    if (offset mod BYTES_IN_LINE) <> 0 then
    begin
        for i:=(offset mod BYTES_IN_LINE)*HEX_CHARS_PER_BYTE to BYTES_IN_LINE*HEX_CHARS_PER_BYTE-1 do
            pHex[i] := ' ';
        for i:=(offset mod BYTES_IN_LINE) to BYTES_IN_LINE-1 do
            pAscii[i] := ' ';
    end;
    Write(pHex, '| ', pAscii);
    Writeln(' ');
end;


procedure CloseListening(pListenPipe : PUSB_LISTEN_PIPE);
var
    transfer : WD_USB_TRANSFER;

begin
    FillChar(transfer, SizeOf(transfer), 0);

    if pListenPipe^.hThread = 0 then
        Exit;

    Writeln('Stop listening to pipe');
    pListenPipe^.fStopped := True;

    pListenPipe^.stop_pipe_func(pListenPipe^.hDevice);
    WaitForSingleObject(pListenPipe^.hThread, INFINITE);
    CloseHandle(pListenPipe^.hThread);
    pListenPipe^.hThread := 0;
end;


procedure ListenToPipe(pListenPipe : PUSB_LISTEN_PIPE);
var
   threadId : DWORD;

begin
    { start the running thread }
    Writeln('Start listening to pipe');
    pListenPipe^.hThread := CreateThread (nil, $1000, @PipeListenHandler, POINTER(pListenPipe), 0, threadId);
end;


function PipeListenHandler(pParam : POINTER) : DWORD; stdcall;
var
    pListenPipe : PUSB_LISTEN_PIPE;
    pbuf : POINTER;
    dwBytesTransfered : DWORD;

begin
    pListenPipe := PUSB_LISTEN_PIPE(pParam);
    GetMem(POINTER(pbuf), pListenPipe^.dwPacketSize);

    while True do
    begin
        dwBytesTransfered := pListenPipe^.read_pipe_func(pListenPipe^.hDevice, pbuf, pListenPipe^.dwPacketSize);
        if pListenPipe^.fStopped then
            BREAK;
    if dwBytesTransfered = $ffffffff then
    begin
            writeln('Transfer failed');
            BREAK;
        end;
        if @pListenPipe^.process_data_func <> POINTER(0) then
            pListenPipe^.process_data_func(pbuf, dwBytesTransfered, pListenPipe^.pContext)
        else
            PrintHexBuffer(pbuf, dwBytesTransfered);
    end;
    FreeMem(pbuf);
    PipeListenHandler := 0;
end;


function GetHexChar (line : string) : INTEGER;
var
    ch : INTEGER;
    tmpStr : string;

begin
    ch := Ord(line[1]);

    if (not IsHexDigit(line[1])) then
    begin
        GetHexChar := -1;
        Exit;
    end;

    if  ((ch >= Ord('0')) and (ch <= Ord('9'))) then
       GetHexChar := StrToInt(line[1])
    else
        begin
            tmpStr := UpperCase(line[1]);
            GetHexChar := BYTE(tmpStr[1]) - BYTE('A') + 10;
        end;

end;


function GetHexBuffer(pBuffer : POINTER; dwBytes : DWORD) : DWORD;
var
    i , pos: DWORD;
    pData : PBYTE;
    res : BYTE;
    ch : INTEGER;
    line : string;
    strLength : INTEGER;

begin
    pData  := pBuffer;
    i := 1;
    pos := 0;
    Readln(line);
    strLength := Length(line);

    while pos < dwBytes do
    begin
        if i > strLength then
        begin
            Readln(line);
            strLength := Length(line);
            i := 1;
        end;

        ch := GetHexChar(line[i]);
        if ch<0 then
        begin
            i := i+1;
            continue;
        end;

        res := ch * 16;
        i := i+1;

        if i > strLength then
        begin
            Readln(line);
            strLength := Length(line);
            i := 1;
        end;

        ch := GetHexChar(line[i]);
        if ch<0 then
        begin
            i := i+1;
            continue;
        end;

        res := res + ch;
        PBYTE(DWORD(pData) +pos)^ := res;
        i := i+1;
        pos := pos+1;
    end;

    // return the number of bytes that was read
    GetHexBuffer := pos;
end;


function IsHexDigit(c : string) : BOOLEAN;
var
    cOrd : Longint;
begin
    cOrd := Ord(c[1]);
    IsHexDigit := ((cOrd >= Ord('0')) and (cOrd <= Ord('9')))
       or ((cOrd >= Ord('A')) and (cOrd <= Ord('F')))
       or ((cOrd >= Ord('a')) and (cOrd <= Ord('f')));
end;

end.


