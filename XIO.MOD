IMPLEMENTATION MODULE XIO;

FROM SYSTEM IMPORT SEGMENT, OFFSET (*, ASSEMBLER*);
FROM Strings IMPORT Concat, Copy, Length;
FROM System IMPORT AX, DX, BX, DS, XTrap, Trap;

PROCEDURE GetChar( Echo : BOOLEAN):CHAR;
BEGIN
        IF Echo THEN
                AX := 0100H
        ELSE
                AX := 0700H
        END;
        Trap(21H);
        RETURN CHR( AX MOD 256)
END GetChar;

PROCEDURE GetLine( VAR S : ARRAY OF CHAR; Echo : BOOLEAN);
VAR
   cnt, lim : CARDINAL;
   chr      : CHAR;

BEGIN
     cnt := 0;
     lim := SIZE(S);
     LOOP
         chr := GetChar(Echo);
         IF (chr = 0DX) OR (cnt > lim) THEN
            EXIT
         END;
         S[cnt] := chr;
         INC(cnt)
     END
END GetLine;

PROCEDURE InputLine( VAR S : ARRAY OF CHAR);
VAR
    c : CARDINAL;
BEGIN
        DX := OFFSET(S);
        S[0] := 0FFX;
        S[1] := 0X;
        AX := 0A00H;
        Trap(21H);
        Copy(S,2,ORD(S[1]),S);
END InputLine;

PROCEDURE DispChar( C : CHAR);
BEGIN
        CASE DispMode OF
                DOS :   AX := 0200H;
                        DX := ORD(C);
                        Trap(21H)
                |
                BIOS :  AX := 0E00H + ORD(C);
                        BX := 0000H;
                        Trap(10H)
        END;

END DispChar;

PROCEDURE DispString( P : ARRAY OF CHAR);
VAR
   K,I : CARDINAL;
   J : CHAR;
BEGIN
     K := SIZE(P)-1;
     FOR I := 0 TO K DO
         J := P[I];
         IF J=0X THEN
            I := K
         ELSE
            DispChar(P[I]);
         END;
     END;
END DispString;

PROCEDURE DispNL;
VAR
   X : ARRAY [0..1] OF CHAR;

BEGIN
     X[0] := 0DX;
     X[1] := 0AX;
     DispString(X)
END DispNL;
PROCEDURE DispRepeat( N : CARDINAL; S : ARRAY OF CHAR);
VAR I : CARDINAL;
BEGIN
     FOR I := 1 TO N DO
        DispString(S)
     END
END DispRepeat;
PROCEDURE Reverse(VAR S:ARRAY OF CHAR);
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
PROCEDURE DispCard(C:CARDINAL;W:CARDINAL);
VAR I : CARDINAL;
    S : ARRAY [0..5] OF CHAR;
BEGIN
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
           DispRepeat(W-I," ")
        END;
        DispString(S);

END DispCard;
PROCEDURE DispLongCard(L:LONGCARD;W:CARDINAL);
VAR I : CARDINAL;
    S : ARRAY [0..12] OF CHAR;
BEGIN
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
           DispRepeat(W-I," ")
        END;
        DispString(S);

END DispLongCard;
PROCEDURE DispLine( S : ARRAY OF CHAR);
BEGIN
        DispString(S);
        DispNL
END DispLine;
PROCEDURE DispText( S : ARRAY OF CHAR);
VAR
        Of,SE : CARDINAL;
        NewS  : ARRAY [0..255] OF CHAR;
BEGIN
        Concat(S,"$",NewS);
        DS := SEGMENT(NewS);
        DX := OFFSET(NewS);
        XTrap(21H);
END DispText;

BEGIN
        DispMode := DOS
END XIO.

