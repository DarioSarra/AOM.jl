using Documenter, AOM

makedocs(;
    modules=[AOM],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/DarioSarra/AOM.jl/blob/{commit}{path}#L{line}",
    sitename="AOM.jl",
    authors="Dario Sarra",
    assets=String[],
)

deploydocs(;
    repo="github.com/DarioSarra/AOM.jl",
)
