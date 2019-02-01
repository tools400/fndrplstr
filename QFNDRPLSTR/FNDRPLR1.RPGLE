      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  05.01.2004                                              *
      *  E-mail  :  Thomas.Raddatz@Tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  16.12.2008  Th.Raddatz    Now ds_srcMbr.srcDta correctly starts    *
      *                            at position 7.                           *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< OPTION(*EVENTF);                                     *
      *     >>END-COMPILE<<                                                 *
      *     >>EXECUTE<<                                                     *
      *     >>CMD<<     CRTPGM       PGM(&LI/FNDRPLSTR) +                   *
      *                              MODULE(&LI/&OB       +                 *
      *                                     &LI/PRGMTRR1) +                 *
      *                              ENTMOD(&LI/&OB) +                      *
      *                              ACTGRP(*NEW) +                         *
      *                              BNDSRVPGM(*LIBL/RTVMBRL  +             *
      *                                        *LIBL/BASICS1) +             *
      *                              DETAIL(*BASIC);                        *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /copy QFNDRPLSTR,H_SPEC
      /copy QFNDRPLSTR,COPYRIGHT
      *=====================================================================*
     FFILE      UF   F32766        DISK    usropn
     F                                     extfile(g_file    )
     F                                     extmbr(g_mbr      )
     F                                     infds(file_FB     )
      *
     D file_FB         DS                  likeds(file_FB_t  )
      *
     D g_file          S             21A   inz
     D g_mbr           S                   inz    like(mbr_t     )
      *
     D ds_file         DS                  qualified
     D  buffer                 1  32766A
      *
     D ds_srcMbr       DS                  qualified
     D  srcSeq                 1      6S 2
     D  srcDat                 7     12S 0
     D  srcDta                13  32766A
      *
      *  Type Definitions
     D bool_t          S               N   based(pDummy)
     D int4_t          S             10I 0 based(pDummy)
     D file_t          S             10A   based(pDummy)
     D lib_t           S             10A   based(pDummy)
     D mbr_t           S             10A   based(pDummy)
     D string_t        S          32766A   based(pDummy)   varying
     D keyword_t       S             10A   based(pDummy)
     D varChar_t       S              1A   based(pDummy)   varying
      *
      /COPY QFNDRPLSTR,FDQOBJ                     Qualified object name
      *
      /COPY QBASICS1,PBASICS1                     Tools/400 Runtime Library
      /COPY QFNDRPLSTR,PPRGMTRR1                  Progress Meter
      /COPY QFNDRPLSTR,CEELIB                     CEE APIs
      *
     D mbrl0200_t      DS                  qualified             based(pDummy)
     D  mbr                          10A
     D  srcType                      10A
     D  crtDatTim                    13A
     D  cghDatTim                    13A
     D  text                         50A
     D  textCcsid                    10U 0
      *
     D fndRplStrL_t    DS                  qualified             based(pDummy)
     D  numEntries                    5I 0
     D  offsets                       5I 0                       dim(cNumValues)
     D  entries                            likeds(entry_t    )   dim(cNumValues)
      *
     D entry_t         DS                  qualified             based(pDummy)
     D  numValues                     5I 0
     D  find                         25A   varying
     D  replace                      25A   varying
      *
     D file_FB_t       DS           512    qualified   based(pDummy)
     D  status                11     15P 0
     D  msg                   46     52A
     D  open_FB                            likeds(open_FB_t  )
     D                                     overlay(file_FB_t:  81)
     D  IO_FB                              likeds(IO_FB_t    )
     D                                     overlay(file_FB_t: 241)
     D  DB_IO_FB                           likeds(DB_IO_FB_t )
     D                                     overlay(file_FB_t: 367)
      *
     D open_FB_t       DS                  qualified   based(pDummy)
     D  odpType                1      2A
     D  file                   3     12A
     D  lib                   13     22A
     D  splF                  23     32A
     D  splFLib               33     42A
     D  splFNbr               43     44I 0
     D  maxRcdLength          45     46I 0
     D  maxKeyLength          47     48I 0
     D  mbr                   49     58A
     D  res_01                59     62I 0
     D  res_02                63     66I 0
     D  fileType              67     68I 0
     D  res_03                69     71A
     D  numRcdAtOpn           76     79U 0
     D  srcFileInd            83     83A
      *
     D IO_FB_t         DS                  qualified   based(pDummy)
     D  writeCount             3      6I 0
     D  readCount              7     10I 0
     D  wrRdCount             11     14I 0
     D  otherCount            15     18I 0
     D  res_01                19     19A
     D  currOper              20     20A
     D  rcdFormat             21     30A
     D  deviceClass           31     32A
     D  deviceName            33     42A
     D  lastRcdLenPrc         43     46I 0
     D  res_02                47    126A
     D  rdBlkSize            127    128I 0
     D  curBlkCount          133    136I 0
      *
     D DB_IO_FB_t      DS                  qualified   based(pDummy)
     D  numLckRcd             11     12I 0
     D  maxNumFld             13     14I 0
     D  numKeyFld             21     22I 0
     D  keyLength             27     28I 0
     D  dataMbrNbr            29     30I 0
     D  rrn                   31     34U 0
      *
      *  Prototype for the RTVMBRL service program
      /COPY QRTVMBRL,PRTVMBRL
      *
      *  Prototypes for Program Entry Point
     D PGM_ENTRY_POINT...
     D                 PR                  extpgm('FNDRPLR1')
     D  gi_qFile                           const  like(qObj_t         )
     D  gi_mbr                             const  like(mbr_t          )
     D  gi_fndRplStrL                      const  likeds(fndRplStrL_t )
     D  gi_case                            const  like(keyword_t      )
     D  gi_wildcard                        const  like(varChar_t      )
      *
      *  Prototypes for internal procedures
     D main...
     D                 PR
     D  i_qFile                            const  like(gi_qFile       )
     D  i_mbr                              const  like(gi_mbr         )
     D  i_fndRplStrL                       const  likeds(gi_fndRplStrL)
     D  i_case                             const  like(gi_case        )
     D  i_wildcard                         const  like(gi_wildcard    )
      *
     D processMbr...
     D                 PR
     D  i_file                             value  like(file_t         )
     D  i_lib                              value  like(lib_t          )
     D  i_mbr                              value  like(mbr_t          )
     D  i_fndRplStrL                       value  likeds(fndRplStrL_t )
     D  i_case                             value  like(keyword_t      )
     D  i_wildcard                         value  like(varChar_t      )
      *
     D replaceString...
     D                 PR                         like(string_t  )
     D  o_numChanges                              like(int4_t    )
     D  i_searchArg                        const  like(string_t  )
     D  i_rplString                        const  like(string_t  )
     D  i_string                           const  like(string_t  )
     D  i_case                             const  like(keyword_t )
     D  i_wildcard                         const  like(varChar_t )
     D                                            options(*nopass)
     D  i_startPos                         const  like(int4_t    )
     D                                            options(*nopass)
     D  i_endPos                           const  like(int4_t    )
     D                                            options(*nopass)
      *
     D scan...
     D                 PR                         like(int4_t    )
     D  i_searchArg                        const  like(string_t  )
     D  i_string                           const  like(string_t  )
     D  i_startPos                         const  like(int4_t    )
     D                                            options(*nopass)
     D  i_wildcard                         const  like(varChar_t )
     D                                            options(*nopass)
      *
     D replace...
     D                 PR                         like(string_t  )
     D  i_rplString                        const  like(string_t  )
     D  i_string                           const  like(string_t  )
     D  i_startPos                         const  like(int4_t    )
     D                                            options(*nopass)
     D  i_length                           const  like(int4_t    )
     D                                            options(*nopass)
     D  i_wildcard                         const  like(varChar_t )
     D                                            options(*nopass)
      *
     D isGeneric...
     D                 PR                         like(bool_t    )
     D  i_string                           const  like(string_t  )
      *
     D rmvMsgByIDAndType...
     D                 PR
     D i_msgType                           const  like(msg_t.type)
     D i_msgID                             const  like(msg_t.ID  )
      *
      *  Create new message.
     D newAppMsg...
     D                 PR                         like(msg_t     )
     D  i_msgID                            const  like(msg_t.ID  )
     D                                            options(*nopass: *omit)
     D  i_msgData                          const  like(msg_t.data)
     D                                            options(*nopass: *omit)
     D  i_msgType                          const  like(msg_t.type)
     D                                            options(*nopass: *omit)
      *
      *  Global Constants
     D cNumValues      C                   const(10)
     D cDblQuotes      C                   const('"')
      *
     D cSrcFile_ind_Yes...
     D                 C                   const('Y')
     D cSrcFile_ind_No...
     D                 C                   const('N')
      *
     D cMbr_First      C                   const('*FIRST')
     D cMbr_All        C                   const('*ALL')
      *
     D cIgnore         C                   const('*IGNORE')
     D cMatch          C                   const('*MATCH')
      *
     D cAppMsgF        C                   const('FNDRPLSTR')
     D cAppMsgFLib     C                   const('*LIBL')
      *
      ********************************************************************
      *  Program Entry Point
      ********************************************************************
      *
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_qFile                           const  like(qObj_t         )
     D  gi_mbr                             const  like(mbr_t          )
     D  gi_fndRplStrL                      const  likeds(fndRplStrL_t )
     D  gi_case                            const  like(keyword_t      )
     D  gi_wildcard                        const  like(varChar_t      )
      *-------------------------------------------------------------------
      /FREE

         main(gi_qFile: gi_mbr: gi_fndRplStrL: gi_case: gi_wildcard);

         *inlr = *on;

      /END-FREE
      *
      *==================================================================*
      *  Main Procedure
      *==================================================================*
      *
     P main...
     P                 B
      *
     D main...
     D                 PI
     D  i_qFile                            const  like(gi_qFile       )
     D  i_mbr                              const  like(gi_mbr         )
     D  i_fndRplStrL                       const  likeds(gi_fndRplStrL)
     D  i_case                             const  like(gi_case        )
     D  i_wildcard                         const  like(gi_wildcard    )
      *
      *  Local fields
     D isMbr           S                   like(bool_t         ) inz(cFalse)
     D hMbrList        S                   like(mbrLst_handle_t) inz
      *
     D msg             S                   like(msg_t          ) inz
     D qFile           DS                  likeds(qObj_t       ) inz
     D mbrl0200        DS                  likeds(mbrl0200_t   ) inz
     D mbrl0200_hlp    S                   like(mbrl0200       )
     D                                     based(pMbrl0200_hlp )
     D pMbrl0200_hlp   S               *   inz(%addr(mbrl0200  ))
      *
      *  Messages
      /COPY QFNDRPLSTR,FRS0004
      *-------------------------------------------------------------------
      /FREE

         qFile = i_qFile;

         // If the member name is *FIRST and not a generic value ...
         // (Since special values are also treated as "generic" values
         //  we have to exclude *FIRST from that.)
         if   (i_mbr = cMbr_First) or (not isGeneric(i_mbr));
            // ... then process the member
            processMbr(qFile.name: qFile.lib:
                       i_mbr: i_fndRplStrL: i_case: i_wildcard);
         else;
            // ... else retrieve member list and process each member
            clear   FRS0004;
            msg = newAppMsg('FRS0004': FRS0004: cMsg_Status);
            f_sndPgmMsg(msg: cMsg_Ext);

            if   not f_opnMbrLst(qFile.name: qFile.lib:
                                 i_mbr: '*NAME': hMbrList: msg);
               f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
            else;
               isMbr = f_getFirstMbr(hMbrList: mbrl0200_hlp);

               dow   isMbr;
                  processMbr(qFile.name: qFile.lib:
                             mbrl0200.mbr: i_fndRplStrL: i_case: i_wildcard);
                  isMbr = f_getNextMbr(hMbrList: mbrl0200_hlp);
               enddo;

               f_cloMbrLst(hMbrList);

            endif;
         endif;

         return;

      /END-FREE
      *
     P main...
     P                 E
      *
      *==================================================================*
      *  Process Member
      *==================================================================*
      *
     P processMbr...
     P                 B
      *
     D processMbr...
     D                 PI
     D  i_file                             value  like(file_t         )
     D  i_lib                              value  like(lib_t          )
     D  i_mbr                              value  like(mbr_t          )
     D  i_fndRplStrL                       value  likeds(fndRplStrL_t )
     D  i_case                             value  like(keyword_t      )
     D  i_wildcard                         value  like(varChar_t      )
      *
      *  Local fields
     D isError         S                   like(bool_t    ) inz(cFalse)
     D isDone          S                   like(bool_t    ) inz(cFalse)
     D isChanged       S                   like(bool_t    ) inz(cFalse)
     D isProgressMeter...
     D                 S                   like(bool_t    ) inz(cFalse)
     D x               S                   like(int4_t    ) inz
     D numChanges      S                   like(int4_t    ) inz
     D sumChanges      S                   like(int4_t    ) inz
     D numRcdPrc       S                   like(int4_t    ) inz
      *
     D msg             DS                  likeds(msg_t        ) inz
     D fndRplStrL      DS                  likeds(fndRplStrL_t ) inz
     D entry           DS                  likeds(entry_t      ) based(pEntry)
      *
      *  Messages
      /COPY QFNDRPLSTR,FRS0001
      /COPY QFNDRPLSTR,FRS0002
      /COPY QFNDRPLSTR,FRS0003
      /COPY QFNDRPLSTR,FRS0005
      *-------------------------------------------------------------------
      /FREE

         fndRplStrL = i_fndRplStrL;

         // Open file
         g_file = %trim(i_lib) + '/' + %trim(i_file);
         g_mbr  = i_mbr;

         open   file;
         rmvMsgByIDAndType(cMsg_Diag: 'CPF4011');   // Buffer length longer than record ...

         // Decide whether to use the progress meter or a static message
         if   file_FB.open_FB.numRcdAtOpn >= 10000;
            isProgressMeter = cTrue;
         else;
            isProgressMeter = cFalse;
         endif;

         // If the progress meter has to be shown ...
         if   isProgressMeter;
            // ... then initialize progress meter
            msg = newAppMsg('FRS0005': FRS0005: cMsg_Info);
            p_inzProgressMeter(f_rtvMsgText(msg) + ' ' +
                               %trimR(file_FB.open_FB.mbr) + ':'  :
                               file_FB.open_FB.numRcdAtOpn:
                               cPrgMtr_Blue: 1: cPrgMtr_JobType_Dlg);
         else;
            // ... else send static information message
            clear   FRS0001;
            FRS00011 = i_mbr;
            msg = newAppMsg('FRS0001': FRS0001: cMsg_Status);
            f_sndPgmMsg(msg: cMsg_Ext);
         endif;

         // Process file member
         dou   isError or isDone;
            if   file_FB.open_FB.srcFileInd = cSrcFile_ind_Yes;
               if   file_FB.open_FB.maxRcdLength > %size(ds_srcMbr);
                  isError = cTrue;
                  leave;
               endif;
            else;
               if   file_FB.open_FB.maxRcdLength > %size(ds_file);
                  isError = cTrue;
                  leave;
               endif;
            endif;

            // Spin through (source) member
            numRcdPrc = 0;

            setll   1   file;
            dow   %found(file);
               if   file_FB.open_FB.srcFileInd = cSRCFILE_IND_YES;
                  read   file   ds_srcMbr;
               else;
                  read   file   ds_file;
               endif;
               if   %eof(file);
                  leave;
               endif;

               // Show progress meter
               if   isProgressMeter;
                  numRcdPrc = numRcdPrc + 1;
                  p_showProgressMeter(numRcdPrc);
               endif;

               // Spin through search & replace string list
               isChanged = cFalse;
               for   x = 1 to fndRplStrL.numEntries;
                  pEntry = %addr(fndRplStrL) + fndRplStrL.offsets(x);
                  if   %len(entry.find) > 0;
                     if   file_FB.open_FB.srcFileInd = cSRCFILE_IND_YES;
                        ds_srcMbr.srcDta = replaceString(
                                                  numChanges                 :
                                                  f_rmvQuotes(entry.find
                                                              : cDblQuotes)  :
                                                  f_rmvQuotes(entry.replace
                                                              : cDblQuotes)  :
                                                  ds_srcMbr.srcDta           :
                                                  i_case                     :
                                                  i_wildcard                 );
                     else;
                        ds_file.buffer = replaceString(
                                                  numChanges                 :
                                                  f_rmvQuotes(entry.find
                                                              : cDblQuotes)  :
                                                  f_rmvQuotes(entry.replace
                                                              : cDblQuotes)  :
                                                  ds_file.buffer             :
                                                  i_case                     :
                                                  i_wildcard                 );
                     endif;
                     if   numChanges > 0;
                        sumChanges = sumChanges + numChanges;
                        isChanged  = cTrue;
                     endif;
                  endif;
               endfor;

                  if   isChanged;
                     if   file_FB.open_FB.srcFileInd = cSRCFILE_IND_YES;
                        update   file   ds_srcMbr;
                     else;
                        update   file   ds_file;
                     endif;
                  else;
                     unlock   file;
                  endif;
            enddo;

            isDone = cTrue;
         enddo;

         // Close file
         if   %open(file);
            close   file;
         endif;

         // Send completion message
         if   sumChanges > 0;
            clear   FRS0002;
            FRS00021 = sumChanges;
            FRS00022 = i_mbr;
            FRS00023 = i_file;
            FRS00024 = i_lib;
            msg = newAppMsg('FRS0002': FRS0002: cMsg_Info);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         else;
            clear   FRS0003;
            FRS00031 = 0;
            FRS00032 = i_mbr;
            FRS00033 = i_file;
            FRS00034 = i_lib;
            msg = newAppMsg('FRS0003': FRS0003: cMsg_Info);
            f_sndPgmMsg(msg: cMsg_Prv: cMsg_ToCtlBdy);
         endif;

         return;

      /END-FREE
      *
     P processMbr...
     P                 E
      *
      *=========================================================================
      *  Replaces all occurences of a search argument by
      *  a replacement string in a given string.
      *=========================================================================
      *  Parameters:
      *   i_searchArg   - The argument that is replaced by the replacement
      *                   string.
      *   i_rplString   - The replacement string that replaces the search
      *                   argument.
      *   i_string      - The string that contains the search argument.
      *   i_case        - Kind of match:  *IGNORE - Search string without
      *                                             case sensitivity.
      *                                   *MATCH  - Search for an exact match
      *                                             to the string.
      *   i_startPos    - The position where to start from.
      *   i_endPos      - Last position to find the search argument.
      *
      *  Returns:
      *   string        - The string having the search argument replaced with
      *                   the replacement string.
      *=========================================================================
      *
     P replaceString...
     P                 B
      *
     D replaceString...
     D                 PI                         like(string_t  )
     D  o_numChanges                              like(int4_t    )
     D  i_searchArg                        const  like(string_t  )
     D  i_rplString                        const  like(string_t  )
     D  i_string                           const  like(string_t  )
     D  i_case                             const  like(keyword_t )
     D  i_wildcard                         const  like(varChar_t )
     D                                            options(*nopass)
     D  i_startPos                         const  like(int4_t    )
     D                                            options(*nopass)
     D  i_endPos                           const  like(int4_t    )
     D                                            options(*nopass)
      *
      *  Return value
     D string          S                   like(string_t  ) inz
      *
      *  Parameter positions
     D p_wildcard      C                   const(6)
     D p_startPos      C                   const(7)
     D p_endPos        C                   const(8)
      *
      *  Optional parameter fields
     D startPos        S                   like(i_startPos) inz
     D endPos          S                   like(i_endPos  ) inz
     D wildcard        S                   like(i_wildcard) inz
      *
      *  Local fields
     D X               S                   like(int4_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         o_numChanges = 0;

         if   %parms >= p_wildcard;
            wildcard = i_wildcard;
         else;
            wildcard = '';
         endif;

         if   %parms >= p_startPos;
            startPos = i_startPos;
         else;
            startPos = 1;
         endif;

         if   %parms >= p_endPos;
            endPos = i_endPos;
         else;
            endPos = %len(i_string);
         endif;

         string = i_string;

         if   i_case = cIgnore;
            x = scan(f_lcase(i_searchArg)
                     : f_lcase(string): startPos: wildcard);
         else;
            x = scan(i_searchArg: string: startPos: wildcard);
         endif;

         dow   (x > 0) and (x < endPos);
            o_numChanges = o_numChanges + 1;
            string = replace(i_rplString
                             : string: x: %len(i_searchArg): wildcard);
            x = x + %len(i_rplString);
            if   x < %len(string);
               if   i_case = cIgnore;
                  x = scan(f_lcase(i_searchArg)
                           : f_lcase(string): x: wildcard);
               else;
                  x = scan(i_searchArg: string: x: wildcard);
               endif;
            endif;
         enddo;

         return   string;

      /END-FREE
      *
     P replaceString...
     P                 E
      *
      *=========================================================================
      *  Returns the first position of the search argument in the source
      *  string, or 0 if it was not found.
      *=========================================================================
      *  Parameters:
      *   i_searchArg   - The argument that is replaced by the replacement
      *                   string.
      *   i_string      - The string that contains the search argument.
      *   i_startPos    - The position where to start from.
      *   i_wildcard    - The wildcard character.
      *
      *  Returns:
      *   pos           - The first position of the search argument
      *                   in the source.
      *=========================================================================
      *
     P scan...
     P                 B
      *
     D scan...
     D                 PI                         like(int4_t    )
     D  i_searchArg                        const  like(string_t  )
     D  i_string                           const  like(string_t  )
     D  i_startPos                         const  like(int4_t    )
     D                                            options(*nopass)
     D  i_wildcard                         const  like(varChar_t )
     D                                            options(*nopass)
      *
      *  Parameter positions
     D p_startPos      C                   const(3)
     D p_wildcard      C                   const(4)
      *
      *  Optional parameter fields
     D startPos        S                   like(i_startPos) inz
     D wildcard        S                   like(i_wildcard) inz
      *
      *  Return value
     D pos             S                   like(int4_t    ) inz
      *
      *  Local fields
     D x               S                   like(int4_t    ) inz
     D y               S                   like(int4_t    ) inz
     D match           S                   like(int4_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= p_startPos);
            startPos = i_startPos;
         else;
            startPos = 1;
         endif;

         if (%parms() >= p_wildcard);
            wildcard = i_wildcard;
         else;
            wildcard = '';
         endif;

         if (wildcard = '');
            pos = %scan(i_searchArg: i_string: startPos);
            return pos;
         endif;

         match = 0;
         for x = 1 to (%len(i_string) - %len(i_searchArg) + 1);
            match = 0;
            for y = 1 to %len(i_searchArg);
               if (%subst(i_searchArg: y: 1) <> wildcard and
                   %subst(i_string: x+y-1: 1) <> %subst(i_searchArg: y: 1));
                  leave;
               endif;
               match = match + 1;
               if (match = %len(i_searchArg));
                  pos = x;
                  return pos;
               endif;
            endfor;
         endfor;

         return pos;

      /END-FREE
      *
     P scan...
     P                 E
      *
      *=========================================================================
      *  Returns the character string produced by inserting a replacement string
      *  into the source string, starting at the start position and replacing
      *  the specified number of characters.
      *=========================================================================
      *  Parameters:
      *   i_rplString   - The replacement string.
      *   i_string      - The source string.
      *   i_startPos    - The position where to start from.
      *   i_length      - The length of the string that is replaced.
      *   i_wildcard    - The wildcard character.
      *
      *  Returns:
      *   pos           - The first position of the search argument
      *                   in the source.
      *=========================================================================
      *
     P replace...
     P                 B
      *
     D replace...
     D                 PI                         like(string_t  )
     D  i_rplString                        const  like(string_t  )
     D  i_string                           const  like(string_t  )
     D  i_startPos                         const  like(int4_t    )
     D                                            options(*nopass)
     D  i_length                           const  like(int4_t    )
     D                                            options(*nopass)
     D  i_wildcard                         const  like(varChar_t )
     D                                            options(*nopass)
      *
      *  Parameter positions
     D p_startPos      C                   const(3)
     D p_length        C                   const(4)
     D p_wildcard      C                   const(5)
      *
      *  Optional parameter fields
     D startPos        S                   like(i_startPos ) inz
     D length          S                   like(i_length   ) inz
     D wildcard        S                   like(i_wildcard ) inz
      *
      *  Return value
     D newString       S                   like(string_t   ) inz
      *
      *  Local fields
     D x               S                   like(int4_t     ) inz
     D rplString       S                   like(i_rplString) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%parms() >= p_startPos);
            startPos = i_startPos;
         else;
            startPos = 1;
         endif;

         if (%parms() >= p_length);
            length = i_length;
         else;
            length = %len(i_rplString);
         endif;

         if (%parms() >= p_wildcard);
            wildcard = i_wildcard;
         else;
            wildcard = '';
         endif;

         if (wildcard = '');
            newString = %replace(i_rplString: i_string: startPos: length);
            return newString;
         endif;

         rplString = i_rplString;

         x = 1;
         dow (x <= %len(i_rplString));
            if (%subst(i_rplString: x: 1) = wildcard);
               %subst(rplString: x: 1) = %subst(i_string: startPos + x - 1: 1);
            endif;
            x = x + 1;
         enddo;

         newString = %replace(rplString: i_string: startPos: length);

         return newString;

      /END-FREE
      *
     P replace...
     P                 E
      *
      *=========================================================================
      *  Is generic?
      *=========================================================================
      *
     P isGeneric...
     P                 B
      *
     D isGeneric...
     D                 PI                         like(bool_t    )
     D  i_string                           const  like(string_t  )
      *
      *  Return value
     D isGeneric       S                   like(bool_t    ) inz(cFalse)
      *
      *  Local fields
     D string          S                   like(i_string  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         string = %trim(i_string);

         if   (%subst(string: 1: 1)            = '*') or
              (%subst(string: %len(string): 1) = '*');
            isGeneric = cTrue;
         else;
            isGeneric = cFalse;
         endif;

         return   isGeneric;

      /END-FREE
      *
     P isGeneric...
     P                 E
      *
      *======================================================================================
      *  Remove last message.
      *
      * Erzeugt mit PRC-Template V1.1 (Zeile bitte nicht löschen)
      *======================================================================================
     P rmvMsgByIDAndType...
     P                 B
      *
     D rmvMsgByIDAndType...
     D                 PI
     D i_msgType                           const  like(msg_t.type)
     D i_msgID                             const  like(msg_t.ID  )
      *
      * Local helper fields
     D rcvm0200        DS                  likeds(rcvm0200_t) inz
     D msg             DS                  likeds(msg_t     ) inz
      * ---------------------------------------------------------
      /FREE

         // empfangen letzte *ESCAPE Nachricht
         rcvm0200 = f_rcvPgmMsg(cMsg_Diag: *omit: cMsg_Act_Same: 0:
                                cMsg_Prv: cMsg_ToMyself: *omit: *omit: msg);

         // löschen Nachrichten
         if (msg.ID = cMSG_ID_OK);
            if (i_msgID = rcvm0200.msgID) or (i_msgID = '');
               p_rmvPgmMsg(cMsg_Rmv_ByKey: rcvm0200.msgKey
                           : cMsg_Prv: cMsg_ToMyself);
            endif;
         endif;

         return;

      /END-FREE
      *
     P rmvMsgByIDAndType...
     P                 E
      *
      *===============================================================*
      *  Create new message.
      *===============================================================*
     P newAppMsg...
     P                 B
      *
     D newAppMsg...
     D                 PI                         like(msg_t     )
     D  i_msgID                            const  like(msg_t.ID  )
     D                                            options(*nopass: *omit)
     D  i_msgData                          const  like(msg_t.data)
     D                                            options(*nopass: *omit)
     D  i_msgType                          const  like(msg_t.type)
     D                                            options(*nopass: *omit)
      *
      *  Return value
     D msg             DS                  likeds(msg_t   ) inz
      *
      *  Parameter positions
     D p_msgID         C                   const(1)
     D p_msgData       C                   const(2)
     D p_msgType       C                   const(3)
      *
      *  Optional parameter fields
     D msgID           S                   like(i_msgID   ) inz
     D msgData         S                   like(i_msgData ) inz
     D msgType         S                   like(i_msgType ) inz
      *
      *  Hilfsfelder für System-API: CEETSTA
     D isPresent       S                   like(int4_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         select;
         when (%parms() >= p_msgType);   // 3 or more parameters
            msg = f_newMsg(i_msgID: i_msgData: i_msgType: cAppMsgF:cAppMsgFLib);

         when (%parms() = p_msgData);    // 2 parameters
            msg = f_newMsg(i_msgID: i_msgData: *omit: cAppMsgF: cAppMsgFLib);

         when (%parms() = p_msgID);      // 1 parameter
            msg = f_newMsg(i_msgID: *omit: *omit: cAppMsgF: cAppMsgFLib);

         other;                          // no parameters
            msg = f_newMsg(*omit: *omit: *omit: cAppMsgF: cAppMsgFLib);
         endsl;

         return msg;

      /END-FREE
      *
     P newAppMsg...
     P                 E
      *
