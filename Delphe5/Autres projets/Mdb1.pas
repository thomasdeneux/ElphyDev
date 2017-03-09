unit Mdb1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,
  ZClasses, ZDbcIntfs, ZCompatibility,
  //Only those drivers will be supported for which you load the proper unit, see below
  ZDbcMySql, ZDbcInterbase6, ZDbcPostgreSql, ZDbcDBLib, StdCtrls, ExtCtrls;


type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
    Connection: IZConnection;
    Statement: IZStatement;
    ResultSet: IZResultSet;
    LastRowNr: Integer;//This is to detect row nr change
    InsertState: Boolean;

    procedure ConnectDB;
    procedure closeDB;
    procedure sendCommand(stCom:string);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.ConnectDB;
var
  Url: string;
const
  stProtocol='postgresql-8';
  stHost='localhost';
  NumPort=5432;
  stBase='postgres';
  stUser='postgres';
  stPassword='elphy51';
begin
  if NumPort > 0
    then Url := Format('zdbc:%s://%s:%d/%s?UID=%s;PWD=%s',
               [stProtocol, stHost,NumPort, stbase, stUser, stPassword])

    else Url := Format('zdbc:%s://%s/%s?UID=%s;PWD=%s',
               [stProtocol, stHost, stbase, stUser, stPassword]);

  try
  Connection := DriverManager.GetConnectionWithParams(Url, nil);
  Connection.SetAutoCommit(True);
  Connection.SetTransactionIsolation(tiReadCommitted);
  Connection.Open;
  memo1.Lines.Add('Connected');
  except
  memo1.Lines.Add('Connection failed');
  end;
end;

procedure TForm1.closeDB;
begin
  if Assigned(Connection) then
    if not Connection.IsClosed then
      Connection.Close;
end;

procedure TForm1.sendCommand(stCom:string);
var

  I: Integer;
  Value: string;
  stres:string;

  colCount:integer;
begin
  Statement := Connection.CreateStatement;
//This is not neccesseary if you do not want to modify the data
  Statement.SetResultSetConcurrency(rcUpdatable);
  ResultSet := Statement.ExecuteQuery(stCom);

  //Was any resultset returned?
  if Assigned(ResultSet) then
  begin
    ColCount := ResultSet.GetMetadata.GetColumnCount;

    stRes:='';
    for I := 1 to ResultSet.GetMetadata.GetColumnCount do
      stRes := stRes+ ResultSet.GetMetadata.GetColumnName(I)+'  ';
    memo1.Lines.Add(stRes);

  //Make a cycle for each record in the resultset
    while ResultSet.Next do
    begin
      stRes:='';
      for I := 1 to ColCount do
      begin
//read out the proper value for the column
        case ResultSet.GetMetadata.GetColumnType(I) of
          stBoolean: if ResultSet.GetBoolean(I) then Value := 'True' else Value := 'False';
          stByte: Value := IntToStr(ResultSet.GetByte(I));
          stShort: Value := IntToStr(ResultSet.GetShort(I));
          stInteger: Value := IntToStr(ResultSet.GetInt(I));
          stLong: Value := IntToStr(ResultSet.GetLong(I));
          stFloat: Value := FloatToStr(ResultSet.GetFloat(I));
          stDouble: Value := FloatToStr(ResultSet.GetDouble(I));
          stBigDecimal: Value := FloatToStr(ResultSet.GetBigDecimal(I));
          stBytes, stBinaryStream: Value := ResultSet.GetBlob(I).GetString;
          stDate: Value := DateToStr(ResultSet.GetDate(I));
          stTime: Value := TimeToStr(ResultSet.GetTime(I));
          stTimeStamp: Value := DateTimeToStr(ResultSet.GetTimeStamp(I));
          stAsciiStream, stUnicodeStream: Value := ResultSet.GetBlob(I).GetString;
        else
          Value := ResultSet.GetString(I);
        end;
        if ResultSet.IsNull(I) then
          Value := '';

        stRes:=stRes+ Value+';';
      end;
      memo1.Lines.Add(stRes);
    end;
  end;
end;




procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  closeDB;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  connectDB;

  sendCommand('SELECT * FROM Users;');
end;

end.
