**free
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  05.01.2004                                              *
//  E-mail  :  Thomas.Raddatz@Tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          nderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  16.12.2008  Th.Raddatz    Now ds_srcMbr.srcDta correctly starts    *
//                            at position 7.                           *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//     >>COMPILE<<                                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< OPTION(*EVENTF);                                     *
//     >>END-COMPILE<<                                                 *
//     >>EXECUTE<<                                                     *
//     >>CMD<<     CRTPGM       PGM(&LI/FNDRPLSTR) +                   *
//                              MODULE(&LI/&OB       +                 *
//                                     &LI/PRGMTRR1) +                 *
//                              ENTMOD(&LI/&OB) +                      *
//                              ACTGRP(*NEW) +                         *
//                              BNDSRVPGM(*LIBL/RTVMBRL  +             *
//                                        *LIBL/BASICS1) +             *
//                              DETAIL(*BASIC);                        *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
/copy QFNDRPLSTR,H_SPEC
/copy QFNDRPLSTR,COPYRIGHT
//=====================================================================*
dcl-f FILE disk(32766) usage(*update: *delete) usropn extfile(g_file) extmbr(g_mbr) infds(file_FB);

dcl-ds file_FB likeds(file_FB_t);

dcl-s g_file char(21) inz;
dcl-s g_mbr inz like(mbr_t);

dcl-ds ds_file qualified;
  buffer char(32766);
end-ds;

dcl-ds ds_srcMbr qualified;
  srcSeq zoned(6: 2);
  srcDat zoned(6);
  srcDta char(32754);
end-ds;

//  Type Definitions
dcl-s bool_t ind based(pDummy);
dcl-s int4_t int(10) based(pDummy);
dcl-s file_t char(10) based(pDummy);
dcl-s lib_t char(10) based(pDummy);
dcl-s mbr_t char(10) based(pDummy);
dcl-s string_t varchar(32766) based(pDummy);
dcl-s keyword_t char(10) based(pDummy);
dcl-s varChar_t varchar(1) based(pDummy);

/copy QFNDRPLSTR,FDQOBJ qualified object name

/copy QBASICS1,PBASICS1 Tools/400 Runtime Library
/copy QFNDRPLSTR,PPRGMTRR1 Progress Meter
/copy QFNDRPLSTR,CEELIB CEE APIs

dcl-ds mbrl0200_t qualified based(pDummy);
  mbr       char(10);
  srcType   char(10);
  crtDatTim char(13);
  cghDatTim char(13);
  text      char(50);
  textCcsid uns(10);
end-ds;

dcl-ds fndRplStrL_t qualified based(pDummy);
  numEntries int(5);
  offsets    int(5) dim(cNumValues);
  entries    likeds(entry_t) dim(cNumValues);
end-ds;

dcl-ds entry_t qualified based(pDummy);
  numValues int(5);
  find      varchar(25);
  replace   varchar(25);
end-ds;

dcl-ds file_FB_t len(512) qualified based(pDummy);
  status   packed(9) pos(11);
  msg      char(7) pos(46);
  open_FB  likeds(open_FB_t) pos(81);
  IO_FB    likeds(IO_FB_t) pos(241);
  DB_IO_FB likeds(DB_IO_FB_t) pos(367);
end-ds;

dcl-ds open_FB_t qualified based(pDummy);
  odpType      char(2);
  file         char(10);
  lib          char(10);
  splF         char(10);
  splFLib      char(10);
  splFNbr      int(5);
  maxRcdLength int(5);
  maxKeyLength int(5);
  mbr          char(10);
  res_01       int(10);
  res_02       int(10);
  fileType     int(5);
  res_03       char(3);
  numRcdAtOpn  uns(10) pos(76);
  srcFileInd   char(1) pos(83);
end-ds;

dcl-ds IO_FB_t qualified based(pDummy);
  writeCount    int(10) pos(3);
  readCount     int(10);
  wrRdCount     int(10);
  otherCount    int(10);
  res_01        char(1);
  currOper      char(1);
  rcdFormat     char(10);
  deviceClass   char(2);
  deviceName    char(10);
  lastRcdLenPrc int(10);
  res_02        char(80);
  rdBlkSize     int(5);
  curBlkCount   int(10) pos(133);
end-ds;

