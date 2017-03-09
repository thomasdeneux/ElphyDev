; -- Elphy64.iss --

[Setup]
AppName=ELPHY64
AppVerName=Elphy64 Version 5.0.0
;include "d:\delphe5\ElphyVersion.txt"
UsePreviousAppDir=No
DefaultDirName={sd}\Elphy64
DefaultGroupName=Elphy64
UninstallDisplayIcon={app}\Elphy64.exe
licenseFile="..\Documents\Elphylicense.txt"
OutputBaseFileName=Elphy64Setup

; "ArchitecturesAllowed=x64" specifies that Setup cannot run on
; anything but x64.
ArchitecturesAllowed=x64
; "ArchitecturesInstallIn64BitMode=x64" requests that the install be
; done in "64-bit mode" on x64, meaning it should use the native
; 64-bit Program Files directory and the 64-bit view of the registry.
; ArchitecturesInstallIn64BitMode=x64

[Dirs]
Name: "{app}\AppData"; Permissions: everyone-modify
Name: "{app}\ElphyTools"; Permissions: everyone-modify

Name: "{app}\Matlab"; Permissions: everyone-modify
Name: "{app}\Matlab\bin"; Permissions: everyone-modify
Name: "{app}\Matlab\Examples"; Permissions: everyone-modify

Name: "{app}\IPP"; Permissions: everyone-modify
Name: "{app}\MKL"; Permissions: everyone-modify
Name: "{app}\Examples"; Permissions: everyone-modify
Name: "{app}\Cuda"; Permissions: everyone-modify
Name: "{app}\lib"; Permissions: everyone-modify
Name: "{app}\hdf5"; Permissions: everyone-modify

[Types]
Name: "full"; Description: "Full installation"
Name: "custom"; Description: "Custom installation"; Flags: iscustom

[Components]
Name: "program"; Description: "Program files"; Types: full custom; Flags: fixed
Name: "IntelLib"; Description: "Intel Libraries"; Types: full
Name: "TOOLS"; Description: "Elphy Tools"; Types: full
Name: "VS"; Description: "Visual Stimulation"; Types: custom

[Files]

Source: "..\DelpheXE\win64\bin\Elphy64.exe"; DestDir: "{app}"; Components: program
Source: "..\DelpheXE\win64\bin\Elphy2.prc"; DestDir: "{app}" ; Components: program
Source: "..\DelpheXE\win64\bin\elphy.chm"; DestDir: "{app}" ; Components: program
Source: "..\DelpheXE\win64\bin\*.dll"; DestDir: "{app}" ; Components: program

Source: "..\Dexe5\unic-key.txt"; DestDir: "{app}"; Components: VS

Source: "..\DelpheXE\win64\bin\Appdata\*.pl1"; DestDir: "{app}\AppData"; Components: program

;Source: "d:\Dexe5\GfcModel\dac2.gfc"; DestDir: "{app}\AppData"; Components: program; flags: onlyifdoesntexist

Source: "..\DelpheXE\win64\bin\mkl\*.*"; DestDir: "{app}\mkl"; Components: IntelLib
Source: "..\DelpheXE\win64\bin\ipp\*.*"; DestDir: "{app}\ipp"; Components: IntelLib

; we copy only Cuda dlls version 8.0
Source: "..\DelpheXE\win64\bin\cuda\cuda80.dll"; DestDir: "{app}\Cuda"; Components: program
Source: "..\DelpheXE\win64\bin\cuda\cudaMC80.dll"; DestDir: "{app}\Cuda"; Components: program
Source: "..\DelpheXE\win64\bin\cuda\cudart64_80.dll"; DestDir: "{app}\Cuda"; Components: program
Source: "..\DelpheXE\win64\bin\cuda\cufft64_80.dll"; DestDir: "{app}\Cuda"; Components: program
Source: "..\DelpheXE\win64\bin\cuda\curand64_80.dll"; DestDir: "{app}\Cuda"; Components: program


Source: "..\DelpheXE\win64\bin\MATLAB\bin\*.dll"; DestDir: "{app}\Matlab\bin"; Components: program

Source: "..\DelpheXE\win64\bin\hdf5\*.*"; DestDir: "{app}\hdf5"; Components: program

Source: "..\Users\ElphyTools\*.pg2"; DestDir: "{app}\ElphyTools"; Components: TOOLS
Source: "..\Users\Matlab Examples\*.m"; DestDir: "{app}\Matlab\Examples"; Components: TOOLS
Source: "..\Users\lib\*.pg2"; DestDir: "{app}\lib"; Components: TOOLS


Source: "..\Users\Examples\*.pg2"; DestDir: "{app}\Examples"; Components: TOOLS
Source: "..\Users\Examples\*.dat"; DestDir: "{app}\Examples"; Components: TOOLS

[Icons]
Name: "{group}\Elphy64"; Filename: "{app}\Elphy64.exe"; WorkingDir: "{app}"
Name: "{group}\Uninstall Elphy64"; Filename: "{uninstallexe}"
Name: "{userdesktop}\Elphy64"; Filename: "{app}\Elphy64.exe"; WorkingDir: "{app}"




