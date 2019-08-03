IMPLEMENTATION MODULE XAnsi;

FROM NumberConversion IMPORT CardToString;
FROM Strings IMPORT Length, Assign, Concat, Delete;
FROM XIO IMPORT DispString, DispChar, DispRepeat;

VAR
    escape : CHAR;

PROCEDURE MakeString( num : CARDINAL; VAR out : ARRAY OF CHAR);
BEGIN
     CardToString(num,out,3);
     WHILE out[0]=' ' DO
        Delete(out,0,1)
     END;
END MakeString;

PROCEDURE AnsiColour( colour : CARDINAL);
VAR
        colourcode : ARRAY [0..2] OF CHAR;
        temp : ARRAY [0..3] OF CHAR;
BEGIN
        MakeString(colour,colourcode);
        Assign(escape,temp);
        Concat(temp,'[',temp);
        Concat(temp,colourcode,temp);
        Concat(temp,'m',temp);
        DispString(temp)
END AnsiColour;

PROCEDURE AnsiLocate( row, col : CARDINAL);
VAR
        rowstr, colstr, temp : ARRAY [0..7] OF CHAR;
BEGIN
        MakeString(row,rowstr);
        MakeString(col,colstr);
        Assign(escape,temp);
        Concat(temp,'[',temp);
        Concat(temp,rowstr,temp);
        Concat(temp,';',temp);
        Concat(temp,colstr,temp);
        Concat(temp,'H',temp);
        DispString(temp)
END AnsiLocate;

PROCEDURE AnsiScreen( background, foreground : CARDINAL);
VAR
        backgroundstr, foregroundstr, temp : ARRAY [0..7] OF CHAR;
BEGIN
        MakeString(background,backgroundstr);
        MakeString(foreground,foregroundstr);
        Assign(escape,temp);
        Concat(temp,'[',temp);
        Concat(temp,backgroundstr,temp);
        Concat(temp,';',temp);
        Concat(temp,foregroundstr,temp);
        Concat(temp,'m',temp);
        DispString(temp)
END AnsiScreen;

PROCEDURE AnsiEraseDisplay;
VAR
   temp : ARRAY [0..3] OF CHAR;

BEGIN
     Assign(escape,temp);
     Concat(temp,'[2J',temp);
     DispString(temp)

END AnsiEraseDisplay;

PROCEDURE AnsiBox( startrow, startcol, height, width : CARDINAL);
VAR
        I : CARDINAL;
BEGIN
  AnsiLocate(startrow,startcol);
  DispChar(TOPLEFT);
  AnsiLocate(startrow,startcol+1);
  DispRepeat(width-1,LYINGDOWN);
  AnsiLocate(startrow,startcol+width);
  DispChar(TOPRIGHT);

  FOR I := 1 TO height-1 DO
     AnsiLocate(startrow+I,startcol);
     DispChar(UPRIGHT);
     AnsiLocate(startrow+I,startcol+width);
     DispChar(UPRIGHT);
  END;
  AnsiLocate(startrow+height,startcol);
  DispChar(BOTTOMLEFT);
  AnsiLocate(startrow+height,startcol+1);
  DispRepeat(width-1,LYINGDOWN);
  AnsiLocate(startrow+height,startcol+width);
  DispChar(BOTTOMRIGHT);
END AnsiBox;
PROCEDURE AnsiCentre( line : CARDINAL; s : ARRAY OF CHAR);
VAR
        place : CARDINAL;

BEGIN
        place := 40-( Length(s) DIV 2);
        AnsiLocate(line,place);
        DispString(s)

END AnsiCentre;

BEGIN
    escape := CHR(27)
END XAnsi.
