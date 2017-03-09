unit stmMatBuffer1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,IPPdefs;


{ TmatBuffer implémente une matrice rudimentaire analogue à Tmatrix .
  Elle ne doit être utilisée que dans les calculs internes.
}


type
  TmatBuffer=class
                tb:pointer;
                tpNum:typetypeG;
                istart,iend,jstart,jend:integer;
                tpSize:integer;
                Icount,Jcount:integer;
                constructor create(tp:typetypeG;i1,i2,j1,j2:integer);
                destructor destroy;override;

                function getP(i,j:integer):pointer;
                function stepIPP:integer;
                function sizeIPP:IPPIsize;overload;
                function sizeIPP(n1,n2:integer):IPPIsize;overload;
                function rectIPP(x1,y1,w1,h1:integer):IPPIrect;
              end;

implementation

{ TmatBuffer }

constructor TmatBuffer.create(tp: typetypeG; i1, i2, j1, j2: integer);
begin
  tpNum:=tp;
  istart:=i1;
  iend:=i2;
  jstart:=j1;
  jend:=j2;
  Icount:=i2-i1+1;
  Jcount:=j2-j1+1;
  tpSize:=tailleTypeG[tpNum];
  getmem(tb,tpSize*Icount*Jcount);
  fillchar(tb^,tpSize*Icount*Jcount,0);
end;

destructor TmatBuffer.destroy;
begin
  freemem(tb);
  inherited;
end;

function TmatBuffer.getP(i, j:integer): pointer;
begin
  result:=@PtabOctet(tb)^[(Jcount*(i-Istart)+j-Jstart)*tpSize];
end;

function TmatBuffer.rectIPP(x1, y1, w1, h1: integer): IPPIrect;
begin
  with result do
  begin
    x:=y1;
    y:=x1;
    width:=h1;
    height:=w1;
  end;
end;

function TmatBuffer.sizeIPP(n1, n2: integer): IPPIsize;
begin
   with result do
  begin
    width:=n2;
    height:=n1;
  end;
end;

function TmatBuffer.sizeIPP: IPPIsize;
begin
  result.width:=Jcount;
  result.height:=Icount;
end;

function TmatBuffer.stepIPP: integer;
begin
  result:=Jcount*tpSize;
end;

end.
