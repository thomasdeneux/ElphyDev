unit Ddosfich;


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows, Messages, SysUtils, Classes, Graphics, Controls,filectrl,
     Forms, Dialogs, StdCtrls, ExtCtrls,
     util1,Gdos;

type
  ThistoryList=class(TstringList)
               public
                  nbSt:integer;
                  constructor create(nbmax:integer);
                  procedure add(st:AnsiString);

                  procedure getV(var p:pointer;var taille0:integer);
                  procedure setV(p:pointer;taille0:integer);
                  function Vsize:integer;

                end;


function ChoixFichierStandard(var stGen,stFichier:AnsiString;
                              stHis:ThistoryList):boolean;

function ChoixFichierStandard1(var stGen,stFichier:AnsiString;
                               filtre:AnsiString;var Ifiltre:integer):boolean;


function SauverFichierStandard(var stFichier:AnsiString;ext:AnsiString):boolean;

function EcraserFichier(st:AnsiString):boolean;
function ConvertFile(st1,st2:AnsiString;toWin:boolean):boolean;

function GChooseFile(titre,stFichier:AnsiString):AnsiString;
function GSaveFile(titre,stFichier,ext:AnsiString):AnsiString;
function GChooseDirectory(caption,root:AnsiString;var dir:AnsiString):boolean;

IMPLEMENTATION

constructor ThistoryList.create(nbmax:integer);
begin
  inherited create;
  nbst:=nbmax;
end;

procedure ThistoryList.add(st:AnsiString);
var
  exist:boolean;
  st0:AnsiString;
  i:integer;
begin
  exist:=false;
  st0:=Fmaj(st);
  i:=0;
  while (i<count) and (Fmaj(strings[i])<>st0) do inc(i);

  if (i>=count) then
    begin
      insert(0,st);
      if count>nbSt then delete(count-1);
    end;
end;

procedure ThistoryList.getV(var p:pointer;var taille0:integer);
var
  st:AnsiString;
begin
  taille0:=length(text);
  getmem(p,taille0);
  st:=text;
  system.move(st[1],p^,taille0);
end;

procedure ThistoryList.setV(p:pointer;taille0:integer);
var
  st:AnsiString;
begin
  setLength(st,taille0);
  system.move(p^,st[1],taille0);
  text:=st;
end;

function ThistoryList.Vsize:integer;
begin
  result:=length(text);
end;

function ChoixFichierStandard(var stGen,stFichier:AnsiString;stHis:ThistoryList):boolean;
  var
    st:AnsiString;
    i,k:integer;
    dialog:TopenDialog;
    exist:boolean;

  begin
    result:=false;
    dialog:=TopenDialog.create(nil);
    with dialog do
    begin
      {$IFNDEF FPC}
      FileEditStyle:=fsComboBox;
      {$ENDIF}
      if stFichier<>'' then
        begin
          initialDir:=cheminDuFichier(stFichier);
          FileName:='*'+extensionDuFichier(stfichier)
        end
      else
      if stGen<>'' then
        begin
          initialDir:=cheminDuFichier(stGen);
          FileName:='*'+extensionDuFichier(stGen)
        end
      else FileName:='*.*';

      if execute then
        begin
          stFichier:=fileName;
          stGen:=fileName;

          if assigned(stHis) then stHis.add(stFichier);

          result:=true;
        end;
    end;
    dialog.free;
  end;


function ChoixFichierStandard1(var stGen,stFichier:AnsiString;
                               filtre:AnsiString;var Ifiltre:integer):boolean;
  var
    st:AnsiString;
    i,k:integer;
    dialog:TopenDialog;
    exist:boolean;

  begin
    result:=false;
    dialog:=TopenDialog.create(nil);
    with dialog do
    begin
      {$IFNDEF FPC}
      FileEditStyle:=fsComboBox;
      {$ENDIF}

      if stFichier<>'' then
        begin
          initialDir:=cheminDuFichier(stFichier);
          FileName:='*'+extensionDuFichier(stfichier)
        end
      else
      if stGen<>'' then
        begin
          initialDir:=cheminDuFichier(stGen);
          FileName:='*'+extensionDuFichier(stGen)
        end
      else FileName:='*.*';

      filter:=filtre;
      filterIndex:=Ifiltre;

      if execute then
        begin
          stFichier:=fileName;
          stGen:=fileName;

          Ifiltre:=filterIndex;
          result:=true;
        end;
    end;
    dialog.free;
  end;


