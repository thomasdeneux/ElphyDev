{ Ce fichier a été automatiquement créé par Lazarus. Ne pas l'éditer !
  Cette source est seulement employée pour compiler et installer le paquet.
 }

unit var32; 

interface

uses
  editcont, adpMRU, DXDrawsG, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('editcont', @editcont.Register); 
  RegisterUnit('adpMRU', @adpMRU.Register); 
  RegisterUnit('DXDrawsG', @DXDrawsG.Register); 
end; 

Initialization
AffDebug('Initialization var32',0);
  RegisterPackage('var32', @Register); 
end.
