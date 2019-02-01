 DEF  /IF NOT DEFINED(CEELIB)
 DEF  /DEFINE CEELIB
      *
      *  Test for Omitted Argument (CEETSTA) API
     D CEETSTA...
     D                 PR
     D                                            extproc('CEETSTA')
     D  io_isPresent                 10I 0
     D  i_argNum                     10I 0 const
     D  o_fc                         12A          options(*omit   )
      *
      *  Get String Information (CEEGSI) API
     D CEEGSI...
     D                 PR
     D                                            extproc('CEEGSI')
     D  i_posn                       10I 0 const
     D  o_datatype                   10I 0
     D  o_curlen                     10I 0
     D  o_maxlen                     10I 0
     D  o_fb                         12A          options(*omit   )
      *
      *  Reference fields for CEEGSI API
     D strInf_t        DS                  based(pDummy)   qualified
     D  datatype                     10I 0
     D  curlen                       10I 0
     D  maxlen                       10I 0
      *
      *  Register Activation Group Exit Procedure (CEE4RAGE) API
     D CEE4RAGE...
     D                 PR                  extproc('CEE4RAGE')
     D  i_pProc                        *   const procptr
     D   fc                          12A         options(*OMIT)
      *
      *  Logarithm base 10 (double float)
     D CEESDLG1...
     D                 PR                  extproc('CEESDLG1')
     D  i_value                       8F   const
     D  o_result                      8F
      *
      *  Register Call Stack Entry Termination User Exit Procedure (CEERTX)
     D CEERTX...
     D                 PR                         extproc('CEERTX')
     D  i_procPtr                      *   const  procptr
     D  i_rtxToken                     *   const  options(*omit)
     D  o_fc                         12A          options(*omit)
      *
      *  Unregister Call Stack Entry Termination User Exit Procedure (CEEUTX)
     D CEEUTX...
     D                 PR                         extproc('CEEUTX')
     D  i_procPtr                      *   const  procptr
     D  o_fc                         12A          options(*omit)
      *
 DEF  /ENDIF
