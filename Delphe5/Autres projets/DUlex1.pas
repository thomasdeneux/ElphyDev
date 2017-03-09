unit Dulex1;

{$O+,F+}

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Gdos,Ncdef2;



const
  Finclus:boolean=false;   { Fichier inclus en cours }
  nomFinclus: String='';   { nom du fichier inclus en cours }
  pFinclus:integer=0;         { position du caractŠre analys‚ dans le f.inclus }
  ligInclus:Integer=0;     { ligne erreur dans Finclus }
  colInclus:Integer=0;     { col erreur dans Finclus }

function initUlex1(st:string):boolean;
procedure DoneUlex1;

procedure coordonneesF(ad:integer;var lig,col:Integer);
procedure coordonneesFinclus;

procedure lireUlex1(var buf;
                    tailleBuf:integer;
                    var pcDef:integer;
                    var stMot:String;
                    var tp:typeLex;
                    var x:float;
                    var error:Integer);

{ lireUlex1 d‚code essentiellement les nombres non sign‚s, les chaŒnes, les
  identificateurs et les symboles principaux.
  buf et taillebuf ne servent à rien. Ils sont là pour assurer la compatibilité
  avec Ulex1.
  PcDef est la position du dernier caractŠre analys‚, autrement dit au
  premier appel on doit donner PcDef=integer(-1) .
  stMot est le mot extrait de buf.
  Un mot commence par une lettre ou @ suivie de chiffres, de lettres ou du
  caractŠre '_'.
  tp0 est de type typeLex. Le programme utilisateur doit d‚clarer une liste
  d'unit‚s lexicales comme ci-dessous en ajoutant les unit‚s suppl‚mentaires
  … la suite.
  x contient le nombre d‚cod‚ ( nbi, nbL ou nbR )
  error est le code d'erreur.
  Les codes d'erreur possibles sont
    0: pas d'erreur
    1: Identificateur trop long
    2: Nombre r‚el hors limites
    3: CaractŠre inconnu
    4: chaŒne trop longue

    10:erreur fichier inclus


}


IMPLEMENTATION

const
  carfin=#26;
  nomFparent:string='';   { nom du fichier analysé principal }



const
  maxchaineCar=250;
  longueurNom=250;

const
  chiffre:set of char=['0'..'9'];
  chiffreHexa:set of char=['0'..'9','A'..'F','a'..'f'];

  lettre:set of char=['a'..'z','A'..'Z','_'];


const
  maxBufFileChar=10000;
type
  typeFileChar=object
                 f:file;
                 buf:array[-10..maxBufFileChar-1] of char;
                 p:Integer;
                 pa:integer;
                 eof0:boolean;
                 res:integer;
                 constructor init(st:string);
                 function lire:char;
                 procedure renvoyer;
                 function fin:boolean;
                 procedure coordonnees(ad:integer;var lig,Col:Integer);

                 destructor done;
               end;

constructor typeFileChar.init(st:string);
  begin
    eof0:=false;
    p:=0;
    pa:=0;
    assign(f,st);
    Greset(f,1);
    Gblockread(f,buf[0],maxBufFileChar,res);
    eof0:=res<>maxBufFileChar;
  end;

function typeFileChar.lire:char;
  begin
    lire:=buf[p];
    inc(p);
    inc(pa);
    if p=maxBufFileChar then
      begin
        move(buf[maxBufFileChar-10],buf[-10],10);
        Gblockread(f,buf[0],maxBufFileChar,res);
        eof0:=res<>maxBufFileChar;
        p:=0;
      end;
  end;

procedure typeFileChar.renvoyer;
  begin
    if p>-10 then
      begin
        dec(p);
        dec(pa);
      end;
  end;

function typeFileChar.fin:boolean;
  begin
    fin:=eof0 and (p>=res);
  end;

procedure typeFileChar.coordonnees(ad:integer;var lig,Col:Integer);
  var
    m:integer;
    c:char;
  begin
    lig:=1;
    col:=1;
    m:=0;
    while (m<ad) do
      begin
        c:=lire;
        if c=#13 then
          begin
            inc(lig);
            col:=1;
          end
        else
        if c<>#10 then inc(col);
        inc(m);
      end;
  end;


destructor typeFileChar.done;
  begin
    Gclose(f);

  end;

const
  ffc:^typeFileChar=nil;
  ffc0:^typeFileChar=nil;



{ ************************************************************************** }
{ ********************* ANALYSEUR LEXICAL ********************************** }
{ ************************************************************************** }


