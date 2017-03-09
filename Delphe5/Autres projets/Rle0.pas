unit RLE0;

interface

uses Windows, SysUtils, Classes, Graphics,

     util1,vfw;

procedure CompressRLE(bmInfo: PBitmapInfo;  var BmInfoSize: integer;
                      data: Pointer;  var BmSize: Dword);

implementation

type
  T256Palette = array [0..255] of TRGBQuad;

function CompressPalette (var Pal1; Data: pointer; DataSize: integer): word;
type
  TPaletteUsed = packed record
    Used : boolean;
    NewEntry : byte;
  end;
  TPaletteUsedArray = array [0..255] of TPaletteUsed;
var
  pal:T256Palette absolute pal1;
  PUArray: TPaletteUsedArray;
  Scan: PByte;
  NewValue,
  Loop: integer;
  NewPal : T256Palette;
begin
// look through the bitmap data bytes looking for palette entries in use
  fillchar (PUArray, sizeof (PUArray), 0);
  Scan:= Data;
  for Loop:= 1 to DataSize do
  begin
    PUArray[Scan^].Used := true;
    inc (Scan)
  end;

// go through palette and set new entry numbers for those in use
  NewValue := 0;
  for Loop:= 0 to 255 do
    with PUArray[Loop] do
      if Used then
      begin
        NewEntry := NewValue;
        inc (NewValue);
      end;
  Result := NewValue; // return number in use
  if NewValue = 256 then
    exit; // QED

// go through bitmap data assigninging new palette numbers
  Scan:= Data;
  for Loop:= 1 to DataSize do
  begin
    Scan^ := PUArray[Scan^].NewEntry;
    inc (Scan)
  end;

// create a new palette and copy across only those entries in use
  fillchar (NewPal, sizeof (T256Palette), 0);
  for Loop := 0 to 255 do
    with PUArray [Loop] do
      if Used then
        NewPal[NewEntry] := Pal [Loop];

// return the new palette
  Pal := NewPal
end;


procedure CompressRLE(bmInfo: PBitmapInfo;  var BmInfoSize: integer;
                      data: Pointer;  var BmSize: Dword);
var
  Handle: THandle;
  CompressHandle: integer;
  ICInfo: TICInfo;

  bmInfo1: PBitmapInfo;

  CompressedStuff, OutData:pointer;
  OutSize, incolors,Outcolors : integer;
  infosize1:integer;

begin
  inColors:=256;
  GetMem (bmInfo1, bmInfoSize);
  infoSize1:=bmInfoSize;
  
  Outcolors := 256{CompressPalette (PtabOctet(bmInfo)^[Plongint(bmInfo)^], Data, bmSize)};
  Move (bmInfo^,bmInfo1^,bmInfoSize);

  bmInfo1^.bmiHeader.biCompression := BI_RLE8;

  CompressHandle := ICLocate (ICTYPE_VIDEO, 0, @bmInfo^,@bmInfo1^, ICMODE_COMPRESS);

  fillchar (ICInfo, sizeof (TICInfo), 0);
  ICInfo.dwSize := sizeof (TICInfo);
  ICGetInfo (CompressHandle, @ICInfo, sizeof (TICInfo));
  OutSize := 0;
  Handle := ICImageCompress (CompressHandle, 0, bmInfo,
             Data, bmInfo1, 10000, @OutSize);

  ICClose (CompressHandle);

  if Handle <> 0 then
     begin
       CompressedStuff := GlobalLock (Handle);

       OutData := pointer (integer(CompressedStuff) +
            sizeof(TBitmapInfoHeader) + Incolors * sizeof (TRGBQuad));

       with bmInfo1^.bmiHeader do
       begin
         biSizeImage := OutSize;
         biClrUsed := Outcolors;
         biClrImportant := 0
       end;

      bmInfoSize:=sizeof(TBitmapInfoHeader) + outcolors * sizeof (TRGBQuad);
      reallocmem(bmInfo,bmInfoSize);
      move(bmInfo1^,bmInfo^,bmInfoSize);

      reallocmem(data,outsize);
      move(outData^,data^,outSize);
      bmSize:=outSize;

      GlobalUnlock (Handle);
      GlobalFree (Handle);
     end;

   FreeMem (bmInfo1, InfoSize1);
end;



end.
