**free
/if NOT defined(PRGMTRR2)
/define PRGMTRR2

//  Initialize Progress Meter
dcl-pr p_inzProgressMeter;
  i_text     char(20) value;
  i_maxValue int(10) value;
  i_marker   char(1) options(*nopass) value;
  i_waitSec  int(10) options(*nopass) value;
  i_jobType  char(10) options(*nopass) value;
end-pr;

//  Show Progress Meter
dcl-pr p_showProgressMeter;
  i_currValue int(10) value;
end-pr;

//  Job Types
dcl-c cPrgMtr_JobType_All '*ALL';
dcl-c cPrgMtr_JobType_Dlg '*DIALOG';
dcl-c cPrgMtr_JobType_Batch '*BATCH';

//  Reverse image colours for solid progress bars.
//  Set i_marker to one of these for good effect.
dcl-c cPrgMtr_Green X'21';
dcl-c cPrgMtr_White X'23';
dcl-c cPrgMtr_Red X'29';
dcl-c cPrgMtr_Turqoise X'31';
dcl-c cPrgMtr_Yellow X'33';
dcl-c cPrgMtr_Pink X'39';
dcl-c cPrgMtr_Blue X'3B';

/endif
