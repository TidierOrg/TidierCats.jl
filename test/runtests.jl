using TidierCats
using Test

@testset "TidierCats.jl" begin
    julia> cat_array = CategoricalArray(["A", "B", "C", "A", "B", "B"], ordered=true);
julia> levels_order = ["B", "A", "C"];
julia> cat_relevel(cat_array, levels_order)
6-element CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "C"
 "A"
 "B"
 "B"

Levels (ordered): "B" < "A" < "C"
end
