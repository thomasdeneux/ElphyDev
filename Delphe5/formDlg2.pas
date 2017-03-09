unit formDlg2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}

  {$ENDIF}
  Windows, messages,Classes, Graphics, Forms, Controls, Buttons,ExtCtrls,
  StdCtrls,ComCtrls,editCont, Dialogs,Menus,DBctrls,

  util1,listG,
  stmdef,stmObj,debug0,
  stmPg,NcDef2,DacInsp1,ObjFile1,
  DBrecord1,
  dateForm1;

const
  FormDlgLeft:smallInt=100;
  FormDlgTop:smallInt=100;

type
  {$IFDEF FPC}
  TNavButton = TDBNavButton;
  TButtonSet = set of TNavigateBtn;

   {$ENDIF}
  TDBnavigatorG=class(TDBnavigator)
  private
    function getButton(w:TnavigateBtn):TNavButton;
  public
    property Button[w:TNavigateBtn]:TNavButton read getButton;
  end;

type
  genreCtrl=(gtext,gNumvar,gstring,gMemo,gboolean,gEnum,gCommand,gColor,glistBox,gNavigator,gObject,gExtCtrl,gdateTime);

  TDBpanel=class;

  typeCtrl=record
             lbl:Tlabel;
             control:Tcontrol;
             ad:Pointer;
             pgOnChange:Tpg2Event;
             pgOndragDrop:Tpg2Event;
             Number:integer;               {numéro qui identifie le contrôle }
             DBPanel:TDBpanel;

             cb: TcheckBox;
             DisplayedCb:boolean;

           case genre:genreCtrl of
             gnumvar: ( sb:TscrollbarV;stSuffix:String[20];Ndeci:byte);
             gcolor:  ( panel:Tpanel);
             glistBox:( nbItem:integer);
             gObject: ( button:TspeedButton;idObj:TUOclass);
             gExtCtrl:( EmbeddedUO:typeUO; Hembedded,Wembedded: integer);
             gdateTime: (  buttonDate:TspeedButton; mode:integer );
           end;

  Pctrl=^typeCtrl;

  TPanelType=(PTsingle,PTvert,PThor,PTpage,PTtabSheet,PTmulti,PTgroupBox,PTgroupVert,PTgroupHor,PTgroupMulti);
                                             { Panel non divisé <==> length(next)=0
                                               Panel divisé verticalement
                                               Panel divisé horizontalement
                                               TpageControl
                                               TtabSheet
                                               Page contenant des panels simples superposés mais sans onglets
                                             }
  TDBpanel=
          class
            Wnum:integer;                    {numéro du panel pour version 1 }
            name:AnsiString;                 {nom pour version 2 }
            next: array of TDBpanel;
            PanelType:TPanelType;
            Ylabel:integer;
            BackPanel: TwinControl;
            ctrls:array of PCtrl;

            LeftMargin:   integer;            // ajouté à gauche de chaque ligne
            rightMargin:  integer;            // ajouté à la fin de chaque ligne
            TopMargin:    integer;            // ajouté en haut, avant la première ligne
            BottomMargin: integer;            // ajouté après toutes les lignes
            LineSpace:    integer;            // ajouté après chaque ligne

            GroupBoxMargin: integer;

            Hline0: integer;                  // permet d'imposer une hauteur de ligne uniforme
            TabNum:integer;
            constructor create(Aowner:Tcomponent;tp:TpanelType;var num:integer;stName:AnsiString);
            destructor destroy;override;

            procedure setPos(x1,y1,dx1,dy1:integer);

            function divide(var curNum:integer;mode:TpanelType;nb:integer;stOpt:TstringList):boolean;
            function divideGroupBox(var curNum:integer;mode:TpanelType;nb:integer):boolean;

            function AddGroupBox(var curNum:integer; stCap:AnsiString;const margin:integer=3):boolean;

            function getWin(num:integer):TDBpanel;overload;
            function getWin(stName:AnsiString):TDBpanel;overload;


            procedure CalculPos(var dx1,dy1:integer);
            function getInfo:AnsiString;

            function selectTab(value:integer):boolean;
          end;




type

  { TDlgForm2 }

  TDlgForm2 = class(TForm)
    ColorDialog1: TColorDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
    Ctrls:Tlist;
    Fbutton:integer;
    btn:array[1..3] of Tbutton;
    nbBtn:integer;

    Finstalled:boolean;

    DBpanels:TDBpanel;
    curDB:TDBpanel;
    PautoNum:integer;   {permet la numérotation automatique des panels }

    GUpdateCtrl: boolean;

    procedure adjust;
    procedure CommandClick(Sender: TObject);
    procedure CommandMouseDown(Sender: TObject; Button: TMouseButton;
                               Shift: TShiftState; X, Y: Integer);
    procedure CommandEndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure ColorClick(Sender: TObject);

    function getCtrl(i:integer):Pctrl;
    function getWinControl(i:integer):Tcontrol;

    procedure EditNumChange(sender:Tobject);
    procedure CtrlChange(sender:Tobject);
    procedure sbScrollV(Sender: TObject;x:float;ScrollCode: TScrollCode);


    procedure ChooseObjectClick(sender:Tobject);
    procedure ChooseDateClick(sender:Tobject);

    procedure ObjectDragOver(Sender, Source: TObject; X, Y: Integer;State: TDragState; var Accept: Boolean);
    procedure ObjectDragDrop(Sender, Source: TObject; X, Y: Integer);

    procedure setChecked(num:integer;w:boolean);
    function  getChecked(num:integer):boolean;
    procedure setCheckedA(id:integer;w:boolean);
    function  getCheckedA(id:integer):boolean;

    procedure setEnabled(num:integer;w:boolean);
    function  getEnabled(num:integer):boolean;
    procedure setEnabledA(id:integer;w:boolean);
    function  getEnabledA(id:integer):boolean;

    function getCtrlfromId(id:integer): integer;

  public
    { Public declarations }

    UOdlg:typeUO;   // L'objet Tdialog

    nbVar:integer;
    Lcar,Hcar:integer;

    pgOnEvent:Tpg2Event;

    NavigatorClick: procedure (Sender: TObject; Button: TNavigateBtn) of object;

    property ctrl[i:integer]:PCtrl read getCtrl; {indicé à partir de 1 }
    property control[i:integer]:Tcontrol read getWinControl; {indicé à partir de 1 }

    property Checked[n:integer]:boolean read getChecked write setChecked ;
    property CheckedA[id:integer]:boolean read getCheckedA write setCheckedA ;

    property Enabled[n:integer]:boolean read getEnabled write setEnabled ;
    property EnabledA[id:integer]:boolean read getEnabledA write setEnabledA ;

    procedure addCtrl;

    procedure setButtons(bb:integer);

    procedure setText(st:AnsiString; FontName:AnsiString;FontSize,FontColor,FontStyle:integer);

    procedure setNumVar0(st:AnsiString;var x;t:tNumType;n,m:integer; setE1:TsetE=nil; getE1:TgetE=nil;data1:pointer=nil);
    procedure setNumVar(st:AnsiString;var x;t:tNumType;n,m:integer);
    procedure setNumProp(st:AnsiString;t:tNumType;n,m:integer; setE1:TsetE; getE1:TgetE;data1:pointer);

    procedure AddScrollBar(min1,max1,dx1,dx2:float);
    function ModifyScrollBarA(id:integer; min1,max1,dx1,dx2:float):boolean;

    procedure AddCheckBox;
    procedure SetCheckBox(idNum:integer);
    procedure SetReadOnly;

    procedure setShortString(st:AnsiString;var x:ShortString;xmax,n:integer);
    procedure setString0(st:AnsiString;var x:AnsiString;n:integer;setSt1:TsetSt=nil; getSt1:TgetSt=nil;data1:pointer=nil; Update2:boolean=false);
    procedure setString(st:AnsiString;var x:AnsiString;n:integer);
    procedure setStringProp(st:AnsiString;n:integer;setSt1:TsetSt; getSt1:TgetSt;data1:pointer);

    procedure setMemo0(st:AnsiString;var x:AnsiString;n,Nline,flags:integer;setSt1:TsetSt=nil; getSt1:TgetSt=nil;data1:pointer=nil; Update2:boolean=false);
    procedure setMemo(st:AnsiString;var x:AnsiString;n,Nline,flags:integer);
    procedure setMemoProp(st:AnsiString;n,Nline,flags:integer;setSt1:TsetSt; getSt1:TgetSt;data1:pointer);


    procedure setDateTime0(mode1:integer; st:AnsiString;n:integer);
    procedure setDateTime(mode:integer;st:AnsiString;var x:TdateTime;n:integer);
    procedure setDateTimeProp(mode:integer;st:AnsiString;n:integer;setDT1:TsetDt; getDT1:TgetDT;data1:pointer);


    procedure setBoolean0(st:AnsiString;var x:boolean;setB1:TsetB; getB1:TgetB;data1:pointer);
    procedure setBoolean(st:AnsiString;var x:boolean);
    procedure setBooleanProp(st:AnsiString;setB1:TsetB; getB1:TgetB;data1:pointer);


    procedure setEnumerated(st,st1:AnsiString;var x;tpx:Tnumtype;
                                  const setI1:TsetI=nil; const getI1:TgetI=nil; const data1:pointer=nil;const vv: TarrayOfInteger=nil;const sst: TarrayOfString=nil;
                                  const setSt1:TsetSt=nil; const getSt1:TgetSt=nil);
    procedure ModifyEnumerated(AnId:integer; st,st1:AnsiString;
                               const vv: TarrayOfInteger=nil;const sst: TarrayOfString=nil);

    procedure setListBox(st,st1:AnsiString;nblig,nbcol:integer;var x;Fsingle,Fcheck:boolean;number1:integer; minlen:integer);

    procedure setCommand(st:AnsiString;var x:boolean;mres:integer);



    procedure setColor(st:AnsiString;var x:longint);

    procedure modifyText(id:integer;st:AnsiString; FontName:AnsiString;FontSize,FontColor,FontStyle:integer);



    procedure addText(nbCar:integer);

    procedure updateControl(num:integer);
    procedure updateControls;

    procedure updateVars;
    procedure updateVar(num:integer);
    procedure DerefObjects;

    procedure setBackPanel(embed:boolean);
    property CtrlInstalled:boolean read Finstalled;


    function selectPanel(num:integer):boolean;overload;
    function selectPanel(stName:AnsiString):boolean;overload;

    function DividePanel(mode:TpanelType;num0,nb:integer):boolean;overload;
    function DividePanel(mode:TpanelType;stName:AnsiString;nb:integer):boolean;overload;

    function splitPanel(num:integer;st:AnsiString;nbTabs:integer):boolean;overload;
    function splitPanel(stName:AnsiString;st:AnsiString;nbTabs:integer):boolean;overload;

    procedure setPanelProp(Fborder: boolean;Fbevel:integer;const mleft:integer=-1; const mtop:integer=-1;const mright:integer=-1; const mbottom:integer=-1);
    procedure setLineSpacing(inter:integer);
    procedure DispatchMsgs;

    procedure installButtons;
    procedure DisplayInfo;

    procedure setObject(st:AnsiString;var x:TGvariant;n:integer;classID:AnsiString);

    procedure CheckObject(source:typeUO);
    procedure InstallForm;

    function SelectTab(num:integer;value:integer):boolean;overload;
    function SelectTab(stName:AnsiString;value:integer):boolean;overload;

    function setExtControl(AnUO:typeUO):boolean;

    function BackPanel: TwinControl; // Tpanel;

    procedure SetHline(n:integer);
    function GetHline: integer;

    function AddGroupBox(st:AnsiString):boolean;
    function setId(n:integer):integer;
  end;

