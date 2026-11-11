# Get poll results

Returns poll results in long format, with one row per poll and party.

## Usage

``` r
get_results(
  election_key = NULL,
  territory_code = NULL,
  pollster_key = NULL,
  pollster = NULL,
  media = NULL,
  party_key = NULL,
  party = NULL,
  fieldwork_end_from = NULL,
  fieldwork_end_to = NULL,
  publication_date_from = NULL,
  publication_date_to = NULL,
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

- pollster_key:

  Optional stable pollster key.

- pollster:

  Optional pollster key or exact pollster name.

- media:

  Optional media substring filter.

- party_key:

  Optional stable party key.

- party:

  Optional alias for `party_key`.

- fieldwork_end_from, fieldwork_end_to:

  Fieldwork end date filters.

- publication_date_from, publication_date_to:

  Publication date filters.

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

A tibble with one row per poll-party result, ordered by descending
`date`, `poll_id`, descending `vote_share`, and then `party_key`.

## Examples

``` r
if (interactive()) {
  get_results(election_key = "congreso_espana_2026", party = "psoe")
}
```
