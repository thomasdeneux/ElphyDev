
//--- 256 COLOUR BITMAP COMPRESSOR ---------------------------------------------
//
// This form contains a simple user interface to take 256 colour bitmaps in
// windows BPM format and compress them using RLE8 compression.
//
// The form itself contains no bitmap compression but attempts to locate
// a compressor in the windows system.
//
//
// Version 1.00
// Grahame Marsh 1 October 1997
//
// Freeware - you get it for free, I take nothing, I make no promises!
//
// Please feel free to contact me: grahame.s.marsh@corp.courtaulds.co.uk
//
// Revison History:
//    Version 1.00 - initial release  1-10-97

unit Comp2;

{$IFNDEF WIN32}
  Sorry, WIN 32 only!
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtDlgs, ExtCtrls, StdCtrls, Buttons, ComCtrls;


// declare own bitmap file record, specifically for 256 colour bitmaps
type
  T256Palette = array [0..255] of TRGBQuad;
  P256Bitmap = ^T256Bitmap;
  T256Bitmap = packed record
    b256File : TBitmapFileHeader;
    b256Info : TBitmapInfoHeader;
    b256Pal  : T256Palette;
    b256Data : record end;
  end;

type
  TBitmapCompForm = class(TForm)
    GroupBox1: TGroupBox;
    InBrowseBtn: TBitBtn;
    InFilenameEdit: TEdit;
    InFilesizeLabel: TLabel;
    InScrollBox: TScrollBox;
    InImage: TImage;
    OpenPictureDialog: TOpenPictureDialog;
    GroupBox2: TGroupBox;
    OutFilenameEdit: TEdit;
    OutBrowseBtn: TBitBtn;
    SaveDialog: TSaveDialog;
    OutScrollBox: TScrollBox;
    OutImage: TImage;
    CompressBtn: TBitBtn;
    OutFilesizeLabel: TLabel;
    CompUsingLabel: TLabel;
    PaletteCheckBox: TCheckBox;
    QualityTrackBar: TTrackBar;
    QualityLabel: TLabel;
    Label1: TLabel;
    procedure InBrowseBtnClick(Sender: TObject);
    procedure QualityTrackBarChange(Sender: TObject);
    procedure OutBrowseBtnClick(Sender: TObject);
    procedure OutFilenameEditChange(Sender: TObject);
    procedure CompressBtnClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    InBitmap : P256Bitmap;  // copy of bitmap file
    InSize,                 // copy of filesize
    InDataSize,             // size of bitmap data
    InColours : integer;    // number of colours

    procedure FreeStuff;
  public
  end;

var
  BitmapCompForm: TBitmapCompForm;

implementation

{$R *.DFM}

//-- calls to video for windopws dll -------------------------------------------

type
  PICInfo = ^TICInfo;
  TICInfo = packed record
    dwSize,                  // sizeof (TICInfo)
    fccType,                 // compressor type eg vidc
    fccHandler,              // compressor subtype eg rle
    dwFlags,                 // lo word is type specific
    dwVersion,               // version of driver
    dwVersionICM : DWORD;    // version of the ICM
    szName : array [0..15] of wchar;           // short name
    szDescription : array [0..127] of wchar;   // long name
    szDriver : array [0..127] of wchar;        // driver that contains the compressor
  end;

const
  ICMODE_COMPRESS            = 1;
  ICTYPE_VIDEO = ord ('v') +
                 ord ('i') shl  8 +
                 ord ('d') shl 16 +
                 ord ('c') shl 24;
type
  TICHandle = THandle;

function ICLocate (fccType, fccHandler: DWORD; lpbiIn, lpbmOut : PBitmapInfoHeader; wFlags: word) : TICHandle;
  stdcall; external 'msvfw32.dll' name 'ICLocate';

function ICGetInfo (Handle: TICHandle; var ICInfo: TICInfo; cb: DWORD): LRESULT;
  stdcall; external 'msvfw32.dll' name 'ICGetInfo';

