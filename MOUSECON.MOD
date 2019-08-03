IMPLEMENTATION MODULE MouseControl;

FROM System IMPORT AX, BX, CX, DX, XTrap;

PROCEDURE Mouse( VAR M1, M2, M3, M4 : CARDINAL);
BEGIN
    AX := M1;
    BX := M2;
    CX := M3;
    DX := M4;
    XTrap(51);
    M1 := AX;
    M2 := BX;
    M3 := CX;
    M4 := DX
END Mouse;

PROCEDURE MouseInit;
VAR
    m1, m2, m3, m4 : CARDINAL;
BEGIN
    m1 := 0;
    m2 := 0;
    m3 := 0;
    m4 := 0;
    Mouse(m1, m2, m3, m4);
END MouseInit;

PROCEDURE MouseCursorOn;
VAR
    m1, m2, m3, m4 : CARDINAL;
BEGIN
    m1 := 1;
    m2 := 0;
    m3 := 0;
    m4 := 0;
    Mouse(m1, m2, m3, m4);
END MouseCursorOn;


END MouseControl.
