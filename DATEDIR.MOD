IMPLEMENTATION MODULE DATEDIR;

    FROM System IMPORT Trap, AX, CX, DX;
    FROM Strings IMPORT Assign, Append;
    FROM NumberConversion IMPORT CardToString;
    FROM XString IMPORT ZeroFill;

    VAR
        sCode : ARRAY [0..35] OF CHAR;

    PROCEDURE GetDosDir;
        BEGIN
            AX := 2A00H;
            Trap(21H)
        END GetDosDir;

    PROCEDURE GetDosTime;
        BEGIN
            AX := 2C00H;
            Trap(21H)
        END GetDosTime;



    PROCEDURE DateDir( VAR sDateDir : ARRAY OF CHAR);
        CONST
            cWIDTH = 2;
        VAR
            cHour,
            cMinute,
            cSecond,
            cDay,
            cMonth,
            cYear : CARDINAL;
            sMinute,
            sSecond,
            sDay,
            sMonth,
            sYear : ARRAY [0..1] OF CHAR;
            sDir : ARRAY [0..7] OF CHAR;
        BEGIN
            sDir := '';
            GetDosDir;
            cDay := DX MOD 256;
            cMonth := DX DIV 256;
            cYear := CX MOD 1900;
            GetDosTime;
            cHour := CX DIV 256;
            cMinute := CX MOD 256;
            cSecond := DX DIV 256;
            CardToString(cMinute,sMinute,cWIDTH);
            CardToString(cSecond,sSecond,cWIDTH);
            ZeroFill(sMinute);
            ZeroFill(sSecond);
            sDir[0] := sCode[ cDay ];
            sDir[1] := sCode[ cMonth ];
            sDir[2] := sCode[ cYear - 80 ];
            sDir[3] := sCode[ cHour ];
            sDir[4] := 0C;
            Append(sDir,sMinute);
            Append(sDir,sSecond);
            Assign(sDir,sDateDir);
        END DateDir;

    BEGIN
        sCode := '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    END DATEDIR.