function nbToTT(n:integer):TnumType;

implementation

uses chooseOb;

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}
{$R ElphyRes1.res}

procedure SetLblCaption(lbl:Tlabel;st:AnsiString);
var
  i:integer;
  st1: string;
  w:integer;
begin
  lbl.Caption:=st;

  for i:=1 to length(st) do
  begin
    if st[i]<>' ' then exit;
    st1:=st1+'x';
  end;

  // si st ne contient que des espaces, on ajuste width
  lbl.Caption:= st1 ;
  w:=lbl.width;
  lbl.Caption:= st ;
  lbl.Width:=w;

end;



{ TDBnavigatorG }

function TDBnavigatorG.getButton(w: TnavigateBtn): TNavButton;
begin
  result:=Buttons[w];
end;


Const
  HtabSheet:integer=16;



{ TDBpanel }


constructor TDBpanel.create(Aowner:Tcomponent;tp:TpanelType;var num:integer;stName:AnsiString);
begin
  Wnum:=num;
  name:=stName;
  inc(num);

  panelType:=tp;
  case tp of
    PTsingle,PTvert,PThor,PTmulti:
      begin
         backPanel:=Tpanel.Create(Aowner);
         Tpanel(backPanel).ParentBackGround:=false;
      end;
    PTpage:                backPanel:=TpageControl.Create(Aowner);
    PTtabSheet:            backPanel:=TtabSheet.Create(Aowner);
    PTgroupBox,PTgroupVert,PTgroupHor,PTgroupMulti:
      begin
        backPanel:=TgroupBox.create(Aowner);
        TgroupBox(backPanel).ParentBackGround:=false;
      end;
  end;

  {$IFDEF FPC} Backpanel.Color:=clMenuBar ; {$ENDIF}

  LeftMargin:=10;
  rightMargin :=5;
  TopMargin:=8;
  BottomMargin:=5;
  LineSpace:=2;
  GroupBoxMargin:=4;

  Ylabel:=TopMargin;
end;

destructor TDBpanel.destroy;
var
  i:integer;
begin
  for i:=0 to high(next) do
    next[i].Free;
  setlength(next,0);

  inherited;
end;

function TDBpanel.divide(var curNum:integer;mode:TpanelType; nb: integer;stOpt:TstringList):boolean;
var
  i:integer;
  page:TpageControl;
begin
  result:=false;
  if (length(next)=1) and (next[0].PanelType=PTgroupBox) then
  begin
    result:=divideGroupBox(curnum,mode,nb);
    exit;
  end;

  if not ((panelType in [PTsingle,PTtabSheet]) and (length(next)=0)) then exit;

  panelType:=mode;
  setlength(next,nb);
  TabNum:=1;

  case mode of
    PTvert,PThor,PTmulti:
                   for i:=0 to nb-1 do
                   begin
                     next[i]:=TDBpanel.Create(backPanel.Owner,PTsingle,curnum,name+'.'+Istr(i+1));
                     with Tpanel(next[i].BackPanel) do
                     begin
                       parent:=self.backPanel;
                       parentBackGround:=false;
                       BevelOuter:=BvNone;
                       if mode=PTmulti then
                       begin
                         Align:=AlClient;
                         visible:=(i=0);
                       end;
                     end;
                   end;
    PTpage:        begin
                      page:=TpageControl.Create(backPanel.owner);
                      page.Parent:=BackPanel;
                      page.Align:=AlClient;

                      for i:=0 to nb-1 do
                      begin
                        next[i]:=TDBpanel.Create(backPanel.Owner,PTtabSheet,curnum,name+'.'+Istr(i+1));
                        with TtabSheet(next[i].BackPanel) do
                        begin
                          Align:=AlClient;
                          Caption:=stOpt[i];
                          PageControl:=Page;
                          Htabsheet:=page.Height- Height;
                        end;
                      end;
                   end;
  end;
  result:=true;
end;

function TDBpanel.divideGroupBox(var curNum:integer;mode:TpanelType;nb:integer):boolean;
var
  i:integer;
  page:TpageControl;
  stName:AnsiString;
begin
  result:=false;

  if length(next)<>1 then exit;
  case mode of
    PTvert:  mode:= PtGroupVert;
    PThor:   mode:= PtGroupHor;
    PTmulti: mode:= PtGroupMulti;
    else exit;
  end;

  stName:=name;

  with next[0] do
  begin
    panelType:=mode;
    setlength(next,nb);
    TabNum:=1;

    for i:=0 to nb-1 do
    begin
      next[i]:=TDBpanel.Create(backPanel.Owner,PTsingle,curnum,stname+'.'+Istr(i+1));
      with Tpanel(next[i].BackPanel) do
      begin
        parent:=self.backPanel;
        parentBackGround:=false;
        BevelOuter:=BvNone;
        if mode=PTmulti then
        begin
          Align:=AlClient;
          visible:=(i=0);
        end;
      end;
    end;
  end;

  result:=true;
end;


function TDBpanel.AddGroupBox(var curNum:integer; stCap:AnsiString;const margin:integer=3):boolean;
var
  i:integer;
  page:TpageControl;
begin
  result:=false;
  if not ((panelType in [PTsingle,PTtabSheet]) and (next=nil)) then exit;

  panelType:=PTmulti;
  setlength(next,1);
  TabNum:=1;

  next[0]:=TDBpanel.Create(backPanel.Owner,PTgroupBox,curnum,name+'.G');
  with TgroupBox(next[0].BackPanel) do
  begin
    parent:=self.backPanel;
    parentBackGround:=false;
    Align:=AlClient;
    caption:=stCap;
    GroupBoxMargin:= margin;
  end;

  next[0].Ylabel:= TopMargin+10;

  result:=true;
end;


function TDBpanel.getWin(num: integer): TDBpanel;
var
  i:integer;
begin
  result:=nil;
  if Wnum=num then result:=self
  else
  for i:=0 to length(next)-1 do
  begin
    result:=next[i].getWin(num);
    if assigned(result) then exit;
  end;
end;

function TDBpanel.getWin(stName:AnsiString): TDBpanel;
var
  i:integer;
begin
  result:=nil;
  if name=stName then result:=self
  else
  for i:=0 to length(next)-1 do
  begin
    result:=next[i].getWin(stName);
    if assigned(result) then exit;
  end;
end;

Const
  GroupDx=5;
  GroupDy=18;

procedure TDBpanel.setPos(x1, y1, dx1, dy1: integer);
var
  i:integer;
  x0,dx0,y0,dy0:integer;
begin
  if panelType in [PTgroupBox, PTgroupVert, PTgroupHor, PTgroupMulti] then
  begin
    backPanel.Align:=AlNone;
    x1:=x1+GroupBoxMargin;
    y1:=y1+GroupBoxMargin;
    dx1:= dx1-2*GroupBoxMargin;
    dy1:= dy1-2*GroupBoxMargin;
  end;

  backPanel.left:=x1;
  backPanel.top:= y1;
  backPanel.width:= dx1;
  backPanel.height:=dy1;


  case panelType of
    PTVert:
            begin
              dx0:=0;
              x0:=0;
              for i:=0 to length(next)-1 do
              begin
                dx0:=next[i].backPanel.width;
                next[i].setPos(x0,0,dx0,dy1);
                x0:=x0+dx0;
              end;
            end;
    PTgroupVert:
            begin
              dx0:=0;
              x0:=GroupDx;
              for i:=0 to length(next)-1 do
              begin
                dx0:=next[i].backPanel.width;
                next[i].setPos(x0,GroupDy,dx0-GroupDx,dy1-GroupDy);
                x0:=x0+dx0;
              end;
            end;
    PThor:
            begin
              dy0:=0;
              y0:=0;
              for i:=0 to length(next)-1 do
              begin
                dy0:=next[i].backPanel.height;
                next[i].setPos(0,y0,dx1,dy0);
                y0:=y0+dy0;
              end;
            end;
    PTgroupHor:
            begin
              dy0:=0;
              y0:=GroupDy;
              for i:=0 to length(next)-1 do
              begin
                dy0:=next[i].backPanel.height;
                next[i].setPos(GroupDx,y0,dx1-GroupDx,dy0-GroupDy);
                y0:=y0+dy0;
              end;
            end;
    PTpage,PTmulti:
             for i:=0 to length(next)-1 do
                next[i].setPos(0,0,dx1,dy1);
    PTgroupMulti:
             for i:=0 to length(next)-1 do
                next[i].setPos(GroupDx,GroupDy,dx1-GroupDx,dy1-GroupDy);


  end;
end;

procedure TDBpanel.CalculPos(var dx1,dy1:integer);
var
  i,j:integer;
  col1,col2,firstCom,maxW:integer;
  maxY,iy:integer;
  nbctrl:integer;
  dxa,dya:integer;
  FlagCb:boolean;
const
  lblExtra=2;

  cbWidth=20;

