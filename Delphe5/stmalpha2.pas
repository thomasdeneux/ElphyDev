unit stmAlpha2;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}


uses classes,dialogs,controls,
     util1,Gdos,Dgraphic,
     stmdef, stmObj,stmData0,stmVec1,varconf1,debug0,
     stmExe11,
     stmError,Ncdef2,stmPg;




type
  TalphaDetect=class(Tdata0)
               private
                 nbptDerivee:integer;
                 nbLis:integer;
                 dxSource:double;


                 i0:integer;
                 Fini:boolean;
                 lastUp:boolean;


                 sourceB,FalphaB,DalphaB:Tvector;
                 Vx0B,VAmpB,VtauB,VlambdaB:Tvector;


                 function getV(i:integer):double;
                 function diff(i:integer):float;
                 procedure Reconstruire(i1,i2:integer);


               public
                 source,Falpha,Dalpha:Tvector;


                 DtLis:double;


                 seuilH,seuilB,DtDerivee,b_exc,b_inh,a_max,a_min:double;
                 Vx0,VAmp,Vtau,Vlambda:Tvector;


                 x0,Amp,slope,minSlope,t,b,a:double;
                 IstartA,IendA,i_back:integer;
                 diffMode:integer;
                 backStep:double;

                 constructor create;override;
                 destructor destroy;override;
                 class function stmClassName:AnsiString;override;
                 procedure FreeRef;override;

                 procedure createForm;override;


                 procedure BuildInfo(var conf:TblocConf;lecture,tout:boolean);
                   override;


                 procedure RetablirReferences(list:Tlist);
                   override;
                 procedure processMessage(id:integer;source1:typeUO;p:pointer);
                   override;


                 procedure initVectors(source1,Falpha1,Dalpha1:Tvector);
                 procedure initVectorsAux(vx1,vamp1,Vtau1,Vlambda1:Tvector);



                 procedure init;
                 procedure next;
                 procedure execute;


               end;


procedure proTalphaDetect_create(name:AnsiString;var pu:typeUO);pascal;

procedure proTAlphaDetect_installVectors
            (var source1,Falpha1,Dalpha1:Tvector;var pu:typeUO);pascal;


procedure proTAlphaDetect_installVectorsAux
            (var vx1,vamp1,Vtau1,Vlambda1:Tvector;var pu:typeUO);pascal;



procedure proTAlphaDetect_UpperThreshold(x:float;var pu:typeUO);pascal;
function fonctionTAlphaDetect_UpperThreshold(var pu:typeUO):float;pascal;


procedure proTAlphaDetect_LowerThreshold(x:float;var pu:typeUO);pascal;
function fonctionTAlphaDetect_LowerThreshold(var pu:typeUO):float;pascal;


procedure proTAlphaDetect_DtDiff(x:float;var pu:typeUO);pascal;
function fonctionTAlphaDetect_DtDiff(var pu:typeUO):float;pascal;


function fonctionTAlphaDetect_tau(var pu:typeUO):float;pascal;
function fonctionTAlphaDetect_Amp(var pu:typeUO):float;pascal;
function fonctionTAlphaDetect_Lambda(var pu:typeUO):float;pascal;
function fonctionTAlphaDetect_x0(var pu:typeUO):float;pascal;


procedure proTAlphaDetect_init(var pu:typeUO);pascal;
procedure proTAlphaDetect_next(var pu:typeUO);pascal;
procedure proTAlphaDetect_execute(var pu:typeUO);pascal;


function fonctionTAlphaDetect_Terminated(var pu:typeUO):boolean;pascal;


procedure proTAlphaDetect_XstartA(x:float;var pu:typeUO);pascal;
function fonctionTAlphaDetect_XstartA(var pu:typeUO):float;pascal;


procedure proTAlphaDetect_XendA(x:float;var pu:typeUO);pascal;
function fonctionTAlphaDetect_XendA(var pu:typeUO):float;pascal;


