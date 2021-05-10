#
# Plotting routines.
#

"""
$(TYPEDSIGNATURES)

Heuristic check if Plotter is PyPlot
"""
ispyplot(Plotter)=typeof(Plotter)==Module&& isdefined(Plotter,:Gcf)

"""
$(TYPEDSIGNATURES)

Heuristic check if Plotter is Plots
"""
isplots(Plotter)=typeof(Plotter)==Module&& isdefined(Plotter,:gr)

# Plot color scale for grid colors.
function frgb(Plotter,i,max;pastel=false)
    x=Float64(i-1)/Float64(max)
    if (x<0.5)
        r=1.0-2.0*x
        g=2.0*x
        b=0.0
    else
        r=0.0
        g=2.0-2.0*x
        b=2.0*x-1.0
    end
    if pastel
        r=0.5+0.5*r
        g=0.5+0.5*g
        b=0.5+0.5*b
    end
    if ispyplot(Plotter)
        return (r,g,b)
    end
    if isplots(Plotter)
        return Plotter.RGB(r,g,b)
    end
end

"""
$(SIGNATURES)

Find the circumcenter of a triangle.                 
									 
Created from C source of Jonathan R Shewchuk <jrs@cs.cmu.edu>

Modified to return absolute coordinates.
"""
function tricircumcenter!(circumcenter,a,b,c)

    # Use coordinates relative to point `a' of the triangle.
    xba = b[1] - a[1]
    yba = b[2] - a[2]
    xca = c[1] - a[1]
    yca = c[2] - a[2]

    # Squares of lengths of the edges incident to `a'.
    balength = xba * xba + yba * yba
    calength = xca * xca + yca * yca
    
    # Calculate the denominator of the formulae.
    # if EXACT
    #    Use orient2d() from http://www.cs.cmu.edu/~quake/robust.html	 
    #    to ensure a correctly signed (and reasonably accurate) result, 
    #    avoiding any possibility of division by zero.		    
    #  denominator = 0.5 / orient2d((double*) b, (double*) c, (double*) a)
    
    
    # Take your chances with floating-point roundoff
    denominator = 0.5 / (xba * yca - yba * xca)

    # Calculate offset (from `a') of circumcenter. 
    xcirca = (yca * balength - yba * calength) * denominator  
    ycirca = (xba * calength - xca * balength) * denominator  


# The result is returned both in terms of x-y coordinates and xi-eta	 
# coordinates, relative to the triangle's point `a' (that is, `a' is	 
# the origin of both coordinate systems).	 Hence, the x-y coordinates	 
# returned are NOT absolute; one must add the coordinates of `a' to	 
# find the absolute coordinates of the circumcircle.  However, this means	 
# that the result is frequently more accurate than would be possible if	 
# absolute coordinates were returned, due to limited floating-point	 
# precision.  In general, the circumradius can be computed much more	 
# accurately.								 
    

    circumcenter[1] = xcirca+a[1]
    circumcenter[2] = ycirca+a[2]

    return circumcenter
end




