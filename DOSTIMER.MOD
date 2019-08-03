IMPLEMENTATION MODULE DosTimer;

    FROM System IMPORT AX, CX, DX, Trap;

    PROCEDURE Timer() : LONGCARD;
        VAR
            lcRet : LONGCARD;
        BEGIN
            AX := 00H;
            Trap(1AH);
            lcRet := LONG(CX)*65536L + LONG(DX);
            RETURN lcRet
        END Timer;

    PROCEDURE TimerSeconds() : REAL;
        BEGIN
            RETURN SHORT(FLOAT(Timer()) / LONG(18.206))
        END TimerSeconds;


    PROCEDURE TimerWholeSeconds() : LONGCARD;
        BEGIN
            RETURN TRUNC(FLOAT(Timer()) / LONG(18.206))
        END TimerWholeSeconds;

    PROCEDURE Timer2( VAR cSeconds, cThousandths : CARDINAL);
        VAR
            rTime : REAL;
        BEGIN
            rTime := TimerSeconds();
            cSeconds := TRUNC(rTime);
            cThousandths := TRUNC( (rTime - FLOAT( cSeconds)) * 1000.0)
        END Timer2;

    PROCEDURE TicksToSeconds( lcTicks : LONGCARD) : REAL;
        BEGIN
            RETURN SHORT(FLOAT(lcTicks) / LONG(18.206))
        END TicksToSeconds;

    PROCEDURE TicksToWholeSeconds( lcTicks : LONGCARD) : LONGCARD;
        BEGIN
            RETURN TRUNC(FLOAT(lcTicks) / LONG(18.206))
        END TicksToWholeSeconds;

    PROCEDURE TicksToThousandths( lcTicks : LONGCARD) : LONGCARD;
        BEGIN
            RETURN TRUNC((FLOAT(lcTicks) / LONG(18.206))*1000.0)
        END TicksToThousandths;

    BEGIN
    END DosTimer.
