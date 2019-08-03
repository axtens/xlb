IMPLEMENTATION MODULE ARGQUERY;

FROM System IMPORT GetArg;

PROCEDURE ArgQuery( pArgProc: ArgProc) : BOOLEAN;
VAR
        sEntry : ArgEntry;
        cCnt : CARDINAL;
        cCounter : CARDINAL;

BEGIN
        cCounter := 0;
        LOOP
                GetArg(sEntry,cCnt);
                IF (cCnt=0) THEN
                   IF (cCounter=0) THEN
                      RETURN FALSE
                   ELSE
                       EXIT
                   END;
                END;
                pArgProc(sEntry);
                INC(cCounter);
        END;
        RETURN TRUE

END ArgQuery;

END ARGQUERY.


