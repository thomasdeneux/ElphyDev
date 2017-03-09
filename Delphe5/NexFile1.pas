unit NexFile1;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

uses classes, sysutils, util1;


(*
  1. NEX FILE STRUCTURE
  ------------------------

  Nex data file has the following structure:

	- file header (structure NexFileHeader)
	- variable headers (structures NexVarHeader)
	- variable data (stored as binary arrays, depends on data type)

  Each variable header contains the size of the array that stores
  the variable data as well as the location of this array in the file.

  2. NEX FILE HEADERS
  -------------------

  2.1. NexFileHeader contains the following information:
  (full definition of NexFileHeader is provided below)

	int  Version; // 100 to 104
	char Comment[256]; // file comment
	double Frequency;  // timestamp frequency - tics per second
	int  Beg;	// usually 0, minimum of all the timestamps in the file
	int  End;	// = maximum timestamp + 1
	int  NumVars;    // number of variables (and variable headers) in the file

    NexFileHeader is followed by variable headers.

  2.2. NexVarHeader contains the following information:
  (full definition of NexVarHeader is provided below)

  	int  Type; // 0-neuron, 1-event, 2-interval, 3-waveform,
	           // 4-population vector, 5-continuous variable, 6 - marker
	char Name[64]; // variable name
	int  DataOffset; // where the data array for this variable
					//is located in the file
	int  Count;  // number of events, intervals, waveforms, or fragments
	double XPos; // neuron only, electrode position in (0,100) range
	double YPos; //  neuron only, electrode position in (0,100) range
	double WFrequency; // waveforms and continuous vars only,
					// sampling frequency
	double ADtoMV; // waveforms and continuous vars only,
				//coeff. to convert from A/D values to milliVolts.
	int  NPointsWave; // waveforms and continuous vars. only,
				// waveforms: number of points in each wave
				// continuous vars.: total number of a/d valus

	int	 NMarkers; // how many values are associated with each marker
	int	 MarkerLength; // how many characters are in each marker value


  3. HOW DATA ARE STORED
  ---------------------

    3.1. Neurons and events (VarHeader.Type = 0 or VarHeader.Type = 1).

	  The timestamps are stored as arrays of 4-byte integers.
		NexVarHeader vh;
		int timestamps[10000];
		// seek to the start of data
		fseek(fp,  vh.DataOffset, SEEK_SET);
		// read the timestamps, 4 bytes per timestamp
		fread(timestamps, vh.Count*4, 1, fp);

    3.2. Interval variables (VarHeader.Type = 2)

	  Interval beginnings and interval ends are stored as 2
	  arrays of 4-byte integers.
		NexVarHeader vh;
		int beginnings[10000], ends[10000];
		// seek the start of data
		fseek(fp,  vh.DataOffset, SEEK_SET);
		// read interval beginnings and ends
		fread(starts, vh.Count*4, 1, fp);
		fread(ends, vh.Count*4, 1, fp);

     3.3  Waveform variables (VarHeader.Type = 3)

	  The data for a waveform variable are stored as:
	  - array of timestamps (4-byte integers)
	  - array of waveform values (2-byte integers, raw A/D values)
	    for all the waveforms

		NexVarHeader vh;
		int timestamps[10000];
		short waveforms[32*10000];
		fseek(fp,  vh.DataOffset, SEEK_SET);
		fread(timestamps, vh.Count*4, 1, fp);
		fread(waveforms, vh.Count*vh.NPointsWave*2, 1, fp);

  		You also need to use the following fields in the variable header:
		vh.WFrequency = 25000; // this is a/d frequency of the waveform values, 25 kHz
		vh.ADtoMV = 1.; // this is a coefficient to convert a/d values to millivolts.
		// 1. here means that the stored a/d values are in millivolts.

    3.4  Continuously recorded variables (VarHeader.Type = 5)

      In general, a continuous variable may contain several fragments of data.
      Each fragment may be of different length. We don't store the timestamps
	  for all the a/d values since they would use too much space. Instead,
	  for each fragment we store the timestamp of the first a/d value in
	  the fragment and the index of the first data point in the fragment.

	  Therefore, a continous variable contains the following 3 arrays:

      - array of all a/d values (stored as 2-byte integers)
		NexVarHeader.NPointsWave field stores the number of a/d values

      - array of timestamps (each timestamp is for the beginning of the fragment;
        timestamps are in the same units as any other timestamps, i.e. usually
        in 25 usec units for Plexon data)
		NexVarHeader.Count field stores the number of fragments

      - array of indexes (each index is the position of the first data point
        of the fragment in the a/d array; index[0] is always 0, if index[1] = 200,
        it means that the second fragment is advalues[200], advalues[201], etc.)

		NexVarHeader vh;
		// assume that we have less than 100 fragments and less than 10000
		// a/d values
		int fragment_timestamps[100];
		int fragment_indexes[100];
		short advalues[10000];
		fseek(fp,  vh.DataOffset, SEEK_SET);
		fread(fragment_timestamps, vh.Count*4, 1, fp);
		fread(fragment_indexes, vh.Count*4, 1, fp);
		fread(advalues, vh.NPointsWave*2, 1, fp);

		You also need to use the following fields in the variable header:
		vh.WFrequency = 10; // this is a/d frequency, 10 data points per second
		vh.ADtoMV = 1; // this is a coefficient to convert a/d values to millivolts.
		// 1. here means that the stored a/d values are in millivolts.



    3.5 Markers (VarHeader.Type = 6)

       In general, a marker variable may contain several data fields, i.e.
       for each timestamp there are several values associated with this
       timestamp. The values of these data fields are stored as strings.

       If you are using Plexon system, there is only one data field for
       each timestamp (the strobed value) and the numerical strobed values
       are stored as strings. If you need the numerical strobed values,
       you'll have to convert strings to numbers.

		The data are stored in the following way:

		- array of timestamps
		for each field:
			- field names (each field name uses 64 bytes in the file)
			- array of field values (each value uses MarkerLength bytes in the file)

		When you read variable headers, check for Type = 6

	    Use then the following NexVarHeader fields:

			Name - variable name
			Count - number of timestamps
			NMarkers - number of data fields for each timestamp
			MarkerLength - length of each data field string
			DataOffset - where the data starts in the file

		  Here is the code to read the marker variable:

  			// read the variable header
			NexVarHeader sh;
			int* timestamps = 0;
			// assume that we have less than 16 fields
			char fieldnames[16][64];
			// assume that marker strings are shorter than 1024 characters
			char buf[1024];
			fread(&sh, sizeof(NexVarHeader), 1, fp);
			if(sh.Type == 6){
				timestamps = new int[sh.Count];
			}

			// seek to the variable data
			fseek(fp,  sh.DataOffset, SEEK_SET);

			// read the timestamps
			fread(timestamps, sh.Count*4, 1, fp);

			// read the field names and values
			for(i=0; i<sh.NMarkers; i++){
				// read the name of the data fields
				fread(fieldnames[i], 64, 1, fp);
				for(j=0; j<sh.Count; j++){
					// this is the i-th field for j-th timestamp
					fread(buf, sh.MarkerLength, 1, fp);
				}
			}


    4. Header Sizes
    ---------------

	Header sizes (to check integer sizes and structure alignment):

	sizeof(NexFileHeader) = 544
	sizeof(NexVarHeader) = 208

*)


