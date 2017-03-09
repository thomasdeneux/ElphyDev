unit nsAPItypes;

interface
{$IFDEF FPC} {$mode delphi} {$DEFINE AcqElphy2} {$A1} {$Z1} {$ENDIF}

          ///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2003  Neuroshare Project
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// A copy of the GNU Lesser General Public License can be obtained by writing to:
//  Free Software Foundation, Inc.,
//  59 Temple Place, Suite 330,
//  Boston, MA  02111-1307
//  USA
//
// Contact information:
//  Angela Wang
//  CyberKinetics, Inc.,
//  391 G Chipeta Way
//  Salt Lake City,  UT  84108
//  USA
//  angela@bionictech.com
//
// Website:
//	www.neuroshare.org
//
// All other copyrights on this material are replaced by this license agreeement.
//
///////////////////////////////////////////////////////////////////////////////////////////////////
(* $Workfile: nsAPItypes.h $
*)
//
// File version  : 1.0
//
// Specification : based on Neuroshare API specification version 1.0
//
// Description   : This header file contains C declarations for constants, types,
//                 and structures defined in the Neuroshare API specification document
//
// Authors       : Shane Guillory, Angela Wang
//
(* $Date: 2/21/03 11:45a $
*)
//
(* $History: nsAPItypes.h $
//
// *****************  Version 1  *****************
// User: Angela       Date: 2/21/03    Time: 11:45a
// Created in $/Neuroshare/nsNEVLibrary
// Version 1.0 Neuroshare Specifications
//
// *****************  Version 1  *****************
// User: Angela       Date: 2/17/03    Time: 11:22a
// Created in $/Neuroshare/nsNEVLibrary
// Neuroshare API Ver 1.0 compliant header files
//
// *****************  Version 1  *****************
// User: Angela       Date: 2/13/03    Time: 9:29a
// Created in $/Neuroshare/nsNEVLibrary
 *
 * *****************  Version 5  *****************
 * User: Angela       Date: 1/14/03    Time: 9:42a
 * Updated in $/Neuroshare/nsNEVLibrary
 * Fixed location of brackets in structures
 *
 * *****************  Version 4  *****************
 * User: Angela       Date: 1/10/03    Time: 12:13p
 * Updated in $/Neuroshare/nsNEVLibrary
 * Reword disclaimer
 *
 * *****************  Version 3  *****************
 * User: Angela       Date: 1/09/03    Time: 12:14p
 * Updated in $/Neuroshare/nsNEVLibrary
 * Add copyright, disclaimer and file header

    v0.9b - Functions changed to use __stdcall calling convention for compatibility
        with Visual Basic. Function prototype declarations also changed to
        all-capital versions of the neuroshare function names.
    v0.9b - First public release..
*)
///////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////
//
//	Additional Remarks
//
//  - The members of the Neuroshare API structures are defined on 4-byte boundaries.  Make sure to
//    compile all with 4-byte or smaller alignement
//
///////////////////////////////////////////////////////////////////////////////////////////////////

const
  ns_LIBVERSION = 0100;  // version 01.00

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Fixed storage size definitions for declared variables
// (includes conditional testing so that there is no clash with win32 headers)
//
///////////////////////////////////////////////////////////////////////////////////////////////////

type
   int8 = shortint;
   uint8 = byte;
   int16 = smallint;
   uint16 = word;
   int32 = longint;
   uint32 = longword;

{$ALIGN 4 }


///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Library Return Code Definitions
//
///////////////////////////////////////////////////////////////////////////////////////////////////

type
  ns_RESULT = int32;

Const
  ns_OK        =  0;  //Function Successful
  ns_LIBERROR  = -1;  //Linked Library Error
  ns_TYPEERROR = -2;  //Library unable to open file type
  ns_FILEERROR = -3;  //File access or read Error
  ns_BADFILE   = -4;  //Invalid file handle passed to function
  ns_BADENTITY = -5;  //Invalid or inappropriate entity identifier specified
  ns_BADSOURCE = -6;  //Invalid source identifier specified
  ns_BADINDEX  = -7;  //Invalid entity index or index range specified

///////////////////////////////////////////////////////////////////////////////////////////////////
//
// Definitions of constants and flags
//
///////////////////////////////////////////////////////////////////////////////////////////////////