procedure proTAlphaDetect_DtSmooth(x:float;var pu:typeUO);pascal;
function fonctionTAlphaDetect_DtSmooth(var pu:typeUO):float;pascal;


procedure proTAlphaDetect_b_exc(x:float;var pu:typeUO);     pascal;
function fonctionTAlphaDetect_b_exc(var pu:typeUO):float;   pascal;
procedure proTAlphaDetect_b_inh(x:float;var pu:typeUO);     pascal;
function fonctionTAlphaDetect_b_inh(var pu:typeUO):float;   pascal;
procedure proTAlphaDetect_a_max(x:float;var pu:typeUO);     pascal;
function fonctionTAlphaDetect_a_max(var pu:typeUO):float;   pascal;
procedure proTAlphaDetect_a_min(x:float;var pu:typeUO);     pascal;
function fonctionTAlphaDetect_a_min(var pu:typeUO):float;   pascal;
procedure proTAlphaDetect_backStep(x:float;var pu:typeUO);  pascal;
function fonctionTAlphaDetect_backStep(var pu:typeUO):float;pascal;



implementation


var
  E_vector:integer;
  E_source:integer;


constructor TalphaDetect.create;
begin
  inherited create;


  diffMode:=1;
end;


destructor TalphaDetect.destroy;
begin
  derefObjet(typeUO(source));
  derefObjet(typeUO(Falpha));
  derefObjet(typeUO(Dalpha));


  derefObjet(typeUO(Vx0));
  derefObjet(typeUO(VAmp));
  derefObjet(typeUO(Vtau));
  derefObjet(typeUO(Vlambda));


  inherited destroy;
end;

procedure TalphaDetect.FreeRef;
begin
  derefObjet(typeUO(source));
  derefObjet(typeUO(Falpha));
  derefObjet(typeUO(Dalpha));


  derefObjet(typeUO(Vx0));
  derefObjet(typeUO(VAmp));
  derefObjet(typeUO(Vtau));
  derefObjet(typeUO(Vlambda));
end;

class function TalphaDetect.stmClassName:AnsiString;
begin
  result:='AlphaDetect';
end;



procedure TalphaDetect.createForm;
begin


end;


procedure TalphaDetect.BuildInfo(var conf:TblocConf;lecture,tout:boolean);
begin
  inherited;


   if lecture then
    begin
      conf.setvarConf('source',sourceB,sizeof(sourceB));
      conf.setvarConf('Falpha',FalphaB,sizeof(FalphaB));
      conf.setvarConf('Dalpha',DalphaB,sizeof(DalphaB));


      conf.setvarConf('Vx0',Vx0B,sizeof(Vx0B));
      conf.setvarConf('Vamp',VampB,sizeof(VampB));
      conf.setvarConf('Vtau',VtauB,sizeof(VtauB));
      conf.setvarConf('Vlambda',VlambdaB,sizeof(VlambdaB));


    end
  else
    begin
      conf.setvarConf('source',source,sizeof(source));
      conf.setvarConf('Falpha',Falpha,sizeof(Falpha));
      conf.setvarConf('Dalpha',Dalpha,sizeof(Dalpha));


      conf.setvarConf('Vx0',Vx0,sizeof(Vx0));
      conf.setvarConf('Vamp',Vamp,sizeof(Vamp));
      conf.setvarConf('Vtau',Vtau,sizeof(Vtau));
      conf.setvarConf('Vlambda',Vlambda,sizeof(Vlambda));


    end;


end;


procedure TalphaDetect.RetablirReferences(list:Tlist);
var
  i,j,page:integer;
  lu:Tlist;
  ppu:typeUO;
  p:pointer;
