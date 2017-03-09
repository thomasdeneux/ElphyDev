unit nsTemplateLib;

Simple exemple

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}
// nsTemplateLib.cpp : Defines the entry point for the DLL application
//                     All exported library functions are defined here
//
// This is a template source file to use as an example on how to create a Neuroshare
// DLL library.  Library functions are provided with hints on what to create and fill in.

// The following exported library functions are included here:
//	DllMain
//	ns_GetLibraryInfo
//	ns_OpenFile
//	ns_CloseFile
//	ns_GetFileInfo
//	ns_GetEntityInfo
//	ns_GetEventInfo;
//	ns_GetEventData;
//	ns_GetAnalogInfo;
//	ns_GetAnalogData;
//	ns_GetSegmentInfo;
//	ns_GetSegmentSourceInfo;
//	ns_GetSegmentData;
//	ns_GetNeuralInfo;
//	ns_GetNeuralData;
//	ns_GetIndexByTime;
//	ns_GetTimeByIndex;
//	ns_GetLastErrorMsg
//
//
//
// _stdcall calling conventions used for exported functions to make them compatible with
// application using both C++ and Pascal (VBasic) calling conventions.
// nsTemplateLib.def file is used to export the library functions and create the library
// nsTemplateLib.dll.  nsTemplateLib.def is placed in the same directory as the source file
// nsTemplateLib.cpp and linked with the source file


uses nsAPItypes;

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// DLL process local storage in the form of global variables
// (in Win32, each process linking a DLL gets its own copy of the DLL's global variables)
//
///////////////////////////////////////////////////////////////////////////////////////////////////

// Define any global handles or file catalogs.




///////////////////////////////////////////////////////////////////////////////////////////////////
//
//                               Exported Neuroshare functions
//
///////////////////////////////////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetLibraryInfo
//
// Retrieves information about the loaded API library
//
// Parameters:
//
//	ns_LIBRARYINFO *pLibraryInfo	pointer to ns_LIBRARYINFO structure to receive information
//	uint32 dwLibraryInfoSize		size in bytes of ns_LIBRARYINFO structure
//
// Return Values:
//
//	ns_OK							ns_LIBIRARYINFO successfully retrieved
//	ns_LIBEERROR					library error
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetLibraryInfo( var LibraryInfo: ns_LIBRARYINFO;  dwLibraryInfoSize: uint32):ns_Result;cdecl;
	// Verify validity of passed parameters
	// Null pointers mean that no information is returned
	// Fill in ns_LIBIRARYINFO structure with information for this library

	// result:= ns_OK;



///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_OpenFile
//
// Opens the data file and assigns a file handle for internal use by the library.
// Library is required to be able to handle a minimum of 64 simultaneously open data files, if
// system resources allow.
//
// Parameters:
//
//	char *pszFilename	name of file to open
//	uint32 *hFile		pointer to a file handle
//
// Return Values:
//
//	ns_OK				ns_LIBIRARYINFO successfully retrieved
//	ns_TYPEERROR		library unable to open file type
//	ns_FILEERROR		file access or read error
//	ns_LIBEERROR		library error
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_OpenFile(pszFilename: Pansichar; var hFile: uint32):ns_Result;cdecl;
    // Open data files and return file handles
    // Invalid file handles are NULL.
    // Create Neuroshare Entity types.  This is may be a good place to enumerate entities
    // fill in general information structures, reorganize data and create pointers to
    // the entity data values.

    // result:= ns_OK;;




///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetFileInfo
//
// Retrieve general information about the data file
//
// Parameters:
//
//	uint32 hFile				handle to NEV data file
//	ns_FILEINFO *pFileInfo		pointer to ns_FILEINFO structure that receives data
//	uint32 dwFileInfoSize		number of bytes in ns_FILEINFO
//
// Return Values:
//
//	ns_OK						function succeeded
//	ns_BADFILE					invalid file handle
//	ns_FILEERROR				file access or read error
//	ns_LIBERROR					library error, null pointer
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetFileInfo (  hFile: uint32; var pFileInfo: ns_FILEINFO;  dwFileInfoSize: uint32 ):ns_Result;cdecl;
  // Check validity of passed parameters
  // Fill in ns_FILEINFO structure with currently open file information
  // result:= ns_OK;;



