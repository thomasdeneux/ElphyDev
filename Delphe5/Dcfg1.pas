unit Dcfg1;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses Classes,sysutils,
     util1,DdosFich,debug0;

const
  enteteCfg1:AnsiString='CFG1';

type
  TgetVProc=procedure (var p:pointer;var taille0:integer) of object;
  {getV alloue et donne un bloc mémoire }

  TsetVProc=procedure (p:pointer;taille0:integer) of object;
  {setV prend et libère un bloc mémoire}

  TvarType=(TV_var,TV_string,TV_prop);

  typeMotCle=string[12];

  typeProcedureSetCfg1=procedure(lecture:boolean);

var
  EndCfgOffset:longint;
  {6-10-98: variable ajoutée en fin de fichier avec le mot-clé ENDCFG. Elle
            contient la taille du bloc configuration proprement dit. }

procedure SetVarConf1(mot:typeMotCle;var v;t:word);
procedure SetStringConf1(mot:typeMotCle;var v:AnsiString);
procedure SetPropConf1(mot:AnsiString;t:word;Vset:TsetVproc;Vget:TgetVProc);

function ecrireCfg1(st:AnsiString):smallint;
function lireCfg1(st:AnsiString):smallint;

procedure allouerCfg1(n:word);
procedure resetCfg1;


IMPLEMENTATION

type
  typeVarConf=record
                MotCle:typeMotCle;
                Taille:word;
                Pvar:pointer;
                tp:TvarType;
                getV:TgetVProc;
                setV:TsetVProc;
              end;
  PvarConf=^typeVarConf;

  typeTabVarConf=array[1..1000] of typeVarConf;
  PtabvarConf=^typeTabVarConf;

const
  maxConf:word=0;
  nbconf:word=0;
  Pconf:PtabvarConf=nil;

procedure allouerCfg1(n:word);
  var
    m:word;
  begin
    m:=sizeof(typeVarConf)*n;
    if m>maxAvail then exit;
    getmem(Pconf,m);

    maxConf:=n;
    nbConf:=0;
  end;

procedure resetCfg1;
  begin
    if Pconf<>nil then freemem(Pconf,sizeof(typeVarConf)*maxConf);
    Pconf:=nil;
  end;

procedure SetVarConf1;
  begin
    if (Pconf=nil) then exit;
    if (NbConf>=maxConf) then
      begin
        messageCentral('Trop de variables CFG1');
        halt;
      end;
    inc(NbConf);
    with Pconf^[nbConf] do
      begin
        motCle:=mot;
        Pvar:=@v;
        taille:=t;
        tp:=TV_var;
      end;
  end;

procedure SetStringConf1(mot:typeMotCle;var v:AnsiString);
  begin
    if (Pconf=nil) then exit;
    if (NbConf>=maxConf) then
      begin
        messageCentral('Trop de variables CFG1');
        halt;
      end;
    inc(NbConf);
    with Pconf^[nbConf] do
      begin
        motCle:=mot;
        Pvar:=@v;
        taille:=0;
        tp:=TV_string;
      end;
  end;

procedure SetPropConf1(mot:AnsiString;t:word;Vset:TsetVproc;Vget:TgetVProc);
begin
  if (Pconf=nil) then exit;
  if (NbConf>=maxConf) then
    begin
      messageCentral('Trop de variables CFG1');
      halt;
    end;
  inc(NbConf);
  with Pconf^[nbConf] do
    begin
      motCle:=mot;
      Pvar:=nil;
      taille:=t;
      tp:=TV_prop;
      setV:=Vset;
      getV:=Vget;
    end;
end;


function ecrireCfg1(st:AnsiString):smallint;
  var
    f:TfileStream;
    i:integer;
    res:intg;
    endVar:typeVarConf;
    ii:word;
    taille0:integer;
    p0:pointer;
    len:byte;