procedure lireUlex1(var buf;
                    tailleBuf:integer;
                    var pcDef:integer;
                    var stMot:String;
                    var tp:typeLex;
                    var x:float;
                    var error:Integer);

  var
    c:char;
    st0:String;
    code:integer;
    fin,flag,flagDebutINC,flag1,finCom:boolean;
    nbdigit:integer;
    w:integer;
    stN:string;

  function lire:char;
    begin
      if Finclus then
        begin
          lire:=ffc^.lire;
          if ffc^.fin then
            begin
              pFinclus:=ffc^.pa;
              dispose(ffc,done);

              ffc:=nil;
              Finclus:=false;
            end;
        end
      else
        begin
          if ffc0^.fin then lire:=carfin
          else
            begin
              lire:=ffc0^.lire;
              pcDef:=ffc0^.pa;
            end;
        end;
    end;

  procedure renvoyer;
    begin
      if Finclus
        then ffc^.renvoyer
        else ffc0^.renvoyer;
    end;

  procedure analyseINC;

    begin
      nomFinclus:='';
      repeat
        nomFinclus:=nomFinclus+lire
      until (length(nomFinclus)>=255) or (nomFinclus[length(nomFinclus)]='}');

      if length(nomFinclus)>=255 then
        begin
          repeat c:=lire until (c=carfin) or (c='}');
          renvoyer;
        end
      else
        begin
          delete(nomFinclus,length(nomFinclus),1);
          nomFinclus:=Fsupespace(nomFinclus);
          nomFinclus:=trouverFichier(nomFinclus,nomFparent);
          if nomFinclus='' then
            begin
              error:=10;
              pFinclus:=ffc^.pa;
              ffc:=nil;
              exit;
            end;

          new(ffc,init(nomFinclus));
          if GIO<>0 then
            begin
              error:=10;
              pFinclus:=ffc^.pa;
              dispose(ffc,done);
              ffc:=nil;
              Finclus:=false;
            end
          else
            begin
              Finclus:=true;
            end;
        end;
    end;

  begin
    st0:='';
    stMot:='';
    x:=0;
    tp:=vid;
    error:=0;
    flagDebutINC:=false;
    repeat
      repeat c:=lire until not(c in[' ',#10,#13]);
      flag1:=false;
      flag:=(c='{');

      if c='(' then
        begin
          flag1:=(lire='*');
          if not flag1 then renvoyer;
        end;

      if flag or flag1 then
        begin
          c:=lire;
          if flag and (c='$') then
            begin
              c:=lire;
              if not Finclus and ((c='I') or (c='i')) then
                begin
                  analyseINC;
                  flagDebutINC:=true;
                end
              else
                begin
                  stMot:=c;
                  while (c<>'}') and (c<>carfin) do
                  begin
                    c:=lire;
                    stMot:=stMot+c;
                  end;
                  if c='}' then delete(stMot,length(stMot),1);
                  tp:=directive;
                  exit;
                end;
            end
          else renvoyer;

          finCom:=false;
          if not flagDebutINC then
            repeat
              c:=lire;
              if flag and (c='}') then finCom:=true;
              if flag1 and (c='*') then
                begin
                  c:=lire;
                  if c=')' then fincom:=true else renvoyer;
                end;
            until (c=carfin) or finCom;
        end;
    until not (flag or flag1);
   (*
      flag:=(c='{');
      if flag then
        begin
          c:=lire;
          if c='$' then
            begin
              c:=lire;
              if not Finclus and ((c='I') or (c='i')) then
                begin
                  analyseINC;
                  flagDebutINC:=true;
                end
              else
                begin
                  stMot:=c;
                  while (c<>'}') and (c<>carfin) do
                  begin
                    c:=lire;
                    stMot:=stMot+c;
                  end;
                  if c='}' then delete(stMot,length(stMot),1);
                  tp:=directive;
                  exit;
                end;
            end
          else renvoyer;

          if not flagDebutINC then
            repeat c:=lire until (c=carfin) or (c='}');
        end;
    until not flag;
    *)
    if c=carFin then
      begin
        renvoyer;      { Les prochains appels renverront toujours Carfin }
        tp:=FinFich;
        exit;
      end;
    case c of
      '+':tp:=plus;
      '-':tp:=moins;
      '*':tp:=mult;
      '/':tp:=divis;
      '^':tp:=expos;
      '(':tp:=parOu;
      ')':tp:=parFer;
      '[':tp:=croOu;
      ']':tp:=croFer;

      ',':tp:=virgule;
      ';':tp:=PointVirgule;
      '=':tp:=egal;
      ':':
        begin
          c:=lire;
          if c='=' then tp:=DeuxPointEgal
          else
            begin
              tp:=DeuxPoint;
              renvoyer;
            end;
        end;

      '.':
        begin
          c:=lire;
          if c='.' then tp:=PointDouble
          else
            begin
              tp:=PointL;
              renvoyer;
            end;
        end;

      '''','#':
      begin
        stmot:='';

        repeat
          if c='''' then
            begin
              fin:=false;

              repeat
                stMot:=stMot+lire;
                flag:=(length(stMot)>=maxchaineCar) or
                    (stMot[length(stMot)] in [carfin,#10,#13]);
                if not flag and (stMot[length(stMot)]='''') then
                  begin
                    c:=lire;
                    if c<>'''' then
                      begin
                        renvoyer;
                        fin:=true;
                      end;
                  end;

              until flag or fin;
              delete(stMot,length(stMot),1);
            end
          else
          if c='#' then
            begin
              c:=lire;
              stN:='';
              while c in chiffre do
              begin
                stN:=stN+c;
                c:=lire;
              end;
              val(stN,w,code);
              stMot:=stMot+chr(w);
              renvoyer;
            end;

          c:=lire;
        until flag or not( c in ['#','''']) ;

        renvoyer;
        if flag then error:=4;

        if length(stMot)=1
          then tp:=ConstCar
          else tp:=chaineCar;
      end;

      'A'..'Z','a'..'z','@':
        begin
          st0:=c;
          repeat
            st0:=st0+lire;
          until not( st0[length(st0)] in lettre+chiffre );
          renvoyer;
          delete(st0,length(st0),1);
          stMot:=st0;
          if length(st0)>longueurNom then  error:=1;
        end;

      '0'..'9':
        begin
          st0:=c;
          while st0[length(st0)] in chiffre do st0:=st0+lire;


          if not (st0[length(st0)] in ['.','E','e']) then
            begin
              renvoyer;
              delete(st0,length(st0),1);
              val(st0,x,code);
              if (x<=32767) then tp:=nbi
              else
              if (x<=2147483647) then tp:=nbL
              else tp:=nbr;
              exit;
            end;

          if st0[length(st0)]='.' then
            begin
              st0:=st0+lire;
              if st0[length(st0)]='.' then
                begin
                  renvoyer;
                  renvoyer;
                  delete(st0,length(st0)-1,2);
                  val(st0,x,code);
                  if (x<=32767) then tp:=nbi
                  else
                  if (x<=2147483647) then tp:=nbL
                  else tp:=nbr;
                  exit;
                end;
              while st0[length(st0)] in chiffre do st0:=st0+lire;
            end;

          if (st0[length(st0)]='E') or (st0[length(st0)]='e') then
            begin
              st0:=st0+lire;
              if (st0[length(st0)]='+') or (st0[length(st0)]='-') then
                st0:=st0+lire;
              while st0[length(st0)] in chiffre do st0:=st0+lire;
            end;

          renvoyer;
          delete(st0,length(st0),1);
          val(st0,x,code);
          if code=0 then tp:=nbr
          else error:=2;
        end;

      '$':
        begin
          st0:=c;
          nbDigit:=0;
          repeat
            st0:=st0+lire;
            inc(nbDigit);
          until not (st0[length(st0)] in chiffreHexa);

          if nbDigit>8 then
            begin
              error:=2;
              exit;
            end;

          renvoyer;
          delete(st0,length(st0),1);
          val(st0,w,code);
          x:=w;
          if (x<=32767) then tp:=nbi
          else tp:=nbL;

          exit;

        end;


      '<':
        begin
          c:=lire;
          if c='=' then tp:=infEgal
          else
          if c='>' then tp:=different
          else
            begin
              tp:=inf;
              renvoyer;
            end;
        end;

      '>':
        begin
          c:=lire;
          if c='=' then tp:=SupEgal
          else
            begin
              tp:=sup;
              renvoyer;
            end;
        end;

      else
        begin
          stMot:=c;
          error:=3;
        end;
    end;

    st0:=Fmaj(st0);
    if st0='OR' then tp:=OpOR
    else
    if st0='AND' then tp:=OpAND
    else
    if st0='XOR' then tp:=OpXOR
    else
    if st0='NOT' then tp:=OpNOT
    else
    if st0='DIV' then tp:=OpDiv
    else
    if st0='MOD' then tp:=OpMod
    else
    if st0='SHL' then tp:=OpShl
    else
    if st0='SHR' then tp:=OpShr;
  end;

function initUlex1(st:string):boolean;
  begin
    nomFparent:=st;
    new(ffc0,init(st));

    if GIO<>0 then
      begin
        dispose(ffc0,done);
        ffc0:=nil;
      end;
    Finclus:=false;
    initUlex1:=(GIO=0);
  end;

procedure DoneUlex1;
  begin
    if Finclus then
      begin
        pFinclus:=ffc^.pa;
        if ffc<>nil then dispose(ffc,done);
        ffc:=nil;
        {Finclus:=false;}
      end;
     if ffc0<>nil then dispose(ffc0,done);
     ffc0:=nil;
  end;

procedure coordonneesFinclus;
  begin
    ligInclus:=0;
    colInclus:=0;
    new(ffc,init(nomFinclus));
    if GIO=0 then ffc^.coordonnees(pFinclus,ligInclus,ColInclus);
    dispose(ffc,done);
    ffc:=nil;
  end;

procedure coordonneesF(ad:integer;var lig,col:Integer);
  begin
    lig:=0;
    col:=0;
    new(ffc0,init(nomFparent));
    if GIO=0 then ffc0^.coordonnees(ad,lig,Col);
    dispose(ffc0,done);
    ffc0:=nil;
  end;

end.
