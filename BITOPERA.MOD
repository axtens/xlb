IMPLEMENTATION MODULE BitOperators;
FROM SYSTEM IMPORT ASSEMBLER;
PROCEDURE shr(data : CARDINAL; cnt : CARDINAL) : CARDINAL;
BEGIN
        ASM
                MOV     CX,cnt
                MOV     DX,data
                SHR     DX,CL
                MOV     data,DX
        END;
        RETURN data
END shr;

PROCEDURE shl(data : CARDINAL; cnt : CARDINAL) : CARDINAL;
BEGIN
        ASM
                MOV     CX,cnt
                MOV     DX,data
                SHL     DX,CL
                MOV     data,DX
        END;
        RETURN data
END shl;

PROCEDURE sar(data : CARDINAL; cnt : CARDINAL) : CARDINAL;
BEGIN
        ASM
                MOV     CX,cnt
                MOV     DX,data
                SAR     DX,CL
                MOV     data,DX
        END;
        RETURN data
END sar;

PROCEDURE sal(data : CARDINAL; cnt : CARDINAL) : CARDINAL;
BEGIN
        ASM
                MOV     CX,cnt
                MOV     DX,data
                SAL     DX,CL
                MOV     data,DX
        END;
        RETURN data
END sal;

PROCEDURE rcr(data : CARDINAL; cnt : CARDINAL) : CARDINAL;
BEGIN
        ASM
                MOV     CX,cnt
                MOV     DX,data
                RCR     DX,CL
                MOV     data,DX
        END;
        RETURN data
END rcr;

PROCEDURE rcl(data : CARDINAL; cnt : CARDINAL) : CARDINAL;
BEGIN
        ASM
                MOV     CX,cnt
                MOV     DX,data
                RCL     DX,CL
                MOV     data,DX
        END;
        RETURN data
END rcl;

PROCEDURE ror(data : CARDINAL; cnt : CARDINAL) : CARDINAL;
BEGIN
        ASM
                MOV     CX,cnt
                MOV     DX,data
                ROR     DX,CL
                MOV     data,DX
        END;
        RETURN data
END ror;

PROCEDURE rol(data : CARDINAL; cnt : CARDINAL) : CARDINAL;
BEGIN
        ASM
                MOV     CX,cnt
                MOV     DX,data
                ROL     DX,CL
                MOV     data,DX
        END;
        RETURN data
END rol;

PROCEDURE and( data : CARDINAL; value : CARDINAL) : CARDINAL;
BEGIN
        ASM
                MOV     CX,value
                MOV     DX,data
                AND     DX,CX
                MOV     data,DX
        END;
        RETURN data
END and;

PROCEDURE or( data : CARDINAL; value : CARDINAL) : CARDINAL;
BEGIN
        ASM
                MOV     CX,value
                MOV     DX,data
                OR      DX,CX
                MOV     data,DX
        END;
        RETURN data
END or;

PROCEDURE xor( data : CARDINAL; value : CARDINAL) : CARDINAL;
BEGIN
        ASM
                MOV     CX,value
                MOV     DX,data
                XOR     DX,CX
                MOV     data,DX
        END;
        RETURN data
END xor;

PROCEDURE not( data : CARDINAL) : CARDINAL;
BEGIN
        ASM
                MOV     DX,data
                NOT     DX
                MOV     data,DX
        END;
        RETURN data
END not;

PROCEDURE test( data, offset : CARDINAL) : BOOLEAN;
VAR
        F : CARDINAL;
BEGIN
        ASM
                MOV     DX,data
                MOV     AX,offset
                TEST    DX,AX
                JNZ     istrue
                MOV     @F,0
                JMP     end
        istrue: MOV     @F,1
        end:

        END;

        RETURN (F=1)

END test;

END BitOperators.


