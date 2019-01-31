000100170213 DEF  /IF NOT DEFINED(CEELIB)
000200170213 DEF  /DEFINE CEELIB
000300170213      *
000400170213      *  Test for Omitted Argument (CEETSTA) API
000500170213     D CEETSTA...
000600170213     D                 PR
000700170213     D                                            extproc('CEETSTA')
000800170213     D  io_isPresent                 10I 0
000900170213     D  i_argNum                     10I 0 const
001000170213     D  o_fc                         12A          options(*omit   )
001100170213      *
001200170213      *  Get String Information (CEEGSI) API
001300170213     D CEEGSI...
001400170213     D                 PR
001500170213     D                                            extproc('CEEGSI')
001600170213     D  i_posn                       10I 0 const
001700170213     D  o_datatype                   10I 0
001800170213     D  o_curlen                     10I 0
001900170213     D  o_maxlen                     10I 0
002000170213     D  o_fb                         12A          options(*omit   )
002100170213      *
002200170213      *  Reference fields for CEEGSI API
002300170213     D strInf_t        DS                  based(pDummy)   qualified
002400170213     D  datatype                     10I 0
002500170213     D  curlen                       10I 0
002600170213     D  maxlen                       10I 0
002700170213      *
002800170213      *  Register Activation Group Exit Procedure (CEE4RAGE) API
002900170213     D CEE4RAGE...
003000170213     D                 PR                  extproc('CEE4RAGE')
003100170213     D  i_pProc                        *   const procptr
003200170213     D   fc                          12A         options(*OMIT)
003300170213      *
003400170213      *  Logarithm base 10 (double float)
003500170213     D CEESDLG1...
003600170213     D                 PR                  extproc('CEESDLG1')
003700170213     D  i_value                       8F   const
003800170213     D  o_result                      8F
003900170213      *
004000170213      *  Register Call Stack Entry Termination User Exit Procedure (CEERTX)
004100170213     D CEERTX...
004200170213     D                 PR                         extproc('CEERTX')
004300170213     D  i_procPtr                      *   const  procptr
004400170213     D  i_rtxToken                     *   const  options(*omit)
004500170213     D  o_fc                         12A          options(*omit)
004600170213      *
004700170213      *  Unregister Call Stack Entry Termination User Exit Procedure (CEEUTX)
004800170213     D CEEUTX...
004900170213     D                 PR                         extproc('CEEUTX')
005000170213     D  i_procPtr                      *   const  procptr
005100170213     D  o_fc                         12A          options(*omit)
005200170213      *
005300170213 DEF  /ENDIF
