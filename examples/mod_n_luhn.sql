SET DEFINE OFF
SET PAGESIZE 100
SET LINESIZE 180

COLUMN input_value FORMAT A20
COLUMN radix FORMAT 99999
COLUMN check_char FORMAT A10
COLUMN appended_value FORMAT A30
COLUMN valid_yn FORMAT A8

PROMPT Luhn mod-N examples

WITH samples AS
   ( SELECT '7992739871' AS input_value, 10 AS radix FROM dual
     UNION ALL
     SELECT 'A12F' AS input_value, 16 AS radix FROM dual
     UNION ALL
     SELECT 'HELLO2026' AS input_value, 36 AS radix FROM dual
   )
SELECT input_value
     , radix
     , utl_checkdigit.gen_luhn_check_char(input_value, radix) AS check_char
     , utl_checkdigit.append_luhn_check_char(input_value, radix) AS appended_value
     , utl_checkdigit.luhn_check_char_is_valid
          ( utl_checkdigit.append_luhn_check_char(input_value, radix)
          , radix
          ) AS valid_yn
  FROM samples
 ORDER BY radix, input_value;

PROMPT Done.