dcl-ds DB_IO_FB_t qualified based(pDummy);
  numLckRcd  int(5) pos(11);
  maxNumFld  int(5);
  numKeyFld  int(5) pos(21);
  keyLength  int(5) pos(27);
  dataMbrNbr int(5);
  rrn        uns(10);
end-ds;

//  Prototype for the RTVMBRL service program
/copy QRTVMBRL,PRTVMBRL

//  Prototypes for Program Entry Point
dcl-pr PGM_ENTRY_POINT extpgm('FNDRPLR1');
  gi_qFile      like(qObj_t) const;
  gi_mbr        like(mbr_t) const;
  gi_fndRplStrL likeds(fndRplStrL_t) const;
  gi_case       like(keyword_t) const;
  gi_wildcard   like(varChar_t) const;
end-pr;

//  Prototypes for internal procedures
dcl-pr main;
  i_qFile      like(gi_qFile) const;
  i_mbr        like(gi_mbr) const;
  i_fndRplStrL likeds(gi_fndRplStrL) const;
  i_case       like(gi_case) const;
  i_wildcard   like(gi_wildcard) const;
end-pr;

dcl-pr processMbr;
  i_file       like(file_t) value;
  i_lib        like(lib_t) value;
  i_mbr        like(mbr_t) value;
  i_fndRplStrL likeds(fndRplStrL_t) value;
  i_case       like(keyword_t) value;
  i_wildcard   like(varChar_t) value;
end-pr;

dcl-pr replaceString like(string_t);
  o_numChanges like(int4_t);
  i_searchArg  like(string_t) const;
  i_rplString  like(string_t) const;
  i_string     like(string_t) const;
  i_case       like(keyword_t) const;
  i_wildcard   like(varChar_t) options(*nopass) const;
  i_startPos   like(int4_t) options(*nopass) const;
  i_endPos     like(int4_t) options(*nopass) const;
end-pr;

dcl-pr scan like(int4_t);
  i_searchArg like(string_t) const;
  i_string    like(string_t) const;
  i_startPos  like(int4_t) options(*nopass) const;
  i_wildcard  like(varChar_t) options(*nopass) const;
end-pr;

dcl-pr replace like(string_t);
  i_rplString like(string_t) const;
  i_string    like(string_t) const;
  i_startPos  like(int4_t) options(*nopass) const;
  i_length    like(int4_t) options(*nopass) const;
  i_wildcard  like(varChar_t) options(*nopass) const;
end-pr;

dcl-pr isGeneric like(bool_t);
  i_string like(string_t) const;
end-pr;

dcl-pr rmvMsgByIDAndType;
  i_msgType like(msg_t.type) const;
  i_msgID   like(msg_t.ID) const;
end-pr;

//  Create new message.
dcl-pr newAppMsg like(msg_t);
  i_msgID   like(msg_t.ID) options(*nopass: *omit) const;
  i_msgData like(msg_t.data) options(*nopass: *omit) const;
  i_msgType like(msg_t.type) options(*nopass: *omit) const;
end-pr;

//  Global Constants
dcl-c cNumValues 10;
dcl-c cDblQuotes '"';

dcl-c cSrcFile_ind_Yes 'Y';
dcl-c cSrcFile_ind_No 'N';

dcl-c cMbr_First '*FIRST';
dcl-c cMbr_All '*ALL';

dcl-c cIgnore '*IGNORE';
dcl-c cMatch '*MATCH';

dcl-c cAppMsgF 'FNDRPLSTR';
dcl-c cAppMsgFLib '*LIBL';

//*******************************************************************
//  Program Entry Point
//*******************************************************************
dcl-pi PGM_ENTRY_POINT;
  gi_qFile      like(qObj_t) const;
  gi_mbr        like(mbr_t) const;
  gi_fndRplStrL likeds(fndRplStrL_t) const;
  gi_case       like(keyword_t) const;
  gi_wildcard   like(varChar_t) const;
end-pi;
//-------------------------------------------------------------------

main(gi_qFile: gi_mbr: gi_fndRplStrL: gi_case: gi_wildcard);

*inlr = *on;


//==================================================================*
//  Main Procedure
//==================================================================*

