module test_pointattributelist
using Triangulate
function test()
    x = [1.9 1.2 1.5 1.6 1.3 1.9 1.2 1.4 1.1 1.0]
    y = [1.5 1.4 1.7 1.2 1.3 1.9 2.0 1.9 1.5 1.0]
    z = [1.7 1.0 1.1 1.6 2.0 1.8 1.7 1.8 1.7 1.5]

    pointset = Triangulate.TriangulateIO(; pointlist = [x; y])
    pointset.pointattributelist = z
    triout, vorout = Triangulate.triangulate("Q", pointset)

    test1 = triout.trianglelist == [10 5 7 2 2 9 2 4 8 8 6 8 3;
                                    5 10 9 9 3 7 5 1 3 9 3 6 5;
                                    2 4 8 10 9 10 3 3 6 3 1 7 4]
    test2 = triout.pointattributelist == z

    triout, vorout = Triangulate.triangulate("Qa0.05", pointset)

    test3 = isapprox(triout.pointattributelist,
                     [1.7 1.0 1.1 1.6 2.0 1.8 1.7 1.8 1.7 1.5 1.6 1.72149 1.55 1.42347 1.13548 1.50625];
                     atol = 1.0e-5)

    test4 = triout.trianglelist == [13 5 7 2 12 9 14 9 16 2 3 12 6 8 9 14 5 7 1 15 3 8 14;
             2 13 12 9 9 11 15 7 14 13 16 3 16 6 2 3 4 9 14 2 12 16 16;
             10 4 8 10 15 10 5 11 1 5 8 8 1 7 15 15 14 12 4 5 15 6 3]
    test1 & test2 & test3 & test4
end
end
