# Get poll time series

Returns party vote-share points over time.

## Usage

``` r
get_timeseries(
  election_key = NULL,
  territory_code = NULL,
  party_key = NULL,
  party = NULL,
  pollster_key = NULL,
  pollster = NULL,
  media = NULL,
  date_from = NULL,
  date_to = NULL,
  date_field = c("auto", "fieldwork_end", "publication_date"),
  include_manual_review = FALSE,
  include_inactive = FALSE,
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

- party_key:

  Optional stable party key.

- party:

  Optional alias for `party_key`.

- pollster_key:

  Optional stable pollster key.

- pollster:

  Optional pollster key or exact pollster name.

- media:

  Optional media substring filter.

- date_from, date_to:

  Date range filters.

- date_field:

  Date source used by the API: `"auto"`, `"fieldwork_end"`, or
  `"publication_date"`.

- include_manual_review:

  Include polls in manual review.

- include_inactive:

  Include inactive polls.

- limit:

  Number of rows to request. Must be between 1 and 1000.

- offset:

  Zero-based row offset.

- collect_all:

  If `TRUE`, collect all pages starting at offset 0.

## Value

A tibble with one row per time-series point, ordered by descending
`date`, `poll_id`, descending `vote_share`, and then `party_key`.

## Examples

``` r
if (interactive()) {
  get_timeseries(election_key = "congreso_espana_2026", party = "psoe")
}
```
