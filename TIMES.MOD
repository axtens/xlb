IMPLEMENTATION MODULE Times;

FROM System IMPORT Trap, AX, CX, DX;
FROM NumberConversion IMPORT CardToString;
FROM Strings IMPORT Concat, Assign;

PROCEDURE GetDosTime;
BEGIN
        AX := 2C00H;
        Trap(21H)
END GetDosTime;

PROCEDURE GetHourNumber( VAR hournum : CARDINAL);
BEGIN
        GetDosTime;
        hournum := CX DIV 256
END GetHourNumber;

PROCEDURE GetMinuteNumber( VAR minutenum : CARDINAL);
BEGIN
        GetDosTime;
        minutenum := CX MOD 256
END GetMinuteNumber;

PROCEDURE GetSecondNumber( VAR secondnum : CARDINAL);
BEGIN
        GetDosTime;
        secondnum := DX DIV 256
END GetSecondNumber;

PROCEDURE GetHundredthNumber( VAR hundredthnum : CARDINAL);
BEGIN
        GetDosTime;
        hundredthnum := DX MOD 256
END GetHundredthNumber;

PROCEDURE GetNow( VAR now : ARRAY OF CHAR);
VAR
        hh, mm, ss, cc : CARDINAL;
        hhs, mms, sss, ccs : ARRAY [0..1] OF CHAR;
        timestring : ARRAY [0..10] OF CHAR;
PROCEDURE ZeroInsert( VAR num : ARRAY OF CHAR);
BEGIN
        IF num[0] = 20X THEN
                num[0] := 30X
        END;
END ZeroInsert;

BEGIN
        GetDosTime;
        hh := CX DIV 256;
        mm := CX MOD 256;
        ss := DX DIV 256;
        cc := DX MOD 256;
        CardToString(hh,hhs,2);
        CardToString(mm,mms,2);
        CardToString(ss,sss,2);
        CardToString(cc,ccs,2);
        ZeroInsert(hhs);
        ZeroInsert(mms);
        ZeroInsert(sss);
        ZeroInsert(ccs);
        Concat(hhs,":",timestring);
        Concat(timestring,mms,timestring);
        Concat(timestring,":",timestring);
        Concat(timestring,sss,timestring);
        Concat(timestring,".",timestring);
        Concat(timestring,ccs,timestring);
        Assign(timestring,now)
END GetNow;

END Times.

