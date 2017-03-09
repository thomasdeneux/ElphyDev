unit mphlp;

interface

{ Attention: ancienne version remplacée par mpHlp1}

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
    procedure paraProgramme(st:string);

    procedure makeJump(var st:string;k:integer);
    function Fjump(st,stID:string):string;
    procedure storeObject(st:string);

    function FID(st:string):string;
    function Fstring(st,stObj:string):string;
    function getMethodeID(st,stObj:string):string;

    procedure analyseConst;
    function getNumObj(st:string):integer;

    procedure traiterParagraphe;
    procedure analysePage;

    procedure analyseObjet;
    procedure rangeProp(tp:integer;numObj:integer;stProp,ID:string);
    procedure traiterDescription(var description:TstringList);
    procedure SortirDescription(title:string;var description:TstringList;stObj:string);
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

procedure TmHlp.paraProgramme(st:string);
var
  stmod:string;
  k:integer;
begin
  stmod:=modele.strings[27];
  k:=pos('\fs22',stmod);
  insert('\f6',stmod,k);

  writeln(fdest,stmod);
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

{Convertit st en un identificateur valable: plus d'espaces, d'apostrophes ou de
caractères accentués, ni de minuscules.
}
function TMhlp.FID(st:string):string;
var
  i:integer;
begin
  st:=FsupEspaceFin(st);
  st:=FsupEspaceDebut(st);
  st:=Fmaj(st);
  for i:=1 to length(st) do
    case st[i] of
     ' ','''','.':  st[i]:='_';
     'é','è','ê':   st[i]:='E';
     'ç':           st[i]:='C';
     'à','â':       st[i]:='A';
     'ù','û':       st[i]:='U';
     'î':           st[i]:='I';
     'ô':           st[i]:='O';
    end;
  result:=st;
end;

{Range un nom d'objet dans la table}
procedure TMhlp.storeObject(st:string);
var
  stObj,stAncetre:string;
begin
  st:=FsupEspaceFin(stTexte);
  st:=FsupEspaceDebut(stTexte);
  stAncetre:='';
  if pos('(',st)>0 then
    begin
      stObj:=copy(st,1,pos('(',st)-1);
      stAncetre:=copy(st,pos('(',st)+1,100);
      delete(stAncetre,length(stAncetre),1);
    end
  else
    begin
      stAncetre:='';
      stObj:=st;
    end;

  ObjNames.add(Fsupespace(stObj));
  ObjAncetre.add(Fsupespace(stAncetre));

  ObjProp[ObjNames.count-1]:=TstringList.create;
  ObjMethode[ObjNames.count-1]:=TstringList.create;

end;

procedure TMhlp.EcrireConstMPH(st:string);
var
  i:integer;
begin
  st:=FID(st);

  inc(nbConst);
  writeln(fmph,'#define IDH_'+Jgauche(st,40)+Istr(nbConst+IDH_const));
end;

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
    if directive='H' then
      begin
        traiterDescription(description);
        sortirDescription('',description,'');
      end
    else
    if ok then paraProgramme(stTexte);
  end;
end;

procedure TMhlp.traiterParagraphe;
var
  stList:TstringList;
  titrePara:string;
  i:integer;
begin
  if directive<>'P' then exit;
  titrePara:=stcom;

  stList:=TstringList.create;

  while Fcom or FfinCom do
  begin
    if (stCom='') or (length(stCom)>0) and(stCom[1]=' ') or (stList.count=0)
      then stList.add('');
    stCom:=FsupEspaceDebut(stCom);
    with stList do strings[count-1]:=strings[count-1]+' '+stCom;
    if FFinCom then
      begin
        if stList.count>1 then
          with stList do
          begin
            paraTitre(TitrePara,strings[1]);
            for i:=2 to count-1 do paraTexte(strings[i]);
          end;

        stList.free;
        exit;
      end;
    nextLine;
  end;
end;


procedure TMHlp.analysePage;
var
  titre,ident:string;

begin
  titre:=stTexte;
  titre:=FsupespaceDebut(titre);
  delete(titre,1,5);
  if pos(';',titre)>0 then delete(titre,pos(';',titre),1);

  ident:=stCom;
  if ident='' then ident:=titre;
  ident:=FsupespaceDebut(ident);
  ident:=FsupespaceFin(ident);

  memo1.lines.add('Page:'+ident+'+'+titre);
  NouvellePage(ident,titre);
  ParaTexte('');

  while not eof(fsource) do
  begin
    nextLine;
    if stBloc<>'' then exit;

    traiterParaGraphe;
  end;
end;

procedure TMhlp.analyseObjet;
var
  st:string;
begin
  stBloc:='';

  NouvellePage('Les objets','Les Objets');

  ParaTexte('');

  while not eof(fsource) do
  begin
    nextLine;
    if stBloc<>'' then exit;

    st:=FsupEspaceFin(stTexte);
    st:=FsupEspaceDebut(stTexte);
    if (st<>'') and (st<>'end;') then
      begin
        if pos('(',st)>0 then insert('\tab ',st,pos('(',st));
        MakeJump(st,1);
        StoreObject(st);
        ParaTexte(st);
      end;
    traiterDescription(descriptionObj[ObjNames.count]);
  end;
end;

function TMhlp.getNumObj(st:string):integer;
var
  i:integer;
begin
  st:=Fmaj(st);
  with objNames do
  for i:=0 to count-1 do
    if Fmaj(strings[i])=st then
      begin
        result:=i;
        exit;
      end;
  result:=-1;
end;

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

  pob:=pointer(Pdef);
  with Pdef^ do
    inc(intG(pob),Kdep+length(nom)+word(nbParam)*sizeof(typeParam));

  result:=ObjNames.strings[pob^]+'_'+st;
end;

{ Fstring recherche les caractères @ dans st et les convertit en sauts hypertexte.

  Les cas possibles sont:
    truc@
   (truc chose)@
   (truc chose)@ident
   (truc chose)@(ident en deux mots)

  stObj est le nom d'objet courant
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

    {recherche du premier groupe de mots st1}
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

    {recherche du second groupe de mots st2}
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

    if st1='' then
      begin
        {Il s'agit d'une directive}
        delete(st,i1+1,i2-i1);
        insert(' \'+st2+' ',st,i1+1);
      end
    else
      begin
        {il s'agit d'un saut}

        if flagPar2 then
          begin
            {On remplace les espaces de st2 par des _}
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
      end;
    {messageCentral(st1+'/'+st2);}
  end;
  result:=st;
end;

procedure TMhlp.SortirDescription(title:string;var description:TstringList;stObj:string);
var
  i:integer;
begin
  if assigned(description) and (description.count>0) then
    with description do
    begin
      if title<>''
        then paraTitre(Title,Fstring(strings[0],stObj))
        else paraTexte(Fstring(strings[0],stObj));
      for i:=1 to count-1 do paraTexte(Fstring(strings[i],stObj));
    end;

  description.free;
  description:=nil;
end;

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

      pob:=pointer(Pdef);
      with Pdef^ do
      begin
        inc(intG(pob),Kdep+length(nom)+word(nbParam)*sizeof(typeParam));

        stApplique:=ObjNames.strings[pob^[0]];

        makeJump(stApplique,1);
        for i:=1 to nbObj-1 do
          begin
            w:=pob^[i];
            if w<objNames.count then
              begin
                stApplique:=stApplique+', '+ObjNames.strings[pob^[i]];
                makeJump(stApplique,length(stApplique)-2);
              end
            else sortieErreur('w>=objNames.count '+stDeclare);
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
  with Pdef^ do
  begin
    for i:=0 to nbObj-1 do
      begin
        w:=pob^[i];
        if w<objNames.count then
          if stAlias<>''
            then rangeProp(tp,w,stAlias,stObj1+stAlias)
            else rangeProp(tp,w,stProp,stObj1+stProp);
      end;
  end;

  if (tp=2) or (tp=3) then
    if stAlias<>''
      then Procs.addObject(stAlias,pointer(numGroupe))
      else Procs.addObject(stProp,pointer(numGroupe));

  SortirDescription('Description',description,stObj);

end;

procedure TMhlp.PremiereLigneTab(st1,st2,st3:string);
var
  st:string;
begin
  writeln(fdest,modele.strings[32]);
  st:=st1+'\cell '+st2+'\cell '+st3+'\cell ';
  writeln(fdest,st);
end;

procedure TMhlp.LigneTab(st1,st2,st3:string);
var
  st:string;
begin
  writeln(fdest,modele.strings[35]);
  writeln(fdest,modele.strings[36]);

  st:=st1+'\cell '+st2+'\cell '+st3+'\cell ';
  writeln(fdest,st);
end;

procedure TMhlp.FinTab;
begin
  writeln(fdest,modele.strings[39]);
end;


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

procedure TMhlp.creerPagesProp;
var
  i:integer;
begin
  for i:=0 to objNames.count-1 do creerPageProp(i);
end;

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

procedure TMhlp.creerPagesMethodes;
var
  i:integer;
begin
  for i:=0 to objNames.count-1 do creerPageMethodes(i);
end;

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

  SortirDescription('Description',DescriptionObj[num+1],ObjNames.strings[num]);

end;

procedure TMhlp.CreerPagesObjet;
var
  i:integer;
begin
  for i:=0 to objNames.count-1 do creerPageObjet(i);
end;

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
  memo1.lines.add('Line '+Istr(LineNum)+': '+st);
  memo1.refresh;
end;

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
  else
  if copy(st,1,5)='HPAGE' then stBloc:='HPAGE'

  else stBloc:='';

  {memo1.lines.add(Istr(lineNum)+':'+stCom);}
end;

procedure TMhlp.Analyse1(stSource:string);
begin
  assignFile(fsource,stSource);
  reset(fsource);

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
    if stBloc='FUNCTION' then analyseProc(3)
    else
    if stBloc='HPAGE' then analysePage;
  end;

  closeFile(fsource);
end;


procedure TMhlp.Analyse0;
begin
  assignFile(fdest,'C:\Dac2_hlp\NDac2.rtf');
  rewrite(fdest);

  copierFichier(debugPath+'dac2.mph','c:\dac2_hlp\dac2.mph');
  assignFile(fmph,'C:\Dac2_hlp\dac2.mph');

  append(fmph);

  NouveauFichier;

  analyse1(debugPath+'DAC2.FPS');
  analyse1(debugPath+'Common.FPS');

  creerPagesProp;
  creerPagesMethodes;
  creerPagesObjet;
  CreerPageConstantes;
  creerPageProcedures;

  FinFichier;
  closeFile(fdest);
  closeFile(fmph);

end;

procedure ExecuteProcess(st1,st2:string);
var
  processInfo:TprocessInformation;
  startUp:TstartUpInfo;
  flags:Dword;
begin
  flags:=0;
  fillchar(startUp,sizeof(startUp),0);
  startUp.cb:=sizeof(startUp);

  if not createProcess(Pchar(st1),Pchar(st2),nil,nil,false,Flags,nil,nil,startUp,processInfo)
    then messageCentral('unable to create Process '+st1);
  WaitForSingleObjectEx(processInfo.hprocess,1000000,false);
end;

procedure TMhlp.Analyse00(var message:Tmessage);
begin
  analyse0;

  executeProcess(
  'C:\Program files\Borland\Delphi5\Help\Tools\hcw.exe',
  'C:\Program files\Borland\Delphi5\Help\Tools\hcw.exe /c/n/e c:\dac2_hlp\dac2'
  );

  copierFichier( debugPath+'Dac2.prc',   'c:\dexe5\Dac2.prc');
  copierFichier( debugPath+'dac2.fps',   'c:\dexe5\dac2.fps');
  copierFichier( debugPath+'common.fps', 'c:\dexe5\common.fps');

  copierFichier( 'c:\dac2_hlp\dac2.hlp',   'c:\dexe5\dac2.hlp');
  copierFichier( 'c:\dac2_hlp\gedit1.hlp', 'c:\dexe5\gedit1.hlp');


  memo1.lines.add('Terminé');
  {postMessage(handle,wm_close,0,0);}

end;

procedure TMhlp.FormCreate(Sender: TObject);
var
  i:integer;
  Pdef:PdefProc;
begin
  executeProcess('c:\Dexe5\precomp.exe','c:\Dexe5\precomp.exe '+debugPath+'Dac2.fps');

  ObjNames:=TstringList.create;
  ObjAncetre:=TstringList.create;
  modele:=TstringList.create;
  modele.loadFromFile(debugPath+'modhlp2.mod');

  Constantes:=TstringList.create;
  Procs:=TstringList.create;
  groups:=TstringList.create;

  with tabProc do
  begin
    init;
    charger(debugPath+'dac2.prc');
  end;

  postMessage(handle,wm_user+0,0,0);


end;


end.