begin
  case panelType of
    PThor,PTgroupHor:
            begin
              dx1:=0;
              dy1:=0;
              for i:=0 to high(next) do
              begin
                next[i].CalculPos(dxa,dya);
                if dxa>dx1 then dx1:=dxa;
                dy1:=dy1+dya;
              end;
            end;

    PTvert, PTgroupVert:
            begin
              dx1:=0;
              dy1:=0;
              for i:=0 to high(next) do
              begin
                next[i].CalculPos(dxa,dya);
                dx1:=dx1+dxa;
                if dya>dy1 then dy1:=dya;
              end;
            end;

    PTpage,PTmulti,PTgroupMulti:
            begin
              dx1:=0;
              dy1:=0;
              for i:=0 to high(next) do
              begin
                next[i].CalculPos(dxa,dya);
                if dxa>dx1 then dx1:=dxa;
                if dya>dy1 then dy1:=dya;
              end;
              if PanelType=PTpage then dy1:=dy1+HtabSheet;
            end;

    PTsingle,PTtabSheet, PTgroupBox:
            begin
              nbCtrl:=length(ctrls);

              col1:=LeftMargin;
              col2:=0;
              firstCom:=-1;

              FlagCb:=false;
              for i:=0 to nbctrl-1 do                    { Calculer col1 }
                with ctrls[i]^ do
                begin
                  case genre of
                    gNumvar,gstring,gmemo, gboolean,genum,glistBox,gobject,gdateTime:
                               if col1<LeftMargin+lbl.width +lblExtra then col1:=LeftMargin+lbl.width +lblExtra;
                    gcolor:    if col1<LeftMargin+control.width then col1:=LeftMargin+control.width;
                    gCommand:  if lbl.visible and (col1<LeftMargin+control.width)
                                 then col1:=LeftMargin+control.width;
                    gNavigator, gExtCtrl:if col1<LeftMargin then col1:=LeftMargin;
                  end;
                  if assigned(cb) and DisplayedCb then FlagCb:=true;
                end;

              //col1:=col1+10;

              for i:=0 to nbctrl-1 do                    { Affecter Col1 et calculer col2 }
                with ctrls[i]^ do
                begin
                  case genre of
                    gtext:   if col2<LeftMargin+lbl.width +lblExtra then col2:=LeftMargin+lbl.width +lblExtra;
                    gcommand:
                             begin
                               if lbl.visible then
                                 begin
                                   if col2<col1+lbl.width +lblExtra then col2:=col1+lbl.width +lblExtra;
                                   lbl.left:=col1;
                                   SetLblcaption(lbl,'');
                                 end
                               else
                               if col2<LeftMargin+control.width then col2:=LeftMargin+control.width;

                               if firstCom=-1 then               {on ajuste les longueurs des boutons consécutifs }
                                 begin
                                   firstCom:=i;
                                   maxW:=control.width;
                                 end
                               else
                                 begin
                                   if control.width>maxW then maxW:=control.width;
                                   for j:=firstCom to i do ctrls[j]^.control.width:=MaxW;
                                 end;
                             end;
                    gstring,gmemo,gboolean,genum,glistBox,gnumvar,gobject,gDateTime:
                             begin
                               control.left:=col1;
                               if col2<col1+control.width then col2:=col1+control.width;

                               if (genre=gnumvar) and assigned(sb) then
                                 begin
                                   sb.left:=control.left+control.width+ 3;
                                   if col2<sb.Left+sb.Width then col2:=sb.Left+sb.Width;
                                 end
                               else
                               if (genre=gobject) then
                                 begin
                                   button.left:=control.left+control.width+ 3;

                                   if col2<button.Left+button.Width then col2:=button.Left+button.Width;
                                 end
                               else
                               if genre=gdateTime then
                                 begin
                                   buttonDate.left:=control.left+control.width+ 3;

                                   if col2<button.Left+buttonDate.Width then col2:=buttonDate.Left+buttonDate.Width;
                                 end;

                             end;
                    gColor:  begin
                               panel.left:=col1;
                               if col2<col1+panel.width then col2:=col1+panel.width;
                             end;
                    gNavigator:
                             if col2<LeftMargin+control.width then col2:=LeftMargin+control.width;
                    gExtCtrl:
                             if col2<LeftMargin+Wembedded then col2:=LeftMargin+Wembedded;
                  end;
                  if genre<>gcommand then firstCom:=-1;
                end;

              if FlagCb then
              begin
                for i:=0 to nbctrl-1 do                    { Positionner cb }
                  with ctrls[i]^ do
                    if assigned(cb) and DisplayedCb then cb.Left:=col2+3;

                col2:=col2+ 3+ cbWidth;
              end;

              dx1:=col2+rightMargin ;
              dy1:=Ylabel+BottomMargin;


            end;
  end;

  if panelType=PTgroupBox  then
  begin
    dx1:=dx1+2*GroupBoxMargin;
    dy1:=dy1+2*GroupBoxMargin;
  end
  else
  if panelType in [PTgroupHor,PTgroupVert,PTgroupMulti] then
  begin
    dx1:=dx1 + 2*GroupBoxMargin +GroupDx;
    dy1:=dy1 + 2*GroupBoxMargin +GroupDy;
  end;

  backPanel.width:=dx1;
  backPanel.Height:=dy1;
end;

function TDBpanel.getInfo:AnsiString;
begin
  with backPanel do
  result:=Istr1(Wnum,3)+Istr1(ord(panelType),3)+ Istr1(left,5)+Istr1(top,5)+Istr1(width,5)+Istr1(height,5);
end;

function TDBpanel.selectTab(value:integer):boolean;
var
  i:integer;
begin
  result:=false;
  if panelType =PTmulti then
  begin
    if (value<1) or (value>length(next)) then exit;

    TabNum:=value;
    for i:=0 to high(next) do
      next[i].BackPanel.Visible:=(i=TabNum-1);
  end
  else
  if panelType=PTpage then
  begin
    if (value<1) or (value>length(next)) then exit;
    TpageControl(backPanel).TabIndex:=value-1;
  end
  else exit;
  result:=true;
end;

{TDlgform2}


function nbToTT(n:integer):TnumType;
begin
  case typeNombre(n) of
    nbByte:      result:=T_byte;
    nbShort:     result:=T_ShortInt;
    nbSmall:     result:=T_SmallInt;
    nbWord:      result:=T_Word;
    nbLong:      result:=T_LongInt;
    nbSingle:    result:=T_Single;
    nbdouble:    result:=T_Double;
    nbExtended:  result:=T_Extended;
  end;
end;


const
  BT_Ok=     1;
  BT_Cancel= 2;
  BT_Abort=  4;
  BT_Retry=  8;
  BT_Ignore=16;
  BT_Yes=   32;
  BT_No=    64;


procedure TDlgForm2.CommandClick(Sender: TObject);
begin
  updateVars;

  with ctrl[Tbutton(sender).tag]^ do
  if assigned(ad) then Pboolean(ad)^:=true;

  ctrlChange(sender);
end;


procedure TDlgForm2.CommandMouseDown(Sender: TObject; Button: TMouseButton;
                               Shift: TShiftState; X, Y: Integer);
begin
  with ctrl[Tcontrol(sender).tag]^ do
  begin
    if pgOnDragDrop.valid then
      begin
        with pgOnDragDrop do pg.ManageProcedure(ad);
        if assigned(specialDrag)
          then Tbutton(sender).beginDrag(false);
      end;
  end;
end;

procedure TDlgForm2.CommandEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
  specialDrag:=nil;
end;

procedure TDlgForm2.ColorClick(Sender: TObject);
begin
  with colorDialog1,ctrl[Tbutton(sender).tag]^ do
  begin
    color:=Tcolor(Ad^);
    execute;
    Tcolor(Ad^):=color;
    Panel.color:=Tcolor(Ad^);
  end;

  ctrlChange(sender);
end;

function TDlgForm2.getCtrl(i:integer):Pctrl;
begin
  result:=Pctrl(ctrls[i-1]);
end;


function TDlgForm2.getWinControl(i:integer):Tcontrol;
begin
  result:=Pctrl(ctrls[i-1])^.control;
end;

procedure TDlgForm2.addCtrl;
var
  ct:PCtrl;
begin
  new(ct);
  fillchar(ct^,sizeof(ct^),0);
  ct^.DBPanel:=curDB;
  ct^.Number:= ctrls.Count+1;          // valeur par défaut aout 2011

  setlength(curDB.ctrls,length(curDB.ctrls)+1);
  curDB.ctrls[high(curDB.ctrls)]:=ct;

  ctrls.add(ct);
  inc(nbvar);
end;

function TDlgForm2.setId(n: integer): integer;
begin
  if n<>0 then ctrl[nbvar].Number:= n;
  result:= ctrl[nbvar].Number;
end;

procedure TDlgForm2.CtrlChange(sender:Tobject);
var
  n:integer;
begin
  if GUpdateCtrl then exit;

  n:=Tcontrol(sender).tag;
  with ctrl[n]^,pgOnChange do
  if valid then pg.ManageProcedure(ad);

  with ctrl[n]^,pgOnEvent do
    if valid then
      if number<>0
        then pg.ManageProcedure1(ad,number)
        else pg.ManageProcedure1(ad,n);
end;

procedure TDlgForm2.setText(st:AnsiString; FontName:AnsiString;FontSize,FontColor,FontStyle:integer );
var
  i:integer;
  sty:TFontStyles;
begin
  addCtrl;

  with ctrl[nbVar]^ do
  begin
    lbl:=Tlabel.create(self);
    lbl.parent:=curDB.BackPanel;
    SetLblCaption(lbl,st);

    if FontName<>'' then
    begin
      lbl.Font.Name:= FontName;
      lbl.Font.Size:= FontSize;
      lbl.Font.Color:= FontColor;

      sty:=[];
      if FontStyle and 1<>0 then sty:=sty+[fsBold];
      if FontStyle and 2<>0 then sty:=sty+[fsItalic];
      if FontStyle and 4<>0 then sty:=sty+[fsUnderLine];
      if FontStyle and 8<>0 then sty:=sty+[fsStrikeOut];
      lbl.font.style:=sty;
    end;

    genre:=gtext;

    adjust;
    inc(DBpanel.Ylabel,DBpanel.LineSpace);
  end;
end;

procedure TDlgForm2.modifyText(id:integer;st:AnsiString; FontName:AnsiString;FontSize,FontColor,FontStyle:integer);
var
  i:integer;
  sty:TFontStyles;
