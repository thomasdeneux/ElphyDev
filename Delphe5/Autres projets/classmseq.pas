UNIT classmseq;
(*
  Auteur Yann LE GUENNO
  Version objet
  Date: 08/03/99
*)

INTERFACE

type
 vectap = array[8..16] of byte;
 vec  = array[0..65535] of word;
 Pvec = ^vec;
(* Définition de la classe Tmseq, avec ses attributs et méthodes *)
 Tmseq = class
         public
          n : byte; //de 1 à 16
          R : Pvec; //vecteur des valeurs de la mseq
          T : byte; //feedback tap, déterminé par n
          l : word; //au max (lgueur de la mseq)-1, 2^16-1=65535 au plus
          constructor create(b:byte);
          procedure calcul;
         private
          q,masque : word; //pour les manipulations de bit
          function deuxpuiss(a:byte) : cardinal;
         end; //fin classe

var
 valtap : vectap; //valeurs possibles du feedback tap (voir initializaion)
 mseq : Tmseq;
 
IMPLEMENTATION
(* constructeur *)
constructor Tmseq.create(b:byte);
 var
   toto : cardinal;

 begin
   //inherited create;
   n:=b;
   T:=valtap[n];
   toto:=self.deuxpuiss(n)-1;
   l:=word (toto);
   masque:=l;
   toto:=self.deuxpuiss(n-1);
   q:=word (toto);
   GetMem(R,l*sizeof(word));
   R^[0]:=1;
 end;

(* fonction calculant 2^a *)
function Tmseq.deuxpuiss;
 var
   k    : integer;
   calc : cardinal; (* intermédiaire de calcul *)

 begin
   calc:=1;
   for k:=1 to a do calc:=2*calc;
   deuxpuiss:=calc;
 end;
(* fin fonction *)

(* calcul de la mseq *)
procedure Tmseq.calcul;
 var
   i        : cardinal;
   x1,x2,x3 : word;    (* intermédiaires de calcul pour affecter R *)

 begin
   for i:=1 to l do
                 begin
                   x1:=R^[i-1];
                   x2:=x1 shl 1;
                   if (x1 and q)<>q then x3:= (x2 and masque)
                                    else x3:= (x2 and masque) xor T;
                                    R^[i]:=x3;
                 end;
 end;

(* valeurs possibles du feedback tap *)
initialization
//valeurs déterminées d'après test
valtap[8]:=29;
valtap[9]:=17;
valtap[10]:=9;
valtap[11]:=5;
valtap[12]:=83;
valtap[13]:=27;
valtap[14]:=43;
valtap[15]:=3;
valtap[16]:=45;

 (* fin unité *)
end.
