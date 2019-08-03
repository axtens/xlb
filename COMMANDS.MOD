IMPLEMENTATION MODULE Commands;
    FROM Files IMPORT Close, Open, READ;
    FROM Strings IMPORT Assign, CompareStr;
    FROM XString IMPORT RightTrim, YesNo;
    FROM Dictionary IMPORT DictInsert, DictRetrieve;
    FROM SHELL IMPORT Shell;
    FROM System IMPORT Terminate;
    FROM InOut IMPORT ReadLine, WriteLine, Read, WriteString;
    FROM Dictionary IMPORT DictSave, DictLoad;
    FROM NumberConversion IMPORT StringToInt;

    TYPE
        tCommand = RECORD
                    name : ARRAY [0..15] OF CHAR;
                    proc : PROCEDURE() : BOOLEAN;
                   END;
        StdString = ARRAY [0..254] OF CHAR;
    VAR
        aCommands : ARRAY [1..20] OF tCommand;
        nMaxCommands : CARDINAL;

    PROCEDURE Crash() : BOOLEAN;
    BEGIN
        WriteLine("CRASH!!");
        RETURN TRUE
    END Crash;

    PROCEDURE SaveDictionary() : BOOLEAN;
    VAR
        cTemp1 : StdString;
    BEGIN
        DictRetrieve("$P1", cTemp1);
        RightTrim( cTemp1);
        DictSave( cTemp1);
        RETURN TRUE
    END SaveDictionary;

    PROCEDURE LoadDictionary() : BOOLEAN;
    VAR
        cTemp1 : StdString;
    BEGIN
        DictRetrieve("$P1", cTemp1);
        RightTrim( cTemp1);
        DictLoad( cTemp1);
        RETURN TRUE
    END LoadDictionary;


    PROCEDURE Define( ) : BOOLEAN;
    VAR
        cTemp1,
        cTemp2 : StdString;
    BEGIN
        DictRetrieve("$P1",cTemp1);
        RightTrim(cTemp1);
        DictRetrieve("$P2",cTemp2);
        (*RightTrim(cTemp2);*)
        DictInsert(cTemp1,cTemp2);
        RETURN TRUE

    END Define;
    PROCEDURE XYesNo( ) : BOOLEAN;
    VAR
        cTemp1,
        cTemp2,
        cTemp3 : StdString;
        lFlag  : BOOLEAN;

    BEGIN
        DictRetrieve("$P1",cTemp1);
        (*RightTrim(cTemp1);*)
        lFlag:=YesNo( cTemp1);
        DictRetrieve("$P2",cTemp1);
        DictRetrieve("$P3",cTemp2);
        RightTrim(cTemp1);
        RightTrim(cTemp2);
        IF cTemp1[0] = 0X THEN
            IF NOT lFlag THEN
                cTemp3 := '2'
            ELSE
                cTemp3 := '1'
            END
        ELSE
            IF cTemp2[0] = 0X THEN
                IF NOT lFlag THEN
                    Assign(cTemp1,cTemp3)
                ELSE
                    cTemp3 := '1'
                END
            ELSE
                IF NOT lFlag THEN
                    Assign(cTemp2,cTemp3)
                ELSE
                    Assign(cTemp1,cTemp3)
                END
            END
        END;
        IF lFlag THEN
            DictInsert("$YESNO","YES")
        ELSE
            DictInsert("$YESNO","NO")
        END;
        DictInsert("$INCR",cTemp3);
        RETURN TRUE

    END XYesNo;


    PROCEDURE OnError( ) : BOOLEAN;
    VAR
        cTemp1,
        cTemp2 : StdString;
        lFlag : BOOLEAN;
    BEGIN
        DictRetrieve("$P1",cTemp1);
        RightTrim(cTemp1);
        IF CompareStr(cTemp1,"FAIL")=0 THEN
            DictInsert("$ONERROR","FAIL")
        ELSE
            DictInsert("$ONERROR","PASS")
        END;
        RETURN TRUE
    END OnError;

    PROCEDURE End() : BOOLEAN;
    BEGIN
        Terminate(0);
        RETURN TRUE
    END End;


    PROCEDURE Require() : BOOLEAN;
    VAR
        nBuf : INTEGER;
        lFlag: BOOLEAN;
        cTemp: ARRAY [0..65] OF CHAR;

    BEGIN
        DictRetrieve("$P1",cTemp);
        Open(nBuf,cTemp,READ);
        IF nBuf = -1 THEN
            DictInsert("$ERP","REQUIRE");
            DictInsert("$ERM","File not found.");
            DictInsert("$ERI",cTemp);
            lFlag := FALSE
        ELSE
            Close(nBuf);
            lFlag := TRUE
        END;
        RETURN lFlag
    END Require;

    PROCEDURE GetLine() : BOOLEAN;
    VAR
        cTemp,
        cSym : StdString;
    BEGIN
        DictRetrieve("$P1",cSym);
        DictRetrieve("$P2",cTemp);
        (*RightTrim(cTemp);*)
        WriteString(cTemp);
        ReadLine(cTemp);
        WriteLine("");
        DictInsert(cSym,cTemp);
        RETURN TRUE
    END GetLine;

    PROCEDURE GetKey() : BOOLEAN;
    VAR
        cKeyTemp : CHAR;
        cTemp,
        cSym : StdString;
    BEGIN
        DictRetrieve("$P1",cSym);
        DictRetrieve("$P2",cTemp);
        (*RightTrim(cTemp);*)
        WriteString(cTemp);
        Read(cKeyTemp);
        WriteLine(cKeyTemp);
        DictInsert(cSym,cKeyTemp);
        RETURN TRUE
    END GetKey;

    PROCEDURE Execute( ) : BOOLEAN;
    VAR
        cTemp : StdString;
        n : CARDINAL;
    BEGIN
        DictRetrieve("$CMDTAIL",cTemp);
        RETURN Shell(cTemp,n);
    END Execute;

    PROCEDURE Skip() : BOOLEAN;
        VAR
            cTemp : StdString;
            i     : INTEGER;
            l     : BOOLEAN;
        BEGIN
            DictRetrieve("$P1", cTemp);
            DictInsert("$INCR",cTemp);
            StringToInt(cTemp,i,l);
            IF NOT l THEN
                DictInsert("$ERP","SKIP");
                DictInsert("$ERM","Parameter does not resolve to an integer");
                DictInsert("$ERI",cTemp);
                RETURN FALSE
            ELSE
                RETURN TRUE
            END;
        END Skip;

    PROCEDURE Process( ) : CARDINAL;
    VAR
        n : CARDINAL;
        cSearch,
        cKnown : ARRAY [0..15] OF CHAR;
        pTemp  : PROCEDURE():BOOLEAN;
        nResult: CARDINAL;
        lFlag,
        lResponse  : BOOLEAN;

    BEGIN
        DictRetrieve("$CMDNAME",cSearch);
        RightTrim(cSearch);

        pTemp := Crash;
        nResult := 0;
        n := 1;
        lFlag := FALSE;
        LOOP
            Assign(aCommands[n].name,cKnown);
            RightTrim(cKnown);
            IF CompareStr(cSearch,cKnown)=0 THEN
                pTemp := aCommands[n].proc;
                lFlag := TRUE;
            END;
            IF lFlag THEN
                lResponse := pTemp();
                IF lResponse THEN
                    nResult := 0
                ELSE
                    nResult := 1
                END;
                EXIT
            ELSE
                INC(n);
                IF n > nMaxCommands THEN
                    nResult := 0FFFFH;
                    EXIT
                END;

            END;
        END;

        RETURN nResult

    END Process;


BEGIN
    aCommands[1].name := '*END';
    aCommands[1].proc := End;
    aCommands[2].name := '*REQUIRE';
    aCommands[2].proc := Require;
    aCommands[3].name := '*GETLINE';
    aCommands[3].proc := GetLine;
    aCommands[4].name := '*EXECUTE';
    aCommands[4].proc := Execute;
    aCommands[5].name := '*DEFINE';
    aCommands[5].proc := Define;
    aCommands[6].name := '*GETKEY';
    aCommands[6].proc := GetKey;
    aCommands[7].name := '*YESNO';
    aCommands[7].proc := XYesNo;
    aCommands[8].name := '*ONERROR';
    aCommands[8].proc := OnError;
    aCommands[9].name := '*SAVEDICT';
    aCommands[9].proc := SaveDictionary;
    aCommands[10].name := '*LOADDICT';
    aCommands[10].proc := LoadDictionary;
    aCommands[11].name := '*SKIP';
    aCommands[11].proc := Skip;

    nMaxCommands := 11;

END Commands.

