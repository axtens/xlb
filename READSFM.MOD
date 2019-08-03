IMPLEMENTATION MODULE READSFM;
    FROM ASCII IMPORT NUL;
    FROM Strings IMPORT Copy, Delete, Pos, Assign, Append;

    PROCEDURE ReadSFM( sData : ARRAY OF CHAR;
                       VAR sKey, sContent : ARRAY OF CHAR);
        VAR
            sTemp : ARRAY [0..254] OF CHAR;
            cPos : CARDINAL;
            bFlag : BOOLEAN;
        BEGIN
            IF sData[0] = 0C THEN
                sKey[0] := NUL;
                sContent[0] := NUL;
            ELSE
                bFlag := (sData[0] = "\");
                IF bFlag THEN
                    cPos := Pos(" ",sData);
                    IF cPos <= HIGH(sData) THEN
                        Copy(sData,0,cPos,sKey);
                        Append(sKey,0C);
                        Copy(sData,cPos+1,254,sContent);
                        Append(sContent,0C)
                    ELSE
                        IF bFlag THEN
                            Assign(sData,sKey);
                            Append(sKey,0C);
                            sContent[0] := 0C
                        ELSE
                            sKey[0] := 0C;
                            Assign(sData,sContent);
                            Append(sContent,0C)
                        END;
                    END;
                ELSE
                    sKey[0] := 0C;
                    Assign(sData,sContent);
                    Append(sContent,0C);
                END;
            END;
        END ReadSFM;
    BEGIN
    END READSFM.

