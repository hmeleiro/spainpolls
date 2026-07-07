#' Get poll results
#'
#' Returns poll results in long format, with one row per poll and party.
#'
#' @param election_key Optional stable election key.
#' @param territory_code Optional territory code filter.
#' @param pollster_key Optional stable pollster key.
#' @param pollster Optional pollster key or exact pollster name.
#' @param media Optional media substring filter.
#' @param party_key Optional stable party key.
#' @param party Optional alias for `party_key`.
#' @param fieldwork_end_from,fieldwork_end_to Fieldwork end date filters.
#' @param publication_date_from,publication_date_to Publication date filters.
#' @param include_manual_review Include polls in manual review.
#' @param include_inactive Include inactive polls.
#' @param limit Number of rows to request. Must be between 1 and 1000.
#' @param offset Zero-based row offset.
#' @param collect_all If `TRUE`, collect all pages starting at offset 0.
#'
#' @return A tibble with one row per poll-party result, ordered by descending
#'   `date`, `poll_id`, descending `vote_share`, and then `party_key`.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   get_results(election_key = "congreso_espana_2027", party = "psoe")
#' }
get_results <- function(election_key = NULL,
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
                        collect_all = FALSE) {
  validate_scalar_logical(include_manual_review)
  validate_scalar_logical(include_inactive)
  validate_scalar_logical(collect_all)
  query <- list(
    election_key = election_key,
    territory_code = territory_code,
    pollster_key = pollster_key,
    pollster = pollster,
    media = media,
    party_key = party_key,
    party = party,
    fieldwork_end_from = fieldwork_end_from,
    fieldwork_end_to = fieldwork_end_to,
    publication_date_from = publication_date_from,
    publication_date_to = publication_date_to,
    include_manual_review = include_manual_review,
    include_inactive = include_inactive,
    limit = limit,
    offset = offset
  )
  query <- validate_query_dates(
    query,
    c("fieldwork_end_from", "fieldwork_end_to", "publication_date_from", "publication_date_to")
  )
  fetch_paginated("results", query, result_long_schema, collect_all = collect_all, sort = "results")
}
