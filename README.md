# utl_checkdigit
UTL_CHECKDIGIT provides Oracle PL/SQL functions for generating, appending, and
validating Luhn mod-N check digits in bases 1 through 36.

## Functions

- `quotient` returns the result of integer division of two numbers.
- `Gen_Luhn_Check_Char` returns the Luhn check character for an input value.
- `Append_Luhn_Check_Char` appends the generated Luhn check character to an
  input value.
- `Validate_Luhn_Check_Char` returns `TRUE` when the right-most character is a
  valid Luhn check character.
- `Luhn_Check_Char_is_Valid` returns `Y` when the right-most character is a
  valid Luhn check character, otherwise `N`.

## dbpm

This repository is packaged for dbpm with `dbpm.yaml`.

```sh
dbpm plan . --mode install
dbpm publish . --target gh-maven:512itconsulting/utl_checkdigit --dry-run --signing-key "$DBPM_SIGNING_KEY"
```

The package depends on dbpm Core 3.4.0 or newer so DBPM-provided deployment
provenance can be recorded during installation.
