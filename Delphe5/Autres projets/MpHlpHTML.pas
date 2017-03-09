unit MpHlpHTML;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,strUtils,
  HTMLhelp1,

  util1,Gdos,procAc2,Dgraphic,precomp0 , wordList1, editcont,
  memoForm;



const
  NomMainFPS:string='d:\delphe5\dac2II.fps';     {  Param1 }
                                                 {  fichier FPS contenant une liste de fichiers inclus FPS }
  repEXE:string='d:\Dexe5\';                     {  Param2 }
                                                 {  Au final, le fichier prc et le fichier chm sont copiés dans ce répertoire }

  repPas:string='d:\delphe5\';
  {Param3 correspond à DebugPath qui est fixé dans Util1, c'est le répertoire des fichiers PAS
                                   Precompile (dans Precomp0) crée des fichiers PAS dans ce répertoire.
                                  }
  repHTML:string='d:\ElphyHTML\'; { Param4
                                    Répertoire de stockage des fichiers HTML }
                                  { HTML Help Workshop travaille dans ce répertoire et crée le fichier Elphy.chm
                                    doit contenir le fichier projet elphy.hhp   et le fichier elphyHTML.css
                                  }


Const
  NomBasePrc:string= 'Elphy2';

Var
  OpenLen0:integer;

type
  THTMLpage=class
              fileName:string;
              list:TstringList;
              constructor create;
              destructor destroy;override;
              procedure writeln(st:string);
              procedure save;
              Function IsOpen:boolean;
            end;


type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Label1: TLabel;
    esFPS: TeditString;
    Label2: TLabel;
    esEXE: TeditString;
    Label3: TLabel;
    esPAS: TeditString;
    Label4: TLabel;
    esHTML: TeditString;
    Bgo: TButton;
    Bfps: TButton;
    Bexe: TButton;
    Bpas: TButton;
    Bhtml: TButton;
    Label5: TLabel;
    esPRC: TeditString;
    Bchm: TButton;
    procedure BgoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BchmClick(Sender: TObject);
    procedure BexeClick(Sender: TObject);
  private
    { Déclarations privées }

    procedure outString(st:string);
  public
    { Déclarations publiques }
    objNames,objAncetre:TstringList;
    ObjProp,ObjMethode:array[0..1000] of TstringList;
    DescriptionObj:array[1..1000] of TstringList;
    Constantes:TstringList;
    Procs:TstringList;

    fsource:text;

    fContent:text;
    fIndex:text;

    stLine,stCom,stTexte,stBloc:string;
    directive:string;
    Fcom,FdebutCom,FfinCom:boolean;
    FcomParEtoile:boolean;
    lineNum:integer;

    stGroupe:string;

    nbConst:integer;
    numGroupe:integer;

    description:TstringList;

    currentObj:integer;
    currentSource:string;

    catNames:TstringList;
    catTitles:TstringList;
    cats:array of TstringList;

    DeclareList:Tstringlist;

    PageList,TitleList,BrowseGroupList:TstringList;
    SubPageList,SubTitleList,SubBrowseGroupList:TstringList;

    wordList:TwordList;

    FlagENG:boolean;

    HTMLpage:THTMLpage;

    repExe1: array[1..20] of string;
    NrepExe:integer;

    procedure sortieErreur(st:string);
    procedure nextLine;

    function BrowseLines(stID,titre,BrowseGroup:string;withNames:boolean):string;

    procedure nouvellePage(stID,titre,BrowseGroup:string);
    procedure paraLie(st1,st1ID,st2,st2ID,st3,st3ID,st4,st4ID:string);
    procedure paraTitre(titre,st:string);
    procedure EcrireConstMPH(st:string);

    procedure sortirTitre(title:string);
    procedure sortirPara(list:TstringList;stobj:string);

    procedure paraTexte(st:string);

    procedure makeJump(var st:string;k:integer);
    function Fjump(st,stID:string;const stComp:string=''):string;

    procedure CreerPageLesObjets;

    function FID(st:string):string;
    function Fstring(st,stObj:string):string;
    function getMethodeID(st,stObj:string):string;

    procedure traiterParagraphe;
    procedure traiterTitle(id:string;BrowseGroup: string);

    procedure analysePage;

    procedure analyseConst;
    procedure analyseTypes;
    procedure analyseObjet;
    procedure rangeProp(tp:integer;numObj:integer;stProp,ID:string);
    procedure traiterDescription(var description:TstringList);

    procedure ajouteCategorie;
    procedure traiterCategorie(stName:string);

    procedure SortirDescription(var description:TstringList;stObj:string);
    procedure analyseProc(tp:integer);

    procedure creerPageProp(num:integer);
    procedure creerPagesProp;

    procedure creerPageMethodes(num:integer);
    procedure creerPagesMethodes;

    procedure creerPageHier(num:integer);
    procedure creerPagesHier;


    procedure CreerPageObjet(num:integer);
    procedure CreerPagesObjet;

    procedure CreerPageConstantes;
    procedure creerPageProcedures;
    procedure creerPageProcThemes;
    procedure creerPagesCategories;

    procedure Analyse1(stSource:string);
    procedure analyseFPS(stF:string);
    procedure Analyse0;

    function PreAnalyse:boolean;
    procedure writelnMemo(st:string);

    procedure PrintObjNames;

    procedure StoreWords(stF:string);

    procedure CtOpen1;
    procedure CtClose1;
    procedure CtField1(name,local:string);
    procedure CtField2(name,local:string);

    procedure BuildChapter(stFile, stTitle, stId:string);
    procedure BuildSubChapter(stFile, stTitle, stId:string);
    procedure BuildContent;

    procedure saveParams;
    procedure LoadParams;
    procedure resetAll;

    procedure SetDefaultDirectories;
  end;

var
  form1: Tform1;

implementation

{$R *.DFM}

const
  lettres=['A'..'Z','a'..'z','0'..'9','_'];

  legalChar=lettres+
    ['à','â','ä','é','è','ê','ë','î','ï','ô','ö','ù','û','ü','ç','@','^','$','£','%','µ','&' ];
var
  tabProc:TtabDefProc;


function HTMLTitle(st:string;num:integer;center:boolean):string;
begin
  if center
    then result:='<h'+Istr(num)+' align="center">'+st+'</h'+Istr(num)+'>'
    else result:='<h'+Istr(num)+'>'+st+'</h'+Istr(num)+'>';
end;


function HTMLopen(title:string):string;
begin
  result:=  '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">' +crlf+

            '<html>'+crlf+

            '<head>'+crlf+
            '<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">'+crlf+

            '<title>'+title+'</title>'+crlf+
            '<link rel="stylesheet" type="text/css" href="elphyhtml.css">'+crlf+
            '</head>'+crlf+
            '<body>'+crlf;

            OpenLen0:=length(result);
            result:=result+HTMLtitle(title,2,true)+crlf;
end;

function HTMLclose:string;
begin
  result:='</body>'+crlf+
          '</html>'+crlf;
end;


function HTMLPara(st:string):string;
begin
  result:='<p>'+st+'</p>' ;
end;


function HTMLlist(list:TstringList):string;
var
  i:integer;
