unit UlexC;


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes, sysutils,
     util1;

(* Opérateurs C
  ( ) [ ] . ! ~ < > ? :
  = , + - * / % | & ^

  -> ++ -- <= >= == != && || << >>
  += -= *= /= %= <<= >>= |= &= ^=

  On ajoute { } ;
*)

type
  tplexC=  (vid,

            parou,
            parfer,
            croOu,
            crofer,
            point,
            exclam,
            tilde,
            inf,
            sup,
            interro,
            DeuxPoint,

            egal,
            virgule,
            plus,
            moins,
            mult,
            divis,
            percent,
            barre,
            et,
            expos,

            qualif,
            plusplus,
            moinsmoins,
            infegal,
            supegal,
            EgalEgal,
            NotEqual,
            EtEt,
            barrebarre,
            shiftL,
            shiftR,

            PlusEgal,
            MoinsEgal,
            MultEgal,
            DivEgal,
            ModEgal,
            ShiftLEgal,
            ShiftREgal,
            BarreEgal,
            EtEgal,
            ExposEgal,

            backSlash,
            SlashSlash,
            SlashStar,
            StaSlash,

            AccolOu,
            AccolFer,
            PointVirgule,

            FinFich,

            nbI,          { nombre entier }
            nbIhexa,
            nbIoctal,
            nbR,          { nombre réel }

            constCar,
            chaineCar,
            comment,
            ligneVide,

            identifier
            );

  TUlexC=class
         private
           fileName:AnsiString;
           f:TfileStream;

           UlexInclus:TUlexC;
           lastChar:char;

         public
           Ligne,colonne:integer;
           error:integer;

           constructor create(stF:AnsiString);
           destructor destroy;override;

           function lirechar:char;
           function readLine:AnsiString;
           procedure renvoyer;
           procedure PreProcess;

           procedure processDefine;
           procedure processInclude;
           procedure processIfDef;
           procedure processIf;
           procedure processIfNDef;
           procedure processElse;
           procedure processEndIf;

           function IncludeFile:boolean;

           procedure lire(  var stMot:AnsiString;
                            var tp:tpLexC;
                            var CurrentFile:AnsiString);

           procedure lireIgnore
                           (var stMot:shortString;
                            var tp0:tpLexC;
                            var numInclus:integer);
         end;


procedure testUlexC(stSrc,stDest:AnsiString);


IMPLEMENTATION



const
  carfin=#26;


const
  maxchaineCar=250;
  longueurNom=250;

const
  chiffre:set of char=['0'..'9'];
  chiffreHexa:set of char=['0'..'9','A'..'F','a'..'f'];

  lettre:set of char=['a'..'z','A'..'Z','_'];

{Tfilechar}


{ ************************************************************************** }
{ ********************* ANALYSEUR LEXICAL pour langage C ******************* }
{ ************************************************************************** }


constructor TUlexC.create(stF:AnsiString);
begin
  f:=TfileStream.Create(stF,fmOpenRead);
  fileName:=stF;

  ligne:=1;
  Colonne:=1;
end;

Destructor TUlexC.destroy;
begin
  f.Free;
end;

function TUlexC.lirechar: char;
begin
  if f.Read(lastChar,1)=0
    then lastchar:=carfin
  else
  if lastChar=#10 then
  begin
    inc(ligne);
    colonne:=1;
  end;
  result:=lastChar;
end;

function TUlexC.readLine:AnsiString;
var
  c,c1:char;
