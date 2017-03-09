unit regEditOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont,

  util1, stmDef, stmObj, stmDplot, stmOIseq1, ColorFrame1;

type
  TRegOptions = class(TForm)
    cbBinXBinY: TCheckBoxV;
    Button5: TButton;
    Button6: TButton;
    ColFrame1: TColFrame;
  private
    { Déclarations privées }
    Bin:boolean;
    Acolor:integer;
  public
    { Déclarations publiques }
    procedure execute(uo: TdataPlot);
  end;


  function RegOptions: TRegOptions;

implementation

{$R *.dfm}

var
  FregOptions: TRegOptions;

function RegOptions: TRegOptions;
begin
  if not assigned(FRegOptions) then FregOptions:=TregOptions.create(formStm);
  result:=FregOptions;
end;


{ TRegOptions }



procedure TRegOptions.execute(uo: TdataPlot);
begin
  Acolor:=uo.BKcolor;

  Bin:=uo.CoupledBinXY;
  cbBinXBinY.setVar(Bin);
  colFrame1.init(Acolor);

  if showModal=mrOK then
  begin
    updateAllVar(self);
    uo.CoupledBinXY:=bin;
    uo.BKcolor:=Acolor;
  end;
end;

end.
