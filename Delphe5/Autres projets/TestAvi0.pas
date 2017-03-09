unit TestAvi0;

interface

uses windows,classes,graphics,
     util1,Gdos,DdosFich,Dgraphic,vfw,dibG,
     dibForm0,BMex1,
     stmdef,stmObj,multg1;

procedure AVIView;

procedure testDib;

implementation

type
  TBITMAPINFO256 = packed record
    bmiHeader: TBitmapInfoHeader;
    bmiColors: array[0..255] of TRGBQuad;
  end;

var
  f:file;
  fs:text;
  indent:string;
  Fsize:integer;

  AviH:TmainAviHeader;
  strH:TaviStreamHeader;
  strf:TbitmapInfo256;

  index1,index2:TAVIINDEXENTRY;

  ddOk:boolean;

procedure ViewChunk(st:string);forward;

procedure viewList;
var
  posf:integer;
  st0:string[4];
  res:integer;
  size:integer;
begin

  st0:='    ';
  Gblockread(f,size,4,res);
  Gblockread(f,st0[1],4,res);

  posf:=GfilePos(f)+size-4;


  GwritelnT(fs,indent+'LIST '+st0+'==>'+Istr(size));
  indent:=indent+'  ';

  while (GfilePos(f)<posf) and (GfilePos(f)<Fsize) and (GIO=0) and not testEscape do
  begin
    Gblockread(f,st0[1],4,res);
    if st0='LIST'
      then ViewList
      else ViewChunk(st0);
  end;
  Gseek(f,posf);

  delete(indent,length(indent)-1,2);
end;


const
  BitmapFileType = Ord('B') + Ord('M')*$100;

procedure testImage(sz:integer);
var
  p:TmemoryStream;
  mm:pointer;
  res:integer;
  bm:Tdib;
  BF: TBitmapFileHeader;
begin
  if ddOK then exit;

  with BF do
  begin
    bfType    := BitmapFileType;
    bfOffBits := SizeOf(TBitmapFileHeader)+sizeof(strf);
    bfSize    := bfOffBits+sz;
    bfReserved1 := 0;
    bfReserved2 := 0;
  end;


  p:=TmemoryStream.create;
  p.Write(bf,SizeOf(TBitmapFileHeader));
  strf.bmiHeader.biSizeImage:=sz;
  p.write(strf,sizeof(strf));

  getmem(mm,sz);
  Gblockread(f,mm^,sz,res);
  p.write(mm^,sz);

  p.Position:=0;
  bm:=Tdib.create;
  bm.LoadFromStream(p);

  dibForm.showDib(bm);

  p.Free;
  bm.free;
  freemem(mm);

  ddOK:=true;
end;



procedure ViewChunk(st:string);
var
  posf:integer;
  res:integer;
  size:integer;
begin
  Gblockread(f,size,4,res);
  posf:=GfilePos(f)+size;
  GwritelnT(fs,indent+st+'==>'+Istr(size));

  if st='avih' then Gblockread(f,avih,sizeof(avih),res)
  else
  if st='strh' then Gblockread(f,strh,sizeof(strh),res)
  else
  if st='strf'
    then Gblockread(f,strf,sizeof(strf),res)
  else
  if st='00db' then testImage(size)
  else
  if st='idx1' then
    begin
      Gblockread(f,index1,sizeof(index1),res);
      Gblockread(f,index2,sizeof(index2),res);
    end;


  Gseek(f,posf);
end;


procedure View1(stf:string);
var
  st0:string[4];
  res,size:integer;
begin
  assignFile(fs,debugPath+'avi.txt');
  GrewriteT(fs);

  st0:='    ';
  assignFile(f,stf);
  Greset(f,1);

  Gblockread(f,st0[1],4,res);
  GwritelnT(fs,st0);
  Gblockread(f,Fsize,4,res);
  Gblockread(f,st0[1],4,res);
  GwritelnT(fs,st0);
  GwritelnT(fs,'');

  while GfilePos(f)<Fsize+12 do
  begin
    Gblockread(f,st0[1],4,res);
    if st0='LIST'
      then ViewList
      else ViewChunk(st0);
  end;


  Gclose(f);
  GcloseT(fs);
end;

procedure AVIView;
const
  st:string='c:\dac2\*.avi';
var
  st1:string;
begin
  ddOK:=false;
  indent:='';
  st1:=GchooseFile('',st);
  if st1<>'' then view1(st1);
end;


procedure saveImage(dib:Tdib);
var
  p:TmemoryStream;
  mm:pointer;
  res:integer;
  BF: TBitmapFileHeader;
  f:file;
  size:integer;
begin
  with BF do
  begin
    bfType    := BitmapFileType;
    bfOffBits := SizeOf(TBitmapFileHeader)+sizeof(TBITMAPINFO256);
    bfSize    := bfOffBits+dib.BitmapInfo.bmiHeader.biSizeImage;
    bfReserved1 := 0;
    bfReserved2 := 0;
  end;


  assignFile(f,'c:\dac2\x.bmp');
  Grewrite(f,1);
  GblockWrite(f,bf,SizeOf(bf),res);

  Gblockwrite(f,dib.bitMapInfo^, dib.BitmapInfoSize,res);

  size:=dib.BitmapInfo.bmiHeader.biSizeImage;
  Gblockwrite(f,dib.PBits^, size,res);

  Gclose(f);
end;


procedure testDib;
var
  rect0:Trect;
  bmRef:TbitmapEx;
  bm:Tdib;
begin
  rect0:=multigraph0.formG.getCadre(0);
  bmRef:=multigraph0.formG.getBM;

  bm:=Tdib.create;

  bm.setSize(rect0.right-rect0.left+1,rect0.bottom-rect0.top+1,8);
  bm.ColorTable:=stdColorTable;
  bm.UpdatePalette;

  bm.canvas.copyRect(rect(0,0,bm.width-1,bm.height-1),bmref.Canvas,rect0);

  with bm.BitmapInfo^ do
    messageCentral('ClrUsed='+Istr(bmiHeader.biClrUsed )+CRLF+
                   'ImageSize='+Istr(bmiHeader.biSizeImage)
                   );

  bm.Compress;
  dibForm.showDib(bm);
  bm.savetoFile('c:\dac2\bmbm.bmp');


  saveImage(bm);

  bm.free;
end;




end.
