using Documenter, DocumenterMarkdown
using TidierData, TidierCats

DocTestMeta = quote
    using TidierData, TidierCats, Statistics
end
DocMeta.setdocmeta!(TidierCats,
    :DocTestSetup,
    DocTestMeta;
    recursive=true)
makedocs(
    modules=[TidierCats],
    clean=true,
    doctest=false,
    #format   = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    sitename="TidierCats.jl",
    authors="Karandeep Singh et al.",
    strict=[
        :doctest,
        :linkcheck,
        :parse_error,
        :example_block,
        # Other available options are
        # :autodocs_block, :cross_references, :docs_block, :eval_block, :example_block,
        # :footnote, :meta_block, :missing_docs, :setup_block
    ], checkdocs=:all, format=Markdown(), draft=false,
    build=joinpath(@__DIR__, "docs")
)

deploydocs(; repo="github.com/TidierOrg/TidierCats.jl.git", push_preview=true,
    deps=Deps.pip("mkdocs", "pygments", "python-markdown-math", "mkdocs-material",
        "pymdown-extensions", "mkdocstrings", "mknotebooks",
        "pytkdocs_tweaks", "mkdocs_include_exclude_files", "jinja2", "mkdocs-video"),
    make=() -> run(`mkdocs build`), target="site", devbranch="main")