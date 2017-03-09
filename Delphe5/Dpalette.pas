unit Dpalette;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,sysutils,forms,messages,graphics,
      util1,debug0,
      dibG;

 { Dpalette gère une palette de dégradés de couleurs en se basant sur une
   ou deux couleurs fondamentales:
  'R  ','G  ','B  ','RG ','RB ','GB ','RGB' (numéros de 1 à 7)

  On initialise avec
    Create
    SetColors(couleur1, couleur2,DeuxCouleurs,DC);
    SetPalette(Lmin,Lmax,gamma);

  Ensuite ColorPal(x) renvoie la couleur RGB correspondant à x
 }

type
  TpaletteType=(mono,rgb1,D2,FullD2);
  T2Dpalette=array[0..15] of integer;

  TDpalette=class
              private
              Vred:boolean;
              Vgreen:boolean;
              Vblue:boolean;

              Vred1:boolean;
              Vgreen1:boolean;
              Vblue1:boolean;

              degradePal,degradePal1:byte;
              PaletteRGB1:array[0..255] of integer;
              quads:TrgbQuads;

              LogXminPal:float;
              LogXmaxPal:float;
              ModeLog:boolean;

              function ColorPal1(x:float):longint;

              public

              TwoCol:boolean;
              XminPal:float;
              XmaxPal:float;
              GammaPal:float;

              YminPal,YmaxPal,GammaPal2:float;

              paletteType:TpaletteType;

              constructor create;
              destructor destroy;override;
              procedure setColors(n1,n2:integer;deux:boolean;dc:hdc);
              procedure setPalette(Lmin,Lmax,gamma:float;const logZ:boolean=false);

              function ColorPalRGB1(x:float):longint;
              function ColorPalMono(x:float):longint;
              function ColorPal(x:float):longint;



              function ColorIndex(x:float):integer;

              procedure initPaletteRGB1;

              procedure setType(stF:AnsiString);

              function rgbQuads:TrgbQuads;
              function rgbPalette:TmaxLogPalette;

              procedure buildQuads;
              function ColorQuad(x:float):longint;

              function ColorIndex2(y:float):integer;

              function ColorIndex2D(x,y:float):integer;
              function color2D(x,y:float):integer;
              procedure set2DPal(p:T2Dpalette);
              procedure set2DPalette(full:boolean);
              procedure setChrominance(Cmin,Cmax,gamma:float);
            end;

function getDColor(n,w:integer):longint;



IMPLEMENTATION

{ février 2011 : on supprime PaletteHandle
                        donc CreateStm2Palette
                         et  SelectDpaletteHandle
                         etc...
}


const
  NmaxPal:integer=255;


constructor TDpalette.create;
begin
  setColors(1,2,true,0);
  setPalette(0,10,1);
  setChrominance(0,10,1);
  initPaletteRGB1;
  paletteType:=mono;
end;

procedure TDpalette.initPaletteRGB1;
var
  i:integer;
begin
  for i:=0 to 63 do
    begin
      paletteRGB1[i]:=rgb(0,i*4,255);
      paletteRGB1[64+i]:=rgb(0,255,252-i*4);
      paletteRGB1[128+i]:=rgb(i*4,255,0);
      paletteRGB1[192+i]:=rgb(255,252-i*4,0);
    end;

end;

function TDpalette.ColorIndex(x: float): integer;
var
  c:float;
begin
  if ModeLog and (XminPal>0) and (XmaxPal>0) then
  begin
    if x<XminPal then x:=XminPal
    else
    if x>XmaxPal then x:=XmaxPal;

    if LogxmaxPal>LogxminPal
      then c:=(ln(x)-LogXminPal)/(LogxmaxPal-LogxminPal)
      else c:=(LogXminPal-ln(x))/(LogxminPal-LogxmaxPal);
  end
  else
  if xmaxPal>xminPal
    then c:=(x-XminPal)/(xmaxPal-xminPal)
    else c:=(XminPal-x)/(xminPal-xmaxPal);

  if c<=0 then c:=1E-300
  else
  if c>1 then c:=1;
  result:=roundI(NmaxPal*exp(gammaPal*ln(c)));
end;


