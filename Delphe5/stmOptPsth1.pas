unit stmOptPsth1;

interface

implementation

(*
procedure optimized_Psth_calculus;
var
  Nopt,i,j,l,p,z,lambda,nbspk,lg_listN,Nstimulations,Ndebut:integer;
  N:array[1..5] of integer;
  kbar,cost:array[1..5] of real;
  listN:array[1..40] of integer;
  K,costv:Tmatrix;
  vr,moy,minimum:real;
  bool:boolean;
begin

  optpsth.clear;
  binSize:=0;
  listN[1]:=32768;
  K.create(t_longint,1,listN[1],1,40);
  listN[2]:=round(listN[1]/2);
  listN[3]:=1;
  lg_listN:=3;
  N[1]:=listN[1];
  N[3]:=round(listN[1]/2);
  N[5]:=1;
  case IsoCrossModeFlag of
    1:  Nstimulations:=2*Nstim;
    2..3:  Nstimulations:=Nstim;
  end;
  case IsoCrossModeFlag of
    1..2: Ndebut:=0;
    3: Ndebut:=Nstim;
  end;
  for z:=1 to Nstimulations do
  begin
   for i:=1 to 3000 do
   begin
     K.Kvalue[ceil(i/3000*N[1]/Nstimulations+(z-1)*N[1]/Nstimulations),1]:=
           K.Kvalue[ceil(i/3000*N[1]/Nstimulations+(z-1)*N[1]/Nstimulations),1]+round(psth.V[z+Ndebut,1].Yvalue[i]);
     K.Kvalue[ceil(i/3000*N[3]/Nstimulations+(z-1)*N[3]/Nstimulations),2]:=
           K.Kvalue[ceil(i/3000*N[3]/Nstimulations+(z-1)*N[3]/Nstimulations),2]+round(psth.V[z+Ndebut,1].Yvalue[i]);
   end;
  end;
  nbspk:=round(K.sum(1,N[1],1,1));
  K[1,3]:=nbspk;
  if (nbspk/epcount<10) then
  begin
    spikeflag:=FALSE;
    Nopt:=round(300/20);
    binsize:=20;
    for z:=1 to Nstimulations do
    begin
      for i:=-1000-ceil(3000/Nopt)+1 to -1000 do optPSTH.V[z+Ndebut,1].Yvalue[-1000]:=optPSTH.V[z+Ndebut,1].Yvalue[-1000]+psth.V[z+Ndebut,1].Yvalue[i];
      for i:=-999 to 3000 do
         optPSTH.V[z+Ndebut,1].Yvalue[i]:=optPSTH.V[z+Ndebut,1].Yvalue[i-1]-psth.V[z+Ndebut,1].Yvalue[i-ceil(3000/Nopt)]+psth.V[z+Ndebut,1].Yvalue[i];
      for i:=-1000 to 3000 do optPSTH.V[z+Ndebut,1].Yvalue[i]:=round(optPSTH.V[z+Ndebut,1].Yvalue[i])/epcount/binsize*1000;
    end;
    PsthClean.V[1,1].Yvalue[-3000]:=binSize/500;
    {optPSTH.invalidate;}
  end
  else
  begin
    spikeFlag:=TRUE;
    {messageBox ('nbspk='+Istr(nbspk,0));}
    for p:=0 to 2 do
    begin
      j:=2*p+1;
      kbar[j]:=nbspk/N[j];
      vr:=0;
      for l:=1 to N[j] do
      begin
        vr:=vr+sqr(K.Kvalue[l,p+1]-kbar[j])/N[j];
      end;
      cost[j]:=(2*kbar[j]-vr)*sqr(N[j]);
    end;

    bool:=true;
    while ((N[1]-N[5]>10)and(bool)) do
    begin
      for p:=1 to 2 do
      begin
        j:=2*p;
        N[j]:=floor((N[j-1]+N[j+1])/2);
        i:=1; 
        while ((listN[i]<>0)and(round(listN[i]/N[j])<> listN[i]/N[j])) do i:=i+1;
        if listN[i]=0 then
        begin
          for z:=1 to Nstimulations do
          for l:=1 to 3000 do
            K.Kvalue[ceil(l*N[j]/3000/Nstimulations+(z-1)*N[j]/Nstimulations),i]:=
              round(K.Kvalue[ceil(l*N[j]/3000/Nstimulations+(z-1)*N[j]/Nstimulations),i]+psth.V[z+Ndebut,1].Yvalue[l]);
          
          if (i<>lg_listN+1) then messageBox('fail comptage');
          
          listN[lg_listN+1]:=N[j];
          lg_listN:=i;
          kbar[j]:=nbspk/N[j];
          vr:=0;
          for l:=1 to N[j] do
            vr:=vr+sqr(K.Kvalue[l,i]-kbar[j])/N[j];
             
          cost[j]:=(2*kbar[j]-vr)*sqr(N[j]); 
        end
        else
        begin
           lambda:= round(listN[i]/N[j]);
           kbar[j]:=nbspk/N[j];
           vr:=0;
           for l:=1 to N[j] do
           begin
             K.Kvalue[l,lg_listN+1]:=round(K.sum(lambda*l-lambda+1,lambda*l,i,i));
             vr:=vr+sqr(K.Kvalue[l,lg_listN+1]-kbar[j])/N[j];
           end;
           listN[lg_listN+1]:=N[j];
           lg_listN:=lg_listN+1;
           cost[j]:=(2*kbar[j]-vr)*sqr(N[j]);
        end;
      end;
      if (cost[1]<cost[3])and(cost[1]<cost[2])
        then messageBox('in optPsth, échec cuisant : N trop petit?');
      
      if (cost[1]>cost[2])and(cost[2]<cost[3]) then
      begin
        N[5]:=N[3];
        N[3]:=N[2];
        cost[5]:=cost[3];
        cost[3]:=cost[2];
        kbar[5]:=kbar[3];
        kbar[3]:=kbar[2];
      end
      else
      begin
        if (cost[2]>cost[3])and(cost[3]<cost[4])and(cost[1]>=cost[3]) then
        begin
          N[1]:=N[2];
          N[5]:=N[4];
          cost[1]:=cost[2];
          cost[5]:=cost[4];
          kbar[1]:=kbar[2];
          kbar[5]:=kbar[4];
        end
        else
        begin
          if (cost[3]>cost[4])and(cost[4]<cost[5])and(cost[1]>=cost[4])and(cost[2]>=cost[4]) then
          begin
            N[1]:=N[3];
            N[3]:=N[4];
            cost[1]:=cost[3];
            cost[3]:=cost[4];
            kbar[1]:=kbar[3];
            kbar[3]:=kbar[4];
          end
          else
          begin
            bool:=false;
          end;
        end;
      end;
    end; {  of while }

    if (N[1]-N[5]>Nstimulations) and not bool then
    begin
      {MessageBox('Problème de convergence');
      MessageBox ('nbspk='+Istr(nbspk,0));
      MessageBox ('Nl='+Istr(N[1],0)+'; Nr='+Istr(N[5],0));
      MessageBox ('costl='+Rstr(cost[1])+'; costil='+Rstr(cost[2])+'; costm='+Rstr(cost[3])+'; costir='+Rstr(cost[4])+'; costr='+Rstr(cost[5]));
      InitDialogBox;
      DBgetReal('Choix du bin arbitraire en ms',binSize,10,3);
      ShowDialogBox; }
      Nopt:=round(300/20);
      binsize:=20;     
    end
    else 
    begin
      {costv.create(t_extended,N[5],N[1],1,1);}
      {MessageBox ('Nl='+Istr(N[1],0));
      MessageBox ('Nr='+Istr(N[5],0));}
      {for j:=N[5] to N[1] do
       begin
        for l:=1 to 3000 do
         begin
          K.Kvalue[ceil(l/3000*j),j]:=round(K.Kvalue[ceil(l/3000*j),j]+psth.V[z,1].Yvalue[l]);
        end;
        vr:=0;
        for l:=1 to j do
         begin
          vr:=vr+sqr(K.Kvalue[l,j]-nbspk/j)/j;
        end;
        costv[j,1]:=(2*nbspk/j-vr)*sqr(j); 
      end;
      minimum:=1000000000; 
      for j:=N[5]to N[1]-floor((N[1]-N[5])/2) do
       begin
        moy:=costv.sum(j,j+floor((N[1]-N[5])/2),1,1);
        if moy<minimum then
         begin
          minimum:=moy;
          Nopt:=j;
        end;
      end;}
      Nopt:=round((N[5]+N[1])/2/Nstimulations);
      binSize:=300/Nopt;
    end;
    K[1,3]:=0;
    {for z:=1 to Nstimulations do
    begin
    for i:=1 to 3000 do
     begin
       K.Kvalue[ceil(i/3000*Nopt+(z-1)*Nopt),lg_listN+1]:=round(K.Kvalue[ceil(i/3000*Nopt+(z-1)*Nopt),lg_listN+1]+psth.V[z+Ndebut,1].Yvalue[-i+1]);
       K.Kvalue[ceil(i/3000*Nopt+(z-1)*Nopt),3]:=round(K.Kvalue[ceil(i/3000*Nopt+(z-1)*Nopt),3]+psth.V[z+Ndebut,1].Yvalue[i]);
    end;
    end; }
    for z:=1 to Nstimulations do
    begin
      for i:=-1000-ceil(3000/Nopt)+1 to -1000 do optPSTH.V[z+Ndebut,1].Yvalue[-1000]:=optPSTH.V[z+Ndebut,1].Yvalue[-1000]+psth.V[z+Ndebut,1].Yvalue[i];
      for i:=-999 to 3000 do
           optPSTH.V[z+Ndebut,1].Yvalue[i]:=optPSTH.V[z+Ndebut,1].Yvalue[i-1]-psth.V[z+Ndebut,1].Yvalue[i-ceil(3000/Nopt)]+psth.V[z+Ndebut,1].Yvalue[i];
      for i:=-1000 to 3000 do optPSTH.V[z+Ndebut,1].Yvalue[i]:=round(optPSTH.V[z+Ndebut,1].Yvalue[i])/epcount/binsize*1000;
    end;
    PsthClean.V[1,1].Yvalue[-3000]:=binSize/500;
  end;
end;
*)

end.
