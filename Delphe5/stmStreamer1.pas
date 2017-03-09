unit stmStreamer1;


interface

uses windows, classes,graphics, sysutils,

     Direct3D9G, D3DX9G,

     util1,varconf1,Dgraphic, debug0,  DibG,
     ippDefs,ipps,ippsOvr,
     stmdef,stmObj,stmMvtX1, stmObv0, defForm,
     Ncdef2,stmPG,
     syspal32,
     stmVSBM1,
     stmOIseq1, cuda1,
     stmMat1;


{ TVSstream gère un flux d'image et les affiche dans un TVSbitmap
  Les images sont
    - soit dans une liste de fichiers BMP ou JPEG
    - soit dans un fichier texture
    - soit dans un OIseq
    - on pourrait ajouter une liste de matrices


}


Const
  TexHeaderIdent= 'Elphy Texture';
type
  TtexHeader= record
                ident:String[13];
                mySize:integer;
                Nx,Ny:integer;
                tpNum: typetypeG;
              end;



  TVSstream= class(TonOff)
                Images:TstringList;
                BMwidth, BMheight: integer;

                BMTexture0: IDirect3DTexture9;
                // On charge l'image dans BMtexture0 puis on copie BMtexture0 dans BMtexture du VSbitmap
                // BMtexture0 est en mémoire PC, BMtexture est en mémoire graphique

                FpolarMode: boolean; // si true, on appelle Cuda1.CartToPolar
                Fretina: boolean;

                hdib: Tdib;                 // intermédiaire pour charger une image à partir d'un fichier.

                Lmini, Lmaxi: single;
                oi: Toiseq;

                stTextureFile: AnsiString;
                TextureFile: TStream;
                TextureFileMem: TmemoryStream;
                FtextureMem: boolean;

                TexImageCount: integer;
                TexHeader:TtexHeader;
                TexBuffer:pointer;
                TexHeaderSize:integer;
                TexBufferSize:integer;

                CudaFlag: boolean;

                matXretina,matYretina: array of single;

                VideoList: pointer;

                procedure CreateBMtexture;
                procedure LoadTexture(num:integer);
                procedure LoadDib(num:integer);

                procedure LoadTextureFromDib(num: integer; xRect: D3DLOCKED_RECT);
                procedure LoadTextureFromTextureFile(num: integer; xRect: D3DLOCKED_RECT);
                procedure LoadTextureFromOI(num: integer;  xRect: D3DLOCKED_RECT);

                procedure LoadFileInVideo;
                constructor create;override;
                destructor destroy;override;
                class function STMClassName:AnsiString;override;

                procedure InitMvt; override;
                procedure InitObvis;override;

                procedure calculeMvt; override;
                procedure DoneMvt;override;
                function ImageCount: integer;


                procedure AddImage(st:AnsiString);
                procedure ClearImages;
                function valid:boolean;override;

                procedure InstallOIseq(oi1: Toiseq);
                function InstallTexFile(stF:AnsiString):boolean;
                procedure FreeTexFile;

                procedure InitCudaResources;
                procedure FreeCudaResources;

                procedure setRetinaParams(var matX1,matY1: Tmatrix);
              end;


procedure proTVSstream_create(var pu:typeUO);pascal;

procedure proTVSstream_AddImage(st:Ansistring; var pu:typeUO);pascal;
procedure proTVSstream_ClearImages(var pu:typeUO);pascal;

procedure proTVSstream_setLminLmax(L1,L2: float ;var pu:typeUO);pascal;

procedure proTVSstream_InstallOIseq(var oi1: Toiseq;var pu:typeUO);pascal;
procedure proTVSstream_InstallTextureFile(stF:AnsiString;var pu:typeUO);pascal;
procedure proTVSstream_InstallTextureFileInMemory(stF:AnsiString;var pu:typeUO);pascal;
procedure proTVSstream_CudaTest(n:integer; var pu:typeUO);pascal;

procedure proTVSstream_PolarMode( w:boolean ;var pu:typeUO);pascal;
function fonctionTVSstream_PolarMode(var pu:typeUO): boolean;pascal;

procedure proTVSstream_RetinaMode( w:boolean ;var pu:typeUO);pascal;
function fonctionTVSstream_RetinaMode(var pu:typeUO): boolean;pascal;
procedure proTVSstream_setRetinaParams(var matX,matY: Tmatrix; var pu:typeUO);pascal;



