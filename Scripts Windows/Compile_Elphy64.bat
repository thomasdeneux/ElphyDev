c:
//cd C:\Program Files (x86)\Embarcadero\Studio\16.0\bin
@SET BDS=C:\Program Files (x86)\Embarcadero\Studio\16.0
@SET BDSINCLUDE=C:\Program Files (x86)\Embarcadero\Studio\16.0\include
@SET BDSCOMMONDIR=C:\Users\Public\Documents\Embarcadero\Studio\16.0
@SET FrameworkDir=C:\Windows\Microsoft.NET\Framework\v3.5
@SET FrameworkVersion=v3.5
@SET FrameworkSDKDir=
@SET PATH=%FrameworkDir%;%FrameworkSDKDir%;C:\Program Files (x86)\Embarcadero\Studio\16.0\bin;C:\Program Files (x86)\Embarcadero\Studio\16.0\bin64;C:\Users\Public\Documents\Embarcadero\InterBase\redist\InterBaseXE7\IDE_spoof;%PATH%
@SET LANGDIR=EN
@SET PLATFORM=
@SET PlatformSDK=

msbuild "%~dp0..\delpheXE\elphy64.dproj" /t:Rebuild /p:Config=Release;Platform=Win64
pause