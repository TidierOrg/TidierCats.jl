
const docstring_cat_rev = 
"""
cat_rev(cat_array)

Reverses the order of levels in a categorical array.

# Arguments
`cat_array`: Input categorical array.
# Returns
Categorical array with reversed order of levels.
# Examples

```jldoctest
julia> using CategoricalArrays

julia> cat_array = CategoricalArray(["A", "B", "C", "A", "B", "B"], ordered=true)
6-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "C"
 "A"
 "B"
 "B"

julia> cat_rev(cat_array)
6-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "C"
 "A"
 "B"
 "B"
```
"""


const docstring_cat_relevel = 
"""
cat_relevel(cat_array::CategoricalArray, levels_order::Vector{String})

Reorders the levels in a categorical array according to the provided order.

# Arguments
`cat_array`: Input categorical array.
`levels_order`: Vector of levels in the desired order.
# Returns
Categorical array with levels reordered according to levels_order.
# Examples
```jldoctest
julia> using CategoricalArrays

julia> cat_array = CategoricalArray(["A", "B", "C", "A", "B", "B"], ordered=true)
6-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "C"
 "A"
 "B"
 "B"

julia> cat_relevel(cat_array, ["B", "A", "C"])
6-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "C"
 "A"
 "B"
 "B"
```
"""

const docstring_cat_infreq = 
"""
cat_infreq(cat_array)

Orders the levels in a categorical array by their frequency, with the most common level first.

# Arguments
`cat_array`: Input categorical array.
# Returns
Categorical array with levels reordered by frequency.
# Examples
```jldoctest
julia> using CategoricalArrays

julia> using StatsBase

julia> cat_array = CategoricalArray(["A", "B", "B"], ordered=true)
3-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "B"

julia> cat_infreq(cat_array)
3-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "B"
```
"""

const docstring_cat_lump = 
"""
cat_lump(cat_array, n::Int)

Orders the levels in a categorical array by their frequency and keeps only the 'n' most common levels. All other levels are replaced by "Other".

Arguments
`cat_array`: Input categorical array.
`n`: Number of levels to keep as they are, the rest become "Other"
# Returns
Categorical array with the least frequent levels lumped as "Other". 
# Examples
```jldoctest
julia> using CategoricalArrays

julia> using DataFrames

julia> cat_array = CategoricalArray(["A", "B", "C", "A", "B", "B", "D", "E", "F"], ordered=true)
9-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "C"
 "A"
 "B"
 "B"
 "D"
 "E"
 "F"
```
"""

const docstring_as_categorical = 
"""
as_categorical(arr::AbstractArray)

Converts the input array to a CategoricalArray.

# Arguments
`arr`: Input array.
# Returns
CategoricalArray constructed from the input array.
# Examples
```jldoctest
julia> using CategoricalArrays
julia> arr = ["A", "B", "C", "A", "B", "B", "D", "E", missing]
9-element Vector{Union{Missing, String}}:
 "A"
 "B"
 "C"
 "A"
 "B"
 "B"
 "D"
 "E"
 missing
 
julia> as_categorical(arr)
9-element CategoricalArrays.CategoricalArray{Union{Missing, String},1,UInt32}:
 "A"
 "B"
 "C"
 "A"
 "B"
 "B"
 "D"
 "E"
 missing
 ```
"""

const docstring_cat_reorder = 
"""
cat_reorder(cat_var::AbstractVector, order_var::AbstractVector, fun::String, desc::Bool=true)

Reorders the levels in a categorical variable column based on a summary statistic calculated from another variable.

Arguments
`cat_var`: Categorical variable column to reorder.
`order_var`: Variable to calculate the summary statistic from.
`fun`: Function to calculate the summary statistic. Options are "mean" and "median".
desc: If true, the levels are ordered in descending order of the summary statistic.
# Returns
Categorical array with the levels reordered.
# Examples
```jldoctest
julia> using CategoricalArrays

julia> using StatsBase

julia> cat_var = ["A", "B", "A", "B", "A", "B", "C", "C", "C"]
9-element Vector{String}:
 "A"
 "B"
 "A"
 "B"
 "A"
 "B"
 "C"
 "C"
 "C"

julia> order_var = [1, 2, 3, 4, 5, 6, 7, 8, 9]
9-element Vector{Int64}:
 1
 2
 3
 4
 5
 6
 7
 8
 9

julia> cat_reorder(cat_var, order_var, "mean")
9-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "A"
 "B"
 "A"
 "B"
 "C"
 "C"
 "C"
```
"""

const docstring_cat_collapse = 
"""
cat_collapse(cat_array::CategoricalArray, levels_map::Dict)

Collapses levels in a categorical variable column based on a provided mapping.

# Arguments
`cat_array`: Categorical variable column to collapse.
levels_map: A dictionary with the original levels as keys and the new levels as values. Levels not in the keys will be kept the same.
# Returns
Categorical array with the levels collapsed.
# Examples
```jldoctest
julia> using CategoricalArrays


julia> cat_array = CategoricalArray(["A", "B", "C", "D", "E"], ordered=true)
5-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "C"
 "D"
 "E"

julia> levels_map = Dict("A" => "A", "B" => "A", "C" => "C", "D" => "C", "E" => "E")
Dict{String, String} with 5 entries:
  "B" => "A"
  "A" => "A"
  "C" => "C"
  "D" => "C"
  "E" => "E"

julia> cat_collapse(cat_array, levels_map)
5-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "A"
 "C"
 "C"
 "E"
```
"""


const docstring_cat_lump_min = 
"""
    cat_lump_min(cat_array, min::Int, other_level::String = "Other")

Lumps infrequent levels in a categorical array into an 'other' level based on minimum count.

# Arguments
- `cat_array`: Categorical array to lump  
- `min`: Minimum count threshold. Levels with counts below this will be lumped.
- `other_level`: The level name to lump infrequent levels into. Default is "Other".

# Returns
Categorical array with levels lumped.

# Examples
```jldoctest 
julia> using CategoricalArrays

julia> using DataFrames

julia> cat_array = CategoricalArray(["A", "B", "B", "C", "C", "D"])
6-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A" 
 "B"
 "B"
 "C" 
 "C"
 "D"

julia> cat_lump_min(cat_array, 2)  
6-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "B"
 "Other"
 "Other"
 "Other"
 ```
"""

const docstring_cat_lump_prop = 
"""
    cat_lump_prop(cat_array, prop::Float64, other_level::String = "Other")

Lumps infrequent levels in a categorical array into an 'other' level based on proportion threshold.

# Arguments
- `cat_array`: Categorical array to lump
- `prop`: Proportion threshold. Levels with proportions below this will be lumped.  
- `other_level`: The level name to lump infrequent levels into. Default is "Other".

# Returns
Categorical array with levels lumped based on proportion.

# Examples
```jldoctest
julia> using CategoricalArrays

julia> using DataFrames

julia> cat_array = CategoricalArray(["A", "B", "B", "C", "C", "D"])
6-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B" 
 "B"
 "C"
 "C" 
 "D"
 
julia> cat_lump_prop(cat_array, 0.3)
6-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "B"
 "Other" 
 "Other"
 "Other"
 ```
"""
