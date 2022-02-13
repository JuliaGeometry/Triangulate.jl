### A Pluto.jl notebook ###
# v0.18.0

using Markdown
using InteractiveUtils

# ╔═╡ 8af90e7a-0e5e-4a9d-b39e-f7603fc1e25e
begin 
	ENV["LC_NUMERIC"]="C" # necessary for ensuring 
	                      # proper parallel use of PyPlot and Triangulate
	using Triangulate, PyPlot, PlutoUI, Printf
	PyPlot.svg(true)
end;

# ╔═╡ 7b468c8a-ce16-11eb-3009-f9e4c79e6c17
md"""
# Triangulate examples
$(TableOfContents(title="",aside=false))
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
# Wrap "Pyplotting" into this function in order to shield calling code
# from all these peculiarities.
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
end;

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
end;

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
end;

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
end;

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
end;

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
end;

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
end;

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
end;

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
end;

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
end;

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
end;

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
end;

# ╔═╡ 6545d149-d4dd-4f26-8f51-5db90f6b444d
example_domain_holes(minangle=20,maxarea=0.05)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Printf = "de0858da-6303-5e67-8744-51eddeeeb8d7"
PyPlot = "d330b81b-6aea-500a-939a-2ce795aea3ee"
Triangulate = "f7e6ffb2-c36d-4f8f-a77e-16e897189344"

[compat]
PlutoUI = "~0.7.34"
PyPlot = "~2.10.0"
Triangulate = "~2.1.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[Conda]]
deps = ["Downloads", "JSON", "VersionParsing"]
git-tree-sha1 = "6cdc8832ba11c7695f494c9d9a1c31e90959ce0f"
uuid = "8f4d0f93-b110-5947-807f-2305c1781a2d"
version = "1.6.0"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "13468f237353112a01b2d6b32f3d0f80219944aa"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.2"

[[Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8979e9802b4ac3d58c503a20f2824ad67f9074dd"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.34"

[[Preferences]]
deps = ["TOML"]
git-tree-sha1 = "2cf929d64681236a2e074ffafb8d568733d2e6af"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.3"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[PyCall]]
deps = ["Conda", "Dates", "Libdl", "LinearAlgebra", "MacroTools", "Serialization", "VersionParsing"]
git-tree-sha1 = "71fd4022ecd0c6d20180e23ff1b3e05a143959c2"
uuid = "438e738f-606a-5dbb-bf0a-cddfbfd45ab0"
version = "1.93.0"

[[PyPlot]]
deps = ["Colors", "LaTeXStrings", "PyCall", "Sockets", "Test", "VersionParsing"]
git-tree-sha1 = "14c1b795b9d764e1784713941e787e1384268103"
uuid = "d330b81b-6aea-500a-939a-2ce795aea3ee"
version = "2.10.0"

[[REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[Triangle_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bfdd9ef1004eb9d407af935a6f36a4e0af711369"
uuid = "5639c1d2-226c-5e70-8d55-b3095415a16a"
version = "1.6.1+0"

[[Triangulate]]
deps = ["DocStringExtensions", "Libdl", "Printf", "Test", "Triangle_jll"]
git-tree-sha1 = "0b011b75202d936d2f1af6215bf3b6cce26f2b7b"
uuid = "f7e6ffb2-c36d-4f8f-a77e-16e897189344"
version = "2.1.1"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[VersionParsing]]
git-tree-sha1 = "58d6e80b4ee071f5efd07fda82cb9fbe17200868"
uuid = "81def892-9a0e-5fdd-b105-ffc91e053289"
version = "1.3.0"

[[Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

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
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
