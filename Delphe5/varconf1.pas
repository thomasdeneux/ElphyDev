unit Varconf1;


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
uses classes,sysUtils,
     util1,Gdos,Dgraphic,debug0;
{
 Gestion d'un bloc info.

 Sur le disque, un bloc contient:
 - un mot de 4 octets représentant la taille totale du bloc
      (y compris ces 4 octets)
 - un mot clé string de longueur quelconque identifiant le bloc
 - une suite de petits blocs contenant chacun:
     - une string de longueur quelconque
     - un mot de 2 octets représentant la taille de la variable qui est stockée
       après.

     - la variable proprement dite.

  8-10-01: Le système ayant été prévu pour sauver des variables de taille inférieure
  à 64K, nous l'améliorons avec l'astuce suivante:

  Pour des var>=64K, on range une taille égale à $FFFF . Vient ensuite la vraie taille
  sur 4 octets, puis la variable proprement dite.


Avec la procédure lire, le pointeur de fichier doit se trouver au début du bloc.
Si le bloc ne contient pas le nom donné dans Create, les variables ne seront pas
chargéees et le pointeur de fichier se trouvera à la fin du bloc.

Avec la procédure lire1, le pointeur de fichier doit se trouver après le mot-clé
On suppose donc que l'on a identifié le bloc auparavant et que l'on est prêt à
charger les infos. Le paramètre size fourni est la taille totale du bloc.

En lecture, les setvarConf peuvent donner une taille supérieure à celle qui est
stockée sur le disque.
}


const
  maxBlocConf=100;

type
  TgetVProc=procedure (var p:pointer;var taille0:integer) of object;
  {getV alloue et donne un bloc mémoire }

  TsetVProc=procedure (p:pointer;taille0:integer) of object;
  {setV prend et libère un bloc mémoire}

  TvarType=(TV_var,TV_string,TV_prop,TV_dyn,TV_data);
  { TV_var :    on donne l'adresse d'une variable et sa taille, optionnellement
                un gestionnaire d'événement Onread
    TV_string : on donne l'adresse d'une chaîne longue
    TV_prop :   on donne l'adresse de deux procédures exécutées à l'écriture et la lecture
    TV_dyn :    on donne l'adresse d'un pointeur et l'adresse d'un entier contenant la taille
    TV_data:    à l'écriture, on ne fait rien
                à la lecture, on range l'adresse fichier du bloc de données et sa taille
  }

  TBlocConf=class;

  TonRead=procedure(w:TblocConf) of object;
  { Procedure appelée juste après la lecture d'une variable (facultative)
    w est l'objet appelant.
    posf est la position du pointeur de fichier après la lecture de la variable.
  }
  typeVarConf=record
                tp:TvarType;
                Pvar:pointer;
                Psize:pointer;
                varSize:Plongint;
                Taille:integer;       {modifié le 8-10-01}
                MotCle:string[255];
                getV:TgetVProc;
                setV:TsetVProc;
                onRead: TonRead;
              end;
  PvarConf=^typeVarConf;

  TBlocConf=class
            private
              conf:array of typeVarConf;
              nbConf:integer;

              pvNext:integer;

              ad:integer;
              name:string[255];

              function adresseVar(mot:AnsiString):PVarConf;
              function tailleEcrite:integer;

              procedure affectVar(pv1:PvarConf);
            public
              constructor create(st:AnsiString);
              destructor destroy;override;

              procedure SetVarConf(mot:AnsiString;var v;t:integer);overload;
              procedure SetVarConf(mot:AnsiString;var v;t:integer;OnR:Tonread);overload;


              procedure SetStringConf(mot:AnsiString;var v:AnsiString);
              procedure SetPropConf(mot:AnsiString;t:integer;Vset:TsetVproc;Vget:TgetVProc);

              procedure SetDynConf(mot:AnsiString;var v;var t:integer);
              { v doit être un pointeur et t doit contenir la taille du bloc pointé
                La taille du bloc + le bloc sont sauvés.
                En lecture, le pointeur est réalloué et t est mis à jour.
              }
              procedure SetDataConf(mot:AnsiString;var posf: int64;var sizef:longWord);

              procedure ModifyVar(mot:AnsiString;var v;t:integer);

              function ecrire(f:Tstream):integer;
              function lire(f:TStream):integer;
              function lire1(f:Tstream;size:integer):integer;

              procedure copyFrom(conf1:TblocConf);

              procedure loadFromFile(stf:AnsiString);
              procedure SaveToFile(stf:AnsiString);

            end;

