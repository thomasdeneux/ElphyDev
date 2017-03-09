unit IgorBin;

INTERFACE
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
// IgorBin.h -- structures and #defines for dealing with Igor binary data.



// All structures written to disk are 2-byte-aligned.

{$align 2}


// From IgorMath.h

Const
  NT_CMPLX= 1;    // Complex numbers.
  NT_FP32= 2;     // 32 bit fp numbers.
  NT_FP64= 4;     // 64 bit fp numbers.
  NT_I8= 8;       // 8 bit signed integer. Requires Igor Pro 2.0 or later.
  NT_I16=$10;     // 16 bit integer numbers. Requires Igor Pro 2.0 or later.
  NT_I32=$20;     // 32 bit integer numbers. Requires Igor Pro 2.0 or later.
  NT_UNSIGNED=$40;// Makes above signed integers unsigned. Requires Igor Pro 3.0 or later.


// From wave.h
Const
  MAXDIMS= 4;


//	From binary.h

type
  TBinHeader1= record
	         version:smallInt;  //Version number for backwards compatibility.
	         wfmSize:longint;   // The size of the WaveHeader2 data structure plus the wave data plus 16 bytes of padding.
	         checksum:smallint; // Checksum over this header and the wave header.
               end;
  PBinHeader1=^TBinHeader1;

  TBinHeader2= record
                 version:smallint;  // Version number for backwards compatibility.
	         wfmSize:longint;   // The size of the WaveHeader2 data structure plus the wave data plus 16 bytes of padding.
	         noteSize:longint;  // The size of the note text.
	         pictSize:longint;  // Reserved. Write zero. Ignore on read.
	         checksum:smallint; // Checksum over this header and the wave header.
               end;
  PBinHeader2=^TBinHeader2;

  TBinHeader3 =record
	         version:smallint;   // Version number for backwards compatibility.
	         wfmSize:longint;    // The size of the WaveHeader2 data structure plus the wave data plus 16 bytes of padding.
	         noteSize:longint;   // The size of the note text.
	         formulaSize:longint;// The size of the dependency formula, if any.
	         pictSize:longint;   // Reserved. Write zero. Ignore on read.
	         checksum:smallint;  // Checksum over this header and the wave header.
               end;
  PBinHeader3=^TBinHeader3;

  TBinHeader5 =record
                 version:smallint;        // Version number for backwards compatibility.
                 checksum:smallint ;      // Checksum over this header and the wave header.
                 wfmSize:longint;         // The size of the WaveHeader5 data structure plus the wave data.
                 formulaSize:longint;     // The size of the dependency formula, if any.
                 noteSize:longint ;       // The size of the note text.
                 dataEUnitsSize:longint ; // The size of optional extended data units.
                 dimEUnitsSize:array[1..MAXDIMS] of longint ;
                                          // The size of optional extended dimension units.
                 dimLabelsSize:array[1..MAXDIMS] of longint ;
                                          // The size of optional dimension labels.
                 sIndicesSize:longint ;	 // The size of string indicies if this is a text wave.
                 optionsSize1:longint ;	 // Reserved. Write zero. Ignore on read.
                 optionsSize2:longint ;	 // Reserved. Write zero. Ignore on read.
               end;
  PBinHeader5=^TBinHeader5;


//	From wave.h

Const
  MAX_WAVE_NAME2= 18;	// Maximum length of wave name in version 1 and 2 files. Does not include the trailing null.
  MAX_WAVE_NAME5= 31;	// Maximum length of wave name in version 5 files. Does not include the trailing null.
  MAX_UNIT_CHARS= 3;

//	Header to an array of waveform data.

