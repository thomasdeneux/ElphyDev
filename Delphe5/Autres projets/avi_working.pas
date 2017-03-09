

begin
  NColor:=colorDepth[OutputOptionForm.ColorDepthGroup.ItemIndex];
  //const colorDepth : array[0..2] of integer = (16, 256, 65536);

  AVIFileInit;
  AVIFileOpen(pfile, PChar(filename), OF_WRITE or OF_CREATE, nil);

  with Mainform.glImage.Picture.Bitmap do
    begin
      InternalGetDIBSizes( Handle, BitmapInfoSize, BitmapSize, NColor);
      BitmapInfo:=AllocMem(BitmapInfoSize);
      BitmapBits:=AllocMem(BitmapSize);
      InternalGetDIB(Handle, 0, BitmapInfo^, BitmapBits^, NColor);
    end;

  FillChar(asi,sizeof(asi),0);
  asi.fccType   := streamtypeVIDEO; //  Now prepare the stream
  asi.fccHandler:= 0;
  asi.dwScale   := 1;         // dwRate / dwScale == samples/second
  asi.dwRate    := TimelineForm.FPSEdit.value;
  asi.dwSuggestedBufferSize:=BitmapSize;
  asi.rcFrame.Right  := BitmapInfo^.biWidth;
  asi.rcFrame.Bottom := BitmapInfo^.biHeight;

  AVIFileCreateStream(pfile, ps, @asi);
  with mainform.glImage.Picture.Bitmap do
    begin
     InternalGetDIB(Handle,0,BitmapInfo^,BitmapBits^, NColor);
     //AVIStreamSetFormat(ps, 0, BitmapInfo, BitmapInfoSize)
     (*  IT's this line that cause the problem!  *)
     galpAVIOptions:=@gaAVIOptions;
     fillchar(gaAVIOptions, sizeof(gaAVIOptions), 0);

     AVISaveOptions(mainform.Handle, ICMF_CHOOSE_KEYFRAME or ICMF_CHOOSE_DATARATE,
     1, ps, galpAVIOptions);
     AVIMakeCompressedStream(ps_c, ps, galpAVIOptions, nil);
     AVIStreamSetFormat(ps_c, 0, BitmapInfo, BitmapInfoSize);

     mainform.RenderIntoBitmap;
     mainform.glImage.Invalidate; // to refresh it

     InternalGetDIB( mainform.glImage.Picture.Bitmap.Handle, 0, BitmapInfo^, BitmapBits^, NColor);
     AVIStreamWrite(ps_c, i, 1, BitmapBits, BitmapSize, AVIIF_KEYFRAME, nil, nil);
    end;

  AVIStreamRelease(ps);
  AVIStreamRelease(ps_c);
  AVIFileRelease(pfile);
  AVIFileExit;
end;
