IMPLEMENTATION MODULE Tab;

FROM Files IMPORT StdPrn, Write;
FROM ASCII IMPORT CR;
FROM SYSTEM IMPORT ADR;
FROM Strings IMPORT Concat;

PROCEDURE PrintTab( dist: CARDINAL);

VAR
   n : CARDINAL;
   c : CHAR;
   s : ARRAY [0..255] OF CHAR;
BEGIN
     s[0] := 0X;
     FOR n := 1 TO dist DO
        Concat(s," ",s)
     END;
     c := CR;
     Write(StdPrn,ADR(c),1,n);
     Write(StdPrn,ADR(s),dist,n)
END PrintTab;
END Tab.