// Library description flags
Const
  ns_LIBRARY_DEBUG         = $01;  // includes debug info linkage
  ns_LIBRARY_MODIFIED      = $02;  // file was patched or modified
  ns_LIBRARY_PRERELEASE    = $04;  // pre-release or beta version
  ns_LIBRARY_SPECIALBUILD  = $08;  // different from release version
  ns_LIBRARY_MULTITHREADED = $10;  // library is multithread safe

//Definitions of Event Entity types
  ns_EVENT_TEXT  = 0;  // null-terminated ascii text string
  ns_EVENT_CSV   = 1;  // comma separated ascii text values
  ns_EVENT_BYTE  = 2;  // 8-bit value
  ns_EVENT_WORD  = 3;  // 16-bit value
  ns_EVENT_DWORD = 4;  // 32-bit value

//Definitions of entity types in the structure ns_ENTITYINFO
  ns_ENTITY_UNKNOWN     = 0;	 // unknown entity type
  ns_ENTITY_EVENT       = 1;	 // Event entity
  ns_ENTITY_ANALOG      = 2;	 // Analog entity
  ns_ENTITY_SEGMENT     = 3;	 // Segment entity
  ns_ENTITY_NEURALEVENT = 4;	 // Sorted Neural entity

//Flags used for locating data entries
  ns_BEFORE  = -1;  // less than or equal to specified time
  ns_CLOSEST =  0;  // closest time
  ns_AFTER   = +1;  // greater than or equal to specified time

///////////////////////////////////////////////////////////////////////////////////////////////////
//
//			 DLL library version information functions
//
///////////////////////////////////////////////////////////////////////////////////////////////////

//File descriptor structure
type
  ns_FILEDESC = record
	          szDescription: array[1..32] of char;  // Text description of the file type or file family
	          szExtension: array[1..8] of char;     // Extension used on PC, Linux, and Unix Platforms
	          szMacCodes: array[1..8] of char;      // Application and Type Codes used on Mac Platforms
	          szMagicCode: array[1..16] of char;    // Null-terminated code used at the file beginning
                end;
  ns_PFILEDESC=^ns_FILEDESC;

// Library information structure
  ns_LIBRARYINFO =
     record
       dwLibVersionMaj : uint32;              // Major version number of library
       dwLibVersionMin : uint32;	        // Minor version number of library
       dwAPIVersionMaj : uint32;              // Major version number of API
       dwAPIVersionMin : uint32;	        // Minor version number of API
       szDescription : array[1..64] of char;  // Text description of the library
       szCreator : array[1..64] of char;      // Name of library creator
       dwTime_Year : uint32;                  // Year of last modification date
       dwTime_Month : uint32;                 // Month (0-11; January = 0) of last modification date
       dwTime_Day : uint32;                   // Day of the month (1-31) of last modification date
       dwFlags : uint32;                      // Additional library flags
       dwMaxFiles : uint32;                   // Maximum number of files library can simultaneously open
       dwFileDescCount : uint32;              // Number of valid description entries in the following array
       FileDesc : array[1..16] of ns_FILEDESC;// Text descriptor of files that the DLL can interpret
     end;
  Pns_LIBRARYINFO = ^ns_LIBRARYINFO;

// File information structure (the time of file creation should be reported in GMT)
  ns_FILEINFO=
    record
      szFileType : array[1..32] of char;      // Manufacturer's file type descriptor
      dwEntityCount : uint32;                 // Number of entities in the data file.
      dTimeStampResolution : double;          // Minimum timestamp resolution
      dTimeSpan : double;                     // Time span covered by the data file in seconds
      szAppName : array[1..64] of char;       // Name of the application that created the file
      dwTime_Year : uint32;                   // Year the file was created
      dwTime_Month : uint32;                  // Month (0-11; January = 0)
      dwTime_DayofWeek : uint32;              // Day of the week (0-6; Sunday = 0)
      dwTime_Day : uint32;                    // Day of the month (1-31)
      dwTime_Hour: uint32;                    // Hour since midnight (0-23)
      dwTime_Min : uint32;                    // Minute after the hour (0-59)
      dwTime_Sec : uint32;                    // Seconds after the minute (0-59)
      dwTime_MilliSec : uint32;		      // Milliseconds after the second (0-1000)
      szFileComment : array[1..256] of char;  // Comments embedded in the source file
    end;
  Pns_FILEINFO = ^ns_FILEINFO;

