unit mpStm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,

  util1,Gdos,procAc1,Dgraphic;

type
  TMhlp = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    modele:TstringList;
    objNames,objAncetre:TstringList;
    ObjProp,ObjMethode:array[0..1000] of TstringList;
    DescriptionObj:array[1..100] of TstringList;
    Constantes:TstringList;
    Procs,groups:TstringList;

    fsource,fdest,fmph:text;
    stLine,stCom,stTexte,stBloc:string;
    directive:char;
    Fcom,FdebutCom,FfinCom:boolean;
    lineNum:integer;

    stGroupe:string;

    nbConst:integer;
    numGroupe:integer;

    description:TstringList;

    currentObj:integer;
    currentSource:string;

    procedure sortieErreur(st:string);
    procedure nextLine;

    procedure nouveauFichier;
    procedure FinFichier;
    procedure nouvellePage(stID,titre:string);
    procedure nouvellePageTableau(stID,titre:string);
    procedure paraLie(st1,st1ID,st2,st2ID,st3,st3ID:string);
    procedure paraTitre(titre,st:string);
    procedure EcrireConstMPH(st:string);

    procedure PremiereLigneTab(st1,st2,st3:string);
    procedure LigneTab(st1,st2,st3:string);
    procedure FinTab;

    procedure paraTexte(st:string);
    procedure makeJump(var st:string;k:integer);
    function Fjump(st,stID:string):string;

    procedure CreerPageLesObjets;

    function FID(st:string):string;
    function Fstring(st,stObj:string):string;
    function getMethodeID(st,stObj:string):string;

    procedure analyseConst;
    procedure analyseObjet;
    procedure rangeProp(tp:integer;numObj:integer;stProp,ID:string);
    procedure traiterDescription(var description:TstringList);
    procedure SortirDescription(var description:TstringList;stObj:string);
    procedure analyseProc(tp:integer);

    procedure creerPageProp(num:integer);
    procedure creerPagesProp;

    procedure creerPageMethodes(num:integer);
    procedure creerPagesMethodes;

    procedure CreerPageObjet(num:integer);
    procedure CreerPagesObjet;

    procedure CreerPageConstantes;
    procedure creerPageProcedures;

    procedure Analyse1(stSource:string);
    procedure analyseFPS(stF:string);
    procedure Analyse0;
    procedure Analyse00(var message:Tmessage);message wm_user+0;
  end;

var
  Mhlp: TMhlp;

implementation

{$R *.DFM}

const
  lettres=['A'..'Z','a'..'z','0'..'9','_'];

{Transforme les caractères accentués en codes RTF}
procedure traiteString(var sts:string);
var
  i:integer;
  flag:boolean;
  st:string;
begin
  i:=0;
  while i<length(sts) do
  begin
    inc(i);
    flag:=true;
    case sts[i] of
      'é': st:='\''e9';
      'è': st:='\''e8';
      'à': st:='\''e0';
      'ù': st:='\''f9';

      'â': st:='\''e2';
      'ê': st:='\''ea';
      'î': st:='\''ee';
      'ô': st:='\''f4';
      'û': st:='\''fb';

      'ç': st:='\''e7';

      '{','\','}':    st:='\'+sts[i];
      else
      if (ord(sts[i])>127) and (sts[i]<>'-') then  st:='!'
      else flag:=false;
    end;
    if flag then
      begin
        delete(sts,i,1);
        insert(st,sts,i);
        inc(i,length(st)-1);
      end;
  end;
end;

{Débuter fichier RTF}
procedure TmHlp.nouveauFichier;
var
  i:integer;
begin
  for i:=1 to 17 do writeln(fdest,modele.strings[i-1]);
end;

{Terminer fichier RTF}
procedure TmHlp.FinFichier;
begin
  writeln(fdest,modele.strings[41]);
end;

{Commencer une nouvelle page. Le titre de la page et la note $
sont supposés identiques}

