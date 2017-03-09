unit stmDataBase1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses sysUtils,DB,DBtables,
     util1,stmdef,stmObj,NcDef2,stmPg;

type
  typeDBfield=(dbf_smallint,dbf_longint,dbf_double,dbf_string);

  TstmField=record
              name:AnsiString;
              tp:typeDBfield;
              size:integer;
            end;
  TstmIndex=record
              name:AnsiString;
              field:AnsiString;
              options: TindexOptions;
            end;

  TstmDataBase=
    class(typeUO)
      table:Ttable;
      base:TdataBase;
      DFields:array of TstmField;
      Dindex: array of TstmIndex;

      constructor create;override;
      destructor destroy;override;
      class function stmClassName:AnsiString;

      procedure OpenLocalBase(st:AnsiString);

      Procedure ClearFieldDefs;
      procedure AddFieldDefinition(tp1:typeDBfield;name1:AnsiString;size1:integer);
      procedure AddIndexDefinition(name1,field1:AnsiString;options1:integer);

      procedure setStringField(name,st:AnsiString);
      function getStringField(name:AnsiString):AnsiString;

      procedure CreateTable(name1:AnsiString);

      procedure Append;
      procedure First;
      procedure Last;
      procedure Next;
      procedure Prior;

      procedure Post;
    end;


procedure proTdataBase_create(stName:AnsiString;var pu:typeUO);pascal;

procedure proTdataBase_OpenLocalBase(st:AnsiString;var pu:typeUO);pascal;

Procedure proTdataBase_ClearFieldDefs(var pu:typeUO);pascal;

procedure proTdataBase_AddFieldDefs(tp1:integer;name1:AnsiString;size1:integer;var pu:typeUO);pascal;
procedure proTdataBase_AddIndexDefs(name1,field1:AnsiString;options:integer;var pu:typeUO);pascal;

procedure proTdataBase_FString(name:AnsiString; st:AnsiString;var pu:typeUO);pascal;
function fonctionTdataBase_FString(name:AnsiString;var pu:typeUO):AnsiString;pascal;

procedure proTdataBase_CreateTable(name1:AnsiString;var pu:typeUO);pascal;

procedure proTdataBase_Append(var pu:typeUO);pascal;
procedure proTdataBase_First(var pu:typeUO);pascal;
procedure proTdataBase_Last(var pu:typeUO);pascal;
procedure proTdataBase_Next(var pu:typeUO);pascal;
procedure proTdataBase_Prior(var pu:typeUO);pascal;

procedure proTDataBase_Post(var pu:typeUO);pascal;


implementation

{ TstmDataBase }

constructor TstmDataBase.create;
begin
  inherited;
  table:=Ttable.Create(formStm);
end;

destructor TstmDataBase.destroy;
begin
  table.free;
end;

class function TstmDataBase.stmClassName: AnsiString;
begin
  result:='TdataBase';
end;

procedure TstmDataBase.OpenLocalBase(st: AnsiString);
begin
  if directoryExists(st)
    then table.DatabaseName:=st
    else SortieErreur('TdataBase.OpenBase : directory not found');
end;


procedure TstmDataBase.AddFieldDefinition(tp1: typeDBfield; name1: AnsiString; size1: integer);
begin
  setLength(Dfields,length(Dfields)+1);
  with Dfields[high(Dfields)] do
  begin
    name:=name1;
    tp:=tp1;
    size:=size1;
  end;
end;

procedure TstmDataBase.AddIndexDefinition(name1,field1:AnsiString;options1:integer);
begin
  setLength(Dindex,length(Dindex)+1);
  with Dindex[high(Dindex)] do
  begin
    name:=name1;
    field:=field1;

    options:=[];
    if options1 and 1<>0 then options:=options+ [ixPrimary];
    if options1 and 2<>0 then options:=options+ [ixUnique];
    if options1 and 4<>0 then options:=options+ [ixDescending];
    if options1 and 8<>0 then options:=options+ [ixCaseInsensitive];
    if options1 and 16<>0 then options:=options+ [ixExpression];
    if options1 and 32<>0 then options:=options+ [ixNonMaintained];
  end;
end;

procedure TstmDataBase.Append;
begin
  table.Append;
