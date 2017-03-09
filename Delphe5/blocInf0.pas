unit BlocInf0;

Interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,util1,Gdos;

type
  TblocInfo=class
              tailleBuf:Integer;
              buf:PtabOctet;
              ad:Integer;
              constructor create(taille:integer);
              destructor destroy;override;

              procedure read(var f:file);overload;
              procedure read(f:TfileStream);overload;

              procedure write(var f:file);overload;
              procedure write(f:TfileStream);overload;


              function getInfo(var x;nb,dep:integer):boolean;
              function setInfo(var x;nb,dep:integer):boolean;

              function readInfo(var x;nb:integer):boolean;
              function writeInfo(var x;nb:integer):boolean;
              procedure resetInfo;

              function copy:TblocInfo;
              procedure clear;
            end;

implementation

{*********************** Méthodes de TblocInfo ******************************}

constructor TblocInfo.create(taille:integer);
  begin
    if (taille>0) and (taille<maxavail) then
      begin
        getmem(buf,taille);
        fillchar(buf^,taille,0);
        tailleBuf:=taille;
      end;
  end;

destructor TblocInfo.destroy;
  begin
    if tailleBuf<>0 then freemem(buf,tailleBuf);
  end;

procedure TblocInfo.read(var f:file);
var
  res:integer;
begin
  if tailleBuf>0 then blockread(f,buf^,tailleBuf,res);
end;

procedure TblocInfo.read(f:TfileStream);
begin
  if tailleBuf>0 then f.Read(buf^,tailleBuf);
end;

procedure TblocInfo.write(var f:file);
var
  res:integer;
begin
  if tailleBuf>0 then blockwrite(f,buf^,tailleBuf,res);
end;

procedure TblocInfo.write(f:TfileStream);
begin
  if tailleBuf>0 then f.write(buf^,tailleBuf);
end;


function TblocInfo.getInfo(var x;nb,dep:integer):boolean;
  begin
    if (buf=nil) or (dep<0) or (tailleBuf<dep+nb) then
      begin
        fillchar(x,nb,0);
        getInfo:=false;
        exit;
      end;

    move(buf^[dep],x,nb);
    getInfo:=true;
  end;


function TblocInfo.setInfo(var x;nb,dep:integer):boolean;
  begin
    if (buf=nil) or (dep<0) or (tailleBuf<dep+nb)
      then setInfo:=false
      else
        begin
          move(x,buf^[dep],nb);
          setInfo:=true;
        end;
  end;

function TblocInfo.readInfo(var x;nb:integer):boolean;
  begin
    readInfo:=getInfo(x,nb,ad);
    inc(ad,nb);
  end;

function TblocInfo.writeInfo(var x;nb:integer):boolean;
  begin
    writeInfo:=setInfo(x,nb,ad);
    inc(ad,nb);
  end;

procedure TblocInfo.resetInfo;
  begin
    ad:=0;
  end;

function TblocInfo.copy:TblocInfo;
var
  p:TblocInfo;
begin
  p:=TblocInfo.create(tailleBuf);
  move(buf^,p.buf^,tailleBuf);
  result:=p;
end;

procedure TblocInfo.clear;
begin
  fillchar(buf^,tailleBuf,0);
  ad:=0;
end;

end.