IMPLEMENTATION



constructor TBlocConf.create(st:AnsiString);
  begin
    inherited create;
    name:=st;
  end;

destructor TBlocConf.destroy;
  begin
    inherited destroy;
  end;

procedure TBlocConf.SetVarConf(mot:AnsiString;var v;t:integer);
var
  m:integer;
  pv:PvarConf;

begin
  inc(nbConf);
  setLength(conf,nbconf);
  with conf[nbConf-1] do
  begin
    Pvar:=@v;
    taille:=t;
    motCle:=mot;
    tp:=TV_var;
  end;

end;

procedure TBlocConf.SetVarConf(mot:AnsiString;var v;t:integer;OnR:TonRead);
begin
  setvarConf(mot,v,t);
  conf[nbConf-1].onRead:=onR;
end;

procedure TblocConf.SetStringConf(mot:AnsiString;var v:AnsiString);
begin
  setVarConf(mot,v,length(v));
  conf[nbConf-1].tp:=TV_string;
end;

procedure TblocConf.SetPropConf(mot:AnsiString;t:integer;Vset:TsetVproc;Vget:TgetVProc);
begin
  setVarConf(mot,t,t);

  with conf[nbConf-1] do
  begin
    getV:=Vget;
    setV:=Vset;
    tp:=TV_prop;
  end;
end;

procedure TBlocConf.SetDynConf(mot:AnsiString;var v;var t:integer);
begin
  setVarConf(mot,v,t);

  with conf[nbConf-1] do
  begin
    varSize:=@t;
    tp:=TV_Dyn;
  end;
end;

procedure TBlocConf.SetDataConf(mot:AnsiString;var posf:int64;var sizef:longword);
begin
  setVarConf(mot,posf,0);
  conf[nbConf-1].tp:=TV_data;
  conf[nbConf-1].Psize:=@sizef;
end;

function TBlocConf.tailleEcrite:longint;
var
  i:integer;
begin
  result:=0;

  for i:=0 to nbConf-1 do
  begin
    with conf[i] do
    begin
      inc(result,length(motCle)+1+sizeof(word)+taille);
      if taille>=$FFFF then inc(result,4);
    end;
  end;
end;

function TBlocConf.ecrire(f:Tstream):integer;
const
  Lmax:word=$FFFF;
var
  i:integer;
  size:integer;
  res:intG;
  ii:integer;
  p0:pointer;
  taille0:integer;

begin
  TRY
  result:=0;
  size:=4+1+length(name)+tailleEcrite;
  f.writeBuffer(size,sizeof(size));
  f.writeBuffer(name,1+length(name));

  for i:=0 to nbConf-1 do
  begin
    with conf[i] do
    begin
      f.writeBuffer(motCle,length(motCle)+1);
      case tp of
        TV_var:
        begin
          if taille>=Lmax then
            begin
              f.WriteBuffer(Lmax,sizeof(Lmax));
              f.WriteBuffer(taille,sizeof(taille));
            end
          else f.WriteBuffer(taille,sizeof(word));

          f.WriteBuffer(Pvar^,taille);
        end;

        TV_string :
        begin
          ii:=length(PansiString(pvar)^);
          if ii>=Lmax then
            begin
              f.writeBuffer(Lmax,sizeof(Lmax));
              f.WriteBuffer(ii,sizeof(ii));
            end
          else f.WriteBuffer(ii,sizeof(word));
          if ii>0 then f.WriteBuffer(PansiString(Pvar)^[1],ii);
        end;

        TV_prop:
        begin
          getV(p0,taille0);
          if taille0>=Lmax then
            begin
              f.WriteBuffer(Lmax,sizeof(Lmax));
              f.WriteBuffer(taille0,sizeof(taille0));
            end
          else f.WriteBuffer(taille0,sizeof(word));

          f.WriteBuffer(p0^,taille0);
          freemem(p0);
        end;

        TV_dyn:
        begin
          if varSize^>=Lmax then
            begin
              f.WriteBuffer(Lmax,sizeof(Lmax));
              f.WriteBuffer(varSize^,sizeof(varSize^));
            end
          else f.WriteBuffer(varSize^,sizeof(word));

          f.WriteBuffer(pointer(Pvar^)^,varSize^);
        end;



        TV_data: messageCentral('TV_data not supported');
      end;
    end;
  end;
  EXCEPT
    result:=-1;
  END;
