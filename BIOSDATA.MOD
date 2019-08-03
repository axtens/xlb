IMPLEMENTATION MODULE BiosDataAccess;
FROM SYSTEM IMPORT ADDRESS, TSIZE, OFS, SEG, OFFSET, SEGMENT;
FROM System IMPORT Move;

PROCEDURE RetrieveBiosData;
VAR
        RealBios, TempBios : ADDRESS;
BEGIN
        RealBios.SEG := 40H;
        RealBios.OFS := 0H;
        TempBios.SEG := SEGMENT(BiosData);
        TempBios.OFS := OFFSET(BiosData);
        Move(RealBios,TempBios,TSIZE(BiosDataRecord))

END RetrieveBiosData;


END BiosDataAccess.
