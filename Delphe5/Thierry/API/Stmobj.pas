unit Stmobj;

INTERFACE

uses windows,sysUtils,DateUtils,
     classes, controls, forms, graphics,messages,menus,comCtrls,stdCtrls,Dialogs,
     util1,Gdos,Dgraphic,defForm,clock0,BMex1,DdosFich,
     stmdef,editCont,spk0,Dprocess,stmError,
     varconf1,
     KBlist0,
     formMenu,
     debug0,
     sysmask0,memoForm,

     Ncdef2;

  { typeUO est le type de base de tous les objets STM.

    Les principaux objets sont recensés dans deux listes:
      MainObjList qui contient les objets créés de façon interactive ainsi que les
      objets permanents comme datafile0, multigraph0,...
      La propriété Fmain de ces objets vaut True.

      TbObj qui contient les objets créés dans le programme Pg1. La propriété
        Fpg de ces objets vaut true.
      Certains objets sont aussi dans tbObj mais ont été créés ailleurs. ce sont
      les objets assignés par le programme: une variable objet désigne alors un objet
      créé ailleurs (la propriété Fpg de cet objet vaut false).

    Certains objets peuvent n'appartenir à aucune des 2 listes. A savoir:
      - les objets possédés par un autre objet. Exemple: datafile0.v1
      Leur propriété Fchild vaut true.
      - Les objets créés par le système (ex RF). Un tel objet n'est pas concerné par
      la sauvegarde et le chargement de mainList.



    Les opérations possibles sont les suivantes:

      Créer dans MainObjList:      cntRef:=1;

      Détruire dans MainObjList:   if cntRef>0 then dec(cntRef);
                                   if cntRf=0 then destroy

      Nouvelle référence dans MainObjList:
                                   (ex: un stim fait référence à un objet visuel)
                                   pour l'ancienne référence
                                      if cntRef>0 then dec(cntRef)
                                      if cntRf=0 then destroy
                                   pour la nouvelle référence
                                      inc(cntRef)

      Creer dans pg1:              cntRef:=1;

      Détruire dans pg1:           if cntRef>0 then dec(cntRef);
                                   if cntRf=0 then destroy

      Nouvelle référence dans pg1: affectation ou procédure modifiant une
                                   référence d'objet
                                   pour l'ancienne référence
                                      if cntRef>0 then dec(cntRef)
                                      if cntRef=0 then destroy
                                   pour la nouvelle référence
                                      inc(cntRef)

      Reset Pg1:                   on balaye la liste et pour chaque référence
                                   non vide, on appelle détruire dans pg1

  Les objets système sont créés avec cntRef=-1, ce qui empêche leur destruction


  9-10-98: L'inspecteur d'objet référence aussi les objets. Ce qui garantit que
  son pointeur obv0 est toujours valable.



  25-2-99: La méthode du pointeur de référence est peu satisfaisante surtout
  parce que l'utilisateur ne comprend pas ca qui se passe quand on détruit un
  objet.

  Je préfère donc la destruction autoritaire:
    - quand un objet détruit son enfant pu, il envoie d'abord un
      pu.messageToAll(UOmsg_Destroy) puis détruit son enfant pu.
    - un objet recevant UOmsg_Destroy doit libérer ses références à cet objet

    - le seul problème qui subsiste concerne les variables du programme qui ont
      été assignées:
        - l'appel à free dans le programme ne doit pas détruire l'objet
        - la destruction de l'objet dans l'inspecteur doit mettre la variable à
        nil


  Suite:

  Compromis entre compteur de référence et destruction autoritaire.

  On garde le compteur de référence pour TOUS les objets.
  Les clients (exemple: MG et graph) appellent referenceObjet et dereferenceObjet.

  Le PG1 appelle referenceObjet dans create et assign
         appelle dereferenceObjet dans free et create, et dans resetPg

  Pour une destruction autoritaire, on verifie le compteur de références:
    - s'il vaut 1, on détruit l'objet
    - s'il est >1, on envoie messageToAll(UOmsg_Destroy)
    - si cntref vaut alors 1, on détruit l'objet

  Ceci est efficace car on n'envoie pas le message à tous s'il n'y aucune
  référence.

  Les objets qui gèrent autoritairement leurs enfants (ex:TdataFile) ne sont pas
  obligés d'utilisé le cntref mais ce serait plus efficace.

  Les objets sont détruits autoritairement
  - par l'inspecteur d'objets pour les objets de mainObjList
  - par resetPg, par free dans Pg1 à condition que l'objet appartienne à PgListe.

  En fait, cntref ne suffit pas pour déterminer si la destruction est autorisée.
  Donc, on rajoute un flag Fmain qui identifie les objets de MainObjList.

  }

const
  LoadingObjects:boolean=false;
  {Pendant le chargement des objets, ce flag est mis à true.
   Ce qui entraîne le blocage des messageToAll.
  }
  FLoadObjectsMINI:boolean=false;
  {On peut imposer un chargement entrainant un encombrement minimum en
   positionnant ce flag.
   Est utilisé par dataFIle.
  }
