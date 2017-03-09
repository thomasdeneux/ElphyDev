unit bitmapG;
... Ne pas utiliser
... DibG a de nombreux avantages.

interface

uses  Windows, Graphics, sysUtils,
      util1, jpeg, pngImage ;

function CreatePaletteMono: hPalette;

implementation

type
  TPaletteEntries = array[0..255] of TPaletteEntry;

  TLogPalette256 = record
    palVersion: Word;
    palNumEntries: Word;
    palPalEntry: TPaletteEntries;
  end;



function CreatePaletteMono: hPalette;
var
  log: TLogPalette256;
  taglog: TagLogPalette absolute log;
  i:integer;
begin
  fillchar(log,sizeof(log),0);
  log.palVersion:= $300;
  log.palNumEntries := 256;

  for i:=0 to 255 do log.palPalEntry[i].peGreen:=i;

  result:= createPalette(taglog);
end;


procedure LoadBitmapFromFile(bm:Tbitmap; stF:string);
var
  ext:string;
  png: TPNGobject;
  jp: TjpegImage;
begin
  ext:=Fmaj(ExtractFileExt(stf));

  if ext='.BMP' then bm.LoadFromFile(stF)
  else
  if ext='.PNG' then
  begin
    try
      PNG := TPNGObject.Create;
      PNG.LoadFromFile(stF);
      bm.Assign(PNG);
    finally
      PNG.free;
    end;
  end
  else
  if (ext='.JPG') or (ext='.JPEG') then
  begin
    try
      jp:=TjpegImage.create;
      jp.LoadFromFile(stF);
      bm.Assign(jp);
    finally
      jp.free;
    end;
  end;

end;

procedure SaveBitmapToFile(bm:Tbitmap; stF:string; const quality:integer=100);
var
  ext:string;
  png: TPNGobject;
  jp: TjpegImage;
begin
  ext:=Fmaj(ExtractFileExt(stf));

  if ext='.BMP' then bm.SaveToFile(stF)
  else
  if ext='.PNG' then
  begin
    try
      PNG := TPNGObject.Create;
      PNG.Assign(bm);
      PNG.SaveToFile(stF);
    finally
      PNG.free;
    end;
  end
  else
  if (ext='.JPG') or (ext='.JPEG') then
  begin
    try
      jp:=TjpegImage.create;
      jp.CompressionQuality:= quality;
      jp.Assign(bm);
      jp.SaveToFile(stF);
    finally
      jp.free;
    end;
  end;

end;



end.
