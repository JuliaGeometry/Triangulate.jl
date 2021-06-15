module Triangulate
using DocStringExtensions
using Triangle_jll

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
export plot_triangulateio, plot_in_out, isplots, ispyplot

end