type
  TUOclass=class of typeUO;
  TformClass=class of Tform;
  TUOstatus=(UO_Main,UO_Temp,UO_PG);

  typeUO=
         class
           ident0:string[30];

           MyAd:pointer;     { adresse de l'objet }
           { sert à mémoriser les références entre objets }
           { création: reçoit self
             Myad est sauvée dans les fichiers de configuration.
             Après chargement, MyAd contient donc l'adresse à la précédente
             session et les objets qui pointaient sur cet objet contiennent
             aussi cette valeur.
             RetablirReferences permet, en utilisant myAd, de rétablir les
             références entre objets qui existaient au moment de la sauvegarde.
             MainObjList.RetablirReferences remet self dans myAd.

             Le gros défaut de la méthode est qu'il faut sauver et charger la totalité
             des objets, sinon les pointeurs ne signifient rien.
             Si on sauvait les références par nom, on pourrait sauver et charger
             des configurations partielles.
           }

           Fstatus:TUOstatus;

           NotPublished:boolean;{ N'apparaitra pas dans l'inspecteur d'objets }

           Fchild:boolean;   {vaut true quand l'objet est créé et détruit
                              automatiquement par un autre objet
                              Exemple: v1, v2.. dans TdataFile
                              Dans l'inspecteur d'objets, ces objets apparaissent
                              effectivement comme les enfants d'un autre objet.
                              }
           Fsystem:boolean;  {l'objet appartient au système. Destruction interdite}
           FsingleLoad:boolean;{l'objet ne doit être chargé qu'au lancement de Dac2}
           stComment:string; {Commentaire utilisé quand on sauve l'objet dans un fichier OAC}

           reference:Tlist;  {liste des objets référenceurs. La liste est complétement
                              passive et sert à accélérer certaines opérations.
                             }

           tagUO:integer;    {tag à la manière Delphi}

           childList:Tlist;  {pour initialiser l'inspecteur d'objet avec ses enfants, un
                              objet peut se contenter de remplir childList avec ses enfants
                             }
           UOowner:typeUO;  {UOwner désigne le propriétaire de l'objet.
                             Pour les objets créés par programme, UOowner contient l'objet TPG2
                             Pour les objets enfants, UOowner contient le propriétaire
                             UOowner est positionné par addToChildList.

                             UOowner est sauvé mais pas chargé par save/load
                             UOowner pourrait être utilisé pour identifier les parents et
                             enfants dans un fichier.

                             Reçoit les messages de MessageToRef.
                             }
           PgAd:pointer;    {positionnée par createPgObject
                            }

           function getIdent:string;
           procedure setIdent(st:string);virtual;

           function getTitle:string;virtual;
           procedure setTitle(st:string);virtual;

           function getReadOnly:boolean;virtual;
           procedure setReadOnly(v:boolean);virtual;

           procedure setFlagOnScreen(v:boolean);virtual;

           function getOnScreen:boolean;virtual;
           procedure setOnScreen(v:boolean);virtual;

           procedure setFlagOnControl(v:boolean);virtual;

           function getOnControl:boolean;virtual;
           procedure setOnControl(v:boolean);virtual;

           function getLocked:boolean;virtual;
           procedure setLocked(v:boolean);virtual;

           function getDispPriority:integer;virtual;

           function getIsOnScreen:boolean;virtual;
           procedure setIsOnScreen(v:boolean);virtual;

           function getIsOnCtrl:boolean;virtual;
           procedure setIsOnCtrl(v:boolean);virtual;

           class function STMClassName:string;virtual;
                             { renvoie le nom du type d'objet STM }
           {class function PgClassName:string;virtual;
                             renvoie le nom du type d'objet dans le langage }


           property OnScreen:boolean read GetOnScreen  write SetOnScreen;
           property OnControl:boolean read GetOnControl write setOnControl;
           property Locked:boolean read GetLocked write SetLocked;

           property FlagOnScreen:boolean read GetOnScreen  write SetFlagOnScreen;
           property FlagOnControl:boolean read GetOnControl write setFlagOnControl;

           property DispPriority:integer read getDispPriority;
             {0 en général, 1 pour les matrices
              Sur l'écran de controle, les matrices doivent
              s'afficher en arrière plan
              Sur l'écran de controle, on affiche d'abord tous les
              objets de priorité 1 puis tous ceux de priorité 0
              }

           property isOnScr:boolean read GetIsOnScreen write setIsOnScreen;
           property isOnCtrl:boolean read GetIsOnCtrl write setIsOnCtrl;
              { Repère les objets affichés sur l'écran de stimulation ou de contrôle
                avant le lancement d'une animation
              }

           property title:string read getTitle write setTitle;
           property ident:string read getIdent write setIdent;

           property readOnly:boolean read getReadOnly write setReadOnly;

           procedure creerRegions;virtual;
           procedure detruireRegions;virtual;

           procedure afficheS;Virtual;
           procedure afficheC;Virtual;
           procedure afficheMask;Virtual;
           procedure freeBM;virtual;


           constructor create;virtual; { Tous les create doivent être override }
           destructor destroy;override;{ id }

           {procedure setName(st:string);}

           function DialogForm:TclassGenForm;virtual;
           procedure installForm(var form:TgenForm;var newF:boolean);
           { Ces 6 procédures sont utilisées uniquement par inspobj2 }

           procedure installDialog(var form:TgenForm;var newF:boolean);virtual;
           procedure completeDialog(var form:TgenForm);virtual;
           procedure extraDialog(sender:Tobject);virtual;
           procedure Paint(priorite:Integer);         virtual;


           procedure display;                         virtual;
           {affichage standard de l'objet dans MultiGraph.
            Appelé par MG pour le 1ER objet d'une fenêtre}
           procedure displayEmpty;                    virtual;
           {affichage des coordonnées seules}

           procedure displayGUI;virtual;
           {Affichage sur le GUI de Multigraph pour des aff. temporaires}

           procedure swapContext(numW:integer;var varPg:TvarPg1;ContextPg:boolean);virtual;

           procedure displayInside(FirstUO:typeUO;
                                   extWorld,extparam,logX,logY:boolean;
                                   mode,taille:integer);virtual; {=display}
           {affichage sans les graduations.
            MG appelle la méthode pour les objets autres que le 1er avec extWorld=false,
            Dans ce cas, les params logX,logY,mode,taille sont ignorés.
            la méthode est aussi appelée par Pg1displayObject avec extWorld=true.
           }
           function getInsideWindow:Trect;virtual;

           function getTitleColor:integer;virtual;
           function Plotable:boolean;virtual;

           function WithInside:boolean;virtual;
           {Certains objets ont un intérieur (Tvector, Tmatrix) dans lequel
            on peut afficher d'autres objets.
            D'autres n'en ont pas (Tmemo)
           }
           procedure getWorldPriorities(var Fworld,FlogX,FlogY:boolean;
                               var x1,y1,x2,y2:float);virtual;
           {Les objets WithInside peuvent imposer certains paramètres de World
            pour les objets affichés dans leur intérieur.
            Tvector et Tmatrix imposent seulement modeLogX et modeLogY.
            Tcoo impose tout le world.
           }

           {Les objets TdataPlot ont une propriété displayCursors qui est appelée
           par Multigraph.
           Quand MG veut afficher des curseurs, il sélectionne le cadre puis appelle
           displayCursors de tous les objets contenus dans la fenêtre.

           Ces objets fixent setWorld puis appellent à leur tour la méthode PaintCursor de
           leurs références.}
           procedure displayCursors(BMex:TbitmapEx);virtual;

           { Les curseurs ont une méthode PaintCursor. Quand la méthode est appelée, le
           cadre et le world sont en place. }
           procedure paintCursor(BMex:TbitmapEx);virtual;

           { InvalidateCursors est appelé par TLcursor (méthode de son obref de type TdataPlot)
           pour lui demander de le réafficher.
             La méthode InvalidateCursors de TdataPlot invalide sa propre fenêtre
           puis lance un message UOmsg_cursor.

           UOmsg_cursor est ensuite reçu par MG qui invalide sa fenêtre
           }
           procedure InvalidateCursors;virtual;

           {Les 3 procédures suivantes sont utilisées dans Stim2 pour gérer la
           fenêtre Contrôle.
           }


           function MouseDown(Button: TMouseButton;
                          Shift: TShiftState; X, Y: smallInt):boolean;
                                                      virtual;
           function MouseMove(Shift: TShiftState;
                          X, Y: smallInt):smallInt;     virtual;
           procedure MouseUp(Button: TMouseButton;
                           Shift: TShiftState; X, Y: smallInt);
                                                      virtual;


           { Cette procédure est utilisée soit en interne, soit par HKpaint0 }
           procedure majPos;virtual;

           { Montrer et cacher les poignées }
           procedure drawHandle(x,y:smallInt);
           procedure ShowHandles;virtual;

           {
           MouseDownMG est utilisée pour gérer les clics de la souris dans
           l'objet MultiGraph.
           Au moment de l'appel, le cadre multigraph dans lequel se trouve l'objet
           est sélectionné et getWindowG permet d'obtenir les coo de ce cadre.
           Irect contient le rectangle intérieur.

           Exemple: TvectorList (stmVlist1) gère ces clics pour selectionner
           des traces.

           numOrdre est le numéro d'ordre dans le cadre multigraph (commence à 0).
           Xc et Yc sont les coordonnées écran du cadre.
           X et Y sont les coordonnées du clic dans le cadre.

           La fonction doit renvoyer True si une action a été entreprise.
           }
           function MouseDownMG(numOrdre:integer;Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean; virtual;

           function MouseMoveMG(x,y:integer):boolean;virtual;
           procedure MouseUpMG(x,y:integer);virtual;

           function MouseRightMG(ControlSource:Twincontrol;numOrdre:integer;Irect:Trect;
                Shift: TShiftState; Xc,Yc,X,Y: Integer;var uoMenu:typeUO):boolean; virtual;

           {
           MouseDownMG2 joue le même rôle que MouseDownMG mais au deuxième niveau.
           Par exemple, quand MouseDownMG d'un vecteur est appelée, elle doit appeler
           à son tour MouseDownMG2 des objets référenceurs (les curseurs associés au
           vecteur par exemple).
           }
           function MouseDownMG2(Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean; virtual;

           function MouseMoveMG2(x,y:integer):boolean;virtual;
           procedure MouseUpMG2(x,y:integer);virtual;
           function MouseRightMG2(numOrdre:integer;Irect:Trect;
                Shift: TShiftState; Xc,Yc,X,Y: Integer;var uoMenu:typeUO):boolean; virtual;



           {permet de créer un menu Popup associé à l'objet.
            Les modèles de popup sont dans stmPopUp }
           function getPopUp:TpopupMenu;virtual;


           procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);virtual;
           {contient une suite de setVarConf propre à l'objet}
           {tout est vrai en général mais false quand on appelle loadinfo}

           procedure completeLoadInfo;virtual;
           {Opérations à réaliser immédiatement après chargement d'un objet
            Ex: mise en place des paramètres secondaires.
            A cet instant, les références à d'autres objets ne sont pas valables.

            Pour tenir compte de ces références, il faut utiliser ResetAll.
           }

           procedure completeSaveInfo;virtual;


           {Opérations à réaliser après Sauvegarde d'un objet
            Ex: libérations de variables temporaires utilisées pour le stockage
           }

           {Pour sauver et charger un objet, on utilise saveObject et loadObject.
            Chaque objet peut réécrire complètement ces 2 procédures en respectant
            la structure d'un bloc:
              - un mot de 4 octets représentant la taille totale du bloc
               (y compris ces 4 octets)
              - un mot clé string de longueur quelconque identifiant l'objet:
                ici, obligatoirement stmClassName.
              - des données quelconques

            Il faut aussi sauver ident et myAd

            Plus simplement, on peut seulement surcharger buildInfo qui dresse une
            liste de variables à sauver ou charger. Il faut toujours appeler
            inherited buildinfo.

            En pratique, quand saveObject est réécrit, c'est pour sauver des objets
            enfants juste après l'objet principal.

           }
           procedure saveToStream(f:TStream;Fdata:boolean);virtual;
           procedure saveToStream0(f:TStream;Fdata:boolean);

           procedure saveObject(var f:file;Fdata:boolean);
           {Appelle buildInfo et sauve le blocConf sur le disque
           }

           function loadFromStream(f:Tstream;size:longWord;Fdata:boolean):boolean;virtual;

           {f pointe après le nom du bloc et l'objet vient d'être identifié
            loadObject charge les info disponibles
            size est la taille totale du bloc. Après le pointeur fichier, il y a donc
            (size-4-1-length(nom)) octets.

            Quand un objet est propriétaire d'autres objets, ces objets sont sauvés
            immédiatement après. LoadObject doit charger les objets possédés.

            La valeur renvoyée par la fonction n'est en fait pas utilisée.
            }
           function loadObject(var f:file;size:LongWord;Fdata:boolean):boolean;

           function loadAsChild(f:Tstream;Fdata:boolean):boolean;
           {Quand un objet possède d'autres objets, il stocke ces objets juste
           après lui. Quand il les recharge, il s'attend à trouver un objet
           du bon type avec la propriété Fchild ou NotPublished(pour les anciens objets).

           avec loadAsChild l'objet essaie de se charger. Si les conditions ci-dessus ne
           sont pas remplies, il replace le pointeur de fichier là où il l'a trouvé.
           }

           {Les deux procédures suivantes ne sont utilisées que par tobject_LoadInfo}

           function LoadInfo(f:Tstream;num:smallInt;tailleInfo:integer):boolean;
           function LoadInfoDat(num:smallInt):boolean;



           procedure chooseCoo(sender:Tobject);virtual;

           {Initialise est appelé quand l'utilisateur à choisi de créer un objet
           dans Object/New . Voir NouvelObjet1 .
           L'objet vient d'être créé et on lui donne le nom st. Certains objets doivent
           donner un nom aux objets possédés.
           Parfois, on ouvre un dialogue pour inviter l'utilisateur à fixer certains
           paramètres.
           Si la fonction renvoie false, l'objet qui vient d'être créé est détruit.
           }
           function initialise(st:string):boolean;virtual;

           {Par défaut isVisual vaut FALSE. IsVisual vaut TRUE pour les objets visuels
           et certains objets (Tmatrix) qui peuvent s'afficher sur l'écran de controle
           du SV. Quand isVisual=TRUE , l'objet est ajouté à la liste HKpaint à la création.
           }
           function isVisual:boolean;virtual;

           procedure RetablirReferences(list:Tlist);virtual;
           {
            Quand un objet contient des sous-objets, RetablirReferences doit
            appeler RetablirReferences des sous-objets.

            Le 22-9-99, les objets avec réf sont  Acquis1, graphe, Multigraph,
            Stim, Curseur et Fit.

            RetablirReferences ne doit pas appeler des procédures faisant
            intervenir d'autres objets (ex: affichage dans Tmultigraph) car
            toutes les références ne sont pas encore en place.

            En fait, RetablirReferences doit agir comme si les autres objets
            n'existaient pas.
           }
            procedure resetAll;virtual;
           {
            Après RetablirReferences, resetToAll est appelé. L'objet est invité
            à se réafficher complètement où à prendre en compte l'existence des
            autres objets.
           }

           procedure ClearReferences;virtual;
           {Si on charge un objet seul, il faut lui dire de remettre à nil ses
           éventuelles références (celles qui ont été chargées).
           En fait, si BuildInfo est bien écrite, le chargement d'un objet laisse
           les références à nil, ces références étant chargées provisoirement
           ailleurs. C'est le cas de Tgraph ou TmultiGraph.  ClearReferences
           est alors inutile.
           }
           procedure FreeRef;virtual;
           {Libère les références.
           Si on charge un objet d'un fichier dans un objet existant déjà,
           il faut supprimer les références existantes.
           }

           procedure resetMyAd;
           {range self dans myAd
           }
           procedure setChildNames;virtual;
           {Propage le nom de l'objet dans les objets enfant
           }
           function clone(Fdata:boolean):typeUO;virtual;
           procedure loadFromObject(uo:typeUO;Fdata:boolean);

           procedure copyDataFrom(p:typeUO);virtual;

           function getSysListPosition:integer;

           procedure MessageToAll(id:integer;p:pointer);
           procedure ProcessMessage(id:integer;source:typeUO;p:pointer);
               virtual;

           function controleRef(p:typeUO):boolean;
           function MessageToRef(id:integer;p:pointer):integer;
           {17-10-02: renvoie le nb de messages effectivement traités
                      De plus, le message n'est envoyé qu'une fois quand la reflist
                      contient plusieurs fois le même objet.
           }

           function getWindowHandle:integer;virtual;
           procedure show(sender:Tobject);virtual;



           procedure addToTree(tree:TtreeView;node:TtreeNode);virtual;
           { addToTree ajoute le nom de l'objet (et son adresse) au noeud node
           de l'arbre tree. Si l'objet possède des objets enfants, ces enfants
           seront accrochés au noeud node.

             Depuis le 7-02-06, les noeuds sont développés par expandTree.
             Il n'est pas nécessaire de sucharger cette méthode sauf si on veut
           compliquer l'arborescence comme dans TdataFile.
             En général, l'objet se contente de ranger ses enfants dans childList.
           }

           function expandTree(tree:TtreeView;node:TtreeNode):boolean;virtual;
           { Développe un noeud dans l'inspecteur d'objet.
             Si on réécrit addToTree, il faut aussi surcharger expandTree sauf si
             addToTree met tout en place.
           }

           procedure saveData(f:Tstream);virtual;
           function loadData(f:Tstream):boolean;virtual;

           {save et load permettent de sauver/charger les objets avec les
            données qu'ils contiennent
            save appelle saveObject puis saveData
            load appelle loadObject puis loadData
            }
           procedure saveAsSingle(var f:file);virtual;
           function loadAsSingle(var f:file):boolean;virtual;


           function loadX(f:Tstream):boolean;virtual;

           function readDataHeader(f:Tstream;var size:integer):boolean;
           {Size est la taille des data}
           procedure writeDataHeader(f:Tstream;size:integer);
           {Size est la taille des data}

           function getInfo:string;virtual;
           { getInfo est utilisé par le visionneur d'objets}

           procedure bringToFront;
           { bringToFront concerne seulement les objets visuels de priorité 1
             (les matrices)
           }

           procedure refObjet(pu:typeUO);
           procedure derefObjet(var pu:typeUO);
           function refCount:integer;

           procedure specialDrop(Irect:Trect;x,y:integer);virtual;


           procedure initChildList;virtual;
           procedure clear;virtual;
           procedure invalidate;virtual;

           procedure setEmbedded(v:boolean);virtual;
           function getEmbedded:boolean;virtual;
           property Embedded:boolean read getEmbedded write setEmbedded;
           function EmbeddedForm:Tform;virtual;

           function CanEmbedForm:boolean;virtual;

           procedure addToStimList(list:Tlist);virtual;

           procedure AddToChildList(uo:typeUO);
           {Ajoute uo à ChildList, positionne uo.Fchild et uo.UOowner}
           procedure ClearChildList;

           procedure CreateClone(sender:Tobject);virtual;
           {Appelé par la commande popup Clone}

           procedure saveObjectToFile(sender:Tobject);virtual;
           {Appelé par la commande popup Save Object}


           procedure Verify;
           function isModified:boolean;virtual;

           procedure swapFont(var font:Tfont;var color:integer);virtual;
           {Echange la fonte de l'objet avec celle qui est fournie en paramètre
            On échange les pointeurs }

           class function PgType:integer;
           {Renvoie le numéro de type dans un programme PG2}

           class function PgDescendantOf(num:integer):boolean;
           {l'objet descend-t-il du numéro num ? }

           function PgAddress:pointer;
           {revoie l'adresse de la variable qui a créé l'objet ou bien myAd}
         end;


  PPUO=^typeUO;             { Adresse d'une adresse de typeUO }


type
  TgenreUO=(Orien,obvis,stim,data,sys,tools);
var
  UOnameList:array[TgenreUO] of TstringList;


type
  TMainObjList=class(Tlist)
                  uoBase:typeUO;

                  constructor create;
                  destructor destroy;override;

                  function firstName(st:string):string;
                  function existe(st:string):boolean;
                  function accept(st:string):boolean;
                  function getAd(st:string):typeUO;
                  procedure add(p:typeUO;status:TUOstatus);
                  procedure supprime(p:typeUO);

                  procedure clear(tout:boolean);

                  procedure loadFromStream(f:Tstream;tailleInfo:integer;tout:boolean);
                  procedure loadObjects(var f:file;tailleInfo:integer;tout:boolean);

                  {Tout=true pour la cfg de base}
                  procedure saveObjects(var f:file);

                  procedure RetablirReferences;
                  procedure resetAll;
               end;

var
  MainObjList:TMainObjList;

  stmTresizable:TUOclass;


type
  {syslist (de type TsystemList) contient TOUS les objets UO existant
  Tous les objets UO se rangent eux-mêmes dans cette liste au moment de leur
  création et se retirent au moment de leur destruction.
  }
  TsystemList=class(Tlist)
                FModified:boolean;   {utilisé par l'inspecteur d'objet}
                constructor create;
                function Add(Item: Pointer): Integer;
                function Remove(Item: Pointer): Integer;
                procedure Delete(Index: Integer);
                procedure inspect;
                procedure clear;
                function ObjectByName(st:string):typeUO;
                function existe(st:string):boolean;

                procedure FillTreeView(treeView:TtreeView;var ob:typeUO;Fsort:boolean);
              end;


var
  sysList:TsystemList;


{ TGvariant pose un problème: dans Delphi, quand un record est passé par valeur à une procédure,
  le système s'efforce de maintenir le compteur de référence des chaines longues contenues dans
  le record.

  TGvariant a le type object, sans constructeur, sans méthodes virtuelles, afin de pouvoir
  le considérer comme un record auquel sont associées des méthodes.
  Dans cette situation, la gestion du compteur de références fonctionne mal.

  Il faut donc impérativement éviter le passage de TGvariant par valeur, sinon on obtient des
  pertes de mémoire.

}

type
  TGVariantType = (gvNull, gvBoolean, gvInteger, gvFloat, gvString, gvDateTime, gvObject);

  TrefUO=class;

  TrecGvariant= record
                  VString: AnsiString;
                case VType: TGVariantType of
                  gvBoolean:    (VBoolean: Boolean);
                  gvInteger:    (VInteger: Int64);
                  gvFloat:      (VFloat: Extended);
                  gvDateTime:   (VdateTime:TdateTime);
                  gvObject:     (Vobject:TrefUO);
                end;




  TGvariant=object                               {15 octets}
            public
              rec:TrecGvariant;
              procedure setString(w:string);
              procedure setBoolean(w:boolean);
              procedure setInteger(w:int64);
              procedure setFloat(w:float);
              procedure setDateTime(w:TdateTime);

              procedure setObject(w:TypeUO);
              function getObject:typeUO;
            public
              property Vtype:TGvariantType read rec.Vtype write rec.Vtype;
              property Vstring:string read rec.Vstring write setString;
              property Vboolean:boolean read rec.Vboolean write setboolean;
              property Vinteger:int64 read rec.Vinteger write setinteger;
              property Vfloat:float read rec.Vfloat write setfloat;
              property VdateTime:TdateTime read rec.VdateTime write setdateTime;
              property Vobject:TypeUO read getObject write setobject;

              procedure init;
              procedure finalize;

              function VarAddress:pointer;
              procedure AdjustObject;
              procedure showStringInfo;
              function Usize:integer;
              function getValString(const Ndeci:integer=6):string;
            end;

  PGvariant=^TGvariant;
  TGvariantArray=array of TGvariant;

  TrefUO= class(typeUO)
            refUO:typeUO;
            MyVariant:PGVariant;
            procedure ProcessMessage(id:integer;source:typeUO;p:pointer);override;
            constructor create;override;
            destructor destroy;override;
          end;

Const
  GvariantSize=sizeof(TrecGvariant);

procedure copyGvariant(var src:TGvariant;var dest:TGvariant);
{
procedure FloatToGV(var gv:TGvariant;w:float);
procedure IntegerToGV(var gv:TGvariant;w:integer);
procedure BooleanToGV(var gv:TGvariant;w:boolean);
procedure StringToGV(var gv:TGvariant;w:string);
procedure DateTimeToGV(var gv:TGvariant;w:Tdatetime);
}


{ un UO peut envoyer un message à tous les autres objets avec MessageToAll
  un UO reçoit ces messages avec ProcessMessage }

{ UOmsg_invalidate signale que la source a été modifiée et qu'il est nécessaire de
  réafficher.

  UOmsg_update est utilisé par Daffac1.

  UOmsg_Coupling signale aux objets couplés qu'il est nécessaire de modifier
  leurs coordonnées et de se réafficher.

  UOmsg_destroy signale que l'objet source va être détruit de façon autoritaire
  et qu'il est nécessaire de couper toutes les références à cet objet.

  UOmsg_cursor est envoyé par Tcursor pour signaler qu'il doit être affiché ou
  effacé

  UOmsg_SimpleRefresh est envoyé par l'objet lui-même pour forcer son réaffichage
  partiel. Le mécanisme est le suivant:
  un flag interne est positionné. Le message est envoyé. La méthode Display est donc
  appelée une ou plusieurs fois. Compte tenu du flag interne, l'objet réaffiche ce
  qu'il voulait faire réafficher. Le flag est ensuite effacé.
  A la différence de UOmsg_invalidate, le cadre multigraph ne sera pas effacé au
  préalable.

  UOmsg_DisplayGUI est un envoyé par un objet à un objet multigraph (par exemple)
  pour lui signaler qu'il souhaite afficher quelque chose temporairement.
  En retour, Multigraph
     - sélectionne le canvas de l'écran
     - sélectionne le (ou les cadres) et réaffiche son BM
     - appelle DisplayGUI de l'objet

}

const
  UOmsg_invalidate=1;
  UOmsg_update=2;
  UOmsg_destroy=3;
  UOmsg_coupling=4;
  UOmsg_cursor=5;

  UOmsg_FreeHardBM=6;

  UOmsg_SimpleRefresh=7;
  UOmsg_invalidateAcq=8;
  UOmsg_AutoscaleAcq=9;

  UOmsg_sendToBack=10;
  UOmsg_BringToFront=11;

  UOmsg_colorsChanged=12;

  UOmsg_addObject=13;
  UOmsg_DisplayGUI=14;

  UOmsg_invalidateData=15;
  UOmsg_PaintEmpty=16;

  UOmsg_LineCoupling=17;

  UOmsg_releaseMenu=18;

  UOmsg_SetLevelAcq=19;

{ FlagClock de type ThreadFclock est un timer lancé avec DAC2. Il positionne dix
flags toutes les 100 ms.
Le numéro 1 est réservé aux programmes.
Le numéro 2 est utilisable par les opérations de calcul devant être interrompues
}

type
  ThreadFclock=class(Tthread)
                 Flag:array[1..10] of boolean;
                 procedure execute;override;
               end;

var
  FlagClock:ThreadFclock;


{Tentative d'unifier les drag and drop.

 On part du principe qu'il n'y a qu'une seule opération de DnD à la fois.
 A la source, en appelant BeginDrag, on positionne les deux objets ci-dessous.

 On remarquera que l'objet source dans les gestionnaires d'événement Dnd est un
composant Delphi, pas un UO.

 ResetDragUO remet les deux variables à nil . Le plus simple est d'appeler ResetDragUO
 dans EndDrag.
 ResetDragUO serait nécessaire si on introduisait d'autres formes de DnD dans Elphy.
 Actuellement, c'est juste une sécurité.
}

var
  DragUOsource:typeUO;
  DraggedUO:typeUO;


  FlagObjectFile:boolean; {Positionné par TobjectFile pour empêcher de charger
                           un objet Multigraph dans formStm }


var
  HKpaint:Tsystemlist;

  FirstUOpopup:typeUO;    {affecté dans multigraph.mouseDown}  

procedure resetDragUO;


function getFlagClock(num:integer):boolean;



function NomParDefaut0(st0:string):string;
function NomControle(ref:TUOclass;name:string):string;

{ On donne stmClassName (pas de T au début), on obtient la classe }
function StmClass(stMot:string):TUOclass;

function createUO(stMot:string;tout:boolean):typeUO;
{ createUO crée un objet dont le type correspond à stMot=stmClassName avec un
  nom par défaut.
  renvoie nil si stMot n'existe pas
  Tout ne concerne que VisualStim. Si Tout est vrai, VisualStim est chargé
  }
function readHeader(f:Tstream;var size:longWord):string;
{ Lit l'entête de bloc (size+motClé) . Le pointeur de fichier se trouve
  ensuite après cet entête
}

function readAndCreateUO(f:Tstream;status:TUOstatus;tout:boolean;Fdata:boolean):typeUO;
{ Lit l'entête de bloc (size+motClé) puis essaie de créer l'objet.
  A la fin, le pointeur de fichier se trouve toujours à la fin du bloc.
  Renvoie l'objet ou bien NIL
  pg positionne le flag FPG.
  Tout ne concerne que VisualStim. Si Tout est vrai, VisualStim est chargé
}

procedure verifierObjet(var pu:typeUO);


procedure proTSystem_ControlON(ww:boolean;var pu:typeUO); pascal;
function fonctionTSystem_ControlON(var pu:typeUO):boolean; pascal;


function fonctionAssigned(var pu:typeUO):boolean; pascal;


function fonctionTobject_loadInfo(num:smallInt;var pu:typeUO):boolean;pascal;
function fonctionTobject_sysname(var pu:typeUO):String;pascal;

function fonctionTobject_tag(var pu:typeUO):integer;pascal;
procedure proTobject_tag(w:Integer;var pu:typeUO);pascal;

function fonctionTobject_stCom(var pu:typeUO):String;pascal;
procedure proTobject_stCom(w:String;var pu:typeUO);pascal;



function GetGlobalList(tp:TUOclass;withRF:boolean):Tlist;
function getGlobalObject(st:string):typeUO;

procedure InstalleComboBox(cb:TcomboBox;ob:TypeUO;TUO:TUOclass);
function recupComboBox(cb:TcomboBox):pointer;

{function WaitVideo:boolean;}
procedure registerObject(ref:TUOclass;genre:TgenreUO);
{range le type et le nom de l'objet dans UOnameList }
{Les objets enregistrés
  - seront reconnus au moment du chargement.
  - apparaitront dans le menu Object/New sauf si leur catégorie est sys.
}

procedure PrintUOnameList;

function nouvelObjet(numType:integer):boolean;
{Appelée par le menu Object/New }

function nouvelObjet1(UOclass:TUOclass):typeUO;
{cree l'objet de type UOclass
 propose un changement de nom
 appelle initialise
 range l'objet dans MainObjList
}

function CreerObjet(tp:TUOclass):typeUO;
{ Idem mais sans appeler Initialise
}

function CloneObjet(p:typeUO):typeUO;

function UOident(uo:typeUO):string;

{procedure createDDscreen;}

procedure proDragDropObject(var dest:typeUO);pascal;

type
  TdataHeader=record
                size:integer;
                st:string[5];
              end;


procedure PrintStmClassName;


type
  TUOlist=class(Tlist)
  private
     function getUO(i:integer):typeUO;
     procedure putUO(i:integer;p:typeUO);
  public
     property Items[Index: Integer]: typeUO read GetUO write PutUO; default;
  end;

procedure proTObject_save(var obF, pu:typeUO);pascal;
procedure proTObject_load(var obF, pu:typeUO);pascal;
function fonctionTObject_load1(var obF, pu:typeUO):boolean;pascal;

procedure proTObject_saveSingleData(var binF, pu:typeUO);pascal;
procedure proTObject_loadSingleData(var binF, pu:typeUO);pascal;

procedure proTObject_loadObject(stF:String;var pu:typeUO);pascal;
procedure proTObject_SaveAsObject(stF:String;var pu:typeUO);pascal;


procedure initStmObj;




IMPLEMENTATION


uses binFile1,ObjFile1,objName1,saveObj1,stmdf0,stmPg,dacadp2;


{**************************** Méthodes de typeUO **************************}

constructor typeUO.create;
  begin
    inherited create;
    myAd:=self;
    ident:='_'+stmClassName;

    sysList.add(self);                  { ATTENTION l'appel de create comme procédure ordinaire }
    if isVisual then HKPaint.add(self); { est impossible à cause de ces instructions. }

  end;

destructor typeUO.destroy;
  begin

    onScreen:=false;
    onControl:=false;

    detruireRegions;

    if isVisual then HKPaint.remove(self);

    sysList.remove(self);

    inherited destroy;

    messageToRef(UOmsg_destroy,nil);
    {Les objets doivent appeler messageToRef(UOmsg_destroy,nil) de préférence
     au début de destroy }

    reference.free;
    reference:=nil;
    childList.free;
  end;

class function typeUO.STMClassName:string;
  begin
    STMClassName:='';
  end;


function typeUO.getOnScreen:boolean;
begin
  result:=false;
end;

procedure typeUO.setOnScreen(v:boolean);
begin
end;

function typeUO.getOnControl:boolean;
begin
  result:=false;
end;

procedure typeUO.SetOnControl(v:boolean);
begin
end;

procedure typeUO.setFlagOnScreen(v:boolean);
begin
end;

procedure typeUO.setFlagOnControl(v:boolean);
begin
end;

function typeUO.getLocked:boolean;
begin
  result:=false;
end;

procedure typeUO.setLocked(v:boolean);
begin
end;

function typeUO.getDispPriority:integer;
begin
  result:=0;
end;


function typeUO.getIsOnScreen:boolean;
begin
  result:=false;
end;

procedure typeUO.setIsOnScreen(v:boolean);
begin
end;

function typeUO.getIsOnCtrl:boolean;
begin
  result:=false;
end;

procedure typeUO.setIsOnCtrl(v:boolean);
begin
end;

procedure typeUO.creerRegions;
begin
end;

procedure typeUO.detruireRegions;
begin
end;

procedure typeUO.drawHandle(x,y:smallInt);
begin
  with DXcontrol.canvas do
  begin
    pen.Style:=psSolid;
    pen.color:=clWhite;
    brush.color:=clWhite;
    brush.style:=bsSolid;

    rectangle(x-2,y-2,x+2,y+2);
  end;
end;

procedure typeUO.ShowHandles;
begin
end;


procedure typeUO.afficheC;
begin
end;



procedure typeUO.afficheS;
begin
end;

procedure typeUO.afficheMask;
begin
end;

procedure typeUO.freeBM;
begin
end;

procedure typeUO.majPos;
begin
  if oncontrol then HKpaintPaint;
  if onscreen then HKpaintScreen;
end;


procedure typeUO.paint(priorite:integer);
begin
  if priorite<>DispPriority then exit;
  afficheC;
end;

procedure typeUO.display;
begin
end;

procedure typeUO.displayEmpty;
begin
  display;
end;

procedure typeUO.displayGUI;
begin
end;

procedure typeUO.swapContext(numW:integer;var varPg:TvarPg1;ContextPg:boolean);
begin
end;

procedure typeUO.displayInside(FirstUO:typeUO;extWorld,extParam,logX,logY:boolean;mode,taille:integer);
begin
  display;
end;

function typeUO.getInsideWindow:Trect;
var
  x1,y1,x2,y2:integer;
begin
  getWindowG(x1,y1,x2,y2);
  getInsideWindow:=rect(x1,y1,x2,y2);
end;

function typeUO.getIdent:string;
begin
  result:=ident0;
end;

procedure typeUO.setIdent(st:string);
begin
  ident0:=st;
  if st<>'_'+stmClassName then setChildNames;
  {Le nom par défaut est fixé alors que create n'est pas complètement exécuté}
end;


function typeUO.getTitle:string;
begin
  result:=ident;
end;

procedure typeUO.setTitle(st:string);
begin
end;


function typeUO.getTitleColor:integer;
begin
  result:=ClBlack;
end;

function typeUO.Plotable:boolean;
begin
  result:=false;
end;

function typeUO.WithInside:boolean;
begin
  result:=false;
end;

procedure typeUO.getWorldPriorities(var Fworld,FlogX,FlogY:boolean;
                           var x1,y1,x2,y2:float);
begin
  Fworld:=false;
  FlogX:=false;
  FlogY:=false;
  x1:=0;
  y1:=0;
  x2:=100;
  y2:=100;
end;


procedure typeUO.displayCursors(BMex:TbitmapEx);
begin
end;

procedure typeUO.paintCursor(BMex:TbitmapEx);
begin
end;

procedure typeUO.InvalidateCursors;
begin
end;


function typeUO.MouseDown(Button: TMouseButton;
                            Shift: TShiftState; X, Y: smallInt):boolean;
begin
  mouseDown:=false;
end;

function typeUO.MouseMove(Shift: TShiftState; X, Y: smallInt):smallInt;
begin
  mouseMove:=0;
end;

procedure typeUO.MouseUp(Button: TMouseButton;
                            Shift: TShiftState; X, Y: smallInt);
begin

end;

function typeUO.MouseDownMG(numOrdre:integer;Irect:Trect;
            Shift: TShiftState;Xc,Yc,X,Y: Integer):boolean;
begin
  result:=false;
end;

function typeUO.MouseDownMG2(Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean;
begin
  result:=false;
end;

function typeUO.MouseMoveMG(x,y:integer):boolean;
begin
  result:=false;
end;

procedure typeUO.MouseUpMG(x,y:integer);
begin
end;

function typeUO.MouseMoveMG2(x,y:integer):boolean;
begin
  result:=false;
end;

procedure typeUO.MouseUpMG2(x,y:integer);
begin
end;

function typeUO.MouseRightMG(ControlSource:Twincontrol;numOrdre:integer;Irect:Trect;
                Shift: TShiftState; Xc,Yc,X,Y: Integer;var uoMenu:typeUO):boolean;

begin
   result:=false;
   uoMenu:=nil;
end;

function typeUO.MouseRightMG2(numOrdre:integer;Irect:Trect;
                Shift: TShiftState; Xc,Yc,X,Y: Integer;var uoMenu:typeUO):boolean;

begin
  result:=false;
  uoMenu:=nil;
end;




procedure typeUO.installForm(var form:TgenForm;var newF:boolean);
  begin
    newF:=false;


    if assigned(Form) and not (Form.className=DialogForm.classname) then
      begin
        Form.free;
        form:=nil;
      end;
    if not assigned(Form) then
      begin
        Form:=DialogForm.create(formStm);
        newF:=true;
      end;
  end;

function typeUO.DialogForm:TclassGenForm;
begin
  DialogForm:=TgenForm;
end;

procedure typeUO.installDialog(var form:TgenForm;var newF:boolean);
begin
  installForm(form, newF);
end;


procedure typeUO.completeDialog(var form:TgenForm);
begin
end;

procedure typeUO.extraDialog(sender:Tobject);
  begin
  end;


function typeUO.getPopUp:TpopupMenu;
begin
  result:=nil;
end;

procedure TypeUO.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
  begin
    with conf do
    begin
      if tout then
        begin
          setvarConf('IDENT',ident0,sizeof(ident0));    {ajouté le 5-10-98}
          setvarConf('MYAD',myAd,sizeof(myAd));
        end;
      setvarConf('NOTPUB',NotPublished,sizeof(NotPublished));

      setvarConf('FCHILD',Fchild,sizeof(Fchild));
      setvarConf('Fsload',FsingleLoad,sizeof(FsingleLoad));
      setStringConf('COM',stComment);

      if not lecture then
        setvarConf('OWNER',UOowner,sizeof(UOowner));

    end;
  end;

procedure typeUO.saveToStream(f:TStream;Fdata:boolean);
var
  conf:TblocConf;
begin
  conf:=TblocConf.create(stmClassName);
  BuildInfo(conf,false,true);
  conf.ecrire(f);
  conf.free;
  completeSaveInfo;

  if Fdata then saveData(f);
end;

procedure typeUO.saveToStream0(f:TStream;Fdata:boolean);
begin
  if UOowner<>nil then setChildNames;
  saveToStream(f,Fdata);
  if UOowner<>nil then UOowner.setChildNames;
end;


procedure TypeUO.saveObject(var f:file;Fdata:boolean);
var
  stream:ThandleStream;
begin
  stream:=ThandleStream.create(TfileRec(f).handle);
  try
    saveToStream0(stream,Fdata);
  finally
    stream.free;
  end;
end;

procedure typeUO.completeLoadInfo;
  begin
  end;

procedure typeUO.completeSaveInfo;
  begin
  end;

function readHeader(f:Tstream;var size:longword):string;
var
  st1:shortString;
begin
  f.readBuffer(size,sizeof(size));     { lire taille }
  f.readBuffer(st1,1);                 { et      }
  f.readBuffer(st1[1],length(st1));    { mot-clé }

  if size<5+length(st1) then
    begin
      size:=0;
      result:='';
    end
  else result:=st1;
end;


function readAndCreateUO(f:Tstream;status:TUOstatus;tout:boolean;Fdata:boolean):typeUO;
var
  posf:LongWord;
  st1:string;
  p:typeUO;
  size:longWord;
begin
   posf:=f.position;                  {noter la position de départ}
   st1:=readHeader(f,size);           {lire l'entête}

   p:=CreateUO(st1,tout);             { créer l'objet si possible }
   if assigned(p) then
     begin
       p.loadFromStream(f,size,Fdata);{ si ok, demander à l'objet de charger ses paramètres }
       p.Fstatus:=status;
     end
   else f.Position:=posf+size;           {sinon, aller à la fin du bloc }

   result:=p;
end;


function typeUO.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  ok:boolean;
  conf:TblocConf;
  st:string;
  posf:LongWord;
begin
  conf:=TblocConf.create(stmClassName);
  BuildInfo(conf,true,true);
  ok:=(conf.lire1(f,size)=0);
  conf.free;

  if ok then
    begin
      if not NotPublished then
        begin
          st:=ident; {L'objet pouvant être déjà dans mainObjList, on modifie ident}
          ident:=''; {pour que le nom ne soit pas refusé }
          ident:=nomControle(TUOclass(classType),st);
        end;
      CompleteLoadInfo;
      if Fdata then
      begin
        posf:=f.position;
        if not loadData(f)
          then f.position:=posf;
      end;
    end;
  result:=ok;
end;

function typeUO.loadObject(var f:file;size:LongWord;Fdata:boolean):boolean;
var
  stream:ThandleStream;
begin
  stream:=ThandleStream.create(TfileRec(f).handle);
  try
    LoadFromStream(stream,size,Fdata);
  finally
    stream.free;
  end;
end;

function typeUO.LoadInfo(f:Tstream;num:smallInt;tailleInfo:integer):boolean;
var
  posMax:integer;
  conf:TblocConf;
  n:smallInt;
  ok:boolean;
begin
  posMax:=f.position+tailleinfo;

  conf:=TblocConf.create(stmClassName);
  BuildInfo(conf,true,false);

  n:=0;
  repeat
    ok:=(conf.lire(f)=0);
    if ok then inc(n);
  until (n=num) or (f.position>=posmax) or testEscape;

  conf.free;
  if n=num then CompleteLoadInfo;

  LoadInfo:=(n=num);
end;


{Remarque: cette fonction est à réécrire. TabstatEv étant appelée à disparaitre.
}
function typeUO.LoadInfoDat(num:smallInt):boolean;
begin
(*
  assign(f,stDat);
  Greset(f,1);
  with tabStatEv,PrecEv(items[numSeq-1])^ do
  begin
    Gseek(f,debut);
    LoadInfoDat:=LoadInfo(f,num,info);
  end;
  Gclose(f);
  *)
end;



procedure typeUO.chooseCoo(sender:Tobject);
begin
end;

function typeUO.initialise(st:string):boolean;
begin
  ident:=st;
  title:=ident;
  result:=true;
end;

function typeUO.isVisual:boolean;
begin
  isVisual:=false;
end;

procedure typeUO.RetablirReferences(list:Tlist);
begin
end;

procedure typeUO.ResetAll;
begin
  affdebug(ident+'.resetAll',6);
end;

procedure typeUO.ClearReferences;
begin
end;

procedure typeUO.FreeRef;
begin
end;

function typeUO.clone(Fdata:boolean):typeUO;
var
  f:TmemoryStream;
  st1:string;
  size:LongWord;
begin
  f:=TmemoryStream.create;
  try
    saveToStream0(f,Fdata);
    result:=TUOclass(classType).create;
    f.Position:=0;
    st1:=readHeader(f,size);
    result.loadFromStream(f,size,Fdata);

    with result do
    begin
      Fchild:=false;
      Fstatus:=UO_main;
      clearReferences;
      resetMyAd;
      setChildNames;
    end;

    f.Free;
  except
    result:=nil;
    f.free;
  end;
end;



procedure typeUO.copyDataFrom(p:typeUO);
begin
end;


function typeUO.getSysListPosition:integer;
begin
  getSysListPosition:=sysList.indexOf(self);
end;


{Actuellement, MessageToAll n'envoie que uomsg_coupling ou uomsg_LineCoupling}
procedure typeUO.MessageToAll(id:integer;p:pointer);
var
  i,c0:integer;
  p0:typeUO;
begin
  if loadingObjects then exit;

  {La construction qui suit est obligatoire car des objets peuvent retirés de
   syslist à l'intérieur de la boucle}
  i:=0;
  with syslist do
  begin
    while i<count do
    begin
      p0:=typeUO(items[i]);
      c0:=count;

      p0.ProcessMessage(id,self,p);

      if c0<>count
        then i:=indexof(p0)+1
        else inc(i);
    end;
  end;
end;

function typeUO.controleRef(p:typeUO):boolean;
begin

{$IFDEF DEBUG}
  result:=syslist.indexof(p)>=0;
  if not result then
    begin
      messageCentral('Ref doesn''t exist: '+ident+'  /  '+p.ident  );
      reference.remove(p);
      {Problème: messageToRef reprendra au début de la liste}
    end;
{$ELSE}
  result:=true;

{$ENDIF}
end;

function typeUO.MessageToRef(id:integer;p:pointer):integer;
var
  i,c0:integer;
  p0:typeUO;
  DoneList:Tlist;
begin
  result:=0;

  {ajouté le 07-03-03}
  if assigned(UOowner)
    then UOowner.ProcessMessage(id,self,p);

  if loadingObjects or not assigned(reference) or (refCount<=0) then exit;

  {La construction qui suit est obligatoire car des objets peuvent retirés de
   syslist à l'intérieur de la boucle.
   De plus, reference peut devenir nil pendant la boucle.
  }
  DoneList:=Tlist.create;
  i:=0;

  while i<refcount do
  begin
    p0:=typeUO(reference.items[i]);

    c0:=refcount;
    if controleRef(p0) and (DoneList.IndexOf(p0)<0)  then
      begin
        p0.ProcessMessage(id,self,p);
        DoneList.add(p0);
        inc(result);
      end;

    if (c0<>refcount) and (refcount>0)
        then i:=reference.indexof(p0)+1
        else inc(i);
  end;
  doneList.free;


end;


procedure typeUO.ProcessMessage(id:integer;source:typeUO;p:pointer);
begin
end;

function typeUO.getWindowHandle:integer;
begin
  getWindowHandle:=0;
end;

procedure typeUO.show(sender:Tobject);
begin
end;


procedure typeUO.addToTree(tree:TtreeView;node:TtreeNode);
var
  p:TtreeNode;
            {7-02-06 : on ne développe plus l'arbre à la création de la liste dans l'insp.}
begin
  p:=tree.Items.addChildObject(node,ident,self);

  if assigned(childList) and (childList.count>0)
    then tree.Items.addChildObject(p,'Dummy',nil) { on ajoute un élément bidon pour afficher une case "+" }
end;

            { les noeuds sont développés à la demande de l'utilisateur }
function typeUO.expandTree(tree:TtreeView;node:TtreeNode):boolean;
var
  i:integer;
begin
  result:=true;
  if not assigned(childList) then exit;

  if (node.count>0) and (node.item[0].data=nil) and (node.Item[0].text='Dummy') then
  begin
    node.item[0].delete;

    screen.Cursor:=crHourGlass;
    for i:=0 to childList.count-1 do
    begin
      typeUO(childList.items[i]).addToTree(tree,node);
      if testEscape then break;
    end;

    if node.count<>childList.Count then
    begin
      node.DeleteChildren;
      tree.Items.addChildObject(node,'Dummy',nil);
      result:=false;
    end;

    screen.Cursor:=crDefault;
  end;
end;


procedure TypeUO.saveData(f:Tstream);
begin
end;


function TypeUO.LoadX(f:Tstream):boolean;
var
  posf:LongWord;
  st1:string;
  size:LongWord;

  oldId:string;
  oldFchild:boolean;
  OldNotPub:boolean;
  oldReadOnly:boolean;
begin
  posf:=f.position;                 {noter la position de départ}
  st1:=readHeader(f,size);           {lire l'entête}

  result:=(st1=stmClassName);
  if result then
    begin
      oldId:=ident;
      oldFchild:=Fchild;
      OldNotPub:=NotPublished;
      oldReadOnly:=readOnly;
      try
        freeRef;
        loadFromStream(f,size,true);{ si ok, demander à l'objet de se charger: params+data }

      finally
        ident:=oldId;               { rétablir les paramètres qui ne doivent pas changer }
        Fchild:=oldFchild;
        NotPublished:=oldNotPub;
        ReadOnly:=OldReadOnly;

        clearReferences;
        resetMyAd;
        setChildNames;
      end;
    end;


  if not result then f.position:=posf;      {sinon, retour au début du bloc }
end;

procedure typeUO.loadFromObject(uo:typeUO;Fdata:boolean);
var
  f:TmemoryStream;
  st1:string;
  size:LongWord;

  oldIdent:string;
  oldFchild:boolean;
  OldNotPub:boolean;
  OldReadOnly:boolean;
begin
  if not assigned(uo) or (stmClassName<>uo.stmClassName) or ReadOnly then exit;

  oldIdent:=ident;
  oldFchild:=Fchild;
  oldNotPub:=NotPublished;
  OldReadOnly:=readOnly;

  f:=TmemoryStream.create;
  try
    uo.saveToStream0(f,Fdata);
    f.Position:=0;
    st1:=readHeader(f,size);
    loadFromStream(f,size,Fdata);
    f.Free;
  except
    f.free;
  end;

  Ident:=OldIdent;
  Fchild:=oldFchild;
  NotPublished:=OldNotPub;
  ReadOnly:=OldReadOnly;

  clearReferences;
  resetMyAd;
  setChildNames;
end;


function TypeUO.LoadData(f:Tstream):boolean;
begin
  result:=true;
end;

procedure TypeUO.saveAsSingle(var f:file);
begin
end;

function TypeUO.LoadAsSingle(var f:file):boolean;
begin
  result:=true;
end;


function typeUO.readDataHeader(f:Tstream;var size:integer):boolean;
var
  header:TdataHeader;
  posf:integer;
begin
  posf:=f.position;
  f.readBuffer(header,sizeof(TdataHeader));
  result:=(header.st='DATA');
  if result then size:=header.size-sizeof(header)
  else
    begin
      size:=0;
      f.position:=posf;
    end;
end;

procedure typeUO.writeDataHeader(f:Tstream;size:integer);
var
  header:TdataHeader;
begin
  header.size:=sizeof(TdataHeader)+size;
  header.st:='DATA';
  f.writeBuffer(header,sizeof(header));
end;

function typeUO.getInfo:string;
begin
  if ident<>'' then  result:=ident +' : ';
  result:=result+'T'+stmClassName+CRLF;
  if stComment<>'' then result:=result+stComment+CRLF;

  result:=result + 'Fchild='+Bstr(Fchild)+CRLF;

end;

procedure typeUO.bringToFront;
var
  i:integer;
begin
  with HKPaint do
  begin
    i:=indexof(self);
    if i<0 then exit;
    move(i,count-1);

    for i:=0 to count-2 do
      with typeUO(items[i]) do
        if DispPriority=1 then FlagOnControl:=false;

    HKpaintPaint;
  end;

end;

procedure TypeUO.CreateClone(sender:Tobject);
var
  p:typeUO;
begin
  p:=cloneObjet(self);
  if p<>nil then p.show(nil);
end;

procedure typeUO.AddToChildList(uo: typeUO);
begin
  if not assigned(childList)
    then childList:=Tlist.create;

  with uo do
  begin
    Fchild:=true;
    UOowner:=self;
  end;
  childList.Add(uo);
end;

procedure typeUO.ClearChildList;
begin
  if assigned(childList) then childList.clear;
end;
{**************************** Méthodes de TsystemList ********************}

constructor TsystemList.create;
begin
  inherited;
  Fmodified:=true;
end;


function TsystemList.Add(Item: Pointer): Integer;
begin
  result:=inherited add(item);

  Fmodified:=true;
end;

function TsystemList.Remove(Item: Pointer): Integer;
begin
  result:=inherited remove(item);
  Fmodified:=true;
end;

procedure TsystemList.Delete(Index: Integer);
begin
  inherited delete(index);
  Fmodified:=true;
end;

procedure TsystemList.clear;
begin
  inherited;
  Fmodified:=true;
end;

const
  tabStatus:array[TUOstatus] of string[5]=('Main','Temp','PG');

procedure TsystemList.inspect;
var
  viewText:TviewText;
begin
  viewText:=TviewText.create(formStm);
  with viewText do
  begin
    caption:='SysList info';
    memo1.lines.clear;

    memo1.lines.add(Istr(count)+' objects');
    memo1.lines.add('Allocated memory: '+Istr(getHeapStatus.totalAllocated)+' bytes');

    memo1.lines.add('');
    {
    for i:=0 to count-1 do
      begin
        memo1.lines.add(Istr1(i+1,3)+': '+typeUO(items[i]).getInfo);
        memo1.lines.add(TabStatus[typeUO(items[i]).Fstatus] );

        memo1.lines.add('');
      end;
    }
    showModal;
  end;

  viewText.free;
end;

function TsystemList.existe(st:string):boolean;
var
  i:integer;
begin
  st:=Fmaj(st);
  for i:=0 to count-1 do
    if Fmaj(typeUO(items[i]).ident)=st then
      begin
        result:=true;
        exit;
      end;
  result:=false;
end;


function TsystemList.ObjectByName(st:string):typeUO;
var
  i:integer;
begin
  result:=nil;
  if st='' then exit;
  st:=Fmaj(st);

  for i:=0 to count-1 do
    if Fmaj(typeUO(items[i]).ident)=st then
      begin
        result:=items[i];
        exit;
      end;
end;

function FindNode(p:pointer;vv:TtreeNode):TtreeNode;
var
  i:integer;
begin
  result:=nil;

  if p=vv.Data then
  begin
    result:=vv;
    exit;
  end;

  for i:=0 to vv.Count-1 do
  begin
    result:=FindNode(p,vv.Item[i]);
    if result<>nil then exit;
  end;
end;


procedure TsystemList.FillTreeView(treeView:TtreeView;var ob:typeUO;Fsort:boolean);
var
  ob1:typeUO;
  i:integer;
  p0:TtreeNode;
begin
  with treeView do
  begin
    items.clear;
    items.BeginUpDate;
    for i:=0 to self.count-1 do
      begin
        ob1:=TypeUO(self.items[i]);

        if not (ob1.Fchild or ob1.notPublished)
           then ob1.addToTree(treeView,nil);
      end;

    if Fsort then AlphaSort(false);

    items.EndUpDate;

    p0:=nil;
    for i:=0 to items.count-1 do
    begin
      p0:=findNode(ob,items[i]);
      if p0<>nil then break;
    end;
    invalidate;
  end;

  if p0<>Nil then
    begin
      p0.selected:=true;
      ob:=p0.data;
    end
  else ob:=nil;
end;

{************************ Méthodes de TmainObjList *********************}

constructor TMainObjList.create;
begin
  uoBase:=typeUO.create;
  uobase.Fchild:=true;
  uobase.NotPublished:=true;
  uobase.ident:='MainList';
  inherited;
end;

function TMainObjList.firstName(st:string):string;
var
  i:integer;
  st0:string;
begin
  i:=0;
  repeat
    inc(i);
    st0:=st+Istr(i);
  until not existe(st0);

  result:=st0;
end;

function TMainObjList.existe(st:string):boolean;
  var
    i:integer;
    st1:string;
  begin

    st:=Fmaj(st);
    existe:=false;

    for i:=0 to count-1 do
      begin
        st1:=typeUO(items[i]).ident;
        st1:=Fmaj(st1);
        if (st=st1) then
          begin
            existe:=true;
            exit;
          end;
      end;

  end;

function TMainObjList.accept(st:string):boolean;
begin
  result:=not existe(st)
          and
          (pos('.',st)<=0)
          and
          (pos(' ',st)<=0);
end;

function TMainObjList.getAd(st:string):typeUO;
  var
    i:smallInt;
    st1:string;
  begin
    st:=Fmaj(st);
    getAd:=nil;;
    for i:=0 to count-1 do
      begin
        st1:=typeUO(items[i]).ident;
        st1:=Fmaj(st1);
        if (st=st1) then
          begin
            getAd:=typeUO(items[i]);
            exit;
          end;
      end;
  end;


procedure TMainObjList.add(p:typeUO;status:TUOstatus);
  begin
    inherited add(p);
    p.Fstatus:=status;
  end;

procedure TMainObjList.supprime(p:typeUO);
  begin
    remove(p);
    pack;
  end;

destructor TMainObjList.destroy;
begin
  clear(true);
  inherited destroy;
  uobase.free;
end;


procedure TMainObjList.clear(Tout:boolean);
var
  i:integer;
  p:typeUO;
  st,lastSt:string;
begin
  for i:=0 to count-1 do
    begin
      p:=typeUO(items[i]);
      if tout or not p.FsingleLoad then
        begin
          try
            LastSt:=st;
            st:=p.ident;
            p.free;
          except

            messageCentral('MainObjList.clear error '+Istr(i)+': Last: '+LastSt );
          end;
          items[i]:=nil;
        end;
    end;

  pack;
end;


procedure TmainObjList.LoadFromStream(f:Tstream;tailleInfo:integer;tout:boolean);
  { Le pointeur de fichier pointe sur le début du bloc info global}
  { La taille de ce bloc est tailleInfo }
  var
    posMax:integer;
    p:typeUO;
  begin
    loadingObjects:=true;
    clear(tout);                               { vider la liste }

    AffDebug('',1);
    AffDebug('mainObjList.LoadObjects '+Istr(f.size),1);
    posMax:=f.position+tailleinfo;            { Limite fichier }
    if posmax>f.Size then posmax:=f.size;

    repeat
      p:=readAndCreateUO(f,UO_main,tout,false);
      if assigned(p) then
        begin
          if p.Fchild or (not tout and p.FSingleLoad) then p.free
          else add(p,UO_main);
        end;
    until (f.position>=posmax)  or testEscape;
    f.Position:=posMax;


    RetablirReferences;

    loadingObjects:=false;
    {ResetAll; déplacé dans nouvelleCg}


    HKpaintSort;
    if assigned(HKpaintPaint) then HKpaintPaint;
    if assigned(HKpaintScreen) then HKpaintScreen;
  end;

procedure TmainObjList.LoadObjects(var f:file;tailleInfo:integer;tout:boolean);
var
  stream:ThandleStream;
begin
  stream:=ThandleStream.create(TfileRec(f).Handle);
  try
    loadFromStream(stream,tailleInfo,tout);
  finally
    stream.free;
  end;
end;

procedure TmainObjList.saveObjects(var f:file);
var
  i:integer;
begin
  HKpaintSetZ;
  for i:=0 to count-1 do
    with TypeUO(items[i]) do
    if Fstatus=UO_main
      then saveObject(f,false);
end;

procedure TmainObjList.RetablirReferences;
var
  i:integer;
begin
  for i:=0 to count-1 do TypeUO(items[i]).RetablirReferences(sysList);

  for i:=0 to syslist.count-1 do
    TypeUO(syslist.items[i]).myAd:=syslist.items[i];
end;

procedure TmainObjList.ResetAll;
var
  i:integer;
begin
  for i:=0 to count-1 do
    begin
      affdebug('MainObjList.resetAll '+typeUO(items[i]).ident,6);
      TypeUO(items[i]).ResetAll;
    end;
end;



{*************************************************************************}

{GetGlobalList renvoie la liste de tous les noms d'objet contenus dans syslist
 et descendant de tp, en évitant les répétitions}

function GetGlobalList(tp:TUOclass;withRF:boolean):Tlist;
  var
    list1:Tlist;
    i:integer;
  begin
    list1:=Tlist.create;
    with sysList do
      for i:=0 to count-1 do
        if (typeUO(items[i]) is tp) and
           (withRF or not (typeUO(items[i]).className='TRF') )
              then list1.add(items[i]);

    getGlobalList:=list1;
  end;


{getGlobalObject renvoie l'adresse d'un objet de nom st en consultant la syslist}

function getGlobalObject(st:string):typeUO;
var
  i:integer;
begin
  st:=Fmaj(st);
  with syslist do
    for i:=0 to count-1 do
      if Fmaj(typeUO(items[i]).ident)=st then
        begin
          getGlobalObject:=items[i];
          exit;
        end;
  getGlobalObject:=nil;
end;

procedure InstalleComboBox(cb:TcomboBox;ob:TypeUO;TUO:TUOclass);
var
  i:integer;
  list:Tlist;
begin
  list:=GetGlobalList(TUO,false);

  with CB do
  begin
    clear;
    for i:=0 to list.count-1 do
      begin
        items.addObject(typeUO(list.items[i]).ident,list.items[i]);
        if ob=list.items[i] then itemIndex:=i;
      end;
    items.addObject('',nil);
  end;

  list.free;
end;

function recupComboBox(cb:TcomboBox):pointer;
begin
  with CB do
  if (itemIndex>=0) and (itemIndex<items.count-1)
      then result:=items.objects[itemIndex]
      else result:=nil;
end;

{*************************************************************************}




{************** Méthodes de ThreadFclock ********************************}

procedure ThreadFclock.execute;
begin
  repeat
     fillChar(Flag,sizeof(Flag),1);
      sleepEx(100,false);
  until terminated;
end;

function getFlagClock(num:integer):boolean;
begin
  result:=flagClock.flag[num];
  if result then flagClock.flag[num]:=false;
end;

{*************************************************************************}

function NomParDefaut0(st0:string):string;
  { on ajoute un numéro au nom de base et on incrémente ce numéro jusqu'à
    ce que l'on obtienne un nom qui n'existe pas dans les 2 listes }
  begin
    result:=MainObjList.firstName(st0);
  end;

function NomControle(ref:TUOclass;name:string):string;
  { name est un nom proposé par l'utilisateur. On le garde s'il n'existe pas.
    Sinon, on donne un nom par défaut avec numéro }
  begin
    name:=Fsupespace(name);
    if (name='') or MainObjList.existe(name)
      then nomControle:=nomParDefaut0(ref.stmClassName)
      else nomControle:=name;
  end;


{************** Méthodes STM  de typeSYS *****************************}

procedure verifierObjet(var pu:typeUO);
begin
  if (@pu=nil) or not assigned(pu)
    then sortieErreur(E_objetInexistant);
end;




procedure proTSystem_ControlON(ww:boolean;var pu:typeUO);
begin
  AffControl:=ww;
  speedControlStm.down:=AffControl;
  FormControlStm.visible:=affControl;

end;

function fonctionTSystem_ControlON(var pu:typeUO):boolean; pascal;
begin
  result:=AffControl;
end;

function fonctionAssigned(var pu:typeUO):boolean;
  begin
    fonctionAssigned:=(@pu<>nil) and (pu<>nil);
  end;


{ createUO crée un objet dont le type correspond à stMot=stmClassName avec un
  nom par défaut.
  renvoie nil si stMot n'existe pas}
function createUO(stMot:string;tout:boolean):typeUO;
var
  g:TgenreUO;
  i:integer;
  p:typeUO;
begin
  result:=nil;
  if not tout and (stMot='VisualStim') then exit;
  if (stMot='VisualStim') and not testUnic then exit;

  if FlagObjectFile and (stMot='MGDAC')
    then stMot:='MultiGraph';

  for g:=low(TgenreUO) to high(TgenreUO) do
    for i:=0 to UOnameList[g].count-1 do
      if UOnameList[g].strings[i]=stMot then
        begin
          p:=TUOclass(UOnameList[g].objects[i]).create;
          p.ident:=NomParDefaut0(stMot);
          createUO:=p;
          exit;
        end;
end;

function StmClass(stMot:string):TUOclass;
var
  g:TgenreUO;
  i:integer;
begin
  stMot:=Fmaj(stMot);
  for g:=low(TgenreUO) to high(TgenreUO) do
    for i:=0 to UOnameList[g].count-1 do
      if Fmaj(UOnameList[g].strings[i])=stMot then
        begin
          result:=TUOclass(UOnameList[g].objects[i]);
          exit;
        end;
  result:=nil;
end;

procedure typeUO.refObjet(pu:typeUO);
begin
  if assigned(pu) then
    with pu do
    begin
      AffDebug(self.ident+' référence '+pu.ident+' count='+Istr(refCount),15 );
      if not assigned(reference) then reference:=Tlist.create;
      reference.add(self);
    end;
end;

procedure typeUO.derefObjet(var pu:typeUO);
begin
  if assigned(pu) then
    with pu do
    begin
      if assigned(reference) then
        with reference do
        begin
          remove(self);
          if count=0 then
            begin
              reference.free;
              reference:=nil;
            end;
        end;
      AffDebug(self.ident+' déréférence '+pu.ident+' count='+Istr(refCount),15 );
    end;
  pu:=nil;
end;

function typeUO.refCount:integer;
begin
  if assigned(reference)
    then result:=reference.count
    else result:=0;
end;

procedure typeUO.specialDrop(Irect:Trect;x,y:integer);
begin
end;


procedure TypeUO.initChildList;
begin
end;

procedure TypeUO.clear;
begin
end;

procedure TypeUO.invalidate;
begin
end;


function typeUO.getEmbedded: boolean;
begin
  result:=false;
end;

procedure typeUO.setEmbedded(v: boolean);
begin

end;

function typeUO.CanEmbedForm:boolean;
begin
  result:=false;
end;

function typeUO.EmbeddedForm:Tform;
begin
  result:=nil;
end;


procedure typeUO.addToStimList(list:Tlist);
begin
end;


procedure typeUO.resetMyAd;
var
  i:integer;
begin
  myAd:=self;
  if assigned(childList) then
    for i:=0 to childList.count-1 do
      typeUO(childList.items[i]).resetMyAd;
end;

procedure typeUO.setChildNames;
begin

end;

procedure typeUO.saveObjectToFile(sender: Tobject);
var
  oac:TobjectFile;
const
  AppendSave:boolean=false;
  stSave:shortstring='*.oac';
begin
  SaveObjectDialog.caption:='Save object '+ident;
  if not SaveObjectDialog.execution(stComment,AppendSave) then exit;

  if not sauverFichierStandard(stSave,'OAC') then exit;

  if not AppendSave and fichierExiste(stSave) then
    if MessageDlg('File already exists. Continue ?',mtConfirmation,[mbYes,mbNo],0)<>mrYes
      then exit;


  oac:=TobjectFile.create;

  if AppendSave then
    begin
      oac.openFile(stSave);
      if oac.error<>0 then
        begin
          messageCentral('Error opening '+stSave);
          oac.free;
          exit;
        end;
    end
  else
    begin
      oac.createFile(stSave);
      if oac.error<>0 then
        begin
          messageCentral('Error creating '+stSave);
          oac.free;
          exit;
        end;
    end;

  oac.save(self);
  if oac.error<>0 then
    begin
      messageCentral('Error saving '+stSave);
      oac.free;
      exit;
    end;

  oac.close;
  oac.free;

end;

(*
const
  stF:string='';
var
  objFile:TobjectFile;
  st:string;
begin
  st:=GSaveFile('Save object to file',stF,'');
  if st<>'' then
  begin
    stF:=st;
    objFile:=TobjectFile.create;
    TRY
    with objFile do
    begin
      if fileExists(stF)
        then OpenFile(stF)
        else createFile(stF);

      if fileName='' then
      begin
        messageCentral('Unable to open '+stf);
        exit;
      end;

      objFile.save(self);
      if GIO<>0 then messageCentral('Unable to save object');
    end;

    FINALLY
    objFile.free;
    END;
end;
*)


function typeUO.getReadOnly: boolean;
begin
  result:=false;
end;

procedure typeUO.setReadOnly(v: boolean);
begin
end;



procedure typeUO.Verify;
begin
  if not assigned(self) then sortieErreur(E_objetInexistant);
end;

function typeUO.isModified: boolean;
begin
  result:=true;
end;

procedure typeUO.swapFont(var font:Tfont;var color:integer);
begin

end;


{******************************************************************************}


function fonctionTobject_loadInfo(num:smallInt;var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  result:=pu.loadInfoDat(num);
end;

function fonctionTobject_sysname(var pu:typeUO):String;
begin
  verifierObjet(pu);
  result:=pu.ident;
end;

function fonctionTobject_tag(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  result:=pu.tagUO;
end;

procedure proTobject_tag(w:Integer;var pu:typeUO);
begin
  verifierObjet(pu);
  pu.tagUO:=w;
end;



procedure initRegister;
  var
    g:TgenreUO;
  begin
    for g:=low(TgenreUO) to high(TgenreUO) do
      begin
        UOnameList[g]:=TstringList.create;
        UOnameList[g].sorted:=true;
      end;
  end;


procedure registerObject(ref:TUOclass;genre:TgenreUO);
begin
  if not assigned(UOnameList[genre]) then initRegister;

  UOnameList[genre].addObject(ref.stmClassName,Tobject(ref));
end;

procedure PrintStmClassName;
var
  i:integer;
  f:Text;
  g:TgenreUO;
begin
  assignFile(f,debugPath+'stmClass.txt');
  GrewriteT(f);

  for g:=low(TgenreUO) to high(TgenreUO) do
    for i:=0 to UOnameList[g].count-1 do
      GwritelnT(f,UOnameList[g].strings[i]);
  GcloseT(f);
end;



function nouvelObjet(numType:integer):boolean;
  var
    k:integer;
    st:shortstring;
    p:typeUO;
    status:TUOstatus;

  const
    Ninit:integer=1;
    xpos:integer=100;
    ypos:integer=100;

  begin
    k:=ShowMenu1(FormStm,'New object',UOnameList[TgenreUO(numType)],
                 Ninit,xpos,ypos);
    if k=0 then exit;
    st:=NomParDefaut0(UOnameList[TgenreUO(numType)].strings[k-1]);

    with getObjName do
    begin
      accept:=MainObjList.accept;
      status:=UO_main;
      if not execution(st,status) then exit;
    end;
    p:=TUOclass(UOnameList[TgenreUO(numType)].objects[k-1]).create;
    result:= p.initialise(st);
    if result then
      begin
        MainObjList.add(p,status);
        p.show(nil);
      end
    else p.free;
  end;

function nouvelObjet1(UOclass:TUOclass):typeUO;
var
  st:shortstring;
  p:typeUO;
  status:TUOstatus;
begin
  result:=nil;

  st:=NomParDefaut0(UOclass.STMClassName);
  with getObjName do
  begin
    accept:=MainObjList.accept;
    status:=UO_main;
    if not execution(st,status) then exit;
  end;
  p:=UOclass.create;
  if p.initialise(st) then
    begin
      MainObjList.add(p,status);
      result:=p;
    end
  else p.free;
end;

function CloneObjet(p:typeUO):typeUO;
var
  st:shortstring;
  p2:typeUO;
  status:TUOstatus;
begin
  result:=nil;

  st:=nomControle(TUOclass(p.ClassType),'');
  with getObjName do
  begin
    accept:=MainObjList.accept;
    status:=UO_temp;
    if not execution(st,status) then exit;
  end;

  p2:=p.clone(true);
  if p2=nil then exit;

  p2.ident:=st;
  p2.setChildNames;
  p2.notPublished:=false;
  p2.Fchild:=false;

  MainObjList.add(p2,status);
  result:=p2;
end;

function CreerObjet(tp:TUOclass):typeUO;
var
  st:shortstring;
  p2:typeUO;
  status:TUOstatus;
begin
  result:=nil;

  st:=nomControle(tp,'');
  with getObjName do
  begin
    accept:=MainObjList.accept;
    status:=UO_main;
    if not execution(st,status) then exit;
  end;

  p2:=tp.create;
  if p2=nil then exit;

  p2.ident:=st;
  p2.notPublished:=false;
  p2.Fchild:=false;

  MainObjList.add(p2,status);

  result:=p2;
end;


procedure proDragDropObject(var dest:typeUO);
begin
  verifierObjet(dest);
  specialDrag:=dest;
end;


procedure resetDragUO;
begin
  DragUOsource:=nil;
  DraggedUO:=nil;
end;


function typeUO.loadAsChild(f: Tstream;Fdata:boolean): boolean;
var
  size,posini:LongWord;
  st1:string;
begin
  posIni:=f.position;
  st1:=readHeader(f,size);
  result:=(st1=stmClassName);
  if result then loadFromStream(f,size,Fdata);
  result:=result and (NotPublished or Fchild);

  if not result then f.Position:=Posini;
end;

procedure PrintUOnameList;
var
  g:TgenreUO;
  i:integer;
  f:textFile;
begin
  assignFile(f,debugPath+'UOname.txt');
  rewrite(f);

  for g:=low(TgenreUO) to high(TgenreUO) do
    for i:=0 to UOnameList[g].count-1 do
      writeln(f,UOnameList[g][i]);

  closeFile(f);
end;


function TUOlist.getUO(i:integer):typeUO;
begin
  result:=get(i);
end;

procedure TUOlist.putUO(i:integer;p:typeUO);
begin
  put(i,p);
end;

function UOident(uo:typeUO):string;
begin
  if assigned(uo)
    then result:=uo.ident
    else result:='';
end;


procedure initStmObj;
begin
  if not assigned(sysList) then
  begin
    SysList:=TsystemList.create;
    HKpaint:=TsystemList.create;

    MainObjList:=TMainObjList.create;

    FlagClock:=ThreadFclock.create(false);
  end;
end;

var
  E_save:integer;
  E_load:integer;


procedure proTObject_save(var obF, pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(obF);

  TobjectFile(obF).save(pu);
  if GIO<>0 then sortieErreur(E_save);
end;

procedure proTObject_load(var obF, pu:typeUO);
var
  ok:boolean;
begin
  verifierObjet(pu);
  verifierObjet(obF);

  ok:=TobjectFile(obF).load(pu);
  if not ok then sortieErreur(E_load);
end;

function fonctionTObject_load1(var obF, pu:typeUO):boolean;
begin
  verifierObjet(pu);
  verifierObjet(obF);

  result:=TobjectFile(obF).load(pu);
end;

procedure proTObject_loadObject(stF:String;var pu:typeUO);
var
  obF:TobjectFile;
begin
  verifierObjet(pu);

  obF:=TobjectFile.create;
  try
    obF.OpenFile(stF);
    if not TobjectFile(obF).load(pu)
      then sortieErreur('TObject.LoadObject : unable to load from file '+stF);
  finally
  obF.Free;
  end;
end;

procedure proTObject_SaveAsObject(stF:String;var pu:typeUO);
var
  obF:TobjectFile;
begin
  verifierObjet(pu);

  obF:=TobjectFile.create;
  try
    obF.createFile(stF);
    if obF.error<>0 then sortieErreur('TObject.SaveAsObject : unable to create file '+stF);

    obF.save(pu);
  finally
  obF.Free;
  end;
end;



procedure proTObject_saveSingleData(var binF, pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(binF);

  TbinaryFile(binF).save(pu);
  if GIO<>0 then sortieErreur(E_save);
end;

procedure proTObject_loadSingleData(var binF, pu:typeUO);
var
  ok:boolean;
begin
  verifierObjet(pu);
  verifierObjet(binF);

  ok:=TbinaryFile(binF).load(pu);
  if not ok then sortieErreur(E_load);
end;


function fonctionTobject_stCom(var pu:typeUO):String;
begin
  verifierObjet(pu);
  result:=pu.stComment;
end;

procedure proTobject_stCom(w:String;var pu:typeUO);pascal;
begin
  verifierObjet(pu);
  pu.stComment:=w;
end;

procedure copyGvariant(var src:TGvariant;var dest:TGvariant);
begin
  case src.VType of
    gvBoolean:  dest.Vboolean:=src.Vboolean;
    gvInteger:  dest.Vinteger:=src.Vinteger;
    gvFloat:    dest.Vfloat:=src.Vfloat;
    gvString:   dest.Vstring:=src.Vstring;
    gvDateTime: dest.VdateTime:=src.VdateTime;
    gvObject:   dest.Vobject:=src.Vobject;
    else        dest.finalize;
  end;
end;



{ TrefUO }

constructor TrefUO.create;
begin
  inherited;
  notpublished:=true;
end;

destructor TrefUO.destroy;
begin
  derefObjet(refUO);
  inherited;
end;

procedure TrefUO.ProcessMessage(id: integer; source: typeUO; p: pointer);
begin
  if (id=UOmsg_destroy) and (refUO=source) then
  begin
    refUO:=nil;
    derefObjet(source);
    myVariant^.finalize;
  end;
end;

{ TGvariant }

procedure TGvariant.AdjustObject;
begin
  if Vtype=gvObject then rec.Vobject.MyVariant:=@self;
end;

procedure TGvariant.finalize;
begin
  rec.Vstring:='';
  if Vtype=gvObject then freeAndNil(rec.Vobject);
  fillchar(rec,sizeof(rec),0);
end;

function TGvariant.getObject: typeUO;
begin
  if (Vtype=gvObject) and assigned(rec.Vobject)
    then result:=rec.Vobject.refUO
    else result:=nil;
end;

function TGvariant.getValString(const Ndeci:integer=6): string;
var
    year,month,day,hour,minute,second,millisecond:Word;
begin
  result:='';
  case rec.VType of
    gvBoolean:    result:=Bstr(rec.VBoolean);
    gvInteger:    result:=Istr(rec.VInteger); { 64 bits }
    gvFloat :     result:=Estr(rec.VFloat,Ndeci) ;
    gvString:     result:=rec.Vstring;
    gvDateTime:   result:=FormatDateTime('yyyy/mm/dd hh:mm:ss',rec.VDateTime);
    gvObject:     if assigned(rec.Vobject) and assigned(rec.Vobject.refUO)
                    then result:=rec.Vobject.refUO.ident;
  end;
end;

procedure TGvariant.init;
begin
  fillchar(rec,sizeof(rec),0);
end;

procedure TGvariant.setBoolean(w: boolean);
begin
  finalize;

  rec.Vtype:=gvBoolean;
  rec.VBoolean:=w;
end;

procedure TGvariant.setDateTime(w: TdateTime);
begin
  finalize;

  rec.Vtype:=gvDateTime;
  rec.VdateTime:=w;
end;

procedure TGvariant.setFloat(w: float);
begin
  finalize;

  rec.Vtype:=gvFloat;
  rec.Vfloat:=w;
end;

procedure TGvariant.setInteger(w: int64);
begin
  finalize;

  rec.Vtype:=gvInteger;
  rec.Vinteger:=w;
end;

procedure TGvariant.setObject(w: TypeUO);
begin
  finalize;

  rec.Vtype:=gvObject;
  rec.Vobject:=TrefUO.create;
  rec.Vobject.MyVariant:=@self;
  rec.Vobject.refUO:=w;
  rec.Vobject.refObjet(w);
end;

procedure TGvariant.setString(w: string);
begin
  finalize;

  rec.Vtype:=gvString;
  rec.Vstring:=w;
end;

procedure TGvariant.showStringInfo;
begin
  util1.showStringInfo(rec.Vstring);
end;

function TGvariant.Usize: integer;
begin
  case rec.VType of
    gvBoolean:    result:=1;
    gvInteger:    result:=8; { 64 bits }
    gvFloat :     result:=10;
    gvString:     result:=4 + length(Vstring);
    gvDateTime:   result:=sizeof(TdateTime);
    gvObject:     result:=0;
    else          result:=0;
  end;
end;

function TGvariant.VarAddress: pointer;
begin
  if assigned(Vobject)
    then result:=rec.Vobject.refUO.PgAddress
    else result:=nil;
end;

class function typeUO.PgType: integer;
begin
  result:=tabProc2.getNumObj('T'+stmClassName);
end;

class function typeUO.PgDescendantOf(num: integer): boolean;
begin
  result:=tabProc2.estDescendant(PgType,num);
end;

function typeUO.PgAddress: pointer;
begin
  if PgAd<>nil
    then result:=PgAd
    else result:=@myAd;
end;




initialization

initStmObj;

installError(E_save,'TObject: Write error');
installError(E_load,'TObject: Read error');


finalization
FlagClock.free;

end.