function TDpalette.ColorPal1(x:float):longint;
  var
    c:float;
    i:integer;
    col:longint;
  begin

    if (x>=0) and (xmaxPal<>0) then c:=abs(x/xmaxPal)
    else
    if (x<0) and (xminPal<>0) then c:=abs(x/xminPal)
    else
      begin
        colorPal1:=0;
        exit;
      end;

    if c<=0 then c:=1E-300
    else
    if c>1 then c:=1;
    i:=roundI(NmaxPal*exp(gammaPal*ln(c)));

    if x>=0 then ColorPal1:=rgb(ord(Vred)*i,ord(Vgreen)*i,ord(Vblue)*i)
            else ColorPal1:=rgb(ord(Vred1)*i,ord(Vgreen1)*i,ord(Vblue1)*i);
  end;

function TDpalette.ColorPalMono(x:float):longint;
  var
    c:float;
    i:integer;
  begin
    if twoCol then
      begin
        result:=colorPal1(x);
        exit;
      end;

    i:=colorIndex(x);

    result:=rgb(ord(Vred)*i,ord(Vgreen)*i,ord(Vblue)*i);
  end;

function TDpalette.ColorPalRgB1(x:float):longint;
var
  i:integer;
begin
  i:=colorIndex(x);
  result:=paletteRGB1[i];
end;

function TDpalette.ColorPal(x:float):longint;
begin
  try
  case paletteType of
    mono: result:=colorPalMono(x);
    rgb1,D2,FullD2: result:=colorPalRGB1(x);
  end;
  except
  result:=0;
  end;
end;

function TDpalette.ColorIndex2(y: float): integer;
var
  c:float;
begin
  if ymaxPal>yminPal
    then c:=(y-yminPal)/(ymaxPal-yminPal)
    else c:=(yminPal-y)/(yminPal-ymaxPal);

  if c<=0 then c:=1E-300
  else
  if c>1 then c:=1;
  result:=roundI(NmaxPal*exp(gammaPal2*ln(c)));
end;

function TDpalette.ColorIndex2D(x,y:float):integer;
var
  i,j:integer;
begin
  i:=colorIndex(x) div 16;
  j:=colorIndex2(y) div 16;

  result:= i+16*j;
end;

function TDpalette.color2D(x, y: float): integer;
var
  i,j:integer;
begin
  i:=colorIndex(x) div 16;
  j:=colorIndex2(y) div 16;

  {result:=colorPalRGB1(i+16*j);}
  result:=paletteRGB1[i+16*j];
end;

procedure TDpalette.set2DPal(p:T2Dpalette);
var
  i,j:integer;
  w:TpaletteEntry;
begin
  for i:=0 to 15 do
  for j:=0 to 15 do
  begin
    integer(w):=p[j];
    w.peFlags:=0;
    w.peRed:=(w.peRed*i) div 16;
    w.peGreen:=(w.peGreen*i) div 16;
    w.peBlue:=(w.peBlue*i) div 16;

    paletteRgb1[i+16*j]:=integer(w);
  end;

  PaletteType:=D2;
end;

procedure TDpalette.set2DPalette(full:boolean);
var
  p:T2Dpalette;
  i:integer;
begin
  if paletteType=mono then
  begin
    p[0]:=rgb(255,0,0);
    p[1]:=rgb(255,64,0);
    p[2]:=rgb(255,128,0);
    p[3]:=rgb(255,192,0);
    p[4]:=rgb(255,255,0);
    p[5]:=rgb(192,255,0);
    p[6]:=rgb(128,255,0);
    p[7]:=rgb(64,255,0);
    p[8]:=rgb(0,255,0);
    p[9]:=rgb(0,255,64);
    p[10]:=rgb(0,255,128);
    p[11]:=rgb(0,255,192);
    p[12]:=rgb(0,255,255);
    p[13]:=rgb(0,170,255);
    p[14]:=rgb(0,85,255);
    p[15]:=rgb(0,0,255);
  end
  else
  for i:=0 to 15 do p[i]:=paletteRgb1[i*16];

  if not full
    then set2Dpal(p)
    else paletteType:=FullD2;
end;


procedure TDpalette.setChrominance(Cmin,Cmax,gamma:float);
begin
  if Cmin=Cmax then exit;
  YminPal:=Cmin;
  YmaxPal:=Cmax;
  if (gamma>=0) and (gamma<=10) then GammaPal2:=Gamma;