begin
  for i:=0 to list.count-1 do
    begin
     p:=typeUO(list.items[i]).myAd;
     if p=sourceB then
       begin
         source:=list.items[i];
         refObjet(source);
       end;
     if p=FalphaB then
       begin
         Falpha:=list.items[i];
         refObjet(Falpha);
       end;
     if p=DalphaB then
       begin
         Dalpha:=list.items[i];
         refObjet(Dalpha);
       end;


     if p=Vx0B then
       begin
         Vx0:=list.items[i];
         refObjet(Vx0);
       end;
     if p=VampB then
       begin
         Vamp:=list.items[i];
         refObjet(Vamp);
       end;
     if p=VtauB then
       begin
         Vtau:=list.items[i];
         refObjet(Vtau);
       end;
     if p=VlambdaB then
       begin
         Vlambda:=list.items[i];
         refObjet(Vlambda);
       end;


    end;
end;


procedure TalphaDetect.processMessage(id:integer;source1:typeUO;p:pointer);
begin
  inherited processMessage(id,source1,p);
  case id of
    UOmsg_destroy:
      begin
        if source=source1 then
          begin
            source:=nil;
            derefObjet(source1);
          end;


        if Falpha=source1 then
          begin
            Falpha:=nil;
            derefObjet(source1);
          end;


        if Dalpha=source1 then
          begin
            Dalpha:=nil;
            derefObjet(source1);
          end;


        if Vx0=source1 then
          begin
            Vx0:=nil;
            derefObjet(source1);
          end;


        if Vamp=source1 then
          begin
            Vamp:=nil;
            derefObjet(source1);
          end;


        if Vtau=source1 then
          begin
            Vtau:=nil;
            derefObjet(source1);
          end;


        if Vlambda=source1 then
          begin
            Vlambda:=nil;
            derefObjet(source1);
          end;


      end;
  end;
end;



procedure TalphaDetect.initVectors(source1,Falpha1,Dalpha1:Tvector);
begin
  derefObjet(typeUO(source));
  derefObjet(typeUO(Falpha));
  derefObjet(typeUO(Dalpha));


  source:=source1;
  Falpha:=Falpha1;
  Dalpha:=Dalpha1;


  refObjet(typeUO(source));
  refObjet(typeUO(Falpha));
  refObjet(typeUO(Dalpha));


  IstartA:=source.Istart;
  IendA:=source.Iend;
end;


procedure TalphaDetect.initVectorsAux(vx1,vamp1,Vtau1,Vlambda1:Tvector);
begin
  derefObjet(typeUO(vx0));
  derefObjet(typeUO(Vamp));
  derefObjet(typeUO(Vtau));
  derefObjet(typeUO(Vlambda));


  vx0:=vx1;
  vamp:=vamp1;
  vtau:=vtau1;
  vlambda:=vlambda1;


  refObjet(typeUO(vx0));
  refObjet(typeUO(Vamp));
  refObjet(typeUO(Vtau));
  refObjet(typeUO(Vlambda));
end;


procedure TalphaDetect.init;
begin
  i0:=IstartA;

  dxSource:=source.dxu;
  i_back:=roundL(backStep/dxSource);

  nbptDerivee:=roundL(DtDerivee/DxSOurce);
  nbLis:=roundL(DtLis/DxSOurce);


  Falpha.dxu:=dxSource;
  Falpha.initTemp1(source.Istart,source.Iend,G_single);


  Falpha.fill(source.data.getE(source.Istart));
  {proLissage(source,Falpha,NbLis,source.Xstart,source.Xend);}


  Dalpha.dxu:=dxSource;
  Dalpha.initTemp1(source.Istart,source.Iend,G_single);


  if assigned(Vx0) then Vx0.initEventList(g_longint,source.dxu);
  if assigned(Vamp) then Vamp.initList(g_single);
  if assigned(Vtau) then Vtau.initList(g_single);


  fini:=false;
  if i0>=IendA then fini:=true;
  lastUp:=false;
end;


function TalphaDetect.getV(i:integer):double;
begin
  result:=source.data.getE(i);
end;



function TalphaDetect.diff(i:integer):float;
begin
  case diffMode of
    1: diff:=(getV(i+nbptDerivee)-getV(i))/DtDerivee;
    2: diff:=source.data.fastSlope(i,i+nbPtDerivee-1);
  end;
end;