implementation

{ TVSstream }

constructor TVSstream.create;
var
  i:integer;
begin
  inherited;
  hdib:=Tdib.Create;
  Images:=TstringList.create;

  Lmini:=0;
  Lmaxi:=syspal.Lmax;  // par défaut

  CudaFlag:= initCudaLib1;
end;

destructor TVSstream.destroy;
var
  i:integer;
begin
  images.Free;
  hdib.Free;
  TextureFile.Free;
  TextureFileMem.Free;
  BMtexture0:=nil;

  derefObjet(typeUO(oi));

  inherited;
end;


class function TVSstream.STMClassName: AnsiString;
begin
  result:='VSstream';
end;

function TVSstream.valid:boolean;
begin
  result:=assigned(obvis) and (ImageCount>0) ;
end;

function TVSstream.ImageCount: integer;
begin
  if assigned(oi) then result:= oi.FrameCount
  else
  if stTextureFile<>'' then result:= TexImageCount
  else result:= images.Count;
end;



procedure TVSstream.InitMvt;
var
  i,res:integer;
  f: TfileStream;
begin
  if assigned(oi) then
  begin
    BMwidth:=oi.Nx;
    BMheight:=oi.Ny;
  end
  else
  if stTextureFile<>'' then
  begin
    if FTextureMem then LoadFileInVideo
    else
    begin
      TextureFile:= TfileStream.Create(stTextureFile,fmOpenRead);
      TextureFile.Position:= TexHeaderSize;
    end;
    //BMwidth et BMheight sont mis en place dans installTexFile
  end
  else
  begin
    LoadDib(0);

    BMwidth:=hdib.Width;
    BMheight:=hdib.height;
  end;
  CreateBMTexture;  // crée la texture BMtexture0

  initObvis;
  inherited;
                    // crée la texture VSbitmap.BMtexture
  {
  if CudaFlag and (FPolarMode or Fretina) then
  begin
    res:=registerVSstream(BMtexture[0],BMtexture[1],BMwidth,BMheight);
    if res<>0 then messageCentral('registerVSstream='+Istr(res));
    if Fretina then
    begin
      if (length(matXretina)=BMwidth*BMheight) and (length(matYretina)=BMwidth*BMheight)
        then registerRetina(@matXretina[0], @matYretina[0])
        else
        begin
          messageCentral('RegisterRetina error');
          Fretina:=false;
        end;
    end;
  end;
  }

  if not FtextureMem then LoadTexture(0); // BMtexture0 reçoit la première image de la liste
end;

procedure TVSstream.InitObvis;
begin
  TVSbitmap(obvis).initBM(BMwidth,BMheight);
  TVSbitmap(obvis).prepareS;
  if FtextureMem then TVSbitmap(obvis).registerCuda;
  inherited;
end;

procedure TVSstream.calculeMvt;
var
  tCycle,num:integer;
  res:integer;
begin
  tCycle:=timeS mod dureeC;
  num:= timeS div dureeC;

  if num<imageCount then
  begin
    if tcycle= 0 then
    begin
      if FtextureMem then ImageList_UpdateTexture(VideoList,num,TVSbitmap(obvis).BMCudaResource)
      else
      begin
        res:= DXscreen.Idevice.UpdateTexture(BMtexture0,TVSbitmap(obvis).BMtexture);
        if res<>0 then messageCentral('VSstream.UpdateTexture='+hexa(res));
      end;
    end;

    if (tcycle= dureeC div 2) and not FtextureMem then LoadTexture(num+1);

  end
  else BMTexture0:=nil;
end;

procedure TVSstream.DoneMvt;
var
  i:integer;
begin
  BMtexture0:=nil;

  //if CudaFlag and (FPolarMode or Fretina) then UnregisterVSstream;

  if FtextureMem then
  begin
    FreeImageList(VideoList);
    VideoList:=nil;
  end
  else
  if assigned(TextureFile) then
  begin
    textureFile.Free;
    textureFile:= nil;
  end;
end;

procedure TVSstream.AddImage(st:AnsiString);
begin
  images.add(st);
end;

procedure TVSstream.ClearImages;
begin
  Images.clear;;
end;

procedure TVSstream.CreateBMtexture;
var
  res, i:integer;
