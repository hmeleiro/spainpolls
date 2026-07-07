fetch_paginated <- function(path, query, schema, collect_all = FALSE, sort = NULL) {
  limit <- query$limit %||% 100L
  offset <- query$offset %||% 0L
  validate_limit_offset(limit, offset)

  if (!isTRUE(collect_all)) {
    page <- spainpolls_get(path, query = query)
    validate_page(page, path)
    return(sort_spainpolls_tibble(list_to_tibble(page$items, schema), sort))
  }

  page_limit <- if (!is.null(query$limit) && query$limit < max_page_limit) {
    as.integer(query$limit)
  } else {
    max_page_limit
  }

  query$limit <- page_limit
  query$offset <- 0L
  all_items <- list()

  repeat {
    page <- tryCatch(
      spainpolls_get(path, query = query),
      error = function(cnd) {
        cli::cli_abort(
          "Failed while collecting {.path {path}} at offset {.val {query$offset}}.",
          parent = cnd
        )
      }
    )
    validate_page(page, path)

    all_items <- c(all_items, page$items)
    n_items <- length(page$items)
    total <- as.integer(page$total)

    if (total == 0 || n_items == 0 || query$offset + n_items >= total) {
      break
    }

    query$offset <- query$offset + page_limit
  }

  sort_spainpolls_tibble(list_to_tibble(all_items, schema), sort)
}

validate_page <- function(page, path) {
  required <- c("items", "limit", "offset", "total")
  if (!is.list(page) || !all(required %in% names(page)) || !is.list(page$items)) {
    cli::cli_abort("Unexpected paginated response format from {.path {path}}.")
  }
  invisible(TRUE)
}
