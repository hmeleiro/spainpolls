# Check API health

Calls the public `/health` endpoint and returns the service status.

## Usage

``` r
spainpolls_health()
```

## Value

A one-row tibble with `status`, `service`, and `database`.

## Examples

``` r
if (interactive()) {
  spainpolls_health()
}
```
