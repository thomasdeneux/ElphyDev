unit stmGaborSparse1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,math,
     util1,Gdos,dtf0,Dgraphic,Dpalette, debug0,
     stmDef,stmObj,stmobv0,stmRev1,varconf1,Ncdef2,
     stmGaborDense1,stmPG,Gnoise1;

type
  TgaborSparse=class(TgaborNoise)
                 class function STMClassName:AnsiString;override;

                 procedure randSequence;override;

               end;


procedure proTGaborSparse_create(name:AnsiString;var pu:typeUO);pascal;


implementation

{ TgaborSparse }


procedure TgaborSparse.randSequence;
var
  i,j, x1,y1,z1: integer;
  elt:TseqElt;

begin
  Fblank:=false;

  nX := roundI(nbDivX*Expansion/100.0);
  nY := roundI(nbDivY*Expansion/100.0);
  nbGabor:=OrientCount*PeriodCount*LumCount*PhaseCount;

  cycleCount:=nx*ny*nbGabor;
  noise.free;
  noise:=TrevNoise.create(nx,ny,nbGabor,seed);

end;


class function TgaborSparse.STMClassName: AnsiString;
begin
  result:='GaborSparse';
end;


procedure proTGaborSparse_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TGaborSparse);
end;


Initialization
AffDebug('Initialization stmGaborSparse1',0);

registerObject(TGaborSparse,stim);

end.
