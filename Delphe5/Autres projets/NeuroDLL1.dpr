library NeuroDLL1;

{ Remarque importante concernant la gestion de mémoire de DLL : ShareMem doit
  être la première unité de la clause USES de votre bibliothèque ET de votre projet
  (sélectionnez Projet-Voir source) si votre DLL exporte des procédures ou des
  fonctions qui passent des chaînes en tant que paramètres ou résultats de fonction.
  Cela s'applique à toutes les chaînes passées de et vers votre DLL --même celles
  qui sont imbriquées dans des enregistrements et classes. ShareMem est l'unité
  d'interface pour le gestionnaire de mémoire partagée BORLNDMM.DLL, qui doit
  être déployé avec vos DLL. Pour éviter d'utiliser BORLNDMM.DLL, passez les
  informations de chaînes avec des paramètres PChar ou ShortString. }

uses
  windows,
  SysUtils,
  Classes,
  nsAPItypes in 'nsAPItypes.pas',
  NeuroShareElphy1 in 'NeuroShareElphy1.pas',
  stmTcpIp1light in 'stmTcpIp1light.pas',
  NexFile1 in 'NexFile1.pas';

exports
  ns_GetLibraryInfo,
  ns_OpenFile,
  ns_GetFileInfo,
  ns_CloseFile,
  ns_GetEntityInfo,
  ns_GetEventInfo,
  ns_GetEventData,
  ns_GetAnalogInfo,
  ns_GetAnalogData,
  ns_GetSegmentInfo,
  ns_GetSegmentSourceInfo,
  ns_GetSegmentData,
  ns_GetNeuralInfo,
  ns_GetNeuralData,
  ns_GetIndexByTime,
  ns_GetTimeByIndex,
  ns_GetLastErrorMsg;

{$R *.res}

var
  SaveDllProc: Procedure(reason:integer) ;

procedure LibExit(Reason: Integer);
begin
  if Reason = DLL_PROCESS_DETACH then
  begin
     EndNeuroShareElphy;
  end;
  if assigned(saveDllProc) then SaveDllProc(Reason);  // appeler la procédure de point d'entrée enregistrée
end;

begin
  SaveDllProc := DllProc;  // mémoriser la chaîne des procédures de sortie
  DllProc := @LibExit;  // installer la procédure de sortie LibExit

  if not InitNeuroShareElphy then exitCode:=101;
  
end.
