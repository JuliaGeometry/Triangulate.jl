module Triangulate
using DocStringExtensions


const depsfile = joinpath(@__DIR__, "..", "deps", "deps.jl")

if isfile(depsfile)
    include(depsfile)
else
    error("Tetgen not build correctly. Please run Pkg.build(\"TetGen\")")
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

