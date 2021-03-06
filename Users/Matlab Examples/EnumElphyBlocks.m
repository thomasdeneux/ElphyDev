
function ListBlocks = EnumElphyBlocks(stName)

ListBlocks = struct();
blockNum = 0;

  fid=fopen(stName);
  if (fid==-1)
      error( 'unable to open file %s', stName )
  end

try
  % Elphy Header
  len=fread(fid,1,'uchar');
  ID=fread(fid,len,'uchar');
  ID=char(ID');
  dum=fread(fid,15-len,'uchar');
  SZ=fread(fid,1,'int16');

  if (len ~=12) | ( strcmp(ID ,'Dac2 objects'))
      return
  end;

while (~feof(fid))
   blockNum = blockNum+1;
   SZ=fread(fid,1,'int32');         % Block Size 
   if (length(SZ)==0 )
       break;
   end;

   len=fread(fid,1,'uchar');        % Block Name Length
   if (length(len)==0 )
       break;
   end;

   ListBlocks(blockNum).ID = fread( fid, len, '*char' )';       % Block Name
   ListBlocks(blockNum).offset = ftell(fid)-len-5;              % Block offset 
   

   fseek(fid,SZ-len-5,'cof');
end;
   fclose(fid);

catch
    fclose(fid);
    rethrow(lasterror);
end;

end
