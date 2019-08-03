IMPLEMENTATION MODULE StringCutter;
FROM Strings IMPORT Copy;

PROCEDURE Cutter( inS : ARRAY OF CHAR; Start, End : CARDINAL; VAR outS : ARRAY OF CHAR);
VAR
	i : CARDINAL;
BEGIN
     outS[0] := 0X;
     i := End-Start+1;
     Copy(inS,Start-1,i,outS)
END Cutter;
END StringCutter.
