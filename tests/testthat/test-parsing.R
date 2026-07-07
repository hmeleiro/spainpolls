test_that("catalogue endpoints parse typed tibbles", {
  withr::local_options(spainpolls.request_fn = function(path, query) {
    switch(
      path,
      elections = mock_page(list(list(
        id = 1,
        election_key = "congreso_espana_2027",
        election_type = "general",
        territory_code = "ES",
        election_name = "Congreso de los Diputados 2027",
        election_date = "2027-07-01"
      ))),
      pollsters = mock_page(list(list(
        id = 10,
        pollster_key = "40db",
        pollster_name = "40dB",
        poll_count = 18
      ))),
      parties = mock_page(list(list(
        party_key = "psoe",
        party_name = "Partido Socialista Obrero Espanol",
        short_name = "PSOE",
        territory_code = "ES",
        color_hex = "#e30613",
        display_order = 10,
        is_active = TRUE,
        poll_count = 42
      )))
    )
  })

  elections <- get_elections()
  pollsters <- get_pollsters()
  parties <- get_parties()

  expect_s3_class(elections, "tbl_df")
  expect_s3_class(elections$election_date, "Date")
  expect_type(pollsters$poll_count, "integer")
  expect_equal(parties$party_key, "psoe")
  expect_equal(parties$short_name, "PSOE")
  expect_type(parties$display_order, "integer")
  expect_type(parties$is_active, "logical")
  expect_false("party_raw" %in% names(parties))
})

test_that("polls parse dates, datetimes, logicals, nulls and drop internal fields", {
  withr::local_options(spainpolls.request_fn = function(path, query) {
    mock_page(list(list(
      id = 101,
      election_key = "congreso_espana_2027",
      election_name = "Congreso de los Diputados 2027",
      territory_code = "ES",
      pollster_key = "40db",
      pollster_name = "40dB",
      media = "El Pais",
      fieldwork_start = "2026-06-01",
      fieldwork_end = "2026-06-05",
      publication_date = "2026-06-07",
      sample_size = 1200,
      turnout = NULL,
      lead = 3.2,
      source_url = "https://example.com/active",
      source_title = "Active poll",
      identity_status = "exact",
      first_seen_at = "2026-06-07T10:15:00",
      is_active = TRUE,
      row_hash = "hidden"
    )))
  })

  polls <- get_polls()

  expect_s3_class(polls$fieldwork_end, "Date")
  expect_s3_class(polls$first_seen_at, "POSIXct")
  expect_type(polls$is_active, "logical")
  expect_true(is.na(polls$turnout))
  expect_false("row_hash" %in% names(polls))
})

test_that("poll detail returns nested result tibble", {
  withr::local_options(spainpolls.request_fn = function(path, query) {
    expect_equal(path, "polls/101")
    list(
      id = 101,
      election_key = "congreso_espana_2027",
      election_name = "Congreso de los Diputados 2027",
      territory_code = "ES",
      pollster_key = "40db",
      pollster_name = "40dB",
      media = "El Pais",
      fieldwork_start = "2026-06-01",
      fieldwork_end = "2026-06-05",
      publication_date = "2026-06-07",
      sample_size = 1200,
      turnout = NULL,
      lead = 3.2,
      source_url = "https://example.com/active",
      source_title = "Active poll",
      identity_status = "exact",
      first_seen_at = "2026-06-07T10:15:00",
      is_active = TRUE,
      results = list(list(
        party_key = "pp",
        party_raw = "PP",
        party_name = "Partido Popular",
        short_name = "PP",
        color_hex = "#1d84ce",
        display_order = 20,
        vote_share = 28,
        seats_min = NULL,
        seats_max = NULL
      ), list(
        party_key = "psoe",
        party_raw = "PSOE",
        party_name = "Partido Socialista Obrero Espanol",
        short_name = "PSOE",
        color_hex = "#e30613",
        display_order = 10,
        vote_share = 31.2,
        seats_min = NULL,
        seats_max = NULL
      ))
    )
  })

  poll <- get_poll(101)
  results <- get_poll_results(101)

  expect_s3_class(poll$results[[1]], "tbl_df")
  expect_equal(results$party_key, c("psoe", "pp"))
  expect_equal(results$short_name, c("PSOE", "PP"))
  expect_equal(results$display_order, c(10L, 20L))
  expect_true(all(is.na(results$seats_min)))
})

