000100170213      *=====================================================================*
000200170213      *  Author  :  Thomas Raddatz                                          *
000300170213      *  Date    :  05.01.2004                                              *
000400170213      *  E-mail  :  Thomas.Raddatz@Tools400.de                              *
000500170213      *  Homepage:  www.tools400.de                                         *
000600170213      *=====================================================================*
000700170213      *                                                                     *
000800170213      *  This software is free software, you can redistribute it and/or     *
000900170213      *  modify it under the terms of the GNU General Public License (GPL)  *
001000170213      *  as published by the Free Software Foundation.                      *
001100170213      *                                                                     *
001200170213      *  See GNU General Public License for details.                        *
001300170213      *          http://www.opensource.org                                  *
001400170213      *          http://www.opensource.org/licenses/gpl-license.html        *
001500170213      *                                                                     *
001600170213      *=====================================================================*
001700170213      *  History:                                                           *
001800170213      *                                                                     *
001900170213      *  Datum       Name          Änderung                                 *
002000170213      *  ----------  ------------  ---------------------------------------  *
002100170213      *  16.12.2008  Th.Raddatz    Now ds_srcMbr.srcDta correctly starts    *
002200170213      *                            at position 7.                           *
002300170213      *                                                                     *
002400170213      *=====================================================================*
002500170213      *   >>PRE-COMPILER<<                                                  *
002600170213      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
002700170213      *                              SRCFILE(&SL/&SF) +                     *
002800170213      *                              SRCMBR(&SM);                           *
002900170213      *     >>COMPILE<<                                                     *
003000170213      *       >>PARM<< TRUNCNBR(*NO);                                       *
003100170213      *       >>PARM<< DBGVIEW(*LIST);                                      *
003200170213      *       >>PARM<< OPTION(*EVENTF);                                     *
003300170213      *     >>END-COMPILE<<                                                 *
003400170213      *     >>EXECUTE<<                                                     *
003500170213      *     >>CMD<<     CRTPGM       PGM(&LI/FNDRPLSTR) +                   *
003600170213      *                              MODULE(&LI/&OB       +                 *
003700170213      *                                     &LI/PRGMTRR1) +                 *
003800170213      *                              ENTMOD(&LI/&OB) +                      *
003900170213      *                              ACTGRP(*NEW) +                         *
004000170213      *                              BNDSRVPGM(*LIBL/RTVMBRL  +             *
004100170213      *                                        *LIBL/BASICS1) +             *
004200170213      *                              DETAIL(*BASIC);                        *
004300170213      *   >>END-PRE-COMPILER<<                                              *
004400170213      *=====================================================================*
004500170213      /copy QFNDRPLSTR,H_SPEC
004600170213      /copy QFNDRPLSTR,COPYRIGHT
004700170213      *=====================================================================*
004800170213     FFILE      UF   F32766        DISK    usropn
004900170213     F                                     extfile(g_file    )
005000170213     F                                     extmbr(g_mbr      )
005100170213     F                                     infds(file_FB     )
005200170213      *
005300170213     D file_FB         DS                  likeds(file_FB_t  )
005400170213      *
005500170213     D g_file          S             21A   inz
005600170213     D g_mbr           S                   inz    like(mbr_t     )
005700170213      *
005800170213     D ds_file         DS                  qualified
005900170213     D  buffer                 1  32766A
006000170213      *
006100170213     D ds_srcMbr       DS                  qualified
006200170213     D  srcSeq                 1      6S 2
006300170213     D  srcDat                 7     12S 0
006400170213     D  srcDta                13  32766A
006500170213      *
006600170213      *  Type Definitions
006700170213     D bool_t          S               N   based(pDummy)
006800170213     D int4_t          S             10I 0 based(pDummy)
006900170213     D file_t          S             10A   based(pDummy)
007000170213     D lib_t           S             10A   based(pDummy)
007100170213     D mbr_t           S             10A   based(pDummy)
007200170213     D string_t        S          32766A   based(pDummy)   varying
007300170213     D keyword_t       S             10A   based(pDummy)
007400170213     D varChar_t       S              1A   based(pDummy)   varying
007500170213      *
007600170213      /COPY QFNDRPLSTR,FDQOBJ                     Qualified object name
007700170213      *
007800170213      /COPY QBASICS1,PBASICS1                     Tools/400 Runtime Library
007900170213      /COPY QFNDRPLSTR,PPRGMTRR1                  Progress Meter
008000170213      /COPY QFNDRPLSTR,CEELIB                     CEE APIs
008100170213      *
008200170213     D mbrl0200_t      DS                  qualified             based(pDummy)
008300170213     D  mbr                          10A
008400170213     D  srcType                      10A
008500170213     D  crtDatTim                    13A
008600170213     D  cghDatTim                    13A
008700170213     D  text                         50A
008800170213     D  textCcsid                    10U 0
008900170213      *
009000170213     D fndRplStrL_t    DS                  qualified             based(pDummy)
009100170213     D  numEntries                    5I 0
009200170213     D  offsets                       5I 0                       dim(cNumValues)
009300170213     D  entries                            likeds(entry_t    )   dim(cNumValues)
009400170213      *
009500170213     D entry_t         DS                  qualified             based(pDummy)
009600170213     D  numValues                     5I 0
009700170213     D  find                         25A   varying
009800170213     D  replace                      25A   varying
009900170213      *
010000170213     D file_FB_t       DS           512    qualified   based(pDummy)
010100170213     D  status                11     15P 0
010200170213     D  msg                   46     52A
010300170213     D  open_FB                            likeds(open_FB_t  )
010400170213     D                                     overlay(file_FB_t:  81)
010500170213     D  IO_FB                              likeds(IO_FB_t    )
010600170213     D                                     overlay(file_FB_t: 241)
010700170213     D  DB_IO_FB                           likeds(DB_IO_FB_t )
010800170213     D                                     overlay(file_FB_t: 367)
010900170213      *
011000170213     D open_FB_t       DS                  qualified   based(pDummy)
011100170213     D  odpType                1      2A
011200170213     D  file                   3     12A
011300170213     D  lib                   13     22A
011400170213     D  splF                  23     32A
011500170213     D  splFLib               33     42A
011600170213     D  splFNbr               43     44I 0
011700170213     D  maxRcdLength          45     46I 0
011800170213     D  maxKeyLength          47     48I 0
011900170213     D  mbr                   49     58A
012000170213     D  res_01                59     62I 0
012100170213     D  res_02                63     66I 0
012200170213     D  fileType              67     68I 0
012300170213     D  res_03                69     71A
012400170213     D  numRcdAtOpn           76     79U 0
012500170213     D  srcFileInd            83     83A
012600170213      *
012700170213     D IO_FB_t         DS                  qualified   based(pDummy)
012800170213     D  writeCount             3      6I 0
012900170213     D  readCount              7     10I 0
013000170213     D  wrRdCount             11     14I 0
013100170213     D  otherCount            15     18I 0
013200170213     D  res_01                19     19A
013300170213     D  currOper              20     20A
013400170213     D  rcdFormat             21     30A
013500170213     D  deviceClass           31     32A
013600170213     D  deviceName            33     42A
013700170213     D  lastRcdLenPrc         43     46I 0
013800170213     D  res_02                47    126A
013900170213     D  rdBlkSize            127    128I 0
014000170213     D  curBlkCount          133    136I 0
014100170213      *
014200170213     D DB_IO_FB_t      DS                  qualified   based(pDummy)
014300170213     D  numLckRcd             11     12I 0
014400170213     D  maxNumFld             13     14I 0
014500170213     D  numKeyFld             21     22I 0
014600170213     D  keyLength             27     28I 0
014700170213     D  dataMbrNbr            29     30I 0
014800170213     D  rrn                   31     34U 0
014900170213      *
015000170213      *  Prototype for the RTVMBRL service program
015100170213      /COPY QRTVMBRL,PRTVMBRL
015200170213      *
015300170213      *  Prototypes for Program Entry Point
015400170213     D PGM_ENTRY_POINT...
015500170213     D                 PR                  extpgm('FNDRPLR1')
015600170213     D  gi_qFile                           const  like(qObj_t         )
015700170213     D  gi_mbr                             const  like(mbr_t          )
015800170213     D  gi_fndRplStrL                      const  likeds(fndRplStrL_t )
015900170213     D  gi_case                            const  like(keyword_t      )
016000170213     D  gi_wildcard                        const  like(varChar_t      )
016100170213      *
016200170213      *  Prototypes for internal procedures
016300170213     D main...
016400170213     D                 PR
016500170213     D  i_qFile                            const  like(gi_qFile       )
016600170213     D  i_mbr                              const  like(gi_mbr         )
016700170213     D  i_fndRplStrL                       const  likeds(gi_fndRplStrL)
016800170213     D  i_case                             const  like(gi_case        )
016900170213     D  i_wildcard                         const  like(gi_wildcard    )
017000170213      *
017100170213     D processMbr...
017200170213     D                 PR
017300170213     D  i_file                             value  like(file_t         )
017400170213     D  i_lib                              value  like(lib_t          )
017500170213     D  i_mbr                              value  like(mbr_t          )
017600170213     D  i_fndRplStrL                       value  likeds(fndRplStrL_t )
017700170213     D  i_case                             value  like(keyword_t      )
017800170213     D  i_wildcard                         value  like(varChar_t      )
017900170213      *
018000170213     D replaceString...
018100170213     D                 PR                         like(string_t  )
018200170213     D  o_numChanges                              like(int4_t    )
018300170213     D  i_searchArg                        const  like(string_t  )
018400170213     D  i_rplString                        const  like(string_t  )
018500170213     D  i_string                           const  like(string_t  )
018600170213     D  i_case                             const  like(keyword_t )
018700170213     D  i_wildcard                         const  like(varChar_t )
018800170213     D                                            options(*nopass)
018900170213     D  i_startPos                         const  like(int4_t    )
019000170213     D                                            options(*nopass)
019100170213     D  i_endPos                           const  like(int4_t    )
019200170213     D                                            options(*nopass)
019300170213      *
019400170213     D scan...
019500170213     D                 PR                         like(int4_t    )
019600170213     D  i_searchArg                        const  like(string_t  )
019700170213     D  i_string                           const  like(string_t  )
019800170213     D  i_startPos                         const  like(int4_t    )
019900170213     D                                            options(*nopass)
020000170213     D  i_wildcard                         const  like(varChar_t )
020100170213     D                                            options(*nopass)
020200170213      *
020300170213     D replace...
020400170213     D                 PR                         like(string_t  )
020500170213     D  i_rplString                        const  like(string_t  )
020600170213     D  i_string                           const  like(string_t  )
020700170213     D  i_startPos                         const  like(int4_t    )
020800170213     D                                            options(*nopass)
020900170213     D  i_length                           const  like(int4_t    )
021000170213     D                                            options(*nopass)
021100170213     D  i_wildcard                         const  like(varChar_t )
021200170213     D                                            options(*nopass)
021300170213      *
021400170213     D isGeneric...
021500170213     D                 PR                         like(bool_t    )
021600170213     D  i_string                           const  like(string_t  )
021700170213      *
021800170213     D rmvMsgByIDAndType...
021900170213     D                 PR
022000170213     D i_msgType                           const  like(msg_t.type)
022100170213     D i_msgID                             const  like(msg_t.ID  )
022200170213      *
022300170213      *  Create new message.
022400170213     D newAppMsg...
022500170213     D                 PR                         like(msg_t     )
022600170213     D  i_msgID                            const  like(msg_t.ID  )
022700170213     D                                            options(*nopass: *omit)
022800170213     D  i_msgData                          const  like(msg_t.data)
022900170213     D                                            options(*nopass: *omit)
023000170213     D  i_msgType                          const  like(msg_t.type)
023100170213     D                                            options(*nopass: *omit)
023200170213      *
023300170213      *  Global Constants
023400170213     D cNumValues      C                   const(10)
023500170213     D cDblQuotes      C                   const('"')
023600170213      *
023700170213     D cSrcFile_ind_Yes...
023800170213     D                 C                   const('Y')
023900170213     D cSrcFile_ind_No...
024000170213     D                 C                   const('N')
024100170213      *
024200170213     D cMbr_First      C                   const('*FIRST')
024300170213     D cMbr_All        C                   const('*ALL')
024400170213      *
024500170213     D cIgnore         C                   const('*IGNORE')
024600170213     D cMatch          C                   const('*MATCH')
024700170213      *
024800170213     D cAppMsgF        C                   const('FNDRPLSTR')
024900170213     D cAppMsgFLib     C                   const('*LIBL')
025000170213      *
025100170213      ********************************************************************
025200170213      *  Program Entry Point
025300170213      ********************************************************************
025400170213      *
025500170213     D PGM_ENTRY_POINT...
025600170213     D                 PI
025700170213     D  gi_qFile                           const  like(qObj_t         )
025800170213     D  gi_mbr                             const  like(mbr_t          )
025900170213     D  gi_fndRplStrL                      const  likeds(fndRplStrL_t )
026000170213     D  gi_case                            const  like(keyword_t      )
026100170213     D  gi_wildcard                        const  like(varChar_t      )
026200170213      *-------------------------------------------------------------------
026300170213      /FREE
026400170213
026500170213         main(gi_qFile: gi_mbr: gi_fndRplStrL: gi_case: gi_wildcard);
026600170213
026700170213         *inlr = *on;
026800170213
026900170213      /END-FREE
027000170213      *
027100170213      *==================================================================*
027200170213      *  Main Procedure
027300170213      *==================================================================*
027400170213      *
027500170213     P main...
027600170213     P                 B
027700170213      *
027800170213     D main...
027900170213     D                 PI
028000170213     D  i_qFile                            const  like(gi_qFile       )
028100170213     D  i_mbr                              const  like(gi_mbr         )
028200170213     D  i_fndRplStrL                       const  likeds(gi_fndRplStrL)
028300170213     D  i_case                             const  like(gi_case        )
028400170213     D  i_wildcard                         const  like(gi_wildcard    )
028500170213      *
028600170213      *  Local fields
028700170213     D isMbr           S                   like(bool_t         ) inz(cFalse)
028800170213     D hMbrList        S                   like(mbrLst_handle_t) inz
028900170213      *
029000170213     D msg             S                   like(msg_t          ) inz
029100170213     D qFile           DS                  likeds(qObj_t       ) inz
029200170213     D mbrl0200        DS                  likeds(mbrl0200_t   ) inz
029300170213     D mbrl0200_hlp    S                   like(mbrl0200       )
029400170213     D                                     based(pMbrl0200_hlp )
029500170213     D pMbrl0200_hlp   S               *   inz(%addr(mbrl0200  ))
029600170213      *
029700170213      *  Messages
029800170213      /COPY QFNDRPLSTR,FRS0004
029900170213      *-------------------------------------------------------------------
030000170213      /FREE
030100170213
030200170213         qFile = i_qFile;
030300170213
030400170213         // If the member name is *FIRST and not a generic value ...
030500170213         // (Since special values are also treated as "generic" values
030600170213         //  we have to exclude *FIRST from that.)
030700170213         if   (i_mbr = cMbr_First) or (not isGeneric(i_mbr));
030800170213            // ... then process the member
030900170213            processMbr(qFile.name: qFile.lib:
031000170213                       i_mbr: i_fndRplStrL: i_case: i_wildcard);
031100170213         else;
031200170213            // ... else retrieve member list and process each member
031300170213            clear   FRS0004;
031400170213            msg = newAppMsg('FRS0004': FRS0004: cMsg_Status);
031500170213            f_sndPgmMsg(msg: cMsg_Ext);
031600170213
031700170213            if   not f_opnMbrLst(qFile.name: qFile.lib:
031800170213                                 i_mbr: '*NAME': hMbrList: msg);
031900170213               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
032000170213            else;
032100170213               isMbr = f_getFirstMbr(hMbrList: mbrl0200_hlp);
032200170213
032300170213               dow   isMbr;
032400170213                  processMbr(qFile.name: qFile.lib:
032500170213                             mbrl0200.mbr: i_fndRplStrL: i_case: i_wildcard);
032600170213                  isMbr = f_getNextMbr(hMbrList: mbrl0200_hlp);
032700170213               enddo;
032800170213
032900170213               f_cloMbrLst(hMbrList);
033000170213
033100170213            endif;
033200170213         endif;
033300170213
033400170213         return;
033500170213
033600170213      /END-FREE
033700170213      *
033800170213     P main...
033900170213     P                 E
034000170213      *
034100170213      *==================================================================*
034200170213      *  Process Member
034300170213      *==================================================================*
034400170213      *
034500170213     P processMbr...
034600170213     P                 B
034700170213      *
034800170213     D processMbr...
034900170213     D                 PI
035000170213     D  i_file                             value  like(file_t         )
035100170213     D  i_lib                              value  like(lib_t          )
035200170213     D  i_mbr                              value  like(mbr_t          )
035300170213     D  i_fndRplStrL                       value  likeds(fndRplStrL_t )
035400170213     D  i_case                             value  like(keyword_t      )
035500170213     D  i_wildcard                         value  like(varChar_t      )
035600170213      *
035700170213      *  Local fields
035800170213     D isError         S                   like(bool_t    ) inz(cFalse)
035900170213     D isDone          S                   like(bool_t    ) inz(cFalse)
036000170213     D isChanged       S                   like(bool_t    ) inz(cFalse)
036100170213     D isProgressMeter...
036200170213     D                 S                   like(bool_t    ) inz(cFalse)
036300170213     D x               S                   like(int4_t    ) inz
036400170213     D numChanges      S                   like(int4_t    ) inz
036500170213     D sumChanges      S                   like(int4_t    ) inz
036600170213     D numRcdPrc       S                   like(int4_t    ) inz
036700170213      *
036800170213     D msg             DS                  likeds(msg_t        ) inz
036900170213     D fndRplStrL      DS                  likeds(fndRplStrL_t ) inz
037000170213     D entry           DS                  likeds(entry_t      ) based(pEntry)
037100170213      *
037200170213      *  Messages
037300170213      /COPY QFNDRPLSTR,FRS0001
037400170213      /COPY QFNDRPLSTR,FRS0002
037500170213      /COPY QFNDRPLSTR,FRS0003
037600170213      /COPY QFNDRPLSTR,FRS0005
037700170213      *-------------------------------------------------------------------
037800170213      /FREE
037900170213
038000170213         fndRplStrL = i_fndRplStrL;
038100170213
038200170213         // Open file
038300170213         g_file = %trim(i_lib) + '/' + %trim(i_file);
038400170213         g_mbr  = i_mbr;
038500170213
038600170213         open   file;
038700170213         rmvMsgByIDAndType(cMsg_Diag: 'CPF4011');   // Buffer length longer than record ...
038800170213
038900170213         // Decide whether to use the progress meter or a static message
039000170213         if   file_FB.open_FB.numRcdAtOpn >= 10000;
039100170213            isProgressMeter = cTrue;
039200170213         else;
039300170213            isProgressMeter = cFalse;
039400170213         endif;
039500170213
039600170213         // If the progress meter has to be shown ...
039700170213         if   isProgressMeter;
039800170213            // ... then initialize progress meter
039900170213            msg = newAppMsg('FRS0005': FRS0005: cMsg_Info);
040000170213            p_inzProgressMeter(f_rtvMsgText(msg) + ' ' +
040100170213                               %trimR(file_FB.open_FB.mbr) + ':'  :
040200170213                               file_FB.open_FB.numRcdAtOpn:
040300170213                               cPrgMtr_Blue: 1: cPrgMtr_JobType_Dlg);
040400170213         else;
040500170213            // ... else send static information message
040600170213            clear   FRS0001;
040700170213            FRS00011 = i_mbr;
040800170213            msg = newAppMsg('FRS0001': FRS0001: cMsg_Status);
040900170213            f_sndPgmMsg(msg: cMsg_Ext);
041000170213         endif;
041100170213
041200170213         // Process file member
041300170213         dou   isError or isDone;
041400170213            if   file_FB.open_FB.srcFileInd = cSrcFile_ind_Yes;
041500170213               if   file_FB.open_FB.maxRcdLength > %size(ds_srcMbr);
041600170213                  isError = cTrue;
041700170213                  leave;
041800170213               endif;
041900170213            else;
042000170213               if   file_FB.open_FB.maxRcdLength > %size(ds_file);
042100170213                  isError = cTrue;
042200170213                  leave;
042300170213               endif;
042400170213            endif;
042500170213
042600170213            // Spin through (source) member
042700170213            numRcdPrc = 0;
042800170213
042900170213            setll   1   file;
043000170213            dow   %found(file);
043100170213               if   file_FB.open_FB.srcFileInd = cSRCFILE_IND_YES;
043200170213                  read   file   ds_srcMbr;
043300170213               else;
043400170213                  read   file   ds_file;
043500170213               endif;
043600170213               if   %eof(file);
043700170213                  leave;
043800170213               endif;
043900170213
044000170213               // Show progress meter
044100170213               if   isProgressMeter;
044200170213                  numRcdPrc = numRcdPrc + 1;
044300170213                  p_showProgressMeter(numRcdPrc);
044400170213               endif;
044500170213
044600170213               // Spin through search & replace string list
044700170213               isChanged = cFalse;
044800170213               for   x = 1 to fndRplStrL.numEntries;
044900170213                  pEntry = %addr(fndRplStrL) + fndRplStrL.offsets(x);
045000170213                  if   %len(entry.find) > 0;
045100170213                     if   file_FB.open_FB.srcFileInd = cSRCFILE_IND_YES;
045200170213                        ds_srcMbr.srcDta = replaceString(
045300170213                                                  numChanges                 :
045400170213                                                  f_rmvQuotes(entry.find
045500170213                                                              : cDblQuotes)  :
045600170213                                                  f_rmvQuotes(entry.replace
045700170213                                                              : cDblQuotes)  :
045800170213                                                  ds_srcMbr.srcDta           :
045900170213                                                  i_case                     :
046000170213                                                  i_wildcard                 );
046100170213                     else;
046200170213                        ds_file.buffer = replaceString(
046300170213                                                  numChanges                 :
046400170213                                                  f_rmvQuotes(entry.find
046500170213                                                              : cDblQuotes)  :
046600170213                                                  f_rmvQuotes(entry.replace
046700170213                                                              : cDblQuotes)  :
046800170213                                                  ds_file.buffer             :
046900170213                                                  i_case                     :
047000170213                                                  i_wildcard                 );
047100170213                     endif;
047200170213                     if   numChanges > 0;
047300170213                        sumChanges = sumChanges + numChanges;
047400170213                        isChanged  = cTrue;
047500170213                     endif;
047600170213                  endif;
047700170213               endfor;
047800170213
047900170213                  if   isChanged;
048000170213                     if   file_FB.open_FB.srcFileInd = cSRCFILE_IND_YES;
048100170213                        update   file   ds_srcMbr;
048200170213                     else;
048300170213                        update   file   ds_file;
048400170213                     endif;
048500170213                  else;
048600170213                     unlock   file;
048700170213                  endif;
048800170213            enddo;
048900170213
049000170213            isDone = cTrue;
049100170213         enddo;
049200170213
049300170213         // Close file
049400170213         if   %open(file);
049500170213            close   file;
049600170213         endif;
049700170213
049800170213         // Send completion message
049900170213         if   sumChanges > 0;
050000170213            clear   FRS0002;
050100170213            FRS00021 = sumChanges;
050200170213            FRS00022 = i_mbr;
050300170213            FRS00023 = i_file;
050400170213            FRS00024 = i_lib;
050500170213            msg = newAppMsg('FRS0002': FRS0002: cMsg_Info);
050600170213            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
050700170213         else;
050800170213            clear   FRS0003;
050900170213            FRS00031 = 0;
051000170213            FRS00032 = i_mbr;
051100170213            FRS00033 = i_file;
051200170213            FRS00034 = i_lib;
051300170213            msg = newAppMsg('FRS0003': FRS0003: cMsg_Info);
051400170213            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
051500170213         endif;
051600170213
051700170213         return;
051800170213
051900170213      /END-FREE
052000170213      *
052100170213     P processMbr...
052200170213     P                 E
052300170213      *
052400170213      *=========================================================================
052500170213      *  Replaces all occurences of a search argument by
052600170213      *  a replacement string in a given string.
052700170213      *=========================================================================
052800170213      *  Parameters:
052900170213      *   i_searchArg   - The argument that is replaced by the replacement
053000170213      *                   string.
053100170213      *   i_rplString   - The replacement string that replaces the search
053200170213      *                   argument.
053300170213      *   i_string      - The string that contains the search argument.
053400170213      *   i_case        - Kind of match:  *IGNORE - Search string without
053500170213      *                                             case sensitivity.
053600170213      *                                   *MATCH  - Search for an exact match
053700170213      *                                             to the string.
053800170213      *   i_startPos    - The position where to start from.
053900170213      *   i_endPos      - Last position to find the search argument.
054000170213      *
054100170213      *  Returns:
054200170213      *   string        - The string having the search argument replaced with
054300170213      *                   the replacement string.
054400170213      *=========================================================================
054500170213      *
054600170213     P replaceString...
054700170213     P                 B
054800170213      *
054900170213     D replaceString...
055000170213     D                 PI                         like(string_t  )
055100170213     D  o_numChanges                              like(int4_t    )
055200170213     D  i_searchArg                        const  like(string_t  )
055300170213     D  i_rplString                        const  like(string_t  )
055400170213     D  i_string                           const  like(string_t  )
055500170213     D  i_case                             const  like(keyword_t )
055600170213     D  i_wildcard                         const  like(varChar_t )
055700170213     D                                            options(*nopass)
055800170213     D  i_startPos                         const  like(int4_t    )
055900170213     D                                            options(*nopass)
056000170213     D  i_endPos                           const  like(int4_t    )
056100170213     D                                            options(*nopass)
056200170213      *
056300170213      *  Return value
056400170213     D string          S                   like(string_t  ) inz
056500170213      *
056600170213      *  Parameter positions
056700170213     D p_wildcard      C                   const(6)
056800170213     D p_startPos      C                   const(7)
056900170213     D p_endPos        C                   const(8)
057000170213      *
057100170213      *  Optional parameter fields
057200170213     D startPos        S                   like(i_startPos) inz
057300170213     D endPos          S                   like(i_endPos  ) inz
057400170213     D wildcard        S                   like(i_wildcard) inz
057500170213      *
057600170213      *  Local fields
057700170213     D X               S                   like(int4_t    ) inz
057800170213      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
057900170213      /FREE
058000170213
058100170213         o_numChanges = 0;
058200170213
058300170213         if   %parms >= p_wildcard;
058400170213            wildcard = i_wildcard;
058500170213         else;
058600170213            wildcard = '';
058700170213         endif;
058800170213
058900170213         if   %parms >= p_startPos;
059000170213            startPos = i_startPos;
059100170213         else;
059200170213            startPos = 1;
059300170213         endif;
059400170213
059500170213         if   %parms >= p_endPos;
059600170213            endPos = i_endPos;
059700170213         else;
059800170213            endPos = %len(i_string);
059900170213         endif;
060000170213
060100170213         string = i_string;
060200170213
060300170213         if   i_case = cIgnore;
060400170213            x = scan(f_lcase(i_searchArg)
060500170213                     : f_lcase(string): startPos: wildcard);
060600170213         else;
060700170213            x = scan(i_searchArg: string: startPos: wildcard);
060800170213         endif;
060900170213
061000170213         dow   (x > 0) and (x < endPos);
061100170213            o_numChanges = o_numChanges + 1;
061200170213            string = replace(i_rplString
061300170213                             : string: x: %len(i_searchArg): wildcard);
061400170213            x = x + %len(i_rplString);
061500170213            if   x < %len(string);
061600170213               if   i_case = cIgnore;
061700170213                  x = scan(f_lcase(i_searchArg)
061800170213                           : f_lcase(string): x: wildcard);
061900170213               else;
062000170213                  x = scan(i_searchArg: string: x: wildcard);
062100170213               endif;
062200170213            endif;
062300170213         enddo;
062400170213
062500170213         return   string;
062600170213
062700170213      /END-FREE
062800170213      *
062900170213     P replaceString...
063000170213     P                 E
063100170213      *
063200170213      *=========================================================================
063300170213      *  Returns the first position of the search argument in the source
063400170213      *  string, or 0 if it was not found.
063500170213      *=========================================================================
063600170213      *  Parameters:
063700170213      *   i_searchArg   - The argument that is replaced by the replacement
063800170213      *                   string.
063900170213      *   i_string      - The string that contains the search argument.
064000170213      *   i_startPos    - The position where to start from.
064100170213      *   i_wildcard    - The wildcard character.
064200170213      *
064300170213      *  Returns:
064400170213      *   pos           - The first position of the search argument
064500170213      *                   in the source.
064600170213      *=========================================================================
064700170213      *
064800170213     P scan...
064900170213     P                 B
065000170213      *
065100170213     D scan...
065200170213     D                 PI                         like(int4_t    )
065300170213     D  i_searchArg                        const  like(string_t  )
065400170213     D  i_string                           const  like(string_t  )
065500170213     D  i_startPos                         const  like(int4_t    )
065600170213     D                                            options(*nopass)
065700170213     D  i_wildcard                         const  like(varChar_t )
065800170213     D                                            options(*nopass)
065900170213      *
066000170213      *  Parameter positions
066100170213     D p_startPos      C                   const(3)
066200170213     D p_wildcard      C                   const(4)
066300170213      *
066400170213      *  Optional parameter fields
066500170213     D startPos        S                   like(i_startPos) inz
066600170213     D wildcard        S                   like(i_wildcard) inz
066700170213      *
066800170213      *  Return value
066900170213     D pos             S                   like(int4_t    ) inz
067000170213      *
067100170213      *  Local fields
067200170213     D x               S                   like(int4_t    ) inz
067300170213     D y               S                   like(int4_t    ) inz
067400170213     D match           S                   like(int4_t    ) inz
067500170213      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
067600170213      /FREE
067700170213
067800170213         if (%parms() >= p_startPos);
067900170213            startPos = i_startPos;
068000170213         else;
068100170213            startPos = 1;
068200170213         endif;
068300170213
068400170213         if (%parms() >= p_wildcard);
068500170213            wildcard = i_wildcard;
068600170213         else;
068700170213            wildcard = '';
068800170213         endif;
068900170213
069000170213         if (wildcard = '');
069100170213            pos = %scan(i_searchArg: i_string: startPos);
069200170213            return pos;
069300170213         endif;
069400170213
069500170213         match = 0;
069600170213         for x = 1 to (%len(i_string) - %len(i_searchArg) + 1);
069700170213            match = 0;
069800170213            for y = 1 to %len(i_searchArg);
069900170213               if (%subst(i_searchArg: y: 1) <> wildcard and
070000170213                   %subst(i_string: x+y-1: 1) <> %subst(i_searchArg: y: 1));
070100170213                  leave;
070200170213               endif;
070300170213               match = match + 1;
070400170213               if (match = %len(i_searchArg));
070500170213                  pos = x;
070600170213                  return pos;
070700170213               endif;
070800170213            endfor;
070900170213         endfor;
071000170213
071100170213         return pos;
071200170213
071300170213      /END-FREE
071400170213      *
071500170213     P scan...
071600170213     P                 E
071700170213      *
071800170213      *=========================================================================
071900170213      *  Returns the character string produced by inserting a replacement string
072000170213      *  into the source string, starting at the start position and replacing
072100170213      *  the specified number of characters.
072200170213      *=========================================================================
072300170213      *  Parameters:
072400170213      *   i_rplString   - The replacement string.
072500170213      *   i_string      - The source string.
072600170213      *   i_startPos    - The position where to start from.
072700170213      *   i_length      - The length of the string that is replaced.
072800170213      *   i_wildcard    - The wildcard character.
072900170213      *
073000170213      *  Returns:
073100170213      *   pos           - The first position of the search argument
073200170213      *                   in the source.
073300170213      *=========================================================================
073400170213      *
073500170213     P replace...
073600170213     P                 B
073700170213      *
073800170213     D replace...
073900170213     D                 PI                         like(string_t  )
074000170213     D  i_rplString                        const  like(string_t  )
074100170213     D  i_string                           const  like(string_t  )
074200170213     D  i_startPos                         const  like(int4_t    )
074300170213     D                                            options(*nopass)
074400170213     D  i_length                           const  like(int4_t    )
074500170213     D                                            options(*nopass)
074600170213     D  i_wildcard                         const  like(varChar_t )
074700170213     D                                            options(*nopass)
074800170213      *
074900170213      *  Parameter positions
075000170213     D p_startPos      C                   const(3)
075100170213     D p_length        C                   const(4)
075200170213     D p_wildcard      C                   const(5)
075300170213      *
075400170213      *  Optional parameter fields
075500170213     D startPos        S                   like(i_startPos ) inz
075600170213     D length          S                   like(i_length   ) inz
075700170213     D wildcard        S                   like(i_wildcard ) inz
075800170213      *
075900170213      *  Return value
076000170213     D newString       S                   like(string_t   ) inz
076100170213      *
076200170213      *  Local fields
076300170213     D x               S                   like(int4_t     ) inz
076400170213     D rplString       S                   like(i_rplString) inz
076500170213      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
076600170213      /FREE
076700170213
076800170213         if (%parms() >= p_startPos);
076900170213            startPos = i_startPos;
077000170213         else;
077100170213            startPos = 1;
077200170213         endif;
077300170213
077400170213         if (%parms() >= p_length);
077500170213            length = i_length;
077600170213         else;
077700170213            length = %len(i_rplString);
077800170213         endif;
077900170213
078000170213         if (%parms() >= p_wildcard);
078100170213            wildcard = i_wildcard;
078200170213         else;
078300170213            wildcard = '';
078400170213         endif;
078500170213
078600170213         if (wildcard = '');
078700170213            newString = %replace(i_rplString: i_string: startPos: length);
078800170213            return newString;
078900170213         endif;
079000170213
079100170213         rplString = i_rplString;
079200170213
079300170213         x = 1;
079400170213         dow (x <= %len(i_rplString));
079500170213            if (%subst(i_rplString: x: 1) = wildcard);
079600170213               %subst(rplString: x: 1) = %subst(i_string: startPos + x - 1: 1);
079700170213            endif;
079800170213            x = x + 1;
079900170213         enddo;
080000170213
080100170213         newString = %replace(rplString: i_string: startPos: length);
080200170213
080300170213         return newString;
080400170213
080500170213      /END-FREE
080600170213      *
080700170213     P replace...
080800170213     P                 E
080900170213      *
081000170213      *=========================================================================
081100170213      *  Is generic?
081200170213      *=========================================================================
081300170213      *
081400170213     P isGeneric...
081500170213     P                 B
081600170213      *
081700170213     D isGeneric...
081800170213     D                 PI                         like(bool_t    )
081900170213     D  i_string                           const  like(string_t  )
082000170213      *
082100170213      *  Return value
082200170213     D isGeneric       S                   like(bool_t    ) inz(cFalse)
082300170213      *
082400170213      *  Local fields
082500170213     D string          S                   like(i_string  ) inz
082600170213      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
082700170213      /FREE
082800170213
082900170213         string = %trim(i_string);
083000170213
083100170213         if   (%subst(string: 1: 1)            = '*') or
083200170213              (%subst(string: %len(string): 1) = '*');
083300170213            isGeneric = cTrue;
083400170213         else;
083500170213            isGeneric = cFalse;
083600170213         endif;
083700170213
083800170213         return   isGeneric;
083900170213
084000170213      /END-FREE
084100170213      *
084200170213     P isGeneric...
084300170213     P                 E
084400170213      *
084500170213      *======================================================================================
084600170213      *  Remove last message.
084700170213      *
084800170213      * Erzeugt mit PRC-Template V1.1 (Zeile bitte nicht löschen)
084900170213      *======================================================================================
085000170213     P rmvMsgByIDAndType...
085100170213     P                 B
085200170213      *
085300170213     D rmvMsgByIDAndType...
085400170213     D                 PI
085500170213     D i_msgType                           const  like(msg_t.type)
085600170213     D i_msgID                             const  like(msg_t.ID  )
085700170213      *
085800170213      * Local helper fields
085900170213     D rcvm0200        DS                  likeds(rcvm0200_t) inz
086000170213     D msg             DS                  likeds(msg_t     ) inz
086100170213      * ---------------------------------------------------------
086200170213      /FREE
086300170213
086400170213         // empfangen letzte *ESCAPE Nachricht
086500170213         rcvm0200 = f_rcvPgmMsg(cMsg_Diag: *omit: cMsg_Act_Same: 0:
086600170213                                cMsg_Prv: cMsg_ToMyself: *omit: *omit: msg);
086700170213
086800170213         // löschen Nachrichten
086900170213         if (msg.ID = cMSG_ID_OK);
087000170213            if (i_msgID = rcvm0200.msgID) or (i_msgID = '');
087100170213               p_rmvPgmMsg(cMsg_Rmv_ByKey: rcvm0200.msgKey
087200170213                           : cMsg_Prv: cMsg_ToMyself);
087300170213            endif;
087400170213         endif;
087500170213
087600170213         return;
087700170213
087800170213      /END-FREE
087900170213      *
088000170213     P rmvMsgByIDAndType...
088100170213     P                 E
088200170213      *
088300170213      *===============================================================*
088400170213      *  Create new message.
088500170213      *===============================================================*
088600170213     P newAppMsg...
088700170213     P                 B
088800170213      *
088900170213     D newAppMsg...
089000170213     D                 PI                         like(msg_t     )
089100170213     D  i_msgID                            const  like(msg_t.ID  )
089200170213     D                                            options(*nopass: *omit)
089300170213     D  i_msgData                          const  like(msg_t.data)
089400170213     D                                            options(*nopass: *omit)
089500170213     D  i_msgType                          const  like(msg_t.type)
089600170213     D                                            options(*nopass: *omit)
089700170213      *
089800170213      *  Return value
089900170213     D msg             DS                  likeds(msg_t   ) inz
090000170213      *
090100170213      *  Parameter positions
090200170213     D p_msgID         C                   const(1)
090300170213     D p_msgData       C                   const(2)
090400170213     D p_msgType       C                   const(3)
090500170213      *
090600170213      *  Optional parameter fields
090700170213     D msgID           S                   like(i_msgID   ) inz
090800170213     D msgData         S                   like(i_msgData ) inz
090900170213     D msgType         S                   like(i_msgType ) inz
091000170213      *
091100170213      *  Hilfsfelder für System-API: CEETSTA
091200170213     D isPresent       S                   like(int4_t    ) inz
091300170213      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
091400170213      /FREE
091500170213
091600170213         select;
091700170213         when (%parms() >= p_msgType);   // 3 or more parameters
091800170213            msg = f_newMsg(i_msgID: i_msgData: i_msgType: cAppMsgF:cAppMsgFLib);
091900170213
092000170213         when (%parms() = p_msgData);    // 2 parameters
092100170213            msg = f_newMsg(i_msgID: i_msgData: *omit: cAppMsgF: cAppMsgFLib);
092200170213
092300170213         when (%parms() = p_msgID);      // 1 parameter
092400170213            msg = f_newMsg(i_msgID: *omit: *omit: cAppMsgF: cAppMsgFLib);
092500170213
092600170213         other;                          // no parameters
092700170213            msg = f_newMsg(*omit: *omit: *omit: cAppMsgF: cAppMsgFLib);
092800170213         endsl;
092900170213
093000170213         return msg;
093100170213
093200170213      /END-FREE
093300170213      *
093400170213     P newAppMsg...
093500170213     P                 E
093600170213      *