"""
$(TYPEDSIGNATURES)

Plot contents of triangulateio structure.
The plot module (currently only PyPlot is possible, GLMakie may follow)
is passed as parameter.
This allows to keep the package free of heavy
plot package dependencies. 
"""
function plot(Plotter,
              tio::TriangulateIO;
              voronoi=nothing,
              aspect=1,
              circumcircles=false
              )
    
    if ispyplot(Plotter)
        PyPlot=Plotter
        ax = PyPlot.matplotlib.pyplot.gca()
        ax.set_aspect(aspect)
        if numberofpoints(tio)==0
            return
        end
        x=tio.pointlist[1,:]
        y=tio.pointlist[2,:]
        xminmax=extrema(x)
        yminmax=extrema(y)

        dx=xminmax[2]-xminmax[1]
        ax.set_xlim(xminmax[1]-dx/10,xminmax[2]+dx/10)
        dy=yminmax[2]-yminmax[1]
        ax.set_ylim(yminmax[1]-dy/10,yminmax[2]+dy/10)

        
        PyPlot.scatter(x,y, s=10,color="b")
        t=transpose(tio.trianglelist.-1)
        if size(tio.triangleattributelist,2)>0
            PyPlot.tripcolor(x,y,t,tio.triangleattributelist[1,:],cmap="Pastel2")
        end
        if numberoftriangles(tio)>0
            PyPlot.triplot(x,y,t,color="k")
            if circumcircles
                t=0:0.025*π:2π
                circle(x,y,r)=PyPlot.plot(x.+r.*cos.(t),y.+r.*sin.(t),color=(0.4,0.05,0.4), linewidth=0.3)	
                cc=zeros(2)
                for itri=1:numberoftriangles(tio)
                    
                    trinodes=tio.trianglelist[:,itri]
                    a=tio.pointlist[:,trinodes[1]]
                    b=tio.pointlist[:,trinodes[2]]
                    c=tio.pointlist[:,trinodes[3]]
                    tricircumcenter!(cc,a,b,c)
                    r=sqrt((cc[1]-a[1])^2+(cc[2]-a[2])^2)
                    circle(cc[1],cc[2],r)
                    PyPlot.scatter([cc[1]],[cc[2]], s=20,color=(0.4,0.05,0.4))
                end
            end
        end
        if numberofsegments(tio)>0
            lines=Any[]
            rgb=Any[]
            markermax=maximum(tio.segmentmarkerlist)
            # see https://gist.github.com/gizmaa/7214002
            for i=1:numberofsegments(tio)
                x1=tio.pointlist[1,tio.segmentlist[1,i]] 
                y1=tio.pointlist[2,tio.segmentlist[1,i]]
                x2=tio.pointlist[1,tio.segmentlist[2,i]]                 
                y2=tio.pointlist[2,tio.segmentlist[2,i]]
                push!(lines,collect(zip([x1,x2],[y1,y2])))
                push!(rgb,frgb(PyPlot,tio.segmentmarkerlist[i],markermax))
            end
            ax.add_collection(PyPlot.matplotlib.collections.LineCollection(lines,colors=rgb,linewidth=3))
        end

        if numberoftriangles(tio)==0 && numberofregions(tio)>0 
            x=tio.regionlist[1,:]
            y=tio.regionlist[2,:]
            r=tio.regionlist[3,:]
            PyPlot.scatter(x,y, s=20,c=r,cmap="Dark2")
        end
 
        if numberoftriangles(tio)==0 && numberofholes(tio)>0 
            x=tio.holelist[1,:]
            y=tio.holelist[2,:]
            PyPlot.scatter(x,y, s=20,color="k")
        end
 

        if voronoi!=nothing && numberofedges(voronoi)>0
            bcx=sum(x)/length(x)
            bcy=sum(y)/length(y)
            wx=maximum(abs.(x.-bcx))
            wy=maximum(abs.(y.-bcy))
            ww=max(wx,wy)
            
            x=voronoi.pointlist[1,:]
            y=voronoi.pointlist[2,:]
            PyPlot.scatter(x,y, s=10,color="g")
            for i=1:numberofedges(voronoi)
                i1=voronoi.edgelist[1,i]
                i2=voronoi.edgelist[2,i]
                if i1>0 && i2>0
                    PyPlot.plot([voronoi.pointlist[1,i1],voronoi.pointlist[1,i2]],
                                 [voronoi.pointlist[2,i1],voronoi.pointlist[2,i2]],
                                 color="g")
                else
                    x0=voronoi.pointlist[1,i1]
                    y0=voronoi.pointlist[2,i1]
                    xn=voronoi.normlist[1,i]
                    yn=voronoi.normlist[2,i]
                    normscale=1.0e10
                    if x0+normscale*xn>bcx+ww
                        normscale=abs((bcx+ww-x0)/xn)
                    end
                    if x0+normscale*xn<bcx-ww
                        normscale=abs((bcx-ww-x0)/xn)
                    end
                    if y0+normscale*yn>bcy+ww
                        normscale=abs((bcy+ww-y0)/yn)
                    end
                    if y0+normscale*yn<bcy-ww
                        normscale=abs((bcy-ww-y0)/yn)
                    end
                    PyPlot.plot([x0, x0+normscale*xn], [y0,y0+normscale*yn],color="g")
                end
                
            end
        end
    end
    
    ### Currently not working
    if isplots(Plotter)
        #=
        if p==nothing
            p=Plotter.plot()
        end
        for icell=1:num_cells(grid)
            rgb=frgb(Plotter,grid.cellregions[icell],num_cellregions(grid),pastel=true)
            coord1=nodecoord(grid,cellnode(grid,1,icell))
            coord2=nodecoord(grid,cellnode(grid,2,icell))
            coord3=nodecoord(grid,cellnode(grid,3,icell))
            # https://github.com/JuliaPlotter/Plotter.jl/issues/605    
            tri=Plotter.Shape([coord1[1],coord2[1], coord3[1]],[coord1[2],coord2[2],coord3[2]])
            Plotter.plot!(p,tri,color=rgb,label="")
        end
        for icell=1:num_cells(grid)
                coord1=nodecoord(grid,cellnode(grid,1,icell))
            coord2=nodecoord(grid,cellnode(grid,2,icell))
            coord3=nodecoord(grid,cellnode(grid,3,icell))
            Plotter.plot!(p, [coord1[1],coord2[1]],[coord1[2],coord2[2]]  ,linewidth=0.5,color=:black,label="")
            Plotter.plot!(p, [coord1[1],coord3[1]],[coord1[2],coord3[2]]  ,linewidth=0.5,color=:black,label="")
            Plotter.plot!(p, [coord2[1],coord3[1]],[coord2[2],coord3[2]]  ,linewidth=0.5,color=:black,label="")
        end
        for ibface=1:num_bfaces(grid)
            rgb=frgb(Plotter,grid.bfaceregions[ibface],num_bfaceregions(grid))
            coord1=nodecoord(grid,bfacenode(grid,1,ibface))
            coord2=nodecoord(grid,bfacenode(grid,2,ibface))
            Plotter.plot!(p,[coord1[1],coord2[1]],[coord1[2],coord2[2]]  ,linewidth=5,color=rgb,label="")
        end
        if show
            Plotter.gui(p)
        end
        return p
        =#
    end
end


"""
$(TYPEDSIGNATURES)

Plot  pair of triangulateio structures arranged 
in two subplots. This is intendd for visualizing both input
and output data.
"""
function plot_in_out(Plotter, triin, triout;voronoi=nothing, circumcircles=false,title="")
    if ispyplot(Plotter)
        PyPlot=Plotter
        PyPlot.clf()
        PyPlot.suptitle(title)
        PyPlot.subplot(121)
        PyPlot.title("In")
        Triangulate.plot(PyPlot,triin)
        PyPlot.subplot(122)
        PyPlot.title("Out")
        plot(PyPlot,triout,voronoi=voronoi,circumcircles=circumcircles)
        PyPlot.tight_layout()
    end
end
