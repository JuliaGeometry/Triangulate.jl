module TriangleRaw
using DocStringExtensions

include("ctriangulateio.jl")
include("triangulateio.jl")
include("plot.jl")

export triangulate
export triunsuitable
export TriangulateIO
export numberofpoints
export numberofsegments
export numberoftriangles

end # module Triangle
