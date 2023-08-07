# TidierCats.jl

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://github.com/TidierOrg/TidierCats.jl/blob/main/LICENSE)
[![Docs: Latest](https://img.shields.io/badge/Docs-Latest-blue.svg)](https://tidierorg.github.io/TidierCats.jl/dev)
[![Build Status](https://github.com/TidierOrg/TidierCats.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/TidierOrg/TidierCats.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Downloads](https://shields.io/endpoint?url=https://pkgs.genieframework.com/api/v1/badge/Tidier&label=Downloads)](https://pkgs.genieframework.com?packages=TidierCats)

<img src="/docs/src/assets/TidierCats_logo.png" align="right" style="padding-left:10px;" width="150"/>

## What is TidierCats.jl

`TidierCats.jl `is a 100% Julia implementation of the R forcats package. 

`TidierCats.jl` has one main goal: to implement forcats's straightforward syntax and of ease of use while working with categorical variables for Julia users. While this package was develeoped to work seamelessly with `Tidier.jl` fucntions and macros, it can also work as a indepentenly as a standalone package. This package is powered by CateogricalArrays.jl 

## What functions does TidierCats.jl support?

- `cat_rev()`
- `cat_relevel()`
- `cat_infreq()`
- `cat_reorder()`
- `cat_collapse()`
- `cat_lump_min()`
- `cat_lump_prop()`
- `as_categorical()`

## Installation

For the development version:

```julia
using Pkg
Pkg.add(url = "https://github.com/TidierOrg/TidierCats.jl.git")
```
## Examples

```julia
using TidierData
using TidierCats
using Random

Random.seed!(10)

categories = ["High", "Medium", "Low", "Zilch"]

random_indices = rand(1:length(categories), 57)


df = DataFrame(
    ID = 1:57,
    CatVar = categorical([categories[i] for i in random_indices], levels = categories)
)
```

#### `cat_relevel()`
This function changes the order of levels in a categorical variable. It accepts two arguments - a column name and an array of levels in the desired order.

```julia
custom_order = @chain df begin
    @mutate(CatVar = cat_relevel(CatVar, ["Zilch", "Medium", "High", "Low"]))
end

print(levels(df[!,:CatVar]))
print(levels(custom_order[!,:CatVar]))
```

```
["High", "Medium", "Low", "Zilch"]
["Zilch", "Medium", "High", "Low"]
```

#### `cat_rev()` 
This function reverses the order of levels in a categorical variable. It only requires one argument - the column name whose levels are to be reversed.

```julia
reversed_order = @chain df begin
    @mutate(CatVar = cat_rev(CatVar))
end

print(levels(df[!,:CatVar]))
print(levels(reversed_order[!,:CatVar]))
```

```
["High", "Medium", "Low", "Zilch"]
["Zilch", "Low", "Medium", "High"]
```

#### `cat_infreq()` 
This function reorders levels of a categorical variable based on their frequencies, with most frequent level first. The single argument is column name.

```julia
@chain df begin
    @count(CatVar)
end
```

```
 Row │ CatVar  n     
     │ Cat…    Int64 
─────┼───────────────
   1 │ High       19
   2 │ Medium     11
   3 │ Low        14
   4 │ Zilch      13
```

```julia
orderedbyfrequency = @chain df begin
    @mutate(CatVar = cat_infreq(CatVar))
end

print(levels(df[!,:CatVar]))
print(levels(orderedbyfrequency[!,:CatVar]))
```

```
["High", "Medium", "Low", "Zilch"]
["High", "Low", "Zilch", "Medium"]
```

#### `cat_lump()` 
This function lumps the least frequent levels into a new "Other" level. It accepts two arguments - a column name and an integer specifying the number of levels to keep.

```julia
lumped_cats = @chain df begin
    @mutate(CatVar = cat_lump(CatVar,2))
end

print(levels(df[!,:CatVar]))
print(levels(lumped_cats[!,:CatVar]))
```

```
["High", "Medium", "Low", "Zilch"]
["High", "Low", "Other"]
```


#### `cat_reorder()` 
This function reorders levels of a categorical variable based on a mean of a second variable. It takes three arguments - a categorical column , a numerical column by which to reorder, and a function to calculate the summary statistic (currently only supports mean, median). There is a fourth optional argument which defaults to true, if set to false, it order the categories in ascending order.

```julia
df3 = DataFrame(
    cat_var = repeat(["Low", "Medium", "High"], outer = 10),
    order_var = rand(30)
)

df4 = @chain df3 begin
    @mutate(cat_var= cat_reorder(cat_var, order_var, "median" ))
end

@chain df3 begin
    @mutate(catty = as_categorical(cat_var))
    @group_by(cat_var)
    @summarise(median = median(order_var))
end

print(levels(df3[!,:cat_var]))
print(levels(df4[!,:cat_var]))
```

```
 Row │ cat_var  median   
     │ String   Float64  
─────┼───────────────────
   1 │ High     0.385143
   2 │ Low      0.510809
   3 │ Medium   0.65539

["High", "Low", "Medium"]
["Medium", "Low", "High"]
```

#### `cat_collapse()`
This function collapses levels in a categorical variable according to a specified mapping. It requires two arguments - a categorical column and a dictionary that maps original levels to new ones.

```julia
df5 = @chain df begin
    @mutate(CatVar = cat_collapse(CatVar, Dict("Low" => "bad", "Zilch" => "bad")))
end

@chain df begin
    @count(CatVar)
end

@chain df5 begin 
    @count(CatVar)
end
```

```
 Row │ CatVar  n     
     │ Cat…    Int64 
─────┼───────────────
   1 │ High       19
   2 │ Medium     11
   3 │ Low        14
   4 │ Zilch      13

 Row │ CatVar  n     
     │ Cat…    Int64 
─────┼───────────────
   1 │ High       19
   2 │ Medium     11
   3 │ bad        27
```

#### `as_categorical()`
This function converts a standard Julia array to a categorical array. The only argument it needs is the colunn name to be converted.

```julia
test = DataFrame( w = ["A", "B", "C", "D"])

@chain test begin 
    @mutate(w = as_categorical(w))
end
```

```
 Row │ w    
     │ Cat… 
─────┼──────
   1 │ A
   2 │ B
   3 │ C
   4 │ D
```

#### `cat_lump_min()`
This function wil lump any cargory with less than the minimum number of entries and recateogrize it as "Other" as the default, or a category name chosen by the user.

```julia
lumpedbymin = @chain df begin
    @mutate(CatVar = cat_lump_min(CatVar, 14))
end

print(levels(df[!,:CatVar]))
print(levels(lumpedbymin[!,:CatVar]))
```

```
["High", "Medium", "Low", "Zilch"]
["High", "Low", "Other"]
```


#### `cat_lump_prop()`
This function wil lump any cargory with less than the minimum proportion and recateogrize it as "Other" as the default, or a category name chosen by the user.

```julia
lumpedbyprop = @chain df begin
    @mutate(CatVar = cat_lump_prop(CatVar, .25, "new name"))
end

print(levels(df[!,:CatVar]))
print(levels(lumpedbyprop[!,:CatVar]))
```

```
["High", "Medium", "Low", "Zilch"]
["High", "new name"]
```