// General entity information structure
  ns_ENTITYINFO=
    record
      szEntityLabel : array[1..32] of char;   // Specifies the label or name of the entity
      dwEntityType : uint32;                  // One of the ns_ENTITY_* types defined above
      dwItemCount : uint32;                   // Number of data items for the specified entity in the file
    end;
  Pns_ENTITYINFO = ^ns_ENTITYINFO;

// Event entity information structure
  ns_EVENTINFO =
    record
       dwEventType : uint32;                // One of the ns_EVENT_* types defined above
       dwMinDataLength : uint32;            // Minimum number of bytes that can be returned for an Event
       dwMaxDataLength : uint32;	    // Maximum number of bytes that can be returned for an Event
       szCSVDesc : array[1..128] of char;   // Description of the data fields for CSV Event Entities
    end;
  Pns_EVENTINFO = ^ns_EVENTINFO;

// Analog information structure
   ns_ANALOGINFO =
     record
	dSampleRate: double;                   // The sampling rate in Hz used to digitize the analog values
	dMinVal: double	;                      // Minimum possible value of the input signal
	dMaxVal: double;                       // Maximum possible value of the input signal
	szUnits: array[1..16] of char;         // Specifies the recording units of measurement
	dResolution: double;                   // Minimum resolvable step (.0000305 for a +/-1V 16-bit ADC)
	dLocationX: double;                    // X coordinate in meters
	dLocationY: double;                    // Y coordinate in meters
	dLocationZ: double;                    // Z coordinate in meters
	dLocationUser: double;                 // Additional position information (e.g. tetrode number)
	dHighFreqCorner: double;               // High frequency cutoff in Hz of the source signal filtering
	dwHighFreqOrder: uint32;               // Order of the filter used for high frequency cutoff
	szHighFilterType: array[1..16] of char;// Type of filter used for high frequency cutoff (text format)
	dLowFreqCorner: double;                // Low frequency cutoff in Hz of the source signal filtering
	dwLowFreqOrder: uint32;                // Order of the filter used for low frequency cutoff
	szLowFilterType: array[1..16] of char; // Type of filter used for low frequency cutoff (text format)
	szProbeInfo: array[1..128] of char;    // Additional text information about the signal source
     end;
   Pns_ANALOGINFO = ^ns_ANALOGINFO;

//Segment Information structure
  ns_SEGMENTINFO =
     record
	dwSourceCount: uint32;         // Number of sources in the Segment Entity, e.g. 4 for a tetrode
	dwMinSampleCount: uint32;      // Minimum number of samples in each Segment data item
	dwMaxSampleCount: uint32;      // Maximum number of samples in each Segment data item
	dSampleRate: double;           // The sampling rate in Hz used to digitize source signals
	szUnits: array[1..32] of char; // Specifies the recording units of measurement
     end;
  Pns_SEGMENTINFO = ^ns_SEGMENTINFO;

// Segment source information structure
  ns_SEGSOURCEINFO =
     record
	dMinVal: double;                        // Minimum possible value of the input signal
	dMaxVal: double;                        // Maximum possible value of the input signal
	dResolution: double;                    // Minimum input step size that can be resolved
	dSubSampleShift: double;                // Time diff btn timestamp and actual sampling time of source
	dLocationX: double;                     // X coordinate of source in meters
	dLocationY: double;                     // Y coordinate of source in meters
	dLocationZ: double;                     // Z coordinate of source in meters
	dLocationUser: double;                  // Additional position information (e.g tetrode number)
	dHighFreqCorner: double;                // High frequency cutoff in Hz of the source signal filtering
	dwHighFreqOrder: uint32;                // Order of the filter used for high frequency cutoff
	szHighFilterType: array[1..16] of char; // Type of filter used for high frequency cutoff (text format)
	dLowFreqCorner: double;		        // Low frequency cutoff in Hz of the source signal filtering
	dwLowFreqOrder: uint32;                 // Order of the filter used for low frequency cutoff
        szLowFilterType: array[1..16] of char;	// Type of filter used for low frequency cutoff (text format)
        szProbeInfo: array[1..128] of char;     // Additional text information about the signal source
     end;
  Pns_SEGSOURCEINFO = ^ns_SEGSOURCEINFO;

// Neural Information structure
  ns_NEURALINFO =
    record
       dwSourceEntityID: uint32;            // Optional ID number of a source entity
       dwSourceUnitID: uint32;              // Optional sorted unit ID number used in the source entity
       szProbeInfo: array[1..128] of char;  // Additional probe text information or source entity label
    end;
  Pns_NEURALINFO = ^ns_NEURALINFO;


implementation

end.
