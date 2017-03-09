unit DacSys;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  stmdef,stmObj,

  acqDef2
  ;



function fonctionTsystem_Nil(var pu:typeUO):typeUO;pascal;
function fonctionTsystem_Acquisition(var pu:typeUO):typeUO;pascal;
function fonctionTsystem_Stimulator(var pu:typeUO):typeUO;pascal;

function fonctionTsystem_PG0(var pu:typeUO):typeUO;pascal;


implementation


{************************** Méthodes de Tsystem *****************************}

function fonctionTsystem_Nil(var pu:typeUO):typeUO;
const
  p:pointer=nil;
begin
  result:=@p;
end;

function fonctionTsystem_Acquisition(var pu:typeUO):typeUO;
begin
  result:=@DacAcqInfo;

end;

function fonctionTsystem_Stimulator(var pu:typeUO):typeUO;
begin
  result:=@DacStimInfo;
end;

function fonctionTsystem_PG0(var pu:typeUO):typeUO;
begin
  result:=@DacPg;
end;



end.
