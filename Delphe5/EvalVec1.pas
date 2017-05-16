unit EvalVec1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1, stmvec1,
     IPPdefs17,IPPS17;


{ Tevalvec est sensé accélérer les calculs vectoriels en simplifiant l'écriture des routines IPPS.

  Bien souvent, on obtient une amélioration d'un facteur 2 pour une suite d'opérations, ce qui est
  plutôt décevant. 
}

type

  TevalVec=class
           private
             Nbpt:integer;
             Vec:array of Tvector;

           public
             constructor create(Nb:integer);
             destructor destroy;override;

             function v(n:integer):Tvector;
             function v1:Tvector;
             function v2:Tvector;
             function v3:Tvector;
             function v4:Tvector;
             function v5:Tvector;
             function v6:Tvector;
             function v7:Tvector;
             function v8:Tvector;
             function v9:Tvector;
             function v10:Tvector;
             function v11:Tvector;
             function v12:Tvector;


             procedure freeVectors;

             procedure thresh(src,dest:Tvector);overload;
             procedure thresh(dest:Tvector);overload;

             {Copie}
             procedure copy(src,dest:Tvector);overload;
             procedure copy(src:double;dest:Tvector);overload;

             {Addition}
             procedure Add(src1,src2,dest:Tvector);overload;
             procedure Add(src1:double;src2,dest:Tvector);overload;
             procedure Add(src1:Tvector;src2:double;dest:Tvector);overload;

             {Soustraction src1 - src2 }
             procedure Sub(src1,src2,dest:Tvector);overload;
             procedure Sub(src1:double;src2,dest:Tvector);overload;
             procedure Sub(src1:Tvector;src2:double;dest:Tvector);overload;

             {Multiplication src1 * src2 }
             procedure Mul(src1,src2,dest:Tvector);overload;
             procedure Mul(src1:double;src2,dest:Tvector);overload;
             procedure Mul(src1:Tvector;src2:double;dest:Tvector);overload;

             {Division src1 / src2 }
             procedure Divide(src1,src2,dest:Tvector);overload;
             procedure Divide(src1:double;src2,dest:Tvector);overload;
             procedure Divide(src1:Tvector;src2:double;dest:Tvector);overload;

             {Décalage à droite}
             procedure shiftR(src:Tvector;n:integer;dest:Tvector);
           end;

implementation


{ TevalVec }

constructor TevalVec.create(Nb: integer);
begin
  Nbpt:=Nb;
end;

destructor TevalVec.destroy;
begin
  inherited;
end;

function TevalVec.v(n: integer): Tvector;
var
  old:integer;
begin
  if n>=length(vec) then
  begin
    old:=length(vec);
    setLength(vec,n+1);
    fillchar(vec[old],(n+1-old)*sizeof(pointer),0);
  end;
  if not assigned(vec[n]) then vec[n]:=Tvector.create32(g_double,1,nbpt,false);
  result:=vec[n];
end;

function TevalVec.v1: Tvector;
begin
  result:=v(1);
end;

function TevalVec.v10: Tvector;
begin
  result:=v(10);
end;

function TevalVec.v11: Tvector;
begin
  result:=v(11);
end;

function TevalVec.v12: Tvector;
begin
  result:=v(12);
end;

function TevalVec.v2: Tvector;
begin
  result:=v(2);
end;

function TevalVec.v3: Tvector;
begin
  result:=v(3);
end;

function TevalVec.v4: Tvector;
begin
  result:=v(4);
end;

function TevalVec.v5: Tvector;
begin
  result:=v(5);
end;

function TevalVec.v6: Tvector;
begin
  result:=v(6);
end;

function TevalVec.v7: Tvector;
begin
  result:=v(7);
end;

function TevalVec.v8: Tvector;
begin
  result:=v(8);
end;

function TevalVec.v9: Tvector;
begin
  result:=v(9);
end;


procedure TevalVec.freeVectors;
var
  i:integer;
begin
  for i:=0 to high(vec) do vec[i].free;
  setlength(vec,0);
end;

{Copie}
procedure TevalVec.copy(src, dest: Tvector);
begin
  ippsmove_64f(src.tbD,dest.tbD,nbpt);
end;

procedure TevalVec.copy(src: double; dest: Tvector);
begin
  ippsSet_64f(src,dest.tbD,nbpt);
end;

{Addition}
procedure TevalVec.Add(src1, src2, dest: Tvector);
begin
  if src1=dest then ippsAdd_64f_I(src2.tbD,dest.tbD,nbpt)
  else
  if src2=dest then ippsAdd_64f_I(src1.tbD,dest.tbD,nbpt)
  else
  ippsAdd_64f(src1.tbD,src2.tbD,dest.tbD,nbpt);
end;

procedure TevalVec.Add(src1: double; src2, dest: Tvector);
begin
  if src2<>dest then ippsmove_64f(src2.tbD,dest.tbD,nbpt);
  ippsAddC_64f_I(src1,dest.tbD,nbpt);