end;




procedure TDpalette.setPalette(Lmin,Lmax,Gamma:float;const logZ:boolean=false);
begin
  if Lmin=Lmax then Lmax:=Lmin+1;

  try
  XminPal:=Lmin;
  if XminPal<-1E200 then XminPal:=-1E200;
  except
  XminPal:=-1E200;
  end;

  try
  XmaxPal:=Lmax;
  if XmaxPal> 1E200 then XmaxPal:= 1E200;
  except
  XmaxPal:= 1E200;
  end;


  if (gamma>=0) and (gamma<=10) then GammaPal:=Gamma;

  ModeLog:=LogZ;
  if XminPal>0 then LogXminPal:=ln(XminPal);
  if XmaxPal>0 then LogXmaxPal:=ln(XmaxPal);
end;

procedure TDpalette.setType(stF:AnsiString);
var
  f:TfileStream;
  res:integer;
begin
  stF:=Fmaj(stF);

  paletteType:=mono;

  if (stF='') or (stF='MONOCHROME') then exit;

  if stF='R' then setColors(1,1,false,0)
  else
  if stF='G' then setColors(2,1,false,0)
  else
  if stF='B' then setColors(3,1,false,0)
  else
  if stF='RG' then setColors(4,1,false,0)
  else
  if stF='RB' then setColors(5,1,false,0)
  else
  if stF='GB' then setColors(6,1,false,0)
  else
  if stF='RGB' then setColors(7,1,false,0);


  stF:= AppData +stF+'.PL1';
  if fileExists(stF) then
    begin
      f:=nil;
      TRY
      f:=TfileStream.create(stF,fmOpenRead);

      f.Read(paletteRgb1,sizeof(paletteRgb1));
      f.free;
      EXCEPT
      f.free;
      END;
      paletteType:=rgb1;
    end;
end;


procedure getLogPalStm(var logpal:TmaxLogPalette);
var
  i:integer;
begin
  fillchar(logPal,sizeof(logPal),0);
  with logPal do
  begin
    palVersion:=$300;
    palNumEntries:=160;
  end;

  with logPal do
  begin
    for i:=0 to 159 do palpalEntry[i].peFlags:= pC_RESERVED;
    for i:=0 to 15 do
      begin
        with palpalEntry[i] do peRed:=16*i;
        with palpalEntry[i+16] do peGreen:=16*i;
        with palpalEntry[i+32] do peBlue:=16*i;
        with palpalEntry[i+48] do
        begin
          peRed:=16*i;
          peGreen:=16*i;
        end;
        with palpalEntry[i+64] do
        begin
          peGreen:=16*i;
          peBlue:=16*i;
        end;
        with palpalEntry[i+80] do
        begin
          peRed:=16*i;
          peBlue:=16*i;
        end;
      end;

    for i:=0 to 63 do
      with palpalEntry[i+96] do
      begin
        peRed:=4*i;
        peGreen:=4*i;
        peBlue:=4*i;
      end;
  end;
end;


procedure TDpalette.setColors(n1,n2:integer;deux:boolean;dc:hdc);
type
  TMaxLogPalette=
       record
         palVersion:word;
         palNumEntries:word;
         palPalEntry:array[0..255] of TpaletteEntry;
       end;
var
  logPal:TMaxLogPalette;
  i:integer;
  old:hpalette;
begin
  degradePal:=n1;
  degradePal1:=n2;

  Vred:=(n1 in [1,4,5,7]);
  Vgreen:=(n1 in [2,4,6,7]);
  Vblue:=(n1 in [3,5,6,7]);

  Vred1:=(n2 in [1,4,5,7]);
  Vgreen1:=(n2 in [2,4,6,7]);
  Vblue1:=(n2 in [3,5,6,7]);

  twoCol:=deux;

end;

destructor TDpalette.destroy;
begin

end;


function getDColor(n,w:integer):longint;
  begin
    case n of
      1:getDcolor:=rgb(w,0,0);
      2:getDcolor:=rgb(0,w,0);
      3:getDcolor:=rgb(0,0,w);
      4:getDcolor:=rgb(w,w,0);
      5:getDcolor:=rgb(0,w,w);
      6:getDcolor:=rgb(w,0,w);
      7:getDcolor:=rgb(w,w,w);
      else getDColor:=0;
    end;
  end;



