unit DirDlg1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, FileCtrl;

type
  TForm2 = class(TForm)
    Button2: TButton;
    Bcancel: TButton;
    DirectoryListBox1: TDirectoryListBox;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

end.
