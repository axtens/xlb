IMPLEMENTATION MODULE PORTS;

FROM SYSTEM IMPORT ASSEMBLER;

PROCEDURE InB( PortNumber : CARDINAL) : CHAR;
VAR     X : CHAR;
BEGIN
        ASM
                MOV     DX,PortNumber
                IN      AX,DX
                MOV     X,AL
        END;
        RETURN X
END InB;

PROCEDURE InW( PortNumber : CARDINAL) : CARDINAL;
VAR     X : CARDINAL;
BEGIN
        ASM
                MOV     DX,PortNumber
                IN      AX,DX
                MOV     X,AX
        END;
        RETURN X
END InW;


PROCEDURE OutB( PortNumber : CARDINAL; Value : CHAR);
BEGIN
        ASM
                MOV     DX,PortNumber
                MOV     AL,Value
                OUT     DX,AL
        END
END OutB;

PROCEDURE OutW( PortNumber, Value : CARDINAL);
BEGIN
        ASM
                MOV     DX,PortNumber
                MOV     AX,Value
                OUT     DX,AX
        END
END OutW;

END PORTS.


