unit syspal32;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows,  SysUtils, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, editcont,math,
  util1,Gdos,Dgraphic,Dprocess,stmError, debug0,

  stmdef,stmObj,Ncdef2,
  {$IFDEF DX11}
  DXscr11;
  {$ELSE}
  Direct3D9G,DXscr9;

  {$ENDIF}


const
  maxObjCol=10;
  maxTbA=50000;


type
  TLumEtalon=array[0..255] of single;


  TsysPal=class
             protected
               {Méthode sans gamma }
               tbA:array[0..maxTbA] of byte; { On range l'index pour les luminances de 0 à 500 Cd/m²
                                               de 0.01 en 0.01 cd/m²
                                              }


               {Nouvelle méthode }

               G0:single;          { On passe de l'index à la luminance par Lum = G0*i }
               Fgamma:boolean;     { true: la correction gamma est installée }


               {Méthode sans gamma }

               procedure initTbA;

               function LumIndex1(x:single):single;
                                   { Permet de construire GammaControl }

             public
               FIndexMode:boolean;

               FuseGammaRamp:boolean;
               lum:TlumEtalon;     { Luminances réelles correspondant à chaque niveau de vert }
                                   { Provient du fichier d'étalonnage }
               BKlum:single;       { Luminance du fond }

               LuminanceMax: single; { Avec les nouveaux écrans, on peut souhaiter limiter le maximum }

               function MaxLum: single;       { Valeur max dans la courbe d'étalonnage }
               function Lmax: single;         { égal à LuminanceMax ou MaxLum }

               function EColor(x:single):integer;
               constructor create;

               procedure Menu;

               function LumIndex(x:single):integer;
               function GreenRgb(lum:single):integer;
               function BKcolIndex:integer;

               procedure updateColors;

               function lireCalib:boolean;
               procedure ChangeCalib(st:AnsiString);

               property GammaGain:single read G0;

               function IndexToLum(i:integer):single;
               function IndexToGammaIndex(i:integer): integer;

               function PixToLum(ii: double): double;      // permet de passer des valeurs de pixel aux luminances sans arrondis
               function LumToPix(x: double): double;       // permet de passer des luminances aux valeurs de pixel sans arrondis


               procedure update;
               procedure BuildGamma;
               procedure resetGamma;


               function DX9color(lum:single; const Alpha1:single=1): longword;
               class function DX9colorI( n:integer; const Alpha:integer=255): longword;

             end;




type
  TsaisiePal32 = class(TForm)
    BOK: TButton;
    Bcancel: TButton;
    Label19: TLabel;
    enBK: TeditNum;
    cbGammaRamp: TCheckBoxV;
    procedure BApplylClick(Sender: TObject);
  private
    { Déclarations private }
    indLO,indLM:smallInt;
  public
    { Déclarations public }

    procedure execution;

  end;

function saisiePal32: TsaisiePal32;
function sysPal:TsysPal;

implementation

uses stmVS0;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
var
  FsaisiePal32: TsaisiePal32;
  Fsyspal:TsysPal;


function saisiePal32: TsaisiePal32;
begin
  if not assigned(FsaisiePal32) then FsaisiePal32:= TsaisiePal32.create(nil);
  result:= FsaisiePal32;
end;

function sysPal:TsysPal;
begin
  if not assigned(FsysPal) then FsysPal:=TsysPal.create;
  result:=FsysPal;
end;


procedure TsaisiePal32.execution;
var
  i:integer;
begin
  with syspal do
  begin
    enBK.setvar(BKlum,T_single);
    enBK.setMinMax(0,1000);

    cbGammaRamp.Checked:=true;
    cbGammaRamp.Enabled:=false;
    
  end;

  showModal;
  updateAllVar(self);

  syspal.update;

end;

procedure TsaisiePal32.BApplylClick(Sender: TObject);
var
  i:integer;
begin
  updateAllVar(self);
  syspal.update;
end;

{*********************   Méthodes de TsysPal  ****************************}


constructor TsysPal.create;
var
  i:integer;
begin
  G0:=0.1;
  for i:=0 to 255 do lum[i]:=i*G0;  {luminances de 0 à 25.5}

  FuseGammaRamp:=true;

  initTbA;

  BKlum:=5;

  updateColors;
end;


procedure TsysPal.menu;
begin
  saisiePal32.execution;
end;

procedure TsysPal.initTbA;
var
  i:integer;
begin
  for i:=0 to maxTbA do tbA[i]:=Ecolor(i*0.01);
end;


procedure TsysPal.updateColors;
begin
  if assigned(visualStim)
    then VisualStim.FXcontrol.setDevColors;
end;

function TsysPal.LumIndex(x:single):integer;
var
  k:integer;
begin
  if FindexMode then
  begin
    result:=round(x);
    if result<0 then result:=0
    else
    if result>255 then result:=255;
    exit;
  end
  else
  if Fgamma {OR FlagSimulation} then
  begin
    result:=round(x/G0);
    if result<0 then result:=0
    else
    if result>253 then result:=253;
  end
  else
  begin
    k:=round(x*100);
    if k<0 then k:=0
    else
    if k>maxTbA then k:=maxTbA;
    result:=tbA[k];
  end;
end;

function TsysPal.EColor(x:single):integer;
var
  d:single;
  min,max,k:integer;

begin
  min:=1;        {le 0 n'est pas utilisé, le 254 et le 255 non plus }
  max:=253;
  repeat
    k:=(max+min) div 2;

    d:=lum[k];
    if d<x then min:=k
    else
    if d>x then max:=k;
  until (max-min<=1) or (d=x);

  if d=x then result:=k
  else
  if x-lum[min]<lum[max]-x then result:=min
  else result:=max;
end;

{
function TsysPal.LumIndex1(x:single):single;
var
  d:single;
  min,max,k:integer;

begin
  min:=0;
  max:=255;
  repeat
    k:=(max+min) div 2;

    d:=lum[k];
    if d<x then min:=k
    else
    if d>x then max:=k;
  until (max-min<=1) or (d=x);

  if d<>x then k:=min;

  if (k<255) and (lum[k+1]>lum[k])
    then result:=k+(x-lum[k])/(lum[k+1]-lum[k])
    else result:=k;

  if result<0 then result:=0;
end;
}

function TsysPal.LumIndex1(x:single):single;
var
  d:single;
  min,max,k:integer;

begin
  min:=0;
  max:=255;
  repeat
    k:=(max+min) div 2;

    d:=lum[k];
    if d<x then min:=k
    else
    if d>x then max:=k;
  until (max-min<=1) or (d=x);

  if d<>x then k:=min;

  if (k<255) and (lum[k+1]>lum[k])
    then result:=k+(x-lum[k])/(lum[k+1]-lum[k])
    else result:=k;

  if result<0 then result:=0;
end;



function TsysPal.GreenRgb(lum:single):integer;
var
  n:integer;
begin
 {  'R  ','G  ','B  ','RG ','RB ','GB ','RGB' (numéros de 1 à 7) }
  n:=lumIndex(lum);
  case sysPaletteNumber of
    1:  result:=rgb(n,0,0);
    2:  result:=rgb(0,n,0);
    3:  result:=rgb(0,0,n);
    4:  result:=rgb(n,n,0);
    5:  result:=rgb(n,0,n);
    6:  result:=rgb(0,n,n);
    7:  result:=rgb(n,n,n);
    else result:=rgb(0,n,0);
  end;
end;

function TsysPal.lireCalib:boolean;
var
  st:AnsiString;
  i:integer;
  code:integer;
  f:text;
begin
  result:=false;
  st:=trouverFichier(CalibFileName,'');
  if st='' then exit;

  i:=0;
  try
  assign(f,st);
  reset(f);
  while not eof(f) and (i<=255) do
  begin
    readln(f,st);
    val(st,lum[i],code);
    inc(i);
  end;
  close(f);
  result:=true;

  except
  {$I-}close(f); {$I+}
  end;
end;

procedure TsysPal.ChangeCalib(st:AnsiString);
var
  i:integer;
  old:AnsiString;
  oldLum:TlumEtalon;
begin
  old:=calibFileName;
  oldLum:=lum;

  calibFileName:=st;
  if not lireCalib then
    begin
      {messageCentral('Unable to load VS calibration file');}
      calibFileName:=old;
      lum:=oldLum;
      exit;
    end;

  initTbA;

  update;
end;



procedure TsysPal.BuildGamma;
var
  i:integer;
  w: word;
  gammaRamp:TD3DGammaRamp;


procedure saveGammaRamp(stf:string);
var
  f:Text;
  i:integer;
begin
  assignFile(f,stf);
  rewrite(f);
  for i:=0 to 255 do writeln(f,Istr(GammaRamp.green[i]));
  closeFile(f);

end;

begin
  if not FuseGammaRamp  then
  begin
    resetGamma;
    exit;
  end;



  G0:=Lmax/253;

  with gammaRamp do
  for i:=0 to 255 do
    begin
      red[i]:=256*i;
      green[i]:=256*i;
      blue[i]:=256*i;
    end;

  for i:=1 to 253 do
  begin
    w:= round(lumIndex1(Lmax/253*i)*256);
    GammaRamp.green[i]:= w;

    // On applique la même correction à R et B
    GammaRamp.red[i]:=w;
    GammaRamp.blue[i]:=w;

  end;
//  SaveGammaRamp('d:\delphe5\gammaRamp.txt');

  GammaRamp.red[254]:=  65535;
  GammaRamp.green[254]:=65535;
  GammaRamp.blue[255]:= 65535;

  GammaRamp.red[255]:=  65535;
  GammaRamp.green[255]:=65535;
  GammaRamp.blue[255]:= 65535;


  if assigned(DXscreen) then

  Fgamma:=DXscreen.SetGammaRamp(GammaRamp);

end;


procedure TsysPal.ResetGamma;
var
  i:integer;
  gammaRamp:TD3DGammaRamp;

begin
  with gammaRamp do
  for i:=0 to 255 do
    begin
      red[i]:=256*i;
      green[i]:=256*i;
      blue[i]:=256*i;
    end;

  if assigned(DXscreen) then
     DXscreen.SetGammaRamp(GammaRamp);

  Fgamma:=false;
end;


function TsysPal.IndexToLum(i: integer): single;
begin
  if Fgamma {OR FlagSimulation}
    then result:=i*G0
    else result:=lum[i];
end;

function TsysPal.PixToLum(ii: double): double;
begin
  result:=ii*G0;
end;

function TsysPal.LumToPix(x: double): double;
begin
  result:= x/G0;
end;


procedure TsysPal.update;
var
  i:integer;
begin
  if not syspal.FIndexMode then buildGamma;

  updateColors;

  with HKpaint do
  for i:=0 to count-1 do
    typeUO(items[i]).ProcessMessage(uomsg_colorsChanged,nil,nil);
  HKpaintScreen;
  HKpaintScreen;
end;



function TsysPal.BKcolIndex: integer;
begin
  result:=lumIndex(BKlum);
end;

function TsysPal.DX9color(lum: single; const Alpha1:single=1): longword;
var
  n,alpha:integer;
begin
  n:= lumIndex(lum);
  alpha:= ceil(255*alpha1);

  case sysPaletteNumber of
    1:  result:= D3Dcolor_rgba(n,0,0,alpha);
    2:  result:= D3Dcolor_rgba(0,n,0,alpha);
    3:  result:= D3Dcolor_rgba(0,0,n,alpha);
    4:  result:= D3Dcolor_rgba(n,n,0,alpha);
    5:  result:= D3Dcolor_rgba(n,0,n,alpha);
    6:  result:= D3Dcolor_rgba(0,n,n,alpha);
    7:  result:= D3Dcolor_rgba(n,n,n,alpha);
    else result:=D3Dcolor_rgba(0,n,0,alpha);
  end;
end;

class function TsysPal.DX9colorI( n:integer; const Alpha:integer=255): longword;
begin
  case sysPaletteNumber of
    1:  result:= D3Dcolor_rgba(n,0,0,alpha);
    2:  result:= D3Dcolor_rgba(0,n,0,alpha);
    3:  result:= D3Dcolor_rgba(0,0,n,alpha);
    4:  result:= D3Dcolor_rgba(n,n,0,alpha);
    5:  result:= D3Dcolor_rgba(n,0,n,alpha);
    6:  result:= D3Dcolor_rgba(0,n,n,alpha);
    7:  result:= D3Dcolor_rgba(n,n,n,alpha);
    else result:=D3Dcolor_rgba(0,n,0,alpha);
  end;
end;


function TsysPal.IndexToGammaIndex(i: integer): integer;
begin
  result:= round(lum[i]/G0);
end;

function TsysPal.MaxLum: single;
var
  i: integer;
begin
  result:=lum[253];

end;


function TsysPal.Lmax: single;
begin
  if (LuminanceMax>0) and ( LuminanceMax<maxLum)
    then Lmax:= LuminanceMax
    else Lmax:= maxLum;
end;


Initialization
AffDebug('Initialization syspal32',0);



{$IFDEF FPC}
{$I syspal32.lrs}
{$ENDIF}
end.

