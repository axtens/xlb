IMPLEMENTATION MODULE DevIO;

FROM Files IMPORT StdIn, StdOut, StdErr, StdCom, StdPrn, Read, Write;
FROM SYSTEM IMPORT ADR;
FROM Strings IMPORT Length;
FROM XString IMPORT RepeatString;

VAR
    crlf : ARRAY [0..1] OF CHAR;


PROCEDURE INPUT( Device : INTEGER; VAR S : ARRAY OF CHAR);
BEGIN
        Read(Device,ADR(S),SIZE(S),RWcnt)
END INPUT;

PROCEDURE OUTPUT( Device : INTEGER; VAR S : ARRAY OF CHAR);
BEGIN
        Write(Device,ADR(S),SIZE(S),RWcnt)
END OUTPUT;


PROCEDURE InChar( VAR C : CHAR);
BEGIN
    Read(StdIn,ADR(C),1,RWcnt)
END InChar;

PROCEDURE InRead( VAR S : ARRAY OF CHAR);
BEGIN
    Read(StdIn,ADR(S),Length(S),RWcnt)
END InRead;

PROCEDURE ComChar( VAR C : CHAR);
BEGIN
    Read(StdCom,ADR(C),1,RWcnt);
END ComChar;

PROCEDURE ComRead( VAR S : ARRAY OF CHAR);
BEGIN
    Read(StdCom,ADR(S),1,RWcnt)
END ComRead;


PROCEDURE CharOut( C : CHAR);
BEGIN
    Write(StdOut,ADR(C),1,RWcnt)
END CharOut;

PROCEDURE WriteOut( S : ARRAY OF CHAR);
BEGIN
    Write(StdOut,ADR(S),Length(S),RWcnt)
END WriteOut;

PROCEDURE NLOut;
BEGIN
    Write(StdOut,ADR(crlf),2,RWcnt)
END NLOut;

PROCEDURE LineOut( S : ARRAY OF CHAR);
BEGIN
    WriteOut(S);
    NLOut
END LineOut;

PROCEDURE IntOut( I : INTEGER; W:CARDINAL);
VAR c1,c2 : CARDINAL;
    sAscii,
    sSpacing : ARRAY [0..5] OF CHAR;
    bNeg : BOOLEAN;
BEGIN
    IF I < 0 THEN
        bNeg := TRUE;
        I := I * (-1);
    ELSE
        bNeg := FALSE
    END;
    sAscii := "";
    sSpacing := "";
    c1 := 0;
    REPEAT
            sAscii[c1] := CHR( I MOD 10 + INTEGER(ORD("0")));
            INC(c1);
            I := I DIV 10;
    UNTIL I <= 0;
    sAscii[c1] := 0X;
    Reverse(sAscii);
    c1 := Length(sAscii);
    IF W>c1 THEN

        IF bNeg THEN
            c2 := W-c1-1
        ELSE
            c2 := W-c1
        END;
        RepeatString(" ",c2,sSpacing)
    END;
    WriteOut(sSpacing);
    IF bNeg THEN
        WriteOut("-")
    END;
    WriteOut(sAscii);

END IntOut;

PROCEDURE CardOut( C : CARDINAL; W : CARDINAL);
VAR I : CARDINAL;
    S,
    T : ARRAY [0..5] OF CHAR;
BEGIN
    S := "";
    T := "";
        I := 0;
        REPEAT
                S[I] := CHR( C MOD 10 + ORD("0"));
                INC(I);
                C := C DIV 10;
        UNTIL C <= 0;
        S[I] := 0X;
        Reverse(S);
        I := Length(S);
        IF W>I THEN
           RepeatString(" ",W-I,T)
        END;
        WriteOut(T);
        WriteOut(S);

END CardOut;


PROCEDURE LongCardOut( L : LONGCARD; W : CARDINAL);
VAR I : CARDINAL;
    S,
    T : ARRAY [0..12] OF CHAR;
BEGIN
    S := "";
    T := "";
        I := 0;
        REPEAT
                S[I] := CHR( SHORT(L MOD 10L + LONG(ORD("0"))));
                INC(I);
                L := L DIV 10L;
        UNTIL L <= 0L;
        S[I] := 0X;
        Reverse(S);
        I := Length(S);
        IF W>I THEN
           RepeatString(" ",W-I,T)
        END;
        WriteOut(T);
        WriteOut(S);

