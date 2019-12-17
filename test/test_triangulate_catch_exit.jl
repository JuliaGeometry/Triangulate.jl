module test_triangulate_catch_exit
using Triangulate

function test()
    triin=Triangulate.TriangulateIO()
    triin.pointlist=Matrix{Float64}([1.0 0.0 ; 0.0 1.0 ;])
    try
        (triout, vorout)=triangulate("Q", triin)
    catch err
        if typeof(err)==TriangulateError
            println("Catched TriangulateError")
            return true
        end
    end
    return false
end
end

