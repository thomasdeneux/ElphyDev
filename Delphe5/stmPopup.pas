unit stmPopUp;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses
  {$IFDEF FPC}
  Lresources,
  {$ELSE}
  Windows,
  {$ENDIF}
  Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus,

  util1,debug0,Dgraphic;

{La fiche PopUps contient les modèles de popupmenus utilisés par les objets STM

popUpItem retourne un élément de menu dont on donne le nom. Théoriquement,
FindComponent devrait faire la même chose mais ça ne marche pas ou alors je n'ai
pas bien compris.

copyPopUp copie un menuItem et son arborescence dans un autre menu.
}

type
  TPopUps = class(TForm)
    Pop_Tplot: TPopupMenu;
    Tplot_Show: TMenuItem;
    Tplot_Properties: TMenuItem;
    Pop_TdataPlot: TPopupMenu;
    TdataPlot_Coordinates: TMenuItem;
    TdataPlot_Show: TMenuItem;
    TdataPlot_Properties: TMenuItem;
    pop_Tmatrix: TPopupMenu;
    Tmatrix_Coordinates: TMenuItem;
    Tmatrix_show: TMenuItem;
    Tmatrix_Properties: TMenuItem;
    Tmatrix_Oncontrol: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    pop_TVList0: TPopupMenu;
    Label4: TLabel;
    TVList0_Coordinates: TMenuItem;
    TVList0_Show: TMenuItem;
    TVList0_Properties: TMenuItem;
    TVList0_showplot: TMenuItem;
    File1: TMenuItem;
    TdataPlot_FileSaveData: TMenuItem;
    TdataPlot_FileLoad: TMenuItem;
    TdataPlot_FilePrint: TMenuItem;
    TdataPlot_fileCopy: TMenuItem;
    TdataPlot_FileSaveObject: TMenuItem;
    TdataPlot_FileSaveAsText: TMenuItem;
    Pop_Tcursor: TPopupMenu;
    Tcursor_Properties: TMenuItem;
    Tcursor_Show: TMenuItem;
    Label5: TLabel;
    Pop_TvectorArray: TPopupMenu;
    Label6: TLabel;
    TvectorArray_Coordinates: TMenuItem;
    TvectorArray_Options: TMenuItem;
    TvectorArray_Show: TMenuItem;
    TvectorArray_Properties: TMenuItem;
    Tmatrix_Edit: TMenuItem;
    Pop_Tvector: TPopupMenu;
    Tvector_coordinates: TMenuItem;
    Tvector_show: TMenuItem;
    Tvector_properties: TMenuItem;
    Tvector_File: TMenuItem;
    Tvector_FileSaveData: TMenuItem;
    Tvector_FileSaveObject: TMenuItem;
    Label7: TLabel;
    Tvector_Edit: TMenuItem;
    Tools1: TMenuItem;
    Tmatrix_Buildcontourplot: TMenuItem;
    Tmatrix_SelectMode: TMenuItem;
    Tmatrix_MarkMode: TMenuItem;
    Tvector_Cursors: TMenuItem;
    Tvector_Cursors_New: TMenuItem;
    Pop_TXYPlot: TPopupMenu;
    TXYPlot_coordinates: TMenuItem;
    TXYplot_show: TMenuItem;
    TXYPlot_properties: TMenuItem;
    TXYPlot_Edit: TMenuItem;
    Label8: TLabel;
    Pop_Tcoo: TPopupMenu;
    Tcoo_Coordinates: TMenuItem;
    Label9: TLabel;
    Pop_Tsymbs: TPopupMenu;
    Tsymbs_Properties: TMenuItem;
    Label10: TLabel;
    Tvector_clone: TMenuItem;
    Tmatrix_showMatrix: TMenuItem;
    Tmatrix_show3Dcommands: TMenuItem;
    Tvector_Image: TMenuItem;
    Tplot_Clone: TMenuItem;
    TdataPlot_Clone: TMenuItem;
    Tmatrix_File: TMenuItem;
    Tmatrix_Clone: TMenuItem;
    Tmatrix_Saveobject: TMenuItem;
    TVlist0_File: TMenuItem;
    TVlist0_Clone: TMenuItem;
    TVlist0_Saveobject: TMenuItem;
    TVlist0_Savedata: TMenuItem;
    TvectorArray_File: TMenuItem;
    TvectorArray_Clone: TMenuItem;
    TvectorArray_Saveobject: TMenuItem;
    TvectorArray_Savedata: TMenuItem;
    TXYPlot_File: TMenuItem;
    TXYPlot_Clone: TMenuItem;
    TXYPlot_Saveobject: TMenuItem;
    Pop_TVlist: TPopupMenu;
    TVlist_Coordinates: TMenuItem;
    TVlist_show: TMenuItem;
    TVlist_ShowPlot: TMenuItem;
    TVlist_Properties: TMenuItem;
    TVlist_file: TMenuItem;
    TVlist_SaveData: TMenuItem;
    TVlist_SaveObject: TMenuItem;
    TVlist_Clone: TMenuItem;
    TVlist_ShowViewer: TMenuItem;
    Label11: TLabel;
    Load1: TMenuItem;
    Tvector_FileLoadfromvector: TMenuItem;
    Tvector_fileLoadFromObjectFile: TMenuItem;
    Load2: TMenuItem;
    Tmatrix_FileLoadFromMatrix: TMenuItem;
    Tmatrix_FileLoadFromObjectfile: TMenuItem;
    Pop_TdataFile: TPopupMenu;
    TdataFile_Properties: TMenuItem;
    Label12: TLabel;
    TdataFile_Show: TMenuItem;
    Pop_Toptimizer: TPopupMenu;
    Label13: TLabel;
    Toptimizer_Info: TMenuItem;
    Toptimizer_CalculateOutputs: TMenuItem;
    Tmatrix_ShowSelectWindow: TMenuItem;
    Pop_TregionList: TPopupMenu;
    TregionList_show: TMenuItem;
    TregionList_Edit: TMenuItem;
    TregionList_Clone: TMenuItem;
    Label14: TLabel;
    TregionList_Coordinates: TMenuItem;
    Pop_TUO2: TPopupMenu;
    TUO2_Show: TMenuItem;
    TUO2_Properties: TMenuItem;
    Label15: TLabel;
    Pop_TXYZplot: TPopupMenu;
    TXYZplot_Coordinates: TMenuItem;
    TXYZplot_Show: TMenuItem;
    TXYZplot_Properties: TMenuItem;
    TXYZplot_Edit: TMenuItem;
    TXYZplot_File: TMenuItem;
    TXYZplot_SaveObject: TMenuItem;
    TXYZplot_Clone: TMenuItem;
    TXYZplot: TLabel;
    TXYZplot_ShowPlot: TMenuItem;
    TXYZplot_Show3Dcommands: TMenuItem;
    Pop_TdumRegion: TPopupMenu;
    Label16: TLabel;
    TdumRegion_Delete: TMenuItem;
    TdumRegion_Edit: TMenuItem;
    Pop_TOIseq: TPopupMenu;
    Label17: TLabel;
    TOIseq_Coordinates: TMenuItem;
    TOIseq_Show: TMenuItem;
    TOIseq_Properties: TMenuItem;
    TXYZplot_PrintSaveCopy: TMenuItem;
    Pop_TOIseqPCL: TPopupMenu;
    TOIseqPCL_Coordinates: TMenuItem;
    TOIseqPCL_Show: TMenuItem;
    TOIseqPCL_Properties: TMenuItem;
    TOIseqPCL_Edit: TMenuItem;
    TOIseqPCL: TLabel;
    TOISeq_DisplayAsMatrix: TMenuItem;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;


