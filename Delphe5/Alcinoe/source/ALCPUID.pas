{*************************************************************
Author:       Stéphane Vander Clock (SVanderClock@Arkadia.com)
              fastcode project

www:          http://www.arkadia.com
EMail:        SVanderClock@Arkadia.com

product:      ALCPUID
Version:      3.05

Description:  A list of function to detect CPU type

Legal issues: Copyright (C) 1999-2005 by Arkadia Software Engineering

              This software is provided 'as-is', without any express
              or implied warranty.  In no event will the author be
              held liable for any  damages arising from the use of
              this software.

              Permission is granted to anyone to use this software
              for any purpose, including commercial applications,
              and to alter it and redistribute it freely, subject
              to the following restrictions:

              1. The origin of this software must not be
                 misrepresented, you must not claim that you wrote
                 the original software. If you use this software in
                 a product, an acknowledgment in the product
                 documentation would be appreciated but is not
                 required.

              2. Altered source versions must be plainly marked as
                 such, and must not be misrepresented as being the
                 original software.

              3. This notice may not be removed or altered from any
                 source distribution.

              4. You must register this software by sending a picture
                 postcard to the author. Use a nice stamp and mention
                 your name, street address, EMail address and any
                 comment you like to say.

Know bug :

History :

Link :

Please send all your feedback to SVanderClock@Arkadia.com
**************************************************************}
unit ALCPUID;

interface

uses SysUtils;

type

  {Note: when changing TVendor, also change VendorStr array below}
  TALCPUVendor = (
                  cvUnknown,
                  cvAMD,
                  cvCentaur,
                  cvCyrix,
                  cvIntel,
                  cvTransmeta,
                  cvNexGen,
                  cvRise,
                  cvUMC,
                  cvNSC,
                  cvSiS
                 );

  {Note: when changing TInstruction, also change InstructionSupportStr below
   * - instruction(s) not supported in Delphi 7 assembler}
  TALCPUInstructions = (
                        isFPU,     {80x87}
                        isTSC,     {RDTSC}
                        isCX8,     {CMPXCHG8B}
                        isSEP,     {SYSENTER/SYSEXIT}
                        isCMOV,    {CMOVcc, and if isFPU, FCMOVcc/FCOMI}
                        isMMX,     {MMX}
                        isFXSR,    {FXSAVE/FXRSTOR}
                        isSSE,     {SSE}
                        isSSE2,    {SSE2}
                        isSSE3,    {SSE3*}
                        isMONITOR, {MONITOR/MWAIT*}
                        isCX16,    {CMPXCHG16B*}
                        isX64,     {AMD AMD64* or Intel EM64T*}
                        isExMMX,   {MMX+ - AMD only}
                        isEx3DNow, {3DNow!+ - AMD only}
                        is3DNow    {3DNow! - AMD only}
                       );
  TALCPUInstructionSupport = set of TALCPUInstructions;

  TALCPUInfo = record
    Vendor: TALCPUVendor;
    Signature: Cardinal;
    EffFamily: Byte;     {ExtendedFamily + Family}
    EffModel: Byte;      {(ExtendedModel shl 4) + Model}
    CodeL1CacheSize,     {KB or micro-ops for Pentium 4}
      DataL1CacheSize,   {KB}
      L2CacheSize,       {KB}
      L3CacheSize: Word; {KB}
    InstructionSupport: TALCPUInstructionSupport;
  end;

  {Note: when changing TALCPUTarget, also change CALCPUTargetStr array below}
  TALCPUTarget = (
                  fctRTLReplacement,  {not specific to any CPU}
                  fctBlended,         {not specific to any CPU, requires FPU, MMX and CMOV}
                  fctP3,              {Pentium/Celeron 3}
                  fctPM,              {Pentium/Celeron M (Banias and Dothan)}
                  fctP4,              {Pentium/Celeron/Xeon 4 without SSE3 (Willamette, Foster, Foster MP, Northwood, Prestonia, Gallatin)}
                  fctP4_SSE3,         {Pentium/Celeron 4 with SSE3 (Prescott)}
                  fctP4_64,           {Pentium/Xeon 4 with EM64T (some Prescott, and Nocona)}
                  fctK7,              {Athlon/Duron without SSE (Thunderbird and Spitfire)}
                  fctK7_SSE,          {Athlon/Duron/Sempron with SSE (Palomino, Morgan, Thoroughbred, Applebred, Barton)}
                  fctK8,              {Opteron/Athlon FX/Athlon 64 (Clawhammer, Sledgehammer, Newcastle)}
                  fctK8_SSE3          {Opteron/Athlon FX/Athlon 64 with SSE3 (future)}
                 );


