IMPLEMENTATION MODULE Rotor;

FROM DevIO IMPORT CharOut;
FROM Strings IMPORT Assign, Length;
FROM ASSERT IMPORT Assert, ASSERT_ERRORS;

CONST
        BS = 8X;
VAR
        rotornum : CARDINAL;
        RotorChars : ARRAY [0..19] OF CHAR;

PROCEDURE ResetRotor;
BEGIN
        rotornum := 0
END ResetRotor;

PROCEDURE DoRotor;
BEGIN
        INC(rotornum);
        IF rotornum > ( Length( RotorChars ) - 1 ) THEN
                rotornum := 0
        END;
        CharOut(RotorChars[rotornum]);
        CharOut(BS);

END DoRotor;

PROCEDURE SetRotorChars( sRotors : ARRAY OF CHAR );
BEGIN
    Assert( sRotors[0] # 0C, "sRotors in SetRotorChars is null.", ASSERT_FATAL );
    Assign( sRotors, RotorChars );
END SetRotorChars;

BEGIN
        rotornum := 0;
        RotorChars := "|/-\";

END Rotor.

