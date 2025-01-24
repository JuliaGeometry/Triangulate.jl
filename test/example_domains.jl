# Triangulations of domains
# ===========================
#
# These examples can be loaded into Julia (Revise.jl recommended)
# and run by calling one of the methods with the optional arguments "Plotter=PyPlot".
# Alternatively, you can download a [jupyter notebook](example_domains.ipynb) created
# from this source.
#---
#
# Set  up environment

using Triangulate
using Test
using Printf

injupyter() = (isdefined(Main, :IJulia) && Main.IJulia.inited)

if injupyter()
    import PyPlot
end

# ### Constrained Delaunay triangulation (CDT) of a domain given by a segment list specifying its boundary.
#
# This is obtained by
# specifying the "p" flag.
function example_domain_cdt(; Plotter = nothing)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = Matrix{Cdouble}([0.0 0.0; 1.0 0.0; 1.0 1.0; 0.6 0.6; 0.0 1.0]')
    triin.segmentlist = Matrix{Cint}([1 2; 2 3; 3 4; 4 5; 5 1]')
    triin.segmentmarkerlist = Vector{Int32}([1, 2, 3, 4, 5])
    (triout, vorout) = triangulate("pQ", triin)
    plot_in_out(Plotter, triin, triout; title = "Domain triangulation")
    @test numberofpoints(triout) >= numberofpoints(triin)
    @test numberofsegments(triout) >= numberofsegments(triin)
    return @test numberoftriangles(triout) > 0
end
#
injupyter() && example_domain_cdt(; Plotter = PyPlot);

# ### Constrained Delaunay triangulation (CDT) of a domain given by a segment list specifying its boundary together with a maximum  area constraint.
#
# This constraint is specified as a floating
# point number given after the -a flag.
# Be careful to not give it in the exponential format as Triangle would be unable to analyse it.
# Therefore it is dangerous to a number in the string interpolation and it is better to convert
# it to a string before using `@sprintf`.
# Specifying only the maximum area constraint does not prevent very thin
# triangles from occurring at the boundary.
function example_domain_cdt_area(; Plotter = nothing, maxarea = 0.05)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = Matrix{Cdouble}([0.0 0.0; 1.0 0.0; 1.0 1.0; 0.6 0.6; 0.0 1.0]')
    triin.segmentlist = Matrix{Cint}([1 2; 2 3; 3 4; 4 5; 5 1]')
    triin.segmentmarkerlist = Vector{Int32}([1, 2, 3, 4, 5])
    area = @sprintf("%.15f", maxarea) # Don't use exponential format!
    (triout, vorout) = triangulate("pa$(area)Q", triin)
    plot_in_out(Plotter, triin, triout; voronoi = vorout, title = "Domain CDT with area constraint")
    @test numberofpoints(triout) >= numberofpoints(triin)
    @test numberofsegments(triout) >= numberofsegments(triin)
    return @test numberoftriangles(triout) > 0
end
#
injupyter() && example_domain_cdt_area(; Plotter = PyPlot, maxarea = 0.05);

# ### Boundary conforming  Delaunay triangulation (BCDT) of a domain given by a segment list specifying its boundary
# In addition to the area constraint specify the -D flag
# in order to keep the triangle circumcenters  within the domain.
function example_domain_bcdt_area(; Plotter = nothing, maxarea = 0.05)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = Matrix{Cdouble}([0.0 0.0; 1.0 0.0; 1.0 1.0; 0.6 0.6; 0.0 1.0]')
    triin.segmentlist = Matrix{Cint}([1 2; 2 3; 3 4; 4 5; 5 1]')
    triin.segmentmarkerlist = Vector{Int32}([1, 2, 3, 4, 5])
    area = @sprintf("%.15f", maxarea)
    (triout, vorout) = triangulate("pa$(area)DQ", triin)
    plot_in_out(Plotter, triin, triout; voronoi = vorout, title = "Boundary conforming Delaunay triangulation")
    @test numberofpoints(triout) >= numberofpoints(triin)
    @test numberofsegments(triout) >= numberofsegments(triin)
    return @test numberoftriangles(triout) > 0
end
#
injupyter() && example_domain_bcdt_area(; Plotter = PyPlot, maxarea = 0.05);

# ### Constrained Delaunay triangulation of a domain with minimum angle condition
#
# The "q" flag  allows to specify a minimum angle
# constraint preventing skinny triangles.
#
# This combination of flags, possibly with an additional "D" flag is recommended
# when creating triangulations for finite element or finite volume methods.
# It the minimum angle is larger then 28.6 degrees, Triangle's algorithm may
# run into an infinite loop.
function example_domain_qcdt_area(; Plotter = nothing, minangle = 20, maxarea = 0.05)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = Matrix{Cdouble}([0.0 0.0; 1.0 0.0; 1.0 1.0; 0.6 0.6; 0.0 1.0]')
    triin.segmentlist = Matrix{Cint}([1 2; 2 3; 3 4; 4 5; 5 1]')
    triin.segmentmarkerlist = Vector{Int32}([1, 2, 3, 4, 5])
    area = @sprintf("%.15f", maxarea)
    angle = @sprintf("%.15f", minangle)
    (triout, vorout) = triangulate("pa$(area)Qq$(angle)", triin)
    plot_in_out(Plotter, triin, triout; voronoi = vorout, title = "Quality triangulation")
    @test numberofpoints(triout) >= numberofpoints(triin)
    @test numberofsegments(triout) >= numberofsegments(triin)
    return @test numberoftriangles(triout) > 0
end
#
injupyter() && example_domain_qcdt_area(; Plotter = PyPlot, maxarea = 0.05, minangle = 20);

# ### Triangulation of a domain with refinement callback
#
# A maximum area constraint is specified in the `unsuitable` callback
# which is activated via the "u" flag if it has been passed before calling triangulate.
# In addition, the "q" flag  allows to specify a minimum angle
# constraint preventing skinny triangles.
function example_domain_localref(; Plotter = nothing, minangle = 20)
    center_x = 0.6
    center_y = 0.6
    localdist = 0.1
    function unsuitable(x1, y1, x2, y2, x3, y3, area)
        bary_x = (x1 + x2 + x3) / 3.0
        bary_y = (y1 + y2 + y3) / 3.0
        dx = bary_x - center_x
        dy = bary_y - center_y
        qdist = dx^2 + dy^2
        return qdist > 1.0e-5 && area > 0.1 * qdist
    end

    triunsuitable(unsuitable)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = Matrix{Cdouble}([0.0 0.0; 1.0 0.0; 1.0 1.0; 0.6 0.6; 0.0 1.0]')
    triin.segmentlist = Matrix{Cint}([1 2; 2 3; 3 4; 4 5; 5 1]')
    triin.segmentmarkerlist = Vector{Int32}([1, 2, 3, 4, 5])
    angle = @sprintf("%.15f", minangle)
    (triout, vorout) = triangulate("pauq$(angle)Q", triin)
    plot_in_out(Plotter, triin, triout; voronoi = vorout, title = "Quality triangulation with local refinement")
    @test numberofpoints(triout) >= numberofpoints(triin)
    @test numberofsegments(triout) >= numberofsegments(triin)
    return @test numberoftriangles(triout) > 0
end
#
injupyter() && example_domain_localref(; Plotter = PyPlot, minangle = 20);

# ### Triangulation of a heterogeneous domain
#
# The segment list specifies its boundary and the inner boundary between subdomains.
# An additional region list is specified which provides "region points" in `regionlist[1,:]`
# and `regionlist[2,:]`.  These kind of mark the subdomains. `regionlist[3,:]` contains an attribute
# which labels the subdomains. `regionlist[4,:]` contains a maximum area value. `size(regionlist,2)`
# is the number of regions.
#
# With the "A" flag, the subdomain labels are spread to all triangles in the corresponding
# subdomains, becoming available in `triangleattributelist[1,:]`.
# With the "a" flag, the area constraints are applied in the corresponding subdomains.
function example_domain_regions(; Plotter = nothing, minangle = 20)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = Matrix{Cdouble}([0.0 0.0; 0.5 0.0; 1.0 0.0; 1.0 1.0; 0.6 0.6; 0.0 1.0]')
    triin.segmentlist = Matrix{Cint}([1 2; 2 3; 3 4; 4 5; 5 6; 6 1; 2 5]')
    triin.segmentmarkerlist = Vector{Int32}([1, 2, 3, 4, 5, 6, 7])
    triin.regionlist = Matrix{Cdouble}([0.2 0.8; 0.2 0.2; 1 2; 0.01 0.05])
    angle = @sprintf("%.15f", minangle)
    (triout, vorout) = triangulate("paAq$(angle)Q", triin)

    plot_in_out(Plotter, triin, triout; voronoi = vorout, title = "Hetero domain triangulation")

    @test numberofpoints(triout) >= numberofpoints(triin)
    @test numberofsegments(triout) >= numberofsegments(triin)
    return @test numberoftriangles(triout) > 0
end
#
injupyter() && example_domain_regions(; Plotter = PyPlot, minangle = 20);

# ### Triangulation of a domain with holes
#
# The segment list specifies its boundary and the boundaries of the holes.
# An additional hole list is specified which provides "hole points" in `holelist[1,:]`
# and `holelist[2,:]`.
function example_domain_holes(; Plotter = nothing, minangle = 20, maxarea = 0.001)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = Matrix{Cdouble}(
        [
            0.0 0.0;
            1.0 0.0;
            1.0 1.0;
            0.0 1.0;
            0.2 0.2;
            0.3 0.2;
            0.3 0.3;
            0.2 0.3;
            0.6 0.6;
            0.7 0.6;
            0.7 0.7;
            0.6 0.7
        ]'
    )
    triin.segmentlist = Matrix{Cint}([1 2; 2 3; 3 4; 4 1; 5 6; 6 7; 7 8; 8 5; 9 10; 10 11; 11 12; 12 9]')
    triin.segmentmarkerlist = Vector{Int32}([1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3])
    triin.holelist = [0.25 0.25; 0.65 0.65]'
    area = @sprintf("%.15f", maxarea) # Don't use exponential format!
    angle = @sprintf("%.15f", minangle)
    (triout, vorout) = triangulate("pa$(area)q$(angle)Q", triin)

    plot_in_out(Plotter, triin, triout; voronoi = vorout, title = "Domain with holes")

    @test numberofpoints(triout) >= numberofpoints(triin)
    @test numberofsegments(triout) >= numberofsegments(triin)
    return @test numberoftriangles(triout) > 0
end
#
injupyter() && example_domain_holes(; Plotter = PyPlot, minangle = 20, maxarea = 0.05);
