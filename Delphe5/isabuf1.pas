unit isabuf1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,
     util1,Gdos,QTthunkG;

var
  realTab1:integer;      { adresse réelle du buffer utilisée dans la
                           programmation du DMA }
  tabDMA1ISA:ptabEntier; { adresse 32 bits du buffer DMA }
  tailleTabDma1ISA:integer; { sa taille en octets }

  realTab2:integer;      { adresse réelle du buffer utilisée dans la
                           programmation du 2ème DMA }
  tabDMA2ISA:ptabEntier; { adresse 32 bits du 2ème buffer DMA }
  tailleTabDma2ISA:integer; { sa taille en octets }

function initISABuffers:boolean;

implementation


{**************** Installations des buffers DMA ISA ***************************}



var
  DLLhandleU16:Thandle;
  adU16:pointer;

function getProc(hh:Thandle;st:AnsiString):pointer;
begin
  result:=GetProcAddress(hh,Pansichar(st));
  if result=nil then messageCentral(st+'=nil');
end;


function installBuffer(RealAd,taille:longint):pointer;
begin
  result:=pointer(call16bitG(adU16,[realAd,taille],[4,4]));
  result:=ptr16to32(result);
end;


function initISABuffers:boolean;
const
  taillePage=128;
var
  f:text;
  st0:ShortString;
  st:AnsiString;
  code1,code2,x:integer;
  ad0:integer;
  i,j:integer;

  realTab0,taille0:integer; {valeurs lues dans dmares.txt}
  ad,taille:array[1..2] of integer; {les deux parties du buffer}
  p1,p2,adm:integer;
begin
  result:=InitQTthunkG;
  if not result then exit;

  {Vérifier la variable d'environnement}
  byte(st0[0]):=getEnvironmentVariable('DAC2DIGI1200',@st0[1],255);
  if st0='' then exit;

  st:='';

  {Vérifier et charger le fichier DMARES.TXT}
  try
  assign(f, AppDir + 'dmares.txt');
  reset(f);

  readln(f,st);
  st:=Fsupespace(st);
  val(st,x,code1);
  if code1=0 then realTab0:=x;

  readln(f,st);
  st:=Fsupespace(st);
  val(st,x,code2);
  if code2=0 then taille0:=x;

  while realtab0 mod 4<>0 do
  begin
    inc(realtab0);
    dec(taille0);
  end;

  taille0:=(taille0 div 4)*4;

  close(f);
  except
  close(f);
  exit;
  end;

  if (code1<>0) or (code2<>0) or
     (realTab0=0) or (taille0=0) then exit;

  {Calculer les adresses réelles}

  ad0:=loWord(realTab0)+integer(hiWord(realtab0))*16;
  p1:=ad0 div (taillePage*1024);
  p2:=(ad0+taille0-1) div (taillePage*1024);

  if p1=p2 then
    begin
      ad[1]:=realtab0;
      taille[1]:=taille0;
      ad[2]:=0;
      taille[2]:=0;
    end
  else
    begin
      adm:=taillePage*1024*p2;
      if adm-ad0>ad0+taille0-adm then
        begin
          ad[1]:=realtab0;
          taille[1]:=adm-ad0;

          ad[2]:=realtab0+adm-ad0;
          taille[2]:=ad0+taille0-adm;
        end
      else
        begin
          ad[1]:=realtab0+adm-ad0;
          taille[1]:=ad0+taille0-adm;

          ad[2]:=realtab0;
          taille[2]:=adm-ad0;
        end;
    end;

  if taille[1]>2*taille[2] then
    begin
      realtab1:=ad[1];
      tailleTabDma1ISA:=taille[1] div 2;
      realtab2:=realtab1+tailleTabDma1ISA;
      tailletabDma2ISA:=tailleTabDma1ISA;
    end
  else
    begin
      realtab1:=ad[1];
      tailleTabDma1ISA:=taille[1];
      realtab2:=ad[2];
      tailletabDma2ISA:=taille[2];
    end;

  ad0:=hiword(realtab1)*16+loword(realtab1);
  realtab1:=(ad0 shr 4)*65536+ad0 and $F;

  ad0:=hiword(realtab2)*16+loword(realtab2);
  realtab2:=(ad0 shr 4)*65536+ad0 and $F;

  {Charger la DLL U16}
  DLLhandleU16:=loadLib16('U16.DLL');
  if DLLhandleU16=0 then exit;
  adU16 :=GetProcAddress16(DLLHandleU16,'RealTo16' );
  if adU16=nil then exit;

  {Calculer les adresses 32 bits}
  tabDMA1ISA:=installBuffer(realTab1,tailleTabDma1ISA);
  tabDMA2ISA:=installBuffer(realTab2,tailleTabDma2ISA);

  result:=true;


  {messageCentral('dma1='+Istr(realTab1)+'/'+Istr(tailleTabDma1ISA)
               +' dma2='+Istr(realTab2)+'/'+Istr(tailleTabDma2ISA) );}

  {Libérer la DLL U16}
  freeLibrary16(DLLhandleU16);


end;



end.