function ICImageCompress (Handle: TICHandle; uiFlags: UINT; lpbiIn: PBitmapInfo;
  lpBits: pointer; lpbiOut: PBitmapInfo; lQuality: integer; plSize: PInteger): HBitmap;
  stdcall; external 'msvfw32.dll' name 'ICImageCompress';

function ICClose (Handle: TICHandle): LRESULT;
  stdcall; external 'msvfw32.dll' name 'ICClose';

//--- compressor form ----------------------------------------------------------

const
  FSStr = 'File size: %d';
  CUStr = 'Compressed using: %s';
  BitmapSignature = $4D42;

procedure TBitmapCompForm.FormDestroy(Sender: TObject);
begin
  FreeStuff
end;

procedure TBitmapCompForm.FreeStuff;
begin
  if InSize <> 0 then
  begin
    FreeMem (InBitmap, InSize);
    InBitmap := nil;
    InSize := 0
  end
end;

procedure TBitmapCompForm.InBrowseBtnClick(Sender: TObject);
var
  Bitmap : TBitmap;
begin
  with OpenPictureDialog do
  if Execute then
  begin
    InFilesizeLabel.Caption := Format (FSStr, [0]);
    InImage.Picture := nil;
    InFilenameEdit.Text := '';
    FreeStuff;

    with TFileStream.Create (Filename, fmOpenRead) do
    try
      InSize := Size;
      GetMem (InBitmap, InSize);
      Read (InBitmap^, InSize);

      with InBitmap^ do
      if b256File.bfType = BitmapSignature then
        if b256Info.biBitCount = 8 then
          if b256Info.biCompression = BI_RGB then
          begin
// Ok, we have a 256 colour, uncompressed bitmap
            InFilenameEdit.Text := Filename;

// determine number of entries in palette
            if b256Info.biClrUsed = 0 then
              InColours := 256
            else
              InColours := b256Info.biClrUsed;

// determine size of data bits
            with InBitmap^.b256Info do
              if biSizeImage = 0 then
                InDataSize := biWidth * biHeight
              else
                InDataSize := biSizeImage

          end else
            ShowMessage ('Bitmap already compressed')
        else
          ShowMessage ('Not a 256 colour bitmap')
      else
        ShowMessage ('Not a bitmap')
    finally
      Free
    end;

// show the bitmap and file size
    if InFileNameEdit.Text <> '' then
    begin
      Bitmap := TBitmap.Create;
      try
        Bitmap.LoadFromFile (InFilenameEdit.Text);
        InImage.Picture.Bitmap := Bitmap
      finally
        Bitmap.Free
      end;
      InScrollBox.VertScrollBar.Range := InBitmap^.b256Info.biHeight;
      InScrollBox.HorzScrollBar.Range := InBitmap^.b256Info.biWidth;
      InFilesizeLabel.Caption := Format (FSStr, [InBitmap^.b256File.bfSize])
    end
  end
end;

procedure TBitmapCompForm.OutBrowseBtnClick(Sender: TObject);
begin
  with SaveDialog do
    if Execute then
      OutFilenameEdit.Text := Filename
end;

//--- Palette Compression ------------------------------------------------------

// compress a 256 colour palette by removing unused entries
// returns new number of entries
function CompressPalette (var Pal: T256Palette; Data: pointer; DataSize: integer): word;
type
  TPaletteUsed = packed record
    Used : boolean;
    NewEntry : byte;
  end;
  TPaletteUsedArray = array [0..255] of TPaletteUsed;
var
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

//--- try to compress input image -> output image ------------------------------

procedure TBitmapCompForm.CompressBtnClick(Sender: TObject);
var
  Bitmap: TBitmap;
  Handle: THandle;
  CompressHandle: integer;
  ICInfo: TICInfo;
  OutBitmap,
  InBitmapCopy : P256Bitmap;
  CompressedStuff,
  OutData,
  InDataCopy : pointer;
  OutSize,
  OutColours : integer;
begin
// make an output bitmap file
  GetMem (OutBitmap, sizeof (T256Bitmap));
  try