begin
  for i:=1 to ctrls.Count do
  with ctrl[i]^ do
    if (number=id) and assigned(lbl) then
    begin
      SetLblCaption(lbl,st);
      if FontName<>'' then
      begin
        lbl.Font.Name:= FontName;
        lbl.Font.Size:= FontSize;
        lbl.Font.Color:= FontColor;

        sty:=[];
        if FontStyle and 1<>0 then sty:=sty+[fsBold];
        if FontStyle and 2<>0 then sty:=sty+[fsItalic];
        if FontStyle and 4<>0 then sty:=sty+[fsUnderLine];
        if FontStyle and 8<>0 then sty:=sty+[fsStrikeOut];
        lbl.font.style:=sty;
      end;
    end;
end;

procedure TDlgForm2.EditNumChange(sender:Tobject);
var
  x:float;
begin
  if GUpdateCtrl then exit;
  with ctrl[Tcontrol(sender).tag]^ do
  if assigned(sb) then
  begin
    with TeditNum(control) do
    begin
      updateVar;
      case Tnum of
        T_byte:     x:=Pbyte(advar)^;
        T_shortInt: x:=Pshort(advar)^;
        T_smallInt: x:=PsmallInt(advar)^;
        T_word:     x:=Pword(advar)^;
        T_longint:  x:=Plongint(advar)^;

        T_single:   x:=Psingle(advar)^;
        T_real:     x:=Preal(advar)^;
        T_double:   x:=Pdouble(advar)^;
        T_extended: x:=Pextended(advar)^;
      end;
    end;

    sb.setParams(x,sb.Xmin,sb.Xmax);
  end;

  ctrlChange(sender);
end;

procedure TDlgForm2.setNumvar0(st:AnsiString;var x;t:tNumType;n,m:integer;setE1:TsetE=nil; getE1:TgetE=nil;data1:pointer=nil);
  var
    i:integer;
  begin
    addCtrl;

    st:=copy(st,1,50);

    with ctrl[nbVar]^ do
    begin
      lbl:=Tlabel.create(self);
      lbl.parent:=curDB.BackPanel;
      SetLblCaption(lbl,st);

      control:=TeditNum.create(self);

      control.parent:=curDB.BackPanel;

      if assigned(setE1) and assigned(getE1)
        then TeditNum(control).setProp(setE1,getE1,data1,t)
        else TeditNum(control).setVar(x,t);

      TeditNum(control).decimal:=m;
      Ndeci:=m;

      control.top:=curDB.Ylabel-2;
      control.width:=Lcar*(n+1);
      control.tag:=nbvar;
      TeditNum(control).onExit:=EditNumChange;
      {$IFNDEF FPC}
      TeditNum(control).onEnter:=EditNumChange;
      {$ELSE}
      TeditNum(control).height:=19;
      {La hauteur affichée reste égale à 23. ClientHeight=height }
      {$ENDIF}

      genre:=gnumvar;
    end;

    adjust;
  end;

procedure TDlgForm2.setNumVar(st:AnsiString;var x;t:tNumType;n,m:integer);
begin
  setnumvar0(st,x,t,n,m);
end;

procedure TDlgForm2.setNumProp(st:AnsiString;t:tNumType;n,m:integer; setE1:TsetE; getE1:TgetE;data1:pointer);
begin
  setnumvar0(st,nil^,t,n,m,setE1,getE1,data1);
end;


procedure TDlgForm2.sbScrollV(Sender: TObject;x:float;ScrollCode: TScrollCode);
var
  n:integer;
Const
  Flag: boolean=false;
begin
  if Flag=true then exit;
  if GUpdateCtrl then exit;

  FnoSmartTestEscape:=true;
  Flag:=true;
  // En mode Debug, on appelle FonScrollV uniquement sur scEndScroll
  if FdebugMode and (ScrollCode<>scEndScroll) then exit;

  Try

  with ctrl[TscrollbarV(sender).tag]^ do
  begin
    with TeditNum(control) do
    begin
      case Tnum of
        T_byte:     Pbyte(advar)^:=round(x);
        T_shortInt: Pshort(advar)^:=round(x);
        T_smallInt: PsmallInt(advar)^:=round(x);
        T_word:     Pword(advar)^:=round(x);
        T_longint:  Plongint(advar)^:=round(x);

        T_single:   Psingle(advar)^:=x;
        T_real:     Preal(advar)^:=x;
        T_double:   Pdouble(advar)^:=x;
        T_extended: Pextended(advar)^:=x;
      end;
      updateCtrl;
    end;

   //if ScrollCode<>scEndScroll then exit;                               // Cette ligne était devenue nécessaire suite à une modification de TestShiftEscape
   //if  ScrollCode in [ scPosition, scTrack, scTop, scBottom] then exit;// Elle redevient inutile grace à FnoSmartTestEscape

     with pgOnChange do
       if valid then pg.ManageProcedure(ad);
  end;

  n:=Tcontrol(sender).tag;
  with ctrl[n]^,pgOnEvent do
  if valid then
    if number<>0
      then pg.ManageProcedure1(ad,number)
      else pg.ManageProcedure1(ad,n);

  Finally
  Flag:=false;
  FnoSmartTestEscape:=false;
  End;
end;


procedure TDlgForm2.AddScrollBar(min1,max1,dx1,dx2:float);
var
  x:float;
begin
  with ctrl[nbVar]^ do
  begin
    if genre<>Gnumvar then exit;
    if assigned(sb) then exit;
    
    sb:=TscrollbarV.create(self);
    sb.parent:=curDB.BackPanel;

    with sb do
    begin
      top:=control.top+1;
      height:=control.height-2;
      width:=80;
      tag:=nbvar;
      kind:=sbHorizontal;

      onScrollV:=sbScrollV;

      with TeditNum(control) do
      begin
        case Tnum of
          T_byte:     x:=Pbyte(advar)^;
          T_shortInt: x:=Pshort(advar)^;
          T_smallInt: x:=PsmallInt(advar)^;
          T_word:     x:=Pword(advar)^;
          T_longint:  x:=Plongint(advar)^;

          T_single:   x:=Psingle(advar)^;
          T_real:     x:=Preal(advar)^;
          T_double:   x:=Pdouble(advar)^;
          T_extended: x:=Pextended(advar)^;
        end;
      end;

      setParams(x,min1,max1);
      dxSmall:=dx1;
      dxLarge:=dx2;

    end;
  end;
 end;

function TDlgForm2.ModifyScrollBarA(id: integer; min1, max1, dx1, dx2: float):boolean;
var
  i:integer;
  x:float;
begin
  result:=false;
  for i:=1 to ctrls.Count do
  with ctrl[i]^ do
    if (number=id) and (genre=Gnumvar) and assigned(sb) then
    begin
      with TeditNum(control) do
      begin
        case Tnum of
          T_byte:     x:=Pbyte(advar)^;
          T_shortInt: x:=Pshort(advar)^;
          T_smallInt: x:=PsmallInt(advar)^;
          T_word:     x:=Pword(advar)^;
          T_longint:  x:=Plongint(advar)^;

          T_single:   x:=Psingle(advar)^;
          T_real:     x:=Preal(advar)^;
          T_double:   x:=Pdouble(advar)^;
          T_extended: x:=Pextended(advar)^;
        end;
      end;

      with sb do
      begin
        setParams(x,min1,max1);
        dxSmall:=dx1;
        dxLarge:=dx2;
      end;
      result:=true;
    end;
end;

procedure TDlgForm2.AddCheckBox;
var
  x:float;
begin
  with ctrl[nbVar]^ do
  begin
    if not (genre in [gstring,gmemo,gboolean,genum,glistBox,gnumvar,gobject,gDateTime]) then exit;
    if assigned(cb) then exit;

    cb:=TcheckBox.create(self);
    cb.parent:=curDB.BackPanel;

    DisplayedCb:=true;
    with cb do
    begin
      top:=control.top+1;
      height:=control.height-2;
      width:=20;
      tag:=nbvar;
    end;
  end;
 end;

procedure TDlgForm2.SetCheckBox(idNum: integer);
var
  x:float;
begin
  with ctrl[nbVar]^ do
  begin
    if not (genre in [gstring,gmemo,gboolean,genum,glistBox,gnumvar,gobject,gDateTime]) then exit;
    if assigned(cb) then exit;

    IdNum:=getCtrlFromId(idNum);
    if IdNum=0 then exit;

    if assigned(ctrl[idNum]^.cb) then cb:= ctrl[idNum]^.cb
    else
    if ctrl[idNum]^.control is TcheckBoxV then cb:= TcheckBox(ctrl[idNum]^.control);

    DisplayedCb:=false;
  end;
end;


procedure TDlgForm2.SetReadOnly;
begin
  with ctrl[nbVar]^ do
  begin
    if not assigned(control) then exit;

    case genre of
      gstring:   TeditString(control).ReadOnly:=true;
      gmemo:     TmemoV(control).ReadOnly:=true;
      gboolean:  TcheckBoxV(control).State:=cbGrayed;
      genum:     TcomboBoxV(control).enabled:=false;
      gnumvar:   TeditNum(control).ReadOnly:=true;
      gDateTime: buttonDate.Enabled:=false;
    end;
  end;
 end;


procedure TDlgForm2.AddText(nbcar:integer);
var
  st:AnsiString;
  i:integer;
begin
  with ctrl[nbVar]^ do
  begin
    if genre<>Gcommand then exit;

    lbl.top:=Tbutton(control).top;
    lbl.visible:=true;
    st:='';
    for i:=1 to nbcar do st:=st+'m';
    SetLblCaption(lbl,st);
  end;
end;

procedure TDlgForm2.setShortString(st:AnsiString;var x:ShortString;xmax,n:integer);
  var
    i:integer;
  begin
    addCtrl;

    {st:=copy(st,1,80);}

    with ctrl[nbVar]^ do
    begin
      lbl:=Tlabel.create(self);
      lbl.parent:=curDB.BackPanel;

      SetLblCaption(lbl,st);

      control:=TeditString.create(self);
      control.parent:=curDB.BackPanel;
      control.tag:=nbvar;
      Teditstring(control).setVar(x,xmax);

      control.top:=curDB.Ylabel-2;
      control.width:=Lcar*n;

      TeditString(control).onExit:=CtrlChange;
      {$IFNDEF FPC}
      TeditString(control).onEnter:=CtrlChange;
      {$ELSE}
      control.height:=19;
      {La hauteur affichée reste égale à 23. ClientHeight=height }
      {$ENDIF}
      genre:=gstring;
    end;
    adjust;
  end;

