# Configure the Spain Electoral Polls API URL

Sets the API base URL used by all `spainpolls` requests.

## Usage

``` r
set_spainpolls_api_url(url)
```

## Arguments

- url:

  Scalar character API base URL, for example `"http://localhost:8000"`.

## Value

The previous value of `getOption("spainpolls.api_url")`, invisibly.

## Examples

``` r
old <- set_spainpolls_api_url("http://localhost:8000")
options(spainpolls.api_url = old)
```
