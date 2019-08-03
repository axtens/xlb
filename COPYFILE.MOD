IMPLEMENTATION MODULE COPYFILE;

FROM Files IMPORT Open, Create, Close,
                  Read, Write, READ, WRITE, Delete;
FROM Storage IMPORT ALLOCATE, DEALLOCATE;

PROCEDURE CopyFile( sourcefile,
                    destfile : ARRAY OF CHAR) : ResponseCode;
CONST
     FileError = -1;
     arraysize = 1024*60;
TYPE
        CopyFileBuffer = ARRAY [0..arraysize] OF CHAR;
        pCopyFileBuffer = POINTER TO CopyFileBuffer;
VAR
   fdin, fdout : INTEGER;
   Buffer : pCopyFileBuffer;
   bytesin,
   bytesout   : CARDINAL;

BEGIN
     Open(fdin,sourcefile,READ);
     IF fdin=FileError THEN
        RETURN FileNotFound
     END;
     Create(fdout,destfile,WRITE);
     IF fdout = FileError THEN
        RETURN CantOpenTarget
     END;
     NEW(Buffer);
     LOOP
        Read(fdin,Buffer,arraysize,bytesin);
        IF bytesin=0 THEN
           EXIT
        END;
        Write(fdout,Buffer,bytesin,bytesout);
        
        IF bytesout < bytesin THEN
           Close(fdin);
           Close(fdout);
           Delete(destfile);
           DISPOSE(Buffer);
           RETURN CantWriteTarget
        END;
     END;
     Close(fdin);
     Close(fdout);
     DISPOSE(Buffer);
     RETURN Successful

END CopyFile;
END COPYFILE.