procedure TmHlp.nouvellePage(stID,titre:string);
var
  st:string;
  k:integer;
begin
  stID:=FID(stID);

  titre:=FsupespaceFin(titre);
  titre:=FsupespaceDebut(titre);
  traiteString(titre);

  {memo1.lines.add('====>'+titre);}
  writeln(fdest,modele.strings[18]);
  st:=modele.strings[19];

  k:=pos('ABCDEFG',st);
  delete(st,k,7);
  insert(stID,st,k);

  k:=pos('ABCDEFG',st);
  while k>0 do
  begin
    delete(st,k,7);
    insert(titre,st,k);
    k:=pos('ABCDEFG',st);
  end;
  writeln(fdest,st);
end;

{Nouvelle page du genre Méthodes ou Propriétés. Pas de titre de page}
procedure TmHlp.nouvellePageTableau(stID,titre:string);
var
  st:string;
  k:integer;
begin
  stID:=FID(stID);

  traiteString(titre);
  titre:=FsupespaceFin(titre);
  titre:=FsupespaceDebut(titre);

  st:='\page #{\footnote # IDH_'+stID+'}${\footnote $ '+titre+'}';
  writeln(fdest,st);
end;

{Paragraphe lié au titre de la page et contenant au maximum 3 rubriques comme:
   Méthodes    Propriétés    Exemples }
procedure TmHlp.paraLie(st1,st1ID,st2,st2ID,st3,st3ID:string);
var
  st:string;
begin
  traiteString(st1);
  traiteString(st2);
  traiteString(st3);

  writeln(fdest,modele.strings[21]);

  st:='\par }{\fs22\ul '+st1+'}{\v IDH_'+Fmaj(st1ID)+'}{';
  if st2<>'' then st:=st+'          \fs22\ul '+st2+'}{\v IDH_'+Fmaj(st2ID)+'}{';
  if st3<>'' then st:=st+'          \fs22\ul '+st3+'}{\v IDH_'+Fmaj(st3ID)+'}{';

  writeln(fdest,st);
end;

{Paragraphe contenant un titre du genre: Déclaration }
procedure TmHlp.paraTitre(titre,st:string);
begin
  traiteString(titre);

  writeln(fdest,modele.strings[24]);
  titre:='\par }{\b '+titre+'}{ \tab';
  writeln(fdest,titre);
  writeln(fdest,st);
end;

{Paragraphe ordinaire sans titre }
procedure TmHlp.paraTexte(st:string);
begin
  writeln(fdest,modele.strings[27]);
  writeln(fdest,st);
end;

{Dans St, le mot désigné par K est transformé en saut}
procedure TmHlp.makeJump(var st:string;k:integer);

var
  k1,k2,nb:integer;
  st1:string;
begin
  k1:=k;
  while (k1>0) and (st[k1] in lettres) do dec(k1);
  k2:=k;
  while (k2<=length(st)) and (st[k2] in lettres) do inc(k2);

  nb:=k2-k1-1;
  k1:=k1+1;

  st1:=copy(st,k1,nb);
  delete(st,k1,nb);
  st1:='{\fs22\uldb '+st1+'}{\v IDH_'+Fmaj(st1)+'}';
  insert(st1,st,k1);
end;

{Convertit une expression en saut}
function TMhlp.Fjump(st,stID:string):string;
begin
  result:='{\fs22\uldb '+st+'}{\v IDH_'+FID(stID)+'}';
end;

{transforme la chaine st en un identificateur valable: espaces remplacés par _
et caractères accentués supprimés}
function TMhlp.FID(st:string):string;
var
  i:integer;
