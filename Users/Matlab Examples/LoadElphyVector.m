

function V = LoadElphyVector(stName, NumOc, stClass)
% [V] = LoadElphyAnalog(FileName,NumOc)
% Open the Elphy object file with name FileName and load the NumOC
% occurrence of a Tvector object
% stClass ='Vector' or 'Average' or 'Psth'

V=0;
fid=fopen(stName);
if (fid==-1)
    'unable to open file'
    return
end;

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

    % Looking for Tvector
    SZ = findBlock(fid, stClass,NumOc);
    PosMax = ftell(fid)+SZ;

    % Reading Tvector

    if SZ<=0
        return
    end;

    TheEnd = (ftell(fid)>=PosMax);

    while not(TheEnd)

        len = fread(fid,1,'uchar');        % keyword length
        if (length(len)==0 )
            break;
        end;

        ID=fread(fid,len,'uchar');         % keyword
        ID=char(ID');
        SZ=fread(fid,1,'uint16');          % subblock size
        if (SZ==65535)                     % on 2 bytes
            SZ=fread(fid,1,'int32');       % or 4 bytes
        end;
        pos1 = ftell(fid)+SZ;              % End of subblock

        % We are only interested in the OBJINF structure
        % In Pascal, this structure looks like ( Data Alignment =1 )
        % TInfoDataObj =
        %   record
        %     tpNum:byte;  { data type }
        %     imin,imax,jmin,jmax:longint;    { data bounds for vectors and matrix }
        %     x0u,dxu,y0u,dyu,z0u,dzu:double; { scaling parameters }
        %     temp:boolean;
        %     readOnly:boolean;
        %   end;

        if (strcmp(ID,'OBJINF'))
            tpNum = fread(fid,1,'uchar');

            imin = fread(fid,1,'int32');
            imax = fread(fid,1,'int32');
            jmin = fread(fid,1,'int32'); % not used for Tvector
            jmax = fread(fid,1,'int32'); % not used for Tvector

            x0u = fread(fid,1,'float64');
            dxu = fread(fid,1,'float64');
            y0u = fread(fid,1,'float64');
            dyu = fread(fid,1,'float64');

            % we skip the other fields
            break; % we can also skip the other subblocks

        end;

        fseek(fid,pos1,'bof');
        TheEnd = (ftell(fid)>=PosMax);
    end;

    fseek(fid,PosMax,'bof');
    % Just after the 'Vector' block, there must be a 'DATA' block
    SZ = findBlock(fid,'DATA',1);
    if SZ<=0
        return
    end;

    % We must skip one byte
    fseek(fid,1,'cof');
    SzNum = [1,1,2,2,4,4,6,8,10,8,16,20];

    Nf = Nformat(tpNum);

    % Then read data
    V = fread(fid, imax-imin+1, Nf);
    
    % Apply scaling params    
    V = V*dyu+y0u;

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

function Nf = Nformat(N)
switch N
    case 0
        Nf ='uint8';
    case 1
        Nf ='int8';
    case 2
        Nf ='int16';
    case 3
        Nf ='uint16';
    case 4
        Nf ='int32';
    case 5
        Nf ='float32';
    case 7
        Nf ='float64';
    case 9
        Nf ='float32';
    case 10
        Nf ='float64';
    otherwise
        Nf = '';
end;
end

