library M62;

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
  SysUtils,
  Classes,
  M62code in 'M62code.pas';

{$R *.res}

exports
        M62_open,
        M62_close,
        M62_cardinfo,
        M62_reset,
        M62_run,
        M62_read_mailbox,
        M62_write_mailbox,
        M62_start_app,
        M62_check_outbox,
        M62_check_inbox,
        M62_read_mb_terminate,
        M62_write_mb_terminate,
        M62_iicoffld,
        M62_clear_mailboxes,
        M62_start_talker,
        M62_interrupt,
        M62_host_interrupt_enable,
        M62_host_interrupt_disable,
        M62_host_interrupt_install,
        M62_host_interrupt_deinstall,
        M62_mailbox_interrupt,
        M62_mailbox_interrupt_ack,
        M62_check,
        M62_talker_fetch,
        M62_talker_store,
	M62_talker_read_memory,
	M62_talker_write_memory,
        M62_talker_section,
        M62_talker_download,
        M62_talker_launch,
        M62_talker_resume,
        M62_talker_registers,
        M62_opreg_outport,
        M62_opreg_inport,
        M62_outport,
        M62_inport,
        M62_from_ieee,
        M62_to_ieee,
        M62_key,
        M62_emit,
        M62_Tx,
        M62_Rx,
        M62_control,
        M62_get_semaphore,
        M62_request_semaphore,
        M62_own_semaphore,
        M62_release_semaphore,
        M62_slow,
        M62_fast,
        M62_talker_sector_erase,
        M62_flash_sector_erase,
        M62_flash_init,
        M62_flash_offset,
        M62_talker_revision
        ;

begin
end.
