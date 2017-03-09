procedure DoNumPlus(id:integer;msg:integer;user:integer;dw1,dw2:integer);stdCall;
var
  i,j:integer;
  x:boolean;
begin
  epI2:=getCountDigi;

  if flagReset and (epI2>=trigdate+nbAp) and Ftrig then
    begin
      Ftrig:=false;
      oldSyncNum:=true;
    end;

  while not Ftrig and (epI1<=epI2) do
  begin
    x:=tab1^[epI1 mod max1] and 2<>0;
    if not oldSyncNum and x then
      begin
        TrigDate:=epI1;
        Ftrig:=true;
        FlagReset:=false;
        for j:=epI1-nbAv to epI1 do
          tab2^[(j-trigdate+nbAv) mod max2]:=tab1^[j mod max1];
        writeln(fdeb,'date=',trigdate);
      end;
    oldSyncNum:=x;
    inc(epI1);
  end;

  if Ftrig then
    while (epI1<=trigdate+nbAp) and (epI1<=epI2) do
    begin
      tab2^[(epI1-trigDate+nbAv) mod max2]:=tab1^[epI1 mod max1];
      inc(epI1);
    end;

  GI1:=epI1;

  epI1:=epI2;


  setEvent(EventBuf);
end;

