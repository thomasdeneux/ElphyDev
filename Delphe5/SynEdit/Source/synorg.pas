{ This file was automatically created by Lazarus. do not edit!
  This source is only used to compile and install the package.
 }

unit SynORG; 

interface

uses
    SynURIOpener, SynAutoCorrect, SynAutoCorrectEditor, SynCompletionProposal, 
  SynDBEdit, SynEdit, SynEditAutoComplete, SynEditExport, SynEditHighlighter, 
  SynEditKbdHandler, SynEditKeyCmdEditor, SynEditKeyCmds, 
  SynEditKeyCmdsEditor, SynEditKeyConst, SynEditMiscClasses, SynEditMiscProcs, 
  SynEditOptionsDialog, SynEditPlugins, SynEditPrint, SynEditPrinterInfo, 
  SynEditPrintHeaderFooter, SynEditPrintMargins, SynEditPrintMarginsDialog, 
  SynEditPrintPreview, SynEditPrintTypes, SynEditPropertyReg, 
  SynEditPythonBehaviour, SynEditReg, SynEditRegexSearch, SynEditSearch, 
  SynEditStrConst, SynEditTextBuffer, SynEditTypes, SynEditWildcardSearch, 
  SynEditWordWrap, SynExportHTML, SynExportRTF, SynExportTeX, 
  SynHighlighterADSP21xx, SynHighlighterAsm, SynHighlighterAWK, 
  SynHighlighterBaan, SynHighlighterBat, SynHighlighterCAC, 
  SynHighlighterCache, SynHighlighterCobol, SynHighlighterCPM, 
  SynHighlighterCpp, SynHighlighterCS, SynHighlighterCss, SynHighlighterDfm, 
  SynHighlighterDml, SynHighlighterDOT, SynHighlighterEiffel, 
  SynHighlighterFortran, SynHighlighterFoxpro, SynHighlighterGalaxy, 
  SynHighlighterGeneral, SynHighlighterGWS, SynHighlighterHashEntries, 
  SynHighlighterHaskell, SynHighlighterHC11, SynHighlighterHP48, 
  SynHighlighterHtml, SynHighlighterIDL, SynHighlighterIni, 
  SynHighlighterInno, SynHighlighterJava, SynHighlighterJScript, 
  SynHighlighterKix, SynHighlighterLDraw, SynHighlighterM3, 
  SynHighlighterManager, SynHighlighterModelica, SynHighlighterMsg, 
  SynHighlighterMulti, SynHighlighterPas, SynHighlighterPerl, 
  SynHighlighterPHP, SynHighlighterProgress, SynHighlighterPython, 
  SynHighlighterRC, SynHighlighterRuby, SynHighlighterSDD, SynHighlighterSml, 
  SynHighlighterSQL, SynHighlighterST, SynHighlighterTclTk, SynHighlighterTeX, 
  SynHighlighterUNIXShellScript, SynHighlighterUnreal, SynHighlighterURI, 
  SynHighlighterVB, SynHighlighterVBScript, SynHighlighterVrml97, 
  SynHighlighterXML, SynMacroRecorder, SynMemo, SynRegExpr, SynTextDrawer, 
  LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('SynEditPropertyReg', @SynEditPropertyReg.Register); 
  RegisterUnit('SynEditReg', @SynEditReg.Register); 
end; 

initialization
  RegisterPackage('SynORG', @Register); 
end.
