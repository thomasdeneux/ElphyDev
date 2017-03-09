{ Ce fichier a été automatiquement créé par Lazarus. Ne pas l'éditer !
  Cette source est seulement employée pour compiler et installer le paquet.
 }

unit varpackage64; 

interface

uses
  editCont, adpMRU, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('editCont', @editCont.Register); 
  RegisterUnit('adpMRU', @adpMRU.Register); 
end; 

initialization
  RegisterPackage('varpackage64', @Register); 
end.
