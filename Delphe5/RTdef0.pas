unit RTdef0;

interface


type
  TNrnName=array[0..63] of char;
  TRTrecInfo= packed record
                AcqSize:integer;    // Taille utile du buffer Acquisition
                StimSize:integer;   // Taille utile du buffer Stimulation

                SampleInt: integer;                // Intervalle d'échantillonnage en microsecondes
                BaseInt: integer;                  // Intervalle d'échantillonnage de base  en microsecondes

                NbADC:integer;                     // Nombre de voies acquises sur la carte
                AdcNum: array[1..16] of integer;   // Numéros des ADC
                NbDAC: integer;                    // Nombre de DAC
                DacNum: array[1..16] of integer;   // Numéros des DAC

                NbDout: integer;                   // Nb bits utilisés en sortie
                DoutNum: array[1..16] of integer;  // numéros des bits utilisés

                NbDin: integer;                    // Nb bits utilisés en entrée
                DinNum: array[1..16] of integer;   // numéros des bits utilisés

                Dyu:   array[1..16] of double;     // paramètres d'échelle des entrées
                Y0u:   array[1..16] of double;

                DacDyu:   array[1..16] of double;  // paramètres d'échelle des sorties
                DacY0u:   array[1..16] of double;
                DacEnd:   array[1..16] of double;  // valeurs finales
                UseDacEnd:   array[1..16] of longBool;

                NbStim: integer;                   // Nb de voies dans le buffer de stim
                NbAcq: integer;                    // Nb de voies dans le buffer Acq sans compter le canal Tag

                NbTag: integer;                    // Nb de voies Tag Elphy
                TagNum: array[1..16] of integer;   // numéros des voies utilisées

                AIMode: integer;                   //  Differential      = 1
                                                   //  NRSE              = 2
                                                   //  RSE               = 3

                AcqSymb: array[1..32] of TNrnName;   // Noms symboles pour voies Elphy analog    1 à nbAcq
                TagSymb: array[1..32] of TNrnName;   // id voies Elphy digitales                 1 à NbTag
                StimSymb: array[1..32] of TNrnName;  // id voies Elphy stim                      1 à NbStim

                AdcSymb: array[1..16] of TNrnName;   // id voies adc                             1 à NbADC
                DacSymb: array[1..16] of TNrnName;   // id voies dac                             1 à NbDAC
                DinSymb: array[1..16] of TNrnName;   // id voies dio en entrée                   1 à NbDin
                DoutSymb: array[1..16] of TNrnName;  // id voies dio en sortie                   1 à NbDout

                FNeuron:longBool;                    // si 1, appel de nrn_fixed_step
                NIbusNumber:integer;
                NIdeviceNumber:integer;

                FlagStim: LongBool;
              end;
  PRTrecInfo= ^TRTrecInfo;
  
type
  TcomBuffer= record
                rec: TRTrecInfo;
                command: integer;
                Dresult: double;
                OutBuffer: array[1..32] of single;
                InBuffer:  array[1..32] of single;
                TagBuffer: integer;
                data: array[0..99999] of byte;
              end;
  PcomBuffer= ^TcomBuffer;

Const
  stDrvEvent='NrnDrvEvent';
  stDrvBuffer= 'NrnDrvBuffer';

  nc_quit=        1;
  nc_sendString=  2;
  nc_getSymList=  3;
  nc_ShowConsole= 4;

  nc_InitAcqNrnPointer= 5;
  nc_ProcessAg =        6;
  nc_getNrnValue=       7;


  nc_start=10;

  nc_DllQuit = 20;
  nc_DllError= 21;

procedure setNrnName(var name:TnrnName;st:AnsiString);
function getNrnName(var name:TnrnName):Ansistring;

implementation

procedure setNrnName(var name:TnrnName;st:AnsiString);
begin
  while (length(st)>0) and (st[1]=' ') do delete(st,1,1);
  while (length(st)>0) and (st[length(st)]=' ') do delete(st,length(st),1);
  st:=st+#0;
  move(st[1],name,length(st));
end;

function getNrnName(var name:TnrnName):Ansistring;
var
  i:integer;
begin
  result:='';
  for i:=0 to 63 do
    if name[i]<>#0 then result:= result+name[i] else exit;
end;

end.
