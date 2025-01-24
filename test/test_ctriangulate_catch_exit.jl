module test_ctriangulate_catch_exit
using Triangulate

function test()
    nodes = Matrix{Cdouble}([1.0 0.0; 0.0 1.0])
    triin = Triangulate.CTriangulateIO()
    triout = Triangulate.CTriangulateIO()
    vorout = Triangulate.CTriangulateIO()

    triin.numberofpoints = Cint(size(nodes, 2))
    triin.pointlist = pointer(nodes)
    rc = triangulate("Q", triin, triout, vorout)
    return rc == 1
end
end
