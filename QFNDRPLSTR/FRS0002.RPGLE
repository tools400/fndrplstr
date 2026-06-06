**free
//---------------------------------------------------------------
// Datenstruktur fr Message-ID : FRS0002

// Applied &1 changes to member &2 in file &4/&3.

dcl-ds FRS0002;
  FRS00021 packed(010) inz(*zeros);
  FRS00022 char(010) inz(*blanks);
  FRS00023 char(010) inz(*blanks);
  FRS00024 char(010) inz(*blanks);
end-ds;
dcl-s FRS0002# bindec(8) inz(0036);