const

  CALCPUVendorStr: array[Low(TALCPUVendor)..High(TALCPUVendor)] of ShortString = (
                                                                                  'Unknown',
                                                                                  'AMD',
                                                                                  'Centaur (VIA)',
                                                                                  'Cyrix',
                                                                                  'Intel',
                                                                                  'Transmeta',
                                                                                  'NexGen',
                                                                                  'Rise',
                                                                                  'UMC',
                                                                                  'National Semiconductor',
                                                                                  'SiS'
                                                                                 );

  CALCPUInstructionSupportStr: array[Low(TALCPUInstructions)..High(TALCPUInstructions)] of ShortString = (
                                                                                                          'FPU',
                                                                                                          'TSC',
                                                                                                          'CX8',
                                                                                                          'SEP',
                                                                                                          'CMOV',
                                                                                                          'MMX',
                                                                                                          'FXSR',
                                                                                                          'SSE',
                                                                                                          'SSE2',
                                                                                                          'SSE3',
                                                                                                          'MONITOR',
                                                                                                          'CX16',
                                                                                                          'X64',
                                                                                                          'MMX+',
                                                                                                          '3DNow!+',
                                                                                                          '3DNow!'
                                                                                                         );

  CALCPUTargetStr: array[Low(TALCPUTarget)..High(TALCPUTarget)] of ShortString = (
                                                                                  'RTLReplacement',
                                                                                  'Blended',
                                                                                  'P3',
                                                                                  'PM',
                                                                                  'P4',
                                                                                  'P4_SSE3',
                                                                                  'P4_64',
                                                                                  'K7',
                                                                                  'K7_SSE',
                                                                                  'K8',
                                                                                  'K8_SSE3'
                                                                                 );

  {--------------------------------}
  Function ALGetCPUInfo: TALCPUinfo;
  Function ALGetCPUTarget: TALCPUTarget;



implementation

var VALCPUInfo: TALCPUinfo;
    VALCPUTarget: TALCPUTarget;

type

  TALCPURegisters = record
    EAX,
      EBX,
      ECX,
      EDX: Cardinal;
  end;

  TALCPUVendorStr = string[12];

  TALCpuFeatures = (
                    {in EDX}
                    cfFPU,
                    cfVME,
                    cfDE,
                    cfPSE,
                    cfTSC,
                    cfMSR,
                    cfPAE,
                    cfMCE,
                    cfCX8,
                    cfAPIC,
                    cf_d10,
                    cfSEP,
                    cfMTRR,
                    cfPGE,
                    cfMCA,
                    cfCMOV,
                    cfPAT,
                    cfPSE36,
                    cfPSN,
                    cfCLFSH,
                    cf_d20,
                    cfDS,
                    cfACPI,
                    cfMMX,
                    cfFXSR,
                    cfSSE,
                    cfSSE2,
                    cfSS,
                    cfHTT,
                    cfTM,
                    cfIA_64,
                    cfPBE,
                    {in ECX}
                    cfSSE3,
                    cf_c1,
                    cf_c2,
                    cfMON,
                    cfDS_CPL,
                    cf_c5,
                    cf_c6,
                    cfEIST,
                    cfTM2,
                    cf_c9,
                    cfCID,
                    cf_c11,
                    cf_c12,
                    cfCX16,
                    cfxTPR,
                    cf_c15,
                    cf_c16,
                    cf_c17,
                    cf_c18,
                    cf_c19,
                    cf_c20,
                    cf_c21,
                    cf_c22,
                    cf_c23,
                    cf_c24,
                    cf_c25,
                    cf_c26,
                    cf_c27,
                    cf_c28,
                    cf_c29,
                    cf_c30,
                    cf_c31
                   );
  TCpuFeatureSet = set of TALCpuFeatures;

  TALCpuExtendedFeatures = (
                            cefFPU,
                            cefVME,
                            cefDE,
                            cefPSE,
                            cefTSC,
                            cefMSR,
                            cefPAE,
                            cefMCE,
                            cefCX8,
                            cefAPIC,
                            cef_10,
                            cefSEP,
                            cefMTRR,
                            cefPGE,
                            cefMCA,
                            cefCMOV,
                            cefPAT,
                            cefPSE36,
                            cef_18,
                            ceMPC,
                            ceNX,
                            cef_21,
                            cefExMMX,
                            cefMMX,
                            cefFXSR,
                            cef_25,
                            cef_26,
                            cef_27,
                            cef_28,
                            cefLM,
                            cefEx3DNow,
                            cef3DNow
                           );
  TCpuExtendedFeatureSet = set of TALCpuExtendedFeatures;

