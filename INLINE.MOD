IMPLEMENTATION MODULE INLine;

    FROM ASCII IMPORT NUL;
    FROM Strings IMPORT Copy, Pos, Length;
    FROM DEBUG IMPORT SetDebug, DebugS, DebugC, DebugL;
    FROM ASSERT IMPORT Assert, ASSERT_ERRORS;

    PROCEDURE IsIn( sFind, sIn : ARRAY OF CHAR) : BOOLEAN;
        VAR
            c : CARDINAL;
        BEGIN
            Assert( sFind[0] # 0C, "sFind in IsIn is null", ASSERT_BAD );
            Assert( sIn[0] # 0C, "sIn in IsIn is null", ASSERT_BAD );
            c := Pos( sFind , sIn);
            RETURN (NOT (c > HIGH( sIn)))
        END IsIn;

    PROCEDURE InLine( VAR cFrom : CARDINAL; sTarget, sFind, sBreak : ARRAY OF CHAR; bWholeWord : BOOLEAN) : BOOLEAN;
        VAR
            cHere,
            cPos,
            cSav : CARDINAL;
            sTemp : ARRAY [0..255] OF CHAR;
            bResult : BOOLEAN;

        PROCEDURE IsWord( sMaster : ARRAY OF CHAR; cStart, cLength :CARDINAL) :BOOLEAN;
            VAR
                bLeftIsSpace,
                bRightIsSpace : BOOLEAN;
                cLeft,
                cRight        : CARDINAL;

            BEGIN
                bRightIsSpace := FALSE;
                bLeftIsSpace := FALSE;

                cRight := cStart + cLength;
                cLeft := cStart - 1;

                IF sMaster[cRight] = NUL THEN
                    bRightIsSpace := TRUE
                ELSE
                    IF IsIn( sMaster[cRight], sBreak) THEN
                        bRightIsSpace := TRUE
                    END;
                END;

                IF (cStart) = 0 THEN
                    bLeftIsSpace := TRUE
                ELSE
                    IF IsIn( sMaster[cLeft], sBreak) THEN
                        bLeftIsSpace := TRUE
                    END;
                END;

                IF (bLeftIsSpace AND bRightIsSpace) THEN
                    RETURN TRUE
                ELSE
                    RETURN FALSE
                END;

            END IsWord;

        BEGIN
            cHere := cFrom;
            cSav := HIGH( sTarget);
            IF bWholeWord THEN
                LOOP
                    Copy(sTarget, cHere, 256, sTemp);
                    cPos := Pos( sFind, sTemp);
                    IF cPos <= HIGH( sTemp) THEN
                        IF IsWord( sTarget, cPos+cHere, Length(sFind)) THEN
                            cFrom := cHere + cPos;
                            bResult := TRUE;
                            EXIT
                        ELSE
                            cHere := cHere + cPos + Length(sFind);
                        END;
                    ELSE
                        cFrom := cSav + 1;
                        bResult := FALSE;
                        EXIT
                    END
                END;
                (* Find Whole *)
            ELSE
                Copy(sTarget, cFrom, 256, sTemp);
                cHere := Pos( sFind, sTemp);
                IF cHere <= HIGH( sTemp) THEN
                    cFrom := cFrom + cHere;
                    bResult := TRUE
                ELSE
                    cFrom := cSav + 1;
                    bResult := FALSE
                END

            END;
            RETURN bResult
        END InLine;



END INLine.
