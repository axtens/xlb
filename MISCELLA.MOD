IMPLEMENTATION MODULE Miscellaneous;

FROM Strings IMPORT Length, Delete;

PROCEDURE AlphaOnly( VAR Src : ARRAY OF CHAR);
VAR
	I,N : CARDINAL;
BEGIN
	N := Length(Src);
	I := 0;
	WHILE I<N DO
		CASE Src[I] OF
		'A'..'Z','a'..'z' : INC(I);
		ELSE 	Delete(Src,I,1);
			N := Length(Src)
		END;
END;
END AlphaOnly;
PROCEDURE NumberOnly( VAR Src : ARRAY OF CHAR);
VAR
	I,N : CARDINAL;
BEGIN
	N := Length(Src);
	I := 0;
	WHILE I<N DO
		CASE Src[I] OF
		'0'..'9' : INC(I);
		ELSE 	Delete(Src,I,1);
			    N := Length(Src)
		END;
END;
END NumberOnly;
END Miscellaneous.
