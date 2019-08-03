IMPLEMENTATION MODULE CmdQuery;

FROM System IMPORT GetArg;

PROCEDURE WithCMD( ArgProc: CMDproc) : BOOLEAN;
VAR
        S : CMDentry;
        I : CARDINAL;
        C : CARDINAL;

BEGIN
        C := 0;
        LOOP
                GetArg(S,I);
                IF (I=0) THEN
                   IF (C=0) THEN
                      RETURN FALSE
                   ELSE
                       EXIT
                   END;
                END;
                ArgProc(S);
                INC(C);
        END;
        RETURN TRUE

END WithCMD;

END CmdQuery.


