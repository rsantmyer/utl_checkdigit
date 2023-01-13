CREATE OR REPLACE PACKAGE utl_checkdigit
AS
--
FUNCTION quotient(ip_dividend IN INTEGER, ip_divisor IN INTEGER)
   RETURN INTEGER;

FUNCTION Gen_Luhn_Check_Char( ip_input IN VARCHAR2
                            , radix    IN INTEGER DEFAULT 10 )
   RETURN VARCHAR2 DETERMINISTIC PARALLEL_ENABLE;

FUNCTION Append_Luhn_Check_Char( ip_input IN VARCHAR2
                               , radix    IN INTEGER DEFAULT 10 )
   RETURN VARCHAR2 DETERMINISTIC PARALLEL_ENABLE;

FUNCTION Validate_Luhn_Check_Char( ip_input IN VARCHAR2
                                 , radix    IN INTEGER DEFAULT 10 )
   RETURN BOOLEAN DETERMINISTIC PARALLEL_ENABLE;

FUNCTION Luhn_Check_Char_is_Valid( ip_input IN VARCHAR2
                                 , radix    IN INTEGER DEFAULT 10 )
   RETURN VARCHAR2 DETERMINISTIC PARALLEL_ENABLE;
--
END utl_checkdigit;
/