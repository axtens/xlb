IMPLEMENTATION MODULE XBiosTools;

FROM XString IMPORT RepeatString;
FROM XBios IMPORT WriteString, SetCursorPosition;
FROM Strings IMPORT Concat;


CONST   TOPLEFTsingle = 0DAX;           TOPLEFT = 0;
        TOPRIGHTsingle = 0BFX;          TOPRIGHT = 1;
        BOTTOMLEFTsingle = 0C0X;        BOTTOMLEFT = 2;
        BOTTOMRIGHTsingle = 0D9X;       BOTTOMRIGHT = 3;
        UPRIGHTsingle = 0B3X;           UPRIGHT = 4;
        LYINGDOWNsingle = 0C4X;         LYINGDOWN = 5;
VAR
        Borders : ARRAY [0..11] OF CHAR;

PROCEDURE Box( row, col, height, width, borderstyle, colour : CARDINAL);
VAR
        I : CARDINAL;
        OutputString : ARRAY [0..255] OF CHAR;
        offset : CARDINAL;
BEGIN
        CASE borderstyle OF
                0 : offset := 0;
                |
                1 : offset := 6;
        END;
        RepeatString(Borders[LYINGDOWN+offset],width-1,OutputString);
        Concat(Borders[TOPLEFT+offset],OutputString,OutputString);
        Concat(OutputString,Borders[TOPRIGHT+offset],OutputString);
        WriteString(1,colour,0,row,col,OutputString);
        FOR I := 1 TO height-1 DO
                WriteString(1,colour,0,row+I,col,Borders[UPRIGHT+offset]);
                WriteString(1,colour,0,row+I,col+width,Borders[UPRIGHT+offset]);
        END;
        OutputString[0] := 0X;
        RepeatString(Borders[LYINGDOWN+offset],width-1,OutputString);
        Concat(Borders[BOTTOMLEFT+offset],OutputString,OutputString);
        Concat(OutputString,Borders[BOTTOMRIGHT+offset],OutputString);
        WriteString(1,colour,0,row+height,col,OutputString)
END Box;

PROCEDURE CLS;
BEGIN
END CLS;

PROCEDURE Centre( row : CARDINAL; Text : ARRAY OF CHAR; colour : CARDINAL);
BEGIN
END Centre;
BEGIN
        Borders[0] := TOPLEFTsingle;
        Borders[1] := TOPRIGHTsingle;
        Borders[2] := BOTTOMLEFTsingle;
        Borders[3] := BOTTOMRIGHTsingle;
        Borders[4] := UPRIGHTsingle;
        Borders[5] := LYINGDOWNsingle;
END XBiosTools.
