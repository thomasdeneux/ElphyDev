unit stmIntTable;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,stmObj,stmPG,
     varconf1, ncdef2;

type
  TIntegerArray3 = array of array of array of integer;

  TTable3   =   class(typeUO)

                  Att:TIntegerArray3;

                  class function STMClassName:AnsiString;override;
                  function getInfo:AnsiString;override;

                  procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                  procedure CompleteLoadInfo;override;
                  procedure CompleteSaveInfo;override;

                  function loadData(f:Tstream):boolean; override;
                  procedure saveData(f:Tstream); override;

                end;


procedure proTTable3_create(var pu:typeUO);pascal;

procedure proTTable3_value(i,j,k:integer;w:integer;var pu:typeUO);pascal;
function fonctionTTable3_value(i,j,k:integer;var pu:typeUO):integer;pascal;

function fonctionTTable3_length(var pu:typeUO):integer;pascal;
function fonctionTTable3_length_1(i:integer;var pu:typeUO):integer;pascal;
function fonctionTTable3_length_2(i,j:integer;var pu:typeUO):integer;pascal;

procedure proTTable3_Clear(var pu:typeUO);pascal;

implementation

{ TTable3 }

class function TTable3.STMClassName: AnsiString;
begin
  result:='Table3';
end;

procedure TTable3.BuildInfo(var conf: TblocConf; lecture, tout: boolean);
begin
  inherited;

end;

procedure TTable3.CompleteLoadInfo;
begin
  inherited;

end;

procedure TTable3.CompleteSaveInfo;
begin
  inherited;

end;

function TTable3.getInfo: AnsiString;
begin

end;

function TTable3.loadData(f: Tstream): boolean;
begin

end;

procedure TTable3.saveData(f: Tstream);
begin
  inherited;

end;

{***************************************** Méthodes stm *************************************************}

procedure CreateTable(var pu:typeUO);
begin
  if not assigned(pu) then createPgObject('',pu,TTable3);
end;

procedure proTTable3_create(var pu:typeUO);
begin
  createPgObject('',pu,TTable3);
end;

procedure proTTable3_value(i,j,k:integer;w:integer;var pu:typeUO);
begin
  createTable(pu);
  with Ttable3(pu) do
  begin
    if length(att)<i+1 then setlength(att,i+1);
    if length(att[i])<j+1 then setlength(att[i],j+1);
    if length(att[i,j])<k+1 then setlength(att[i,j],k+1);

    att[i,j,k]:=w;
  end;
end;

function fonctionTTable3_value(i,j,k:integer;var pu:typeUO):integer;
begin
  createTable(pu);
  with Ttable3(pu) do
  begin
    if (length(att)>i) and (length(att[i])>j) and (length(att[i,j])>k)
      then result:=att[i,j,k]
      else sortieErreur('Ttable3.get : index out of range');
  end;
end;

function fonctionTTable3_length(var pu:typeUO):integer;
begin
  createTable(pu);
  with Ttable3(pu) do
    result:=length(att);
end;

function fonctionTTable3_length_1(i:integer;var pu:typeUO):integer;
begin
  createTable(pu);
  with Ttable3(pu) do
  begin
    if length(att)<i+1 then sortieErreur('Ttable3.length : index out of range');
    result:=length(att[i]);
  end;
end;

function fonctionTTable3_length_2(i,j:integer;var pu:typeUO):integer;pascal;
begin
  createTable(pu);
  with Ttable3(pu) do
  begin
    if length(att)<i+1 then sortieErreur('Ttable3.length : index out of range');
    if length(att[i])<j+1 then sortieErreur('Ttable3.length : index out of range');

    result:=length(att[i,j]);
  end;
end;

procedure proTTable3_Clear(var pu:typeUO);
begin
  createTable(pu);
  setlength(Ttable3(pu).Att,0);
end;

end.
