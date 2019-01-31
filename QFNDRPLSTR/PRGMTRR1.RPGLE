000100170213      ***************************************************************************************
000200170213      * PRGMTRR1: Progress meter
000300170213      * Copyright (C) 2001  Martin Rowe   <martin@dbg400.net>           Original  Version
000400170213      *               2001  Th. Raddatz   <thomas.raddatz@tools400.de>  Procedure Version
000500170213      *
000600170213      * This program is free software; you can redistribute it and/or modify
000700170213      * it under the terms of the GNU General Public License as published by
000800170213      * the Free Software Foundation; either version 2 of the License, or
000900170213      * (at your option) any later version.
001000170213      *
001100170213      * This program is distributed in the hope that it will be useful,
001200170213      * but WITHOUT ANY WARRANTY; without even the implied warranty of
001300170213      * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
001400170213      * GNU General Public License for more details.
001500170213      *
001600170213      * You should have received a copy of the GNU General Public License
001700170213      * along with this program; if not, write to the Free Software
001800170213      * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
001900170213      ***************************************************************************************
002000170213      *   >>PRE-COMPILER<<
002100170213      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +
002200170213      *                              SRCFILE(&SL/&SF) +
002300170213      *                              SRCMBR(&SM);
002400170213      *     >>COMPILE<<
002500170213      *       >>PARM<< TRUNCNBR(*NO);
002600170213      *       >>PARM<< DBGVIEW(*LIST);
002700170213      *       >>PARM<< OPTION(*EVENTF);                                     *
002800170213      *     >>END-COMPILE<<
002900170213      *     >>EXECUTE<<
003000170213      *   >>END-PRE-COMPILER<<
003100170213      ***************************************************************************************
003200170213     H nomain
003300170213      /copy QFNDRPLSTR,H_SPEC
003400170213      ***************************************************************************************
003500170213      *
003600170213      *  Global fields
003700170213     D g_text          S             20A   inz
003800170213     D g_maxValue      S             10I 0 inz
003900170213     D g_marker        S              1A   inz
004000170213     D g_waitSec       S             10I 0 inz
004100170213      *
004200170213     D g_jobtype       S              1A   inz
004300170213     D g_showPrgMtr    S               N   inz
004400170213     D g_lastPercentage...
004500170213     D                 S              3P 0 inz
004600170213     D g_lastTmStmp    S               Z   inz
004700170213      *
004800170213     D cTrue           C                   const(*on )
004900170213     D cFalse          C                   const(*on )
005000170213      *
005100170213     D cSCR_MODE_DS3   C                   const('*DS3')
005200170213     D cSCR_MODE_DS4   C                   const('*DS4')
005300170213      *
005400170213     D cSCR_COLUMN_DS3...
005500170213     D                 C                   const(80)
005600170213     D cSCR_COLUMN_DS4...
005700170213     D                 C                   const(132)
005800170213      *
005900170213      *  Type definitions
006000170213     D errCode_t       DS                  qualified   based(pDummy)
006100170213     D  bytPrv                       10I 0
006200170213     D  bytAvl                       10I 0
006300170213     D  excId                         7A
006400170213     D  res01                         1A
006500170213     D  excData                     256A
006600170213      *
006700170213      *  Exported procedures
006800170213      /COPY QFNDRPLSTR,PPRGMTRR1
006900170213      *
007000170213      *  Private Prototypen
007100170213     D lf_getNumDspCol...
007200170213     D                 PR            10U 0
007300170213      *
007400170213     D lf_getScreenMode...
007500170213     D                 PR            10A
007600170213      *
007700170213      *===============================================================*
007800170213      *  Initialize Progress Meter
007900170213      *===============================================================*
008000170213      *
008100170213     P p_inzProgressMeter...
008200170213     P                 B                   export
008300170213      *
008400170213     D p_inzProgressMeter...
008500170213     D                 PI
008600170213     D  i_text                       20A   value
008700170213     D  i_maxValue                   10I 0 value
008800170213     D  i_marker                      1A   value  options(*nopass)
008900170213     D  i_waitSec                    10I 0 value  options(*nopass)
009000170213     D  i_jobType                    10A   value  options(*nopass)
009100170213      *
009200170213      *  Optional parameter positions
009300170213     D p_marker        C                   const(3)
009400170213     D p_waitSec       C                   const(4)
009500170213     D p_jobType       C                   const(5)
009600170213      *
009700170213      *  Optional parameter fields
009800170213     D marker          S                   like(i_marker  ) inz
009900170213     D waitSec         S                   like(i_waitSec ) inz
010000170213     D jobType         S                   like(i_jobType ) inz
010100170213      *
010200170213      *  Local helper fields
010300170213     D p_rcvr          S            100A   inz
010400170213     D p_rcvrLen       S             10I 0 inz(%size(p_rcvr))
010500170213     D p_format        S              8A   inz('JOBI0100')
010600170213     D p_thisJob       S             26A   inz('*')
010700170213     D p_intJob        S             16A   inz
010800170213      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
010900170213      *
011000170213      *  Process optional parameters ...
011100170213      *  ... i_marker
011200170213     C                   If        %parms >= p_marker
011300170213     C                   Eval      marker = i_marker
011400170213     C                   Else
011500170213     C                   Eval      marker = cPrgMtr_Blue
011600170213     C                   Endif
011700170213      *
011800170213      *  ... 'i_waitSec'
011900170213     C                   If        %parms >= p_waitSec
012000170213     C                   Eval      waitSec = i_waitSec
012100170213     C                   Else
012200170213     C                   Eval      waitSec = 0
012300170213     C                   Endif
012400170213      *
012500170213      *  ... 'i_jobType'
012600170213     C                   If        %parms >= p_jobType
012700170213     C                   Eval      jobType = i_jobType
012800170213     C                   Else
012900170213     C                   Eval      jobType = cPrgMtr_JobType_All
013000170213     C                   Endif
013100170213      *
013200170213      * Determine job type (interactive or batch)
013300170213     C                   Call      'QUSRJOBI'
013400170213     C                   Parm                    p_rcvr
013500170213     C                   Parm                    p_rcvrLen
013600170213     C                   Parm                    p_format
013700170213     C                   Parm                    p_thisJob
013800170213     C                   Parm                    p_intJob
013900170213      *
014000170213      * Set processing attributes ...
014100170213     C                   Eval      g_jobType = %subst(p_rcvr : 61 :1)
014200170213      *
014300170213     C                   Eval      g_text        = i_text
014400170213     C                   Eval      g_maxValue    = i_maxValue
014500170213     C                   Eval      g_waitSec     = waitSec
014600170213      *
014700170213     C                   Eval      g_lastPercentage = -1
014800170213     C                   Eval      g_lastTmStmp     = *LOVAL
014900170213      *
015000170213      * ... if an attribute below x'20' (normal green) specified,
015100170213      *     swap for yellow reverse (safer)
015200170213     C                   If        marker < X'20'
015300170213     C                   Eval      g_Marker = cPrgMtr_Yellow
015400170213     C                   Else
015500170213     C                   Eval      g_marker = marker
015600170213     C                   Endif
015700170213      *
015800170213      * ... change marker acording to job type
015900170213     C                   If        (g_jobType = 'B') and (g_marker < ' ')
016000170213     C                   Eval      g_marker = '#'
016100170213     C                   Endif
016200170213      *
016300170213      *  ... check whether the progress meter must be shown for jobs of type ...
016400170213     C                   Select
016500170213      *      ... all Jobs
016600170213     C                   When      jobType = cPrgMtr_JobType_All
016700170213     C                   Eval      g_showPrgMtr = cTrue
016800170213      *      ... interactive jobs
016900170213     C                   When      jobType = cPrgMtr_JobType_Dlg
017000170213     C                   If        g_jobType <> 'B'
017100170213     C                   Eval      g_showPrgMtr = cTrue
017200170213     C                   Else
017300170213     C                   Eval      g_showPrgMtr = cFalse
017400170213     C                   Endif
017500170213      *      ... batch jobs
017600170213     C                   When      jobType = cPrgMtr_JobType_Batch
017700170213     C                   If        g_jobType = 'B'
017800170213     C                   Eval      g_showPrgMtr = cTrue
017900170213     C                   Else
018000170213     C                   Eval      g_showPrgMtr = cFalse
018100170213     C                   Endif
018200170213      *      ... others
018300170213     C                   Other
018400170213     C                   Eval      g_showPrgMtr = cFalse
018500170213     C                   Endsl
018600170213      *
018700170213     C                   Return
018800170213      *
018900170213     P p_inzProgressMeter...
019000170213     P                 E
019100170213      *
019200170213      *===============================================================*
019300170213      *  Show Progress Meter
019400170213      *===============================================================*
019500170213      *
019600170213     P p_showProgressMeter...
019700170213     P                 B                   export
019800170213      *
019900170213     D p_showProgressMeter...
020000170213     D                 PI
020100170213     D  i_currValue                  10I 0 value
020200170213      *
020300170213      *  Local helper fields
020400170213     D percentage      S              8F   inz
020500170213     D tmStmp          S               Z   inz
020600170213     D seconds         S             30S 0 inz
020700170213      *
020800170213     D progress        S            128A   inz  varying
020900170213     D complete        S            128A   inz  varying
021000170213     D pointer         S            128A   inz  varying
021100170213     D fraction        S             10I 0 inz
021200170213      *
021300170213      *  QMHSNDPM API
021400170213     D p_msgID         S              7A   inz('CPDA0FF')
021500170213     D p_msgFile       DS
021600170213     D  p_msgFile_name...
021700170213     D                               10A   inz('QCPFMSG')
021800170213     D  p_msgFile_lib...
021900170213     D                               10A   inz('*LIBL')
022000170213     D p_msgData       S            512A   inz
022100170213     D p_dataLength    S             10I 0 inz
022200170213     D p_msgType       S             10A   inz
022300170213     D p_pgmQueue      S             10A   inz
022400170213     D p_pgmStack      S             10I 0 inz
022500170213     D p_msgKey        S              4A   inz
022600170213     D p_error         DS
022700170213     D p_errCode       DS                  likeds(errCode_t) inz
022800170213      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
022900170213      *
023000170213      *  Check whether the progress meter must be shown
023100170213     C                   If        not g_showPrgMtr
023200170213     C                   Return
023300170213     C                   Endif
023400170213      *
023500170213      *  Set size of fields depending on screen size
023600170213     C                   If        g_jobType = 'B'
023700170213     C                   Eval      %len(progress) = 50
023800170213     C                   Else
023900170213     C                   Eval      %len(progress) = lf_getNumDspCol() - 30
024000170213     C                   Endif
024100170213     C                   Eval      %len(complete) = %len(progress)
024200170213     C                   Eval      %len(pointer ) = %len(progress)
024300170213      *
024400170213      *  Compute new percentage, get current timestamp
024500170213     C                   Eval      percentage = %int(100 * i_currValue
024600170213     C                                                   / g_maxValue  )
024700170213     C                   Time                    tmStmp
024800170213      *
024900170213      *  Compute elapsed time
025000170213     C                   If        g_waitSec > 0
025100170213     C     tmStmp        Subdur    g_lastTmStmp  seconds:*s
025200170213     C                   Else
025300170213     C                   Eval      seconds = *hival
025400170213     C                   Endif
025500170213      *
025600170213      *  Check whether a new value must be shown
025700170213     C                   If        (percentage <> g_lastPercentage)  and
025800170213     C                             ((seconds >= g_waitSec) or (g_waitSec = 0))
025900170213      *
026000170213      *  ... initialize message line with dots.
026100170213     C                   EVAL      progress = %xlate(' ': '.': progress)
026200170213      *
026300170213      *  ... build completion overlay for marker values of *blank and above
026400170213     C                   If        g_marker >= x'40'
026500170213     C                   EVAL      pointer = %xlate(' ': g_marker: pointer)
026600170213     C                   Endif
026700170213      *
026800170213      *  ... as we only have enough space for a line of X, adjust the percentage to fit
026900170213     C                   Eval      fraction = (percentage/100) * %len(progress)
027000170213      *
027100170213      *  ... make sure that fraction does not excedd %len(progress)
027200170213     C                   If        fraction > %len(progress)
027300170213     C                   Eval      fraction = %len(progress)
027400170213     C                   Endif
027500170213      *
027600170213      *  ... replace the the dots in the completed section with the requested marker
027700170213     C                   Eval      %subst(progress : 1 : fraction) =
027800170213     C                             %subst(pointer  : 1 : fraction)
027900170213      *
028000170213      *  ... format the message accoring to marker type -
028100170213      *      row of characters or solid reverse image
028200170213     C                   If        g_marker >= x'40'
028300170213     C                   Eval      p_msgData = g_text + ' ' +
028400170213     C                             %editc(%dech(percentage: 3: 0):'Z') +
028500170213     C                             '% ' + progress
028600170213     C                   Else
028700170213     C                   If        fraction < %len(progress)
028800170213     C                   Eval      %subst(progress : fraction + 1 : 1) = x'22'
028900170213     C                   Else
029000170213     C                   Eval      progress = progress + x'22'
029100170213     C                   Endif
029200170213     C                   Eval      p_msgData = g_Text + ' ' +
029300170213     C                             %editc(%dech(percentage: 3: 0):'Z') +
029400170213     C                             '%' + g_marker + progress
029500170213     C                   Endif
029600170213      *
029700170213     C                   EVAL      p_DataLength = %len(%trimL(p_msgData))
029800170213     C                   EVAL      p_PgmStack = 0
029900170213     C                   EVAL      p_PgmQueue = '*EXT'
030000170213      *
030100170213      *  Send message to this program's own queue if in batch (log in job log) ...
030200170213     C                   If        g_jobType = 'B'
030300170213     C                   Eval      p_msgType = '*INFO'
030400170213     C                   Else
030500170213      *  ... otherwise send status message for interactive request
030600170213     C                   Eval      p_msgType = '*STATUS'
030700170213     C                   Endif
030800170213      *
030900170213     C                   Clear                   p_errCode
031000170213     C                   Eval      p_errCode.bytPrv = %size(p_errCode)
031100170213      *
031200170213     C                   Call (E)  'QMHSNDPM'
031300170213     C                   Parm                    p_msgID
031400170213     C                   Parm                    p_msgFile
031500170213     C                   Parm                    p_msgData
031600170213     C                   Parm                    p_dataLength
031700170213     C                   Parm                    p_msgType
031800170213     C                   Parm                    p_pgmQueue
031900170213     C                   Parm                    p_pgmStack
032000170213     C                   Parm                    p_msgKey
032100170213     C                   Parm                    p_error
032200170213      *
032300170213      *  ... remember current values
032400170213     C                   Eval      g_lastPercentage = percentage
032500170213     C                   Eval      g_lastTmStmp     = tmStmp
032600170213     C                   Endif
032700170213      *
032800170213     C                   Return
032900170213      *
033000170213     P p_showProgressMeter...
033100170213     P                 E
033200170213      *
033300170213      *===============================================================*
033400170213      *  Get number of display columns
033500170213      *===============================================================*
033600170213      *
033700170213     P lf_getNumDspCol...
033800170213     P                 B
033900170213      *
034000170213     D lf_getNumDspCol...
034100170213     D                 PI            10U 0
034200170213      *
034300170213      *  Definieren Funktionswert
034400170213     D numDspCol       S             10U 0 inz
034500170213      *
034600170213      *  Definieren Arbeitsfelder
034700170213      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
034800170213      *
034900170213     C                   If        lf_getScreenMode() = cSCR_MODE_DS3
035000170213     C                   Eval      numDspCol = cSCR_COLUMN_DS3
035100170213     C                   Else
035200170213     C                   Eval      numDspCol = cSCR_COLUMN_DS4
035300170213     C                   Endif
035400170213      *
035500170213     C                   Return    numDspCol
035600170213      *
035700170213     P lf_getNumDspCol...
035800170213     P                 E
035900170213      *
036000170213      *===============================================================*
036100170213      *  Get screnn mode
036200170213      *===============================================================*
036300170213      *
036400170213     P lf_getScreenMode...
036500170213     P                 B
036600170213      *
036700170213     D lf_getScreenMode...
036800170213     D                 PI            10A
036900170213      *
037000170213      *  Definieren Funktionswert
037100170213     D screenMode      S             10A   inz
037200170213      *
037300170213      *  Retrieve Display Mode       Return value: Display Mode
037400170213     D QsnRtvMod...
037500170213     D                 PR             1A          extproc('QsnRtvMod')
037600170213     D  o_dspMode                     1A          options(*omit   )
037700170213     D  i_hLowLvlEnv                 10I 0 const  options(*omit   )
037800170213     D  io_errCode                32767A          options(*omit   :
037900170213     D                                                    *varsize)
038000170213      *
038100170213      *  Definieren Arbeitsfelder
038200170213     D p_mode          S              1A                     inz
038300170213     D p_errCode       DS                  likeds(errCode_t) inz
038400170213      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
038500170213      *
038600170213     C                   Clear                   p_errCode
038700170213      *
038800170213     C                   Callp     QsnRtvMod(p_mode: *omit: p_errCode)
038900170213      *
039000170213     C                   If        p_mode = '3'
039100170213     C                   Eval      screenMode = cSCR_MODE_DS3
039200170213     C                   Else
039300170213     C                   Eval      screenMode = cSCR_MODE_DS4
039400170213     C                   endif
039500170213      *
039600170213     C                   Return    screenMode
039700170213      *
039800170213     P lf_getScreenMode...
039900170213     P                 E
040000170213      *
