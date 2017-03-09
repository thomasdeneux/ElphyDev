{
 ----------------------------------------------------------------
  File - PCI_DIAG_LIB.PAS
 
  Utility functions for printing card information,
  detecting PCI cards, and accessing PCI configuration
  registers.
  
  Copyright (c) 2003 Jungo Ltd.  http://www.jungo.com 
 ----------------------------------------------------------------
}   

unit PCI_diag_lib;

interface

uses
    Windows,
    SysUtils,
    windrvr,
    print_struct,
    status_strings;

type FIELDS_ARRAY = record
        name : PCHAR;
        dwOffset : DWORD;
        dwBytes : DWORD;
        dwVal : DWORD;
     end;

var
    line : string[255];            { input of command from user }

function PCI_Get_WD_handle(phWD : PHANDLE) : BOOLEAN;
procedure PCI_Print_card_info(pciSlot : WD_PCI_SLOT);
procedure PCI_Print_all_cards_info;
procedure PCI_EditConfigReg(pciSlot : WD_PCI_SLOT);
function PCI_ChooseCard(ppciSlot : PWD_PCI_SLOT) : BOOLEAN;


implementation


function PCI_Get_WD_handle(phWD : PHANDLE) : BOOLEAN;
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
        PCI_Get_WD_handle := False;
        Exit;
    end;

    FillChar(ver, SizeOf(ver), 0);
    WD_Version(phWD^,ver);
    if ver.dwVer<WD_VER
    then
    begin
        Writeln('Error - incorrect WinDriver version');
        WD_Close(phWD^);
        phWD^ := INVALID_HANDLE_VALUE;
        PCI_Get_WD_handle := False;
    end
    else
        PCI_Get_WD_handle := True;
end;

procedure PCI_Print_card_info(pciSlot : WD_PCI_SLOT);
var
    hWD : HANDLE;
    pciCardInfo : WD_PCI_CARD_INFO;
    dwStatus : DWORD;

begin
    if not PCI_Get_WD_handle (@hWD)
    then
        Exit;

    FillChar(pciCardInfo, SizeOf(pciCardInfo), 0);
    pciCardInfo.pciSlot := pciSlot;
    dwStatus := WD_PciGetCardInfo(hWD, pciCardInfo);
    if dwStatus>0
    then
        Writeln('WD_PciGetCardInfo failed with status $', IntToHex(dwStatus, 8), Stat2Str(dwStatus))
    else
        WD_CARD_print(@pciCardInfo.Card, '   ');

    WD_Close (hWD);
end;

procedure PCI_Print_all_cards_info;
var
    hWD : HANDLE;
    i : INTEGER;
    pciScan : WD_PCI_SCAN_CARDS;
    pciSlot : WD_PCI_SLOT;
    pciId : WD_PCI_ID;
    tmp : string[2];
    dwStatus : DWORD;

begin
    if not PCI_Get_WD_handle (@hWD)
    then
        Exit;

    FillChar(pciScan, SizeOf(pciScan), 0);
    pciScan.searchId.dwVendorId := 0;
    pciScan.searchId.dwDeviceId := 0;

    Writeln('Pci bus scan.');
    Writeln('');
    dwStatus := WD_PciScanCards (hWD,pciScan);
    if dwStatus>0
    then
    begin
      Writeln('WD_PciScanCards failed with status ($', IntToHex(dwStatus, 8), ') - ', Stat2Str(dwStatus));
      Exit;
    end;

    for i:=1 to pciScan.dwCards do
    begin
        pciId := pciScan.cardId[i-1];
        pciSlot := pciScan.cardSlot[i-1];
        Writeln('Bus ', pciSlot.dwBus, ' Slot ', pciSlot.dwSlot, ' Function ', pciSlot.dwFunction,
            ' VendorID $', IntToHex(pciId.dwVendorId, 4), ' DeviceID $', IntToHex(pciId.dwDeviceId, 4));
        PCI_Print_card_info(pciSlot);
        Writeln('Press Enter to continue to next slot');
        Readln(tmp);
    end;
    WD_Close (hWD);
end;

function PCI_ReadBytes(hWD : HANDLE; pciSlot : WD_PCI_SLOT; dwOffset : DWORD; dwBytes : DWORD) : DWORD;
var
    pciCnf : WD_PCI_CONFIG_DUMP;
    dwVal : DWORD;
    dwMask : DWORD;
    dwDwordOffset : DWORD;

