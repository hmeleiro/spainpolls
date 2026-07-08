internal_fields <- c(
  "row_hash",
  "poll_signature",
  "poll_key_strict",
  "raw_html",
  "raw_wikitext",
  "payload_json",
  "wiki_revision_id",
  "identity_confidence",
  "source_reference_ids",
  "source_metadata",
  "raw_value"
)

drop_internal_fields <- function(x) {
  x[, setdiff(names(x), internal_fields), drop = FALSE]
}

list_to_tibble <- function(items, schema) {
  if (length(items) == 0) {
    return(empty_schema_tibble(schema))
  }

  rows <- purrr::map(items, function(item) {
    item <- purrr::map(item, null_to_na)
    tibble::as_tibble_row(item)
  })
  out <- vctrs::vec_rbind(!!!rows)
  out <- drop_internal_fields(out)
  apply_schema(out, schema)
}

null_to_na <- function(x) {
  if (is.null(x)) NA else x
}

empty_schema_tibble <- function(schema) {
  cols <- purrr::imap(schema, function(type, name) {
    switch(type,
      integer = integer(),
      numeric = numeric(),
      logical = logical(),
      date = as.Date(character()),
      datetime = as.POSIXct(character(), tz = "UTC"),
      list = list(),
      character()
    )
  })
  tibble::as_tibble(cols)
}

apply_schema <- function(x, schema) {
  for (name in names(schema)) {
    if (!name %in% names(x)) {
      x[[name]] <- missing_column(schema[[name]], nrow(x))
    }
  }

  for (name in names(schema)) {
    x[[name]] <- coerce_column(x[[name]], schema[[name]])
  }

  dplyr::select(x, dplyr::all_of(names(schema)))
}

missing_column <- function(type, n) {
  switch(type,
    integer = rep(NA_integer_, n),
    numeric = rep(NA_real_, n),
    logical = rep(NA, n),
    date = as.Date(rep(NA_character_, n)),
    datetime = as.POSIXct(rep(NA_character_, n), tz = "UTC"),
    list = rep(list(NULL), n),
    rep(NA_character_, n)
  )
}

coerce_column <- function(x, type) {
  switch(type,
    integer = as.integer(x),
    numeric = as.numeric(x),
    logical = as.logical(x),
    date = as.Date(x),
    datetime = lubridate::as_datetime(x, tz = "UTC"),
    list = x,
    as.character(x)
  )
}

sort_spainpolls_tibble <- function(x, kind) {
  switch(kind,
    elections = dplyr::arrange(
      x,
      dplyr::desc(.data[["election_date"]]),
      .data[["election_key"]]
    ),
    pollsters = dplyr::arrange(
      x,
      dplyr::desc(.data[["poll_count"]]),
      .data[["pollster_name"]],
      .data[["pollster_key"]]
    ),
    parties = dplyr::arrange(
      x,
      dplyr::desc(.data[["poll_count"]]),
      .data[["party_key"]]
    ),
    polls = dplyr::arrange(
      x,
      dplyr::desc(.data[["fieldwork_end"]]),
      dplyr::desc(.data[["publication_date"]]),
      .data[["id"]]
    ),
    poll_results = dplyr::arrange(
      x,
      dplyr::desc(.data[["vote_share"]]),
      .data[["party_key"]]
    ),
    results = dplyr::arrange(
      x,
      dplyr::desc(.data[["date"]]),
      .data[["poll_id"]],
      dplyr::desc(.data[["vote_share"]]),
      .data[["party_key"]]
    ),
    timeseries = dplyr::arrange(
      x,
      dplyr::desc(.data[["date"]]),
      .data[["poll_id"]],
      dplyr::desc(.data[["vote_share"]]),
      .data[["party_key"]]
    ),
    x
  )
}

health_schema <- c(
  status = "character",
  service = "character",
  database = "character"
)

election_schema <- c(
  id = "integer",
  election_key = "character",
  election_type = "character",
  territory_code = "character",
  election_name = "character",
  election_date = "date"
)

pollster_schema <- c(
  id = "integer",
  pollster_key = "character",
  pollster_name = "character",
  poll_count = "integer"
)

party_schema <- c(
  party_key = "character",
  party_name = "character",
  short_name = "character",
  territory_code = "character",
  color_hex = "character",
  display_order = "integer",
  is_active = "logical",
  poll_count = "integer"
)

poll_summary_schema <- c(
  id = "integer",
  election_key = "character",
  election_name = "character",
  territory_code = "character",
  pollster_key = "character",
  pollster_name = "character",
  media = "character",
  fieldwork_start = "date",
  fieldwork_end = "date",
  publication_date = "date",
  sample_size = "integer",
  turnout = "numeric",
  lead = "numeric",
  source_url = "character",
  source_title = "character",
  identity_status = "character",
  first_seen_at = "datetime",
  is_active = "logical"
)

poll_result_schema <- c(
  party_key = "character",
  party_raw = "character",
  party_name = "character",
  short_name = "character",
  color_hex = "character",
  display_order = "integer",
  vote_share = "numeric",
  seats_min = "integer",
  seats_max = "integer"
)

result_long_schema <- c(
  party_key = "character",
  party_raw = "character",
  party_name = "character",
  short_name = "character",
  color_hex = "character",
  display_order = "integer",
  vote_share = "numeric",
  seats_min = "integer",
  seats_max = "integer",
  poll_id = "integer",
  date = "date",
  election_key = "character",
  pollster_key = "character",
  pollster_name = "character",
  media = "character",
  fieldwork_end = "date",
  publication_date = "date",
  sample_size = "integer"
)

timeseries_schema <- c(
  date = "date",
  poll_id = "integer",
  pollster_key = "character",
  pollster_name = "character",
  media = "character",
  sample_size = "integer",
  party_key = "character",
  party_raw = "character",
  party_name = "character",
  short_name = "character",
  color_hex = "character",
  display_order = "integer",
  vote_share = "numeric",
  seats_min = "integer",
  seats_max = "integer"
)
