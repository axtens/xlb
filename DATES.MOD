IMPLEMENTATION MODULE Dates;

FROM System IMPORT Trap, AX, CX, DX;
FROM Strings IMPORT Assign;

PROCEDURE GetDosDate;
BEGIN
        AX := 2A00H;
        Trap(21H)
END GetDosDate;

PROCEDURE GetDayOfWeekNumber( VAR dayofweeknum : CARDINAL);
BEGIN
        GetDosDate;
        dayofweeknum := AX MOD 256;
END GetDayOfWeekNumber;

PROCEDURE GetDayOfWeekName( VAR dayname : ARRAY OF CHAR);
VAR
        dnum : CARDINAL;
        day  : ARRAY [0..8] OF CHAR;
BEGIN
        GetDayOfWeekNumber(dnum);
        CASE dnum OF
                0 : day := "Sunday";
                |
                1 : day := "Monday";
                |
                2 : day := "Tuesday";
                |
                3 : day := "Wednesday";
                |
                4 : day := "Thursday";
                |
                5 : day := "Friday";
                |
                6 : day := "Saturday";
        END;
        Assign( day,dayname );
END GetDayOfWeekName;

PROCEDURE GetDayNumber( VAR daynum : CARDINAL);
BEGIN
        GetDosDate;
        daynum := DX MOD 256
END GetDayNumber;


PROCEDURE GetMonthNumber( VAR monthnum : CARDINAL);
BEGIN
        GetDosDate;
        monthnum := DX DIV 256
END GetMonthNumber;

PROCEDURE GetMonthName( VAR monthname : ARRAY OF CHAR);
VAR
        mnum : CARDINAL;
        month : ARRAY [0..8] OF CHAR;
BEGIN
        GetMonthNumber(mnum);
        CASE mnum OF
                1 : month :=  "January";
                |
                2 : month :=  "February";
                |
                3 : month :=  "March";
                |
                4 : month := "April";
                |
                5 : month := "May";
                |
                6 : month := "June";
                |
                7 : month := "July";
                |
                8 : month := "August";
                |
                9 : month := "September";
                |
                10 : month := "October";
                |
                11 : month := "November";
                |
                12 : month := "December";
        END;
        Assign(month,monthname);
END GetMonthName;

PROCEDURE GetYearNumber( VAR yearnum : CARDINAL);
BEGIN
        GetDosDate;
        yearnum := CX
END GetYearNumber;

END Dates.
