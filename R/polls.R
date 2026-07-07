#' Get polls
#'
#' Lists polls with poll-level metadata.
#'
#' @param election_key Optional stable election key.
#' @param territory_code Optional territory code filter.
#' @param pollster_key Optional stable pollster key.
#' @param pollster Optional pollster key or exact pollster name.
#' @param media Optional media substring filter.
#' @param fieldwork_start_from,fieldwork_start_to Fieldwork start date filters.
#' @param fieldwork_end_from,fieldwork_end_to Fieldwork end date filters.
#' @param publication_date_from,publication_date_to Publication date filters.
#' @param identity_status Optional identity status filter.
#' @param include_manual_review Include polls in manual review.
#' @param include_inactive Include inactive polls.
#' @param limit Number of rows to request. Must be between 1 and 1000.
#' @param offset Zero-based row offset.
#' @param collect_all If `TRUE`, collect all pages starting at offset 0.
#'
#' @return A tibble with one row per poll, ordered by descending
#'   `fieldwork_end`, descending `publication_date`, and then `id`.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   get_polls(election_key = "congreso_espana_2027", limit = 10)
#' }
get_polls <- function(election_key = NULL,
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
    fieldwork_start_from = fieldwork_start_from,
    fieldwork_start_to = fieldwork_start_to,
    fieldwork_end_from = fieldwork_end_from,
    fieldwork_end_to = fieldwork_end_to,
    publication_date_from = publication_date_from,
    publication_date_to = publication_date_to,
    identity_status = identity_status,
    include_manual_review = include_manual_review,
    include_inactive = include_inactive,
    limit = limit,
    offset = offset
  )
  query <- validate_query_dates(
    query,
    c(
      "fieldwork_start_from",
      "fieldwork_start_to",
      "fieldwork_end_from",
      "fieldwork_end_to",
      "publication_date_from",
      "publication_date_to"
    )
  )
  fetch_paginated("polls", query, poll_summary_schema, collect_all = collect_all, sort = "polls")
}

#' Get one poll
#'
#' Fetches one poll by numeric ID, including nested party results.
#'
#' @param poll_id Numeric poll ID.
#' @param include_manual_review Include polls in manual review.
#' @param include_inactive Include inactive polls.
#'
#' @return A one-row tibble with a `results` list-column containing a tibble
#'   ordered by descending `vote_share`.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   get_poll(101)
#' }
get_poll <- function(poll_id,
                     include_manual_review = FALSE,
                     include_inactive = FALSE) {
  poll_id <- validate_poll_id(poll_id)
  validate_scalar_logical(include_manual_review)
  validate_scalar_logical(include_inactive)

  x <- spainpolls_get(
    paste0("polls/", poll_id),
    query = list(
      include_manual_review = include_manual_review,
      include_inactive = include_inactive
    )
  )

  results <- sort_spainpolls_tibble(
    list_to_tibble(x$results %||% list(), poll_result_schema),
    "poll_results"
  )
  x$results <- NULL
  poll <- list_to_tibble(list(x), poll_summary_schema)
  poll$results <- list(results)
  poll
}

#' Get results for one poll
#'
#' Returns the nested result rows for a single poll. The API does not expose a
#' separate `/polls/{poll_id}/results` route, so this helper reads the `results`
#' field from `get_poll()`.
#'
#' @inheritParams get_poll
#'
#' @return A tibble with one row per party result, ordered by descending
#'   `vote_share`.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   get_poll_results(101)
#' }
get_poll_results <- function(poll_id,
                             include_manual_review = FALSE,
                             include_inactive = FALSE) {
  poll <- get_poll(
    poll_id,
    include_manual_review = include_manual_review,
    include_inactive = include_inactive
  )
  poll$results[[1]]
}
