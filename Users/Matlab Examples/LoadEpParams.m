

function EpStruct = LoadEpParams(fid, SZ)

EpStruct= struct;

    PosMax = ftell(fid)+SZ;

    % Reading B_Ep

    if SZ<=0
        return
    end;

    TheEnd = (ftell(fid)>=PosMax);

    Ktype=[];
    while not(TheEnd)

       len = fread(fid,1,'uchar');
       if (length(len)==0 )
          break;
       end;

       ID=fread(fid,len,'uchar');
       ID=char(ID');
       SZ=fread(fid,1,'uint16');
       if (SZ==65535)
           SZ=fread(fid,1,'int32');
       end;
       pos1 = ftell(fid)+SZ;


       if (strcmp(ID,'Ep'))
          nbvoie= fread(fid,1,'uchar');

          nbpt= fread(fid,1,'int32');

          tpData= fread(fid,1,'uchar');
          uX= freadString(fid,10);

          Dxu = fread(fid,1,'double');
          x0u = fread(fid,1,'double');

          continu = fread(fid,1,'uchar');

          TagMode = fread(fid,1,'uchar');
          TagShift = fread(fid,1,'uchar');

          DxuSpk = fread(fid,1,'double');
          X0uSpk = fread(fid,1,'double');
          nbSpk = fread(fid,1,'int32');
          DyuSpk = fread(fid,1,'double');
          Y0uSpk = fread(fid,1,'double');
          unitXspk = freadString(fid,10);
          unitYSpk = freadString(fid,10);
          CyberTime = fread(fid,1,'double');
          PCtime = fread(fid,1,'int32');

          Ktype = ones(nbvoie,1) * tpData(1,1) ;

       elseif (strcmp(ID,'Adc'))
          uY=[];
          Dyu=[];
          Y0u=[];
          for ii = 1 : nbvoie
              uY = strvcat(uY,freadString(fid,10));
              Dyu = cat(1,Dyu,fread(fid,1,'double'));
              Y0u = cat(1,Y0u,fread(fid,1,'double'));
          end;

       elseif (strcmp(ID,'Ksamp'))
          Ksamp = [];
          for ii = 1 : nbvoie
              Ksamp = cat(1,Ksamp,fread(fid,1,'uint16'));

          end;

       elseif (strcmp(ID,'Ktype'))
          Ktype=[];
          for ii = 1 : nbvoie
              Ktype = cat(1,Ktype,fread(fid,1,'uchar'));

          end;

       end;
       fseek(fid,pos1,'bof');
       TheEnd = (ftell(fid)>=PosMax);
    end;

    % Reading Rdata
    SZ = findBlock(fid,'RDATA',1);
    if SZ<=0
        return
    end;
    RdataHsize = fread(fid,1,'int16');    %Rdata Header Size
    fseek(fid,RdataHsize-2,'cof');
    SZ = SZ-RdataHsize;

    nbSamp = floor(SZ/2);

    [AgSampleCount,ppcm0] = GetAgSampleCount(Ksamp);
    ChanMask = GetMask(Ksamp);
    SamplePerChan = GetSamplePerChan(nbSamp,AgSampleCount,ppcm0,Ksamp,Ktype,ChanMask);

    N = SamplePerChan(NumChan);
    Dy0 = Dyu(NumChan);
    Y00 = Y0u(NumChan);
    V = zeros(N,1);

    k =0;
    for i=1 : nbSamp
        w = fread(fid,1,'int16')*Dy0 + Y00;
        im = mod((i-1),AgSampleCount)+1;
        if ChanMask(im) == NumChan
          k = k+1;
          V(k) = w;
        end;
    end;

    fclose(fid);

  catch
    fclose(fid);
    rethrow(lasterror);
  end;
end


function SZ = findBlock(fid,Name,Num)
ID=0;
SZ=0;
N=0;

while (N ~= Num) && (~feof(fid))
   SZ=fread(fid,1,'int32');
   if (length(SZ)==0 )
       break;
   end;

   len=fread(fid,1,'uchar');
   if (length(len)==0 )
       break;
   end;

   ID=fread(fid,len,'uchar');
   ID=char(ID');

   if ( strcmp(ID , Name))
       N=N+1;       
   end;
   SZ=SZ-len-5;
   if (N ~= Num)
      fseek(fid,SZ,'cof');
   end;   
end;
if N~=Num 
    SZ=-1;
    'Block not found'
end;

end

function x=freadString(fid,N)
  len = fread(fid,1,'uchar'); 
  if len>N
      len=N;
  end;
  x = fread(fid,len,'uchar');  
  x = char(x');
  fseek(fid,N-len,'cof'); 
end

function [x,ppcm0] = GetAgSampleCount(KS) 
%Number of samples in aggregate 

  N = length(KS);
  ppcm0 = 1;
  for i =1 : N
    if KS(i)>0
       ppcm0 = lcm(ppcm0,KS(i));
    end;   
  end;                          
  
  x = 0;
  for i=1 : N
    if KS(i)>0
      x = x+ppcm0 / KS(i);
    end;
  end;
end

function x = GetMask(KS)
% build Channel Mask = array of channel numbers for each sample of aggregate
% KS = array of DownSampling factors
  AgC = GetAgSampleCount(KS);
  Nvoie=length(KS);

  x = zeros(AgC,1);  
  i=0;
  k=1;
  while k<=AgC 
    for j=1 : Nvoie 
      if (KS(j)>0) && (mod(i,KS(j))==0)
          x(k)=j;          
          k=k+1;
          if k>AgC
             break;
          end;   
      end;
    i=i+1;
    end;
  end;   
end


function x = GetAgSize(KS,KT)
  tpSize =[1 1 2 2 4 4 6 8 10 8 16 20 0];
  x=0;
  for i= 1:length(KS)
      x = x+TpSize(KT(KS(i)));
  end;
end

function x = GetSamplePerChan(nb,AgSz,ppcm0,KS,Ktype,chanMask) 
% nb est la taille du bloc de données
% AgSz est la taille de l'agrégat
% KS contient les DownSampling factors

  tpSize =[1 1 2 2 4 4 6 8 10 8 16 20 0];

  x = zeros(length(KS),1);
  nvoie = length(KS);

  nbAg = floor(nb/AgSz); %        {nombre d'agrégats complets }

  for i=1 : nvoie 
    if KS(i)>0
       x(i) = nbAg*ppcm0/KS(i);
    else
       x(i) = 0;
    end;
  end;  

  rest= mod(nb,AgSz);        %   {agrégat incomplet }
  it=0; %{ taille }
  j=1;  %{ indice dans l'Ag }
  while it<rest 
    vv = chanMask(j);
    if (vv>=0) && (vv <nvoie) 
       x(vv) = x(vv)+1;
       it = it + tpSize(Ktype(vv));
       j = j+1;
    end;
  end;
end




