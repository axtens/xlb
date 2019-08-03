IMPLEMENTATION MODULE ASSERT;

FROM InOut IMPORT WriteLine;
FROM System IMPORT Terminate;

VAR
    AssertFlag : BOOLEAN;

PROCEDURE Assert(
                bAssertTest : BOOLEAN;
                sAssertFailMessage : ARRAY OF CHAR;
                eAssertErrorFlag : ASSERT_ERRORS
                );
    BEGIN
        IF AssertFlag THEN
            IF NOT bAssertTest THEN
                WriteLine( sAssertFailMessage );
                IF eAssertErrorFlag = ASSERT_FATAL THEN
                    Terminate( 255 )
                END
            END;
        END;
    END Assert;

    PROCEDURE AssertionsOn();
    BEGIN
        AssertFlag := TRUE;
    END AssertionsOn;

    PROCEDURE AssertionsOff();
    BEGIN
        AssertFlag := FALSE;
    END AssertionsOff;
BEGIN
    AssertionsOn();
END ASSERT.
