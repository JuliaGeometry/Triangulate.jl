module test_triangulate
using TriangleRaw

function test()
    triin=TriangleRaw.TriangulateIO()
    triin.pointlist=Matrix{Float64}([1.0 0.0 ; 0.0 1.0 ; -1.0 0.0 ; 0.0 -1.0]')
    triin.segmentlist=Matrix{Int32}([1 2 ; 2 3 ; 3 4 ; 4 1 ]')
    triin.segmentmarkerlist=Vector{Int32}([1, 2, 3, 4])
    triin.regionlist=Matrix{Float64}([0.5 0.5 1 0.01;]')

    (triout, vorout)=triangulate("paAqQ", triin)

    size(triout.pointlist,2)==177 && size(triout.trianglelist,2)==319 && size(triout.segmentlist,2)==33
end
end