begin
  result:='<ul>'+crlf;
  with list do
  for i:=0 to count-1 do
    result:=result+'<li>'+strings[i]+'</li>'+crlf;
  result:=result+'</ul>' +crlf;
end;

function HTMLlist1(list:TstringList;nbcol:integer;sep:char):string;
var
  i,j,k:integer;
  st,st1:string;
begin
  result:='<table>'+crlf;
  with list do
  for i:=0 to count-1 do
  begin
    result:=result+'<tr>';
    st:=strings[i];
    for j:=0 to nbcol-1 do
    begin
      k:=pos(sep,st);
      if k=0 then k:=length(st)+1;
      st1:=copy(st,1,k-1);
      system.delete(st,1,k);

      result:=result+ '<td>'+st1+'</td>';
    end;
    result:=result+'</tr>'+crlf;
  end;
  result:=result+'</table>' +crlf;
end;

function HTMLtable(list:TstringList;nbcol:integer):string;
var
  i,j,k:integer;
  st:string;
  nbl:integer;
begin
  result:='<table cellpadding=1 cellspacing=0  >'+crlf;
  nbl:=list.count div nbcol;
  if list.count mod nbcol<>0 then inc(nbl);

  with list do
  for i:=0 to nbl-1 do
  begin
    result:=result+'<tr>';
    for j:=0 to nbcol-1 do
    begin
      k:=nbcol*i+j;
      if k<count
        then st:=strings[k]+' &nbsp; &nbsp;'
        else st:='';

      result:=result+ '<td>'+st+'</td>';
    end;
    result:=result+'</tr>'+crlf;
  end;
  result:=result+'</table>' +crlf;
end;


function CtOpen:string;
begin
  result:='<UL>';
end;

function CtClose:string;
begin
  result:='</UL>';
end;

function CtField(name,local:string):string;
begin
  result:='<LI> <OBJECT type="text/sitemap">'+crlf+
	  '<param name="Name" value="'+name+'">'+crlf+
          '<param name="Local" value="'+local+'">'+crlf+
          '</OBJECT>';
end;



procedure TForm1.outString(st: string);
begin
  HTMLpage.writeln(st);
end;

{Transforme les caractères spéciaux HTML}
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
      '<': st:='&lt;';
      '>': st:='&gt;';
      '&': st:='&amp;';
      '"': st:='&quot;';

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

{transforme la chaine st en un identificateur valable: espaces, points et apostrophes
remplacés par _ }
function Tform1.FID(st:string):string;
var
  i:integer;
