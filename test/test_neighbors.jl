# thanks @tduretz
module test_neighbors

# Test correct handling of second order points

using Triangulate

function test()
    triin = Triangulate.TriangulateIO()
    triin.pointlist = Cdouble[0.0 0.0; 1.0 0.0; 1.0 1.0; 0.0 1.0]'
    triin.segmentlist = Cint[1 2; 2 3; 3 4; 4 1]'
    triin.segmentmarkerlist = Cint[1, 2, 3, 4]

    (triout, vorout) = triangulate("pqQn", triin)
    test1 = triout.pointlist == [
        0.0 1.0 1.0 0.0;
        0.0 0.0 1.0 1.0
    ]

    test1 = test1 && triout.trianglelist == [
        4 2;
        1 3;
        2 4
    ]

    test2 = triout.neighborlist == [
        -1 -1;
        2 1;
        -1 -1
    ]
    return test1 && test2
end

end
