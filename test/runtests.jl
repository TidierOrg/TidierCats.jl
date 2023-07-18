module TestTidierCats

using TidierCats
using Test
using Documenter

DocMeta.setdocmeta!(TidierCats, :DocTestSetup, :(using TidierCats); recursive=true)

doctest(TidierCats)

end