procedure TDlgForm2.setString0(st:AnsiString;var x:AnsiString;n:integer;setSt1:TsetSt=nil; getSt1:TgetSt=nil;data1:pointer=nil; Update2:boolean=false);
begin
  addCtrl;

  with ctrl[nbVar]^ do
  begin
    lbl:=Tlabel.create(self);
    lbl.parent:=curDB.BackPanel;

    SetLblCaption(lbl,st);

    control:=TeditString.create(self);
    control.parent:=curDB.BackPanel;
    control.tag:=nbvar;

    if assigned(setSt1) and assigned(getSt1)
      then Teditstring(control).setProp(setSt1,getSt1,data1)
      else Teditstring(control).setString(x,2048);

    control.top:=curDB.Ylabel-2;
    control.width:=Lcar*n;

    TeditString(control).onExit:=CtrlChange;
    {$IFNDEF FPC}
    TeditString(control).onEnter:=CtrlChange;
    {$ELSE}
     TeditString(control).height:=19;
    {La hauteur affichée reste égale à 23. ClientHeight=height }
    {$ENDIF}
    TeditString(control).UpdateCtrlAfterVar:=Update2;

    genre:=gstring;
  end;
  adjust;
end;

procedure TDlgForm2.setString(st:AnsiString;var x:AnsiString;n:integer);
begin
  setString0(st,x,n);
end;

procedure TDlgForm2.setStringProp(st:AnsiString;n:integer;setSt1:TsetSt; getSt1:TgetSt;data1:pointer);
begin
  setString0(st,Pansistring(nil)^,n,setSt1,getSt1,data1);
end;


procedure TDlgForm2.setMemo0(st:AnsiString;var x:AnsiString;n,Nline,flags:integer;setSt1:TsetSt=nil; getSt1:TgetSt=nil;data1:pointer=nil; Update2:boolean=false);
begin
  addCtrl;

  with ctrl[nbVar]^ do
  begin
    lbl:=Tlabel.create(self);
    lbl.parent:=curDB.BackPanel;

    SetLblCaption(lbl,st);

    control:=TMemoV.create(self);
    control.parent:=curDB.BackPanel;
    control.tag:=nbvar;

    if assigned(setSt1) and assigned(getSt1)
      then TmemoV(control).setProp(setSt1,getSt1,data1)
      else TmemoV(control).setString(x);

    control.top:=curDB.Ylabel-2;
    control.width:=Lcar*n;
    control.Height:=Hcar*Nline+10;

    //TmemoV(control).WantReturns:=false;
    //TmemoV(control).WordWrap:=true;
    TmemoV(control).ScrollBars:=ssBoth;
    TmemoV(control).onExit:=CtrlChange;
    {$IFNDEF FPC}
    TmemoV(control).onEnter:=CtrlChange;
    {$ELSE}
    {La hauteur affichée reste égale à 23. ClientHeight=height }
    {$ENDIF}
    TmemoV(control).UpdateCtrlAfterVar:=Update2;

    genre:=gMemo;
  end;
  adjust;
end;

procedure TDlgForm2.setMemo(st:AnsiString;var x:AnsiString;n,Nline,flags:integer);
begin
  setMemo0(st,x,n,Nline,flags);
end;

procedure TDlgForm2.setMemoProp(st:AnsiString;n,Nline,flags:integer;setSt1:TsetSt; getSt1:TgetSt;data1:pointer);
begin
  setMemo0(st,Pansistring(nil)^,n,Nline,flags, setSt1,getSt1,data1);
end;


procedure TDlgForm2.ChooseDateClick(sender: Tobject);
var
  ok:boolean;
  numtag:integer;
  date1:TdateTime;
  pA:Tpoint;
begin
  numtag:=Tbutton(sender).tag;
  with ctrl[numtag]^ do
  begin
    date1:=StringToDateTime(TeditDateTime(control).Text);

    pA:=clientToScreen(point(buttonDate.Left,buttonDate.Top));

    ok:=getDateForm.Execute(date1,mode,pA.X,pA.y);
    if ok then
    begin
      TeditDateTime(control).Text:=DateTimeToString(date1);
      //TeditDateTime(control).UpdateVar;
      CtrlChange(sender);
    end;
  end;
end;


procedure TDlgForm2.setDateTime0(mode1:integer;st:AnsiString;n:integer);
begin
  addCtrl;

  with ctrl[nbVar]^ do
  begin
    lbl:=Tlabel.create(self);
    lbl.parent:=curDB.BackPanel;

    SetLblCaption(lbl,st);

    control:=TeditDateTime.create(self);
    control.parent:=curDB.BackPanel;
    control.tag:=nbvar;


    control.top:=curDB.Ylabel-2;
    control.width:=Lcar*n;

    Tedit(control).onExit:=CtrlChange;

    Tedit(control).readOnly:=true;

    button:=Tspeedbutton.create(self);
    buttonDate.Glyph.LoadFromResourceName(Hinstance,'SmallBut');
    buttonDate.NumGlyphs:=2;
    buttonDate.parent:=curDB.BackPanel;
    buttonDate.caption:='';
    buttonDate.left:=curDB.LeftMargin;
    buttonDate.top:=control.top;
    buttonDate.width:=18;
    buttonDate.height:=18;
    buttonDate.tag:=nbvar;
    buttonDate.onClick:=ChooseDateClick;

    mode:=mode1;
    genre:=gDateTime;
  end;
  adjust;
end;


procedure TDlgForm2.setDateTime(mode:integer;st:AnsiString;var x:TdateTime;n:integer);
begin
  setDateTime0(mode,st,n);
  with ctrl[nbVar]^ do
  begin

    TeditDateTime(control).setvar(x,n);
  end;
end;

procedure TDlgForm2.setDateTimeProp(mode:integer;st:AnsiString;n:integer;setDT1:TsetDt; getDT1:TgetDT;data1:pointer);
begin
  setDateTime0(mode,st,n);
  TeditDateTime(ctrl[nbVar]^.control).setProp(setDT1, getDT1, data1);
end;



procedure TDlgForm2.setBoolean0(st:AnsiString;var x:boolean;setB1:TsetB; getB1:TgetB;data1:pointer);
  var
    i:integer;
  begin
    addCtrl;
    st:=copy(st,1,50);

    with ctrl[nbVar]^ do
    begin
      lbl:=Tlabel.create(self);
      lbl.parent:=curDB.BackPanel;
      SetLblCaption(lbl,st);

      control:=TCheckBoxV.create(self);
      control.parent:=curDB.BackPanel;
      control.tag:=nbvar;

      if assigned(setB1)
        then TcheckBoxV(control).setProp(setB1,getB1,data1)
        else TcheckBoxV(control).setVar(x);

      control.top:=curDB.Ylabel-2;
      control.width:=control.height;
      TcheckBoxV(control).onClick:=CtrlChange;

      genre:=gboolean;
    end;
    adjust;
  end;

procedure TDlgForm2.setBoolean(st:AnsiString;var x:boolean);
begin
  setBoolean0(st,x,nil,nil,nil);
end;

procedure TDlgForm2.setBooleanProp(st:AnsiString;setB1:TsetB; getB1:TgetB;data1:pointer);
begin
  setBoolean0(st,Pboolean(nil)^,setB1,getB1,data1);
end;

procedure TDlgForm2.setEnumerated(st,st1:AnsiString;var x;tpx:Tnumtype;
                       const setI1:TsetI=nil; const getI1:TgetI=nil; const data1:pointer=nil;
                       const vv: TarrayOfInteger=nil;const sst: TarrayOfString=nil;
                       const setSt1:TsetSt=nil; const getSt1:TgetSt=nil);
var
  i,j,l:integer;
  stx:AnsiString;
  p,nb:integer;
  w:float;
  nn:integer;
  Alabel:Tlabel;
  st2:AnsiString;
  ok: boolean;

begin
  stx:=st1;
  nb:=0;
  while stx<>'' do
  begin
    p:=pos('|',stx);
    if p=0 then p:=length(stx)+1;
    inc(nb);
    delete(stx,1,p);
  end;

  if not assigned(setI1) and not assigned(setSt1) then
  begin
    if not assigned(vv) then
    begin
      w:=varToFloat(x,tpx);
      if w<1 then w:=1;
      if w>nb then w:=nb;
      FloatToVar(w,x,tpx);
    end
    else
    begin
      nn:=round(varToFloat(x,tpx));

      ok:=false;
      for i:=0 to high(vv) do
      if nn=vv[i] then ok:=true;

      if not ok then FloatToVar(vv[0],x,tpx);
    end
  end;

  addCtrl;
  st:=copy(st,1,50);

  with ctrl[nbVar]^ do
  begin
    lbl:=Tlabel.create(self);
    lbl.parent:=curDB.BackPanel;
    SetLblCaption(lbl,st);

    control:=TComboBoxV.create(self);
    control.parent:=curDB.BackPanel;
    control.tag:=nbvar;
    TcomboBoxV(control).style:=csDropDownList;
    TcomboBoxV(control).setString(st1);

    if assigned(setI1)
      then TcomboBoxV(control).setProp(setI1,getI1,data1)
    else
    if assigned(setSt1)
      then TcomboBoxV(control).setPropString(setSt1,getSt1,data1)
    else TcomboBoxV(control).setVar(x,tpx,1);

    if assigned(vv) then TcomboBoxV(control).SetValues(vv)
    else
    if assigned(sst) then TcomboBoxV(control).SetStValues(sst);

    Alabel:=Tlabel.create(self);
    Alabel.parent:=self;
    Alabel.ParentFont:=true;

    l:=0;           // Evaluation de la largeur l

    st1:=st1+'|';
    for i:=1 to length(st1) do
    begin
      if st1[i]='|' then
        begin
          SetLblCaption(Alabel,st2);
          if Alabel.Width>l then l:=Alabel.Width;
          st2:='';
        end
      else st2:=st2+st1[i];
    end;
    Alabel.free;


    control.width:=l+32;
    control.top:=curDB.Ylabel-2;

    {$IFDEF FPC}
     TcomboBoxV(control).height:=19;
    {La hauteur affichée reste égale à 23. ClientHeight=height }
    {$ENDIF}

    TcomboBoxV(control).onChange:=CtrlChange;

    genre:=genum;
  end;

  adjust;

