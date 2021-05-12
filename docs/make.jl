using ComoniconOptions
using Documenter

DocMeta.setdocmeta!(ComoniconOptions, :DocTestSetup, :(using ComoniconOptions); recursive=true)

makedocs(;
    modules=[ComoniconOptions],
    authors="Roger-Luo <rogerluo.rl18@gmail.com> and contributors",
    repo="https://github.com/Roger-luo/ComoniconOptions.jl/blob/{commit}{path}#{line}",
    sitename="ComoniconOptions.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Roger-luo.github.io/ComoniconOptions.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Roger-luo/ComoniconOptions.jl",
)
