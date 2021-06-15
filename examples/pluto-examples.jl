### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 8af90e7a-0e5e-4a9d-b39e-f7603fc1e25e
begin 
	using Pkg
	Pkg.activate(mktempdir())
	ENV["LC_NUMERIC"]="C"
	Pkg.add("Revise")
	using Revise
	Pkg.develop("Triangulate")
	Pkg.add("PyPlot")
	Pkg.add("PlutoUI")
	
	using Triangulate, PyPlot, PlutoUI, Printf
	PyPlot.svg(true);
end

# ╔═╡ 7b468c8a-ce16-11eb-3009-f9e4c79e6c17
md"""
# Triangulate examples
$(TableOfContents(title=""))
## Triangulations of point sets
"""

# ╔═╡ 83f07f94-7e35-42de-9214-715c92b6dddd
md"""
### Delaunay triangulation (DT)

The Delaunay triangulation of a set of points is a triangulation
where for each triangle, the interior of its circumcircle  does not contain any points
of the triangulation.

The Delaunay triangulation of a set of points in general position
(no 4 of them on a circle) is unique. At the same time, it is a
triangulation of the convex hull of these points.

Given an input list of points, without any further flags, Triangle creates
just this triangulation (the "Q" flag suppresses the text output of Triangle).
For this and the next examples, the input list of points is created randomly,
but on a raster, preventing the appearance of too close points.

"""

# ╔═╡ c56434f3-e0a4-462e-86d5-fcfbb6778c11
md"""
### DT with boundary
Same as the previous example, but in addition specify the "c" flag.

In this case, Triangle outputs an additional list of segments
describing the boundary of the convex hull. In fact this is a constrained
Delaunay triangulation (CDT) where the boundary segments
are the seen constraining edges which must appear in the output.

"""

# ╔═╡ f13ad00e-a3d3-462f-93d4-ebe1fe4a7b4d
md"""
### DT with Voronoi diagram

Same as the previous example, but instead of "c" specify the "v" flag.
In this case, Triangle outputs information about the Voronoi diagram
of the point set which is a structure dual to  the Delaunay triangulation.

The Voronoi cell around a point $p$ a point set $S$ is defined
as the set of points $x$ such that $|x-p|<|x-q|$ for all $q\in S$
such that $p\neq q$.
The Voronoi cells of boundary points
of the convex hull are of infinite size. The corners of the Voronoi
cells are the circumcenters of the triangles. They can be far
outside of the triangulated domain.

"""

# ╔═╡ 852e1ebf-3f29-472a-945e-53920d7653be
md"""
### Boundary conforming DT (BCDT)
Specify "c" flag for convex hull segments, "v" flag for Voronoi
and "D" flag for creating a boundary conforming Delaunay triangulation of
the point set. 

In this case additional points ("Steiner points") are created which split
the boundary segments and ensure that all triangle circumcenters
lie within the convex hull.
Due to random input, there may be situations where Triangle fails with this task,
so we check for the corresponding exception.

"""

# ╔═╡ b95859af-ab21-4c41-b095-82b3ea39724a
md"""
### Constrained DT (CDT) 
Constrained Delaunay triangulation (CDT) of a point set with
additional constraints given a priori. This is obtained when
specifying the "p" flag and an additional list of segments each described
by two points 
which should become edges of the triangulation. Note that
the resulting triangulation is not Delaunay in the sense
given above.

"""

# ╔═╡ c5a87fb5-c264-498d-aa7c-91d9e6d7bfe2
md"""
## Triangulations of domains
"""

# ╔═╡ 7f2b4252-a827-4de4-abb6-42d1bbde44b9
md"""
### CDT of a domain 

Specification is similar to that of the CDT of a point set.

The domain is given by a segment list specifying its boundary.

This is obtained by specifying the "p" flag.

"""

# ╔═╡ 6793711b-d476-45c6-8b2b-b1d0693d8e6e
md"""
### CDT with maximum area constraint

This constraint is specfied as a floating
point number given after the -a flag.
Be careful to not give it in the exponential format as Triangle would be unable to analyse it.
Therefore it is dangerous to provide it via string interpolation and it is better to convert it to a string before using `@sprintf`.

Specifying only the maximum area constraint does not prevent very thin
triangles from occuring at the boundary.

"""