begin
    dwVal := 0;
    dwDwordOffset := dwOffset mod 4;
    FillChar(pciCnf, SizeOf(pciCnf), 0);
    pciCnf.pciSlot := pciSlot;
    pciCnf.pBuffer := @dwVal;
    pciCnf.dwOffset := dwOffset;
    pciCnf.dwOffset := pciCnf.dwOffset - dwDwordOffset;
    pciCnf.dwBytes := 4;
    pciCnf.fIsRead := 1;
    WD_PciConfigDump(hWD,pciCnf);

    dwVal := dwVal shr (dwDwordOffset*8);
    case dwBytes of
    1:
        dwMask := $ff;
    2:
        dwMask := $ffff;
    3:
        dwMask := $ffffff;
    4:
        dwMask := $ffffffff;
    end;
    dwVal := dwVal and dwMask;
    PCI_ReadBytes := dwVal;
end;

procedure PCI_WriteBytes(hWD : HANDLE; pciSlot : WD_PCI_SLOT; dwOffset : DWORD; dwBytes : DWORD; dwData : DWORD);
var
    pciCnf : WD_PCI_CONFIG_DUMP;
    dwVal : DWORD;
    dwMask : DWORD;
    dwDwordOffset : DWORD;

begin
    dwVal := 0;
    dwDwordOffset := dwOffset mod 4;
    FillChar(pciCnf, SizeOf(pciCnf), 0);
    pciCnf.pciSlot := pciSlot;
    pciCnf.pBuffer := @dwVal;
    pciCnf.dwOffset := dwOffset;
    pciCnf.dwOffset := pciCnf.dwOffset - dwDwordOffset;
    pciCnf.dwBytes := 4;
    pciCnf.fIsRead := 1;
    WD_PciConfigDump(hWD,pciCnf);

    case dwBytes of
    1:
        dwMask := $ff;
    2:
        dwMask := $ffff;
    3:
        dwMask := $ffffff;
    4:
        dwMask := $ffffffff;
    end;
    dwVal := dwVal and (not (dwMask shl (dwDwordOffset*8)));
    dwVal := dwVal or ((dwMask and dwData) shl (dwDwordOffset*8));

    pciCnf.fIsRead := 0;
    WD_PciConfigDump(hWD,pciCnf);
end;

procedure PCI_EditConfigReg(pciSlot : WD_PCI_SLOT);
var
    hWD : HANDLE;
    fields : array [0..29] of FIELDS_ARRAY;
    i, cmd : INTEGER;
    dwVal : DWORD;

begin
    if not PCI_Get_WD_handle (@hWD)
    then
        Exit;

    i := 0;
    fields[i].name := 'VID'; fields[i].dwOffset := $0; fields[i].dwBytes := 2; i:=i+1;
    fields[i].name := 'DID'; fields[i].dwOffset := $2; fields[i].dwBytes := 2; i:=i+1;
    fields[i].name := 'CMD'; fields[i].dwOffset := $4; fields[i].dwBytes := 2; i:=i+1;
    fields[i].name := 'STS'; fields[i].dwOffset := $6; fields[i].dwBytes := 2; i:=i+1;
    fields[i].name := 'RID'; fields[i].dwOffset := $8; fields[i].dwBytes := 1; i:=i+1;
    fields[i].name := 'CLCD'; fields[i].dwOffset := $9; fields[i].dwBytes := 3; i:=i+1;
    fields[i].name := 'CALN'; fields[i].dwOffset := $c; fields[i].dwBytes := 1; i:=i+1;
    fields[i].name := 'LAT'; fields[i].dwOffset := $d; fields[i].dwBytes := 1; i:=i+1;
    fields[i].name := 'HDR'; fields[i].dwOffset := $e; fields[i].dwBytes := 1; i:=i+1;
    fields[i].name := 'BIST'; fields[i].dwOffset := $f; fields[i].dwBytes := 1; i:=i+1;
    fields[i].name := 'BADDR0'; fields[i].dwOffset := $10; fields[i].dwBytes := 4; i:=i+1;
    fields[i].name := 'BADDR1'; fields[i].dwOffset := $14; fields[i].dwBytes := 4; i:=i+1;
    fields[i].name := 'BADDR2'; fields[i].dwOffset := $18; fields[i].dwBytes := 4; i:=i+1;
    fields[i].name := 'BADDR3'; fields[i].dwOffset := $1c; fields[i].dwBytes := 4; i:=i+1;
    fields[i].name := 'BADDR4'; fields[i].dwOffset := $20; fields[i].dwBytes := 4; i:=i+1;
    fields[i].name := 'BADDR5'; fields[i].dwOffset := $24; fields[i].dwBytes := 4; i:=i+1;
    fields[i].name := 'EXROM'; fields[i].dwOffset := $30; fields[i].dwBytes := 4; i:=i+1;
    fields[i].name := 'INTLN'; fields[i].dwOffset := $3c; fields[i].dwBytes := 1; i:=i+1;
    fields[i].name := 'INTPIN'; fields[i].dwOffset := $3d; fields[i].dwBytes := 1; i:=i+1;
    fields[i].name := 'MINGNT'; fields[i].dwOffset := $3e; fields[i].dwBytes := 1; i:=i+1;
    fields[i].name := 'MAXLAT'; fields[i].dwOffset := $3f; fields[i].dwBytes := 1; i:=i+1;
    repeat
    begin
        Writeln('');
        Writeln('Edit PCI configuration registers');
        Writeln('--------------------------------');
        for i:=0 to 20 do
        begin
            fields[i].dwVal := PCI_ReadBytes(hWD, pciSlot, fields[i].dwOffset, fields[i].dwBytes);
        Writeln(i+1, '. ', fields[i].name, ' : ', IntToHex(fields[i].dwVal, 8));
        end;
        Writeln('99. Back to main menu');
        Write('Choose register to write to, or 99 to exit: ');
        cmd := 0;
        Readln(line);
        cmd := StrToInt(line);
        if (cmd>=1) and (cmd<=21)
        then
        begin
            i := cmd-1;
            Write('Enter value (Hex) to write to ', fields[i].name, ' register (or <X> to cancel): ');
            Readln(line);
            line := UpperCase(line);
            if line[1]<>'X'
            then
        begin
                dwVal := 0;
                dwVal := HexToInt(line);
            if ((dwVal > $ff) and (fields[i].dwBytes = 1))
                    or ((dwVal > $ffff) and (fields[i].dwBytes = 2))
            or ((dwVal > $ffffff) and (fields[i].dwBytes = 3))
                then
                    Writeln('Error: value to big for register')
                else
                    PCI_WriteBytes(hWD, pciSlot, fields[i].dwOffset, fields[i].dwBytes, dwVal);
            end;
        end;
    end;
    until cmd=99;

    WD_Close (hWD);