function GChooseFile(titre,stFichier:AnsiString):AnsiString;
  var
    dialog:TopenDialog;
  begin
    dialog:=TopenDialog.create(nil);
    with dialog do
    begin
      title:=titre;
      initialDir:=cheminDuFichier(stFichier);
      FileName:='*'+extensionDuFichier(stfichier);

      if execute
        then result:=fileName
        else result:='';
    end;
    dialog.free;
  end;

function SauverFichierStandard(var stFichier:AnsiString;ext:AnsiString):boolean;
  var
    dialog:TsaveDialog;
  begin
    SauverFichierStandard:=false;
    dialog:=TsaveDialog.create(nil);
    with dialog do
    begin
      if stFichier<>'' then
        begin
          initialDir:=cheminDuFichier(stFichier);
          FileName:=NomDuFichier(stfichier);
        end;

      {if ext<>'' then DefaultExt:=ext;}
      if (ext<>'') and (ext[1]='.') then delete(ext,1,1);
      if ext<>''
        then  filter:='*.'+ext+'|'+'*.'+ext + '|*.*|*.*'
        else  filter:='';
      filterIndex:=0;

      if execute then
        begin
          stFichier:=fileName;
          if ext<>'' then
            begin
              
              if pos('.',stFichier)=0 then stFichier:=stFichier+'.'+ext;
            end;

          SauverFichierStandard:=true;
        end;
    end;
    dialog.free;
  end;

function GSaveFile(titre,stFichier,ext:AnsiString):AnsiString;
  var
    dialog:TsaveDialog;

  begin
    dialog:=TsaveDialog.create(nil);
    with dialog do
    begin
      title:=titre;
      initialDir:=cheminDuFichier(stFichier);
      FileName:=NomDuFichier(stfichier);

      while pos('.',ext)>0 do delete(ext,1,1);

      if execute then
      begin
        if pos('.',fileName)=0
          then result:=fileName+'.'+ext
          else result:=fileName;
      end
      else result:='';
    end;
    dialog.free;
  end;



function EcraserFichier(st:AnsiString):boolean;
  var
    st0:String[80];
  begin
    EcraserFichier:=true;
    if fichierExiste(st) then
      begin
        st0:='File '+
             nomDuFichier(st)+
             ' already exists. Overwrite? (Y/N)';

        EcraserFichier:=messageDlg(st0,mtConfirmation,[mbYes,mbNo],0)=mrYes;
      end;
  end;

function ConvertFile(st1,st2:AnsiString;toWin:boolean):boolean;
var
  f1,f2: text;
  st:AnsiString;
begin
  try
  result:=false;
  Assign(f1, st1);
  Reset(f1);
  Assign(f2, st2);
  Rewrite(f2);

  while not eof(f1) do
  begin
    readln(f1,st);
    if toWin then st:=oem(st)
             else st:=ansi(st);
    writeln(f2,st);
  end;

  CloseFile(f1);
  CloseFile(f2);
  result:=true;

  except
  {$I-}
  CloseFile(f1);
  CloseFile(f2);
  {$I+}
  end;
end;


{$IF CompilerVersion >=22}
function GChooseDirectory(caption,root:AnsiString;var dir:AnsiString):boolean;
var
  dir1:string;
begin
  dir1:=dir;
  result:=selectDirectory(caption,root,dir1,[],nil);
  dir:=dir1;
end;
{$ELSE}
function GChooseDirectory(caption,root:AnsiString;var dir:AnsiString):boolean;
begin
  result:=selectDirectory(caption,root,dir);
end;
{$IFEND}


end.

