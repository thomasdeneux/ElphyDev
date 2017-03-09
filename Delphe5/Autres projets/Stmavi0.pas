unit stmAvi0;

interface

uses windows,classes,graphics,sysutils,
     util1, Gdos, Dgraphic,
     stmDef, stmObj, stmVec1,
     Iunk, VFW, DIBitmap, multg1,
     Ncdef2, stmError,stmPg ;

type

  TaviBuilder=
            class(typeUO)
              fileName:string;
              Frate:integer;
              Fcount:integer;
              bm:Tbitmap;
              open:boolean;

              mg0:Tmultigraph;
              rect0:Trect;

              pfile: PAVIFile;
              asi: TAVIStreamInfo;
              ps, ps_c: PAVIStream;
              nul: Longint;

              BmInfo: PBitmapInfoHeader;
              BmInfoSize: integer;
              BmBits: Pointer;
              BmSize: Dword;

              AviInit:boolean;

              constructor create;override;
              destructor destroy;override;

              class function STMClassName:string;override;

              procedure createFile(st:string);
              procedure setWindow(num:integer);
              procedure buildBM;
              procedure save;
              procedure closeFile;

            end;


procedure proTaviBuilder_createFile(st:String;var pu:typeUO);pascal;
procedure proTaviBuilder_setWindow(num:smallInt;var pu:typeUO);   pascal;
procedure proTaviBuilder_save(var pu:typeUO);                     pascal;
procedure proTaviBuilder_closeFile(var pu:typeUO);                pascal;
procedure proTaviBuilder_rate(n:smallint;var pu:typeUO);          pascal;
function fonctionTaviBuilder_rate(var pu:typeUO):smallint;        pascal;

implementation

const
  E_aviFileOpen=4251;
  E_AVIFileCreateStream=4252;
  E_AVIStreamSetFormat=4253;
  E_AVIStreamWrite=4254;


class function TaviBuilder.STMClassName:string;
  begin
    STMClassName:='AviBuilder';
  end;

constructor TaviBuilder.create;
begin
  mg0:=DacMultigraph;
  rect0:=mg0.formG.paintbox1.ClientRect;
  bm:=Tbitmap.create;

  Frate:=20;
end;

destructor TaviBuilder.destroy;
begin
  if open then closeFile;
  bm.free;
end;


procedure TaviBuilder.createFile(st:string);
begin
  fileName:=st;
  open:=true;

end;

procedure TaviBuilder.buildBM;
var
  bmRef:Tbitmap;
begin
  bmRef:=mg0.formG.getBM;
  bm.width:=rect0.right-rect0.left+1;
  bm.height:=rect0.bottom-rect0.top+1;

  bm.canvas.copyRect(rect(0,0,bm.width-1,bm.height-1),bmref.Canvas,rect0);
end;

procedure TaviBuilder.save;
var
  gaAVIOptions:TAVICOMPRESSOPTIONS;
  galpAVIOptions:PAVICOMPRESSOPTIONS;
  res:integer;
  st:string[4];
begin
  if not open then exit;

  buildBM;

  if Fcount=0 then
    begin
      AVIFileInit;
      AVIinit:=true;

      if not AVIFileOpen(pfile, PChar(FileName), OF_WRITE or OF_CREATE, nil)=AVIERR_OK then
        begin
          sortieErreur(E_aviFileOpen);
          exit;
        end;

      FillChar(asi,sizeof(asi),0);

      asi.fccType := streamtypeVIDEO;
      asi.fccHandler := 0;
      asi.dwScale := 1;
      asi.dwRate := Frate;

      with BM do
      begin
        InternalGetDIBSizes(Handle,BmInfoSize,BmSize,256);
        BmInfo := AllocMem(BmInfoSize);
        BmBits := AllocMem(BmSize);
        InternalGetDIB(Handle,0,BmInfo^,BmBits^,256);
      end;

      asi.dwSuggestedBufferSize := BmInfo^.biSizeImage;
      asi.rcFrame.Right := BmInfo^.biWidth;
      asi.rcFrame.Bottom := BmInfo^.biHeight;

      if not (AVIFileCreateStream(pfile,ps,@asi)=AVIERR_OK) then
        begin
          sortieErreur(E_AVIFileCreateStream);
          exit;
        end;
      InternalGetDIB(bm.Handle,0,BmInfo^,BmBits^,256);

      fillchar(gaAVIOptions, sizeof(gaAVIOptions), 0);
      galpAVIOptions:=@gaAVIOptions;

      with gaAVIOptions do
      begin
        dwFlags := AVICOMPRESSF_VALID;
        fccType := streamtypeVIDEO;
        fccHandler := mmioFOURCC('m', 'r', 'l', 'e');
        {dwQuality := 6500;}
        dwKeyFrameEvery := 1;
      end;



      res:= AVIMakeCompressedStream(ps_c, ps, galpAVIOptions, nil);
      if res<>AviErr_OK then
        begin
          messageCentral('AVIMakeCompressedStream='+Istr(res));
          exit;
        end;

      res:=AVIStreamSetFormat(ps_c, 0, BmInfo, BmInfoSize);
      if res<>AviErr_OK then
        begin
          messageCentral('AVIStreamSetFormat='+Istr(res));
          exit;
        end;
    end;

  with BM do
  begin
    InternalGetDIB(Handle,0,BmInfo^,BmBits^,256);
    if AVIStreamWrite(ps_c,Fcount,1,BmBits,BmSize,AVIIF_KEYFRAME,@nul,@nul)<>AVIERR_OK then
      begin
        sortieErreur(E_AVIStreamWrite);
        exit;
      end;

  end;

  inc(Fcount);

end;

procedure TaviBuilder.closeFile;
begin
  if not open then exit;

  if assigned(bmInfo) then FreeMem(BmInfo,bmInfoSize);
  if assigned(bmBits) then FreeMem(BmBits,bmSize);

  if assigned(ps) then AVIStreamRelease(ps);
  if assigned(ps_c) then AVIStreamRelease(ps_c);
  if assigned(pfile) then AVIFileRelease(pfile);

  if AVIinit then AVIFileExit;
  open:=false;

end;

procedure TaviBuilder.setWindow(num:integer);
begin
  rect0:=mg0.formG.getCadre(num);
end;



procedure proTaviBuilder_createFile(st:String;var pu:typeUO);
begin
  createPgObject('',pu,TaviBuilder);
  with TaviBuilder(pu) do createFile(st);
end;

procedure proTaviBuilder_setWindow(num:smallInt;var pu:typeUO);
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do setWindow(num-1);
end;

procedure proTaviBuilder_save(var pu:typeUO);
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do save;
end;

procedure proTaviBuilder_closeFile(var pu:typeUO);
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do closeFile;

  proTobject_free(pu);
end;

procedure proTaviBuilder_rate(n:smallint;var pu:typeUO);
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do Frate:=n;
end;

function fonctionTaviBuilder_rate(var pu:typeUO):smallint;
begin
  verifierObjet(pu);
  with TaviBuilder(pu) do result:=Frate;
end;


initialization
  installError(E_aviFileOpen,'TaviBuilder: unable to open file');
  installError(E_AVIFileCreateStream, 'TaviBuilder: CreateStream error');
  installError(E_AVIStreamSetFormat, 'TaviBuilder: StreamSetFormat error');
  installError(E_AVIStreamWrite, 'TaviBuilder: AVIStreamWrite error');

  registerObject(TaviBuilder,sys);
  
end.
