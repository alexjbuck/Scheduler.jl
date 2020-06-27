using Scheduler
using Documenter

makedocs(;
    modules=[Scheduler],
    authors="Alexander Buck",
    repo="https://github.com/alexjbuck/Scheduler.jl/blob/{commit}{path}#L{line}",
    sitename="Scheduler.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://alexjbuck.github.io/Scheduler.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/alexjbuck/Scheduler.jl",
)
