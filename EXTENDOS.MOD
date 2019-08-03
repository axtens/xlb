IMPLEMENTATION MODULE ExtenDos;
FROM SYSTEM IMPORT OFFSET, SEGMENT, ADDRESS, OFS, SEG, TSIZE;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM System IMPORT AX, BX, CX, DX, DS, FLAGS, carryFlag, XTrap;
FROM Files IMPORT SEEKABS, SEEKCUR, Read, Seek;
FROM Strings IMPORT Pos, Copy;

VAR
    lcFilePos : LONGCARD;

PROCEDURE CreateFile( VAR BUFF : INTEGER; FILE : ARRAY OF CHAR; ATTRIB : CARDINAL; VAR RESULT : CARDINAL);
BEGIN
        DS := SEGMENT(FILE);
        DX := OFFSET(FILE);
        CX := ATTRIB;
        AX := 3C00H;
        XTrap(21H);
        IF carryFlag IN FLAGS THEN
                RESULT := (AX MOD 256)
        ELSE
                BUFF := INTEGER(AX);
                RESULT := 0
        END;
END CreateFile;
PROCEDURE MakeHidden( VAR BUFF : INTEGER; FILE : ARRAY OF CHAR) : BOOLEAN;
BEGIN
        DS := SEGMENT(FILE);
        DX := OFFSET(FILE);
        CX := 0002H;
        AX := 3C00H;
        XTrap(21H);
        IF carryFlag IN FLAGS THEN
                RETURN FALSE
        ELSE
                BUFF := INTEGER(AX);
                RETURN TRUE
        END;
END MakeHidden;

(*PROCEDURE ReadFileLine( handle : INTEGER;
                    VAR Buffer : ARRAY OF CHAR;
                    VAR BytesReceived : CARDINAL);

VAR
        C : CHAR;
        ByteCount : CARDINAL;
BEGIN
        ByteCount := 0;
        LOOP
                AX := 3F00H;
                BX := handle;
                CX := 1;
                DS := SEGMENT(C);
                DX := OFFSET(C);
                XTrap(21H);
                IF carryFlag IN FLAGS THEN
                        AX := 0;
                        EXIT
                END;
                IF AX = 0 THEN
                        EXIT
                ELSE
                        Buffer[ByteCount] := C;
                        INC(ByteCount);
                        IF C = 0AX THEN
                                EXIT
                        END;
                END;
        END;
        Buffer[ByteCount] := 0X;
        BytesReceived := ByteCount;
END ReadFileLine;
*)
PROCEDURE ReadFileLine( handle : INTEGER;
                    VAR Buffer : ARRAY OF CHAR;
                    VAR BytesReceived : CARDINAL);

TYPE
    sLineBuffer = ARRAY [0..32766] OF CHAR;
    psLineBuffer = POINTER TO sLineBuffer;
VAR
    pBuffer : psLineBuffer;
    cRead : CARDINAL;
    cBytePos : CARDINAL;
    lcHere : LONGCARD;
BEGIN
    NEW(pBuffer);
    lcHere := 0L;
    Seek( handle, SEEKCUR, lcHere);
    IF lcHere # 0L THEN
        Seek(handle, SEEKABS, lcFilePos)
    ELSE
        lcFilePos := 0L;
    END;
    Read( handle, pBuffer, TSIZE(sLineBuffer), cRead);
    IF cRead = 0 THEN
        lcFilePos := 0L;
        BytesReceived := 0
    ELSE
        cBytePos := Pos( CHR(10), pBuffer^);
        IF cBytePos <= HIGH(pBuffer^) THEN
            Copy( pBuffer^,0,cBytePos,Buffer);
            lcFilePos := lcFilePos + LONG(cBytePos)+1L
        ELSE
            BytesReceived := 0
        END
    END;
    DISPOSE(pBuffer);
END ReadFileLine;
BEGIN
    lcFilePos := 0L

END ExtenDos.

