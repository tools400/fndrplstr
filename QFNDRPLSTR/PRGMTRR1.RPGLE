**free
//**************************************************************************************
// PRGMTRR1: Progress meter
// Copyright (C) 2001  Martin Rowe   <martin@dbg400.net>           Original  Version
//               2001  Th. Raddatz   <thomas.raddatz@tools400.de>  Procedure Version
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
//**************************************************************************************
//   >>PRE-COMPILER<<
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +
//                              SRCFILE(&SL/&SF) +
//                              SRCMBR(&SM);
//     >>COMPILE<<
//       >>PARM<< TRUNCNBR(*NO);
//       >>PARM<< DBGVIEW(*LIST);
//       >>PARM<< OPTION(*EVENTF);                                     *
//     >>END-COMPILE<<
//     >>EXECUTE<<
//   >>END-PRE-COMPILER<<
//**************************************************************************************
ctl-opt nomain;
/copy QFNDRPLSTR,H_SPEC
//**************************************************************************************

//  Global fields
dcl-s g_text char(20) inz;
dcl-s g_maxValue int(10) inz;
dcl-s g_marker char(1) inz;
dcl-s g_waitSec int(10) inz;

dcl-s g_jobtype char(1) inz;
dcl-s g_showPrgMtr ind inz;
dcl-s g_lastPercentage packed(3) inz;
dcl-s g_lastTmStmp timestamp inz;

dcl-c cTrue *on;
dcl-c cFalse *on;

dcl-c cSCR_MODE_DS3 '*DS3';
dcl-c cSCR_MODE_DS4 '*DS4';

dcl-c cSCR_COLUMN_DS3 80;
dcl-c cSCR_COLUMN_DS4 132;

//  Type definitions
dcl-ds errCode_t qualified based(pDummy);
  bytPrv  int(10);
  bytAvl  int(10);
  excId   char(7);
  res01   char(1);
  excData char(256);
end-ds;

//  Exported procedures
/copy QFNDRPLSTR,PPRGMTRR1

//  Private Prototypen
dcl-pr lf_getNumDspCol uns(10);
end-pr;

dcl-pr lf_getScreenMode char(10);
end-pr;

//Prototype for 'QUSRJOBI'

//  Retrieve Job Information (QUSRJOBI) API
dcl-pr qusrjobi extpgm('QUSRJOBI');
  o_rcvVar     char(65535) options(*varsize);
  i_rcvVarLen  int(10) const;
  i_format     char(8) const;
  i_qJob       char(26) const;
  i_intJobID   char(16) const;
  io_errCode   char(65535) options(*nopass: *varsize); // OptGrp 1
  i_resPrfStat char(1) options(*nopass) const; // OptGrp 2
end-pr;

//  Send Program Message (QMHSNDPM) API
dcl-pr qmhsndpm extpgm('QMHSNDPM');
  i_msgid      char(7) const;
  i_qmsgf      char(20) const;
  i_msgdata    char(32767) options(*varsize) const;
  i_length     int(10) const;
  i_msgtype    char(10) const;
  i_callstke   char(256) const;
  i_callstkc   int(10) const;
  o_msgkey     char(4);
  io_errcode   char(32767) options(*varsize);
  i_lenstke    int(10) options(*nopass) const; // optGrp 1
  i_callstkeq  char(20) options(*nopass) const;
  i_wait       int(10) options(*nopass) const;
  i_callstkedt char(10) options(*nopass) const; // optGrp 2
  i_ccsid      int(10) options(*nopass) const;
end-pr;

//===============================================================*
//  Initialize Progress Meter
//===============================================================*