end;


function TblocConf.adresseVar(mot:AnsiString):PVarConf;
var
  i:integer;
begin
  result:=nil;

  if pvNext<nbConf then
  with conf[pvNext] do
    if motCle=mot then
    begin
      result:=@conf[pvNext];
      inc(pvNext);
      exit;
    end;

  for i:=0 to nbConf-1 do
  with conf[i] do
  begin
    if motCle=mot then
      begin
        result:=@conf[i];
        pvNext:=i+1;
        exit;
      end;
  end;
end;

function TblocConf.lire(f:Tstream):integer;
  var
    st1:string[255];
    size:integer;
    vc:typeVarConf;
    p:pvarConf;
    t:word;
    res:intG;
    posf,posmax:int64;
    i:integer;
    ch:Ansichar;
    p0:pointer;

  begin
    result:=1;
    pvNext:=1;

    posf:=f.position;
    f.read(size,sizeof(size));
    f.read(st1,1);
    f.read(st1[1],length(st1));

    if st1<>name then
      begin
        lire:=501;
        f.Position:=posf+size;
        exit;
      end;


    posmax:=posf+size;
    if posmax>f.size then posmax:=f.size;

    posf:=f.position;

    repeat
      f.read(vc.motCle,1);
      f.read(vc.motCle[1],length(vc.motCle));

      vc.taille:=0;
      f.read(vc.taille,sizeof(word));
      if vc.taille=$FFFF then
        f.read(vc.taille,sizeof(vc.taille));

      p:=AdresseVar(vc.motcle);
      if assigned(p) then
        case p^.tp of
          TV_var:
            begin
              if (p^.taille>=vc.taille)
                then f.read(p^.pvar^,vc.taille)
                else f.read(p^.pvar^,p^.taille);
              if assigned(p^.onRead) then p^.onRead(self);
            end;

          TV_string:
            begin
              PansiString(p^.pvar)^:='';
              for i:=1 to vc.taille do
                begin
                  f.read(ch,1);
                  PansiString(p^.pvar)^:= PansiString(p^.pvar)^+ch;
                end;
            end;

          TV_Prop:
            begin
              {messageCentral('Load '+vc.motCle);}
              getmem(p0,vc.taille);
              f.read(p0^,vc.taille);
              p^.setV(p0,vc.taille);
            end;

          TV_dyn:
            begin
              p^.varSize^:=vc.taille;
              reallocmem(pointer(p^.pvar^),p^.varSize^);
              f.read(pointer(p^.pvar^)^,p^.varSize^);
            end;

          TV_data:
            begin
              Pint64(p^.pvar)^:=f.position;
              Plongword(p^.psize)^:=vc.taille;
            end;
        end;

      posf:=posf+length(vc.motcle)+3+vc.taille;
      f.position:=posf;
    until (posf>=posmax);

    f.position:=posmax;
    result:=0;
  end;

