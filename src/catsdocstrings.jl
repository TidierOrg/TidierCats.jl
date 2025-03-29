
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
    cat_relevel(cat_array::CategoricalArray, levels_order::Vector{String}, after::Int=0)

Reorders the levels in a categorical array according to the provided order.

# Arguments
`cat_array`: Input categorical array.
`levels_order`: Vector of levels in the desired order.
`after`: Position after which to insert the new levels. Default is ignored
# Returns
Categorical array with levels reordered according to levels_order.

# Examples

```jldoctest
julia> cat_array = CategoricalArray(["A", "B", "C", "A", "B", "B"], ordered=true)
6-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "C"
 "A"
 "B"
 "B"

julia> println(levels(cat_relevel(cat_array, ["B", "A", "C"])))
["B", "A", "C"]

julia> println(levels(cat_relevel(cat_array, ["A"], after=1)))
["B", "A", "C"]

julia> cat_array = CategoricalArray(["A", "B", "C", "A", "B", missing], ordered=true);

julia> println(levels(cat_relevel(cat_array, ["C", "A", "B", missing]), skipmissing=false))
Union{Missing, String}["C", "A", "B", missing]
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
`desc`: If true, the levels are ordered in descending order of the summary statistic.

# Returns
Categorical array with the levels reordered.

# Examples

```jldoctest
julia> cat_var = String["A", "B", "A", "B", "A", "B", "C", "C", "C"];
       order_var = [1, 2, 3, 4, 5, 6, 7, 8, 9];
       cat_reorder(cat_var, order_var, "mean")
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
julia> cat_array = CategoricalArray(["A", "B", "C", "D", "E"], ordered=true)
5-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "A"
 "B"
 "C"
 "D"
 "E"

julia> levels_map = Dict("A" => "A", "B" => "A", "C" => "C", "D" => "C", "E" => "E");

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
const docstring_as_integer =
"""
Converts a CategoricalValue or CategoricalArray to an integer or vector of integers.
"""
const docstring_cat_replace_missing = 
"""
    cat_replace_missing(cat_array::CategoricalArray, missing_level::String = "missing")

Replaces missing values within a CategoricalArray with a placeholder string.

# Arguments
- `cat_array`: Categorical array to lump
- `missing_level`: The string that will be used inplace of missing values.

# Returns
Categorical array without any missing elements. 

# Examples

```jldoctest
julia> cat_array = CategoricalArray(["a", "b", missing, "a", missing, "c"]);
6-element CategoricalArray{Union{Missing, String},1,UInt32}:
 "a"
 "b"
 missing
 "a"
 missing
 "c"

 julia> print(cat_replace_missing(cat_array))
6-element CategoricalArray{Union{Missing, String},1,UInt32}:
 "a"
 "b"
 "missing"
 "a"
 "missing"
 "c"

julia> print(cat_replace_missing(cat_array, "unknown"))
6-element CategoricalArray{Union{Missing, String},1,UInt32}:
 "a"
 "b"
 "unknown"
 "a"
 "unknown"
 "c"
```
"""

const docstring_cat_recode = 
"""
    cat_recode(cat_array::Union{CategoricalArray, AbstractVector}; kwargs...)

Recodes the levels in a categorical array based on a provided mapping.

# Arguments
- `cat_array`: Categorical array to recode
- `kwargs`: A dictionary with the original levels as keys and the new levels as values. Levels not in the keys will be kept the same.

# Returns
Categorical array with the levels recoded.

# Examples

```jldoctest
julia> x = CategoricalArray(["apple", "tomato", "banana", "dear"]);

julia> println(levels(cat_recode(x, fruit = ["apple", "banana"], nothing = ["tomato"])))
["fruit", "nothing", "dear"]
```
"""

const docstring_cat_other =
"""
    cat_other(cat_array::CategoricalArray, other_level::String="Other")

Replaces all levels in a categorical array with the 'other' level.

# Arguments
- `cat_array`: Categorical array to replace levels
- `other_level`: The level name to replace all levels with. Default is "Other".

# Returns
Categorical array with all levels replaced by the 'other' level.

# Examples

```jldoctest
julia> cat_array = CategoricalArray(["A", "B", "C", "D", "E"]);

julia> cat_other(cat_array, drop = ["A", "B"])
5-element CategoricalArrays.CategoricalArray{String,1,UInt32}:
 "Other"
 "Other"
 "C"
 "D"
 "E"
```
"""

const docstring_cat_expand = 
"""
    cat_expand(cat_array::CategoricalArray, new_levels...; after=Inf)

Expands the levels in a categorical array by adding new levels at a specified position.

# Arguments
- `cat_array`: Categorical array to expand levels
- `new_levels`: New levels to be added to the categorical array
- `after`: Position after which to insert the new levels. Default is Inf, which appends the new levels at the end.

# Returns
Categorical array with the new levels added.

# Examples
```julia
julia> cats = CategoricalArray(["a", "b", "c", "a", "c", "b"]);

julia> println("Original levels: ", levels(cats))
Original levels: ["a", "b", "c"]

julia> cats = cat_expand(f, "d", "e", "f");

julia> println("Expanded levels: ", levels(cats))
Expanded levels: ["a", "b", "c", "d", "e", "f"]
```
"""