type
  TWaveHeader2= record
	          typeW:smallint;      // See types (e.g. NT_FP64) above. Zero for text waves.
	          next:pointer;	       // Used in memory only. Write zero. Ignore on read.

	          bname:array[1..MAX_WAVE_NAME2+2] of char;
                                       // Name of wave plus trailing null.
                  whVersion:smallint ; // Write 0. Ignore on read.
	          srcFldr:smallint ;   // Used in memory only. Write zero. Ignore on read.
	          HfileName:longint;   // Used in memory only. Write zero. Ignore on read.

	          dataUnits:array[1..MAX_UNIT_CHARS+1] of char;
                                       // Natural data units go here - null if none.
	          xUnits:array[1..MAX_UNIT_CHARS+1] of char;
                                       // Natural x-axis units go here - null if none.

                  npnts:longint;       // Number of data points in wave.

	          aModified:smallint;  // Used in memory only. Write zero. Ignore on read.
	          hsA,hsB:double;      // X value for point p = hsA*p + hsB

	          wModified:smallint ; // Used in memory only. Write zero. Ignore on read.
	          swModified:smallint; // Used in memory only. Write zero. Ignore on read.
	          fsValid:WordBool;    // True if full scale values have meaning.
	          topFullScale,botFullScale:double;
                                       // The min full scale value for wave.

                  useBits:char;        // Used in memory only. Write zero. Ignore on read.
	          kindBits:char;       // Reserved. Write zero. Ignore on read.
	          formula:pointer;     // Used in memory only. Write zero. Ignore on read.
	          depID:longint;       // Used in memory only. Write zero. Ignore on read.
	          creationDate:Longword;  // DateTime of creation. Not used in version 1 files.
	          wUnused:array[1..2] of char;
                                       // Reserved. Write zero. Ignore on read.

                  modDate:Longword;       // DateTime of last modification.
	          waveNoteH:integer;   // Used in memory only. Write zero. Ignore on read.

	          wData:array[1..4] of single;
                                       // The start of the array of waveform data.
                end;

  WavePtr2=^TWaveHeader2 ;
  waveHandle2=^WavePtr2 ;


  PWaveHeader5=^TWaveHeader5;
  TWaveHeader5= record
	          next: PWaveHeader5;	  // link to next wave in linked list.
                  creationDate: longword; // DateTime of creation.
	          modDate:longword;       // DateTime of last modification.

	          npnts: longint;         // Total number of points (multiply dimensions up to first zero).
	          typeW: smallint ;       // See types (e.g. NT_FP64) above. Zero for text waves.
	          dLock: smallint;        // Reserved. Write zero. Ignore on read.

	          whpad1: array[1..6] of char;
                                          // Reserved. Write zero. Ignore on read.
                  whVersion: smallint;    // Write 1. Ignore on read.
	          bname: array[1..MAX_WAVE_NAME5+1] of char;
                                          // Name of wave plus trailing null.
                  whpad2:longint;         // Reserved. Write zero. Ignore on read.
	          dFolder:pointer;        // Used in memory only. Write zero. Ignore on read.

	// Dimensioning info. [0] == rows, [1] == cols etc
	          nDim: array[1..MAXDIMS] of longint;
                                          // Number of of items in a dimension -- 0 means no data.
                  sfA:array[1..MAXDIMS] of double;
                                          // Index value for element e of dimension d = sfA[d]*e + sfB[d].
                  sfB:array[1..MAXDIMS] of double;// SI units
	          dataUnits:array[1..MAX_UNIT_CHARS+1] of char;
                                          // Natural data units go here - null if none.
                  dimUnits:array[1..MAXDIMS,1..MAX_UNIT_CHARS+1] of char;
                                          // Natural dimension units go here - null if none.

                  fsValid:WordBool;       // TRUE if full scale values have meaning.
	          whpad3: smallint;       // Reserved. Write zero. Ignore on read.
	          topFullScale,botFullScale:double;
                                          // The max and max full scale value for wave.
                  dataEUnits:integer;     // Used in memory only. Write zero. Ignore on read.
	          dimEUnits:array[1..MAXDIMS] of integer;
                                          // Used in memory only. Write zero. Ignore on read.
                  dimLabels:array[1..MAXDIMS] of integer;
                                          // Used in memory only. Write zero. Ignore on read.

                  waveNoteH:integer;      // Used in memory only. Write zero. Ignore on read.
	          whUnused:array[1..16] of longint;
                                          // Reserved. Write zero. Ignore on read.

	// The following stuff is considered private to Igor.

                  aModified:smallint;     // Used in memory only. Write zero. Ignore on read.
                  wModified:smallint;     // Used in memory only. Write zero. Ignore on read.
                  swModified:smallint;    // Used in memory only. Write zero. Ignore on read.

                  useBits:char;           // Used in memory only. Write zero. Ignore on read.
                  kindBits:char;          // Reserved. Write zero. Ignore on read.
                  formula:pointer;        // Used in memory only. Write zero. Ignore on read.
                  depID:longint;          // Used in memory only. Write zero. Ignore on read.

                  whpad4:smallint;        // Reserved. Write zero. Ignore on read.
                  srcFldr:smallint;       // Used in memory only. Write zero. Ignore on read.
                  fileName:integer;	  // Used in memory only. Write zero. Ignore on read.

                  sIndices:pointer;       // Used in memory only. Write zero. Ignore on read.

                  wData:single;           // The start of the array of data. Must be 64 bit aligned.
                end;

  WavePtr5=^TWaveHeader5 ;
  WaveHandle5=^WavePtr5 ;



implementation
end.