END LongCardOut;



PROCEDURE CharErr( C : CHAR);
BEGIN
    Write(StdErr,ADR(C),1,RWcnt)
END CharErr;

PROCEDURE WriteErr( S : ARRAY OF CHAR);
BEGIN
    Write(StdErr,ADR(S),Length(S),RWcnt)
END WriteErr;

PROCEDURE NLErr;
BEGIN
    Write(StdErr,ADR(crlf),2,RWcnt)
END NLErr;

PROCEDURE LineErr( S : ARRAY OF CHAR);
BEGIN
    WriteErr(S);
    NLErr
END LineErr;

PROCEDURE CardErr( C : CARDINAL; W : CARDINAL);
VAR I : CARDINAL;
    S,
    T : ARRAY [0..5] OF CHAR;
BEGIN
    S := "";
    T := "";
        I := 0;
        REPEAT
                S[I] := CHR( C MOD 10 + ORD("0"));
                INC(I);
                C := C DIV 10;
        UNTIL C <= 0;
        S[I] := 0X;
        Reverse(S);
        I := Length(S);
        IF W>I THEN
           RepeatString(" ",W-I,T)
        END;
        WriteErr(T);
        WriteErr(S);

END CardErr;


PROCEDURE LongCardErr( L : LONGCARD; W : CARDINAL);
VAR I : CARDINAL;
    S,
    T : ARRAY [0..12] OF CHAR;
BEGIN
    S := "";
    T := "";
        I := 0;
        REPEAT
                S[I] := CHR( SHORT(L MOD 10L + LONG(ORD("0"))));
                INC(I);
                L := L DIV 10L;
        UNTIL L <= 0L;
        S[I] := 0X;
        Reverse(S);
        I := Length(S);
        IF W>I THEN
           RepeatString(" ",W-I,T)
        END;
        WriteErr(T);
        WriteErr(S);

END LongCardErr;




PROCEDURE CharCom( C : CHAR);
BEGIN
    Write(StdCom,ADR(C),1,RWcnt)
END CharCom;

PROCEDURE WriteCom( S : ARRAY OF CHAR);
BEGIN
    Write(StdCom,ADR(S),Length(S),RWcnt)
END WriteCom;

PROCEDURE NLCom;
BEGIN
    Write(StdCom,ADR(crlf),2,RWcnt)
END NLCom;

PROCEDURE LineCom( S : ARRAY OF CHAR);
BEGIN
    WriteCom(S);
    NLCom
END LineCom;

PROCEDURE CardCom( C : CARDINAL; W:CARDINAL);
BEGIN
END CardCom;

PROCEDURE LongCardCom( L : LONGCARD; W:CARDINAL);
BEGIN
END LongCardCom;


PROCEDURE CharPrn( C : CHAR);
BEGIN
    Write(StdPrn,ADR(C),1,RWcnt)
END CharPrn;

PROCEDURE WritePrn( S : ARRAY OF CHAR);
BEGIN
    Write(StdPrn,ADR(S),Length(S),RWcnt)
END WritePrn;

PROCEDURE NLPrn;
BEGIN
    Write(StdPrn,ADR(crlf),2,RWcnt)
END NLPrn;

PROCEDURE LinePrn( S : ARRAY OF CHAR);
BEGIN
    WritePrn(S);
    NLPrn
END LinePrn;

PROCEDURE CardPrn( C : CARDINAL; W:CARDINAL);
BEGIN
END CardPrn;

PROCEDURE LongCardPrn( L : LONGCARD; W:CARDINAL);
BEGIN
END LongCardPrn;



PROCEDURE Reverse(VAR S : ARRAY OF CHAR);
VAR
        C : CHAR;
        I, J : CARDINAL;
BEGIN
        I := 0;
        J := Length(S)-1;
        WHILE (I<J) DO
                C := S[I];
                S[I] := S[J];
                S[J] := C;
                INC(I);
                DEC(J)
        END;
END Reverse;
BEGIN
    crlf[0] := 0DX;
    crlf[1] := 0AX
END DevIO.


