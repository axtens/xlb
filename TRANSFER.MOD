IMPLEMENTATION MODULE TRANSFER;

FROM XIO IMPORT DispNL, DispLine, DispString;
FROM Files IMPORT Open, Create, Close,
                  Read, Write, READ, WRITE, Delete, Seek, SeekMode;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;
FROM Rotor IMPORT ResetRotor, DoRotor;
FROM Bar IMPORT InitBar, DisplayBar, DisplayFullBar, UpdateBar;
FROM ASSERT IMPORT Assert, ASSERT_ERRORS;

PROCEDURE Transfer( sourcefile,
                    destfile : ARRAY OF CHAR;
                    method : progressType) : BOOLEAN;
CONST
     FileError = -1;
     longcardwidth = 7;
     arraysize = 1024*60;
TYPE
        TransferBuffer = ARRAY [0..arraysize] OF CHAR;
        pTransferBuffer = POINTER TO TransferBuffer;
VAR
   fdin, fdout : INTEGER;
   Buffer : pTransferBuffer;
   bytesin,
   bytesout   : CARDINAL;
   filelength,
   tmp  : LONGCARD;

BEGIN
     Assert( sourcefile[0] # 0C, "sourcefile is null in Transfer", ASSERT_FATAL );
     Assert( destfile[0] # 0C, "destfile is null in Transfer", ASSERT_FATAL );
     NEW(Buffer);
     Open(fdin,sourcefile,READ);
     IF fdin=FileError THEN
        DispString("Could not open ");
        DispString(sourcefile);
        DispNL;
        RETURN FALSE
     END;
     Create(fdout,destfile,WRITE);
     IF fdout = FileError THEN
        DispString("Could not open ");
        DispString(destfile);
        DispNL;
        RETURN FALSE
     END;
     CASE method OF
             nothing : ;
             |
             percentage : ;
             |
             rotor : ResetRotor;
             |
             bar : filelength := 0L;
                   Seek(fdin,SEEKEND,filelength);
                   tmp := 0L;
                   Seek(fdin,SEEKABS,tmp);
                   InitBar(70,filelength);
                   DisplayBar;
     END;
     LOOP
        Read(fdin,Buffer,arraysize,bytesin);
        IF bytesin=0 THEN
           EXIT
        END;
        Write(fdout,Buffer,bytesin,bytesout);
        CASE method OF
                nothing : ;
                |
                percentage : ;
                |
                rotor : DoRotor;
                |
                bar : UpdateBar(bytesout);
        END;

        IF bytesout < bytesin THEN
           DispNL;
           DispString("Could not write to ");
           DispString(destfile);
           DispString(". Disk might be full. Deleting destination file.");
           DispNL;
           Close(fdin);
           Close(fdout);
           Delete(destfile);
           RETURN FALSE;
        END;
     END;
     Close(fdin);
     Close(fdout);
     DISPOSE(Buffer);
     RETURN TRUE;

END Transfer;
END TRANSFER.