const
  CALCPUVendorIDString: array[Low(TALCPUVendor)..High(TALCPUVendor)] of TALCPUVendorStr = (
                                                                                           '',
                                                                                           'AuthenticAMD',
                                                                                           'CentaurHauls',
                                                                                           'CyrixInstead',
                                                                                           'GenuineIntel',
                                                                                           'GenuineTMx86',
                                                                                           'NexGenDriven',
                                                                                           'RiseRiseRise',
                                                                                           'UMC UMC UMC ',
                                                                                           'Geode by NSC',
                                                                                           'SiS SiS SiS'
                                                                                          );

  {CPU signatures}
  CALCPUIntelLowestSEPSupportSignature = $633;
  CALCPUK7DuronA0Signature = $630;
  CALCPUC3Samuel2EffModel = 7;
  CALCPUC3EzraEffModel = 8;
  CALCPUPMBaniasEffModel = 9;
  CALCPUPMDothanEffModel = $D;
  CALCPUP3LowestEffModel = 7;

{********************************}
Function ALGetCPUInfo: TALCPUinfo;
Begin
  Result := VALCPUInfo;
end;

{************************************}
Function ALGetCPUTarget: TALCPUTarget;
Begin
  Result := VALCPUTarget;
end;

{**********************************************}
function ALIsCPUID_Available: Boolean; register;
asm
  PUSHFD                 {save EFLAGS to stack}
  POP     EAX            {store EFLAGS in EAX}
  MOV     EDX, EAX       {save in EDX for later testing}
  XOR     EAX, $200000;  {flip ID bit in EFLAGS}
  PUSH    EAX            {save new EFLAGS value on stack}
  POPFD                  {replace current EFLAGS value}
  PUSHFD                 {get new EFLAGS}
  POP     EAX            {store new EFLAGS in EAX}
  XOR     EAX, EDX       {check if ID bit changed}
  JZ      @exit          {no, CPUID not available}
  MOV     EAX, True      {yes, CPUID is available}
@exit:
end;

{**********************************}
function ALIsFPU_Available: Boolean;
var
  _FCW, _FSW: Word;
asm
  MOV     EAX, False     {initialize return register}
  MOV     _FSW, $5A5A    {store a non-zero value}
  FNINIT                 {must use non-wait form}
  FNSTSW  _FSW           {store the status}
  CMP     _FSW, 0        {was the correct status read?}
  JNE     @exit          {no, FPU not available}
  FNSTCW  _FCW           {yes, now save control word}
  MOV     DX, _FCW       {get the control word}
  AND     DX, $103F      {mask the proper status bits}
  CMP     DX, $3F        {is a numeric processor installed?}
  JNE     @exit          {no, FPU not installed}
  MOV     EAX, True      {yes, FPU is installed}
@exit:
end;

{********************************************************************}
procedure ALGetCPUID(Param: Cardinal; var Registers: TALCPURegisters);
asm
  PUSH    EBX                         {save affected registers}
  PUSH    EDI
  MOV     EDI, Registers
  XOR     EBX, EBX                    {clear EBX register}
  XOR     ECX, ECX                    {clear ECX register}
  XOR     EDX, EDX                    {clear EDX register}
  DB $0F, $A2                         {CPUID opcode}
  MOV     TALCPURegisters(EDI).&EAX, EAX   {save EAX register}
  MOV     TALCPURegisters(EDI).&EBX, EBX   {save EBX register}
  MOV     TALCPURegisters(EDI).&ECX, ECX   {save ECX register}
  MOV     TALCPURegisters(EDI).&EDX, EDX   {save EDX register}
  POP     EDI                         {restore registers}
  POP     EBX
end;

{***********************}
procedure ALGetCPUVendor;
var
  VendorStr: TALCPUVendorStr;
  Registers: TALCPURegisters;
