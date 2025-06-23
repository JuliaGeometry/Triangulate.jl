module Triangulate
using DocStringExtensions
using Triangle_jll

include("ctriangulateio.jl")
include("triangulateio.jl")

export triangulate
export triunsuitable!
export TriangulateIO
export numberofpoints
export numberofsegments
export numberoftriangles
export TriangulateError

end
