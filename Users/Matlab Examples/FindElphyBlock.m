function SZ = FindElphyBlock(fid,Name,Num)
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