function PopUps: TPopUps;

function popUpItem(menu:TpopupMenu;name:AnsiString):TmenuItem;
procedure copyPopUp(m0:TmenuItem;m1:TpopUpMenu);



implementation

{$IFNDEF FPC} {$R *.DFM} {$ENDIF}

var
  FPopUps: TPopUps;

function PopUps: TPopUps;
begin
  if not assigned(FPopUps) then FPopUps:= TPopUps.create(nil);
  result:= FPopUps;
end;
function getItem(m1:TmenuItem;name:AnsiString):TmenuItem;
var
  i:integer;
begin
  result:=nil;
  if m1=nil then exit;

  if Fmaj(m1.name)=name then
    begin
      getItem:=m1;
      exit;
    end;

  for i:=0 to m1.count-1 do
    begin
      result:=getItem(m1.items[i],name);
      if result<>nil then exit;
    end;

end;

function popUpItem(menu:TpopupMenu;name:AnsiString):TmenuItem;
var
  i:integer;
begin
  name:=Fmaj(name);
  i:=0;
  result:=nil;
  while (i<menu.items.count) and (result=nil) do
  begin
    result:=getItem(menu.items[i],name);
    inc(i);
  end;

  if result=nil then messageCentral('Erreur popUpItem '+menu.className+' '+name);
end;



procedure addItem(m0,m1:TmenuItem);
var
  i:integer;
  mj:TmenuItem;
begin
  mj:=TmenuItem.create(m0);
  mj.caption:=m1.caption;
  mj.onClick:=m1.onClick;
  mj.checked:=m1.checked;
  mj.visible:=m1.visible;
  mj.tag:=m1.tag;

  m0.add(mj);

  for i:=0 to m1.count-1 do  addItem(mj,m1.items[i]);
end;

procedure copyPopUp(m0:TmenuItem;m1:TpopupMenu);
var
  i:integer;
begin
  if not assigned(m1) then exit;
  for i:=0 to m1.items.count-1 do addItem(m0,m1.items[i]);
end;

Initialization
AffDebug('Initialization stmPopUp',0);
{$IFDEF FPC}
{$I stmPopUp.lrs}
{$ENDIF}
end.
