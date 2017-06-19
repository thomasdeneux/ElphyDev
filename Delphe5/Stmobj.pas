unit Stmobj;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,sysUtils,
     classes, controls, forms, graphics,messages,menus,comCtrls,stdCtrls,Dialogs,
     {$IFDEF DX11} {$ELSE} DXTypes, Direct3D9G, D3DX9G, {$ENDIF}
     util1,Gdos,Dgraphic,defForm,clock0,BMex1,DdosFich,
     stmdef,editCont,spk0,Dprocess,stmError,
     varconf1,
     KBlist0,
     formMenu,
     debug0,
     sysmask0,memoForm,

     Ncdef2, visu0,
     MemManager1,
     matlab_matrix;

  { typeUO est le type de base de tous les objets STM.

    tout objet est recens� dans Syslist. typeUO.create range l'objet dans syslist. typeUO.destroy l'enl�ve de syslist.

    Ensuite, les objets sont recens�s
      - soit dans MainObjList qui contient les objets cr��s de fa�on interactive ainsi que les
      objets permanents comme datafile0, multigraph0,...

      - soit dans le segment de donn�es d'un programme PG2.
        La propri�t� Fpg de ces objets vaut true.


    Certains objets peuvent appartenir � un autre objet. Leur propri�t� Fchild vaut true.



  }

const
  LoadingObjects:boolean=false;
  {Pendant le chargement des objets, ce flag est mis � true.
  }
  FLoadObjectsMINI:boolean=false;
  {On peut imposer un chargement entrainant un encombrement minimum en
   positionnant ce flag.
   Est utilis� par dataFIle.
  }
  FDoNotLoadDisplayParams: boolean=false;
  {Utilis� par TobjectFile load, load1 searchAndLoad, searchTypeAndLoad
   Les descendants de TdataPlot ne chargent pas la structure visu quand le flag est mis
   Le flag est remis � false imm�diatement apr�s le chargement.
  }

  FKeepCoordinates: boolean=false;
  {Utilis� par TobjectFile load, load1 searchAndLoad, searchTypeAndLoad
   Quand FKeepCoordinates est vrai, l'objet impose ses coordonn�es aux
   objets ayant les m�mes coefficients de couplage
  }

