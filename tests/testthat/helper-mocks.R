mock_page <- function(items, limit = 100, offset = 0, total = length(items)) {
  list(items = items, limit = limit, offset = offset, total = total)
}
