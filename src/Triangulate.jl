module Triangulate
using DocStringExtensions

const depsfile = joinpath(@__DIR__, "..", "deps", "deps.jl")

if isfile(depsfile)
    include(depsfile)
else
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
export TriangulateError
export isplots, ispyplot

end

