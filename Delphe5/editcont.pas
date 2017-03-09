unit editcont;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  windows, messages, Classes, Controls, Forms, StdCtrls, CheckLst,menus,
  util1,debug0;


(*  20-09-05 : on fusionne TnumType et typetypeG : on perd longword et comp

  TNumType=(T_byte,T_shortInt,T_smallInt,T_word,T_Longint,T_longWord,
            T_single,T_real,T_double,T_extended,T_comp);


   2010: TradioButtonV est supprimé
         tout comme TsimplePanel
         Ils n'ont jamais été utilisés.

*)

{ avec Delphi 2, les try except empêchent le fonctionnement des composants
  en particulier pour TcheckBox et TradioButton
}



Const
   T_byte =     G_byte;
   T_shortInt = G_short;
   T_smallInt = G_smallInt;
   T_word =     G_word;
   T_Longint =  G_Longint;
   T_single =   G_single;
   T_real =     G_real;
   T_double =   G_double;
   T_extended = G_extended;

type
  TnumType=typetypeG;


type
  PlongString=^AnsiString;

  TsetSt=procedure (x:AnsiString;data1:pointer) of object;
  TgetSt=function(data1:pointer):AnsiString of object;


  TeditString = class(TEdit)
    private
      short:boolean;
      Flen:integer;              {longueur de la chaîne }
      FUpdateVarOnExit:boolean;  {La variable doit-elle être mise à jour dès
                                  que l'on sort du champ du contrôle? }

      FlagUpdateCtrl:boolean;

      Fprop:boolean;
      getSt:TgetSt;
      setSt:TsetSt;
      data:pointer;

    protected
      procedure DoExit; override;

    public
      adVar:pointer;             {adresse de la chaine}
      UpdateCtrlAfterVar:boolean;

      constructor Create(AOwner: TComponent); override;


      procedure setString(var x:AnsiString;long:integer);  {pour type AnsiString}
      procedure setVar(var x;long:integer);            {pour type ShortString}
      procedure setProp(setE1:TsetSt; getE1:TgetSt;data1:pointer=nil);

      procedure UpdateCtrl;
      procedure UpdateVar;

    published
      property len:integer read Flen write Flen;
      property UpdateVarOnExit:boolean read FUpdateVarOnExit
                                       write FUpdateVarOnExit;
    end;


  TmemoV = class(Tmemo)
    private
      FUpdateVarOnExit:boolean;  {La variable doit-elle être mise à jour dès
                                  que l'on sort du champ du contrôle? }

      FlagUpdateCtrl:boolean;

      Fprop:boolean;
      getSt:TgetSt;
      setSt:TsetSt;
      data:pointer;

    protected
      procedure DoExit; override;

    public
      adVar:pointer;             {adresse de la chaine}
      UpdateCtrlAfterVar:boolean;

      constructor Create(AOwner: TComponent); override;


      procedure setString(var x:AnsiString);  {pour type AnsiString}
      procedure setProp(setE1:TsetSt; getE1:TgetSt;data1:pointer=nil);

      procedure UpdateCtrl;
      procedure UpdateVar;

    published
      property UpdateVarOnExit:boolean read FUpdateVarOnExit
                                       write FUpdateVarOnExit;
    end;


  TsetDT=procedure (x:TdateTime;data1:pointer) of object;
  TgetDT=function(data1:pointer):TdateTime of object;


  TeditDateTime = class(TEdit)
    private
      FUpdateVarOnExit:boolean;  {La variable doit-elle être mise à jour dès
                                  que l'on sort du champ du contrôle? }
      FlagUpdateCtrl:boolean;

      Fprop:boolean;
      getDT:TgetDT;
      setDT:TsetDT;
      data:pointer;

    protected
      procedure DoExit; override;
      procedure KeyDown(var Key: Word; Shift: TShiftState);override;

    public
      adVar:^TdateTime;           {adresse de la variable}

      constructor Create(AOwner: TComponent); override;

      procedure setVar(var x: TdateTime;long:integer);
      procedure setProp(setDT1:TsetDT; getDT1:TgetDT;data1:pointer=nil);


      procedure UpdateCtrl;
      procedure UpdateVar;
      procedure UpdateLocal;
    published
      property UpdateVarOnExit:boolean read FUpdateVarOnExit
                                       write FUpdateVarOnExit;
    end;



type
  TsetE=procedure (x:float;data1:pointer) of object;
  TgetE=function(data1:pointer):float of object;


  TeditNum = class(TEdit)
    private
      FTnum:TNumType;            {type de variable}
      Fmin,Fmax:float;           {limites de saisie}
      FUpdateVarOnExit:boolean;  {La variable doit-elle être mise à jour dès
                                  que l'on sort du champ du contrôle? }

      x0:float;                  {garde la valeur antérieure de la variable}
      FlagUpdateCtrl:boolean;

      Fdecimal:integer;          { nombre de décimales}
      setKey:set of char;        { touches clavier autorisées}

      FDxu,Fx0u:float;           { loi de conversion X=Dxu*var+x0u
                                   On saisit x et on range var }

      Fprop:boolean;             { on accède à la variable réelle via deux fonctions d'accès }
      setE:TsetE;
      getE:TgetE;
      data:pointer;

      Haschanged: boolean;
      procedure controleLimites;
      procedure controleTexte;
      procedure setDecimal(n:integer);

      function getFloatValue:float;
      procedure setFloatValue(x:float);

      procedure Reinit;
    protected

      procedure Change; override;
      procedure DoExit; override;

      function conv(x:float):float;
      function invconv(x:float):float;
      procedure setDxu(x:float);
      procedure setx0u(x:float);

    public
      adVar:pointer;             {adresse de la variable}
      constructor Create(AOwner: TComponent); override;

      procedure setVar(var x;tp:TnumType);
      procedure setProp(setE1:TsetE; getE1:TgetE;data1:pointer;tp:TnumType);
      procedure setMinMax(mini,maxi:float);

      procedure UpdateCtrl;
      procedure UpdateVar;

      procedure setCtrlValue(x:float);

      property FloatValue:float read getFloatValue write setFloatValue;

    published
      property Tnum:TnumType read Ftnum write Ftnum;
      property Min:float read Fmin write Fmin;
      property Max:float read Fmax write Fmax;
      property UpdateVarOnExit:boolean read FUpdateVarOnExit
                                       write FUpdateVarOnExit;
      property Decimal:integer read Fdecimal write setdecimal;
      property Dxu:float read Fdxu write setDxu;
      property x0u:float read Fx0u write setx0u;

    end;



  TsetB=procedure(x:boolean;data1:pointer) of object;
  TgetB=function(data1:pointer) :boolean of object;


  TCheckBoxV = class(TCheckBox)
    private

      FUpdateVarOnToggle:boolean;{La variable doit-elle être mise à jour
                                  immédiatement? }

      FlagUpdateCtrl:boolean;

      Fprop:boolean;
      setB:TsetB;
      getB:TgetB;
      data:pointer;

      {$IFDEF FPC} AlDum: TleftRight; {$ENDIF}


    protected
      procedure toggle; override;

    public
      adVar:pointer;             {adresse de la variable booléenne}
      constructor Create(AOwner: TComponent); override;

      procedure setVar(var x);
      procedure setProp(setB1:TsetB;getB1:TgetB;data1:pointer);

      procedure UpdateCtrl;
      procedure UpdateVar;

    published
      property UpdateVarOnToggle:boolean read FUpdateVarOnToggle
                                         write FUpdateVarOnToggle;

      {$IFDEF FPC}
      property Alignment: TLeftRight read AlDum write AlDum;
      {$ENDIF}
    end;


  TsetI=procedure (x:integer;data1:pointer) of object;
  TgetI=function(data1:pointer):integer of object;

  TcomboBoxV = class(TcomboBox)
    private

      n1:integer;                { numéro de la première option}
      FTnum:TNumType;            { type de variable}
      FUpdateVarOnExit:boolean;  { La variable doit-elle être mise à jour dès
                                   que l'on sort du champ du contrôle? }
      FUpdateVarOnChange:boolean;{ La variable doit-elle être mise à jour à chaque changement }
                                 { Rem: la mise à jour se fait après le gestionnaire OnChange }

      FlagUpdateCtrl:boolean;

      FnumVar:boolean;

      Values:array of integer;
      StValues: array of AnsiString;

      getI:TgetI;
      setI:TsetI;

      getSt:TgetSt;
      setSt:TsetSt;

      data:pointer;

    protected
      procedure DoExit; override;
      procedure change;override;

    public
      adVar:pointer;             {adresse de la variable}
      constructor Create(AOwner: TComponent); override;

      procedure setVar(var x;tp:TnumType;num1:integer);
      procedure setNumVar(var x;tp:TnumType);

      procedure setProp(setI1:TsetI;getI1:TgetI;data1:pointer);
      procedure setPropString(setst1:TsetSt;getSt1:TgetSt;data1:pointer);


      procedure UpdateCtrl;
      procedure UpdateVar;

      { Les chaînes de la liste peuvent être fixées directement dans Delphi ou
        bien avec l'une des 3 procédures suivantes }
      { Il faut toujours remplir la liste AVANT d'appeler setvar ou setNumVar
        En fait, ça marche quand même depuis le 10 mai 2005 .
      }

      procedure setString(st:AnsiString);                    { ex: 'UN|DEUX|TROIS'}
      procedure setStringArray(var tb;long,nb:integer);  { tableau de chaînes courtes }
      procedure SetNumList(n1,n2,step:integer);          { suite de nombres }

      procedure SetValues(vv:array of integer);
      procedure SetStValues(sst: array of AnsiString);
    published
      property Tnum:TnumType read Ftnum write Ftnum;
      property UpdateVarOnExit:boolean read FUpdateVarOnExit
                                       write FUpdateVarOnExit;
      property UpdateVarOnChange:boolean read FUpdateVarOnChange
                                         write FUpdateVarOnChange;

    end;


  TlistBoxV = class(TlistBox)
    private
      FUpdateVarOnExit:boolean;  {La variable doit-elle être mise à jour dès
                                  que l'on sort du champ du contrôle? }
      FlagUpdateCtrl:boolean;

    protected
      procedure DoExit; override;

    public
      adVar:PtabBoolean;             {adresse de la variable}
      advar1:Plongint;
      num1:integer;
      constructor Create(AOwner: TComponent); override;

      procedure setVar(var x);
      procedure setVar1(var x;n1:integer);

      procedure UpdateCtrl;
      procedure UpdateVar;

      { Les chaînes de la liste peuvent être fixées directement dans Delphi ou
        bien avec l'une des 3 procédures suivantes }
      { Il faut toujours remplir la liste AVANT d'appeler setvar }

      procedure setString(st:AnsiString);                { ex: 'UN|DEUX|TROIS'}
      procedure setStringArray(var tb;long,nb:integer);  { tableau de chaînes }
      procedure SetNumList(n1,n2,step:integer);          { suite de nombres }

    published
      property UpdateVarOnExit:boolean read FUpdateVarOnExit
                                       write FUpdateVarOnExit;
    end;


  TcheckListBoxV = class(TcheckListBox)
    private
      FUpdateVarOnExit:boolean;  {La variable doit-elle être mise à jour dès
                                  que l'on sort du champ du contrôle? }
      FlagUpdateCtrl:boolean;

      popup: TpopupMenu;

      procedure CheckSelection(sender:Tobject);
      procedure UnCheckSelection(sender:Tobject);

    protected
      procedure DoExit; override;

    public
      adVar:PtabBoolean;             {adresse de la variable}
      advar1:Plongint;
      num1:integer;
      constructor Create(AOwner: TComponent); override;

      procedure setVar(var x);
      procedure setVar1(var x;n1:integer);

      procedure UpdateCtrl;
      procedure UpdateVar;

      { Les chaînes de la liste peuvent être fixées directement dans Delphi ou
        bien avec l'une des 3 procédures suivantes }
      { Il faut toujours remplir la liste AVANT d'appeler setvar }

      procedure setString(st:AnsiString);                { ex: 'UN|DEUX|TROIS'}
      procedure setStringArray(var tb;long,nb:integer);  { tableau de chaînes }
      procedure SetNumList(n1,n2,step:integer);          { suite de nombres }

    published
      property UpdateVarOnExit:boolean read FUpdateVarOnExit
                                       write FUpdateVarOnExit;
    end;



    TScrollVEvent = procedure(Sender: TObject;x:float;ScrollCode: TScrollCode) of object;

{ TscrollbarV permet de controler une variable réelle.
  Il suffit
    d'initialiser avec setParams(x,xmin,xmax) (valeurs réelles)
    de fixer dxSmall et dxLarge
    d'écrire le gestionnaire d'événement OnScrollV. OnScrollV reçoit la
    nouvelle valeur de x comme paramètre.

}
    TscrollbarV=class(Tscrollbar)
    private
      x:float;
      Fxmin,Fxmax,Fdxsmall,FdxLarge:float;

      FOnScrollV: TScrollVEvent;

      procedure setDxSmall(x:float);
      procedure setDxLarge(x:float);

    protected
      procedure Scroll(ScrollCode: TScrollCode; var ScrollPos: Integer);override;
    public
      constructor Create(AOwner: TComponent); override;
      procedure setParams(x0:float;x1,x2:float);

    published
      property Xmin:float read Fxmin write Fxmin;
      property Xmax:float read Fxmax write Fxmax;
      property dxSmall:float read FdxSmall write setdxSmall;
      property dxLarge:float read FdxLarge write setdxLarge;

      property OnScrollV: TScrollVEvent read FOnScrollV write FOnScrollV;
    end;

  TeditTime= class(TEdit)
    private
      Last:AnsiString;
      function controleTexte(st:AnsiString): boolean;

      procedure Reinit;
    protected

      procedure Change; override;
      procedure DoExit; override;

    public
      constructor Create(AOwner: TComponent); override;
      procedure setValue(st:AnsiString);
    end;



procedure UpdateAllVar(form:Tform);
procedure UpdateAllCtrl(form:Tform);

procedure ResetVar(form:Tform);



procedure Register;


function VarToFloat(var x;tp:tnumType):float;
procedure FloatToVar(w:float;var x;tp:tnumType);

implementation

function NumSize(n:TnumType):integer;
begin
  case n of
    T_byte,T_shortInt:             result:=1;
    T_smallInt,T_word:             result:=2;
    T_Longint,T_single:            result:=4;
    T_double:                      result:=8;
    T_extended:                    result:=10;
  end;
end;

function VarToFloat(var x;tp:tnumType):float;
begin
 case tp of
    T_byte:     result:=byte(x);
    T_shortInt: result:=shortInt(x);
    T_smallInt: result:=smallInt(x);
    T_word:     result:=word(x);
    T_Longint:  result:=longint(x);

    T_single:   result:=single(x);

    T_double:   result:=double(x);
    T_extended: result:=extended(x);
    else result:=-1;
  end;
end;

procedure FloatToVar(w:float;var x;tp:tnumType);
begin
 case tp of
    T_byte:     byte(x):=round(w);
    T_shortInt: shortInt(x):=round(w);
    T_smallInt: smallInt(x):=round(w);
    T_word:     word(x):=round(w);
    T_Longint:  longint(x):=round(w);

    T_single:   single(x):=w;

    T_double:   double(x):=w;
    T_extended: extended(x):=w;
  end;
end;


procedure rangerVar(Tnum:TnumType;advar:pointer;x0:float);
begin
  case Tnum of
    T_byte:     Pbyte(advar)^:=round(x0);
    T_shortInt: Pshort(advar)^:=round(x0);
    T_smallInt: PsmallInt(advar)^:=round(x0);
    T_word:     Pword(advar)^:=round(x0);
    T_longint:  Plongint(advar)^:=round(x0);

    T_single:   Psingle(advar)^:=x0;

    T_double:   Pdouble(advar)^:=x0;
    T_extended: Pextended(advar)^:=x0;
  end;
end;

function getVar(Tnum:TnumType;advar:pointer):float;
begin
  case Tnum of
    T_byte:     result:=Pbyte(advar)^;
    T_shortInt: result:=Pshort(advar)^;
    T_smallInt: result:=PsmallInt(advar)^;
    T_word:     result:=Pword(advar)^;
    T_longint:  result:=Plongint(advar)^;

    T_single:   result:=Psingle(advar)^;

    T_double:   result:=Pdouble(advar)^;
    T_extended: result:=Pextended(advar)^;
  end;
end;


{********************* Méthodes de TeditString ***********************}



procedure TeditString.setString(var x:AnsiString;long:integer);
  begin
    short:=false;
    advar:=@x;
    len:=long;

    UpdateCtrl;
  end;


procedure TeditString.setvar(var x;long:integer);
  begin
    short:=true;
    advar:=@x;
    len:=long;

    UpdateCtrl;
  end;

procedure TeditString.setProp(setE1: TsetSt; getE1: TgetSt;data1:pointer=nil);
begin
  Fprop:=true;
  setSt:=setE1;
  getSt:=getE1;
  data:=data1;

  updateCtrl;
end;


procedure TeditString.UpdateCtrl;
  var
    st:AnsiString;
  begin
    if assigned(advar) then
    begin
      if short then st:=Pshortstring(advar)^
               else st:=Plongstring(advar)^;
    end
    else
    if assigned(getSt) then st:=getSt(data)
    else st:='';

    FlagUpdateCtrl:=true;
    text:=st;
    FlagUpdateCtrl:=false;
  end;

constructor TeditString.Create(AOwner: TComponent);
  begin
    inherited create(AOwner);
  end;



procedure TeditString.DoExit;
  begin
    inHerited DoExit;
    if FUpdateVarOnExit then UpdateVar;
  end;

procedure TeditString.UpdateVar;
  begin
    if not enabled then exit;

    if assigned(advar) then
    begin
      if short then Pshortstring(advar)^:=copy(text,1,len)
               else PlongString(advar)^:=copy(text,1,len);
    end
    else
    if assigned(setSt) then
    begin
      setSt(text,data);
      if UpdateCtrlAfterVar then UpdateCtrl;
    end;
  end;

{********************* Méthodes de TmemoV ***********************}



procedure TmemoV.setString(var x:AnsiString);
  begin
    advar:=@x;
    UpdateCtrl;
  end;


procedure TmemoV.setProp(setE1: TsetSt; getE1: TgetSt;data1:pointer=nil);
begin
  Fprop:=true;
  setSt:=setE1;
  getSt:=getE1;
  data:=data1;

  updateCtrl;
end;


procedure TmemoV.UpdateCtrl;
  var
    st:AnsiString;
  begin
    if assigned(advar) then st:=Plongstring(advar)^
    else
    if assigned(getSt) then st:=getSt(data)
    else st:='';

    FlagUpdateCtrl:=true;
    text:=st;
    FlagUpdateCtrl:=false;
  end;

constructor TmemoV.Create(AOwner: TComponent);
  begin
    inherited create(AOwner);
  end;

procedure TmemoV.DoExit;
  begin
    inHerited DoExit;
    if FUpdateVarOnExit then UpdateVar;
  end;

procedure TmemoV.UpdateVar;
  begin
    if not enabled then exit;

    if assigned(advar) then PlongString(advar)^:=text
    else
    if assigned(setSt) then
    begin
      setSt(text,data);
      if UpdateCtrlAfterVar then UpdateCtrl;
    end;
  end;



{********************* Méthodes de TeditDateTime ***********************}

constructor TeditDateTime.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
end;

procedure TeditDateTime.setvar(var x: TdateTime;long:integer);
begin
  advar:=@x;
  UpdateCtrl;
end;

procedure TeditDateTime.setProp(setDT1: TsetDT; getDT1: TgetDT;data1:pointer=nil);
begin
  Fprop:=true;
  setDT:=setDT1;
  getDT:=getDT1;
  data:=data1;

  updateCtrl;
end;



procedure TeditDateTime.UpdateCtrl;
var
  st:AnsiString;
begin
  if assigned(advar) then
    st:= DateTimeToString(advar^)
  else
  if assigned(getDT) then st:=DateTimeToString(getDT(data))
  else st:='';

  FlagUpdateCtrl:=true;
  text:=st;
  FlagUpdateCtrl:=false;
end;

procedure TeditDateTime.UpdateVar;
begin
  if not enabled then exit;

  if assigned(advar) then advar^:= StringToDateTime(text)
  else
  if assigned(setDT) then setDT(StringToDateTime(text),data);
end;

procedure TeditDateTime.UpdateLocal;
var
  dateTime:TdateTime;
begin
  FlagUpdateCtrl:=true;
  dateTime:= StringToDateTime(text);
  text:=DateTimeToString(dateTime);
  FlagUpdateCtrl:=false;
end;

procedure TeditDateTime.DoExit;
begin
  inHerited DoExit;
  if FUpdateVarOnExit then UpdateVar
  else UpdateLocal;
end;

procedure TeditDateTime.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if key=Vk_return then UpdateLocal;
  inherited;
end;


{********************* Méthodes de TeditNum ***********************}

function TeditNum.conv(x:float):float;
begin
  conv:=Dxu*x+X0u;
end;

function TeditNum.invconv(x:float):float;
var
  x1:float;
begin
  x1:=(x-X0u)/Dxu;
  if (tnum<T_single)
    then invconv:=roundL(x1)
    else invconv:=x1;
end;

procedure TeditNum.setDxu(x:float);
begin
  if x<>0 then
    begin
      Fdxu:=x;
      Reinit;
    end;
end;

procedure TeditNum.setx0u(x:float);
begin
  Fx0u:=x;
  reinit;
end;

procedure TeditNum.ControleLimites;
var
  min1,max1:float;
begin
  case Tnum of
    T_byte:
       begin
         min1:=0;
         max1:=255;
       end;

    T_shortInt:
       begin
         min1:=-128;
         max1:=127;
       end;
    T_smallInt:
       begin
         min1:=-32768;
         max1:=32767;
       end;
    T_word:
       begin
         min1:=0;
         max1:=65535;
       end;
    T_longint:
       begin
         min1:=MinEntierLong;
         max1:=MaxEntierLong;
       end;

    T_single:
       begin
         min1:=-1E38;
         max1:=1E38;
       end;

    T_double:
       begin
         min1:=-1E308;
         max1:=1E308;
       end;
    T_extended:
       begin
         min1:=-1E4932;
         max1:=1E4932;
       end;
  end;

  if (min=0) and (max=0) then
    begin
      min:=min1;
      max:=max1;
    end;
end;

procedure TeditNum.setVar(var x;tp:TnumType);
  begin
    Fprop:=false;

    advar:=@x;
    tnum:=tp;
    min:=0;
    max:=0;

    if (tp<T_single) and (dxu=1) and (x0u=0) then
      begin
        if tp in [g_byte, g_word]
          then setkey:=['0'..'9']
          else setkey:=['+','-','0'..'9'];
        decimal:=0;
      end
    else
      begin
        setkey:=['+','-','.','e','E','0'..'9'];
        decimal:=3;
      end;

    controleLimites;
    UpdateCtrl;
  end;

procedure TeditNum.setProp(setE1:TsetE; getE1:TgetE;data1:pointer;tp:TnumType);
begin
  Fprop:=true;
  setE:=setE1;
  getE:=getE1;
  data:=data1;

  tnum:=tp;
  min:=0;
  max:=0;

  if (tp<T_single) and (dxu=1) and (x0u=0) then
    begin
      setkey:=['+','-','0'..'9'];
      decimal:=0;
    end
  else
    begin
      setkey:=['+','-','.','e','E','0'..'9'];
      decimal:=3;
    end;

  controleLimites;
  UpdateCtrl;

end;

procedure TeditNum.Reinit;
begin
  if Fprop
    then setProp(setE,getE,data,tnum)
    else setvar(advar^,tnum);
end;

procedure TeditNum.setDecimal(n:integer);
begin
  if n>=0 then
    begin
      Fdecimal:=n;
      UpdateCtrl;
    end;
end;

procedure TeditNum.UpdateCtrl;
  var
    st:String[40];
  begin
    if not assigned(advar) and not assigned(getE) then exit;

    if not Fprop and assigned(advar) then
    case Tnum of
      T_byte:       x0:=Pbyte(advar)^;
      T_shortInt:   x0:=Pshort(advar)^;
      T_smallInt:   x0:=PsmallInt(advar)^;
      T_word:       x0:=Pword(advar)^;
      T_longint:    x0:=Plongint(advar)^;
      T_single:     x0:=Psingle(advar)^;

      T_double:     x0:=Pdouble(advar)^;
      T_extended:   x0:=Pextended(advar)^;
    end
    else
    if Fprop and assigned(getE) then x0:=getE(data)
    else x0:=0;

    setCtrlValue(x0);
  end;

procedure TeditNum.setCtrlValue(x:float);
  var
    st:string[40];
  begin
    str(conv(x):40:decimal,st);
    while pos(' ',st)>0 do delete(st,pos(' ',st),1);

    FlagUpdateCtrl:=true;
    text:=st;
    FlagUpdateCtrl:=false;
  end;


constructor TeditNum.Create(AOwner: TComponent);
  begin
    inherited create(AOwner);
    FDxu:=1;
  end;

procedure TeditNum.Change;
  var
    i,pc:integer;
    st:string[40];
  begin
    inherited change;

    if FlagUpdateCtrl or not HandleAllocated then exit;

    pc:=SelStart;
    st:=text;
    for i:=length(st) downto 1 do
      if not (st[i] in setKey) then
        begin
          delete(st,i,1);
          if i<=pc then dec(pc);
        end;

    text:=st;
    SelStart:=pc;
    HasChanged:=true;
  end;


procedure TeditNum.controleTexte;
  var
    x:float;
    st:string[40];
    code:integer;
  begin
    st:=text;
    st:=Fsupespace(st);
    val(st,x,code);
    x:=invconv(x);

    if code=0 then x0:=x;

    if x0<min then x0:=min
    else
    if x0>max then x0:=max;

    str(conv(x0):40:decimal,st);
    {supespace(st);}
    while pos(' ',st)>0 do delete(st,pos(' ',st),1);

    text:=st;
  end;

procedure TeditNum.DoExit;
  begin
    inHerited DoExit;
    if FUpdateVarOnExit then UpdateVar else controleTexte;
  end;

procedure TeditNum.setMinMax(mini,maxi:float);
  begin
    min:=mini;
    max:=maxi;
    controleLimites;
  end;

procedure TeditNum.UpdateVar;
  begin
    if not assigned(advar) and not assigned(getE) or not enabled then exit;
    if not HasChanged then exit;
    
    controleTexte;

    if not Fprop then
    case Tnum of
      T_byte:     Pbyte(advar)^:=round(x0);
      T_shortInt: Pshort(advar)^:=round(x0);
      T_smallInt: PsmallInt(advar)^:=round(x0);
      T_word:     Pword(advar)^:=round(x0);
      T_longint:  Plongint(advar)^:=round(x0);

      T_single:   Psingle(advar)^:=x0;

      T_double:   Pdouble(advar)^:=x0;
      T_extended: Pextended(advar)^:=x0;
    end
    else setE(x0,data);
  end;

function TeditNum.getFloatValue:float;
begin
  if not Fprop and assigned(advar) then result:=VarToFloat(advar^,Tnum)
  else
  if Fprop and assigned(getE) then result:=getE(data)
  else result:=0;
end;

procedure TeditNum.setFloatValue(x:float);
begin
  if x<min then x:=min
  else
  if x>max then x:=max;

  if not Fprop and assigned(advar) then rangerVar(Tnum,advar,x)
  else
  if Fprop and assigned(setE) then setE(x,data);

  updateCtrl;
end;



{********************* Méthodes de TcheckBoxV ***********************}

constructor TcheckBoxV.Create(AOwner: TComponent);
begin
  inherited create(AOwner);
end;

procedure TcheckBoxV.setVar(var x);
begin
  Fprop:=false;
  advar:=@x;

  UpdateCtrl;
end;

procedure TcheckBoxV.setProp(setB1:TsetB;getB1:TgetB;data1:pointer);
begin
  Fprop:=true;
  setB:=setB1;
  getB:=getB1;
  data:=data1;
end;

procedure TcheckBoxV.toggle;
begin
  inherited toggle;
  if FlagUpdateCtrl or not HandleAllocated then exit;

  if FUpdateVarOnToggle then updateVar;
end;

procedure TcheckBoxV.UpdateVar;
begin
  if not enabled  then exit;
  if FlagUpdateCtrl then exit;

  if assigned(advar) then Pboolean(advar)^:=checked
  else
  if assigned(setB) then setB(checked,data);
end;

procedure TcheckBoxV.UpdateCtrl;
begin
  FlagUpdateCtrl:=true;

  if assigned(advar) then checked:=Pboolean(advar)^
  else
  if assigned(getB) then  checked:=getB(data);

  FlagUpdateCtrl:=false;
end;



{********************* Méthodes de TcomboBoxV ***********************}


procedure TcomboBoxV.setVar(var x;tp:TnumType;num1:integer);
  begin
    advar:=@x;
    n1:=num1;
    tnum:=tp;
    UpdateCtrl;
  end;

procedure TcomboBoxV.setNumVar(var x;tp:TnumType);
  begin
    advar:=@x;
    tnum:=tp;

    FNumVar:=true;
    UpdateCtrl;
  end;

procedure TcomboBoxV.UpdateCtrl;
  var
    x0:longint;
    i:integer;
    x,x1:float;
    code:integer;
    st:AnsiString;
  begin
    if not assigned(advar) and not assigned(getI) and not assigned(getSt) then exit;
    if items.count<=0 then exit;

    if assigned(advar) and Fnumvar then
      begin
        itemIndex:=0;
        x1:=getvar(Tnum,advar);
        {affdebug('TcomboBoxV.UpdateCtrl '+Estr(x1,3));}
        for i:=0 to items.count-1 do
          begin
            val(items[i],x,code);
            {affdebug('TcomboBoxV.UpdateCtrl ==>'+Estr(x,3));}
            if x=x1 then
              begin
                FlagUpdateCtrl:=true;
                itemIndex:=i;
                refresh;
                FlagUpdateCtrl:=false;
                {affdebug('TcomboBoxV.UpdateCtrl ==>'+Istr(itemIndex)+' '+text);}
                exit;
              end;
          end;
        exit;
      end;

    if assigned(advar) then
    case Tnum of
      T_byte:       x0:=Pbyte(advar)^;
      T_shortInt:   x0:=Pshort(advar)^;
      T_smallInt:   x0:=PsmallInt(advar)^;
      T_word:       x0:=Pword(advar)^;
      T_longint:    x0:=Plongint(advar)^;
    end
    else
    if assigned(getI) then x0:=getI(data)
    else
    if assigned(getSt) then
    begin
      st:=getSt(data);

      if (length(stvalues)=items.count) and (items.count>0) then
      begin
        x0:=-1;
        for i:=0 to high(stValues) do
          if st=stValues[i] then x0:=i;
      end
      else x0:=items.IndexOf(st);
    end;

    FlagUpdateCtrl:=true;

    if length(values)=items.Count then
    begin
      for i:=0 to length(values)-1 do
        if values[i]=x0 then
        begin
          itemindex:=i;
          break;
        end
    end
    else itemIndex:=x0-n1;

    FlagUpdateCtrl:=false;
  end;

constructor TcomboBoxV.Create(AOwner: TComponent);
  begin
    inherited create(AOwner);
  end;

procedure TcomboBoxV.DoExit;
  begin
    inHerited DoExit;
    if FUpdateVarOnExit then UpdateVar;
  end;

procedure TcomboBoxV.Change;
  begin
    inHerited Change;
    if FUpdateVarOnChange then UpdateVar;
  end;


procedure TcomboBoxV.UpdateVar;
  var
    x0:longint;
    x:float;
    code:integer;
  begin
    if not assigned(advar) and not assigned(setI) and not assigned(setSt) or not enabled then exit;
    if FlagUpdateCtrl then exit;

    if Fnumvar then
      begin
        val(items[itemindex],x,code);
        if (code=0) and assigned(advar) then rangervar(tnum,advar,x);

        exit;
      end;

    if (length(values)=items.Count) and (items.count>0)
      then x0:=values[itemIndex]
      else x0:=n1+itemIndex;

    if assigned(advar) then
    case Tnum of
      T_byte:     Pbyte(advar)^:=x0;
      T_shortInt: Pshort(advar)^:=x0;
      T_smallInt: PsmallInt(advar)^:=x0;
      T_word:     Pword(advar)^:=x0;
      T_longint:  Plongint(advar)^:=x0;
    end
    else
    if assigned(setI) then setI(x0,data)
    else
    if assigned(setSt) and (itemIndex>=0) then
    begin
      if (length(stvalues)=items.count) and (items.count>0) 
        then setSt(stValues[itemindex],data)
        else setSt(items[itemindex],data);
    end;
  end;


procedure TcomboBoxV.setString(st:AnsiString);
  var
    p:integer;
  begin
    setLength(values,0);

    items.clear;
    while st<>'' do
    begin
      p:=pos('|',st);
      if p=0 then p:=length(st)+1;
      items.add(copy(st,1,p-1));
      delete(st,1,p);
    end;
    itemIndex:=0;

    if advar<>nil then
    begin
      if FnumVar
        then setNumvar(advar^,tnum)
        else setvar(advar^,tnum,n1);
    end;
  end;

procedure TcomboBoxV.setStringArray(var tb;long,nb:integer);
  var
    i:integer;
    txt:typetabChar absolute tb;
  begin
    setLength(values,0);
    items.clear;
    for i:=1 to nb do
        items.add(Pshortstring(@txt[(long+1 )*(i-1)])^);

    if advar<>nil then
      if FnumVar
        then setNumvar(advar^,tnum)
        else setvar(advar^,tnum,n1);
  end;


procedure TcomboBoxV.SetNumList(n1,n2,step:integer);
  var
    i:integer;
  begin
    setLength(values,0);
    items.clear;
    i:=n1;
    while i<=n2 do
    begin
      items.add(Istr(i));
      i:=i+step;
    end;

    if advar<>nil then
      if FnumVar
        then setNumvar(advar^,tnum)
        else setvar(advar^,tnum,n1);
  end;

procedure TcomboBoxV.SetValues(vv: array of integer);
var
  i:integer;
begin
  setLength(values,length(vv));
  for i:=0 to length(vv)-1 do
    values[i]:=vv[i];

  updateCtrl;
end;

procedure TcomboBoxV.SetStValues(sst: array of AnsiString);
var
  i:integer;
begin
  setLength(Stvalues,length(sst));
  for i:=0 to length(sst)-1 do
    StValues[i]:=sst[i];

  updateCtrl;
end;



procedure TcomboBoxV.setProp(setI1: TsetI; getI1: TgetI; data1: pointer);
begin
   setI:=setI1;
   getI:=getI1;
   data:=data1;
   UpdateCtrl;
end;

procedure TcomboBoxV.setPropString(setst1:TsetSt;getSt1:TgetSt;data1:pointer);
begin
   setSt:=setSt1;
   getSt:=getSt1;
   data:=data1;
   UpdateCtrl;
end;


{********************* Méthodes de TlistBoxV ***********************}


procedure TlistBoxV.setVar(var x);
  begin
    advar:=@x;
    advar1:=nil;
    UpdateCtrl;
  end;

procedure TlistBoxV.setVar1(var x;n1:integer);
  begin
    advar1:=@x;
    num1:=n1;
    advar:=nil;
    UpdateCtrl;
  end;

procedure TlistBoxV.UpdateCtrl;
  var
    i:integer;
  begin
    if assigned(advar) then    {tabBooléen}
    begin
      if items.count<=0 then exit;

      FlagUpdateCtrl:=true;
      for i:=0 to items.count-1 do
        selected[i]:=advar^[i];

      FlagUpdateCtrl:=false;
    end
    else
    if assigned(advar1) then   {integer}
    begin
      if items.count<=0 then exit;

      FlagUpdateCtrl:=true;
      for i:=0 to items.count-1 do
        selected[i]:= (num1+i= advar1^);

      FlagUpdateCtrl:=false;
    end;
  end;

constructor TlistBoxV.Create(AOwner: TComponent);
  begin
    inherited create(AOwner);
  end;

procedure TlistBoxV.DoExit;
  begin
    inHerited DoExit;
    if FUpdateVarOnExit then UpdateVar;
  end;

procedure TlistBoxV.UpdateVar;
  var
    i:integer;
  begin
    if not enabled then exit;
    if assigned(advar) then
    begin
      if FlagUpdateCtrl then exit;
      for i:=0 to items.count-1 do
        advar^[i]:=selected[i];
    end
    else
    begin
      if FlagUpdateCtrl then exit;
      for i:=0 to items.count-1 do
        if selected[i] then
          advar1^:=num1+i;
    end;
  end;


procedure TlistBoxV.setString(st:AnsiString);
  var
    p:integer;
  begin
    items.clear;
    while st<>'' do
    begin
      p:=pos('|',st);
      if p=0 then p:=length(st)+1;
      items.add(copy(st,1,p-1));
      delete(st,1,p);
    end;
    itemIndex:=0;
  end;

procedure TlistBoxV.setStringArray(var tb;long,nb:integer);
  var
    i:integer;
    txt:typetabChar absolute tb;
  begin
    items.clear;
    for i:=1 to nb do
        items.add(Pshortstring(@txt[(long+1 )*(i-1)])^);
  end;


procedure TlistBoxV.SetNumList(n1,n2,step:integer);
  var
    i:integer;
  begin
    items.clear;
    i:=n1;
    while i<=n2 do
    begin
      items.add(Istr(i));
      i:=i+step;
    end;
  end;

{********************* Méthodes de TcheckListBoxV ***********************}


procedure TcheckListBoxV.setVar(var x);
  begin
    advar:=@x;
    advar1:=nil;
    UpdateCtrl;
  end;

procedure TcheckListBoxV.setVar1(var x;n1:integer);
  begin
    advar1:=@x;
    num1:=n1;
    advar:=nil;
    UpdateCtrl;
  end;

procedure TcheckListBoxV.UpdateCtrl;
  var
    i:integer;
  begin
    if assigned(advar) then    {tabBooléen}
    begin
      if items.count<=0 then exit;

      FlagUpdateCtrl:=true;
      for i:=0 to items.count-1 do
        checked[i]:=advar^[i];

      FlagUpdateCtrl:=false;
    end
    else
    if assigned(advar1) then   {integer}
    begin
      if items.count<=0 then exit;

      FlagUpdateCtrl:=true;
      for i:=0 to items.count-1 do
        checked[i]:= (num1+i= advar1^);

      FlagUpdateCtrl:=false;
    end;
  end;

constructor TcheckListBoxV.Create(AOwner: TComponent);
var
  mi: TmenuItem;
begin
  inherited create(AOwner);

  popup:=TpopupMenu.Create(self);
  popup.AutoPopup:=true;

  mi:=TmenuItem.create(popup);
  mi.caption:='Check Selection';
  mi.Onclick:= CheckSelection;
  popup.items.add(mi);

  mi:=TmenuItem.create(popup);
  mi.caption:='Uncheck Selection';
  mi.Onclick:= UncheckSelection;
  popup.items.add(mi);

  popupMenu:= popup;

end;

procedure TcheckListBoxV.DoExit;
  begin
    inHerited DoExit;
    if FUpdateVarOnExit then UpdateVar;
  end;

procedure TcheckListBoxV.UpdateVar;
  var
    i:integer;
  begin
    if not enabled then exit;
    if assigned(advar) then
    begin
      if FlagUpdateCtrl then exit;
      for i:=0 to items.count-1 do
        advar^[i]:=checked[i];
    end
    else
    begin
      if FlagUpdateCtrl then exit;
      for i:=0 to items.count-1 do
        if checked[i] then
          advar1^:=num1+i;
    end;
  end;


procedure TcheckListBoxV.setString(st:AnsiString);
  var
    p:integer;
  begin
    items.clear;
    while st<>'' do
    begin
      p:=pos('|',st);
      if p=0 then p:=length(st)+1;
      items.add(copy(st,1,p-1));
      delete(st,1,p);
    end;
    itemIndex:=0;
  end;

procedure TcheckListBoxV.setStringArray(var tb;long,nb:integer);
  var
    i:integer;
    txt:typetabChar absolute tb;
  begin
    items.clear;
    for i:=1 to nb do
        items.add(Pshortstring(@txt[(long+1 )*(i-1)])^);
  end;


procedure TcheckListBoxV.SetNumList(n1,n2,step:integer);
  var
    i:integer;
  begin
    items.clear;
    i:=n1;
    while i<=n2 do
    begin
      items.add(Istr(i));
      i:=i+step;
    end;
  end;

procedure TcheckListBoxV.CheckSelection(sender: Tobject);
var
  i:integer;
begin
  for i:=0 to items.Count-1 do
    if selected[i] then Checked[i]:=true;
  updatevar;
end;

procedure TcheckListBoxV.UnCheckSelection(sender: Tobject);
var
  i:integer;
begin
  for i:=0 to items.Count-1 do
    if selected[i] then Checked[i]:=false;

  updatevar;
end;


{*****************************************************************************}


procedure UpdateAllVar(form:Tform);
  var
    i:integer;
  begin
    with form do
    for i := 0 to ComponentCount -1 do
      if Components[i] is TEditNum then
        TEditNum(Components[i]).UpdateVar
      else
      if Components[i] is TcheckBoxV then
        TcheckBoxV(Components[i]).UpdateVar
      else
      if Components[i] is TcomboBoxV then
        TcomboBoxV(Components[i]).UpdateVar
      else
      if Components[i] is TeditString then
        TeditString(Components[i]).UpdateVar
      else
      if Components[i] is TmemoV then
        TmemoV(Components[i]).UpdateVar
      else
      if Components[i] is TeditDateTime then
        TeditDateTime(Components[i]).UpdateVar
      else

      if Components[i] is TlistBoxV then
        TlistBoxV(Components[i]).UpdateVar
      else
      if Components[i] is TcheckListBoxV then
        TcheckListBoxV(Components[i]).UpdateVar;
  end;

procedure ResetVar(form:Tform);
  var
    i:integer;
  begin
    with form do
    for i := 0 to ComponentCount -1 do
      if Components[i] is TEditNum then
        TEditNum(Components[i]).adVar:=nil
      else
      if Components[i] is TcheckBoxV then
        TcheckBoxV(Components[i]).adVar:=nil
      else
      if Components[i] is TcomboBoxV then
        TcomboBoxV(Components[i]).adVar:=nil
      else
      if Components[i] is TeditString then
        TeditString(Components[i]).adVar:=nil
      else
      if Components[i] is TmemoV then
        TmemoV(Components[i]).adVar:=nil
      else
      if Components[i] is TeditDateTime then
        TeditDateTime(Components[i]).adVar:=nil
      else
      if Components[i] is TlistBoxV then
      begin
        TlistBoxV(Components[i]).adVar:=nil;
        TlistBoxV(Components[i]).adVar1:=nil;
      end
      else
      if Components[i] is TchecklistBoxV then
      begin
        TchecklistBoxV(Components[i]).adVar:=nil;
        TchecklistBoxV(Components[i]).adVar1:=nil;
      end;
  end;


procedure UpdateAllCtrl(form:Tform);
  var
    i:integer;
  begin
    with form do
    for i := 0 to ComponentCount -1 do
      if Components[i] is TEditNum then
        TEditNum(Components[i]).UpDateCtrl
      else
      if Components[i] is TcheckBoxV then
        TcheckBoxV(Components[i]).UpDateCtrl
      else
      if Components[i] is TcomboBoxV then
        TcomboBoxV(Components[i]).UpDateCtrl
      else
      if Components[i] is TeditString then
        TeditString(Components[i]).UpDateCtrl
      else
      if Components[i] is TmemoV then
        TmemoV(Components[i]).UpDateCtrl
      else
      if Components[i] is TeditDateTime then
        TeditDateTime(Components[i]).UpDateCtrl
      else

      if Components[i] is TlistBoxV then
        TlistBoxV(Components[i]).UpDateCtrl
      else
      if Components[i] is TchecklistBoxV then
        TchecklistBoxV(Components[i]).UpDateCtrl;

  end;


procedure Register;
begin
  RegisterComponents('Var',      [TeditString,
                                  TmemoV,
                                  TeditNum,
                                  TcheckBoxV,
                                  TcomboBoxV,
                                  TscrollbarV,
                                  TlistBoxV,
                                  TcheckListBoxV,
                                  TeditDateTime,
                                  TeditTime]
                    );
end;




{********************** TscrollBarV *****************************}

constructor TscrollBarV.Create(AOwner: TComponent);
begin
  inherited;
  xmin:=0;
  xmax:=1000;
  dxSmall:=1;
  dxLarge:=10;
  inherited setParams(0,0,30000);
end;

procedure TscrollBarV.setDxSmall(x:float);
begin
  if x>0 then FDxSmall:=x;
end;

procedure TscrollBarV.setDxLarge(x:float);
begin
  if x>0 then FDxLarge:=x;
end;

procedure TscrollBarV.Scroll(ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  case scrollCode of
    scLineDown:    if x+dxSmall<=xmax then x:=x+dxsmall;
    scLineUp:      if x-dxSmall>=xmin then x:=x-dxSmall;
    scPageDown:    if x+dxLarge<=xmax then x:=x+dxLarge;
    scPageUp:      if x-dxLarge>=xmin then x:=x-dxLarge;

    scPosition,scTrack:
                 begin
                   x:=xmin+(scrollPos)*(xmax-xmin)/30000;
                   x:=roundL((x-xmin)/dxSmall)*dxSmall+xmin;
                 end;

    scTop:       x:=xmax;
    scBottom:    x:=xmin;
  end;

  scrollPos:=roundL(30000/(xmax-xmin)*(x-xmin));

  inherited Scroll(ScrollCode, ScrollPos);


  if assigned(FonScrollV) then FonScrollV(self,x,scrollCode);
end;

procedure TscrollBarV.setParams(x0:float;x1,x2:float);
var
  i:longint;
begin
  x:=x0;


  if x2>x1 then
    begin
      xmin:=x1;
      xmax:=x2;
    end;

  if x0<x1 then x0:=x1
  else
  if x0>x2 then x0:=x2;

  i:=roundL(30000/(xmax-xmin)*(x-xmin));
  inherited setParams(i,0,30000);
  enabled:=(x2>x1);
end;







{ TeditTime }

procedure TeditTime.Change;
var
  pc:integer;
begin
  inherited;
  if not HandleAllocated then exit;

  pc:=selstart;
  if not controleTexte(text)
    then text:=Last
    else Last:=Text;
  selstart:=pc;
end;

function TeditTime.controleTexte(st:AnsiString): boolean;
var
  i: integer;
  nb:integer;
const
  setKey=['0'..'9',':'];
begin
  result:=true;
  nb:=0;
  for i:=1 to length(st) do
  begin
    if not (st[i] in setKey) then result:=false;
    if st[i]=':' then inc(nb);
  end;

  if nb<>2 then result:=false;
end;

constructor TeditTime.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TeditTime.DoExit;
begin
  inherited;

end;

procedure TeditTime.setValue(st:AnsiString);
begin
  if not controleTexte(st) then st:='00:00:00';

  text:=st;
  Last:=st;
end;

procedure TeditTime.Reinit;
begin

end;


end.
