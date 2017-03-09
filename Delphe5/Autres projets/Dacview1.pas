unit DacView1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, Menus,
  util1, Gdos, dtf0, stmDef, stmObj, spk0,
  dacCreat, stmCreat,stmSys0 ;

type
  TDACview = class(TForm)
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Options1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Pepisode: TPanel;
    Panel3: TPanel;
    BEpPrevious: TBitBtn;
    BEpNext: TBitBtn;
    Panel4: TPanel;
    Pobject: TPanel;
    BobjPrevious: TBitBtn;
    BobjNext: TBitBtn;
    OpenDialog1: TOpenDialog;
    Panel5: TPanel;
    Panel6: TPanel;
    Pname: TPanel;
    Panel8: TPanel;
    Pclass: TPanel;
    procedure File1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BEpNextClick(Sender: TObject);
    procedure BEpPreviousClick(Sender: TObject);
    procedure BobjPreviousClick(Sender: TObject);
    procedure BobjNextClick(Sender: TObject);
  private
    { Déclarations privées }
    stFile:string;
    statEv:TtabStatEv;

    numSeq:integer;
    numObj:integer;
    nbseq:integer;

    uo:typeUO;

    procedure load1(var f:file;num,infoSize:integer;var st1:string);
    procedure installeObjet;
    procedure afficheNum;
  public
    { Déclarations publiques }
  end;

var
  DACview: TDACview;

implementation

{$R *.DFM}

procedure TDACview.load1(var f:file;num,infoSize:integer;var st1:string);
var
  posMax:integer;
  size:integer;
  posf:integer;
  n:integer;
begin
  uo.free;
  uo:=nil;

  posMax:=GfilePos(f)+infoSize;            { Limite fichier }

  n:=0;
  size:=0;
  posf:=GfilePos(f);

  repeat
    Gseek(f,posf+size);
    posf:=GfilePos(f);
    st1:=readHeader(f,size);
    {messageCentral('___'+st1);}
    inc(n);
  until (GfilePos(f)>=posMax) or (n=num);
  if GfilePos(f)>=posmax then exit;


  uo:=CreateUO(st1);                  { créer l'objet si possible }
  {if assigned(uo) then messageCentral(st1+'  '+uo.ident)
                  else messageCentral(st1);}
  if assigned(uo) then
    begin
      uo.loadObject(f,size,nil,false);
      uo.clearReferences;
    end;
end;



procedure TDACview.installeObjet;
var
  f:file;
  st1:string;
begin
  if statEv.count=0 then exit;

  assignFile(f,stFile);
  Greset(f,1);
  with StatEv,PrecEv(items[numSeq-1])^ do
  begin
    Gseek(f,debut);
    Load1(f,numObj,info,st1);
  end;
  Gclose(f);


  if assigned(uo) then
    begin
      memo1.text:=uo.getInfo;
      Pname.caption:=uo.ident;
      Pclass.caption:=uo.stmClassName;
    end
  else
    begin
      memo1.text:='';
      Pname.caption:='';
      Pclass.caption:=st1;
    end;
  afficheNum;

end;

procedure TDACview.File1Click(Sender: TObject);
var
  st:string;
begin
  if not OpenDialog1.execute then exit;

  st:=OpenDialog1.fileName;

  if not statEv.initFile(st) then exit;

  {messageCentral(Istr(statEv.count));}
  stFile:=st;

  nbSeq:=statEv.count;
  numSeq:=1;
  numObj:=1;

  installeObjet;
end;

procedure TDACview.FormCreate(Sender: TObject);
begin
  statEv:=TtabStatEv.create;
  registerObject(Tsystem,sys);
  registerDacObjects;
  registerStmObjects;

end;

procedure TDACview.afficheNum;
begin
  Pepisode.caption:=Istr(numSeq);
  Pobject.caption:=Istr(numObj);
end;

procedure TDACview.BEpNextClick(Sender: TObject);
begin
  if numSeq<statEv.Count then
    begin
      inc(numSeq);
      numObj:=1;
      installeObjet;
    end;
end;

procedure TDACview.BEpPreviousClick(Sender: TObject);
begin
  if numSeq>1 then
    begin
      dec(numSeq);
      numObj:=1;
      installeObjet;
    end;
end;



procedure TDACview.BobjPreviousClick(Sender: TObject);
begin
  if numObj>1 then
    begin
      dec(numObj);
      installeObjet;
    end;

end;

procedure TDACview.BobjNextClick(Sender: TObject);
begin
  inc(numObj);
  installeObjet;        

  if not assigned(uo) then
    begin
      dec(numObj);
      installeObjet;
    end;

end;

end.
