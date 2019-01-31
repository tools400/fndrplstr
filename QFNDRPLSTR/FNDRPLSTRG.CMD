000100170213/* =================================================================== */
000200170213/*                                                                     */
000300170213/*  Kurzdokumentation :                                                */
000400170213/*                                                                     */
000500170213/*  Bereich . . . : FNDRPLSTR                                          */
000600170213/*  Objekt  . . . : FNDRPLSTR                                          */
000700170213/*  Beschreibung  : Find and Replace Strings - Ger                     */
000800170213/*  Author  . . . : Thomas Raddatz   <thomas.raddatz@tools400.de>      */
000900170213/*  Datum . . . . : 05.01.2004                                         */
001000170213/*                                                                     */
001100170213/* =================================================================== */
001200170213/*                                                                     */
001300170213/*  This software is free software, you can redistribute it and/or     */
001400170213/*  modify it under the terms of the GNU General Public License (GPL)  */
001500170213/*  as published by the Free Software Foundation.                      */
001600170213/*                                                                     */
001700170213/*  See GNU General Public License for details.                        */
001800170213/*          http://www.opensource.org                                  */
001900170213/*          http://www.opensource.org/licenses/gpl-license.html        */
002000170213/*                                                                     */
002100170213/* =================================================================== */
002200170213/*  History:                                                           */
002300170213/*                                                                     */
002400170213/*  Datum       Name          Änderung                                 */
002500170213/*  ----------  ------------  ---------------------------------------  */
002600170213/*                                                                     */
002700170213/* =================================================================== */
002800170213/* >>PRE-COMPILER<<                                                    */
002900170213/*                                                                     */
003000170213/*   >>CRTCMD<< CRTCMD       CMD(&LI/FNDRPLSTR) +                      */
003100170213/*                           SRCFILE(&SL/&SF) +                        */
003200170213/*                           SRCMBR(&SM);                              */
003300170213/*                                                                     */
003400170213/*   >>COMPILE<<                                                       */
003500170213/*     >>PARM<< PGM(*LIBL/FNDRPLSTR);                                  */
003600170213/*     >>PARM<< HLPPNLGRP(*LIBL/FNDRPLSTRP);                           */
003700170213/*     >>PARM<< HLPID(FNDRPLSTR);                                      */
003800170213/*     >>PARM<< PRDLIB(&LI);                                           */
003900170213/*   >>END-COMPILE<<                                                   */
004000170213/*                                                                     */
004100170213/*   >>EXECUTE<<                                                       */
004200170213/*                                                                     */
004300170213/* >>END-PRE-COMPILER<<                                                */
004400170213/* =================================================================== */
004500170213
004600170213             CMD        PROMPT('Zeichenk. suchen und ersetzen')
004700170213
004800170213             PARM       KWD(FILE)              +
004900170213                        MIN(1)                 +
005000170213                        TYPE(QUAL1)            +
005100170213                        PROMPT('Datei')
005200170213
005300170213             PARM       KWD(MBR)               +
005400170213                        TYPE(*GENERIC)         +
005500170213                        MIN(1)                 +
005600170213                        SPCVAL((*FIRST)        +
005700170213                               (*ALL))         +
005800170213                        PROMPT('Teildatei')
005900170213
006000170213             PARM       KWD(VALUES)            +
006100170213                        TYPE(ELEM1)            +
006200170213                        MIN(1)                 +
006300170213                        MAX(10)                +
006400170213                        PROMPT('Suchen und ersetzen')
006500170213
006600170213             PARM       KWD(CASE)              +
006700170213                        TYPE(*CHAR)            +
006800170213                        LEN(10)                +
006900170213                        MIN(0)                 +
007000170213                        DFT(*IGNORE)           +
007100170213                        RSTD(*YES)             +
007200170213                        VALUES(*IGNORE         +
007300170213                               *MATCH )        +
007400170213                        PROMPT('Übereinstimmung (Groß/Klein)')
007500170213
007600170213             PARM       KWD(WILDCARD)          +
007700170213                        TYPE(*CHAR)            +
007800170213                        LEN(1)                 +
007900170213                        MIN(0)                 +
008000170213                        VARY(*YES *INT2)       +
008100170213                        DFT(*NONE)             +
008200170213                        SPCVAL((*NONE ''))     +
008300170213                        PROMPT('Joker-Zeichen')
008400170213
008500170213 QUAL1:      QUAL       TYPE(*NAME)            +
008600170213                        LEN(10)                +
008700170213                        MIN(1)
008800170213             QUAL       TYPE(*NAME)            +
008900170213                        LEN(10)                +
009000170213                        DFT(*LIBL)             +
009100170213                        SPCVAL((*LIBL))        +
009200170213                        PROMPT('Bibliothek')
009300170213
009400170213 ELEM1:      ELEM       TYPE(*CHAR)            +
009500170213                          LEN(25)              +
009600170213                          MIN(1)               +
009700170213                          VARY(*YES *INT2)     +
009800170213                          PROMPT('Suchzeichenkette')
009900170213             ELEM       TYPE(*CHAR)            +
010000170213                          LEN(25)              +
010100170213                          MIN(1)               +
010200170213                          VARY(*YES *INT2)     +
010300170213                          PROMPT('Ersetzungszeichenkette')
010400170213
