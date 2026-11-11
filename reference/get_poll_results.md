# Get results for one poll

Returns the nested result rows for a single poll. The API does not
expose a separate `/polls/{poll_id}/results` route, so this helper reads
the `results` field from
[`get_poll()`](https://spainelectoralproject.github.io/spainpolls/reference/get_poll.md).

## Usage

``` r
get_poll_results(
  poll_id,
  include_manual_review = FALSE,
  include_inactive = FALSE
)
```

## Arguments

- poll_id:

  Numeric poll ID.

- include_manual_review:

  Include polls in manual review.

- include_inactive:

  Include inactive polls.

## Value

A tibble with one row per party result, ordered by descending
`vote_share`.

## Examples

``` r
if (interactive()) {
  get_poll_results(101)
}
```
