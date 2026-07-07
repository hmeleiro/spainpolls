api_prefix <- "/api/v1"
default_timeout_seconds <- 30

#' Check API health
#'
#' Calls the public `/health` endpoint and returns the service status.
#'
#' @return A one-row tibble with `status`, `service`, and `database`.
#' @export
#'
#' @examples
#' if (interactive()) {
#'   spainpolls_health()
#' }
spainpolls_health <- function() {
  x <- spainpolls_get("/health")
  list_to_tibble(list(x), health_schema)
}

spainpolls_get <- function(path, query = list()) {
  request_fn <- getOption("spainpolls.request_fn")
  if (is.function(request_fn)) {
    return(request_fn(path, query))
  }

  spainpolls_request(path, query = query)
}

spainpolls_request <- function(path, query = list()) {
  if (!rlang::is_string(path) || !nzchar(path)) {
    cli::cli_abort("{.arg path} must be a non-empty string.")
  }
  if (!is.list(query)) {
    cli::cli_abort("{.arg query} must be a list.")
  }

  base_url <- spainpolls_api_url()
  url <- spainpolls_build_url(base_url, path)
  query <- clean_query(query)

  req <- httr2::request(url) |>
    httr2::req_timeout(default_timeout_seconds) |>
    httr2::req_user_agent(spainpolls_user_agent())

  if (length(query) > 0) {
    req <- do.call(httr2::req_url_query, c(list(req), query, list(.multi = "explode")))
  }

  resp <- tryCatch(
    httr2::req_perform(req),
    error = function(cnd) {
      cli::cli_abort(
        "Could not connect to Spain Electoral Polls API at {.url {base_url}}.",
        parent = cnd
      )
    }
  )

  status <- httr2::resp_status(resp)
  if (status >= 400) {
    abort_http_error(resp, path = path, query = query)
  }

  parse_json_response(resp)
}

spainpolls_build_url <- function(base_url, path) {
  path <- paste0("/", sub("^/+", "", path))

  if (identical(path, "/health")) {
    return(paste0(base_url, path))
  }

  if (startsWith(path, api_prefix)) {
    return(paste0(base_url, path))
  }

  paste0(base_url, api_prefix, path)
}

spainpolls_user_agent <- function() {
  version <- tryCatch(
    utils::packageVersion("spainpolls"),
    error = function(cnd) "0.1.0"
  )
  paste0("spainpolls R package/", version)
}

clean_query <- function(query) {
  query <- purrr::compact(query)
  purrr::map(query, serialize_query_value)
}

serialize_query_value <- function(x) {
  if (inherits(x, "Date")) {
    return(format(x, "%Y-%m-%d"))
  }

  if (inherits(x, "POSIXt")) {
    return(format(as.Date(x), "%Y-%m-%d"))
  }

  if (is.logical(x)) {
    validate_scalar_logical_value(x)
    return(if (isTRUE(x)) "true" else "false")
  }

  x
}

parse_json_response <- function(resp) {
  tryCatch(
    httr2::resp_body_json(resp, simplifyVector = FALSE),
    error = function(cnd) {
      cli::cli_abort("Unexpected response format from Spain Electoral Polls API.", parent = cnd)
    }
  )
}

parse_error_detail <- function(resp) {
  body <- tryCatch(httr2::resp_body_json(resp, simplifyVector = FALSE), error = function(cnd) NULL)
  if (is.null(body) || is.null(body$detail)) {
    return(NULL)
  }

  detail <- body$detail
  if (is.character(detail) && length(detail) == 1) {
    return(detail)
  }

  if (is.list(detail) && length(detail) > 0 && !is.null(detail[[1]]$msg)) {
    loc <- paste(unlist(detail[[1]]$loc %||% character()), collapse = ".")
    msg <- detail[[1]]$msg
    return(if (nzchar(loc)) paste0(loc, ": ", msg) else msg)
  }

  jsonlite::toJSON(detail, auto_unbox = TRUE)
}

abort_http_error <- function(resp, path, query) {
  status <- httr2::resp_status(resp)
  detail <- parse_error_detail(resp) %||% httr2::resp_status_desc(resp)

  if (status == 400) {
    cli::cli_abort("The API rejected the request as malformed: {detail}")
  }
  if (status == 404) {
    cli::cli_abort("The requested Spain Electoral Polls API resource was not found: {detail}")
  }
  if (status == 422) {
    cli::cli_abort("Invalid API parameter: {detail}")
  }
  if (status == 500) {
    cli::cli_abort("The Spain Electoral Polls API returned an internal error. Try again later.")
  }
  if (status == 503) {
    cli::cli_abort("The Spain Electoral Polls API is temporarily unavailable.")
  }

  cli::cli_abort("The Spain Electoral Polls API returned status {status}: {detail}")
}

`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}
