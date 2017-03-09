{ This file was automatically created by Lazarus. do not edit!
  This source is only used to compile and install the package.
 }

unit VarPackage1; 

interface

uses
  editCont, adpMRU, DXDrawsG, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('editCont', @editCont.Register); 
  RegisterUnit('adpMRU', @adpMRU.Register); 
  RegisterUnit('DXDrawsG', @DXDrawsG.Register); 
end; 

initialization
  RegisterPackage('VarPackage1', @Register); 
end.
