test_that("collect_all collects several pages and starts at offset zero", {
  seen_offsets <- integer()
  withr::local_options(spainpolls.request_fn = function(path, query) {
    seen_offsets <<- c(seen_offsets, query$offset)
    if (query$offset == 0) {
      return(mock_page(
        list(
          list(id = 1, election_key = "a", election_type = "general", territory_code = "ES", election_name = "A", election_date = NULL),
          list(id = 2, election_key = "b", election_type = "general", territory_code = "ES", election_name = "B", election_date = NULL)
        ),
        limit = 2,
        offset = 0,
        total = 3
      ))
    }
    mock_page(
      list(list(id = 3, election_key = "c", election_type = "general", territory_code = "ES", election_name = "C", election_date = NULL)),
      limit = 2,
      offset = 2,
      total = 3
    )
  })

  elections <- get_elections(limit = 2, offset = 50, collect_all = TRUE)

  expect_equal(nrow(elections), 3)
  expect_equal(seen_offsets, c(0, 2))
})

test_that("empty pages return typed empty tibbles", {
  withr::local_options(spainpolls.request_fn = function(path, query) {
    mock_page(list(), total = 0)
  })

  elections <- get_elections()

  expect_s3_class(elections, "tbl_df")
  expect_equal(nrow(elections), 0)
  expect_s3_class(elections$election_date, "Date")
})

test_that("collect_all reports intermediate page failures", {
  withr::local_options(spainpolls.request_fn = function(path, query) {
    if (query$offset == 0) {
      return(mock_page(
        list(list(id = 1, election_key = "a", election_type = "general", territory_code = "ES", election_name = "A", election_date = NULL)),
        limit = 1,
        offset = 0,
        total = 2
      ))
    }
    rlang::abort("boom")
  })

  expect_error(get_elections(limit = 1, collect_all = TRUE), "offset")
})
