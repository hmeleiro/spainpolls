#' Get the Spain Electoral Polls API URL
#'
#' Returns the configured API base URL. By default, this is the public
#' production API.
#'
#' @return A scalar character URL.
#' @export
#'
#' @examples
#' spainpolls_api_url()
spainpolls_api_url <- function() {
  url <- getOption("spainpolls.api_url", "https://polls.spainelectoralproject.com")
  normalize_base_url(url)
}

#' Configure the Spain Electoral Polls API URL
#'
#' Sets the API base URL used by all `spainpolls` requests.
#'
#' @param url Scalar character API base URL, for example
#'   `"http://localhost:8000"`.
#'
#' @return The previous value of `getOption("spainpolls.api_url")`, invisibly.
#' @export
#'
#' @examples
#' old <- set_spainpolls_api_url("http://localhost:8000")
#' options(spainpolls.api_url = old)
set_spainpolls_api_url <- function(url) {
  validate_url(url)
  old <- getOption("spainpolls.api_url")
  options(spainpolls.api_url = normalize_base_url(url))
  invisible(old)
}

normalize_base_url <- function(url) {
  validate_url(url)
  sub("/+$", "", url)
}

validate_url <- function(url) {
  if (!rlang::is_string(url) || !nzchar(url)) {
    cli::cli_abort("{.arg url} must be a non-empty string.")
  }

  if (!grepl("^https?://", url)) {
    cli::cli_abort("{.arg url} must start with {.val http://} or {.val https://}.")
  }

  invisible(url)
}
