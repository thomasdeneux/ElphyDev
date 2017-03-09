{
 ----------------------------------------------------------------
 File - ISAPNP_DIAG_LIB.PAS

 Utility functions for printing card information,
 detecting PCI cards, and accessing PCI configuration
 registers.

 Copyright (c) 2003 Jungo Ltd.  http://www.jungo.com 
 ----------------------------------------------------------------
}

unit ISAPnP_diag_lib;

interface

uses
    Windows,
    SysUtils,
    WinDrvr,
    Print_Struct;

function ISAPNP_Get_WD_handle(phWD : PHANDLE) : BOOLEAN;
procedure ISAPNP_Print_all_cards_info;


implementation

function ISAPNP_Get_WD_handle(phWD : PHANDLE) : BOOLEAN;
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
        ISAPNP_Get_WD_handle := False;
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
        ISAPNP_Get_WD_handle := False;
    end
   else
       ISAPNP_Get_WD_handle := True;
end;

procedure ISAPNP_Print_all_cards_info;
var
    hWD : HANDLE;
    scanCards : WD_ISAPNP_SCAN_CARDS;
    cardInfo : WD_ISAPNP_CARD_INFO;
    i, j : DWORD;

begin
    if not ISAPNP_Get_WD_handle (@hWD)
    then
        Exit;

    Writeln('ISA PnP bus scan:');
    Writeln('');
    FillChar(scanCards, SizeOf(scanCards), 0);
    WD_IsapnpScanCards (hWD, scanCards);
    for i:=1 to scanCards.dwCards do
    begin
        Writeln('Card ', i-1, ': ', scanCards.Card[i-1].cIdent);
        for j:=1 to scanCards.Card[i-1].dcLogicalDevices do
        begin
            FillChar(cardInfo, SizeOf(cardInfo), 0);
            cardInfo.cardId := scanCards.Card[i-1].cardId;
            cardInfo.dwLogicalDevice := j-1;
            WD_IsapnpGetCardInfo(hWD, cardInfo);
            if StrLen(cardInfo.cIdent) <> 0 then
               Write('Device ', j-1, ': ', cardInfo.cIdent, ', ');
            Write('Vendor ID: ', scanCards.Card[i-1].cardId.cVendor, ', ');
            Write('Serial number: ', IntToHex(scanCards.Card[i-1].cardId.dwSerial, 8));
        Writeln('');
            WD_CARD_print(@cardInfo.Card, '   ');
            Writeln('');
        end;
    end;
    WD_Close (hWD);
end;

end.

