IMPLEMENTATION MODULE SLICE;

	FROM XString IMPORT IsWhite;
	FROM Strings IMPORT Assign, Copy, Pos, Length;
	FROM InOut IMPORT WriteString, WriteLine;

PROCEDURE Slice( VAR axSource, axSlice : ARRAY OF CHAR);
VAR c1,
	c2,
	cQuotNo:CARDINAL;
	xDelim : CHAR;
	axNULL : ARRAY [0..5] OF CHAR;
BEGIN
	 axNULL := '';
	 IF axSource[0] = 0X  THEN
		Assign(axNULL,axSlice);
		RETURN
	 END;
	 c1 := 0;
	 c2 := HIGH(axSource);
	 WHILE ( IsWhite(axSource[c1]) AND (c1<=c2) ) DO
		   INC(c1,1)
	 END;
	 Copy(axSource,c1,c2,axSource);
IF SliceDebug THEN
WriteString("axSource=");
WriteLine(axSource);
END;
	 cQuotNo := Pos(axSource[0],SliceOpenQuote);
	 IF cQuotNo<=HIGH(SliceOpenQuote) THEN
		  xDelim := SliceCloseQuote[cQuotNo];
		  Copy(axSource,1,c2,axSource);
IF SliceDebug THEN
WriteString("Quoting. axSource=");
WriteLine(axSource);
END;
		  c1 := Pos(xDelim,axSource);
		  IF c1 > HIGH(axSource) THEN
			   Assign(axNULL,axSlice);
IF SliceDebug THEN
WriteString("Quoting. axSlice=");
WriteLine(axSlice);
END;
		  ELSE
			  Copy(axSource,0,c1,axSlice);
			  Copy(axSource,c1+1,c2,axSource);
IF SliceDebug THEN
WriteString("Quoting. axSlice=");
WriteLine(axSlice);
WriteString("Quoting. axSource=");
WriteLine(axSource);
END;
		  END;
	  ELSE
		   c1 := Pos(' ',axSource);
		   IF c1 > HIGH(axSource) THEN
				c1 := Pos(9X,axSource);
		   END;
		   IF c1 > HIGH(axSource) THEN
				Assign(axSource,axSlice);
				Assign(axNULL,axSource);
IF SliceDebug THEN
WriteString("Not Quoting. axSlice=");
WriteLine(axSlice);
WriteString("Quoting. axSource=");
WriteLine(axSource);
END;
		   ELSE
				Copy(axSource,0,c1,axSlice);
				Copy(axSource,c1+1,c2,axSource);
IF SliceDebug THEN
WriteString("Not Quoting. axSlice=");
WriteLine(axSlice);
WriteString("Quoting. axSource=");
WriteLine(axSource);
END;
		   END;
	   END;
END Slice;
BEGIN
	 SliceOpenQuote[0] := 27X;
	 SliceOpenQuote[1] := '"';
	 SliceCloseQuote[0] := 27X;
	 SliceCloseQuote[1] := '"';
	 SliceDebug := FALSE;
END SLICE.
