IMPLEMENTATION MODULE XString;

FROM Strings IMPORT CompareStr, Assign, Copy, Pos, Length, Concat, Insert, Delete;
FROM System IMPORT AX, DX, Trap;
FROM NumberConversion IMPORT StringToCard;

PROCEDURE IsWhite( C : CHAR) : BOOLEAN;
BEGIN
     CASE C OF
          0X..20X,7FX : RETURN TRUE;
          ELSE RETURN FALSE
     END
END IsWhite;

PROCEDURE Cut( String : ARRAY OF CHAR; VAR First, ButFirst : ARRAY OF CHAR);
VAR I,
    J,
    QuoteNumber:CARDINAL;
    DELIM : CHAR;
    Empty : ARRAY [0..5] OF CHAR;
BEGIN
     Empty := '';
     IF String[0] = 0X  THEN
        Assign(Empty,First);
        Assign(Empty,ButFirst);
        RETURN
     END;
     I := 0;
     J := HIGH(String);
     WHILE ( IsWhite(String[I]) AND (I<=J) ) DO
           INC(I,1)
     END;
     Copy(String,I,J,String);
     QuoteNumber := Pos(String[0],CutOpenQuote);
     IF QuoteNumber<=HIGH(CutOpenQuote) THEN
          DELIM := CutCloseQuote[QuoteNumber];
          Copy(String,1,J,String);
          I := Pos(DELIM,String);
          IF I > HIGH(String) THEN
               Assign(String,First);
               Assign(Empty,ButFirst);
          ELSE
              Copy(String,0,I,First);
              Copy(String,I+1,J,ButFirst);
          END;
      ELSE
           I := Pos(' ',String);
           IF I > HIGH(String) THEN
                I := Pos(9X,String);
           END;
           IF I > HIGH(String) THEN
                Assign(String,First);
                Assign(Empty,ButFirst);
           ELSE
                Copy(String,0,I,First);
                Copy(String,I+1,J,ButFirst);
           END;
       END;
END Cut;
PROCEDURE Spaces( I : CARDINAL; VAR S : ARRAY OF CHAR);
VAR
   J : CARDINAL;
BEGIN
     FOR J := 1 TO I DO
         Concat(S,' ',S)
     END
END Spaces;

PROCEDURE LeftJustify( S : ARRAY OF CHAR; I : CARDINAL; VAR LJ : ARRAY OF CHAR);
BEGIN
    Copy(LJ,0,0,LJ);
     IF Length(S)<I THEN
        Spaces(I-Length(S),LJ);
        Concat(S,LJ,LJ)
     ELSE
         IF Length(S)=I THEN
            Assign(S,LJ)
         ELSE
             Copy(S,0,I,LJ)
         END
     END

END LeftJustify;
PROCEDURE Detab( S : ARRAY OF CHAR; W : CARDINAL; VAR D : ARRAY OF CHAR);
VAR
   K : CARDINAL;
   j : ARRAY [0..10] OF CHAR;
BEGIN
     K := Pos(9X,S);
     WHILE K<=HIGH(S) DO
           Delete(S,K,1);
           Spaces(8 - (K MOD W),j);
           Insert(j,S,K);
           K := Pos(9X,S)
     END;
     Assign(S,D)

END Detab;
PROCEDURE AlphaOnly( VAR Src : ARRAY OF CHAR);
VAR
        I,N : CARDINAL;
BEGIN
        N := Length(Src);
        I := 0;
        WHILE I<N DO
                CASE Src[I] OF
                'A'..'Z','a'..'z' : INC(I);
                ELSE    Delete(Src,I,1);
                        DEC(N)
                END;
END;
END AlphaOnly;

PROCEDURE Unique( VAR Src : ARRAY OF CHAR);
VAR
        N, I : CARDINAL;
BEGIN
        I := 0;
        N := Length(Src);
        WHILE (I<N) DO
                IF Src[I]=Src[I+1] THEN
                        Delete(Src,I,1);
                        DEC(N);
                ELSE
                        INC(I)
                END;
        END;
END Unique;

PROCEDURE UpperCase( VAR Src : ARRAY OF CHAR);
VAR
        I,
        N : CARDINAL;
BEGIN
        N := Length(Src);
        IF N > 0 THEN
            DEC(N);
            FOR I := 0 TO N BY 1 DO
                Src[I] := CAP(Src[I])
            END;
        END;
END UpperCase;

PROCEDURE YesNo( S : ARRAY OF CHAR) : BOOLEAN;
VAR
        C : CHAR;
        F : BOOLEAN;
