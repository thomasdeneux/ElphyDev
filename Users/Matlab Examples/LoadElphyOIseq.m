function [OI,Nx,Ny,HasRef,FrameCount] = LoadElphyOIseq(stName,NumOI)
% [OI,Nx,Ny,HasRef,FrameCount] = LoadElphyOIseq(FileName,NumOI) 
% Open the Elphy datafile with name FileName and load the (NumOI)th image sequence
% stored in the datafile
% Nx and Ny are the image dimension
% Hasref=1 if a reference frame is present
% FrameCount is the image count

ID=0;
SZ=0;
OI=0;
fid=fopen(stName);
if (fid==-1)    
    'unable to open file'
    return
end;
% Elphy Header
len=fread(fid,1,'uchar');
ID=fread(fid,len,'uchar');
ID=char(ID');
dum=fread(fid,15-len,'uchar');
SZ=fread(fid,1,'int16');

if (len ~=12) | ( strcmp(ID ,'Dac2 objects'))
    return
end;

% Looking for OIblock
N=0;
while (N ~= NumOI) && (~feof(fid))
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
   
   if ( strcmp(ID , 'OIblock'))
       N=N+1;       
   end;
   if (N ~= NumOI)
      fseek(fid,SZ-len-5,'cof');
   end;
   
end;

% Reading OIblock
if (N==NumOI)
    NotTheEnd = true;
    while (NotTheEnd) 
       len=fread(fid,1,'uchar');
       if (length(len)==0 )
          break;
       end;
   
       ID=fread(fid,len,'uchar');
       ID=char(ID');
       SZ=fread(fid,1,'uint16'); 
       if (SZ==65535)
           SZ=fread(fid,1,'int32');
       end;
       
       if (strcmp(ID,'Main'))            
           Nx = fread(fid,1,'int32');
           Ny = fread(fid,1,'int32');
           TpNum = fread(fid,1,'uchar');
           HasRef = fread(fid,1,'uchar');
           FrameCount = fread(fid,1,'int32');
         
       elseif (strcmp(ID,'RSH'))   
           Rsh = fread(fid,SZ,'uchar');
           Rsh = char(Rsh');
           
       elseif (strcmp(ID,'data'))   
           OI =  fread(fid,SZ/2,'int16');
           NotTheEnd=false;
           
       end;
    end;  
end;

fclose(fid);



