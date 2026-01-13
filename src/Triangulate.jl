"""
$(README)
"""
module Triangulate
using DocStringExtensions: DocStringExtensions, TYPEDEF, TYPEDFIELDS, TYPEDSIGNATURES, README
using Triangle_jll: Triangle_jll, libtriangle

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
