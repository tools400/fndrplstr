**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : FRS0003

// No matches found in member &2 in file &4/&3.

dcl-ds FRS0003;
  FRS00031 packed(010) inz(*zeros);
  FRS00032 char(010) inz(*blanks);
  FRS00033 char(010) inz(*blanks);
  FRS00034 char(010) inz(*blanks);
end-ds;
dcl-s FRS0003# bindec(8) inz(0036);

