# Client Implementation Notes

Date: 2026-07-02

## `GET /api/v1/polls/{poll_id}/results`

Discrepancy: the original package brief requested `get_poll_results(poll_id)`,
but the handoff and OpenAPI contract state that `GET
/api/v1/polls/{poll_id}/results` is not implemented.

Decision: `get_poll_results(poll_id)` calls `GET /api/v1/polls/{poll_id}` via
`get_poll()` and returns the nested `results` tibble.

Possible future change: if the API adds a stable public poll-results endpoint,
`get_poll_results()` can switch to that route while keeping the same R function
name.

## Package Location

Decision: the R package is implemented at the repository root, with
`DESCRIPTION` in the root directory. This follows the user revision after the
initial plan.
