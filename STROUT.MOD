IMPLEMENTATION MODULE StrOut;
FROM SYSTEM IMPORT ASSEMBLER;
FROM Strings IMPORT Length;
PROCEDURE DispChar( C : CHAR);
BEGIN
        CASE DispMode OF
                DOS : ASM
                        MOV       DL,C
                        MOV       AH,2
                        INT       21X
                      END;
                |
                BIOS : ASM
                           MOV       AL,C
                           MOV       BH,0  (* current screen *)
                           MOV       AH,14 (* write to TTY *)
                           INT       10X   (* video output *)
                         END;
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
BEGIN
        DispMode := DOS
END StrOut.