///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_CloseFile
//  
// Close the opened data files.
//
// Parameters:
//
//	uint32 hFile				handle to NEV data file
//
// Return Values:
//
//	ns_OK						function succeeded
//	ns_BADFILE					invalid file handle
//	
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_CloseFile ( hFile: uint32):ns_result;cdecl;

  // Check validity of passed parameters
  // Close file, release handles and any other clean up
  //  result:= ns_OK;;



///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetEntityInfo
//  
// Retrieve general Entity information
//
// Parameters:
//
//	uint32 hFile				handle to NEV data file
//	uint32 dwEntityID			entity ID
//	ns_ENTITYINFO *pEntityInfo	pointer to ns_ENTITYINFO structure that receives information 
//	uint32 dwEntityInfoSize		number of bytes in ns_ENTITYINFO
//
// Return Values:
//
//	ns_OK						function succeeded
//	ns_BADFILE					invalid file handle
//	ns_LIBERROR					library error, null pointer
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetEntityInfo ( hFile: uint32;  dwEntityID: uint32; var pEntityInfo: ns_ENTITYINFO;  dwEntityInfoSize: uint32):ns_result;cdecl;
  // Check validity of passed parameters
  // Fill in ns_ENTITYINFO
  // result:= ns_OK;;



///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetEventInfo
//  
// Retrieve information for Event entities.
//
// Parameters:
//
//	uint32 hFile				handle to NEV data file
//	uint32 dwEntityID			Event entity ID
//	ns_EVENTINFO *pEventInfo	pointer to ns_EVENTINFO structure to receive information 
//	uint32 dwEventInfoSize		number of bytes in ns_EVENTINFO
//
// Return Values:
//
//	ns_OK						function succeeded
//	ns_BADFILE					invalid file handle
//  ns_BADENTITY				inappropriate or invalid entity identifier
//	ns_LIBERROR					library error, null pointer
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetEventInfo ( hFile: uint32;  dwEntityID: uint32; var pEventInfo: ns_EVENTINFO;  dwEventInfoSize: uint32):ns_result;cdecl;
  // Check validity of passed parameters
  // Fill in ns_EVENTINFO
  // result:= ns_OK;



///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetEventData
//  
// Retrieve the timestamp and Event entity data items.
//
// Parameters:
//  uint32 hFile                handle to NEV data file
//  uint32 dwEntityID           Event entity ID
//  uint32 nIndex               Event entity item number
//  double *pdTimeStamp         pointer to double timestamp (in seconds)
//  void   *pData               pointer to data buffer to receive data
//  uint32 dwDataBufferSize     number of bytes allocated to the receiving data buffer
//  uint32 *pdwDataRetSize      pointer to the actual number of bytes of data retrieved
//
// Return Values:
//  ns_OK                       function succeeded
//  ns_BADFILE                  invalid file handle
//  ns_BADENTITY                inappropriate or invalie entity identifier
//  ns_BADINDEX             	invalid entity index specified
//  ns_FILEERROR            	file access or read error
//  ns_LIBERROR                 library error, null pointer
//
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetEventData ( hFile: uint32;  dwEntityID: uint32;  nIndex: uint32;
                           var pdTimeStamp: double; pData: pointer;
                            dwDataBufferSize: uint32; var pdwDataRetSize: uint32):ns_result;cdecl;

// Check validity of passed parameters
// Fill in Event timestamp, data values and return size, if pointers are not NULL
// result:= ns_OK;;


///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetAnalogInfo
//
// Retrieve information for Analog entities
//
// Parameters:
//
//	uint32 hFile				handle to NEV data file
//	uint32 dwEntityID			Analog entity ID
//	ns_ANALOGINFO *pAnalogInfo	pointer to ns_ANALOGINFO structure to receive data
//	uint32 dwAnalogInfoSize		number of bytes in ns_ANALOGINFO
//
// Return Values:
//
//	ns_OK						function succeeded
//	ns_BADFILE					invalid file handle
//  ns_BADENTITY				inappropriate or invalie entity identifier
//	ns_LIBERROR					library error, null pointer
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetAnalogInfo (  hFile: uint32;  dwEntityID: uint32;
                             var pAnalogInfo: ns_ANALOGINFO;  dwAnalogInfoSize: uint32 ):ns_result;cdecl;
{
 	// Check validity of passed parameters
    #pragma message("ns_GetAnalogInfo - verify validity of passed parameters" )

	// Fill in ns_ANALOGINFO structure.
    #pragma message("ns_GetAnalogInfo - fill in ns_ANALOGINFO" )


    result:= ns_OK;;
}



