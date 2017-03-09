unit DUlex5;


INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes, sysutils,
     util1, NcDef2;

{   TUlex1 est l'analyseur lexical utilisé par Ncompil3.

    Le texte est fourni par un descendant de TUgetText. Ce qui permet d'avoir un
    texte stocké de différentes façons. Seuls NextString et eof sont importants.

    TUgetText fournit le texte ligne par ligne avec NextString.
    eof signale qu'il n'y a plus de lignes disponibles.
    Init doit placer le pointeur de lecture sur la première ligne.

    Posmax et getPos permettent au compilateur de montrer la progression de
    la compilation.
    FileName s'affichera aussi dans la boite montrant la progression


}

type
  TUgetText= class
               procedure Init;virtual;abstract;
               function NextString:AnsiString;virtual;abstract;
               function eof:boolean;virtual;abstract;
               function posMax:integer;virtual;abstract;
               function getPos:integer;virtual;abstract;
               function fileName:AnsiString;virtual;abstract;
             end;

  TUTextStringList=
             class(TUgetText)
               list0:TstringList;
               line,Fpos:integer;
               constructor create(list:Tstringlist);
               procedure Init;override;
               function NextString:AnsiString;override;
               function eof:boolean;override;
               function posMax:integer;override;
               function getPos:integer;override;
               function fileName:AnsiString;override;
             end;

  TUtextFile=class(TUgetText)
             private
                Fname:AnsiString;
                f:Text;
                size,Fpos:integer;
             public
                constructor create(stF:AnsiString);
                destructor destroy;override;

                procedure Init;override;
                function NextString:AnsiString;override;
                function eof:boolean;override;
                function posMax:integer;override;
                function getPos:integer;override;
                function fileName:AnsiString;override;
             end;


  TUlex1=class
         private
           stList:TUgetText;
           st0list:AnsiString;

           IncludeUtext:TUtextFile;
           IncludeUlex:TUlex1;

           Ligne,Colonne:integer;
           Rchar: AnsiChar;

         public
           constructor create(List:TUgetText);
           destructor destroy;override;
           procedure lire(var stMot:shortString;
                            var tp0;
                            var x:float;
                            var error:Integer);

           procedure lireIgnore
                           (var stMot:shortString;
                            var tp0;
                            var x:float;
                            var error:Integer);

           procedure getLastPos(var lig,col:integer;var stFile:AnsiString);
         end;

{ Ulex1 décode essentiellement les nombres non signés, les chaînes, les
  identificateurs et les symboles principaux.
  stMot est le mot extrait de buf.
  Un mot commence par une lettre ou @ suivie de chiffres, de lettres ou du
  caractère '_'.

  Ulex1 écarte aussi les commentaires encadrés par les accolades ou parenthèses-étoile.

  x contient le nombre décodé ( nbi, nbL ou nbR )
  error est le code d'erreur.
  Les codes d'erreur possibles sont
    0: pas d'erreur
    1: Identificateur trop long
    2: Nombre réel hors limites
    3: Caractère inconnu
    4: chaîne trop longue

    10:erreur fichier inclus


}


IMPLEMENTATION



const
  carfin=#26;


const
  maxchaineCar=250;
  longueurNom=250;

const
  chiffre:set of AnsiChar=['0'..'9'];
  chiffreHexa:set of AnsiChar=['0'..'9','A'..'F','a'..'f'];

  lettre:set of AnsiChar=['a'..'z','A'..'Z','_'];



{ ************************************************************************** }
{ ********************* ANALYSEUR LEXICAL ********************************** }
{ ************************************************************************** }


procedure TUlex1.lire(var stMot:shortString;
                  var tp0;
                  var x:float;
                  var error:Integer);

