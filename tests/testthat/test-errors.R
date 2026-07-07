make_response <- function(status, body) {
  httr2::response(
    status_code = status,
    headers = list("content-type" = "application/json"),
    body = charToRaw(jsonlite::toJSON(body, auto_unbox = TRUE))
  )
}

test_that("HTTP errors become clear package errors", {
  expect_error(
    spainpolls:::abort_http_error(make_response(404, list(detail = "Poll not found")), "polls/1", list()),
    "not found"
  )
  expect_error(
    spainpolls:::abort_http_error(make_response(422, list(detail = list(list(
      loc = list("query", "limit"),
      msg = "Input should be less than or equal to 1000"
    )))), "polls", list()),
    "limit"
  )
  expect_error(
    spainpolls:::abort_http_error(make_response(500, list(detail = "Internal Server Error")), "polls", list()),
    "internal error"
  )
  expect_error(
    spainpolls:::abort_http_error(make_response(503, list(detail = "Service unavailable")), "polls", list()),
    "temporarily unavailable"
  )
})

test_that("unexpected paginated responses fail clearly", {
  withr::local_options(spainpolls.request_fn = function(path, query) list(items = list()))
  expect_error(get_elections(), "Unexpected paginated response")
})