begin
  st:=FsupEspaceFin(st);
  st:=FsupEspaceDebut(st);
  st:=Fmaj(st);
  for i:=1 to length(st) do
    case st[i] of
     ' ','''','.',':':  st[i]:='_';
     'é','è','ê':   st[i]:='E';
     'ç':           st[i]:='C';
     'à','â':       st[i]:='A';
     'ù','û':       st[i]:='U';
     'î':           st[i]:='I';
     'ô':           st[i]:='O';
    end;
  result:=st;
end;

{Ajoute les lignes de navigation à la dernière page}
function Tform1.BrowseLines(stID,titre,BrowseGroup:string; WithNames:boolean):string;
var
  st,st1:string;
  cnt:integer;
begin
  if BrowseGroup='' then exit;
  st:='';
  cnt:=pageList.count;
  (*
  if (cnt>1) and (BrowseGroupList[cnt-1]=BrowseGroupList[cnt-2]) then
  begin
    if withNames then st1:=TitleList[cnt-2] else st1:='';
    st:='<a href="'+pageList[cnt-2]+'.html"><img src="precedent.gif" alt="Previous" width="10" height="10" border="0" hspace="10" >'+st1+'</a>';
  end;
  if (cnt>0) and (BrowseGroupList[cnt-1]=BrowseGroup) then
  begin
    if st<>'' then st:=st+'<br>';
    if withNames then st1:=Titre else st1:='';
    st:=st+'<a href="'+stID+'.html"><img src="suivant.gif" alt="Next" width="10" height="10" border="0" hspace="10" >'+st1+'</a>';
  end;
  *)

  (*
   if (cnt>1) and (BrowseGroupList[cnt-1]=BrowseGroupList[cnt-2])  then
   begin
     if withNames then st1:=TitleList[cnt-2] else st1:='';
     st:='<table align="left" border="1" rules="none" ><colgroup><col><col width="800" span="2"></col><tr><td align="left">'+
         '<a href="'+pageList[cnt-2]+'.html"><img src="precedent.gif" alt="Previous" width="10" height="10" border="0" hspace="10" >'
       +st1+'</a></td>';
   end;
   if(cnt>0) and (BrowseGroupList[cnt-1]=BrowseGroup)  then
   begin
     if withNames then st1:=Titre else st1:='';
     st:=st+'<table align="right" border="1" rules="none"><td align="right"><a href="'+stID+'.html">'
     +st1+'<img src="suivant.gif" alt="Next" width="10" height="10" border="0" hspace="10" ></a></td></tr></table>';
   end;
  *)
  result:=st;

end;

{Commencer une nouvelle page, donc un nouveau fichier }

procedure Tform1.nouvellePage(stID,titre,BrowseGroup:string);
var
  st,st1:string;
begin
  stID:=FID(stID);

  if titre='' then messageCentral(stID +' vide');

  if HTMLpage.IsOpen then
  begin
    st1:=HTMLpage.list[0];
    insert(HTMLpara(BrowseLines(stID,titre,BrowseGroup,False)),st1,OpenLen0);
    HTMLpage.list[0]:=st1;

    paratexte(BrowseLines(stID,titre,BrowseGroup,true));

    outString(HTMLclose);
    HTMLpage.save;

    wordList.ProcessHTML(repHTML,pageList[pageList.count-1],'.html');
  end;

  HTMLpage.fileName:= repHTML+stID+'.HTML';

  titre:=FsupespaceFin(titre);
  titre:=FsupespaceDebut(titre);
  traiteString(titre);
  OutString(HTMLopen(titre));

  pageList.Add(stID);
  TitleList.Add(titre);
  BrowseGroupList.Add(BrowseGroup);

  writeln(fIndex,CtField(titre,stID+'.HTML'));
end;


{Paragraphe lié au titre de la page et contenant au maximum 3 rubriques comme:
   Méthodes    Propriétés    Exemples }
procedure Tform1.paraLie(st1,st1ID,st2,st2ID,st3,st3ID,st4,st4ID:string);
var
  st:string;
begin
  traiteString(st1);
  traiteString(st2);
  traiteString(st3);
  traiteString(st4);

  if st1<>'' then outString(Fjump(st1,st1ID) +' &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp;');
  if st2<>'' then   outString(Fjump(st2,st2ID)+' &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp;');
  if st3<>'' then   outString(Fjump(st3,st3ID)+' &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp;');
  if st4<>'' then   outString(Fjump(st4,st4ID)+' &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp;');

end;

{Paragraphe contenant un titre du genre: Déclaration }
procedure Tform1.paraTitre(titre,st:string);
var
  k:integer;
begin
  titre:=Fstring(titre,'');

  outString(HTMLTitle(titre,4,false));

  outString(HTMLpara(st));
end;

{Paragraphe ordinaire sans titre }
procedure Tform1.paraTexte(st:string);
begin
  outString(HTMLpara(st));
end;



{Dans St, le mot désigné par K est transformé en saut
 Le mot clé est identique au texte }
procedure Tform1.makeJump(var st:string;k:integer);

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
  st1:='<a href="'+st1+'.html">'+st1+'</a>';
  insert(st1,st,k1);
end;

{Convertit une expression en saut}
function Tform1.Fjump(st,stID:string;const stComp:string=''):string;
begin
  if stComp=''
    then result:= '<a href="'+FID(stID)+'.html">'+st+'</a>'
    else result:= '<a href="'+FID(stID)+'.html#'+stComp+'">'+st+'</a>';
end;



{ Fstring recherche les caractères @ dans st et les convertit en sauts hypertexte.

  Les cas possibles sont:
    truc@
   (truc chose)@
   (truc chose)@ident
   (truc chose)@(ident en deux mots)

  Si on a @truc ou @(truc chose) , on remplace par \truc ou \truc chose

  stObj est le nom d'objet courant
}

function Tform1.Fstring(st,stObj:string):string;
var
  i,i1,i2,k:integer;
  st1,st2,st3,ID:string;
  flagPar1,flagPar2:boolean;
begin
  traiteString(st);

  while pos('@@',st)>0 do
  begin
    i:=pos('@@',st);          { @@ représente un vrai arobas }
    delete(st,i,1);
    st[i]:='';               {on remplace provisoirement par  }
  end;

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

    if st1='' then                 { exemple @(    ) }
      begin
        {Il s'agit d'une directive}
        delete(st,i1+1,i2-i1);
        st2:=lowercase( st2);
        if (st2<>'') and (st2[1]='@') then      { insertion bitmap }
          begin
            delete(st2,1,1);
            if extractFilePath(st2)='' then
            begin
              st2:= FsupespaceDebut(st2);
              st2:=extractFilePath(NomMainFPS)+st2;
            end;
            st2:='<img src="'+st2+'" alt="'+st2+'" align="middle" >';
            insert(st2,st,i1+1);
          end
        else
        if st2='prog'
          then insert('</p><pre>',st,i1+1)                   { texte d'un programme }
        else
        if st2='notprog' then insert('</pre><p>',st,i1+1)    { texte d'un programme : fin de ligne }
        else
        if st2='br' then insert('<br>',st,i1+1)              { break }
        else
        if st2='ul' then insert('<u>',st,i1+1)               { souligné}
        else
        if st2='notul' then insert('</u>',st,i1+1)           { non souligné}
        else
        if st2='b' then insert('<b>',st,i1+1)                { gras}
        else
        if st2='notb' then insert('</b>',st,i1+1)            { non gras}
        else
        if st2='i' then insert('<i>',st,i1+1)                { italique}
        else
        if st2='noti' then insert('</i>',st,i1+1);           { non italique}

      end
    else
      begin
        {il s'agit d'un saut}
        st3:='';
        if flagPar2 then
          begin
            {On remplace les espaces de st2 par des _}
            for i:=1 to length(st2) do
              if st2[i]=' ' then st2[i]:='_';
            k:=pos('#',st2);
            if k>0 then
            begin
              st3:=copy(st2,k+1,length(st2));
              st2:=copy(st2,1,k-1);
            end;
          end
        else
          begin
            ID:=getMethodeID(st2,stObj);
            if ID<>'' then st2:=ID;
          end;

        delete(st,i1+1,i2-i1-1);
        insert(Fjump(st1,st2,st3),st,i1+1);
      end;
    {messageCentral(st1+'/'+st2);}
  end;

  while pos('',st)>0 do st[pos('',st)]:='@';
  result:=st;
end;


{ list contient le texte tel qu'il existe dans les fichiers fps
}
procedure Tform1.sortirPara(list:TstringList;stobj:string);
var
  i:integer;
  st:string;
  oldFprog,Fprog,Fprog2:boolean;
begin
  i:=0;
  st:='';
  oldFprog:=false;
  Fprog2:=false;

  repeat
    list[i]:=FsupespaceFin(list[i]);

    oldFprog:=Fprog;
    Fprog:=(pos('@f6',list[i])>0) or (list[i]='') and oldFprog;

    if pos('@prog',list[i])>0 then Fprog2:=true;
    if pos('@notprog',list[i])>0 then Fprog2:=true;

    if Fprog and not oldFprog then st:=st+' @prog'
    else
    if not Fprog and oldFprog then st:=st+' @notprog';

    if st<>''
      then st:=st+' '+List[i]
      else st:=List[i];

    if (i=list.count-1) and Fprog then st:=st+' @notprog';

    if (List[i]='') and not Fprog  and not Fprog2 or (i=List.count-1) then
    begin
      outString(HTMLpara(Fstring(st,stObj)));
      st:='';
    end
    else
    if (i<>List.count-1) and (copy(st,length(st)-7,8)<>'@notprog') and (copy(st,length(st)-4,5)<>'@prog')
      then st:=st+' @br';
    inc(i);
  until i>=List.count;
end;

procedure Tform1.sortirTitre(title:string);
begin
  outString(HTMLtitle(title,4,false));
end;

{ ICI commencent les méthodes qui ne dépendent pas du codage RTF ou HTML }


{Ecriture dans le fichier MPH}
procedure Tform1.EcrireConstMPH(st:string);
begin
  inc(nbConst);
end;

{Traitement d'un bloc CONST. On écrit directement la page Constantes}
procedure Tform1.analyseConst;
var
  ok:boolean;
  desc:TstringList;
  i:integer;
begin

  ok:=false;
  stBloc:='';


  while not eof(fsource) do
  begin
    nextLine;
    if stBloc<>'' then exit;

    if directive='T' then
      begin
        NouvellePage(stCom,stCom,'CONST');
        EcrireConstMPH(stCom);
        constantes.add(stCom);
        ok:=true;
      end
    else
    if ok and (directive='H') then
    begin
      desc:=nil;
      traiterDescription(desc);
      with desc do
      for i:=0 to count-1 do
        paraTexte(Fstring(strings[i],''));
      desc.free;
    end
    else
    if ok then
    begin
      ParaTexte(stTexte);
      writelnMemo(stTexte);
    end;
  end;
end;

{Traitement d'un bloc TYPE. }
procedure Tform1.analyseTypes;
var
  ok:boolean;
begin
  ok:=false;
  stBloc:='';
  while not eof(fsource) do
  begin
    nextLine;
    if stBloc<>'' then exit;
  end;
end;


procedure Tform1.traiterParagraphe;
var
  stList:TstringList;
  titrePara:string;
begin
  titrePara:=stcom;
  stList:=TstringList.create;
  stcom:='';

  while Fcom or FfinCom do
  begin
    if (stCom='') or (length(stCom)>0) and(stCom[1]=' ') or (stList.count=0)
      then stList.add('');

    with stList do strings[count-1]:=strings[count-1]+' '+stCom;

    if FFinCom then
      begin
        if stList.count>1 then
        begin
          if titrePara<>'' then sortirTitre(titrePara);
          sortirPara(stList,'');
        end;

        stList.free;
        exit;
      end;
    nextLine;
  end;
end;

procedure Tform1.traiterTitle(id:string; BrowseGroup: string);
var
  st,stID,stTitle:string;
begin
  stTitle:=stCom;
  traiteString(stTitle);
  stID:= FID(stCom);

  st:='<a name="' + stID +'">'+stTitle+'</a>';
  st:='<h3>'+st+'</h3>';
  outString(st);


  SubpageList.Add(id+'.HTML'+'#'+ FID(stCom));
  SubTitleList.Add(stTitle);
  SubBrowseGroupList.Add(BrowseGroup);
  
end;


procedure Tform1.analysePage;
var
  titre,ident:string;
  st:string;
begin
  ident:=stTexte;
  ident:=FsupespaceDebut(ident);
  delete(ident,1,5);
  if pos(';',ident)>0 then delete(ident,pos(';',ident),100);

  titre:=stCom;

  ident:=FsupespaceDebut(ident);
  ident:=FsupespaceFin(ident);
  if ident='' then ident:=titre;

  memo1.lines.add('Page:'+ident+'+'+titre);
  NouvellePage(ident,titre,'Hpage_'+currentSource);
  ParaTexte('');

  while not eof(fsource) do
  begin
    nextLine;
    if stBloc<>'' then break;

    if directive='P' then traiterParaGraphe
    else
    if directive='TITLE' then traiterTitle(ident,'Hpage_'+currentSource);
  end;


end;



{Analyse d'un bloc Object. Les noms sont déjà dans ObjNames.
On range la description de l'objet num dans descriptionObj[num] (TstringList)
le premier objet du groupe est marqué avec 1 dans la propriété Objects de ObjNames
}
procedure Tform1.analyseObjet;
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
procedure Tform1.CreerPageLesObjets;
var
  st:string;
  i,j:integer;
  list:TstringList;

begin

  If FlagEng
    then NouvellePage('The Objects','Elphy Objects','')
    else NouvellePage('Les objets','Objets','');

  ParaTexte('');

  list:=TstringList.create;
  list.sorted:=true;

  for i:=0 to ObjNames.count-1 do
  begin
    st:=ObjNames.strings[i];
    st:=Fjump(st,st);
    list.Add(st);
  end;

  outString(HTMLtable(list,5));

  list.free;
end;

{Range un nom de propriété ou de méthode pour l'objet numObj dans la stringList
ObjProp[numObj] ou ObjMethode[numObj]. L'ID est rangé en même temps dans la propriété
objects.
}
procedure Tform1.rangeProp(tp:integer;numObj:integer;stProp,ID:string);
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
procedure Tform1.traiterDescription(var description:TstringList);
begin
  if directive<>'H' then exit;

  description.free;
  description:=TstringList.create;

  while Fcom or FfinCom do
  begin
    if (stCom='') or (length(stCom)>0) and(stCom[1]=' ') or (description.count=0)
      then description.add('');
    //stCom:=FsupEspaceDebut(stCom);
    with description do strings[count-1]:=strings[count-1]+' '+stCom;

    if FFinCom then exit;

    nextLine;
  end;

end;


{ Ajoute une catégorie . Le format est
   $CAT KeyWord Titre de la page

 }
procedure Tform1.ajouteCategorie;
var
  st,key:string;
  n:integer;
begin
  if directive<>'CAT' then exit;

  st:='';
  while Fcom or FfinCom do
  begin
    st:=st+' '+stCom;
    if FfinCom then break;
    nextLine;
  end;

  st:=FsupEspaceDebut(st);
  key:='';
  while (length(st)>0) and (st[1]<>' ') do
  begin
    key:=key+st[1];
    delete(st,1,1);
  end;
  st:=FsupEspaceDebut(st);

  key:=Fmaj(key);
  n:=CatNames.indexof(key);
  if n<0 then
  begin
    CatNames.add(key);
    catTitles.add(st);
    setLength(cats,length(cats)+1);
    cats[high(cats)]:=TstringList.Create;
    n:=high(cats);
  end;

end;

{ Traitement d'une catégorie . Le format est
   $C KeyWord Description en une ligne
 }
procedure Tform1.traiterCategorie(stName:string);
var
  st,key:string;
  n:integer;
begin
  if directive<>'C' then exit;

  st:='';
  while Fcom or FfinCom do
  begin
    st:=st+' '+stCom;
    if FfinCom then break;
    nextLine;
  end;

  st:=FsupEspaceDebut(st);
  key:='';
  while (length(st)>0) and (st[1]<>' ') do
  begin
    key:=key+st[1];
    delete(st,1,1);
  end;

  key:=Fmaj(key);
  n:=CatNames.indexof(key);
  if n<0 then
  begin
    messageCentral('Unknown cat : '+key);
    halt;
  end;

  cats[n].add(Fjump(stName,stName)+' : '+st);
end;

{Renvoie l'ID de la méthode st correspondant à l'objet stObj.
}
function Tform1.getMethodeID(st,stObj:string):string;
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



{Crée le paragraphe 'Description' dans une page.
description est la stringList contenant le texte.
stObj est l'objet courant
}
procedure Tform1.SortirDescription(var description:TstringList;stObj:string);
var
  i:integer;
begin
  if assigned(description) and (description.count>0) then
    with description do
    begin
      sortirTitre('Description');
      sortirPara(description,stObj);
    end;

  description.free;
  description:=nil;
end;



{Traitement d'une déclaration de procédure, fonction ou méthode}
procedure Tform1.analyseProc(tp:integer);
var
  st:string;
  stDeclare,stDeclareTot:string;
  stProp,stObj,stObj1,stObj2:string;
  stApplique,stAlias:string;
  i,k:integer;
  numObj:integer;
  Pdef:PdefProc;
  pob:PtabOctet;
  w:byte;
  stGroup:string;
  NumP:integer;

const
  stDebut:array[false..True,1..4] of string=
       (('Propriété ','Procédure ','Fonction ','Méthode '),
        ('Property ','Procedure ','Function ','Method ')
       );

begin
  stAlias:='';
  stDeclare:=stTexte;

  st:=FsupEspace(stTexte);
  case tp of
    1,3: delete(st,1,8);           {supprimer Property ou Function}
    2:   delete(st,1,9);           {supprimer Procedure}
  end;

  k:=pos('.',st);
  if (k>0) and (st[k+1]<>'.') then
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
      numP:=tabProc.getNumProc1(stProp,Pdef,numObj);
    end
  else numP:=tabProc.getNumProc1(stProp,Pdef,-1);

  stDeclareTot:=stDeclare;
  if tp=1 then
  begin
    stDeclareTot:=AnsiReplaceText(stDeclareTot,'(','[');
    stDeclareTot:=AnsiReplaceText(stDeclareTot,')',']');
  end;


  if Pdef=nil then messageCentral('Pdef=nil stObj='+stObj+'   stProp='+stProp);
  
  if Pdef^.Foverload then  { getNumProc1 renvoie la première déclaration }
  begin
    DeclareList.Add(stDeclare);

    if declareList.count<tabProc.NumberOfOverload(Pdef) then
    begin
      stBloc:='';
      while not eof(fsource) and (stBloc='') do nextLine;
      exit;
    end
    else
    with declareList do
    begin
      stDeclareTot:=strings[0];
      for i:=1 to count-1 do
        stDeclareTot:=stDeclareTot+ '<br>'+ strings[i];
      clear;
    end;
  end
  else DeclareList.clear;

  if stObj<>'' then
    begin
      if Pdef=nil then
        begin
          messageCentral('Pdef=nil :: '+stProp+'  '+Istr(numObj));
          exit;
        end;
      pob:=pointer(Pdef);
      with tabProc,Pdef^ do
      begin
        if valObj2=-1 then valObj2:=nbtypeObjet;
        for i:=valObj1 to valObj2-1 do
          if isChild(i,valObj1) then
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
    ajouteCategorie;
    if stAlias<>''
      then traiterCategorie(stAlias)
      else traiterCategorie(stProp);
  end;

  if (stObj<>'') then
    begin
      if (tp<>1) then tp:=4;
      stObj1:=stObj+'_';
      stObj2:=stObj+'.';

    end
  else
  begin
    stObj1:='';
    stObj2:='';
  end;

  if stObj<>''
    then stGroup:=stObj+'_'
    else stGroup:='PROC_';

  if stAlias<>'' then
    begin
      NouvellePage(stObj1+stAlias, stDebut[FlagEng,tp]+stObj2+stAlias,'');
      paraTitre('Alias',stProp);

      stDeclare:=AnsiReplaceText(stDeclare, stProp,stAlias);
      stDeclareTot:=AnsiReplaceText(stDeclareTot, stProp,stAlias);
    end
  else NouvellePage(stObj1+stProp,stDebut[FlagEng,tp]+stObj2+stProp,'');

  {if ((tp=2) or (tp=3)) and (stGroupe<>'') then paraLie('Groupe','','');}

  for i:=length(stDeclareTot)-1 downto 1 do
    if stDeclareTot[i]=';' then insert(' ',stDeclareTot,i+1);

  if FlagEng
    then paraTitre('Declaration',stDeclareTot)
    else paraTitre('Déclaration',stDeclareTot);

  if (tp=1) or (tp=4) then
  begin
    if FlagEng
      then paraTitre('Applies To',stApplique)
      else paraTitre('S''applique à',stApplique);
  end;

  if stObj<>'' then
  with tabProc,Pdef^ do
  begin
    if valObj2=-1 then valObj2:=nbtypeObjet;
    for i:=valObj1 to valObj2-1 do
      if isChild(i,valObj1) then
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



{Création de la page propriétés pour l'objet num}
procedure Tform1.creerPageProp(num:integer);
var
  i:integer;
  list:TstringList;
begin
  if ObjProp[num].count=0 then exit;

  ObjProp[num].sort;
  list:=TstringList.create;

  with objProp[num] do
  for i:=0 to count-1 do
    list.Add(Fjump(strings[i],Pshortstring(objects[i])^));

  if FlagEng
    then NouvellePage(ObjNames[num]+'_Properties',ObjNames[num]+' Properties','')
    else NouvellePage(ObjNames[num]+'_Propriétés','Propriétés de '+ObjNames[num],'');

  outString(HTMLtable(list,5));
  list.free;
end;


{Création de toutes les pages Propriétés}
procedure Tform1.creerPagesProp;
var
  i:integer;
begin
  for i:=0 to objNames.count-1 do creerPageProp(i);
end;

{Création de la page Méthodes pour l'objet num}
procedure Tform1.creerPageMethodes(num:integer);
var
  i:integer;
  list:TstringList;
begin
  if ObjMethode[num].count=0 then exit;

  ObjMethode[num].sort;
  list:=TstringList.create;

  with objMethode[num] do
  for i:=0 to count-1 do
    list.Add(Fjump(strings[i],Pshortstring(objects[i])^));

  if FlagEng
    then NouvellePage(ObjNames[num]+'_Methods', ObjNames[num]+' Methods','')
    else NouvellePage(ObjNames[num]+'_Méthodes','Méthodes de '+ObjNames[num],'');
  outString(HTMLtable(list,5));
  list.free;
end;

{Création de toutes les pages Méthodes}
procedure Tform1.creerPagesMethodes;
var
  i:integer;
begin
  for i:=0 to objNames.count-1 do creerPageMethodes(i);
end;



{Création de la page Hiérarchy pour l'objet num}
procedure Tform1.creerPageHier(num:integer);
var
  i,inext:integer;
  list:TstringList;                                     
begin
  list:=TstringList.create;

  i:=num;
  while (i>=0) and (ObjAncetre.strings[i]<>'') do
  begin
    inext:= tabProc.tbAncetre^[i+1];
    if (inext>=0) and ( ObjAncetre.strings[inext]<>'')
      then list.Add(Fjump(ObjAncetre.strings[i],ObjAncetre.strings[i])
                   +'<BR align="center"> <img src="ln.gif" width="10" height="20" border="0" hspace="10" >')
      else list.Add(Fjump(ObjAncetre.strings[i],ObjAncetre.strings[i]));
    i:=inext;
  end;

  if FlagEng
    then NouvellePage(ObjNames[num]+'_Hierarchy',ObjNames[num]+' Inherits From ','')
    else NouvellePage(ObjNames[num]+'_Hierarchy',ObjNames[num]+' Hérite de ','');
    
  outString(HTMLtable(list,1));
  list.free;
end;


{Création de toutes les pages Hierarchies}
procedure Tform1.creerPagesHier;
var
  i:integer;

begin
  for i:=0 to objNames.count-1 do creerPageHier(i);
end;




{Création de la page Objet pour l'objet num}
procedure Tform1.CreerPageObjet(num:integer);
var
  st,stID:array[1..4] of string;
  i,nb:integer;
begin
     if FlagEng
      then  NouvellePage(objNames.strings[num],objNames.strings[num]+' Object ','')
      else NouvellePage(objNames.strings[num],'Objet '+objNames.strings[num],'');

  nb:=0;
  for i:=1 to 4 do
    begin
      st[i]:='';
      stID[i]:='';
    end;

  if ObjAncetre.strings[num]<>'' then
  begin
    inc(nb);

    if FlagEng
      then st[nb]:='  Hierarchy '
      else st[nb]:='  Hierarchie ';

    stID[nb]:=objNames.strings[num]+'_HIERARCHY';
  end;

  if objProp[num].count>0 then
    begin
      inc(nb);
      if FlagEng then
      begin
        st[nb]:='Properties';
        stID[nb]:=objNames.strings[num]+'_PROPERTIES';
      end
      else
      begin
        st[nb]:='Propriétés';
        stID[nb]:=objNames.strings[num]+'_PROPRIETES';
      end;
    end;

  if objMethode[num].count>0 then
    begin
      inc(nb);
      if FlagEng then
      begin
        st[nb]:='Methods';
        stID[nb]:=objNames.strings[num]+'_METHODS';
      end
      else
      begin
        st[nb]:='Méthodes';
        stID[nb]:=objNames.strings[num]+'_METHODES';
      end;
    end;

  if nb>0 then ParaLie(st[1],stID[1],st[2],stID[2],st[3],stID[3],st[4],stID[4]);

//  if ObjAncetre.strings[num]<>'' then
//  begin
//    if FlagEng
//      then ParaTitre('Hérite de ',Fjump(ObjAncetre.strings[num],ObjAncetre.strings[num]))
//      else ParaTitre('Inherits From ',Fjump(ObjAncetre.strings[num],ObjAncetre.strings[num]));
//  end;
  SortirDescription(DescriptionObj[num+1],ObjNames.strings[num]);

end;

{Création de toutes les pages Objet }
procedure Tform1.CreerPagesObjet;
var
  i:integer;
begin
  for i:=0 to objNames.count-1 do creerPageObjet(i);
end;

{Création de la page renvoyant à toutes les pages constantes }
procedure Tform1.CreerPageConstantes;
var
  i,k:integer;
  st,stID:string;
begin
  if FlagEng
    then NouvellePage('Constants','Constants','')
    else NouvellePage('Constantes','Constantes','');

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
Procedure Tform1.creerPageProcedures;
var
  i:integer;
  st:string;
  lettreDeb:string;
  list:TstringList;
begin
  NouvellePage('ProcFoncs','Procedures And Functions','');

  lettreDeb:='';
  Procs.sort;
  list:=TstringList.create;

  for i:=0 to Procs.count-1 do
    begin
      st:=Procs.strings[i];
      if Fmaj(st[1])<>LettreDeb then
      begin
        outString(HTMLtable(list,5));
        list.clear;
        paraTexte('');
      end;

      lettreDeb:=Fmaj(st[1]);

      st:=Fjump(st,st);
      list.Add(st);
    end;

  outString(HTMLtable(list,5));
  list.free;
end;

const
  stCats: array[1..10,1..2] of string =(
          ('Manipulation de vecteurs',        'ManVec'),
          ('Manipulation de matrices',        'ManMat'),
          ('Mesures sur des vecteurs' ,       'MesVec'),
          ('Routines mathématiques',          'Math'),
          ('Routines trigonométriques',       'Trigo'),
          ('Routines de gestion de fichiers', 'Files'),
          ('Routines système',                'RSystem'),
          ('Dialogue modal',                  'Dialmod'),
          ('Gestion de chaînes de caractères','RString'),
          ('Routines de conversion',          'Conv')

          );
  stCatsEng: array[1..10,1..2] of string =(
          ('Vector Handling',         'ManVec'),
          ('Matrix Handling',         'ManMat'),
          ('Vector Measures' ,        'MesVec'),
          ('Math Routines',           'Math'),
          ('Trigonometry Routines',   'Trigo'),
          ('File Management Routines','Files'),
          ('System Routines',         'RSystem'),
          ('Modal Dialog',            'Dialmod'),
          ('String Handling Routines','RString'),
          ('Conversion Routines',     'Conv')

          );

procedure Tform1.creerPageProcThemes;
var
  i:integer;
begin
  NouvellePage('ProcThemes','Procedures And Functions','');

  if FlagEng then
    for i:=1 to high( stCatsEng) do
      paraTexte(Fjump(stCatsEng[i,1],stCatsEng[i,2]))
  else
    for i:=1 to high( stCats) do
      paraTexte(Fjump(stCats[i,1],stCats[i,2]));
end;

procedure Tform1.creerPagesCategories;
var
  i,j:integer;
begin
  for i:=0 to high(Cats) do
  with cats[i] do
  begin
    NouvellePage(catNames[i],CatTitles[i],'');
    paraTexte('');

    outString(HTMLlist1(cats[i],2,':'));
  end;
end;


procedure Tform1.sortieErreur(st:string);
begin
  memo1.lines.add(currentSource+' '+'Line '+Istr(LineNum)+': '+st);
  memo1.refresh;
end;

{Lecture d'une ligne du fichier source
On décompose le texte et on affecte les variables globales suivantes:
  stCom, stTexte, directive, Fcom, stBloc

 ATTENTION : on considère qu'il n'y a jamais deux commentaires sur la même ligne !!!
}
procedure Tform1.nextline;
var
  i,j,i1,j1:integer;
  st:string;
begin
  inc(lineNum);

  stCom:='';
  stTexte:='';
  directive:='';

  readln(fsource,stLine);

  if not Fcom then
  begin
    i:=pos('{',stLine);
    i1:=pos('(*',stLine);
    FcomParEtoile:=(i1>0) and ((i=0) or (i>i1));
    if FcomParEtoile then i:=i1;

    if i>0 then
    begin
      if FcomParEtoile
        then j:=pos('*)',stLine)
        else j:=pos('}',stLine);
    end
    else
    begin
      j:=pos('}',stLine);
      j1:=pos('*)',stLine);
      if (i=0) and ((j>0) or (j1>0))
        then SortieErreur('fermeture de commentaire inattendue');
    end
  end
  else
  begin
    if not FcomParEtoile then
    begin
      i:=pos('{',stLine);
      j:=pos('}',stLine);
    end
    else
    begin
      i:=pos('(*',stLine);
      j:=pos('*)',stLine);
    end;
  end;

  FdebutCom:=(i>0);
  FfinCom:=(j>0);

  if not Fcom and (i>0) then
    begin
      if (j>0) and (j<i) then SortieErreur('{ après }');
      Fcom:=(j=0);

      if j=0 then j:=length(stLine)+1;

      if FcomParEtoile
        then stCom:=copy(stLine,i+2,j-i-1)
        else stCom:=copy(stLine,i+1,j-i-1);
      stTexte:=stLine;
      delete(stTexte,i,j-i+1);
      if (length(stCom)>=2) and (stCom[1]='$') then
        begin
          delete(stCom,1,1);
          while(length(stCom)>0) and (stCom[1]<>' ') do
          begin
            directive:=directive+stCom[1];
            delete(stCom,1,1);
          end;
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
  else
  if copy(st,1,5)='TYPE' then stBloc:='TYPE'


  else stBloc:='';

  {memo1.lines.add(Istr(lineNum)+':'+stCom);}
end;

{Analyse d'un fichier source FPS }
procedure Tform1.Analyse1(stSource:string);
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
    if stBloc='FUNCTION' then analyseProc(3)
    else
    if stBloc='HPAGE' then analysePage
    else
    if stBloc='TYPE' then analyseTypes;

  end;

  closeFile(fsource);
end;


procedure Tform1.analyseFPS(stF:string);
var
  f:textFile;
  st:string;
  stPath:string;
begin
  stPath:=extractFilePath(stF);
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
        st:=extractFilePath(stF)+extractFileName(st);
        analyse1(st);
      end;
  end;
  closeFile(f);
end;

{Analyse des fichiers FPS dans le but de créer des fichiers HTML
}
procedure Tform1.Analyse0;
begin
  AssignFile(fIndex,repHTML+'Elphy.hhk');
  rewrite(fIndex);
  writeln(fIndex,HTMLopen('Elphy Index'));
  writeln(fIndex,CtOpen);

  analyseFPS(nomMainFPS);

  creerPageLesObjets;
  creerPagesProp;
  creerPagesMethodes;
  creerPagesObjet;
  CreerPageConstantes;

  creerPagesCategories;

  creerPageProcedures;
  creerPageProcThemes;

  creerPagesHier;
  HTMLpage.save;

  wordList.saveToFile(repHTML+'elphy.wli' );

  writeln(fIndex,CtClose);
  writeln(fIndex,HTMLclose);
  CloseFile(fIndex);

  BuildContent;
end;

function Tform1.preAnalyse:boolean;
var
  i,res:integer;
  Pdef:PdefProc;
  version:integer;

begin
  result:=false;
  writeln1:=writelnMemo;

  { La précompilation crée dans D:\delphe5 les fichier PRC et ADR  }


  DebugPath:= RepPas;

  if precompile(NomMainFPS,repPas+NomBasePrc)<>0 then exit;

  { Ensuite, on charge le fichier PRC et on range le maximum d'info dans des listes
  }
  ObjNames:=TstringList.create;
  ObjAncetre:=TstringList.create;

  Constantes:=TstringList.create;
  Procs:=TstringList.create;

  catNames:=TstringList.create;
  catTitles:=TstringList.create;

  DeclareList:=TstringList.create;
  PageList:=TstringList.create;
  TitleList:=TstringList.create;
  BrowseGroupList:=TstringList.create;

  SubPageList:=TstringList.create;
  SubTitleList:=TstringList.create;
  SubBrowseGroupList:=TstringList.create;

  wordList:=TwordList.create;
  HTMLpage:=THTMLpage.create;


  tabProc:=TtabDefProc.create;
  with tabProc do
  begin
    charger(repPas+ nomBasePrc+'.prc');

    for i:=1 to tabProc.nbtypeObjet do
      begin
        Objnames.add(tbObjet[i-1].stName);
        if tbAncetre^[i]<>-1
          then ObjAncetre.add(tbObjet[tbAncetre^[i]].stName)
          else ObjAncetre.add('');

        ObjProp[i-1]:=TstringList.create;
        ObjMethode[i-1]:=TstringList.create;
      end;
  end;
  result:=true;
end;

procedure Tform1.BgoClick(Sender: TObject);
var
  i,k:integer;
  st:string;
begin
  resetAll;
  updateAllvar(self);
  saveParams;

  st:=repExe;
  NrepExe:=0;
  k:=pos(';',st);
  while k>0 do
  begin
    inc(NrepExe);
    RepExe1[NrepExe]:=copy(st,1,k-1);
    delete(st,1,k);
    k:=pos(';',st);
  end;
  if length(st)>0 then
  begin
    inc(NrepExe);
    RepExe1[NrepExe]:=st;
  end;

  memo1.Clear;
  memo1.lines.add( 'NomMainFPS= '+NomMainFPS);
  memo1.lines.add( 'repEXE= '+repEXE);
  memo1.lines.add( 'repHTML= '+repHTML);


  if not preAnalyse then exit;

  analyse0;

  for i:=1 to NrepExe do
    copierFichier( repPas+ nomBasePrc+'.prc',   repEXE1[i]+nomBasePrc+'.prc');

  if executeProcess('C:\Program Files\HTML Help Workshop\hhc.exe',
                 '"C:\Program Files\HTML Help Workshop\hhc.exe" '+repHTML+'elphy.hhp') <>0

    then executeProcess('C:\Program Files (x86)\HTML Help Workshop\hhc.exe',
                       '"C:\Program Files (x86)\HTML Help Workshop\hhc.exe" '+repHTML+'elphy.hhp');

  for i:=1 to NrepExe do
    copierFichier( repHTML+'elphy.chm',   repEXE1[i]+'elphy.chm');

  memo1.lines.add('Terminé');

  PrintObjNames;

  memo1.lines.add('Nb Param Max = '+Istr(NparMax));
end;

procedure Tform1.writelnMemo(st:string);
begin
  memo1.lines.add(st);
end;


procedure Tform1.PrintObjNames;
var
  i:integer;
  f:textFile;
begin
  assignFile(f,repPas+'Elphy-objects.txt');
  rewrite(f);

  for i:=0 to objNames.Count-1 do
    writeln(f, objNames[i]);

  closeFile(f);
end;



procedure TForm1.StoreWords(stF: string);
var
  f:textFile;
  st:string;
begin
  assignFile(f,stF);
  reset(f);
  try
  while not eof(f) do
  begin
    readln(f,st);
  end;

  finally
  CloseFile(f);
  end;


end;

procedure TForm1.CtOpen1;
begin
  writeln(fContent,CtOpen);
end;

procedure TForm1.CtClose1;
begin
  writeln(fContent,CtClose);
end;

procedure TForm1.CtField1(name,local:string);
begin
  writeln(fContent,CtField(name,local+'.HTML'));
end;

procedure TForm1.CtField2(name,local:string);
begin
  writeln(fContent,CtField(name,local));
end;


procedure TForm1.BuildChapter(stFile, stTitle, stId:string);
var
  stMod:string;
  i:integer;
  ok:boolean;
begin
  ok:=false;
  CtField1(stTitle,stID);
  CtOpen1;
  stMod:=Fmaj('Hpage_'+extractfilePath(nomMainFPS)+stFile);
  with BrowseGroupList do
  for i:=0 to count-1 do
    if Fmaj(strings[i])=stMod then
      if ok then CtField1(TitleList[i],PageList[i])
      else ok:=true;
  CtClose1;
end;

procedure TForm1.BuildSubChapter(stFile, stTitle, stId:string);
var
  stMod:string;
  i:integer;
  ok:boolean;
begin
  ok:=false;
  CtField1(stTitle,stID);
  CtOpen1;
  stMod:=Fmaj('Hpage_'+extractfilePath(nomMainFPS)+stFile);
  with SubBrowseGroupList do
  for i:=0 to count-1 do
    if Fmaj(strings[i])=stMod then
      CtField2(SubTitleList[i],SubPageList[i]);
  CtClose1;
end;


procedure TForm1.BuildContent;
var
  i,k:integer;
  st,stID:string;
  stMod:string;
begin
  assignFile(fContent,repHTML+'Elphy.hhc');
  rewrite(fContent);

  writeln(fContent,HTMLopen('Elphy content'));
  CtOpen1;


  BuildSubChapter('ElphyOverview.fps','Overview','Elphy');
  BuildSubChapter('ElphyDAQ.fps','Data Acquisition','ElphyDAQ');
  BuildSubChapter('ElphyAnalyzis.fps','Data Analyzis','ElphyAnalyzis');
  BuildSubChapter('VisualStim.fps','Visual Stimulation','ElphyVisualStim');
  BuildSubChapter('ElphyCommands.fps','Command Reference','ElphyCommands');


{**** Procedures and Functions:alphabetical order ***}
  if FlagEng
    then CtField1('Procedures And Functions : alphabetical order','ProcFoncs')
    else CtField1('Procédures et fonctions standard : ordre alphabétique','ProcFoncs');
  CtOpen1;
  for i:=0 to Procs.count-1 do
    begin
      st:=Procs.strings[i];
      CtField1(st,st);
    end;
  CtClose1;

{**** Procedures And Functions : thematic order ****}
  if FlagEng
    then CtField1('Procedures And Functions : thematic order','ProcThemes')
    else CtField1('Procédures et fonctions standard : classement par thèmes','ProcThemes');

  CtOpen1;

  if FlagEng then
    for i:=1 to high( stCatsEng) do
      CtField1(stCatsEng[i,1],stCatsEng[i,2])
  else
    for i:=1 to high( stCats) do
      CtField1(stCats[i,1],stCats[i,2]);


  CtClose1;

{**** The Objects ******}
  if FlagEng
    then CtField1('The Objects','The_objects')
    else CtField1('Les objets','Les_objets');
  CtOpen1;
  ObjNames.Sort;
  for i:=0 to ObjNames.count-1 do
    CtField1(ObjNames[i],ObjNames[i]);
  CtClose1;

{**** The Elphy Language ****}
  if FlagEng
    then BuildSubChapter('pg_elphy.fps','The Elphy Language','ProgElphy')
    else BuildSubChapter('pg_elphy.fps','Le langage Elphy','ProgElphy');


{**** Data Base Access ****}
  if FlagEng
    then CtField1('Data Base Access','DBUnic')
    else CtField1('L''accès aux bases de données','DBUnic');

{**** Constants ********}
  if FlagEng
    then CtField1('Constants','Constants')
    else CtField1('Les constantes','Constantes');
  CtOpen1;
  for i:=0 to constantes.count-1 do
    begin
      st:=constantes.strings[i];
      st:=FsupespaceFin(st);
      st:=FsupespaceDebut(st);
      stID:=FID(st);
      CtField1(st,stID);
    end;
  CtClose1;



  CtClose1;

  writeln(fContent,HTMLclose);
  CloseFile(fContent);
end;




{ THTMLpage }

constructor THTMLpage.create;
begin
  list:=TstringList.create;
end;

destructor THTMLpage.destroy;
begin
  list.Free;
  inherited;
end;

function THTMLpage.IsOpen: boolean;
begin
  result:=(fileName<>'');
end;

procedure THTMLpage.save;
begin
  if (fileName<>'') then list.SaveToFile(fileName);
  list.clear;
  fileName:='';
end;

procedure THTMLpage.writeln(st: string);
begin
  list.Add(st);
end;


procedure TForm1.FormCreate(Sender: TObject);
begin

  LoadParams;
  esFPS.setString(NomMainFPS,1000);
  esExe.setString(repExe,1000);
  esPas.setString(repPas,1000);
  esHTML.setString(repHTML,1000);
  esPRC.setString(NomBasePRC,1000);


end;

procedure TForm1.LoadParams;
var
  st,st1,stf:string;
  f:TextFile;
  k:integer;
begin
  setDefaultDirectories;

  stf:= extractFilePath(paramStr(0))+'PreHelp.cfg';
  if not fileExists(stf) then exit;

  assignFile(f,stf);
  reset(f);

  while not eof(f) do
  begin
    st:='';
    ReadLn(f, st);
    k:=pos('=',st);
    if k>0 then
    begin
      st1:=copy(st,1,k-1);
      delete(st,1,k);
      if st1='MainFps' then NomMainFps:=st
      else
      if st1='RepExe' then RepExe:=st
      else
      if st1='RepPas' then RepPas:=st
      else
      if st1='RepHTML' then RepHtml:=st
      else
      if st1='PRC' then NomBasePrc:=st;
    end;
  end;
  closefile(f);
end;

procedure TForm1.saveParams;
var
  f:textFile;
begin
  assignFile(f,extractFilePath(paramStr(0))+'PreHelp.cfg');
  rewrite(f);
  writeln(f,'MainFps='+NomMainFps);
  writeln(f,'RepExe=' +RepExe);
  writeln(f,'RepPas='+ RepPas);
  writeln(f,'RepHTML='+repHTML);
  writeln(f,'PRC='+ NomBasePRC);
  closefile(f);
end;

procedure TForm1.BchmClick(Sender: TObject);
var
  st:Ansistring;
begin
  st:= RepExe+'elphy.chm';
  HTMLhelp(0,Pansichar(st),HH_DISPLAY_TOPIC,0);
end;

procedure TForm1.resetAll;
var
  i:integer;
begin
    FreeAndNil(objNames);
    FreeAndNil(objAncetre);
    for i:=0 to 1000 do
    begin
      FreeAndNil(ObjProp[i]);
      FreeAndNil(ObjMethode[i]);
      FreeAndNil(DescriptionObj[i]);
    end;
    FreeAndNil(Constantes);
    FreeAndNil(Procs);

    stLine:='';
    stCom:='';
    stTexte:='';
    stBloc:='';
    directive:='';
    Fcom:=false;
    FdebutCom:=false;
    FfinCom:=false;
    FcomParEtoile:=false;
    lineNum:=0;

    stGroupe:='';

    nbConst:=0;
    numGroupe:=0;

    freeAndNil(description);

    currentObj:=0;
    currentSource:='';

    freeAndNil(catNames);
    freeAndNil(catTitles);

    for i:=0 to high(cats) do freeAndNil(cats[i]);
    setlength(cats,0);

    freeAndNil(DeclareList);

    freeAndNil(PageList);
    freeAndNil(TitleList);
    freeAndNil(BrowseGroupList);
    freeAndNil(SubPageList);
    freeAndNil(SubTitleList);
    freeAndNil(SubBrowseGroupList);

    freeAndNil(wordList);

    FlagENG:=true;

    freeAndNil(HTMLpage);

end;

procedure TForm1.BexeClick(Sender: TObject);
var
  form: TviewText;
  st:string;
begin
  UpdateAllVar(self);
  form:= TviewText.Create(self);

  form.Memo1.Text:= AnsiReplaceText(repExe, ';', crlf);

  if form.ShowModal=mrOK then
  begin
    repExe:= AnsiReplaceText(form.Memo1.Text, crlf, ';');
    UpdateAllCtrl(self);
  end;
  form.Free;
end;
(*
  NomMainFPS:string='d:\delphe5\dac2II.fps';     {  Param1 }
                                                 {  fichier FPS contenant une liste de fichiers inclus FPS }
  repEXE:string='d:\Dexe5\';                     {  Param2 }
                                                 {  Au final, le fichier prc et le fichier chm sont copiés dans ce répertoire }

  repPas:string='d:\delphe5\';
  {Param3 correspond à DebugPath qui est fixé dans Util1, c'est le répertoire des fichiers PAS
                                   Precompile (dans Precomp0) crée des fichiers PAS dans ce répertoire.
                                  }
  repHTML:string='d:\ElphyHTML\'; { Param4
*)


procedure TForm1.SetDefaultDirectories;
var
  stDir: AnsiString;
begin
  stDir:= extractFilePath(paramStr(0));
  delete(stDir,length(stDir),1);
  while (stDir<>'') and (stDir[length(stDir)]<>'\') do delete(stDir,length(stDir),1);

  NomMainFPS:= stDir+'Delphe5\Dac2II.fps';
  repExe:=stDir+'Dexe5\';
  repPas:= stDir+'Delphe5\';
  repHTML:=stDir+'elphyHTML\';

end;

end.