begin
  // On crée une texture en mémoire système. Ce qui permet de la charger de différentes façons
  // Le but est d'utiliser ensuite UpdateTexture pour la transférer dans le BMtexture du VSbitmap (en mémoire vidéo)
  res:= D3DXCreateTexture(DXscreen.Idevice,BMwidth,BMheight,0,0,D3DFMT_A8R8G8B8,D3DPOOL_SYSTEMMEM,BMtexture0);
  // Rappel: UpdateTexture ne fonctionne que si
  //    -  la source est D3DPOOL_SYSTEMMEM et la destination est D3DPOOL_DEFAULT
  //    -  source et dest sont sans AUTOGENMIPMAP

end;


procedure TVSstream.LoadTexture(num:integer);
var
  xRect: D3DLOCKED_RECT;
  res:integer;
begin
  if not assigned(hdib) and not assigned(oi) and (stTextureFile='') then exit;

  if BMtexture0.LockRect( 0, xrect, nil, 0) = 0 then
  begin
    if assigned(TextureFile) then LoadTextureFromTextureFile(num,xrect)
    else
    if assigned(oi) then LoadTextureFromOI(num,xrect)
    else
    LoadTextureFromDib(num,xrect);

    res:=BMTexture0.UnlockRect(0);
  end;
end;


procedure TVSstream.LoadDib(num: integer);
begin
  if not assigned(oi) and (stTextureFile='') then
    if num<images.count
      then LoadDibFromFile( hDib,images[num]);
end;

procedure TVSstream.LoadTextureFromDib(num: integer; xRect: D3DLOCKED_RECT);
var
  i,j: integer;
  p:PtabLong;
  p1: PtabOctet;
  w: longword;
begin
  LoadDib(num);
  with xRect do
  begin
    for j:= 0 to hdib.height-1 do
    begin
      p1:=hdib.ScanLine[j];
      p:= pointer(intG(pbits)+pitch*j);
      for i:= 0 to hdib.width-1 do
      begin
        case hdib.BitCount of
          8:   p^[i]:= syspal.DX9colorI(p1^[i], $FF );
          24:  p^[i]:= D3Dcolor_rgba(p1^[i*3+2] ,p1^[i*3+1] , p1^[i*3] , $FF );
          32:  p^[i]:= D3Dcolor_rgba(p1^[i*4+2] ,p1^[i*4+1] , p1^[i*4] , $FF );

          else
          begin
            w:=hdib.canvas.pixels[i,j];
            p^[i]:= D3Dcolor_rgba( w and $FF, (w shr 8) and $FF, (w shr 16) and $FF , $FF );
          end;
        end;
      end;
    end;
  end;

end;


procedure TVSstream.InstallOIseq(oi1: Toiseq);
begin
  derefObjet(typeUO(oi));
  oi:= oi1;
  refObjet(typeUO(oi));

  stTextureFile:='';
end;

procedure TVSstream.LoadTextureFromOI(num: integer;  xRect: D3DLOCKED_RECT);
var
  p:PtabLong;
  p1: PtabOctet;
  w: integer;
  tbS: PtabSingle;
  tbD: PtabDouble absolute tbS;
  Lmini1,Lmaxi1:single;
  i,j:integer;
begin
  Lmini1:=syspal.lumIndex(Lmini);
  Lmaxi1:=syspal.lumIndex(Lmaxi);

  if num<oi.FrameCount then
  begin
    tbS:= oi.mat[num].tb;
    with xRect do
    begin
      for j:= 0 to oi.ny-1 do
      begin
        p:= pointer(intG(pbits)+pitch*j);
        for i:= 0 to oi.nx-1 do
        begin
          case oi.tpNum of
            g_single:   w:= round(Lmini1+ tbS^[i+oi.Nx*j]*(Lmaxi1-Lmini1)/255);
            g_double:   w:= round(Lmini1+ tbD^[i+oi.Nx*j]*(Lmaxi1-Lmini1)/255);
          end;
          if w<0 then w:=0
          else
          if w>253 then w:=253;
          p^[i]:= syspal.DX9colorI(w, $FF );
        end;
      end;
    end;
  end;
end;

procedure SingleToGreen(pSrc: Psingle; pDst: Plongint; len:integer);
var
  pAux:Plongint;
begin
  getmem(pAux,len*4);
  ippsConvert_32f32s_Sfs(pSrc, pDst,      len,ippRndZero,0);
  ippsAndC_32u_I(255, Plongword(pDst), len);
  ippsLshiftC_32s( pDst, 8,pAux,len);
  ippsAddC_32s_Sfs(pAux, 255, pDst, len, 0);
  freemem(pAux);
