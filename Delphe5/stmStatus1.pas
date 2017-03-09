unit stmStatus1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,forms,controls,menus,stdCtrls,
     editcont,ComCtrls,

     util1,Gdos,DdosFich,Dgraphic,
     Dpalette,Ncdef2,formMenu,

     stmDef,stmObj,
     varconf1,stmPlot1,FMemo1,
     debug0,
     stmError,stmPg;

type
  TstmStatusBar=class(TPlot)
           private
              statusBar:TstatusBar;
              ImmediateUpdate:boolean;
           public
              constructor create;override;
              destructor destroy;override;

              class function STMClassName:AnsiString;override;

            end;


procedure proTStatusBar_create(var pu:typeUO);pascal;
procedure proTStatusBar_create_1(nbPanel:integer;var pu:typeUO);pascal;
procedure proTStatusBar_setPanelProp(Num1,width1,Al1,Be1:integer;txt1:AnsiString;var pu:typeUO);pascal;

procedure proTStatusBar_text(Num1:integer;st:AnsiString;var pu:typeUO);pascal;
function fonctionTStatusBar_text(Num1:integer;var pu:typeUO):AnsiString;pascal;

function fonctionTStatusBar_font(var pu:typeUO):Tfont;pascal;

procedure proTStatusBar_Height(h1:integer;var pu:typeUO);pascal;
function fonctionTStatusBar_height(var pu:typeUO):integer;pascal;

procedure proTStatusBar_Visible(visible1:boolean;var pu:typeUO);pascal;
function fonctionTStatusBar_visible(var pu:typeUO):boolean;pascal;

procedure proTStatusBar_ImmediateUpdate(w:boolean;var pu:typeUO);pascal;
function fonctionTStatusBar_ImmediateUpdate(var pu:typeUO):boolean;pascal;

procedure proHideSystemStatusBar;pascal;

procedure proShowSystemStatusBar;pascal;

implementation

uses mdac;

constructor TstmStatusBar.create;
begin
  inherited;

  statusBar:=TstatusBar.Create(formStm);
  statusbar.Parent:=formStm;
  ImmediateUpdate:=true;
end;

destructor TstmStatusBar.destroy;
begin
  inherited;
  statusBar.Free;
end;


class function TstmStatusBar.STMClassName:AnsiString;
begin
  STMClassName:='StatusBar';
end;




{************************* Méthodes STM de TstmStatusBar ***************************}

procedure proTStatusBar_create(var pu:typeUO);
begin
  createPgObject('',pu,TstmStatusBar);
end;

procedure proTStatusBar_create_1(nbPanel:integer;var pu:typeUO);
var
  i:integer;
begin
  proTStatusBar_create(pu);
  with TstmStatusBar(pu) do
  for i:=0 to nbPanel-1 do
    statusbar.Panels.Add;
end;

procedure proTStatusBar_setPanelProp(Num1,width1,Al1,Be1:integer;txt1:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TstmStatusBar(pu) do
  begin
    if (num1<1) or (num1>statusbar.Panels.Count)
      then sortieErreur('Tstatusbar.setPanelProp : panel number out of range');
    if (width1<1) or (width1>3000)
      then sortieErreur('Tstatusbar.setPanelProp : width out of range');
    if (Al1<0) or (Al1>2)
      then sortieErreur('Tstatusbar.setPanelProp : Alignment out of range');
    if (Be1<0) or (Be1>2)
      then sortieErreur('Tstatusbar.setPanelProp : bevel code out of range');

    with statusBar.Panels[num1-1] do
    begin
      width:=width1;
      Alignment:=Talignment(Al1);
      Bevel:=TstatusPanelBevel(Be1);
      text:=txt1;
    end;
    if ImmediateUpdate then statusBar.update;
  end;
end;

procedure proTStatusBar_text(Num1:integer;st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  with TstmStatusBar(pu) do
  begin
    if (num1<1) or (num1>statusbar.Panels.Count)
      then sortieErreur('Tstatusbar.setPanelProp : panel number out of range');
    statusBar.panels[Num1-1].Text:=st;
    if ImmediateUpdate then statusBar.update;
  end;
end;

function fonctionTStatusBar_text(Num1:integer;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  with TstmStatusBar(pu) do
  begin
    if (num1<1) or (num1>statusbar.Panels.Count)
      then sortieErreur('Tstatusbar.setPanelProp : panel number out of range');
    result:=statusBar.panels[Num1-1].Text;
  end;
end;

function fonctionTStatusBar_font(var pu:typeUO):Tfont;
begin
  verifierObjet(pu);
  with TstmStatusBar(pu) do
    result:=statusBar.Font;
end;

procedure proTStatusBar_Height(h1:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TstmStatusBar(pu) do
  begin
    if (h1<1) or (h1>1000)
      then sortieErreur('Tstatusbar.Height : value out of range');
    statusBar.Height:=h1;
  end;
end;

function fonctionTStatusBar_height(var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TstmStatusBar(pu) do
  begin
    result:=statusBar.height;
  end;
end;

procedure proTStatusBar_Visible(visible1:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TstmStatusBar(pu) do
  begin
    statusBar.visible:=visible1;
  end;
end;

function fonctionTStatusBar_visible(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TstmStatusBar(pu) do
  begin
    result:=statusBar.visible;
  end;
end;

procedure proTStatusBar_ImmediateUpdate(w:boolean;var pu:typeUO);
begin
  verifierObjet(pu);
  with TstmStatusBar(pu) do
  begin
    ImmediateUpdate:=w;
  end;
end;

function fonctionTStatusBar_ImmediateUpdate(var pu:typeUO):boolean;
begin
  verifierObjet(pu);
  with TstmStatusBar(pu) do
  begin
    result:=ImmediateUpdate;
  end;
end;



procedure proHideSystemStatusBar;
begin
  mainDac.PanelBottom.Visible:=false;
end;

procedure proShowSystemStatusBar;
begin
  mainDac.PanelBottom.Visible:=true;
end;



Initialization
AffDebug('Initialization stmStatus1',0);
  registerObject(TstmStatusBar,sys);

end.

