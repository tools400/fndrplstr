/* =================================================================== */
/*                                                                     */
/*  Kurzdokumentation :                                                */
/*                                                                     */
/*  Bereich . . . : FNDRPLSTR                                          */
/*  Objekt  . . . : FNDRPLSTR                                          */
/*  Beschreibung  : Find and Replace Strings - Ger                     */
/*  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      */
/*  Datum . . . . : 05.01.2004                                         */
/*                                                                     */
/* =================================================================== */
/*                                                                     */
/*  This software is free software, you can redistribute it and/or     */
/*  modify it under the terms of the GNU General Public License (GPL)  */
/*  as published by the Free Software Foundation.                      */
/*                                                                     */
/*  See GNU General Public License for details.                        */
/*          http://www.opensource.org                                  */
/*          http://www.opensource.org/licenses/gpl-license.html        */
/*                                                                     */
/* =================================================================== */
/*  History:                                                           */
/*                                                                     */
/*  Datum       Name          nderung                                 */
/*  ----------  ------------  ---------------------------------------  */
/*                                                                     */
/* =================================================================== */
/* >>PRE-COMPILER<<                                                    */
/*                                                                     */
/*   >>CRTCMD<< CRTCMD       CMD(&LI/FNDRPLSTR) +                      */
/*                           SRCFILE(&SL/&SF) +                        */
/*                           SRCMBR(&SM);                              */
/*                                                                     */
/*   >>COMPILE<<                                                       */
/*     >>PARM<< PGM(*LIBL/FNDRPLSTR);                                  */
/*     >>PARM<< HLPPNLGRP(*LIBL/FNDRPLSTRP);                           */
/*     >>PARM<< HLPID(FNDRPLSTR);                                      */
/*     >>PARM<< PRDLIB(&LI);                                           */
/*   >>END-COMPILE<<                                                   */
/*                                                                     */
/*   >>EXECUTE<<                                                       */
/*                                                                     */
/* >>END-PRE-COMPILER<<                                                */
/* =================================================================== */

             CMD        PROMPT('Zeichenk. suchen und ersetzen')

             PARM       KWD(FILE)              +
                        MIN(1)                 +
                        TYPE(QUAL1)            +
                        PROMPT('Datei')

             PARM       KWD(MBR)               +
                        TYPE(*GENERIC)         +
                        MIN(1)                 +
                        SPCVAL((*FIRST)        +
                               (*ALL))         +
                        PROMPT('Teildatei')

             PARM       KWD(VALUES)            +
                        TYPE(ELEM1)            +
                        MIN(1)                 +
                        MAX(10)                +
                        PROMPT('Suchen und ersetzen')

             PARM       KWD(CASE)              +
                        TYPE(*CHAR)            +
                        LEN(10)                +
                        MIN(0)                 +
                        DFT(*IGNORE)           +
                        RSTD(*YES)             +
                        VALUES(*IGNORE         +
                               *MATCH )        +
                        PROMPT('bereinstimmung (Gro/Klein)')

             PARM       KWD(WILDCARD)          +
                        TYPE(*CHAR)            +
                        LEN(1)                 +
                        MIN(0)                 +
                        VARY(*YES *INT2)       +
                        DFT(*NONE)             +
                        SPCVAL((*NONE ''))     +
                        PROMPT('Joker-Zeichen')

 QUAL1:      QUAL       TYPE(*NAME)            +
                        LEN(10)                +
                        MIN(1)
             QUAL       TYPE(*NAME)            +
                        LEN(10)                +
                        DFT(*LIBL)             +
                        SPCVAL((*LIBL))        +
                        PROMPT('Bibliothek')

 ELEM1:      ELEM       TYPE(*CHAR)            +
                          LEN(25)              +
                          MIN(1)               +
                          VARY(*YES *INT2)     +
                          PROMPT('Suchzeichenkette')
             ELEM       TYPE(*CHAR)            +
                          LEN(25)              +
                          MIN(1)               +
                          VARY(*YES *INT2)     +
                          PROMPT('Ersetzungszeichenkette')

