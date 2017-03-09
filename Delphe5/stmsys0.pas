unit stmSys0;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes,
     util1,Dgraphic,varconf1, debug0,
     stmdef, stmObj,
     doubleExt;

type
  TinfoSysVS= record                                      // 17 avril: on remplace les float par des doubles
                tfreq: double;
                extraTime:integer;
                BKlum:single;
                TrackChannel:array[1..2] of integer;
                TrackSeuilP:array[1..2] of double;
                TrackSeuilM:array[1..2] of double;

                TrackPoint:array[1..2] of smallInt;

                TrackColor:array[1..2] of Integer;
                DotSize:array[1..2] of smallInt;
                TrackShift:array[1..2] of smallInt;

                TrackDelay:double;

                //trackObvis:pointer;                      // 9 juin 2016 : pointer remplacé par integer (pb 64 bits)
                trackObvis: integer;                       // trackObvis était utilisée uniquement pour rejouer semi-manuel ( obsolète)
                                                           // on neutralise trackObvis
                TrackMode:array[1..2] of byte;

                RF1: typedegre;
                ACleft, ACright: typedegre;
              end;

  TinfoSysVS_=
              record
                tfreq:float_;
                extraTime:integer;
                BKlum:single;
                TrackChannel:array[1..2] of integer;
                TrackSeuilP:array[1..2] of float_;
                TrackSeuilM:array[1..2] of float_;

                TrackPoint:array[1..2] of smallInt;

                TrackColor:array[1..2] of Integer;
                DotSize:array[1..2] of smallInt;
                TrackShift:array[1..2] of smallInt;

                TrackDelay:float_;

                //trackObvis:pointer;
                trackObvis: integer;
                TrackMode:array[1..2] of byte;

                RF1: typedegre;
                ACleft, ACright: typedegre;
              end;


  TsystemVS=
          class(typeUO)
            BlockVersion: byte;

            inf:TinfoSysVS;
            inf_: ^TinfoSysVS_;

            inf1:TinfoSysVS;  {Sert pour push/pop}
            FLoad64: boolean;

            constructor create;override;
            class function STMClassName:AnsiString;override;
            procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);override;
            procedure CompleteLoadInfo;override;
            procedure RetablirReferences(list:Tlist);override;
            function getInfo:AnsiString;override;

            procedure GlobalToInf(var inf:TinfoSysVS);
            procedure InfToGlobal(var inf:TinfoSysVS);
            procedure push;
            procedure pop;
          end;

