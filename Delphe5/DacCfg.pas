unit DacCfg;

{$F+,O+}

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses util1,Dgraphic,Dcfg1,StmDef,
     acqDef2,
     ProcFile,recorder1,objFile1, objFileO,
     {$IFDEF FPC} Gedit5fpc {$ELSE} Gedit5 {$ENDIF} ;

procedure initcfg0DAC(lecture:boolean);
procedure initCfgBaseDAC;

IMPLEMENTATION

uses stmdf0;                                                     

procedure initcfg0DAC(lecture:boolean);
  begin

    { Programme }
    setVarConf1('NOMPG1',     NomTextePg,    sizeof(NomTextePg));

    if lecture then
    begin
      fillchar(paramStimOld,sizeof(paramStimOld),0);
      fillchar(paramStimOld2,sizeof(paramStimOld2),0);
      fillchar(acqInfOld,sizeof(AcqInfOld),0);

      setVarConf1('STIMDACDIO', paramStimOld,    sizeof(paramStimOld));
      setVarConf1('STIMULATOR', paramStimOld2,    sizeof(paramStimOld2));
      setvarconf1('ACQINF',acqInfOld,sizeof(acqInfOld));
    end;

    setStringConf1('OBJREFRESH',stObjectsToRefresh);
    setStringConf1('OBJCLEAR',stObjectsToClear);

  end;

