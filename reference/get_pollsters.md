# Get pollsters

Lists pollsters and matching poll counts.

## Usage

``` r
get_pollsters(
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

  If `TRUE`, count only active, non-manual-review polls.

- limit:

  Number of rows to request. Must be between 1 and 1000.

- offset:

  Zero-based row offset.

- collect_all:

  If `TRUE`, collect all pages starting at offset 0.

## Value

A tibble with one row per pollster, ordered by descending `poll_count`,
then `pollster_name` and `pollster_key`.

## Examples

``` r
if (interactive()) {
  get_pollsters(election_key = "congreso_espana_2026")
}
```