dcl-proc main;
  dcl-pi *n;
    i_qFile      like(gi_qFile) const;
    i_mbr        like(gi_mbr) const;
    i_fndRplStrL likeds(gi_fndRplStrL) const;
    i_case       like(gi_case) const;
    i_wildcard   like(gi_wildcard) const;
  end-pi;

  //  Local fields
  dcl-s isMbr like(bool_t) inz(cFalse);
  dcl-s hMbrList like(mbrLst_handle_t) inz;

  dcl-s msg like(msg_t) inz;
  dcl-ds qFile likeds(qObj_t) inz;
  dcl-ds mbrl0200 likeds(mbrl0200_t) inz;
  dcl-s mbrl0200_hlp like(mbrl0200) based(pMbrl0200_hlp);
  dcl-s pMbrl0200_hlp pointer inz(%addr(mbrl0200));

  //  Messages
/copy QFNDRPLSTR,FRS0004
  //-------------------------------------------------------------------

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


end-proc main;

//==================================================================*
//  Process Member
//==================================================================*

dcl-proc processMbr;
  dcl-pi *n;
    i_file       like(file_t) value;
    i_lib        like(lib_t) value;
    i_mbr        like(mbr_t) value;
    i_fndRplStrL likeds(fndRplStrL_t) value;
    i_case       like(keyword_t) value;
    i_wildcard   like(varChar_t) value;
  end-pi;

  //  Local fields
  dcl-s isError like(bool_t) inz(cFalse);
  dcl-s isDone like(bool_t) inz(cFalse);
  dcl-s isChanged like(bool_t) inz(cFalse);
  dcl-s isProgressMeter like(bool_t) inz(cFalse);
  dcl-s x like(int4_t) inz;
  dcl-s numChanges like(int4_t) inz;
  dcl-s sumChanges like(int4_t) inz;
  dcl-s numRcdPrc like(int4_t) inz;

  dcl-ds msg likeds(msg_t) inz;
  dcl-ds fndRplStrL likeds(fndRplStrL_t) inz;
  dcl-ds entry likeds(entry_t) based(pEntry);

  //  Messages
/copy QFNDRPLSTR,FRS0001
/copy QFNDRPLSTR,FRS0002
/copy QFNDRPLSTR,FRS0003
/copy QFNDRPLSTR,FRS0005
  //-------------------------------------------------------------------

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


end-proc;

//=========================================================================
//  Replaces all occurences of a search argument by
//  a replacement string in a given string.
//=========================================================================
//  Parameters:
//   i_searchArg   - The argument that is replaced by the replacement
//                   string.
//   i_rplString   - The replacement string that replaces the search
//                   argument.
//   i_string      - The string that contains the search argument.
//   i_case        - Kind of match:  *IGNORE - Search string without
//                                             case sensitivity.
//                                   *MATCH  - Search for an exact match
//                                             to the string.
//   i_startPos    - The position where to start from.
//   i_endPos      - Last position to find the search argument.
//
//  Returns:
//   string        - The string having the search argument replaced with
//                   the replacement string.
//=========================================================================