end;

function TDlgForm2.getCtrlfromId(id:integer): integer;
var
  i:integer;
begin
  result:=0;
  for i:=1 to ctrls.Count do
  with ctrl[i]^ do
    if (number=id) then
    begin
      result:=i;
      exit;
    end;
end;


procedure TDlgForm2.ModifyEnumerated(AnId:integer; st,st1:AnsiString;
                       const vv: TarrayOfInteger=nil;const sst: TarrayOfString=nil);
var
  i,NumVar:integer;

begin
  st:=copy(st,1,50);

  Numvar:=getCtrlfromId(AnId);

  if (numvar=0) or (ctrl[NumVar]^.genre<>Genum) then exit;

  with ctrl[NumVar]^ do
  begin
    SetLblCaption(lbl,st);

    TcomboBoxV(control).setString(st1);

    if assigned(vv) then TcomboBoxV(control).SetValues(vv)
    else
    if assigned(sst) then TcomboBoxV(control).SetStValues(sst);
  end;
end;



procedure TDlgForm2.setListBox(st,st1:AnsiString;nblig,nbcol:integer;var x;Fsingle,Fcheck:boolean;number1:integer; minlen:integer);
var
  i,j,l:integer;
  stx,sty:AnsiString;
  p:integer;
  bb:TypeTabBoolean absolute x;
  w0:integer;
  lblTest: Tlabel;
  Lmax, Hmax:integer;

begin
  addCtrl;
  st:=copy(st,1,50);

  with ctrl[nbVar]^ do
  begin
    lbl:=Tlabel.create(self);
    lbl.parent:=curDB.BackPanel;
    SetLblCaption(lbl,st);

    if Fcheck
      then control:=TchecklistBoxV.create(self)
      else control:=TlistBoxV.create(self);
    control.parent:=curDB.BackPanel;
    control.tag:=nbvar;

    if Fcheck then
    with TchecklistBoxV(control) do
    begin
      setvar(x);
      multiselect:=true;
    end
    else
    with TlistBoxV(control) do
    begin
      if Fsingle then
      begin
        setvar1(x,number1);
        multiselect:=false;
        ExtendedSelect:=false;
      end
      else
      begin
        setvar(x);
        multiselect:=true;
        ExtendedSelect:=true;
      end;
    end;

    lblTest:=Tlabel.create(self);
    lblTest.Font:=TlistBoxV(control).Font;

    stx:='';
    for i:= 1 to minlen do stx:=stx+'m';
    lblTest.caption:= stx;
    Lmax:=lblTest.width;

    lblTest.caption:= 'M';
    Hmax:=lblTest.height;

    stx:=st1;
    l:=0;
    nbItem:=0;

    while stx<>'' do
    begin
      p:=pos('|',stx);
      if p=0 then p:=length(stx)+1;
      stY:=copy(stX,1,p-1);
      if length(stY)>l then l:=length(stY);
      with TlistBoxV(control) do
      begin
        Items.Add(stY);
        selected[items.count-1]:=bb[items.count-1];
      end;
      lbLtest.Caption:=stY;
      if lblTest.width>Lmax then Lmax:=lblTest.width;
      if lblTest.height>Hmax then Hmax:=lblTest.height;
      delete(stx,1,p);
      inc(nbItem);
    end;

    lblTest.free;


    with TlistBoxV(control) do
    begin
      //integralHeight:=true;

      Height:=(Hmax)*nblig+10;
      width:=(Lmax+20)*nbcol;
      top:=curDB.Ylabel-2;

      if Fsingle or (nbCol<=1)
        then Columns:=0
        else Columns:=nbcol;

      onClick:=CtrlChange;
    end;

    genre:=glistBox;
  end;

  adjust;

end;


procedure TDlgForm2.setCommand(st:AnsiString;var x:boolean;mres:integer);
  var
    i:integer;
  begin
    addCtrl;
    st:=copy(st,1,50);

    with ctrl[nbVar]^ do
    begin
      lbl:=Tlabel.create(self);
      lbl.parent:=curDB.BackPanel;
      SetLblCaption(lbl,st);
      lbl.visible:=false;

      control:=Tbutton.create(self);
      control.parent:=curDB.BackPanel;
      control.tag:=nbvar;
      Tbutton(control).caption:=st;
      Tbutton(control).left:=curDB.LeftMargin;
      Tbutton(control).width:=lbl.width+20;
      Tbutton(control).height:=Tbutton(control).height-4;
      Tbutton(control).modalResult:=mres;
      Tbutton(control).tag:=nbvar;
      Tbutton(control).onClick:=CommandClick;
      Tbutton(control).onMouseDown:=CommandMouseDown;
      Tbutton(control).onEndDrag:=CommandEndDrag;

      control.top:=curDB.Ylabel-2;
      ad:=@x;
      if assigned(ad) then x:=false;
      genre:=gcommand;
    end;
    adjust;
  end;



procedure TDlgForm2.Adjust;
var
  Hline:integer;
begin
  with ctrl[nbVar]^ do
  begin
    if assigned(lbl) then
    begin
      lbl.left:=curDB.LeftMargin;
      lbl.top:=curDB.Ylabel;
    end;

//      if assigned(control) then messageCentral('Height='+Istr(control.Height)+'ClientHeight='+Istr(control.ClientHeight));

    if assigned(control) then
    begin
      if (curDB.Hline0>0) and (genre in [gtext,gNumvar,gstring,gboolean,gEnum,gCommand,gColor])
        then Hline:=curDB.Hline0
        else Hline:= control.Height-2;
    end;

    if assigned(control) and (not assigned (lbl) or (control.Height>lbl.height))
      then inc(curDB.Ylabel , Hline + curDB.LineSpace)
    else
    if assigned(lbl) then inc(curDB.Ylabel , lbl.height+curDB.LineSpace)
    else
    if (genre = gExtCtrl) and assigned(EmbeddedUO) then inc(curDB.Ylabel , Hembedded + curDB.LineSpace);

  end;
end;

procedure TDlgForm2.setButtons(bb:integer);
  begin
    Fbutton:=bb;
  end;

procedure TDlgForm2.setColor(st:AnsiString;var x:longint);
  var
    i:integer;
  begin
    addCtrl;
    st:=copy(st,1,50);

    with ctrl[nbVar]^ do
    begin
      lbl:=Tlabel.create(self);
      lbl.parent:=curDB.BackPanel;
      SetLblCaption(lbl,st);

      control:=Tbutton.create(self);
      control.parent:=curDB.BackPanel;
      Tbutton(control).caption:=st;
      Tbutton(control).left:=curDB.LeftMargin;
      Tbutton(control).width:=lbl.width+20;
      Tbutton(control).height:=Tbutton(control).height-6;
      Tbutton(control).tag:=nbvar;
      Tbutton(control).onClick:=ColorClick;
      control.top:=curDB.Ylabel-2;

      lbl.visible:=false;

      panel:=Tpanel.create(self);
      panel.ParentBackground:=false;
      panel.parent:=curDB.BackPanel;
      panel.top:=control.top+1;
      panel.height:=control.height-1;
      panel.width:=50;
      panel.caption:='';
      panel.color:=Tcolor(x);
      panel.borderStyle:=bsSingle;
      panel.borderWidth:=1;
      panel.bevelInner:=bvNone;
      panel.bevelOuter:=bvNone;

      ad:=@x;
      genre:=gcolor;
    end;
    adjust;

  end;


procedure TDlgForm2.setObject(st: AnsiString; var x: TGvariant; n: integer; classID: AnsiString);
begin
    addCtrl;
    st:=copy(st,1,50);

    with ctrl[nbVar]^ do
    begin
      lbl:=Tlabel.create(self);
      lbl.parent:=curDB.BackPanel;
      SetLblCaption(lbl,st);

      control:=Tedit.create(self);
      control.parent:=curDB.BackPanel;
      control.top:=curDB.Ylabel-2;

      control.width:=Lcar*(n+1);
      control.tag:=nbvar;

      Tedit(control).readOnly:=true;
      Tedit(control).OnDragOver:=ObjectDragOver;
      Tedit(control).OnDragDrop:=ObjectDragDrop;


      button:=Tspeedbutton.create(self);
      button.Glyph.LoadFromResourceName(Hinstance,'SmallBut');
      button.NumGlyphs:=2;
      button.parent:=curDB.BackPanel;
      button.caption:='';
      button.left:=curDB.LeftMargin;
      button.top:=control.top;
      button.width:=18;
      button.height:=18;
      button.tag:=nbvar;
      button.onClick:=ChooseObjectClick;

      if x.Vtype<>gvObject then x.setObject(nil); //
      uoDlg.refVariant(x);                       //

      if x.Vobject<>nil
        then Tedit(control).text:=x.Vobject.ident
        else Tedit(control).text:='';
      ad:=@x;

      delete(classID,1,1);
      idObj:=stmClass(classID);
      genre:=gObject;
    end;
    adjust;

end;

procedure TDlgForm2.ChooseObjectClick(sender: Tobject);
var
  numtag:integer;
  AnUO: typeUO;
begin
  numtag:=Tbutton(sender).tag;

  with ctrl[numtag]^ do
  begin
    AnUO:= PGvariant(ad)^.Vobject;

    ChooseObject.caption:='';
    if chooseObject.execution(idObj,AnUO) then
    begin
      PGvariant(ad)^.setObject(AnUO);
      if assigned(AnUo)
        then Tedit(control).Text:=AnUO.ident
        else Tedit(control).Text:='';
      CtrlChange(sender);
    end;
  end;
end;

procedure TDlgForm2.ObjectDragOver(Sender, Source: TObject; X, Y: Integer;State: TDragState; var Accept: Boolean);
var
  numtag:integer;
begin
  numtag:=Tbutton(sender).tag;

  with ctrl[numtag]^ do
  begin
    Accept:= assigned(DragUOsource)
              and
              ( (DragUOsource.plotable) or
                (DragUOsource is TstmInspector) or
                (DragUOsource is TobjectFile)
              )
              and
              assigned(draggedUO) and (draggedUO is IdObj);
  end;
end;

procedure TDlgForm2.ObjectDragDrop(Sender, Source: TObject; X, Y: Integer);
var
  numtag:integer;
