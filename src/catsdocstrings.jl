

"""
cat_relevel(cat_array::CategoricalArray, levels_order::Vector{String})

Reorders the levels in a categorical array according to the provided order.

Arguments
cat_array: Input categorical array.
levels_order: Vector of levels in the desired order.
Returns
Categorical array with levels reordered according to levels_order.
Examples
jldoctest

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
"""

"""
cat_infreq(cat_array)

Orders the levels in a categorical array by their frequency, with the most common level first.

Arguments
cat_array: Input categorical array.
Returns
Categorical array with levels reordered by frequency.
Examples
jldoctest

julia> cat_array = CategoricalArray(["A", "B", "C", "A", "B", "B"], ordered=true);
julia> cat_infreq(cat_array)
6-element CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "C"
 "A"
 "B"
 "B"

Levels (ordered): "B" < "A" < "C"
"""


"""
cat_lump(cat_array, n::Int)

Orders the levels in a categorical array by their frequency and keeps only the 'n' most common levels. All other levels are replaced by "Other".

Arguments
cat_array: Input categorical array.
n: Number of most frequent levels to keep.
Returns
Categorical array with the least frequent levels lumped as "Other".
Examples
jldoctest
Copy code
julia> cat_array = CategoricalArray(["A", "B", "C", "A", "B", "B", "D", "E", "F"], ordered=true);
julia> cat_lump(cat_array, 3)
9-element CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "Other"
 "A"
 "B"
 "B"
 "Other"
 "Other"
 "Other"

Levels (ordered): "Other" < "A" < "B"
"""

"""
as_categorical(arr::AbstractArray)

Converts the input array to a CategoricalArray.

Arguments
arr: Input array.
Returns
CategoricalArray constructed from the input array.
Examples
jldoctest
Copy code
julia> arr = ["A", "B", "C", "A", "B", "B", "D", "E", "F"];
julia> as_categorical(arr)
9-element CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "C"
 "A"
 "B"
 "B"
 "D"
 "E"
 "F"
"""
"""
cat_reorder(cat_var::AbstractVector, order_var::AbstractVector, fun::String, desc::Bool=true)

Reorders the levels in a categorical variable column based on a summary statistic calculated from another variable.

Arguments
cat_var: Categorical variable column to reorder.
order_var: Variable to calculate the summary statistic from.
fun: Function to calculate the summary statistic. Options are "mean" and "median".
desc: If true, the levels are ordered in descending order of the summary statistic.
Returns
Categorical array with the levels reordered.
Examples
jldoctest
Copy code
julia> cat_var = ["A", "B", "A", "B", "A", "B", "C", "C", "C"];
julia> order_var = [1, 2, 3, 4, 5, 6, 7, 8, 9];
julia> cat_reorder(cat_var, order_var, "mean")
9-element CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "A"
 "B"
 "A"
 "B"
 "C"
 "C"
 "C"

Levels (ordered): "A" < "B" < "C"
"""


"""
cat_collapse(cat_array::CategoricalArray, levels_map::Dict)

Collapses levels in a categorical variable column based on a provided mapping.

Arguments
cat_array: Categorical variable column to collapse.
levels_map: A dictionary with the original levels as keys and the new levels as values. Levels not in the keys will be kept the same.
Returns
Categorical array with the levels collapsed.
Examples
jldoctest
Copy code
julia> cat_array = CategoricalArray(["A", "B", "C", "D", "E"], ordered=true);
julia> levels_map = Dict("A" => "A", "B" => "A", "C" => "C", "D" => "C", "E" => "E");
julia> cat_collapse(cat_array, levels_map)
5-element CategoricalArray{String,1,UInt32}:
 "A"
 "A"
 "C"
 "C"
 "E"

Levels (ordered): "A" < "C" < "E"
"""
