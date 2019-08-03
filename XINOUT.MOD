IMPLEMENTATION MODULE XInOut;

FROM SYSTEM IMPORT SEGMENT, OFFSET (*, ASSEMBLER*);
FROM Strings IMPORT Concat, Copy, Length;
FROM System IMPORT AX, DX, BX, DS, XTrap, Trap;

PROCEDURE ReadChar( Echo : BOOLEAN):CHAR;
BEGIN
		IF Echo THEN
				AX := 0100H
		ELSE
				AX := 0700H
		END;
		Trap(21H);
		RETURN CHR( AX MOD 256)
END ReadChar;

PROCEDURE ReadLine( VAR S : ARRAY OF CHAR; Echo : BOOLEAN);
VAR
   cnt, lim : CARDINAL;
   chr		: CHAR;

BEGIN
	 cnt := 0;
	 lim := SIZE(S);
	 LOOP
		 chr := ReadChar(Echo);
		 IF (chr = 0DX) OR (cnt > lim) THEN
			EXIT
		 END;
		 S[cnt] := chr;
		 INC(cnt)
	 END
END ReadLine;

PROCEDURE InputLine( VAR S : ARRAY OF CHAR);
VAR
	c : CARDINAL;
BEGIN
		DX := OFFSET(S);
		S[0] := 0FFX;
		S[1] := 0X;
		AX := 0A00H;
		Trap(21H);
		Copy(S,2,ORD(S[1]),S);
END InputLine;

PROCEDURE WriteChar( C : CHAR);
BEGIN
		CASE WriteMode OF
				DOS :	AX := 0200H;
						DX := ORD(C);
						Trap(21H)
				|
				BIOS :	AX := 0E00H + ORD(C);
						BX := 0000H;
						Trap(10H)
		END;

END WriteChar;

PROCEDURE WriteString( P : ARRAY OF CHAR);
VAR
   K,I : CARDINAL;
   J : CHAR;
BEGIN
	 K := SIZE(P)-1;
	 FOR I := 0 TO K DO
		 J := P[I];
		 IF J=0X THEN
			I := K
		 ELSE
			WriteChar(P[I]);
		 END;
	 END;
END WriteString;

PROCEDURE WriteNL;
VAR
   X : ARRAY [0..1] OF CHAR;

BEGIN
	 X[0] := 0DX;
	 X[1] := 0AX;
	 WriteString(X)
END WriteNL;
PROCEDURE WriteRepeat( N : CARDINAL; S : ARRAY OF CHAR);
VAR I : CARDINAL;
BEGIN
	 FOR I := 1 TO N DO
		WriteString(S)
	 END
END WriteRepeat;
PROCEDURE Reverse(VAR S:ARRAY OF CHAR);
VAR
		C : CHAR;
		I, J : CARDINAL;
BEGIN
		I := 0;
		J := Length(S)-1;
		WHILE (I<J) DO
				C := S[I];
				S[I] := S[J];
				S[J] := C;
				INC(I);
				DEC(J)
		END;
END Reverse;
PROCEDURE WriteCard(C:CARDINAL;W:CARDINAL);
VAR I : CARDINAL;
	S : ARRAY [0..5] OF CHAR;
BEGIN
		I := 0;
		REPEAT
				S[I] := CHR( C MOD 10 + ORD("0"));
				INC(I);
				C := C DIV 10;
		UNTIL C <= 0;
		S[I] := 0X;
		Reverse(S);
		I := Length(S);
		IF W>I THEN
		   WriteRepeat(W-I," ")
		END;
		WriteString(S);

END WriteCard;
PROCEDURE WriteLongCard(L:LONGCARD;W:CARDINAL);
VAR I : CARDINAL;
	S : ARRAY [0..12] OF CHAR;
BEGIN
		I := 0;
		REPEAT
				S[I] := CHR( SHORT(L MOD 10L + LONG(ORD("0"))));
				INC(I);
				L := L DIV 10L;
		UNTIL L <= 0L;
		S[I] := 0X;
		Reverse(S);
		I := Length(S);
		IF W>I THEN
		   WriteRepeat(W-I," ")
		END;
		WriteString(S);

END WriteLongCard;
PROCEDURE WriteLine( S : ARRAY OF CHAR);
BEGIN
		WriteString(S);
		WriteNL
END WriteLine;
PROCEDURE WriteText( S : ARRAY OF CHAR);
VAR
		Of,SE : CARDINAL;
		NewS  : ARRAY [0..255] OF CHAR;
BEGIN
		Concat(S,"$",NewS);
		DS := SEGMENT(NewS);
		DX := OFFSET(NewS);
		XTrap(21H);
END WriteText;

BEGIN
		WriteMode := DOS
END XInOut.

