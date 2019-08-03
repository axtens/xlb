IMPLEMENTATION MODULE Dictionary;
    FROM Strings IMPORT Copy, Assign, CompareStr, Insert, Length, Delete, Pos;
    FROM InOut IMPORT WriteString, WriteLine, WriteCard, RedirectOutput,
                        ReadLine, CloseOutput, RedirectInput, CloseInput, Done;
    FROM XString IMPORT RightTrim;

    CONST DEFINER = 0;
          DEFINIT = 1;
          SYMLEN  = 10;
          DEFLEN  = 127;

    TYPE aDictType = RECORD
                        Symbol : ARRAY [0..SYMLEN] OF CHAR;
                        Definition : ARRAY [0..DEFLEN] OF CHAR;
                     END;
        StdString = ARRAY [0..127] OF CHAR;

    VAR
        aDict  : ARRAY [1..100] OF aDictType;
        lDictDebug : BOOLEAN;


    PROCEDURE SetDictDebug( lFlag : BOOLEAN);
    BEGIN
        lDictDebug := lFlag
    END SetDictDebug;

    PROCEDURE DictGet( n : CARDINAL; VAR cSym, cDef : ARRAY OF CHAR);
    BEGIN
        Assign( aDict[n].Symbol, cSym);
        Assign( aDict[n].Definition, cDef);
        IF lDictDebug THEN
            WriteString("DictGet [");
            WriteCard(n,3);
            WriteString(": ");
            WriteString(cSym);
            WriteString("=");
            WriteLine(cDef)
        END;
    END DictGet;

    PROCEDURE DictCreate();
    VAR n : CARDINAL;
    BEGIN
        FOR n := 1 TO nDictSize DO
            aDict[n].Symbol := '';
            aDict[n].Definition := ''
        END;
        nDictUsed := 0;
    END DictCreate;


    PROCEDURE DictInsert( cSym, cDef : ARRAY OF CHAR);
    VAR nTemp : CARDINAL;
        lFlag : BOOLEAN;

    BEGIN
        IF lDictDebug THEN
            WriteString("DictInsert: ");
            WriteString(cSym);
            WriteString("=");
            WriteLine(cDef)
        END;
        IF nDictUsed = 0 THEN
            Assign(cSym,aDict[1].Symbol);
            Assign(cDef,aDict[1].Definition);
            nDictUsed := 1
        ELSE
            lFlag := FALSE;
            FOR nTemp := 1 TO nDictUsed DO
                IF CompareStr(aDict[nTemp].Symbol,cSym)=0 THEN
                    Assign(cDef,aDict[nTemp].Definition);
                    lFlag := TRUE
                END
            END;
            IF NOT lFlag THEN
                INC(nDictUsed);
                Assign(cSym,aDict[nDictUsed].Symbol);
                Assign(cDef,aDict[nDictUsed].Definition)
            END
        END
    END DictInsert;



    PROCEDURE DictRetrieve( cSym : ARRAY OF CHAR; VAR cDef : ARRAY OF CHAR);
    VAR nTemp : CARDINAL;
        lFlag : BOOLEAN;
    BEGIN
        IF nDictUsed = 0 THEN
            cDef[0] := 0X;
        ELSE
            lFlag := FALSE;
            FOR nTemp := 1 TO nDictUsed DO
                IF CompareStr(aDict[nTemp].Symbol,cSym)=0 THEN
                    Assign(aDict[nTemp].Definition,cDef);
                    lFlag := TRUE
                END
            END;
            IF NOT lFlag THEN
                cDef[0] := 0X
            END;
        END;
        IF lDictDebug THEN
            WriteString("DictRetrieve: ");
            WriteString(cSym);
            WriteString("=");
            WriteLine(cDef)
        END;
    END DictRetrieve;


    PROCEDURE DictSubst( VAR cString : ARRAY OF CHAR; nSwaps : CARDINAL);
        VAR
            cSym,
            cDef : StdString;
            i2,
            n    : CARDINAL;
            lSwapped : BOOLEAN;
        PROCEDURE Substitute() : BOOLEAN;
            VAR
                lSwap : BOOLEAN;
                i     : CARDINAL;
            BEGIN
                lSwap := FALSE;
                FOR i := 1 TO nDictUsed DO
                    DictGet( i, cSym, cDef);
                    (*RightTrim(cDef);*)
                    RightTrim(cSym);
                    n := Pos(cSym, cString);
                    IF n <= HIGH( cString) THEN
                        lSwap := TRUE;
                        IF lDictDebug THEN
                            WriteString("Swapping out ");
                            WriteString(cSym);
                            WriteString(" and swapping in ");
                            WriteLine(cDef);
                        END;
                        Delete( cString, n, Length( cSym));
                        Insert( cDef, cString, n);
                        n := Pos( cSym, cString)
                    END;
                END;
                RETURN lSwap
            END Substitute;

        BEGIN
            LOOP
                lSwapped := Substitute();
                DEC(nSwaps);
                IF nSwaps = 0 THEN EXIT END;
                IF NOT lSwapped THEN EXIT END;
            END;

        END DictSubst;

    PROCEDURE DictSave( cFileName : ARRAY OF CHAR);
        VAR
            n : CARDINAL;
            cSym,
            cDef : StdString;
        BEGIN
            RedirectOutput(cFileName);
            FOR n := 1 TO nDictUsed DO
                DictGet( n, cSym, cDef);
                WriteString(cSym);
                WriteString("=");
                WriteLine(cDef);
            END;
            CloseOutput;
        END DictSave;

    PROCEDURE DictLoad( cFileName : ARRAY OF CHAR);
        VAR
            cTemp1,
            cSym,
            cDef : StdString;
            n      : CARDINAL;
        BEGIN
            RedirectInput( cFileName);
            IF NOT Done THEN
                DictInsert("$ERP","DictLoad");
                DictInsert("$ERM","File not found.");
                DictInsert("$ERI",cFileName);
                RETURN
            END;
            LOOP (*WHILE Done DO*)
                ReadLine( cTemp1);
                IF (NOT Done) OR (cTemp1[0]=0C) THEN
                    EXIT
                END;
                n := Pos( "=", cTemp1);
                IF n <= HIGH( cTemp1) THEN
                    Copy( cTemp1, 0, n, cSym);
                    Copy( cTemp1, n+1, 127, cDef);
                    IF lDictDebug THEN
                        WriteString("DictLoad: cSym=");
                        WriteLine(cSym);
                        WriteString("DictLoad: cDef=");
                        WriteLine(cDef)
                    END;
                    DictInsert(cSym, cDef);
                END
            END;
        END DictLoad;



BEGIN
    lDictDebug := FALSE
END Dictionary.