begin
  {call CPUID function 0}
  ALGetCPUID(0, Registers);

  {get vendor string}
  SetLength(VendorStr, 12);
  Move(Registers.EBX, VendorStr[1], 4);
  Move(Registers.EDX, VendorStr[5], 4);
  Move(Registers.ECX, VendorStr[9], 4);

  {get CPU vendor from vendor string}
  VALCPUInfo.Vendor := High(TALCPUVendor);
  while (VendorStr <> CALCPUVendorIDString[VALCPUInfo.Vendor]) and
    (VAlCPUInfo.Vendor > Low(TALCPUVendor)) do
    Dec(VAlCPUInfo.Vendor);
end;

{*************************}
procedure ALGetCPUFeatures;
{preconditions: 1. maximum CPUID must be at least $00000001
                2. GetCPUVendor must have been called}
type
  _Int64 = packed record
    Lo: Longword;
    Hi: Longword;
  end;
var
  Registers: TALCPURegisters;
  CpuFeatures: TCpuFeatureSet;
begin
  {call CPUID function $00000001}
  ALGetCPUID($00000001, Registers);

  {get CPU signature}
  VALCPUInfo.Signature := Registers.EAX;

  {extract effective processor family and model}
  VALCPUInfo.EffFamily := VALCPUInfo.Signature and $00000F00 shr 8;
  VALCPUInfo.EffModel := VALCPUInfo.Signature and $000000F0 shr 4;
  if VALCPUInfo.EffFamily = $F then
  begin
    VALCPUInfo.EffFamily := VALCPUInfo.EffFamily + (VALCPUInfo.Signature and $0FF00000 shr 20);
    VALCPUInfo.EffModel := VALCPUInfo.EffModel + (VALCPUInfo.Signature and $000F0000 shr 12);
  end;

  {get CPU features}
  Move(Registers.EDX, _Int64(CpuFeatures).Lo, 4);
  Move(Registers.ECX, _Int64(CpuFeatures).Hi, 4);

  {get instruction support}
  if cfFPU in CpuFeatures then
    Include(VALCPUInfo.InstructionSupport, isFPU);
  if cfTSC in CpuFeatures then
    Include(VALCPUInfo.InstructionSupport, isTSC);
  if cfCX8 in CpuFeatures then
    Include(VALCPUInfo.InstructionSupport, isCX8);
  if cfSEP in CpuFeatures then
  begin
    Include(VALCPUInfo.InstructionSupport, isSEP);
    {for Intel CPUs, qualify the processor family and model to ensure that the
     SYSENTER/SYSEXIT instructions are actually present - see Intel Application
     Note AP-485}
    if (VALCPUInfo.Vendor = cvIntel) and
      (VALCPUInfo.Signature and $0FFF3FFF < CALCPUIntelLowestSEPSupportSignature) then
      Exclude(VALCPUInfo.InstructionSupport, isSEP);
  end;
  if cfCMOV in CpuFeatures then
    Include(VALCPUInfo.InstructionSupport, isCMOV);
  if cfFXSR in CpuFeatures then
    Include(VALCPUInfo.InstructionSupport, isFXSR);
  if cfMMX in CpuFeatures then
    Include(VALCPUInfo.InstructionSupport, isMMX);
  if cfSSE in CpuFeatures then
    Include(VALCPUInfo.InstructionSupport, isSSE);
  if cfSSE2 in CpuFeatures then
    Include(VALCPUInfo.InstructionSupport, isSSE2);
  if cfSSE3 in CpuFeatures then
    Include(VALCPUInfo.InstructionSupport, isSSE3);
  if (VALCPUInfo.Vendor = cvIntel) and (cfMON in CpuFeatures) then
    Include(VALCPUInfo.InstructionSupport, isMONITOR);
  if cfCX16 in CpuFeatures then
    Include(VALCPUInfo.InstructionSupport, isCX16);
end;

{*********************************}
procedure ALGetCPUExtendedFeatures;
{preconditions: maximum extended CPUID >= $80000001}
var
  Registers: TALCPURegisters;
  CpuExFeatures: TCpuExtendedFeatureSet;
begin
  {call CPUID function $80000001}
  ALGetCPUID($80000001, Registers);

  {get CPU extended features}
  CPUExFeatures := TCPUExtendedFeatureSet(Registers.EDX);

  {get instruction support}
  if cefLM in CpuExFeatures then
    Include(VALCPUInfo.InstructionSupport, isX64);
  if cefExMMX in CpuExFeatures then
    Include(VALCPUInfo.InstructionSupport, isExMMX);
  if cefEx3DNow in CpuExFeatures then
    Include(VALCPUInfo.InstructionSupport, isEx3DNow);
  if cef3DNow in CpuExFeatures then
    Include(VALCPUInfo.InstructionSupport, is3DNow);
