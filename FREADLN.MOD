IMPLEMENTATION MODULE FREADLN;
    FROM ASCII IMPORT CR, LF;
    FROM Files IMPORT Seek, SEEKCUR, SEEKABS, Read;
    FROM Storage IMPORT ALLOCATE, DEALLOCATE;
    FROM SYSTEM IMPORT OFS;

    PROCEDURE FReadLine( fp : INTEGER; VAR sLine : ARRAY OF CHAR) : BOOLEAN;

        VAR
            pBuffer, pTemp : POINTER TO CHAR;
            lcNow, lcAfter : LONGCARD;
            cCount, cInc, cLoc : CARDINAL;
        BEGIN
            lcAfter := 0L;
            Seek( fp, SEEKCUR, lcAfter);
            ALLOCATE( pBuffer, 1024);
            Read( fp, pBuffer, 1024, cCount);
            IF cCount = 0 THEN
                sLine[0] := 0C;
                RETURN FALSE
            END;
            pTemp := pBuffer;
            cInc := 0;
            LOOP
                IF pTemp^ = CR THEN
                    EXIT
                ELSE
                    INC( cInc);
                    IF cInc > 1023 THEN
                        sLine[0] := 0C;
                        RETURN FALSE
                    END;
                    INC( pTemp.OFS);
                END
            END;

            cLoc := cInc;
            pTemp := pBuffer;
            IF cLoc # 0 THEN
                FOR cInc := 0 TO cLoc-1 DO
                    sLine[cInc] := pTemp^;
                    INC(pTemp.OFS)
                END;
            END;
            sLine[cLoc] := 0C;
            lcAfter := lcAfter + LONG(cLoc+1);
            INC( pTemp.OFS);
            IF pTemp^ = LF THEN
                INC( lcAfter);
            END;
            Seek( fp, SEEKABS, lcAfter);
            DEALLOCATE( pBuffer, 1024);
            RETURN TRUE
        END FReadLine;

    BEGIN
    END FREADLN.
