/* --------------------------------------------------------------- */
/* FNDRPLSTR  - SCRIPT MEMBER                                      */
/* Use commands  xmlgenINC (generate text for install pgm)         */
/*               xmlgenMBR (to define source members               */
/*               xmlgenCMD (execute qcmdexc at run time            */
/* Put &TOLIB where you want user selected lib at run time.        */
   DCL &TOLIB *CHAR 10
/* --------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENVRS  XSRCFILE(QFNDRPLSTR) XSRCLIB(TOOLS400) XSRCMBR(COPYRIGHT)

             XMLGENCND  XMSG('Select language (GER, ENG)') +
                          XVALUES(GER ENG) XVAR(&LANG)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QFNDRPLSTR)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL ) XMBRATR(CLLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_MSG_ENG ) XMBRATR(CLP  ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_MSG_GER ) XMBRATR(CLP  ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CEELIB    ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PNLGRP ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PNLGRP ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDERRCODE ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PNLGRP ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDMSG     ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PNLGRP ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDQOBJ    ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PNLGRP ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FNDRPLPE  ) XMBRATR(PNLGRP) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PNLGRP ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FNDRPLPG  ) XMBRATR(PNLGRP) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PNLGRP ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FNDRPLR1  ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FNDRPLSTRE) XMBRATR(CMD   ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*CMD    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FNDRPLSTRG) XMBRATR(CMD   ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*CMD    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FRS0001   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FRS0002   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FRS0003   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FRS0004   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FRS0005   ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(H_SPEC    ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PPRGMTRR1 ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PRGMTRR1  ) XMBRATR(RPGLE ) +
                          XFROMSRCF(QFNDRPLSTR) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QFNDRPLSTR) XOBJTYPE(*PGM    ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/QFNDRPLSTR) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB' '&LANG'))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