begin
  st:=FsupEspaceFin(st);
  st:=FsupEspaceDebut(st);
  st:=Fmaj(st);
  for i:=1 to length(st) do
    case st[i] of
     ' ','''':      st[i]:='_';
     'é','è','ê':   st[i]:='E';
     'ç':           st[i]:='C';
     'à','â':       st[i]:='A';
     'ù','û':       st[i]:='U';
     'î':           st[i]:='I';
     'ô':           st[i]:='O';
    end;
  result:=st;
end;

{Ecriture dans le fichier MPH}
procedure TMhlp.EcrireConstMPH(st:string);
var
  i:integer;
begin
  st:=FID(st);

  inc(nbConst);
  writeln(fmph,'#define IDH_'+Jgauche(st,40)+Istr(nbConst+IDH_const));
end;

{Traitement d'un bloc CONST. On écrit directement la page Constantes}
procedure TMhlp.analyseConst;
var
  ok:boolean;
begin
  ok:=false;
  stBloc:='';
  while not eof(fsource) do
  begin
    nextLine;
    if stBloc<>'' then exit;

    if directive='T' then
      begin
        NouvellePage(stCom,stCom);
        EcrireConstMPH(stCom);
        constantes.add(stCom);
        ok:=true;
      end
    else
    if ok then ParaTexte(stTexte)
  end;
end;

{Analyse d'un bloc Object. Les noms sont déjà dans ObjNames.
On range la description de l'objet num dans descriptionObj[num] (TstringList)
le premier objet du groupe est marqué avec 1 dans la propriété Objects de ObjNames
}
procedure TMhlp.analyseObjet;
var
  st:string;
  flag:boolean;
begin
  flag:=true;
  stBloc:='';

  while not eof(fsource) do
  begin
    nextLine;
    if stBloc<>'' then exit;

    st:=FsupEspaceFin(stTexte);
    st:=FsupEspaceDebut(st);
    if (st<>'') and (Fmaj(st)<>'END;') then
      begin
        inc(currentObj);
        if flag then ObjNames.objects[currentObj-1]:=pointer(1);
        if flag then memo1.lines.add('------->'+objNames.strings[currentObj-1]+' + '+st);
        flag:=false;
      end;

    traiterDescription(descriptionObj[currentObj]);
  end;
end;

{Création de la page LES OBJETS
On trouve chaque groupe classé séparément en ordre alphabétique.
Pour cela, on range d'abord les noms dans une liste triée et à chaque fois que
l'on rencontre une marque de début de groupe, on vide la liste dans la page et
on saute une ligne.
}
procedure TMhlp.CreerPageLesObjets;
var
  st:string;
  i,j:integer;
  list:TstringList;
begin
  list:=TstringList.create;
  list.sorted:=true;

  NouvellePage('Les objets','Les Objets');

  ParaTexte('');

  for i:=0 to ObjNames.count-1 do
  begin
    if  (objNames.objects[i]<>nil)  then
      begin
        for j:=0 to list.count-1 do paraTexte(list.strings[j]);
        paraTexte('');
        list.clear;
      end;

    st:=ObjNames.strings[i];
    if length(st)>7 then st:=st+' \tab '
    else st:=st+' \tab \tab ';
    st:=st+ObjAncetre.strings[i];
    MakeJump(st,1);

    list.add(st);
  end;

  for j:=0 to list.count-1 do paraTexte(list.strings[j]);
  list.free;
end;

{Range un nom de propriété ou de méthode pour l'objet numObj dans la stringList
ObjProp[numObj] ou ObjMethode[numObj]. L'ID est rangé en même temps dans la propriété
objects.
}
procedure TMhlp.rangeProp(tp:integer;numObj:integer;stProp,ID:string);
var
  p:pshortstring;
begin
  getmem(p,length(ID)+1);
  p^:=ID;
  case tp of
    1:ObjProp[numObj].addObject(stProp,pointer(p));
    4:ObjMethode[numObj].addObject(stProp,pointer(p));
  end;
end;

{Traite un commentaire commençant par $H
Le texte est rangé dans la stringList Description
}
procedure TMhlp.traiterDescription(var description:TstringList);
begin
  if directive<>'H' then exit;

  description.free;
  description:=TstringList.create;

  while Fcom or FfinCom do
  begin
    if (stCom='') or (length(stCom)>0) and(stCom[1]=' ') or (description.count=0)
      then description.add('');
    stCom:=FsupEspaceDebut(stCom);
    with description do strings[count-1]:=strings[count-1]+' '+stCom;
    if FFinCom then exit;

    nextLine;
  end;
end;

{Renvoie l'ID de la méthode st correspondant à l'objet stObj.
}
function TMhlp.getMethodeID(st,stObj:string):string;
var
  i,num:integer;
  Pdef:PdefProc;
  res:integer;
  pob:Pbyte;
begin
  result:='';
  num:=-1;
  for i:=0 to objNames.count-1 do
    if Fmaj(objNames.strings[i])=Fmaj(stObj) then num:=i;
  if num=-1 then exit;

  res:=tabProc.getNumProc1(st,Pdef,num);
  if res<=0 then exit;

  result:=ObjNames.strings[pdef^.valObj1]+'_'+st;
end;

{Transforme un chaine st en une chaine contenant des sauts. stObj est le nom de
l'objet courant.
}
function TMhlp.Fstring(st,stObj:string):string;
var
  i,i1,i2,k:integer;
  st1,st2,ID:string;
  flagPar1,flagPar2:boolean;
begin
  while pos('@',st)>0 do
  begin
    k:=pos('@',st);
    i1:=k-1;
    st1:='';

    if (i1>0) and (st[i1]=')') then
      begin
        flagPar1:=true;
        dec(i1);
      end
    else flagPar1:=false;
    while not flagPar1 and (i1>0) and (st[i1] in lettres)
          or
          flagPar1 and (i1>0) and (st[i1]<>'(') do
    begin
      st1:=st[i1]+st1;
      dec(i1);
    end;
    if flagPar1 and (i1>0) and (st[i1]='(') then dec(i1);


    i2:=k+1;
    st2:='';
    if (i2<=length(st)) and (st[i2]='(') then
      begin
        flagPar2:=true;
        inc(i2);
      end
    else flagPar2:=false;
    while not flagPar2 and (i2<=length(st)) and (st[i2] in lettres)
          OR
          flagPar2 and (i2<=length(st)) and (st[i2]<>')')
    do
    begin
      st2:=st2+st[i2];
      inc(i2);
    end;

    if flagPar2 and (i2<=length(st)) and (st[i2]=')') then inc(i2);
    if st2='' then
      begin
        st2:=st1;
        flagPar2:=flagPar1;
      end;

    if flagPar2 then
      begin
        for i:=1 to length(st2) do
          if st2[i]=' ' then st2[i]:='_';
      end
    else
      begin
        ID:=getMethodeID(st2,stObj);
        if ID<>'' then st2:=ID;
      end;

    delete(st,i1+1,i2-i1-1);
    insert(Fjump(st1,st2),st,i1+1);
    {messageCentral(st1+'/'+st2);}
  end;
  result:=st;
end;

{Crée le paragraphe 'Description' dans une page.
description est la stringList contenant le texte.
stObj est l'objet courant
}
procedure TMhlp.SortirDescription(var description:TstringList;stObj:string);
var
  i:integer;
begin
  if assigned(description) and (description.count>0) then
    with description do
    begin
      paraTitre('Description',Fstring(strings[0],stObj));
      for i:=1 to count-1 do paraTexte(Fstring(strings[i],stObj));
    end;

  description.free;
  description:=nil;
end;

{Traitement d'un déclaration de procédure, fonction ou méthode}
procedure TMhlp.analyseProc(tp:integer);
var
  st:string;
  stDeclare,stProp,stObj,stObj1:string;
  stApplique,stAlias:string;
  i,k,res:integer;
  numObj:integer;
  Pdef:PdefProc;
  pob:PtabOctet;
  w:byte;


const
  stDebut:array[1..4] of string=('Propriété ','Procédure ','Fonction ','Méthode ');

begin
  stAlias:='';
  stDeclare:=stTexte;

  st:=FsupEspace(stTexte);
  case tp of
    1,3: delete(st,1,8);           {supprimer Property ou Function}
    2:   delete(st,1,9);           {supprimer Procedure}
  end;

  k:=pos('.',st);
  if k>0 then
    begin
      stObj:=copy(st,1,k-1);       {nom objet}
      delete(st,1,k);
    end
  else stObj:='';

  if pos('(',st)>0 then stProp:=copy(st,1,pos('(',st)-1)      { nom propriété }
  else
  if pos(':',st)>0 then stProp:=copy(st,1,pos(':',st)-1)
  else stProp:=copy(st,1,pos(';',st)-1);


  if stObj<>'' then
    begin
      numObj:=tabProc.getNumObj(stObj);

      res:=tabProc.getNumProc1(stProp,Pdef,numObj);

      if Pdef=nil then
        begin
          messageCentral('Pdef=nil');
          exit;
        end;
      pob:=pointer(Pdef);
      with tabProc,Pdef^ do
      begin
        if valObj2>nbtypeObjet then valObj2:=nbtypeObjet;
        for i:=valObj1 to valObj2-1 do
          if estDescendant(i,valObj1) then
            begin
              if stApplique='' then
                begin
                  stApplique:=ObjNames.strings[i];
                  makeJump(stApplique,1);
                end
              else
                begin
                  stApplique:=stApplique+', '+ObjNames.strings[i];
                  makeJump(stApplique,length(stApplique)-2);
                end;
            end;
      end;

    end;

  stBloc:='';
  while not eof(fsource) and (stBloc='') do
  begin
    nextLine;

    if (stTexte<>'') and (stTexte[1]='/') and not Fcom then
      begin
        stAlias:=Fsupespace(stTexte);
        delete(stAlias,1,1);
      end;

    traiterDescription(description);
  end;

  if (stObj<>'') then
    begin
      if (tp<>1) then tp:=4;
      stObj1:=stObj+'_';
    end
  else stObj1:='';

  if stAlias<>'' then
    begin
      NouvellePage(stObj1+stAlias, stDebut[tp]+stAlias);
      paraTitre('Alias',stProp);
      k:=pos(stProp,stDeclare);
      delete(stDeclare,k,length(stProp));
      insert(stAlias,stDeclare,k);
    end
  else NouvellePage(stObj1+stProp,stDebut[tp]+stProp);

  {if ((tp=2) or (tp=3)) and (stGroupe<>'') then paraLie('Groupe','','');}

  for i:=length(stDeclare)-1 downto 1 do
    if stDeclare[i]=';' then insert(' ',stDeclare,i+1);
  paraTitre('Déclaration',stDeclare);

  if (tp=1) or (tp=4) then paraTitre('S''applique à',stApplique);

  if stObj<>'' then
  with tabProc,Pdef^ do
  begin
    if valObj2>nbtypeObjet then valObj2:=nbtypeObjet;
    for i:=valObj1 to valObj2-1 do
      if estDescendant(i,valObj1) then
        if stAlias<>''
          then rangeProp(tp,i,stAlias,stObj1+stAlias)
          else rangeProp(tp,i,stProp,stObj1+stProp);

  end;

  if (tp=2) or (tp=3) then
    if stAlias<>''
      then Procs.addObject(stAlias,pointer(numGroupe))
      else Procs.addObject(stProp,pointer(numGroupe));

  SortirDescription(description,stObj);

end;

{Sortie de la première ligne d'un tableau de 3 colonnes}
procedure TMhlp.PremiereLigneTab(st1,st2,st3:string);
var
  st:string;
begin
  writeln(fdest,modele.strings[32]);
  st:=st1+'\cell '+st2+'\cell '+st3+'\cell ';
  writeln(fdest,st);
end;

{Sortie d'une ligne d'un tableau de 3 colonnes}
procedure TMhlp.LigneTab(st1,st2,st3:string);
var
  st:string;
begin
  writeln(fdest,modele.strings[35]);
  writeln(fdest,modele.strings[36]);

  st:=st1+'\cell '+st2+'\cell '+st3+'\cell ';
  writeln(fdest,st);
end;

{Fin d'un tableau}
procedure TMhlp.FinTab;
begin
  writeln(fdest,modele.strings[39]);
end;


{Création de la page propriétés pour l'objet num}
procedure TMhlp.creerPageProp(num:integer);
var
  stP:array[0..2] of string;
  l,c,i,j:integer;
begin
  if ObjProp[num].count=0 then exit;

  ObjProp[num].sort;

  NouvellePageTableau(ObjNames[num]+'_Propriétés',ObjNames[num]+' Propriétés');

  with ObjProp[num] do
  for i:=0 to count-1 do
    begin
      l:=i div 3;
      c:=i mod 3;

      stP[c]:=Fjump(strings[i],Pshortstring(objects[i])^);
      if c=2 then
        begin
          if l=0 then premiereLigneTab(stP[0],stP[1],stP[2])
                 else LigneTab(stP[0],stP[1],stP[2]);
          for j:=0 to 2 do stP[j]:='';
        end;

    end;

  if c<>2 then
    if l=0 then premiereLigneTab(stP[0],stP[1],stP[2])
           else LigneTab(stP[0],stP[1],stP[2]);

  FinTab;
end;


{Création de toutes les pages Propriétés}
procedure TMhlp.creerPagesProp;
var
  i:integer;
begin
  for i:=0 to objNames.count-1 do creerPageProp(i);
end;

{Création de la page Méthodes pour l'objet num}
procedure TMhlp.creerPageMethodes(num:integer);
var
  stP:array[0..2] of string;
  l,c,i,j:integer;
begin
  if ObjMethode[num].count=0 then exit;

  ObjMethode[num].sort;

  NouvellePageTableau(ObjNames[num]+'_Méthodes',ObjNames[num]+' Méthodes');

  with ObjMethode[num] do
  for i:=0 to count-1 do
    begin
      l:=i div 3;
      c:=i mod 3;

      stP[c]:=Fjump(strings[i],Pshortstring(objects[i])^);
      if c=2 then
        begin
          if l=0 then premiereLigneTab(stP[0],stP[1],stP[2])
                 else LigneTab(stP[0],stP[1],stP[2]);
          for j:=0 to 2 do stP[j]:='';
        end;

    end;

  if c<>2 then
    if l=0 then premiereLigneTab(stP[0],stP[1],stP[2])
           else LigneTab(stP[0],stP[1],stP[2]);

  FinTab;
end;

{Création de toutes les pages Méthodes}
procedure TMhlp.creerPagesMethodes;
var
  i:integer;
begin
  for i:=0 to objNames.count-1 do creerPageMethodes(i);
end;

{Création de la page Objet pour l'objet num}
procedure TMhlp.CreerPageObjet(num:integer);
var
  st,stID:array[1..3] of string;
  i,nb:integer;
begin
  NouvellePage(objNames.strings[num],'Objet '+objNames.strings[num]);

  nb:=0;
  for i:=1 to 3 do
    begin
      st[i]:='';
      stID[i]:='';
    end;

  if objProp[num].count>0 then
    begin
      inc(nb);
      st[nb]:='Propriétés';
      stID[nb]:=objNames.strings[num]+'_PROPRIETES';
    end;

  if objMethode[num].count>0 then
    begin
      inc(nb);
      st[nb]:='Méthodes';
      stID[nb]:=objNames.strings[num]+'_METHODES';
    end;

  if nb>0 then ParaLie(st[1],stID[1],st[2],stID[2],st[3],stID[3]);

  if ObjAncetre.strings[num]<>''
    then ParaTitre('Hérite de ',Fjump(ObjAncetre.strings[num],ObjAncetre.strings[num]));


  SortirDescription(DescriptionObj[num+1],ObjNames.strings[num]);

end;

{Création de toutes les pages Objet }
procedure TMhlp.CreerPagesObjet;
var
  i:integer;
begin
  for i:=0 to objNames.count-1 do creerPageObjet(i);
end;

{Création de la page renvoyant à toutes les pages constantes }
procedure TMhlp.CreerPageConstantes;
var
  i,k:integer;
  st,stID:string;
begin
  NouvellePage('Constantes','Constantes');
  paraTexte('');

  for i:=0 to constantes.count-1 do
    begin
      st:=constantes.strings[i];
      st:=FsupespaceFin(st);
      st:=FsupespaceDebut(st);
      stID:=FID(st);
      paraTexte(Fjump(st,stID));
    end;
end;

{Création de la page renvoyant à toutes les pages procédures }
Procedure TMhlp.creerPageProcedures;
var
  i:integer;
  st:string;
  lettreDeb:string;
begin
  NouvellePage('Procédures','Procédures et fonctions');

  lettreDeb:='';
  Procs.sort;

  for i:=0 to Procs.count-1 do
    begin
      st:=Procs.strings[i];
      if Fmaj(st[1])<>LettreDeb then paraTexte('');
      lettreDeb:=Fmaj(st[1]);
      paraTexte(Fjump(st,st));
    end;
end;


procedure TMhlp.sortieErreur(st:string);
begin
  memo1.lines.add(currentSource+' '+'Line '+Istr(LineNum)+': '+st);
  memo1.refresh;
end;

{Lecture d'une ligne du fichier source
On décompose le texte et on affecte les variables globales suivantes:
  stCom, stTexte, directive, Fcom, stBloc
}
procedure TMhlp.nextline;
var
  i,j:integer;
  st:string;
begin
  inc(lineNum);

  stCom:='';
  stTexte:='';
  directive:=' ';

  readln(fsource,stLine);
  i:=pos('{',stLine);
  j:=pos('}',stLine);
  FdebutCom:=(i>0);
  FfinCom:=(j>0);

  if not Fcom and (i>0) then
    begin
      if (j>0) and (j<i) then SortieErreur('{ après }');
      Fcom:=(j=0);

      if j=0 then j:=length(stLine)+1;
      stCom:=copy(stLine,i+1,j-i-1);
      stTexte:=stLine;
      delete(stTexte,i,j-i+1);
      if (length(stCom)>2) and (stCom[1]='$') then
        begin
          directive:=stCom[2];
          delete(stCom,1,2);
          stCom:=FsupespaceFin(stCom);
        end;
    end
  else
  if Fcom and (j>0) then
    begin
      if (i>0) then SortieErreur('{ après {');
      Fcom:=false;
      stCom:=copy(stLine,1,j-1);
      stTexte:=copy(stLine,j+1,260);
    end
  else
  if not Fcom and (i=0) and (j=0) then stTexte:=stLine
  else
  if Fcom and (i=0) and (j=0) then stCom:=stLine;

  st:=Fmaj(stTexte);
  st:=FsupespaceDebut(st);

  if copy(st,1,5)='CONST' then stBloc:='CONST'
  else
  if copy(st,1,6)='OBJECT' then stBloc:='OBJECT'
  else
  if copy(st,1,8)='PROPERTY' then stBloc:='PROPERTY'
  else
  if copy(st,1,9)='PROCEDURE' then stBloc:='PROCEDURE'
  else
  if copy(st,1,8)='FUNCTION' then stBloc:='FUNCTION'
  else stBloc:='';

  {memo1.lines.add(Istr(lineNum)+':'+stCom);}
end;

{Analyse d'un fichier source}
procedure TMhlp.Analyse1(stSource:string);
begin
  currentSource:=stSource;
  memo1.lines.add('File: '+stSource);
  assignFile(fsource,stSource);
  reset(fsource);
  lineNum:=0;

  stBloc:='';
  while not eof(fsource) and (stBloc='') do NextLine;

  while stBloc<>'' do
  begin
    if stBloc='CONST' then analyseConst
    else
    if stBloc='OBJECT' then analyseObjet
    else
    if stBloc='PROPERTY' then analyseProc(1)
    else
    if stBloc='PROCEDURE' then analyseProc(2)
    else
    if stBloc='FUNCTION' then analyseProc(3);
  end;

  closeFile(fsource);
end;


procedure TMhlp.analyseFPS(stF:string);
var
  f:textFile;
  st:string;
begin
  assignFile(f,stF);
  reset(f);
  while not eof(f) do
  begin
    readln(f,st);
    st:=Fsupespace(st);
    if (st<>'') and (copy(st,1,3)='{$I') and (st[length(st)]='}') then
      begin
        delete(st,1,3);
        delete(st,length(st),1);
        analyse1(st);
      end;
  end;
  closeFile(f);
end;

{Analyse globale}
procedure TMhlp.Analyse0;
begin
  assignFile(fdest,'C:\Stm32_hlp\NStm32.rtf');
  rewrite(fdest);

  copierFichier('C:\Delphe5\Stm32.mph','c:\Stm32_hlp\Stm32.mph');
  assignFile(fmph,'C:\Stm32_hlp\Stm32.mph');
  append(fmph);

  NouveauFichier;

  analyseFPS('C:\Delphe5\stm32.fps');

  creerPageLesObjets;
  creerPagesProp;
  creerPagesMethodes;
  creerPagesObjet;
  CreerPageConstantes;
  creerPageProcedures;

  FinFichier;
  closeFile(fdest);
  closeFile(fmph);

end;

procedure TMhlp.Analyse00(var message:Tmessage);
begin
  analyse0;

  executeProcess(
  'C:\Program files\Borland\Delphi5\Help\Tools\hcw.exe',
  'C:\Program files\Borland\Delphi5\Help\Tools\hcw.exe /c/n/e c:\Stm32_hlp\Stm32'
  );

  copierFichier( 'c:\delphe5\Stm32.prc',   'c:\dexe5\Stm32.prc');
  copierFichier( 'c:\delphe5\Stm32.fps',   'c:\dexe5\Stm32.fps');
  copierFichier( 'c:\delphe5\common.fps', 'c:\dexe5\common.fps');

  copierFichier( 'c:\Stm32_hlp\Stm32.hlp',   'c:\dexe5\Stm32.hlp');
  copierFichier( 'c:\Stm32_hlp\gedit1.hlp', 'c:\dexe5\gedit1.hlp');


  memo1.lines.add('Terminé');
  {postMessage(handle,wm_close,0,0);}

end;

procedure TMhlp.FormCreate(Sender: TObject);
var
  i:integer;
  Pdef:PdefProc;
begin
  if executeProcess('c:\dexe5\precomp.exe','c:\dexe5\precomp.exe c:\delphe5\Stm32.fps')<>0
    then halt;

  ObjNames:=TstringList.create;
  ObjAncetre:=TstringList.create;
  modele:=TstringList.create;
  modele.loadFromFile('c:\delphe5\modhlp2.mod');

  Constantes:=TstringList.create;
  Procs:=TstringList.create;
  groups:=TstringList.create;

  with tabProc do
  begin
    init;
    charger('c:\delphe5\Stm32.prc');

    for i:=1 to tabProc.nbtypeObjet do

      begin
        Objnames.add(tbObjet^[i]);
        if tbAncetre^[i]<>255
          then ObjAncetre.add(tbObjet^[tbAncetre^[i]+1])
          else ObjAncetre.add('');

        ObjProp[i-1]:=TstringList.create;
        ObjMethode[i-1]:=TstringList.create;
      end;
  end;

  postMessage(handle,wm_user+0,0,0);


end;


end.
