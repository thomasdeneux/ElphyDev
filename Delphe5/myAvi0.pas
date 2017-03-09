unit MyAVI0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,vfw,
     graphics,
     util1,dibG;


{TsimpleAVI permet d'écrire une succession de bitmaps dans un fichier AVI.

 Le fichier est créé directement sans utiliser les DLL microsoft. Il ne peut
 actuellement contenir qu'une voie Video sans voie sonore. Les images sont
 soit non compressées, soit compressées au format RLE.

 L'utilisation est simple:
   - on crée l'objet en donnant un nom de fichier et le nombre d'images par secondes
   - on appelle save pour chaque image à sauver. Le format ne doit évidemment pas
     changer d'une image à l'autre pas plus que la palette de couleurs.
   - Enfin, on détruit l'objet. Ce qui ferme le fichier proprement.

}



type
  TBITMAPINFO256 = packed record
    bmiHeader: TBitmapInfoHeader;
    bmiColors: array[0..255] of TRGBQuad;
  end;

  Tjunk=array[1..2840] of byte;

type
  TsimpleAVI=class
             private
               f:TfileStream;
               ChunkList,ListList:Tlist;

               sizeList,OffsetList:Tlist;

               info:TBITMAPINFO256;

               fps,maxSize,totFrame:integer;
               avihOffset,strhOffset:integer;

               offset0:integer;

               open:boolean;

               procedure writeSgn(st:AnsiString);
               procedure writeInt(w:integer);

               procedure openRiff(st:AnsiString);
               procedure closeRiff;

               procedure openChunk(st:AnsiString);
               procedure closeChunk;

               procedure openList(st:AnsiString);
               procedure closeList;

               procedure writeAvih;
               procedure writestrh;
               procedure writestrf;

             protected
               destructor destroy;override;

             public
               constructor create(st:AnsiString;dib:Tdib;fps1:integer);
               procedure save(dib:Tdib);overload;
               procedure save(bm:Tbitmap);overload;

             end;

implementation

{ TsimpleAVI }


procedure TsimpleAVI.writeSgn(st: AnsiString);
begin
  while length(st)<4 do st:=st+' ';

  f.Write(st[1],4);
end;

procedure TsimpleAVI.writeInt(w:integer);
begin
  f.Write(w,4);
end;

procedure TsimpleAVI.openRiff(st: AnsiString);
begin
  writeSgn('RIFF');
  writeInt(0);
  writeSgn('AVI ');

end;

procedure TsimpleAVI.closeRiff;
var
  Fsize:integer;
begin
  Fsize:=f.size-12;
  f.Position:=4;
  writeInt(Fsize);
  f.Position:=f.Size;
end;

procedure TsimpleAVI.openChunk(st: AnsiString);
var
  p:integer;
begin
  writeSgn(st);
  p:=f.Position;
  ChunkList.add(pointer(p));
  writeInt(0);
end;


procedure TsimpleAVI.closeChunk;
var
  p:integer;
begin
  p:=intG(ChunkList.last);

  f.Position:=p;
  writeInt(f.Size-p-4);
  f.Position:=f.size;

  ChunkList.delete(ChunkList.count-1);
end;

procedure TsimpleAVI.openList(st: AnsiString);
var
  p:integer;
begin
  writeSgn('LIST');
  p:=f.Position;
  ListList.add(pointer(p));
  writeInt(0);
  writeSgn(st);
end;

procedure TsimpleAVI.closeList;
var
  p:integer;
begin
  p:=intG(ListList.last);

  f.Position:=p;
  writeInt(f.size-p-4);
  f.Position:=f.size;

  ListList.delete(ListList.count-1);
end;



constructor TsimpleAVI.create(st: AnsiString;dib:Tdib;fps1:integer);
var
  junk:Tjunk;
  res:integer;
begin
  chunkList:=Tlist.create;
  ListList:=Tlist.create;
  SizeList:=Tlist.create;
  OffsetList:=Tlist.create;

  move(dib.bitMapInfo^,info,dib.BitmapInfoSize);

  if (info.bmiHeader.biClrUsed=0) and (info.bmiHeader.biBitCount=8)
    then info.bmiHeader.biClrUsed:=256;

  fps:=fps1;
  maxSize:=0;
  totFrame:=0;

  f:=nil;
  try
  f:=TfileStream.create(st,fmCreate);

  openRiff('AVI ');

  openList('hdrl');

  openChunk('avih');
  avihOffset:=f.Position;
  writeAVIH;
  closeChunk;

  openList('strl');

  openChunk('strh');
  strhOffset:=f.Position;
  writeStrh;
  closeChunk;

  openChunk('strf');
  writeStrf;
  closeChunk;

  closeList;
  closeList;

  openChunk('JUNK');
  fillchar(junk,sizeof(junk),0);
  f.write(junk,sizeof(junk));
  closeChunk;


  openlist('movi');
  offset0:=f.size+4;
  open:=true;
  except
  open:=false;
  end;