function TblocConf.lire1( f:Tstream;size:longint):integer;
  var
    vc:typeVarConf;
    p:Pvarconf;
    res:intg;
    posf,posmax:int64;
    i:integer;
    ch:Ansichar;
    p0:pointer;

  begin
    result:=1;
    pvNext:=1;

    posf:=f.position;
    posmax:=posf+size-sizeof(size)-1-length(name);
    if posmax>f.size then posmax:=f.size;

    repeat
      f.read(vc.motCle,1);
      f.read(vc.motCle[1],length(vc.motCle));

      vc.taille:=0;
      f.read(vc.taille,sizeof(word));
      if vc.taille=$FFFF then
      begin
        f.read(vc.taille,sizeof(vc.taille));   // utilisé  par Domenico et aussi par OIblock
        inc(posf,4);
      end;  

      {messageCentral(vc.motCle+'  '+Istr(vc.taille));}
      p:=AdresseVar(vc.motcle);
      {messageCentral(Bstr(p=nil)+'  '+Istr(t));}
      if assigned(p) then
        case p^.tp of
          TV_var:
            begin
              if (p^.taille>=vc.taille)
                then f.read(p^.pvar^,vc.taille)
                else f.read(p^.pvar^,p^.taille);
              if assigned(p^.onRead) then p^.onRead(self);
            end;

          TV_string:
            begin
              PansiString(p^.pvar)^:='';
              for i:=1 to vc.taille do
                begin
                  f.read(ch,1);
                  PansiString(p^.pvar)^:= PansiString(p^.pvar)^+ch;
                end;
            end;

          TV_prop:
            begin
              {messageCentral('Load '+vc.motCle);}
              getmem(p0,vc.taille);
              f.read(p0^,vc.taille);
              p^.setV(p0,vc.taille);
            end;

          TV_dyn:
            begin
              p^.varSize^:=vc.taille;
              reallocmem(pointer(p^.pvar^),p^.varSize^);
              f.readBuffer(pointer(p^.pvar^)^,p^.varSize^);
            end;

          TV_data:
            begin
              Pint64(p^.pvar)^:=f.position;
              Plongword(p^.psize)^:=vc.taille;
            end;
        end;

      if vc.taille<0
        then posf:=posmax
        else posf:=posf+length(vc.motcle)+3+vc.taille;

      f.position:=posf;
    until (posf>=posmax);

    f.position:=posmax;
    result:=0;
  end;

procedure TblocConf.affectVar(pv1:PvarConf);
var
  p:pvarConf;
  p0:pointer;
  taille0:integer;
begin
  p:=AdresseVar(pv1^.motCle);

  if assigned(p) then
    begin
      if (pv1^.tp=TV_String) and (p^.tp=TV_string) then
         PansiString(pv1^.pvar)^:=PansiString(p^.pvar)^
      else
      if (pv1^.tp=TV_prop) and (p^.tp=TV_prop) then
        begin
          p^.getV(p0,taille0);
          pv1^.setV(p0,taille0);
        end
      else
      if (pv1^.tp=TV_var) and (p^.tp=TV_var) and (pv1^.taille>=p^.taille)
        then move(p^.pvar^,pv1^.pvar^,p^.taille);
    end;
end;


procedure TblocConf.copyFrom(conf1:TblocConf);
var
  i:integer;
begin
  for i:=0 to nbconf-1 do
    conf1.affectVar(@conf[i]);
end;

procedure TblocConf.loadFromFile(stf:AnsiString);
var
  f:TfileStream;
begin
  if fileExists(stf) then
  begin
    f:=nil;
    TRY
      f:=TfileStream.create(stf,fmOpenRead);
      lire(f);
    FINALLY
      f.Free;
    END;
  end;
end;

procedure TblocConf.SaveToFile(stf:AnsiString);
var
  f:TfileStream;
begin
  f:=nil;

  TRY
    f:=TfileStream.create(stf,fmCreate);
    ecrire(f);
  FINALLY
    f.free;
  END;
end;


procedure TBlocConf.ModifyVar(mot: AnsiString;var v;t:integer);
var
  i:integer;
begin
  for i:=0 to nbConf-1 do
  with conf[i] do
  if MotCle=mot then
  begin
    Pvar:=@v;
    taille:=t;
    exit;
  end;
end;

end.
