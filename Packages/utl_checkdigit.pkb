CREATE OR REPLACE PACKAGE BODY utl_checkdigit
AS

--integer division
FUNCTION quotient(ip_dividend IN INTEGER, ip_divisor IN INTEGER)
   RETURN INTEGER
IS
BEGIN
   RETURN FLOOR(ip_dividend / ip_divisor);
END;



FUNCTION CodePointFromCharacter(ip_character IN VARCHAR2)
   RETURN INTEGER
   DETERMINISTIC
IS
BEGIN
   RETURN 
   CASE UPPER(ip_character)
      WHEN '0' THEN 0
      WHEN '1' THEN 1
      WHEN '2' THEN 2
      WHEN '3' THEN 3
      WHEN '4' THEN 4
      WHEN '5' THEN 5
      WHEN '6' THEN 6
      WHEN '7' THEN 7
      WHEN '8' THEN 8
      WHEN '9' THEN 9
      WHEN 'A' THEN 10
      WHEN 'B' THEN 11
      WHEN 'C' THEN 12
      WHEN 'D' THEN 13
      WHEN 'E' THEN 14
      WHEN 'F' THEN 15
      WHEN 'G' THEN 16
      WHEN 'H' THEN 17
      WHEN 'I' THEN 18
      WHEN 'J' THEN 19
      WHEN 'K' THEN 20
      WHEN 'L' THEN 21
      WHEN 'M' THEN 22
      WHEN 'N' THEN 23
      WHEN 'O' THEN 24
      WHEN 'P' THEN 25
      WHEN 'Q' THEN 26
      WHEN 'R' THEN 27
      WHEN 'S' THEN 28
      WHEN 'T' THEN 29
      WHEN 'U' THEN 30
      WHEN 'V' THEN 31
      WHEN 'W' THEN 32
      WHEN 'X' THEN 33
      WHEN 'Y' THEN 34
      WHEN 'Z' THEN 35
   END;
END CodePointFromCharacter;



FUNCTION CharacterFromCodePoint(ip_codepoint IN INTEGER)
   RETURN VARCHAR2
   DETERMINISTIC
IS
BEGIN
   RETURN
   CASE ip_codepoint
      WHEN 0  THEN '0'
      WHEN 1  THEN '1'
      WHEN 2  THEN '2'
      WHEN 3  THEN '3'
      WHEN 4  THEN '4'
      WHEN 5  THEN '5'
      WHEN 6  THEN '6'
      WHEN 7  THEN '7'
      WHEN 8  THEN '8'
      WHEN 9  THEN '9'
      WHEN 10 THEN 'A'
      WHEN 11 THEN 'B'
      WHEN 12 THEN 'C'
      WHEN 13 THEN 'D'
      WHEN 14 THEN 'E'
      WHEN 15 THEN 'F'
      WHEN 16 THEN 'G'
      WHEN 17 THEN 'H'
      WHEN 18 THEN 'I'
      WHEN 19 THEN 'J'
      WHEN 20 THEN 'K'
      WHEN 21 THEN 'L'
      WHEN 22 THEN 'M'
      WHEN 23 THEN 'N'
      WHEN 24 THEN 'O'
      WHEN 25 THEN 'P'
      WHEN 26 THEN 'Q'
      WHEN 27 THEN 'R'
      WHEN 28 THEN 'S'
      WHEN 29 THEN 'T'
      WHEN 30 THEN 'U'
      WHEN 31 THEN 'V'
      WHEN 32 THEN 'W'
      WHEN 33 THEN 'X'
      WHEN 34 THEN 'Y'
      WHEN 35 THEN 'Z'
   END;
END CharacterFromCodePoint;


--https://en.wikipedia.org/wiki/Luhn_mod_N_algorithm
FUNCTION Gen_Luhn_Check_Char( ip_input IN VARCHAR2
                            , radix    IN INTEGER DEFAULT 10)
   RETURN VARCHAR2 DETERMINISTIC PARALLEL_ENABLE