///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetAnalogData
//
// Retrieve analog data in the buffer at pData.  If possible, dwIndexCount, number of analog data
// values are returned in the buffer.  If there are time gaps in the sequential values, the
// number of continuously sampled data items, before the first gap, is returned in pdwContCount.
//
// Parameters:
//
//	uint32 hFile			handle to NEV data file
//	uint32 dwEntityID		Analog entity ID
//	uint32 dwStartIndex		starting index to search for timestamp
//	uint32 dwIndexCount		number of timestamps to retrieve
//	uint32 *pdwContCount	pointer to count of the first non-sequential analog item
//	double *pData			pointer to data buffer to receive data values
//
// Return Values:
//
//	ns_OK						function succeeded
//	ns_BADFILE					invalid file handle
//  ns_BADENTITY				inappropriate or invalid entity identifier
//	ns_LIBERROR					library error, null pointer
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetAnalogData ( hFile: uint32;  dwEntityID: uint32;
                            dwStartIndex: uint32;  dwIndexCount: uint32;
                            var pdwContCount: uint32; var pData: double):ns_result;cdecl;
   // Check validity of passed parameters
   // Fill in data buffer pData, and the number of continuous analog data values,
   // if pointers are not NULL.
   // result:= ns_OK;


///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetSegmentInfo
//
// Retrieve information for Segment entities.
//
// Parameters:
//
//	uint32 hFile					handle to NEV data file
//	uint32 dwEntityID				Segment entity ID
//	ns_SEGMENTINFO *pSegmentInfo	pointer to ns_SEGMENTINFO structure to receive information
//	uint32 dwSegmentInfoSize		size in bytes of ns_SEGMENTINFO structure
//
// Return Values:
//
//	ns_OK							function succeeded
//	ns_BADFILE						invalid file handle
//	ns_BADENTITY					invalid or inappropriate entity identifier specified
//	ns_FILEERROR					file access or read error
//	ns_LIBERROR						library error
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetSegmentInfo (  hFile: uint32;  dwEntityID: uint32;
                              var pSegmentInfo: ns_SEGMENTINFO;  dwSegmentInfoSize: uint32):ns_result;cdecl;
    // Check validity of passed parameters
    // Fill in ns_SEGMENTINFO structure
    // result:= ns_OK;



///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetSegmentSourceInfo
//
// Retrieve information on the source, dwSourceID, generating segment entity dwEntityID.
//
// Parameters:
//
//	uint32 hFile					handle to NEV data file
//	uint32 dwEntityID				Segment entity ID
//	uint32 dwSourceID				entity ID of source
///	ns_SEGSOURCEINFO *pSourceInfo	pointer to ns_SEGSOURCEINFO structure to receive information
//	uint32 dwSourceInfoSize			size in bytes of ns_SEGSOURCEINFO structure
//
// Return Values:
//
//	ns_OK							function succeeded
//	ns_BADFILE						invalid file handle
//	ns_BADENTITY					invalid or inappropriate entity identifier specified
//	ns_FILEERROR					file access or read error
//	ns_LIBERROR						library error
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetSegmentSourceInfo (  hFile: uint32;  dwEntityID: uint32;  dwSourceID: uint32;
                                    var pSourceInfo: ns_SEGSOURCEINFO;
                                    dwSourceInfoSize: uint32):ns_result;cdecl;
    // Check validity of passed parameters
    // Fill in ns_SEGSOURCEINFO
    // result:= ns_OK;


///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetSegmentData
//  
// Retrieve segment data waveform and its timestamp.
// The number of data points read is returned at pdwSampleCount.
//
// Parameters:
//
//  uint32 hFile                    handle to NEV data file
//  uint32 dwEntityID               Segment entity ID
//  int32 nIndex                    Segment item index to retrieve
//  double *pdTimeStamp             pointer to timestamp to retrieve
//  double *pData                   pointer to data buffer to receive data
//  uint32 dwDataBufferSize         number of bytes available in the data buffer 
//  uint32 *pdwSampleCount          pointer to number of data items retrieved          
//  uint32 *pdwUnitID               pointer to unit ID of Segment data
//
// Return Values:
//
//	ns_OK							function succeeded
//	ns_BADFILE						invalid file handle
//	ns_BADENTITY					invalid or inappropriate entity identifier specified
//	ns_FILEERROR					file access or read error
//	ns_LIBERROR						library error
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetSegmentData (  hFile: uint32;  dwEntityID: uint32;  nIndex: int32;
                              var pdTimeStamp: double;  var pData: double;
                               dwDataBufferSize: uint32; var pdwSampleCount: uint32;
                               var pdwUnitID: uint32 ):ns_result;cdecl;
   // Check validity of passed parameters
   // Fill in timestamp, data values, number of data values retireved and unitID of requested
   // segment.  If any pointers are NULL, do not fill in information for that field.
   // result:= ns_OK;;




