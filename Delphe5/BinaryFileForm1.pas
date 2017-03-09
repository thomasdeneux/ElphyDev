unit BinaryFileForm1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont,
  util1, Gdos, Ddosfich,DescBinary1;

type
  TLoadBinForm = class(TForm)
    GroupBox1: TGroupBox;
    enHeaderSize: TeditNum;
    Label1: TLabel;
    cbNumType: TcomboBoxV;
    Label2: TLabel;
    Label3: TLabel;
    enNchannel: TeditNum;
    label4: TLabel;
    enDx: TeditNum;
    Label5: TLabel;
    enX0: TeditNum;
    Label6: TLabel;
    Label7: TLabel;
    enDy: TeditNum;
    enY0: TeditNum;
    Label8: TLabel;
    Label9: TLabel;
    cbContinuous: TCheckBoxV;
    cbMultiplexed: TCheckBoxV;
    Label10: TLabel;
    enSample: TeditNum;
    esUnitX: TeditString;
    esUnitY: TeditString;
    Bok: TButton;
    Bcancel: TButton;
    GroupBox2: TGroupBox;
    LabName: TLabel;
    Bload: TButton;
    Bsave: TButton;
    procedure BsaveClick(Sender: TObject);
    procedure BloadClick(Sender: TObject);
  private
    { Déclarations privées }
    prec:^TbinaryRec;
  public
    { Déclarations publiques }

    function execute(var rec:TbinaryRec): boolean;
  end;

function LoadBinForm: TLoadBinForm;

implementation



{$R *.dfm}

uses stmDf0;

var
  FLoadBinForm: TLoadBinForm;

function LoadBinForm: TLoadBinForm;
begin
  if not assigned(FloadBinForm) then FloadBinForm:= TloadBinForm.Create(nil);
  result:= FLoadBinForm;
end;

{ TForm1 }

function TLoadBinForm.execute(var rec: TbinaryRec): boolean;
begin
  prec:= @rec;
  with rec do
  begin
    enHeaderSize.setVar(HeaderSize,g_longint);
    with cbNumType do
    begin
      setStringArray(typeNameG,10,9);
      setvar(NumType,g_byte,0);
    end;
    enNchannel.setVar(Nchannel,g_longint);
    enDx.setVar(Dx,t_double);
    enDx.Decimal:=6;

    enX0.setVar(X0,t_double);
    enX0.Decimal:=6;

    enDy.setVar(Dy,t_double);
    enY0.setVar(Y0,t_double);
    cbContinuous.setVar(continuous);
    cbMultiplexed.setVar(Fmux);
    enSample.setVar(SamplePerEpisode,g_longint);
    esUnitX.setVar(unitX,20);
    esUnitY.setvar(unitY,20);

    result:= (showModal=mrOK);
    if result then updateAllVar(self);
  end;
end;


procedure TLoadBinForm.BsaveClick(Sender: TObject);
var
  stText:TstringList;
  st:AnsiString;
begin
  st:=stBinPrm;
  st:= GsaveFile('Save Parameter File',st,'BinPrm');
  if st<>'' then
  begin
    stBinPrm:=st;
    updateAllVar(self);
    stText:=TstringList.create;
    BinaryRecToStringList(prec^,stText);
    stText.SaveToFile(stBinPrm);
    stText.Free;
    LabName.Caption:=extractFileName(stBinPrm);
  end;
end;

procedure TLoadBinForm.BloadClick(Sender: TObject);
var
  stL: TstringList;
  stText,stf,st:AnsiString;

begin
  stL:= TstringList.Create;
  stf:=stBinPrm;
  if stf='' then stf:='*.BinPrm';
  stf:= GchooseFile('Load Parameter File',stf);
  if stf<>'' then
  begin
    stL.LoadFromFile(stf);
    StringListToBinaryRec(stL,prec^);
    stBinPrm:=stf;
    updateAllCtrl(self);
    LabName.Caption:=extractFileName(stBinPrm);
  end;
  stL.Free;


end;

end.
