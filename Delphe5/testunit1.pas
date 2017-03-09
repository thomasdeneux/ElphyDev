
procedure AssignGraphic(Source: TGraphic);
var
  Data: THandle;
  Format: Word;
begin
  OpenClipboard(Application.handle);
  try
    EmptyClipboard;

    Format := CF_ENHMETAFILE;
    Data := CopyEnhMetaFile(MetaFileHandle, nil);
    SetClipboardData(Format, Data);

  finally
    CloseClipboard;
  end;
end;


