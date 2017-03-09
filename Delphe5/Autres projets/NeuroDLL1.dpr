library NeuroDLL1;

{ Remarque importante concernant la gestion de m�moire de DLL : ShareMem doit
  �tre la premi�re unit� de la clause USES de votre biblioth�que ET de votre projet
  (s�lectionnez Projet-Voir source) si votre DLL exporte des proc�dures ou des
  fonctions qui passent des cha�nes en tant que param�tres ou r�sultats de fonction.
  Cela s'applique � toutes les cha�nes pass�es de et vers votre DLL --m�me celles
  qui sont imbriqu�es dans des enregistrements et classes. ShareMem est l'unit�
  d'interface pour le gestionnaire de m�moire partag�e BORLNDMM.DLL, qui doit
  �tre d�ploy� avec vos DLL. Pour �viter d'utiliser BORLNDMM.DLL, passez les
  informations de cha�nes avec des param�tres PChar ou ShortString. }

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
  if assigned(saveDllProc) then SaveDllProc(Reason);  // appeler la proc�dure de point d'entr�e enregistr�e
end;

begin
  SaveDllProc := DllProc;  // m�moriser la cha�ne des proc�dures de sortie
  DllProc := @LibExit;  // installer la proc�dure de sortie LibExit

  if not InitNeuroShareElphy then exitCode:=101;
  
end.