function TDpalette.rgbQuads: TrgbQuads;
var
  i,k0,kmax:integer;
begin
  case paletteType of
    mono:
      if not twocol then
        for i:=0 to 255 do
        with Result[i] do
        begin
          rgbRed := i*ord(Vred);
          rgbGreen := i*ord(Vgreen);
          rgbBlue := i*ord(Vblue);
          rgbReserved := 0;
        end
      else
      begin
        if xmaxPal<>xminPal
          then k0:=round(-XminPal/(xmaxPal-xminPal)*255)
          else k0:=0;
        if k0>255 then k0:=255;
        if k0<0 then k0:=0;

        if k0>0 then kmax:=k0 else kmax:=1;
        for i:=0 to k0 do
          with Result[i] do
          begin
            rgbRed := round((k0-i)*ord(Vred1)*255/kmax);
            rgbGreen := round((k0-i)*ord(Vgreen1)*255/kmax);
            rgbBlue := round((k0-i)*ord(Vblue1)*255/kmax);
            rgbReserved := 0;
          end;

        if k0<255 then kmax:=255-k0 else kmax:=1;
        for i:=k0 to 255 do
          with Result[i] do
          begin
            rgbRed := round((i-k0)*ord(Vred)*255/kmax);
            rgbGreen := round((i-k0)*ord(Vgreen)*255/kmax);
            rgbBlue := round((i-k0)*ord(Vblue)*255/kmax);
            rgbReserved := 0;
          end;

      end;

    rgb1,D2,FullD2:
      for i:=0 to 255 do
        with Result[i] do
        begin
          rgbRed :=    paletteRGB1[i] and 255;
          rgbGreen := (paletteRGB1[i] shr 8) and 255;
          rgbBlue :=  (paletteRGB1[i] shr 16) and 255;
          rgbReserved := 0;
        end;

  end;

end;

function TDpalette.rgbPalette:TmaxLogPalette;
var
  i,k0,kmax:integer;
begin
  result.palVersion:=$300;
  result.palNumEntries:=256;

  case paletteType of
    mono:
      if not twocol then
        for i:=0 to 255 do
        with Result.palPalEntry[i] do
        begin
          peRed := i*ord(Vred);
          peGreen := i*ord(Vgreen);
          peBlue := i*ord(Vblue);
          peFlags := 0;
        end
      else
      begin
        if xmaxPal<>xminPal
          then k0:=round(-XminPal/(xmaxPal-xminPal)*255)
          else k0:=0;
        if k0>255 then k0:=255;
        if k0<0 then k0:=0;

        if k0>0 then kmax:=k0 else kmax:=1;
        for i:=0 to k0 do
          with Result.palPalEntry[i] do
          begin
            peRed := round((k0-i)*ord(Vred1)*255/kmax);
            peGreen := round((k0-i)*ord(Vgreen1)*255/kmax);
            peBlue := round((k0-i)*ord(Vblue1)*255/kmax);
            peFlags := 0;
          end;

        if k0<255 then kmax:=255-k0 else kmax:=1;
        for i:=k0 to 255 do
          with Result.palPalEntry[i] do
          begin
            peRed := round((i-k0)*ord(Vred)*255/kmax);
            peGreen := round((i-k0)*ord(Vgreen)*255/kmax);
            peBlue := round((i-k0)*ord(Vblue)*255/kmax);
            peFlags := 0;
          end;

      end;

    rgb1,D2,FullD2:
      for i:=0 to 255 do
        with Result.palPalEntry[i] do
        begin
          peRed :=    paletteRGB1[i] and 255;
          peGreen := (paletteRGB1[i] shr 8) and 255;
          peBlue :=  (paletteRGB1[i] shr 16) and 255;
          peFlags := 0;
        end;

  end;

end;


procedure TDpalette.buildQuads;
begin
  quads:=rgbQuads;
end;

function TDpalette.ColorQuad(x:float):longint;
begin
  result:=integer(quads[colorIndex(x)]);
end;




Initialization
AffDebug('Initialization Dpalette',0);

end.