{
function TalphaDetect.diff(i:integer):float;
begin
  result:=source.data.fastSlope(i,i+nbPtDerivee-1);
end;
}



procedure TalphaDetect.Reconstruire(i1,i2:integer);
var
  ti,ifin:integer;
  tf,tfmax:double;
  c0,c1:double;


begin
  {amp:=source.data.getE(i2)-source.data.getE(i1)+
       Falpha.data.getE(i1)-Falpha.data.getE(i2);}


  amp:=getV(i2)-Falpha.data.getE(i2);
  slope:=diff(i2)-Dalpha.data.getE(i2);
   
  t:=(i2-i1)*Dxsource;
  x0:=source.convx(i1);


  if (amp>0) then b:=b_exc
  else b:=b_inh;


   a:=b/t-slope/amp;


   if (a > a_max) then b:=t*(a_max + slope/amp);
   if (a < a_min) then b:=t*(a_min + slope/amp);


   a:=b/t-slope/amp;

   if a<=0 then
     begin
       messageCentral('a<=0');
       exit;
     end;

   c0:=amp*exp(a*t)/exp(b*ln(t));


  if assigned(Vx0) then Vx0.addToList(x0);
  if assigned(Vamp) then Vamp.addToList(getV(i2)-getV(i1));
  if assigned(Vtau) then Vtau.addToList(1/a);
  if assigned(Vlambda) then Vlambda.addToList(b);


  tf:=Dxsource;
  ti:=i1;


  tfmax:=10/a;
  ifin:=source.Iend-nbptDerivee;


  repeat
    c1:=c0*exp(b*ln(tf))*exp(-a*tf);
    Falpha.data.setE(ti,Falpha.data.getE(ti)+c1);
    Dalpha.data.setE(ti,Dalpha.data.getE(ti)+c1*(b/tf-a));
    inc(ti);
    tf:=tf+dxSource;
  until (tf>tfmax) or (ti>Ifin);
end;


{ Version initiale }
procedure TalphaDetect.next;
var
  i_deb,i_fin,iminslope:integer;
  ok:boolean;
begin
  if i0>=IendA then exit;


  repeat
    if (diff(i0)>seuilH+Dalpha.data.getE(i0)) and
       (diff(i0+1)>seuilH+Dalpha.data.getE(i0+1)) and
       (diff(i0+2)>Dalpha.data.getE(i0+2)) and
       (getV(i0)>Falpha.data.getE(i0)) then
         begin
           i_deb:=i0;
           i0:=i0+3;
           repeat
              inc(i0);
              slope:=diff(i0)-Dalpha.data.getE(i0);
              if (slope < minslope) then
              begin
                 minslope:=slope;
                 iminslope:=i0;
              end;
           until (i0>IendA) or (diff(i0)<=Dalpha.data.getE(i0)) or ((iminslope>i_deb) and (slope<minslope));
           if i0<=iendA then
             begin
                if (slope <= 0)
                   then i_fin:=i0-i_back-1
                else i_fin:=i0-1;

               reconstruire(i_deb,i_fin);
               ok:=true;
             end;
         end
    else


if (diff(i0)<seuilB+Dalpha.data.getE(i0)) and
       (diff(i0+1)<seuilB+Dalpha.data.getE(i0+1)) and
       (diff(i0+2)<Dalpha.data.getE(i0+2)) and
       (getV(i0)<Falpha.data.getE(i0)) then
         begin
           i_deb:=i0;
           i0:=i0+3;
           repeat
              inc(i0);
              slope:=diff(i0)-Dalpha.data.getE(i0);
              if (slope > minslope) then
              begin
                 minslope:=slope;
                 iminslope:=i0;
              end;
           until (i0>IendA) or (diff(i0)>=Dalpha.data.getE(i0)) or ((iminslope>i_deb) and (slope<minslope));
           if i0<=iendA then
             begin
                if (slope >= 0)
                   then i_fin:=i0-i_back-1
                else i_fin:=i0-1;
                
               reconstruire(i_deb,i_fin);
               ok:=true;
             end;
         end;
    inc(i0);
  until (i0>=iendA) or ok;


  fini:= (i0>=iendA);


