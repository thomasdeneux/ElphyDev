unit CreateAVI1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, editcont, StdCtrls, Buttons,
  util1, DdosFich, stmDef;

type
  TCreateAVIform = class(TForm)
    GroupBox1: TGroupBox;
    esFile: TEdit;
    Bfile: TBitBtn;
    BOK: TButton;
    Bcancel: TButton;
    enQuality: TeditNum;
    Lquality: TLabel;
    LNfactor: TLabel;
    enNfactor: TeditNum;
    procedure BfileClick(Sender: TObject);
  private
    { Déclarations privées }
    stf:AnsiString;
    ext0: string;
  public
    { Déclarations publiques }
    function execute(cap,ext: string; var st: AnsiString;var quality:integer;var Nfactor:integer): boolean;
  end;

function CreateAVIform: TCreateAVIform;


implementation

{$R *.dfm}

var
  CreateAVIform0: TCreateAVIform;

function CreateAVIform: TCreateAVIform;
begin
  if not assigned(CreateAVIform0) then CreateAVIform0:= TCreateAVIform.Create(formStm);
  result:=CreateAVIform0;
end;

procedure TCreateAVIform.BfileClick(Sender: TObject);
begin
  stf:= GsaveFile('Choose a file name',stf,ext0);
  if stf<>'' then esFile.Text:=stF;
end;

function TCreateAVIform.execute(cap,ext: string; var st: AnsiString; var quality:integer;var Nfactor:integer): boolean;
var
  IsJPG,isTex: boolean;
  ext1:string;
begin
  caption:= cap;
  if pos('.',ext)=0 then ext:='.'+ext;
  ext0:=ext;
  esFile.Text:=st;

  IsJPG:= (Fmaj(ext)='.JPG') or (Fmaj(ext)='.JPEG');
  IsTex := Fmaj(ext)='.TEX';
  if IsJPG then Lquality.Caption:= 'JPEG quality'
  else
  if isTex then Lquality.Caption:= 'Skip factor ';

  Lquality.Visible:= IsJPG or IsTex;
  enQuality.Visible:= IsJPG or IsTex;

  if IsJPG or IsTex then
  begin
    enQuality.setVar(quality,g_longint);
    enQuality.setMinMax(0,100);
  end;

  //cbAlpha.Visible:= (Fmaj(ext)<>'AVI') and (Fmaj(ext)<>'TEX');
  //cbAlpha.setVar(Falpha);

  enNfactor.setVar(Nfactor,g_longint);

  result:=false;

  if showModal=mrOK then
  begin
    updateAllVar(self);
    st:=esFile.Text;

    ext1:=Fmaj(extractFileExt(st));
    if Fmaj(ext0)<>ext1 then
    begin
      delete(st,length(st)-length(ext1)+1,length(ext1));
      st:=st+ext0;
    end;

    result:=true;
  end;

end;

end.
