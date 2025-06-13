# Triangulations of point sets
# ===========================
#
#
# These examples can be loaded into Julia (Revise.jl recommended)
# and run by calling one of the methods with the optional arguments "Plotter=PyPlot".
# Alternatively, you can download a [jupyter notebook](example_pointsets.ipynb) created
# from this source.
#
#
#---
#
# Set  up environment

using Triangulate
using Test

# ### Delaunay triangulation of point set
#
# Create a set of random points in the plane and calculate
# the Delaunay triangulation of this set of points. It is a triangulation
# where for each triangle, the interior of its circumcircle  does not contain any points
# of the trianglation.
#
# The Delaunay triangulation of a set of points in general position
# (no 4 of them on a circle) is unique. At the same time, it is a
# triangulation of the convex hull of these points.
#
# Given an input list of points, without any further flags, Triangle creates
# just this triangulation (the "Q" flag suppresses the text output of Triangle).
# For this and the next examples, the input list of points is created randomly,
# but on a raster, preventing the appearance of too close points.
#
function example_convex_hull(; Plotter = nothing, n = 10, raster = 10)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = hcat(unique([Cdouble[rand(1:raster) / raster, rand(1:raster) / raster] for i in 1:n])...)
    (triout, vorout) = triangulate("Q", triin)
    @test numberofpoints(triin) == numberofpoints(triout)
    return @test numberoftriangles(triout) > 0
end
#

# ### Delaunay triangulation of point set with boundary
#
# Same as the previous example, but in addition specify the "c" flag
# In this case, Triangle outputs an additional list of segments
# describing the boundary of the convex hull. In fact this is a constrained
# Delaunay triangulation (CDT) where the boundary segments
# are the seen constraining edges which must appear in the output.
function example_convex_hull_with_boundary(; Plotter = nothing, n = 10, raster = 10)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = hcat(unique([Cdouble[rand(1:raster) / raster, rand(1:raster) / raster] for i in 1:n])...)
    (triout, vorout) = triangulate("cQ", triin)
    @test numberofpoints(triin) == numberofpoints(triout)
    @test numberoftriangles(triout) > 0
    return @test numberofsegments(triout) > 0
end
#

# ### Delaunay triangulation of point set with Voronoi diagram
#
# Same as the previous example, but instead of "c" specify the "v" flag
# In this case, Triangle outputs information about the Voronoi diagram
# of the point set which is a structure dual to  the Delaunay triangulation.
#
# The Voronoi cell around a point $p$ a point set $S$ is defined
# as the set of points $x$ such that $|x-p|<|x-q|$ for all $q\in S$
# such that $p\neq q$.
# The Voronoi cells of boundary points
# of the convex hull are of infinite size. The corners of the Voronoi
# cells are the circumcenters of the triangles. They can be far
# outside of the triangulated domain.
function example_convex_hull_voronoi(; Plotter = nothing, n = 10, raster = 10)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = hcat(unique([Cdouble[rand(1:raster) / raster, rand(1:raster) / raster] for i in 1:n])...)
    (triout, vorout) = triangulate("vQ", triin)
    @test numberofpoints(triin) == numberofpoints(triout)
    @test numberoftriangles(triout) > 0
    return @test numberofpoints(vorout) > 0
end
#

# ### Boundary conforming Delaunay triangulation of point set
# Specify "c" flag for convex hull segments, "v" flag for Voronoi
# and "D" flag for creating a boundary conforming Delaunay triangulation of
# the point set. In this case additional points are created which split
# the boundary segments and ensure that all triangle circumcenters
# lie within the convex hull.
# Due to random input, there may be situations where Triangle fails with this task,
# so we check for the corresponding exception.
function example_convex_hull_voronoi_delaunay(; Plotter = nothing, n = 10, raster = 10)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = hcat(unique([Cdouble[rand(1:raster) / raster, rand(1:raster) / raster] for i in 1:n])...)
    return try
        (triout, vorout) = triangulate("vcDQ", triin)
        @test numberofpoints(triin) <= numberofpoints(triout)
        @test numberoftriangles(triout) > 0
        @test numberofpoints(vorout) > 0
    catch err
        if typeof(err) == TriangulateError
            println("Triangle had some problem.")
            return true
        end
    end
end
#

# ### Constrained Delaunay triangulation (CDT) of a point set with edges
# Constrained Delaunay triangulation (CDT) of a point set with
# additional constraints given a priori. This is obtained when
# specifying the "p" flag and an additional list of segments each described
# by two points
# which should become edges of the triangulation. Note that
# the resulting triangulation is not Delaunay in the sense
# given above.
function example_cdt(; Plotter = nothing, n = 10, raster = 10)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = hcat(unique([Cdouble[rand(1:raster) / raster, rand(1:raster) / raster] for i in 1:n])...)
    npt = size(triin.pointlist, 2)
    triin.segmentlist = Matrix{Cint}([1 2; npt - 1 npt - 2; 1 npt]')
    triin.segmentmarkerlist = Vector{Cint}([2, 3, 4])
    (triout, vorout) = triangulate("pcQ", triin)
    @test numberofpoints(triin) <= numberofpoints(triout)
    @test numberofsegments(triout) >= numberofsegments(triin)
    return @test numberoftriangles(triout) > 0
end
#
