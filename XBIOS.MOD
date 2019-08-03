IMPLEMENTATION MODULE XBios;

FROM SYSTEM IMPORT ASSEMBLER, OFFSET, SEGMENT;
FROM BitOperators IMPORT shl;
FROM System IMPORT AX, CX, DX, BX, ES, BP, XTrap, Trap;
FROM Strings IMPORT Length;

PROCEDURE SetVideoMode( Mode : CARDINAL);
BEGIN
        AX := Mode;
        Trap(10H)
END SetVideoMode;

PROCEDURE GetVideoMode(VAR ColumnsOnScreen, VideoMode, ActiveDisplayPage:CARDINAL);
BEGIN
        AX := 0F00H;
        Trap(10H);
        ColumnsOnScreen := AX DIV 256;
        VideoMode := AX MOD 256;
        ActiveDisplayPage := BX DIV 256
END GetVideoMode;

PROCEDURE SetCursorSize( StartLine, BlinkAttr, EndLine : CARDINAL);
VAR
        Col, Vid, Pag : CARDINAL;
        Tmp : CHAR;
BEGIN
        GetVideoMode( Col, Vid, Pag);
        CX := ( shl( BlinkAttr,5)+StartLine) * 256 +EndLine;
        AX := 0100H + Vid;
        Trap(10H);
END SetCursorSize;
PROCEDURE SetCursorPosition( Row, Col, Page:CARDINAL);
BEGIN
        AX := 0200H;
        DX := Row*256+Col;
        BX := Page*256;
        Trap(10H);
END SetCursorPosition;
PROCEDURE GetCursorPosition( Page : CARDINAL; VAR Row, Col, StartLine, EndLine:CARDINAL);
BEGIN
        AX := 0300H;
        BX := Page*256;
        Trap(10H);
        Row := DX DIV 256;
        Col := DX MOD 256;
        StartLine := CX DIV 256;
        EndLine := CX MOD 256;
END GetCursorPosition;

PROCEDURE SelectDisplayPage( Page : CARDINAL);
BEGIN
        AX := 0500H + Page;
        Trap(10H);
END SelectDisplayPage;

PROCEDURE WriteString(Mode, Attrib, Page, Row, Col : CARDINAL; Text : ARRAY OF CHAR);
VAR
        seg, ofs, len : CARDINAL;
BEGIN
        seg := SEGMENT(Text);
        ofs := OFFSET(Text);
        len := Length(Text);
        ASM
                PUSH    BP
                PUSH    ES
                MOV     AH,13H
                MOV     AL,Mode
                MOV     BH,Page
                MOV     BL,Attrib
                MOV     DH,Row
                MOV     DL,Col
                MOV     CX,len
                MOV     BP,ofs
                PUSH    AX
                MOV     AX,seg
                MOV     ES,AX
                POP     AX
                INT     10H
                POP     ES
                POP     BP
        END;
        (*
        AX := 1300H + Mode;
        BX := Page*256+Attrib;
        DX := Row*256+Col;
        ES := SEGMENT(Text);
        BP := OFFSET(Text);
        CX := Length(Text);
        XTrap(10H)
        *)
END WriteString;

PROCEDURE TTYWrite( Char : CHAR; DispPage, ForeColour : CARDINAL);
BEGIN
        AX := 0E00H + ORD(Char);
        BX := DispPage*256+ForeColour;
        Trap(10H)

END TTYWrite;

PROCEDURE WriteCharacters( Char : CHAR; Page,Colour,ReplicCount : CARDINAL);
BEGIN
        AX := 0A00H + ORD(Char);
        BX := Page*256+Colour;
        CX := ReplicCount;
        Trap(10H)

END WriteCharacters;

BEGIN

END XBios.

