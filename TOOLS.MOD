IMPLEMENTATION MODULE Tools;

FROM System IMPORT Terminate, AX, Trap, Move;
FROM SYSTEM IMPORT ADDRESS, SEG, OFS, ADR;
FROM Strings IMPORT Length, Copy;
FROM ASSERT IMPORT Assert, ASSERT_ERRORS;

PROCEDURE KeyScan():CARDINAL;
BEGIN
     AX := 0;
     Trap(22);
     RETURN AX;
END KeyScan;

PROCEDURE ShiftStatus() : CHAR;
BEGIN
        AX := 2;
        Trap(16H);
        RETURN CHR( AX MOD 256)

END ShiftStatus;

PROCEDURE MemAt( Segment, Offset : CARDINAL) : CARDINAL;
VAR
   p : POINTER TO CARDINAL;

BEGIN
     p.SEG := Segment;
     p.OFS := Offset;
     RETURN p^
END MemAt;

PROCEDURE KEYBOARD( S : ARRAY OF CHAR);
VAR
   pKeyboard    : ADDRESS;
   sCommand     : ARRAY [0..14] OF CHAR;
   cCounter,
   cLength      : CARDINAL;
   xCmdLen      : CHAR;
BEGIN
     Assert( S[0] # 0C, "S in KEYBOARD is null.", ASSERT_FATAL );
     xCmdLen := CHR(30);
     Copy(S,0,15,sCommand);
     cLength := Length(sCommand);
     pKeyboard.SEG := 0;
     pKeyboard.OFS := 1050;
     Move(ADR(xCmdLen),pKeyboard,1);
     INC(pKeyboard,2);
     xCmdLen := CHR(30+cLength*2);
     Move(ADR(xCmdLen),pKeyboard,1);
     FOR cCounter := 1 TO cLength DO
         INC(pKeyboard,2);
         Move(ADR(sCommand[cCounter-1]),pKeyboard,1)
     END

END KEYBOARD;

PROCEDURE STOP();
BEGIN
     Terminate(0)
END STOP;

PROCEDURE TwoBytesToCard( One, Two : CARDINAL) : CARDINAL;
BEGIN
        RETURN (One*256+Two)
END TwoBytesToCard;


END Tools.

