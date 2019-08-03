IMPLEMENTATION MODULE XMem;

FROM SYSTEM IMPORT SEG, OFS, WORD;

PROCEDURE MemW( Segment, Offset : CARDINAL) : CARDINAL;
VAR
   p : POINTER TO CARDINAL;

BEGIN
     p.SEG := Segment;
     p.OFS := Offset;
     RETURN p^
END MemW;

PROCEDURE Mem( Segment, Offset : CARDINAL) : CHAR;
VAR
   p : POINTER TO CHAR;

BEGIN
     p.SEG := Segment;
     p.OFS := Offset;
     RETURN p^
END Mem;

PROCEDURE wordMemW( Segment, Offset : WORD) : WORD;
VAR
   p : POINTER TO WORD;

BEGIN
     p.SEG := CARDINAL(Segment);
     p.OFS := CARDINAL(Offset);
     RETURN p^
END wordMemW;

END XMem.


