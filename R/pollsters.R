#' Get pollsters
#'
#' Lists pollsters and matching poll counts.
#'
#' @param election_key Optional stable election key.
#' @param territory_code Optional territory code filter.
#' @param active_only If `TRUE`, count only active, non-manual-review polls.
#' @param limit Number of rows to request. Must be between 1 and 1000.
#' @param offset Zero-based row offset.
#' @param collect_all If `TRUE`, collect all pages starting at offset 0.
#'
#' @return A tibble with one row per pollster, ordered by descending
#'   `poll_count`, then `pollster_name` and `pollster_key`.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   get_pollsters(election_key = "congreso_espana_2027")
#' }
get_pollsters <- function(election_key = NULL,
                          territory_code = NULL,
                          active_only = TRUE,
                          limit = 100,
                          offset = 0,
                          collect_all = FALSE) {
  validate_scalar_logical(active_only)
  validate_scalar_logical(collect_all)
  query <- list(
    election_key = election_key,
    territory_code = territory_code,
    active_only = active_only,
    limit = limit,
    offset = offset
  )
  fetch_paginated("pollsters", query, pollster_schema, collect_all = collect_all, sort = "pollsters")
}