///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetNeuralInfo
//
// Retrieve information on Neural Events.
//
// Parameters:
//
//	uint32 hFile				handle to NEV data file
//	uint32 dwEntityID			Neural entity ID
//	ns_NEURALINFO *pNeuralInfo	pointer to ns_NEURALINFO structure to receive information
//	uint32 dwNeuralInfoSize		number of bytes in ns_NEURALINFO
//
// Return Values:
//
//	ns_OK						function succeeded
//	ns_BADFILE					invalid file handle
//  ns_BADENTITY				inappropriate or invalid entity identifier
//	ns_LIBERROR					library error, null pointer
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetNeuralInfo(  hFile: uint32;  dwEntityID: uint32;
                            var pNeuralInfo: ns_NEURALINFO;  dwNeuralInfoSize: uint32 ):ns_result;cdecl;
  // Check validity of passed parameters
  // Fill in ns_NEURALINFO structure
  // result:= ns_OK;;



///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetNeuralData
//
// Retrieve requested number of Neural event timestamps (in sec)
//
// Parameters:
//
//	uint32 hFile				handle to NEV data file
//	uint32 dwEntityID			Neural event entity ID
//	uint32 dwStartIndex			index of first Neural event item time to retrieve
//  uint32 dwIndexCount			number of Neural event items to retrieve
//	double *pData				pointer to buffer to receive times
//
// Return Values:
//
//	ns_OK						function succeeded
//	ns_BADFILE					invalid file handle
//  ns_BADENTITY				inappropriate or invalie entity identifier
//	ns_LIBERROR					library error, null pointer

///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetNeuralData(  hFile: uint32;  dwEntityID: uint32;  dwStartIndex: uint32;
                             dwIndexCount: uint32; pData: pointer ):ns_result;cdecl;
    // Check validity of passed parameters
    // Retrieve requested double timestamps (sec) in pData, if not NULL
    // result:= ns_OK;;



///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetIndexByTime
//
// Given the time (sec), return the closest data item index, The item's location relative to the
// requested time is specified by nFlag.
//
// Parameters:
//
//	uint32 hFile				handle to NEV data file
//	uint32 dwEntityID			entity ID to search for
//	uint32 dwSearchTimeStamp	timestamp of item to search for
//	int32 nFlag					position of item relative to the requested timestamp
//	uint32 *pdwIndex			pointer to index of item to retrieve
//
// Return Values:
//
//	ns_OK						function succeeded
//	ns_BADFILE					invalid file handle
//	ns_LIBERROR					library error, null pointer
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetIndexByTime(  hFile: uint32;  dwEntityID: uint32;  dTime: double;
                             nFlag: int32;  var pdwIndex: uint32 ):ns_result;cdecl;

   // Check validity of passed parameters
   // Search for entity item closest to the specified time, dTime
   // and return its index, pdwIndex, position.
   // result:= ns_OK;




///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetTimeByIndex
//
// Given an index for an entity data item, return the time in seconds.
//
// Parameters:
//
//	uint32 hFile			handle to NEV data file
//	uint32 dwEntityID		entity ID to search for
//	uint32 dwIndex			index of entity item to search for
//	double *pdTime			time of entity to retrieve
//
// Return Values:
//
//	ns_OK						function succeeded
//	ns_BADFILE					invalid file handle
//	ns_LIBERROR					library error, null pointer
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetTimeByIndex( hFile: uint32;  dwEntityID: uint32;  dwIndex: uint32; var pdTime: double):ns_result;cdecl;
    // Check validity of passed parameters
    // Search for time of the entity item specified by index, dwIndex
    // and return its timestamp in seconds, pdTime
    // result:= ns_OK;



