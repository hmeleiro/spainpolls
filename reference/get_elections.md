# Get elections

Lists elections known by the Spain Electoral Polls API.

## Usage

``` r
get_elections(
  territory_code = NULL,
  election_type = NULL,
  limit = 100,
  offset = 0,
  collect_all = FALSE
)
```

## Arguments

- territory_code:

  Optional territory code filter, for example `"ES"`.

- election_type:

  Optional election type filter, for example `"general"`.

- limit:

  Number of rows to request. Must be between 1 and 1000.

- offset:

  Zero-based row offset.

- collect_all:

  If `TRUE`, collect all pages starting at offset 0.

## Value

A tibble with one row per election, ordered by descending
`election_date` and then `election_key`.

## Examples

``` r
if (interactive()) {
  get_elections(limit = 10)
}
```
