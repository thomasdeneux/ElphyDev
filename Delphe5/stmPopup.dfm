object PopUps: TPopUps
  Left = 679
  Top = 200
  Width = 590
  Height = 346
  Caption = 'PopUps'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 131
    Top = 51
    Width = 24
    Height = 13
    Caption = 'Tplot'
  end
  object Label2: TLabel
    Left = 179
    Top = 60
    Width = 46
    Height = 13
    Caption = 'TdataPlot'
  end
  object Label3: TLabel
    Left = 231
    Top = 52
    Width = 65
    Height = 13
    Caption = 'Tmatrix (stm2)'
  end
  object Label4: TLabel
    Left = 317
    Top = 61
    Width = 32
    Height = 13
    Caption = 'TVlist0'
  end
  object Label5: TLabel
    Left = 25
    Top = 126
    Width = 36
    Height = 13
    Caption = 'Tcursor'
  end
  object Label6: TLabel
    Left = 93
    Top = 125
    Width = 61
    Height = 13
    Caption = 'TvectorArray'
  end
  object Label7: TLabel
    Left = 200
    Top = 128
    Width = 37
    Height = 13
    Caption = 'Tvector'
  end
  object Label8: TLabel
    Left = 24
    Top = 184
    Width = 39
    Height = 13
    Caption = 'TXYPlot'
  end
  object Label9: TLabel
    Left = 88
    Top = 184
    Width = 25
    Height = 13
    Caption = 'Tcoo'
  end
  object Label10: TLabel
    Left = 176
    Top = 192
    Width = 36
    Height = 13
    Caption = 'Tsymbs'
  end
  object Label11: TLabel
    Left = 317
    Top = 117
    Width = 26
    Height = 13
    Caption = 'TVlist'
  end
  object Label12: TLabel
    Left = 296
    Top = 220
    Width = 41
    Height = 13
    Caption = 'Tdatafile'
  end
  object Label13: TLabel
    Left = 60
    Top = 248
    Width = 48
    Height = 13
    Caption = 'Toptimizer'
  end
  object Label14: TLabel
    Left = 160
    Top = 256
    Width = 52
    Height = 13
    Caption = 'TregionList'
  end
  object Label15: TLabel
    Left = 8
    Top = 56
    Width = 29
    Height = 13
    Caption = 'TUO2'
  end
  object TXYZplot: TLabel
    Left = 408
    Top = 184
    Width = 45
    Height = 13
    Caption = 'TXYZplot'
  end
  object Label16: TLabel
    Left = 400
    Top = 64
    Width = 61
    Height = 13
    Caption = 'TdumRegion'
  end
  object Label17: TLabel
    Left = 408
    Top = 256
    Width = 35
    Height = 13
    Caption = 'TOIseq'
  end
  object TOIseqPCL: TLabel
    Left = 480
    Top = 256
    Width = 55
    Height = 13
    Caption = 'TOIseqPCL'
  end
  object Pop_Tplot: TPopupMenu
    Left = 130
    Top = 22
    object Tplot_Show: TMenuItem
      Caption = 'Show'
    end
    object Tplot_Properties: TMenuItem
      Caption = 'Properties'
    end
    object Tplot_Clone: TMenuItem
      Caption = 'Clone'
    end
  end
  object Pop_TdataPlot: TPopupMenu
    Left = 192
    Top = 29
    object File1: TMenuItem
      Caption = 'File'
      object TdataPlot_FileSaveData: TMenuItem
        Caption = 'Save data'
      end
      object TdataPlot_FileSaveObject: TMenuItem
        Caption = 'Save object'
      end
      object TdataPlot_FileSaveAsText: TMenuItem
        Caption = 'Save as text'
      end
      object TdataPlot_FileLoad: TMenuItem
        Caption = 'Load'
      end
      object TdataPlot_FilePrint: TMenuItem
        Caption = 'Print'
      end
      object TdataPlot_fileCopy: TMenuItem
        Caption = 'Copy'
      end
      object TdataPlot_Clone: TMenuItem
        Caption = 'Clone'
      end
    end
    object TdataPlot_Coordinates: TMenuItem
      Caption = 'Coordinates'
    end
    object TdataPlot_Show: TMenuItem
      Caption = 'Show'
    end
    object TdataPlot_Properties: TMenuItem
      Caption = 'Properties'
    end
  end
  object pop_Tmatrix: TPopupMenu
    Left = 245
    Top = 22
    object Tmatrix_Coordinates: TMenuItem
      Caption = 'Coordinates'
    end
    object Tmatrix_show: TMenuItem
      Caption = 'Show'
      object Tmatrix_showMatrix: TMenuItem
        Caption = 'matrix'
      end
      object Tmatrix_show3Dcommands: TMenuItem
        Caption = '3D commands'
      end
      object Tmatrix_ShowSelectWindow: TMenuItem
        Caption = 'Select Window'
      end
    end
    object Tmatrix_Properties: TMenuItem
      Caption = 'Properties'
    end
    object Tmatrix_Edit: TMenuItem
      Caption = 'Edit'
    end
    object Tmatrix_SelectMode: TMenuItem
      Caption = 'Select mode'
    end
    object Tmatrix_MarkMode: TMenuItem
      Caption = 'Mark Mode'
    end
    object Tools1: TMenuItem
      Caption = 'Tools'
      object Tmatrix_Buildcontourplot: TMenuItem
        Caption = 'Build contour plot'
      end
    end
    object Tmatrix_Oncontrol: TMenuItem
      Caption = 'On control'
    end
    object Tmatrix_File: TMenuItem
      Caption = 'File'
      object Tmatrix_Saveobject: TMenuItem
        Caption = 'Save object'
      end
      object Load2: TMenuItem
        Caption = 'Load'
        object Tmatrix_FileLoadFromMatrix: TMenuItem
          Caption = 'from matrix'
        end
        object Tmatrix_FileLoadFromObjectfile: TMenuItem
          Caption = 'from object file'
        end
      end
      object Tmatrix_Clone: TMenuItem
        Caption = 'Clone'
      end
    end
  end
  object pop_TVList0: TPopupMenu
    Left = 316
    Top = 25
    object TVList0_Coordinates: TMenuItem
      Caption = 'Coordinates'
    end
    object TVList0_Show: TMenuItem
      Caption = 'Show'
      object TVList0_showplot: TMenuItem
        Caption = 'plot'
      end
    end
    object TVList0_Properties: TMenuItem
      Caption = 'Properties'
    end
    object TVlist0_File: TMenuItem
      Caption = 'File'
      object TVlist0_Savedata: TMenuItem
        Caption = 'Save data'
      end
      object TVlist0_Saveobject: TMenuItem
        Caption = 'Save object'
      end
      object TVlist0_Clone: TMenuItem
        Caption = 'Clone'
      end
    end
  end
  object Pop_Tcursor: TPopupMenu
    Left = 32
    Top = 89
    object Tcursor_Show: TMenuItem
      Caption = 'Show'
    end
    object Tcursor_Properties: TMenuItem
      Caption = 'Properties'
    end
  end
  object Pop_TvectorArray: TPopupMenu
    Left = 101
    Top = 90
    object TvectorArray_Coordinates: TMenuItem
      Caption = 'Coordinates'
    end
    object TvectorArray_Options: TMenuItem
      Caption = 'Options'
    end
    object TvectorArray_Show: TMenuItem
      Caption = 'Show'
    end
    object TvectorArray_Properties: TMenuItem
      Caption = 'Properties'
    end
    object TvectorArray_File: TMenuItem
      Caption = 'File'
      object TvectorArray_Savedata: TMenuItem
        Caption = 'Save data'
      end
      object TvectorArray_Saveobject: TMenuItem
        Caption = 'Save object'
      end
      object TvectorArray_Clone: TMenuItem
        Caption = 'Clone'
      end
    end
  end
  object Pop_Tvector: TPopupMenu
    Left = 200
    Top = 93
    object Tvector_coordinates: TMenuItem
      Caption = 'Coordinates'
    end
    object Tvector_show: TMenuItem
      Caption = 'Show'
    end
    object Tvector_properties: TMenuItem
      Caption = 'Properties'
    end
    object Tvector_Edit: TMenuItem
      Caption = 'Edit'
    end
    object Tvector_File: TMenuItem
      Caption = 'File'
      object Tvector_FileSaveData: TMenuItem
        Caption = 'Save data'
      end
      object Tvector_FileSaveObject: TMenuItem
        Caption = 'Save object'
      end
      object Load1: TMenuItem
        Caption = 'Load'
        object Tvector_FileLoadfromvector: TMenuItem
          Caption = 'from vector'
        end
        object Tvector_fileLoadFromObjectFile: TMenuItem
          Caption = 'from object file'
        end
      end
      object Tvector_clone: TMenuItem
        Caption = 'Clone'
      end
      object Tvector_Image: TMenuItem
        Caption = 'Image'
      end
    end
    object Tvector_Cursors: TMenuItem
      Caption = 'Cursors'
      object Tvector_Cursors_New: TMenuItem
        Caption = 'New'
      end
    end
  end
  object Pop_TXYPlot: TPopupMenu
    Left = 24
    Top = 153
    object TXYPlot_coordinates: TMenuItem
      Caption = 'Coordinates'
    end
    object TXYplot_show: TMenuItem
      Caption = 'Show'
    end
    object TXYPlot_properties: TMenuItem
      Caption = 'Properties'
    end
    object TXYPlot_Edit: TMenuItem
      Caption = 'Edit'
    end
    object TXYPlot_File: TMenuItem
      Caption = 'File'
      object TXYPlot_Saveobject: TMenuItem
        Caption = 'Save object'
      end
      object TXYPlot_Clone: TMenuItem
        Caption = 'Clone'
      end
    end
  end
  object Pop_Tcoo: TPopupMenu
    Left = 88
    Top = 152
    object Tcoo_Coordinates: TMenuItem
      Caption = 'Coordinates'
    end
  end
  object Pop_Tsymbs: TPopupMenu
    Left = 168
    Top = 152
    object Tsymbs_Properties: TMenuItem
      Caption = 'Properties'
    end
  end
  object Pop_TVlist: TPopupMenu
    Left = 316
    Top = 81
    object TVlist_Coordinates: TMenuItem
      Caption = 'Coordinates'
    end
    object TVlist_show: TMenuItem
      Caption = 'Show'
      object TVlist_ShowPlot: TMenuItem
        Caption = 'plot'
      end
      object TVlist_ShowViewer: TMenuItem
        Caption = 'viewer'
      end
    end
    object TVlist_Properties: TMenuItem
      Caption = 'Properties'
    end
    object TVlist_file: TMenuItem
      Caption = 'File'
      object TVlist_SaveData: TMenuItem
        Caption = 'Save data'
      end
      object TVlist_SaveObject: TMenuItem
        Caption = 'Save object'
      end
      object TVlist_Clone: TMenuItem
        Caption = 'Clone'
      end
    end
  end
  object Pop_TdataFile: TPopupMenu
    Left = 300
    Top = 188
    object TdataFile_Properties: TMenuItem
      Caption = 'Properties'
    end
    object TdataFile_Show: TMenuItem
      Caption = 'Show'
    end
  end
  object Pop_Toptimizer: TPopupMenu
    Left = 68
    Top = 216
    object Toptimizer_Info: TMenuItem
      Caption = 'Show'
    end
    object Toptimizer_CalculateOutputs: TMenuItem
      Caption = 'Calculate outputs'
    end
  end
  object Pop_TregionList: TPopupMenu
    Left = 170
    Top = 230
    object TregionList_Coordinates: TMenuItem
      Caption = 'Coordinates'
    end
    object TregionList_show: TMenuItem
      Caption = 'Show'
    end
    object TregionList_Edit: TMenuItem
      Caption = 'Edit'
    end
    object TregionList_Clone: TMenuItem
      Caption = 'Clone'
    end
  end
  object Pop_TUO2: TPopupMenu
    Left = 10
    Top = 22
    object TUO2_Show: TMenuItem
      Caption = 'Show'
    end
    object TUO2_Properties: TMenuItem
      Caption = 'Properties'
    end
  end
  object Pop_TXYZplot: TPopupMenu
    Left = 416
    Top = 145
    object TXYZplot_Coordinates: TMenuItem
      Caption = 'Coordinates'
    end
    object TXYZplot_Show: TMenuItem
      Caption = 'Show'
      object TXYZplot_ShowPlot: TMenuItem
        Caption = 'Plot'
      end
      object TXYZplot_Show3Dcommands: TMenuItem
        Caption = '3D commands'
      end
    end
    object TXYZplot_Properties: TMenuItem
      Caption = 'Properties'
    end
    object TXYZplot_Edit: TMenuItem
      Caption = 'Edit'
    end
    object TXYZplot_File: TMenuItem
      Caption = 'File'
      object TXYZplot_SaveObject: TMenuItem
        Caption = 'Save object'
      end
      object TXYZplot_Clone: TMenuItem
        Caption = 'Clone'
      end
    end
    object TXYZplot_PrintSaveCopy: TMenuItem
      Caption = 'Print/Save/Copy'
    end
  end
  object Pop_TdumRegion: TPopupMenu
    Left = 408
    Top = 32
    object TdumRegion_Delete: TMenuItem
      Caption = 'Delete'
    end
    object TdumRegion_Edit: TMenuItem
      Caption = 'Edit'
    end
  end
  object Pop_TOIseq: TPopupMenu
    Left = 408
    Top = 224
    object TOIseq_Coordinates: TMenuItem
      Caption = 'Coordinates'
    end
    object TOIseq_Show: TMenuItem
      Caption = 'Show'
    end
    object TOIseq_Properties: TMenuItem
      Caption = 'Properties'
    end
    object TOISeq_DisplayAsMatrix: TMenuItem
      Caption = 'Display As Matrix'
    end
  end
  object Pop_TOIseqPCL: TPopupMenu
    Left = 480
    Top = 224
    object TOIseqPCL_Coordinates: TMenuItem
      Caption = 'Coordinates'
    end
    object TOIseqPCL_Show: TMenuItem
      Caption = 'Show'
    end
    object TOIseqPCL_Properties: TMenuItem
      Caption = 'Properties'
    end
    object TOIseqPCL_Edit: TMenuItem
      Caption = 'Edit'
    end
  end
end
