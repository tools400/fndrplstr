000100170213      /IF NOT DEFINED(PRGMTRR2)
000200170213      /DEFINE PRGMTRR2
000300170213      *
000400170213      *  Initialize Progress Meter
000500170213     D p_inzProgressMeter...
000600170213     D                 PR
000700170213     D  i_text                       20A   value
000800170213     D  i_maxValue                   10I 0 value
000900170213     D  i_marker                      1A   value  options(*nopass)
001000170213     D  i_waitSec                    10I 0 value  options(*nopass)
001100170213     D  i_jobType                    10A   value  options(*nopass)
001200170213      *
001300170213      *  Show Progress Meter
001400170213     D p_showProgressMeter...
001500170213     D                 PR
001600170213     D  i_currValue                  10I 0 value
001700170213      *
001800170213      *  Job Types
001900170213     D cPrgMtr_JobType_All...
002000170213     D                 C                   const('*ALL')
002100170213     D cPrgMtr_JobType_Dlg...
002200170213     D                 C                   const('*DIALOG')
002300170213     D cPrgMtr_JobType_Batch...
002400170213     D                 C                   const('*BATCH')
002500170213      *
002600170213      *  Reverse image colours for solid progress bars.
002700170213      *  Set i_marker to one of these for good effect.
002800170213     D cPrgMtr_Green   C                   const(X'21')
002900170213     D cPrgMtr_White   C                   const(X'23')
003000170213     D cPrgMtr_Red     C                   const(X'29')
003100170213     D cPrgMtr_Turqoise...
003200170213     D                 C                   const(X'31')
003300170213     D cPrgMtr_Yellow  C                   const(X'33')
003400170213     D cPrgMtr_Pink    C                   const(X'39')
003500170213     D cPrgMtr_Blue    C                   const(X'3B')
003600170213      *
003700170213      /ENDIF
