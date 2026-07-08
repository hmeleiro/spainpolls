test_that("API URL defaults and can be configured", {
  withr::local_options(spainpolls.api_url = NULL)
  expect_equal(spainpolls_api_url(), "https://pollsdb.spainelectoralproject.com")

  old <- set_spainpolls_api_url("http://localhost:8000/")
  expect_null(old)
  expect_equal(spainpolls_api_url(), "http://localhost:8000")
})

test_that("invalid API URLs fail clearly", {
  expect_error(set_spainpolls_api_url("localhost:8000"), "must start")
})