end;

function PCI_ChooseCard(ppciSlot : PWD_PCI_SLOT) : BOOLEAN;
var
    fHasCard : BOOLEAN;
    pciScan : WD_PCI_SCAN_CARDS;
    dwVendorID, dwDeviceID : DWORD;
    hWD : HANDLE;
    i : DWORD;
    dwStatus : DWORD;

begin
    if not PCI_Get_WD_handle (@hWD)
    then
    begin
        PCI_ChooseCard := False;
    Exit;
    end;

    fHasCard := False;

    while not fHasCard do
    begin
        dwVendorID := 0;
        Write('Enter VendorID: ');
        Readln(line);
        dwVendorID := HexToInt(line);
        if dwVendorID = 0
        then
            Break;

        Write('Enter DeviceID: ');
        Readln(line);
        dwDeviceID := HexToInt(line);

        FillChar(pciScan, SizeOf(pciScan), 0);
        pciScan.searchId.dwVendorId := dwVendorID;
        pciScan.searchId.dwDeviceId := dwDeviceID;
        dwStatus := WD_PciScanCards (hWD, pciScan);
        if dwStatus>0
        then
        begin
            Writeln('WD_PciScanCards failed with status ($', IntToHex(dwStatus, 8), ') - ', Stat2Str(dwStatus));
            WD_Close(hWD);
        end;
        if pciScan.dwCards = 0             { One card at least must be found }
        then
            Writeln('Error - cannot find PCI card')
        else
            if pciScan.dwCards = 1
            then
            begin
                ppciSlot^ := pciScan.cardSlot[0];
                fHasCard := True;
            end
            else
            begin
                Writeln('Found ', pciScan.dwCards, ' matching PCI cards');
                Write('Select card (1-', pciScan.dwCards, '): ');
                i := 0;
                Readln(line);
                i := StrToInt(line);
                if (i>=1) and (i <=pciScan.dwCards)
                then
                begin
                    ppciSlot^ := pciScan.cardSlot[i-1];
                    fHasCard := True;
                end
                else
                    Writeln('Choice out of range');
            end;
        if not fHasCard
        then
        begin
            Write('Do you want to try a different VendorID/DeviceID? ');
            Readln(line);
            line := UpperCase(line);
            if line[1] <> 'Y'
            then
                Break;
        end;
    end;
    WD_Close (hWD);
    PCI_ChooseCard := fHasCard;
end;

end.
