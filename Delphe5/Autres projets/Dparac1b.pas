unit Dparac1b;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, editcont, ComCtrls;

type
  TparamAcq = class(TForm)
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Button1: TButton;
    Button2: TButton;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbMode: TcomboBoxV;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    enNbvoie: TeditNum;
    enDuree: TeditNum;
    enPeriode: TeditNum;
    Label5: TLabel;
    Label6: TLabel;
    enNbpt: TeditNum;
    enNbAv: TeditNum;
    GroupBox2: TGroupBox;
    comboBoxV1: TcomboBoxV;
    Label7: TLabel;
    Label8: TLabel;
    enVoieSynchro: TeditNum;
    Label9: TLabel;
    enSeuilHaut: TeditNum;
    enSeuilBas: TeditNum;
    Label10: TLabel;
    enInterval: TeditNum;
    Label11: TLabel;
    GroupBox3: TGroupBox;
    Label13: TLabel;
    enJ1: TeditNum;
    Label80: TLabel;
    enY1: TeditNum;
    Label14: TLabel;
    enJ2: TeditNum;
    Label15: TLabel;
    enY2: TeditNum;
    Label16: TLabel;
    editNum1: TeditNum;
    Label12: TLabel;
    comboBoxV2: TcomboBoxV;
    Label17: TLabel;
    editNum2: TeditNum;
    Label18: TLabel;
    editNum3: TeditNum;
    CheckBoxV1: TCheckBoxV;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  paramAcq: TparamAcq;

implementation

{$R *.DFM}

end.
