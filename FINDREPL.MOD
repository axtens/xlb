IMPLEMENTATION MODULE FINDREPL;

FROM Strings IMPORT Assign, Length, Insert, Delete, Pos;

PROCEDURE FindRepl( cString, cFind, cRepl : ARRAY OF CHAR;
                       VAR cResult : ARRAY OF CHAR );

VAR
   iPos : CARDINAL;

BEGIN
   Assign( cString, cResult );
   iPos := Pos( cFind, cString );
   IF iPos > Length( cString ) THEN
      RETURN
   END;
   Delete( cResult, iPos, Length( cFind ) );
   Insert( cRepl, cResult, iPos );
END FindRepl;




END FINDREPL.
