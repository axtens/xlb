IMPLEMENTATION MODULE HASH;

FROM SYSTEM
    IMPORT TSIZE;

FROM Storage
    IMPORT ALLOCATE, DEALLOCATE, Available;

FROM Strings
    IMPORT Assign, CompareStr, Length;

FROM ASSERT
    IMPORT Assert, ASSERT_ERRORS;

CONST
    HASHSIZE = 101;

VAR
    hashtab : ARRAY [0..HASHSIZE] OF pnList;

PROCEDURE hash( s : ARRAY OF CHAR) : INTEGER;
VAR
    cHashVal : CARDINAL;
    cPtr : CARDINAL;
    cLim : CARDINAL;

BEGIN
    cLim := Length(s);
    Assert( cLim # 0, "s in hash is null.", ASSERT_FATAL );
    cHashVal := 0;
    cPtr := 0;
    WHILE (cPtr < cLim) DO
        cHashVal := cHashVal + ORD(s[cPtr]);
        INC(cPtr)
    END;
    RETURN (cHashVal MOD HASHSIZE)
END hash;

PROCEDURE lookup( s : ARRAY OF CHAR) : pnList;
VAR
    pn : pnList;
BEGIN
    Assert( s[0] # 0C, "s in lookup is null.", ASSERT_FATAL );
    pn := hashtab[hash(s)];
    WHILE pn # NIL DO
        IF CompareStr( s, pn^.name) = 0 THEN
            RETURN pn
        END;
        pn := pn^.next
    END;
    RETURN NIL
END lookup;

PROCEDURE install( sName, sDefinition :ARRAY OF CHAR): pnList;
VAR
    pn : pnList;
    cHashVal : CARDINAL;
BEGIN
    Assert( sName[0] # 0C, "sName in install is null.", ASSERT_FATAL );
    Assert( sDefinition[0] # 0C, "sDefinition in install is null.", ASSERT_FATAL );
    pn := lookup( sName);
    IF pn = NIL THEN
        IF NOT Available( TSIZE( nList)) THEN
            RETURN NIL
        END;
        NEW( pn);
        Assign( sName, pn^.name);
        Assign(sDefinition, pn^.def);
        cHashVal := hash( pn^.name);
        pn^.next := hashtab[cHashVal];
        hashtab[cHashVal] := pn
    ELSE
        Assign(sDefinition, pn^.def);
    END;
    RETURN pn
END install;

PROCEDURE remove( sName : ARRAY OF CHAR) : BOOLEAN;
VAR
    pn : pnList;
    cHashVal : CARDINAL;
BEGIN
    Assert( sName[0] # 0C, "sName in remove is null.", ASSERT_FATAL );
    pn := lookup( sName);
    IF pn # NIL THEN
        cHashVal := hash( sName);
        hashtab[cHashVal] := NIL;
        DISPOSE(pn);
        RETURN TRUE
    ELSE
        RETURN FALSE
    END
END remove;
END HASH.