type
  TUOclass=class of typeUO;
  TformClass=class of Tform;
  TUOstatus=(UO_Main,UO_Temp,UO_PG);

  TidentOld=string[30];

  typeUO=
         class
           identOld: ^TidentOld;
           identNew:AnsiString;

           MyAd:pointer;     { Object address }
           { after create = self
             This value is saved in the configuration files
             and is used to keep a track of the references between objects.

             After loading a configuration file, MyAd is the object address during the previous session
             and the referencing objects also contain this value.

             RetablirReferences uses myAd to set the correct addresses in the referencing objets
             and, at the end, put the new address in MyAd

           }
           SysIndex: integer;

           Fstatus0:TUOstatus;

           NotPublished:boolean;{ Will not be visible in the Object Inspector }

           Fchild:boolean;   { true  when the object is owned by another object : ie will be destroyed
                               when the owner is destroyed

                               Example: v1, v2..  in TdataFile
                               In the Object Inspector, this object is seen as a child of another object
                              }
           Fsystem:boolean;  { true when the object belongs to the system : cannot be destroyed }

           FsingleLoad:boolean; {true = the object is only loaded  at the beginning of an Elphy session}
           stComment:AnsiString; { a Comment}

           reference:Tlist;  { List of referencing objects.
                               The RefCount function (=reference.count) gives the reference count for this object.
                             }

           tagUO:integer;    { a Delphi-like tag }

           childList:Tlist;  { Some objects use this property to initialize the object inspector
                             }
           UOowner:typeUO;   { The object owner.
                               When created by the PG2 program, the owner is the TPG2 object
                               For child objects, UOowner is the owner

                               Is not used by Load
                               Receive messages from MessageToRef.
                             }
           PgAd:pointer;     { set by createPgObject
                             }

           UserPopUp: TstringList; { optionnal list of menu items }

           procedure setFstatus(status: TUOstatus);virtual;

           function getIdent:AnsiString;
           procedure setIdent(st:AnsiString);virtual;

           function getTitle:AnsiString;virtual;
           procedure setTitle(st:AnsiString);virtual;

           function getReadOnly:boolean;virtual;
           procedure setReadOnly(v:boolean);virtual;

           function GetIsMask:boolean;virtual;
           procedure SetIsMask(w:boolean);virtual;

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

           class function STMClassName:AnsiString;virtual;
                             { renvoie le nom du type d'objet STM }
           {class function PgClassName:AnsiString;virtual;
                             renvoie le nom du type d'objet dans le langage }


           property Fstatus: TUOstatus read Fstatus0 write setFstatus;

           // L'affectation de OnScreen provoque le r�affichage imm�diat de l'�cran
           property OnScreen:boolean read GetOnScreen  write SetOnScreen;
           property OnControl:boolean read GetOnControl write setOnControl;
           property Locked:boolean read GetLocked write SetLocked;

           //  L'affectation de FlagOnScreen modifie seulement le flag 
           property FlagOnScreen:boolean read GetOnScreen  write SetFlagOnScreen;
           property FlagOnControl:boolean read GetOnControl write setFlagOnControl;

           property DispPriority:integer read getDispPriority;
             {0 en g�n�ral, 1 pour les matrices
              Sur l'�cran de controle, les matrices doivent
              s'afficher en arri�re plan
              Sur l'�cran de controle, on affiche d'abord tous les
              objets de priorit� 1 puis tous ceux de priorit� 0
              }

           property isOnScr:boolean read GetIsOnScreen write setIsOnScreen;
           property isOnCtrl:boolean read GetIsOnCtrl write setIsOnCtrl;
              { Rep�re les objets affich�s sur l'�cran de stimulation ou de contr�le
                avant le lancement d'une animation
              }
           property IsMask:boolean read GetIsMask write SetIsMask;


           property title:AnsiString read getTitle write setTitle;
           property ident:AnsiString read getIdent write setIdent;

           property readOnly:boolean read getReadOnly write setReadOnly;

           procedure creerRegions;virtual;      { Used by visual objects }
           procedure detruireRegions;virtual;   { Used by visual objects }

           procedure afficheS;Virtual;          { Used by visual objects }
           procedure afficheSDX9(TheMasks:boolean);Virtual; { Used by visual objects }

           procedure afficheC;Virtual;          { Used by visual objects }
           procedure afficheMask;Virtual;       { Used by visual objects }
           procedure freeBM;virtual;            { Used by visual objects }


           constructor create;virtual; { Tous les create doivent �tre override }
           destructor destroy;override;{ id }

           {procedure setName(st:AnsiString);}


           function DialogForm:TclassGenForm;virtual;                            { Used by visual objects }
           procedure installForm(var form:TgenForm;var newF:boolean);            { Used by visual objects }
           procedure installDialog(var form:TgenForm;var newF:boolean);virtual;  { Used by visual objects }
           procedure completeDialog(var form:TgenForm);virtual;                  { Used by visual objects }
           procedure extraDialog(sender:Tobject);virtual;                        { Used by visual objects }
           procedure Paint(priorite:Integer);virtual;                            { Used by visual objects }


           procedure display;                         virtual;
           { Standard display in TMultiGraph
             Used for the first object in a Multigraph window
             The other objects use DisplayInside
            }
           procedure displayEmpty;                    virtual;
           { Display coordinates only}

           procedure displayGUI;virtual;
           { Used for temporary display , only on GUI, not on bitmap}

           procedure swapContext(numW:integer;var varPg:TvarPg1;ContextPg:boolean);virtual;

           procedure displayInside(FirstUO:typeUO;
                                   extWorld,logX,logY:boolean;
                                   const order:integer=-1);virtual; {=display}
           { Display without scale
             Is called by Tmultigraph for all objects in a window except the first object.
           }
           function getInsideWindow:Trect;virtual;

           function getTitleColor:integer;virtual;
           function Plotable:boolean;virtual;

           function WithInside:boolean;virtual;
           { For some objects, the display have an inner rectangle (ex: Tvector, Tmatrix).
             Other objects can be displayed in this inner rectangle.
           }
           procedure getWorldPriorities(var Fworld,FlogX,FlogY:boolean;
                               var x1,y1,x2,y2:float);virtual;
           { WithInside objets can set world parameters in such a way that objects displayed in their inner rectangle
             will use this parameters, not their own parameters.

             Tvector and Tmatrix impose modeLogX and modeLog, not  Xmin, Xmax, Ymin, Ymax coordinates.
             Tcoo impose everything.

           }

           {Les objets TdataPlot ont une propri�t� displayCursors qui est appel�e
           par Multigraph.
           Quand MG veut afficher des curseurs, il s�lectionne le cadre puis appelle
           displayCursors de tous les objets contenus dans la fen�tre.

           Ces objets fixent setWorld puis appellent � leur tour la m�thode PaintCursor de
           leurs r�f�rences.}
           procedure displayCursors(BMex:TbitmapEx);virtual;

           { Les curseurs ont une m�thode PaintCursor. Quand la m�thode est appel�e, le
           cadre et le world sont en place. }
           procedure paintCursor(BMex:TbitmapEx);virtual;

           { InvalidateCursors est appel� par TLcursor (m�thode de son obref de type TdataPlot)
           pour lui demander de le r�afficher.
             La m�thode InvalidateCursors de TdataPlot invalide sa propre fen�tre
           puis lance un message UOmsg_cursor.

           UOmsg_cursor est ensuite re�u par MG qui invalide sa fen�tre
           }
           procedure InvalidateCursors;virtual;

           {Les 3 proc�dures suivantes sont utilis�es dans Stim2 pour g�rer la
           fen�tre Contr�le.
           }


           function MouseDown(Button: TMouseButton;
                          Shift: TShiftState; X, Y: smallInt):boolean;
                                                      virtual;
           function MouseMove(Shift: TShiftState;
                          X, Y: smallInt):smallInt;     virtual;
           procedure MouseUp(Button: TMouseButton;
                           Shift: TShiftState; X, Y: smallInt);
                                                      virtual;


           { Cette proc�dure est utilis�e soit en interne, soit par HKpaint0 }
           procedure majPos;virtual;

           { Montrer et cacher les poign�es }
           procedure drawHandle(x,y:smallInt);
           procedure ShowHandles;virtual;

           {
           MouseDownMG est utilis�e pour g�rer les clics de la souris dans
           l'objet MultiGraph.
           Au moment de l'appel, le cadre multigraph dans lequel se trouve l'objet
           est s�lectionn� et getWindowG permet d'obtenir les coo de ce cadre.
           Irect contient le rectangle int�rieur.

           Exemple: TvectorList (stmVlist1) g�re ces clics pour selectionner
           des traces.

           numOrdre est le num�ro d'ordre dans le cadre multigraph (commence � 0).
           Xc et Yc sont les coordonn�es �cran du cadre.
           X et Y sont les coordonn�es du clic dans le cadre.

           La fonction doit renvoyer True si une action a �t� entreprise.
           }
           function MouseDownMG(numOrdre:integer;Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean; virtual;

           function MouseMoveMG(x,y:integer):boolean;virtual;
           procedure MouseUpMG(x,y:integer; mg:typeUO);virtual;

           function MouseRightMG(ControlSource:Twincontrol;numOrdre:integer;Irect:Trect;
                Shift: TShiftState; Xc,Yc,X,Y: Integer;var uoMenu:typeUO):boolean; virtual;

           {
           MouseDownMG2 joue le m�me r�le que MouseDownMG mais au deuxi�me niveau.
           Par exemple, quand MouseDownMG d'un vecteur est appel�e, elle doit appeler
           � son tour MouseDownMG2 des objets r�f�renceurs (les curseurs associ�s au
           vecteur par exemple).
           }
           function MouseDownMG2(Irect:Trect;
                    Shift: TShiftState; Xc,Yc,X,Y: Integer):boolean; virtual;

           function MouseMoveMG2(x,y:integer):boolean;virtual;
           procedure MouseUpMG2(x,y:integer);virtual;
           function MouseRightMG2(numOrdre:integer;Irect:Trect;
                Shift: TShiftState; Xc,Yc,X,Y: Integer;var uoMenu:typeUO):boolean; virtual;



           {permet de cr�er un menu Popup associ� � l'objet.
            Les mod�les de popup sont dans stmPopUp }
           function getPopUp:TpopupMenu;virtual;


           procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);virtual;
           {contient une suite de setVarConf propre � l'objet}

           procedure CheckOldIdent;
           procedure completeLoadInfo;virtual;
           {Op�rations � r�aliser imm�diatement apr�s chargement d'un objet
            Ex: mise en place des param�tres secondaires.
            A cet instant, les r�f�rences � d'autres objets ne sont pas valables.

            Pour tenir compte de ces r�f�rences, il faut utiliser ResetAll.
           }

           procedure completeSaveInfo;virtual;


           {Op�rations � r�aliser apr�s Sauvegarde d'un objet
            Ex: lib�rations de variables temporaires utilis�es pour le stockage
           }

           {Pour sauver et charger un objet, on utilise saveObject et loadObject.
            Chaque objet peut r��crire compl�tement ces 2 proc�dures en respectant
            la structure d'un bloc:
              - un mot de 4 octets repr�sentant la taille totale du bloc
               (y compris ces 4 octets)
              - un mot cl� AnsiString de longueur quelconque identifiant l'objet:
                ici, obligatoirement stmClassName.
              - des donn�es quelconques

            Il faut aussi sauver ident et myAd

            Plus simplement, on peut seulement surcharger buildInfo qui dresse une
            liste de variables � sauver ou charger. Il faut toujours appeler
            inherited buildinfo.

            En pratique, quand saveObject est r��crit, c'est pour sauver des objets
            enfants juste apr�s l'objet principal.

           }
           procedure saveToStreamBase(f:TStream;Fdata:boolean);
           procedure saveToStream(f:TStream;Fdata:boolean);virtual;
           procedure saveToStream0(f:TStream;Fdata:boolean);

           procedure saveObject(var f:file;Fdata:boolean);
           {Appelle buildInfo et sauve le blocConf sur le disque
           }

           function loadFromStreamBase(f:Tstream;size:longWord;Fdata:boolean):boolean;
           function loadFromStream(f:Tstream;size:longWord;Fdata:boolean):boolean;virtual;

           {f pointe apr�s le nom du bloc et l'objet vient d'�tre identifi�
            loadObject charge les info disponibles
            size est la taille totale du bloc. Apr�s le pointeur fichier, il y a donc
            (size-4-1-length(nom)) octets.

            Quand un objet est propri�taire d'autres objets, ces objets sont sauv�s
            imm�diatement apr�s. LoadObject doit charger les objets poss�d�s.

            La valeur renvoy�e par la fonction n'est en fait pas utilis�e.
            }
           function loadObject(var f:file;size:LongWord;Fdata:boolean):boolean;

           function loadAsChild(f:Tstream;Fdata:boolean):boolean;
           {Quand un objet poss�de d'autres objets, il stocke ces objets juste
           apr�s lui. Quand il les recharge, il s'attend � trouver un objet
           du bon type avec la propri�t� Fchild ou NotPublished(pour les anciens objets).

           avec loadAsChild l'objet essaie de se charger. Si les conditions ci-dessus ne
           sont pas remplies, il replace le pointeur de fichier l� o� il l'a trouv�.
           }



           procedure chooseCoo(sender:Tobject);virtual;

           {Initialise est appel� quand l'utilisateur � choisi de cr�er un objet
           dans Object/New . Voir NouvelObjet1 .
           L'objet vient d'�tre cr�� et on lui donne le nom st. Certains objets doivent
           donner un nom aux objets poss�d�s.
           Parfois, on ouvre un dialogue pour inviter l'utilisateur � fixer certains
           param�tres.
           Si la fonction renvoie false, l'objet qui vient d'�tre cr�� est d�truit.
           }
           function initialise(st:AnsiString):boolean;virtual;

           {Par d�faut isVisual vaut FALSE. IsVisual vaut TRUE pour les objets visuels
           et certains objets (Tmatrix) qui peuvent s'afficher sur l'�cran de controle
           du SV. Quand isVisual=TRUE , l'objet est ajout� � la liste HKpaint � la cr�ation.
           }
           function isVisual:boolean;virtual;

           
           procedure RetablirReferences(list:Tlist);virtual;
           {
            Quand un objet contient des sous-objets, RetablirReferences doit
            appeler RetablirReferences des sous-objets.

            Le 22-9-99, les objets avec r�f sont  Acquis1, graphe, Multigraph,
            Stim, Curseur et Fit.

            RetablirReferences ne doit pas appeler des proc�dures faisant
            intervenir d'autres objets (ex: affichage dans Tmultigraph) car
            toutes les r�f�rences ne sont pas encore en place.

            En fait, RetablirReferences doit agir comme si les autres objets
            n'existaient pas.
           }
            procedure resetAll;virtual;
           {
            Apr�s RetablirReferences, resetToAll est appel�. L'objet est invit�
            � se r�afficher compl�tement o� � prendre en compte l'existence des
            autres objets.
           }

           procedure ClearReferences;virtual;
           {Si on charge un objet seul, il faut lui dire de remettre � nil ses
           �ventuelles r�f�rences (celles qui ont �t� charg�es).
           En fait, si BuildInfo est bien �crite, le chargement d'un objet laisse
           les r�f�rences � nil, ces r�f�rences �tant charg�es provisoirement
           ailleurs. C'est le cas de Tgraph ou TmultiGraph.  ClearReferences
           est alors inutile.
           }
           procedure FreeRef;virtual;
           {Lib�re les r�f�rences.
           Si on charge un objet d'un fichier dans un objet existant d�j�,
           il faut supprimer les r�f�rences existantes.
           }

           procedure resetMyAd;
           {range self dans myAd
           }
           procedure setChildNames;virtual;
           {Propage le nom de l'objet dans les objets enfant
           }
           procedure ChangeName(st:AnsiString);virtual;

           procedure ResetTitles;virtual;
           // Impose les noms par d�faut

           function clone(Fdata:boolean; const Fref:boolean=true):typeUO;virtual;
           procedure loadFromObject(uo:typeUO;Fdata:boolean);

           procedure copyDataFrom(p:typeUO);virtual;

           function getSysListPosition:integer;

           procedure ProcessMessage(id:integer;source:typeUO;p:pointer);
               virtual;

           function FindLimits(id:integer; var Amin,Amax:float):boolean;virtual;

           function controleRef(p:typeUO):boolean;
           function MessageToRef(id:integer;p:pointer):integer;
           {17-10-02: renvoie le nb de messages effectivement trait�s
                      De plus, le message n'est envoy� qu'une fois quand la reflist
                      contient plusieurs fois le m�me objet.
           }

           function getWindowHandle:integer;virtual;
           procedure show(sender:Tobject);virtual;



           procedure addToTree(tree:TtreeView;node:TtreeNode);virtual;
           { addToTree ajoute le nom de l'objet (et son adresse) au noeud node
           de l'arbre tree. Si l'objet poss�de des objets enfants, ces enfants
           seront accroch�s au noeud node.

             Depuis le 7-02-06, les noeuds sont d�velopp�s par expandTree.
             Il n'est pas n�cessaire de sucharger cette m�thode sauf si on veut
           compliquer l'arborescence comme dans TdataFile.
             En g�n�ral, l'objet se contente de ranger ses enfants dans childList.
           }

           function expandTree(tree:TtreeView;node:TtreeNode):boolean;virtual;
           { D�veloppe un noeud dans l'inspecteur d'objet.
             Si on r��crit addToTree, il faut aussi surcharger expandTree sauf si
             addToTree met tout en place.
           }

           procedure saveData(f:Tstream);virtual;
           function loadData(f:Tstream):boolean;virtual;

           {save et load permettent de sauver/charger les objets avec les
            donn�es qu'ils contiennent
            save appelle saveObject puis saveData
            load appelle loadObject puis loadData
            }
           procedure saveAsSingle(f:Tstream);virtual;
           function loadAsSingle(f:Tstream):boolean;virtual;


           function loadX(f:Tstream; Const Fref:boolean=true):boolean;
           // L'objet se charge � partir d'un fichier d'objets
           // Par d�faut (Fref=true), les r�f�rences charg�es sont effac�es.
           // On consid�re que l'objet est charg� isol�ment.

           function readDataHeader(f:Tstream;var size:integer):boolean;
           {Size est la taille des data}
           procedure writeDataHeader(f:Tstream;size:integer);
           {Size est la taille des data}

           function getInfo:AnsiString;virtual;
           { getInfo est utilis� par le visionneur d'objets}

           procedure bringToFront;
           { bringToFront concerne seulement les objets visuels de priorit� 1
             (les matrices)
           }

           procedure refObjet(pu:typeUO);
           procedure derefObjet(var pu:typeUO);

           procedure refVariant(var w);
           procedure derefVariant(var w);


           function refCount:integer;

           procedure specialDrop(Irect:Trect;x,y:integer);virtual;


           procedure initChildList;virtual;
           procedure clear;virtual;
           procedure invalidate;virtual;

           procedure setEmbedded(v:boolean);virtual;
           function getEmbedded:boolean;virtual;
           property Embedded:boolean read getEmbedded write setEmbedded;

           function ActiveEmbedded(TheParent:TwinControl; x1,y1,w1,h1:integer): Trect;virtual;
           procedure UnActiveEmbedded;virtual;
           procedure PaintImageTo(DC: HDC;x,y:integer);virtual;

           procedure addToStimList(list:Tlist);virtual;

           procedure AddToChildList(uo:typeUO);virtual;
           {Ajoute uo � ChildList, positionne uo.Fchild et uo.UOowner}
           procedure ClearChildList;

           procedure CreateClone(sender:Tobject);virtual;
           {Appel� par la commande popup Clone}

           procedure saveObjectToFile(sender:Tobject);virtual;
           {Appel� par la commande popup Save Object}


           procedure Verify;
           function isModified:boolean;virtual;

           procedure swapFont(var font:Tfont;var color:integer);virtual;
           {Echange la fonte de l'objet avec celle qui est fournie en param�tre
            On �change les pointeurs }

           procedure swapVisu(visu1: PvisuInfo;flags: PvisuFlags); virtual;

           class function PgType:integer;
           {Renvoie le num�ro de type dans un programme PG2}

           class function PgChildOf(num:integer):boolean;
           {l'objet descend-t-il du num�ro num ? }

           function PgAddress:pointer;
           {renvoie l'adresse de la variable qui a cr�� l'objet ou bien l'adresse du champ myAd}

           { Dans Multigraph, le premier objet d'une fen�tre peut contr�ler l'affichage des autres
             Voir Multg1.displayG
             Dans ce cas il peut fixer la fen�tre d'affichage et le world
             Num2 est le num�ro d'ordre
              }
           procedure SetCurrentWorld(num2:integer;x1w,y1w,x2w,y2w:float);virtual;
           function SetCurrentWindow(num2:integer; rectI:Trect):boolean;virtual;

           { Le premier objet peut aussi modifier les params des objets secondaire (modify)
             puis les restaurer (restore).
             ModifyPlot est appel� avant displayInside
             RestorePlot est appel� apr�st displayInside
             On peut inclure des affichages compl�mentaires.
           }
           procedure ModifyPlot(num2:integer;plot:typeUO);virtual;
           procedure RestorePlot(num2:integer;plot:typeUO);virtual;

           procedure getUserPopUp(m:TmenuItem);
           procedure UserPopUpEvent(sender:Tobject);
           procedure AddUserPopUpItem(st:AnsiString; ad:integer);
           procedure resetUserPopUp;


           function is3D:boolean;virtual;
           procedure Display3DX(Idevice: IDirect3DDevice9);virtual;
           procedure FreeDXresources;virtual;
           function getD3DZ: integer;virtual;
           

           function HasMgClickEvent:boolean;virtual;


           procedure AddVar(p: pointer);
           procedure Freevar(p:pointer);

           function getMxArray(Const tpdest0:typetypeG = G_none):MxArrayPtr;virtual;
           procedure setMxArray(mxArray:MxArrayPtr;Const invertIndices:boolean=false);virtual;

           procedure setDoNotCopyAlpha(v:boolean);virtual;
           function getDoNotCopyAlpha:boolean;virtual;
           property DoNotCopyAlpha:boolean read getDoNotCopyAlpha write setDoNotCopyAlpha;

           function SetBlendOp: boolean;virtual;
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

                  function firstName(st:AnsiString):AnsiString;
                  function existe(st:AnsiString):boolean;
                  function accept(st:AnsiString):boolean;
                  function getAd(st:AnsiString):typeUO;
                  procedure add(p:typeUO;status:TUOstatus);
                  procedure supprime(p:typeUO);

                  procedure clear(tout:boolean);

                  procedure loadFromStream(f:Tstream;tailleInfo:integer;tout:boolean);
                  procedure loadObjects(var f:file;tailleInfo:integer;tout:boolean);

                  {Tout=true pour la cfg de base}
                  procedure saveObjects(var f:file);
                  procedure saveToStream( f:Tstream);

                  procedure RetablirReferences;
                  procedure resetAll;

                  procedure verifyMulti(cc:TUOclass);


               end;

var
  MainObjList:TMainObjList;

  stmTresizable:TUOclass;


type
  {syslist (de type TsystemList) contient TOUS les objets UO existant
  Tous les objets UO se rangent eux-m�mes dans cette liste au moment de leur
  cr�ation et se retirent au moment de leur destruction.

  15 juin 2017 :  remove se contente de mettre l'item � nil pour ne pas perturber les SysIndex
                  pack supprime les items valant nil et recalcule les SysIndex
                  pack doit �tre appel� par FillTreeView
                  Toutes les fonctions doivent v�rifier qu'un item ne vaut pas nil
  }
  TsystemList=class(Tlist)
                FModified:boolean;   {utilis� par l'inspecteur d'objet}
                HK: boolean;
                constructor create(IsHK: boolean);
                function Add(Item: typeUO): Integer;
                function Remove(Item: typeUO): Integer;
                procedure Delete(Index: Integer);
                procedure inspect;
                procedure clear;
                function ObjectByName(st:AnsiString):typeUO;
                function existe(st:AnsiString):boolean;

                procedure FillTreeView(treeView:TtreeView;var ob:typeUO;Fsort:boolean);
                procedure SortVisual;
                procedure SortThisVisualObject(n:integer);
                procedure pack;
              end;


var
  sysList:TsystemList;


{ TGvariant pose un probl�me: dans Delphi, quand un record est pass� par valeur � une proc�dure,
  le syst�me s'efforce de maintenir le compteur de r�f�rence des chaines longues contenues dans
  le record.

  TGvariant a le type object, sans constructeur, sans m�thodes virtuelles, afin de pouvoir
  le consid�rer comme un record auquel sont associ�es des m�thodes.
  Dans cette situation, la gestion du compteur de r�f�rences fonctionne mal.

  Il faut donc imp�rativement �viter le passage de TGvariant par valeur, sinon on obtient des
  pertes de m�moire.

}

type
  TGVariantType = (gvNull, gvBoolean, gvInteger, gvFloat,  gvString, gvDateTime,gvObject, gvComplex,gvDouble,gvDcomplex);
  { gvDouble et gvDComplex ne sont jamais utils�s en interne, mais seulement par la sauvegarde en win64
  }

Const
  TGvariantTypeName: array[TGvariantType] of AnsiString= (
                      'Null',
                      'Boolean',
                      'Integer',
                      'Float',
                      'String',
                      'DateTime',
                      'Object',
                      'Complex',
                      'Double',
                      'Dcomplex');


type
  TrefUO=class;

  TrecGvariant= record
                  VString: AnsiString;
                  ClearFlag:boolean;
                case VType: TGVariantType of
                  gvBoolean:    (VBoolean: Boolean);
                  gvInteger:    (VInteger: Int64);
                  gvFloat:      (VFloat: Extended);
                  gvComplex:    (Vcomplex: TfloatComp);
                  gvDateTime:   (VdateTime:TdateTime);
                  gvObject:     (Vref:TrefUO);
                end;




  TGvariant=object                               {15 octets devenus 25 avec les complexes}
            public
              rec:TrecGvariant;
              procedure setString(w:Ansistring);
              procedure setBoolean(w:boolean);
              procedure setInteger(w:int64);
              procedure setFloat(w:float);
              procedure setComplex(z:TfloatComp);
              procedure setDateTime(w:TdateTime);

              procedure setObject(w:TypeUO);
              function getObject:typeUO;
            public
              property Vtype:TGvariantType read rec.Vtype write rec.Vtype;
              property Vstring:Ansistring read rec.Vstring write setString;
              property Vboolean:boolean read rec.Vboolean write setboolean;
              property Vinteger:int64 read rec.Vinteger write setinteger;
              property Vfloat:float read rec.Vfloat write setfloat;
              property Vcomplex:TfloatComp read rec.Vcomplex write setComplex;
              property VdateTime:TdateTime read rec.VdateTime write setdateTime;
              property Vobject:TypeUO read getObject write setobject;
              property Fchecked:boolean read rec.ClearFlag write rec.ClearFlag;


              procedure init;
              procedure finalize;

              function VarAddress:pointer;
              procedure AdjustObject;
              procedure showStringInfo;
              function UDiskSize:integer;
              function getValString(const Ndeci:integer=6):Ansistring;
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


{
  un UO peut envoyer un message � d'autres objets avec MessageToRef
  un UO re�oit ces messages avec ProcessMessage }

{ UOmsg_invalidate signale que la source a �t� modifi�e et qu'il est n�cessaire de
  r�afficher.

  UOmsg_update est utilis� par Daffac1.

  UOmsg_Coupling signale aux objets coupl�s qu'il est n�cessaire de modifier
  leurs coordonn�es et de se r�afficher.

  UOmsg_destroy signale que l'objet source va �tre d�truit de fa�on autoritaire
  et qu'il est n�cessaire de couper toutes les r�f�rences � cet objet.

  UOmsg_cursor est envoy� par Tcursor pour signaler qu'il doit �tre affich� ou
  effac�

  UOmsg_SimpleRefresh est envoy� par l'objet lui-m�me pour forcer son r�affichage
  partiel. Le m�canisme est le suivant:
  un flag interne est positionn�. Le message est envoy�. La m�thode Display est donc
  appel�e une ou plusieurs fois. Compte tenu du flag interne, l'objet r�affiche ce
  qu'il voulait faire r�afficher. Le flag est ensuite effac�.
  A la diff�rence de UOmsg_invalidate, le cadre multigraph ne sera pas effac� au
  pr�alable.

  UOmsg_DisplayGUI est un envoy� par un objet � un objet multigraph (par exemple)
  pour lui signaler qu'il souhaite afficher quelque chose temporairement.
  En retour, Multigraph
     - s�lectionne le canvas de l'�cran
     - s�lectionne le (ou les cadres) et r�affiche son BM
     - appelle DisplayGUI de l'objet

}

const
  UOmsg_invalidate=1;
  UOmsg_update=2;
  UOmsg_destroy=3;

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

  UOmsg_updateBM=20;

  UOmsg_couplingX =21;
  UOmsg_couplingY =22;
  UOmsg_couplingZ =23;

  UOmsg_FreeDXResources = 24;

{ FlagClock de type ThreadFclock est un timer lanc� avec DAC2. Il positionne dix
flags toutes les 100 ms.
Le num�ro 1 est r�serv� aux programmes.
Le num�ro 2 est utilisable par les op�rations de calcul devant �tre interrompues
}

type
  ThreadFclock=class(Tthread)
                 Flag:array[1..10] of boolean;
                 procedure execute;override;
               end;

var
  FlagClock:ThreadFclock;


{Tentative d'unifier les drag and drop.

 On part du principe qu'il n'y a qu'une seule op�ration de DnD � la fois.
 A la source, en appelant BeginDrag, on positionne les deux objets ci-dessous.

 On remarquera que l'objet source dans les gestionnaires d'�v�nement Dnd est un
composant Delphi, pas un UO.

 ResetDragUO remet les deux variables � nil . Le plus simple est d'appeler ResetDragUO
 dans EndDrag.
 ResetDragUO serait n�cessaire si on introduisait d'autres formes de DnD dans Elphy.
 Actuellement, c'est juste une s�curit�.
}

var
  DragUOsource:typeUO;
  DraggedUO:typeUO;


  FlagObjectFile:boolean; {Positionn� par TobjectFile pour emp�cher de charger
                           un objet Multigraph dans formStm }


var
  HKpaint:Tsystemlist;    { Liste des objets visuels }
  MaskList: Tlist;        { Liste des objets visuels ayant leur prop Mask=true }

  FirstUOpopup:typeUO;    {affect� dans multigraph.mouseDown}

  MainObjFileList:Tlist;


procedure resetDragUO;


function getFlagClock(num:integer):boolean;



function NomParDefaut0(st0:AnsiString):AnsiString;
function NomControle(ref:TUOclass;name:AnsiString):AnsiString;

{ On donne stmClassName (pas de T au d�but), on obtient la classe }
function StmClass(stMot:AnsiString):TUOclass;

function createUO(stMot:AnsiString;tout:boolean):typeUO;
{ createUO cr�e un objet dont le type correspond � stMot=stmClassName avec un
  nom par d�faut.
  renvoie nil si stMot n'existe pas
  Tout ne concerne que VisualStim. Si Tout est vrai, VisualStim est charg�
  }
function readHeader(f:Tstream;var size:longWord):AnsiString;
{ Lit l'ent�te de bloc (size+motCl�) . Le pointeur de fichier se trouve
  ensuite apr�s cet ent�te
}

function readAndCreateUO(f:Tstream;status:TUOstatus;tout:boolean;Fdata:boolean):typeUO;
{ Lit l'ent�te de bloc (size+motCl�) puis essaie de cr�er l'objet.
  A la fin, le pointeur de fichier se trouve toujours � la fin du bloc.
  Renvoie l'objet ou bien NIL
  pg positionne le flag FPG.
  Tout ne concerne que VisualStim. Si Tout est vrai, VisualStim est charg�
}

function FindUOclassName(st:string;var stMot:string):integer;
{ Cherche un mot cl� dans st }

procedure verifierObjet(var pu:typeUO);


procedure proTSystem_ControlON(ww:boolean;var pu:typeUO); pascal;
function fonctionTSystem_ControlON(var pu:typeUO):boolean; pascal;


function fonctionAssigned(var pu:typeUO):boolean; pascal;


function fonctionTobject_sysname(var pu:typeUO):AnsiString;pascal;

function fonctionTobject_tag(var pu:typeUO):integer;pascal;
procedure proTobject_tag(w:Integer;var pu:typeUO);pascal;

function fonctionTobject_stCom(var pu:typeUO):AnsiString;pascal;
procedure proTobject_stCom(w:AnsiString;var pu:typeUO);pascal;



function GetGlobalList(tp:TUOclass;withRF:boolean):Tlist;
function getGlobalObject(st:AnsiString):typeUO;

procedure InstalleComboBox(cb:TcomboBox;ob:TypeUO;TUO:TUOclass);
function recupComboBox(cb:TcomboBox):pointer;

{function WaitVideo:boolean;}
procedure registerObject(ref:TUOclass;genre:TgenreUO);
{range le type et le nom de l'objet dans UOnameList }
{Les objets enregistr�s
  - seront reconnus au moment du chargement.
  - apparaitront dans le menu Object/New sauf si leur cat�gorie est sys.
}

procedure PrintUOnameList;

function nouvelObjet(numType:integer): typeUO;
{Appel�e par le menu Object/New }

function nouvelObjet1(UOclass:TUOclass):typeUO;
{cree l'objet de type UOclass
 propose un changement de nom
 appelle initialise
 range l'objet dans MainObjList
}

function CreerObjet(tp:TUOclass; const BaseName:AnsiString=''):typeUO;
{ Idem mais sans appeler Initialise
}

function CloneObjet(p:typeUO):typeUO;

function UOident(uo:typeUO):AnsiString;

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


procedure proTObject_loadObject(stF:AnsiString;var pu:typeUO);pascal;
procedure proTObject_SaveAsObject(stF:AnsiString;var pu:typeUO);pascal;

function fonctionTobject_getIndex(num:integer; var pu:typeUO):integer;pascal;

procedure initStmObj;




IMPLEMENTATION


uses binFile1,ObjFile1,objName1,saveObj1,stmdf0,stmPg,dacadp2, stmVS0;


{**************************** M�thodes de typeUO **************************}

constructor typeUO.create;
  begin
    inherited create;
    myAd:=self;
    ident:='_'+stmClassName;

    sysList.add(self);            { ATTENTION l'appel de create comme proc�dure ordinaire }
    if isVisual then              { est impossible � cause de ces instructions. }
    begin
      HKPaint.add(self);
      HKpaint.SortThisVisualObject(HKpaint.count-1);
    end;

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
    {Les objets doivent appeler messageToRef(UOmsg_destroy,nil) de pr�f�rence
     au d�but de destroy }

    reference.free;
    reference:=nil;
    childList.free;

    resetUserPopUp;
  end;

class function typeUO.STMClassName:AnsiString;
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
  if isvisual and assigned(visualstim) and  (visualStim.form<>nil) then visualStim.FXcontrol.invalidate;
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

procedure typeUO.afficheSDX9(TheMasks:boolean);
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

procedure typeUO.displayInside(FirstUO:typeUO;extWorld,logX,logY:boolean;const order:integer=-1);
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

function typeUO.getIdent:AnsiString;
begin
  result:=identNew;
end;

procedure typeUO.setIdent(st:AnsiString);
begin
  identNew:=st;
  if st<>'_'+stmClassName then setChildNames;
  {Le nom par d�faut est fix� alors que create n'est pas compl�tement ex�cut�}
end;


function typeUO.getTitle:AnsiString;
begin
  result:=ident;
end;

procedure typeUO.setTitle(st:AnsiString);
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

procedure typeUO.MouseUpMG(x,y:integer; mg:typeUO);
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
          if lecture then
          begin
            new(identOld);
            identOld^:='';
            setvarConf('IDENT',identOld^,sizeof(identOld^));
            myad:=nil;
          end;

          setStringConf('IDENT1',identNew);
          setvarConf('MYAD',myAd, sizeof(integer) {sizeof(myAd)});  // en 64 bits, on ne prend que la partie basse de l'adresse
        end;
      setvarConf('NOTPUB',NotPublished,sizeof(NotPublished));

      setvarConf('FCHILD',Fchild,sizeof(Fchild));
      setvarConf('Fsload',FsingleLoad,sizeof(FsingleLoad));
      setStringConf('COM',stComment);

      if not lecture then
        setvarConf('OWNER',UOowner,sizeof(UOowner));

    end;
  end;

procedure typeUO.saveToStreamBase(f:TStream;Fdata:boolean);
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

procedure typeUO.saveToStream(f:TStream;Fdata:boolean);
begin
  saveToStreamBase(f,Fdata);
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

procedure typeUO.CheckOldIdent;
begin
  if assigned(identOld) and (identOld^<>'') then ident:=identOld^;
  dispose(identOld);
  identOld:=nil;
end;


procedure typeUO.completeLoadInfo;
begin
  CheckOldIdent;
end;

procedure typeUO.completeSaveInfo;
  begin
  end;

function readHeader(f:Tstream;var size:longword):AnsiString;
var
  st1:String[25];
begin
  f.readBuffer(size,sizeof(size));     { lire taille }
  f.readBuffer(st1,1);                 { et      }

  if length(st1)<25
    then f.readBuffer(st1[1],length(st1))    { mot-cl� }
    else st1:='';
    
  if size<5+length(st1) then
    begin
      size:=0;
      result:='';
    end
  else result:=st1;
end;


function readAndCreateUO(f:Tstream;status:TUOstatus;tout:boolean;Fdata:boolean):typeUO;
var
  posf:int64;
  st1:AnsiString;
  p:typeUO;
  size:longWord;
begin
   posf:=f.position;                  {noter la position de d�part}
   st1:=readHeader(f,size);           {lire l'ent�te}

   p:=CreateUO(st1,tout);             { cr�er l'objet si possible }
   if assigned(p) then
     begin
       p.loadFromStream(f,size,Fdata);{ si ok, demander � l'objet de charger ses param�tres }
       p.Fstatus:=status;
     end
   else f.Position:=posf+size;           {sinon, aller � la fin du bloc }

   result:=p;
end;


function typeUO.loadFromStreamBase(f:Tstream;size:LongWord;Fdata:boolean):boolean;
var
  ok:boolean;
  conf:TblocConf;
  st:AnsiString;
  posf:int64;
begin
  conf:=TblocConf.create(stmClassName);
  BuildInfo(conf,true,true);
  ok:=(conf.lire1(f,size)=0);
  conf.free;

  if ok then
    begin
      if not NotPublished then
        begin
          st:=ident; {L'objet pouvant �tre d�j� dans mainObjList, on modifie ident}
          ident:=''; {pour que le nom ne soit pas refus� }
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

function typeUO.loadFromStream(f:Tstream;size:LongWord;Fdata:boolean):boolean;
begin
  result:=loadFromStreamBase(f,size,Fdata);
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


procedure typeUO.chooseCoo(sender:Tobject);
begin
end;

function typeUO.initialise(st:AnsiString):boolean;
begin
  ident:=st;
  title:=ident;
  result:=true;
end;

function typeUO.isVisual:boolean;
begin
  result:=false;
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

function typeUO.clone(Fdata:boolean; const Fref:boolean=true):typeUO;
var
  f:TmemoryStream;
  st1:AnsiString;
  size:LongWord;
begin
  f:=TmemoryStream.create;
  try
    saveToStream0(f,Fdata);
    result:=TUOclass(classType).create;
    f.Position:=0;
    st1:=readHeader(f,size);
    result.loadFromStream(f,size,Fdata);

    if Fref then                   // Danger!
    with result do                 // si on appelle clone avec Fref=false
    begin                          // il faut g�rer ces 5 lignes correctement
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




function typeUO.controleRef(p:typeUO):boolean;
begin

{$IFDEF DEBUG}
  result:=syslist.indexof(p)>=0;
  if not result then
    begin
      messageCentral('Ref doesn''t exist: '+ident+'  /  '+p.ident  );
      reference.remove(p);
      {Probl�me: messageToRef reprendra au d�but de la liste}
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

  {ajout� le 07-03-03}
  if assigned(UOowner)
    then UOowner.ProcessMessage(id,self,p);

  if loadingObjects or not assigned(reference) or (refCount<=0) then exit;

  {La construction qui suit est obligatoire car des objets peuvent retir�s de
   syslist � l'int�rieur de la boucle.
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

function typeUO.FindLimits(id: integer; var Amin, Amax: float): boolean;
begin
  result:=false;
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
            {7-02-06 : on ne d�veloppe plus l'arbre � la cr�ation de la liste dans l'insp.}
begin

  p:=tree.Items.addChildObject(node,ident,self);

  if assigned(childList) and (childList.count>0)
    then tree.Items.addChildObject(p,'Dummy',nil) { on ajoute un �l�ment bidon pour afficher une case "+" }
end;

            { les noeuds sont d�velopp�s � la demande de l'utilisateur }
function typeUO.expandTree(tree:TtreeView;node:TtreeNode):boolean;
var
  i:integer;
begin
  result:=true;
  if not assigned(childList) then exit;

  if (node.count>0) and (node[0].data=nil) and (node[0].text='Dummy') then
  begin
    node[0].delete;

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


function TypeUO.LoadX(f:Tstream; Const Fref:boolean=true):boolean;
var
  posf:int64;
  st1:AnsiString;
  size:LongWord;

  oldId:AnsiString;
  oldFchild:boolean;
  OldNotPub:boolean;
  oldReadOnly:boolean;
begin
  posf:=f.position;                 {noter la position de d�part}
  st1:=readHeader(f,size);          {lire l'ent�te}

  result:=(st1=stmClassName);
  if result then
    begin
      oldId:=ident;
      oldFchild:=Fchild;
      OldNotPub:=NotPublished;
      oldReadOnly:=readOnly;
      try
        freeRef;
        loadFromStream(f,size,true);{ si ok, demander � l'objet de se charger: params+data }

      finally
        ident:=oldId;               { r�tablir les param�tres qui ne doivent pas changer }
        Fchild:=oldFchild;
        NotPublished:=oldNotPub;
        ReadOnly:=OldReadOnly;

        if Fref then
        begin
          clearReferences;
          resetMyAd;
          setChildNames;
        end;
      end;
    end;


  if not result then f.position:=posf;      {sinon, retour au d�but du bloc }
end;

procedure typeUO.loadFromObject(uo:typeUO;Fdata:boolean);
var
  f:TmemoryStream;
  st1:AnsiString;
  size:LongWord;

  oldIdent:AnsiString;
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

procedure TypeUO.saveAsSingle(f:Tstream);
begin
end;

function TypeUO.LoadAsSingle(f:Tstream):boolean;
begin
  result:=true;
end;


function typeUO.readDataHeader(f:Tstream;var size:integer):boolean;
var
  header:TdataHeader;
  posf:int64;
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

function typeUO.getInfo:AnsiString;
begin
  if ident<>'' then  result:=CRLF+ident +' : ';
  result:=result+'T'+stmClassName+CRLF;
  if stComment<>'' then result:=result+stComment+CRLF;


  //result:=result + 'myad='+ Pstr(myAd)+CRLF;

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
{**************************** M�thodes de TsystemList ********************}

constructor TsystemList.create(IsHK: boolean);
begin
  inherited create;
  Fmodified:=true;
  HK:= isHK;
end;


function TsystemList.Add(Item: typeUO): Integer;
begin
  result:=inherited add(item);
  if not HK then item.SysIndex:=result;
  Fmodified:=true;
end;

function TsystemList.Remove(Item: typeUO): Integer;
begin
  if HK
    then result:=inherited remove(item)
    else items[Item.SysIndex]:=nil;
  Fmodified:=true;
end;

procedure TsystemList.Delete(Index: Integer);
begin
  //inherited delete(index);
  messageCentral('Interdit');

  Fmodified:=true;
end;

procedure TsystemList.clear;
begin
  inherited;
  Fmodified:=true;
end;

const
  tabStatus:array[TUOstatus] of String[5]=('Main','Temp','PG');

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
    memo1.lines.add('Allocated memory = '+Estr1(getHeapStatus.totalAllocated/1E6,12,6)+' Mb');

    memo1.lines.add('');
    memo1.lines.add(memManager.Info);
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

function TsystemList.existe(st:AnsiString):boolean;
var
  i:integer;
begin
  st:=Fmaj(st);
  for i:=0 to count-1 do
    if (items[i]<>nil) and (Fmaj(typeUO(items[i]).ident)=st) then
      begin
        result:=true;
        exit;
      end;
  result:=false;
end;


function TsystemList.ObjectByName(st:AnsiString):typeUO;
var
  i:integer;
begin
  result:=nil;
  if st='' then exit;
  st:=Fmaj(st);

  for i:=0 to count-1 do
    if (items[i]<>nil) and (Fmaj(typeUO(items[i]).ident)=st) then
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
    result:=FindNode(p,vv[i]);
    if result<>nil then exit;
  end;
end;

type
  TdumUO=class( typeUO)
           constructor create;override;
           procedure AddToChildList(uo:typeUO);override;
         end;

constructor TdumUO.create;
begin
  // on n'ins�re pas l'objet dans syslist
end;

procedure TdumUO.AddToChildList(uo:typeUO);
begin
  if not assigned(childList)
    then childList:=Tlist.create;

  childList.Add(uo);
end;

var
  DumList: TstringList;

procedure TsystemList.FillTreeView(treeView:TtreeView;var ob:typeUO;Fsort:boolean);
var
  ob1:typeUO;
  i,k:integer;
  p0:TtreeNode;
  DumNode: TdumUO;
  stBase:string;
begin
  pack;
  if not assigned(DumList) then DumList:= TstringList.create
  else
  with DumList do
  begin
    for i:=0 to count-1 do TdumUO(objects[i]).Free;
    DumList.Clear;
  end;

  with treeView do
  begin
    items.clear;
    items.BeginUpDate;
    for i:=0 to self.count-1 do
      begin
        ob1:=TypeUO(self.items[i]);
        if(ob1<>nil) and  not (ob1.Fchild or ob1.notPublished) then
        begin
          k:= pos('[',ob1.ident);
          if k>0 then                                          // gestion des variables tableau
          begin
            stBase:= copy(ob1.ident,1,k-1);

            k:=DumList.indexof(stBase);
            if k<0 then
            begin
              DumNode:=tdumUO.create;
              DumNode.ident:=stBase;
              DumList.AddObject(stBase,DumNode);
              DumNode.AddToChildList(ob1);
              DumNode.addToTree(treeView,nil);
            end
            else
            begin
              DumNode:= pointer(DumList.objects[k]);
              DumNode.AddToChildList(ob1);
            end;
          end
          else ob1.addToTree(treeView,nil);
        end;
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

function sortVS (Item1, Item2: Pointer): Integer;
begin
  if typeUO(Item1).getD3DZ>typeUO(Item2).getD3DZ then result:=-1
  else
  if typeUO(Item1).getD3DZ<typeUO(Item2).getD3DZ then result:=1
  else result:=0;
end;

procedure TsystemList.SortVisual;
begin
  sort(sortVS);
end;

procedure TsystemList.SortThisVisualObject(n: integer);
var
  n1:integer;
begin
  n1:=n;
  while (n1>0) and (typeUO(items[n1-1]).getD3DZ < typeUO(items[n]).getD3DZ) do dec(n1);
  while (n1<count-1) and (typeUO(items[n1+1]).getD3DZ > typeUO(items[n]).getD3DZ) do inc(n1);
  if n1<>n then move(n,n1);
end;

procedure TsystemList.pack;
var
  i,k: integer;
  changed: boolean;
begin
  changed:= false;
  k:=0;
  for i:=0 to count-1 do
    if (items[i]<>nil) then
    begin
      typeUO(items[i]).sysIndex:=k;
      inc(k);
    end
    else changed:= true;
  if changed then inherited pack;
end;

{************************ M�thodes de TmainObjList *********************}

constructor TMainObjList.create;
begin
  uoBase:=typeUO.create;
  uobase.Fchild:=true;
  uobase.NotPublished:=true;
  uobase.ident:='MainList';
  inherited;
end;

function TMainObjList.firstName(st:AnsiString):AnsiString;
var
  i:integer;
  st0:AnsiString;
begin
  i:=0;
  repeat
    inc(i);
    st0:=st+Istr(i);
  until not existe(st0);

  result:=st0;
end;

function TMainObjList.existe(st:AnsiString):boolean;
  var
    i:integer;
    st1:AnsiString;
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

function TMainObjList.accept(st:AnsiString):boolean;
begin
  result:=not existe(st)
          and
          (pos('.',st)<=0)
          and
          (pos(' ',st)<=0);
end;

function TMainObjList.getAd(st:AnsiString):typeUO;
  var
    i: integer;
    st1:AnsiString;
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

procedure TMainObjList.verifyMulti(cc: TUOclass);
var
  i,n: integer;
begin
  n:=0;
  for i:=0 to count-1 do
    if typeUO(items[i]) is cc then
    begin
      typeUO(items[i]).ident:=stMultigraph0;
      inc(n);
      if n>1 then
      begin
        typeUO(items[i]).Free;
        items[i]:=nil;
      end;
    end;
  if n>1 then pack;
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
  st,lastSt:AnsiString;
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
  { Le pointeur de fichier pointe sur le d�but du bloc info global}
  { La taille de ce bloc est tailleInfo }
  var
    posMax:int64;
    p:typeUO;
  begin
    loadingObjects:=true;
    clear(tout);                               { vider la liste }

    AffDebug('',1);
    AffDebug('mainObjList.LoadObjects '+Istr(f.size),1);
    posMax:=f.position+tailleinfo;            { Limite fichier }
    if posmax>f.Size then posmax:=f.size;

    repeat
      p:=readAndCreateUO(f,UO_temp,tout,false);
      if assigned(p) then
        begin
          affdebug('Loading '+p.ident,0);
          if p.Fchild or (not tout and p.FSingleLoad) then p.free
          else add(p,UO_main);
        end;
    until (f.position>=posmax)  or testEscape;
    f.Position:=posMax;

    syslist.pack;
    RetablirReferences;

    loadingObjects:=false;
    {ResetAll; d�plac� dans nouvelleCg}


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

procedure TmainObjList.saveToStream( f:Tstream);
var
  i:integer;
begin
  HKpaintSetZ;
  for i:=0 to count-1 do
    with TypeUO(items[i]) do
    if Fstatus=UO_main
      then saveToStream0(f,false);
end;


procedure TmainObjList.RetablirReferences;
var
  i:integer;
begin
  for i:=0 to count-1 do
    TypeUO(items[i]).RetablirReferences(sysList);

  for i:=0 to syslist.count-1 do
    if syslist.items[i]<>nil then TypeUO(syslist.items[i]).myAd:=syslist.items[i];
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
 et descendant de tp, en �vitant les r�p�titions}

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

function getGlobalObject(st:AnsiString):typeUO;
var
  i:integer;
begin
  st:=Fmaj(st);
  with syslist do
    for i:=0 to count-1 do
      if (items[i]<>nil) and (Fmaj(typeUO(items[i]).ident)=st) then
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




{************** M�thodes de ThreadFclock ********************************}

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

function NomParDefaut0(st0:AnsiString):AnsiString;
  { on ajoute un num�ro au nom de base et on incr�mente ce num�ro jusqu'�
    ce que l'on obtienne un nom qui n'existe pas dans les 2 listes }
  begin
    result:=MainObjList.firstName(st0);
  end;

function NomControle(ref:TUOclass;name:AnsiString):AnsiString;
  { name est un nom propos� par l'utilisateur. On le garde s'il n'existe pas.
    Sinon, on donne un nom par d�faut avec num�ro }
  begin
    name:=Fsupespace(name);
    if (name='') or MainObjList.existe(name)
      then nomControle:=nomParDefaut0(ref.stmClassName)
      else nomControle:=name;
  end;


{************** M�thodes STM  de typeSYS *****************************}

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


{ createUO cr�e un objet dont le type correspond � stMot=stmClassName avec un
  nom par d�faut.
  renvoie nil si stMot n'existe pas}
function createUO(stMot:AnsiString;tout:boolean):typeUO;
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

function FindUOclassName(st:string;var stMot:string):integer;
var
  g:TgenreUO;
  i:integer;
begin
  for g:=low(TgenreUO) to high(TgenreUO) do
    for i:=0 to UOnameList[g].count-1 do
    begin
      stMot:= UOnameList[g].strings[i];
      result:=pos(stMot,st);
      if (result>0) and (byte(st[result-1])<>length(stMot)) then result:=0;
      if result>0 then exit;
    end;
end;


function StmClass(stMot:AnsiString):TUOclass;
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
//      AffDebug(self.ident+' r�f�rence '+pu.ident+' count='+Istr(refCount),15 );
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
//     AffDebug(self.ident+' d�r�f�rence '+pu.ident+' count='+Istr(refCount),15 );
    end;
  pu:=nil;
end;

procedure typeUO.refVariant(var w);
var
  variant: TGvariant absolute w;
begin
  if (variant.rec.VType=gvObject) then refObjet(variant.rec.Vref);
end;

procedure typeUO.derefVariant(var w);
var
  variant: TGvariant absolute w;
  uo: typeUO;
begin
  if (variant.rec.VType=gvObject) then
  begin
    uo:=variant.rec.Vref;
    derefObjet(uo);
  end;
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

function typeUO.ActiveEmbedded(TheParent:TwinControl; x1,y1,w1,h1:integer): Trect;
begin
  result:=rect(0,0,0,0);
end;

procedure typeUO.UnActiveEmbedded;
begin
end;

procedure typeUO.PaintImageTo(DC: HDC;x,y:integer);
begin

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

procedure typeUO.ChangeName(st:AnsiString);
var
  st1:AnsiString;
  k:integer;
begin
  st1:=ident;
  k:=pos('.',st1);
  if k>0 then
  begin
    delete(st1,1,k-1);
    identNew:= st+st1;
  end
  else identNew:= st;
end;

procedure typeUO.ResetTitles;
begin
end;

procedure typeUO.saveObjectToFile(sender: Tobject);
var
  oac:TobjectFile;
const
  AppendSave:boolean=false;
  stSave:AnsiString='*.oac';
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



function typeUO.getReadOnly: boolean;
begin
  result:=false;
end;

procedure typeUO.setReadOnly(v: boolean);
begin
end;

function typeUO.GetIsMask:boolean;
begin
  result:= false;
end;

procedure typeUO.SetIsMask(w:boolean);
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

procedure typeUO.swapVisu(visu1: PvisuInfo;flags: PvisuFlags);
begin
end;

class function typeUO.PgType: integer;
begin
  result:=tabProc2.getNumObj('T'+stmClassName);
end;

class function typeUO.PgChildOf(num: integer): boolean;
begin
  result:=tabProc2.IsChild(PgType,num);
end;

function typeUO.PgAddress: pointer;
begin
  if PgAd<>nil
    then result:=PgAd
    else result:=@myAd;
end;

function typeUO.SetCurrentWindow(num2: integer; rectI: Trect):boolean;
begin
  with rectI do Dgraphic.setWindow(left,top,right,bottom);
  result:=true;
end;

procedure typeUO.SetCurrentWorld(num2: integer; x1w, y1w, x2w, y2w:float);
begin
  Dgraphic.setWorld(x1w, y1w, x2w, y2w);
end;

procedure typeUO.ModifyPlot(num2:integer;plot: typeUO);
begin

end;

procedure typeUO.RestorePlot(num2:integer;plot: typeUO);
begin

end;

procedure typeUO.getUserPopUp(m: TmenuItem);
var
  i:integer;
  mj:TmenuItem;
begin
  if assigned(UserPopUp) then
  begin
    if (UserPopUp.Count>0) and not PPG2event(UserPopUp.Objects[0]).valid then
    begin
      resetUserPopUp;
      exit;
    end;

    for i:=0 to UserPopUp.count-1 do
    begin
      mj:=TmenuItem.create(m);
      mj.caption:=UserPopUp[i];
      mj.onClick:=UserPopUpEvent;
      mj.tag:=i;
      m.add(mj);
    end;
  end;
end;

procedure typeUO.UserPopUpEvent(sender:Tobject);
var
  p:^TPG2event;
  i:integer;
begin
  i:=TmenuItem(sender).tag;
  p:=pointer(UserPopUp.Objects[i]);
  if p^.valid then p^.Pg.executerPopUpClick(p^.Ad, self);
end;

procedure typeUO.AddUserPopUpItem(st:AnsiString; ad:integer);
var
  p:^TPG2event;
begin
  if not assigned(UserPopUp) then UserPopUp:=TstringList.create;
  new(p);
  p^.setAd(ad);
  UserPopUp.AddObject(st,Tobject(p));
end;

procedure typeUO.resetUserPopUp;
var
  i:integer;
  p:^TPG2event;
begin
  if assigned(UserPopUp) then
  begin
    for i:=0 to UserPopUp.count-1 do
    begin
      p:=pointer(UserPopUp.Objects[i]);
      dispose(p);
    end;

    UserPopUp.free;
    UserPopUp:=nil;
  end;
end;


procedure typeUO.setFstatus(status: TUOstatus);
begin
  Fstatus0:=status;
end;

{******************************************************************************}


function fonctionTobject_sysname(var pu:typeUO):AnsiString;
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
  try
  assignFile(f,debugPath+'stmClass.txt');
  rewrite(f);

  for g:=low(TgenreUO) to high(TgenreUO) do
    for i:=0 to UOnameList[g].count-1 do
      writeln(f,UOnameList[g].strings[i]);
  close(f);
  except
  {$I-}closeFile(f);{$I+}
  end;
end;



function nouvelObjet(numType:integer):typeUO;
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
  result:=nil;

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
  if p.initialise(st) then
  begin
    MainObjList.add(p,status);
    p.show(nil);
    result:=p;
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

function CreerObjet(tp:TUOclass; const BaseName:AnsiString=''):typeUO;
var
  st:shortstring;
  p2:typeUO;
  status:TUOstatus;
  i:integer;
begin
  result:=nil;

  if BaseName='' then  st:=nomControle(tp,'')
  else
  begin
    i:=0;
    repeat
      inc(i);
      st:= BaseName+Istr(i);
    until MainObjList.accept(st);
  end;

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
//  verifierObjet(dest);
  specialDrag:=dest;
end;


procedure resetDragUO;
begin
  DragUOsource:=nil;
  DraggedUO:=nil;
end;


function typeUO.loadAsChild(f: Tstream;Fdata:boolean): boolean;
var
  size: longword;
  posini: int64;
  st1:AnsiString;
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

function UOident(uo:typeUO):AnsiString;
begin
  if assigned(uo)
    then result:=uo.ident
    else result:='';
end;


procedure initStmObj;
begin
  if not assigned(sysList) then
  begin
    SysList:=TsystemList.create(false);
    HKpaint:=TsystemList.create(true);
    MaskList:= Tlist.Create;

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

  if TobjectFile(obF).save(pu)<0 then sortieErreur(E_save);
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

procedure proTObject_loadObject(stF:AnsiString;var pu:typeUO);
var
  obF:TobjectFile;
  ok:boolean;
begin
  verifierObjet(pu);

  obF:=TobjectFile.create;
  try
    ok:= (obF.OpenFile(stF)<>0);
    if not( ok  and TobjectFile(obF).load(pu) )
      then sortieErreur('TObject.LoadObject : unable to load from file '+stF);
  finally
  obF.Free;
  end;
end;

procedure proTObject_SaveAsObject(stF:AnsiString;var pu:typeUO);
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





function fonctionTobject_stCom(var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=pu.stComment;
end;

procedure proTobject_stCom(w:AnsiString;var pu:typeUO);pascal;
begin
  verifierObjet(pu);
  pu.stComment:=w;
end;

procedure copyGvariant(var src:TGvariant;var dest:TGvariant);
begin
  dest.init;
  case src.VType of
    gvBoolean:  dest.Vboolean:=src.Vboolean;
    gvInteger:  dest.Vinteger:=src.Vinteger;
    gvFloat:    dest.Vfloat:=src.Vfloat;
    gvComplex:  dest.Vcomplex:=src.Vcomplex;
    gvString:   dest.Vstring:=src.Vstring;
    gvDateTime: dest.VdateTime:=src.VdateTime;
    gvObject:   dest.Vobject:=src.Vobject;
    else        dest.finalize;
  end;

  dest.Fchecked:=src.Fchecked;
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
  if Vtype=gvObject then rec.Vref.MyVariant:=@self;
end;

procedure TGvariant.finalize;
begin
  rec.Vstring:='';
  if Vtype=gvObject then freeAndNil(rec.Vref);
  fillchar(rec,sizeof(rec),0);
end;

function TGvariant.getObject: typeUO;
begin
  if (Vtype=gvObject) and assigned(rec.Vref)
    then result:=rec.Vref.refUO
    else result:=nil;
end;

function TGvariant.getValString(const Ndeci:integer=6): Ansistring;
begin
  result:='';
  case rec.VType of
    gvBoolean:    result:=Bstr(rec.VBoolean);
    gvInteger:    result:=Int64str(rec.VInteger); { 64 bits }
    gvFloat :     result:=Estr(rec.VFloat,Ndeci) ;
    gvComplex:    result:=Estr(rec.Vcomplex.x,Ndeci)+'+i'+Estr(rec.Vcomplex.y,Ndeci);
    gvString:     result:=rec.Vstring;
    gvDateTime:   result:=FormatDateTime('yyyy-mm-dd hh:mm:ss:zzz',rec.VDateTime);
    gvObject:     if assigned(rec.Vref) and assigned(rec.Vref.refUO)
                    then result:=rec.Vref.refUO.ident;
  end;
end;

procedure TGvariant.init;
begin
  fillchar(rec,sizeof(rec),0);
  Vtype:=gvNull;
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

procedure TGvariant.setComplex(z: TfloatComp);
begin
  finalize;

  rec.Vtype:=gvComplex;
  rec.Vcomplex:=z;
end;

procedure TGvariant.setInteger(w: int64);
begin
  finalize;

  rec.Vtype:=gvInteger;
  rec.Vinteger:=w;
end;

procedure TGvariant.setObject(w: TypeUO);
begin
  if rec.Vtype=gvObject then rec.Vref.derefObjet(rec.Vref.refUO)
  else
  begin
    finalize;
    rec.Vtype:=gvObject;
    rec.Vref:=TrefUO.create;
  end;
    
  rec.Vref.MyVariant:=@self;
  rec.Vref.refUO:=w;
  rec.Vref.refObjet(w);
end;

procedure TGvariant.setString(w: Ansistring);
begin
  finalize;

  rec.Vtype:=gvString;
  rec.Vstring:=w;
end;

procedure TGvariant.showStringInfo;
begin
  util1.showStringInfo(rec.Vstring);
end;

{ Taille de stockage sur disque.

  Elphy32 sauve les r�els en extended (gvFloat)
  Il peut lire les gvdouble mais les convertit en extended
  Son format de travail est toujours extended


  Elphy64 est capable de charger les extended mais les convertit en double
  Son format de travail est toujours double
  Il sauve les r�els en tant que double (gvDouble)
 }
function TGvariant.UDiskSize: integer;
begin
  case rec.VType of
    gvBoolean:    result:=1;
    gvInteger:    result:=8; { int64 }
    {$IFDEF win64}
    gvFloat :     result:=8;
    gvComplex:    result:=16;
    {$ELSE}
    gvFloat :     result:=10;
    gvComplex:    result:=20;
    {$ENDIF}
    gvString:     result:=4 + length(Vstring);
    gvDateTime:   result:=sizeof(TdateTime);
    gvObject:     result:=0;

    gvDouble :    result:=8;
    gvDComplex:   result:=16;
    else          result:=0;
  end;
end;

function TGvariant.VarAddress: pointer;
begin
  if assigned(Vobject) and assigned(rec.Vref.refUO)
    then result:=rec.Vref.refUO.PgAddress
    else result:=nil;
end;

function fonctionTobject_getIndex(num:integer; var pu:typeUO):integer;
var
  st:string;
  n,k: integer;
  w,code:integer;
Const
  Chiffres=['0'..'9','-'];
begin
  result:=0;
  verifierObjet(pu);
  st:=TypeUO(pu).ident;

  n:=0;
  repeat
    k:=1;
    while (k<length(st)) and (st[k]<>',') and (st[k]<>'[') do inc(k);  //chercher [ ou ,
    if (k<length(st)) then
    begin
      inc(n);                                                          // si trouv�
      delete(st,1,k);                                                  // effacer le d�but
      k:=1;
      while (k<length(st)) and (st[k] in chiffres) do inc(k);          // chercher la fin du nombre
      val(copy(st,1,k-1) ,w,code);                                     // le d�coder
    end;
  until (n=num) or (k>=length(st));

  if (n=num) and (code=0) then result:=w else result:=0;

end;




function typeUO.is3D: boolean;
begin
  result:=false;
end;

procedure typeUO.Display3DX(Idevice: IDirect3DDevice9);
begin
end;

procedure typeUO.FreeDXresources;
begin
end;


function typeUO.HasMgClickEvent: boolean;
begin
  result:=false;
end;

procedure typeUO.AddVar(p: pointer);
begin

end;

procedure typeUO.Freevar(p: pointer);
begin

end;

function typeUO.getD3DZ: integer;
begin
  result:=0;
end;



{ Cr�e une structure Matlab MxArrayPtr � partir des donn�es
  tpDest0 est le type destination (g_none = utiliser le type de l'objet)
}
function typeUO.getMxArray(const tpdest0: typetypeG = g_none): MxArrayPtr;
begin
  sortieErreur('T'+stmClassName+' : Matlab conversion not supported');
  result:=nil;
end;

procedure typeUO.setMxArray(mxArray: MxArrayPtr; const invertIndices: boolean);
begin
  sortieErreur('T'+stmClassName+' : Matlab conversion not supported');
end;

function typeUO.getDoNotCopyAlpha: boolean;
begin
  result:=false;
end;

procedure typeUO.setDoNotCopyAlpha(v: boolean);
begin

end;



function typeUO.SetBlendOp: boolean;
begin

end;

Initialization
AffDebug('Initialization Stmobj',0);

initStmObj;

installError(E_save,'TObject: Write error');
installError(E_load,'TObject: Read error');

MainObjFileList:=Tlist.create;


finalization
FlagClock.free;

end.
