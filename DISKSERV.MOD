IMPLEMENTATION MODULE DiskServices;
FROM System IMPORT AX,BX,CX,DX,Trap;
FROM BitOperators IMPORT and;
PROCEDURE GetDiskFreeSpace( drive : ARRAY OF CHAR;
                                VAR SectorsPerCluster,
                                    AvailableClusters,
                                    BytesPerSector,
                                    ClustersPerDrive : CARDINAL);
BEGIN
        AX := 3600H;
       DX := and(ORD(drive[0]),31);
       Trap(21H);
        SectorsPerCluster := AX;
        AvailableClusters := BX;
        BytesPerSector    := CX;
        ClustersPerDrive  := DX
END GetDiskFreeSpace;

PROCEDURE CalcAllocations( SizeOfFile : LONGCARD; BytesPerCluster : CARDINAL): CARDINAL;
VAR
        div, mod : CARDINAL;
BEGIN
        div := SHORT(SizeOfFile DIV LONG(BytesPerCluster));
        mod := SHORT(SizeOfFile MOD LONG(BytesPerCluster));
        IF mod > 0 THEN
                INC(div)
        END;
        RETURN div
END CalcAllocations;

END DiskServices.