///////////////////////////////////////////////////////////////////////////////////////////////////
// ns_GetLastErrorMsg
//
// Purpose:
//
//  Retrieve the most recent error text message
//
// Parameters:
//
//  char *pszMsgBuffer			pointer to text buffer to receive error message
//  uint32 dwMsgBufferSize		size in bytes of text buffer
//
// Return Values:
//
//  ns_OK                       function succeeded
//  ns_LIBERROR                 library error
//
///////////////////////////////////////////////////////////////////////////////////////////////////
function ns_GetLastErrorMsg(pszMsgBuffer: Pansichar;  dwMsgBufferSize: uint32):ns_result;cdecl;
  	// Check validity of passed parameters
	// Retrieve most recent error text message in pszMsgBuffer and the size in bytes
        // of the error message in dwMsgBufferSize.
	//result:= ns_OK;;

implementation

function ns_GetLibraryInfo( var LibraryInfo: ns_LIBRARYINFO;  dwLibraryInfoSize: uint32):ns_result;
begin
  result:=ns_OK;
end;

function ns_OpenFile(pszFilename: Pansichar; var hFile: uint32):ns_Result;
begin
end;

function ns_GetFileInfo (  hFile: uint32; var pFileInfo: ns_FILEINFO;  dwFileInfoSize: uint32 ):ns_Result;
begin
end;

function ns_CloseFile ( hFile: uint32):ns_Result;
begin
end;

function ns_GetEntityInfo ( hFile: uint32;  dwEntityID: uint32; var pEntityInfo: ns_ENTITYINFO;  dwEntityInfoSize: uint32):ns_Result;
begin
end;

function ns_GetEventInfo ( hFile: uint32;  dwEntityID: uint32; var pEventInfo: ns_EVENTINFO;  dwEventInfoSize: uint32):ns_Result;
begin
end;

function ns_GetEventData ( hFile: uint32;  dwEntityID: uint32;  nIndex: uint32;
                           var pdTimeStamp: double; pData: pointer;
                            dwDataBufferSize: uint32; var pdwDataRetSize: uint32):ns_Result;
begin
end;

function ns_GetAnalogInfo (  hFile: uint32;  dwEntityID: uint32;
                             var pAnalogInfo: ns_ANALOGINFO;  dwAnalogInfoSize: uint32 ):ns_Result;
begin
end;

function ns_GetAnalogData ( hFile: uint32;  dwEntityID: uint32;
                            dwStartIndex: uint32;  dwIndexCount: uint32;
                            var pdwContCount: uint32; var pData: double):ns_Result;
begin
end;

function ns_GetSegmentInfo (  hFile: uint32;  dwEntityID: uint32;
                              var pSegmentInfo: ns_SEGMENTINFO;  dwSegmentInfoSize: uint32):ns_Result;
begin
end;

function ns_GetSegmentSourceInfo (  hFile: uint32;  dwEntityID: uint32;  dwSourceID: uint32;
                                    var pSourceInfo: ns_SEGSOURCEINFO;
                                    dwSourceInfoSize: uint32):ns_Result;
begin
end;

function ns_GetSegmentData (  hFile: uint32;  dwEntityID: uint32;  nIndex: int32;
                              var pdTimeStamp: double;  var pData: double;
                               dwDataBufferSize: uint32; var pdwSampleCount: uint32;
                               var pdwUnitID: uint32 ):ns_Result;
begin
end;

function ns_GetNeuralInfo(  hFile: uint32;  dwEntityID: uint32;
                            var pNeuralInfo: ns_NEURALINFO;  dwNeuralInfoSize: uint32 ):ns_Result;
begin
end;

function ns_GetNeuralData(  hFile: uint32;  dwEntityID: uint32;  dwStartIndex: uint32;
                             dwIndexCount: uint32; pData: pointer ):ns_Result;
begin
end;

function ns_GetIndexByTime(  hFile: uint32;  dwEntityID: uint32;  dTime: double;
                             nFlag: int32;  var pdwIndex: uint32 ):ns_Result;
begin
end;

function ns_GetTimeByIndex( hFile: uint32;  dwEntityID: uint32;  dwIndex: uint32; var pdTime: double):ns_Result;
begin
end;

function ns_GetLastErrorMsg(pszMsgBuffer: Pansichar;  dwMsgBufferSize: uint32):ns_Result;
begin
end;


end.