IS
   l_factor INTEGER := 2;
   l_sum    INTEGER := 0;
   --
   l_codepoint INTEGER;
   l_addend    INTEGER;
   l_remainder INTEGER;
   l_checkCodePoint INTEGER;
BEGIN
   assert(    radix >= 1 
          AND radix <= 36, 'radix must be greater than or equal to 1 and less than or equal to 36');
   
   IF ip_input IS NULL THEN
      RETURN NULL;
   END IF;
   
   --Starting from the right and working leftwards is easier since 
   --the initial "factor" will always be "2".
   FOR l_position IN REVERSE 1..LENGTH(ip_input)
   LOOP
      l_codepoint := CodePointFromCharacter( SUBSTR(ip_input, l_position, 1) );
      l_addend := l_factor * l_codepoint;

      -- Alternate the "factor" that each "codePoint" is multiplied by
      l_factor := CASE WHEN l_factor = 1 THEN 2 ELSE 1 END;

      -- Sum the digits of the "addend" as expressed in base "n"
      l_addend := FLOOR(l_addend / radix) + MOD(l_addend, radix);
      l_sum := l_sum + l_addend;
   END LOOP;

   -- Calculate the number that must be added to the "sum" 
   -- to make it divisible by "n".
   l_remainder := MOD(l_sum, radix);
   l_checkCodePoint := MOD( (radix - l_remainder), radix);

    RETURN CharacterFromCodePoint(l_checkCodePoint);
END Gen_Luhn_Check_Char;



FUNCTION Append_Luhn_Check_Char( ip_input IN VARCHAR2
                               , radix    IN INTEGER DEFAULT 10 )
   RETURN VARCHAR2 DETERMINISTIC PARALLEL_ENABLE
IS
BEGIN
   RETURN ip_input||Gen_Luhn_Check_Char( ip_input, radix );
END Append_Luhn_Check_Char;



FUNCTION Validate_Luhn_Check_Char( ip_input IN VARCHAR2
                                 , radix    IN INTEGER DEFAULT 10 )
   RETURN BOOLEAN DETERMINISTIC PARALLEL_ENABLE
IS
   l_factor INTEGER := 1;
   l_sum    INTEGER := 0;
   --
   l_codepoint INTEGER;
   l_addend    INTEGER;
   l_remainder INTEGER;
   l_checkCodePoint INTEGER;
BEGIN
   assert(    radix >= 1 
          AND radix <= 36, 'radix must be greater than or equal to 1 and less than or equal to 36');
   
   IF ip_input IS NULL THEN
      RETURN NULL;
   END IF;

   -- Starting from the right, work leftwards
   -- Now, the initial "factor" will always be "1" 
   -- since the last character is the check character.
   FOR l_position IN REVERSE 1..LENGTH(ip_input)
   LOOP
      l_codepoint := CodePointFromCharacter( SUBSTR(ip_input, l_position, 1) );
      l_addend := l_factor * l_codepoint;

       -- Alternate the "factor" that each "codePoint" is multiplied by
       l_factor := CASE WHEN l_factor = 1 THEN 2 ELSE 1 END;

       -- Sum the digits of the "addend" as expressed in base "n"
       l_addend := FLOOR(l_addend / radix) + MOD(l_addend, radix);
       l_sum := l_sum + l_addend;
   END LOOP;

   l_remainder := MOD(l_sum, radix);

   RETURN l_remainder = 0;
END Validate_Luhn_Check_Char;



FUNCTION Luhn_Check_Char_is_Valid( ip_input IN VARCHAR2
                                 , radix    IN INTEGER DEFAULT 10 )
   RETURN VARCHAR2 DETERMINISTIC PARALLEL_ENABLE
IS
BEGIN
   --Not sure why, but the commented out version always returns "Y"
   --RETURN CASE WHEN Validate_Luhn_Check_Char(ip_input, radix) IS NULL THEN NULL WHEN FALSE THEN 'N' ELSE 'Y' END;
   RETURN CASE WHEN Validate_Luhn_Check_Char(ip_input, radix) = TRUE THEN 'Y' ELSE 'N' END;
END Luhn_Check_Char_is_Valid;

END utl_checkdigit;
/
