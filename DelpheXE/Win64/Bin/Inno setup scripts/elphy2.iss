; -- Elphy2.iss --

#define DateStr GetDateTimeString('yymmdd','','')

[Setup]
AppName=ELPHY2
AppVerName=Elphy Version 5.0.0
;include "..\Delphe5\ElphyVersion.txt"
DefaultDirName={pf}\Elphy2
UsePreviousAppDir=no
DefaultGroupName=Elphy2
UninstallDisplayIcon={app}\Elphy2.exe
;licenseFile="..\Delphe5\Elphylicense.txt"
OutputBaseFileName=Elphy2Setup-{#DateStr}

[Dirs]
Name: "{app}\AppData"; Permissions: everyone-modify
Name: "{app}\ElphyTools"; Permissions: everyone-modify

Name: "{app}\Matlab"; Permissions: everyone-modify
Name: "{app}\Matlab\bin"; Permissions: everyone-modify
Name: "{app}\Matlab\Examples"; Permissions: everyone-modify

Name: "{app}\ipp"; Permissions: everyone-modify
Name: "{app}\mkl"; Permissions: everyone-modify
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
Name: "DATABASE"; Description: "Data Base files"; Types: full
Name: "TOOLS"; Description: "Elphy Tools"; Types: full
Name: "VS"; Description: "Visual Stimulation"; Types: custom


[Files]

;Source: "..\Dexe5\Elphy2.exe"; DestDir: "{app}"; Components: program
Source: "..\Dexe5\Elphy2_DX9.exe"; DestDir: "{app}"; Components: program; 
Source: "..\Dexe5\Elphy2_DX9.exe"; DestDir: "{app}"; Components: program; DestName: Elphy2.exe

Source: "..\Dexe5\Elphy2.prc"; DestDir: "{app}" ; Components: program
Source: "..\Dexe5\elphy.chm"; DestDir: "{app}" ; Components: program
Source: "..\Dexe5\Elphy.txt"; DestDir: "{app}"; Components: program
Source: "..\Dexe5\NrnDrv2.exe"; DestDir: "{app}"; Components: program
Source: "..\Dexe5\NrnDll.dll"; DestDir: "{app}"; Components: program

Source: "..\Dexe5\unic-key.txt"; DestDir: "{app}"; Components: VS


Source: "..\Dexe5\glut32.dll"; DestDir: "{app}"; Components: program


Source: "..\Dexe5\AppData\*.pl1"; DestDir: "{app}\AppData"; Components: program

;Source: "..\Delphe5\elphy.txt"; DestDir: "{app}"; Components: program
Source: "..\Dexe5\axdd132x.dll"; DestDir: "{app}"; Components: program
Source: "..\Dexe5\D3DX81ab.dll"; DestDir: "{app}"; Components: program

Source: "..\Dexe5\CyberK.dll"; DestDir: "{app}"; Components: program
Source: "..\Dexe5\CyberK37.dll"; DestDir: "{app}"; Components: program

Source: "..\Dexe5\NeuroDll1.dll"; DestDir: "{app}"; Components: program
Source: "..\Dexe5\Appdata\*.gfc"; DestDir: "{app}\AppData"; Components: program; flags: onlyifdoesntexist
;Source: "d:\VSprojects\nrnVS6\rtdebug\nrnRT1.rta"; DestDir: "{app}"; Components: program

Source: "..\Dexe5\lcr.dll"; DestDir: "{app}"; Components: program
Source: "..\Dexe5\hidapi.dll"; DestDir: "{app}"; Components: program

Source: "..\Dexe5\mkl\*.*"; DestDir: "{app}\mkl"; Components: IntelLib
Source: "..\Dexe5\ipp\*.*"; DestDir: "{app}\ipp"; Components: IntelLib  



; we copy only Cuda dlls version 6.5
Source: "..\Dexe5\Cuda\cuda65.dll"; DestDir: "{app}\Cuda"; Components: program
Source: "..\Dexe5\Cuda\cudaMC65.dll"; DestDir: "{app}\Cuda"; Components: program
Source: "..\Dexe5\Cuda\cudart32_65.dll"; DestDir: "{app}\Cuda"; Components: program
Source: "..\Dexe5\Cuda\cufft32_65.dll"; DestDir: "{app}\Cuda"; Components: program
Source: "..\Dexe5\Cuda\curand32_65.dll"; DestDir: "{app}\Cuda"; Components: program


Source: "..\Dexe5\MATLAB\bin\*.dll"; DestDir: "{app}\Matlab\bin"; Components: program

Source: "..\Dexe5\hdf5\*.*"; DestDir: "{app}\hdf5"; Components: program

Source: "..\Dexe5\comerr32.dll"; DestDir: "{app}"; Components: DATABASE
Source: "..\Dexe5\krb5_32.dll"; DestDir: "{app}"; Components: DATABASE
Source: "..\Dexe5\libeay32.dll"; DestDir: "{app}"; Components: DATABASE
Source: "..\Dexe5\libiconv-2.dll"; DestDir: "{app}"; Components: DATABASE
Source: "..\Dexe5\libintl-2.dll"; DestDir: "{app}"; Components: DATABASE
Source: "..\Dexe5\libpq.dll"; DestDir: "{app}"; Components: DATABASE
Source: "..\Dexe5\libxml2-2.dll"; DestDir: "{app}"; Components: DATABASE
Source: "..\Dexe5\libxml2.dll"; DestDir: "{app}"; Components: DATABASE
Source: "..\Dexe5\libxslt.dll"; DestDir: "{app}"; Components: DATABASE
Source: "..\Dexe5\ssleay32.dll"; DestDir: "{app}"; Components: DATABASE

Source: "..\Users\ElphyTools\*.pg2"; DestDir: "{app}\ElphyTools"; Components: TOOLS
Source: "..\Users\Matlab Examples\*.m"; DestDir: "{app}\Matlab\Examples"; Components: TOOLS
Source: "..\Users\lib\*.pg2"; DestDir: "{app}\lib"; Components: TOOLS


Source: "..\Users\Examples\*.dat"; DestDir: "{app}\Examples"; Components: TOOLS
Source: "..\Users\Examples\*.pg2"; DestDir: "{app}\Examples"; Components: TOOLS

[Icons]
Name: "{group}\Elphy2"; Filename: "{app}\Elphy2.exe"; WorkingDir: "{app}"
Name: "{group}\Elphy2_DX9"; Filename: "{app}\Elphy2_DX9.exe"; WorkingDir: "{app}"
Name: "{group}\Uninstall Elphy2"; Filename: "{uninstallexe}"
Name: "{userdesktop}\Elphy2"; Filename: "{app}\Elphy2.exe"; WorkingDir: "{app}"
Name: "{userdesktop}\Elphy2_DX9"; Filename: "{app}\Elphy2_DX9.exe"; WorkingDir: "{app}"


