unit Utri1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,

  util1,Gdos,Ddosfich,spk0, Menus, StdCtrls, editcont,Dgraphic;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Info1: TMenuItem;
    ESdest: TeditString;
    ListBox1: TListBox;
    Bsave: TButton;
    Bappend: TButton;
    procedure File1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BsaveClick(Sender: TObject);
    procedure BappendClick(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    stDat,stGenDat:pathStr;
    stHis:shortString;
    tabStatEv:TtabStatEv;

    stDest:string;
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.File1Click(Sender: TObject);
var
  i:integer;
  ok:boolean;
begin
  if choixFichierStandard(stgenDat,stDat,StHis) then
    begin
      caption:='Tri SM2:'+nomDuFichier(stDat);
      ok:=tabStatEv.initFile(stDat);

      with listBox1 do
      begin
        clear;
        for i:=0 to tabStatEv.count-1 do items.add('Sequence '+Istr(i+1));
      end;
    end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ESdest.setString(stDest,50);
  tabStatEv:=TtabStatEv.create;
  stGenDat:='c:\data\fred\video\*.sm2';
end;

procedure TForm1.BsaveClick(Sender: TObject);
var
  res:integer;
  f1,f2:file;
  i:integer;
begin
  if stDest='' then exit;

  if fichierExiste(stDest) then
    begin
      res:=MessageDlg('File already exists. Overwrite?',
                       mtConfirmation,[mbYes,mbNo],0);
      if res<>mrYes then exit;
    end;

  assignFile(f1,stDat);
  Greset(f1,1);
  assignFile(f2,stDest);
  Grewrite(f2,1);

  with tabStatEv do
  begin
    fileCopy(f1,f2,HeaderSize);
    for i:=0 to count-1 do
      if listBox1.selected[i] then
        with PrecEv(items[i])^ do
        begin
          Gseek(f1,debut-6);
          fileCopy(f1,f2,info+6+spCount*6);
        end;
  end;

  Gclose(f1);
  Gclose(f2);
end;

procedure TForm1.BappendClick(Sender: TObject);
var
  res:integer;
  f1,f2:file;
  i:integer;
begin
  if stDest='' then exit;

  if not fichierExiste(stDest) then
    begin
      MessageCentral('File doesn''t exist');
      exit;
    end;

  assignFile(f1,stDat);
  Greset(f1,1);
  assignFile(f2,stDest);
  Greset(f2,1);
  Gseek(f2,GfileSize(f2));

  with tabStatEv do
  begin
    for i:=0 to count-1 do
      if listBox1.selected[i] then
        with PrecEv(items[i])^ do
        begin
          Gseek(f1,debut-6);
          fileCopy(f1,f2,info+6+spCount*6);
        end;
  end;

  Gclose(f1);
  Gclose(f2);
end;

end.
