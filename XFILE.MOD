IMPLEMENTATION MODULE XFile;

FROM ASCII IMPORT EOL;
FROM FileSystem IMPORT File, WriteChar, ReadChar;
FROM Strings IMPORT Concat;

PROCEDURE WriteStringToFile( VAR OutBuffer : File; OutString : ARRAY OF CHAR; cr : BOOLEAN);
VAR cnt : CARDINAL;
BEGIN
     cnt := 0;
     LOOP
         IF ( (cnt > HIGH(OutString)) OR (OutString[cnt] = 0X) ) THEN
            EXIT
         END;
         WriteChar(OutBuffer,OutString[cnt]);
         INC(cnt,1);
     END;
     IF cr THEN
        WriteChar(OutBuffer,EOL)
     END;

END WriteStringToFile;

PROCEDURE ReadStringFromFile( VAR InBuffer : File; VAR InString : ARRAY OF CHAR; VAR TotalRead : CARDINAL);
VAR cnt : CARDINAL;
    chr : CHAR;
    lim : CARDINAL;
BEGIN

     lim := SIZE(InString);
     cnt := 0;
     InString[0] := 0X;
     LOOP
         ReadChar(InBuffer,chr);
         IF InBuffer.eof THEN
                EXIT
         END;
         IF chr = EOL THEN
            INC(cnt,1);
            EXIT
         END;
         Concat(InString,chr,InString);
         INC(cnt,1);
         IF cnt >= lim THEN
            EXIT
         END
     END;
     InString[cnt] := 0X;
     TotalRead := cnt;
END ReadStringFromFile;
END XFile.
