{Version Delphi}

unit Ptext0;

{ Gestion de fichiers texte avec plus de 255 caractäres par ligne }

INTERFACE

uses util1;

type
  TypePseudoText=object
                   buf:PtabChar;
                   taille:integer;
                   f:file;
                   Plec:integer;
                   pPos,pmax:longint;
                   error:integer;
                   constructor init(n:integer);
                   procedure Passign(st:string);
                   procedure Prewrite;
                   procedure Pappend;
                   procedure Preset;
                   procedure Pclose;
                   procedure Pwrite(st:shortString);
                   procedure Pwriteln(st:shortString);
                   function Preadln(var nb:integer):pointer;
                   function Perror:integer;
                   function Peof:boolean;
                   destructor done;
                 end;

  PpseudoText= ^TypePseudoText;

IMPLEMENTATION

constructor TypePseudoText.init(n:integer);
  begin
    if maxAvail<n then
      begin
        taille:=0;
        error:=-1;
        exit;
      end;
    getmem(buf,n);
    taille:=n;
    error:=0;
    Plec:=0;
    pmax:=0;
  end;

procedure TypePseudoText.Passign(st:string);
  begin
    if error<>0 then exit;
    assign(f,st);
  end;

procedure TypePseudoText.Prewrite;
  begin
    if error<>0 then exit;
    rewrite(f,1);
    error:=IOresult;
  end;

procedure TypePseudoText.Pappend;
  begin
    if error<>0 then exit;
    reset(f,1);
    error:=IOresult;
    if error=0 then
      begin
        pMax:=fileSize(f);
        error:=IOresult;
      end;
    pPos:=pMax;
    if error=0 then seek(f,pMax);
  end;

procedure TypePseudoText.Preset;
  var
    res:intG;
  begin
    if error<>0 then exit;
    reset(f,1);
    error:=IOresult;
    if error=0 then
      begin
        blockread(f,buf^,taille,res);
        error:=IOresult;
      end;
    if error=0 then
      begin
        pmax:=fileSize(f);
        error:=IOresult;
        pPos:=0;
      end;
  end;

procedure TypePseudoText.Pclose;
  begin
    if error<>0 then exit;
    close(f);
    error:=IOresult;
  end;

procedure TypePseudoText.Pwrite(st:shortString);
  begin
    if error<>0 then exit;
    if Plec+length(st)<taille-2 then
      begin
        move(st[1],buf^[Plec],length(st));
        inc(Plec,length(st));
      end
    else error:=-2;
  end;

procedure TypePseudoText.Pwriteln(st:shortString);
  var
    res:intG;
  begin
    Pwrite(st);
    if error<>0 then exit;
    buf^[Plec]:=#13;
    buf^[Plec+1]:=#10;

    BlockWrite(f,buf^,Plec+2,res);
    error:=IOresult;
    Plec:=0;
  end;


function TypePseudoText.Preadln(var nb:integer):pointer;
  var
    res:intG;
  begin
    if error<>0 then exit;
    if Plec>0 then move(buf^[Plec],buf^[0],taille-Plec);
    blockread(f,buf^[taille-Plec],Plec,res);
    error:=IOresult;
    if error<>0 then exit;

    Plec:=0;
    while (buf^[Plec]<>#10) and (buf^[Plec]<>#13) and (Plec<taille)
      do inc(Plec);

    nb:=Plec;
    if Plec<taille-2 then
      begin
        if buf^[Plec]=#13 then
          begin
            buf^[Plec]:=#0;
            if buf^[Plec+1]=#10 then
              begin
                buf^[Plec+1]:=#0;
                inc(Plec);
              end;
          end
        else buf^[Plec]:=#0;
        inc(pLec);
        inc(pPos,pLec);
      end
    else error:=-3;
    Preadln:=buf;
  end;

function TypePseudoText.Perror:integer;
  begin
    Perror:=error;
  end;

function TypePseudoText.Peof:boolean;
  begin
   if error<>0 then exit;


    Peof:=(Ppos>=pmax);
    error:=IOresult;
  end;

destructor TypePseudoText.done;
  begin
    if taille<>0 then freemem(buf,taille);
  end;

end.