IMPLEMENTATION MODULE Bar;

FROM XIO IMPORT DispRepeat;
CONST
     SparseBlock = 0B0X;
     FullBlock   = 0B2X;
VAR
        Comparator,
        BarLength,
        BarCount1,
        BarCount2,
        BarCount3 : LONGCARD;

PROCEDURE InitBar(BarLen : CARDINAL; Compar : LONGCARD);
BEGIN
        BarLength := LONG(BarLen);
        BarCount1 := 0L;
        Comparator := Compar;
        BarCount3 := 0L;
END InitBar;

PROCEDURE DisplayBar;
BEGIN
        DispRepeat(SHORT(BarLength),SparseBlock);
        DispRepeat(SHORT(BarLength),8X);
END DisplayBar;

PROCEDURE DisplayFullBar;
BEGIN
     DispRepeat(SHORT(BarLength),FullBlock);
END DisplayFullBar;

PROCEDURE UpdateBar( count : CARDINAL);
VAR
    Percent : LONGCARD;
BEGIN
    BarCount3 := BarCount3 + LONG(count);
    Percent := TRUNC( FLOAT(BarCount3)/FLOAT(Comparator)*FLOAT(BarLength));
    IF Percent > BarCount1 THEN
        BarCount2 := Percent - BarCount1;
        DispRepeat(SHORT(BarCount2),FullBlock);
        BarCount1 := Percent
    END;
END UpdateBar;

BEGIN
        InitBar(10,10L);
END Bar.

