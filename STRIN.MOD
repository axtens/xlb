IMPLEMENTATION MODULE StrIn;
FROM SYSTEM IMPORT OFFSET, ASSEMBLER;
FROM Strings IMPORT Copy, Length;

PROCEDURE GetChar( Echo : BOOLEAN):CHAR;
VAR
   c : CHAR;
BEGIN
     IF Echo THEN
        c := 1X
     ELSE
        c := 7X
     END;
     ASM
        MOV  AH,c
        INT  21X
        MOV  c,AL
     END;
     RETURN c
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
     c := OFFSET(S);
     S[0] := 0FFX;
     S[1] := 0X;
     ASM
        MOV  DX,c
        MOV  AH,10
        INT  33
     END;
     Copy(S,2,255,S);
     S[Length(S)-1] := 0X;
END InputLine;

END StrIn.