dcl-proc replaceString;
  dcl-pi *n like(string_t);
    o_numChanges like(int4_t);
    i_searchArg  like(string_t) const;
    i_rplString  like(string_t) const;
    i_string     like(string_t) const;
    i_case       like(keyword_t) const;
    i_wildcard   like(varChar_t) options(*nopass) const;
    i_startPos   like(int4_t) options(*nopass) const;
    i_endPos     like(int4_t) options(*nopass) const;
  end-pi;

  //  Return value
  dcl-s string like(string_t) inz;

  //  Parameter positions
  dcl-c p_wildcard 6;
  dcl-c p_startPos 7;
  dcl-c p_endPos 8;

  //  Optional parameter fields
  dcl-s startPos like(i_startPos) inz;
  dcl-s endPos like(i_endPos) inz;
  dcl-s wildcard like(i_wildcard) inz;

  //  Local fields
  dcl-s X like(int4_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns the first position of the search argument in the source
//  string, or 0 if it was not found.
//=========================================================================
//  Parameters:
//   i_searchArg   - The argument that is replaced by the replacement
//                   string.
//   i_string      - The string that contains the search argument.
//   i_startPos    - The position where to start from.
//   i_wildcard    - The wildcard character.
//
//  Returns:
//   pos           - The first position of the search argument
//                   in the source.
//=========================================================================

dcl-proc scan;
  dcl-pi *n like(int4_t);
    i_searchArg like(string_t) const;
    i_string    like(string_t) const;
    i_startPos  like(int4_t) options(*nopass) const;
    i_wildcard  like(varChar_t) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_startPos 3;
  dcl-c p_wildcard 4;

  //  Optional parameter fields
  dcl-s startPos like(i_startPos) inz;
  dcl-s wildcard like(i_wildcard) inz;

  //  Return value
  dcl-s pos like(int4_t) inz;

  //  Local fields
  dcl-s x like(int4_t) inz;
  dcl-s y like(int4_t) inz;
  dcl-s match like(int4_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Returns the character string produced by inserting a replacement string
//  into the source string, starting at the start position and replacing
//  the specified number of characters.
//=========================================================================
//  Parameters:
//   i_rplString   - The replacement string.
//   i_string      - The source string.
//   i_startPos    - The position where to start from.
//   i_length      - The length of the string that is replaced.
//   i_wildcard    - The wildcard character.
//
//  Returns:
//   pos           - The first position of the search argument
//                   in the source.
//=========================================================================

dcl-proc replace;
  dcl-pi *n like(string_t);
    i_rplString like(string_t) const;
    i_string    like(string_t) const;
    i_startPos  like(int4_t) options(*nopass) const;
    i_length    like(int4_t) options(*nopass) const;
    i_wildcard  like(varChar_t) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_startPos 3;
  dcl-c p_length 4;
  dcl-c p_wildcard 5;

  //  Optional parameter fields
  dcl-s startPos like(i_startPos) inz;
  dcl-s length like(i_length) inz;
  dcl-s wildcard like(i_wildcard) inz;

  //  Return value
  dcl-s newString like(string_t) inz;

  //  Local fields
  dcl-s x like(int4_t) inz;
  dcl-s rplString like(i_rplString) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Is generic?
//=========================================================================

dcl-proc isGeneric;
  dcl-pi *n like(bool_t);
    i_string like(string_t) const;
  end-pi;

  //  Return value
  dcl-s isGeneric like(bool_t) inz(cFalse);

  //  Local fields
  dcl-s string like(i_string) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  string = %trim(i_string);

  if   (%subst(string: 1: 1)            = '*') or
       (%subst(string: %len(string): 1) = '*');
    isGeneric = cTrue;
  else;
    isGeneric = cFalse;
  endif;

  return   isGeneric;


end-proc;

//======================================================================================
//  Remove last message.
//
// Erzeugt mit PRC-Template V1.1 (Zeile bitte nicht lschen)
//======================================================================================
dcl-proc rmvMsgByIDAndType;
  dcl-pi *n;
    i_msgType like(msg_t.type) const;
    i_msgID   like(msg_t.ID) const;
  end-pi;

  // Local helper fields
  dcl-ds rcvm0200 likeds(rcvm0200_t) inz;
  dcl-ds msg likeds(msg_t) inz;
  // ---------------------------------------------------------

  // empfangen letzte *ESCAPE Nachricht
  rcvm0200 = f_rcvPgmMsg(cMsg_Diag: *omit: cMsg_Act_Same: 0:
                         cMsg_Prv: cMsg_ToMyself: *omit: *omit: msg);

  // lschen Nachrichten
  if (msg.ID = cMSG_ID_OK);
    if (i_msgID = rcvm0200.msgID) or (i_msgID = '');
      p_rmvPgmMsg(cMsg_Rmv_ByKey: rcvm0200.msgKey
                  : cMsg_Prv: cMsg_ToMyself);
    endif;
  endif;

  return;


end-proc;

//===============================================================*
//  Create new message.
//===============================================================*
dcl-proc newAppMsg;
  dcl-pi *n like(msg_t);
    i_msgID   like(msg_t.ID) options(*nopass: *omit) const;
    i_msgData like(msg_t.data) options(*nopass: *omit) const;
    i_msgType like(msg_t.type) options(*nopass: *omit) const;
  end-pi;

  //  Return value
  dcl-ds msg likeds(msg_t) inz;

  //  Parameter positions
  dcl-c p_msgID 1;
  dcl-c p_msgData 2;
  dcl-c p_msgType 3;

  //  Optional parameter fields
  dcl-s msgID like(i_msgID) inz;
  dcl-s msgData like(i_msgData) inz;
  dcl-s msgType like(i_msgType) inz;

  //  Hilfsfelder fr System-API: CEETSTA
  dcl-s isPresent like(int4_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