# ╔═╡ 3f2f0b19-3c13-482d-abd5-e6325802c6e8
md"""
### BCDT with maximum area constraint 

In addition to the area constraint specify the -D flag
in order to keep the triangle circumcenters  within the domain.

"""

# ╔═╡ 14145886-2a5f-4ae8-bf00-a5eaaa7e0568
md"""
### CDT with minimum angle condition

The "q" flag  allows to specify a minimum angle
constraint preventing skinny triangles.

This combination of flags, possibly with an additional "D" flag is recommended
when creating triangulations for finite element or finite volume methods.
It the mimimum angle is larger then 28.6 degrees, Triangle's algorithm may
run into an infinite loop.

"""

# ╔═╡ 61dc30ce-9256-4f20-9163-e8d473ac9e53
md"""
### Triangulation with refinement callback

A maximum area constraint is specified in the `unsuitable` callback
which is activated via the "u" flag if it has been passed before calling triangulate.

In addition, the "q" flag  allows to specify a minimum angle
constraint preventing skinny triangles.

"""

# ╔═╡ 30990760-92e1-4a26-98a5-b43be658dee7
md"""
### Triangulation of a heterogeneous domain

The segment list specifies its boundary and the inner boundary between subdomains.
An additional region list is specified which provides "region points" in `regionlist[1,:]`
and `regionlist[2,:]`.  These kind of mark the subdomains. `regionlist[3,:]` contains an attribute
which labels the subdomains. `regionlist[4,:]` contains a maximum area value. `size(regionlist,2)`
is the number of regions.

With the "A" flag, the subdomain labels are spread to all triangles in the corresponding
subdomains, becoming available in `triangleattributelist[1,:]`.
With the "a" flag, the area constraints are applied in the corresponding subdomains.

"""

# ╔═╡ 783975f5-cbab-4b23-9155-7a6276cd25df
md"""
### Triangulation of a domain with holes
The segment list specifies its boundary and the boundaries of the holes.
An additional hole list is specified which provides "hole points" in `holelist[1,:]`
and `holelist[2,:]`. 

"""

# ╔═╡ 9a090bba-093b-4ca4-a186-1c43b52cd4ff
html"""<hr>"""

# ╔═╡ 9447e874-22ce-4b99-9037-e0d202430ee2
function pyplot(f;w=650,h=300)
	PyPlot.close()
	PyPlot.clf()
	fig=PyPlot.figure(1,dpi=100)
	fig.set_size_inches(w/100,h/100,forward=true)
	f()
	PyPlot.gcf()
end;

# ╔═╡ a5f7aca5-9e40-471a-bece-34498a804bd8
function example_convex_hull(;n=10,raster=10)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=hcat(unique([ Cdouble[rand(1:raster)/raster, rand(1:raster)/raster] for i in 1:n])...)
    display(triin)
    (triout, vorout)=triangulate("Q", triin)
	pyplot() do
		plot_in_out(PyPlot,triin,triout,title="Convex hull",circumcircles=true)
	end
end

# ╔═╡ d0e63ebd-9288-42d5-9735-3c94a2baa8e3
example_convex_hull(;n=10,raster=10)

# ╔═╡ 6f3f0014-42bc-4565-a03e-208fed8b8f48
function example_convex_hull_with_boundary(;n=10,raster=10)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=hcat(unique([ Cdouble[rand(1:raster)/raster, rand(1:raster)/raster] for i in 1:n])...)
    display(triin)
    (triout, vorout)=triangulate("cQ", triin)
	pyplot() do
    	plot_in_out(PyPlot,triin,triout,title="Convex hull with boundary")
	end
end


# ╔═╡ 6ec811ca-e6d3-43ea-8da9-02bb05060d8d
example_convex_hull_with_boundary(;n=10,raster=10)

# ╔═╡ 6e2d70c4-dc0f-4672-823a-930a50114811
function example_convex_hull_voronoi(;n=10,raster=10)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=hcat(unique([ Cdouble[rand(1:raster)/raster, rand(1:raster)/raster] for i in 1:n])...)
    (triout, vorout)=triangulate("vQ", triin)
	pyplot() do
    plot_in_out(PyPlot,triin,triout,voronoi=vorout,title="Convex hull with Voronoi diagram")
	end