BEGIN
        Display(S);
        Display(" (Y/N)? ");
        F := FALSE;
        WHILE NOT F DO
                AX := 0700H;
                Trap(21H);
                C := CAP(CHR( AX MOD 256));

                IF ( ( C = 'Y' ) OR ( C = 'N') ) THEN
                    F := TRUE
                ELSE
                    Display(CHR(7));
                    F := FALSE;
                END;
        END;
        Display(C);
        Display(CHR(13));
        Display(CHR(10));
        RETURN (C = "Y")

END YesNo;
PROCEDURE RepeatString( S : ARRAY OF CHAR; N : CARDINAL; VAR O : ARRAY OF CHAR);
VAR I : CARDINAL;
BEGIN
        O[0] := 0X;
        FOR I := 1 TO N DO
                Concat(O,S,O)
        END;
END RepeatString;
PROCEDURE IndexInList( Find, InThis : ARRAY OF CHAR; Width : CARDINAL) : CARDINAL;
VAR
   I : CARDINAL;

BEGIN
     I := Pos(Find, InThis);
     IF (I>HIGH(InThis)) THEN
        RETURN 0
     ELSE
         RETURN (I DIV Width)+1
     END

END IndexInList;

PROCEDURE ParseEscape( S : ARRAY OF CHAR; VAR O : ARRAY OF CHAR);
VAR Temp : ARRAY [0..2] OF CHAR;
    I, J : CARDINAL;
    Flag : BOOLEAN;
BEGIN
     FOR I := 0 TO Length(S) BY 3 DO
         Copy(S,I,3,Temp);
         StringToCard(Temp,J,Flag);
         IF Flag THEN
            IF J <> 0 THEN
               Concat(O,CHR(J),O)
            END
         END
     END;
END ParseEscape;

PROCEDURE RightTrim( VAR S : ARRAY OF CHAR);
VAR
    rc : INTEGER;
BEGIN
    rc := Length(S);
    LOOP
        DEC(rc);
        IF rc < 0 THEN
            EXIT
        END;
        IF NOT IsWhite(S[rc]) THEN
            EXIT
        ELSE
            S[rc] := 0X;
        END;
    END;
END RightTrim;
PROCEDURE LeftTrim( VAR S : ARRAY OF CHAR);
VAR
        lim : CARDINAL;
BEGIN
        lim := Length(S);
        LOOP
                IF lim = 0 THEN
                        EXIT
                END;
                IF IsWhite(S[0]) THEN
                        Delete(S,0,1);
                        DEC(lim)
                ELSE
                        EXIT
                END;
        END;
END LeftTrim;

PROCEDURE Exact( ax1, ax2 : ARRAY OF CHAR) : BOOLEAN;
BEGIN
    RightTrim( ax1);
    RightTrim( ax2);
    RETURN (CompareStr( ax1, ax2) = 0)
END Exact;

PROCEDURE Equiv( ax1, ax2 : ARRAY OF CHAR) : BOOLEAN;
BEGIN
    RightTrim( ax1);
    UpperCase( ax1);
    RightTrim( ax2);
    UpperCase( ax2);
    RETURN (CompareStr( ax1, ax2) = 0)
END Equiv;

PROCEDURE GetResponse( sPrompt, sChoices : ARRAY OF CHAR) : CARDINAL;

VAR
        xTemp : CHAR;
        bFlag : BOOLEAN;
        cPos : CARDINAL;
BEGIN
        Display(sPrompt);
        bFlag := FALSE;
        WHILE NOT bFlag DO
                AX := 0700H;
                Trap(21H);
                xTemp := CAP(CHR( AX MOD 256));
                cPos := Pos( xTemp, sChoices);
                bFlag := (cPos <= HIGH( sChoices));
        END;
        Display(xTemp);
        Display(CHR(13));
        Display(CHR(10));
        RETURN cPos

END GetResponse;

PROCEDURE Display( DString : ARRAY OF CHAR);
VAR i : CARDINAL;
    c : CHAR;
    s : ARRAY [0..127] OF CHAR;
BEGIN
     Concat(DString,CHR(0),s);
     i := 0;
     LOOP
         c := s[i];
         IF c = 0X THEN
            EXIT
         END;
         AX := 0200H;
         DX := ORD(c);
         Trap(21H);
         INC(i)
      END;
END Display;

PROCEDURE ZeroFill( VAR sToFill : ARRAY OF CHAR);
VAR
    cIdx : CARDINAL;
    cLen : CARDINAL;

BEGIN
    cLen := Length( sToFill);
    IF cLen > 0 THEN
        FOR cIdx := 0 TO cLen-1 DO
            IF sToFill[cIdx]=40C THEN
                sToFill[cIdx] := '0'
            END;
        END;
    END

END ZeroFill;


BEGIN
     CutOpenQuote[0] := 27X;
     CutOpenQuote[1] := '"';
     CutCloseQuote[0] := 27X;
     CutCloseQuote[1] := '"';
END XString.
