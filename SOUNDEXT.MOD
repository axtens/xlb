IMPLEMENTATION MODULE SoundeXtras;

FROM Strings IMPORT Delete, Length, Copy, Concat, Pos;
FROM XString IMPORT AlphaOnly, Unique, UpperCase;

PROCEDURE SoundeX( VAR Src : ARRAY OF CHAR);
VAR
        J,I,N : CARDINAL;
        Temp : CHAR;
        SoundexList : ARRAY [0..36] OF CHAR;
BEGIN
        SoundexList := 'B1C2D3F1G2J2K2L4M5N5P1Q2R6S2T3V1X2Z2';
        AlphaOnly(Src);
        IF Src[0]=0C THEN
           RETURN
        END;
        UpperCase(Src);
        Unique(Src);
        I := 1;
        N := Length(Src)-1;
        WHILE (I<=N) DO
                Temp := Src[I];
                J := Pos( Temp, SoundexList);
                IF (J>HIGH(SoundexList)) THEN
                        Delete(Src,I,1);
                        DEC(N)
                ELSE
                        Src[I] := SoundexList[J+1];
                        INC(I)
                END;
        END;
        Unique(Src);
        Concat(Src,'000',Src);
        Copy(Src,0,4,Src)
END SoundeX;

END SoundeXtras.
