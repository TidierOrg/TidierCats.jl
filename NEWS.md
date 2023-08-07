# TidierCats.jl updates

## v0.1.1 - 2023-08-06
- Added the `TidierCats.jl` functions to the `TidierData.jl` list of `not_vectorized[]` functions, which means that the user does *not* need to explicitly prefix them with a `~` when used inside of a `@mutate()` within `TidierData.jl`. Thus, all the `~` prefixes have been removed from the examples.

## v0.1.0 - Initial commit
- Released to Julia general registry