end;

{********************************}
procedure ALGetProcessorCacheInfo;
{preconditions: 1. maximum CPUID must be at least $00000002
                2. GetCPUVendor must have been called}
type
  TConfigDescriptor = packed array[0..15] of Byte;
var
  Registers: TALCPURegisters;
  i, j: Integer;
  QueryCount: Byte;
begin
  {call CPUID function 2}
  ALGetCPUID($00000002, Registers);
  QueryCount := Registers.EAX and $FF;
  for i := 1 to QueryCount do
  begin
    for j := 1 to 15 do
      with VALCPUInfo do
        {decode configuration descriptor byte}
        case TConfigDescriptor(Registers)[j] of
          $06: CodeL1CacheSize := 8;
          $08: CodeL1CacheSize := 16;
          $0A: DataL1CacheSize := 8;
          $0C: DataL1CacheSize := 16;
          $22: L3CacheSize := 512;
          $23: L3CacheSize := 1024;
          $25: L3CacheSize := 2048;
          $29: L3CacheSize := 4096;
          $2C: DataL1CacheSize := 32;
          $30: CodeL1CacheSize := 32;
          $39: L2CacheSize := 128;
          $3B: L2CacheSize := 128;
          $3C: L2CacheSize := 256;
          $40: {no 2nd-level cache or, if processor contains a valid 2nd-level
                cache, no 3rd-level cache}
            if L2CacheSize <> 0 then
              L3CacheSize := 0;
          $41: L2CacheSize := 128;
          $42: L2CacheSize := 256;
          $43: L2CacheSize := 512;
          $44: L2CacheSize := 1024;
          $45: L2CacheSize := 2048;
          $60: DataL1CacheSize := 16;
          $66: DataL1CacheSize := 8;
          $67: DataL1CacheSize := 16;
          $68: DataL1CacheSize := 32;
          $70: if not (VALCPUInfo.Vendor in [cvCyrix, cvNSC]) then
              CodeL1CacheSize := 12; {K micro-ops}
          $71: CodeL1CacheSize := 16; {K micro-ops}
          $72: CodeL1CacheSize := 32; {K micro-ops}
          $78: L2CacheSize := 1024;
          $79: L2CacheSize := 128;
          $7A: L2CacheSize := 256;
          $7B: L2CacheSize := 512;
          $7C: L2CacheSize := 1024;
          $7D: L2CacheSize := 2048;
          $7F: L2CacheSize := 512;
          $80: if VALCPUInfo.Vendor in [cvCyrix, cvNSC] then
            begin {Cyrix and NSC only - 16 KB unified L1 cache}
              CodeL1CacheSize := 8;
              DataL1CacheSize := 8;
            end;
          $82: L2CacheSize := 256;
          $83: L2CacheSize := 512;
          $84: L2CacheSize := 1024;
          $85: L2CacheSize := 2048;
          $86: L2CacheSize := 512;
          $87: L2CacheSize := 1024;
        end;
    if i < QueryCount then
      ALGetCPUID(2, Registers);
  end;
end;

{****************************************}
procedure ALGetExtendedProcessorCacheInfo;
{preconditions: 1. maximum extended CPUID must be at least $80000006
                2. GetCPUVendor and GetCPUFeatures must have been called}
var
  Registers: TALCPURegisters;
begin
  {call CPUID function $80000005}
  ALGetCPUID($80000005, Registers);

  {get L1 cache size}
  {Note: Intel does not support function $80000005 for L1 cache size, so ignore.
         Cyrix returns CPUID function 2 descriptors (already done), so ignore.}
  if not (VALCPUInfo.Vendor in [cvIntel, cvCyrix]) then
  begin
    VALCPUInfo.CodeL1CacheSize := Registers.EDX shr 24;
    VALCPUInfo.DataL1CacheSize := Registers.ECX shr 24;
  end;

  {call CPUID function $80000006}
  ALGetCPUID($80000006, Registers);

  {get L2 cache size}
  if (VALCPUInfo.Vendor = cvAMD) and (VALCPUInfo.Signature and $FFF = CALCPUK7DuronA0Signature) then
    {workaround for AMD Duron Rev A0 L2 cache size erratum - see AMD Technical
     Note TN-13}
    VALCPUInfo.L2CacheSize := 64
  else if (VALCPUInfo.Vendor = cvCentaur) and (VALCPUInfo.EffFamily = 6) and
    (VALCPUInfo.EffModel in [CALCPUC3Samuel2EffModel, CALCPUC3EzraEffModel]) then
    {handle VIA (Centaur) C3 Samuel 2 and Ezra non-standard encoding}
    VALCPUInfo.L2CacheSize := Registers.ECX shr 24
  else {standard encoding}
    VALCPUInfo.L2CacheSize := Registers.ECX shr 16;
