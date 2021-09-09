# thanks @tduretz
module test_o2

# Test correct handling of second order points

using Triangulate

function test()
    triin=Triangulate.TriangulateIO()
    triin.pointlist=Matrix{Cdouble}([0.0 0.0 ; 1.0 0.0 ; 1.0  1.0; 0.0 1.0]')
    triin.segmentlist=Matrix{Cint}([1 2 ; 2 3 ; 3 4 ; 4 1 ]')
    triin.segmentmarkerlist=Vector{Int32}([1, 2, 3, 4])


    # Test P1 element creation
    (triout, vorout)=triangulate("pqQ", triin)  
    test1=triout.pointlist==[0.0  1.0  1.0  0.0;
                             0.0  0.0  1.0  1.0]&&
    triout.trianglelist==[4  2;
                          1  3;
                          2  4]



    # Test P2 element creation
    (triout, vorout)=triangulate("pqo2Q", triin)  
    test2=triout.pointlist==[0.0  1.0  1.0  0.0  0.0  0.5  0.5  1.0  0.5;
                             0.0  0.0  1.0  1.0  0.5  0.0  0.5  0.5  1.0]&&
    triout.trianglelist==[4  2;
                          1  3;
                          2  4;
                          6  9;
                          7  7;
                          5  8]

    test1&&test2
end

end