dcl-proc p_inzProgressMeter export;
  dcl-pi *n;
    i_text     char(20) value;
    i_maxValue int(10) value;
    i_marker   char(1) options(*nopass) value;
    i_waitSec  int(10) options(*nopass) value;
    i_jobType  char(10) options(*nopass) value;
  end-pi;

  //  Optional parameter positions
  dcl-c p_marker 3;
  dcl-c p_waitSec 4;
  dcl-c p_jobType 5;

  //  Optional parameter fields
  dcl-s marker like(i_marker) inz;
  dcl-s waitSec like(i_waitSec) inz;
  dcl-s jobType like(i_jobType) inz;

  //  Local helper fields
  dcl-s p_rcvr char(100) inz;
  dcl-s p_rcvrLen int(10) inz(%size(p_rcvr));
  dcl-s p_format char(8) inz('JOBI0100');
  dcl-s p_thisJob char(26) inz('*');
  dcl-s p_intJob char(16) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //  Process optional parameters ...
  //  ... i_marker
  If %parms >= p_marker;
    marker = i_marker;
  Else;
    marker = cPrgMtr_Blue;
  Endif;

  //  ... 'i_waitSec'
  If %parms >= p_waitSec;
    waitSec = i_waitSec;
  Else;
    waitSec = 0;
  Endif;

  //  ... 'i_jobType'
  If %parms >= p_jobType;
    jobType = i_jobType;
  Else;
    jobType = cPrgMtr_JobType_All;
  Endif;

  // Determine job type (interactive or batch)
  QUSRJOBI ( p_rcvr : p_rcvrLen : p_format
  : p_thisJob : p_intJob );

  // Set processing attributes ...
  g_jobType = %subst(p_rcvr : 61 :1);

  g_text        = i_text;
  g_maxValue    = i_maxValue;
  g_waitSec     = waitSec;

  g_lastPercentage = -1;
  g_lastTmStmp     = *LOVAL;

  // ... if an attribute below x'20' (normal green) specified,
  //     swap for yellow reverse (safer)
  If marker < X'20';
    g_Marker = cPrgMtr_Yellow;
  Else;
    g_marker = marker;
  Endif;

  // ... change marker acording to job type
  If (g_jobType = 'B') and (g_marker < ' ');
    g_marker = '#';
  Endif;

  //  ... check whether the progress meter must be shown for jobs of type ...
  Select;
  //      ... all Jobs
  When jobType = cPrgMtr_JobType_All;
    g_showPrgMtr = cTrue;
  //      ... interactive jobs
  When jobType = cPrgMtr_JobType_Dlg;
    If g_jobType <> 'B';
      g_showPrgMtr = cTrue;
    Else;
      g_showPrgMtr = cFalse;
    Endif;
  //      ... batch jobs
  When jobType = cPrgMtr_JobType_Batch;
    If g_jobType = 'B';
      g_showPrgMtr = cTrue;
    Else;
      g_showPrgMtr = cFalse;
    Endif;
  //      ... others
  Other;
    g_showPrgMtr = cFalse;
  Endsl;

  Return;

end-proc;

//===============================================================*
//  Show Progress Meter
//===============================================================*