end;

{*****************************************}
procedure ALVerifyOSSupportForXMMRegisters;
begin
  {try a SSE instruction that operates on XMM registers}
  try
    asm
      DB $0F, $54, $C0  // ANDPS XMM0, XMM0
    end
  except
    on E: Exception do
    begin
      {if it fails, assume that none of the SSE instruction sets are available}
      Exclude(VALCPUInfo.InstructionSupport, isSSE);
      Exclude(VALCPUInfo.InstructionSupport, isSSE2);
      Exclude(VALCPUInfo.InstructionSupport, isSSE3);
    end;
  end;
end;

{**********************}
procedure ALInitCPUInfo;
var
  Registers: TALCPURegisters;
  MaxCPUID: Cardinal;
  MaxExCPUID: Cardinal;
begin
  {initialize - just to be sure}
  FillChar(VALCPUInfo, SizeOf(VALCPUInfo), 0);

  try
    if not ALIsCPUID_Available then
    begin
      if ALIsFPU_Available then
        Include(VALCPUInfo.InstructionSupport, isFPU);
    end
    else
    begin
      {get maximum CPUID input value}
      ALGetCPUID($00000000, Registers);
      MaxCPUID := Registers.EAX;

      {get CPU vendor - Max CPUID will always be >= 0}
      ALGetCPUVendor;

      {get CPU features if available}
      if MaxCPUID >= $00000001 then
        ALGetCPUFeatures;

      {get cache info if available}
      if MaxCPUID >= $00000002 then
        ALGetProcessorCacheInfo;

      {get maximum extended CPUID input value}
      ALGetCPUID($80000000, Registers);
      MaxExCPUID := Registers.EAX;

      {get CPU extended features if available}
      if MaxExCPUID >= $80000001 then
        ALGetCPUExtendedFeatures;

      {verify operating system support for XMM registers}
      if isSSE in VALCPUInfo.InstructionSupport then
        ALVerifyOSSupportForXMMRegisters;

      {get extended cache features if available}
      {Note: ignore processors that only report L1 cache info,
             i.e. have a MaxExCPUID = $80000005}
      if MaxExCPUID >= $80000006 then
        ALGetExtendedProcessorCacheInfo;
    end;
  except
    on E: Exception do
      {silent exception - should not occur, just ignore}
  end;
end;

{************************}
procedure ALInitCPUTarget;
{precondition: GetCPUInfo must have been called}
begin
  {as default, select blended target if there is at least FPU, MMX, and CMOV
   instruction support, otherwise select RTL Replacement target}
  if [isFPU, isMMX, isCMOV] <= VALCPUInfo.InstructionSupport then
    VALCPUTarget := fctBlended
  else
    VALCPUTarget := fctRTLReplacement;

  case VALCPUInfo.Vendor of
    cvIntel:
      case VALCPUInfo.EffFamily of
        6: {Intel P6, P2, P3, PM}
          if VALCPUInfo.EffModel in [CALCPUPMBaniasEffModel, CALCPUPMDothanEffModel] then
            VALCPUTarget := fctPM
          else if VALCPUInfo.EffModel >= CALCPUP3LowestEffModel then
            VALCPUTarget := fctP3;
        $F: {Intel P4}
          if isX64 in VALCPUInfo.InstructionSupport then
            VALCPUTarget := fctP4_64
          else if isSSE3 in VALCPUInfo.InstructionSupport then
            VALCPUTarget := fctP4_SSE3
          else
            VALCPUTarget := fctP4;
      end;
    cvAMD:
      case VALCPUInfo.EffFamily of
        6: {AMD K7}
          if isSSE in VALCPUInfo.InstructionSupport then
            VALCPUTarget := fctK7_SSE
          else
            VALCPUTarget := fctK7;
        $F: {AMD K8}
          if isSSE3 in VALCPUInfo.InstructionSupport then
            VALCPUTarget := fctK8_SSE3
          else
            VALCPUTarget := fctK8;
      end;
  end;
end;

initialization
  ALInitCPUInfo;
  ALInitCPUTarget;
end.