end;


destructor TsimpleAVI.destroy;
var
  res:integer;
  idArray:array of TAVIINDEXENTRY;
  i:integer;
begin
  if open then
    begin
      closeList; {close movi}

      openChunk('idx1');               {créer le chunk index }
      setLength(idArray,totFrame);
      for i:=0 to totFrame-1 do
        with idArray[i] do
        begin
          ckid:=mkFourCC('0','0','d','b');
          dwFlags:=16;
          dwChunkOffset:=intG(OffsetList[i]);
          dwChunkLength:=intG(SizeList[i]);
        end;
      f.Write(idArray[0],sizeof(TAVIINDEXENTRY)*totFrame);
      closeChunk;


      f.Position:=avihOffset;           {mettre à jour avih}
      writeavih;

      f.Position:=strhOffset;           { et strh}
      writeStrh;

      f.Position:=f.Size;

      closeRiff;                      {on ferme}

      f.Free;

    end;

  chunkList.free;
  ListList.free;
  SizeList.free;
  OffsetList.free;

  inherited;
end;

procedure TsimpleAVI.save(dib:Tdib);
var
  res,size:integer;
begin
  if not open then exit;

  openChunk('00db');

  OffsetList.add(pointer(f.size-offset0));
  size:=dib.saveImage(f);
  SizeList.add(pointer(size));

  if size>maxSize then maxSize:=size;
  inc(totFrame);

  closeChunk;
end;


function saveBitmapImage(bm:Tbitmap; f: Tstream): integer;
begin
  case bm.PixelFormat of
    pf8bit:  result:=1;
    pf24bit: result:=3;
    pf32bit: result:=4;
    else result:=0;
  end;

  result:= result*bm.Width*bm.Height;
  f.Write(bm.scanline[0]^,result);
end;

procedure TsimpleAVI.save(bm:Tbitmap);
var
  res,size:integer;
begin
  if not open then exit;

  openChunk('00db');

  OffsetList.add(pointer(f.size-offset0));
  size:=saveBitmapImage(bm,f);
  SizeList.add(pointer(size));

  if size>maxSize then maxSize:=size;
  inc(totFrame);

  closeChunk;
end;



procedure TsimpleAVI.writeAvih;
var
  avih:TmainAviHeader;
  res:integer;
begin
  fillchar(avih,sizeof(avih),0);
  with avih do
  begin
    dwMicroSecPerFrame      :=1000000 div fps;
    dwMaxBytesPerSec        :=MaxSize*fps;
    dwPaddingGranularity    :=0;
    dwFlags                 :=AVIF_HASINDEX;
    dwTotalFrames           :=TotFrame;        // # frames in file
    dwInitialFrames         :=0;
    dwStreams               :=1;
    dwSuggestedBufferSize   :=MaxSize;

    dwWidth                 :=info.bmiHeader.biWidth  ;
    dwHeight                :=info.bmiHeader.biHeight ;
  end;

  f.write(avih,sizeof(avih));
end;

procedure TsimpleAVI.writestrh;
var
  strh:TAviStreamHeader;
  res:integer;
begin
  fillchar(strh,sizeof(strh),0);
  with strh do
  begin
    fccType                 :=mkFourCC('v','i','d','s');
    fccHandler              :=0;
    dwFlags                 :=0;
    wPriority               :=0;
    wLanguage               :=0;
    dwInitialFrames         :=0;
    dwScale                 :=1;
    dwRate                  :=fps;
    dwStart                 :=0;
    dwLength                :=totFrame;
    dwSuggestedBufferSize   :=maxSize;
    dwQuality               :=0;
    dwSampleSize            :=0;
  end;

  f.write(strh,{sizeof(strh)}56);
end;

procedure TsimpleAVI.writestrf;
var
  res:integer;
begin
  f.write(info,sizeof(info));
end;




end.
