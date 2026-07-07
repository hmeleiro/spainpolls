max_page_limit <- 1000L

validate_limit_offset <- function(limit, offset) {
  if (!is.numeric(limit) || length(limit) != 1 || is.na(limit) || limit != as.integer(limit)) {
    cli::cli_abort("{.arg limit} must be a single integer.")
  }
  if (limit < 1 || limit > max_page_limit) {
    cli::cli_abort("{.arg limit} must be between 1 and {max_page_limit}.")
  }

  if (!is.numeric(offset) || length(offset) != 1 || is.na(offset) || offset != as.integer(offset)) {
    cli::cli_abort("{.arg offset} must be a single integer.")
  }
  if (offset < 0) {
    cli::cli_abort("{.arg offset} must be greater than or equal to 0.")
  }

  invisible(TRUE)
}

validate_scalar_logical <- function(x, arg = deparse(substitute(x))) {
  if (!is.logical(x) || length(x) != 1 || is.na(x)) {
    cli::cli_abort("{.arg {arg}} must be `TRUE` or `FALSE`.")
  }
  invisible(TRUE)
}

validate_scalar_logical_value <- function(x) {
  if (!is.logical(x) || length(x) != 1 || is.na(x)) {
    cli::cli_abort("Boolean query parameters must be scalar `TRUE` or `FALSE`.")
  }
  invisible(TRUE)
}

validate_poll_id <- function(poll_id) {
  if (!is.numeric(poll_id) || length(poll_id) != 1 || is.na(poll_id) || poll_id != as.integer(poll_id)) {
    cli::cli_abort("{.arg poll_id} must be a single integer.")
  }
  if (poll_id < 1) {
    cli::cli_abort("{.arg poll_id} must be greater than or equal to 1.")
  }
  as.integer(poll_id)
}

validate_date_field <- function(date_field) {
  rlang::arg_match(date_field, c("auto", "fieldwork_end", "publication_date"))
}

coerce_query_date <- function(x, arg) {
  if (is.null(x)) {
    return(NULL)
  }

  if (inherits(x, "Date")) {
    return(x)
  }

  out <- tryCatch(as.Date(x), error = function(cnd) NA)
  if (length(out) != 1 || is.na(out)) {
    cli::cli_abort("{.arg {arg}} must be a Date or a string coercible to Date.")
  }

  out
}

validate_query_dates <- function(query, date_args) {
  for (arg in date_args) {
    query[[arg]] <- coerce_query_date(query[[arg]], arg)
  }
  query
}
