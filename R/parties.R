#' Get parties
#'
#' Lists the canonical party catalogue with public poll counts.
#'
#' @param election_key Optional stable election key.
#' @param territory_code Optional territory code filter.
#' @param active_only If `TRUE`, return active catalogue parties.
#' @param limit Number of rows to request. Must be between 1 and 1000.
#' @param offset Zero-based row offset.
#' @param collect_all If `TRUE`, collect all pages starting at offset 0.
#'
#' @return A tibble with one row per party, including display fields useful for
#'   analysis and plots: `short_name`, `color_hex`, and `display_order`.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   get_parties(election_key = "congreso_espana_2027")
#' }
get_parties <- function(election_key = NULL,
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
  fetch_paginated("parties", query, party_schema, collect_all = collect_all, sort = "parties")
}
