using Documenter, TriangleRaw


function make_all()
    
    makedocs(
        sitename="TriangleRaw.jl",
        modules = [TriangleRaw],
        clean = true,
        doctest = false,
        authors = "J. Fuhrmann, ...",
#        repo="https://github.com/j-fu/VoronoiFVM.jl",
        pages=[ 
            "Home"=>"index.md",
            ]

    )
    
    if !isinteractive()
        deploydocs(repo = "github.com/j-fu/VoronoiFVM.jl.git")
    end
end

make_all()
