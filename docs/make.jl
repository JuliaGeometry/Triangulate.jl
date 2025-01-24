using Documenter, Triangulate, Pluto, Pkg

function rendernotebook(name)
    input = joinpath(@__DIR__, "..", "examples", name * ".jl")
    output = joinpath(@__DIR__, "src", name * ".html")
    session = Pluto.ServerSession()
    ENV["PLUTO_PROJECT"] = joinpath(@__DIR__, "..", "examples")
    notebook = Pluto.SessionActions.open(session, input; run_async = false)
    html_contents = Pluto.generate_html(notebook)
    return write(output, html_contents)
end

function make_all()
    Pkg.activate(joinpath(@__DIR__, "..", "examples"))
    Pkg.develop(; path = joinpath(@__DIR__, ".."))
    Pkg.instantiate()
    rendernotebook("pluto-examples")
    Pkg.activate(@__DIR__)

    makedocs(;
        sitename = "Triangulate.jl",
        modules = [Triangulate],
        clean = false,
        doctest = false,
        authors = "Juergen Fuhrmann, Francesco Furiani, Konrad Simon",
        repo = "https://github.com/JuliaGeometry/Triangulate.jl",
        pages = [
            "Home" => "index.md",
            "triangle-h.md",
            "Major changes" => "changes.md",
            "allindex.md",
            "examples.md",
        ]
    )

    return if !isinteractive()
        deploydocs(; repo = "github.com/JuliaGeometry/Triangulate.jl.git")
    end
end

make_all()
