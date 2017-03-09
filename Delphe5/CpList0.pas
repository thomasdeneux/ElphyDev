unit CpList0;

interface

uses classes,
     util1, listG, stmObj;

type
  TCPlist= class
             listCp, listL: Tlist;

             constructor create;
             destructor destroy;
             procedure clear;

             procedure add(n:integer; uo:typeUO);
             procedure remove(n:integer; uo:typeUO);
             procedure setUO(oldN,NewN:integer; uo:typeUO);

             procedure sendMessage(n:integer;UOmsg: integer; source: typeUO);
             function FindLimits(n:integer;UOmsg: integer; var Amin, Amax: float): boolean;

           end;

implementation

{ TCPlist }

type
  TCPrec= record
            cp: integer;
            UOlist: TUOlist;
          end;
  PCPRec= ^TCPrec;


constructor TCPlist.create;
begin
  listCp:= Tlist.create;
  listL:=  Tlist.create;
end;

destructor TCPlist.destroy;
begin
  clear;
  listCp.Free;
  listL.Free;
end;

procedure TCPlist.clear;
var
  i:integer;
begin
  with listL do
  for i:=0 to Count-1 do
    TUOlist(items[i]).Free;

  listCP.Clear;
  listL.clear;
end;

procedure TCPlist.add(n: integer; uo: typeUO);
var
  k:integer;
  uoList:TUOlist;
begin
  k:= listCP.indexOf(pointer(n));
  if k<0 then
  begin
    listCP.Add(pointer(n));
    uoList:= TUOlist.create;
    k:=listL.Add(uoList);
  end;

  uoList:=listL[k];
  uoList.add(uo);
end;

procedure TCPlist.remove(n: integer; uo: typeUO);
var
  k:integer;
  uoList:TUOlist;
begin
  k:= listCP.indexOf(pointer(n));
  if k>=0 then
  begin
    uoList:=listL[k];
    uoList.Remove(uo);
    if uolist.count=0 then
    begin
      uoList.free;
      listCP.delete(k);
      listL.Delete(k);
    end;
  end;

end;


procedure TCPlist.sendMessage(n, UOmsg: integer; source: typeUO);
var
  i,k:integer;
  uoList:TUOlist;
begin
  k:= listCP.indexOf(pointer(n));
  if k>=0 then
  with TUOlist(listL[k]) do
  begin
    for i:=0 to count-1 do
      items[i].processmessage(UOmsg,source,nil);
  end;
end;

function TCPlist.FindLimits(n, UOmsg: integer; var Amin, Amax: float):boolean;
var
  i,k:integer;
  uoList:TUOlist;
begin
  result:=false;
  k:= listCP.indexOf(pointer(n));
  if k>=0 then
  with TUOlist(listL[k]) do
  begin
    for i:=0 to count-1 do
      if items[i].FindLimits(UOmsg,Amin,Amax) then
      begin
        result:=true;
        exit;
      end;

  end;

end;




procedure TCPlist.setUO(oldN,NewN: integer; uo: typeUO);
begin
  if oldN=newN then exit;

  if oldN<>0 then remove(oldN,uo);
  if NewN<>0 then add(newN,uo);
end;

end.
