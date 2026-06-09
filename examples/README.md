# UTL_CHECKDIGIT Examples

These examples assume `UTL_CHECKDIGIT` is installed in the connected schema.

Run an example with SQLcl or SQL*Plus:

```sh
sql -name dev_database @examples/basic_luhn.sql
```

## Files

- `basic_luhn.sql` demonstrates the classic base-10 Luhn example.
- `mod_n_luhn.sql` demonstrates Luhn mod-N check characters for multiple bases.
- `plsql_boolean_validation.sql` demonstrates the PL/SQL-only `BOOLEAN`
  validation function.
