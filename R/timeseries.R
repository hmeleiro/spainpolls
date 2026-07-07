#' Get poll time series
#'
#' Returns party vote-share points over time.
#'
#' @param election_key Optional stable election key.
#' @param territory_code Optional territory code filter.
#' @param party_key Optional stable party key.
#' @param party Optional alias for `party_key`.
#' @param pollster_key Optional stable pollster key.
#' @param pollster Optional pollster key or exact pollster name.
#' @param media Optional media substring filter.
#' @param date_from,date_to Date range filters.
#' @param date_field Date source used by the API: `"auto"`, `"fieldwork_end"`,
#'   or `"publication_date"`.
#' @param include_manual_review Include polls in manual review.
#' @param include_inactive Include inactive polls.
#' @param limit Number of rows to request. Must be between 1 and 1000.
#' @param offset Zero-based row offset.
#' @param collect_all If `TRUE`, collect all pages starting at offset 0.
#'
#' @return A tibble with one row per time-series point, ordered by descending
#'   `date`, `poll_id`, descending `vote_share`, and then `party_key`.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   get_timeseries(election_key = "congreso_espana_2027", party = "psoe")
#' }
get_timeseries <- function(election_key = NULL,
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
                           collect_all = FALSE) {
  date_field <- validate_date_field(date_field)
  validate_scalar_logical(include_manual_review)
  validate_scalar_logical(include_inactive)
  validate_scalar_logical(collect_all)
  query <- list(
    election_key = election_key,
    territory_code = territory_code,
    party_key = party_key,
    party = party,
    pollster_key = pollster_key,
    pollster = pollster,
    media = media,
    date_from = date_from,
    date_to = date_to,
    date_field = date_field,
    include_manual_review = include_manual_review,
    include_inactive = include_inactive,
    limit = limit,
    offset = offset
  )
  query <- validate_query_dates(query, c("date_from", "date_to"))
  fetch_paginated("timeseries", query, timeseries_schema, collect_all = collect_all, sort = "timeseries")
}
