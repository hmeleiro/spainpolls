# Get parties

Lists the canonical party catalogue with public poll counts.

## Usage

``` r
get_parties(
  election_key = NULL,
  territory_code = NULL,
  active_only = TRUE,
  limit = 100,
  offset = 0,
  collect_all = FALSE
)
```

## Arguments

- election_key:

  Optional stable election key.

- territory_code:

  Optional territory code filter.

- active_only:

  If `TRUE`, return active catalogue parties.

- limit:

  Number of rows to request. Must be between 1 and 1000.

- offset:

  Zero-based row offset.

- collect_all:

  If `TRUE`, collect all pages starting at offset 0.

## Value

A tibble with one row per party, including display fields useful for
analysis and plots: `short_name`, `color_hex`, and `display_order`.

## Examples

``` r
if (interactive()) {
  get_parties(election_key = "congreso_espana_2026")
}
```
