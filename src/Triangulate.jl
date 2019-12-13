module Triangulate
using DocStringExtensions


const depsfile = joinpath(@__DIR__, "..", "deps", "deps.jl")
const buildlog = joinpath(@__DIR__, "..", "deps", "build.log")


println(@__DIR__)
println(depsfile)
println(buildlog)

if isfile(depsfile)
    include(depsfile)
else
    blog = open(buildlog) do file
        read(file, String)
    end
    print(blog)
    error("Triangulate not built correctly. Please run Pkg.build(\"Triangulate\")")
end
function __init__()
    check_deps()
end



include("ctriangulateio.jl")
include("triangulateio.jl")
include("plot.jl")

export triangulate
export triunsuitable
export TriangulateIO
export numberofpoints
export numberofsegments
export numberoftriangles
export isplots, ispyplot

end

