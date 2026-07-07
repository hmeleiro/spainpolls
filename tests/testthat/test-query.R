test_that("query cleaning omits NULL and serializes dates and booleans", {
  query <- spainpolls:::clean_query(list(
    keep = "x",
    missing = NULL,
    date = as.Date("2026-06-05"),
    flag = TRUE
  ))

  expect_named(query, c("keep", "date", "flag"))
  expect_equal(query$date, "2026-06-05")
  expect_equal(query$flag, "true")
})

test_that("query cleaning preserves multi-value filters", {
  query <- spainpolls:::clean_query(list(
    party_key = c("psoe", "pp"),
    media = c("El Pais", "La Sexta")
  ))

  expect_equal(query$party_key, c("psoe", "pp"))
  expect_equal(query$media, c("El Pais", "La Sexta"))
})

test_that("date, limit, offset, logical and enum validation works", {
  expect_error(get_polls(limit = 0), "limit")
  expect_error(get_polls(offset = -1), "offset")
  expect_error(get_polls(include_inactive = NA), "include_inactive")
  expect_error(get_polls(fieldwork_end_from = "not-a-date"), "fieldwork_end_from")
  expect_error(get_timeseries(date_field = "end"), "date_field")
  expect_error(get_poll("abc"), "poll_id")
})
