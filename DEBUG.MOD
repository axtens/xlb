IMPLEMENTATION MODULE DEBUG;

    FROM ASCII IMPORT NUL;
    FROM DevIO IMPORT WriteOut, LineOut, CardOut, IntOut;
    FROM XString IMPORT Equiv;
    FROM System IMPORT GetEnv;


    VAR
        bDebugFlag : BOOLEAN;

    PROCEDURE SetDebug( b : BOOLEAN);
        BEGIN
            bDebugFlag := b
        END SetDebug;

    PROCEDURE SetDebugEnv( sEnv, sVal : ARRAY OF CHAR);
        VAR
            sValue : ARRAY [0..19] OF CHAR;
        BEGIN
            GetEnv( sEnv, sValue);
            IF sValue[0] = NUL THEN
                bDebugFlag := FALSE
            ELSE
                bDebugFlag := Equiv( sVal, sValue);
                DebugL("DEBUG is ON")
            END
        END SetDebugEnv;


    PROCEDURE DebugS( s : ARRAY OF CHAR);
        BEGIN
            IF bDebugFlag THEN
                WriteOut( s)
            END
        END DebugS;

    PROCEDURE DebugL( s : ARRAY OF CHAR);
        BEGIN
            IF bDebugFlag THEN
                LineOut( s)
            END
        END DebugL;

    PROCEDURE DebugC( c1 : CARDINAL);
        BEGIN
            IF bDebugFlag THEN
                CardOut( c1, cDebugNumWidth)
            END
        END DebugC;

    PROCEDURE DebugI( i1 : INTEGER);
        BEGIN
            IF bDebugFlag THEN
                IntOut( i1, cDebugNumWidth)
            END
        END DebugI;

    PROCEDURE DebugB( b1 : BOOLEAN );
    BEGIN
         IF bDebugFlag THEN
            IF b1 THEN
               WriteOut( "TRUE" )
            ELSE
                WriteOut( "FALSE" )
            END
         END
    END DebugB;

    PROCEDURE IsDebug() : BOOLEAN;
        BEGIN
            RETURN bDebugFlag
        END IsDebug;

    BEGIN
        bDebugFlag := FALSE;
        cDebugNumWidth := 1;

    END DEBUG.
