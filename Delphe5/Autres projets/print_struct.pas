{
 ----------------------------------------------------------------
 File - PRINT_STRUCT.PAS

 Copyright (c) 2003 Jungo Ltd.  http://www.jungo.com 
 ----------------------------------------------------------------
}

unit Print_Struct;


interface

uses
    Windows,
    SysUtils,
    windrvr;

function StringToInt (str : STRING) : INTEGER;
function HexToInt(hex : STRING) : INTEGER;
procedure WD_CARD_print(pCard : PWD_CARD; pcPrefix : PCHAR);


implementation

function StringToInt(str : STRING) : INTEGER;
var
    i : INTEGER;
    res : INTEGER;

begin
    res := 0;
    for i:=1 to Length(str) do
    if (str[i]>='0') and (str[i]<='9')
    then
        res := res * 10 + Ord(str[i]) - Ord('0')
    else
    begin
        Writeln('Illegal number value');
        StringToInt := 0;
        Exit;
    end;
    StringToInt := res;
end;

function HexToInt(hex : STRING) : INTEGER;
var
    i : INTEGER;
    res : INTEGER;

begin
    hex := UpperCase(hex);
    res := 0;
    for i:=1 to Length(hex) do
    begin
        if (hex[i]>='0') and (hex[i]<='9')
        then
            res := res * 16 + Ord(hex[i]) - Ord('0')
        else
            if (hex[i]>='A') and (hex[i]<='F')
            then
                res := res * 16 + Ord(hex[i]) - Ord('A') + 10
            else
                begin
                    Writeln('Illegal Hex value');
                    HexToInt := 0;
                    Exit;
                end;
    end;
    HexToInt := res;
end;


procedure WD_CARD_print(pCard : PWD_CARD; pcPrefix : PCHAR);
var
    i : DWORD;
    item : WD_ITEMS;

begin
    for i:=1 to pCard^.dwItems do
    begin
        item := pCard^.Item[i-1];
        Write(STRING(pcPrefix), 'Item ');
        case item.item of
        ITEM_MEMORY:
            Write('Memory: range ', IntToHex(item.Memory.dwPhysicalAddr, 8), '-', IntToHex(item.Memory.dwPhysicalAddr+item.Memory.dwMBytes-1, 8));
        ITEM_IO:
            Write('IO: range $', IntToHex(item.IO.dwAddr, 4), '-$', IntToHex(item.IO.dwAddr+item.IO.dwBytes-1, 4));
        ITEM_INTERRUPT:
            Write('Interrupt: irq ', item.Interrupt.dwInterrupt);
        ITEM_BUS:
            Write('Bus: type ', item.Bus.dwBusType, ' bus number ', item.Bus.dwBusNum, ' slot/func $', IntToHex(item.Bus.dwSlotFunc, 1));
        else
            Write('Invalid item type');
        end;
        Writeln('');
    end;
end;

end.

