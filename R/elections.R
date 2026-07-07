#' Get elections
#'
#' Lists elections known by the Spain Electoral Polls API.
#'
#' @param territory_code Optional territory code filter, for example `"ES"`.
#' @param election_type Optional election type filter, for example `"general"`.
#' @param limit Number of rows to request. Must be between 1 and 1000.
#' @param offset Zero-based row offset.
#' @param collect_all If `TRUE`, collect all pages starting at offset 0.
#'
#' @return A tibble with one row per election, ordered by descending
#'   `election_date` and then `election_key`.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   get_elections(limit = 10)
#' }
get_elections <- function(territory_code = NULL,
                          election_type = NULL,
                          limit = 100,
                          offset = 0,
                          collect_all = FALSE) {
  validate_scalar_logical(collect_all)
  query <- list(
    territory_code = territory_code,
    election_type = election_type,
    limit = limit,
    offset = offset
  )
  fetch_paginated("elections", query, election_schema, collect_all = collect_all, sort = "elections")
}