var
  tp:typeLex ABSOLUTE tp0;
  c,c1:Ansichar;
  st0:shortString;
  code:integer;
  fin,flag,flag1,flag2,finCom:boolean;
  nbdigit:integer;
  w:integer;
  stN:AnsiString;

  function lireChar:AnsiChar;
  begin
    if Rchar<>#0 then result:=Rchar
    else
    if stList.eof and (colonne>=length(st0list)) then result:=carfin
    else
    begin
      inc(colonne);
      if colonne<=length(st0list) then result:=st0list[colonne]
      else
        begin
          inc(ligne);
          colonne:=0;
          result:=#13;
          if not stList.eof
            then st0List:=stList.NextString
            else st0List:='';
        end;
    end;

    {messageCentral(result);}
    if result=#9 then result:=' ';  { Remplacer tabulation par espace }
    Rchar:=#0;
  end;

  procedure renvoyer;
  begin
    if colonne>0 then dec(colonne)
    else Rchar:=#13;
  end;

  function FindAFile(stF, stParent:AnsiString):AnsiString;
  var
    withPath:boolean;
    st1:AnsiString;
  begin
    withPath:= (pos(':',stF)>0) or (pos('\',stF)>0);
    if withPath and FileExists(stF) then result:=stF
    else
    begin
      st1:=extractFilePath(stParent)+extractFileName(stF);
      if FileExists(st1) then result:=st1
      else result:='';
    end;

  end;

  procedure analyseINC;
  var
    st1:AnsiString;
    nomFinclus:AnsiString;

  begin
    nomFinclus:='';
    repeat
      nomFinclus:=nomFinclus+lireChar;
    until (length(nomFinclus)>=90) or (nomFinclus[length(nomFinclus)]='}');

    if length(nomFinclus)>=90 then
      begin
        repeat c:=lireChar until (c=carfin) or (c='}');
        renvoyer;
      end
    else
      begin
        delete(nomFinclus,length(nomFinclus),1);           { supprimer parenthèse de fin }
        nomFinclus:=FsupespaceDebut(nomFinclus);
        nomFinclus:=FsupespaceFin(nomFinclus);             { supprimer les espaces de début et de fin }

        nomFinclus:= FindAFile(nomFinclus,stList.fileName);

        if nomFinclus='' then
          begin
            error:=10;
            IncludeUlex.free;
            IncludeUlex:=nil;
            IncludeUtext.free;
            IncludeUtext:=nil;
            exit;
          end;

        try
        IncludeUtext:=TUtextFile.create(nomFinclus);
        IncludeUlex:=TUlex1.create(IncludeUtext);
        except
        error:=10;
        IncludeUlex.free;
        IncludeUlex:=nil;
        IncludeUtext.free;
        IncludeUtext:=nil;
        end;
      end;
  end;

begin
  if assigned(includeUlex) then
  begin
     IncludeUlex.lire( stMot, tp, x, error);
     if (tp=finFich) or (error<>0) then
     begin
       IncludeUlex.Free;
       IncludeUlex:=nil;
       IncludeUtext.Free;
       IncludeUtext:=nil;
     end
     else exit;
  end;

  st0:='';
  stMot:='';
  x:=0;
  tp:=vid;
  error:=0;

  repeat
    repeat c:=lireChar until not(c in[' ',#10,#13,#0]);
    
    flag:=(c='{');
    flag1:=false;
    flag2:=false;

    if c='(' then
      begin
        flag1:=(lireChar='*');
        if not flag1 then renvoyer;
      end;

    if c='/' then
      begin
        flag2:=(lireChar='/');
        if not flag2 then renvoyer;
      end;

    if flag or flag1 or flag2 then
      begin
        c:=lireChar;
        if flag and (c='$') then
          begin
            c1:=lireChar;
            if c1<>'}' then
            begin
              c:=lireChar;
              if  ((c1='I') or (c1='i')) and (c=' ') then
                begin
                  analyseINC;
                  if error<>0 then exit;

                  if assigned(includeUlex) then
                  begin
                    IncludeUlex.lire( stMot, tp, x, error);
                    if tp=finFich then
                    begin
                      IncludeUlex.Free;
                      IncludeUlex:=nil;
                      IncludeUtext.Free;
                      IncludeUtext:=nil;
                    end
                    else exit;
                  end;
                end
              else
                begin
                  stMot:=c1+c;
                  while (c<>'}') and (c<>carfin) do
                  begin
                    c:=lireChar;
                    stMot:=stMot+c;
                  end;
                  if c='}' then delete(stMot,length(stMot),1);
                  tp:=directive;
                  exit;
                end;
            end
            else renvoyer;
          end
        else renvoyer;

        finCom:=false;

        repeat
          c:=lireChar;
          if flag and (c='}') then finCom:=true;
          if flag1 and (c='*') then
            begin
              c:=lireChar;
              if c=')' then fincom:=true else renvoyer;
            end;

          if flag2 and (c in [#13,#10]) then
            begin
              c:=lireChar;
              if not (c in [#13,#10]) then renvoyer;
              fincom:=true;
            end;

        until (c=carfin) or finCom;

      end;
  until not (flag or flag1 or flag2);

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
        c:=lireChar;
        if c='=' then tp:=DeuxPointEgal
        else
          begin
            tp:=DeuxPoint;
            renvoyer;
          end;
      end;

    '.':
      begin
        c:=lireChar;
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
                stMot:=stMot+lireChar;
                flag:=(length(stMot)>=maxchaineCar) or
                    (stMot[length(stMot)] in [carfin,#10,#13]);
                if not flag and (stMot[length(stMot)]='''') then
                  begin
                    c:=lireChar;
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
              c:=lireChar;
              stN:='';
              while c in chiffre do
              begin
                stN:=stN+c;
                c:=lireChar;
              end;
              val(stN,w,code);
              stMot:=stMot+chr(w);
              renvoyer;
            end;

          c:=lireChar;
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
          st0:=st0+lireChar;
        until not( st0[length(st0)] in lettre+chiffre );
        renvoyer;
        delete(st0,length(st0),1);
        stMot:=st0;
        if length(st0)>longueurNom then  error:=1;
      end;

    '0'..'9':
      begin
        st0:=c;
        while st0[length(st0)] in chiffre do st0:=st0+lireChar;


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
            st0:=st0+lireChar;
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
            while st0[length(st0)] in chiffre do st0:=st0+lireChar;
          end;

        if (st0[length(st0)]='E') or (st0[length(st0)]='e') then
          begin
            st0:=st0+lireChar;
            if (st0[length(st0)]='+') or (st0[length(st0)]='-') then
              st0:=st0+lireChar;
            while st0[length(st0)] in chiffre do st0:=st0+lireChar;
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
          st0:=st0+lireChar;
          inc(nbDigit);
        until not (st0[length(st0)] in chiffreHexa);

        if nbDigit>9 then
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
        c:=lireChar;
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
        c:=lireChar;
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


procedure TUlex1.lireIgnore(var stMot:shortString;
                            var tp0;
                            var x:float;
                            var error:Integer);
var
  tp:typeLex ABSOLUTE tp0;
  c:Ansichar;

function lireChar:Ansichar;
begin
  if stList.eof and (colonne>=length(st0list)) then result:=carfin
  else
    begin
      inc(colonne);
      if colonne<=length(st0list) then result:=st0list[colonne]
      else
        begin
          inc(ligne);
          colonne:=0;
          result:=' ';
          if not stList.eof
            then st0List:=stList.NextString
            else st0List:='';
        end;
    end;
end;

procedure renvoyer;
  begin
    if colonne>0 then dec(colonne);
  end;

begin
  stMot:='';
  x:=0;
  tp:=vid;
  error:=0;

  repeat
    repeat c:=lireChar until (c='{') or (c=carfin);
    if c='{' then
    begin
      c:=lireChar;
      if (c='$') then
      begin
        c:=lireChar;
        stMot:=c;
        while (c<>'}') and (c<>carfin) do
        begin
          c:=lireChar;
          stMot:=stMot+c;
        end;
        if c='}' then delete(stMot,length(stMot),1);
        supespace(stMot);
        if (Fmaj(stMot)='ELSE') OR (Fmaj(stMot)='ENDIF') then
        begin
          tp:=directive;
          exit;
        end;
      end;
    end;
  until c=carfin;

  if c=carFin then
    begin
      renvoyer;      { Les prochains appels renverront toujours Carfin }
      tp:=FinFich;
      exit;
    end;
end;

constructor TUlex1.create(list:TUgetText);
begin
  stList:=list;
  st0list:='';

  stList.Init;
end;

Destructor TUlex1.destroy;
begin
  IncludeUlex.free;
  IncludeUtext.free;

end;

procedure TUlex1.getLastPos(var lig, col: integer; var stFile: AnsiString);
begin
  if assigned(includeUlex) then IncludeUlex.getLastPos(lig, col, stFile)
  else
  begin
    lig:=ligne;
    col:=colonne;
    stFile:=stList.fileName;
  end;
end;



{ TUTextStringList }

constructor TUTextStringList.create(list: Tstringlist);
begin
  list0:=list;
end;

function TUTextStringList.eof: boolean;
begin
  result:= (line>=list0.count);
end;

function TUTextStringList.fileName: AnsiString;
begin
  result:='';
end;

function TUTextStringList.getPos: integer;
begin
  result:=Fpos;
end;

procedure TUTextStringList.Init;
begin
  inherited;
  line:=0;
  Fpos:=0;
end;

function TUTextStringList.NextString: AnsiString;
begin
  result:='';
  if line<list0.count then
  begin
    result:=list0[line];
    Fpos:=Fpos+length(result);
    inc(line);
  end;
end;

function TUTextStringList.posMax: integer;
begin
  posmax:=length(list0.text);
end;

{ TUtextFile }

constructor TUtextFile.create(stF:AnsiString);
var
  f1:file;
begin
{$IFDEF FPC}

  try
  assignFile(f1,stF);
  reset(f1);
  size:=fileSize(f1);
  closeFile(f1);

  assignFile(f,stF);
  reset(f);
  Fname:=stF;
  except
  Fname:='';
  end;

{$ELSE}
  try
  assignFile(f,stF);
  reset(f);

  size:=fileSize(f);
  Fname:=stF;
  except
  Fname:='';
  end;
{$ENDIF}
end;

destructor TUtextFile.destroy;
begin
  CloseFile(f);
  inherited;
end;

function TUtextFile.eof: boolean;
begin
  result:=  system.eof(f);
end;

function TUtextFile.getPos: integer;
begin
  result:=Fpos;
end;

procedure TUtextFile.Init;
begin
end;

function TUtextFile.NextString: AnsiString;
begin
  if eof then result:=''
  else
    begin
      readln(f,result);
      inc(Fpos,length(result));
    end;
end;

function TUtextFile.posMax: integer;
begin
  result:=size;
end;

function TUtextFile.fileName:AnsiString;
begin
  result:=Fname;
end;



end.