end;

procedure TstmDataBase.ClearFieldDefs;
begin
  setLength(Dfields,0);
end;


procedure TstmDataBase.CreateTable(name1: AnsiString);
var
  i:integer;
begin
  with Table do
  begin
    Active := False;
    if DatabaseName='' then sortieErreur('TdataBase.createTable : base not defined');
    TableType := ttParadox;
    TableName := name1;

    FieldDefs.Clear;
    for i:=0 to high(Dfields) do
    begin
      with FieldDefs.AddFieldDef do
      begin
        Name := Dfields[i].name;
        case Dfields[i].tp of
          dbf_smallint:     DataType := ftSmallInt;
          dbf_longint:      DataType := ftinteger;
          dbf_double:       DataType := ftFloat;
          dbf_string:       DataType := ftstring;
        end;
        size:=Dfields[i].size;
      end;
    end;

    IndexDefs.Clear;
    { Décrit ensuite tous les index }
    for i:=0 to high(Dindex) do
    begin
      with IndexDefs.AddIndexDef do
      begin
        Name := Dindex[i].name;
        Fields := Dindex[i].field;

        Options := Dindex[i].options;
      end;
    end;

    CreateTable;
    Active:=true;
  end;
end;



procedure TstmDataBase.setStringField(name, st: AnsiString);
begin
  table.FieldByName(name).AsString:=st;
end;

function TstmDataBase.getStringField(name: AnsiString): AnsiString;
begin
  result:= table.FieldByName(name).AsString;
end;

procedure TstmDataBase.First;
begin
  table.First;
end;

procedure TstmDataBase.Last;
begin
  table.Last;
end;

procedure TstmDataBase.Next;
begin
  table.Next;
end;


procedure TstmDataBase.Prior;
begin
  table.Prior;
end;

procedure TstmDataBase.Post;
begin
  table.Post;
end;



{Méthodes STM }

procedure proTdataBase_create(stName:AnsiString;var pu:typeUO);
begin
  createPgObject(stName,pu,TstmDataBase);
end;

procedure proTdataBase_OpenLocalBase(st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TstmDataBase(pu).OpenLocalBase(st);
end;

Procedure proTdataBase_ClearFieldDefs(var pu:typeUO);
begin
  verifierObjet(pu);
  TstmDataBase(pu).ClearFieldDefs;
end;

procedure proTdataBase_AddFieldDefs(tp1:integer;name1:AnsiString;size1:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TstmDataBase(pu).AddFieldDefinition(typeDBfield(tp1),name1,size1);
end;

procedure proTdataBase_AddIndexDefs(name1,field1:AnsiString;options:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  TstmDataBase(pu).AddIndexDefinition(name1,field1,options);
end;



procedure proTdataBase_FString(name:AnsiString; st:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TstmDataBase(pu).setStringField(name,st);
end;

function fonctionTdataBase_FString(name:AnsiString;var pu:typeUO):AnsiString;
begin
  verifierObjet(pu);
  result:=TstmDataBase(pu).getStringField(name);
end;

procedure proTdataBase_CreateTable(name1:AnsiString;var pu:typeUO);
begin
  verifierObjet(pu);
  TstmDataBase(pu).CreateTable(name1);
end;

procedure proTdataBase_Append(var pu:typeUO);
begin
  verifierObjet(pu);
  TstmDataBase(pu).Append;
end;

procedure proTdataBase_First(var pu:typeUO);
begin
  verifierObjet(pu);
  TstmDataBase(pu).First;
end;

procedure proTdataBase_Last(var pu:typeUO);
begin
  verifierObjet(pu);
  TstmDataBase(pu).Last;
end;

procedure proTdataBase_Next(var pu:typeUO);
begin
  verifierObjet(pu);
  TstmDataBase(pu).Next;
end;

procedure proTdataBase_Prior(var pu:typeUO);
begin
  verifierObjet(pu);
  TstmDataBase(pu).Prior;
end;

procedure proTDataBase_Post(var pu:typeUO);
begin
  verifierObjet(pu);
  TstmDataBase(pu).Post;
end;



Initialization
AffDebug('Initialization stmDataBase1',0);

registerObject(TstmDataBase,data);
end.
