module TidierCats

using CategoricalArrays
using DataFrames 
using Statistics
using Reexport

@reexport using CategoricalArrays

export cat_rev, cat_relevel, cat_infreq, cat_lump, cat_reorder, cat_collapse, cat_lump_min, cat_lump_prop
export as_categorical, as_integer
include("catsdocstrings.jl")

"""
$docstring_cat_rev
"""
function cat_rev(cat_array)
    cat_array = categorical(cat_array)
    ordered_levels = reverse(levels(cat_array))
    new_cat_array = CategoricalArray([String(v) for v in cat_array], ordered=true, levels=ordered_levels)
    return new_cat_array
end

"""
$docstring_cat_relevel
"""
function cat_relevel(cat_array::CategoricalArray, levels_order::Vector{String})
    ordered_levels = [x for x in levels_order if x in levels(cat_array)]
    append!(ordered_levels, [x for x in levels(cat_array) if x ∉ ordered_levels])
    new_cat_array = CategoricalArray([String(v) for v in cat_array], ordered=true, levels=ordered_levels)
    return new_cat_array
end


"""
$docstring_cat_infreq
"""
function cat_infreq(cat_array::CategoricalArray)
    # Create a DataFrame from the CategoricalArray
    df = DataFrame(category = cat_array)
    
    # Group by categorical column and count frequency
    freq_df = combine(groupby(df, :category), nrow => :frequency)
    
    # Sort by frequency in descending order
    sort!(freq_df, :frequency, rev=true)

    # Get the sorted levels
    new_levels = [String(level) for level in freq_df.category]

    # Create a new categorical array with the levels ordered by frequency
    new_cat_array = CategoricalArray([String(v) for v in df.category], ordered=true, levels=new_levels)
    
    return new_cat_array
end
"""
$docstring_cat_lump
"""
function cat_lump(cat_array, n::Int)
    # Convert to DataFrame
    df = DataFrame(category = cat_array)
    
    # Count frequency of each category
    freq_df = combine(groupby(df, :category), nrow => :count)
    
    # Sort by frequency
    sort!(freq_df, :count, rev = true)

    # Keep the top 'n' levels
    new_levels = freq_df.category[1:n]

    # Create a new array that replaces the less frequent levels with "Other"
    lumped_array = [x in new_levels ? String(x) : "Other" for x in cat_array]

    # Create a new categorical array with the lumped values
    new_cat_array = CategoricalArray(lumped_array, ordered=true)
    
    return new_cat_array
end

"""
$docstring_as_categorical
"""
function as_categorical(arr::AbstractArray)
  return CategoricalArray(map(x -> ismissing(x) ? missing : x, arr)) 
end

"""
$docstring_cat_reorder
"""
function cat_reorder(cat_var::AbstractVector, order_var::AbstractVector, fun::String, desc::Bool=true)
    # Convert the categorical variable column to a CategoricalArray
    cat_var = CategoricalArray(cat_var)

    # Map string to corresponding function
    fun_dict = Dict("mean" => mean, "median" => median) # Add more functions as needed
    if !haskey(fun_dict, fun)
        error("Invalid function name. Available options are: " * join(keys(fun_dict), ", "))
    end

    # Create a dictionary where keys are categorical levels and 
    # values are the summary statistic of the corresponding values in order_var
    level_summary = Dict()
    levels = unique(cat_var)
    for level in levels
        level_summary[level] = fun_dict[fun](order_var[cat_var .== level])
    end

    # Sort cat by their summary statistics
    new_levels = sort(levels, by = level -> level_summary[level], rev = desc)

    # Create a new categorical array with the levels ordered by their summary statistics
    new_cat_array = CategoricalArray(cat_var, ordered=true, levels=new_levels)

    return new_cat_array
end

"""
$docstring_cat_collapse
"""
function cat_collapse(cat_array::CategoricalArray, levels_map::Dict)
    # Generate a new array with the collapsed levels based on the mapping
    collapsed_array = [get(levels_map, String(x), String(x)) for x in cat_array]
    # Create a new categorical array with the collapsed values
    new_cat_array = CategoricalArray(collapsed_array, ordered=true)

    return new_cat_array
end



"""
$docstring_cat_lump_min
"""
function cat_lump_min(cat_array, min::Int, other_level::String = "Other")
    # Convert to DataFrame
    df = DataFrame(category = cat_array)
    
    # Count frequency of each category
    freq_df = combine(groupby(df, :category), nrow => :count)
    
    # Keep levels that have count greater than or equal to 'min'
    new_levels = freq_df[freq_df.count .>= min, :category]

    # Create a new array that replaces the less frequent levels with 'other_level'
    lumped_array = [x in new_levels ? String(x) : other_level for x in cat_array]

    # Create a new categorical array with the lumped values
    new_cat_array = CategoricalArray(lumped_array, ordered=true)
    
    return new_cat_array
end

"""
$docstring_cat_lump_prop
"""
function cat_lump_prop(cat_array, prop::Float64, other_level::String = "Other")
    # Convert to DataFrame
    df = DataFrame(category = cat_array)
    
    # Count frequency of each category
    freq_df = combine(groupby(df, :category), nrow => :count)
    
    # Calculate proportions
    total = sum(freq_df.count)
    freq_df[!, :proportion] = freq_df.count ./ total
    
    # Keep levels that have proportion greater than or equal to 'prop'
    new_levels = freq_df[freq_df.proportion .>= prop, :category]

    # Create a new array that replaces the less frequent levels with 'other_level'
    lumped_array = [x in new_levels ? String(x) : other_level for x in cat_array]

    # Create a new categorical array with the lumped values
    new_cat_array = CategoricalArray(lumped_array, ordered=true)
    
    return new_cat_array
end

"""
$docstring_as_integer
"""
function as_integer(cat_value::CategoricalValue)
    return CategoricalArrays.levelcode(cat_value)
end

function as_integer(cat_array::CategoricalArray)
    return CategoricalArrays.levelcode.(cat_array)
end

end
