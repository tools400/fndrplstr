             PGM        PARM(&LI)

             DCL        VAR(&LI) TYPE(*CHAR) LEN(10)

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD für Message-ID :   FRS0001                    */
     /* Searching member &1.                                        */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(FRS0001) MSGF(&LI/FNDRPLSTR)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(FRS0001) +
                MSGF(&LI/FNDRPLSTR) +
                MSG(+
'Searching member &1.'                                                +
                ) +
                SEV(00) +
                FMT( +
                    (*CHAR 010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD für Message-ID :   FRS0002                    */
     /* Applied &1 changes to member &2 in file &4/&3.              */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(FRS0002) MSGF(&LI/FNDRPLSTR)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(FRS0002) +
                MSGF(&LI/FNDRPLSTR) +
                MSG(+
'Applied &1 changes to member &2 in file &4/&3.'                      +
                ) +
                SEV(00) +
                FMT( +
                    (*DEC 010 0) +
                    (*CHAR 010) +
                    (*CHAR 010) +
                    (*CHAR 010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD für Message-ID :   FRS0003                    */
     /* No matches found in member &2 in file &4/&3.                */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(FRS0003) MSGF(&LI/FNDRPLSTR)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(FRS0003) +
                MSGF(&LI/FNDRPLSTR) +
                MSG(+
'No matches found in member &2 in file &4/&3.'                        +
                ) +
                SEV(00) +
                FMT( +
                    (*DEC 010 0) +
                    (*CHAR 010) +
                    (*CHAR 010) +
                    (*CHAR 010) +
                ) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD für Message-ID :   FRS0004                    */
     /* Retrieving member list ...                                  */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(FRS0004) MSGF(&LI/FNDRPLSTR)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(FRS0004) +
                MSGF(&LI/FNDRPLSTR) +
                MSG(+
'Retrieving member list ...'                                          +
                ) +
                SEV(00) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

     /* ----------------------------------------------------------- */
     /*   Cmd-ADDMSGD für Message-ID :   FRS0005                    */
     /* Searching                                                   */
     /* ----------------------------------------------------------- */

             RMVMSGD MSGID(FRS0005) MSGF(&LI/FNDRPLSTR)
             MONMSG  MSGID(CPF2419)     /* MsgID nicht gefunden */

             ADDMSGD +
                MSGID(FRS0005) +
                MSGF(&LI/FNDRPLSTR) +
                MSG(+
'Searching'                                                           +
                ) +
                SEV(00) +
                ALROPT(*NO) +
                CCSID( 65535) +
                /*  -EOF-  */

             RCLRSC LVL(*)

             ENDPGM
