using Documenter, Triangulate, Literate, Pluto

function rendernotebook(name)
    input = joinpath(@__DIR__, "..", "examples", name * ".jl")
    output = joinpath(@__DIR__, "src", name * ".html")
    session = Pluto.ServerSession()
    ENV["PLUTO_PROJECT"] = joinpath(@__DIR__, "..", "examples")
    notebook = Pluto.SessionActions.open(session, input; run_async = false)
    html_contents = Pluto.generate_html(notebook)
    write(output, html_contents)
end

function make_all()
    rendernotebook("pluto-examples")

    makedocs(; sitename = "Triangulate.jl",
             modules = [Triangulate],
             clean = false,
             doctest = false,
             authors = "Juergen Fuhrmann, Francesco Furiani, Konrad Simon",
             repo = "https://github.com/JuliaGeometry/Triangulate.jl",
             pages = [
                 "Home" => "index.md",
                 "triangle-h.md",
                 "changes.md",
                 "allindex.md",
                 "examples.md",
             ])

    if !isinteractive()
        deploydocs(; repo = "github.com/JuliaGeometry/Triangulate.jl.git")
    end
end

make_all()
