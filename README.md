# TidierCats

## The goal of this package is to bring the convenience and simple usability of Forcats in R to Julia. This package was designed  to work with Tidier.jl, but can also work independently.

### This package includes: cat_rev, cat_relevel, cat_infreq, cat_lump, cat_reorder, cat_collapse, cat_lump_min, cat_lump_prop, as_categorical
 
```
using CategoricalArrays
using Tidier
using Random

Random.seed!(10)

categories = ["High", "Medium", "Low", "Zilch"]

random_indices = rand(1:length(categories), 57)


df = DataFrame(
    ID = 1:57,
    CatVar = categorical([categories[i] for i in random_indices], levels = categories)
)
```

### cat_relevel(): 
#### This function changes the order of levels in a categorical variable. It accepts two arguments - a column name and an array of levels in the desired order.
```
custom_order = @chain df begin
    @mutate(CatVar = ~cat_relevel(CatVar, ["Zilch", "Medium", "High", "Low"]))
end

print(levels(df[!,:CatVar]))
print(levels(custom_order[!,:CatVar]))

```

### cat_rev(): 
#### This function reverses the order of levels in a categorical variable. It only requires one argument - the column name whose levels are to be reversed
reversed_order = @chain df begin
    @mutate(CatVar = ~cat_rev(CatVar))
end

print(levels(df[!,:CatVar]))
print(levels(reversed_order[!,:CatVar]))

```

### cat_infreq(): This function reorders levels of a categorical variable based on their frequencies, with most frequent level first. The single argument is column name

```
@chain df begin
    @count(CatVar)
end

orderedbyfrequency = @chain df begin
    @mutate(CatVar = ~cat_infreq(CatVar))
end

print(levels(df[!,:CatVar]))
print(levels(orderedbyfrequency[!,:CatVar]))

@chain df begin
    @count(CatVar)
end

```
### cat_lump(): 
#### This function lumps the least frequent levels into a new "Other" level. It accepts two arguments - a column name and an integer specifying the number of levels to keep.
```

lumped_cats = @chain df begin
    @mutate(CatVar = ~cat_lump(CatVar,2))
end

print(levels(df[!,:CatVar]))
print(levels(lumped_cats[!,:CatVar]))

@chain lumped_cats begin
    @count(CatVar)
end
```

### cat_reorder(): 
#### This function reorders levels of a categorical variable based on a mean of a second variable. It takes three arguments - a categorical column , a numerical column by which to reorder, and a function to calculate the summary statistic (currently only supports mean, median). There is a fourth optional argument which defaults to true, if set to false, it order the categories in ascending order.

```

df3 = DataFrame(
    cat_var = repeat(["Low", "Medium", "High"], outer = 10),
    order_var = rand(30)
)

df4 = @chain df3 begin
    @mutate(cat_var= ~cat_reorder(cat_var, order_var, "median" ))
end


print(levels(df3[!,:cat_var]))
print(levels(df4[!,:cat_var]))

@chain df3 begin
    @mutate(catty = ~as_categorical(cat_var))
    @group_by(catty)
    #@summarise(median = median(order_var))
end
```

### cat_collapse(): 
#### This function collapses levels in a categorical variable according to a specified mapping. It requires two arguments - a categorical column and a dictionary that maps original levels to new ones.
```
df5 = @chain df begin
    @mutate(CatVar = ~cat_collapse(CatVar, Dict("Low" => "bad", "Zilch" => "bad")))
end

print(levels(df[!,:CatVar]))
print(levels(df5[!,:CatVar]))
```
### as_categorical(): 
#### This function converts a standard Julia array to a categorical array. The only argument it needs is the colunn name to be converted.
```
test = DataFrame( w = ["A", "B", "C", "D"])

@chain test begin 
    @mutate(w = ~as_categorical(w))
end
```

### cat_lump_min(): 
#### This function wil lump any cargory with less than the minimum number of entries and recateogrize it as "Other" as the default, or a category name chosen by the user

@chain df begin
    @count(CatVar)
end
lumpedbymin = @chain df begin
    @mutate(CatVar = ~cat_lump_min(CatVar, 14))
end

print(levels(df[!,:CatVar]))
print(levels(lumpedbymin[!,:CatVar]))

```
### cat_lump_min(): 
#### This function wil lump any cargory with less than the minimum proportion and recateogrize it as "Other" as the default, or a category name chosen by the user

```
lumpedbyprop = @chain df begin
    @mutate(CatVar = ~cat_lump_prop(CatVar, .25, "wow"))
end


print(levels(df[!,:CatVar]))
print(levels(lumpedbyprop[!,:CatVar]))
```


### cat_na_value_to_level(): 
#### This function will replace any missing values in a categorical array with "Missing" to make sure they appear on plots. 

```
x = categorical([missing, "A", "B", missing, "A"])

cat_na_value_to_level(x)

print(levels(x))

```