// make a copy of the input file as we will play with the data
    GetMem (InBitmapCopy, InSize);
    try
      Move (InBitmap^, InBitmapCopy^, InSize);
      InDataCopy := pointer (integer(InBitmapCopy) + sizeof (TBitmapFileHeader) +
        sizeof (TBitmapInfoHeader) + InColours * sizeof (TRGBQuad));

// crunch the palette
      with InBitmapCopy^ do
        if PaletteCheckBox.Checked then
          OutColours := CompressPalette (b256Pal, InDataCopy, InDataSize)
        else
          OutColours := InColours;

// now copy the input file to fill in most of the output bitmap values
      Move (InBitmapCopy^, OutBitmap^, sizeof (T256Bitmap));
// set the compression required
      OutBitmap^.b256Info.biCompression := BI_RLE8;

// find a compressor
      CompressHandle := ICLocate (ICTYPE_VIDEO, 0, @InBitmapCopy^.b256Info,
        @OutBitmap.b256Info, ICMODE_COMPRESS);
      try
        fillchar (ICInfo, sizeof (TICInfo), 0);
        ICInfo.dwSize := sizeof (TICInfo);
// get info on the compressor
        ICGetInfo (CompressHandle, ICInfo, sizeof (TICInfo));
        OutSize := 0; // best compression
// now compress the image
        Handle := ICImageCompress (CompressHandle, 0, @InBitmapCopy^.b256Info,
             InDataCopy, @OutBitmap^.b256Info, QualityTrackBar.Position*100, @OutSize);
      finally
        ICClose (CompressHandle)
      end;

      if Handle <> 0 then
      begin
// get the compressed data
        CompressedStuff := GlobalLock (Handle);
        try
// modify the filesize and offset in case palette has shrunk
          with OutBitmap^.b256File do
          begin
            bfOffBits := sizeof (TBitmapFileHeader) + sizeof(TBitmapInfoHeader) +
                         OutColours * sizeof (TRGBQuad);
            bfSize := bfOffBits + OutSize
          end;
// locate the data
          OutData := pointer (integer(CompressedStuff) +
            sizeof(TBitmapInfoHeader) + InColours * sizeof (TRGBQuad));

// modify the bitmap info header
          with OutBitmap^.b256Info do
          begin
            biSizeImage := OutSize;
            biClrUsed := OutColours;
            biClrImportant := 0
          end;

// save the bitmap to disc
          with TFileStream.Create (OutFilenameEdit.Text, fmCreate) do
          try
            write (OutBitmap^, sizeof (TBitmapFileHeader) + sizeof (TBitmapInfoHeader));
            write (InBitmapCopy^.b256Pal, OutColours*sizeof (TRGBQuad));
            write (OutData^, OutSize)
          finally
            Free
          end;

// view the result
          Bitmap := TBitmap.Create;
          try
            Bitmap.LoadFromFile (OutFilenameEdit.Text);
            OutImage.Picture.Bitmap := Bitmap
          finally
            Bitmap.Free
          end;

// set the scrollbars and give some stats
          with OutBitmap^ do
          begin
            OutScrollBox.VertScrollBar.Range := b256Info.biHeight;
            OutScrollBox.HorzScrollBar.Range := b256Info.biWidth;
            OutFileSizeLabel.Caption := Format (FSStr, [b256File.bfSize]);
            CompUsingLabel.Caption := Format (CUStr, [WideCharToString (ICInfo.szDescription)])
          end

// now tidy up
        finally
          GlobalUnlock (Handle)
        end
      end else
        ShowMessage ('Bitmap could not be compressed')
    finally
      FreeMem (InBitmapCopy, InSize)
    end
  finally
    FreeMem (OutBitmap, sizeof (T256Bitmap))
  end
end;

procedure TBitmapCompForm.QualityTrackBarChange(Sender: TObject);
begin
  QualityLabel.Caption := IntToStr (QualityTrackBar.Position)
end;

procedure TBitmapCompForm.OutFilenameEditChange(Sender: TObject);
begin
  CompressBtn.Enabled := (InFilenameEdit.Text <> '') and
                         (OutFilenameEdit.Text <> '')
end;

end.

