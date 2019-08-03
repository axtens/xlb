IMPLEMENTATION MODULE NewLong;
PROCEDURE InitLONG( VAR L : LONGC);
BEGIN
        WITH L DO
                LO := 0;
                HI := 0
        END
END InitLONG;
PROCEDURE IncLONG( VAR L : LONGC);
BEGIN
     WITH L DO
          INC(LO);
          IF LO>=10000 THEN
             INC(HI);
             LO := 0
          END
     END
END IncLONG;
END NewLong.
