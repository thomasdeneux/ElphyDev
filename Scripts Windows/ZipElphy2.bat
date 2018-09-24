cd ..\Dexe5

copy Elphy2_DX9.exe Elphy2.exe
"C:\Program Files\7-Zip\7z" a ..\Setup\Elphy2.zip Elphy2.exe
"C:\Program Files\7-Zip\7z" a ..\Setup\Elphy2.zip Elphy2_DX9.exe
"C:\Program Files\7-Zip\7z" a ..\Setup\Elphy2.zip Elphy2.prc
"C:\Program Files\7-Zip\7z" a ..\Setup\Elphy2.zip elphy.chm

"C:\Program Files\7-Zip\7z" a ..\Setup\Elphy2.zip cuda\cuda65.dll
"C:\Program Files\7-Zip\7z" a ..\Setup\Elphy2.zip cuda\cudaMC65.dll

"C:\Program Files\7-Zip\7z" a ..\Setup\Elphy2.zip Elphy.txt

pause