begin
  numtag:=Tbutton(sender).tag;

  with ctrl[numtag]^ do
  begin
    if not assigned(DraggedUO) then exit;

    if DragUOsource is TobjectFile then draggedUO:=cloneObjet(DraggedUO);
    if not assigned(DraggedUO) then exit;

    PGvariant(ad)^.setObject(DraggedUO);
    Tedit(control).Text:=DraggedUO.ident;

    resetDragUO;
  end;
end;

procedure TDlgForm2.CheckObject(source:typeUO);
var
  i:integer;
begin
  for i:=1 to nbvar do
  with ctrl[i]^ do
  begin
    if (genre=gObject) and (ad<>nil) and (PGvariant(ad)^.Vobject=source) then Tedit(control).Text:='';

    if (genre=gExtCtrl) and (EmbeddedUO=source) then
    begin
      EmbeddedUO.UnActiveEmbedded;
      UOdlg.derefObjet(EmbeddedUO);
      EmbeddedUO:=nil;
    end;
  end;
end;

procedure TDlgForm2.DerefObjects; // appelé par dlg.Destroy
var
  i:integer;
  x:float;
begin
  for i:=1 to nbvar do
    with Ctrl[i]^ do
    if genre=gObject then
    begin
      UOdlg.derefVariant(PgVariant(ad)^);
      Tedit(control).text:='';
    end
    else
    if genre=gExtCtrl then
    begin
      if assigned(EmbeddedUO) then EmbeddedUO.UnActiveEmbedded;
      UOdlg.derefObjet(EmbeddedUO);
      EmbeddedUO:=nil;
    end;
end;

procedure TDlgForm2.FormCreate(Sender: TObject);
var
  lbl:Tlabel;
begin
{ IFDEF FPC}
  //Lcar:=10;
{ ELSE}
  lbl:=Tlabel.create(self);
  lbl.parent:=self;
  lbl.ParentFont:=true;
  SetLblCaption(lbl,'MMMMMMMMMM');
  Lcar:=lbl.width div 10;
  Hcar:=lbl.Height+1;
  lbl.free;
{ ENDIF}
  ctrls:=Tlist.create;

  Fbutton:=BT_OK+BT_Cancel;

  DBpanels:=TDBpanel.create(self,PTsingle,PautoNum,'1');
  with DBpanels do
  begin
    Backpanel:=Tpanel.create(self);
    Tpanel(Backpanel).parent:=self;
    Tpanel(Backpanel).parentBackGround:= false;

    {$IFDEF FPC} Backpanel.Color:=clMenuBar ; {$ENDIF}

    Tpanel(BackPanel).BevelOuter:=BvNone;
    Tpanel(BackPanel).OnMouseDown:=FormMouseDown;
    Tpanel(BackPanel).OnMouseUp:=FormMouseUp;
    Tpanel(BackPanel).OnMouseMove:=FormMouseMove;


  end;
  curDB:=DBpanels;

  {$IFDEF FPC}
  Color:=clMenuBar ;
  DefaultMonitor:= dmMainForm;
  Position:= poMainFormCenter;
  {$ENDIF}
end;

procedure TDlgForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action:=caHide;
  FormDlgLeft:=left;
  FormDlgTop:=top;
end;

procedure TDlgForm2.installForm;
var
  dx1,dy1:integer;
begin
  if not Finstalled then
  begin
    DBpanels.calculPos(dx1,dy1);

    with backPanel do
    begin
      width:=dx1;
      height:=dy1;
      DBpanels.setPos(0,0,width,height);
    end;

    installButtons;

    ClientWidth:=backPanel.width;
    ClientHeight:=backPanel.Height;

    Finstalled:=true;
  end;
end;

procedure TDlgForm2.FormShow(Sender: TObject);
begin
  installForm;
end;



procedure TDlgForm2.setChecked(num:integer;w:boolean);
begin
  if (num>=1) and (num<=ctrls.count) then
    with ctrl[num]^ do
      if assigned(cb) then cb.Checked:=w;
end;

function TDlgForm2.getChecked(num:integer):boolean;
begin
  if (num>=1) and (num<=ctrls.count) then
    with ctrl[num]^ do
      if assigned(cb) then
      begin
        result:=cb.Checked;
        exit;
      end;
  result:=false;
end;

procedure TDlgForm2.setCheckedA(id:integer;w:boolean);
var
  i:integer;
begin
  for i:=1 to ctrls.Count do
  with ctrl[i]^ do
    if (number=id) and assigned(cb) then cb.Checked:=w;
end;

function TDlgForm2.getCheckedA(id:integer):boolean;
var
  i:integer;
begin
  for i:=1 to ctrls.Count do
  with ctrl[i]^ do
    if (number=id) and assigned(cb) then
    begin
      result:=cb.Checked;
      exit;
    end;

  result:=false;
end;

procedure TDlgForm2.setEnabled(num:integer;w:boolean);
begin
  if (num>=1) and (num<=ctrls.count) then
    with ctrl[num]^ do
      if assigned(control) then control.Enabled:=w;
end;

function TDlgForm2.getEnabled(num:integer):boolean;
begin
  if (num>=1) and (num<=ctrls.count) then
    with ctrl[num]^ do
      if assigned(control) then
      begin
        result:=control.Enabled;
        exit;
      end;
  result:=false;
end;

procedure TDlgForm2.setEnabledA(id:integer;w:boolean);
var
  i:integer;
begin
  for i:=1 to ctrls.Count do
  with ctrl[i]^ do
    if (number=id) and assigned(control) then control.Enabled:=w;
end;

function TDlgForm2.getEnabledA(id:integer):boolean;
var
  i:integer;
begin
  for i:=1 to ctrls.Count do
  with ctrl[i]^ do
    if (number=id) and assigned(control) then
    begin
      result:=control.Enabled;
      exit;
    end;

  result:=false;
end;


procedure TDlgForm2.FormDestroy(Sender: TObject);
var
  i:integer;
begin
  DBpanels.Free;

  for i:=1 to ctrls.count do
  with ctrl[i]^ do
  begin
    lbl.free;

    if genre<>gExtCtrl then control.free
    else
    if assigned(control) then control.parent:=nil;

    case genre of
      gnumvar:  sb.free;
      gcolor:   panel.free;
      gObject:  button.free;
      gdateTime:    buttonDate.free;
    end;
  end;

  for i:=0 to ctrls.count-1 do
    dispose(Pctrl(ctrls[i]));
  ctrls.free;
  nbvar:=0;
end;

procedure TDlgForm2.updateControls;
var
  i:integer;
  x:float;
begin
  GUpdateCtrl:=true;
  try
  updateAllCtrl(self);

  for i:=1 to nbvar do
    with Ctrl[i]^ do
    if (genre=gnumvar) and assigned(sb) then
      with TeditNum(control) do
      begin
        case Tnum of
          T_byte:     x:=Pbyte(advar)^;
          T_shortInt: x:=Pshort(advar)^;
          T_smallInt: x:=PsmallInt(advar)^;
          T_word:     x:=Pword(advar)^;
          T_longint:  x:=Plongint(advar)^;

          T_single:   x:=Psingle(advar)^;
          T_real:     x:=Preal(advar)^;
          T_double:   x:=Pdouble(advar)^;
          T_extended: x:=Pextended(advar)^;
        end;

        sb.setParams(x,sb.xmin,sb.xmax);
      end
    else
    if genre=gObject then
    with PgVariant(ad)^ do
    begin
      if Vobject<>nil
        then Tedit(control).text:=Vobject.ident
        else Tedit(control).text:='';
    end;

  finally
  GUpdateCtrl:=false;
  end;
end;

procedure TDlgForm2.updateVars;
begin
  updateAllVar(self);
end;

procedure TDlgForm2.updateVar(num:integer);
var
  i,k:integer;
begin
  k:=0;
  for i:=1 to ctrls.Count do
  if ctrl[i]^.number=num then k:=i;

  if (k=0) and (num>0) and (num<=ctrls.Count) then k:=num;
  if k=0 then exit;

  with ctrl[k]^ do
  begin
    if Control is TEditNum then TEditNum(Control).UpdateVar
    else
    if Control is TcheckBoxV then TcheckBoxV(Control).UpdateVar
    else
    if Control is TcomboBoxV then TcomboBoxV(Control).UpdateVar
    else
    if Control is TeditString then TeditString(Control).UpdateVar
    else
    if Control is TlistBoxV then TlistBoxV(Control).UpdateVar;

  end;
end;

procedure TDlgForm2.updateControl(num:integer);
var
  i,k:integer;
  x:float;
begin
  GUpdateCtrl:=true;
  try
  k:=0;
  for i:=1 to ctrls.Count do
  if ctrl[i]^.number=num then k:=i;

  if (k=0) and (num>0) and (num<=ctrls.Count) then k:=num;
  if k=0 then exit;

  with ctrl[k]^ do
  begin
    if Control is TEditNum then TEditNum(Control).UpdateCtrl
    else
    if Control is TcheckBoxV then TcheckBoxV(Control).UpdateCtrl
    else
    if Control is TcomboBoxV then TcomboBoxV(Control).UpdateCtrl
    else
    if Control is TeditString then TeditString(Control).UpdateCtrl
    else
    if Control is TlistBoxV then TlistBoxV(Control).UpdateCtrl;

    if (genre=gnumvar) and assigned(sb) then
      with TeditNum(control) do
      begin
        case Tnum of
          T_byte:     x:=Pbyte(advar)^;
          T_shortInt: x:=Pshort(advar)^;
          T_smallInt: x:=PsmallInt(advar)^;
          T_word:     x:=Pword(advar)^;
          T_longint:  x:=Plongint(advar)^;

          T_single:   x:=Psingle(advar)^;
          T_real:     x:=Preal(advar)^;
          T_double:   x:=Pdouble(advar)^;
          T_extended: x:=Pextended(advar)^;
        end;
        sb.setParams(x,sb.xmin,sb.xmax);
      end
    else
    if genre=gObject then
    with PgVariant(ad)^ do
    begin
      if Vobject<>nil
        then Tedit(control).text:=Vobject.ident
        else Tedit(control).text:='';
    end;
  end;
  finally
  GUpdateCtrl:=false;
  end;
end;



procedure TDlgForm2.FormActivate(Sender: TObject);
begin
  updateAllCtrl(self);
end;

