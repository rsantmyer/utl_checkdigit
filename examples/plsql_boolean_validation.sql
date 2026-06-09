SET DEFINE OFF
SET SERVEROUTPUT ON

PROMPT PL/SQL BOOLEAN validation example

DECLARE
   l_value    VARCHAR2(30) := '79927398713';
   l_is_valid BOOLEAN;
BEGIN
   l_is_valid := utl_checkdigit.validate_luhn_check_char(l_value);

   IF l_is_valid THEN
      dbms_output.put_line(l_value || ' is valid.');
   ELSIF l_is_valid IS NULL THEN
      dbms_output.put_line(l_value || ' could not be validated.');
   ELSE
      dbms_output.put_line(l_value || ' is not valid.');
   END IF;
END;
/

PROMPT Done.
