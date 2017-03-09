unit DBmain1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, DBTables;

type
  TForm1 = class(TForm)
    Table1: TTable;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