{TsystemVS permet d'écrire des variables globales sous la forme d'un pseudo objet
dans un fichier Elphy et surtout de relire les valeurs de ces variables sans
modifier les variables elles-mêmes.

Quand on sauve l'objet, les variables globales sont d'abord transférées dans l'objet
mais la réciproque n'est pas vraie }

implementation

uses stmObv0, {$IFDEF DX1}FxCtrlDX11 {$ELSE} FxCtrlDX9  {$ENDIF} ,sysPal32,stmVS0, stmMark0;

constructor TsystemVS.create;
begin
  inherited;
  notPublished:=true;
  BlockVersion:=1;
end;

class function TsystemVS.STMClassName:AnsiString;
begin
  result:='SysVS';
end;

procedure TsystemVS.GlobalToInf(var inf:TinfoSysVS);
var
  i:integer;
begin
  inf.tfreq:=Tfreq;
  inf.extraTime:=extraTime;
  inf.BKlum:=syspal.BKlum;

  for i:=1 to 2 do
  begin
    inf.TrackChannel[i]:=visualStim.FXcontrol.TrackChannel[i];
    inf.TrackSeuilP[i]:=visualStim.FXcontrol.TrackSeuilP[i];
    inf.TrackMode[i]:=visualStim.FXcontrol.TrackMode[i];

    inf.TrackPoint[i]:=visualStim.FXcontrol.TrackPoint[i];
    inf.TrackColor[i]:=visualStim.FXcontrol.TrackColor[i];
    inf.DotSize[i]:=visualStim.FXcontrol.DotSize[i];
    inf.TrackShift[i]:=visualStim.FXcontrol.TrackShift[i];
  end;

  inf.TrackDelay:=visualStim.FXcontrol.TrackDelay;

  //inf.trackObvis:=visualStim.FXcontrol.TrackObvis;

  inf.RF1:=   RFsys[1].deg;
  inf.ACleft:=  ACleft.deg;
  inf.ACright:=  ACright.deg;
end;


procedure TsystemVS.InfToGlobal(var inf:TinfoSysVS);
var
  i:integer;
begin
  if inf.Tfreq>0 then Tfreq:=inf.tfreq;
  extraTime:=inf.extraTime;
  syspal.BKlum:=inf.BKlum;

  for i:=1 to 2 do
  begin
    {
    visualStim.FXcontrol.TrackChannel[i]:=inf.TrackChannel[i];
    visualStim.FXcontrol.TrackSeuilP[i]:=inf.TrackSeuilP[i];
    visualStim.FXcontrol.TrackMode[i]:=inf.TrackMode[i];
    }
    visualStim.FXcontrol.TrackPoint[i]:=inf.TrackPoint[i];
    visualStim.FXcontrol.TrackColor[i]:=inf.TrackColor[i];
    visualStim.FXcontrol.DotSize[i]:=inf.DotSize[i];
    visualStim.FXcontrol.TrackShift[i]:=inf.TrackShift[i];
  end;

  visualStim.FXcontrol.TrackDelay:=inf.TrackDelay;

  //visualStim.FXcontrol.trackObvis:=inf.TrackObvis;

  RFsys[1].deg:=  inf.RF1;
  ACleft.deg:=   inf.ACleft;
  ACright.deg:= inf.ACright;

end;

procedure TsystemVS.push;
begin
  GlobalToInf(inf1);
end;

procedure TsystemVS.pop;
begin
  InfToGlobal(inf1);
end;

procedure TsystemVS.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  if not lecture then GlobalToInf(inf);

  with conf,inf do
  begin
    setvarconf('VER',BlockVersion,sizeof(BlockVersion));
    setVarConf('INFVS2',inf,sizeof(inf));

    if lecture then
    begin
      new(inf_);
      fillchar(inf_^,sizeof(inf_^),0);
      BlockVersion:=0;

      setVarConf('INFVS',inf_^,sizeof(inf_^));
    end
    else BlockVersion:=1;
  end;
end;

procedure TsystemVS.CompleteLoadInfo;
begin
  if BlockVersion=0 then       // S'il s'agit d'un bloc créé avant le 17 avril 2014
  begin                        // Il faut convertir les données
    {$IFNDEF WIN64}
    inf.tfreq:= inf_^.tfreq;
    inf.extraTime:= inf_^.extraTime;
    inf.BKlum:= inf_^.BKlum;
    inf.TrackChannel[1]:= inf_^.TrackChannel[1];
    inf.TrackChannel[2]:= inf_^.TrackChannel[2];

    inf.TrackSeuilP[1]:= inf_^.TrackSeuilP[1];
    inf.TrackSeuilP[2]:= inf_^.TrackSeuilP[2];

    inf.TrackSeuilM[1]:= inf_^.TrackSeuilM[1];
    inf.TrackSeuilM[2]:= inf_^.TrackSeuilM[2];

    inf.TrackPoint[1]:= inf_^.TrackPoint[1];
    inf.TrackPoint[2]:= inf_^.TrackPoint[2];

    inf.TrackColor[1]:= inf_^.TrackColor[1];
    inf.TrackColor[2]:= inf_^.TrackColor[2];

    inf.DotSize[1]:= inf_^.DotSize[1];
    inf.DotSize[2]:= inf_^.DotSize[2];

    inf.TrackShift[1]:= inf_^.TrackShift[1];
    inf.TrackShift[2]:= inf_^.TrackShift[2];

    inf.TrackDelay:= inf_^.TrackDelay;

    //inf.trackObvis:= inf_^.trackObvis;

    inf.TrackMode[1]:= inf_^.TrackMode[1];
    inf.TrackMode[2]:= inf_^.TrackMode[2];

    inf.RF1:= inf_^.RF1;
    inf.ACleft:= inf_^.ACleft;
    inf.ACright:= inf_^.ACright;
    {$ELSE}
    inf.tfreq:= ExtendedToDouble(inf_^.tfreq);
    inf.extraTime:= inf_^.extraTime;
    inf.BKlum:= inf_^.BKlum;
    inf.TrackChannel[1]:= inf_^.TrackChannel[1];
    inf.TrackChannel[2]:= inf_^.TrackChannel[2];

    inf.TrackSeuilP[1]:= ExtendedToDouble(inf_^.TrackSeuilP[1]);
    inf.TrackSeuilP[2]:= ExtendedToDouble(inf_^.TrackSeuilP[2]);

    inf.TrackSeuilM[1]:= ExtendedToDouble(inf_^.TrackSeuilM[1]);
    inf.TrackSeuilM[2]:= ExtendedToDouble(inf_^.TrackSeuilM[2]);

    inf.TrackPoint[1]:= inf_^.TrackPoint[1];
    inf.TrackPoint[2]:= inf_^.TrackPoint[2];

    inf.TrackColor[1]:= inf_^.TrackColor[1];
    inf.TrackColor[2]:= inf_^.TrackColor[2];

    inf.DotSize[1]:= inf_^.DotSize[1];
    inf.DotSize[2]:= inf_^.DotSize[2];

    inf.TrackShift[1]:= inf_^.TrackShift[1];
    inf.TrackShift[2]:= inf_^.TrackShift[2];

    inf.TrackDelay:= ExtendedToDouble(inf_^.TrackDelay);

    //inf.trackObvis:= inf_^.trackObvis;

    inf.TrackMode[1]:= inf_^.TrackMode[1];
    inf.TrackMode[2]:= inf_^.TrackMode[2];

    inf.RF1:= inf_^.RF1;
    inf.ACleft:= inf_^.ACleft;
    inf.ACright:= inf_^.ACright;
    {$ENDIF}



    dispose(inf_);
    inf_:=nil;
  end;


end;

procedure TsystemVS.RetablirReferences(list:Tlist);
var
  i:integer;
begin
  (*
  for i:=0 to list.count-1 do
    if typeUO(list.items[i]).myAd=inf.trackObvis then
      begin
        inf.TrackObvis:=TypeUO(list.items[i]);
        {refObjet(obvis);}
        exit;
      end;
  inf.Trackobvis:=nil;
  *)
end;


function TsystemVS.getInfo:AnsiString;
begin
  with inf do
  result:=inherited getInfo+CRLF+
          'TrackingPoint[1]='+Istr(TrackPoint[1])+CRLF+
          'TrackingPoint[2]='+Istr(TrackPoint[2])+CRLF+
          'TrackShift[1]=   '+Istr(TrackShift[1])+CRLF+
          'TrackShift[2]=   '+Istr(TrackShift[2])+CRLF+

          'ExtraTime=       '+Istr(extraTime) +CRLF+
          'Frame=       '+Estr(tfreq,3)+' µs' +CRLF+

          'RF1   x =      '+Estr(RF1.x,3)+CRLF+
          '      y =      '+Estr(RF1.y,3)+CRLF+
          '      dx =     '+Estr(RF1.dx,3)+CRLF+
          '      dy =     '+Estr(RF1.dy,3)+CRLF+
          '      theta =  '+Estr(RF1.theta,3)+CRLF+

          'ACleft  x =    '+Estr(ACleft.x,3)+CRLF+
          '        y =    '+Estr(ACleft.y,3)+CRLF+
          'ACright x =    '+Estr(ACright.x,3)+CRLF+
          '        y =    '+Estr(ACright.y,3)+CRLF+
          'BKlum =        '+Estr(BKlum,3)
          ;
end;



Initialization
AffDebug('Initialization stmSys0',0);

if testUnic then registerObject(TsystemVS,sys);

end.