test_that("results and timeseries parse analytical tibbles", {
  withr::local_options(spainpolls.request_fn = function(path, query) {
    if (path == "results") {
      return(mock_page(list(
        list(
          party_key = "pp",
          party_raw = "PP",
          party_name = "Partido Popular",
          short_name = "PP",
          color_hex = "#1d84ce",
          display_order = 20,
          vote_share = 28,
          seats_min = NULL,
          seats_max = NULL,
          poll_id = 102,
          date = "2026-06-06",
          election_key = "congreso_espana_2027",
          pollster_key = "40db",
          pollster_name = "40dB",
          media = "El Pais",
          fieldwork_end = "2026-06-06",
          publication_date = "2026-06-08",
          sample_size = 1200
        ),
        list(
        party_key = "psoe",
        party_raw = "PSOE",
        party_name = "Partido Socialista Obrero Espanol",
        short_name = "PSOE",
        color_hex = "#e30613",
        display_order = 10,
        vote_share = 31.2,
        seats_min = NULL,
        seats_max = NULL,
        poll_id = 101,
        date = "2026-06-05",
        election_key = "congreso_espana_2027",
        pollster_key = "40db",
        pollster_name = "40dB",
        media = "El Pais",
        fieldwork_end = "2026-06-05",
        publication_date = "2026-06-07",
        sample_size = 1200
        )
      )))
    }
    mock_page(list(
      list(
        date = "2026-06-04",
        poll_id = 101,
        pollster_key = "40db",
        pollster_name = "40dB",
        media = "El Pais",
        sample_size = 1200,
        party_key = "psoe",
        party_raw = "PSOE",
        party_name = "Partido Socialista Obrero Espanol",
        short_name = "PSOE",
        color_hex = "#e30613",
        display_order = 10,
        vote_share = 31.2
      ),
      list(
        date = "2026-06-05",
        poll_id = 102,
        pollster_key = "40db",
        pollster_name = "40dB",
        media = "El Pais",
        sample_size = 1200,
        party_key = "pp",
        party_raw = "PP",
        party_name = "Partido Popular",
        short_name = "PP",
        color_hex = "#1d84ce",
        display_order = 20,
        vote_share = 28
      ),
      list(
        date = "2026-06-05",
        poll_id = 101,
        pollster_key = "40db",
        pollster_name = "40dB",
        media = "El Pais",
        sample_size = 1200,
        party_key = "psoe",
        party_raw = "PSOE",
        party_name = "Partido Socialista Obrero Espanol",
        short_name = "PSOE",
        color_hex = "#e30613",
        display_order = 10,
        vote_share = 31.2
      ),
      list(
        date = "2026-06-05",
        poll_id = 101,
        pollster_key = "40db",
        pollster_name = "40dB",
        media = "El Pais",
        sample_size = 1200,
        party_key = "pp",
        party_raw = "PP",
        party_name = "Partido Popular",
        short_name = "PP",
        color_hex = "#1d84ce",
        display_order = 20,
        vote_share = 28
      )
    ))
  })

  results <- get_results()
  timeseries <- get_timeseries()

  expect_s3_class(results$date, "Date")
  expect_type(results$vote_share, "double")
  expect_s3_class(timeseries$date, "Date")
  expect_equal(results$poll_id, c(102L, 101L))
  expect_equal(results$short_name, c("PP", "PSOE"))
  expect_equal(timeseries$party_key, c("psoe", "pp", "pp", "psoe"))
  expect_equal(timeseries$color_hex, c("#e30613", "#1d84ce", "#1d84ce", "#e30613"))
})