begin
  result:=0;
  f:=nil;
  if Pconf=nil then exit;

  TRY
    f:=TfileStream.create(st,fmCreate);

    len:=length(enteteCfg1);
    f.write(len,sizeof(len));
    f.Write(enteteCfg1[1],length(enteteCfg1));
    for i:=1 to nbConf do
      with Pconf^[i] do
        begin
          if tp=TV_var then
            begin
              f.write(Pconf^[i],sizeof(motCle)+2);
              f.write(Pvar^,taille);
            end
          else
          if tp=TV_string then
            begin
              {messageCentral(motCle+crlf+PansiString(Pvar)^);}
              f.write(Pconf^[i],sizeof(motCle));
              ii:=length(PansiString(pvar)^);
              f.write(ii,sizeof(ii));
              if ii>0 then f.write(PansiString(Pvar)^[1],ii);
            end
          else
          if tp=TV_prop then
            begin
              f.write(motCle,sizeof(motCle));
              getV(p0,taille0);
              {messageCentral(motCle+' '+Istr(taille0));}
              if taille0>65535 then messageCentral('Taille bloc varConf trop grande');
            {Les blocs doivent faire moins de 64K}
              f.write(taille0,2);
              f.write(p0^,taille0);
              freemem(p0);
            end
        end;

    endvar.motCle:='ENDCFG';
    endvar.taille:=sizeof(EndCfgOffset);
    endVar.Pvar:=@EndCfgOffset;

    EndCfgOffset:=f.position+sizeof(endvar.motCle)+2+sizeof(EndCfgOffset);

    f.write(endvar,sizeof(endvar.motCle)+2);
    f.write(EndCfgOffset,sizeof(EndCfgOffset));
    f.free;

  Except
    f.free;
    result:=1;
  end;

end;


function adresseVar(mot:typeMotCle):Pvarconf;
  var
    i:integer;
  begin
    result:=nil;
    mot:=Fmaj(mot);
    for i:=1 to nbConf do
      with Pconf^[i] do
      begin
        if motCle=mot then
          begin
            result:=@Pconf^[i];
            exit;
          end;
      end;
  end;

function lireCfg1(st:AnsiString):smallint;
var
  f:TfileStream;
  i:smallint;
  entete1:shortstring;
  vc:typeVarConf;
  pv:pvarconf;
  res:intG;
  posf:intG;
  ch:Ansichar;
  p0:pointer;
  len:byte;

begin
  result:=-1;
  if Pconf=nil then exit;

  if not fileExists(st) then
  begin
    result:=5000;
    exit;
  end;

  result:=0;
  f:=nil;
  posf:=0;

  TRY
    f:=TfileStream.Create(st,fmOpenRead);

    f.read(len,sizeof(len));
    setlength(entete1,len);
    f.read(entete1[1],len);

    if (entete1<>enteteCfg1) then
      begin
        f.free;
        messageCentral('Unrecognized configuration file');
        result:=-1;
        exit;
      end;

    repeat
      posf:=f.position;
      f.read(vc,sizeof(vc.motcle)+2);
       pv:=AdresseVar(vc.motcle);

      {messageCentral('==>'+vc.motCle+'  '+Istr(vc.taille)+' '+Bstr(pv<>nil));
      if pv<>nil then messageCentral('>'+Istr(ord(pv^.tp)));}

      if (pv=nil)
         or
         (pv^.taille<vc.taille) and (pv^.tp<>tv_prop) and (pv^.tp<>tv_string) then
        begin
          {messageCentral('SKIP '+vc.motCle);}
          f.Position:=posf+sizeof(vc.motcle)+2+vc.taille;
        end
      else
      if (pv^.tp=TV_string) then
        begin
          PansiString(pv^.pvar)^:='';
          for i:=1 to vc.taille do
            begin
              f.read(ch,1);
              PansiString(pv^.pvar)^:= PansiString(pv^.pvar)^+ch;
            end;
        end
      else
      if pv^.tp=TV_Prop then
        begin
          {messageCentral('PROP  '+pv^.motCle+Istr(vc.taille));}
          getmem(p0,vc.taille);
          f.read(p0^,vc.taille);
          pv^.setV(p0,vc.taille);
        end
      else
      if pv^.tp=TV_var then f.Read(pv^.pvar^,vc.taille);

    until (posf>=f.size) or (vc.MotCle='ENDCFG');
    if vc.MotCle='ENDCFG' then EndCfgOffset:=f.Position;

    f.Free;
  Except
    f.free;
    result:=1;
  end;
end;


end.
