unit DBShortcuts;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
    uses
        SysUtils,Classes,stmMemo1;
    procedure proSplitString(st,separator:AnsiString;var memo:TstmMemo);pascal;
    procedure proReplaceString(source,target:AnsiString;var st:AnsiString);pascal;

implementation

    procedure proReplaceString(source,target:AnsiString;var st:AnsiString);
        var
            tmpstr:AnsiString;

        begin
            tmpstr := st;
            st := StringReplace(tmpstr, source, target, [rfReplaceAll]);
        end;
        
    procedure proSplitString(st,separator:AnsiString;var memo:TstmMemo);
        var
            new_index, last_index, len : Integer;
            substr_left, substr_right:AnsiString;

        begin
            substr_right := StringReplace(st, ' ', '', [rfReplaceAll]);
            separator := StringReplace(separator, ' ', '', [rfReplaceAll]);
            last_index := 0;
            new_index := Pos(separator,substr_right);
            while new_index > 0 do
                begin
                    substr_left := Copy(substr_right,last_index, new_index);
                    substr_left := StringReplace(substr_left, separator, '', [rfReplaceAll]);
                    if Length(substr_left) > 0 then memo.stList.Add(substr_left);
                    substr_right := Copy(substr_right,new_index,Length(st)-Length(substr_left));
                    substr_right := StringReplace(substr_right, separator, '', []);
                    new_index := Pos(separator,substr_right);
                end;
            if Length(substr_right) > 0 then memo.stList.Add(substr_right);
        end;

end.
 
