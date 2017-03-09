unit revpan2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ComCtrls, ExtCtrls, Grids,

  util1,Gdos,DdosFich,Dgraphic,
  stmObj,stmVec1, chooseOb, debug0 ;

const
  maxNbC=20;
type
  TRCAinfo=record
             dataVec:Tvector;    {vecteur contenant les ev data}
             stEvt:string[255];  {fichier contenant les ev stim}

             tmaxi,dt0:double;       {Les psths de base sont calculés pour
                                      toutes les tranches de largeur dt0
                                      entre -tmaxi et +tmaxi }
             t,dt:double;            {Paramètres pour la matrice courante}

             AutoScale:boolean;      {Flag autoscale}
             seuilZ:double;          {Seuil de significativité=2.57}
             optiAvecSeuil:boolean;  {Flag entrainant un seuillage des cartes optimales}
           end;

  TRCAinfo1=record
              Nmoyen,Nsig:double;
              ZupRaw,ZupOpt:array[1..2] of double;
              nbPixelOpt:array[1..2] of integer;
            end;

type
  TrevPanel = class(TForm)
    pageControl1: TPageControl;
    Pgeneral: TTabSheet;
    Pdisplay: TTabSheet;
    esEvtFile: TeditString;
    Label1: TLabel;
    BevtFile: TButton;
    Label2: TLabel;
    Bcalculate: TButton;
    Panel1: TPanel;
    cbDataVector: TcomboBoxV;
    PaintBox1: TPaintBox;
    cbAutoScale: TCheckBoxV;
    GroupBox1: TGroupBox;
    Label4: TLabel;
    enT2: TeditNum;
    GroupBox3: TGroupBox;
    Lt: TLabel;
    sbT: TscrollbarV;
    Ldt: TLabel;
    sbDT: TscrollbarV;
    Label7: TLabel;
    enDt0: TeditNum;
    Popti: TTabSheet;
    GroupBox2: TGroupBox;
    LNmoyen: TLabel;
    LdeltaN: TLabel;
    Button1: TButton;
    Label3: TLabel;
    enSeuil: TeditNum;
    cbUseTh: TCheckBoxV;
    LzupRaw: TLabel;
    LzupOpt: TLabel;
    procedure BcalculateClick(Sender: TObject);
    procedure BevtFileClick(Sender: TObject);
    procedure cbDataVectorDropDown(Sender: TObject);
    procedure sbTScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure sbDTScrollV(Sender: TObject; x: Extended;
      ScrollCode: TScrollCode);
    procedure PdisplayEnter(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure pageControl1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure cbDataVectorChange(Sender: TObject);
  private
    { Déclarations privées }
    adInfo:^TRCAinfo;
    adInfo1:^TRCAinfo1;

    owner0:typeUO;
  public

    { Déclarations publiques }
    loadEvtFileP: procedure of object;
    CalculPsthP: procedure of object;
    CalculOptiP: procedure of object;

    scrollTP,scrollDTP:procedure (x:float) of object;

    procedure initSB;
    procedure AffichePopti;

    procedure init(owner:typeUO;var Info:TRCAinfo;var resultat:TRCAinfo1);

    procedure setCaptions;
  end;


implementation



{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

procedure TrevPanel.init(owner:typeUO;var Info:TRCAinfo;var resultat:TRCAinfo1);
begin
  owner0:=owner;
  adinfo:=@info;
  adinfo1:=@resultat;

  with adinfo^ do
  begin
    cbDataVector.items.clear;
    if assigned(dataVec) then cbDataVector.items.add(DataVec.ident);
    cbDataVector.itemIndex:=0;

    esEvtFile.setvar(stEvt,128);

    installeComboBox(cbDataVector,dataVec,Tvector);

    enT2.setVar(tmaxi,t_double);
    enT2.setMinMax(0,10000);

    endt0.setVar(dt0,t_double);

    cbAutoScale.setvar(autoscale);

    enSeuil.setvar(seuilZ,t_double);

    cbUseTh.setvar(OptiAvecSeuil);

  end;

  with adInfo1^ do
  begin

  end;

  initSB;

end;

procedure TrevPanel.initSB;
begin
  with adInfo^ do
  begin
    sbt.setParams(t,-tmaxi,tmaxi-dt) ;
    sbt.dxSmall:=dt0;
    sbt.dxLarge:=dt0*10;

    sbdt.setParams(dt,dt0,tmaxi) ;
    sbdt.dxSmall:=dt0;
    sbdt.dxLarge:=dt0*10;

    Lt.caption:='t='+Estr(t,3);
    Ldt.caption:='dt='+Estr(dt,3);
  end;

  with adinfo1^ do LZupRaw.caption:='Zup=  '+Estr(adinfo1^.ZupRaw[1]+adinfo1^.ZupRaw[2],6);
end;


procedure TrevPanel.BcalculateClick(Sender: TObject);
begin
  updateAllVar(self);
  CalculPsthP;
end;

procedure TrevPanel.BevtFileClick(Sender: TObject);
var
  stFichier,stgen:AnsiString;
begin
  stFichier:=adinfo^.StEvt;
  stgen:='*.evt';
  if choixFichierStandard(stgen,stfichier,nil) then
    begin
      adinfo^.stEvt:=stFichier;
      esEvtFile.updateCtrl;
      loadEvtFileP;
    end;
end;

procedure TrevPanel.cbDataVectorDropDown(Sender: TObject);
begin
  with adInfo^ do installeComboBox(cbDataVector,dataVec,Tvector);
end;

procedure TrevPanel.sbTScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  updateAllvar(self);
  Lt.caption:='t='+Estr(x,3);
  scrollTP(x);
  paintBox1.refresh;
end;

procedure TrevPanel.sbDTScrollV(Sender: TObject; x: Extended;
  ScrollCode: TScrollCode);
begin
  updateAllvar(self);
  Ldt.caption:='dt='+Estr(x,6);
  scrollDTP(x);

  with adinfo^ do
  begin
    sbt.setParams(t,-tmaxi,tmaxi-dt) ;
  end;
  paintBox1.refresh;

  LZupRaw.caption:='Zup=  '+Estr(adinfo1^.ZupRaw[1]+adinfo1^.ZupRaw[2],6);
end;

procedure TrevPanel.PdisplayEnter(Sender: TObject);
begin
  initSB;
end;

procedure TrevPanel.PaintBox1Paint(Sender: TObject);
var
  hei,len:integer;
begin
  if not assigned(adinfo) then exit;


  with paintbox1 do initGraphic(canvas,left,top,width,height);

  len:=paintbox1.width-20;
  hei:=6;

  with paintbox1.canvas do
  begin
    pen.color:=clBlack;
    brush.color:=clGreen;
    rectangle(10,10,10+len,10+hei);

    brush.color:=clRed;

    with adinfo^ do
    rectangle(10+roundL((t+tmaxi)/(2*tmaxi)*len),10,
              10+roundL((t+dt+tmaxi)/(2*tmaxi)*len),10+hei);
  end;
  doneGraphic;

end;

procedure TrevPanel.pageControl1Change(Sender: TObject);
begin
  if pageControl1.ActivePage=Popti then AffichePopti;
end;

procedure TrevPanel.AffichePopti;
begin
  LNmoyen.caption:='N=    '+Estr(adinfo1^.Nmoyen,3);
  LdeltaN.caption:='dN= +-'+Estr(adinfo1^.Nsig,3);
  LZupOpt.caption:='Zup=  '+Estr(adinfo1^.ZupOpt[1]+adinfo1^.ZupOpt[2],6);
end;

procedure TrevPanel.Button1Click(Sender: TObject);
begin
  updateAllVar(self);
  calculOptiP;
  AffichePopti;
end;

procedure TrevPanel.cbDataVectorChange(Sender: TObject);
begin
  with adInfo^ do
  begin
    owner0.derefObjet(typeUO(dataVec));
    with CBdataVector do
    if (itemIndex>=0) and (itemIndex<items.count-1) then
      begin
        dataVec:=Tvector(items.objects[itemIndex]);
        owner0.refObjet(typeUO(dataVec));
      end
    else dataVec:=nil;
  end;
end;

procedure TrevPanel.setCaptions;
begin
  {
  with adInfo1^ do
  begin
    LN1.caption:='N1='+Istr(nbPixelOpt[1]);
    LN2.caption:='N2='+Istr(nbPixelOpt[2]);
  end;
  }
end;

Initialization
AffDebug('Initialization revpan2',0);
{$IFDEF FPC}
{$I revpan2.lrs}
{$ENDIF}
end.
