# TidierCats.jl updates

## v0.1.1 - 2023-08-06
- Added initialization script such that as long as `TidierData` is imported before `TidierCats`, the `TidierCats` functions are automatically registered as being not vectorized, which means that the user does *not* need to explicitly prefix them with a `~` when used inside of a `@mutate()` within `TidierData`.

## v0.1.0 - Initial commit
- Released to Julia general registry