dcl-proc p_showProgressMeter export;
  dcl-pi *n;
    i_currValue int(10) value;
  end-pi;

  //  Local helper fields
  dcl-s percentage float(8) inz;
  dcl-s tmStmp timestamp inz;
  dcl-s seconds zoned(30) inz;

  dcl-s progress varchar(128) inz;
  dcl-s complete varchar(128) inz;
  dcl-s pointer varchar(128) inz;
  dcl-s fraction int(10) inz;

  //  QMHSNDPM API
  dcl-s p_msgID char(7) inz('CPDA0FF');
  dcl-ds p_msgFile;
    p_msgFile_name char(10) inz('QCPFMSG');
    p_msgFile_lib  char(10) inz('*LIBL');
  end-ds;
  dcl-s p_msgData char(512) inz;
  dcl-s p_dataLength int(10) inz;
  dcl-s p_msgType char(10) inz;
  dcl-s p_pgmQueue char(10) inz;
  dcl-s p_pgmStack int(10) inz;
  dcl-s p_msgKey char(4) inz;
  dcl-ds p_error;
  end-ds;
  dcl-ds p_errCode likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  //  Check whether the progress meter must be shown
  If not g_showPrgMtr;
    Return;
  Endif;

  //  Set size of fields depending on screen size
  If g_jobType = 'B';
    %len(progress) = 50;
  Else;
    %len(progress) = lf_getNumDspCol() - 30;
  Endif;
  %len(complete) = %len(progress);
  %len(pointer ) = %len(progress);

  //  Compute new percentage, get current timestamp
  percentage = %int(100 * i_currValue
                       / g_maxValue  );
  tmStmp = %timestamp();

  //  Compute elapsed time
  If g_waitSec > 0;
    seconds = %diff(tmStmp:g_lastTmStmp:*s);
  Else;
    seconds = *hival;
  Endif;

  //  Check whether a new value must be shown
  If (percentage <> g_lastPercentage)  and
     ((seconds >= g_waitSec) or (g_waitSec = 0));

    //  ... initialize message line with dots.
    progress = %xlate(' ': '.': progress);

    //  ... build completion overlay for marker values of *blank and above
    If g_marker >= x'40';
      pointer = %xlate(' ': g_marker: pointer);
    Endif;

    //  ... as we only have enough space for a line of X, adjust the percentage to fit
    fraction = (percentage/100) * %len(progress);

    //  ... make sure that fraction does not excedd %len(progress)
    If fraction > %len(progress);
      fraction = %len(progress);
    Endif;

    //  ... replace the the dots in the completed section with the requested marker
    %subst(progress : 1 : fraction) =
    %subst(pointer  : 1 : fraction);

    //  ... format the message accoring to marker type -
    //      row of characters or solid reverse image
    If g_marker >= x'40';
      p_msgData = g_text + ' ' +
      %editc(%dech(percentage: 3: 0):'Z') +
      '% ' + progress;
    Else;
      If fraction < %len(progress);
        %subst(progress : fraction + 1 : 1) = x'22';
      Else;
        progress = progress + x'22';
      Endif;
      p_msgData = g_Text + ' ' +
      %editc(%dech(percentage: 3: 0):'Z') +
      '%' + g_marker + progress;
    Endif;

    p_DataLength = %len(%trimL(p_msgData));
    p_PgmStack = 0;
    p_PgmQueue = '*EXT';

    //  Send message to this program's own queue if in batch (log in job log) ...
    If g_jobType = 'B';
      p_msgType = '*INFO';
    Else;
      //  ... otherwise send status message for interactive request
      p_msgType = '*STATUS';
    Endif;

    Clear p_errCode;
    p_errCode.bytPrv = %size(p_errCode);

    callp(e) QMHSNDPM ( p_msgID : p_msgFile :
    p_msgData : p_dataLength : p_msgType :
    p_pgmQueue : p_pgmStack : p_msgKey :
    p_error );

    //  ... remember current values
    g_lastPercentage = percentage;
    g_lastTmStmp     = tmStmp;
  Endif;

  Return;

end-proc;

//===============================================================*
//  Get number of display columns
//===============================================================*

dcl-proc lf_getNumDspCol;
  dcl-pi *n uns(10);
  end-pi;

  //  Definieren Funktionswert
  dcl-s numDspCol uns(10) inz;

  //  Definieren Arbeitsfelder
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  If lf_getScreenMode() = cSCR_MODE_DS3;
    numDspCol = cSCR_COLUMN_DS3;
  Else;
    numDspCol = cSCR_COLUMN_DS4;
  Endif;

  Return numDspCol;

end-proc;

//===============================================================*
//  Get screnn mode
//===============================================================*

dcl-proc lf_getScreenMode;
  dcl-pi *n char(10);
  end-pi;

  //  Definieren Funktionswert
  dcl-s screenMode char(10) inz;

  //  Retrieve Display Mode       Return value: Display Mode
  dcl-pr QsnRtvMod char(1) extproc('QsnRtvMod');
    o_dspMode    char(1) options(*omit);
    i_hLowLvlEnv int(10) options(*omit) const;
    io_errCode   char(32767) options(*omit: *varsize);
  end-pr;

  //  Definieren Arbeitsfelder
  dcl-s p_mode char(1) inz;
  dcl-ds p_errCode likeds(errCode_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  Clear p_errCode;

  QsnRtvMod(p_mode: *omit: p_errCode);

  If p_mode = '3';
    screenMode = cSCR_MODE_DS3;
  Else;
    screenMode = cSCR_MODE_DS4;
  endif;

  Return screenMode;

end-proc;

