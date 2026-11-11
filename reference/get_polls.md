# Get polls

Lists polls with poll-level metadata.

## Usage

``` r
get_polls(
  election_key = NULL,
  territory_code = NULL,
  pollster_key = NULL,
  pollster = NULL,
  media = NULL,
  fieldwork_start_from = NULL,
  fieldwork_start_to = NULL,
  fieldwork_end_from = NULL,
  fieldwork_end_to = NULL,
  publication_date_from = NULL,
  publication_date_to = NULL,
  identity_status = NULL,
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

- fieldwork_start_from, fieldwork_start_to:

  Fieldwork start date filters.

- fieldwork_end_from, fieldwork_end_to:

  Fieldwork end date filters.

- publication_date_from, publication_date_to:

  Publication date filters.

- identity_status:

  Optional identity status filter.

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

A tibble with one row per poll, ordered by descending `fieldwork_end`,
descending `publication_date`, and then `id`.

## Examples

``` r
if (interactive()) {
  get_polls(election_key = "congreso_espana_2026", limit = 10)
}
```