procedure initCfgBaseDAC;   { Variables sauvées uniquement dans dac2.gfc }
  var
    i:integer;
  begin
      { Configuration }
    setvarconf1('STCFG',     stCfg,sizeof(stCfg) );
    setvarconf1('STGENCFG',  stGenCfg,sizeof(stGenCfg) );

    setStringConf1('CFGHIS', stCfgHistory );
    setStringConf1('DATHIS', stDatHistory );
    setStringConf1('PGHIS', stTxtHistory );

    setStringConf1('MATLABPATH', MatlabPath );
    setStringConf1('DATAROOT', UnicDataRoot );
    setStringConf1('PGROOT', UnicPgRoot );
    setStringConf1('TEMPDIR', TempDirectory );
    setVarConf1('MEMMANSIZE',MemManagerSize,sizeof(MemManagerSize));

      { Taille fenêtre principale }

    setvarconf1('WSTATE',   wState, sizeof(wState) );

    setvarconf1('WTOP',     wtop,   sizeof(wTop) );
    setvarconf1('WLEFT',    wLeft,  sizeof(wLeft) );
    setvarconf1('WWIDTH',   wWidth, sizeof(wWidth) );
    setvarconf1('WHEIGHT',  wHeight,sizeof(wHeight) );

    setvarconf1('LASTCAP',  LastCaption,sizeof(LastCaption) );


    setvarconf1('PRIMONO',  PRmonochrome ,  sizeof(PRmonochrome) );
    setvarconf1('PRIWHITE', PRwhiteBackGnd ,sizeof(PRwhiteBackGnd) );
    setvarconf1('PRILAND',  PRlandscape ,   sizeof(PRlandscape) );
    setvarconf1('PRIDRAFT', PRdraft ,       sizeof(PRdraft) );
    setvarconf1('PRINAME',  PRprintName ,   sizeof(PRprintName) );
    setvarconf1('PRICOM',   printComment , sizeof(printComment) );

    setvarconf1('PRFONTMAG',  PRfontMag,   sizeof(PRfontMag) );
    setvarconf1('PRPWIDTH',   PRPwidth,    sizeof(PRPwidth) );
    setvarconf1('PRPHEIGHT',  PRPheight,   sizeof(PRPheight) );
    setvarconf1('PRAUTOFONT', PRautoFont,  sizeof(PRautoFont) );

    setvarconf1('PRSYMBMAG',  PRSymbMag,   sizeof(PRsymbMag) );
    setvarconf1('PRAUTOSYMB', PRAutoSymb,  sizeof(PRAutoSymb) );
    setvarconf1('PRSPLITMAT', PRsplitMatrix,  sizeof(PRsplitMatrix) );


    setvarconf1('PRKEEPASPECT', PRkeepAspectRatio,  sizeof(PRkeepAspectRatio) );
    setStringConf1('PRFNAME', PRFileName );


    setvarconf1('FORMINSP', InspFormRec ,  sizeof(InspFormRec) );

    with ProcessFileForm do
    begin
      setvarconf1('PFSEQ1', seq1 ,      sizeof(seq1) );
      setvarconf1('PFSEQ2', seq2 ,      sizeof(seq2) );

      setvarconf1('PFIVALID', Finit ,     sizeof(Finit) );
      setvarconf1('PFPVALID', Fprocess ,  sizeof(Fprocess) );
      setvarconf1('PFEVALID', Fend ,      sizeof(Fend) );

      setStringConf1('PFINAME', InitName);
      setStringConf1('PFPNAME', ProcessName);
      setStringConf1('PFENAME', EndName);
      setStringConf1('PFDFNAME',DFName);

      setvarconf1('PFUPDATE', Fupdate ,   sizeof(Fupdate) );
    end;


    setvarConf1('ACQDRV1',AcqDriver1,sizeof(AcqDriver1));

    if assigned(acqCommand) then
      setvarconf1('ACQBOX0',acqCommand.AcqRec,sizeof(acqCommand.AcqRec));

    setStringConf1('GENOBJ',defGenObjFile);

    setVarConf1('LASTVER',    LastVersion,    sizeof(LastVersion));

    setvarConf1('TFREQ',Tfreq,sizeof(Tfreq));
    setvarConf1('SSWIDTH',SSwidth,sizeof(SSwidth));
    setvarConf1('SSHEIGHT',SSheight,sizeof(SSheight));
    setvarConf1('SSREFRATE',SSRefreshRate,sizeof(SSRefreshRate));
    setvarConf1('SSBITCOUNT',SSbitCount,sizeof(SSbitCount));

    setvarConf1('SCREENDIST',ScreenDistance,sizeof(ScreenDistance));
    setvarConf1('SCREENHEIGHT',ScreenHeight,sizeof(ScreenHeight));

    setvarConf1('VSSYNCMODE',VSsyncMode,sizeof(VSsyncMode));
    setvarConf1('VSSYNCSPOT',VSsyncSpot,sizeof(VSsyncSpot));
    setvarConf1('VSCONTSPOT',VScontSpot,sizeof(VScontSpot));
    setvarConf1('VSSPOTSIZE',VSSpotSize,sizeof(VSSpotSize));


    setStringConf1('DXDRIVER',stDXdriver);

    setStringConf1('VSCALIB',CalibFileName);

    setVarConf1('HTMLHELP',ChmHelp,sizeof(ChmHelp));

    setvarconf1('SYNCINPUT',VSSyncInput,sizeof(VSSyncInput));
    setvarconf1('CONTROLINPUT',VSControlInput,sizeof(VSControlInput));
    setvarconf1('VSTRIG',VSnotrigger,sizeof(VSnotrigger));

    setvarconf1('SERVERADD',ElphyServerAdd,sizeof(ElphyServerAdd));
    setvarconf1('SERVERPORT',ElphyServerPort,sizeof(ElphyServerPort));

    setvarconf1('TESTEDFILES',TestedFiles,sizeof(TestedFiles));

    setvarconf1('EDCOLORS',DefEdColors,sizeof(DefEdColors));
    setvarconf1('EDBKCOLORS',DefEdBKColors,sizeof(DefEdBKColors));
    setvarconf1('EDBOLD',DefEdBold,sizeof(DefEdBold));
    setvarconf1('EDITALIC',DefEdItalic,sizeof(DefEdItalic));
    setvarconf1('EDUNDER',DefEdUnderScore,sizeof(DefEdUnderScore));

    setvarconf1('EDBREAK', BreakPointColor,sizeof(BreakPointColor));
    setvarconf1('EDBREAKBK',BreakPointBKColor,sizeof(BreakPointBKColor));

    setvarconf1('MONOPALNUM',MonoPaletteNumber,sizeof(MonoPaletteNumber));
    setvarconf1('STDCOLORS', StdColors,sizeof(StdColors));

    setvarconf1('DEFSCALECOL', DefScaleColor,sizeof(DefScaleColor));
    setvarconf1('DEKBKCOL', DefBKColor,sizeof(DefBKColor));
    setvarconf1('DEFPENCOL', DefPenColor,sizeof(DefPenColor));

    setvarconf1('OFILEOPT', ObjFileDefOptions,sizeof(ObjFileDefOptions));

    setStringConf1('SEARCHPATH',Pg2SearchPath);

    setvarconf1('GDEBUG',GDebugMode,sizeof(GDebugMode));
    setvarconf1('DEBUGCODE',DebugCode,sizeof(DebugCode));

    {$IFDEF WIN64}
    //setVarConf1('CUDAVERSION', FcudaVersion,sizeof(FcudaVersion));
    {$ENDIF}
    //setVarConf1('DIRECTXVER', FDirectXVersion,sizeof(FDirectXVersion));


    setvarconf1('BINARYFILEP', DataFileRecBin,sizeof( DataFileRecBin));
  end;



end.
