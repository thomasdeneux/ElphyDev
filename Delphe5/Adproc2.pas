unit adproc2;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1;

type
  TTabAdresse=class
                   adr:PtabPointer1;
                   maxAdr:smallInt;
                   nbAdr:smallInt;
                   procedure init(nb:smallInt;var err:Integer);
                   destructor destroy;override;

                   procedure empile(ad:pointer);
              end;


IMPLEMENTATION

procedure TTabAdresse.init(nb:smallInt;var err:Integer);
  begin
    adr:=nil;
    if maxavail<sizeof(pointer)*nb+1000 then
      begin
        err:=99;
        exit;
      end;
    getmem(adr,sizeof(pointer)*nb);
    nbAdr:=0;
    maxAdr:=nb;
    err:=0;
  end;

destructor TTabAdresse.destroy;
begin
  if adr<>nil then freemem(adr,sizeof(pointer)*maxAdr);
  inherited;
end;

procedure TTabAdresse.empile(ad:pointer);
  begin
    if nbAdr>maxAdr then runError(249);
    inc(nbAdr);
    adr^[nbAdr]:=ad;
  end;


end.