end;


{ Version Fred: le seuil vers le haut est un seuil absolu
                le seuil vers le bas s'applique à la différence entre la pente
                actuelle et la pente de la fonction reconstruite.


procedure TalphaDetect.next;
var
  i_deb,i_fin:integer;
  ok:boolean;
begin
  if i0>=IendA then exit;


  repeat
    if (diff(i0)>seuilH) and
       (diff(i0+1)>Dalpha.data.getE(i0+1)) and
       (diff(i0+2)>Dalpha.data.getE(i0+2))  then
         begin
           i_deb:=i0;
           repeat
             inc(i0)
           until (i0>IendA) or (diff(i0)<=0);
           if i0<=iendA then
             begin
               i_fin:=i0;
               reconstruire(i_deb,i_fin);
               ok:=true;
             end;
           lastUp:=true;
         end
    else


    if lastUp and
       (diff(i0)<seuilB+Dalpha.data.getE(i0)) and
       (diff(i0+1)<Dalpha.data.getE(i0+1)) and
       (diff(i0+2)<Dalpha.data.getE(i0+2))
       OR
       not lastUp and
       (diff(i0)<seuilB) and
       (diff(i0+1)<Dalpha.data.getE(i0+1)) and
       (diff(i0+2)<Dalpha.data.getE(i0+2))


       then
         begin
           i_deb:=i0;
           repeat
             inc(i0)
           until (i0>IendA) or (diff(i0)>=0);
           if i0<=iendA then
             begin
               i_fin:=i0;
               reconstruire(i_deb,i_fin);
               ok:=true;
             end;
           lastUp:=false;
         end;


    inc(i0);
  until (i0>=iendA) or ok;


  fini:= (i0>=iendA);


end;
}


procedure TalphaDetect.execute;
begin
  init;
  repeat
    next;
    if testShiftEscape then
     if messageDlg('Stop program? ',mtConfirmation,[mbYes,mbNo],0)=mrYes
            then  finExeU^:=true;


  until fini or finExeU^;
end;


procedure proTalphaDetect_create(name:AnsiString;var pu:typeUO);
begin
  createPgObject(name,pu,TalphaDetect);
end;


procedure proTAlphaDetect_installVectors(var source1,Falpha1,Dalpha1:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);
  verifierObjet(typeUO(source1));
  verifierObjet(typeUO(Falpha1));
  verifierObjet(typeUO(Dalpha1));


  if Falpha1.inf.readOnly or not Falpha1.inf.temp then sortieErreur(E_vector);
  if Dalpha1.inf.readOnly or not Dalpha1.inf.temp then sortieErreur(E_vector);


  with TAlphaDetect(pu) do initVectors(source1,Falpha1,Dalpha1);


end;


procedure proTAlphaDetect_installVectorsAux
            (var vx1,vamp1,Vtau1,Vlambda1:Tvector;var pu:typeUO);
begin
  verifierObjet(pu);


  if assigned(vx1) then
    if vx1.inf.readOnly or not vx1.inf.temp then sortieErreur(E_vector);
  if assigned(vamp1) then
    if vamp1.inf.readOnly or not vamp1.inf.temp then sortieErreur(E_vector);
  if assigned(vtau1) then
    if vtau1.inf.readOnly or not vtau1.inf.temp then sortieErreur(E_vector);
  if assigned(vlambda1) then
    if vlambda1.inf.readOnly or not vlambda1.inf.temp then sortieErreur(E_vector);


  with TAlphaDetect(pu) do initVectorsAux(vx1,vamp1,Vtau1,Vlambda1);
end;



