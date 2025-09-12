test_that("Function returns", {
  fn_output <- suppressMessages(gwascatftp::install_lftp())
  if (!is.na(fn_output)) {
    out_exists <- fs::file_exists(fn_output)
    expect_true(out_exists)
  } else {
    expect_equal(fn_output, NA)
  }
})