end;

procedure TevalVec.Add(src1: Tvector; src2: double; dest: Tvector);
begin
  if src1<>dest then ippsmove_64f(src1.tbD,dest.tbD,nbpt);
  ippsAddC_64f_I(src2,dest.tbD,nbpt);
end;


{Soustraction}
procedure TevalVec.Sub(src1, src2, dest: Tvector);
begin
  if src1=dest then ippsSub_64f_I(src2.tbD,dest.tbD,nbpt)
  else
  if src2=dest then
    begin
      ippsSub_64f_I(src1.tbD,dest.tbD,nbpt);   {on obtient l'opposé 2-1}
      ippsMulC_64f_I(-1,dest.tbD,nbpt);        {multiplier par -1 }
    end
  else
  ippsSub_64f(src2.tbD,src1.tbD,dest.tbD,nbpt);
end;

procedure TevalVec.Sub(src1: double; src2, dest: Tvector);
begin
  if src2<>dest then ippsmove_64f(src2.tbD,dest.tbD,nbpt); {copier 2 dans dest}
  ippsmulC_64f_I(-1,dest.tbD,nbpt);                          {prendre l'oposé de dest}
  ippsAddC_64f_I(src1,dest.tbD,nbpt);                        {ajouter 1 }
end;

procedure TevalVec.Sub(src1: Tvector; src2: double; dest: Tvector);
begin
  if src1<>dest then ippsmove_64f(src1.tbD,dest.tbD,nbpt);
  ippsAddC_64f_I(-src2,dest.tbD,nbpt);
end;

{Multiplication}
procedure TevalVec.Mul(src1, src2, dest: Tvector);
begin
  if src1=dest then ippsMul_64f_I(src2.tbD,dest.tbD,nbpt)
  else
  if src2=dest then ippsMul_64f_I(src1.tbD,dest.tbD,nbpt)
  else
  ippsMul_64f(src1.tbD,src2.tbD,dest.tbD,nbpt);
end;

procedure TevalVec.Mul(src1: double; src2, dest: Tvector);
begin
  if src2<>dest then ippsmove_64f(src2.tbD,dest.tbD,nbpt);
  ippsMulC_64f_I(src1,dest.tbD,nbpt);
end;

procedure TevalVec.Mul(src1: Tvector; src2: double; dest: Tvector);
begin
  if src1<>dest then ippsmove_64f(src1.tbD,dest.tbD,nbpt);
  ippsMulC_64f_I(src2,dest.tbD,nbpt);
end;


{Division}
procedure TevalVec.Divide(src1, src2, dest: Tvector);
var
  Vdum:array of double;
begin
  if src1=dest then ippsDiv_64f_I(src2.tbD,dest.tbD,nbpt)
  else
  if src2=dest then
    begin
      setlength(Vdum,nbpt);
      ippsDiv_64f(dest.tbD,src1.tbD,@Vdum[0],nbpt);  {Calcul dans Vdum}
      ippsMove_64f(@Vdum[0],dest.tbD,nbpt);          {Copier dans Dest}
    end
  else
  ippsDiv_64f(src2.tbD,src1.tbD,dest.tbD,nbpt);
end;

procedure TevalVec.Divide(src1: double; src2, dest: Tvector);
var
  Vdum:array of double;
begin
  setLength(Vdum,Nbpt);
  ippsSet_64f(src1,@Vdum[0],nbpt);            { src1 dans Vdum }
  ippsdiv_64f_I(src2.tbD,@Vdum[0],nbpt);        { diviser par src2 }
  ippsMove_64f(@Vdum[0],dest.tbD,nbpt);       { copier dans dest }
end;

procedure TevalVec.Divide(src1: Tvector; src2: double; dest: Tvector);
begin
  if src1<>dest then ippsmove_64f(src1.tbD,dest.tbD,nbpt);
  ippsMulC_64f_I(1/src2,dest.tbD,nbpt);
end;

{ threshold à zéro }
procedure TevalVec.thresh(src, dest: Tvector);
begin
  ippsThreshold_LT_64f(src.tbD,dest.tbD,nbpt,0)
end;

procedure TevalVec.thresh(dest: Tvector);
begin
  ippsThreshold_LT_64f_I(dest.tbD,nbpt,0)
end;


{ Décalage à droite}
procedure Tevalvec.shiftR(src:Tvector;n:integer;dest:Tvector);
begin
  if n>0 then
  begin
    ippsmove_64f(src.tbD, @PtabDouble(dest.tbD)^[n],nbpt-n);
    ippsZero_64f(dest.tbD,n);
  end
  else
  if n<0 then
  begin
    n:=-n;
    ippsmove_64f(@PtabDouble(src.tbD)^[n],dest.tbD, nbpt-n);
    ippsZero_64f(Pdouble(@PtabDouble(dest.tbD)^[nbpt-1-n]),n);
  end;
end;


end.