procedure proTAlphaDetect_UpperThreshold(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TAlphaDetect(pu).seuilH:=x;
  end;


function fonctionTAlphaDetect_UpperThreshold(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TAlphaDetect(pu).seuilH;
  end;


procedure proTAlphaDetect_LowerThreshold(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TAlphaDetect(pu).seuilB:=x;
  end;


function fonctionTAlphaDetect_LowerThreshold(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TAlphaDetect(pu).seuilB;
  end;



procedure proTAlphaDetect_DtDiff(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TAlphaDetect(pu).Dtderivee:=x;
  end;


function fonctionTAlphaDetect_DtDiff(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TAlphaDetect(pu).DtDerivee;
  end;


procedure proTAlphaDetect_DtSmooth(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TAlphaDetect(pu).DtLis:=x;
  end;


function fonctionTAlphaDetect_DtSmooth(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TAlphaDetect(pu).DtLis;
  end;




function fonctionTAlphaDetect_tau(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    {result:=TAlphaDetect(pu).tau;}
  end;


function fonctionTAlphaDetect_Amp(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TAlphaDetect(pu).amp;
  end;


function fonctionTAlphaDetect_Lambda(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    {result:=TAlphaDetect(pu).Lambda;}
  end;


function fonctionTAlphaDetect_x0(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TAlphaDetect(pu).x0;
  end;


procedure proTAlphaDetect_init(var pu:typeUO);
begin
  verifierObjet(pu);
  with TAlphaDetect(pu) do init;
end;


procedure proTAlphaDetect_next(var pu:typeUO);
begin
  verifierObjet(pu);
  with TAlphaDetect(pu) do next;
end;


procedure proTAlphaDetect_execute(var pu:typeUO);
begin
  verifierObjet(pu);
  with TAlphaDetect(pu) do execute;
end;



function fonctionTAlphaDetect_Terminated(var pu:typeUO):boolean;
  begin
    verifierObjet(pu);
    result:=TAlphaDetect(pu).fini;
  end;


procedure proTAlphaDetect_XstartA(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with TAlphaDetect(pu) do
    begin
      if assigned(source)
        then IstartA:=source.invconvx(x)
        else sortieErreur(E_source);
    end;
  end;


function fonctionTAlphaDetect_XstartA(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    with TAlphaDetect(pu) do
      if assigned(source)
        then result:=source.convx(IstartA)
        else sortieErreur(E_source);
  end;


procedure proTAlphaDetect_XendA(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    with TAlphaDetect(pu) do
    begin
      if assigned(source)
        then IendA:=source.invconvx(x)
        else sortieErreur(E_source);
    end;
  end;


function fonctionTAlphaDetect_XendA(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    with TAlphaDetect(pu) do
      if assigned(source)
        then result:=source.convx(IendA)
        else sortieErreur(E_source);
  end;



{****************************************************************************}

procedure proTAlphaDetect_b_exc(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TAlphaDetect(pu).b_exc:=x;
  end;


function fonctionTAlphaDetect_b_exc(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TAlphaDetect(pu).b_exc;
  end;

procedure proTAlphaDetect_b_inh(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TAlphaDetect(pu).b_inh:=x;
  end;


function fonctionTAlphaDetect_b_inh(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TAlphaDetect(pu).b_inh;
  end;


procedure proTAlphaDetect_a_max(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TAlphaDetect(pu).a_max:=x;
  end;


function fonctionTAlphaDetect_a_max(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TAlphaDetect(pu).a_max;
  end;


procedure proTAlphaDetect_a_min(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TAlphaDetect(pu).a_min:=x;
  end;


function fonctionTAlphaDetect_a_min(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TAlphaDetect(pu).a_min;
  end;


procedure proTAlphaDetect_backStep(x:float;var pu:typeUO);
  begin
    verifierObjet(pu);
    TAlphaDetect(pu).backStep:=x;
  end;


function fonctionTAlphaDetect_backStep(var pu:typeUO):float;
  begin
    verifierObjet(pu);
    result:=TAlphaDetect(pu).backStep;
  end;



Initialization
AffDebug('Initialization stmalpha2',0);


installError(E_vector,'TAlphaDetect: invalid vector');
installError(E_source,'TAlphaDetect: source vector must be installed');

registerObject(TalphaDetect,data);

end.

