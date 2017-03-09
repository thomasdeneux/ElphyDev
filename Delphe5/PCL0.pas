unit PCL0;

{ Gère les objets photon en utilisant les mêmes principes que dans dtf0 ou tbe0 }

interface

uses util1, dtf0;

{ TPCLrecord est la structure d'un photon dans un fichier PCL
  Les nombres sont stockés en Big Endian format
  Convert rétablit l'ordre des octets .

  Quand TPCLrecord est utilisé en interne, on oublie la conversion
 }

type
  TPCLrecord = object
                 time:double;
                 X,Y,Z:smallint;
                 procedure convert;
               end;
  tabPCLrecord = array[0..0] of TPCLrecord;
  PtabPCLrecord=^tabPCLrecord;

  // Type générique
  TypeDataPhotonB= class
                     indiceMin,indiceMax:integer;
                     function getPhoton(i:integer): TPCLrecord; virtual;abstract;
                     property Photon[i:integer]: TPCLrecord read GetPhoton;
                     function getDataVtime: typeDataB;virtual;abstract;
                     function getDataVx: typeDataB;virtual;abstract;
                     function getDataVy: typeDataB;virtual;abstract;
                     function getDataVz: typeDataB;virtual;abstract;
                   end;

  // Les photons sont dans un tableau en mémoire de TPCLrecord
  TypeDataPhoton=  class (TypeDataPhotonB)
                     p0: PtabPCLrecord;
                     constructor create(p: pointer;i1, i2: integer);
                     function getPhoton(i:integer): TPCLrecord; override;

                     function getDataVtime: typeDataB;override;
                     function getDataVx: typeDataB;override;
                     function getDataVy: typeDataB;override;
                     function getDataVz: typeDataB;override;

                   end;

  // Les photons sont dans un tableau tournant de TPCLrecord

  // p indique le début du buffer considéré comme un tableau indicé de 0 à Nmax-1
  // indice1 est le début du segment de données utiles dans ce buffer
  // imin et imax sont les indices utilisateurs de début et de fin de ce segment
  // GetPhoton = p0^[(indice1+i) mod Nmax];


  TypeDataPhotonT= class (TypeDataPhotonB)
                     indice1: integer;
                     Nmax:integer;
                     p0: PtabPCLrecord;
                     constructor create(p: pointer; N1, i1,imin,imax: integer);
                     function getPhoton(i:integer): TPCLrecord; override;

                     function getDataVtime: typeDataB;override;
                     function getDataVx: typeDataB;override;
                     function getDataVy: typeDataB;override;
                     function getDataVz: typeDataB;override;

                   end;


implementation

{ TPCLrecord }


function swap(x:smallint):smallint;assembler;
asm
  mov ax, x
  xchg ah,al
end;

procedure swapDouble(var x:double);
var
  x1: array[0..7] of byte absolute x;
  y: double;
  y1: array[0..7] of byte absolute y;
  i:integer;
begin
  for i:=0 to 7 do y1[i]:=x1[7-i];
  x:=y;
end;


procedure TPCLrecord.convert;
begin
  swapDouble(time);
  x:=swap(x);
  y:=swap(y);
  z:=swap(z);
end;






{ TypeDataPhoton }

constructor TypeDataPhoton.create(p: pointer; i1, i2: integer);
begin
  p0:=p;
  indicemin:=i1;
  indicemax:=i2;
end;

function TypeDataPhoton.getDataVtime: typeDataB;
begin
  result:= typeDataD.createStep(@p0^[0].time,sizeof(TPCLrecord),0,indicemin, indicemax);
end;

function TypeDataPhoton.getDataVx: typeDataB;
begin
  result:= typeDataI.createStep(@p0^[0].x,sizeof(TPCLrecord),0,indicemin,indicemax);
end;

function TypeDataPhoton.getDataVy: typeDataB;
begin
  result:= typeDataI.createStep(@p0^[0].y,sizeof(TPCLrecord),0,indicemin,indicemax);
end;

function TypeDataPhoton.getDataVz: typeDataB;
begin
  result:= typeDataI.createStep(@p0^[0].z,sizeof(TPCLrecord),0,indicemin,indicemax);
end;

function TypeDataPhoton.getPhoton(i: integer): TPCLrecord;
begin
  result:=p0^[i-indicemin];

//  result:=p0^[i+indice1];
end;


{ TypeDataPhotonT }
constructor TypeDataPhotonT.create(p: pointer; N1,i1,imin,imax: integer);
begin
  p0:=p;
  indice1:=i1;
  indicemin:=imin;
  indicemax:=imax;
  Nmax:=N1;
end;


function TypeDataPhotonT.getDataVtime: typeDataB;
begin
  result:= typeDataDT.createStep(@p0^[0].time,sizeof(TPCLrecord),Nmax,indice1,indicemin, indicemax);
end;

function TypeDataPhotonT.getDataVx: typeDataB;
begin
  result:= typeDataIT.createStep(@p0^[0].x,sizeof(TPCLrecord),Nmax,indice1,indicemin, indicemax);
end;

function TypeDataPhotonT.getDataVy: typeDataB;
begin
  result:= typeDataIT.createStep(@p0^[0].y,sizeof(TPCLrecord),Nmax,indice1,indicemin, indicemax);
end;

function TypeDataPhotonT.getDataVz: typeDataB;
begin
  result:= typeDataIT.createStep(@p0^[0].z,sizeof(TPCLrecord),Nmax,indice1,indicemin, indicemax);
end;

function TypeDataPhotonT.getPhoton(i: integer): TPCLrecord;
begin
  result:=p0^[(indice1+i) mod Nmax];
end;


end.
