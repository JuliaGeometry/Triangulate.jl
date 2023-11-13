module Triangulate
using DocStringExtensions
using Triangle_jll
using Compat: @compat

include("ctriangulateio.jl")
include("triangulateio.jl")
include("plot.jl")

export triangulate
export triunsuitable!, triunsuitable
export TriangulateIO
export numberofpoints
export numberofsegments
export numberoftriangles
export TriangulateError
export plot_triangulateio, plot_in_out
export isplots, ispyplot

@compat public triangulate, triunsuitable, triunsuitable!
@compat public numberofpoints, numberofsegments, numberoftriangles
@compat public TriangulateError
@compat public plot_triangulateio, plot_in_out
@compat public isplots, ispyplot

end
