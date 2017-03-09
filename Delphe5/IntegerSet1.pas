unit IntegerSet1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes, util1;

type
  TintegerSet=class(Tlist)
              private
                function getIntegerItem(i:integer):integer;
              public
                property IntegerItem[i:integer]:integer read getIntegerItem;default;
                procedure Add(n:integer);
                procedure remove(n:integer);
                function isElement(n:integer):boolean;
                function isEmpty:boolean;
              end;




implementation

{ TintegerSet }

procedure TintegerSet.Add(n: integer);
begin
  if indexof(pointer(n))<0 then inherited add(pointer(n));
end;

function TintegerSet.getIntegerItem(i: integer): integer;
begin
  result:=intG(items[i]);
end;

function TintegerSet.isElement(n: integer): boolean;
begin
  result:=indexof(pointer(n))>=0;
end;

function TintegerSet.isEmpty: boolean;
begin
  result:= (count=0);
end;

procedure TintegerSet.remove(n: integer);
var
  k:integer;
begin
  k:=indexof(pointer(n));
  if k>=0 then delete(k);
end;

end.
