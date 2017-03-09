unit BrowserTest1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw, Menus, ExtCtrls,

  util1;

type
  TGbrowse = class(TForm)
    WebBrowser1: TWebBrowser;
    MainMenu1: TMainMenu;
    Contents1: TMenuItem;
    Previous1: TMenuItem;
    Next1: TMenuItem;
    Search1: TMenuItem;
    Panel1: TPanel;
    procedure Contents1Click(Sender: TObject);
    procedure Previous1Click(Sender: TObject);
    procedure Next1Click(Sender: TObject);
    procedure Search1Click(Sender: TObject);
    procedure WebBrowser1CommandStateChange(Sender: TObject;
      Command: Integer; Enable: WordBool);
    procedure WebBrowser1TitleChange(Sender: TObject;
      const Text: WideString);
  private
    { Déclarations privées }
    file0:string;
    initOK:boolean;
    HelpInit:boolean;
  public
    { Déclarations publiques }
    procedure Init(st:string);
    property isOK:boolean read InitOK;
  end;

var
  Gbrowse: TGbrowse;

implementation

{$R *.dfm}

uses HelpSearch1;

procedure TGbrowse.Init(st: string);
begin
  file0:=st;
  webBrowser1.Navigate(file0);
  initOK:=true;
end;

procedure TGbrowse.Contents1Click(Sender: TObject);
begin
  webBrowser1.Navigate(file0);
end;

procedure TGbrowse.Previous1Click(Sender: TObject);
begin
  webBrowser1.GoBack;
end;

procedure TGbrowse.Next1Click(Sender: TObject);
begin
  webBrowser1.GoForward;
end;

procedure TGbrowse.Search1Click(Sender: TObject);
var
  st:string;
begin
  if not HelpInit
    then HelpSearch.init(changeFileExt(file0,'.wli'));
  HelpInit:=true;

  st:=HelpSearch.execution;
  if st<>'' then webBrowser1.Navigate(extractFilePath(file0)+st+'.html');
end;

procedure TGbrowse.WebBrowser1CommandStateChange(Sender: TObject; Command: Integer; Enable: WordBool);
begin
 case Command of
    CSC_NAVIGATEBACK:    Previous1.Enabled := Enable;
    CSC_NAVIGATEFORWARD: Next1.Enabled := Enable;
    CSC_UPDATECOMMANDS:  begin end;
  end;
end;

procedure TGbrowse.WebBrowser1TitleChange(Sender: TObject;
  const Text: WideString);
var
  st,st1:string;
  f:TfileStream;
  k1,k2:integer;
  n,code:integer;
begin
  st:=webBrowser1.LocationURL;

  if copy(st,1,5)='file:' then
  begin
    delete(st,1,8);

    while pos('%',st)>0 do
    begin
      k1:=pos('%',st);
      st1:='$'+copy(st,k1+1,2);
      val(st1,n,code);
      delete(st,k1,3);
      insert(chr(n),st,k1);
    end;

    setLength(st1,300);
    fillchar(st1[1],length(st1),0);

    try
    f:=TfileStream.Create(st,fmOpenRead);
    f.Read(st1[1],length(st1));
    finally
    f.Free;
    end;

    k1:=pos('<title>',st1);
    k2:=pos('</title>',st1);

    st:=copy(st1,k1+7,k2-k1-7);
  end
  else st:=webBrowser1.LocationName;

  panel1.Caption:=st;
end;

end.