end;

procedure ByteToGreen(pSrc: Pbyte; pDst: Plongint; len:integer);
var
  pAux:Plongint;
begin
  getmem(pAux,len*4);

  ippsConvert_8u32f(pSrc, Psingle(pAux),len);
  ippsConvert_32f32s_Sfs(Psingle(Paux), pDst,      len,ippRndZero,0);
  ippsAndC_32u_I(255, Plongword(pDst), len);
  ippsLshiftC_32s( pDst, 8,pAux,len);
  ippsAddC_32s_Sfs(pAux, 255, pDst, len, 0);
  freemem(pAux);
end;


procedure TVSstream.LoadTextureFromTextureFile(num: integer;  xRect: D3DLOCKED_RECT);
var
  Lmini1, Lmaxi1: single;
  pFile: int64;
  p:PtabLong;
  p0: longword;
  i,j:integer;
  w:integer;
  KminMax: single;

  Tbdum:array of byte;
begin
  Lmini1:=syspal.lumIndex(abs(Lmini));        // renvoie deux nombres compris entre 1 et 253
  if Lmini<0 then Lmini1:=-Lmini1;

  Lmaxi1:=syspal.lumIndex(Lmaxi);

  with TexHeader, xRect do
  begin
    pFile:=TexHeaderSize+ num*TexBufferSize;
    TextureFile.position:=pFile;
    TextureFile.Read(TexBuffer^,TexBufferSize);

    KminMax:= (Lmaxi1-Lmini1)/255;
    case tpNum of
      g_byte: for j:= 0 to ny-1 do
              begin
                p:= pointer(intG(pbits)+pitch*j);
                for i:= 0 to nx-1 do
                begin
                  w:= round(Lmini1+ PtabOctet(TexBuffer)^[i+Nx*j]* KminMax);
                  p0:= syspal.DX9colorI(w, $FF );  { au lieu de p^[i]:=}
                  move(p0,p^[i],3);
                end;
              end;

      g_single:
             for j:= 0 to ny-1 do
              begin
                p:= pointer(intG(pbits)+pitch*j);
                for i:= 0 to nx-1 do
                begin
                  w:= round(Lmini1+ PtabSingle(TexBuffer)^[i+Nx*j]* KminMax);
                  if w<1 then w:=1 else if w>253 then w:=253;
                  p0:= syspal.DX9colorI(w, $FF );  { au lieu de p^[i]:=}
                  move(p0,p^[i],3);
                end;
              end;
    end;
  end;
end;

procedure TVSstream.LoadFileInVideo;
var
  Lmini1, Lmaxi1: single;
  i,j:integer;
  w:integer;
  KminMax: single;

  buf: pointer;
  f: TfileStream;
  res: integer;
begin
  Lmini1:=syspal.lumIndex(abs(Lmini));        // renvoie deux nombres compris entre 1 et 253
  if Lmini<0 then Lmini1:=-Lmini1;
  Lmaxi1:=syspal.lumIndex(Lmaxi);

  KminMax:= (Lmaxi1-Lmini1)/255;



  getmem(buf, TexBufferSize);

  with TexHeader do VideoList:=CreateImageList(Nx,Ny);
  f:= TfileStream.Create(stTextureFile,fmOpenRead);
  f.Position:= TexHeaderSize;

  for i:=0 to CycleCount-1 do
  begin
    f.Read(buf^,TexBufferSize);
    res:= ImageList_Add(VideoList, buf);
    if res<>0 then break;
  end;
  f.Free;

  freemem(buf);



  ImageList_setScaling(VideoList, KminMax, Lmini1);
  //ImageList_SetMask(VideoList, CudaRgbMask);

end;


function TVSstream.InstallTexFile(stF: AnsiString):boolean;
var
  Nb:integer;