// Nex file header structure
type
  TNexFileHeader =
      record
	MagicNumber: integer;           // string NEX1
	Version: integer;               // 100
	Comment: array[1..256] of AnsiChar;
	Frequency: double;              // timestamped freq. - tics per second
	Beg: integer;                   // usually 0
	End1: integer;	                // = maximum timestamp + 1
	NumVars: integer;               // number of variables in the first batch
	HeaderOffset: integer;          // position of the next file header in the file
	                                //, not implemented yet
	Padding: array[1..256] of byte; // future expansion
      end;

// Nex variable header structure
  TNexVarHeader =
      record
	Type1: integer;                 // 0 - neuron, 1 event, 2- interval, 3 - waveform, 4 - pop. vector, 5 - continuously recorded
	Version: integer;               // 100
	Name: array[1..64] of AnsiChar;     // variable name
	DataOffset:integer;             // where the data array for this variable is located in the file
	Count: integer;                 // number of events, intervals, waveforms or weights
	WireNumber: integer;            // neuron only, not used now
	UnitNumber: integer;            // neuron only, not used now
	Gain: integer;                  // neuron only, not used now
	Filter: integer;                // neuron only, not used now
	XPos: double;                   // neuron only, electrode position in (0,100) range, used in 3D
	YPos: double ;                  // neuron only, electrode position in (0,100) range, used in 3D
	WFrequency: double ;            // waveform and continuous vars only, w/f sampling frequency
	ADtoMV: double ;                // waveform continuous vars only, coeff. to convert from A/D values to Millivolts.
	NPointsWave: integer;           // waveform only, number of points in each wave
	NMarkers: integer;              // how many values are associated with each marker
	MarkerLength: integer;          // how many characters are in each marker value
	Padding: array[1..68] of AnsiChar;
      end;


{ procedure testNexFile(stf:string); }

implementation

(*
uses TestNsDll;

procedure testNexFile(stf:string);
var
  f:TfileStream;
  NexHeader: TNexFileHeader;
  NexVar: array[0..200] of TNexVarHeader;
  i,ii:integer;
begin
  f:=TfileStream.Create(stf,fmOpenRead );

  f.Read(NexHeader,sizeof(NexHeader));
  with NexHeader do
  begin
    NeuroShareTest.Memo1.Lines.Add( PcharToString(@Comment,256)+'  NumVars='+Istr(NumVars) );
    NeuroShareTest.Memo1.Lines.Add( 'Frequency =  '+Estr(frequency ,3) );
  end;

  for i:=0 to NexHeader.NumVars-1 do
  begin
    f.Read(NexVar[i],sizeof(NexVar[i]));
    with Nexvar[i] do
      NeuroShareTest.Memo1.Lines.Add( PcharToString(@name,64)+'  Type='+Istr(Type1)+'  Count='+Istr(count) );
  end;

  NeuroShareTest.Memo1.Lines.Add('           Data Var  ');

  with NexVar[1] do
  begin
    f.Seek(dataOffset, soFromBeginning);
    for i:=0 to count-1 do
    begin
      f.Read(ii,4);
      NeuroShareTest.Memo1.Lines.Add('         '+Istr(ii));
    end;
  end;

  f.free;

end;
*)

end.