end


# ╔═╡ 0b54833f-0458-4417-aa03-27c4fe2a873c
example_convex_hull_voronoi(;n=10,raster=10)

# ╔═╡ 1ee0af11-96e4-4929-926e-d7143ed1f791
function example_convex_hull_voronoi_delaunay(;n=10,raster=10)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=hcat(unique([ Cdouble[rand(1:raster)/raster, rand(1:raster)/raster] for i in 1:n])...)
    try
        (triout, vorout)=triangulate("vcDQ", triin)
		pyplot() do
        plot_in_out(PyPlot,triin,triout,voronoi=vorout,title="Convex hull with Voronoi diagram")
		end
    catch err
        if typeof(err)==TriangulateError
            println("Triangle had some problem.")
            return true
        end
    end
end


# ╔═╡ 4da9a598-bf59-4b3b-aea7-ee1c2721c206
 example_convex_hull_voronoi_delaunay(;n=10,raster=10)

# ╔═╡ 0d648d22-aa03-437b-b019-59bd693bc55e
function example_cdt(;n=10,raster=10)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=hcat(unique([ Cdouble[rand(1:raster)/raster, rand(1:raster)/raster] for i in 1:n])...)
    npt=size(triin.pointlist,2)
    triin.segmentlist=Matrix{Cint}([1 2; npt-1 npt-2;  1 npt;]')
    triin.segmentmarkerlist=Vector{Cint}([2,3,4])
    (triout, vorout)=triangulate("pcQ", triin)
	pyplot() do
    plot_in_out(PyPlot,triin,triout,title="CDT")
	end
end


# ╔═╡ 910ce428-4989-4b08-8037-887dae5c847e
example_cdt(;n=10,raster=10)

# ╔═╡ ccd8ed8d-7991-4a19-8a05-65761adc2fee
function example_domain_cdt()
    triin=Triangulate.TriangulateIO()
    triin.pointlist=Matrix{Cdouble}([0.0 0.0 ; 1.0 0.0 ; 1.0  1.0 ; 0.6 0.6; 0.0 1.0]')
    triin.segmentlist=Matrix{Cint}([1 2 ; 2 3 ; 3 4 ; 4 5 ; 5 1 ]')
    triin.segmentmarkerlist=Vector{Int32}([1, 2, 3, 4, 5])
    (triout, vorout)=triangulate("pQ", triin)
	pyplot() do
    plot_in_out(PyPlot,triin,triout,title="Domain CDT")
	end
end


# ╔═╡ fc5264cf-b1f7-43c5-bcff-09e6274ca215
example_domain_cdt()

# ╔═╡ b71b1faf-ff3f-4404-8a2c-9de84fa498f7
function example_domain_cdt_area(;maxarea=0.05)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=Matrix{Cdouble}([0.0 0.0 ; 1.0 0.0 ; 1.0  1.0 ; 0.6 0.6; 0.0 1.0]')
    triin.segmentlist=Matrix{Cint}([1 2 ; 2 3 ; 3 4 ; 4 5 ; 5 1 ]')
    triin.segmentmarkerlist=Vector{Int32}([1, 2, 3, 4, 5])
    area=@sprintf("%.15f",maxarea) # Don't use exponential format!
    (triout, vorout)=triangulate("pa$(area)Q", triin)
	pyplot() do
    plot_in_out(PyPlot,triin,triout,voronoi=vorout, title="Domain CDT with area constraint",circumcircles=true)
	end
end

# ╔═╡ cd007961-7f0e-4c56-9c86-1a9827a71e3e
example_domain_cdt_area(;maxarea=0.05)

# ╔═╡ 8ac6cc0b-e4e7-4aa0-bc37-b22b15bf2a83
function example_domain_bcdt_area(;maxarea=0.05)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=Matrix{Cdouble}([0.0 0.0 ; 1.0 0.0 ; 1.0  1.0 ; 0.6 0.6; 0.0 1.0]')
    triin.segmentlist=Matrix{Cint}([1 2 ; 2 3 ; 3 4 ; 4 5 ; 5 1 ]')
    triin.segmentmarkerlist=Vector{Int32}([1, 2, 3, 4, 5])
    area=@sprintf("%.15f",maxarea)
    (triout, vorout)=triangulate("pa$(area)DQ", triin)
	pyplot() do
    plot_in_out(PyPlot,triin,triout,voronoi=vorout, title="Boundary conforming Delaunay triangulation", circumcircles=true)

	end
end

# ╔═╡ a0cb6060-8278-444a-a4e5-46055d98616c
example_domain_bcdt_area(;maxarea=0.05)

# ╔═╡ a7e97f1c-e091-4555-abc0-a71abd22dd8a
function example_domain_qcdt_area(;minangle=20, maxarea=0.05)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=Matrix{Cdouble}([0.0 0.0 ; 1.0 0.0 ; 1.0  1.0 ; 0.6 0.6; 0.0 1.0]')
    triin.segmentlist=Matrix{Cint}([1 2 ; 2 3 ; 3 4 ; 4 5 ; 5 1 ]')
    triin.segmentmarkerlist=Vector{Int32}([1, 2, 3, 4, 5])
    area=@sprintf("%.15f",maxarea)
    angle=@sprintf("%.15f",minangle)
    (triout, vorout)=triangulate("pa$(area)q$(angle)", triin)
	pyplot() do
    plot_in_out(PyPlot,triin,triout,voronoi=vorout, title="Quality triangulation")
	end
end

# ╔═╡ 4e7dad4d-7d3c-4201-a56f-28e3df51e885
example_domain_qcdt_area(;maxarea=0.05,minangle=20)

# ╔═╡ 083b8aef-67f1-489a-8eff-b70fb6dc9da4
function example_domain_localref(;minangle=20)
    center_x=0.6
    center_y=0.6
    localdist=0.1
    function unsuitable(x1,y1,x2,y2,x3,y3,area)
        bary_x=(x1+x2+x3)/3.0
        bary_y=(y1+y2+y3)/3.0
        dx=bary_x-center_x
        dy=bary_y-center_y
        qdist=dx^2+dy^2
        qdist>1.0e-5 && area>0.1*qdist
    end

    triunsuitable(unsuitable)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=Matrix{Cdouble}([0.0 0.0 ; 1.0 0.0 ; 1.0  1.0 ; 0.6 0.6; 0.0 1.0]')
    triin.segmentlist=Matrix{Cint}([1 2 ; 2 3 ; 3 4 ; 4 5 ; 5 1 ]')
    triin.segmentmarkerlist=Vector{Int32}([1, 2, 3, 4, 5])
    angle=@sprintf("%.15f",minangle)
    (triout, vorout)=triangulate("pauq$(angle)Q", triin)
	pyplot() do
    plot_in_out(PyPlot,triin,triout,voronoi=vorout, title="Quality triangulation with local refinement")
	end
end


# ╔═╡ 3c88e5cb-5e85-4146-a6d7-3682f4b9a892
example_domain_localref(;minangle=20)

# ╔═╡ f0f9922b-70ce-4866-bc41-349a26095ade
function example_domain_regions(;minangle=20)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=Matrix{Cdouble}([0.0 0.0 ;0.5 0.0; 1.0 0.0 ; 1.0  1.0 ; 0.6 0.6; 0.0 1.0]')
    triin.segmentlist=Matrix{Cint}([1 2 ; 2 3 ;3 4 ; 4 5 ; 5 6 ; 6 1 ; 2 5]')
    triin.segmentmarkerlist=Vector{Int32}([1, 2, 3, 4, 5, 6, 7])
    triin.regionlist=Matrix{Cdouble}([0.2 0.8; 0.2 0.2; 1 2 ; 0.01 0.05])
    angle=@sprintf("%.15f",minangle)
    (triout, vorout)=triangulate("paAq$(angle)Q", triin)
	pyplot() do
    plot_in_out(PyPlot,triin,triout,voronoi=vorout, title="Hetero domain triangulation")
	end
end


# ╔═╡ 58dbd0e3-b34f-44ec-905a-488c7bbd07ca
example_domain_regions(minangle=20)

# ╔═╡ 3dfe5acd-72f7-4510-b3a0-40364f679073
function example_domain_holes(;minangle=20,maxarea=0.001)
    triin=Triangulate.TriangulateIO()
    triin.pointlist=Matrix{Cdouble}([0.0 0.0;
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
                                     0.6 0.7;                                     
                                     ]')
    triin.segmentlist=Matrix{Cint}([1 2; 2 3; 3 4; 4 1; 5 6; 6 7; 7 8; 8 5;  9 10; 10 11; 11 12; 12 9;]')
    triin.segmentmarkerlist=Vector{Int32}([1, 1,1,1, 2,2,2,2, 3,3,3,3])
    triin.holelist=[0.25 0.25; 0.65 0.65;]'
    area=@sprintf("%.15f",maxarea) # Don't use exponential format!
    angle=@sprintf("%.15f",minangle)
    (triout, vorout)=triangulate("pa$(area)q$(angle)Q", triin)
 
	pyplot() do
    plot_in_out(PyPlot,triin,triout,voronoi=vorout, title="Domain with holes")
	end
end


# ╔═╡ 6545d149-d4dd-4f26-8f51-5db90f6b444d
example_domain_holes(minangle=20,maxarea=0.05)

# ╔═╡ Cell order:
# ╟─7b468c8a-ce16-11eb-3009-f9e4c79e6c17
# ╟─83f07f94-7e35-42de-9214-715c92b6dddd
# ╠═a5f7aca5-9e40-471a-bece-34498a804bd8
# ╠═d0e63ebd-9288-42d5-9735-3c94a2baa8e3
# ╟─c56434f3-e0a4-462e-86d5-fcfbb6778c11
# ╠═6f3f0014-42bc-4565-a03e-208fed8b8f48
# ╠═6ec811ca-e6d3-43ea-8da9-02bb05060d8d
# ╟─f13ad00e-a3d3-462f-93d4-ebe1fe4a7b4d
# ╠═6e2d70c4-dc0f-4672-823a-930a50114811
# ╠═0b54833f-0458-4417-aa03-27c4fe2a873c
# ╟─852e1ebf-3f29-472a-945e-53920d7653be
# ╠═1ee0af11-96e4-4929-926e-d7143ed1f791
# ╠═4da9a598-bf59-4b3b-aea7-ee1c2721c206
# ╟─b95859af-ab21-4c41-b095-82b3ea39724a
# ╠═0d648d22-aa03-437b-b019-59bd693bc55e
# ╠═910ce428-4989-4b08-8037-887dae5c847e
# ╟─c5a87fb5-c264-498d-aa7c-91d9e6d7bfe2
# ╟─7f2b4252-a827-4de4-abb6-42d1bbde44b9
# ╠═ccd8ed8d-7991-4a19-8a05-65761adc2fee
# ╠═fc5264cf-b1f7-43c5-bcff-09e6274ca215
# ╟─6793711b-d476-45c6-8b2b-b1d0693d8e6e
# ╠═b71b1faf-ff3f-4404-8a2c-9de84fa498f7
# ╠═cd007961-7f0e-4c56-9c86-1a9827a71e3e
# ╟─3f2f0b19-3c13-482d-abd5-e6325802c6e8
# ╠═8ac6cc0b-e4e7-4aa0-bc37-b22b15bf2a83
# ╠═a0cb6060-8278-444a-a4e5-46055d98616c
# ╟─14145886-2a5f-4ae8-bf00-a5eaaa7e0568
# ╠═a7e97f1c-e091-4555-abc0-a71abd22dd8a
# ╠═4e7dad4d-7d3c-4201-a56f-28e3df51e885
# ╟─61dc30ce-9256-4f20-9163-e8d473ac9e53
# ╠═083b8aef-67f1-489a-8eff-b70fb6dc9da4
# ╠═3c88e5cb-5e85-4146-a6d7-3682f4b9a892
# ╟─30990760-92e1-4a26-98a5-b43be658dee7
# ╠═f0f9922b-70ce-4866-bc41-349a26095ade
# ╠═58dbd0e3-b34f-44ec-905a-488c7bbd07ca
# ╟─783975f5-cbab-4b23-9155-7a6276cd25df
# ╠═3dfe5acd-72f7-4510-b3a0-40364f679073
# ╠═6545d149-d4dd-4f26-8f51-5db90f6b444d
# ╟─9a090bba-093b-4ca4-a186-1c43b52cd4ff
# ╠═8af90e7a-0e5e-4a9d-b39e-f7603fc1e25e
# ╠═9447e874-22ce-4b99-9037-e0d202430ee2