begin
  derefObjet(typeUO(oi));
  FreeTexFile;

  result:=fileExists(stF);
  if not result then exit;

  // On met en place le buffer et les paramètres utiles mais on ferme le fichier

  try
  stTextureFile:=stF;
  TextureFile:= TfileStream.Create(stTextureFile,fmOpenRead);

  Nb:= sizeof(texHeader.Ident)+sizeof(texHeader.mySize);  // lire ident et mysize
  TextureFile.read(texHeader, Nb);

  if TexHeader.ident<>TexHeaderIdent then                 // vérifier ident
  begin
    FreeTexFile;
    result:=false;
    exit;
  end;

  TextureFile.Read(TexHeader.Nx,TexHeader.mySize-Nb);
  BMwidth:=TexHeader.Nx;
  BMheight:=TexHeader.Ny;

  TexHeaderSize:=TexHeader.mySize;

  with TexHeader do TexBufferSize:=Nx*Ny*tailleTypeG[tpNum];
  getmem(TexBuffer, TexBufferSize);

  if TexBufferSize>0
    then TexImageCount:=(TextureFile.Size-TexHeaderSize) div TexBufferSize;

  cycleCount:=TexImageCount;

  finally
  TextureFile.Free;
  TextureFile:=nil;
  end;

end;

procedure TVSstream.FreeTexFile;
begin
   stTextureFile:='';
   if assigned(TextureFile) then
   begin
     TextureFile.Free;
     TextureFile:=nil;
   end;

   TexBufferSize:=0;
   Freemem(TexBuffer);
   TexBuffer:=nil;
   BMwidth:=0;
   BMheight:=0;
end;

procedure TVSstream.setRetinaParams(var matX1, matY1: Tmatrix);
var
  i,j:integer;
begin
  with matX1 do
  begin
    setlength(matXretina,Icount*Jcount);
    for j:=0 to Jcount-1 do              //rangement ligne par ligne
    for i:=0 to Icount-1 do
      matXretina[j*Icount+i]:=matX1[Istart+i,Jstart+j];

    setlength(matYretina,Icount*Jcount);
    for j:=0 to Jcount-1 do
    for i:=0 to Icount-1 do
      matYretina[j*Icount+i]:=matY1[Istart+i,Jstart+j];

  end;

end;


{***************************** Méthodes STM de TVSstream ********************}

procedure proTVSstream_create(var pu:typeUO);
begin
  createPgObject('',pu,TVSstream);
end;


procedure proTVSstream_AddImage(st:Ansistring;var pu:typeUO);
begin
  verifierObjet(pu);
  if not fileExists(st) then sortieErreur('TVSstream.addImage : file not found');
  TVSstream(pu).AddImage(st);
end;


procedure proTVSstream_ClearImages(var pu:typeUO);
begin
  verifierObjet(pu);

  TVSstream(pu).ClearImages;
end;

procedure proTVSstream_InstallOIseq(var oi1: Toiseq;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(oi1));
  TVSstream(pu).InstallOIseq(oi1);
end;

procedure proTVSstream_InstallTextureFile(stF:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  if not TVSstream(pu).InstallTexFile(stF)
    then sortieErreur('TVSstream.InstallTextureFile : file not found');
  TVSstream(pu).FtextureMem:= false;
end;

procedure proTVSstream_InstallTextureFileInMemory(stF:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  if not TVSstream(pu).InstallTexFile(stF)
    then sortieErreur('TVSstream.InstallTextureFile : file not found');

  TVSstream(pu).FtextureMem:= true;
end;


procedure proTVSstream_setLminLmax(L1,L2: float ;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSstream(pu).Lmini:=L1;
  TVSstream(pu).Lmaxi:=L2;

end;

procedure proTVSstream_PolarMode( w:boolean ;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSstream(pu).FpolarMode:=w;
end;

function fonctionTVSstream_PolarMode(var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  result:= TVSstream(pu).FpolarMode;
end;

procedure proTVSstream_RetinaMode( w:boolean ;var pu:typeUO);
begin
  verifierObjet(pu);
  TVSstream(pu).Fretina:=w;
end;

function fonctionTVSstream_RetinaMode(var pu:typeUO): boolean;
begin
  verifierObjet(pu);
  result:= TVSstream(pu).Fretina;
end;

procedure proTVSstream_setRetinaParams(var matX,matY: Tmatrix ;var pu:typeUO);
begin
  verifierObjet(pu);
  verifiermatrice(matX);
  verifiermatrice(matY);

  TVSstream(pu).setRetinaParams(matX,matY);
end;


procedure TVSstream.FreeCudaResources;
begin

end;

procedure TVSstream.InitCudaResources;
begin

end;

procedure proTVSstream_CudaTest(n:integer; var pu:typeUO);
begin
end;




Initialization
AffDebug('Initialization stmVSstreamer1',0);
registerObject(TVSstream,stim);


end.
