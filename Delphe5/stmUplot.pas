unit stmUplot;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

{ TuserPlot est un objet STM poss�dant une propri�t� OnPaint. OnPaint re�oit par
  programme l'adresse d'une proc�dure de dessin PG1.

  Quand OnPaint est appel�e, le canvas et la fen�tre multigraph sont ont �t�
  s�lectionn�es. OnPaint ne doit jamais appeler setWindow ou setWindowEx.
  Si un deuxi�me multigraph existait, il y aurait probl�me. Il faudrait transmettre
  � OnPaint, l'adresse de l'objet Multigraph concern�.

  TuserPlot poss�de son propre contexte d'affichage (varPg1) afin de ne pas interf�rer
  avec le programme Pg1.
  SwapContext(true) est appel� par Multigraph avant Display.
  SwapContext(false) est appel� par Multigraph apr�s Display.

  Comme le programme utilise les m�thodes multiGraph, on ne peut pas afficher en
  dehors de Multigraph. La m�thode Show est surcharg�e.
}

uses Dgraphic,stmDef,stmObj,stmPlot1,stmPg,debug0;

type
  TuserPlot=class(Tplot)
              varPg1:TvarPg1;
              onPaint:Tpg2Event;

              x1,y1,x2,y2:integer;

              constructor create;override;
              destructor destroy;override;
              class function stmClassName:AnsiString;override;

              procedure swapContext(numW:integer;var varPg:TvarPg1;ContextPg:boolean);override;
              procedure Display;override;
              procedure show(sender:Tobject);override;
            end;

procedure proTuserPlot_create(name:AnsiString;var pu:typeUO);pascal;
procedure proTuserPlot_create_1(var pu:typeUO);pascal;
procedure proTuserPlot_onPaint(w:integer;var pu:typeUO);pascal;
function fonctionTuserPlot_onPaint(n:integer;var pu:typeUO):integer;pascal;


implementation

constructor TuserPlot.create;
begin
  inherited create;
  varPg1:=TvarPg1.create;
end;

destructor TuserPlot.destroy;
begin
  varPg1.free;
  inherited Destroy;
end;

class function TuserPlot.stmClassName:AnsiString;
begin
  result:='UserPlot';
end;

procedure TuserPlot.swapContext(numW:integer;var varPg:TvarPg1;ContextPg:boolean);
var
  v:TvarPg1;
begin
  if ContextPg then
    begin
      with varPg1 do
      begin
        winEx:=true;
        win0:=numW;
        getWindowG(x1winEx,y1winEx,x2winEx,y2winEx);
        canvasPg1:=varPg.canvasPg1;
        cleft:=varPg.cleft;
        ctop:=varPg.ctop;
        cWidth:=varPg.cWidth;
        cHeight:=varPg.cHeight;
      end;
      getWindowG(x1,y1,x2,y2);
    end
  else setWindow(x1,y1,x2,y2);

  v:=varPg;
  varPg:=varPg1;
  varPg1:=v;

end;

procedure TuserPlot.Display;
begin
  with OnPaint do
  if valid then pg.executerProcedure(ad);
end;

procedure TuserPlot.show(sender:Tobject);
begin
end;

{************************ M�thodes STM de TuserPlot *************************}

procedure proTuserPlot_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TuserPlot);
end;

procedure proTuserPlot_create_1(var pu:typeUO);
begin
  proTuserPlot_create('',pu);
end;

procedure proTuserPlot_onPaint(w:integer;var pu:typeUO);
begin
  verifierObjet(pu);
  with TuserPlot(pu) do OnPaint.setad(w);
end;

function fonctionTuserPlot_onPaint(n:integer;var pu:typeUO):integer;
begin
  verifierObjet(pu);
  with TuserPlot(pu) do result:=OnPaint.ad;
end;

Initialization
AffDebug('Initialization Stmuplot',0);

registerObject(TuserPlot,data);

end.
