unit stmBackGnd1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses windows,classes,graphics,forms,controls,menus,stdCtrls,
     editcont,ComCtrls,

     util1,Gdos,DdosFich,Dgraphic,
     Dpalette,Ncdef2,

     stmDef,stmObj,
     varconf1,stmPlot1,FMemo1,
     debug0,
     stmError,stmPg;

type
  TbackGround=class(TPlot)
           private
              BKcolor:integer;
           public
              constructor create;override;
              destructor destroy;override;

              class function STMClassName:AnsiString;override;

              procedure display; override;


              procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
                override;



              function withInside:boolean;override;
            end;


procedure proTbackGround_create(stName:AnsiString;var pu:typeUO);pascal;
procedure proTbackGround_create_1(var pu:typeUO);pascal;


implementation

constructor TbackGround.create;
begin
  inherited;

  BKcolor:=clGray;
end;

destructor TbackGround.destroy;
begin
  inherited;
end;


class function TbackGround.STMClassName:AnsiString;
begin
  STMClassName:='BackGround';
end;


procedure TbackGround.display;
var
  x1,y1,x2,y2:integer;
begin
  getWindowG(x1,y1,x2,y2);

  with canvasGlb do
  begin
    pen.Style:=psSolid;
    pen.Color:=BKcolor;
    brush.style:=bsSolid;
    brush.color:=BKcolor;
    rectangle(x1,y1,x2,y2);
  end;
end;


procedure TbackGround.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited buildInfo(conf,lecture,tout);

  conf.SetVarConf('BKcolor',BKcolor,sizeof(BKcolor));
end;

function TbackGround.withInside: boolean;
begin
  result:=true;
end;


{************************* Méthodes STM de TbackGround ***************************}

procedure proTbackGround_create(stName:AnsiString;var pu:typeUO);
begin
  createPgObject(stname,pu,TbackGround);
end;

procedure proTbackGround_create_1(var pu:typeUO);
begin
  proTbackGround_create('',pu);
end;



Initialization
AffDebug('Initialization stmBackGnd1',0);
  registerObject(TbackGround,data);

end.

