IMPLEMENTATION MODULE IS;

PROCEDURE IsLower( C : CHAR) : BOOLEAN;
BEGIN
     CASE C OF
          "a".."z" : RETURN TRUE
          ELSE RETURN FALSE
     END

END IsLower;
PROCEDURE IsUpper( C : CHAR) : BOOLEAN;
BEGIN
     CASE C OF
          "A".."Z" : RETURN TRUE
          ELSE RETURN FALSE
     END

END IsUpper;
PROCEDURE IsPunc( C : CHAR) : BOOLEAN;
BEGIN
     CASE C OF
          '"',"~","`","!","@","#","$","%","^","&","*","(",")",
          "_","-","+","=","{","[","}","]","|","\",":",";","'",
          "<",",",">",".","?","/" : RETURN TRUE
          ELSE RETURN FALSE
     END

END IsPunc;
PROCEDURE IsNumber( C : CHAR) : BOOLEAN;
BEGIN
     CASE C OF
          "0".."9" : RETURN TRUE
          ELSE RETURN FALSE
     END

END IsNumber;
PROCEDURE IsHighBit( C : CHAR) : BOOLEAN;
BEGIN
     IF ORD(C) > 127 THEN
          RETURN TRUE
     ELSE
          RETURN FALSE
     END

END IsHighBit;
PROCEDURE IsAlpha( C : CHAR) : BOOLEAN;
BEGIN
     CASE C OF
          "a".."z","A".."Z" : RETURN TRUE;
          ELSE RETURN FALSE
     END

END IsAlpha;
PROCEDURE IsWhite( C : CHAR) : BOOLEAN;
BEGIN
     IF ORD(C) < 33 THEN
        RETURN TRUE
     ELSE
         RETURN FALSE
     END

END IsWhite;
PROCEDURE IsControl( C : CHAR) : BOOLEAN;
BEGIN
     IF ORD(C) < 32 THEN
        RETURN TRUE
     ELSE
         RETURN FALSE
     END

END IsControl;
END IS.
