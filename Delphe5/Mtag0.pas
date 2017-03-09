unit Mtag0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,
     util1,Dgraphic,dtf0;

type
  TMtag=record
          date:integer;
          code:byte;
        end;

  TMtagArray=object
               nbmax,nb:integer;
               t:array[1..1] of TMtag;
               procedure init(max:integer);
               function size:integer;
               procedure add(dd,cc:integer);
               procedure reset;
             end;
  PMTagArray=^TMtagArray;

type
  TdataMTag=class(typeDataB)
              pm:PMTagArray;
              constructor create(p:PmTagArray);

              function getI(i:longint):longint;virtual;
              function getE(i:longint):float;virtual;
              function getAtt(i:longint):integer;
            end;


function AllocMtagArray(N:integer):PMtagArray;

implementation

{******************** Méthodes de TMTagArray ***********************************}

function AllocMtagArray(N:integer):PMtagArray;
var
  sz:integer;
begin
  sz:=8+sizeof(TMtag)*N;
  getmem(result,sz);
  result^.init(N);
end;


procedure TMtagArray.init(max:integer);
begin
  nbmax:=max;
  nb:=0;
  fillchar(t,sizeof(TMtag)*nbmax,0);
end;

function TMtagArray.size:integer;
begin
  result:=8+sizeof(TMtag)*nbmax;
end;

procedure TMtagArray.add(dd,cc:integer);
begin
  if nb<nbmax then
    begin
      inc(nb);
      t[nb].date:=dd;
      t[nb].code:=cc;
    end;
end;

procedure TMtagArray.Reset;
begin
  nb:=0;
  fillchar(t,sizeof(TMtag)*nbmax,0);
end;


{******************** Méthodes de TdataMTag ***********************************}

constructor TdataMTag.create(p:PmTagArray);
var
  max:integer;
begin
  pm:=p;
  if assigned(p)
    then max:=pm^.nb
    else max:=0;

  inherited create(1,max);
end;

function TdataMTag.getI(i:longint):longint;
begin
  if assigned(pm)
    then getI:=pm^.t[i].date
    else getI:=0;
end;


function TdataMTag.getE(i:longint):float;
begin
  if assigned(pm)
    then getE:=convx(pm^.t[i].date)
    else getE:=0;
end;

function TdataMTag.getAtt(i:longint):integer;
begin
  if assigned(pm)
    then getAtt:=pm^.t[i].code
    else getAtt:=0;
end;



end.
