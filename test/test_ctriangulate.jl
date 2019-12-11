module test_ctriangulate
using TriangulateIO


function test()
    nodes=Matrix{Cdouble}([1.0 0.0 ; 0.0 1.0 ; -1.0 0.0 ; 0.0 -1.0]')
    faces=Matrix{Cint}([1 2 ; 2 3 ; 3 4 ; 4 1 ]')
    faceregions=Matrix{Cint}([1 2 3 4]')
    regionpoints=Matrix{Cdouble}([0.5 0.5 1 0.01;]')
    triin=TriangulateIO.CTriangulateIO()
    triout=TriangulateIO.CTriangulateIO()
    vorout=TriangulateIO.CTriangulateIO()
    
    triin.numberofpoints=Cint(size(nodes,2))
    triin.pointlist=pointer(nodes)
    triin.numberofsegments=size(faces,2)
    triin.segmentlist=pointer(faces)
    triin.segmentmarkerlist=pointer(faceregions)
    triin.numberofregions=size(regionpoints,2)
    triin.regionlist=pointer(regionpoints)
    
    triangulate("paAqQ",triin,triout,vorout)

    triout.numberofpoints==177 && triout.numberoftriangles==319 && triout.numberofsegments==33
end
end
