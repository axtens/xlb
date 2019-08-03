IMPLEMENTATION MODULE SHELSORT;

    FROM XString IMPORT UpperCase;
    FROM Strings
        IMPORT CompareStr;

    PROCEDURE shellsort( VAR a : ARRAY OF STRING; cCount : CARDINAL; bIgnoreCase : BOOLEAN);
        VAR
            iLimit,
            iGap,
            i1,
            i2      : INTEGER;
            sTemp3   : STRING;

        PROCEDURE StringCompare( s1, s2 : ARRAY OF CHAR) : INTEGER;
            BEGIN
                IF bIgnoreCase THEN
                    UpperCase(s1);
                    UpperCase(s2)
                END;
                RETURN CompareStr(s1,s2)
            END StringCompare;

        BEGIN
            IF cCount = 0 THEN
                iLimit := HIGH(a)
            ELSE
                iLimit := INTEGER(cCount)
            END;
            iGap := iLimit DIV 2;
            WHILE iGap > 0 DO
                i1 := iGap;
                WHILE i1 < iLimit DO
                    i2 := i1 - iGap;
                    WHILE (i2 >= 0) AND (StringCompare( a[i2],a[i2+iGap]) > 0 ) DO
                        sTemp3 := a[i2];
                        a[i2] := a[i2 + iGap];
                        a[i2 + iGap] := sTemp3;
                        i2 := i2 - iGap;
                    END;
                    INC(i1)
                END;
                iGap := iGap DIV 2;
            END
        END shellsort;

END SHELSORT.

