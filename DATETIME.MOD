IMPLEMENTATION MODULE DATETIME;

    FROM System IMPORT Trap, AX, CX, DX;
    FROM Strings IMPORT Assign, Append;
    FROM NumberConversion IMPORT CardToString;
    FROM XString IMPORT ZeroFill;

    PROCEDURE GetDosDate;
        BEGIN
            AX := 2A00H;
            Trap(21H)
        END GetDosDate;

    PROCEDURE GetDosTime;
        BEGIN
            AX := 2C00H;
            Trap(21H)
        END GetDosTime;


    PROCEDURE GetDate( VAR sDat : ARRAY OF CHAR);
        CONST
            Slash = "/";
            cWIDTH = 2;
        VAR
            cDay,
            cMonth,
            cYear : CARDINAL;
            sDay,
            sMonth,
            sYear : ARRAY [0..1] OF CHAR;
            sDate : ARRAY [0..7] OF CHAR;
        BEGIN
            sDate := '';
            GetDosDate;
            cDay := DX MOD 256;
            cMonth := DX DIV 256;
            cYear := CX MOD 1900;
            CardToString(cDay,sDay,cWIDTH);
            CardToString(cMonth,sMonth,cWIDTH);
            CardToString(cYear,sYear,cWIDTH);
            ZeroFill(sDay);
            ZeroFill(sMonth);
            ZeroFill(sYear);
            Assign(sDay,sDate);
            Append(sDate,Slash);
            Append(sDate,sMonth);
            Append(sDate,Slash);
            Append(sDate,sYear);
            Assign(sDate,sDat)
        END GetDate;

    PROCEDURE GetTime( VAR sTim : ARRAY OF CHAR);
        CONST
            cWIDTH = 2;
            Colon = ":";
        VAR
            cHour,
            cMin,
            cSec : CARDINAL;
            sHour,
            sMin,
            sSec : ARRAY [0..1] OF CHAR;
            sTime : ARRAY [0..7] OF CHAR;
        BEGIN
            sTime := '';
            GetDosTime;
            cHour := CX DIV 256;
            cMin := CX MOD 256;
            cSec := DX DIV 256;
            CardToString(cHour,sHour,cWIDTH);
            CardToString(cMin,sMin,cWIDTH);
            CardToString(cSec,sSec,cWIDTH);
            ZeroFill(sHour);
            ZeroFill(sMin);
            ZeroFill(sSec);
            Assign(sHour,sTime);
            Append(sTime,Colon);
            Append(sTime,sMin);
            Append(sTime,Colon);
            Append(sTime,sSec);
            Assign(sTime,sTim)
        END GetTime;

    END DATETIME.
