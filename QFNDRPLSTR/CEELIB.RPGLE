**free
/if NOT defined(CEELIB)
/define CEELIB

//  Test for Omitted Argument (CEETSTA) API
dcl-pr CEETSTA extproc('CEETSTA');
  io_isPresent int(10);
  i_argNum     int(10) const;
  o_fc         char(12) options(*omit);
end-pr;

//  Get String Information (CEEGSI) API
dcl-pr CEEGSI extproc('CEEGSI');
  i_posn     int(10) const;
  o_datatype int(10);
  o_curlen   int(10);
  o_maxlen   int(10);
  o_fb       char(12) options(*omit);
end-pr;

//  Reference fields for CEEGSI API
dcl-ds strInf_t based(pDummy) qualified;
  datatype int(10);
  curlen   int(10);
  maxlen   int(10);
end-ds;

//  Register Activation Group Exit Procedure (CEE4RAGE) API
dcl-pr CEE4RAGE extproc('CEE4RAGE');
  i_pProc pointer(*proc) const;
  fc      char(12) options(*omit);
end-pr;

//  Logarithm base 10 (double float)
dcl-pr CEESDLG1 extproc('CEESDLG1');
  i_value  float(8) const;
  o_result float(8);
end-pr;

//  Register Call Stack Entry Termination User Exit Procedure (CEERTX)
dcl-pr CEERTX extproc('CEERTX');
  i_procPtr  pointer(*proc) const;
  i_rtxToken pointer options(*omit) const;
  o_fc       char(12) options(*omit);
end-pr;

//  Unregister Call Stack Entry Termination User Exit Procedure (CEEUTX)
dcl-pr CEEUTX extproc('CEEUTX');
  i_procPtr pointer(*proc) const;
  o_fc      char(12) options(*omit);
end-pr;

/endif
