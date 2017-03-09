unit stmBMcorrection1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, editcont, Buttons,

  util1,DdosFich, stmdef,syspal32;

type
  TBMcorrection = class(TForm)
    GroupBox1: TGroupBox;
    Bsource: TBitBtn;
    eSource: TeditString;
    GroupBox2: TGroupBox;
    eDest: TeditString;
    Bdest: TBitBtn;
    Bexecute: TButton;
    Bcancel: TButton;
    procedure BsourceClick(Sender: TObject);
    procedure BdestClick(Sender: TObject);
  private
    { Déclarations privées }
    stSource, stdest: Ansistring;
  public
    { Déclarations publiques }
    procedure Execute;
  end;


function BMcorrection: TBMcorrection;

implementation

{$R *.dfm}

var
  BMcorrection0: TBMcorrection;

function BMcorrection: TBMcorrection;
begin
  if not assigned(BMcorrection0) then BMcorrection0:= TBMcorrection.Create(formstm);
  result:=BMcorrection0;
end;

procedure TBMcorrection.BsourceClick(Sender: TObject);
var
  st: string;
begin
  if stSource='' then stSource:='*.bmp';
  st:= GchooseFile('Source File',stSource) ;
  if st<>'' then
  begin
    stSource:=st;
    eSource.UpdateCtrl;
  end;
end;

procedure TBMcorrection.BdestClick(Sender: TObject);
var
  st: string;
begin
  if stDest='' then stDest:='*.bmp';
  st:=GsaveFile('Destination File',stDest,'bmp');
  if st<>'' then
  begin
    stDest:=st;
    eDest.UpdateCtrl;
  end;
end;

procedure TBMcorrection.Execute;
var
  bm: Tbitmap;
  i,j: integer;
  p: PtabOctet;
begin
  eSource.setString(stSource,255);
  eDest.setString(stDest,255);

  if showModal=mrOK then
  begin
    updateAllVar(self);
    try
    bm:=Tbitmap.create;

    bm.LoadFromFile(stSource);
    if bm.PixelFormat= pf8bit then
    begin
      for j:=0 to bm.Height-1 do
      begin
        p:=bm.scanLine[j];
        for i:=0 to bm.width-1 do p^[i]:=syspal.IndexToGammaIndex( p^[i]);
      end;
    end;
    bm.SaveToFile(stDest);


    finally
    bm.free;
    end;
  end;
end;


end.
