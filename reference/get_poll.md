# Get one poll

Fetches one poll by numeric ID, including nested party results.

## Usage

``` r
get_poll(poll_id, include_manual_review = FALSE, include_inactive = FALSE)
```

## Arguments

- poll_id:

  Numeric poll ID.

- include_manual_review:

  Include polls in manual review.

- include_inactive:

  Include inactive polls.

## Value

A one-row tibble with a `results` list-column containing a tibble
ordered by descending `vote_share`.

## Examples

``` r
if (interactive()) {
  get_poll(101)
}
```
