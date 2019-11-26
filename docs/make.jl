using Documenter, TriangleRaw


function make_all()
    
    makedocs(
        sitename="TriangleRaw.jl",
        modules = [TriangleRaw],
        clean = true,
        doctest = false,
        authors = "Juergen Fuhrmann, Francesco Furiani, Konrad Simon",
        repo="https://github.com/j-fu/TriangleRaw.jl",
        pages=[ 
            "Home"=>"index.md",
            "triangle-h.md"
        ]
    )
    
    if !isinteractive()
        deploydocs(repo = "github.com/j-fu/TriangleRaw.jl.git")
    end
end

make_all()
