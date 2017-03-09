unit Darbre0;
INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses classes, util1,debug0 ;

const
  longvar=20;
  maxVar=50;

  chiffre:set of Ansichar=['0'..'9'];
  lettre:set of Ansichar=['a'..'z','A'..'Z','_'];

  Aerror:integer=0;

type
  tabNom=array[1..maxVar] of string[longvar];
  tabVal=array[1..maxvar] of float;


  typeFonc1=function(x:float):float;

  typgenre=(op,nbr,vari,fonc);
  ptelem=^typelem ;
  typelem=record
            case genre:typgenre of
               op:(g,d:ptelem;opnom:Ansichar);
               nbr:(vnbr:float);
               vari:(num:byte);
               fonc:(f:typeFonc1;arg:ptelem);
            end;


procedure CreerArbre(var rac:ptelem;chdef:AnsiString;var pc:integer;
          var nomVar:tabNom;var n:integer);
       { pc et n doivent être initialisés avant l'appel }

procedure DetruireArbre(var rac:ptelem);

procedure affarbre0(var f:text;var rac:ptelem;var nomVar:tabnom);

Function evaluer(var rac:ptelem;var valeur:tabval):float;

Function derivee(rac:ptelem;num:integer):ptelem;

procedure simplifier(var r:ptelem);

procedure VerifierExpression(var st:AnsiString;var pc:integer;var error:integer);
  { pc doit être initialisé }

procedure VerifierEgalite(st:AnsiString;var pc:integer;var error:integer;
                          var st1:AnsiString);

function numeroVariable(st:AnsiString;
               var nomVar:tabnom;var n:integer):byte;

procedure verifierListe(list:TstringList;var lig,col,error:integer);
procedure CreerArbreListe(var rac:ptelem;texte:TstringList;
                          var nomVar:tabNom;var nbvar:integer);

IMPLEMENTATION

const
  ensop:set of Ansichar=['(',')','+','-','*','/','^'];

  opad:set of Ansichar=['+','-'];
  opmult:set of Ansichar=['*','/'];



var
  FunctionList:TstringList;

  numVar:byte;        { sert pour derivee }
  PlusDeSimp:boolean; { sert pour simplifier }


function Fabs(x:float):float;
  begin
    Fabs:=abs(x);
  end;

function Fnul(x:float):float;
  begin
    Fnul:=0;
  end;

function Fsin(x:float):float;
  begin
    Fsin:=sin(x);
  end;

function Fcos(x:float):float;
  begin
    Fcos:=cos(x);
  end;

function Farctg(x:float):float;
  begin
    Farctg:=arctan(x);
  end;

function Fexp(x:float):float;
  begin
    if abs(x)<690 then Fexp:=exp(x)
    else
      begin
        if x<0 then Fexp:=1E-300
               else Fexp:=1E300;
        Aerror:=205;
      end;
  end;

function Flog(x:float):float;
  begin
    if x>0 then Flog:=ln(x)
    else
      begin
        Flog:=-1E300;
        Aerror:=206;
      end;
  end;

function Ffrac(x:float):float;
  begin
    Ffrac:=frac(x);
  end;

function Fint(x:float):float;
  begin
    Fint:=int(x);
  end;

function Fsqr(x:float):float;
  begin
    Fsqr:=sqr(x);
  end;

function Fsqrt(x:float):float;
  begin
    if x>=0 then Fsqrt:=sqrt(x)
    else
      begin
        Fsqrt:=0;
        Aerror:=207;
      end;
  end;

function Ftg(x:float):float;
  var
    y:float;
  begin
    y:=x/pi-0.5;
    y:=x+pi*(0.5+trunc(y));
    if abs(y)>1E-19
      then Ftg:=sin(x)/cos(x)
    else
      begin
        Ftg:=0;
        Aerror:=208;
      end;
  end;

function Fcotg(x:float):float;
  var
    y:float;
  begin
    y:=x/pi;
    y:=x+pi*(trunc(y));
    if abs(y)>1E-300
      then Fcotg:=cos(x)/sin(x)
    else
      begin
        Fcotg:=0;
        Aerror:=209;
      end;
  end;


function Farcsin(x:float):float;
  begin
    if abs(x)<1E-300 then Farcsin:=0
    else
    if abs(x)<=1
      then Farcsin:=2*arctan( (1-sqrt(1-sqr(x)))/x)
    else
      begin
        Farcsin:=0;
        Aerror:=210;
      end;
  end;

function Farccos(x:float):float;
  begin
    if abs(x)<=1 then
      begin
        if x<-1+1E-19 then Farccos:=pi
        else
        Farccos:=2*arctan((1-x)/(1+x));
      end
    else
      begin
        Farccos:=0;
        Aerror:=211;
      end
  end;

function Farccotg(x:float):float;
  begin
    if abs(x)<1E-300 then Farccotg:=Pi/2
    else
      begin
        Farccotg:=arctan(1/x);
        if x<0 then x:=x+pi;
      end;
  end;

function Fsh(x:float):float;
  begin
    if abs(x)<690 then Fsh:=0.5*(exp(x)-exp(-x))
    else
      begin
        Fsh:=0;
        Aerror:=212;
      end;
  end;

function Fch(x:float):float;
  begin
    if abs(x)<690 then Fch:=0.5*(exp(x)+exp(-x))
    else
      begin
        Fch:=0;
        Aerror:=213;
      end;
  end;

function Fth(x:float):float;
  begin
    if abs(x)<690
      then Fth:=(exp(x)-exp(-x))/(exp(x)+exp(-x))
    else
      begin
        Fth:=0;
        Aerror:=213;
      end;
  end;

function Fcoth(x:float):float;
  begin
    if abs(x)<1E-19 then
      begin
        Fcoth:=0;
        Aerror:=213;
      end
    else
    if x<-690 then Fcoth:=-1
    else
    if x>690 then Fcoth:=1
    else Fcoth:=(exp(x)+exp(-x))/(exp(x)-exp(-x));
  end;



procedure InitFonction1;
  begin
    FunctionList:=Tstringlist.create;
    with FunctionList do
    begin
      addObject( 'ABS'    ,Tobject(@Fabs));
      addObject( 'ARCTAN' ,Tobject(@Farctg));
      addObject( 'ARCTG'  ,Tobject(@Farctg));
      addObject( 'COS'    ,Tobject(@Fcos));
      addObject( 'EXP'    ,Tobject(@Fexp));
      addObject( 'FRAC'   ,Tobject(@Ffrac));
      addObject( 'INT'    ,Tobject(@Fint));
      addObject( 'LN'     ,Tobject(@Flog));
      addObject( 'LOG'    ,Tobject(@Flog));
      addObject( 'SIN'    ,Tobject(@Fsin));
      addObject( 'SQR'    ,Tobject(@Fsqr));
      addObject( 'SQRT'   ,Tobject(@Fsqrt));
      addObject( 'TG'     ,Tobject(@Ftg));
      addObject( 'TAN'    ,Tobject(@Ftg));
      addObject( 'COTG'   ,Tobject(@Fcotg));
      addObject( 'COTAN'  ,Tobject(@Fcotg));
      addObject( 'ARCSIN' ,Tobject(@Farcsin));
      addObject( 'ARCCOS' ,Tobject(@Farccos));
      addObject( 'ARCCOTG',Tobject(@Farccotg));
      addObject( 'SH'     ,Tobject(@Fsh));
      addObject( 'CH'     ,Tobject(@Fch));
      addObject( 'TH'     ,Tobject(@Fth));
      addObject( 'COTH'   ,Tobject(@Fcoth));
    end;
  end;



function ecrireel(x:float):AnsiString;

var
   i:integer;
   ch:AnsiString;
begin
   if x=0 then begin ecrireel:='0';exit;end;

   if (x<-1e10) or ((x>-1e-10) and (x<1E-10)) or (x>1E+10) then
     begin
      str(x,ch);
      delete(ch,1,1);
      if x>=0 then delete(ch,1,1);
      i:=pos('E',ch)-1;
      while ch[i] in ['0','.'] do
        begin
          delete(ch,i,1);
          i:=i-1;
        end;
     end
   else
     begin
      str(x:0:10,ch);
      if pos('.',ch)<>0 then
        begin
          i:=length(ch);
          while ch[i] = '0' do
            begin
              delete(ch,i,1);
              i:=i-1;
            end;
          if ch[i]='.' then delete(ch,i,1);
        end;
     end;
   ecrireel:=ch;
end;




function numeroVariable(st:AnsiString;
               var nomVar:tabnom;var n:integer):byte;
  var
    i:integer;
  begin
    for i:=1 to n do
      if (nomvar[i]=st) then
        begin
          numeroVariable:=i;
          exit;
        end;
    inc(n);
    nomvar[n]:=st;
    numeroVariable:=n;
  end;

function numeroFonction1(st:AnsiString):pointer;
  var
    i:integer;
  begin
    st:=Fmaj(st);
    with functionList do
    begin
      i:=indexof(st);
      if i>=0
        then numeroFonction1:=objects[i]
        else NumeroFonction1:=@Fnul;
    end;
  end;

function NomFonc1(f1:typeFonc1):AnsiString;
  var
    i:integer;
  begin
    with functionList do
    begin
      i:=indexofObject(@f1);
      if i>=0
        then nomFonc1:=strings[i]
        else NomFonc1:='NUL';
    end;
  end;



procedure CreerArbre(var rac:ptelem;chdef:AnsiString;var pc:integer;
          var nomVar:tabnom;var n:integer);
  var
    i:integer;
    st:AnsiString;


  function lirenb:float;
    var
      st1:AnsiString;
      x:float;
      code:integer;
    begin
      st1:='';
      while chdef[pc]  in chiffre+['E','.'] do
         begin
            st1:=st1+chdef[pc];
            inc(pc);
            if (chdef[pc-1]='E') AND (chdef[pc] in opad) then
              begin
                st1:=st1+chdef[pc];
                inc(pc);
              end;
         end;
      val(st1,x,code);
      lirenb:=x;
    end;

  function liremot:AnsiString;
    var
      st1:AnsiString;
    begin
      st1:=chdef[pc];
      inc(pc);
      while chdef[pc] in lettre+chiffre do
         begin
            st1:=st1+chdef[pc];
            inc(pc);
         end;
      liremot:=st1;
    end;

procedure creeelem(var rac:ptelem);forward;

procedure creearb(var rac:ptelem);
  var
    n1,n2,n3,n4,n5,n6,n7:ptelem;

  begin
    n1:=nil;
    n2:=nil;

    if chdef[pc]='+' then inc(pc);
    if chdef[pc]='-' then
      begin
        creeelem(n1);
        creeelem(n2);
        n1^.g:=nil;
        n1^.d:=n2;
      end
    else
    creeelem(n1);

    while true do
      begin
        if chdef[pc]=')' then
          begin
            rac:=n1;exit;
          end;
        creeelem(n2);
        creeelem(n3);

        n2^.g:=n1;
        n2^.d:=n3;
        n1:=n2;

        if not(n2^.opnom in opmult) then
          begin
            if chdef[pc]=')' then
              begin
                rac:=n2;pc:=pc;exit;
              end;
            if (chdef[pc] in opmult) then
              begin
                creeelem(n4);
                creeelem(n5);
                n2^.d:=n4;
                n4^.g:=n3;
                n4^.d:=n5;
                n1:=n2;

                while chdef[pc] in opmult do
                  begin
                    creeelem(n6);
                    creeelem(n7);
                    n6^.g:=n4;
                    n6^.d:=n7;
                    n1^.d:=n6;
                    n4:=n6;
                  end;
              end;
          end;
      end;        (* fin du while *)
   end;               (* fin de creearb *)

procedure creeelem;
   var
      na,nb:ptelem;
   begin
      if chdef[pc]=')' then exit;
      if chdef[pc]='(' then
        begin
          inc(pc);
          creearb(na);
          rac:=na;
        end
      else
      if chdef[pc] in ensop then
        begin
          new(rac);
          with rac^ do
          BEGIN
            genre:=op;
            opnom:=chdef[pc];
          END;
        end
      else
      if chdef[pc] in chiffre+['.'] then
        begin
          new(rac);
          rac^.genre:=nbr;
          rac^.vnbr:=lirenb;
          dec(pc);
        end
      else
      if chdef[pc] in lettre then
        begin
          new(rac);
          st:=liremot;
          if st='PI' then
            begin
              rac^.genre:=nbr;
              rac^.vnbr:=pi;
              dec(pc);
            end
          else
          if chdef[pc]<>'(' then
            begin
              rac^.genre:=vari;
              rac^.num:=NumeroVariable(st,nomvar,n);
              dec(pc);
            end
          else
            begin
              rac^.genre:=fonc;
              @rac^.f:=NumeroFonction1(st);
              inc(pc);
              creearb(na);
              rac^.arg:=na;
            end;
        end;

      inc(pc);
      if chdef[pc]='^' then
         begin
            new(na);  na^.genre:=op;  na^.opnom:='^';
            inc(pc);
            creeelem(nb);
            na^.g:=rac;
            na^.d:=nb;
            rac:=na;
         end;
   end;(*of creeelem *)



  begin
    while pos(' ',chdef)>0 do delete(chdef,pos(' ',chdef),1);
    chdef:=chdef+')))))';
    creearb(rac);
  end;

procedure detruireArbre(var rac:ptelem);
  begin
    if rac<>nil then
      case rac^.genre of
        op: begin
              detruireArbre(rac^.g);
              detruireArbre(rac^.d);
              dispose(rac);
            end;
        fonc:begin
               detruireArbre(rac^.arg);
               dispose(rac);
             end;
        nbr,vari:dispose(rac);
      end;
    rac:=nil;
  end;




procedure affarbre0(var f:text;var rac:ptelem;var nomVar:tabnom);
  begin
    if rac<>nil then
      begin
        case rac^.genre of
          op :begin
                write(f,'(');
                Affarbre0(f,rac^.g,nomvar);
                write(f,')');
                write(f,rac^.opnom);
                write(f,'(');
                Affarbre0(f,rac^.d,nomvar);
                write(f,')');
              end;

          nbr:write(f,ecrireel(rac^.vnbr));

          vari:write(f,nomvar[rac^.num]);

          fonc:begin
                 write(f,NomFonc1(rac^.f));
                 write(f,'(');
                 Affarbre0(f,rac^.arg,nomvar);
                 write(f,')');
               end;
        end;
      end
  end;

Function evaluer(var rac:ptelem; var valeur:tabval):float;
  const
    epsilon=1E-10;
  var
    x,y,z:float;
  begin
    if rac=nil then evaluer:=0
    else
      begin
        case rac^.genre of
          op :begin
                x:=evaluer(rac^.g,valeur);
                y:=evaluer(rac^.d,valeur);
                case rac^.opnom of
                  '+':evaluer:=x+y;
                  '-':evaluer:=x-y;
                  '*':evaluer:=x*y;
                  '/':if y<>0 then evaluer:=x/y
                              else
                                begin
                                  evaluer:=0;
                                  Aerror:=200;
                                end;
                  '^':if x=0 then evaluer:=0
                      else
                      begin
                        z:=y*ln(abs(x));
                        if abs(z)<1419 then
                          begin
                            z:=exp(z);
                            if (x<0) and ( abs(frac(y))<epsilon ) and
                            ( abs(y)<2147483647 ) and ( trunc(y) mod 2=1)
                              then evaluer:=-z
                              else evaluer:=z;
                          end
                        else
                        if z<0 then evaluer:=0
                        else
                        evaluer:=1E300;
                      end;
                end;
              end;

          nbr:evaluer:=rac^.vnbr;

          vari:begin
                 evaluer:=valeur[rac^.num];
               end;

          fonc:begin
                 x:=evaluer(rac^.arg,valeur);
                 evaluer:=rac^.f(x);
               end;
        end;
      end
  end;


function Pnombre(n:float):Ptelem;
  var
    a:ptElem;
  begin
    new(a);
    a^.genre:=nbr;
    a^.vnbr:=n;
    Pnombre:=a;
  end;

function Poppose(r:ptelem):ptelem;
  var
    a:ptelem;
  begin
    if r=nil then Poppose:=nil
    else
    begin
      new(a);
      a^.genre:=op;
      a^.opnom:='-';
      a^.g:=nil;
      a^.d:=r;
      Poppose:=a;
    end;
  end;

function Pcopie(r:ptelem):ptelem;
  var
    a:ptelem;
  begin
    if r=nil then Pcopie:=nil
    else
    begin
      new(a);
      move(r^,a^,sizeof(typelem));
      case r^.genre of
        op: begin
              a^.g:=Pcopie(r^.g);
              a^.d:=Pcopie(r^.d);
            end;
        fonc:a^.arg:=Pcopie(r^.arg);
      end;
      Pcopie:=a;
    end;
  end;


function derivee1(rac:ptelem):ptelem;
  var
    a,b,c,d,e,f:ptelem;
  begin
    if rac=nil then
      begin
        derivee1:=nil;
        exit;
      end;
    case rac^.genre of
      op :case rac^.opnom of
            '+','-':
              begin
                new(a);;
                a^.genre:=op;
                a^.opnom:=rac^.opnom;
                a^.g:=derivee1(rac^.g);
                a^.d:=derivee1(rac^.d);
                derivee1:=a;
              end;
            '*':
              begin
                new(a);new(b);new(c);
                a^.genre:=op;
                a^.opnom:='+';
                a^.g:=b;
                a^.d:=c;

                b^.genre:=op;
                b^.opnom:='*';
                b^.g:=Pcopie(rac^.g);
                b^.d:=derivee1(rac^.d);

                c^.genre:=op;
                c^.opnom:='*';
                c^.g:=derivee1(rac^.g);
                c^.d:=Pcopie(rac^.d);

                derivee1:=a;
              end;
            '/':
              begin
                new(a);new(b);new(c);new(d);new(e);new(f);
                a^.genre:=op;
                a^.opnom:='/';
                a^.g:=b;
                a^.d:=c;

                b^.genre:=op;
                b^.opnom:='-';
                b^.g:=d;
                b^.d:=e;

                c^.genre:=op;
                c^.opnom:='^';
                c^.g:=Pcopie(rac^.d);
                c^.d:=f;

                d^.genre:=op;
                d^.opnom:='*';
                d^.g:=Pcopie(rac^.d);
                d^.d:=derivee1(rac^.g);

                e^.genre:=op;
                e^.opnom:='*';
                e^.g:=Pcopie(rac^.g);
                e^.d:=derivee1(rac^.d);

                f^.genre:=nbr;
                f^.vnbr:=2;

                derivee1:=a;
              end;
            '^':
              if (rac^.d^.genre=nbr) then
              begin
                new(a);new(b);new(c);
                a^.genre:=op;
                a^.opnom:='*';
                a^.d:=derivee1(rac^.g);
                a^.g:=b;
                b^.genre:=op;
                b^.opnom:='*';
                b^.g:=Pcopie(rac^.d);
                b^.d:=c;
                c^.genre:=op;
                c^.opnom:='^';
                c^.g:=Pcopie(rac^.g);
                c^.d:=Pnombre(rac^.d^.vnbr-1);
                derivee1:=a;
              end
              else
              begin
                new(a);new(b);new(c);
                a^.genre:=op;
                a^.opnom:='*';
                a^.g:=Pcopie(rac);

                b^.genre:=op;           {construction de valeur*Log(u)}
                b^.opnom:='*';
                b^.g:=Pcopie(rac^.d);
                b^.d:=c;
                c^.genre:=fonc;
                c^.f:=Flog;
                c^.arg:=Pcopie(rac^.g);

                a^.d:=derivee1(b);
                detruireArbre(b);
                derivee1:=a;
              end;
          end;
      nbr:derivee1:=nil;

      vari:if rac^.num<>numVar
             then derivee1:=nil
             else derivee1:=Pnombre(1);
      fonc:
        begin
          new(a);
          a^.genre:=op;
          a^.opnom:='*';
          a^.g:=derivee1(rac^.arg);
          a^.d:=nil;
          if @rac^.f=@Fabs then
                     begin end
          else
          if @rac^.f=@Farctg then
                     begin
                       a^.opnom:='/';
                       new(b);
                       a^.d:=b;
                       b^.genre:=op;
                       b^.opnom:='+';
                       b^.g:=Pnombre(1);
                       new(c);
                       b^.d:=c;
                       c^.genre:=op;
                       c^.opnom:='^';
                       c^.g:=Pcopie(rac^.arg);
                       c^.d:=Pnombre(2);
                     end
          else
          if @rac^.f=@Fcos then
                     begin
                       new(b);
                       b^.genre:=fonc;
                       b^.f:=Fsin;
                       b^.arg:=Pcopie(rac^.arg);
                       a^.d:=Poppose(b);
                     end
          else
          if @rac^.f=@Fexp then
                     begin
                       a^.d:=Pcopie(rac);
                     end
          else
          if @rac^.f=@Ffrac then
                     begin end
          else
          if @rac^.f=@Fint then
                     begin end
          else
          if @rac^.f=@Flog then
                     begin
                        a^.opnom:='/';
                        a^.d:=Pcopie(rac^.arg)
                      end
          else
          if @rac^.f=@Fsin then
                     begin
                       new(b);
                       b^.genre:=fonc;
                       b^.f:=Fcos;
                       b^.arg:=Pcopie(rac^.arg);
                       a^.d:=b;
                     end
          else
          if @rac^.f=@Fsqr then
                     begin
                       new(b);
                       a^.d:=b;
                       b^.genre:=op;
                       b^.opnom:='*';
                       b^.g:=Pnombre(2);
                       b^.d:=Pcopie(rac^.arg);
                     end
          else
          if @rac^.f=@Fsqrt then
                     begin
                       a^.opnom:='/';
                       new(b);
                       b^.genre:=op;
                       b^.opnom:='*';
                       b^.g:=Pnombre(2);
                       b^.d:=Pcopie(rac);
                       a^.d:=b;
                     end;

          derivee1:=a;
        end;            {of fonc}
      end
  end;

function derivee(rac:ptelem;num:integer):ptelem;
  begin
    numVar:=num;
    derivee:=derivee1(rac);
    simplifier(rac);
  end;


function Pegal(r1,r2:ptelem):boolean;
  begin
    Pegal:=false;
  end;


procedure simplifier1(var r:ptelem);
  var
    sg,sd:ptelem;
  begin
    if r=nil then exit;
    case r^.genre of
      nbr:if r^.vnbr=0 then
            begin
              dispose(r);
              r:=nil;
              PlusDeSimp:=false;
            end;
      op:begin
           simplifier1(r^.g);
           simplifier1(r^.d);
           sg:=r^.g;
           sd:=r^.d;

           case r^.opnom of
             '+':if sg=nil then         { 0+x=x }
                   begin
                     dispose(r);
                     r:=sd;
                     PlusDeSimp:=false;
                   end
                 else
                 if sd=nil then         { x+0=x }
                   begin
                     dispose(r);
                     r:=sg;
                     PlusDeSimp:=false;
                   end;
             '-':if sd=nil then         { x-0=x }
                   begin
                     dispose(r);
                     r:=sg;
                     PlusDeSimp:=false;
                   end
                 else
                 if Pegal(sd,sg) then   { x-x=0 }
                   begin
                     detruireArbre(r);
                     r:=nil;
                     PlusDeSimp:=false;
                   end
                 else
                 if (sg=nil) and (sd^.genre=op) and (sd^.opnom='-') and
                 (sd^.g=nil) then
                   begin                { -(-x)=x }
                     dispose(r);
                     r:=sd^.d;
                     dispose(sd);
                     PlusDeSimp:=false;
                   end;
             '*':if sd=nil then         { x*0=0 }
                   begin
                     dispose(r);
                     detruireArbre(sg);
                     r:=nil;
                     PlusDeSimp:=false;
                   end
                 else
                 if sg=nil then         { 0*x=0 }
                   begin
                     dispose(r);
                     detruireArbre(sd);
                     r:=nil;
                     PlusDeSimp:=false;
                   end
                 else
                 if (sd^.genre=nbr) and (sd^.vnbr=1) then
                   begin
                     dispose(r);        { x*1=x }
                     dispose(sd);
                     r:=sg;
                     PlusDeSimp:=false;
                   end
                 else
                 if (sg^.genre=nbr) and (sg^.vnbr=1) then
                   begin
                     dispose(r);        { 1*x=x }
                     dispose(sg);
                     r:=sd;
                     PlusDeSimp:=false;
                   end;
             '/':if sg=nil then         { 0/x=0 }
                   begin
                     dispose(r);
                     detruireArbre(sd);
                     r:=nil;
                     PlusDeSimp:=false;
                   end
                 else
                 if Pegal(sd,sg) then
                   begin                { x/x=1 }
                     detruirearbre(sd);
                     detruirearbre(sg);
                     dispose(r);
                     r:=Pnombre(1);
                     PlusDeSimp:=false;
                   end;
             '^':if sd=nil then         { x^0=1 }
                   begin
                     dispose(r);
                     detruireArbre(sg);
                     r:=Pnombre(1);
                     PlusDeSimp:=false;
                   end
                 else
                 if (sd^.genre=nbr) and (sd^.vnbr=1) then
                   begin                { x^1=x }
                     dispose(r);
                     dispose(sd);
                     r:=sg;
                     PlusDeSimp:=false;
                   end
                 else
                 if (sg^.genre=nbr) and (sg^.vnbr=1) then
                   begin                { 1^x=1 }
                     detruirearbre(r);
                     r:=Pnombre(1);
                     PlusDeSimp:=false;
                   end;
           end; { of case r^.opnom }
         end; { of op }
      fonc:
         begin
           sd:=r^.arg;
           if @r^.f=@Fcos then
                 if (sd^.genre=nbr) and (sd^.vnbr=0) then
                       begin
                         detruirearbre(r);
                         r:=Pnombre(1);
                         PlusDeSimp:=false;
                       end
           else
           if @r^.f=@Fexp then
                if (sd^.genre=nbr) and (sd^.vnbr=0) then
                       begin
                         detruirearbre(r);
                         r:=Pnombre(1);
                         PlusDeSimp:=false;
                       end
           else
           if @r^.f=@Fsin then
                if (sd^.genre=nbr) and (sd^.vnbr=0) then
                       begin
                         detruirearbre(r);
                         r:=nil;
                       end

         end;  {of fonc }
    end; { of case r^.genre }
  end; { of simplifier }

procedure simplifier(var r:ptelem);
  begin
    repeat
      PlusDeSimp:=true;
      simplifier1(r);
    until plusDeSimp;
  end;


procedure VerifierExpression(var st:AnsiString;var pc:integer;var error:integer);
  var
    nbPar:integer;
    st1,st2:AnsiString;

  procedure verifierExp;forward;
  procedure verifierTerme;forward;

  procedure lire;
    begin
      repeat
        if pc<length(st)
          then inc(pc)
          else
            begin
              error:=1;
              exit;
            end;
      until st[pc]<>' ';
    end;

  procedure VerifierNombre;
    begin
      while (st[pc] in chiffre) and (error=0) do lire;
      if error>0 then exit;
      if st[pc]='.' then
        begin
          lire;if error>0 then exit;
          if not (st[pc] in chiffre) then
            begin
              error:=4;
              exit;
            end;
          while (st[pc] in chiffre) and (error=0) do lire;
          if error>0 then exit;
        end;
      if (st[pc]='E') or (st[pc]='e') then
        begin
          lire;if error>0 then exit;
          if st[pc] in opAd then lire;
          if error>0 then exit;
          if not (st[pc] in chiffre) then
            begin
              error:=5;
              exit;
            end;
          while (st[pc] in chiffre) and (error=0) do lire;
          if error>0 then exit;
        end;
    end;

  procedure VerifierVarFonc;
    var
      stF:AnsiString;
    begin
      stF:='';
      while (st[pc] in lettre+chiffre) and (error=0) do
        begin
          stF:=stF+st[pc];
          lire;
        end;
      if error>0 then exit;
      if st[pc]='(' then
        begin
          if numeroFonction1(stF)=@Fnul then
            begin
              error:=10;
              exit;
            end;
          inc(nbpar);
          lire;if error>0 then exit;
          verifierExp;
          if error>0 then exit;
          if st[pc]=')' then
            begin
              dec(nbpar);
              lire;if error>0 then exit;
            end
          else
            begin
              error:=6;
              exit;
            end;
        end;
    end;


  procedure VerifierTerme;
    begin
      if error>0 then exit;
      if st[pc] in chiffre then verifierNombre
      else
      if st[pc] in lettre then verifierVarFonc
      else
      if st[pc]='(' then
        begin
          inc(nbpar);
          lire;if error>0 then exit;
          verifierExp;
          if error>0 then exit;
          if st[pc]<>')' then
            begin
              error:=2;
              exit;
            end;
          dec(nbpar);
          lire;if error>0 then exit;
        end
      else
        begin
          error:=3;
          exit;
        end;

      if st[pc]='^' then
        begin
          lire;if error>0 then exit;
          verifierTerme;
        end;
    end;

  procedure VerifierExp;
    begin
      if error>0 then exit;
      if st[pc] in opAd then lire;
      if error>0 then exit;

      while true do
      BEGIN
        verifierTerme;
        if error=1 then
          begin
            error:=0;
            exit;
          end;
        if error>0 then exit;
        if st[pc] in opAd+opMult  then
          begin
            lire;
            if error>0 then exit;
          end
        else
        if Not( (st[pc]=')') or (pc=length(st)) ) then
          begin
            error:=7;
            exit;
          end
        else exit;
      END;
    end;



  begin
    dec(pc);
    error:=0;
    nbPar:=0;
    lire;
    verifierExp;
    if ( error=0 ) and (nbpar<>0) then error:=10;
    st1:=copy(st,pc+1,length(st)-pc);
    while pos(' ',st1)>0 do delete(st1,pos(' ',st1),1);
    if ( error=0 ) and ( st1<>'') then error:=11;
    st2:=st;
    while pos(' ',st2)>0 do delete(st2,pos(' ',st2),1);
    if st2='' then
      begin
        error:=0;
        pc:=1;
      end;
  end;

procedure VerifierEgalite(st:AnsiString;var pc:integer;var error:integer;
                          var st1:AnsiString);

  procedure lire;
    begin
      repeat
        if pc<length(st)
          then inc(pc)
          else
            begin
              error:=100;
              exit;
            end;
      until st[pc]<>' ';
    end;

  begin
    st1:='';
    error:=0;
    dec(pc);
    lire;
    if error>0 then
      begin
        if pc=0 then pc:=1;
        exit;
      end;
    if Not (st[pc] in lettre) then
      begin
        error:=101;
        exit;
      end;

    lire;
    while (st[pc] in lettre+chiffre) and (error=0) do lire;
    if pc>0 then st1:=copy(st,1,pc-1) else st1:='';
    while pos(' ',st1)>0 do delete(st1,pos(' ',st1),1);

    if Not (st[pc]='=') then
      begin
        error:=102;
        exit;
      end;

    lire;
    verifierExpression(st,pc,error);
  end;

{**************************************************************************}

procedure CreerArbre1(var rac:ptelem;chdef:AnsiString;var pc:integer;
          var nomVar:tabnom;var nbvar:integer;
          exp:TstringList);
  var
    i:integer;
    st:AnsiString;


  function getExp(st1:AnsiString):ptElem;
  var
    i:integer;
  begin
    getExp:=nil;
    i:=exp.indexof(st1);
    if i>=0
      then getExp:=Pcopie(ptElem(exp.objects[i]))
      else getExp:=nil;
  end;

  function lirenb:float;
    var
      st1:AnsiString;
      x:float;
      code:integer;
    begin
      st1:='';
      while chdef[pc]  in chiffre+['E','.'] do
         begin
            st1:=st1+chdef[pc];
            inc(pc);
            if (chdef[pc-1]='E') AND (chdef[pc] in opad) then
              begin
                st1:=st1+chdef[pc];
                inc(pc);
              end;
         end;
      val(st1,x,code);
      lirenb:=x;
    end;

  function liremot:AnsiString;
    var
      st1:AnsiString;
    begin
      st1:=chdef[pc];
      inc(pc);
      while chdef[pc] in lettre+chiffre do
         begin
            st1:=st1+chdef[pc];
            inc(pc);
         end;
      liremot:=st1;
    end;

procedure creeelem(var rac:ptelem);forward;

procedure creearb(var rac:ptelem);
  var
    n1,n2,n3,n4,n5,n6,n7:ptelem;

  begin
    n1:=nil;
    n2:=nil;

    if chdef[pc]='+' then inc(pc);
    if chdef[pc]='-' then
      begin
        creeelem(n1);
        creeelem(n2);
        n1^.g:=nil;
        n1^.d:=n2;
      end
    else
    creeelem(n1);

    while true do
      begin
        if chdef[pc]=')' then
          begin
            rac:=n1;exit;
          end;
        creeelem(n2);
        creeelem(n3);

        n2^.g:=n1;
        n2^.d:=n3;
        n1:=n2;

        if not(n2^.opnom in opmult) then
          begin
            if chdef[pc]=')' then
              begin
                rac:=n2;pc:=pc;exit;
              end;
            if (chdef[pc] in opmult) then
              begin
                creeelem(n4);
                creeelem(n5);
                n2^.d:=n4;
                n4^.g:=n3;
                n4^.d:=n5;
                n1:=n2;

                while chdef[pc] in opmult do
                  begin
                    creeelem(n6);
                    creeelem(n7);
                    n6^.g:=n4;
                    n6^.d:=n7;
                    n1^.d:=n6;
                    n4:=n6;
                  end;
              end;
          end;
      end;        (* fin du while *)
   end;               (* fin de creearb *)

procedure creeelem;
   var
      na,nb:ptelem;
   begin
      if chdef[pc]=')' then exit;
      if chdef[pc]='(' then
        begin
          inc(pc);
          creearb(na);
          rac:=na;
        end
      else
      if chdef[pc] in ensop then
        begin
          new(rac);
          with rac^ do
          BEGIN
            genre:=op;
            opnom:=chdef[pc];
          END;
        end
      else
      if chdef[pc] in chiffre+['.'] then
        begin
          new(rac);
          rac^.genre:=nbr;
          rac^.vnbr:=lirenb;
          dec(pc);
        end
      else
      if chdef[pc] in lettre then
        begin
          st:=liremot;
          if st='PI' then
            begin
              new(rac);
              rac^.genre:=nbr;
              rac^.vnbr:=pi;
              dec(pc);
            end
          else
          if chdef[pc]<>'(' then
            begin
              rac:=getExp(st);
              if rac=nil then
                begin
                  new(rac);
                  rac^.genre:=vari;
                  rac^.num:=NumeroVariable(st,nomvar,nbvar);
                end;
              dec(pc);
            end
          else
            begin
              new(rac);
              rac^.genre:=fonc;
              @rac^.f:=NumeroFonction1(st);
              inc(pc);
              creearb(na);
              rac^.arg:=na;
            end;
        end;

      inc(pc);
      if chdef[pc]='^' then
         begin
            new(na);  na^.genre:=op;  na^.opnom:='^';
            inc(pc);
            creeelem(nb);
            na^.g:=rac;
            na^.d:=nb;
            rac:=na;
         end;
   end;(*of creeelem *)



  begin
    while pos(' ',chdef)>0 do delete(chdef,pos(' ',chdef),1);
    chdef:=chdef+')))))';
    creearb(rac);
  end;



procedure verifierListe(list:TstringList;var lig,col,error:integer);
var
  i:integer;
  st1:AnsiString;
begin
  with list do
  for i:=0 to count-1 do
    begin
      lig:=i+1;
      col:=1;
      verifierEgalite(strings[i],col,error,st1);
      if error<>0 then exit;
    end;
end;


procedure compilerListe(Texte:TstringList;
                        var exp:TstringList;
                        var nomvar:tabnom;
                        var nbvar:integer);
var
  i:integer;
  pc:integer;
  rac:ptElem;
  st,st1:AnsiString;
begin
  fillchar(nomvar,sizeof(nomvar),0);
  nbvar:=0;

  exp.clear;

  with texte do
  for i:=0 to count-1 do
    begin
      st:=Fsupespace(strings[i]);
      pc:=pos('=',st);
      st1:=copy(st,1,pc-1);

      inc(pc);
      CreerArbre1(rac,st,pc,nomVar,nbvar,exp);
      exp.addObject(st1,Tobject(rac));

    end;
end;


procedure CreerArbreListe(var rac:ptelem;texte:TstringList;
                          var nomVar:tabNom;var nbvar:integer);
var
  exp:TstringList;
  i:integer;

  f:text;

begin
  exp:=TstringList.create;
  compilerListe(Texte,exp,nomvar,nbvar);
  for i:=0 to exp.count-2 do
    begin
      rac:=ptElem(exp.objects[i]);
      detruireArbre(rac);
    end;
  rac:=ptElem(exp.objects[exp.count-1]);
  exp.free;

  {
  assign(f,'c:\delphe32\arbre.txt');
  rewrite(f);
  affarbre0(f,rac,nomvar);
  close(f);
  }
end;

Initialization
AffDebug('Initialization Darbre0',0);
initFonction1;

finalization
FunctionList.free;
end.

