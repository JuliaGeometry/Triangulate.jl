using Documenter, Triangulate, Literate


function make_all()

    #
    # Generate Markdown pages from examples
    #
    output_dir  = joinpath(@__DIR__,"src","examples")
    example_dir = joinpath(@__DIR__,"..","examples")
    
    for example_source in readdir(example_dir)
        base,ext=splitext(example_source)
        if ext==".jl"
            Literate.markdown(joinpath(@__DIR__,"..","examples",example_source),
                              output_dir,
                              documenter=false,
                              info=true)
        end
    end
    generated_examples=joinpath.("examples",readdir(output_dir))

    
    makedocs(
        sitename="Triangulate.jl",
        modules = [Triangulate],
        clean = true,
        doctest = false,
        authors = "Juergen Fuhrmann, Francesco Furiani, Konrad Simon",
        repo="https://github.com/JuliaGeometry/Triangulate.jl",
        pages=[ 
            "Home"=>"index.md",
            "triangle-h.md",
            "changes.md",
            "allindex.md",
            "Examples" => generated_examples
        ]
    )
    
    if !isinteractive()
        deploydocs(repo = "github.com/JuliaGeometry/Triangulate.jl.git")
    end
end

make_all()
