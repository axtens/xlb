IMPLEMENTATION MODULE INSTRING;
FROM Strings IMPORT Copy, Length, Pos;
FROM DevIO IMPORT CardOut, LineOut, WriteOut;

PROCEDURE InStr( cFrom : CARDINAL; sTarget, sFind : ARRAY OF CHAR) : CARDINAL;
VAR
    cPos,
    cSav : CARDINAL;
    sTemp : ARRAY [0..255] OF CHAR;
BEGIN
    cSav := HIGH( sTarget);
    Copy(sTarget, cFrom, 256, sTemp);
    cPos := Pos( sFind, sTemp);
    IF cPos > HIGH( sTemp) THEN
        cPos := cSav + 10
    ELSE
        cPos := cPos + cFrom
    END;
    RETURN cPos
END InStr;
END INSTRING.
