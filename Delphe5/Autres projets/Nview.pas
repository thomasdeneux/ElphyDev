unit NView;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Label1: TLabel;
    Button7: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure RadioButton5Click(Sender: TObject);
    procedure RadioButton6Click(Sender: TObject);
    procedure RadioButton7Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
    procedure RadioButton9Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
Form1: TForm1;
Procedure NViewLibSetCustomLang(pProgress,pError, pLoad, pErrLoad, pWarning : PChar); Stdcall; external 'NViewLib.dll';
function NViewLibSetLanguage(Lang: PChar): bool; Stdcall; external 'NViewLib.dll';
function NViewLibLoad(FileName : PChar; ShowProgress: BooLean):hbitmap; Stdcall; external 'NViewLib.dll';
function NViewLibSaveAsJPG(Quality:Integer; FileName: PChar):bool; Stdcall; external 'NViewLib.dll';
function Load_JPG(FileName : PChar; ShowProgress: BooLean):hbitmap; Stdcall; external 'NViewLib.dll';
function Load_GIF(FileName : PChar; ShowProgress: BooLean):hbitmap; Stdcall; external 'NViewLib.dll';

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
Image1.update;
Image1.Picture.Bitmap.Handle:= NViewLibLoad('fig.jpg',true);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Image1.Picture.Bitmap.Handle:= NViewLibLoad('fig.gif',true);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
if not NViewLibSaveAsJPG(80, 'junk.jpg') then
begin
Image1.picture.savetofile('~temp.bmp');
Image1.Picture.Bitmap.Handle:= NViewLibLoad('~temp.bmp',false);
NViewLibSaveAsJPG(80, 'junk.jpg');
DeleteFile('~temp.bmp');
Label1.Caption := 'Saved but no delish!:-|';
end
else
Label1.Caption := 'Saved :-)';

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
Image1.Picture.Bitmap.Handle:= NViewLibLoad('cat.bmp',false);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
Image1.Picture.Bitmap.Handle:= NViewLibLoad('cat.tga',true);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
Image1.Picture.Bitmap.Handle:= NViewLibLoad('cat.pcx',false);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
Image1.Picture.Bitmap.Handle:= NViewLibLoad('cat.pc0',false);
end;

procedure TForm1.RadioButton1Click(Sender: TObject);
begin
NViewLibSetLanguage(PChar('Engilsh'));
end;

procedure TForm1.RadioButton2Click(Sender: TObject);
begin
NViewLibSetLanguage(PChar('German'));
end;

procedure TForm1.RadioButton3Click(Sender: TObject);
begin
NViewLibSetLanguage(PChar('Dutch'));
end;

procedure TForm1.RadioButton4Click(Sender: TObject);
begin
NViewLibSetLanguage(PChar('portuguese'));
end;

procedure TForm1.RadioButton5Click(Sender: TObject);
begin
NViewLibSetLanguage(PChar('Spanish'));
end;

procedure TForm1.RadioButton6Click(Sender: TObject);
begin
NViewLibSetLanguage(PChar('Japanese'));
end;

procedure TForm1.RadioButton7Click(Sender: TObject);
begin
NViewLibSetLanguage(PChar('custom'));
NViewLibSetCustomLang(PChar('Yall! Progressing'), PChar('It ain''t no good!'), PChar('It''s fixing to show'), PChar('This file ain''t no dilish! -->'), PChar('Reserved for future update'))
end;

procedure TForm1.RadioButton8Click(Sender: TObject);
begin
NViewLibSetLanguage(PChar('Italian'));
end;

procedure TForm1.RadioButton9Click(Sender: TObject);
begin
NViewLibSetLanguage(PChar('French'));
end;

end.
