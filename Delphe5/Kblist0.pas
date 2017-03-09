unit Kblist0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,stmDef,Ncdef2,stmError,debug0;

type
  TKBrecord=record
              deg:typeDegre;
              key:word;
            end;
  PKBrecord=^TKBrecord;

  TKBlist=class(Tlist)
            procedure store(w:word;deg1:typeDegre);
            procedure clear;
          end;

var
  KBlist:TKBlist;

procedure proGetKBmark(num:integer;var code:integer;var x,y,dx,dy,theta:float);pascal;
function fonctionKBmarkCount:integer;pascal;

implementation

var
  E_KBmark:integer;

procedure TKBlist.store(w:word;deg1:typeDegre);
var
  m:PKBrecord;
begin
  new(m);
  m^.deg:=deg1;
  m^.key:=w;
  add(m);
end;

procedure TKBlist.clear;
var
  i:integer;
begin
  for i:=0 to count-1 do dispose(PKBrecord(items[i]));
  inherited clear;
end;

procedure proGetKBmark(num:integer;var code:integer;var x,y,dx,dy,theta:float);
begin
  controleParam(num,1,KBlist.count,E_KBmark);
  with PKBrecord(KBlist.items[num-1])^ do
  begin
    code:=key;
    x:=deg.x;
    y:=deg.y;
    dx:=deg.dx;
    dy:=deg.dy;
    theta:=deg.theta;
  end;
end;

function fonctionKBmarkCount:integer;
begin
   fonctionKBmarkCount:=KBlist.count;
end;

Initialization
AffDebug('Initialization Kblist0',0);
KBlist:=TKBlist.create;

installError(E_KBmark,'GetKBmark: Invalid mark number');

end.
