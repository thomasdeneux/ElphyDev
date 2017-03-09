unit VSgraph0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Dgraphic,
     stmDef,stmObj,stmObv0,
     syspal32,
     stmPg,stmVS0,debug0;


type
  TVSgraph=class(TVisualObject)

             onPaint:Tpg2Event;

             constructor create;override;
             class function STMClassName:AnsiString;override;

             procedure afficheS;override;
             procedure afficheC;override;
        end;

procedure proTVSgraph_create(var pu:typeUO);pascal;
procedure proTVSgraph_onPaint(w:integer;var pu:typeUO);pascal;
function fonctionTVSgraph_onPaint(n:integer;var pu:typeUO):integer;pascal;


implementation

{ TVSgraph }


constructor TVSgraph.create;
begin
  inherited;

end;

class function TVSgraph.STMClassName: AnsiString;
begin
  result:='VSgraph';
end;


procedure TVSgraph.afficheC;
begin
  VSpaintOnScreen:=false;
  with OnPaint do
  if valid then pg.executerProcedure(ad);
end;

procedure TVSgraph.afficheS;
begin
  VSpaintOnScreen:=true;;
  with OnPaint do
  if valid then pg.executerProcedure(ad);
end;


procedure proTVSgraph_create(var pu:typeUO);
begin
  createPgObject('',pu,TVSgraph);
end;

procedure proTVSgraph_onPaint(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TVSgraph(pu) do OnPaint.setad(w);
end;

function fonctionTVSgraph_onPaint(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TVSgraph(pu) do result:=OnPaint.ad;
end;

Initialization
AffDebug('Initialization VSgraph0',0);

registerObject(TVSgraph,obvis);


end.
