IMPLEMENTATION MODULE XDOS;
FROM SYSTEM IMPORT OFFSET, SEGMENT, ADDRESS, OFS, SEG;
FROM System IMPORT AX, BX, CX, DX, DS, FLAGS, carryFlag, XTrap, Trap;
FROM Storage IMPORT Available, ALLOCATE, DEALLOCATE;
FROM Directories IMPORT GetFirstDir, DirEntry;
FROM ASSERT IMPORT Assert, ASSERT_ERRORS;

TYPE
    tDataBuffer = ADDRESS; (* ARRAY [0..cBuffSize] OF CHAR; *)
    ptDataBuffer= POINTER TO tDataBuffer;

VAR
    cBuffSize   : CARDINAL;
    aDataBuffer : ptDataBuffer;
    cDataPtr    : CARDINAL;
    cDataMax    : CARDINAL;

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

PROCEDURE ReadFileLine( handle : INTEGER;
                    VAR Buffer : ARRAY OF CHAR;
                    VAR BytesReceived : CARDINAL);

VAR
        C : CHAR;
        ByteCount : CARDINAL;
BEGIN
        Assert( (handle >= 0), "ReadFileLine handle must be greater than or equal to zero", ASSERT_FATAL );
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


PROCEDURE ReadBlock( handle : INTEGER) : CARDINAL;
BEGIN
    Assert( (handle >= 0), "ReadBlock handle must be greater than or equal to zero", ASSERT_FATAL );
    AX := 3F00H;
    BX := handle;
    CX := cBuffSize+1;
    DS := aDataBuffer.SEG;
    DX := aDataBuffer.OFS;
    XTrap(21H);
    IF carryFlag IN FLAGS THEN
            AX := 0;
    END;
    RETURN AX

END ReadBlock;


PROCEDURE BlockReadLine( handle : INTEGER;
                    VAR Buffer : ARRAY OF CHAR;
                    VAR BytesReceived : CARDINAL);

VAR
    c : CARDINAL;
    x : CHAR;
    a : ADDRESS;
BEGIN
    Assert( (handle >= 0), "BlockReadLine handle must be greater than or equal to zero", ASSERT_FATAL );
    c := 0;
    LOOP
        IF (cDataPtr >= cDataMax) OR (cDataMax = 0) THEN
            cDataMax := ReadBlock(handle);
            IF cDataMax = 0 THEN
                EXIT
            ELSE
                cDataPtr := 0
            END
        END;
        a := aDataBuffer;
        a.OFS := a.OFS + cDataPtr;
        x := CHR(CARDINAL(a^));
        Buffer[c] := x;
        IF x = 0AX THEN
            INC( cDataPtr);
            INC( c);
            EXIT
        END;
        INC( c);
        IF (c >= cBuffSize) OR (c >= HIGH(Buffer)) THEN
            INC( cDataPtr);
            EXIT
        END;
        INC(cDataPtr);
    END;
    BytesReceived := c;
    Buffer[c] := 0C

END BlockReadLine;

PROCEDURE BlockReadCreate( cBufSiz : CARDINAL);
BEGIN
    Assert( cBufSiz > 0, "BlockReadCreate cBufSiz must be greater than zero.", ASSERT_FATAL );
    Assert( Available( cBufSiz ), "BlockReadCreate cannot allocate requested block.", ASSERT_FATAL );
    cBuffSize := cBufSiz;
    ALLOCATE(aDataBuffer,cBuffSize);
    cDataMax    := 0;
    cDataPtr    := cDataMax;
END BlockReadCreate;

PROCEDURE BlockReadDestroy;
BEGIN
    DEALLOCATE(aDataBuffer,cBuffSize);
END BlockReadDestroy;



PROCEDURE GetCurDrive( cDrive : CARDINAL; VAR xDrive : CHAR);
BEGIN
    AX := 1900H;
    Trap(21H);
    xDrive := CHR( 41H + (AX MOD 256))

END GetCurDrive;


PROCEDURE Exists( sFileName : ARRAY OF CHAR) : BOOLEAN;
VAR
    rDirEntry : DirEntry;
    bFlag : BOOLEAN;
BEGIN
    GetFirstDir( sFileName, BITSET{}, rDirEntry, bFlag);
    RETURN bFlag

END Exists;
END XDOS.

