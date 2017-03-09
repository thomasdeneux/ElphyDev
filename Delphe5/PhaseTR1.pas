unit PhaseTR1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Gdos,Dgraphic,editcont,
     stmDef,stmObj,stmMvtX1,defForm,
     stmobv0,getPhasT,varconf1,debug0,
     stmPg;


type
  TphaseTrans=  class(TonOff)
                PhaseSpeed:single; {vitesse de phase en degrés par seconde}
                phase0:single;

                constructor create;override;
                class function STMClassName:AnsiString;override;

                procedure InitMvt;   override;
                procedure calculeMvt;override;

                function DialogForm:TclassGenForm;override;
                procedure installDialog(var form:Tgenform;var newF:boolean);
                            override;
                procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
                function getInfo:AnsiString;override;

                end;

procedure proTphasetranslation_create(var pu:typeUO);pascal;
procedure proTphasetranslation_create_1(name:AnsiString;var pu:typeUO);pascal;

procedure proTPhasetranslation_speed(ww:float;var pu:typeUO);pascal;
function fonctionTphasetranslation_speed(var pu:typeUO):float;pascal;

procedure proTPhasetranslation_phase0(ww:float;var pu:typeUO);pascal;
function fonctionTphasetranslation_phase0(var pu:typeUO):float;pascal;


implementation

{*********************   Méthodes de TphaseTrans  ************************}


constructor TphaseTrans.create;
  begin
    inherited create;
    PhaseSpeed:=360;
  end;

class function TphaseTrans.STMClassName:AnsiString;
  begin
    STMClassName:='PhaseTranslation';
  end;

procedure TphaseTrans.InitMvt;
begin
  inherited;
  obvis.prepareS;
end;

procedure TphaseTrans.calculeMvt;
  begin
    obvis.setPhase(phase0+PhaseSpeed*timeS*Xframe);
  end;

function TphaseTrans.DialogForm:TclassGenForm;
begin
  DialogForm:=TgetPhaseTrans;
end;


procedure TphaseTrans.installDialog(var form:Tgenform;var newF:boolean);
  begin
    inherited;

    with TgetPhaseTrans(form) do
    begin
      enSpeed.setVar(PhaseSpeed,T_single);
      enPhase0.setVar(phase0,T_single);
    end;
  end;

procedure TphaseTrans.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;
  with conf do
  begin
    setvarConf('Vpal',PhaseSpeed,sizeof(PhaseSpeed));
    setvarConf('Phase0',Phase0,sizeof(Phase0));
  end;
end;


procedure proTphasetranslation_create(var pu:typeUO);
begin
  createPgObject('',pu,TphaseTrans);
end;

procedure proTphasetranslation_create_1(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TphaseTrans);
end;

procedure proTPhasetranslation_speed(ww:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tphasetrans(pu).PhaseSpeed:=ww;
  end;

function fonctionTphasetranslation_speed(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    fonctionTphasetranslation_speed:=Tphasetrans(pu).PhaseSpeed;
  end;

procedure proTPhasetranslation_phase0(ww:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    Tphasetrans(pu).Phase0:=ww;
  end;

function fonctionTphasetranslation_phase0(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=Tphasetrans(pu).Phase0;
  end;


function TphaseTrans.getInfo: AnsiString;
begin
  result:=inherited getInfo+CRLF+
         'speed='+Estr(phaseSpeed,3)+crlf+
         'phase0='+Estr(phase0,3);
end;

Initialization
AffDebug('Initialization PhaseTR1',0);
registerObject(TphaseTrans,stim);

end.