begin
  result:='';
  repeat
    c:=lireChar;
    if not (c in [#10,#13,carfin]) then result:=result+c;
  until c in [#10,#13,carfin];
  if c<>carfin then c1:=lirechar;

  if not((c=#13) and (c1=#10) or (c=#10) and (c1=#13)) then renvoyer;
end;

procedure TUlexC.renvoyer;
begin
  f.Seek(-1,soFromCurrent);
  if lastChar=#10 then dec(ligne);
end;


procedure TUlexC.processDefine;
var
  st1,st2:AnsiString;
  c:char;
  fini:boolean;
begin
{
  st1:='';
  fini:=false;
  while not fini do
  begin
    repeat
      c:=lireChar;
      if not (c in [#10,#13,carfin]) then st1:=st1+c;
    until c in [#10,#13,carfin];
    renvoyer;
    st1:=FsupespaceFin(st1);

 }
end;

procedure TUlexC.processInclude;
begin
end;

procedure TUlexC.processIfDef;
begin
end;

procedure TUlexC.processIf;
begin
end;

procedure TUlexC.processIfNDef;
begin
end;

procedure TUlexC.processElse;
begin
end;

procedure TUlexC.processEndIf;
begin
end;


procedure TUlexC.PreProcess;
var
  c:char;
  stMot:AnsiString;
begin
     {# vient d'être lu}
  stMot:='';
  repeat
    c:=lireChar;
    if c in lettre then stMot:=stMot+c;
  until not (c in lettre);
  renvoyer;

  stMot:=Fmaj(stMot);
  if stMot='DEFINE' then processDefine
  else
  if stMot='INCLUDE' then processInclude
  else
  if stMot='IFDEF' then processIfDef
  else
  if stMot='IF' then processIf
  else
  if stMot='IFNDEF' then processIfNDef
  else
  if stMot='ELSE' then processElse
  else
  if stMot='ENDIF' then processEndIf

end;


procedure TUlexC.lire(var stMot:AnsiString;
                  var tp:tpLexC;
                  var CurrentFile:AnsiString);
var
  c,c1:char;

begin
  stMot:='';
  tp:=vid;
  error:=0;

  if includeFile then
  begin
    UlexInclus.lire(stMot, tp, CurrentFile);
    error:=UlexInclus.error;
    ligne:=UlexInclus.ligne;
    colonne:=UlexInclus.colonne;

    if tp=finFich then
    begin
      UlexInclus.Free;
      UlexInclus:=nil;
    end
    else exit;
  end;

  repeat c:=lireChar until not(c in[' ',#10,#13,#9]);

  stmot:=c;

  case c of
    '#' : PreProcess;    {include ou define ou ifdef...}
    '/' : begin
            c1:=lirechar;
            case c1 of
              '*':  begin            {commentaire commençant par /* }
                      stMot:='(*';
                      repeat
                        c:=c1;
                        c1:=lirechar;
                        stMot:=stMot+c1;
                      until (c='*') and (c1='/') or (c1=carfin);
                      if c1<>carfin then stMot[length(stMot)]:=')';
                      tp:=comment;
                    end;
              '/':  begin            {commentaire commençant par // }
                      stMot:='(*';
                      repeat
                        c1:=lirechar;
                        stMot:=stMot+c1;
                      until (c1=#10) or (c1=#13) or (c1=carfin);
                      stMot:=stMot+'*)';
                      tp:=comment;
                    end;
              '=':  tp:=DivEgal;
              else  begin
                      tp:= Divis;
                      renvoyer;
                    end;
            end;
          end;

    carFin:  begin
               renvoyer;
               tp:=FinFich;
             end;

    '('   :    tp:= parOu;
    ')'   :    tp:= parfer;
    '['   :    tp:= croOu;
    ']'   :    tp:= croFer;
    '.'   :    tp:= point;
    '!'   :    begin
                 tp:= exclam;
                 if lirechar='='
                   then tp:=NotEqual
                   else renvoyer;
               end;
    '~'   :    begin
                 tp:= tilde;
                 if lirechar='='
                   then tp:=ModEgal
                   else renvoyer;
               end;
    '<'   :    begin
                 tp:= inf;
                 case lirechar of
                   '<' :  begin
                           if lirechar='='
                             then tp:=ShiftLEgal
                             else renvoyer;
                          end;
                   '=' : tp:= infEgal;
                   else renvoyer;
                 end;
               end;
    '>'   :    begin
                 tp:= sup;
                 case lirechar of
                   '>' :  begin
                           if lirechar='='
                             then tp:=ShiftREgal
                             else renvoyer;
                          end;
                   '=' : tp:= SupEgal;
                   else renvoyer;
                 end;
               end;
    '?'   :    tp:= interro;
    ':'   :    tp:= DeuxPoint;
    '='   :    begin
                 tp:= Egal;
                 if lirechar='='
                   then tp:=EgalEgal
                   else renvoyer;
               end;
    ','   :    tp:= Virgule;

    '+':begin
          tp:=plus;
          case lirechar of
            '+' : tp:=plusplus;
            '=' : tp:=plusEgal;
            else renvoyer;
          end;
        end;
    '-':begin
          tp:=moins;
          case lirechar of
            '>':  tp:=qualif;
            '-':  tp:=moinsmoins;
            '=': tp:=moinsEgal;
            else renvoyer;
          end;
        end;

    '*'   :    begin
                 tp:= mult;
                 if lirechar='='
                   then tp:=MultEgal
                   else renvoyer;
               end;
    '%'   :    begin
                 tp:= PerCent;
                 if lirechar='='
                   then tp:=ModEgal
                   else renvoyer;
               end;
    '|'   :    begin
                 tp:= barre;
                 if lirechar='='
                   then tp:=BarreEgal
                   else renvoyer;
               end;
    '&'   :    begin
                 tp:= Et;
                 if lirechar='='
                   then tp:=EtEgal
                   else renvoyer;
               end;
    '^'   :    begin
                 tp:= expos;
                 if lirechar='='
                   then tp:=ExposEgal
                   else renvoyer;
               end;


    '''':     begin                    {caractère}
                c:=lirechar;
                stMot:=c;
                if c in [carfin,#10,#13,''''] then error:=5;
                c:=lirechar;
                if c<>'''' then error:=5;
                tp:=Constcar;
              end;

    '"':                               { chaine de caractères }
      begin
        stmot:='';
        repeat
          c:=lirechar;
          {gérer les séquences d'échappement}

          stMot:=stMot+c;
        until (length(stMot)>=maxchaineCar) or (c in [carfin,#10,#13,'"']) ;

        if length(stMot)>=maxchaineCar then error:=4;
        if c<>'"' then error:=4;
        tp:=chaineCar;
      end;


    'A'..'Z','a'..'z':                 { identificateurs }
      begin
        stMot:=c;
        repeat
          c:=lirechar;
          stMot:=stMot+c;
        until not( c in lettre+chiffre );
        renvoyer;
        delete(stMot,length(stMot),1);
        tp:=identifier;
      end;

    '0'..'9':                        { Nombres }
      begin
        if c='0' then
        begin
          c:=lirechar;
          if (c='x') or (c='X') then { hexadécimal }
          begin
            stMot:='$';
            repeat
              c:=lirechar;
              if c in chiffreHexa then stMot:=stMot+c;
            until not (c in chiffreHexa);

            case c of
              'u','U','l','L':
              else renvoyer;
            end;

            tp:=NbIhexa;
            exit;
          end
          else
          if c in chiffre then       { octal }
          begin
            stMot:=c;
            repeat
              c:=lirechar;
              if c in chiffre then stMot:=stMot+c;
            until not (c in chiffre);

            case c of
              'u','U','l','L':
              else renvoyer;
            end;

            tp:=NbIoctal;
            exit;
          end
          else
          begin
            renvoyer;              { on peut avoir 0.12 ; dans ce cas, on continue }
            c:='0';
          end;
        end;

        stMot:=c;
        while c in chiffre do
        begin
          c:=lireChar;
          stmot:=stmot+c;
        end;

        if not (c in ['.','E','e']) then
          begin
            renvoyer;
            delete(stMot,length(stMot),1);
            tp:=nbI;
            exit;
          end;

        if c='.' then
        begin
          repeat
            c:=lirechar;
            stMot:=stMot+c;
          until not (c in chiffre);
        end;

        if (c='E') or (c='e') then
          begin
            c:=lirechar;
            stMot:=stMot+c;
            if (c='+') or (c='-') then
            begin
              stMot:=stMot+c;
              c:=lirechar;
            end;
            while c in chiffre do
            begin
              c:=lirechar;
              stMot:=stMot+c;
            end;
          end;

        renvoyer;
        delete(stMot,length(stMot),1);

        tp:=nbr
      end;

    '{': tp:=AccolOu;
    '}': tp:=AccolFer;
    ';': tp:=PointVirgule;

    else
      begin
        stMot:=c;
        error:=3;
      end;
  end;
end;


procedure TUlexC.lireIgnore(var stMot:shortString;
                            var tp0:tpLexC;
                            var numInclus:integer);
begin
end;




function TUlexC.IncludeFile: boolean;
begin
  result:=assigned(UlexInclus);
end;




function lineCount(st:AnsiString):integer;
var
  i:integer;
begin
  result:=1;
  for i:= 1 to length(st) do
    if st[i]=#10 then inc(result);
end;

procedure testUlexC(stSrc,stDest:AnsiString);
var
  fDest:TextFile;
  UlexC:TUlexC;

  stMot,stFile:AnsiString;
  tp:TpLexC;
  i,LastLine:integer;

begin
  AssignFile(fDest,stDest);
  Rewrite(fDest);

  UlexC:=TUlexC.create(stSrc);
  repeat
    LastLine:=UlexC.Ligne;
    UlexC.lire(stMot,tp,stFile);
    for i:=lastline+lineCount(stMot)+1 to UlexC.ligne do writeln(fDest,'');

    writeln(fDest,ord(tp):3,'     ',stMot);
  until tp=finFich;

  UlexC.free;
  CloseFile(fDest);
end;


end.