procedure TDlgForm2.setBackPanel(embed:boolean);
begin
  if backPanel is Tpanel then
  if embed
    then Tpanel(BackPanel).BevelOuter:=BvRaised
    else Tpanel(BackPanel).BevelOuter:=BvNOne;
end;

{ On envoie les messages de la souris au parent s'il existe (cas ou le dialogue est
 encapsulé dans Multigraph).
   Les paramètres transmis sont seulement x et y dans wparam et lparam.
}

procedure TDlgForm2.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p:Tpoint;
begin
  if parent<>nil then
  begin
    p:=BackPanel.ClientToScreen(classes.point(x,y));
    parent.Perform(msg_XmouseUp,p.x,p.y);
  end;
end;

procedure TDlgForm2.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p:Tpoint;
begin
  if parent<>nil then
  begin
    p:=BackPanel.ClientToScreen(classes.point(x,y));
    parent.Perform(msg_XmouseDown,p.x,p.y);
  end;
end;


procedure TDlgForm2.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  p:Tpoint;
begin
  if parent<>nil then
  begin
    p:=BackPanel.ClientToScreen(classes.point(x,y));
    parent.Perform(msg_XmouseMove,p.x,p.y);
  end;
end;

function TDlgForm2.DividePanel(mode:TpanelType;num0,nb: integer):boolean;
var
  pw:TDBpanel;
begin
  pw:=DBpanels.getWin(num0);
  result:= assigned(pw);

  if result then
    result:=pw.divide(PautoNum,mode,nb,nil);

  if not assigned(curDB)
    then curDB:=pw.next[0];
end;

function TDlgForm2.DividePanel(mode: TpanelType; stName: AnsiString;
  nb: integer): boolean;
var
  pw:TDBpanel;
begin
  pw:=DBpanels.getWin(stName);
  result:= assigned(pw);

  if result then
    result:=pw.divide(PautoNum,mode,nb,nil);

  if not assigned(curDB)
    then curDB:=pw.next[0];
end;

function TDlgForm2.AddGroupBox(st: AnsiString): boolean;
begin
  if assigned(curDB) and (curDB.BackPanel is Tpanel)
    then result:= curDB.AddGroupBox(PAutoNum, st)
    else result:= false;

  if result then curDB:=curDB.next[0];
end;


function TDlgForm2.splitPanel(num:integer;st:AnsiString;nbTabs:integer):boolean;
var
  nb,p:integer;
  stY:TstringList;
  DB:TDBpanel;
begin
  result:=false;

  DB:=DBpanels.getwin(num);
  if not assigned(DB) then exit;

  stY:=TstringList.create;
  try
  nb:=0;
  while st<>'' do
  begin
    p:=pos('|',st);
    if p=0 then p:=length(st)+1;
    stY.Add(copy(st,1,p-1));
    delete(st,1,p);
    inc(nb);
  end;

  if nb>0
    then result:= DB.divide(PautoNum,PTpage,nb,stY)
    else result:= DB.divide(PautoNum,PTmulti,nbTabs,stY);

  finally
  stY.free;
  end;
end;

function TDlgForm2.splitPanel(stName: AnsiString; st: AnsiString; nbTabs: integer): boolean;
var
  nb,p:integer;
  stY:TstringList;
  DB:TDBpanel;
begin
  result:=false;

  DB:=DBpanels.getwin(stName);
  if not assigned(DB) then exit;

  stY:=TstringList.create;
  try
  nb:=0;
  while st<>'' do
  begin
    p:=pos('|',st);
    if p=0 then p:=length(st)+1;
    stY.Add(copy(st,1,p-1));
    delete(st,1,p);
    inc(nb);
  end;

  if nb>0
    then result:= DB.divide(PautoNum,PTpage,nb,stY)
    else result:= DB.divide(PautoNum,PTmulti,nbTabs,stY);

  finally
  stY.free;
  end;
end;


function TDlgForm2.SelectTab(num:integer;value:integer):boolean;
var
  DB:TDBpanel;
begin
  result:=false;

  DB:=DBpanels.getwin(num);
  if not assigned(DB) then exit;

  result:=DB.selectTab(value);
end;

function TDlgForm2.SelectTab(stName:AnsiString;value:integer):boolean;
var
  DB:TDBpanel;
begin
  result:=false;

  DB:=DBpanels.getwin(stName);
  if not assigned(DB) then exit;

  result:=DB.selectTab(value);
end;



function TDlgForm2.selectPanel(num: integer):boolean;
var
  pw:TDBpanel;
begin
  pw:=DBpanels.getWin(num);
  result:= assigned(pw);
  if not result then exit;

  if (length(pw.next)=1) and (pw.next[0].PanelType= PTgroupbox) then pw:= pw.next[0];

  curDB:=pw;
end;


function TDlgForm2.selectPanel(stName: AnsiString): boolean;
var
  pw:TDBpanel;
begin
  pw:=DBpanels.getWin(stName);
  result:= assigned(pw);
  if not result then exit;

  if (length(pw.next)=1) and (pw.next[0].PanelType= PTgroupbox) then pw:= pw.next[0];

  curDB:=pw;
end;

procedure TDlgForm2.setPanelProp(Fborder: boolean;Fbevel:integer;const mleft:integer=-1; const mtop:integer=-1;const mright:integer=-1; const mbottom:integer=-1);
begin
  if assigned(curDB) and (curDB.BackPanel is Tpanel) then
  with Tpanel(curDB.BackPanel) do
  begin
    case Fborder of
      false: BorderStyle:=bsNone;
      true:  BorderStyle:=bsSingle;
    end;
    case Fbevel of
      0: begin
           bevelOuter:=bvNone;
           bevelInner:=bvNone;
         end;
      1: begin
           bevelOuter:=bvRaised;
           bevelInner:=bvNone;
         end;
      2: begin
           bevelOuter:=bvLowered;
           bevelInner:=bvNone;
         end;
    end;

    if mleft>=0 then curDB.LeftMargin:=mleft;
    if mtop>=0 then
    begin
      curDB.TopMargin:=mtop;
      curDB.Ylabel:=mtop;
    end;
    if mright>=0 then curDB.rightMargin :=mright;
    if mbottom>=0 then curDB.BottomMargin :=mbottom;

  end;
end;

procedure TDlgForm2.setLineSpacing(inter:integer);
begin
  if assigned(curDB) and (curDB.BackPanel is Tpanel) then
  with curDB do
    LineSpace:=inter;
end;

procedure TDlgForm2.SetHline(n:integer);
begin
  if n<0 then n:=0;
  if n>100 then n:=100;
  if assigned(curDB) then curDB.Hline0:=n;
end;

function TDlgForm2.GetHline:integer;
begin
  if assigned(curDB)
    then result:=curDB.Hline0
    else result:=0;
end;

procedure TDlgForm2.DispatchMsgs;
var
  msg:Tmsg;
  i:integer;
begin
  while peekMessage(Msg,Handle,0,0,pm_remove)  do
  begin
      if (msg.message=wm_keyup) and (msg.wparam=VK_Escape) and (getKeyState(vk_shift) and $8000<>0)
        then QuestionFinPg
      else
      begin
        translateMessage(msg);
        dispatchMessage(msg);
      end;
  end;
end;

function TDlgForm2.BackPanel: TwinControl;// Tpanel;
begin
  result:=Tpanel(DBpanels.BackPanel);
end;


procedure TDlgForm2.installButtons;
var
  i,Lmini,l1:integer;
  Y0:integer;
begin
  Y0:=BackPanel.height;
  for i:=0 to 6 do
    if Fbutton and (1 shl i)<>0 then
      begin
        inc(nbBtn);
        if nbBtn<=3 then
          begin
            btn[nbBtn]:=Tbutton.create(self);
            with btn[nbBtn] do
            begin
              parent:=self;
              top:=Y0+5;
              height:=20;
              width:=60;
              case i of
                0:begin
                    caption:='OK';
                    modalResult:=mrOK;
                  end;
                1:begin
                    caption:='Cancel';
                    modalResult:=mrCancel;
                  end;
                2:begin
                    caption:='Abort';
                    modalResult:=mrAbort;
                  end;

                3:begin
                    caption:='Retry';
                    modalResult:=mrRetry;
                  end;
                4:begin
                    caption:='Ignore';
                    modalResult:=mrIgnore;
                  end;
                5:begin
                    caption:='Yes';
                    modalResult:=mrYes;
                  end;
                6:begin
                    caption:='No';
                    modalResult:=mrNo;
                  end;
              end;
            end;
          end;
      end;

  Lmini:=60*nbBtn+10*(nbBtn-1)+40;
  if backPanel.width<Lmini then backPanel.width:=Lmini;

  l1:=(backPanel.width-60*nbBtn) div (nbBtn+3);

  for i:=1 to nbBtn do
    with btn[i] do left:=2*l1+(i-1)*(60+l1);


  if nbBtn>0
    then backPanel.Height:=Y0+5+20+10
    else backPanel.Height:=Y0;

end;


procedure TDlgForm2.DisplayInfo;
var
  i:integer;
  st:AnsiString;
begin
  st:=DBpanels.getWin(0).getInfo;
  for i:=1 to PautoNum-1 do
    st:=st+crlf+DBpanels.getWin(i).getInfo;

  messageCentral(st);
end;


function TDlgForm2.setExtControl(AnUO:typeUO): boolean;
var
  rect0:Trect;
begin
  AnUO.NotPublished:=true;
  AnUO.embedded:=true;

  addCtrl;

  with ctrl[nbVar]^ do
  begin
    EmbeddedUO:=AnUO;
    rect0:=EmbeddedUO.ActiveEmbedded(curDB.BackPanel,curDB.LeftMargin,curDB.Ylabel-2,0,0);
    Wembedded:=rect0.Right-rect0.Left+1;
    Hembedded:=rect0.bottom-rect0.Top+1;
    {
    control:=AnUO.EmbeddedForm;
    control.parent:=curDB.BackPanel;
    control.Visible:=true;

    control.tag:=nbvar;                    tag ne sert à rien
    control.left:=curDB.LeftMargin;
    control.top:=curDB.Ylabel-2;
    }


    genre:=gExtCtrl;

    UOdlg.refObjet(EmbeddedUO);
  end;
  adjust;
end;



Initialization
AffDebug('Initialization formDlg2',0);
{$IFDEF FPC}
{$I formDlg2.lrs}
{$ENDIF}
end.
