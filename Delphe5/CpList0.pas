unit CpList0;

interface

uses classes,
     util1, listG, stmObj;

type
  TCPlist= class
             CouplingON: boolean;
             listCp: Tlist;   // liste des coeff
             listL: Tlist;    // liste des listes d'objets
             listLast: Tlist; // liste des derniers objets modifiés pour chaque coeff

             constructor create;
             destructor destroy;override;
             procedure clear;

             procedure add(n:integer; uo:typeUO);
             procedure remove(n:integer; uo:typeUO);
             procedure setUO(oldN,NewN:integer; uo:typeUO);

             procedure sendMessage(n:integer;UOmsg: integer; source: typeUO);
             function FindLimits(n:integer;UOmsg: integer; var Amin, Amax: float): boolean;

             procedure suspend;
             procedure UpdateCp(UOmsg: integer) ;
           end;



implementation

{ TCPlist }


constructor TCPlist.create;
begin
  CouplingON:= true;
  listCp:= Tlist.create;
  listL:=  Tlist.create;
  listLast:=  Tlist.create;

end;

destructor TCPlist.destroy;
begin
  clear;
  listCp.Free;
  listL.Free;
  ListLast.Free;
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
  listLast.clear;
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
    listLast.Add(nil);
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
      listLast.Delete(k);
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
  if CouplingON then
  begin
    with TUOlist(listL[k]) do
    begin
      for i:=0 to count-1 do
        items[i].processmessage(UOmsg,source,nil);
    end;
  end
  else listLast[k]:=source;
end;

function TCPlist.FindLimits(n, UOmsg: integer; var Amin, Amax: float):boolean;
var
  i,k:integer;
  uoList:TUOlist;
begin
  result:=false;
  if not CouplingON then exit;

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

procedure TCPlist.suspend;
var
  i: integer;
begin
  CouplingON:= false;

  for i:=0 to listLast.Count-1 do listLast[i]:=nil;   // Utile ?
end;

procedure TCPlist.UpdateCp(UOmsg: integer);
var
  i: integer;
begin
  for i:=0 to ListCp.Count-1 do
    if listLast[i]<>nil then
    begin
      sendMessage(intG(listCp[i]), UOmsg, typeUO(listLast[i]));
      listLast[i]:=nil;
    end;  

  CouplingON:=true;
end;

end.
