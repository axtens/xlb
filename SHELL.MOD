IMPLEMENTATION MODULE SHELL;

FROM System IMPORT GetEnv;
FROM Strings IMPORT Append;
FROM Loader IMPORT Execute;

PROCEDURE Shell( sCmd : ARRAY OF CHAR; VAR cReturnCode : CARDINAL) : BOOLEAN;
VAR
        sPath : ARRAY [0..126] OF CHAR;
        sParam : ARRAY [0..126] OF CHAR;
        bFound : BOOLEAN;
        cRetCode  : CARDINAL;
BEGIN
    GetEnv("COMSPEC",sPath);
    sParam := "/c ";
    Append(sParam, sCmd);
    Execute(sPath,sParam,cRetCode);
    cReturnCode := cRetCode;
    IF cRetCode < 32768 THEN
        RETURN FALSE
    ELSE
        RETURN TRUE
    END;

END Shell;
END SHELL.

