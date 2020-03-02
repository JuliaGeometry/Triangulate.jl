module test_triangulate2
using Triangulate

function test()
    #     *
    #     |
    #  *--*--*

    triin = Triangulate.TriangulateIO(
        pointlist = Float64[0.0 1.0 2.0 1.0
                            0.0 0.0 0.0 1.0],
        segmentlist = Int32[1 2 2
                            2 3 4],
        # don't give segmentmarkerlist !
    )

    (triout, vorout) = triangulate("pcDQ", triin)

    return all([
        size(triout.pointlist, 2) == 4,
        size(triout.trianglelist, 2) == 2,
        size(triout.segmentlist, 2) == 5,
    ])
end

end
