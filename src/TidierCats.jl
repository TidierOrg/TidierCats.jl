module TidierCats

using CategoricalArrays
using DataFrames 
using Statistics
using Reexport

@reexport using CategoricalArrays

export cat_rev, cat_relevel, cat_infreq, cat_lump, cat_reorder, cat_collapse, cat_lump_min, cat_lump_prop
export as_categorical, as_integer, cat_replace_missing, cat_other, cat_recode
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
function cat_relevel(cat_array::CategoricalArray{Union{Missing, String}}, levels_order::Vector{Union{String, Missing}})
    unwrapped_levels = unwrap.(levels(cat_array))
    ordered_levels = [x for x in levels_order if !ismissing(x) && x in unwrapped_levels]
    if any(ismissing, levels_order) && any(ismissing, unwrapped_levels)
        push!(ordered_levels, missing)
    end
    append!(ordered_levels, [x for x in unwrapped_levels if !ismissing(x) && x ∉ ordered_levels])
    levels!(cat_array, ordered_levels)
    return cat_array
end

function cat_relevel(cat_array, levels_order::Vector{String}; after::Int = 0)
    current_levels = levels(cat_array)
    
    # Separate levels into those mentioned in levels_order and those not
    mentioned_levels = [x for x in levels_order if x in current_levels]
    unmentioned_levels = [x for x in current_levels if x ∉ mentioned_levels]
    
    # Determine where to insert the mentioned levels
    if after == 0
        new_levels = vcat(mentioned_levels, unmentioned_levels)
    elseif after > 0 && after <= length(current_levels)
        before = current_levels[1:after]
        after_levels = current_levels[(after+1):end]
        new_levels = vcat(
            [l for l in before if l ∉ mentioned_levels],
            [l for l in after_levels if l ∉ mentioned_levels],
            mentioned_levels
        )
        # Move mentioned levels to the correct position
        mentioned_set = Set(mentioned_levels)
        insert_pos = after + 1
        for (i, level) in enumerate(new_levels)
            if i > after && level ∉ mentioned_set
                insert_pos = i
                break
            end
        end
        new_levels = vcat(
            new_levels[1:(insert_pos-1)],
            mentioned_levels,
            new_levels[insert_pos:end]
        )
        new_levels = unique(new_levels)  # Remove any duplicates
    else
        error("'after' must be between 0 and the number of levels")
    end
    
    # Create a new CategoricalArray with the updated level order
    new_cat_array = copy(cat_array)
    levels!(new_cat_array, new_levels)
    
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

"""
$docstring_cat_replace_missing
"""
function cat_replace_missing(cat_array::CategoricalArray{Union{Missing, String}}, txt::String)
    replace(cat_array, missing => txt)
end

"""
$docstring_cat_other
"""
function cat_other(f::Union{CategoricalArray, AbstractVector}; 
                   keep::Union{Nothing, Vector{String}} = nothing, 
                   drop::Union{Nothing, Vector{String}} = nothing, 
                   other_level::String = "Other")
    
    if !isnothing(keep) && !isnothing(drop)
        error("Only one of 'keep' or 'drop' should be specified, not both.")
    end
    
    if isnothing(keep) && isnothing(drop)
        error("Either 'keep' or 'drop' must be specified.")
    end
    
    # Convert to CategoricalArray if it's not already
    if !(f isa CategoricalArray)
        f = categorical(f)
    end
    
    current_levels = levels(f)
    
    if !isnothing(keep)
        levels_to_change = setdiff(current_levels, keep)
    else  # drop is specified
        levels_to_change = intersect(current_levels, drop)
    end
    
    # Create a new CategoricalArray
    new_f = copy(f)
    
    # Replace levels
    for level in levels_to_change
        new_f[new_f .== level] .= other_level
    end
    
    # Ensure 'other_level' is at the end of levels
    new_levels = union(setdiff(current_levels, levels_to_change), [other_level])
    levels!(new_f, new_levels)
    
    return new_f
end


"""
$docstring_cat_recode
"""
function cat_recode(f::Union{CategoricalArray, AbstractVector}; kwargs...)
    # Convert to CategoricalArray if it's not already
    if !(f isa CategoricalArray)
        f = categorical(f)
    end

    # Create a new CategoricalArray
    new_f = copy(f)
    
    # Iterate over the keyword arguments
    for (new_level, old_levels) in kwargs
        old_levels_str = [String(level) for level in old_levels]  # Convert to string if needed
        
        if new_level === nothing
            # Remove the old levels by setting them to missing
            for old_level in old_levels_str
                new_f[new_f .== old_level] .= missing
            end
        else
            new_level_str = String(new_level)  # Convert new level to string
            # Recode the old levels to the new level
            for old_level in old_levels_str
                if old_level in levels(new_f)
                    new_f[new_f .== old_level] .= new_level_str
                else
                    @warn "Unknown level in input factor: $old_level"
                end
            end
        end
    end

    # Clean up the levels (remove missing levels)
    levels!(new_f, unique(skipmissing(new_f)))

    return new_f
end



end
