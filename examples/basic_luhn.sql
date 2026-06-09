SET DEFINE OFF
SET PAGESIZE 100
SET LINESIZE 160
SET SERVEROUTPUT ON

COLUMN input_value FORMAT A20
COLUMN check_char FORMAT A10
COLUMN appended_value FORMAT A20
COLUMN valid_yn FORMAT A8
COLUMN invalid_yn FORMAT A10

PROMPT Classic base-10 Luhn example
PROMPT Input 7992739871 should generate check digit 3.

SELECT '7992739871' AS input_value
     , utl_checkdigit.gen_luhn_check_char('7992739871') AS check_char
     , utl_checkdigit.append_luhn_check_char('7992739871') AS appended_value
     , utl_checkdigit.luhn_check_char_is_valid('79927398713') AS valid_yn
     , utl_checkdigit.luhn_check_char_is_valid('79927398714') AS invalid_yn
  FROM dual;

PROMPT Done.
