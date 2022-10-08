using Test

modname(fname)=splitext(basename(fname))[1]

#
# Include all Julia files in `testdir` whose name starts with `prefix`,
# Each file `prefixModName.jl` must contain a module named
# `prefixModName` which has a method test() returning true
# or false depending on success.
#
function run_tests_from_directory(testdir,prefix)
    @testset "all tests" begin
        println("Directory $(testdir):")
        examples=modname.(readdir(testdir))
        for example in examples
            if example[1:length(prefix)]==prefix
                println("  $(example):")
                path=joinpath(testdir,"$(example).jl")
                @eval begin
                    include($path)
                    # Compile + run test
                    print("   compile:")
                    @time @test eval(Meta.parse("$($example).test()"))
                    # Second run: pure execution time.
                    print("       run:")
                    @time eval(Meta.parse("$($example).test()"))
                end
            end
        end
    end
end


@time begin
    run_tests_from_directory(@__DIR__,"test_")
end

